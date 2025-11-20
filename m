Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E298CFA443
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 19:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1196B0029; Thu, 20 Nov 2025 14:43:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998E36B0032; Thu, 20 Nov 2025 14:43:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AFAE6B0062; Thu, 20 Nov 2025 14:43:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 796096B0029
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:43:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A5ED12E6AD
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:43:20 +0000 (UTC)
X-FDA: 84132009360.07.91D8872
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5C727C0011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:43:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Eep7lU+S;
	spf=pass (imf10.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763667798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOb5k3bbgLdxLAU2xBUhkNf6M8DrTXlh4mqXRt4KFAI=;
	b=cSDLS8hxSjbjJ8ITUFWtwzX7uzuo9e7yeXKJD5mar4XcWyUwofos6n34cg3IPh46Dk3SFG
	uYI9Cl7cT4mK+s3si8DBwMMAAJmnnlG769x0uUymqWZzlottQlufm5+TT1PYT4QMvO6Heq
	Mi+nmeOWo1wXfDI8CJCHtnh23X13h24=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763667798; a=rsa-sha256;
	cv=none;
	b=V3nNRrrZz+LiKl3rVFml3fzjjMaQuJ0P/6oLBkJKc9SAcIXHpcB5uwZvJh4lmtPpCVp8fW
	BCjsjB+CFu0MbuH5TTStXlmkev29xJVieLdR/+l9TS/5HKKdFRbWNGpIixb4RcuZWwdU00
	ZcBh1mvsfI0DsXF9OUqoWQh0MRDF2yY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Eep7lU+S;
	spf=pass (imf10.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5957e017378so1246609e87.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763667796; x=1764272596; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jOb5k3bbgLdxLAU2xBUhkNf6M8DrTXlh4mqXRt4KFAI=;
        b=Eep7lU+S5lpw3XHgncpg7WskeQDPksMdoi4nUnslBAPJELVoz90atwuAf+/c4jXwbU
         un46/LdEyx5Ngufu5pIsJFeSa7oQjuIBUpMmgpg4bAKqJxB27VPdUMMg02vSZ0o/bTXS
         Wj2d/MaMp5HW57xuMXQIxLcPsb5IPIGeM00T4/TxBGa6G14Z2xMURjmgT6/Axx4tOue5
         Y/Y3uECBJQX8o8cVWyAu63JYmOLcU9XwzSmkMTl+RJNLTXs5pbag+JH1Yla9DouSIbLt
         ZrDAA7lp1axupy/5qQ8x+2suKYCpi0WO+8Au5mr477e1niO1BfU/rxWvp0pKIO8nDVnt
         /DHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763667796; x=1764272596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jOb5k3bbgLdxLAU2xBUhkNf6M8DrTXlh4mqXRt4KFAI=;
        b=PvHCbN+xpBynHHUCC6zzTaOzgn+VrpQh3a6YQLDlmsrHfBBNFEYpWMcaz6TFusONJF
         dgFD6FkUTeLRdAzAlnbMydvqT1729Z1QGBdw2X9MnINmI+Um+gNNXWCxixKJLONUeRHT
         CS4IhuH2JmWrMjxFMC2gu4VsLNCRcdpVJUzJueCqtxPrZD0dlvk6ozYAHoz7TLTQ9YsB
         wF8G8FBI49grQTWhrgr+Uv4p7Ci8PhvvsNZlMmPGovCnuxO2pJ+5b2JBXN3NPMI0uc1y
         DBUUkULvrPKRY059B4blx+oRW0C73/fgBSP42+NAn3sXCbMY0sH1z2Ar9VjoRYONNL9s
         tSug==
X-Forwarded-Encrypted: i=1; AJvYcCVGNsyxXwkn3JhVZ6p8NGYeSXYvZEr9Crs2dxWe5MdZf2TSvx6U3UOQ/RAw7L9bp3mZUfZpKrHgyA==@kvack.org
X-Gm-Message-State: AOJu0YwC0Cxivv3Tqm69RIOxTS0wZ12yFbHb/Ea5l9lG0h34CRMTcE+G
	ik+5/jZIig92eiqgY3XNBcGfshXSDdHTX3lfAfHE+WwAF7Xid56DkUVkQq6Q5unhq9CGl7jq9Yv
	j88Xe/0d1oUHx8WEZ8RTFlg4BxPcYVusg8s5O8PZ3
X-Gm-Gg: ASbGncu9+Agfq9cBZupGaI6utlBtxsXv2FCY4ZcbkM6tpQOGhc4lO6YMMGZ/nqTyZes
	McGm9upzr3A08JreKKJCDL1bqc7vpwoSlEjDHa/xPbeKocQQNHyyRYsmhXirQITPn0lMCrL5FMI
	nTMx06ecxSHSxz1PcnVpCfrIW896t1tIOj1xbegJ/gpDwoTwBsZ93/1UpA7Z+MXjYEvc25Gu4wH
	SQ7t6+g0sOtTMwh9S9b07Qtz9z9aQRUvGoSvkyYDUSE6XpeCN/FuGEhsVFD+gD3tR+lefo=
X-Google-Smtp-Source: AGHT+IHcyfhgJOxNFwVB1wmP5vbwR6JERZRpaFBPUMh7cIOOgFdIrerxF5fqZb7M8NqokF29pYgwiXqXN0SorsacWb4=
X-Received: by 2002:a05:6512:3093:b0:594:346f:4850 with SMTP id
 2adb3069b0e04-5969e331044mr1508727e87.49.1763667795875; Thu, 20 Nov 2025
 11:43:15 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-6-pasha.tatashin@soleen.com> <CALzav=c-KJg8q8-4EaDC1M+GErTCiRKtn5qRbh1wa08zJ0N4ng@mail.gmail.com>
 <CA+CK2bD4Y3CMHcTGKradmv-hAbdtA7zsw2CYeh7-8LNianYMZw@mail.gmail.com>
In-Reply-To: <CA+CK2bD4Y3CMHcTGKradmv-hAbdtA7zsw2CYeh7-8LNianYMZw@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 20 Nov 2025 11:42:47 -0800
X-Gm-Features: AWmQ_blhAAizSjkijMqBfleikcubXUn4oYnXzPUSaeKAUDCiwV_6zW22M0WcB8M
Message-ID: <CALzav=dmFQr+BrqzRDgio0q68MPRVnZPK4-wUXVj47o1FObgNg@mail.gmail.com>
Subject: Re: [PATCH v6 05/20] liveupdate: luo_ioctl: add user interface
To: Pasha Tatashin <pasha.tatashin@soleen.com>
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
X-Stat-Signature: hxn8r1u14yhpjnnrzzx83t7bioy8isn5
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C727C0011
X-Rspamd-Server: rspam01
X-HE-Tag: 1763667798-510199
X-HE-Meta: U2FsdGVkX1+tfgG6GAdATkg/x+R0o6K+DRuEKKR1g+sh3AUyIgTvVwCPSYhyfbAv1/MLR1EXoD/Pm4vGDFYPdzR2iqkRFn6K2TFebspMFIYZ3ZCXWC28Ohnpr3NTG8eUNCBvyHVjBvzKoflPMweuvgEW0Jbr1+i9HvlZQn27XuJd0Tt2pjaNq5941nJiH70IogvtFnwPTlJUuPrDnABCgD44tNX6CqGMrX+7/XBQ7mvqKd02OZDlbv5zlPHdLyxEPJZhwqVcLCQD6Dwtu9IIj9rct2AqBMU4qTSYvj8EtaFpe0ZddPm7OuX7vrg2G+ZCQeGb+q6f2xj39Q6xQtuPA0wDkO5teqBdGvC9BOTMCIpXnudpz4ztz8rX4X3HAaTt/zqGNLwbLM71sTumndWF4FCHQKcahxJB/3BbSEDUYEz9cv1+gNOp4vIQYFgCD7O9WBzeaNkrZ19fq4ke+GIgLm5UX8Rz0EAQ4Scw0xSga29B/cQW9GzVHYIDD/0VG0fxTD0tIY5iUNRJ813widky+SZRDwquAkjap4G3KzpO9kbROfapSEhsGrJU0++82LRl/X07YyNK18pzdB2KwUZws10oajGu3jY9CtKXeCp9pS9txIJRQaJOE3D5HgMug2HJtbAzG3K9l2L09TpVaOuyxD8IgZKIzGxxp8qrSbUM1Rp2odR309IfuBVkuWqpe/nm6Rb/FnIQTbFHkrNkFoPK0MpM5aX+bo5wztLrrZvEylPF5sGIsfGkXO3MjtWx4qvLkKgA57CXSVgFq2eZc1OZRsf1EZG+BeXyzq2DCNjk3X2HIIbZK+ZAmNtEjyOhrJMPuwcMm7WrJl0w2AsfMZU0D7B/5qqSqAx29GS8FXqUmIbARxk223Lwke0LtiUkGLDb+Wuh3Ht0VGTUbtId943SpD4O4iywVXBeVsYUilQ8I1oC//25i9V3kTIrrOOrShb7XHf+GFr7bRAAjKVWpJr
 JITDaZHF
 wIDOkqOeZkYwKZ29NZMaT7Yr6a3+DmgbssGwvQfpGOWtXyZQNOtxDf1ZtsutZQqPD9J7GuOpRILsb/zM/gA75kfrsuSXfGDQwA4x3heyB5lsNjEb9ovr/UsIGFHOa4g3PVvYLjLFJHTu30jlrUiVulnFQdIUEro1D8QMnNOh0FqFfzdNlGRquMAnnjvmfhoc5i9HDuqUIBM1gIs6SaofwkviEL/FFjZcJX8ovH4fNQOhEN7WVkTtlrdLZNVH98ei7nj0sRXZlgp9V8xuMH1KV4IIuu7YMSEYBX0wjkhaJgfasUnvUBL7H7oRl4pGInp9pnC5WVXQx3/rQehQg9VuQc9tM3bjH8ImxpoILT1Not1aSlEnZTQg0+LpzMA4oGob4qq2Cli9VpQfbK0c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 11:23=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Thu, Nov 20, 2025 at 1:38=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On Sat, Nov 15, 2025 at 3:34=E2=80=AFPM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> > > The idea is that there is going to be a single userspace agent drivin=
g
> > > the live update, therefore, only a single process can ever hold this
> > > device opened at a time.
> > ...
> > > +static int luo_open(struct inode *inodep, struct file *filep)
> > > +{
> > > +       struct luo_device_state *ldev =3D container_of(filep->private=
_data,
> > > +                                                    struct luo_devic=
e_state,
> > > +                                                    miscdev);
> > > +
> > > +       if (atomic_cmpxchg(&ldev->in_use, 0, 1))
> > > +               return -EBUSY;
> >
> > Can you remind me why the kernel needs to enforce this? What would be
> > wrong or unsafe from the kernel perspective if there were multiple
> > userspace agents holding open files for /dev/liveupdate, each with
> > their own sessions?
>
> By enforcing a singleton, we will ensure a consistent view for tooling
> like luoadm (which will track incoming/outgoing sessions, UUIDs, etc.)
> and prevent conflicting commands regarding the transition state.
>
> This is not a bottleneck because the vast majority of the work
> (preserving devicse/memory) is handled via the individual Session FDs.
> Also, since sessions persist even if /dev/liveupdate is closed, we
> allow the agent upgrade, or crashing without requiring concurrent
> access.

Yeah, I'm not concerned about bottlenecking. It just seems like an
artificial constraint to impose on userspace at this point. The only
ioctls on /dev/liveupdate are to create a session and retreive a
session. Neither of those will conflict with having multiple open
files for /dev/liveupdate.

