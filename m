Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A7A1CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 17:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F00F6B0088; Mon,  4 May 2026 13:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C77C6B008A; Mon,  4 May 2026 13:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DE186B008C; Mon,  4 May 2026 13:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4F26B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:24:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91CD61A023F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 17:24:18 +0000 (UTC)
X-FDA: 84730410996.20.4D40744
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8E4321A0014
	for <linux-mm@kvack.org>; Mon,  4 May 2026 17:24:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j28htmlz;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777915456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DRIGBANyTxbRVKczgT9uBMklmvWRVuW0duqUNmLE+k=;
	b=J2CCGtyyqRAgzYxZYbukm+h3E4V01GkoMHchev1WyH4wWo6Detz03rz7YZEcbqMKvBn17j
	ue0fbylNQ5E2uVBc1D1qTOLjHKl/dM2f+c/UtU0IQ+HIgNPTqvm97evx34vKYgMsMRlnfa
	e0NskgiTp2vsOH8zC098JzF6uPU795k=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j28htmlz;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777915456; a=rsa-sha256;
	cv=pass;
	b=L7PoCBHuLhaaPmqe7dFx0/rpPDmtXcf1ypyYT7T/+HdtC5R/Ru7y9RnkbBQVJpc5TDAXm0
	1V12v3a8ri7XYMSSiyDXf2SAKs2N+C7Bz70V1VOIm/jAjCob+l/m7HtSm+j4poLzFZk0S2
	79Yrh44w525NIl9YFAAqx8PhMMe1Huk=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12713e56abdso3028566c88.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 10:24:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777915455; cv=none;
        d=google.com; s=arc-20240605;
        b=gEMWBnY5ri7Xn9COxAl6M6Ao2s4b9qtYbeP0aam3ZK9AFiFuwsNHTQq6cNX517P8N7
         HtduBQgOj5Akl/VzTtRJSE+kLNurjLm5XXQ2dwm11hNdN9bR+pK+sNdbaEIyBQevlHij
         q5soMP28eRI4Z4MRSed2z3yizQzZ3qb5AC4CrZBlu2oky7sr3wTjf1jDmnoMmOO8E6C9
         j8SNpdzgfqo4i/7jrJmqXK4XfuIbUDTHXWZdcLX2DRiLLzmJAlMf0JYox85WZm9l9gU4
         0eTVrJ25+o4+3PgPc73d2lni25G1XF2pA1N39XMiq8eYgguNGbN6DI2WPDxNvSO4fbIs
         Tt/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8DRIGBANyTxbRVKczgT9uBMklmvWRVuW0duqUNmLE+k=;
        fh=SmzqJJw4z1iNrcjd7PJ9BvF9K+3Z//24/gb+oR6XJR4=;
        b=W14utQNIOTM5uuVwdR50/C27mC6D69MNOvSJ7+0Q5r6ZN++laSPFyZsH5pPUgSqq6j
         m66Oo0hgK61Yx2a5EVKmhc02Eh9Q5L/abNb3Q2bdZcFhilorJ+Y6QyIdx2WvzJO9GAQW
         37rMToD6A3jp5Ob1uYMzXya4aNvBq2NFmrEZ+lAwtDzGLFM/1E0WFkloWiolATEqUrke
         kPhFI3o3yjfMt9gG8ubjFsTeYpuDvcFfjyKwZzL9ViOxN50U0IqEQYQtaPUVSb1bwSwp
         0ycXl/6ybHOAJhq4p3pirgmw0QVbKXPt9B8t/J2aFAs1nFvjHJR1qgkBcrzgj87knF4V
         r3Gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777915455; x=1778520255; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8DRIGBANyTxbRVKczgT9uBMklmvWRVuW0duqUNmLE+k=;
        b=j28htmlzCkN2CP1r7Dwo77tqjStS5tvsOTdRLV9f7UboO101iBvLORZQZI4Qg1Nh8l
         KCh1TGegukbUfQTMe0OyR7Ez/8IdSW/DQKF9qhTcN9Laox9klKxljPZM4LQk+Bf1NlIL
         W6pTGk8DHiknMe/cgHxAjI7CKlgQF8lq0FSvxHB7n5EmRDcZpK0bL6gw3Hul8Tr7+V+X
         J5u+WxbzL4mv+WZ5fOJGJUIsp0NclpCNwUJKFB7Kk+bRkqnUxRBAQpYJwDrF3sycoxZV
         zZqOq/orjqedn5iorfjdQtkIkmcfC4cTWkayl4L79tg5BKSnZXny0m5u8gKd07kq2bU1
         zzaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777915455; x=1778520255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8DRIGBANyTxbRVKczgT9uBMklmvWRVuW0duqUNmLE+k=;
        b=TBnC6su95bUg3NNH3Hb1FH030Z42We3iUQk8dNoH6/OSezb0gsEr4dCOxZFPMnZMr0
         185RFi20BMMq5akDyPfSWan1jv1Sn9EcKRfZvjty1fqFhsRDsaO3PYfoBE+OsXHmBmtT
         dwed4+U90QYN97wlwC96n6xFcmvJJlfWvOOIxZzYYwfCYZik6w0YiltmmslyhLL7U2I6
         W5o3TVYR8Q1OFFeyMzqnqZkKn46rlYMhayIIb0kkeo4qpPsnHHm4QKrF9dGTeMpx7soG
         IluxVCVr1oiT4NzsU03uIARHGdUbIPToJu99u4AOK4yc2EnfR93I4nLfxAl/6+ONcO/x
         RvgQ==
