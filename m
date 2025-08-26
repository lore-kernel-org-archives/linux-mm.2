Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 709FDCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27DB88E00EC; Tue, 26 Aug 2025 15:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192AB8E00FB; Tue, 26 Aug 2025 15:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F243B8E00EC; Tue, 26 Aug 2025 15:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8D408E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:33:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97665B8147
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:33:59 +0000 (UTC)
X-FDA: 83819908998.06.DC00DB0
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id C31DBC0007
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:33:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bnbccl37;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756236837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csL4vcqUsLMqelmQE03dlwxPXsPoNvqKRUsp+93HhyE=;
	b=ZxQoXub4/pTVN+gjQD7NdouRnz6RwiY3yBvXpB3zbkoATv8DXKPD/W2knBMm6ktwGrwVWX
	apbNuBNVCwXsegCL7n2cQvQTJmK99hXE2dk4/TlKVc9cnZI77bXh/uNZYh0sIRnpjxjok2
	iTNvCPbv3qmOadLg3UenLJqWpKz5uRQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bnbccl37;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756236837; a=rsa-sha256;
	cv=none;
	b=yoXib55ScXRGuyhYPzw0Y2LWT6sFmMZ3CX9awt2n1s7H49SHeHv0WlF7st3AvZbm6CtT3h
	J1Yy5e1dNMd/yZL6gHXYjO8RUqDaEGOBoB/wkbxHhlOlPBUNgCykwxUjjm+8fqjIDqrrKd
	TVmq9SICMakJouEymd4SBPH7mOu83N8=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-77057266dacso3058070b3a.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756236836; x=1756841636; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csL4vcqUsLMqelmQE03dlwxPXsPoNvqKRUsp+93HhyE=;
        b=Bnbccl3700u4d6xopuI0sijEreNwES7nA2JZE50T3GDHVN5Ce7f0E6AQr+1vUdf8QR
         ud2pGLARuAAwMaAuEo+Ww5d+NP5KnHBEluILsjEiPpXUjHSDVTyCSlP4SY9nVOlV5Ofd
         Lh54fGdAcuXkRRY2hCxaasD3dNj8StD/9OgLhYxfHb5lKJCExmKXLPhBSGjlCFdZsk6a
         sL2ev5le75HYYxl8ehWNyxoP//Zbjm8N1HYiLA4K0CAmDwhHPNssgFi4GFibmt1c6XI4
         vzqfm67JL77tfOzhtmlr9Q9+/B/+pNZEhw1VeHXrUnjweY0uxO2DE4C0DSmHX26unfRc
         EYmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756236836; x=1756841636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=csL4vcqUsLMqelmQE03dlwxPXsPoNvqKRUsp+93HhyE=;
        b=sPdyUSAxyyrk1KJAkTn6Sfs05uTllLeyDTclGwLnHTT7J9WuAJ5dCgqoGBk6frrbQM
         CF/P4GnZTM1XEVUy5DGXuMMegIqQSE7a1ncIYzVyskWZsLAvcl60OefdsDQsqxAsUmBC
         AqaJaovpdktXkFRxgHYRdsUsRxNBDoQLKbCk2O8yAHU8U4PEgDiNdqs0+0rPDyx80Huw
         nW7rqcfFcFGd1O7YTWW+8EtcU1Cg1OMc09TjwMVetf9neqHH4HSOhyaVtUDtoxysC1hD
         5xt0X6jaNCoinSNKDeY2n0qCadW7Ff0Bj57e6UtLT0IjjdT3bviDYtD0XY+e2Zys4D0T
         6t1g==
X-Gm-Message-State: AOJu0Yw2u/tP+h8WlejEjS90d3v52Ly7rJH6LLnQt7Jn4gO58zV0Uewm
	PSHzDXUwx8toUWZcQ5Fu40wm+SfgC94MNQYjwqY1zThXz0je2RPgpzJeBTO8hg==
X-Gm-Gg: ASbGnctWEz+l8GrHAzpBzPvCAnmH6enHLf8QdfpINy91eAzF1PToYrd2aQWIS+ChmJL
	+g+mtwczLzC9t3YDofv9UBtm6gRQ/8bkV+VPeUjl7vhh6z0MOkdQSXbJniGHLh0p/PZ4NW8XvX/
	hvq1UAGGE6l0t9KaYmc8K88XBholiw/Qu6nNXv0MyC2W/Wd1olNkF/YatrPobCCFerlt2NMr1SP
	gsMF+RXs+pGVNk1My2Y/vLLRU70WFkPYLT9WH05H07s4gvYj4xsEXtJGnS7Ahps0ILmn/tw7KCd
	6koOY16mF1IU3ZUrntxKNalRm5wWgMMpfOJaM8IvlmroE3xDpYqidR2SIZx5iYkcpN6Z8iDRPCb
	23d/ZiofRPEcELKgakrW2PeWMg1aBw+pDeUPtVFmFAXAG+Mc4BE2LhA==
