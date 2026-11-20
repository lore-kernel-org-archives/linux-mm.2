Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8EB4606A6BA
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wsv7cSPQ
Received: by kanga.kvack.org (Postfix)
	id C77126B05BA; Fri, 20 Nov 2026 17:46:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00A96B05BB; Fri, 20 Nov 2026 17:46:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0A66B05BC; Fri, 20 Nov 2026 17:46:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 768E26B05BA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:46:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC8EC14020F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:46:22 +0000 (UTC)
X-FDA: 85456982604.15.31784C0
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1039A80008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:46:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Wsv7cSPQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795214781;
	b=C+l7oEjBi10lpFctWHb/Gat8xCma7nqOVORdETAkkTPKX8yksFxs+z3PwvHQ7AkEIcpACt
	Yz4P5OB3JErmwDkrFNwfiJdsjy68yD1tkbpa9LvJKBvyxW14kmI0FOTbvU1GIo4wcrfmST
	k3+rdaHC2ud2LC61MoyZ8wrKAMNAgbI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795214781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1eGqv/h9Aum9cuRfzP0GxawnzKTcJHSd17/iuLvj8io=;
	b=t9OJpR3pG7Loub+Um8TruXAh++ZdTaaDLfGPrr8nLZ9eDr2PFIFGloeU17eNqOR/cKhmwp
	8/Q1oddk/5g8/J/wYRv3mwV4GlHtwmTeD9mdf/CKqJcRTR+lR/0UYxOUoexG2VqdWeFtbh
	/9IuVIsGQh/cR/kX697tBRtHRGd3VQY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Wsv7cSPQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4a32576da88so844132f8f.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:46:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795214779; cv=none;
        d=google.com; s=arc-20260327;
        b=PmQIN3pUjHfNOJ5gdUNjKlsGx2oiRaHRaZJ4FcXXEGDMCjnzQLuKMERM2KMM4Ty7LF
         JCC0Ig87AV6Cx1tsNXkfPPXWg7LkTUCvQr3ECSpBb04uDvQse+1B6rh/75eNSAaGfsG4
         rgj+RDm1eNq6JCcQw4OJkNpc6uKhT1R8RanPXX2Jq6QbiW0hrKo2Dzn0IdHJLY/l/ZE4
         XEpbzvVYfVKseHHgORJlslGPZNY9myEOahCuxm/pvQ+uT5Tz0S10XDXeld9i5WsOtYZH
         aE81z6OcZam6DtMrHCOniuA7KXUqH/u8IPV5RdJ46+5A6h1fLAv8MlQz38XOdqEEVTGk
         0Fkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1eGqv/h9Aum9cuRfzP0GxawnzKTcJHSd17/iuLvj8io=;
        fh=PIjbIOXsUAVW5h7L9xOW3gXRchq07d0daymV5z5yICY=;
        b=Et7hoXAbNht5aztC8g3/++2S879dUVt6/NiIwmZJjs+XNjKVC/5sXDU4s0/GVbkYle
         UBXrnhdvFLs9Zr0FJmpxBslFTGAjfjrd9ykdBChrACIFiW+Bzj0a6Ypel6/YerVai3TK
         JM1apHu7Ph2GXq3jylb89IBCC2LvJsHhdDTDYlwF9k5kC7j/m3hk5JQZkvEj28jhc8xP
         K4VqtQ9bVjoMIu/woYDUbiSI3k9uHownxKGb3O4BvnVM8U05VvxPaO2Av3lH/u5WE2h2
         q0PXZ0OTPRCwTZaH/Ceb/MTP5wUu8ztWP1J/RwOZAG/oGFeoKoYV9IBzm6zWfPoD7+Xy
         BeLg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795214779; x=1795819579; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1eGqv/h9Aum9cuRfzP0GxawnzKTcJHSd17/iuLvj8io=;
        b=Wsv7cSPQLt8Hz/k4bS5/Z1oNwDmXQpHMWuNgrKSlOEtKXoe8P0dBHdXylxKpBpwp84
         hgLpqaRoFdt8PNdl2ZbbJ10LH7ZxhzqKtEcQl3fNZZ8FTcQDjn3dh4yIbVW/273riUzG
         QzD0o5j1PUrAHmP3DNNHtqV0suMqd2qv7l6oM9bOpxz13ah202Y9EgkYJJ37xvW9iGKm
         Sgp6CDr7Ot0pSF+/JGGVud8mhtkq3HTTGlIi7E74BL17UO0i+fY6LMGxcm6U+qDDEkmk
         GlEGuYONbHubu8Vd4C18cxa32ZETomxEB+a++1bmx7SRyAcJUgSc2yFicde/iUzgfKAr
         06JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795214779; x=1795819579;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1eGqv/h9Aum9cuRfzP0GxawnzKTcJHSd17/iuLvj8io=;
        b=watSI4Z6+JrwUhuTGLwSTmLUfZy5WJjjp2pgqbDMjhR4vkQYG09LueXuUzgOUSi8/z
         bQdvh0cUvV9Lul0+6QDz98UeYa0DOFaWSyCH5iYJBJlMEKGIF9UF0lLQu74hzpZ+dkwq
         cFbD60yTtRJUVoOqe6P/R2ppHvbNeb+42C+zRp9XDqVenjlHvJXb8NY4rsZa4KCsYJyo
         5f29GDU4iWVQo3dsJ1/0nCdVvzl6u4W2YTGRSknjB1MFpOtwYR7SVPJhS8RECsLzKp0q
         pOQS6WgwDyfHTa7R8P71AYjwjKbHyGT+YZaFcB07kSJdar6UY6Ra4pAY9KVv1Mrv3LOa
         MgXw==
