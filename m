Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC463606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B1v3ooI7
Received: by kanga.kvack.org (Postfix)
	id 125426B05B2; Wed, 28 Oct 2026 23:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5C06B05B4; Wed, 28 Oct 2026 23:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2E236B05B5; Wed, 28 Oct 2026 23:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C66276B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:06:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 583201C2177
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:06:03 +0000 (UTC)
X-FDA: 85374174606.26.2DB6AF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C9ACB140005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:06:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B1v3ooI7;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793243161;
	b=Jscks36P5KRKIkbHAdgC48w8zEU8FeKmps9HxRIdMrRSkv08HkOeGAQpbsxdiBeLqq4mP0
	j8sKMWtFGKWJxKvom5Ynjf/ZDgx7o/mwOODHbqObTdU2zsfpQPkExHtdvWt6g+ic9sZjYf
	FtKYmKdiH52SZpYouT4tQkwJc4o844Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B1v3ooI7;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793243161;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBnn/OUg7PxXvo8p3nJ/SroKfFD1H0Hr92Nww3NdOjM=;
	b=iJV0kcSCjKx4KKMNYb4quG5TN//Abg54Tnf7jnbXrs+/J5OSkr8SeTHrwDDWrazoLc33pe
	goh5HtmFzbf2TsnZzTQiUHRO/5NFzog2pW0GxgapWzSGrCTqVJ+OJupL8oDy83Mfzjh8NB
	m6DPMqY/CG4fDwGuFCc2jQAhTfv36wc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B02A600DA;
	Thu, 29 Oct 2026 03:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8141F01825;
	Thu, 29 Oct 2026 03:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793243160;
	bh=eBnn/OUg7PxXvo8p3nJ/SroKfFD1H0Hr92Nww3NdOjM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B1v3ooI7lpqk6Men20s5ikVdhaQOBtMk3DcYDpo1whk+KkTP3E6j+lRTgzxXS2eAC
	 k0WMhkatNRdifPO2fA8vfanB4te8HhYIK2SkYgcM+i8MoeJiyQqCAlwPyfJ6R9eitt
	 XJOl1m4HfKsdG9f7r9JrzuFRlTpjlpogx1xwBYQyHWobyob+EOTV4v1Ny7wtbIemkS
	 +OFP/wU4POmBxBK7OhO7J3GTDl/vTbCmVOw2tQEC+q47TwZToOe7cmuE05a4sIz9Dw
	 HCxWzcsuhPZL4wGRWyAdjyxiH/Fww6nne+H3+zm92JHSgs7WzX+NXex7i5hk/Scm1H
	 HnrG3ZT/IIUJw==
Message-ID: <sashiko-outbox-188655@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation
 wrapper.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261028030503.17923-4-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-4-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 03:05:59 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: C9ACB140005
