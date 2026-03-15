Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F0BD58B08
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 03:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6044C6B0088; Sat, 14 Mar 2026 23:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B17C6B0089; Sat, 14 Mar 2026 23:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F6B6B008A; Sat, 14 Mar 2026 23:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 325136B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 23:30:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 83A9D5C2ED
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 03:30:46 +0000 (UTC)
X-FDA: 84546870492.05.70E83C8
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7D85840011
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 03:30:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c9HL4q9I;
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773545444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bv72G/11tEX9vAPzpUs7xnniWeBvTIRb1OfN9FbtC4o=;
	b=uqVYfXoT27CWY7QMj6IukOQ+dBXBltrkMci8CWFjLtVsdzDy0DE0WEVnPIwHup7xN02Vl7
	s2Icq0U0W3uj4eS1tLQ+TTKl96dzQ7vGh0jLH2rmPaXzCnrpovjJ9JVF5fSGIw/DPfKAPU
	L4ZYoBew27WNfBMFf7DBlUq0A/P0B0Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773545444; a=rsa-sha256;
	cv=pass;
	b=Nz0dU2DyESmHImedONLxEmgAPhctFqKOckQBhIsHO//Y1r0IodUAkLN7I3TpPjUpIK3wHh
	mHF3yXbmdgRgEU9nPweDysNJUnKPbn3XAw3Sb6dORZvCYGweow+AeUrcWKnIbuVEg7Yu+c
	I+wM+o9UqHSa5VgzBcrNivyqxhBWTrs=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c9HL4q9I;
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65c4152313fso4903090a12.1
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 20:30:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773545443; cv=none;
        d=google.com; s=arc-20240605;
        b=I6Vaw+KQRdRalD1WG+2lrvxFRr1XXXLRJtEJbm2EoXjGQ/aaE/LVpEU96+ikmlKQ+G
         QL85kYO3ykAEZivrt0K9rCXKPo3UINQZ3xMCsNRhnCIM8s4+AMqXYlG1WavrruJcA0J1
         pvZ0yvUS2qpQwPCZ7tV9yfojVyauwMPxrFXQ9tNvJrCWiWZhxCnzfI0CDTst+XM4HaWU
         xQyZDtZiOktZDojErPrgVifUKjxRBaSdkY4NNBOZXk5fsm26RuSmT4YtM/OotHm197Zt
         T6tp9uhRfREy2kqvIsk4mKJylQ8aISLJLebcKTWFrU9B2b8mztmfhUJ2jRPDN0+6IG6u
         Hbgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Bv72G/11tEX9vAPzpUs7xnniWeBvTIRb1OfN9FbtC4o=;
        fh=3LYTg7Ly0VrO4OhbRk2MqOdzeH+SYd+c6Zr+3GPEuq0=;
        b=OntgCOWhNz5xm5Yuz5gY0LqrjbvvMW5ndxsZ5deEh3Sx789Rqz4iMZO2ug/K8kA/9j
         wVKLltZqs8TDQLDdFpqoEjMlP5xkw+CVZpo2SQyjTHYXo+G5R+/WrR6cnD0pOtcPj+Gn
         a90xuVptB/73lBhDPUfZ2CX6sFxlb74DlXoOxVRnzqZBZ5q98rIADOTfzaoHo/dX8e7m
         NS55OnxkluI/I8VI5g4ItiFbjWuGOjXgL9YkVEv1cRM22TRH1xo1loSxLDvw2AGo2r0n
         nWCdnMZLOg9+RXu5hW+IMpiI3kOHizHNMnE+eYKaxNyguBPOSjGVzINeOvXwUp1QbOkd
         Adsw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773545443; x=1774150243; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bv72G/11tEX9vAPzpUs7xnniWeBvTIRb1OfN9FbtC4o=;
        b=c9HL4q9IpSOLQiz3bed2KAUpPV31U0fXXQZ6iylJYM2KaBt6Myr0WDMAosP1VXNMo/
         sx6qIGqMfGbuMup5MCFbTePvHnzvKazJxQhikD9X5lhDCYDKMS0cZBoHNBZPtc3Ha08k
         O+CdmOeEFoU6WqJPPdfe1IlIcVQQR6zETzpsuCxjBfZLHT55bN0VYytHcFupkJubKoqy
         OVpEc+8TYuL4QSSZl84kh99zFftFAM3j0+UR23izDOignJJISPdf2e//KgL0kb/+JdkE
         7KBbQszEKXHyhZvjeein+Ig2qz1WELQhxys34piy2J7rA1ahN9j98TnwOlyQY6UXffc+
         u2OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773545443; x=1774150243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Bv72G/11tEX9vAPzpUs7xnniWeBvTIRb1OfN9FbtC4o=;
        b=Ca7qdLYCbuJaMN69Q2gy43zbNW3FWXHgNxnaO3rAU285npxZchcNqgQGBodFP3fuEY
         YpICwMJgCjVMKQNeg5YLDGNB34ZvFjRMaRzYp0VzPUyTtjUUQAVU/8NN72GJgdprARvv
         dkwM+iIhJsp2fGR8kT6xZz0rkVmREo7HdMo0Ww5cgKuCL7HHd3o3j1c9GJ5jFu9voKgq
         6OCjQWrLczZCVdQQ24thVOKR8bYjPNMdeTtxHSjgcLmTEceFFkl0EfuQL3csmeIYA+TN
         1AKTPMcgCEvhXqdWoWIYwN2kybcQBncbxKs4ttTp9NFxocWzm/eVwerEOBfr0lZQE2Hk
         3VHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXi+oUS7kj2ycReoU+UX3g9PwBn+ZCS82IV+DRinDw3PeipTLW9bqGmD6iuFAI9MqfX2y7mM24P4g==@kvack.org
