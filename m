Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C11606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 07:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OSPCAGvB
Received: by kanga.kvack.org (Postfix)
	id 3E6DF6B0923; Wed, 25 Nov 2026 02:38:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397A06B0925; Wed, 25 Nov 2026 02:38:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ADA56B0926; Wed, 25 Nov 2026 02:38:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3A036B0923
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:38:40 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7714840E2C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:38:40 +0000 (UTC)
X-FDA: 85472839200.01.5B27545
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 93A2D20005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:38:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OSPCAGvB;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795592318;
	b=P8VNHXpgb3X+1+l00bR9v5OSV8kSQkU22wo9HofT89q+GvegGMQeSuo7SDF5diXzvDK7IE
	zH3s3IO7aDaL0Txf/CZWBbNLlGDog/0Alddtl5PMmNVlpJoG13nYwg/FdCIfCSdLM3dhHc
	ewJLeEVpUX1ukbtfn3TYjp48Xv8Xhzo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795592318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGB+fOBKdYyUYIRe+oBpjk90yiPpoLkK9I3BKuiG5yA=;
	b=vB2kVFw6/ZStewqyzq7WNPI8wv//lnFtrwtw0P272r4A/amb92e6KnR8zxd22aplooV4sR
	g2ivm++gG2HL+FhGa4SGTNAGD7XBNVNojucvkCPrN2HaOVWsMErxkuyApivpfeAeDN11fZ
	EXs/+6dHLxCLYdX5iK/38LANox6I88c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OSPCAGvB;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D6DF60F97
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56B31F000E1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795592317;
	bh=RGB+fOBKdYyUYIRe+oBpjk90yiPpoLkK9I3BKuiG5yA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OSPCAGvBBPGdVwRymygPVtZlLky7yB4MBRcAfgZvdpmP8TnQttwwd2uEES2lbnSK4
	 KDkSWj+W9/RypsuypNPrqG7Gtrj+e2xebWj/gdrrLO4c8ausIuArnWvTp14CXnTe1J
	 Whr8byp4VzBVZWFHU0cvykhiJIcxc1DMlm04nhHKD4ajAQHTGd+DYwIf8F8zwHd9OZ
	 qzBJ8+SkWVXvLU6DPaJhOkezKgw8LHJZNLOr8CgHeOSG1EajNHGo3izVrNnHRCjogs
	 9Ls5SMtKEZrgR8C+w2nvtaXUIqCZp6n6EhXiJvEtMg+x0rkxUOZdLXPeAf01vt1/Ih
	 T4fo8VAWIxZ0g==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-949680e6d82so594281585a.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:38:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGzCFlwDiFUNTlb4dtB1QDsHBTVVgG7FMCiXWEnq35SAdyeriJi6UHfG1jatHr/504f3avgPqVHjA==@kvack.org
X-Gm-Message-State: APuU4Z9+tj9pPbLnUrhzp5rFphMhfE6I+9xE1wrdE6KRNezEUE4hPo6J
	p59WSRMI9fyyZvu36igdHT2RftDX71nQUsqFOVhElfmN2cl/muB7Wpp/DziBz7fDG7+7zZ/Nbjo
	o0tCpC0VpC8sS6bjBxlJswNrsvURGa90=
X-Received: by 2002:a05:620a:171f:b0:949:7f5c:6d9d with SMTP id
 af79cd13be357-949bab24d39mr2862714285a.75.1795592317040; Tue, 24 Nov 2026
 23:38:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261125-fix-mglru-kswapd-age-v2-1-4cc37437af9b@tencent.com>
