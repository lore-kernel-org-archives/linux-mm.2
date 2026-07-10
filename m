Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03DA9C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 02:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956B16B008A; Thu,  9 Jul 2026 22:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92DA16B008C; Thu,  9 Jul 2026 22:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845966B0092; Thu,  9 Jul 2026 22:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE746B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:10:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E304614031F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:10:34 +0000 (UTC)
X-FDA: 84971237988.27.B79258F
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2AE4540008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:10:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vzbad4ok;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783649433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6M9EO2T8ZhKMV/o4gYzimlSRKTWmrzh6IwQ2unmsm9k=;
	b=lDB6K1IczlDQaFe/QnyB5ggdZWmxKPDEG0uu8z2yFij1+sgv6hKUvTZywluAZjJYH0H1o8
	fQvDKU8sTWNoV/KnfyTLmvo/1PVvOzaaaBcn8estvnTlzfvzRHsSDzBYaoQ7v48kN9daSV
	PCYWEIlePXL1o13dLP1VBztMxqVbZSY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vzbad4ok;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783649433;
	b=j+HQ3ekKfDy+rsnvfDA+hHPvpiUno0Lq4VHepSrOBqNTu6GGdxd0vPNfPsyYdqd0OFLz/z
	O+wKdmniAI8bbMAGiftJnY0RVODQvRWBzBjIP5iev2RbPmGgw16wQgdGR8Je7bV652/LFI
	91tJU5EF35bGqf3ki/MUtRgxqLLC5Yk=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-37df72c9984so680545a91.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 19:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783649432; x=1784254232; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6M9EO2T8ZhKMV/o4gYzimlSRKTWmrzh6IwQ2unmsm9k=;
        b=Vzbad4okVTi3FlvFQm60u6d7TEGZcOPlOqOakyFE8jxFEkicVCTMHpDsPRAJ7xtZUX
         BmdFDGXDzEzeFTM8ctG/o9bYzbTQ6C8OfH1WvC/J3CUoTJ9Kj/410B5gyBTf8j1GmVAd
         siYF+hJpC4+f2LCuk6vfAHwaz5hAQNDnjEiwVobfEOA8Z1vj955/7jXh5I22pwKaRK2i
         47+JjkD+CC5iAuU8CgyQSJO8OlgBLcrz4GFg+jUIg9DZvAIl819lTdP2xFHipNxvGrsE
         KAi3zaVGd+X62T1IlmsYzjKVdX2+vSyRSdJdPbVCdFB5bc9smfAl64mV8FNnBECkQ3qc
         uMQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783649432; x=1784254232;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6M9EO2T8ZhKMV/o4gYzimlSRKTWmrzh6IwQ2unmsm9k=;
        b=KyJABBbvjaK2+BjcSS0QlHMSpg1LRLK2XTguhOXQ8zxHickkgRW4CxadWJePUCv9Cj
         e0DUj7ayrqnCwnMgV/IOOq9EUhlTdHyN26aKt9jyAH3z1XlYGJaDQeg+boBNAh3uDlJu
         WFe6hdcaYDzknvWZE1GirjWSqJrMxHxYyEj6vGl5mTpss3eOleFX7g0BkKp8MoDVKa+Q
         Y2KwkW5VuQ4cC23xgMbj/DiIajQvpW+yqdyLY3pCEBGraKBi+c5Ns9oTsnT5PP6Okyno
         9UYLyTyBoFCLMVvzFhJcFjlXpwAgAUzspbTBxFEM9W3Nrm/2Ko/a7ix1pzRoisbCOlgO
         2zkA==
X-Forwarded-Encrypted: i=1; AHgh+RpMhV97tZmBxTAVL1qyajdNTF8nKQaJHwWrYeamfc8q+yN+KcHdZfhH9xivIpzAueSm1hA59YuTIA==@kvack.org
X-Gm-Message-State: AOJu0Yyu+PbCvfqEpck6ag92aNu1Oe3uMkLshnTVI9MfD0c1zbSBRIyI
	tBLQPZWLoqrXIOnjzU5NWROBYMNHObuK+KjysH7WwRrQ1x0d8m/XX0kE
X-Gm-Gg: AfdE7cmE8lXHch0FVkpNijBXh9ClX4hGMDvMCvdJvSec6XJMsrEc+xMmyRV5w9IPxua
	O8B5voCawQ6FHkleVN1vx1RF+vuYfXD1QsGIUdpO28q5I3hRQakihkQKTWibIMZohSh8O1q1dHb
	2B45sExanU2scxmofUEN3h9B/Kzh2QfDGg4gcYU7WSyg+r9cYw7MLPil9hDCU0lpcKXAtiHXi4a
	p8Wxhx7KnaAvoQh9N19IuyKH4XBvhkLAUidHTzTZB3SD84XL2Vrq87DBNVNlsmbPYgCZtGyAIlI
	qzTE008JF+E1pyQMhLafdVU156tg6s7kRv+7BwX95jhVPv6oPfEvbKFH4EE9SaenJDYrDHQvZIx
	u23AYXMWIPn8vcAxG2g1UQE1Gm1CyEsFj4Jm4welP50oCGjhU3qOsH5htyaRKaqHPkqgJhyvoNG
	RKrpqc94KrWQ/wEpmFjfJfbsuVaVSLV0T1glxY6TjlrEukGl0xIZEcitaaMNbQs3CucpEL/FWbn
	/S6ne0yTY5zlezStQ==
