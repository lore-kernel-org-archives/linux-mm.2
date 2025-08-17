Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535FFCA0EE4
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 03:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BA1A6B03C2; Sat, 16 Aug 2025 23:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D136B03C8; Sat, 16 Aug 2025 23:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F9B66B03C9; Sat, 16 Aug 2025 23:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 004F46B03C2
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 23:27:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B087F837C3
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 03:27:13 +0000 (UTC)
X-FDA: 83784813546.03.65427CC
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id E616120002
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 03:27:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nSbq48C1;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755401232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CrmGOnC6hI2nhDhI34QceOS34XNO9l4/iKzGa/WK66o=;
	b=MnB9gIA4JZ5lq3BKPka65YYNwqRWh0nUUMX40HzSKPwsuN/Xcgj+xtsYYtJt2UFjvXQZIk
	cipp+qhDNv4tyX3ciL+VUXtp8uiECL9AsmqHxZ2cGFx4+qCTnm8mnGw4seHqsHw5pd38VN
	MrqgYTO4+eTDXrCH03ZH9EfYo+AeYG8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nSbq48C1;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755401232; a=rsa-sha256;
	cv=none;
	b=J/OpeK+oWCfW9N84RKV5qp0rYo2Nv4aqGOn2/Zaq+bxu4HxYGPRMnQZP0dOPqheTOyW+Gt
	K2y4mPgzsHQkk8ZISQpFGUv5x+2EQL5fDLw5rUkClAX4T25rej5mWsr/07J9ACkWWYnr/0
	FIWPJvuZfaec+E+tyKWfhoGzNga2UrI=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6188b690517so4564607a12.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 20:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755401230; x=1756006030; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CrmGOnC6hI2nhDhI34QceOS34XNO9l4/iKzGa/WK66o=;
        b=nSbq48C1JRzLoVPo+faptsNWQiE1aB90O2Yvo5kyqG4BdJlgE3QqfJaexu3LL72sPh
         V8Jd+pOl3cJPYZxdY8dFH35O3MF4Z8ILSOILPOBXpMNnen7EdKKYKZZSvAFmduRMvqAZ
         EICJUEmRIuGjlz7Pr5I/RTZE23Tzm7GjfbnVqc+ay0QpcK7Ys44b7yXUu4gegAVl8DuZ
         URdlqfJIN4FC1hCDnQNmlZXCSNH2i+SJBnGRUi2yh8y61arksHDnYnSSWiIj6iiI8esO
         3fWa/vmSMs37UrxtGVmiKx60HK9mWRbc0YzYGA4MzUN/n8/pu41MxzMwoyZsqufEliTC
         3ukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755401230; x=1756006030;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CrmGOnC6hI2nhDhI34QceOS34XNO9l4/iKzGa/WK66o=;
        b=VScCRYTCgQ1QqtxqTMoOt7VmbDgLezyXCPta4pf0Efm33lxNAJ3fT8lsDZPYEuYVJr
         Zb3936EHgtd0bWOLGROMMh5oJ/sk1MZLuvwQrSnj07ZUQk3R9qUYoAFEMPZCXmsHG4oO
         0kFr/qF65XhKowFdpL69UeSgba15nEGLiND/WetxbxwpFhMV7kXSwSFIrPequy7KoWwP
         +6xoxCHwWMRzL6KdTUh1dyM9A70PYLSW9NCINNwcxLz12JelJTr+zEPxVCbpW2iYT2u/
         6+SvqutBeiM3B3s23Ks5iDF04NIIXhvNpoyNFKiwCWVfyNHTpHWaNaP5gzV9WOh7gsSv
         cF1g==
X-Gm-Message-State: AOJu0Yzw6EqS8RqcHF+X5eTMDWPHfRNB95l/ncWDM0eO0Ejer4BRIn2a
	bnmxTwX0MtAMMDKXL8+o4YfYIArKC1ahLGJT7kEO53XKZD96QouViI2t
X-Gm-Gg: ASbGncu+cBP1rJrR1A0S7EtB4AXFzvwu0WqtJ5aN25CK+825dtgEL9Ir3H8xTTv7xtT
	99HGuTFFPXBXIQpi9l2tP5Og8nfNGod1qtWfnbxC6/O7sQKoKQrmFi6KO4/WQLNpNd58AYfP+0t
	kitKn2qw9SsjM6Gtl2p9yhHiaF3/FlR5YkNC2qpN9shQiUPaGYuXU+9LW38DF3OfRJH1rtArNue
	rOW5cNQNBjBEFA46pmLZaiNg7DkEK3VObfnicieNk46ezZTul7b2v7nc2NbZqaC+h43useHdCsp
	wIhW5/o0E+rHrsK3iUm06jCbLI6hF1jghKw6UILgG+kEYJ7SJC9avX+xKLR4QYDU1Ysz91Ink9p
	exzDRwfNtf2+3+1RV8mXQoA==
X-Google-Smtp-Source: AGHT+IGQHfVP0KJfTjBmfehT26Q9ylEWbO9sMkg8xqW32ykIXn8ZVTTu2A4sqyC1VPLved3Nr9PnOw==
X-Received: by 2002:a05:6402:35d0:b0:618:a4fe:d821 with SMTP id 4fb4d7f45d1cf-618b051dfccmr5918864a12.14.1755401230363;
        Sat, 16 Aug 2025 20:27:10 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-618b01ae57dsm4337685a12.29.2025.08.16.20.27.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 20:27:09 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 1/2] mm/rmap: not necessary to mask off FOLIO_PAGES_MAPPED
