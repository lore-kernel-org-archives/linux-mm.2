Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE3160A2604
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 06:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jIajj2jn
Received: by kanga.kvack.org (Postfix)
	id 628DC6B05B3; Tue, 10 Nov 2026 01:16:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6010A6B05B4; Tue, 10 Nov 2026 01:16:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E566B05B5; Tue, 10 Nov 2026 01:16:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5356B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:16:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1BCAF140517
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:16:43 +0000 (UTC)
X-FDA: 85418200686.25.614D5F0
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 299A0180004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:16:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jIajj2jn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794291401;
	b=ouclP4lahmWgpq86sX/uM5RaLTS72l1NVKbn/LpejBkpXPrrRRzUZBWmc6CfEOWapdZKVV
	Ix/l5bZGmO3mGN2YqqkBXIZFVRlzFENMnQgRSI4LV0J0B2VgJXjA9M3PORNd+rocGCboSS
	MHhMtFY6lxqWYBhXj8ye2ZHg71T8fOI=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jIajj2jn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794291401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rcGViOQt/HBMQw3WBvxyev/DtteQWbQcY0dBV/7zZ2E=;
	b=d8IfUxPWtoBiJuFtzfF+iDVtei1Lm/frIgvrL6qergOj05p9uE+NsmiBNL5twLBS/828Yp
	lSyWg5km753il56ufo2w30o2Lc47480ZgzxZjmGWUjIPJ2cPFJreC13gZecMoQjiQrfRYS
	Xw3pOX7f8Ytop2CIVY8VBS6GTPwvDck=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c5049f267c9so67547566b.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 22:16:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794291399; cv=none;
        d=google.com; s=arc-20260327;
        b=XaWvEmM8BjyUaaTp+LOEplqCAICnEaVdiZPdRX0qDVfjCprPVZqbajAJxoRtvkX+KQ
         7HbZLLoKhDZv8ZvNpu6OclptYP9wHxpxmbd1tUFEc6SVPGn5NFY3GUuIP+N/bboIiuP1
         l3SoCRhdXHUnFWQaYBE33ml/qyjyU8BIkYnmXMcfIoDp2FiAz+DWFE5Omte8jRBlWJmQ
         R6OrIGZkSIlNgrjk6ZmyJ1y5UyHsky1GaAsC/lzlW7xfTpDVoYBwbbbTSwUeeZT2iCpQ
         QNxy11+BfqKz3agtUpAm+goP9kVe35EQuEe8hiA4mm383a3uaeAEvz+lfnhGtp4ysB3Q
         8VbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rcGViOQt/HBMQw3WBvxyev/DtteQWbQcY0dBV/7zZ2E=;
        fh=6E90KgXEiewj3e+h0jkLYPAZlTFqvDaxwbrR4BVUDoQ=;
        b=FgV+F+T/I85WOBtyrBhB0Uhr/H9TPyT5dktZLVjje6GiDjUXzzD43OwczxFdfWwa1j
         UMZSRqXOAtwAbsU5QTn6DFhmF4it2vabLLjJFP8cPAQoKUEfZglK//1YFh33IYoDzsd2
         urLJvCe1ehrKTrRjy3Z03YUPR0XSK2aZIaRF3sdmGB6DZJtw/L97qXv0BSkTg33y4ZXd
         1eUfjQhFx/LL0F2RZ6ei1wMkceAYjFJ+YvPqsSGCRhA/ysLkrHcEsx1i58Wn5Y3w9XFN
         ZtDeKzQpRNm2sUK2ZsbzzhDaxsxmTNbpDStWW2h3K9eYZyyeXZab27w98cUsQd6pLtJb
         eDhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794291399; x=1794896199; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rcGViOQt/HBMQw3WBvxyev/DtteQWbQcY0dBV/7zZ2E=;
        b=jIajj2jn0FDAeAdjhi3JpWd0dhScsBt/cWnKdOLdJuPUqP59G7NwVp6Jcw3Aaov1pw
         KO80hcIuSOj6sHVsOkAi65Goe6EtthIqyoDs+8W59Ah59DEXuFhGY78M+GZkfd4NcvO/
         a+frZOLklfIR9unGtANxfaiRhnuh7Q34oalUwea9DjxOecyN5WcSOsceTVp7vEtV+/jJ
         YZmvuCTLbY0jwqw7nl4p8S1hnEndSEXWMFnBYeuEWukcZGCuzAVxznbjWiAJH+HNlEDz
         lTWXQG5aeoMI5LvZdbP4knJTz7GjPeE15RbQGah7vYU3z2WNHznB5BLBlU15sAp1G/XP
         anbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794291399; x=1794896199;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rcGViOQt/HBMQw3WBvxyev/DtteQWbQcY0dBV/7zZ2E=;
        b=l3nPDzKrgLUtgT0dC7eBRuzSukFdvFpWnLym7QnGl0iHKM4OvyYHq2cq3nDoe1Fizb
         sne5ZMJqx6/frP4maNShI35+a8ngZXgOZ8BVCrvJyRbSiMB7pkSJ5w3p0xkGFM7xZgHg
         cPSQgKn4kC7cB8axahKfVzSxz/F1IEzb6A1qvzCUEAlegjkDthbep0u9CQxA2ls4sKxy
         endvW9GCwyOTOXuqw7PN7yqjlunFVTP+sIUfq02EqNE8KAp2AVT04gsWirz4Etn5/M3m
         LubeZWBwneFaEi1TfOyH4OcQn9iQS5rdAXASB1m3yxVkSFVcZqI/VRImJtxLcyCg4bPJ
         egvQ==