In-Reply-To: <20261125-fix-mglru-kswapd-age-v2-1-4cc37437af9b@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 25 Nov 2026 15:38:25 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z-UdXQg0LYqymEZdoHALPmAZC7eGcXbGad6f0sdjmkcw@mail.gmail.com>
X-Gm-Features: Aa3M54ohWK453GGCwz5KqjeaTi0MuN11Z-VTtmlbSWu2DhjYRrMVio6g8TeMuFw
Message-ID: <CAGsJ_4z-UdXQg0LYqymEZdoHALPmAZC7eGcXbGad6f0sdjmkcw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: skip oom killing for order != 0 allocs in kswapd
To: bingfangguo@tencent.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Yu Zhao <yuzhao@google.com>, Bingfang Guo <bfguo@icloud.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hd7cgxcnmtbgm88epir49ne6777588it
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 93A2D20005
X-HE-Tag: 1795592318-381437
X-HE-Meta: U2FsdGVkX1+F28Ql/dwSbUvd7StRdAG048uWcphptSwoDuOkhmD9wotBQNW1fNsjMFxWvjyRz7iIOa1eJNtdLcTLIAIMaiKaG06chVwCORLOOWUoxlFxJvpoklnqeRRqNto77t14qVeoYOTE+AfRuFH6VP+3EU+4uZGpJGQrzQJPcrNkssSxwuJXOA7+YeKL3TlrbbD3N5ExKU9RQapviNPPwyUKUZW5SVf9dZXRRJlOKjxbE91PVCLbgcDcyKdcwEpeG1N4gGCx6kTmXEZ+VKhORPUA7DGHckgMvrGp91f42YGbg/Dgeu1UUqQGXSchuEXtySdHbUC/uEwBAR3m6xTLR0iKr/Twu7Szfz6g+snKOaV4ohi2fq6wVJOEO9Ht6KwgWYaRsxefmajq7GVmaQlbGfYHVgRvrJV1dBHmqfend07zFTEO2LahgWUXRGwAREdwGMib0tLCO4oug+4fHw80WPkJdXMUgYcQbhM9hwginouDYARDOo/DhWuEAKXB8laVLHCoPhYzC4E/rSVEjej4eismq7sG+qEJWRUPECCGIU8JX9kJ7u6UpEN4IIXtqWxhD2r/5rhaE2XkJNMSygkNX0iGf6V2iPbbHazbriDCjf0X3FnYgsHcg1O1Hf4K0iYE+b6eV4/cRMAJGQKuwcy9/sWNRfFeiB+T9qfg5GbTWFecJPDGxwtDPCCn74syCiKk0D42QHBlKeqHzOMVSuIDV50G8gCqLLxV77miDs5sEZBg3IiOPMb5EoRf1OTFSAHaxWAGttuv/KVGlAeL1a7V0A+GgyAcXtgxLYkWDf+s/RrXyhojp25OEcluUrdw+i9f+ecy+/eQ3GJnHoPe1DtQxecwL1rcmdlsFqdOQw1BIjrEv+JldsLLPtcpg8fHjuR34oyAo24oen2aox1bIpmH59CU3iGNTKsh1hOXhnua5M39sExEIYJ+CbWYg84cT1+f/3ZVH/sPH5VJTjG
 X6TQ8zsG
 hJJk0cq3E1DTtQjJbFjTMBpu8QtG28wvpZw0K/yFhY1mH2Ur4c2t5CwCv9pT+rJR/RQeWPFHBI8xJgPyNB7/PrrPXti++KR3QQqJsBS96FtBwrK0T5+iD5VPvr/NvXV7FCEFdOYTsFUbo7EEvBsU933fAwdtSe/LYNn/lWy4fhKe8P6olfdA8G85jXpqoWVExZxPyWixxJzv0KVImH/gupiRVa34UUWKVNE+mBqPZwmPxOiY8RzKgDrlrZfeCNDajWvCi5Mu9rIiz0pHL4X820oM4/zNKWXXJOFJMsQofOSJFDaLYTMv+A3qdVq4GBtUhmJ/bUziKRyCJxWrd+kA0i8hvVt+aUEg6jYbXXCbfEcKK4C+BLkDge7Hm0ctADe7hGqJwcgu7vKoVPJRgkOHEfKz6tELRpAzoC4p9LREdbl9JFIXOEe82zdLtsabOVtJN2rusW6PL+wjS2/o8LP2042DR74uzs4wi1MZXphXiBOTWjwg9JVJfERVhfVzJUf8Ao5yUGlle6+EhEOED2bMFQudHJBqD9r7nI3ZUfZWJsCrrkize9y7GyROUyUBOt8wjsJa0lYZIXcLrBZHQY79BVwclMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 12:32=E2=80=AFPM Bingfang Guo via B4 Relay
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>
> From: Bingfang Guo <bingfangguo@tencent.com>
>
> We observed that when MGLRU min_ttl is set and the system is highly
> fragmented, high order allocations (e.g. order =3D=3D 9) will fail and wa=
ke
> up kswapd. It can not make any progress, while pushing generations of
> memcgs so that they all end up younger than min_ttl_ms, repeatedly
> triggering the OOM killer in lru_gen_age_node(). Then the whole process
> repeats until all processes are killed and the kernel panics.

