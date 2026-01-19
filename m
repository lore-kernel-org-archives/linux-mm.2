Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0BDDD29C2E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2319A6B01F0; Mon, 19 Jan 2026 09:25:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206346B01F3; Mon, 19 Jan 2026 09:25:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108B66B01F4; Mon, 19 Jan 2026 09:25:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFD006B01F0
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:25:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C02B41A720
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:25:28 +0000 (UTC)
X-FDA: 84348936336.27.5D19968
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id A6F6040016
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:25:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="OAaaEY7/";
	spf=pass (imf01.hostedemail.com: domain of smostafa@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768832726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWfpM57Ov0hDYx5aY7CnSscsAijAfja4kjPeN0VMSfk=;
	b=NGC8MOZMBA45TopuZFNY6GapfLzIRXi3RFgudTK33S+kgk1gzyyyKEwsiDXj5kAmuMCzi2
	GhnHUL9XEU0kBFw7CLc1+49xMR+N8RYkFAMumgE07SLmK0AvPug1kLRke5eislOypHuYTa
	LRUnzNjYWfISa13D5EPBilIy+xnevNo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="OAaaEY7/";
	spf=pass (imf01.hostedemail.com: domain of smostafa@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768832726; a=rsa-sha256;
	cv=pass;
	b=glypdyFuq1zFcsHkE6DaQpLPs1xZhLHYfVs7GwqEDhoJfAeMadcgHv56/xo6/no5t4izCc
	t9t8tMg8dwcRVn032RJ+rX2Kv6bEKAHTA/OYJVGMDZJzEh0y6beGv+gFqmNt+IPuLtbk1B
	7DeFCjjvJyW9U5yAfU1OHbjNpccHRUQ=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6505d147ce4so11121a12.0
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:25:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768832725; cv=none;
        d=google.com; s=arc-20240605;
        b=WnWreuImlZ+SxUoTwboundweitznmGfAZbCYn5B3nDjF9sbkN+oVAa7PtE2cwGMOXw
         E9M4+IUln6z25L7iL7WqBIl68M5vV1Q9JWjEdPzLmZ7AwH29ooPJWgsnk+OnBOLMBmeo
         yGNNGthOhgGYtxVxMcfqXB91coR1posCMsr+9o6psnlCvSROYbqkUUWaNBs3xMaf6bkZ
         BTZKWuNYFdB021vmgkRbn1SjgSrcQ/aXWxKk6ICzRp4HCEbYuH4FPxnqrJCy1nz4oR5u
         t2qEaMUVMjHjBY496XKXGIt8oxsCknfrXj8MDaR18IL1JNjRwZJ0Eqwc1O7Xjb/pyKJl
         KZKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yWfpM57Ov0hDYx5aY7CnSscsAijAfja4kjPeN0VMSfk=;
        fh=Qo8odiG4X1pcuKeoe9pQ3TS5U1ltera5Ii80MlwbtWM=;
        b=Y0QZ0C/lVcf4HA0IbCp8yvskIuRoLiOoa1Fa9Tb0wrje3PASxjWynKn/MrPmIX+9OY
         un0MkBB4zRewuwSCRy1bgXd/der4XXPmE3tZwA3z7nrQUIBDABgfHseAs9kXiBaixeMf
         I/GIiKBGSDZ03ao7TptbntYAigPwtdGS3Vz4PTNkhf/YL4UYe8qVVojbw5qxV+4ELS0q
         jPuUpE/axd3dhohmU4UmUtk+Oq6ImmOO50Y3zvXZ7bPFC1QPDebDBCgifrbrPCPPHxyB
         7Hml/GOyjAJarF1zUyMyIlmpMwtX2Vm/B2yG541HJWoItS/AaVKZLOuqCRJp7TIVQr1u
         K/Eg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768832725; x=1769437525; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yWfpM57Ov0hDYx5aY7CnSscsAijAfja4kjPeN0VMSfk=;
        b=OAaaEY7/Jtqa8vK0SYQojdWl9pRo9gC/NzZywxgMLWqXrhYrWxlnKiLHz90J5GF4UM
         QLd82wdbD8hO/mOVgvYav7fwudJq+nnWQFIXqStirYs5v8Swbkkm1PzxunAHcE28yrlp
         9vX5W4O67vqu6J/r3oqcSxYc1DMhaSo1jX9h+ou3CX4ZaBGAIx8mgo4EefRS+OL3p6AJ
         G5U3USBEFOXVkOT3RF2r7RoGIUjaPv2T5ELlPRyobax6/TJG6r7TRehMtZ8dH24bOKxy
         zkgFcUjBSdyb1wXaveSM/5VT0SO59ffgcJwC/BzAJJEySHoSPHzbBnmpoO9hSIpuS5mH
         RVnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768832725; x=1769437525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yWfpM57Ov0hDYx5aY7CnSscsAijAfja4kjPeN0VMSfk=;
        b=rPy66QqQ8A6fWCEXFrmzFxLN+es2HbYNIsGNZbZJk5m2evBxcb9N7jgL4ztAzsflRD
         kGI/a5xSY3iq351rs2QNeOPNAfwzLoqHKNXoEwSbB7G4LLNuouARhOWCLQQxVxoHPzjH
         collQy3iLexJOkSTnuX8WE7K6HtmMzmGJMvCpvcsX6sNzyk613qQGAduPw8ZRUfAGvxn
         FT3GNLAj1RQnvA89wBHywhCf0J//2ixY3j1bQxEOybrvoyU5PQkdYJYGVTRakaJMOME9
         i1nGkbU5L63wnseLhKDq3TWH60Xf5Z2/r8iYq48Y991jIu+CNiKb0yfYLS6h1WppsMbv
         NR1g==
X-Forwarded-Encrypted: i=1; AJvYcCWNVod1rk29UK9OmzXqP0+koGWc3M80PJ9UO5U4gigqR5wtnrD7PZrBLCC/Rs2Ejgjgd1pHLUOnwA==@kvack.org
X-Gm-Message-State: AOJu0YySg+QTifV5SlzB3EdhvxPLbaKhHZhzd8+fp+p8IC9UcoP/wYcW
	aitCNRgi64X/Ebvv1s4Kcc2+AaBfmwURM5UBBPutjqqN2FvA6aLHU1FXFx7O+GKhQy660C72gap
	vxOPSJp4lzIr509wsAi0Nga4laHjQ5BwFcfFRV9Hj
X-Gm-Gg: AZuq6aIw4ez0LF7vk7dTbIhvCLezfCrbnUuzaXrBDil5T60r7Qfd8ahms3uHAHgBQZe
	IubIGh9HLdrdqAmr9EHYG4udtQo6PbXB3Ok19RUCjkUwxJAzM5Y1EpQbz3N+pzy7DjsUTPG4U53
	yzb4h9Gl+ipwvgDo4jkMAthvdUsBKJXHekZzyjYN6EHIYLGzqNd1DMg8B9I3pPZ0iL7Za5hVlml
	XnKXhFNYa7HNDt52oaDGBZ5JYzdHpmaY9LWCxolhY+z97ajxGN+4zI6aLozrMQJYTtVzSQ=
X-Received: by 2002:aa7:d914:0:b0:645:21c1:97e1 with SMTP id
 4fb4d7f45d1cf-6560b37891fmr63399a12.18.1768832724914; Mon, 19 Jan 2026
 06:25:24 -0800 (PST)
MIME-Version: 1.0
References: <20260114164322.787125-1-smostafa@google.com> <f3ab0156-3d7c-470d-9c1e-922195ea27af@linux.intel.com>
 <CAFgf54rVPaUgbouXWQkczCyFQvXkrei_x6FYY6n1X5NkSSwYfA@mail.gmail.com> <aWos4aIxKpqWuHoK@willie-the-truck>
In-Reply-To: <aWos4aIxKpqWuHoK@willie-the-truck>
From: Mostafa Saleh <smostafa@google.com>
Date: Mon, 19 Jan 2026 14:25:11 +0000
X-Gm-Features: AZwV_QgGzbNYGrxymBlNJ_B6_tKEdbujc-QXDCatHQBzV6r02BmVWWZUnnYdT0I
Message-ID: <CAFgf54r+RW0ot2Pmv6z6yvb90ADheWeRkxDsa503vOw7nXpZQQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/5] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
To: Will Deacon <will@kernel.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, 
	joro@8bytes.org, robin.murphy@arm.com, akpm@linux-foundation.org, 
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A6F6040016
X-Stat-Signature: pd3o55jsusqqu4xghbns6gth3pbz6z78
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768832726-11766
X-HE-Meta: U2FsdGVkX1+jEBjaa5NYoNo3OlPx3s/niVIGC4xmB0hNFJOoTaLqDTBDZndVWMSsWEPpHorUCEaHbQeC29hILqjhu4BKl+MaUu3/XMIuW8HecaeFawzPDCHx1+pUsCFosXCzpB56WlZmRQnxvmX9oBzGJO/iAZELup27/Y2882mxxgkPuS2GrwUD/SPa70Bf5L7NjZJR5cYjLCC1nk5iHrGmnX5rSBgQgE7xNtIhzjrJguJKF+GKF+JpMlPxOuTJIPspff0KPztfAUi/BQ7dSPc3G4ShzABB8f/ezh+ciytJHJNEJajYMD4KzFk9iU0/c4YD9EcutT8PSp6Rn7BsMOe+kpC3IowAGRZ0RCIad6CjSE/ytaFwwXIh+XOaXM8LO/FqH9YZvx4NOz2bO2wTjujnpPfLpYC7Ck1qiXkeP/YCVM3Igb0wkkeuoZ56p78wBmO0k2hT7egqVXCxjILCp4kKgEXN1pqQ6p1LL/xgt0p1txC2L8jHNP79ureHRi5v3AQJ2tlJcz8GOzbUll7wD7O5OF8+VyCuJaD5J6u3TGwPGsUsnaCPRfLgU9ymFJeR3X7QjUixoN502WkhJ44ET/ICSTDtV+miH6pxFiIczJ58ufDFAPSNMChHaAiQUAYEQV7Z7oMpqVOpnHth59rSOdd3FEa5ZgiKEdEWGlE+mH4X6xHGFytcVQKbD1T1uV19NAdTl8pmRZOo7jFIH6CjmYneYnBQ//zroaruT3Af6qHacFL0adl+R2SX/sDxB7SnYuG9Zz8rJ5JogQ338qnDguYGidWVbq5u+xJglRSJOX1jpSpw6a61kK5jG2Y7dXtiTh+Tbne67DJZKM8zcSKAxMdTxGEJNxKEzZ/Bq6T0V7AqPnucWsuidkVpMddyYALfIg0wIFXE1B8ShJbfkw2wrjIol/hg2aETkNTfcg7PwWeGX/wS+iczWG8Wd06Q9LII+xNGt/EyEQgIcgC5dMe
 XhuT3idA
 AqkwCdA4r+oTyPHcUWnf7Z0wTk5tXRI6b5U3QqshEKQIbnnhW+6pKDshgEI2pJSL0TiJtDQDCiXAS19g0jMIucgnl2MLzrEWCXIktjJaOvoCFy14u0H5xZMFTnQ2+PXN+5Qy1hqTxBZQ6cjQGOHtB3pMc0NJVPlX5lNR8Ps2XXKu39R3Pc1omzeAFQnLSjZqnQQRXw7OhWg5lk5aFnVG0CtH91mEqXLZjhXm4zTqmdHoDhhwT2giA2S5TEYDox4sk9XhPgFYsRlYDYQIyUZaRDm3PywurxeXIO7FSI13+S05esbv0nelSqcuSe/ZTjosgvHsVxGJ1WierJ7+Z9FtUzCsKYsEUIIs1CaD9rOBW/JYVMWWo4wa8ohawmseOG34fP1x5kgLiwe2MEqD9UPbIE/KBWW/t+OyiYqRv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000008, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 12:19=E2=80=AFPM Will Deacon <will@kernel.org> wrot=
e:
>
> On Fri, Jan 16, 2026 at 09:08:42AM +0000, Mostafa Saleh wrote:
> > Sorry I was travelling all day yesterday. I see Jorg hasn't done the
> > pull request yet, so I was hoping we can still change it.
> > But I can send the fix separately also.
>
> iommu/core is a stable (non-rebasing) branch, so patches on top, please.
>

I see, I posted the fix separately in:
https://lore.kernel.org/linux-iommu/20260119142246.3821052-1-smostafa@googl=
e.com/

Thanks,
Mostafa

> Will

