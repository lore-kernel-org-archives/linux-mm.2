Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E10CCCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8EC8E001A; Mon, 17 Nov 2025 13:30:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289C78E0002; Mon, 17 Nov 2025 13:30:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0158E001A; Mon, 17 Nov 2025 13:30:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 07BDC8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:30:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5CDF12B656
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:30:28 +0000 (UTC)
X-FDA: 84120939336.07.F4B5A0B
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id AF1C5180002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:30:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HDW+9SFR;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763404226; a=rsa-sha256;
	cv=none;
	b=v1oXIIe7j13gxzhWq0l+0o7BpKMf0R84LqUW/5gtf9v2SejLqDAPM3yl0In/ZZHDC17Rva
	Azjr0fYjfT0Z7WZCy3CUTzhT8FR7vA9E1D5e07dn72sSzmrAbcPAtWaJ0IiIvD58uIn2Hd
	AId6vGajVv6qE0A/AP1QEX7sX8rEQHA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HDW+9SFR;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763404226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mo7Fpew4SCWgreWKkBa60zvQOZX9oGrQ6m1RkCiDUC0=;
	b=2vLy5pzzGe6LT6kLYTtzBg/FCozoJ08ywlIS+XB+fl+jKiuZm+0aZycLaW5LqGYxNg6l+G
	fHTj0pkpRSzmb7T07Yr+j8N3+5fAS8xYD3KaI4gdg6tNZQcPUbWYuTH/qzEwlCqR7MPBVi
	36QTqkHa5aFLgikg+4vtzgkRCjBJCeE=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so7010139a12.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763404225; x=1764009025; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mo7Fpew4SCWgreWKkBa60zvQOZX9oGrQ6m1RkCiDUC0=;
        b=HDW+9SFR9U3dDY3BNfXJq4O5jmuEAA69OWKm53vb8RpILBLDg0ubIPssag7hxZKH29
         FUxiIKHVx+c+gY6pMAjgem3DdENHphx9JRwfWdtQFENfwxWSun7ZgguXUTT0/ppIZSIr
         Mj3PojzMkDjBXVY3/N5PCEdYC7Ds3kwCAVuE/LUPoa4ZAjdbQwb2kh81DtjTHZwui5zL
         KPQAnIjNNL+2OSpywhUOrWZz5MFJ8qAmrDOuRlUovwV9BjPBzOHPxKYSCatxdJSyAJjC
         pAuTjoMgvGeQpX3XF9VbWbBIalIM7MGtOs06J4TiJf42NVYToHidphfiRpB22vVF//bR
         mSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763404225; x=1764009025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mo7Fpew4SCWgreWKkBa60zvQOZX9oGrQ6m1RkCiDUC0=;
        b=VCIzDyJvAi0DDxQnfYewDTDevDCUoNJXQq1Thcd2Og9qhlLMBaiHFXyD0FnHp/ypZY
         IU5v3pTS2q0NU1uIBlEvfh7qfs6Li6pIY3xThk82vqPcrJ+pBdOUDfMaIQvK3qrU5UI+
         GXz6G83vKoy0HwVjELDRr+c9Jz9mL499f+3yS5895OziFXhiQSy1dYQJXLQiAxkcKD1B
         31a6KQ68lBvo0ZnU5jyzlImW5C7IOcRYwAmPxbP02jcWCxSIQpBVydfys522nLuJ4wxy
         dEl93RraTTtPJFtjyc5avMlY8fElFASwEn5F6i5lE3+16rqrtan/0TBdKYusdMXg5fJF
         ac1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXxVfBGhEHBcris50/Rz62YbXW+wBF1RRGPn0DYEnmHcJq/BZp97Z+2/YVvfQ44XxLkZE40kzMx8Q==@kvack.org
