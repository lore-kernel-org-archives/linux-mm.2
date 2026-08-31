Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B142C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2B746B0099; Mon, 31 Aug 2026 11:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDBB96B009B; Mon, 31 Aug 2026 11:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF23E6B009D; Mon, 31 Aug 2026 11:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEB076B0099
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:26:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32D15A2D6A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:26:27 +0000 (UTC)
X-FDA: 85161941214.30.70A29FC
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3CEE940004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:26:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VeQXzN49;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788189985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKx4z/gVUVYo3h0sY7zCFMtg9vG2hgH7eEzaxSp487c=;
	b=scWgpjPOg0TswJHLgDfQA2jn/XM/38WBVZ6c3j7BIjVud7AJrHjI4HKTEEiKOIPtV5laPC
	oBiB/zX+1ANom5R7nQCEYoYLN4Frq5IDeEyVq1a/60dvk6GHsxT+67JXiKmXkdi2KAEIjB
	edoLF5KVI7tCelKpWUUGd2MM1m9thZM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788189985;
	b=BpwJ9MUkQ0cZuvG5HwWHB/HV3kemtWbJHGV95WoXWSnqGTVjrWhqTAzZW5OOpxC3G2Wl1e
	xkGlB4bOqhAtL1xHvFa584QQGiHGaccp+64/f1c+HMlmfalbo7352UsPgbhk0c7thXW0OL
	rZ7AYo59pYhR+NnbqhQ//lcM4i3LrX4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VeQXzN49;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-52fac937235so360131cf.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:26:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788189984; cv=none;
        d=google.com; s=arc-20260327;
        b=k6hJigaJsCDC3on7ci8PN428XR7BiE+T2QpLB8UBjUK4FQPHh9XT5KWKyx6/2yE4+1
         WigTA8+EMaFExVe/ZY/uGyhOHLYJIHJxLtAOjNui3ZY1ZH9tlX+ZM07Nt8mi9mDBg7o1
         bc1TOx0seDrU5JOVBr4V2AiIA+x4xb3viae0HvNGaKqRIctjZinEKWX1cECUJtuIS7hR
         6A/rqxWZU+3QAr72wqE8VPk7JmYf4wwcFUQdTSvgvXre/+pvElk6peYPHtGl17SMG/yU
         CTWav6wXqve0nTT4VZH4z0ESkNbCZKDTJNWyOxPrOVWupU0RAzkVGI9PLCoelFxTucdh
         oE3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HKx4z/gVUVYo3h0sY7zCFMtg9vG2hgH7eEzaxSp487c=;
        fh=Tdnl+yjcliujnai/QTQhvO/LnRrs2yHmpMe0Tj+G74Q=;
        b=H+Lyw+6fBBDxgws6VJNZHD6YTRYe5t2pGEDQ3962Nupwhi5qtk4eZSTUhOat9qx/VL
         Iqff4Ff7g0WYmul10ci7c4GpVpdycqLXnvtzZMZYSTUCRfxT0nk/K17nLwhRTP2W1fT5
         +1RW1EZ2Nkw3f79s8QXuJTnvWWoBSZVMldjBihDQkq92l6y24AmSKDbIWkovhlPc4yKL
         3t9Dy4Z5+sswShc7qzvWwIhsfkr4pNomFFPHMyGrAtLOWo6TujkMGOu0NAFn1phWOYy/
         cwFVaLEEfoXNQGrbpIPjzoT7I2Xe/evnHUualG+qmBnOih2gomFH/N8gUOCHJoyQv63/
         kqZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788189984; x=1788794784; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HKx4z/gVUVYo3h0sY7zCFMtg9vG2hgH7eEzaxSp487c=;
        b=VeQXzN49whTKfnEw7K2MCvY+fnSKqTGV5zTCUYrlmsgx3saH8YyexnglZ+LdJwNrhr
         MRoymvvLEurBH2kw/1liJQpAK5bCAiMuxh8aKmF3XYO+4rUrVB3BHmjDnUIEMbmol3EE
         6PHYuKMEH92ZMNeKb/9D2LdUWczfOhAs5WNnpceLY754GoL0e5eN4Tnu+H2WhVPIFgMP
         /uOtgGGXsjVowaDHdHyIiMq53+1WXTbzjv9e6L19HZg238g2H2P9p/18G6sNMKKLjD0d
         ICWB4DF05bzkI7OQaaa1Hc4LoUAei4fmzhDt1afnONu5cgYZz8hFL9OHT5UsEzGEcsNU
         bALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788189984; x=1788794784;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HKx4z/gVUVYo3h0sY7zCFMtg9vG2hgH7eEzaxSp487c=;
        b=PveMR0k8y2K5Nj7iInSwG9mKh+6Gg8G6czz0gV9iKziBVfc2ArthvEbSSWg6IxzAc/
         UgQLZd5ju2KYjCQJS9q/hamAVRAyl8j9OrSXa397kAJrVYTrtYjg5mHpAIXCYz9ZZxEc
         XpnWZydkzKkencgG1EXbA94Wkp0W4mtzsAPApuM1nF/JnHCtGdbkRBCzH4PeVy677vAb
         WhC+jtoJF/QgWiA06UoCmMdmXUASvh3gT2fz6wnT3/ve7So7Ccx5fOldwkJEfELuDajg
         PzSF5BqDXEQ+XmcC24BXZ2optaO28GvbDmFkxP9w10+dCnfEIazYpXJVTYTzGIWHuxdM
         9YhQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro96ESh2mvVt3go8/wYbK8UWzbiuUaWUdx2zI1HNdGvxZRhfKJF8ie/zaJrBjDSpCDHvSMdW1+aFA==@kvack.org
