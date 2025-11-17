Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FBD1CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 14:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85EE48E0003; Mon, 17 Nov 2025 09:28:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836E48E0002; Mon, 17 Nov 2025 09:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74CC78E0003; Mon, 17 Nov 2025 09:28:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 639EE8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:28:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 11ABA1DE3D1
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:28:39 +0000 (UTC)
X-FDA: 84120329958.09.378247E
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 24590C000D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:28:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fcRN+SZA;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763389717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQVCE/CnnGowlKqCGL6JwWMjWGkEt4E9DF7myhq90M4=;
	b=bcGTwbZXoyvF+eNIAWI2wsqcm6hXUwwmvImMTBcufcCwI0DVTLB1QV/dMkzp3lTl6D0UIA
	jyMQHRyEi313mIiuzdjFoSeOsMSjqGjxlrbMY3Qm0xEyLWrNb9EsnFSbO/VRkniVG0rFjo
	dHtBTzISIggJyxrx/gX6b0mseY6Nwns=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fcRN+SZA;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763389717; a=rsa-sha256;
	cv=none;
	b=WwSp1NH+wEBDxo9T+Cgj27l6OD2vBHP9DpaV5BzNHmBtpNH660nKaMNQ3zUG8yxygX30Jf
	FZ0PbGDc8tYG/xaGv5f6TeiIdgB4YKa4ZFbOq+U9uWWnEhZ/NgXFjUP4nSs45LvMiDVLpK
	XXoN/HW9DXuNlrfRECjUEMBIsaZv+Y0=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64165cd689eso8406771a12.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763389715; x=1763994515; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WQVCE/CnnGowlKqCGL6JwWMjWGkEt4E9DF7myhq90M4=;
        b=fcRN+SZALU9WDY8BRl4ddo8OZY+iHanHgERcYIZ3iIIppxFao9lq1vhoqs4uqA51uE
         NwTdtz2rDctDWgCF8SmXT4lyoAeqbUV6CxSAsVLeDuTA89vKFRsdpzAE4Fd7yg8BGnfp
         Pz7Z0gr3gX2Z0ahIIUIkYEhudeBOj1eP9q7To/6FNrj+wilUecgVSbY0D0dbDP3cmSgM
         KG0YgfssxEw9r5/C/uf6r7Q2I+5tgSIULbskieQ8+/2/Je5QdML7FpAFrss2Kd22pPx4
         g7HdMjuTchcjS7awc4YFOV/SWlyL9LdU+UiPvnIzkUQpWRuwSTwT9RPP+cTKosmqYGiV
         JFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763389715; x=1763994515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WQVCE/CnnGowlKqCGL6JwWMjWGkEt4E9DF7myhq90M4=;
        b=F7Tx4UlghPZjAn7pAAjXjmPHngWGwVqa6pr5y8/CHwRRBVuhETan+YtyxSHK/p6WQ3
         H16YJvP0RFbzyJ/C0IJXtGlIWPMcQIHsTheWZq4ADoM0BlKA+hUFwikrP/MeGhZTNWa9
         4DDTmE350kIWgSDkGwuPrDQy4Qt2MZEK8SRCBPCRw8TiJxB760T9K/o4ts9wCF9vXXro
         a+P3dJYNMdHF4S2i9xhfap35nw2Pl1CvnVk6Vlsfwq+nt7xbgW+QsBrzQWgSp6yGo2Kr
         Gdiknha9ugUuCi+sZ1WnmK3HkGp1psA5pHdvkB2ArqMr++RPfpu1dC+aYkWBgbp9SOEt
         1mLg==
X-Forwarded-Encrypted: i=1; AJvYcCUKk83LOF4g6zSn1d6+scFymWWTfr3D9NM713xv5xesoC/eSXOPK1oZhItw27vjm0xdYuZFUUNN2g==@kvack.org
X-Gm-Message-State: AOJu0YxZSN+V0V5UWr7XIR+E4x4jmfU5te+FtFkNhQGL4yIxE0a8Ipb6
	vhJrO0ELkTcdm1wwR96hYOafssbrJDDNVqoYByb237wd5XEtrMWziBIzpp582Js5lozTneEaS78
	LLbpOyBZ7aMbLb7hX2xEmUFOmlhcWu6eCaGnUYZZDew==
X-Gm-Gg: ASbGncucs4vKHqucBu64isE624AoQtGbckhvFUPReRoSi3pPua+H3IaX+8/rduJUimg
	20LuUcA+eBIdUVMChC3mI0jSnqGCTaqzuWSauUSyRKkMRdWuyc38DW7bwo4pceUSspXwHtopn4e
	SzSYUr+67QLAHcbjyJXqfElOcliIro7PLuBICo3NL2A6uKLhH5e5L0oQh6YGU317Vdj4emRDQjg
	z6eUnoT4D7jw+LTYMJr097IWHoKpnWrmcDkiAoCUaYksYXS4/edy0KDfQ==
X-Google-Smtp-Source: AGHT+IHFe/sTuuiJ+53/94QiMySpnxf4UN/E970XTSsHg+BmNQprmENpJq+u5KG4abgGaMQyqcrDGuE+yfqH+ShvDHg=
X-Received: by 2002:a17:906:fe4d:b0:b72:7e7c:e848 with SMTP id
 a640c23a62f3a-b7348570745mr849235566b.17.1763389715484; Mon, 17 Nov 2025
 06:28:35 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-2-pasha.tatashin@soleen.com> <20251116185406.0fb85a3c52c16c91af1a0c80@linux-foundation.org>
