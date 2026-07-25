Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 650F7C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 10:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4AD16B007B; Sat, 25 Jul 2026 06:14:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5186B0088; Sat, 25 Jul 2026 06:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F586B008A; Sat, 25 Jul 2026 06:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4A46B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 06:14:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEB6F1202BE
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 10:14:26 +0000 (UTC)
X-FDA: 85026889332.09.9DB998B
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id F1F3620006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 10:14:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=m1m5AQYU
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784974465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mKnbPcWgHhMyrO4V7xcbU637Ba8Qy4Y9EblUr4Mkk8k=;
	b=SyvpvIGqWppSA4ceY1zjp5U9TsRqTJzwA4vzH+XVi69Ps3PC3wYsX3zqP3/mIPok52NBzd
	5GfPo9vC+S86xm+RZZuTq6ce95d2EByuAHgQ3uH36r+tCXb5KEHNR2bz0TdS5pK/Zs93Mm
	vpnJ7VJslT0h6U3HBZNWw5oMhGgh+qU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=m1m5AQYU;
	spf=none (imf03.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.46) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784974465;
	b=lROBJWPUqNEdNo+vpfbx6I6uzyBsdz/NYQO3+FZ6tMe1BsRdbkWdpff/vp1cF2AVIs4BYg
	1b2lxPeJ0pNx6NwKohPPUwm/ZpVpopVGH44ACnfOyYRnr/B3Uh1dJDyVf6XOvJh5VZPchZ
	4T3T1OFcncjNnftBjLvYDqbgvkD6QNc=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f703a9d05so750264f8f.0
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1784974463; x=1785579263; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mKnbPcWgHhMyrO4V7xcbU637Ba8Qy4Y9EblUr4Mkk8k=;
        b=m1m5AQYUStDbQylcoOFHzZ1U94DnlABYrkgWmSFjvxWFYcPnpZQ81Eu0XiDC/prUz6
         btxibHhZEjCF4Y44nBiBCO4UvH6Yaw475oKv4ZUG7HmG+pe9KLS6uVu0Z4FEohVruqKY
         F7Dvx29Do0OigJvUsalcmk/YYH8/JBQNbarfWRuf08tZPBhiSI6fDFOomJPeJVDxUH2X
         1DyGRez/Fj1SC7FQFPqqGT0UYM9SSOMImnbJtOTdGHU8eVvJkOWXSLzUiO5hRShLUzNG
         bg3aqiyZ0f1KYump4xm38dv/hPMw71IOnLVymdpvluK4Y+uBrL6Qpyg+HJ/gd/Qr9Hn/
         SfFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784974463; x=1785579263;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mKnbPcWgHhMyrO4V7xcbU637Ba8Qy4Y9EblUr4Mkk8k=;
        b=BxAmJhhHE06jopzQtkeqhCtsfGrlIY45IJ3imTY/9uexIr+cJvF9mkJDC0uuT6ZcqH
         T+vHhgsYflkwARDOJG2Fy/xLWMcvEBNGEUoYfBDzA0EKXwWx1M5wQLzuBhS55fJHlPMg
         pBY6oa/jyrv7iBZ3JOKh1feYpFqqT5mthSq3m7XyIOSD5C/lxYTBFwz4int3/ibRsE2m
         4JTjtAOo2fAEP+/I8jBnHUYgyH2GZyUA8a0Z4NNVxUP4sQPy2R/zniTif2X/A1hgKS2j
         N3Ggj6lpWAsxLNyzjvVzwpEyjPqOcknZKDA/1CcWLX2PXL9IUPrMl3DtNugY+cJjyd3c
         Iuzg==
X-Forwarded-Encrypted: i=1; AHgh+Rq0F6bW3YsfUci/jeLMwJnEV2NcrZiVLELqCTO4oUg9hJLROoVt0sja/VpmKL9Rut5ikq+DJuZRSw==@kvack.org
X-Gm-Message-State: AOJu0YwedRVfEVOt9VvF1RijgT9Do49CrhMEIpw71jIizIsjMLrlNAro
	yP5MXta2NbuUi//10rbSrKIzCuHbagflu2gl2G7B3azOAk0QQVYheT2Ho67oPUAiLUk=
