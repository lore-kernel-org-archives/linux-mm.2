Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0CB606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 04:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=axOtmIct
Received: by kanga.kvack.org (Postfix)
	id C9C1D6B05B1; Sat, 21 Nov 2026 23:13:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4CAB6B05B2; Sat, 21 Nov 2026 23:13:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BA86B05B3; Sat, 21 Nov 2026 23:13:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 881266B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 23:13:18 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E84EB405DD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 04:13:17 +0000 (UTC)
X-FDA: 85461435234.06.ECCA3A3
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 030E980005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 04:13:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=axOtmIct;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795320796;
	b=bpdWy0zvS2+KxUJvh1k0P73sgb4JAF0SRLnm1ooAMdMWKwES7wX/SEeSnBP2gmuWG7cZWQ
	aviLH9V8//cTIYWXc9XjwXP+KjJqiAlZYOMnB+NizmhQPuRFIsOGt/Jil5HaGO/q60BfVR
	SPYoM9IeVnsukw1PaoEBhkhL67DrSgc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795320796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ljRHehwKpqXIEQjugVh5IB8G8Jh5NOSn1c67fpxeVk=;
	b=lagbhEV6LKV4zYsG6rec81FqwW4w6j+H6tNr0NeqnpYLBcZySn0AkRh/LyDQmb7HbB+8n2
	R2E8uj6Br7oEdMvFGsABd9COH853lqc7RHWXkseGXVY4fWDT0FDVrDFzdT4lfGeqystNqC
	pVLMw41rjF5fETK8z7wPmuPRT3Qlo2g=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=axOtmIct;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-54492d8a988so218151cf.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:13:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795320795; cv=none;
        d=google.com; s=arc-20260327;
        b=s2650fzG8qkR3YraJpKei/dIkm/hFTIvrF8yUjlXiCO07DRdbRFnqB3glv4tMq7Caz
         u+buriwWXOXRjkt1nOmZBFXT3Jkz4hEtaz2Fl//9lEqRF+wHGwE+VFNtwWDbuKN4n2Eu
         ZG9ZRxp+RfbSUR4adeOrH7RQbPS40MKKB1bzTm8PIh5lvHDb+LRFsbgIxMXaEbyVD2s7
         SqWEDwW1shNqW6coRw6qVJaVDVDdqCuxcRU/b7gsOKmWVzBprBQXXLxab/sTewkU+xyu
         BYbDT6wj9WC1ClLeM7qNET8TcQYMaPEtZhaVtIHK/Fh9pV47zp9AOJHluPEwoaZcy66A
         fHxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5ljRHehwKpqXIEQjugVh5IB8G8Jh5NOSn1c67fpxeVk=;
        fh=Jl1yoJ7q7Tfzp3Ql+WWccHdtVYv8cDE6AUuAQyE68us=;
        b=TdVEEX29gYGIV31Y+MAahXz3au5b+eyaIPHSQvjhsy93is1N9brrTtdt0WgDXeebMZ
         D5uDhC/t20Cc4G/XQWlbOmmYT6uvfWWMm6x945oe4fwvW1FZhCW/LEEBP7I8kpCo7EN1
         BdbtypgpLMOotsb6d7q93Ry5zAvL+J7/dOh5tZGP2Pe7fXbc9zAXIIvFvrsj08ugbKwV
         VIHwGIGJJgGAGxh9GcYAeqifhcajwxAMl3+4h90cIwDk2PtJBgzeONC8AiBHQ2lVO9kH
         kJUEOvBYqHYGn3A1m7T8qR727j8AC8mr0m6QQvOyKAjuxkY+TBU7u/DfIeIQstKjxybd
         X4fw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795320795; x=1795925595; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5ljRHehwKpqXIEQjugVh5IB8G8Jh5NOSn1c67fpxeVk=;
        b=axOtmIctIgUziRPz9eR/BQTI6H7Pq8AsvwkcJ4P/6Fpd26wRQtAVlMC8hzeXvsqG4k
         EpG05NbU2ihtMxin6xtDMeL1kC3MqlvEPkx2cBk2PJ8/TD/QVECdz8kZXDoI2TAftZtA
         tcSmmbvpxbL3CUoI/UMm55TyzvDpOHGuFIaWxTOjcgseaNkoS8tjLj8Mr0I3yF45Vt3b
         aTE3u7hugvioSadDBG1tdWpopL7MWZFOtP7n5D6ycXluqYshAV/O+v3T1ou/dDNCSAzR
         DqcMD5oWf68Kv7l2PPR5aTfLyjKhz+LzIHfCZVe6ENwjupbBNivdBxiOyqXLD9oKRl5Q
         VdJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795320795; x=1795925595;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5ljRHehwKpqXIEQjugVh5IB8G8Jh5NOSn1c67fpxeVk=;
        b=c4+xYy/6GeHRjjQOdk3wHbeXCt1I9jsb4ddKTq8phT2iKHmztvCmgCl0qh/KG8WoXh
         uhBcIEZU2Yb/XUizIMcnm14w5mT4DG8JmxRV5CaiOLKSetWr9n+kYPf38W6W5tB2arLX
         3E2AGwHJSlZQdF52ZyBNjo4A0EOfh7VFAgnBnVDBQboPMKuXf5ms9TZx3uK+Lvf5vDjo
         ftU9Yp40bKhW43H5HdMOIl6c9e0TUBzWr2+dsrMWswSZocveFJ1IJRiLrlQ8qQxoMtfz
         jfz7kCVfzjNFNdZAf11qXs3sD528mjoQk1nq/EbrwitnxOIj3G3rtRe6wIldRZO4P/mY
         iEqQ==
