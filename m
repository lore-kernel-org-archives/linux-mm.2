Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01A81606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 05:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZLRMmHNg
Received: by kanga.kvack.org (Postfix)
	id 235BD6B00EF; Thu, 29 Oct 2026 01:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E71A6B05B3; Thu, 29 Oct 2026 01:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5886B05B6; Thu, 29 Oct 2026 01:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8DAD6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:09:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70CFC16023C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:09:51 +0000 (UTC)
X-FDA: 85374486582.07.A119BF7
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 89F2F1C0009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:09:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZLRMmHNg;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793250589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpw8TTYWKB5hnWuUygH4ZRFIeIPvKSlqcY3nCnns/2g=;
	b=0YsqhzSAuuJ1q/kdfNEwtSBMToEVix+3JfxX39Bi2gI3o0pCm2+1sEzY18IlxbdUtv23iW
	hbcifmuEqh+wdWXuu+FDb0dimMDLuj0o+61tYE9CA0R1M8CzLQFj1p1Dp+xfm3/vINIh7i
	X7MgylUX/B0kfVPgV8DC8BT8YTQEjZQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZLRMmHNg;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793250589;
	b=56K+GRjakr3VnPJeayd1PIWz+5OUNaEeISVsdACdffmAEkyhD0eeqnM/7b1/ng/LJhu3MD
	bvr6uR4Lw5VP96o7jGSpZm6+JusdPCRZOGhDPJ8UwGXPFrnYtXcVRjDjSrTeaaOX0LQ2vt
	cNNwYAc5sGJcEPEpqfEbg8NgjIfkuBA=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5ba3fba0080so1416111e87.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:09:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793250588; cv=none;
        d=google.com; s=arc-20260327;
        b=R4V9efj/KnFFDBoK0pzVTyAU0q9g7YtCwnP2QwjF+7pPURws1SZJ/XkHV3AG41dP4m
         YJkO/P9orcGPF5tHhyDJoUJ85XsASvskxBgRvqIoeAGCeiPkOpeaZXRy1T+4f7LFwehF
         VnuorSOb7c+4Nf03lzvyH8hWs/kyJ0Gc8wrFBXxFETHsdvqCNQpPihOUmMdMgEPHW5Zu
         g05yvGIfuvpUJsIY+rC8JO2iSw4WaTV9aPY7nFXjqbuVvGcW8n03yEuOU561C6s2hHxh
         ptQ+qLEEKeOWoOGYknqg504FLKFo2tIoguxH/x8rmdiYlOwlm3Gs/rfDi8M28qtIKvV1
         EhKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kpw8TTYWKB5hnWuUygH4ZRFIeIPvKSlqcY3nCnns/2g=;
        fh=vdPXqvMAe2aKDHo3WZQ4/FG1mKRBr5wcn6X2WYKMBvU=;
        b=Ozzi3nfNVomh6SidW7Xonf1S0xX8Rk21hFYfkTZ4ak0UPHJOOPoHJ2ZmI7PiYXQCQz
         yHQ2MclGaObXn6eEKhSKl7V8bHO/lxciRQQeVyfqoxpNp2+6Di+0LnOPQJ4x80u1r9EW
         AFCPvjT4LNzbGMVwOWYEiL22ZaKahIpdKVk7dbaa9RMQpAlIkJDYACIJ774I0DrB9kps
         cCr14fvnt//tLv8thPxfSQHcmPW9aKDO6uqc9ZCvmUptOBA0ZHmkm3Lsd1bd9y3ppxQP
         TfaQEfGp0T9VtfufnLIJgZFg6OcdlbMrNVYx/hAsobzA+dMqyZRJDVGrA03gq8eUI88X
         yD6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793250588; x=1793855388; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kpw8TTYWKB5hnWuUygH4ZRFIeIPvKSlqcY3nCnns/2g=;
        b=ZLRMmHNgNQhaeiqNhTTPVE04fBQpbwHKLFZipujDmwAvxe/heHsgO4cRKrivNnDeA9
         2OWxi7lCqGIhX//2TdTsoCLwZMVHLd2I393F3q8MoYVpW6rTzJU+y8zl0ntqEKRt7H3O
         f/acew/eahIeNs3AuT0cP2ocpKdgOj8bQ1lbpMqdaZt4ROWLShskvNqXlVZ5AREVGayy
         RpFNhxawQXCGh/6NRfbQqROgDXXPeRBzoyNHsaGoD/MdsiR6n53zn1ZeQqxMPTJc8KQU
         sYvtY/Tc9dj8M9ppK3cpnOYYK+Rj/5g8OFOMQ6QWfJG+BcWu5AMXGA75jj9JL7wbFGH/
         PEXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793250588; x=1793855388;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kpw8TTYWKB5hnWuUygH4ZRFIeIPvKSlqcY3nCnns/2g=;
        b=K+paA9BD3QHEyZAOSNtI0Kwp8scrC1yqDIHgdUWGpEmhm3S1YrdkFNcMUsr36G/PSa
         3nzEdcTDXFe1O+eXleJPFHZMnPRpeVotDDteaDoZU6Jv0CW919qem6UyGXac1Gp2WXT8
         dG3KvwiMvWs70gr7Lkqr3QAma+HRojwlkkR4vFJC0tWVfCZiMqk3qgAKq6iAjQlMAldg
         6D0htIxr/EMEEvkTA9HSkZuGBKVXeDbiLRE4NIDq0Y1kHNSSWculumbHlMQ/XyDp/VnN
         8nPYgNu95bd8d9NPdK+/Cj3g52pG0d1eLxvUpw6AjSjikwTiOoOMxT7LRXt5hVcxV6UN
         nv1w==
