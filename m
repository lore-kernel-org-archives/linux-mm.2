Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F1A6C61DBE
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 02:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 124166B0095; Wed, 26 Aug 2026 22:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB2A6B0096; Wed, 26 Aug 2026 22:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011036B0098; Wed, 26 Aug 2026 22:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCDE16B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:26:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 596C0C02C6
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:26:46 +0000 (UTC)
X-FDA: 85145461212.03.2401DBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7F037A0002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:26:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SrGToG6W;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787797604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KRCoeguRNXQjKf/J1BJkLL0r/nvVajBk63KtuoCwr8g=;
	b=qWtTHe4+p+F4vE4Cl4PgoxtxgiT9Q6p0PNWItSZC6U0KQNk6JTP1ArM4x+0k0Fp+wTAbqT
	mq/KO3Ou5CXW/fmyikR/Rje1Sf20PXitYZaPmu0fSgXYa3sbFbk7eN+ToWJQ6zeLQdS3wL
	2Lh2JfcBqiXxTZ1iIcbMdU0q7UjVgW8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787797604;
	b=Z3uFBEdZzM2Fs3d5Kh2H1mGhGNYvarMTMQRmTRWAQ7zuTqOhndRRoY5X2DLEXVCeRvfKwn
	dxXLpdyEBVkoT8muTaqfPJACrOKfamJ031PUgTWAK8qsb/3HWCkX28w+mexnzUcwQvWku9
	3HfWasJsNpgyfNedkknHRUKa80LQMoo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SrGToG6W;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27CB443FFE;
	Thu, 27 Aug 2026 02:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FDB1F000E9;
	Thu, 27 Aug 2026 02:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787797603;
	bh=KRCoeguRNXQjKf/J1BJkLL0r/nvVajBk63KtuoCwr8g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SrGToG6W0G0ii7P5TP8t46WK6UMhhyLRfGMQYo+3BynPCsSu/G5jy8oZGuAyd1J1g
	 scsANe3Hw/iwJNEEx50FiGhSv/LDUezqEXYjStUi2WJHbxv8VEn+KqXpGOyrKDQJhu
	 hQoeKqOiIgBaRhanIjyZX383vWTsESelzA2ESxwg=
Date: Wed, 26 Aug 2026 19:26:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Li Xinhai <lixinhai.lxh@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+f12658786a4153df5113@syzkaller.appspotmail.com,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: reset unfaulted VMA page offset for
 MREMAP_DONTUNMAP
Message-Id: <20260826192642.980c3aba921bf20cef425591@linux-foundation.org>
In-Reply-To: <20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org>
References: <20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F037A0002
X-Stat-Signature: i4ozt5zdi5oan9bcjyq1ufkp5x4mrga5
X-HE-Tag: 1787797604-526016
X-HE-Meta: U2FsdGVkX1+b0YjzHwR94r1FoFDuUYLLHZMtUm+yvoThCjjH0qJlmyHUH5/v8H/NFwsLinShRcJ05m2+h35BkROQB6waQuckU31UkWEvn5m0byMFOrj8hDhwjT4G+oyyGS3qJervlEjDOEGJt87WXJUeryc5OnKIikw4sV9kYQcgEjap7Q10JBwHYejA2cLlwUGQ4xsBQIV58wmIXT4YwYuoUor85d3x7W2xWfn9pXaZsm55xsaWCsxP6Lo5LYmOrwRwW8jrIGwWHjm6fafJU+qPaVxTpnIAJtFsujAusj4LtVuL3lq8VgMSbJdMpLLLo5Hd6/gixPH/lM1L007tUUSm0EteeDqhN9qNJkRtaQaXVZvlxRo5pVVz9pUDqzV2FaFCV3clHcJbUrjA2mxdCsO/FggTR+G2JXvzdinIdd8Lw+9NSD5kXPoPXcnPsBJFXsleTAuKIFk8EJg9Vn+5MoWdTdpbWh7dvPrTh0ou0dMAAsvACvnH65DtjDij+ySjEEHrdqP67d/4tQTz0/bAi6T3dyVJ8oGdcFa2hpgj+yNEVPGazIP8m00bGi/SByVvzZSAydwfSgTDeuQ0yTlriDQ9CNHTsb3VcSYCzPJ+gGXK8QOvmM7DdWcoYTuQ6wtCXDIQy+s8ET6ejztpO7mB8x8ULsCZhynl3LwgFn/Emtf/+LJ4gOpNV2umSGvhXasSrPkSEDTjkkwCpQEzP2F58qRysIdNRuAHU7yKFPX6pDIFt9v1Kur9FJ2GWwEId337V7YGkErkAJznyvu6V6BkUq54GtaKZF0T6HnvOSchyFUZAhJxmWgrTRnNCPtD4xxPdaxJESRqReM31hxWqPjuXNcgll9+DnwAHsIPkYG9fKBtHDMi0ITxK+2pqhGWi251LSWhMTM06SP8u/CMdF9FJduHETEIMvl3NiBBes8gH93j1HA9SSH8hwb/9PcMga7ODfFxpwfDbGzlO3864PU
 ffXCYMCc
 Mtc2eO+c9BrHx632uaHKQLHS8sE3ZiyuY7zOR2Qg5ja8kw/ooZQvByKYAVp2ja2r0eHjeTlxXfO2rBGfhvQq/v0vcyiPSVgo2/GsVCXpgkUz+0d/x+54Oo7lmKN9LciYNtFJ6yGdD29XUxrASVxL3FzeRQSADdC2siUp/lSwFCmwHjxdaL5bJr2Vug4PD2XyRhe/pMnp8f1gIQlsDSjK5cEHDv08q/CWh8ecqsYvqEqu8oT85BYo7tlFUbKSn+ngGYqQZk5JmqQaAWzeOnpvKUIG0rI+07F6P3geIo6mOfwXeYYX63EV6qgmX3vtrMaw2F/iJ0SbCjdF5whjHpm8MinmyCDY7cybR0J2NiMey5pBIwa04/RIzxaAT+rv7DboLY954liE5kP+WgHr+vxsZETV91SpPwHOdBcND9oZ2gIRktwSy8ke9E9iTYkSuAeGeEfw1XemBPwKwvlgL15Go2APYDpTPRRe5qXS13/kCW5EwAt+CHwiDWvyNO1DTrbj6VaxZAtiCC7m49rk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 08:55:26 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can reset
