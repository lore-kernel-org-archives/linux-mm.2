Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FAB5CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A2AB6B00EE; Wed, 13 May 2026 09:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A2F6B00F0; Wed, 13 May 2026 09:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 890966B00F1; Wed, 13 May 2026 09:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B92A6B00EE
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:11:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49C53120109
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:49 +0000 (UTC)
X-FDA: 84762433938.21.C6BD143
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6AE82140003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QQapp4I+;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+OzHiBv3aopKwtOQIdTMG6i3QI+K667v1klhZuAIPI=;
	b=UPtttD/nzuSxIHbOMIe2c6vy0htCX6TPywsCcwkm9dw5jVoUUW0cW65fEdgnx9nbkF5lKJ
	Avb9zgVYxttj9xDRRz7z37HD6axq4bdUCQH2KrheyBxKOy4ljrK+YisIJDEepL2W+a38ax
	lpZ//bD86ZZvowKZSkg72GnPtwvFOJI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677907; a=rsa-sha256;
	cv=none;
	b=x71ufV1W1/h5SVoRuiNFzMgULBeezhBlUbJwSEmIUW6zah4p4DNYFxzFMfzExulcruUnmL
	W6il4cLutL6ZceNCSxwByKq+vJSlVVpDAAQqr1BnL7MHdvI6X6NNLBvHrd1X9TBsTFoAMo
	aVvGLPLpupRcAMjbyFJKfh1BWAsdDmM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QQapp4I+;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3667cf0136fso4941278a91.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677906; x=1779282706; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j+OzHiBv3aopKwtOQIdTMG6i3QI+K667v1klhZuAIPI=;
        b=QQapp4I+yJRkDD+yczNvFQ74AEU3T/a7LS8jygp8itPGgMAbxGLegZdWJTldHFRlMy
         lpiC5LtTxEAlYjXGN5dDZImnVpo1fUUWu//W07/zdu/R1xgpqS+k61uzM08tzDVujp2l
         mno16Eh7a3e1kO11EfNs8KB/7D+e6BHIlYwqgY15uMbjYbfCsxVMInRp8zHJgO/UNNHu
         NemP4Qp4PskQxy9abTcC9QeMt5g8v2l4LgaiOZaozoTrsAju+4PN174LWYrOSzCBJXA2
         YCDTezMK4IYu7L3VRJDZSJZs2Ns2JZshQClHjEEkf9Kak49qatZN1b8QrCyBZXtBsVEg
         GuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677906; x=1779282706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j+OzHiBv3aopKwtOQIdTMG6i3QI+K667v1klhZuAIPI=;
        b=ACzFZ7Ap+CzSU17FPVlqXE6fDbuWsQxcsINJmhcW590bpnXasvWD6Oto7S8GecT/qA
         gCQmjcKu2tD/1HUivAniK2UVylIulethSsdKXWGJzC0a5yQUW6SD8yGCkgSX3OrLwSnw
         iHRv5xOgeHv/NQjFp/6bOadZK6Do06ch0SHjB92Nm7eHwbjWzdBOkjDUmhV1NeSPJsl2
         jaPpO8q7UN8jekFLcHAQvhl4PAKhMAlZQK1BDuZZB5KIRPSYvy79XCDU/JdFSvlCmhb9
         Y+H42GJhmkXEuuzbanjuLhmqSHhvLHRr39bjb0NokxMeuPndrOg2y0tdLaTFoXHkQZH/
         Qo7A==
X-Forwarded-Encrypted: i=1; AFNElJ8Vz4rNHC6yBzHvkok+U1DPsVHKDere/i9ds30mLzxW3LW6ooS3jm+z5UclKevFthCCmf0wlpr8TQ==@kvack.org
X-Gm-Message-State: AOJu0YyvacrBFJPzz6Tc/zLMxLkpfIaKjQzGuAiTU4zn5gHXHthVk01R
	4/ie3IxlwWawp+NSrgA4jCz9/ACzntVNIhRynC5GVXBhfFhfE5Yo1AfrJjmLGmk4lK0=
X-Gm-Gg: Acq92OFwFM0ZQaSVtfyw7HmSRW6A0gf3AI+WYFsNFHUJP5HCQNKNV9sxI2boWNvGv0k
	JHayySNihtil2WxPpIVysbAkB4axDXIKfK6oDWD33rVPR/uAKxf55OhS4/TRUmcSAk8WeOTuRia
	CWjMx5ciz8VIafW1+M5PDrVN/inwkcAw6r1gGihntMMr1/tiGubzq20JCwWxXgEIu4uoR9onp60
	4JwXNcmpCkHa8yz9Ky2uNaVpA0UpZb/TwU3fBZAEqJwS7Guhq/YCnEU9KmBFGHGyunhj3qwjvEn
	XWyaXgI/zZkuT+v910zO1WlR7QgWtFbw2Af3AENVZkWGI8zuszoNDw2ObyR/F+yNTGWIMn0PVX/
	G19WgzNuvOWL7F3vmUYmnS6R3zXCtuApgVjxhw7ZEtGONAk5Q9xpcDfwbitgS64pA8K7CGEUDKA
	Fk4Y+V45x49/uGGVpOpo08sXiwfQoHAIy3rYt9KWWOb6M/aTpbufrKtzB+82g=
