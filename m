Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39CF8CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266498E00F9; Wed, 29 Oct 2025 16:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2170F8E00B2; Wed, 29 Oct 2025 16:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1062C8E00F9; Wed, 29 Oct 2025 16:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F387C8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:44:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A71E1A6194
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:44:27 +0000 (UTC)
X-FDA: 84052329774.04.AB1809C
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id B206916000F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:44:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=af099qNV;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761770665; a=rsa-sha256;
	cv=none;
	b=z8XKMxF3ElqWILdhTu+UXmEPxC3lVtGBsIUu5bvxnDXUkbq1PC3DOWXrI4HI2rP/cO9Hy4
	5wXBd/czD/1rDRoldSSIy8B59E0KMKhQ/4E4fb09JGx8P1MiGSX6w2YuIMICF4kSdClv0a
	JidW4ycXUAy0bpv8xhqr/ALlgWoMcIE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=af099qNV;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761770665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nRyrHH69bDwdkUwV+ZvUiMlkERSxLC5qY0L4yNkpAA=;
	b=4kNIyAzijiM9bj1rIX/vmOgYhe/+rJZNxCIhqpbAmelTqUrivXVTMVN0u13PensEcvbnMZ
	zJTQd9Zv0VnfilquRlwFYUhzeiAODXVZLf7xjrDCf+XE73xKBDrJ0y7G9L+PUs9Ns4tbFL
	uFEbGlRURU9B5pC1IYftLo3AKgGeemI=
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-378f010bf18so14819081fa.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761770664; x=1762375464; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/nRyrHH69bDwdkUwV+ZvUiMlkERSxLC5qY0L4yNkpAA=;
        b=af099qNVi7VyJ2WAsA48Ek8Yrt0xLMF1rRiZL6d9gew47Giu46NkVTc4DlylKsG8gt
         ZfrCRemLnv9CZJD0+ZaiVhzXOH6BQKVjfVzDp1TUxlEBrcbJ6Uc8coFLmIBLKrH/LajZ
         +yuBPcLNeUZOyvr4G6tk9AUO8EmvUUscnyoXJPc06jVOwgm+88NORIl8doeXc0ZP15SE
         xVeDJDUSA9EiV+hjaWeSOBfxwmgqfFUTjQ8l7Xr6y2h0MJQek8u1qFmeik9YKY2dDBuN
         rQ9mR//UQqsFdWa2OATrZUwr2atQU8neK/sHRpwIfmRnIjrDStDO7eXH016Q+0vdTeKU
         Dhng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761770664; x=1762375464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/nRyrHH69bDwdkUwV+ZvUiMlkERSxLC5qY0L4yNkpAA=;
        b=R1einTramAUQ3t87cp+S0hY3SUHsarCoUjsznDGSbQ1BnwNAm048i92AlgW0tkrjhi
         Cvw2IryuoP0ymuYwygubq/uW8kBqZem64WbQduergszGgdtOBYJ04phIOjm0ZxLCcL3J
         nIW+AYyc+wLnG6oHUGPdfTecVSDZbRJ7Q7CqfPewW14q4cCLzLsLgfWq3GztIfJR3mKz
         0DuBl/tqZGGbOFPQqs/ulFXLpm12fMxSpWWmQPV9QCb5GSnUiLrGYhHxvx44xyxUWCpv
         C2VvFM1yxsTUUsRfbbyJHIqsLZY3zg9ERiIC9ABUyILdb7up6mFbQjtI/zJ/zgLaCrtz
         2s9g==
X-Forwarded-Encrypted: i=1; AJvYcCUCFgzARVeMPwzwoqxS7oL88/E+B7iZHHD5grIdOMH3Y4FhZNVstIxAJlZIqXg5JtV8MaYouhfdWw==@kvack.org
X-Gm-Message-State: AOJu0YzASpXiHXmr+V22NCwR3thLZxYy3cfYKiG+ayYGdoSPKuN824wY
	IyZWe5t/37Utue3+8v9nYbO4zmqBsXSVgI4wYSTgT/IfvYlvG1gsS6sffg77jejYwLEBaiM/8xp
	SNtzw8jHuJr+2oGs739ciullegdcqmY8X+CL5UL+I
