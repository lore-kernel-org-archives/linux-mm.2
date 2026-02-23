Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78E12EEC2A5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 22:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2FCA6B008C; Mon, 23 Feb 2026 17:38:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB0A36B0092; Mon, 23 Feb 2026 17:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C803F6B0093; Mon, 23 Feb 2026 17:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B7A3E6B008C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:38:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5688C16024C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:38:43 +0000 (UTC)
X-FDA: 84477187326.29.784C69C
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 680E3C0009
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:38:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C1TFhiOn;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771886321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FgNKK4IJNslBJZZOngZoyEbar9yDv1r70Pc6CR+o2yQ=;
	b=pXE1LIHaUgj4eXxfPLL9EVOmODsKOn5GwaLxLZ/TGZlWnCd2CkNBwPFscMmIVAnrZSrKzQ
	Qo80cJbek7r+2awOuL/S8ZlfSl1AUoVFUcKym8bocE2sID0u1RjycX+vVGnyhRvmKNW7Mq
	Z3DtV6mPWkOIKJ9ae5Nkh5OarxmBYw4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771886321; a=rsa-sha256;
	cv=none;
	b=BCIyvAd2sDnW2Ef6XVWKYf9Wk4hpVjjEGba1xzrcoUjwXB55L2y/FQsSC18WNnWOzoYPLB
	BnobgSNefs+4z0r2biqPiMI7g+xvAipu+8O6rhrPxOgjf6dG8GmE9ol1/jNGkDeF4JQCkV
	EoH3JIt6qF5gXHCGDjAJEYGLmjErnMg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C1TFhiOn;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-45f171cb842so3571624b6e.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771886320; x=1772491120; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FgNKK4IJNslBJZZOngZoyEbar9yDv1r70Pc6CR+o2yQ=;
        b=C1TFhiOnxTU94WVp+uQFC8f/2eqHoOGB1mIi0YMUWdpMn0QreqDpstAdIgKcygEKdT
         Fzyj5NKjyT14MWJ/BJbbYpl5Cbt5Vr9QoKmOGJ2G+g1Krp96xU6f9yt1FZ3ZCgoheUcO
         K6Anc8q3EPf2tgDP3vt4Ib+XQHtiXHk4GUvlcZDAP+iqfCw+uFVWAlESbuzuGfpx5zbt
         zI1itIqBMJNId0ld3XzSD8BguQT8i7vupP9T473LuXtfobnJh/HYfFf4BNzi58tFz4MR
         004W4Wsf55cn7lYTHYxVkI96n4HsB4u/FL5E4KyEkc7ylxOrORqlLNNQApMeDlzSt2KG
         dN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771886320; x=1772491120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FgNKK4IJNslBJZZOngZoyEbar9yDv1r70Pc6CR+o2yQ=;
        b=iXVHIW8du4VaaqSuF1SWtU1ht1+kT2QQps+uSABjYGMnaXMazH8lVz6glDm+zY/BkG
         x/91bLdDMz4ZxgMgupeXkTVjgPcg/yAaYEyt8QsPhs4A0jc3W1rUOFyrY8KD7Tqip2vz
         PWzL0jFWvEx5QTh8/N7RADOOtgNP0Yaq1xgIvuwzvF0hMovdLZUJhTbtA/DqBNS/Wvyw
         clnHTK7dk6WWIzZ8j5iVlmPO9wgnZDcMVbPHLxqDdrkAs//11nI1bi9Cxx4/iMLMn5yT
         7ieUGVRONAqCIyNocXcTD8nwwfSJE08Ju/vKZmWnp6g1aKUvrTaW2qTi2IK5sqzm9TWI
         jHzg==
X-Forwarded-Encrypted: i=1; AJvYcCU/DRPvAXQ2ejl8dAf+yLcHxqyq2HrA9GUksfcvVq2XF5i/mge8zujp+stEr2CdLQZ/1o9f7HGqlA==@kvack.org
X-Gm-Message-State: AOJu0YzYyw4WRp1gUIj30OZZ3NPWExI6CuyVXl4Q+gDVzQJNFRMUQCwJ
	UqQd2wxjAGQrRU17k47XxhHH3p67YRKV5WITvM+9rotQ8zvSKT6cvwXo
