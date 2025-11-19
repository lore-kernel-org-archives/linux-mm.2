Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F1ACF2564
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 03:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14DD36B0028; Tue, 18 Nov 2025 22:03:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FE986B0098; Tue, 18 Nov 2025 22:03:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013726B0099; Tue, 18 Nov 2025 22:03:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4A436B0028
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 22:03:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 396811402E1
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:03:45 +0000 (UTC)
X-FDA: 84125861610.27.E2AF4E2
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3C2FCC000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:03:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KkFRBYiZ;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763521423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLVQ9fpSMwb+/1OgxzSqM9eSJCO8OgdCf7gGWf7HfaQ=;
	b=qZX+HMO18Mm7l003Q1CX7ax9D11Jl9Y006P1Hlbr5OhUggU+8LyW2Y25k5OFuKm5OSK6HJ
	pIkoNeil9mFCWkXq0PrictA4zk531haSMF7ikBW+p502Frcx3iUU901EeI4zY7kW2vSQOK
	p4wBDkxZgZOf1RjQG7Isnp1hbrkuZ38=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763521423; a=rsa-sha256;
	cv=none;
	b=QUjp5UhOgcBUwUo582x+B3cD+Xv9z7QkhidVAwFiFYdRsdmwG2D74bcDRVBxAKN5MlTk9f
	uk65xqM0jRw1vvnY5IbRiFKFFW3QGw+rbXwCXYTkKsCagRh+7mgYS6nzkor65BKJ7i+2g9
	vQA5Jp71GCXBj1iVN44KMTtzAozRAi4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KkFRBYiZ;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5959d9a8eceso601316e87.3
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763521421; x=1764126221; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iLVQ9fpSMwb+/1OgxzSqM9eSJCO8OgdCf7gGWf7HfaQ=;
        b=KkFRBYiZOcAQaVCthyz6RPa1DGZMBlTYhWC5byKXXTKFt7BaYusDFaRRfg+Gvh0i11
         oV8Mh1UcaS/oCAonma59bma4UIq7FumvA5qXV+4rddKDxsRq4qLL2jftbKSuoT+R3r2N
         UdRT9yB2wI4TKJViaQTzSo7DGy+DB9Mq77I+WcpUGuT6HwjwW/mcHWY7PKrC10LrvBFS
         xppeMk1+xkjEAnI+woTfDQ9rtkXg+/Xa+pjFpua5YXndONdOq79zLAQ4fCBQB9zV+yIQ
         Ogfw+OMBp2BO0BLYqU/GF9vc83LYNzFQtAuBno1yd/zM6tQaRGikQ3S8pHZh+0KAzepn
         wEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763521421; x=1764126221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iLVQ9fpSMwb+/1OgxzSqM9eSJCO8OgdCf7gGWf7HfaQ=;
        b=BLMwgKOyVbT1yVrV1gLdrNsDFkzWGRvCCPtu3THmukdLuRU5/bzvYd/Kdlr01dnfDi
         OC0a9Kd/3nze287PmAGh9P40PRq9RVwoarAKXQSGCsHZUe7scJJWefPZXrkyQL2rKAF3
         Yqm11oU0F/igvZAdUO3wvddRcgJaJMsr8EMFIPaDFpcoTrtEgS6mIVNLxXakoomr+p7S
         6QTLqyosibyUSpRgwUC+QGETy+SNTHyQCaS6MzZRqAXeBythHxhq5Zrig5kf4wQht3TS
         ATycYeQAx26Et2auMvWyCdtkWupMBQ0xpaSbNvjGmZIn2qeezExDaYg3pxPb0grPQoL9
         lRog==
