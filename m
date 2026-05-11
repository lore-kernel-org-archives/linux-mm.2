Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48B13CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE686B00A2; Mon, 11 May 2026 10:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F8F6B00A7; Mon, 11 May 2026 10:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B4C6B00B4; Mon, 11 May 2026 10:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 551B86B00A2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:59:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FBAF1A0164
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:59:52 +0000 (UTC)
X-FDA: 84755448624.30.770FB98
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7E5E740005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:59:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="T5ZER/B3";
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778511590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7h6hiVH0/NZ6Qfi9mJnbfpbwuzxv04Y7rZxb6Vb37aU=;
	b=zTSc8PaDrkWzvmPFqi8MLDu6l3xY8xfHV/VjHjM7Na1FT7dbJ58xlPXoHbU5QPGD1f7f54
	eeSYZEOxI/2jq9vzsqLAtkRodXkEK+xeLI4WFM1tuxnCfgNF059Mypnv9ZFttSAyewGW/8
	icA4Eqt3oawr4K72Tm51J9PXdXjfPZ0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="T5ZER/B3";
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778511590; a=rsa-sha256;
	cv=none;
	b=A1fFdmlTbmxTKecm9W8mrmG2xX3RWawTvQnv6yasnRaQ8qj0ma8nADb8ddxm0Fse99V0fd
	+BolXIRvpbbsfgLlJ8fqEA5miO9nxz8xbuqrLKVtuTCopG4q0FyyMvcJfU05S8UBgVwRpX
	pjmQUCDmqqEtb4BV4R6b3rfTnOWWCBQ=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8ef2118b478so449804785a.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 07:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778511589; x=1779116389; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7h6hiVH0/NZ6Qfi9mJnbfpbwuzxv04Y7rZxb6Vb37aU=;
        b=T5ZER/B3rihujIwPOcmH8hBEYXcab+G7Qxwy9frdsYRMCBphdc+9s5wsgKmTDMrPjv
         5eYcVsP8399y0aq3KYGA9IVYSVMzl6aANS4SQK1SLZ63ZqogQ4oPij2fYfVYeCt7m5mo
         CjCNSpt3Sj8VK2GTU7ElQjYybpz2XsTsww7wJspqY19ZetMgjy737x3WKUxbxneiESMu
         BW9z+XJWaveTigCraOS7LfPtrANnyAi17s4PqUdwelALkpVc/rXijh2h1Z9zH7qT2YCV
         KEVV5MJEPckO54T7YQt4CF71ve8o5QYtj9CY9aQCqiDW0Xf01Rn+VPauwXqGXePkFsVP
         Pwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778511589; x=1779116389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7h6hiVH0/NZ6Qfi9mJnbfpbwuzxv04Y7rZxb6Vb37aU=;
        b=fOiRXPkJjvz0uYRxzCm7mdwn808//iMASptd10sEZXhdzIz94MHnwy1dIZA5HAPspC
         CjR8HEwHOptK+GJZb3sHa/MOfK6WP3vRw7vNogJDdv8G/5na8pKJ6RkBUDNfnlrv2Qag
         dhJvBa6lXivlM3Ssg2n4RNu2q2PEG4f1AKkAGIj4+5C/IuLGfEgLDqMZAS93mGXtm8D3
         yIINYVxhsbP2q5O6B/9JTvDe+qN3up3Q05GvDw8hNHoO+HcXxKLcb9FbeT3KphMg6Pqm
         REwV3rIBdkcpzf3isg7fB3lArL09+SktRvkRgU4RagPE17Fw+fgIfQ0+nt/PO2L5nVIf
         WkaA==
X-Forwarded-Encrypted: i=1; AFNElJ8GjM6K/mpzvmrlNG/Ca1zqlNJ9dbXzsUepWEfsRiqqw0lM/YSwrqde1yfFhNwsCQbQH0WpQPAiwg==@kvack.org
X-Gm-Message-State: AOJu0Yzy6zNw0AA/3i2xXPCEwsSv/NGWyEA8ubhCQXB89MGSjZ4Qfzq3
	rUX7SxakFSnv8X/rrIrlFqz+H0KevijCpV5IKBbMZ3MDGYqPomBhm4NfbHK0V5hdti8=
