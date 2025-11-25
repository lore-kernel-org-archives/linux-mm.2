Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B99DBD0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23AA36B009E; Tue, 25 Nov 2025 13:55:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EC266B00B0; Tue, 25 Nov 2025 13:55:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B45C6B00B1; Tue, 25 Nov 2025 13:55:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E922C6B009E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:55:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A2C116037B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:55:07 +0000 (UTC)
X-FDA: 84150031854.21.53A11D1
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 91D0114000A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:55:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KyFmIxE+;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764096905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TTCNx8vWQBYhmY++zaqhyqyyYNnaJr9KGGVzzHKQdqA=;
	b=WE0+/atWSkAXs7IRnF/OC1aIXwB9xxxOwD9QZCLIlBd05+QeRKEB22jBRa2WyC2ht/VL+D
	DNzlZxbl3lI/bmkXyW4zTCex6YUqg2LaxhCOOdA2Uojap1/3aXJGT8/XFyb5NtpDXyDJsw
	L8tlAy7Skbsn0aUUHL+0cwf9XEI/iF0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764096905; a=rsa-sha256;
	cv=none;
	b=8qfRcugvMZgu1ydqC79YGnCKXqPJKqtrKgvt20noyrWYwC+2NEhqI/hk0Y10Ucz/a6p77b
	oqkyHLmodlqYCp73klBvcDMgDdhgchDazykbUdR/uNi/1epsgDJEP9Ydv3h6rajqlRsXw5
	+s12F0WrmCnB0mBAQR9B+ad0mQE6y48=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KyFmIxE+;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso173024a12.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764096904; x=1764701704; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TTCNx8vWQBYhmY++zaqhyqyyYNnaJr9KGGVzzHKQdqA=;
        b=KyFmIxE+9OzuUJUMHMQP7GQkPmHs0HLcclMPtqlaRiVXUI1XaD6lqEEUBTF5Bm/TKO
         Jr108hYnTFwuoLESJcHcZpllpmsnwHCOdFNM+iyo82ws6wL3yiYmSfn7uw6n0qLxqOQ/
         2yHi8mTzXFMZX6q4zNAnrL7+LKi/t8iNTjY4V+/wzFwK2q34g5cCFX/6KqQGfPplwviY
         s6hDMTauV6TOiPClXvdLmQholoeeIIcZImeiY3KeTGLlcX9PoGTDj3f1IzQERo8olajj
         sEXjn11HKig4FST4YuY/89f7tvqxODMK9NrbNvWf+gKyOHgBFf0a1t5PCrGitgF8SKfq
         KbXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764096904; x=1764701704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TTCNx8vWQBYhmY++zaqhyqyyYNnaJr9KGGVzzHKQdqA=;
        b=ZdTelS3s3+iJeePWqKv98MbZj7eZg31PL3Jj3fLoNvpP2nQQy2pJ1UKVOk8NV6ETff
         TyiOhXEK93OBfLwNf8o3Nj79dUBF5u7Xg0W67QgIF+9kykPXckQdxdFU9WO2VXfeNh8z
         fSNfSbDcbA+VBs8gTTJen792rlmGUJJZnmbGAaOg7tdb7RM+daDj+S+v3r5BOXatCtTR
         IPy2fPtxTP2+h3N4k2hVwbdgz4j4WakupoQRHijlon2jpCJvonmKfCZtv0xEFQXw7vzx
         KhaHKSF3jrtudj+5jeEZeGq/5rljTaxgUYRVOfzZA4Afz2U4k4YrenvAL7lqR9VOCPsE
         26Xw==
X-Forwarded-Encrypted: i=1; AJvYcCXYDX2Krs2Fv/bCLRAKUrPb9rNcbq53ppKP5fcNiW9vFy9qn62Cnr1/IMvXmgBFsupggWbXc9Hhnw==@kvack.org
X-Gm-Message-State: AOJu0YyCDXy0F2UPkUNu/mVUV13p9PaNGBS8/FWEMgnKQUZmJANdP84W
	Lne3nfx9Rv/yB0EQyDtpFy5N6QUYVgofa7VZPD37NiUY/bRMc8W6ex+2ZjCywTzvWXkBIAjjMtf
	koGFzEhlrRdjmavxgJIBKhDc5q45vURjVZay4JPeENQ==
X-Gm-Gg: ASbGncspTFZiNeHmsiP31vryOxBsbL7GcogfSHZxM+PdtZRl7tJgiig3m3CqMihhoG2
	J27i0tfkD2hqBlqnAPSjbaQTPy020cLryySMJDkMNAGN8vhP91vXAyId43r8tiI02OVVa6fahXn
	8ZiYthWM/nzoZZgp1FYkoc4LC1KgJVX23CsrKER2HwcJPjHI/GzLrGRK37CNMrGgKHoljQynlXn
	yHJR+zRWX3iYVnK7RkJ7mj2H7gkUSXdDFcQLntpuZDivW2tKRak/evYpu1zdl9zqBWu
