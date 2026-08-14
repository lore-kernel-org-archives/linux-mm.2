Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D687C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173C46B02E6; Fri, 14 Aug 2026 03:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1541B6B02ED; Fri, 14 Aug 2026 03:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088AC6B02EE; Fri, 14 Aug 2026 03:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC1146B02E6
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:19:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D8A6C038E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:19:26 +0000 (UTC)
X-FDA: 85099024332.08.45F40B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 580EF100003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:19:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EufttVzY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786691964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Od/M0sS38B/IAHXIIur4KlaDShFpToMSCwBEwlqqN4w=;
	b=AersPdn479mNHFhv488Fz8mX7XEgYqg/ZV63HMV0X5NxSwZMN4xwzMX/conu/Yh/XuFrdP
	vBjJUMBFbvvT6XlHpGoo6r2ovPp+oUHbU68FLProZ+ZmyYiF9VS/0+aqn+rBr+E+PZB+lj
	r+rMOY0XLOVKT+1/Bv4MM+HTertZ5Fw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EufttVzY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786691964;
	b=RSJrlqQajs7qPy4tjVyGcGf1/KOZrsjwTj1pT1WqX0gWmfghSiUyONkJfl+vZsZI4c+YFX
	HvEMWLNfuzipaixU5DG8yZK/Txs13J3Dl5K7d3j1J/c5HSk6j7/87KAEEHFish2R4zJqNX
	W/zTDNHMM2qpqGgKP3XJfsEG4CAuX3U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FBF743EF6
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504291F01558
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786691963;
	bh=Od/M0sS38B/IAHXIIur4KlaDShFpToMSCwBEwlqqN4w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EufttVzYSD4hOq2ld3LMwDFdOYGxvuwOB3FBSW6GFLaOcLMWHpHPWBcjrfGvynUGb
	 UGj2Ljd++nUZslpco8vP8EcpCqcnLXxVZ4kjfzTqSZhMGrnyUtdtp4g2iLTb7r8hPb
	 rVXLmpe+OWDrLXj3KL7hmveNr1tb+IhElZbifanzSXFheJTXiGpTTCl7klVUKYSnJz
	 lNEF0vlm/bnpgZdfcZ6OtI1qr6NRN9E3brVOaTJVuk9ovCH6py9iZMj8+kuz9G6PTL
	 16XkV5kJVADwU8R3/EbvYfaOq9ePgBoukw5WKCl+C1b+B33EEuUSJtVxxwtkqtVtQY
	 uScdEjx3s9Hgw==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-908239232adso3326866d6.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 00:19:23 -0700 (PDT)
X-Gm-Message-State: AOJu0YyjbQ+lvjPNFE+Sedni8Z4IV3aqTzimoHhU5OPRhNTWoMJLvLjF
	NABIuefVAw8bcio57exEA6H6ZS3JzffodACjcLlrNi8VNnVE6OgxQj8AcHKvF9WOGx5052Q0b/1
	CRh5XgmJrlgCchcPntKu1zeBHSw3WlFc=
X-Received: by 2002:a05:6214:459c:b0:90a:5779:d30a with SMTP id
 6a1803df08f44-90a809e7e4fmr129248456d6.6.1786691962682; Fri, 14 Aug 2026
 00:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com> <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 15:19:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zVhK9SvHEd+OFAHSu-OgTiAtk-ZU5OQVx5RwBYmc9r7w@mail.gmail.com>