X-Received: by 2002:a17:90a:e7cf:b0:37e:b6a:6cdf with SMTP id 98e67ed59e1d1-38941cc76e0mr9141284a91.20.1783649431820;
        Thu, 09 Jul 2026 19:10:31 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38c7d38e084sm1395987a91.14.2026.07.09.19.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 19:10:31 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id AF4BC1495CB2; Fri, 10 Jul 2026 11:10:29 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [PATCH] mm: nommu: free unused resources when mremap shrinks the vma
Date: Fri, 10 Jul 2026 11:10:28 +0900
Message-ID: <20260710021028.892645-1-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2AE4540008
X-Stat-Signature: x4kq6c9b8mxi6n4zuusqjjs18k7kwzbt
X-HE-Tag: 1783649433-459215
X-HE-Meta: U2FsdGVkX18GBqvyOOSUVJIzL5WMih2BWxGQ5lN2WHgX38feOPvnef5u5c2yfQEuqgwySVe+U+YPCOn+gk1pCBO6xLGITRih1vdFMPYSHvKOwiTX+AWepwBOOHbrn0JGcw9lwO4qbjik1wZN0swutfByH/IlVBKLJaQCoe7hN784wGosgbNFhIKrZ8YxWHYjjeKW3KJzhEtS2eYUYxOfO2IrCwijPZLQxIWcpioOh/OJwIjmoW4krxPG+t5PZEt1gVTPYwCQUfSFKR1wLcgA14Hd6YvyMUXY3Sk2nuQwSPAnWYoGMTXOd9qsdvmc9zQKyk+V8Q8s+4dOo38u0mvavGuT2JQYV97vcAAt1WYfDsUNy3u5u+Qdt66gOXo8rsCN29pWv0cFfVcGAr1EULTrUY7VhUoc5BfaoRXPKZCllmUemSvxZUQ5/AnjomQsYeG71mEUZzDYkLQaZ4z/Gw4V/oRCk1Y9tWF5bKFsu8F2CWy/RUNNzenDf+4RooHttivSm06j1shNL9PedkfWfMKs1h7Yb2/m4p9Dn9Cq3J/HesceJjRAEvXIvjYDM2ii5VO93M9kIC3NsV6/R0+t0DaSa/uSLySZk/SZLbhYis21GzkUZvzJaYxnRddCGNoNsCPBRcDY/heA0Wb/zARmtE0XamyiEWvne++MqOW08fTnxPidmlpm7Aq7MSl7moii9Bvt0zM2FwovLiVPXlJFozOk6dRdWUtj/EUFlWh7DfhN5DEDGkuMNL4gu6eqeIBVAKV14Z34aamV6WQ7sD9kLGptH4qd8487gtWAqrs/FHbRGDkuanoknR5o37Yrsx8I9tcrfbTnnHplaGGGyg7rvyOgNTzzXSwugdci+aqvsWoDNSgO2kND1EOiSr//yaHT0sLweLqdcpeLsLNlhF9RjL+fpKRLU2o4QcmrnHeNLBIq35PxuLDLpON/qE5xm9QdpGkJbOjwrdhYzxXuq7JLyuY
 qzNiPajc
 2/d8kWMFdLWSjY5cxfEBBBRHG0IjZgzSjdqKsf1Zvy/m6scZvqa1WUdfslYn7E4OApwZObt26CoxJ80HW4lkFvv7qnfFDnxjXVl63x4nJ7Xu1WLR7LNZMLqzaITQcqQrTyul7IPVpZsed0Iqwf4DjaQc2hfQA6fDXIx1IyO0ogTMzDP8DQViXpax766mZ160HmKCvAU1iKaiU2QruUAqO9T1AMQsgGSlipdRL3IEN4N8Hra31hAf+08ADEPd7/AytpyBrXOljAkqbBiwXNK6KyihxoPMFefU042B+sFp6iEJgj3wg1uhpMdfW2vT8bKLVoqaadiWIhJlfd3eXP/bKhk0GPB9/renUnLDtAYIgAdDB+oUkoVKhloedW15y9j1iSZ2303GHs6u1hXh7J9ddXPkwITMEkHWQU9rAdzK+tkULvOajhNI8hcimYFYsUa67Nlctx9mgvGWfww7lSx9Ojcs7U1Uc8LY2Sb/C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

WIP:

When shrinking a VMA via mremap, the bounds are modified directly:
mm/nommu.c:do_mremap() {
    ...
    vma->vm_end = vma->vm_start + new_len;
    ...
}
This shrink the VMA without updating its bounds in the maple tree.
If the maple tree (mm->mm_mt) still contains the old bounds, a user
process could access the freed portion. The stale maple tree would
incorrectly return the shrunk VMA for an address past its new vm_end.

This commit fixes this issue by calling vmi_shrink_vma() when shrink
happens.

Link: https://sashiko.dev/#/patchset/20260702012546.665383-1-thehajime@gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
---
 mm/nommu.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 852ec9bd0505..10794e3b6be9 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1598,7 +1598,17 @@ static unsigned long do_mremap(unsigned long addr,
 		return (unsigned long) -ENOMEM;
 
 	/* all checks complete - do it */
-	vma->vm_end = vma->vm_start + new_len;
+	if (new_len < old_len) {
+		/* shrink only happens addr + new_len and old_len are in different pages */
+		VMA_ITERATOR(vmi, current->mm, addr);
+		/* vmi_shrink_vma() needs from/to pointers to be removed,
+		 * (mainly used in munmap) so, specify them.
+		 */
+		vmi_shrink_vma(&vmi, vma, addr + new_len, addr + old_len);
+	} else {
+		/* when there are no shrink, update vma.  */
+		vma->vm_end = vma->vm_start + new_len;
+	}
 	return vma->vm_start;
 }
 
-- 
2.43.0


