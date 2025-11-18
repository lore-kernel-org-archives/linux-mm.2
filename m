Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04DB4CEE350
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 19:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D63C6B009B; Tue, 18 Nov 2025 14:32:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE3A6B009E; Tue, 18 Nov 2025 14:32:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4076B00A1; Tue, 18 Nov 2025 14:32:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA7A6B009B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:32:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCAD81DFB08
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:32:01 +0000 (UTC)
X-FDA: 84124723242.14.36F00E9
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0151EC0014
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:31:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YqN2iCRv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763494320; a=rsa-sha256;
	cv=none;
	b=FJ0uUxOOxgXQBXLY+UuIXkWKU8cGc2cpPrVfNIkGcdbCEw7RQejDhZbPgW6i+tIaNt7Anm
	7ghlmQodzuhFG8v0qqbzOnPLFUgkxS3ppfWCbx8r7X+op/13OC0qZ3UABDkBg0ddGlr2c7
	ZG1wpIMu5r1Qx/PnF3DY+NiXu+0wdag=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YqN2iCRv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763494320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYaqzEIQYjC/AA8fKfHRWLmVY/sXnNn+7WATr1cqH64=;
	b=0oh/QUdIYK7cFHjTTKTJ3BnONmIMJ0DXvRYWpV9EHpmqxOQ/ojry3YFAJs+kOireY9W1RU
	hXeobM97cOjdYM9KSF5kGkks9eZ09JxoAWr1sqb+TvOiNygKbjCemk5qWGn2NcX5iFTggi
	5aF7NV1mbF1KB4zzYQr4h/YeW9F5gho=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b75c7cb722aso182468366b.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763494318; x=1764099118; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RYaqzEIQYjC/AA8fKfHRWLmVY/sXnNn+7WATr1cqH64=;
        b=YqN2iCRvtz3P47tnEv+cJXdyuVqfnKj00n7EY228XAJaZdAe1h21XQ0dKyeYtnf5TE
         cJrgReLpVAG71ULTQFVoJh3DnFUBDyUej1bR6HdKxqeWMWwXcRqak1+GvedNMm7lRJ7k
         x0xpasfrCaNA0Wu/mVGMAbtDirkshho+Nh1iocindAYf8F3rUYqvD7/1GjMmHaIfdXNY
         rzU1cTEzuvUFSmIBYoqbdKfsguRLvJHBH7MxyNBZnAsG3hjCZP4zlAasqWRSw6qNTr1q
         LazceSUSU63kLwJIsoqTnjeLQdBfYa1fifCbQceQgFpO+Hz2ZRpalMdBCc6PS84o54Rz
         noig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763494318; x=1764099118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RYaqzEIQYjC/AA8fKfHRWLmVY/sXnNn+7WATr1cqH64=;
        b=cPGDNAzjz90ws08ipi2MhqGl+07EuohhceUgzCJr9yeDjBrWwXaJtt2leZl3NRle8m
         fMyWOXntRDf6kisNxgfN6KE5n3LdWDi8Ob0rpsJAih1wOMda2uz0ObOQQbt2zJjwgHGY
         FAL34pjTM3OfeDTvqw+HZZ+V1WOYMP5unaataMQeyPVQlkLi6mifg9iUOz9Hjsaom1PR
         4e/788X/un3Q9keAZHLa6i1k2JF/jhZ4gK+ERiqsqcPjkIyB6duIVLTMnEfHm2f6H60f
         mx1wbOO7emLbUFEL4f36FdFQV5M9lt8NK+U5UI4xvS0IfnxjcFOojT34PURUhQbTGn+y
         rsCA==
X-Forwarded-Encrypted: i=1; AJvYcCWQFaXXdduUPCWEhaz03Ofbu58FohNYUWreqS74YYKKPSpfMjCt7nF8SRZuxWBN/UuG2jd/w8nVng==@kvack.org
X-Gm-Message-State: AOJu0Yx6tbU8d9r8DNHn8DE1Udenh/XTJhiVptDoGlR9X2CuLR+9DVoG
	WArZ+6qWtNp/9LLXpucb4qq4gIBWgn54NAGHbRwVrc2GdOZRpJt6luvxbUEVAYxMoqrjKME4J93
	tT7T9ObGpojehsZJxigq03IEF3IxjHKAQKbP3uctk6g==
X-Gm-Gg: ASbGncvWfv4J+n6V6kC/MpKN+CNtDukeuOqxtsoTOVCNPWY3IezIPg1fTYeVjRaoOld
	KeFedCAXmRts9evEh4RzQxwdvljZ3b8OHPcQIBavQbXXITIHTw15VmB73ZaWlordyYh+JsWIK4c
	SSz9A20MP17mdhfZo3YXM8nrO0p6E0cSldbsgDu1HQPgLEPmae1ekB85SqTZFaxlox/pv3JuKT0
	XIUZJwAe5zQIdkCtA8fSO6PUnjFtxB9sMEmeXP7NxRMke2LKbuCNKR4jPp7DZpPgc8PHGPo5O1Y
	yuk=
