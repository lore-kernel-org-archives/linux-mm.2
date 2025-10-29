Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E226CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718138E00FD; Wed, 29 Oct 2025 16:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1F38E00B2; Wed, 29 Oct 2025 16:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542548E00FD; Wed, 29 Oct 2025 16:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 405918E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:57:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2677C0793
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:57:49 +0000 (UTC)
X-FDA: 84052363458.03.25C4305
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id DB4BC180003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:57:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AyUCI3ej;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761771468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuiAC7OKtA+UPyYMr+UMd+A8BNjdLWXyrqC7LzVZISg=;
	b=QoHrNdMUAgtt31eoh/kCsT1gEQjbqTFrZOKhsNR1NbJlOJlfvtB3RZrnsPI3aIV6jpRCnX
	rYWsOURoTU175QGsA+jVkiReVq/KeuUyX1fXNO0hnTIfy3Uevwt1ln2gOJMP2vbi9FsHX9
	atJGxa+O5I91BjeVhqxBpCqUbN1gYxQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AyUCI3ej;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761771468; a=rsa-sha256;
	cv=none;
	b=Yh/psIxh7lJTAmUOP9IPf/zE7vGssMurQo58P5gak2VZCK08tfdtkl54w6HUlPDP1LquQK
	V5XXECrkmkzJimMmO5lUIryu5rZz5/7I6w7BSF5PP3th30N/ZRGlciKmXfdYKYiN5Pc9Kq
	g0/TcudLH3uXayNonnzf4RBmpPvYCik=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63bad3cd668so525075a12.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761771466; x=1762376266; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CuiAC7OKtA+UPyYMr+UMd+A8BNjdLWXyrqC7LzVZISg=;
        b=AyUCI3ej92/2NO5mUm5BCoZPwQzuO5oFpytc+1GBO454TgTX62fg8Cbtfuz2mqheV7
         iih95tTZ5GEB1Il/C3dVkZ2A01dqzPQaTC5HKQ44HH++uTg8RrbZ8roNRH4NHY2e6fqM
         WK9SpAyFzejjX2bMrq36KufenGCx2DtwhKfIFtCv/QOWKx9gD3alVFpyZlMJxBEQ7thP
         anT7eJ461a1ur6ha+mmnvPfOQgMaecHffTVVHC1l0I2EW54Mzog53XeTqboaibNXOcfK
         0gJSDU5kGzpOdeI9jvX+O7mxx5rMiU6nj4I41SGetgM+9F1fdmQq5haf1vuAazcDfmC1
         XPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761771466; x=1762376266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CuiAC7OKtA+UPyYMr+UMd+A8BNjdLWXyrqC7LzVZISg=;
        b=icGDwRsBk4F2KLjkrhUObuh38Wc6jTsIDwUj9d/xWMuPubPEYY816MMcJpSkLAH7sO
         1KhZjzbdNPRJyQ90L1TRgrKs5JOF2MLB5xVfsqgixalk7nYwQRf8fyQBsdZKSMOmnthL
         W7zUKymSrzc8x/jVzBJ8fXLUhq0ELe4B/mB79l8mwAVV5wwGypcVByT5uTGeqsaRI2+m
         lJ7fExqnJr42JpmwNTdQ5/o/9gTUAdr0CgI39LcHVWCYMUvCaYORoZjPzRc5U4RMhB+5
         QbZQdRj9jA+KRBppfuoinkGMfkvymDxxvfbpJopBgUDbP1uSKMvlzeh8kIGzgf0T37qC
         FWeA==
X-Forwarded-Encrypted: i=1; AJvYcCU6UjMLzw/el1PNmxTfjPNGM6qqYLWKThYFV23J1wP26gjrtlnohIbJH74isRh77NH2/MKmtJr3KQ==@kvack.org
X-Gm-Message-State: AOJu0YwJiN+VOIYluTkzXMSO24wiA4HR8ADrQg4Km9UQ55tBmTt2LDw6
	oQscIfIBwiowxZDqZ125ZC0Uhx++v7/I21AKppu4ERUoDFcxE5BMfyUVrVy4NZ3PhWQjUOhhlkM
	keZOKauSNYa1PcHjUWhuBosP5911+bMsFOOF5Ge/8EA==
