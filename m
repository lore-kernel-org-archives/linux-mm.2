Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B78BBCCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 10:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE048E0165; Sun, 26 Oct 2025 06:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F178E0150; Sun, 26 Oct 2025 06:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0673B8E0165; Sun, 26 Oct 2025 06:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E22B08E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 06:03:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5C9AC026B
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:03:06 +0000 (UTC)
X-FDA: 84039827172.22.934072C
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id CF002C0008
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:03:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ON4LbMrd;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761472984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qv3xbgzWscSD1bGLEjSMP2LBFninQO/a156OhJUr9XU=;
	b=zkb+5mkF52cFDULQ+kkcMER6hmojsOIeCJACVFlj1oZksyiZPqxA7R5KqKoI4KikVg5XXw
	z34X+s+E6WYZgdwO6eQ6gCjhEPEDpecyOhGsQoPp5qQrMibUGgUjijT6JcBGKMGiF5li0f
	t2pCmpWjXJ5xiJoPPv52kYiFF4UIv34=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ON4LbMrd;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761472984; a=rsa-sha256;
	cv=none;
	b=fbvhSDnsjm67iOas02q8F7un/TgD/3lJLTQbOrIV66OxNKiXRPTQkBn/YesWc7zrhZaL4h
	DQFI+/+aqbj8c+QQbr6vGLLg9N+WKJymLL5evek/rEAS8Dnin+m5gDdBOUeA1yp3LkOBFI
	n7cXNDk6q6GspIDqcVjwiff/wVyCzMI=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-33bcf228ee4so3101217a91.1
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 03:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761472984; x=1762077784; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qv3xbgzWscSD1bGLEjSMP2LBFninQO/a156OhJUr9XU=;
        b=ON4LbMrdG7Eev9clrcblcQ5b91nR8U2+ewqfGLVwXH6nt8HqdIasYo/5wXoIXZz4tZ
         mHp/bc1/D2s9KQtsNyvH6R6getyd7ermQ0TBVcHfvWKO3KK85HeaoYSbMTOpcxTE3Drg
         AytJk4BPvBR7L5R15T0vAFhYgxG/mOsFapKAT4DLl6jJRpHRwohDhf1pwu+tgugfFu/w
         /DVWQzYlhZdYrd9s3LLlQnPy3yqc/QuyXDA7lDGNmOPZsG0XypoolEsV2rfN8bzQUiO5
         WGQwYE6xywv/uW/m9YPYd0fk4+uGDpTBE9mySGDfh24axKMYjwIB9gQteDLknt2sDICd
         hoDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761472984; x=1762077784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qv3xbgzWscSD1bGLEjSMP2LBFninQO/a156OhJUr9XU=;
        b=QHKV8s1OOBhifAOFE9E226pD7XOj2TwbqkfhmiRK4xd7WC4A4i79m77LTVfmQ8LDFQ
         knPFU9oZ3gSl0SYXEVlR1Gibj2Yh3sHpX+I6kM1dBdYKeF8iSg0qjPLdnJXLQZa75pSs
         1etblfTcE+4ZCLAgWaFg30Ichbg/j3yJU+uWLwrqUBQfpBQODTx04dcf/7m3IICbr5oj
         F6UXy8loemizKrhz3DsdRYmRuARS+XBlrSf1JWiNdU5xys1i8gDFmGCr4BrDGkWr7PSd
         +hcsC/EKxNRpX23QaGoIRC5XseVPx4dpnlhdbxSvfRqeRAraJgzEAlwsjoHFNA0DCx48
         HloQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFwZhhPyLbYSvKWmstDI9GWmejSuPDkqX5vzlaljDwm8X7dw2RVvwplXIbwUwtsQE0h0ftalulRA==@kvack.org
X-Gm-Message-State: AOJu0YzSqsQjFWwZeKu3O9FGggbWEwwxWosPFW1Uz5A3ecbOalqUi8Yh
	hklfkKoZVQ7c7embHSPdP/ha5vAEx9orKtmvmcOgiFNR1+DGRzjG0nfS