X-Gm-Message-State: AOJu0YzhrsYuHv3p5m4LYvdGkssGDuhBHB8rdRiJFGxdZMUfTeRujbB1
	wTShluidZTvJU357dsTb0bLZEQIfXbiQpUPLXwfQ5+bCLW4jw2YKPXVYjPeCH8p4NIRCsN6VI0N
	zrx2Kwo5Uw9GK28+pLAFOafY2MOQtIs/Gv0WPKn0/yA==
X-Gm-Gg: ASbGnctHSQ0wvJ1xDVsQv0ZZpld/1jNZ9qHqfCC7QUDt9+3WC6TH7DWk4eeN0+I3yjZ
	d/RfRdzGkr/+ugvrPbrJ9PKhT93WtlZC+gvTATaNenn2+Ruhqixm1C650PAzeP1OY1EFHftxKq6
	2gOz+7i8aiD6ThhJf26/VWjUX/uOZxHWb0JiPA5XNV3Pl/uXxB39wSHBL/Mk4nTQSe9DO1Ciu/e
	IgRgsFVUbG7S8VX5HZyKmcJ+I3m5S6ledpCEVNtYhhcOWj17qTIym3I8kB+ll6+G6OE
X-Google-Smtp-Source: AGHT+IGbft8Z+rAKPet8Z4NE8LDyUX4MgwKnPbmIzDODsbkkevdfT0+fNvskHAAOPS9NtBXhUCGNpo/Yz/tzbQHQBNw=
X-Received: by 2002:a05:6402:27c8:b0:641:8b4d:cc6f with SMTP id
 4fb4d7f45d1cf-64350e899b0mr11672843a12.23.1763404225103; Mon, 17 Nov 2025
 10:30:25 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-3-pasha.tatashin@soleen.com> <aRnG8wDSSAtkEI_z@kernel.org>
 <CA+CK2bDu2FdzyotSwBpGwQtiisv=3f6gC7DzOpebPCxmmpwMYw@mail.gmail.com> <aRoi-Pb8jnjaZp0X@kernel.org>
