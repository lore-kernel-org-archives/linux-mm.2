Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BBACFD31F
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 23:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC816B000E; Mon, 24 Nov 2025 18:45:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD42D6B0024; Mon, 24 Nov 2025 18:45:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE95D6B0028; Mon, 24 Nov 2025 18:45:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5DA6B000E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:45:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C22359ABF
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:45:32 +0000 (UTC)
X-FDA: 84147134904.06.2A8DA73
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 482D040010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:45:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q9VOTyhV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764027930; a=rsa-sha256;
	cv=none;
	b=rccC+teIoR+o9RBc2vyiiNYFDY4X14TIhYKMbsFqXm7J5ZAizpXJwqBWpT9kfILHdS73AL
	yzAyiPoB+dO5EAMae261f9zB/DQ5rnyvz6hxgF/aMEO5jS94XZrTFmnV+PSmK1q8wUTrkv
	1eER3BasPJzLz3TIsbDP53WBPvSP0vg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q9VOTyhV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764027930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05wP4M5m8hN24FSCktfwvvhdg9eAu0qN4WDwWhg5IsU=;
	b=AqlG2NZ4xzH603SZpfkT7lNQZv+sewIyV5Pd+I8P7PfIkJOEjjfAIGbz342QUyDWf7RSrJ
	AgDogl7IPuj4I0qpCMNj5xzFDEp1mFexpDLvBaVmS0ncQPcyOSUowvq5khiXK33dMw60G5
	PksPqAVhQc2tXkV8pjphXBTULueNsg4=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5957753e0efso5086033e87.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764027928; x=1764632728; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=05wP4M5m8hN24FSCktfwvvhdg9eAu0qN4WDwWhg5IsU=;
        b=Q9VOTyhVfXm5iZE0kM/NdXZAMSBjRIOIg/2xKJPv/3pmSGFE5O+kkFdEMjo5YwBA4k
         Js617G4Sry6KsGYUAjel5hlKP6hyw5a0Q9sip2lDrVxAsuS076TZ7XGY+ogUXY6ft082
         jDio7pDtP32PUWZcuk75kDB3t6kGjjua0DbqlpNMZTQPkvlaCP0lQckpf98qkxWrWNS/
         C1GYEujeAnByM0rXXDY2TLQA38ioENFVNUtRdYLnH6yLICxSifZF+XXhKDXGNEFhUio4
         asREaT8q/aeHSIFZxMKX9AFi+708CJgKpj8rjD08mcqghwfCtnndxi7WkQfQPjUx1CP5
         S3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764027928; x=1764632728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=05wP4M5m8hN24FSCktfwvvhdg9eAu0qN4WDwWhg5IsU=;
        b=OLghKqlW36MYOY18dnd6HjFjz3Fd6JU8WN3ivbZYqo/U97LAQRg9zCErySDDvaGtiP
         QX9IR6+9yHGN8VVZHtsQUKgHIabX05adTTxAanrbxZWa/oJIzSJG2HvznuLqQ5W7wlyQ
         JslriBjCXsrS3kZXTiQzAvu1laWA1iqgnOmmzXIkxqCajAYJqglVZuzu1pYHOkuy1Ddt
         j2AGFkzQbLRiDOXtOAGRpeRpuLsRVN17JpGenrl4QkiCO/Wusww1GSBGZ5+GLf9bz8an
         2QDYl5QYarFXLoVSj8MXQVNR41K0ObU3+TOHBuWx2mqGgTu/VSSif2YHAEQQfwIPRw8/
         Y5sw==
X-Forwarded-Encrypted: i=1; AJvYcCWbl3ebxVpS0wiyOZRNO6WpQ2bV0rNi8+G8ubwVS7W9B5fiIhUPePVrLLcZa458ncLh9awSgNJtBg==@kvack.org
X-Gm-Message-State: AOJu0Yx4Q3EuqFSs1pPY0YeZ/JQYeptQ0BfhsIUwUnhkeYTJunDgeAZ+
	6Uqj5/pt7Q5ExQdU9SY88ohOf2HLvmCgQ+oGLyWoyqgaFAResojRDqzDLjiZ438nGNqBwmrF+hS
	sfeSxHLoiH+3ZiaTwk4Li9m95quSLotSm2P3pectK
