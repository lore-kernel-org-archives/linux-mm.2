Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DD1606A32E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oudw1gho
Received: by kanga.kvack.org (Postfix)
	id 992836B05B1; Wed,  4 Nov 2026 04:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942606B05B2; Wed,  4 Nov 2026 04:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A0B6B05B3; Wed,  4 Nov 2026 04:51:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6071D6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:51:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF6F6A0557
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:51:25 +0000 (UTC)
X-FDA: 85396968930.08.FABC209
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5955D160005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:51:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oudw1gho;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793785884;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFOrB0RlUyfBaL1ZVNyfIXXD7jm51UKr3SX0ZVzaBSM=;
	b=oBqVW1yEp9uXOPPaWJ4j2fnVSu3rAoaaNkRErj6/MR6BmS1tZxgIHvnrdsOVx65aUD3lte
	NZEvk0DIzPdLYRSa2koH50pUwYB/0ai4Y8tolVZElaTGKv+/6ZdCQwMrXM2HMi86LPUlhR
	WmPUlA7oonhfpT3NHYEizJ66+lwXqiM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793785884;
	b=384PQr1y1wx1kdmSlRQK8HGOf4vtD1U5kYavP6KqvdaTu1r2s7TvvIj6xQcIbNpknwjyEZ
	MQqcDdahS+RpUj/j/l/tgydClyk2duIp1KtVAPX7ryI3IolDvdkPrAh8X9hRkHf2rUAvuV
	w1w4iEXrS7a03nBh9p2Bjt2QB18TRuA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oudw1gho;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF9AE601F0;
	Wed,  4 Nov 2026 09:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E221F00919;
	Wed,  4 Nov 2026 09:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793785883;
	bh=nFOrB0RlUyfBaL1ZVNyfIXXD7jm51UKr3SX0ZVzaBSM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oudw1ghofc92RwmeX+P3J9uu8wG0/EGGONuNuDVEJPiJ8h1qlF6AL1v7AiGaRFIb8
	 a6LkTbPpLJaV3Jfo86XS7xXCDZRfIlRg4cpeizPdgkXnKg8MUGzCqhosT7TDw7+cpG
	 1UifggURqR3AtHwfwdjuMzXyMBKEGH/+CtH1GS+xeHrdqXZCHyTXS8sDv2BJy8V7WE
	 sJvMuyl7LXooB6tyg98+03iIQdgMdeIqU6W8ldNzmvd7JW8ua+wl7EU9uBSJXjjLX2
	 L+RnymVx7mTq6VopCnCX9ZE0smTg9GRY2jyiqeGuwbPiiOuEuhr51RkyVIX9xsXr58
	 fovbepPsx19OA==
Message-ID: <sashiko-outbox-197002@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 3/6] virtio-mem: support memmap_on_memory in Big
 Block Mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikolaos Karaolidis" <nick@karaolidis.com>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Randy Dunlap" <rdunlap@infradead.org>
Cc: "Oscar Salvador" <osalvador@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>, "Jason
 Wang" <jasowangio@gmail.com>, "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>,
 =?utf-8?b?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Michal
 Hocko" <mhocko@suse.com>, "Hui Zhu" <teawater@gmail.com>, "Georgi Djakov" <georgi.djakov@oss.qualcomm.com>, virtualization@lists.linux.dev, linux-mm@kvack.org, linux-cxl@vger.kernel.org
