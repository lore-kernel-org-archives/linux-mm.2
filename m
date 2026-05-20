Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1782CD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 17:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E1A6B00D0; Wed, 20 May 2026 13:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890C86B00D1; Wed, 20 May 2026 13:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731426B00D2; Wed, 20 May 2026 13:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5716B00D0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:29:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D64954037C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:29:58 +0000 (UTC)
X-FDA: 84788486076.01.55EE5E3
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf31.hostedemail.com (Postfix) with ESMTP id CBE3F20003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:29:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Mvj/Fwfu";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf31.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779298196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ivlqf9X+vCo/1ab4f8MfKfXy2yprKWpLMuT5UD154/s=;
	b=55LzClQTbMcKYCWuA5E/GHIu9MRapErwqtCofYTg9/EYlBZgcmwFrUML67DtK0dsWTlVOV
	nw7RfpnXyKaYeIWP9G7Ql+Pa32pnPUQZgBYPxSvjF1cx9h5kJ/mL7iOjwDeGlDnbefy78Q
	SwvEiqWs5mU7GrMsB2+mmaBDg9+bMLs=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Mvj/Fwfu";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf31.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779298196; a=rsa-sha256;
	cv=pass;
	b=sNomB4mLWE8JK8JaAwC0m01eYilkTXnYRPc5eLclz6wO8Ob4T74nxCVIvOjBJ652/7r1dS
	04cqN6y6iRlYUtoukfRAJA8I/O1h7QFXfNgByDtTcwPnL9NFDnHkGgJxvBCHl1b283Be0G
	S0qt4Y7sTkq8NaAgAjhw8PIrZKt5yR4=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-67bf769704eso37a12.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 10:29:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779298195; cv=none;
        d=google.com; s=arc-20240605;
        b=PQONoQJ+lr6fyUKAE2yXZqBIgUOHTQGhfuWl4fErHbislBoZCoeqa8GVUpurkb3j7M
         rBYh40E9wxBbAaZXPtxJm/pFsx1nWx3cKz/XWCEb17IupZSrqbjyxz3/8+zhkd4TDuca
         RWLgi4mhqVTsPSFzQomRFuWKvCVRP6mHuShnbU/l51/KszFQa22HoH390tDorJIMDHPC
         Oxyk8whtwmG9SiBW+b608VKPH9ffieKUau9E5XPR11CGxsCLfUnoG5rGQ6GuN6K1VydP
         2xheIjEHr+yLg6pYAfGCS2tBRvbC4KRTf9ZNDUXP6gBH6hKZjC2NpB6aLP8TRCbodX5O
         gp3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ivlqf9X+vCo/1ab4f8MfKfXy2yprKWpLMuT5UD154/s=;
        fh=dpzWCMh6unrbH5Q8N/fF2W7pDQ5/YXHpqqnIN+u/tps=;
        b=de3AD6fW9D2JVd0IgoRvbcyZae4aqdvWtPWIJAoYlsyrkm6W8NF2rlt1qg2GRItoIY
         xBvQvD382Mv0ozaxB2olAj1zxswziYSO4BLyF+mCf2vZwC1/XYspUToIcgUsQHxYePLn
         Nh9Wq6pCQ1yJvCu+n8ZT7uMrnbjNkT8KWFve1OEi2zQy7q6pNJp5XwhjMbBmJ8L7dsBy
         XvWQP0RToHEDNmwUXI8rJlpjJAz+Iz4SdhYWb1dB05HVPgF1Uedpv3jeOxJpQNZDiztv
         PXjXqJNDkd54dJIor3XKmNFRHA0gD43Oze0KRtzTNXSt/RHgRPukj+1sxmzG4K0jNrAZ
         /xDg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779298195; x=1779902995; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ivlqf9X+vCo/1ab4f8MfKfXy2yprKWpLMuT5UD154/s=;
        b=Mvj/Fwfu6HYa/Km4WJV536Jg58L4NgzcMbrRlmEKEt/MXKw61Pha3bIKN6rF1m97xG
         Yjr3pUSnCScC5BBaqxWsqLkeB1FlYLx7DC8rgOI1e6K6Ww1wQ24eC9wimqQeegbYpZyb
         SShqFgUpcWwogQciGciPs3rlOUHIFJpq5Um1R2zpY0/SMfkq+B3ic/SLaUlG9Svb/NAz
         9o2fdHESykvE8a/a1+9mgDvcAbbWUgnwvl0qKmznzCj8Nm72tVHb+aCwv5umhVPeJv+9
         MRILaaxwYvM4JEP/yT/7dmv4lr5qZ+uqyFnRtRI+7Oacn79fmrQCV6pY2PxUQRUfDpl5
         5Dkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779298195; x=1779902995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ivlqf9X+vCo/1ab4f8MfKfXy2yprKWpLMuT5UD154/s=;
        b=ZwLiqE09p3LHm1Ktw18+f05wMdC6+u10ETgThfs5EO70+4r/W73N3iYbr9bO+qCM3O
         OS27U9uOG3XKjpXEosq4vRAFx3IUG+a4q90VEeUFtKXkCKmmIH+0fSQ3ziOWzJlyq/GS
         fZ4jYiSfIR3snUgPyknWhKVDZMGozXOfVIbazFsGz3l2uVEE4UeWjHvR1ukN4b0EWVGr
         9X3T2DL4zBJ51j11jdzL6ay7ketJbXayhndp4t46h32wqvK2N+3WjFhxjB1UNSB6tGLI
         ynv+uHzPUvFEGj8zJdhkIzwg+1jhXQPeKOHS8WA0rV802TMpEUge86TGN//7MmrjOrA8
         QgHg==
