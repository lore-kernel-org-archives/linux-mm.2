Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E03CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 17:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F958E0021; Mon, 13 Oct 2025 13:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0378E0009; Mon, 13 Oct 2025 13:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6378E0021; Mon, 13 Oct 2025 13:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCC0F8E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:42:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C7971A0366
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:42:28 +0000 (UTC)
X-FDA: 83993810376.03.6B17C23
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id A4DC912000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:42:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CHs+303h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760377346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AMykzJJayvn6YeEpKV9Q3LgMXzXdoUHGdFnIA0ikh+A=;
	b=yxT3tdDnpdR+jQCexJrzSV2JM0fSwR7M7HHb940mG2jPFAelgYStDkYco4q0iqI13nyiCm
	ad4NIXKhe0z4KcTcmrBY/+kzSCVy4pvs+Kf+u1x4OXtDWHAFpC/79ZJJOHCJF+P7w8xPMJ
	y67arQc9UkA4sxT+YatVaPFpn7WWY+U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CHs+303h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760377346; a=rsa-sha256;
	cv=none;
	b=DnoQB8aiUZOzG5SSFsBFlj2a8U4DCRPtmMkupohAQI22/nslalj1QQqTHqKZNsgIVbcgU2
	Mvi0cq31RzAfeWED+vz2mHvGE9gStRb6O+1GOwqLlZl7iitOPTyi/hUBY3X1XgY9z3cEAQ
	pFqeoPNEfrlUmi4w5ZtTfWoSpDEdCPQ=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-57da66e0dc9so4519193e87.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760377345; x=1760982145; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AMykzJJayvn6YeEpKV9Q3LgMXzXdoUHGdFnIA0ikh+A=;
        b=CHs+303hIXz8qo+fbT2o9hhv4ChLzU3mvqyxwMtNOD+1JtbVLT9v66SWBrMEGYABVn
         B2XnZQA1NnEKHl15eUOXvlIGV6Xnl76h0i71kYJU/aTkMWmEj0q2eg1X531KGI+QiYoo
         3563KUBnjaPm7aCOIU3TQcR7+hbVoZFf5fAltrxtC316f0ubJQQh2WY7WX7tY+YsaeCs
         2aoxWPaKEN8tVRyrarbqfzGKwsD+PSy0RwCEtVxkd1WMxXZ1FSgesto/sahBc+Pnq6GV
         CfEdKnsfIHV1AyHTnAaSuiXm9te4eNvcNzvhNBIn+SkH1IEohpNKeCOMMLBf/UUTBFB1
         mPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760377345; x=1760982145;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AMykzJJayvn6YeEpKV9Q3LgMXzXdoUHGdFnIA0ikh+A=;
        b=eO5SbHUHp/yjN+NnMH4E0rWZJRJtztgZOJ5r1G4MHnAThfWx7aBESaOUZYCW6gxQxT
         gjOD1wQx2h04NmZsqLa13ARQcL+eyv+udpZA8fwj0vzo3HxN/bLqQS4ilBa8c9FJyzTp
         W1b4SdNmuo38EuHNsTMfCKnUXh57mt4MG0EaiIVgUyZ27oqI+XrgIt8+Fx30ZZ2N0kcH
         OFBCTtk7a6BQfk4zYp8UK8znD9iUH42YE2id8UdVYNqXSK8TNLC7kkQo13SMcETXucS0
         T2M9W2DTinfURGM0EDvTCqJTl/caU0+/bqrhSv1TbqWmITl2K07ssj5X0y8WES601jVy
         E5Kg==
X-Gm-Message-State: AOJu0YyTuOFl+a6Q95Mw7pqYix3CIKsu3pigA0HuYD479/G/L96RYS7w
	1gO+ACcPXCMlnnT5TvUPJAbzQSuVGOcQBpbzB8qkxO2EFdoiEN9mu50ncEFmS5Ydg7Q=
X-Gm-Gg: ASbGnctlBf4a9dH3WTNMunN1ggGT6HYT8uwkb0nDRGWGnAyuQ8GlcH6Utp+SfLfmotM
	ogk0Tqy1dqzu5aXxlzH8Ijk0cwiMAObZORggnZ2onU/inqhgVrbMb/SOH6R6DouWdsocG1Xw1Vg
	A8aiBstY3u9oZiIyimmQcR7APnh+xCJ0+nG+94ZWo3iWXCo3zGwid+SAEaWE4kFdy5cfigJdKc8
	sR+qS8uoXyY5FowBMMy32L7Q87FC5pY9Tf+A52Hb+O4RyoorhqNgzMrzhuzza3sNmJEju9v14va
	FFWgKcpSnbUpoYcgRi9WTidP64l+AHmCITT2cFAFb9mCHFoE93+fe8To9KjMj/LhG27qH8Br20N
	4Y8zzfCEngXQVh0GonL/9J4r6evsZGvZtecrGw9QpWceV6Q==
