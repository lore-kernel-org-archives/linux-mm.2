Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB28CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17FCF8E0018; Tue,  9 Sep 2025 12:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130C58E0001; Tue,  9 Sep 2025 12:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F6F8E0018; Tue,  9 Sep 2025 12:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E240D8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:26:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 87E6D11AAB5
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:26:25 +0000 (UTC)
X-FDA: 83870239530.05.FD86AE0
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id AFE37C000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:26:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ny4EWm2j;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757435183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2KtKkiK1ZCeC0eEimsTpCD94S5mFdW9SnYokRVzfec=;
	b=qY4NrN7dBLdFPbynv5stxd8SpcjII9HWo5jObmXZ6iUoIFbZ9VaIHKyMjoMB97yUMpXhGC
	s4PeF1vuqXEbxuE/DFKQEb2pO0YFuWMZTmurf12xk09SPQLSvLf+D+fdPnuyCmfPi4eWnQ
	aei4DT2otlaCHYfQLIknAxTM4nSZsMY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ny4EWm2j;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757435183; a=rsa-sha256;
	cv=none;
	b=hlmfTmVZ/uwnyYzDk8f13156uODFqLcLO4Be2oa/hSFMzkCJItK2C1To/MZIYZ7k8NiPpq
	Sgs9wo7LSpxlNOLxL2dWQdgRmt5guEfoMz4BlmsQ3k2mX3gec0VjMn4qC0AMDEJk199aO4
	8VNLJy51gFGMc6T1bJMBCHSF6EPUqnY=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b61161c32eso25646351cf.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 09:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1757435183; x=1758039983; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h2KtKkiK1ZCeC0eEimsTpCD94S5mFdW9SnYokRVzfec=;
        b=Ny4EWm2jvBn8qgUL12h+GqEvnuL7k8pfLGViWY7lEgFaffAlcyYYTdJfVRoiCzxxrt
         ZtkqM2M9ujO3COV/oUax+R0jizYSz1cU7Ud7ej4c+kxE/VxDC7DY3pMdgB2rZ1UF6Vi0
         XLtpRo7KW3PSVAlbay36ShKw5BIp5e7o/1v2bpI2ndHNWzz6RMA5FUznIef7S1kl7GIj
         YzkxiZNbHgc3sfWjfZd7H9fSonZq1HXZT8m0FTCR7NkGMRflIPa84ed+kgA+dbS6xcaf
         SaiGCMJ9jpF7rphxrD3cHmzed9AV2SdFmhDiiFhjPaRtYJWjVvnEh60XTp6FrY4ZW5la
         Udqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757435183; x=1758039983;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h2KtKkiK1ZCeC0eEimsTpCD94S5mFdW9SnYokRVzfec=;
        b=N5ZKucB+ItJr/1PbNWUfKusx7IFwQihNKuZrTH/v7n07JSmqyCuSOV02Dk3gviHDWL
         nRX69WM+q2V68HnM5t2Y6bhg7d9Lf4je3IgDif1g2nwKth4gd9STsI/7FevoBftXd0HL
         yELEnZtySaAWXCOyxz4HY6HjmpUytIrjdEEDejeB5CfpI0tP4ohzzsuiLtxbyWctYen5
         ym+zebU1ChAUEevCTC14+dwwqgXx3EJ8vsQ03zHyLwEq/pNyp80z+/oI+38iU5ujJ2Dr
         sQmgP4SrI2hsnFePK1oLm2Z4IkyZm7F8KdNp/Z3b7q1DuZZfeQ01hvZ6mEo5gbrRPy8D
         txJw==
X-Forwarded-Encrypted: i=1; AJvYcCUMC1vfMeqpe4BTrK9vx6SOJwjBrzV/9AeHUcvvXGqhm69bOX9n7jUv9BAnBfXDev8sf+kkrcVf/w==@kvack.org
X-Gm-Message-State: AOJu0Yy8dQdlKiVKr7n+EjPnLaP9uOHcWBfxYTcgehm9DU2EfB544/0A
	Np7oYR8CetsZzt6GwWVL6HB9diznzXBRxJABMA/nG9Bd+P+0zw4w8gknaohbUJUB/jpAxUg1FzD
	VXXy1RkaJKDHuynFtgrGr90400Ew6XRVOSj+4WRsxJw==
X-Gm-Gg: ASbGnctgBv/X/zEiPzyyLrIoM95M0SrgZlQuQV0Y5MXkrA/INwbqmFW7O3gCFPJzwgA
	D7qwc5kOG40nxdeRG657ttakyMu3p9LAJnV+TCJI4g/SlBDqINk3DC5XljxQLEDPsNsxmx5CA39
	AK70xxuC2CdlyOmJeiptnda30RdbCMA5xTDfWt4yvUzZb77oATENHup6ZtpOSOamWAvPSREfOJ9
	Bz1G9sG/uuG0JM=
