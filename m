Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A72C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 20:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0F66B008C; Fri,  8 Aug 2025 16:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78CA6B009D; Fri,  8 Aug 2025 16:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E3E6B009E; Fri,  8 Aug 2025 16:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9ECE6B008C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:20:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 456BF11614E
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:20:38 +0000 (UTC)
X-FDA: 83754708156.28.D186762
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C2DAA000E
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:20:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iyZ86THk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754684436; a=rsa-sha256;
	cv=none;
	b=hOvgCWjPgrvAob5jBF+4Pe/wvBq+00cFkaO4JmrEiDJJvnmoiHf4LcNG/gQ6v6Blf0ZCJi
	1OhS5ZaBVMfp2/Rt8MjGuVOksGf47BWBgUp2+glhB2h6668VGJGQ1LfpOk4yghstAsw3lh
	hRhNir7Bg3MdcVrcpi3S97O3Dvb84Vw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iyZ86THk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754684436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQYa91kkeSfQG6Jm1FdT+mkrUk8mk+nsXZw2Gvf2uBM=;
	b=L9zmjSG9W7PbUN1bPEzF38hTeoJHrBjn7DmnZAvrdZNWJ0YaCZXx1zl49IZBEZdeJ3kB3z
	oIiA9VjhbMkoPQg3Y0At34eKZffb0LzcIOQZPph4yG/3o6OWWUg5kFV+u+vjDQ3B5nyr2r
	XQoZU0Kb8hLWCSv7jNzFqdv7F1j/Xjw=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b06d6cb45fso31336281cf.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 13:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754684435; x=1755289235; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pQYa91kkeSfQG6Jm1FdT+mkrUk8mk+nsXZw2Gvf2uBM=;
        b=iyZ86THkx1Vb+tZGkIXbScM4Buyb1UtJAjJEsFpmQqkybbVJUd+iZxjg9Bjqw6oDc5
         mF5axWSJBxQK39sjvg8mkdGXFALcclDwXWbFR4z6vpgXvTb6j3Bi2l2bSdLU5WWLHnfQ
         AXYRHc8S7sRpt8OvQxHicUG0kznlvg+fD9kKq+M7j0F+r1FVRotPFv/2UDLMEOAErxX0
         oK3WrRg7944bkgcvESmUhLX3dZzmyRKD31ttNWoB5ypPcOzoympm28eYVbHbhvTtf8Kr
         e3fawtDwaBn+cY5W6gi5CJB7HCdVwB1fGJSEWN3hKxqw169z/X8sXhIQOQEU1b65iVdm
         1Q5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754684435; x=1755289235;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pQYa91kkeSfQG6Jm1FdT+mkrUk8mk+nsXZw2Gvf2uBM=;
        b=whudAERCANxN3MDgCAQE14tINBR27x8xWZiVoSME3bmw+L13Bo4RWQCzmSzyj/AYTY
         6IFCugC1x0tJDCw1jy1OrHSu9pe48ZXlJ84Py8oE7plHMv1dTTDgtF/Tc9buB2KPNzhV
         +2qWxVfqo5z6Cv2+3kJEOmgzO/rx61/6g1AHwQpo1eKgtlBu+dVIb3OBJ+2TcD3x0WDV
         FAWolVS5AnGHhifEYVnY8YBPC1S67KJs9BtQKd+jWqBhssLiHuFSnnJGHjMGADOPtWuk
         mVwKwl5EBX75YYo/+M4vnyyU6gFymngehW8zyHmcUelCoqijqXrYCZo53BLZN90JolTG
         jpCA==
X-Forwarded-Encrypted: i=1; AJvYcCX3+rzeZ3zG5FZFko1jloxxrOJ3yd7zrKbKlSMvbKgj+v2GftPMR77NoJp5hzwFDSF+9Byn4ytcUA==@kvack.org
X-Gm-Message-State: AOJu0YyXQuFyaNmWHjqWU43AoSxcJ8ibHjGMBBu7tOvsR4UJtbeGCz0g
	aEb8MVd7ex8Z8aP4cI1wpIP2jfkQOTPBRo4YHOh6UEWpgYHTOPGC8zl8tw+2nsuYb1/nBkKPs9o
	Lt8FTLlKXi+DIJgTiRk3PR32Maa9SvkIBdQeB0INw3g==
X-Gm-Gg: ASbGnctzDNiWOwAoDebFXds1aV85v/MIWqn/Suoo02tvEooAI8bwYb/uf2OihlOWsr2
	tU7wHsNIZvJJ33Et3b8chASZdbUTfws5luxpTIu7Z7UujMKVPEx7keptJisY5f4FtiR42gNWCs3
	5EaNZun4pRLZqctofHfj5YW18lCMloLgMJInisnlmo1jv25D1xstGmYm1SjB9TeODdjUMraF8+w
	37e
