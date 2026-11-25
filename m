Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18837606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vu+nQWuo
Received: by kanga.kvack.org (Postfix)
	id 3CB576B09ED; Wed, 25 Nov 2026 07:36:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A24B6B09EF; Wed, 25 Nov 2026 07:36:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B91D6B09F0; Wed, 25 Nov 2026 07:36:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB58A6B09ED
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:36:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63B46C0ECC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:36:56 +0000 (UTC)
X-FDA: 85473590832.23.29132E9
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 87639120003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:36:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Vu+nQWuo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795610214;
	b=Gwfh9n0xA/93m2DLRBtpfJDAfETNlLxTnbm7HD6r0aOFOd8HBVXyCB0xjRsJ2AriDQPDAw
	mIEMWy893VXck0L4bj0VI7debOuZMCNNTL3FI3JI+IhGLkXc7Z3LszNznVchcXuIACzqKD
	Bs52bI1hthFG4WjiYZxCeLmKANTWvp8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795610214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9PVTO+o8vn+uvMZF31e4GKIg2ZTnIwjzGlvqUNqLkI=;
	b=4mUka3Tuj+kl6YxA1Mx9R12vG6gKU4DIPiOx5/65gfzM2pQrsJXwPDVl/28VTFIw9sxY3B
	D53JoiHaSdFxxRB3Cxb3vACrke79KGd91XfxYpcvtPzVpeINqRYc4QgJ1+9X1U4C/XxXmG
	JVyNOOc5ZEcvi7jbM3BWcDNqRBWuVLY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Vu+nQWuo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b43d30822fso2974132a91.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795610213; x=1796215013; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C9PVTO+o8vn+uvMZF31e4GKIg2ZTnIwjzGlvqUNqLkI=;
        b=Vu+nQWuoTVIrm+dr0/POjLCSLozwikHMiPypo/fHa1SSc+An/nOo/08x2fisPJP3PC
         wMw9vwzJki2GPGlRIcg6r04bl7QAYZUAYqno8K15KxldISeHloJ9Tgf1zQ/fz7473BJ3
         j+YcHu0dbiRyYbZeAcVBi6tT+ojXi+8jC9zLjDAcIw4U1UB/nWo1KWtbGYEFiPaf8iLl
         7K3VjvADCzb6BBM63M7JVuybAhCDzLzc3xWi9oszV8a2rtJSdI2MC8lVxi3uO0qD2zBf
         Q9lw60VS6skzayh4F3Yi2CyChpNb9vM08rBsaoE58xy86+dAYJQ+I2JLHXBkBVSBZzNw
         +8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795610213; x=1796215013;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C9PVTO+o8vn+uvMZF31e4GKIg2ZTnIwjzGlvqUNqLkI=;
        b=oOmvhJt1L5GgqEXeWywhE1yXQ1yErzAmvtLxjuNUCVtYf5yjqGOwfM6v3EBJoJ9W2P
         GGfE9X3aHMj3UlBNDCw4pMJ0OZwvXQW47KTfaPyGbbboOB8vv+niAfqCEQUqe7T9kJb3
         uF+dX1Vx64SD6v0zgGqYxEbehf3fhKQOASIVh3w58Q9uVRRlM/Jo0qNeM3Dm0BF93Yet
         QAQXD/MrSuBkZqfeB7TaRI3mT+ZVcvZbSSHOdd3sqWSQCIT/MyytN6FjuoywPz7WNOmA
         gHgTn93IzmnyuVyz8xwnNdALrK+K9/AEOaJkw9iYhYftXM9gDX0GU1KvR0rC2q3Bs8PO
         IhZg==
