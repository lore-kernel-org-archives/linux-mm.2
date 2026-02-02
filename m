Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87060E7C70C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 19:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB5D6B0089; Mon,  2 Feb 2026 14:41:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CF16B008A; Mon,  2 Feb 2026 14:41:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD096B008C; Mon,  2 Feb 2026 14:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEFCA6B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:41:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B87F13A097
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:41:35 +0000 (UTC)
X-FDA: 84400536150.01.20D3E5D
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id E416F1C0009
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:41:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IT0e+fOp;
	spf=pass (imf21.hostedemail.com: domain of 37P2AaQgKCD8kjbrjzbohpphmf.dpnmjovy-nnlwbdl.psh@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37P2AaQgKCD8kjbrjzbohpphmf.dpnmjovy-nnlwbdl.psh@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770061293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzBuDtCCfLt++OBvygrsI0xUSFHIl5gIsKDVFk7aDn4=;
	b=Aj325gZQx4v6dQdDqW9VGH67xxB+c36wiWlmfZuZ5vsEmlC6cc8wKvjJhAsO+3L9QCkL0U
	yxYalSM9qABwsADA2vtsqs/Ge3wtyCqoo1CyPSc753wJongyvYHTm2vxXgT2kqcgK4opbJ
	1khBaI/VILo5vR2p5kmWhVewn0Cjr/o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IT0e+fOp;
	spf=pass (imf21.hostedemail.com: domain of 37P2AaQgKCD8kjbrjzbohpphmf.dpnmjovy-nnlwbdl.psh@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37P2AaQgKCD8kjbrjzbohpphmf.dpnmjovy-nnlwbdl.psh@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770061294; a=rsa-sha256;
	cv=none;
	b=Rofd5z3CCuxnBim3Hve/EvZ2tBwp+fT/HpTa+bktOsoFFxVodWSM1Vj4d1n2L+KQea/xgt
	kGg6vZkEPcMeQ0mGbBBhqfgcF++syIWEfWqxEnfYKhw/Fo1TQklT3H+sH1f9glM25cwf1c
	iKs/UpvVoKjOzmdDR5GZNw8BJ+RAO+I=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a773db3803so50564105ad.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 11:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770061293; x=1770666093; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CzBuDtCCfLt++OBvygrsI0xUSFHIl5gIsKDVFk7aDn4=;
        b=IT0e+fOp8lqcEFTqx+eRN9awnqlTMx/IPPmgQbXs5Ypnyx3PSZe3D/8x75SidVEUyU
         kZgfrGhUtOdgFzfAjbYx5noKwjfu/0y72w17F/tyS3Bndyk+a8iBKpk0IVnwbz4X4QK2
         9hnnD9bqnfuUolGh8odu3qebQ6Hy6Qy0u8N0BGKebLp1hVJhBl03lJDris7SDQydFsBr
         hjMeXfAfAh8rA/ZgvCpQ6c5S3viTYxQOHteruflb73E5+waw5bzAZG63OA5Y44FHtqgS
         qAgjcfMZdX7ny72mMUm4us0hkehrI7TniNlumF3/fQ8LIMCIKQ3Bly6SrNFshgXLsOQp
         OSOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770061293; x=1770666093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CzBuDtCCfLt++OBvygrsI0xUSFHIl5gIsKDVFk7aDn4=;
        b=eQxaHeWPaMiDrbUoN13BizvV3h+wmaWnvi4nJ67mACbHzpuVGUuDP13X8+TWf8Etxd
         tD0Bvxf/i+Rx2GrPB4ldOUiiqDaR0m0aVB+L85/JxX05v4YIWnMbTwMNhwkM/Qhi1RM7
         sIVYmfn+4Qwx2SsiAyIOTOOm401ivuFINBB1Kyy5xNzD2GCAypK2j0LYCrJH4SQhpIi/
         qA32p6xVEOTH5PXHoWYkjOVQM17eMMclYdIed4VlQeH/3jdx10tOcaxlSaQfYPR4RhXS
         EeWXX55DskfAYPUXUPVKfC4IhaIsR/dtHSy1HhN/JQogd27/0+SeZoud1tx3kRMzDn75
         LZcA==
X-Forwarded-Encrypted: i=1; AJvYcCVNagplRtD1thw/lofa+u5sTfX5Gpr7WOD3QpL2Vehtp1iNw29iodRm+XNWAcQ5uwH2M7f3FdotDw==@kvack.org
X-Gm-Message-State: AOJu0YyMvTxVm5yI4zpErQZD4Id3CvxRjNsflR8woTl2SDh2OufLYBGE
	YFDxy3JSnXoVIc7v4J38lbaa9m2Qi5c9DuIT6U5TXHLbsb0+G7sxcsLuw1HEEjO4btjkPRj+VgC
	PimpR5f0HiiZQNA==
X-Received: from plblf5.prod.google.com ([2002:a17:902:fb45:b0:2a0:fb2a:79f0])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:283:b0:29f:1fad:8e50 with SMTP id d9443c01a7336-2a8d959c8abmr134229505ad.3.1770061292645;
 Mon, 02 Feb 2026 11:41:32 -0800 (PST)
Date: Mon,  2 Feb 2026 19:41:24 +0000
In-Reply-To: <20260202194125.2191216-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260202194125.2191216-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202194125.2191216-3-jiaqiyan@google.com>
Subject: [PATCH v4 2/3] mm/memory-failure: set has_hwpoisoned flags on
 dissolved HugeTLB folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E416F1C0009
X-Stat-Signature: ig4wj366ydhzjsu6y7tp56mzkqtoxm7n
X-Rspam-User: 
X-HE-Tag: 1770061293-528871
X-HE-Meta: U2FsdGVkX1+YolLgFhHljpCWF5m4/cfjdqq+Qz7GZGIQzveULsfkxNE0ftv7GoCMWCXyZvKw0EHRBuc3HMABppB2UN2DemMZVTJoKDrbVtasy84H5EgMeBQ+0JFwK93RyVYm/VJgnnuS0WmOUROzn63tAO1MC5YMkgX485GI2NVaiW3Le3OGf6E4RSxtePn5ve7Nu8TtUQWCeh2agVLGHP+6vJNBC4m3c5BNlFSRpX1qp6A3fGCu6nLcVxgatDSt22H13L0FEoI/yoVHm9vH5yNhfYzNNDaNBeEjM0LvAnluii1/uM8Dhid88pg/gAmC7RQISK4iFVsfcabsw6nBa142mQXDmvplVCrHitUw+6opWhoNphpGMwKSbfmP6UczdFEqG6N+RXaF6UchblM+3LnfD3hRtLNSKXOqIowYm/AXaw0pZCC1zS+X+5voKZrswWWDA773xKcxFXRzAnqTp0SrT+H9vLi+70EjqN/Q8fxdgMvDqQQIEEO89K6vEEk1+HUGdrXJ+23nXPQeGJ2jaSE35zqBAzSD+06QxdTSz9C5qHHhLE1hmBByn40wnQYLhFBeTS0oCKLWyV9oUeKX0MDkCpp/a+cbVRwexkAdqxEHG9I1bn+0F2TMdukZ4vEHZCN5AJ+/jgHKFwwf5fZTP2qc/FnvHRor8Ke2b57oBSCnSc+eevQm2yH+MUqv5vv0fPwT/CeNDzknn8OmtmfNtN619WgcWebDPrIxTGj0IpW+LfnuGX8rzDNkBQDI7GZFTt0v/iNMRr+JU5K7bUXa5I/eb4BNyTcUCwP3YUrE5M+hbfLq7q1KxiCQzvxYP1832bWts4tDG3v33hufyH+jFnbb0sVdqxhEO+uYrqllkk4K67e14BfkW7Ogz3qsz7fBpoECjwHy4cKzftEqQNOC9di3/wdad5wuvWvAa7xYDElwlnJ5sB9wKtnIm/sYmpXEd2HofCHoSeYsiKNtsUg
 /vziAzt2
 V4ERXWvvHQBdAoJ1cMUyu2LZH96R3b8GZimFsv6L/Lr2BRbAipISRodMynIQFwEUJ0Nv4LC5PSnGe9G1jyQvJs6BhbfrPWpoxcz/OD6Syk9RnLMHIwbb3ztkScki4Yr6Ifo59ucpgavZCp6rfQOUt7ecNTycy4DqJm9UpKI7M/ogrYLo6ThgGnKfP+G5cAWxYyUaPQfbzXYnK7qWVt6KNbuT+ROtMy8s7mXwQDuThVGo2xPD3aauflpT5mjrSMviYTxX8oVL8fGsvKw5lLLsIpeoFhiti/lMJiqlOMbTZb6W345xbebi81RKLCVEkYBoLtnDd1vmiPMtjDVc4LD3qdMjgt/uIqDF9I+g6K6ZsQnkSU0DohFl3NOEDXVA/aluLF4PJG+fyrIuNEgHYo9W34RNrWOyIHCwz7DgkhPip2RJ6ifllgPZtdD+Gkii0GN+uOzOZI/Vn+80S1pFzL0DD99RDxj/I09XpW2mpnq0m2abzaz8HqpTvs7HdZSvGvNoiu40g/I098I33CJOOCiQXn7waPMGLLgPXcMlSw6d/jT3wmZ0jw8bQp9cmofZDj1F4H42Q/HdF7jJbeWYAKynjXzFx2v//+pq7GU7AG6wPZjBsg27ewEcxzrliMW0Bkvdvidg2/I/ymBViYKKxDjmjhcTTmZ0hcSV60G/b6Xech+P3ywU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a free HWPoison HugeTLB folio is dissolved, it becomes
non-HugeTLB and is released to buddy allocator as a high-order
folio.

Set has_hwpoisoned flags on the high-order folio so that buddy
allocator can tell that it contains certain HWPoison page(s),
and can handle it specially with free_has_hwpoisoned().

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 include/linux/page-flags.h | 2 +-
 mm/memory-failure.c        | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c734..d13835e265952 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -904,7 +904,7 @@ static inline int PageTransCompound(const struct page *page)
 TESTPAGEFLAG_FALSE(TransCompound, transcompound)
 #endif
 
-#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+#if defined(CONFIG_MEMORY_FAILURE) && (defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE))
 /*
  * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
  * compound page.
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c80c2907da333..529a83a325740 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1952,6 +1952,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 	if (folio_test_hugetlb_vmemmap_optimized(folio))
 		return;
 	folio_clear_hwpoison(folio);
+	folio_set_has_hwpoisoned(folio);
 	folio_free_raw_hwp(folio, true);
 }
 
-- 
2.53.0.rc2.204.g2597b5adb4-goog