It seems we should address the underlying issue of why order-9 reclaim
keeps advancing memcg generations until all memcgs are younger than
min_ttl.

>
> The purpose of the min_ttl is to prevent thrashing when all memcgs are
> too young to reclaim instead of preventing fragmentation. So fix this by
> restoring the behavior in commit 30d77b7eef019 ("mm/mglru: fix
> ineffective protection calculation"), which skips OOM killer invocations
> in lru_gen_age_node() for sc->order !=3D 0.

I'm not really convinced this is the correct fix. It seems to work
around an issue with min_ttl for higher-order allocations, but it
doesn't appear to address the root cause.

And what about order-1 and order-2 allocations?

>
> Fixes: 30d77b7eef019 ("mm/mglru: fix ineffective protection calculation")
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
> =3D=3D=3D=3D Testing =3D=3D=3D=3D
>
> Tested on a VM with 6 cores and 6GiB of memory, HZ=3D1000, MGLRU enabled,
> min_ttl_ms set to 1000, and a workload that fragments the memory then
> allocates 2M pages.
>

So the real question is: if order-9 reclaim can't make progress, why
do we keep triggering memcg aging and end up over-reclaiming?

> Without the patch, kswapd kills all processes and panics the system even
> with plenty of memory available. With the patch, allocations fail but
> the system remains stable.

I know, I know. But this isn't really the root cause, is it?
Even if we avoid OOM kills, we may still end up with excessive reclaim
or system overheating, right?

>
> --
> Changes in v2:
> - Reword the comments to explain the purpose clearly. (Kairui)
> - Relax the skip condition to sc->order !=3D 0 for soundness. (sashiko)
> - Rebase to mm-unstable.
> - Cc stable.
> - Link to v1: https://lore.kernel.org/all/20261027-fix-mglru-kswapd-age-v=
1-1-b1ffdec4ae52@tencent.com/
> ---
>  mm/vmscan.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 836f50814ffa..9fadc6f9da49 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4351,7 +4351,7 @@ static void lru_gen_age_node(struct pglist_data *pg=
dat, struct scan_control *sc)
>  {
>         struct mem_cgroup *memcg;
>         unsigned long min_ttl =3D READ_ONCE(lru_gen_min_ttl);
> -       bool reclaimable =3D !min_ttl;
> +       bool reclaimable =3D !min_ttl || sc->order;
>
>         VM_WARN_ON_ONCE(!current_is_kswapd());
>
> @@ -4371,6 +4371,9 @@ static void lru_gen_age_node(struct pglist_data *pg=
dat, struct scan_control *sc)
>          * The main goal is to OOM kill if every generation from all memc=
gs is
>          * younger than min_ttl. However, another possibility is all memc=
gs are
>          * either too small or below min.
> +        *
> +        * OOM killing for fragmentation is not desired. So skip this whe=
n
> +        * sc->order !=3D 0.
>          */
>         if (!reclaimable && mutex_trylock(&oom_lock)) {
>                 struct oom_control oc =3D {
>
> ---
> base-commit: a3d0117e02bfa1c3bb6c50e7afe42bbecdbb3459
> change-id: 20261026-fix-mglru-kswapd-age-98390614c746
>
> Best regards,
> --
> Bingfang Guo <bingfangguo@tencent.com>
>
>

Thanks,
Barry

