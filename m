Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5296BD39000
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856636B0005; Wed, 14 Jan 2026 12:42:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804786B0088; Wed, 14 Jan 2026 12:42:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC726B0089; Wed, 14 Jan 2026 12:42:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3586B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:42:13 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BC87596C3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:42:12 +0000 (UTC)
X-FDA: 84331288104.10.F296E5D
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id 81F21140010
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:42:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=B+tw2sJq;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of smostafa@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768412530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LvZuiuu1YEsxAfp5fNtmPk7deYxJACc8HafvMN6PKo=;
	b=1tgrDtv5kjrG1M5gfP5zLmb4Y7mz4BH0umAMtccOl1ZojcmcII5Ijo7g5RjtgSrrfX7JBl
	KenYR2xOkhxTWmGKAchleOLhQtKHwCQO5V3CJEsFnNSWGijYFViQ5NJIsYcVpyFwPyPIIf
	FMrGpt81Su4owtZUboJX8nVZ0l+4x9I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768412530; a=rsa-sha256;
	cv=pass;
	b=aMloTctr3xaSwP92llL6oKDrc2Iz2kdYF1obHFNWOup5+UlklQmfSo7mxd0iHz5/4T/ds9
	zdzprYYNIPGF5q4VxzmnDhDhy74uCnjiTuTTFc27kJUJYXzrRdhv+Pnk22cLxDqjZTM5eG
	26nGSIHFyh7P5EHPXnx3/ElwMajrp2k=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=B+tw2sJq;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of smostafa@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6505d147ce4so223a12.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:42:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768412529; cv=none;
        d=google.com; s=arc-20240605;
        b=BJD6bxkTB5r0XaVRhtrM1YrVIOhMKJZz08WtZiRymly8s+a/I79GqGnjGYTw8rVTqn
         lcpNzv5HYxvX5b043re2i72DeiyjQohVZ1cs2sPiGWnDbIAY8i7+vtGXwbWW/oDaxXJb
         sV+pQZtM1RzSUopPztR67iKWVFEw77CYzTo9zi7ufpjdJozLddLiiZqcqEFz24S952Lu
         FV27Z53pkFSxyGuqPzMGGXLSJPLr7Yne4japYFtpNGFE4b6y7Jbmwe2w84VQxNh13ZkN
         VSbITL5Rgt9mz1jqODc8D7KyKw7Iz8RLy2RbsIAfUvx5M+rEiIxCqEK6HBJJyTH05TcU
         Epug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/LvZuiuu1YEsxAfp5fNtmPk7deYxJACc8HafvMN6PKo=;
        fh=ZO+g5MdcQMKOKlkyYYg+pa7i+Ap2hcfTAY+4QFTeZT0=;
        b=b/ePUndXF2asO0T/LoBr9ixGo3IUIPGFuuT6oOuyqdg5CqsGCZVavJkp5qTAUf7kwW
         uini10YAffE0z5aNzjvYjUHEmf9voQHiXXRAwen26zm9BN7JZ3EEHXS6Q3T8d8SLlUX2
         xx39x7gP2CUzrdiHIOIqvVR3s/rAXQ9kjjZ9/Up8F/E4Mutz9avn4YZFyQvPDIIWvYdx
         BYS7F6e4etI5azpqSGjMlaWHD7zGiO3GdHIBnrNRS3OL5qrx+1VDmcpbpHZHPAucve6z
         oEfHKUq3MewQPeYIv2RvIGPciZKz+kaedP9M5jm8bzcLb69zGINY+kobyklwa8GE7vbC
         udig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768412529; x=1769017329; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/LvZuiuu1YEsxAfp5fNtmPk7deYxJACc8HafvMN6PKo=;
        b=B+tw2sJqm7c941N+DEIGIVLUksgHlpH6oZ7wzsP+f5rStelUF+UKjsodG9CHve9lnt
         DJdr9+OE5OD45B3nbs/McKa+rdtE8Ixg06iPtZttCDt4pKQid1+Nhs+nRJBUrx+pRaQX
         bwuqzWW2gsBYP6P9WACLThzYMxterM5+rp+BsHPrMSggF4cemhemeruQ7f/AGtohqdrp
         nkx8f3IPFPTRl5i2CJ88Hz23k/1Ob3bsACVeXzNrREF/PATHhdExu/zV7qIu+sztMrNl
         sCXTdbnPK/6vwlMFHzjs7uDQUiDzqFrjJDft5Q2MfAq3DyiGeHoTdgc1O92+Z4XWMMP/
         pV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768412529; x=1769017329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/LvZuiuu1YEsxAfp5fNtmPk7deYxJACc8HafvMN6PKo=;
        b=l2x0C9lzhZsyS+htaz96KLw0ennTeSKxPG4KD36FepFvJEAgqyN6tyOHa0J5BYds7S
         F9ydbt6MEaEwxl0FPCORSXwXz1FmpZ2s3tSb2nEkhIcipMxDNRmvh0R6xyqSLl3SPI6O
         OK4MaBkbPYU3bZ3yJq8UvlVATSiOb5tW9s0SjAly+5qZHQiyYTL7lrT3xj+1I7Puhzf8
         ySF8eb67EKbtzZE0EXjtXFwL/ntJk8IYNCY2sOhGj5MM3XYWP5vblEEgtJ5LHtAVbLbh
         Vy+Ypv9UU1chwt7qzMj6l9/+bN9cOlRpc8c5KP0HVfokDH5GNANwl9C4iXcfNnn7A7Da
         bPCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSSUt+yl0ThM4stY1GOXRXmemubwpeuLnj7mT8DGT3iNn8SqtpqPvJzzfiushkPbUXEaPgjpya6Q==@kvack.org
