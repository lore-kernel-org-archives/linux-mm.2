Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8983E606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O1YezwXQ
Received: by kanga.kvack.org (Postfix)
	id 7F3326B097A; Thu, 22 Oct 2026 11:44:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CBF96B097B; Thu, 22 Oct 2026 11:44:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708F56B097C; Thu, 22 Oct 2026 11:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2126B097A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:44:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF609A726A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:14 +0000 (UTC)
X-FDA: 85350683628.14.8E4E11C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2F0E7A0002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O1YezwXQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792683853;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0zqhnWdd2sFyaMi7vkmKkorHXARnmLsjNYTdh0a/5s=;
	b=O8YX8p96rvN1+6rFoQaU5qHTeYQCyVkVCHy3GdW4k8ZedcoFD4+MR2y4CAlVwWXlF8FoKh
	Rl2mIHf8CJd9tYvKIqBYKBfM++RTio/P5n6UuR26qeMC7M4ZW5+uPg51zLSjNZ4IIpoy7a
	ZpTu9NVt43vmxVwzyW+mL/75HKouok0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O1YezwXQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792683853;
	b=Nsz6ToDqnrvKaqYWERDsfOE4NM0RRDnhMhm4uMoFJxVvHYE0t8wsGsVqeSvBMrZ1Ttja21
	BzXihlobxcHM/RrY+U4vvBFQVv8zEGVQCTyt8bGExvMQGCxkRKDQ5vY7La9Dd0sXHSkD2Y
	3si2ebBYdwhsR2PEPi24ZNUdu4XGzic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD67061D82;
	Thu, 22 Oct 2026 15:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A801A1F031E4;
	Thu, 22 Oct 2026 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792683852;
	bh=Z0zqhnWdd2sFyaMi7vkmKkorHXARnmLsjNYTdh0a/5s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O1YezwXQII5U4uFlc8oAWY4iUlGinrbVafW9aoY/4Jmp/fU77oq9HS+6UCRsG2k5p
	 qljmwxzqELpRVt/X5zYvJZ0GVptEsk9mJvFmLhia4jEqlq9BQ8kOrkfxwtoQr7uw3g
	 GGMo7uzzKH77dHd7sNIFENO/zifuiXixP76Cb5Dh4PXnMaHPh4F/DiNQRXLRfz0i54
	 Fie/R8JNBSWflnQugGOsgZ8C5AWR7K+lSwlbGg8L0zvYid0a5U8pKdru8OdzDw3FIo
	 4pOsn1l21GXuKF83QTew03mNZDWLB3LYfhYD8btLScqSM/aTpbya34BDc502o4pTLw
	 XS+CFkNW5XtpA==
Message-ID: <sashiko-outbox-181717@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 1/8] memcg: Add MEMCG_DMABUF accounting
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
 =?utf-8?b?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, mripard@kernel.org, echanude@redhat.com, media-ci@linuxtv.org
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-1-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
 <20261021-v2_20230123_tjmercier_google_com-v2-1-ef6ee2dd8c5c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:44:10 +0000
