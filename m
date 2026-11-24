Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48424606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=MD2yQ8mo
Received: by kanga.kvack.org (Postfix)
	id 4F37E6B0676; Tue, 24 Nov 2026 06:06:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47CC96B0677; Tue, 24 Nov 2026 06:06:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345056B0678; Tue, 24 Nov 2026 06:06:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 048A66B0676
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:06:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0EFE8140B2F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:34 +0000 (UTC)
X-FDA: 85469734308.12.7FC55D4
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 45CED10000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MD2yQ8mo;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795518392;
	b=NMDRqojiu+G533U14QYyE42f97j6DsvyoPbPu2oC0TMJ7oVSb+s/yIMYAJA9jvJXxj7Q7T
	//PLdiSZOdluNhMg5wfv0J6t4TmTtwpMF6QqBtabmy+p7mvwR+WduAheo/err8qbJkcxSo
	BJZlOeYw3QC5kQpOtN2FiSn4cYQ5e1g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795518392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jvR3C0Rm0Iwfz342yu15wIbrtblehpCvbwmdKPZLj90=;
	b=LNQ4WDj3rt2KossqQnDU1CQx7oWgtRRyRGU6tJ+83It8dM2+431vAnyCHBZTDGdwlQgFh4
	gHU13/HQ48bRLFtWLwOglYwGJEsZQBBAAJiOznsPFXbYcdxqK7jpmIBR23NMHJfH05b5ia
	uat6cnezwheQMJTi6hZE+uHwCAql85A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MD2yQ8mo;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2f04bea9a93so37113995ad.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795518389; x=1796123189; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jvR3C0Rm0Iwfz342yu15wIbrtblehpCvbwmdKPZLj90=;
        b=MD2yQ8mo/cHsSkZVjpy2zsYiHAVGnUWp9ntJ3xlmYVbLjgEtCnyRHhRHAKRYM2HmbA
         F3LuFLMTE6Jt7tU8R/9QQiy3O9Iy2iaL1YmRn8YmuXMGlnkZm6GBCsSq3LNSYB/wqTVb
         UnN3kAS7EeyHxmuOrejO66BVVdc2n5OewSKxmkflQniSH8T6tusYDcg5l0adT+zwy5zD
         /fdsqdVITp/Hb6eToFl3R19S+8/JSeYJzGdH0BI0HhpjI+cwVTQFDxCYG52QFpfZXMmw
         1S4iWTjpChq7F+tsA/WXKgCrWmgUp6VY6z7X1OHvs0D5IVl3NiRXwSmR+EvczgIKcMoT
         IU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795518389; x=1796123189;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jvR3C0Rm0Iwfz342yu15wIbrtblehpCvbwmdKPZLj90=;
        b=ScMqxrHSYXSbYT6QH167QdI80YI7EUpUt2xqek82FvjCokQrFoevGfUX75RLfFMf4a
         LEuCObSyOuBATXHjCSQpzdtWDhoPu0ef/5YAwMQV+kEvthfkK1EjNrHirDzy8P4FSEhf
         1YGut/ARO3XRN/fzP2D0S1KWmGMqU+E6lZfswfaR9lYTUpfREHmB9Ov3i+YI/2SilRJ0
         tmrfv7eX5f54L8oOuwNifn04mmPyjWV9J9QfuCK7Zj6BlbBiPOyfSooqJmOvWzRCs2BO
         kUGp12+7kGHDrzep8jibW5/dSre6f32HVxrq9loljkVFRShpYP+nEWlH9tp3ao9taGm1
         jggA==
X-Forwarded-Encrypted: i=1; AL+hErF2KmOfUGvsRVoKn63O0rONaKLTsZYTubIRTh28CeCzyxS6ev+2nIVq2bml5KGm8mW3SxoHXci5pA==@kvack.org
X-Gm-Message-State: APuU4Z/93UuiawhvwXhO5PzLQ+n3TqKS1qX+DNHHNErIN2/HMhjcz2CA
	HPz6nlamDVUHYjm7zg996GcPVB4Bp3sTvnCthy7JsuHitPKPP+NaSgPtPThIPs/7NxU=
X-Gm-Gg: AZFdTZe0n6GuCPXEd81jxuyq/xCjRg6g9xixuk3ZQMniZ9LbG0JblpSTeh7eM2WoHPK
	ci/erLUI4OCVIFhC0pj0gwRrW11pB2hwB+GPxr7RaT9pV3vHYHsPkDbDeWFbPy93YBvw2LEg98f
	IdVmfwfvgjdo1OIulc2lzLZROuuq77VCh3lVyFsi7NLP019UpWYhNdvqgYmJ+30xdZ+2EK3YR6a
	Lx96RdBguZIFtcnASXI/kXcfXc1a2XlDRQBMZeWXS8EBYoZEB1vqnj/Lkg31U9wGz2ZV880cWip
	7D4BaBqeeaJKN6v98P/qKb8oTb7FkqMA0ar7PECMVKDev6ZpOrP2IsdCQMFeAJLC1Ix29KE3N9c
	mbCSi87GOWAe6y/R2q8oHW4h0YdtUpTJVTO2mpLSzzpYJS9uh2yfSUlQxlcI/bzQYL4itnl4Q6U
	OQ0YqNtCe2nY3Dxy5n9tu05eTrzxwHPcsVSS4nOA4mOGpmH4v6loK9PPLERmwwscQRPkutBzUXF
	g3StOds5GhFlL/e+xJraTZbi1KPbkDRtYFP4oq0HZ8ZLT/kk2DBsw9cLv2ynDtoANINyNm/PgkQ
	vFKTwi5kBJGOXfRstQ2StQr/3wqANqBXUpI9I5VwBf8UqTVK4g==
