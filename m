Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12B3ACA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15AAB6B008C; Tue, 29 Sep 2026 03:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132406B0092; Tue, 29 Sep 2026 03:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 048986B0093; Tue, 29 Sep 2026 03:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5D706B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:30:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CABD1C1DB6
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:30:15 +0000 (UTC)
X-FDA: 85265976390.26.252CA7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 92E6C8000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:30:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B4heSQdz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790667013;
	b=rd7eh6JIDxuWGAu5N3YuEGMkfTJdAlLY3UGasy76a5j+GLzcuVSuiobGkDXfeYJccP4t8Z
	pYKfMj4EtOQfC3SazvU43fQOi2EfiKbzuKMq48Y/qTETtE58ryVeifGLeFdsrouFr4ZyvI
	Xw3FHHYVjBjmtRGMPi8RbKYvy/vnSIE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B4heSQdz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790667013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFhSlZBaUkH6xGhsYdrWxCRhPZNn++zm2ii0wkj+7yc=;
	b=T2w+jbevclwiZyuP6mTuuaETSAq+rOwXhj4ZxywViyzve0Th21OoYRaPc452wAEuRaHwQv
	ctSqCIsl8Rn6J6gqc5TBBwckpKJFRC/4jUgF/JCD374GghORHI5NYAtVvgB2HLqJjzSDUe
	YohiRGnOfsQmQAdASzCbZTNWeUQeVWM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1555429C8;
	Tue, 29 Sep 2026 07:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D501F000FF;
	Tue, 29 Sep 2026 07:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790667012;
	bh=fFhSlZBaUkH6xGhsYdrWxCRhPZNn++zm2ii0wkj+7yc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B4heSQdz/tMGqNY0slQOXLzlZADZOd1dREgw2hLpJuin0+Y/BvyRJVvhE9H311PiN
	 UdkIz6MHgNClCIeaF3ktCwfACFHHvKFYNCNYvebxw9adLLf2IJYvEexDN+mVyzHuAy
	 3k/ahn482F5vG4IHXX1ST5aRmRIq2QOx/pNZxbLPrW6/fPjaPrD6trp4WhIKWIZb1X
	 xC3QP9ZZFOwLCfdx1AFk10bV8E4GyHCjiFxSjDv3V6OcHCOS7ftwNB4MLeMm7o98nZ
	 sQTK8rhjbfYRyMJVzjNJ/kl1Afn+JBTTLP18zsoD7fwkwmoS6aD7FOlYqJt1FpZkXv
	 jPO0B/TzOk3KA==
