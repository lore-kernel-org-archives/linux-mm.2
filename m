Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EACE4C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18E16B0092; Fri, 10 Jul 2026 08:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF07E6B0095; Fri, 10 Jul 2026 08:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06966B0096; Fri, 10 Jul 2026 08:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFFE86B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:09:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F2BD1A0405
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:09:39 +0000 (UTC)
X-FDA: 84972747678.09.6FC5D3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C7AA40002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:09:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ELDUjJY9;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783685377;
	b=5vGtHH0aUEl++TxyQWN3HNPVAkX0qncN5ZsEvShIGCJsDGlYm2t9jfgdPsehJ4ZZUQ2Dtn
	mpgBIkhdpwLd7M0XHl5Ng3n6vkt+GoUufK4Cu95gFN4PRXZN1pFpGurAhl7zMZD2tpn82Y
	CeNMXLVxHA8TE/bCpMgDpv6E3r8+XVo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ELDUjJY9;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783685377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHyiYyonVSx0Himos07lHVjuF+/oMX3axwRtefrjmbc=;
	b=sOfyxizz6d9vKhyv4FibintexMl9Bx5mePWUKaDDjpaDzolVOTz5ko/Uaja3jb9F4kDL/Y
	BXmwdSFvetJ84/Xt63JTXVvZBgNDFkyNVk2MWCmKkJOyNim59zs/jB8A5d96D8NpXiYNTt
	UY63PD9ADmCyH7hJGjPSnvrzS6PqSVg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B88EE42E62;
	Fri, 10 Jul 2026 12:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D961F000E9;
	Fri, 10 Jul 2026 12:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783685376;
	bh=GHyiYyonVSx0Himos07lHVjuF+/oMX3axwRtefrjmbc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ELDUjJY9yklISNd1G3rLfD6bcQn56TF7LUXC5wXV+cRcshH0+no7o1EJnIiMgKCKe
	 4ABJgkXpOCuZc8gQiSay5kaQ7K3rOUvW85Ii9ThgI3fbxhlgM3zGos8kWnhnSifPtW
	 vYRv6Len39tiGQM6Nsp4nc3txes6wdPsUCZVCADhrjQxhb7Jxohaibwiz+XnEC4ZTA
	 q7M5m6JQiPpMGlicdlKZ3qZH+3UBZ5AO+l5gepvqmEzOqcd1y0KkL3BCxtVIch4oWK
	 sDOw1ZSq3GeTc4S55plPwK1YKptYnUD0YOMPAsxSlmLjSnGT1mgmOgQ13QzAjQS/uW
	 u1iTY8ZSSzcTw==
Message-ID: <a41c58a8-9d5a-4022-ad9a-1995827b6da7@kernel.org>
Date: Fri, 10 Jul 2026 14:09:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm: mincore: replace __get_free_page() with
 kmalloc()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Liam R . Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
 <20260710120052.103886-3-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260710120052.103886-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9C7AA40002
X-Stat-Signature: npaecfsnrh8u196q31ujdjht86bmhm6z
X-HE-Tag: 1783685377-221535
X-HE-Meta: U2FsdGVkX181h4+b72d71SNhzoxUpR9aObzveGvOASdMx2xJSls/QflkCrtCcdrtGXOZSkoI10QwKnU9fMKz767BAAPvJjdWwpXcwLTuCC22eV9jkiDTqZC+A/jOtBGW54Fm3jDhcDWUpjMBe6Ts7RK/RngfhhOuU4arfSJz2Xw44ZRnIGU+QbTC4/NIYbyTfceyOxrr4IjKbMDVSLiqVwIx6BIPTvGqRdqnBfQGgYFchjzEdVIplabsOIsH1o9AohL3JCe3Dy3X5Pf6VKckGkVtD3BZq4oK6LkHGRcmPGSzTPldgbioHiryBeYz77/36r84Z7j6qMKCwVL8AWw3Ges70T0lqtIV3hYWRNzIlbaPsD3T0rG/ECt3PKQGzH0kMe/guiBx4ZPHnvPUQrNLsh6kax8RgZK8X5gZJJv/Sl+cjCc9Wq1n4Gr5euCRNIZzyWYeg//M42QLjvDn3CPk31jwUbBcSMI7AXLLM7+EIZx72ZGedcMf3jMO5W56jtAQlvWkmn9QSDsN7s/E1Win6/i/039Hx3qhBt1f1ECXqoeLXd5NKt4/Q3Bj+JAAXrU/oAgoQms7c7E3DU908regbTb0yZsVnlLq/ngk2a+TsDMuFUiqegJrHb9XigcRxAo9HsjOCzgQxqyJgZrM2Ph4LKywp5p1nmZXViOy5D8KVsIbrJ/EEZSB7gxPUM3sxsODBRQfRUpJ18hqufxR5SOjH2ymaAxdI5TRA9wHmWXLQ2UHJuCadoOWJgHFdLq9QSsvYEjjBOo830+Cq2IBdkvCi1JYqOmgY8wG+ZjXBhwoQ5oqTI6lgSBW8r4aHjbyFxPG5UZj4inXHFzpfbPfAdmVBVvCqq7dmjvpys3QgjOnXTuiYXKs6VOfvFIpOGP2PcwKMwuWsclHVOHe80fVcBnvSOG7Tu8cgf9wwuBnNVkP/q3Gbx2vVa6KK5RdA/vcc6PpZByRDY6GvznBgyNYpA9
 YMAcKdh0
 Pw+cM8090UydFLLSqMByRO8p64r9QLZRa+aBIztXGMl2HNJSIh4ju/UL2VV8H6L9sjmKDaONdQbKg9Oiw7pYPeIf6ZA3J7f3G+CL+2tw01WaZarZ/xADP+Y2zN5pXAH9/7xPa5Tw1hgdcYCIkFE59Mnc5w6x3CiibfzP1jBS8yKBqcaE8r8/N7aLsP4GhJx6/+oBwepWUarggWNvZAxhRZsigD1lZ+bVA9CklCfRGOgJLOk3gPBWPQThMOg43TvRmEtqpnQENHLRTVnUDNRvMvdxKAi/8VceTLpFMtZzAeCPfzNX1Wm0KIMlijedO87B4pZ6MGd1HqHdsgH7JXYlMM5Va8PhZIR2XoNuRC8z8tgwGeB/WXFWPA4ysS0tHcCvLVYZDCVpcq2Lff5sKuTiSQFCUGuu1hPV27NMj7jIaV7Px3Pg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 14:00, Kefeng Wang wrote:
> Remove ugly casts by using the more natural kmalloc/kfree allocation,
> also replace GFP_USER(pointless here) with GFP_KERNEL.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

