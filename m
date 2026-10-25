Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005C1606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 13:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=X8RiEgqW
Received: by kanga.kvack.org (Postfix)
	id 1FAC86B05B0; Sun, 25 Oct 2026 09:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB6B6B05B1; Sun, 25 Oct 2026 09:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B3E6B05B2; Sun, 25 Oct 2026 09:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D35706B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 09:22:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 472E98057A
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:22:19 +0000 (UTC)
X-FDA: 85361212398.26.05C62F2
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5E18140005
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:22:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X8RiEgqW;
	spf=pass (imf07.hostedemail.com: domain of danielmaraboo@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=danielmaraboo@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792934537;
	b=Nu+QdmqvHaHS2QYD3C1FCHtmNqGLEH/HA6ELvOiQgbm/6uhZlGPPfM9qb4DGWmqtAiJH5W
	cZOLHjD4aO2XH1NrnCRiv/5whP2HYPrVnuOk43SaVWFwZcOxUqNxFkkBNCL214z2r1VDcv
	rU2bVusX+JnGeHxezUoZIJ9cgdXonZ0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X8RiEgqW;
	spf=pass (imf07.hostedemail.com: domain of danielmaraboo@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=danielmaraboo@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792934537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZmVJXovP/SYcTy7+girXETRc+nqmLI60cP0gmYMw0Ks=;
	b=akLHi4MJQI+eHhetI+7m1055TLyxNKxwebTT2UFxFj3zk2l+KI/pkDd0Panxn7lkJpRh+v
	hAnA9PySf+/TSABj6yPSrzSyJUBpv5Wm1XsBqANl4hHHvHnitGOu3PXuFzpYhsWTpV3wGv
	M5by8xJei4MzL5JIXRD1SbmWB2ZNCCU=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5365b48238dso17516091cf.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 06:22:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792934536; cv=none;
        d=google.com; s=arc-20260327;
        b=FxjdE+gt22kNfsP7N9t84O9uQDmIxQ+lTM/R+WSUrhsXPGgGVNZeKmq5sk9BAYVB67
         aNh123wmFKxbQ80e9KS/QHJMmu6l5TsFjL/LHaRU8jpJpDZ+3yG4lQ/xRTq2yF6WsJgQ
         qpNZo3yKo0ciQeUBQ2iQr/aueiLVonySp2oInrmv8cpxYIzhdPuX01PWxM9EDojelFBK
         ve7uQFtUS3A4wuhkyRg82tQr3OCk63qRzNLhmEE3OPhzqFLPmjcFzXYpvEpRpUQF+L4n
         ZXn1u81UZq5u++5j8txas37lq68sY8L7G3pA2Y5vFL7y347n2qGKbnFsK+y1CyIcBXfC
         sVsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZmVJXovP/SYcTy7+girXETRc+nqmLI60cP0gmYMw0Ks=;
        fh=IjEC2jpWJUz9Axi1ylF7PQtAxw4VW18hVXWj8tv+Sn0=;
        b=c26P3UiikPAEug6yLuLBx3NAS8K4rmqIMjH672OR5PIBakOWoe9gHty0Wgp/ZJvW5v
         YsBPr3GD+KPldojhRholHC6OSfOfjVtTikvWvZvKsp/+jrJSvoSG5udFUbXWYNC1uBL+
         eeXDw384estF4K+7sKsrv10MLERLFks5lXPYYHVwUS/wa2PDs8ewPOfPaXOI2/U3DtDO
         90WLFiFlKx0doMi47xUj88CRdGI0iNAF1bUE9oOSowE9CY2UnqAL/YVuChz/bt/DcgI0
         cEQdttCfWKPo5aPkh5hgJ1bW2wLnAcyN1SYulCCZ8hxoA9OTwYJ1pP8YHMBsl0AFnxFT
         5/bA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792934536; x=1793539336; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZmVJXovP/SYcTy7+girXETRc+nqmLI60cP0gmYMw0Ks=;
        b=X8RiEgqW+Ho5ofsawQ6KuOmLce0Gi8nMCWhndwbNjo4+lwsLab14OsqUIAE2v/xrXW
         OdviCSOwBLK3t4vXJHSM0i5NTsnE4Ozw9/K5N794PmSamiihN6XJ5SVKS53buxaQ+8I4
         YJNJPwiFhMqbfeKb/jD/pm9tqixU9lmgNm/8BnT24282I7RjSN46SVzM5LDl2N5/BNBo
         NnyPM7oAv2ICXjBO69ZZjQYgiZEUrkKCusUML01jqxHFYDFz+VbY8BtdVLreHiKqiF7I
         /Tx307gqSr1gro3OcTcjbWHld0rJPjMn7yE4YsaRNLyYzZLLIk9e6m3k5/jZ21PpD17I
         WeDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792934536; x=1793539336;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZmVJXovP/SYcTy7+girXETRc+nqmLI60cP0gmYMw0Ks=;
        b=Ebr6uvSF+DniyDsnbRqb809u+55Ze5tvgSeJ3cCXjWBjDMI+dO5+qLNiQyBmkz/zds
         bIFIvnHrMW3Mt5X8AN24jVTj2xDk7z7hr+aipmNUmHmMv96n2HAJN1bdYg3k7d0o3Lob
         qwAu7dTIVBgSUdOwpYwq9d3qDdAG4HWmJ4+YxpN2H1IYNB8AKsDuYRHao731qhRs7c2d
         P2gd/nmM7vDX8CNRUTB0jlXynIkK/yywaQDI4v+d+v2Adk5cbXljggywSrVme/Ihi20N
         XMqqcYUpChdPUgZcEz8gaka8T9m/VOzTnxOiht2LUQIavp5h5HYO/euq3Ohl+tuqqJxU
         bwbg==
X-Forwarded-Encrypted: i=1; AKwUvBwjoNT7TKMXEOdACXI68bAREzyT9oaR6aUN2Y6g4UJXgnvGn6aorcVKO+ls+7hxLSWxgA38pg/s3A==@kvack.org
X-Gm-Message-State: AFq9FYKeg8701zRLIWaDYI5o6mmp1/08mTMY97ohX9d0BpDpsWwDuFtD
	+q4GVt9DiPAQgHkurM//OI5pvZVJsFUAaNDl4nDKfcillYaYFgKjhj1+4WO0+f0lVFLwEtvXKsB
	FzIs9A+F13tFxYja+jQPQPNX1N/FJG/k=
X-Gm-Gg: AYBFou3+Ca4pdoi2qscENsna9CQLd9LpOZ5h6RfMmUvOUsRI+za7pyrMMTuUIBAb2B3
	1daWyaDtq9ytQ02IfX00nrJl2znXSDc5aYLHM0JyEIRVAC8E3nqgpuccoKt/0wR2kaqBPVhT31J
	enpSZsL/hqSX3oluJeA7bXC/BvLkdLRveA97kfaNIXpHTWUwx0mMGYojz7IU6FCJ8bTYykZyBbG
	aImZRtW0elyjX7hn2KqUG0LwKEgS8xUF4+xAygoQ7OkYIrsMKwhOxtY0z/xU71yWPnCsGXXkeso
	7UtX1jBhVNXDaxxtYpWqoPn51oIT39NiShTug6dC55iWYYcaNSwF10aGkKEIM9mW5bn86K9PS5U
	FV3uJqE1gnunibRZsIHtDWDeFtr8Ucj+Qa2P8qQKOkPGxZQnP7qIUROyLHLORRH/jT3ApBfyY0p
	Vy3OI2OuYj+KR87RA+S13+7PfCHNMwcWbuH9h/sUFIpOHOZx+4UE0=
X-Received: by 2002:a05:622a:1e0a:b0:536:8f5a:64a with SMTP id
 d75a77b69052e-5383b5d8095mr65259641cf.63.1792934536433; Sun, 25 Oct 2026
 06:22:16 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023-binfmt-typo-v1-1-459d4ae4c15f@proton.me>
In-Reply-To: <20261023-binfmt-typo-v1-1-459d4ae4c15f@proton.me>
From: Daniel Pereira <danielmaraboo@gmail.com>
Date: Sun, 25 Oct 2026 10:22:05 -0300
X-Gm-Features: AclHuK_RzNSAMZBWg3A6xIKtAXs72wHUSwnE42f611HZttmQYdbPl-cqobyZqvE
Message-ID: <CAMAsx6c7MVuP1gsOdepwyjostG8eYnkXrw1rttqFupiT_GmbKQ@mail.gmail.com>
Subject: Re: [PATCH] binfmt_misc: fix typo in "auxiliary vector"
To: atanaskunchev@proton.me
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	kees@kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1aepdkg49fcidbjz85qyoqqki4ykxkkj
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5E18140005
X-Rspam-User: 
X-HE-Tag: 1792934537-66766
X-HE-Meta: U2FsdGVkX1/G3GBR2eICsI1PI1SDJe1b7syJ74UB2sDyMa0knHcOlksE7a3lqUwD/ffbds+bfoXie1eI0KoOGssjyYk+SSBtXjhaDgDqYzzNZKyaBQ6e7j1FT1b5nCUKYz7K7WIOmpWTPkuXVLfRTXJqAeETdMkysaSue5Ugg6+9+IgW6Eez+7+hmQumxWvWGuLlrIKVu4iVHHH96vYINMK8SqhCy5edX6EcuHBcZfEvMM/0UoB8AiLZ0lemy0lVJXFqua/N5ApweB1One6QVQJdgvPl58fnms95qbRPKbEwbORL5WDAYDjqdy5XSyZsIV9FAPqhS4vBmHSicqbRREI3Z2VodiCAYkKOsRe0XFBvOnSeue4kE+TV1ya05uNlmaJhk/r832VUwYNaisjMKV0Kd6IchCjozdRZX7HWGkpibKfnTnIL8jCNvO2MuCmfAfpyNu32jV3jcT8cGNeMTI1+rktfVmsKF7rZ/gUnsNBw/0QNQ/LkQ2lCzCHb7RjMqMrGZX+hEm/Na+GiburLaM8N2bmPaKAgZ/kVUPjJgOXKlcE5i3ReJEpIcTICKIQqHs2A09/74HKkeBK351uZT7NY4XQ4g/w/Q0ftbX/P1LWK1yV6cKhSqwRCQc19erMrI7PIOv/YA2lGY8MDHRSzsW0Ow5ppuaTKX64dk1/AKWb6hrbFEFsMK25RGHYkC2xY7G8o7rtBEbGf1h1r6NbIDH62taRtU6h6X/L3PBuAVP6GWvF7KZznd2fj/NoE+QBhRkiVTFdbAWCShpOEpyHUC+j5K3xVRewH8doYeM72sh/vp9eBks6BHMj+TQ3RkCCnpbUESr4VVxfiqHo4NfjK05WgxPmcyGAd24Qa0axymW/CEm80CyWQxmLvxnH5uvE2PLJjDGnsbgQ54Nf9ARVkyunwBrW2fS+apr75aFDYYL7+jkZhh3qtBtfz18M+IzJzCxkUK3BF7dis6nyEip1
 dj8F8gP5
 8le6n4gZSNMdRJoKofNfjLxmIRvCrjSFCpPszb5cbzK1joJOlKiVOjPLeuK2CvOlnmH3kYmhC3Y4thVKhQpqpxyIEQpAimydS0gYIaIdKHXP7SCmaB7wiihXLJczH0KcHJYgGgvOhJnCcuxeQXrV62/7fqjX0PtognRmKz5OXF7NJiEDH50rSphfV1InsyvherKnLAM3nRuY5O7jZ7HCqK4wOxs7aumfwKGv1vmq18oceXFcUu4juKvlgnKuPBaxk4CnRZPV8g1gfggofuRaBLVu0JCBhfqhzg52wYxqgZPZBfmRaWEQ+9KiIwsQd2hnHt8raJV7QGJbPOHZvhUcd6g1z6jNNFXbMGZdZizFuTKdN3n6XP0IwBC5FEHtdOZX5UqMQROn9lpepbETuz+/tgLokHSLwI8+nHRAiD59x9G+MUCK8igFmvTlJ+gAERX3LGPMIPhXpKr0FL0lnQFFZdCm5UFmwLz17aqgFmrsXKs/CPEAgAUEPHFrxXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026, Atanas Kunchev wrote:
> Fix "auxilary" -> "auxiliary".

Hi Atanas,

I searched Documentation/ for the misspelling and this is the only
remaining instance, so nothing else needs fixing. The change touches a
single word in the description of the "O" flag, and the fix is correct.

Reviewed-by: Daniel Pereira <danielmaraboo@gmail.com>

Thanks,
Daniel


Em sex., 23 de out. de 2026 =C3=A0s 14:55, Atanas Kunchev via B4 Relay
<devnull+atanaskunchev.proton.me@kernel.org> escreveu:
>
> From: Atanas Kunchev <atanaskunchev@proton.me>
>
> Fix "auxilary" -> "auxiliary".
>
> Signed-off-by: Atanas Kunchev <atanaskunchev@proton.me>
> ---
> Fix a spelling mistake in the binfmt_misc documentation.
> ---
>  Documentation/admin-guide/binfmt-misc.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/ad=
min-guide/binfmt-misc.rst
> index 9e84b877d06d..e37668371453 100644
> --- a/Documentation/admin-guide/binfmt-misc.rst
> +++ b/Documentation/admin-guide/binfmt-misc.rst
> @@ -73,7 +73,7 @@ Here is what the fields mean:
>             Legacy behavior of binfmt_misc is to pass the full path
>              of the binary to the interpreter as an argument. When this f=
lag is
>              included, binfmt_misc will open the file for reading and pas=
s its
> -            descriptor into the auxilary vector with the key "AT_EXECFD"=
, thus
> +            descriptor into the auxiliary vector with the key "AT_EXECFD=
", thus
>              allowing the interpreter to execute non-readable binaries. T=
his
>              feature should be used with care - the interpreter has to be=
 trusted
>              not to emit the contents of the non-readable binary.
>
> ---
> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> change-id: 20261023-binfmt-typo-bf80308e23a0
>
> Best regards,
> --
> Atanas Kunchev <atanaskunchev@proton.me>
>
>
>