X-Gm-Gg: ASbGnctEoBMjFhqFdczHZXGj4weWxZKWCU55qRWma9qIPe+SZZrD+kQPkgUMjV2QGk3
	So4J5rIPLuUIZxQX3HQpeuDIonJWG9jt0UwqzljHel8dEEPvPTFeiPcpSQkX9JGBdgRsfgz9CYe
	wwipG2i/CHuLLLv1DwuROFzXWBtF/G0I4BuifrrWZmYRBd80NI0uO1Bwhf9q9XRPzvB+miC2x9G
	Mz+AiURkayIla2HEW2wozkzG5DBN2eq6zqvX5Z5qip7KkRsiQs/2p88MA==
X-Google-Smtp-Source: AGHT+IG1L1CklcYrT3HJAsT3NVI2g7bIUPxqqj/65m77k2dZAOZ3fC4M2LmVzxUPHERR8OTwMl8fTbOBKlBu6jPbapM=
X-Received: by 2002:a05:6402:43cc:b0:63c:84e:614f with SMTP id
 4fb4d7f45d1cf-64044254e3emr3585778a12.18.1761771466076; Wed, 29 Oct 2025
 13:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-15-pasha.tatashin@soleen.com> <mafs0tszhcyrw.fsf@kernel.org>
 <CA+CK2bBVSX26TKwgLkXCDop5u3e9McH3sQMascT47ZwwrwraOw@mail.gmail.com> <CALzav=d_Gmb8xKCwWCGsQQrdxHJrnk5VP-8hvO6FugUP7_ukAw@mail.gmail.com>
In-Reply-To: <CALzav=d_Gmb8xKCwWCGsQQrdxHJrnk5VP-8hvO6FugUP7_ukAw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 29 Oct 2025 16:57:09 -0400
X-Gm-Features: AWmQ_bmg8lfgTlZTUn7wdsm2doiok4izVO4pilRQtGY6Hx2FX2qYt9rGJfmSrxU
Message-ID: <CA+CK2bDMcCtDom1XQOx0U6yTg3Azr4jzSTpUo=WKgvTVOh5oog@mail.gmail.com>
Subject: Re: [PATCH v4 14/30] liveupdate: luo_session: Add ioctls for file
 preservation and state management
