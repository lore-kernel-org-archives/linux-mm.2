Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7EDB606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 05:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eIhbNjvl
Received: by kanga.kvack.org (Postfix)
	id B0C736B05B2; Thu, 29 Oct 2026 01:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDAA6B05B3; Thu, 29 Oct 2026 01:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ABDD6B05B4; Thu, 29 Oct 2026 01:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 692E66B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:49:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB807802C3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:49:16 +0000 (UTC)
X-FDA: 85374585912.01.AFE600B
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id E47DF80003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:49:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eIhbNjvl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793252954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qO35EV0mnWV9G43hoQX9fpVz/YShAelE6s2Ci5t7qJQ=;
	b=TvBoaSOR+/SYRvCs8hfhVhC9ul4aTrjAWoIuSAlBHj2O8Eq9rDIrmg5ZxldIdRfpsDVazS
	eNKlQtJ4rhjrN4e6zzlGTnAf2Mb4rtOyUncPPj9IuMEqgxWhS+ZKKFS7wnXDTAAs+68GbF
	LbkU6Q9Y92Y1vUDkjIpzQmhoydnNxFM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eIhbNjvl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793252954;
	b=m/wJsFodGlGFNKs2f9nj5FwQtY9jMck2xsoo/1y9/nOWf/owIrjRFzvCLn+xdmT/0PI7//
	PYn6CWd8VHq0isOKZzaoaGSi1OTqnw7WsuR2jr34dpRkgLVFfrE5mdp6KAdWpXZXHRiZE2
	Cd8b4jlWw4ggWetUZMA0eEabY/XJUE8=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bcb1f1358aso1324853e87.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:49:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793252953; cv=none;
        d=google.com; s=arc-20260327;
        b=DaIT3vYh6Tqa7EFLFwjIoTcJ3Xmb3cHJftzMQrUMed6xubipPrwVdS6FqkXoaO/6I8
         baGTZ8MvsCCIplstl7qZpicgKhGyxkR1WCJ76oLj7KvjJYOe2rlPIs/LYRv0XKAKJ1aj
         vXEBUEB2PR5VF0UagxeJp5a2Z44TDwxoKCpYh+0ys5Uq+Q2+GoEPguQuO1DArsqhKxF7
         EYqHhbw4VpPyl+X7CGGs+AiT8xi3O1A01QZAxMgVbzScb5iLdrTU2L1P32h2QTY7vZVe
         4TzyW1g4ZrrtUiRaxfLRqVy/BbkmzWDg3yYpGljbewzviTGTptYJIqRr1rvR864Wh2Sj
         xFSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qO35EV0mnWV9G43hoQX9fpVz/YShAelE6s2Ci5t7qJQ=;
        fh=ZgZL0u2840totQWLE8+ZReBCcaprlCRaKCAnBjk8tCg=;
        b=U7tAIyIQvpoHR0DLdl9dbM1fTek3zOelNk2mLT4ua2B7t3jHUVm3IqjaNFoAMCW91Z
         q9ccTf0FjYWulVYRy69LR3U1pwZ+IyLEzzj44BOB4xsDMqFvMAb1zsc+4KDOsntJvaqV
         aYJUWIJykXoFICNwBZqwyL6Zsa9nHM5uWbN0Dc8s+L8XbJbDQQPEBY7BD+YxYxWNTBdp
         tgLwbEFdV2sMdJDX4F6gFyBckVsPHoysFlItoy4IzYkMGRVdUIO+c50ZE7K5VOL8raCG
         k69TG+Xh6nudD8xVa6sTUDXjWYScKJjVwnHKQ4tWIoQxtPgPjKlNbVG9L6WZcAomwImU
         Qa4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793252953; x=1793857753; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qO35EV0mnWV9G43hoQX9fpVz/YShAelE6s2Ci5t7qJQ=;
        b=eIhbNjvlr4Oh4WDMNkFsishGmEHQi1VPgXi/toTGnU9stpc+vuN1+spaaWYctCCioE
         gH4QhVgCIHhyHAHZ+uVnfuX0IgUXm48R1z7tU2UgM21g2jmuUiJ9RWGQkqZc2IwnqXvV
         cd+ycBQrAU/YosZyNVwe4BWKvvUkQ+mzmyr+RcgBD9shLf2WPytzprU/FDUXnhNfG+VX
         QaDFUR0ECgmRRMNgvp2XpsLawY9SH3uIp5e1ssGHpaCZecdE5MZmfQKno36YJKVgOaNW
         e7G8hknLJqGZtCTmEFLAMQmgpcgI9lJgHtl04OskXwWL2tf/a32YN0wIR5vgycmbNyhK
         jTwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793252953; x=1793857753;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qO35EV0mnWV9G43hoQX9fpVz/YShAelE6s2Ci5t7qJQ=;
        b=IZZ0IFU9LqQhaKSSkRZ/EN10QJDPoewouQQEb3UMFlRNXKaW7pD/LS4p/T5RKzXQ3D
         W5mdDZ0k7dHuh9aUtxGNUQ6XG5a1M+YWPnpyvh9VO6dG6ECWKVQ954/C0j901wDxuPI+
         yv7mNP+BkJncUywpQ69jloOBKMTZ+YoTc/Iz7tmavsEH42/9pit+KZeHZ4UCLwyCwvRO
         PjQTphsNDh1UFeBkaaEm0/iitwFQdTYpnQyCRqZq4ywkozBHi2WPS9i9zKZ2uYCAjxcY
         w+wimt/Aoz/DYVfCXI7J8hrEQe7ftelSPQOttzwFGxDxOyarE7n60CJS/+rVwHc3ddbO
         zIpg==
