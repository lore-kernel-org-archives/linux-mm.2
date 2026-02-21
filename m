Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E313C61DE1
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 10:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637BB6B0005; Sat, 21 Feb 2026 05:27:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5386B0089; Sat, 21 Feb 2026 05:27:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD236B008A; Sat, 21 Feb 2026 05:27:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38ED86B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 05:27:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91D841A0442
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 10:27:50 +0000 (UTC)
X-FDA: 84468087900.10.AE5C245
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id A74AA40004
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 10:27:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="N/TkE1T9";
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771669668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+FUSakG8dJNNhn6FKDJASlbvJpzxIaFyhcv2foqnjY=;
	b=YWGpDTYqLBwAJMvI5yGqKCtXgp01Npo3Mh0HaZsc6SJB7FHdEQ8X5LgglI2lwo2Xz+hJA0
	vpyPu7yYbnUma6xgvrf0omNgruQ0fr4xf3GrvqrX+V0nhrFTA26z5ePjs+ul2qm75PgQmV
	QE12yIpsn+bx++EFiiyGAJ+saOKtkRg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="N/TkE1T9";
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771669668; a=rsa-sha256;
	cv=pass;
	b=wHjG0BZs4u48FfvblIh8bG/Qh5hgLHp8uIe0APgLYNU3oWsvFJ1ddMtXp3GljNEbWam8mi
	i90ffJYcR8yD64iLH4iZv5bQIAhltTa6j7WTjtYuq8TB9fTVY0t2PS8fgfgNlmhfCMvHa3
	DmQ3/jege9luFhEIHMlMGiw7QMck+p8=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-896ff127650so47898966d6.3
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 02:27:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771669668; cv=none;
        d=google.com; s=arc-20240605;
        b=KwxCL7uKD2FCOO07I9tQgKOmgn7mhntMc0ajYl4kTEO8jGxGhomt2c7r7HhVlbBchn
         ejIRHtpsSBCWEhXi+RlAuFr8Ot1c5CYyIqS/43+wWw4iqiEFRtV11QKqw4qNSRauS+to
         7nqu6iZz7W8wxu2MWjgxe469p/f1VdPtDuwCNaugLuCT8f9OtiwUCDpveKscfEyw9imc
         V8XWO2S0scHeFOvjvuczmh/qIRcNw8HgbbnirK92OtdGNNVqTIDsTWIGObx4xwm28oTq
         fLC1KeA57fCpUJj7B4kH5hLUFHlfzs1JuEj01UdxPysUcasAsOHzCcIIGofuIYgId79X
         yHLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r+FUSakG8dJNNhn6FKDJASlbvJpzxIaFyhcv2foqnjY=;
        fh=0PIbs/TD6NUZiFsPtvDsKHVfqQl9+tVi/waVJQHMah4=;
        b=iTm8pfZz4pseLsm+jdPicn7g9uMO+H6RUPG8c/MIt4ffSKcOhK9VHYoIFQY9ODqbaX
         5mOODzxhEmFemWD+O/KeIbpmE6oH5Qyh7x48qB37UGSL9MvlFYxorhNzO97KQmcjE8Vd
         r2H7jq2xDZ/r1CgdU1qB29L3+JAP1Ffd4OtgpXLq3J49XnJ4bNgR1k2HLlaWGJBahKge
         fLoJwOUWwNpUqxOBF2VVM5WCNPmCi4FTzgkTYG5pw3jcDzMTCwyA2Xc6C+CcJvsbZNtG
         BJQMv9VA5WAOqTojWl0PHyxI4ySycXWrVVxnvjsMcdvMbpZXGrygesEMraSmG+RcjzAq
         Ac7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771669668; x=1772274468; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+FUSakG8dJNNhn6FKDJASlbvJpzxIaFyhcv2foqnjY=;
        b=N/TkE1T9Fx7XHhjbn72Mq0YTgRTIUzOlnLGx4SQcR4ltBbWGknpNVCHU4Q+4DvoeLr
         Ll4VyOzvcOH7amM2MpcLGJrNnMesb1JFn507gATk0SltAoi3XUgUTNON9yck5iSaZ2zj
         iPUJ2Ww/h2DFzyoEU+rv1/Ng4E1iyzPjRdy32LKq66JcPTsEQKUY4Ez7jTydruTVt5Rl
         23bF10nliZsn5YsnWUGnUGb2PbKMxxDRr8fMMEiQD+3wVgwSlXZk3hkwQFfDvQPO94fv
         p6mE2f2Ms/86HX7/GEDjwnYl/g93fMjm0Kv9uHwT6321Q7Bt2lVrMwLhbCc/xzeWelO6
         sw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771669668; x=1772274468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r+FUSakG8dJNNhn6FKDJASlbvJpzxIaFyhcv2foqnjY=;
        b=LosdE1lC0aDuPr404HrcXjHzUxjgwoZ3t4KW2rAqb47GRs4c+b3T0/ZDalbntFaAUI
         vqBM+yp6uYkd6rSkWQb/pICXEJO6knZ1xgdyGyZ/WJlcMzqTcLPdj3pfLIRhhlmkRycq
         M96rdhBqLofr7G5Ctok3E6vrWhlZ5z8OZ3Oe5a0YtGN9ATb6XVEL+cWN4F9/td7QGWBc
         qshcZt1kWT/9wlndjVgtGox5bLlTqJ8iuqQx0P8issh47bn3VlS+mEkjX630qNV6oKmX
         /knFPrfFQs9Kzf3J3PKMVvQEyvahdPRBt8k5nEQZe0KGKKKZFOCq9c4pEvvxBwC6NR8W
         j7lw==
