Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4F15C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF03E6B0578; Thu, 13 Aug 2026 14:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6396B0579; Thu, 13 Aug 2026 14:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDCFA6B057A; Thu, 13 Aug 2026 14:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B49F6B0578
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:02:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C980E120261
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:02:42 +0000 (UTC)
X-FDA: 85097016564.02.BD2100C
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id D6FD5C0004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:02:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LGFsGfkL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786644160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24oLlMBWuGFM4ixL+3IRhzcxntuQ/KdbTbGmhUOjPx4=;
	b=llR3MdCUwLBfNzWhHWAWsL40iyqdlUzdCqwo24VD+F3w8Z/FtwdWXbbYG+LhGS6L5Y5wla
	wzZ2frWVuw1T9uO6z8aJo4xcE8kZcFGESB1VANWOJizL6QarjUgOmoUg8ShBY5Kw7MX83T
	LKfsE6CvK80x3VM11s298AAPgG1dOr4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LGFsGfkL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786644160;
	b=CVfMOKtNPW0EewjtZ8vuKqmUc8HjD34UAjLbjKjkk5PRryLs0joi0yoBKDmMN/evvKb+fo
	S+QDhFkjiUuM62yb/KP1Wo2oBhgQcZ9IdeD1YollBbLk9e6lRg+2y6C9QBTxoOM15APql1
	HRYYVPKBSFsIbUBMpuRPai+bQNHPzww=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso2028803a12.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:02:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786644159; cv=none;
        d=google.com; s=arc-20260327;
        b=klW92LfT50/eEsGT63mSZrQrZbcOSl0EMAvSKXPAzvNdN0G3aRd4xZfix+w6+ynAYE
         M7r6dkL5WWe03Fi/VlFbEmj9JHxm4ywNB+OjsqjyemzLLlWk11Rwn3GRqLB0k/DP/W7T
         F+utkSYq1nbLj4mnQINwa7UTQR348SMcb/H5sSiZUBhm/rFknnv/TFELbrlhD42b6htu
         B/IgsCSlJSUHcC7P3+CI3dPife5DwDooL8HyR2XrXQ9sy8bAUybDYG+6z4k7fgHORlPI
         g9hZ0oRVR6+sBrWmsUgVeJHjNiyZP94FGE7Xror5KKfx1md6hW4fVLG5CBB2ME/gJbEv
         0Vgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=24oLlMBWuGFM4ixL+3IRhzcxntuQ/KdbTbGmhUOjPx4=;
        fh=ctMiu4LrH7HpDGA6W/13/okPxSD1uxAWh0a2WMBvIy4=;
        b=rR0SkBk8f5EskGg1ZKiSS7yTLNj6maq6XmzuzKGCjKNS8zzm50oLB8tlNt35bOhne3
         sVRNLl7aE79AvAIFQf2gpjwDObhAqgtkI0Q48bZsJnFxn5RW0eznPU4G98ivpJtiKnWw
         nRcNscyIlrBERnT7u6AwRnqWsZNbrjjh30NojTXpoQ8pO+/db/6JW1hpbFmgqyK4nANA
         moiHQt+Q18nPfSD69H968WdmdzFX/5jWXod7QvUW0wtSGFCLKiP+YwjOqS/UArmKXEYq
         Rk045XymZfT2sQ9mcnAf5VGm6NvQBCGPsNYqQmKP+NlSmcFH64lYxT19ewkh/monO6fP
         sAfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786644159; x=1787248959; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=24oLlMBWuGFM4ixL+3IRhzcxntuQ/KdbTbGmhUOjPx4=;
        b=LGFsGfkLvjAxeYzeMCe73BsPeow8q7S65kFx7tKLiDaGX5E+r9I1Xw9Y29wvyDfG/F
         hf2PdGlGmlHwXT0L2SrUUHAUtG22lwj5na4sGNTaSf9KmVIpa2nroFV59jbrL4AOb4gO
         x6DOwu9b6WiYwgH6+RhaUrvUGSujYjC+bicCv1if+z/ruZ9GCORozB6UkqgLKwr9xShU
         ZK5jvhGUdWIBepZGcK1OUQSkA7YRLWSf5g0iecH4NJ5M46/KeruSY2eE57/0TcgrJm9a
         LjYClpAHy88Gkg//O3NEXLva8I4JlOf4eIx7e1TkNjxJrwoxh6aL1P85tPVDbSyrxxji
         WhjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786644159; x=1787248959;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=24oLlMBWuGFM4ixL+3IRhzcxntuQ/KdbTbGmhUOjPx4=;
        b=KyoyCoMKt3s/eUn0KX4Ckqd4vN976lQWbD83Eo1rx+e3cB/u7gpit1CFOwaJYWpJC3
         6a7SNbMsiSTjdCwHxXykWebvln8ku0OsCuJx6fHqjXgDcszmENY48Js1wPDumpBCspdg
         qmdYjI5rwQMCSen25bvB4holRcDb2Qv3EG6QHNzDAgbod4PSfbyUV9200IBGDD9nBFhN
         Cf0dIEenybQBC/548xaPvqGXDLyUthJGn+GmyjX7vhYFKqcibrCcM9kqNKDWaiCoUhne
         JT5HrEc4IBN9YVZ2lrHZG5EkwyNMRM9atJJWR8YHBO6SaGRHkue7GOTVETbMG2cOgmBu
         mAjw==
