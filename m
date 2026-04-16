Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE227F8D765
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B0D6B00BB; Thu, 16 Apr 2026 14:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13BD86B00BD; Thu, 16 Apr 2026 14:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A8D6B00BE; Thu, 16 Apr 2026 14:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E31676B00BB
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:47:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 884F213BEB1
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:47:24 +0000 (UTC)
X-FDA: 84665302008.11.382145C
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 81B2BC000F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:47:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rV66+YHX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776365242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fV2yQdpPdBSM0JKi/3hIXKAc4W3UmbJU7CKjv7sEIcs=;
	b=zM9Zxvuydc9nPnpy4STTBaRMzBOWNyTPxU2+rzNCz8gW67a1tqg9Kqf+hVu8qCwVrt9PQf
	IcOdKmvHiYDBx2dQ0AAuUrsfqSXRqmb0y8asPBA+Jc2pJduFK7ucwluWTKaHdorRPLTPUu
	reNphFOavogeLdjG7SwXexT8LLy0T5k=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rV66+YHX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776365242; a=rsa-sha256;
	cv=pass;
	b=A7vzJy+5NTpaM9UM9hWxUNBwIYHSoHTcIMBNPvds9mignthhP/y9fLSC+ZMBRLlXxykWxR
	Apd8LXvPgORMMY0ycKYnnb5CoDNy/1ra9+THuZvIkeGxwT5bfg8nY/NtUoFYxmImdn8Vh3
	v+WbRr6kiG8rUNdlSiz8PGyKSCoNADY=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-66ba9dfe83bso10962222a12.3
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:47:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776365241; cv=none;
        d=google.com; s=arc-20240605;
        b=Asn+AMNj+Hv3Sn+8eU1jx0kjVpNoPW7HFXFmijkSuehGuB20Uvsu3WkxJO4ZfANjIp
         rKQFkNRwlEw/KBTMPs1CM6DnzZ9jRdrGuii9EjZPBWSK9hMLLl5PulqbR2U2uyDwYAQh
         /h6g6SOEYFwhcuaBPq8wO5x7BlvnqrUjzSkXtN+fwnKMZImyk1O27oLleLCfUxpXWW0N
         s+BeQ8pBFkemOqANe8EZuXPqnBXBGTQd04+ybVCaTKvU+g5Hi4Tg1+rR5wcfzCfedC+/
         cyycmFyCarQAJUxTo6Xq1jfcmDEM/M+XrWF2nlGiwyqD1VEI7I2OSXqVXDbcl/QAAIEF
         0khQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fV2yQdpPdBSM0JKi/3hIXKAc4W3UmbJU7CKjv7sEIcs=;
        fh=o+vgyOY2D9A+JKzp9bwJwtBgLUl0UGjc04U1iAkY+Cs=;
        b=itUXuo/AqyD50VbsOhj1ramAtfdnVKzQUEa1ncZJM4VX7LW0toRNgxDrPunSGEdjmL
         vhW9HPnZlSE+iyAID5SvRNGCapj0OHfA2aCCdCJsN/P4KpM/y/PT0p0EdwBm3w6hcGeU
         +Rh/kjqeQh+IrxbFoWwpiECKYVxGX9M1qrMbkGfVH1H3EvqjnqaU3H5UyAiHxRfKyPRW
         a09Xa+AcZFWz1V/3mvkQDVFz7wibJ5fYg8LqHejWyKGDKvm6BIdV3saQoXJ4E/naE2Zj
         injtdBHqFKO8g7yF3d2XzSCYExam9vPA+1r77k/WXDFT1IdAaeWChMkjU3fCiByAafdz
         WXtg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776365241; x=1776970041; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fV2yQdpPdBSM0JKi/3hIXKAc4W3UmbJU7CKjv7sEIcs=;
        b=rV66+YHXPvwBKm0oqNQOgkFFhYi1PwoBQop7bvBltvvmOY9oglU0dMgyOZJQ8ByqmX
         lbNV8XRJfcGWFP9WX+8rdo94nznEWp4LFkwrTUn/oiv+vzZs2ZzuAovjZzqAxJZq2MPl
         TFb/tyawfyXVxeSjFpej8eqTDQ74laDlqNjqg8qogUDQ+RqMDbaT+sHk9lGdS4Bw40sf
         9W2w+bOaFdsH0hEZGQv1ya7tH3XMpQ+UJdFY3VKFZfix/UNhtwpDUJ0Ayli4VV7AVUtV
         8QtXsd8cu2SXRgzt2owkqMj+1rhYMQ5DnqKXr1r17SX05LURdmw+gw8mKWMzBqolrgr3
         a7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776365241; x=1776970041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fV2yQdpPdBSM0JKi/3hIXKAc4W3UmbJU7CKjv7sEIcs=;
        b=R32jFL9Cf4ZNe14hdFH89SMm/4uPm5fh0eSTZKu4Xek+JULGKsPrwzaPoGVUOMg9IE
         bvam1VDkBgcLW9CViWU2CTtiqz2/Woqjq+Jl+1hOJ6cU0WlurR+GFf0/z1lea/6Hu4FC
         HOcD4GcY4qKa8IiQeHceb20uNHYCbOk9CanMR+Zw10ZiZ6nukLx+8DXSUfWU5Yjlyqcl
         Sj24UCzYlTmt/7RvPZRcSHdDvV4ABBpKWeDWKo2D2JI91t2ga4Lny6L86mhiEddmgTFz
         sA++Yr7yBz/LHxhtNBPfDKFZja0I3SulkoJWc0o5SfzbfL/ha7bz1Uo1dugCwDzDq/qa
         Zv4g==
