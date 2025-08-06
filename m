Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163AAC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 22:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB056B0093; Wed,  6 Aug 2025 18:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C136B0095; Wed,  6 Aug 2025 18:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84AC76B0096; Wed,  6 Aug 2025 18:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 760966B0093
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:28:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CB011DCEE3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:28:40 +0000 (UTC)
X-FDA: 83747773200.09.955DB40
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 59DC2180006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:28:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fhkaVf1P;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754519318; a=rsa-sha256;
	cv=none;
	b=t0w2Otkr29Na9DexApKLq4BESoJ+847d4N4NFSs4Vs8Ku0fgnJd2A7bB3eH4VwHlCsLyzV
	VxdQ0qB2vUvqxHzSpGoZxYo5I52iG6Te6zins4EzpY+DeXJqyoFk3/GoGFhdImpY0YDuGT
	3HV1AksRwD28PuyGhlB+Y+UMbek+Sz4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fhkaVf1P;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754519318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhQ142AcHuDpEckqO7rgr+eVAp4QNMkO6ZcybFE1pag=;
	b=ctTE0QXufM39HuaI6ZvG+q9qFCV2NVogtj0hOW20r9UAiN+XEfmBNrt/gwhz+0lsucdiLR
	5sMhsyNgmGO0r1iPuQpyONWKYHhM+WN++Kb5IXmCvdkX2n5t2dso6V84+W8C18hV/9n+9z
	e1go7B1E/hVROuwPcUuVSm65++4kfZk=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b0619a353dso3425561cf.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 15:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754519317; x=1755124117; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xhQ142AcHuDpEckqO7rgr+eVAp4QNMkO6ZcybFE1pag=;
        b=fhkaVf1P8e3kfcfTNFA709/4SEB66f8JjeYmxN1vU/JwYI/SuLio9Xg09FTPaeLnCJ
         7/9f9n6LZgGQLLRElskXpAp8SIZLjcFNj/+SGmTHmadTrsM+sPpwKbHQ1SlXILYmYBLo
         xGZju/3lhRcCqpqfruutYOMMv3HXBqsxNc6fHTzi6dvfplsk+AOnE4cJs//EODZ36mox
         Buqdoo6Q4/iG4X2ypPPZz2Bd8UEiE28O0CTX1QxBCD5j1FwOSxG2QwOD+zKsUHtaft7d
         /VJ3/BhmnaDYYZehCxLtWdcxLMb1HK1IIZikyAVhMEZXJ4sQSFGmv34syTPyZtmkq3bo
         nw9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754519317; x=1755124117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xhQ142AcHuDpEckqO7rgr+eVAp4QNMkO6ZcybFE1pag=;
        b=DdX31JeMoQSeihksFdJUhCzl4VVNKxi3+KUpVKtbn2uWoqNd2ZjqF0RJPz7yAWSo/a
         xu7myKOQYAnAAwX6sgoyrRtLr9vMaciofMkSvaGhgXQEBMPtY8cznDnG7Z0bG4fbR1y3
         EdkHnnYo7wZB9SVt4Ebi1aVnnoRl3oXOcR3TaUqOQp1ELnVygV2PHWepp+GuDkp5uFhk
         juMIUQbITZqbzqmt4kpGk/QFA/nVOEEEFfg0IhTFY17DUtFfExkBuTZIawjAH0yb/61H
         lD5HjyJmuYFeTLb4G6KmdOcNqdTGhc9ictGrtP35/O5qqfq0q2vieMy5kzhZKirk5BEj
         jT6w==
X-Forwarded-Encrypted: i=1; AJvYcCVMfWxeLn2d+i+KAUPgBXo6WInDLF9lVkpPa6MVcjLDbwYbXO4FLZm7/PQnfMXShGZpLvK3gf7BIg==@kvack.org
X-Gm-Message-State: AOJu0YyawyyqWpF0EioZ8dv7WFfAyaAgzTara8rgynhGeWHuMrFdbs/S
	Dm9t2+V9n0Nahd4wXaFp3r0jyC3GvXdbVed787PJ/6YfMu5YO/35Z+56vXRVrWA8rlG9aAyvrI4
	zVUxepzdhivj0zQmNveIjNw0kKW4KHts+5Iqh66Pj0g==
