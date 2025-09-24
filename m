Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25C2FCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 17:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB408E0007; Wed, 24 Sep 2025 13:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78ACD8E0001; Wed, 24 Sep 2025 13:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674048E0007; Wed, 24 Sep 2025 13:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5798E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:30:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB980160932
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:30:42 +0000 (UTC)
X-FDA: 83924833524.24.419AAE5
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 03044160015
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:30:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OedVFMIG;
	spf=pass (imf08.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758735041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5k4yjC+BSG1p1WXbj5tLbzcQV6kbIE3+SfAB1tB9E6M=;
	b=aW+mmQQqIc/9FULgvvxk/nfmofCyfoONVyeI0SizbTrO57coKCj68g3oALJofAKhaDlPpA
	Vl1Bfux6RUCzikEa72eel1KSLIYTP7HrUk4H+a91Q45COVXA3Sepi8S/pLWVZMyk8epcwG
	fd+JY2rGBuHZ+YDAb0H4pFYOrMlAfCs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OedVFMIG;
	spf=pass (imf08.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758735041; a=rsa-sha256;
	cv=none;
	b=eDSm0hUklpCsqOiAjCXh1ySrrpOYrIRcnnSB7JdxKQPeD1ObHHjC0lXJGuWf248aWjH1H4
	+WRzZevKgFfLiobuFh4TGWLL0KT/rQEjSSOR17SQ8ZMdDxhaPfXTNVXpogtjFJSxREgtEX
	CFBrJfg6Ilq7qH77ZHyCu7PacvN1fSk=
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-54a8514f300so61160e0c.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758735040; x=1759339840; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5k4yjC+BSG1p1WXbj5tLbzcQV6kbIE3+SfAB1tB9E6M=;
        b=OedVFMIGIl0/ogCJft+6N01JcFRnbW0l5TkavyBdGRIB6gN2ud01FrGBkb9rURvdEc
         uXJ3uPxRlEXgXkAPR0SBQ4rC5IvQnpRDkt50qjc5JvKcy/aq4OuHV104ob5khC5HysZv
         QJSwipW5wPAzylI3QprO6CqSe7I/+8Qg4Q4HMO1LTAAJKkhR5ubsvM79Wz4lMYGA+8Ds
         qSZlPR42jialMnFzdfAWnPwaTCeNLrOg0lhjJIA+LMh3vcUoTdXcTO/GyvjYj3BBw3da
         IQXhpSosh2BlR4f+IakQL9d1TsUTTIG2V/3caOGQ6th/REi4239XMrlNRbigUZzy/faF
         p8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758735040; x=1759339840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5k4yjC+BSG1p1WXbj5tLbzcQV6kbIE3+SfAB1tB9E6M=;
        b=dYn9sBn/6yWtNF66icUo0P4w5WRonnZzT6czEbtaa74tqQK8iO3kI8znNb0NOVX8Gg
         mybBrdgeEWrLy4+dAl/eUexGO4xPGSUOmS9wz4GnQJmBIO0G0EzjdUv4sv8Mo44B26K0
         xsAu/9HEyUIwBfHdoCzL64Q0eqAmL9vnDRhS/w7xet52oioPNyKT4gFUCFXQf0QeE6rb
         MTrJdrUG1exE1cKf9HFeiQC3U0sBdmLj+c+yXoyfnk6a7nnEQL+9oC7bS6ydZRC3zpIf
         NC+UDNBtr7GIP7wDikFXNA3P5QWCTrb89+ye70NA4rv20zRtglUuDxhqBYjGQeLi0Ocl
         LJOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbC9kQMSJ2xmN7YXh7KEVnGqwoxbmnV6os6P1nhPCCZ1sXSEXPPiKRCEEHcKNGycT8cQ+6okaUoQ==@kvack.org
X-Gm-Message-State: AOJu0YxUpMDc5jMihSxJz1uqBPSA11+c0eCNCgx1XrrjsM5XwJMsnNX4
	/B22ee8MOS+lrqkbNsoGxpaAuimnhUqgomgQgCa2a36242okpb0VKt5nylATT4skAcPSxUX19wi
	ph93jEmn/PsNKbTQ2KLPN2sEhJVzdJxnon49F
X-Gm-Gg: ASbGncvROAqOkv0QU5eaiLap7+KXfHjklZ3yVvrrVPgw70se0bz8rUyvcKJ2HoDx1Gu
	QS6FGA6KBo8pMLXP6EMUUQsVLtpSZtS6Tibh/Llc0asQiBv9KEP7V9/ioZ8JuD3hIozE7O9/eUh
	t636C2K38P4KCsozu0DBU8pNcw/LUHUT0R3XI/XxDcpH/trONlRZAPEPhP3J3iE59ABuoPEcVp1
	YuT7I2wrN+Ui4c2rO9utBbKb7wd/TzSdH7+ve8=
X-Google-Smtp-Source: AGHT+IHRUpk+l43lUEkfSvsxG/gFSXsSmy0Yb679EkTBjMcSGGxPm5euPRNwbWLb6UIPoPzyECrG67GnQN0NLXcRGYk=
X-Received: by 2002:a05:6122:a02:b0:54a:71f6:d570 with SMTP id
 71dfb90a1353d-54bea048358mr462955e0c.0.1758735040012; Wed, 24 Sep 2025
 10:30:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <20250921014721.7323-1-hdanton@sina.com> <CAM_iQpXMjFs4LmpRVNqxeBnFp4KxEfgi9cB_Jwuy7VgOSqTfsQ@mail.gmail.com>
 <20250924011237.7568-1-hdanton@sina.com>
In-Reply-To: <20250924011237.7568-1-hdanton@sina.com>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 24 Sep 2025 10:30:28 -0700
X-Gm-Features: AS18NWC4qMXjcqYtqwcv8qlLfwmYuF4gi5abMG-3xTy48-aZuz-HQ3CPl9ywuBM
Message-ID: <CAM_iQpUwm0wOQx3Epo-5MmkfwZmLsehx6HmABNwzqpRNiPjTmQ@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Hillf Danton <hdanton@sina.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	multikernel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 03044160015
X-Stat-Signature: fk3smtytp55h1zfw3dgc5ak6m7tbxcos
X-HE-Tag: 1758735040-593503
X-HE-Meta: U2FsdGVkX1+XJrzKFKLwH01ZZa4k/J7qp16StdnFjrv6xX+hAanTjtT+QVxuXhMcLL9HJI1k0RdadoHeLNVi8JG4n4qga3UZVpXf3RdcjzK7YydHxEdgk1OU0v4GOGu2nB4wfCJVAfjhkFYu+i9xS/qDRQHntQu2+HctcD7GzEV9PqLR4e7O5480ATbmV6bq2hvDheRTyGPl7NekcPVoIQKYlcJLZ/oSMtVfLFglTq3C4vHRYJw9lVvDq5ONNINLTU+PrRhliLxfGDgutemAElclIuZo8lM+hltyt79rzX6oIi8I2addW6uy53JMe9Cjtp0f2KErS/aL9dRkIvV+K1tSp9HnEK+k5y9IhCeBIu8QwKSZr6aEBozMjkogAlXWFD6HnG9/QXaaWkx9dFzzK3wELj/ZSDHBW1+D18aRPkYMlc/beMSm5IEhxbarYf3I1DVGS866CPJLLd1J6XAIG8MKbk+sXia+63yZf76JfLjEw91pZTfATGYLx5LWkWzTrzFfktL+z7DrAKDuD3gBA6Sc2bgcHHjMxNR2sSuu4DT7hya+JOUlZkbnB2gKLb70G0xiv52k+soqYtnoW3JOFDMO1HxraKBnDxFFoGhuCdP/G7lxdUCDjYcBoAFrd+r76ZPSxWLAZ0CO61UjVDBTf/fMEwLMVFoFxHXA1+Ws055xTk0WiZNyC1RT2zibSmdoFLdDumpVAd4NCM3Q6bQYA7cDaeInPctNvQFjPd06JJDXrDuQKvrJW597mdKoMuciERJ/E7TnaDCMvcfTThpInve3uveuYIH3qEKj7RsdJ80qWFiiXaxzw9Kj8/k3ME8aSawyc4CpfkHjlhuK6gk7BAZXgMirNCY1cN8UCJhVquchNQKPgEaCPa78+rskSLAugowYCe61o7TJjXRZyflFEfBhdPRqzNVhpswggnwyupKeT4lcIskOBtStGqU2VObIoTmdB29HjyHbpb9WZlG
 5id7fIcg
 SZXnoXTAXSnX0kUhqr/hzOp6oynTAgOT5KfX329VUe+3dc1H14dRH9kRgNIC2CwZmYb9igHRwDHuCY4sfLHWstefXRBUSvYNmR0ixzeKVMCgHqKsfdVO6Cq2iARnoT1WiKnSt27fvsSOSQijAabQIhVL0Hgd8uzqMiQG3cI2q3JtcaBwIExp+39NZX00enOZrH3WjlI181VhoTxX/weNIxoWWnjkqu+vUbdfyNcOoQk/whomGM3kLtWUR3em84+F48TrrQeVS+KVEOGqzpwQ+2KIOiqIq8XcJ0r4/WOsRgvnU7tJ1ykM04Fv+iszk71rdCw8EtMRk45dEHsaGKcxamsXJx0q274I8/yZ9mDzdo4IjkBl7x43yp2FNRagaJRE7+E/2sBaRbhME84zVzmlWkK0trsff5vQbqUzp7R2T5VBYE+i9LiTGqPmuIczO1RBc50f1/2RThQfJfM8Of9evWqpqJUA5iW+jd/3u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 6:12=E2=80=AFPM Hillf Danton <hdanton@sina.com> wro=
te:
>
> On Mon, 22 Sep 2025 14:55:41 -0700 Cong Wang wrote:
> > On Sat, Sep 20, 2025 at 6:47=E2=80=AFPM Hillf Danton <hdanton@sina.com>=
 wrote:
> > > On Thu, 18 Sep 2025 15:25:59 -0700 Cong Wang wrote:
> > > > This patch series introduces multikernel architecture support, enab=
ling
> > > > multiple independent kernel instances to coexist and communicate on=
 a
> > > > single physical machine. Each kernel instance can run on dedicated =
CPU
> > > > cores while sharing the underlying hardware resources.
> > > >
> > > > The multikernel architecture provides several key benefits:
> > > > - Improved fault isolation between different workloads
> > > > - Enhanced security through kernel-level separation
> > > > - Better resource utilization than traditional VM (KVM, Xen etc.)
> > > > - Potential zero-down kernel update with KHO (Kernel Hand Over)
> > > >
> > > Could you illustrate a couple of use cases to help understand your id=
ea?
> >
> > Sure, below are a few use cases on my mind:
> >
> > 1) With sufficient hardware resources: each kernel gets isolated resour=
ces
> > with real bare metal performance. This applies to all VM/container use =
cases
> > today, just with pure better performance: no virtualization, no noisy n=
eighbor.
> >
> > More importantly, they can co-exist. In theory, you can run a multierne=
l with
> > a VM inside and with a container inside the VM.
> >
> If the 6.17 eevdf perfs better than the 6.15 one could, their co-exist wa=
stes
> bare metal cpu cycles.

I think we should never eliminate the ability of not using multikernel, use=
rs
should have a choice. Apologize if I didn't make this clear.

And even if you only want one kernel, you might still want to use
zero-downtime upgrade via multikernel. ;-)

