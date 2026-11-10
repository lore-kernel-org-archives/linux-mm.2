Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7E9606A336
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O7Lw/W9K
Received: by kanga.kvack.org (Postfix)
	id CCEA96B05C5; Tue, 10 Nov 2026 16:08:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57E46B05C6; Tue, 10 Nov 2026 16:08:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95EB6B05C7; Tue, 10 Nov 2026 16:08:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 931316B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:08:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8081B40133
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:08:47 +0000 (UTC)
X-FDA: 85420448694.16.4053D04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9715EC0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:08:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O7Lw/W9K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794344925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avSfIEBCYCAjqR9F/laL5XImOVS++483HV3bkyt3Yrk=;
	b=WntPNV462EqBDNIW/K0kysBj95wTySBFGM+5H18mfhUPwPAha6jO1P7x8OT5N/6AX/e9+s
	MS0jZi9DyY19L5zetTY3SG+FOjfMptSxf7WhVGc8keHx54HiZ6DxtwAWJbS+chQwDSN1sM
	vnN2v3AS/M6hrYI2mYydpj0EeuL49zY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O7Lw/W9K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794344925;
	b=bwIgXRY1qAgnTtwN+SK1laD1GhHhkPvtoy/C9RYzkd4yRoZxkYEKV+qFpCtKViWKvMqu3D
	2SLUGFf64/0rjnn2wIkIGTr8PkUXjbRq42UxGvyE3Ct4AOMPJwZ0ySJkUVw9ZGlIHyKkvN
	qfxyMUbE6ioHMWXNlXEpf/efadQ2ul8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BAA2142D67
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B0E1F008A3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344924;
	bh=avSfIEBCYCAjqR9F/laL5XImOVS++483HV3bkyt3Yrk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=O7Lw/W9K1gEOTKogDePOMboKBEIgw44+GtVNN2K6IGGpoKZ2WGoxecsLAOX/o8GAN
	 nbDHTmheAURkpRElPva2il21piDVtf4piQPgQbM+GfttKB6OtUQ2z9IgMom7SKYEMZ
	 MKYIM/CWQhoSP9BujolQxOMdfpc7PjZZO2u40JIg6oIKxaV6tjPkW4uSfmPKY2aOsd
	 cTGJ3h9bGnhcEnmRcLrzmaYNmfcRQdF7tWHwJWeu2ciXDbN8jQQP0ueozB+8HusUo+
	 Oc1FD6eJfPknjkOePKC3ADTtxPHl2xGjYt146D4dFHYVqgGA+JZhbzz+sqzAsPV/Rr
	 pXaZxABz+VfZg==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93f36c18b75so149859385a.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:08:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEhoUGvvYt0OG1xrjLIfcmbirRnp3oM61pzmhdCuRWvdShKHy/Rbkeb8c46shVcd0q5P0X+CG37XQ==@kvack.org
X-Gm-Message-State: APuU4Z9jee6TmdtOLxHr7lsYKIu+xpfmhA1f+x3CKDE8pk6ZGBtnN29+
	uU/EG/Zc1hBVylwi7ZfcvABv1DEGTrT5ETq9DExHbzb5xCIK6qkaTCQgUduRHMHmzTPxX6P6xWi
	sfG/UHatLfDf0BtYJwnD7hjqXlLcfNog=
X-Received: by 2002:a05:620a:2628:b0:93f:565f:e46 with SMTP id
 af79cd13be357-947afff4ee6mr33367385a.52.1794344923786; Tue, 10 Nov 2026
 13:08:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110202025.25736-1-baohua@kernel.org> <20261110202025.25736-12-baohua@kernel.org>
 <sashiko-outbox-207748@kernel.org>
