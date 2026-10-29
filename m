Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25D5F606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 22:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=k/rh7lhh
Received: by kanga.kvack.org (Postfix)
	id 366B16B00EF; Thu, 29 Oct 2026 18:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3177E6B05B1; Thu, 29 Oct 2026 18:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206A86B05B2; Thu, 29 Oct 2026 18:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED5C46B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:30:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E3F8140577
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:30:54 +0000 (UTC)
X-FDA: 85377110028.26.F78AE0D
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7CAFB12000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:30:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="k/rh7lhh";
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793313052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPY3X5uvq0LQlVSKfRxAerWA4F2Yg0A//1vEESl9I+c=;
	b=zM59k2SRB9FVn2UrF3KQj5fHzOgM/jgN497x+srAs2GQEbuJkXKbUBZdfYln2dYwAO9teB
	AEhGrOH6Gi6ptFDBV5SXGiXHX4i1bIy1A+g+mE2DDdD62SeaM4Is9FOmCFX9ojQBgD2YTW
	1aSP4eKGH8QSHHHrA6b4I9ZL12jHDck=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="k/rh7lhh";
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793313052;
	b=RmG3EytMksgZ47WJXilNidjz6gbrLpAo7G2UCXULUM9iWls/5q3zqv+RyQMNMZDIFV8iR7
	NjjFfabwQ3GgG+IXEDHS8Upa+WBxh2UYtHOObbCmvv4uuZiAk/TMkoPaLjfLvzKRdNtdYq
	ankdnmVYSpHkyXjnW4aZD0YZpoG+l4M=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-917a707f37eso1299836d6.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793313051; x=1793917851; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UPY3X5uvq0LQlVSKfRxAerWA4F2Yg0A//1vEESl9I+c=;
        b=k/rh7lhhEfAq5tIQkxWdi1Z4pCHcjoIMs7D0ldABGSktRf3HWBlctjv1t4nk8vyVvP
         SlaDk4b7RaEbulWZ/rBJFTuuwsHkHCiVSZV2wFmqHmR6rVrkgY65SQlnepaA6ofQx9X/
         XW8sGgdzf/i4vpWX20xMwIJwKMLQRfZBr1g5tB2BB8tFnKupSW623q6x3rCiiomFr9ZB
         eocj5yduhBKt0hBYKvNDFPa2R02UnnpnP6lixCgVapWCkW9Iaj88SLLJGfvT4J3LqNU+
         m0/kb/0S2JKBI5b+JsFgIS5OhD4MOy9g7HJMqKE9JndIQCjRWR202/1sA4t86TrdPRpj
         O2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793313051; x=1793917851;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UPY3X5uvq0LQlVSKfRxAerWA4F2Yg0A//1vEESl9I+c=;
        b=kzuyOPLiw/fj5bsUIGII0vjT1A7/6/Kcc4kyEdflwZsnbYXCJux4j/qFyBW01CGAsF
         xf4FjXED5cXgDUEbR7YEHrSTxYD4z7I9vzMlnVC5Elw74Kmsm2Q6fH0O00iy2S4FXtxE
         Dr63xiSLv0oTbaz0HUHGxVrN/SFI6REmV10aYonrAZ8LGA8jwcCBwkcdF+zQPDGngHwV
         kpN2E/A0uMjg+3pnCAtvMGbnDKrYGXp/DCpHfVS6B426flLT2tGhZyLJXF1pD1OXigWa
         +TrJdf+QauVctV41l/b27I8O6PMglyNqzoDvGEoLGRAGPlpquGfsFHBJZTebI77FRXm0
         QLyA==
X-Forwarded-Encrypted: i=1; AKwUvBxpuCc2JEOApd58rdVDyO4tXPAyVXzdicgrXmJptf9UBNQYRj5d4s8KIJT2T5CgqEd7havLr5cpGA==@kvack.org
X-Gm-Message-State: AFq9FYIEgbbDhEozXnHSKAP4fCSuk0WnbX5hM/PXyNSO2q14eNssOAG1
	hpIQiuSxV6h8u/XBjXbD8LvaNxzTnw3ZQn1vz3/7jGemoJxei/ux9z+s2onCT9DU3do=
X-Gm-Gg: AYBFou0dVo2KIVbjJDj+N4BNUUOXlOpI2JMg/Ke3TxvDw9rdVkvyazBKzCEnI13DWgG
	HnqadPCFcttsVqGOZDZyeZkAv8v1LCBmQMN70Jk288jb/5vgrBIS5Khi0NmzUICURic9Ntk75Pj
	5olVQUnJrynbJG7pB1ETg6SlLdp0U5cwOULiVydsTdxMaxbQVDdVyM/A2gBIlUjMLzp6HyHlHI3
	GWMtg6J6Ew2HNGaqzI9TBNK0shln4nXd4aNxfRg6857Hm9RcWkWK5/g4XVC2dltjfWLwwIvXSRW
	twfBlUlajol7IPQnHBP0Md4hTIap7cXkH2/yU/sR7E1kPXUbe1x2By8rzek5uy+OQH/5Qudi1hU
	lzw4xpS+GsFYZESKETEsVGxxRFbpT6XVLWPackykxkidUPrJXrzDVQey3jWpMKeuX5pW5ecLgiN
	RaUMTEf1HBy0QReZBoQc1nBnhV3FteiLhAGV1gv5P+jb6auLZ8P8DxqdB4FbA5FmGek3COjxmCD
	FrJ944tfqMHcV+oEpHX7WndBnD5X6/Lp0j+X9mQ/fIeZCDiKf5rnupyMjzG7rXUj/wNoLibNcQB
	/yJRwpXLT/86/TR1uvpuEj3UxX4mSa+B6m0izom9Z8vMHjSmkNxGKdvjlA0JWz4Vdt1fYoEdWwF
	6