Message-ID: <751f6586-625b-4485-9f27-409fdf38bf3e@kernel.org>
Date: Tue, 29 Sep 2026 09:30:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/12] mm/sparse-vmemmap: set compound page order for
 device DAX
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-7-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927025441.741633-7-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: d6xxpassup7zdmu5or56h9tnhp6jgyb5
X-Rspam-User: 
X-Rspamd-Queue-Id: 92E6C8000B
X-HE-Tag: 1790667013-267174
X-HE-Meta: U2FsdGVkX1/5C+oR/8+uEEu0BsONF1iydGs6HpwZR/DAToau9fcl5yqU5k0+4tKv/8o6QE3UY+j+SRmPIzb4K0UG+UZznuiMK0tmkxndRsNEOS9DLHnQzytBja0oIzlymeEZn7ThLrbxHod7VzrCdAenLvpMj/sc3kiQLZrE2wDguUS12UBSC9Mm2e8RzNpPRYcVpPH05XHdsFCSDUuZz8DQYgkGLwoTIdzWrOtBS+ztOHWrIYfqQ+y+MWJp/JkfjXFZDlH/zo+/dak2XON1eHKyHOhQNT7hW2Xdy7V8ISiEAJ/hKeJWtvPcFf3eox8/ltsBam8bEixsra/X6eO6u2szKGuMd8tpeAxPDcoTGHKW7qfBlSo81NcNfaoDCDbrlZ3eJ2th+TDl8yoExfODKIyINAi2mDP12cpkRZJctI67ZBNJPoSFl1PbZJH8YOREMFNNgqqOedC5B1n1Edk1TkCcyc/YWqGpNpkeuG9jxg+wY1F9EJUrH9qfxKvVnw3u6aWZzm75F11BbxJzYBkYWKpnVEFA77KttOiug7FuJCyM9D4JlJxePUrw8v+VLb0xyLDOBSV+4mYboSIL+W1GYMyhTwmpAeoSFx4peSJJC9MkbIR7po1vYz69fvqZMlWbMqw59tC9fm4ZKyLvWZ3oB5fzkiYFcVoWb+D07sTEfBqgRRu5htsTRDjRz7snN4VABDPjwZdBPtBWgKWLXKgYfAEjbnYmpd80GFl/CSwdzqwb6goVq8KJgYv6EKoN3mGYT9aa4ORpfX6E98NgxLGGSKzHI1EcCppGe8QtxiBL9Ne9kkMwlNKcsouCKiMlDa8rOgy/l8uY4ifwtqsLUujuzH6Nmti2XJnsemcvq51Y49Aac4nSXGG6N2OdMNqmDgc0y4BH5fgzUfiswpaa16qdyDmdFTUiRBAvwuBtMfhXY24i6zR3OgcfU3fCGFuLZ3FJuGqRGKTsQ+vj9D8duXj
 DXqoIoyy
 1DJqBpuxFebcOTOUVIueBWwOBvp3sm12WIk8iTJOgzbZ4L57Jff8ECasD15vEYp/VDyoO+FxvNErNNgYnme7f4UAlc7Rbd+OGD2cpIFZKudBCHaXi1q7hPGbG9guqgy+XN/6SOs8KajG/EwGEhuPT3OWU6Z2MvF06eb+Gnz/WqrnsUCbpA3mWxfXhOLHb8dV6EMvJeEgPe9DIXd9G6xivV6PVYJpc4M7J4vEwrOz+tGOtzqncF9yIDbNPZv2m2f+U3fBzORTQpZc9reddGLvv3Kp6QVd0usf+RGh42IUINQJvRSD7SjuGJ2ZkL7/JpiD2tMzY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 04:54, Muchun Song wrote:
> Device DAX can use vmemmap optimization only when a full section is
> populated with a compound-page geometry. Record that geometry as the
> compound page order in section metadata before populating the section, so
> later vmemmap accounting and population decisions can use the section state
> directly.
> 
> Clear the compound page order when the section becomes empty again. Also
> reject partial additions to a section that already has optimized vmemmap
> mappings. compound_nr_pages() determines how many struct pages to
> initialize with a section as the smallest granularity. A section therefore
> cannot safely mix optimized and ordinary vmemmap layouts.
> 
> Partial additions continue to use ordinary vmemmap population, so they do
> not save vmemmap memory. Such additions are uncommon, and the lost saving
> is negligible.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> ---
> v3:
> - Update the subject and commit message to use compound page order
>   terminology
> - Use EOPNOTSUPP instead of ENOTSUPP
> 
> v2:
> - Explain why optimized and ordinary layouts cannot share a section
>   (suggested by Qi Zheng)
> - Collect Acked-by from Qi Zheng
> ---

[...]>
>  static struct page * __meminit section_activate(int nid, unsigned long pfn,
> @@ -838,8 +840,13 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
>  	struct mem_section *ms = __pfn_to_section(pfn);
>  	struct mem_section_usage *usage = NULL;
>  	struct page *memmap;
> +	unsigned int order;
>  	int rc;
>  
> +	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
> +	if (nr_pages < PAGES_PER_SECTION && section_compound_order(ms))
> +		return ERR_PTR(-EOPNOTSUPP);

Hm. Why should we support optimizing the vmemmap in case we fall into the same
memory section as boot memory?

In that case, there already is a memmap allocated during boot for the entire
section. IOW, we really shouldn't mess with the vmemmap in case we have an early
section.

But maybe I am missing something and this is already disallowed?

-- 
Cheers,

David

