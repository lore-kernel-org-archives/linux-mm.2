Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C53CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F05B6B0256; Mon,  1 Jun 2026 12:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A0506B0477; Mon,  1 Jun 2026 12:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18F836B0478; Mon,  1 Jun 2026 12:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 061EE6B0475
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:47:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0C68914B4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:47:37 +0000 (UTC)
X-FDA: 84831924954.01.85CBF4B
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id 94CD02004E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:47:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ThL+nBNu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780332455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xo6AraTzJMTpgSfCYcj4/S3X8D0rbyuKdNz81jBZtVk=;
	b=ANCUvXsZa1KY4lezcMI5RGOGwknkSXtc1WHuZt6Hcugq2HnbKqOpKhnbkdQDaeLNKHQl/D
	DA28/oKctoHQtu/ucIMGJuW9xqNG3lPyVZXfBXFRHToaCcvi1MwDIEymIxicvhP//unmjJ
	pU36k+aLNe6S9zIMxO7yee4RavdZ3qs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ThL+nBNu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780332455;
	b=Np0fvdVT1fOpdk6W1Jr09NG9Rf00eni97Oid+HrLNRmkCmRgSyAY0HlBM5FL/Ur0+F4oGJ
	eH3UEJFdLwh/BDKHX7P8TBf1bephA4c2TiJkcpGjQbEEgReR2PEZY2nThkD0hUWICeXgkc
	G3TrYi/gJa8vphqCQpF3fkOW7yHTYFo=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490a765d410so18283595e9.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 09:47:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780332454; cv=none;
        d=google.com; s=arc-20240605;
        b=HDm1P3CWK4vnCdLF5ajomJ7eMbc75bjG64W2Z5xys38NBKjv41cUDSJ8ldfvc59jHW
         YPj5Pnlo8UZlnQr0nuY0nX9V1lK7nTP9E99VanrF4JEIa98dsYRUo7nR0wDNfeqfmKCN
         ZHOnf2uWt2t0V/txCY/cV0fIXlmyvP75sc6jwiZ1QIyoZe8ag0OLcYQ70e09pWbx/E/m
         RBolpFAY0ElF53WZTdT0qoZbaNHt23Dl/Q+gatR6rowE2n/eVmix1E+/MlHRI68vBivy
         xUAOy+pz6Wovv9F5N4tbG6Wb3Pa3dNu0F9DLBKNmrGGDCmZ+iIZ253NJ/qkmqtl/QTOn
         BRLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xo6AraTzJMTpgSfCYcj4/S3X8D0rbyuKdNz81jBZtVk=;
        fh=wxt1AfzWRHV9iMShmbeelP/mWn6ikWl0bvIxswnvoEs=;
        b=Lc1WbFORJuUZ8jwyHaU3OtFZ+HarsX1vLtYTWW7P85hJm+zfsTusBPMxGVb71csbmn
         OCd1PFPSAr7/FpaykhIBL3FwBv+F36E9rihjWXy9V7EuAP6JRoa/jFbHOyD4AKgQHWuu
         9c8er+fe2x4HAG4sFYigpUc9OlyCWhU2XK0OCmUriAC1oELhog4uESggY1DM+nfk1Lit
         trttTnQ2/liXk10vknkelQ/GlMpRYwxvadc2bMiFraPNZI1fU9cLd3r/CzOs05VRxj6j
         TVNxm1RGXz9QgQeNs6itwB7LWM5aC6Z3nhevZel/oFhPavxVqk3GFkeYzI68+CjVWu0/
         Kglw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780332454; x=1780937254; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xo6AraTzJMTpgSfCYcj4/S3X8D0rbyuKdNz81jBZtVk=;
        b=ThL+nBNupno72gktj+BQkBZ4U6eVgI5hA507fHB8TrpwbKFGItJ7ml+xhwKGRL5riF
         EyLrpsKmekFaZHDaESFoi2eGqlD6/b/Tx0T6ng0zHpeovqJN2nV4NdBS2qIQao+ZgBom
         7SLSK6CyweB8sGMdaos1wMjJzjEf98PfOTir49i/fUfr+Zg/6C1sGiDN1Q7xd/vUbAgu
         +RBG3+DnSlkMOT39mJ4AjwjSkOLYo1IyXVS7ipJJdGjIRcLJjmi4aCUOoKg37P0jS83q
         4dQx6QsGiuoroorf0QZbsWKT6EpFfBESA64ArwnXoM4vsA7bvJVbKr3DFsbHobplNFTR
         TABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780332454; x=1780937254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xo6AraTzJMTpgSfCYcj4/S3X8D0rbyuKdNz81jBZtVk=;
        b=aMga3cwlHCbvSGbxK8Wv0k3zKBq2cIWB11EyF0yei3qFPTCm6HAT3NB//QiTIofFyp
         xPkXIJllBVPiYDqj2rtYQwZ1vKX5To1TlD1AvYRAcYKjhp2IAdmc1rbaZ81rCD2gph4Q
         51EC3d2tuto3khBDJ/g5xTz95yfm11g2MYzjOMpCbRv4w3pnb4HoC0sq4I0aZaLvFIyc
         lmtK0ho2lpBx+QGYb6tZLmDIelA6dqolmbPiGAHcJ6jciPmIWhBXBlobxcAx5jHtT7WR
         m/D8ebbGA3yv7Zn4DSrRIQxKV1iDyZg6HK4CofDtHfAU3qPBFnLyP2oE8hH9VkFRBlFG
         rXNA==
