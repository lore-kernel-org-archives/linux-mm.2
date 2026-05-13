Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C93FCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128906B0115; Wed, 13 May 2026 09:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FFEF6B0117; Wed, 13 May 2026 09:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015766B0118; Wed, 13 May 2026 09:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E181D6B0115
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:22:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99CE71A0108
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:54 +0000 (UTC)
X-FDA: 84762461868.12.086310E
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8141080012
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Bd96pEVJ;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+xjNGO48cR5AqDS1JugnvXgVXjO+vzOT6RKvB10/GY=;
	b=ueA4rwlJLud/oRVBvgUliFHoy/KtCzpPFQ2kJDP7XADEsRKKjNH3yBPP49YiYJ2tBJvlLJ
	ysBrRkF9RRKbDARmgqGLYMYfbc/5qXmooOFFsnp0409UmAReMWsbZJnC10rYiKjAriRemU
	em8dzAwtVD3mn/++iKfdUYhERlJNL7M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Bd96pEVJ;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678572; a=rsa-sha256;
	cv=none;
	b=iuOLBZltbhO/N8YE/MmdKl1dhXwkUMiox3gmvrm5BcZIM9VuhiEovvqF7oKW8UI03wg+kh
	zPXbiQZ+Tg6OmlipSKvasXTDekIum/2DELZZ4tD2QZ5Ogh7VrRiWoNzNgXmfwME8tWe/2y
	bjPOkiwDxlEuzyWX2CR6rOC5jFTdhcs=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-367c2a39fcfso2513292a91.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678571; x=1779283371; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+xjNGO48cR5AqDS1JugnvXgVXjO+vzOT6RKvB10/GY=;
        b=Bd96pEVJ7xJjKE7h6m3RA+pYdms34Rpczxom1T6B4n+ee9QR7LrE/fuKPS7XglmdEZ
         ZLenMGEZ9O2favBqLc3FiZXdZCv5JLDmMiO6ORVMEHqRE8KkBqcCJmLOeBlu4hSYwO74
         Z5lbk3gSRWqK0CBTaTrMJNaiKxURmBoydSCda/mvdR5VBZwJIFNGU9rf252oe+HrnkPC
         e6Y+CogXc/5FBxrHptI4SIAt/86WoxdJIiJiEx4jFifonXZYGJgI5w5Ge9fvMUfd7plI
         bGJTfpKQfCiO01BggeNBQPDRwFG3JG1KXf3RgWCkCdknUl9bfsL+Pw93xtx+clqXXNCj
         JkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678571; x=1779283371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z+xjNGO48cR5AqDS1JugnvXgVXjO+vzOT6RKvB10/GY=;
        b=p623m0e4dCPtzugz6hf7hWRqxwaP8AW29CQ/vT4O9kERrifMCaQAMxb/kP5B3MmaUR
         97Rp/fKgxiIgCSUYo5VEmlUASMN0OKWPk9YUfYTIac2ssG0yGI/EEg1rsUXT5OAwEy7c
         usJCYz+Cm3XMU5uWOZXo4DOZsPWBwHtvKAQuB3VMce+SCyluo5a7S/xRZ876E8LqGwgI
         tk1hFivP6OiEHpje8KY1vafFBX9qwWPrVtTLfSIXSXgj4iar39BouarupYtC7LYJLMcp
         jZiPKJe/5gwmbxDfOmuI5Hd4qRC57T9hADEwl7WdywPuBS9yk9J6tOAZ7H6ir7HKH5ul
         4h8w==
X-Forwarded-Encrypted: i=1; AFNElJ/8zPZIFnn2E3sIcVLygXHpgn2Qq/yE+LbHLqG2G6s5u8a/2BMgjdo2S57RLT6llg5g/z5QJ4mpuw==@kvack.org
X-Gm-Message-State: AOJu0Yxh3DwWofPmPFFMG9xv37QckIYlLboEqKnvjARPbgmyTCgSpKBS
	14ij6UMy4woF4C/Y67LUBZX7SV4O3tjkzW6urzaLPNq2TzmaC4i2IEEi1nPLVZq55YM=
X-Gm-Gg: Acq92OH9cvexTHELDBRpxJmE32mqDk1k78k1neypkT2XKYLYX0qUvIetFruJKqxmoh2
	u/shB5y7yHxGUgHqiWvx5ovnmEXCdXmWbPXdpr3SC22e9+eZ6mEvU/qbsUok1mRtxuLLnoAv3rb
	0ENHz4jsfL0J7DaM9mZjyaZy0xLvc24i4dACq5tSGapg6y9E7xq66u8zDkzAm3BvWTbDDa+65l6
	cnUHZFV2QXPx94Z9I2XEU9AUB/7CtRL1JXNR09ggKw1GWQ59icHpdWuIkGqYIDOgpE239J/BuaO
	3IfQd+szs8V+PYrosmcp7LyGi/MP+0lFcgcb0LdigDqnIJJ3t2VQT7qy4ni2j8tKoWctyoB6CCt
	yyzRf/JMw9unMTl40RjINTtvCUr+EPB1o5DjFiE0IFsirDDz6VVlb1RRYbxYIhtJfEUfZUgMNgW
	4zedM5pMcOGN89yjeK02wXiNkJMjTntjsbYpex9eYZz698yU8dsSCMYSRRZm0n