X-Gm-Gg: ASbGnctgvnppmXdUp+9h+kQ1fNc3JeBjvPyMg50tjRJPu8OACHzCVhqxx8XkmwgdmpA
	+1+hTWUSXyMJZo5L8z4Xt3Kiig7IyZgQOJjs2A28T3n2HRFlQJnT58oDH26iNkoHLJkMUtkNcnY
	CRUaUpsK7HB3sXC08WvDI5hM3rcrZVgo9VNQ1SdnTCd1APaQYXa0n1PxkwgAOz0HHuFaayGdKZo
	TV5
X-Google-Smtp-Source: AGHT+IGj0vOgYMp9T/0JmW5XllWs9eR8q77wvB4/2/eB5UfznGaAzPWexivE55P3uc74jC/GyDuncjth4cnA3wVQmDo=
X-Received: by 2002:ac8:5889:0:b0:4b0:695d:9ad0 with SMTP id
 d75a77b69052e-4b0924e0f3emr47887021cf.3.1754519317270; Wed, 06 Aug 2025
 15:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-11-pasha.tatashin@soleen.com> <20250729172812.GP36037@nvidia.com>
 <CA+CK2bCrfVef_sFWCQpdwe9N_go8F_pU4O-w+XBJZ6yEuXRj9g@mail.gmail.com> <20250805123103.GH184255@nvidia.com>
In-Reply-To: <20250805123103.GH184255@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 6 Aug 2025 22:28:00 +0000
X-Gm-Features: Ac12FXzz6aElzLLHqZjWxK5H3LOARobpBSmk1rsUp_q_uPWZt7Z5vxl_KzsDWdA
Message-ID: <CA+CK2bCeaH_Lesyr1G-Ur0eDb9HgKqOYgTu=vk=wrpZExMrWuA@mail.gmail.com>
Subject: Re: [PATCH v2 10/32] liveupdate: luo_core: Live Update Orchestrator
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
X-Stat-Signature: w4setmd8wqbt1tu71ssk1ooj351cgwic
X-Rspam-User: 
X-Rspamd-Queue-Id: 59DC2180006
X-Rspamd-Server: rspam02
X-HE-Tag: 1754519318-405676
X-HE-Meta: U2FsdGVkX1/6N7Rj05vJOrPYcgtS6KYYOmQMznUhpuEyt66mGoW6aIGd1oXnIH3SMsuFBwG3zGbE6GEPNlF/HylAn3r+RJh5g9HGKnfK7M5rVjoPHrUAIFMuE98dEx3V2TRPZQn+5eGU4V6LguccQcsEHsO7X0yGROcASLoffOTmxdllkqMy3EkkFPigYT45SPgdNkkRH+vvninyHYoZAb12wo+GcXp5uFSgLPa2m29ue7ZGmr2vjyMdHUQN8nL5GH0gbdQYCWCtFX+7SA0qT7K04sIas8Hd3h2oFBNKyrgmkx/520cyuKYaUkEIGkym2SnQVhlrDctjHg69lhOE2n5Q8uf9JDPGhOdsujh1fyGkmdSP9NhTCRke7rY3aU0grJJmobYCfjPdGV14QwMvWn9YAA1pWnJd8bz7GF4HDAzX6snVheQb0Go91xey5sxlRiatB5FkjUtZGaRWVVljxanRfcOUfe2iZlA0RRWK4jBeiHrj+2/YtIvzY5Eh7sbVatxsYrXxtBVvB0fUDyK9s92HzXFx+BNyw1gzdqnR6dobLY/K3G0gVj7JmiA+GU/kFF8WVhbo1w3puYLqRtoW4rWTGQhqbt3rvi2CG54y6TRLYyjhMBKH+1zM8WyhrzEwFFjzKf9vytkIA8H7QkiO2F9uDVZth9MKDK6bJmdX1wkTsTREvRpm5hjKw2Wa1yI9IDDXA6i3S2uuMapcLIki09jO7Z5RDSRcCPURKqJNrq3yn2Qw99DhT/+AnkQVO0O606P8txYRFOR2nSC1dh5dn5UJHe2IsbE9Zl2ggQZx+CCRqWi9gqS+0F1quyWRommUhc/T2LlmQ0rzjJCnVLFheV8jJEivh82cTeBiquO3pVc0wT5RcgI05o36IefiSKBu9IeyXBWqgLPFa5zo1ie6TQwAO+QNbye3KVxXwtKAyheoqHs/x6C2Flj1vC7lJ9GirC8rRZTPPuY1Z8WypXi
 nNyv+YAj
 Aq7yoGsFFUetKifxD/TnQaSA8dyeij06yOwyqFB5ON9R/KVq0lQj2KS/bJY/8/RzEBFBWqsIgDIeZiXMuyhku102CvRUtmfyn/E+TyBDO8Hw73jGctXz+WuF/kpzss1ShVq6MsjgvVn4fvcHvwQAP5HyRbsTpp9K/o9FE/72F4JFp/JoKYuyctX3j1qeXCzfYLRmoufDtV7Vcu8GRzvxxBSyzGWYAgLRcDPdy7xLzml8FmOiSIWMuK+MklMWZxl6Ox1CnhwZW3/GsGl6mvn67dvRLlIRmMgAR7T06k9DeRkWs9FRPwIsG4TGMD6rDTJLlYXlSynJbjETWAfU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 12:31=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Sun, Aug 03, 2025 at 09:11:20PM -0400, Pasha Tatashin wrote:
