Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 705C7606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=iBq+nqKL
Received: by kanga.kvack.org (Postfix)
	id 77E3B6B05BC; Mon, 26 Oct 2026 22:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E456B05BD; Mon, 26 Oct 2026 22:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6DB6B05BE; Mon, 26 Oct 2026 22:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF756B05BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:44:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1C174090B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:44:29 +0000 (UTC)
X-FDA: 85366862658.09.D328AD5
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2DA10180002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:44:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="iBq+nq K";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jD8NrEF10P2VtaMB8bhjtU6NtVeQsEVr6wPPMXQfP+A=;
	b=VMs46crcfa6PYVMoUoWAKIay5DDx95H6yjNfxXZwWr/OdhD8GWwhdXYjM3RrB76kLPsjwu
	Vp9D49Uxujs1hwS0csp/9VzJGyahUsaipVsDTdSoJPMjunbXIfTdM/tW/+t4Q+YBUpzng0
	yfLp67PpnFIEDbIhYWXOVRGUnN2jBpo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="iBq+nq K";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069068;
	b=MuDROHgpYtHDncTa/jL5kr0dgsl3an8S/qQs22tfVEXJsoKAm9N74IldDXZ77U4LhZEv64
	fxpDgb9xr2LoY2T/aQsEh54shLErsQ26mtzUQ7ypYqtSNeirPsSWSbN7XHJsfPbkNDpxqF
	L7zpF4u9M9ddim+ot4stvlbr+2BApcw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=jD8NrEF10P2VtaMB8bhjtU6NtVeQsEVr6wPPMXQfP+A=; b=iBq+nq
	KLOEjbYYdUAPAEsZwkrsVlsMbau8sPaQUcFxapsXRqkp5x7L0HKbiz1V+JwuKcTR/GBqgaCvr71vs
	Azl5exRlAEe+DimTQWh8fS0vwDU2CsiljZsMdUYZDAPvE5/hwXnoNhMGxlXeqfF7JYCSjK6mmcfeW
	BfiPVgT3S4zTiGr3VU359pUEU7q0FHXgB6OThiw+NTjQPpMdcwrnSU5ZEyXwFVFYW0t+NalyqESRH
	CfKP89P11ExVsiA3ldtFd1nVlkbgGl6/jisI5NTNJX9ju733TLXV4llbeM7Mjm7VlOJ93SU0QV4F4
	bX5UR21h5xQnnQD/hzqAbQwGl8zw==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xLX9Q-0000000B2wR-2Z6a;
	Tue, 27 Oct 2026 02:43:00 +0000
Message-ID: <f12ffd4cf8933452ef13adae55d6d238a3069235.camel@surriel.com>
Subject: Re: [PATCH 06/46] mm/filemap: read mapping->a_ops->free_folio under
 i_lock
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton	
 <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko	 <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt	
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Kairui Song	
 <kasong@tencent.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen	
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu	
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Baolin Wang	
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>, Kees
 Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Jann Horn	
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins	
 <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush
 Yadav	 <pratyush@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Lance Yang <lance.yang@linux.dev>, Harry Yoo	 <harry@kernel.org>, Alistair
 Popple <apopple@nvidia.com>, Nico Pache	 <nico.pache@linux.dev>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain	 <dev.jain@arm.com>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau	 <kas@kernel.org>, Matthew Brost
 <matthew.brost@intel.com>, John Hubbard	 <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Will Deacon <will@kernel.org>,  "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Oscar Salvador
 <osalvador@suse.de>,  Minchan Kim <minchan@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>,  Chengming Zhou
 <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>,  Nhat Pham <nphamcs@gmail.com>, Youngjun Park
 <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>,  Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Ying Huang	
 <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, 	linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, 	linux-cxl@vger.kernel.org, Josef Bacik
 <josef@toxicpanda.com>, 	stable@vger.kernel.org
Date: Mon, 26 Oct 2026 22:43:00 -0400
In-Reply-To: <20261027-fixes_core-v1-6-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
	 <20261027-fixes_core-v1-6-6f74bec9a5bb@kernel.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 2DA10180002