X-Gm-Message-State: AOJu0YyX0z7iadlOvwyf93peJETFhpWxOdfrb9v+fCDR1loyaOTjcvfd
	ntBF5S/jsbVZ7o9WMjXRb8SFJl/1mTz2frVgX+daDBNvVoWbShXQeEkJo99hfduCGo4rEmBaBhf
	koAiLXpJSfDHL++c/Taofs0VdaBaRywA=
X-Gm-Gg: ATEYQzwRSHVY8PsL5H+x4N22o0TPz3eBVXmYNmPO+VZ3WsDHPOl+kdExziwLt+HeHNj
	gYNqGRIlwODcG82pOw/9dRJZDvbJbm6Jrk0/L6R1hdaWk39Crobl0NTyUZQeeG3IwcsA14uhMQu
	b7PSwLYEqutrLBXWnESE4l2E7D5MIA4bwKatpgJl/m3jr6FTwzc31S5pUaRjQukQp5LpL+m3lyM
	XC6hxhZAT5eyTpSb7FpHK+6gzdmZYyLQKQkpVYODmGwgDxit/HWE9d8w8YFhpY/MbZJkBmvjs9C
	ae7Ql3RXhw2hU1KD9Eos/D2Kbg==
X-Received: by 2002:a17:907:1b1a:b0:b8f:a85c:95c5 with SMTP id
 a640c23a62f3a-b9765345681mr450808766b.37.1773545442392; Sat, 14 Mar 2026
 20:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com> <20260314171150.fd6a80a8f51a5390144d20d6@linux-foundation.org>