>
> > Having a global state is necessary for performance optimizations. This
> > is similar to why we export the state to userspace via sysfs: it
> > allows other subsystems to behave differently during a
> > performance-optimized live update versus a normal boot.
>
> > For example, in our code base we have a driver that doesn't
> > participate in the live update itself (it has no state to preserve).
> > However, during boot, it checks this global state. If it's a live
> > update boot, the driver skips certain steps, like loading firmware, to
> > accelerate the overall boot time.
>
> TBH, I'm against this. Give the driver a 0 byte state if it wants to
> behave differently during live update. We should not be making
> implicit things like this.
>
> Plus the usual complaining about building core kernel infrastructure
> around weird out of tree drivers.
>
> If userspace wants a device to participate in live update, even just
> "optimizations", then it has to opt in.
>
> Frankly, this driver has no idea what the prior kernel did, and by
> "optimizing" I think you are actually assuming that the prior kernel
> had it bound to a normal kernel driver that left it in some
> predictable configuration.

Fair enough, that subsystem / driver should simply participate in the
live update process normally.

> Vs say bound to VFIO and completely messed up.
>
> So this should be represented by a LUO serialization that says "the
> prior kernel left this device in well defined state X" even if it
> takes 0 bytes to describe that state.
>
> So no globals, there should be a way for a driver to tell if it is
> participating in LUO, but not some global 'is luo' boot fla.g
>
> > > +       ret =3D liveupdate_register_subsystem(&luo_file_subsys);
> > > +       if (ret) {
> > > +               pr_warn("Failed to register luo_file subsystem [%d]\n=
", ret);
> > > +               return ret;
> > > +       }
> > > +
> > > +       if (liveupdate_state_updated()) {
> > >
> > > Thats going to be a standard pattern - I would expect that
> > > liveupdate_register_subsystem() would do the check for updated and
> > > then arrange to call back something like
> > > liveupdate_subsystem.ops.post_update()

I added another callback liveupdate_subsystem.ops.post_update(), which
gets called on live update, just when a subsystem registers with LUO,
because that is when we know that it is ready. I will send the new
patch version soon.

Thank you,
Pasha

