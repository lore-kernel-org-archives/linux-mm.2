Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E7CE75448
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 10:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA986B0088; Wed, 24 Dec 2025 05:43:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281986B008A; Wed, 24 Dec 2025 05:43:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180A66B008C; Wed, 24 Dec 2025 05:43:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05CAB6B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:43:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A87C81606A7
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:43:33 +0000 (UTC)
X-FDA: 84254028306.12.4C0C6A9
Received: from mail-yw1-f225.google.com (mail-yw1-f225.google.com [209.85.128.225])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8448B80007
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:43:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=Wl41K4r0;
	spf=pass (imf30.hostedemail.com: domain of ajay.kaher@broadcom.com designates 209.85.128.225 as permitted sender) smtp.mailfrom=ajay.kaher@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766573011; a=rsa-sha256;
	cv=none;
	b=32VKusR1xdQ4JvfjwmC9JUaLrw5kT83xPOBCiI8w99ha7qkiOtNEFuY8zw32wt1BNovewE
	4XHvnicrkbjvipO2lkXKvvhC8xWkBlTir4yDcYCe/dev67nfI86cVKxP6OPbwEAB8/6B6x
	6QqBXyWcBEjmKNSn7DNGfHsEBo6d14U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=Wl41K4r0;
	spf=pass (imf30.hostedemail.com: domain of ajay.kaher@broadcom.com designates 209.85.128.225 as permitted sender) smtp.mailfrom=ajay.kaher@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766573011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1xHU9mQPsJeek2O22o16AKV8gYUfyitTbWLfmUirCg=;
	b=wXE3rWd1N/17CZCGOX1roW8r106Vg4l+DIFgp/VjaRRa2t1xeN2BFTsEykzmIIZ/aDN2gF
	Uek4uPfaEJMQLzpCXXzzYTtN04E68qN3UQDj3uH2JGit3+wq96Y1gUalyOAovyz2D0Ne/+
	33s0kaLrOrMa7/ONhiW05oOl3YNfzNc=
Received: by mail-yw1-f225.google.com with SMTP id 00721157ae682-78fc3572431so33502117b3.0
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:43:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766573010; x=1767177810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P1xHU9mQPsJeek2O22o16AKV8gYUfyitTbWLfmUirCg=;
        b=sU+cSgNGY/yfgFQYufiQBOf8tHj4B0sFMedX0u1vr715qQxYwhjbcMBr18JxrnYg4Z
         KCyD3PZpqUQ06/09X57nhe6YCD5DK0UHMbWB1j508vs4j1c+2L5quk/+TCZNE9iB5D8K
         T/EJyTBxXND7ewWkkgmnz+ZHydnwrK18qwKJSvLv7bwILcNQ/sIUrcjPAAKsw1QYniA6
         U+XVL2qMaMZfQbrhJ/NA20JWqI3XqJ5l5JGoA2gYjReNq32ctX+IGbjP+DpSW+KG6a+Q
         Uofhllufe9ocRhfesOnA6DbXu1OWAdq/ojTj+3KK944Ymfz4YeSTTd+O63vJ6ASG2KW3
         gzSg==
X-Forwarded-Encrypted: i=1; AJvYcCWERFF2Npiq9G1BnEGnIXPjyyMIn6WdujRa7qLv6ZbSilS/i5tocz0PYwf9jC3zfSYY9BZCNFYn1Q==@kvack.org
X-Gm-Message-State: AOJu0YyP4hyrM47VUFlS2vAWhQCWFh1FohJiYaroavpCZdPSzr19ZSvC
	6f/Jkd5eYPq8emAPNp2njecnbpYkBK0lBZCBFWvB3Uzl42VZVopvbn2QaPAOoIg3Oxnxw00I08p
	+G1Zy5k2EKZQnaZyRUK9Bli3sP5Rq9xk4OO3sSnrlgM+MsS9IDmdV6x+P0XgfVVjcy10Uf70WPK
	mcZN8H+KEMvqLenDe0ccszsMH3gVvHnSoxHn/K2bGN3/RxB4mJbqsLncJBY1eXqH+nDbyYtweDD
	AeYiw==