In-Reply-To: <20261103-virtio-mem-memmap-v1-3-308ae1da6240@karaolidis.com>
References: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
 <20261103-virtio-mem-memmap-v1-3-308ae1da6240@karaolidis.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 09:51:22 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: e7nfz5nie7uroiyzrgch6en7fqa8t1kw
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5955D160005
X-Rspam-User: 
X-HE-Tag: 1793785884-988607
X-HE-Meta: U2FsdGVkX1/cjn8gqHmuKH4VBbZggOeKayXPOKmFcNJNLqU4RUcm3D9RoIVYlIGM4FO7+hSoxDHqUDqkdYgQYJ287Vla9FbidkStC2jUmtnbq+G6yGlwASxcJBrCwt0LlEah/5HW0Mu5SD3lCrbyXssH3iFWU0kiWpKlHI+obf0FJYQ6DZ138G08ztLwCsvJNA1osuG2+p2QXxMdT3q0P+HuJUlgrKJTL3mlxOZ2HxXNqx4fE2AHT1SbKnt4QeiN6Ar6rG9FD+uhTUKBOkzv0ahApv+oMIJ1ILlabrTVeMlYx/neVZuae3gOpZg97IjQNOPVYt68M/N2vIWG2pEp7HsLnaPDE2cpbQjuzDiugQwckHrhzBxdm4yjrZKJFksUWihAqArWirhONiFTc735gP4vPpzrGUMSZ9EEeDhmlqRUwU4GrWoqWiLxddv72+PQkySqo4Xr+lDeAYUDRDTGiEimG43HbATUqIRqeiuHMr/Ew4vsysfyCerU6CYyzF3LzJ+hiY6/vIJ6ym99/uiD/GuM+wPdc0D2+f6gfuEQFAa9cqsBiim6yX9PxovSC63vLs9Pn/3GdyDJH//TY20Kl7D9YUFNjd6NLbZFObo2CPrZzzVctGtYzxBkX0i+mwXsxHI/hoFFUyHnACR+Sn45YlKao4jA8I5+IFOuEfrX8G9eIh/O/Rq6wxbjru0snrwE3oqkL37T5s0hecEKdJY7MopksaRNOtPMywJJl+qHGQb1EQEXJ4FpJGPUEHiZLHO70Ua0bxeHkuQmfHbghz/O8i0G8UAfeyz+GrNK9K9VCbcMJLr8TthwNodxoM12FpP9ymPmHPR7SPCjzcKSd14u4jT4ZZ9tSQa0eVwFTreAJ9Ue9gUQ+zjgzxOMlRvhKAsjwZlyQ1Nq647sksxxRU9dtpuF8xlG4SmN3f8JowjiBvH1BlBTMKDAxFokvwJXNdgAUE4uYrdzcFR5GdDsxbQ
 9YeOoCwi
 MgQBNBscwVSxfP6JTas2PgsDyY4Df7UbuoIBk/v+JOEA89b1w7u9yNctJ2r8hWcns2Yz4NoP97Fv8f6reQkZRfilTjtrJOcT+EetRcLD1D+3XYdwbTHGjfNeow0BOQst6F4qVD0NfOenaU3IbjVpjD2gp3zv3acQUrpQv2q/HqBxSduraktpQ7O7ipaLaMmx2MPmr8ZSfZIn/XOAIE+BEGXcZK7BPErzA98WhfNqIHaZ/iWQ9jpCYxyoOLV6WnkAjpLMBrgFGa2blHCTp3acVHIsWJkxnDFZNcnKM6EesbmelCcVuQV0gk1FXIm7drw+27nALzdvrrBJ6Ppw0o35xx4ntHSNv/SXnqzVyZqAUKbdz1QZibje4DByz+Dkj82M/z5cU2UkuyPouMxRSUjqXEJhhIva6SiGBHG955TKbKrRUQgu2gDI6JDIXKWTgHd3qh0GlIgmvN+XEhy4YhwQ/MC3ElOBbH0GmUnre+PDI5/lkoU95heHs46ICaVueS/p7q5gTXSf+zrPK6jGx4k1wxByWRWFim9ny9ogefrV9F00gBlDoQHkpIhu5VdWjjYeEesCIpSJoK1R7NML0+km110Ml1Yvgp+XyZzZd0nxTbPM/T1QXVQK459uLIS1W2A0lYJmMRqy5QINzsVnwfAP78sxEpCdD/Qb4v4fRSjXftGPqxQk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] virtio-mem: missing kernel-parameters.txt entry for virtio_mem.memm=
ap_on_memory
--

commit 20926ca463fbc5ddc5964493d1dbdfa119302f38
Author: Nikolaos Karaolidis <nick@karaolidis.com>

virtio-mem: support memmap_on_memory in Big Block Mode

This commit adds a virtio_mem.memmap_on_memory module parameter to enable
self-hosted memmaps via MHP_MEMMAP_ON_MEMORY when operating in Big Block Mo=
de,
and skips the memmap pages during fake-offlining and rollback.

> diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
> index ab06adbc0342b..034d07207e44d 100644
> --- a/drivers/virtio/virtio_mem.c
> +++ b/drivers/virtio/virtio_mem.c
> @@ -40,6 +40,11 @@ module_param(bbm_block_size, ulong, 0444);
>  MODULE_PARM_DESC(bbm_block_size,
>  		 "Big Block size in bytes. Default is 0 (auto-detection).");
> =20
> +static bool memmap_on_memory;
> +module_param(memmap_on_memory, bool, 0444);
> +MODULE_PARM_DESC(memmap_on_memory,
> +		 "Allocate the memmap from hotplugged memory itself if memory_hotplug.=
memmap_on_memory is enabled. Default is 0.");

[Severity: Low]
drivers/virtio/virtio_mem.c registers the new memmap_on_memory module
parameter with 0444 permissions, which can be passed on the kernel command
line at boot as virtio_mem.memmap_on_memory=3D.

Should Documentation/admin-guide/kernel-parameters.txt also be updated to
document virtio_mem.memmap_on_memory, its format, what it controls, and the
architectures it applies to?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-virtio-mem=
-memmap-v1-0-308ae1da6240@karaolidis.com?part=3D3

