Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E61C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 06:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8956B008C; Thu, 27 Aug 2026 02:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753316B0092; Thu, 27 Aug 2026 02:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61ACF6B0095; Thu, 27 Aug 2026 02:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3989D6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:27:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE8FCA0320
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:27:05 +0000 (UTC)
X-FDA: 85146066810.14.EA1F31D
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id CDEFB120006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:27:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="sa/R4hxE";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787812023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZKMvnBcPJlEjiIGIjUEHCR8FjCIhDtcMqGhHVLCc0JE=;
	b=JMs6tfAHotDxcPM4xaqyjoRLq9InMvq/0fwkuILbeu+Ei4sJ0iibPgOH02i1JVBU7Gh5nV
	4yc6vVGAo1yHpE2Nv2PrCVzFHVoWgz5q1KzQ8JJnUZSdMwQSkmHTOhttsM8En+HAwjhHYi
	PO2XlGo4LJ8/d73DgJRgcnqjbHvGhMY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="sa/R4hxE";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787812023;
	b=3lEussRwgvkbQHTVCcTwR2p3nAcLbZdz6+8r0wh3I40MefLzS100gSh2KqHu2HCqxStG6K
	Oz1OLXUgo5O1cUApYgivCHxukwnoXtRkhlCj8OKzL+33DAoWdCLo1PpZpTBdJmkledyJL2
	Qsq9c/Fa7EtlM3gu7PmDtka9XMRwsBo=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-852c481415fso2205543b3a.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787812023; x=1788416823; darn=kvack.org;
        h=content-transfer-encoding:andrewto:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZKMvnBcPJlEjiIGIjUEHCR8FjCIhDtcMqGhHVLCc0JE=;
        b=sa/R4hxE2uysiEhzwMuiJxGiWMb0auSREJPxtr0nhfbRHfMC/lj10fvza6/vmiHFIK
         HTujCFYIG79QQYjuFvwH2Elfcqicb3BY+8ewjf2NVCc6ux5UV07J2MtRRSByRB+phjpU
         6iyFe2GBDePy5UJC2NsrMJl7bvnj8iDCZkKVYbhNA5AZYfPOvcQHx5/RCxD26+pdcQqo
         yEgmkS71yI/4e/dxfXsg/ads4ZSCxqDt8f7m6SU/+ILOJcQQtWX7OMBZGvawEKpTAaSV
         923Jn1meB2r63rd/iCSDqz+BwOHIUQ5FykQ6k9Gb6YszSGhMfcrK8ENmgQhDZawchs/n
         fwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787812023; x=1788416823;
        h=content-transfer-encoding:andrewto:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZKMvnBcPJlEjiIGIjUEHCR8FjCIhDtcMqGhHVLCc0JE=;
        b=Qnm/bFIaG4BTZnrqJ4awhal6VEz8csGggZThwlHKQsHA4i9QOVCcS8puDbw0ebHHbH
         +dHZhNbQwqiYy+d9IKRfC09v6IfHuoZ0fKTtnvVG5l+qYpiyXhiqgvsvWqH8VUvP6ypk
         jZ61PEvKmvFdYUykjh2Ex+Xs7HWyjYvEZQwSFy7j867wLCXN8Ge0lq/53jkI0XQvseMs
         LV2/Kah1U1cpkbJ6Kl2cgRELt6HqgG/YcIIhVtAul8jfJnx3s5h4j5/7a5B5Ehfp9E3d
         U2IApuxGA2uu9WRNtITdK6s9RtEuR4bVk2A/V+nSmduqgr0f3abM+Zc+f54N/JXLcrzg
         /AwA==
X-Forwarded-Encrypted: i=1; AHgh+RrQJon4EKGBA9ERKUDNfU8Gzsnvk8X3HAr3HHADoVjLDvVHsNw/Xq0cRkETKnQ9eCOjr+U9hAyRdg==@kvack.org
X-Gm-Message-State: AFuF++nnC6GVBBfrPvcUQosS6XAcEGr+8wU+S0OGz0Eld4seKOfwUv/t
	Er7zWs0evbitdA897RBMoF6yzCtyKiVukas1Re6sPwFN7KROkFXhlz0i
X-Gm-Gg: AR+sD13IodU8xcjSttQ9f5c4YDPD6SIyaJ9lUrr0ur/CSAc5gzPrVL6p6H8ux/BzliT
	c2e488EVfEk95xTiHkkLa7zFy0AsyTblTLelx0VGsAk1ohDLfiMPJByBZE9N7VhtcGy7315GXt8
	nFkO9SHcM7tZvn9dXcIumJxuWKB0IhgeMuX7NnpLuFmzD/Xwiyn6HR2UqrTNEI+nrDVa+FIdUj1
	W83GWojx9fghy5QT21bBLna9mOhX7A/OUMCahs1M8cifOe+NBN+K8rOUXDg/CugVNdafJ+6SEeg
	rcVxxOIENDzn6ddJNeWPdLLxQTLPYGKHHY2ObsrbEpU7dyTNcXxuqqfFqLTPuIBKtookfJci4L8
	vEcRCW4wWt/6CO/Cx/P5amUlldHkmz+OI1cg9oKZVNDeYuAvjRILZG9bwk5Pmj/VR3DULAn5I7L
	Cof8bzS4k+TrNkasY3w1qT8m8qUFDQPjM1l7emua3lZ4jtrOGhQwpSDtPI1fQ2MagI0aV2ZkmJd
	LYkUC8=
