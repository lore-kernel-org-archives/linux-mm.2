Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD7CCFD376
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 01:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 236E26B000D; Sun, 30 Nov 2025 20:44:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7A46B000E; Sun, 30 Nov 2025 20:44:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD8B6B0010; Sun, 30 Nov 2025 20:44:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 000CE6B000D
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 20:44:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2397F1330D4
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 01:44:48 +0000 (UTC)
X-FDA: 84169208256.17.1A33E7D
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41579160003
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 01:44:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=v3HWQ0BX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vannapurve@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764553486; a=rsa-sha256;
	cv=none;
	b=4djPLyo9hIRaUnJeqyDFrEGfm1BYkje2s6rbC3owCNZAkZfpGeoTqxbrksJR1MFIaU88gC
	ml/OM8EqVc65SrJWpKAf+9CClk8tON0kx6Bo3iNHxe3FWRewtdJJElH88HcSXm4w+8m2pA
	vLKaDh5x/StAhIpkQLbUjJAZPt0F7/8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=v3HWQ0BX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vannapurve@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764553486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXjK9G/6yVP87R7EES41vVBqCFfsiZh7q+9DV7eI7Lg=;
	b=PHkYPKpX1tUIHJ0tysqmwYQqFJoc6Ky8nSfvVCwm0vVXAYhoK0GvJfdqbn+Mam77kqxSRD
	telRguwmdYSRSgGpUcTRehyNLVCpP6rgh9zgecSEKr/TO6m6aikK9eri45qLfXVKr4f9Zn
	X0RHBrEHwR09aPKy9lfPu5Z/IIm9lZ4=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-297e13bf404so618385ad.0
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 17:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764553485; x=1765158285; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXjK9G/6yVP87R7EES41vVBqCFfsiZh7q+9DV7eI7Lg=;
        b=v3HWQ0BX3j6Wzeh0ExH64emK8MtysjxYEZDMbbIPq24sELCxmIuvUWSXuA1g91Yk9Q
         mZsY0WDTHxW/b1LBjpDRA8vmWw3qhWliVR4kEk+5y7QD9DxgcbTdK2f89LEFsJIK42cr
         o+eMFifJlhIDN5RxD/NuaFHqmKRyq2vIAFxBBoDL4sqKPbplgN9iJrOqJWJgkUDu7Sbp
         PaRjd0U9cJAMtqWeik+MBaBKyiSFKWOgBOAX1bGGgv6iGJGY3UJZFCDjQfWeSZJ8J4ku
         Iqu50T4+OszJLamc9z9l1h6C5Se/5sCjIe0Sygjah2XsowboqSk2oFIl+D6V+6EyRHkP
         EN7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764553485; x=1765158285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XXjK9G/6yVP87R7EES41vVBqCFfsiZh7q+9DV7eI7Lg=;
        b=K5Lozi/3P1aNYMnAEZszraVZ/MY45Cl/idH+F7M1HlSt7qy5k0BJsxqcsbXrgPhJap
         6NlBqOY9Ygtm11imAaWCyQJBz8ljgvTAg3KzXlolVI5ctD2xx59cahwPQSD76P7OSgv5
         2SPwtok27m3lRxWfk9Q2QHSaGdim6HY7hjgaNC5sLyoV1ZGFOW3UPVngqePcE5DXhhzx
         TwM28NS2ulBkuR6fzF/ZolKrUoAz5DmczNaZG6wDlC2pmTiw2TWzLZ6D9uoxT8jCW+55
         6m3n77l/lWAaAdAGqCxacd1oCr9IAeEittKhbFOH1Y91tqgzie+0ZgBZ8CoN9LtMDeCX
         PyNg==
X-Forwarded-Encrypted: i=1; AJvYcCUVPB4LojowcimQE81+HJD8XKtixrn6+soj17gkzgd9Qqgf6CKOuZXlpsJBfa0mStl651kBnqyjPA==@kvack.org
X-Gm-Message-State: AOJu0YyXj5ZjdgRHL5W8f3T1lYIshloLlv2AJg/ORFwiavm2OtwCfNdG
	UX0rX28b+Ozjpax2Qqe4NH8UZP4faHCAJ1OYCH7nhTpq0SU+BNjIORseXPx/gnqpkpm4DZrtXK3
	HLMLFtWYW+4i0oL4Wb+Bb+XA6uItl0IpepdxhiRkv
X-Gm-Gg: ASbGnctIF3c4aZm1Lo2qc7S2cpWo5WbLSpq5cz5R2hNd0cSuEg9efXCGYVnYn8U/SXS
	I13GxMc/iy1mVbnKUEhjQ+ec3medouxewIpZaf5PE1+TiVYYsU/QIIpEFhkBAte8NrBvyTAuhct
	CskFpI9IxX6Fjv5s3On7IiYOJ7dyTorZHh9hr+1q2at+HPiEvVUB+Z7IEXGd2VGqflF73Z1XlZX
	6NuiNjquBND+cH8LxMSY34RvqPkhn7oJHR0SwewGMz8GdKXzSVzPxU+NpWGJ9rcScNV1VcLoyMV
	l7E2tAP6V5V92188TKebK18cNXqx
X-Google-Smtp-Source: AGHT+IGVdSi91XFWN15kFPtoKM7WWzNM62D2CelcHdnZr/ei9NXQxiXmZnu+94y9qAsgrliHk3AbI8g7Jygo19QMqI4=
X-Received: by 2002:a05:7022:f902:10b0:119:e55a:808c with SMTP id
 a92af1059eb24-11dc9c5d1f3mr233294c88.9.1764553484484; Sun, 30 Nov 2025
 17:44:44 -0800 (PST)
