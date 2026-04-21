Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 380F0F327AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DF996B00A2; Tue, 21 Apr 2026 02:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8909A6B00A3; Tue, 21 Apr 2026 02:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F2F6B00A4; Tue, 21 Apr 2026 02:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 60C2E6B00A2
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:29:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05AF7160CC9
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:29:26 +0000 (UTC)
X-FDA: 84681586332.25.7BC7EC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C9BE1C0004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:29:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OhEYI6eO;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776752964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CY+CAN7bHLfKN7GZH5mzdKp7O2UV70GqpD0qinzZqk=;
	b=X3/rrz13O7fhwzBTgYWpGCQdnK6J/OCI+DIx/+0tBNDakm6bCqtjyB3oGG8Ho6FUwBeeBP
	LkI9RP2EwJQt2c/9taecQFl58YXPFvDD6Va0rT44L1ScdzIzExTkdl4lOe5pyDHNI4DAfS
	28QHax9UX9OXoKWZEGD/IiZKZplG9rs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OhEYI6eO;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776752964; a=rsa-sha256;
	cv=none;
	b=wiVdTLDYm6dz6vU4a01A2U/yw/IykqCOnE6RiLGQDJSKHP/XKmihr1DTK0OLgDKWnZhPlw
	ZoOK49VPLvXvljaATlAR6x5KixCr2yXX6FHtAFcTeu7F7CE8Xf99AT6zm2IAsAYucEAE63
	2mRqikP9HYmwvVR+oyIit25xJGyG/mI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31DA1443A0;
	Tue, 21 Apr 2026 06:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0931C2BCB0;
	Tue, 21 Apr 2026 06:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776752963;
	bh=99LEZojT7pft8o8FMe7NKGJK2eyZsz4DnlCV6RI9vyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OhEYI6eOjzLMVTpBUMc6V2EolP/jAuhojRfnyLjJoIYYyzJiWjWXX36/RLXUslYOd
	 YTuJZ6lKQgWGKAjsuqoVU7eQQoUg4vZhI+MAnuqusMrwy1vE74KeSqIY72QmPuctYp
	 nrU1d+XY/tm1BicogkivFEqYOpw8xtFYffn+RJfOgxxogiqCElg3ZnaBiwUbuK/VEL
	 VlHL5lbRsW2JUp0a8wEn/hRELPcv+koJjY7d0Bfcdjtf8I/nt5otijl1bz1MdKCbkC
	 ozXqmfHGZd/hVjmPXCghC+oZj72/Uke3GH/AUEJ8uSaG06o2yBkXEG8lqs5nM93msm
	 kITseR2zVcgbw==