X-Stat-Signature: ujytocof5xt9xnx5cs88csh7ddfuupye
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793243161-859701
X-HE-Meta: U2FsdGVkX194acfkQt+o9PmwWMV3DO9WXYDE8DYVhXGg/f1IWKBqXcMfxv33BACxlUOehdmzt/Bv9hJqor+2q3bhbL7B3fxUvisZJnlC7i7dW/HO7qOLB3oCYNtLa3iR/kNOKDsJxYyCsGffi3DmazsaI3NrEUw/yVAoozyomwPlheuNr+VqI5DHtHvKZgwWxlZh0idqhHD6nYRtL6pe7PqQeTQrSRq7HDiTvrBn/Dntom/GegJouDRm/BkaUymXa3S6kGLtBYmL7roUqmZbfk9GdXtUYUE/0mSY1uWWl9LCF0JAPGfo4L7XSfOTj8952LfDcRVxCkk2bYErpYQqxTjuC9g35zfKA9/pksHn2zlB84BrZ735/UkCXnmw+3QSK9FzZOoJ4tcZrXNeQ2/V8mv4peLtuCxGuCFFeOzRrC59+a1SOhv9j/Hernp9iHD3TWE6M0ycyozlihLUiIOnEEO+9Grvqq2vSYl5yyPnDi+Ypo9d05lXj3gFVBJMwOMT2rd6MkEsE55MjH/3FGzZLK82SJ5yVPhJDTRaPhQrkKMEx/TDm0bShd/xPLVicNMyk9GAYY7AqYQQOFSGFDOYN7f4goiHYOTkBh9MvANwxeBDtoN4BNMDCFNzqBx+/9b7/bSzcYk/M8EjuOuqE/GZPRWTgXKYCdHQzemZBa8lh7dwp4bEuwphTHBoEKd8hsnOUbZa4hcc/yG6K9aBTFXdHPtllKl4SKJglc5F1v0Z0qI5I6br032IouoKMjyqIpqI6O7fZtfe94skma1giPJfdbxYBbBUoSxbNwarzugE085PfDF8FKMUAbmYiYpjxRIYHAPE8Tw6cGm9T2kMkAvj0o4XpCSh6latp6fUTgj4qjfj568APykLt8UETDoDdb+zQfs0gbiruJRTw2j/e6cJ1PNLxG6ms7AWL4S2kaztD6hkGG5lz+tE5heoUvCGdGj4D8Ss//VvG4cgQp+tfbV
 11rX4424
 +qryg4+EoZv/WpE1k0b7g1SSOFjwIVcta/IogVbbK3Avw8p2b3dMCVQ0/VBQD2j+RPt12jJm+AZfPWD++Z0jZHdpDNvAZPsERuORqX6k5D3SbgLUAJku9iXEYzwg4i7UE5C4drjkT4Z28fdhYGB0hoEVXZGW06OeTYgC5hp7k0W3H1A4PtaOFO92i9xWT1S5W/r41pkbu5FNZqtoXh9IWEs2hXZ6xYSui74nIP4pNTH7jP0+7I4EeFPVkHmQoXV4w+DWEvV2qa1ZjVgJCMYpmLCERy670539K6b91yuJA97TSi+FjrixgQF61Iqt6WJ5DscN4N9zKysX/Rt6i1ajFv5orDoI7L4nGi2MVr9pxer9bkjPq/vtojN4kUcRfFLSKiYBebs1BRiLfQPY9g9rfYt/nVl2UVecUe/lOKDlIrbUIEVq0vZ/S4U5dzC6g4baV3ol2SxdJ2iot63D/1FGVQ+P/g+1cblnzurwmZOK61ZS+3UGM9rfVIirTxIPEJ/fVMQwKVVrKLAAsj211Y8TNkQdW+5w+S73qPn76VrEri3I08KmkWAZzq6BLKUBi7qMj2uCb8rKLKBn9nAwyseo8/ZeYag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] crypto: acomp - missing async check in crypto_acomp_compress()=
 fast path
- [High] crypto: acomp: uninitialized state->src/dst restore in acomp_reqch=
ain_virt()
--

commit 7144b07b2cc5b6704699fb53fac44c4270d31f7b
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

crypto: acomp - Add trivial segmentation wrapper.

This commit adds a single-segment compression wrapper in crypto/acompress.c
that stores the compressed length or error code into req->dst->length when
req->unit_size is set on transforms that do not support segmentation. It al=
so
adds an inline fast path in crypto_acomp_compress() for single-segment
scatterlist requests.

> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index c8b4b8589769e..c55b0e8eff3d8 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -166,14 +166,20 @@ static void acomp_save_req(struct acomp_req *req, c=
rypto_completion_t cplt)
> =20
>  	state->compl =3D req->base.complete;
>  	state->data =3D req->base.data;
> +	state->unit_size =3D req->unit_size;
> +	state->flags =3D req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
> +					  CRYPTO_ACOMP_REQ_DST_VIRT);

