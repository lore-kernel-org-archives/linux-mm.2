Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA757C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1065D6B00E2; Tue, 30 Jun 2026 12:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068756B00E4; Tue, 30 Jun 2026 12:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73436B00E7; Tue, 30 Jun 2026 12:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD4206B00E2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:42:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A9ED120576
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:42:15 +0000 (UTC)
X-FDA: 84937146630.11.89BE8E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 298C340002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:42:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mpjj1UpA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837733;
	b=DgW54M+wORzICPFhce5j0zgZ1MsdopSTconeSShU7W5gTuR785XynOevGyL1rD6jxEEWiB
	4UX/1DFv28GHD9H8dhWe4cs27wPq3SJwSDvK3aMln8Lvw0N7IaLnOeafs0mEs3EkEhRcDx
	Cs8Rbnfnd758tXTSoFc82t2QPAwdMdg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGaQANRuz7ppZV2PSxCdI1jyGhFNKQCFfZRkpjfHIx4=;
	b=CdYcp01a4v1tdgutW5P0OQWrTdE5tJygkUz5X9aRnf4ShYNx5zNXoE6LDjGrCo9lMYU/+e
	KiZcuT/5P9CozYEPK4o1VfNfafEBHCkyOvpv54gKutgUWgtFG7tlu7p/3DkLKTdZjIh2Za
	pl+xKVR2siukESfNTXmq+zcqgAcRw4A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mpjj1UpA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D328D43C8B;
	Tue, 30 Jun 2026 16:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ECF1F000E9;
	Tue, 30 Jun 2026 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782837731;
	bh=FGaQANRuz7ppZV2PSxCdI1jyGhFNKQCFfZRkpjfHIx4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Mpjj1UpA9JvWJDddJxrWhkw/KgM7NeF2WyUc6ixJCeX2ovt8ol68V2rJtBbTDtFT8
	 Z3cPZHdMgHR6zxn+yzaF5QBu/zgeJa8rHKgCHWal563uBDK9MIrN+LfWBCR+uPMIzn
	 TP2mR3hru6thL0WQDc7fJRQeuMyyCvOHj4WhMkdLmYrA/GIo8ktjRrxZg/PNw/51q7
	 W1ChdE9N1cO+m+vXnjmwi6f7WU7ztLvqVWettq9woeTZNmbmwsgji+rmzjbpXB4EYS
	 9BVHOhiuEUkBE6N41SiXWiAXR0daUye9ldy5nfBo5xfIchE/ceRZdcnk467CQ8x/iD
	 JsDO+oNp5EdeA==