X-Forwarded-Encrypted: i=1; AFNElJ8rlka8SWJtRcZj6DzLh2x246OyanYEmQap3ctlg1I6Urt1yghBIVW45mNDOQ1nGu43wa5r6BAt/g==@kvack.org
X-Gm-Message-State: AOJu0YzW69FffqFuDCUyx0ok/mKOXq69EIm8oApoYve62e9VHrSfMYfc
	8tW1hnCvrgrOw/fqxdu+VJcGCrCaJKm2A02NM5il/PWF4EKTWU16RIGZHhSXslXsu0/qYQIrmx0
	S5yXB2aqx/tzWH55Zmqfk/z6KwJpwVKMGP0RKuQVo
X-Gm-Gg: Acq92OFsPwghDo4mmYlONrtHXi0uXyUGsYs6vnr6pO4ysut/F/0eX8yWbkVl+TlLrCI
	nQU0ztLc8ph925WraRYkVrP+mLKqUOjdgXGhPEbdo4vepkl5lN+b3ZYkuiNaMTNjZ3liCeRjD/S
	LkQfD2wHbPg65KuchupjGAKc295q/q4uNNHUe3Oa4TsldlE3vXGaPBSEo71fa2GOpytKaTWgsmd
	jseYx/q/0iXb1wWr5BAmSYPBlqEPw4JpxgTBsap6rDJPT36nviaaond9lQPAB5HwWn7vCEL9iuu
	sPIDC+uU4ihEZ8GZYnUIL7sR/AbtwFVP/z95P4n7/Y4ReJZN
X-Received: by 2002:a05:6402:22d2:b0:671:fff6:f82c with SMTP id
 4fb4d7f45d1cf-68800637361mr3257a12.2.1779298194634; Wed, 20 May 2026 10:29:54
 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
 <CAG48ez0kVA+Rw+pHSi5-JLf9KTh8Y9Am04W567YS=imgk+b7tA@mail.gmail.com> <CAHk-=wh7CJo_GmRoByrMePPB6sDC2ienhEd8riq=xp0BLPYZYQ@mail.gmail.com>