X-Gm-Message-State: AFuF++lkRF2AUxXgeENDqmyuJxloHLoNhWeu7N0r2wBcJQ8NsRhbhy1y
	SXjguGrlWPiFBl+MbeJcd01NWXoMJRI2nLjCMp0UJmEE9YxEIuc4WDLKb0Yr7vOJgRM8OZbknTQ
	IKs3Zk++3p51uGxCJ4aT4ZBbNIrimwQLNXdnKGElP
X-Gm-Gg: AR+sD119JqjUuVzf+VE98EfgVf5u95XI1q46Ab9w6V3Ef63WWnPWd8uNdsRM0/8ut6l
	GnMe6Se431qMDXrOXDJJL9YnXf3Pw3BTtUSRd5dRqhyqUAr9CIfB8ReyY4DKHcJgufJLil1pCVB
	B9GO3dgoJQQ6Eh6kbJbWl4lZ664qE43ZkeQbkfIm503f8VmXhv6dEwWghx0F37KbE9X/iRe5xy4
	4P9xCTQ7AYS1xRCbZ2rZnyFD9vR+wP0nZ5a37S7FaSvWA0nIOChCLZUJ2q1o1DEn0wV/qCRJE8a
	g4qclyfsN79so5q02fa8OHuzZt11Kj04K4DJJyzsEyA=
X-Received: by 2002:a05:622a:598e:b0:52d:7a3c:8396 with SMTP id
 d75a77b69052e-52ff6f30c8emr34733291cf.2.1788189983103; Mon, 31 Aug 2026
 08:26:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org> <20260831-docs-memalloc-guide-v1-1-547718c274c1@kernel.org>
In-Reply-To: <20260831-docs-memalloc-guide-v1-1-547718c274c1@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 31 Aug 2026 08:26:11 -0700
X-Gm-Features: AcwNN1WFRSN--wzS21rSGRH8C_o1FPRMTwmuGQ5Gza9KkI5iwhlrj79hsn8yfPE
Message-ID: <CAJuCfpGMOW89vVaAX_69MiMy+4VV0o-H+OBqkLRVUVHToM241g@mail.gmail.com>
Subject: Re: [PATCH 1/2] docs/core-api: memory-allocation: add
 k[mz]alloc_obj() and clarify kmalloc
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vlastimil Babka <vbabka@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3CEE940004
X-Stat-Signature: 9xny6wnuqbrnbixy6rbq431gn1a9fjcw
X-Rspam-User: 
X-HE-Tag: 1788189985-983827
X-HE-Meta: U2FsdGVkX18gux1ij+mgrbXBUhQNolLYvve8MPpZr3iAZOmyb2Ct8IrEoVdbCmiCvVfGtU6amSN464cpvAgn28zK6z86fYv6h0Fi7zJ4z5ncldjnnKs7KuHmI+jF0aYY5sRUSeQT52NRo3fWoriYsmEzL7zupcqjIhI88N8qA2wITRYLpC72yqvUEFr/lNetsiUylQzVfijDmU52wqCtJamh13SaZt+Jze504N2TLH0TR7k+wZQCOUVC/StKBexdJjVaexQtb0g1DquLW/kN75ecCahIjB0HLkachqDhdJKeJjRqRY6u4PRP710jFK1PGPWSLP2QlPPZzH4eVmsDQGhKJbeXy+uVFvXYIBLZQLBhxliXljd5/V49d+Z65qhjY97QSDbT2i53jm5eQOH060JsSGo12poWudaOudmr2m0xcYyIfjGNMnvW99u/kWVrSyzOrH2nIexp7pCEm2SVVkzue9aIDJwj9nvVxXDQvuKzfvl5C7wRd1skU7PgB4n1+0+Qbw7zIM2TFrhej+x1SAcshhu9IhMXDYtyIYzwdowGX9K/v7lV8w++t1VK99xraS0m0yula4tT9l6hPK7l5v5LrfLSRyzItOYFJoRvtel4fP+9DCxmDCTbMVo0WWSvklrVe8SJB1lmPu9Rl8Yf+v0DqblxRAfkTJnubOQOvP8su777g91sXpfKW2jWUJ1etuCBQjJYypaPfOB/H38i/YADc2EOBPL/LqhaHhgb2HiyY1eYHbKmX7OBoYCryTZfnTZ2qU8OhVQIi4J2U4BtsHaj6jmDMbBj9DXvX7Rr5hENnWWAhEp/dHAFq9kTwYKLnDQtz35J5uMjwiqW507aw5H4E1KWfnypU5YluadxyBO9NjV2BfpM+0Aum4K0IvpMwFPdIKhdiGciiZ9hXKqP3Fn4OWQEF00U9DJ8L95A/btq4grPKlYdkUBuTK1s/5r+VJXyomaqCOQsMEerMnN
 lxE3YQuD
 vyOLaePevTGngtX0TNwqYhyPqM7YOmr2Jsu1NmB55/tyxKPIn2BRtjEOCIoKRurLZPXNH3W0oPY1CZeyZcukFefy32rZjYDeSiPITzafBxZpMeA7p0H+FmUN7LlYEd+XL7ZowN0ofVLsm+Mt0HR41fHy/gXGx8DUs3SGvahd8/9uw7f9cMJUCMqQic9EekgzHJGzfM9dfdZ2FaO5vhPRPsZyYQxn8dCcbVmQZ5oMPOiLSn8qiHgA2El6wreueMP3/KGGFV2pYkACC4pyNCKuywfXUyhGnl++g7R6Al0HT6sOievb4pijG6VvAyw7y2WYe4Ns+HG+ax5qCCZk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 8:13=E2=80=AFAM Mike Rapoport (Microsoft)