X-Forwarded-Encrypted: i=1; AJvYcCWASdsHFKr5sxtFGcYgA3h/8b6EGxERYuyZbwAQ08rDk33igkirFf52IIh4R0Yzm2MQaQcB3v5RYQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1inaumTXmEiXIcBGBRZqAJgxT4f0eajWEmndyOy4oeVbYUzSB
	DQZ7zQz4F/GPOc1kDsfq+nTgNqeOYdelSnk2sDlhEEXRlgocRKmoepGiXszADqnYTYUFpcT2Qtu
	ABdMi6i5ChH5JaJYKHHLJFsipYJRzHXw=
X-Gm-Gg: AZuq6aLOvEfBcozDh6hEJX8cw5t84ebuBqQilb99zxv8MGkbxFxyOYn8qfyw5SCiTwi
	Ey4hy4F2UmIZqIFxtactQiq6rZT7X1Iln1Autmp1eZaGTHnmTqrk4i/lNmp19+tDanYS5JagUCT
	Ogwf8msqHPoCTe9EGhV6FOXbbokXfGvpW1q+pvQVaKuKGm7WeRU0GI/WJoPrbx3q6Cmf5YrBSKI
	FUUB4zZ5DqU/O62gxira54pv/I0oN9l/oJwciPwuVWXr2igmq3pbXgeNCRf0Lg+t5pfrM96zaJ7
	R5M45w==
X-Received: by 2002:a05:622a:180b:b0:501:49f9:7488 with SMTP id
 d75a77b69052e-5070bc727d6mr39263471cf.49.1771669667480; Sat, 21 Feb 2026
 02:27:47 -0800 (PST)
