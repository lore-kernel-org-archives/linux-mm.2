Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3284CE8D4B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3062F8E0039; Fri, 14 Nov 2025 10:54:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE1E8E0029; Fri, 14 Nov 2025 10:54:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD118E0039; Fri, 14 Nov 2025 10:54:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08FA18E0029
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2CEC4CF2C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:16 +0000 (UTC)
X-FDA: 84109659312.02.34D9AFC
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id EEC8F180019
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eMTbcv5v;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKhHd1KgPWmocj3LIkR2PSOdJapJ90TJO0FtGZ1fNlc=;
	b=QLfanLY/fH46w+TJvIPRTj5mQhJQQs3c57Vnx6qOEUQ22HXnJD67FPVizG+vdauwaVTrq+
	2DQDZKgGBGo1ffogyvFB6SkF8TvIxiqizqPGosvK0SyhFuhq+VO3wUAze0lfjP3CONSz4o
	gEIarcPqZz3KcmFm1wI3dZRi5WI8/J0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eMTbcv5v;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135655; a=rsa-sha256;
	cv=none;
	b=oddqHMBJSp/hI8j0WUXq522+BoUpN1JHU5DuOdGzppDRcG2wsRv7dX6oX0IebaZMFA8gi4
	gm9YmKGjThrxXpD4UX8Rxqj44kXBg4mOcLZSaamLqXtqTfMQZuhbE9r53ZCBdvsF9MjCqJ
	MdOLPixag83KcQPimX3GMNVpH7mU9eQ=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-640d8b78608so1649692d50.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135654; x=1763740454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kKhHd1KgPWmocj3LIkR2PSOdJapJ90TJO0FtGZ1fNlc=;
        b=eMTbcv5vix14n6ZQe5mt06wawtURGI375oqKpYRm6IPpdxjrZhOA9ObxOUAmv5APQK
         Acd2Q9mniyIMdhXSVjuKexnq49OkJHYCc3wXvECCBviRyy2iMeJyN7899KZoTjtaVYre
         81QumRwlfff0QuXRcwtUYs5UHEXk38Xt7EWYf8ldfKRpevExc/2s2B1AtpYEj1iWlUA5
         CflBNGh5oaQAkUAUl8be/Lnei9wFjDdcGczf25r+rbv5UqkJAEp+XY5wKwH5E5/Ocjw3
         FSedX78GIC3wQPL4MXrydh8YI/xmawF2FXeHnXEQ80JDyFMXq7V8WDCStOWSu76Eb9gn
         I6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135654; x=1763740454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kKhHd1KgPWmocj3LIkR2PSOdJapJ90TJO0FtGZ1fNlc=;
        b=k8in9cTxgE9Mgkn2pbgCGTFTgi2rsMyXG7HfdBZBSC6l3f6BtpSdif2qoaOnNRs1Nl
         /GychrVbnq25YwntWXio6ACCpTLQzHInYHLlVyHa01iZsyfXpIFO5cvJ4lmDmobt+kFm
         PS23nkStukaP2f0CT5Q3qFBO1GmIAfFIOjKBud8B6BUWltway73xDQ415/w9DzXDmF8V
         DRKYCZhJQy8SXhf/Ri6fH1d9mFyOxpPCaW9wFnbUpNyOBrhd9LLyj6Y/7V6UeUuuheWz
         J9L5JgBsvpXoJVjd3HgMnsXQgjPafO3bwnh/ohxTz5s9a3U3mjl4DN3IXlSJGoVuX9h7
         bdPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJBR/H+3UJ4wpQQApeJJfsXM2Iu7Ybmc2D6bBHG9EOjuWGJZjzdtbfnWN5SWDNHaBtXZPibuK+oQ==@kvack.org
X-Gm-Message-State: AOJu0YxeF+coAg4CmANGQtiCFW57QDXC2VzkWmgbFGafoQLxkzHakX8Z
	zgheLwtaqmGIVfJLyqX26+DzybrvTkCxCWPr/qRUYWQcOCAzBAp9vTLoLox8igj/VMA=
X-Gm-Gg: ASbGnctQzLn6voPclVQCl7OHDN1ONdBjD6K2ldTzl54aVRtTSty0GvZTWMXxyOblXYr
	O04yL2WjKzUocTOmegD560pCebmuvXzdlBpGvC5UIIZMS6ue1cG7T27m97pwNn2XAVDGlJl+0Uo
	kyDTCxTED3f+Wo3c8Ht3Tdn4RsbixRG35G4GQGxRcm0WeWSL67ctAYPa4IsWgDHmexBnThjV9bO
	fG0q1noFHHY30sbavDCkUkfzTvRGUwaeh2Rqy6hhGpAs6SKVckqhk9X9RimidE23wnlx1GJCirM
	2SXdOWWrpZuSCJntjlsJy6oHxA7w4mi3rr3HMMlrXmkskKDzvcKCJk6O4kk9h/bnxbglMDNg+JX
	H3JbfycSWMNMAsBN7WQlkL+NiOg+MOyT4WKwPh4eB4XHQUoTSAbJifwF6AHRpiZbNAwzgtCxnsz
	C3rEx1ZvL65H9NZ9txdlab2dLhkA7V93BU+94T8tfkbMg0SuKfa4hap09wXKBn+Aba9uxj