<rppt@kernel.org> wrote:
>
> Since v7.0 the most used memory allocation function is kzalloc_obj().
>
> Update hte memory-allocation guide to describe k[mz]alloc_obj() family

s/hte/the

> and make kzalloc_obj() the first answer to "How should I allocate
> memory?" question.
>
> While on it, clarify description of kmalloc() size limitations.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  Documentation/core-api/memory-allocation.rst | 30 +++++++++++++++++++++-=
------
>  1 file changed, 23 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation=
/core-api/memory-allocation.rst
> index 0f19dd5243239..8ecfa4d35f4f5 100644
> --- a/Documentation/core-api/memory-allocation.rst
> +++ b/Documentation/core-api/memory-allocation.rst
> @@ -19,6 +19,12 @@ Diversity of the allocation APIs combined with the num=
erous GFP flags
>  makes the question "How should I allocate memory?" not that easy to
>  answer, although very likely you should use
>
> +::
> +
> +  kzalloc_obj(<VAR_OR_TYPE>);
> +
> +or
> +
>  ::
>
>    kzalloc(<size>, GFP_KERNEL);
> @@ -139,10 +145,13 @@ allocate memory for an array, there are kmalloc_arr=
ay() and kcalloc()
>  helpers. The helpers struct_size(), array_size() and array3_size() can
>  be used to safely calculate object sizes without overflowing.
>
> -The maximal size of a chunk that can be allocated with `kmalloc` is
> -limited. The actual limit depends on the hardware and the kernel
> -configuration, but it is a good practice to use `kmalloc` for objects
> -smaller than page size.
> +Since 7.0 there are type aware kmalloc-family helpers that let you safel=
y and
> +conveniently allocate a single object or arrays of objects with kzalloc_=
obj()
> +and kmalloc_obj() and their array versions kzalloc_objs() and
> +kmalloc_objs(). These helpers only need the type of the object that shou=
ld be
> +allocated and the count of elements in the array for the array versions.
> +
> +As of v7.2, vast majority of the memory allocations use kzalloc_obj().
>
>  The address of a chunk allocated with `kmalloc` is aligned to at least
>  ARCH_KMALLOC_MINALIGN bytes. For sizes which are a power of two, the
> @@ -154,9 +163,16 @@ Chunks allocated with kmalloc() can be resized with =
krealloc(). Similarly
>  to kmalloc_array(): a helper for resizing arrays is provided in the form=
 of
>  krealloc_array().
>
> -For large allocations you can use vmalloc() and vzalloc(), or directly
> -request pages from the page allocator. The memory allocated by `vmalloc`
> -and related functions is not physically contiguous.
> +`kmalloc` always allocates physically contiguous memory and the maximal =
size of
> +a chunk that can be allocated with `kmalloc` is limited by `MAX_ORDER`, =
the
> +same limit also applies to the page allocator.
> +
> +Internally, slab allocator differentiates allocations of different order=
s and
> +delegates larger allocations to the page allocator, but for the users of
> +`kmalloc` family it is entirely transparent.
> +
> +For large allocations that do not require physically contiguous memory y=
ou can
> +use vmalloc() and vzalloc() family.
>
>  If you are not sure whether the allocation size is too large for
>  `kmalloc`, it is possible to use kvmalloc() and its derivatives. It will
>
> --
> 2.53.0
>

