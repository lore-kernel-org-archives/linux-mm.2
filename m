Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97FC2CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 13:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8CD76B0399; Mon,  1 Jun 2026 09:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63D16B039B; Mon,  1 Jun 2026 09:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0E76B039C; Mon,  1 Jun 2026 09:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89E896B0399
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:21:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A3A1A06B6
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:21:48 +0000 (UTC)
X-FDA: 84831406296.24.479F287
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 689C7A000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:21:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VS5JAOKQ;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780320106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=io/nWNe86lhvjJWsubKx+bggG1DCxvRqyS7n1xMOY/s=;
	b=N42U9Tk6ckD2G+JhM+978n6NdS2eu63hKfGaC0ONAJczbwkhHyv5mqQyZ+9f2zkqBiS7Ne
	esaDHUZZGmZ3nWQSb21Vkk51TyNSne2bx7buzbfN+Gm8jAYVIg6N8NFhi2YnqYmkAMp39U
	trO8FuQpcXoooNKXNSgcAtqNvgwrjJM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VS5JAOKQ;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780320106; a=rsa-sha256;
	cv=none;
	b=3EclRb0pdtI2wob13KbdhqV3jBw5ZQjmQBFtiisWJMVNv/uQXUGAMjXy6y9B+JOJyuf6+w
	SkAQ66hfcav7qpNOewGsN02mUfeLHb28yX5gHa7Svd1RmHpiq+PahFzSM5Yr7+Hs57sA6I
	ushGCRhsYaQOkDTzoeVqW+w3SyWvPSA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780320104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=io/nWNe86lhvjJWsubKx+bggG1DCxvRqyS7n1xMOY/s=;
	b=VS5JAOKQy+tQJA3X0tyQ+VPzBr0usyd3U2XwNbpi+S72w1R3mZ0hN5nhEjzmdeRGKdqsIZ
	ml1rA0qowCaJ3Wb8Z7oks84ILx8+GdHCezYkfd1MjmySVCDLBuMExOPVCJSy0/4XV/4a04
	bnannMrYBKhS4p10E5HXbvqyDtBo3RE=
From: Lance Yang <lance.yang@linux.dev>
To: hannes@cmpxchg.org,
	baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	qi.zheng@linux.dev,
	yosry.ahmed@linux.dev,
	ziy@nvidia.com,
	liam@infradead.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	ryncsn@gmail.com,
	zaslonko@linux.ibm.com,
	gor@linux.ibm.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	npache@redhat.com,
	ryan.roberts@arm.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Date: Mon,  1 Jun 2026 21:21:35 +0800
