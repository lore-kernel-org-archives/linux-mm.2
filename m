Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB16CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ADEF8E0003; Wed,  3 Sep 2025 12:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95E7C8E0001; Wed,  3 Sep 2025 12:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D508E0003; Wed,  3 Sep 2025 12:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD018E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:00:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 211305B484
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:00:22 +0000 (UTC)
X-FDA: 83848401084.09.A944119
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4181180016
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:00:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OusIq+av;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756915220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VzTEB4bQWY8fWAQTgqOF+HS9WXqmiqpiTrodHwtJGNM=;
	b=4JmNQ5f9ZAAzYzlRLDOTCoht/jWCuPgzrlKLwAR/cMu8gwTXYhA7lj9JU2cTpCI4tbWldj
	AdiF67tRov2RnNxCJOAh6ZCVWzp0scfBhw7Og0zMZCvhKbnxSqRVnZI/VcBv0H19HCHoc9
	eJ+Aa4fgNFgaEvgNkgUrdnhrYySZEM8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OusIq+av;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756915220; a=rsa-sha256;
	cv=none;
	b=S84If2kdSM53PdQK1Hzhc2M5IrAL25EjNJWrWtmMP8ilFkMlBHSdCQe18q1U/TjMW0ngNd
	b62ihHGTSQaaRkWxxCkcTuFfu1NM1L2OsL72EvFfPf0E3BHvlKn1fPN7Zx4JvAle96g7Tw
	1nTQHY/bdSOahs92Epav1X3nPITVdzU=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b58b1b17d7so73611cf.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 09:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1756915219; x=1757520019; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VzTEB4bQWY8fWAQTgqOF+HS9WXqmiqpiTrodHwtJGNM=;
        b=OusIq+avimBVt8aL/3EHmfCpxbRiLsbC/Sskd+k84m/D/LfEZ76PnbdmERwA1Tvj8f
         L2Vq84UT95GZjZNI4XafmwwCVmHn9uMHPFDJZ7vF5SnzQ9fHdHRTjcM7KxcZl8O5WzjD
         xw2KnAjvd5A19N4m7ZzrQTe+YpOPWh2CMj/+BxsJmKaiGWmIbWfqkLdO0wYmQul24wMc
         ngsfKsNVYhk47+Q7W3TLuTH0YUqUDCrCLGByNF5YXf8SUgAUKGxv5/y4CJskyqnGeBfN
         IRb93KPe1ADJDXLrzJdTua/aol59tJs6DlW7FXtANoCrp7Qfm3yAJ9eG8d+PLRqxIFmx
         u4ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756915219; x=1757520019;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VzTEB4bQWY8fWAQTgqOF+HS9WXqmiqpiTrodHwtJGNM=;
        b=Ym51zLvfwmbxjEet33k5aF/hF1u3nj7NVkkkvSOoGWFTRksZM+JiCav6auYevmVeD/
         G7jO/FEzO9yd+b+Z1drGSIufA6EqHLlg+2GjGTyact4N7iMDG/Or0IgYQhEYxlzfgJfd
         AUhOKN+R+4ak+72oY99unnI9IVrpNn2nxuUOyeM+QOSLd/cZ0jxDfLNibVQXtgYcUoYo
         wtQ1Avyl7mzYyHUvjbOm21AOkyk/ZYM6q3dZqLjenb5mFhEbhuTbMZlB8Mc+Xyna3tE8
         /06bvkJmAhmN1ElV4UZnRjJQ6LKzkHujnQwJsrjiK33QnmUISt7VmkyaEhGrraM83hCH
         OndA==
X-Forwarded-Encrypted: i=1; AJvYcCU0ZPsOC+BIhs1gnTl9yxt+d3tVjAmhtACvPSBMj66Tgtk5k8LVrPuwcHuO7V+VlerbS+it786W9A==@kvack.org
X-Gm-Message-State: AOJu0Yw1uqENN/4hDC8S695E+Au6D6t/KahdWKDkbrupljQNvI0fJHTN
	yTOvVJnzi9mzvakLxAyj/7oX8bs+KLcKXYaf7UzWVko44yak5S8LJAGLF2LyvrAtFB4es4pJSnV
	bZs8ShBTJfctt63g3CFpBj1Th8ZdIw+wyC8X9s80sUg==
X-Gm-Gg: ASbGncujxQGVQ3MfWvbom2IVxY5FpvH2YCwWXbt754PSrA0uBJklXtArdkYbN11VNDB
	Zi3DsSEu494vnt1TvUrltFwr31RyRFe3kM/m1va1yCRrNftPyNWi+YgOa9TC06zYG/31VlD/Kxo
	rUSCvvIx5Gd0c3MIE9aKi2O1lNxJLUXcTRvG04t8vBDiw/EC2grCQn6XswHln//Jq/HfSVtbZpb
	l0ju6r6b1aPEAk=