X-Rspamd-Queue-Id: 2F0E7A0002
X-Stat-Signature: jtwnboebffiouhd7mkfd14fimofnxn1k
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792683853-985373
X-HE-Meta: U2FsdGVkX18WW2HFzqdPDkmG+nYv8Gdh+rfH/rnQl+YXDed9vxZFYKTfTwh1vVhA4XaBOQTejqT05zs0PVCCM8yiMAwrIgqwrzLQMORfHPBOEXhVomlv5qF60qQP4ZjBe6sXkLUyAI5a3xU+4X5MO6XrIWqCSsyq2cX3iVAyL5eR+5CkPw9JUr/kXyAfZBtiOZd6vZtWBWcsELisoXF0YLf+UQuQxoEPwpvHIl4e7SpLfXb+1ph1PHKhhc+QrYSzEt5iQOvMLMT72RfIfRty4OnurFXXnCMtgPF8m4/XIY/XPGn4ruio3kZtqnnZQFdoMLFTyjUzxdDglrkzazSY+qXxzRIujdvMQoxY/PMvUX14HLuq3DuNbAChnyyeM4IkcCBZ8JQrJKcT4rW9dvTruJzeYg6XzOwS0jbTwRhfQkjs0772O/BucAto2Yg9JJpwBbk0hx1W/3h9TlJnC1/UJwoM7fpmG2A0pd6jurcetnNmaGuVURGJGzWQZzks+rOj3IZVZwQVd/UiyUYREyz5eRnzvMN7T0Rm+WiksbWD6e++JowojU7YflTTvOddbaISGQ9FemugzLIo8OhdjBrdILlyh4rHj34IQudpPulfDC0HtPI3M/MDc4DKvJKm+p0bMSDHQY+LNA7HGjz6AujEGeqtlCSkFzCB/pdgvutbbTbKYUBLfAEqr2avSSTsRSwCUaGEf6rX+epZ5smugnfStbes6+WiNB3CjyKwOwO+neYs0xW+y3NVFc3vI+qq3TLRgE3ru5Laev5bSOqCwIURD4uQFpphNX5nGDvsVyPVCkAgIfHgwMM0UcIwmP4tcElE9wi8zcyA3OBzGPh/UbJRpQX4RRzxH2N4mQ2ohkXBIzkrvl/weehum+HkD1gLPGhy18xsj0XvIm2blpK5MxLJU76Xsvj2DNC8E4PKSS8nZA5OgzxMZqHm3+Zju2wlK0n42FIXoHlqhyuJsLLxfmK
 syCT+Rsq
 EauVcA5rRSOgWyWkUFhHdKdW6+nWhK29xjvEQk41GimG/UxwKkiFntsladlslQSvOMVJnesZzaRbS78A0gNHpJI+doFx76HeaMqBTs/LNfKuJlb6wsbzBEet7GybCUO05ALpirYi/5fbJmPIHbQfMqGY3PVjltHxhHc//+1w6oXkTYwFgceKw0TtjMcyn7oaQVa/Mwl2woL2GNBEkHnhflJN37qOsM4lGUmkvSWVq2S8mh3HK07J4j2SmHQqdRwwKQpAHQ2hap/0jFMJcYy+MPrB6nw6Pfx6sFiIYgxYhLQmBEl5UClL/DnYZJTqOr300e4WtcMRg1tAGtu0x9i6qham7qhmoNXZvIT3TKjpCt6lhsz01DBU0xKcsBPtrxuUFm1tatQH+tmMLll5O1ffCPXWpfnHVxuq+NV4oTL5Pt7915RnlpbE84o1S1zEiXumErpZAy2UeRf5wEZUsPrttXXuszagtt1Xr0cIMD4LwTGoCF/bgNAuVWY6Xe7YRyLH9plFcyEOAqdXuxphz2UBHXXkCSe3L41v2mt1i5tqtxTxub+d17FAiwsj3gybM4gaWxxuJGmFJcYePkT4ywTzDjZNj52eJNfccjC4+aeu4QQQ0hRHxI8dUpIRqgmMlOLIWKacPaENQUsVsWliWrjTN0NQY2g6fMYN7kyjC1OgPLlnBfbc7553phFScC0ZKXt+rzos9rMqzZC0qjnjx18hloYRoLfjVG7SKNwbOjuYpF4N5FzU=
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
- [High] dma-buf: system_heap: uncharged page allocation in system_heap_all=
ocate()
--

commit c1f3a1d4f988a0cc1048e5d03e0a2f1959fbf0ee
Author: T.J. Mercier <tjmercier@google.com>

memcg: Add MEMCG_DMABUF accounting infrastructure