X-Forwarded-Encrypted: i=1; AKwUvBy6JAqy6wJwnE55sF478zO8Wku09pVsT4eAEJEqspTLQ5GLnQRejMHKWh2xQxjDnoe9kzpPTvs6Vw==@kvack.org
X-Gm-Message-State: AFq9FYLsUHgAwFNkbwlxAt5vYFVj/VcmCZzQPYOuONw/JwXCGSBaOgr8
	DM/RVl+0RtFwvfW/GnYL4LREqsP7wzul6paCS5xP3WPVtZ9WgNZHTh2LmrXl8AB00mNMp0EF9fY
	u3Bd/ILRdwvl+9NAAIuVP4IWICg7FYJQ=
X-Gm-Gg: AYBFou0e0sA+eNRvrcwmhL5YBnJYjmIABdtw9+olA18hYQcz8lYmmg12jmDT881YgUn
	Hvke2n6n0RKeLprag87Mt+s41Lcs4ocpYDZlqyIxGhuLoQM5ZO2eICa1CQWOK/80B4JtCOtoRtG
	7TWXFugCv0CbDuukYuXDB0qweTJ/ZQewe8YRlcQ7mYdF3pZW/tzQ6t/3hvVIVASdR+NfppC8wP+
	7DWPZW/QWPYYrVNOD8j5SIIasOh+CEBBjBU998MYjLuNLzXBHwhjxsgWYds+IUNH1mEh6/vsbIM
	UFAxLFwA8dIAdmbSbV0gxn/uI9QQENQ6u0/aicjlmXk3wRUAMvCiKLqIHJRSaAGKDAq7kGsh09m
	xsuj1M6WMsMuNsrxAf+obIIlfxPf6aHd0CV69
X-Received: by 2002:a05:6512:3e22:b0:5bf:ce85:4d55 with SMTP id
 2adb3069b0e04-5bfce854e61mr1159757e87.33.1793252953140; Wed, 28 Oct 2026
 22:49:13 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-5-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188656@kernel.org>
