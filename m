Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2119F532C6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 02:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0885D6B0005; Mon, 23 Mar 2026 22:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0394B6B008A; Mon, 23 Mar 2026 22:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91436B008C; Mon, 23 Mar 2026 22:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7FA26B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:51:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E4951B9895
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:51:19 +0000 (UTC)
X-FDA: 84579430278.15.63D8817
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf29.hostedemail.com (Postfix) with ESMTP id A1D36120010
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:51:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774320678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nw1iqE+cx7Vw/oudWtZU2oQxpossldG/TZXvWmPS3Pc=;
	b=FjtfoZbaWA9fi8kiasQQhaiuDSWu37VrKP5aDtmIdu6SKbLYUmuYJ4QqKZ10eZNrudaxAY
	pLQIFStUovRdbfEM4VDzKXKDildzv7y1r400AeTX2oATMwIdfF2T1p2M8/w//uiBX3HeeW
	/aICe6nPw9D+rz6LSgSA293Xti5LLP8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774320678; a=rsa-sha256;
	cv=none;
	b=B2GtS9FFLEynectrHmOUVcRsKciqDlLjWUaHIFzfme9WdJ4ttLvjNl3n27JXoHBG0KUlcS
	4n/f+nnk2ymS4NnYKbpqha+MImMeN1sHc+IPUl/hLhR4mSNAL/pPgQgtV9GFDMaGzXLWVk
	syLVJMEaj2qIahKfVBobp/+r05MtUyc=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 24 Mar 2026 11:51:13 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 24 Mar 2026 11:51:12 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Pavel Machek <pavel@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 0/2] mm/swap, PM: hibernate: fix swapoff race in
 uswsusp by pinning swap device
Message-ID: <acH8IKWyv9gW9YFU@yjaykim-PowerEdge-T330>
References: <20260323160822.1409904-1-youngjun.park@lge.com>
 <20260323154833.045b732a5865b11b5b4e539e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323154833.045b732a5865b11b5b4e539e@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1D36120010
X-Stat-Signature: fegrixx8j4oqhinef1qehkgcdnk5td3z
X-Rspam-User: 
X-HE-Tag: 1774320676-834284
X-HE-Meta: U2FsdGVkX1/SClK84AhiP+p02K+PvSuEtTssKWdPiaMZ6PeW4XnJjqQJhQwB1st/qE5hvG4jhT+fw1fx0DNCdsmSLS0V0nHy4JWiuNBaoK/7E4BudgMFJUD8O/PwXAcJIs5kFF8nCUlT7AquMXCrlpglyqrGj3sm5GEvZBExdXGy4QBfrN4su5cNs49AS7APv84JxqHa+eCBCZbXtirio2yA9YH/Tx5EiH6Fss7k2uew1lJysheh8YoNI7PHn0y1xYwCVTc318AH3p1yjbcQpqQAUlz5rcpsZWHzWbGrXa8T/cgs/VW3+QWtopd4eQ0DGQNKqVRsUwsXFgGM3v2O/VcwUssd7uMYS2DaSJL/aTQbwJF8xjn2WZYFdwBriAr4ucPZGIpfGkBChTxj6Ys4ZmpQCZXeVZCtW5ssQpdPf9dk+kqcb4rk8QU0Njjvbkk4IAz7A5DTVZB1CKH/xjVW83atug5xCN/8rmfYvkN9uYVupktnRFzpuNswjwLRB/OFve/t0mm9vscNtfeg/OXgktNHBJ6+TPM2lVRO8+Zl3yNgoldWHJXudf/mvlbftumn0bCvklZYlgkCVpht0pLG8avgDyZ6Rr+tq2hYaZnp/mr1bZ16QfyzsoDlJw546K00nS5mHEjkwjdSwJ1SshVsuQU39dyiw50SS1QASdnAD4mmtVN7tIkluYKDwfYk/cc16JMpZaH2Bgpzzl6FbMULuwOLGHYFECMg+a/5ATnWgPpIMJ/WuDJ/WzGPLF72pZSoPfRlKUaSFvuCsn/hudUo87Q+rUC9V/vNlxrzbVPaufNkjCkK7QOJkuBUOyFa96LndBG24gVplS8+6XAkiIBUISshgRnU5kcZdFP52IEviSwmlm8njADvZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 03:48:33PM -0700, Andrew Morton wrote:
> On Tue, 24 Mar 2026 01:08:20 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > Rebased onto mm-new per Andrew's suggestion [1]. The si->flags race
> > flagged by AI review in v7 (between SWP_HIBERNATION and cont_lock in
> > add_swap_count_continuation) and the proposed fixes discussed there
> > (atomic ops for si->flags, or serializing with swap_lock) are all moot
> > on mm-new since Kairui's series removed that code path entirely.
> > kernel/power/ changes are small, so Andrew proposed carrying everything
> > through mm-new.
> > 
> > Rafael, could you ack the PM-side changes?
> 
> Please.
> 
> We'll hit a conflict in linux-next and Mark will tell us and we can
> flag that to Linus when merging into mainline, usual stuff.
> 
> Or we can park this until the next cycle, depends on how serious the
> bug is.  How serious is the bug?

Hi Andrew,

In my opinion, this bug is unlikely to occur and does not appear to be serious. 
It may be better to park this for the next cycle.

I verified the behavior using suspend-utils. Below is a recap of the
reproduction scenarios I mentioned earlier in more detail.

Pre-condition
  - swapon /dev/sdb (intended for hibernation)

Case 1

  Process 1 (test program)        Process 2
  ---------------------------     ----------------
  ioctl(SNAPSHOT_SET_SWAP_AREA)
                                   swapoff /dev/sdb
  ioctl(SNAPSHOT_ALLOC_SWAP_PAGE)

  - SNAPSHOT_ALLOC_SWAP_PAGE fails with -ENOSPC.
  - The race window where swapoff /dev/sdb can occur is extremely
    small, and such an intentional sequence is unlikely in practice.
  - If SNAPSHOT_ALLOC_SWAP_PAGE succeeds, swapoff does not occur.

Case 2

  Process 1 (test program)        Process 2
  ---------------------------     ----------------
  ioctl(SNAPSHOT_SET_SWAP_AREA)
                                   swapoff /dev/sdb
                                   swapon /dev/sdc
  freeze processes
  ioctl(SNAPSHOT_ALLOC_SWAP_PAGE)
  create snapshot image

  - In testing, snapshot boot from /dev/sdb succeeds.
  - The swap block offset may be taken from an unexpected device,
    but I/O to /dev/sdb itself succeeds.
  - Since the actual allocated swap offset is not used for writing
    the snapshot image, there is a theoretical risk of corruption if
    I/O occurs at that offset on /dev/sdb during the window.
    However, Processes are frozen before writing the snapshot image to /dev/sdb.
    Therefore, while the issue is theoretically possible, the
    probability of it occurring in practice appears extremely low.


Best regards,
Youngjun Park

