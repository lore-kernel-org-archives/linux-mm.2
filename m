Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A9CCA9EBE
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 17:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807306B008A; Fri,  9 Oct 2026 13:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B76C6B008C; Fri,  9 Oct 2026 13:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6FB6B0092; Fri,  9 Oct 2026 13:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45AC66B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:29:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56967804A0
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:28:57 +0000 (UTC)
X-FDA: 85303773114.03.58E3BEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 71AA94000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:28:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AjGzRXCB;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791566935;
	b=3SgAT1oXMDPXS28VIhGrV+uqdGsEcgSeMoTJnWIHDJWv4iOseLRFntPOCN1kE9xdWTA2to
	Dww+WM6p21y/S2nqNgSeSgON+QUhWtBO7eldewMorVsgf2/iPcDFrJqGRZpZNIIpojf+n1
	eeLrwBk9QbyFJ4Dc/6PSelntHds8pSk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AjGzRXCB;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791566935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQ1+vi+vdsZ99qDKhf+JpCWijkqBaMTbgUW8v/FAGik=;
	b=jEvGUWLIHl5LH2YnQd1+hVeP+P5v6kya9/pU1BaApjYcRhtClyyvpOya4KWvVpq2psCV4F
	x9EfCK90GVtlc0DitK2UHRvpICphFEBSAUAiZhhCpVysnPyoGfeeQ82TI/jOhwMoEz9Xsa
	g2oPOt7iXmsCP/RXmSfqQtWL0bw5rqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FADD60DA8
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8451F008A0
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791566934;
	bh=GQ1+vi+vdsZ99qDKhf+JpCWijkqBaMTbgUW8v/FAGik=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AjGzRXCBiIJZ0fhtb2/1CNulUjXjnTDvnthvDq1VL2KZuRdN/DX9OG9YewnGQk5po
	 ByCxdZBfRjeBhg32rFTHM5KRuPhLz66f9FbKfEJ1CiBM/1Aj5jBnsYQ8Au+cJjq0kU
	 tri1wFANAAV0t72+edO9jthntXUxHT+eyDCsk7eizqRsTf4uoNB8LGpfNOv4syIRbR
	 OpBfjHLBZwPWS30HMGFH+X8myvR90MyW3aIqboeNgVwC1G23JMPeDaYs4q5h5JAoN6
	 4VbXUZZWbyCRT+MGL1vfTtdwQ1sGTgAO+PJcP7jFwDTe535vZfLYUvt4C6voLFAHem
	 /jx7sYVjroO9g==
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5339173489eso51311291cf.3
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 10:28:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxRktiWO3Jb6WBJua935MbFGYgrvLd8eDvmBm5MMSlAKrxM5QlVygqjzxvYoGdBQMz6XPMDCz8PXA==@kvack.org
X-Gm-Message-State: AFuF++k0kokZrVD+2a2+N42+skXbBNAeMw2AYNBS6EmIHHFBosNHmlOx
	uDQa6ASdUujM98mEidR30mKKFFdsNB97wS6FMgd4WvB1f7C8guo593APnt9FxaSte6k8qWYEZ4n
	xNmFUR/Jtt2r0c7a4C01+OsPAJ3YFNXs=
X-Received: by 2002:a05:620a:a2cf:10b0:93e:c12c:f142 with SMTP id
 af79cd13be357-93ec12d0865mr231402285a.76.1791566933524; Fri, 09 Oct 2026
 10:28:53 -0700 (PDT)
MIME-Version: 1.0
References: <20261006002307.2669023-1-usama.arif@linux.dev>
 <20261006002307.2669023-3-usama.arif@linux.dev> <CAO9r8zMFm+JsboodgkG-jdQ9eTk+JHo=d-3Dw8PUcEqjr3+xVg@mail.gmail.com>
 <b887f721-124c-49ce-8b5b-c1edf0c24e40@linux.dev>
