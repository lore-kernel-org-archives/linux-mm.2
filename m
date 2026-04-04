Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A930E88D87
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 07:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B4F6B0089; Sat,  4 Apr 2026 03:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBF36B008A; Sat,  4 Apr 2026 03:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CAD56B008C; Sat,  4 Apr 2026 03:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF896B0089
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 03:17:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F0C78C3E8
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 07:17:48 +0000 (UTC)
X-FDA: 84620018616.18.0211EB9
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 437ACC0002
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 07:17:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Gvhygw8Q;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775287066; a=rsa-sha256;
	cv=none;
	b=vKjI0VUxxPjTtNatuS+i7l5fESi9cprAdmoV9laFZjgAmmQmbXnc5zE2yzaBtDmXppFpiz
	69vl/3yzxoqwnVr4Qs1DZumdO+eOZCTml2N/Is3S11JClQhGseTZJj1YpGICgEqYTD6O7F
	N0DzfCkeMdnEs177yttoOzrxUj+dIng=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775287066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4Nvft068bH006LDXNZII5o6Ddc8RwmqN3Jk81Xy5HA=;
	b=0/p3W6FtUvJRNFtiKBb6aMAdwrOiMKyUtvFqJDjwJX5mRtjaMjr/a7Unvthwrt2vGw3R4i
	QzNnC0cFcpmNYGjvfHPU0GXEgqXN4e3A41bCEvQJEfCQ4XlUWFb+SsCnC1iTky92lO3bpX
	v73rktv6edr761WcTLR1HkfCB2BkiJw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Gvhygw8Q;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b24fede2acso13193125ad.3
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 00:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775287065; x=1775891865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+4Nvft068bH006LDXNZII5o6Ddc8RwmqN3Jk81Xy5HA=;
        b=Gvhygw8QvS7uUEqCt5XbNuEao5qvfbCkknkD/Xhm//bZTis+kYkCVAvLxR7QthBf1v
         FpvUAWgRtTH8gwYFe222ZNiwzt/wrnPdU1++/osqgGWsV2AcvUaIIpvhWpD7HmJCd6Fl
         4DUUvrfZf8468ljBHK4QeebPsm9LBZUyraJTJtIX5ldslglNTcTUTFRGnkpTyG4YIqmu
         Ijy+Epqan9KXIh2r8Pq9cfroFDyHfBP2IcMpN1PJRnYuAp/6f39v9Z5gfQkRxy/piXdT
         BrcRNFlOr5Ql/+lI3x3CQ/ldgt3m60GQaw1M154AtZT7A1LAZc0zt5s6oT7DLhC09Y/L
         p46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775287065; x=1775891865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+4Nvft068bH006LDXNZII5o6Ddc8RwmqN3Jk81Xy5HA=;
        b=rXNxCHVFGpQBTPoGdkaDJ/0ofSN4e+0UWsL8seokvrNz18xu4ALS23/g2puM0hKXFG
         q22S3Y46lM0el7MIwKygtZecYonIFZyJ3FDF0S3Fief8BzATzYGTmYkLNaEd5UNxOiyH
         L+2/6covmAv93eNvjaSzLAGIz8Pql1cI+OfH5M5g8Xg4s5FfQT0YJY8AxypsgbPe4/Di
         wTRkJ1ZIJRU1f6z6G66T4rmN6pGkvd553C2BwotXXTKx3Eo7MP/ups2w/eAowiFh16kY
         PL0sklpigXqKlt+KtcxW7wk/1nA15xWPlr+NigJFg7JNTYU30s25fl00qd7J6YIAJR2O
         rfZA==
X-Forwarded-Encrypted: i=1; AJvYcCVNZOUCq1RXe38P2MD8w56Eai0zYom9Bxy5W48TRgVzFGm1l2A8X7DToa85wXvzQFkAbSlb7xxLpg==@kvack.org
X-Gm-Message-State: AOJu0YxnpJYY3J/yh+YbDS98ud3W+pJFr7SVfeH+vHRsRyMxU6uCp3E9
	HTweKN4g6ADS1RQSdGmYm4B1obVh2KsCcU3HR73GmigNzX3HJ5dT80AVlAVjQKPWFiE=
X-Gm-Gg: AeBDietZ92O21PJkVaHvvpQy/h6UahjyGAULqf7ufTkrNXx0R2ApgYL7Aq4XKHf02QR
	hTXKmoy6EIlmEKU8+v/Gp/ZSkRJukDGag9CC/sj3ftFFXhTEyzS3VQlok3Z7EJtRGyZ/B1Ubx3K
	JFhR0HInXNGAbbf8F+abwZ39lP56unN5S80KlKJmGw8vIGQ6rUzg23Pi9dMm5csuW7UhtR+HDcm
	p5YLNfEKHDaK+YwmQrdLE8DyJWz+1KMnbzNDSqaybb1gcf+opD9B7xh90BSopP4jpE75ncjV9DP
	hXR486bomGBf3Woide0pXFQ+SicafVjxCSggIkuym+MpkR+yj061VaxfyTBmqRZT76vYemDVrar
	o3SmDToZ+RSTpfl6/Ys8rl2jIHFxeQDJn9Z9BKaaHG9BOvMg0xd4NR/ORCSWTrLigWmfL/znnft
	ye19PXw9ffaPZ2S5WxjkhaV4p6kGSdUnKp3RvxufZ2/QASKYoWitB0Nw==
