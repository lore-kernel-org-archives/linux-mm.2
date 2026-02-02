Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACF9CE7DF19
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 18:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758AE6B0005; Mon,  2 Feb 2026 13:15:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730896B00BC; Mon,  2 Feb 2026 13:15:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611F06B00BF; Mon,  2 Feb 2026 13:15:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE3A6B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:15:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC9B757998
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:15:28 +0000 (UTC)
X-FDA: 84400319136.11.A010A99
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id D159F10000C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:15:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pRuuNyHS;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770056126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIHmbN0vtM4SeA7+jGmffdOqzfQaVyhc47MhdLc1+1s=;
	b=vzigZJv3m3mCmWiw1l1FouNhcB8CgFwXhJf82G0IvXpnzPkTrZH4GVJiVeC9GBMs3DTK88
	q9D5bESb+3tbQkoh+OV5idrqpuZ03fSRAf+8TFZLFtz84Xbx+Xr8H4Xi9ARtpPYchBj21S
	P58Q5y5MBSHkrHWJ5f1HiJwyq/oKuKA=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pRuuNyHS;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770056127; a=rsa-sha256;
	cv=pass;
	b=kePXix8wOXHrEw07wAFZg4AhtNzV64gNWe5XhahUYulYzs8+T9ekAtQ7xGxpD6k5op/ffu
	41xwCCo23eWUHzmMBiO5x7JfphyLgFXAHz17Ebr2VnFRbrvXR5/qkpxC9HtIYrJqJ/8U1a
	JZJSPwmUu0sRQUkNUUS8d+6SwFmo9go=
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-383153e06d6so43313331fa.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 10:15:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770056125; cv=none;
        d=google.com; s=arc-20240605;
        b=HLeZtCL+Zc5S4oKs4BOXTvlmQhIFr9hdOBZJuzWysknQgJNVKRn+lM6V4D6EKaU9pL
         x8FYjeGrK2Dt8stq3aUpGcW++uHRKNKbs3+XfhytGQx1rsuuwfC/4rFPVCIPKg2I4Fv5
         3/4zt+wzC84WPlm75jE/DvkSxlduZegGFqP1tvzp/H+p073MzwHqWAjjafMULIb0y21z
         6UzDPmb6+wR4qB7I78AEXxpvwKSfVLW5hnnu2WRWzCl7Gf8356vsrOFRQISzffoT6nEY
         mPYdreJs9YYeWZhB7AD+jEeDWDFw6+K5fwZ49tIP31Yv3gJIW0EsvrHm9t2RN18o0niV
         nsmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LIHmbN0vtM4SeA7+jGmffdOqzfQaVyhc47MhdLc1+1s=;
        fh=yMdTen3zkZMode4XsmUYsKSTTyOQ31ntjZl8l85Us9Q=;
        b=jNqf+XCGTiw9w/JwVGBhs8nlXADUd/OgHahnQeYwc85IfY0h1zDkIJP90u5ggYUyxg
         Gvj+BE8kGq7t7fGXFVlZGz5w/a213aURItZGQaeXbF8Bg6Mh+UTPAncFuTi6yKQpMwfI
         0q8GOnkajXf9UFmoPYIrmNFRxA3fKY/+DtWKdDeyv1VlnPvDRI3HgH3OuqkiWwQ415St
         9sj+glO+bjIPz/kOdxv/wSDQq5UfYQTcsGmdxNA10XwWrF7CcFapHvH8gciTzwghNvAP
         8oTy+nteZqcpCVFsLWIbc8i9QzNQ61so1Y6ZaUTnCHnCuuCT0978wjrJQh4NTxo6U6Xf
         Uuew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770056125; x=1770660925; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LIHmbN0vtM4SeA7+jGmffdOqzfQaVyhc47MhdLc1+1s=;
        b=pRuuNyHSYa12BPvsYtLNTg41IP3r8/2Zh7nhc3Oe51DuFuU9naXPc/uo6KClEgw4WN
         bQuqEs/z5bdvTIdtf5I4OtByIPRBpJVQXd8IpdS0bYJX7PjusB28lbXLi4aUaPZtvdN/
         Mv6/aadzeL3DGZjJRL6bUBu0a69/ilHIMt/Ctwd5ceZZYw8Wd5ojhQZDgVa96kHirUjG
         +6bfojusCrWBFs8SxWmP4s1SovSbOb8jN1kUVsSjByfUc6b9EVeYX10nw4v20Ti2j9BW
         4WARt2FQZg3P9FmuzJw9SHACgW5wvIgcsNslt79rgM+/nU/BGRPFCGY0oT7RES1B+HTa
         oGBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770056125; x=1770660925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LIHmbN0vtM4SeA7+jGmffdOqzfQaVyhc47MhdLc1+1s=;
        b=Z4WjPw/PFA4mMbTSkGw17us033sMu3iIk/XFYPYWGjRIQsN57c/SQb50AUWAx9IXW+
         /KHFBWbsvnIoSf0/fA2KT0fUK5smhyzGEApKMJ4tlzdMeg8Btg1jUClL20UDk3TcA9xw
         YjkWgjUxyBauT8W/ZmPopZGBLI8ptB/s7AygA6nI33j7koVEZGdpchXZFnfsAUL38xJX
         rd3Sy2+gLXkA1Ad+iS7BJ21CWUrqXHbMolIHbORDCV+cHWEAHEfLRYmJS3aeSEchOtY7
         VR4rWJRBuKxhnrW9QK0GMbs8Uw7Mal9lMnSZLHcxSRgj9bhe1w8oImXdyWw/9/XyNrNF
         XPvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVKqd4CU+UYcBFj0gMDvegKMlvT47AR+uXBIa1wCXX+aBEKjmItMBOfA1g6o92wQ+qu8DNHKWGUA==@kvack.org
