Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51FC5D3B7F2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56156B0022; Mon,  8 Dec 2025 09:36:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91746B0023; Mon,  8 Dec 2025 09:36:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7516B0024; Mon,  8 Dec 2025 09:36:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 835776B0022
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:36:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DC3614019D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:44 +0000 (UTC)
X-FDA: 84196555128.10.4077340
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7ACD6C0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LNbvTaD0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=b58eopmRYaO07fZ3crSTh+RDfUHvxnj+RWyrG39lEC0=;
	b=w9aHyeC8BvdBrcrTRx33rvkvysyPbWYAA1G+Lz04GRWbx7yePAu+LHKg8EeJcmsgIvkwjP
	XyWYwtqPOPOkjJ0Xr8PZWLqfSq4/jwUtEjaPbgdqaezsoLflMnu7wF+NeOWsFWyGV1ejEi
	KZ/1lSiX4MTpKvHrlEcoDGzlEgMZzrE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LNbvTaD0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204602; a=rsa-sha256;
	cv=none;
	b=T/RhYDRz4kRJTc7C8aa+2TwK1nB3Bdfw3F9c01Rb3JvADyME2ygAuuIRv71Rm8UZhID+Gv
	NNxhHenimcZSQxXp8WZA1A2xgmDZNIxcyUPm/0rQ8AtGWeDE0SwWyOzHGKFTdgcCX0cO1T
	09CUB8rnIOpTPQzmeVAGeSe6mja0bIc=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b735e278fa1so743783066b.0
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 06:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765204601; x=1765809401; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b58eopmRYaO07fZ3crSTh+RDfUHvxnj+RWyrG39lEC0=;
        b=LNbvTaD0GbR6l5xZo33ElzqTk0xZYxxffGN/qRQ2/Q2R3AhQAMqtGgnavbx+0wR8O8
         4TPbdbfj5ixHindE3emF+ecpdg2vBguBfw8vIP/olP/jgpgg77+y6mUzx2sri4bgvB5M
         OIrdhYjMeG86lNST6IFvtGb+pjDigT5oTA/vxx1eVdLOE73VAER7vn0zbPwXuoAbG2yz
         +hewQ/3tQJKglWOkMQhn8IESQdlhXs3grpH0HNUub8r0jkqfXqApshP7v/gMP9zqmjZO
         XQr8jW1epS+RQf4TWyd6djrchBmbmYnKveHdBO6og3K15cK4yla3LeES2jsn1WIIMbZI
         xclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765204601; x=1765809401;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b58eopmRYaO07fZ3crSTh+RDfUHvxnj+RWyrG39lEC0=;
        b=Z2aXyPU+PZTcRxVLNSPM3f17LR/iUW1er7frldlMwJvNcv3RRmkAvuQmfQgb0WDK3u
         l10hh9EYAqnytKF/uxvDsjKgX1VposJ2agGhPIrCYRFyiba5JJFUqvHo/b3wq6efTp/T
         q/ggz2NFNfznaBJXaksx0NAedWzyYeMn/eVmMJvm+rwDyD9pnZhB5vVkDS+W1DkDr7uM
         2HUqq5xNJWjqVIrryUdTC7/HDGDQwD9kwxTEUJL2veS0SB9nYD5tMxbz/jE45/1LKxFi
         GAAttzMKwDYRTz0WWKRWEcQH4omAdaojjyyxNKyVsWtOyHixK9kRm2n3ypAK7S4OrONV
         tnYA==
X-Gm-Message-State: AOJu0YxBxZs7mdE+1sfrn8YCnqgMIbcTR5rhe9UFYObZfZg0Iq4nypAF
	szjrxRYZdZfi1b7q6qqODYBM3iFjHQyaz0+ttXA+GHakuLHafSC9uDv4
X-Gm-Gg: ASbGncvG+zLGNQ3mlzbAl1/lQLYMYzX11dOgxqRCA93Uj7IKC17sA6U7L2qMj2cuwn9
	Aatg0B84g/KaRj1iZbyjs1jylf2K4jzC+kdHtKoBflCVxepyvK73Qy1WUo0kkBzDvQ6yvs0qmsm
	PzwyMGqv2ceMaFE54Xje6nRG3EJcsU9wUfGRcYelJzKLNGXSUfpXSS3jxoE6vOOGvHGlA8Dt8Z5
	FVhtTUbu+DZsk5/4sJKFLULC8QlGAB4bLfXLpz1beJ+SC1dOKbVdG/ouAn2efJpY5FKczqJjhJx
	eIzEOPJJp8aZUwpsAnIGNlgoPO18fYoPZkMk6VMPNDLA90nZEqMGMCRBPQaOEunFopcBpFE9cs3
	IvEsaLzhqXGMLwhWBRHut4z2wwDHJS+j51jKGKJ/0RBC2li+k79qZXgsm5Id2Sd/XtkzL2/vIxW
	b3foOQEvSZYg==
X-Google-Smtp-Source: AGHT+IGFaxh4GgLQbO7hObotwQw6A8cjcfe6lKEWpbP9jD91hTufMIqRYM5JQCFgbiPNiMQ5G0h/PQ==
X-Received: by 2002:a17:906:d54a:b0:b7a:1be1:821 with SMTP id a640c23a62f3a-b7a24851d1emr835666566b.62.1765204600612;
        Mon, 08 Dec 2025 06:36:40 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f497674asm1085416866b.38.2025.12.08.06.36.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Dec 2025 06:36:40 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch  10/11] mm/huge_memory: convert folio split helpers to use folio_split_uniform()
