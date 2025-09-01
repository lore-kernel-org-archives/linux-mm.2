Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A176ECA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 19:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA76D8E0008; Mon,  1 Sep 2025 15:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E718E0001; Mon,  1 Sep 2025 15:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D949A8E0008; Mon,  1 Sep 2025 15:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8A9A8E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:03:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A1835C25D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:03:26 +0000 (UTC)
X-FDA: 83841604812.01.E09FD2F
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7EB8640008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:03:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cjX0NZze;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756753404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3hCdUT2ICLXa1GjNdU28dZZnKCVYtibeydsEJ9rZEA=;
	b=JehZQY7PRpwtOAEH1WnD6ZMuA1sPnhbc9rs30N7ZI8SePieS6MiUrIll3lYWUCZgcnprlT
	kb5F1+elRRdTncoTU9W8GpnXOsUCT3zIYBPbOXjSEFXsrnfU+Hc3XU1Q8rE2+TN/HfXa8j
	XhuRYrnHErqOlyBahLICCSrZqakYixQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cjX0NZze;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756753404; a=rsa-sha256;
	cv=none;
	b=z7e4TEPTQOl1EAz2sfaT/Eqois+CVHWDqFSOiwzj1HenFDyBO4N1JexnlY+LJ3jhmnDqmn
	EfE+MxuWjO+gBi50z0eTYodbLR/Dl5+DjNcvRBaHipP1KMUym9QXaRd8S6w+6I6vt/wKh1
	9mdaGyjMAiBHomNTIEzuamr34RdWsh8=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b30f73ca19so21153601cf.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 12:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1756753403; x=1757358203; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S3hCdUT2ICLXa1GjNdU28dZZnKCVYtibeydsEJ9rZEA=;
        b=cjX0NZze4cn9pu3MdA0InWtWSKf4RBvdz6wIKG0GhiVdrupwOvpjlYe5/M1m3XX8qW
         Re4fOY5LcwQ0oeahaM/tNgfE/u3daxERw2zf/papB48+9DT+1jIFR12QUnlv55MH9otR
         mFevuCR9P0AZly7A6AniVNnOzV+sua4Ny6cs0x9YbaLlVO4Gs+OH5sGgA05MGUgQYZvs
         0WsBm6LVWK8yS2ww1iojI0gLIcBQeosNULeQYcpLDrJ23PrRCxcbpcTALBFrJi20uYxS
         I4JnZvMW54T6TE3BVHdPtXVSXr3fy++hhAxjcAOER8q4r9qv3fDE6iN+kXmtlYO1Y92s
         +V0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756753403; x=1757358203;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S3hCdUT2ICLXa1GjNdU28dZZnKCVYtibeydsEJ9rZEA=;
        b=Af6w3c43krmbCUre7TSav0Rd8ACQ+C9pzh+lEgycuggY2nQsSsSO5A5Dn/xs/M5PBt
         zm8RaraEZgVbqCMc69L0znqMlLGFMO4EzjB1cIG9HX1qCTF+rFZgmiUTwhJ5emXKw7iK
         OZDpafR6jtKAO5ybY/ZAFPUDDAswSNRl4XX354Kwh+Li5GLaQz3sGh/k+ynzo4kCI8+Q
         lfF9V8l9LEqDjEeROgw4jdJBJvZVnouUGEr8YP7iyvTxS5nQoigEnRqmDipzynpPNGkC
         GYevImkqcfB5h/6EvkOtIH9qtbkJfIS2e/mdEdfESiSL2Su9Hn6GvSZOOyG7jD+zlVV2
         a3Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWM1NqavG/rjKeFvb60fzBAStzAOptzVWtcIag0JH1eHnVokZqS8KJGuACnA8vZIhw2hRogfk6Q2A==@kvack.org
X-Gm-Message-State: AOJu0Ywiq/sUJQ7cJSpw99imdcEdu4Ze9cZx72BH/RpYHAT7zoTuDMlI
	+1joGbjicvwPDmIfiRxeiII0aPkkAGzQFCMXBtOV346Dx6kKkld98gomYY8YgKKdPqBR22sOX/y
	3Eb/R7FlyP8107A1pzMgQQppHnO6Z7wf9pw3klvZRqw==
X-Gm-Gg: ASbGncsBuTpMbuf+ooknsH02bmiFdPKRxBfDcEYUBg0yF0GsuqyFRRTM+gONJ7zbw8x
	Kya7phsYinAEnQUQFu0C3Qn2IM9BcwwkSmi5J/nFEWf9IsQ0N6qlQ7/H4l77SmMXevwh9LyMQY0
	hTj0CiKBucNGrg26lG5Xbqd6ejvLQV4nsqY9D4nOoj4rDb4Z3Vk8VwZNjTmCsZJ72txEffDYzYs
	+wssjPxpus7hUE=
X-Google-Smtp-Source: AGHT+IGC4IxxW7gTteEuAiFDY4ARihDdjTh7r8Mht+Ln0Ng2xWrhyAI5gEJNZ2B2JAdSBb2GjROz0/at0WjW2Aw4LfQ=
X-Received: by 2002:a05:622a:1a0a:b0:4ab:902c:5553 with SMTP id
 d75a77b69052e-4b31da17d84mr113554401cf.52.1756753403110; Mon, 01 Sep 2025
 12:03:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com> <20250826162019.GD2130239@nvidia.com>
 <aLXIcUwt0HVzRpYW@kernel.org> <CA+CK2bC96fxHBb78DvNhyfdjsDfPCLY5J5cN8W0hUDt9KAPBJQ@mail.gmail.com>
 <mafs03496w0kk.fsf@kernel.org>
