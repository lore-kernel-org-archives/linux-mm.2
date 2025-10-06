Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC88CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 17:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519DD8E001C; Mon,  6 Oct 2025 13:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA388E0002; Mon,  6 Oct 2025 13:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B86A8E001C; Mon,  6 Oct 2025 13:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 243F48E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:23:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE7D087A0D
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:23:52 +0000 (UTC)
X-FDA: 83968361904.06.CD50620
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id F046640013
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:23:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HVB+3jNt;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759771431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eiMWaxwcwGco8r+FHYAdZ8/rgwTBKI1DQmsAsIjVEPg=;
	b=HdocO2m9KVqnkHY1u3THFydhF0Ey7112ZEcWJa+y7jLmHHcLXp1CqVTnaiiFvECm5rW+qz
	2HTqChwlG8bgoh0RfuqxXYnIvQJtIdeVxNnCsup8Ol0Pr6anLr7qb/Ti7Nvg9kHxYM0bPL
	iVuHwWB+IjT3UPiLk0mJO3K5aRUnQNo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759771431; a=rsa-sha256;
	cv=none;
	b=6skbT5DTyHdsIeFbO/06j/RaC4vnGCHQFluUum9142MdJARa2n3p2emcvP6i5k9lzLdIQD
	TEn3G6vE7/YdbUySo0p5RPyBpiIojIAmJL7OnCfOjquuXlYC6fHtX3+zWn5+WKZM4RH6Ao
	KDLp1CS3DTs+S1nuBZNt+Hi+P2ofQ5Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HVB+3jNt;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-856cbf74c4aso655310585a.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 10:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759771430; x=1760376230; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eiMWaxwcwGco8r+FHYAdZ8/rgwTBKI1DQmsAsIjVEPg=;
        b=HVB+3jNt2Ut6UMDJpTNicvXHMDsk8B5VLSfmmKMJ7tp2W+4Lw+SXER0DNty2m1C8gt
         K2U4JFosLf1at5Fw4VkJTnbjqGzdy5+/krp+mFZM2DpmgQgLNjzXRCJ6CUigGBjbeLnX
         v1vXDtfH2x1xW1ctl1PSGvVV315TQaD0/GvLQkdWdnehwlpNKAp4r5xgw66kkLkRNJT7
         7AoDWRD+KJFAj4ihfA/rtcp4l3WDIt12XcTlHZDYqlbqx0FONrinzHrM7ZpnyWrqBTOA
         zrlBrR6UJ2hD2UxdrLmmIG2T8SNdM0fh7G7QwVOHZFXpiqb6R6LmjntmbN8cWI/jK/Ct
         vtbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759771430; x=1760376230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eiMWaxwcwGco8r+FHYAdZ8/rgwTBKI1DQmsAsIjVEPg=;
        b=TGx3xx31+7/yHhTFMZCLfM3CFuhJj+VLT6paTTBSpNc3GubuwJ5V17zrGEjWw+AuHP
         nbAodyqLQ4Zk/vzbHhYZ5GtLQIDtrjfjuVNMTrp0RGjr3cnJ8BPVZpTgu+/As+fsXzlx
         JCvKq3kpcAV3zud3hLS+KMx3rISHvPEU1NOSRsL5NopeN0WxnHvfelcJcMBJ5u+1R6yY
         dWBRvObk8T9DEfkcZdMkirNMf5bTunphJfN174GQoUy6bK2KxWx+fsaEQ1lU5c1CCzqh
         MmjSBpJeOcnafkcL2Rn2K+Yx9vuXl5EayQlEsXCKhJBOva+go94Q2UuB3rHAPI+uzVUB
         ZJxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxpjlr8QfvTKtQ+If3o76S0uWwHL4df2nI4TKTuPSnvOHk69at+VTNRTWmnnW2bfMmx/WrHaYrcA==@kvack.org
X-Gm-Message-State: AOJu0YzpyO9VDQtTGN3JHAoWDp66oKfqDjVK6JfdU2a5Rj0URubHVaBu
	qTYuR0iuHMuwSqCZ0DItUSwMbDKtyNbzoTRrxrPZ5v/Zf3xZpkbTtlAfk1eGSAx1CihFQ91o+VW
	gpL2Pccby3RxCL2zGc6xlqUYgz48OrxWvVwaCUq7QFA==