X-Google-Smtp-Source: AGHT+IEwx1LONda4kuiaJ848y4hM0OUKd0p1JeEharACFnO+JnUd0aS8iQNuarNBHObxQXAJhaTUSynWXDSmvzGvt7Q=
X-Received: by 2002:a05:622a:1ba4:b0:4b3:1197:b93a with SMTP id
 d75a77b69052e-4b31dc8f67fmr234759261cf.34.1756915218859; Wed, 03 Sep 2025
 09:00:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com> <20250826162019.GD2130239@nvidia.com>
 <aLXIcUwt0HVzRpYW@kernel.org> <CA+CK2bC96fxHBb78DvNhyfdjsDfPCLY5J5cN8W0hUDt9KAPBJQ@mail.gmail.com>
 <mafs03496w0kk.fsf@kernel.org> <CA+CK2bAb6s=gUTCNjMrOqptZ3a_nj3teuVSZs86AvVymvaURQA@mail.gmail.com>
 <20250902113857.GB186519@nvidia.com>
In-Reply-To: <20250902113857.GB186519@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 3 Sep 2025 15:59:40 +0000
X-Gm-Features: Ac12FXzyfAMIU2bzOrGlEX9a8opKhAuJo6gq5GdnRJV0XcXKQKHlYu1Dn3mOunw
Message-ID: <CA+CK2bB-CaEdvzxt9=c1SZwXBfy-nE202Q2mfHL_2K7spjf8rw@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Mike Rapoport <rppt@kernel.org>, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, dmatlack@google.com, 
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
X-Stat-Signature: 4eti1iq95h1e5gjmfmdf61tzg1dncoch
X-Rspam-User: 
X-Rspamd-Queue-Id: 4181180016
X-Rspamd-Server: rspam01
X-HE-Tag: 1756915220-877973
X-HE-Meta: U2FsdGVkX19lzm8R3+41pDiDazywMWjiOaBLSGp7gbkURYoYBmF7++Cufwrdjx72/ZkF/m8gRNVNjco2jEjrufGPG7nvm676xNef6Yywk2puoFHVFY6tmnW7DuHhAwEDf8SK/+EoxI+ZAW2TjPNIDn8yVusYplba6c2+Fkt4GkqGKTOPh1ABRPedFHgxUbrAHFAysXICiRsFVy6WecQWXNOy3EDZzScOr2+AgKynZuZudDuSOhI9OXitSkqGi86Ayzw6mKxVHgZfjNNtZlCK6jGrVA+brpjXR0ZaFa54lxme6ybBKnVAlUFk7xSVUGdsMnd9/1AsVJby+JjXljIxVusR+nVQNNQscZ1bGZ4ZDcRRYoyeGsm9yMmOm/Kxq7fPSwU9T/tYrJ9Pnv1PuxOKf+UKahMqlAXHe/qnG+GE8HmDIQ2osUhrRkRQI667A463ruVZ5bEx7kr47/mqXWcSTlDJdG2X32H2ctCAiCCI1BHYEs+5AYGA/jMTV5l+veg20p4tTnqwNVGkHddkEEK/GuTfSDQ0lrLZ06edA2vOnJd1s47AQ3c4pUhpmJFBCw/Nly/VEyfi0H59UOQcIsdqvEmL38w9+dJrct+7jY34iHJAGjjgpY/q7AZvFJFFchvSQ2Zk60y/ALV0wlMyC8TCXYnsD7H02lzCsSQXMDwnN92QNG9tq4U2LOrBbdlFRSI6xE+yNyqFw16bY8b/23Rf/L+ryw2a1r6hEcNh026Vyi9s0+1q8q++z9HTt1CRbqNTFrldHyh4jN+oESGLFiYTo4WsInXLIULlLvodT4+O3oPT2P95wumV27TTUUTRD8dyh5FOwxdSjPMOHPnA2+jjhb+THvEangW9d2O0pMuKn2ToaSV22/pyYDOmX4AHFsziTRi9ThpS6rHhVGx2YyzOCgXpcB9iXg9uZj2mQ1GyQDWt3P4YJba7NkXhw4ppq7p8vJreAOBctr2pyTlqybs
 2afs0A6j
 AfWapOTKNSnPlWS52d0IdwwpJRGkfgIL8mjRMPK3pX4J/wQMZKCdnfa/Kx1yJ7OS9KLrS/eKoVoYmUMz9VChtBz8daLh2eGgI1Kn5CybY5FuFp+VRprBwmkwiVdg6mtj68nMyAqgwW4b4ZYpXRUF0AQS6d2jelq6Ua13Qsk+HS9l8/M5X3qox+U3x2CFbxMTkZoTHwfKU9xVpGy/gv3aGyZU5I2lGTMr1Oqhx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > The patch looks okay to me, but it doesn't support holes in vmap
> > > > areas. While that is likely acceptable for vmalloc, it could be a
> > > > problem if we want to preserve memfd with holes and using vmap
> > > > preservation as a method, which would require a different approach.
> > > > Still, this would help with preserving memfd.
> > >
> > > I agree. I think we should do it the other way round. Build a sparse
> > > array first, and then use that to build vmap preservation. Our emails
> >
> > Yes, sparse array support would help both: vmalloc and memfd preservation.
>
> Why? vmalloc is always full popoulated, no sparseness..

vmalloc is always fully populated, but if we add support for
preserving an area with holes, it can also be used for preserving
vmalloc. By the way, I don't like calling it *vmalloc* preservation
because we aren't preserving the original virtual addresses; we are
preserving a list of pages that are reassembled into a virtually
contiguous area. Maybe kho map, or kho page map, not sure, but vmalloc
does not sound right to me.

> And again in real systems we expect memfd to be fully populated too.

I thought so too, but we already have a use case for slightly sparse
memfd, unfortunately, that becomes *very* inefficient when fully
populated.