X-Forwarded-Encrypted: i=1; AL+hErH2nVH0mIDBiXaQXZOlYutuTEdks2ysxs7YIfT7zOhzdr9V0s2UAsMG8ObhXKhROZZ7Wc1sK8HAqA==@kvack.org
X-Gm-Message-State: APuU4Z8lZFneRKoVgWqwsuAQkJvM4lWW18VuxNlsKnGxKi6HRDJomTou
	9UVZCNmv3lMIrELlnAY7A1ZazsIR19oqfm4r4GiXVQ+9KhmDP19sUnUtQLnU/FtFTm8ETFQNKrt
	AucUzWYJB81zy+UIvhsl39KgKgGDPY35PY8oA51F/
X-Gm-Gg: AZFdTZcDuI79YVQ/77fUkPgmqcX5CNKzGiIKkd4u76pnjtQjJjkreNrJ8u6X+y7ycxM
	GZwoMF66XEMYQ8ctUbro0POFZ+7F/EDVjjJdBoeC1ZkRwsflM29VgFie5pb5glCEi8E38R+hm2Z
	80YkjdXkuywcSK9O0qcHRkAhgkk1MhE2v/6aoU0cWPuCH6hZI4qV4eXmjX7Om/5WTz5GkLF5zfH
	DVGG6uuMc290KCvZZh32zQAYlWbj4M2G1dgG5EnffndjTmle60N15xmZM8YOFWjvxHgZwd5FMc0
	AOJIZqVYc23f9hQcSqDwFTNXFTpsKAuuNI2e0wcrUueF8Lo5HNyNL3W+0i43gciuAg8L5JrY+qF
	JmZQyknUfp69JKEUtZexrcfp7MTDpITYJKJJUnxxny2DWs89HwbjxF0gIpUoPuIEpH8qZ5GA=
X-Received: by 2002:a05:622a:c15:b0:530:e335:4ef with SMTP id
 d75a77b69052e-55d88014944mr19387541cf.2.1795320794485; Sat, 21 Nov 2026
 20:13:14 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116071325.263682-1-hao.ge@linux.dev> <20261116071325.263682-10-hao.ge@linux.dev>
