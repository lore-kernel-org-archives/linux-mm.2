Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB01C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D0D6B0101; Tue,  4 Aug 2026 10:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D476B0103; Tue,  4 Aug 2026 10:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7AA6B0104; Tue,  4 Aug 2026 10:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE8A6B0101
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:36:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4779A0196
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:36:57 +0000 (UTC)
X-FDA: 85063838874.25.ED1806A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B4A85140014
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:36:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HbEtkvAZ;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854215;
	b=ZkAT2xUMKZE0XPofQpJoLTQHzbmc/1W940J+Z0T9OZTzN7nuPY+XLpj9OvPbiTmjHOnYPI
	5Uxs14nLtGw+XwFLvuOTpI8dq3f/4lLlFilI1eku8a71TttAVOqDcFcNfsJREdghMZfU8M
	dXPfTHu/s/zwrMnxICJbW1RDw1GoQBQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HbEtkvAZ;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMHP+hPMOaHZx9jDNO0xYD9pWUWMBLkbRPM0u4QDrOo=;
	b=q2rOOQPYYzOrKq8/bPZM5x2lV8xrbtlww6gnNK7LlLGw6b+zJu7Fu2k37IeyP6eHVjm5bi
	42jl1Koa4IoRLQyF4t+vDTie8iVwokcLoP6IDnk7jG7Cq/jDVigsJ7nRZ5SZk/zDW+qPlT
	RoI4/J5KLlOXWrf4/czf1eMmZGEYEQQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4365F60A8C;
	Tue,  4 Aug 2026 14:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E245F1F00A3D;
	Tue,  4 Aug 2026 14:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785854215;
	bh=xMHP+hPMOaHZx9jDNO0xYD9pWUWMBLkbRPM0u4QDrOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HbEtkvAZf70uDRm57s8S2Js++GGFN/fljdOhoJptzMF2N88EfAEJdmrEAOiM6HJA2
	 Uml3dId9f0WYqJxejCZCNArT9SawT2uP5jBSBBTLxELnu+vfc0GrsQQToYXnzZw7ay
	 R2cCwVxzqM2fT6TWYAaKqN1WqujNXbIzjc4hw/eC6rhhFCv/KfYrxFLih6Jrc63Rhu
	 H65iFpahgeGYB5ENvkbVjTZG7Kplz40leJ2pXOnMBN5hi05peml/UnMWFScX1c0N16
	 swAnz9kYXUJDHs4BvIs96i8yud/gEHZr+fA+ZQz8W3xvRfOJnYVR7bTf9PNnG88X3G
	 +61ZdFvaiiEig==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 53B4D198005C;
	Tue,  4 Aug 2026 10:36:49 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 04 Aug 2026 10:36:52 -0400
X-ME-Sender: <xms:APlxaugx6RXIfl3v3aDSMW0ncJwAyy3pLzAUtRUokhDAKNBC9I0DUA>
    <xme:APlxas611YFY_Rg92zXDB25utn_Hk_llj8ms3tot78f4y0wufCTpw9u_bbq2Niada
    5EMkb3Y4odp-bn6EYhByDMUkenXkjP5sbjiR6vl59XbLUoDJFlD-5M>
