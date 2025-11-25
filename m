Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 017A8D0EE0D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 17:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE6D6B0093; Tue, 25 Nov 2025 12:11:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48EB46B00A6; Tue, 25 Nov 2025 12:11:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DAD6B00A7; Tue, 25 Nov 2025 12:11:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D58D6B00A6
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:11:36 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C498313A75B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:11:35 +0000 (UTC)
X-FDA: 84149770950.16.2508FDA
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id C4AC380014
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:11:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fLOsuFov;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764090693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ly5LBt6mDypO/G6NdTT5RZY/q0zV3qr4fzhYNtYlqik=;
	b=Ltpo5ondFV79Z5CAmEbLmWsZOXE+7w7nZ5gm1YcOrtIBux/vYYWp4H2kJ1m+YdHHec9rCm
	qTr0DFNpdW3jNiZkmfxQHyvqnwovMRlhvya8Y4XzjSgGHnXkNlm25DD7P7TLUm8DuQBv1i
	gjn9hJf6hEP71S3KzxOaAY+dZYCA4C8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fLOsuFov;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764090693; a=rsa-sha256;
	cv=none;
	b=U54powc0wkZpl1aupp5RobVa1WvuzkKviQBikGe0AE1WEsNieQDHIRfsOUI4TZIusLhv5y
	AO8LumUnAXVEBL2OKMEWjIoXXdCvIGHGleb0ZpFSOO8eQT7i1ZpoFk0A5WQRe2t5HeFII2
	MSMZPGePkDZk322IAuSW9W9cwdXZHWo=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso8955000a12.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764090692; x=1764695492; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ly5LBt6mDypO/G6NdTT5RZY/q0zV3qr4fzhYNtYlqik=;
        b=fLOsuFovisE5dqRQirOG4hzKivOL9RG9AgQqGeN8JZtfBOxAYZ6h+xaLtW1k/VNvvt
         z+HMSgnF2bDvCgoSCgajupImL5hiUcDhQc6KAijCM2JduF90imvEKMwpHO3myp6rZvSP
         6Ue9OuWSc6w4+Fa1efD3ovqX7jdx92RwjQqZjQWaAOp4xu1MhcGN1z0N+oxXURwHeJ0T
         nCoxkSYqvPXMs+BHSPC9kFMUFgUuLk08lDurxstaTCucKT1Q+Xko/p+0n/DZosklSfpf
         grQPDl50ekfiJq/a392btoJrfLU8/c08/313zdivDr0Yxfr6UQDDiB9ZKjyle+HczvIJ
         bWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764090692; x=1764695492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ly5LBt6mDypO/G6NdTT5RZY/q0zV3qr4fzhYNtYlqik=;
        b=WCsLV31g5srrT1BXDzOvusdSRSc5PUA7rD8URZyxv45FcUHTj4dGixh5y209A/ru1L
         r2RFaMU3IERVXHU1XnV9nckYF4Km7vnHY+TXVwLhOvxPSWedzwv/tBCR7gy+sZl3XmgV
         qfI8jtXKxPgeKF6hrC1AwU3TsrjP9YMgysxHDsN5tYFyPfrDHBfYhKEdC2r4IGxPqe0W
         ML17E9sW/U6+/Xb+r6Z5iTyKOpkkot4CKd5AqXGoV6w3Itm7s0AQAdB5aqEKf6lianJw
         iTx9nCny0wgV89HDrQlakypeodhiQfEzSwImmtH8zqLq2H0ESM5I0gJ98ADF5q/hz3Yq
         DHPw==
X-Forwarded-Encrypted: i=1; AJvYcCVqffPdIGdV7hN/CQCsz8fzPs+Y0QYZYCF1phrWLJ8/xaR21g1FR2VsjguG07gIprl6iUbyDlA3Gg==@kvack.org
X-Gm-Message-State: AOJu0YzD6FVSCSXeBXTtcn9bVOUeEfA1Q3yDPlUKqVUi6CD02Vqu6mHC
	ULjXE4kjq6dKFBDD6l/JIZJly43cgReGInrYTvoZEC96nUa6uzJUAbu6tzYnwZPrtnIElWNUrJP
	93MQuVUyDcDCXeuiysmXa96FpL8JWRRF7JUHun+AGnQ==
