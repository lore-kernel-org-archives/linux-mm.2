Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15059CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 16:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37E006B0092; Tue,  2 Jun 2026 12:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355396B0093; Tue,  2 Jun 2026 12:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B6F6B0095; Tue,  2 Jun 2026 12:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 169946B0092
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:08:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B13DD93479
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:08:08 +0000 (UTC)
X-FDA: 84835454256.05.6A370CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DE2F8180015
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:08:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9OEVz4r;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780416487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMzfNq+ehdXO/Jw3X2hRGcEOYo6KK0VIVTw3/YK9NuA=;
	b=i59rbvZvLGIaEmnv5SfQ4RvmnMhQ3sHudYdoyRRCo8+TD2uvmxW5PjGOYW+FK0iUrOJErJ
	E/yI7dQmEs4SQ8baCpiBJHX8BSeVXV0B33nmkbT4Ir5CIA6me9V5Ca9Pk2prpvLoVu4VUV
	L87mokJjPJyM3ksKbgf+3WZumdnY21I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780416487;
	b=g4kQb46sOC/nJmjOJmyLEvFGMwGZtDjr6IitnQXS/IlpE80a7Efzz9vPvjfYxGXr0av+bw
	dZa1RU/e2ZD5h2aR5m4jch2XWLs4zB5Af9yC9i+4Hwb/8WpQw5s5PONPa0KbaehxUNuLpz
	X5JytXpijQ5Hj2GI82kga8vSNH4TIoQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9OEVz4r;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BA8243208;
	Tue,  2 Jun 2026 16:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56CE1F00893;
	Tue,  2 Jun 2026 16:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780416485;
	bh=EMzfNq+ehdXO/Jw3X2hRGcEOYo6KK0VIVTw3/YK9NuA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I9OEVz4rylaFp3pNevk2zHSWkGG2xI2nyzD4N+VrsqzLiK1w7rxT6CEqu8obDWZrV
	 ir563Os2LvTO+r32bkhjQy5lRULt4Un5DdFFZymuxhsfWbK+SpHm91nfvdIPDUjoDX
	 LrVn3eYMXPMVQ4ezEpXf3grANdI58bDPZA6kzFBX2aiEPELH2AXKLEHljNlWdgTyVo
	 0SWGPlHjjXiahVuTpvmWHoMprGDGx/DDHMqOmHQ/1AZeCrbT/i8XS+KHZYkAgaAEte
	 R1bjzdWSobiftdLUC67botuwZLso+80sTGQkFhfiv1NgGalqM+THxadGthdkCcLHn6
	 +Pvw+93fVg6gQ==
Message-ID: <0867dac0-bc48-4aa9-891f-2066a3eff989@kernel.org>
Date: Wed, 3 Jun 2026 01:07:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
To: tao <tao.wangtao@honor.com>, catalin.marinas@arm.com, will@kernel.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, akpm@linux-foundation.org,
 david@kernel.org, willy@infradead.org, sj@kernel.org, kees@kernel.org,
 luizcap@redhat.com, zhangjiao2@cmss.chinamobile.com, kas@kernel.org,
 ljs@kernel.org
Cc: hpa@zytor.com, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jack@suse.cz, riel@surriel.com,
 jannh@google.com, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 nao.horiguchi@gmail.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, pfalcato@suse.de,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, damon@lists.linux.dev,
 shakeel.butt@linux.dev, ryncsn@gmail.com, 21cnbao@gmail.com,
 jparsana@google.com, dvander@google.com, zhangji1@honor.com,
 wangzicheng@honor.com