In-Reply-To: <20260314171150.fd6a80a8f51a5390144d20d6@linux-foundation.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sat, 14 Mar 2026 20:30:30 -0700
X-Gm-Features: AaiRm53et6BNybxT7kXiCWRSAaquX2zmTHsUTtxux4cSYbjHAW7Hw1CpMFCH7Ok
Message-ID: <CACpmpodjsMELCrJ-QX066CYiGgraysr_ZhFMvU5N-6nr2HsRsw@mail.gmail.com>
Subject: Re: [PATCH 0/2] zswap pool per-CPU acomp_ctx simplifications
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D85840011
X-Stat-Signature: 7neqocxrk6fk7sfaqzyu9sj1wht3ox3e
X-HE-Tag: 1773545444-854322
X-HE-Meta: U2FsdGVkX1+xT2xXPHAh27UD7aNBu9ziRMqeBZ4LHgvLf1+Qgc3+x2S/zmAceHfpUAabQDw/Jk0DU0U+em8A2ljBhIWaKa1LbMXzoP1Op+Sw6g2scCZOe1v89IW2EWEncrNKD8gcIONf+paiayH6QrWIj0Q0WPwQrihY51ZtFXwuK+Wlkk74A+fyikW6BuCfiIHLZ/uocVhk8HW2eV+lSwEBwo/3k/6dx3TvZTOYI4jmwjYWEBDVSamgQn1P3j381irn9YJu9uCis+x1qGZn/bO5d5EAp8UQvmmik2PbbtMo+WLtMBp8TdnPKwh1DWKSDnHauB/JfWzvVUJpg7FYqgBAgFyA1odVLec6C3ipLmKRofokMhIcor5BQ7LFt18JLgoIV/XvJAvl7gwgP3faRLEaOsiQkGaRWjyy9TRgJVnJfQRM+oxghTHX1HAG3MrQZTRuotWMTkA7/055rtpjhUAFwYmAd3DwmowFRvXsGnCpcmsSgLDJqAuCQN4CqgOepc4LkpANZB0aKBy12GxeV74IOgJNMA6PlEvsSONuVWWH9JoZJw/6a8utH9U6vuC4Sz+WAM7zrmHi55jtCLnV36AWH0csBAouh89n8dJYeITrumLK7QFJ7lF3/VOhOMy0z39qnYek9o6NLrgaUP28D72uQR1QUul40WcNazwn9dNKs2cgCNJ4L3BxKNZwFGAninVSV36tx4vdV5uin6Ps2/hfeFJck3uprNMjLU5Ac0RF9fJVxc55xBJixjm5Mp9u+jI5fJCC9rNrKTk2aPr5OmUJ7YGuzvCJGy7G+pDZLdvwNynk6v2G8vG6UicqpjSs5Zj23J+8fbAWfwle3uzrWBp9pLoOeS07MxWARTYRtgvaewoNxx/2FKJhEElPf3BN//OC72Zo89s1DcFQixOsvFIE9ZGJ+0zl8YYMQlUP2Db3057nlqFAyfvXJLJMTfiYytRA+x/59Wa58qC/LuB
 I+Fle5ng
 RsfVGqkTVa+UinZcHrfSo6bld+FczSEzMrlBTW+Q+6lcNRss/8qfv9rjvqmMvBlGqJrn5dsQohVqAtZiLv2Bm/IUB9AqalXSl+0QX/vjinxjVVJfyHSNUEIIJs/SSVVxnljHON/MbxVfg6dl2FwqbRae9yaTAdSJZrOtM0GoYhvHYyVO2ohyqdxuJCOGTHA84m10mUNFpU8mJw/VTjy93Plw8U7dedFY8plVTZtYzJIa/4NVTk4MXYX5fWavzWASUdK0IR1URY2c/lDcTWE/sjpACDW7pqJZrUkODJk0yT9UvTPBni3cwUZ8+AprvWOu/dNZg+qAZ9WtHZqmwUszqok3Uf/Ky7Nvi7Y4ZNrQCH9Vuma4nXO25suiHHgd3WsP/9TKe9hMrsYvYnWOXJ2kJDi9zCvN4ec80Ylx+DjBeMx08x17vPs/Fp/pW1CjQ4eiU+V+oEvNtMrhN8C/Oew3bQBA4iWEV5/GPWSjmv5FmS7bDp1P7tPEZqcav3Pu+VQWYfyodhffEcnCygg49dj8xcT661Azrjh+VWcEe7kFaKE/5n6HvzeRGOk0ZyCssxhycC3Hm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 14, 2026 at 5:11=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 13 Mar 2026 22:16:30 -0700 "Kanchana P. Sridhar" <kanchanapsridha=
r2026@gmail.com> wrote:
>
> >
> > This patchset persists the zswap pool's per-CPU acomp_ctx resources to
> > last until the pool is destroyed. It then simplifies the per-CPU
> > acomp_ctx mutex locking in zswap_compress()/zswap_decompress().
> >
> > Further, it consistently uses the same checks for valid
> > acomp_ctx->acomp/req in zswap procedures that allocate/deallocate
> > acomp_ctx members.
>
> Sashiko has questions:
> https://sashiko.dev/#/patchset/20260314051632.17931-1-kanchanapsridhar202=
6%40gmail.com
>

