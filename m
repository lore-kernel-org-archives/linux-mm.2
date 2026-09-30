Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D419BCA5FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB75D6B009B; Wed, 30 Sep 2026 10:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68766B009D; Wed, 30 Sep 2026 10:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E696B009E; Wed, 30 Sep 2026 10:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2FC86B009B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:07:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C9B71A0809
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:07:54 +0000 (UTC)
X-FDA: 85270607268.20.732A385
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf11.hostedemail.com (Postfix) with ESMTP id 73C5640006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:07:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SrCW5B9y;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lYqlLPEL4NmsKfc4jswjFAJ2nsB8z9Iog/hwprMxOQ=;
	b=S+2PMvnsRkjcTkxH74GnuTwBlwmCFWLaC6rWk3UKHSoJFLqzhxTjwUproVi1vuM6vFisho
	xqKmiLcVObCXDjNntea5or4tgB9q55VRVg00fM47ia/3fBqnqJk4cFqWIzKcEZPnRj6UNH
	ZIJEy17G43+gfUJ7ZhahnJFHXwxcDsU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SrCW5B9y;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777272;
	b=RNhRsJqQDnEg0x4rge0IfNdl9ZHU65qoMPBjMyg/9XUhLDr1N2mSkwIeVvODsElXtzs5oR
	Swmkxhm1daf2Ijg5xERbrUBeA0ITW56aEMmF6oxY//pVfJLtDtgVUK5maipYWoFapYMEqw
	+ZC5UFYcH+f5nHVmT3wGELnFebKUs/o=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccb652d7so3868454a91.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777271; x=1791382071; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4lYqlLPEL4NmsKfc4jswjFAJ2nsB8z9Iog/hwprMxOQ=;
        b=SrCW5B9y9Fv9jDmuWfdcdXqAJ8wJodj+VY8LwZLEdbNpNfUbUPZu4FZio1TVqWIA/H
         AjlCi9mR88jMysmJhcM4dMAFmPRqfxzoE9OYhZJtcq0Fpm3osCLWEe29i64L06oXP95i
         HRmVwzrVzANGvTVNrB8aKdjNWi+SzmR3eJBTSO1khXLUzdWDu3QnGIYBuKNOgRCKHHKe
         cnEUpfLEpmkyCDokuxRdtXr6vPROQ30sUr12OgKcGIE1zLaF1ZUkzN4xxr4y6D+5ave0
         m0M0niEgcApUhWW2TOeYFulb0XbFaKTzSR5FfQqhKqDOjaxDvrXXgi4MhksCTz/fQiwt
         yByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777271; x=1791382071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4lYqlLPEL4NmsKfc4jswjFAJ2nsB8z9Iog/hwprMxOQ=;
        b=X88kDPCNyV/NZ1VkCLFTvP1xaiOqtD/80dePjdH53W4oIUzKYKwhgAlOCuoGqYcllJ
         Qtz/4Yf1ZaPVEJJbaBeio5L2uEQ0zEed+Bx7e3vcrWlFTa67OJZaGRqVi8QJdvUwIqXe
         4V0qVqk4T9yyp8YI5XuMrd4+pU7aUWBNXHXVuSAlwwRNG8CvcO4CGmgcoGpiFC1HyXKL
         LLmzxXzo3CzWNtypu6wQh0jxexR3R50xzeHFGziQ3br9JXPEJkDZ1KJqMpsf8goz2DIe
         vSm0fD2PfsbKQenfloErFDQlrIdqPnkItrjlXXxac1XBKrWKAT3Bg4kvU8b2OiSfcoQN
         Gjrw==
X-Gm-Message-State: AFq9FYKjkCngSSfe1KWWvXB3SJv/3zrYKL0VwbE03T9v1diQTRNJsJD3
	/bMoIgUAuIYNeJTl1TxPnBaKizSm2Sxir3hmWRdl1lEIYqNhIvUOJeZNCcR+LpBQht0=
X-Gm-Gg: AYBFou16b+gj8oY5KFwor7jsh/1A0DoAfAKKYgrihJLrdcRriep8NUJuI59NN4xNGE9
	L01PHVHXBfMOzaG7pGqH26wVetwOZxLHVJSw+GbO6hCSdAKuJx1ZV9EUX41o4zszic6+qvRbr8c
	JAu18Y2+hrNDXkYDXniuSKCIjKP0Ytn5ANX4FtUpstG2uRX9l4yw+EQqlKrAtPg+AI3XuN3OmhG
	VQUpPCmkKHECM8yx544e4LFJ389yKk/gpwuOSkSypDZPTv+LOzf9p1DCydRk0QS7Rqzwxmlv5qO
	24VAFUujfP4CMVgHmeS2uo4uWpU3evSMMjeFi9tjsqoQyt/6r7cHq60zbQryQQ5B7PjuqJEyRxz
	NTt+kq0k2MPLJkPGDLZm0lErfDMrjDFhYwr2Pfa3Zc0WeislTdf3CiXT+o5IOOPlq07Xa6ZWIBx
	so3rmLt2pjHxO8FWbMjG/uxHFSYy4VndMKbuQeaBvd3Q5IO/fHVN/0mWV4RbgpRHUKB6gAFUSBg
	8dfVWhjDmvwCNWS1na4d9295Q==
X-Received: by 2002:a17:90b:1d46:b0:3a4:cfc2:3517 with SMTP id 98e67ed59e1d1-3a4d1b5dee4mr1371166a91.49.1790777270839;
        Wed, 30 Sep 2026 07:07:50 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.07.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:07:50 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 04/12] mm/sparse-vmemmap: open-code init_compound_tail()
