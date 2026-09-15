Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3938AC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3466B0088; Tue, 15 Sep 2026 08:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5CB36B008C; Tue, 15 Sep 2026 08:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72EA6B0098; Tue, 15 Sep 2026 08:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B63246B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:40:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B99C1A03D5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:40:33 +0000 (UTC)
X-FDA: 85215955146.22.99F7F0B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9D9E9C0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:40:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=huBfHert;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789476031;
	b=NAU8lSWyL+Kou3EKq1FpnbcVODalS5KSc7nYEEz6lwvT6JUCOVjJMxbZFhJfBGVvPHDORT
	2lJJM8+Mp7tNszW8g43DfdecGlJHdhCpZaZus06c/dTYLqpsATAV+EYENtm22smxwpEvhP
	WvRj5cIZY6SkIttVVeMrTbZVVs82faM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=huBfHert;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789476031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pqqx6qyZK7hDaGMfpM7ctme4msTknL0M/1U1XtnHr1M=;
	b=LHtYeY5bnck7uyRZw4mTYS2iXC3MGDjtzUWLDNis88H5z2lKDl7wNgn9zpIPY8cYg6wEFB
	KxB34Srk2n130MIpnYBiB5BS3Vnfs42JY8zQUylDTKZme1IAnHJUCPDF4lokuZxcQ58vLO
	Jw7dQDnj/GmexSEmja74R96ZCmB4QZc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=Pqqx6qyZK7hDaGMfpM7ctme4msTknL0M/1U1XtnHr1M=; b=huBfHert8ebhJsOV5HNhXjIL6i
	5hoDBf8pBN819FnWMjS07l+DapxPI5DgQs5AX8qKYVKDdOhXqpOC2FMR9E4k1ERdGl9gLRYa6uS7L
	29ZMZlV8O/OgrMSMPHHLn//ZifgJXlrn097+s/IzxtyrQ/x+0cTTCUE+CBjBIlTxVONVha3ghSzyU
	WbWX347JicsNYVyxS7O5iHBc5fdrfrnAA5+tFHy+mlF8v8LVSeJkNUDmq0F40jC7sd6Hp6tqBv7dB
	v/o0rxqmBw4kUMlPPOg5fHOhqQBLMlVAvYlYUIRvN2RhVwgBX90/49Nyn7l9HOVPICSYQFAbnlWwJ
	7dSC0UUg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6SS0-004Oba-0j;
	Tue, 15 Sep 2026 12:39:52 +0000
Date: Tue, 15 Sep 2026 05:39:44 -0700
From: Breno Leitao <leitao@debian.org>
To: Harry Yoo <harry@kernel.org>
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
Message-ID: <aqk4NUnq92ftuUuJ@gmail.com>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <2c9a7bef-3189-4f78-a6cb-61d2f7afd643@app.fastmail.com>
 <aqKhgPKzRf0e22s3@gmail.com>
 <aqkIdVhoG2wwVBtb@gmail.com>
 <aqkyT0Ui9h5KWuzn@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqkyT0Ui9h5KWuzn@thinkstation>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D9E9C0005