X-Gm-Gg: ASbGncvtJyuFM6NVmZacSbCQXL7Cl321hIs5MJDjv5cldS2e2iq4VK79QtPChKE2h/A
	mKq3yZIIU1Hf9xeTplrunJg7bOBjpAG8dC7zJam5LWJT2tu+hCxVvdOywLjS+7/VdT04VygdKVf
	UFUzC3kct5+RGRCre2w+dkQpOeRGE0ShynF17Ym0VDGKN3IRQEMN+lTm4cn/4Fm6nFyvT6w2dSt
	zXUOobzb6fR5/QzgswozhIAB+/3Xe2B00CJRxguahut37sEEyn1SM/xlKBC
X-Google-Smtp-Source: AGHT+IFRYtH5XfTJnxxGfkJO0Gi6f1H2nFBXWvOk+OBKFsn98ppWQIAtWYQQwdGEa9VK8XbxcXnwXcPQMdyC3mUpVtI=
X-Received: by 2002:a05:651c:32a6:b0:378:d020:b6b3 with SMTP id
 38308e7fff4ca-37a1068ccefmr2106821fa.7.1761770663502; Wed, 29 Oct 2025
 13:44:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-15-pasha.tatashin@soleen.com> <mafs0tszhcyrw.fsf@kernel.org>
 <CA+CK2bBVSX26TKwgLkXCDop5u3e9McH3sQMascT47ZwwrwraOw@mail.gmail.com>
In-Reply-To: <CA+CK2bBVSX26TKwgLkXCDop5u3e9McH3sQMascT47ZwwrwraOw@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 29 Oct 2025 13:43:56 -0700
X-Gm-Features: AWmQ_blzsfm8AU4aSmOo38Baxqd-QolYtNvPxHfj3yJKEB0u3KTJVZdMqBMfTX4
Message-ID: <CALzav=d_Gmb8xKCwWCGsQQrdxHJrnk5VP-8hvO6FugUP7_ukAw@mail.gmail.com>
Subject: Re: [PATCH v4 14/30] liveupdate: luo_session: Add ioctls for file
 preservation and state management
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: c47pi61w8yh5uwqmnqhjfo1osxuaq97s
X-Rspamd-Queue-Id: B206916000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1761770665-244135
X-HE-Meta: U2FsdGVkX18c8oKC5ExZxQo/eL1ExLtIqIIP8CJrnB7/UPpBYT+1NAa0BnS9ljgVt/oOSw3IMMekzdKxvism+KeXVcA9a/zrsZEG89c23S9x6qM3dfKiPJwS/6vEEchIwfwd+TxKVpRjQr/H5CeTZyqKfS+QR/hK03p5C+1l4Eht4s0xVGlzARtFugqL6Y1aEkP3bWzgVFt6I9PcmLazIr60QkVR6CKb3qO84oDm8eC8936T1KGH+h3BAE7gSqOSCxjRUt6L7H3Hzejdx8JjZmIReVeYASXICuYqdMrhtAUNKp2eipXmhiGvETbZzM3iYKL6EMhevwJUU4guLNQ0yN6JqcQP1WHKas/gn/cTaWJRJ1EoKaCA+vJPN8albnv/ZxZDXUufBu1sZIxgFHSI5tHl+/zivomQOJd4+P9jiEKBudN2Qy16wMF+GR8rg8PAnfU33Jg7hZdSXLyP162oySrewcsv57KIGFWayih8XgUn0ZIkXVo6EkSOX5LbCO2aRU30bGJJuR2sW0UWHOeUKxMcs+y9wGLtdWDGke1kgUH4uQsmjQTgsqoFGia5aK0KLq+EaUNZQVSVaMNOIlIaQtKZKjLppmIO93aoojpIV7GYwXrIzf2fKcmqKaSsduX6ewByS3v2zy/gjkTEMd6FG3KuyTkjK8BL1Z0OwWBY4fe1M3dmEyajgipU3QDv0UwOX5QPOFGuTVyc9tiip2cVEJTs8YEC5R3R9smTGZsruAzW4jvd3UYUFtpN/3Yn3Nu2YrM4msNc2cWXSHvl70kM9ilYb6JSK7/XqW30E8QGOYjK8UjWpkkKuWreYUubfjJ0Pg9Et8iJL/Cl0JN4DYoya4DxlbCBG/5Har0bu4rLy7u0yo49gYctM5OVkdnycLFUwVe+W3e7YmRECsHjq5UfG5xZB9+dM6Nfb1tMx4oN7Sj7qBUxCsQH5UdMFFEth1eur0M3SSMYMjpY5GX6HLI
 OTX66MOD
 RpSh/AS2p3QnIpvrvQq21HMO5iIdjNCWQFD3QZnStCa2VLtwu8ohlziFYya+3Is35RcMPzJUQmdBwazI0/eo8jXmANL3cZxttTS7/mg8BSzbzQJR+ro5LO8m42aNBAcUDDYrPKcbhDSdH/Fhn7hlgLxjo3KXsejmibLgt4FZYOv3Rp68V4p8aCP747dAC4Tx0dzSA97biAdRcZMiQ65ooAUuuhgxgna8Zy8SxPjjKnsBLZizldtV+ufWaZiyD0ep9lTmw0j99FEcuF/y/tB0OONMVcfIed0g6tsFErWAXOue92wGQ/h2ECMmm4ZQ+AAjkZ0tB4S9ppLi7rW+EWiHAk7vKSUo1dHyvuXJnthmj3QLSf4cyG5gZ3dNbI/0qw0oEFewRCAaeqyOjKow=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 1:13=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