In-Reply-To: <mafs03496w0kk.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 1 Sep 2025 19:02:46 +0000
X-Gm-Features: Ac12FXxIFoyzz5jiOJ4O5RxQRUabkrNBq-ldI0H08I8mR4jOJnwP6yzvNT_MXGI
Message-ID: <CA+CK2bAb6s=gUTCNjMrOqptZ3a_nj3teuVSZs86AvVymvaURQA@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, jasonmiu@google.com, 
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
X-Stat-Signature: mf86pecuaz6it7r14mpsh4ry76egbsg8
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EB8640008
X-Rspamd-Server: rspam05
X-HE-Tag: 1756753404-134926
X-HE-Meta: U2FsdGVkX18/D3mK8wI5GQp9O/wH6YgNdOrw/Pzp2sdmjhGa7Q3ikUXPGBb6kBzUoKqTzEaKNBOypd0orOyZxrzX+CcnPvMFovNIjhoTTQAXZpyhGuEKndlGODs0aeKtpM/lHdjF4XHDu4Zogr3QkMrrEddJtlsTG5tAHBrMd+GUHb7Yk4H3KbdXvIGXsg+ayxqyfOpq7a2kuqNAs4gcLf5+MeR3OGerq3BcXSuosJ8UvkVbLx8bq/ermpUiowFhA2Kq+nC2Qj1rw8XY9lZLfmh+PlGCcmxBvLJnv9Buv9w4eh0BWTA0udSboz74V87nd+lgQJz9LXMPc2196mQru9fB3ThjxXxmGQ+Hn/iVIRzeusHzMzrG7g9bfGFclBlmEbqR9k/tJAAG1kwn36iZ1LTrI9964x+Lp4Q1YC4QMwifE7iAUPGJ+Su5V0qNi894ISdIPEafETQvQNZgRjnXFm08A6tzVoK0cYVBLgDgyot2lGX/63dFXWUd4QhBwy8EQvmUrKUv3xJs0tTTrN/gkm45FnxZW7G6CtbTtbOEh97WkLVmFIQEnEtO+G9nfA1QAxCECNKJMvsFo9osduhG6wM63zP8Pj2JX9qkz2xvLkcZZlGImm3ZCJcj+q6QvwAWAJyo37qA0qUllVX8xSPwkCQaTaozozqfInTxCbYf1fNZVYiahAqfKI8tXdwoKNQaU4nTjgoyLgzYosXUrdqS0HXz2viYcyLbi5chCoi4eqicaN5cUvjSd1ULn7muNZyNOl+xfHElMbI3MPeJchpBgogYPpBNfcMeQbuCYhRc6+ufXWCNCrWmVTgBpIvgVKyl++KeAMlkSSlJ5vcKp3wYywC9BOMoqiEaCI+65uQFDRM0heCI/awzMfmFROIp1fWvskjKd+U1QDWAsyFRAUK4mJyxWIijw9AT+puONK+4vev8rHkoAN54klG/088i2qwmVih//UZkE0lICXbtCBg
 AupuU86v
 GSDXvk3ShIW5jr1N9UGCbTUjJj2X5+GlKtrErJhbxg+biKliEGjm5m9e8AxohX2aR3/CSKGwyfaGafnP8+70AwKRkNQ62gp1ycB9q0i/8xdPyQ+PkYzdX5+fDXHZw7t9I9FImx4FiLAEbREPLbXSbwrU4c+9XKRizEP2qH1h3wpssezjz01dbeOX5mW2jZ24G7fA6bT6pzVkQd/CApGkzdgab+JMh7qawfaGT/EN7E19j89bevAYxG+LFFiw3sEM75fjXIPrdl6E0oUyxfl36eH95parduTTYEIJc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> > This really wants some luo helper
> >> >
> >> > 'luo alloc array'
> >> > 'luo restore array'
> >> > 'luo free array'
> >>
> >> We can just add kho_{preserve,restore}_vmalloc(). I've drafted it here:
> >> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kho/vmalloc/v1
> >
> > The patch looks okay to me, but it doesn't support holes in vmap
> > areas. While that is likely acceptable for vmalloc, it could be a
> > problem if we want to preserve memfd with holes and using vmap
> > preservation as a method, which would require a different approach.
> > Still, this would help with preserving memfd.
>
> I agree. I think we should do it the other way round. Build a sparse
> array first, and then use that to build vmap preservation. Our emails

Yes, sparse array support would help both: vmalloc and memfd preservation.

> seem to have crossed, but see my reply to Mike [0] that describes my
> idea a bit more, along with WIP code.
>
> [0] https://lore.kernel.org/lkml/mafs0ldmyw1hp.fsf@kernel.org/
>
> >
> > However, I wonder if we should add a separate preservation library on
> > top of the kho and not as part of kho (or at least keep them in a
> > separate file from core logic). This would allow us to preserve more
> > advanced data structures such as this and define preservation version
> > control, similar to Jason's store_object/restore_object proposal.
>
> This is how I have done it in my code: created a separate file called
> kho_array.c. If we have enough such data structures, we can probably
> move it under kernel/liveupdate/lib/.

Yes, let's place it under kernel/liveupdate/lib/. We will add more
preservation types over time.

> As for the store_object/restore_object proposal: see an alternate idea
> at [1].
>
> [1] https://lore.kernel.org/lkml/mafs0h5xmw12a.fsf@kernel.org/

What you are proposing makes sense. We can update the LUO API to be
responsible for passing the compatible string outside of the data
payload. However, I think we first need to settle on the actual API
for storing and restoring a versioned blob of data and place that code
into kernel/liveupdate/lib/. Depending on which API we choose, we can
then modify the LUO to work accordingly.

>
> --
> Regards,
> Pratyush Yadav

