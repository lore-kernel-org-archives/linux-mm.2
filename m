Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 630CBC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F0D6B00A7; Tue,  7 Jul 2026 16:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4771E6B00AB; Tue,  7 Jul 2026 16:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3BD6B00AC; Tue,  7 Jul 2026 16:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0AA6B00A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:18:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62748168BFA
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:18:45 +0000 (UTC)
X-FDA: 84963093810.01.D5E2AF7
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 994F61C0004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:18:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aoIR3kDZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783455523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GEN3Awww7LkykBAC9Xz53YyXDjfYr2+gNOK+5mA+IGM=;
	b=XrBRvE+GbjwpzWGOhU/J5e0vzy6BE6bbyYdIrdHVWjBLqs5GZJwpUeUttxvhpmXI9+/wkn
	wAJ0RW6DAYBU96/3gHWH/SVETAd0FpaF9Nnfa3kxI+UYQ0PNUxf27Q9TzuW04FXzW6pltF
	s1tbm9wELSk6djd8sLPwSCqfU9W3llI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aoIR3kDZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783455523;
	b=p3mQyfh/veDaVQ+FHgAY3quElF0iLAHKPZmMV31l4/8vcv0/MeZtnyQkhyn+MNw5DhUa2c
	4XlW+klbAK45a+DvdUEZP+NPN5fku6Qs+mw13166xGtbLfJE1JD0P+4cDS4zqrj97v/ap+
	F1ev+44wovAdSoJ5hi4+RGtib8dImeo=
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-446f87b6de1so2071367fac.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 13:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783455522; x=1784060322; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEN3Awww7LkykBAC9Xz53YyXDjfYr2+gNOK+5mA+IGM=;
        b=aoIR3kDZRtEUBpwxy7Do2J8RSgbPssomSY3z8N3Xi+uCc5nyib0mvx3GIfxZW6qaB1
         7YLqF4SGiASOxWpv2oQk04iIxJDHPv1i6mZbATjviOiUTkaFCuBNLCBB+Tlar3Yau2AT
         AiBanN5Ggh3yFtmsMPI/P5G3MQgPKa2ut6CRilbjwsXOvfTkyYmxKAKz2usp0nLgs1Dk
         SQhFACp8KpThf4blWX9Q1/ca/5CSc8N7zzeZeE/gOqgUb3ThbGjB2ibg2qduyDM+dFtu
         IfEIeDcSNVPWRFDfrtQFMQyLbRGtqsi98AkKYSBI+0vmcf6MInnmEdVfiwHaDDNFS4fp
         IBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783455522; x=1784060322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GEN3Awww7LkykBAC9Xz53YyXDjfYr2+gNOK+5mA+IGM=;
        b=WNb20QmBSgrRJAO7qmUABMsnsu2vyOexHMPoPVCqlnxRJ+vDav1wZj9OW25DP76AUU
         8y3B9sr/l9LJUpz5Fd0Q9zq4PpayBindbEfZPSsBJEDhrBj1o47wsu3f+GYkH5Frh+4z
         k8eDmhXP+JNyP+xxwOy/k+pJzIJE5+041Mjf9S+4tsDKZZEjx0BvmG4Sts16FgjK+uXQ
         qZGqU7gNGGv31AU/oDhDLiQyqGipgK/pSjRdEkVpS8RfvlRk046W1grzmKhLIbiHIGJO
         ezjtPjmYtR18CtiLAh/c9a7XELY+WEsUvn+r4Jngkp785eAQY1BdZOGIsF0/FS3ZAyqY
         47Zg==
X-Forwarded-Encrypted: i=1; AHgh+RohRlnmOS3J3kxT2tryIs99kgwhwFWF+nGGstK0mfRadgSMNu16AlRt2lyWSM+scL5o05aVLcHgcw==@kvack.org
X-Gm-Message-State: AOJu0YyV4iW16pM+q9tBSlW3r2PSqS4pEHN2fmaMhoRzRDRybWyQTSsp
	O3i31+Cgb4ARvN8nrpDjF+ltguUWRJoDQu3qcXrr4zAupmkHppwleyRD
X-Gm-Gg: AfdE7clRYuD3dhUAsj8zC2CxywuQqJuXzbCf1T+joowU4egrcHGvtm5unmO1ap042ub
	iEbCpVz1XAB2pjmpVQMoCY9y6UXiDd6Or95UyAVqEhINEg20Xnb4tRdV7b5n3YvRuCRFXwVS/sk
	sVgQ/NdYfpEzjGeWkNxfptkLvGIvzQNyc7Qzw16ePPrsfihqJFWnI/3Io5BHZnLyzjKe2UjA341
	FPBFx90QYUQ4HdOHAR9xkujeGtqG4loS05xjjejjCBEWran5SlZPNAarcl/U0M49trs3nftPi2u
	J/As8g+Jpa07dJaxKNsZvsBjR0M0s/y9OMPeBAAsp6VRHhqolDH5fvaoujNBloQRiLQGeUHn1tO
	sjOTmsOIQuzQLKNE2c+Mp5ZcQ94o9Q69owps7hAlubOG6UolK9qtTpCPgMnU908og6K2JG1D9V2
	76MmHLE5WDIkdDbUQdzUudTgSgraVHRXgxoFXOyj7YJE4JdNeDUQY2nJO42BifBIrG
X-Received: by 2002:a05:6870:224c:b0:440:4df:c208 with SMTP id 586e51a60fabf-45105efbd4fmr3802997fac.33.1783455521667;
        Tue, 07 Jul 2026 13:18:41 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44cfb67156csm15130448fac.18.2026.07.07.13.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 13:18:41 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: usama.arif@linux.dev,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v1 1/2] mm/huge_memory: extend thp_underused() to mTHP folios
