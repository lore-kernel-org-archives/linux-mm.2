Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751F6CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE2D18E00B4; Tue, 26 Aug 2025 03:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9F28E00A8; Tue, 26 Aug 2025 03:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0418E00B4; Tue, 26 Aug 2025 03:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF6B8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:21:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 463285A41B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:21:53 +0000 (UTC)
X-FDA: 83818064106.29.B34405C
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 61C0B1C0005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:21:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=goCUDVwq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t13H33qD8qLpbmeE54fNLyxvfIEhKYRpPw50c6x9IkI=;
	b=AE+/Y8uRiN6Rg1yoaWaxgsovPNaeDqHsYrbZZuQzk0TmsEtDJGnf4v3lleNlsq8s+XE0og
	bvYnqeWQk9yTwIV4R0MefRVvrdkDw12NISbwg2yc3pspl0ut62iZQYt4L5VWQODp/qfY5I
	p5ttlF65C19gK0LOpNjs1uPMtHDTtmI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=goCUDVwq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192911; a=rsa-sha256;
	cv=none;
	b=Etq+D0B8anMUM6PtPkt6vHYMQsVBdMmpuYoXZNRGuI+ePkEFPiMzTSqbcnDtQ199aAF+S5
	njMsUttGYYEM4jsLwXOd8ck+r4twhxGNPD1BXXvs5guoKydLs0PClg1Fn0rPEnkFCM4ZOo
	MkvBVTcOochgca91LO2wkBRmOhPnhUY=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7704f3c46ceso1944307b3a.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756192910; x=1756797710; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t13H33qD8qLpbmeE54fNLyxvfIEhKYRpPw50c6x9IkI=;
        b=goCUDVwq/O8GVHc5nf+GAC6IDkk73iYRsocioNI/m4wOj2EaQlVz5dWE1MyFuImO2A
         HibEbTGrmi0YLsH0mu87A4d031FsFX/YKgmytEBIhwylRErdUkomOYysOX6TyzPt3c0h
         YMYoFX64Acd3pgM21SEN9z7XdVaD8jdvfQHqi8QbWS0vPqVILaejBF7CAYG6mg4tnPA5
         Y6yHZxgxNWqWJawvQwfwILyQPyAhRscZ0Qixn4VZQ6QbNuzFHSIkN6MwL5oUKT3SWUGa
         Wiyh/bO/ZWfRfsBt58VGsWrkcziZJ3QOdRwcF/zpxqQxNjByDJSJCzO+3HoDONShMyQ8
         bpog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756192910; x=1756797710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t13H33qD8qLpbmeE54fNLyxvfIEhKYRpPw50c6x9IkI=;
        b=hr5EpJY3u8MSbrXgyMYAXb/p+t4WsdV3z9HfQZbKYmv8T1Fdd5554UzmtnL71vWYih
         Bpgrr6P1JP+kxYjF3+C5gTtXtyQ6l06QnT0F5uAr8UOkuPaRp05GZyNbHEaeqV+hYYrF
         5/UmE5/wUn+Whklo6ThHSX8HAWD/ZslX/7FQyQv9ZP0sVqcxiGk9GT/lt9iMjtrLTp2i
         Rt5t4RR3LZ/YlCNZQf+wIWKGP5oW5SQhIig+H0pC1uEnAeceoBRjJlWIO1aSIt9GQWFW
         WY3D1B6UKVQxFOVfXo1tcnbu4EB06KkXxuTZJKznonqVufyChL7jVBYeWypDO42jWQoV
         cJqA==
X-Forwarded-Encrypted: i=1; AJvYcCVA1psphz5NMACowyoNAtlPwpxLRLdPOmUYirm987+z0ROImue4vFg/8xRakqxiulamkeur/b6V/A==@kvack.org
X-Gm-Message-State: AOJu0YxdJSfgBT1oaFeoGNNWIy0XBIVHm3OZWnBpp0WLa8qGyiE+z8Ti
	t5c294WvgDhKCsiIXBmGEOXN/27QqyiFQI6ZKYh8dmU9WPSkFdb/yjRhA8GRi16zwgk=
