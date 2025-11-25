Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EABF2D0EE04
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE906B0008; Tue, 25 Nov 2025 11:10:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6386B000D; Tue, 25 Nov 2025 11:10:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E31A6B0010; Tue, 25 Nov 2025 11:10:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BECC6B0008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:10:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B90B013A32B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:10:26 +0000 (UTC)
X-FDA: 84149616852.10.82F9C3D
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id B46CD180019
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:10:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iJx9iAdO;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764087024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZjV6DtXhsZ5AkR3PkxyMa000cMnBKP6+/LjP904D4A=;
	b=Seu8d/yVlwbwh+PxounrjHj50uXf5fdagJnk7CW2cl2WFiNy/V9wbXkPgrLJG0L/XtdUHE
	c7nJV3ZvpXN9fYcgMUfGIyjmVRLp80fy9SSIAqZU9LWG3CVtXTIGp56GT27BEr/cnsCKll
	+F3OSSXplHLFm3d7in7xhZ+CUCdGAIU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764087024; a=rsa-sha256;
	cv=none;
	b=fDJVMhcz1R7UjEF7FjCBmKNhPeXrUrN1pvP4VjqSPKvvl5f+JbYx7erZynsn+AkwATLhLb
	e5ycuCCgshj2uyE2U1m/+/tybU9TJR0GOHGRfAd9FbcTjSFW0ZDWcgTALY76xSdPiOsKA4
	gg5wCqZNMH5gNgWldai7hZazUjUwau4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iJx9iAdO;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso2159379a12.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764087023; x=1764691823; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ZjV6DtXhsZ5AkR3PkxyMa000cMnBKP6+/LjP904D4A=;
        b=iJx9iAdOcaku3UprwTh5EyJbnRrBzrDxd0wYlpWqX5qT77jo+uiRuS12Loc81Q4Lqx
         h0xkyLTh4nItIaAjplOBdq+yfjebdutXJvXkJyF0fIuRryo/1Saiz2H7LxKVQzpFHrx6
         8GVCwS4grlinAn/+16rfmluEsI1kXl4fvBuQeavKJuZCi5Kon8AcwK0fThjvQDfYDQHF
         9MpGXL/MgCEuIwzOgWn90uXG6hirjDWm5knUwhKeMkB1uFh47Ax2FV09kUB4RVy4n+IA
         Qxx5RPi5cJX/UJW5EaaIyAZ85IVunptqItDfVnaCqTcWrLVUb+7wipbFfkLiTuVv3Oi3
         7vlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764087023; x=1764691823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1ZjV6DtXhsZ5AkR3PkxyMa000cMnBKP6+/LjP904D4A=;
        b=Adnv7UAdTocbkg8XhMRUtp1/klAEwFnrsLu/eRdg6ve/Y/hmz8aKQYB1kQGUY1I92P
         0yd0Bd7Y4sqRK4jjgT98f+ecr+aqV7xFfD1z6reuIYSVqmWJrrh0/ElyFH17YyCC1PFB
         XDNCq8gO0pDNZczNE/0cSpd4QQduCgYtTGLPEbWYwCNgrUcvTxsx7LMPAEj+D3wojjal
         VuQsJMEkyrXKMjOzxteLPFar/2TkL2Vfgnq9d9h10wVJ32f4Z9viE/KAxroEw/TGJMUu
         q/l7b7iyHongsllF5dFdNvaQUS6NyfswR63gL3MB4md29RwB/GFrQ7/rcZ+JSs9+uOx5
         hXgw==
X-Forwarded-Encrypted: i=1; AJvYcCXogvjEwDV0JIqyWgse1l59d6ApoZUPnJ9GhbWdzpwJTnMJu/53WqIwL4hzcTN3MyFL5232T8RoJA==@kvack.org
X-Gm-Message-State: AOJu0YxARyBK9X/mHmOq+XoTEt5t2t1c0BdPZQV9y5Ka2S6QqwiGEmpE
	2V6SCjsN/rfE3UWvhd1s0dvfhXV8eWdidG3yWe3w+whWJOpEDvYPOLzsbPOFKeKah8z2JOf6DeG
	EdAU9+nOWiixRTbnzKx6uKo9Tnw9IuOAWdRi1jtVV5g==
X-Gm-Gg: ASbGncuH2YJ6KaQRRkY6D38zM1xZ9T2LxOelOplItmCyE+BgHJwWWYryX3eispbumrA
	X6PoKlbU12ZgGzjIgNgGsJJrSgh5ggpfHmG4tRQrrWXK1h9nSQmpBOLCPU9m/CZyDT2PqF6dW2S
	NIBYuUDMUbzhrb3NcORVnw3qQIpwNcvTqVpSQmiSMKh2Er2BDDP1uEFrjOK8ENt+Agpc1EoHxR7
	u8LmL2m/aW5QFwkqL1lDA29DfEHX+43SEcZaNBSZkxJ49sVJ5L2q3M8N/OW5dzhAOSE
X-Google-Smtp-Source: AGHT+IEE8pFdl7WzD0Q0QybPHjOSG7Z/5A80NYawnvCXoY05NDZWq/KDeZ5UjLXRkONdwsanA3Sa60SF0QSqqiKVFUw=
X-Received: by 2002:a05:6402:1d1c:b0:640:aae6:adc5 with SMTP id
 4fb4d7f45d1cf-6454ddd44e5mr11579420a12.4.1764087023025; Tue, 25 Nov 2025
 08:10:23 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-3-pasha.tatashin@soleen.com> <mafs0ikezzf30.fsf@kernel.org>
