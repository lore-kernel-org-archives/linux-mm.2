Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0FB0CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 15:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A3C280031; Fri, 22 Aug 2025 11:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0409D8E009D; Fri, 22 Aug 2025 11:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF18280031; Fri, 22 Aug 2025 11:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DB31F8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:14:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9057316023F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:14:00 +0000 (UTC)
X-FDA: 83804738640.03.8D5280F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E208AA0013
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:13:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oq+YiBtz;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755875639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L7qMagALD0IoFhMlbtYj3vAqhjRthxO08VDRkg86DzE=;
	b=8GUoud3vhU6ketcL6XpqfIGdUhVRIVElXnjo2cmgdmk/2er2fwcuHyb4ZR1v8duEWAAyJ7
	HyoWR05zaCXY12X952Ktl17zMdmvtZRZPku6xK47b9GzHhPgbB6kZ3phin9GMP7Dvvbo9g
	mNg9J/Hi52aC84gmtOyyHSYhsRZ/ieI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oq+YiBtz;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755875639; a=rsa-sha256;
	cv=none;
	b=p7e7alkl0hrOigWI5pAngz3qPIvsYm2j/fD0EUV4q2Ko+s3a3A/FIbgpu1rX0n/XtJrqUq
	2QZj4iVxjTHxNO6cyrgqe8eg5vaoyjQw84ShKCBsUV+2x1KTf4Lv4B8D0Q3mJWwuE5NaVX
	Rnuzmw17EHbK59INn4tLfRzp/f3Jq3c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DBD4344F53;
	Fri, 22 Aug 2025 15:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A19C4CEED;
	Fri, 22 Aug 2025 15:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755875637;
	bh=p0iPLyXnfNJdu+YoCuoUVSR7eRuOWUAmkwSHtZmbswo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Oq+YiBtzNwt4g95Bu7PV0Fl9ib86q+ONSg37ZzPXpeT67l668lZdZKcDZ17zCgq/+
	 NUr9Cggu/NQsNbAf8J5LWQZhrBwU1g/MF3aj/PVZNB0J8PVxbWJVmp+W/+1x83AUZi
	 Ksafl3fKhK5d4QzvSbcncq8HLEoFlkjFsSlSh1hzeqF0bChtCL26UZCq78qNfMb29E
	 EBeBkg4phSCnNI6fLlpTsGgIlXQA3OAyRkh7ArJn5n6ii54fXevJBkxPUnY9AstAPY
	 LmiLofHFtmfQUlmw4ITl2sEhNM7ay49imRJJkphBZ9EWVC8vpCEY5+m+WLFICOjhFU
	 VsNUYbhaEIPrw==
Date: Fri, 22 Aug 2025 18:13:39 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Shuah Khan <shuah@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 05/35] wireguard: selftests: remove
 CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Message-ID: <aKiJI0jiFEjtLE3l@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-6-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-6-david@redhat.com>
X-Rspamd-Queue-Id: E208AA0013
X-Rspam-User: 
X-Stat-Signature: yp4d9ua9rbfcqiw64ckf6f7acjoisi5u
X-Rspamd-Server: rspam09
X-HE-Tag: 1755875638-940934
X-HE-Meta: U2FsdGVkX19NH8OQ1ZBGYyT6LRg1HsPZAsflts9N11z1z7o9WSPdM17pEyLl/iG6gWGs01T0A1AfVMvbqx2zm+AXFCT/pU+YhnMyxAavoCpYx9UmjBb25CpHJ43jeM6oFzbYHOg6X416rcArldQaGrODuotFah1LVwXD4m9ZJr2M79op0U8U5AWJHGcGIEE0HLGB4hUWo+wHhQw3pqTQMVxtJRnkMuH++miibPEzYLoN6SmmZUhBI4d3N1E0i8xI/QzDRTLA0QykJitw0PwnTYfFeSXQg0eOv8PlXgNAz5ReRI0A5+FW53NcdMkVa46+5G5arXwQ+UR+wqs/XCtbeYn0SIbA1lNoBSZ996UKG4RTQITB6RpaH+PVgodUhhtIjPl+ungmFaq95stXysPfsO+On0xM+MyGqiVz2AwvhjbrMzhDXOyM/CDy/UprcyaaxLmP/t4unlIi5CHgSN4DOnnNh/2ZaurxwT5Ug9v5Zd6oVXicb9TrFt6RxSe2K0JZYIo4BfKjejq9/rCSH8TIslPPLC1XA9/KBV/3NiBm1eePmUD4F+7sMXGr4rj3w+rURWSq7SYFSibbUb0CkRpwPmxmRSPAL/+W/gvahtNjwDB8IeJP1wP4G7UEOZQxfWMDiSTa+S0tE+BaV6IALU3N0FraF1Ao80f9ymAqaVxdL8P6Td1OjF9H6OMfzCbprohQ5Kft1+GCAIQ/Gk7VldG6zQH/zenQ5rlK9bl/sQ9I4WcQa1pH6fTvz9mlUdOVK/wp+axRpEHEcEN1sbcxI7QS8rgx5P3rerEVtTViWq2zD+Uqdk+5fauD6wkm0EnWnO32+IMmPR3cEzevsNiq/nbSV6t5J15tWxafcdHQrcjepRSF/aNykknw0i5JYOB3Fw9NeZhbiLVKvAGRBQ/zars6CMVvVx8OnOWf0Q6EDyRWoeAfVRCx/wrOO2ZGIj0njOXsjSH6xHWbWNMz/Ro+9Wj
 Q0lZDQPZ
 6qGr//RhX2bH+sgDKPrw3pXCcXRyMf6AsUSpYWhFes0U9+wpXOtwhrgGhWgHUz5cayV4IEuQJUHJgdi5mlV/743K6YCw8JYKAHp38uTC1XivGxryUENpJZYaiHulKQMb8sUD1kj83UegzEd4cRKRihWo0Tedhi6yNKzunxBdbmSK7LqEoDN7T3lVLNirTFgOlM2JztvgfC6F2RAuWkMLtkJoeO97HA3F9PUdvFYiuTMgJIhmMkJo7bf90svVc5fLVUF1HmYV2lEc+5WISoNJMJxMOH0C2phRi33X9bLaW24xhdqajU5jfEAlmMSicJp75/Z2Fz27KDdZX72TBR8mZWIJZZtj5g3Ni3GVJN6cL+vFPu6EkDCKEOjVED2rYaAtZVZAVCnJGCWLS+nf74eN6b01hwgsM2uv4+YwF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:06:31PM +0200, David Hildenbrand wrote:
> It's no longer user-selectable (and the default was already "y"), so
> let's just drop it.

and it should not matter for wireguard selftest anyway
> 
> Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
> index 0a5381717e9f4..1149289f4b30f 100644
> --- a/tools/testing/selftests/wireguard/qemu/kernel.config
> +++ b/tools/testing/selftests/wireguard/qemu/kernel.config
> @@ -48,7 +48,6 @@ CONFIG_JUMP_LABEL=y
>  CONFIG_FUTEX=y
>  CONFIG_SHMEM=y
>  CONFIG_SLUB=y
> -CONFIG_SPARSEMEM_VMEMMAP=y
>  CONFIG_SMP=y
>  CONFIG_SCHED_SMT=y
>  CONFIG_SCHED_MC=y
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

