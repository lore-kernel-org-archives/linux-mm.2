Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA9F9CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7A86B0092; Wed, 13 May 2026 09:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A7B36B0093; Wed, 13 May 2026 09:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE096B0095; Wed, 13 May 2026 09:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 193616B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:07:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB7111C066D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:07:52 +0000 (UTC)
X-FDA: 84762423984.08.3E83DBA
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id D87B24000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:07:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="OaUStTv/";
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+0ze7EIzQ8zDlwa2Xdpv+yLCfHzqyRtA/0pp8bbhmY=;
	b=i6V0FvwFalHjzbP8QjiITlKR9/Ggry+B8wwFAjh6mDNRMugQcMeWFRCBv0Y05z9VZMuGlD
	rB7C4YFGmQM4pJSQzHRMXmEBXchzsfiCQlzK23GZZ02oF+VY4UyJ5MqSfdaag9R5uRNKaT
	Eyg4XNKxoHVaA09dwggsic/nl51d2so=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677670; a=rsa-sha256;
	cv=none;
	b=VmEbCnfUGOT8YdL31nGZ+suO/GnMbvRBS4FAPD+SXKcjUFw9MOPP2MfMySwLvbW3TogOtG
	DFM/NKj5ib+j9p03wcIVaq8TtFO8WZC4W+sK4779ToXgGJ26KyGABIMuKRujFN7BKct5Oi
	3+H2b75W19/wiQI3rvD6AM4mX3hMw24=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="OaUStTv/";
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3680540a6efso2513488a91.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677670; x=1779282470; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W+0ze7EIzQ8zDlwa2Xdpv+yLCfHzqyRtA/0pp8bbhmY=;
        b=OaUStTv/HwOM2BqVDZ8GE9N8o4Po3rn5jmzUuNoF9tFWebnHoN196sabV2THVnEH2i
         th8Gi3StUEKScyjctwsYbAdxIa8HuLM8Ac5Bh3hd68mMa75wAx0aHjup8QoZAKFYr/E/
         hWQk2YK1z1vmneg/+XWP5eaSzYabCrprMqfy201SkAH0Aay7C3YBpwcxu5mPtBD8SeNK
         z5iDwvFAGkI6hNspMfFoWHBm0sW9nvb2GNg3daTsx3i6cJmS9VuDBTIxw6qTx/K56XGH
         LZkl0jORNS4nQzxyr4WsYhq3RS9jjWcqlOC8oGLu5kyNIbyYoq0y48KitaqG7h0sK0tk
         jVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677670; x=1779282470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W+0ze7EIzQ8zDlwa2Xdpv+yLCfHzqyRtA/0pp8bbhmY=;
        b=G4f6ehqy82MhEOVbJqAfPy1VxfNm/dAtDBOz/YB5wlu9NVocLR4Zc8UKU1DyPjTYM3
         3WjaeauGVJMDDnIq8m8bwll/ZFAqn82sCC12BtbJRBm0F+07dea/Jdn8cWa+8QZdjPFa
         L5C5xCFEqZTxSLjoFUdDAJKABUzwv3tdXgdbNzV8tv04SGAAYxjFGYTrbmNyCxOjms+b
         YKv154O9JpVQJuJT2tzkBp58MVaR8exQecT+4Kigzt2ADtaS2VLJLN96YJhhSH/ZtcC9
         dwqqdDvs2HZWYtwTPQa2pHg2P09OP4ELOdM4xg3SScUvBHMHrFgcMTVVZ9HqX7RozB4z
         hUuA==
X-Forwarded-Encrypted: i=1; AFNElJ82RcVo7bL8KgZr3OJ9fip+Ff1ucC87snZMaA+VV9GC84knQAxG4Wq9imi6NPQz50nlxkL0qlGuAQ==@kvack.org
X-Gm-Message-State: AOJu0Yz9MlNtPTigPqUpdsHmtiDopDQ/rkiXz+HfJhB30Ml3aDIyRJGb
	BtM/YEqf2NJQNNekU+4hZeT+uJpWpAY/4JJnYlcVIwQgzIhEKmwuxn/JLUfVwwh1LSo=