Date: Tue, 21 Apr 2026 09:29:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org,
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>
Subject: Re: [PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
Message-ID: <aecZPdGyF5i1baee@kernel.org>
References: <20260417135805.1758378-1-ekffu200098@gmail.com>
 <aeXIKM9BeRmaCZ_d@kernel.org>
 <CABFDxMHT0W-FFuLJwiWMqXueXZvz-2wSsZyRPKJ6ki6FhVPLnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABFDxMHT0W-FFuLJwiWMqXueXZvz-2wSsZyRPKJ6ki6FhVPLnA@mail.gmail.com>
X-Stat-Signature: 4eiremr6zyenpwm3nkhn83tno4ct4rjq
X-Rspamd-Queue-Id: 4C9BE1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776752964-542521
X-HE-Meta: U2FsdGVkX1/9PRh/qK/lCbYlAA1R84R46NSfgWgP/OCs43LlEbGDsknqJYLvccoUdXSBBn5P3KocRLfS5ARJtljKH11oqKJrDVf6nGGWPhL9q4zyxQlrjJIisuG37NObFCQQye7md/+lGstigIEck93hc2r8jFGXlqiRm1A+zoDvsRECrU/Q11wc2Shi2/bsBMAftiihJc/4MTnoWm0FyAFFNzF38t8FtNSm+O/6TbZYFet5uzko3LTeo/06DLygMuD43GHyyWbk+iSz0EK9tAznaeAKbuBZKBsMTrDgnNb3puhTQSX7W3oT7+d/p8r0plxvfHRvqrju4PwVzJ2zCSYl14b59U5u6ZeBpzhoie8zfnLawI+rWFopCc6IJVGefpBv/lhYS0dRH4w4AppHhsIxmq6BKTyzdLfRYtgA/fO2h/KXlGoa9f1Dyv3mEHRzm71n0sHcdz/jADJhJtjv4gLZwM3rlUPC1nMRr5s7E8kyb/+cFGzixLbfsKV+uK6UdEh436Dw3Om1G6m9XrxEyi+2PhgETCk8pogieAcwCHEc2Ky0YVEjiktymDDicQxxAy+OjQFzsuUXuAi4SyeIDHhiTcA0xLQtOAGyNlSghRmCX/Whd33Ve1D12k9g54iLKgAXGdoKBlHL/CLFDx0dM2XGken9j/hpCOkldzjqUjXUgXk2tThadAlRcYCBhXyYsYz4eYte7kmsTfyGpijGm8haGwyGhOIdlAKMLhsEMV9jW5beLZMnvOOyNQ9P7IX6tpd6sjYh4tC8JatSEUNloL7kPggF+a8xwMBmrNlhZZoPNIvuHf4rVh2jBdyUXB6Z0KKf6IqCJNS6AorWcUS4t5UQrCDVbN2lZuItC3CXcW7mtoQXLCML8pWbzPL1c0PBAyQsLcQP0TbGonLhLw5mFrc6htVYV3L4+oPj5hMe7j/xp98Hwtpr9+1y4085F95O6JAQeIBjcG1xDUmXxzM
 MaWhlcsw
 NxzRh/bH/SS8kIkFVs6s/6P3ZrwPdg4jthQ2ZXpIbSzcp1vGsCRbAbKlPTKCTSptvs0hyTNhpSbxZOQSwsVQjok0tAub0MGkFgaYphmJA43XjP9qspMkmDN0adcQ8a1BTT26fUOk7b6wOoPLAXmdXl92br78geCZw+GN7sxY90C34Zj/JLemVL/4RfStZCtKr9Od9kW7yuuL22z4uWI/LqnjHK03oEhWhLXB0GPcLwIacvpo5uvUpihh3S7G2TCi/gYGmDOSySGcK4OxJQ44kqZns9+E9L9hdv1gzsacxBFP1R9U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 11:26:13PM +0900, Sang-Heon Jeon wrote:
> On Mon, Apr 20, 2026 at 3:31 PM Mike Rapoport <rppt@kernel.org> wrote:
> > On Fri, Apr 17, 2026 at 10:58:05PM +0900, Sang-Heon Jeon wrote:
> > > When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> > > returns the next absolute node ID, not the number of nodes created.
> > >
> > > The existing under-allocation detection logic compares next absolute node
> > > ID (ret) and request count (n), which only works when nid starts at 0.
> > >
> > > For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> > > 1: 128MB) and numa=fake=8U, 8 fake nodes are successfully created from
> > > node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> > > fake node nid starts at 8, but only 4 fake nodes are created due to
> > > current FAKE_NODE_MIN_SIZE being 32MB, and
> > > split_nodes_size_interleave_uniform() returns 12. By existing
> > > under-allocation detection logic, "ret < n" (12 < 8) is false, so the
> >
> > In this example it would be 11, won't it?
> > I'll update when applying.
> 
> Oops, my previous reply is not the main point of this review. (Please ignore it)
> But 12 is still correct, because split_nodes_size_interleave_uniform()
> returns next available node ID.
> 
> IMHO, it would be clearer if both the commit message and the function
> comment change into "next available node ID".
> If you're okay with it, I'll create v3 patch soon, including minor fix below

No need for v3, I updated the comment and the whitespace:
https://git.kernel.org/rppt/memblock/c/a34436ac05e76bd6634a89fc0a399ab3a48f509a
 
> Best Regards,
> Sang-Heon Jeon

-- 
Sincerely yours,
Mike.