In-Reply-To: <sashiko-outbox-207748@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 11 Nov 2026 05:08:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zEsCkb9JuRTC-k5-xvQ5kQddHF7Puj8uvUwB1GYsvkbw@mail.gmail.com>
X-Gm-Features: AclHuK_FV7UORW-D6TUozHp0AeI3TaZRQ8Kdbk21PFOTfmD3L-0EsvrYHcJnIFw
Message-ID: <CAGsJ_4zEsCkb9JuRTC-k5-xvQ5kQddHF7Puj8uvUwB1GYsvkbw@mail.gmail.com>
Subject: Re: [PATCH v6 11/15] mm/mglru: Restrict eviction accounting to
 eligible zones
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	zhuhui@kylinos.cn, sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9715EC0005
X-Stat-Signature: xmtn8khcgjnup9dixyan9syhfgbzfimi
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794344925-103656
X-HE-Meta: U2FsdGVkX1+WbI87XVTQxEuNCuhooQEVgqh70XLyGIimZk3psx86DKlLFUBnbVBMX5ty0TenEJLBt4q2JoZKcvbJUB1Dbck70qvmC3EVjB7JzMqNlYpcuZwyfxasO42EwMg7oX/8PYwsxmu8sWV1/76Ko45gFlUo3j4WiW7lgT3cYsOSTKr+UzHIe23rPCg1CXfvb7/y5jN1sc1fnCf6eM4GxQX/JktqWJ6ndpDfzs/zm1BN9fs7DRs5ox3Cq0kITmbfRzOBbWU/QvsT7wpw3iiRy6ohjCq8D1E5IgfqnFq3PQmo7zrMdhuHoyjg2hurn8GTOWgenCLKc4cNpCg4hjm8bckKGPZjukf9NcNGo5bfrbnuBiGtvEBwFu9aWG+svGCmx6aw/kxW22N01mL1ncYvk/uJW4eEa/qFy1BQYKWisnp6ffvN0JfiB6fjhsk+E7da2YGmh3fawf7RTGA1e+zpPUiGNl4q11uCZa+v4t4bhZj8zTFmB5zrVbU/U1v7t9YemM5dX3LV0nB1IZmShO2resQj+SAaRl2UJoU9xlVZuPBSxFCuByTnbXEJcIyiCuicH4VEWBEzlIIdzR3HW0HpF4dkvdf5EiUZii0JS7/ykr3V1TxM5TsFIdRPZtFcd/eqbKbtv1lDz+kLGCyasNiHAjr2dX84hx64eAlDQhC0JRgo7KeFp4Qrz6ngdDdlBUEXotIHWciMTxIvUvEfaoX7Ob7Saq4+vNG/YYpzD1J3SEn2nYnUScKhm1nT5n3Bac1pXjv4pf4S1uXvSX/oh+Cm8gfRH564vuuM2e3x3VePnY4JXQphYn7EHhLV+24rC/KKFnD3LJdx5iuAblBak5Tq1n9YySyJmLbA4bj+6AsWVd9U1UBEBTI85YNvXHwRWC3V8PbWqzBfW2/nAisAjR9V4bYdz8pcRM7CxXrfrmSpOMSlLttPZrUDSNZSs+jFOYDiFsRwAyQVd+YIVjx
 K9/i5n1j
 CkLdnX0vlmRUIuzvNYxZ5Uy+nL2CFkz+MwsAXsGfc6aN6YIVV3mpILLCcwp+Anfvv0yJqyCwN0HLAh7ohxCVIMdhs5xZ7NHg3io4O5PxNaxoYahmtkrHWg45fLKYdbVV+Ws3ZDY/MsLoI45yxjP+0WdN8Y0N+FT9ORpJC7rUpDe/20yi2hP4BMmd987oNl7mA4TLsd8qI7sCV8j+nPc3aSDdzkUf/kE6/SvY9qpT0agytRT4vtTDUGGSoqUkHcXNMQlPDH5k/Rs76znrLPV6Xgj6sMaU17BMC1kgDfX2TwPxwfKfkIyL+SYslqWE98ckDTTRsk6PqG8eY1+gDBf57UkfuTOPkJECI0a2DvymtTRBL09UV8EN2yojcq5RFtAHva+r/wfcE/32zkih8alkypTxDecjVsAVaKyrmt6nwsyhVSQI4Crmz6NEXUCZ7honogWPS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 4:56=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/mglru: undeclared identifier sc in lruvec_evictable_size()
>   breaks build
> --
>
> commit bd1d7f7120c80acf045074ac097e502f51cacdb1
> Author: Barry Song (Xiaomi) <baohua@kernel.org>
>
> mm/mglru: Restrict eviction accounting to eligible zones
>
> This commit adds a max_zone parameter to lruvec_gen_size() so that
> lruvec_evictable_size() and lru_gen_imbalanced() only sum pages from
> zones up to sc->reclaim_idx.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 8014a90e4bc29..bfc9789a999ac 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4220,7 +4220,7 @@ static void lruvec_evictable_size(struct lruvec *=
lruvec, int swappiness,
> >
> >       for_each_evictable_type(type, swappiness) {
> >               for (seq =3D min_seq[type]; seq <=3D max_seq; seq++)
> > -                     nr[type] +=3D lruvec_gen_size(lrugen, type, seq);
> > +                     nr[type] +=3D lruvec_gen_size(lrugen, type, seq, =
sc->reclaim_idx + 1);
> >       }
> >  }
>
> [Severity: High]
> Does this break the build when CONFIG_LRU_GEN is enabled because sc is no=
t
> a parameter or local variable of lruvec_evictable_size()?
>
> A later patch in the series, commit "mm/mglru: Avoid scan anon while
> swapcache is low for GFP_NOIO allocation", adds struct scan_control *sc t=
o
> lruvec_evictable_size() and updates its callers (lruvec_is_sizable(),
> lru_gen_prepare_scan() and run_eviction()), leaving this commit and the
> intermediate commits unbuildable during bisection.

Oops, my bad. I initially placed this patch at the end of
the series, but later decided it would be better to move
it earlier. That caused unbuildable during bisection.

The entire series is still buildable, though. I'll fix it in v7.

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202025.25=
736-1-baohua@kernel.org?part=3D11

Thanks,
Barry