X-Gm-Gg: ASbGncuHoCR0vZz4QhbQCUSePGFiAwsGejPc5zpv0g/lm3zuHEkZXZfnj15S/Y3zmd+
	gjrd4ZVYw2RYW6BDHU6hQEkfYPYAA6Hr799dQrfhPVOKGyqkZIipKeq4MOQV0+s57h0RKQx/Mgx
	7GsOZu25tGS8oprrROPWmFFaoNoShToTg1nIO8l0Nn8/S5USNG1WckycOxsDX64No7oMaA55Xv7
	EJIE8KuQLx5rnFmRsBMQYdGr2fAc0bab5wPC3PcaPkeg6eOxYc9elPP+/+mysmGWiEVAyL5in8I
	xOVo0Yk3SvGpR4EWva4v0oco12zQv5K0KSuWiwgyPBl6M0PJngDORWthCZVM/MLgHogoImXMxRN
	csQ7dj05FaxyXFayse32gafLfkywRyh6vDXEYHrTyLNkM4V4z55Hd4EGfGCTG0RhqDxExBQbsrK
	UDgH0=
X-Google-Smtp-Source: AGHT+IEu2b0RM+dE+zHiTagKiYCBPegaYQagDUGzf74IowO/NX6e+8Qmik0yxURJXoig5rjUT1KdPg==
X-Received: by 2002:a05:6a20:a110:b0:240:763:797e with SMTP id adf61e73a8af0-24340b8a6a0mr22053427637.25.1756192910180;
        Tue, 26 Aug 2025 00:21:50 -0700 (PDT)
