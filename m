Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E8D606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 19:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ggZEktIu
Received: by kanga.kvack.org (Postfix)
	id 828026B08B6; Thu, 22 Oct 2026 15:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FEE06B09B8; Thu, 22 Oct 2026 15:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73BB96B09B9; Thu, 22 Oct 2026 15:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4D06B08B6
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:16:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 846FCA6E12
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:16:06 +0000 (UTC)
X-FDA: 85351217532.02.224150E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9949780008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:16:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ggZEktIu;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792696564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aXEotVyVHJYDPptgK6vNC0rI1V41OJrJxrbuxV/+QY4=;
	b=pa6s4WZe+9vL/154BqF12Mo9fqSjdTj4NMVsFR7amKPl0VYDjZlaY2iFJnkUZH/uHG1chX
	3qRhn/RJHhPWI/qMbKJSFfGFjzwREsbd9afCIIIW63DRHSsppFYqbdHD7614lmHBbPt9Q6
	uGcWtuw0uwU5dzeKB5xCsAA8oOOTFgc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792696564;
	b=aGMeeusV+hb8MpQzSSgqQ6nPrRja9uxqrlEyrzPo4g5ED9PUL5q26jONMse1A0/XiKjzkv
	XHZj1oL6tczPJfMgFKqLn9Wd7jh2lzfeSGpekTxlc5UcKcy10fpxj8I7RF4XUpfumr30Tq
	UyrvphnLEMWAwb/egG0BzOjRWPBQhQk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ggZEktIu;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAB59609CE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797DC1F031EE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792696563;
	bh=aXEotVyVHJYDPptgK6vNC0rI1V41OJrJxrbuxV/+QY4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ggZEktIu+eC0ocrsZZXiVHxUntX/tF/RiCECaz1exsAYChneQQq5R9Zw1zHCAZ+Ny
	 46dYopslFW4D4BIJ86ovTrPhIEApOeoKUDyI44l7UbPdKSYK6V6zQyS4VaIlbL3W5m
	 KufrO3ZTfHynnu+DYQqKa6UE3P4tfmww1BG43u+EJ8Uwnx3ox8YxyuKhJErLEXA5gl
	 8RoevceTnFtiiTYiPn3gEVGVrjIvdWVXpERr23iLocMiOU0P0+UqSTRrW08U+Immcg
	 ygmko5cwJXvek8zOVUHeeZTPLXrzeKV7yr4gLgyiqmszdV5OX4yWp1A4A5k+SjSn1n
	 ZHxmsFIw0hxLw==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b1a86c0316so122286a12.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:16:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz6bAVAHrbRP8lcHkJ1ZF1DJNtavu9HisWxqWVAU3cD6GFDC+xtzONVsDCTRpWrgiHiil+96ZRspw==@kvack.org
X-Gm-Message-State: AFq9FYL8DHUolUuXnNC7SgjjpCuggK4Gt7sTXr10mcHDoMg/avmpd9bD
	weRHrN6CjKejSS+XPUGvbCgezppAQTiQI4vEeAJk7XEc7kvf0Bois25jLD9Hw94DN4SVnfdvHgf
	USwOwbD/xiLH6gNtggxv+INbKBqm/eZU=
X-Received: by 2002:a17:907:9c06:b0:c3e:34fa:611d with SMTP id
 a640c23a62f3a-c46a93f0638mr14493466b.35.1792696562242; Thu, 22 Oct 2026
 12:16:02 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-3-suseendranb@google.com> <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
 <20261022155144.4177200-1-suseendranb@google.com> <CAO9r8zP+GUE-hcGWSGzhLNLcchFoZ38EMVCAtX5yZ78tZ0bbgA@mail.gmail.com>
 <20261022183319.163484-1-suseendranb@google.com>
