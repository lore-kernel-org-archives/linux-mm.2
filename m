Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC04C982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3F2E6B0093; Thu, 17 Sep 2026 21:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1206B0095; Thu, 17 Sep 2026 21:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0196B0096; Thu, 17 Sep 2026 21:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABC626B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:12:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8E11A053A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:12:27 +0000 (UTC)
X-FDA: 85225107534.25.94FA20C
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id B216620004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:12:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SaCOhzLT;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789693945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CaD0rfqQizy2B+GSoa1ONFRM1MKoZPF6ZVzgGYvBiY=;
	b=2VNUybelJM45V6kUAEbNrkFLrYuJsv+yfohoAqx//ZEic3eHZIPSfQPdUKtOuRm6QCVDUO
	/FxGd2EFLK5pxQxVHfn+4n6TfrrqZTgpHdoNks1ZwFFwVPpjizZEinLIvq5BcT8h4PLEFz
	KBL3KYaBjCcMPOMxdk1N0kGLEHVmOm4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SaCOhzLT;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789693945;
	b=EGNQQjOgepINu/OgPFwId7p1PcdTMxbI8ldrKX7VAbpo/DIAjwds9O272emzs2GpDn92oi
	NxmO/JfdlrIX4oTpzNwdBUUNFhtMjcmbxiA3O+ClmkYiTtJGQOOfGo/1x511WY+mB+7TRn
	UqD93jYfAeML1hmlI56Hs28F5SBcmEc=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-53113d72966so106311cf.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:12:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789693945; cv=none;
        d=google.com; s=arc-20260327;
        b=L4kwpqpAiQdQYXeKdInk4m8fu6SMeq0oXrk+r0155WL/sYkgMzzK1yfUOqYwyzTKHq
         rTgPsnfEHqi/w31hARB//Vjnuh7OlvQW5tsAwuF7R9UFQTojTkJIKVBpQ0WgAg5XvANF
         c63smQGcr6cruhJ3dlHAqhmwk5IamzMLoZFddruNSB4ijReXXVNkD+Kl0xks1fjvg0pb
         Widyl42pX2X2SpvsQ6Le0wNj2awWdTcPi6VfMzWtpK5vOdzCfObAIeVzjiI6cQXJwHCD
         Gx27SzYL/rTJmXkuroevD3XQgViRTK9Lo1pju5IZsAA0mE1mKMWp0Oqi6fq8sx4tBSql
         h2Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8CaD0rfqQizy2B+GSoa1ONFRM1MKoZPF6ZVzgGYvBiY=;
        fh=MjyCIwVVd1lkZp7CjOVUdpjaVm1Aw30NRZbNyZBK/GU=;
        b=HS8oXSa7eIbxYPzCyHjyVKZJqtvrdBBwUakHH0ppox1Q6X+hkxtjzaZV9lHhHp4M4o
         dL40e3je9Sef2Czrvi81UvIQkMWmCNpfYhZ3aviNvyj+2XgQBk/FrKGACsze2GaNwOOa
         Wr+/lqYZTybrdNBUgle66vrmEQLAmV2R+B0O4aAF8zCiLh3jxdoPdzkqvPWZy9m9Jh6s
         aVou2N5DfnGXMbIeVSSLdpRJHTqcnOMm5oz5etAj4iIG7rMdVneqCJI3IEpfuFS7V1az
         X7p+liOEpWkpo6Qu1yYSXsm5IgigD6N9KYIxNhC2sixe8xeEy4fGWpHrxBXJePaaTKJd
         ZWQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789693945; x=1790298745; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8CaD0rfqQizy2B+GSoa1ONFRM1MKoZPF6ZVzgGYvBiY=;
        b=SaCOhzLTiMPmZbY9QAqob/gM/+jLbVgL3ptXSLqro0ZlWxwg5/WQsKBJR5ZoXOCQ9A
         oNWZ7cgneEpQKcgrcfX9QFKE1TRAVQBO4tyj9PyoUQTw2nQEYodo8kuz6h5ISv29sLEc
         1knI2OPC9DfL7WeWC/kln7nHDKIKM128s9m/sNCtj7hctIqNwGNon9g+2yeZSK0Me+XB
         k2JV4tytvPTZ2ezvXJpovVPgggUcLsIP6ppBFKkBKkSGz++DGIfSh72E2nHtyZGpBgy+
         DY9XIcrnKBBfCmTR8khdNvZC+JR9EqxrvL2Wc4H8MAm5zWR2CxDjfKF3vZynKa9sN4PD
         xsag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789693945; x=1790298745;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8CaD0rfqQizy2B+GSoa1ONFRM1MKoZPF6ZVzgGYvBiY=;
        b=k0k4NKVrR8MdvodFUp11ZSZYci6bzOhzHLHFl4b3Lu6jT1QKOvvVswLW1y33BLxLAz
         abs5rhuGMAwTxIpLfVT6isSDK9hwX4iqi6l1S1tFuq21S0gh0cK3fNHNp9sf327TruBW
         GENh09DAYQn16mY/amW4X32qrVtyW7qFts+oLciOoxI2GtVLPcfLeClQMsoAx8Q8Z8Kp
         qIVA73RUOzmHd/3hX4quXBod2OtSbhWcriSBtdsJuebUMC7szQrK3LvEJckaEZjsQKkT
         Q9+qpEXtUjEYTjMCro/75rTUHzp6EgNIS57fhWFNnIwppdxH/iPhd1ZgxrtoYvTKXURY
         VDgA==
