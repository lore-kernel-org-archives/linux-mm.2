Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD71D0EE13
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 19:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4D76B00A6; Tue, 25 Nov 2025 14:02:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C596B00B1; Tue, 25 Nov 2025 14:02:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1CB6B00B3; Tue, 25 Nov 2025 14:02:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65A1C6B00A6
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:02:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F0C812BE3
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:02:15 +0000 (UTC)
X-FDA: 84150049830.07.F3AE6F7
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1BDE180028
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:02:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jEdQ50Q1;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764097333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZbg8SojFwo+/6fxa8iIzTLQdoY14/XcMqsoNhFxHBw=;
	b=NYHiNcCxW3iQ8dknysE89b9/rgBFftxOgsexrKcFAIpPilgRUywU8vNV/NZ0q1N+IIfqGt
	GhkKBr4CHxFJnCeIUh/1KUM4LXIcofLonNG31gL5W8tvuRQhkyHcN/E4woomcmH3Wf1iNj
	VBT4xePWuxi1KuUxwExOADxtipvyByM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764097333; a=rsa-sha256;
	cv=none;
	b=MdrcUcDZsHRq0WDDmePcURMIW6bpkcrOH2+R5CKADlt4mMjR+rc/jywm/uhlcftTcDpfnD
	gEU6fmWJIzkUTR9iX64O/IIDNURBMh/Vq8ieSgKghE+mq+lijSPpEDlFsF5UXwsvXZbq3g
	fCs0oLhS8XG57J7cn7R8osfxmScx9ms=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jEdQ50Q1;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640a503fbe8so10440599a12.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764097331; x=1764702131; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZbg8SojFwo+/6fxa8iIzTLQdoY14/XcMqsoNhFxHBw=;
        b=jEdQ50Q1aA5RlH+Cg96tkSpC2Moz4LhNyfWhwy5ZLYJZdY7FdKPAbgiRQNh2COMmJA
         ZhHJNWUFIuLFNGxue+K89bf7SHWIhlXiDBXIoN55f8OPCddUxKGsZ9M+macA1upxg3xR
         3gmdZlVrByuQyw6qRbgZwchRzp6qDbTH9AnDsxZDT2TLhrYfCDjlVPLfdKeiXD1eurEH
         ula/Z9yIRsbQKWN8QgVPGi0ZAX94Ld0cwBqWMMvGyKQSV4+zL5LRvHKCCj1eHZ51CMa6
         uSqtQj6NhAHB6Y4CUgdaBfLRmxHvTncwo3hlwisapEgFybuMn1sO6BWqFsee6Bq39zjK
         YK9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764097332; x=1764702132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pZbg8SojFwo+/6fxa8iIzTLQdoY14/XcMqsoNhFxHBw=;
        b=oG3Q2Raz3suIEUXmJ5K3Vnl7N5QuTCzcev/aIv6lsc2cLPAldYBXlaZ231V3ZPACKv
         6EF9PwvG8B4Fz8oZaM2ZyeR+48Q4EWGBvOTccZxbStzkmkW2v63x46z4Xsol3G+VBNc0
         PmJSXYfvdXBr3rSLzSHREL11C0srdukczeeTALEJHDw2PAE/HMFkl2rmvXKCED3kWR2n
         OZrMBMjRpyCUTvGt1zEQ950AL1dzWvIdZVYJ6UCbUobGwKok+FJ+JjNK5bPT/OucSoPu
         A6XF4OozLZBnGns/PY4/bb3VexumZVuNOcQ+/wwydXTD1kFk+97TopHO9ivSlwjulrQr
         0yFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNHbsHNuflPgL1ItEw3DngiCiggvhrCXdfcf6nHD1XnPjXYohJZPagbBh47ZCPBCt8vOqqGqQgAA==@kvack.org
X-Gm-Message-State: AOJu0YxkCz93Ls7Lbzi1/E4oOScAg4iMg64RJSV4Prrhrnsd+DMgOUiQ
	Po2b7r2Q5UKBWrpOTHAEo7du1NNp50XmxEftAHf3NS/6opPvmCYFrBprDB7JVWKZLIpWhkZfNmr
	AJq4yzoPscSyktsDxZyX5SX8zejDabJgoUZkwitaGqg==
X-Gm-Gg: ASbGncuwbQLGLqgDWPQ8Xk57s/1oMHPT3ovJR1RpI4fM84OGaQxVkvcu5GzmtdAD/3h
	u+O8tJ4yTbfW8Pr39sbOOFUd4pArgFnbEhVfPdmpm3LvhqYSe/jc1UHFRP9gTeTi93sAKaq8ftm
	HZt0TBoGDnSUCD4EIuF8CJaO1xOPHvJr92RFlET54lFMXQO7YJbLYohHDa8KeI20xXDKwAzAsPA
	Qe/trZAfPZQwoMIF+RUHDRtpB8StVZz45ujH7prMAe1XtTw+1wOxAUBTV9VqbkCp+ve
X-Google-Smtp-Source: AGHT+IHaJ/LbREE5Jpzko9OcKbnJBE1+OgV3WfTKWJciDLFdWD0t5cmLQ1AQFk0Y1AJ05l0WSop6DSkyv43G2Zwocz4=
X-Received: by 2002:a17:907:9720:b0:b6d:5262:a615 with SMTP id
 a640c23a62f3a-b76c5630b03mr446231166b.41.1764097331448; Tue, 25 Nov 2025
 11:02:11 -0800 (PST)
