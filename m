Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD2DCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 10:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860866B008A; Mon, 25 May 2026 06:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8376E6B008C; Mon, 25 May 2026 06:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726DC6B0093; Mon, 25 May 2026 06:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6085E6B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:42:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20B7B40351
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:42:47 +0000 (UTC)
X-FDA: 84805603974.05.F05EFBC
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2BA8D2000C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:42:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PY0cYQyg;
	spf=pass (imf03.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779705765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zc9LvU3e/f54K4oHyIoq4+XKoWb/QRX1RMbSGSqgSQI=;
	b=qrk0Fd8/nQFtSfaj4s50z3jQQHaMqbElRDgVwKwVp5dQSwvqzTwMkD+kVKNOdJ/IYt/R+M
	b7h7z9TOjyl4g0MH2lHMqf31rvgW+gCPL2GMNBBVZHFEPsINQfjtIHGdB4djR9REq3S7tQ
	0zEpiFwVZqrP1n21g1c/pJeUdY8nGoQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PY0cYQyg;
	spf=pass (imf03.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779705765; a=rsa-sha256;
	cv=none;
	b=chshvycrL/U7gD/imQ5SFS3wBlSiQwxHBl14NuFd7EPlI/d5fsDWD0UMticMeNFTTV5Piz
	yfcNZ6gNl+M/IxjjAgp+36PgrPiPmp0GxDRZQvH/Tbzvwfkt7ffp1IFX7mOCXyeHaEK2Pc
	VxTqUNUxP+BdrELNWhJIsxl3yNECHVM=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49056b9f04aso21390115e9.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 03:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779705764; x=1780310564; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zc9LvU3e/f54K4oHyIoq4+XKoWb/QRX1RMbSGSqgSQI=;
        b=PY0cYQygyGELn2xMcpRvUdKoFAkqoOWEaJwwHL8IrpFcIDSdGLwpnoXunZMprpJKpE
         zzRQMny+KWPeh1UkC1I2VIj6/Py2m9L8vOC8lXVdhohn72ml5H3t4iLzc5G9/LWLmeGN
         zC5ZJe/8egYxwL3ILP//9maNdHWBNbrE80rTpudCZOt1vMKzLVY7B7Y5zEqw98kmaHqQ
         kIt/sSG6v5Zuq9WrGIyuJPPYz1c4nVZ5LHuS9MSMii43Kk55VR1fIaNCbNSKfPDLQJbN
         ODKWrcpx3n3pJ0wAzOry+/tOCtOJ2sFeTUgtp495ZG+sqUxKnDV/shuuaCiip0JO/u0Q
         gW1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779705764; x=1780310564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zc9LvU3e/f54K4oHyIoq4+XKoWb/QRX1RMbSGSqgSQI=;
        b=V/8XPSprdDLBdFj4AUWBnBxmvMfjulyvsprVllhF3z9Sqhg0tmGPSlIespGE9BeWNG
         bV+bqZ0VJ6qye92YQ97PM2EYZz7lWp+4tGqxR/PVAEGpXptg/fLe8XzGjBKEU/ggxEg0
         q15umydkGwHgBgHgMsLRQ+sPeUJgG/kPcr9DNV1+SkUx3hdh6m2HIn6oBBQykgnIw9lc
         xM4t8NtaqpQo0exFegI8tnW71GavjCWAw/iGpS9xgBr5WU5WiVWgZg9GaO28YvWVinv4
         Sx4lFSv/9mB2CLkcPODumH32ftDVP/Y/Mk0f2zJ07rNb4WwLxvTFm7/lvGtG9XU7lPFA
         9VRQ==
X-Forwarded-Encrypted: i=1; AFNElJ/5RiNiqbzN7k9APZCYe4vGvn/k7UtKVdylJsV8OXepOA+W5WCg1EcKsJ+qnfxu/FXhUxhVeErvnQ==@kvack.org
X-Gm-Message-State: AOJu0YwFJHzBqTV7VMPl0tuSMiHmBzPvzygNYej0XOQ+RkqoyQm4lH+Z
	hMb7rlMEkeGEEzGX6swYs+fvEft3GJ2yRSRRUdBhhszOcdB24bgO2WIZ
X-Gm-Gg: Acq92OGM+nuXsTjNGrrhCuypRV2zlZgQ/0q2Jyu0ZbaIIHrvCSWTkSv9MEKVyMmi8ES
	lY3HVSqIe3QIYnrx4pUorRgN8sLyf/lIiP9KTqROtTkb3g4tv00vYY1aqwwkABdL7Oj32tv2BVM
	4ODSCVTKFw9oiGAN4aFJ8b0rMgW1TBSkToV82rNxI+usTcB6eBTxxFiILEPN1Gg9Mp9M0wsIepG
	dXKsda+KTtdX9Pc8XVA2G5+/cvbCq503rBpA4mtld43JadBaztnngi2ZxaWH3uImTdVkGNFmJgZ
	fvP7sgdyMCeAVtScH4QS7kXW/9ZVp2nKI33plF9QjDShEgP+dhUbg+DZPNjaIXIzb7WQMhEnxbi
	WDnIwjF3TlcQrdPvN41vEztq68zU8rJoeD7yEq7zSU3hrRKmdWeTR99/23NRY2kTW72Yy7REpSQ
	rJkQ1V/FpJ4PKWdRhJbTOydZBScs+rEWm0odRemAeH6VWYMFoWnIByq2GTKuzOjgrXva4mmI9AY
	24=
X-Received: by 2002:a05:600c:45ce:b0:490:5cd8:d213 with SMTP id 5b1f17b1804b1-4905cd8d33emr89808645e9.15.1779705763319;
        Mon, 25 May 2026 03:42:43 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49049973b71sm67696445e9.29.2026.05.25.03.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 03:42:42 -0700 (PDT)
Date: Mon, 25 May 2026 11:42:41 +0100
From: David Laight <david.laight.linux@gmail.com>
To: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Steven Rostedt <rostedt@goodmis.org>, Christian Brauner
 <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Shuah Khan
 <shuah@kernel.org>, willy@infradead.org, mathieu.desnoyers@efficios.com,
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com,
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org,
 linux-api@vger.kernel.org, Bhupesh <bhupesh@igalia.com>
Subject: Re: [PATCH v2 4/6] sched: Extend task command name to 64 bytes
Message-ID: <20260525114241.4b6f3050@pumpkin>
In-Reply-To: <20260525114107.7fa5b4c1@pumpkin>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
	<20260524-tonyk-long_name-v2-4-332f6bd041c4@igalia.com>
	<20260525114107.7fa5b4c1@pumpkin>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2BA8D2000C
X-Stat-Signature: 9hteq7a6er9p5ek4gbkguh8ip974c71e
X-HE-Tag: 1779705764-640689
X-HE-Meta: U2FsdGVkX19pzlirnX8jS0zqbqy7+JVi66QsBaKM5781hmjzUP/IZNl3ivPnEciAU1e27179foGyJ0A6xsIfZce1/fVsLX9VuMCz2SFdb0a0GFHEpW8OkWlsWM6z6IzL4z2I6gXfZSTkd8h8O2vBrWXICrrS7CPjgpJ2wVlUWRcEBpn9JE0Xm9hp30AaybjqK9ALbmDDU7cMCFH+aX4Xs7ALD4+ANqncngMOcblW538WoFN2GXIrXS1CARFTfwuDgq5qFyRPDYupWPZ8I5mp3gWL704qTGZIUuoZBi0+rBz8lMwDiMekjJurP+6zSVuiRMGlh+XvaTXm4WYZImR594I2iWTju+YFftqqm42tT0PA1seAgz1EpDdh8ep42kc8hIrZ4n2HxZZhYkyRN2qvBad2ZjekYCj1Lp6dHb0zft9JpZDJf8CWYGx20KBKtgKZmewmOvOmQbQNDo/hQaX1rImf70lTlsFh/DmQR6Z8T1is88TEnqbrfsxCpLeAG5j0Pr2ppw0n52dJQ/S1YoZ++qKGyjaTPMUJsR7/jXGN4tHeDWQzsCvckAWKGOBCiiOFFaZnI65oEvuRUTbXF9cNhAlCHndtwSHXBfmXk/Y6jt4JKIRZh3gQrG16T8U3JmOAy0FwywqYcTVcS/oxyh36NKXI+q6JvIye7Z/nYLi6nG8RWARSXRkLAde+xw8mW/GK3W2k64skdk7G80bh0Jm2gI0VnCOrCVYNDWq5hoGuBpIDrg2oHn+nnmCR/zMRnG1v+vFD+v1tvNXQwWCcJZaJuaT1xLmlNrx06ynPnert1L/VEvpagrwQ1TTk7o8WPZlrkPxYBZPRc6EZj23FCi7tO8ZQuGHhazagXxs96iwtVGhDP2S3GNF1jjP8sAbcQu3XJ70SuEuwbn7TbUNDi4lmuCEckJLdtw4upXBaRvZulvAFJfe+6ZGJEdlzK7UbMxqBY+5EbirbDxP3AtJtZJE
 bjJOyuYa
 szqZh13emW+kIfpVo417V4BO36McMZYhfMbumDX9MTtPaZRl9DKsavxHpxx+6jCIMemsAlfG9ZMW2WOuxn9DR85tGrzVAXhB4NbRRA/n1vVafJCM9P1BJTcBLxJD7JXHeNMvYjl7rvJkEOqhXcbItkP/rJcZVho5rBiQY1UZ7vMyflLpwVpkwVC9FWyS6Cvj7aR/LfQMPx6YxblFKIdU9erLodgB8IisXSf133GJuZrz/wABDqXqbMiANWKr9hByDZQhoHlawmlt4FiT0i06g5iiPHJGrUeZ6YGkuQ4BcJqH2mNj0lnX+cEMjChj5WXz+22NnEjs+VvsxtMbEcHrk1YC5yLCSCp9GEBjrMQItv4Een7M5fWEs+v8W4vtgQngjMkOMgBNfFssRAZbJg1jmnzv4b/I8Iq9//5VXPAwAJUKbN1zVTspT+ZBFXnYQukOBiSZ1x8gU8KNDEvroztqIalNYtzUWnx4zOLNR7XtXgNfRC5N5lBjJXnXqaJI6k1B+lpuXWK1U24a8T745sligCFosUEJZwxeKh1n/46P32/EgmfAnxYuI8vTuLe22gMWLzWh0Zq08GU5ExJieUqXaM0KLySynwJBKfM3rRNM3ul/wi5pLin5WTHQMmv42+Hlnz+Fp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 11:41:07 +0100
David Laight <david.laight.linux@gmail.com> wrote:

> On Sun, 24 May 2026 19:38:54 -0300
> Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:
>=20
> > Command name has been restrict to only 16 bytes, which is too limiting,
> > specially when debugging and tracing complex software with thousands of
> > threads and the need to differentiate them.
> >=20
> > Just as it was done with kthreads in commit 6b59808bfe48 ("workqueue:
> > Show the latest workqueue name in /proc/PID/{comm,stat,status}"), suppo=
rt
> > long names for userspace threads as well.
> >=20
> > To avoid buffer overflows, cap all existing userspace APIs to
> > TASK_COMM_LEN, and leave the full extended name for a new interface.
> >=20
> > Co-developed-by: Bhupesh <bhupesh@igalia.com>
> > Signed-off-by: Bhupesh <bhupesh@igalia.com>
> > Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > ---
> >  fs/proc/array.c       |  2 +-
> >  include/linux/sched.h |  3 ++-
> >  kernel/sys.c          | 10 +++++-----
> >  3 files changed, 8 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/fs/proc/array.c b/fs/proc/array.c
> > index c8c3fbd9bfa9..312371eddc7f 100644
> > --- a/fs/proc/array.c
> > +++ b/fs/proc/array.c
> > @@ -110,7 +110,7 @@ void proc_task_name(struct seq_file *m, struct task=
_struct *p, bool escape)
> >  	else if (p->flags & PF_KTHREAD)
> >  		get_kthread_comm(tcomm, sizeof(tcomm), p);
> >  	else
> > -		strscpy_pad(tcomm, p->comm);
> > +		strscpy_pad(tcomm, p->comm, TASK_COMM_LEN);
> > =20
> >  	if (escape)
> >  		seq_escape_str(m, tcomm, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index b6de742b1155..f7fd2b7d131d 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -323,6 +323,7 @@ struct user_event_mm;
> >   */
> >  enum {
> >  	TASK_COMM_LEN =3D 16,
> > +	TASK_COMM_EXT_LEN =3D 64,
> >  };
> > =20
> >  extern void sched_tick(void);
> > @@ -1167,7 +1168,7 @@ struct task_struct {
> >  	 * - set it with set_task_comm() to ensure it is always
> >  	 *   NUL-terminated and zero-padded
> >  	 */
> > -	char				comm[TASK_COMM_LEN];
> > +	char				comm[TASK_COMM_EXT_LEN];
> > =20
> >  	struct nameidata		*nameidata;
> > =20
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index 1d5152d2395e..76d77218ab19 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -2535,7 +2535,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long=
, arg2, unsigned long, arg3,
> >  		unsigned long, arg4, unsigned long, arg5)
> >  {
> >  	struct task_struct *me =3D current;
> > -	unsigned char comm[sizeof(me->comm)];
> > +	unsigned char comm[TASK_COMM_LEN];
> >  	long error;
> > =20
> >  	error =3D security_task_prctl(option, arg2, arg3, arg4, arg5);
> > @@ -2601,16 +2601,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned lo=
ng, arg2, unsigned long, arg3,
> >  			error =3D -EINVAL;
> >  		break;
> >  	case PR_SET_NAME:
> > -		comm[sizeof(me->comm) - 1] =3D 0;
> > +		comm[TASK_COMM_LEN - 1] =3D 0;
> >  		if (strncpy_from_user(comm, (char __user *)arg2,
> > -				      sizeof(me->comm) - 1) < 0)
> > +				      TASK_COMM_LEN - 1) < 0) =20
>=20
> Nak - you can't do that.
> You are reading data that the application doesn't expect you to read.

Or have I got confused over the names...

-- David

>=20
> >  			return -EFAULT;
> >  		set_task_comm(me, comm);
> >  		proc_comm_connector(me);
> >  		break;
> >  	case PR_GET_NAME:
> > -		strscpy_pad(comm, me->comm);
> > -		if (copy_to_user((char __user *)arg2, comm, sizeof(comm)))
> > +		strscpy_pad(comm, me->comm, TASK_COMM_LEN);
> > +		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_LEN)) =20
>=20
> Double-nak - you are writing beyond the end of the applications buffer.
>=20
> You can't change the user memory that the syscalls access.
>=20
> You can support the longer name for read/write of /proc/self/comm.
>=20
> -- David
>=20
> >  			return -EFAULT;
> >  		break;
> >  	case PR_GET_ENDIAN:
> >  =20
>=20