X-Gm-Gg: AY/fxX6o2KzKm/XF4vj5u0Ro5+JzsLsCQDucLxScV0gP0oDeNN2PhjdDJ+t7uQn0KCl
	Vuoju7abOiN3THMDlqvtd9VBHfsaTvG136uzDOsWtA6L9DlDFhZbVmAxK4xBqcZzbsbPFZWExeO
	SPdGNdpANNi1e0TCvJd6PHN5T4CyTaaNjj1sBsTIE4nEeoV3mu562vOkZmNZr7I5wiebQBWhGz/
	CeRICB9kGyABef3mjyvhgVzE77V7KkISOa11DSWONUzW6U29ZZ9W0KjG1yDNrUNcDo8QmIopa5d
	k4HwxPTb3Rwj1M37jFcP2PUq8Kau60AKOBIvw8oCWkLieJcp7UCGgQ2vFIu4O9mIlovGziFSWso
	wsKR6H8Jkw9QTerHhjUxe6UYwslZWbB3VFyLJG8R9dQi0GW+oSDpdcLGro9zk+A/sjOUeE+c4z7
	SHgTnET2x/O+B4PjTmI/tovoJfIoewouTSJsKSIB1SJQ==
X-Google-Smtp-Source: AGHT+IEVKPkQMCoJEGCq4iK6lddstOplj7r1c2R1a6v2hqtSPErMWPEO2OlNuZWYcJDcdkbsC0ONsh4fNz7f
X-Received: by 2002:a05:690e:1919:b0:63f:b0a3:73fb with SMTP id 956f58d0204a3-6466a832133mr14304602d50.17.1766573010405;
        Wed, 24 Dec 2025 02:43:30 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-19.dlp.protect.broadcom.com. [144.49.247.19])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-6466a8d0dffsm701552d50.7.2025.12.24.02.43.30
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Dec 2025 02:43:30 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c0bead25feeso4894263a12.0
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1766573009; x=1767177809; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1xHU9mQPsJeek2O22o16AKV8gYUfyitTbWLfmUirCg=;
        b=Wl41K4r044aDAuvM8Sp5PdO8wbFR9ca2SAkGtT/6Rpub4WZmKI3+xTO5dCA5Sq9caK
         GU/s7SZzgHiTHpjP1m1SXLeZWBMwQmKT2xUbymV5E+vr2dETfN7gPmIRTN3X7rACdrnE
         Wf09s2TWx1n8VEvJ6Qwd72x3GqvHnpJhI0Ozo=
X-Forwarded-Encrypted: i=1; AJvYcCWS7wMFMGA04sbKLA2fBLFgdqRUgue/l1qhnjPZMQ1XdsFqtWy2k0D5vPgfQ0pXEnxmfTulLtcbTQ==@kvack.org
X-Received: by 2002:a05:7022:670b:b0:11a:fec5:d005 with SMTP id a92af1059eb24-121721aab84mr18748479c88.10.1766573008973;
        Wed, 24 Dec 2025 02:43:28 -0800 (PST)
X-Received: by 2002:a05:7022:670b:b0:11a:fec5:d005 with SMTP id a92af1059eb24-121721aab84mr18748454c88.10.1766573008224;
        Wed, 24 Dec 2025 02:43:28 -0800 (PST)
Received: from photon-dev-haas.. ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254c734sm68746919c88.13.2025.12.24.02.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 02:43:27 -0800 (PST)
From: Ajay Kaher <ajay.kaher@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Ma Wupeng <mawupeng1@huawei.com>,
	syzbot+5f488e922d047d8f00cc@syzkaller.appspotmail.com,
	Alexander Ofitserov <oficerovas@altlinux.org>
