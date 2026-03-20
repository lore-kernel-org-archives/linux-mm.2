Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C93A108B905
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4EA6B0005; Fri, 20 Mar 2026 07:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66086B0088; Fri, 20 Mar 2026 07:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B966B0089; Fri, 20 Mar 2026 07:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 870786B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:52:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF8A21B6D8D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:52:20 +0000 (UTC)
X-FDA: 84566278440.26.2711D13
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id EDA5540009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:52:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pDdnElzp;
	spf=pass (imf07.hostedemail.com: domain of 38TS9aQsKCKQNSSRaSROERKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--joonwonkang.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=38TS9aQsKCKQNSSRaSROERKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774007539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gU69MYAltTpsVwDKd9QeUs/oT95TyhbpJovXUD5z/eo=;
	b=eUbqVQAVij4VaFhw/AUA4UX3CEMrX41qgyCyEL3p0GXTHny3P/SlYXSdIYX0vp1ID+tTTq
	jJM5Yp/ozFWMu+jvg+f13CUe7NUU7VtCdwe10GxP2Hoa2qGGS6Pw4z9l8ptF5X3YDTMBsA
	5ORMqd2mZg6pgX4du+dod0j3G+Vnw9E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774007539; a=rsa-sha256;
	cv=none;
	b=XhDfwwbgqzcwOOtjVCO2fm8Vt8kylT2B9kl3jnyh9y7iW/NEu1cNJz2cVoNrDqIjrPj9v0
	b+SZEG12RhdGG3qOpau6Jp98WsAukWA2pPWUn7hZKWzpMmNCiVOrK/zbfFt1oHCWtHup34
	dW2BAV76eAhd0lIYYeiLLVV/AMXyitg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pDdnElzp;
	spf=pass (imf07.hostedemail.com: domain of 38TS9aQsKCKQNSSRaSROERKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--joonwonkang.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=38TS9aQsKCKQNSSRaSROERKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35842aa350fso9349875a91.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774007538; x=1774612338; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gU69MYAltTpsVwDKd9QeUs/oT95TyhbpJovXUD5z/eo=;
        b=pDdnElzpYKtQBguH8YeToR0wxqY1wXKhJkt612MPIqf+SlAy7n1uUs8moa9g1otbvL
         dVQOVixnOjqSXQHl78KuF5O7GuzdNKW9swLUzLQ87xt1WhrDnaDrn9n7FzQwOBrWEjeC
         tgFhaNGW4CtzeqS10NiJuuJfD731vKS+UZGaXgds7nY/r143p5aDmRNpyWyYIRCpkW5W
         S2dFw1+6cS9lvAmoVEPmEPYuVsOSyMrTv/xjFTq1SHHtpyEDFKTfhDVVn+voXATX58JP
         tHVYXlo6SPjqqSaCAM7KSqjALKcTrvMRCBxzmTNc8avWSGzSM6A4v6yw6kp1sLWQ0H80
         UrVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774007538; x=1774612338;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gU69MYAltTpsVwDKd9QeUs/oT95TyhbpJovXUD5z/eo=;
        b=kfIY2JfqW1N4Ij7kzIxM3hLMCPWhwAua6RabJOdD+5WFch2hsJUqfflEgO5UrFK4Ge
         ElvxFCNd6MSE815Kaa3I9oME1UC5P06t9prVjPTOFq89xbvlomBV6GcfIDTyoDzcpqOt
         bBJa8A95BzmQe4GPOM4HirK7ZbBdGY0gL+IVq0LlAHwQaFnZp12cEjouIg5Jy0e9ydSL
         VEhT/bMwl4BqNdp+dBCpeH5gpQWQLo4G+YqYvOt7G1+8jaILuL1fY8Yxi9Ni1JeGepwh
         vcQsa0zA6phqlTim4z3v+PnWrMKXiT/ILBb2eZ2u8fKbqPEiqm8fXZm2wUxshwx4fMc/
         L70A==
X-Forwarded-Encrypted: i=1; AJvYcCUspraSdjc5fDzftC3pCVIkZdozjgJePNeTKAfnbsEFuub17S10YZJpnioEiqeO8U7HpCV5FZcfCQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7XgCmuzqPJektEE0Q0icpAUzr4wREhDgPGMd5vress8h6NFR/
	l9/8CDGSCYT3Z/HmriIYsabqQmMDxNNC3spewgsfhffE2J5Qr8QI3nFo236VnPUVw8naxweJgeG
	bDixs2x2JhS1Lkx2TOtv5L0N5Zw==
X-Received: from pjzd9.prod.google.com ([2002:a17:90a:e289:b0:356:1f2b:7ea1])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c8e:b0:35b:93d8:6aaa with SMTP id 98e67ed59e1d1-35bd2cf8065mr2240997a91.19.1774007537556;
 Fri, 20 Mar 2026 04:52:17 -0700 (PDT)
Date: Fri, 20 Mar 2026 11:52:14 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260320115214.143933-1-joonwonkang@google.com>
Subject: [PATCH] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Joonwon Kang <joonwonkang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EDA5540009
X-Stat-Signature: s37a5ff9an5ebpjruekmdft81hbdajwy
X-HE-Tag: 1774007538-14581
X-HE-Meta: U2FsdGVkX1/GqeNWbc3LYpP47S7zqnHIMdU/A/y60hXbl60OR2x46nuVeni0GehBuUR82DSpmNtGTiEGhWVBJUn4EJpFtUXfU3Tn60iYdxqd5GXF3yyp+UtAUhnK5xWrbZKjz+z2T+aYKoAN4GocrUiFdhGwjx1akBKYZFJTaY20j5Y5NwDswVFf6Dji9NudZFyd8eMZklYgTNz4HEJHQdscZ4vVN0b6JzDYZuWgaTY9+q8rLnTQakSjcRcrnt6gl/O59UYDmE+NMLalrrc9D8v6/BDGLzbWtGcJjA/h9hByDC28JwqpZooXUrwX1AWoNinAC+hlDeCdrT3Xmixfx/5tUew+BR06Ijz9Ewy+v2mo9m4B7DlXEWzATOydlZXFuPW0+70QACzSkpPJ0E+gnjOGSp58m7u5fBYIB2uSrIMOGyaSFAmIQZTHzMzoupN3q5rNXqGHWBW56gJKp36RbKuEZL8KuD39Q7efhDXnmqxSqUpsZT5yl6rMI8G7Wpns6/DuF2xEoEisqmT3lX6Rf3g7D4DBpoAQ+9MKe4BQjrkFgnesOPOw5UDivOuNqhA+0A6mWbrkViPzRa7T/D+Cb809JPf/XmLIw5bdDmGNKeahFKvC522Tr7V29rDWwhf8vTcSsQEE4m2v85loZ5LUVMuFH2Xo6niIaXQFQdI+qR38usbHSluTqCAry9EFm8XtongqhTucjF1T5V/OjnYZTEGDqRU+9ZKgnwOcU6tP7RN1Xm3eeXiuh5cbYYU2ysy7pPY6DYqtb7UV/5nENPwUD3YY5RxCtlN7UWbUy0H1y7ovW9jWoDGXX1iEkT371bq5MoJa1+t2XcW0UmatFU9IDu6L+GUAwYd5fB7W2Je0XrrH11Q5GqxpLvmbIFnqajlLcqn7R85QNP/bjqgVqzL6sYGsRM48BLIZJ76m4lvpMI2Xs/Xjk0ltCdBpL1sTyZR5/rdiwCtdgeYcHxdkkNK
 kFzs1+00
 OGOCHGZ9rBFIx3Aw1kM0Lwfs6fBfYFGmvcDypsmqtKSyZPIcx4kqaqY5c7RhJw2U76Vo/2BR3y7xHRrPMdLgzIjAFP81nvfvVq2hBZN/G4idor4f8hXRBT+TfpGafYg74cc8Glj7KvI1b/ecs1PtJpbEn8iC96nanCbatQzYanNMMQt3kXHR7NkUpWKjhnKxUq2IiONlwdpVKi3WOxYn7LV7XLqeuKjRYo5froHqJCjcVVWtJXznHAMDQxM/1yAI8IFrJIFFBC6Y3+Mu9ItbVuwxUYmN6K6wyXffw5grzTeeZh9SIeFrL43fVw1hWCSyey/Ta+yv1mc04+n5FD7WFVNXoZZfa2ZTlAj/UIonV8Ue9YjkY31HIrOKVH4pdxxJXMjbvUEaslOD12dTL4A9GAZXysr9yqV2ly2YWz5zJORs/n5sy+Vmv4T2fDoON7piDrQXsJ3H6PxjnreKtmjF/m6ZNZSnlcacyySYGGzF6mfWZ7to4SN2wGNSXj3VN7qpM24IeQA+8c0UJ+awpjBUKYQFe+pse+muyFejlIMDVyj9vR1Uiwk0fewmW22/N6UxBpaZoMCBrsshTUvb+2hYyHPai0JtCq6L3aivRbO9rvs1MgN/qrGCK4UqyiOevYw/tq6BBhmnaBtJfcKel1qKFVPjt0rHi/TS9Eodv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The invariant "scan_hint_start > contig_hint_start if and only if
scan_hint == contig_hint" should be kept for hint management. However,
it could be broken in some cases:

  - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
    scan_hint_start < new contig start) && the new contig is to become a
    new contig_hint due to its better alignment, then scan_hint should
    be invalidated instead of keeping it.

  - if (new contig == contig_hint > scan_hint) && (start <
    contig_hint_start) && the new contig is not to become a new
    contig_hint, then scan_hint should be invalidated instead of being
    updated to the new contig.

This commit fixes this invariant breakage and also optimizes scan_hint
by keeping it or updating it when acceptable:

  - if (new contig > contig_hint > scan_hint) && (scan_hint_start < new
    contig start < contig_hint_start), then keep scan_hint instead of
    invalidating it.

  - if (new contig > contig_hint == scan_hint) && (contig_hint_start <
    new contig start < scan_hint_start), then update scan_hint to the
    old contig_hint instead of invalidating it.

  - if (new contig == contig_hint > scan_hint) && (new contig start <
    contig_hint_start) && the new contig is to become a new contig_hint
    due to its better alignment, then update scan_hint to the old
    contig_hint instead of invalidating or keeping it.

Signed-off-by: Joonwon Kang <joonwonkang@google.com>
---
 mm/percpu.c | 60 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 21 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e..a0e4f8acb7c2 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -641,19 +641,13 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 	if (contig > block->contig_hint) {
 		/* promote the old contig_hint to be the new scan_hint */
 		if (start > block->contig_hint_start) {
-			if (block->contig_hint > block->scan_hint) {
+			if (block->contig_hint > block->scan_hint ||
+			    start < block->scan_hint_start) {
 				block->scan_hint_start =
 					block->contig_hint_start;
 				block->scan_hint = block->contig_hint;
-			} else if (start < block->scan_hint_start) {
-				/*
-				 * The old contig_hint == scan_hint.  But, the
-				 * new contig is larger so hold the invariant
-				 * scan_hint_start < contig_hint_start.
-				 */
-				block->scan_hint = 0;
 			}
-		} else {
+		} else if (start < block->scan_hint_start) {
 			block->scan_hint = 0;
 		}
 		block->contig_hint_start = start;
@@ -662,20 +656,44 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 		if (block->contig_hint_start &&
 		    (!start ||
 		     __ffs(start) > __ffs(block->contig_hint_start))) {
+			if (block->contig_hint > block->scan_hint) {
+				if (start < block->contig_hint_start) {
+					block->scan_hint = block->contig_hint;
+					block->scan_hint_start = block->contig_hint_start;
+				}
+			} else if (start > block->scan_hint_start) {
+				/*
+				 * old contig_hint == old scan_hint == contig.
+				 * But, the new contig is farther than the old
+				 * scan_hint so hold the invariant
+				 * scan_hint_start > contig_hint_start iff
+				 * scan_hint == contig_hint.
+				 */
+				block->scan_hint = 0;
+			}
+
 			/* start has a better alignment so use it */
 			block->contig_hint_start = start;
-			if (start < block->scan_hint_start &&
-			    block->contig_hint > block->scan_hint)
-				block->scan_hint = 0;
-		} else if (start > block->scan_hint_start ||
-			   block->contig_hint > block->scan_hint) {
-			/*
-			 * Knowing contig == contig_hint, update the scan_hint
-			 * if it is farther than or larger than the current
-			 * scan_hint.
-			 */
-			block->scan_hint_start = start;
-			block->scan_hint = contig;
+		} else {
+			if (block->contig_hint > block->scan_hint) {
+				if (start < block->contig_hint_start) {
+					/*
+					 * old scan_hint < contig == old
+					 * contig_hint. But, the new contig is
+					 * before the old contig_hint so hold
+					 * the invariant
+					 * scan_hint_start > contig_hint_start
+					 * iff scan_hint == contig_hint.
+					 */
+					block->scan_hint = 0;
+				} else {
+					block->scan_hint_start = start;
+					block->scan_hint = contig;
+				}
+			} else if (start > block->scan_hint_start) {
+				block->scan_hint_start = start;
+				block->scan_hint = contig;
+			}
 		}
 	} else {
 		/*
-- 
2.53.0.1018.g2bb0e51243-goog