In-Reply-To: <CAHk-=wh7CJo_GmRoByrMePPB6sDC2ienhEd8riq=xp0BLPYZYQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 20 May 2026 19:29:18 +0200
X-Gm-Features: AVHnY4K_0ZsDeiSnxR8IQSsVI2YaMnhET3qv4365kxsUHduS6tJ5wV2RAJFhBiI
Message-ID: <CAG48ez1ekM0nkBbw1gD30rsVp8x2BJV-6Rb-30L7m_eCdcGVTw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/5] ptrace: keep mm metadata accessible past exit_mm()
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Christian Brauner <brauner@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k1p6xmkq7qfw3fyyh3yobwgcpsjmmabr
X-Rspamd-Queue-Id: CBE3F20003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779298196-836153
X-HE-Meta: U2FsdGVkX18O63a5q3bZ5A5b36HqAcsjMqvNXaSlXIzV9YWlqXIUoaRDAANRVu0dIAFqYBGML/SFMVj/JAdFr0pXyGIWlWHppwxYdn8+nckUJD1y2Fwnwa+z1Wb2WgrejljD91lwyuVcNMbD1x1MGsyR/EJFpMhIcO5bDUSg935UAGOTMk6K3wIjdIQtP3zsa1ff2vmHFPRSULuoNRx3s8OX1iXfnuPFvw87HjIR4S6PSQSTZq5XtKQHvFudt9RM4865EcDhYB2vSgu3uxYDcGCqFdDZ/CEeRFD6hwwIYclPDktYhX2k8qiro8aohj625tpAh4rzr6Wx7BXrLcQMv9JuzB/qIFzXmu8ZxuaDiKKtsa/tZXzQ0seQIThqAXspu2SeJQhpECHgPvriGR72h28U+xBJvomIMtexFtP/+T91VLADQp2cvOqlJLRuVyCCZ+afdPGLvD+1hvxBmpFcgBDyxt+A5vBMrgFcqp457g2SFu8LaSEtYFEtiRt5Gc1CzfsEFh65t9ROXH1ljZw6iM8ms8zCPWy3EPQUwASAWbGfejZVUWP1XjQI8ImJLERkXoJ7VP9BySBLu7Mq5JIR2Vu3ByxV7YiujGpPn8U1vsCeE6mIBN2vwWoxIMaF90YJvB5cjr52tx+IcETwbCZYi3CIitiFYbIb4Q/E+q2Qty2kho3WK435ATLxT3Xg6zxoAzdmep4TpLSV5Rug3hJ8HI8FSvP9TYMKtuDD6TrxlxxiSlmmC5BPFNqctzLm5boThvRwVz/h+JI473rkii+Z7hTwcYnLsPjsvsVYgQmY5e5uZDdhxKItm5IB5Q7XSUqpzaIR8mjdnGpZdOBKBJa+iE3YJu9/TqKwIHNEvJP338gvTUXEGo1Tm0nt/kYPVXFvWNeg3a/KyhNhcO9/UoFp78rpOLKajv6OpW/ocPX4PLQBIn50EV+38aNYOwCqiCgAAeX/Dogy6uPLKJk1xEy
 MN2U+4kI
 1TLkEZ6OZB2vOztY+JM0vK1nVF90UVwxqnG0thMUOiwVDoeSxteXNGgX9z1rYyTtLPRgoZ82PXclWKUeY5mVHExQe9lDhiB7xjtm3UP25JmGhVi930uo3QZBvIGRFFod0cCO1NLBPkuvDgro32BLR0/h5u1GfNxWhHzSwwcZt6ijRqLvF0UBl+fGLTwUI+tVg8v82j7+7yjQq3PqkjgCucmgjPnJLzhMISz56Rj3WPIrEOSjDXX55pikiWhE2UhFNy6yrGVzuO3hAxOBZy4hWXx2wVladSb+mC/nZ5fw4KDvJG2fMZ+nl1RZUzYNqEDyivTU+IzWKm5iDl3tinHTL2DasvBfnUbiKsfSfbWPcsR/4bw5TAtFgzsQtwnxV2f/hYOmLpUEaheWmzmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 6:58=E2=80=AFPM Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
> On Wed, 20 May 2026 at 11:27, Jann Horn <jannh@google.com> wrote:
> > On Android, there is a process "zygote64" from which all apps are
> > forked without exec, and these apps are supposed to not interfere with
> > each other:
>
> Oh, yeah, I remember that horrid hack. I think it has come up before
> because it makes fork() very expensive when you have a huge process
> that you fork for every little thing...
>
>     "Zygote: the GNU emacs of Android".

FWIW, while the Zygote concept is something I've only seen in Google
products (Android and Chrome), the idea that fork() children are
supposed to be less privileged also exists in other stuff; for
example, I believe ssh's "sshd-session" binary does privilege
separation between the root-privileged part and the rest that way.
Though I think dumpability is not relevant for its security.

> That said, I think it's mostly harmless, because:
>
> > So I think with this series applied, any app could use prctl() to
> > influence the dumpability of all other apps, which seems
> > undesirable...
>
> Right you are. How about just modifying the rule to saying that
> prctl(PR_SET_DUMPABLE) just always creates a new exec_state for the
> current thread?
>
> (Insert obvious optimizations: if the state doesn't change, don't
> split it, and if the current exec state has a refcount of 1, don't
> split it).
>
> It's still not the same thing as "always create a new one at fork",
> since there would be no "shared mm" component to it, and it would be
> thread-local. Hmm?

For this case it might work, since that... probably?... runs before
more threads get spawned.

There is also this:

https://cs.android.com/android/platform/superproject/+/android-latest-relea=
se:bionic/libc/bionic/android_profiling_dynamic.cpp;l=3D140;drc=3D2557f73c0=
5f256db3ffa9ac9892b13e226b6ea4c

That's a signal handler for signal 36, which probably usually runs in
a multithreaded process, and it includes this gross hack:
```
  // If the process is undumpable, /proc/self/mem will be owned by
root:root, and therefore
  // inaccessible to the process itself (see man 5 proc). We
temporarily mark the process as
  // dumpable to allow for the open. Note: prctl is not async signal
safe per posix, but bionic's
  // implementation is. Error checking on prctls is omitted due to
them being trivial.
  int orig_dumpable =3D prctl(PR_GET_DUMPABLE, 0, 0, 0, 0);
  if (!orig_dumpable) {
    prctl(PR_SET_DUMPABLE, 1, 0, 0, 0);
  }
  ScopedFd maps_fd{ open("/proc/self/maps", O_RDONLY | O_CLOEXEC) };
  ScopedFd mem_fd{ open("/proc/self/mem", O_RDONLY | O_CLOEXEC) };
  if (!orig_dumpable) {
    prctl(PR_SET_DUMPABLE, orig_dumpable, 0, 0, 0);
  }
```

I think that's a process-directed signal, so this might happen on some
random non-main thread, while /proc/self/ refers to the main thread...

