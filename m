Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58550CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1A88E0125; Tue, 14 Oct 2025 09:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 261D98E0123; Tue, 14 Oct 2025 09:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 103EC8E0125; Tue, 14 Oct 2025 09:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D83F68E0123
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:49:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A46511A08E0
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:49:29 +0000 (UTC)
X-FDA: 83996852058.04.58BBC09
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id D496640002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:49:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a9NnSEMo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760449767; a=rsa-sha256;
	cv=none;
	b=8F4OcnSmnlLzM6T5hiT4sfe0DRHTgGBmQmLpTZCaxl4UFOIwACibYX+fwdbSOKFq57qkLS
	fOqH/LRjy4pVHlcQ6Dbh75jPS25oGIgF7f5uuGPpBtUDZIxCB8rUbrUrJNB278QIp74prq
	V7Akzj2X5htxkJo3wKKXEdliTQXpZLc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a9NnSEMo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760449767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=88cTXVtZOipEtcz5oNh9glrygqD36jj0Liob+IRUZWQ=;
	b=wdiEn23jCGEKC2Mh5DJpS8YzU7uuL/iCqPQgEtQBna9T+t75aCHdi6SDGHw1QXBNxt50VV
	CcU3OtVGXC6oYRNZGdBq5bo0RIm8nHVQogVfwrsUnCs3WBzPuhPV7YmJrxWYDPDNQO7NF0
	lgfnFUR2LVyR8vczaaSckfEGpeWWFRc=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e52279279so38442955e9.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760449766; x=1761054566; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=88cTXVtZOipEtcz5oNh9glrygqD36jj0Liob+IRUZWQ=;
        b=a9NnSEMoQCDJiJPpxoyR/4Uq76nBe4mTvknk/XPGbstgJzjME53kqQXprjFRqbI1Ax
         6vlXi4Vn7pK3REKrWP1AH9lWr2XRGHhyioY4HoBB1xwowAHCDuaiLQpCYZcz40lpp16g
         MYQchwNPqBCRPaPXeULIuvMD2AqvODq6eyWDams2k2iqbQNq348TKUZSRlIShLq4Sy8b
         JYzzzZTtjSKeyAPRxta+94oX0VbGxezIQxramdtJ44ryw9PMd3/H61wPDUh8T+bKnP0z
         qn0VnHvF8AlEHVA6vsfTJrBmSIP4Stw5f58y85bXpg9qFfmCy9caK9AL32CQ6z1CeJFR
         f/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760449766; x=1761054566;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=88cTXVtZOipEtcz5oNh9glrygqD36jj0Liob+IRUZWQ=;
        b=ZyjN6UriMxgD0Hnpnc0eSaILjH/8c2cHyMJGbpSk6Q1g2G05aFX7d5Wgc9BErJyob9
         CBQgLevBrd/lBG5zvaHjube6tPCqX7HJOGFhzj+bgfOigj46LYuxZ/t9+mfTiKmPQ/WP
         t9I4PRoLco9Rsi2ZiMjrtwLGcDTKqfybmJ0y8EXhafVpe0eQ7z+AqEAb/oP+ZnNZ2oxn
         i0OKZHB5uBUyvHX3Ww0hTwRHJcCdyhwnTlqfsDHPEZZho18E/hiAQdDI0URRHjEsRsRb
         4mGeEXbdKUxerrSD2VzWFLfqadJDvONuR5VEu8+Tc8LnZiIwx191nbwfQAjpsSXgUoGl
         H40w==
X-Gm-Message-State: AOJu0YzM+vkaVputUueECAatm9am68N/L0H6UkDGnLrKoJpwOc6e/zPm
	y85A09cScCjampikjHO2pkwxdzQ5hvyz1u+uSjcVzebXJpOWza7p6Ms2
X-Gm-Gg: ASbGncvDkpVQx1LzNI4lNSMcHDswZaEJqGuceVaVocugIEyQjskC2tyWxlfL+JqYX9K
	UVY6XNHczLSTiQwRsj/I0ucAIHlP7ePWE5S7Ug7AdBj7G4HDd663b95J3KMZhbv/hRj4L/xr3kU
	BLU2RJm6DhR741QzBqoVVYYEApXDIp0iduq5Lq+X1aEI5aJGi9Fv4qaTyfqSUH9N9eHOB5SpE3K
	JzLtWiSsocZWcSjP3DLpSIsV35Gr31cksLQH4B7UIvL51V5rmvEkNgGKxOzdpF5Vwy9mszgR13G
	VkBZ0EODfev/tF+VlgOBlUUk7b62Ex0IZ/qpy+YWF6pPbYMUE9ngitX0/dUOtwT9iAwI67edGwD
	CBUOgVKAXJNl4ojdFu0Eog05bX4lHgwIKPkVrQhNkno51bBFYFmI=
