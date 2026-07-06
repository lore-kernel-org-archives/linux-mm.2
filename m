Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EAAEC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 16:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677066B00C4; Mon,  6 Jul 2026 12:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626D46B00C5; Mon,  6 Jul 2026 12:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EEA46B00C7; Mon,  6 Jul 2026 12:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27B426B00C4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:48:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0A501A016E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:48:07 +0000 (UTC)
X-FDA: 84958934214.10.3F690F0
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id B576C40003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:48:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b7tlIV+j;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783356485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zarcUzp/fr15vy/Sk3GURs8seOzb+QEYuzaIJK/NbMg=;
	b=z4HsmqtS8cAyNRRrTEUoS7dkR6/OXpwve975K9Y0EWNMmkYg6RKfQ2ZlIbWKdYhJNeGeeR
	ybuMjwbxwNnClPpBHruBqUiiuzbFuBwUBoqe5YK48DTqwLj7OXokCQ4IqKy3UNtPgYnwDl
	YyGGc4t8j+sSH+K5MOHWwnIB1g+dJRE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b7tlIV+j;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783356485;
	b=hdUW/K0KfHHIc6rdi5549pOxXmsPIh7o+Dl38oWltHKu0i3cA2FJ1TZDD/SMAtQmtRmd2n
	Ypj2pQ8F3PvQSibZPiV+2QFiALM6/AG0ZKqD+VjJc+9I8NhsVBAGxUWmLNl23muC8eMZCD
	51vowvc04XxWG9zffapViF4xbtsauAo=
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-495c63c4141so2406269b6e.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 09:48:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783356485; cv=none;
        d=google.com; s=arc-20260327;
        b=mA1L4IFqziwGjRPEd8H6amhnmOp2Z8T5W28LF/mlxLEqH2t8tL/oC4HrZak076rgbZ
         pza8zKmsMQXg9ZYLN3EE+nMm5LjFJxkdYWMis9ZGVrzFhsEdl0wOJK/YY9yCiTnwG5mV
         koa+2kG+Wm8/QGSC5j9IWjWJ1VLyawv2oDYe2w4lSsQzpMWKPjeZAbPb+EL5tC/+k5al
         78no5V6G5LPuPw67C2dzoK+GbzMOtkd1tJaX7mzc1sbpUfsuG1oouoLkxBuZSRpRxb6i
         HA4a3jHh0wMp7PVPoyic4X7xLRSRtp0TcVL039xFLRoAGNnG95rW1q54Zi8hTtONEy5q
         hA4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zarcUzp/fr15vy/Sk3GURs8seOzb+QEYuzaIJK/NbMg=;
        fh=i5VYr7WOMpS9slmBInjTLslEF1ad7YwtayXvyb9XP5Q=;
        b=LAUC4gbn+Kmv1K8Jevxo68zJNnEjCYT7kcdmTd/0BgQRiYg3g0SEi4OClXqKkj4WkZ
         SO0gh/GMcA8uoRmgBijWO6jX8rsOln5wZ0rceNQ5CcwG5p7+2Jfp8m9D3P68VSBma8Ih
         F9m9jqfsKkEU61anL409ekESTVZQUd3G+GKjT3JH5qaUeOI1izFo9yTJjT5YELZyeS9C
         7u4YZYiLaD6VxZsu5DWwLstELvUHYsWzMUjsmt+Op32tfXrzMOjagrNhdnLWq7ivyI5g
         psYXsldGc1cmO18JqavG2TYED/4C847FNe+Niz95d8H2eu/VgPxrqjLr5UaAhIyvBVtc
         mAdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783356485; x=1783961285; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zarcUzp/fr15vy/Sk3GURs8seOzb+QEYuzaIJK/NbMg=;
        b=b7tlIV+jaTb+VF+dF5r3gkF9IIG130qJfFtFdTOUI0mYR4PtNVWp9JWIkWclYwIIOv
         h05TqRI1h1bjh5HeN0A5sdHKyEU/XRVSE8pXKgCmaqzxfK84P6pEAbR1U3ZSvNAwGtV9
         0CDBhMi45+ta6qDlk49WqAkgLlwKZ5htVXXTQe0nAeSFgHf4Tm4vepvSFdOCu0VjjiKr
         j5yQluxcAtOIGMhDoV1rZZMGzxsiyQCVR1nsiS6r9kuToPWZlk/CzIeZ8u1+nYZRT0xT
         BeQX063VAq7PTPTOraHr7i8+hXFAwyx30hl08C19sywk7bH9vGiBoNGRXDV1OjYqi048
         X1xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783356485; x=1783961285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zarcUzp/fr15vy/Sk3GURs8seOzb+QEYuzaIJK/NbMg=;
        b=UoPQA9KVRFJt2d6qLbqs5EvFzvYyJopAhm0tmGWD7qZAoi7oz8cE5DcagjQa34THr8
         VO7tQ0mDaitMvjtPig90oDKBzBRVHUlp0HiuV+2kpNurQs0cQebEG7kbMAE9gMo5nEXY
         /JHC8UO7SAUJJ1KkAh0A8ifl6H/A9MHeeLVRZiKQPGQq2A/Xcmr66uP9UNaqKX7mpKFW
         sh7TTfFpXjaGjxTf32rE0fhWVAuchr+jvf/efc3BxoPmKmscQY624516dOf/BRanjE63
         vkAa5WS80HqcNpmwLNc+0fkmkgSFgK5lQxGGCCgEXQkkBWs5mBHw0YSAVCgSoOAYDT+2
         RUKg==