In-Reply-To: <b887f721-124c-49ce-8b5b-c1edf0c24e40@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 9 Oct 2026 10:28:40 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOukk0p1BS=1qSvmi+Sxp+1zLUAxGMEHoyHepEb+tyd4A@mail.gmail.com>
X-Gm-Features: AclHuK86qX40IDYr0hsGsWtxtfNvpNDkIvmBi0TCgMzngiR8Ajf-TDMhH84pAzE
Message-ID: <CAO9r8zOukk0p1BS=1qSvmi+Sxp+1zLUAxGMEHoyHepEb+tyd4A@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: zswap: use stack requests for synchronous decompression
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, terrelln@fb.com, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: f8ojbex4ncbh3xodnf1xebd7cmdfzrzd
X-Rspamd-Queue-Id: 71AA94000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791566935-206142
X-HE-Meta: U2FsdGVkX1/aaodF7SPrarFdkFQZ7uCr1FdLwWJsppBIZAgQE5DmmIqXl0VUTkNaH9PbxUli1DfUdDTy+LuK4xOXFoJ67zLHZ32McKnF3vzz69k4u3O4AludK8S/BowvoUlmjzvWPWRuPY4lwRRL6Qw7ZTrMy1NqJjSD4vImTdP3VOTtP6u+1Yuuk1igcny4pw6tf3r/1SfdIw+uF6XJwTE76HYdq/wriknHDXX1zCLoJ8LFkTImZzVkbAyXLoCqUK7w9Uhv8GTxSlHYxgERZ/21PDAl/V51Moycr2ShgyzayqPy9GIK3lvfekiHOCcCO0BY09/ZxfPhGi4OML2lzvTvP9jZ7+h+dnNVY/uv9XV+4j5kAhZcqS8cn3FK9wQSBbNRTe2ijF88NVulGcwL1F47ScTsysawa5x5jonuQasDL6lcQ1N85L0yOqHiSgmCbYaO5/U84B/CVXPgaNT0Ygqwk4M0t974T2aim7dEqEE8Zsu1fT474+6OXnVffUMlQYl52jasIc1tq+PhkLKi8IdSJD+b43Wbl0Qxb7Mml9CFI4otAxx334n8kXHJao4CGA7iGjmk3dOUwIxYXCBtUgQFkiTogZWXKy14x23bylY1lQaPOG26x0QXsIlj+tJ3npPU2Ii7fLUWH4CxOXTruQX9G5sYDm477mqd9fA4t9f+pLt4G/qcnjOyF+O/Mb31ATbwD9O3oKctt+BoUZPKvVyYaEI1SqeHkI8LLi8sGQOfLgq7Tbuy7UkliWiOdjhL2FdwH+cQt7h6WXumiHszbMdyn/bNrlAMlOZaLI6dXiCHl4CAzThSEL4Q9OVky4oedvlcID+Ks5Lrr0NmNQ5Me9d+tY07UQKkksJu4gkeo6a5Z0b4oAnlsh5tFrfju6dX/Sxw2p/sPbMnF51lekwgildFT0vYfNGukukMLc/Ht7Y9f233+v0JDp+qOyAMnCqex2RtDqqdcob/KGEeyzg
 z8UFrc2X
 bptK+yGN1lRm6US+YHXynGxKkYoEUvb1NH+USO+ArcdqJfgGKfWagnCUSfNpdJqG7SVG92hKBzZhbDIS4s80Njq/ohxtuWbuQ11uHjmgyynj/hBsIE3D7BtIQD6PvKpzoBVCCIdWpxUSxQfThStvP4/TmvMif3mPncpDOfzKWX3tRboQN3/H44d9d2MmFeKclhWJAuLUo2Ns6zyyB3V9zxCyxtyrDAbA2HFHdrDJV9Q7iaZM8RRKp+fYeJFry+P+0TTqLDs1eumRYlbNZYKU2g4ecmVyWxL9Lzye0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 9, 2026 at 8:27=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