In-Reply-To: <20261022183319.163484-1-suseendranb@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 22 Oct 2026 12:15:51 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN6hN4h5m9pg4xQpirJj3o2nhGx5dxAuSddZ8+UenYnMg@mail.gmail.com>
X-Gm-Features: AclHuK_hJDFj0vZeNwHlzwbNEbCyCqR7zIQWw8UnwCHO6c8KrbK1Hg29ZhvDHe4
Message-ID: <CAO9r8zN6hN4h5m9pg4xQpirJj3o2nhGx5dxAuSddZ8+UenYnMg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor compression
To: Suseendran Bhaskaran <suseendranb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9949780008
X-Stat-Signature: jm8b947uhtke5a1b5uu6f5gioxjiq18r
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792696564-924503
X-HE-Meta: U2FsdGVkX1/0lfcOIMvSrLbFJAi1cblX7SfdKOJiAhTX8oBKZHkcLcQud8Q36bEEHEShKEVCH3ulWES/mOpjTR/vAlZqofxHKTRKGjUFXQO0N0OccfTfxB/1ioTyyGvPWh/5tfBMSBesom5tICCgBGCBwpXNYOTtm7ZxzQIqaaRCrdf6jCIo2mLNGD2JMUmjp9YRB28GgSmvJPl92AswX6X4yCx6qnmU6rP6q86WPIh+Cg/htpEgHo0VS9JBWtO1NriyQqOq8RO0afHR7/7uuCZ1rLG3GNr1l3yNm0phBd9rDDX6bteWnWFhqPhAd2csVAdJtDBQiTvtfwLvk6YKiEau5X8ooTJnz8Wq988iDvBnaRen23WJ6uDoo5NsLkVEzLUqNlm127daeSsGEuRnhribWFCYivviQmG3DnAadcOJh4GKeeijA48doQXh5Lw73/pX82wPFwjfWKWqI7/zP4NL3RjcQbqBqVSwKlpkT58CCoCzrSpJj5graqgz1c/h68NmknzzdN8Q8i6n5Ng15R6vvned4B0HwJhuH6ndf9fxYLIjJLjDOVOieSOYqxiPkMvdem15gDhosF/veZnGq1XN1R140Uz5YNxDeNtnrwdyFM9yWov2/YxvhapEJNH1ikr1W2UWudTPwQmCzTmfklP7/0BfT8Yq/emT8Lwkv/MshLwO2KJsyAnSjHQycOBL5WOmieJbvIloEktbPqSNSsibxmlm+mlmD9jh7wF9WpMYZO2kZ+v/u551Pe8tbm15MGPIgpRZEq01qV+W7tuxvI7oy3V8wq7bRqDkws8Hy7epso2UtK4HawcCFLYaK3syLFm5bOiCh3Qx5Wsdyd1CQF+BRnRpAS2vXwuKWOZp6zF/57I1F4vv37JScmiB4DNsFUoHe55qnqhiAPvcVWBaLJLn1SAQQqN5CpJFsqy2SGjwb67P3gSEJ2ZtDILT91hlSnShzjN5q+NqAJlZK7k
 YmRHBFHp
 xLymUGNR3ZQeSqC8jfKzoPkLTc0NvIEcObQkdN1TwnMv8TRvnP4b6V2FbQkV6AVOwPEcmm6qtrs/xYFCz8v4r8OVsXw0nqtyvGhnOS8p6xHXSUzIgYBpsaxHjXv+5ARt7JIjCoG/cor9ffsY3fLR6ZE06p5R6B1XaI1gSPTYdAdnFiFCcZiLHoMVJxqRzdrGWxnMw5xw5cUTWcW+4DhPwl4EV4RDBoKNHKvryq1Y55NC15RvihFXkl4ry+g4xALQr7k2FIqOKLJUVvIgl5Gy3HzWs24O5aUni3Ct2Y0DoJIZ7JWwd8Y+IgjDpNyqvRuwwiXBWt0t9pHeDX/HcpZXAV/vtSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 11:33=E2=80=AFAM Suseendran Bhaskaran
