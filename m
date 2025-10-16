Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A89E1CCD19A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 00:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B832F8E0053; Wed, 15 Oct 2025 20:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE5688E0008; Wed, 15 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4738E0053; Wed, 15 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8966E8E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 374BBC0144
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:46:26 +0000 (UTC)
X-FDA: 84002136372.09.FD94870
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 91BA7180005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:46:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h1jmPnSx;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760575584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=h02wqLHpga/+28WX+0nL0buxBxUD7AtKeabCcwrDLpY=;
	b=CAAzb8f1cH5vQ9fIopnyoLV6q4PDr1t1R1nxDRA50ova02UdLCljojHuakG1kQECRcWa/3
	zGtnLVuLO9ydVXHp0wyCRElocK4XrF3FScDRI+nkRF8a7ywdCqfuGyViuSyCxIlPdflcKs
	4uoTHny2KMUPoE1ceOo93+27gspzoF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760575584; a=rsa-sha256;
	cv=none;
	b=Nzco1SeFSwoPzh3saBVH3Ppr9FYzWrvXC5/F5ZperZTL98WKFdzwyIMze8XsDssqRkJmUT
	inYzn5NzmQOrFl3V6JtPuG2U2KEEmTbhHQjZzRme8Kx3kVGULQuiA4Ct+vRdMqaU46m3V8
	DYr3IwmK89eeKEdSPQgCn0v/jEE5jwE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h1jmPnSx;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4060b4b1200so122509f8f.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760575583; x=1761180383; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h02wqLHpga/+28WX+0nL0buxBxUD7AtKeabCcwrDLpY=;
        b=h1jmPnSxSzQp5qpxndGGnHZ0Y5aixbduvKT9n/9rRRpbZQHyf7QUQ7mQWvT8vzgI87
         A9TbGu2Llr377AIWWxMCRQlvAH4BxUt15m2R9w0UsRGyoDKKDL1UdtrmCGsmcZCAkJW/
         /FzFJ40IwgCp03osqbW1B67XsgjlyiyUnFQXAeY7u4kdBFEwcEmQXZq0sg2gyPdQLK7o
         10hnqEXkCvBTm1RYkLXIFrCm6a+3Qtwolv7+O7zlQ7+KJA9sm5xNkiYvyxJr9paIWNPw
         5Su74n/fheESgThqq3nqhE894u4cA/QVbr+iooZzvzmzDBGIE2WkZG5f5Q11Gmy/8ij6
         O7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760575583; x=1761180383;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h02wqLHpga/+28WX+0nL0buxBxUD7AtKeabCcwrDLpY=;
        b=Aw8Q4mMEOXlwvg00DAFpD9K6ckR9KMYaNJhbRs/NrX6dWP9/2MOyV/7Z/Qtp4ylDFW
         F61Cuso9H1ivXkuBNYBwDIsxL5UdFU+u4lk+HfzLmh8iCjr7q9Ylz949v58Oho2ei2YO
         +G5cuDVABHucoVhNa8KSV5rNg1SxeINeoNfTYVO5/6B8Gz5N4tESj7BmmhuaJ4iOvkMQ
         AxkRB96xAVSqOfnrB5GpJDaqxh4znl3vOvAsNLMi4Z3VjrCL5fyhIk8XKHAKKHKjdYXP
         nhcZEl+WXJIRNEQqLmkfq2eUbAX7NYvUxnRjkoxVcteUpXNuCe48cL0JURhjWMMYydyb
         NBXQ==
X-Gm-Message-State: AOJu0YxSy/vCcprFz8wUm5YkDnViO/+2p8mVfayQtcbU7vMdDjhM/M2R
	ANh2u9ee+AruK4ABS9WL0rWcLPyYkt/hfJk+fJ+D1ssplku6uIJFsIv4
X-Gm-Gg: ASbGncuMHyM/Tfuffwd2Wa+/Mpl8qeHNVTlnp1TWTVNoNcKWUMzgf03JWZ8fCGo46eb
	NCmhi5vLVt7otyJefDCddwwxfsrvktZUbz3TU19saUhBmoVCna8/Oj2nHhEMm/lpd7K+gsQa7aH
	F0Lbm/ZAmJM+Wq1dm4WxHQK8RUc6XmM60CMVl0hZOkbperJm3sdF74Ysn1TM6ikoWmFQwad9zir
	Y1YtddmK1Ic6qzLU6RrzYY1VqjW2L+NnybybFWAdZ0Gi9YmEZ1PIh2Jt7VSj4TD5IyMd6807nmN
	myft/RIy/Vtc5b4TOuhjLWs1wqPgW/Xj64bSplxIhxSPBCX6IRn8gTx6SxwZJMQZD6y89WqUxdj
	1ZS1zF8AJTkm147ar0RDK/EdDvvSyRkn57Hb5P+oAJXTgIaXuCWaRLb0W4K6FNSEbC2uyTERv13
	0w91UZqUdYAQ==