X-Gm-Gg: ASbGncsiMcSeNgUmDCaAUgCh7P7+p9AYftYoJ5YYhYrdqcxAQK+rYStJKvRROYpgRyq
	dY2e6O2Qw4LXFIsfLU81lEmc5Hh/Iy4Rp9/bZLW+IavM+uS6Y+7ZFQQDXvT7VHQHdH7SDJTSbFv
	A4tPmxTkQV2S1nrXmyKYBBrFObY+GKRktTV99H2sDV7bgPuaoXbglY/fbBtc6KaFKEYbqB1xbO3
	yo/EXplMWd1GNQ0jbRXqLGo2Y0I0nrCk6XKcTVZL21q1U0mi/KpIdEXsr56vYewccQYBpiCElLw
	v8rpnTCV/Oed37Cpa/wmwfJFJyawyM2bavEMhBK4wh4fj+rklLTZlaCZwKgN0LaCsiLcRVbtv45
	7hfymSNP/kiIgKbt+1TwjEv9cHZzoqCp50dGXWmzWWT/aYv6HjztITQOlgOf9b/Pr+HmkV/F1AU
	rrWtTueLooUV0SLqrz1VBe3JCiN8ZEzp27R5g=
X-Google-Smtp-Source: AGHT+IHumIu4Yiorz3nhZEBFgPf6IDz83EuHAByQ4wLOjx+CQb65VNu5bzBy24T85rvogYoDnqvUKA==
X-Received: by 2002:a17:90b:1dc6:b0:339:a4ef:c8b1 with SMTP id 98e67ed59e1d1-33bcf8f7802mr42446552a91.22.1761472983515;
        Sun, 26 Oct 2025 03:03:03 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1a84:d:452e:d344:ffb:662b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7d1fdesm4824966a91.5.2025.10.26.03.02.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Oct 2025 03:03:03 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org,
	clm@meta.com,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v12 mm-new 05/10] mm: thp: enable THP allocation exclusively through khugepaged