X-Gm-Gg: Acq92OFcSd2QCOHuWGW/1nkP+zarbndyGUgHQAlf2yJNBQ3vKLSui3JsPPNxKXDbXFO
	eogXGB/NhBoAd98CDOKn7QB3DGeZh2qr8zv6V43vPlWYIqiec2tnorGMPFd7otuGm2DKVq78Pcm
	Kc5Tr762mYtAKyQXz7YBoHrFZdO9qn62L9ttLILGJh5dFVA2k3XG27u+YTQXIrDqP02nJnSsaXf
	oeCa1Eg4Fkk60eY+NY8JZGtQOfKs2xL4wlan5kUhXR2YckE+wDMOOVnuo6W5nFv91kmNLTGJ6N3
	E442A7Nj8rLZzgVoT205sYiBHPg/h/jDv5/xYjgTgYKSYMfY0l/je7gWBkP6D9gvmW2laOvZeYT
	xzcQXXrK2Ti/Zhhadx4dgu+8uC0JvrgQ5gDsB33G4TAIycsuCaIdZEYDILKbgjOFm4ZTIoTDeb7
	LKQJJYCBEhJIordNukWYGCrLzN+kwbCSko/jnTxHaa3nmBH5zpQf/V/pwDxvc/8oX/xueq+A==
X-Received: by 2002:a17:90b:3f8c:b0:368:ed92:6f5 with SMTP id 98e67ed59e1d1-368f77f6980mr2850344a91.4.1778677669469;
        Wed, 13 May 2026 06:07:49 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.07.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:07:49 -0700 (PDT)
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
Subject: [PATCH v2 03/69] powerpc/mm: Fix wrong addr_pfn tracking in compound vmemmap population
Date: Wed, 13 May 2026 21:04:31 +0800
Message-ID: <20260513130542.35604-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D87B24000B
X-Stat-Signature: ccyn1p6gbeztdi843yq1se3kmwo5u1mr
X-Rspam-User: 
X-HE-Tag: 1778677670-337044
X-HE-Meta: U2FsdGVkX18lher7QL+6SkuNk4L/o0qv9EZqPXZejFDm+lEBRuZgVjMUJK/LaUEr6s2fyRiqVipNesn7ovC+QSceOUU6Cy25png7d/mZ/rHC3gJjoDTiDEVR/oSx5RQ3E9bII/ptn4WbVgzN637uZIiBQi5Oeb/V3braYjdORebEB995vFiTK4ymD9pG9GSJAVv0Ab0EUtfF2zweACFt9NpqebrXEdgaLpDRuILt9QtFAKerEY0AGtdyo9hJQw0qdzRiA6wrGUHjFwhuUZnHdJFEI8lAOd+pb103UN+JX6avDDmKTSztdsCLGemlBDBUbrEfN6ZgNE3MIKG24BvVm5Se0c5A/sWh+HGmDN5DcpZv3Ch3c+Ka0A9up9MLpop/7g0pEGI0zicARiJP677OwJz9nZaqluH1iypzJdsX9NrZDXJomujOcMahZw4tL6wWExuXUT7O9ZJianQniSfN4dHUvpdWpufMPByc3DJa4ZsWjw28BXSni9hphG9DiJHhFo+T73dICVFXGoGMzwRtrIMaLi974Qred/asDSm/7EvI/VZY6KVqPAtdfrtzo9cD1osrhZ2boRt4KIlX9k2EE8zC9SpFOSXpw0O5VHaJR2j6GyzYS4HKv+Oj4Q3wVynjHDai0coarrOa+jTXkFrYRRhRAFMz/lOTuhKsbGHYhLsdrhgw3qSRhAKR/KqizKavsT2tg+ImQiX1j3/YJgbRyPrniCBI5CoxXo20p8DF7/x3Umr1Mva+cWewDzYjr+7v/mvAgywPj0zteHNGVe3NHlnKiCCxgNULRH36gCHDEiJJ7vDgd96wmwC45origE6qB4En8zmoeay9WKa+YYu9+QPBXP+729WOgGkDiVhqBFCQhB+6wk8SV3o907GeUPORDaC9LompU1SRAoTtHAqG/vuum5VLb11aYAoMLgjnKRE2fTr4f2hucTzpIm5JYaEuU8Zs+arNYbfeX6bMeuF
 22C0APUG
 fw27INNCvq5KgcVnnUM0sNxISOqxl0uFQ3Wd+7ZrVp1esphhXAX8dbpeKl0xBGLiS6B0FCrUhf8X29rMO5x8RZw8Z4/3ZMwICbqth9BtUl3kkIDf5n6ynbEYZxMSLTwwE+yMxoGjDsLBbncJubCQzcqFPTYZwAhgkzOFMmG9xrHjmYqr8rIidQ5366DpIXMDV3ADQldUYQ6yy8EWz5KL93dLH/xl5WpoKIVhTx/Osq0LXUp7APGHoMWF4539nVeu0esmpwmAHzCkdIrA26rT37AxBQQH9Qb/av1KfcNHVb6QwDXL3dmCqvq6CZlRQYr3MQG/BlUQnxCgBrybLgSenD87iAHqx4s9ih7FP1enOsEtg9n4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_populate_compound_pages() uses addr_pfn to determine the PFN
