Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7AF8CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041438E0126; Tue, 14 Oct 2025 09:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0CF68E0123; Tue, 14 Oct 2025 09:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87218E0126; Tue, 14 Oct 2025 09:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD6528E0123
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:49:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E19A13BEC9
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:49:30 +0000 (UTC)
X-FDA: 83996852100.29.64082CC
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id AAADA140005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:49:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OFiXpmBN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760449768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=bj/feOlBWwkuR5XVo/xiuDZQHb2jsSSZcYYYe6Ph/+g=;
	b=CpsjVSVGeUtGGv5N4z4/yakCtSepdesAm9Lpg7A5z1Qq4VbAz3mcZzgHXj4Xy66dPaetbA
	WoMiYPs9FGBzaAOvPwwC23eKZv7+U2IXt2/slhS81/JxcDNM86BDGhTZW0npL1EdabQFUK
	LUaH/mVGXG1C3uY9vGsyEjQQ5uYPUUs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OFiXpmBN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760449768; a=rsa-sha256;
	cv=none;
	b=HswirWVV6ReFHzceteqCqgjKuHHa2pwnq+thWhRh8YBFDXoEgXtGpD7m6gZsUnpUVV9CCx
	BeD38dNNyP1R7dhMF38TKiw8rYdK0FgTmNUuozApr13JVJYFRoEEYRATE4ndNpKOwsyYys
	zfpYmfO+FZ0DZrSR6oDDr3rA3oIS0Lg=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e326e4e99so30994525e9.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760449767; x=1761054567; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bj/feOlBWwkuR5XVo/xiuDZQHb2jsSSZcYYYe6Ph/+g=;
        b=OFiXpmBNwqW5nNryEnMLCt9dhNooL00drmtnhdbPfzGi0/LR0io6QABQ0tICEeMage
         DvUUSyYbFKxudU7gp8kExWmi6bJzxaX2b36iAaWQECVjeEQEOa9p20BMglMvZ+70fjJX
         FEqa60Iayq0z8tnEC3a7SaiZTG5ttH8sgCaTSTIBdkzsbceh3tt1GwYTrcP6k/NRkcTA
         Qsqjt1IcUaqwtGxzpyXKci62DmqO9/EK5R6mzL/n9kdGwB6vsdNHOkMylSI7N8PH5+Hz
         oyyUyTZN+DDwxxYfTagKbBuk/a0NY8S8nZ1zociUokhdfpbuNsJoObsCJAHUw/U0sj2A
         q4ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760449767; x=1761054567;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bj/feOlBWwkuR5XVo/xiuDZQHb2jsSSZcYYYe6Ph/+g=;
        b=b4mpZ+noyEYXS6MOOr7A9fRq+6PjYFLPZzygWQ5BuXv7xJGEk9Capv+x1N3wTDu7xq
         z2tgtcogvRhZgrFVppIWX0Pn6v5SVGnl0xLrEtcq0Vxf+CP9+pfP9HqkaejXGyjSoAUF
         tJQomQYy95gpyxlIDfFoJ2VwuCn+hFXrxI8FkwWq86ibknWWOUBWRbmPbqW9AYdYG9d1
         Y87EgLs79bNMkC7GUHTcEFR0HxHo1frJPY7gqeytxIbwUvmbFCLenWXlG8tD584pt7TT
         0fd8BxqmKdvvXBCVotG3ahyNHzix8GcphmVzekRgCyqw2Frn8V7qw8sWmbZMeSUnjFQA
         7JMw==
X-Gm-Message-State: AOJu0YyY4Y3uNWoCWy6CzMPoHiMnmhHgPnUHYIeNEvTKJBd8cAXZgy6x
	NeDdLlMpqmJFGVZbTrUETeakFKzb+ouH2+5Sd/qEJ9gqUwYGvuMF5L7/
X-Gm-Gg: ASbGncv2CFhO67E39zOqJIsMB3AYLHwH9HCk4jd7wIYsGRN57w/yGahBaWk2eVSfkpC
	yJo4ztbO7dYWL2/2zNfWR0hcooBeDFokMQs8G+KBkKLSgbMiEUxceXepbJidfXy3k7EHgeu2ZfZ
	w5uzOHHWPRg5mOjXsoHWVx6yCQKObohN/VCE5LFz2H02YtO/5dn1x4itO48Z+DG9X9tl8Paw0zA
	61o02gBV47OvavxNaWvknqMrEGXMwnMtYB6Qj64wmiJ92/IiJGSr+QLF631P9bTufIIi6uEsT59
	W/Zo3h7vaTguUo0qj2G2Rtz9GT9Qu4evEaWo7ZbDdxrLbuQaSAwg2/eIckDOItqq8e+N6cylUcd
	onHCVVXDxnxm7LD6lBEJPUl5W9H0JNkJ3h7gDWIbmHbAyBy8iycM=