X-Gm-Gg: AZuq6aLK8sxvLmAg082TbD2NKm2Av/Ex+yuxpcKvb3GBZXjqVh1/iaiw7RfwB35EHKS
	No4vdULZRmgycweRsf6f+LIt4IkRnJyMBvGmzKe7vWS/kaMRsgAC/fUm2zt080ffaFYzfdQAISL
	LwtyrJXMEJjQNbvmsweMEL9s8owSJGSQ3SSrIHAmYfN0hW86d/Ri++9BlLLWSjEkv/ELBW0eVnW
	xsQ2Hv4XHVkQ6xwB7aoBHSWZ6gkqsCYW6K7IrKVfmK4HJjsY82HRgJINLhBJ8C372heqB+Dn9Hb
	/Bo0n2xOAmfGM5hoMqmgRrfYzODns9/D8ZM2yIIWjsbedxoYCTpSYu8WBycEbLoy2yy74Ib2sjy
	wTVnWvmcCQuKsWXlZ1obY0XoVE5FHfu+9lx/b/ZOpEhVH+Pbc3s92407eppal/SUi7EHXADZSex
	9zlfIX2av52MYyi2aEOvEGv1NEAdK6+IU=
X-Received: by 2002:a05:6808:3442:b0:453:7cad:63be with SMTP id 5614622812f47-464276813fbmr8219044b6e.31.1771886320460;
        Mon, 23 Feb 2026 14:38:40 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4644a1afa44sm5819928b6e.16.2026.02.23.14.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:38:39 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 4/6] mm/memcontrol: Charge and uncharge from toptier
Date: Mon, 23 Feb 2026 14:38:27 -0800
Message-ID: <20260223223830.586018-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
References: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: hz1wooibue4akxsrih1mfmzxr6ujxkwx
X-Rspamd-Queue-Id: 680E3C0009
X-Rspam-User: 
X-HE-Tag: 1771886321-636544
X-HE-Meta: U2FsdGVkX1+axpdEa2f2QA+4rb0N0lwqxt2x7L0zPkVxiLA3tSKYjwLMEHj4ZvxPzHrGHVTkQv3njOon1q4pqK5DyESyycuyisfUzgJNAd2NxFhfcCqzWRHHltJzAsz2i/9jy3Oj0qrDH3Ln9XY8+shLNXltWdC30lWxtPtGuZ+Lo59SCHy/sGOE7AzJ90EZXMdyWVMMLP0J1t5y+cXuj0bsQEe5G9JzfcxdNr6azrbiG2c8A2K7kClEFB9UMIhQ2muC55A7xNbF9CoU0lqy+933VBd8KNOtV3ncudwCYX5/41bzZM9oHrMY/64h0zGBDrYU/zi7J1tBiTBjbNBaqQFhGdpgshl8oEJL/GNk9zlWbI2cj37PPhdR5uyEcSL003cGXORxeq8NX5ycKk1QYt4t4WbAUZitxo6uWNKCJVaS4mn8cUQ+0Nu+cf8+nyeD84k8fUng01RM/WqsXjlh+zrgA/wWd2MNoGiRweNgWOiZ1wqzU44WC6+pss4Mhy6i7cga61WAzlWhIppAKDuKtJTsAPwlWKXZ00ex4MSlu+JuwfoZNRh04pCaT1XcfprnhZ45OoGbWsDRFlRC4/247TlmejXLPhzK2UsisYKEWE4ajAN6CKF7c7jLREcfqg4bUmNMbE8B3wVBjREgUFakiJzc2KxBgWOZoy6Y+28wLFuOKgjX7JInuTSY43LtucJ1D/yFnKulGTMdqpX8ef6+kKfyaEFPgiD16xzvkyEkwkuQ2Ac0EIOzj16X0z+ims1I5GqbuSa8hh8mbmov6VqWeCJ0EdYIkSR5QW3SfT3PLcbpYCmXuvcU6MjTKPrc5SvVjpfcK2iu/qrp4ZlBKde7TKuION6z63fZ2E8AnBp8ndiMI6qKSo4u1T9xAx7Ylba4opjqrtEQbeNONEkR3tCyb2sKTt+IVJtmeVVGyZHwLkfiLq+8gf3FhbZkkBaTVvvVlxQBIGrQCvo9Vwylh+8
 N8YuW6hy
 +Oz8L2xHbZ53j7rNUG0xOdD4E4UYAed5VujVjJ+2pKKvbmQp2yZiBtR+qSYgmRRnUCuXbGewiCg/08bRazPOW7qHEHYeaEFDqtSWsREnpE4lgPOL0rQ8H65j5/Jv7rDcreyQV6pC42WWKfjXzw4GdON+IvXjrYEo1yGOi6758VtcP7zGD7PPfefXFWdoT7UADJW0E9qbHvK7pMdvKmPPw2u5+Aah6BewFCl+gLcYJJvlZO3U8vRQJBOnAwJcfwctn5bDa6MRYTxl5sDaYUXW/YtWN51opa2JTe/3A8ydWhD9gf9TGacMi5TQjEN2UiGR2/+hiCwFYv8f1N9LghXJZFlxMyKs9vmqZaVeH2RNc/Gw20vgYEn8s4S4FsOS3g9iBSyxcDGNLPbkDr60lqGL6icMJcvNjqhirNRijHFsXG+4KPVr4HWulskvrT28QdYAi1X6snhX0o0ydupTrl67jAsh8YJCUTWx7euLcktO/O9CsMdm0Oo7bwca45Wl9cz2IpenmccfOaevM+LHJGd94GukwwiTwSNtbGPc3m8O8/FK1IOHgI2XehQ8Vxs0Z1E24ljiChttqDSY+0Cm0YxT5JSSAnJDzzUktULx4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify memcg charging and uncharging sites to also update toptier
