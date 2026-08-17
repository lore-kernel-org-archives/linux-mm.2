Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA67C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 10:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35D36B00B0; Mon, 17 Aug 2026 06:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6E76B00B1; Mon, 17 Aug 2026 06:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC506B00B2; Mon, 17 Aug 2026 06:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B424D6B00B0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:22:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B577A0744
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:22:26 +0000 (UTC)
X-FDA: 85110371892.06.65CEF2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 49367140005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:22:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PKeQfikO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786962144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=spCbx979Q0ZWCyzTQhonengjn1lj8BphNbQgPB8fbNI=;
	b=X2PKCjDgdPOzjAd5HiBU83MPfFTUdX+88WqxtUAu5sK8aVI72m+Te97crzEjHS/OIVCqzj
	ys4hn67QCGXO/7PfGuXRLZiyX4vWDqWFJePM3IrknQiZF3G/tY9bwaCnFo9hes0+4ZIVXe
	OAl8uOapvGIDQjWTH+FunbtJFqKoS/Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PKeQfikO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786962144;
	b=Xy3UXkk9SfK6W9pkbo7bP/9wZimkZWo2OKbr2dCi53bR44YYhIhX0GXnyONrjuJTV0OC+j
	tAy9rQufvUii6OM/tVLGCTadz0L+DqOLDviHs+MbaNsoJQ4gFztOVE38O9aGYu7Fxplusy
	PkRsnE+0LQZsoEYeRvsasxvEVry7qNM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79E974028B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5AC1F00A3E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786962143;
	bh=spCbx979Q0ZWCyzTQhonengjn1lj8BphNbQgPB8fbNI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PKeQfikOBCqlF/2o99iDGPQeWC+fzPewpGMGY8ZzHW1Hn4IDzQ/EbH66/5N1thPjL
	 Kqck7jCc3OXgHB1YzhCkTpvZJsmL4fOfuNJN4VHukNo3ChRLmvbTv7kEuQI/LXrNEm
	 3PNUwCgtgiYamBA6ACa/SCir8TTlQI7FokdHMjbwMWH7/ldFXgIK5DoigBatQ1YOs9
	 sZuBwfiAIHWd/SV8i/Tc6fnN8IAL2nbPJMlygchIIQ9AxrnFbC3Z+3H7XetVCeXed2
	 HqNMIgA3EVAeXg8Z2WWDKxhGPxsC1DznAHxEr3N8ze/5LS+rkhWr6/lRyvEeS2bf4C
	 XM5lljvU8vmhw==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92edb12cdf2so256705885a.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:22:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro5jILoUsEIZiJcp+rr1pkSi8dYvnA4dtZ06F7FWpHixt7l/Frd5hYj7Sm/V7SVAXJyYyXDUc/ijg==@kvack.org
X-Gm-Message-State: AOJu0YyQZn6FARSYWZJ4+hu19emHV6aXb5E6/DLS+MMQfz4GfCb3476T
	LEVE/HGLvNu4yPqNKHEHu2sD6TKJCOTkm7M1h9X++LrjrlgpN8wf4LDSL8/pMkRAW5BO6nre9EY
	RE32DlbpB8nfdnes0+F/M7ADT5iesDqA=
X-Received: by 2002:a05:620a:a1d4:b0:936:9db3:b82 with SMTP id
 af79cd13be357-936d22e9eafmr2242167085a.31.1786962142762; Mon, 17 Aug 2026
 03:22:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260813-swap-v2-0-4a625ccabdae@debian.org> <20260813-swap-v2-2-4a625ccabdae@debian.org>