Message-Id: <20260601132135.14272-1-lance.yang@linux.dev>
In-Reply-To: <20260527204757.2544958-10-hannes@cmpxchg.org>
References: <20260527204757.2544958-10-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 689C7A000C
X-Stat-Signature: 6kss66igokbjup55y7pgnn1cccf1tw3j
X-HE-Tag: 1780320106-654296
X-HE-Meta: U2FsdGVkX1+PXeaIgIhMKI+Up+JyVdVwzTq7+EWn8V9uaEZWjYsb1Lsxhup9Kd2PSfXi0Rbo44Z/7Kfs54W7WWXRzoE4/1AZKZRhXoQpq2wjUd1fRwxa7+ZqF5ba9rPfBN3sE7VVCa6nzFEjqrdn35lk1ycGq88QjTRAJIGJuWuhzqZkqTLjUFuCw5z+OYSoXz4kMJUP0H1jy3/rOhTXn0uA5mAQXFt40/Yyt62kEf+7eUB8n4PCco2gd5bDQrn01WePpoYld2DhSz817TcBPcU5CksRjugjp3jk3I12/0TA3mhUDZNBN8N+W4y49FAjPPQuhtfJckYFHb/3F+2gJ39C+yHAQyluKZmPeSiAHSks3diQCGfeqGAlumRFYYgYLWWkjw6CdndoO1Up95+bcssovDUs6qM3J7ooARdqrcT1obZi/dC234XNW2dFPTKU63qtIcbgjduBF+BQcsmCV6Ykag7/hTjY/cjAMZDT7LciQRIeeyo0O1teUu5OSoKTgOqgBUJuEtPhLUCwroHFX/xl1I5QCl+PcSeKEycC//m/mZ77K2/dPC+oMRVl548BBxOw6+Pqv4T6HYAPP1OmRKRlT5qJ3Aj11ys0PX656izERjszi/Zi6TmySyGjHbQ47YTMwGzeNpi+RXg7jHd/Jk2VgM/ap/GoIeg7JrioKEy35MeDeMVkPMvWACb4EeQ4Gwza0nmKuw71tsyfPNjkarkhfYnBcy/OMxsaWeB9I56v3WK0NynlzaXIroTVwqmbaECewpRfQvq1JGQCIN9/vbjerPUbdCJJvbnhZOSWVIjbCiWPmrNeFIRU1cmIdIazXK7kyst9tPtHvdSZ6Db2NhqfSkQgau2pBfT76ELijWSoaI3txp0jNUy+Rswvp9UwHDiXWfK6ob0agcZKA9MZ7fkQi71BTJQie3QAa84rsbeUkzg3wuLdl9JJDu+FZl+uZ2AeM63XU441aATAhUF
 +13zx8zf
 lDGY85eSurV+TlTvzSR1FNco/MMHeg5MHQYLGxJlAH+mcPPshuYIzKq7k7a7F3OoSmTh7MUsFqWqptOjZj6DXOUcNVmGRTMUuf9RPR1Vt3RQLv7Ajz6hCAiI2/SOdIwxZFSG8xfosOIufmW8HMehtD9yC/H0b31S1/cRozF+W9vMO8MxpTGqgTF9gbYKKE92HEYqYabkHGFq88gpIx/G0bm8ABewYrsxl4UFtxUPW/ehzekh9VHWQbaSmTEiJ5q6uIXf+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, May 27, 2026 at 04:45:16PM -0400, Johannes Weiner wrote:
[...]
>diff --git a/mm/swap_state.c b/mm/swap_state.c
>index 04f5ce992401..9c3a5cf99778 100644
>--- a/mm/swap_state.c
>+++ b/mm/swap_state.c
>@@ -465,6 +465,16 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
> 		return ERR_PTR(-ENOMEM);
> 	}
> 

Shouldn't this be limited to anon swapin?

e.g. vmf && vma_is_anonymous(vmf->vma)

>+	if (order > 1 && folio_memcg_alloc_deferred(folio)) {

__swap_cache_alloc() is also used by shmem direct swapin, so shmem can
get here too when handling a large swap entry:

shmem_get_folio_gfp()
  shmem_swapin_folio()
    shmem_swap_alloc_folio()
      swapin_sync()
        swap_cache_alloc_folio()
          __swap_cache_alloc()
            folio_memcg_alloc_deferred()

@Baolin please correct me if I got it wrong :)

folio_memcg_alloc_deferred() itself doesn't filter shmem out either; it
only allocates the memcg list_lru metadata for deferred_split_lru:

int folio_memcg_alloc_deferred(struct folio *folio)
{
	if (mem_cgroup_disabled())
		return 0;
	return folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL);
}

Since deferred_split_lru only queues anon large folios, doing this for
shmem swapin doesn't buy us anything :)

Maybe I'm missing something, just wanted to raise it.

>+		spin_lock(&ci->lock);
>+		__swap_cache_do_del_folio(ci, folio, entry, shadow);
>+		spin_unlock(&ci->lock);
>+		folio_unlock(folio);
>+		/* nr_pages refs from swap cache, 1 from allocation */
>+		folio_put_refs(folio, nr_pages + 1);
>+		return ERR_PTR(-ENOMEM);
>+	}
>+
> 	/* memsw uncharges swap when folio is added to swap cache */
> 	memcg1_swapin(folio);
> 	if (shadow)
>-- 
>2.54.0
>
>

