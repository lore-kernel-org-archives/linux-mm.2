Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A834CEE327
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 15:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B585E6B00A7; Tue, 18 Nov 2025 10:47:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE0F66B00A8; Tue, 18 Nov 2025 10:47:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981F96B00A9; Tue, 18 Nov 2025 10:47:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 820F56B00A7
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:47:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3751A4E03C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:47:17 +0000 (UTC)
X-FDA: 84124156914.12.2489FA8
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 501D416000B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:47:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gv2UgsL4;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763480835; a=rsa-sha256;
	cv=none;
	b=at8DLLJHB6Qa5bMtEylXctVwVhLcZo9O3anRHXsK1xsGvl+mZqxm6dk99JFz3e4Yy4lZj/
	wUBMR48ElmhkyRuo/3UVaYkh0T94zactehzYKmmYqr5tt/84VFlo2l3LZuqxGuOUvlh3on
	+QdNi/XGSqJKFyJ/rlULtBPY1uGSFq0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gv2UgsL4;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763480835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSit9q9L9b/5E+Zs8jJoiIuLjTbwdZ6FtiEGsvw8Sos=;
	b=KfBY6FvsriAbDjYaJryYuXvrpQyroxSy1eBkKUpFOpWZp9nCqawuPGk/m8pusvgCMc4ws+
	OBaerTufZ9GGszAAkqCrMeIUhTtvyqLdCYv8dxo343AMtlZ91ZZo6ki/wpDUnv4GW0voLS
	KQVVE0LMGbwU+LrSmkMlm9fKNHFZGu4=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6418738efa0so9886139a12.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763480834; x=1764085634; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSit9q9L9b/5E+Zs8jJoiIuLjTbwdZ6FtiEGsvw8Sos=;
        b=gv2UgsL4qS6DCQk3y/rFAZGWmj4oQZVRVEgf0hh7I9H3Kc8OutFcLr8sLS6X6bzHCJ
         xHRlMtlVrHMEpemquG8ANj5oazEue/vSElMQwrkdQksY7S7KP+UmmPcV07LfT8av1GY8
         QtS1rWVTdk65IK8ZlIpwlkCSFkOSWaB7p23Lr7oZEu2NIxAxurUcGJaTHL1E10t1Ymtc
         qmGZIw5SmHdjVsgFcsG3uHQgojIQeguWLvpucAbCx+llbdnUotKYb71HBZBNnWXcocns
         3XFsdWHM/RJeLdK2MrXkEii9AgFacl9mH2Ku3EbuaXEkPqXlQqnLPah5iqwir+F9ustz
         51ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763480834; x=1764085634;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZSit9q9L9b/5E+Zs8jJoiIuLjTbwdZ6FtiEGsvw8Sos=;
        b=JXFmVswWsxzOfBDujjYQoVZ2ZbuHwiPFHH1gw3S0RBnQztf8zCj6ciixEDVAY3etMd
         kDe7YuXLz61LKkL1vUimjw+u3n6laHIm/pMlwj8qORh3lbKFwU12EJhJfjjfrCcGCM8F
         tqo6BhXKn13l14SyTyH8GBFtLKIsUh2Ob0xss288RBjtJgrbzEJ5+4YZWe6mFFWToDHE
         Wq7hfGJ5+DiUmtYPyxo2+l41mQcMkuWFpsQzovICuyw9ZRJqVidYIEJb+8wl7BxDLKbw
         WV2erf4swzzwIHEXeUQ6a7vGft+8mid3acLkJHiSGOiSjJrD7oC59UmOTV4olEge8KWO
         oVkg==
X-Forwarded-Encrypted: i=1; AJvYcCWPl9FioRcv40+FBtOG4UN0hqIgItHNL/IUKi+aeRcEiFbvm8GsJCN0BZIIroQdolljDSKG1+W/Zw==@kvack.org
X-Gm-Message-State: AOJu0YwFAjrdq1DQAx/rZ5SN13iNF+f0TiOqqTTqVnfhWagLUe8iPaYM
	iNARVY3pdXHijIgfQ2wYZgqHeD0CU8M56TUkmgg2+FE15o03rtTsUtlkq/jND5a6UWZd2yVoK6J
	KTiC8qT4GHvhh6Kwsf2fKPy/Ufum/02N7TXHaga/cog==
X-Gm-Gg: ASbGncs1PBq4uWI7CUElU+hJu7wr2dx0SU31kKhJZYLKBLnpw2nGGhAy5MtaG2hjVx5
	E/kgW+RkkiKZ2sSv9h6EiXOrY4GJ/uM1WvjYYD9q6sGHT/6d7SA6kF7N8cZwfnk0K5l17tnavj0
	fFqssRuH5HYZXcZY+RdYNlqb93Mry17wCNofjmb9pTlRMOMf+cA/bzEY2t05nXaHgAVxdHEAkib
	iPFxWvx7iXDv0Hf5YjWccfTeh9OqcZsQOwd047uC9Ni0/Ct8HS3RH1icIQY0f6nk9Y/8vQRt0Jv
	RFk=
X-Google-Smtp-Source: AGHT+IFl4FaDFqzlx6bWBXZq0K6NpC2OdnYDHICZqNqSZXVeIXY6NixyhYod+1/BeWpybcUus0n1F+KTrSDNCoyB1KE=
X-Received: by 2002:a05:6402:5c8:b0:641:5bb9:fdfb with SMTP id
 4fb4d7f45d1cf-64350e9d8acmr13722597a12.33.1763480833517; Tue, 18 Nov 2025
 07:47:13 -0800 (PST)
