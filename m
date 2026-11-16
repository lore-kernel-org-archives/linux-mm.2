Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3697606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bz/YgBxq
Received: by kanga.kvack.org (Postfix)
	id 177C06B00EF; Mon, 16 Nov 2026 10:57:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129596B05B1; Mon, 16 Nov 2026 10:57:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0654F6B05B4; Mon, 16 Nov 2026 10:57:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBAA46B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:57:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B4A6140156
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:57:32 +0000 (UTC)
X-FDA: 85441437144.25.9E3731D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 70B66160003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:57:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bz/YgBxq";
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794844650;
	b=jk6oZxy+JhzNsrlmguQxeAuEvpMQGufFtyynR1FHz/WgpUO+rSwznK04EElRxDl1dj5CTy
	vQxFmTY2+H8Ne6SnaxPPthkVZKf2H955uVVBAGMkuo9apuPnS4ZgvSCskyi2kXvpKy61jg
	6fEtJsQt1DgIGD6vZoqfciUZXVJbuIw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bz/YgBxq";
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794844650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ko62fks3HdUFJERJbaidaf8/9NyAdqZsfNsy+M8rI7E=;
	b=QP4O5vLf477Ds1aD0tJuYEXEX9Quik7XtPglAgjTpyRHbkzlzLabJML9bP0Z1nq83aMRAn
	jfIGliVWb/mN3XPP+c20NEK9iyr1HNWHDRCuOKgvXCeOANEzdJGp1QNyMit/cz5LmdkbPd
	qbBfJGfRj6T7pYfIXt0lIasastvaF0E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E821162CC2;
	Mon, 16 Nov 2026 15:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EBA1F000C9;
	Mon, 16 Nov 2026 15:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794844649;
	bh=Ko62fks3HdUFJERJbaidaf8/9NyAdqZsfNsy+M8rI7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bz/YgBxqC7bQ6A5vwCn5B5zt8h6Vujoe/s4NX9IUNxZh3fgAsCK4uoO92CIfIZodX
	 kCHCtnQpCJPewEGp8sCK8Put3td3e6idPHi8n+tnmPeJEhQwPFr+fzL0Ldpp4EGeix
	 2LFYhlEQfl/ZnYrdXRk+b6iAbzrwzpZB940T2IG6F+lPt7Q7WlNeisA/APYuquMWj6
	 opFt9D/6uS81vz2l/5/E4H7+OOZQeP/VAYuZd0bIoJEOAgh821Q0j+rsVCnWUmlUq8
	 e+AlIoMnw0qtbwIg2gMVprZ08pHnkXN7RbveuRMAsBr7HSyqXD4WgSYALyDbBY0hyp
	 oMGpAbvsyHMxQ==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0D09E198003A;
	Mon, 16 Nov 2026 10:57:21 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 16 Nov 2026 10:57:26 -0500
X-ME-Sender: <xms:4Sf7aiLjdYKlrGwpeD5NINDxohS2dJ_lyTrpJIZoKMOgstVJOBStlA>
    <xme:4Sf7ahgH744rwVK1EyjuOymivLuQfK5MtgaGG2x1LQrUmvqUOMtgTPwdz4UeaAgoV
    mnNgeE9xHqwQicjv0hGgIPb3mwB9uYEMGPbnTUFjCL9AsbXDnhTp8vU>
X-ME-Received: <xmr:4Sf7auvitGg7ZB1hhgLqrZCYGhCBvjsH_dmqXCr8m6_tK6n364wcwa7PROU>
X-ME-Proxy-Cause: dmFkZTGKqzOa9mbkYud3YjoAdT1iCdWHe+MpJQTExtWEpMQAweCMisAu2fcJvNFVrlprJb
    kBiEFF59rEPiAv0vQT4Psar852PZawWsc9M4fGFjohDuxRFin/4q/+8xyQWAbSrkwljSoU
    4rmE+DxE3v+h4LMCrsrqmslUmtHuwueZIa2ex6mJxDPKhC8iaNtNx+7O6aMCXO7zzBmfHx
    SK2XAafreqbFzSu3BJmjGtAd1nt5pcnYgA3x9ja943Y/8VPDiEIGf4si3MQObEeu/3Uz09
    e6p8vXN5Zm+usMe6EV+LZjcFFV9n3iaDNu4UXlB/1Ra30F4Be3puKVA6MJJslCgy3U+dR8
    h0tt9LphgI6AFChLOB+pzUimlXAQL2YO8wShOx5UD4yUyHhCVpF0Es6BqRZwLYi4rqv8zR
    PRfWc2tU2QeZrKAtOgj8cyweAiXt7AVId6Htj/5KppKUt+PZi3Rhuafxtn606pOXABoLbA
    LeKL+j+OjGLLawrQ6H0o8Ww8cPUN31NT8vdtgl0MhAo3SFQWbk1CG4+Npb++EscEFEg5nF
    Jh3R3hst54wGNCqm4n4SN7MCfqlwgstgFtpDPqcieM9sOwUKcAAj++yBpCq8lzzbSrvCky
    JPz1YWZRrQreS18C9iqQvEh4a23aft7kLtIX6nKoig1yVAoty/KS+2PMjjKA
