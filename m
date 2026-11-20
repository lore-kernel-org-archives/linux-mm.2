Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD98B606A338
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 23:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q8Je0zrY
Received: by kanga.kvack.org (Postfix)
	id F269E6B05B2; Fri, 20 Nov 2026 18:40:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFDC16B05B3; Fri, 20 Nov 2026 18:40:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13D56B05B4; Fri, 20 Nov 2026 18:40:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0BE06B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:40:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CE451A025A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:40:29 +0000 (UTC)
X-FDA: 85457118978.05.2CE5EE7
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf31.hostedemail.com (Postfix) with ESMTP id 647BC20003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:40:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=q8Je0zrY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795218027;
	b=ocToPDE2krJXoxcngf6pM996zDX0MGvC62pEIMaXvC7iVjKJJ/cV3P6H97vg0su7arYWWB
	xOcaXqXnZHtPQSYKd4csmmepMwx9LE8O+Kga96/tr9BJu/AynYs2yjpE5s96yO4nVVvPDZ
	t8wmbi2qAL7gWGflL79OWVhFHwX978A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795218027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXsP6Kzw4Fd0TFm2S4Fc1qx6wAsu/iBIUZpt3s1NHMU=;
	b=d+QLG/fNN0K5pE9WMKrn0XYt4xY1IZexDo/sYxyBRkBshmwR40q7i2oJolJvad8jJO16Xk
	/L59//13Xudn2Bd7ONprIx2nozmg5V8r97plcvQu0o9fhzApn0Vt9/ELHsNFH5Z6JCejV/
	oidXxa9+hLviC4FqenAzoEBiMd4OQXU=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=q8Je0zrY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3adf9b1f5aeso24046211fa.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:40:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795218026; cv=none;
        d=google.com; s=arc-20260327;
        b=p0WpH1MH9U2t0IL42LmrEeUc93zuG04jR4ZlI6BmySXCvJo0qLXk2aXDvfFMGzFsep
         wLkOQuPyNyqRANoUbLydw2zJAsvOu5snG8NNB/5ZfQcEBml6R4pDUuVtzyLlMsBrap9O
         2Po4Swkesnm+BbY47ANdT9aCDP8YP6+CogvitzC1ton4YNo6i1perI4R8WekITNATYy+
         btWORyyMdDrxfJjsHL1lMtQ3aaxph6ShBW2QD20DLb8PDUJ9nsVs/wuRrMt+KE5l12N6
         p3SeRcHR21/93qUiIWh3aLpum8aVJbcEBlqfv+8Z1hVJmDkVzO9qwae+3j7WFr2IqzNy
         ZDNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VXsP6Kzw4Fd0TFm2S4Fc1qx6wAsu/iBIUZpt3s1NHMU=;
        fh=leHIoGjIK4/9ix+a+KqxER5LxRvOP6P1eJUoXxtrAWw=;
        b=ls9E7qSL5qr6/ghbtUlRWrCJhPgmXXYka6b9geTBuuVSa90NTfAdiEWUv0MmFOD4Ll
         Vu5Bq7UMsR5ys4TNMJ/tivD8/togUNH7gvdsa4K3ZdC635QWRK4ko9WJYNEn5lYyUsr0
         oy+lsDa+C68ny1zqomNpcNctFE85pKGxQdxcKmEU9YVVhnAkG7Kmz2LXYWDR/kjp44oZ
         az3ZUxXxwMCZFCX1PUrUfl2/1QCy67uF7UCLQwJEim8/Yg9KE5MKFFkxMslyLwGPC/lX
         m96xS2rdeYUBw/pH8D1wvSfA3B70y1UD9WdP43R5s19LkruMyuOUfM0BLXEVHK9i5ffe
         CukA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795218026; x=1795822826; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VXsP6Kzw4Fd0TFm2S4Fc1qx6wAsu/iBIUZpt3s1NHMU=;
        b=q8Je0zrY+88rXR4h9UXH7I29PIrPW2T4j+YmGK57ciRqmQBJciOFhiFisQH5BQgEIp
         zEf2f+8m+KQjoqbIAn/QyL8pCpLgQEFehBD7V6+S+RXY+tuJyjxgQLIW+gZtIjPZdUFV
         g5+28AtPxt1yR5hEauf0e/K3KxzySl0bPBIbpl+Uh31+BXpP+26QWjmwgGX3GSv1aPYt
         AiS92BPoYCSJHz6eCAlJ8x3kz9R9bvObs4+GKwjco+eFu0Y9cMcSntAPgbExL5UJHYRB
         m00GLwC4k++IV5Dh5/yDrQ7rGgTDau41VGjBJACCKx9sHw2xzf8blRVjOR8JQz2hxpZY
         ZVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795218026; x=1795822826;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VXsP6Kzw4Fd0TFm2S4Fc1qx6wAsu/iBIUZpt3s1NHMU=;
        b=xrDFOB+/I3DMNHZZ2FIu+rOwkGSKdIamDqQNpRC3wDDYo/IdwvqWcZpovEhbnT24PV
         Izv6xogI8brcEpgpkgpalD01saKzeLaAgn2u/QZeLrDOJAVKFKlx2Rvl2mjDHBCOPRcU
         4PEjoYViYMVHoYXXCtEOrjW1NMIsQEa4C07VmrwzV4ikWzKlwiZ63W+EwwEfqxgevdHj
         /m+IoNUzAHsURuz1vQ7pmAQfBAN9eyUMT/RrcSOyyYxsNu5Q/MGed/3JGMBWoHgDa/5c
         MMtqRwdKrF15UMZLHQyhLPo9ew+usimy8FcoKSf9896bfSONfHuOU834Xe5cf6HX4rHX
         nt7w==