X-ME-Received: <xmr:APlxavLwEjMZQ1IBwnbCXr56XcJFbnqC8Ny4SeDk02wyxNn2EMCHUBaylk4>
X-ME-Proxy-Cause: dmFkZTFhdGzLG39r1fMJddaw2USXwwshGe2dXEdkL6WJwsFjOH3SdHoN64VD7l/z+M8aMA
    4AjIBR2yzva7tfrgZigRLsg6cD+RB1DPGvEMnmO9G+1lDkX/EXVbxIdZbn0UeqbFiuJ4/r
    gyVQZ01CzYF618dykSnjz8ppv0caM8t0SMTDncdEUQUmHYImfVsKz0hQwHW9gNiycWqLRV
    WSMaLbFxWRx3XFZF6qtVLvbGv3Oc5bfAz52rJ02W1a4rDBLkqzpI2xBOcimCjvxGSGUbcD
    UZSi+TEdX0ZKm7T9C+gTHS5O3QVH+kRCBSzxorCQsCu4xyiAEjBf85LNlNHXsYIcHP/bZT
    y9ElmDOfTPofTD3biREhXmS/3/YA1l3kKXL1JPXMZqPsHnKV4lwAdHbFieVsTTMB0WxxeJ
    gpE/ZDETEt7gEpR5pgZ+kSaPTFT46I2/SseRBTCPJ7d/ph1n2wKmLua1xwtqMBq7tnuwt1
    WcDN6VDPdB6cNQEVwElYTlLy5vNHbmTDx9RnoQ51rjkfOwE4hp+CwfANrClC+nFGJduohN
    Fyg90+BlIbFbygBlp6B+xRaV9RF2hU2o3YGvd4tvlGm1ykhw/YtveSA6NqtYkRTJGcT0jT
    inYKiVKVyK3heu/y3I7hbiuDUNur6cNpm8WMjUmMhQdIntVB8GtsD3OBSypg
X-ME-Proxy: <xmx:APlxaohgtFkYNZB9P24X4TXe7X6JSD0n1NWpWO2ZZT5U4Yh9EdK9Hg>
    <xmx:APlxakJMCwFzE8uZYpmby2AO8jgsRCpHQ8i7uYWtSC0wvSuHQlMKug>
    <xmx:APlxathVa0Uz2XeVL-tZHO5hN4St8GJP6Ulo_DCfEUXq3Lsm8sONpA>
    <xmx:APlxat0bFoBmPsiivHmT90C9inEDleeJSM8BvHwH_6bYCeoBz7ni9w>
    <xmx:APlxakaZC_dsoWXGBa_Y9EFyxE6ERYBXKMOW85tXaPkkSpUeVfWJgZpH>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 4 Aug 2026 10:36:48 -0400 (EDT)
