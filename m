Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89254606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 21:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FZHk2/+9
Received: by kanga.kvack.org (Postfix)
	id 763C56B05B2; Sat, 31 Oct 2026 17:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714676B05B3; Sat, 31 Oct 2026 17:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6047F6B05B4; Sat, 31 Oct 2026 17:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 383F66B05B2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:39:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24D75C017C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:39:31 +0000 (UTC)
X-FDA: 85384238142.22.5552890
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 95D10160002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:39:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FZHk2/+9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793482769;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7H7cXGlDlil6ZV+zgm8kUhVnxjK56KVfjw3bskyCfV0=;
	b=VNIWQ7awVTlJJv3nlAgTLo++DM3cI/OTk4fFC2esS93K/sL8qO8c1Ohp3F5/Rj1anmYscy
	LLqHlm4BncHfGA+nEvOCzRThfA90jDtZcUBxjuCL9yelyjYm3UR47EVMuihl8on40wvtvA
	puoBJ3mDK1OCvpBq/7+0kEK1tjWzIt4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FZHk2/+9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793482769;
	b=gdVYuFUIXlmXYGpxgoX/it/RMSzsL3yqNkfzQ8pMbMM2rUl6aIm/S7ov/qRQ4msWOhLrh6
	/nhZ6HQwnrTtk2lCkygXdbo9IEyjGpaNL/0H5X/P3Bd6r776ORYTeazbr46qD06gdRwEc8
	rKj7cQhvD63w37Uz4ReGk3xJMFdpcZ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3160460234;
	Sat, 31 Oct 2026 21:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE841F0093A;
	Sat, 31 Oct 2026 21:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793482768;
	bh=7H7cXGlDlil6ZV+zgm8kUhVnxjK56KVfjw3bskyCfV0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FZHk2/+9ACjM7o7Rjf7SP/4O3KHTPhWa5w9B2T12kMqVSLkBY0utwyXfrtOG8GwXD
	 9E8rjAS7AMjD9jrCjJnOIlDsqeM/Gn5Ku6l5q2+f7Gds9PLHnvmALDW4dY7pLmYsEG
	 bqqxXfI0rlIhnmk5lBxig1yjz/UpwJgOkx64KX83cjKYxK+BSb0ZBhBee6MdL6BfJl
	 +/E5mUb5xx9Uvfe4Bk22+M22elaQwVQEI+64t/VoDTtPAYgJOVaGZQaT6DABLSvAAn
	 0orxhLjf012TPAs7eySi7/mT8XhpSPN/jD7hYy+2M/Zm1b6qQVj1rT1sb958mf50xB
	 9g1jgdeYN6MUA==
Message-ID: <sashiko-outbox-192182@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 5/6] prctl: Add support for long user thread names
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5kcsOpIEFsbWVpZGE=?= <andrealmeid@igalia.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Christian
 Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>, "Shuah Khan" <shuah@kernel.org>, willy@infradead.org, mathieu.desnoyers@efficios.com, "David
 Laight" <david.laight.linux@gmail.com>, "Linus Torvalds" <torvalds@linux-foundation.org>, akpm@linux-foundation.org, "Yafang
 Shao" <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com, "Petr
 Mladek" <pmladek@suse.com>
Cc: kernel-dev@igalia.com, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261030-tonyk-long_name-v8-5-c9b030332254@igalia.com>
References: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
 <20261030-tonyk-long_name-v8-5-c9b030332254@igalia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 21:39:27 +0000