X-Gm-Message-State: AOJu0Yxagt8K1XW6cOM08+bk2scTAL4nG6qVWsPQYfjHrQCWzhhQcdrN
	1Ntol0IDxrr4HBP/qb+ta0vh7U1ZSF+3cWXiLDQl1mB9ZDJDZprzbS5JOXeYCaQGXsIHtEwgS81
	2meLb27LmPpRr+IR5JZLAYeP+IceVP1GF9i58pRgQ
X-Gm-Gg: AY/fxX6Eni0cERMLynUD3tRFfR9yZIduRotjEHcbcHRcdgug5PoipDyA2DeQnmuNBdj
	UVqLVgFtceVfOS2HMneDNYx85FGmwMmEy2Ryf+anuhKzQxWdXt8ndFcjqFQx3gx4B54PnQhGTLM
	yXo6KbYsN0KKMjC+GHvvVP+oZsQVBILLXsXusnwKMa2GRySSmFgSlA4B1A9kJZ5v12bZJvRLPth
	tOgO4UBXePgFPY8ShnE2r9Q4zBsV0dDCHIQ/PwZIeyeYbw78KF84s3g9msgZ97diYALrsf5pawk
	AnEzAu6+DS78wzVsc6Qy85Au
X-Received: by 2002:aa7:dd15:0:b0:63c:1167:3a96 with SMTP id
 4fb4d7f45d1cf-653edfab5b7mr33769a12.5.1768412528683; Wed, 14 Jan 2026
 09:42:08 -0800 (PST)
MIME-Version: 1.0
References: <20260109195111.GQ545276@ziepe.ca> <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
 <20260112133256.GB745888@ziepe.ca> <CAFgf54psxPrsvujStPNtrzxiKOsJF+aVrN7BcNxxmAF4wDmRXA@mail.gmail.com>
 <20260112135208.GD745888@ziepe.ca> <CAFgf54q+9Y5TtGJDB=8q_BW-0F=TM7zBbCcMzvtvr_N2WMnd-w@mail.gmail.com>
 <746f5adb-1d91-4ca2-8ae0-a2d171203b66@kernel.org> <CAFgf54pbkfdFr6biE8BiNKBnTBFWxXGmvxsZ0E+C1C44c9AW_g@mail.gmail.com>
 <482f2f36-e906-492a-a80c-987bf7359d83@kernel.org> <CAFgf54ovfnTHmMuZGk73SEEKsP3k-_exR1wqUE4W9tLYKv_iDw@mail.gmail.com>
 <20260113150828.GP745888@ziepe.ca> <f239e391-ac7c-4d26-ab82-4024a77ec3d3@kernel.org>
