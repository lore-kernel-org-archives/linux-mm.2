Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 177E4606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dctnb9CN
Received: by kanga.kvack.org (Postfix)
	id 09C116B05B3; Sat, 21 Nov 2026 16:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0738A6B05B5; Sat, 21 Nov 2026 16:22:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4846B05B6; Sat, 21 Nov 2026 16:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B75206B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:22:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DFBBC05E3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:22:29 +0000 (UTC)
X-FDA: 85460400018.11.A1251B9
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 52C4E40006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:22:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Dctnb9CN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795296147;
	b=AE6xfTUAAhFzu1EhPlfGN3HMNSCD7TVsna2fgVw8f3acCnCnrHbboNM0xNvKhxmCzcU8Ag
	ZAtRJUseS2RqJKc/DUifCfDH+LI1nDRywu4yaMCee9s7aFmfw1e7VzAQmHCctg5bJOtEL+
	b1rndM+TP5DfQLoWF9zgqwOkLirPoD4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795296147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LhcHhD/8aRKBI15ASV7ocqmrU70ZzMpPTnqr+rqSRik=;
	b=5zI/qDBjXgfpODu+vqAbiF4Sojgqi9OLaQTewXL1aGgE4d8W9KntQj7nfAHp3Ja3Iikm+t
	/wBRFvSzgdOaYsDrckJ3v3o8wXUMfFBB+Ig38zcKXh0PxVl2D+xj8HuAJNNub39NL+qPdS
	oCndd07/Ly9WafiHJUhIxkDn8sXE6ig=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Dctnb9CN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5be53e5fce1so1778658e87.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:22:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795296145; cv=none;
        d=google.com; s=arc-20260327;
        b=IHhAGonM1FCw/0C2pGOMI7exI/u3FBCrWfc+ejsoioFrL7M8QAWWreqqNdyPJ2QNjK
         lI1PpDgzan4iLjyaJiWkjAXLVZGK9eomjpJlXGourIIzM5NNp7v+JVTSNzj4c8491UzK
         fUNk7IhmF3axhWlS0z+4sfLTRu5I5xZ8wIDWURySEUfGSzn0Kf5NU909zVmaqi5rPlOB
         NLEKalGU9Eiqghu84rKri0ka+9kUE8UNQH83uhmoyPGYHEHcJ7wa7xbjEZZzSH+p3QSL
         7wFN68y/4bCUzVAKMcxgFLYhaQ23H6HeQn7xmxrTQMmPMn1zszrD7m4ITB/afAkIhi07
         CSFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LhcHhD/8aRKBI15ASV7ocqmrU70ZzMpPTnqr+rqSRik=;
        fh=2GqGkLCVhJ0eSi1OMyjjoDkFOJBjFYQU3hRzoHmUJHY=;
        b=hchXpMTz1aXl6dGvMPXUo5kbDV9xSa6Z4Rr5zXHg18rZK+wMgGtKhqOHTOO2vHHSBX
         w2rvbfHH7xp+6ZTgKlg0rqmjnRgG5fY4TlYXR4ABhM3dG/btM4dYuSl0YQAziNKpAqWV
         Qyar3d7kIjsCFbTC15JofYGwN0oXh8DF53QkCN+1pUFDSR+rdBrnmvF9hgCEHm3z6cAN
         5kNrzp0xW3fdGwoeLXo7Lck4r3PkDxydPJUr3FwynsGeCjhYDPO+D6hh+C3w5wYW9c94
         qGLtUonipXw6Z8FnV27Xl6WIW8vEzh07fPKwKukJeysuU3DH5qYoKwSnoUUUbhy8Amgr
         v8XQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795296145; x=1795900945; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LhcHhD/8aRKBI15ASV7ocqmrU70ZzMpPTnqr+rqSRik=;
        b=Dctnb9CNP4Oc+f8wWMXl67hBnbkJFrGq+zTOEKlcdVFILubRDpkggIcidSea/mkUHu
         7g0MfFxCKS0fJtibpoAwD7O+XyUVz2cYcLtPyJJiiMJFdOCwknqVNc7vgoPiHW5wtW8j
         aHuwHo3P/Nx5Bs06nGhkUTPP7uu0062Ac9J9VkrrVh3L4IjK/FqcXc9xWBa00dUVUPrP
         oKAdZnWKcIJ1rsIPrtLOAlxIwSxEztQZ6UQP2SpG0trukxxMeDWarR04SpyQVqoPNw+s
         yyF2qCLwBYCgb8UpcqXDhxD7l6183S9Ncb+STj+5ttte365UIlr/3Tj1o++0MZ95+r78
         hx4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795296145; x=1795900945;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LhcHhD/8aRKBI15ASV7ocqmrU70ZzMpPTnqr+rqSRik=;
        b=pKMNBiswCN2Pt5bTDUedXKmJOHy3pYy+rkAhtoSc7SKY/PspkooF/11MSX9l5jaKNT
         HTdcX31LX22P4CidAiYF7RzE5KL+7iwellSrzydZWaawLFOJInd03UVxoxzAbnfrCWF6
         8DXWTtxSCV3gO2tRtEHjgqeZzL8XQ3U+VWpcIwYl2+FIcM1knQqGUE6Co1/gXf7whlsq
         72JsqYwdjCHcfVO/mJvQCjh4dRxVrAU3RXsxS9OkwW6wJ5b4FMwEVZTcn+LzfoYdhW7w
         aOUitGMxL6Ssnb4sL8PPMyJznBHBkwIh5r9DJJ62Wc3+Jzs+kKkn8ABLwXu9RHR88X5F
         R4ww==