X-Gm-Gg: Acq92OHX15dcVqH8B6W095/Sy4vXLLebLnArzHhDb0hRYpPzGBqLOXa5GLz1GAeaqqo
	qQAA15yGStePxaH/4xrqHW59dDQJ95nNDHvMPgrraY5wQ21qh26mkG7b26nNVGV1xmwoIkiGTC6
	RGq5WN2Kii/E7MCq0JlKAqmZAUNs15PmeyBuXR1ngdfWI5/7Q6QnfdmS7RgwyCBSC6ZvHs8iblU
	Q3UiyFO0vq/UkyJKu+4qph2TzV+Dxuf3LYAXRc2R0hpEqMtLCFXGU9d5v7cyuM2CWKozdEGJghO
	RtRa4wnHuDO0nvGTtbMquZVD61luirzVjyAsSsnF9DUggsz0PI9khIbWMh6mZYmM1YvcSFE+8/l
	fPMxnub8DFRGk4pwMH0Ev+smLgT3EFm5FbXdAKeaeNwK8sVnlzZcWGmTqijYJgMP5ZcNpjGzT75
	36UVIik63xbluG/Vm2Gl1jFGAsWClZO83Nlrm2KlUNaptugI0UTU562v04YpLxaTohS5njDSCdQ
	OMh9yj54FbUOTAc25+uztE=
X-Received: by 2002:a05:620a:1788:b0:902:afae:fd39 with SMTP id af79cd13be357-904d70c4754mr3575981085a.57.1778511589271;
        Mon, 11 May 2026 07:59:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c91c813sm3112985985a.33.2026.05.11.07.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 07:59:48 -0700 (PDT)
Date: Mon, 11 May 2026 10:59:46 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH resend v6 02/30] mm: mempolicy: fix interleave index for
 unaligned VMA start