<suseendranb@google.com> wrote:
>
> On Thu, Oct 22, 2026 at 09:01:02AM -0700, Yosry Ahmed wrote:
> > On Thu, Oct 22, 2026 at 8:51 AM Suseendran Bhaskaran
> > <suseendranb@google.com> wrote:
> [...]
> > > With that unchanged, existing zswap_compress() already accounts -ENOS=
PC
> > > vs other error codes when writeback is disabled, except for the
> > > !comp_ret && dlen >=3D PAGE_SIZE case mentioned above:
> >
> > Is this actually possible? When we changed the buffer size to
> > PAGE_SIZE, I thought we made sure all compressors wouldn't write
> > beyond the buffer size. dlen > PAGE_SIZE means buffer overflow, which
> > is a bigger problem than debugfs stats. Or maybe compressors can set
> > dlen > PAGE_SIZE but won't actually write to the buffer? I didn't
> > check.
>
> dlen > PAGE_SIZE isn't possible, since all compressors bound their
> output by the input req->dlen (PAGE_SIZE) as you mentioned, and only
> set req->dlen <=3D PAGE_SIZE. The 'dlen >=3D PAGE_SIZE' check in commit
> dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
> as-is") was written when the buffer was still 2 * PAGE_SIZE prior to
> commit 0b1bf60c324a ("mm/zswap: reduce the size of the compression
> buffer to a single page").
>
> > As for the (!comp_ret && dlen =3D=3D PAGE_SIZE) case specifically, yeah=
 we
> > should probably use -ENOSPC to count it as poor compression.
>
> Ack.
>
> > The compt_ret and dlen checks are not super intuitive tbh, I wonder
> > how they should relate. What is the expected value of dlen if comp_ret
> > is an error? Is it always 0, or can the compressor set it as a
> > non-zero value if compression fails?
>
> On error (comp_ret !=3D 0), dlen is not guaranteed to be 0. The value
> left in dlen depends on the compressor used. For example:
> - zstd, 842, and qat set dlen =3D 0 on error.
> - lz4, lz4hc, lzo, lzo-rle (via scomp_acomp_comp_decomp()), deflate,
>   and iaa return the error code without modifying dlen, so dlen
>   remains at its input value (PAGE_SIZE).
> - hisi_zip sets dlen to the hardware-reported produced bytes even
>   on error.
>
> So dlen is only meaningful when !comp_ret. The !dlen check was
> added in commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE
> compression failed page as-is") as a defensive check for the case when
> comp_ret is 0 with 0 dlen which shouldn't happen unless the compressor
> is faulty.
>
> > >
> > > -                       comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> > > +                       comp_ret =3D comp_ret ? comp_ret :
> > > +                                  (dlen >=3D PAGE_SIZE ? -ENOSPC : -=
EINVAL);
> > >
> > > Would you prefer that I narrow Patch 2 to just that change in v2, or =
drop
> > > Patch 2 and only send Patch 1?
> >
> > Let's figure out what needs to be done for patch 2 first, if anything.
>
> Since dlen is only valid when !comp_ret, we could normalize comp_ret
> first when !comp_ret and then just check 'if (comp_ret)':
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -874,19 +874,24 @@ static bool zswap_compress(struct page *page, struc=
t zswap_entry *entry,
>          */
>         comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
), &acomp_ctx->wait);
>         dlen =3D acomp_ctx->req->dlen;
> +       if (!comp_ret) {
> +               if (dlen =3D=3D PAGE_SIZE)
> +                       comp_ret =3D -ENOSPC;
> +               else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
> +                       comp_ret =3D -EINVAL;
> +       }
>
>         /*
>          * If a page cannot be compressed into a size smaller than PAGE_S=
IZE,
>          * save the content as is without a compression, to keep the LRU =
order
>          * of writebacks.  If writeback is disabled, reject the page sinc=
e it
>          * only adds metadata overhead.  swap_writeout() will put the pag=
e back
>          * to the active LRU list in the case.
>          */
> -       if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
> +       if (comp_ret) {
>                 rcu_read_lock();
>                 if (!mem_cgroup_zswap_writeback_enabled(
>                                         folio_memcg(page_folio(page)))) {
>                         rcu_read_unlock();
> -                       comp_ret =3D comp_ret ? comp_ret : -EINVAL;
>                         goto unlock;
>                 }
>
> Does this look good to you?

Yes. I assume this is completely independent from patch 1, so we can
tell Herbert to pick up patch 1 and send this separately?