Subject: [PATCH v6.1 1/2] x86/mm/pat: clear VM_PAT if copy_p4d_range failed
Date: Wed, 24 Dec 2025 10:24:31 +0000
Message-Id: <20251224102432.923410-2-ajay.kaher@broadcom.com>
X-Mailer: git-send-email 2.40.4
In-Reply-To: <20251224102432.923410-1-ajay.kaher@broadcom.com>
References: <20251224102432.923410-1-ajay.kaher@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspam-User: 
X-Rspamd-Queue-Id: 8448B80007
X-Rspamd-Server: rspam04
X-Stat-Signature: efocgjfmuney7q969chkjsj9s4froh1n
X-HE-Tag: 1766573011-780525
X-HE-Meta: U2FsdGVkX18ZNGh8T4Gw8CQsuccf29/xzMscFCCZinEuTVpLl6408oOh0bM/dAH+2rkNUsXIDxods09B43s92EOV+vL/Jxj7aJpn61EWWMpkMrzQOk2XxByjTXngAUIhXIwa+Bn78ZVwswo2uFHn3omk74S/smbZCjlytY86yQlWOsFfRCJliL6SEuaJk8GngW/fHMDNAbKRRXiQba2MC18Wcetx7/As95B7d9QxTUNuztONaMtTxKGS8qSGG6gNHAHtIr9uFfnHJ2//pOqnEGy/+YwyzViXOUPdFAypQpyugfQGDJOkYkwffvm72DVz0x1r8RHCyiv/Hvr3Gm9Kv/jAb8FXO/okD1z3FMn4Y+9GEJKTpTQc5JHWly4e/jiAhkLbQTck5My2pkBe88Zf6yTOFDcClJTwtosd4DJ0MyLuimaZN0tmGYv4KMry3R1IalhxpewEmRA2k54lNPG3mRmjIV33F9/tnSpfxDxajdveKpeHx8J/zsyRi7Khe4uj+c58GWjlzQ+99O/ivSEm5AAimMcS4BWCfa4WXa5xizts8NJtnOtYyQF567+PeJzuiDlj+Y3A1tOQbboV5TGP7kOsaDBrU2gxymIP4LM3173XVYFRQ4zVh1u8bDUNWuYRhmDHr5aUVP5HSPb8Gv8/yAMsMI/P2pWCNX+k549Ofd7LZs9p7HbmF7cm65yfzSo4s5rETmk/P12ME6HSxJNJ6odmCV9c68J++a06Vwy61uznvOjSmBc2imuoDDkdghycC+zcZKDvNr59WLkbuWpJWov3gNVDd0gYFZiIih6Z+KTeo/ko6bapB8AIHqNDs1TXVaW3FCajNWkpdD+fscKBjnbutFD6Wgh0oJ608FGUEREljlhuxb4UmdKza2sf40+Hr+i+fg+A0OFBnRISvDk/03Pf5xjWkjpmKRKS9Ulp2Homw44BauIgGYTGs55XjK1PNFzBoIUylk5DnGbFZyY
 VWDchgMC
 IoCobnZYxhQRjgFk/uytu9CEtYp06UO3NBObLcen1dTFr+7ydWHqQyDTnqN/30IA1aRmmJHmNf4siIt9CCjmgb6zsMiGHbWDEb7MUs4ga/NOGY/yUbmv52SQtxdc0yRRzqgnT+NTTZ1xATBrkBDW8ulG1lcBK2fe7P1z1FTtgHe9LtoVbMmFbFp8Swen9cAWn7K/b31iwEeuJ8P6CjcnlOluV9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ma Wupeng <mawupeng1@huawei.com>

[ Upstream commit d155df53f31068c3340733d586eb9b3ddfd70fc5 ]

Syzbot reports a warning in untrack_pfn().  Digging into the root we found
that this is due to memory allocation failure in pmd_alloc_one.  And this
failure is produced due to failslab.