MIME-Version: 1.0
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com> <aSX19cWypvh1mKWM@google.com>
In-Reply-To: <aSX19cWypvh1mKWM@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 25 Nov 2025 14:01:34 -0500
X-Gm-Features: AWmQ_bmdDcUwBBud3cZl0TGUz3iSEuxf2L3NoBzXOoPUOHJetvLBDiXl30iG0_Y
Message-ID: <CA+CK2bCq3K3dd1a+OGtsqGHpraFZcbxc_LCGt2CPz6euFD=_CQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/18] Live Update Orchestrator
To: David Matlack <dmatlack@google.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1BDE180028
X-Stat-Signature: dxe86sgk8j9ugntbunbabbfsn7gkfwe4
X-HE-Tag: 1764097332-913900
X-HE-Meta: U2FsdGVkX1+znATcNf9/k9ruVXuMBDyxd7ZvBCHwrmMRhHPKUgc/KMQuIitQ/nsJQhjnpmlqsNHq+U1S7YndYq7es+zYKfQL6ptg3sjr+/3E545ZGjAUgtgjFDUiVJRrI6LN9GUp4qZ6x7va2DS327sqeJZYKQrH7NXAFqBVFkxqhHNTKraJRuPelnw3yVPBfuuUQbRzKPZLVSgMl7Uml6NzhlP15eW7oYcSM6jhPHGOD6DJnNuAs8pujOVtbvttFPiraF4XT+ed1ZmCDz7jixulnWcGYLA7Q1gjSfShaMQkOk0At97+mGw99ZS9ZDuN0kUuDb/emA95fd3JQapixC0NLQ7aVJqcmd+IFKf5E3Svj5urimzKVsuxFzlXqzAuT1SeYm3ZNPPx8v257849ueA0sFk4d3bOuTSKbkcV6nIbFAnaZVNNqo4uJ6QmJHTYF9xKQ53+uKJ0KZl3IwcALfQWjo0b+IwXPeGBubq6rgz7rdBHZmPbybk8WIky6+43gs8ELdpsm0ZZ2Q7/LnW4ZTT+ikgVk9zGFjZsqCQjsdm1Np87qd5pTYUzc2u6FxA4Qxfry19Ql+hk5fs0z3c3B24BSfJHDjQaXf4V9nwqFK5vlyvmqu646TlAH2YIPsRbMeHYf9iIryQ1/24WmE3RAcrsFZi4KGmCtMdcPHJEDPgsFbF2Ti6R9wM8oBZDS++pqn9wjYp+3t5TZO1QEcDEzWbMvpRvz41uppsBynSjvyGlmoSVPQlaE9axhKG5yof4ZcI1nFpN5XivOkGbM5hmBUxAJBy7giprm0qFkJXLGirowP56J5jBKaZOdC7yjU35blbgZLIsSLhwZiabAmZH8KBoMjlvhXsEQGuqCjWsYKQ8jHCY8DDRSyuX3ZMlQeRCUwol2jTQvrxGnBaMSazjv58sVZLHE6eGN9zL8GE41lmUsKF5HOMJsBIiUyDQOm1eJH9GX/A0k/CzdbZuAcC
 0Sg+Zd+U
 S1MKo/eDU5x+tzJlp7WOuPHkPFvfaEtIz0FeKpo+HRZ2uHzMLDViPHB8mFd3bF8Ogad8KTH66mugYPDBBg64v8fooEnJ8vMMA2doZq6gAKiaq2dvffJA9lMWy5HOliQIXh+IF4dn3PTYTBRGpgPpUoqnbKZvB4pEd3h5Wg33pKS/yvY9TmUDavYA8UIxNU1HzV8uafmaOMfq5WPVXWEMe3tejQe8Nr1QYJlPGxzARURDyiBdVGh1J73oUf2xpm12A3Al6PLO/eLHjfSIy+cPqJDsr0Hr3u2a+0V1l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 1:31=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2025-11-25 11:58 AM, Pasha Tatashin wrote:
> >
> > Pasha Tatashin (12):
> >   liveupdate: luo_core: Live Update Orchestrato,
> >   liveupdate: luo_core: integrate with KHO
> >   kexec: call liveupdate_reboot() before kexec
> >   liveupdate: luo_session: add sessions support
> >   liveupdate: luo_core: add user interface
> >   liveupdate: luo_file: implement file systems callbacks
> >   liveupdate: luo_session: Add ioctls for file preservation
> >   docs: add luo documentation
> >   MAINTAINERS: add liveupdate entry
> >   selftests/liveupdate: Add userspace API selftests
> >   selftests/liveupdate: Add simple kexec-based selftest for LUO
> >   selftests/liveupdate: Add kexec test for multiple and empty sessions
> >
> > Pratyush Yadav (6):
> >   mm: shmem: use SHMEM_F_* flags instead of VM_* flags
> >   mm: shmem: allow freezing inode mapping
> >   mm: shmem: export some functions to internal.h
> >   liveupdate: luo_file: add private argument to store runtime state
> >   mm: memfd_luo: allow preserving memfd
> >   docs: add documentation for memfd preservation via LUO
>
> I ran all the new selftests, including those that require kexec on an
> Intel EMR server, and all tests passed.
>
> Tested-by: David Matlack <dmatlack@google.com>

Great, thank you David!

Pasha