X-Gm-Gg: ASbGncs60947vJdcjaU8X8tdP/2Zt9JhZJiRDzSrGYen/tXvxUg6eSWOwNmx6BapFvZ
	uIeNo6o0f2FkTs8ItKKXwxzDOzdf1+3aF2ElYOFyn5P6seplVoekRnonFXo4cHRlfwSDQ4S4A2y
	x8X/9ghxwjJhIfSHhDbJcngFf+8xSAh1KdQncwDtT4a8OxG4rIhnyvRxnT8HbQy+stjtWxb/G7W
	n1Z8aGNuHf886bYdWm1xwUZweSTxjRUSpOZB3xLOrBs+KMmngJlt1wBBaboN13ByAT2
X-Google-Smtp-Source: AGHT+IGrfsmrfzIW+aWRuJRmdKZisN9HOWvhufzxvxHfKz1E+SFLlkqO50B6RT0T1wYIyaZoNdq4RbNgdU/zWatA1zQ=
X-Received: by 2002:a05:6402:1469:b0:637:e2b8:605b with SMTP id
 4fb4d7f45d1cf-645eb23f94cmr3816071a12.5.1764090691966; Tue, 25 Nov 2025
 09:11:31 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-22-pasha.tatashin@soleen.com> <CALzav=f+=c5XH7Uw9EGVb2P6VxsnpF76e0DXAAXhM0gsWPxw2w@mail.gmail.com>
In-Reply-To: <CALzav=f+=c5XH7Uw9EGVb2P6VxsnpF76e0DXAAXhM0gsWPxw2w@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 25 Nov 2025 12:10:54 -0500
X-Gm-Features: AWmQ_blUNJXGJsZNTyk-wstisxWf95tP1YO8_RTqL2T5TqXUElAOHsjvRUxN7S8
Message-ID: <CA+CK2bBXNkpkYFa8xX4L1redUAdyx40ggJhntysH4W=a2nh99A@mail.gmail.com>
Subject: Re: [PATCH v7 21/22] liveupdate: luo_flb: Introduce
 File-Lifecycle-Bound global state
To: David Matlack <dmatlack@google.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C4AC380014
X-Stat-Signature: 5q757qtsur4ykumqtq5y4ttzy5ra7r6y
X-Rspam-User: 
X-HE-Tag: 1764090693-898389
X-HE-Meta: U2FsdGVkX1+ttYMDywgrgAJdCNw/SigfHiMQrxbrLPhODVxz0hKxfb8KPKkEgJYnlMrzYMu/kAwxa0N3MGCklX75EvTJ40nOxkPaSSx0KRn5kK95Q+3v5mR+Wl3/ruJdARZAdx1MS5WJtukH9/qJkY9HyIs1Ik69uUJBKkzQ0Sof+dcbXaxqO5R2WPiMHQ/poK+SE8gtmBFwDy7KxPFmRjddZxG9g7qW8ZFR+oxUB/W76Yzcb6WsZlaY01Y2r/N1PYuO5hd/acWb4nnU54bylhEP/FxefwPKowXe+cyhGikhl+CSObVyEDpvovFf93f+hRx+SEP8n2lRnQUnB0IWYseuHDU5I7+UpFZENvxAz4hQptKOKwiHKt+PrELv8QDdBphBWyrL3SGAiAAlbGtiWyKCTFBnNbuaIia2hm6snRCXau18pcbwQ7I3nxFAoWoqWKCG68xHHlWC3POhrLC+pdFL3NrgMH3mC5Q/0c+mCP11jWCY+0h0tss/KWJpT2AxFGx+TrpE7DzCfATZMAhmYCUP9ydbVlo1Gh9FrxAel/qzuNi4+BojUXVTjyOPdVvpv3eUQx1eK6ZoeJlYz9wvSghinGsIzLOf0dj1LDTbrL+DJ7PiaGB/8UlatxfftBh7q3Fu8StHR4Xxh5rLxjng6YXVuzAXKV5K96pVncSiINSzy1nfShM4enEoqeiAVtQWMblRsYTjck5HF3g3fRtU545Lm54G3L7jLbcCFBi7Kt8tBJyPTh3LOEz+WJaAQPoQPNn2Vpi1xlObdYB+qY0i1XqU+PsSGnNgOtHnzW5HZZx1SL9GAsRhqWVjMhJk1LD2UvKHa3YE+FNU+JHbM45thvKF3V8kQ+a2eOoGnYCbktYQPm/n+zgQhUsc+1xXKB+35NrC3jxZVzskfw506B2xhb4mrjh92OrgAnX7sT9+wcbn4wMZp2Sr5Mfsmfh2swOZ97XI0WiY8OM8QkjE64N
 GZL3UwV+
 ciO0mCwxOOQUQjCX98nZsVCv+jUeOUrlLhfPSql8YvuS07EPINBrDxzEkHzGGNfsonF5npoFGi93MKMQ/hNLWDbBCEhrdV4j6gwLhELLcrYQusQnDdecBbi1oqK7ouWnoDsOfZYS6M1p2s4w7TxP/pLpnhkcoS8gxhJODCKw+Ijp/jrzxrJaj7mx46HjFFJJYPlH/cwZd7GY72iLGwHuOK+K5ZMvHfQYyuJ++7KeyZoQ7gU9+OcBDJycU42PytY0Dota+OXiw3C2OhXD8U/WJcyn4TCF86k72gBh/kYUZJrC4qJrMUipQbId0ed5AIFIDgUjOBDUmW1xYmP3bZCQ4dOLLrfuc5wffDAtaQn76gaC9FYGFRLsPLfcZT3VsCtrcAyVJHV5gINH8eMc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 6:45=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Sat, Nov 22, 2025 at 2:24=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>