Received: from localhost.localdomain ([101.82.213.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401ecc51sm9686052b3a.75.2025.08.26.00.21.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 Aug 2025 00:21:49 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v6 mm-new 09/10] Documentation: add BPF-based THP adjustment documentation
Date: Tue, 26 Aug 2025 15:19:47 +0800
Message-Id: <20250826071948.2618-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250826071948.2618-1-laoar.shao@gmail.com>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 61C0B1C0005
X-Stat-Signature: ezmqs74b17uzrqb7omiaicwea4sgmcqq
X-Rspam-User: 
X-HE-Tag: 1756192911-786585
X-HE-Meta: U2FsdGVkX1/F7FOTrDnKOZBg3jS5/kIBRuOOYPq5eiLRFPcPWn2XC4tcZXX+Xhh3/4I4m441JI7Vw9pmklhfgY1nBv0psx3PjxykZrmLPvFz2xqyHu4yXKpsHnSEFlgQLEzE8Dlz1FDkQLUB00lv8IU9zJqWgfmnMibhX7U5tkQaVmegOwsE4+faJnsTthXUZ67ez56FWRr2/Spd/BpQvqUjErwrwdf82orawSJlbhFQI+Zbp0YdIMFJdll0N3+5ShOcglboFdJbC91p29rFb/JAWTeDub+9aDC1nCghQSBjkLe9DIcSLCTnBss1D81nFjPmKbBKxa02Bgxow3Kb1SxnwQUjverXaUlx8s4YvvDELBn4r7/m9xdR59JH5QbGKr2NbrJHIcwcv6xGuSDT5EbjphcMqYG3sqvpifnaDVwTkJVb9oYCFrL1HmFt/Uv4LVbVNCPqmOkKPBWyGu/Z9u2IIJsPBsv64xbeGu3cwfJMV5JaglPTECl/f/udIQ9brjeKEY8RmVLCYfCFeY0BM2s6FUQ5vP/QsLMeH2Xo6GXHMtf2S8S8Ks9z7rnbFJei2IsdKOwqr4/Y1PYJjUr4X6XeSzhc63ETIzpn2JhvfT9DPjRKmlhCotQj/Wr3jnTrK2qJ8HZ0x61izvMgtdBvDB7xtV2fpyqyrJJsb7z86nIUQ9UOnWltG/ZBqS4zKe4ySzi1jSkuulUxE4IyhWv9xPpyvqrQxGlu9Zq7kzg+juLg3hx5EcT4ly5lPtxnDMVAV68fLYSqdCX5dmcFBmM067S2uysvAsQOdkhuQd6ml4i24BuLiWeV2M5zGSSpdFgw7x5KdQLWYNznBPI5DOrpRBKZjqswmKz6lLHglVITW1422wZOc2CTTYefr8p9iqCa8STDLs4TLMmrV5NWvZsq+Te4pOEnw9nXYsF0xTWWhkq7dLCnW+6ROCZyOTFGaA0dulNBX5Y9khRvQMPdoP4
 Ji2WXBnj
 /qRtAQjzjbjWcqtovW7bNJJUcFHYvdXM1Trj4ou47y7rkb2oSf/eJZOVQ7R8mlZFPiLe7kpo5uZx60CKD5cj05FZacR5xJEisuSVJYjiq1H3p//ExLhDHH1PsKrFx5otQQxtKMcBwv971KywhYxlXwvsAHR/GRQZk9SZ0wxtyguKDea/NbKssLHTgbzSVBavJMysgUl6pCH5omGmulDOVBjO6XkUJ1wAvOrCv0xtdYCYpcA43djgQqN2XvVvE0c95xZYGPXXboByUJE4NROoWkWaAQV4PbUfwUSF5MM6cyr/DhZ+zkOvR95vsvdAbnLZzheq8Lycam7oAHjTsdTqmaX9IEBC2QC5W8ffU8D2ncwb15vQ4q0Gia8OHsh7nZzhFMtN5KVEgBrVEg0ucpYFzcjJ+V/OCcghYDhQSUThwAEJ8IZIxm9iG6aAmdThnjwnMktLsleaVQlmXYXistKWIDPHyAz8XXEieoyCOJQE7WSWXbaNIOHzb6rMGEFjBxhoS+KEuHD5TDd0ZYVI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the documentation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index a16a04841b96..1725b89426a9 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -734,3 +734,50 @@ support enabled just fine as always. No difference can be noted in
 hugetlbfs other than there will be less overall fragmentation. All
 usual features belonging to hugetlbfs are preserved and
 unaffected. libhugetlbfs will also work fine as usual.
+
+BPF-based THP adjustment
+========================
+
+Overview
+--------
+
+When the system is configured with "always" or "madvise" THP mode, a BPF program
+can be used to adjust THP allocation policies dynamically. This enables
+fine-grained control over THP decisions based on various factors including
+workload identity, allocation context, and system memory pressure.
+
+Program Interface
+-----------------
+
+This feature implements a struct_ops BPF program with the following interface::
+
+  int (*get_suggested_order)(struct mm_struct *mm,
+                             struct vm_area_struct *vma__nullable,
+                             u64 vma_flags, enum tva_type tva_flags, int orders)
+
+Parameters::
+
+  @mm:  mm_struct associated with the THP allocation
+  @vma__nullable: vm_area_struct associated with the THP allocation (may be NULL)
+                  When NULL, the decision should be based on @mm (i.e., when
+                  triggered from an mm-scope hook rather than a VMA-specific
+                  context)
+                  Must belong to @mm (guaranteed by the caller).
+  @vma_flags: use these vm_flags instead of @vma->vm_flags (0 if @vma is NULL)
+  @tva_flags: TVA flags for current @vma (-1 if @vma is NULL)
+  @orders: Bitmask of requested THP orders for this allocation
+           - PMD-mapped allocation if PMD_ORDER is set
+           - mTHP allocation otherwise
+
+Return value::
+
+  Bitmask of suggested THP orders for allocation. The highest suggested order
+  will not exceed the highest requested order in @orders.
+
+Implementation Notes
+--------------------
+
+This is currently an experimental feature.
+CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION must be enabled to use it.
+Only one BPF program can be attached at a time, but the program can be updated
+dynamically to adjust policies without requiring affected tasks to be restarted.
-- 
2.47.3