This commit introduces a MEMCG_DMABUF stat counter along with
mem_cgroup_charge_dmabuf() and mem_cgroup_uncharge_dmabuf() helpers to
track dma-buf memory charges on struct dma_buf. It also removes
__GFP_ACCOUNT from system-heap page allocations in preparation for wiring
up charging in the dma-heap ioctl.

[ ... ]

> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/=
system_heap.c
> index c8959eadc71d1..0a99ac0183a81 100644
> --- a/drivers/dma-buf/heaps/system_heap.c
> +++ b/drivers/dma-buf/heaps/system_heap.c
> @@ -388,8 +388,6 @@ static struct page *alloc_largest_available(unsigned =
long size,
>  		if (max_order < orders[i])
>  			continue;
>  		flags =3D order_flags[i];
> -		if (mem_accounting)
> -			flags |=3D __GFP_ACCOUNT;
>  		page =3D alloc_pages(flags, orders[i]);
>  		if (!page)
>  			continue;

[Severity: High]
Does removing __GFP_ACCOUNT from alloc_largest_available() in
drivers/dma-buf/heaps/system_heap.c introduce a regression in memory
cgroup limit enforcement and bisectability?

First, this commit removes __GFP_ACCOUNT before any caller of
mem_cgroup_charge_dmabuf() exists, which leaves dma_heap.mem_accounting=3D1
non-functional at this commit until the subsequent patch ("dma-heap:
charge dma-buf memory via explicit memcg") wires up the call in
dma_heap_ioctl_allocate().

Second, even after dma_heap_ioctl_allocate() calls
mem_cgroup_charge_dmabuf(), mem_cgroup_charge_dmabuf() in mm/memcontrol.c
operates on an already-exported struct dma_buf:

mm/memcontrol.c:mem_cgroup_charge_dmabuf() {
	unsigned int nr_pages =3D PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;

	if (mem_cgroup_disabled())
		return true;

	if (try_charge(memcg, gfp_mask, nr_pages))
		return false;
    ...
}

When userspace invokes ioctl(DMA_HEAP_IOCTL_ALLOC) on /dev/dma_heap/system,
the call chain is:

  dma_heap_ioctl()
    -> dma_heap_ioctl_allocate()
      -> system_heap_allocate()
        -> alloc_largest_available()

Inside drivers/dma-buf/heaps/system_heap.c:system_heap_allocate(), the
allocation loop allocates and zeroes (via GFP_HIGHUSER | __GFP_ZERO) all
backing pages for the entire requested buffer before exporting the
dma_buf:

drivers/dma-buf/heaps/system_heap.c:system_heap_allocate() {
    ...
	while (size_remaining > 0) {
		/*
		 * Avoid trying to allocate memory if the process
		 * has been killed by SIGKILL
		 */
		if (fatal_signal_pending(current)) {
			ret =3D -EINTR;
			goto free_buffer;
		}

		page =3D alloc_largest_available(size_remaining, max_order);
		if (!page)
			goto free_buffer;

		list_add_tail(&page->lru, &pages);
		size_remaining -=3D page_size(page);
		max_order =3D compound_order(page);
		i++;
	}
    ...
}

system_heap_allocate() then allocates the scatter-gather table via
sg_alloc_table(), decrypts pages when cc_shared_buffer(buffer) is true,
and exports the struct dma_buf via dma_buf_export() before returning to
dma_heap_ioctl_allocate() where mem_cgroup_charge_dmabuf() is finally
called.

Previously, passing __GFP_ACCOUNT to alloc_pages() in
alloc_largest_available() charged each page to the calling task's memcg
during allocation, aborting the loop in system_heap_allocate() as soon as
the cgroup's memory.max limit was reached.

With charging deferred until after system_heap_allocate() completes, can a
task inside a memory-limited cgroup request a buffer much larger than its
memory.max limit and force the global page allocator to allocate and zero
arbitrary amounts of physical memory, triggering host-wide memory reclaim
or the global out-of-memory killer before mem_cgroup_charge_dmabuf() ever
checks the cgroup limit?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-v2_2023012=
3_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com?part=3D1