X-Gm-Gg: AR+sD13TkUyLxjcP7M9GxeNdUZHLG6nCOvjz7BoJc+29GNyQPRcJ0kJjAp9HtIF9/w1
	gHNxAsSgMpsNfXhc9Qjzy3BOScWOgTb0qyGJ5dGGT1uCnzIzgO4HhGFG94Za8oB2jENLs31BT06
	0ka+4fNCBrK1k4/GKU3eSKtMWfyM0mkoj3pZIbXqP3xYaX4pBBIthTkDrC/yM74bp9iSNBczHiC
	fAoe9rvhBM4cVGBGA/RvRLGCjNxLwjEq4cWM/3ARPnXg90ec1YZUkkUmYbYCdMCPtVyut46jt2h
	qyEGNJjPk7FGYhWIELCu3+VRw3MoBulcYgFeQb7iuf4TllvgnePo8k53J+FX6oDjmiRxr2cnF6d
	tD6yTB0EgswiKqwuHyvvyaH5l1RXmDyJeKGolBvtYhunj+EgzZTeY4TAMtTu8kERhpHt/k1i3ON
	fvvDIouA==
X-Received: by 2002:adf:e190:0:b0:47f:52e9:3716 with SMTP id ffacd0b85a97d-47f9fea1ed7mr1967871f8f.44.1784974463387;
        Sat, 25 Jul 2026 03:14:23 -0700 (PDT)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:1f19::319:116])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f864305f5sm30334154f8f.17.2026.07.25.03.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 03:14:22 -0700 (PDT)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <ryncsn@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v2] mm/huge_memory: Initialise workingset state before folio split
