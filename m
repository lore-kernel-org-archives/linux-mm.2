Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E400B606A33C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJVUYjQk
Received: by kanga.kvack.org (Postfix)
	id D96266B05B1; Sat,  7 Nov 2026 02:25:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D205C6B05B2; Sat,  7 Nov 2026 02:25:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9ABC6B05B3; Sat,  7 Nov 2026 02:25:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA956B05B1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:25:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2DC7A7D22
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:25:09 +0000 (UTC)
X-FDA: 85407486738.06.0543668
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 565EB160003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:25:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJVUYjQk;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794036308;
	b=ZkE/O8DEQ2HnQZTh/hHs0Ls3tDpUUCUcSgjaFS7BtndCT+4dpeom/BleAH4w0DFCihtORo
	sA5tFvdHEr//am4wG95+gFws4zmRpp+DPIKicqfYieomQEHheENvrioqVpUI5JTY2bDue8
	RUriEXShlgE5pt1PRh8A6ApsfkF4/Uc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJVUYjQk;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794036308;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgN9ogDRRfRK2oexKDdbAOVIB3kCwunMAnWHxeIq0w0=;
	b=QV+sFff6fBMZ1KO78AIcgatePa8UNQ36IVOn9AtrrqwxCIbweHnea8P2dTHrBbWl41f2LR
	R/W7Sb9jrM5rf0sOxPnzgx8apCmOw4tZYLKbnimZ1gd3Jlmy9bwK2EspzAkgu8BjUYAXSh
	fIeHZk/H5XN2fjCkkpfMp8NkM2qPFmg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC98743979;
	Sat,  7 Nov 2026 07:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF62A1F008A1;
	Sat,  7 Nov 2026 07:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036307;
	bh=TgN9ogDRRfRK2oexKDdbAOVIB3kCwunMAnWHxeIq0w0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DJVUYjQkXVy8QrSbj0lQ/02xBLylp9eHAUe4LuTBjg94FTrisAs7fomyvtqGz2m/B
	 5yUTsmXO7uO+imVJN35EnBt1mlexyH1oMHf0S2Mzyn1FWUol0daV63rup2cACFVTo2
	 MmnXEEpwN65LTKg8BrvyC5wFsr485uXyt79SaPYVlIlXqulm3DdQIMhBHg8tYNeL2N
	 whR8e0pudEp6C54X6dGAcc6aINtFA6WI1D1zyF9mrmPRRyvk2o2BFcm2go1aLbIGnf
	 YEk0ZzuF6rDt1fflPiiSVyBBQO/ZHfrU9HgCeMfP2b3Oy02AAdkpT+Y2jVwpb+HBr2
	 x/cuso6kfG8Rw==
Message-ID: <sashiko-outbox-202710@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/8] crypto: acomp - Add API to get a compression
 algorithm's batch-size.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261106072412.7909-5-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-5-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 07:25:06 +0000