Date: Tue, 4 Aug 2026 15:36:47 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <anH1JdVtiM9VoXMH@thinkstation>
References: <20260803-kexec_posioned-v3-1-83aa6ede0351@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803-kexec_posioned-v3-1-83aa6ede0351@debian.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B4A85140014
X-Stat-Signature: yaio65zg13yo1duj17gbbse49tkj95zf
X-Rspam-User: 
X-HE-Tag: 1785854215-652649
X-HE-Meta: U2FsdGVkX1+wdEIvmmR8rEmcqyt1pG6U9c+2Rl3hUBmiHc7DVuPaJzOF7jkoVAiyUt5qUI4P76mFr3L8uX0j43l647qxC6qe/qfLp09YOMliJocAdZDB5Mw+2+eiSIEThvpbvNiCtN46cm217KoByU87k1mnKCL0opamSsCvViHZUX+g6y4fzaSwKCl2dqED0ADwpi7QREB7EeYYAVQeWjFTL/wAk/9EscBf67wn3RBWwWjdNgjF8caTYL5SV5oAUNtqXWlGFD1Us5qtgq/GNIxfSbmHwnIvgn3rsmbWVaJgq2PRkZBcm2jXw3NPRpcYW8FI8TWwy0Fmpsds8DIyGqXT9RZjEgH21PoXyCNIJR8xLiOEkjP7w3yTBP8xvC/y7c21Pb5cDr+dJq1lrtNraQkrZx+5XFZAA/q7rQ1PnGWknLOeUveVGb8KKrKfoTpBxQijMhBpv6OR7d1ZU5HjH5WMh4etdL1vsFTKyTHxMF/E4dfn4A7R5N/XI7VcXXyceeZMMFMeMP8Kt6lAA6CJ5zk6tGOkFOy9URl5yusx/aXKZPQPawMiXXyc2bu630etRL9v9sbSsX9T2CFCvN2YNlRIZ7MPU+Goq+lR86ZUvTD4a6oFsr0ly+SCyyTr7/u7gmnFcdUril75BVnIpb86ZnrpLDVTpQMTWGhwmUspRcK7RCAxeqvdmtZrw3LreSe7vMF6BOuo9M/bpG7VKH0tl4GWhbdpWbv2KmZCclV+/yeS6V2RYY4TCWzzDUjehS042SOQ2epOzJH6jbkhjbE/o1LcbxQEHr/aEPDCX5qFkVMapwO/ZzhfvIhaGplDEwY8Oby04i3KoFPVvU9zPRer73EWo1fOLGzpwOdFfGKMS9l3h50WWqxSV0cQMAzRhjvM+juUjBTm/ekm/k6Qr5st/6vKm0aQDTRpuNZfNGqFwPwZfEexcrP+ygKUi51Gk1QHMBpGk3Bjc2K2aVg/gD4
 mJG/2Wmz
 rMclouByO+J9WHVYLIH4q5fwnd4nZHbV+3FzUvWyu2aG+ciPt18DF4pgEnt4jL8co/mccM65Io/UAYBQh+rkngAh9d8IWs1OY9pHR3wW3VyaGsHy7qUX5hq5xBa/v2Y1+AYYiGGOmIcMVlQOA9XOJfgdR3PCI/AHvw+B4YmX2TsoTl+CxBp3Ma+QUw6s1O/Wqc9EEq/TXyvWJVj4slX/AyBFn6YbsaMDsD1EixK/D+q4WRo4VRG/vV1H7BFGYnRukOMz9by1aqbUOetD0WosWzGwMoZn6oF14joEgKC/3zyosDpAukyflVuLg4rrMh3pvrbEz22iIidETHCr+xo0AiucXTlCEum61Q7Px
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 05:41:10AM -0700, Breno Leitao wrote:
> @@ -504,6 +505,15 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
>  			continue;
>  		}
>  
> +		poison = range_last_hwpoison(temp_start, kbuf->memsz);
> +		if (poison != PHYS_ADDR_MAX) {
> +			/* we hit a poisoned page */
> +			if (poison < kbuf->memsz)
> +				return 0;
> +			temp_start = poison - kbuf->memsz;
> +			continue;
> +		}
> +

Hm. Don't we want range_first_hwpoison() for top-down walk? Otherwise
the end of range would land on poison.

>  		/* We found a suitable memory range */
>  		break;
>  	} while (1);

...

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a8b03e2920ba8..ef0e989c25d93 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -96,6 +96,31 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
>  		memblk_nr_poison_sub(pfn, i);
>  }
>  
> +/*
> + * Return the address of the last hardware-poisoned online page in
> + * [start, start + size), or PHYS_ADDR_MAX if the range is clean.
> + */
> +phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size)
> +{
> +	phys_addr_t poison = PHYS_ADDR_MAX;
> +	unsigned long pfn, end_pfn;
> +
> +	if (!size || !atomic_long_read(&num_poisoned_pages))
> +		return poison;
> +
> +	end_pfn = PHYS_PFN(start + size - 1);
> +	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
> +		struct page *page = pfn_to_online_page(pfn);
> +
> +		if (page && PageHWPoison(page))
> +			poison = PFN_PHYS(pfn);

Oh... I think it will not work for hugetlb pages. It will give
false-negative.

We cannot just set the bit hugetlb pages as we don't always have memory
for tail page -- look at HugeTLB Vmemmap Optimization (HVO). Hugetlb
uses a trick to encode poison page. See code that uses _hugetlb_hwpoison
in struct folio.

I think we need special-case hugetlb here. (One more reminder why I hate
HugeTLB).

> +
> +		cond_resched();
> +	}
> +
> +	return poison;
> +}
> +
>  /**
>   * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
>   * @_name: name of the file in the per NUMA sysfs directory.
> 
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

