Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF55BC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51CA6B00F2; Thu, 16 Jul 2026 11:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03196B014F; Thu, 16 Jul 2026 11:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA866B0151; Thu, 16 Jul 2026 11:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EC716B00F2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:13:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC9521C0143
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:13:21 +0000 (UTC)
X-FDA: 84994983402.28.2478482
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 44E4E18000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:13:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KsI1yLU7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784214800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZcIKy0sKnwiVTiIn1xnQqul/iC9zSIy0vEYFOh5eLM=;
	b=VCUO7LXJZxcpmxZMV9lXWUCftnTUL5p0IPoOTA7XrszIszmUBCENnroWivta7WQJnWaWtF
	TehlqyQcfgfc/YbRtsruqVLXxUuVEla0CubAlnQikxp/vV7IZjbuebi9cvBKOkLDakpMMY
	8tzmDFaUmpYaCpoN+twSDe8uOsAFHfI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KsI1yLU7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784214800;
	b=5tQHgh6zgFHEhJecppJ0YveO5kXr9s069y8eU2kpE+ZhJosqTjw89r9KYFgHwHpLBLWQAA
	UE3Slj1YatVrPoRcr74drRKNW4TSm/GbaOTPEvGvqJGk52fwXhzOo6mug4ttCrDqsIEX+3
	UIdyPvp//rAXR99/afa803NCv+6fRb8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 617A140E4E;
	Thu, 16 Jul 2026 15:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082A81F000E9;
	Thu, 16 Jul 2026 15:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784214799;
	bh=mZcIKy0sKnwiVTiIn1xnQqul/iC9zSIy0vEYFOh5eLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KsI1yLU77HcEbaUDL1hSrDTf3zwMw/qpIqrIgSG/O9oRVSo8fW4BNS4MCTWT7fXas
	 J8kZj/b638mvvaWJyB/d7e5QR071mfNahmSxOgjSpAr5/BzAnSvHZxczE++LMgDY74
	 TBGjqLDh6CK2v0FTHngXee55oEV7bNAL/xar5n5aoRdqnl7OIvaOYbz5BZGocLcpXP
	 zkoDEmRL5ACkAj9tkUS4AhG/dP1DZlr5RtrDtf3WP/ko3hh1wWugvKyoCHv94sDrNr
	 bRbAOWkOsnKjR2VDpBWelHdNVxsv6Kw1gzLzkE6grf3+lUq9dAjIUSoxyb/ngAGHpm
	 bf91edPL2OBkQ==
Date: Thu, 16 Jul 2026 16:13:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/mseal: remove further superfluous comments,
 do_mseal()
Message-ID: <alj02XcxXC6kQGnK@lucifer>
References: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
 <20260716-mseal-fixups-v1-3-3a9609bf041b@kernel.org>
 <aljzdCwWzyvTDgmv@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aljzdCwWzyvTDgmv@pedro-suse.lan>
X-Stat-Signature: 64ufgk96bicqwxd414nbr14qfkr7tmbj
X-Rspamd-Queue-Id: 44E4E18000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784214800-542721
X-HE-Meta: U2FsdGVkX18oEV/rGwhwcF0ByKyxPHiabf4XtLCK0QarrHqfcfe+UE1Jkg/b7GKrifzrsBrcjLC0yNHiEgDLDiGE7TywmGVkZxGgKTQ4gig6mOBKfTcoKu76SaKDWMzWHtQztqTAritxw42nf1zjONxcGdEQiL0ysUPKvJK0yXIbVOAljf5CxZklBwumPMeQk5Zh5p95NX9iBZMxLMEDShfrTmwc3CIH5EGCV/y+djJVGnycbsn3cXr12mugo+UVuNvt6W5F7OLOIUG/8doRX5yK31mBwXzEO5rgMTwdO2AZtpJEtGlB7mFcJ3xkBtAVruU6Ke+RwOyErxjljVqeggq8/SWn93is+qjzg2bPea9PT7/6golOIwVZo2AbuqhqY6+q2AnbnGaaTIzM/KyM2p1/IUpPpn/4cZ3B6jDcZ3dhsual4ougteGSxix6hrqRKtlLCwxEd/jO+DNX1jNqMQNPNs+9m7ozC/E1SXRIHBICLDR817+ADHlMhuu/RD6tCvhsIko4Wfdfl+G/JgKMb0Fd9ySR/A9EvuAxfvBHVprBbNIN+AGM2Ladfpoh7qQRJQmFzFLwHfyqlQ5V98S8aj6cdGXyQsdk4CXHq5v8ftRhDex+golQ6UNepY2JmOuAU/HmkQ+8rQYWS8fBV0SwdBXds0yrPUDzvm1cWKUSwVfj3zqTpW570CQTBfiXDFVghdRRp6KTEP6zjPewI4wQc48pB/gSkZkpfPyaR3LS2g+wOOGI2SEGOG3MnpQ7Dji+4u6E1bIh+OXce7JItgcv4jT5z9sKDUKvt8urNsDMdYFD1sfAXersE+zMRvWAYrY3/4tnFfAD0rdrbe4EcsWvlvnIm++vAlLl92mFeEbzcbW6F46kbhogRYYGxAxONpzgjRJ+7QJP84GvExWNTjPwxMlbWHd4S/RUZOolF5Uw25bDkl8567vnz9ewkZ8k8iHlMR/JJ74xzWYzW3rCT/0
 kEYASeW9
 nV0mgRwzvt9RhfFfpCBTvDYLUQ0bUHtEmyUk56fhsGalSHQKhBxVEmtZAQB9Fnsu6iVoaHxXmA9DHoM4/Azc7wyoVxAABtaMk1J28plrrYWdQE+lW56yFE7kB3dgbjfUWx0iR7pUItBYahP6FCdwKA3hQlOh6jLlsrNSiLJ430FOOnv+SJB4JdKDP5VsMqwQ0JKmoC0BJK6PM9CdXrHsLpKhh70j6fNe8yrmWjbi4BcEYvrnCTZrdAop6XYJUfgQ/FJ/5cIPMYTP5b2mL6jdwoItj08FhP85oQF8ZDCYQSDpdTpfuC1dsp5g0PkgbEbcrHBNQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 04:09:14PM +0100, Pedro Falcato wrote:
> On Thu, Jul 16, 2026 at 02:43:11PM +0100, Lorenzo Stoakes (ARM) wrote:
> > There's no need to abstract do_mseal() any longer so put the system call
> > implementation in the system call declaration.
>
> This looks great!
>
> >
> > The comment around do_mseal() is strangely formatted, overly long and adds
> > a lot of superfluous information that the code already provides, so boil it
> > down to the essentials.
>
> But I would much rather we delete the whole comment (like Leon's patch did,
> per my request). Do you disagree?

I would like us to retain the information I added yes. Removing that is not
really helpful I don't think.

>
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Anyway,
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
> --
> Pedro

Cheers, Lorenzo