offset within a compound page and to decide whether the current
vmemmap slot should be populated as a head page mapping or should reuse
a tail page mapping.

However, addr_pfn is advanced manually in parallel with addr.  The loop
itself progresses in vmemmap address space, so each PAGE_SIZE step in
addr covers PAGE_SIZE / sizeof(struct page) struct page slots.  Since
addr_pfn is compared against nr_pages in data-PFN units, it should
advance by the same number of PFNs.  The existing manual increments do
not match that and therefore do not reliably track the PFN
corresponding to the current addr.

As a result, pfn_offset can be computed from the wrong PFN and the code
can make the head/tail decision for the wrong compound-page position.

Fix this by deriving addr_pfn directly from the current vmemmap address
instead of carrying it as loop state.

Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 10aced261cff..cf692b2b5f7b 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1314,7 +1314,6 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	 * covering out both edges.
 	 */
 	unsigned long addr;
-	unsigned long addr_pfn = start_pfn;
 	unsigned long next;
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -1335,7 +1334,6 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 
 		if (pmd_leaf(READ_ONCE(*pmd))) {
 			/* existing huge mapping. Skip the range */
-			addr_pfn += (PMD_SIZE >> PAGE_SHIFT);
 			next = pmd_addr_end(addr, end);
 			continue;
 		}
@@ -1348,11 +1346,11 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			 * page whose VMEMMAP_RESERVE_NR pages were mapped and
 			 * this request fall in those pages.
 			 */
-			addr_pfn += 1;
 			next = addr + PAGE_SIZE;
 			continue;
 		} else {
 			unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
 			unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
 			pte_t *tail_page_pte;
 
@@ -1376,7 +1374,6 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 				if (!pte)
 					return -ENOMEM;
 
-				addr_pfn += 2;
 				next = addr + 2 * PAGE_SIZE;
 				continue;
 			}
@@ -1392,7 +1389,6 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					return -ENOMEM;
 				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 
-				addr_pfn += 1;
 				next = addr + PAGE_SIZE;
 				continue;
 			}
@@ -1402,7 +1398,6 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 				return -ENOMEM;
 			vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 
-			addr_pfn += 1;
 			next = addr + PAGE_SIZE;
 			continue;
 		}
-- 
2.54.0


