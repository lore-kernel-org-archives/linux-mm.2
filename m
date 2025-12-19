Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9636D7495D
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02B1F6B0088; Fri, 19 Dec 2025 01:46:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D6D6B0089; Fri, 19 Dec 2025 01:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D1A6B008A; Fri, 19 Dec 2025 01:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDDD06B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:46:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9428F1A0476
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:46:20 +0000 (UTC)
X-FDA: 84235286520.24.4EEB0C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id EB5354000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:46:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jsMVxo1i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766126779; a=rsa-sha256;
	cv=none;
	b=tjvQCoBXiWS0DYuQLFnnYN3Ee00tg6PjWmrDEpU8qEVcCEkYXoYk140Ay7gEw/k9KDIPN/
	lxJpA2kF8x5EzvXybAFZUj0oSa0n7zDTbeIu+0/QaJaA/Ya3rvyb2p8ji2fy4rBBd7fMwz
	Tnl1EpW2+oSSGmbAkeMz5c1DuyJPzC0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jsMVxo1i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766126779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kbKkbECJGYSYNBKg2CTk2JoGUnf3Md2EF7oYfClxvgQ=;
	b=7zoBNtqf50AR7Z6EE44/+yMO4tkRTqeF2WOFUZIT85Gk6VptLuJsT5+Aeh/QTIwffQPVw8
	FQBZ1rlooMZsGgoK9yEtpj7hB2qd8EbuEkIW+iUfdMt0ZIn80oUMgDFrsgHicyrq7nyiEj
	S7MYE0H5nxOAMNKlr+eh4OskKQoIUJU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6E4540E3D;
	Fri, 19 Dec 2025 06:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDD3C4CEF1;
	Fri, 19 Dec 2025 06:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766126777;
	bh=GCtvC7JQ0sW45JFNIzTHFaQFaunZxr+uykDzvh97kGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jsMVxo1i4HZyEIFV7s7muMvbrYA1u4urWTJy/arP8omdTOVw3SZtZR/hvldWPHBiP
	 R5R4AF2JueetEmMspogbZDMmog1r/MkpmXAQ4GLsbORnw79EhcW5kDAEU1JtB0oTCX
	 XKS2Xy2mjBrRLpEfgrKfic5rLst27vfBT0VXefL+CZp/v2nJlWXg9++3xKgFNIpRPe
	 zROYBcO2ZdINdHza/Sk9mBS3+87JXsUEHCWPlANrDPA/r6mjQJHsgs+NlQKso53RKU
	 hr2MM0mHvhZLSCbQ1UAhGfBf7HxhpASl6j9gujFMYZ+F7GD98AGh30Ekb4OTLIdrs4
	 HLKHh29bGv8mw==
Date: Fri, 19 Dec 2025 08:46:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org,
	dmatlack@google.com, skhawaja@google.com, rientjes@google.com,
	corbet@lwn.net, kees@kernel.org, davidgow@google.com,
	pmladek@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	nicolas.frattaroli@collabora.com, linux-doc@vger.kernel.org,
	tamird@gmail.com, raemoar63@gmail.com, graf@amazon.com
Subject: Re: [PATCH v2 0/5] list private v2 & luo flb v9
Message-ID: <aUT0sJsDWZHGT-Q9@kernel.org>
References: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
 <20251218130725.1b93a521c039ce121de62472@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218130725.1b93a521c039ce121de62472@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: EB5354000A
