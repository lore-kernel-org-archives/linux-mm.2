Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E605606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zatd8Vt0
Received: by kanga.kvack.org (Postfix)
	id 7D8576B05C2; Wed, 18 Nov 2026 10:21:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD7E6B05C3; Wed, 18 Nov 2026 10:21:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677686B05C4; Wed, 18 Nov 2026 10:21:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43B846B05C2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:21:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD53A1A075D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:21:53 +0000 (UTC)
X-FDA: 85448604906.19.BAB2625
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E9EBA1C0012
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:21:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zatd8Vt0;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015312;
	b=RwQSq7EnvxI8KSvLBS90E47LFV/leyaALDdn/NKWdgis1nEY08W/wmUmHDzEOHrXCQtz7P
	4VGZjDOVXK1rUKnokgYOscIJuT2+qfGIVQ0qw8FFqA9tFUqIxRTkBLgngv/PPpk2niutVK
	lHFnc9jIuq+r2Eu0+vXB52StCWUmSLk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zatd8Vt0;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjHf/N+E74CHlMypQ6kG0MO/j1AaxlMnO45unT7fRs8=;
	b=qIfPIMCvyyadaJvkguOmvffXiqzgTw1+uJsJNqEJImHS3GZD7Oem4NnrfVgrCx3lKGR2mW
	1HJcbJt/MIAC/Z57ZYmxvp8Mz7GJ9Otdw0EPDFhNvkt7Yw3HgSaGE/W1Yok8Qr5HmoEghx
	OffyApOJLwsIee0ODrrVCSJ3gwrgDeU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46F7340601;
	Wed, 18 Nov 2026 15:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587FD1F000C4;
	Wed, 18 Nov 2026 15:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015311;
	bh=zjHf/N+E74CHlMypQ6kG0MO/j1AaxlMnO45unT7fRs8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Zatd8Vt0ywkplJtY52sv1C6gqcSe5RQKIFV+5E71Yls+0SNUpVBiJwgzdPLtELYUe
	 lMEeHjRrAnWCh2jU/xSsBaecsX4m19vZToDTdpSksFBkKQ+BznUVf+kzqQpRE594cl
	 xI8Xzi02t1DvZZ4QYsxI3pXSUlMMlXjiS6thpbcD+kd0ditk+o0zuiajNisMWqprBJ
	 /63zF2q7x1g0nOMjPpptKxP3+nsGFzPTU+2b5WqClj1L/DhevvwIx0kJR7RAEdV+V1
	 Jl3RUAzke75z/aoxyBUnO1R5v5m1VuTsvFwkZGVLKCc2UzrfJ4Rc20DHv+e1oARAVi
	 NavFFG/ZUVtzw==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 James Houghton <jthoughton@google.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>, 
 Tal Zussman <tz2294@columbia.edu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, dri-devel@lists.freedesktop.org, 
 intel-xe@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
 amd-gfx@lists.freedesktop.org
In-Reply-To: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
Subject: Re: (subset) [PATCH v3 0/9] userfaultfd: assorted fixes (part 1)
Message-Id: <179501529906.13844.1913398195867025027.b4-ty@b4>
Date: Wed, 18 Nov 2026 16:21:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Queue-Id: E9EBA1C0012
X-Stat-Signature: 91wqnotdi4y4wkuyzs3x4w3uxwub6rp5
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795015311-60062
X-HE-Meta: U2FsdGVkX18TUunI5xzHc+OXVhSZzN049SmOj15IA/i8l6ls6lUjAWzfzKg/PF6aHTNC+SRrOgwmH4qs5VgRRi5xrOllKExO3THlKSb7EbFlBnPLMqIBFi6gdo0r8on/YruLXUkN2GtAhpY5TgzA9gCNexG5hMNIxRKJ3tHY6v0YEXZk1MG5aQmjDRaWs8y0JZkr1D2b/IfQPU4LPvjfYjLkee3MIR94pul0ndmjsLxzUgPBbXyRZ9ciklD4DnmgqzictGHNb4V01r56R18BWx4+ih4C8wVsAzSDQHUJyseHNkUrS3NNljaUDrEmRdQcTQlVxgAAn6NAy8jnMMf3DaOi7qq6kw8VmnfRv+JhOAJQLyCg5O7wYbMrlqWMDTxbT4K2C/l2yfjQwbJOmqqBk66wcm20GoqP3MK6KFYThFmd2RZk8BxTCiO6oDmcvSwqaO+VgLyKlRoshWrSNv+SS+iTSERzcQqKJZGKjVoDQ6vCuifWvcfZhnI2RI4F7D/qIA5VckV95T6zHW4v7K4r2fSsC50YmFmj0rmpfSB0mO1+uKxfKNEgNV8U07ZD5RqLNn4tGHhwkFGjxoa4F4IqkSeqKLV4GFq9T/GkI0EXS8ylJ/5t7JvzSUP8fYYaE7x2trCg6w0F8eO9hdEFoJWUlF/AGdMDTt3wPovBLkv/GbYyHz6KCxQeuUM4bf5JBru/v+JJqMt+E9RPq9bZb1vp/oL0E04YSNA0G7PNeUetZBS6701F9qSAy4Tqblb2VQYGCBiNc3tY1X65qIlpcXbZIWl7V62EsK4cA6TmgC+tJjrWDIXHKT3ctffrzhE3Yq3q5Btd0+GFLDSJfqngXPEs8C+Tx3I07teJqe6E9kq/EBVMkvjCzVPzHG/PVYdPqUTlKYvkc/8yglg+jxyxSKCBCU+FO8BG2dYVxK6QRrJHUKXjmusUXQB5Nkb1gS2f+r7f3HY4LD3r4YP+DHgPYAU
 +t+5eF59
 k6LTSZYsxtWPaKBbQULOhqBWFpesY9ls+6NkdMfKHGfxk1bNy9aU8lQCXrh1ZkSbpiXsVwg29Xjm+VHPqx6+nVnp4QA0S0n3Auqlz8Gpy3sKya75ibpbtdA0OxY3e59tKwyx80ZDd9/MqK7inh6U8K49TqMGuBgBb5sHMJwWcJjnjgXxIlTFEOrGtBWhudIaSrsri/PDFT4MheIXuXCBWHS7JzlG5D7ahoTx5nB5RQ7Wuiz0YmUpLDbACyhsBm3JkARBP3My/EYPcQ21W3la6h1liVTr4UFE2QtRQ0I+e4yyxrqyD4cT5Em2T7skTMVzBRyp4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 23:28:40 -0500, Tal Zussman wrote:
> This is a first batch of userfaultfd fixes, with more to come.
> 
> These were found by a mix of regular old LLM review and by having an LLM
> write a TLA+ model of uffd interactions with PTE bits and other state
> and seeing what issues fell out.
> 
> Most of these fix places where mm code loses uffd-wp or RWP protection
> while moving or migrating an entry. Userspace then either misses writes
> and accesses, or gets pages reported that nobody touched.
> There is also a hang in UFFDIO_MOVE, and UFFDIO_ZEROPAGE modifying a
> file through a private mapping.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: migrate-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[8/9] mm/migrate_device: do not migrate a uffd-protected zero page
      https://git.kernel.org/mm/core/c/a37a6cf0

-- 
Cheers,

David