X-Google-Smtp-Source: AGHT+IFbO0LQXpb4o5AfjDjgaLCI09lbX8MmFHBChHx28mbb47+GctVRETBu/lxFgwTGAONEXXUbu26j2npwF4yJSjI=
X-Received: by 2002:a05:622a:2d3:b0:4b4:8f9f:746c with SMTP id
 d75a77b69052e-4b5f8398f6amr130559411cf.23.1757435182490; Tue, 09 Sep 2025
 09:26:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com> <20250826162019.GD2130239@nvidia.com>
 <mafs0bjo0yffo.fsf@kernel.org> <20250828124320.GB7333@nvidia.com>
 <mafs0h5xmw12a.fsf@kernel.org> <20250902134846.GN186519@nvidia.com>
 <mafs0v7lzvd7m.fsf@kernel.org> <20250903150157.GH470103@nvidia.com>
 <mafs0a53av0hs.fsf@kernel.org> <20250904144240.GO470103@nvidia.com>
 <mafs0cy7zllsn.fsf@yadavpratyush.com> <CA+CK2bAKL-gyER2abOV-f4M6HOx9=xDE+=jtcDL6YFbQf1-6og@mail.gmail.com>
 <mafs0h5xbk4ap.fsf@yadavpratyush.com>
In-Reply-To: <mafs0h5xbk4ap.fsf@yadavpratyush.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 9 Sep 2025 12:25:44 -0400
X-Gm-Features: Ac12FXx6epo0S67QSojcQ_-q7eHBI3YWc1_bazn-CLdcZQ8RS6cUC5rSpC48xWE
Message-ID: <CA+CK2bD0FGsqKS70bCgiD_1T2S092-UDy3saW9p5KNZCzzYjPA@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Pratyush Yadav <me@yadavpratyush.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
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
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: qas9ikzry9bo1p1saj1o119zmm9a9nmx
X-Rspam-User: 
X-Rspamd-Queue-Id: AFE37C000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1757435183-763199
X-HE-Meta: U2FsdGVkX1/VW/M5755tmriZLzFb5RaoHrgZWzo8Jd+/4iFHXui1ZJ5vZBjQFi0mX9u8hN+Xh7vPH27xdGD8pm/b4rYPFuU7W4k2J0pjbe1MjaEEOv1QpnPu7xwQfPP3QDLVSXQik/W4xRGA6Z5pSCUnYYpH6kXQWKmEioKDoKSLaRdTTgb46CkWhISmddlBVfcWc0YLI0U8lpN0UZaXaxLcepeqC7VfySPGfsV7SqSUPXIlIdx+U2ZY8DsgOKAQHu/ClICN5OgaHoNU44cnIkiFHlPBcWza/nS+bqifZDfuJZVagmXpQzEsaC78tg08nYNzzLN9vjIAu1O9KOfl9jLRvsQ8Qei5A6iD1IW4yXkrHd/ER9DROxMX80HfAt24Si2z6C4mVUUbvXYQjujEWOxho6M1IJqISURe/SuJUbXzdKbGqWq9XGusJ15wOjSmE0lL6juxdIAh/cHD5No/710CMyytdvoc5UYmRoDfwPtFsfwVb9GIPfrSBKrn1A3CbwZ/K7waXfDyyN5AxALeIhgLF1/EAjhykDYQaaBTO6Fv83U4yb50hCD0N9k1AUNwJcNtteZOHHVotxFdlkn5l2h4u1Iyj/Tn5Gt7AWiqhyX4nMlNbmC7/OMSYdE57B7iK5yssP2iM174cV+I72wPLSQJ/S6pjt7KW+LqsStc8ZGgY8aSbQSY4AH7W9NcRx9Mgn352OacId+gWKzSbzIu7Gl4MeJm5HwhKLNDKvfhK32dXFn+JJ+bS80S0zrbiFaYdBmMm5/wZhGdwquMfZhImQeSe3xvcmT1P/LxdtvXGq7l/RdF3z5rV2sveChzNIXF2JuKgimiQSpb199fOKP2/J4qYwVXD1JHQg5e+nrZ69IkBhLWgN/OPBV5Ne047QopDH24tpgkhaGsT1Dya6f3R1wjq5DmIVBgHlT4/iVBe395WjntEgUZSTuOxQfUkL5IwIGY12/gW8Yn5bQfGaJ
 fnHU163E
 MSDvLdQAkoVlrN+UaQFTuBxK+l7Bc65mF1JNxMgkzZP4rwtaUJ5McK/JkXW2+UzUXw9X+BSm/4ZlG/91O9TevLoDp5/lLO059niUbpk45yrG44U3EmTNudUvCSdexfxuznUZ2MSD2zDZ76mtKpe2bLZW/dbTdbl+WXTUKh8kuzL0+s5FZVigCT/MTKehBD6+GOad5Z8YyhHh5x+oQmddKqdaS959K4IU+4RDYqm6OwJ/m2efYdF9L11p824tLFYdotjcxfEMv1x3J9kR/Hd5cVXpRDB69ItHVfD67bAQ7H8ZU9Qc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I think it would help with making a wider range of roll back and forward
> options available. For example, if your current kernel can speak version
> A and B, and you are rolling back to a kernel that only speaks A, this
> information can be used to choose the right serialization formats.

At least for upstream, we discussed not to support rolling back (this
can be revised in the future), but for now rollback is something that
would need to be taken care of downstream.

Pasha