X-Forwarded-Encrypted: i=1; AL+hErEEfPLkQ0dwUBGiiIPcHQsf99IrOPx3THWP01bcDNtbZrARUY8+LyiCeI0hA7tbzFvLqdR5JP8sfQ==@kvack.org
X-Gm-Message-State: APuU4Z/3vB501iQrj1MA+XVxtdd9kmXOJCUdlak0dSkFRbwEe3cyhGU4
	m4iifWT/AFvvO67phkqqMrU4W3OKaIU/u/6B7AAFWUxJ1Zd3KqNOpUOY
X-Gm-Gg: AZFdTZct+P9TzlQ+6FTvr5wH1X1aca225OJymGI8POXJ+7PUav0bLzdIEnplQDDnwi0
	9mM7vfVZFMiaogc727vgIEOfvwy3AVkguAuR6LxlWv3N3ZdjRP1LcKOYJAnqTwwtCuQ+jPjVmKP
	VvWJIYrpyPdN5b3yapVumPnm8cu1sw2c4Jvz5SNHGtOkwPyEKNuljwBzMAEV2PUQ2QsNknY/71a
	eUG//pGYcoytP6U64KlGfIY/bGCFZbZMfx/PuawPwJlgr5LLlhk1uXsQj8G2jp1Uxl4igKwfy/7
	xxG6iRKw3a3x7wnJP+OWbO7GPowaPkI6oZ6yuqyqFKf4Jt4fgHcEFONRUUnBycchzNzUUS577V4
	58YqL+MPhRHhOFAteQq6Gwp7bxeOdd7TEvjUt/g/bsMhq98aRCSSIhUVcj4f96iTiAL+GWRXwR+
	sBWlTYOD86mT9hvL9L2pCHWkbwh/0XqDZ0mKmN0Y5GAUQSimcgJ6E4aUAVG8JkHOALosVBxeZ82
	pH+4KOp4sHD/1SBzFntRwiywQXhPOVCbfi8NRVVw7nhQ/B/9MDnLLAcA8Q6fVMPJtrsroigqAhW
	Bh51FKqDUTatZWM1lAH2JUCdONAzDdW+OlMEoV6YSYkePdMqe8CWvQUIr1g3wr+R6ZZMAq8=
X-Received: by 2002:a17:90b:4a48:b0:3ab:2d17:51c5 with SMTP id 98e67ed59e1d1-3b41c7b60b5mr15844816a91.6.1795610212712;
        Wed, 25 Nov 2026 04:36:52 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d639fdsm30933094a91.10.2026.11.25.04.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 04:36:52 -0800 (PST)
Date: Wed, 25 Nov 2026 20:36:36 +0800
From: Kairui Song <ryncsn@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 08/18] mm/mglru: make folio lru referenced times count
 a generic API
Message-ID: <awa30hwg6x82REoo@KASONG-MC4>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com>
 <e85a2666-9722-420b-9a60-9d4251fc3d4c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85a2666-9722-420b-9a60-9d4251fc3d4c@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 87639120003