X-Forwarded-Encrypted: i=1; AFNElJ+wNTOLV15/ce5b06ZgW9+WWSvHhJ+GDwRR1WoEWAFFm8Jm5YKaDAZgj6IUS+52P6Cl7uvktzwh6A==@kvack.org
X-Gm-Message-State: AOJu0YxW/KA+EOx8gupnmLxbnW8XeAdbQw8KEb/h2Lx4BhcKVIfs3KcA
	3+it+ymtAjt+798I0LYhbOvbMiAsfH+wUFgRCAnCYPmqroZg5MS4KhOaGUDj0QI5ftiGIa5kjJS
	fFCbpq8+bz2ENLa8AsNFMYy32C6KWgcs=
X-Gm-Gg: AeBDiesbvu/tPHqfCBcfk7yWex2pE5WPtfNx+IVrE40cPxUBf/nu5XYYPK8trSQ5GKI
	yDRx2gSQ8toYOv1a+qI9P40vK41eqRbxkzK+fQjC8zw4wIBZhapX+ZWpm0430xMI7qaKCTb+IfO
	+yWj26NkcIqppO8MsRZrSaHKaLP2b+r1jIBrrQybjSC79fwquP/sRPk02ZpihWlD+Du73/TNJPm
	DO2hfR7GMYN2Rw0gB00Zt7vEfM1oIrqARNT7kKTnp6CqJ2EepNf/+mNbMpdO38qX+Ih8Eh8ZAGi
	WH6bcUWdGpIqpRay+TKHoMKBKu3D6GynjxwJALshMgSTib+GUSQ=
X-Received: by 2002:a05:6402:3513:b0:670:8b30:a8a7 with SMTP id
 4fb4d7f45d1cf-672bd216aefmr183464a12.0.1776365240497; Thu, 16 Apr 2026
 11:47:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <CAMgjq7AiUr_Ntj51qoqvV+=XbEATjr7S4MH+rgD32T5pHfF7mg@mail.gmail.com>
 <CAKEwX=PBjMVfMvKkNfqbgiw7o10NFyZBSB62ODzsqogv-WDYKQ@mail.gmail.com>
 <CAMgjq7AzySv801qDxfc8mEkEsFDv4P=_qw0rNOTe0n+qy7Fz6A@mail.gmail.com>
 <CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com> <CAKEwX=NrUhUrAFx+8BYJEfaVKpCm-H9JhBzYSrqOQb-NW7QRug@mail.gmail.com>