X-Rspamd-Server: rspam10
X-Stat-Signature: xxhob68seqjcf7didg6p19g5qjmouhu4
X-HE-Tag: 1766126778-325203
X-HE-Meta: U2FsdGVkX18P3nLRWh7LMAoVQy14f4eEZErh8SL+sn2bmqO9va3vAMLOr1mSJGLWcJTgPZbg0Mz4fDKhdT9nPcxdKwMlzHN7GB2lMUJ95+SB7Fhr3aauYEdCye5kAs4Eypg5ZD4x76rSzgovjfjM2Gkas+xHt+yDLzsW3WsdyO6u1tlGwaVP5AtWgmsKiHnC6oQNqHkErTPBnRTG5GzbztNi8+Uilphg6a2JZP0IQgatpaj91+cbM9LNO9mXHYo8DT/6oQdHZ1WR1nnz1HpNagRdozGW00n2iOceXH9J0DeER9kP/dr9iVRJV62tQQ+Y0ZNOoirhSHkOfclCmTlgu1wVTuC7mDxz+ka7Sw/lVHWVoiOLel3/z1jVVuaDUOfC+kmKt2uoIcVpG6L6ElzD+KQh2pDIq7e2gmgmE6k6UYQIJNqU6FAFM3i7s/HmCZBapaKx/uLA/b2BdkaOTkPz+jP21mku7sDuzmGQnwsIp6AqVxTeF3KugtKALsJEjwr1v8j1xy00DbgjX95XagNJwFOySfuQW+8pnvjooshyeNSyfzSTObw30W82frjlteO/Uuty2/UyXB1jMsGVB7o1CFbxzkHVPDL5fZLsLXW0Xh+pXKoI/FEyx/JjxglMDsjtFoRSOwq02JEceOBehMynbfvujTRDH4o9XeFRI6o2RVHxoxoKePqQ26x3uUCpiiYPz/drib4YnWzqeAiGsse68lCvzZQT1wa8CSCgU+F0icQnlFvQT0hwCrKjm++J7gh4DMwnMJnLP++FOvHcDPPrZ+/t3Ke1ZhAp9r5Go57rt4aUYUw8HQQp4SzIoq/aej9rduQaL1Qf/t8HMptmTau5LDewD8jmIifKMZ7x9sEPEbYjH8HKJuyp/gfbFKd5TRbTno9w5L6ZBYVD+ogRRDO+yPHZNZSXB87+NaQNOzeFi8EnyXY27NCJra8Ns91Tc/vgheGF0E+32CjzRkBTupp
 9/XrRVCt
 ivqFFO29KndMb56PT01VMsi/h5c8TtWZ9jq6pDv7l/0+Wj+i5JRz/mPMlQgbf+2hqRQnDXz7yQJnAlFcd7Pqr7+r7MHi4yHkiliU0E9opAgVeWpvLjLgLMCYyVHtXBnO2eqpljbY38Hp6NmFdfWoMz8EmWmK99HFRFBpbttWO1HI9QZaYZuX9AVWlGEEtEKlqF460DMa3Au2SyO3QXFTZ6B42fWaXaR+aCX75rX38AiZJQs8dnRB7HCfQIs9TIEV9aa8Hwe4ZbGWmO8egoCQSn9RUV/HB5XsxsHg5MMrbjitCVgAittJ4wkzmPCYXZ39GvJdtEKzpU5XCrrlUJtOoq2AMWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 01:07:25PM -0800, Andrew Morton wrote:
> On Thu, 18 Dec 2025 10:57:47 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> 
> > This series includes two separate workstreams. This is because FLB
> > should be applied on top of list_private, as it uses some of its
> > interfaces.
> > 
> > 1. List private v2 (first 3 patches) Previous version:
> > https://lore.kernel.org/all/20251126185725.4164769-1-pasha.tatashin@soleen.com
> > For details, please read the cover letter from the previous submission.
> > 
> > v2 Changelog:
> > - Added a Reviewed-by from David Gow.
> > 
> > 2. LUO FLB v9 (last 2 patches) Previous version:
> > https://lore.kernel.org/all/20251125225006.3722394-2-pasha.tatashin@soleen.com
> 
> Please, no.
> 
> This patch series is intended for the Linux kernel.  Your grandchildren
> will read the above wondering "what did granddad do".  It's just lazy
> for us to expect readers to have to chase down links to earlier
> versions and then to figure out what changed and why we changed it,
> etc, etc.
> 
> Let's give our audience a nice, self-contained and complete description
> of the proposed changes which doesn't refer them to the minute details
> of the ongoing development process.  A process which is utterly
> uninteresting three years from now.
> 
> IOW, can we please have a complete and standalone description of *this
> patchset* which doesn't refer to earlier obsolete stuff?

And I would even say this should be two patchsets, one with private list
and the other one with FLB.
 
> Thanks.

-- 
Sincerely yours,
Mike.