X-Forwarded-Encrypted: i=1; AL+hErF0aLYK6E+JCPhLZkTsKwNKegwmlhn23ntdmS5wB8wcLVsLUyyd55x8hSGwQhttNXDSvTgxZkLc7g==@kvack.org
X-Gm-Message-State: APuU4Z//Jsksagijj8B9dZn7FATvkUPUqsYcNek+qcaWYUueIJ1A4Txi
	0cxXlKJvLQyGKCkHtf83DrMmA6/JyR+djWPIvkdHN72JCSFfoMIMtVMRN5EFePV0ugHkeLDCJ9Z
	2C+Nq3vH3ac4IgFKngjQChtjZJHOdXzM=
X-Gm-Gg: AZFdTZfkGFM2S1aOvFLl5z9/WZ4DcVj5Yetyc4jUvVb8MN618c2EIY7NKVqRm6wiq32
	qNLcvgJFYMSemwKdY6o2gcEMAGQXKcZ4cErurTP3loqpZTanlrzKxO+8EvVchoHs5ObigDJTLk2
	/dKP03uXeAZIK1xO6XzpMPrgMgIgGI+BMsYkLJka2AIFlN3TyWDw+YrbwDlLAe/ET/ftbWecFek
	lgoxSDGyaSItQiB0m6dZNd8O6pZ5eTe+ZXUfe5Zwp47rFfLMN01eJ6dFQ0rG6qnwhmW5PBO3Z8p
	rL1RHtLlwOZJfDvQ6cJUQi81pZ+Gy/cz7ZJvp1b5EsV/lLb5ZLbYcPbf+z6kEhHsJjC1YuZbWjM
	6sSKu9gFsYC5Q8FpkOkbnGYP3Q/fIhW7AmslXatpnJyftRy9EaMjxW5cywbo=
X-Received: by 2002:a2e:9fc2:0:b0:3ae:c43:d892 with SMTP id
 38308e7fff4ca-3ae7b71b82fmr14829431fa.1.1795218025362; Fri, 20 Nov 2026
 15:40:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-7-kanchanapsridhar2026@gmail.com> <CAKEwX=Ok9rom97s1GbrdJHNLqQTj-C=iieFHnbtUVY7skO0DGA@mail.gmail.com>