> On Wed, Oct 29, 2025 at 3:07=E2=80=AFPM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
> > Also, I think the model we should have is to only allow new sessions in
> > normal state. Currently luo_session_create() allows creating a new
> > session in updated state. This would end up mixing sessions from a
> > previous boot and sessions from current boot. I don't really see a
> > reason for that and I think the userspace should first call finish
> > before starting new serialization. Keeps things simpler.
>
> It does. However, yesterday Jason Gunthorpe suggested that we simplify
> the uapi, at least for the initial landing, by removing the state
> machine during boot and allowing new sessions to be created at any
> time. This would also mean separating the incoming and outgoing
> sessions and removing the ioctl() call used to bring the machine into
> a normal state; instead, only individual sessions could be brought
> into a 'normal' state.
>
> Simplified uAPI Proposal
> The simplest uAPI would look like this:
> IOCTLs on /dev/liveupdate (to create and retrieve session FDs):
> LIVEUPDATE_IOCTL_CREATE_SESSION
> LIVEUPDATE_IOCTL_RETRIEVE_SESSION
>
> IOCTLs on session FDs:
> LIVEUPDATE_CMD_SESSION_PRESERVE_FD
> LIVEUPDATE_CMD_SESSION_RETRIEVE_FD
> LIVEUPDATE_CMD_SESSION_FINISH

Should we drop LIVEUPDATE_CMD_SESSION_FINISH and do this work in
close(session_fd)? close() can return an error.

I think this cleans up a few parts of the uAPI:

 - One less ioctl.
 - The only way to get an outgoing session would be through
LIVEUPDATE_IOCTL_CREATE_SESSION. The kernel does not have to deal with
an empty incoming session "becoming" an outgoing session (as described
below).
 - The kernel can properly leak the session and its resources by
refusing to close the session file.

