Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAE0BE99076
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4164F6B009E; Fri, 10 Apr 2026 06:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C68E6B009F; Fri, 10 Apr 2026 06:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCF86B00A0; Fri, 10 Apr 2026 06:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9CB6B009E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:43:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B616C13A4D0
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:43:41 +0000 (UTC)
X-FDA: 84642310242.07.C782ABE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 918CE40003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:43:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LrxZkLyP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DVOXQXV8;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LrxZkLyP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DVOXQXV8;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbRrRbvEHMBhZEljaSGGSYpGNi0eJbZpub28rmgSAjg=;
	b=AqvYW240MKHy3jt26x21orFCk9E1iGQH1VpmPqJG/4BUi1HtRdCFrtW3hDt/3hMKB6LUIZ
	KRHSyKYyA1wiXrLI3oMO8KHg4Hj2b9HVE6EUw/ThvMEzEYXbbFdCiV0Aving4/ZDU2e/Qe
	KlnANToMaC8f9bcd7aqCxRFnxP/4+p4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817819; a=rsa-sha256;
	cv=none;
	b=4QFcAHpO4+yEZio9fJgdIKQjrYL6svQ13Ymztoto0cyr010Z0AfTc33prP3g5vlHLlHx4m
	TB72O6avJl6ru0CDewtlBpzO4wR33BhdHijgdFyB/97lBH9mfC8jW9FzX8tpv4CXCJ+Hye
	v8x/Bt37gKY2AT80QHgq4c7esJd9l64=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LrxZkLyP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DVOXQXV8;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LrxZkLyP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DVOXQXV8;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 060CA6A7EC;
	Fri, 10 Apr 2026 10:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775817818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fbRrRbvEHMBhZEljaSGGSYpGNi0eJbZpub28rmgSAjg=;
	b=LrxZkLyPSx4lyRDVj4hlCbBOOKS29D5bPMXt81xmXxFU2flsXeu9IMCGIk/KsCYlH6oMeI
	e5980ENvbGJTuzknMd3IXYRI2pfC4/a2Dst12WDFfJLpcs9eLwhrMplcr86Hj2wXlxTcUI
	NVsOpHvpGiKzqDY5rJcqlXU3Brs1lWw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775817818;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fbRrRbvEHMBhZEljaSGGSYpGNi0eJbZpub28rmgSAjg=;
	b=DVOXQXV8JX8vi+MHLSIhDWJi+/5T/ubGPeIB5TQvn+3zV4SewFf7LSJ2O6TJv1Cn2T4eVz
	qo/aim37j873CICg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775817818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fbRrRbvEHMBhZEljaSGGSYpGNi0eJbZpub28rmgSAjg=;
	b=LrxZkLyPSx4lyRDVj4hlCbBOOKS29D5bPMXt81xmXxFU2flsXeu9IMCGIk/KsCYlH6oMeI
	e5980ENvbGJTuzknMd3IXYRI2pfC4/a2Dst12WDFfJLpcs9eLwhrMplcr86Hj2wXlxTcUI
	NVsOpHvpGiKzqDY5rJcqlXU3Brs1lWw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775817818;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fbRrRbvEHMBhZEljaSGGSYpGNi0eJbZpub28rmgSAjg=;
	b=DVOXQXV8JX8vi+MHLSIhDWJi+/5T/ubGPeIB5TQvn+3zV4SewFf7LSJ2O6TJv1Cn2T4eVz
	qo/aim37j873CICg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F2A904A0B2;
	Fri, 10 Apr 2026 10:43:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4l3wN1jU2Gn5CAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 10 Apr 2026 10:43:36 +0000
Date: Fri, 10 Apr 2026 11:43:35 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Haakon Bugge <haakon.bugge@oracle.com>
Cc: Joseph Salisbury <joseph.salisbury@oracle.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [External] : Re: [RFC] mm: stress-ng --mremap triggers severe
 lruvec lock contention in populate/unmap paths