X-Google-Smtp-Source: AGHT+IE+DIXrfdA7ivZALIGUWqsnZGyWMTnXFgCMhvbVU6LxfffKOaGKx2noLGlgbiENEAEz+gvSdA==
X-Received: by 2002:a05:600c:1d12:b0:468:7f92:5a80 with SMTP id 5b1f17b1804b1-46fa9b076cdmr160842895e9.27.1760449766173;
        Tue, 14 Oct 2025 06:49:26 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3d2c1asm153861375e9.1.2025.10.14.06.49.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Oct 2025 06:49:25 -0700 (PDT)
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
Subject: [PATCH 4/5] mm/huge_memory: Optimize old_order derivation during folio splitting
Date: Tue, 14 Oct 2025 13:46:05 +0000
Message-Id: <20251014134606.22543-5-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251014134606.22543-1-richard.weiyang@gmail.com>
References: <20251014134606.22543-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D496640002
X-Stat-Signature: 8u3pio7kwuqi98zfut54tsyzndpnqtmd
X-HE-Tag: 1760449767-996605
X-HE-Meta: U2FsdGVkX1+748CpD+6D9OUQ6Mh9YW29vTpCEpJtn4CXVrRAWMCB2vRGGDdkf6N8MjgMLfroVsL7bDtO5eskdirwMX/4Knl4zA2K3mg7rne4OM4piKWIyEJEMoDop6pTx9DlaR5sUFHeeL2VdbagPI/LdStfGGRFWMb+KWraYV1FyXbLM0LHJpf5/uFv1w5ODWflEXOFFvswAy3YOIlmm3DrehNDEZvXiRTAOH8bCRXOB9qfoPNkGIkpP7fjCUoDDw35h9LCnthT51T0Djzovxo4UhO7VFp1pWCU+YwoqXUEKTXZB7e9+Ajj2EkE5PqWswwOUi2LudYR6Q/9ycK8nC7m0otYE9Vgc9PbPEVMZnNKBGGsLbKwoXvsmUZC9s322zEMD3xUFBqZcGlUwdvdZ4D6YZcm2ZMkX3J217KX9m7SM0UW7Snrf+oZqjUsIbNyBCnc0567MIpxM98qt39FlJiCgESZ8qOZkGI3jpRqpN+PdLeW9foibtrqPJ+ZLEgIxDMOd2SF7hHxrQSNPz9UMKPPM6JT0/KrFTADSP5obGNU3XmbR6U0LgyAK7Q2Nx3lwL6KdHis9Wm5pr2/D09hoLCX6dUcQNIMtFPqlE3PkeJy5WnDBgdWxtrCxR7x21AFfPoqrCuhCB8YS9pYvWVH53+B5UcSU915desTC52M2jyESfedI9AUJU0I0LlqSUpIdX+L0Ku+SDvdZ3HGXwJrPtc+O7fyr66i6SjGj+/NViK/EmtfQSzRvkGoi6qmkjDxSHqQNqkJn3UlLwBUS4dvGesL8I5InhhPypjWKMUXTzRm57fsbWx7AQeP44UkJMjLG5kYb3TtlY+rTWGQR1mQRLy4W8lkyUHwePdStrqjbCl42hqfqbk8eAhL1lnfw5SR6LX7DdkJNOlUfuL13Wq7pQdyvmxqwU/UqUPQY3BpJJpY4cdO4alGS/jMcXHaE0xKFAUdKnh3JmFELtABD2o
 /4thEI47
 /SI0RlRlvlVu8busGPaatmltc0jv06QG++Gt0IvSM6Ae5M7EuJFxuTNYMGEhMmF4/mw7Dw8pbvCE6VEDoDdVnwp/1WEGgauOKkMd9Pxk5GOu+4exntC13cpzPGYvKBK6jSfoQhvg6AjGTc585xBRmMVQtOsEA6USKiodGVhK1AVeQZ/X8Uae1jxO55HdP5jMFe6tRD1YRGcrtg4/XQ25cW0S/RD+5Py/C9N4Cvr5LPJt8oh0e6KP3mVM2QTnAxZxOl9e4NnNI10+cnvN02T0tz6/U8rE/4p4mkYukLBXccV3HJdkB9APfp47EgT7PhVDom/5XdhZRyx9wvhGkcvMyV0h4e0snYcb/P5PD2wCP9iR/K8EGEX52WPe9cGVR31jWQNVnwoleancI1gqVDW1yic+15FpwkfIEaEJxWo46V0RXrQ7LtYY93cS2ZII4illeSE5VXZtIrbAwd0BTSAQfSsBo6QxjHX2wQMGN/HzezBNgPZ4RhX4DdEZud7JFlkApjozb1yzhQ6I+Q6KHMzRLi525/4uwmo9YU5yWvuVJztI5oPYpkwcjHiEDhCnQFBmld2nqTpb9NQ0ItJBUSs7fchrmgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Folio splitting requires both the folio's original order (@old_order)
and the new target order (@split_order).

In the current implementation, @old_order is repeatedly retrieved using
folio_order().

However, for every iteration after the first, the folio being split is
the result of the previous split, meaning its order is already known to
be equal to the previous iteration's @split_order.

This commit optimizes the logic:

  * Instead of calling folio_order(), we now set @old_order directly to
    the value of @split_order from the previous iteration.

  * The initial @split_order (which was previously handled by a separate
    @start_order variable) is now directly used, and the redundant
    @start_order variable is removed.

This change avoids unnecessary function calls and simplifies the loop
setup.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 482a734b61ac..63380b185df1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3528,8 +3528,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct address_space *mapping, bool uniform_split)
 {
 	bool is_anon = folio_test_anon(folio);
-	int order = folio_order(folio);
-	int start_order = uniform_split ? new_order : order - 1;
+	int old_order = folio_order(folio);
 	int split_order;
 
 	folio_clear_has_hwpoisoned(folio);
@@ -3538,10 +3537,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	 * split to new_order one order at a time. For uniform split,
 	 * folio is split to new_order directly.
 	 */
-	for (split_order = start_order;
+	for (split_order = uniform_split ? new_order : old_order - 1;
 	     split_order >= new_order;
 	     split_order--) {
-		int old_order = folio_order(folio);
 		int new_folios = 1UL << (old_order - split_order);
 
 		/* order-1 anonymous folio is not supported */
@@ -3576,6 +3574,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, new_folios);
 		}
 		folio = page_folio(split_at);
+		old_order = split_order;
 	}
 
 	return 0;
-- 
2.34.1


