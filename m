Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA59CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 21:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9768E0053; Wed,  8 Oct 2025 17:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A428E0002; Wed,  8 Oct 2025 17:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A198E0053; Wed,  8 Oct 2025 17:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0DA08E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 17:26:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 354211607C3
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:26:28 +0000 (UTC)
X-FDA: 83976230856.23.5767CC2
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7689F180006
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:26:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DOStb1UM;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759958786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=02WGp1DxFUiByHpXLeMo76f1SdNmrFn5JyqrYXqca1I=;
	b=icfVUcFDj/2oPwE7LaNKHabklo9GJG9BSNiUg3SKpdRll/MI2yla8Movk2gWiHRrSQbWN+
	2EjgPpL4QanymZOkTsDynFNL6Wm+GMs0J01hif46ZFQGKzKDT7c12yjn4vqUzaIs8UXVl4
	LfmMA/pYGyYSLuU5owb6tgyZTWBcRAg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DOStb1UM;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759958786; a=rsa-sha256;
	cv=none;
	b=f7HwiP+kHgMZjVobBW0jIIYNxYRvdrkvG7k3KbvcxjcKNvJy0emmO05wDSVnY80LzjRffB
	ZN26i69kJ1io0TRaTMKQ9e1q2KW/HhKHYZfWYGw+67M9lVNFnWQbTaJOgSl5PTE00+InHj
	pP6r2Ajj/eZ42+h3TvRfgqBifk+w5RE=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-791fd6bffbaso4317446d6.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 14:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759958785; x=1760563585; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=02WGp1DxFUiByHpXLeMo76f1SdNmrFn5JyqrYXqca1I=;
        b=DOStb1UMP6HO7gTMvQRXXj04YVjW96m0eEWDOQXg/DVJGTj6blO6kbFFWtf6vS/kh4
         X67kqdBjHbkuOzT5MSY4SKK/vr6Rab72a+GNAJFN0qDaNv/yZwQfxw+V7RhAmN1C0oFp
         WEiaWr7d5FLz+3j0ADiJxRmqsThIieP/0vjJFtta3NfSSh2QCBXoqssmUUxIiUBOCPJu
         xnpsF8MRSf4d7mdAdYUxmo9hy75/YcvQpM/6/v0k5//4iyJymzefjFFd/QzG0q2RVkzz
         DSc3ryUjmPw7k1iF6Ri+EJnzWkUr9NRAD53SHT0xjP203Mz1cThtH2WzT8IpMcLHIr0N
         ykYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759958785; x=1760563585;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=02WGp1DxFUiByHpXLeMo76f1SdNmrFn5JyqrYXqca1I=;
        b=WnVHoODqiMrN5VFnLFc/AFxSD65BgFuIYEfB4eb3Z8zZeEvKn4UWY+xL91dfjO3Jkr
         G5cgx/WR2XlpJ+wdr5+ltrXtSIlld6X66jsDpWjSjbkOGyNfLeBDg3GfEPuQ6rrWvhFd
         xoxMuOAGY9TFRIwsMnxvGw7cT0IpBvcTSOhvPZotn6THTgHMVkLmTAF9LZW+cn+etSzb
         cYEQFtTK8Aj8Ep9QLVRRShcXgZ+MMFYnW5DLEvBepudz1FkgaxqsY8De+0axocy9jjat
         85oRvlv57ujy+jQKzvVa7Q4POoDAsCREbYAUIolJuza1lZK1X63d7QHUOvjmI/uJv3S7
         YpaA==
X-Gm-Message-State: AOJu0Yzh8Wx5CoRHHaf4Al4MRkSsxVpXTVTGbbrWf/XAucq4A/fXbubC
	yXdMET4T4/8UNvo5PTpEpw/5rej+AJSFFHhiY67xRspyTh5UBVs2Ng6vXFIuNUPVliujGABxrrf
	1e3+K
X-Gm-Gg: ASbGncsZRjFT9xo/mIlWCuQ3pqaH9RPPUcQhAkcV84G2AbSZ837ZZwJwj8QsKXB7jAX
	cqOz3PlRd2tHsWmhHNbyvtt8b3SZGCSW0sb6y2/5Vq3/uVAcDyh104u34HZoEj7ZK+veSw+HTiC
	/eN1JS/1sYTXQoepVI+2ajG/Eq6kif65qvIJfgnV6LLR52/FSiisjZ5/KnVB4iVS3vNZS4c89Ld
	KJFehYk+kRjNsQ5KcBGy5s9WCJtcKi5aRK4P1PyN6vcKQlD30hIuYGnn916mKbmwoPrBN9Ury2j
	hAzGTsSB8u7W7Ya79xU7BMN2w3UFZqmgHIQ+ad6MnIshqogP4oOzZXW7Wpj/XXdIo/WOv1ynvu9
	Do1WDjVSie5x75AdHIhRAPIm81/7zduXgC0x21XbxoyUDSR3KPzVjPvApGM2bvqNbqYFvJmXUxf
	TW8NMtzDyL6Ee66PQY7Cnue/gEPye3i3R+nqzuTn1CCYqDt9t+S7by8+yR
