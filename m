Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 054EFF94CC5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 04:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7416B0088; Wed, 22 Apr 2026 00:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58496B008A; Wed, 22 Apr 2026 00:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47746B008C; Wed, 22 Apr 2026 00:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C33C86B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:31:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43CF713C6BF
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:31:57 +0000 (UTC)
X-FDA: 84684919074.06.8201C25
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 34EA7180004
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:31:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b8ghMvws;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of qjx1298677004@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=qjx1298677004@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776832315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKpbukl/csWxCpNtEhbFAtgYuBh9hrYOWhmgDtMm0XI=;
	b=5YvqhRSgSn2lDXNR38pHljeMzTVmpYP2c3QDZLF4eIEC+0qLIkbL6jWUz1C9RC68nVrJnO
	nKeN4mmrZXEKXYGi2L78WPdObrh1dThWtOZsPPQ7edYxoanruDeunuD2wO8y+BlLmmIWDN
	ugMZUy/FadxiJTYBOAIs0zmVyekCwlQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776832315; a=rsa-sha256;
	cv=pass;
	b=GtqbAff6l6lMLkYFSChM6KiFbpoxnN7Cb2hipRxj6AZhvE0452D++Pw/5Ub2Tb4TGsSw+e
	MtQA1Hf3eRkEQCtoE9Ic1RGia5b0BG7W3q6nmVGbRJ8M5aAIUm8EeRQitVZBMQ1jl0Joc5
	7PGbUPYUVMDTLqgeZfJV/G2MObBcXkU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b8ghMvws;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of qjx1298677004@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=qjx1298677004@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82faf871346so2454518b3a.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 21:31:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776832314; cv=none;
        d=google.com; s=arc-20240605;
        b=DwApRWdbcCMvsr2J42C8hxe+eftKGpdAjHLPqlzfwM7EVhf54m/LxdupvyUVtg9oLB
         nrFcgeZMwDkD0ls9eD51ZNrdkEnlHV+TJ1inPGdd0jAEGjy6XiC4QrS3iZkzRWLVuADk
         eQ34HkubM9ITfWmEncoe4xb3RUxu+1IuggWRNFDD7QHp8LoqSa52cfhTo5XmlMUUx20l
         gR919aS3EtLGdxSUATIU8f6J1L2LAJ1+4hySTCdZtwWDCyFXS65yV8EZJ4XSgbw/GssZ
         5y5A0kVSBSTHipLahvSFSH0gmknnTpD0b0OwpteBfjuOg43Pig/eK432T61vzVkkG+8I
         yv7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pKpbukl/csWxCpNtEhbFAtgYuBh9hrYOWhmgDtMm0XI=;
        fh=D52PtZwZXK3Qtq6PC/urS8oqU/dIlfR4bfhj0fEsyFA=;
        b=Jb3XWQuOMEuPXgyutsVSToP5fbmOKgQmSmSUK3W7yvnIpjpXK5Ejf32o8VRbE4cVhX
         Rzp6G0xAK8SSpQfQ82jsy8sq1NEh6jonHY7IDyobjcmJqEQOiJTDg/RSVxgoPzY9yP8Q
         qK1mwveqdwy699/CD4RZQtOI78n4CDQcbKX2/vFRs5mt8KnmP35zCBU4brgu2QH16/Y6
         IFLj3QS31R9B5QNotwlaRF7bGOe6+QvHth5aJd+JfLVN+sQDm5rjN2pR2krnIsgrP3in
         5UEqheD2ks8ZoD5j9qJ/IdvFLesMqqk1OEyXAEN0PkQGFWV7MmVpZF0T5OweSc5QtGgA
         Uzog==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776832314; x=1777437114; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pKpbukl/csWxCpNtEhbFAtgYuBh9hrYOWhmgDtMm0XI=;
        b=b8ghMvwsS9IHAT/+LHwrb32VKzixzyeaaAvlTtjXC+vsXS9f2NyITV0OuFr+Q8tlbm
         Sl5W6g3UwABADOb8ZpeIdMEE3OxyUVwvjj38Sc0z9aYrqWVbDBskQFGpmbmHSLjJofyy
         WWpPxSoPof+T6vxWJcrzPUuSpkz6J1wbBXun6dyoGkY4/gGU/qXIl7y/gzTdoU2pE5TD
         im//dJBCkbjljIrJ9mtubrUb8oJ+ruzDOJpmisUNn6kjd5L5zAYEJocLY28tEoQPCsvC
         lLlbnr5p04XzlDOnTFNv1Es/zXtSn1BP7Gp2A9wx7u5pzTd6+rShIN1LEeQIc7K6b9G2
         Gi7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776832314; x=1777437114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pKpbukl/csWxCpNtEhbFAtgYuBh9hrYOWhmgDtMm0XI=;
        b=LxbhFDoHnzjuaOb62NY2v833TVLNFwsDutNgqjqPCOKnN8zPZMhk2/96Zuj5p2RN/z
         Qh3UJsLHD4wXhQ/lieR5MzSKrnq+UM4IAnf1bw3/1OKvWPnhVT4v33FmXCRyg4vE0CBR
         ZTYU6uZxlykcSQ0z27UmZRwHHRn9ckzGzS1l2+jgXobgnbDJ4+dKzFs0DX3o9hN4k+LD
         pSj3wwHERFoRMa7NEFwweRCBs/Z+3yNtEYV8zoJYWM7ZfrZjYdQJxEDWvUxefTyq/DXJ
         4N5Jhsah6lf+m2bIrCBanItHMWO2OZWsiKiY88rP5/9Alev6sILUFgiQSPNqQnt7Fu1F
         8xOQ==