In-Reply-To: <20261116071325.263682-10-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 21 Nov 2026 20:13:03 -0800
X-Gm-Features: Aa3M54q14FtdKOZ0RiWv5OEBoj77CCH8AI-Mq7soe9RzxldP46nF6XTAMApufpI
Message-ID: <CAJuCfpF_=KV3ArFO5LtMjc4EGMr79tX_tX2K=YCG_JTvC51OfQ@mail.gmail.com>
Subject: Re: [PATCH v5 09/11] mm/vmalloc: undo what vmap_pages_range_batched()
 mapped on failure
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: 030E980005
X-Stat-Signature: try74hwr9iaujdoyq9xnbw9syoarop8i
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795320795-641515
X-HE-Meta: U2FsdGVkX19/BUxuAaEY7FAYqv8jWUQBG3jTlZ7JR8xlwQlpYKCq6z6qr4xrMdRhLxvhkkgETkU7S2sb3t6rBKV667i/XBmcs2IszIuhL1vInBx58nOLjj3slE0ZhObWgc/Eigw3rTNYZtkJE4niKpD9VM4GA/8No8v4FGzSJa0CBSUgmW6wMWfLQsDy3RkOGPcmoldcycql5Qd02C9ZvAHPj1pinUbphkcHpfyW88rzAETs8kv4SRu0mGU1PQtr0PLQ/QUoG+tdcWd00uIpyydlSx0AOzBAhKV2TNMyzsY76ngNtY0fvhHWAmuJh16SF/O6jW4+uRKWJkoLx/fCNJ3GwxQfgQdySYcBL6vTkTc+rn7iIfv9fBDtqAR6bouw+H1FY6EuuDzpeoq/Tc3Qm0+XbKi6GWWnMisEWeuvH1vfXNqqaAkCUC5WhYduyFHAzRuwgvSaH3FBk1mxU+OyeE98sU7PgKT9jW+CEvINgGxnxhWV4sHaJdo3Et7QmPTo2+74g5ZLiDOGrSTEv4f2ZvcRLpp6h75QZXdGcYPFZFk4lLUyqHPS0/v9MZ35hWNs/ZfMuyKLCL24caeSvdjr95k+sAJOuJibBiLdeLqoLHmBCiT3MFn1z9280s4Evb7KRwt5YkgKGAYn5vPTA/27VesWeltQqn5DpF2eR/B6v6tXeNomTOjgqq+T6M+3lRlgP9l3+JN+2UUI8fqa9XDz7ZD3F8dZlSNRqaviLBpOl3ijW2SP4c66XBG3k22aJYEYgbUFZXGLWgBp6A/RT7sAsBAfrB4K7oRpgnPa7VgtwSX0aNccBJP4yu1aOa49VFiJkfUA6BcMsroNd/DHGAwvNZENN/85kynPVOuSzeEd2VLaeeeqrf/2wZY6yow0SfgzuTk3x5oJ5UTgFuXUxIfRMjs652N5VTFEFGHulygTaGRV1rUlMPiGIjjhgx2eeNEK05IdjqRxaihhA7UqEKK
 +r9VQbO2
 XkaLNSkP54zHyShzvx2YqCMPs/OWrEjIOjZlbXvDPKrjB7/nNuA0rSOEWjQXCzntgUl9UyDeTV/+328KVlkNuGILXW4hQJPn1+JEhdgcmEFd3SIpXblARxfzOyKIa8Oxv8rnYJwAcAJ/z2KFxTyam2cM6TekopNXPKt5YRLWVy4RalM52uJb0q5MuLvpeCOJkEZBsjFRJDPlx8kIKLj+8IW4Z8v/X6tVYUawt5aryidgOOkpJ8C/CcBGZobUJ9TZaZWZIXfFt0R+JCjXg3eAqPKXseKq5tUrmDGYw0HvRBy4+musmL/rGO9srOlQ0kcJhXv8h3foDtlYxRFv6sihbbI2c+ynRnMc64J5hvPFQlrzP+knFSYDhDv/l11UO1GRCsK28ZJkwFRD4Z6S0XoRJrtn1AyVXhwKurfnId2pN7OS38+B8Dtzu362jQQO57hX2eBpeFQcwQku7ABwrr58KP+C9/7NLDLQIvEqvhK86sFh/AJoRK5iba8TOnZpbDxg9Ay/pPbhdNleZla941XEW2NBeFQuDXnNDuc9edXXBu5ev7FOC6xG5FuqFyRqc9j9qHObhOORiuQTdf54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 11:14=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> vmap_pages_range_batched() maps the range batch by batch. When a