X-Forwarded-Encrypted: i=1; AL+hErHytZSjIwhjXjp+VloYht538lqFx5o40OnqS+/D8D27Hj1sv/3W1GKmTjuygEUMYYo98E6HIXNICg==@kvack.org
X-Gm-Message-State: APuU4Z8QUPhfegqaOuQsBvXgBcfXpdNYmqYfdil5oOZon0mNrm8b3onL
	Ts4xAXh6rR363ej3zdTjdZKogY5WHP/2Jb7eFjhE2z875ztpj7PaC36bDwJaaz/XKu0LwAF1Eh1
	3EUhRl8Dc1s10yg8O0MsMtCnvkPobsu4=
X-Gm-Gg: AZFdTZeoaUEDWiui7GEOValK96QdNMpnmUndFXfFDWPUkB9i/Im5uddEx7BQyKxAtle
	Dcp+eVlFrRW6/t3JiId6fForULhMnIANYgDHrm/7DD+VG3qgjEtAMxYMHkIPZOb93ZfAg6LetBz
	Ys/x2H5fC0IUuDjwGd6LjEFXOGSrHaKnXUEdfzeSFlFFkwfAQ5bH8JPolL0HOw4RjSlg28ti5gb
	93lqpgYDwQWOR1PEhSX69YpbtOlMsb5sAJtf54kybj2IAn5IJxhFd7qbHC3kKe+98ohNCNjgrPK
	e7qpc2wEeAvoxqtE7shEKLi4dd5bSUSP1SOZmCaC1MRw9zGx1gY5AmY/fmQ0SLUURE/p1YtTVJU
	aJeyabG9e7iaQeCMCvnhq+Z228csdolmfxIxuMszVo2AWmLVtr6sGRnm0OQxHoJS6N0p+oYd+M0
	LsRz38MfecNDPTrQ13wrN2bjV/Q4A1IAdVzCQHkgzYsW9djam26sM2rlI=
X-Received: by 2002:a05:6000:4813:b0:490:2033:1477 with SMTP id
 ffacd0b85a97d-4abb917a9eemr8798576f8f.56.1795214779042; Fri, 20 Nov 2026
 14:46:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com> <20261120041906.5785-6-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20261120041906.5785-6-kanchanapsridhar2026@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 20 Nov 2026 14:46:06 -0800