X-Google-Smtp-Source: AGHT+IHhEwy/BGJsgagFs+NryYihU/HyuisdDCE+tDOMPz9gSDnX04RD+Z/cfYEUKcFC/FsUVDNIjQ==
X-Received: by 2002:a05:6214:528f:b0:877:81d2:4c27 with SMTP id 6a1803df08f44-87b2ef38450mr71340646d6.57.1759958785149;
        Wed, 08 Oct 2025 14:26:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878b5dcaef2sm174415006d6.0.2025.10.08.14.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 14:26:24 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] hugetlb.h: flatten logic in arch_hugetlb_migration_supported
Date: Wed,  8 Oct 2025 17:26:13 -0400
Message-ID: <20251008212614.86495-1-gourry@gourry.net>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7689F180006
X-Rspamd-Server: rspam03
X-Stat-Signature: rqrsqa3cuopnnxmmdhgroe6ssfkaezbz
X-HE-Tag: 1759958786-459524
X-HE-Meta: U2FsdGVkX1+T7FJSI0UNo33sUIIoB+M7y0xECxiEQohFtjo9hPpboUkBdLP7qlwbKyX+WH2rtXTNw6NUrK6/9qzhdkZqToKkMURlCNOfJbenLhcBRNqG8MBxMGMoACknFmSRkFH2qtGqwzKdlnPt+lPkZgOg6fGJzfAw8MTCS4yPVjbeJg6TxG2rj0tOkir6hUiVQpRKayFEix05ELAXNF26no+DzSG9SCr+0mO1an+vFevzEEIsGfhBJmU+3aW1mfok7Q5gdpfPZYkxghMa48rWHCWeznYGGaFFzdPftB86G3wNiE8FkbHpJJNXOOlur+vgsTgZcVhVjhBFmuS6k0Au8eOX2ZoS0fA94ZaoXgeGHhfVleOHeB8zMLewzqBnsWYTXbjcvrE1gLDYWIyWnymOPshDV2q266YSd7EITFcS0uWztMEbeZxIg6IRS2SW7SMXRRboridwn7slaRG3Mca/GkND+lkHAB3UP+UVLfRPNhCN3qFiIBk0mKtkuMAHyXVuXxGGIgsQX8kKIYnGn3IAVaGRv39/f69wmRzAk+l0b6mxdUlR4UL8cmH4eoWPHwf8vGD1O7qLLDu/A/ZUOsG/ZLVSnSAQFEVKvPfWeQYGyFw4XkovS1wjS0+K9uF/5avD90wjGKhYi6G40V6EHK7h46//Z+h7C3zlYl+qJNUXYguTcfKRTbqOeC+vpb/2AG/uMauQLOf58XIcsQRIImGQdy1CAxy6UT6sOYh/yGJCQFLE4ls44l2i0kVjdsxQo/gPKFpPKH+bK5oD1Xyz4S6Pzp7SfbQ9Fw7z1BVGP4AVsJdn7tOdvSBpjM3OPciMWKsLP/cRKrl0zCrt5faCVdzdneb3MgKFrq06ZaAnLCdeuWioh4XTe5x9xl2WJ4ENIIEa89Jj/qIJFjp5ZMQzPuy3OghNRqIqUdaNTRH2BFyn0T7FiPW/BaDBdeR200bWPFLxbIEAlXO9F73IeYd
 XO8bTyHV
 pPtEHMXlLYYWSpJxErFt8NGcPuf0/tr6493aPZu9vcHzp49XPp87SkdZye6Ok8slgC7A/5tsKh/Wz6XyD2hN0mKWNzV0+EWvJCkbx1wiym1rSKylJWlaAv8lsQux07+U6wu4QgkJdJ8fMyVb3zBaNuEo2B5Vr3ZdlzS07sfKmo1yP6OSeMMNR4Qbj6ebNaKzaq9Yuxhc1hiM1Hl4J84mDG/++LSy7UNVKQihapoeKRpYy41HF83nGC0qQw47nlJujEOFAmjnQeA0jeJSOwch35hORZOvNnlFdHzow1yKubDnX3+f7/VxJfFnpIDW7zIpb8HzG4y7YkRCTNlBSRGuNMyHWWQ/oW2WmoTsKLl+dv5YDJ0jzs2FDzSDf+cmllEkHeSG8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify if-true-return-true-else-false logic.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/hugetlb.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 526d27e88b3b..b030850975ef 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -876,12 +876,9 @@ static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
 #ifndef arch_hugetlb_migration_supported
 static inline bool arch_hugetlb_migration_supported(struct hstate *h)
 {
-	if ((huge_page_shift(h) == PMD_SHIFT) ||
+	return ((huge_page_shift(h) == PMD_SHIFT) ||
 		(huge_page_shift(h) == PUD_SHIFT) ||
-			(huge_page_shift(h) == PGDIR_SHIFT))
-		return true;
-	else
-		return false;
+		(huge_page_shift(h) == PGDIR_SHIFT));
 }
 #endif
 #else
-- 
2.51.0