Message-ID: <agHu4iaL-3By0YuC@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <41bd50fdaae943e1a79215ea4000322e74a823be.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41bd50fdaae943e1a79215ea4000322e74a823be.1778489843.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E5E740005
X-Rspamd-Server: rspam06
X-Stat-Signature: n7ag6jtnqgiricsitr8it3nsbmx1pgjs
X-HE-Tag: 1778511590-31857
X-HE-Meta: U2FsdGVkX18vjqWW92TtRaq9eD2+/kc2UK5g83pqfmeFvlM2Zkfhi4apNSxX1v1frZk2X76epfIl1kSlEH8hLCIA7ZTjKvhyRMJaCMtzxtfPZClXwCXw5YpItVH4zaghojoPYXcgjiczWg0soWrhd4kuvyeue5dyWa8dpN1OhRDOeE20Wm/e2495t9GljvnDZrG1GmixOVuOKScRoVl1/eEHDBQQX3NnFVGPH/84jGQELegFh7cAFJOg4wZ3hc2tpwAJSOwR1pAttA+rdmerRmk/zfT7ulrik/2XIELbSgSMsO6mPPjBK9ykvP+DarT95Hw5VcdKtDoZJQs0/rcys8hp/K/P4EsTwThf0X0e3qdJ+Dk3d6XJElSGjya+WGxJ8JACcwRpJ858vc1C9ZeIA8S5KGiO8kVAA/08Y9zPJg/q0uYQQjImHUF1b/V1a5jYyYDiMBca0NFrJl2Y6287SHLJIBEbILcI8FQuUr9RWVfC/2vX5YCXgf2aEJpvOaJ1gNprNx+yH6iAeAhmPpiUecM2qQzm6QuWDOXkCaC+S7ugB6oMrsV6q3mP33wv+MzvM3iqEN8KQhUB2+dQJQL19mlAESo1GEEE/kVDjf/fZgUUNSe5RbqNXMYw20H/ka51LF0yD4qQpnKX4ikbXHebAO2iWQ/zQ0DpxNeKijlZvK8FzsAm0L23HyBGUKvYT2A7hHmy0hBqLSzgRu3Gaauekzl4+q4tKwAPK5MTgMXKMFuQocv0xLqUmNm4G6LtXPiZfE2Ow2RXvBub4id8BJmovZfErfMwmVA1yBvZYFzAQeHeszr/dljFkxvJFeMp41GcPg70j9/U7UMye6I6XqC7ZnLMqAHvFgyPc1MLlTWq9coM9K0GqxR03foSO1FebBcM3+uxD8gK/nwXEvAW5+HGHZNpBQbH04F8L/Rbjrdjo53O+sdOC235JGOw3iMT1oHdfOm0iptf019AH5PQZ3q
 wvWiWKIz
 kBhWSSdywEh/h/1xQs5gYoerAc/jAjVVblEHNgpMkHQxSqs03CHdmuWtXvJKva7rtZ17CfzNU6j+U5gej1/GaAkIjEMyuwbuv1hi9BPBE3LWsfvGlzdtxyDaJ3dy+rNmkqzNqgYgYLH8sVaDrJtA+F0avg+utEYeTbR/46jvkQQicX1IylrUPPhPN3BrXozUs5LPavil+JGQVrpP0orV6VmdXs6JslYtLUp7c//RUQN4oiT7kz23COUaiX2lgW7+6K6VyUBfbasvER2UHHfbTjXftH8oXeID0qoiDzSZubN3sRcnmsyvEInfBQHmtxKhWWgZlDi/xwn1ODFxBTFPW3XwjRXXdD5mb27dp2CGyGFR77gumBlZ1gZstZCIq1O4AXqVfVC2cj4n4rEprZICe/RovPtwBMXWUVM6Zj9r1AF2m6rsyXQA8X6ayLUP8I1JExSaCEjvkczO3mbu1W28jEp5JJdi/AIRKMF2wX9fzRSCG2D7eu7i1BO/sxlAfkiui3cnsxZ8wWSrRpWr4s+qgAuJWhgFJQ54vT5WXNru6irQmOZgVDXxzv1/tLHj22hd9ycrr/jF2KgdxyEDJgmrxctXNJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:01:49AM -0400, Michael S. Tsirkin wrote:
> The NUMA interleave index formula (addr - vm_start) >> shift
> gives wrong results when vm_start is not aligned to the folio
> size: the subtraction before the shift allows low bits to
> affect the result via borrows.
> 
> Use (addr >> shift) - (vm_start >> shift) instead, which
> independently aligns both values before computing the
> difference.
> 
> No functional change for current callers: the fix only affects
> NUMA interleave and weighted-interleave policies. Current
> large-order callers either pre-align the address
> (vma_alloc_anon_folio_pmd) or do not use NUMA interleave
> (drm_pagemap). All other callers use order 0 where the old
> and new formulas are equivalent. However subsequent patches
> in this series add large-order callers that pass unaligned
> fault addresses, making this fix necessary.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Reviewed-by: Gregory Price <gourry@gourry.net>

Should this just be pulled out ahead as a fix (assuming this
set takes more time to bake)?  I get it's not causing issues today,
but the interface is otherwise technicaly broken either way.

> ---
>  mm/mempolicy.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 6832cc68120f..39e556e3d263 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2049,7 +2049,8 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
>  	if (pol->mode == MPOL_INTERLEAVE ||
>  	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
>  		*ilx += vma->vm_pgoff >> order;
> -		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
> +		*ilx += (addr >> (PAGE_SHIFT + order)) -
> +			(vma->vm_start >> (PAGE_SHIFT + order));

There's enough (PAGE_SHIFT + ...) spread around the kernel, i wonder if
it's worth a define or a function (not in scope, just pondering).

~Gregory

