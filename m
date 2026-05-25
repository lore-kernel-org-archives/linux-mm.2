Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A71CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 10:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C07306B0005; Mon, 25 May 2026 06:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90BA6B0088; Mon, 25 May 2026 06:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59A26B008A; Mon, 25 May 2026 06:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7F26B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:41:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 452FFA021F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:41:13 +0000 (UTC)
X-FDA: 84805600026.25.3A7C5C0
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 601B1100003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:41:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="D3/cXtpj";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779705671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFLYe9us/Dsl57mEZ/B/rM5ImRHePLFDjoSpnJjwwkw=;
	b=OAFpvvN1fjsW5mk1oWk2417HCX/ely+D6zoqXHxCKYg2bG4JP32w17UeGoJO0A83973J/d
	CkImVDOZ2jwmZ9q6jRrAO0PyhP11GOdUsAtl9rBGXH+/rAxcSnQAKGMmcf4ptK8ash1hq3
	EZHRPrWyl436hGUk3g7Qpz3veIuE31c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="D3/cXtpj";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779705671; a=rsa-sha256;
	cv=none;
	b=uUwxfMzKLyQ9kzT/xL85hmdn54P+GKrnLyjU9anSw2yaJx6D9vanbGCYYfAeeS9yZnEBmS
	neEbbsJ4qf+84hIFmX+m9ZZgiWHcKhn2mgmsxhMD/36tuKlpd0Fcn+0xCoGr4cadiVQa9L
	w4TKVgi0RbDWXzHoZYgMaM2UuiS6CwY=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-44ce78ab5feso7631280f8f.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 03:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779705670; x=1780310470; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SFLYe9us/Dsl57mEZ/B/rM5ImRHePLFDjoSpnJjwwkw=;
        b=D3/cXtpjtxYoxfm5Y/PLJ7oyanQh+YY18kNNvbdEL+HLRmuChV135wprrFLVrw6yCy
         ji5uIHx4ofh0DVlXFox5ooPNDWk+/1tJIj20qPId3HE3m/0dxf1WqNdCxmIsecHgdV4N
         bIBODDLlCtBHVswA17xFUjQex4XZag4r2lVJ/bc36F6UrSNShdrC7pXoisF6cZSN0KoY
         bt2DpW2TjOpBT9je/rr8ZXugedN55LlIvfTmDvSPXSN2PjpnvDP4GiwoL1NA10ZF8jZP
         kNtOaGy5Du0Ihs3IwkxkpJr0q6VL5D/u8OqrTkzC+/+nnHqeTP52ymW+FgYZqhab3eE3
         pMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779705670; x=1780310470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SFLYe9us/Dsl57mEZ/B/rM5ImRHePLFDjoSpnJjwwkw=;
        b=kLEw2i17txAvL1KAAiSrIx6laAM7rl+dcfLNVArv14MAJF+kmBFK5/eCj0L7uvhdw9
         oKWFDsaq6ZYrhJDnzf68QFIZLFhhvWA8JiFdk61xZrbVbrYpFm9ne6uE2m2TWW0TE8G8
         a8mKOb2ewbaToKFJ5bZ85pl0JwObzRgdi1urOZCX0US9aopAsKrIsvQDhkQJ9EV4ea0Z
         myQ3Y3ZNbgvSMggZvShfegUiZOvJjgh1JQT26w5CyKJK50/QohuE1Aa/9A2j+Ilaau4l
         6Z4PEpVlCmuPkaaxdVvVCI4nVuTjCiEMOGSxFloiKJl+0/wzfwz6CvZL5wsGqC3UJ1Xg
         mWrw==
X-Forwarded-Encrypted: i=1; AFNElJ/yL8DGW1aHDb9pMqE9sReD3YlwZ1oTFOqTEi+CPEmOmYIhkjOXlUSWU+eWo5BTPoy1oGFhLku/jw==@kvack.org
X-Gm-Message-State: AOJu0Yx6dWxf+DepoHrQvunhBCcSBMvfAEgO9BlqoNJp7Ux1u5sx8JIS
	/OZJgZ33c0ovDQ/JHspiymzohZG05r2ayAgd7k/IVX2Da1KhdU6VKZ4J
