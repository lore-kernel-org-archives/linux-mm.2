Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 229C2CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 02:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517218E000F; Sat,  8 Nov 2025 21:32:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C86D8E0003; Sat,  8 Nov 2025 21:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6F08E000F; Sat,  8 Nov 2025 21:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 253218E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 21:32:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7A7C4C1E8
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:32:33 +0000 (UTC)
X-FDA: 84089494986.24.433EBFC
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id CD2CB40006
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:32:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QKXAkTbz;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762655551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3sUd4yemanGWTyJ8Beqz7xtQVHp5hlUsPWyPSJXOUQ=;
	b=sdMS2DvFde49W4DI7BCmcqZKGA0tkZ1qxMD6aJ8xbnm5dVcQFOP4fNMgzTsF3T7mfqIqy4
	VYPi6CRFUYBxyB0h655H+03MogEr0SIrEqXtRLDyU6kT4E07CM6xXqxV0MlUdU3u8OgR1Q
	+28fc7toMQSL4a/Lf5vw5qLIROyfphw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QKXAkTbz;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762655552; a=rsa-sha256;
	cv=none;
	b=P1T2oPCeqG+vDw77rBCRLHK6jVNlVWmtedlvD19ZCRq5iHXFjFBdpyxAHODSbUFTKWjA/+
	5HGEiUShy7XBzOKuSlbeYjq9PMo0MPLXrpyz4LTnqOlwBGqrEXohRL88AneosohOJLf/r+
	R7BvTEi1+LPM6qAMvSNZn1rzfm38qOE=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64180bd67b7so104288a12.0
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 18:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762655550; x=1763260350; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v3sUd4yemanGWTyJ8Beqz7xtQVHp5hlUsPWyPSJXOUQ=;
        b=QKXAkTbzviFAlb7Gd2nC4R4aKERZQnJzhU8nS4dFTW0ERJIMc3v0/iSZQGbnbiLkIF
         KIYIT8N8vYgFzMyC4VdE+ddINwlg2nnrRX437+kY7Pet9M4YC82L5GM3Y+6ip0yHMK7y
         PxLXykl9rDaoV5Wnh2L9jYTw5iap4JXXA3huo4BxgOsza/jcbg0XapDMa3r9koWopyli
         H6pt6Kuvw/wvjhmxGMQcWdqS/6XvaKcmEYaaJm0/wT1EgYHZD9yvgFm6B+1eQwBoP6Gh
         mxYzjhPfkk495a+iNOfvy52S+FWL+Ck5Ax0oPVVejfxdJ6Bf/pSftDmod7gpSdTGsbms
         MBmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762655550; x=1763260350;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3sUd4yemanGWTyJ8Beqz7xtQVHp5hlUsPWyPSJXOUQ=;
        b=QO2iBbAPK392Weld8KTfU49IJZVOlRhDVD/zcWHSZfTqOpyYxpLAeypS0th+Fjz544
         5PpSsx/C6Ho947LVpRghk1NTKJWNVaJeXvmjBuuR8FSmYb0BswMb2Ce0qgzk+h/oKraC
         4tBwiLnPW59yZdggAAEsdv8k5cAK+80wsNKqLdIE11ArsmlWrQheswx89sNYpdBbzZil
         roHky0gP+vT7lMQVb//bv3XKR1mOsL/8wO8Fl1s6QyiciaMu6pOJ2Aaj+VVz/gVN8rpq
         v2QNuAmvO5C7f3/pi9QND+4538Tmp/ldt2ipg+elBVY30pJBTlOvLg22pUtfyF3ikgUE
         ikqw==
X-Forwarded-Encrypted: i=1; AJvYcCXxZKC8sBewfe+nuij9haWoRw/TQ47OxtnymD25beBrJT9gulpT2DA01hEyNqCwe+7sVKpmxmylPg==@kvack.org
X-Gm-Message-State: AOJu0YzhWGVfIW9zo97wBIUXfHIpEIIATFKpEKBJrRt9o2FVZba+HtxT
	Cw4iQp7+I+ynLP6QasHXEfSVhUyANd7Er9+MGLCbyecoUC9byY5d/YFbcHOAabiTEDG7zEjDoFw
	mWEfGpa0eg0iHRas/irNsH/FngpmjtynTjQIBwPx53w==
X-Gm-Gg: ASbGncuDw10fG5yYjgt9tyHhuOpdaYMDV6UPPLHYj7fUFhB6wVH4O364PVITOn3Qbwv
	WWk2Np/h6lzG8mKBmx4qbw5plZSjhR3VwC+apW7lMB0oEe9yZ1WdYjXwTp5awNJdfDvuNA6dFqt
	oMYiwknNLG/MvztCeAYQYEkBrfWovAvNt+oiTiZDb/91cOBRAVx6CXVQ2zw6uJ7Rvl8+2Xm80PY
	wJcSq2+Or/Zbx02kH+1uVl/fOd/cmzgM6OwdC7ib0RCD6QBobFxUR2G/Q==