Message-ID: <ff2afe47-0e0e-4fd1-acb3-8c715aba2f82@kernel.org>
Date: Tue, 30 Jun 2026 18:42:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/16] mm/page_alloc: relax GFP WARN in nolock allocs
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-6-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260629-alloc-trylock-v3-6-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 298C340002
X-Rspam-User: 
X-Stat-Signature: cnj97nhdp5of6sr9b8f18cqmu4irfdwn
X-HE-Tag: 1782837732-181792
X-HE-Meta: U2FsdGVkX192Ifb2aF6GHzu6NkX0iljXm0kjUZP1Knjb5OG4BuVrSFZ+kMJO9R6COvtdb1VkOp0pSHp6PufFw7kShBnuQkQPIEv67naG0sT/iO8qKPjWfv/YGR0/uZDkLGh2IpCY8elyIRJzIJtgwiRW5q7ESexM2zIEZVl3VbMn0wBt4+3sV+vkNZUnIpdMHKOvxtXHK4RTVelUlSZgPd3LAX4YqOpLgpdj4OMZlvnY7g7DZq0fYuSiVfRKCeObib5um4K5skvGVjyrxMDsADFInBTyyy1x3+b2dzLPPrHau7qYg1B/weoFqzpvQgeUDgjoty6UVNt3OCx1k6wk7+5UwZd6gJzvlZK6M+2Hy4sRAeeFEGHyA21rNgIqFndoiOJXu6bPGTDa5OjKOVDpV8YXA8TvzpA7v7hO2nTAZOOw8By4c0LW01YF1sZEr7E8SlcMxNVRQG3+LbE1tw258Piuzrn8ho2ACWAQqIs5hbuKp02SLd99upGKAEZr7SEs9tH7FprpvZ+aRiFO+qhvGyHqFWO1gr7MtxLi/zJW0u/g1SgvpSZZVDIF330TP7WwD4z+tqDHSl8/hkFpg09sf/NEUbgLUQKanTctmpKB4p/Oi0cqh8/hk3G6VOD60tgzpAEJ3hFjZnher87sV5V4yKls/ozt6iP2GpSsVJBdLtnAK+0o7/K3MgqH/DibHYeUWXcnxAEH3miYPLMBVqYD+Mfiwy6A181Yhv0qe/Zy0Uzv7G6h1oSSzzImTmwvHmRbIZBtrsX5ka9oIQDa2w+yUOxM5lxOfKXOoFgC2Bh74UIaFlCjMRQMAj+bl/5aj3y3/jV2wxSr/mDHbwVu6epIFCYDgXzn6zVorH5iv/xVNFYcLWxbjVaZsZglo/8spQwg8aR3G8V0pe+58VZ2fFGtMw1ZNeKYJ57fAD8BRcBBB+fi/8DdxXl6aToUYS1QI1QVoS5lEtT6IcuKrueSBuJ
 9fg9N0Cc
 QPve7/nIR6i3uR5hhu9SrnnVZD1eEKst/+tHvOy/RgtjovpTgKQWVYXIQ+INu460bHhHkuhUugqaIcLD9ZYFRlfnbDpNl3YybrbFmtVfaRVf4981cIKOKjoXunzhNxkeBbKUEHtdQSiCD87wZvdclHnxe/i4xNQa44vcNuK1M2nR+nm6gBy22PLZJIE5MxDxJgQM0lFXlJtc4JemcofRaKYKF5rfoHD5VzmYKoZ71sdrPU4SSq2D7AIvwK/JlJm+9k3K4Hoxl+eAnu9NDbUYpObzXTR4OzzKQ8wekW4zMpaaCyCOutvx3AJHTGRyoAXJqVhD+uIHbchAMf/pYJUEsxTTKKlD62kh3j3I8w3U/d3hCcWviUiXpmYLAF/3ABe2yxBjlK072ypLtLWNtYghkn/c9Lvokzwt5HCzxofpaQQRhgrwcVAMF6xIuYyvqWe9Nwupzn3jLtiLRrYcPjt/rsm8tPfL4V33om561BHHZTHwdtMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:11, Brendan Jackman wrote:
> This WARN forbids setting other flags than __GFP_ACCOUNT but we
> unconditionally set the ones in gfp_nolock so they are certainly fine
> for the caller to set.
> 
> There are other GFP flags that are almost certainly fine to set here;
> Willy noted GFP_HIGHMEM, GFP_DMA, GFP_MOVABLE and GFP_HARDWALL. But,
> nolock allocation is rather special, so be conservative to try and
> ensure we have a chance to think carefully before nontrivial new
> usecases arise.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Link: https://lore.kernel.org/linux-mm/ajS96fWbG4dzP3u3@casper.infradead.org/
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8d409d075e3e9..9cb3f1665b41b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5355,7 +5355,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>  		return NULL;
>  
>  	if (alloc_flags & ALLOC_NOLOCK) {
> -		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
> +		/* Certain other flags could be supported later if needed. */
> +		VM_WARN_ON_ONCE(gfp & ~(__GFP_ACCOUNT | gfp_nolock));
>  		if (!alloc_trylock_allowed())
>  			return NULL;
>  		gfp |= gfp_nolock;
> 