In copy_page_range(), memory alloaction for pmd failed.  During the error
handling process in copy_page_range(), mmput() is called to remove all
vmas.  While untrack_pfn this empty pfn, warning happens.

Here's a simplified flow:

dup_mm
  dup_mmap
    copy_page_range
      copy_p4d_range
        copy_pud_range
          copy_pmd_range
            pmd_alloc
              __pmd_alloc
                pmd_alloc_one
                  page = alloc_pages(gfp, 0);
                    if (!page)
                      return NULL;
    mmput
        exit_mmap
          unmap_vmas
            unmap_single_vma
              untrack_pfn
                follow_phys
                  WARN_ON_ONCE(1);

Since this vma is not generate successfully, we can clear flag VM_PAT.  In
this case, untrack_pfn() will not be called while cleaning this vma.

Function untrack_pfn_moved() has also been renamed to fit the new logic.

Link: https://lkml.kernel.org/r/20230217025615.1595558-1-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Reported-by: <syzbot+5f488e922d047d8f00cc@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alexander Ofitserov <oficerovas@altlinux.org>
Cc: stable@vger.kernel.org
[ Ajay: Modified to apply on v6.1 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
---
 arch/x86/mm/pat/memtype.c | 12 ++++++++----
 include/linux/pgtable.h   |  7 ++++---
 mm/memory.c               |  1 +
 mm/mremap.c               |  2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index d6fe9093e..1ad881017 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -1137,11 +1137,15 @@ void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
 }
 
 /*
- * untrack_pfn_moved is called, while mremapping a pfnmap for a new region,
- * with the old vma after its pfnmap page table has been removed.  The new
- * vma has a new pfnmap to the same pfn & cache type with VM_PAT set.
+ * untrack_pfn_clear is called if the following situation fits:
+ *
+ * 1) while mremapping a pfnmap for a new region,  with the old vma after
+ * its pfnmap page table has been removed.  The new vma has a new pfnmap
+ * to the same pfn & cache type with VM_PAT set.
+ * 2) while duplicating vm area, the new vma fails to copy the pgtable from
+ * old vma.
  */
-void untrack_pfn_moved(struct vm_area_struct *vma)
+void untrack_pfn_clear(struct vm_area_struct *vma)
 {
 	vma->vm_flags &= ~VM_PAT;
 }
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 82d78cba7..500a612ff 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1214,9 +1214,10 @@ static inline void untrack_pfn(struct vm_area_struct *vma,
 }
 
 /*
- * untrack_pfn_moved is called while mremapping a pfnmap for a new region.
+ * untrack_pfn_clear is called while mremapping a pfnmap for a new region
+ * or fails to copy pgtable during duplicate vm area.
  */
-static inline void untrack_pfn_moved(struct vm_area_struct *vma)
+static inline void untrack_pfn_clear(struct vm_area_struct *vma)
 {
 }
 #else
@@ -1228,7 +1229,7 @@ extern void track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
 extern int track_pfn_copy(struct vm_area_struct *vma);
 extern void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
 			unsigned long size);
-extern void untrack_pfn_moved(struct vm_area_struct *vma);
+extern void untrack_pfn_clear(struct vm_area_struct *vma);
 #endif
 
 #ifdef CONFIG_MMU
diff --git a/mm/memory.c b/mm/memory.c
index 454d91844..41a03adcf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1335,6 +1335,7 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 			continue;
 		if (unlikely(copy_p4d_range(dst_vma, src_vma, dst_pgd, src_pgd,
 					    addr, next))) {
+			untrack_pfn_clear(dst_vma);
 			ret = -ENOMEM;
 			break;
 		}
diff --git a/mm/mremap.c b/mm/mremap.c
index 930f65c31..6ed28eeae 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -682,7 +682,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 
 	/* Tell pfnmap has moved from this vma */
 	if (unlikely(vma->vm_flags & VM_PFNMAP))
-		untrack_pfn_moved(vma);
+		untrack_pfn_clear(vma);
 
 	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
-- 
2.40.4


