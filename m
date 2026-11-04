Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1FC6606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 05:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ichbTzIF
Received: by kanga.kvack.org (Postfix)
	id C02D06B00EF; Wed,  4 Nov 2026 00:18:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2826B05B1; Wed,  4 Nov 2026 00:18:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0E16B05B2; Wed,  4 Nov 2026 00:18:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 863CE6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:18:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 149EC140625
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:18:01 +0000 (UTC)
X-FDA: 85396279962.30.BF5532E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 167F0140004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:17:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ichbTzIF;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793769479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6KEeyjyNXQU3ayuJEeECWcZazCVcQKxSt/xZY18j9s=;
	b=kF9JoJ0vco9+0c9JEO/EZw+giqlHDiwIVv98yh1dfOteqKKwRrxRMS5vib8iK99sCS/FT1
	Te1Ezz7jS2a52LLBpFojLGVmmXXqxgua5gi29p2ZNWroJtmQ3oOB6TMvmrrRh7xuKx2zjn
	SBJOmB8ej9BCiPEApuxZaJXNY4Dl9qY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793769479;
	b=G6ky/OKIG6mbg7+ySgna5rAM3kmW4YNKmi06k/2EtgTUcVYpA5XlhRiplmUME92y5Tg/WH
	kGrkbhMpXyk0UKbMHkZmWDfxjUFXyViM9tg0YG6zH5qKu+FpukeHGr8TH6HmN2q5sX1RIZ
	WUdzi34VivB1UV2jFEPpsRqTdGcgH24=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ichbTzIF;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1274C43E42
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED7C1F00A21
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793769477;
	bh=p6KEeyjyNXQU3ayuJEeECWcZazCVcQKxSt/xZY18j9s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ichbTzIFya4W4WvNFCCv7nTsWENKpsz/V73rkUdV/LAxdcLmHpB33xGEZaX0EJ+C7
	 fUYkpcfQqYF5+wfPoPyIOk8jbvL/1+HaOku9c0ovYoTVebuAFLP5XXggDYzfJcqaUB
	 c0bWcmVTgsq0m6Ecl77tjDe3Ntlx2L9fudNU6uQp8LVF7ZqMTcYx7csZorF1rhWDrw
	 sfpxfT1nsTHEBrAHDGrLHn6oa24jb0/CppzZ7NoE1p2Q6h/BX48sFUAp0dFFZRTIz2
	 mxQf/OZ/tNTlSYu5RDJww+WcxbkSks60rmE89D5WvO2JTr6G7u53SUBebSsSlUnS8o
	 VpayNyFYYtOCg==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91c75267b0fso3803216d6.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 21:17:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBw1787zEWn0xahDJvlC+AEypRJnny/jvt0TJDWvl7Xe3Y07eQvs1FXw91Wmm+ub5SjljWEnErqyAw==@kvack.org
X-Gm-Message-State: APuU4Z8W+GwYuELYhcdW4OWrH2D64RvPxbTDxISNoGV0bzScyEUuQCQ2
	BzFS+e4BA14sIKp+ZadRoVLs2MOrOSY6Smjf/cSI6a3LwcG6B8eC9vKC9xvlJvt3ovw74Ja5DwQ
	m+7R8Lt9FRdxZqE0rit/BqbT6QVXjTLQ=
X-Received: by 2002:a05:620a:2986:b0:93f:353c:6bee with SMTP id
 af79cd13be357-9442179bdeemr2649014985a.41.1793769477189; Tue, 03 Nov 2026
 21:17:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103113711.1832834-1-max.kellermann@ionos.com> <20261103113711.1832834-5-max.kellermann@ionos.com>
