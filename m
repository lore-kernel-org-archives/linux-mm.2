Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C32BC87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 23:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EAD66B0095; Sat,  2 Aug 2025 19:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2606B0096; Sat,  2 Aug 2025 19:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8DF6B0098; Sat,  2 Aug 2025 19:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2C96B0095
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 19:46:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 990521144E5
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 23:46:50 +0000 (UTC)
X-FDA: 83733454980.04.6805045
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id BCD6D4000B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 23:46:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EQIR4vY9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754178408; a=rsa-sha256;
	cv=none;
	b=3z9gbG3dgWNZOhRS4ZyeB4ZCFeUyuQu56mpVQTHi1fYve+jISSuN78Dc0nQsy/2kmVhjKe
	SC91dqRTdNV3c6NpJx3AQtXoUeJ7FM2Txd2DAj11gvUj8YU+xj5hpfACKZVU2LyzSeG56r
	n9tCpipfUx15qSMoaYgyFeQQb7SRiVs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EQIR4vY9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754178408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omSxCOyrH+cAC0v6maS2PTOyG9YcJYfYvPlLW3DY1LU=;
	b=6CEfOnhc5vPAlr71NeJ6mxcvOTmQsBJC7NE1xCnrcUPmbrdfHQ4+PXrFS+izOHJusoz/OI
	6LvR51i1g7zqioLuNbiXdq6+IXufU5gM3E5lVq6j13uteZYUTYKhbEVZV+F3N/xZm2+IIJ
	4ggIQIothuaWYQd7FNNfzldN0uxOQao=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4af21689d1dso3938511cf.0
        for <linux-mm@kvack.org>; Sat, 02 Aug 2025 16:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754178408; x=1754783208; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=omSxCOyrH+cAC0v6maS2PTOyG9YcJYfYvPlLW3DY1LU=;
        b=EQIR4vY9NWNw8A+NGEPC3LmPiwGsnsQJdAnFUeXL1iaUivn6o88bzvYYVfu2OfVjrm
         6DYc4uOt+mxxEkO4owWAca2k1lD1Ka7zRM0eU3uSz6wKMbSKhhEjyEJBKZvZJeSuZdeu
         K8Y1Dx8oj5lvA+pV/J/hm6sKk/Cm6kmu3xBePX65DSNwN+VzXsTrUfUCrJ8FrmHtrGxF
         QSnHE15KAoCvjKG1AxSr9TAP39WlhLB6Zp0hjaHRPrAdARTfKoaVQ6UXU2Z7ZLBKPb6l
         8mB8fLAaQB+3TyWMKBU2hGY1ueTDDDNcGj38wqYXnZc5b2vWBfBQqOa61tP/RvemCVOS
         PqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754178408; x=1754783208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=omSxCOyrH+cAC0v6maS2PTOyG9YcJYfYvPlLW3DY1LU=;
        b=ZoyAHt3P7EpB2Jc7IoDg1aQx9nliBFjX0l0KxtgmfxOlxlMixohJiAzGYlWJk/5cAf
         Jm2EmqQC8s754XYtepBR19l6e72fneNsBMwVdYL32n6Z+UWVw+oCPK2ViigJ+O2aPPLz
         Lm+TJofrfaw5yx90l+6b+/qD/mESKv+WhQ88sQ55cxmaj1DxyKO4S0Cr31Fpj4BdAPEY
         /Ob2NJQfLE1ALFw0OB0du7Y0kCzPlyxEkRxOhUc0zjt9mfrAV5eZfvFZO3M5YtLqH0jq
         i48SiO0lgyGqPduEKyc/imH3W7mdjMtBh7YaYGRL5qcmICcGwkygfqrZODSIS0VVdf0x
         tkCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJxUJLr4P7yYU+BuSMAIjy819Qbn5CsWWAWAuIp7ySR4VWzK16Gi52US0rQopHqrTvsbr20UGnVg==@kvack.org
X-Gm-Message-State: AOJu0YwTx9wGdIaI7PaQtNz0/8TVhcON3UGqZVNH2TV+T7Lb+NT2mS1I
	0e/YQSukehimOIqgZD+MBcXEwo3cvf6QI+Y6vZ9AymSITfqcl+Prrc3pNRuj4dRuDO8Q6BgxOXs
	Y6Q5P8orhfJzmBgX1RIChUo14iH9NLz3ND0nPNiazPg==
X-Gm-Gg: ASbGncsbrs2QV0lxe78BKEOWiSIYMDe95N5+AP1EANYnc/E1qaMwUWad3FH0gTjL97K
	vqaam6IxWx+YJHZucxiScntwg7IKN/lBrVmHBj1EY1zZuQCZd0HmqHEeg6f5Bu2WjJWAv5mGBkT
	K8Q7iMrEh+SRSlUOB35MoAqOJXGf3GcsJz/SDR7zyP82huWdWUU9JEZ8nh4nJu/8UiwP7sP4yIN
	KOv
X-Google-Smtp-Source: AGHT+IHdEITyYGYGGvkUJ/FLXWfXeXO8iQNocqY+DuXZ+nO0UMVJgqKLU07m6mpEY1xZc8NU3/+RPBwpxH4hgExqjBU=
X-Received: by 2002:ac8:5e4e:0:b0:4ab:3963:c650 with SMTP id
 d75a77b69052e-4aef16dc96cmr147684491cf.10.1754178407719; Sat, 02 Aug 2025
 16:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-10-pasha.tatashin@soleen.com> <20250729171454.GO36037@nvidia.com>
