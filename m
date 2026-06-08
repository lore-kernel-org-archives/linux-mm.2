Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFAF6CD8CA8
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3383D6B008A; Mon,  8 Jun 2026 08:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F766B0093; Mon,  8 Jun 2026 08:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D106B0095; Mon,  8 Jun 2026 08:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1720E6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:52:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D53AA1A0ABD
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:52:15 +0000 (UTC)
X-FDA: 84856733430.20.E063951
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4E6C71C0007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:52:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AGt1SmTQ;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780923134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmVe8ku3CY5kinxGUaPpQUp63b+9qm/CHLoW2Y5uqCY=;
	b=OWi9JscDiZW/10R9BEyL7Th0rZx2Tls08BSjMZhrS65sFJKlFO/i8yBegH4FXIkizDJnSa
	DtcG0+h2W80q+xIzkGcWbBTR0ISN+Xz2WFHRC/l+CqEIkUE9CvReprdUAsnxgi99i3gYvw
	DtKnxeO8rK9auGu5AHBXlyZBNEdb4go=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AGt1SmTQ;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780923134;
	b=GjunW04JGzHJQY49bCYxnUK6uEk7BqUUpChgr6VXXTyPoRnhMwrZ4jP3Nx5HM3tJy/HitN
	D2TcjMwoWvFRh3izmSbdBmqXWJT1WAhLSZFgzxQBnprpL2NBS9sZS30PetB8egVmQsEXq6
	qRx4R89ONz6NuVlmjBKJ8sUaj2V4lHw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1FD36001D;
	Mon,  8 Jun 2026 12:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F4E1F00893;
	Mon,  8 Jun 2026 12:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780923133;
	bh=gmVe8ku3CY5kinxGUaPpQUp63b+9qm/CHLoW2Y5uqCY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AGt1SmTQgIucQ1ZtlRcS2Py3s4ECdl94z2/YN90I7SjGfvkcn+zQpRanBTE+QkzpA
	 igmMjICG+puOyd9F6z7V86Rwz8l0PcYfX2zlxUZ0QZwtRhyu9Gvn7lbuu7hW9/DPFl
	 19FyvqCbwuq06TfhnINGGwoKK60uJNcaioY8v6BVwOmfa3NnsVpgdWJ/yKnNcoLzBo
	 uL8X5yzJZ0A4aiNM1H5imsW+Uad5zwiU80LQ9eAOZeQyHVvXwcoEehfxXvhrvec1Zv
	 kxqHgJ6nPvELaGUeqFzv1eJbKuQX5BoN4F7Wue6ncQUU4P7lWmKawDI7czyGTF/OrB
	 I1qEc1ZiCG4mw==
Date: Mon, 8 Jun 2026 13:52:00 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 00/37] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <aia6Xi-zyb1N-y_I@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <aiaHd3T42XyB3UBn@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiaHd3T42XyB3UBn@lucifer>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4E6C71C0007
X-Stat-Signature: 73oouy3ieejr1n677grjw3m1xrqsn8bo
X-Rspam-User: 
X-HE-Tag: 1780923134-808680
X-HE-Meta: U2FsdGVkX19qjL5h6C3YVmP3lDHkwd7JXr63mkn4DS2ZSBqmbxFBHkOlSV+4ox8RXaUaMp8YFbfE0g69CgVehlwLbemQVDYei7zYQwKCr4vjFq6moCCkVcqplj90uZ9lCpDfJuIoUJ54kvjBGbE3PI99xac+SZhUgBWZ2iHuAFVFGf0KCLUvFonzGpZt7cZe+hJ8SAYGiNk36NPxmd/L0ye65ZvCZl9CrfUykoq65k9eXtZ5h25pOTbnX5CIZHdpe4uR9G1Hrkx5OByKYtDa800Kh/dyZuawdLtSHCJLzmLjud6YPrb33nmdaI6LdA3kiWsAYZrlemRgQCrt/lb4SJmB4DipOuXwfyXceXE6Hz3AxCnjQylk+f4bIWjMcGhf6/dlbzmYbDeDNVnBP90zlMN55SqgRr5TuAV1uCa9mDn0LwO7rIWeWS0i/rOCwww0r99nktFy8QYaFvfxDD0y0ysWp9h3rkkKp+EoYR/OpdcMarBMXnDJYXtcSALUbqjTLttCAAeP50HW9rAaahqjL8TeAYfRygMIDlaJcPrJ+Jl7ps6QKOCMTTbcW0If+5F97fmgYWVh1t9OYIkT4riENNGIsU6171Ja4ORN8GDJWLjGDlql8AuZX1Sqc4BsxV0Btbcvyjclq87HXQcnBCJVf393zKQqqAVEak03ep6Edrc+xTKUwPRn756yVlrXcI2+fT9tiDAEN0QCvMi9pb2kZHqOR6EcEnQlitjxP0riaAWXGWP24N8DhorwmiqtKy6WG3gj2YM/AeSHyebYIWXDwg8kqGST+G6DEY3MVR2FTDNufLCrrOInTBL/4J22vU0kPHf4lrBCY3K00r5BhXTH1U6Dxg4kmnrpgorWt7skzf4HKsWM9uaVi4yFFkaFh4DgnYGk52RgR8FiZnGTm/9uWVXM5BehM1INvk9wsnPqKKdnytNeu+QYsWBMM6j+M4RhiirWau7bxgIItXpgdGG
 Tw5/uQr7
 ySd5IyXEeP4DA9Bh3Jdsx1JRs1ngQTL8jOYRfdmd9VCMqjRV0VDu0sAZgM8OrLmsl6Kp0aiumV9nV3RCgltAv04pvdz113RLQ1UC+rWD6/+OhicZM/mxAfbQvq0seE6MnlqPpfvYZhbQG7I2HUMS6fM42ocfnttkYwjZY07kdXc+U3U0+L4x5NG9hkBoC/ncp+J21ZwU1l85XJ19WcDmu5l6nR0yb4VKGgepqj23mYivYXJlBYlhzEUTz9TUga7K3/4n22yTCOb/nyUsCDyZ+IC7Qp2uXoiSVpX2da+UGxG3L8DM5OHlhoAcv8BNbG3UGtNXjWXkwZhhEMNDmaI2UBReatBG3CAUfCPrx2y6VvvLDzNIfiXmVfDu+uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 10:17:47AM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 04:33:46AM -0400, Michael S. Tsirkin wrote:
