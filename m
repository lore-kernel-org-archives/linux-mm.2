Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BD55606D83B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LqwrdTgO
Received: by kanga.kvack.org (Postfix)
	id B41116B05B3; Thu,  5 Nov 2026 06:11:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18AF6B05B4; Thu,  5 Nov 2026 06:11:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55FA6B05B5; Thu,  5 Nov 2026 06:11:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3E76B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:11:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 958B01C43F6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:11:57 +0000 (UTC)
X-FDA: 85400800674.17.F68029C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E3575180006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:11:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LqwrdTgO;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793877115;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enixJkjvt/NjGzx2vZdqFTkXKPfd4qcXQu8lRjKJNZg=;
	b=wRHJma8OFveTWdWm4NwQfoC+mDxBckCtw77Ozk9ByXc1CwlF4T6WBUi0xrQBAtSmujaVyL
	W6TWAYaCmC0/yJKbzAlRC82zN6lkHmwHqjO+zxe5hfvU8QbIlGulkfypK0rsTOmtbgP2dW
	LE/+khc0sq2pvLZYdarqSi2hMxBq7Pw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793877115;
	b=qnkarpvkOIp0Iz4l/VSD1XscjkRh4ceBrMAyRd9b+8U1YD+0Mh1yClNWG0YbmzLQz0fV7z
	sUjyJqfXjHzzd47t2rfLimcvOC1BxIEUoDk1/HoY5wfOhqhFscuRCSlqwkIGI2oRUiz7e4
	c49mufJ2g/EFI9o3O04AyI1vj0RsMu0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LqwrdTgO;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99C5460D91;
	Thu,  5 Nov 2026 11:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99511F00919;
	Thu,  5 Nov 2026 11:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793877114;
	bh=enixJkjvt/NjGzx2vZdqFTkXKPfd4qcXQu8lRjKJNZg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LqwrdTgOAHYSfUZcCn0vb7egFoGlnn/N25DberiwXI2r9Nuan10LzGhj9TOTvc4hq
	 aRLKo586J9Jj71jjdo2VlOkAT/orK4gAlgaFE4P6O7VKEi6hdnj25pKLDWL9myPx+U
	 jWZWyOtctKFaf8lmRnasULc7fMQVuW1Wzcl2/EaENoVrDU9TS2O8CPwNdxqIvJFcAy
	 ZQ+MfX6a6r4jgl4wL0Xq+/umegY7ix5rxuuPx9Fhqe0plwgj6xjoQLP1S+mbkJuNoG
	 YcnBsyy9XWslw0oR9Jozyi+3QwJVuOhSFTMdXCQoHhIi3Gn/3uBKejCot25qhdoOJn
	 bqwniPkRTAQfg==
