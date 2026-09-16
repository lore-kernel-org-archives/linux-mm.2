Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11252C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 17:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186E56B008C; Wed, 16 Sep 2026 13:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F396B0092; Wed, 16 Sep 2026 13:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064EC6B0093; Wed, 16 Sep 2026 13:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2C576B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:29:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDE151207B6
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:29:23 +0000 (UTC)
X-FDA: 85220311806.23.75D93DC
Received: from mail-ej2-f18.google.com (mail-ej2-f18.google.com [74.125.228.146])
	by imf25.hostedemail.com (Postfix) with ESMTP id F040AA0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:29:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kbc5kHcn;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.146 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789579762;
	b=gJm8T2trmDCiDht965QBAPBoTB8itIXAZce5Za9N9QNNIA5OAYYgOSyiWYZmtljMm1BpiN
	a3gvyV/45EwKn39B4zEQ7RFXDlrX8M3VgMMEgQ1k/dtnmqYc9HNUv+3WbaEpL1/W5zIuzu
	gApfj7x2xzbgm3YI8Hhe4pRmDNgaxkc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kbc5kHcn;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.146 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789579762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsBp/K/8Mh4fs+CJj0dFevHba775OvfQ8W0kzE3hMzk=;
	b=3TTmaVwlZTBxr0LSPgoNs/7+kjkdq/xnLyE91hWwoWyNVCovRfo/a39JixpZ7cIxpAV2zq
	ZnQawTNLzd174K9dh8hCcqjMymfPo9h+O+Pc1/UQT1uGoIRoXvnFwo3AHFpkEn8OX0lE2X
	G3qMyiqan0lb5cszojqGwKYvra2bkOE=
Received: by mail-ej2-f18.google.com with SMTP id a640c23a62f3a-c254fa65080so166468866b.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:29:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789579760; cv=none;
        d=google.com; s=arc-20260327;
        b=o1U2C0WTquFcpBNH65amagd7QJZ2JKc3WoT33BRIWrbAx536pa+zRNnoaGmA+GEFSC
         n5axWTGD12vXzDUrbxoIRC75av7tLax1r9jwuLXID6I695qFp4hjPvUWWjKop6cqqv54
         WdN63cSCpkn8cJyT/mJ3kmlUiAPW0GteGxYA2UtNZuCua/HDs3b7QgvKyQwYs0LHC0TQ
         LC0iID8VqszDgtLPnbkXHn7eNJ0hqFVOoBUz7z1RL2YtozRwX6UiMBJBw1+DwsM9i75p
         h/mhxXhOm2+hxvT0kv3O62wbpwgc62r8RwTjjmdo5wWdfk/Giv0g6PGSK+Ev/OwsU41S
         Bwbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MsBp/K/8Mh4fs+CJj0dFevHba775OvfQ8W0kzE3hMzk=;
        fh=9Xzjq8bPeiNq0cgvpo+joK2Sn9ETibJHLcV9NrInD7o=;
        b=CoEJDyP+UUvo+SkbsqJd6cZXY7yjoafoSqwnKTEhmHrrihkFmHejJGSA5d1Pa1Twzu
         TSCb/s+Cgh6zOWLU2OABq34TWASzE3zDQFj9YCDHq8App/rxcloyiIyroiNSHWO5zTze
         dz79VdICCRpNZWCvsToYMAq/pkbQhqnOKDj7JIGZqPkJPC2+ZAKNkwH5/LTgs9EjunjI
         lqzvgW7O67O4LenyS3TBcXY7YOVuRLmbRPDZxaesQCMOKOa/mdmppvndl9UjzvaS3Oxs
         LlueFMeZtN5zBodHGUk/EAYo/Ido04PTu+qVUbdbYc+pObOx5iVt4IhpMXf6SG/iXee6
         P6zA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789579760; x=1790184560; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MsBp/K/8Mh4fs+CJj0dFevHba775OvfQ8W0kzE3hMzk=;
        b=kbc5kHcnx/zWxk0pCMBjevtKD3r9Pppf5PY/at6X0R1432t17RW2ho9pdU5NlQTXHy
         13XooXFv/RtHWheMWST5WhgAObCxoUjKtOlr2AgDFaxnjSH4nP9pV45NIVhZLhKG2Jre
         d+nI7NDEFHaLBUiemns45f9OGdJrg9j86pAGufeGyhrBFp2ZuL9k+UU3Tfzmjvqot6hq
         xmF/bj3BZeVdicihUs3RYbVriUpiSVRGwBPIxLzB1GTK1yw7joGIMe08BagQQ1y1axEc
         Ipd7vw4QSfQrAhr3ORFehSlKxqS5wyRvMW5sfH1djgdub9MO85wv3d4Zrpt6+ltVJhP8
         uSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789579760; x=1790184560;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MsBp/K/8Mh4fs+CJj0dFevHba775OvfQ8W0kzE3hMzk=;
        b=I1YtOdX6x7IKaVqY4V6dnfBFrV99kliw1Bhjda/98gxHajx+wNrrnHjDKXIbQsQq6b
         adY0STsqMsQiY7kerO6hQkLyN2rEgwXPx3qBR+doGVfYH7DwsUbxvOXovjaIouwtV4jh
         ZubF7pRHOW2Rx0zCp748Jo5BqtfJocNoluIeo7Wqg5dRTZDqVZFTSJRr4I0AhdA130Oo
         xCblZ96MPpyTpAgIf1YCIt8BFQQjv+gpV0Bx5G1CGNV5+vdVYew/tJ38oyolSHzaqB1C
         jyC7e+erbbOOoUhedbH1nIO7/iBtxIYCSA27T7XyEsYFuWhYtt23HtbVOSeLkJcVTU5n
         t0qw==