X-Google-Smtp-Source: AGHT+IGiDMpoF1/OziCNFf3dCo0jW3YOO3Yc+5BO/O7YGqjVq/L6uWOIGV+2HHGmACM7asKY55998g==
X-Received: by 2002:a05:690e:1508:b0:636:d4ab:a507 with SMTP id 956f58d0204a3-641e74d6eaemr2931309d50.16.1763135654039;
        Fri, 14 Nov 2025 07:54:14 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:13 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v1 11/13] kho: Allow memory preservation state updates after finalization
Date: Fri, 14 Nov 2025 10:53:56 -0500
Message-ID: <20251114155358.2884014-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EEC8F180019
X-Stat-Signature: 7ciamy4qi5cmxebrroyq879swti1swo9
X-Rspam-User: 
X-HE-Tag: 1763135654-951895
X-HE-Meta: U2FsdGVkX187lvMvrQ6zYehAvzjzRBU1KegNpUqo6WSvCHRdkGeJQNH9WrA4NwQLyqgj5undutNpHdclsdKbm3doXlEEjlSZPZmPVJrD9zGGJghsX5giapGHhFJhUTdUM5G5RXBj+B29qS1PtJRvdR+11fAp0W7v5m1LM+W0bgmbfiXv/k/Xw11nG4kUWtueqO8XABaOPhMSyHBsA1c+X1yTCPdfOxnQ7BUHVv6DIGwAXnbfhTL+AZOk1R/n39MPkT5plyQ1aiecW3EM4n5yfikF1wrTlfvU65wleyv6VRWBl1u8hMjRfEG/khakSmcB7bBzWq60qwc67pLY5W2dl6P+Cf3yWoZm/BVV1cDZsN6sGu2TJoZHKYTxTQFVUFUsk0oCozNj78PyDcaDvvvWcCng5IweGj2FoKN30wS5WYct0Te7ZGLclzrx1sY1qL694UD8S1mEzJdiJDNphEharf2wGDMMTF8+LG+vZCpB6Pdp45U+LCdDr5ZM0qRZylCkX6vXKojGRK6Wnl8afz5PuTVJY1OpEga/7xr7mW5aJkI4qowf2bGT6HPuDexl3KAqHzsU7uB49FNnG3KYNKIa35An9Xc9atXxC8axFWqJMv3UZElbIcWBalz81oXV3NSphUyCCyWwch+viPEjZZ8ucNjz8BQxrZH+BR1p+pc00jxrhTNV/Xzqnw0lKuZBcD/zDfrG5xaEg5O2w409PN89TInpu2nyLkmnVBlOlxDR/bsqlovSrcqegVtImxcQQPUTqCd1xlOX43JTKnROa4ydF0kOXbJ5AhqphSzbZSWWsCa0jX++f2CjPlajcI7YwmRHA3gh+ghdQaYhfsqQ8XkEL/Uibzk2u845cX4Jvt2ev1n0y1LW6Y2NgRHH6w/y+nME6EzsjwC7cZNOgi8J0e0+ZXHXhSG3DUASrNsl1fodMy0jePegX5RgL2S/KuHqk8GICTFVmbsRzdjz7F6n5VL
 CRJMqqht
 ITJrnFuIwDd5YF03geSVQM72OvBXJzRpw9UQBDd7J73wlkJW08Vd62EKAsk47Ik42pT/qYdDz5fUtwaQrGhRq28l9/Z6AumRm7rCnzQ0Xdd2WAM7JKZuzJlmtklie1Z429hOZZysUoua3+y8RHfctdF+UFCCYxdcWw6LIR24tGJKMfXMMAFFNYDl5jhY2ZytfdWwcmNYpLWdI9YyzEUsj3cDMc6i0/yq1G5ODJ4t9doFbZM2O5BQrfI7WpNGhUtNqU0wkSL0DTRcfIdh6FJVOi6BbcGPfywuWPCkFcFnihfBZfK05EE0Ca3/ohbqtSKykt+2PBbqjXIBdCQI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, kho_preserve_* and kho_unpreserve_* return -EBUSY if
KHO is finalized. This enforces a rigid "freeze" on the KHO memory
state.

With the introduction of re-entrant finalization, this restriction is
no longer necessary. Users should be allowed to modify the preservation
set (e.g., adding new pages or freeing old ones) even after an initial
finalization.

The intended workflow for updates is now:
1. Modify state (preserve/unpreserve).
2. Call kho_finalize() again to refresh the serialized metadata.

Remove the kho_out.finalized checks to enable this dynamic behavior.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 27ef20565a5f..87e9b488237d 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -183,10 +183,6 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 	const unsigned long pfn_high = pfn >> order;
 
 	might_sleep();
-
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	physxa = xa_load(&track->orders, order);
 	if (!physxa) {
 		int err;
@@ -815,9 +811,6 @@ int kho_unpreserve_folio(struct folio *folio)
 	const unsigned int order = folio_order(folio);
 	struct kho_mem_track *track = &kho_out.track;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	__kho_unpreserve_order(track, pfn, order);
 	return 0;
 }
@@ -885,9 +878,6 @@ int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
 	const unsigned long start_pfn = page_to_pfn(page);
 	const unsigned long end_pfn = start_pfn + nr_pages;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	__kho_unpreserve(track, start_pfn, end_pfn);
 
 	return 0;
@@ -1066,9 +1056,6 @@ EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
  */
 int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
 {
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	kho_vmalloc_free_chunks(preservation);
 
 	return 0;
-- 
2.52.0.rc1.455.g30608eb744-goog