MIME-Version: 1.0
References: <20260221093918.1456187-1-vernon2gm@gmail.com> <20260221093918.1456187-5-vernon2gm@gmail.com>
In-Reply-To: <20260221093918.1456187-5-vernon2gm@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 21 Feb 2026 18:27:36 +0800
X-Gm-Features: AaiRm52sH5twCKKMwApVUYIS-0HHsPJjeOlr3Faf2bFZ8eyM9a-Fr4RTLg1oNuw
Message-ID: <CAGsJ_4z1twdSNrAVR_vZRnLW4xtsfi+vegNMCwht+RPCjy=E4w@mail.gmail.com>
Subject: Re: [PATCH mm-new v8 4/4] mm: khugepaged: skip lazy-free folios
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: A74AA40004
X-Stat-Signature: puefsoijs4raojmp3fo7dbceajetdbdu
X-HE-Tag: 1771669668-76361
X-HE-Meta: U2FsdGVkX1+zk8cO9cc2HGtCcBbBSotfdYkuyiB1v+x53zV3iRnatsCG5YnFovm/jWd0JZoGAIGPR+4w57y2UmDqpfsFP31tWF4PD5GgW6AS9zJKftbXBVQInd4kNmUKFakzO4ZpPs7qn1HdIZN37gREx95w+eEAAE14hWGhDrZsdonLpY8TRwfx5kEwQQP0Q3v/Gw63ikJnKLWuBwsRh9zLTDbPDEOGwuw+MGSPCu0DRUyyPl0nIlaCSoic10hFs+RzqTNvUSg4r7v370h4lZurq59oZNyvW8VptKnbcka8AiPyh51IuyI29vo7pfvhk0vq3wmX2AUvpm//3my3zZdlqesdJCN9+VR0VV08e3bEN/oXZWnZ0fnk6dSHM+D/+5t/SRcwmsLjTVNq7sIE+VajvY8yz1zPtbg3dab5fm+emvesEnIpxOpl0sESP29RkU9J3TtQ5xCkT/cqGqhYny6o647vOCWZ0xF1JfJ7xe+ip+UzxFkrdZgDsi7EbQImpyLg8afscWuKcf5BOu7PtHWbS3FABg5VyS+O9kM0lXMekX7kbt6xjoke7GhSoJ4wjVC01QW98laASrPpTQAKVEUpTQsejigCd7gqQwYsBtFa7l3hzhWBo+auPuWz/nrN0hvB26+xc6g7ao1dXq745VruK8mUp4hvSuDNz1ipDZjC1ZmBxq7NwOlJgbLkJTkRCrQO0J6a7WRgsVWwl5/U2j8I6E1olhwvSIvr5TVetj1XwjaabmkseP3jDuk4aA5kOeQdzUrX0AzVx6LP6mYACledYNzrKJdt40m1MzQcWqIc9rqNCkrSWSNHnBdg3cE5B5SDIqip/EeQ/EXCphnd42P1sb+zPCaUKvkp/0opPSaZYyLpwjMwtLuafVmptBh75omfs6/7hNNWKCigwHVnyHcgQjHsCvNvN0kfF9GOY5z/s36yKEANbDjc7HizWMKN6MNpRKl11wOgzckv7/J
 OuW5z5as
 8ClxJzafkzuMs3kaWG2GP4UnClL337kIkCY/8py03mby0q8CbhwAEaAKIP75QS0vQyT8gJEzSgjXAJOYBqrXtUVnkRvyY7ej9eq1vK08dK60HYvX6tXfBYSnETOJRkHo60PO9AhZ5LTrCzlyw9Tkzun8SX4BqE+bsio7Lae5X9c8/iJHByhkTQcF4uUboIxVUFjfpcr67UVhKYduQX0EzcRZEKTIgK7CzBGwh4TJMbX2k0vMAfK0G0lUY6Dvpl8p2V/rHYKZCKPQQmWOkoURiEmRX3YzQP6l64vhQBqJpnhVD6cTViiRJrhk9I7Wth5E7AgngkdIieID1mRHFAzb1XOeKltJ9MKkTrwKzSHiP/ShXnaCi9CPUX83eAUzyNshy9/7hhiDWTMliYzvgmWfvla35S8+oxZDAY22+PRJkI2Znby9GAtDcVdZ9nE+hYUzkKqc3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 5:40=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> w=
rote:
>
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> For example, create three task: hot1 -> cold -> hot2. After all three
> task are created, each allocate memory 128MB. the hot1/hot2 task
> continuously access 128 MB memory, while the cold task only accesses
> its memory briefly and then call madvise(MADV_FREE). However, khugepaged
> still prioritizes scanning the cold task and only scans the hot2 task
> after completing the scan of the cold task.
>
> And if all folios in VM_DROPPABLE are lazyfree, Collapsing maintains
> that property, so we can just collapse and memory pressure in the future

