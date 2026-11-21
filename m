Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4AA9606A682
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bsKGCzny
Received: by kanga.kvack.org (Postfix)
	id 829096B05CA; Fri, 20 Nov 2026 20:10:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9D46B05CB; Fri, 20 Nov 2026 20:10:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8226B05CC; Fri, 20 Nov 2026 20:10:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44D6F6B05CA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:10:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFE411A0283
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:10:00 +0000 (UTC)
X-FDA: 85457344560.09.8E8FBE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2C94840003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bsKGCzny;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223399;
	b=6THE8nRAVheHTjRmdTAjLoSGYXYH4o6xl/VuN5WzgaTbNhSxo0pAJ6tcB2IgaZQHQ51zBA
	ZD7xb5jDT7H+gHBdzjy52J9cKZauRxyLWH3Mn4QdJEQEJjFteZIkoMf1E2lWfjkl5rmjqS
	D5K6qi6+c3rWnrmfhVV1bidNLkZpp6M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223399;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIRz7Bu3xA8jvuNJ5QjD7Bq2AHUadNgvHZi4azhrEq4=;
	b=Qqm9h/dINiyweUrxf+UdRKtdNQDJp37p7ODlrC0tHYFflDnY1pa3tlylmWpBzfmlojRnhh
	cp7lxWeXm5Vnb8JsypbVdCEETfXiguH+KWfEUeUZL94+oncArdxl8W0JasN2hm0IWQffag
	rmkDm73OKK5HXtQWc3I0HmEvdEBvTx0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bsKGCzny;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FFB04426A;
	Sat, 21 Nov 2026 01:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FA61F000ED;
	Sat, 21 Nov 2026 01:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223397;
	bh=gIRz7Bu3xA8jvuNJ5QjD7Bq2AHUadNgvHZi4azhrEq4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bsKGCznyguiOBe680jgB59UM4bRmkcUCQlRMdtYq0/nxsUsBkvk/JsdTQzz4/g9os
	 W14+mE5h/e8e1s1XNiHJb0ubnFSweyllG86R4cQ86Zcb6X4Gfu8MoxZ2O8Aor5eDuz
	 u2I+tX48DvU+/kPEf1a3JT7hDAX7lBMSlQlfWGKPCEUZRmdlOPI+hqmpGsEFn8HOUH
	 Mx8X+9YGqbEKodDGBxmFPSYhmq/DGEBxnT8kAB9EXcX9JNy6oiU6XykxoMhjrlFxRL
	 r8DrUuMTSp3iIgQPIYHVzfgb82lX+gGUtNwjO9lfeAHIp0HqNf+5XfIfoO81u/OsEs
	 YfEhuCUUs+3Zg==
Message-ID: <sashiko-outbox-226489@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 25/25] Documentation: Add PISA architecture
 documentation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Joerg Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Jens
 Axboe" <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Harry Yoo" <harry@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Jann
 Horn" <jannh@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Simon
 Horman" <horms@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Willem de Bruijn" <willemb@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Alexander Lobakin" <aleksander.lobakin@intel.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Naman
 Gulati" <namangulati@google.com>, "Pranjal Shrivastava" <praan@google.com>, "Mostafa
 Saleh" <smostafa@google.com>, "Randy Dunlap" <rdunlap@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261120010655.467825-26-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-26-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:54 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C94840003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 1s656m1h9mfz1wjy3rqxqx3jg6q6bu3p