Date: Sun, 17 Aug 2025 03:26:46 +0000
Message-Id: <20250817032647.29147-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250817032647.29147-1-richard.weiyang@gmail.com>
References: <20250817032647.29147-1-richard.weiyang@gmail.com>
X-Stat-Signature: tk7mjspq4jaiqxg81brhm51ut6np4dmu
X-Rspam-User: 
X-Rspamd-Queue-Id: E616120002
X-Rspamd-Server: rspam05
X-HE-Tag: 1755401231-351933
X-HE-Meta: U2FsdGVkX1+UonwTLGR213FJdWBqxA1AT0WqwRs+AEAr6q+HAIuEtQsnyNtpA0R6jpQISYS0ZBmZ+BWloqa6iCWwbrvjzRcNBTgXrunoqFkeee/NmeQBAWjYBZYuG/F0tdHtWqveBQaUgkyQblD8qk9nAqPDV6fgCfxDY7qihK7QUgeLexvRXI6oThx73/nmCRGTtjsn/5BCWOG/yHDBshDfpiUG+ju6EwdQG5oEFAYocFZB8BNvJnbBP/jKtxWAgAluNiY5dBTwLDwhEJKVyHwU55aczdgfq1nue6tIdq+3K7cUccYxhANhyqLmiwFIDfby5uVoj2g3+PNt3CmMBHGxrlPDXeQVt4X2sHNZOOQhP/M9cwToAkXPZ+gxCe7OxvqY8GEj1CDDJKm/Luz086NdwFZIBlUjygS3CvaMKsPfx4mTlTZF6ydWi9J6sAOcQ7KLN6Teg/lfPQI8xPabnDvJWdQPA3OQpgACUyT8X5Hc6MGyhvIiMhgcqa+O/BtoVKTcaRvGAGEZhkhBiuKfI+ygkIamTYZf7GmBssIO9rpQz4hZ8svCw7UBD7QJ5E1cSPj6YHUt0VQr7qgwfXrBcgAGP5ymFsQTyjxmZSirBht4McAweQS9sKR5HXyr82yDNxsRVOcdD02vPf+AwJAF056uaN1fXMU9Yu7CwJmTh5q9BX1nTS8Fjr8n1D657gn8IUQMMg1A5z4Xylq2cJ/WR/A2J0/LZewSHI6itC8hvZl49ckZ+YLT8ClcxhZS1f66owg67mOhk6/4Kj8mGgP8+GhpyFHHn13V83WjONqp4yiP1hUWbyBtV1vasKGEzqpikT9F1faeYZ0b56iOGXYAvWLUJY9hT2vC4s1fqJ5h7RSkUey9iLTB2Q2EtQszr6+Dhj/3xbAYYER8jASTGWPU3ygMqvSZfAdOypB+wG7B+LB0X1zwl8NHCWDt1ch9leEVB6+A+4R88Z2vIeIPDdT
 7yZO9V2R
 2D0e9GeVqDHcS3/ss/nntKEZtazBo/tYB5Kuvx8y/aLO8dOZbgVLXKeH89WCSyzNOgSPIoDgXHvVnOMr+1iW1sQFq+kezEM95fGzYlApb8NN1fd8oqECd3+mEEoPrcXnq9DiL5v6IxMO/IB8SD40a1yqLyJbMcTNcF7H7+BHzNBhLiNBheq9nad9hTFlCQNs413BZ9tUS/YUxnMgyGxWPqd6F1+0ojW6VX7HEodNle0GBB4D232DjiG3slnkQMqriynZDO2tqrrFH37QwKi+BEz6eZ23LjrD6Xc9WiZex+iERQl1BAA83rib+tb382sxhD01RIxMLO6PWJGszS/WpZ7+Z3JN1O8ZeNOffjGnZJUHaWA0tunG31gnSE5sPzIouctE6O/9jvAX64p1YHFdykosS/EuYYTGwPJufdNYrBFwXMAJ1kbWyQiIY7gqO6cfs1bomVGOniPsNw1j2DcCqHs+IHc3rvVY0v4khR1+YMv/KKHp7y4vSHnjxxjzTbgiqF+se0fgRSQRkw6qPZ5oroYK4+dnlDT/6DMqpHjfw21ZdCYNf5EwhEH+6bePv71H33Gar4RZufdeAiMJF0xnusZBRuAp70A82s87PGrxxMBT1yARfL8wgdCEZcSeXv07Hbg0F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At this point, we are in an if branch conditional on
(nr < ENTIRELY_MAPPED), and FOLIO_PAGES_MAPPED is equal to
(ENTIRELY_MAPPED - 1). This means the upper bits are already cleared.

Not necessary to mask off it.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>

---
v2:
  * adjust the changelog based on Lorenzo's comment
---
 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1c5988dbd1e7..a927437a56c2 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1749,7 +1749,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 				nr_pages = folio_large_nr_pages(folio);
 				if (level == PGTABLE_LEVEL_PMD)
 					nr_pmdmapped = nr_pages;
-				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
+				nr = nr_pages - nr;
 				/* Raced ahead of another remove and an add? */
 				if (unlikely(nr < 0))
 					nr = 0;
-- 
2.34.1