X-Rspamd-Queue-Id: 95D10160002
X-Stat-Signature: co4jkmzkwynx88d9pmoqc84zgu7o54ir
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793482769-513652
X-HE-Meta: U2FsdGVkX1/qEat3gY1ogzxV/pcuPdCzrX3b82PS89ZmYLWrCwQY2meiYjXzrHfOhG3B84FtFe2O0t9EASyzT2WughUmbaxZiR4HxT+6SxBZoCTifUpsPEgXkizUEvJdd3rKT68b18LMFsI9ph8YU8u7zbMofETR+swN907lGlxeHo5ZVRSoPWEby+S35dO8Y4EiQOVczsudybvA6IZXg2VveBMIi71kek3oCdWw/wqPNFML4mj+q/V86M1lTshSoTDdIC4bLyCGAMkc/+AH1eEJDu32FrdZ9sd3M2KoWGB+N8meAq06RVyEftu6AvZrokC0cG2qLjDLOzI9HnER1l74kWA+NUYRUz5EfnVMQDLw4UD1BQIHivDUmyK/n0ZB5K9vD31RivlOLxWLroE/5ZWcqWtbuDjItxWAJBJeOpha02HTSwDQnQoCZqXG135Gl1KiFhg48SLHBBpoafEAjMhBJ1XmxLl8jMX927aFwckRXC7dNKB/jq+EgA5OS8/FhFoWhx2hdaAAPA+++/YfcndyXOgSva9hn8G/p0LULx7sJwogTiRhNv4H2ydNpNtASA+vtBhiJCY6YjsD7gq9xnWXW1CHrK+f4akgxPI2JT3TPSWOD47gBEZULcT8UxT9vTD3WyFDNGPUHWmvRE04BTPIiao84mepp9tuK41vz0eI89DUBibNls0WmhgT/WpDkxLblQlv+NzAt5OY0st8Li6qUXeko4/S3nr1pJP0qpLKNCPwNh0uYEudSWgQP8p08oyl5phE7PQ0l0Is80Qv+uRdBkUF3uo8oIJu0uD2R5Znb4NT+ElNnnYKWgF9HiIYJ4SXi+OyXu+HGWVcrx9hpyUkcTWzYxUO1fDIx3PoF7jbE9Z2k8mHs+Ky253aS8SCb7gm3xM8oTRNz2RYJTrymCVR2hfeagxwSeo9dgHevInHY8zuU0qalOO2NhxFmWwsnZeDF5TR3dBIVb6MUfZ
 ZhQ2IRd/
 Wgezd5oZYXhBhAGpKkMNCfgLsaE3UGogI+QygbaumzF16qLXrpT7+Hl4EtnW0m14ONe5Hd60ZdbsN0WIu9GfQV5J0uFBc+63q6faMR6xVeSUo+8mxyiyXzDEwF4UFZ1tDAaybbaNcBVkPk2WX4ropBtVOUY4S1bgm6u/KcUUQpD9L9Hictj3cjXVtPYeMlt6a8B8QTqCXEUwJjXiuV5trAepFIOiTgNznbcibMmIW9vlTXOWwpRUJertBecdQsNfrio3wAr+2Zp6xsIfAIvM7Di0nm/8IPWbuZnkW96uRIJ+OswjsoxXNwmOj9lDqIRXHNqRKNDl54OmkJdDlFeKjqhRaYra0sPgDdyVHYbOLj8/7rhlOkfo5AvqkoWEDwugl+s7F4rp0kKg2WiLEpEreq4vdY1KiFZpljaAldpouQVrSDc5oimVlKY9nQbq1tU3zxrOu4norOffjUEu/f1oAollElI6MgCZmLGAlw7zcDBF5QlLulgFHR+P74gRdBCKcgE3VwiloE1BLkO2s9jiZalVMV4Sx2jGjJ5r/gGOdcxx3wwHqhRG2KztGE+dHEWnXld0jXt87OOHjcMTvVHr3KQnsEiOK+VNfl0GCth15h0f5YZfi09sI+9boysrPzae3ZMixiYV2MCC93RG0i8NWEYzj/GCrV8VEnqiWp67tA4Sd3EuGJ7/G54imXSkEjcohpWqB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] prctl: missing arg validation and buffer size UAPI in PR_{SET,GE=
T}_EXT_NAME
--

commit d86849bc61de6aa30e004f18202851c2e72d0d41
Author: Andr=C3=A9 Almeida <andrealmeid@igalia.com>

prctl: Add support for long user thread names

This commit adds the PR_SET_EXT_NAME and PR_GET_EXT_NAME prctl() options to
support getting and setting extended user thread names up to
TASK_COMM_EXT_LEN bytes.

> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index b6ec6f6937195..a07f8edadd652 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -56,6 +56,9 @@
>  #define PR_SET_NAME    15		/* Set process name */
>  #define PR_GET_NAME    16		/* Get process name */
> =20
> +#define PR_SET_EXT_NAME    17		/* Set extended process name */
> +#define PR_GET_EXT_NAME    18		/* Get extended process name */
> +
>  /* Get/set process endian */
>  #define PR_GET_ENDIAN	19
>  #define PR_SET_ENDIAN	20
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 6a72c7e644e70..fc9e3c5a91353 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c

[ ... ]

> @@ -2616,6 +2616,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long,=
 arg2, unsigned long, arg3,
>  		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_LEN))
>  			return -EFAULT;
>  		break;
> +	case PR_SET_EXT_NAME:
> +		comm[TASK_COMM_EXT_LEN - 1] =3D 0;
> +		if (strncpy_from_user(comm, (char __user *)arg2,
> +				      TASK_COMM_EXT_LEN - 1) < 0)
> +			return -EFAULT;
> +		set_task_comm(me, comm);
> +		proc_comm_connector(me);
> +		break;
> +	case PR_GET_EXT_NAME:
> +		strscpy_pad(comm, me->comm, TASK_COMM_EXT_LEN);
> +		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_EXT_LEN))
> +			return -EFAULT;
> +		break;

[Severity: Medium]
Should PR_SET_EXT_NAME and PR_GET_EXT_NAME in SYSCALL_DEFINE5(prctl) valida=
te
that the unused arguments (arg3, arg4, and arg5) are zero and return -EINVAL
otherwise? Because libc's prctl() wrapper is variadic, 2-argument calls from
userspace can pass arbitrary register values in arg3..arg5, which prevents
extending these options with flags or length parameters in the future.

In addition, PR_GET_EXT_NAME unconditionally copies TASK_COMM_EXT_LEN (64)
bytes to the userspace buffer at arg2, but TASK_COMM_EXT_LEN is only defined
in include/linux/sched.h and is not exposed in include/uapi/linux/prctl.h:

include/linux/sched.h:
    enum {
        TASK_COMM_LEN =3D 16,
        TASK_COMM_EXT_LEN =3D 64,
    };

Without a UAPI constant or a buffer size argument in PR_GET_EXT_NAME, could=
 a
userspace caller passing a smaller buffer (or passing a buffer length in ar=
g3)
have 64 bytes written past the end of its buffer, or break if
TASK_COMM_EXT_LEN is ever increased?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030-tonyk-long=
_name-v8-0-c9b030332254@igalia.com?part=3D5

