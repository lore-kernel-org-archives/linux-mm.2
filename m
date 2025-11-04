Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE73DCCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 17:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 063818E000B; Tue,  4 Nov 2025 12:33:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F788E0002; Tue,  4 Nov 2025 12:33:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F958E000B; Tue,  4 Nov 2025 12:33:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD43B8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:33:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A1DA140628
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 17:33:31 +0000 (UTC)
X-FDA: 84073621422.20.B55E2E7
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 38FD440009
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 17:33:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=D5q1tpOl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762277609; a=rsa-sha256;
	cv=none;
	b=yueVYvbfZf5URScVzpbrprHfJ8XRReVA/w8PM6gyr6MVhOZRZJMiyHjzI7N+Q3Zd2J9bdY
	xpu5jmt6WRNWDkYtNbHxTZRMB56aC5seNh0/i2iFxbPDzHYLlOeaxiyVftiq2IKMCJDNRq
	3GOPsgZMZ4yPGGWWlYUF2+H+YSBM5mE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=D5q1tpOl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762277609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTfDTquCk48dkTU3Tq45eZhigns6jK7aZyvpfJOfrnA=;
	b=lvgKkvF0l51hOVARxQsHSdLMvxM6lU5PJibUZF9GnzkASn4+1+pQtX2jGG+1meBgI9SPt/
	q/Cn4WIIsuCFvbKKDlTiB7NPilyeto1DB8lyll10/aHV/PIyIkZFXw19a09zmqcmQuHlnw
	H0wJU3FnaIHEeZhf426rK1AP/E3ieMw=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so7666027a12.2
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 09:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762277607; x=1762882407; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTfDTquCk48dkTU3Tq45eZhigns6jK7aZyvpfJOfrnA=;
        b=D5q1tpOl+4sElNriPEv7vWpZbPfWdtPXP+/6hq5W1mk4ZN/r4mzCYSYLLNOyVIspWc
         LK6ASj8nVjOnhSfqJ4D8x2LUuP3A1xSAFsU80leIozoCXVhZpt2LyKNKLuHf3NZw1FxO
         C2RS1Qjgt//slID8ADnCEalivJ4t1qKll/fI6vSbP7z6lBuMGOkT6IZEnA6lkA6Wz6yN
         29ZtTU7oa+1GAze1zn43U70MP7UNfT6LkXLIMw8os7ZafTPGZCwB0eNMao4NmvRNZrr5
         7gxk6eMhH+FZGZpIwbpa7Ew4TQpi3kDiypc8F0tEZCdIY3gMmrgzYhtnep9QHK8YxVwr
         ma7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762277607; x=1762882407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dTfDTquCk48dkTU3Tq45eZhigns6jK7aZyvpfJOfrnA=;
        b=T/gzycwCzmYs/m3YR4IYsYLlCQ13D67l9KW7gaj0mrvEuAC/7sImt0BtuEwU9Ijod5
         xg/Nsz+KxwqsFBNyc8hOaMT1Jw+Xniu/FqkvXXV9rZ23NCsYprFGnu8w+UZWG056HUke
         YhKp25IiYohBJXltYOZ7m2FTxFj/th8D6plM9XAXMca9NW42OjF2hQcaZDHmuPfBNh8C
         RP5P6Lq4cCySDPG/V8+mCB3YVh82kA+Lof6NbHIEYH5I04CdwjcAbvD7YsNKT2/nM9Yb
         eKd5GbbAUu4L2mzJOA7K6jM+7Q1qUoutuOx5/d69AMIERLhtQI8q7j2vAhHbaBqOKi6V
         BD6w==
X-Forwarded-Encrypted: i=1; AJvYcCVzbUA6spfDkPYWLpuyyr4NZSE4dkoYx30T8BXSRfsEn7E1+lTGJnDVt5x1NSZvi7g1Ys5hxntq/A==@kvack.org
X-Gm-Message-State: AOJu0YwFngm8WkztO4oau4CQpYsD2+CHfjOPalcAPsVOrMn+/Ij5s9CM
	PEhR7F2J3FZ9U98mhflj5NDI7/vRhZU4aIFYfI846pD8ywVhhrrUSR5EZKt4BvAiSUO4WGrEhC9
	QlgrtGro85099IwYyX9ufCv8mHpgH82oOBGex6vRVtA==