In-Reply-To: <aRoi-Pb8jnjaZp0X@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 13:29:47 -0500
X-Gm-Features: AWmQ_bmhhbDUMBKFxNnFMOPCeOApSAwekkwuL9HuN6ynW1cSRitKeGbWllXoez0
Message-ID: <CA+CK2bBEs2nr0TmsaV18S-xJTULkobYgv0sU9=RCdReiS0CbPQ@mail.gmail.com>
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
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
X-Rspamd-Queue-Id: AF1C5180002
X-Rspamd-Server: rspam07
X-Stat-Signature: dnf18qfj7gh6my8u6y66e1q3pddk8117
X-Rspam-User: 
X-HE-Tag: 1763404226-700060
X-HE-Meta: U2FsdGVkX19KLdp5MtwJImg9pq3i0W2xr6l4xQFQcfjldLgNOOJ3q1BDGmrok5x5Hdf6SaB3sMmyCMq99ap1xFAfJR+9b2lXXMiODLqJ8tT6+GF0n7ipGb4kBUSThoHLH/zOWGmYAymNwGA/dearhNwmFJWeDnrgLsXzwsNTHQlS40XAy2XfzdBTQBAtRPc4LlI3xPpiiIPmreXy8PizEjxZrjnqJEsHRSMTaOem2GHA2BOD7cETWlnUJ2FFNC4L9k6D/6nft6CugtRDj12RNEZPDy99IQ1gxSu9wyakr0+EypnEDtGL0u9wYfgBjKUaLy61OwX9LNjlYHJpIRUWcmGPF88Vq3dIV5aNC6cuiykyuGQ3A7nhDyvNY9y6GVlkkMZDfmWC7kC8vnks4/glSTLMKYFZsbgbgj2XeZD43q+M/E8op4ThtjeDKI69cCxX3hr+aQ5oaMRe1kNLpshmlsEBxmiMXI/b5HeS1nFakvzFDAt1vaYtRYUB2qw4vMq4Z8kYd5ZaQImlcvA2pkd3ecNPoBKT1F3f71ldu/ZcRZCC7eGynOXtaH6zedfCXu9XIM8SKpXZifxHlChM1mIq03YKSUKQZI+y7MVYV3Kcsa5SHggxNTedyBR79lPHyiX/HrPHt002x/UavqY5YxjwY9XOKKN0bujbgV/dhv1DJuuOTh3CBIDbMrpx7JDuv2qJ/8OroCJP0tE/10yBS8Olq/GV7t81NRAp6snb5vQC6O5aBNcVLJtvGp7Dtmv+3ZP9eF81k6E3PJlwwLcoSd9BlJSI50RrYiF/444GL9fBHokhaQEBomBWhbpRHogDzgkaqytXppH47qsSgLu8RmgePwOduSRkVKVIEUGyR8tV7LI1u6aN1hURZzmoNMPtZ3QFtOqvVuMfi7zjXj8f7xj2TGWMv23KgYWH9/s8jNnrAgnoda3hEkuyiBbsRHSt+/VKnNad59idEh/WiRX8Brp
 MSxqWvbo
 1p17WtB6QB0UHKDEOoLVkbN6RXODKqCjOWtUoi/V4S81E/n6I8eDTkTYRtnv7BtKQy4NhxkH6rwFg+hzxH/gTiCvH8/t2SKw2vYg7rdGE7/lmCsfuSRHhNulQfzdWaagGtO9k73onC69yEFWlaFQmkFWdxtaIxeAkeMo5yg0TRALlTZ0/tLj1ajvi2rf1F+88pCcutpKNZFduwCYKkKn1wqxaZtj5vHKyjzyBOG2/bdQfL/GegQpjzlD3Y5GGDsacgcNDG5QPhV4OxIL4Kq2KC0EdHudxIBzN6rVTj4A7mQVwJp7oJxUp1dSC1yJPWlGzOjrtgEZv9pSdEBABHHFe5xEehC6gykuYU9yIkRFu2b9XmYJz/OzzjQ1ZoTZP+TP3QCB1/X3o8mIl4Zs+QRQTHqEwegXmpUAAxopREkGGwg5xGYbGPiE4rWZOhZ0MoOgwNaCMWmpq90KyZbg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 2:16=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sun, Nov 16, 2025 at 09:55:30AM -0500, Pasha Tatashin wrote:
> > On Sun, Nov 16, 2025 at 7:43=E2=80=AFAM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > > +static int __init liveupdate_early_init(void)
> > > > +{
> > > > +     int err;
> > > > +
> > > > +     err =3D luo_early_startup();
> > > > +     if (err) {
> > > > +             pr_err("The incoming tree failed to initialize proper=
ly [%pe], disabling live update\n",
> > > > +                    ERR_PTR(err));
> > >
> > > How do we report this to the userspace?
> > > I think the decision what to do in this case belongs there. Even if i=
t's
> > > down to choosing between plain kexec and full reboot, it's still a po=
licy
> > > that should be implemented in userspace.
> >
> > I agree that policy belongs in userspace, and that is how we designed
> > it. In this specific failure case (ABI mismatch or corrupt FDT), the
> > preserved state is unrecoverable by the kernel. We cannot parse the
> > incoming data, so we cannot offer it to userspace.
> >
> > We report this state by not registering the /dev/liveupdate device.
> > When the userspace agent attempts to initialize, it receives ENOENT.
> > At that point, the agent exercises its policy:
> >
> > - Check dmesg for the specific error and report the failure to the
> > fleet control plane.
>
> Hmm, this is not nice. I think we still should register /dev/liveupdate a=
nd
> let userspace discover this error via /dev/liveupdate ABIs.

Not registering the device is the correct approach here for two reasons:

1. This follows the standard Linux driver pattern. If a driver fails
to initialize its underlying resources (hardware, firmware, or in this
case, the incoming FDT), it does not register a character device.
2. Registering a "zombie" device that exists solely to return errors
adds significant complexity. We would need to introduce a specific
"broken" state to the state machine and add checks to IOCTLs to reject
commands with a specific error code.

Pasha

