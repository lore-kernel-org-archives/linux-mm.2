Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B21481061B18
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 18:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11BAD6B008C; Mon, 30 Mar 2026 14:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3626B0095; Mon, 30 Mar 2026 14:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031276B0096; Mon, 30 Mar 2026 14:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E903E6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:52:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 891A4598FC
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:52:37 +0000 (UTC)
X-FDA: 84603625554.23.A5F5842
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B289D1C0002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:52:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KagYQeJO;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774896755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=liIWWgh3PHR9mQyTHAhDipXMUbIjVFVPZYvEzlHWcPA=;
	b=AdECAgr7Wq8MV/Y4R14FiuK33m4W64W01RWVACiWWLK4MVov4a8CEnWMIMrz/VnUr0R2uo
	ptr7XLEChx2bNy4O0XgB7ZbfdSI7Le1vAa8EKySVnIFd3kB9QgI9fH3v+ZzSP9VC7Sc1Qa
	fP0NEWov8aPUKKphUyA+xX9X+KaQOv4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774896755; a=rsa-sha256;
	cv=none;
	b=3ERX7ImSLQnIV2krHOH9y9zAEdWy5BTtxq60ppdTPTRjk/xRHvwn5zki4oi5dPd6z17pTm
	K8AQEsD/TanJaap1k7UIa/3RrJnChMWeTHfsCRRuifj/0h+tqZSELG8MFA5aB8JqqF+dCc
	cOjm48y/qMWRXBbLjIlDW7VzYyFOk8w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KagYQeJO;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BC116012A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A39C2BCB3
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774896754;
	bh=liIWWgh3PHR9mQyTHAhDipXMUbIjVFVPZYvEzlHWcPA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KagYQeJOlSGL3kfsOcc1wqmwJFO/SvRwu4RusSJKBcCwNB9g+SFyCuZk60NRljReS
	 +ix7Upcou3dYQcQt5/8VPEYSxNSrtbqw3G00Y1FyIJIUy+LB55GgrIzs3sDMgUIeag
	 7hGXvK7qlS0//TJHCbi4zZN1LXFS4WGoT6M8TqM6QUghVtepriWynI2yThZdErXDyo
	 XamMJ1l84/ymUY2u5GZ1rSCCpsJdCtbFdT+D426H6N8BFYO+p+H2KTsGELYDhfzk6E
	 hdRDGkcHz9bHI7vmHo9FLBuhCKzj3jF2XYIh6s8yy9/pLyd7BgBJLHGI73HwdvptVV
	 OoKw4ZxbaOPxw==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-66a851e62c6so5076580a12.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:52:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVp3wU4g0SpvkejJLaI9gEye6Wc6QMvUbNF3dRKChrKFLB8HOz1WnMAYfUOoqVPxEFCbvKgAHc4Mw==@kvack.org
X-Gm-Message-State: AOJu0YzYt3/nRHuV0UoBxnK8/QsZr+cZgEcEC1Ntk2pkSCcP9Uzj0/9O
	W7VBMLUHTPm65IzWYDGHkDqIsuPaf0YbpP/SCe7+Fb8H9Eyh7wgh8rpubye7KzUbZWcBJ4bmffs
	FJkUWT855nQHF39MfaOz9yDc++jcZgys=
X-Received: by 2002:a17:907:8d8d:b0:b98:528b:844a with SMTP id
 a640c23a62f3a-b9b5098b5d4mr835193666b.51.1774896753619; Mon, 30 Mar 2026
 11:52:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
 <20260317014802.27591-3-kanchanapsridhar2026@gmail.com> <20260326192351.7fc8c27d87c60ab5f7de5395@linux-foundation.org>
 <CACpmpofW2hcmQ5srg=a_WT2fXNhvY0pp20rjxxL=n0jGGUEi2Q@mail.gmail.com>
 <CAO9r8zMSnRq02b68Tjf_yi+_Wg6TBgyM53gaxmfbXhXJ59Om6Q@mail.gmail.com> <20260330115141.997e29f96223da1e22c0f375@linux-foundation.org>