> a faulted VMA into an unfaulted one.
> 
> It does so after the page tables have been moved to the copied VMA with
> MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfaulted
> as the page tables it had are no longer present.
> 
> However, in doing so, it violates the invariant that the anonymous page
> offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.
> 
> This is because a VMA may have been faulted in, mremap()'d (causing a delta
> between its page offset and vma->vm_start >> PAGE_SHIFT), and then
> mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.
> 
> This condition is a violation of a fundamental assumption in mm, but now
> also triggers an assert in assert_sane_pgoff() which explicitly checks for
> this condition.
> 
> Correct it by resetting the VMA's page offset at the point of completing
> the MREMAP_DONTUNMAP operation.

Thanks.  I'll park this in mm-new until mm.git is all merged up
(simplifying my life..)


Unrelatedly, Sashiko thinks we're messing up locked_vm accounting with
MREMAP_DONTUNMAP on a locked VMA.
	https://sashiko.dev/#/patchset/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org


I had Sashiko write code to demonstrate this but am too lazy to test it
on a current kernel.  If someone could oblige?


#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

/* Read VMLck (in kB) from /proc/self/status */
static long get_vmlck_kb(void) {
    FILE *f = fopen("/proc/self/status", "r");
    if (!f) {
        perror("fopen /proc/self/status");
        return -1;
    }

    char line[256];
    long vmlck = -1;
    while (fgets(line, sizeof(line), f)) {
        if (strncmp(line, "VMLck:", 6) == 0) {
            sscanf(line + 6, "%ld", &vmlck);
            break;
        }
    }
    fclose(f);
    return vmlck;
}

int main(void) {
    size_t size = 4096 * 10; // 40 kB
    long initial_vmlck, post_mlock, post_mremap, post_munmap;

    initial_vmlck = get_vmlck_kb();
    printf("[1] Initial VMLck:      %ld kB\n", initial_vmlck);

    /* 1. Allocate initial VMA */
    void *addr = mmap(NULL, size, PROT_READ | PROT_WRITE,
                      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (addr == MAP_FAILED) {
        perror("mmap initial");
        return 1;
    }

    /* 2. Lock the VMA (increments mm->locked_vm) */
    if (mlock(addr, size) != 0) {
        perror("mlock");
        return 1;
    }
    post_mlock = get_vmlck_kb();
    printf("[2] Post-mlock VMLck:   %ld kB (+%ld kB)\n", 
           post_mlock, post_mlock - initial_vmlck);

    /* 3. mremap with MREMAP_DONTUNMAP 
     * move_vma() increments mm->locked_vm for the destination VMA,
     * while dontunmap_complete() clears VMA_LOCKED_MASK on source VMA
     * without decrementing mm->locked_vm.
     */
    void *new_addr = mremap(addr, size, size, 
                            MREMAP_MAYMOVE | MREMAP_DONTUNMAP, NULL);
    if (new_addr == MAP_FAILED) {
        perror("mremap MREMAP_DONTUNMAP");
        return 1;
    }
    post_mremap = get_vmlck_kb();
    printf("[3] Post-mremap VMLck:  %ld kB (+%ld kB from initial)\n", 
           post_mremap, post_mremap - initial_vmlck);

    /* 4. Unmap source VMA 
     * Since VMA_LOCKED_BIT was cleared on source VMA, 
     * munmap fails to decrement mm->locked_vm for this region.
     */
    munmap(addr, size);
    post_munmap = get_vmlck_kb();
    printf("[4] Post-munmap source: %ld kB\n", post_munmap);

    /* 5. Clean up destination VMA */
    munmap(new_addr, size);
    long final_vmlck = get_vmlck_kb();
    printf("[5] Final VMLck:        %ld kB\n", final_vmlck);

    /* Evaluation */
    printf("\n--- Result ---\n");
    if (final_vmlck > initial_vmlck) {
        printf("BUG DEMONSTRATED: Leaked %ld kB in mm->locked_vm counter.\n",
               final_vmlck - initial_vmlck);
    } else {
        printf("NO LEAK: mm->locked_vm returned to initial state.\n");
    }

    return 0;
}


