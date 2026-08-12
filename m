Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C37C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53A46B018C; Wed, 12 Aug 2026 08:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B1B6B018D; Wed, 12 Aug 2026 08:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68406B018E; Wed, 12 Aug 2026 08:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8AE6B018C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:13:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8801A80326
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:13:44 +0000 (UTC)
X-FDA: 85092508368.28.A9D53A2
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3DC3BC0002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:13:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786536822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rGvyKSX4FMqJGpB7PSKjb/22wa7UYZTgFnw6PhiP59A=;
	b=qzMdqVs/IyhKlJEwwfNpsKrncRX01xd8yflyefOBT/abu1vBtYFIDKj2LavnuKwYnM6XAM
	DlLMOMHljidIs+lk5yRHbERaIJfjjkS0Ou6DP/rOmcPC2Bn/WC7FUDPkeb+Ah8Ty9VKYzA
	A1XzTXdQBQDI+pDfo8aMQtMXiZ7vNLg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786536822;
	b=QL1MDN0DlTOydwtloBqehdsHIlGACGSOmZPPCq2DNt/OGseKRW7uZ35aQ8htdGX8/uyMjb
	VIPuItdmp7kaiDdiYen3sue4fv2GC+31DRUpKleY0syyTXo2Sbb7k8TclMcZQpqf1/E8QR
	9t76KD7pphdAoO/s2MMFfvtaDB0bw6g=
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
	by 156.147.23.52 with ESMTP; 12 Aug 2026 21:13:37 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.126 with ESMTP; 12 Aug 2026 21:13:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 12 Aug 2026 21:13:37 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>, Jianyue Wu <wujianyue000@gmail.com>,
	her0gyugyu@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] mm, swap: keep hibernation swap slots out of the
 swap cache
Message-ID: <anxjcYKBMeAlgrBl@yjaykim-PowerEdge-T330>
References: <20260811132209.2862708-1-youngjun.park@lge.com>
 <20260811114622.6a04927b0c7ca0c2d6b39cce@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811114622.6a04927b0c7ca0c2d6b39cce@linux-foundation.org>
X-Stat-Signature: 9tk4nc41x31odjj4ij6sihyx7m5dghzx
X-Rspamd-Queue-Id: 3DC3BC0002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786536820-970136
X-HE-Meta: U2FsdGVkX1+h5DzHW3zqJzYuAPWJ5wkmjYcPJi0lC5R2IEKNgZt5S5vhIyy4sdqzayZcXzDO51AE5ncE2lEuvpWrelMDl8+hso72TjCrFkYokrW9PLkUcJ5rBTObJFPFz2eldnpBqpJNgCOKvx5sUtemDVGoqCPW4l0xnLhdxrPueahNvJgmkHn9Vod4SJZrETMlzJW0ZohpxBqVOKEU6tqQjjwJfVlFG5EnH/0oI2ZX3NYhW/sKCvSGx7LiJo4dJw6bmcd6wnAJ7ur0Hg3GjAOGQMGs0TB71TonNwj+UvSQ0Axoc6BEQ7a0Fhlb9ZHrx50tYnE8PFD9DhZdZkOWqaQICPTlQObo6/A7B4WXO1xS+MsYfHuZgkzhrR58bpCHBSpGWPHKzWHm1W8nRPWCZd5F4BqiPMr/VdaDPXrWV3Z3hIVEl6ZpbZ3YSl+0Nj6r2S2VxDvCsEtGftrNH9PNFRjRJJbaa0TmwwCxMpJHSAVb+7nGezq3ok4+elN3NdFaL8DlaKYVWId4n94EM+tol48krFXlR0cKE2YIbmnwOWvSXD0r6PNtdnyeO055pMaaIvUE0KlUbFMATTJwl2AylGWsnDpUO2zwd7kBhnXPF51WWj6Gl4EOWPxUuTsOueSh8IOT+L290vj8F3pRx7twwr3te5EMYTZVsYKLyprolOhMTI4+mvmnt0TcBtguRTnqlj8LxeWPtqEmETCO8F7f40TqCzDa0IdQvKqxHj9odtajn+TOW0urXz6GDlUsIKz2WRhyTf3zra/g2A5FvvlC9fyzJf2PMU7WBs622H0WuRBsd/0ofBZ1zDPaw8e6d/kXN7bUOF7d8oLkG9Hhmme/pC6/XNxRbXTR61gOsnAEESIUFlY/eKybaVvCK4ilpiIdbaNh2tw4lBXn+1BR8k77fMln24FJ0qBETdNK7j8Pz0E/xrpozu27kduFiVNekTALGk4XJeQpzllzyZwNDpm
 slOnieFh
 i3upURxFdGA96eq8N51RQvj3cu5K5VcOZ81nAG34cKgfjZk79ANx0CSX0vywR7Mww41vIFTbXt/1T9Mia0GoUMJLrO6N+ehY00vuvTtqiQXes68L7YFHajorGA5vSZ8kWjIKUOc0c1GbaWyJDCQplkFUltPbCuAbvCx6xYOqDeyoYNHDlsB/ltWkCe3+odZfjcHIxkDLPvg/bNP0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 11:46:22AM -0700, Andrew Morton wrote:
> When fixing things, please always take care to describe the
> userspace-visible runtime effects of the bug, particularly when
> proposing a -stable backport.

Thank you for the advice and sorry for it.
I will make sure future patches describe the userspace-visible effects clearly!

> For [1/4] Gemini tells me "At a high level, this bug triggers silent
> memory corruption, process crashes, or data instability across
> completely unrelated userspace applications - typically occurring after a
> system resumes from hibernation (suspend-to-disk)." Which is what I
> figured too.

That is right, with one small correction. this can happen with
uswsusp while the hibernation image is being created, not at resume
time. Memory corruption, process crashes, or data instability across
completely unrelated userspace applications can occur there.

> Do we have any reports of this?  Reported-by/Closes?

I found this while working on giving hibernation slots their own
marker in the swap table, which I had discussed with Kairui.
(https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/)
As far as I know there are no reports, so there is no Reported-by/Closes to
add.

> I'd like to grab [1/4] only, and defer the other three until 7.3-rc1.
> This might be mistaken, but from a quick read, it's not clear what
> benefit those three patches offer our users.

Simply put, they are close to cleanups that remove unneeded work.
(with a some little optimization.)

Patch 2 keeps bad slots out of the swap cache, so readahead no
longer wastes a folio on them.

Patch 3 keeps hibernation slots out of the swap cache, with the same
effect. no wasted folio at readahead time.

Patch 4 removes dead code.

Thanks,
Youngjun Park

