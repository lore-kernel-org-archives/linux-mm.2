Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8868C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D996B0552; Thu, 13 Aug 2026 13:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C755D6B0553; Thu, 13 Aug 2026 13:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64BB6B0554; Thu, 13 Aug 2026 13:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8681C6B0552
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:05:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12063801D7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:05:21 +0000 (UTC)
X-FDA: 85096872042.01.31433F9
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 51C1840019
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:05:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PzA24iLn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786640717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08qe7GTxugqqWui5JnaWlv3REeL121Y5upJ6qwpGRNA=;
	b=n2ciriP/9Mn8ouxN0Ixy5JxWMmRCcQVeb4wBSE/9tW3OW8sIEJ3RFcTnpUHkaS4P2YfPwI
	9H7/Io0pCL9V/EcL9aLcfSv7nhU7fJ579dVDkwr/MEHeWmYNJP2D28rlUD1174OnL3J0FM
	JHmcN+r0tcu3fhMzc+yUJQBapfkmtPg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PzA24iLn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786640717;
	b=piei2NlVYv2nH25f3ZoToB7O3cApJgzBSgrKcv8QHebGutk6Diq7xX22t2NA558Go32GtL
	fP8lR8IWYXt7yGKzEOIBWYBPpWXeOWPdqdxfCorkXLUIIGj/POqAISlqgx+lpFW25lrYh+
	0HTXriQaqdldzden05uAPgDd6Du8Nqc=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso20166166b.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:05:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786640716; cv=none;
        d=google.com; s=arc-20260327;
        b=eRRvQKylfuEnq0WW2vkNK0OHARSGibuU/CzRHWs4oKGannPVEGeZasfKM0JqYI48i9
         7KCNEO3AGv5mZYnm45+g+SC6YOpPuoHhuc3bxKCuhVyc26C8ZcPEiHb40sQclCOgNKCX
         pwjLshi0OonBGK46zdR6D77mUAu8nWKt1GXQTxEd5Wr+vTSmRdgL0WtuPBQ0QFBbuP9W
         UwLJdfVXbgUSbL0DPRzyYI/hgQIGLYnGtIcMmKYB8qI/uues2obA3YqdKzoYguwH1oTH
         Ih43DcptpR4OCeJohaKB7XNYXOdAEeN4OfZ5f+Xl1Sv1Y5UPhsM2MS96azbgzKu0upf6
         n9GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=08qe7GTxugqqWui5JnaWlv3REeL121Y5upJ6qwpGRNA=;
        fh=ctMiu4LrH7HpDGA6W/13/okPxSD1uxAWh0a2WMBvIy4=;
        b=c64QZYpf1YpzUk/nQyLKuNphn9IRJD2cNqkow6VyQ1EhFeBKE+uEjO/XlqYf3pvZTi
         2LHHqCdXa0yHK6CPJjKf2iXIj8zlad3En5JIzTQjbN5SGWJfK1GYfjgAFcSmit1/8cUY
         WIAaPeoOGApcjI2FbMbGOIvjUf1n7WFd4Jr7IU1xKYCszpq4iCPP1SYzgarBeg8rSFAm
         Ebm01uCUhe7lohJqSx0Oi1cvLVz5PsuhP0V9M33ys3wZx/MqSZe0ZnvBrbVcc7BRZV7N
         Xz9WOobAmFVgJsvmYkJR++dXai4dSUQlJzkaRF1Pa+JPwTjQarvzgjxuZPHOp5+S6vgn
         j3ww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786640716; x=1787245516; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=08qe7GTxugqqWui5JnaWlv3REeL121Y5upJ6qwpGRNA=;
        b=PzA24iLnFb4sr26TkHAnKyplJ3ceCMc5yAKOpZnO5A5k5kNuXcmops60R610dKUVrP
         jtPPpTIQYA8A+ZB/9y/eIq7WpVt4Nr+d+2PDgvC2QPrQgc+xKg3yNTNE4oeVXGzGbrJT
         jT9HqajOcRiPxzMJsvwlmu+tG+fEalS+ShbJcgPB0jWOIHaQnCdKe+6te4wyC64aqOvm
         b9ND0uJuxfJFxENvdM/6azCjxgd/7gD5l0awBIsUJJEUTLC/Jwx0pmVXbHkj5a/4+Est
         SGU6MW9T7NSiysLc+LVxtjaxR8DWc3hHov2oyVKB97/H8meubSlx4wZZbty6lGsYhAVh
         mtRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786640716; x=1787245516;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=08qe7GTxugqqWui5JnaWlv3REeL121Y5upJ6qwpGRNA=;
        b=fKEaj/WlFmXlTn8kTuwOtGPCy8MgXTAhehlGdQXul3ukV+qD4A+AhBtbozVLPTAjTo
         djALyJTA7O+EzKTOIhWuXYHibeVH1EDpGzi0EKVkqykh7aqF0vJi6MJ4lQZwhAy2LH8c
         QuLk2DALSZ32PZXVkaP1yba+n+5YXSEKgA3PgO9BnFlICM/s06CgaBHJ8XkcirlMWoom
         Pyvjds1wcB9MhUikJuVHMpMLJMMWSgZ68jqYPBMVnT2VbSL/9VtjRBoelIp/jECcG+tV
         nmZwGCCJhONK3xZ5bfR0eKz0FGpGpqtJbjq3l68PmAe+5E25z/0rsUCJoxGy4gRg+9d3
         2M5A==