X-Gm-Features: AUfX_mz2XV1v1iX3UNY8IBmbo0jYMTf1B8XkecPKEj6nl8GXRPWB8QN2pO8GcTc
Message-ID: <CAGsJ_4zVhK9SvHEd+OFAHSu-OgTiAtk-ZU5OQVx5RwBYmc9r7w@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 580EF100003
X-Stat-Signature: 5tyejsn4qibp3z4gpg3pxzxnzaz9ywc4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786691964-1395
X-HE-Meta: U2FsdGVkX196YrtV5KMfSRIIIWK1PYxlGSfOBYpNqKv1u4uPBSQGQX+A0JBidZcXHOwpGaKJgtMgT7PhILCvrMRUPC6rR0P9qxvrvvm5DWracvKv/WHDAefr13xFUXxTL+VWMLtXM1ZEVhG/SN5RlxFh6S1g7VMCuv878HsESbhzkzqWqyZ3W7ZQGop1OQUgtKwae7LnSiOLHVOgea8Ou30ZYKgse1C1uqxLpP+aI8bMIjN7hoCbzqhx+SaSZ1bKmJ2h4lR9orsox1KF9Ijal5mXNNfh53/Dsz4JpYSxyovsszGRDCb6RMn70oCzf95gpRON6wuww7SFNd7PWHZoJGIqJjNmShkPrL7K2xd1RJTCl0bPe9KD+dNXYLQPLkTy7FLGNUdmSBWWI5yYMlG1x3/kmH7frJtFb9rlZ7mnMCfURrDsspw0fTgv68nc48KJ//CdU3APXiTJDPqagrmc1BN2sazXNw08OQjqjtw3VLH5QTfUsEiZasHUSxS6IcOKl6hgABF+hbBORFPAYUSXsgmNlGGyoL9uaJeyRxRc+ljvv7P8WckI3pchUAVKS6p3oTFafG9Toy/HlVXoJ+tzO5Oo2oRq+HYBbOCVBQIubKjFZwI3hMwE1A53jpMoww2yT5vYq595RlzjFoJr4mVgedjX8m20UHpzTosLQkdI3vVmm75x4TDvJ42lVdldZBPHgFiMQSmymL30O7+8C2kiEcAofEPgQjlRMx8/MY3z6Q+WX9mcFPv/fd9myDyenlhS0pj68suOlOKjr/MzTT1NoKgNEEJtyKfv4RfTm0QkMx+8vLmw2Kl3W6SUf+CWkTyxoqLUhdqax9LameLdO3Bar4Nx9476S16WDjZVmKESSycyALbyW8wGrBCuUrvmd7FgeKu8EqicSg7sdn+ATrQ/6uPPbKOGzquhTQGpGz4sAwM2rPXeszxHY8Mylk20mJ9u6TQpXuZ48ieMH4qz4s8
 b6fQTtkN
 0oc2Szu3J9DNx6Yjy9ndKUW2M8o4pem6cFm3GsEbi2Wpaa1FRFTfPl3tAsr7qzB8KqiWrrNEd1Guyy6oS6Qd5pOXQ9sCSc3kSy+UWHN1DP8FH+cfeh5/jQO+ThUAZ9Peqnvxh3Ck0iBL7OnvYwVBDYrinvEkfIuYbRlwBEy5bgcez1q8bnFV19FVW6lSf8toBlUFkcItlLfOWSciPIB//qHvrWkbcn71vQZN5nrvvxH+ijNuzqq2kF5S6XMOao9UiI9aNQ2C6c8iZNZU0SovOvRL6Nuzn2Td84Qt+8YplihX8j/VGoQWuDjGyJp4/oTK7X3/tPz20soC+Ekc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Complement MGLRU's eviction-time tier-PID protection with access-time
> frequency-guided promotion.  Introduce a unified set of helpers built bas=
ed
> on referenced (access) count of a folio.
>
> Each access increments a folio's referenced count stored in folio flags
> (refs), refs still mappes to a logarithmic tier just like before, but wit=
h
> more formal bit definitions, a few special thresholds are introduced:
> LRU_REFS_REFERENCED (1), LRU_REFS_WORKINGSET (2), LRU_REFS_PROTECTED (3),
> and LRU_REFS_MAX(7). When it reaches certain threshold, the folio is
> promoted proactively instead of wait for the PID controller to kick in.
>
> Also simplify MGLRU's usage of PG_workingset and PG_referenced, now
> these 2 flags are purely used as the lower 2 bit of refs for MGLRU. This
> doesn't effect classical LRU in any way. This will actually simplify and
> make MGLRU's certain metric reading more accurate, and reduced MGLRU's
> original tier / referenced count bit by one since only one extra bit is
> now needed to record a max referenced count of 7 (previously 2 extra bits
> are needed). This changes make sense because MGLRU doesn't have demotion
> so these 2 flags are never separately useful for MGLRU.
>
> This addresses several shortcomings of the old model:
[...]

> + * Update the folio's lru refs indicator without taking the folio lock,
> + * isolation, or lruvec lock. Used by both page table access (@is_fault=
=3Dtrue)
> + * and by file access (@is_fault=3Dfalse).
> + */
> +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exec)
> +{


This is really hard to follow, especially with call sites like:

folio_inc_lru_refs(folio, true, false);
folio_inc_lru_refs(folio, false, false);

The reader needs to remember what the first true and the second
false represent, which makes the call sites quite opaque.

Could we have something like this instead?

#define LRU_REFS_FAULT BIT(0)
#define LRU_REFS_EXEC BIT(1)

folio_inc_lru_refs(folio, LRU_REFS_FAULT);
folio_inc_lru_refs(folio, 0);
folio_inc_lru_refs(folio, LRU_REFS_EXEC);
folio_inc_lru_refs(folio, LRU_REFS_EXEC | LRU_REFS_FAULT);

BTW