X-Forwarded-Encrypted: i=1; AKwUvBzGV/RPM0ObQMCE2b1gzgS2lqY/XOBigvK28KmZ4zbQfU6R1I4gryQ6TR7w0YUJuxkQEgJ7rQe7Gg==@kvack.org
X-Gm-Message-State: AFq9FYJm65UTUVdFXFQbN3Gc7JODkQCYPlvmrwRa6wDMjoekxQ9JFXd6
	U0A5smyxikPJS2O7zGEsdqeIh0lMjgxpcms3Sko11oEr24WSwyHuB6FYsk4Hbcck14YmEf3F6lh
	yooBPs6QFjkXlYlJV1nBpLinjw2iGk/k=
X-Gm-Gg: AYBFou1xoFB3JnJRvN75xNSec+NbFdhn3eykwFgNbyhGrqYXNIHzUcVaAIMDMbrDu8I
	XdefskGW0bh2XWd8v9uOwa1wBwIe4Jk1T/1zMhSVMgvA34dHhUpgyv17oNRSlDy8LRWHe9DOM8/
	WGI0gQwa4a0z7+ZHLPW11WhcKtUV9oMjwt7SUNdto7Efd6m22Li0zA1q0wXA6qvluHsRm4CB5kr
	WAFOz8kM+7ln6zaJQW0hKH/gon3U0dwsAXgrIsvZUBkaldu4ujLwnyU8TPYbNtH9wRxfU1Y8fT2
	Bpa1oaLbQzXnrRZe3BQHnvCvYKwRe0eGvc0EGefzzeDoRIKzDbSxuQXwtFyHTfa15VjcQ2DD18u
	GxjtmkSKWg5/RO8R+C8cIminVQMW53cRxCfRH
X-Received: by 2002:a05:6512:2254:b0:5bf:bbcb:5090 with SMTP id
 2adb3069b0e04-5bfcad1735cmr1673625e87.11.1793250587589; Wed, 28 Oct 2026
 22:09:47 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-4-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188655@kernel.org>