X-Forwarded-Encrypted: i=1; AJvYcCVievQNKaDuwQqgiylhi+IOVoc4qMFakQD1hRv2xZ49gTOhypFsVuqzU772JRWTj01vYHxBC1dy4g==@kvack.org
X-Gm-Message-State: AOJu0YxwkJBr8D68ZBIOy3eAckgFQqiq2rl0yNTw8SrDzo2aNcdGSKhE
	q/fCg7nfPzD0S1nJoaBhtzKu062A2CPBcv+2hcfYWhmLaYLjtLJSzHeVY8XEEPGlhwbOMyN9Nxs
	ywrCdq+HYlRAXi92To9hQj16xZQ61XXG/orE6tT1k/A==
X-Gm-Gg: ASbGncvCkONlaSXXrE6NRsMAY7vcelnCAdthaWG6PSzvwgFWm/IPLxLVFjKU2N9Hvdy
	VAGPslfn6zVBtDAy9mPMRTH0icyHIk2uqW4ZyG6Nrvon7d8UDtJiKfs2hiaV2xTv1QJVvhnRqpt
	2LVaMXF9tCenXKlsdpSGMDyjwNeHR7Tgvi6fpK0gJX/CsDVi2MDfhf+hljDxhVg9bjbVZ1CnY3m
	QKUjR9XjeYlkoluZOpT5gfiHXrVn1KOgX8cYCzGUCVGasGYx+5Dum3w1nyHVkbGZz9n
X-Google-Smtp-Source: AGHT+IF6jFUgyWxnWzJx/waEh+e8ZZZcrBjexbTkHm8gmlq1XM1TXAgMYp45D6MyYvw+W6OQW+owK+2k/XNdPzJADA8=
X-Received: by 2002:a05:6512:239a:b0:594:3d20:f021 with SMTP id
 2adb3069b0e04-595841e10e3mr6573440e87.3.1763521421110; Tue, 18 Nov 2025
 19:03:41 -0800 (PST)
MIME-Version: 1.0
References: <aRuODFfqP-qsxa-j@kernel.org> <CA+CK2bAEdNE0Rs1i7GdHz8Q3DK9Npozm8sRL8Epa+o50NOMY7A@mail.gmail.com>
 <aRxWvsdv1dQz8oZ4@kernel.org> <20251118140300.GK10864@nvidia.com>
 <aRyLbB8yoQwUJ3dh@kernel.org> <CA+CK2bBFtG3LWmCtLs-5vfS8FYm_r24v=jJra9gOGPKKcs=55g@mail.gmail.com>
 <20251118153631.GB90703@nvidia.com> <CA+CK2bC6sZe1qYd4=KjqDY-eUb95RBPK-Us+-PZbvkrVsvS5Cw@mail.gmail.com>
 <20251118161526.GD90703@nvidia.com> <CA+CK2bCguutAdsXETdDSEPCPT_=OQupgyTfGKQuxi924mOfhTQ@mail.gmail.com>
 <20251118232517.GD120075@nvidia.com>