X-Forwarded-Encrypted: i=1; AFNElJ+LNACX3ek1VpY49iwGeBv+z2WouI4r9C7+TVJ+Bfm6GPFw+YD7LI3Jr3xBJDrNFcBgsqaJIVjFig==@kvack.org
X-Gm-Message-State: AOJu0Yw3lBLAkBZ0bm3/BftMJPJYfcgTX8Qr/f18sAHaBLEhUG/mm7Y4
	ehNuIkEXODjYmP8ivWgl3pDn7Rv0EB/0ybNs1HbVMi2VuwAzWN8F1eX9hqyP2Bprbn8lwWzfN6i
	jJ//3fD7z/LI8q7NqQH4+cL1fOWpl49s=
X-Gm-Gg: AfdE7clSosh1aBmYBoufIHYhEhQXnA+nkeNW1Io2t94YuCEB5tHJJ3X9dCe3bnvT+vV
	Vpt0x9pkDZjuyX0rXyELhiUR8uNxHRPt8kWNnAE2ctjv5YWapIFlgqGt8LUusvIyj9/jP8grRV5
	Pb4t7Y3pyVt3E9oneIYJ8suhv3eyf1htNud8DHTQuQ4je3gS0UQRqySxt4UjTMMMES1xli0izZQ
	kIRjpR7uU+m7GZFI/rgfUBd/aSYUNtBy2fTdBH7bxySGOzOGbGcSSU5XFA3xn6jWYNGgg==
X-Received: by 2002:a05:6808:3986:b0:497:df42:1df4 with SMTP id
 5614622812f47-49fdb9341bemr1075973b6e.9.1783356484621; Mon, 06 Jul 2026
 09:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com> <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
In-Reply-To: <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Mon, 6 Jul 2026 09:47:53 -0700
X-Gm-Features: AVVi8CezoZXmxdx0EVJgscHRgUSuI56V3d2lgnD3ARstqF0mvBDKn_k51tgqOEc
Message-ID: <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
To: Christian Brauner <brauner@kernel.org>
Cc: david.laight.linux@gmail.com, jack@suse.cz, jannh@google.com, 
	kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mail@johnericson.me, 
	shuah@kernel.org, viro@zeniv.linux.org.uk, Gemini <assistant@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B576C40003