In-Reply-To: <sashiko-outbox-188655@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Wed, 28 Oct 2026 22:09:35 -0700
X-Gm-Features: AclHuK8nR-G5FLP-nKgfLbRVgykWEd41gXMbkberCRHNZZZBPGk3kNc3GrhEkxw
Message-ID: <CACpmpodu3C=uYH6dmFM-xkvdJxiRDjamRKs1Q4jU6_KKjFWNqA@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 89F2F1C0009
X-Stat-Signature: 7se8rjnoc1g9s1z6kk8z3uyd5qpogt3f
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793250589-667969
X-HE-Meta: U2FsdGVkX18MWAortDTSISGFn2lLoprEN7Sted3abec3pFffqQtEjQ04UmIGC6Kv7XTkH63i+hBvvg84RJGLVs2Dl3HFPBDrvSxOQ+6AItGiP7WePkAamMBvU9vLqmO3fmoUUq+GA8GN9KGVCHcCyNWmseDGAJUoeHJSJLNdscM/ZzrsExGP3I0vGVAwFo7nMwaGy3XtFnxEnN1ZYzBmNOf/+m0Ce4eJpu1ES+4Z/RroWf+bKkwsgOykNIz9xo3XhRpCo8nO6fg5ucpmYpYVJvFlsiyXWQcfDuvaJ42xqvzDxE55bBodV/95A6gCs07eDOUrQL/etiv+qejBSQ10fChqaAIyEjsk2wkKHVj/MurAA3/DSb6bIViBmUn3hSqHLogR83tKmaemF5CQPqj40T7fHm6UrIsNJPoSeAE8Sur+dkTi7w8L4VGUXuPGmc0uZ22+lnmd1s5ApQvCQE7HGns3V36ftVPdGQG83q+w2OV35HFVRKLH94lqlC6I4wPSUsLGT6FfGlyWzyagYR82xA3H9z9cppvDAWC5BeRAC76NKItZxLbashsTvViL+177HaKSxrQi+IY9hIn1Zn8021QTtXRpJBxM4Y/vvVqeV8AdKqRif16BQy0t8yGjpfCfkDSiLn77IiUzwl3h3Y1RzYUGaDAKqNJOqdKfCYUczL0znpSfdzS7Vn9HqfUHwYmtz+2YHeyB0OFLNsOliFE7hw1vHJS8lOFReSVOXv3n/yvgSE60tdnPfledmAcRK+2JfmWoiDXzlVTxwBv22agxmoBw7HZ71R18Pi3l5oRy94Ph4othi4NPbFe8DHsOuO42kYvhOI4m50FVwT9xkBU0t6fsg4Ai8RzttFxTZhQDQJQnAxPtJIzWrKa3S1qI2A4jn0I4TSijoGmf0Mj9oQ2kCp3T2ZvDQ1L6Hdx/yZkCjV7fw6E+Fz7kTPuIKkmi+Iuc/n6VZC5NBgFvZXB/aLy
 qZpr1ptz
 XWiJoAo09H5soLaWYdFVaz7ReLtsshI88SjNSeDoJ/G6cadTjValTqB7jClP3Q4U69tMmbg/TA4+YeMt5OIKGFXVnS1ZB6oDCZDO/LWa8oUxEb5tPTrtQ0Mm0Z9CmT4hi7OUKZjTY2yGeNLMID81e0j7pCL4pGqfqtlXL2YouYAAnjmEFFpDZfitA21RdDLP/I0SxJ+JFN1mze4nGfzuaB2YDe3n6X7pbRLka4jXUWODwdX2OM8I1BVVaP5hF6TaMIN7BNLSZkH48Z2mIKc1HvybD4sZy7y0JSlSle0TlLWa12ywuqkZVfsAPootrtIlnceCx6CZOKQAZuV3AkWXPIT5RZWuucin1i2zM168swyWI9bLX3tBFuxSwZrBqZSkFU9VyBDwOAR94XF1IoGsxjNYoTuYKB3TYk+0yQkV1C08QltIBro9dy47wl6rNzYmHSl5BCwTE4kpjKwAOBp5rlDhGHl6J5P7HrK0pPjfc/jSuvm8oDwWQuX6owYec51243ia9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 8:06=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [Critical] crypto: acomp - missing async check in crypto_acomp_compress=
() fast path
> - [High] crypto: acomp: uninitialized state->src/dst restore in acomp_req=
chain_virt()
> --

Thanks for the detailed code review!

>
> commit 7144b07b2cc5b6704699fb53fac44c4270d31f7b
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> crypto: acomp - Add trivial segmentation wrapper.
>
> This commit adds a single-segment compression wrapper in crypto/acompress=
.c
> that stores the compressed length or error code into req->dst->length whe=
n
> req->unit_size is set on transforms that do not support segmentation. It =
also
> adds an inline fast path in crypto_acomp_compress() for single-segment
> scatterlist requests.
>
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index c8b4b8589769e..c55b0e8eff3d8 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -166,14 +166,20 @@ static void acomp_save_req(struct acomp_req *req,=
 crypto_completion_t cplt)