X-Forwarded-Encrypted: i=1; AFNElJ9CYW6/jfxot7p0wfDRsW46J5Z8m11fPjSu+V8fAplWbUKhA4RLiT1cd+R89GoCgB/kRAOyTkrofw==@kvack.org
X-Gm-Message-State: AOJu0YwyVfFKK3xkt5CKD8nzBWwF0IbCKcCDCjdWlk0RyCQ0HF/nevsj
	0h1HSsnXv6j1jb7jmw+aG5hKqEMaZWi+O2D9jZcepYghZmOl+sCNFWDx9Xfkyu4Ltxe1RwxZySt
	p0NFS4vvR2x/kuq+xRzJT7vsYZ5QKBeE=
X-Gm-Gg: AeBDieuvTN4X3tt2KzJSpMDKmfBwhr1b2lMcW0usL2ry0QFfKisAKfPByeWtL4DfuLN
	RJ4PB1oe1bdciEF+Wk0AYCbveaUyewp10rF72PIXCWmOwZo6avhxwpw4l6USgLoSoToU84B1eZu
	LfGiCfl2gdwypkvk1/DYKkH3lGrcLbpVMI4UhH+IbRXFMkM1uGiMrKk6GSQ1G33XHZsavKnZ6C4
	Vmx9/0mhkeQ9y61mdYcxSwOUs/OZjsqDcM1TK4Fc0GOSZmivqlxmG6tg5RJ9QdHqre6ZvcPdk00
	GWgFnxeVjv+iikhR/yY=
X-Received: by 2002:a05:6a00:80c6:b0:82f:8e9f:bdd5 with SMTP id
 d2e1a72fcca58-82f8e9fc333mr16084294b3a.1.1776832313733; Tue, 21 Apr 2026
 21:31:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260421070632.161808-1-qjx1298677004@gmail.com> <20260421234730.2917-1-sj@kernel.org>