To: David Matlack <dmatlack@google.com>
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
X-Rspamd-Queue-Id: DB4BC180003
X-Rspamd-Server: rspam03
X-Stat-Signature: i1bp6fzzqxah8txcmqc5owhbdieappow
X-HE-Tag: 1761771467-47586
X-HE-Meta: U2FsdGVkX185PG5rbKUXQLXuRwteD5i7JfrQ0A+nJP1RfUnH314pLyHb8rYcuN38BD0yEt1sWDhZm2Fcyc8/t3xSReNP7+kUH/bnFVGjBzHljjs82A8NiGm7Ls2O14sczmBzYi+gwkXMR/JqME/2jzRfGQr19s2/7YHLbAQI1pfNp0HMjcOlHN1hx4k3EvVXxMJo6yqFJfGnnCinnuuS1XRonCbNWgChJw+qxIBEUyqU++reVZdKDozZOmFqckCb+gpLVbggbliOV7c530QEy+N6nq5x58RR1S/XIAOTb1LORykvztCZecDUc6SYuZ1AdM9gN2ErrXS+zrQXp9pVPl+9AoTtCc0Sv5UKcIsVQp235JV8XI/exDB7pXwaZYXsXlIt/N2/G5c8J4jot2zVrCYp+FSds5ymha6lv7wqXOKTXkbm55CxWzj8T7K7P2ANRqFV+s+wvpf4rQFVmU+Uq4oOyeLUEuUuzX68acNCkS2s0MVeTJYyyWakfxoAhBcXIC34qbihvkibmihmkkq0RCq9UzQlk5h8N6JHX+p9OYyHQayI201eG6BAK18gEH+G1Cg2FvwlIHa079qdLd4D/1EuhwJkurDDkWmJFNdFRfTDs802GA5nKMVWSil+ZFgrS7fH0nigg1wraQlm2if1qw5EYAW/v13Zcd4kPWVFU3SIv0PLXjKCxK10M9ePwp/lVijPEo6sd/3BPYzigJlxxrDv048lfnccpJRVJm5FmVAA4OEcBuXFMGjA/eYAbXhaD/sYdi4FlIvWmNqjzUYT+RQ7IxlDISAdsEYqXi7aVGETv5WQpN3IGESeuoO7JXPzD77qzZjRfD28aD/eQgsvUSebLlMrWsVZqMujJou0vculZsntze5HfMl0kw/yLMNnx+qPAviIZsRgzPavt+NS6N6IaCIkKMGXGJnVXl+/AEqDIspIEKwZmgP6GvD82iaA5alczhAumka3UPcW285
 fhZgKp0j
 CNmjVwNAm1T7++ivaMQ1NhReWBQ4bNPdnVnWtSgv0u4q49yZv3+OtzwDSdaR5yzJjT5wuvVj1CdeRLBYbdhG344ZG8iH8YoLd65IYEDteEwfinbHRwB40hzDYomFnbdxp6BBOqHPPr9KsrVqI3/FY7iS3/Z0C/xupKnNjrATzqQVc8HHtHIT+Z3MEZcn8kblHcHCr58yVd7m3ns31RbEb7swQMvbd4XovaQxZDrYA2qIHarZpHRDl1qIxrBeUgT4L5PJe89T5dJlLPiUejNj5diVHMxwRK7kdOvcxvVzORoESd20GxNuINunpEIT/WLHMLbTLCF1CmgUbO9GpX3KHcahXpQUhcJpOLBnlDpIG3sqO7P55IGSdmmrTlsaSv2ymS/MDqVRtbU8hnZB0bvWqXikRKbjbHwtk+VY3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 4:44=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Wed, Oct 29, 2025 at 1:13=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> > On Wed, Oct 29, 2025 at 3:07=E2=80=AFPM Pratyush Yadav <pratyush@kernel=
.org> wrote:
> > > Also, I think the model we should have is to only allow new sessions =
in
> > > normal state. Currently luo_session_create() allows creating a new
> > > session in updated state. This would end up mixing sessions from a
> > > previous boot and sessions from current boot. I don't really see a
> > > reason for that and I think the userspace should first call finish
> > > before starting new serialization. Keeps things simpler.
> >
> > It does. However, yesterday Jason Gunthorpe suggested that we simplify
> > the uapi, at least for the initial landing, by removing the state
> > machine during boot and allowing new sessions to be created at any
> > time. This would also mean separating the incoming and outgoing
> > sessions and removing the ioctl() call used to bring the machine into
> > a normal state; instead, only individual sessions could be brought
> > into a 'normal' state.
> >
> > Simplified uAPI Proposal
> > The simplest uAPI would look like this:
> > IOCTLs on /dev/liveupdate (to create and retrieve session FDs):
> > LIVEUPDATE_IOCTL_CREATE_SESSION
> > LIVEUPDATE_IOCTL_RETRIEVE_SESSION
> >
> > IOCTLs on session FDs:
> > LIVEUPDATE_CMD_SESSION_PRESERVE_FD
> > LIVEUPDATE_CMD_SESSION_RETRIEVE_FD
> > LIVEUPDATE_CMD_SESSION_FINISH
>
> Should we drop LIVEUPDATE_CMD_SESSION_FINISH and do this work in
> close(session_fd)? close() can return an error.
>
> I think this cleans up a few parts of the uAPI:
>
>  - One less ioctl.
>  - The only way to get an outgoing session would be through
> LIVEUPDATE_IOCTL_CREATE_SESSION. The kernel does not have to deal with
> an empty incoming session "becoming" an outgoing session (as described
> below).
>  - The kernel can properly leak the session and its resources by
> refusing to close the session file.


I was considering this. But, in AFAIK even if close() fails, the FD is
still closed, therefore, I am not aware of any existing api that
relies on close() to fail. The finish or (set event if we decide to
expands events in the future) should be a separate ioctl() and close()
should release FD unconditionally as it still would do even if return
failure from release()

