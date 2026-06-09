Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAFB5CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 17:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C346B0005; Tue,  9 Jun 2026 13:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273F26B0088; Tue,  9 Jun 2026 13:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189BF6B008A; Tue,  9 Jun 2026 13:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AAAD6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:54:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A05BD40714
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:54:11 +0000 (UTC)
X-FDA: 84861123102.03.8466A34
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 813B218000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:54:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AjWk+rcT;
	spf=pass (imf24.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781027649;
	b=iqG4Za9kYw+bfEjeHMyN9HWDpS3Jd8hoIhLB/kRju6r44Dn0E1cykePiY81mLBPwgoirBX
	eT4R7lY8ZRuee3NefnfdGao/4F4+IxoFtIiMRtFxqWYTYAlcYewtql9sbRbviTVyQycyyz
	31dGAjzDcliWTXSkEtTURDgMtPp65mI=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AjWk+rcT;
	spf=pass (imf24.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781027649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iPo/rNEwfs0tGz+mQjgisI/ZCW4vs/mt/EjG+vliJIU=;
	b=oePdD+Zbj65aiSb9Q1/tFKBopLwBRUolxb/icLYrX2/NTTciQxZSa42yFiURCVEQ8Jwa55
	+mgspJXF2jlWmJHHPkQS5wdn0CU7ylg08prt6ij8Foal3YaNd6a8UBoHyfQBiYJhwAeSxs
	8GdDRCxmJ88bX8No0TyNVhpr9GOnvlc=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-68cb445dd5cso44057a12.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 10:54:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781027648; cv=none;
        d=google.com; s=arc-20240605;
        b=VOnHiMc0m7aFlraelZ2xsNIsrQPX5wV1OkBVeDEaDSh2QIF1+6H08X0T98ADNvXhVp
         j3MGD5soCwa2rZsuJauCURVOUH1zMhLCKiBwOMLXeubk2Gahy23MZUD1qk18kZ9ekonC
         5AeKwVrr/sZWwTyzE++sE1yHxyt4JuB12DyqCmLen+0L/GGV4XqvYY+uWkJBd4HwTasv
         WKXbgQwYi1TY2C8SnX7PlOwPV5cshNJu7pmG/iM/gdc9j8i3/eT0Z0LHSXnFH5kft7Va
         onFiTSEamOG847lCrRiopfAZE7ws51gzJGuNjxqN3KZwwisgKxt9+MKmToR8bONyczel
         Y+mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iPo/rNEwfs0tGz+mQjgisI/ZCW4vs/mt/EjG+vliJIU=;
        fh=1XEz77rGgkYrNqMgrfd2Qq+hXb0YSh4QbngE9dDm6NY=;
        b=iFdhqhPBPRHehd+GtbgnUKoHfvJ9+ogSU09bjPluEosfoaN4Vze+nvvIx2XnpF3LW1
         B4W+vbzqoxCtMFMXubOck0xwP82m60xthqm5Ifd9PIPmOfcFnASQSAtqnf+hBLuHlcEP
         ynQeENgALA/lDsULbejrGPrdflDeq08pZBvjHPLMnMQVARgq4U2FEtnIrsyHG/T+reLY
         N3/3tbZmq+Gb5mI4Or1m6L9+UBDDMt1CSbeqyzY7nu1jY5bRezutqvsGKYhZkHG2lFGu
         HwwvmGoI7nrvUmeM0HQg9sLlXrZ0J8CNMxDMa2sn2KozIhOn/Rwj29IM4N8ef9bYLLK4
         OtRA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781027648; x=1781632448; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iPo/rNEwfs0tGz+mQjgisI/ZCW4vs/mt/EjG+vliJIU=;
        b=AjWk+rcT9gSKbHOLUIzvQ5L9fLH7lPrIuhWda4mTJ6HIjtkJ5sxIe13SMEnOkPSsPR
         IO2pIZxX94WmAd93vHozvJD+/HNGvYQBzIzrr6csvO4B/TWAzunIkuZVv5asc6YQV/8J
         0ybPmNN9rOv+zXagqPxGpQXXirNnbMVSEI4hMmOCCoZNs8Ip7TqFMBtlP/LG/yn4vz8K
         WLqPGcF1PIVEz6u1ZTV8/kbeTyrtl27vcRgheAuHudMt+W9O4+q3ms3X3FUBHEQuUlVC
         AZm300s7GTwjDUAShD4ksQpWl7D+LNxb20WEiYCs9GVW3K/YlSGzwEMBE3QetqUhqzHf
         d4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781027648; x=1781632448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iPo/rNEwfs0tGz+mQjgisI/ZCW4vs/mt/EjG+vliJIU=;
        b=MOjeyLXKc+Cz/OpNxFW+tCPECmnlxBqC0uyNwLt7pcB3e3vgQsJQyop53j8kIwYCd8
         E8FkR2CxsSpzCrynvx7bEqge4knSoZnKiDAI2GkCFmWLSNVVg4U/cRc8d81IcVtwFp3d
         D1U/aKZnGOdy/Nqiq6O3JlNezbvV6ku8xKUADC9Uj9ZS2hKBSQVy9sab0z5OW8OjFSoU
         wFRplF9LvqiiHKQtrX2yGhuECC8BhQROug0SE2OliS+2PfgwzWu6Rddj3WflTUFBEpam
         8pfu619uKg/wtIP/2+ytN1X6y+UKYc1ch6/IZNvli+X6dyNseAyKotgJwsqt+5vfhfc7
         36gg==
X-Forwarded-Encrypted: i=1; AFNElJ+nUDW4xRaNhOpzOAcCeQI+gUgnNXNLezxP4WrXtzlcuYdTygMYRBcXrzAudwn74PfwBsyioHv98w==@kvack.org
X-Gm-Message-State: AOJu0YyOchkoRFO064By6x1mYwe7BPtk5lMd/unus8HwT6fmfphM/+Zh
	eZATP2n8AD9wNRe7Jl7139uDkIaPCIBEGEJ12kV85Vr2PQkYA7G+9FbFzAh3XAiewf+qgACyoXi
	r1okSr4nQC1t3+p8SNEF6Qe9IRSnKUHQPFN4k2XkU
X-Gm-Gg: Acq92OEEaIfrz7BjpMNZRisdugdqycCyPPr2tSs2iZbCZy1Xet8Sp45q6yErRd3QDQa
	pOyhh8n6p71AnleQlpQYabzEeKwPVq6I7LsJicy9yTcTSSfZt5FNaD89PHUyoa931bYgY3VQMpg
	QC6vArj8waKWxxv+NGTjRuhi/1e1bgpTLIyFnuO1skLqULEqkB/NuGEYfrM4fhbMbxhHjOcOHUo
	vToEHIGdYvqB84FTDRCWv/U9YJTZziDtz3E6fUAX1DY+phN5m+ee54l0+pcruS9wZs43mNr49GO
	+q4vraYOj26dT/+Cmt5b/IEa2fCzAueSbGJD0mjGsXMRCcIg
X-Received: by 2002:a05:6402:708:b0:68f:d45f:e497 with SMTP id
 4fb4d7f45d1cf-68ff191f2f4mr222363a12.14.1781027647308; Tue, 09 Jun 2026
 10:54:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260528095235.2491226-1-me@linux.beauty> <vealb52tv5suireenkke4lul2l3wbnaul2rp3ea545ly5wa5ty@yk3aksvp7skt>
 <CAG48ez38OEE8ZPLyU6nr9=cYx-hMsdoh5WRrv-GMZGMDKyyOTA@mail.gmail.com> <lhubjdk1c1m.fsf@oldenburg.str.redhat.com>
In-Reply-To: <lhubjdk1c1m.fsf@oldenburg.str.redhat.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 9 Jun 2026 19:53:30 +0200
X-Gm-Features: AVVi8CdbotQb6TdiuBRRRFJLKPXdrZXdsDiaDY2tYNXV6Fkhva6G6BZKR3tezyY
Message-ID: <CAG48ez0FCqMaEgosy4K59pKan6Wn5RMbJeOuNWAc_m_56nDVYg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
To: Florian Weimer <fweimer@redhat.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>, Christian Brauner <brauner@kernel.org>, Li Chen <me@linux.beauty>, 
	Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 813B218000E
X-Rspam-User: 
X-Stat-Signature: qc3995qkno3dz5d9ozkqqn8j33kxw4wo
X-HE-Tag: 1781027649-44975
X-HE-Meta: U2FsdGVkX18SNgze5vqRu+LHVOOtLlKXr6Z8ZzF6F+zaHpL10VLIsud68yczZlrTJdFh12umm4Qo2ANm8Uq5Kvgb1r2dJcww/DnW3YfClrubla6hufjiLu0RhY8ZgmoTPKi2Um14oqT+YgEtetW1OWSTJ30x9aTBHVQN+F6TSvp6PTE0DjZinbJZMwPssN/U79UyaG7QoTuEzTeIUKuuSjgHa0g1trNPXS4W9h5ei8lC+lngS3lUlwCXbXXDw7dnh1fP8zVLeQwptDytYGdMuLnTEPL+xF3G+iV9+5/WuFd5vO4em8snhHiwvz2IwHpebJg7HNqS2kwwVs+LsSkggTlGkkCoD6BlzDOzh4SKCICunEraJ6KN+HnzeqevoyTp45LWyrP0CwlScjyfvgoEAUZopqOz9KfTTgEzls748/N5QbjEPOOYUz10YBExv2LWz+mPRRpvBj8yBO8org/9i/BsQvC8c+mX9M9UYfBhJULO6cd1RcazT4MlRTPIhIkOZox12ElsEwe9OqDo6tbFTHNbx3QVFnRU1B2chXUFnFAKl3s/8BgXPgcLMZvrwpzYtOgxHubsmjHulDk06FL8Cl9OZozvnYpNojhuBQdsJKeF/e3xUT0ZAbMyHBgfRrzGK/doR5XDozwaqkTAVn3++i5rIeSGqd9EGiwjSue6yYONI88z0NOYE0F52T4S70P2v/dfPc4ZQ68E73dQ80oJ845cLV0tclJfrXji5G7pSup2XQ4YqX2z9VdbX69FjlQ1QH2DRu8PCxwgx/GZoL/Wyu/mdZ16xmlH/VkPQWba3JXzfr6JQf/LEeDWXZblQsegzwOuQLOobpSgvohDJcEhiS4AIAQuFbo0M85Z4bh2F3V4rCEf67BK0V+/x7KAsOFYv73MBivEK27P4YvCtKVsZNpyQMw02m+ZtFTAP05ATbkL+hPYWigtfNeEHMDk2V9b7SIdrbLUQV3BBJETJzi
 M86BAK76
 7rmuQX7kgHCFk3k9GuFDEQF+tDvklzCpAOMqgio4UdWSsvhCw8/6JUnSOA/6AdoHOxX5ykmw9i3+VvyA2qNIiRzgGxfC0y88BLax5UxJNWe1dL6IB4vXBy1e3cimQvak8rwh1+zNaI76HQcv1tfZ/RKKOWRQsRcbZl9GyHwq82628dyyiTXdNjOKNiV1xryOFCikOj1NjQycstzzsBLqCuRkC6eLT+arpgWZUlP3W0VovO9frbQEmiQ0AopnL1DLu9E9n4v5lHLpVyG6V5y8OQbPkLk+Uoug6LRBM4TBb4eaUZY0ejM9D583xyFYQULlIak4wBm5xP/txZTjAjYuQMJErdZK0jDP4dbAbKv7ucdpmLsIkc5qJtP7RlollcdEDdtdY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 8:08=E2=80=AFAM Florian Weimer <fweimer@redhat.com> =
wrote:
>
> * Jann Horn:
>
> >> Per the above, the primary win would stem from *NOT* messing with mm.
> >
> > As you write below, I think we have that with CLONE_MM? The C function
> > vfork() is kind of a terrible API because of its returns-twice
> > behavior, but I think if process cloning with CLONE_VM|CLONE_VFORK was
> > wrapped by libc in a way similar to clone() (with the child executing
> > a separate handler function), or if it was used in the implementation
> > of some higher-level process-spawning API, it would be a perfectly
> > fine API?
>
> No, there is still a problem with SIGTSTP handling because we cannot
> atomically unmask the signal during execve.  We need to unblock SIGTSTP
> before execve in the new process, but this means that it can get
> suspended by SIGTSTP.  Consequently, the execve never happens and the
> original process is stuck in vfork:
>
>   posix_spawn: parent can get stuck in uninterruptible sleep if child
>   receives SIGTSTP early enough
>   <https://inbox.sourceware.org/libc-help/2921668c-773e-465d-9480-0abb6f9=
79bf9@www.fastmail.com/>
>
> More on the low-level side, it's difficult to make sure that execve gets
> a consistent snapshot of the environ vector.  Both vfork and execve need
> to be async-signal-safe.  Any locking or memory allocation (except for
> the stack =E2=80=A6) persists in the original process after vfork returns=
.  The

I think that's not entirely accurate; if you call set_robust_list() on
a futex list, then call execve(), the futexes should be released once
the process switches to a new MM, in
begin_new_exec -> exec_mmap -> exec_mm_release -> futex_exec_release
-> futex_cleanup -> exit_robust_list.

So in theory you could use clone() with CLONE_VM and without
CLONE_VFORK, and let the parent either wait for a futex that is
released on exec, or somehow asynchronously check later whether the
futex is still held... probably not the nicest building block but
maybe workable? Though I guess it would fit more nicely if there was a
"munmap() this range on exec" API...

> environ vector can be large, so making a copy on the stack is not ideal.
> It's even harder for getenv/setenv/unsetenv implementations that use
> locking instead of software transactional memory.

Makes sense, that kind of sounds like a pain inherent in being able to
execute from signal handler context...

