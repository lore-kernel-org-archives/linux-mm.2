Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE1291061B1A
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 18:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F1C6B008C; Mon, 30 Mar 2026 14:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF71A6B0095; Mon, 30 Mar 2026 14:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33416B0096; Mon, 30 Mar 2026 14:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A44D36B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:32:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4043D59664
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:32:24 +0000 (UTC)
X-FDA: 84603574608.21.B02C32F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 516DBA0012
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:32:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NqwkCXBT;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774895542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7U8IN7wNWKroVVksH0qLml7e1xdOOXEyrhaS/+jQV0o=;
	b=mJdjE+juqKKJXohcKcsYJYNK1LqNdR9OZdMfajsWHwqm4sgZ0DQM0j9XLeZjSYoOu6fAq+
	lidAeflAt6Oc9upXJuzZrDEtorouIyWr1OXjrzWqpkh85clM4QA1DShGnHvwQhRgJLtmbX
	kbJ18suKuvozbP4r/2T/Yf7g8fcDZyg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NqwkCXBT;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774895542; a=rsa-sha256;
	cv=none;
	b=VNDWSbxo+IM0QgcN8pAQStbDlT/CeZFGW8e0Duzl3vo+fooyDruCLiQv2FML07vCBKnFTs
	3s3rPYAAxnOqPKzgUY8VmS5BDDkVArVPxBnEfE79LY/Y54RP9oCsMOG1UltOs6EHQgB8LL
	OSE15lve1s0WA6+4yixzwNTjw8G173Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 637AD600CB
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108DEC4AF09
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774895541;
	bh=7U8IN7wNWKroVVksH0qLml7e1xdOOXEyrhaS/+jQV0o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NqwkCXBTBuv+p9v2yhSRvIW7NTpOQK57WUnMHx8/jXyFAqTTlN9/t72xL3RFf8Rcp
	 Yy3Bmhzf4VwKi5/jsXKXANg8RuF2OpGZJLJ8LzEiIXL1jzESbv8j6XbQWPA/KpC+M4
	 AA+mvWcTFsh9gPlnGR1CdBE1NIaSQdqpsj+a/dXV/PiwA6tB4bk5hFRcEocwJ+zg2e
	 IqFIc4CeWvdqm4xva3YU1WqbAJOR75ZHLSOjsCAFWsDz7UFwc0siLH4wLdqFKSHOcV
	 1nZJDrpfaVWfmqPEIR0+FWVjNAK/nXuEln5BuMppg3sgZYg3xmVKhFEkP2M5jVjYVN
	 O02CII+6TqzXQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b8d7f22d405so743646566b.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:32:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWoBRMdFaS7SvgouAYShm4XtrBUTYyQ46c5x4MeFgSh/LMHqs99KRLih6hJlt+Z8TgRSAKk9wSagw==@kvack.org
X-Gm-Message-State: AOJu0YxhcC3uAw7h1WYnxs23M0pOkFIUxRT0NJ0o5EXU7LKyecvocBZh
	gUBlfpetvKcsepa17t0Ds85F1TEerJ8oUEaUYB/mOBJK9nJ9Sb2XKJluD2LiE951JOte75o9sUB
	A6MxtyEoq8l+t3jip+UCGGeFeYn6Mi2A=
X-Received: by 2002:a17:906:8d8d:b0:b9b:1b9e:e4c9 with SMTP id
 a640c23a62f3a-b9b5094517emr850819266b.48.1774895539751; Mon, 30 Mar 2026
 11:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
 <20260317014802.27591-3-kanchanapsridhar2026@gmail.com> <20260326192351.7fc8c27d87c60ab5f7de5395@linux-foundation.org>
 <CACpmpofW2hcmQ5srg=a_WT2fXNhvY0pp20rjxxL=n0jGGUEi2Q@mail.gmail.com>
