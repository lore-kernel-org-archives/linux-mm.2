Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B2F3C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2606B00C3; Mon, 13 Jul 2026 13:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9C26B00FC; Mon, 13 Jul 2026 13:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9616B0100; Mon, 13 Jul 2026 13:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F04716B00C3
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:11:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D55D1C003B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:11:36 +0000 (UTC)
X-FDA: 84984394992.20.9CDDAA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C023A1C0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:11:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bkWcOVc8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783962694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4n2+420PsvWKB6fOrF1XvEX/qnF3xVintdlvrK6vykU=;
	b=b2yuv5CJNVZkIbsRrum9sJf4+/xkFkYtK8IOMlo3V7geeeAUlSNKxwznIA1gsspCzTBtxW
	H24plbR3QzT1bdoNwaJPHDHRxpbHVexjJa/FRmcwg89x0EmogjlqbkgH4m+AOas6x9cfQc
	N5zLKrJ2InL4qVMCWKBpRzINGOG3YrE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bkWcOVc8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783962694;
	b=LatHJjE/V5haFk/krk1NzLlvg+/r8QqTWeujx+U9NCHGB8o9n/lVXlF3mICqp+cmvKJige
	kJN6DpctOzSBs6MH222TIK+aeB9e/VjdD/fgdBf0jhFu3xzY0L7WMZ5Xoc/YuBup0cF0xj
	JMlRqIjq0aTle5HGSiFo773e83JFQpQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BE52600D8;
	Mon, 13 Jul 2026 17:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20451F00A3E;
	Mon, 13 Jul 2026 17:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783962694;
	bh=4n2+420PsvWKB6fOrF1XvEX/qnF3xVintdlvrK6vykU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bkWcOVc8auovep/LxjUzqlQErnTNu07yEGIEFenSX5s/99s9nbCBMxdw3DNl7X8BO
	 Ldp3Z4fynz6eyLVgxQlzLsT+74cnccePggfMcQxIjwfC4TXWMqqbKI12LOHPgdP+WE
	 38eSXUPpIu6GmpgchAkCGUJgNXnLZMQnFNHFzllSW7duT41cWsrgt1Ix+fSMGN2Lhc
	 ckpyE/OcUDdQAJxvMYh26VHpmfU2qI6eakvSGoIahds2X4NGGTWjG9os4jnlIfwCYi
	 vn9MCNYTWhk2xE50x5HJCpA1m6mp3w/aOsUVL9ppea0W5FHHlu1dI9lpA9reHfO5Ah
	 /8+AT/2V073dw==
Message-ID: <731cdaa8-6d0c-4a88-b398-806c28c698b9@kernel.org>
Date: Mon, 13 Jul 2026 19:11:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] mm/sparse-vmemmap: flush_cache_vmap() after
 hotplugging vmemmap
To: Vivian Wang <wangruikang@iscas.ac.cn>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, Muchun Song <muchun.song@linux.dev>
References: <20260713-mark-after-vmemmap-populate-v6-0-b945ceba29d4@iscas.ac.cn>
 <20260713-mark-after-vmemmap-populate-v6-2-b945ceba29d4@iscas.ac.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260713-mark-after-vmemmap-populate-v6-2-b945ceba29d4@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C023A1C0005
X-Stat-Signature: 9gx5qrxaeuzanbom3b9xqs6x6arqprh6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783962694-205407
X-HE-Meta: U2FsdGVkX196ZTweuVPt5BF+ZJun046bRUqWOW6mfAjiZ32aPCqE8FrxY/qPQ9pYf1J7ov3lH2pLXwawJz0KcWqU+fUyb8a8e5uKDKIPDbEYp/aecvo7mlcDuDMDH8DJPHBrKpDUB2tMzoeO96MRmRl7LrufjT+zcvyfC8yLFxoNwB9hF6j6C0YEKD2fhwXsfQibXYW8sz4VVN7v3VWMNClIjaI601uU5wOGMhMFpn2GOJGA+p1/25If6uNz6E+8gZZoCbYvEgywarwZrRKJgzm58/5yfV6VKtzazsr9F5qoAcX4EZhhIQKPE6MP9l0FPdmtfMI50kdigfB8P0IIfH4+vxGgMMp7b/tACgRY5y7KcGsBGLC3leSFqi72pGswBi47OmXrfBF3t1tUloNWuZaEkbCh+m62VQelN+EfpGxRGhgVEhwfquniUOqzTAndLQNNXbxHATyXsA7eX9+IQeiyhT3dtkOyfQL0C15D+/yY9fv/YPbMdgsVtLLPQm2Uq3uLsf4NKJbAkE/cz6TUJVuniPpT2bj3eYZtCIfiEAiqskkvgizbtv0C+tFeCDp0B4+T7jzfbNMG0IriF0CVM+urVPDvUlAS+lHTZLv+ZY75aCYmlI/GGCA+7lvMAwwlFQpR74Z1LcM4JTMZHi9FNjKGl5xMpqn9psprAa9hHpsEcIUHzTJSAUgLlhOyhtSg8Ilew0MOfoLB2FWOl1zXMT4UmotIU9pKlws/IfFZm1vC3DQfnYkXMCBbIrBf2zaGMLa1zH2alNE9n6MbOf6GABI/lGtURoTZ5tLOU+ajgbvDCPRVWBRUjPKSg5b4rxTaVic60MoBvyW3G+FPRL3x1/v3REvKS+ezDYGVVuHqv1ZMv73K9z2mVvey6x1aBB3nh0LpnD+JVh07eezjEcKwCh1/MZFM22qY78o+WQHJogX8XmrdjdHm5U45Nmdcwjau7i92a14NV2TkX9jHAFE
 9lojh4fe
 /ACEDfi2J5bLbUJO4cdkFn7iYei3ZjMCcozdxBPzLnWbFXn77CNr6qxI2mRA8lj+pDewbJjURE4L28W+kQnZ5igWIPc7DH8fJnc6mvzQwCw/fMnE233HiA4YxPe8o/PGgyK4Ah3mSzxZnifO2tstc3Cv7xmynHsStMGcPDbOkklQ2hAPcUSajx1c+uvCh2hlmrOJunc7pTBjH761zL6UA+tpwaXPLfJDF+JWFLazUhbTfK7MZSTnigrrPltjw8diTgiL9Pfmd82yvSj6uzsLMS1cD3VOOq0t1z2fBoVqiLATlrN4FeJeuCT6qfCnKRLjcXov6BeQRoC0vnNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 08:15, Vivian Wang wrote:
> section_activate() does not flush TLB after populating new vmemmap
> pages. On most architectures, this is okay. However it is a problem on
> RISC-V since there the TLB caching non-present entries is permitted,
> which causes spurious faults on some hardwares.
> 
> This seems to be most easily reproduced with DEBUG_VM=y and
> PAGE_POISONING=y, which causes these newly mapped struct pages to be
> poisoned i.e. written to immediately after mapping.
> 
> Extend the RISC-V flush_cache_vmap() to also handle the vmemmap range,
> and call it after hotplugging vmemmap, which gets the possible spurious
> fault handled in the exception handler.
> 
> At least for now, the only other architecture with both
> SPARSEMEM_VMEMMAP and flush_cache_vmap() is PowerPC, which has a similar
> problem with newly valid PTEs. But there flush_cache_vmap() is just a
> ptesync. So it should be safe to do this for generic code while having
> minimal performance impact.
> 
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

