Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C1C1CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1057A6B009B; Fri, 15 May 2026 08:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F3E6B009D; Fri, 15 May 2026 08:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4B766B009E; Fri, 15 May 2026 08:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CFB1E6B009B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:44:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8529D40843
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:44:10 +0000 (UTC)
X-FDA: 84769621860.26.15E80A4
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id B2233C0009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:44:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EF4RzdUd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778849048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tc1Hi4hRis6nDBLT1nxBblw8j7Bbw8+zpnBKWgjEvE=;
	b=H25KU4Xxg+KedlKx4Jut26TZw7dMM9AtKnwWcgKNgIr1Ma8enq0D0hn3pLSVvtM0RXwtnS
	Vd3brJadL2ymMWcs7hgjUn1R1q2H1gtUhLYSYNkDeZDtqCmSJ2OD6Vb8G1IyML5HD2JR0C
	DyPkmoh8qsE7ANFZJeYoN9wkrBGbYMs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778849048; a=rsa-sha256;
	cv=none;
	b=ot2oFGRMSKfgh3tybCAUjE78qHLvH2keccuP9ECg5aYXNN1GwC9yh+vQq0BjFbe4JKV0pr
	n7MRWquPZO+2f5KHDk8/NIZpYDRJSjP2ZmF5LTnx1NORf3gfCbbcJdSbWURpKV8Dc/KFdj
	meRweUKDtCYLGT2wRLmpoljl+larx3o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EF4RzdUd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so151023305e9.2
        for <linux-mm@kvack.org>; Fri, 15 May 2026 05:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778849047; x=1779453847; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6tc1Hi4hRis6nDBLT1nxBblw8j7Bbw8+zpnBKWgjEvE=;
        b=EF4RzdUd+KSldvuTpVMZopPqotaE1HKgrXa0aUMt9Tt/OEDvNIbf1HksRxMwN+KFA5
         +NrSCrHUYNw9TbFzgUoyNHpzybVzOEy/Wv1rL9WZWnmgujYKl6d3unEFAm9dO1CrmYAY
         CUAwkj5lxud1SN+4W/9cVSQPXGwDojDPxibvHTRtPN3O5qoqN/UZ/t2NRHlC3Kcj0+ev
         lmoEZI1CqRmeIrpp3cDbwL7Hu4Z8M9iifl/2kCWmugHqnRfhemds41YakUNltBsMJnrK
         5upssK6FYUViydII4DhL1jZEMyL54GD9d7FTTnpDDmFIw/G8ExqF8dr2zzpxM3GFTcmZ
         FrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778849047; x=1779453847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6tc1Hi4hRis6nDBLT1nxBblw8j7Bbw8+zpnBKWgjEvE=;
        b=Qygcj+cSlp8c31EZWnH68zOw/cazbq0JxD/xjMeinYTXrDFnH5BMGBODLRB0Pse8iw
         f/pSBhzrAEWLbHnzHlhVP2nv9OhtZOiVllzQXNvhvV/cwE8qpFqiR1Jv4BtWiIWfcc7K
         GOjN/4s7207uWrWBFb8p8DsoKj7IbO0QPdsLt09iu50jc5Kl9SI4B3yoXL0pQF5GPKDF
         sYDdg4ZjQgU3kDjkQtkqXHODRmisDflEcwmbc6EL3PXV4qcDMifGfk1rfLRsY6vF962a
         ENubbtpEB9pWR0I6IbQbEnjNkevurPNUvJ27DNb9SgvMNfCdH4c/KrAXZzfLz6KtVXYE
         xtzA==
X-Gm-Message-State: AOJu0Yy9X0F9RmyAgyhpYTn1dvM5gHCGhCVZr2pSTSRvARVNOAGbH/60
	xnykzQOVMa977qf20rGlNfhDDqLQS+01wjgKqKipMKODHQkSVKlntF0Q