X-Google-Smtp-Source: AGHT+IGkPxaoskiODxv8UFWCdDvkCCatOQpLUt4UqpyBbWyWH0iYYiRs5ogfnHqSYP0nAMnRxIXTeT8EwyG6LMTSdO4=
X-Received: by 2002:a05:6402:270f:b0:640:b7f1:1cc8 with SMTP id
 4fb4d7f45d1cf-6415e822f52mr2906725a12.18.1762655550218; Sat, 08 Nov 2025
 18:32:30 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107143310.8b03e72c8f9998ff4c02a0d0@linux-foundation.org>
 <CA+CK2bCakoNEHk-fgjpnHpo5jtBoXvnzdeJHQOOBBFM8yo-4zQ@mail.gmail.com> <20251108103655.1c89f05222ba06e24ddc3cc3@linux-foundation.org>
In-Reply-To: <20251108103655.1c89f05222ba06e24ddc3cc3@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 8 Nov 2025 21:31:54 -0500
X-Gm-Features: AWmQ_bkVcbxT0gV7fpmnxd0SCIbpS_2m6TSXTf-t_TBkr04sjlFMoWl4do6gJ2w
Message-ID: <CA+CK2bAcQZM76dO2pHP0M1wAUeq6m7kKijSxoWDv7fvyreMJ1g@mail.gmail.com>
Subject: Re: [PATCH v5 00/22] Live Update Orchestrator
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, tj@kernel.org, 
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev, 
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com, 
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org, 
	dan.j.williams@intel.com, david@redhat.com, joel.granados@kernel.org, 
	rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org, 
	zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD2CB40006
X-Stat-Signature: 898tyuskmicy9zgiesnung47tfu9qci1
X-Rspam-User: 
X-HE-Tag: 1762655551-673785
X-HE-Meta: U2FsdGVkX18/5MX9xZUKmRyliz2z+FFlfQ6frRr3MaYcFnVPjNpCKx4TQ+pwGSa+dfrf3G9P7z1u64AzDkEIqNyVtOLvfA1yYm0OMJ4Reg+A3uEUWv5dL1mvenNrzEw8sP8Z1hM+RxGG1+b9xL6hRwAuOYYq5v1e8wvpUZa8CHqTvMXBgfkYU02DRGzChdZn8ceTEKE+eG/K5qX68rQ4tJtAN1/tXxYgX92GNNGEx04YGE+1Nvlakyc27zK6gnaXOfDtJ/j+lUBwEXBEILtZDfxvznVf6Q/1qv513naWQJKQV9QrzXSDq2T2ZxWi/tlKrXM8X+ZMNvU4Due6E10jwXezU42FVkz1Za5T/05sQO4D4CKGPD2PD2cQEIPl3mWFpw37ZyjN/HLdYKXdC17Aj0k0b8UWZ0zIjZGHjUfiPYa80hNO3AgzOD8dRXOg6Dt90fFDh63iKyGxEvKW+zGHLN1+oIAU3txbHJBsWuPMGi3sBcKbmxs1wZqQ47KRl7S2HrnRS234Z2K6pfB7dQBO1b8HuH6Djs8GxLKG10egGqB/T4kMB+XoK833Q1KJtaNsMoSjAeANAVFg6CHur6x/gAGaGhCWAuyYbik/1+GvfSrgKhukXes/jYZjkKGiq41C4nqlF24OK6HC3+dKFuIgOlaidmBV6VLtPToOWZmM+zhA9t7zbAqG1s5HNbMQnks3CkmSZXl/Ph7onDvLetnOkbMQd3nbYdRx3tD7RDmPNPIV2ENl++Z1+qx/M1kaWwTKjxHvWLMckCDZkG3M1Szvd2MnxdEKJeqVVV49mT1f2A7xb5nqa8hpvFivYgTPjmNrFiOcCIHvuj9ncXz0cAUsPiWLdUJLhj5gtmt9Eb+3FlR8HTJ0ehwo0YtA3ewxPT4d1LtBV4NXus4uogm2ilKUBIgfEt021w2HPvuG2Djj0VgfD855YxEQvgDjvkaTGBWp/n44XjavDiR9CXGFIVE
 BSqfJiz1
 L2Ol09x84QTuYDgpZsRq9q3A2e2LZTYOYgvkkBdy+FddySqIVORF7pBspNEWtNjOtaxh1O+eR6HG3XpwnIy8wEgJHqc+T4CEymEuLOKDjCuvj0Vk004tBSvonQlOEynlOQkhOyGQxamCuvBZ7g6tqafmWIM2dDG+XRwdQwBT5lcfe87YX/jiQYvUPuf81QCEWUvp78CQd3esUGs/tzTBIF//3qkA6Hv2jpXBdSsTk8zWaGlHahbXSuxLgdEZnzRBwLJXj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> No prob.
>
> It's unfortunate that one has to take unexpected steps (disable
> CONFIG_DEFERRED_STRUCT_PAGE_INIT) just to compile test this.
>
> It's a general thing.  I'm increasingly unhappy about how poor
> allmodconfig coverage is, so I'm starting to maintain a custom .config
> to give improved coverage.

That's an interesting point. The depends on !DEFERRED_STRUCT_PAGE_INIT
reduces build and potentially other automatic test coverage for
LUO/KHO.

We should prioritize relaxing this constraint. There are a few
possible short- and long-term solutions, which I will discuss with
Mike and Pratyush at our next sync.

Thanks,
Pasha