MIME-Version: 1.0
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com> <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
In-Reply-To: <20251121130144.u7eeaafonhcqf2bd@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Sun, 30 Nov 2025 17:44:31 -0800
X-Gm-Features: AWmQ_bkAp7M4RY7KhmAYC2tjQ6Yi5K4jbimiP8co_ZGiovyYBjjsYMzWDYgBcYo
Message-ID: <CAGtprH8gznGJ6VObk8aShBn_XnhwDoUzyzTkaDAe+MyiNsJ-NA@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
To: Michael Roth <michael.roth@amd.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 41579160003
X-Stat-Signature: 3a4oabwrpz1wipuzbt4ujujuqihpat1k
X-Rspam-User: 
X-HE-Tag: 1764553486-222952
X-HE-Meta: U2FsdGVkX19uTv9CWtNb8x8S3tRelm1vEYZsUAeGOTqBoqvb2DQ3NyvcXGMUhyWVcrGPRQIPB0TEnl5GA29rDTG/GuSdF8mfMXYqb3mjZKCbavAfRjKQ26atI7EJBBqLgsJt4jsny3obnOC+KN0yPPcY/vwuwceVgYI5jPf5E0Mw8MfY1675wVbjDQT/AQMTTU9WYcuhTFArvFMUsD41LyuITYKRakC1BHBIpy7D23tu/OMC5qhE2QXMV7VTccXeqh2ezIFYbnuo2aQ57tjpgJ289QRBEsDUTNJo7z+6X/a6+IjEqug7Qj5bj0o1UCvBxvZoHWyHY2bATsH/JTInh9I3+biqo4mzua2uwXY57pINKneaaF6Q6wZ34S9eO57IfoY+Nzz4bR/ZF+O4bkmX9EHtkgxm/ypbjDRzeJJ8XatAbYO8ogB+TL27fNTN+SS9bKoZlyxje6hjJVY1nQu5L00dwN5bzcUrQAaVzaqwHKoSbC/Bs0sEsXJRCyLhbuqEXLUEWNJmGO+LRDWnrY1RV61Tplbs+Al2uXrGrH+Povl+iyDZR/Q/CNGGpb8aKTqDS4eg5aRrkMyvVkR0oasItznwXS5qZNS29ieqh8RbWqqbeG/P+OOU8Rt1jfmu97EW3iVVEGc5y5KXhHoZXclzeYQ0+VyleIflaWf/W1I37MPt2OuJDXL/KNmE63P8AfFyZO/ynqJ/7oogR5ZfO6m/hxqcicW8RDIrvk4tT+NaTWxw7IBfWtzkSxwHKJ7Ng0jJzCEhtXiKtyGLscq50uw/K+ZQwXImgvYIC3iwIFdp0Xq+zHc/4MeM35hJXoxSmwcGzk3MGgSXo2w9JAfVOJ4YmYdOUg6INwTVjBMVVNTSgpOuLJpo0SrmpE0DskniamKRQuVVui14sahB1LkVf2QLKT5D9p4GJAyPsBnHZBzSN+CB91DC7A1UqUwMtq/6QOXurb3S0TTeJ/Inv7QNRWn
 id8gN2iP
 d6XJD20BY9CSHmJs9H73MCzjaf1fdHmXmhbGkvPDvhWJQory20pDjrwP9G849van/uOEjKrdCrQzJz4gbRsgxN24hDUThIaMVHEOTmZ7G6oHl8MF5nXg8117RaaGyMCmwyEIThI1vzyM33aeQvpo/RFoLqK+eqXpG3fyZJ3llBU1Ye/aXlXM/SNTlBFiqythTbe2CfI9Ub41+UcyUDDBCqheAqGX0AhkTl1p6lo++Ra7MuKtgADIZo1vCjq1Vo8lWpa3bzFVas65QKw1LGaRKudCnZU5cUJFKvOc10SvEtf7HhMQgDNeTJIu6YA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 5:02=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> >
> > Increasing GMEM_GUP_NPAGES to (1UL << PUD_ORDER) is probabaly not a goo=
d idea.
> >
> > Given both TDX/SNP map at 4KB granularity, why not just invoke post_pop=
ulate()
> > per 4KB while removing the max_order from post_populate() parameters, a=
s done
> > in Sean's sketch patch [1]?
>
> That's an option too, but SNP can make use of 2MB pages in the
> post-populate callback so I don't want to shut the door on that option
> just yet if it's not too much of a pain to work in. Given the guest BIOS
> lives primarily in 1 or 2 of these 2MB regions the benefits might be
> worthwhile, and SNP doesn't have a post-post-populate promotion path
> like TDX (at least, not one that would help much for guest boot times)

Given the small initial payload size, do you really think optimizing
for setting up huge page-aligned RMP entries is worthwhile?
The code becomes somewhat complex when trying to get this scenario
working and IIUC it depends on userspace-passed initial payload
regions aligning to the huge page size. What happens if userspace
tries to trigger snp_launch_update() for two unaligned regions within
the same huge page?

What Sean suggested earlier[1] seems relatively simpler to maintain.

[1] https://lore.kernel.org/kvm/aHEwT4X0RcfZzHlt@google.com/

>
> Thanks,
>
> Mike