X-Forwarded-Encrypted: i=1; AL+hErGdSgKxQk5dF2cSfFIVBYbo8Foeo+3W45zBiat1LZCEXilq24K+xeVOcLpa9znnwFFS68sIRLpdCw==@kvack.org
X-Gm-Message-State: APuU4Z8eJv/IvvbDNcgqATQpThoQv2ZAtx2uCWEOAV+PlZl1IfinFUB8
	blw9dfX5niAeawjv7Pl6oQ/usCLTE17KA4HDEEER0eU0mgDuga0ZoL3BEdkAcv0ITvIb7kampF3
	CqcILB++lUrc9j0EmABRQM+dc6XM7bk0=
X-Gm-Gg: AZFdTZcRjurieqApru6FUI8WmllbOiPdZjjkeS9QvUIfOd6+6N14c6xVA2l7Yu3jndm
	HqNefyJbaUbSee4fXatizdx7oDh0leZCQFar8F7wDXBONfaRcnyF6AicZ+Gb4FUxKlxrHT/SnHA
	rlRDAbD1xSwWeND846mf4NMR4v/os5I1s8Rso+Rrl51oUtdax0b9WiqdZmJHtb8Ddx5Uhv5AT5D
	0Gu/euyovECcX8+YAcwjxvY5yxvtWZwa/GL/tfPW29NfRARpPz6gzQmTz6GTLWtpiW/IIFvKye0
	QSpyJA2riqjRQhLsNlEWqI+6xwXJvud/IS1GMdU89OL4c9wE8caq1XZCTlfiZgRFE9MsAaiHQ5L
	bcQxPP7eIX+3TSEWH9CuXH35huLzS1iviyoCZ
X-Received: by 2002:a05:6512:3a86:b0:5be:590e:ea76 with SMTP id
 2adb3069b0e04-5c1bc680e86mr2302113e87.6.1795296145205; Sat, 21 Nov 2026
 13:22:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-5-kanchanapsridhar2026@gmail.com> <sashiko-outbox-226634@kernel.org>