X-Stat-Signature: 756zm18xy9ko1795dqsc1xb7j8k1qt6e
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795610214-80834
X-HE-Meta: U2FsdGVkX1/gf0vW11uDJxR5/vae8jUrA/V6anMHqrcpC8CmlCMD0zITl/pdC7KVjkVlF5Hp/DFAwhPl67yQbHFbpNGPvLEoHDg/ovTT+BfuaJ3oDyriFstnf5VzVZhTd/pz06WOgOCpZnPuTSWiWnYepqtgghVPyasmX38E0OZy95k/245HMk8ynf8Ymi/Bs+rc/rSCs2g7OHdtiziTK5Tijs9ndgvPBaqNOOr/LeQpygWUh1zVclZJqv1PivcZLFl1idGitJYRngwwjVaVL+5xTGIUYtS1RjLmek8RH57LdU1Qxj/NFm7ZteoYxaWL65MzmBn+94xkI8TNGR4JDeSV+4RUNQXtbr2xCW2ifcI9a3AMQccEdp3DXFk7v0R5k4Z40PvyoFfsuv2Ul35y0KhFB8ME7AegB09g++efL2QHxYmuaqAduELfN6OoabXrD7Y/4wISqjBwS0rFmuveLR6+z41pCJWRzfXaKqB36w5CfwSsCiLN2bwls3NOe6Rux6UpAPTqt1MPR0/wuaLck6RyTefsyRAJqXkLzL7hvXPpdUlbOGN8J7sMqOHs1CEBLfJi5NcfxY3W1wB6OpsqjuOPJ5NxQsnr8DqIIRBBEDwfqxBTO5bbUOMsNW6EmG5ttwV5YYAHUn8FvEARqqzL2tKU+SNO3c+nwNcHMqEKxnp28cNXcWiQpbq7ARR6CMt/SlwVUDd6BxvJ7yepl8wRfUrnLsLkjGfdSsBTqZXkm3Kdxj7tweEgSHXey7AfgHXqtEhkHi2FGooDdlSUJnYjWM4B60BsFi6nGzoj+GJkba6cQHKH5ltpARg6rNhvjq3zUNCQuMyUrQb1DU4DfL5PgwpXrEdj7icO+TEYkscPbBouX2ncpNgg9RMqRX+kB3JwVLNpDeXVgLF9QIhay4LV2ABiBC6jl1fUjwMwwTFw+G3Gi7gLlLIh847aS1j7KWRxQxAvBrobHpXNYZrCeMo
 BzjX4H1N
 f7rk+1tVS2iwVLv/zfoGwQvH5dVE3LgFo5HK0RNTlwfuk5PxYFU4jjR1psH+HKqa/QOI5zVYOxRYLNrxVtwweXehtDw3WoDbNCr/ad94s655bv+Wb+1KJJDmFkEAj3k2HKnnCZsH55EPT8i3O3IJpyhcFJbhLjgBj9BY7X52gcITEGXq4aQDlvq/PBr/hW3ANyV8eRinglXEeoYjjzsITq9CMgboi7W+1e9kfSLkAp+/mgmQxVSweUm18UnWBjwj9XVXr+F9uj3C9sfpVkpqxBFYzTacgh/jNo9eyIrQVEmtn1ReTve+aGk9eDlB3lRCLl3vC3TWOeeEBNEkaSJh08+9aCBMxzxB9K+YWjWYLpWM6o5Hyl/cfPnIE+5XCxOKO1zZWJKAMt6KvDrhhufPvMfWZVAGAXVHUj9YEqPdi3LJ4y9rK3BpqIUlfn6K+BHj3IttRuDDushB2vvKjNu6hfJB6VMuplY1zdwrN2/i3gq3AxttvNMFRCqdTSnlPa8Tsy/rX1Ajm/VdgPdC0ZpnP0++cPyTI6RThJcoxIFAV4mDboVtpHQgnVbEs2KhNJQ8PdyCjNZpaLT4385BKh+C8DNma/vFeeFWXgDGZh2sk74JBf601cikKLfJukVUZkoYscidp0MeFL2JTPH7AHnprDfH9kXqpZs1eX930VlC+Vq3AyfgVpqCLLqGy+bKVvXpUZLEVyzxdNvMEVGmoLFMtYWG4AMwBVbM5v7SXAp/e6Ho4kq7F9O5xN7fxs2LHz4aKSxa9CXCYVndUVUH7A2vJbCGWxiXy0fY9bRHzfJpEN628NSeWbKgeu0F8Ve3HwI8qzgKkjCDUqsjHH9ph7yB9ovEdg+LA/tiRBPJxePsbdAWGKle/VFfhEJG0dJdE9YUeAkKU1BqV7nx2oOFrE+4CInzFDdL+U4D+0uoqk+bc4XN8i+1Vw2zFEpo4c9DZYmLN9MLs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 11:15:33AM +0800, David Hildenbrand (Arm) wrote:
> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > Pure code shuffle, no behavior change.
> > 
> > Make the folio LRU refs helpers available regardless of CONFIG_LRU_GEN.
> > Without MGLRU the extra bits are never set, so they are inert. Move the
> > lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
> > unifying the API for checking folio referenced and workingset status.
> > 
> > folio_migrate_lru_refs() now migrates the complete refs count,
> > including PG_workingset (bit 1 of the encoding), bitwise identical to
> > the direct copy dropped from folio_migrate_flags().
> > 
> > lru_set_refs_flags() skips the nonexistent mask bits when
> > LRU_REFS_WIDTH collapses to 0, preserving the two independent flags for
> > !CONFIG_LRU_GEN builds.
> > 
> > Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Tested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/mm_inline.h | 55 ++++++++++++++++++++++++-----------------------
> 
> I'm starting to feel like all of these mglru/reclaim thingies should go into a
> dedicated helper.

Hi David

I saw your comment on other patches too, about the header mm_inline.h,
about ~690 / 860 lines of code in it is for MGLRU / CLRU only. The
rest ~200 are for VMA / TLB / MMU.

> 
> Can you do that as a prio cleanup in this series, so we don't have to mess with
> mm_inline.h in later patches anymore?

Perhaps we can instead move the non LRU helpers in it?
These helpers:

  - anon_vma_name_get
  - anon_vma_name_put
  - anon_vma_name_reuse
  - dup_anon_vma_name
  - free_anon_vma_name
  - anon_vma_name_eq
  - pfnmap_track_ctx_release
  - init_tlb_flush_pending
  - inc_tlb_flush_pending
  - dec_tlb_flush_pending
  - mm_tlb_flush_pending
  - mm_tlb_flush_nested
  - copy_pte_marker
  - num_pages_contiguous

All other helper in mm_inline.h are for LRU. So we rename mm_inline.h
to mm_lru.h?

Like the patch below, zero behavior change, pure code shuffle:

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d8bafcd92791..2eb0e2fc8c2d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1903,6 +1903,90 @@ static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return
 
 int vma_is_stack_for_current(const struct vm_area_struct *vma);
 
+static inline void init_tlb_flush_pending(struct mm_struct *mm)
+{
+	atomic_set(&mm->tlb_flush_pending, 0);
+}
+
+static inline void inc_tlb_flush_pending(struct mm_struct *mm)
+{
+	atomic_inc(&mm->tlb_flush_pending);
+	/*
+	 * The only time this value is relevant is when there are indeed pages
+	 * to flush. And we'll only flush pages after changing them, which
+	 * requires the PTL.
+	 *
+	 * So the ordering here is:
+	 *
+	 *	atomic_inc(&mm->tlb_flush_pending);
+	 *	spin_lock(&ptl);
+	 *	...
+	 *	set_pte_at();
+	 *	spin_unlock(&ptl);
+	 *
+	 *				spin_lock(&ptl)
+	 *				mm_tlb_flush_pending();
+	 *				....
+	 *				spin_unlock(&ptl);
+	 *
+	 *	flush_tlb_range();
+	 *	atomic_dec(&mm->tlb_flush_pending);
+	 *
+	 * Where the increment if constrained by the PTL unlock, it thus
+	 * ensures that the increment is visible if the PTE modification is
+	 * visible. After all, if there is no PTE modification, nobody cares
+	 * about TLB flushes either.
+	 *
+	 * This very much relies on users (mm_tlb_flush_pending() and
+	 * mm_tlb_flush_nested()) only caring about _specific_ PTEs (and
+	 * therefore specific PTLs), because with SPLIT_PTE_PTLOCKS and RCpc
+	 * locks (PPC) the unlock of one doesn't order against the lock of
+	 * another PTL.
+	 *
+	 * The decrement is ordered by the flush_tlb_range(), such that
+	 * mm_tlb_flush_pending() will not return false unless all flushes have
+	 * completed.
+	 */
+}
+
+static inline void dec_tlb_flush_pending(struct mm_struct *mm)
+{
+	/*
+	 * See inc_tlb_flush_pending().
+	 *
+	 * This cannot be smp_mb__before_atomic() because smp_mb() simply does
+	 * not order against TLB invalidate completion, which is what we need.
+	 *
+	 * Therefore we must rely on tlb_flush_*() to guarantee order.
+	 */
+	atomic_dec(&mm->tlb_flush_pending);
+}
+
+static inline bool mm_tlb_flush_pending(const struct mm_struct *mm)
+{
+	/*
+	 * Must be called after having acquired the PTL; orders against that
+	 * PTLs release and therefore ensures that if we observe the modified
+	 * PTE we must also observe the increment from inc_tlb_flush_pending().
+	 *
+	 * That is, it only guarantees to return true if there is a flush
+	 * pending for _this_ PTL.
+	 */
+	return atomic_read(&mm->tlb_flush_pending);
+}
+
+static inline bool mm_tlb_flush_nested(const struct mm_struct *mm)
+{
+	/*
+	 * Similar to mm_tlb_flush_pending(), we must have acquired the PTL
+	 * for which there is a TLB flush pending in order to guarantee
+	 * we've seen both that PTE modification and the increment.
+	 *
+	 * (no requirement on actually still holding the PTL, that is irrelevant)
+	 */
+	return atomic_read(&mm->tlb_flush_pending) > 1;
+}
+
 /* flush_tlb_range() takes a vma, not a mm, and can care about flags */
 #define TLB_FLUSH_VMA(mm,flags) { .vm_mm = (mm), .vm_flags = (flags) }
 