X-Gm-Gg: ASbGncuP+4d9jtcpAehnA+g4H9lOtYrytAvABJLfJGDg2H1n2r3YKBwEhpqL8cIHr0e
	YJC8orzEXSKcalgIJEJ/9Z9BoFINuPyK4xIc/Yy0fReozvo1gJBOwvTujjDsu1g6WQjpquT3TZn
	s2+3ySNejZevisHKJtFt1ZpZXq/wUXATqw7pY6O9jRt/umGSrdDdGcrVXLXHpTXQnXC5m44CXGl
	4HHmNDtYVr9rMzNsMYF4TzDH71Alz3PpTj+8UYoO7msib6WA2+RnLBVMEiEPEsG+80Q
X-Google-Smtp-Source: AGHT+IHAtkWxLI4f079UeX9mWGwD7T230+rA0BeumknybAB451rxF/wEunoh94xjXza19vrHmYhvGiuhu0O1dH647iw=
X-Received: by 2002:a05:6402:1447:b0:640:ea21:8bfd with SMTP id
 4fb4d7f45d1cf-64105b7a66amr13762a12.31.1762277607365; Tue, 04 Nov 2025
 09:33:27 -0800 (PST)
MIME-Version: 1.0
References: <202511042251.paO6f5BZ-lkp@intel.com> <aQod7jDFBjw9T-u2@kernel.org>
In-Reply-To: <aQod7jDFBjw9T-u2@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 4 Nov 2025 12:32:50 -0500
X-Gm-Features: AWmQ_blKIkIlMfgAINdWoBAGRXf_NXuynpSKevp0VOCPWGaVDe_zHYFu-h4128E
Message-ID: <CA+CK2bBYF5AndNHgqcb5zDbUOV04nE6xiZ0igcTdYf-GOU4aOQ@mail.gmail.com>
Subject: Re: [linux-next:master 4972/5926] kernel/kexec_handover_debug.c:16:18:
 error: use of undeclared identifier 'kho_scratch_cnt'
To: Mike Rapoport <rppt@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 38FD440009
X-Stat-Signature: 8zpnmwe91ybquh9pgzbieye6ns4mbya1
X-HE-Tag: 1762277608-775183
X-HE-Meta: U2FsdGVkX19Ryfdbzsi7V3ItOPMPVLZ/7dNKoy7KRJGH5DNDMGf5X6wm+YerKbNHlYqKFjeQYu42341Hjeb8nEMWuM2QNfWyM4eUMb3CfwVb4zvQvnqNoYt5hp/dUQejjkw/zbEqyKb9AtG9ulK6EeST48rJ0buuZofaVZ5hBoGCP31ZlVP85jCdld+Y3Q+s7z6A3avz1f5ZNftoI8n66xYq8tO/dw+ZWz/WuuLiWq6EUp7a8XYYVAsUGvVHYtiMXA/4qL4PdLYWPM56+SXMY17YDuF0qJaTyDWseFHv+NIZ0v+DtTg0QqPpr+GxNTnSEu0hwJS/FJdd9OIV+nbUwhswWM2TlMycCHikYXp8zTEpZLONqH5jpkOmAbKOyQE3kWsqlyF0t5EsjUC9t8yMhRuL77ua6DEmwiQCJV6KCorjF5nB3bp1pjc4WuoM9K9gydV9Z9DV7ZZQbMs6h2jthkmjhe7heYre/9ozxRzW4PZAdPKZ0bc8fSJ3cGEdOZb85bueXbngVhDakZU4cG/UpfRqg21odjZdvX+v3bOxDkiqt1ld7USXmfuc2t+e/WXFAwuVNSi4w1xMaSHH+DOyYmrA8eDGtuyMOekUseg+zqJen5ZIiLWp/AL5cMnM6dvm6zXYNDs5aZOqumvFU8E66q5WriVt6r8lWjaJmBBSYQLE/aaS4/3CzGK5CnjNX9/N6TgVbiVaxZ/Yidg7cfJ0CYZ8nUs/aapQB/Y2pVNgADCifUGwH0ElUG8WzXI6DTolv6kDtucKGiEhSwYartJoQrXQS+OVsC/U0+wp/zRHdhnwhB992Cp+suSTovnBCFGCDHyDC1d4uQbaHQnh6eqXu3aVG5tWwspt2xFgHUG9ojhDuDiGdpDkVgrmo90KNF8AaKuOUykJjQBrIvfL8XNvY3ZJVlw0kmaLbs0q8gFTkI1dnw+X7DSLBLK+1sr+Uzbf3We4CffN2iD7nldkHoJ
 77CDlOTj
 H/G5z1VbURsptiO/unxdOX6DIdWctZF6N/rEa0dMy5LSpwLKRcBazkWGCN0jWld+/ZjQiBNy1db8EDtJ/pr1rqP3J+ZghDbePHmu7+BN0QA9lVRDl6XCgB/R7Tsdd9InNfsQXdYUfQTPBV/HFjtmZmjVKmjA8Wx/VNlNnBdaquFcocVD8kuFSEesxGq6kaLaqyPO0gTv/Q0NLs+ZMkgb+7J5aUIy8ZTK0EbDdPu8LDN8nSHL/QwYMVjpGBTaw3oVyXpcU6/QsRmZbbtxqZD3CYp39fYYyVBM2s0ByjXbK9K4U8lSOdZ1sc1HkcQmQaQD/86YqMsX19Ln1W1TlFSXNAIwK0e7LsrLGFj/PCrJYrbBhku7g7R2vWYfml8eG9i1Fde9/euLCHS91cMYm7s9DCKWpJDcoN/aAsMX04M3rqsV1yBmbhM0WaukUOLe5prm5EZ93
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Eh, "kho: make debugfs interface optional" makes this variable external.