In-Reply-To: <sashiko-outbox-226634@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sat, 21 Nov 2026 13:22:12 -0800
X-Gm-Features: Aa3M54rocg5lImMNhqmcaG3bXPnzsrtWItRkXY1bhretNH8NzvJavMtXKNpuBjY
Message-ID: <CACpmpoc-OJoQ4hcKpF6muY+tf7NcP9ok+fGXQLog3dc1q__njA@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] crypto: acomp - Add API to get a compression
 algorithm's batch-size.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 52C4E40006
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 8xq5ncmpbm39swnnw8e5q3r8qxpynkhy
X-HE-Tag: 1795296147-530756
X-HE-Meta: U2FsdGVkX1/lkPMXOz2UYdsdPZP9zF/4fx0dsxPb2n1urltK0DwCrwZ34yduPq/PgwzP+ctejcP1Rev1Exlm15CqANivaJDyh7nIAc5vhvjOz3SBU5rpnu5QGkk3CFI0p/+GDW48ViiQpaqofNMR6e/OfKFqCAY1ZnEn0r1CuIdhQoF4bKKcrWYmWad/7vnpinp1nkCgzKhs4qnoYQi2KreokCuP6XbeU8kPgDMe6AH/FcGI2mil7nhEMazi8l9fCaA3vtVFn59uVedexA50pkG+C/OZr43efLTHX4exzSHxngKyFOvoxinmFnpLnFapQpEcVj8xcRnQAWuSntXZjluJYRHP7OP1RTKYxDDiamhSSUqDWuh5vaK4K1+i+WkGarN1tgdPJcgn+bTDiNi31ReZH558onLZCiNfpxbWJdDPfur5pEQF8eH/9fh64eAZCi1KRgoz/v3AC/1MGHnM5qqAcUZNXluUIH4+byjcD5jAjeJ8lBxSX3V8FzdhhO524VixPdF43I7RfXAmt2P5QhRbPYVeOHwqzYJXuUOp7NCexukqSntr5jqAcHYcPG2MQ+77VQ7TlmXWpNFma+peLCmpHGDsJuN6u37vcl+hKsk5185ZaivciX7GC/z3JJdExeUjVz9snF6r3Rb547rILVHqsmVxlYjX5WHvli/GPnak4UrYJUR8DKALe+cpkBdTXjEsazXVd0M7MFEyTduzM7yykPVAl6MK4Da+/QlZhK1SkSBtbEgHUxOTd/njOGrdfh4Cu6ZfLrEAjc+HmabV4ZoUMM1B1fnRFj3agSDpUrzq6JMCo6QA5P0nFsljogPYILRMgwKgw/U+nilYxPNWfFO8SYO98RTVPNJfGTbU68AmfQ5II44nti66ZLZQie2DRRDui5A6/9bDVGLBFalL3jAnHOjmiGFGrD2VI6HPYJPYZgEQl4MclVyFk+oWx9d7ZkLxJJALOOmf/Afz2xf
 hHzoB2T+
 UGbpUY//kNF9FoQgscl3rOoZRnN6wfLanxYT0A5s6Sxpq6m930Ow+S+OcWiDlkbCMhFIRNx2wkcfmCxFxuDc+gR7sIpo+7XqpMbouEkHpiMl4MzNPkd8v3dknayruz9nbym4GsQaa9phkioD8kCKt+0bBvCHIJtQ6VRTbnZBtkT5UFpxX6Zzr+otIKWwBzWyx9pz6qy7qv0fzxXtN86VUYYoKf3zFP5hiIl+PFAiT7TcHg9hFnAmHko7obLDLkghWx/HjnLTYbWSDMemxbTNxt3DHAjU75uWZ59SLYd9Y6RXDiRtnAWOgCM6IvpZwQWe4fS1kRfFsrAf/YIQZTN25Oz+3rJ6x/xhEnd8vxWE07cjKD0Y0MWCYp/15QIWD/d45BcMwHAtjcI6WaV3OWjsh2T7nM6+4vXXZS/PkUqvg2nxfN9Pk7BWZVtv6GcFUgKRQrBA3HxoULXgBXQzueYuSY93DZBvf7i38sIbg/CM+FUXmlMVpzZfx1ettr8XyHCH6SCLkFpHzFQSLfwD9YupVbsge/7Q2Krq0UyqFh++uKZvmSxvW/stxw6FY7rkPzF9TrthTUhnUMqSqD49GoH+b3eNI8TJamTSyOHqDAsh8/7iLB40QsjBr23WFAQzd2zzbS1LEFD0nLLcnBB8uR4z+Osi44DVZ3+nadlifVEHVflnHTriNXd/ctQ7Ff/JGXIRSWoX3IRTO5CyPc28ggRae0LS/oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 8:20=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] crypto: acomp: crypto_acomp_batch_size() checks async instead