@@ -2887,6 +2971,42 @@ static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 }
 #endif /* SECTION_IN_PAGE_FLAGS */
 
+/**
+ * num_pages_contiguous() - determine the number of contiguous pages
+ *			    that represent contiguous PFNs
+ * @pages: an array of page pointers
+ * @nr_pages: length of the array, at least 1
+ *
+ * Determine the number of contiguous pages that represent contiguous PFNs
+ * in @pages, starting from the first page.
+ *
+ * In some kernel configs contiguous PFNs will not have contiguous struct
+ * pages. In these configurations num_pages_contiguous() will return a num
+ * smaller than ideal number. The caller should continue to check for pfn
+ * contiguity after each call to num_pages_contiguous().
+ *
+ * Returns the number of contiguous pages.
+ */
+static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
+{
+	struct page *cur_page = pages[0];
+	unsigned long section = memdesc_section(&cur_page->flags);
+	size_t i;
+
+	for (i = 1; i < nr_pages; i++) {
+		if (++cur_page != pages[i])
+			break;
+		/*
+		 * In unproblematic kernel configs, page_to_section() == 0 and
+		 * the whole check will get optimized out.
+		 */
+		if (memdesc_section(&cur_page->flags) != section)
+			break;
+	}
+
+	return i;
+}
+
 /**
  * folio_pfn - Return the Page Frame Number of a folio.
  * @folio: The folio.
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index f6f4bc9a704f..d7f1d3e4fa4c 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -6,9 +6,6 @@
 #include <linux/huge_mm.h>
 #include <linux/mm_types.h>
 #include <linux/swap.h>
-#include <linux/string.h>
-#include <linux/userfaultfd_k.h>
-#include <linux/leafops.h>
 
 /**
  * folio_is_file_lru - Should the folio be on a file LRU or anon LRU?
@@ -500,181 +497,7 @@ void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
 			-folio_nr_pages(folio));
 }
 
-#ifdef CONFIG_ANON_VMA_NAME
-/* mmap_lock should be read-locked */
-static inline void anon_vma_name_get(struct anon_vma_name *anon_name)
-{
-	if (anon_name)
-		kref_get(&anon_name->kref);
-}
-
-static inline void anon_vma_name_put(struct anon_vma_name *anon_name)
-{
-	if (anon_name)
-		kref_put(&anon_name->kref, anon_vma_name_free);
-}
-
-static inline
-struct anon_vma_name *anon_vma_name_reuse(struct anon_vma_name *anon_name)
-{
-	/* Prevent anon_name refcount saturation early on */
-	if (kref_read(&anon_name->kref) < REFCOUNT_MAX) {
-		anon_vma_name_get(anon_name);
-		return anon_name;
-
-	}
-	return anon_vma_name_alloc(anon_name->name);
-}
-
-static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
-				     struct vm_area_struct *new_vma)
-{
-	struct anon_vma_name *anon_name = anon_vma_name(orig_vma);
-
-	if (anon_name)
-		new_vma->anon_name = anon_vma_name_reuse(anon_name);
-}
-
-static inline void free_anon_vma_name(struct vm_area_struct *vma)
-{
-	/*
-	 * Not using anon_vma_name because it generates a warning if mmap_lock
-	 * is not held, which might be the case here.
-	 */
-	anon_vma_name_put(vma->anon_name);
-}
-
-static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
-				    struct anon_vma_name *anon_name2)
-{
-	if (anon_name1 == anon_name2)
-		return true;
-
-	return anon_name1 && anon_name2 &&
-		!strcmp(anon_name1->name, anon_name2->name);
-}
-
-#else /* CONFIG_ANON_VMA_NAME */
-static inline void anon_vma_name_get(struct anon_vma_name *anon_name) {}
-static inline void anon_vma_name_put(struct anon_vma_name *anon_name) {}
-static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
-				     struct vm_area_struct *new_vma) {}
-static inline void free_anon_vma_name(struct vm_area_struct *vma) {}
-
-static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
-				    struct anon_vma_name *anon_name2)
-{
-	return true;
-}
-
-#endif  /* CONFIG_ANON_VMA_NAME */
-
-void pfnmap_track_ctx_release(struct kref *ref);
-
-static inline void init_tlb_flush_pending(struct mm_struct *mm)
-{
-	atomic_set(&mm->tlb_flush_pending, 0);
-}
-
-static inline void inc_tlb_flush_pending(struct mm_struct *mm)
-{
-	atomic_inc(&mm->tlb_flush_pending);
-	/*
-	 * The only time this value is relevant is when there are indeed pages
-	 * to flush. And we'll only flush pages after changing them, which
-	 * requires the PTL.
-	 *
-	 * So the ordering here is:
-	 *
-	 *	atomic_inc(&mm->tlb_flush_pending);
-	 *	spin_lock(&ptl);
-	 *	...
-	 *	set_pte_at();
-	 *	spin_unlock(&ptl);
-	 *
-	 *				spin_lock(&ptl)
-	 *				mm_tlb_flush_pending();
-	 *				....
-	 *				spin_unlock(&ptl);
-	 *
-	 *	flush_tlb_range();
-	 *	atomic_dec(&mm->tlb_flush_pending);
-	 *
-	 * Where the increment if constrained by the PTL unlock, it thus
-	 * ensures that the increment is visible if the PTE modification is
-	 * visible. After all, if there is no PTE modification, nobody cares
-	 * about TLB flushes either.
-	 *
-	 * This very much relies on users (mm_tlb_flush_pending() and
-	 * mm_tlb_flush_nested()) only caring about _specific_ PTEs (and
-	 * therefore specific PTLs), because with SPLIT_PTE_PTLOCKS and RCpc
-	 * locks (PPC) the unlock of one doesn't order against the lock of
-	 * another PTL.
-	 *
-	 * The decrement is ordered by the flush_tlb_range(), such that
-	 * mm_tlb_flush_pending() will not return false unless all flushes have
-	 * completed.
-	 */
-}
-
-static inline void dec_tlb_flush_pending(struct mm_struct *mm)
-{
-	/*
-	 * See inc_tlb_flush_pending().
-	 *
-	 * This cannot be smp_mb__before_atomic() because smp_mb() simply does
-	 * not order against TLB invalidate completion, which is what we need.
-	 *
-	 * Therefore we must rely on tlb_flush_*() to guarantee order.
-	 */
-	atomic_dec(&mm->tlb_flush_pending);
-}
-
-static inline bool mm_tlb_flush_pending(const struct mm_struct *mm)
-{
-	/*
-	 * Must be called after having acquired the PTL; orders against that
-	 * PTLs release and therefore ensures that if we observe the modified
-	 * PTE we must also observe the increment from inc_tlb_flush_pending().
-	 *
-	 * That is, it only guarantees to return true if there is a flush
-	 * pending for _this_ PTL.
-	 */
-	return atomic_read(&mm->tlb_flush_pending);
-}
-
-static inline bool mm_tlb_flush_nested(const struct mm_struct *mm)
-{
-	/*
-	 * Similar to mm_tlb_flush_pending(), we must have acquired the PTL
-	 * for which there is a TLB flush pending in order to guarantee
-	 * we've seen both that PTE modification and the increment.
-	 *
-	 * (no requirement on actually still holding the PTL, that is irrelevant)
-	 */
-	return atomic_read(&mm->tlb_flush_pending) > 1;
-}
-
 #ifdef CONFIG_MMU