X-Forwarded-Encrypted: i=1; AFNElJ9PQssJKBGh5jwKB85y+xehlN3n9+f2RvVzQT1EIAz8DEhSpW/WbyhVxOsQf+25w7fleGC7UBAlMw==@kvack.org
X-Gm-Message-State: AOJu0YwUPYCfqZTrXh+AyzhtZxG7WSP2sniqNhFQCCIw0gSQBx2p7u17
	CedjCCli6xFl9X+/Y0ZlD67eczszbQkduGuM8yro9kifLh21pUawmtwLn27lZi4YI/HfLRDJkKa
	qw+BGUFWYZsxAqxJP042miMP6qyWIIUk=
X-Gm-Gg: Acq92OEOwruhGszD1f9lL8KIiOhXNYvw+H4JdI2H4pUl2mWNin9EVXL/IXAplH4wNht
	oASUS/1o0xuZvfafo7eAuVx3DqztReDj6O+QrxFz5KOkmH844fdeF6yz1k4fvYm+51r/s4tMICG
	fP2TJekiFUpL9Br/uUdnXhOXQ4r/VmBfdIS5fsjiHPh0l3gqjdiNlTjqLitJcTAqhFgVbXXpvUg
	yToAPR7Em4+4PSdSLLozHnJtRBNuwID02mgjDgH8Zhj49ZGvyCpniGj2aTxQxEiwZaApro9Lzd2
	WIz5y+jzKyfzd/AiQks82v9vBwbSdYQjoO35NMwdxru8VcqkJV3AaZwy6bhP
X-Received: by 2002:a05:600c:a214:b0:490:958c:46dc with SMTP id
 5b1f17b1804b1-490a2953d0fmr139013995e9.17.1780332453810; Mon, 01 Jun 2026
 09:47:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com> <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com> <CAKEwX=M5KiWc8ZZTEXCXtxeBrQho3Gs-JnKmBB=YNUkp=WXaKA@mail.gmail.com>
