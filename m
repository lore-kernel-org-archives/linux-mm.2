Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6888BCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 07:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFAF78E0005; Wed, 12 Nov 2025 02:24:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AABD58E0002; Wed, 12 Nov 2025 02:24:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C16B8E0005; Wed, 12 Nov 2025 02:24:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE598E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:24:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F531B9160
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:24:35 +0000 (UTC)
X-FDA: 84101117310.04.F4D952E
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D5F640008
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:24:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BZkx8BQ0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762932273; a=rsa-sha256;
	cv=none;
	b=rziobcnNEYLPknecT/DkqmVwo/FKR8pMyi2FpJO2+LukErLtB8+Boqloys5uEExk/GGvfS
	MxACmb6zTZRmBSGvbyITzP/LmGaq+v95ngYgyLmE19GDrvTc+83l4Mv7/fiv1LWW0t3T9R
	Pdv07ocMt/55lBfkEnQMJjOMrLefrcs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BZkx8BQ0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762932273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gHjs64x1sYM8PIf291RcKqDCzlklmWGwXUXJRSFHLCg=;
	b=FG/l3PDjr9KrU8N90T/3xh35Xn/Q+JuWzknB4IHWrkvXvIiptK6nJiiwGFWnAG+AM3qaYd
	AXER0YvjroeOlnvHzKp6L9hdb3HBsDu37YaIiOQXooPD5t6tWEQIm7uUaoPBJC0aDUUUKJ
	I8zSKTPHQwqvlj5r/57RIfazPhybHKI=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7a9fb6fccabso431370b3a.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762932272; x=1763537072; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gHjs64x1sYM8PIf291RcKqDCzlklmWGwXUXJRSFHLCg=;
        b=BZkx8BQ0MS2vhuQ8oG31kZSwzDK56n4WZz9K0KIXuBOuMVsSaG/s+sPDwlcdAAFg7N
         L/Gs6a1D+dOvG3NmOjgijMnwVTaD8QvsQCCWMucsuxa+OLXgmI4fGBO2IccHGIi2rWAg
         BCqoOj520Yi7JN1Mwqu4UqeNv+bZQtmrzSg++3LrHM37f7OCst4RrCrq9xoYtYeA7aAm
         WQTg8TdI6lZ8zzava3JvFedZdjPOjhDxs5wMu5S68sTeplswDHgNWBm0ZTXOgH0FizOx
         WFkL40utISPJ+gUkE4p163fgtxM571og2jI1cMvASVMVcU7DQY/tkyyOlS+bAapHPL01
         EqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762932272; x=1763537072;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHjs64x1sYM8PIf291RcKqDCzlklmWGwXUXJRSFHLCg=;
        b=EQ1hUGtHojlcyloJ1wLCtzKzxV0G1Dz5e6d1+9PxryZJu9tv+0ReuMUvAw6qgt62Df
         k1b6Th64Yy0r8uFO9lKTA7EU04jxdp/go8RP+e2ACVueaKXqnFnxFZFsZfZTcZJz3KaJ
         HEt+UKyskHkTvEmoXaRPkRQ1L3Mh/F4rqSp5YYkVxOZs9o2/xQZC+v6EZb39U+edZ5BJ
         EmRtqPTiKb+s6pdMP1uXsSdw04QjyQcCgHtUf/bHiBj3jz1eHAtONTXOEXSq1CxfTd7L
         MWY3ewCuw9+M10S652+AfcNYSWqnUM8b7+d+4yNapiOOtQ6RUbSQpHsEXpId6leqh1M1
         nBKA==
X-Gm-Message-State: AOJu0YxXAxVYNgnQjgRY+TQ2uO7itHMPjS9Twfi5Ofxqa2mSQqgCHBrw
	wjRjX44xH1IrsP3SfMCQj4jHosfvvcZW8QFfOdxmcVZp12fA4hGghlj6CSsML0qgivjfYQ==
X-Gm-Gg: ASbGncsJgcLljLr/SszpasNQVcrFjKQo/bHW62WHbptvE4UE5BGSj6JyZMxDzeoDIdU
	c+w9aG95e+uNrp3JS5g/X5ACMLVdJHcpNd/lmAeKF1t/7lO54OGmRTgP+XSwBZk7HL75rSLvuAL
	MXvKh12+vqwRBXNLOrwoYB+ToxmNEhMiinSoBiCaxjV8ub7MsUIAE82/E3l+55YTYenMknIl8Kx
	D6VtIH+xsPstW3jlp0rmJoO20ucSo8satp8SA0BEZeVJo8lyyjCopTp3zVe6OrsofcmBZuyeFDE
	PUa0mfRqTFujdRUERXUW4nazsNkVP0F75b2qRb/bs2NkiOHGt9s2l2P9+Co2gJF7yc6EnZXuuVI
	eQCT1Zh7H8q8WlpaEXlKzN+Svs/TVXBCgtNQD7EiFKiFHyLYN6/hnvGAlh27iaInVe2CmZsRVmp
	Bh0H9ACQiGhQ==
X-Google-Smtp-Source: AGHT+IFUZAAP6TA8tNra5vdp5shDkkx1ePydRmct9+JBO8i8YD0QZYerdN9x2vPVqM44KgUCXLMhvQ==
X-Received: by 2002:a05:6a00:1397:b0:7aa:8397:7750 with SMTP id d2e1a72fcca58-7b7a2d8fb0bmr2111013b3a.12.1762932272063;
        Tue, 11 Nov 2025 23:24:32 -0800 (PST)