X-Forwarded-Encrypted: i=1; AFNElJ/pXkc3djM758g+Xdki3aSGA0mKpQdbaABh2wwMuUhRfR0mxybB6Fdy+Qi407j8YOoFjxDvNcnK8A==@kvack.org
X-Gm-Message-State: AOJu0YwPY+CnYHDi1WoxwYtJbH/TCgNExzvzOvuRT2QW8+QNOGHMTiuA
	aDx4wbU6h8QqpssnfNjhiuXV/t5wd+SbKtX02v3k5j9jFLS3lW85SEhKws8Ba5nnPyRD9JBhxyp
	sLWYVcopXAnuUQY8TX2Xa9nuU9cxBQdE6tI/XhVoR
X-Gm-Gg: AeBDieuucJK+4lneV6ucG9bpDDHMXclYR0mDTWjJnkQ//EoU02w96noq6xaZmKNnRVM
	FZjFmRiyf512rpOa0XqRvbMNGO9kKPuyGzlwI62X2lQF0UqVZMa3bir7KbTRZfCU4pr9eCXoAEc
	l63BvOASeTDwHTe967b6sNRwGO2Sy7JobZz5mw5bWJJPY1RKr2rJQIu2or187kLmyxUY5ksMj/f
	CnC63j6ge5N0ORi5qtsF4c83d3p8ikeuNgcAxRSmsokVnaCjWVHOhuOVbDoMSmiNjZ091twL1Re
	vcumRRDRqxj/jhjUNFm8aasv5EeR3A==
X-Received: by 2002:a05:7022:497:b0:12d:de3e:86af with SMTP id
 a92af1059eb24-130a9fec67emr177647c88.18.1777915454575; Mon, 04 May 2026
 10:24:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com> <20260423212316.3431746-8-dmatlack@google.com>
