Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D7B9C55838
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 02:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1A156B007B; Tue,  4 Aug 2026 22:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCAEE6B0088; Tue,  4 Aug 2026 22:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0C96B008A; Tue,  4 Aug 2026 22:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88CA86B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:25:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 031BDA18CD
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:25:58 +0000 (UTC)
X-FDA: 85065625638.11.6A21F2D
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7DB6A140004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:25:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IcEcihZW;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785896757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gylrXA8dZHEkTigMCwezjCY5gprk9td+R+vUmKVGqHo=;
	b=Re6fHZIVHthgB8M6gUQBk4Nk4Rpr0nhwe288Ps7eCzyWjzfnwObHWof2ggQ9zrhd1T4Jac
	dQhu5k/AJVZLyC8DLkVEaDCUipNJ4l7jMpNA+y4uj+EUbQy3vCFb6Q6Wy35XHJSi6fYj/y
	Yc41aGnvI3Cx0s6gWd9BqQj1hAWh+OM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IcEcihZW;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785896757;
	b=ZBREI+noD60qjkw8HE0XneiKx6OgVeUG92h1vwOAxvpLrfVQCg0lnTWtW4YVnMhBpU8ivT
	MhLdA9/A3oPDyg47cKftK70hncxDqVQn61z5a4/cuRVmKFreD1y5Evcg07bbKy+v2cmsMK
	tcRqb+gnUq97az4WierYrg6x23rNmPU=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so479233a12.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 19:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785896755; x=1786501555; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gylrXA8dZHEkTigMCwezjCY5gprk9td+R+vUmKVGqHo=;
        b=IcEcihZW0zQegt3bkrpD7Z+wyQoBzvK5FpnRKDGUENUmcfMZtb6o1yV9Bl/OwB+DYU
         O0KvWTk6CvEmqqTKanBNEV56u32FVwQMAfIF7CT1LnktvAbBGXIuonWN63J2fUzEXkOw
         iYsQec+Oa3RbRl9OunRWbv/4pj/FlBCIxd4xYrpJU3jNI2TZrlPIVBvhHSEZ4X08sCYh
         Ud16g3Wh2o1iSFaiVOIAGqZyHdstTgqNtCF0HDe3AamuvsTVhYHTNRIdSL/zzI6AASA6
         kKe1rC9fx6lmVUwY5tVNh9jMYFPkTClHJJDWjYQntqnptkiiSkaLxBRkw95cxDkIIxSM
         YIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785896755; x=1786501555;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gylrXA8dZHEkTigMCwezjCY5gprk9td+R+vUmKVGqHo=;
        b=XlkDzOCPm+tZh803SnCeq3QKHysb69QvdqXHfJD4dD7SVrwYqnA6vgaFWJNas/ae4C
         BgxecFh89OczOb/1/WOtRXMKxdtO6q/R1/dJdJ7/EILaRxxDuzQ8tlviveOjkBwmAmGN
         bpP3HAs7+HLVIs6IOHcrK+mBVXEcFVNeZYO/iLUHa6YcqWknbsSIU2Vx+03nsJjiRng5
         nXou0ol6LuvacZyvB4K59aNJogkbOE4rL2VxYnn8xVCZKliOI0H8Ea24UXk6LdCIOxfH
         Y4ea/becCfmjeIgdDxPPK/yYOkplOhR+xy028eQQTaDiSx+cvHmtHsdXaZYHGgzlHpex
         V0wQ==
X-Forwarded-Encrypted: i=1; AHgh+RqIjdpUIgHSsMNlLuNE4K6XuSFrAt8GF8WvaLVO2yi6TIDJliEe/R4Fij8OfehSWC9Bky0cXBbWug==@kvack.org
X-Gm-Message-State: AOJu0YwTozsnUDYbYOUloOENshdwsQfpprWm9ljENY5HobeQH2fmYNSN
	OZV+ukbf1fv6jB71rd0o8WN67g/lt3QFToRbsdEaavuw/7ktmpnj1HgNY5tl5RbXHpM=
X-Gm-Gg: AR+sD11P3+QD6MVFGoT3+2qd7Y3OhSZHK0rLAWqYBjBkvj0K3zN8tjz6rvJHkoAWDNX
	zSXv0EWJaGW3yBpVIn+cmrhOTrEM0k7+Fqp2MeYfckr6eH8XW2h+mtuzm9pnq9qCZrooyAYQuKj
	g7GgPBdWXJRs/b0TsUghVxV8Isksgx0riT7wzYEBfrZXTKoL/AyCk2XWZnqICrbdWvn5OwwqhNu
	3Q+kxmD/q/SbOnhFGRTVJ9C1ZdQpczEY2BzN258vPyAGryNhfX7PAKzPv6CtSsUIKMF8Z+xBCce
	R458a8voHgmwJo8Hz17saQrsVTrBYxqVPLhgBQr6Z8ggn7iK+7px94NlDwZaoEFjJyWEfxtE06D
	8z1KqGUryexb6VwAtRUBoxv6mkKkFQKvYwHCX45rKOb4mob3yybqn0wUCWyA7D/VhjDn6ROh2zG
	bakxiUyk6LIvoDRsIHB85GvKKr+nbZ80lw4DnMKcy2H/VSAN/KqlWqjzgnMWDfus7KjZBCT7EXs
	pZT3qST9A==
X-Received: by 2002:a05:6a00:1821:b0:84f:21ba:54e9 with SMTP id d2e1a72fcca58-84f2e0dbe2cmr3481771b3a.38.1785896755037;
        Tue, 04 Aug 2026 19:25:55 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f2e52e28fsm337769b3a.53.2026.08.04.19.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 19:25:54 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v2] mm/sparse: keep mem_section_usage_size() internal