X-Google-Smtp-Source: AGHT+IEoY5GxNNnNMoAylXF6Jyy2pRfpo8iGqzyCOOpRdKPPNoDFYT4pwtFBZN3XqQWL9L3hx4nbDu6IprbOG+APsaM=
X-Received: by 2002:a17:907:7b83:b0:b73:54b6:f892 with SMTP id
 a640c23a62f3a-b73677edcbfmr1719343266b.4.1763494318109; Tue, 18 Nov 2025
 11:31:58 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-7-pasha.tatashin@soleen.com> <aRyvG308oNRVzuN7@google.com>
 <mafs05xb744pb.fsf@kernel.org> <CA+CK2bAqisSdZ7gSBd7=hGd1VbLHX5WXfBazR=rO8BOVCRx3pg@mail.gmail.com>
 <20251118190901.GS10864@nvidia.com>
In-Reply-To: <20251118190901.GS10864@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 14:31:20 -0500
X-Gm-Features: AWmQ_bmbBbBA2popU7vHmJW9PAVFFPXLJPyntHOLQd2MbOo1GozNXCODJ9I9W2Y
Message-ID: <CA+CK2bBXRopZBBJi3YgN_PCwe2b98O=0oyu+XjUkfVrffrDVTw@mail.gmail.com>
Subject: Re: [PATCH v6 06/20] liveupdate: luo_file: implement file systems callbacks
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, David Matlack <dmatlack@google.com>, jasonmiu@google.com, 
	graf@amazon.com, rppt@kernel.org, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com, 
	hughd@google.com, skhawaja@google.com, chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0151EC0014
X-Stat-Signature: szwdh4yunooknaz4dujwc4s5a8uuxr65
X-HE-Tag: 1763494319-457235
X-HE-Meta: U2FsdGVkX1+Ibg1AnodOpdtrJdL/EZmY3w1BYQgDa478B7knE6WGe6/BWp/OspgbejTdfqDSnTyhGm+HtKIm26gtOeniXS4vCGQYh+q6rzzxjeyprlgKKtX1BjQ32hgcXVAxpJ1+9WbhTvhDA/aLCcVgZchAXpwYsB+JhTGk2sHdKk+w+mRLCXooKJGbLegEUi39dsVWJwhajZrIqvA1MyAiTmTFbVa2RxB5reKZ8nkpAfG2OpzuoEMwwpQJMrIt7f6yQtHKVOHjOrLDA2q9CWbs6RIQEVt1AnwdcmXMmCJUHnR5wS23hdhzbZdgK8zj/CwSjq+cis8be/aA0YbQcSk/JT4AXi2SB/DhKi49mq48T4r1BeDt2DRScKJUHCTE1Ndepsw4oEz1CNlwwroQFU7Rs7kXzwo2r6uE4dSWVW240pNcA8fH8DX3hTaMG1ymxhw+cwVqsPWksqGVJJ0EEmCX8Ez8kIF2dWLEBhtDXfNpDhoi29RTQObwhglNEDW/Vr8QF6lg4zYdYMra9X6X5ZAh9dewlvNDugw8TOuOnTJ3gJ8kWEiVt74FFMTJ+lszt//hWJk+/orDmddB42CYkrjYBZJUrNVKMkB5afmKhgI9y6ad0Ix5l68YGSVA3ZxcZULWieeuKiSfIFr2lbOK5T80LDsQQODbf0X2j9LFVvTrM9/HJmeSE6Z8g0OBagvtlquaUWCSFycE7ICji9satkRWSZ0n73u+Vl7u/d03nE6Y2VhzH/vdunO/0BTNj5WekdK1CcwXB013aOQucHD3q7KbRuA17m9JGA4tJby9ziyvpxts/80V3Wrk8JfawI30d0W4hqv9dEjFzALUq8elhxLaGpovsL5xEb9Z/vST/QukY+wx03aOpSe4+7DKKAKCyx6nHeEF0OFkJYfTvwX7TrBBraZubB9ThAOokV0UJPtha/o79IWQbqDYTDnRNL9MP2KSvicUtLE/Y/X97R6
 2rmdZHpU
 QSGI7hrJywLOIw7WR6wzoh8vXjrfeErTasy/tTjYi8WAu4+LOYdOS6o8KzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 2:09=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Nov 18, 2025 at 12:58:20PM -0500, Pasha Tatashin wrote:
> > I actually had full unregister functionality in v4 and earlier, but I
> > dropped it from this series to minimize the footprint and get the core
> > infrastructure landed first.
>
> I don't think this will make sense, there are enough error paths we
> can't have registers without unregisters to unwind them.

I will add them back in LUOv7.

>
> Jason