Message-ID: <sashiko-outbox-198916@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/8] memcg: Add MEMCG_DMABUF accounting
 infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Albert Esteve" <aesteve@redhat.com>, "Tejun Heo" <tj@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Sumit
 Semwal" <sumit.semwal@linaro.org>, =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Benjamin Gaignard" <benjamin.gaignard@collabora.com>, "Brian
 Starkey" <Brian.Starkey@arm.com>, "John Stultz" <jstultz@google.com>, "T.J.
 Mercier" <tjmercier@google.com>, "Christian Brauner" <brauner@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, "Stephen Smalley" <stephen.smalley.work@gmail.com>, "Shuah
 Khan" <shuah@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 =?utf-8?b?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, "Jens Wiklander" <jenswi@kernel.org>, "Sumit
 Garg" <sumit.garg@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, op-tee@lists.trustedfirmware.org, media-ci@linuxtv.org
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-1-1819a017000b@redhat.com>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-1-1819a017000b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 11:11:52 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: dw6sqbqtax9mz9g4iu4kt1gwt4rqxfc5
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E3575180006
X-Rspam-User: 
X-HE-Tag: 1793877115-716175
X-HE-Meta: U2FsdGVkX19tXbwZPZV37QiIeLCzv98Q6Wt1wKpybLBLOz8n2AtUWc42LtZ/KkXMWh02N4Y4K/J+/6NK8huOCo+TSXS3iQdFIPL1a8CR1tr/Gn64j7F0YL46SVZMSAbDpgFHAFh/gHATO4175rxifun2YQoZraOx5I7Jm3d1l1dnkOLKgs16/5Eb6E6xJN/6l6FtEAx3b1AyA7FBAj0encavHJEkGpL/JOFqYS27fOEI9UahZ/Hp0iHe04QHCkxlBo4Akj0OFSBOWut+3drmHLa4bqBZBq+9OjtY22vrcr0GAW3lgCNeYzoMwUUIpG+FfrXOzdK1pfZj1Qi0XjPcs0Zym6H1B1AYcB8DvQBeZmLe1hQK4oRkLFerYrxwXS8ynOVDgtWiK8n07u3qdKu/zEvyxsrxo1P8QkRU251z5CvMXVWbkAZcLxMqlkhLyYyGILgDTHi1q/oK92FYnf3tbcl7HIXJB97RnLkN85xsduY5W74EexV3TCOHzWLHjVAqqbMRpOZcirb6PgSBJAioZBPi08G4t+e9o0hN0hxzewCd/W03LEcFsXeVSqDy7ftR10/08bJVNXI2Bz6eLmFKUH+Ve5o0elMMEzhIU7ewiEcUw0KzXibTFCpBsaRKuZszwWRlCoYkcey14yP7ALZrhEBA8eO2kBMOJss/5k6Rpft05S/vlISl7xEK9KLg7fQDgxp07cEhnQIxgtdjd7ahW9uU6ZkEOrA3/hm23jmntY8Tq8IFIqm1nJDJgpltttIvNNNKDdZOD5Ya7SUyEhb1CkmBHK8rSKDNvePFW0dLz4VKj0dvWp0XEdjaP+HvyT9uKGr2sKdc+/cVpq3EVn/mk9YLOYKM/XcXpCVPifsj9t6cCkDDH5iGXaJ9JTzpLSqjgd3ztaqwvY3FRRvCJ4cJ/yP0T17Y6WNuguuPxVOuHCTWj8naIvFn8DgzcsOAxwcvPKPTd3vOwWbq2MQvzGI
 D0cwlELd
 stccgBbD71Io7AH+iJClpa9vH6IhV+iNdDZvyYOB47JyhZTW4Ra239mSJZf7s0iTTk1+MWeNM9bORbKEUAuV34UUFKLsBbeyL5oMVVoDOdEZ90Xm389D6JU56j0nMjXOwYv9qI1lUFnXiZz/LMCos0ZILhpQV5HXkazlyHMIBeIpUwsCHWuu0uM1lDxglBKd8N/exCJsg0j/h7ru6LXV7hNm3nDDJUfLEGW4z82COtkus8qkGIhShSCWy9PC2EU3aOcXQq0u1yOy/XOxvW64nWIH5N8l6LAYEpVKZ1Hm/9l7zxEuLMeDZiX1Mf0YQ6QhQmnPT1H8TrqsUYtvc6xUJhB00YTk8daw2h8Or+E6CVBH301OJ0zlTeglaimfC07PUX1aqQLLMQvD+JgwyI//LXjFRXW/5SLGHlYTVMm5zj8NC8hihuhrIeuwU92ah+QcwpX8rE8lBnVyT0l5EIeoGTn/Qdlwfn1o2VkEVmWjCsrXkBirPYEhnfDaUpEyoNinUH+HPzB0jpxBVyYPay6xeh/8x1eZ3t8omMO0XAIz35wqkp5XSwK/IZnlbK/17svxvG0r+2DbjN+68y1b0P+t7TbhSUAqhK2NUeB0SoBkt0OpsOmNkPOV99WzIU/5w520MjSIm9znr7Tvcyd80Wgye2v/dmSErH2QKW/7KTgNiJlQLpnnIhzPxBnoc4T5pVzUHPQQxMW15xokWmWrhF6p+YYmG0A0d/ZFRHLT/3b+bs3AH0EQ=
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
- [Medium] mm: memcontrol: 32-bit nr_pages truncation in dmabuf charge help=
ers
--

commit a5e6165b3e0444a33f57a14736c2174d7c009944
Author: T.J. Mercier <tjmercier@google.com>

memcg: Add MEMCG_DMABUF accounting infrastructure

This commit introduces the MEMCG_DMABUF stat counter and helper functions
to reserve, cancel, and uncharge dma-buf memory against a memory cgroup,
tracking the active charge via a memcg pointer on struct dma_buf.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 856a7d07586cc..e53dd7eebc3b5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c