X-Gm-Message-State: AOJu0Yxw+SYaWSafXJLYVSC8Vrw/o1ZxdcwUsqGBFD8rALv2WP3m8Cnd
	mcn0OUEurq5DwpeEIVDyNA+RcRtt+SU9Yi0Gzkvj1c3Jpc4PbantJKhlta/1C6hwuCPMcmp4dEq
	yozxvIFsZUHeWNSSlobaU5F7laPO8X5M=
X-Gm-Gg: AR+sD13OMQLZ2xx9P/BhRZK+zW1Y7EMWdruB1j+AtonakPy7QgNqVR2y23sP1dFKiLl
	tg6lrlOEpp+JPWZrf8k8WQnsP6cA3iKHfcynCuM/r8E2sKZbneOg/gyWa/V9IDoKL+s5Mpn2Ypf
	eHAlxiSCNQ3loYEo2mROWA586J42gbdLex9OvI3CDQ+zCUnG10zP6zDWEPIqAsZmMYgl0GrIWMo
	YIHzBq5jMnFVovU/0IbdURjZJa2T5KLdQNXNsCaH3BT92wCBLoVofVzM8ss4oeP8sCVopCuKKmC
	dZl3ASDYEo3Z3GyYQ8TVW5FEN0vAChCdtbvdbdOMwNQWJ/8EM+jxbfymCKlK1U/Xh5EyMLdMBsh
	ySpk0cWoRVPoT
X-Received: by 2002:a17:907:60d1:b0:c1c:4fce:6518 with SMTP id
 a640c23a62f3a-c21090d8161mr335006466b.24.1786640715471; Thu, 13 Aug 2026
 10:05:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com> <20260813-swap-thp-cleanup-v2-14-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-14-d2ee48c6aa49@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 14 Aug 2026 01:04:39 +0800