>
> > 2) Active-backup kernel for mission-critical tasks: after the primary k=
ernel
> > crashes, a backup kernel in parallel immediately takes over without int=
errupting
> > the user-space task.
> >
> > Dual-kernel systems are very common for automotives today.
> >
> If 6.17 is more stable than 6.14, running the latter sounds like square s=
kull
> in the product environment.

I don't think anyone here wants to take your freedom of doing so.
You also have a choice of not using multikernel or kexec, or even
CONFIG_KEXEC=3Dn. :)

On the other hand, let's also respect the fact that many automotives
today use dual-kernel systems (one for interaction, one for autonomous
driving).

>
> > 3) Getting rid of the OS to reduce the attack surface. We could pack ev=
erything
> > properly in an initramfs and run it directly without bothering a full
> > OS. This is similar to what unikernels or macro VM's do today.
> >
> Duno

Same, choice is always on the table, it must be.

>
> > 4) Machine learning in the kernel. Machine learning is too specific to
> > workloads, for instance, mixing real-time scheduling and non-RT can be =
challenging for
> > ML to tune the CPU scheduler, which is an essential multi-goal learning=
.
> >
> No room for CUDA in kernel I think in 2025.

Maybe yes. LAKE is framework for using GPU-accelerated ML
in the kernel:
https://utns.cs.utexas.edu/assets/papers/lake_camera_ready.pdf

If you are interested in this area, there are tons of papers existing.

>
> > 5) Per-application specialized kernel: For example, running a RT kernel
> > and non-RT kernel in parallel. Memory footprint can also be reduced by
> > reducing the 5-level paging tables when necessary.
>
> If RT makes your product earn more money in fewer weeks, why is eevdf
> another option, given RT means no schedule at the first place?

I wish there is a one-single perfect solution for everyone, unfortunately
the reality seems to be the opposite.

Regards,
Cong Wang