X-Gm-Gg: ASbGncs2JAFtLYbImOLiQHw1cloCZxhxeMNzeywU8etfQ0bMYy2FFQtpMVTICXxdRKK
	VByQ+49i5vAbsSx3Rlh/cEZ6i/wZD2CwpfsDvZ9s0akEXb1KUAaNL96wbv0gZex1SBFYN+VN5ni
	iS6+sGNL+9eMjjHThMKEuT1tFJtHnJEc1s5buutOcUdw2jqvvSKxovwDFU/LyL0XUDbwsU47ISD
	SDW9F1hfocuYZ/MluXc+4sWpDoLI2BnK8U4u2k=
X-Google-Smtp-Source: AGHT+IFv/eQIGSPIMF5AtEJ9/NjM4NT3tDLx/ni0W3avlG1qBmkP6qV6SoLJbkqgHaLD5t7vOoviSBII4unw5QD/72E=
X-Received: by 2002:a05:620a:469e:b0:85e:5022:33a2 with SMTP id
 af79cd13be357-87a3a34d387mr1695495985a.39.1759771429425; Mon, 06 Oct 2025
 10:23:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-3-pasha.tatashin@soleen.com> <mafs0y0ponf6b.fsf@kernel.org>
In-Reply-To: <mafs0y0ponf6b.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 6 Oct 2025 13:23:11 -0400
X-Gm-Features: AS18NWCYmyLqK5As63FctOGJiEPF3B80wEZqrPZ_K5x_kzJeySLPd8Ta4rPXhIg
Message-ID: <CA+CK2bC0j=CbTNo=V-dceZEz9mji0yTWkE7QyUzvR1SRCiAJ=A@mail.gmail.com>
Subject: Re: [PATCH v4 02/30] kho: make debugfs interface optional
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, changyuanl@google.com, 
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
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
X-Rspamd-Queue-Id: F046640013
X-Rspamd-Server: rspam02
X-Stat-Signature: xeu7qfkkqqeidux5hhod39hx3p5xc7ro
X-HE-Tag: 1759771430-901507
X-HE-Meta: U2FsdGVkX1/O85f71JTpfu+QpyqXgu58MUgEoCvVXtWlspHsMJAlp+0DW/hdfUBgDgGyc4Uk0RqG23/4t3HEhvj3U/2ynSpEz+qfDXW0MZ8SjsGaOeo2YrzZbIrMPcSC+EdN09PafurRW/XnbCbvEhinmSazI85sCWXeYgY3vyWD4qxkQ26mW74D2RHEInYtN7cNsiQZXjFgABVnZMriQC93lzqOJQjNUbxo5UH/tTMtbBdNQHLTezzcgNJmLBeb8EwU1Hza0SMdl0JBTl6pcdM4WQHKG2PsApRjvEuhrLKvW5xf+H+OvJWY5bJgGvulGSXlFhw8z9/W9K4WMgpGPZTYd98QpYfttcpJXIAXYn3SePbZNpuaWh3UxXaxQ3NnYpr2QwhmRQdCkkKUc7PQN1qoK8DBuM2IrwUPxF9nrgIecJVvGgjneL4Ph/8+0lkogu/GEZ+YdTAiTtH8rqu+M14Cs3dNm3nSTg+AnV9/ZAkYYvzS+Ay4avvS644qPGcHlhf/KAqtSPWP6GYm+wU124/a3PZlhtI+NyTz8K0gmIzUkuBE+wCg3rdXHQbgLg3OLJFEegrghjhCQ/K2KJyPKjWTRwOZXvtR4cJK6EETBAFH4rvCegBTB9KkYYgrk9Ha6s8oocWwG4Rtt9Fo8AwanDTbuyzyZVe4Upr+BuVBWX6QP56eiVGV9IHwNHrsC/yxyYlNJ5aCxjsP5sVo8WLNqbz/RGLeW9ugyIdJADlktGjz/a+TC+FO57whT/0SL3qSu1o2n78v04FPJ7ca5ija3SudJAWEKKly6Uq0lX/Ffkj+Y7rwOVCJQriDprH5axYuWsEV0myU9XIJCExxZJL/xwj7JMqS8834ChFtMi37vgvMby0klIVx/kS3ufCl6mMrSESe9Gca+GaEd3GDUyu5pKGUWpMU1/lt9I4RRqz+BiAV+KoYNkzWKUdi5vCSswhnUfkGs/uqZ3C724Ffd82
 vzbQ+LsM
 zjWOw9YdiHeM3iwDE737WviFtoKTTz1cRhviJMpdapYxjGW2uGksbW8i+GtY59Y0mJAs2bqGilK5tpsBmvxuYprWhKXDPAvG+5sBa9lVxaOtu3gIVEStzGMqq4Pbt6aQKcGp3TVHv2ZyWF7DRBVO1mVmF64eYLsz29MWffRm73D80nkhIClmLoIPu4WCvRQJhG4TszxSS8ggxpymZkZWggBfcLSzOETgsp8VvNI/DwMAd708qVl7/kGx8H/5hSqmUASzjIBusU+ju7VQwAKqu8eimWRAYw1VhnFCrbWKT2u3RDBOXEgbW+n/VwFPG8XaRWLhTEabqX4xjEj/NonaadJ38Qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 12:55=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Hi Pasha,
