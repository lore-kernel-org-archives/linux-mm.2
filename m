Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC55FCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31CC78E000B; Mon, 17 Nov 2025 13:25:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD4E8E0002; Mon, 17 Nov 2025 13:25:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 194F48E000B; Mon, 17 Nov 2025 13:25:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0445C8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:25:47 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF8A04CA4D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:25:46 +0000 (UTC)
X-FDA: 84120927492.30.17B2697
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id CA87340009
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:25:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YesK7KIM;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763403944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMycsWk6alcimZ9cye+sIiGHVio6V3dIKHH3BxJbFzo=;
	b=tf7p9Gi0G4RzIrDiDi00sKtL3NCw7MvrQSip6Z026TbRq2QWFJokg+/dgAkYu86eK42H2l
	nlVjS2hug7hZghucEzewxz1AMGYhXmuxHA/ucVil11kxZqmkrVknVg5x+141HIzVpkvVmg
	Zvjr56KrcWVA1H3iK8wypjsd8iywEvY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YesK7KIM;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763403944; a=rsa-sha256;
	cv=none;
	b=Yl76l+mmX1xmO3PP+FQIz8PkkXAbf4GcwlHhs9Ze8tzLrANZc/LFYIXdJQpkF/HGzAHGqU
	azSrjZWyi3atfQaEfiIZg0rjW8qlw3LPOdTvcIKwsxg8zWWaTx0tIK143VjcU/2iwBoljL
	dr7GDZIA9TldDmJ06TYZXjU7iB4xnWc=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64162c04f90so7537652a12.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763403943; x=1764008743; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMycsWk6alcimZ9cye+sIiGHVio6V3dIKHH3BxJbFzo=;
        b=YesK7KIMZ56bS/5F1Q1PQj47MTU4hg7biaJlEKDkxYrFqXvp+EqqpXGPCKqrz5xi5J
         ezytC0N1K7VkKi3f+MONVXa4e5XJy9+8PtNxLxo1TQkcJ5R54jLY8E27Hgv3uUEM+Crr
         THssZjV25lCwXZyQ/OUFBShfJ+GGo3xeN5fd/9xaT/bqjgLzoXT2nEM50DeJoFjYaFQF
         WGZrcSH7pYNO2F9TLXKDhyiDKApKwqxzyjLUtvhTdeTYiqlLoRCR/4pNRSm3oEtrNZj/
         cIANEmdJsVReIOa/GpTAH+GWGySogvkwz9TYL05k7MUGlsZciuoCRdvXE15BhqBYt8SB
         46VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763403943; x=1764008743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dMycsWk6alcimZ9cye+sIiGHVio6V3dIKHH3BxJbFzo=;
        b=fNcSQj38ATLHMi4a/Q3FeoS5jp7+eylg1p6oL7iDUh+Cm1E6yCJMLzyC6rrG+1dRdu
         7tUpEIPIZUGIJ+67LFODs90Rb3AzVuAtGfjNgW/X7Ob8As8cSE/lDj6dad+bFxnekmW6
         MeiR1jGpJSZ9RJ1t6CXCzjaTsKrhvmkxY6jhPNpAVUeKsTZV1ZHDniKb0AoUA05v9/fo
         t68Cycp+sIGhDGz+tdKMpfv87Mz0fngart6a+kdSgbr0FoKVGlYp8jZ2ds6c5Z2u7jta
         xLlzp73avhuIR+Mv0CHcvW0lJ2qhcUbBGqRBCN7uYjr8S7E7DpFqLz2dYMKWj7NKuZQf
         LHcg==
X-Forwarded-Encrypted: i=1; AJvYcCUUH/pxd1LQiJX/5cDP4d0BJ53wXerxJ1+7OZGXas3fEqfjVkPRXnhQha9jsqLAyN8yanBcdUG+qw==@kvack.org
X-Gm-Message-State: AOJu0YxyR9uRFTEK5BqCcXhbFyDeyzMY+06U7CQuN0nKUxsdSokTM5kn
	5zQkUJP+5HwrnzusFRvh19rGv2D7KRq/LyeY7JcI1StWmyjJCOBUt8vFx4R8frwmPNO0L5t+DFx
	ypZVocv/Axb9OYiC0EeqBIr8xDL5RteXyzdXxelLuOg==
X-Gm-Gg: ASbGncuxIWkzd8pGS59SGlNo33zYLrfvfo8X5j55B3erX5YWV4hqjd7v5LN1GrtgE8B
	oHnChD2Ht0S2qXmT9hZpRaKcuKzl6FymGyf29uCDC38OzzUru8v+QiF8Oma5c1FD58RfBg3zcAx
	BB1aLe19Qn7WJn8DZSO93f34HfkwTqXIUv+NGOfn5H7A2fgUS2ogXV0TUK0Co5ulGwjsatnA2y9
	N1srkcwNMzOTujKbTzBk6eEJsYDCIOG9WOPep5ugnsnGKl14hD97eEWq6XOGp23xSuC50tNKYPp
	OVM=
X-Google-Smtp-Source: AGHT+IFhDEducLN7T5Jy1DwFvPprFdHcnJ42WfejgEYNti2gLXiHYmpyBjQ/4t56trSFuAgRCxac7v4hY1mMU4Ka3uY=
X-Received: by 2002:a05:6402:23cc:b0:640:b497:bf77 with SMTP id
 4fb4d7f45d1cf-64350e9eb61mr11509176a12.35.1763403943114; Mon, 17 Nov 2025
 10:25:43 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-12-pasha.tatashin@soleen.com> <aRrvaHh-cP8jygAF@kernel.org>