X-Received: by 2002:a17:90b:574f:b0:368:6159:980c with SMTP id 98e67ed59e1d1-368f79b61camr2563736a91.20.1778678571207;
        Wed, 13 May 2026 06:22:51 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.22.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:22:50 -0700 (PDT)
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
Subject: [PATCH v2 65/69] mm/mm_init: Make __init_single_page() static
Date: Wed, 13 May 2026 21:20:30 +0800
Message-ID: <20260513132044.41690-19-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8141080012
X-Rspamd-Server: rspam06
X-Stat-Signature: 8u618inefn8zd5uffsgxye8qb6m3ff77
X-HE-Tag: 1778678572-594198
X-HE-Meta: U2FsdGVkX1+GI0TGuWlWS1E7gGv4aAhV3EU5YjD8qpVrT1XEVM6VM7IaW7WYQxEnugrLw0riVuPfHeIOIVDApzmNIl4dAnqLD1voe/sS5X0A+4uws3bHM6CnOi60eCtwxsTdZ51TjdRhDWPAbkyZ+j8GuJLnlFBCO/F1h0gen7nfpxnqiSOk4xKJARyspCKOB/AWbxpwatS1JL4tVCGbsEaM69yuA0rSg3pDe2NmDpMFfgCtgdazf9Tra6s6ucru+lG1ZthcbZASWC0KjwnKr9AozTNCv7UXlewdbWMSzOqTz0Wj//edQyUcIQRfuICnjStjNcX+lsJ+OA1maP2fkLrBVWZpDGxs2pamgS7q2y4bcCfqgVhQNdmOkJjqKPUbZvZyBJGRDXqXxb2+j7+BMA3g3aZWr7f1LnDrkOYmKjfjcwHIzwyzsZwZF+oAEi5KyL17zFtD8aWD8Ivd49nUPWm4qHzjeXOYdkcAgex9WqZXcU9D9psvm2QyT/egVJHhU3/TUAzdcDbuNXqzARDp49JdMr30Wb3CwwX58BxAu8Zcku3vjQtIHe5Ng+YMgGVMcw2ahWm7vNQAsdxdDcIqCm7sX+AN7anHk/7Qb9+5mJwgwgyoY4ap7+DDvNYmgwazrV6nCcUBZY88cucjf7ebsFc5ZunQ0ZARwJjZF3G571iUwiwP9fT3hIIvQIXCQvPSgJmQCL7UL9tgPKpL/opoxBkdYcYPcLetPe9n9U5QBNBBu+V7fdQXj4kHNXunpeHebonOFEU7nAmPl7fZUfd734fnAmzMIQJsQ91jzljQnK8uO56IWzpqt07VKDxBFmyTjuf1XA1D/hwzuyDDx3miKJ5/CEeRzrsHIdr+i0xMFyNkSaVcxE06fqPmh1u8gwnSfdGHYdHSDQn9h2gQvTSwNXD/EGLM2hpZ/qMimz68nA9UQSGmREgngR5VaVyIVRYZrxBy/joFhzOh+HsM3C4
 3a4uRDam
 VxoPTrqiyWk84cfIhUd0ck7t8S7wz+/DNzX0+kRgZ2ejuq1zgK4ZaH6jplt0Z8xJ9FnXV/tm2YdfXlmHsVGzwCm3YzXbJAfK5dEwkZwTW/BXfLDmeiXjOaZKGlydk5QK3DPOP4FwO0cVEIpvTlRiJXwP1s58NLzTqNEEYXNTEp0fLLgZFyCuxj4wa6kC10AfLC3KLqZ1Q37rG0dWx4JN88r9wcfFWm5qoUoP2z+7AFJOIfBlnrOg7RxCnz7qoUTddLqWXBrYgSyUnskX0ndiPU2ljTF+f6HrdNYxf5IjpnhLG4D0r65LbV9Mz/1bFebwbQtdMfo0aXat1UXMfo32EulZgd1cUazqgWOxsimgGxXi9kgE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__init_single_page() is only used within mm/mm_init.c, so make it
static.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h | 2 --
 mm/mm_init.c  | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 2c67ae25124b..80b9ab594dc5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1791,8 +1791,6 @@ static inline bool pte_needs_soft_dirty_wp(struct vm_area_struct *vma, pte_t pte
 	return vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte);
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid);
 void __meminit memmap_init_compound_page_frozen(struct page *head, unsigned long pfn,
 		enum zone_type zone, int nid, unsigned int order);
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 9b23c31db8c6..1e11fd683292 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -589,7 +589,7 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 	node_states[N_MEMORY] = saved_node_state;
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
+static void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid)
 {
 	mm_zero_struct_page(page);
-- 
2.54.0


