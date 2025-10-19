Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B3EECCD1A2
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 08:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3AF8E001D; Sun, 19 Oct 2025 04:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B268E0002; Sun, 19 Oct 2025 04:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A4F8E001D; Sun, 19 Oct 2025 04:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF4548E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 04:19:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B184C05B5
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 08:19:59 +0000 (UTC)
X-FDA: 84014165718.11.ADCF55B
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id 46B2F140007
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 08:19:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IOZLWC6C;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760861997; a=rsa-sha256;
	cv=none;
	b=rOVtb3mkpzzvigRmZIlDMh/KdRa4Ca2yy9WWlXu2y8QZ16hIMzKcKEi78lx+bBOfP7mJ3U
	TAw1Gj9VRQgc7rNhM1Fn0+CmgRYYzw3SwWX4z2oG9LvKL75tn405ukHE1KgMwCmGmlPPWf
	7mTr++UsvUiiN3RiXPtKgevyBQ3AFNE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IOZLWC6C;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760861997;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzAnCEb80QifK9acVK1YEWu5S4rWy7O2ChI/IhFvLrQ=;
	b=z4hF2rD3sLNBwAkhtt79denwgYUKl3tjj1pmVB8mNIv4MZYafQHCnK8Wgd1VSIiuHK+bLQ
	g5xfZhdz9UCNXM/wB2E03LjoFZaAHaxDwjBZRS6GcuYhekTRtOZAhpzj2pmjHkNKrcQfLV
	BZN0G5gX+syX/Agg4u6zGCY1u36pHhs=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b660019ac2aso291098066b.3
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 01:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760861996; x=1761466796; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hzAnCEb80QifK9acVK1YEWu5S4rWy7O2ChI/IhFvLrQ=;
        b=IOZLWC6CwMlhYa9DefNldjPjp/dxIXyaLN+GmfS/6QQXfgf6YHzE2IoizBBwRCZE4L
         dvHr4RfDi5MORZAIqaykp4PwxWQoz5gbIPZApNVzOo5gxysXu30xN4oYEeJuLD3u2HFe
         dacbZE4V1UUJcRnJs+qB1Afj00LpSsUEtMo4/678WjxAmk0I8/Ckvdzv0XI4IxZdQwhu
         KFfuDeZFnkuArlMFqY5z7cMo1YLnpRODxfmUfBkuPxuyIeUxnMGjvONIw4jeyB+hmECR
         ju7zR1gEau7iYhi8D1psAgkLYb9VfYXbx1ZCPJ9ycHHnv14YzQrMPrr6yTCaD5YT6ruD
         6/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760861996; x=1761466796;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hzAnCEb80QifK9acVK1YEWu5S4rWy7O2ChI/IhFvLrQ=;
        b=Jg+7x+Ts0hTsHQyBtymBatIS6MUirusHRarB0/0byrEeptNQB4DKFMPFC+cGBIMw19
         j2HPXNayyausj1+zDuYCO6vHeoflIQoxWtCxvjw7biiRv5UikoTGLrwFq5vUN+2UoWU4
         gxhR/nXJqYoel8auxg0Z/gBh/IX6zymk3aoJIjaedfdIrm1uRr21gDnuN7ZYWNPSuv34
         N03cvbgRL7LMUhTP3PmB1XdrPBhZy/C/fbbWHORG7MJHkGH8rNfSZO89VRbNLe9Cz7fj
         ihAAuKTAwNCsK0vlW6LbeUL0pi38GlLqsA1UYW+JdEYe6VqlADo6bPkdvwHBy1PmgHEH
         Xx9g==
X-Forwarded-Encrypted: i=1; AJvYcCUT92Dcr8Z4Kdo06F1x9AgAhcytc8RadCGTtXtkWygeoQFuYRE+c5JjSN3BfLil2qrkaK7EzBtILQ==@kvack.org
X-Gm-Message-State: AOJu0Yxt5BztEiCwsv0GfQqTHEDpNr8uIpftnCi60j+34jmpMeA7bj4Y
	kmWogfr0TGDSOZf28vPjy2L39FEwAVF2tBlUiet/lCltjdeXm5k8M5/N