In-Reply-To: <aRrvaHh-cP8jygAF@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 13:25:05 -0500
X-Gm-Features: AWmQ_blTQifSbVFjHBESf3b3IYzXXqzrvc6uwjRPXvt2KinsJtxmdBdOtqW5SFc
Message-ID: <CA+CK2bD_a=C0h-y4HDWPYV1VOWjM7V4gcocwekA6M9h5WbiqSg@mail.gmail.com>
Subject: Re: [PATCH v6 11/20] mm: shmem: use SHMEM_F_* flags instead of VM_* flags
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA87340009
X-Stat-Signature: kxdf4rynfw867snz19xumtpdeh5zxdx6
X-Rspam-User: 
X-HE-Tag: 1763403944-601305
X-HE-Meta: U2FsdGVkX1/hO4Jka7sZos4AxnmeIuA/iDMhEca9QNdoFaRAhNOXRsn9mFNjVPKn4OWZghdcWPYQishVyOkaxUWX4uVALve5MXgAIcsMWNvbQiOK3wc/C5pTVWRmfUr1E8r3Q7nsUhq1D/85mRVuBLZy+fh0sdlL3zgkMTrjkK/ITZAOWF20D6fPmelxOrTeh3Z6LAjcTQQl4Z32IUv5qBZs0h30xDJZJ1af/yHly46CqK6UI+Eps58a6rOkfM8lKfm0tneuE4UtBIiJ588vALlTsmel5jiGKaqLoXTeT4DpyV62V3jjfwVFdv+s2GEdQGNSj5/Jsj+mgWgnMIeD2I5pXgz+Vhvxnd35DCp76UpmU1npcasSLQzzZenop7oU7hQN4bCQbE3Qv+Hc8YyWtz1D40u/TDzDoLqqfPkXUpoFY923fmPl6+opmtJXW4HN0ymzkXMpoOfn2wiQXMr97epUyJhyin98m8RlVI+Qb1P6MRTgUraRx/7Npqhs2S8lydMHQjFa9C2L8VAzzc+5zo/F3VD+zucpKZV9xZI4iYsjKDaur+XwKDccGL0T3SDCeqPonouycHcqozx/hKvuw0ACErSOcLXeekaOhkpRD8bV7G2cXdYxV3AeHIYcOcpPAIcfzXYXmatTj0H/uc2eQoXqVU+XXhPwtMvoVDk4z3sjIn6N7AUL8imMbZI2A/gF/G964JeUp254Des0hFl5UzWU36jSliO+/SUqfpfTRkigE+6BDxKQ2cEFLeSDXnyeKP6XGvOadZl60Bxd8dJu4Xb0dNEKtqESFv8bDetPTY1Fks1Nu8zbNZKiBkNsoLOSx/rSG4fZbZ+wYOpXg4qLgYxVFKi6WwNo0qFLhOb9tWS16OjDl3Cz1ZD02+U/gY5A394P1m6GlLWHriVLtXHgm/+UXf8vZ2RmZEv8+YK8pxXJHl6MiTFQiWT+KWao48BiuQj7rGpN3kMCLvvQlCq
 KidNwQTc
 35SFBedDhf9t1ECVgMN2ZxIFL5wMCzKRHfrkE3/S8u+nngyk4tzt0In4LqA0yEGjVOoyIsHsNakVlh5Nu+aKC2amEcRg+vZ+B2VFAReU/hMrl9e1VTM+3NGzj1MkoaBBOC/1y0PhtvT/BSGWS3qRWfoo+13DmvkLG2Rzte/zxgner3AQrkcAt7p6klE3SvnsZgWl/ifiLnHD/iaLWRP85l2EjUH9JViSeoY7Rt7zOzIXc0YfZTGCVOhtAI+IfGS9fCCbTj7LV82xVCobixkneFF/Bqh6ebEUItBHsY66C42bjEy9eAY/Udg76JBxJki2WJZCRf8Ia402h7Kqpqz7z5MUyTyq1oC766dGkfvpAlCiAiWmYKfx9yPFhlnmcubckn6yql60koaeMg+AayRcvwWfFly/GwW0GtWTaZ1jiObiVAttkJCDWV9LxQ3GtM3nBhnYEm8CePnaB1ZQVG1t0nKA5FF4mxcN9/ZBanmGLZNpWCAvHN+O7hKeOWpwenVdlAQWl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 4:48=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Nov 15, 2025 at 06:33:57PM -0500, Pasha Tatashin wrote:
> > From: Pratyush Yadav <ptyadav@amazon.de>
> >
> > shmem_inode_info::flags can have the VM flags VM_NORESERVE and
> > VM_LOCKED. These are used to suppress pre-accounting or to lock the
> > pages in the inode respectively. Using the VM flags directly makes it
> > difficult to add shmem-specific flags that are unrelated to VM behavior
> > since one would need to find a VM flag not used by shmem and re-purpose
> > it.
> >
> > Introduce SHMEM_F_NORESERVE and SHMEM_F_LOCKED which represent the same
> > information, but their bits are independent of the VM flags. Callers ca=
n
> > still pass VM_NORESERVE to shmem_get_inode(), but it gets transformed t=
o
> > the shmem-specific flag internally.
> >
> > No functional changes intended.
> >
> > Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thank you.

Pasha