X-Received: by 2002:a05:6214:5f10:b0:91b:8296:3b88 with SMTP id 6a1803df08f44-91ca4ae90b0mr5824286d6.15.1793313051262;
        Thu, 29 Oct 2026 15:30:51 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca68e5f47sm398016d6.42.2026.10.29.15.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 15:30:50 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 14/47] mm/huge_memory: fix zapping migration entries
 for device-private THPs
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org
In-Reply-To: <20261029-fixes_core-v2-14-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
 <20261029-fixes_core-v2-14-a64ce7f83abb@kernel.org>
Date: Thu, 29 Oct 2026 18:30:48 -0400
Message-Id: <179331304801.2127828.6570375349219520262.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 7CAFB12000A
X-Stat-Signature: n6g16q3b5rfbcx7fdt5qfj1racjhak8q
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793313052-748791
X-HE-Meta: U2FsdGVkX19DR1mXKKyz26QTizzvvAltzunqeivwOkhb9fUlMXnt2BByoHEZw5E8fJK73KSkbkPQiDzMQ7LRwZVL7KYquIlVSmY6NA4dhuyLGM158kVAqEVg4ujaZGNod2f0h9XZotOpPQCA9dUhoAnH60q9qBI+EhstHNc1dNnqR1kCxTF6JFKjEW+mP3+kR5gCyYjlSRYO92kcXWy3Qy2DHpZtbeh/SC/gB1cB/ICAWrFUwhKyuNvyt6XjGBuj2BFuNbpxD3kYbOz9rRcMY3xK7FdB1BnVf3w+2DBro0AKam0WpYY7SyppWNgvdpKq4SF6MMLrV7OgXdwEik9EYBDckuftI8Y+GWJTSf0LO17BRSR3UwgxFxEhec15Oa4/pldDqc4jhRw/eSuFXOT1ihtVqZOiHQVmmVGBS1a+qq/Y5cHTcW7WKykScc0YGlUpffla9p0QQLB16zlbTW4ykm5HV44BU1N2xrXWQhgtFHMT2VxY8S/+zh8adbrqL2ksTAbvQoDzOV/UbxnmYGKHA+e7daUEhWFtYDC6uIY3nXje084hCwCjcf4+7oNBykvAc/b+JhwjfLxV8C7kM22DDyeBU4dXaQY6GZlXfhxHh1Er/Z1k5s0LgDq0SaKyBD3nfxMVitG88Yoo/MbE/u9GD0v/fKX2uUbmyEDh4j/8Gj4O/28ZA+xHKoOPblj6h/a0ShBEuah/QL6yHaEerfj8D8Oi0fBLszqz5yV22omUWQoW/OXmwUtvMKHdsJQjvMWvQw4Ga25rcYSj6Ue949Cwr3OkfOLJ60KoDq3Cm8BtaGHcZM19pA4vsBAqsiZmaSJ15NPe9J4AMOY/UbupsEyCwNEAQUOfmZBp+B8Co2xLkM63MNoxx/mxJe5Axdc+TqgAaGN59+gJO73Wz68CKhHT0yj4LXiPZEvHF30/VYxECzFaWtVGPTI8UP7SZoMdNaSvCWVG/2K9Ne3w+EKNZhJ
 ZLUzAq2P
 SJ/VrxfJvFWhqQvCc5nGdendJZVcWE+1305bli20wdEKQR8FZRPv1SRO92zPzLd98KGJ4/ikNa8BBlfto8o6j1KyF373BqGkrV9/9hALi/adhdZZd1jLGIgVmmM9xtZKobUtAfIWbe4LDu1E5wlIKCfFdYWc5YVM2qzj2+pwxvbnNC2mPTL3UbQlp4R+zovRUv1eT0t5eKHfvuSmnzBJYyMVcHo6AH0LdUa2p7BHzWdBYJHg7BEHcuy2e0rf3S+p/YF5X5L+Zkenu6n23VModIlnBrgAV5kz1HhhEmkOHo/JdL6vySvSjnjgqecx/ia0gqHg6NyZZ4m0+8TyQq1x3e5j2lrya+QVzEvCaoTzdtk0kNrwQpDip5QCbO4abDEsbaQS6LSjcBiw8KkD/Rprk5oowwf67Z/4aeIHPcLLUt88Etq+6dRVO/FODhmeAWJOhJKyyTdjdQY3DNak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-29 21:33 +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> A PMD migration entry can refer to a device-private folio.
> zap_huge_pmd_folio() checks the folio type instead of the entry type,
> so it treats such a migration entry as a device-private entry.
> 
> Installing the migration entry already removed the reverse mapping and
> dropped the mapping reference. Zapping it must not repeat those
> operations. Concurrent MADV_DONTNEED during migration back to system
> memory can trigger this.
> 
> Check the PMD entry type using pmd_is_device_private_entry().
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

One note below, but it's not a holdup.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

> +	const bool is_device_private = !is_present && pmd_is_device_private_entry(pmdval);

pmd_is_device_private_entry() already returns false for a present
pmdval - so !is_present is redundant.  If there was a reason to open
code this, then keep it, but otherwise you could drop it.

-- 
~Gregory