In-Reply-To: <20261103113711.1832834-5-max.kellermann@ionos.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 4 Nov 2026 13:17:46 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wpd-e+xjm5KwihVziAeVnQp3XYG=+-BKmx0SVEhmyqqw@mail.gmail.com>
X-Gm-Features: AclHuK-K3YmNyTgJ3q-8NAOMY6-mXLoQSaTkbTkKltCKCY_JfrfNuVcqZ-jSFOg
Message-ID: <CAGsJ_4wpd-e+xjm5KwihVziAeVnQp3XYG=+-BKmx0SVEhmyqqw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] mm/mglru: avoid redundant rotations of young memcgs
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: s71ur981xbh3izia7gfjudmujirzs8k8
X-Rspamd-Queue-Id: 167F0140004
X-Rspam-User: 
X-HE-Tag: 1793769478-421257
X-HE-Meta: U2FsdGVkX19bS+78xNvaFuDxgFTC/lPNjJ3AvLwtClt97fzmljHwXH/mTXxOuzrLeiSRSnFBfLo+dGD1kYq5wRF782KCsnDcxA+LVPvh6eOwyphD76tIcm5i4xm9wo33htpOg1s06Eoo3+kkTWPjcGFZBF0SGI9OTccZvzdXBc20I7Pr0pNzqGkdQYOHjBn0uWXJhvp3cGQX0P4gwkMBGV1wxKCtRJaSRKM4w5+9mQXzvggyhOdXNZ0kFDZNS94PWbqK2AHkzHESh0c+ZjnfK82zscGh8d44WW2eR4tJNBppaFLKJOXfb8BrBwU6sdq6/ytn0wGyaArYImUB2nFYm20ENOxqWqjhq1nasSk7W0Y0IKkZtjNsCxLTL5MosKz3X1PGXHgfKDeJ51HPgHlt1empB/ltpc/QFlqVDzsmdnQh3HwVtnX/k9JKIu7/T2pOyXLk8orgxa/l55uWeWSs7Axproro54e5RIZImj+ZDIWhGj0Ks79+j7Q2GJNB6QXCDDM+fHNi1IZPbK08lJmSCr4HwTdmbdpdBNZoS7pmKXiB7INhF2Dlrk+OFYjnjBYxFDDHd5gFrcuU5tzr9cejGg/r0x/9Pfb+sPYtbPhBqH0k396TItyvgwdoJZ0ni0RJ2wuyGE6C+yGLNvPlJc5p2Cj8L8lwLFBaewkWod2oIjpu0X+B9yq3C89BIs2BP/Fsa82TsLC1/Lfaf3c6YbqWkBr1brYCz7rY7yU42oWe0ee4XrqtR0wQY/yqdNC49rqbakR/cVHpT6QbERTSOscrHejJhQ60w6iawCUs8F6z9+KpLejnJBetohWZ4o2wNyxZEnx3BzGZQoNxf89OvWwj2d4+THPXH/gx06hy2mL8C5Ayt/mTy0M6GUMKz+PUIrIAHI5hBCFMMaofpAUk9w7q56u5ZFikc7yUanixNEtaUlpCjiQt0w/t5E7GNnOgP853QiK//dpIx0QjwtXeQSq
 SEIDmJfH
 K5OSFKSMfYpcO6AsENSgC9WXXS66WdjsTMMbzBPnclyoOzLHYnuJ07ZIAl2wHjwLUW+GQ8x2UvrhantBxebqlY6rusJ/cqpHvTaxLgAOzljFJoxaLlZ984MGWiSkXHq/qn0gMMcyhNQjau13O/HK4pOQB2lu5kl4OcZpfoscP8vb+ZGexzDt07fIsSajxODjwKFXiDOcEW7hLF/7S1zyaNGN55Yq8gd5hig4y84YXRyNTZSV8/Gd9ipySwE0CzDof0NLHHoytegTCxtAReKyAtX9GMU5SPisqHBaBDSZqu0ojmnzeObEiW47KDCb+cDQvKZrj4M2ppi35mS1ai+LHZx+zGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 7:37=E2=80=AFPM Max Kellermann <max.kellermann@ionos=
.com> wrote:
>
> Concurrent reclaimers can request promotion after another reclaimer
> has already moved a memcg into the young generation.  Requeueing it
> into a random bin again adds list mutations without advancing the
> old-generation scan.
>
> Therefore, skip `MEMCG_LRU_YOUNG` when the memcg is already in the
> default segment of the current young generation.
>
> In my micro benchmark, this increases the request rate by 36% and
> reduces the average duration of each write request by 27%.

Could you share your microbenchmark somewhere (or post it here
if it's not too lengthy), perhaps on GitHub, so others can
reproduce it? You could then refer to it in your changelog.

>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  mm/vmscan.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3075949bf641..899f756bd15b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4620,6 +4620,14 @@ static void lru_gen_rotate_memcg(struct lruvec *lr=
uvec, int op)
>         else
>                 VM_WARN_ON_ONCE(true);
>
> +       if (op =3D=3D MEMCG_LRU_YOUNG && old =3D=3D new && lruvec->lrugen=
.seg =3D=3D seg)
> +               /*
> +                * This memcg is already in the young generation and
> +                * reshuffling it again cannot help the scan of the
> +                * old generation.
> +                */
> +               goto unlock;

I think this is a correct change. I wonder if we can
reproduce the issue even without concurrent reclaimers.
In other words, can a single thread running in a
memory-limited memcg trigger it as well?

One thing I noticed is that you may not need to call
get_random_u32_below(MEMCG_NR_BINS) upfront. Could you
defer generating the random number until you actually need
to rotate the memcg? I wonder if this could further improve
your microbenchmark results.

Anyway, the compiler might be able to defer it for you.
I'm not sure, though. Could you take a look?

> +
>         WRITE_ONCE(lruvec->lrugen.seg, seg);
>         WRITE_ONCE(lruvec->lrugen.gen, new);
>
> @@ -4633,6 +4641,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lru=
vec, int op)
>         if (!pgdat->memcg_lru.nr_memcgs[old] && old =3D=3D get_memcg_gen(=
pgdat->memcg_lru.seq))
>                 WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1=
);
>
> +unlock:
>         spin_unlock_irqrestore(&pgdat->memcg_lru.lock, flags);
>  }

Best,
Barry

