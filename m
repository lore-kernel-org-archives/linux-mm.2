Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2410CA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 14:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0648E0006; Mon, 22 Sep 2025 10:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98498E0001; Mon, 22 Sep 2025 10:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD908E0006; Mon, 22 Sep 2025 10:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A8ECF8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:55:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F30D138162
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:55:30 +0000 (UTC)
X-FDA: 83917184820.16.3A25EBC
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 52A971C000A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:55:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DB3ypPhg;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758552928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvVveR+eoaL9wv+8XBbQic5VEQu2ToLre/5kbgHOc30=;
	b=NJ9Gu68cb9IPPM0pl+B/Neps1ab8nJJsHwW8tMQqadd+gkvEWPH4NjJQdoMJFhp/64x4Ph
	J6+IzZtxt8ntUZDqHzTvpOGNVM4zBW+vgFUZtxjiOUidWjpkKZsbkuvfC5ZlBdT08t8I2D
	pEoCBTCeqDAvVQ4bR8S+kC/EOueyKMA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DB3ypPhg;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758552928; a=rsa-sha256;
	cv=none;
	b=bKCa+q78dxQMlo4seAz8r53Qgr+fnzDw/lKh40gLJZE9yf9/gOWwzQGx7rgfWv/wJS68fM
	ungEQsVmDjqe6CpXdjtjPV1HRl+DAsfM6Q/zxRawflKghVHySRRJ0LQC0RnOn8uKokPClL
	oqwu+WE3LaGt+Ga/HEiTJL1wmnN0Bis=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b60144fc74so57820391cf.2
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1758552927; x=1759157727; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TvVveR+eoaL9wv+8XBbQic5VEQu2ToLre/5kbgHOc30=;
        b=DB3ypPhgQoFjQ/byc+MudbebnOlDhn7sil1YuXgEFykWLyaMTzqCXOsd82QOcNKJT5
         vtXlTI8SAhrQBiZEgIdyE7zKOf588ewK1BkuVFdGt4NhqNtrz76IBJtJ0iK2zGbRqHZY
         xml9mBFRcMZxRJ5r0VTJlKrlgIAcU9lOhWyTQXTr03aT5SqKo9dZHRoCo9gWKCGmvNj6
         OjhujnK8llsMRxPmOLChFscNpdOnUXY/Zi0mF+flrh+M9OLrj8ya0OaXhztXAL5jsEhJ
         Ah4Ba4m03MXFdK7WvlqJH6lUCBOu/FegvPb4IT6fB/gXyZ87afhJXyL/irugj7E6goiR
         DOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758552927; x=1759157727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TvVveR+eoaL9wv+8XBbQic5VEQu2ToLre/5kbgHOc30=;
        b=HeQUsMml3naUlZD5WaSL8SVegApK2QogBXtoXRlIKlRfgaeKoftz5f2XdUxI2rvcDC
         TYyUugd2AAWkwh9eDHW4L+HBfsj2b60POLAR6N0aw34bL8C2qU2M5NFUvY47JJEafSDP
         LzO2o3kk0E9bFUW7ojPemq1sEapu8VqrBw0J3QDQK6Qczr3IEJTf1AzT63Y0HRL6154+
         zkM1OkwgOBRHgBwJA5LtArEVcEI/9oDRnLZg9snYip0cbkgWQDVhFkYJoJnZHDebgs/M
         kx0D5L5PHID3Th9GRaxk0B67z8Elj+v3rk1TbTJTkNh7HPvtkf3IJ21J8mkxzTobvida
         gDEg==
X-Forwarded-Encrypted: i=1; AJvYcCXkxTYi0tGR+1M40bYBBJ6RSbzvBnC5fei/URprULKYuUbjpbpyPWoW5KURbxMCWLhN3S2hmXkXVQ==@kvack.org
X-Gm-Message-State: AOJu0YxVXRHyaj3uLlL0qCBuOgkPJM6uyA+GYu924teRtKD+bjZUbHtP
	0FAOW/xw0Alr+gI8+w1UcoA+4Dj4gejlgLLbdA7i0uPmfrFX2c1s1Aa9mr7y5Hpe1n80nQ8Jwvr
	FEADigFX630hFSHdQTBbzLjnKtO7adeAz2lvQIhFHrg==
X-Gm-Gg: ASbGncuS+mJdiQv6ihgjYP5p8PaD1TrvTOO93TEFUFJqgucBjifFzBT9P9QMOitCyR2
	zIV5u1G7RUvN9DGLsk3DTJ6PiTR4KbweApZdHirIFi3NdWDIPc26vAgbfWD0bKlhDMIrjvUaE78
	rpKyrm/DbzdRtyHaosSUWhO07tVlsSGMl1iniCwFWi57OfCWl6i9VsHwqFkxnpYP5yfY943cnaj
	OaU6+SBqV+FqZ8=