X-Received: by 2002:a05:6a00:181f:b0:84a:646f:193 with SMTP id d2e1a72fcca58-8536ea1f46fmr21211018b3a.0.1787812022167;
        Wed, 26 Aug 2026 23:27:02 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8535cdc03b0sm1615408b3a.30.2026.08.26.23.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 23:27:01 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: 
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
Date: Thu, 27 Aug 2026 14:26:50 +0800
Message-ID: <20260827062652.305611-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260826192642.980c3aba921bf20cef425591@linux-foundation.org>
References: 
MIME-Version: 1.0
AndrewTo: Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 8bit
X-Stat-Signature: edhtdmuidki9b5qdi956spb66s9bsbi8
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CDEFB120006
X-Rspam-User: 
X-HE-Tag: 1787812023-514565
X-HE-Meta: U2FsdGVkX1/U0Y6wjg89BR6grMFpguhKaiMSUUVtr+74VxjF4hOgMb9e9J62JjWuIlkEHMQEdtdN29vDzN7DNteZrVCXDl9SeRIniMBV/CYVxcTg2/w3RVB/WcQKugCYp/I2xuKjoQDVTYT3Mpm04PHrSax25o78O9BkKW6/S4EfGHietkLq0ZMpSG+6DOo+tDQjc6xWcyNyiJ8Cw5ReWzWD1URnjBsuOVMZrfhFB92tjcN60gmbOd2cVkwfIAdFEzfXkoZJGcSofELyuLPmR/7tMfu/EKRtALDwS+yIigjXrKVdV8/c4y1Q+bvSVjxtfvs2FENYK921Gh+VC1UxuHDyraBj700EVyG2WyISvZPrY3HqBv2iOacj8GtyEsR0nylSjeF2h2i2doHtmJw26VfFNO1Xskrraft4iAsaqhhLWcuNbv7xp5cl6X53RZyqk0mVTnmzIQHpCJK2sUuq3rxIA1O4xuJc6C6PxKY5JDkrTBW9+zSXHiPNshiRgg2aSTBNO0o4NPeTASXO6UjfK2vpYnTyElnfs0zHLbpkIz+OKNCF1WXvzyI9wGLTJqf+rjZFYFzg4giMltuZfUWQccBJmi4Wz1HuVvUeto3sHF1vJ3P3hS+CeSdSoVsfxerumrsXNGOw5izp/D9pW0w7eqKnjjAMW9c1tk1ymbIEaQGCytGEmzkWRUN/HxamfV2jIQpWhv5JoCIPBstmyqdwZo2BuUGO3FEYLWTWOHI9wleyEVwW34k47qCr55pUohfPUKE7Toae2VyA6YK6WYC1k2PET0mzYh0KWgXYv0DWu2sL8/nXDKg/iodnJGNMCPAZ02wjHrnbxeICcEpwcx03Pgv/qTjdyyUMpmOVFdT6+oXGhZIiwetYBfuOEFMjtxlZmipiGrCWu2NbQ6JjjsqErJhO6YuUfmIi8Zgkgqeev7dgljeJY76EpTKZoXc6JnkoEXTsh5TppBeWbEZXAFO
 mGSRW7qF
 xbHuJ+b+bB5+RVkCjbWxMi7vJknLoAPQwxSzLSue5aZk5JkRF4jehkYYDC0JvqKGADxQXjYtfja0wHqWjc5sd6dKbYiHG7Ds5XEKCXRBVt448qTK3ZHQijTakdZZyefXjuvryU6hM2lccTLFknPNLTHgWSkjUU78tDOHHjcl/YJn0ucVl/yMiEbnZBUHN5Y0YTH5Z7E/0o5hSyL9NWZrfVhkuQ32TapFUe/oXqrOfTDwfELKeD0bUEVzXCLQ5wbBMqFyg0xzpsKdUSXmx8wNS8c6JdaS6Y1CnAVg/2Yvs1NP0OYXZBv870skMt+SM7cwh+9OBjMnpXjGRkharQ3Xd73EYUiuFA+TzVPfAvpr1GMPwyqteDkZBW2HxyrEBD+5lcT/00fPSGJoJzRF510Guvw7t7KfX4PhOoHlnVq7nnj1vS9UNiyKEXLg2N+RmAjjHN/W9ih9akgm3OWkCBgG84DuCaGWO8+op2Tuhsf1CcRAwunfOyp50GfcovLBo2FBuyuC2Sj8KUOuhcQa2xJ4FOJgVBr0TsM8pEdIxBKirli8TWRsq3zDu1r2/08+x+vHwoaYcEoUSJNjdOyRoVNs6z07xFQtgBDG347AsCgNOMxf02v8hBulUYAhbdRPiOvAnj7CNCB6IB8lQdJbPFPzBndq1TvFP0Ob79P4yTbCDnjOImKkJsekI+Z2FoxrbStrf+121CQAJ/ZAjY8c=
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
> I had Sashiko write code to demonstrate this but am too lazy to test it
> on a current kernel.  If someone could oblige?

Hi Andrew,

I'll test the reproducer on a current kernel and check the mm->locked_vm 
accounting before and after MREMAP_DONTUNMAP.


Thanks,
Kunwu


> 
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