X-Gm-Gg: Acq92OFQIz3NAdLfpw4Qu0wtjnnz6EmluxXmhwuHeepeIPRrvNMz57wYnRlY+G9NwRz
	Ca7oQw2Q5Od0wyvzZVQ1LibyHehJmyHFBwBJuGrC67JSgaTWNxC+93R+PIPcX5Ip/tRH5cWqvdR
	sThuP24iYJ+8PzhLIK+zok6fjkpMe2wTeu0C+Pu8g/aTHL8s9PAaeWXcJSpTvOwLNk52Erls9nz
	1+zeWgWE1w371BkZKgP9N3478zuruONaH2vFxT+hc30EE/uaujH6LzoAfKHuzwHY2meIrtjye/t
	WhFWW4kHqXmTO+BuDtFxmmdRPjPjtYcEC4G5cWgZLxSbkn+oqArgwHv7TI0OzMtopyooHJuStCs
	8KPRr7AkNK/FG2FMbTUiS5DigBLwznb2c/7no5R4oehqGeNoVVAxKnZuGWFBIwNmaIuUMRH2v9h
	M+AiL5HkEiatp0zrWovOfHR1IysNxnoA==
X-Received: by 2002:a05:600c:8184:b0:485:46fd:7887 with SMTP id 5b1f17b1804b1-48fe60edcefmr49132125e9.13.1778849047119;
        Fri, 15 May 2026 05:44:07 -0700 (PDT)
Received: from fedora ([156.207.183.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c8344asm100188115e9.1.2026.05.15.05.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 05:44:06 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	avagin@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Jann Horn <jannh@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH v4 8/9] mm: propagate VM_SOFTDIRTY on merge
Date: Fri, 15 May 2026 15:42:18 +0300
Message-ID: <20260515124218.151966-10-elaidya225@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515124218.151966-2-elaidya225@gmail.com>
References: <20260515124218.151966-2-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B2233C0009
X-Rspamd-Server: rspam04
X-Stat-Signature: nu99xjbnat9jotrbpbbiag6khack3hp9
X-HE-Tag: 1778849048-814750
X-HE-Meta: U2FsdGVkX1874TVrfwDmtweRivzkCeonVzmftrxMBblfo0F+kXFeZ3dukT+7/GPTfBCjCKUOlzCc3ttIKJNhZCybWjp6AehQUqiQT8xlsmLKEofO3GbmxISSMycfAitZs7BKekyIhalhzUUsvO/uycN8cUIbxpwz3zUKHMYuLXfe56ROnaRHEP6LMLaMIMV3o108lbVJ+tdxqN28pSWHhcoWDQNxSD2dLW+/bRW6rrZrlbAwXmavDodj3dK8G++nR73uXZ1eOy2HuT6WC+BnSam2RtlZWZKU/NB8sEtcg5ovzQZBgaFBP09GIVzorVIPKBKsR6QYXyTzUMMSCqS/emcDJZ9F4kMwiGrLGtCqdFRJSBOlRfEKca4lloGhGwFFZ+1B7s0QX5ZWAQqyT0RcPuFv4XXVK/p/Y5xqS1kc1wnCmWtIl2Bpp8sXSUAtnDyDlA5vjxPz6awio5K/5cbZCbU8avwcFTql4xN9YjUf9umyAYDeL4rvngflg2O3LGsCZxTt8j4E81SL7oHPx/+GySMS1XU1qstrZh1z6kB6/PcUWcLHK8PE+/ohfa4KeFSfziMlOXnVVdsXyflDetDYibTmoEEMnv01SI+NQTNwWXYW74RHYHIYKwKFw1RA7E+jqBVEP4JTcdQiFX72HkVpnUvS59EFOLI1Qe5ry+vPgYorFLLGROOQq27+0JPztS87Ke4gDGg1sp19sNyYekrL/y7O2sDNL/VSx7SSb1f0/eiY0XYBGs0bU0KtSFRrkopk687Mg6VinJHeaUas9e9J6tWilAG/+uRyt6bCEwQ7KGx26A4sFALSOJvTb7nETXe2AzByW8yCIuPWmSDKQfcFS0vCPMXKkeSnXz9nf4AbnFQ8FO+kqrdQyZvtPMcBVNJuhLjlgk9NEgGAqCun8QHG4p6kMfzmmuhDrrbRMAWJ6dpSZ0XZB8sQWphi+vcK+QlhJcSh+jdMD1IE6Qm48fy
 YmG73ej0
 7FFLFunFr1i4v2AioDFV+yCyKLgFGWykslPpcb5xOIQPD3+Q31jw0D2PVYGmJNhiC71T0N8t0SPvc5FDhWsRIXlWloGRvTB5M0zM88tRDJh2zB/YEZgijlAPooDpceyAZ0EVqn+E0jn59epxdp8wrSz0JBCVysBIRbGRFfokxJeEToqpy9Mw+zgwWoqD9KN5QC3QLjiCFHV0vjOAf5Df+mefE+L6+4ZRyHLCDqTDFDm52eWTe6ih1S5s0RQ4BUCTQqLL9tAKBVjiYohk+JIozTvz2yX0ThKf8SpZGm4ErV2G9y0OpqE7qKzC9+T+VFmuCGQN06odgEHfUEsXRD1u6r1R6XaYpIoSQV45m0I2+MjEw/JKzKbeCwuMb8kgSX7G3rXBabh++VX4K9UCfISQfAAVtwkENYtNS4MOf+3LE2rY6kpNZcEvrph2NL5suJBweeobf1Q2MTA8yS3RdBojq+Q9Z+mb9Sktn3M3BwGGiWbyadpl+joGRVvdjbVZ19J2E1tHlzUl/lZlLjNkci/+MG6dj8GmA1/REKwohFlmAp2TVnjIRI5fAfZ7C3abrjTOyQvBDUlAGoWOtGrVP3npN/xaLYqBhzOK1wvvQKAH+hYY9X6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Patch series "make VM_SOFTDIRTY a sticky VMA flag", v2.

Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
establishing a new VMA, or via merge) as implemented in __mmap_complete()
and do_brk_flags().