statistics.

Unfortunately, try_charge_memcg is unaware of the physical folio being
charged; it only deals with nr_pages. Instead of modifying
try_charge_memcg, instead adjust the toptier fields once
try_charge_memcg succeeds, inside charge_memcg.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f3e4a6ce7181..07464f02c529 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1948,6 +1948,24 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 }
 
+static void memcg_charge_toptier(struct mem_cgroup *memcg,
+				 unsigned long nr_pages)
+{
+	struct page_counter *c;
+
+	for (c = &memcg->memory; c; c = c->parent)
+		atomic_long_add(nr_pages, &c->toptier_usage);
+}
+
+static void memcg_uncharge_toptier(struct mem_cgroup *memcg,
+				   unsigned long nr_pages)
+{
+	struct page_counter *c;
+
+	for (c = &memcg->memory; c; c = c->parent)
+		atomic_long_sub(nr_pages, &c->toptier_usage);
+}
+
 /*
  * Returns stocks cached in percpu and reset cached information.
  */
@@ -4830,6 +4848,9 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 	if (ret)
 		goto out;
 
+	if (node_is_toptier(folio_nid(folio)))
+		memcg_charge_toptier(memcg, folio_nr_pages(folio));
+
 	css_get(&memcg->css);
 	commit_charge(folio, memcg);
 	memcg1_commit_charge(folio, memcg);
@@ -4921,6 +4942,7 @@ int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 struct uncharge_gather {
 	struct mem_cgroup *memcg;
 	unsigned long nr_memory;
+	unsigned long nr_toptier;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
 	int nid;
@@ -4941,6 +4963,8 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 		}
 		memcg1_oom_recover(ug->memcg);
 	}
+	if (ug->nr_toptier)
+		memcg_uncharge_toptier(ug->memcg, ug->nr_toptier);
 
 	memcg1_uncharge_batch(ug->memcg, ug->pgpgout, ug->nr_memory, ug->nid);
 
@@ -4989,6 +5013,9 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 
 	nr_pages = folio_nr_pages(folio);
 
+	if (node_is_toptier(folio_nid(folio)))
+		ug->nr_toptier += nr_pages;
+
 	if (folio_memcg_kmem(folio)) {
 		ug->nr_memory += nr_pages;
 		ug->nr_kmem += nr_pages;
@@ -5072,6 +5099,10 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
 
+	/* The old folio's toptier_usage will be decremented when it is freed */
+	if (node_is_toptier(folio_nid(new)))
+		memcg_charge_toptier(memcg, nr_pages);
+
 	css_get(&memcg->css);
 	commit_charge(new, memcg);
 	memcg1_commit_charge(new, memcg);
@@ -5091,6 +5122,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
 	struct mem_cgroup *memcg;
+	int old_toptier, new_toptier;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
 	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
@@ -5111,6 +5143,13 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	if (!memcg)
 		return;
 
+	old_toptier = node_is_toptier(folio_nid(old));
+	new_toptier = node_is_toptier(folio_nid(new));
+	if (old_toptier && !new_toptier)
+		memcg_uncharge_toptier(memcg, folio_nr_pages(old));
+	else if (!old_toptier && new_toptier)
+		memcg_charge_toptier(memcg, folio_nr_pages(old));
+
 	/* Transfer the charge and the css ref */
 	commit_charge(new, memcg);
 
-- 
2.47.3