> > +int liveupdate_flb_incoming_locked(struct liveupdate_flb *flb, void **=
objp);
> > +void liveupdate_flb_incoming_unlock(struct liveupdate_flb *flb, void *=
obj);
> > +int liveupdate_flb_outgoing_locked(struct liveupdate_flb *flb, void **=
objp);
> > +void liveupdate_flb_outgoing_unlock(struct liveupdate_flb *flb, void *=
obj);
>
> nit: "locked" should be "lock". "locked" is used for situations where
> the lock must already be held by the caller.

I am going to clean-up this API, and remove locked/unlocked; just
return the object directly.

>
> > @@ -633,6 +639,7 @@ static void luo_file_finish_one(struct luo_file_set=
 *file_set,
> >         args.file =3D luo_file->file;
> >         args.serialized_data =3D luo_file->serialized_data;
> >         args.retrieved =3D luo_file->retrieved;
> > +       luo_flb_file_finish(luo_file->fh);
> >
> >         luo_file->fh->ops->finish(&args);
>
> I think luo_flb_file_finish() should be called after the file's
> finish() callback. Otherwise the FLB data will be cleaned just before
> the last file's finish() callback.
>
> i.e. The order should be
>
>   file1->finish()
>   file2->finish()
>   file3->finish() // last file
>   flb->finish()
>
> rather than
>
>   file1->finish()
>   file2->finish()
>   flb->finish()
>   file3->finish() // last file

Yes, I will make this change in the next version of FLB patch
(currently FLB has been dropped from LUO and will be sent separately
since there currently no in-kernel users beside the self-test)

>
> > +static void luo_flb_unlock(struct liveupdate_flb *flb, bool incoming,
> > +                          void *obj)
> > +{
> > +       struct luo_flb_private *private =3D luo_flb_get_private(flb);
> > +       struct luo_flb_private_state *state;
> > +
> > +       state =3D incoming ? &private->incoming : &private->outgoing;
> > +
> > +       lockdep_assert_held(&state->lock);
> > +       state->obj =3D obj;
>
> I tripped over this when developing the PCI FLB state. The following
> compiles fine and looks innocent enough:
>
>   liveupdate_flb_incoming_locked(&pci_liveupdate_flb, &ser);
>   ...
>   liveupdate_flb_incoming_unlock(&pci_liveupdate_flb, &ser);
>
> But this ends up corrupting state->obj.
>
> Do we have a use-case for replacing obj on unlock? If not I'd suggest
> dropping it.

I can remove internal obj updates.