>   of req_seg
> --
>
> commit 4f8164105102abaa98a8641d32dd35c9cb223ee0
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> crypto: acomp - Add API to get a compression algorithm's batch-size.
>
> This commit adds a batch_size field to struct acomp_alg and introduces
> crypto_acomp_batch_size() so callers can query the maximum batch size sup=
ported
> by an acomp algorithm.
>
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index ac4dc52668b89..df9e42f519c35 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -327,6 +327,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
> >  }
> >  EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
> >
> > +unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
> > +{
> > +     if (acomp_is_async(tfm) &&
> > +         (crypto_comp_alg_common(tfm)->base.cra_type =3D=3D &crypto_ac=
omp_type)) {
> > +             struct acomp_alg *alg =3D crypto_acomp_alg(tfm);
> > +
> > +             if (alg && alg->batch_size > 1)
> > +                     return alg->batch_size;
> > +     }
> > +
> > +     return 1;
> > +}
> > +EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);
>
> [Severity: Medium]
> Should crypto_acomp_batch_size() check crypto_acomp_req_seg(tfm) instead =
of
> acomp_is_async(tfm)?
>
> crypto_acomp_compress() only dispatches segmented requests (where
> req->unit_size is set) to tfm->compress(req) when crypto_acomp_req_seg(tf=
m) is
> true, and otherwise sends them to acomp_do_req_chain(), which rejects
> multi-segment requests (req->slen > req->unit_size) with -ENOSYS:

v3 response:
As described in response to Sashiko's v2 comments, this is kept simple
for now and for the only known use-case which is acomp_is_async(tfm).

v2 response:
This is a good question. When the patch was initially planned, the
intended algorithm for batch_size > 1 was async, that too for zswap to
know how much memory to allocate for batching resources. Plus, we did
not want to impose strong semantics between batch_size and
segmentation for synchronous algorithms. The only known usage model
for batch_size > 1 was for async, hence the gate to prevent unintended
side effects until we know more about how to evolve this.

>
> crypto/acompress.c:crypto_acomp_compress() {
>     ...
>         if (req->unit_size && acomp_request_issg(req)) {
>                 if (!crypto_acomp_req_seg(tfm))
>                         return acomp_do_req_chain(req, true);
>
>                 return tfm->compress(req);
>         }
>     ...
> }
>
> If an asynchronous acomp_alg sets batch_size > 1 without CRYPTO_ALG_REQ_S=
EG,
> crypto_acomp_batch_size() returns alg->batch_size and callers such as zsw=
ap
> will submit multi-unit requests that fail with -ENOSYS.  Conversely, beca=
use
> base.cra_type =3D=3D &crypto_acomp_type already distinguishes struct acom=
p_alg from
> struct scomp_alg, requiring acomp_is_async(tfm) forces
> crypto_acomp_batch_size() to return 1 for a synchronous acomp_alg even wh=
en it
> sets CRYPTO_ALG_REQ_SEG and batch_size > 1.

In addition to the clarifications reiterated above, this is an
additional v2 7/8 response:

Excellent questions. For compressors for which compr_batch_size > 1,
i.e., zc->nr_batch_pages > 1, that batching algorithm's driver is
expected to test for req->slen > req->unit_size and use
req->slen/req->unit_size to ascertain the # of SG lists to process (in
the case of compression). Please refer to a reference implementation
in [1] and [2].

[1]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-17-kanchana.p.sridhar@intel.com/
[2]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-19-kanchana.p.sridhar@intel.com/

The crypto_acomp algorithms don't use
zc->comp_ctx->sg_table->sgl->length as inputs, these values are always
over-written as the output of compression (patch 3 in this series).




>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120041906.57=
85-1-kanchanapsridhar2026@gmail.com?part=3D4