X-Stat-Signature: dwkfzxte8u3u1wqt5dgomxqfhaq8xbwr
X-HE-Tag: 1783356485-825525
X-HE-Meta: U2FsdGVkX18HaVfcve/V1Y7EJ2HEUeaWCy9t+3bPPEsekvr3ghWfEZOohIwbFebNjnRoefPfpmBRjqCk28oICXGfDzthVsqqVJ2Kxt8zIdiOzMRGS0rSno8b7LcSzjMoWkiBU6H9lJk/QLKQiu87cjq5gl9tDLf/tGmNNkHZDBA6yHk6KghnwzuzFJspUl55sibG5c+vqlMBhTD4sc4nguLWAUu2wsWibI8LhiskKjeYYDM6+QaPPGPpenO87YbLTFjdpwT7KQ6PoC3vKzeCEyhgOadcgqetUGdO6Au3v1NrUzueKdORzDESKO2xcNBKEFE04gvDgL0zfkluCKuoxBy9bnkwpYhfd9IvEyQL+ul70gUOT/tzAxl/R/EXSeAEY6LVO+A7iPgLrlcIeSV7zi3VF1wW5t5lQo8TvYSxsRAV4/NXhRuvAiyH6jxv6BXIz+LSXdH9SNjCS9oJigMuRVPcJQ6txPG9gYnwVkkAOjhfamrXFhqVehh2iEQhDsE3uL9RUYDimo0xhhbr5tEZTpaLQUzorgN88cGY1q1UeJNezGuIZzWbMfaFH+tny+PbKLfBKG9nSvMgPhi72SyuQBwobtHqxByZAQX8ym7+UhXI/7nmhB1tSsYZbDDIeiafbvhZyWb1ioF/R0MLFyNizh58M4CvL0jxdZNo9upACqFXD+xqod/e9wJDPC5YNUPQ/iTn5qORgDBx/UuK93IDXQsCjlcgTvX5323lf5Cy5PK4VtcOSiLEOXOl9QQabboA/wp+KKBi25jPAwp3oMbxMkJJO3iTQf3dh1FLhpSq9Epd+DUgO+m3TXErrUCC7e6LHQLwrYtnEHQT00SDo7gQQ2MirTYEc/+tG4vwOWmSiERNQntbWeAYLtAFvWtS8msFUZY/cAVuUlJ6NSAWoXzwWNRZEy20gHz73k09IbJdjbNZ1wGTk1WQdczpHRzWVa2cGH/dxt6lP73bPD0Wj0G
 94s/FOG9
 DC5WJ5w9cH6dWn6G46J8XF+296fl8YOXC9Rr0mNmeQnJ/royRO9DqGlASNLGCm2ZbsIeuGxlBrne1qegTCludg3aGmWvF8tPcCPqgh0xW+w5s0zGlD5RjCWH+NBYJPShcHzEge7bnsoZh7rYrdbEqmrac19Y0GPdohPgyEZAQSz4uWtjjsymOqDD0Y56OI1JTcTEKvySruxix4JZx7o7eP0wgxCZVDlEC+jgsO4GHZnrrRI68jX2AbrDlq/4JD6tJwIehlVVS0C9nb6aux24a6blQ7hkHLuIGvrssd2rJvcBY2QplU4A9ABAw1MXxm7IfoU94fBukBnpuTduu5nzOHBJo7XcHAL6pGhkFzSjsiU3LVxkCNfQ8vRZUFhhh2Hh6M6Ganicfeh473kneQvImidpJ8f2ksJV3axeOI6h+cEvbNpNn0mBABca0WBjoayFRBjI7XcRucpYfD4x80a84Rz/6uMjyTqy2AtMNUQi6Xzcc1jH/OTDCnlZ4inz/8ry6BK0So8AhgLCGVp3FxFdmHg9+GOORiDPnemPSLkCivnU6sH3knAisdAU/zetnX8gcApJ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 9:01=E2=80=AFAM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> > Historically binfmt_misc has only matched binaries by magic bytes or fi=
le
> > extension, and always redirects a match to a fixed interpreter recorded=
 in
> > the registration. This is insufficient when the match requires parsing =
the
> > binary header (e.g. inspecting ELF program headers) or when the interpr=
eter
> > must be computed per-binary rather than hard-coded.
> >
> > Introduce a new 'B' (BPF) handler type. A pinned SOCKET_FILTER program =
is
> > registered in place of the magic/mask, and no interpreter is recorded:
> >
> >   echo ':name:B:<bpf_pinned_path>::::<flags>' \
> >       > /proc/sys/fs/binfmt_misc/register
> >
> > When a binary is executed, binfmt_misc runs the program with the
> > BINPRM_BUF_SIZE file-header buffer as context. Returning 1 selects the
> > handler; returning 0 falls through to the remaining handlers.
> >
> > Unlike magic/extension handlers, a 'B' handler carries no interpreter o=
f its
> > own: the program chooses it via a new helper, bpf_binprm_set_interp(). =
This
> > lets the program compute the interpreter path however it sees fit (for =
example
> > relative to the binary). A 'B' handler is therefore a strict superset o=
f the
> > existing magic handlers -- any of them can be expressed as a program th=
at
> > matches on the header and sets a fixed interpreter.
> >
> > bpf_binprm_set_interp() is exposed to SOCKET_FILTER programs and stashe=
s the
> > chosen path on a per-CPU area that binfmt_misc reads back immediately a=
fter
> > the run under migrate_disable(); only a match that set an interpreter
> > allocates.
> >
> > Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
>
> Ignoring the blatant bpf abuse here I think this is quite workable. So
> this can be turned into an actual design and patch imho...

Glad to see you think this proposal is in the right direction.
Just for my edification, when you say "balatant bpf abuse", you mean
how it abuses the socket bpf type?
If so, do you have any guidance on a new type or should I just take a
stab at it.

For the proper RFC patch unbastardized with tests, should I start a
new thread or is
the convention to keep attaching it to this same thread?

>
> Note that binfmt_misc is namespaced and can be mounted inside of user
> namespace + mount namespaces fwiw. So a container mounting binfmt_misc
> (a fresh instance - few do) would escape that bpf program. On the other
> hand it would allow to register a custom bpf program per container if
> needed...

That makes sense -- but you will need CAP_BPF etc.. to load the new
programs though
if inside a userns.

>
> --
> Christian Brauner <brauner@kernel.org>

