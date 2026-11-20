Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D329C606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 12:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vn0+NOAZ
Received: by kanga.kvack.org (Postfix)
	id F1A5C6B05B7; Fri, 20 Nov 2026 07:03:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF27E6B05B8; Fri, 20 Nov 2026 07:03:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31006B05B9; Fri, 20 Nov 2026 07:03:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6D176B05B7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:03:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2757120EB4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:03:33 +0000 (UTC)
X-FDA: 85455362706.16.69AAEFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E261920004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:03:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vn0+NOAZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795176212;
	b=qbetOJg8b9VmohjMPUmeaCjiPd2KEk6K/AMyPc3UeHCCL4Qa4oV30WYoi5T3auh1p1tykV
	zx107rlpkb97qGkmDy2V14vSUCcjJW2e4k/jyZndbazexyRJB9VgS6JLh/nbr/edDe0U73
	qon8ahjLVYiz8vvUd3j8g8b4IOo2/Z0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795176212;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JpbgjL4knLgXBglW8ypDg+v8ydY1t6Op1Mpp+OkMS2o=;
	b=yLe7MFCs3uKw6oqhezZvTBJnc/0VMKvcJY09jh2ygYCNFGyiei7/7167EAg1EUBN49E5TW
	UVAVdJBOBXBZ/MMj7D2p9c2NSisRY8JR4/E9SYzPsXpt7KQGNkimd0Tces9rrO1I5xhI2V
	bcdzPCCPmYVUkKmrF3dh5UeTfmdbTpY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vn0+NOAZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 56B20612A1;
	Fri, 20 Nov 2026 12:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37031F000C0;
	Fri, 20 Nov 2026 12:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795176211;
	bh=JpbgjL4knLgXBglW8ypDg+v8ydY1t6Op1Mpp+OkMS2o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vn0+NOAZAfopI1A1pgN2iZwg5fiq+6haVEGBl6P/tCPbfv+e5mLHIatFy0/p4ztau
	 Ay9Dq2/p5qU0F4FA4EhThhYzloGkTeHqCW7jq4/RDl1PSlxJReiI24iS9Nsaa2nidq
	 BkonfAnQUxtCBg+vVvrutJTXZKL2EGznAbKehoB9mwrgu64gd6G9OxGn2cdHpSBpnn
	 /i5rB4MEDSfVI0PRXx16ON7jCShhXC/60RKHIaKeuey1UBjnaUrXV8j7UadaIh6oCl
	 scPbM8Hb93ryn2VLGRHWne785ZxAptUpD3Rok2aGiCfTNfn6vkdi8yKEvgYR8aqsV9
	 QayHN0UlxxjYQ==
Message-ID: <sashiko-outbox-225115@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 6/7] virtio_balloon: add DEVICE_INIT_REPORTED
 feature
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Brendan Jackman" <jackmanb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Suren Baghdasaryan" <surenb@google.com>, "Jason
 Wang" <jasowang@redhat.com>, "Andrea Arcangeli" <aarcange@redhat.com>, "Dev
 Jain" <dev.jain@arm.com>, "Geert Uytterhoeven" <geert@linux-m68k.org>, "Greg
 Ungerer" <gerg@linux-m68k.org>, "Gregory Price" <gourry@gourry.net>,
 =?utf-8?b?SHVhbmcsIFlpbmc=?= <ying.huang@linux.alibaba.com>, "Lance Yang" <lance.yang@linux.dev>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Magnus Lindholm" <linmag7@gmail.com>, "Matthew
 Wilcox" <willy@infradead.org>, "Miaohe Lin" <linmiaohe@huawei.com>, "Zi Yan" <ziy@nvidia.com>, linux-mm@kvack.org, virtualization@lists.linux.dev, "Jason
 Wang" <jasowangio@gmail.com>, =?utf-8?b?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, "Xuan
 Zhuo" <xuanzhuo@linux.alibaba.com>