X-Gm-Message-State: AOJu0YwEf5fxZsCTD4L1ZZ92Uv2nLSfvdLfAjAXavwESJItNoIeOtBLz
	pyyeQLxHcheTOg/MXy7YVR8y7615j0ywJ8ZHhEWm5iL288eYW++1HgPquDFEDp0v6DAeoqFd55o
	0h77mNSWRXH/c3+YFYrB4HU+s5Vagfw7kzp8gbPZz
X-Gm-Gg: AZuq6aJ/cwpWnrgSEB3a1cQv9/5yXQjTDPBznObCMynojxt48p81j+pPfkHEnPm6Vwe
	AgiPuFm2L6RJ8ZJdXRXW0D2zTeayc3/zmNd4qJHDkBW/tQ60ChJZaKg7Rv7X2HBzoFvyaSG+Yvy
	sCUy0CLPcc74sm3F/1qS7N/zxuILWzZPpKvnSYYppgLY46SFt/NXgAUymHy6VjnFAu0EV/oa8uW
	qi9IQ7bQEKFZDFV2I8BgUMZxWDdFtzjKcYzNu0Ky1uAbo1sdd8jZQt0Q/BMubLQ/6xJ1Q==
X-Received: by 2002:a2e:a54b:0:b0:383:1c18:ade6 with SMTP id
 38308e7fff4ca-3864662d728mr40696471fa.20.1770056124374; Mon, 02 Feb 2026
 10:15:24 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-3-dmatlack@google.com>
 <44484594-5b5d-4237-993c-ac1e173ad62e@linux.dev>