In-Reply-To: <CAKEwX=Ok9rom97s1GbrdJHNLqQTj-C=iieFHnbtUVY7skO0DGA@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 15:40:13 -0800
X-Gm-Features: Aa3M54osVsiYW3ZTm9lfCyqxR5ht3NZx9SXV3Yfo9go8drjU5olk5SDW1EIK3-g
Message-ID: <CACpmpocBaeKVVN7VSm7g4dN+TXoRC-ywjzJ2H2g39BQSp5pd2A@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] mm: zswap: Store large folios in batches.
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pkhsbios3r7ppdi5kgmb74tw3nmamjqt
X-Rspam-User:
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 647BC20003
X-HE-Tag: 1795218027-589935
X-HE-Meta: U2FsdGVkX1/c7jLC3VMHjV2bEVTd/+Req6z6ZlcA2mk/Gn2aKZAwywowvJNtEiwOTmabXHUa18ch7FiY5h1IsdeNA4W2+q+n5O1DpFQ4eGY3vhAOIjpDQiAjqVzqFW8B8slfCEQEv++l5+HjAafRtLmseNZfUC/tFnyk/OyeeqAZ+Tn7Kj2r08Lsbm9Dej/QbeHamlYV5t3KEICPn+XNT/5l7K7EcKZsk7nD4+po7Ju/60CEJS09UbBqR4bh6/0Oi8meESjvSYvGxG+lNuLM8VR8G0FtzNThMZeroMDEO59ph+O2x7Z0zJ3nOZbuI7DmS1bGzuJ2pfb+O9fyJLB9vvn+7Qx9SqcF4VzlhcvZLkQt7O1lKWJj3mnzzPsRjlNTkCV+lNpR1SwK0boYFQEbSgwbw5NYWGE7TQ6IFZomJDr5BPQAU1VW93z63iR2kw/uYHXB7ge0vtYe2HX/Qap4HTCRKcYcywNmK+Rnz8le7XNhNubH9Ioig71fIrXAvRk22u/klg8+PGSVcJPfKOs0GpSPyi0xW6dZCwHWpukKm+z/BCGzG+ti/jrwfNg0Hp4DYyz9mI6CaDdyCdecAr/HgHn+BT/rMFYtjBlHasMbcYxk4QBYmm/bKGlIape6wPzxl6cVbAX+rbU01tw4te02vb0kx17XrjfaiIpCP+6TmPmEE/HKshQAa1ZgxrvLFF4ReDXLMsxmGVmerTgD4fQ3o8lCk7C8jNKkJUhzzhxmT5iJ+zXSqIFZFVdk+Y3mBBNRTbWhp1bJwk1nW+eZ1h5WH8UUUYgY3Htp1WFZQYu+HJH+yoNaM27IpboTBHlWfdWQKsTQWI2VmL+/fahWDhV9i/5t4KDY0LAVgVWFJCtFKec5RSF9wBwqXKd8D5YBW5m9bPbxxTqay51EaMGh58x220h0vc7nBvq78rtgnrL8cXjRaEwuPM2G/gST0fpxWioV2nC7F7Y5K6nNwOKqfe+
 u0n0AzsR
 H1c5EDqaj2ntlA+4eN2IcZFCkRDshgMBEgQP/YB/H1gzSNXLOm/x0QH9z4BJAE2m3LP7EjiIEZyvuGFHzf3fGNrkHDWoUShsFdlhnIYyOcqQeOxnygli8e/2izPs1WvLuFMOQdwpfT8Z+MEgTcaKge9PWGUUg+VqqYkpS0cqbivomQALL28cf4IA4Exf6Qx/muWbjq4s8sqIYtIED2F4I19j4x427m2t0HGadlLDWwlEO8YQOMM1UQTdBMzDu0GanE8XAY2pkpv14XvveElg9cJGrMmtWuTyaBdX1cqYbO6tmRXwXZOPtYJlshPHl60FULEy5zGBJlrkw41471210zjEuwr0mwQ3gyySuJBpkGMVGsieT/So5lviJZ7cNiUk/xCFf4IyN396+SdERWbHmT/ZO/2a2KnHmFlOYUl8e+CsaIbU26yt9Jg56IcmdIxIY4LoeOiUU+Np9RfUnazck0h/UDqoGtl31zqMS2EERUtdvAGA3irVwltQk3Z8OTPUPfvmUyr89/EqVHPkjcKgeNRZ4nmgTi17La/pVTVtnuZZ13EIZGx8VzDvQQO8ENsh7tRts0FZkrmUIFNK4c6pOFD0GA+by3kYdevXH0yj0ihjaa4DYPZtfOFk9B8cfcQv81rHF17Dzz0pSTAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 3:08=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > Use batching when storing large folios in zswap. A new constant,