[ ... ]

> @@ -5658,6 +5661,73 @@ void mem_cgroup_flush_workqueue(void)
>  	flush_workqueue(memcg_wq);
>  }
> =20
> +/**
> + * mem_cgroup_reserve_dmabuf - charge a memcg for a dma-buf allocation
> + * @memcg: memcg to charge (may be %NULL)
> + * @gfp_mask: reclaim mode
> + * @nr_pages: number of pages to charge
> + *
> + * Charges @nr_pages against @memcg. Call this before allocating pages so
> + * the cgroup limit is enforced up front. On success the caller must
> + * finalize the charge with the MEMCG_DMABUF stat update, or call
> + * mem_cgroup_cancel_dmabuf() to undo it.
> + *
> + * Returns %true on success, %false if the charge would exceed the limit.
> + */
> +bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp_mask,
> +			       unsigned int nr_pages)
> +{
> +	if (!memcg || mem_cgroup_disabled())
> +		return true;
> +
> +	if (try_charge(memcg, gfp_mask, nr_pages))
> +		return false;
> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(mem_cgroup_reserve_dmabuf);
> +
> +/**
> + * mem_cgroup_cancel_dmabuf - undo a dma-buf charge
> + * @memcg: memcg to uncharge (may be %NULL)
> + * @nr_pages: same value passed to mem_cgroup_reserve_dmabuf()
> + *
> + * Returns @nr_pages of charge to @memcg. Use when the allocation fails
> + * after mem_cgroup_reserve_dmabuf().
> + */
> +void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_=
pages)
> +{
> +	if (!memcg)
> +		return;
> +
> +	if (!mem_cgroup_is_root(memcg))
> +		refill_stock(memcg, nr_pages);
> +}
> +EXPORT_SYMBOL_GPL(mem_cgroup_cancel_dmabuf);
> +
> +/**
> + * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
> + * @dmabuf: buffer to uncharge
> + *
> + * Reverses a finalized dma-buf charge. Drops the memcg
> + * reference stored in @dmabuf->memcg and clears the pointer.
> + * Safe to call when @dmabuf->memcg is %NULL.
> + */
> +void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf)
> +{
> +	unsigned int nr_pages;
> +	struct mem_cgroup *memcg =3D dmabuf->memcg;
> +
> +	if (!memcg)
> +		return;
> +
> +	nr_pages =3D PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
> +	mod_memcg_state(memcg, MEMCG_DMABUF, -nr_pages);
> +	mem_cgroup_cancel_dmabuf(memcg, nr_pages);
> +	mem_cgroup_put(memcg);
> +	dmabuf->memcg =3D NULL;
> +}

[Severity: Medium]
Can passing a 32-bit unsigned int for nr_pages in
mem_cgroup_reserve_dmabuf(), mem_cgroup_cancel_dmabuf(), and
mem_cgroup_uncharge_dmabuf() in mm/memcontrol.c (and include/linux/memcontr=
ol.h)
truncate 64-bit dma-buf sizes?

struct dma_buf stores size as a 64-bit size_t, and in the following commit
("dma-heap: charge dma-buf memory via explicit memcg"),
dma_heap_ioctl_allocate() -> system_heap_allocate() passes a 64-bit
PAGE_ALIGN(len) >> PAGE_SHIFT to mem_cgroup_reserve_dmabuf() before
entering its while (size_remaining > 0) page allocation loop without
__GFP_ACCOUNT.

If a userspace caller requests an allocation where len >=3D (1ULL << (32 +
PAGE_SHIFT)) (for example, (1ULL << 44) + PAGE_SIZE on a 4 KiB page
system), PAGE_ALIGN(len) >> PAGE_SHIFT wraps to 1 page when converted to
unsigned int nr_pages. try_charge() will then succeed against a small
memory.max limit while system_heap_allocate() proceeds to allocate
unaccounted pages using the full 64-bit size_remaining.

Additionally, in mem_cgroup_uncharge_dmabuf(), passing -nr_pages to
mod_memcg_state(memcg, MEMCG_DMABUF, -nr_pages) (which takes a signed int
val) will overflow when nr_pages exceeds INT_MAX. Should nr_pages use
unsigned long (or size_t) across these helpers?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-v2_2023012=
3_tjmercier_google_com-v4-0-1819a017000b@redhat.com?part=3D1