> >
> >       state->compl =3D req->base.complete;
> >       state->data =3D req->base.data;
> > +     state->unit_size =3D req->unit_size;
> > +     state->flags =3D req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
> > +                                       CRYPTO_ACOMP_REQ_DST_VIRT);
>
> [Severity: High]
> Can moving the state->flags assignment from acomp_virt_to_sg() into
> acomp_save_req() corrupt req->svirt and req->dvirt when a request is
> configured with acomp_request_set_src_nondma() or
> acomp_request_set_dst_nondma()?
>
> When a caller sets up a non-dma virtual request via
> acomp_request_set_src_nondma() or acomp_request_set_dst_nondma(), both th=
e
> non-dma and virtual request flags are set in req->base.flags. When
> crypto_acomp_compress() or crypto_acomp_decompress() calls
> acomp_do_req_chain(), the call chain is:
>
> crypto_acomp_compress()
>   acomp_do_req_chain()
>     acomp_save_req()
>       state->flags =3D req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
>                                         CRYPTO_ACOMP_REQ_DST_VIRT);
>     acomp_do_one_req()
>       if (acomp_request_isnondma(req))
>           return acomp_do_nondma(req, comp);
>
> Because acomp_do_one_req() returns early through acomp_do_nondma() withou=
t
> calling acomp_virt_to_sg(), state->src and state->dst are never initializ=
ed
> from req->svirt and req->dvirt.
>
> When acomp_reqchain_finish() then calls acomp_reqchain_virt() in
> crypto/acompress.c:
>
> static void acomp_reqchain_virt(struct acomp_req *req)
> {
>         struct acomp_req_chain *state =3D &req->chain;
>         unsigned int slen =3D req->slen;
>         unsigned int dlen =3D req->dlen;
>
>         if (state->flags & CRYPTO_ACOMP_REQ_SRC_VIRT)
>                 acomp_request_set_src_dma(req, state->src, slen);
>         if (state->flags & CRYPTO_ACOMP_REQ_DST_VIRT)
>                 acomp_request_set_dst_dma(req, state->dst, dlen);
> }
>
> won't acomp_reqchain_virt() see the virtual flags set in state->flags and
> overwrite req->svirt and req->dvirt with the uninitialized state->src and
> state->dst pointers (while also clearing the non-dma flags), causing a nu=
ll
> or wild pointer dereference if acomp_reqchain_finish() then writes to
> req->dst->length when req->unit_size is non-zero?
>

Herbert, can you please take a look at this and suggest what changes
need to be made here, since you are the original developer of this
portion of the patch. Thanks.

> [ ... ]
>
> > @@ -279,10 +289,27 @@ int crypto_acomp_compress(struct acomp_req *req)
> >  {
> >       struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> >
> > +     if (likely((req->unit_size =3D=3D req->slen) && acomp_request_iss=
g(req) &&
> > +                 !crypto_acomp_req_seg(tfm) && !acomp_req_on_stack(req=
))) {
> > +             int err =3D tfm->compress(req);
> > +
> > +             req->dst->length =3D unlikely(err) ? err : req->dlen;
> > +             return err;
> > +     }
>
> [Severity: Critical]
> Should this fast path in crypto_acomp_compress() in crypto/acompress.c ch=
eck
> !acomp_is_async(tfm) instead of !acomp_req_on_stack(req)?

Thanks for the catch! Yes, I will add (!acomp_is_async(tfm) &&
!acomp_req_on_stack(req)) here.
Since zswap is the only current user who, with this patch series,
submits the req as SG lists, I was assuming that async algorithms
would set the segmentation bit, and avoid this short-circuit. But
until that happens, the above check will take care of this.

>
> Callers using asynchronous hardware compression transforms (where
> acomp_is_async(tfm) is true, such as qat, hisi_zip, or iaa in async mode)
> allocate requests on the heap with acomp_request_alloc(), so
> !acomp_req_on_stack(req) is true for asynchronous requests.
>
> When zswap_compress() submits a single-segment scatterlist request with
> req->unit_size =3D=3D req->slen to an asynchronous transform that does no=
t
> support segmentation, this fast path will be taken instead of
> acomp_do_req_chain(req, true):
>
> crypto/acompress.c:crypto_acomp_compress() {
>         if (likely((req->unit_size =3D=3D req->slen) && acomp_request_iss=
g(req) &&
>                     !crypto_acomp_req_seg(tfm) && !acomp_req_on_stack(req=
))) {
>                 int err =3D tfm->compress(req);
>
>                 req->dst->length =3D unlikely(err) ? err : req->dlen;
>                 return err;
>         }
> }
>
> When tfm->compress(req) submits the descriptor to hardware and returns an
> in-progress or busy status, won't this immediately overwrite req->dst->le=
ngth
> with the negative error value while hardware dma is still in flight on
> req->dst, and skip registering acomp_reqchain_done() via acomp_save_req()=
 so
> that req->dst->length is never updated to req->dlen upon async completion=
?
>

The augmented check for async algs should take care of this.

Thanks,
Kanchana

> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.17=
923-1-kanchanapsridhar2026@gmail.com?part=3D3