X-Gm-Gg: ASbGncvmMXGQmsRWjgaFUpG9CLeeSs18BaIDZOnHXXudeDjThGJpVBNBrJwEhxJMyYa
	jQFjlM241+pVStAN52DCYFd5dbX86msAB0DnAUY8XLoivMn9Ry116R6LyhTTkj6j4TMt+5u1EDq
	DWN7gbl+7/d7rtUaI248K2YAmCVEoPX1x0zUvATyH76qhc9qLY+ZT9yvuSIzORdwLPi9ANoH7Ij
	fdTcdqTU+YomumMaWTKeSu7PPmu1xqTzpNMB4nCOTbzXUE89iyP5p3gMpfIVM2Hu/EVrBcQStNE
	Add1QA==
X-Google-Smtp-Source: AGHT+IFG3B3wjJ5hUmdHvUSiONpPpEjo/smMGL+Sq7VqjhpIWo7YbanBRf0jnx+HWEMfNF7y44/hOJQ08ua0/lRI7nY=
X-Received: by 2002:a05:6512:3c89:b0:595:e35d:6b80 with SMTP id
 2adb3069b0e04-596a3ea6658mr4439445e87.5.1764027927918; Mon, 24 Nov 2025
 15:45:27 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com> <20251122222351.1059049-22-pasha.tatashin@soleen.com>
In-Reply-To: <20251122222351.1059049-22-pasha.tatashin@soleen.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 24 Nov 2025 15:45:00 -0800
X-Gm-Features: AWmQ_bnJaOF-T9FnnUyFXJgRaTp9b-dM-s_K88NADK1Pd4LiL71E0T19a9fmhbE
Message-ID: <CALzav=f+=c5XH7Uw9EGVb2P6VxsnpF76e0DXAAXhM0gsWPxw2w@mail.gmail.com>
Subject: Re: [PATCH v7 21/22] liveupdate: luo_flb: Introduce
 File-Lifecycle-Bound global state
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
X-Rspamd-Queue-Id: 482D040010
X-Rspamd-Server: rspam07
X-Stat-Signature: y1ziqyxzjyhes4u7sh4urgkwnnt7zqkd
X-Rspam-User: 
X-HE-Tag: 1764027930-32467
X-HE-Meta: U2FsdGVkX18twyqRqPEWcwGj2tVUMezi2yZEE1m8H+XVyrwZgotf+qRwh9UDKcj+Ls+9BzYAP07zKJdoBeLeqBYBuacPaRfB1i3OMdjogdUl9And+L/MnQk0SaQ19ceavedMwH+0H5ZSbG/mbJ0FEaQMzuQqb+CTOqsg/t1J7j1RfUzcpUagAKQvCTVJ+frkpH6/xfOjApEBIzH47b+LhGttYemY2+IduHX0K5dTr6hq/FNsDNqihu2qIcOM8ss5QbMGWUsfGOWIUs7m/325U2ZAUsWkh3vovJmsNsIOdgq7rn5REM+d3JR1cppO3k1DfQ2lBCGJHa5r8qBMI+E74tYPqJPWKWV1ussOyg+IcJMSfzvwRN6oVT+pd/9x4dvHPfIGmWXw9G8eBWvvItTA8p4UA1JGjgwemiuyGz7zeAmxQd/8+oziWipFQA/Gz7DtLbiMz1O6MrH0d9AUbCf0D0mXPY6yNtFbw78tvEm7fO2uRvLHYvWEAxVclmPqE47FgyfFa+f9WNg2mO387GQB2XL7Mo3tOPd2GB8ZP9dmVAOsY1ZbPemsy8CqDpIfa3D5eb3HokQWaaMJj/nZX7PBPyD5roZtVWoZwzdBJNXgEBuSGTbBw1M717KIQHTMWH9690bITMj+lthezI3kA3pZ8b538Saabnq9WpyFtS/UoT7HlQ+dyZelvPd5XgJQJGz7XaFfWEjIngp1CjrKlA0TxhWRugHC+8aOUEo3h1cPMeZmGefCb1wXVBcMTiOUdu0gWuEHcGGznAYSfwOlgocH0oOHQ7SVyutI5QA54vP8iZa8dMAm+2y3hW5pkM4TD+4vARrPWcz/i8ElUFlVRvhLZ1ILo66RY1D96PuwptA4IbmptQZYOdc/XdMUNstoAsCQsKnkOS9g9FRJXocw9Zbmjj0jRtfKCEdAFmZQARjUYSD7EMgY3xPU5zAHNXMPgZ0N3X/rAm6PM4vsLQ6/2ho
 WhFYOJTo
 y6cHCWdlurI67b7wocILKkzi0eF3basS7M0nklPCIwquuqnw2k+W4hg1lU1KMs96b9WqY/9S1TVDwfrr5RIDAX6Os181mSPjbMH0c42iJaX/vBS4pjOoXv0M9XH1RIX0xmYVwdxfA2f61w8AACUqkfSVLeA09TgxvQOZLdGbZBJdpKeztKCwYQ86W4qH4cQrcIYcPVCe8TmNC2Ky7BOQo85yTSzUvH97CyvQU1zZU3pmneP9g0c8Fzvdi6kt/TigNnlxR+WB0K1ePySmLYrw5sZ/fw77XFaELbWkKafeV4vSlXBPs4/xoO7SvEkCJomSD/WRviRVimutNqTeRXA6uKvcafHefeDqZnowHr/41WfiAS7r9SV3cWQX2Gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 2:24=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:

> +int liveupdate_flb_incoming_locked(struct liveupdate_flb *flb, void **ob=
jp);
> +void liveupdate_flb_incoming_unlock(struct liveupdate_flb *flb, void *ob=
j);
> +int liveupdate_flb_outgoing_locked(struct liveupdate_flb *flb, void **ob=
jp);
> +void liveupdate_flb_outgoing_unlock(struct liveupdate_flb *flb, void *ob=
j);

nit: "locked" should be "lock". "locked" is used for situations where
the lock must already be held by the caller.

> @@ -633,6 +639,7 @@ static void luo_file_finish_one(struct luo_file_set *=
file_set,
>         args.file =3D luo_file->file;
>         args.serialized_data =3D luo_file->serialized_data;
>         args.retrieved =3D luo_file->retrieved;
> +       luo_flb_file_finish(luo_file->fh);
>
>         luo_file->fh->ops->finish(&args);

I think luo_flb_file_finish() should be called after the file's
finish() callback. Otherwise the FLB data will be cleaned just before
the last file's finish() callback.

i.e. The order should be

  file1->finish()
  file2->finish()
  file3->finish() // last file
  flb->finish()

rather than

  file1->finish()
  file2->finish()
  flb->finish()
  file3->finish() // last file

> +static void luo_flb_unlock(struct liveupdate_flb *flb, bool incoming,
> +                          void *obj)
> +{
> +       struct luo_flb_private *private =3D luo_flb_get_private(flb);
> +       struct luo_flb_private_state *state;
> +
> +       state =3D incoming ? &private->incoming : &private->outgoing;
> +
> +       lockdep_assert_held(&state->lock);
> +       state->obj =3D obj;

I tripped over this when developing the PCI FLB state. The following
compiles fine and looks innocent enough:

  liveupdate_flb_incoming_locked(&pci_liveupdate_flb, &ser);
  ...
  liveupdate_flb_incoming_unlock(&pci_liveupdate_flb, &ser);

But this ends up corrupting state->obj.

Do we have a use-case for replacing obj on unlock? If not I'd suggest
dropping it.

