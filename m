Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63157111224A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CF356B0088; Wed,  1 Apr 2026 21:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F5E6B0089; Wed,  1 Apr 2026 21:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66EDE6B008A; Wed,  1 Apr 2026 21:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52B4E6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:31:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7056C188B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:31:00 +0000 (UTC)
X-FDA: 84611887080.08.EE53855
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id E964E1C0004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:30:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=D3ZiSf04;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775093459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aikrbea8CERSi0owCoJG1V8TXTn9cGO1ItcU8dz6z/Y=;
	b=yUHoOJ0/fCkE896sfSy3ZNadmeK3kNOBEQ2agY2JpI8M6TY8p0m+rAuUVQCJYXNUpQWJYJ
	l54QwpD9IrWMDY6VIT9hWPpSGVU8+cUnNisydorUnlcsef7wEXb4xXXUY8r0VFltFZx17v
	qsjVyOykSouToBOt1iEGkXvuyXzAbvg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775093459; a=rsa-sha256;
	cv=pass;
	b=zlgn9igG55+oP+Vr6Ymf3ORk25tOxhQq8OlnzX1tiNWrghgHtWF56uXYlxuxJMzuFLjtux
	2KrdvZvLpV6VDwzG8cj1SnUnx0xdtnZ6iidst1ejHPqJuy+kwF0rd8f/EKgcZuW2ILlMdE
	ErYIdwoUHuWrMcI2A++G8/rihIDgQj8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=D3ZiSf04;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-661b16ac011so679385a12.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 18:30:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775093457; cv=none;
        d=google.com; s=arc-20240605;
        b=FLDrb+1yBsJyP9BN9CN8PsbwqxtXCOLUG05gSvIwwc5dG7+zRk82Yynu7bXA/Iz83S
         V14wrroohdXPtwHYC8WGBN4ejuTEW7o11LRrpuhx0+sna01T2QGZE0RkhLwDl0ChKZMe
         5M/515qjVDbPDUdUDEoLVUTWcwOuowf0xU/q3n2xxYpsuii5GFmVids5vKKW0JgdNA7l
         WLo8avYytHh0Q01saB/TBMhq8WsrOu3USCyR2lLripClLiUgWqLwvmvK0+Uh4LYoE3RU
         TjdXmP8QNQuBVRQtWzC0uCYy2kwCg5R/G6/x+gXKlJZgGjWzZz+0bVphvkkRYYuHTZ/i
         L3lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Aikrbea8CERSi0owCoJG1V8TXTn9cGO1ItcU8dz6z/Y=;
        fh=F5iaSsXcXnWdNcsqjjUYsUyBqePqeFgPsHy9LKtRsPs=;
        b=lqaxMZz5bWQPzcNtzhiZziPQEz82BpoAjZFi7asfNRULnXJWuxD0ofVg220Vc80LVT
         YSA8wZLkJO3dmKobGK1Ipn7Ib+iSHUNa8DG9It46S95mjmnen+v6Uz0sAiXPD3HZDMnU
         KqIM8pK0jmpgFB8vo0T2zWFITYW2fijDAOTam+RuIot08o6b5JxCvmtvI2caC0qfu469
         PHEqpoLByVUv5AXpXrlv4myfmbcK61plzLS/zdJwR2rMXpDCnpp0qjPnL6AKHfdrBTyz
         87DV66PpddjcnvMVfT9vmWZMr0C5mKkXSn8oP1bCSBeovUWSWg/Wy2DhowbSDVtjUUFr
         D0fQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1775093457; x=1775698257; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aikrbea8CERSi0owCoJG1V8TXTn9cGO1ItcU8dz6z/Y=;
        b=D3ZiSf043eruqA+EYsvhab7QWEeK0N9lmM2wzJb3VGfGGqiAGWUtdSp4/50zWqTq3p
         bsjLdXN5HaGFCu5B3DYbfqwJXJ3mtwXz7CZFw6uPuWxj858pNFLvysskdk7laZNrd6tj
         aSXXPmTDCOX22y9/qNGmX/3QM6LC5tV6dsjvfKpeNlu975cgKEqxk9SP3qhnjRriz1g6
         1lsO/HDLnihBK4e4Ipu55y7PVsWjwLtsggfrnUd46vGL39jz0QI+uDnHmOcL13g8DbNg
         5r9FKmguro7FreAPcRPERMzY5GPjuqEP5AZvf2Cp1kwTGVcq/n7TQSrVL0FxSx5mp4NZ
         WTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775093457; x=1775698257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Aikrbea8CERSi0owCoJG1V8TXTn9cGO1ItcU8dz6z/Y=;
        b=idxDtACRKh1CR9Qx+VDIQQJ88wjTc5AOK/a5VEquH1jW8uoRw2f/w7g0MmDkuq//5g
         WSspfAHHLcs6fbGD/N7zmSU21XiKUiOxTlV7V3lEfoNNiYYX8G7uki/lRDXshKCOLhTY
         Zqf9zjoVAK1ULkLNUoVGWwu5wKfZ/Xy1E4zHXKJ8iVgQzs4H6J0FpLQt0nulXLCTX54f
         i/sI4Jz6mjJEyVW25S0sYW6rwX17Q2Z6pKyveXmTwYXnrITIeAQwRRLGtK00bByHToSY
         nm5YWjNpF2kcVOxevvHY43pb+nYNi9H8mE34z+djDqUmudh54PagiyjzYQkYXE1QQo6o
         kMrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcm6FutQiyYwSTlR5MdHuDi7WJ2vT2eIRdLSUFrd4rvTpUbho36ToHGbkQ4N9xVqDbGfueA2m/cQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5L6vJlJC5v6HyBfhr3OeZCghZsvA/bxmspQKglzd6ww5yqhTH
	8ZGLpg5KW2T6HsROZIgdbQdrrQWwE9oE1w7xJ651rg4JdEOIhgBHwLYBX8dR+o+W4q6Z4r4jCtz
	pPybkS48wcLxIQ6AbGUxHQqj9/sccGdhijrJVYXUjHA==
