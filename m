Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C7AC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700236B0099; Tue, 15 Sep 2026 08:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D85B6B009E; Tue, 15 Sep 2026 08:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7926B00A0; Tue, 15 Sep 2026 08:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6BC6B0099
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:12:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF848403F2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:12:58 +0000 (UTC)
X-FDA: 85215885636.11.725C350
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2336BC0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:12:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dMecOfkG;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TyC2gpsaXN4JBLWKNmm7J702tnSFqXToNgpiVHAQLkg=;
	b=3GfwM4Q1glBg9iOnA46yEi+tf/wmN2NzDxo//Wv8w6lE7U4bwWXxgeC3LG01fOzY353pZ1
	FeW3MpJdF314sqAQ+lylaRC0ceJj60wwLAe3WWc1pp44kOM1m/L0VyLeI7DVMIa4vsK8bB
	hnBSgkUafcH9N/z65oOAaoE1u4buZtM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474377;
	b=3VqLneFPbxaCzGfs9lH21mitmaPMojZRAf7C9H6GKMuZFE0HMiyrYkoD9lwbvkC8TxVZgs
	TNpsUWGC4RWbq8hG0/jiVbxahOfPEaFKTYuhjbwRgFbfdqJqVSVeKuZ+Ft1+ibdNQ1903g
	PBXpiNyaVaP/s6+dXATk8lps9eYUipc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dMecOfkG;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 91133600D1;
	Tue, 15 Sep 2026 12:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8041F000FF;
	Tue, 15 Sep 2026 12:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474376;
	bh=TyC2gpsaXN4JBLWKNmm7J702tnSFqXToNgpiVHAQLkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dMecOfkGD9IVBc5A1wOJ7RaGIcLenu0fPPaNj6ULgetn0QKiid3SmCobziHh5dth/
	 nsDFEIkSHNG8yfPhdRtOGhuiglEEp7ZCUa/9k5QBoF5PdykrhfAZSEXZHUgx1U1BVK
	 xGkTFAq/PNyGxR26wFeby3W2dyLnU3iQBk2jD4P50ZyW+dlHVBfMUvzMpwJaiHHOfs
	 K2RpX/7yFozlGNknDOJ672FQSl3wdlWEAAzJJOS7dXtYw4h5/AJzF587NEwZ4BMyPj
	 9pfv4RMOw/V3LIbDZ0K3TuOXdj2r4FW+lleHFXb0J74YtGlz0qeP1Rx8Bjz9BMVApD
	 0vMrkjCKJ1HWA==
Date: Tue, 15 Sep 2026 13:12:54 +0100
From: Harry Yoo <harry@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>, kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqkyT0Ui9h5KWuzn@thinkstation>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <2c9a7bef-3189-4f78-a6cb-61d2f7afd643@app.fastmail.com>
 <aqKhgPKzRf0e22s3@gmail.com>
 <aqkIdVhoG2wwVBtb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqkIdVhoG2wwVBtb@gmail.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3811q7unnw8jemei4urogagntbqe9iz7