X-Gm-Gg: Acq92OFr9VC+ZM/U5O21B/c9LB+sl1naxnS8yWbdwkLVzYbAuZ5LyGlAC9rPdVpAA4J
	FwJYhPup5tzNfejHrMZmb1SWawZLtLJudrkuG/xK8FuMj35ekN9R2n+N0UkgB728BGIuceZTzEN
	H+IsWOyrNcJA75jZLaCh1tZQIYC4v3IXoLQOn8bT3+ul2qdpZzHM5ojzrVAjFUXRQgPNBUFQVVh
	FCuu4awi0csvGbaaXV5VgfWWMmttSXS5BB7x0mkQmNIXac4+QkZHL8tttPmI+XlZoJjIv512+UG
	FETqJznW1VBRW3WHSoznfAB2QrzAuGnb6z1qT7gsjax9VoShI23BYZQmKXmHlScRcyTa2Qute5N
	oDhfuQkZrKesCifBOOM5YznIwrJtDn5nciaXzDh32MXjED0KmaPoef4lVZ5qnqRyCHrtLktqHTP
	kqRn1tfSA+sDcgChn6ZdCk7YUbGWrTRW5IgtI/eE00uZ+YCAJWn+omsCP0Ww1j/oeU
X-Received: by 2002:a05:6000:4606:b0:45e:8727:be87 with SMTP id ffacd0b85a97d-45eb36aa72amr22395547f8f.15.1779705669622;
        Mon, 25 May 2026 03:41:09 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6cd1780sm27855882f8f.16.2026.05.25.03.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 03:41:09 -0700 (PDT)
Date: Mon, 25 May 2026 11:41:07 +0100
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
Message-ID: <20260525114107.7fa5b4c1@pumpkin>
In-Reply-To: <20260524-tonyk-long_name-v2-4-332f6bd041c4@igalia.com>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
	<20260524-tonyk-long_name-v2-4-332f6bd041c4@igalia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 601B1100003
X-Stat-Signature: 1zh1pg7mdgfbq7b9nzhuszrtbx9xozma
X-Rspam-User: 
X-HE-Tag: 1779705671-432632
X-HE-Meta: U2FsdGVkX1+MPh1fdulIRhA2uW5bJ62HDRCQLHvnaU71pU7++G4Xl1hg6vWi6ZHuLqIVIWe/mr+WIOkocgK47PYs29+q+7+CnUBT31b6IQL6H/E7xWEiWTiUMdXLLxCX0LF2D6TVsDcR+AKv/RDoN3OmE0fExVK8KEympuk6WuNF3Qqx3cXhWc9TmbNcoNITNRM1o8pkWdtQg1q6OfeXgorXjFtCdU+fLteVC6XWdxBKa8b71MWXo22yDJ1DFnAnZoot2HiXD/4SbLUiN7QxVZ6Uw3+VHLlOTdyspnwgmtmAamlhhny/1nXT4u/tMQRyRmFTIH8L74tLbs8pylxXTtLDHKojClHaAGQPrAwzNrN7PszjrcOJ0mIHO4G7mQFb8bsqkeY3mYm+dDUOOcH7HIvaX9mjDr5qigXHnPmAFjTCZjQORGGMRdSxGjg2OoeVyvdwwoU49xHdw8zIJR5vnmyhdIkE7X301xqexSmIOVDIGat0Y+AM8YOMsESeTCEOuvNuSm8I2beTZUpmny7msB614+5pSKd+i+PIGkSlqprwXoYf9xGkSneEQxDgcm/BfcqTR6aRIcosXdglhJz+odxtxmdfel7p3LUrqj+njDZHRqyGv5aqOmRr7ilD4lN85Cnq7zwmX1MsV1iKTFnwfObIto/XS4MTehywlnnsFJvNICO2EdeG4b5vGze1jpOTuwpmtZ9DTd5pCr25MC+Zsq7j5RyGZw+9Br0hmA0EKPOfFQ4y8xbTJN5cFiPVucphOAdcJO1ckDCGPshmKwB7eZmeI148bJj9/F3hKtL50i9QQgVGnME0AgQgPcSUjFRuzZBjiRFuaFkior5fza+w7R2lgG6nsTWOgdCfsvfUrsgtPTATHB0sZ9h+slSZUHF/sxqwtSgfRX7ReipCBIXxPOVzg92g1mJgVkj9xgRVax57Sj+yTglPGoXhZMGcDKPfso9xMunqaAgjqfd82zH
 Z6+ZrcnE
 MwSaPk3WSBEuuoKySoIWkhypearTcXraOzg3f0sxVFq+tBpJT3KD7IuaNU7AN4Ec0GQ9oFf9G0wP+AFnqRvCuPlUe1952YOcvnPoPePu8riqpCi69q63U5JSYBKtTwf+sQgJRR+xgvLjOAUSlqTTiKr/GuyFdcphUWkpdeKKNbmvtaVXg8y1dD5pDftDZAQvXlrao4MhTtGic3C1SLLH107h22iMRQpDogtNaR8Y4dekHWhdmqXtdsLv1Ve4z0YEB9ZTQOeOUS92e/XmNqx4kY8gI5jsxU6U3plPJNQY7Bn7QnlzhIRY379/9vXXIYJkjPtxuT0dnTjRiWDI7d5bP7dpEliFChe65cPO77ZOTaOAMouLmZr7cDxOSVBbh4eXodWcmh1uETSgHrdkZf3bPzBfdrvr7KJJqBocccECRhzCentVzE/MY5Zlu3XHt8uU6qtHlL85fFxpIVABOf60NOIJEIUwTe/ywO2RoUF65yiFamywfZq90Y+pKgIpi4bJ3jhu1nFXA7HiI8ogAtBgzWPZQpzxW3CMGkjC6zAcGFpMwhqkgA54OS/MDlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 24 May 2026 19:38:54 -0300
Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:

> Command name has been restrict to only 16 bytes, which is too limiting,
> specially when debugging and tracing complex software with thousands of
> threads and the need to differentiate them.
>=20
> Just as it was done with kthreads in commit 6b59808bfe48 ("workqueue:
> Show the latest workqueue name in /proc/PID/{comm,stat,status}"), support
> long names for userspace threads as well.
>=20
> To avoid buffer overflows, cap all existing userspace APIs to
> TASK_COMM_LEN, and leave the full extended name for a new interface.
>=20
> Co-developed-by: Bhupesh <bhupesh@igalia.com>
> Signed-off-by: Bhupesh <bhupesh@igalia.com>
> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> ---
>  fs/proc/array.c       |  2 +-
>  include/linux/sched.h |  3 ++-
>  kernel/sys.c          | 10 +++++-----
>  3 files changed, 8 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index c8c3fbd9bfa9..312371eddc7f 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -110,7 +110,7 @@ void proc_task_name(struct seq_file *m, struct task_s=
truct *p, bool escape)
>  	else if (p->flags & PF_KTHREAD)
>  		get_kthread_comm(tcomm, sizeof(tcomm), p);
>  	else
> -		strscpy_pad(tcomm, p->comm);
> +		strscpy_pad(tcomm, p->comm, TASK_COMM_LEN);
> =20
>  	if (escape)
>  		seq_escape_str(m, tcomm, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b6de742b1155..f7fd2b7d131d 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -323,6 +323,7 @@ struct user_event_mm;
>   */
>  enum {
>  	TASK_COMM_LEN =3D 16,
> +	TASK_COMM_EXT_LEN =3D 64,
>  };
> =20
>  extern void sched_tick(void);
> @@ -1167,7 +1168,7 @@ struct task_struct {
>  	 * - set it with set_task_comm() to ensure it is always
>  	 *   NUL-terminated and zero-padded
>  	 */
> -	char				comm[TASK_COMM_LEN];
> +	char				comm[TASK_COMM_EXT_LEN];
> =20
>  	struct nameidata		*nameidata;
> =20
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 1d5152d2395e..76d77218ab19 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2535,7 +2535,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, =
arg2, unsigned long, arg3,
>  		unsigned long, arg4, unsigned long, arg5)
>  {
>  	struct task_struct *me =3D current;
> -	unsigned char comm[sizeof(me->comm)];
> +	unsigned char comm[TASK_COMM_LEN];
>  	long error;
> =20
>  	error =3D security_task_prctl(option, arg2, arg3, arg4, arg5);
> @@ -2601,16 +2601,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long=
, arg2, unsigned long, arg3,
>  			error =3D -EINVAL;
>  		break;
>  	case PR_SET_NAME:
> -		comm[sizeof(me->comm) - 1] =3D 0;
> +		comm[TASK_COMM_LEN - 1] =3D 0;
>  		if (strncpy_from_user(comm, (char __user *)arg2,
> -				      sizeof(me->comm) - 1) < 0)
> +				      TASK_COMM_LEN - 1) < 0)

Nak - you can't do that.
You are reading data that the application doesn't expect you to read.

>  			return -EFAULT;
>  		set_task_comm(me, comm);
>  		proc_comm_connector(me);
>  		break;
>  	case PR_GET_NAME:
> -		strscpy_pad(comm, me->comm);
> -		if (copy_to_user((char __user *)arg2, comm, sizeof(comm)))
> +		strscpy_pad(comm, me->comm, TASK_COMM_LEN);
> +		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_LEN))

Double-nak - you are writing beyond the end of the applications buffer.

You can't change the user memory that the syscalls access.

You can support the longer name for read/write of /proc/self/comm.

-- David

>  			return -EFAULT;
>  		break;
>  	case PR_GET_ENDIAN:
>=20


