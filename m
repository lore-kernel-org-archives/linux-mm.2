Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 809A9C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A060F6B03A0; Thu, 13 Aug 2026 14:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B68A6B0585; Thu, 13 Aug 2026 14:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A51B6B0586; Thu, 13 Aug 2026 14:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 795B76B03A0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:12:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F16541A0272
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:12:40 +0000 (UTC)
X-FDA: 85097041680.08.6D6DE5A
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1D75940006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:12:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mS39I2AS;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786644759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9eHOpdQAE++f+PQ1EojrCZrmxZfxuhwDxN/qbqqDG8=;
	b=0DY+eXBzlK+HDCR1voY/B0I7ydmJffAZjUsozOic5lKZrr8mBjz2FPBA5puMZy5D4289kO
	2JNlezD58cX+M2TVSvi+0I2VHl4wd/tWrC+yv8/H24mfYOCU4ZoV5Kb0LfNsyQ1RsKPB/3
	BgHKXLHzukCOsYwfsd29GhdrAsKJfSY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mS39I2AS;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786644759;
	b=mo7n6ZZ/nfT6tdJvOyM4G5DH/cixUJBJxb7OGhh3DEXPgHUVlRufrehiDM3oVmZA9pB0Pk
	c8P1ehQqPxSmrUtIp+Df3w+l0MfnQ8ap2hu2XwU0Z7D06p/n3WzbdxH0ou9qV1qAOYPjsj
	aoDncL79dH+iYqp5iCGdPY3RE+u1Srw=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c169ae1cb26so230570666b.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:12:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786644758; cv=none;
        d=google.com; s=arc-20260327;
        b=Cmj2JSUchb94TiZTyDru6iB/kT2Ztk6SuTimEEa7ENx+bLNOMNxp6KA1P9dAEDEGRu
         e+ZNVjGZQiTJx6Ba5SDOlm46QjayEVV2zHws+8rx9xQHs54L2ldqLYZ8KjgxR9wSOHeT
         Nr3VkJkf/v7Sz69+BugRJT08Fa8VK+BXUtO1gl/Z9AOQ1P3pQ7lMLpaf+lb62q4NOHLP
         TweiJelbhSj7wzX5ebrgPjy00WDJYChm/QTGTVTLcDHYOpP8ZgGsQpl0xl9xpL2l/nri
         9cY5GNRvjW1t/1KaEzxNAr5jaRW51zpnWcLjEHn3FMTBtyKZWa2vAeqvtkw/IplH/CKj
         QcmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=E9eHOpdQAE++f+PQ1EojrCZrmxZfxuhwDxN/qbqqDG8=;
        fh=ctMiu4LrH7HpDGA6W/13/okPxSD1uxAWh0a2WMBvIy4=;
        b=XVySem3H111ZGtGNF6JG6bVDCG01rkJjES7xhw7sNcwxAkcq5/odno02Rmtzc2I1Xu
         wkmmEGTorHBd6SCscrgr9optTJeFPobLBgC3F1DPCQxTH5ajkFjB5w/r0IHoC39cpJCi
         gqu5JRsB93/qrBMJD8dPmSDZAOT8mXdUjCYPcacumJfrskPcJfVs8k0EVjpjlCjGwpn+
         rTv92f3nfUb3FzgdBYLV2hFDW29sG97jnXzktwddr7IGSDLq3Nj5DLXIQKVeJoLeJOth
         JHhGssmukHEwOnEHXXSDRUKfpMAYmgs79O9kUOWcwxlCY0CwG8d7sTZDpufPVNSQTBmD
         LJvA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786644758; x=1787249558; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E9eHOpdQAE++f+PQ1EojrCZrmxZfxuhwDxN/qbqqDG8=;
        b=mS39I2ASZKRVhbGyA0GdrJtzag73SEz801/SPhXmzGS50+As4IWknbtOrL1RX9RzlJ
         c+AHhWELvWl+BGbN0a8ltkn5FxeS59Y1Nt05YhR4UU3LmNlnq2NbiyYWi1Mc5zwSW7wr
         M9G3NOPNPV5n1zDpb1jbINSt/1OYMSkdVd7zGJrOaB6UkBIoPsLz03i/4EcHDo6QGM4x
         8nvuqXwteoSDbhnVGRK5i6Q89CkhWMxUCi+WPLF0cL/LIdGFJljvY723pAHmZF6OT2su
         Dmp+ln8Cs3gNuBOSAjxKjybXQBwnk9xFDvYkJYtyBgPspisad9O9mlsQF3vXXZNfyNjt
         F0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786644758; x=1787249558;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=E9eHOpdQAE++f+PQ1EojrCZrmxZfxuhwDxN/qbqqDG8=;
        b=GcRXsj1Bp9i82LXMUhPNU2TorNqeB+FaCSd/f07GuTc1KZ4/tnP+NNstnAvzsk/jCt
         0mLcpxROXe3RBI52gfEKCx3RHzhPUv6E4kOSvDltK1DbIqD/aOmYoWYU6g4GoSm82dfl
         toW9fPtfhEFAlDhi22yHakn0rcW4pStT2Ubg9UcJS69HnxH/59unE9WyrVrgSaOKE9DN
         y1PG/L/nNtc7mKvEdbSnNNrVcdNKkLBcGuP+eOvwPq28A1NtLrEC7c1g6SQRontMlxan
         HX4sq6jB+XztDPz4/i80RCtp7N+YzQks4oDGCcKx3OTKM82fthw4lMxn3aUvCoL8nwXg
         EhLA==