X-Gm-Gg: ASbGnctBmnYs87n9qJ/CZjVczCK+kAaNL+Glh5OBEFWuLQ9RcxoEYEmCpHUIwy3WgDf
	AaaXvngFMEnY6FJNaV1/k3hLGpQuxvCy6UwhhxiuUMED4x/aI3FS3UWfSxL1Uscq+NfjVHyWfwt
	x6IMSSJSIP5IL8w6aWJVhIT9NhF5QDA/1I9/GsH2+Dor9yhfq9AsD3eoPH9u3hqy/dRwBc0h4Hd
	NU1ReSHqE52tzn4gxCghjj0BnX8jWDBlGDxWbXgWULYVJQMeZYkmIZFtMn7oi7dv0CgrFGZtjGg
	1t3ym+aRCV4ku8deA2a00LcdXNM+dDOCeQTTFuZzWwG2Z50XhpgkKb1AszN5uAh3+rt+H+X6wJ2
	Tuqkvp4KxAn/wUZgiLxc6OfrYPd3DZojVuRBdZpFQ2Nopj/tDoVg/r+7SZcAUK46dVZ3hn0Nt+b
	NP4nY=
X-Google-Smtp-Source: AGHT+IGe2bSS2UoD1lk0Xxfgzd8YXhfUNUOT8b22z2p6gAASSaXv1SkNEJLCq1pmMcg1S7iCxcQ1kQ==
X-Received: by 2002:a17:906:c145:b0:b57:78fa:db48 with SMTP id a640c23a62f3a-b6474f185a3mr1028142366b.51.1760861995556;
        Sun, 19 Oct 2025 01:19:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65ebb499dasm457209766b.73.2025.10.19.01.19.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 Oct 2025 01:19:55 -0700 (PDT)