X-Forwarded-Encrypted: i=1; AL+hErEM/6dEDhScOqR2sghADq+yKNBW7LdsevOm/cIRNk+Yw7dnaJ1FXZG6BLzk4rkaJXexS2mHZINN+w==@kvack.org
X-Gm-Message-State: APuU4Z/eTgG4n1bt1Bh7JOBLYmPqumR230Rr/lAcBb6ccg/wT2P9NvNq
	yspDwGShzYpdKh5hJ0e/ZuG57CPxdyjT9BZnqCh6V5hGbKPrGGMfvCAjod0j9zYNrvo2Cabnm89
	V6WnqmUpAjcH4hlebiQnU+Hb0xQsdNqs=
X-Gm-Gg: AYBFou2ghr6EwMiRR/qGNz+/CAodgsQkWcr5oLByQWfp5pEkvwmDS6yfYNGrPGi6NP0
	+Ufy3mzZrq43+wlSRpV831shGbYEMFNzopS8L51Oc+hLXNvmyQKY/9gbcmVGW4uucYdqzG9f5/B
	vdnUIjVcy8e1MljVu7K9WLO7QwRGNrl2xKSXK8yFpqpWcaYUJ7gK3YY7KV47W6HVwe9cG2etEuA
	TMg+0S2JyozMyBhLLI4SDnjnaC8ZdTPZxr29nGi/P2chkvej/yiUCyYDnvGiCSHkgL7b2J0R64Z
	aaM5OAxDLp+IfR0Ebrt6PMIX7JGBdchiHjcbkkOjZnQx9LcUjA9n1WN5fCFAjZQe1pNWdODmCh1
	WPlIiSVJ2PeaUaJejxMgeRoFJ++mMX1gPqjsrJJ2yheY4Q1rn/kAtfTFcEgTyi1SIrwl0
X-Received: by 2002:a17:906:4788:b0:c25:afb6:2d91 with SMTP id
 a640c23a62f3a-c50491be261mr114423366b.2.1794291399333; Mon, 09 Nov 2026
 22:16:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org> <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 10 Nov 2026 14:16:02 +0800