In-Reply-To: <65c518234ce31fac3f6ed436455dcb415d4b1189.1795089715.git.mst@redhat.com>
References: <cover.1795089715.git.mst@redhat.com>
 <65c518234ce31fac3f6ed436455dcb415d4b1189.1795089715.git.mst@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 12:03:29 +0000
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: esx5yyszo89csx7wikx398hd4my3rmcr
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E261920004
X-HE-Tag: 1795176211-246061
X-HE-Meta: U2FsdGVkX1+dS3Qb5SuULHqaTjvaZwNIZ12X0BDv3f1uCV2uGrQ6DJ+Aa3u2jtWMYuqnClFH8O8wqCv29MQEn125L98Zh2MzNSkRWDgp3ZqWSeX0MrOwdsowhAbX8PMeQdzxDAHWrDkFWeV6yCmv1vizHj/Jcvm3oCuZcyN/+wu7ZzM52HZWnDoODj9Yn49M+ixHUTa9er8Z4aWRxvqbvBJADbK+CopZDdm1IHYJxuGyPTftt11LNZqUg706adwLhC8NFyonertFKxKM/cYORC3Don9ZaHP9ZzeWt9LEr4CtlOW8iNNhLzMmf48WMzrehNXZCihgZRWIVGxtMiZVbXXPxRQ0VDQ8Egj9G66xBZIA+QnCKKROa9OlKUMQkcBbqoXNC5h8LJON2Fs0/bY0lvT8RDmVDfEqpjGqfKDvpo7DeqPYvnquoezOe8Xo67OZff+Wjp46K/dVy7F11SrRgOEOHLugxChYJsG+9Z11W1kgXf73EPGi/S6pIf2mw83MsmTynPaFmT+t5KdHtTDUTEC6rL3cprqnhkFQDgsro07eyFJoqsD6vZeK12AJ7+0r1E2V0GOW1PjT2WFusPI2DRm6IaBJ+DuIbbW5sbQPuMKR6PWEUwU9JP7QyULzlWvvWctzcOxB7/FjK+KnIUmhQnDM1IEKKpDPv4RTviN5f0iKfm5ffUtDEkV1ideUI6GWprI+Q4LV0sBN2xAR+bVYqyVY0UhL0Xur+a54Mxbfh1G7Z9nAxCGyobFoxc16elymRKpoZ1iRsn+/WyI4p4NOb+XdzgaZGBNVHi3gmASEweVAcJZC3csfde5kMiWmQG8+AhPg9k0OvRRL7BwIe2V+dN2LdJbpq3KMFTxRCji3wqxgCz4WOlRlpOknk4zFkfHFZy1Js8wAtOgrYR71syNq/fZkbV8HNFRZdyO/FAfiRiELQ102LMibyL592EtqcJB0H5MXAqc6t4J4o6skDit
 jgcOPdOR
 2sxkRJ6b+pdb2qUw6ab904shs8zzj4AKW3/F0GXV5l4bFsaD5WeZkslZFJcB1+AfuJC+R0dUaBYLEO+jr3ffeOJAqcA/D5dCWRn9loW08ejSw/5CpUr2FBtBYzYuAnczQVhMReIqrrGJvA9eJIdH9PS9wxvT7M2sis55qhfwyJsBExWI80piOe4DFHwUgU1v6zcLke758iJS3wcENlvOuh6nMkUH4nRbQ6VyuVFzwexri076XWFU+itmBUMllpuJQ6bX3sZOjCV064FoHHXQi303TzL3YGli7e2Kj67+rmgLPWHjzqCPRhTZ4gjdOmEn4WyqVkHUU6mOWar4qkX/d3SwcK8GVGi3tMUPbsXZtABa6XC7mwIKC1baChTMEYvuEv9qaBoKL6Gi7xx/pkj+nxH0x2BRQIsBx9xIo5F/szLkTgjBIiBc7jILww56gvPve8xOwKCNElPOT+4EH3TVlafjEB0F32u4QxlRNApAYCPChW6dPeVtfWNNw9Nn0sWtEJDShNaIlIDFIRp1C42KcRBa/q5OtQxWsBuN8gxYWYE77oieYvhDo6JXCLBSpwga4TiclmfxgtSpeQPhetpTp1JDjUAPAniJuHHZomHjG8MKvoHdjGPl6n3tKUpGM6+/vpKyao2Tt0UiNuDvhXEx4ttlxoCoQuz7UZkEfdPw97hpNy3x8wlFgPWs8dJ6NOIqJLu3Y1tFC2csG9nVeOge/oRUInVzYX9xXaCFa+Y5IjR/cn0A3lzMJ1/dKydh0CNcQQ4kiF6ew9ItBvw/iIROSdohcjN+HAevq3ktEEdaAvqcQDQFbhGY+AzDmAoSHRI1ORNNNQ1+OcoalqerjjuY5qeP+KkysYKQ76MMr52eXIYQyFRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] virtio_balloon: 32-bit used length overflow in
  virtballoon_free_page_report()
- [High] virtio_balloon: stale PG_zeroed flag on free pages across
  hibernation resume
- [Medium] virtio_balloon: missing feature dependency checks in
  virtballoon_validate()
--

commit 45401c714e001e18d0bb9e4b0f46a6691e93f0cb
Author: Michael S. Tsirkin <mst@redhat.com>

virtio_balloon: add DEVICE_INIT_REPORTED feature

This commit adds support for the VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED
feature, allowing page reporting to mark reported pages as zeroed when the
host initializes them on reclaim.

> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_ball=
oon.c
> index 8c1b47ec17a29..4c6630c5f9599 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
[ ... ]
> @@ -205,7 +206,9 @@ static int virtballoon_free_page_report(struct page_r=
eporting_dev_info *pr_dev_i
>  	struct virtio_balloon *vb =3D
>  		container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
>  	struct virtqueue *vq =3D vb->reporting_vq;
> -	unsigned int unused, err;
> +	struct scatterlist *entry;
> +	unsigned int len, i;
> +	int err;
> =20
>  	/* We should always be able to add these buffers to an empty queue. */
>  	err =3D virtqueue_add_inbuf(vq, sg, nents, vb, GFP_NOWAIT);
> @@ -221,9 +224,24 @@ static int virtballoon_free_page_report(struct page_=
reporting_dev_info *pr_dev_i
>  	virtqueue_kick(vq);
> =20
>  	/* When host has read buffer, this completes via balloon_ack */
> -	wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
> +	wait_event(vb->acked, virtqueue_get_buf(vq, &len));
> =20
> -	return 0;
> +	if (!pr_dev_info->host_zeroes_pages)
> +		return 0;
> +
> +	/*
> +	 * Only a fully initialized batch may be marked reported when reported
> +	 * pages are treated as zeroed. A short completion does not identify
> +	 * which pages were initialized, so reject the entire batch.
> +	 * Subtract each entry to avoid overflowing a total-length accumulator.
> +	 */
> +	for_each_sg(sg, entry, nents, i) {
> +		if (len < entry->length)
> +			return -EIO;
> +		len -=3D entry->length;
> +	}
> +
> +	return len ? -EIO : 0;
>  }

[Severity: High]
Can virtqueue_get_buf() ever return a len large enough for a batch of 4 GiB
or more?

The Virtio used ring stores a 32-bit __virtio32 len field, so len is at most
U32_MAX (4 GiB - 1).  On CONFIG_ARM64_64K_PAGES, MAX_PAGE_ORDER is 13
(512 MiB per block) and capacity is up to PAGE_REPORTING_CAPACITY (32), so a
single scatterlist batch of 8 or more order-13 blocks totals 4 GiB to 16 Gi=
B.
For any batch of 4 GiB or more, subtracting entry->length from the 32-bit l=
en
always hits len < entry->length and returns -EIO, causing
page_reporting_cycle() to abort without marking the pages reported and retry
the same blocks on every reporting pass.

> @@ -1043,6 +1061,9 @@ static int virtballoon_probe(struct virtio_device *=
vdev)
>  #if defined(CONFIG_ARM64) && defined(CONFIG_ARM64_64K_PAGES)
>  		vb->pr_dev_info.order =3D 5;
>  #endif
> +		if (virtio_has_feature(vb->vdev,
> +				      VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED))
> +			vb->pr_dev_info.host_zeroes_pages =3D true;

[Severity: High]
Does enabling host_zeroes_pages leave stale PG_zeroed flags on free buddy
pages across hibernation resume when want_init_on_free() and
page_poisoning_enabled() are false?

During hibernation snapshot creation, free buddy page frames are excluded
from the image, while the vmemmap pages containing their struct page entries
(with PG_zeroed set by page_reporting_drain()) are saved.  During resume, t=
he
boot kernel uses those free physical page frames as temporary safe pages for
struct pbe chains and image buffers, and swsusp_arch_resume() restores the
saved struct page entries with PG_zeroed still set.  Afterward,
clear_or_poison_free_pages() only zeroes free pages when
page_poisoning_enabled() or want_init_on_free() is true:

kernel/power/snapshot.c:clear_or_poison_free_pages() {
    ...
	if (page_poisoning_enabled() || want_init_on_free()) {
		memory_bm_position_reset(bm);
		pfn =3D memory_bm_next_pfn(bm);
		while (pfn !=3D BM_END_OF_MAP) {
			if (pfn_valid(pfn))
				clear_or_poison_free_page(pfn_to_page(pfn));
    ...
}

In the default configuration where both are disabled, post_alloc_hook() and
vma_alloc_zeroed_movable_folio() see PG_zeroed set and skip zeroing, handing
dirty resume-kernel memory to __GFP_ZERO allocations and userspace page
faults.

> @@ -1189,6 +1210,11 @@ static int virtballoon_validate(struct virtio_devi=
ce *vdev)
>  	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
>  		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
> =20
> +	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) ||
> +	    page_poisoning_enabled_static())
> +		__virtio_clear_bit(vdev,
> +				   VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);

[Severity: Medium]
Should virtballoon_validate() clear VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED
when VIRTIO_BALLOON_F_REPORTING is not set, and keep VIRTIO_BALLOON_F_REPOR=
TING
enabled when want_init_on_free() is satisfied by
VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED?

If VIRTIO_BALLOON_F_REPORTING is absent or cleared above,
VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED remains set in vdev->features_array,
which can cause virtio_features_ok() to fail probe with -ENODEV on a device
that requires VIRTIO_BALLOON_F_REPORTING as a prerequisite.  In addition,
when want_init_on_free() is true and page_poisoning_enabled_static() is
false, the check above clears VIRTIO_BALLOON_F_REPORTING if the device does
not offer VIRTIO_BALLOON_F_PAGE_POISON, even when
VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED guarantees zeroed pages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795089715.gi=
t.mst@redhat.com?part=3D6

