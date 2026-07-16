Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7EF9C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27146B00CA; Thu, 16 Jul 2026 11:58:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8136B013B; Thu, 16 Jul 2026 11:58:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16346B0145; Thu, 16 Jul 2026 11:58:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69D626B00CA
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:58:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D253FC0119
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:58:15 +0000 (UTC)
X-FDA: 84995096550.23.4EA03A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D3E9DC0006
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:58:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWOPc18D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of luto@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=luto@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784217494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g6oSqoiMEa7OzZXyjPnpquDQDeAESj15pX4ZUB9li/c=;
	b=LFyoHvi0h95+X69CEW1FMfGWcYwtiVvJDEZL3xOcmJBLARqnFm7AtPAPjKLt8B0m1Bd79p
	zF71dWBz944/h2vzND3J/Gu0cQYRyK+CsdjNPvV3Qj8xvxqd0i6daaCz+pEHCAuJUPYr7l
	BWsldRJUryz3c9M3BG8QygDk5ERQWms=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWOPc18D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of luto@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=luto@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784217494;
	b=QvVxqDzlEW7+zRfr3ZIJrwxQB306Bh8/nFhaIoldbMYFi9svf7KebbK5Th+4xHW+uT6i1C
	ClzzhVKQtbAJG7SXbpBm6t7+Kv+oC4rMIuwLiJDzCo5tKDWpKa0yShfVaA0+1pBdqUrHk0
	1KSM5IjvfD3SrJFG1BN8yJgXpRYf3kc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A98E94137A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1321F0155B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784217492;
	bh=g6oSqoiMEa7OzZXyjPnpquDQDeAESj15pX4ZUB9li/c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OWOPc18DUN5kQHrt+xLBtV2PjEZdVi69MM0+NpTl/NYFqRkmVq7sgKSbBUJyppKyr
	 tktDa2H5OLMRJY9fgw77kBkND0XQCSxoVGfsUWBqMLgr3olYo5q705QCWsC84Kz7lG
	 bUZsYA2uTK72J/d8YIx26+d5PnOEou2YboEW0P33zbpj/HtSFLhu8xtc2dUpHX6AWj
	 QRXBynl87zcZl/2F5t17zJM4hrp9eoKy11agItqqqz6js/nESyrVRp9WLk51YXvVQz
	 GOtXvB96ERTiQKX47jzJjE9WW0kC3MFhVgLi3EWtQgacnVqrN4SdqLaPz4E4GRIxcN
	 sHtsksHvmzyvQ==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aeae350e0aso7607661e87.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 08:58:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqAQ0dgKuma55OJnY/GskSrL73TQ9xvlnW1s3H04HK7451THzXzqwQu0LQbWGf7j18ZypaKC7Pjww==@kvack.org
X-Gm-Message-State: AOJu0YyrmJnLcdRwSX69KjQ7XWYJsh1DTC+nfrtsWkylXW6xRoQOW0M+
	rxbUQ/IhByOmzJxJ7bITsLYnTXZ0o6S+0To7Dn9lH9h8DykbhJXYxu9TzHVJHlS2fnLXi/3imBG
	ziEgs79tfaJqcR0S2NNcH9Aa2rxo7WU2Lw3P1kqUR
X-Received: by 2002:a05:6512:64e4:b0:5b0:1b78:497a with SMTP id
 2adb3069b0e04-5b15d7b2ccbmr1132556e87.46.1784217490875; Thu, 16 Jul 2026
 08:58:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1784204592.git.me@linux.beauty> <538e494dd8fcc677da24ec985c6e90dde554e7f3.1784204592.git.me@linux.beauty>
In-Reply-To: <538e494dd8fcc677da24ec985c6e90dde554e7f3.1784204592.git.me@linux.beauty>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 16 Jul 2026 08:57:58 -0700
X-Gmail-Original-Message-ID: <CALCETrU2sCf_Ab2oDcUuJV53mhaDHTtf7QNqPJuFxV_ESHkbtg@mail.gmail.com>
X-Gm-Features: AUfX_mxAk_l8G-Iv8v_7CV1_wrfRphfDpCG9qyDjwBEY1AgFD3q_hB2zypmmUZY
Message-ID: <CALCETrU2sCf_Ab2oDcUuJV53mhaDHTtf7QNqPJuFxV_ESHkbtg@mail.gmail.com>
Subject: Re: [RFC PATCH 12/24] fork: let kernel callers create embryonic tasks
To: Li Chen <me@linux.beauty>
Cc: Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
	Gabriel Krisman Bertazi <krisman@kernel.org>, Josh Triplett <josh@joshtriplett.org>, 
	Mateusz Guzik <mjguzik@gmail.com>, Andy Lutomirski <luto@kernel.org>, John Ericson <mail@johnericson.me>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	audit@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7ehpcctehku6nsukey4977z5rg4aqfh9
