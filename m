Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78594CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 15:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876568E0008; Fri,  3 Oct 2025 11:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84DBE8E0006; Fri,  3 Oct 2025 11:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78ADE8E0008; Fri,  3 Oct 2025 11:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65C8D8E0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 11:01:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB72C13BD03
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 15:01:22 +0000 (UTC)
X-FDA: 83957116404.13.3616D53
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id C93E24000E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 15:01:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="XQIE/k8w";
	spf=pass (imf12.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759503680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rvoiyExDSEvJpLVkArK+JF0/gLIg1oSJww/Brn0jTdI=;
	b=0+LMqVOjb6RZKCsbwddz8siPvgOvtaBYqZ8W/cGklLxnMpwi9UmrA+n/QQbOKL7RwYgYMn
	iScyF9968t1qTBBTTJaoIurarklJLPv6u8l2tqNAcZz7+/ZS5G2K4wM0yFeYPJkIzN7aUL
	Pmzbu3eFyaYzNZcgbRKkGAxny0AguRk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759503680; a=rsa-sha256;
	cv=none;
	b=19woOCWi0dnhjfZyjzfGjg+zF5bP+Tbu2iJf5Hx8q8SBcgEf07ABY3Fh9JH+tvCsE655Uf
	1J/zfn7E93tE0pNB1qm8L73GScus9Q6INR9EVL2ekKxd4OrV+ktJJ5y7OuIN2bGz0uKcfg
	Biow/cwdkBB6MjPrTKaI0mZVsBGhiiU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="XQIE/k8w";
	spf=pass (imf12.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e42fa08e4so22082915e9.3
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 08:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759503679; x=1760108479; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rvoiyExDSEvJpLVkArK+JF0/gLIg1oSJww/Brn0jTdI=;
        b=XQIE/k8w2pdUWjVl2JC13t2d25LG6oph/iePjn87Af06o1KqRg5bJPAiRZcTjOlIUQ
         qe6alBNwXcLZEjqGfEMk4s71wWuzaQTBYKxhMWA8uLVU5aprUKAhqy7v5Q24Qqsynde7
         hQwUpxsf1Ltf464AjyDfgYLquUmFlDvRf6lSVkaKvuYyukKeuPN0x+dMGEIphicUL2BW
         nthzgT0FAs/LVJ1IyLnWED8hels8YapXe7aKEd2oNMRfNkIHXKjLR+WnMg/WAnpeZNR6
         hnEkfMDh0xBzLxcL5ajzpRe7BPW2Fx3Hmrh9d382vci8b9yeUsRfRhO9df3YPp/6vX64
         GuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759503679; x=1760108479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rvoiyExDSEvJpLVkArK+JF0/gLIg1oSJww/Brn0jTdI=;
        b=wrfDjltJ8dwk/zomZDZ/pbzNfKjbAASvMKErUtqdoetYZVZfA5KniBFQKckQiHN1tQ
         OZDijH94CjFp90vn46Sx3tJooHk5O3P+NN652DCcuP5ZJc8fQHtj6TytEoVKyNxQMmyL
         d4ZX4/mTjdOfEiOTNB39qcmq4krwlvB+fcRD8eOR+g7PbFDhQgwbZRsvZ4fGaM35he30
         4ccUtq6iV345RC9rrxERQAeVgDwgXWWYPQnyQ2tAazR2BCjdlBCh0pzckjN3AMgm1Vif
         +apZl0boncdFQ+cCi9OUBTwtFOTQR2RlhCt3D5ChcMcd1ZGLa8ilCTDC29dt83LUEg9J
         7KQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMA+a79XQcS6VHHYpxBrQSnMAEQBzMxDYSeQufhuMcSTMjKpGpV+DjOJZUHMMg+SHocpBOnJrWOw==@kvack.org
X-Gm-Message-State: AOJu0YyuD0uctDOFwKClUSHIe8qTiJd0v4vEO5JvCImEztisC5JIDEmr
	Te78EiRGhX0/zbvNw1OHkLlhk3Q/RU7UMrc/ZuR1c6ZEl4ULCqH8XLmxq4+OEsM40WRIcWhv04X
	AeK2suAmY4EzavaxWIeFrVd7PgbBGvOU=
X-Gm-Gg: ASbGncvupwz7ZoFDpsUzwJJx2MnF9XEjoKAHvGeKVHgO1naxdVjE56KptKzIHcMNjJt
	o1HCEFv8d98z87Zx0UlUvRDcONXXfBbICeuMy1I++hPM/zuCD3Mzz0l+T+xb99QIV2NbcD+Lgtd
	umwZ2J39fY/GcXN99vXSVHDRWa3yFcmA0UdxFkCgEHHliF5FgOWifZmGGA5IEMI49hqSRXtLz5S
	V8EU+SV7ruoauXEXEpRNsPWBXuDQmgRXy4SzzbiFUiUzOpB4qp5RZg0O7wDaMJTbl5A
X-Google-Smtp-Source: AGHT+IGhP1/atGsvKEKDdjwDJhtnkHEnPkwva/8TFkjZbQaj2BQDqokdY2zYTli9XTOnEez1YY3KKjNm1oo6pN9k7fQ=
X-Received: by 2002:a05:600c:19ce:b0:45f:2919:5e6c with SMTP id
 5b1f17b1804b1-46e7110c3d5mr28401455e9.16.1759503678161; Fri, 03 Oct 2025
 08:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250930083402.782927-1-ranxiaokai627@163.com> <f72deca7-4344-4adc-88e3-35a4a1d9a30b@suse.cz>
In-Reply-To: <f72deca7-4344-4adc-88e3-35a4a1d9a30b@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 3 Oct 2025 08:01:07 -0700
X-Gm-Features: AS18NWDeadN5gWCPdehSIc1K0vm29j1_C80YFC-7IO3Xo557HA4mE3AgwK0bSQg
Message-ID: <CAADnVQK0COXqq=R_WZU5stBe1b+472RS0+JJrThnbxXadBgN4Q@mail.gmail.com>
Subject: Re: [PATCH] slab: Fix using this_cpu_ptr() in preemptible context
To: Vlastimil Babka <vbabka@suse.cz>
Cc: ranxiaokai627@163.com, Andrew Morton <akpm@linux-foundation.org>, cl@gentwo.org, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Alexei Starovoitov <ast@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C93E24000E
X-Stat-Signature: ugpodgru5yodx9bo7xnzijxeqfirj6tc
X-Rspam-User: 
X-HE-Tag: 1759503680-646513
X-HE-Meta: U2FsdGVkX1/nNBrjZx4jvG1liDgVY1wqdKQKBJshraejnuDwn1kOxg+VUzeDE8kJfdTxKzDgGgsdjv3R0P/4EvGMzSg77mKf8zRwY6clHuVJ/bqAriiasoLNTpb2kx2fxB4crCnYAMMuIGR7hhkcDKpYVGc/yd/jiiO3UiGVIgAItrM1sBLQLPSUm/Lcdxgy747CF8vYBNbO5ICTZcz3Irx7dU+uetgswYkHTkAlkGmfjr6m9TcrMT0X41RAu73JxPkmli4/1EiZHrDLe2p+EDb5xtjDFauTyAQgdj9xnqB24vG54j3BYxVwGIifriFuOmbmZoCA16VwuQie/6Ox92IVJsh5ZCqKoIu/tBAqjFZzORDT4ugvH1Tgen3GsXBJTaEksPBDmAMXYirHiuxqqxa5WNTqLbVK8cLG7CqcaD6vuyMpin4IN/PQtSn3lyxeWBaBxZlJwApotn/nyLuifKjgkV6JcS0ftcxzsP4db4NaykTVKjgTUizU+6DIh29YfWntQuZaG9CsJm0k3f5Ij72/6fsEDTlD0di+3OO/GfwWJLhImJHkWK+KJWUo8ezh0XaAsC11o/BYDFfTuBBUdcY/lL7Zfxu3+yg0CmLTc9Fq00dRhueCsmouovqHBXcosk9dUT2sKKJDmA79jXp5Z4PU0kwGaIpLcBsSrC9UKNQxF4PM/xztrGd5OSbPiK2Pk1pyHZRN0AhipUxkI0WmCK3XkeFBRXY6EV1Aw1BFu9dmzU9KUjyB5erEOH1W8e+qLZ/331rt821yIR40ZGU0TCjgJZ5XboNks6yY/GS/HQVJk1I1PRQtTwgCIrEjjys/+yg4j+DmtI/IW4mTJtrVCtVP4Sn7KV1OAfFZbspKVpuYs7JnBz+zI1I2qoasx31aY8edYpfGdQllgc0nMQL8+j+KChyc5+PKhzrkp+cRfJt6fWhENnSY31wjpcXp/dfs5CAQIyBAstWpBB/kdwT
 w3CK+5EW
 yIAMtaospcJrdgBWQwhcw1mLkSvGjcTgMHDI/rt3xQ/YrGpg9/Xtrz5jnFxtC6H9FHrKf/2AO9/FQe19N6ycy78MPo6kIdjLv1dreXzy0OasK8gPTESlBiGQrW+pM9udUBsNcHkgo0i9051Iq0iG/nissxI3Si/X5eByS+mBQ+Mx6k7d7GD+n5EOPbG46SktJ8EOwMG8FeoYIeT0+FzPoBH3md0KWHQpilKCZ0n39TF1OVm5QkXf+uEpIl2XzTNrYXj1T6TRsnUh4RUTIOh8gXfHUco3lVJs3xFWThWRjumPPGHlEV+YjjESAg21hyTUgmVUsyK1QdvlA1BxmcF6uCPQixYgChCJpw/6iP7WovqSLWsgWDvDRo9OJAzIu8hT0MKH8tf6BGEbrojsI8KhgBTUsZYRuRQCoI9FRri2sVmv8sArtZ2fThWzNJ7pIxT+MvJImd3OuTvFxEfxG3ayhGjyx08Bv08qRicA24KOE1+3QNwYxzkIUsMuqqQctPebNNv+JBGsFZg3L+0zl4D1NrNJbG8aI8Z6SVVgO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 12:50=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
>
> Disable preemption in defer_free() and also defer_deactivate_slab() to
> make it safe.
>
> [vbabka@suse.cz: disable preemption instead of using raw_cpu_ptr() per
>  the discussion ]
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock()=
.")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Link: https://lore.kernel.org/r/20250930083402.782927-1-ranxiaokai627@163=
.com
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Alexei Starovoitov <ast@kernel.org>