X-Rspamd-Queue-Id: 2336BC0006
X-HE-Tag: 1789474376-546068
X-HE-Meta: U2FsdGVkX18V/KpQ6/IvBrJ6ilhWqaYtlKlv/K4tNRWzpEhjSbNOeJRG9B3peDJOyr8pGifm2OAmosFv7EtG5fXR4WbmQWS2dyjPbMGGVyoQ7cCGcFrLKaawsEnIh+tvB6dtcLxkZ7/tqMgD44kqNNbrbg7yrjYuYAb0g2K6hEJDhav1SYQacoAjYP5PDmrypxspouS/vd0sE/OSWjw+tU2aGmbs0Npz3jgFJspSC67VfeyRz1nWtcQCgrZB8BQnQFPPy/IaDcDuvYOWIvTuLAjm6xQ0NM0TIQ9r0wXRw+e0WCP/lAVijamRLYdCy9yTqBfu3w9SxB8AtzBmQb7Rjoeh+4LXSM7dvPBjFbK5jLS0FxJnCoYuCT/ZNKT/VK3hT2rHxwW4Kw7Hbd8KeWcqNfsNwmNI2Cb1ZceTMsgcfzlveU9ebZK04aAqGuSfmzJAb1/1/AMr8/QHFVrRijWN/BQpbSp3lOP3xIife3N+QbQVWP8RzqU02UqPbaUazNocsrDHo8hF/UD2PQVShMuwwuqsZ9rk90RNKeIZ9KxiPKXfUgEiWSCCPrdvNOzWa6R7EiPiKTgVI2tzz/UFJbkJHbT0Aq4jwE9CgL29xSVvJTrorKw7aYX8ZiVyhVNHByfBSy/svo3tVyW6URFSmLM/Uq2TZ2/6ltodEPbBqanKCAJrGGBe9xWbzR+/XHW29CruH6vrjMKBhSC/5XK9Jo9bq82mI5QYytaT2VrbJMTt4j1TMaQ/E07CeTi+/uVkxWuIEkQwyJM6T+oZOz66BBQA1gExQ1fV4VjjOYCoMjaW+9O4zswlqbF8VsWQ5FYj92/0Mlnp35buYEQ5VwVVnTPWUaL81j+uMPvl0PEt9xv4joGiGyq5BuLM4EuN9hqfza5fZo+6gheYCMtkwT1g0H71r1E1IUkNz55r0wMt71TJg5hZUBtCSfpguMq8pspRI3YAMK/dKLoN+gFrh7IcpIC
 kATzp7PN
 AkTDrz7g4kcxMGHkGPLwcBX3Cs2EQG/i58hgEhzcLdY8lBijGCwuSUs1ay8mkcJhUnDw7YgMBBQlLui6ycnxdWMNztQpNbFOAOWGb5CFaMGVGId1mAvCMGoLqLe2+zAMvbnuCF11TB4ZYXyhBKKAt3IwUgbUYoMj6tSAMJAZXEpGiyM8iAs8MByYag4Q4UMJ6oolX5fkuTQJdO9hQ2LT8WikHNtreuEiflP3UeQWnJCrDTkvkeFaOAHWZmDPl8BfAo3neNd2V2XrZvbHxzGhTrVtAo7x9RfFs+E/6ptsCS5GZsudbbyP26lkUVg+NsCHDY/q3Eym56FgEjzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 02:03:48AM -0700, Breno Leitao wrote:
> On Thu, Sep 10, 2026 at 06:11:53AM -0700, Breno Leitao wrote:
> > So I'd say we have two options:
> >
> > 1) Keep it similar to unaccepted memory, with 2M granularity.
> >    - Pro : Similar mental model as unnacepted memory
> >    - Cons: 2 MB might be a bit wasteful
> >
> > 2) Move to a linked list like the RFC, keeping it outside of the EFI
> >    table.
> >    - Pro: Reduce the memory granularities to page instead of 2M blocs.
> >    - Cons: Another way of passing memory information between kexec
> >      kernels.
> >
> > Any any other option or strong preference?
> 
> Since nobody voiced a strong preference, I will stick with option (1),
> the bitmap, for these reasons:

Not sure if this was discussed already, but perhaps we need to have
a chain of struct linux_efi_poisoned_memory rather than a single
bitmap, to easily add support for hot-added memory later?

Also, I wonder if some architectures have a scattered set of pfn
ranges so that the span from the start pfn to the end pfn being much
larger than the actual physical memory size.

If so it might make more sense to have a bitmap for each pfn range.

-- 
Cheers,
Harry / Hyeonggon

> 1) It follows the same mental model as unaccepted memory, which people
>    are already familiar with.
> 
> 2) It is simpler to query at boot time, especially as the number of
>    poisoned memory regions grows. Walking a bitmap is easier than
>    walking a linked list when freeing memory back to the buddy
>    allocator.

