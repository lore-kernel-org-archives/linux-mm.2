Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751F8CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 02:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705FC8E0006; Tue, 21 Oct 2025 22:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6F58E0002; Tue, 21 Oct 2025 22:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CCA28E0006; Tue, 21 Oct 2025 22:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C45D8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 22:46:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD831C06FF
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:46:56 +0000 (UTC)
X-FDA: 84024212832.18.E3FCF68
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 462421C000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:46:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761101215; a=rsa-sha256;
	cv=none;
	b=t/k6BlpkWSXtMYkOq6wXwSp5xj+FOBxwP1KBH9HEZcfdV+eUWzhXm6D306ZTZyFMY/8Aly
	E4AKxFtCu/hIyR3PuZknzyyTlLOGbQFU4LOWFJTchKEAFsQU0v0480G7/HI7dkBKebXrYp
	4/Z2Y3fUPeWNvlFivVYzpUF5/1fGpNE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761101215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kX28FULpXXteXswyK2F1UaoY9EZgpGq74AYIMFzLytU=;
	b=g7+t2oy3i8sAPfbEL2hRd1+GBqcWdpeANwureDcvqe1fCtQw5Q9UCPy0L6vlpxsY4NVazu
	9usqIs9BFUtehOFMmaQuQICSx2odJcXCjJ2Dpd1FLXZzW/rZtHYnIvkzivfJ4PZVpn/WYI
	s5nz04DIihQyfzHGuDSjXDjXVChu+AU=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4crtns6hPHzYQtdR
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:45:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 91E8F1A1991
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:46:47 +0800 (CST)
Received: from [10.174.178.152] (unknown [10.174.178.152])
	by APP2 (Coremail) with SMTP id Syh0CgBXrESVRfhoiRrABA--.7417S3;
	Wed, 22 Oct 2025 10:46:47 +0800 (CST)
Message-ID: <0fec500c-52ea-473d-b276-826c0f4dd76f@huaweicloud.com>
Date: Wed, 22 Oct 2025 10:46:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible regression in pin_user_pages_fast() behavior after
 commit 7ac67301e82f ("ext4: enable large folio for regular file")
To: Karol Wachowski <karol.wachowski@linux.intel.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org
References: <ebe38d8f-0b09-47b8-9503-2d8e0585672a@huaweicloud.com>
 <20251020084736.591739-1-karol.wachowski@linux.intel.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20251020084736.591739-1-karol.wachowski@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBXrESVRfhoiRrABA--.7417S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGF1DCr1Dtr4kWrWkJw1kKrg_yoWrArW7pF
	W3Gw4ayFWfXrn7try7Ca1kur4Iyws8G3yUGFy0qr1UAwn8CFySvF4kKay5Ary3Kr48Ar4v
	qr4jgr98ZF4UCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7IJmUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Stat-Signature: bedwadbxm9tkcd487yst3f45jmto7x97
X-Rspamd-Queue-Id: 462421C000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761101211-674716
X-HE-Meta: U2FsdGVkX19tUJjuEfdx1dEZEmv375UxpzY8w3I06fcXT/1I+mnfWFc8MIvmFpdwC2jcbPqGey6RmAVYIUxZOFeYwBKteBRcJFoMGH2Ii9f5kDn4nlGBY0NaxVrq1kNPQK6mg0fxWM1BIUdaXVveQmMHhubhYWCKbH+wvgUfsIlOyIzSXEKsaBsbuC/6TZCiLu5UZcFTQ4a7yUmVjd0cSJ6F1iEqqs1ovXzhQJG/czxojYXbtJbSaKBJUeNffkvLRwo1R1twGiM0eO9ALXMKqDL0T/JQZM4MEnBdhraiy/0GkYpQakAx/fDALYz8ow3flCGX6V9bO29YWaxCdNv8bxmpm6Ob+w++7kAxqkycBQIJ3+FxkSF4VqPljMpZBZuOeKQhuVTUboFNxvNZtzVIz+yM2fikxW+1SR6w7exIcK+m2JzCxseP6/v4lN9iFY8IBd55ruqRIB216o7aIcJ7GigTfMgIvbOUHPyzo0/H4WItWZxwiGY4pkkpdCV0ExT0rQatVzojxVY1Uxxn7ifeEG/UT5mV5PheuITqkdYEtxLtkM0Jl4FDRvydjS7Sv+3WgWg0RxB0GCSpeWPlRskRp4NMi97xBknRyNhHDuBdL1P6mv5kGKESLLWk+vDZDYjboLg2ZJ43jbsmXXzn1rkkpmy4aYNcmYgIrHs0jIU58ZGON1RudQ7uL8/dHUTZpcOlA4PjWx8BE19mZpnmWmokyestXYMjDwnFtUD4dTtyx5zbbzttiS4tVNiore4qoRI7q+IjsroiXmthMuhbwund40A/Zrol5LRdVsqQ8sgR+IWzPsVh8OsD46ofcksb+Dd6ZgS5AnxUaEfX6snwZAA7tESP0DCA1/EGYjI0MvyWBy5KckAlYqUWZKIoiorAgYTfvI48p3kYPLsvIKCHMEV6mVCbW6IiDeJoFbfU64Uh8wPboLykB8UJnv9dDAFemt1e0Ic3AdHRJBUrsQje4AP
 OOHTjzz8
 M+YJvkwq9HARrALVZIdj9mfoBQAyfcwg9Hi5ng4KsxeweA6CZ6/eO4/zVuTwYJHd2R1OKjsfkrqoHxIyL9r5jmEvHIB9lg1bVwk4w1TjMs9d+XO8o+/Ojqf0E8hqJfiFSa1+no0syCkN+KjrAEN2ihnGkXTW+0hGtHoQ6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[add mm list to CC]