X-Received: by 2002:a17:90b:4483:b0:3b0:9deb:d991 with SMTP id 98e67ed59e1d1-3b41c92cbb8mr13417925a91.35.1795518389329;
        Tue, 24 Nov 2026 03:06:29 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm22909735a91.6.2026.11.24.03.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 03:06:28 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 0/6] mm: Simplify HugeTLB vmemmap optimization code
Date: Tue, 24 Nov 2026 19:05:24 +0800
Message-ID: <20261124110530.3004071-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kcn36fhnqb9rrh9eat1brk5b47rmg8gr
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 45CED10000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1795518391-864743
X-HE-Meta: U2FsdGVkX1+XBzu5DTD5RhAG6gpwQC4XlXNX8maAcjzyivzfWBZUGOmjMuG1sTpRksnGXXFMRieYvvrn7uv46qluBETMNRNRCytWtbEzXDfTcZKHewgBSMe+sHToF4ZLU6URJ7tUMUefqRLPSke2UvfgPJpEczxp6DK2HOe4I6uPw1ojrZTp4mgXC3jI9MFOaHKuSkxO85xZIhlY2EGOjdfHuF7WMRXRLxaEDcnD01JJ9FBRY9secgxLsqYJS8XM/fZh4m3VlwfJ8rDLxWFzKJQVzqWhO3Uzv4KnMs+DMHZwhA9uhYICorlC9uULzrgwWl0akQkSIsiKMCAFqiykraF9Jnd9BaFyUh3ld+jPfjdZiPNPWfZyNLcKgaa6gYESOw9OjjXRSNGdXpfdVYeB37ez4CeqjS7m48OGiCEUkD4KB1bD9WsFf/I7I6N2kv+a8XHYsM5fXf8REcbLon1CjQdwDVpkEWcT+7Q3TkCfoADmVcQJBhtUSCi3jSUGvQqXPKb2nAWDorsaumrfDJL/PW4Fref8A7GZHsZBDmfD8HT38o7nwY/9v5slNb6IYeus1Z+QCGE17vnFwr3VqgLW1QPagXvI7zvGnAT+PbzQFHeW6Q12t9LTN0/h+7enVY8odpRg91GXiRq3HufFPVNjhIEbPeM1noYdwc8zOXhqmpgVuBdQtSxWwtnYxqaxu4+pkKNnkSkpWIAYv315UPESgfFLi5xdtW20Eh1yR2bza5Qw7YwwSxvL1d4aV0dj4Bm7xHYUkI+APS1gIrGorZWmFoUWwdcXaiW/7apy7qoJx5nSHrAGr+eQ/Zgx2ACDP/5VROYmvNs1NeN3UL+wpZYq5fZFekXsLJhBrIQG6zJGvsY32JWEYS/tcVAwkxBjv/BkaWsvbrQvwMqwRuR2c2IB6++dWZJhx1dw1jEu++iADKh6JSvs8me3gdkqZksFp+0Oq/NL8nth04nEEnW7SZp
 hdGoUnQE
 Y5XDo2QkKh89WeEE/m3BGXoStxkWbRaTElHcv4Wsr9CBEgNSKcUuEZUXVsDenIb9wuVKH3z9ZPvnN5I92pVFZXN2mltyNQwMPXLZKuqtk+3skXI7sjd+HDDqXNAseXqdHAvA3nQQEn4MilgSk3CNJHkOyFXJi2KwA/1iIlNM/pKnUJ8ZgA6ZD4BJHZujCnwqSDP7I7E0RyHZPfJPw0UohlzycKrUnaZMjQf/voeZ6hbmgnBwLkwn378ArsMq/OGXzcAB12hECi6z8sgr2RhL1T6XCb2NU5m3UV1WpDjZpLf4YSbcndBaHbvKn72eeM+09rmLZm/r06TUwK9XJOTO2CMOe7Lg3gW6KR8sSMqsMiYqaU2EMs5Uoz2ZvwAVa2i/SU5caGoHyCZy3V0plWzUS7EoAQOZekIPze0kUWZ/IDecihId+RdZwoDuVmyrITcRl1cO2vyLy78Ol6xHVXduU3Os+YqfaJKFPEdIlPvhlYYMqMHjgD1w/U0i4cBbg63xo/Cd9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

This is based on the mm-new branch at commit 87cdbd9bd631.

HugeTLB vmemmap optimization has evolved over time, leaving obsolete
and duplicated logic spread across the implementation. This makes the
code harder to follow and obscures the contract shared by HugeTLB and
the generic vmemmap optimization helpers.

Simplify the code around that common contract and align the HVO
implementation with its current behavior.

The first five patches simplify the HugeTLB-specific implementation.
The final patch centralizes the support condition shared by HVO and the
generic compound-page helpers.

Muchun Song (6):
  mm/hugetlb_vmemmap: remove the vmemmap savings boot message
  mm/hugetlb_vmemmap: fold vmemmap_should_optimize() into its callers
  mm/hugetlb_vmemmap: drop the redundant hstate argument
  mm/hugetlb_vmemmap: open-code free_vmemmap_page()
  mm/hugetlb_vmemmap: drop obsolete restore refcount warning
  mm/vmemmap-optimization: centralize the vmemmap optimization support
    check

 include/linux/hugetlb.h              |  2 +-
 include/linux/page-flags.h           | 10 +--
 include/linux/vmemmap-optimization.h | 14 +---
 mm/hugetlb.c                         | 14 ++--
 mm/hugetlb_vmemmap.c                 | 96 +++++++++-------------------
 mm/hugetlb_vmemmap.h                 | 45 ++++---------
 6 files changed, 58 insertions(+), 123 deletions(-)


base-commit: 87cdbd9bd63174de47ba16555bfe9800a8f3da07
-- 
2.54.0