> > Further, on architectures with aliasing caches, upstream with init_on_alloc
> > double-zeros user pages: once via kernel_init_pages() in
> > post_alloc_hook, and again via clear_user_highpage() at the
> > callsite (because user_alloc_needs_zeroing() returns true).
> > This series eliminates that double-zeroing by moving the zeroing
> > into the post_alloc_hook + propagating the "host
> > already zeroed this page" information through the buddy allocator.
> >
> > For page reporting, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED (bit 6)
> > is used. For the inflate/deflate path,
> > VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE (bit 7) is used.
> >
> > Virtio spec: https://lore.kernel.org/all/cover.1778140241.git.mst@redhat.com
> >
> > Based on v7.1-rc6.  When applying on mm-unstable, two conflicts
> > are expected:
> > - kernel_init_pages() was renamed to clear_highpages_kasan_tagged()
> >   in mm-unstable.  Use clear_highpages_kasan_tagged() in the
> >   post_alloc_hook else branch.
> > - FPI_PREPARED uses BIT(3) in mm-unstable.  Bump FPI_ZEROED to
> >   BIT(4).
> > Build-tested on mm-unstable at e9dd96806dbc:
> > https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git zero-mm-unstable
> >
> > Patches 1-5: fixes/cleanups, dependencies of the zeroing patches.
> > Patches 6-9: thread user_addr through page allocator, contig API,
> >   and gigantic hugetlb allocation.
> > Patches 10-16: folio_zero_user in post_alloc_hook, vma_alloc_zeroed
> >   conversion, raw fault address threading.
> > Patches 17-24: PG_zeroed flag, aliasing guard, buddy merge/split
> >   tracking, FPI_ZEROED optimization, folio_put_zeroed.
> > Patches 25-27: __GFP_ZERO callsite conversions (alloc_anon_folio,
> >   vma_alloc_anon_folio_pmd) with memcg charge failure mitigation.
> > Patches 28-29: hugetlb __GFP_ZERO + HPG_zeroed.
> > Patches 30-35: page reporting zeroing (DEVICE_INIT_REPORTED),
> >   disable indirect descriptors.
> > Patches 36-37: inflate/deflate zeroing (DEVICE_INIT_ON_INFLATE).
>
> This seems far too much for one series.
>
> YOu're doing a bunch of mm stuff that seems relatively independent, then
> putting the virtio stuff on top.
>
> I think this should be broken out into separate series laying foundations
> rather than doing it all in one go, which is also difficult for review
> purposes.
>
> Adding a new folio flag is contentious also for instance, we maybe want to
> go bit-by-bit and ensure that each foundational element is acceptable
> before doing the next bit rather than having it as part of a big series.
>
> Looking through the changelog only adds to this feeling! Huge numbers of
> changes, even relatively recently and I'm not sure all relevant maintainers
> in mm have had a look through either.
>
> Thanks, Lorenzo

Additionally, it seems you've missed/ignored (I hope not) a bunch of
pre-existing feedback, so it'd be helpful if you'd carefully go through
what people have previously asked!

Keeping track of that, especially on a big series, is a lot of work.

Thanks, Lorenzo