X-Google-Smtp-Source: AGHT+IEfzHlIPEiuolnmC+PUY7Qx4g6VZmzqaCh+kJH+E2RdrqezJkmRTURyahiQenFGIYx+F1u+CuUpBK9+z1Di0cU=
X-Received: by 2002:a05:6402:4499:b0:643:130b:c615 with SMTP id
 4fb4d7f45d1cf-64539639594mr16646192a12.6.1764096904062; Tue, 25 Nov 2025
 10:55:04 -0800 (PST)
MIME-Version: 1.0
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
 <20251125165850.3389713-2-pasha.tatashin@soleen.com> <aSX6sQqwwA6I2mxW@kernel.org>
In-Reply-To: <aSX6sQqwwA6I2mxW@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 25 Nov 2025 13:54:27 -0500
X-Gm-Features: AWmQ_bn51TAVMNgVIbPP9PoxfS_5IRPJ8eZ2jrzKpsVEpovGvgRKZept8XkPO9Q
Message-ID: <CA+CK2bDUgU8iBOL6eUeK96fZ3-XfokCma43cTore20c1L6GE0g@mail.gmail.com>
Subject: Re: [PATCH v8 01/18] liveupdate: luo_core: Live Update Orchestrato,
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
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
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 91D0114000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: tkuz4hudadwd3sb34on44bn6icsw6yqj
X-HE-Tag: 1764096905-723909
X-HE-Meta: U2FsdGVkX1+laM/WcCSDSy2GQIYaHpeoNHsp7wEdlpkY54yeurq+/7Ymum9Tz+YpUg0Z9r21aKdPXOvTt5hjRsGW0Zn+CfpaRp7QUW1CmC+gD2M9txlXutpF9B85otNzjl0paGIKzxCflBMcakueYrmDNAqVqxtNVHo4JhDswaNGQvVadobnom+i/48fJcolxca7qVe/TEh6nCkpy+Ipb8orRbeeMtAZ/tFGlSh7gWFn+56jMy0pDOv7qjRgxqe7h5E8n05WS+ILoyjDa5dgljPNx7m2nWCOZLxjzgWfXOEbdlmc8hOXspTjYVI05RalTQUke3HbXK5TKwgqJrNQN5FC5LpvdDGP2M/KG/TSudv13Nf4uG8R9i8ihBzMILRe76no8Vb7uffmh1YxH4U4s0S8eLsBJf1153fevpa0QXy5YZrCViNspuiGpEk0rNRgnAwstp/8HAbnOjNIV9aD4/WEGJCn8Qceyk1Hr0Vtsb1mynsDUhZ2KjhZzYcdgCK5vv3Iqrp3IFLQ4OaVgEeb6VxmWmrlRJ6MOIDvUB1CXJpb52fthh1bCxH7pUFHp+2fI3eOdjVGyN5kg0yYcyGcfb16aXMCwlVE3WTAklN4FH996C9kJlVrqtmhOphxEXsyGyyxaUk1tZqllBlFNPh+yp80lY6Rog0Kzgdf74UmWK2ku19ol58RFDXjpggkkT9mnOGXarftLcPFjuLv7EOXe63ekwy3EwqcQ/VUHq7JJtD9KDnDV8+8z0fpD8Ufna/UjFXR2tlv8jIzEUsCE8XulTZXK23SiZ5i3fAdlcj4qNs0YZ+N56sEM0Xz0OF4ys5aG+oS5hy3zqUno8OChMgGufgCE0IXfeWC4O+ugw19St8zZ7sywiDhkcwC6kvWUZWKrAzH3iKLT9hwNyKoBWkn+FvpBNH8TqZBhotOszt+4glgyW7C8OKAiUhTiyCIx/yj/hjPy9zJb7fpxqoaUTS
 g5rrwMwC
 P2C6GC699LpTiYp+pTKKiFSd4A9K/pmMlKbF8HesITE4G95qUawYDSyfSK8ep36UpSwgVKKnkaAfpq/tiaz6F8WWTxlQCK6gDU+hHDru3PbIPmb8zogOdFTVcYoQjh8TDJHsHohLP3OZjMbBJkBYGR+w0OIOOrx+Fk/jUZ18BomNO1qos6iJ3lWWz0FLaEkcFVKy85Cs9giVrNtOH27tSwc9zDjS0e3edXZ9KX7WL5JT3ad6h+wmkKL1e+6ZaNYII1KN7C5hkedjLaGIZxSpQNh3G0kaKqtJIXzLwNQCLCIZAvfb42NlXafFKMn6vdaQxYuxZw5HDz2nA9FQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 1:51=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, Nov 25, 2025 at 11:58:31AM -0500, Pasha Tatashin wrote:
> > Subject: [PATCH v8 01/18] liveupdate: luo_core: Live Update Orchestrato=
,
>
>                                                               ^ Orchestra=
tor

I like the sound of 'Orchestrato' :-)))))

Thanks,
Pasha

>
> > Introduce LUO, a mechanism intended to facilitate kernel updates while
> > keeping designated devices operational across the transition (e.g., via
> > kexec). The primary use case is updating hypervisors with minimal
> > disruption to running virtual machines. For userspace side of hyperviso=
r
> > update we have copyless migration. LUO is for updating the kernel.
>
> --
> Sincerely yours,
> Mike.