>
> On Mon, Sep 29 2025, Pasha Tatashin wrote:
>
> > Currently, KHO is controlled via debugfs interface, but once LUO is
> > introduced, it can control KHO, and the debug interface becomes
> > optional.
> >
> > Add a separate config CONFIG_KEXEC_HANDOVER_DEBUG that enables
> > the debugfs interface, and allows to inspect the tree.
> >
> > Move all debugfs related code to a new file to keep the .c files
> > clear of ifdefs.
> >
> > Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> [...]
> > @@ -662,36 +660,24 @@ static void __init kho_reserve_scratch(void)
> >       kho_enable =3D false;
> >  }
> >
> > -struct fdt_debugfs {
> > -     struct list_head list;
> > -     struct debugfs_blob_wrapper wrapper;
> > -     struct dentry *file;
> > +struct kho_out {
> > +     struct blocking_notifier_head chain_head;
> > +     struct mutex lock; /* protects KHO FDT finalization */
> > +     struct kho_serialization ser;
> > +     bool finalized;
> > +     struct kho_debugfs dbg;
> >  };
> >
> > -static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *=
dir,
> > -                            const char *name, const void *fdt)
> > -{
> > -     struct fdt_debugfs *f;
> > -     struct dentry *file;
> > -
> > -     f =3D kmalloc(sizeof(*f), GFP_KERNEL);
> > -     if (!f)
> > -             return -ENOMEM;
> > -
> > -     f->wrapper.data =3D (void *)fdt;
> > -     f->wrapper.size =3D fdt_totalsize(fdt);
> > -
> > -     file =3D debugfs_create_blob(name, 0400, dir, &f->wrapper);
> > -     if (IS_ERR(file)) {
> > -             kfree(f);
> > -             return PTR_ERR(file);
> > -     }
> > -
> > -     f->file =3D file;
> > -     list_add(&f->list, list);
> > -
> > -     return 0;
> > -}
> > +static struct kho_out kho_out =3D {
> > +     .chain_head =3D BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
> > +     .lock =3D __MUTEX_INITIALIZER(kho_out.lock),
> > +     .ser =3D {
> > +             .track =3D {
> > +                     .orders =3D XARRAY_INIT(kho_out.ser.track.orders,=
 0),
> > +             },
> > +     },
> > +     .finalized =3D false,
> > +};
>
> There is already one definition for struct kho_out and a static struct
> kho_out early in the file. This is a second declaration and definition.
> And I was super confused when I saw patch 3 since it seemed to be making
> unrelated changes to this struct (and removing an instance of this,
> which should be done in this patch instead). In fact, this patch doesn't
> even build due to this problem. I think some patch massaging is needed
> to fix this all up.

Let me fix it. I Plan to send a separate series only with KHO changes
from LUO, so we can expedite its landing.

Pasha

>
> >
> >  /**
> >   * kho_add_subtree - record the physical address of a sub FDT in KHO r=
oot tree.
> [...]
>
> --
> Regards,
> Pratyush Yadav

