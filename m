Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A347ECAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 15:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098E18E0005; Mon, 22 Sep 2025 11:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070488E0001; Mon, 22 Sep 2025 11:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC8A58E0005; Mon, 22 Sep 2025 11:00:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D573F8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 11:00:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56971B5F5C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 15:00:58 +0000 (UTC)
X-FDA: 83917198596.07.62F8135
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 664A94000F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 15:00:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="etqa/90D";
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758553256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7f6Q5jc1vTYxMw5O1/g4HFLF7Ms2PoeIAA4LcbVkCRg=;
	b=UNcYtiYQPaBqfjVioNAJ+UYey3HTlcKEssUAyirq+EY5jK6tu7X2tJ+OGTHrs5D1DmeiIS
	GESZiuTnVD5dsHuYv3s8zsebO4HZ1jE4wVuECehqrV3SMiPqg1DcDr6gkF7ZaR7rYbC8Wj
	0q9l6CDyNDr1k9Y69+VmP28zDGYbHNE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="etqa/90D";
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758553256; a=rsa-sha256;
	cv=none;
	b=6TUqoEw4Whr5ZvpNBcjLGkx5ynErA/C7n3v+8ufTe92chK/vqba50FUg423kXQqBw7Eedy
	TvnUpUn/89u9wc38c0ppHpk9eIDh3zoMVmt5vBGbvGka3RzvOuezoFhwM4/rJl9oKn4f/0
	emfcegBhysgkasd78Grlqch0n5mct/c=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b38d4de6d9so28402631cf.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1758553255; x=1759158055; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7f6Q5jc1vTYxMw5O1/g4HFLF7Ms2PoeIAA4LcbVkCRg=;
        b=etqa/90DrX3ZKFu8s5UZ7bWOwurenvddcud6VRiZ8Xb2ZaOunqfffIL/BqJzBcAOx2
         m/yZEDBoUKbycor8SWv5yqHg3E1jRUeX+Q9eFOY6kC5vI6HlDLFN3rjjL6d0ZHGZ70m7
         2UjX6/F/dx+FNiib4kR2SBjSefmoSJ5+JClhVahIjfWd/+wsb7ZaTfc0+NqlGaldpgya
         PUZzfgvEX2W3SBy2ueGQFbBD8lVv6DnQ5RrjHfyBeSWh1iLEF9WZMDz3tFqhu+maeICS
         tGRnl8IUCyz8NiWPO0FtUlCGSL3bo0Wds3zlYW7RgXr7ygnzOCu9rztLUNaDsHwRPXFy
         4RLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758553255; x=1759158055;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7f6Q5jc1vTYxMw5O1/g4HFLF7Ms2PoeIAA4LcbVkCRg=;
        b=i70ZsRAweWFy9EcTQZ8dbsErWLpNtI7sQx2QZT6DpSNDyeAk4kksmmqW3V+2cqsU5/
         to3W7rVR462XB/lOHnEzgw5XQ/qkTpKKdPG/7fJa9Dw3e03ojYICsvxBtu+M+eiENqDt
         g7qTiAv2+w0tk48UmZrF9fHzSX5yTJ00JOlDdaSnTh7to5kSS/qBAtaKSIioGZ463Ek4
         HLv4R5NBAiDv6HJSwYr+PRGgUZwSIrnEIYvRLPfPCZV4W0tp5/8GuvbL1QaVU5tbI/cJ
         hm1twMjKGw0WBDiQwMu878IpF/0ji//tpDiIlNa9pR6BE0+qvYX8ITXQd2Ssa9daSd0x
         MtPw==
X-Forwarded-Encrypted: i=1; AJvYcCWy5LWlmB1jiKmMQkSJ252C1YF3gOoKnqhmbDywwATQHlXy3ZTUzy2clwbm3HbF3V+eaAF+TVflcw==@kvack.org
X-Gm-Message-State: AOJu0YwjbHyl6WxbA5hE4vIysBXRE6P7T1UMrFXpGwU1PCiyx0XDgfHv
	6KzaypE4w4keyiw0RM5bLFAhPV1K1udo007tvQdAJbtD9n845Iyf0FTdvUUlJJOyVZan8RYma0+
	zs2CHaV97JZ5k3Pc3CAHRIH6Bn8gaNWS2wOORXr6pfA==
X-Gm-Gg: ASbGncsuamrUQPmNNT6u8t6aez88GEQ7xsC5K0Es6xU+CGcWZv02kolNI7g++LjfY1R
	ahfCGpgC5+SFjGfhgTv787HOwj5dwnC/LE9Z4aHgNY2+X6NhTzhG9Y03aiqWzoO2JhDznbvFMsx
	C2eEwfJucMZFwXykuHEkFbn8A4BlUej5EVabSyQQL656fHhQEPd26R5pIsfXp1GhG6Vzada7/ud
	adyBxWp9sXYzJU=
X-Google-Smtp-Source: AGHT+IFODvetLMEI4TglsorFs5/g17pXRnsZ1YySfP9UyB8TJrkLIBj/0y5AS2xiVpb0YAgRS6Chp+Ecl7/RH4sOKKQ=
X-Received: by 2002:a05:622a:19a7:b0:4b5:781c:8831 with SMTP id
 d75a77b69052e-4c07482541fmr145941741cf.71.1758553254248; Mon, 22 Sep 2025
 08:00:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-11-pasha.tatashin@soleen.com> <20250814133151.GD802098@nvidia.com>