-/*
- * Computes the pte marker to copy from the given source entry into dst_vma.
- * If no marker should be copied, returns 0.
- * The caller should insert a new pte created with make_pte_marker().
- */
-static inline pte_marker copy_pte_marker(
-		softleaf_t entry, struct vm_area_struct *dst_vma)
-{
-	const pte_marker srcm = softleaf_to_marker(entry);
-	/* Always copy error entries. */
-	pte_marker dstm = srcm & (PTE_MARKER_POISONED | PTE_MARKER_GUARD);
-
-	/* Only copy PTE markers if UFFD register matches. */
-	if ((srcm & PTE_MARKER_UFFD_WP) && userfaultfd_wp(dst_vma))
-		dstm |= PTE_MARKER_UFFD_WP;
-
-	return dstm;
-}
-
 static inline bool vma_has_recency(const struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
@@ -687,40 +510,4 @@ static inline bool vma_has_recency(const struct vm_area_struct *vma)
 }
 #endif
 
-/**
- * num_pages_contiguous() - determine the number of contiguous pages
- *			    that represent contiguous PFNs
- * @pages: an array of page pointers
- * @nr_pages: length of the array, at least 1
- *
- * Determine the number of contiguous pages that represent contiguous PFNs
- * in @pages, starting from the first page.
- *
- * In some kernel configs contiguous PFNs will not have contiguous struct
- * pages. In these configurations num_pages_contiguous() will return a num
- * smaller than ideal number. The caller should continue to check for pfn
- * contiguity after each call to num_pages_contiguous().
- *
- * Returns the number of contiguous pages.
- */
-static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
-{
-	struct page *cur_page = pages[0];
-	unsigned long section = memdesc_section(&cur_page->flags);
-	size_t i;
-
-	for (i = 1; i < nr_pages; i++) {
-		if (++cur_page != pages[i])
-			break;
-		/*
-		 * In unproblematic kernel configs, page_to_section() == 0 and
-		 * the whole check will get optimized out.
-		 */
-		if (memdesc_section(&cur_page->flags) != section)
-			break;
-	}
-
-	return i;
-}
-
 #endif
