Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96ED0C4450A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 22:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656386B00CC; Fri, 10 Jul 2026 18:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6073E6B00CF; Fri, 10 Jul 2026 18:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51EE76B00D0; Fri, 10 Jul 2026 18:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 277656B00CC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:12:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A6BA6405C5
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:12:20 +0000 (UTC)
X-FDA: 84974266440.09.CCC32DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id F154CC000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:12:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="vrKNqD/R";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783721539;
	b=g8qNqUUe4T+BcnxBKBNPTPenkcEwNEPN4q1nSLB9zV0OIUJPNdPQ2sCMLQBnIVSJbVJmo5
	eklOHZrjczFaG5Npho0ZSku7ZbcTRJUGqJZ1Y5X28lcrVvev9a11TN8gtBhMfwYytLgdFH
	NqNBm22gcSMpZEjmYiSF8jrydNQ6NjI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="vrKNqD/R";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783721539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZPCZ7vPd1NuY/NOvoRK1wg4DzJ9OfLHTV03rmwvPpc=;
	b=Mw6MfqGDBi5EDjPGOzoiMHsR5jCzi6+v/I/U3SSfRKuTnk+q8An9ZqCKHDgAHCw2pGRA0S
	GKqJ/DghzDSm2ciHc0JPFmuwiOVquvpTrvkB8vwuzVRm4oXs6SRVFppHangCiLFoj0ghnq
	w8Rb1wLWnIDNcHeLvckmrW+hVN4IKm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15A9C41A63;
	Fri, 10 Jul 2026 22:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C384A1F00A3E;
	Fri, 10 Jul 2026 22:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783721538;
	bh=vZPCZ7vPd1NuY/NOvoRK1wg4DzJ9OfLHTV03rmwvPpc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vrKNqD/RSYZafjQOwVndW01m5aLwswfnuVAfqI5wWJJiUGxMunb7KBRBbR+vIavWm
	 Jwjm7GTEqUP54kAGt2vK1og8+S0X4K5USi4sGzpjMkFtbq+y8rgsLvuLfwWeKzYqds
	 EILDdi2jW5IYL94/XhZxUobGPOo9gvao6LZmzPYg=
Date: Fri, 10 Jul 2026 15:12:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
 region faults
Message-Id: <20260710151216.0397a6f9ac5c7b4ccd274cc1@linux-foundation.org>
In-Reply-To: <178371881034.900500.5214601525971121683.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371881034.900500.5214601525971121683.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F154CC000B
X-Stat-Signature: f155d6sxhf8aa66n1aztcspw1o417ouh
X-HE-Tag: 1783721538-156165
X-HE-Meta: U2FsdGVkX1+f/m6w/IkZbqNEsSfdEX8NGnfC45ifC/34loW5Ce0GpFYQ1DTmE99Gfx9NULrQyWI50Rn+PTcvx2XWR5Jy0pU6SHxEw1TvsOzBGTuqAcNLDkevJL1wRmXW6iBx5SAVsU6QHH7PPkEnGw64Ui1Ct9aCAInqs2Yt8qoyhtR4adeKl3e/lZGMDEBt5WVkLITiCBmuUY9bjNlp8apaAS0yAPHfnWJcXBLVfCkgLrS8JnhtDPz6KLeOWWXqXFMFI02COcK/9Yv68stYC1fn4lphnPA7EKqdoXrzM69UzWxaekKTdXPp82KpkCmlnU29jtHYs9hwRlxMMbLYoJPrdtRVeFTzFS/6WmjAYlIaysTrSN9TTjEceR6ih/5lb1yoXu2koNt/7OlnLUQritB3PaNL5ih2fPZ0V8Qjdk2E29gpzuj+LAM4Ui2egRRPRDmP2avy9GdfYGA/NxwGmPEU51xRIniILuFrbsObLAD8F4EYmD0MA+nqst4JQ5euX1KKKx96iwOF5290YvA0Ejv6gkTgR4d3FZdKoGI6oxKnsA2q4KvLxPCylDNmaTvMn5WSHAixiIh1dCCDKxUinQUWI0zA0smPEBdrTChhW79i49+nGhN8inLMu5uzmG/ASGWP/pVsQ+OJEOkUtmPFQ447njn/Y5Ni07Jsc1sry6OXVKx0GpBQ7X4/vbCeVgE2aYOT0cCojEZDlrdxXW/sscjNrrp3XmvJz/4mJrwTg+8711UUWdAn6ASMrRXgG2gY3xyxPeqoR2B6h6K4lBPuWVce5oRlMkLTzdNWaT7EaNI+YtpWIaYXorJPWPiO8R+dp+A8lht4Fo2oIfIzNRrVVoTufAbz2ih8KGMLNBRP0gAKAysnjB8s7+HL3o5nE9G+5ZG36Q275Dz9sldRyd98yr9yzMkm6mn1gUAkDCjMGZQ8jgU37Jt/yzAcS0OA9z5i6tY+wH6Tv45iQ/+nPvJ
 kFVCV6RV
 Py2zWCMD1A0wdMacNFEGmVR5OrN89UkZSTrvp6e9Y1SV0di1/AyD2IhQm0UQuJAIpomakbSjgfv4gPrjoYB2qY6NyYI0cUozLGZFtHnfC8rR7NcQ2ehGlRtOUbjcW9sl01DE7+s4hC5xkkL+L6lDPWZmU3rwHaXzkttlQYn7FS4S+C9LZnWF74MILdLiKDr2I6y676VLAGTgBJuqK9sqeiKsVwLlZa3d9f3lzIHDdpk6wDfO+lt5Yce/iMLytrgWb0LyTFeZPCMrStdhR6iZw1+hh9YueThOBdOMwyGOpea47JRENdObLp7mDUzAvLFTEmOya
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 14:26:50 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> MSHV currently faults movable memory regions by taking mmap_read_lock()
> around hmm_range_fault(). That prevents the fault path from handling VMAs
> whose fault handlers need to drop mmap_lock, such as userfaultfd-backed
> mappings.
> 
> Use hmm_range_fault_unlocked_timeout() instead. Passing a timeout of 0
> preserves MSHV's existing unbounded retry behavior while letting the HMM
> helper own mmap_lock acquisition and refresh range->notifier_seq internally
> before walking the range. After the fault succeeds, MSHV still takes
> mreg_mutex and checks mmu_interval_read_retry() before installing the pages
> into the region, so the existing invalidation synchronization is preserved.
> 
> Fold the small fault-and-lock helper into mshv_region_range_fault(), since
> the remaining retry path is just the standard "fault, take the driver lock,
> check the interval notifier sequence" pattern.
> 
> ...
>
> @@ -452,13 +412,19 @@ static int mshv_region_range_fault(struct mshv_mem_region *region,
>  	range.start = region->start_uaddr + page_offset * HV_HYP_PAGE_SIZE;
>  	range.end = range.start + page_count * HV_HYP_PAGE_SIZE;
>  
> -	do {
> -		ret = mshv_region_hmm_fault_and_lock(region, &range);
> -	} while (ret == -EBUSY);
> -
> +again:
> +	ret = hmm_range_fault_unlocked_timeout(&range, 0);
>  	if (ret)
>  		goto out;
>  
> +	mutex_lock(&region->mreg_mutex);
> +
> +	if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
> +		mutex_unlock(&region->mreg_mutex);
> +		cond_resched();
> +		goto again;
> +	}
> +

If the calling process has realtime scheduling policy and either a)
we're uniprocessor or b) this process and the holder of
interval_sub->invalidate_seq are both pinned to the same CPU then
cond_resched() won't do anything, and this might be an infinite loop?