X-Google-Smtp-Source: AGHT+IFvzr6myYSmZn7HrektYJv4R8WVw1CR1DW/e8DWy+bQK20FC1CA0a5NGejv86A+cns81qBXwA==
X-Received: by 2002:a05:6a00:2991:b0:770:374c:6c60 with SMTP id d2e1a72fcca58-770375bb1b7mr20607989b3a.12.1756236836077;
        Tue, 26 Aug 2025 12:33:56 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7705647e03esm8054053b3a.59.2025.08.26.12.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 12:33:55 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 1/7] mm/page_alloc: Add kernel-docs for free_pages()
Date: Tue, 26 Aug 2025 12:32:52 -0700
Message-ID: <20250826193258.902608-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826193258.902608-1-vishal.moola@gmail.com>
References: <20250826193258.902608-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C31DBC0007
X-Stat-Signature: 33k9jkk6f55a8x5z4b3krmcdx48ei43w
X-Rspam-User: 
X-HE-Tag: 1756236837-280993
X-HE-Meta: U2FsdGVkX1/q01A8uHL31VZtpaV9zoLf4mEvS5aSus3dvEfTVoh+47V7tsY7uwXljSC1NtSxFq1qW3+1GblgnuzTYDst4ZJrKiF5Y6UmJMFKTqyGLLR9XFZK+erUoM3CCR7zdE7RLSikgzQ4vbufKn+Uzmtgm0sy9QBdgBqD+01z7OF5BG77O69IU7rnk6/MihH2UGfr+uuGo48w/6fYidPRCVA4PXLjg3bs+IGXzx7kfi1sAODBbXJ0Zf2CaMkiT4/Yu2D1OOt2xpNDKjvcCZQM+l2iRIjEWD7025lybVbnWcC/9hjVdbQkLEP6GROGEgKfAxINnYgPiusecXvVBN15JqgEGsMRTYfYoE6AE5/3haG2H/VRMw0AN0vdBc1rGe9+owY1cyDqADVVXEkr9+ui/Fa3lj8vcp4jyPk2WlQ+NciyudivQjoCw1IOrOstfmupBrQl0OvoEUzWtP/zzJRaX1fHiecOEZRovcEYAVSZscGOS2gGmTiXuRj+Nl/YFONnipWnKnCS5As1AewGkBBOq/4ZyzwnzWZOYEygN1Ftt//eqd1VlglS7M9M8g00B59+nEk2o3yGQxveoEtlGXlSXvRJ/R+szF03JMV6SlbcZIyM0UtIAcWWZ/kyAWWwqdXMfePjysxFQwL5bhNfLE0ZqR6hj8ruvqUWCqbRZT1cA29hTsJKv5Ks8mqkRe/sRCaVI9NDUn7ywdDcl4PZW4mw2rHyRQd1GqqBdrwZzYuZpri8qWiS/UCfkibEzqii12Cf/6/KL//Uxk3bzaaj8ocz4IGQY1Ibfu5pxBNbxRkthb3mbIBEEgJf/O5RuC1Vu4doxu/bRMwXLx/Z/x+EvCQbiPeBZuN5IMQHaSJdkICo3ULGUGxEbNfzlymWOowQl8l2NlIM7+Co5h4AChOMAAka9SvIEbTmO95CvIZnpNVwcrJSO0ZYnxWypfJNYLrsq7Woz5JTKH7OrhicTF+
 L+Lzsm9G
 10UbFtPL9unqriqdCwzbHFuoCimeLQo/E9wFgqfqo2djTTjrhxR9RR5e5OCYvWjywRMGaLGYy33jdOiRQdhA9D0/9XBK7YYkaYdj6182UmLgIAk2Ltd9enDPv2bm6A/8ZwOMeyEnRKTdeHYYx+zxLqiut3M1ydWxNGQYsx/zQJ4AxEU6z3If2XX4TIAiTyZ+SJTh8+t9n1kULUSbWWmLSTUMdeo7J2BqcCXZEytfRSyZwS7dh/Cz83YHOcbyPc7RAp4Gbf2iCK7vDu+dEO0QrnhD9IFpl7kU+ttJoRvX/5tdfq5BFmvRWEoZxB26uHbqyxN1d4htTKyh7CGLVDvqX7dqtDM7FqZcXklLMAJExwdWa4Mym589cMbZir42RDRkNApxUwi0/KdfGg8JyYzJoDoU122clBpuFtLzPZNAsMiDSP1U1tT7AYA2nSVJdqPjz/z+TWS0Ke5hlGHNNJ+zCI/jDpQOdl0d+qOll//RVdhmWLJrx5PV/q1aA/0ZjGGEYsCZddki8fTr8J/c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kernel-docs to free_pages(). This will help callers understand when
to use it instead of __free_pages().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/page_alloc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index baead29b3e67..6ee8f450c078 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5270,6 +5270,15 @@ void free_pages_nolock(struct page *page, unsigned int order)
 	___free_pages(page, order, FPI_TRYLOCK);
 }
 
+/**
+ * free_pages - Free pages allocated with alloc_pages().
+ * @addr: The virtual address tied to a page returned from alloc_pages().
+ * @order: The order of the allocation.
+ *
+ * This function behaves the same as __free_pages(). Use this function
+ * to free pages when you only have a valid virtual address. If you have
+ * the page, call __free_pages() instead.
+ */
 void free_pages(unsigned long addr, unsigned int order)
 {
 	if (addr != 0) {
-- 
2.51.0