In-Reply-To: <20250729171454.GO36037@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 2 Aug 2025 19:46:11 -0400
X-Gm-Features: Ac12FXzVHD70UwSnRqGNkZr2cSuqC2q4gMi23eZp3qK6a2xJfpUPm-pdMLJYecM
Message-ID: <CA+CK2bDz0t4+r9Yw+rpf_8K_GFDygXQ_b6wvPFtNYkssfX7wew@mail.gmail.com>
Subject: Re: [PATCH v2 09/32] liveupdate: kho: move to kernel/liveupdate
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
X-Stat-Signature: yaje3g6inr5fh9bq14st5ba4cf34y897
X-Rspam-User: 
X-Rspamd-Queue-Id: BCD6D4000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1754178408-976048
X-HE-Meta: U2FsdGVkX19LFmj+JK50fnk699XNHd5c5yLdLzmMZWEnAarmC0J+/5HWVCuaN9aS29/VP4PDrD6Qs07R2FB3mT48GHPu1QPkQnGZIe8Mscm5AT8Mz5TqOPiK5C0DLeH+oLUgRqKoRJll/+4kj4BIAMppYBtrgdzmnHV1CB9Uz2PXoKsPps1Rq7yo1FAqxHtjCfv9JwzhHmgBY4DOH/WbtbhAgwLyHU6UfIgmAO2TFzYaVbdLetKwoeVNFFXgD7jvaAQvUJjrAQyM2J5ZBTq4Pp+qUuFCbOFQYUpar1/oPwB+bWoE2Rz6zH3uORqsyf1Z6SaVuXqPIGV9/pQxiTPgq7++20EVsmkbawybETtarOCU1Z5pat9p1+6VD3kK0VO7qnPV/r/B5Lep3LZL3R4CicRx6TiiDI9F3nHS3jR145RZFAmVnwyFRwaarO+cuw8CmLNzbqer8Ph2UO49KGadVTxSjzW8RKT8JlQen9567hV1EyBqmU0VB8QnXpvDmaf9uaLQ1lS0ShMVaPlXrvzle+35LrIMdBoZYYtrG8FsgMVD82zhdAN8p+NtifY2tAAbHsWka+Q8cH+qUjD4+AtxCwFwWNmAxwmzo/xygGbR8fWqeawU3ZhUNKCJsk96osHNM/HXde9n14Sig8U37ndxHxerDRe9cvGY3Iw1OdaKZgoINSRn9wmM5J7zYxKQDQYO5COzHBDeZnPPE5F2qVzGtauR80CctfbnTKefDR9BGHNmQgoIlqLi/JR02BJ33tUNw6ofqrhoUlgRIuZwMtlY0KDwQnH/ylnlkcsJ5U8nag3wnXfTB5rb3jFSeDigwtqm71wX2asNjhudOXX7jZKv1vnopSjHpOP3thnypu4boVCesUBHvBzQx7nzCfMkS4WtCn9MWggp+JgkRVyXWyuRQq8KfRcusZ9OTfeLczlq9RIq0CqbgG7CjbHPnzrOe0BkpdU+zBo3Vv7dm5Mr5N2
 rkK3qIUr
 U+rtqWgwMffEoEe7M0PnZEIW7aOen7jTq8ES6PYdKdUT9R3ctGlfLJCIH9JIPpjbwRwSilVtt8lS5xiCosWtmGQ2YiP7SVtQPQ1mjihoctuE34F/kpbuqjR7m8ZDa+xQf6xkW/nb420ghckLPnip0+IdC5YAhRlgvCai8q3TyUjtqcEukENLtM2T877REa6vDkm6JUrrMWY/WII6voD4ZehEpGCYgLbJc/lkSuUkcfvpcIe9NaRlLZiCfOfC6KMEyUHcz04waISLiO6hq065LKI7HCAkOL5Coa8ZfKtJs0yjOmvB0cgdsrRZDJ0/4iyjZs0in+Fqql+7eQBpwpUyz6LNClg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 1:14=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Wed, Jul 23, 2025 at 02:46:22PM +0000, Pasha Tatashin wrote:
> > Move KHO to kernel/liveupdate/ in preparation of placing all Live Updat=
e
> > core kernel related files to the same place.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  Documentation/core-api/kho/concepts.rst       |  2 +-
> >  MAINTAINERS                                   |  2 +-
> >  init/Kconfig                                  |  2 ++
> >  kernel/Kconfig.kexec                          | 25 ----------------
> >  kernel/Makefile                               |  3 +-
> >  kernel/liveupdate/Kconfig                     | 30 +++++++++++++++++++
> >  kernel/liveupdate/Makefile                    |  7 +++++
> >  kernel/{ =3D> liveupdate}/kexec_handover.c      |  6 ++--
> >  .../{ =3D> liveupdate}/kexec_handover_debug.c   |  0
> >  .../kexec_handover_internal.h                 |  0
> >  10 files changed, 45 insertions(+), 32 deletions(-)
> >  create mode 100644 kernel/liveupdate/Kconfig
> >  create mode 100644 kernel/liveupdate/Makefile
> >  rename kernel/{ =3D> liveupdate}/kexec_handover.c (99%)
> >  rename kernel/{ =3D> liveupdate}/kexec_handover_debug.c (100%)
> >  rename kernel/{ =3D> liveupdate}/kexec_handover_internal.h (100%)
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thank you,
Pasha