X-Gm-Message-State: AOJu0YycQ15IX0wCsVyur0UsOxS1o0KR0K6TIaIjsFIvMfnTe2fw8eeV
	GtiTdyn5Lb+TgdlsmdGuEA1KsXgRUt+Mr4fS1hhbMTbXRA58tqye38CvaKH+bx2yiOhz3Hh6nQk
	4IT2Wc+9SMBe4LCp6d8VTmnKdoA03gmA=
X-Gm-Gg: AR+sD13QIx90qPnmdgD++RO9iEzDExjyXF/wAkYrT1TKj23GcvgEBAy/bsq7pZlhHwm
	2tT0EUW2UNMGJI3xMO8v2PPHaxdkyipKU6cGbzGgEejfkRX2XG86B0hxsd7+7psjx03naXjZxFR
	h6WAn7zZuBpLWUPIOh+VhUTMp29YfRfy1xurPzSuPCMxz4sySzIf4+7LLOGlOIjJEYtsJqmBuU9
	43Agh5NW0EPFyhKiUmv4m1Dzj8nvcKgqD3X8HZf6X0iuVA477YRO0r3Lp5Unvd63SA46hMTFpZS
	MuNfnGr6L/GA/73ICl3ALbaU+qbHYZkavNno+HlD4K+RN7YqMqJaEqXtbGjRfYQMmr0pXOczt4r
	dig==
X-Received: by 2002:a17:907:d15:b0:c1f:2cb2:c448 with SMTP id
 a640c23a62f3a-c210a0c8c9fmr345156866b.7.1786644158985; Thu, 13 Aug 2026
 11:02:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com> <20260813-swap-thp-cleanup-v2-13-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-13-d2ee48c6aa49@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 14 Aug 2026 02:02:01 +0800
X-Gm-Features: AUfX_mx5rE4kRZY2BHjr6RIup6iVQNV4t5AIt9HejRwTKNhQjT0SV7K0UNeiZrg
Message-ID: <CAMgjq7D_xFxDX4ck9LMHY_TCdSuJTCkpKv023_a7tW3khmRDBg@mail.gmail.com>
Subject: Re: [PATCH v2 13/17] mm/huge_memory: drop the unused do_lru argument
 of the file split helper
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D6FD5C0004
X-Stat-Signature: cd47iruhrbpmuoof5rmaahz54enx3i4w
X-Rspam-User: 
X-HE-Tag: 1786644160-317951
X-HE-Meta: U2FsdGVkX1/B6+uKrQ8TTvSVkw+WWFITy8/HhUDM1V2nJ0LKfpbxlM21MT+36HNWtgWuB7pjv3fn44T4Q7R/Hnoe5xVqs5N8B7DXzENW7zUx8rhtcsk37aV+irRBgvHz5iuAtOgGbOs2gIbw0zyJFZmB4tXZOZfjb0AKBbZGjE+Wg/XqhJO2m51KbccNJQn9z4U7z5ai1Ze2P46+A1p8hqODv3QKnbMZqg5JQ5KWNf/2UPWl5+k/i3zJkysdAHxQG/FcNF+l/wbv5GccFcmUrUF1i77gch9ppBhiXJjkJ1UhbJrTv9f9GBfk3DI8z0pf7VxdHDeVnBQEkGyP/d2no/Y9MEqgX8dKgryi5mO8hZoM85hYphr43334QyRqM7Rx7XnZ/0IBnXK5PZksefFpmG0WdlF3yYy7zAfSNrM+xRgPt7pxLhl1+x2adougksmGrwDJf8I9xgHLKd7oazFmute4PMPutjXoXmM2C6BgHcwW1sFcQDRRCLJes/0kNyt0YCqWPzbWCQO/0leIs8xX8EXMycZLDlrKDKjCA8G4/lWXe6gjWhTDNmqkTsWS9jMfV0c/cSbRsHiN5bNqoklARqkPWytjc722oqbHKeW088A3MzRRYIHxKZkV25KmOzXhMjCEu9rZ6yHpwsUXuTB83dEHqTVenvnvRuelefG7qgDFfNIkxXUCC2CnEAlctZWcRYxHETtx31HioB0KeCR1/iPHSUcH4InysE/D7IuD+0M9OYoYqfGW7C/zvw3rzBtXfRyW/NAYMYSzuE+VJqntPTBd/c4Wtg7zhK/5JhzvUOIyk73hMADVo68P466UBLzTW6pEbUx3AxreoIZM120hYTbixpEfwYN6yg7aSxOLYLa1vY0tZPDKKF5P7D3FyUru3IoCEWjU5vF/a0Xvm45JJqmL8uaROAY4vwx9kJTeDUadVXreDHvBkghxKXh4vST6K8Ahv1rhtU8zquYD5Sr
 JX8Wccmb
 Lxt1c5GmpIDVMochOUfC21X7TBZ72y1Rn+P5BWPIQANfr/1rEhUTrGQp9Q3p6JR+8qLKE1FmECJrF0fTgMFenhIMXrD5FJrwcanBCw5s3PFbhqH/C2YMWgwFKpzY3vhsBKijXahgt2SZI7OAnIAv7sRWCYXOahLSTXiHBGUMqrPV9uEkcbnJAzgCXol/k8FL+fW0sjNDXZHjn4ZXjPFqytyX1LbLNiImYgUiQqT3OTaGiAnxkQqmhJnVI15n0krYfX4PmE9APYqOjnHKPYwE6AXMlGMxoEOCDLJQx5CBRpKIE1tqdZxWFeHKVB1s8/pOzF191ISaLNrCP2gc7MoSVYSeQqqyG2VTXo+f3IsPXhMpZq2zz9DbIaEGVKAZN3LFtKK5VsubpI3sNbdBF+aJ8Ph/aQXkAAP4gaDccl/HqM1XvjC5pVM/Wazj0nZ5gZJoeZu5tbZDWG7gWRO7hF3y37l7Gs4BF/7Byftr3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko reports (TLDR: false positives):