Date: Wed, 30 Sep 2026 22:06:19 +0800
Message-ID: <20260930140627.57431-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8izd5mn7zqfw4s8ohx1hm4iznj1fw4fs
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 73C5640006
X-HE-Tag: 1790777272-803339
X-HE-Meta: U2FsdGVkX18s7/G8VBp4DWGvIbEuMQ1sQOJqaoPSFI3ZnT5W9+UNsQI34g+DMYQgYNtGdCnUvvN//Q9IRhLovUhhMu40jdppW1s4ouf5pjOqhc6uYALFNbkBntyNgPI1UrneXUcoOWmV1+NyL5MQY6Dt6uJkepA0dOua+BzvyFwYssJQVafM4hq4NvabWIqebtkQVDOvowZz9fuU5ESc1fwSPVsUlj6euLjRXZuxSOOVX7hKZEqfx6YGPotdDN07z9aJAe05dd4uSXeqBECXyi6Tl/j0oM1gmTnhXpaaWlberp7EPGwzBFwjz7YaJ+AwBVTW32rABkm7t6cp3tLpunoviKpUReWACo5uhL+hIkwdPtj6X6C0afrb9oHTBz362ag5wQoZfozmE1S4IBH6/33o5X18RfWcInCCs7tB9ZncSDjB6hN6ghh9hADj3j65peKkBOMBgyL72Fbj8dfAcxEkFnEtagYUxlmjJpjpWO6Z5gWVolP06Q44kJjpet7XLMWMQthng5klfUNDhaBPQSETe6TVoYC6s2bumYDrhUfGhD1W1833tirhTaDO6qt/Qt/uxcAmyYuQ93aDZPs5+QGSPnYnc8Yg9Rm/iga70hzmfOOwIqz/67ac4qR7YkO75xPyFyHTsOVlrmjLgwox2DrVbkcs18sNp6TAY5njjVwh6IFPIVMkGM9khnA3d16UZiKGIMkCw6S5mJVoD2X4e9QQzb0uQhDfM3GNkJK5jCV5DageRmVEnDT9IDLTOdvHf+WAhIqlRQSTGpnIn6jSU/IJiPTU3aO7A7Tc8hekULXUZ2IgnFSWci9oWJD8+kqcIY/h4YE1+7Kt49IVXZiogPZsJsJg6hzv7QFsSMEfA8QQKAzecy9Ug0VM0QuZez3ve8zlYuMo5UI95Ao2ouZqOiSu7F1IP5JnPDpta70r8dsBmYjNjGWTVPRLIg3dFpPb7bm67xmanbxTdCBaYZV
 4IIbknyg
 EFVSQd79Evx11v1Tpn6ULz9W62cPYvOMbD4ggWM/hFV0GBssWv7QSjQ/ydkSjwXEVjxkRHSFUDDAgKitDclUFGqtTFTZLMWAP/VbiwHhbrE3MQOia3nZPo7zYOrxe9L8fVUh/eAdi2vYccyt8YG7lpun01WDcyoP/S8syQtUENPuJT7ETLiNWPPF0JMDfiUXiVwhNYWHIOIXcru/cXFm7uSvmchYQQc8QxlVIEkH16+XRGH8pgfQB1WLpD4b+XDAjcm9muMb2pF9tuE0Bwsd5Udd21ir/0w9714pifozOtS9uDMHHCCLR9RV/Vy9qpVTx9zHalt9i9Dmjg6B6TK6OrBpQ5XYqyoyy+34A00+1IxzGUDUbxbWthFkD+UFB0YKxGEv3Gof2vjeq8SfSPLq+X2ccer7tRJrpY+w5Dc7yoCExkTMVJh2+/PDHTm6nra1fUnmGcKAGQIWcE5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

init_compound_tail() is only used by vmemmap_shared_tail_page(), where
the shared tail page setup intentionally passes NULL as the compound head.

Keeping this helper in mm/internal.h exposes that special case to the rest
of the MM code and can make the NULL head argument look generally valid.
Open-code the initialization at the only call site so the special-case use
stays local to sparse vmemmap optimization.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v4:
- Collect Acked-by from Mike Rapoport

v3:
- Collect Acked-by from David Hildenbrand

v2:
- Collect Acked-by from Qi Zheng
---
 mm/internal.h       | 9 ---------
 mm/sparse-vmemmap.c | 5 ++++-
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index da14c56fb24e..0dca33db068f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -786,15 +786,6 @@ static inline void prep_compound_tail(struct page *tail,
 	VM_WARN_ON_ONCE(tail->private);
 }
 
-static inline void init_compound_tail(struct page *tail,
-		const struct page *head, unsigned int order, struct zone *zone)
-{
-	atomic_set(&tail->_mapcount, -1);
-	set_page_node(tail, zone_to_nid(zone));
-	set_page_zone(tail, zone_idx(zone));
-	prep_compound_tail(tail, head, order);
-}
-
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6916a3690778..f77e6e1e5a8b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -221,7 +221,10 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
 		page = (struct page *)addr + i;
 		mm_zero_struct_page(page);
-		init_compound_tail(page, NULL, order, zone);
+		atomic_set(&page->_mapcount, -1);
+		set_page_node(page, zone_to_nid(zone));
+		set_page_zone(page, zone_idx(zone));
+		prep_compound_tail(page, NULL, order);
 	}
 
 	page = virt_to_page(addr);
-- 
2.54.0