X-Rspamd-Queue-Id: D3E9DC0006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784217493-873330
X-HE-Meta: U2FsdGVkX19hFpOogwHPEHb54+sXTYjRMmjjXHBP8uL/aysnFMKRQUtH1ifV/M7iIrPhF+z4LHACRI6ak8aEQf3cBtxyvm/cT4xPKvCZQT9GHMBIOsxjuYKnf2S8wubXJfyeGJAB3e2q2AXax0/net4KoEZbpMQ9mCdYwcHEHVC1+XUR13Xk1yp8HaxbQ7HvS+1a9D6gpzSOsrhRX1B/0PoZGWRpgtBoEPqCYZshGxkvSuTNEYn/zPlwNQVQaujL4WaGKgs52BpezKyAFCh+gHsQvM5+2WNyoTX/U7rfDYcsEUpG/OFCo3msVmVf2R55bf8PYyPbd3idlWlt2dfEsBOH5RWc5Bh7kZL+IdlstQVC430yySMwzVrZpiQ6uiRALenN/craqNNpIwxTchWDRGDdbJ/xXQam+ffKFzJ8zFYwzLEFhSrL2Ya0TZHs13IlT3HhhvUNJzshzUN7p8LIYOGYQr6CV5luMOK9I6P94sc/SWD7D5QYCFMcjypLFsXd4RRZkrhsNZif3BASrEWnCd03342qnkxyOdBzJa5QFPZkyrdPni5oshgTr11a0LCmkGvt6s+E6zxAsy8+jghMcw9eCHemKgI6WAvHRw6wOBOG4QPY4PXqRMYnLJjjLNodyhrEcDvB87JZPqCnW9AdlSF9efZsUPrlBoqNZKXmBp6xUyuTJGexOo7aym6YDGl0gr2nDIyLXa2jaNs1i6p+Tfik4rEKpFH/EEDK03Yhc4EwegDzjhCVbic+xIk2sabkiJGqv3Y9Tpwv7rUTlJ4LRgqwg1WJVXtzZCuJeEniSLVqwk12EnUHQxtToYDnKKahdtFhXHxCG7du98Yo47+OzSvJLMrc4xrRN/3dePKIrBJvsxBx1ovS+U6zHALWCMTEo9NJifmZsvqmMcQLG8EMwSjacFhbEGFevMDmc9V2t9pSPlKEvPJXRSte5dXrYru5/GONABVOHzQQlKHmKr6
 idN9KLH/
 6nZeuequA8MaIhXUG8tzT1VrnpLTM4vIKxPK0yHnSuDYGY49TAVTYEzs6RF0q+RQ0nFDkZXukc9OSngF2hsvOzW+ZynoQNoy4XGPmtuk2/C8Ugv3c8yqp+DJUA8FlOE7wTao2CA0hLLOzJIhalDjK884AxQLFQYDm5W9MmRmBXTM4QR0lNQk2eB3psr2azXoZjeri8F3yit7YVnh7/j783VzYO2tVQeUYCVtpfTUOB17Ku0djuMH2MhJk4u4/s3PdRhRjU1NaRg1Sr19NClRVG/l9W8rmn3l0gZbMoFxaHBV4VeI3xYaz0MQ7Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 8:52=E2=80=AFAM Li Chen <me@linux.beauty> wrote:
>
> A kernel-created task can become visible before it has installed a new
> executable image or a valid userspace register frame. Exposing such a tas=
k
> through ptrace can disclose kernel setup state.
>
> Add a task-local embryonic flag and an internal clone argument for caller=
s
> that need this lifecycle. Reject ptrace access until the creator clears t=
he
> flag. Clear it with release ordering and observe it with acquire ordering=
.
> This orders visibility of the completed exec state with the transition.
>
> Existing fork, vfork, clone, and kernel-thread callers leave the argument
> unset and retain their current behavior.
>

> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -56,6 +56,8 @@ bool ptracer_access_allowed(struct task_struct *tsk)
>         guard(rcu)();
>         if (ptrace_parent(tsk) !=3D current)
>                 return false;
> +       if (task_is_embryonic_exec(tsk))
> +               return false;
>         es =3D task_exec_state_rcu(tsk);
>         return READ_ONCE(es->dumpable) =3D=3D TASK_DUMPABLE_OWNER ||
>                ptracer_capable(tsk, es->user_ns);
> @@ -312,6 +314,8 @@ static int __ptrace_may_access(struct task_struct *ta=
sk, unsigned int mode)
>                 WARN(1, "denying ptrace access check without PTRACE_MODE_=
*CREDS\n");
>                 return -EPERM;
>         }
> +       if (task_is_embryonic_exec(task))
> +               return -EPERM;

Would it be better to use a different error code?  -ECONNREFUSED?
After all, this isn't a permission failure per se.

There's a not-locally-obvious gotcha here: reading other process
attributes prior to calling task_is_embryonic_exec may result in
(security-relevant!) data races.  This should at least be documented
-- it's critical to check task_is_embryonic_exec *before* trying to
read credentials.  Also, I think /proc and many pidfd APIs have the
same issue.

--Andy