Date: Sat, 25 Jul 2026 11:14:19 +0100
Message-ID: <20260725101419.3938406-1-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F1F3620006
X-Rspam-User: 
X-Stat-Signature: wa784r8m79up5au8k15tn38h1m8un4hi
X-Rspamd-Server: rspam04
X-HE-Tag: 1784974464-203194
X-HE-Meta: U2FsdGVkX1+sLdmNcxFIk7CQINoKPvXpx7eyVd+AfsVL9b9jSEFFh+XuhG6VYCu65GDFLD4nbX7bQJ21cOEG+GHGUbbzBAIPTb/qvauVWs7KJZrF8vwRlJ1ymgI+NxDevTIzcMLCKT723YqGovglrddbXtxu7ye/McbrCSMgKmnPIO1Ii3J0a/JC62/zFXOf8Z1JKRpvGT0Ra9NLJjR/oFTRFB5DtGFATGx7N0TYdBttK5VDZuZEnakQYKbDGAJsBqXEM4LWBZwd0x34Eh31cgU1Gr6s3m7r7JuYIm2+svzulhSsdgjHwEe8hKfmQ+NqoFhrNgwakrjc8+8RrYH/YjKm8aqDYbqa1IF0IMk5iinxhwBSIsvSLQudK1tJfFklMhrA9LM1NXRn8IzVyYDXaCfmpqhaH8vKqtKgimezkUKr4fXOHsHbNuyExoSJdnwSqoHcYQd/AMZ/+kSb6uFUTpXeTjeGd7QqxILfcJvbCpibOdZR8r4me4pjKITdCzau2tCkvEkJiEhR56X8nNir3wEDFPg6WVupfxwGEfaR5hxnLDP7KwVzhDmeH7lIIMP+6YcRNFGgM51DJBun/R2IKua+HL7KrRy4nn7Gm2612wcczqQ87N+kDh5weqbB08DV0GWcWeoAkNgPfG1qbadj1gpNkVDE3kL6SdxrreRhNIfvbkNb/GnnzCogGgG5gUHRjrKQIBwKFDiHhc3lMZBv7QY44tlcRFsc00E5ggKGyMpql0/GUWYqFcIKeqGeDlMSkBfndz+CSmvTJMLDAmkj2gvWXdl4HS01FsOZbddiyGOsD7p5Uhf4iuKyBPmhrjfz4k2MjB7nVTe/8WkzwYAw+j6Ri69vzlHDDERCNJ2ZRLJTH6QtjBNVUnjmw8ESkzMe45H3Frv7LI0FkGYJ4aczHFiSH1Ih4VNnSeJ0mIomNYvodpMfteE7WLv+Vt+p+L3wvydyA4y1KgTof9esk0z
 jDriFyek
 /KYiID4eO8ND11egz5fBPuN6n802uA/jbgOrSEh1DkPdvki6TotL9jrp0ge4VmzfAVuEY5omacjrgIqmzLO4+t1Acca4CONOuRc6w5XSYAkYU9AdAIlbcto8dZYZIU0j7zLUCXAwVzkRX1tLqUlHYjSICj+tBQOl1i1C0XvpQeplDyejdjc9m3s58cr5dtWhu+a1wC7zBUn78KaghsGi/QVHJQoT519MXxgPeCKsV8MtPzgtdRqqAxZxwKZMtYMQGndKRa548Fyg18gO8sshaGSBlCH8pmwsP4HWui9WVEgI0lbc9dJkwMYxNZEJhg1fXbRt0Nmf9PaPlbglbFJJp9A2tULvMp/nRoBw6ener2bqXCeEyulEzlf6MI4ZUT10WmfhTQ27qIjef5kikARIOQBq7KZMVuuxqV6KCFXZQCh3L6UQUiUNNS64jpMPTts93IcARJ6HURjRe1NVXh3jqnxn9aNySjQg5NesruR9YvW3DPfAkHhcCC0l7s8CBg4600E4t+oJirJnVhtnUtG81mSZUC8I4LbtCG2F1fdLhWWq7EpzrVW5LXdAS3Vk85Q43t3z2SGjnBM+rSNICzRpxQ826B0HuIyY10Ckf4yaPY3Jp7IjozPIkhxXRWQ2ExpO8XfjMP1ApXeOSORkPqqM3F+ACl7xhOm5XeiE/I6zkjxotCuS3PMX2Jrnb2+ADvqWFfID4Yj88OtrRp0AbjSfEQpYAs42MWvA5skJl1Ksz47UWJy9j1LGfgPzN5evaEdziAWzdvMwi0BhYXk8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matt Fleming <mfleming@cloudflare.com>

xas_try_split() adds __GFP_ACCOUNT for page-cache xa_nodes, but
__folio_split() leaves the xa_state's xa_lru unset. That lets a live,
memcg-charged xa_node exist without being linked into the mapping's
shadow_nodes list_lru; when reclaim later walks the list_lru it trips
VM_WARN_ON(!css_is_dying()).

Use mapping_set_update() to install both the workingset update callback
and the shadow_nodes list_lru on the xa_state.

Reported-by: syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c5b060ce82921a2fd500
Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
Cc: stable@vger.kernel.org
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
Changes in v2:
- Move mapping_set_update() after filemap_release_folio() succeeds.
- Add Zi Yan's Reviewed-by.

Link: https://lore.kernel.org/linux-mm/20260724195244.3715130-1-matt@readmodwrite.com/
---
 mm/huge_memory.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b5d1e9d4463d..4ddbc72e92fd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4033,7 +4033,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-		min_order = mapping_min_folio_order(folio->mapping);
+		min_order = mapping_min_folio_order(mapping);
 		if (new_order < min_order) {
 			ret = -EINVAL;
 			goto out;
@@ -4047,6 +4047,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			goto out;
 		}
 
+		mapping_set_update(&xas, mapping);
+
 		if (split_type == SPLIT_TYPE_UNIFORM) {
 			xas_set_order(&xas, folio->index, new_order);
 			xas_split_alloc(&xas, folio, old_order, gfp);
-- 
2.43.0