Message-ID: <dm7exlrnce6qxvsqh2zkhbn23b6mme3u3pygcfoqwk74ysbnct@yqm72zxw4xux>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <k2ldf7rk6mogzhoe3r7a2hpcc62x2uqqpnwk3czbet4shpirs5@sqfzsqpdc3fk>
 <639f20f3-9e65-4117-af9b-e37af0829847@kernel.org>
 <ebbd4c39-859f-4a10-a9e2-c0e9cd1013a9@oracle.com>
 <F72E050D-BAA4-4D5B-AFDC-5F8A20D8A70E@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F72E050D-BAA4-4D5B-AFDC-5F8A20D8A70E@oracle.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 81oimexqko9decxkkeainrga9d96cw7z
X-Rspamd-Queue-Id: 918CE40003
X-Rspam-User: 
X-HE-Tag: 1775817819-367361
X-HE-Meta: U2FsdGVkX1+aQAUszm6OG398YuMBTlEa7MQvSHV7zBA2geT/s8KTOUK3UqqT+xybQ3a6uRlui+9DGvwTCLhOpAU3MOPwERj1botPyxN99E+2r1sBDATTjsvZFYHLhg5YYG+qlVc2QkflaGITXarhcLauOVFktJd92X3xB7Wampzv7c/WvAox4Qm3Qoxf+cMyshYHqNg4SJwKMdnGHc798lE3kgIhZbQujZ38rbOdsvKc6ikBe5j5aeafwQYLA2dBjUYk9QkzFJLax00VdY8rmvSu438OOW/z4WFWn3WeKeCD9z9PK2rLq+tg1hFXFXATm4qqAh/i4GHD5DG9gQhpPqKq7Xghh0ionOg6xINf+N5EBMPgaeYObNFybVOlrLm2l0QuvApMKp92XINl370gpGDy4s1aU1+IjiCbgbXgswtyX2ojihdfvOV7SerVBHbd/WSCjYHDjo+yO1CoKXNuhT3LV8csNV5Mind370kqQDf+izqgyOOmHGY7e5znR7I30vUUGARG4m1pwa9wizvGVaguuSUeUUKZJNmBCc1k8nxk841mtvQz6DEWIg+JZ1JLoJI2Tm4b1IJChtnpH8SQyootaVBgGDfG5CQoC1NJ3LQqZXXtdXAofaeJawuymaAwZHKQ/5nq6muk4Q6gEudj7mBhKJttRfl3jfM6QnDOihGGWtJqAa0/28quadOMQTo/dVsbnJ6t+IMP5UdBGeRScpTocT2Nn44q0lSNEtpAwWsDfCilP0dUU/4crUVZDlucMbCI81NvWSaw+UH3ChOX5r+fuCMhGyIPRxlNSMsLRPxE0Dw+hWZ5uvYt0aYb6VHRMz1dq76op0lYdgd+SLEBAdwWV/VmRuqvXCupm5q5henJBI1IviEDQy1LQnQ131YC9l8UvdoUA+aPnydL7hD9pnI1A7AUQKE6hlVIKr8gP5DiZxU7X2AgOjWJgnU6UTHthLOYs2iZ5+AQnmdHODq
 /dYo3HK/
 B9GHZRE8hAZVs5uI6aHVLe2oXe6ssXwiDQDsR/jFprzjlLbTArm6Jrtar2oNDlE0S1VRUOvjwV3wVQPAMblEQFcjThuer+uAqg/N/yJ9z5G/0GgQwaA6KSBKnwHXlvE3KL+Y+isy+PKiSiNPF4dDP3rtcpaVbA/EK5L90X/MCPeus7fLFJbjzWG83vuKx+Sp/MYCrtMShlNuEZlkg1K9/v1tua8tOL9yRveBSGwQREH6r4kFXa4LLPpEAPue7ndc5w0c+0w4ihQA3VIM4xNqs6gCSnV0/Q/3wqTQMXTiGnFzP/Js0uQP5rcGMjfh42LUaz8G0ySLKhGVvrlDQqZfKJWJ/RAMx8Sfia9Yo4bRvZdVCOBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Jens