In-Reply-To: <44484594-5b5d-4237-993c-ac1e173ad62e@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Mon, 2 Feb 2026 10:14:56 -0800
X-Gm-Features: AZwV_QhgTJZ7rnxODmCU1qhjsI1pWSHh1k-rPTozueyr5OUveeJ2FC59ISanCNo
Message-ID: <CALzav=d1ZrHrWd-HhZJ8aY6aqxkBcLoet_5+-LL1mOakVTj6Ww@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 1dnna9mwghpg1ds1ujrjpjitfsxxtzoy
X-Rspam-User: 
X-Rspamd-Queue-Id: D159F10000C
X-HE-Tag: 1770056126-363112
X-HE-Meta: U2FsdGVkX1+7+yKSexld1P+KlCE3IrrfpABZ/zWuPcG37PAWuXE/fw6qkMs82oSTvmquwRYLZklztsAPaCe+7bo4j84TvL2wQGuGHAqLCYzuZhI05dRATwZDAcFy1oQHv+giqtPfIoAMVfoO6NhrqkKU8A9c5Y0d31ue4ZMcZ4muFop6F1v4cGNSpEtiITVTxPsH4LAdQPmHXRarFCwcr8i+SOK+BXuYmv/Xqd7yiVXH57hM8ERHRRJTpftQm+YFffBhjLUL/caUzOvO2hPi3bYDVkZB6Q7AaBmmS2nHCfNWJiHRTlhkYQzxuDcZMA9zQ08zKW6fsuSGWLPTPtcvKXCV8wXafPvcG1agaxLrhbQumZagPu3R0iy2qNmenHzQG6hE9ADM+Ol9ZH7kItBTo6RfiTwRRoAUFok7G9KJfqdrwnjQS/Oqkhw0tkVd+G8vgbPOVTLA5PcsY+dNaRVxmK8EVpt3ze/HX1pNPoWgG4pB8tiKYAh9gyB/gEgrjb+EsYfjg9Z65iOjc/JbV+jnhljZgbOhE2eEPenArPK1V5E8zkpEk7jKT4d/Gz5N6uXbFxLLMEtBm/NAbY+vHo6ZmZZ+q78XWEWbDfh+nnib6ly7TuNty09Z8F4i7eokocWVWkF6ng045dAMQocLSPdmc/gPtyX8X8DjYASDmk3Vj43au1lZxEfI/0CQ2bVWpYueCl9ii5vf9h0dmigt/pMnJLwYC+YVuRajs1BC0jfbY2ID8WdNHHPNSquevK5CF1nSFBg6fUkWj2oGYlAQayZL9LnCJh+rKVpIB9TXrOBF/vO91rYmu0ykxUbwW4V3rXD/g7Fe5cvfoOPBqVezsDT0fTzTf7AJTvOcm0COjqflb7v+p+JFXJht/MQbnE0xyKF5xonrMJSGRj4t/AQ5jvDV9yGFqT9Z4xvqTvC9opOv6Ti04Elo5FyeBupasxTk6/IGjI+vXXubhQrXqX3NV7w
 3I4rYElR
 Lfl7dZHU4yzZFji8jPwWoqQflM85TCcyREwjYW55WxoR+dM5lnLZGDijP8+Qx5dfV5nqRjj2aMNeKtWZ85GIkuRHBjTcTY29vNT8+CqWUsQHpBfxGLVfZ8aeQ3tzQVZbMf9E6s6Nm/X40ne6gKe0UESboZGkPWZ3Cie9qwwG9l7JTssovlTOKMGncs5J0EwmT7nEkPsvmK+2HsawXBKw+511c6u3lpcoeoo/0iDwXKUoTQr8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 31, 2026 at 10:38=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.dev> =
wrote:
>
> =E5=9C=A8 2026/1/29 13:24, David Matlack =E5=86=99=E9=81=93:
> > Add an API to enable the PCI subsystem to track all devices that are
> > preserved across a Live Update, including both incoming devices (passed
> > from the previous kernel) and outgoing devices (passed to the next
> > kernel).
> >
> > Use PCI segment number and BDF to keep track of devices across Live
> > Update. This means the kernel must keep both identifiers constant acros=
s
> > a Live Update for any preserved device. VFs are not supported for now,
> > since that requires preserving SR-IOV state on the device to ensure the
> > same number of VFs appear after kexec and with the same BDFs.
> >
> > Drivers that preserve devices across Live Update can now register their
> > struct liveupdate_file_handler with the PCI subsystem so that the PCI
> > subsystem can allocate and manage File-Lifecycle-Bound (FLB) global dat=
a
> > to track the list of incoming and outgoing preserved devices.
> >
> >    pci_liveupdate_register_fh(driver_fh)
> >    pci_liveupdate_unregister_fh(driver_fh)
>
> Can the above 2 functions support the virtual devices? For example,
> bonding, veth, iSWAP and RXE.
>
> These virtual devices do not have BDF. As such, I am not sure if your
> patches take these virtual devices in to account.

No this patch series only supports PCI devices, since those are the
only devices so far we've needed to support.

I am not familiar with any of the devices that you mentioned. If they
are virtual then does that mean it's all just software? In that case I
would be curious to know what problem is solved by preserving them in
the kernel, vs. tearing them down and rebuilding them across a Live
Udpate.