In-Reply-To: <20251116185406.0fb85a3c52c16c91af1a0c80@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 09:27:58 -0500
X-Gm-Features: AWmQ_blpOVxmRUODWBmJWtPPz2QzcGqIJZJTFHJU9AtpYTtzUk5ADMkO-uE2GJ4
Message-ID: <CA+CK2bAKm_Mb0Tp3Q5X=B0ngYrrfiT_pQ5P+c0=YVCXymxkqXw@mail.gmail.com>
Subject: Re: [PATCH v6 01/20] liveupdate: luo_core: luo_ioctl: Live Update Orchestrator
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, tj@kernel.org, 
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev, 
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com, 
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org, 
	dan.j.williams@intel.com, david@redhat.com, joel.granados@kernel.org, 
	rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 24590C000D
X-Stat-Signature: 9r1mzhyhca1h5neq5jign8hbh1fe4zeo
X-Rspam-User: 
X-HE-Tag: 1763389716-961479
X-HE-Meta: U2FsdGVkX1+8Tzxrm44wSJlmN69E3BzW6gjeFIlsm+VzEPSgtSjiQmjiq8nCWQRHQwD/xpRudo8FE/lzqRcEvJhvlVgIosLzIbSZfEztsTKblTC44X7EBz5Qh6qWHLG59xtqw2jvL/6uYtBE0BT6id64bXz2JnCvozMZ0pR68kYcnXPR5RSY4s+asy5RjQO3bnncUexBOU8qQr2ofKtFIhFEuscj6Eh2/3b3LgGcZYXabq8wevwu2CE6xyhN6hCaNY9VlV0GookEc3D78m7A3VWJ+qzyq2m5g8ikmnpCimeYXbF4jmsAlxIyrcxCD7QbfrDcYRWuZHAaR3Cp0pXRrb0GoHClULDapHEVqRvl1pRkopBzFpbPhxVeXxu3BWQ0/HUcsCr4br/IHaFkeB4DOmNP4IHjYoYzhEfv8WsL8HFmm9rDEPdGH2zro0hvoyUXY6aJA4ETcS06jXmu5+pruqFf0EAqZQSj76pBXHek7Pfrq+33igcLpEe0QlOdwqiQmBEirnW4yWpWDUB+ayhQc0CcZRJF1gIpUvEu+Oci+7b12pY8o/cciDPV6AnfBZWksXKSPpmJbE9EBNMECUrvVzlUi9XpJuscKHYrpmVtNT7aNU5666yNuMMiBHrhvhkpv2raqG0PBGZV1mQHWy/e6yN3NEK6e4klD93lgbYqsePM+bmDG85bGRGaJZDUpYJrnxo9qIbDI1hpxdBUc+csOYp+fVqjJbY6KsazIm38oA4ddUeF6JT7eRSsdyyhZxgf+7/XJGk0Lugian9T8eyXmOGauusrKRuJ4prnYOvfb2GFVYmOS9NSfXQ9qs1tzlNRrulJhwsPHpRvwpdqvHx6QCTLQ8mxSGzSfSwTgwdCm4v0zIf/bu5An52uB+2eucWv37QhEw323LW+MXPGAvjQ+RhGvqUimxnXpTs/GSiTIr/U6hUEIS4HAB/1zXNju/YohjuxMygXNzpig7aAXAr
 zb3gvWTb
 v8dhXkthMh20waQaAATHpZqIdNfYOSul/G+EriBc9Y0ZOP879mR/OxUDN8XEQK/ycTSMSmzD6sLJouLPa9C/W6kTV3gySok2ZBaeFpe87lmCEBpEJAMPT16yD1CcGRK02qHbPO4+BX0308zNvVgHOZCPbAe6S0ITuQ7jkm/8QFYHPhYShGRTp4DoRRO4sjHLC/ac0IiKfJ2xRE8FrONb3QcAyDKTjCBAivYtvAZ4y0JJJrzyKUG5a3lwLbaqJF9XxahQMiaXaE3PHVVUGU4O79Xgsstl8SwAyXYzu3Z2jDldm0SqherRFZN07U9njguYjtQg2DqliTR07I7uQklCbrCq7+E+A/Ih6qD+LR3Xq8XO/zueCMgfS5rmJYgYXDwOfH9srmO9YJyvq9Am1B9Gp33GhnSw8eBLHsnrnGkvR28Zyc/EXELlQkV9cPEf0aRmV+4Ybyk/Uoym/O9x0O7iRDhTR4NiIoL53E6ESpwRoF2aHe8uZnFRYJ6c5CJKvUSuHGc8i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 9:54=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sat, 15 Nov 2025 18:33:47 -0500 Pasha Tatashin <pasha.tatashin@soleen.=
com> wrote:
>
> > Introduce LUO, a mechanism intended to facilitate kernel updates while
> > keeping designated devices operational across the transition (e.g., via
> > kexec).
>
> Thanks, I updated mm.git's mm-unstable branch to this version.  I
> expect at least one more version as a result of feedback for this v6.

Thank you Andrew! I plan to address all comments and send a v7 in
about a week. The comments/changes so far are minor, so I hope to land
this during the next merging window

>
> I wasn't able to reproduce Stephen's build error
> (https://lkml.kernel.org/r/20251117093614.1490d048@canb.auug.org.au)
> with this series.

That build error was fixed with the KHO fix-up patch back on Friday.

>