X-Gm-Gg: ATEYQzxu8Q4RJmEPqqpO0X3fodhoS87XqTDB5mG2VVMpmC+H+3x+qxbSD9Ar2tSYR5K
	P5/nsMtytHUU36zxHI5wqEKSAIPWeGJx/+iaEpXxsD4dferHVLBhL7vdm0fGWTFnC/kMDgYNxLo
	OAAvnIYNHNVq71Ho3HfLedTiuYXn3IEKaFtPvJ4ahzVcZ/uHeHsQ9ueMKFLFDJ0gKoDn7+FAOqg
	eQNRb+kJfg3ftDFjxWQ7+f6xdGsSvfZ8eNkntmzRHiPeOqhM+4cKVo9Obeue9k5/UHEuAavFaem
	IXVkEUvtqWEDg7V+d2PWLd+TDi9JPYMkF/s9eg==
X-Received: by 2002:a05:6402:13c9:b0:66d:c30:eb29 with SMTP id
 4fb4d7f45d1cf-66db09eff23mr3967658a12.15.1775093457253; Wed, 01 Apr 2026
 18:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260326084727.118437-1-duanchenghao@kylinos.cn> <20260326084727.118437-6-duanchenghao@kylinos.cn>
In-Reply-To: <20260326084727.118437-6-duanchenghao@kylinos.cn>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 1 Apr 2026 21:30:20 -0400
X-Gm-Features: AQROBzB_CNUYmc6uqlxpRcFdzwO_LZojh7kYkRmuDCJOPbDd1rYUlVzPm4yBTKk
Message-ID: <CA+CK2bBAwMFdvkL6z8P4hMP9xNsuGUcpsEBdQ6zu=y2njGcd+g@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] mm/memfd_luo: fix physical address conversion in
 put_folios cleanup
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: rppt@kernel.org, pratyush@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, jianghaoran@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E964E1C0004
X-Stat-Signature: d3bqfumws7eu1tdjt3now1f39jsrrmm8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775093458-574509
X-HE-Meta: U2FsdGVkX1+sUxBDly+NAsnh9Ec5PCr4jyY2b0cYQRM1M0S06wxiFE+o0lwvNuhlClWemX/UeYp54dEQl0aXmqXvu5vGvt2KWzMlyW/eLGE2CmqEYyerlKS2LR8RRANNyvtJ5zFfs0E78iA7MIhSxFUgWIzF58eSj8+rDWD28YB9N7Gmle9OGVMCnECIWCG9hZWVsFWzZg/Q99+hqdGpz1itTp5PGFTQHZ6NTEn1b6FnvZotRVFuPd5s3ofyLa2+gb2v7z9qMrR7WEPzGzUsz4FcXyvYGrpU9IVNkkxcSLmi0l3F/JyD1DWC4YoiIlD3ZFN0trcjIRWRHfS3ob/CPXWQSy2zzw0DqwOkAwuZeFG/Vn7RYVQ9LBH9WD/iDCnYhXfzzwIOKo3+1b21VHVE88qSxJrq5rGZ5RMCCv94vAEEz2hQTj932jJP2HUYU2rNh+SoC2tKOay9cO7iuiUaV0zMylpzneL/JaJvb/SE/HUcqZOgw2agoG5/QvZW0CiXZFbgtZz9VzFNiUHwLuws7rrywBT9bihCuIWhaJrobC9jhq1g/WwootRFbydJL0m78PfdgOzMiuy4CEKT0My663MENpuRezycr2BcIpsxpYUCxpFhFqNm80G37gYPSoP8BdttF4sHJLo50GF4hl+tUtMbjjM6ddV1f0SB9NwjJguxZIEA7y8gDKD4fsez7A+mVn9WQCbJTidZwXYDI1r5vPnYH5sfWnBTyc4h+/aO+QhZnJs/R2feBzRKIA1DlaGkpYTQLMr0nQUAb75DwdirJP/Ye8u+ZRyra2+A8lxYLVuKsecPQkwH7OL1xKnjhOE6NQ3cBoahP1mdcJOsvIkq6b5UQ5MRiUuB5ZyosBO/HlcxlqmNS1cg6M8jbbiimd6V3fXpXcFsGpiVk4l0D2e987yXfWTEe0i8UPG2hlIJo9MWvRKi999mK40n6RGNgSHjBx80hREkWgJEr0PRyOE
 R4nhxFPU
 XgENaLuTmJz3EehNPRuFby8t35rxE+rUx2Gqk5Ty+36L3UrdpGpRAFtlsgenGSHeqgnFt1FBybZCVTEoYRpi0bFidNc22VsKrHo49Weot7PnpPOuzaIahsJhIKRqTMY59hTmmB2+GOb77lDK040qfVkzwTkRkKbeKcJ1k/vNEoBQAv5MpMu2gkcpc3/jKJagtV05pvfg+S0rFDoBZqmd8cfEDJ0MdVy4zNutxhGW0zn14TObC7F8SLJENnztsE++Ztxj1HCEisgQAe5z3xMr+/XTBuEFt+FGN/jFNb+2m40XF2XF59HBFDJwm0VKDTl7ppNHo2wGOH/xzJIhstTcEk7eOJb6wadcOw93aY/Y/C9gkl/TlTV4GBk08DRw7Ala6CDb34mvC6WkrlDIduFwaS12dnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 4:48=E2=80=AFAM Chenghao Duan <duanchenghao@kylinos=
