Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8296B60A2601
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bxMmhxtb
Received: by kanga.kvack.org (Postfix)
	id 9E9E26B05BB; Wed, 28 Oct 2026 09:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C16A6B05BC; Wed, 28 Oct 2026 09:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6E16B05BD; Wed, 28 Oct 2026 09:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67BB16B05BB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:57:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0AF1240433
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:57:30 +0000 (UTC)
X-FDA: 85372187460.23.65CE61C
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1B1351A0007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:57:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bxMmhxtb;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793195848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6jb7B/1j7cEHHeX+fTV0XB71j0TCm943LKPkVSn0vE=;
	b=2MtAvVisnAyk2ii/p6W2xqS4kwvmSf+paK2wJfifoWer/uSwEwz2NefIzdN1o4/x/NDXJG
	uEX1aBkzJhobNkt054HuZkVSKmwn9qPpiZ3JgCt4cz4RMwkUBPRsXCgxfhVLNOCjxCcOKz
	wkwT1rmX49f++MjEUH/83amA65LU1JM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bxMmhxtb;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793195848;
	b=5lY4Ywqj8+7plPsWkMurRaCUTYf3jkHuSeyZj+L4lU2n+vr57Fe8QyaIIqo89d9m+wFtZA
	os/68uRH5kwb8E2OJFNH06tohkDauh6el5o9Q4x+saYv4RBAV7LDaodUePoSJAG0GphoXB
	qiFBgt00111q2qptnTIF+UwYE4fttMw=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b1ec41d8e9so1249567a12.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:57:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793195846; cv=none;
        d=google.com; s=arc-20260327;
        b=o+ilu4037GrWarg5btEe9fh8dcZ9j6xn6vgxLqCbCSSbwxaPE7YXWBjq5s+fjnn40a
         UQ1nc/jW27Z8S3HZk531tiB5yoL/TwUB9Ea2HHZEDz4KT478ZmjRQRcp2ULYeJiB24uV
         qiXaGWEwBZY1PAUhnLFTNSigXWk6XEv8stE7m8ruGvBicmbG0pwG7NUKncCXsd5PoSKA
         5VwgMeZK642Xvj5q8PYYA191rmoXGuip/kDJO/UWpwPlNLdwDwiwv7Yhr1t3n7O4Ecak
         Rng+SsGA6jsSskGJI0pAYh/3wjIRrmA5xX7LSXpINWbpRQv+NjWwSD99lC2ZIfNZDfYp
         OSig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N6jb7B/1j7cEHHeX+fTV0XB71j0TCm943LKPkVSn0vE=;
        fh=p4kYY6TTjrkyc1qrVCYiHl6dRZN+NnmCCGspXSSVhK4=;
        b=VX1lnl01cBzAAk22Ojnryc7R7dZ3oBUydW/CVUUWvnLZ7GQmLsXt5MMwJlSMscSSXl
         nqtim8oq6gAbjaX0osQ+x5ykK9/pNNoMacIORwFBBfCZB4ezrP3IBWIBQ6xOAL8I0bta
         1py2o0RLTjzhNFdcBmEz7iox37gdjIryWU7gJxsOuRgy8sY0ly+Y9TrtB+B840gpuskB
         5md9byv4IjO91rxafy0lElCHJectkJQW3SQsy4wmLxhQeh7TksMf1NhLjDFUc9KtS87N
         8Zjxekg9k2dFYgRC8d4hbeKw1JiD+dru4tu3Q6p2a0k3T9Kkl2Uk9v8Ql7fRtwbFaFBQ
         v7Iw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793195846; x=1793800646; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N6jb7B/1j7cEHHeX+fTV0XB71j0TCm943LKPkVSn0vE=;
        b=bxMmhxtbbJ5AFrNgHcDOPVuD649dhecoRdP4h0um72xla3l40Gz0+rx7s9K0QU/1ji
         hBR9/xJN7xZwJtLT4DHvejpD+JLxrgc4uYEcBF5tYToh/3DQydAnyRbjXp2IkIghStdi
         DEEDFgA69VWXyocSgmIqmAWB3Ayz2WDDb5OnnqhID31YLmVCKjm1Hvbpyea75FdSiWtn
         FM5KOmuioHj+ar1ZpWEEnVYtStLcC4IHZE8IG4lyJ6Y853Nu6gZQuWIHIK48ZE8Jx71Y
         CJgTyj/O/4p8tPaWROgKp7Yv8MYXye8aCWYAxqLykkbmYpTqXdZl+k5KlWfTMcGC+bsl
         Rrsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793195846; x=1793800646;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N6jb7B/1j7cEHHeX+fTV0XB71j0TCm943LKPkVSn0vE=;
        b=N+PWaAqh+kuDLJGc7azyw1dNOnP3+pEMcKn05cpG+i3PEHO9l/0qnzJgY30DdiRvMl
         BwdJZeuVNmDWQtKi32w4ROkdmTZJKQYXeeNDKkb3yxtkWftA6YeZtwD/hiqytDAeDqNq
         2rB6+0uKiR25cEcKGq4OUbt/rAdvFl5LHucd7zbX93gKKoNTipAmKdeXqeRU0Dz92GyC
         SJWsQqdg/YQE8XRlzWI05WF1a0iedsLiGsCyzrvKtKfvrcifcoPbmKeJMMnNpI/fetOu
         IYqD9PN31jZqRpcMFuOd6IE/KrlctX0K2syJHslyP5jn2/gy29zruJrGe5x0FIgxIfWV
         xLNA==