X-HE-Tag: 1795223399-477164
X-HE-Meta: U2FsdGVkX18sSDbAjx8eZylePTD+9BU7SmhzynfjLmrG8rtRth1t/80ZaNINQujeRJcDn7YOuP7vITlbOYb+qiinNO96ZOc3ESJMiXxwI80J8U0Bx9skudk4lJQbdjpkRX+kuDVZNC+lHNYtnz1vhuiCTTObrV1/mi/ciBW5txwq+fjx1G3Wp5uKAFQSprEW2iGpD/LUb3O/q+blquWPSRR+6Z1TfkID15CeDbAUzyduG0aEvROAFRFAwsLc1oEPo6QmvPR3IoywzDWcV1pqY9JZTrUvv3daWWkPvmzoU86ul+gzbENrc3G4UEjYlGKnEEvXnXeLODoy89Va4K40CRmV9TaRlYYOqA5eo+hoALxuBBECsc1pJPU5US5TDNA6vWRo+O0UnwvNL3ljbAg5cjFUridw760pN/yYgoaasxkzGzjPp5AhAs/RFd+B3jbId5xLP/8RAWT3EnBlQijUTOwV1RX6fBgYlDh85GkdKCAlsSqD8r72vEJXWJ3+cWW9JMAGVR1UkshFiREaLqL7QBiATWw89vIBISI4UufCxNdOCGnIL0Dv4mbVa+HAqQZLik5JiHLx5e2f6uwQ85mmCa8oIZQAtIv+ZIQTFfH7Ps+vX/DoK5IfKI6m+2zmcIKbBh4h71Qnh5TH4DpTxWhGEM4abOxgND3qO6tXsW+ZJGvK6uI51LU6ItYJTXsxwnKP/LkwmdW9bECWx2pk9557CvIIxZZdJGR8+xt3wSLiyV0VXfqiUF6S7/gKpeZuX4RINabQhYCG9pNZptV/2SV4lbKcVcBMOOMmdGv6+SXBPUfKwxGXd8/C/sAetrrzjyFiOltGlpJph70CMXB4pn7wsKY9HjVf0RBqtoOfbmobg+cqlhRg7QTd3hwujRxhzKDGaa0zdhIw2VrgNfh8o3ZtPhiaQz48XNG9XLsYuDLi0Rst+tnHeJqKfXBy9JVVIrseGKhy0hbgpYEMo61I8Ln
 7T3FE+0V
 V8uPk9pwc5EuPOSyZIJ/wKtt+/yJ0EI3oeImLohnPhVz+2XpmNl8m8aln9lKGr1U8DETFA4x2B5gdA5Cr41hetIUZR8u5VK1oiLiN9+f+4VQFaYHMeXh25QaN/vRUPaOwRAraZPflKk4awgF2c8AcPHfjhff26VVeXvf91E54km8jQl3oN5zvaxEZUEiK/oMhJxvtUHn4UHWRbcpNeOVegKKgOOWXsemht7vP/aclbUpHsHN1uB3r0nA1pCZAE9mXQ+MPGg/eJ2X9CQqDUDF2mdCnJIu34GEinvNm/4vfdIHoub/2WTqLp1exmRW7Y5ATDvWyERVIdA6GYl7t4ZNrwlWAEuYy+NsPwRm1wj34DJMX9A5Trdy/1F1pWP7uUpuFm+SDMkse4u5cyz2tuwd/q3sGqDTlRiOPmgJKNr89HiqtNxVNVLcT4BlVT/OY4x2HfzRd9efen2ousOA8M7+6IdAUiM8XSkSYynPmA1Sco2UCwKqN5C0OUODEc1NlfBkV881WZrSU8quxpBHIblYgOPzsUJu3amNigoQ5+M9N5ZyIxp/c5hrRfpK2FQ17Cgbt/xANfbae2l/MyaJkL235WJeu1e8yET2hcmmLjuwDdTNqbME8XSgjz1Q/4zvzvThWC7nhr0bpDTtV/esMjKb5anBKOIXwG3gcny9nMoxDM5o4+agHT35cdeCJZx4vgVf6bEUcjssM8Hl5CZnAigAKdzpIj90HZlM3W7/Psj/hyDxZEbsB8KkKM3hwfRE+K+N6faJidz649TV5Cu2jGg+Fj4NwSPH14NwQBFRQ2AwUGVTZ3BDEiYHOdM6kldI4YcDqLxdkm75J+TbY5Z8d3MkjIgmgNHciLAHXlJ2DTpt2eKw7pO5CGtMzXF1cBaSYC8EleyDH2sxlsJq3WEs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] docs: pisa.rst claims CoCo disables pisa_tx_skb_heads but
  code does not
--

commit 6f86ffee9c2de79fdda7c37ed8b420a9db3ff92f
Author: Luigi Rizzo <lrizzo@google.com>

Documentation: Add PISA architecture documentation

This commit adds core API documentation and a kernel-parameters.txt entry
for the Pre-mapped IOVA Superpage Allocator (PISA).

> diff --git a/Documentation/core-api/pisa.rst b/Documentation/core-api/pis=
a.rst
> new file mode 100644
> index 0000000000000..f9690b4a9c96a
> --- /dev/null
> +++ b/Documentation/core-api/pisa.rst

[ ... ]

> +- **Small skb heads**
> +
> +  - PISA is enabled per device via ``pisa_tx_skb_heads``,
> +    which allows small skb heads to come from an ``skbuff_small_head_pis=
a`` slab cache,
> +    backed by PISA memory mapped ``DMA_TO_DEVICE``.
> +    PISA memory is only used in the cases listed earlier.
> +
> +    One exception, PISA memory is never used for skb small heads in Conf=
idential
> +    Computing because it would expose kernel pointers and callback struc=
tures.

[Severity: Medium]
Does the implementation enforce this Confidential Computing restriction
for pisa_tx_skb_heads?

Neither net_pisa_tx_skb_heads_set() nor pisa_tx_flags() in
net/core/pisa-net.c checks pisa_decrypt_enabled() or
force_dma_unencrypted(), and __pisa_alloc_folio() in mm/pisa-alloc.c
allocates SLAB_CACHE_PISA_RO folios from PISA pages that are decrypted in
Confidential Computing guests.  If pisa_tx_skb_heads is enabled on a
device in a Confidential Computing guest, small skb heads (including
skb_shared_info pointers and callback structures) are allocated from
decrypted host-shared PISA pages rather than falling back to swiotlb.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D25