X-Received: by 2002:a17:903:120a:b0:2b9:fb0b:b727 with SMTP id d9443c01a7336-2bd27714d46mr39411895ad.39.1778677905970;
        Wed, 13 May 2026 06:11:45 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.11.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:11:44 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 46/69] mm/sparse-vmemmap: Map shared vmemmap tail pages read-only
Date: Wed, 13 May 2026 21:05:14 +0800
Message-ID: <20260513130542.35604-47-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6AE82140003
X-Stat-Signature: xr9iemhjhi7d4ebzq4wgt94jxuhrg8k4
X-Rspam-User: 
X-HE-Tag: 1778677907-536889
X-HE-Meta: U2FsdGVkX19abOeoQoI4derULViPNufMNDL2G1cH1GxOLRRCv12uQg871gEM9UKkex7UxSJKI4Gbvnxv/gq2CSWtPOYMVjV5NUbrtm41ZP0vBVhjxv5/rh3GnqWZQrpJaiicRJYrs1IcCwdVpIrGcgSdR17SIRw684boDGKI3y7/B3Z/kU3LybCk2lCOiUAAAF6z+v1xh6ylYQByMD1HgCfbQIeQfiAhEd6wBx17YNGg1BTqhnACBd8lDlQsjBabaJqmsfIRant2waikbyd66EU26q5tF6FV+Vr/tnY21LdpeRhKcKJB8vBpx+s7uPIwyYdPuT6d0oAr+Pn2DhvKgOOFW4BK6abbW0pGihYVFLck8v4Et87orZjE/uVLb0ZJYPf3+7uutdZUcT2R7sEAkYQnmuODgzpz1qJX6tnMAH4YGye/3M5HNek0djMG9+uDpJNRNEOkcIH/jyKR9/dD+AilN1PEbZVpE2UmVDaahuuKjaYDezIDaU58Z5US97ynJo3PGgW6GrAFhC0EmsHvhmvM07lNRHaoaT8nBscHZWCoQOvIXbiam4QiOc0End6aXLEJ5xjIbwvod92kvv4mks+636fDAaVrzp3gtS6MhKzsZnnBy5dGEArNL8HHZ2LtsnUOXMLmNCq1xpBxGw5hX5gwol/kVQNirX6uJexzxtVjmoTZR9vnv28BNm2zCn2FDwLMwrKjLO0dXCzhCtSg/S4M+noO6GNB20daN4pZV8wqVw1ngu8v9wwEF0BmbgegB6mLrQXlpdopuB70yTVh11/8KErz+8v7fGGvggrl5Y9hH1Ha4jZY9/C19oc2Lipqm0wWy5NLoDg0EXtYb4j9aPusOJyE6OV+QPX4s2yoHEfS2donHqA/ODLtpFHmln7j5BTVlpO124xaoZOxQhzVG/VJlqfWJLZHwoHSk9i2jLNmZNermd8dwYxWT2soA9l8KCVZiek9fzTXIL8FkQZ
 tZAp2SBu
 i9Qg/a4gkR8e6v6dJsJ9H5Sa9vwMY0W8Ci5loAipzFjXVU8tNQU5ilFdS5fmuDEyOkljuKJ5nDQQC1TdXfoP65A2/CCarnC1EHXGHjU1/yjSXI0jU2S02YqmS5ODg3dwgsd5OnapELKMSLFgX9OT4U6QfK3zWxYx4t3u1JDW6CO4aRGo3YTJOxgBhQWSqd1qZqRldfoFuhuHG3xapIgdeEDuNuEPd6OTqgUpcoDn0C9UVDRDmb68RcLsuXljplDbA86N1MKIwUqHA68KSdEow6Ub1d2uN2MAX2fvZ+iYEO+O+3TzfXy4n2f69Fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shared vmemmap tail pages are now installed through
vmemmap_pte_populate().

Map those shared pages with PAGE_KERNEL_RO so writes to shared tail
vmemmap entries fault immediately instead of silently corrupting shared
metadata.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 182d0c7dd1e7..9811c92ad258 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -158,7 +158,8 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		if (slab_is_available())
 			get_page(page);
 
-		entry = pfn_pte(page_to_pfn(page), PAGE_KERNEL);
+		/* Map shared tail page read-only to catch illegal writes. */
+		entry = pfn_pte(page_to_pfn(page), PAGE_KERNEL_RO);
 	} else {
 		void *vaddr = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
-- 
2.54.0


