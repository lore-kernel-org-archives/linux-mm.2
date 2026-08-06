Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3AECC5AC7A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95DF6B007B; Thu,  6 Aug 2026 09:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6DF06B008A; Thu,  6 Aug 2026 09:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83646B0092; Thu,  6 Aug 2026 09:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B54706B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:38:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B526C0740
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:38:16 +0000 (UTC)
X-FDA: 85070948592.29.C6794B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8DBCA40008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:38:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+H2uClb;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786023494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWz/cApfw5KEvVt3CONwJTdpcBFR/sFDxLGxiU8Jc8A=;
	b=CDsclxE6CI9cMuTQMxPyKoX+gKC0EpclM35d60oYbX2k2r502wF9yy1bM6Pio8a3zsyzys
	DxiXi6PRHtGAURHmXGf2Vrmp4PbyMv+pmTzPO1dLbMVkBeg7akRVJGLaRk65d01C9QatLX
	JYm95jSAMxUBk/4+82cBbrx9vWsLLUQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786023494;
	b=UgiEi3WNz3lKHtgIm5VRJ7PNV0J8QHWFsSn4ENkIAuenHs7MoZ2mSTha6xEFfqmwrOLPuQ
	XcvQC+jP+9N1pds4BgPEXQuiGurS+J8wKjEZNpdfYDO7a2B2qh/aLFciZojVDgfKXB2pFY
	nqsUibMgRajBEPZiJwWywUmVD3nioNs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+H2uClb;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA04160A96;
	Thu,  6 Aug 2026 13:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAB51F000E9;
	Thu,  6 Aug 2026 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786023493;
	bh=NWz/cApfw5KEvVt3CONwJTdpcBFR/sFDxLGxiU8Jc8A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e+H2uClbj28vgJXpuA1NLeii6LJaOAi2uIkd6dWHvK/jORTGh759PpPPgJ1VMIVG+
	 A+EC7jMjESUiBGq9Fiuphw2n1wfFROxy1M3sk8glOsWr/ZCjtmd8LKOx1qwhAkziAY
	 s8PJMf12DFEtLWNtbXrEqXHgLbO4hIrDpMDnP82B2tltTu04GMlmlg6czmntPz+Bs6
	 Al/H8ak/Mr7/OeRhjiXt4c5pLasSh0vMlKUiqB74ozIB+9H1cZdNT9Fjl250Glmd9m
	 Rtyq5mhAAAx6sAt7hrx6Qd5wyyp9oiI7g8gWE0kVN4C5EquH/7y06OUXmfnxPNfn0u
	 L2JyWWTMpeS6A==
Message-ID: <1a0cba58-5d0d-44f2-86ab-3081601623bf@kernel.org>
Date: Thu, 6 Aug 2026 15:38:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] mm/khugepaged: introduce a count_collapse_event()
 helper
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
 <20260804-khugepaged_pte_refactor-v3-3-0364cad642a0@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260804-khugepaged_pte_refactor-v3-3-0364cad642a0@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8DBCA40008
X-Stat-Signature: 4gprm8efgnpm9mkfztqae6ac4jhpbr7o
X-Rspam-User: 
X-HE-Tag: 1786023494-370957
X-HE-Meta: U2FsdGVkX19D6k7vMBr2l0i1ZRHikgT/aNEgF6UY076kp2z7+rxJODRv2sE5EFwHm9PxdizlASfs5CsbYkX0uH2AHHu9rUa0KcgVIOajLLyA2D94enDCb2LzNfLNErQPM+EM+gwz59Jgk7l02GWXm5Ksw0JWtEqqtg8L2fLLsg8Xub1BzSN5vQNWUAd1ymc0+4NxuKJssbzNX3tXVldAVPkqvi6twZO54zbGAm+KkZocgGNsfbgsOXOmdgZceABVWoVRM+mZSA0Uq7BVlCzIH6IkxYTIevfEC0EH4BEDMzfwfMRKWlQj3HSdRICs/3YoP+m6uRzmjwgCAQekhQGWxYRW45SF1kqFLb6OLLoI6psvrJ99Hn/yhK8d9dHHqeuzrdJtTc8EeLWZhwxXNLtH3MdZ9xYRiTMMAxb0UjiwxBiYesleZGRnYGwk4MrhCp6MMqL+aCb7cNuVNPgl0aHgEnkcJh0PfVwOyB65mwGSi7SgE+OhgkGCoZaxHkeAugLmKd7UpVSB1a6zY+lvBM+lO5GOCGuOfuGY9n5O48drJZliRB2pHjB5XXQ8QBT3MDRGI2pM+9HFGX9BuNS+wWXD/q4SLyIlMcCNqxHd+1JG6/MLS5YEv78samHZh8D5Fw4VZa2Co/yMRT0zb8ZMeSz/5S/ruSLsdcL5wGzdiIBoPt/z4PTwgPjGT5qWV42nBtl+sY/Cg/ACXQx9BUyu2itVRtMuZghgdzjM71BHp17EJtL0z7dF7c0f0t/kio+NOEFh/ztC8ezGl7+esxRSwGIQCNzb+tgVj4k8x5Cyi3hRsfuHqgR1NpfMwr10cX3hNF1pyvLYkRm5wTgAqOE854PB16n0HDGaBMaGVIwYx8tw8LWbT4uUAl/tG2NDqLmWCjIQ+jKcOZ38kutQILcQc0gnzPZEnzc26CX8BboHS8QLJySEvWgjVVzPMs6pwl8tVR4pILLKMZIgJcngZRFFvtU
 Zx1IGXIL
 GI0Bm4NNNdUtn7KtBql8HToSM8guvo3TAS8fjENRcdR2Ioe7eJpoJvCE9VZ4NWFzxrZRmobp3ig9Lsg4RLg8vu69pRUGC3oWcE3OCfN+MXBdCoZNsuQGLyeKPSq1I81v4chlIfchelU8L9Wi9kZCcUz825vSpE2DncC7nNaKqs+NlQHZNhfq4ZJklkPnnLiCJWcBx5lQ+olKgMlDa0rje+dMLH9W+W2YhrJyHML1JifyXmnJYzNCKIMcRYk3lAM4o4qYH07Br846axmgX2j1Bh/qeF0ubWi7a359osSaQ5bWSL8XWGy3D8eT0+EwQY/r8a+0VBqC2kKcbJ5/RSNMay5wAahReQdcU7Cuo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 21:25, Nico Pache (Red Hat) wrote:
> Provide a simple helper function to help reduce a often used, and
> duplicate pattern across the khugepaged code.
> 
> When collapsing to a PMD we need to record a vm_event and the mTHP_stat
> event. When doing mTHP collapse we only update the mTHP stat.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