In-Reply-To: <CAKEwX=NrUhUrAFx+8BYJEfaVKpCm-H9JhBzYSrqOQb-NW7QRug@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 17 Apr 2026 02:46:42 +0800
X-Gm-Features: AQROBzCEgUiZi2O6FzTs1ms_GwJiz6hkD3Or1x7kVqF5Vc65bqWpNQK9z7Fsc8M
Message-ID: <CAMgjq7DJrtE-jARik849kCufd0qNnZQs7C8fcyzVOKE14-O+Dw@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Nhat Pham <nphamcs@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 81B2BC000F
X-Stat-Signature: 8qofgwkkbe936ogo3ac7pphhz1c1whij
X-HE-Tag: 1776365242-322122
X-HE-Meta: U2FsdGVkX1/FoIn7ApLmb3jujjZd85zLnthGYtQv06obVWCeE6IYUADE9ByeiLemUc2H+UR70THrJIrhQdLO99gsUs3aa3uD2CeU6L6jZG5QLZAyoyiGPCpES4wGj12065dtK8+7kelxJ0Kn0Qj+t9Ikkc5iexqzh3OmalGInqygJoDYYi53yHO4owzps2Wht27X+vHMQE/Vz+Jd5dDmHbaheVWJKjDFe54WT7178liCRMRVUf1PblJB01pO1vKXSK1tWfdZ9ZvkMnPGB+pJzunRAV9EYwLpDRLTQNmRMX030tQcXhFwctjU5qRAwKC1OyyZuw2Tx/dYtFNCS9K/6f9GiabsWs4SrBi+lUI4C85PAuDgKMCptgqHgXQ2rhNmyWnZhucoQRj9hLdm5Es0O37Rya5hyX/r9zUeJBZ6hjoTRA/5V/jFZWfAIFKbnT4yuQqdlLrIeEmBU7kXAwhT37oZcaI7Zgv0eMN79pn2kcZmoJ4aIun2SZp8hjhn2qNS8HR9R8+ydZtdwJe6ldO9L/8qJx2FHh/L+zvoYNJtFsFUC8Ljg0Q5hIWYN86YNLBOZPztQgNDEprI/5Yk2Bvw5J19HtFiUN1Zbu/nU9eJIYwlCvqIi+fGlMkv7n26aDvz4XA55zhplfFc6jhHHlDZqIyDSR75QguDwwbdtunxJ1oQ7dT6jA0P8l/tX16Q95tyX4f0a2ZPL1Qz0IDyK/uREupt6FxzKKb5CHqelJnKJotswI9VM2rIGZORG5uhLrZ+OVJeJ+wqqPxjCYE1opgJKfWwDkba6gT0dCfQSMAABK9KvQTbgxTVe+EP97651MALqr/Sh7Ixk7nzxif84wyeRovqPIVbUJpVOb3gLbg10MFw6LPaw/XAucil1BItqx2y3+lcXXh4d06QESfsUP6ZaVs59CIQq1f0HkZ3NVOwdnDXrkGyFagAPVJTRtMVZgTcEbasBCSbB4ByfXEDpF4
 Y9YOuWtB
 5xkbAdMZDb8bjySo+L4nKVukdvKcQT2ZVYEDEh17KVtBsfeg2jIoLVZ8fhNDJ0lCsaDTgX3vuCcScmhViNljgMyhTAtAmusEbecDa6NnRml7w1G+Ow0KTWmeqG62WRit6equ9F4zyJLKhua322doQy30//sc5bSqqPH6N6wdVY4+1ZfeOlMgWBtZ+FlVn9jgX2zO+bg6FL7gTxbxNUHJUXeKU9rPzF7haB0gJEtnXWJNcBJnSrJqqq48z5su7AVHbf1Ssei2QhQxnGT/YAt4qGNKD5/jVU5Lp4aIQ97r5vDGf8g4tC4sLNG9eL/ipnHzsl5MlQ3gL+KyE1IkpesouC0xelhGPykMExA66LMCNnHmu8E6ONHb10FVxSKO2cb+CI0bgZwvQNMeemPRfzAqU2N99pj1djjQUk0Twkae68mXHDUcB2XFz/BAsRK+HZeS5484wArD3lKNuQnFEk7SJ39ZN3Xz9Fvgw03Vtmex+DHKbJJFJXqw1Q8mc3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 1:23=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