X-Google-Smtp-Source: AGHT+IEW5EI0bDney3AfSlHYXZ2gHgt+pMnUQlD7V6AOI/KKVhyBPDT8s0eWrf/LqvSbvdGfBhYlTA==
X-Received: by 2002:a05:6000:4283:b0:3e8:b4cb:c3dc with SMTP id ffacd0b85a97d-4266e7ce955mr21210585f8f.3.1760575583076;
        Wed, 15 Oct 2025 17:46:23 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5cf70fsm30295540f8f.27.2025.10.15.17.46.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Oct 2025 17:46:22 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 1/2] mm/huge_memory: cache folio attribute in __split_unmapped_folio()
Date: Thu, 16 Oct 2025 00:46:12 +0000
Message-Id: <20251016004613.514-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251016004613.514-1-richard.weiyang@gmail.com>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: urnpuue9ae5z6njyiaahtfn17uybzccw
X-Rspam-User: 
X-Rspamd-Queue-Id: 91BA7180005
X-HE-Tag: 1760575584-784831
X-HE-Meta: U2FsdGVkX19aE8KOwRJPuhnjBhS4u7N/KeZrPhx0UGpiFe3uTnj2zuztvyWGFuH3L8wACxU+YjMprkqvdfFgTmsDisnmSqhLOPNS6zuyy1069uPbJBnLbvC0Om00XP82+iBEHTqR8D+nRMlekR5nA3rdK1GFPb0gWHQp3Bot5xU2Y5ZrTTWpe4CstoHmXRUkIbzy1S9vKscFNl0eTNSETt5SfpJO81awIrU5RzRv3oKEsHydElcvRQdXPkhLf+oNHWSaO8NoebEaqiunZd75RoIZWSaAxYg1gq7JqcB2AlFkT+pxT4xQjLC64P0cZD8IvwJbnIGZTauAArGigi29mTuGYrw3F5DLlWLU4E3X2neOcoMlmzAConchu8f1f6ZM8DhxY/FgfTmtfPHknLikJbntTGNiN7egr7umOHky8Es1r/lwidq3gyQ6t2dRB6Moo26+NSvcLaebeSWHGbyaLFFSgQG3t0w0wL2i5uZRcSlRp+lONGY0OUtcTreGu99FirsqgFsGzW3gc1c7glsNVjiYi3wmWnK0MVVfXp9xwJu0Fp93Gc9V3awkaDixSl84D0/7HxhOeMFxtgWFHuBRDlRy4/v9D5imDxEXASVT3Kh0JPEhOoRBAXkDkrScD717CuFaxogHM4h/nMWAFeLBoLxhERup30bxCwwKPxkejIJqPEGLZPPURMks+W0B+z0Gk6TJ7kD7Afs4PX9WhPJ+ycTznzDPeiF+ip079Bbr3T5YUiSVsZzzCie+8jNZcHco+D7ECERaXQtEpSzqlVjVDUzmE/56RNok9rGTr/Dy5ZGx7IrZlsI2dWiZTzDd1CecU1sl08INmCfCNNSZ/bHM6GRDgad4ksqO3RyDMQvbjvFOEtdzOXB4qnOXrPUbww6eIxWMkxZLpPLqrdYogPTZ4g9zhUxNYMYDMfRqnEKEARZ4HeE/NgOtK8Y2RmKyuJsm669+XreMS/qp4JTLdQA
 j9+vGUB8
 1To6BrGcg9np7t/wx0wpfAVkn43/c3Ke7fH4k5GEuxIQa/SRfH7fF2K2P1oegTJOyEkQ2PJqyzolpgGd4VixnFd5gAzCT2EwwfJqLUhqPAQqkZeBygPmqnLn/N/gxazofXjLvasFoB1alqXYLyh9o3LDMYgjcHCEkSJ60V+snRotxg4nvPcQyHuAeQw3D5r2gFRaUWajoZ5ueq4Caebgt0XPpkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During the execution of __split_unmapped_folio(), the folio's anon/!anon
attribute is invariant (not expected to change).

Therefore, it is safe and more efficient to retrieve this attribute once
at the start and reuse it throughout the function.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
---
 mm/huge_memory.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3c74227cc847..4b2d5a7e5c8e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3527,6 +3527,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
 		struct address_space *mapping, bool uniform_split)
 {
+	bool is_anon = folio_test_anon(folio);
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
 	bool stop_split = false;
@@ -3534,7 +3535,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	int split_order;
 	int ret = 0;
 
-	if (folio_test_anon(folio))
+	if (is_anon)
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
 	folio_clear_has_hwpoisoned(folio);
@@ -3551,7 +3552,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct folio *new_folio;
 
 		/* order-1 anonymous folio is not supported */
-		if (folio_test_anon(folio) && split_order == 1)
+		if (is_anon && split_order == 1)
 			continue;
 		if (uniform_split && split_order != new_order)
 			continue;
@@ -3603,7 +3604,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 				if (split_order != new_order && !stop_split)
 					continue;
 			}
-			if (folio_test_anon(new_folio))
+			if (is_anon)
 				mod_mthp_stat(folio_order(new_folio),
 					      MTHP_STAT_NR_ANON, 1);
 		}
-- 
2.34.1


