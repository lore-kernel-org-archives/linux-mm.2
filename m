Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 237D4C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B366B0088; Fri, 18 Sep 2026 17:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162E16B008A; Fri, 18 Sep 2026 17:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079426B008C; Fri, 18 Sep 2026 17:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C77366B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:18:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF7261A078D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:18:31 +0000 (UTC)
X-FDA: 85228146822.03.DCB59D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 180B8100009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:18:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLe9EhHC;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789766310;
	b=b5N4Rr00NXWobZIzcZISUFGLO7/LktfPtvd7uJd9QFALDx9mLQnskNPzk1Ysf/RsRYKPLR
	fg4T1/T50/BHIONxfP/PPtWY9kZJNYMlAFkO1ECPHjvYXzQuUl8gDH4XWNKm5Fma/7kFVs
	zFKmIOzH+Gr/4qXTAmAmWUyHASmrbC8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLe9EhHC;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789766310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uV71i9dxmN5La2QHPB3LFaEp9NirZveEU2dy4qv0nc=;
	b=n0yiEgsSfI4fODDXzjh1SxBPAFF4vmxUWZ0NSpe9I44C1ryyJmVTw9kfObd8R1rTr9u/EK
	ArWtRpgALHpkVvH6l6586wa0ZxNOFz4QfFDiqQ+lBJJFXTXi6iiI9R3CVgePG/xdXrIOWY
	LmJXk4DVJtl2xE2S19vEiECdG+KD9QU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2ACDB401A4;
	Fri, 18 Sep 2026 21:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E701F000FF;
	Fri, 18 Sep 2026 21:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789766309;
	bh=6uV71i9dxmN5La2QHPB3LFaEp9NirZveEU2dy4qv0nc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oLe9EhHCMalkQExDUURMOq31tWgH4Qpwd1QfK5RvLXBZUgHhJKledONWFp0LSeYl8
	 Gwnj0arvPPj6AEpcgvnXY2Kid454NQUl2tsF8B1bpPhTeITUFLW4e2+mRyJfAqPWWM
	 CoLGKuCLlKbY4cQUL22MXsg3iNRCtY5Pz9GH6s0S7ZTAhdwX1jTO1uhBiaOGm3zUtu
	 tAjgHoNw4zXw2pP1yV14jEsI2Nj25+EkIlQzTljQUjT8M9FlG5WUbvnmV8X4yJd+jk
	 UhTgKRrRmx2WIpwFfA1C1oVK1eagi/pgJg35z4gH2gdzJUP9QTRNzTNYcVturylDhH
	 5AiFxXqkD2JZg==
Message-ID: <a4205a11-f0c4-49cc-8bdb-b294dc342dc6@kernel.org>
Date: Fri, 18 Sep 2026 23:18:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 03/29] loongarch: mm: add PMD swap-exclusive helpers
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com, Huacai Chen <chenhuacai@kernel.org>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-4-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914122950.3283997-4-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 180B8100009
X-Stat-Signature: af5sueizu5ardu5hu84ibjw48b5mdka4
X-HE-Tag: 1789766309-467014
X-HE-Meta: U2FsdGVkX181cZEghinktnfreAOGqXMW4GpIEpjrD1p5x3FRzPl3IANPvbDwBeZz4I1MLO9CxrOid3Xme51Gnri/W1SjT+UU3VnPkiP3iW2aTxwqKx4tEqlVHFZYDXxsT/MGEghu1MWJZJEFRd525aW85nGHPStkZshDuYjrGHTWejRorHWK1LAuXTKPAzqNlLuTExcxcQsyw/6a/IyEoMJB8uC27bDCu9Mcr1hODLiLeTZ3D4NKaBjlh9a+AeWXkz5pjRId52zq0FOaFqFDRUNAlGYKvXxwW8HAklgzIW7OfPUyAcYaeuXPdlPwkrukixMVhOCL/1r9TPeNF5VPVwuCy3cmTlVWdOJCRh/lW/97KRsukB8JO5XVK4QYRck9w2J4to4RP2eG4yV7F7KpfWORS99PLet0YsTcPd5sXd62vqqX9NtYVIj4S8Rf12t/kf85Cgf5HKuTqV6umZZbFNUgrK1K+OTQl2bxAZSjQ4o+xVCQCW9sWuuop9Ar38uUdABqNygDPzhTFRjVWTj4wP/eU663e/GGM8po1WKmae6NDi8ygZRViJPufiA90aYG9kqOl+mi45MUR2gnEJNSmR1gL30Z27qxZS6gf5jUIFaeGMu/j16xmqQ82UMBHV1apHWE1QB2IjxnmV4EBAALX2pBml3s1UVPhO3yubwER/Z9iiaDcHT0fZ5rud9ziX5npq7uKu84bcZJ+xgR5Wn/fIhJv1+RRn9gSOZyi9doWnjZPGhPbm5qNDkUoMV6TD+ZTwtIKnw+chR4yKGkjkX0VpASa2IMM8fehq1lUbMoqKeyP8ZIGk9FX2+yfSBef0fB/T5AZKIiFnS+3wzzoSCfqfhUIEVJXyF2rY7Ydfbo16yAgastq6+pgxtUfWFiGG9IYlZJEroJL0/lcRLIR1Fnqb6qdF8VIScr/gA/KbBTzppj+eMAkt5sVYKinvMfOf5iEldzpxzqPRdyHJUTkhn
 fkcqmVCI
 dux4xuRzV9FxWHUZ4nL8TGHwAflPayNrJlb6DMNW8/8ctn7JJVAve5QqiR2h8HHpzUEHNaLjQQXZs77LHQydOO22dJx6b3DVKGJyFreSI9r7SRfbwG0YJQRM11hs1XIqmX/68q9RvAm68UpAwXxYFOfJ/6lpDVHhc+nlhUevXb+ZcqYgWeIDwjgGsjU9WQlMl9xK8rDPUmcVsvLWA1vqZbPGgy/l8aoSDT7FzxctBeNTF3N4781hEhhC7EqmMJxi7ItpRUNCYHUGktiFPdZpnGFSONpEBYMwMqNIU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 14:27, Usama Arif wrote:
> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
> not just in a swap PTE.
> 
> A LoongArch swap PMD is the swap PTE value plus _PAGE_HUGE, and
> _PAGE_SWP_EXCLUSIVE sits outside both the type and the offset field, so the
> PMD helpers can use the same bit.
> 
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

