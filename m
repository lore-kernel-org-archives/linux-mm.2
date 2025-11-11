Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77FA5CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2628E0020; Tue, 11 Nov 2025 13:59:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52088E001B; Tue, 11 Nov 2025 13:59:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F358E0020; Tue, 11 Nov 2025 13:59:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A733B8E001B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:59:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 578CA86BDA
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:59:56 +0000 (UTC)
X-FDA: 84099240792.06.A1FBE5D
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id A34CD1C000D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:59:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NRm7sPR+;
	spf=pass (imf20.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762887594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMnEps90lDVVxQpCV0D0SupS08uIJn0CtLAQpVuX40E=;
	b=v5ojtwYH+e4TmPL0+hMnPo9ujnH1XEuq9w2kqTYqVQkqvMZ5Ln/cfMbix3k2Sgrkur2y5W
	R7xnc+WhdnKkf7IWs5qT9YWAaquphm9X/pYtGVmqukvWAOLjLgWWmXf/+UhIV16jc1qyDP
	mpOFUhBNoXOQ2CR7XiTqhAlNQ66C/WY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NRm7sPR+;
	spf=pass (imf20.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762887594; a=rsa-sha256;
	cv=none;
	b=S3IWTGXMiMZpHT2O3Vjzd5Cc59aFXjcaG8TXHRaDf4EFruY5EOCHpXHXoy5fWH4GU242KY
	v9og49zYEUMwwFLzNmVakfRMpIn8NzCzwIcD0vFED3SfYM0x8wk1NiK+2xxRgrTeRAGcTi
	H85lBVgEjQtvkFZCUPZX3BxnuELZ8MU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762887593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UMnEps90lDVVxQpCV0D0SupS08uIJn0CtLAQpVuX40E=;
	b=NRm7sPR+NTC4j8oIQHpvopN6jNVoYW/ZMofwhUSzPQEo1Ux3CnCGioBiEM+9C6Q+Kdfh9c
	nrz1kfBvONTID8CAT+XGPRraT244HZrAO3hkwarmn1Tx3IOOutvqhPzYEGQlHQNVhlucOX
	KrIgBZbSrNylk/B/CLMxMDEOJICoQ9Y=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  Harry Yoo <harry.yoo@oracle.com>,  Qi Zheng
 <qi.zheng@linux.dev>,  Vlastimil Babka <vbabka@suse.cz>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 4/4] memcg: remove __lruvec_stat_mod_folio
In-Reply-To: <20251110232008.1352063-5-shakeel.butt@linux.dev> (Shakeel Butt's
	message of "Mon, 10 Nov 2025 15:20:08 -0800")
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
	<20251110232008.1352063-5-shakeel.butt@linux.dev>
Date: Tue, 11 Nov 2025 10:59:39 -0800
Message-ID: <877bvws8dg.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A34CD1C000D
X-Stat-Signature: ny17hjcgtzpgwotub3opi3rfnz9x39w8
X-Rspam-User: 
X-HE-Tag: 1762887594-893327
X-HE-Meta: U2FsdGVkX19z1eDjFbB2PXH1srlYw7sPkMTT34TSaIae53Hpa1XvQ/ja5SE1ff2R72JyoJrTd/YVAr3y0Z2JIh51B1wQF1BmCQOYCXhZXTTZvpaKQD+LkMwJV2QPZZq12ZHoMs7/N6ASXY8hwDVWIxjNDScJQawYE/OAHCOYqYSXYS5/SJ/wCDgM3qOaOG7nrdbnmjYhBxnt/KZAuUYN4WWQHj2gIU+3Ic8pnu+Yck6VnnPc8ShWOo0XbpMAzahs9rMoawMT6YKTKBrUB5XJP9c5/jMdjXaMsnFIZFV7A8i0lCMepenLDhKRlCx0TPXfm4aYUUM9hINi/R4xpXrVzo/phJuee+T4ESW2ikcbxUSlBXj5Rliki9sBqDbbiXOe5ZF3rEcYN8w4giEe53nwYCBhJzu/IQwKdvbkEr0tuAUpDeIpyFtG/n6p2oJOaDLqgOGkQ9YQl8kUY0WGLFp3AVcxfY7tyhhscHy6Czl4uFuPb9MSBjcMulAffhCR8heI4jh7/K/8bg1JA4Ih4TyGfMAsPpFlKYe70yZ4MQCzXn3R5m+Ei7Ede4bbYkltTN/1cohEP4wIPxSzMsXWrSYWICVupf52AHHutpNoOUahZvNm9mSTyVFoAqYC37uhMOi/KJA6nnGGEX92e6BaTRqcLNqy6U2SnYss7vUIfPiblSB8zU/eEBr2YBeUANwcsbJ5R5cPlIqz2UlHF96Igs7jv+NYb9LKWNsLZC1kIL/6RNOZcjVullr45SPAD9nq7MZXG9MbZprJIKcfExz9n7QAYpcMT6V6JkY61gibcXac/TOpW3mncWjV2aNP8FvGp7ua54BBFHBloRBOWtsut4hbee5PV03m4E4gragtebybM+ofABgYm5pj/mWGzh6t1qAqB1t/2SljyYTGwbIuPJ91UdvIb3aSAeZ1ZXfKQ9o6X8u/XSPtPN502k8UhwQkebMtJpcDEIJbx3CBHf2NKzw
 wtUY7ve0
 VvFNT9lmdfH3eqCqYDMkh2HBbDSO7zpKgllPdjjc95SluhueZckCuQrtjL81lSdxV0+9HmH781TWNhTExyUbbBZ2Row54tfWrA4CaIIOc1yhCanRcVtWI9MKE4eTKzK4jViC4pSU5MUVnKi7CNOsKvHv9c0qy7gROgVvFDGM+BUM4H8k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> The __lruvec_stat_mod_folio is already safe against irqs, so there is no
> need to have a separate interface (i.e. lruvec_stat_mod_folio) which
> wraps calls to it with irq disabling and reenabling. Let's rename
> __lruvec_stat_mod_folio to lruvec_stat_mod_folio.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

