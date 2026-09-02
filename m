Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A93CC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82E386B0099; Wed,  2 Sep 2026 02:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8060F6B009B; Wed,  2 Sep 2026 02:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F776B009D; Wed,  2 Sep 2026 02:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51B586B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:47:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BFC61C2551
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:47:49 +0000 (UTC)
X-FDA: 85167891858.16.4B2196F
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9BE6840007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:47:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=black-desk.cn (policy=none);
	spf=pass (imf07.hostedemail.com: domain of clx814727823@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=clx814727823@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788331667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CtlpH4A/FsfIicKK/MMLWRSJhN08nYCVAAoP5yOKMSg=;
	b=Dxw3mybGnodGXR8o2F9TfKJ8BCSIGheSfRRC9K8Q7qefDhtLbaLwaxXBdciC8JDQp1VyyJ
	f/7GP+C7IeDGTnopdbQI/+Ygqg5LY1K11u/7xQt/XsK0EARqdVNYNUziMJel09SH3KD5Hj
	MmcKym/uyS1Drn2J0rPpYFn7uxFa6ms=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=black-desk.cn (policy=none);
	spf=pass (imf07.hostedemail.com: domain of clx814727823@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=clx814727823@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788331667;
	b=kVu4Kd8flPdMQUcKfYyZqYOq8S7XpBL2WxiNcQD9cYKf+mHv87zmA9zugzM5oXW9ZIHeFW
	GdWgf55VfzgH+r4OcsHLdiPTso7zTH+w/ukW9/itlyB/oWIInuxTKvikFscE/561ifcj3K
	4MjOo1DwskwSTIeG42Xn1SMh+pFGfhM=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3a305310ddaso7088781fa.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 23:47:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788331666; x=1788936466;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CtlpH4A/FsfIicKK/MMLWRSJhN08nYCVAAoP5yOKMSg=;
        b=tYTrt3RR7bkAw1YEAlXhb6UyhJy8EDEK8IwOvNfr/RCzlcLKiywlTGjGdGkywF0Ig/
         47xTutwq5VKmB35W8SWzTufHdg3DtPoyyn7yrR4+mS5le4EFUKxdngo7YkLwNXJThc3X
         r6XRN30Yml9tNFwy90pMsGtTeuUlSXqnQmiB/YnEMb4+1+Mp6Tz5LZwpQJhlM6SmFY9/
         G5uhgvBYtAgScoXDykJLqWFdJ8vnVlJayJDiqBcGstiP0N0Uxb8SeEGtpLOHCx0SqxBn
         IO2Kl4bjdqEti1nlX8EKPjyfMUiPKtytEK3iF6OlqsOpkR4fyTeUyf3PrZ81R+76DU0k
         gi1g==
X-Forwarded-Encrypted: i=1; AKwUvBzjj4YA9vihhv6et1tkpgr4AuvhitIlujegz1klaRbRJOZu0fGDnVo0x0RY23Lqw72Dt/63WD0LuQ==@kvack.org
X-Gm-Message-State: AFuF++lGWDJkT6IZALwtC0wa2/hyfufhCPOnIhI+VYMKMkaa9ZGCyzwA
	fDjyiLECPMJOb+9jxhBO/UCUWiBLmbetfVLSHLhBUxhhRJ25GZ10PlDRKm5oPsqglC619Q==
X-Gm-Gg: AYBFou3IR1xo5nKwQUyrWXub4ylz6CxusPsHvButNJAVHhuog9UOOufbhwP6tUwpVbt
	/qoOE4s/HsrxKwnaQMbBeHZoscG0/p9bdERNtJVSIk/WlziOyFV6U3l6P9T8tUbM+eRlarBvqh4
	Zy7/ha6UCgdz0eb65bBmzNfwo28E817EfqioXPQ0FIF6WdayOLJueb3c3aBI/RIZMAZHYESkmeq
	Rn7ZQxFBpoF7UmLiVtlV5ywjdtYfPm0g4yVRuFdDwSMk1NwOWXRbbV6SoVDryl5NudDKc5FGXVD
	8s+JpJ0wBqNlEdO3yQdzxZfxvG3Dloq0bV8nPtIMHNzojEKf4/Y8sAnx73EzHfpFxpDowlF8X96
	vcU4+biJqzZUS6dM6/Vvejc4jSkIyBtSul143XAIlHCxlKkXYy5aTIk/6mEaQr9xg5R2MbPd4BC
	AJB+kCksxc1GZKkus6SZ5QTHtiJ9SR8RKNS3cjgn5AF9N4woANhwQxN13jP6DN/wM77R9JvnKsA
	6nQYENYj92/O8pQFtGf/k4fguk1txp3vbDMcPyzuiXTbi9ZYzcPoSnrDm8j/H4=
X-Received: by 2002:a05:651c:a391:20b0:3a1:8558:56a2 with SMTP id 38308e7fff4ca-3a34fd41c70mr3715771fa.6.1788331665557;
        Tue, 01 Sep 2026 23:47:45 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a34ad01984sm3810551fa.24.2026.09.01.23.47.43
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 23:47:44 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b457a0b4e5so590293e87.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 23:47:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwvFYnRn9yz3lQlcr9GQjULZJXHSu3SaieSjkL5h+tfzyi0NUNiNouXnq/iwRs4QIbbJqL2qxe1aQ==@kvack.org
X-Received: by 2002:a05:6512:32c9:b0:5b5:e8af:a5f6 with SMTP id
 2adb3069b0e04-5b60831e880mr829854e87.3.1788331663502; Tue, 01 Sep 2026
 23:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn> <20260831-tauwetter-werkbank-dramen-b37eb4025283@brauner>
In-Reply-To: <20260831-tauwetter-werkbank-dramen-b37eb4025283@brauner>
From: Chen Linxuan <me@black-desk.cn>
Date: Wed, 2 Sep 2026 14:47:31 +0800
X-Gmail-Original-Message-ID: <CAC1kPDMK_D4nhyRmBHg6KC7SmmCkH73Xtc5DhXeJbSvf3LcqcQ@mail.gmail.com>
X-Gm-Features: AcwNN1WESqzlj5-w8dgp1OujQBVwB04y72AI-TKWGXGM1Ob33MtgcQyu2-BCfjY
Message-ID: <CAC1kPDMK_D4nhyRmBHg6KC7SmmCkH73Xtc5DhXeJbSvf3LcqcQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
To: Christian Brauner <brauner@kernel.org>
Cc: Chen Linxuan <me@black-desk.cn>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
	Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9BE6840007
X-Stat-Signature: e91n87te379ajqett5drfbg3krmpbmri
X-Rspam-User: 
X-HE-Tag: 1788331667-217341
X-HE-Meta: U2FsdGVkX1/6NRyGmW5EuEsFOSPRtYTFOqXOvQUzFmKqkN9rVcTFjoUbzNoV+2qIJyUqHSK6snsrp5cXGlHwD7+D5QPLhREJyZP8Y7gfhcro23QkqgvONFC9ZfH2b1FAbCswqph+65dCotNJgCjTKrauBFLYUlbbhe65EVXJHbpum5gk8boRCa+XHUXTGCB0ZsOzGOuM3fWapeCAZxxNTrUfeBGMWxe/KrhGV6tr40sAu8eN8a/Wm43owC24LnakvYXhYSfEoPnXS62t1RhLMsgTLMBs84zvfmqhZAk26t9HwwhpEI+dzm+gprneKv3o//FfGLcNvcXVt/CwvpVhzH0RHXVDdE6Pi1NLoYCF7FAepVArFME5Uhsfphf8wjtoQO4Hp5aNbOjHfz+W8QzJ7c7Ymv2bdIwTp4quOFdRDGELfCIbX/J6GGChBa1oB+OMskXw3DmZy5OVU97gxE1YrPXlVk43J0YWPe7HdSv31LCsPcGCd0MBfCtaeDx2Oynd44NJBvMsF8iYnHxAo5Ql7IZB1spOzffkq2j+KD+cJnwg+k0SdhYR0uDNCRx62td0Z/9oOzByoGRhEBKmEhQAFrBSCfVoAaulSyXpoqLxMJkD62CSbNptpw9dYNvtfXvZmBWUcIUX9iNoY1JrG8k9qnHDWzYpiyVpfYO7dBxbMgDFYFye9Uy6FJtGokLMujNvt5b60j3i5Lfp/Ky6EUaATxUsxn5OUwduZ02nnspCHEuT8vW0youFBAmFcY7flzYs9X71v83L9lj2AYRJ+Nyzx1tHn6jcb6mz6DcmUwA5JCP86N12Kx330kGK+YNxwsPfLFt2CAdo6bYjAE+v2MRVvEHremwcLzBkSPRgDtQyKkZhOXxzUnzf/aU2cNwAScuoHXWsdV+er4CX1v4dKurRp3eXzfe0dwcYfi92DVT0dyy5PJX641CDXR3jVtqq/vz1TNz/oRZBAzuhNbogc8d
 vyfAZpLr
 VM7L6Bm0HEFy8UirEWe+kMrqMJ/HgynT+foijrNxHxncjsO4BaBsWOiP8jpHU4HWO/Hp7Vl0yN2K2vaoBySWu2XhfmySbQ3G/8l06rzHhThL34Lf7tXVoPBx+fqYPE6MjWx9m0P444nMX0qSDEbmm9bmZMeYpCyUakKroD6LU9CUEfOongZunT0rqJqk4u5tAb4pf+8sUbBjr33LUnguBpg+xKxwow4yygoS/ngHMbAEu7RwWWAKr4p2ugJNEgmHZdBjWqDfPehXuGco86LurY98SVBe4Z5IBXzQfRa1wXe2Ahvif+C/9yyG4CSgZaGVzko3Rc3ls+dR4d0a4vvt71Q89Bu7mA9zpX8Wx9fR7Dn1BTCuro6PymeDIRVWc/DAzxYZPCsjrXU3DEt6YXVTReo4nyS98oHplxORSWy8y+BQD8qvI3M4nkVZpTNmVbv9ZV5LaiKemrPq6533W1DMShgYU+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 4:49=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On 2026-08-31 10:59 +0800, Chen Linxuan wrote:
> > Obtaining a target task's executable, working directory, or root
> > currently requires walking procfs symlinks such as /proc/<pid>/exe,
> > /proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation depend
> > on procfs being mounted and visible to the caller, even when it already
> > holds a pidfd for the target.
> >
> > This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
> > ioctl takes no argument and returns a close-on-exec O_PATH file
> > descriptor referencing the corresponding task path.  The new ioctls use
> > the same ptrace permission check and nonzero-argument rejection as the
> > existing pidfd namespace ioctls.
> >
> > The target task is sampled while holding its exec_update_lock. This
> > keeps the access decision and the task-state read in the same exec
> > critical section, preventing a concurrent execve() from changing the
> > credentials or target state between the check and the use.
> >
> > The first patch factors out helpers for acquiring referenced task paths
> > and reuses them in procfs and AppArmor.  The second patch introduces
> > scoped cleanup for privileged pidfd task access and separates namespace
> > lookup from namespace fd creation.  The final patch uses these pieces t=
o
> > implement the three new ioctls.
> >
> > Signed-off-by: Chen Linxuan <me@black-desk.cn>
> > ---
>
> I really have difficulties forming an opinion on this. So this sounds
> very useful but it has implications.
>
> Right now, pidfd ioctls are available even in situations where the task
> in question would not be accessible via procfs, e.g., when procfs is
> mounted with "hidepid" options or similar. So this would expand the

One point regarding hidepid: for callers that can pass
PTRACE_MODE_READ_FSCREDS, hidepid does not provide an additional
restriction. With hidepid=3D1 or hidepid=3D2, has_pid_permissions() falls
back to ptrace_may_access(..., PTRACE_MODE_READ_FSCREDS), and
hidepid=3Dptraceable uses that check directly. In addition, the
/proc/<pid>/{exe,cwd,root} links independently perform the same
PTRACE_MODE_READ_FSCREDS check in call_proc_get_link(), regardless of
the hidepid mode.

So for these specific path lookups, hidepid does not block a caller who
would already pass the check used by the proposed pidfd ioctls.

> surface of operations you could potentially do.
>
> But again, I do think it is actually useful. Adding Jann.
>
>