In-Reply-To: <20260330115141.997e29f96223da1e22c0f375@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 30 Mar 2026 11:52:22 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNRcSBdBthR8Mk929pT2z_Ew_vc8_nLJns-2FygSX630w@mail.gmail.com>
X-Gm-Features: AQROBzCxTWZ8u2aqB6rgkjfwFYtB9_zzffu3EkbHE4cRv_DbXnFzfRhDK4MAd_4
Message-ID: <CAO9r8zNRcSBdBthR8Mk929pT2z_Ew_vc8_nLJns-2FygSX630w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 3inieqyhc5cyywecrnidy6sajbdw4kaa
X-Rspamd-Queue-Id: B289D1C0002
X-Rspam-User: 
X-HE-Tag: 1774896755-218495
X-HE-Meta: U2FsdGVkX18L+/j6Gsy00aX68IJ7+GYaPeJSyzhOCxXrhLEO9+EvdMj8tqwXM5jQBMUNB+hs0aQcNXgey6OumpM2Vo0DE947SOQMIKrm9BuMjnyic3WGp/zPuZ3uZaoiuwp4FayyKGkfiA8SeQUxcB/KD/IGpTbfQ0hjx1B/LZL1tz4J4wpgleeWy1ox+QrpPNz2labDVehKG/Ehl7OG3kXs713J3s6wNdcl/CyaWpJrM7h6XojEDWRXOnEBZv4LClgt5gRge0BW8uVYv2s54s4hSFOrT0Rj1YRS0Y3U9HvnhLhExEnGbIBjI/T1oPXOAK/w8DD8ajj2MkXXeRJHpR5MtRgi82Tbq8KtjlkP5TR024U5D8CdEJF4WfMtXoWRxPESuvMsyxbYhY9tbbdFFc+BSZ9sBomWbw8yhl8awbL6WmewVz6UVPnYztLBEJi+ZRXUjZdqyiXWW9hdMXcA1YgnNIIuiBg8Z5SwUR9U/OgtjoPNGi3EEnhCOnXuvh/KSijP9WpETXdl0XR/m66EX+REf6YkSGgtZTAvhx/zYJp89BSL+RRqt30IHZg6axYfVF6VYtnBkFZ8Tb4hDdfV1ES4yQBqT/IAagWLvvZdMHiZPiTViRx7PP8p74iJa0nWv17Tc6UmiOMG+8VMjqrasUdZBGljcfoXSkEpFfWYqEw66bilQpNSlM1R74GEZ3lXO/cmXT2zmYcHXzq3Y/+R8HQNoTqTayOYnUFWuJAFaJsDW/q+kxsGdmzWaE8vJBvGuVqhw/gaw6EtepOIslkQUxomuBpM4OPHMY3yAdep1YxzzwPS8Pu4INQTsJGWA5wtaaE1BGNzjeARMOVV9lC+49t1ylAx3MZ4txpTgKKfiF4acyc0TruRv9uEQoJDIYctdkeZvbksqu2sE7/oG/kZWux0ztxV9jp3iKtCq7BEPeCJ5dVSF9k+xm8lsU0iCWVwEtrFHyj6mSWl7OBuAyQ
 gC0yPZqt
 W2pYYgwdVByPtasaLDiPnveteu7LnD3VLU+oX4Be1EzG1gJModmieWpBdP6+6UUuh93K8y3CofZ1zoL4NC+SPdIaO0Y1DiGVubXjYbPDNMzMoytX+ME3AeCDiCagmnoEg+MNIa9HRzXXMOLTLQ5wBstCWiH73oqL48LRAUbfUzT9B7uQLI0nyU5tF5fgHraTTniM4VDguaDOXbN1xiyRZ6RjE35wAF+sbvsRYTDW9DW89mLnE9ZytM6EuQvfzno3HW0nHAvo0ACKmsG41MVHMKCOQn8kDSizDhbITCKnjEHuiqLREbAIv5pIL4dYTALaK08lqkHfDSU7qXqO8cnhc14NTca+au/psRygal8NSlcdZHEjT7wIfPjQkS300gyKhNId0gBP7ujihSgJ+L1ieAKJ3W1iCMPi7Kcw+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 11:51=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Mon, 30 Mar 2026 11:32:07 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
>
> > The patch looks good to me, feel free to add:
> >
> > Acked-by: Yosry Ahmed <yosry@kernel.org>
>
> Thanks.
>
> > That being said, it might be a good idea to resend the patches (new
> > version for rebase + Ack?) to get Sashiko to take a look,
>
> Yes please.
>
> > hopefully it will be able to apply/review the patches this time.
>
> I expect so, but I don't understand why Sashiko is having trouble with
> this.

I think it was a transient failure.