In-Reply-To: <20260813-swap-v2-2-4a625ccabdae@debian.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 17 Aug 2026 18:22:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x30dhvWfDH9eqkoOMAtgzLYMBLB+Rt1gEg9Gcg==kufw@mail.gmail.com>
X-Gm-Features: AcwNN1VIYnePxdviKhAdvocDoJXABGd815PNIxhm69gmGeqoL-kCcmJIV56zSQk
Message-ID: <CAGsJ_4x30dhvWfDH9eqkoOMAtgzLYMBLB+Rt1gEg9Gcg==kufw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm, swap: distinguish a malformed swap entry from
 a dying device
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sz85nf1p63snenqt38qpekmjbh4xhx5u
X-Rspamd-Queue-Id: 49367140005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786962144-542853
X-HE-Meta: U2FsdGVkX1+K6/VaEG3+i7CA3HJPc+k52izKxL9N2L1zg735+PzK92sozQQaMIvxD604NIii9FdZt2KE6x6/+Pvcqs6kNUCu+pqEILPjZARkJ7kRjWKwPaEbXxJv6V7qQPI7MRBAfVOy4TG21hmiCx9Iejur5RALeDcjhmqYBnFbD0bqX97I5I6uaHgkRkpjMqBZ2fOwk3mGY0EswIkjy9+viM/vJFV4jMheFo/BhPQeJEIoRc7EBiliEuKD+JUwHm7bNfFnGHDjYdxXzYWgKinPEO53YNShA7XcZo87kIWh7YAxnY/XEN+nRhPjKeM6RlPaCiVSXGtAKCHytCOB0Uv2x26lMHVzg4122rwsbSibawTexnIvGbmKdTXC8xxe0Ugua2uQo3GvOaSLPZlz2DNinf9ji/TLA+vBVxJYuEjIYmGf2uPLYJpPfwGmq3W7gEu4DbG5xEFcCkASR2wqsOlxRkKdhsDJyoU8DL78M2lZoGYbC96QykKJwc5BoFtbjHMnpL4SSGu3htAo6UQCJppdex06XHQjA+hQjccXVB4cfIIIH+nWz6Cp2sxBox1PwYyHlMthzKJ0tL4y2Fp8gP9KRT0GpDC/WcRPryJjoZF+SdPj+Jcv8lQxjY1HjoD/+M2ma3GgHYog3nNtuOhm2K0dGhabEwYBu21S4njUUp+cUDRib/WKyN3Neou68F/PhT8/ci+KlS5RNDybg6cXhsDmXYuDkPVmNV6l00W6r7FHBNLx3NbaLm9PFz+gsVjwpKo11diId4feXi0S1PMavkz4MZSv0sgvyvd1LaIqFXkgO8e3fmBDikBWsnPD3SUwtzRTMNfE9Q9BOHCnurr/oMlBKjyBDM0TtmAarkcFQJtDVsuOw4Q38qu8N/p4sYSILVhD+juwLHii9kfSQpXTwNS/dpwV9Lz2eY0I7kgTcYLOwn140ZMzZqE3HfcKH/T7MhPOuqF7MLtxCDbivzB
 PpRHM90T
 +kihG7+4Q0k8dhgkJ1BM891rCDGUIGX8KqAlbHDD9gNr/yz1a14CkUHNSy/Kbh7nafE5sVUHXuF0h78OtKAJSJ+vaZloB4XcZwItQr4VgJxyAM8CPqTZMLJzk7Ul35lES9wC+XhonC5JGhn2yuu2Q5sQitvIQVujr0cVJ1k6MeKc9XKRrnSm7ceSy8q/En87Gg6wHYlbaTgxQ5Xuqpxptu6cjDG9mkJcnpdIEc84t59rEcRIYWg0p7Ap7T9frKtDzene6c5kpiIQUh8rkYNhMo4/NL/glXZ8upk9XzsIp0bNqNDon7e8LEVvXDa4kPLT+fYaFK9jy8OXrH5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 6:02=E2=80=AFPM Breno Leitao <leitao@debian.org> wr=
ote:
>
> get_swap_device() returns NULL for two different things: an entry whose
> type names no swap device or whose offset is past the end of one, and a
> device that swapoff is taking away. The first never becomes valid, the
> second does, and callers cannot tell them apart.
>
> Return ERR_PTR(-EIO) for the two malformed cases and keep NULL for
> swapoff. copy_nonpresent_pte() already reports -EIO for the same
> corruption on the fork path.
>
> Callers bail out on failure either way, so switch them to
> IS_ERR_OR_NULL() and clear si where the cleanup path would otherwise
> put an ERR_PTR. No functional change.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

My gut feeling is that a corrupted PTE entry could also result in
type > 0 && type < MAX_SWAPFILES and offset < si->max.
However, that would likely lead to other serious problems later.

For this patch, I think it is reasonable to report the two obvious
corrupted PTE entries as -EIO.

Reviewed-by: Barry Song <baohua@kernel.org>