Date: Wed,  5 Aug 2026 10:25:36 +0800
Message-ID: <20260805022536.1206575-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: w9z9nuuba3sa1sewtuns68gss7hu4m9e
X-Rspamd-Queue-Id: 7DB6A140004
X-HE-Tag: 1785896756-972236
X-HE-Meta: U2FsdGVkX1/yT3qers+Kxmo6VvXfm2JWSkR81P/N02OfAd7SXyK5ta4T/B2a0yRFbVB75gzfuavWikGPZDydmOMmR91Wxd+wbLxpQkd/tZvwceY170Cc8rxVc/BViadDOJlwBysRjy2r5QBCGmL5lAO9qxHAOsdchSjPh6Y5Iaxcpd4C9tQ/wBs8TeF+4Hu5+5T6STMr6UrzPtGHiFciEw9jyqs1q5FoIih+/o3SlgIpH1k8ZFhfFGKqf2mknKu2onfXSUaenjbev9+hQUKyUw1oodftQ2dF2QXbAxoECqio7ATp1vW5qr3eZQY2iAUlkFChtBfStK2ngRELXLMT2Ohzwh2MAOuGLGBOjd6N7mWriPlg6GtjKL2JW+tvAU5voNizFuHXMZYdMZ7zRNSVrRbS6/2UDHoCsWCRrF36U7UbFyCT/S6jjm8PObZU7Lzzv+m6B6iGaRllRwSbX12awcafyQbFpxDpO3ik94YWV/0WJigkx2IXVzey91l+E+0pnBPCPzv4H5VycEY98GZ1DBX+ZMcRxSaYUc2Ue2nfBmfY2pxgakWLqmMmgfqrunLJEW4UO/pkvS45qq6EjwLSAUlTJC7FjB/CxxbGu6TAmCNbcIaDLeDFKFkqqucbWKcEt9fuM9TzO+4TD7c+VSOPcgVcjUMsp3vTCpWLbtERjN2dkTQFa6hTcyDFdyZqT1VCI2jkinpvhuWmLwzKnDtq9UtEJQ0CGSIyein6qZ/oBduLnzEvaWMunjkRQPdWB15sxtv4JFWoDu9VCerGHBmGKujCvHan2gbqJ0Z0JlV7RMQp6ExTEv4AkTZmdqUmuJdzdCAmxAn6ak1Y5vE2UQzbB+1PzIQUjsnbcPLub7+vkyIkcdZWCqHvl4I/BmgNpcUY+riBDdTfVk7l3PP04O8ZorjdTiHT4ISDOMKmo+ED9y7E1sBD2oIUADoItyIjnRAzBIkdfgDWZN8OsnTLBC5
 AXbJ6Fwj
 K3pHMf9GDR/uj2pm1wCbbMWKaPuVsJz4+O1c0dEsYUE9rZf+nFV9GWwnT0ZAsl18vnVG4oTZjhjYwjz+nOuJkSt8H4bC6HpdxxMmCjfISCWVSQLjX7t439nryHZaFdyQyPVeGpyfgkdGfsKP4iKjy9Lz4UcnKO4aE3pmE4s6US2xc9Wa9CI6eimMOEwWLtNy1nDFuEF78hM8YSSima6f2+7P4D2zX+lfjTBtEHOB+TwOxw8jJAK2kr+k0hrTy6X9p33HPi3szqZv5K8Q0T4yEx9jpFRX+bcBIIG250D2098eJBwCf1fXbtYP/4QlgYtU/svZNPrhyFoaT9Lgrx+dfTDLedbIi+Fc9l4sLQxDpR/sB0Ts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_section_usage_size() is only needed by sparsemem implementation code
after commit ae751d567baa ("mm/bootmem_info: stop marking mem_section_usage
as MIX_SECTION_INFO"), so keeping the declaration in mmzone.h now exposes
the helper to all mmzone.h users for no reason.

Move the helper to sparse.h so sparse.c and sparse-vmemmap.c can share it
through the internal header. While doing so, calculate the allocation size
with struct_size_t(), which ties the expression to the pageblock_flags
trailing array instead of open-coding the struct header plus bitmap size.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Mention that ae751d567baa removed the last external user (David)
- Use struct_size_t() for the mem_section_usage size calculation (David)
---
 include/linux/mmzone.h |  1 -
 mm/sparse.c            | 10 ----------
 mm/sparse.h            |  6 ++++++
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a26c8b855222..86891163e0ef 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2070,7 +2070,6 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
 #endif
 	return &mem_section[root][nr & SECTION_ROOT_MASK];
 }
-extern size_t mem_section_usage_size(void);
 
 /*
  * We use the lower bits of the mem_map pointer to store a little bit of
diff --git a/mm/sparse.c b/mm/sparse.c
index 704a9dec2b9a..46458e5300e2 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -213,16 +213,6 @@ static void __init memblocks_present(void)
 		memory_present(nid, start, end);
 }
 
-static unsigned long usemap_size(void)
-{
-	return BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS) * sizeof(unsigned long);
-}
-
-size_t mem_section_usage_size(void)
-{
-	return sizeof(struct mem_section_usage) + usemap_size();
-}
-
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 unsigned long __init section_map_size(void)
 {
diff --git a/mm/sparse.h b/mm/sparse.h
index 95aa031213f2..3b744667a7e6 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -47,6 +47,12 @@ static inline void __section_mark_present(struct mem_section *ms,
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
+
+static inline size_t mem_section_usage_size(void)
+{
+	return struct_size_t(struct mem_section_usage, pageblock_flags,
+			     BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS));
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
-- 
2.54.0