X-Forwarded-Encrypted: i=1; AKwUvBybADgFfZWqWTUKvq7Pd0D1uajfUH2yh9H/PKyInSF8VQl0bM6sZ8jDWyjCdQt0xS9lS9mcAPYWcA==@kvack.org
X-Gm-Message-State: AFq9FYKyrDmqql4br7yeyVnX/GSFnMOmTaKMqpeSzdxfFz5I+aIFpFgT
	ia02fPRSU9nA5CWM+nZOEvlu9X5oW55Mx5QbZlrWS+R+iAiWOrH+cDxffGl3sJDsmntH/nKsx9U
	zyhod1jT+hliN7KemOkqXEWyHlilyuVc=
X-Gm-Gg: AYBFou1cXM7mgzOIMXvLoaQzEyNcNhv+CiQutgemhBi9wHywDuvs7+xZEw81En7UXdA
	nVCaEGgwSv63CP3SxWdcMI7olO0VhdKri81S9XsYBMbUurhCCxMUttC6B+c4W8H26qtzVi2EZOI
	Cwwqie6VKPKCOeLCfKraTDczno8/QDNzr4KAxr2F5S5LZm9SJcKlm4nuysgsLIid13bIy0TV0+T
	rSonYLoD8zo4lDF1NsIMTY943mit6r6C318MW7poDKuT28hIhCPY4DtnKQCUhESZQFzI3i6GLEy
	LNzilfpWhgrVWAF8vDDLjNuBha5JuVMgEtA8COIH79bPJxVk1L+KvKmEb5rwChpZtvQp4xYawjl
	NnWpUAcUzV60NSJf/Qfu+NvnAaRdisPwQL6X3pNFq9UyYnTI6aX7mJzNJuLA/M/txg9S3eA==
X-Received: by 2002:a17:907:980c:b0:c41:cf68:bbcf with SMTP id
 a640c23a62f3a-c49bdf2c81emr204613066b.32.1793195846170; Wed, 28 Oct 2026
 06:57:26 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fix-mglru-kswapd-age-v1-1-b1ffdec4ae52@tencent.com>