Thanks Andrew, for sharing the questions raised by Sashiko. I have
provided some responses below:

> > @@ -786,7 +786,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
> > return ret;
> >
> > acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_=
to_node(cpu));
> > - if (IS_ERR(acomp_ctx->acomp)) {
> > + if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
> Does crypto_alloc_acomp_node() ever return NULL?
> Looking at the error handling just below this check, if this were to
> actually return NULL, PTR_ERR(NULL) evaluates to 0. This would cause
> the function to incorrectly return 0 (success) instead of an error code,
> hiding the allocation failure.

This is a good catch. Just to provide context, this patch was
introduced based on Yosry's earlier comments in [1].

[1]: https://patchwork.kernel.org/comment/26282128/

crypto_alloc_acomp_node() currently does not return NULL. However, it
could, in future.
Since the rest of zswap_cpu_comp_prepare() dereferences
acomp_ctx->acomp, it depends on whether we want to future-proof the
code to handle a possible eventuality of crypto_alloc_acomp_node()
returning NULL.

If the maintainers think future-proofing is beneficial, I would need
to handle the PTR_ERR(NULL) which would send a false success status.
If we don't think we need to handle a future NULL return from
crypto_alloc_acomp_node(), then I don't think this change is needed.
We could leave it as IS_ERR(acomp_ctx->acomp). I would like to get the
maintainers' inputs on how to proceed.

> > acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > - if (!acomp_ctx->req) {
> > + if (IS_ERR_OR_NULL(acomp_ctx->req)) {
> Is this change necessary for acomp_request_alloc()?
> This function strictly returns NULL on allocation failure, not an error
> pointer. Changing this to IS_ERR_OR_NULL() obscures the actual API contra=
ct
> without providing a functional benefit.

As of now, acomp_request_alloc() returns a valid "req" or NULL in case
of an error. Same question as above. The only benefit would be making
the code more robust to handle changes in the acomp API in future.

> > pr_err("could not alloc crypto acomp_request %s\n",
> > pool->tfm_name);
> > goto fail;
> Can this error path lead to a double-free or use-after-free?
> This isn't a bug introduced by this patch, but while reviewing the modifi=
ed
> error path, it appears that when zswap_cpu_comp_prepare() fails and jumps
> to fail, acomp_ctx_dealloc() frees acomp_ctx->acomp and acomp_ctx->buffer
> but does not set those pointers to NULL.
> Because acomp_ctx is persistent per-CPU memory, if the CPU later comes ba=
ck
> online, the early initialization check:
> if (acomp_ctx->acomp) {
> WARN_ON_ONCE(IS_ERR(acomp_ctx->acomp));
> return 0;
> }
> would see the dangling pointer, incorrectly return success, and leave the
> CPU with an uninitialized mutex and freed buffer.

Thanks again, good catch. I was thinking some more about this today,
and realized this could happen if let's say a batch of CPUs were
online at pool creation time, and the startup callback succeeds for
all of them. Now, if a CPU "x" is brought online after pool creation
succeeds, encounters an error in zswap_cpu_comp_prepare(), calls
acomp_ctx_dealloc(), then CPU "x"'s state rewinding to CPU_OFFLINE. If
the CPU "x" is again brought back online, the above use-after-free
would occur. I had missed this during my response to Yosry's v14
comment [2] yesterday, sorry about that.

I will set the acomp_ctx pointers to NULL, as Yosry suggested in [2].

[2]: https://patchwork.kernel.org/comment/26773983/

> Additionally, if the pool creation fails entirely, the fallback cleanup l=
oop
> in zswap_pool_create() calls acomp_ctx_dealloc() again for all CPUs, whic=
h
> would cause a double-free on the CPU that initially failed.
> Should acomp_ctx_dealloc() clear these pointers after freeing them?

Yes, I agree, and will include a fix in v2 once I get the maintainers'
feedback on how to proceed on patch 2.

Thanks,
Kanchana