X-Received: by 2002:a17:903:fb0:b0:2b2:4d08:9e02 with SMTP id d9443c01a7336-2b28184aa83mr55341695ad.21.1775287064964;
        Sat, 04 Apr 2026 00:17:44 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b274979525sm94675115ad.45.2026.04.04.00.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 00:17:44 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and vmemmap_check_pmd()
Date: Sat,  4 Apr 2026 15:17:06 +0800
Message-Id: <20260404071720.3577290-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260404071720.3577290-1-songmuchun@bytedance.com>
References: <20260404071720.3577290-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 437ACC0002
X-Stat-Signature: wjygpx65nnyp1aus961toeosbjy7wyzc
X-HE-Tag: 1775287066-486292
X-HE-Meta: U2FsdGVkX1/BiAx7jMiVVEu1J52Q/bW99FL/VAQHGspqVTMl8qt2QQa5nTy7Jd8UpJlZhtNJ+mnz89mGi9a3ZV5OGwmvkbEUjMYJhjCr1O+Zl1ahi8JPvQhoBfIzFdiiUCth1hwNW9S1mQQKdVZs8SQ38NxKHIfyv2UO8p6p+98kgPZLQ44FEnGRqi8HXJI2FUD0yukkduBTm+ZgP2yPPOgzu4tKvc858xgHNGxKfH/3g6JLPZgbyLLsHzziUUGmtXCnYagVuL10z1ZnApNQX3oyBDon+aO5R+MrS4PqOa+zgUTBLoCQwen4sYDGb6gTIlsPIx6nS4NRBAI4Tg0EwPHSGqqZ1kjGBBZfU5MsfoKFZesfuR50kJ2H4dkaN+NKWyebuglGGcBEn3DQ+8/0vEJvoSA+NCVNoGbPcDWJusqgI6bt/jvgRUEGt0YX4rseqTYCu5OYZOQ1ob6ntptlzrnlvor7r/PuWRLNOxx9cKlsBrtk7vIFr0BPADTAbKkJWEGD7bTalEXQS9ymXRhL3JmxlehhHnEuapcQHIT/EcjrkyQfmHc6DFDnTGBlNgNjCR6TQ0wkNvcHVY1/dOxhUaNHF6xbcQoaVSh6yCm87QxJqJ+88aF/QfBLW/6onEmdRKJgNXKutkt8UInu60xhTKDpaUxsceugbTASP0tr+XlEsbJFEcgAl3w5NTFHxN7jELSzBE7/31dKLCyJXUJc+WNIVmN1YYf58h8bt9PmvPQixPvC/vnkzN+iH5xC0rsKs4WyVjaGLOYtx6VL2oYcyQpKLX0Aw5qDW3n9DXR4HjPCwRoy1DM0Ki4SO5uQOMlv8eixFsyFM0lWLcM0miy+oV2d4nSE9EQW9qtsn6BY1bp6M+x5MzhDWxBUiV4Fs16ZbHHFQHsElzf3BnvPzhkEqr0bcj+y5rUQNX2FlL4qOoe2amaK3II53kNy+PoqoR4WB8x7nfnCVNNZ41OF4Y+
 pso0LMpP
 U54W3+/CRN14Sq6IOo/6alAh2TNYSXBmIQR8ndoSXhZf1qzGPuRrdRteAzSxIe3gJqYjCegoa5ipq3OI6Ddjnw1GciOrpNhmKHPUgsLmzV/5DI0brZA+OAdbqa44ZYoFbrl/5tVxobRCuaPmLdMr4WOrpjVu2atwdU0MuYuxtFMCeV5nOt4uyXGP2pMzRQZCmm0DpovFlPv3Q+XWMgYUEAJr5T2ZOJ62mhWm7KRJUEanFn698CddkK1eY39/GVjGi6OoPw7D7h4MKFpNehjXHPJjYax3USCAXl4WOaRhriWTUEvFKqF5XI/6w8sfk83ZuBGVeHD7Xii+l0rUX+RQxfwK5NbZ9IlqvixL/C9q+k27CssI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The two weak functions are currently no-ops on every architecture,
forcing each platform that needs them to duplicate the same handful
of lines.  Provide a generic implementation:

- vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.

- vmemmap_check_pmd() verifies that the PMD is present and leaf,
  then calls the existing vmemmap_verify() helper.

Architectures that need special handling can continue to override the
weak symbols; everyone else gets the standard version for free.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..1eb990610d50 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -391,12 +391,17 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 				      unsigned long addr, unsigned long next)
 {
+	BUG_ON(!pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL));
 }
 
 int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 				       unsigned long addr, unsigned long next)
 {
-	return 0;
+	if (!pmd_leaf(pmdp_get(pmd)))
+		return 0;
+	vmemmap_verify((pte_t *)pmd, node, addr, next);
+
+	return 1;
 }
 
 int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
-- 
2.20.1