On 10/20/2025 4:47 PM, Karol Wachowski wrote:
> Hi,
> 
> I can reproduce this on Intel's x86 (Meteor Lake and Lunar Lake Intel CPUs
> but I believe it's not platform dependent). It reproduces on stable.
> I have bisected this to the mentioned commit: 7ac67301e82f02b77a5c8e7377a1f414ef108b84
> and it reproduces every time if that commit is present. I have attached a patch at the
> end of this message that provides a very simple driver that creates character device
> which calls pin_user_pages_fast() on user provided user pointer and simple test application
> that creates 2 MB file on a filesystem (you have to ensure it's location is on ext4) and
> does IOCTL with pointer obtained through mmap of that file with specific flags to reproduce
> the issue.
> 
> When it reproduces user application hangs indefinitely and has to be interrupted.
> 
> I have also noticed that if we don't write to the file prior to mmap or the write size is less than
> 2 MB issue does not reproduce.
> 
> Patch with reproductor is attached at the end of this message, please let me know if that helps or
> if there's anything else I can provide to help to determine if it's a real issue.
> 
> -
> Karol
> 
Thank you for the reproducer. I can reproduce this issue on my x86 virtual
machine. After debugging and analyzing, I found that this is not a
filesystem issue, we can reproduce it on any filesystem that supports
large folios, such as XFS. However, anyway, IIUC, I think it's a real
issue.

The root cause of this issue is that calling pin_user_pages_fast() triggers
an infinite loop in __get_user_pages() when a PMD-sized(2MB on x86) and COW
mmaped large folio is passed to pin. To trigger this issue on x86, the
following conditions must be met. The specific triggering process is as
follows:

1. Call mmap with a 2MB size in MAP_PRIVATE mode for a file that has a 2MB
   folio installed in the page cache.

   addr = mmap(NULL, 2 * 1024 * 1024, PROT_READ, MAP_PRIVATE, file_fd, 0);
2. The kernel driver pass this mapped address to pin_user_pages_fast() in
   FOLL_LONGTERM mode.

   pin_user_pages_fast(addr, nr_pages, FOLL_LONGTERM, pages);

  ->  pin_user_pages_fast()
  |   gup_fast_fallback()
  |    __gup_longterm_locked()
  |     __get_user_pages_locked()
  |      __get_user_pages()
  |       follow_page_mask()
  |        follow_p4d_mask()
  |         follow_pud_mask()
  |          follow_pmd_mask() //pmd_leaf(pmdval) is true since it's pmd
  |                            //installed, This is normal in the first
  |                            //round, but it shouldn't happen in the
  |                            //second round.
  |           follow_huge_pmd() //gup_must_unshare() is always true
  |            return -EMLINK
  |   faultin_page()
  |    handle_mm_fault()
  |     wp_huge_pmd() //split pmd and fault back to PTE
  |     handle_pte_fault()  //
  |      do_pte_missing()
  |       do_fault()
  |        do_read_fault() //FAULT_FLAG_WRITE is not set
  |         finish_fault()
  |          do_set_pmd() //install leaf pmd again, I think this is wrong!!!
  |      do_wp_page() //copy private anno pages
  <-    goto retry

Due to an incorrectly large PMD set in do_read_fault(), follow_pmd_mask()
always returns -EMLINK, causing an infinite loop. Under normal
circumstances, I suppose it should fall back to do_wp_page(), which installs
the anonymous page into the PTE. This is also why mappings smaller than 2MB
do not trigger this issue. In addition, if you add FOLL_WRITE when calling
pin_user_pages_fast(), it also will not trigger this issue becasue do_fault()
will call do_cow_fault() to create anonymous pages.

The above is my analysis, and I tried the following fix, which can solve
the issue (I haven't done a full test yet). But I am not expert in the MM
field, I might have missed something, and this needs to be reviewed by MM
experts.

Best regards,
Yi.

diff --git a/mm/memory.c b/mm/memory.c
index 74b45e258323..64846a030a5b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5342,6 +5342,10 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;

+	if (vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE) &&
+	    !pmd_write(*vmf->pmd))
+		return ret;
+
 	if (folio_order(folio) != HPAGE_PMD_ORDER)
 		return ret;
 	page = &folio->page;