X-Google-Smtp-Source: AGHT+IGvdDmFYwYYes/wpo+Dpppfnd8l8hOSnA3vj2OAMwAoP2cFM0Otkh7bQGhHPlhqKmTelWpaPg==
X-Received: by 2002:a05:600c:450e:b0:46e:1a60:c995 with SMTP id 5b1f17b1804b1-46fa9e8dcc7mr197605015e9.2.1760449767008;
        Tue, 14 Oct 2025 06:49:27 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57d3b9sm24092534f8f.11.2025.10.14.06.49.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Oct 2025 06:49:26 -0700 (PDT)
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
Subject: [PATCH 5/5] mm/huge_memory: Remove redundant split_order != new_order check in uniform_split
Date: Tue, 14 Oct 2025 13:46:06 +0000
Message-Id: <20251014134606.22543-6-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251014134606.22543-1-richard.weiyang@gmail.com>
References: <20251014134606.22543-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: AAADA140005
X-Rspamd-Server: rspam03
X-Stat-Signature: auadgizjtwurpm3ji1mdcqa9icb56w4c
X-HE-Tag: 1760449768-68920
X-HE-Meta: U2FsdGVkX1+PCOFt9J1EM2hombEm1VS0V62N1fCVRHqqRuNQO/FKStWtq64D5/cXFw21Annsj0N575DQY81C6oRmtgsxY9OyjMz7iKmKnfjc618o3NSyra9A+W/+D37ZzA7OWgEgAOvQcOvBgI7PHL7AuNuWp2uY4o2qzpFtfFDt2eBi/gxBH9pgp+wTZdhRn6bsEnqWQDGdXq54IOVbaPBtB+8tJIMx2MXO7mWoI714FZ+785x6MtjdtmQ97DEEX7r+ssPQwNjP7wovxheHklNpc7lPmoRSulHbhzht6kFB2cCP7ihUWz9YS+TW1u2DnZ2UjYgQ1O6OfG5pKbnRSIlh7SaYgpjVha/wo23LQdz5IFqcSLENuYUMm82CINcS8nZQxWC1DkT4feP0eUIvL8oMuQqMosonZcndtiU2ofQx1DjjHV5BkAAnNnTf3aIhlon/sQRu/PY2QiLjNf3Imn8XH0TKSgYrTtWcwcWTGSIokKxN2SnR0ERC6vI66LIN4NZZLLBR8F+lyJ+UR53FlxQYc2VkgdkCZm8SZXxbv2BPP44rhJC5+VuDmyZKb26o1sLQZOw7HdRtmG86d4/X6Du/XFaTugKeLEtK3QA7dClrjS+vb0FpJosUPPoPPVkwk1CSUvb7LvgZ6XMfmcP032ONJ3BhLGGfDfsBjhzzhrcyO6dnCfkZz9jl08hiCCgmt2sMq9fnqOUxyzYethYr9qlhTrxJFgvhyBBOMTzaBD+l7/M3g9ww7kN6kdPFyITc56zjyQ5vs9ydTet3Bx3AZkGc1lx5wS3c2KrQi0Etqcw9Z0aZVFDFQlJ2mfZqLsTtSxWSFqNbTUDc2BTJE1rpFQbWQfHGUDzMY6yauTNPaDFAmqjUJW+qUYybfim4hFghTOOMQAlfzuGJIPSkOR1onP3BsdJNa3UFw5PcU6zorSUnYfy+/Osxl4J6rEiWIJ+2+KVpz2fFhNySF9AuThe
 2H6kiWG+
 +8bCXBVovUrmfjrSRMowRqGvyMy2Y2QBKdPfKamKEKdBXWMHoRZbCOdqaF6DMdpvzIWDpnAyF6pQlAFcWkca18OXf11LRmwosrGQq71meqQ2zs0lZa0SKCc6gfn1aX3GrS0MI4hdxm1wVdSxG2yjNvrHpCXhN3CKYz3UtWgI/liOz+QPkR+6cEBm7qZDZRHCA2wS6x0JK7yQW6mrcLWtUbo5u3wBtnfZZu1r7Xx0vP7bf+rPxdVXwn7rISRDCJk7cPJeYXtdoh+PutfekuXTJYVrBKNTJ707gOkRT08hbeW34JUIPy+104NwkF4B8e45SnZAbGo4ZFZfvjEZBvx4syy5AWvfiDUpbkUpa5+h3tyMaDbcJydLnWSc3j6WE54yPvPNXCu6PC7OMMOHH07bRhWO1IVUT+FYzN4BEiy7ZayvTBANOAcf/hRBF1UBz3InF3GV6E6Wdw+GcSx5zZyz2EYvnKNRRmNkc2uQ/ktYIBK4ODqCoLFkEIdygGa9NKEo3kB+kip3+OPFVWrW9kCx0uWLGW8ewll0zQ7W2HrDc8G1I35ubte2MvxuIZZVTx7BSLH29mHjB/+PbdWqb64uSh5ms9K6yVzJ1M2Q8w46b7PF8ESrym+zlHzPKYKzRrmEbX0QH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The uniform splitting logic is designed so that the @split_order
variable starts at the target @new_order and subsequently decreases with
each iteration.

Given that both @split_order and @new_order are integers and the
splitting process only ever targets the @new_order for a uniform split,
the condition where split_order != new_order will not logically occur
within the expected execution path.

Removes the check for this non-existent case, simplifying the code.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 63380b185df1..a1f0da9486eb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3545,8 +3545,6 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
 			continue;
-		if (uniform_split && split_order != new_order)
-			continue;
 
 		if (mapping) {
 			/*
-- 
2.34.1