MIME-Version: 1.0
References: <aRnG8wDSSAtkEI_z@kernel.org> <CA+CK2bDu2FdzyotSwBpGwQtiisv=3f6gC7DzOpebPCxmmpwMYw@mail.gmail.com>
 <aRoi-Pb8jnjaZp0X@kernel.org> <CA+CK2bBEs2nr0TmsaV18S-xJTULkobYgv0sU9=RCdReiS0CbPQ@mail.gmail.com>
 <aRuODFfqP-qsxa-j@kernel.org> <CA+CK2bAEdNE0Rs1i7GdHz8Q3DK9Npozm8sRL8Epa+o50NOMY7A@mail.gmail.com>
 <aRxWvsdv1dQz8oZ4@kernel.org> <20251118140300.GK10864@nvidia.com>
 <aRyLbB8yoQwUJ3dh@kernel.org> <CA+CK2bBFtG3LWmCtLs-5vfS8FYm_r24v=jJra9gOGPKKcs=55g@mail.gmail.com>
 <20251118153631.GB90703@nvidia.com>
In-Reply-To: <20251118153631.GB90703@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 10:46:35 -0500
X-Gm-Features: AWmQ_blpsIaa7po7XSkrfRCPIMZ4WBj-h08xugNazGwsDJ_E9pCQg-N3cDPVz28
Message-ID: <CA+CK2bC6sZe1qYd4=KjqDY-eUb95RBPK-Us+-PZbvkrVsvS5Cw@mail.gmail.com>
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>, pratyush@kernel.org, jasonmiu@google.com, 
	graf@amazon.com, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
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
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 501D416000B
X-Stat-Signature: jnokn5nqjkrqw41ykdspoijqrk89nkai
X-Rspam-User: 
X-HE-Tag: 1763480835-734703
X-HE-Meta: U2FsdGVkX1/wiSmK0xfKoQmm+ulv749kzQyvgnUdkQIcOJrmoXIfVFQ98bMgvimAPqw9CkuXLaLcP15RYyzcR1E5vC6Z499Mb7BME6aEv4BlA51NnI0XWILuiF+66e02tWDMbkk18AIUI8i9KomFpwXwxiAQn0unpInLjPo4ANWzLRqkmAJQID9MQ0VIiqQ2C9Ulo6rR4jWrcqGrOjXICL1ZtVQeg+hz13MlifECpN27nCDBxMc2u26DxhtDfvjYbpWwCHTABCeFzC8mn3eNWfhUy/1mEbUmmJH56xMrUAf79hHtMaVOY1Te8fqsOfobguK2i0anYQlcb4Z7/gM2MzzODsMLzK0OgOKW/7siC45P2r7Pv4uDwOy5MeuU5q5ir+WBHQTf78DiQ4L9OuJE8k6mx4HAhVqh0gtyg6Q4QLQPZzvfiMk0GR/I3VaQEBWiL7wtPIYYa+agtecw5iExbbgRykvujFlkV5iSy5pTQCMgmqdonS/JF04tvZg80U3EdXuYlSg2I4Dv9ZoQ+xONjJOskNxqrDuJgypZOxR5dixdKK0V8VP4y2FSJmeo/Wqdtv3Y8uuhuZQVygvwC2sgtpdGRk99waxp8s9A8FP+nQ2qkhCSqxPQ0wogOln5K95HtVkoG7heIBvn+UNsBsGxYOn90adpF4+60BXjXIioZPY9vD80TS4W5UPQPrpppTg63eRiVr1V0JOumP6EtsrdVKY/IX+uuFdr7CW1EwWTl8vvipfdXB4/vwARFBInLgjhNbS0kg/2loqwaWzD5GNCOPENCVGRtZCyjBn05q/BWdpH80hUwAXixdzN4uXk58/6CmqxDqL4YD3TeB2xRpXfwj7F/Q6HwjBZXpVAt5hNS/IJpvnaHnH4uwTKTmwqh84RhTLyn6+y3qF9qMCirVRgc4zKzVHaaQJkB7DOuXua0PLQSQ9OcO9bAC6mg5TXEeUydZQcIgcmm/joGOv5MKX
 5lJYkl8w
 3qVLW99IipkYNKz/ChLi7HjmQf/0mIhNk6F5KU6zVKTFELjkjnCkslicgxJlWOICqDmvPVSRO4FeZ1I8OwsrcPH3L7jluw5+j5Ezy+pHwZ8vTLrkqxDHOu2bL/f7pBTJKpkIBwPRpXFzIgVJjly8TdQBga37No5VI7HJ2SY+F6hVua3xIq91Jgw6QKKCtPnlR7n2mr3o26o5bILvPglI2qH3M73U4Wl4trgTR9SezJdlOHwwFzYX8m3fn10+QZc5c4Odg3fj8MwF+34M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > This won't leak data, as /dev/liveupdate is completely disabled, so
> > nothing preserved in memory will be recoverable.
>
> This seems reasonable, but it is still dangerous.
>
> At the minimum the KHO startup either needs to succeed, panic, or fail
> to online most of the memory (ie run from the safe region only)

Allowing degrade booting using only scratch memory sounds like a very
good compromise. This allows the live-update boot to stay alive as a
sort of "crash kernel," particularly since kdump functionality is not
available here. However, it would require some work in KHO to enable
such a feature.

> The above approach works better for things like VFIO or memfd where
> you can boot significantly safely. Not sure about iommu though, if
> iommu doesn't deserialize properly then it probably corrupts all
> memory too.

Yes, DMA may corrupt memory if KHO is broken, *but* we are discussing
broken LUO recovering, the KHO preserved memory should still stay as
preserved but unretriable, so DMA activity should only happen to those
regions...

Pasha

>
> Jason