> Hi Kairui,
>
> My apologies if I missed your response, but could you share with me
> your full benchmark suite? It would be hugely useful, not just for
> this series, but for all swap contributions in the future :) We should
> do as much homework ourselves as possible :P
>
> And apologies for the delayed response. I kept having to back and
> forth between regression investigating, and figuring out what was
> going on with the build setups (I missed some of the CONFIGs you had
> originally), reducing variance on hosts, etc.
>

Hello Nhat!

No worries, I was also thinking about submitting some in tree test for
that so testing will be easier, but got really busy with some other
issues, series and the incommong LSFMM, will find some time to do
that.

>
> 1. Kswapd is slower on the vswap side, which shifts work towards
> direct reclaim, and makes compaction have to run harder (which has a
> weird contention through zsmalloc - I can expand further, but this is
> not vswap-specific, just exacerbated by slower kswapd).

It might be related, e.g. could the dynamic alloc and RCU free of
vswap data cause more fragmentation hence more pressure?

> 2. Higher swap readahead (albeit with higher hit rate) - this is more
> of an artifact of the fact that zero swap pages are no longer backed
> by zram swapfile, which skipped readahead in certain paths. We can
> ignore this for now, but worth assessing this for fast swap backends
> in general (zero swap pages, zswap, so on and so forth).

Hmm... That just brought up another question, you can't tell the
backend type or properly do readahead until you look down through the
virtual layer I guess?

> I spent sometimes perf-ing kswapd, and hack the usemem binary a bit so
> that I can perf the free stage of usemem separately. Most of the
> vswap-specific overhead lies in the xarray lookups. Some big offenders
> on top of my mind:
>
> 1. Right now, in the physical swap allocator, whenever we have an
> allocated slot in the range we're checking, we check if that slot is
> swap-cache-only (i.e no swap count), and if so we try to free it (if
> swapfile is almost full etc.). This check is cheap if all swap entry
> metadata live in physical swap layer only, but more expensive when you
> have to go through another layer of indirection :)
>
> I fixed that by just taking one bit in the reverse map to track
> swap-cache-only state, which eliminates this without extra space
> overhead (on top of the existing design).

Isn't that HAS_CACHE :) ?

> 2. On the free path, in swap_pte_batch(), we check cgroup to make sure
> that the range we pass to free_swap_and_cache_nr() belongs to the same
> cgroup, which has a per-PTE overhead for going to the vswap layer. We

This might be helpful:
https://lore.kernel.org/linux-mm/20260417-swap-table-p4-v2-8-17f5d1015428@t=
encent.com/

I observed a similar but much smaller issue with the current swap too.
Deferring the cgroup lookup to the swap-cache layer, where we already
grab the cluster (in a later commit), should reduce a lot of overhead.
It requires some unification of allocation though as shown in that
series, things will be much easier after that :)

> Anyway, still a small gap. The next idea that I have is inspired by
> TLB, which cache virtual->physical memory address translation. I added

I think this is getting over complex... You got a mandatory virtual
layer, which already comes with some cluster cache inside, and the
lower physical allocator has its own cluster cache, and then a new set
of cache on top of the virtual layer?

>
> Some final remarks:
> * I still think there's a good chance we can *significantly* close the
> gap overall between a design with virtual swap and a design without.
> It's a bit premature to commit to a vswap-optional route (which to be
> completely honest I'm still not confident is possible to satisfy all
> of our requirements).
>
> * Regardless of the direction we take, these are all pitfalls that
> will be problematic for virtual swap design, and more generally some
> of them will affect any dynamic swap design (which has to go through
> some sort of indirection or a dynamic data structure like xarray that
> will induce some amount of lookup overhead). I hope my work here can
> be useful in this sense too, outside of this specific vswap direction
> :)

Glad to know things are getting better! We can definitely work
something out. But besides the problem above, I think there are some
other concerns that need to be solved too. Good part is I think
everyone agrees that some kind of intermediate layer is needed.