In-Reply-To: <20261027-fix-mglru-kswapd-age-v1-1-b1ffdec4ae52@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Oct 2026 21:56:48 +0800
X-Gm-Features: AclHuK8y7VKQBWVhXVH-qtsChj_MIThWMcMwlYaDr56F0maa3oCruvc7sukFQ_c
Message-ID: <CAMgjq7CcSxNMx9UxVjjM=W11fhd8sh3PgkHKt2kvdah3fy6kXg@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: skip oom killing for high order allocs in kswapd
To: bingfangguo@tencent.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1B1351A0007
X-Rspam-User: 
X-Stat-Signature: eh138drjr3xobsr9iiwecqxtyfm5jsii
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793195847-749104
X-HE-Meta: U2FsdGVkX18JCIFdZxiNoGNjwhz3HWLH1tMegfN09cfc2OKxAoEJTDfPhmQCrxbrD/UT+cZw1zA6KM2xDyHASIzXBzDpVyYpOTyZeMm2DaFzAeZA9+LJXZ4UDIHtDpyb10Rp+SoGKZH8iZTAb0hf9u+Plarvb5ysi94OKdFh7GihIvw6mb6KtqQDflyxWUkuN87fA4INe4HgN6HmpyFcka1kafm8MAOgZJqDYlu91Pn7xXrY2AZkDQkm3iOyrUREv6hwew3VP7A6i+lcTUdqef7AuLQt0Ul5XG55TXqQRCBiOsqW3fuZ6zI/yVqkdTLkxwPykhAHuCnxoG5SctEtnlBSGxjmmLCoMVPzMAEO3LP4BOywodWqGkl8E/hYWpAoqBcq0LaB2mRr3VTdQ33SnIOfhxRIpH1Zt84Z59vIc+7XRCfDr6F4R8E1TDgqpqDYeGPoOiTp2yIRilMwLmVriLkptZ4kRQtzSop6j+O8FGYnyHJ2KrtFn3jCAcoTqmsfKkXZLH9uf3Fb2f9IZfyEHDJ66lbyysi4NgwSAONTjPpLKV0W0Af4wJtsVm+IQqT0QpJ17lfEJYN46k8wGm6Xar2L/WLNCK9KASUQf934BjyCM9FoDnYpeQX31G9Nu78roTXLcD+ggE4/FzxFP+3gHTyAR8Qtq//qd6rrMYg/ilwhnk5TmVOIgMvoEqf4Tar/WyANsBZ1C6gS2433KAKxMYbIGVjtZomXFyvZ/r4F8AumRM/XutRgbdA0ta/6e4AfwheiJVAGVjMJMD9IyaaZRTYMGlc91b3zLhwu7OcevKftbTHvNrhzLTjZTrc6EpCa/CV2bqQ3rDK4Po0yz/P3UNHhFcRSZYyfmzyzD+oKZLpEPHxEK6pk4qkfCI5SWn45uvlNQJNSoqjtA0n4JvUhVT/PZueO5OlAvWLx80dfYx0ZaJOE72Hz9PMf3lhwU1DcCwjycs4eqvxB6U8o7+4
 j2bYsI1y
 aILarq+0j1lr/PLx6uRD9zwOtboCX2gOdx60r/HupogMd79yHj9WjmvLp13HJYz4XG7dGmlGrE5/xxyffs5Jx/JT8Gk/czhnvkH2tCWatfhzWqxeYyyfY52hunnptVNqYhVaNVnEc1NJz4SF8OsKXL7LaQmYbgJwjeFVvjFAy5EIfz2w58SRjPJiySmGxsTPtz/R9VqYNqP1i/W5dmraHzmWWsVigsTuNia9k3ZCSj/U+Ss88q42Fh7PBFp67H+cj6LasVIKvjQYVrkjgpdS5naQKwyRma5WZ64jEGzptBsRv9cbic2Ds+14c8kMdjgmfupaOBoqQBCcT8Wuq7mq2CqHK3sGa9ywQDyy3lbNXQjMaIv6wbwEPV8yKdne1cpXfbBelAKSoVjumwIlGEyQZeHut+iKQhwO2B0TM0BcSgWwaYPWfNkfk2JA7y4gCPxrt5jMGj98VopmfHUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 10:21=E2=80=AFAM Bingfang Guo via B4 Relay
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
>
> Fix this by skipping OOM killer invocations in lru_gen_age_node() for
> sc->order > PAGE_ALLOC_COSTLY_ORDER, which is also what the normal
> allocation path will do, to fail high order allocations without OOM
> killing.
>
> =3D=3D=3D=3D Testing =3D=3D=3D=3D
>
> Tested on a VM with 6 cores and 6GiB of memory, HZ=3D1000, MGLRU enabled,
> min_ttl_ms set to 1000, and a workload that fragments the memory then
> allocates 2M pages.
>
> Without the patch, kswapd kills all processes and panics the system even
> with plenty of memory available. With the patch, allocations fail but
> the system remains stable.
>
> Fixes: 30d77b7eef019 ("mm/mglru: fix ineffective protection calculation")
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
>  mm/vmscan.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Thanks! Really nice catch.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9959ca158ce83..b32777468ead8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4407,6 +4407,12 @@ static void lru_gen_age_node(struct pglist_data *p=
gdat, struct scan_control *sc)
>                         reclaimable =3D lruvec_is_reclaimable(lruvec, sc,=
 min_ttl);
>         } while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)));
>
> +       /*
> +        * OOM killing won't help high order allocations. Skip and let th=
em fail.

A nit pick, OOM definately helps for high order allocations :-D, maybe
something like, the OOM kill is to prevent thrashing whtn all memcgs
are younger than min_ttl (and maybe merge with the comment & check
below?), so OOM for fragmentation is definitely unwanted.

> +        */
> +       if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
> +               return;
> +
>         /*
>          * The main goal is to OOM kill if every generation from all memc=
gs is
>          * younger than min_ttl. However, another possibility is all memc=
gs are

This patch is good to me on its own with a nit fix above.

And checking commit 30d77b7eef019, you might need a Fixes: or maybe
even bring the check back which was removed in that commit?

But for long term, and as a follow up, the whole idea of OOM in kswapd
seems kind of wrong, maybe at least it need to check the water mark
here?