X-Gm-Message-State: AOJu0YxIjX2eYK0EGAicaCKJBnlh2WVzJd3u/W74YbfIsAXi7ELzjRT7
	IEs+Dggi2z1snKV6NriRFE3aWXqlzbDGoC29+JrI2Iig1uTjiitnz0eD2qibx8fuTJBxSzMyytH
	uqLFmxZbsL+zVcHEGHpb70yCLhqAB6aY=
X-Gm-Gg: AR+sD10NEKrACd9cUgN6Ba9k9OA1iqVv7kkyXUEoTRadl+2/tzYypVWUu5zbTHpF2EZ
	X6NQnZiMCM2+TUfqNcOxn29PBxufrHxG2NBg1TpyxWCu11egc1qBvWfyDT6FLFC2wKbtedottDt
	dzv/fn36iNeNAudm4hdIkrlYHUe7CA4oMRiHrRFNBu3bzMQk27CAdr9PpLEafg6Wm0/tkCEwpLZ
	BR5vbS/KEr76fpXzaJaR8RSHuNgJCieG0+CSeS+yRl9yhcWKiIdKrLBPj3SZ1pGApfJJ+s46MH6
	OiOhb+kjRNszYj2SHbFGzCzD6EOlipqqAWoswxEbqtcoRJKCcBDPdcyDAzzBL3PdeT6/e65Jaig
	m1w==
X-Received: by 2002:a17:907:9625:b0:c12:b58c:fd7a with SMTP id
 a640c23a62f3a-c210a1eba4dmr278039766b.9.1786644757271; Thu, 13 Aug 2026
 11:12:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com> <20260813-swap-thp-cleanup-v2-4-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-4-d2ee48c6aa49@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 14 Aug 2026 02:11:57 +0800