X-Stat-Signature: frngsju54ihwqsrgf4ifmzr79x85se8w
X-HE-Tag: 1789476031-292717
X-HE-Meta: U2FsdGVkX180BFzG4mzTyZBSAcgQtTuQF4ZK+1MVjeoJ1+YWJGjMxCvlOK3qwK6yVCmAbTWJw+PRvzlchwWY1zTs++AfxbNkQ+owi5tHXPgFnqZe7I9q6alxwp//Q6Tk1psLeNgNv289xhpGFXQvV3tA9YNcd/56wwNWBtrDfl4axw3VC9VZ6uAWlaf0+1z6jNaf1iXEmh5B4HfT8CN7VZCiIxE1E6iFzmKxSo7TlgS8aqy78lqiBxuiDtb03AzwQqZ/9SHSSbSu/tapNSZvEtMA4IEuF5icU+faZnlHTwdU3RN2S7tO/VuhBh4WjseOaUgxE6USbjUWmdjWRR3lc7/5DEF/3GM5rDCCoaTvThOKMqq2xJH/TH5FI4B+VZ1nLz+usTQpwiSWUzDsMcPai5iKtVts4/PzglFq6EUdN6nWJ5+HZU4c1rg2HRJF2Ev1177LYqE3XLkpeFqf0QPBm5/sxLF+9xVrmgqSVgX+/kUGLOdBpYcsFNeaG2IJ/gCp8SgljX4K0ZJ+eyWyXfmYVy/cfb7zwrHMVsvLue0gQXZ2vQDL7P0WEzJ1y1N1srYj0scbbXaKDkQX8+JN7Jl2JcbxplMMw9cq/7hq+QEo7QdGtgq87jCDnNZ+MNBnpasnOOPO/FmxgArS8y7FlI4dwfrMd+X9NWVqB6ueorl5MPWi9vnOGtK+wBPjZJXOCrBFApKPBWbe9cWL3cNZLERI5O7T2UBVg5qirvuj5YV4FhFYEK7WnYLBh0r07a69Hn7vbKRQfGA9I5DpE8oqKxHQ9xxd3QQiaUM4cO7ftDyZ5jDUtMHj9xi15Z6o03b8tC2LiQkvgdAMX+feV1WkJkTC6Wk4bK0c4RcL/LzOaoJyDNeoRxG/WGHwSXC6URY6+vB+ucWKQsc0P9rb7tRuZqCX35jIwG/BrSY7/6u2EnOL7B8xmab/7edjPExvuxfJ6dRmZWuDQ1wJvH0tWVr7+rA
 /h8dIcY0
 o0zN52R7wvmRMj47Mh9xuVLT/7NJr5gMuN6MbJmKWkUBe4y4NtYxrtZKFX4SahWvBjfSp4rouugIXqGRGbbR1e4mTWQ8lAlCYrjTzZ91aSkMoFME+FaHR6yP4XhEwE4KN+8z9YJYjs8rBsd1SORnRqb3K6gYzVguNj4qwN6T09wOcpAyjB5wdVYUmcaotSparjgEd8BUjTFilo7IadTybCGySAnZ8/TUp8CzH4l8Si2F2McNhMWdaufi+itjSNdf5WsiNR3aZIzpvGAZhW4VPM6RtL3XsArixENAyYRWSP5Auwog5HWtv94wEhjDJgqa2BIgOYaVzOnKOyp3O7ehkbex6taHjfwoYkrrH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

Thanks a lot for the feedback.

On Tue, Sep 15, 2026 at 01:12:54PM +0100, Harry Yoo wrote:
> On Tue, Sep 15, 2026 at 02:03:48AM -0700, Breno Leitao wrote:
> > On Thu, Sep 10, 2026 at 06:11:53AM -0700, Breno Leitao wrote:
> > > So I'd say we have two options:
> > >
> > > 1) Keep it similar to unaccepted memory, with 2M granularity.
> > >    - Pro : Similar mental model as unnacepted memory
> > >    - Cons: 2 MB might be a bit wasteful
> > >
> > > 2) Move to a linked list like the RFC, keeping it outside of the EFI
> > >    table.
> > >    - Pro: Reduce the memory granularities to page instead of 2M blocs.
> > >    - Cons: Another way of passing memory information between kexec
> > >      kernels.
> > >
> > > Any any other option or strong preference?
> >
> > Since nobody voiced a strong preference, I will stick with option (1),
> > the bitmap, for these reasons:
>
> Not sure if this was discussed already, but perhaps we need to have
> a chain of struct linux_efi_poisoned_memory rather than a single
> bitmap, to easily add support for hot-added memory later?

Agreed, that's a good point. We could extend linux_efi_poisoned_memory
with a ->next pointer, so that if we ever add hot-plug support later, we
can link in another linux_efi_poisoned_memory. 

That said, I'm not sure hot-plug memory is really relevant here. Hot-plug
is mostly used in VMs, while this feature is more host-side, so it doesn't
seem like a great fit. Maybe it would only matter for servers where
physical memory can be added while running (do those still exist? I
recall IBM offered that feature at some point, but I'm not sure there are
real customers for it).

> Also, I wonder if some architectures have a scattered set of pfn
> ranges so that the span from the start pfn to the end pfn being much
> larger than the actual physical memory size.
>
> If so it might make more sense to have a bitmap for each pfn range.

Agreed, having a ->next in linux_efi_poisoned_memory is a good idea that
we can lean on depending on whatever problem comes up down the road.

Very good point — let's keep this linux_efi_poisoned_memory chain idea in
mind for whenever we need to expand it.