However, when performing a merge of existing mappings such as when
performing mprotect(), we may lose the VM_SOFTDIRTY flag.

Now we have the concept of making VMA flags 'sticky', that is that they
both don't prevent merge and, importantly, are propagated to merged VMAs,
this seems a sensible alternative to the existing special-casing of
VM_SOFTDIRTY.

We additionally add a self-test that demonstrates that this logic behaves
as expected.

This patch (of 2):

Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
establishing a new VMA, or via merge) as implemented in __mmap_complete()
and do_brk_flags().

However, when performing a merge of existing mappings such as when
performing mprotect(), we may lose the VM_SOFTDIRTY flag.

This is because currently we simply ignore VM_SOFTDIRTY for the purposes
of merge, so one VMA may possess the flag and another not, and whichever
happens to be the target VMA will be the one upon which the merge is
performed which may or may not have VM_SOFTDIRTY set.

Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
which solves this issue.

Additionally update VMA userland tests to propagate changes.

[akpm@linux-foundation.org: update comments, per Lorenzo]
  Link: https://lkml.kernel.org/r/0019e0b8-ee1e-4359-b5ee-94225cbe5588@lucifer.local
Link: https://lkml.kernel.org/r/cover.1763399675.git.ljs@kernel.org
Link: https://lkml.kernel.org/r/955478b5170715c895d1ef3b7f68e0cd77f76868.1763399675.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Andrey Vagin <avagin@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 6707915e030a3258868355f989b80140c1a45bbe)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>

Fixes: 34228d473efe ("mm: ignore VM_SOFTDIRTY on VMA merging")
Cc: stable@vger.kernel.org # 6.18.x
---
 include/linux/mm.h               | 15 +++++++--------
 tools/testing/vma/vma_internal.h | 18 ++++++------------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2bad4bf67d0f..a68bced816fe 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -515,28 +515,27 @@ extern unsigned int kobjsize(const void *objp);
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
+ *
  * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
  *                  mapped page tables may contain metadata not described by the
  *                  VMA and thus any merged VMA may also contain this metadata,
  *                  and thus we must make this flag sticky.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
  *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
  *                'sticky'. If any sticky flags exist in either VMA, we simply
  *                set all of them on the merged VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY
 
 /*
  * Flags which should result in page tables being copied on fork. These are
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 6ee803873e00..bff75a4c3c8c 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -122,28 +122,22 @@ extern unsigned long dac_mmap_min_addr;
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
- * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
- *                  mapped page tables may contain metadata not described by the
- *                  VMA and thus any merged VMA may also contain this metadata,
- *                  and thus we must make this flag sticky.
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
  *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
  *                'sticky'. If any sticky flags exist in either VMA, we simply
  *                set all of them on the merged VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY
 
 /*
  * Flags which should result in page tables being copied on fork. These are
-- 
2.54.0


