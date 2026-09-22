Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3FE3C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 23:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706F76B0095; Tue, 22 Sep 2026 19:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E346B0096; Tue, 22 Sep 2026 19:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5335D6B0098; Tue, 22 Sep 2026 19:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5E66B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:58:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75074A05F3
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:43 +0000 (UTC)
X-FDA: 85243065726.06.5F97C0C
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf29.hostedemail.com (Postfix) with ESMTP id B0DE5120002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ax1PIVan;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790121521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hLggoqTstCCp/LK3cQnyxDjfuxVFKuLURbcW1u38EU=;
	b=WKGvh2OH9vKvQojABX12mvYcKpEouVaTybVXGWIrDF75DQ8ZbpyLAm1vjtzsUT2DFcw9At
	t+mZNOxHuhNvR5TVuiJ8onO3ATJYhdYZ7b0G62sP8TyNU6EhjvU0+thYsFIGqZFX3HRuKT
	j16T45MlkLtU28ZRwzkxJfZqUI2b/q8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ax1PIVan;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790121521;
	b=1RC5IA+xEGrp5vnkPVMAqeUeQ+Vfr2n5xvVBFksUw7v/tzQw9a3l+sLTe7GOf+NwnqSr0n
	UUayoL3Z9nrWwLNApUGkOG9NsbwKZhs78jQZF6LMLB6HwXqmib+4A1lnXR7Y9L+Fno8HFX
	RSNBuN1Lp1LSlTDZmGVWJz/nh6jMT7k=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52fb76c9df1so4216541cf.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790121521; x=1790726321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+hLggoqTstCCp/LK3cQnyxDjfuxVFKuLURbcW1u38EU=;
        b=Ax1PIVanLR4G/YTcBaYQb3RzfZ9amUqNbCMqJ/hOGZI9T4pPlur7QEBronIJW4BHKJ
         ngr4NQUrLqBgWhxQRE/zsnbXoOGsGW4U0WKMlmplzm88Y+o6lDjLk3P1+4Ad31Kaiw/Y
         OW+jL5AERzGU7u4ij/gi7g8Oy7oeYAgFgNtjZGhVpOFoF8fGGiL9Edrkl5ftnEz050VH
         vpx/W5XiXVXy34mHvfvOnjL0XICGe+JJMRX+WaswnsmqM8OwwekFNz+fJKz1CjEsLiCM
         mSva7jGkbsQnLD91mgJ4euSQ1drPe+YfdbpnruOHFHa2JUwnVZNe3JwGVt2FF7NG8WAl
         vvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790121521; x=1790726321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+hLggoqTstCCp/LK3cQnyxDjfuxVFKuLURbcW1u38EU=;
        b=w94QalhCqKgLhuXirepDhArUNfd3qbYcH5DWPYbrqzqiV7wrU3C38lWgnI9aFzsZKf
         QaVkJk4YKVoz35WYuRphVg/TEhLJOS+YKkD09LIdVJmm8W6r3iqT5IjHhamDWKxNRetP
         PGdTAFdWpfcTXbcGxVZuqg4vco3TIdkvouno3+6fXzK4MfO+QiIa6c23jEZGOYOx9FOH
         JHQ9NmvVXpg4h/PqmRa0M52v+mNc96qLufrJx+g4BWuqQ1zaMym/5ab1Rkb3xHluagzB
         FvLCztR2srQ95NEwuzcR9cl/oHe5Akk+qT+JTT4JOKV48bE1vJhnMNRsYQtbREyIQP3/
         yfPw==
X-Gm-Message-State: AFuF++lDLXJwSoMj/4vubKVUprJaNie99fm0VbxICWp1C5dn92Xl1Wii
	ScFK6HLK01PsWept4ORpOF7CbG7TH9MCro6DOjQ0OpUppfoR0CY2cN38BLCgMKk3eFqmaVPZqK0
	Hx/jMjcc=
X-Gm-Gg: AYBFou29ed0rDcBIjoPZnLUXIPNrQ5aId/pXOq8ZR111KH4Lj1U/JCP0HK0mcmC2vGf
	qHcA00+V5ilVqQIipkXw3pxKgZOeS8q/a5z1wowgA25Fcua0YoQ6Ja2IgtQR5RdeVREwO8bZZYP
	pXQQFM+LEeKSzs/Hcb4Okv/xBOUUAPLUXBCKCw5b4kBEqCIfny28OeZOIWpgCCaX/5HIkDcmiWn
	4rNK3X1GuDpqEtNacA7/vMHFr7VCgDemp59T6NLCpCu98ZPr1KSGm4Rw/y0QEak926QeDdhB7/h
	cWTIse94GNJvFzrs3ty5LSlSir+ap50n7GyUXDqAsLb7bfmdgaI+OM/usfqVLyAa8heUNML5Hx2
	ypYwHnrcGDI1Bfr52PPIMUdj4CzH2XRxKMl5MZ2GorVzvnP/Bb1gG+GNeKdhjo8VeLvmXRoiDUz
	djbqAJTyXjxtUC7j9A0dCzBw5N1B8+qahwcfUm9t6Mu7qfKIINfQdIVMX1Y2+eOZrz7BNRUd/3D
	Ycv/9yR+tFIuixZBoUJi7GODqf6Gc7REPu0vwXuZy4wTn9jqaMQT6LmKE92