I don=E2=80=99t think this is accurate. A VMA without VM_DROPPABLE
can still have all folios marked as lazyfree. Therefore, having
all folios lazyfree is not the reason why collapsing preserves
the property.

This raises a question: if a VMA without VM_DROPPABLE has
many contiguous lazyfree folios that can be collapsed, and
none of those folios are non-lazyfree, should we collapse
them and pass the lazyfree state to the new folio?

Currently, our approach skips the collapse, which also feels
a bit inconsistent.

> will free it up. In contrast, collapsing in !VM_DROPPABLE does not
> maintain that property, the collapsed folio will not be lazyfree and
> memory pressure in the future will not be able to free it up.
>
> So if the user has explicitly informed us via MADV_FREE that this memory
> will be freed, and this vma does not have VM_DROPPABLE flags, it is
> appropriate for khugepaged to skip it only, thereby avoiding unnecessary
> scan and collapse operations to reducing CPU wastage.
>
> Here are the performance test results:
> (Throughput bigger is better, other smaller is better)
>
> Testing on x86_64 machine:
>
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> | cycles per access   |  4.96         |  2.21         | -55.44% |
> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
>
> Testing on qemu-system-x86_64 -enable-kvm:
>
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> | cycles per access   |  7.29         |  2.07         | -71.60% |
> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> Acked-by: David Hildenbrand (arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> ---

Overall, LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

>  include/trace/events/huge_memory.h |  1 +
>  mm/khugepaged.c                    | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/hu=
ge_memory.h
> index 384e29f6bef0..bcdc57eea270 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -25,6 +25,7 @@
>         EM( SCAN_PAGE_LRU,              "page_not_in_lru")              \
>         EM( SCAN_PAGE_LOCK,             "page_locked")                  \
>         EM( SCAN_PAGE_ANON,             "page_not_anon")                \
> +       EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")                \
>         EM( SCAN_PAGE_COMPOUND,         "page_compound")                \
>         EM( SCAN_ANY_PROCESS,           "no_process_for_page")          \
>         EM( SCAN_VMA_NULL,              "vma_null")                     \
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 61e25cf5424b..e792e9074b48 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -46,6 +46,7 @@ enum scan_result {
>         SCAN_PAGE_LRU,
>         SCAN_PAGE_LOCK,
>         SCAN_PAGE_ANON,
> +       SCAN_PAGE_LAZYFREE,
>         SCAN_PAGE_COMPOUND,
>         SCAN_ANY_PROCESS,
>         SCAN_VMA_NULL,
> @@ -574,6 +575,12 @@ static enum scan_result __collapse_huge_page_isolate=
(struct vm_area_struct *vma,
>                 folio =3D page_folio(page);
>                 VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>
> +               if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) =
&&
> +                   folio_test_lazyfree(folio) && !pte_dirty(pteval)) {

I would prefer to add a comment about VM_DROPPABLE here
rather than only mentioning it in the changelog.

> +                       result =3D SCAN_PAGE_LAZYFREE;
> +                       goto out;
> +               }
> +
>                 /* See hpage_collapse_scan_pmd(). */
>                 if (folio_maybe_mapped_shared(folio)) {
>                         ++shared;
> @@ -1326,6 +1333,12 @@ static enum scan_result hpage_collapse_scan_pmd(st=
ruct mm_struct *mm,
>                 }
>                 folio =3D page_folio(page);
>
> +               if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) =
&&
> +                   folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
> +                       result =3D SCAN_PAGE_LAZYFREE;
> +                       goto out_unmap;
> +               }

As above.

> +
>                 if (!folio_test_anon(folio)) {
>                         result =3D SCAN_PAGE_ANON;
>                         goto out_unmap;
> --
> 2.51.0
>

Thanks
Barry