X-Gm-Features: AUfX_mzqvKyY3nuUKAGRfqpmy9U1qASPwRcydKfZpDzl6llTSISrOQQ2rICa_YU
Message-ID: <CAMgjq7BQeiWY90+FGvw18__KQr4OxSvgg7ObtGX1K8ptLmZ5pA@mail.gmail.com>
Subject: Re: [PATCH v2 14/17] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 51C1840019
X-Stat-Signature: scn7jtfu9ezc9youcurx4wme5kktgpps
X-Rspam-User: 
X-HE-Tag: 1786640717-17319
X-HE-Meta: U2FsdGVkX1/Q59c9R4HN/aHMEWHphmrmimS7m6UvE4qNCLqSJ5vUDq1XckuxxJeKJu/AvwbWlz0aq8/LKFkjPrgk8Z1/lAIiXPrVCAECvLKdWVy51VJYgksf7Bb+Y0eCOhCLpk3umKpTPqwff0lOcrK37Q5/b2hP2/0VguUpGtmFwPcyyWJI+MVjqZNejI+chmv+bns/LoaRgCeynP5Llgqm9gkA5OzpytpOBWfZGNNYZbit68IfvrXda8rbaDcAe3JVtjgPrmB5jkGTl24aqLHa1EXU+q5CQ9u0oxnReixQdhLn15r/Enc/+VeV6u8ZgBOl6Axn2N0ohivAJeDKjz0KLg7FvEdW2TrYMBPlz4ebsKdS0BQyqIcp9/ciX4GrC7RDtQC2cq6ZqfFzbuvKQnLJGiQEbCjHcc/kLUIwVyFstTr+M9ggePJXwqwOw/E41gn+0euwagQZA7p/sqv+XxNxNY2ASNCtUmR5llaj5HR5rnCjsahX1tsLJNuUSTgxbnAN05d6yEVP8cNj117XsM+ancKaPjEuGqX2S2RghLutBsahbbUSskNb6ncpGlsbKv7E5AEv7+jjrIea/obrj9W2M47s7ipCzIvQaTnYBosPJG65P+oXRadQhuna9lfT0xOZ4hhpaYMDoZ6DNYV7P0p5p6xI7bjJ+v33W3PbQbsIIaYjdFN3G+82LBhDYaUTPQmleTBdh/Iq1xHm2X0inZ91RF0bNnUSpHFxoskAzt8o8VzqebE/vO4f1I+n3eZW6LqiV7qmlofQYMh5FnMVWT/IEmbeiKtDWwt09IIh+8uAqQNNLoSupimvXG+UeRX3Lmup4vh+5uZNblMRxQmoXGdGYZqHT+uFiCVt8ktyQYyaueKIMdFRdmtIE+WMymWZlzfh/lFhWbcBQKRb2jgMUQbtZ3CLnH2sjSgu9VZwwMUMpKgHOnrRenUGK/1m0nkBKGvrmhFfwHR9juzQJid
 BBTXQ3aY
 eMi46+1JYeGqejwaqBCxUKmdOS8q12ys/hS46sCgeu7HAweYLoP2lOtWcREjrYpqaYB38VFASQW+PfJ3k2kVtPi3Er7xZ62rxWiHkQtInRt1wZKXaFI3BZdcmL83OghmJyPfRhAcYNG/3XfyPAmNAME2Ykh+iSuRDmq6jJNXwAl2XZuslf5G2dYsb0MFgnf0mngtSey8zbV3a4VkGafgTc1iwr2GpwZ0c8owBIsDIA5YOqaZJKJJVXblU0xleVNG82J4QzJZ10Llzguja9lx6Zn9lMqrSgptg3x/e2vnjK7Y+lI8KPwFojuMbtBRrTz18/i1EGXvdrhCZD6gm/mv4UXPYI6GPJeVRDpns6zARIDAOi6a3QODfoQlVF9dqVCKwGqAftUwxRBDusniuTZQhOtLvuXGiGVuL+d6nRZdCX+sQNxFprjEJKTPqkiUrX8h0G+L3k3S0q2AmLKlM/+p+Vvi6wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko reports:

--- Patch [14]: [PATCH v2 14/17] mm/huge_memory: clean up after-split
folio freeing in __folio_split ---
commit 30068a849a3b68568f1661083bd4c5a685ac749a
Author: Kairui Song <kasong@tencent.com>

mm/huge_memory: clean up after-split folio freeing in __folio_split

This commit replaces free_folio_and_swap_cache() with direct calls to
folio_free_swap() and folio_put() in the __folio_split() after-split loop.

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4343,14 +4343,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   if (new_folio == page_folio(lock_at))
>   continue;
>
> - folio_unlock(new_folio);
>   /*
>   * Subpages whose mapping has been zapped may be freed
>   * earlier, but freeing them requires taking the
> - * lru_lock, so we defer put_page() on tail pages until
> + * lru_lock, so we defer folio_put() on tail pages until
>   * after the split completes.
>   */
> - free_folio_and_swap_cache(new_folio);
> + if (is_swapcache)
> + folio_free_swap(new_folio);

Is it safe to unconditionally call folio_free_swap() here without checking
if the subfolios are mapped?

The commit message states "The sub folios are still locked and unmapped
here", but looking at the earlier split path, __folio_split_unmap_and_freeze()
calls remap_page() before returning to __folio_split(). This means the
subfolios can actually be mapped in memory by the time we reach this point.

Because they are remapped, calling folio_free_swap() here will unconditionally
free the swap cache for actively mapped pages, marking them dirty and forcing
unnecessary swap allocations and disk writebacks under memory pressure.

Previously, free_folio_and_swap_cache() called free_swap_cache(), which
explicitly checked !folio_mapped() before freeing the cache to prevent this.
Does bypassing this check introduce a performance regression by thrashing
the swap cache for successfully split mapped anonymous folios?

> + folio_unlock(new_folio);
> + folio_put(new_folio);
>   }
>
>  out:

---

Right, I need to check the mapped status. It might be actually fine to
blindly clean the swap cache, and it's always safe to do so, but let
me keep the old behavior for now. I will update it.