Date: Tue,  7 Jul 2026 13:17:34 -0700
Message-ID: <20260707201735.4113107-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260707201735.4113107-1-joannelkoong@gmail.com>
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 41cbsecz8umdftie53y83e6whp6xcs4t
X-Rspamd-Queue-Id: 994F61C0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783455523-98737
X-HE-Meta: U2FsdGVkX1/On3AYbh8Njf28Nn+Ezb1xqP73qR2avs+A18hnHlbhUklGzWIFimZgNJg2BijZvjwFadnYZSanqcsEGiqW7oGqkQev5MN/ZcNaq0rnSwwpkCaUMXcO6DvOsMGlNcP5ZSeqm4bfwsEGS6y5hD6zF8DE8KaO2QIfSolTl2oVJzRLBvlAjXJol+YJ2xlC1cCPRaV5iqIavP1MnIv7XLt39hKLJHHXhp6JqWGMxFSzxmStVr+LQAdn2DqtdjegXN+w9SoNLDasOutVcFYvetRiiDFiTjj0laxr6p5WyGyOhwaCrj+vpIOmlCQmPQ4Jm7RJFWBVpzTWg25MrR9/p9J9Wfkh5EkJxfNzErfZysoPZlZ54OEmqRNkiSK2khYjl0hVlWHobg+V7MkG7uoGJi3hfowhnWZ6KattaY+8jEwr3vwYlsNs2GjWv9tDKfKtggtYyNWoZ3f6xAcw6WWvSgDUiJU3fjE3pFxjAeORfXWOu+yJyqksbXwX4v7YAdDxa0ostv07btjaSvvwfiyCx2YDjxILlryfovOUuqIRn8zldmm1fgWUiYa//T6cfkafbQcl9Ht4kelQki3CdltBJqhnvXC5gSgDyu8ts7sYo1rGkqdcTpjf7m22PvnQIeuvnO+AOiEPpX0eCDbSssghM05snDFtJjNjspNZKUeW1zVVmjhXiioDecQrK/BM8nrc1ppVbYl7+wBCEq+VE4T/uurzYsd/EO2pA8T8oBNBJIhbLj1SN1LtosDKFWV76x45e5jUd4ZIkq008Np+2wfH6nExVe8zmzHALzYgBq4xAdVkCrMsDu2jpsMMwAtXvqRZFXm9xp+6H1AuMLgL+yJcChbdB6UiYM5prkn8fhPExmGqqVhWG2bMsN9FvO8oToz07mFpjaiMoRPxfdG+fkymEfdpEPTZMVyk038zJh+uWsqM2epbBtDAQIzBBwShYfBFbw5Gvjcj6030/61
 dOjv8Ec3
 +8ENJbZAlojJHP1BHPwmf4fOpfwfwhq1KOzq2ymIvOSwZPstVoYNPM6QXe4RBUrZJk3mCXUhPTDmzt4CoIBZQtTzgRYIMPCAqGwMrbfLwSFxEw3YfW9vjNpXDAvrvfObNoOD2WC0gu8YzmyPBOmZYNhFXtFnw80ReY8OQ1BG38hXInTFlwaS5/x9xlLudexh210uQNTd/d9TnPL9EpPZ1mb30+40mysVLDjaesIxdwZbn+a9g3VNTJD9H/PO2D8V8aNk02gRzS/ycxHrFRzvbynI2TJkJiNHIYKtY3Hikuqhr+yNxtIuBQR6UVVVug7IXvpWLTHBAaOHGQroFWq4/bHNhCFCH07UD5sxOW/HaeEmhFtIaWt/DGODcgeDriiMUjpmBXbykO7hgZXwHFXKgY4nW8EPrr9tQd1pkuUpivHl1ejA41DIQOAD2ARVhAYY1fJWjjy6LAHAKTrtFQkwi0D+ygBjRq22W+88DCUZz6Cai39ALVpMgSkbXHXYoVJTSPxDmLaFZ+lTjQWo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

thp_underused() decides whether a large folio on the deferred split
list is underused and should be split so that its zero subpages can be
reclaimed. However, the logic in it only accounts for PMD-sized folios.

As preparatory work for splitting underused mTHP folios, make the logic
in thp_underused() compatible with mTHP-sized folios. This uses the
existing khugepaged_max_ptes_none sysctl value and scales it
proportionally to the size of the folio as the threshold for how many
zero-filled pages a folio may contain before it's considered underused.

This introduces no functional changes for PMD-size folios.

Suggested-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/huge_memory.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c0892cc533a9..ea5c350b4818 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4413,24 +4413,28 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
 static bool thp_underused(struct folio *folio)
 {
 	int num_zero_pages = 0, num_filled_pages = 0;
+	int nr_pages = folio_nr_pages(folio);
+	unsigned int max_ptes_none;
 	int i;
 
-	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
+	max_ptes_none = khugepaged_max_ptes_none * nr_pages / HPAGE_PMD_NR;
+
+	if (max_ptes_none >= nr_pages - 1)
 		return false;
 
 	if (folio_contain_hwpoisoned_page(folio))
 		return false;
 
-	for (i = 0; i < folio_nr_pages(folio); i++) {
+	for (i = 0; i < nr_pages; i++) {
 		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
-			if (++num_zero_pages > khugepaged_max_ptes_none)
+			if (++num_zero_pages > max_ptes_none)
 				return true;
 		} else {
 			/*
 			 * Another path for early exit once the number
 			 * of non-zero filled pages exceeds threshold.
 			 */
-			if (++num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none)
+			if (++num_filled_pages >= nr_pages - max_ptes_none)
 				return false;
 		}
 	}
-- 
2.52.0