X-Gm-Features: AclHuK9ZoNliVkmeviY3CMgdoIakPDsnDlwZO4E-oVMxBFzP5M81JDFrYFQWcJQ
Message-ID: <CAMgjq7Bcbpo8QG-43i_KHHgyUSNuVN5DN3T_fe+MxF37MnFT0g@mail.gmail.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN
 LRU) update
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Lance Yang <lance.yang@linux.dev>, Ridong Chen <ridong.chen@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ziamugeerjm8w9ju1k4wzq8cddjhoijf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 299A0180004
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794291400-736688
X-HE-Meta: U2FsdGVkX1+s/A0TorHhI0qZ/WrsUHn1XkwmKY2Hy5R0rCHbEqX7ur0RsCClPo93o5FVtfj3mcdZAeTA8/H0x7qftud4OxzCmvKr1RfY4Rq1047s/T0IMxvogpCz6iPaZofHAEx+Sk00RXAfgMdd06zMWprdocdDMmPkrY6pU9z08Dc986nktZNQHimjcBx/DGBYUms1yO5zk/7jBgCCbJh+WsLL90+yATm7hM1z3v2otsTV5hCIVYFPYDKIbiyIY8aWOX6KmwXEDWzaRPXhqTnB5UVIGQ7o2YKwSFxXl2tyqWS49HwwR6B0sWNryyIDl253QpcknerKcU0xRHkfN2NiZPd17yzKwLs5D1b5KWD60vkPke0vr29WGEoBRs2O1j4Jpom4aMKpt0lxJB0zt2I+xO/3amyRBkQPapEhvpdRS/8s/cwT2Wn7TLKJ8TMzEna8R22crbdKT9AqiiXqUjPlK7zPhyhjxIKjoRVD0NsTScoXrvAw1vJDyH34WRcMhsJTO5dd+vfUckJ9eyjYODRqpcHezdPp5UGhkkiZPFrdMZebRYzRkXpP4KJ7M0ATXr0KI4/Xt++DiZ2ABnXlM17bjVPl4nP05XeOgkLMJbAG89tg+/yHOQwCakooT3d6Bm/qW/mv5F0jXcy5Pt2QEt7z7NwCo+35QUTt5/HGBd74z7UJxQQoL9dHlVSr8UT62PBsr+fV3K63ye4ew8Yss2a7IrAd6IGFsCg96cqqfLurcuDcqZQACohaOGRkySb6OgcDFkzGEFYsO3VYINItHoaW77xPN+z1xFffakUbfmmWAGZpkvMZ0QNKUzz5TTrdadU+3T8yZtstsEZy1/CoqBinxlRA6NjenaXoR/RiZjOIG6f6WGZrzkOjzRHqmNsCSe+2pHZrXIxlaoZ+rckOE7leTn6z7RMw8KUozpUxBwlUgwsQVNm5fdG4yVT+Uy8y9wBFF9AtMfCePkhCqXg
 ea8SN8Vd
 rQOTfx6A02nnb5apaRVE7e0LiZLBqqa7YUu3ob0ZLYwjgQ8T2WYeAJKq2UV+33/6WN5DNJ391nOcpmYHBdsAO177n+hRPoQ2uy5L7VWpWmfdhZEiajSj3mlk8S8qxCL2HoC+DIi1GIEWC67fCXLLzZE1vN30HlVuZqnWs5gTiNhE19sNFRgCm3VlU2HtIzO1+f0NPSkJlI8j8Xf/Azefd6a+hJKtP15fIpPWwyJCM+dTHJpzVnNtErKq6d0mCSY5p0Go6I/mNGqyMzf+hbqHQi75tbHLKh+9hsx43P9/K9q7A6FYsYOOf0Ay0hgmhddXataYDdNkUjm1GDklBOr/zudJN7eopxBPiW3viSQAnlr/5o1ts/2968KVEEMFD1fW3pMFLUaqJLwOhlxyMvVCW+Wt0dGLjiBLi5wVokZQvCgOwdF6P51ryG2HR9ZLgm1mNO0mIsqhaZb5XgBrGIHoUjmspXqTeaV1FIW69mSMzZpl0VHM2JULl+be37+ICbPUXphBibCKMHCpHyJh31ELinCKxvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 2:46=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> MGLRU is currently the only MM component without a dedicated component
> maintainer. Fortunately, Kairui and Barry have been actively
> contributing to MGLRU and have volunteered to take on more responsibility
> by officially taking care of it.
>
> Given that Kairui is already an established MM component maintainer in
> a related MM component (SWAP), add him as an MGLRU maintainer right away.
>
> For Barry, the idea is to transition him towards a component maintainer
> role over the coming months, starting by moving him to the top of the
> reviewer list.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 222b7fc2c3aa..e7ac319a570c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17635,10 +17635,10 @@ K:    (?i:vmemmap)
>
>  MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
>  M:     Andrew Morton <akpm@linux-foundation.org>
> -R:     Kairui Song <kasong@tencent.com>
> +M:     Kairui Song <kasong@tencent.com>
> +R:     Barry Song <baohua@kernel.org>
>  R:     Qi Zheng <qi.zheng@linux.dev>
>  R:     Shakeel Butt <shakeel.butt@linux.dev>
> -R:     Barry Song <baohua@kernel.org>
>  R:     Axel Rasmussen <axelrasmussen@google.com>
>  R:     Yuanchu Xie <yuanchu@google.com>
>  R:     Wei Xu <weixugc@google.com>
>
> --
> 2.43.0

Thanks for the trust. Looking forward to pushing MGLRU's development
even further with Barry!

Acked-by: Kairui Song <kasong@tencent.com>