X-Google-Smtp-Source: AGHT+IHW/Y/7efeNDjninFHG1sZiCXUgN1QMIuHHkc8N9haI/EiByB0KPd+AScoYy9IdrEiFHiC1LA==
X-Received: by 2002:a05:6512:b10:b0:577:9ee:7d57 with SMTP id 2adb3069b0e04-5906de88ee4mr5720691e87.46.1760377344510;
        Mon, 13 Oct 2025 10:42:24 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59088584812sm4313857e87.122.2025.10.13.10.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 10:42:23 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH] vmalloc: Update __vmalloc_node_noprof() documentation
Date: Mon, 13 Oct 2025 19:42:22 +0200
Message-ID: <20251013174222.90123-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A4DC912000A
X-Rspamd-Server: rspam03
X-Stat-Signature: eu8aec53x6fn691e4xmuuwsf1fubtm7j
X-HE-Tag: 1760377346-820133
X-HE-Meta: U2FsdGVkX1/uxIu8o8F5xHhJaQy/i9XmjhgcQjlB8FBw7kSZL2CKK4gBmu28EahLtvwGe2LfQxJPBXaGaNw8vnPDa/IHFcpgeU/kxUBfeHLpElPl6Bq/A6MY9Zan/6QXkjgF3l1jw5wA+SEoTdvDKpVL+xXR0aLQ402khniZaIp26h/smS58aYjyg0RUXloqFsr7esbPq0xcWC9Usu871DS6xzhQgnm2Kpwt8PNE1y7A8OEroV0rTfhSvATnHG+wPXqUu4MixvOWNOYEPjggTNq7QP7OprM4/Pwx1aUw6DFkP41QOKdE4jpTYTL5TjkxaLugGc/sig7TexYls1GntZzQMRDGmwwxKssoBTH6o5gw4KOXLBLRut/bqkpjtAMO0Th/LUGETdBs72vwNmJWrpZS3MNMrF5Ol457/fEuHfpeNH2xVeNz5WItsV7Hme+qz2jp9IsBLLuofdJWiEgrFa0baCi66M/zQsQQIRHYEr83ROjx68bLBdSlGfLO6oPthSTYcIyIn+bMlkuP4wOLsbJh3ieCl41k3OUmG7Gr3O55P0fXgg/cLjy8+4BlzXY9A4N7GQls1bO1F8s2m2tXn+rAjrkPoFWQ8HM/tbpmX8/8/RDjlhMat1MV3gKG3nBGq1GXJGpcmu1MlK6extD4otVqZoe9SB2Iue1CYeiT/gvg4nlUmmiz1381GQ2sK30Ih4Hd9X88QDl4NwQAOAkMbwx+7zy4BOARFZjOhJKYjM2CsJ4N+vqpmQ/haOiSi9ID0U8X8BeyeKFIolEgPiqEqb2CZJ5L2AziIdNpsteYSCfUieYuHcJE18/7NPKPTdfMLjTcfKVH7/3aJtk/N38pOp6Ji9fRdk9Fl2V3+muiRVGLCJLLlpIwMdil0OsWHLvZaNFzHT/Pt3w/Ap1E1W0JT15p9a4ef4hpDqtkcyaiAX2wt+NR63c/g1czPSmwNSg8CCzGK9cDX0ybjbC0Eka
 gXsivl1P
 GqRmdXizA+Q8lycmOtHelKmoXlvKmsC18YHSgZLqVWMCw9o+3wgGOzoCuH5IZluDFPZKDpku0ZX8cWlNia08C2b8eWBPwct7i3HEwF+2n7QmybUJr/wUdBLV3SLLM7WuToxNmE3K668y3bJ5cxF/Sk9NMNwWrKQwE+eMEcsafvGcS1mUALMq/69bes/iPcssMihbJP7TZ3f7m1uAmhxQCYmudQ5POkesd8UqLnpwntu4CAkWYvHyaGVuP9NKO3TQipB1Ch9m0xUviACOMHNm89tiexJV4tJ1jVYNfAL2ToNXi824vSF/iBqu9twGl9GGr6V8y4AY2VY2G0hmrDOTPypG7h9Smji8XEqtTZxzff6V2/Hr1BFh4zGExr9s8L1djbfxTG9aX2d64XvwnfEvaooh2bZWGkcPhqC4lVBQG8vz6kDTB/RC4i8VOEWoC7cuNFraOTWfFQg9sJIWCfxPLT2SEXBt/PV/rc2TW+oMR61gTYjSlUMsXsKEIoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel-doc for the __vmalloc_node_noprof() incorrectly states
that __GFP_NOFAIL reclaim modifier is not supported. In fact it has
been supported since commit 9376130c390a ("mm/vmalloc: add support
for __GFP_NOFAIL").

To avoid duplication and future drift, point this helper's doc to
__vmalloc_node_range_noprof() for details and the full description.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 9a63c91c6150..c31fa69cc530 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4027,11 +4027,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
  * Allocate enough pages to cover @size from the page level allocator with
  * @gfp_mask flags.  Map them into contiguous kernel virtual space.
  *
- * Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
- * and __GFP_NOFAIL are not supported
- *
- * Any use of gfp flags outside of GFP_KERNEL should be consulted
- * with mm people.
+ * Semantics of @gfp_mask(including reclaim/retry modifiers such as
+ * __GFP_NOFAIL) are the same as in __vmalloc_node_range_noprof().
  *
  * Return: pointer to the allocated memory or %NULL on error
  */
-- 
2.47.3