In-Reply-To: <f239e391-ac7c-4d26-ab82-4024a77ec3d3@kernel.org>
From: Mostafa Saleh <smostafa@google.com>
Date: Wed, 14 Jan 2026 17:41:55 +0000
X-Gm-Features: AZwV_QhTl513jAwSvXOQMjGLcpJF9UrikiS1WWDBCfp2vS9vKyi4pvniNQM3cAg
Message-ID: <CAFgf54pBAUm3ao-UJksiuGKtvv4wzRyFq_uKwLe0H1ettO4DLQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 81F21140010
X-Rspam-User: 
X-Stat-Signature: cmjkrk98x4mitemczr3cwqzj3g5k8695
X-HE-Tag: 1768412530-684833
X-HE-Meta: U2FsdGVkX18k4JOQvW7M0UQtc9DZho/eYsbQb6c1fJ98kGbCgA21N25qSDxgRv0b7Ko67jgFMUONi4G3QrkipRHBADfQkiyUJi4vDcY8MLS93/cofpzN+NEpTcjEtfM2l7ucbrM9WH4nKH9dUQmIeWQs1QyJhWfkfHNICaeiX7SsvIo5Pew/fgaHP6gOZGSxPJ4utBHFNZ9oNw7ZBWiYv465IN35qhyuEVeeWbqeF6ATt/ysalodxidTyoJposIpznPGOZiwyhe9IC5Zkt2Poy7g/WGtZ7pttxpOwqr+G4JkDS6csnnXpPwPs/Tfnb5NMWjF3dWtTmMDzadKim4E0wk2x/dKacgyoSgKffEGG2RI06pmwSdWcJeT2w9kxdeiXGiAW6OczuN3f13XAYa6U/ubyuYuGcUN/inwDhiDRRNso3TcY1q2noxdDewBusXk71CDE3v4kJyG33bQ6nbWyod3jgNv1aKK15YpM7u7rr7awoD6BHAH8eyZMQLe4Nux2Y2U4G0BSpDTw4zx8rxpnjaASHdCpA/kM9ZFJlySQuMi/0+9d5b7Nve1xazG2OZKd5h2EWtve4N8rvqWyO4XO5/4z3L/mdVvjidkcMx2mz7NE7UYaLcRAZbZifjx8sNOQOUXPU2ZDx2VTGi+xbHdiTOeAxCBjfh59/qic7kly0MPDbM7IBEDm5Cqs675JrPSkVQbk9bq9iZkm7pcjd5vvA2fp9ZwR6molIEpuehXgLXna2E4MtAVZPKtlw9bmbzt/Ib/oiqA9SLACS7ZeDajn8YbIpZ/21hgr/+xVifv2+12XlCKI3G+RcqgHONOMjKOHZAtmFsgm9Vlu8IOT3CXFJB84e12W1Ern8XfGxe5KfFItj+7DRiNisXLL6W6Y5bVkrAKA/JSJjjqGvjicxFFQMm+Rd1bLEMzaIN+0Vsf/9yb0Br42H5yi4kbHcYl0xXCBusUGu3wdm4Km+M9I9C
 SlcuNR1G
 KtGiSoXSKd+KfwTvDmfIZb6fV6D9UrNAYRUJ000FsY1wo4q7eKevgbNEnUeYB0Pumhv7NQq6SsS+HYN3I0I6Su1sedEuMovNNe6wRQVvTyatGp0TT1HUB9Vhm4Fk4qzTZuMaaiww3biedGLWisFBRVgpg1JE71fTpBb7E1+aHOAPJDl5DswGWKGGg/qFJ30nwK/rB4RETJJUjQT/dI389iWXIlIhbiX3evv+8CQarycchT0fu6lfG9uj1dsAxTEP7mzbT2lA1k23xbBHXuhKnJs/myxsdtDYhI5jwz003ziodH0xdOYVnQA4EAoktuBZBDAp7YK/zKkW56No8P9/2LjQtE+2k3Peh+4QY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 5:30=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 1/13/26 16:08, Jason Gunthorpe wrote:
> > On Tue, Jan 13, 2026 at 10:49:28AM +0000, Mostafa Saleh wrote:
> >> Would you have a problem if we added a new function in page_ext
> >> "page_ext_from_phys()" as Jason suggested?
> >
> > Given the hidden complexity that David just pointed out I think this
> > is essential to encapsulate it in a function.
> >
> > The function must be able to accept any phys_addr_t and safely returns
> > NULL if page_ext cannot be used for some reason.
>
> Right. I think pfn_to_online_page() is the appropriate check.
>
> @Mostafa, I saw you already sent a v7, is the pfn_to_online_page() stuff
> handled in there?
>

Yes, it's in the first patch in function page_ext_get_phys().  After
spending some time looking into it, that was my conclusion also.

Thanks,
Mostafa

> --
> Cheers
>
> David