X-Google-Smtp-Source: AGHT+IEo3U6rdysgoF2C0xCMhrgpG0Agqof6n2ba9uwRUTWht+9WRzi5tte7RjhfTHV9iSsZvxQedOnK/ZZyoy8est4=
X-Received: by 2002:a05:622a:1a0a:b0:4b0:6cef:19d2 with SMTP id
 d75a77b69052e-4b0aed031fcmr51001501cf.8.1754684435323; Fri, 08 Aug 2025
 13:20:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-2-pasha.tatashin@soleen.com> <mafs0o6sqavkx.fsf@kernel.org>
 <mafs0bjoqav4j.fsf@kernel.org> <CA+CK2bBoMNEfyFKgvKR0JvECpZrGKP1mEbC_fo8SqystEBAQUA@mail.gmail.com>
 <20250808120616.40842e9a9fdc056c9eb74123@linux-foundation.org> <CA+CK2bCVziiUZzdGaEabmPSB4Dq41QZe7gVxtgwy4pWmpo=D_w@mail.gmail.com>
In-Reply-To: <CA+CK2bCVziiUZzdGaEabmPSB4Dq41QZe7gVxtgwy4pWmpo=D_w@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 8 Aug 2025 20:19:58 +0000
X-Gm-Features: Ac12FXymO_RsH5GAn7D-2QfHaIXjJtVjSwQOC9gpco0na8ETzrHiY720l5D8Qt8
Message-ID: <CA+CK2bBjpZLiqK_63L-o+vxotz5fTUMpO4NgUaJ=sEV72qGyqg@mail.gmail.com>
Subject: Re: [PATCH v3 01/30] kho: init new_physxa->phys_bits to fix lockdep
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, tj@kernel.org, 
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
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: owrnfjmq79zy3dmnk5x3psdnfty6tj4h
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C2DAA000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1754684436-900059
X-HE-Meta: U2FsdGVkX19fTdxOa+sF87rFgSWQ4aCxKo2LOUj1KDN5PGz8F7dM/OQ9q0dUKo9dOrA492F1/8Dcrx3NdnrXgxAHPeTzxvsQsVQ8TO0Plx0cED0AHrHKwJ0WH20n1LXivU7PllMKb5Rrr6hxsWrO58aIH7m0TEsYPRwiid/GU/NxZJaF22e34yR7KsXijBG68niZbQw9I1nhDc/ayAShzm8kD2nJKrk9r/ck8TxsK+n8mqf+y4JC7+OnGeYkTU+CV4lFn1dc6NSg5R1oC09t9Zefs71FhIHFP+w0uLeRH80wWHOHYVaYcSk59demkP0qtjT0R1xnzsgXdUIYJP0UC0Kzk5/fcJPR28gZi++uKxrAkEMQFvq5KlIrszlhYrYYmGuS9UK0IVDri8xtTazx9ONuIwkzpmbasvOpqoCi0ATrZClFCvB+wQD/ubpgEzfxuV5K/NjnBebirZfxMSokYuwSflRE8EhwYR4W2ic/LBqbG9qiOu2CVMKZRpzh3wdik8QzWHHMABTbm7qi+BLAT0YsAzGpZ2d7/xO23j5bzdjrdV4JLosKDahGc+cB7nvRkpFGoqiGN6TDPbsgl0URXUryRn9wYboLUmnhAs8LM3ByMig9R1sguhcyY2OjZLytFRE62qRHgUtN2aq4WhFRe3KWJxnt0FSjO9piF2WQsc0VdyshQaRWc9J4SkB6vYe8TYYZ6kN5SzT2/9TymUPYDIKKlyw1ZT3qH5hWZE/s5j81MKHzA+e+hko/4kB3usmnUVjByDEa1nq7cKrF/uqmugmXcNnQrcSXcpLTcwOJvHB3FY0txW24ezpGvK+Ike9kHbw1LGgT/dRiHD50QA6V+CypY3uFi+XgG9jhD6RvIS6orp9lucpZNsCUX0rDbxBnPj2Q3R8v1FWhExZFqnfWXar8W0atNBuXrtHfLX7VBO/Ubv+iG9Z3DeCniN36OoHGjRvFxn2tDuOobyxcOZd
 /9gDbUZc
 HbdMD/oQe5HyzuZRyQxSYPnaTc63iTzQV+pPlAPsC0dcKTuUDHb9FEjUyfkbP+AkByGRr/x16xkVnP7OS6XU/VfWXZx/DwXR9CRoT2rWU4b0hqh31sjBoDOSG3RlYgBDxE5O4u+FRZIWaz2Lng6rR/NNjEsutCvXPpf/4132Mf911Z2aeGT4b4WuxJBYtPTsmGwPf9qhn9q+5X6ix+/Vw7KNzgyFNAY8O/Ww+howKDETafgGaGpDvHMSkhyxRIaqjXi3GRT1D9xph9lBbof24OekyV2ZkB2wZwby/At4d9cIbOP70Y5nBxQuWQBHyd30HFsk9HpwEUa1Z/FXUovtJ4yBX2rldmhHJfW7/nbX3QgztmG9LyaVCypPsCwgK2U6U5VxS/gI9Kis1i0c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 7:51=E2=80=AFPM Pasha Tatashin <pasha.tatashin@solee=
n.com> wrote:
>
> > > Thanks Pratyush, I will make this simplification change if Andrew doe=
s
> > > not take this patch in before the next revision.
> > >
> >
> > Yes please on the simplification - the original has an irritating
> > amount of kinda duplication of things from other places.  Perhaps a bit
> > of a redo of these functions would clean things up.  But later.
> >
> > Can we please have this as a standalone hotfix patch with a cc:stable?

Done:
https://lore.kernel.org/all/20250808201804.772010-1-pasha.tatashin@soleen.c=
om