In-Reply-To: <sashiko-outbox-188656@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Wed, 28 Oct 2026 22:49:00 -0700
X-Gm-Features: AclHuK86TsSiLkFwQ-i4UWDD9J3s6NPe_Yms66pEsTQGm5NwMn9Bd4NlQj7Tw6c
Message-ID: <CACpmpocJNk=WEE0_MiRUoWNJGS9wy7inKQ2pM6kNrdxaxgt0qA@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] crypto: acomp - Add API to get a compression
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E47DF80003
X-Stat-Signature: 1qn5srtzbxksqtkxiamme7eku68b8mjh
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793252954-151923
X-HE-Meta: U2FsdGVkX19JTsuiyuH/XDBc4/mVjIuZNBzs3xU0i4KEIVT8XIUWoZw+cxDBQmNAyKA+k16eyGmSVNBgZujMRkAi+uP/ZbTKplxxXawhNHNdvutZuG94MhmkcZ/Z/zNZgetHagESel1H8EvrQ5Qd/SuLDpmcp28U4nC4n/TnAoNxZt5u8QDMC+aojKGjOajiCCNSUqMOnR7qqXdoQaojGWt7KW4G8VxeZW5pfaC45mubCvRobwaJ4+XoLlp59HpJxeTM5vD9yU6Kg9R3EZZHfN0+W/W4YbLnQFvA6vETwWlVxqVEo0TiWSwT/S5S9Bf9hDe8WZXYpYszwHrL5cIDtdCJJqcgFlrNJS+iLWYI4t+EYzjrjDe3+ZLtWsI8vCd6fiALwr7OV/TnLqH9Y00dub9SRvVEY6luL/GaggSVXjL2ZEz7JoRWS6JF1HrOAbhXvgK5DxuPJcNbmAJy0cZgjJqbstL+QQXf8W0iveTJc7XEiH4W4tWAHnCkMo8GN8HBPyswR7UoRviytnHWnnEPOJUsZDhu9sQxZg2H1Mplx0ZxFJgCTsVV3hcpExKA674g1s4+Dul83BjztjeLTWe57jbOpdeWy94Lk1pfCCZuIJqMtOYJz2AeUV0CoB8RKNE6NIZpp8eMf7ZCAUrfkEIViHmmo+TJ9mj4iNM+nBAcj3QKUELi7IAXFGCC3p7IC6c6AjlnltFD4Rw8dZranjcHT1eUAH6FlSK1f1FZBW0BgSrLL4TYBgnMwJOu7lnpyZocARRbIWMPodHB4Hs8waYO0jrU97pFD3DRxbrwQmZKz5jewfKbPsoa6ZhhcJft0/qf2uCxpOqi08qtQR8lfNoTPqWwpJDKWDgh8tcIvLCwPwrq6PexhqygZdlerl8otOLB5hRtGFJ+dArHpJICbwgn0EQG3ID0Z65/PoH6C3gXCNcB9qg8g4jAFdwUj10IS80OiZbsJG5xNRGAkwE+Y8K
 P+UeWHjg
 Al6xkDTOtj6QcVT222mfELbo7geGcqsrowbgKdc4Mj1Dgfnzjw7gXpSRTZI/ERxQgHOcAefE/CbEZOiMtFMdLNwGUApFKFtvGPieBYURf0LOX0dc4p7t0n+EodCmm+oV67V/wyDgYHbJNqADE/iKusvC7sqFyUxbg4NRyWauQ6qiQjX5bmZU2jpGa+zgFt4/Dac7xbo0vboDg/g19Mz98due83xBRNlAepmRvn3/lzMOqgi1KjeT5tK1e39xRk0rlykhd2Eji+ywRn/LcZXB0SgQkp9yJBDWe18fa0FaDDSQldhpvK/zuXi6GZXEmPrsrgR4aIZlMnzkGFnxrCFC/qD2KUGq+OCyQuPzN77iMldibTAbIxzixg2QxYQV3tfhZttK2/vFEWlfAkagEAkKWyWctkm3f8IU27Z6BzDsv3MGkVI5xcfx2T3Hri+LNrRjmj/kNwK70JAtGrGSfghnrnwn/kcS1q8VJRfW6sN1XgnaiCClHyVoMB3hO9s2EuBHxwPmr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 8:06=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] crypto: acomp: broken type check and async gate in crypto_acom=