X-Forwarded-Encrypted: i=1; AKwUvBysyoNT8qaGbRNTcKkFQTyDLlyqricE3YEJbyPe/aji/NCMBWHnXW6ho1/FDp0e7940PDG4vVduYQ==@kvack.org
X-Gm-Message-State: AFuF++kYJz0bt3zjM1eRyy8H9dLL14WBQmEUdUM/2VNnbamDNqaqwANw
	OIrjnactSDrYTWg3i+bTZxdxh5ZDQ+tFNnNeqOjcxj01POcbszqiAD5twTEBZIsQtwZNH2AbZAF
	dVPBO6cYO0SpkHnNv2dnTUx0Sl4MYYanPHvkJBNmk
X-Gm-Gg: AYBFou18p80v5MUC9Y5aXTuBGHzBYZVDnPI/X/YDuxMd14BDhli01l+Rxj9QjjZtaxt
	idCghaQMVJLOOABR/oLtWgaRnlaea2jYphSiityuG8IkTX4IQVbppemnpsCQTkrYnwuWf7s2ifK
	4wpWt6TFDdT2SueILHcH5HArvWrdUQsaMsVI9Awf1pRXxm/+4y2KvhuY/odAIE16RqSkNZ/mfBJ
	X3BB0lEigVmwn1ZCkL4FfntEdxKukXXhLd7mPRgqsU+AQgFB7NsxUyCYYJPcQe5O1OosW1oGWc0
	8k7+1Qd3hMcNmxtSPO460EqMVia8IcKTlh9LHRZY4ZZB5zlK6AcMA4hzBSyNftDlKrbu7gkGxjK
	2BmxOsfmaBFyDNUQdbBWx
X-Received: by 2002:a17:906:c114:b0:c29:52dd:317c with SMTP id
 a640c23a62f3a-c29e52ff5aamr253749566b.30.1789579759601; Wed, 16 Sep 2026
 10:29:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com> <20260728221007.2098560-4-dmatlack@google.com>
 <e099cbaf-3185-4c39-ae36-7f0e074ebff7@linux.dev>