In-Reply-To: <mafs0ikezzf30.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 25 Nov 2025 11:09:45 -0500
X-Gm-Features: AWmQ_bnmED1MVHVi80Cm4w9yINLIQ5SIv6ctTKaf0R1iFr-NNvQCFN256DGI_UI
Message-ID: <CA+CK2bAbKLocBO8zrhUaevXtsF3BMxyaVznOwSTYxFt6MjYpxg@mail.gmail.com>
Subject: Re: [PATCH v7 02/22] liveupdate: luo_core: integrate with KHO
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, dmatlack@google.com, 
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
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B46CD180019
X-Stat-Signature: 54crq5febw3qjccetrb5rznpt55bdtsn
X-HE-Tag: 1764087024-833875
X-HE-Meta: U2FsdGVkX1/xyAgD4rv7adRm675D5jHuCOZ3aIbZGRB9vNsNXk8W8zB/OollVHz47PRP2lAy0mMOoGP0sB20fQWrOK/TsTCgdE2o2Nflk/i4BqaYqgadLoPTgLBkXnoUxfBjdmeZU5Gu/UpSU/+M1mi78ZKoZ2dbTmt8bvfLs58xyK1xgqM/Nmx9ichHffaxIObRKCUVIWUUrL8OtxbHUlJ4vq2Sw0FjzXwZDr+MzPdz2d/1cByVhA5g9zqr5QMFsATrMGeLlIPXsYDAXoCIvnK5SQLo1b6c+/Bpi9Au+MRRSvCy6363dkaJV5tWqpmXjdHljeMnuEfzq0rwpVrfI+R03vRixO6FduMnKsy2U+lBA7kBnKH5eMGNh7sWMHTG/UKL8D1t4UGoncLbiG7YzW8sb6kkuNFEiGsipTDVXlhT2quHiOjurjzmy9bAimWCF+SPSelSOLhR/fT5CkfgqquECYrNJNLVTgVy3zUZW5ix1qxUmPL06chN4sCCg6K3HWEC4sBXhgOsU3SN2BGWPoJfZIbmqGmXXa+nz+uOmCbY6Fai2fIr/032BqHUOotOcTnr+IvkobP2aBRthS92QW5RlQfmo/ZyT5M9fwC/Rh1LqRlg5TXqR4eM+J87FBUkooh8oPqJCy5sta8PkWF01vEdbypd6SrhAfdv6zDA1Md3CEbBu6NSITlpvPBbCWgeDyW2K0OuADkHDTikiF8gH99xD0CuDYRw+adaSDQzCdfn4Gr2r0Ehr4YcX804CZc/vTLOEsN1aoSMNSMLK8QBzvyxNatKArvPbgPBiZuW0xMhauGfSiA3HDcw1nswmvS44KYyHZk2SJnI1q3vtB5XGlpTsuI7RWzuj5Fhpsv4Qnsl5ZD81J4LiBVZ430yCZsUSSjPotRo9o+c67TOFCbActaDkNPcYREPvF/i2fYQ+/BDW0Vf65wQNhwZDasPqQ8Etk8BXN7fkeVbGIlf+h8
 nrOeurWw
 AwFVQj9mTYsUd9wLtI0+HZHPzNjjojMG0uZ3rCXGp1CVw97ur5O3ERnIt/IrEmbRg4hXY71MfXsW/kCNb43vTQTQD6Y/CVrccsFw5nle/bVC2ZlSiRX/UcEKDLkrF6420+BlMHDPG7ZIf0+57yV9y+74iOKWdZIgp21lK80pUBotrbExHd3l6pSHa6W6/08xqxGBxxyxmaSviW5lLWgg5bj7DI/hciLyaAw5KPkT5+7GgJR5r0EF7c9ien4pm/I4Avdz6I6sIctcgUlAqch06l3nrrYZvvR24vU31e1X4CTTvDKKTuzHF0umnnMkHCg55tnVBOIiYqDlEgSA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 9:21=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Sat, Nov 22 2025, Pasha Tatashin wrote:
>
> > Integrate the LUO with the KHO framework to enable passing LUO state
> > across a kexec reboot.
> >
> > This patch implements the lifecycle integration with KHO:
> >
> > 1. Incoming State: During early boot (`early_initcall`), LUO checks if
> >    KHO is active. If so, it retrieves the "LUO" subtree, verifies the
> >    "luo-v1" compatibility string, and reads the `liveupdate-number` to
> >    track the update count.
> >
> > 2. Outgoing State: During late initialization (`late_initcall`), LUO
> >    allocates a new FDT for the next kernel, populates it with the basic
> >    header (compatible string and incremented update number), and
> >    registers it with KHO (`kho_add_subtree`).
> >
> > 3. Finalization: The `liveupdate_reboot()` notifier is updated to invok=
e
> >    `kho_finalize()`. This ensures that all memory segments marked for
> >    preservation are properly serialized before the kexec jump.
> >
> > LUO now depends on `CONFIG_KEXEC_HANDOVER`.
>
> Nit: This patch does not add the dependency. That is done by patch 1. I
> guess that change needs to be moved here or the comment removed?
>
> Other than this,
>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Done, thank you for review!

>
> [...]
>
> --
> Regards,
> Pratyush Yadav