[Severity: High]
Can moving the state->flags assignment from acomp_virt_to_sg() into
acomp_save_req() corrupt req->svirt and req->dvirt when a request is
configured with acomp_request_set_src_nondma() or
acomp_request_set_dst_nondma()?

When a caller sets up a non-dma virtual request via
acomp_request_set_src_nondma() or acomp_request_set_dst_nondma(), both the
non-dma and virtual request flags are set in req->base.flags. When
crypto_acomp_compress() or crypto_acomp_decompress() calls
acomp_do_req_chain(), the call chain is:

crypto_acomp_compress()
  acomp_do_req_chain()
    acomp_save_req()
      state->flags =3D req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
                                        CRYPTO_ACOMP_REQ_DST_VIRT);
    acomp_do_one_req()
      if (acomp_request_isnondma(req))
          return acomp_do_nondma(req, comp);

Because acomp_do_one_req() returns early through acomp_do_nondma() without
calling acomp_virt_to_sg(), state->src and state->dst are never initialized
from req->svirt and req->dvirt.

When acomp_reqchain_finish() then calls acomp_reqchain_virt() in
crypto/acompress.c:

static void acomp_reqchain_virt(struct acomp_req *req)
{
	struct acomp_req_chain *state =3D &req->chain;
	unsigned int slen =3D req->slen;
	unsigned int dlen =3D req->dlen;

	if (state->flags & CRYPTO_ACOMP_REQ_SRC_VIRT)
		acomp_request_set_src_dma(req, state->src, slen);
	if (state->flags & CRYPTO_ACOMP_REQ_DST_VIRT)
		acomp_request_set_dst_dma(req, state->dst, dlen);
}

won't acomp_reqchain_virt() see the virtual flags set in state->flags and
overwrite req->svirt and req->dvirt with the uninitialized state->src and
state->dst pointers (while also clearing the non-dma flags), causing a null
or wild pointer dereference if acomp_reqchain_finish() then writes to
req->dst->length when req->unit_size is non-zero?

[ ... ]

> @@ -279,10 +289,27 @@ int crypto_acomp_compress(struct acomp_req *req)
>  {
>  	struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> =20
> +	if (likely((req->unit_size =3D=3D req->slen) && acomp_request_issg(req)=
 &&
> +		    !crypto_acomp_req_seg(tfm) && !acomp_req_on_stack(req))) {
> +		int err =3D tfm->compress(req);
> +
> +		req->dst->length =3D unlikely(err) ? err : req->dlen;
> +		return err;
> +	}

[Severity: Critical]
Should this fast path in crypto_acomp_compress() in crypto/acompress.c check
!acomp_is_async(tfm) instead of !acomp_req_on_stack(req)?

Callers using asynchronous hardware compression transforms (where
acomp_is_async(tfm) is true, such as qat, hisi_zip, or iaa in async mode)
allocate requests on the heap with acomp_request_alloc(), so
!acomp_req_on_stack(req) is true for asynchronous requests.

When zswap_compress() submits a single-segment scatterlist request with
req->unit_size =3D=3D req->slen to an asynchronous transform that does not
support segmentation, this fast path will be taken instead of
acomp_do_req_chain(req, true):

crypto/acompress.c:crypto_acomp_compress() {
	if (likely((req->unit_size =3D=3D req->slen) && acomp_request_issg(req) &&
		    !crypto_acomp_req_seg(tfm) && !acomp_req_on_stack(req))) {
		int err =3D tfm->compress(req);

		req->dst->length =3D unlikely(err) ? err : req->dlen;
		return err;
	}
}

When tfm->compress(req) submits the descriptor to hardware and returns an
in-progress or busy status, won't this immediately overwrite req->dst->leng=
th
with the negative error value while hardware dma is still in flight on
req->dst, and skip registering acomp_reqchain_done() via acomp_save_req() so
that req->dst->length is never updated to req->dlen upon async completion?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.1792=
3-1-kanchanapsridhar2026@gmail.com?part=3D3

