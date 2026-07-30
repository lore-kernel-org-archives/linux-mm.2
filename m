Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04A9DC54FCD
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 02:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43396B0096; Wed, 29 Jul 2026 22:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A716B0098; Wed, 29 Jul 2026 22:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09D66B0099; Wed, 29 Jul 2026 22:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 949D06B0096
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:17:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CAEA408B4
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:17:42 +0000 (UTC)
X-FDA: 85043831964.28.36DF657
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 61367180003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:17:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VNnNhzaU;
	spf=pass (imf06.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785377860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmK9e5hF10OqnDZaWNEoqEbUdk/xAOPMzMn2ymShT8o=;
	b=V50M0YCbLnI22FshQp3KZLgLwWDg7TUoL8FvtXCjVhucR++Di+6krax/GVysvX7wKcy9I0
	EdoQzx44d9ltVI54tT2tXbcZxc6aTi0lSraeUk9+vMNvArLTJyp9eazqePofNNP+aXXRfl
	kNnp8Gtje96E5rm4E87fFEn+dErJT8w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785377860;
	b=D0aaF0BYBDBKme2pm4wvP27KDQ6l1dizssiYePyRXUl/BFN2E+ar2fjffVYIHP1ZbdSq+G
	kd/rgM5xZO+sDOxLcp/+UWz/8pjIpzDsbiKPmt1168dZgbWvbXc20mzuzF5cmYFGdJNcUO
	gQaKJlexvJ/SWSE3V+sVrxfqIoqXD60=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VNnNhzaU;
	spf=pass (imf06.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84e4e98d2cfso149733b3a.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785377859; x=1785982659; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PmK9e5hF10OqnDZaWNEoqEbUdk/xAOPMzMn2ymShT8o=;
        b=VNnNhzaUyEQTSCnxTC+WWICtKNoAi+go+10UhxSH6JnxfPl9/clDZDuT4fsr9u8E0v
         ENrFaeVwPIo2jh5tWi5EyGzVIX+ch5CSGl0w9NaAV9gWLNNQv5i8srKFhPNEtL0Yx9r+
         D3t4v2k/qWzfaHU2+IOCtdlJ6jEWOgMCwdI1Pc4GsCiQ3lGwjW1TJpNDtawo15VwssDS
         yOfO76UIXXbRkmWlhSWNchQJhHiTYVBnebGlvazUCQeg/H27hRg1oxUgDezgsVbo0K8q
         9kXfomRicrjl6M4g8yiEjpQBiVUVPxDdcl8tbwXaIIQhjLu1DIODBAdlvwmyYLPJlSN8
         ZtLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785377859; x=1785982659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PmK9e5hF10OqnDZaWNEoqEbUdk/xAOPMzMn2ymShT8o=;
        b=Ep0ABH7ZMruc22YumKCI3AqkMbsfl74NOGnDkEl4LIU1hLFwhOMpKOy9FsHACvxtKY
         vmziVl/GRDQ+MOmUfA0np1W8fTAcXE21AVaDdotS23l1K0FvmWsbS7aFhas847+DHz+q
         A5MZ4pIiaeitcXSdQnz/O5cOXPPuqkHIP5Gn6417uT+gchr8refHHgRoRocn/jxJgRWb
         03i0RnbXuZ4iuSFBWlrPPXGz5yiFQa63ZFIho4QvqUBP04N/ly8qxtnroDZ758GS6Ypk
         Y3eXwdiXKVubHw7VgCakDsQ+ZPMqHz7W77jJDblKyUr9oL8V/LiqnACebLpQCQX49xfa
         Lkkg==
X-Forwarded-Encrypted: i=1; AHgh+RpDfAkTGD43Wvtxvcng+NJUXxkBpaY4hqRBgpWl7qRDM0NRfkZJc9ttVyftOBnJ6VyrHl9aF5il2Q==@kvack.org
X-Gm-Message-State: AOJu0Yx93AuVUOTtglUCXGDZB2w3sdjToTKfDzwpVq+7VAzR9o7hj3PX
	j+oxE2WDGEAsedbWxALzcjSj8HjfNsTJEyhcis6cfs2/vA95//vqJI2B
X-Gm-Gg: AR+sD12K78cXIoRGymNTsELxLkHqP5iDkj6oz30BFKK5MmSYkf+iQAG4rQtURxUeYf/
	Zm4jJP4X1pc7n6k+mUZJqcMLGt8pWQmJcJ+el8+jLbbr2a+xy5vxxwWvEFvuWJ3fVG8hT6k35E/
	4HAFlj04M484HFu2ANqUe5NoMaeWUROCtmxh/wwJpo0X3oazY0CHzL+0CHJWAvtCLFx+kQhec6X
	0TDrNi/AgWxfsH+qeW+LTAnKy57YlxqtVbdJikEY1iwzmNwQeJoMGAcsZlJ36EbdXB/605bkvNP
	/IV06V0RlxxT90rCQsaSZO9BT8x1xuOSc4G0Jgt/66NJw09JDPgprllDKH3/iXs5cm+cJncQu1D
	7s03wniakV3AOfxKMSoii9aNFnxc5Ftmzk82w3Wi5sMQ4XhqUbnqFCqjKnpkNsAb8v8dh65s0yL
	DvRfOZzx6MY7ygMe/h/4wlu1JFWl35KyYO75jiUZ5OpjCbdfNgVL4wRzBouFozeVblysL8INNUK
	xEoe2yScbqom3DLJ39W2y0WpbPEcqRb4TAx0rfO4t36YCXSLyRe
X-Received: by 2002:a05:6a20:9e48:b0:3bf:b228:10b4 with SMTP id adf61e73a8af0-3c9007652c6mr1025922637.2.1785377859190;
        Wed, 29 Jul 2026 19:17:39 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23143sm2159628b3a.2.2026.07.29.19.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 19:17:38 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v4 4/4] mm/shmem: split large folios only on -E2BIG
Date: Thu, 30 Jul 2026 10:16:30 +0800
Message-ID: <20260730021630.2235914-5-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
References: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z4ozgi54aj87jdrye7hr4pjzmatkptza
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61367180003
X-HE-Tag: 1785377860-471163
X-HE-Meta: U2FsdGVkX19XwwkCuYyOuqcOI3TGfQUph4vM4NfqCLhcvoM0NLGVqgdmIb77hRy3sIXxuHjA3n6D+sedCEvViiFsQ/sANsGizyJrxkU+9IoxGiodzMJFBeVb4cmWfa0AKgUHz9+8A7niVE/f6lznn0Z9Y0SlGaoQYDXX1zfTrsZqAuk6zYiJeIN+ashxy33wHRo76hIex5Jj1IJMkV5nB1Ap2jklsikcU5nfsY/UaaIoBIM+lvG2L5K0X971Uj3zX3UVHr+CNPONK9K5/qPckbJZVr8EZXbLAvBVzScimos2Ejyf7fMfabIXTlh0DZ2s65LkhjX4/kplfzkdUiWk0d6KQ+w/rMwhT0iw7vQUOaHMIVCOviGe3KPp1pahO+hhdAjUxNk/K3D6uohYbQrOx9yatU3HiZvpVtLp8A74w9EQv9Qv3Pd8hgzu5PmulDFweKHHCpBP10G4B6vcNkovvorpRQy7QCVNx94wEYA8ABemrVK0YVNDWuTNaM6Soc2+h7vSPW+bJ/NUslqN+Zayth4fUH9FlIE0we22jOBhUMHBwAhJ7yx0R/Z6LjJGy674bpFquI0yH//jId82y9FetK6gY34XCESwuT6wTuGcukGqYcFCvngObgz6j9EL0yclUCu7+MtA7iXbwL9WZNkpe/0qsuNrJsp7JPTfMJKlx4yPaOENfYlMkYouj97RcUJEhStSCZVvlwJW9r8WSWEhccTcn9n+Pa8L5NSj+Qk1QF+NCfcBoDh02nC2svsDEVVHv9wxPHrQhRkL3YDTA5dqtmS/7gHnltCLJlYJRz2NnAs2QVy+7RgovSQcVt10z9VkifVyoMzinT/LICfLJGxfNJEBe+ONbZUVTrsXEVw6uUj9mP/uqyNSMENe7KcwaoIi8QMzD1vI7fwQQHv3UPU+bvNjP4hFEon+ZfCv3fgoRwVj4HWZvt8mgBUO5/PGA84evt40IAK93xO7Nt5BWix
 3P/u7ye8
 dOI9CTdtEYFhLYNg1MOa2QgOTgWPE8rUt/oo5VwTv1JGX7/AY/Z/QtHOEOiE63Orhj4vKHrt2MM6zMv/DErwOrOTaI+XRMiSbwLoU7o28Iq+G5IsOKba7IoI3vXTLS8J26NjycO0/6ixPd4ASuHCGpjnZL5UpMHgpDK9iDwG0fRXgMoQdcFVxMfgQwH76pRfgQZAc8609mfqKiWSOQ5QP8sfljn536s/1dXrlZVAMl/uJ+Ram/ovKvfZoyBrtxF1pvTLdAVAd7wMJ97tTtgo3gC4EoQ+uoGnvqP3hevC0oMkxIGWo63YsO6328aN1olqui9QyNl1NLvYmmM1GplGNUG8Z9qv5thRNZrIs9Khnj7cZ09CffzFAhjPm4DoOGMWbhfC0oPFeMjpWPPOlWfnCtoYNn4k1dxXVoDYSSAJx9JbhzqD1zRJ/0pQZ6UcKFZnirzYTV/Oh8xCF5UYxLkc8oDfARDtE4LxaJkxKko+jcgw15eJ1OB469rsfCOgYFVfipvXIjuezlvdJfBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_writeout() currently splits a large folio on every
folio_alloc_swap() failure. With the refined return-value contract, only
-E2BIG indicates that splitting might allow smaller folios to be swapped
out.

Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
redirty and reactivate the folio as before.

Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/shmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6641823bed16..6f959191ef70 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1609,6 +1609,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	pgoff_t index;
 	int nr_pages;
+	int ret;
 	bool split = false;
 
 	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
@@ -1689,7 +1690,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		folio_mark_uptodate(folio);
 	}
 
-	if (!folio_alloc_swap(folio)) {
+	ret = folio_alloc_swap(folio);
+	if (!ret) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
@@ -1742,7 +1744,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		swap_cache_del_folio(folio);
 		goto redirty;
 	}
-	if (nr_pages > 1)
+	if (nr_pages > 1 && ret == -E2BIG)
 		goto try_split;
 redirty:
 	folio_mark_dirty(folio);
-- 
2.47.3