> batch fails, the batches before it are installed, and the failing
> one may have installed some of its pages. mapped_end follows the
> end of the last installed page, and the error path undoes
> [addr, mapped_end), never past the point where the walk stopped.
>
> The KMSAN metadata is set up for the whole range up front, so it is
> torn down as a whole when the mapping fails, like in
> vmap_pages_range_noflush(). The only caller, vmap(), also calls
> vunmap() on its error path; the double teardown only walks over PTEs
> that are already cleared.

As I mentioned before I think this patch should be merged with patch 7.

>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 28e65073624a..aa80bc273ec0 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3748,13 +3748,14 @@ static int vmap_pages_range_batched(unsigned long=
 addr, unsigned long end,
>         const unsigned int nr_pages =3D (end - addr) >> PAGE_SHIFT;
>         unsigned int prev_shift =3D 0, batch_idx =3D 0, nr_mapped;
>         unsigned long batch_start =3D addr, batch_end =3D addr;
> +       unsigned long mapped_end =3D addr;
>         int err;
>
>         err =3D kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
>                                              PAGE_SHIFT, GFP_KERNEL);
>
>         if (err)
> -               goto out;
> +               return err;
>
>         for (unsigned int i =3D 0; i < nr_pages; ) {
>                 unsigned int shift =3D PAGE_SHIFT +
> @@ -3764,9 +3765,10 @@ static int vmap_pages_range_batched(unsigned long =
addr, unsigned long end,
>                         prev_shift =3D shift;
>
>                 if (shift !=3D prev_shift) {
> -                       err =3D vmap_pages_range_noflush_walk(batch_start=
, batch_end,
> -                                       prot, pages + batch_idx, prev_shi=
ft,
> -                                       &nr_mapped);
> +                       err =3D vmap_pages_range_noflush_walk(batch_start=
,
> +                                       batch_end, prot, pages + batch_id=
x,
> +                                       prev_shift, &nr_mapped);
> +                       mapped_end =3D batch_start + (nr_mapped * PAGE_SI=
ZE);
>                         if (err)
>                                 goto out;
>                         prev_shift =3D shift;
> @@ -3786,13 +3788,21 @@ static int vmap_pages_range_batched(unsigned long=
 addr, unsigned long end,
>         }
>
>         /* Remaining */
> -       if (batch_start < end)
> +       if (batch_start < end) {
>                 err =3D vmap_pages_range_noflush_walk(batch_start, end, p=
rot,
>                                 pages + batch_idx, prev_shift, &nr_mapped=
);
> +               mapped_end =3D batch_start + (nr_mapped * PAGE_SIZE);
> +       }
>
>  out:
> -       if (!err)
> +       if (err) {
> +               /* Undo the part the batches installed before they failed=
. */
> +               if (mapped_end > addr)
> +                       __vunmap_range_noflush(addr, mapped_end, true);
> +               kmsan_vunmap_range_noflush(addr, end, true);

So, you are unmapping (addr, mapped_end) range but removing KMSAN
metadata for the entire (addr, end) range. Is that intended?

> +       } else {
>                 flush_cache_vmap(addr, end);
> +       }
>         return err;
>  }
>
> --
> 2.25.1
>