In-Reply-To: <20260421234730.2917-1-sj@kernel.org>
From: junxi qian <qjx1298677004@gmail.com>
Date: Wed, 22 Apr 2026 12:31:43 +0800
X-Gm-Features: AQROBzAIFaiXid7kxspoe9kHcMj4Dl65yuqKyQFsVGoaGj2cu0HUaj3kNW0odis
Message-ID: <CAAkLyHRCUS7=YEQRrLyRXX5X10pHDGA1e2gnKQsLvGkcqUy2Ng@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/sysfs-schemes: fix use-after-free on memcg_path
 and goal path
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 34EA7180004
X-Rspamd-Server: rspam07
X-Stat-Signature: fi8fhyghcg68h7phrg7hri7dbfrnkr9s
X-Rspam-User: 
X-HE-Tag: 1776832314-437159
X-HE-Meta: U2FsdGVkX19nlKVfxVf1y4/pLff/kBhpsKKEtqTtuhf2/ece2H4Xw8mHBLM0SEz/RoLAbb93PXf6YRKdpixM1YZiajR6tF8sfj6unR6sLUslHhQ+A07UrlKAuPeLbeKZrD8PgE4DQ8Exq4JhBnvZH/3zuUawjs+ByXuO+3fastA1+Wn1PcCjhLUprpOwCurSHXvXyzGjppxaoiCPebf57+rLUk5kuH3kpqVSF9xkcxl9ybTxZYGo9807bKhGYB+PRE4wiFWaBRHmBgW0OVEJplkjiSMvd4xjQO/2IZAYq+8tIcmBgkue197bzvLqYC7FGTEtCpzolKNa38OxbRlMzBAOo7zaDllC61mwxDT4pjD8BEINWnpq7YaAWLhCyYL6LzWv3zbB6xtyy7oOEMczVUp4Lrzl/k+2VYnBp9GDL0MEKLrNT79XszXAFKxrZZfF0b7DOqT4jYrxTaLELT+GGKYDoKRZsweo659O1AoZbkUqaJsxq/13ZtLIF2BU5CChVIg90XjgwzqHewOZBxDHXH8bevr/3ghnfROsJOHAHx0eytEap3BTgJEP/zF72EBcVtM3N9Ct40dnAokqwX1IEGGjzQ5KKmccyt4W9Uo42jjQChQNGz27f/ChrMkaF8cfTeqERz+8zL5GlmVf3ctbr0GoLr1yUcUOHrAb8l1dzVElqanecRW5s/VoqzzyEOOqay8rPr2HXQBBMpH9EbeiT/g463dbpyw/5wJH+0b0GMhanuABsWiYSfY7qQx44bp/m0XxzUWxdr3iIdelSPa1FrVrLHeEFFJPQDEGLd0KIoXUWWnb4mxAM/68Gj7aER74pw+44HBEbRp5qct4wqvo05ukEg0HTEVVVi9aHhIhWqkpIPPmnRVgEsT7W7uRtqUXxZ3PLsrKLK4QXX/I/FzE4In0yUQ95ApzyXh3dx9iWtiLyqg1fFqxF56lklinTQcg/QisDKkqz4IrpK4C7M1
 VWkQWHR9
 27kRYpoDEYKHtBQ+Sc5+gAWxRPbIAvOBcfmiEKjA6Zs2wd8Q80W2G63HgXSJbU/NiSS3uCIBCMnV+TX+EhNWMAqCs5ZHqLfX0VSxRPs+/1LwGKRkaYvMngwyRHr0wlS75OAfb2aW4KtULJcffPSnUi7CtqXHPOHs5XhFOY9PmtyS7HwGJsUBpg1Txp2vEopJuHc4f6q2WNURrVQ4jSebQZO0191i41FMbBEOz3BUvaMKLqS7DWQoxmtehXrjq8AjcfkRAQ3uYS0QRj5J2xrlZ0aH4Kq+U0PoFAjV+gsO70FT2y+zKFRt43dnJm43K0NN+4R198A4YnQbG6aTnVQvHjsk7wwr+RZy1fevm5tK6uJN8hdDCqOhEh13ZSA26nZELZ74ABG57FSA0uvyq8SjQ9ziIbSe+x4dRoFfn66295RObBSW0GuGUcQnGNpVgEjKqp6jlFzVZAdx3o3UiMPFIb7xm3dDVSlLIwViLkr8i71WhCMMPe2EsLTEt6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Thank you for the suggestion and for offering to help.

It would be great if you could finish the remaining work. Please feel
free to add my Co-developed-by: and Signed-off-by: tags.

Thanks,
Junxi

On Wed, Apr 22, 2026 at 7:47=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Tue, 21 Apr 2026 15:06:32 +0800 Junxi Qian <qjx1298677004@gmail.com> w=
rote:
>
> > Hi SJ,
> >
> > Thanks for the suggestion.
> >
> > I checked the show/store race further and was able to reproduce the
> > memcg_path_show() side issue on a KASAN kernel.
>
> Thank you for sharing this, Jinxi!
>
> [...]
> > I will spend some time thinking about how to fix this properly.
> >
> > If someone more familiar with this code would like to work on the fix
> > directly, that would be greatly appreciated, as I am not very familiar
> > with this part of the code yet.
>
> I think you could protect the memcg_path and path load/store() parts with=
 the
> damon_sysfs_lock, but using mutex_trylock() instead of mutex_lock(), as I
> suggested.  If you prefer me to finish the remaining work, please feel fr=
ee to
> let me know.  If that's the case, I will work on the fix while adding
> Co-developed-by: and Signed-off-by: tags of you on the fix, if you don't =
mind.
>
>
> Thanks,
> SJ
>
> [...]