In-Reply-To: <20251118232517.GD120075@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 22:03:03 -0500
X-Gm-Features: AWmQ_bkhtJuHwb_aYM1P0vArDeVsoqrPaefrD9sFZo9CLgQiJu240K99k3Hl7qU
Message-ID: <CA+CK2bCtJD-FGtmCOfz8arUGqO6hFkxWcjG-wHz_S1Abt7rXEw@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3C2FCC000F
X-Stat-Signature: xs3rna5yfuiefxxu335w8kjtpkfk98fk
X-Rspam-User: 
X-HE-Tag: 1763521422-185439
X-HE-Meta: U2FsdGVkX1+/80Pv5RuPXDOsPcHvin/OMhCogXuHheilKnjKX5Q+a3NVYzgrPSluPFyFexqzdgwySCC/fjUeGi1G8GeeP4tZldbMsLyvrcBMPHDeaWHNy9mkU2eDP+Qdc5D4e3zOSUZghpkQFS4+chwb/00aI1OPUXBIu5HLoYu+HqGF2GP/OcDrv9WtxDvEw/M3d63tCVKhAaoSmMokQf5wkEWik7N+Mhxauub3ZWCS0mrvrV5cZFZqbPJ7OAkje142hr7MCm/IXxj9ht6145PFDjZX0w0GrlDr57j18WQ4TEymUSAM5L54s9vz+nH/KmRDGUsSfS6g8qh5ocwWu0hQcOOqxwReXKlZKgU/3FuT+o/IivtTs8FwrzPrzX/v7Y5cQoIBoEhoSHnIFV6DXw/ve538VkXcx4KgCBOAwFU3d6Iiq4ol75wVW2auQwNu3fni7TwNhfqvUrORZ0syDIpxnDeodygIvQGLNnArJex3va31v2P/V4goi7k3Oq8ajD/DpuH3xZRbMa9al2tWzw6tWd28vdvQYNq0lNpKL7hijYY6/xTuOiRAV8JtHjsrihdX7ksaheUdPmXQ4QJlc5ApYifYCfQt4toL3nzQ4w1HDBLNEgf+EFX/trCOPrXrFHrw/XrzDosaXSrRUts+lw3Vm0D4EhnPQFVwGPC2DlAOL2Rqrvud/WP7eulRwPBC9ZwEnxFm1pDoVbqmb02YboDy/BlPslm7jFMIi+3vOlGDWB26TtswqO7PXXagPomXxqOv5iWtW2SQqtIuLCfJZ5YW9OHRAFM+xUCWxkfind0+G3SPj7I7C/2eCVRGO+qQLRVEmGnuLyzuSAGw5EpMRM6qckfbzxLvZtwk9oZb3BALYordE9LIP/GROs65yU/PFtG0OWWzcGs2PqY5dEp8EmxuTqGuTzo7ow2i1tIxyKvsEb2UfI0feB8r6Ybhf+nBZ3MpUjyxUBxAeiCbgtM
 gs/x4r4c
 muQgjNHgRUk1VnBA37ku5/pnuA1hynLjCqkDj3cWypM3QEGxb1nene3ETGiD3SQGhO1u27sMXXVBuhIkhpa5jKl+17KpSshHpj69gLQiq0LEe73cB8lOLRz+gg8leSihQTUGPRftneWMUkpE3fkgzYbUopHrU/mG9fJE7ApN9GS53Tw76STn9697aEDLEF+oFOWFiibjpByJJ2z/ECAo4AeN8pZxQ7lvpZqRb+1/U57dLUTpNsDgMwDo0013B7r6KbXOndzQDUdNgXUhkFW6Ux/OgbiG9OpxF0ofme6rEapS6Ap4v+yXDioyTrBSp6XXR3KNfzwcnBAIoikA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 6:25=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Nov 18, 2025 at 05:07:15PM -0500, Pasha Tatashin wrote:
>
> > In this case, we cannot even rely on having "safe" memory, i.e. this
> > scratch only boot to preserve dmesg/core etc, this is unfortunate. Is
> > there a way to avoid defaulting to identify mode when we are booting
> > into the "maintenance" mode?
>
> Maybe one could be created?
>
> It's tricky though because you also really want to block drivers from
> using the iommu if you don't know they are quieted and you can't do
> that without parsing the KHO data, which you can't do because it
> doesn't understand it..
>
> IDK, I think the "maintenance" mode is something that is probably best
> effort and shouldn't be relied on. It will work if the iommu data is
> restored or other lucky conditions hit, so it is not useless, but it
> is certainly not robust or guaranteed.

Right, even kdump has always been best-effort; many types of crashes
do not make it to the crash kernel.

> You are better to squirt a panic message out of the serial port and

For early boot LUO mismatches, or if FLB data is inaccessible for any
reason, devices might go rogue, so triggering a panic during boot is
appropriate.

However, session and file data structures are deserialized later, when
/dev/liveupdate is first opened by userspace. If deserialization fails
at that stage, I think we should simply fail the open(/dev/liveupdate)
call with an error such as -EIO.

Pasha