In-Reply-To: <CAKEwX=M5KiWc8ZZTEXCXtxeBrQho3Gs-JnKmBB=YNUkp=WXaKA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 1 Jun 2026 09:47:21 -0700
X-Gm-Features: AVHnY4LNMMUatp6JDueU4CjsI_pQhdw4wgollhGHxH_yjG13hM-7SQCVtIuqd0g
Message-ID: <CAKEwX=P0aRy6cep1GoEVxRejm03YQNis2VNgY4+F66BzDPPOdQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 94CD02004E
X-Rspam-User: 
X-Stat-Signature: n5jrfd4omgbh9oam9319owbqnyoio4tr
X-Rspamd-Server: rspam09
X-HE-Tag: 1780332455-184989
X-HE-Meta: U2FsdGVkX1+cfPIpQXzOZSOg/a26vfAkbEsJZXU5oMHizBk+CIYW6f6iQcKMXwTUD2K6wrlLjP2/GzBpooYuH6WFJyxtsKyFuuKK061t30OaYzOGW+gUMJm9nNtbgzfvRXS8NG1mzGd5YLplPUArGQgo3h9GhSch7rCw32bB0wLqiFW1R/HoHqHlTIemDUKp+Mo6/bKWybFjbR3KhcCnMr3mi8ZZc9NLgt7rDCp6EsJ7nr8RH54ZXELEOpnHOk3D6OrOXxZfvfWUQH0+W+mhCCkzzLBdxSZMMkee89EI5iNMsF0Qnj0/VkKDIq8QzjiHX9q1bCHeC2bXDIK0zNLSUgNjmvl9ZCRJXrQmf+uPldxQhoozMuBeCJIBEzte+5OQT42C7pJI80lz3kewxR6hyHNzDIhc5CQoGd2Dyt1xw2AA9z8NYI1xa3dYq8FjRBJfqROVnaf2Pma9B+++XV8gS7OcQFd9pNrS19hIysm9wwaYDBIsvzK9r/ri1gXV5f5N5x65aV2gzjkMQJt0pRhO93JP5QShfHExzoONMsRJNPRu+Rw2DoxcoKdvBjCR6DmhEUgfEbuHIU2o0RHKRzaZIFUgT1lEpiT6+8K9Ge/d6tSTCyoPYWfpUa+d086DO6Z48JSR7i8zeo9iBSpxibHYRKW8PYSX22kpMwmAclIxVD2742RXY9W0Brw7UvsxE3rb8MRZsqbGJeJwGBFQqzTjLzk5j4s/WMaEzx1m+ZSk33r5jDN6Bukv8AMlc/qaV7bCRyYIT73MTxAX28K9Rzsyt+rNykKRR1DdxDtScTE3mHpcAA8Kd3wOoluZzae1N6q7UpvoJfXOUETQ2hppI8To2/y8GP+cCIT6EOuZG8fl7j5uIcKowEuTLfXXDW8rZc6dI0SPEorma2WTjSqbb8Ixmd/Vt3CI3ZazYbQ8gDpK2bktExmTvQV6C6uN79snfDcDlPiLXzh/v3t8Y6V6Dnc
 kuZ8cJzJ
 0SZTlqODyLE2TBX5N9u3tRofoLMaJhiXBtBsoGJX0KTH+UBMFNuId0eVfyqDi1gkGMnKpuFam+V/mOOUy0iaEDFu5I4z3ZEIc8plT5ktfztL/gKo2nXwwT8Ii+WZjWph/uR+6VL3Volmr1yZTQjq9WmLZyKD0DKRmSCmrybNHgxrqufropYdV7nMQtIudPLtwAoiYYDxTXMa06dlE8zreK08g6VvC9slWyFwjPUANZ8BNWMn9/DfLy4cTSrw4Jpuso+y2Vv+AhuOkGURbSsm39mssv/Eu0/7Q3MBlrszTq54tq32w6/NFZt/XgSI/XyrgE2oLTEgx3T5FXrrDVebuQcjWqjJitLjAJ0Bk4bCV/9FSUD62XC3/b4VvutObzyoQkxNKafDAqBbgzkdnBnSCMQSSskKQJbawmdCo4MqfZSpSjlUrLuE7keXc/7ogmKpVFkRVF/6aGXMMO6XuU97nRAXxqATSqixaBZZcuoQtEeFwQwyxy3zuWf8yBFgdtixSl7gbSWq1UmDv6jwTeYEWYmAU+oY6HxPcsn1c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 9:44=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
>
> TBH, I think the spinlock is simpler at this point if we need to do
> all of this explanation to justify correctness of cmpxchg :)
>
> That said, if memcg folks feel like an extra spinlock per cgroup is a
> bit much, we can go with the cmpxchg() approach. Please include a FAT
> comment explains the compxchg() approach's nuance in the code though.
> Speaking from experience, I will forget why it is correct 2 months
> after the patch lands :)

Another alternative is - can we repurpose any lock here? Locks seem to
be per-lruvec or per-node, unfortunately, and we need something
per-cgroup hmmmm.

