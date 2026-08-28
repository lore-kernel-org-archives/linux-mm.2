Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6260C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 08:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA836B0088; Fri, 28 Aug 2026 04:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D536B008A; Fri, 28 Aug 2026 04:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5FD6B008C; Fri, 28 Aug 2026 04:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63EE36B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:26:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D905780283
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:26:08 +0000 (UTC)
X-FDA: 85149995616.07.ECB9B83
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 06FAE140007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:26:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nH6hH2Zf;
	spf=pass (imf23.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787905567;
	b=4YlfUeefe0sVqgkexWU2xFCDU8mIqG/A6Q+VVuYIrnI2t9nN5PT7pF1zAKz8G2PWm73zLC
	HIUXYa8HtVGwql56Ozpmot7d8ZWKmMJSVQguIPachELRCrii3TJNhgRwDBdZB4juK1uS2P
	AC5CdRFhc12/3hz69ohCrN2BBQldIVA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787905567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57gbJ6PuWdyL+kyJ8Dp9UoiQ0ikR2cC7cGndc/5JOIA=;
	b=UozRu66KH92VvkloJyDD0xM7cqtz4lIdfkeYwNvWyAqnXGNf0JRuizUBNKwMRmviRuO+H/
	3aoEOikC0cwzKTkzceLu7UM9E6JHfb4lb1U1du+WjiKtows1SShkeyxV9/5IPhdAXZ7fGO
	0y0nLnPoeOaJejIIo3ee2Q+xXC7eVsw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nH6hH2Zf;
	spf=pass (imf23.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84830c774a0so1007081b3a.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787905566; x=1788510366; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=57gbJ6PuWdyL+kyJ8Dp9UoiQ0ikR2cC7cGndc/5JOIA=;
        b=nH6hH2ZfLqcIErcm9uCT3EFOGTjGn8d1ZLw+WlzPQChe4VYb6axdZi6noJFx4zyNCJ
         oc75Caw/Scdo1aG4JHJNnVi9Cfn8RTYoP6FSDBJ2qFbc5PlM/GG1hSuYuegKlkjmY9e3
         TKO+lbPxqK0EXgEuWVWDeEqZSUWd/Z76CVF16ydCKreYJh1yprkZ12dmv/tLg4Qlw1C1
         T7OLYa43k8RQb7f7vuoKJoFbvatGznB8yoS34xkP7bLNqQWDUmSyO/H39y+dlv+Y91kQ
         Xxq5bAH2+S2xVO+I2rr49bZ4JY/AQ9WC0NSJra77UDcnY/+2e2iEKEOgRtdot8whvsjn
         9aQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787905566; x=1788510366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=57gbJ6PuWdyL+kyJ8Dp9UoiQ0ikR2cC7cGndc/5JOIA=;
        b=Sav2ilNhkqtWWsPnrVHKU/V7+SeT2CcLPq/Kx5eCsMrBBFXw0WeUw+GmSeHyAuqqW5
         SxUwNBFIkJ0IpNQiCs72QYvzEqsjbRVPP9e0Ma2onvnI/T5/E2qBgEesY8tTSSLIRBdH
         yIMklHkb+R5hPdt9GjmJEkyd4FBQZaYCR1wH9LaUm+prdq5M4wDz7aMJ61QvS/YsZyPj
         6eQerOE4haNEEzRwDB53LE0Anw+4SxYNaQ9Cf4rLYxQ4xM1EfrKQcYiPAkXg4pw88IWh
         xu0DzGXnv9hnzHFG9MPRtSu3Dp98IUm181gP8wuzQyU0sHZ8Yr+//mZh5te3CYYqwpZv
         e+DA==
X-Forwarded-Encrypted: i=1; AHgh+RoShMeP/I2rx6O0p2trBtlkXlmDMtGowf35ojxjO9eq/7Dyj1UaJmR7Y+mkn49GwEr28W44/I9A0w==@kvack.org
X-Gm-Message-State: AFuF++k0JrSId6j8wLJLkaLmMoDtCfQYExMqPOJfLLyUvA+ZfQEvsz1a
	wXNzBy90kouD/uDvoifU1JHjEP+PFNkyfCo5IVsKrOwpp1gLrh53Ekkh
X-Gm-Gg: AR+sD121xyyvduJKHqKTVIrAh3dODLZAZGNzj04gnORuC7UHpkKZVSPrCnCDaj3fX3E
	9S3NE4hVX0AbeVnnYrdQ24fSYPX2+oFtOVkPOmB3GtsaNuJlfKnQ+bPWGW9sOsRXtfrVIFi6ox2
	yYELMcX1QXBdxqr5yex2gQ3N0CjPA7OwYGmx4YuyUmSTkpYAIGbR8lL4SCFK3RxjvsFc/q6oY92
	R3zyB1kHky1kKU+O1a9z07QA90b6geg3fXHAWrjRvGRw6FXoWmel/qbk+YaDekI/sQ/nooKqHh0
	g/+OI9Mocc16Rr7htdVlLvqvmPg6xXMSN4a/jij4+vCCoEgC0ObYqZfSLqLZDJiaf0dXD45xpAT
	EvTUbM019IGK6ZVx3tbQlNdstuUxtJNwKFa5C5IGCn5oWEm8YCUuna9jiKb8cnDLO5fwlHb2Fa2
	2oH5HzRYKUp8HjxXIgBRY6Fc4huYxfmiLgex6rZBRdP9imkJWk/tJb2dbsny1glIaVBVThNjSBC
	EPgjztTdWZ48a83UQ==
X-Received: by 2002:a05:6a21:496:b0:3d1:c0e2:936b with SMTP id adf61e73a8af0-3d26765e5f3mr12417876637.7.1787905565243;
        Fri, 28 Aug 2026 01:26:05 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f36dc602sm310894a12.24.2026.08.28.01.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 01:26:04 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Li Xinhai <lixinhai.lxh@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f12658786a4153df5113@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP
Date: Fri, 28 Aug 2026 16:25:39 +0800
Message-ID: <20260828082540.584610-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260826192642.980c3aba921bf20cef425591@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 06FAE140007
X-Stat-Signature: zzz638c93xdunha5z6gamys8p4xi3yt8
X-HE-Tag: 1787905566-210573
X-HE-Meta: U2FsdGVkX19fWj//bu7KJ6gUAuoChA0AnBXN4pIkxta22htnNx27rjWzlyVvSVn6QrSBPd6CwvAPFcE77X7skx+YvRAn+MGC5MoqJlaVrxQ5H/fVF1VMvjOtvi+wb7LS/EtMXnU3i4phb4qkQblD0FDt4OX2X/e02b49XRK45yTtbKKqrmHNmYBpQ31nRQdzN6xFBBpxuXnKd71mj16tvUn2Vrap/4TBznfVOMISwS4YH1zwlMpxQ9u4aDrKnbhocUVRsGHjz89vb9bOBs4bI5wSeSiQHbD/KwQbsut3uF2Gy7VkT+KSqppUtoM23rdRmVgrhDc9h8UU8nPjOMcvbqr72la3aHXJaNdkKvtVMQv5OZC7WRijovESiKZXMa1mvEcaQwEUaJyKu+W5AEry56Lnd57UjjEcG18HCJlUVuTa2fXXo/2KbzYJKN6FhaVglDvH2jVfpmic/7/OFCOg3qsKG31XIGWzriJ2E6y7V01liTSfyGzz2HohV9mGdtmPl8WchuUw3qGEP7D5Le9OO1HHB/cxN63/sOFWsQ8qgfG7fNDsc56i08eWmEDItrC5bXoqVcmZrEbvyZS/VhnO2dZyiAe1FqtgFauhAifx5ivq9ACs2GTPMOaAlpRV/T11Z70GH0Ycw2Mxi+rE/6ex7hpFXUIbbngzoECu8Xw7deLbURrVDSQDdt4AOtvB+8MIfgTBaCKgWq+7HheL2uywGQWgiX7k6lA0tTA+hUWfiNl5abpz6lQitGxtSYMSbagSDNq1liHHV0NdNoPjOJwnk1a2zkGJ93JFDKjp6Ept1L2uwSuNl129CfKHQJCng/2+0zWMtOuN+SAJDCc0F3vsdP9RPPUbWhEV2reG6vhaPcSyHvbY6/2b2BzJz1v4BGfC55IWyi8oPUt7X9BfVYfpQosGzMStpFxRH6NYJg197ZfflizgPcu29r69cGrGcMK5BJhLs2cWiBxbMyumi/M
 sToa/SOC
 +cVcBtOZjl42KoF4U9Urx3MN8P9+IAAQf3C7pH/HTNB/0gaEaRrmZmlveYsrABNBeGNKEaE+bW5HcOwMcVs43eq6o19kQ0AuwU7WrcdCPYzJdtMdFG5oR24juPod7AmZJ8150cZFn8xUrn12+C9d826fDljCXVrUwuG9Nrf7BERZ3aT7ucLB3xl3NcO1CzmQDkhe9oMKlHSE8n+x9czlEJ6hS/WUR9bVAInvA0TUsa8ZnKrVI4euIr11O4Snb9O7++H5q6kXLfryv6VWB9wlFDMObx1tnQ7YCPN6TGp8g6sQ3B0pKQSqiu2yeIGdD0hg6hylTPouPSUHoOMD0e2ykyxJV6CSIj8J0NV64E3A7gpKC9sQ+pFYq/f2TBSuV47vcqebEfyYr88QkjXOLi5uxHHAOaMYJfY2T0EMf72LQsl8Q7Ses5Hx3t19dBkFC7BFQLqMOgLjLhQT3RgJLSIZX/D6w4dmIh/g1XqSz/xNFe5hQapKX3AD9lusWVFoeT9Nxn149/UACw3WR4jzAo1xJ4ikLcuJ0y8Pb+BD6JCq9jQxiaW+MWNrcRD8T8QabqwsepiyyV6Y8mKjnpuSbwlagsGPbwQ/7AGrRLQ8p/vUqTczSSUXbIrEOoShIXcD/mNPHcLFrLNj2oQUKRkTpCO9A6hrbtU8BLABci0nSVqLT3blLOuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 19:26:42 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 25 Aug 2026 08:55:26 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> 
> > Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can reset
> > a faulted VMA into an unfaulted one.
> > 
> > It does so after the page tables have been moved to the copied VMA with
> > MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfaulted
> > as the page tables it had are no longer present.
> > 
> > However, in doing so, it violates the invariant that the anonymous page
> > offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.
> > 
> > This is because a VMA may have been faulted in, mremap()'d (causing a delta
> > between its page offset and vma->vm_start >> PAGE_SHIFT), and then
> > mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.
> > 
> > This condition is a violation of a fundamental assumption in mm, but now
> > also triggers an assert in assert_sane_pgoff() which explicitly checks for
> > this condition.
> > 
> > Correct it by resetting the VMA's page offset at the point of completing
> > the MREMAP_DONTUNMAP operation.
> 
> Thanks.  I'll park this in mm-new until mm.git is all merged up
> (simplifying my life..)
> 
> 
> Unrelatedly, Sashiko thinks we're messing up locked_vm accounting with
> MREMAP_DONTUNMAP on a locked VMA.
> 	https://sashiko.dev/#/patchset/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org
> 
> 

Hi Andrew,

> I had Sashiko write code to demonstrate this but am too lazy to test it
> on a current kernel.  If someone could oblige?
> 

I tested Sashiko's reproducer on mm-new (7.2.0-rc5) and confirmed the
locked_vm accounting issue. There is a minor typo in the reproducer:
VMLck should be VmLck to match /proc/self/status.

On the mm-new baseline, I get:
[1] Initial VmLck:      0 kB
[2] Post-mlock VmLck:   40 kB (+40 kB)
[3] Post-mremap VmLck:  80 kB (+80 kB from initial)
[4] Post-munmap source: 80 kB
[5] Final VmLck:        40 kB

--- Result ---
BUG DEMONSTRATED: Leaked 40 kB in mm->locked_vm counter.

With Lorenzo's pgoff fix applied on top, the results are
unchanged, so the locked_vm issue is independent of that fix.

The issue is that vrm_stat_account() increments mm->locked_vm while
the source VMA is still VM_LOCKED. With MREMAP_DONTUNMAP, the source
VMA is left in place and dontunmap_complete() clears
VMA_LOCKED_MASK, so the later munmap of the source VMA cannot undo
that increment.

I have prepared a separate fix which undoes this accounting in
dontunmap_complete() before clearing VMA_LOCKED_MASK.

I will send the fix separately after completing the testing.

Thanks,
KunWu

> 
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <sys/mman.h>
> #include <fcntl.h>
> 
> /* Read VMLck (in kB) from /proc/self/status */
> static long get_vmlck_kb(void) {
>     FILE *f = fopen("/proc/self/status", "r");
>     if (!f) {
>         perror("fopen /proc/self/status");
>         return -1;
>     }
> 
>     char line[256];
>     long vmlck = -1;
>     while (fgets(line, sizeof(line), f)) {
>         if (strncmp(line, "VMLck:", 6) == 0) {
>             sscanf(line + 6, "%ld", &vmlck);
>             break;
>         }
>     }
>     fclose(f);
>     return vmlck;
> }
> 
> int main(void) {
>     size_t size = 4096 * 10; // 40 kB
>     long initial_vmlck, post_mlock, post_mremap, post_munmap;
> 
>     initial_vmlck = get_vmlck_kb();
>     printf("[1] Initial VMLck:      %ld kB\n", initial_vmlck);
> 
>     /* 1. Allocate initial VMA */
>     void *addr = mmap(NULL, size, PROT_READ | PROT_WRITE,
>                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>     if (addr == MAP_FAILED) {
>         perror("mmap initial");
>         return 1;
>     }
> 
>     /* 2. Lock the VMA (increments mm->locked_vm) */
>     if (mlock(addr, size) != 0) {
>         perror("mlock");
>         return 1;
>     }
>     post_mlock = get_vmlck_kb();
>     printf("[2] Post-mlock VMLck:   %ld kB (+%ld kB)\n", 
>            post_mlock, post_mlock - initial_vmlck);
> 
>     /* 3. mremap with MREMAP_DONTUNMAP 
>      * move_vma() increments mm->locked_vm for the destination VMA,
>      * while dontunmap_complete() clears VMA_LOCKED_MASK on source VMA
>      * without decrementing mm->locked_vm.
>      */
>     void *new_addr = mremap(addr, size, size, 
>                             MREMAP_MAYMOVE | MREMAP_DONTUNMAP, NULL);
>     if (new_addr == MAP_FAILED) {
>         perror("mremap MREMAP_DONTUNMAP");
>         return 1;
>     }
>     post_mremap = get_vmlck_kb();
>     printf("[3] Post-mremap VMLck:  %ld kB (+%ld kB from initial)\n", 
>            post_mremap, post_mremap - initial_vmlck);
> 
>     /* 4. Unmap source VMA 
>      * Since VMA_LOCKED_BIT was cleared on source VMA, 
>      * munmap fails to decrement mm->locked_vm for this region.
>      */
>     munmap(addr, size);
>     post_munmap = get_vmlck_kb();
>     printf("[4] Post-munmap source: %ld kB\n", post_munmap);
> 
>     /* 5. Clean up destination VMA */
>     munmap(new_addr, size);
>     long final_vmlck = get_vmlck_kb();
>     printf("[5] Final VMLck:        %ld kB\n", final_vmlck);
> 
>     /* Evaluation */
>     printf("\n--- Result ---\n");
>     if (final_vmlck > initial_vmlck) {
>         printf("BUG DEMONSTRATED: Leaked %ld kB in mm->locked_vm counter.\n",
>                final_vmlck - initial_vmlck);
>     } else {
>         printf("NO LEAK: mm->locked_vm returned to initial state.\n");
>     }
> 
>     return 0;
> }
> 
> 


