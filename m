Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C667CC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 21:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7B56B0324; Wed, 12 Aug 2026 17:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61386B0325; Wed, 12 Aug 2026 17:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B666B0326; Wed, 12 Aug 2026 17:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F79D6B0324
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:26:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04438803EE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:26:17 +0000 (UTC)
X-FDA: 85093900836.15.228462D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 523C6C0006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:26:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2YhdIKZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786569976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZ14OE14W6R2szqcv6OQ5JAU2OtnvGYenTEQKteSjqE=;
	b=WBe+NmnKwvMVoWbU9IgJps51mXYk593TKmKAY1wThRNOnUSMQn++LFwVTZuVpgCsM2G27S
	ArvS1+NjaS4LvxWNT1SPbvbruKDzLxk6CJbkDeuMtyaQzXG2iD43ODDuR+/7p+7oQF2Ela
	vmUvlZO8XYOZ3bKcL0tsW+HJALukvk4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2YhdIKZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786569976;
	b=DHKmTiplzi7jnlEUamkQNc+vXd961N+s1MHxzsKzBJeL2x/eGQEbhUl67v8bJc3WvBJr4B
	C+txR7KNgIXiGul4qGxUluaasKaZwLARa/ezUnLdXn03artnaBiv3f0YNbxlEtByLJA4Pz
	L8qeuvJ+rvs2o/rfRRFZ7TpDXqU7dNM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 635B1410C3;
	Wed, 12 Aug 2026 21:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D29A1F000E9;
	Wed, 12 Aug 2026 21:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786569975;
	bh=VZ14OE14W6R2szqcv6OQ5JAU2OtnvGYenTEQKteSjqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m2YhdIKZxPGAsE+fyk34oqW883dfKuKiM1yKE0mJVGS2lQwD8/OrByY100MokqwXa
	 Ui8q91vgTqLDqi8KTyyPp/zj4LtPF3tMAmTdQmlgVM4r2GGtVrbK6rXtlQsBOLEQcr
	 RHOHOISwF/eSVkuxn5eQiPiLv7A5Q2TcngViLvRnwiNdpYYUEKXsmPRw9ChiAUK3Xo
	 c7L+zq85vvflb41d3lsfvmBH25k84bhHT6sG+tn/T5x+BOcl75Dpg2kND8t3sVPZps
	 dJ1vy6+ueDy8OVBjVZ0hGy2fWhqlsQHEr2Vm5E15Yd5ApSjex3wTitm+7p+n7cUq72
	 S85UkV9Tfkv3g==
Date: Wed, 12 Aug 2026 21:26:12 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED
 allocations