X-Gm-Features: Aa3M54o22x-4wryDrkjAa-WgAkVk_I6WmUJ-pJSJHTNjra4aQw1mQAmQSzWMpFQ
Message-ID: <CAKEwX=P7To+AV9X3cXLCcuw5yoigdB8w5Ns9c9mDxJf+u5k8xA@mail.gmail.com>
Subject: Re: [PATCH v4 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1039A80008
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 3jwfbu6oh9576sm6h18whecoiptersbr
X-HE-Tag: 1795214780-7625
X-HE-Meta: U2FsdGVkX1+0feo6QSJPFYaXATDE0L8dwXryRF9upDrl6vyHt2dM+i80TWyoNacDFfM3nF+Vhz20uMXybfDa8Xk+LZLmZBXyQlOc8oMnsjmQNwEMk3gmONMDqfcAwM4xjrbZAD+x+t29yzy0oGRyjzuK6vjfJJWvxcI3mz+/gzWhE04lYLKfdUPY52BHS7jYKWkOcT2UX6yO/r2LIvEDkgyH/Z0yGcBzU3+B2wgF/pDEhgPZqXrddXJjNVWdO+PdsJ+We6T4c2oGop8TNV0DvKlLOvetXrapf799XdW802TJmt4ohCPrhaUTfUx220/4H+Q0/XMOicGm6AWReWACKATq+VAtNUgpVFQVL3ubxoudqD54amP9cnkv9Ax3PYzEwpY6DWdqoRmPjXty8dZuaavrRiaJQrjdyzi5AqXSmkAvHGz3s9Jhgwdsmu8wR65KAiDbrwgPNsDhx1KeZGIkk5G+ea0E5ivgDtIbx2dLxKQOXjueSrWEhxZHxy9EEYHgcGlpqGsxW22mI4bdod9c5/LwIp58ndXg49XURAm2EdTTju0VB02xOKy347EA68YcUSScw1NQv7bVDEN315D7VsU0GJfxLa+LpTNjcNpQJwtfpyLYtwt7B+o5nSP+LiTkx+WfI8NWgsw1uYyYfZI/qC1BAHfbjbm2C/wnfbi3sNtgaMRUrRUxGMUDIgAhlF51donijqNd6wSY/xnVD5jBJOPQ2n84m7TQtVKbxa0b3pjYKGugWddlh1nBZIrFbbJQdGUVjVNH1Upi5ZCxnDzF1ghoL2stzoxRWPTCfIKXd4u+lMoMsba7L6diAnkQssrbx62p7OvaNtmLXPGF9kwk7Oo10uPXW8wdSCoduX0fX2TJJUNB4F4/RFlmkOJ57eGUbh3CGP2SosC0fxvqKpkn5T9KxcTa/4qion9Wmyhu6bH1WCzTQTp3CyFe/a9J9t6kuI0X9extFo+U8YenyC4
 hwJ9OpjX
 8wQu1UiYE411fvDerA/WtXMyU+/jR2KJo6Usr8ksF6etwexeww0mb5rf5/hAnG5MWJje9b/rj11ATO4tIxnc1ZkAiQFw9NW3FAivwoDirYWn+K0G188Y5iLNJz8VFc4I688eUzCpjljktbIyYYHoKEZ4dcVLpjaiJWA/wdRQFZ9jxcOcHF3kvyMYxjqtsaEhnicjIUtGr70HOyH252W1nXnO46OfzIUIyfSRtxBfMv2So7o7NZDpaTHwPgmeu8F7FtJUVC7G6P6tuAxA+Ma1YoMcQVx+iF3xs8jR/y/0rX3tSjGuKx1jBinRaMDah0PBMJ+46rUUWXlWF8yU1J6Xrnk170Ap5dcLuyUu0QL9zsw7FfXaQXqJv6KalPTNzHfWMC/r6QPO9Q2mbv05xGtGMfY81n5BQJu6mjblQR67NVeJr7mJ7QNeXf7pLKWLU3s80d0e2+XL8yQddnc6Hm7QgD3dAOlw/pi9xURPeJ29fJ3I914uTx7RNjdHB+825KxRhpXeUpLfSTk3RRaBzh0h3z5WUbbohorzvpPdfh8mU/Gc+1fWZufa/+00KOpSB1Bvvmj3yW77cbvDJiWUJ6sW+VI/HAyuSRdJ3CeXostDXVS6Y4aQFLey3ZO9XZZYbW3ERWofRJlBuoXkd7RPLyCsv8YejrxleNxNH9m2iAr5RRCwo3l17lEtxUPakbzR/3RsWuv2fMuILE/SPDFvjWHructFdkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> When storing a folio in zswap, save the folio's node id in the zswap
> entry instead of relying on the zswap_entry being allocated on the same
> node. This enables optimizations such as batch allocation of zswap
> entries for large folios using kmem_cache_alloc_bulk() that does not
> support specifying a node id.
>
> Accordingly, replace the SLUB allocation in zswap_entry_cache_alloc() to
> be node-agnostic.
>
> The size of the zswap_entry remains unchanged as 'referenced' is lumped
> in with the 'length' (as it doesn't need a full unsigned int anyway).
> A build time assertion checks for the zswap_entry's 'length' bitfield
> being large enough to represent PAGE_SIZE, which can be 256KB on some
> architectures.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

LGTM for the most part:

Acked-by: Nhat Pham <nphamcs@gmail.com>

> ---
> + * nid - NUMA node id of the page for which this is the zswap entry.

Maybe "NUMA node id of the original page of this zswap entry"?

>   * handle - zsmalloc allocation handle that stores the compressed page d=
ata
>   * objcg - the obj_cgroup that the compressed memory is charged to
>   * lru - handle to the pool's lru used to evict pages.
>   */
>  struct zswap_entry {
>         swp_entry_t swpentry;
> -       unsigned int length;
> -       bool referenced;
> -       u8 pool_idx;
> +       struct {
> +               unsigned int length:ZSWAP_MAX_COMPR_LENGTH_SHIFT;

I could have sworn we agreed to just inline this macro.

(btw how many bits do we still have here? )