In-Reply-To: <e099cbaf-3185-4c39-ae36-7f0e074ebff7@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Wed, 16 Sep 2026 10:28:52 -0700
X-Gm-Features: AcwNN1X8OtlPLlB_fEFGTTxlBHL1RWBLk55_RIeZg7bMhopD1i4pmTuVWaDvZaI
Message-ID: <CALzav=eX0gVrbWCnYGwfqPHUkoVxqdr2nw3Tx6Aqze0XOcuwzA@mail.gmail.com>
Subject: Re: [PATCH v8 03/12] PCI: liveupdate: Track incoming preserved PCI devices
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F040AA0005
X-Stat-Signature: u7kh7oopysqc16rk9dzky78meby7dh7c
X-HE-Tag: 1789579761-394015
X-HE-Meta: U2FsdGVkX19aXv5A+5JLhUZogqaQiqmPwif7smeCX2pYUphiwmN/gHxELBp6+2XevZxMpkuX98rvAFinFjh2peRygBW4Ex4Sl93X+WEvsHhN2jPznhE+gzb0v5osE8jJbiDfUxG58s4Y11unpZBBXAyeWth+Io71DTf5UlmgvKfmNpj0XdubwRLPc7j02qerkBRMNpSeIMKLC7Ktd9j0H7rTTEC5u4bjPW2j33HkZMIOc+0iM9jUeIt8xocyNN8nE8lVwfaq9POUWnC5YloMf9NXCxUkDgvF8hUi43o6JnP/c02zjVcLX38/GOi+GfhdeVJjky/UIW07k2ZcGitJkh1cdMJCYMNEsnUOXw80oW8mHT3hPIeQn48HOLEgkUA88povh95FG/jsNLPpiyP2PpnfNuQLYxtB/17jbc4FmBV+yWz8mTpj0Edd3SmzT6wR9K8yxpAP35SQWHggd/1PiJNfg6EXY1DAF2RzhjFnM3pztrZpMFFFAcN8FpEhKfEk/wrTUUz9xey6KXghi7r161ZU3CoIHxyhB6RogsLoboFqhfk8X88exqBRDCVpF56fIRvwpNUh7k0kM+TF81VaYefZGXDHxigKYmEf7wnMHlsnWATOdFAxo5m8wAIQ2L9g+SrjwZ/JL29xRRUV1BoEVLK7qQP0CLWKscx+LOnFXho46AoOhhi7nT6txHLIPu3xY9j5n4C7J07/S/zg+itkkWCHdPMMGyCqvEZSI3n4AtDjCqaPUMUsrSGZkmxi77pOnvaUS4Ztb6EGgdnCLYu1kzqlbJV3NlGgVSbT8Liq01LLU4yvlQj89fQiK5nTIiVJ517Ol3T81byqBGr0t/ijLdIdyw1LMoI1P2CoF/WyzwW1XM6Fq6RChsdncB9aoPOwCgI6RCJyrfbcHtQWwWlY4SnItI0UnAnGjDfuvXcqMGudKcb42yUEoDEIn9omR41OdbZR1gnSK3yYG7XbS9S
 7xF+/HnG
 yAM1ANw2Ug1m6Ou7bbxmK7I7qNY92gvJFqlYgAuFdxlpXazvnotjMLfCHqmY0TjDsRcsQV1iFEbtStG+gpw5lq4Z4aLK1QnAlCvtcd4dkSi7zt2neRlYrDwIOeD4okK8eWkwV+xF0xS5cpZSXU1ny/bAjyAteGmMOns9LFYkYMbb/FZTy+THjpMaNmhS9LzbzoRqGJdvXeoxV2Bbh2f5hMTNc7srtF8GWeQM3zpUUOMjxOU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 8:31=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.dev> w=
rote:
> =E5=9C=A8 2026/7/28 15:09, David Matlack =E5=86=99=E9=81=93:

> > CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that th=
e
> > domain and bdf can be guaranteed to fit in an unsigned long and be used
> > as the xarray key.

> > diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> > index 3781e2b5f095..8af20f558086 100644
> > --- a/drivers/pci/Kconfig
> > +++ b/drivers/pci/Kconfig
> > @@ -273,7 +273,7 @@ config VGA_ARB_MAX_GPUS
> >
> >   config PCI_LIVEUPDATE
> >       bool "PCI Live Update Support"
> > -     depends on PCI && LIVEUPDATE
> > +     depends on PCI && LIVEUPDATE && 64BIT
>
> One question about adding 64BIT to the dependency:
>
> As I understand it, enabling CONFIG_64BIT essentially means that we are
> building a 64-bit kernel, and a 32-bit architecture cannot normally
> enable CONFIG_64BIT.
>
> If that is the case, would depends on 64BIT be necessary here? Or is PCI
> Live Update already inherently restricted to 64-bit architectures by the
> existing LIVEUPDATE/architecture configuration, so that this dependency
> would be redundant?
>
> If this problem has already discussed, I am very sorry about this.

The necessity is that the PCI core needs to store more than 32-bits in
the unsigned long xarray key (see the snippet above). The dependency
on CONFIG_64BIT ensures that unsigned long is big enough. We could
probably remove the dependency but I would rather wait until someone
with a 32-bit build has a real use-case for using PCI_LIVEUPDATE
before putting any effort into it.