> > ZSWAP_MAX_BATCH_SIZE is defined as 4U to support processing batches of
> > up to 4 pages at a time while storing large folios. This commit
> > modifies the "store single page" approach to "store a batch of pages".
> >
> > As part of CPU onlining per-CPU acomp_ctx setup, ZSWAP_MAX_BATCH_SIZE
> > compression buffers are allocated to eventually be able to compress and
> > store ZSWAP_MAX_BATCH_SIZE pages. This happens in subsequent commits.
> >
> > For existing software compressors, the extra overhead is the
> > the extra 'buffers' pointer, 3 additional elements in 'buffers' and 3
> > additional 4K space per 'buffers[i]': in all ~12 KB per-CPU on
> > x86_64. Only the first buffer is currently used.
>
> It's not a lot but do we need multiple buffers here for all software
> compressors? Other than the hardware accelerated compressors,
> compression happens sequentially, no?

That's true, compression happens sequentially. However, multiple
buffers here helps software compressors because it allows the
"batch-centric" compute and lean working set concept, which results in
the sys time improvements (cache locality, fewer cache evictions).
Hence, I think multiple buffers here benefit latency.

>
>
> >
> > zswap_store_page() is replaced with zswap_store_pages(), which processe=
s
> > a batch of pages and allows for batching optimizations. For now, only
> > optimize allocating entries by using batch allocations from the slab
> > cache.
> >
> > Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
> > page and only call it once for the folio, since the entire folio is
> > charged to a single memcg. Similarly, obtain the nid once to use during
> > each batch store of a folio. To facilitate this, a "struct
> > zswap_store_context" is introduced to keep function parameter lists
> > concise.
>
> The wb_enabled stuff sounds like sth you can pull into its own patch?

Do you mean we should obtain wb_enabled status once and pass it to
zswap_store_page(), and factor this into a patch before patch 6 in
this series? Sure, I can do this.

>
> [...]
>
> > -       /*
> > -        * We may have had an existing entry that became stale when
> > -        * the folio was redirtied and now the new version is being
> > -        * swapped out. Get rid of the old.
> > -        */
> > -       if (old)
> > -               zswap_entry_free(old);
> > +       for (i =3D 0; i < zc->nr_pages; ++i) {
> > +               struct zswap_entry *old, *entry =3D zc->entries[i];
> > +
> > +               old =3D xa_store(swap_zswap_tree(entry->swpentry),
> > +                              swp_offset(entry->swpentry),
> > +                              entry, GFP_KERNEL);
>
> This range is guaranteed to be contiguous and always belong to the
> same zswap tree right? Why are we not using xas API here?
>
> (Or maybe we can do this as follow-up/in a different patch?)

Great point. I was looking into this based on your earlier comment,
and was studying the repercussions of obtaining the xa_lock once,
followed by __xa_store() or xas() API, but still needed to figure out
a few things, hence tabled this for a subsequent patch:

 - Impact on zswap loads from being locked out for significantly more
time, potentially causing page fault handling errors.
 - Impact of holding the xa_lock for 4 entries at a time during zswap
stores: would it result in errors due to the task blocked in an atomic
path.
 - Ascertaining if the assumption is true: contiguous range of offsets
is guaranteed to always belong to the same xarray.
 - Comprehend tree rebalancing with xas approach, would it change the
above assumption.

This seemed to require some more focus, and deserving of a patch of
its own. I agree, we should pursue this in a follow-up patch.

Thanks,
Kanchana