Date: Sun, 26 Oct 2025 18:01:54 +0800
Message-Id: <20251026100159.6103-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251026100159.6103-1-laoar.shao@gmail.com>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nfb9hsg9g85hxensz4c7henm3zwgd55o
X-Rspamd-Queue-Id: CF002C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761472984-320759
X-HE-Meta: U2FsdGVkX18E7WXqjrxDJUbuuFPTLiVMHHNWlC3mSabc4J6W0IVh8zWBeGwbwFhULKfIt2DtNHSLOvhjxEoiSckBPWCieTksw8Ol+OaHbMmJ44gnDpLWL2LT2jAIWNcN2ckS/NPk1mZse4PMojbNudWz72xMLc39Ho79nexp6mEeav1hTgK2rT/D7sI4vIWhp9ZchAyWEjLfZr7hQzWX/Nrcht1MHBGpGF40RwPWUqmiMP/Du6ABB5OVJoOQZeoX97mGiUX+ucnyMd91CzORUAGS1A+E7C0g9HwKSJdFJemP5FxTNycrHfA4KOZJDKhFh2Q9XM2CdB/3iFo4Oc8CwuPoRFpDgFgLvzWYZjk888AtiH4K2U8Ue03NSc4u79J82f85TkE81DzWkNhHtB0IOCdvN7L/QCqU4YgbpouRZuNjz41pAtGpr/sF7UFnIoOa/U5iWK1OLJPraMoFT6b3ZJ/+sp8q+rRmXkjSAf+/XaE1Qr6tk9gNJFnwwqGIMRQ95O9kWjy2swLRZe2X4YUoo1zwQLEfvkOaFNvLxUV5ya7C1pFAOUEky+6OWpvV1nKIXdDyi6F8l/2msYQ392D1gqGbtNg4v/E5LWxKPRIS8vc5j/wFo4EsYAfxpmiG69T7lEzpjpC4AOCVaMh+s5V2F7dANWKQojf72ejohJlVj+tYvCoYs04ACvKWD1z44y1hCqzYPGLYRqBLXoV1YpnDFaBKmOwOtBhCac+Q2ASXssK/qFkiO4ga1KR5lfrsVtxhDW4JVlxHGlhf8mIdW2QtGlexWEnG7qpWacJzM0dAEfuGr/pDyCFfpZwCAzrxzVlYtYjC34/j70fwif6lhfjQB9Q9HPyp17Nwnuoi0IGnTNl17QY+VnLObpD7oeXn4+6vq1ugyPT2iKCzp30KSh7M3oeB5QHEsOzwIVp3fUyeS0Bdwd8hbalfLbN8B+Mfg50l3oXLQ0JqqqjQn1g2o3h
 PugmlvFf
 n1dqsgelRp1nG+VAA+il0FfryudLS8OoK1reFB4h6MpyGfXtMHEjN4zPw0VG/RcVxPo5rz16lJa+JcWXc/P0DqZMn9mM6rrdtZPp5mhgBGvAoQoepigdlVoDrdoryStZAn5cUyh2zfnl2BlJlpvhO5bgwJ7Eet2ydYJ989jmzwOej2/wvJEheD6nE5n3p2HO9mfBgWMrdRR3ytPY34UVJscat4hmwaseObx3PIzytFzYpMw6De/CBjzXXC6Ww3128Rv7WZOszN169AHH0TCu+vUuFwxfZOwstDqyObXed+QzA8Vz8RCIULrp43Sos72E4fWbmAVDkMbkzIyN68MhHaHkb8t8Hc4MJ+YIcbJ6yb6H/2GWpWy9F8kuDp8g9uaZdwqyhaYziCAbfh1Zxb6ms4574FjTO7sTLDGbRfQfQXo7mrP1j6GDHb2fiCdEhoCZymBmGeFYmhpP2a2id+UVMHhd7VbiOhi5j92/+ex47er/8L3E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

khugepaged_enter_vma() ultimately invokes any attached BPF function with
the TVA_KHUGEPAGED flag set when determining whether or not to enable
khugepaged THP for a freshly faulted in VMA.

Currently, on fault, we invoke this in do_huge_pmd_anonymous_page(), as
invoked by create_huge_pmd() and only when we have already checked to
see if an allowable TVA_PAGEFAULT order is specified.

Since we might want to disallow THP on fault-in but allow it via
khugepaged, we move things around so we always attempt to enter
khugepaged upon fault.

This change is safe because:
- khugepaged operates at the MM level rather than per-VMA. The THP
  allocation might fail during page faults due to transient conditions
  (e.g., memory pressure), it is safe to add this MM to khugepaged for
  subsequent defragmentation.
- If __thp_vma_allowable_orders(TVA_PAGEFAULT) returns 0, then
  __thp_vma_allowable_orders(TVA_KHUGEPAGED) will also return 0.

While we could also extend prctl() to utilize this new policy, such a
change would require a uAPI modification to PR_SET_THP_DISABLE.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
---
 mm/huge_memory.c |  1 -
 mm/memory.c      | 13 ++++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0bfbb672a559..b675c9041c0f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1476,7 +1476,6 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
-	khugepaged_enter_vma(vma);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
diff --git a/mm/memory.c b/mm/memory.c
index c6a766b271ef..3e2857b30f3b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6336,11 +6336,14 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	if (pud_trans_unstable(vmf.pud))
 		goto retry_pud;
 
-	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
-		ret = create_huge_pmd(&vmf);
-		if (!(ret & VM_FAULT_FALLBACK))
-			return ret;
+	if (pmd_none(*vmf.pmd)) {
+		if (vma_is_anonymous(vma))
+			khugepaged_enter_vma(vma);
+		if (thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
+			ret = create_huge_pmd(&vmf);
+			if (!(ret & VM_FAULT_FALLBACK))
+				return ret;
+		}
 	} else {
 		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
 
-- 
2.47.3