X-Forwarded-Encrypted: i=1; AKwUvBwf5b7N939pqfXKqZNeEf5pJY/YjUZ/ghOrCQIlHrztTGm/jQF4Dhp8PWgnjxz2z73Ajh03pw6Jzw==@kvack.org
X-Gm-Message-State: AFuF++lcfsyOgOnBGY6BGC0aYmwIxvZkKQ19f1FMFkzeKlPICuewxEsu
	Vqyd+NkqmrJyrLjUpusHf/95t1NzuVAJk7CTD2hJ9nRMa7opQBN3eB19d8oi0VAlFaqKlbUmI7h
	4O86jQxQ4F2vvRrmutI3r621yG/dbeXC/NYXey9Sw
X-Gm-Gg: AYBFou1TlS6phu+EbOqTecfJVmgEYCNvwql1lVz5PKWfAF6wiGeVlLJ32tkwrxvlMb7
	Iz2mgEcTr+eVn2dxz+Owpr4Qwe885lZstcNZabKLB/GZkeKP0FaAEfupQ4saf8a9mCzYnCpZQfN
	+GIwbhw6+3xmcvGwIbhCnN/Onx19wbjuJ6oGCGA07wV2MstDt7pdERBAIrqcTLq8vY2Df2xN17V
	/JgoMuOnl42Zs0WbyqctOA610ESDhebqPo3dH8sRgwIQ8erPFMd3cIr1qGtKXeWmLiM2uYnZ7kw
	C+aBM5pFtD54Rl0R3KdpmvBDzPSbqfM956/Y1LRLTow1K+y4mWK1pA==
X-Received: by 2002:a05:622a:649:b0:52f:9ed4:8d74 with SMTP id
 d75a77b69052e-5329d7ebce3mr7824921cf.14.1789693944193; Thu, 17 Sep 2026
 18:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260916075557.121316-1-hao.ge@linux.dev>