diff --git a/mm/internal.h b/mm/internal.h
index de4593b3e3b6..b52647a2442b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -16,7 +16,9 @@
 #include <linux/pagemap.h>
 #include <linux/pagewalk.h>
 #include <linux/rmap.h>
+#include <linux/string.h>
 #include <linux/swap.h>
+#include <linux/userfaultfd_k.h>
 #include <linux/leafops.h>
 #include <linux/tracepoint-defs.h>
 
@@ -281,12 +283,104 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 /* unmap_vmas is in mm/memory.c */
 void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
 
+#ifdef CONFIG_ANON_VMA_NAME
+/* mmap_lock should be read-locked */
+static inline void anon_vma_name_get(struct anon_vma_name *anon_name)
+{
+	if (anon_name)
+		kref_get(&anon_name->kref);
+}
+
+static inline void anon_vma_name_put(struct anon_vma_name *anon_name)
+{
+	if (anon_name)
+		kref_put(&anon_name->kref, anon_vma_name_free);
+}
+
+static inline
+struct anon_vma_name *anon_vma_name_reuse(struct anon_vma_name *anon_name)
+{
+	/* Prevent anon_name refcount saturation early on */
+	if (kref_read(&anon_name->kref) < REFCOUNT_MAX) {
+		anon_vma_name_get(anon_name);
+		return anon_name;
+
+	}
+	return anon_vma_name_alloc(anon_name->name);
+}
+
+static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
+				     struct vm_area_struct *new_vma)
+{
+	struct anon_vma_name *anon_name = anon_vma_name(orig_vma);
+
+	if (anon_name)
+		new_vma->anon_name = anon_vma_name_reuse(anon_name);
+}
+
+static inline void free_anon_vma_name(struct vm_area_struct *vma)
+{
+	/*
+	 * Not using anon_vma_name because it generates a warning if mmap_lock
+	 * is not held, which might be the case here.
+	 */
+	anon_vma_name_put(vma->anon_name);
+}
+
+static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
+				    struct anon_vma_name *anon_name2)
+{
+	if (anon_name1 == anon_name2)
+		return true;
+
+	return anon_name1 && anon_name2 &&
+		!strcmp(anon_name1->name, anon_name2->name);
+}
+
+#else /* CONFIG_ANON_VMA_NAME */
+static inline void anon_vma_name_get(struct anon_vma_name *anon_name) {}
+static inline void anon_vma_name_put(struct anon_vma_name *anon_name) {}
+static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
+				     struct vm_area_struct *new_vma) {}
+static inline void free_anon_vma_name(struct vm_area_struct *vma) {}
+
+static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
+				    struct anon_vma_name *anon_name2)
+{
+	return true;
+}
+
+#endif  /* CONFIG_ANON_VMA_NAME */
+
+#ifdef __HAVE_PFNMAP_TRACKING
+void pfnmap_track_ctx_release(struct kref *ref);
+#endif
+
 #ifdef CONFIG_MMU
 
 bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, pte_t pte,
 		unsigned long nr_ptes);
 
+/*
+ * Computes the pte marker to copy from the given source entry into dst_vma.
+ * If no marker should be copied, returns 0.
+ * The caller should insert a new pte created with make_pte_marker().
+ */
+static inline pte_marker copy_pte_marker(
+		softleaf_t entry, struct vm_area_struct *dst_vma)
+{
+	const pte_marker srcm = softleaf_to_marker(entry);
+	/* Always copy error entries. */
+	pte_marker dstm = srcm & (PTE_MARKER_POISONED | PTE_MARKER_GUARD);
+
+	/* Only copy PTE markers if UFFD register matches. */
+	if ((srcm & PTE_MARKER_UFFD_WP) && userfaultfd_wp(dst_vma))
+		dstm |= PTE_MARKER_UFFD_WP;
+
+	return dstm;
+}
+
 static inline void get_anon_vma(struct anon_vma *anon_vma)
 {
 	atomic_inc(&anon_vma->refcount);
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 6e83ce3801b8..61a0c0d4b47d 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -7,6 +7,7 @@
  *  Copyright (C) 2010  Linus Torvalds
  */
 
+#include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/hugetlb.h>
 #include <linux/pgtable.h>