Date: Sun, 19 Oct 2025 08:19:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, akpm@linux-foundation.org,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v7 11/16] mm/migrate_device: add THP splitting during migration
Message-ID: <20251019081954.luz3mp5ghdhii3vr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251001065707.920170-12-balbirs@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001065707.920170-12-balbirs@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Stat-Signature: gowjs3wbbpdigodeo7bhets7n3z3deph
X-Rspamd-Queue-Id: 46B2F140007
X-Rspamd-Server: rspam09
X-HE-Tag: 1760861997-50784
X-HE-Meta: U2FsdGVkX19KETiYaxscFafzXdsshynQEPcfEvSth2aTbEihPcOPKYIcJnl3MNFqlQE+BsCOPifA85tw8Yvzg/PDNNtdOF+J8uv+pkdcnRR+6qFQbdMnQYEJVRYVQ5bYRgyhq/dqeZ9BeILv/I+zh728MQzDSjy2VJMsEld9Vq681MYKoklFmYAsFfogsrUKnGmBH/8yS+tXcsmuQgo8O/2LRITcUKRzg3QhhP92qOTmVsdOJa8PbpG8UTHAodPYC19mrUd2p2SPXeU7MGic6dLS9l2wt03MijWjfcwv4YMpbLNucm2fgF7iHvrB1qNYsF6XymJEwaESAsqGH1BIq/S7yceXGZIQKQoEywVLb0ySpCFTZJo0WPlqqHmXrBvig3D5DBOuTT24iTiXS4pktDpNSNSyCBlaVIyeuluKnH0S8vZE2SwQkAbF4lptVglH7EphHR2I7NcqNaKhkTKVdzzfOCHURCguPBU3MPczmq1lvH1np0gPe/gQ+JhtyWt5ZxBmOt7TR5XHckcmuu4gOZuqO574lQRzV2QB43gH9f64R5uYVUllW19R+eOTRjdEmzboh0Y6LSPLq28F2yx44a70MbQpYZEzuwDKZ1smh+ItMfaYBEMJE3SSIuQOiSTNTOnzo10kBzOhQy1ywY+XIJQzjh2G4RU2inJObSxZx7Jgp+f3QkMwtDGT7Xh04+bne9Plsrh4eI6078CdxLDwJ/CBNstq1xXWZ6GQRnrwr//kMO/kJRXkddlUk4fTU+3Ih35jKYcFv7Wr3W2uy7vmVOS7k9tuRJAEsyKWmeDRS5VrmaHa2mpo4VYrBECwgwNRp17TBt7KYu9JyMy3eiBXX14Vrdsk0Lz/OgZtHGdMSq3N5+ugbcmvdRwHFUBWKrI/NeyEHjHPu6ijA6rNDvifW8BSSELTwrILi3fHWasjVz6xHAveq3ylQ9IKbjcrWbUKXVbtEnIIah/N3GQB0d/
 GHcbhcGf
 /QqdxiuVK7vy0MJOA3OyV6xPizDtCJK4BeoEUtdWbjSf+TrJWekfMg/ZTMA/7Jo/wGWxsmXTk06VQzJIl+lmYWx6ag47o4d9BQDpIEi46VYdVZ4ZkePLo3Ja1EsBa2MBjADydZ4cpEjcxmOTU8aeBaluxf3GzHFmFrECX6QiMX3ETfBhB9BO8/v0HKuhFxHFgNG4NFWpVIR7qprqaGmAdoRDwLHMFiYanHWDunaRVlq5jyTqfOqJ6dqndCuqQGqiGJ4AxEzHrbDkY6rkLnsymE9nFBWYh1dZlh368RKxxHv9/AZmqu2gN47AdNtwRFKbyX3cakgANjv+lLwwUJgn7jAPt8JUiDJTK2J3ZVmZ5gehDDcwqKSsvFHB1vcZLR+bQ/na7/KwNpuhIt5/QTISwOuCNfpKeeEvp5xOBcKgQvBP2kqjQKZtbVjKG7lo8q7e18qSetMkywPxgVVPnsDEA+6O3kOI/NUf5Z2uGlxuzjQ2r2XvL1j1WOpJBnlAa/+JB0ZzU8AjFWGCtZAjB71DKUbH7Lwq4Og2a38Q1LK4f9EuxVdGU9oDTX9YywBSXIOM43aR/9msf9EdKGZRqY898Nmx+lWAg/5hjJYmg9yUQV55kzZ4dDtlBS2NItLPqzqSsQggJ74E2Q7ZhGCcJgBAJjNjJ3McyGmK88ZGTA8ny/EiYjB2L/JgBVnDiVBp1UEjH8Atb21VyrEYYUO/x/tTod7KBxRThFoqq0quGxZIVsQ4MHjl5x+FucY669pXq8DVJAXes
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 04:57:02PM +1000, Balbir Singh wrote:
[...]
> static int __folio_split(struct folio *folio, unsigned int new_order,
> 		struct page *split_at, struct page *lock_at,
>-		struct list_head *list, bool uniform_split)
>+		struct list_head *list, bool uniform_split, bool unmapped)
> {
> 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
> 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>@@ -3765,13 +3757,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 		 * is taken to serialise against parallel split or collapse
> 		 * operations.
> 		 */
>-		anon_vma = folio_get_anon_vma(folio);
>-		if (!anon_vma) {
>-			ret = -EBUSY;
>-			goto out;
>+		if (!unmapped) {
>+			anon_vma = folio_get_anon_vma(folio);
>+			if (!anon_vma) {
>+				ret = -EBUSY;
>+				goto out;
>+			}
>+			anon_vma_lock_write(anon_vma);
> 		}
> 		mapping = NULL;
>-		anon_vma_lock_write(anon_vma);
> 	} else {
> 		unsigned int min_order;
> 		gfp_t gfp;
>@@ -3838,7 +3832,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 		goto out_unlock;
> 	}
> 
>-	unmap_folio(folio);
>+	if (!unmapped)
>+		unmap_folio(folio);
> 
> 	/* block interrupt reentry in xa_lock and spinlock */
> 	local_irq_disable();
>@@ -3925,10 +3920,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 
> 			next = folio_next(new_folio);
> 
>+			zone_device_private_split_cb(folio, new_folio);
>+
> 			expected_refs = folio_expected_ref_count(new_folio) + 1;
> 			folio_ref_unfreeze(new_folio, expected_refs);
> 
>-			lru_add_split_folio(folio, new_folio, lruvec, list);
>+			if (!unmapped)
>+				lru_add_split_folio(folio, new_folio, lruvec, list);
> 
> 			/*
> 			 * Anonymous folio with swap cache.
>@@ -3959,6 +3957,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 			__filemap_remove_folio(new_folio, NULL);
> 			folio_put_refs(new_folio, nr_pages);
> 		}
>+
>+		zone_device_private_split_cb(folio, NULL);
> 		/*
> 		 * Unfreeze @folio only after all page cache entries, which
> 		 * used to point to it, have been updated with new folios.
>@@ -3982,6 +3982,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 
> 	local_irq_enable();
> 
>+	if (unmapped)
>+		return ret;

As the comment of __folio_split() and __split_huge_page_to_list_to_order()
mentioned:

  * The large folio must be locked
  * After splitting, the after-split folio containing @lock_at remains locked

But here we seems to change the prerequisites.

Hmm.. I am not sure this is correct.

>+
> 	if (nr_shmem_dropped)
> 		shmem_uncharge(mapping->host, nr_shmem_dropped);
> 

-- 
Wei Yang
Help you, Help me