Date: Mon,  8 Dec 2025 14:36:15 +0000
Message-Id: <20251208143616.20797-11-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251208143616.20797-1-richard.weiyang@gmail.com>
References: <20251208143616.20797-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 1i9o3qkarkejs96bpurjy5oedsj6zhqw
X-Rspamd-Queue-Id: 7ACD6C0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1765204602-761227
X-HE-Meta: U2FsdGVkX19mp3kXryPPq2ujJyQmVm6ILkyostWC6feU33tydhmWMpacJrNMqahz9RqT7f2fuUW04hWjJGNaNBksZ4PUo/O/4r0j2t/ID1pOuLeYY/77d7CSqMnYGiAsS7mugMU8rZ5WCdAKVCtuUglmwhZTeZnry0Q0PSbVG9QnYpH7opo9NIA+Ti9fHiEbdBPdvQkznejf/glVk3U5egwdKRTNfB4g90C0nxrar2kuBQ9n/XXXasUEnomYGjDHvNikVTxziqHoxasM8BeQ2KDoSsbut7pRSgx+/cQLLQ2hE+T9hwqnmxDMAZcXP+wbhwVInW5Cw71qg4WgnE+cU0IrdRCQEVZyK8beOpgcKISPVfCEdfb5yj7ArAH1XBh9LSVIUwCmFaoRsjJjRwbUuZ1hPWV4pf9+QJnMPUC3asrt7EfO+BWoHlAB0s7bBLJH4qNy/H1OXtlp8Mk2EJkcJL7i28IjdN4gvsKndNh6vBICUR/P12XMEi83oM99ZVslI140XZlFqCa5sPnHIbE2aBM+gzDoFybEw8+0e1FyMV6L8dL5eiO34x0OMoWCXuYtNSZ0UttN8rC7zi0BwOsswiUnzNOpSTjHRaoBhP0oW5N9ZQ3GorxwVsYCvV2+OdlryNWVjn05HIbkhevelN2eOXGD3tPMqbSWVc4KVIyLrsiou+3l7/8X7q9iRU6kZ24/xwr+WleACbsW4wKsIlzL4Y7lucs6lF4b02NPnW7bawET9f89LEDEl/LUnP+Q7KwZEBP50v1z7v2dqqF5blhVN8sn2EYJEFyL7mpTwoEs9biPcyHrpUgrqRFSFUcpqxUEMXjJHUD5pjHjFaM5uTCyi2aB1EcixjDeMGVu7LUkBGXyQ4KJyz/679KEx7NId0dPtoUO1T6iw7Qaun0QpoyyhpcVIIVI/DRBuZa/KSX/TwjBvSd9dWTCQi8WyXg0GmMIhYkYQFJ/scKMAApEaJP
 ocXHP9br
 ZVXQyVON0+lGv6/9HBkRdwiwi7Eio+7Eh+3q1dfcR9JKWIgy2654vziOpb0MjyW1rlDjXj9ONKH7GNQ0bQgyFgalwjdLguntqJ5TgbStJ5/2/kGRsL6omR6A8B9ZaGT5i5TD/kSVG+aH0D+rE9K0OdbEQyFrvxylx3Wex8WYf+gL7i7KgnC1dP6GQILRm4nVp6bLul1ca5IV9601KKMtSbtQkUe2w9wUcW24AfAiveRSS+s3V4k6OeyXiGBChBCwxCDJLmsvrYt0s+0/7gJTxWjpCpTjMmb2jfCuZPozXjnoDJhN6/GIGBMh9W/4m+lNYazzC4AwOWxOITkyye11Y0tzPbyvSWg0F/TLBLHxGoWm/buVUofbQqkX4Nd4dgl2xbxt3sQzLa+OJ6vk9nF8bD4sQCT3NYM3UzVY/cVWgjpSrUdfkpV2PDw1tE1lp57KhcSJRTPadoh9f7ImgSF4mE8OkNfR6tXvEP5lT3e1LIN+iq6FwbuMfZGIO3+bbcuNjiCtcyaJwMV//CBZOVkQV5TNlxCDZQno6OTQLqRrOoisUtT79Q0nZz7E9y0rOxbN0sKYhJUa7TjtP7GqZktmYKH5Yt/rceYUdovzkb0SLsV+aB19BEbhUlZtl1skw62AWEYOR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The functions split_folio_to_order() and split_folio_to_list() both
perform a uniform split operation and return the first resulting page
locked.

This behavior is functionally identical to the recently introduced
folio-style helper, folio_split_uniform().

This commit converts the internal calls within these functions to use
folio_split_uniform(). This conversion standardizes the implementation
across the codebase, ensuring consistency and full adoption of the
modern folio splitting API.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 2 +-
 mm/huge_memory.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bc99ae7b0376..95a68c19e177 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -388,7 +388,7 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
 
 static inline int split_folio_to_order(struct folio *folio, int new_order)
 {
-	return split_huge_page_to_list_to_order(&folio->page, NULL, new_order);
+	return folio_split_uniform(folio, new_order, NULL);
 }
 
 /**
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 09742c021eee..cedecfc1a40c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4274,7 +4274,7 @@ unsigned int min_order_for_split(struct folio *folio)
 
 int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	return split_huge_page_to_list_to_order(&folio->page, list, 0);
+	return folio_split_uniform(folio, 0, list);
 }
 
 /*
-- 
2.34.1