Received: from gmail.com ([117.147.73.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b811183c77sm903311b3a.20.2025.11.11.23.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 23:24:31 -0800 (PST)
From: peng8420.li@gmail.com
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@redhat.com,
	osalvador@suse.de,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	"peng8420.li" <peng8420.li@gmail.com>
Subject: [PATCH] mm/gup: fix handling of zero page in follow_page_pte()
Date: Wed, 12 Nov 2025 15:24:24 +0800
Message-ID: <20251112072424.125514-1-peng8420.li@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7D5F640008
X-Rspamd-Server: rspam07
X-Stat-Signature: dfjiziytfquxoucgwqf7jbqfejoxo1et
X-Rspam-User: 
X-HE-Tag: 1762932273-340725
X-HE-Meta: U2FsdGVkX18xmt10SGCsRGwP56iSZCnGAXO1fypijPG/n1zzqauMd3puzRvCTquzQiQv1qfatbLQMJUHQlGqqTH25z9SFt+AYeryCt0MIcw1yuIpLSRdP7bkxskcgxnbQSQ+2UMg0nvvDvr+Ethe65te49VfB6YrRa5SJLwxbAd9B3CcK3ua8xPEe8RsuE0pLbK0C3gx47MV/HJas0PnWo50eXIOxYg7lJEqagNhuPRaPQDkkpMFieCbyncPAIRWrDtVz51xI+v2ylX2Z8Ysq5OMPqBN0T5l93YM38He9dtdhTGWKO2mwTDyWfIC9vmoTwM5QPqOgXEiVspnNakM2FaHinS/hPl+Hkz9zvlB52o+YK38C/0VY7gTr7k9HI2XUU9uG85Er9ZNsdRPbzRcUHyYNxVDywtfJugcQBiZ5YuwigxaIKnA+7NTikMhkCNa8OQxsnYGC+wTATYqA/cDl8io6OMp0RJ5vH+iy9VZm56j2wI/r1dbBEup4L01T9nQZtQrk9b+yT0c7AcsiOBV1c06OWJrpX69RKc77ibCyuhvMWejqTbFQgAb7K/UrobvPtI1kV0xVmGyUetMMdTt+w25Qj6ukd/GeSgTupyVYEkrS5JFQeAm2RSjlOTnl8dMSPw5pG7kPffY0FLcOhqFJkpI1n97VE0rVSw2S6tdOXk1pxOV95eQAoZhe7KI/KlvfP78WObFgfaiR432clFsAILCx6ur/g9BbBut6ABhez8deKnyPO5FDC6KUTD819AjpvxPYLPXZwFnexFPWnAHDGcT/2rj6QEMzhUwS4D03UnP3GGjwAipNi+5dI+xTaWyuUFXN3SZZgfB1GwSZQhTIeyIKAvG8jDpCK42ezpuGvmqQZ4ius6vynRkqLuxrcmBJhqhNkA6mP3+NuCoCqhxP3ydMbSRudComR99fF2aW693J0OlXTAgULjjp4Wpk7sfJHY6cn650dKquC43ugD
 YqN2OKLp
 QP5G+DJYo+Y+Pljsrn9LbB2bonAXUMii687faS6ebAn9D5q8wgcPrWLNxptEv3g3opIjoTtTtVnYVBmEzQXbYzGCd5V50qP1i3R3o1zajg3UNZdMPPl15w5VHCVHfYgTjJNfaG+8BryxcpLHKS4Hn5WLgRACxLUifv6b65UHG5AxM1DjjyjTC+HCPURRMj50tQ9geyiuVl9L54mKPbuxI/cDrWbcIXKm3zP42W3jxqz+IYNb5efH9p3+NoddRdx1Q3jsk/G4vssYwBRe9ic1AZ3xqY6SvM7ZglKY7L13TLQNuB1jXFbZO0pL18567VFDqTM+rIFGFk7FTVi1G4MXhoFf5QN4sxIYpPJylKjcWwlgr4t8j3k4dCpyAwEqAEZ/f0W54ZPlLWBUPx9pWE8WpLg2l/2dEPy67UwR4yWIHv9733Jh46eqn1Cu72K1Edn6G32QQlv3nVPMe6bT+Q5DvflrcP2iOQmzzsvIXBoe888hpfvMX/k/K5FRB77jLniju9krnburuKGHDYyo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "peng8420.li" <peng8420.li@gmail.com>

In some scenarios, `__vm_normal_page` might return NULL.
In this case, if `is_zero_pfn(pte_pfn(pte))` is true, simply return `page = pte_page(pte)`;
no further folio processing is needed.

Signed-off-by: peng8420.li <peng8420.li@gmail.com>
---
 mm/gup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/gup.c b/mm/gup.c
index 95d948c8e86c..60ae5f0c20e0 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -838,6 +838,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 
 		if (is_zero_pfn(pte_pfn(pte))) {
 			page = pte_page(pte);
+			goto out;
 		} else {
 			ret = follow_pfn_pte(vma, address, ptep, flags);
 			page = ERR_PTR(ret);
-- 
2.43.0