--- Patch [13]: [PATCH v2 13/17] mm/huge_memory: drop the unused
do_lru argument of the file split helper ---
commit 56c82d4146d59b581770011278661a173c988702
Author: Kairui Song <kasong@tencent.com>

mm/huge_memory: drop the unused do_lru argument of the file split helper

The only caller of __folio_split_unmap_and_freeze_file() always passes
do_lru as true, so the argument and the branches gated on it are dead
code.  Drop it.

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ce02608b37f43..72e7d24139e6f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c

[ ... ]

> @@ -4206,9 +4204,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
>   }
>
>   /* lock lru list/PageCompound, ref frozen by page_ref_freeze */
> - if (do_lru)
> - lruvec = folio_lruvec_lock(folio);
> -
> + lruvec = folio_lruvec_lock(folio);
>   ret = __split_frozen_folio(folio, new_order, split_at, &xas,
>     mapping, split_type);

This is a pre-existing issue, but does this code permanently leak NR_FILE_THPS
or NR_SHMEM_THPS stats if __split_frozen_folio() fails?

Right before this lock acquisition in __folio_split_unmap_and_freeze_file(),
the stats are eagerly decremented. If __split_frozen_folio() returns an error
(like -ENOMEM from xas_try_split() during a non-uniform split), the error
path fails to restore these stats.

Since the split failed, the folio remains pmd_mappable(). When the folio
is later evicted or freed, filemap_unaccount_folio() will observe it is still
pmd_mappable() and decrement the stats again, causing a double-decrement
underflow.

[ ... ]

> @@ -4226,8 +4222,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
>   folio_ref_unfreeze(new_folio,
>     folio_cache_ref_count(new_folio) + 1);
>
> - if (do_lru)
> - lru_add_split_folio(folio, new_folio, lruvec, list);
> + lru_add_split_folio(folio, new_folio, lruvec, list);
>
>   /* Add the new folio to the page cache. */
>   if (new_folio->index < end) {

This is a pre-existing issue, but does calling __xa_store() here inside
the page cache insertion loop leak memory and cause latency spikes?

__folio_split_unmap_and_freeze_file() correctly sets up a local XA_STATE
with mapping_set_update(&xas, mapping). However, the page cache insertion
loop (just below this snippet) uses __xa_store(), which creates a fresh local
XA_STATE that lacks the workingset_update_node callback.

Without this callback, xa_nodes are not added to their memcg's list_lru,
leaking nodes under memory pressure.

Additionally, because __xa_store() bypasses the advanced XA_STATE and
restarts from the root for every sub-folio, it turns an O(1) advancement
into an O(log N) tree walk for each slot while holding the xas_lock_irq
spinlock, which can cause severe latency.

---

For the stats question: the decrement is done up front, but no restore is
needed on the error path.  The uniform path preallocates all the xarray
nodes and checks for errors before the stats are touched, so it cannot
fail there.  The non-uniform path can fail - xas_try_split() does one
GFP_NOWAIT allocation when reducing the order-6 chunk - but by then the
folio has already been split below PMD order, so a failed split can only
leave behind an order-6 remnant, which is not pmd sized.

For the __xa_store() one: it doesn't need to allocate nodes,
every slot it writes already exists after xas_split()/xas_try_split().
Nodes the split creates are tracked through
workingset_update_node() (mapping_set_update() is set on the xas), so
nothing leaks.  The fresh root walk per sub-folio is real, not a bug,
It may be worth optimizing later.