p_batch_size()
> --
>
> commit a38b95e87019ff2c11b51ebf159a082ec340456f
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> crypto: acomp - Add API to get a compression algorithm's batch-size.
>
> This commit adds a batch_size member to struct acomp_alg and introduces
> crypto_acomp_batch_size() so callers such as zswap can query the maximum
> number of requests an acomp algorithm can process in a batch.
>
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index c55b0e8eff3d8..8e285cb7477e9 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -326,6 +326,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
> >  }
> >  EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
> >
> > +unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
> > +{
> > +     if (acomp_is_async(tfm) &&
> > +             (crypto_comp_alg_common(tfm)->base.cra_flags & CRYPTO_ALG=
_TYPE_ACOMPRESS)) {
> > +             struct acomp_alg *alg =3D crypto_acomp_alg(tfm);
> > +
> > +             if (alg && alg->batch_size > 1)
> > +                     return alg->batch_size;
> > +     }
>
> [Severity: Medium]
> Does the cra_flags check in crypto_acomp_batch_size() distinguish
> struct acomp_alg from struct scomp_alg as intended?
>
> In include/linux/crypto.h, algorithm types are 4-bit values under
> CRYPTO_ALG_TYPE_MASK rather than single-bit flags:
>
>     #define CRYPTO_ALG_TYPE_MASK                0x0000000f
>     ...
>     #define CRYPTO_ALG_TYPE_ACOMPRESS   0x0000000a
>     #define CRYPTO_ALG_TYPE_SCOMPRESS   0x0000000b
>
> Because (0x0b & 0x0a) =3D=3D 0x0a, testing cra_flags & CRYPTO_ALG_TYPE_AC=
OMPRESS
> without masking by CRYPTO_ALG_TYPE_MASK evaluates to true for both
> CRYPTO_ALG_TYPE_ACOMPRESS and CRYPTO_ALG_TYPE_SCOMPRESS.
>
> A struct crypto_acomp *tfm allocated via crypto_alloc_acomp() can wrap ei=
ther
> a struct acomp_alg or a struct scomp_alg. If an scomp_alg has CRYPTO_ALG_=
ASYNC
> set in cra_flags (or if the acomp_is_async(tfm) check is removed), callin=
g
> crypto_acomp_alg(tfm) performs container_of() to struct acomp_alg on a
> struct scomp_alg and reads alg->batch_size from unrelated memory inside
> struct scomp_alg::streams.
>
> Elsewhere in crypto/acompress.c, such as in crypto_acomp_init_tfm():
>
>     if (tfm->__crt_alg->cra_type !=3D &crypto_acomp_type)
>         return crypto_init_scomp_ops_async(tfm);
>
> the code checks cra_type =3D=3D &crypto_acomp_type (or masks cra_flags wi=
th
> CRYPTO_ALG_TYPE_MASK before comparing against CRYPTO_ALG_TYPE_ACOMPRESS) =
to
> verify that the tfm is backed by a struct acomp_alg.

Thanks for suggesting this. I will mask cra_flags with
CRYPTO_ALG_TYPE_MASK before the comparison.

>
> Also, should crypto_acomp_batch_size() gate on acomp_is_async(tfm)? A
> synchronous struct acomp_alg registered via crypto_register_acomp() does =
not
> set CRYPTO_ALG_ASYNC, which causes crypto_acomp_batch_size() to always re=
turn 1
> even when batch_size > 1, whereas segmented request handling in
> crypto_acomp_compress() and acomp_do_req_chain() checks
> crypto_acomp_req_seg(tfm) (CRYPTO_ALG_REQ_SEG) instead.

This is a good question. When the patch was initially planned, the
intended algorithm for batch_size > 1 was async, that too for zswap to
know how much memory to allocate for batching resources. Plus, we did
not want to impose strong semantics between batch_size and
segmentation for synchronous algorithms. The only known usage model
for batch_size > 1 was for async, hence the gate to prevent unintended
side effects until we know more about how to evolve this.

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.17=
923-1-kanchanapsridhar2026@gmail.com?part=3D4