X-Stat-Signature: hg1gq84iokkoft17iqbkdbzc1osqxrto
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 565EB160003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794036308-678369
X-HE-Meta: U2FsdGVkX18gs3bJG/F354aaq88uwodMXUWXx2Xp1iGh9xmccaqTRdECIRN+yoG2kOBhZ5EXMEqqAR9Ik/Tinac+1Roggh9D7paAgyG7/qhVDD4Ta46httbWuMP22PhSJZnbbnmY1szxxsZ4ws8qKu72N/ACXDe7XyqdcEzV4zQ93Q1lJ+iH80BYSyUiEibvWtpvRJhW1PyyWJ/KE3OdDqtaxOJ1BPizQGDJjuUwGKNt9tkFG8n51b30mMQlcfFg2ynBDB7w3be4Lw3weBUt5ftMey0gnHS+1bRaieIBfupygKQUc7vOhHlhgJQbNaI1XfEbhZnw/0hpoxAL+0pMmE4dkbPfLhw67pvZO1LTwkSvdt8TTuJE9TSV3L4jzY9oNc44VR9bmQhJBQKDuI6hIAt+xqw9YldW3W9EpmcBUdglKBftnGIZbUeMm4sOU439dEp8fk+vUvltN1EMHx+W7ZWRWlIZo48dEsNGXN0FLpY5j+JjvpLZIQ7gTlF155WadBk9ausXCTS6q3PS1sMcebmmOx3sQxcSq0bjW2e2wPZnWQOmMpH7rQ9ebqXJ5sw0M3yJTl6BmZArb+a1mANf2anzIRMq/f5/zUp0h8XTjLT4XW0APq6XG6bXd8O5mvpizXap2rGT8aRRjAb+PHODn3UkZ+w/lCZeJxHQ4sSSkz5uSlDWcFKZ/ri80mClQCsO+6GGDEHKUv9cVs1/f8RxCp4HnRc5mcAzfj7BWXoelEDdI7+5rWFss2qYX46x7UNR0eVVS+vvQeZAUMN8zVl1M9MJHRrPWFKSj7h/Jww55u/zUJonSfkqEZrD6Io7o7X95XtAghw88RhhsU60SVHo0Z84d5B1LYkNA6+M03jCtJ/VDPsBvTk/UAOdGjvKmu8v+Y7QovKVb0eyDetBGxwW4/8V4E458LBaAXsr5O553sDb78k27xoGoMfYATF02jOVJBnkBSZmIv1ED9dD7dY
 2klaHSKv
 7XxFXNucRvyf48vCVkWl+S0JVXCo+A1VAmIUrZIWy2id1LxFY55V9VyVhbdVHXbjXIcK6H0Iha8W0U2oEEBFzcvGfAno1U/8tcrbQhKW3SFcoGRQyIjGsR2evdtgIp1mSZE49XyTX7ue7Tns+Tcn/Fe+M931kUehOs7OhUJkjlbkFuxrOpfn7ucHsJsQEAz9DkEYurIJ8sFVNhkUblD7ulniG6Pe4KFgqAfHqzDrBoQZkAyahT4TRPolUq+rQ4kVVeO/2FsT3foDQnnu+JHnM939NrIe9EuqfyvN/sQ49fCBV9SwpIDLlYyEJfi1TfRiQPgLDqB+wtM3SDRJ0H0SLvQWOd3nEMavStwQBPMR0Ljki36rhInK9KDi0ka2pj5NQsXZq2y1HAZSu7CS8n2noA3nyifo94zFfLH4OSCj14jDH6KHyikBhUm9bbWq7BYRLYfgmIAMRKraz63z7RBB8fA2hZmzmLf2T0Znu6MQAhH9GUh1fJVB705Cdr+PeFaM2jzQT1YcXdjj/ewbpvW7kIZgM2wb0tPfOTXq/zt7ujThd4sGz1Qc7ko6GFfe7pj3ulB2W2carpXIWUYNiKhnOnWKsVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] crypto: acomp: batch_size gated on acomp_is_async() instead
  of REQ_SEG
--

commit 2fa95d403dcc5d6c7b702698b0e306a5d643d3b3
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

crypto: acomp - Add API to get a compression algorithm's batch-size.

This commit adds a batch_size field to struct acomp_alg and introduces
crypto_acomp_batch_size() to query the maximum batch size supported by an
acomp transform.

> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index ac4dc52668b89..df9e42f519c35 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -327,6 +327,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
>  }
>  EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
> =20
> +unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
> +{
> +	if (acomp_is_async(tfm) &&
> +	    (crypto_comp_alg_common(tfm)->base.cra_type =3D=3D &crypto_acomp_ty=
pe)) {
> +		struct acomp_alg *alg =3D crypto_acomp_alg(tfm);
> +
> +		if (alg && alg->batch_size > 1)
> +			return alg->batch_size;
> +	}
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);

[Severity: Medium]
Should crypto_acomp_batch_size() check crypto_acomp_req_seg(tfm) (or
have crypto_register_acomp() enforce CRYPTO_ALG_REQ_SEG when batch_size
> 1) instead of gating on acomp_is_async(tfm)?

crypto_acomp_compress() dispatches segmented requests based on
crypto_acomp_req_seg(tfm):

crypto/acompress.c:crypto_acomp_compress() {
    ...
	if (req->unit_size && acomp_request_issg(req)) {
		if (!crypto_acomp_req_seg(tfm))
			return acomp_do_req_chain(req, true);

		return tfm->compress(req);
	}
    ...
}

If an asynchronous acomp_alg sets batch_size > 1 without setting
CRYPTO_ALG_REQ_SEG in cra_flags, crypto_acomp_batch_size() returns
alg->batch_size, but crypto_acomp_compress() routes batched requests
(req->slen > req->unit_size) to acomp_do_req_chain(), which fails with
-ENOSYS.  Conversely, requiring acomp_is_async(tfm) forces
crypto_acomp_batch_size() to return 1 for synchronous acomp_alg
transforms even when they set batch_size > 1 and CRYPTO_ALG_REQ_SEG.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.7909=
-1-kanchanapsridhar2026@gmail.com?part=3D4