>
>
> On 07/10/2026 23:28, Yosry Ahmed wrote:
> > On Mon, Oct 5, 2026 at 5:23=E2=80=AFPM Usama Arif <usama.arif@linux.dev=
> wrote:
> >>
> >> With separate requests for compression and decompression, loads still
> >> serialize on the per-CPU decompression mutex. A low-priority load that
> >> is preempted after the codec drops its stream lock keeps holding the m=
utex
> >> and stalls every other load on that CPU, including higher-priority one=
s.
> >>
> >> Synchronous algorithms whose requests need no extra context can use an
> >> on-stack request, so decompress with one and take no zswap lock. All
> >> in-tree software compressors qualify. Asynchronous algorithms, and
> >> synchronous ones with request context, keep the per-CPU request and
> >> mutex, which is still taken before the zsmalloc read lock.
> >>
> >> Reading the per-CPU context without the mutex is safe. Since
> >> commit ef3c0f6cb798e ("mm: zswap: tie per-CPU acomp_ctx lifetime to th=
e
> >> pool"), it is set up before its CPU comes online and is not torn down
> >> until the pool is destroyed. The codecs keep their own stream locks, a=
nd
> >> crypto_acomp_decompress() rejects on-stack requests only for
> >> asynchronous transforms, which never take this path.
> >>
> >> For software compressors this drops the heap request added by the
> >> previous patch. The on-stack request and wait take 216 bytes, which
> >> makes the load path about 270 bytes deeper on x86-64. Asynchronous
> >> algorithms pay this too.
> >>
> >> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >> ---
> >>  mm/zswap.c | 65 +++++++++++++++++++++++++++++++++++++----------------=
-
> >>  1 file changed, 45 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/mm/zswap.c b/mm/zswap.c
> >> index 54187b1ef751d..7e7fb6e7ec24c 100644
> >> --- a/mm/zswap.c
> >> +++ b/mm/zswap.c
> >> @@ -147,7 +147,7 @@ struct zswap_acomp_req {
> >>  struct crypto_acomp_ctx {
> >>         struct crypto_acomp *acomp;
> >>         struct zswap_acomp_req comp;
> >> -       struct zswap_acomp_req decomp;
> >> +       struct zswap_acomp_req decomp;  /* unused by synchronous algor=
ithms */
> >>         u8 *buffer;
> >>  };
> >>
> >> @@ -851,15 +851,20 @@ static int zswap_cpu_comp_prepare(unsigned int c=
pu, struct hlist_node *node)
> >>                 goto fail;
> >>         }
> >>
> >> -       if (zswap_acomp_req_init(&acomp_ctx->comp, acomp_ctx->acomp) |=
|
> >> -           zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)=
) {
> >> -               pr_err("could not alloc crypto acomp_request %s\n",
> >> -                      pool->tfm_name);
> >> -               goto fail;
> >> +       if (zswap_acomp_req_init(&acomp_ctx->comp, acomp_ctx->acomp))
> >> +               goto req_fail;
> >> +
> >> +       /* Synchronous algorithms decompress with an on-stack request.=
 */
> >> +       if (acomp_is_async(acomp_ctx->acomp) ||
> >> +           crypto_acomp_reqsize(acomp_ctx->acomp) > MAX_SYNC_COMP_REQ=
SIZE) {
> >
> > Where does the requirement on crypto_acomp_reqsize() come from? I see
> > crypto_acomp_compress() and crypto_acomp_decompress() only checking
> > acomp_is_async().
>
> ACOMP_REQUEST_ON_STACK() reserves sizeof(struct acomp_req) plus
> MAX_SYNC_COMP_REQSIZE, which is currently zero. A synchronous acomp
> algorithm can advertise a larger request context via cra_reqsize. Checkin=
g
> only acomp_is_async() would then leave that context outside the reserved
> stack storage.
>
> The core already applies the same size restriction to synchronous fallbac=
k
> transforms in crypto_acomp_init_tfm(). The operation functions only rejec=
t
> asynchronous stack requests; they do not validate the amount of storage
> provided.
>
> >
> > Regardless, these are crypto-specific details that shouldn't be
> > checked directly by zswap. Ideally we'd have something like
> > acomp_can_use_stack_req() or something.
> >
>
> Done for v2. Added documented acomp_can_use_stack_req() in the public aco=
mp
> header. It checks both synchronous completion and request-context size;
> zswap now uses that helper.

Thanks!

>
>
> > Also, could you please CC Herbert on future iterations? I would like
> > to get his eyes on any crypto-related changes if possible.
>
> Will do! Thanks! get_maintainers.pl didnt add him.

Yeah because it didn't actually change crypto files, but I usually
prefer someone who actually understands crypto (aka not me) to take a
look :P

[..]
>
> >
> >
> >> +               return __zswap_decompress(entry, pool, req, &wait, fol=
io);
> >
> > Hmm would it be more readable if we create a dummy zswap_acomp_req
> > object here and have __zswap_decompress() take in __zswap_decompress
> > instead of taking in the req and wait separately?
>
>
> I would keep req and wait as separate arguments. zswap_acomp_req includes=
 a
> mutex that stack decompression never uses, and taking the address of its
> wait can still reserve the entire wrapper on the stack. Removing the mute=
x
> from that type would add more restructuring. The shared callback helper a=
nd
> path comment make the setup consistent while keeping the existing stack
> footprint.

I am fine with that.