In-Reply-To: <20260916075557.121316-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 17 Sep 2026 18:12:12 -0700
X-Gm-Features: AcwNN1XNY6AqvHO92sUp1uSClBs9D9k4LNE8UFQHN5IMJcofHqzZ4rP2n34CQxs
Message-ID: <CAJuCfpFSP1oq_ANWqVbhS_3kzdLkK76aGUf6S73_rC++NTL-CQ@mail.gmail.com>
Subject: Re: [PATCH] mm/alloc_tag: account for reserved tag ids in the kernel
 tag check
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B216620004
X-Stat-Signature: ha6n5861579xmxfx66z5tsyuttgfaije
X-Rspam-User: 
X-HE-Tag: 1789693945-523258
X-HE-Meta: U2FsdGVkX1+tW7Ox0dpsE3AasGD7RiaOtu5xshqHaaqVuIdZAzSyw8wvMVWfXa9PrwOCvvG/5zL4MdmrfdihNjwe2BnbDZbqirA1/7iRJy2fnLUq90+vQwb8/yVI1z7DbmiIhlz8VsS7JWcAkM+bTPW3pxm71pRb8P7mOWI/+WFHmrZetfv7M8rEauU8lOfojrSmOYbkJtiCNIBSAW5lLAHHhxDBcxOTUlnW7pNUbyKlbwlsKlxkvuDdi6+s6PM+3vnWHL8/0jQQixrgHu8dAbYq1Icu028xWRqiuDIRFGLdx/t+o03GywwRd3gzMC/tZLgBlfNf1iaT7/ImvLMKDXO1ezwqt6wOYQ5P1REVOd4k54ZZMesE9qrAG6sG9FR6UM0/RAX5msg0HJPmHpfzbaaFRdsXEMeg/REVhg8nbfFGoPHACKIBSllcJ5kYX5oqtxjeGAlrKXzIzw5oHeBcWuIgfoHS1378oXsqQ/ahF4ldhhwemXAJavY+dwJrmaGL7hOLug6I33A0NsRz+BDSnAba1DAvFul+T5M6Qzq30LZPBlyNANxFqZo4urASfTzeV9zsOeptV+CU8Nh9PCP/ZLhVy0C7Ud0fA4rG484yroiULah/nORW94Kd56w35Cg0gyVIwXu2slMzYZnN257tHpbKZPdAys3oDFxM3EGBSF/vVd7OzHyoPj65vNrXRezY7bp9RAyI2SsoEBWkKJfhqZ9q6EcGZrU9WTybvLypqvJfYIENYIDUaNemyAuWTB9llRWC5o2rYW77/h0f0Q0VcM74k8BBzaZyf/g1+LqmOpMnA2qFxu9TNX6Jc56s4Fj5IRYSW6d62o31ms4HRR6MzXO0Itvi3uBTin4m4BtVqdMLnRqA/LQ3fo+KhlDNvJ1LFZtHA4rzeXZlmP8vRIBSJWtTWQG9Z3SNu7bsLY6IQ8HpQrO/ApH+2n2Hwo0Xx2eV3ZJijMY/UWVqELrwRRP
 H7wEL8Vb
 QBEGytrAb7bcmk8LqSoULNULafWMbWzwi96cDEX4Um//byO08H8KTEmZsV/7w5l8AganTlxUUMB8KwsNkYBlBRzRAXM0pvN5EosyxlwrLvfxXKPGhv8ankKAJBhx9tsxofOza8SIvwLqCVcUB+1vhgefyK1DbGJlcxJzQaMK+G1/EbWgV3lx27Cl4cSw3tC1yniGEUzxpP4Bv/j2zfJ1yau62bPnhUwSyneFi7mFg3ZUaeupqi5c08di0WYnINZaS3NFsXVKeQpYv9xc+ogNhOA18cCb52yMsYEeC8solhBdwH4eOpjO0JNmrPl7olFmQl1U1vGE5naqwfZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:55=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> The tag ids stored in the page flags include two reserved markers.
> Id 0 means the page has no tag and id 1 means the tag was cleared,
> so real tags start at CODETAG_ID_FIRST. The kernel-side check in
> alloc_tag_sec_init() compared kernel_tags.count alone against the
> addressable limit, so with the count at or just under the limit
> the last tag ids wrapped into those markers. Pages allocated
> through them then look the same as untagged pages on free, nothing
> is ever subtracted from the real tag and /proc/allocinfo shows
> that memory as still allocated.
>
> Add the missing CODETAG_ID_FIRST, same as tags_addressable().
>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Nice catch!

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/alloc_tag.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index cfa0fc84b68f..cf100e7a852f 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -629,7 +629,7 @@ void __init alloc_tag_sec_init(void)
>         kernel_tags.count =3D last_codetag - kernel_tags.first_tag;
>
>         /* Check if kernel tags fit into page flags */
> -       if (kernel_tags.count > (1UL << NR_UNUSED_PAGEFLAG_BITS)) {
> +       if (CODETAG_ID_FIRST + kernel_tags.count > (1UL << NR_UNUSED_PAGE=
FLAG_BITS)) {
>                 shutdown_mem_profiling(false); /* allocinfo file does not=
 exist yet */
>                 pr_err("%lu allocation tags cannot be references using %d=
 available page flag bits. Memory allocation profiling is disabled!\n",
>                         kernel_tags.count, NR_UNUSED_PAGEFLAG_BITS);
> --
> 2.25.1
>