On Thu, Apr 09, 2026 at 04:37:19PM +0000, Haakon Bugge wrote:
> 
> > On 8 Apr 2026, at 16:27, Joseph Salisbury <joseph.salisbury@oracle.com> wrote:
> > 
> > 
> > 
> > On 4/8/26 4:09 AM, David Hildenbrand (Arm) wrote:
> >>>> It was also found that adding '--mremap-numa' changes the behavior
> >>>> substantially:
> >>> "assign memory mapped pages to randomly selected NUMA nodes. This is
> >>> disabled for systems that do not support NUMA."
> >>> 
> >>> so this is just sharding your lock contention across your NUMA nodes (you
> >>> have an lruvec per node).
> >>> 
> >>>> stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --mremap-numa
> >>>> --metrics-brief
> >>>> 
> >>>> mremap 2570798 29.39 8.06 106.23 87466.50 22494.74
> >>>> 
> >>>> So it's possible that either actual swapping, or the mbind(...,
> >>>> MPOL_MF_MOVE) path used by '--mremap-numa', removes most of the excessive
> >>>> system time.
> >>>> 
> >>>> Does this look like a known MM scalability issue around short-lived
> >>>> MAP_POPULATE / munmap churn?
> >>> Yes. Is this an actual issue on some workload?
> >> Same thought, it's unclear to me why we should care here. In particular,
> >> when talking about excessive use of zero-filled pages.
> >> 
> > Currently this is only showing up with that particular stress test. We will try John's patch and provide feedback.
> > 
> > Thanks for all the feedback, everyone!
> 
> I reported this internally and have worked with Joseph on it. I tested v7.0-rc7-68-g7f87a5ea75f01 ("-"), "Base", vs. ditto plus John Hubbard's patch ("+"), "Test".

Nit: please trim your lines to 70-80 chars per line, thanks!

> 
> Stress-ng command: stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --metrics-brief
> 
> System is an AMD EPYC 9J45:
>   NUMA node(s):              2
>   NUMA node0 CPU(s):         0-127,256-383
>   NUMA node1 CPU(s):         128-255,384-511
> 
> The stress-ng command was run ten times and here are the averages and pstdev:
> 
>    bogo ops/s   pstdev  system time   pstdev
>    (realtime) 
> --------------------------------------------
> -     3192638      35%        24041      32%
> +     3657904       5%        15278       0%
> 
> This is 15% improvement in bogo ops/s (realtime) and a decent 36% reduction in system time.
> 
> I shamelessly copied and modified the fio command from [1]. I ran:
> 
> # fio -filename=/dev/nvme0n1 -direct=0 -thread -size=1024G -rwmixwrite=30 \
> --norandommap --randrepeat=0 -ioengine=mmap -bs=4k -numjobs=1024 -runtime=3600 \
> --time_based -group_reporting -name=mytest
> 
> (that is, one hour runtime)
> 
> - read: IOPS=14.0M, BW=53.4GiB/s (57.3GB/s)(188TiB/3608413msec)
> + read: IOPS=16.0M, BW=61.2GiB/s (65.7GB/s)(215TiB/3600051msec)
> - READ: bw=53.4GiB/s (57.3GB/s), 53.4GiB/s-53.4GiB/s (57.3GB/s-57.3GB/s), io=188TiB (207TB), run=3608413-3608413msec
> + READ: bw=61.2GiB/s (65.7GB/s), 61.2GiB/s-61.2GiB/s (65.7GB/s-65.7GB/s), io=215TiB (237TB), run=3600051-3600051msec

Do you have profiles for this? A flamegraph would be lovely.

> 
> Also, running Base, I see tons of:
> 
> Jobs: 726 (f=726): [_(2),R(1),_(1),R(3),_(4),R(6),_(1),R(2),_(2),R(2),_(3),R(1),_(5),R(2),_(1),R(2),_(1),R(1),_(2),R(2),_(1),R(1),_(1),R(2),_(1),R(3),_(1),R(3),_(1),R(1),_(1),R(1),_(1),R(1),_(1),R(3),_(1),R(3),_(1),R(1),_(3),R(1),_(1),R(5),_(1),R(5),_(1),R(1),_(2),R(1),_(4),R(2),_(1),R(3),_(1),R(3),_(1),R(1),_(2),R(1),_(1),R(8),_(1),R(4),_(1),R(3),_(1),R(1),_(1),R(2),_(1),R(7),_(2),R(2)
> 
> when the fio test terminates, which I do not see using Test. I take that as the threads do not terminate timely using the Base kernel.

Yeah, no idea. Added Jens in case he knows off the top of his head what this
might mean. I don't immediately see how POPULATE performance could
correlate with thread termination performance (or to fio performance overall)
unless it's actively doing mmap + POPULATE while threads are exiting, which
I find doubtful.

-- 
Pedro