In-Reply-To: <CACpmpofW2hcmQ5srg=a_WT2fXNhvY0pp20rjxxL=n0jGGUEi2Q@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 30 Mar 2026 11:32:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMSnRq02b68Tjf_yi+_Wg6TBgyM53gaxmfbXhXJ59Om6Q@mail.gmail.com>
X-Gm-Features: AQROBzCHwD3OfJxXspZczrUTdSkO5cz6USi_6cE0wWRiGGWQYjxEIrT-q5whFUQ
Message-ID: <CAO9r8zMSnRq02b68Tjf_yi+_Wg6TBgyM53gaxmfbXhXJ59Om6Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 516DBA0012
X-Stat-Signature: isu85sau8zx6kqu4jpoy9mtsxoceq4n6
X-Rspamd-Server: rspam06
X-HE-Tag: 1774895542-925965
X-HE-Meta: U2FsdGVkX19gdxtGA+ZoI5aMsLrpzK2i8KpsOS8mgLvzRK8ggw91bErmKclVtfHfiPkndALXVY6AQOfft5ebG8a4YvqW7evf6bi+YSTbHI4dqfl/m0b4nRUbwDQ7hVBZeyQKNTibp6B16zXzKs8CV+jxWCluG4C1hn1rqTWsTBRy+VmolaXQiF4Vzw08y5QXehXvtzbY4NOKp9ycNqF6NfeZoOpB06ZNNHhSXtZLoPMrWo4wgAlx1y/tBdrVbGIxC8crG8nllnaLRwqwRPrbE92ZEhgyfvic+xIEkeaZcFWgutoC0eNjQzhDydBun87BuF7NH6mTQUPDCoF9txGUe33J1fO/9WDl1HKOsnn47mNHnF0TYoFEMGYnQs+NlEmfM7H6ULOFPKYZ2uQ9WaNecZAR/lwv8rCbftykH3bzZsKI+V0oF5b/63t8IF/n8sLtf2els0n7IZN5hby7Sl4J5UMrUIHUPl738QIQm3HnMEBDn964sZ8GbVl0w5DPg7ZZ/ix2DdQUFiQJ4IYkHQw/AdMsFoytf0Gv0jkbuwstDAHy3q3lFlerHI5dzOz+cgg+INh+vUsmD763xGzRJC8O6C407SVIEr89P7K5NYDaz7rkwl7Fn2JLTd/HlGxPgNKA4EKost65Wrdu2S+IrhiLVG2XGqSPxNvyljL2XhvtUnXNMm++y52S2+8k7IirbL6jqWVJoLrzBG9UQ4lmTO6fOci42VnGtxMSpcjYcmZCwUR2QTMHpWGiNfTXwT0O9G1ufaBGs6PnbZfnqQ6EZTRDq64xiEL+byudXheCfngBK5vOs5hmkGuUWn3xAU8KJoRcdbm5RxfDOecRv1gMFIbkGpPCLJcC9rZ40KpFHV3Bg+ZOFj38Ew7M5mCZHZFNUFzA80tCK5dVGifVhDh9RIQY4IcsTTILkKFyIwbMT9fltQtN+R9kQSuoBK5YiNUCct5r/Kd8OJrUODlOi+lpP8W
 zC+Lkhxw
 sij6J9gE4e7i8Da//MWNqSxTGdbPzr6P+0CdJTmkrusUc+yXe4CW1EJKVKa7Po6o2OhljW2yUKaR1FHx4AwUuYakTvxu56BHhRsjRrkSfV6XtZ81PgORh+y7IMlhIeOXONvxKv6hMjFzjUBMdZOcx+g1ydumtqUmbULAiSXDFrr2vRA2AtFEa3Pg41jFBXmWxx8Ir3eM2JkEmXYD1wZ9KTBdlurCHx5gcau9SogMnd4eogFWrhZKonvlcouO5QryNsWjhrhPtJj40m9qLBydHAgGnsU/ljF2X2zCx4jp5wgxvG+Td+Bno7qVqfTn/X1sO2ndB04tI4WJG607e4V1wE2u9ZSdie+iyn6GXM2U+X/rAwizBIVoOVxTEOpAJCA5Yfy97eAC8YeQyol4JXd814X3pWk99EsXkhqWt7jXUst5LHN4mvphVbPlhVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 12:30=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Thu, Mar 26, 2026 at 7:23=E2=80=AFPM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Mon, 16 Mar 2026 18:48:02 -0700 "Kanchana P. Sridhar" <kanchanapsrid=
har2026@gmail.com> wrote:
> >
> > > Currently, per-CPU acomp_ctx are allocated on pool creation and/or CP=
U
> > > hotplug, and destroyed on pool destruction or CPU hotunplug. This
> > > complicates the lifetime management to save memory while a CPU is
> > > offlined, which is not very common.
> > >
> > > Simplify lifetime management by allocating per-CPU acomp_ctx once on
> > > pool creation (or CPU hotplug for CPUs onlined later), and keeping th=
em
> > > allocated until the pool is destroyed.
> > >
> > > ...
> > >
> >
> > This is a tricky-looking patch and I haven't yet recorded any reviews,
> > so could someone please dig in?
>
> Hi Andrew, Yosry,
>
> To provide some background, this patch [1] in my v14 patch-series was
> Acked-by Yosry, with a minor change requested [2] that is addressed by
> the current patch.
>
> Since Sashiko flagged the same issue as [2], I did not automatically
> carry forward the Acked-by.
> Yosry, can you please confirm if your Acked-by and comments in [2] are
> addressed in this current patch?

The patch looks good to me, feel free to add:

Acked-by: Yosry Ahmed <yosry@kernel.org>

That being said, it might be a good idea to resend the patches (new
version for rebase + Ack?) to get Sashiko to take a look, hopefully it
will be able to apply/review the patches this time.