X-Stat-Signature: a1gigikyjq9kp1ihg8utpgb8ky5ghefe
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793069068-587084
X-HE-Meta: U2FsdGVkX19hqza95NP2Zi7VCpXtX25OEEUgtC/weuSemwCZ4NKnoqwjYJ+MvbEZwv4iqHyJW7LH7ijVEvUTOMRBSpLsslup0zBGaryzypUlLu+16fi4gsxuMkNsytMEL25Jrwnqz5J48YAn5TiEjHW7ROmvww5igYimG3KAw7XrrASytcSROKUJiFHkINipkfKoe4/hR9WkQF0sr/3iaAE0j7e+BDJqtqKv397K7JPkFusES93hssdtrO0b+TsHPxIfWGBnJazqcXdWU8XNUjGZseFI9WJAANXQZy3B1crWkx/w8O24frFCrYqKcYYr5JqreZHRMv6n1K9A4IqYbW7gvZF+8lpUfYHzA19eyEEYrGenlxUqcAftCyAyuJpoR3mD2XKGhNbsNSnSHtFRmvQVp71W7M1LddvK8eCxA2jNVhwn4/YjJmZ09b7LdvkeSo0tg0BCGqdrFK4v5MoXq7P3cdOuYb8dTymubfBAcXxKqD4Qya7D/CypBn5PG3yX/ODEEIo1JxL6EuF2N4ImB+Ixy5XUbXLWyaUkO7jsbiW84Z7E7Y1cB02wHkS84ePuEJe3XZ60WzVkD3Day0Z/8FSKzGfcs2xrLUgOpr120UiKrQefVtN/NEi0nrbpiyxruJeHEIIy9UN6HHiFYD8kihWjwWhQhmYViup0OBvSaSdVqfn6OtWYWVttv3sSdXbGAMB0fe4LxuN4SKl+Cd38VfdMBwjiY3GbN6jCXMrN/DbfEIaCeDSclJ7XRD5Aku6nNiQl+XQLjznLWr+QOudItqGNW+qCSsK5PbXjPQOFAZGdP9zoIT10Q5vb0eZ99x8pQhSnQHMgovKbFGIuks1/W3qLj1NjQsIrdzkZYVCwFLfQsa2ZHKK60ZHmeExocXfyzW3f6tdPlEoZTn/hV1lFH/S78fbMWAotzm6vYKKm5yp5ko5QLUtVYFXWFXIvAke9bM/QI8Dqy+sU8jtqDls
 G4M4gZbZ
 DKk/nFCW5Ma9lzBHZP6XYkGv94gn0LsgWsysYVeDSbMSYR+iUPjUTBXa+YVpoHMadbhvhC8iFRcV9hQD7s6GWCYRdtUp27+4CskhhShmv8Daa9SlQAOX4AJZpNm2g+0TwGODffud8Ze9r1MxCjYz8a3TLwYe2TJ4tsPhdyaae2pMyqheAzA2yxhZ6fIqJCK592KaB1F3Kxm1qaU2L0lmZZlLBjL04rUWIWd/DSXdlyB6BErt5rBt5PTTeCPpiKdpDp+/Rbt7yWQaSNN8HJdgrY6/v+OfObN4XGgEO1dtrl42XeJVooMX2+UkEmTbkIou5DMpGV5O0IvCbdZSKiXj85UahMsCvQvan6vUIZrH67XRqfZsEtNuU/IOJ5hgcoKutDAerm3/8b0pgCJJOzO5rPLc9F2OtiaujXV5Kg+P+U8O3gwkOK7bGLaZ2iivyhobom3kHlpFbgqqUxZ94KTwexMGVf/A69BB8Vy5Fbi9p7xAZVqZf32FoBFJXNdvdOBzTauT7r0qOZeXNybJSyzauELfm4Bgo+NAnnErR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-10-27 at 00:17 +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
>=20
> The bug was found by code inspection and has not been reproduced.
>=20
I can't say I'm surprised ;)

I see clues that a most bunch of these issues
occasionally happen in our (rather large) fleet,=C2=A0
but not this one.

> Fix generated by an LLM and sent by Josef Bacik in private.
>=20
> Fixes: 59c66c5f8c4f ("mm: factor out page cache page freeing into a
> separate function")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: get rid of filemap_free_folio() entirely; improve patch
> description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>=20

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

