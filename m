Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E1DEEC1EA6
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EC26B0089; Thu,  5 Feb 2026 06:42:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6926B0093; Thu,  5 Feb 2026 06:42:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2646B0096; Thu,  5 Feb 2026 06:42:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3EB3E6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:42:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE45C13AFC9
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:42:52 +0000 (UTC)
X-FDA: 84410216184.12.442D5AA
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1D0C6100003
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:42:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OXVt1TvI;
	spf=pass (imf05.hostedemail.com: domain of 3OYKEaQkKCKICNKEGTaJNIQQING.EQONKPWZ-OOMXCEM.QTI@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3OYKEaQkKCKICNKEGTaJNIQQING.EQONKPWZ-OOMXCEM.QTI@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770291771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9zFwpzMf0m7VjNRoMa+VYvPnrR6qveuvQACHy4StpI=;
	b=TgHfPesamKvs+QqvlMsKN1cWIoi7PXZFGaKz7EXoitifl5hC3TGeKLOHwxcpR4uVL5j55c
	ww6wYydGU/XXouG2Vk8EPh+LF+MH5E0sFIG1JLMbYbgmTUEDJaFmMkK9PjF1Wi0dmVtJdj
	E17sBpo9R22NkHDJcereFENu1XPsE1w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OXVt1TvI;
	spf=pass (imf05.hostedemail.com: domain of 3OYKEaQkKCKICNKEGTaJNIQQING.EQONKPWZ-OOMXCEM.QTI@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3OYKEaQkKCKICNKEGTaJNIQQING.EQONKPWZ-OOMXCEM.QTI@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770291771; a=rsa-sha256;
	cv=none;
	b=HC8CawqOpcWPINZFcfG2U0/w1se0HAmpK5qjQF4yX+P5wJQu5vILT/QXr7x+9ZRFkS43Ur
	VisthkHzIaCrr27UOtM+k/pUBN0WLX2w+SmieGlXD1v0rzpNW+afg1m/4kyhMAO8SIKUoh
	nZ6/DS3VYmdSl8H4gD5r/MyHDuN8nT4=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4831192e66aso8284675e9.2
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 03:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770291769; x=1770896569; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c9zFwpzMf0m7VjNRoMa+VYvPnrR6qveuvQACHy4StpI=;
        b=OXVt1TvIoqPhsmNbiYax12VsBdQvSncteH0+VziJyfTGiQPxxCdOUS8Pur6MhEIith
         cBRnyAjCUlPVRUYtveENaC0h/ZUnMPKu2BiVtlE5iBq2q60OElKCroE7MCWiDaapATOr
         3SkubzNhjVjAolT0TRbbM35JT+DWGcgDTWlflGO/VHLYMtiqGEAgY+GkoBliS+AbdR7D
         ff+hoqqMukmeBhkzWCeZbKTapElbqmxXvJqnSEohLUjfHRbPqX+ISh5Pc+ssbxjzPkRB
         PZJKA7VcR13lbf2X2Aw1gZAOgun6iZmGK3UszYyJvI128kJ/40d/4/m4UFrWXgkz/4ZI
         xGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770291769; x=1770896569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c9zFwpzMf0m7VjNRoMa+VYvPnrR6qveuvQACHy4StpI=;
        b=wGJBRoEYF/1P/dQDDa4C2DJKyB+K4FwfeZYCZgJ//Ec6tSx4pjmnKzmabu+ARaPkWU
         b9zdsLgoOPUWMvnPGcsDq2NGbiRUv6f/x7gGuQ3fMl4VlNLwxSx/vCd8e8HLiOj6m1G1
         q8TdjgchHP0oWgUhNzmJRyDsQ4jul3uVQrY9BfaF8ITeoP0qfxwamFCfl+oEvqK8ry4g
         zz04NxSyKYxyAgCS+N0hy7ED3rdyzMfjPVKB4PPYI052bBOQEquPnZpmCwgw24+LjKJK
         03b153J/VGfPPPiQ9I9Of1DZhOhXcGiU5qygcI3zXCaD8F5h+1hqS4aXpC2/gHMslXDM
         Hc0w==
X-Forwarded-Encrypted: i=1; AJvYcCXnaigKRk+ophvQF6EM/mInUWDhtB5MC7WrAZAvjsCbWUj7D6E6CqMdeXMdBHxZA2lYpGjNrcyhQg==@kvack.org
X-Gm-Message-State: AOJu0Yw5k9pKYB4aTOnAPpTHXdh1fIZJgLJq3yGvekL0lFknCWN2hWPD
	4vfYMXXc0FwlPksztg7/Y6Ljwms1do+NKfHqZPIuan7Woz8cy8op8u63OZzUaMfoPEEIiaYYDo2
	B7ZevaR3cJZWzBNStSQ==
X-Received: from wmbz6.prod.google.com ([2002:a05:600c:c086:b0:480:4a03:7b6c])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:530f:b0:47a:935f:618e with SMTP id 5b1f17b1804b1-4830e9552a2mr89288445e9.15.1770291769579;
 Thu, 05 Feb 2026 03:42:49 -0800 (PST)
Date: Thu, 5 Feb 2026 11:42:46 +0000
In-Reply-To: <9d0d6edd-eab4-4f31-9691-78ed48e7ad5b@lucifer.local>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-1-dfc947c35d35@google.com> <9d0d6edd-eab4-4f31-9691-78ed48e7ad5b@lucifer.local>
Message-ID: <aYSCNur71BJJeB2Q@google.com>
Subject: Re: [PATCH 1/5] export file_close_fd and task_work_add
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: hghb3a661wiz3m319kwh3gbo9nw5x4ap
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D0C6100003
X-HE-Tag: 1770291770-380950
X-HE-Meta: U2FsdGVkX18cXPBG4Rf6v7ggYwFZ0APLyzz7O2CXTq2y46S8gQftbaOiacmGul/+NH5rqI+iW9ztXwvqGMx7/EON4Zu/n1Zq+Ocq8DeNRItGIivILNn0lI+mcCzgkngO+ylsFcrEiGm+SaRbOB6UYb0V2VCOJyntsy7BT+mgJPdadcxpYNHO2LP17k6F/ATDS/tOhaAli9oNY1yQcSwNNhWv1l+I2iwAMiWYfJ+ypaAxrUnfDtR9M3opdmY4vNm8fG6LANEyhtPH8CUQjeizJRDd7+zyOdpvAN5RCxRWDCiJwyKO4UIGuTWuMNnPfzugR6oAqIONH8/VviTv/iUtX6tHLlQd1WHq42WCzw9Mihw53MoK/qk++eWg7bqtvxx5raaGk0bbvFFvu3JtdO78PfqLoeGQtz3Db1ynPM9lHgBzE8ZlbsWXCEHPLiut9ECTEOxaYR9DLqthQe/RUVkyt7Q91b4bv/4avUEc93FC/gjFPO5yJf4xKrCOOowqNTJfZ0cTvOEUyJXURy44Sdo1TWuf3BZTpG8YrjJHkSROGOHxUcsin+bOECwyywwHXISTQQjn0Ftbr3qXDOLrLpuXE2DGZ2Ip2eOP0k/4NnEQ5DqkXTof3ajFPcLjUw3wll/7v7umIlhStyINH0Yod2H/LkQCoAHgBOQDjNvphCBUtO5JDSMzzXeER7gPoVW8L+Pq45lr9ZiUU3DNNn/xmgYgl2EVlsOTR04dJwJQnsEp36qkbGwQtLaME1gYBHKTSqVyK7YjgfMuJfigUD7lJIaMXHmaCRc1BKx0Qz+pY3XAK5uwM2ItMw5+QyPOJtw30VkeGYD1J3COBonBRPmbBVHWiAfQ0BcDQrIJ1I+r13fgT9QsInfk5QnWqzh7xndsOk6ajWocWQQYjFJtNHOI/z3IJ+8RkVCjEWdQdFVDPjp2ZSlVwUF4rnVJ5NTphNZPS7HDJwdG4PkFiceESXiRiDY
 AXjY3Iwo
 vHWtB9t9Ir+QuSWEg5xPQzWXfmcAHoR8hTxfZots0ZmuqRXOtx8fw4fPgUZh/ff2NRR1AsX7aDp2DHC01kDKB5prjj38E5j924B1w4OXtoxfbv5p9vBFv+rLIE3GY4ZFrKGZqgEvnaH2rQQpaniyits2vBmaDH6hTNstvn20NXnvJyfdIszkFdhCRlawpo/DiL0qHVpz0rf6Jqy+dIc3msXd4N1A4PBi/pqTuuNrrcOikGaQNCs5kkW6ky3h77DAkSQpocZx5JEYrE1JWI7OE4dcYDZLflZW1oTidD54gUTni5XDXtMXiMVZzQOdxk5QiTygqj7cbq4gbsuPDROMMXNJqII2DFkLTFvuK2w7MbeZUUH2HLsm0Ed/87bUNEcLT3nzdD7Y0pALtn5Y8WjcgHISI6aH6YXAN/uYMALj+qqeZKeI52caQAUzGLZ224PboT7FMVsjafLq0y1aTPfq5/9p6z0EQNDU/2KK42CagsOMeREeI7MwxEPgyknplaXQ4lmStU1Z2OU/Ozrs0L/6k5pVIUufSs6v/CrfHXX3zmWyNQffEAMn24XXpaMN4upWeHtK/svZu/OqQO2OknmOVpctHwNxTokh6FwKSs3ZhqimCxzWHi+joWmBlqj2JbMKoC1Hzx9ghaLFFggaObNo5tMDjeGWclOvlqvSM/oj5dNIA1grZxEVkb71TgVWOdVXdO7o0PDCV32GWJU0YVWSnr8eGtGUbcYOAy1axcr80Pl+XRHjNzh1WvmOiFRc9wmZLabB3oXKaEeUKMo6W2fE/RN1U3gkmCsXvrME2CFS1fRg/tuk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 11:20:33AM +0000, Lorenzo Stoakes wrote:
> On Thu, Feb 05, 2026 at 10:51:26AM +0000, Alice Ryhl wrote:
> > This exports the functionality needed by Binder to close file
> > descriptors.
> >
> > When you send a fd over Binder, what happens is this:
> >
> > 1. The sending process turns the fd into a struct file and stores it in
> >    the transaction object.
> > 2. When the receiving process gets the message, the fd is installed as a
> >    fd into the current process.
> > 3. When the receiving process is done handling the message, it tells
> >    Binder to clean up the transaction. As part of this, fds embedded in
> >    the transaction are closed.
> >
> > Note that it was not always implemented like this. Previously the
> > sending process would install the fd directly into the receiving proc in
> > step 1, but as discussed previously [1] this is not ideal and has since
> > been changed so that fd install happens during receive.
> >
> > The functions being exported here are for closing the fd in step 3. They
> > are required because closing a fd from an ioctl is in general not safe.
> > This is to meet the requirements for using fdget(), which is used by the
> > ioctl framework code before calling into the driver's implementation of
> > the ioctl. Binder works around this with this sequence of operations:
> >
> > 1. file_close_fd()
> > 2. get_file()
> > 3. filp_close()
> > 4. task_work_add(current, TWA_RESUME)
> > 5. <binder returns from ioctl>
> > 6. fput()
> >
> > This ensures that when fput() is called in the task work, the fdget()
> > that the ioctl framework code uses has already been fdput(), so if the
> > fd being closed happens to be the same fd, then the fd is not closed
> > in violation of the fdget() rules.
> 
> I'm not really familiar with this mechanism but you're already talking about
> this being a workaround so strikes me the correct thing to do is to find a way
> to do this in the kernel sensibly rather than exporting internal implementation
> details and doing it in binder.

I did previously submit a patch that implemented this logic outside of
Binder, but I was advised to move it into Binder.

But I'm happy to submit a patch to extract this logic into some sort of
close_fd_safe() method that can be called even if said fd is currently
held using fdget().

> > Link: https://lore.kernel.org/all/20180730203633.GC12962@bombadil.infradead.org/ [1]
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> >  fs/file.c          | 1 +
> >  kernel/task_work.c | 1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/fs/file.c b/fs/file.c
> > index 0a4f3bdb2dec6284a0c7b9687213137f2eecb250..0046d0034bf16270cdea7e30a86866ebea3a5a81 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -881,6 +881,7 @@ struct file *file_close_fd(unsigned int fd)
> >
> >  	return file;
> >  }
> > +EXPORT_SYMBOL(file_close_fd);
> 
> As a matter of policy we generally don't like to export without GPL like this
> unless there's a _really_ good reason.
> 
> Christian or Al may have a different viewpoint but generally this should be an
> EXPORT_SYMBOL_GPL() and also - there has to be a _really_ good reason to export
> it.

Sorry I should just have done _GPL from the beginning. My mistake.

Alice