X-Gm-Features: AUfX_mykR9xfZ1MBJIfQVhzkF1GzfZrxJ2Dr4v68q12t5GUuJLRT6mCC18s7wk8
Message-ID: <CAMgjq7DD=xZutuKuL8+zVnBAaWMO2DHi9kbvHzXaDPZ4JLqt+Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/17] mm/huge_memory: split the routine for splitting
 anon and file folio
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
X-Stat-Signature: kajjm63g54tojfs37dck4oz5zur78pis
X-Rspamd-Queue-Id: 1D75940006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786644758-316036
X-HE-Meta: U2FsdGVkX18NkMiLiLqzFp4VlPOzrLPuddJ6VZjjHyAyKReQ+PmyHT/3GzHOINOZN/1ecPKJX1ALspNI86cb7JkxBv0C4fPYPzlOH+NUt8uW0J3HD/s2HPI/wDBgZ1lUMLy8SQeGm/vmWtbLNrK5o3JyobbUtwSiWAqDBL12qnJZBUz/Qr3OEi9MZTpbMLj/Aqxd7W9rVMokPcgSwwnDVQGZ3eKWDeXfHJo0jStBP7Lelk96xE5XCPf8vyE/pzPg9IsYv6fzb7ZfCUHhDBLyV42DY9At5AcMEHQEZ5tBdzJeigkcExjQaPB0VWXbHe8NHylZI+TfnikPekV04vCW4LMrF7e9Kh3JBiPdp8GuElF1M6LlV9wkMDUTcN2rWhb8h0j4pPoHOi+aqZs6xhmLluxLp4MJic2xXV+ZVVMRgjZXRi+uZ+qvT9tpT4ugjOu0YhQY30yad3KhkpIc9h/dk/4kOuLYAWoTCF91DkcXzEeEK0UTYiIq4zP8aECPGZHSnsiYYNgOECNuYUpVCWY20z52cAetKLlUPaeNxjOWtzFs5i2VsTCnBi5lcjsuZeqc/aJZSSr8GKbs5a9O8Nb4EinsnqdCsQ3eDEwbuNWa7wjYVlfwvnuD/Y6yjKmrdNoibW30IB2EoWUIP2T1V1TBvjBBhsty7vnSfJTtqbW6GTuA4KzS8YY2sgBdX4rwuC5XQYe76gQLs3MYcUGAs8QXwXgBAb5PDBGnQKAy3/mXOaoJySjnAa86TIb+CxgCrauDxYnelO9FeejKsapE3+t/WbiDTtNnMeKyIun0XoG954SzgArX2loCsew7oy7LBRULWAcMxOv3MhN4JjGab85/buwxDRoz1kIMhQaee7ZST/H+NIjCj/gz9Yl7KQmIp6LxUfkMLLtihLNOvyy5PYczrNvDo4tdpfYsWjbJH55oki4avd6td++ejgLmwUOoSs+X+SEFK+zXF1b53gMU/IZ
 7Y0BNR0s
 2yeDMMPRn1cHFce6FfbBixLAJEEkNEbDP9IQC6U1Zcz8wNIv3gzVjGtQhxHpqDo4NvfplLxYI60NxkuOt3HGdjRk8wbt2WLKSga5v7RitnaoxhasmGYavtc94uXtKHmmlzpwC+UbyurUQhC2fZgURgyjKK/QhyVzaX/UFNyxMNXoSIilPvA5gVtxz88PWwqMWck8tzx25hcdQtlOeHOl4LOLwxhiMutg29CbPSeFGFY8gRvLoxdyrJvSPmKxJ6CHwFzWN9f3YW9piKqmduruXfJoA0zGu20WCpsw5NmF9gRk1FbtWayqeUmkGpz3J+YXJ4fEVfXm2/oJzFy1tFsIClQ459xS/ejZfKdtrevriMrGkHNpuO5vLP1NmkzSlHgOSNJE+QjWhFMrByuH6QSwTWC638Kb2ELbydDIcvoNBBltbHi29p579/lAfZrDENTgiRtgIy+w4+Gqx1TVX5qKFXTKkrCcIz4+XTrrsPgViq4AMWzsIEKXPORg04Rv3Z0YCQooisoHKjVKl0RpMJpq2zTiREMb2ZaAMSDTcGBNVckUPrBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko reports (a valid case this time):

--- Patch [4]: [PATCH v2 04/17] mm/huge_memory: split the routine for
splitting anon and file folio ---
commit 249f031b2182770a8cf754edfb3833e148a033df
Author: Kairui Song <kasong@tencent.com>

mm/huge_memory: split the routine for splitting anon and file folio

No functional change intended. Before adding more logic, split
__folio_freeze_and_split_unmapped() into an anon and a file variant so
each path can evolve independently. The two paths shared little beyond
the folio freeze call, the LRU locking, and the unfreeze skeleton, but
differed in all other per-folio bookkeeping and routines.

While splitting, some cleanups become easy to apply, and helped drop a
few now-redundant checks. Also introduce a folio iteration helper to
avoid a common pitfall of iterating post-split sub-folios: a sub folio
might get freed mid-iteration as pointed out by Zi [1].

Link: https://lore.kernel.org/linux-mm/DKJSFCLP967N.YBR4DNK1NM2N@nvidia.com/ [1]

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 7fb603ac500f6..7587eeb09e4a6 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c

[ ... ]

> @@ -3634,6 +3634,18 @@ static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
>   return false;
>  }
>
> +/**
> + * for_each_folio_safe - iterate over contiguous folios safe against folio free
> + * @start: the first folio to iterate
> + * @end: sentinel, folio_next() of the last folio to iterate
> + * @sub_folio: struct folio * to use as the loop cursor
> + * @next: struct folio * used as temporary storage
> + */
> +#define for_each_folio_safe(start, end, sub_folio, next) \
> + for (sub_folio = (start), next = folio_next(sub_folio); \
> +     sub_folio != (end); \
> +     sub_folio = next, next = folio_next(next))

Does this macro unconditionally dereference the sentinel pointer?

When the loop increment step executes, it evaluates both sub_folio = next
and next = folio_next(next). If next has reached the end sentinel, calling
folio_next(next) will dereference the sentinel pointer to read its metadata.

If the split large folio happens to be located at the end of a populated
memory section, the sentinel pointer (end) could point to the next section's
vmemmap. If that next section is unpopulated, this out-of-bounds read will
trigger a fatal kernel page fault.

---

Right, I actually hesitated on that but forgot about it midway. I
think I'll just change back to the opencoded style, it's easier to
understand that way.

Or does anyone like this (copied from hlist_for_each_safe)?

   #define for_each_folio_safe(start, end, sub_folio, next) \
      for (sub_folio = (start); \
           sub_folio != (end) && ({ next = folio_next(sub_folio); 1; }); \
           sub_folio = next)