X-Google-Smtp-Source: AGHT+IH/maFhVZagCabAuRpSyzOdLh5RhCtxYHTL9INMkCpwFUrFYMQXEcKIhCuCFYP9Ni4pPChjhYdVr/+VltB6kGE=
X-Received: by 2002:ac8:5f0c:0:b0:4cb:713b:6f08 with SMTP id
 d75a77b69052e-4cb713b74cbmr35760601cf.34.1758552927041; Mon, 22 Sep 2025
 07:55:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-10-pasha.tatashin@soleen.com> <aLK3trXYYYIUaV4Q@kernel.org>
In-Reply-To: <aLK3trXYYYIUaV4Q@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 22 Sep 2025 10:54:47 -0400
X-Gm-Features: AS18NWDwJiLL1FUZIWpx1NLSWLJKu-G0z1HFpnmPi4SdOFce-N6qgysbpZBTW0s
Message-ID: <CA+CK2bAC_X2ONEaT7XYVwjB=fdN897JnmVnt5f+UELbuKR+-0g@mail.gmail.com>
Subject: Re: [PATCH v3 09/30] liveupdate: kho: move to kernel/liveupdate
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, dmatlack@google.com, rientjes@google.com, 
	corbet@lwn.net, rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, 
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com, 
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org, 
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev, 
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com, 
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org, 
	dan.j.williams@intel.com, david@redhat.com, joel.granados@kernel.org, 
	rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org, 
	zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 52A971C000A
X-Stat-Signature: gej76198imqehw9w6oyykwexmgsb5fwq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758552928-654828
X-HE-Meta: U2FsdGVkX18RZ+org4Y5yZNw3nfM3u+4UaY0oVcdoGaKcDptD9YlB1V0cg9M1uZimLDTXKkGvaewz4BDde4UtUmTVvK1FGS82PUn7i1M8kjNMCJcssrGI0CnuJQEOnnYTnMY9gT2N9ZRgPmmXJeaPh5b5hIzt1mEMWw1IzWuJh045QSBqgDuiVZQQTHMaTv3E4w15JluNu0/fi5sn2ZUhYdKUUhXaXFBTep4N5kbgj+rEuLYhjgNSQfcTxg1P1EOaq+Oj5oyAEnjw8U7tseZB8N6cRAPjvjAWHAiNhq/BEf88EPXBYUWSHIbr3USKnL9ejLDpepy1NsZJXJrewspp3BgjIncgc5+aDKpIwFJi1aQKZMtNy8r9J3BUjVgJ3sy0fJ1lACVi0GH5DpKx1UNUCNvo6nCYLwYqgau5vKVxJ4eoY8z4u7vKncFJ6hkQikbVoLcYQ+4SOdP3OBQR8E1sgz/IFfhzAYSmeLpFARPs8yZaAjZWIX8CqECl08CiWGq17IH7NG2K8USD4KDFfdiehZnLBfkAF8KmjJqJT/zCBKsgsqho5GTqy/PrZaqt4vypNm1V/P+ZlQDSkTEkMu6awordnj0N/p/uEXineQteCXs6HCzWsJ9X4y8vI8ayfRgiLiddGJMUFprMMlPvIprP3tZWAehPo6I8jDl21e3cdKxVZZBhJBJ6ldTnr7MJyO6wvin6gAskOPirENQNlEd8d7P2qoOtfI7IpZTNOEbCRqmz8avJ/4lwbPYVpWgAtxNsu+nQbfX4XFQ9po481YpU4SCEz23YILM9bQbgEprSRt0mFnr1ToCSojzN5kvTczTEjwuuFIHCpea/CXW8m4TFb8s/4htK5tvoyaEFSPZH8PofkK8RyWwR8XdQFIkCUmiAp6+39KcQ5oUWtjNlMQwrKstIvwxk3nRsTG+KPXz2PJNKHV03/t/fjL6/kDVWOzfD0sOFtqdLFFx4TWT7Ue
 qOCjS+g/
 zyFwCO+m4L8aItfy6JaDpX4inOS4gZBvmROUpudYZheWICeajgKcPOGgXNx6LFy54zMBK+rCHpViv4jL2JHGqmX/ENsF5TcZopegw8+m+MIqXDzzWYRL7vmDIh2kfMZzk/sVyGkcJa1KeBaynBsWxKUBnM0acTWumkBExh4coiySad509ffnV1PmpUjIuzZo6AsOmw3zWwKQV3uYk9ZXSelUU5SWBT0KOhEJ89W/eO3jb2RPWijNRsQ6wkxJxo/tbrLNp+bbWa6tXOUPOcPxlfEzRJczqmogtVrphgjsz5FCsWy2JiLVnaWUXuYL2tU6TZXT/CugnmLD5WRc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 4:35=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Thu, Aug 07, 2025 at 01:44:15AM +0000, Pasha Tatashin wrote:
> > Move KHO to kernel/liveupdate/ in preparation of placing all Live Updat=
e
> > core kernel related files to the same place.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> >
> > ---
> > diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
> > new file mode 100644
> > index 000000000000..72cf7a8e6739
> > --- /dev/null
> > +++ b/kernel/liveupdate/Makefile
> > @@ -0,0 +1,7 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Makefile for the linux kernel.
>
> Nit: this line does not provide much, let's drop it

Done.

Thank you,
Pasha