References: <20260527110147.17815-1-tao.wangtao@honor.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ey4l15FF9oEWH3xFySCAaCAx"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DE2F8180015
X-Stat-Signature: ci3szmib95oxdf6djtqb7bbutmmpfdkt
X-HE-Tag: 1780416486-615027
X-HE-Meta: U2FsdGVkX18ZN3GRMvFaCJenl2xdAqsk2UI7VdgdgD1rwkT6Ahrh10LlF1y8WnefJ59Y3SAIVO8Ffd6+nC0pre1IgV9JcUEPRAUxJzox1hmb4Kn/jmeR/ld01ol2+7bhQIHnG+Hj10yVsLZ3pzK67ODiNVyiW8epk+kJWBhCqo8aojXgZUJ+n9V9Ikcox+6X/PxY/kZQ0EC+OvyUOxlZ1h4Nfq4yGgq5sSJ/MbDsqWAdzvgSDbOaxpQAqz78vNlbnalfqqE8lOQtvgyxFZtoASgaS4OPMZzs7gIDr4ItfpulIysuba9Df2vQnzrKxaSZCBHl/mG+pExfYZqnYKHZbeQibsICgGThYItN6VTQhovNwHX7OZaxXr/VDULlR+1rcl3W8KxkEbcp5L5GFIJQxHRJxa5eb4bqUiH1y0Nz9gNW/eTDT4pSZzinexzRojrk+NE04SXmMZ9WQpHZQ5EljNu4PjJ7b/U9X0knxE7Opyb8NIi9Jj9K4cRvx2/hqLm7MJ5K8sXRNyvGG6B2QTUha4R0yGsJVVlJYzwnABuwp+VISfh8aX7mkpGf+Wz8Nn7SjSYUoHaLAbEjM0kpNUbpfGyw6PWkxJbgqRTgNwo8oxI5znsibS7SaLMUe/jxUTSdFLRTYgpg60LtukSIHEE0pRN9GcD+arHTfNMoNV7M6P9SWB/IqUgXdo8GhRQ6C76vPPE4Bj/tJqAoKyK1QflzsfwWDjRZE0nNEiTi9D7Ttk/c11hXZOIvtDtUNW+db+Qh9gU/iYtBYoNsb5Zj/c2si/iVuXwB2L/eqUl9OK8ab3jvOHapFcmK9nrgEMh1zl7MVe0CejpBR0yKjP/K/+uP9DGps7SGN7No+vZ9jmAUkgK5op/6mv4Uv8+KWhr9Ed6nty8tRaa9hn9vAIrY2lxNjzT4cKPGKYA4XLsxoxEpDqYKl20quBB2XBI4wd69x2TKHpi//fUx0qtPkJotmIv
 X1fyjnuQ
 AATppGUm37fvmtXkGGc9wg2YVXas/omiAYSWE8w5Omh1gHKs+eLrr6360RtsPgz9GVmMNjQE3kSLfVYw95HBgiGkLrrN+uHNsRn9ur6vpiD+yJuA0RhDlWTgalA8J3E97v2Al9WM88rSQfQdmgGUzMsD8W2IlHOk1hS4+/jcO3Lp0MrOqTEoWj4PN8VN3XcCyv3N6/4qAImO0YiT3r9ZRsncz0rO54axUeVe/MFRpP5QCCFps7uH+TE0AUmpUZsFPKQEh6PpvVJwBnfN7zoAkBIf9ChdfybGYG0SwRDumE5xF5d7bcFpkfbcLeNzonD/cI0dZjfgZY/4qgpP1W60blbwNpBKU2yquGVC7vufnLuD0+/ttcQWyKVKpwwemXrv7vf9WC8E2S7U08gXPXoweLo+Ef/TLnoZgzZYEiqUTDZf0KiBJkzKo72nk7GW3AwOFLNLtW/lzfi8hm5F75kvxYmiKYhQfAGJTN6o/5zL8F+dpCrfKhRXyxENfGqNx3iDwMjy2KZlgWtkIX6rqmAS7IYQ9uHTHOUmmBes6QiHy3hlXNgp7wgVEOxCmtArPmW0p23/8SYPlawyi7OkcNWKxNs10UOZ/dh2LT6QU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ey4l15FF9oEWH3xFySCAaCAx
Content-Type: multipart/mixed; boundary="------------YusAIRMqlR7LLXeBVYeRGebJ";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: tao <tao.wangtao@honor.com>, catalin.marinas@arm.com, will@kernel.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, akpm@linux-foundation.org,
 david@kernel.org, willy@infradead.org, sj@kernel.org, kees@kernel.org,
 luizcap@redhat.com, zhangjiao2@cmss.chinamobile.com, kas@kernel.org,
 ljs@kernel.org
Cc: hpa@zytor.com, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jack@suse.cz, riel@surriel.com,
 jannh@google.com, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 nao.horiguchi@gmail.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, pfalcato@suse.de,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, damon@lists.linux.dev,
 shakeel.butt@linux.dev, ryncsn@gmail.com, 21cnbao@gmail.com,
 jparsana@google.com, dvander@google.com, zhangji1@honor.com,
 wangzicheng@honor.com
Message-ID: <0867dac0-bc48-4aa9-891f-2066a3eff989@kernel.org>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
References: <20260527110147.17815-1-tao.wangtao@honor.com>
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>

--------------YusAIRMqlR7LLXeBVYeRGebJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 5/27/26 8:01 PM, tao wrote:
> Design overview
> ---------------
>=20
> ANON_VMA_LAZY defers anon_vma allocation until it is actually needed
> (for example during fork). VMAs that never participate in sharing can
> avoid creating anon_vma structures entirely.
>=20
> Before an anon_vma exists, rmap operations rely directly on VMA
> information, so no anon_vma locking is required. An anon_vma is created=

> and linked only when sharing semantics are required.

It is unfortunate that the design overview doesn't cover correctness
aspect at all. VMAs are subject to change (even before being shared with
other processes), and rmap needs something that doesn't go away across
VMA merging, split, etc.

I'm not sure how the idea is supposed work correctly.

--=20
Cheers,
Harry / Hyeonggon


--------------YusAIRMqlR7LLXeBVYeRGebJ--

--------------ey4l15FF9oEWH3xFySCAaCAx
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCah7/ywAKCRCGXBN6rc5S
1otsAP9nwP515uUxVeg/W2YVm5teA1//l+vahNQqqxIcs095VAD+Jy2ls4/NwtfN
KAQR7h3eWnaTbpGNQamLViiFJG7giQ8=
=rhvK
-----END PGP SIGNATURE-----

--------------ey4l15FF9oEWH3xFySCAaCAx--