Message-ID: <anzinNUA6ZASDnvA@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
X-Stat-Signature: imo9nobxpwpdbs51si8kayubw6z1jojc
X-Rspamd-Queue-Id: 523C6C0006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786569976-241830
X-HE-Meta: U2FsdGVkX18BJPd6+2tcAg2TIaQZ7eC63rl+RJAuge9ijTJftI6RmoYOjC8wWoL3uK9qM1q7RHdUcoTtay+jQeJZztt+UdBFb4WQB7AIYLw+cQVUFB9kX7dFpq7XAEpUnAww91+TBGRDpee2g3gaxiGMWfRp7ejAFVAVk5wN4HyfohveO2ME8wIegVm5C0L5q9BwCDI/LbqVMhjAR2b8yndMD/x2D407MeaI3RNl9kogPh8A8A6eMq4AL5lKpILSsCzvSrv9eKQllVWu/FxziP1abrdv3Z/N0/tLZTjuBNKhx/UhLMV22BDNN6Pgpb/+OffBxBak+MgLBfgNeXUyIrvPw8l4w+c2LvrwV64mO1CxV/sQdYE1jMUlKC8gFXyR6WxpVLVm95dYM+soTfLPjAMadxW5fX1gNsnGn1xJPE3oBokrareIPANCgqwx9L/KRY93HnqUUJpsSxY9IT2+sn+zvmuGRzOPnAMhDhisbW4trXMW41ARdDCARl365jRe3FoYDISWyqUWwkaGr4ewOvID+drbcVXTjgt8lr12kWyMQKJfxlqoHyZyN/02k/kjbHxXdho73rArIOG6fVOZXXBeVxYjaqVjGm6r7DURvAGOUz9A0O5mBsKRI64DUOzXdHVUh/BWNpUSKEgRFc6V+L2ednfEimDfo1uuyy8h8ogsBfUrMNjF+pxJJ3fsCrLwlNmED/N+g//+rsT3AJLGF8L1Zygnksm+NPVbXmkzxNt79+bDAWBpp2MdSB56eBEIaVvi7N9C01A7jGNNJtmJzDta9PzpDVs2q4UkP8cai2Aowtb3YFWXe5A0g4cc4JSsEeqiU5F7HNob1lCz+2OOU/g10Fkn7/bLCOvstscpz8Ew3jDb8YJ+H/A7L1PlETt+aDq+Y3HfLvH3k0noeNvyAjv/BQHSZEyKMxfdLz5irt04jz4sk1OhlZdmwTEG5Fg2AU1BQ8oP06a1gQjq0cg
 fXwBKigE
 cogdEVrrUCxKinW6/XI7GQhU9RjN1dJXiv/21JBS6srtMzAC/PIoe7WIcI1t+aguoUnArfPxv0OgPDO5EeJ5nYoMhfP8E3H2r2kAZp6+8lJgYFxEAT47hoREm2E3gCmPcOxciTJUti6foL8IXL+M9z42xFO7yc90o7/YKuzcgKtrgryiobsRl07oatUYNr/vjhcq6NWo/2OfQZmxpCTptsivJCzJvTQ10Z0UB45+mFjqHQUzE/rtM9WSD6zDYKLrgx8LUoRDb2LnMDSHsPd34Bb4B4usWSMPlLBxAxuRGv4dE24b7TWNWynH1Zm+Hmpfs609kvWX2IUV1ljGksI6FVb5myCHKNdMfzQZ6ewECUHQGIpNbl4sToZMK1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[..]
>  static __always_inline
>  struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  			   unsigned int order, unsigned int alloc_flags,
> @@ -3433,13 +3580,15 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  			 */
>  			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
>  				page = __rmqueue_smallest(zone, order, ft_high);
> -
> -			if (!page) {
> -				spin_unlock_irqrestore(&zone->lock, flags);
> -				return NULL;
> -			}
>  		}
>  		spin_unlock_irqrestore(&zone->lock, flags);
> +
> +		/* Try changing direct map, now we've released the zone lock */
> +		if (!page)
> +			page = __rmqueue_direct_map(zone, order, alloc_flags, freetype);

Is it intentional that this is called outside __rmqueue() and doesn't
cover pcplists refills through rmqueue_bulk()?

IIUC, we will never change a pageblock to unmapped to refill the
pcplists, so the unmapped pcplists can get filled in two ways:
(a) When unmapped pages are freed.
(b) When a pageblock is converted here (in rmqueue_buddy()), if the
    allocation only consumes part of it, the new allocation might move
    the rest into the pcplist through rmqueue_bulk().

Does this mean that unmapped pcplists are less effective in serving
allocations? There is a tradeoff here because converting a pageblock to
unmapped is expensive, so maybe this is the right choice to make, I am
just wondering if this was intentional and/or if we tried it a different
way.

Actuall, THPs are not covered by scenario (b) above if the pageblock
size is the same as THP size, as the converted THPs are always consumed
by the allocation, so the THP pcplist will only be filled when THPs are
freed.

I wonder if this would cause a problem for THP-heavy workloads (e.g.
guest_memfd using THP, or any THP usage with ASI).

The other thing (that I probably mentioned elsewhere) is that kcompactd
does not produce unmapped pageblocks, so it seems like THP allocations
will mostly hit this code path and convert a pageblock to unmapped.
Actually, if we do bulk conversion to unmapped (e.g. in kcompactd) we
could batch the TLB shootdowns as well, but that should probably be done
separately.


> +		if (!page)
> +			return NULL;
> +
>  	} while (check_new_pages(page, order));
>  
>  	/*