X-ME-Proxy: <xmx:4Sf7ahBVDQeYIVmgdYsjLp3PoRjrOXsf1QJ4cqhnAErySQkuV7EPIQ>
    <xmx:4Sf7aiyQOxPSozr2n08Wd5Kl128TA_4_GRsAD5i0keFqMufCrZuEEw>
    <xmx:4Sf7akHHlkjsc6O07PEaiyz1kXBJxcZwU86lQjOuhS9CSiD2Aw-Adw>
    <xmx:4Sf7apZPOG-7JeZlVXQ8JfqtZTaZacy_nWH6gOIKrBMWoDEAuCyWRw>
    <xmx:4Sf7anitX5I8YkETpY_ueCUQE6nswoO6qv3Dje7kUNQrHIUmpJOoADB1>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 10:57:20 -0500 (EST)
Date: Mon, 16 Nov 2026 15:57:19 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnd Bergmann <arnd@arndb.de>, Johannes Weiner <hannes@cmpxchg.org>, 
	Hugh Dickins <hughd@google.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Ross Zwisler <zwisler@kernel.org>, linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/mmu_gather: delay rmap removal on UP as well
Message-ID: <avsnsRqHQIgeSf6W@shutemov.name>
References: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
 <20261116-dirty_file_pmd-v2-1-571883053174@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-dirty_file_pmd-v2-1-571883053174@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 70B66160003
X-Stat-Signature: 4ee9gfqjjmhubgni6rt73chogyfi4rzw
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794844650-843172
X-HE-Meta: U2FsdGVkX18E+im5HrIQgPOfd6Cj3Te4DIHokcaRyhVf/YDZ1jJfDs2xbcvySc61NIQuSrchydesdfdGwapLh9vslQt5ooTjCSMxgI9Rt4Daw9sMdkBZ18uumCFZgmet1Ee6BqSoh3MvoIErj9nQ3e7us68N10VktwvllQ4TIZqofNAeIZzJhNBxY1Q+HPYBlAeq8Jk1X/+e8e4YLf/cjgR4cu0BIlHBCeM8u/lOQqR4cb51AhqGejPblpjQhhifFbn9O7A02I6UT0hBzVdsJT9KVIAeLX/dbbwQeAAm7vyVuHj9CSFvGYRKDBzY+x486b5u3ZGsWWo+RFRAYrTeAKq6pU6KKkHurZBiMVn+Bqt8snTCfQIq1no22hlFP+DN7hifZV0SoPXB1ihlOesVwnmh64pMkBUi9IEdeFwOKDPgqIbABO4w2hoDZuTi+RiukmSLqy1VduBnExvB1kRBxUMWYfV59zoaZeCyFGhADoRtmXPqakQEKW2N7BaQiHLvU0yuGmAPRW4IXun/dkdr/R3qO5maVFTBNk9fOkQKW4hlrzugssl9waGnjT4gqZqrdCuHHjdoDz5WbPl59IH/bF+Wr1G0oA4axTV3WZkq9EnBUKQTp0bYpdKLJWITJ9I1+bLv9xrZ/iyagD7RrOYJ9j6qbrgiHNi9jDqWGQGzFfnMVOMw2sRzT7Y+5xX9cGyWmRNOOazw1AInBEo1M1TPuJpUw0wejXEryVy9MTrIwDsMjmL70oR4OXdiMNfYZZVbyRbLDhKBTr7tmIA6/ASl9bp4Cu8H/O7ylcPzDu7PwsgMhOzL2gGiemMzvYGQE1kIhRez2Rz0HxQye2i9RElPshFaLP+f/ydUYOoSf+mq+3+tqwmjU+GsBIaFnhiXgErCHnzyimujNMKcc6WFz4X38xhDwgBnqoTYBhJEYHyTAMSmou2SBTcsVn9T0GPXKKJa4d4B9qAV8etwgsmLd4z
 f7ua45Zm
 m/7afclNe6iUzkRbeV5IOrL1VwrQ7+5+MjXf5zLT/I+NTazIvH9QUz5vOOlxGCZgSpxHQ83lOleanWzsrAlUzIT+BjqrzwYXBbjPDy+IRYJhk380ghnzTpcWwSqEsAfPIneM2Ub5SWvn4iQxcp4ROMs+JMOKkORO1yDoqplzOnVaprf3rQsC4SUeXz/x8VhdmknbPIMG3FfRP60XJy1JDj4HWbiuZTAmfYFCY72CvNVlvfZmZIeYGAkhd7LVO2sU5V9kWptGCQDacJjxbrWEQzGI0aAl9YzMcapf5WDJwJUcMdgknLRoN/xRAxYSEEU703WvvSt741FHSDSiXwQ49NlPO+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 04:06:58PM +0100, David Hildenbrand (Arm) wrote:
> Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB
> has been flushed") introduced delayed rmap removal of dirty pages until
> after the TLB flush, so writeback cannot clean a page that is still
> writable through a stale TLB entry.
> 
> It skips this on UP, because on UP there are no remote TLBs (single CPU)
> and because the PTL prevents preemption.
> 
> The PTL prevents preemption while removing the rmap, but the local TLB
> flush is usually only performed after dropping the PTL.
> 
> Consequently, after dropping the PTL we could reschedule to another
> thread of the same mm, which does not flush the TLB. A kworker could
> then run into the original race with writeback: it cleans the folio,
> but the other thread can still modify it through the stale TLB entries,
> and these writes get lost.
> 
> Fix it by simply not special-casing UP. Now, only architectures that
> select MMU_GATHER_NO_GATHER (s390) will skip delay_rmap handling.
> 
> Fixes: 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB has been flushed")
> Cc: stable@vger.kernel.org
> Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Link: https://lore.kernel.org/r/avrxOt_GyXLXNqtR@gremlin
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