In-Reply-To: <20260423212316.3431746-8-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 4 May 2026 10:23:48 -0700
X-Gm-Features: AVHnY4KOWy2Xw7Jao5yCErgbS2iXWpg2-ZhNYfKSnvLQBaJlNVGZseag5k_UOKw
Message-ID: <CALzav=cmZzNetCqWjQaG=VO+Fs=TTL3izU01vDUFd-=mRnDAuw@mail.gmail.com>
Subject: Re: [PATCH v4 07/11] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
To: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b1qs3344cs4fbkwq5s3qeuaxbszqbp5r
X-Rspamd-Queue-Id: 8E4321A0014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777915456-852719
X-HE-Meta: U2FsdGVkX1+UOB9FcgDsyIupn/Yw54x8Cwm8lbcbcS/Fkizh8D8BiTVwuRYq5YpxkYWKltYKjAbVoyAsHS0PZweOtafzcmu1vGAnBnVyfCQZYals4wUaS7WQ9LpJAS3fCMhMxthWoEOp2pmUbOGIdldFs5f9lt9kiDnzuuPTSc3AB2xzj0WEFRbtrCf51n0OGxIW8AKAl5LHGc6zEywskx9AwzpcUvuxK99uTq6XxkO0lo9cN+lrKY7eOpVeEszk9Oio4TD9n415K0rh/66wC630unZ5QnT/HbOKpDRZEGSoRzXG9CoRMJqhij9mY2iaqSJDnKPObvEhCIoKn05fr487NFX9TAc2PHUp/v7G4LYA1F7bgU6OBpkHAavgvxpIGZbA9AH8+Cm/3rWLEQ9UJD49eA0UN3MuXjlTA6iJEPH1tDqpfRVU1jvlX09Pn+kypavijQowjuA6B3cNPuQD/qZxt20UYbMh4xJpi5mOiHg2UVQiuK0WPcOL+kRjm14uxCXc+jGRfYNCwNo3BYyVIwzYIGHtAO/xl31fod1BWu6Op6U9VylVYlk4V+QWisYweKCXyRTPkiIo/HG+PBjzgL3nuoG/7BD1DqXoHCQzGWuCygWT9BSSA1eizsEwVUO6PiYipJwh0imdBsMAurYuqqG1FVQy+sVwP9eXfwBSoX1QgmvMFmRYBA1S85hEVhnFKpP6o1TRHeQk9NFYSKeGKWGq1FOXlGEGWh7gDm3HrB+fZfypvpZaoOFEwagOadwf31KZUUtHzaZXlmFycHXATV0eQH1OFgOvawsXUlADfsFgmcYPYaqDk/IEWaq845bK5ZpSPSocVVnqsJUuexrP5xNeUwWTqaXuHDQJpsaoHkhhdDttmqBOMv5mmmbns9TEPsvjrNqdnVgGqzNa3NNG1lm3sqx1IVpy4gDEKrdoJpVT2iIyOSdpt1Zrp1eb6aJ3OGDIzXVSATpx+yOMgwx
 qdPvscli
 n2OUH3+8GvvWxsWUO4uOxiQsgytcRkl5pnexKrzgs+qeNSEhWE+WmD4JyxCs4nxnHdQa6YSvTwcffvCzPD5zUl6QzubeSEshUO24JFITpBCaHxjqATF/tqZYMxJ5znqUB25MmEXr8Ty0yW+wiHdhFsZ8/9UW1k36zRD2z7TKhEp3aNBYVE03cfFEPD5re1r85GY5iNQCNrQf8cE/hTeK8ZejASMn9OwN+xJEtod3tayprOxxFQjsKSxV4VByntzYU64xv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 2:23=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> Inherit Access Control Services (ACS) flags on all incoming preserved
> devices (endpoints and upstream bridges) during a Live Update.
>
> Inheriting ACS flags avoids changing routing rules while memory
> transactions are in flight from preserved devices. This is also strictly
> necessary to ensure that IOMMU group assignments do not change across
> a Live Update for preserved devices, as changing ACS configurations can
> split or merge IOMMU groups.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

> @@ -1017,6 +1017,15 @@ void pci_enable_acs(struct pci_dev *dev)
>         bool enable_acs =3D false;
>         int pos;
>
> +       /*
> +        * ACS flags must be inherited from the previous kernel during a =
Live
> +        * Update for preserved devices (which includes endpoints and any
> +        * upstream bridges) to avoid changing routing while memory trans=
actions
> +        * are in flight.
> +        */
> +       if (pci_liveupdate_incoming(dev))
> +               return;

Sashiko caught that pci_enable_acs() is also called from
pci_restore_state() so this patch needs a fix to ensure that ACS flags
do not change or get lost after a save+reset+restore.