In-Reply-To: <20250814133151.GD802098@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 22 Sep 2025 11:00:17 -0400
X-Gm-Features: AS18NWDWvCmwoZ0UUnsayOxFgu1ddJVOr-n1U4qHAgmRCSllAUpUXvWhJbPgaAE
Message-ID: <CA+CK2bALMGy8eYpYdsQSJXsCWrusKA0UJfBfv1fbfW-=tYds7g@mail.gmail.com>
Subject: Re: [PATCH v3 10/30] liveupdate: luo_core: luo_ioctl: Live Update Orchestrator
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 664A94000F
X-Stat-Signature: tpf9no195nmcbpzztp1tsw9n1bkuyou6
X-HE-Tag: 1758553256-42829
X-HE-Meta: U2FsdGVkX180r4f7GuHyKcwZmh6Q/XjrfNOsSU0Ggti/8EIKYLv5I4LBGfY4Byr9rrjVZjK9SCcD5f4RwPtZ6vvEAzymZvNgebvbEwPUJzXgJPOfE49gr57gFRT9s55ge8pxwKgjBAiLsmVG5vPHfB9DIxvhud4i6DtOVGkQwyBEsVF90EWJ40a9t0T98izgxQqjtxz5PqTgIIjXCqK6s2eVNjTkLcY8IQvnt+lQdSwejLxGYuJ9GPI5Re4e/RJgIRlrXSzKsaDAdpkkYf6IwjBdAIvZNd+ZdqSGPiNnuDhUyapgAo6dJtkWYkoJMbLwti36DAUqpShFiKu0nW+Qr0bp+Q5H9mR6L+sCF1K6nBcRqfbrlBwGMBUMCsbTpPhT3jUfw0F2s/vqlp6BHFQVHt/pHS486lLDecWeqjKqs3wg20lIj9jwsxjl54y0Q3t3hhnKDqqZzW6cMvGzGfc/ZL6srtGod911rKXXSUWnlSGh1Q88S0z2dtuUsjGVUFcXa3Jmtzh6TCuQJCbDCVBndy9EsbPr0uZkWsdVLqjNyTviM5RiIw68r4jtmpLU5GJDLVSjVX3FeOrpFUMUawBYA3w6L2SjQwGKcAywFvQn/JpuOpno6MonHKMMZcp1QrJmCKW71Jth5ZVJGWnf0UR6dHLlk4uOsypK6DIOsDp/oxc1uHEGIi/OfcV1sdSxJ8dw8kEgCtSUed2Icmk9xVTmXSt/uvW/SOIPjxHPblx4eCNW7YR//PH8Gqkt41h+MlC6aXj1ij7KKQmAtFkwSriuBIWfw7/E23jUaVM7V8BlfG56LDk/vR9pZkpJCaDiNLwna6XrUwM85Ddw617CKAOOyvv8QCECS2f7cO3MG8tI7E4eLOIHCj76A0v+Vtt3MUz8klxmjpXah4M8xtedMITR3qog9eUkBlTnMXl5K+2FmQa7r4yFZJnbMuD6NNikrty3nAywbkumxgB7ZAVQq3u
 eAr7jhJv
 l1VMyCK7cgUj9nlKeKTX3moZ//R9+IoTY/9Wp+OINX8b1maNjRIE3Si2R8ERv9s16Ay0umV3gHMssZkxrF60ebtxMnT3HAvE/fV/FEDwCTvfOEGUY45uCpyOAGB7w8ll94zXqJFEWdGg9MMmZxl1udKE2Xr2VdEMavScsFrr4dAjkStVAFJn4JTA7wVNeZEKonOj5UCgelwSqx0g6Bxb3J2WCIiSTKN7o71OoVGicnAZt7NyJpY1efzjePcb5E+vfGwvuOKk023bjN7e8vWcfXGSscoM64UKhimaXwwr/PRpFmYs39ioI/SfPtroZvG89UbsxkgZ/XPCHqrN0soIzOl6zvR7Mze/ry00nS5F6VwoqJLwaVoZBIWfS0mX71Sen+0aiUP7+tlmJaMxk5txvDd3MNbrEZmoDqzZh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 9:32=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Aug 07, 2025 at 01:44:16AM +0000, Pasha Tatashin wrote:
> > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > @@ -383,6 +383,8 @@ Code  Seq#    Include File                         =
                    Comments
> >  0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                               =
 Marvell CN10K DPI driver
> >  0xB8  all    uapi/linux/mshv.h                                        =
 Microsoft Hyper-V /dev/mshv driver
> >                                                                        =
 <mailto:linux-hyperv@vger.kernel.org>
> > +0xBA  all    uapi/linux/liveupdate.h                                  =
 Pasha Tatashin
> > +                                                                      =
 <mailto:pasha.tatashin@soleen.com>
>
> Let's not be greedy ;) Just take 00-0F for the moment

Done.

Pasha

>
> Jason