.cn> wrote:
>
> In memfd_luo_retrieve_folios()'s put_folios cleanup path:
>
> 1. kho_restore_folio() expects a phys_addr_t (physical address) but
>    receives a raw PFN (pfolio->pfn). This causes kho_restore_page() to
>    check the wrong physical address (pfn << PAGE_SHIFT instead of the
>    actual physical address).
>
> 2. This loop lacks the !pfolio->pfn check that exists in the main
>    retrieval loop and memfd_luo_discard_folios(), which could
>    incorrectly process sparse file holes where pfn=3D0.
>
> Fix by converting PFN to physical address with PFN_PHYS() and adding
> the !pfolio->pfn check, matching the pattern used elsewhere in this file.
>
> This issue was identified by the AI review.
> https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylin=
os.cn
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> ---
>  mm/memfd_luo.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 76edf9a3f5b5..b4cea3670689 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -469,8 +469,13 @@ static int memfd_luo_retrieve_folios(struct file *fi=
le,
>          */
>         for (long j =3D i + 1; j < nr_folios; j++) {
>                 const struct memfd_luo_folio_ser *pfolio =3D &folios_ser[=
j];
> +               phys_addr_t phys;
> +
> +               if (!pfolio->pfn)
> +                       continue;
>
> -               folio =3D kho_restore_folio(pfolio->pfn);
> +               phys =3D PFN_PHYS(pfolio->pfn);
> +               folio =3D kho_restore_folio(phys);

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Thanks,
Pasha

>                 if (folio)
>                         folio_put(folio);
>         }
> --
> 2.25.1
>