Let me see how to fix this quickly.

On Tue, Nov 4, 2025 at 10:38=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> (adding Pasha)
>
> On Tue, Nov 04, 2025 at 10:48:31PM +0800, kernel test robot wrote:
> > Hi Mike,
> >
> > First bad commit (maybe !=3D root cause):
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next=
.git master
> > head:   17490bd0527f59d841168457b245581f314b5fa0
> > commit: 8c211175c3abcebb8bffce8095d78d193e482105 [4972/5926] liveupdate=
-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix
> > config: x86_64-randconfig-071-20251104 (https://download.01.org/0day-ci=
/archive/20251104/202511042251.paO6f5BZ-lkp@intel.com/config)
> > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87=
f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20251104/202511042251.paO6f5BZ-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202511042251.paO6f5BZ-l=
kp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> > >> kernel/kexec_handover_debug.c:16:18: error: use of undeclared identi=
fier 'kho_scratch_cnt'
> >       16 |         for (i =3D 0; i < kho_scratch_cnt; i++) {
> >          |                         ^
> > >> kernel/kexec_handover_debug.c:17:19: error: use of undeclared identi=
fier 'kho_scratch'
> >       17 |                 scratch_start =3D kho_scratch[i].addr;
> >          |                                 ^
> >    kernel/kexec_handover_debug.c:18:17: error: use of undeclared identi=
fier 'kho_scratch'
> >       18 |                 scratch_end =3D kho_scratch[i].addr + kho_sc=
ratch[i].size;
> >          |                               ^
> >    kernel/kexec_handover_debug.c:18:39: error: use of undeclared identi=
fier 'kho_scratch'
> >       18 |                 scratch_end =3D kho_scratch[i].addr + kho_sc=
ratch[i].size;
> >          |                                                     ^
> >    4 errors generated.
> >
> >
> > vim +/kho_scratch_cnt +16 kernel/kexec_handover_debug.c
> >
> > 4039a00022d42a Pasha Tatashin 2025-10-20  10
> > 4039a00022d42a Pasha Tatashin 2025-10-20  11  bool kho_scratch_overlap(=
phys_addr_t phys, size_t size)
> > 4039a00022d42a Pasha Tatashin 2025-10-20  12  {
> > 4039a00022d42a Pasha Tatashin 2025-10-20  13          phys_addr_t scrat=
ch_start, scratch_end;
> > 4039a00022d42a Pasha Tatashin 2025-10-20  14          unsigned int i;
> > 4039a00022d42a Pasha Tatashin 2025-10-20  15
> > 4039a00022d42a Pasha Tatashin 2025-10-20 @16          for (i =3D 0; i <=
 kho_scratch_cnt; i++) {
> > 4039a00022d42a Pasha Tatashin 2025-10-20 @17                  scratch_s=
tart =3D kho_scratch[i].addr;
> >
> > :::::: The code at line 16 was first introduced by commit
> > :::::: 4039a00022d42ac3d68b2eea63066bc9f7ef89ce kho: warn and fail on m=
etadata or preserved memory in scratch area
> >
> > :::::: TO: Pasha Tatashin <pasha.tatashin@soleen.com>
> > :::::: CC: Andrew Morton <akpm@linux-foundation.org>
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
>
> --
> Sincerely yours,
> Mike.