X-Received: by 2002:ac8:6f1a:0:b0:532:c161:b968 with SMTP id d75a77b69052e-532eac32322mr21316581cf.1.1790121520905;
        Tue, 22 Sep 2026 16:58:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb3c6715sm8323261cf.30.2026.09.22.16.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:58:40 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH 04/10] mm/madvise: use the PMD softleaf validity helper
Date: Tue, 22 Sep 2026 19:58:24 -0400
Message-ID: <20260922235830.2350770-5-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922235830.2350770-1-gourry@gourry.net>
References: <20260922235830.2350770-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pfmygiix3x8m44jr6hmjypohz5irne73
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B0DE5120002
X-HE-Tag: 1790121521-103584
X-HE-Meta: U2FsdGVkX1/ySU5+NduVNd3zONsGFMEB5pqmf2buB2lATA2dA0tCrz00xbwPsmh1Pl9q73CNdD0V/RThUyTEixhPJiKcZJUNMy9GgkyeIMyOQr5opAw3HiKy+we7lFa2SIwcf0NAmh2HMXwl26tEZaC4aXEqbjZZWTvRcfCSsMetx9fuYqiXZz46DmJfo4S1MQe+M4A1e9Ef8KNRPQl5c6ClFwdLMKYI6Q5EFf1RxWxHRXqsRW+9bHYfFgudBiCxerLeVIbuSaUGVbk+uKmGN5y7fBJ263nfiu2nltl2xeq8YjStJL0QWGDjheRcruDRKvM4iiNYVkXawUT43r8svqo0ylM63oGDNalhmn40pLd9mo6YKQdRqCh3xzdrJo5e+C/JM++tdncuhkdy3CtwBdH4XzG98OPAoBFyJF4VXa23+OlMNFfIjS5obUApPCDfs42Jp0FbOYc4xOtVyZuzGLgA/mFK27O+uGQtKr2nHN4PmpbkEYW6lzs7jhLMz0vZbF6+HWyEgLzySurdU/M5ossz8BXNSANbqfNjIfdNfxyT5xXwqscl2TY6i/18z/DYFJz8EGXZ4Nof1FvqdUSwslr9kxmE9Uhpd0/XepqwxiNOjFFARawT9edCp7xW2Xwb61GpfSY3ze/3SojkvZHTag1PReLJcROFaAb6piwQCThfxJUXI4g+QEOy/4IeleRNXeFu35AANdvVKKVnIIfdWeohtrDV1E+61mfStJYx8fANBcGJ7MRSdvJjFWoXZO9oEA3M7x+JjGaaU3rHeGBTYj3JyuqXbn6yyZquQNzprl3K/1VHzxqggYBTjgipnyMEe8HMy6yoib5FtvK2dLs+/ffdA8kXYqHgu8nKJgC9+4ksx1h5jC2bxHsJvsKaoBEzsbTydIYUGM794579sWN312PAryA9KLmMoDbry+CgtbKsLUOSjkGFHOsIX+LN58t6s1iyLsB46dU4gWPCkeJ
 u17LlcEp
 Rr40FwXVyAa13Pm/jYd+o5CPl0qhuXsBDlEjbmweSNh5yBJY/PuKGdJ+jrVO7eOP45ZNa1SmZuU8FJZk4tM412zVZbUmEFmsC39giD/FvixoUy57d2FtvLXw9XeRnX5/nyIVc3R68w+bKwOknO00i9VuH0jqfhl2ws2poOqTj+v7k9cmfJbATYt79iPa3F72X92MGV3apF2oRdFMxvxDZa+nkFHYW94xwD23fx+UBTVa3YBToySDQ/SG5lRyxQnVO9XfjHiPTdY7ltEjgxfc0DGrhP/tB4ETc61F42hXzfV6TAxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A non-present huge PMD must contain a software leaf type supported at
PMD level. The open-coded check names the currently supported migration
and device-private entries instead of expressing that invariant.

Use pmd_is_valid_softleaf() so the validation follows the central
definition of valid PMD softleaf entries.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index c345fef23f15d..b31b877c2c130 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -427,8 +427,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 
 		orig_pmd = *pmd;
 		if (unlikely(!pmd_present(orig_pmd))) {
-			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
-					!pmd_is_device_private_entry(orig_pmd));
+			VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(orig_pmd));
 			goto huge_unlock;
 		}
 
-- 
2.53.0-Meta


