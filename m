Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37BAD262B2
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 05:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F154E6B0088; Wed, 21 Jan 2026 00:25:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBFCA6B0089; Wed, 21 Jan 2026 00:25:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2506B008A; Wed, 21 Jan 2026 00:25:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D176E6B0088
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 00:25:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6092A140721
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:25:05 +0000 (UTC)
X-FDA: 84354832170.17.A54D209
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4DC8A40007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:25:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gzGw3eNe;
	spf=pass (imf12.hostedemail.com: domain of avagin@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768973103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJHw0lGeqaxxhmKwhAVb/kT+sCLOXmrYZ/McZsFTgWQ=;
	b=AQE1ig6jBos6aGM1ZO8LMRcdxGFTJuw6ODc0Ww0St4RmNyN9Az6prZhcBeWgYtILZM4Vty
	jWUqjmtAJxIEca0AGxNvhuEBqLHyvMTCSPlW+oErmsPD81Sh6+qlxHDItUNcuOHD0fYYvp
	BuZe0Taps/8JYSxICY0Y9HuSq7oLXnY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gzGw3eNe;
	spf=pass (imf12.hostedemail.com: domain of avagin@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768973103; a=rsa-sha256;
	cv=pass;
	b=GY0VAb7CvN3wseBZJBhJ2gXPNbathQuPH1Rxq/EA92KGBKZJz0m+5P17K0o+oLybqv6lfA
	coR7jUPGpF3PiwwsCgElyScVK0Tsy1OM5tlrbKei3xkuFZcYTL+LjCYVa18O9HJuCjC/cx
	cSudN+Ea48Xf4GvyiyLdK2CKRWT8Nd0=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50299648ae9so240561cf.1
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:25:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768973102; cv=none;
        d=google.com; s=arc-20240605;
        b=keUIavh7HRKhl76fUHzKpf47156+6X9ByELdgdkl66vWwge3+am6Y8C+cqggYENqO2
         7pIen2aU7t9lBJ4fF08vSU7fcaHzPHjJiCbwsmWc3oiE66YXjHDUGqtMzI5Bs/rDC5Pk
         HXc5SZh0+DRfB6nWhTLldtCgzR1AWSPDL1cbuBLOURb/ZN8ok/4uOD3vWQXvWVDxnpSV
         cSigcHk5UJ5HIp1X0ZP9nU71XUEBqLjkif0d1Wp8ttTgJ1gJ8Jqdgeha/fuImWU81yRc
         XW13I9cSY+wUTojT3fBgEf20nQ2WmTSTZUKrTbMZoC3vxgDttk3syxv7H8vB+gVXgZtQ
         Xi2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YJHw0lGeqaxxhmKwhAVb/kT+sCLOXmrYZ/McZsFTgWQ=;
        fh=4CztmjuFwdo65MIztFxko+Wr1uF7IoOcUdJS4BIMppo=;
        b=YovRBw5kixV32sfCn/U1T76MgOHmsXyHLGur0+ViuOxJvImRyOdyXeDAvA+v+/BK2q
         RlTF2Zok/DABoYjErvAXjn76HY9fViPR1NFzYtdeem+BRO2TTmfInmamCdtDhnSy/VVH
         DE4etwid9mFQ3LIPZXAodoRVvHBq3AUYYvhBSMGUbMHcf1xejq48vTBpTgQw1WMDlNHV
         IrV2Xry2NcYJ56mCAv6GY0gIDl+KKTpS7ipdUHeIqx7BLhIFwE/NqLroWGihJAsSluzG
         t6J6cLW9+Ivq6tVedwxHy+s2/kbvrbV28l51F9XrkgC4c4IZo2P0nRi3zh08zi8D5TBw
         UlFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768973102; x=1769577902; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJHw0lGeqaxxhmKwhAVb/kT+sCLOXmrYZ/McZsFTgWQ=;
        b=gzGw3eNeTgUbtgH8PuoKCeebiDonOfBb6SJJDIjpCf85thvZJeaYw/k7TqInr3H37l
         VCChENDskWUt5mnuRbEwgS3D5gviLI9lphaBLUxj9cPXaixgB0ka8BtGsbqu4qxHM2JJ
         UlQ5sIGoLAn/NRBcv3w4/YjOSpEv9rcGyp7cft2pTApIznIvBtA7rV6/wZPNssiT95hi
         OZvB8pkqdPtlFNikXpFlovvPwdxV6/HypL0lJRvFTigbgSbwZmwEPvyl/6cAN47ozK4X
         RrTXs7GlvEd9oQucua46Kt1JkOkSYHmiKH00iBWrjSwDWsTH4EzeXMi8qY5KdclNQDjr
         WKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768973102; x=1769577902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YJHw0lGeqaxxhmKwhAVb/kT+sCLOXmrYZ/McZsFTgWQ=;
        b=YSO+yr6kPNyy1zRcCX8Bshcn/uuiuSHYPoTAHrLscCOazhlazxG3HkQVezqVZY9Y0v
         UiEF+SXcjgLxgn9pe/siun+24sbjmYEy8b+UBivMa2QcNiy6Gr/6sMQ9QkeyrwO9+DhE
         jBgrJAICPUcKeFPNvopvOle2TAElD9nGB7watcg/5CKVxal9XdV/6rebqRK2GAq4FoOT
         4w6mQWAmlDijyH3zDy7zh0JF9mFSptjGPAK/TO5V3K2PvReH0V74DURHQVproCL5JxPK
         M/RVfv1lKynsNAtdHBcPbewkN+yXTocwmlovtsJ7L0fRwqbWix6hvLdsqwBxV1hMJ/fY
         mR+A==
X-Forwarded-Encrypted: i=1; AJvYcCV3XKpTqNrtdLnojob3DMhwdjWE8Y4BTiBMf7CE1oBeC+dLSi+WtQ0522gDZS7yvbRXBxZYMBalQQ==@kvack.org
X-Gm-Message-State: AOJu0YzktxZfzqmlsZjTkRxo587PvvBCEyHaybkRSgCYb3fLjQq3UtEE
	1DaywGwySeFBj664pOjSvuWhK7N5iwEUuGMPhEL13WSrdbSZx0WW17ItUEBaAjKQJAy9iTCv1sa
	j2zd9fy3H3DDw4GUYhBKKZTIg2VsJnVLRtdHuVJfK0UlqEHcEsgtjQoLBHVA=
X-Gm-Gg: AZuq6aKGWAz/mLS7uBi4dqsyefF8b3IrwRZfl6qG5WTkSDh6EatIsSZsG8kD39V0HPd
	txMm11ehmw27zzR8xlZwHKuh+Diz6LYNYJJrbxpHWXDwLno7nOowWjkxbHmhWtphv6T0aq9TewM
	UkYD4w039+qUIfPhOc/QWVkO3OCI8Tjrk3XDPGltXdi7sO8ihd324Dq2rPS0A+MCRM/10/1aHyB
	QR9lduMsbJQ3/pWpmincNX4sRas0VMeAYHVfQQQaUHwLwuvWX/3nOzFyet+BkKlYZaTGXw=
X-Received: by 2002:a05:622a:1aa8:b0:4ed:70d6:6618 with SMTP id
 d75a77b69052e-502e0c6fcbdmr7688251cf.10.1768973102108; Tue, 20 Jan 2026
 21:25:02 -0800 (PST)
MIME-Version: 1.0
References: <20260108050748.520792-1-avagin@google.com> <20260108050748.520792-3-avagin@google.com>
 <wfl47fj3l4xhffrwuqfn5pgtrrn3s64lxxodnz5forx7d4x443@spsi3sx33lnf>
 <CAEWA0a4s+Uhm405CnvNsE61ed5_xJ8PUZqL74zfeZnivw1BChA@mail.gmail.com> <sp5yxpqi62ymfhjysggmuvxxcwsxtz5kthu64h6kr2poymesbd@3tjqlq7z372p>
In-Reply-To: <sp5yxpqi62ymfhjysggmuvxxcwsxtz5kthu64h6kr2poymesbd@3tjqlq7z372p>
From: Andrei Vagin <avagin@google.com>
Date: Tue, 20 Jan 2026 21:24:51 -0800
X-Gm-Features: AZwV_QikbJBczuSV0EDJopiu-yF-8IYj7bbdLuSPwFB_-oOLC1uGOeZinh1Bn0E
Message-ID: <CAEWA0a5yShzk-AHvHKCXb3RM_KEY0aKHkvuRcref-46_1pWoqA@mail.gmail.com>
Subject: Re: [PATCH 2/3] exec: inherit HWCAPs from the parent process
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Cyrill Gorcunov <gorcunov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DC8A40007
X-Stat-Signature: 46eg4yh3h65nypstue7ew9gtdjxgqqt3
X-Rspamd-Server: rspam02
X-HE-Tag: 1768973103-439878
X-HE-Meta: U2FsdGVkX1+X8kXNhYoFbTSpRRxUiYUezfNrHMTZOZhNrI8sxi0E5C85jX6XADVQAdLnhHVQdRQgUdHmHt5/2QQe6exSySpcpE5RomxPzqVCLbQF4BHJnUNYXCs+EjJKwyqAvNW5AaHR2AH+u4YTZ9Z0Bdg4mrgu/ndIWH3v5hEh+NipvrekhrcyoWSobvh0PtIZiFiXnGxfii2y/xz697XFTnhVjl5a2xRhz1aP4UXFJDIS1Z8ZIv5D1vfKOnyE1rAuH/a3qpctwTOxDM3KN1DKUP6JZ6upLsi2f9CHbkttpAQEL2YgX59ERPc7JIM0ottLfx+sb2y44MfmqrYoqtibko0bU50QqxINRi35GhrDtiflBUeIGgfLqR7NETsCQNRstR8JkPGRHpCB/bQcfrGvz0NCbIao2eL+pvpMKxVdEMkvHIsq8t34bWlmclIxBcJs5WrmHSuwSdMx8PF9f2o2XuMpmUotDK75GBruU+wZURJ8SYb8gRiKPLCTvaX8q/lcpOZGGlmBjfSRaB0MhKI4Kq1jg7gQe8WoqKjt0uGC+xPYwrfxS2u0ak3DVVaYzzkCns4Uca/mPvaMdjqQFct2eFmh6kgM57/4GK0hRvnmt/k4OexY6oU7AGkVygljiU77Ad9DkwMMVn9TpN3D90S/9FUZfgDEMCYNeFM/A++YzCc0iZNcTJzw2MHbI81Sz1yWMweLEYnmpic0RV6mhKlc9ArmH1YMTOMWd4PwuNah8pEK7RRGcNOjHmtrC9WjTJck9QSIMy0b/qiwQsMMT3CkDzqO7g92vPpE7Qxp9ay7J/gyeQkDnhAMIhP7fJVSgs9vPC9Dt3rYZD0SDKFpi01u9lxXJIhfD83cYHdX3qMonyNYQflt45vwODalNXGPlkBr1sRRC7JOSu7DT4wVLDxUgxADze/tpMI1WKBtr4az8DDYKX9r/co0VeSA4hdeZQdODvXfR0thrUNgtR5
 LBjgykg3
 dTWNT287p7IXZWscaXeI5LPDT2OvKkbehXw6xs+pehviRyNiB135mBSv0UMwJcUIIhGzINIjl20NFUn1dvJzYgjxyT+t7lBXE8or/3ox/XtMZA9bqLPa3QLwXL+cWbpv2qkr2wzSrqTvLz9S4vqPBD3mnlCyQ1N39xA3SO8uWLO2b5MHxHnLqkpGc4xi0uNq+Q+tKLQkYR7RbClhLnPi/YR/4gLLlT0W7u6v3KiMfw9++3qSjl1vgfJlJxxaUtSu4JJyoZfb91GEpKAJef3FodZTq2/j6xlMNPbXLPNuKpmvi0uMnf+mZ/BYOGJpIIHpO4VGO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 1:25=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Mon, Jan 12, 2026 at 02:18:18PM -0800, Andrei Vagin <avagin@google.com=
> wrote:
> > It is true for all existing arch-es. I can't imagine why we would want =
to
> > define ELF_HWCAP{n+1} without having ELF_HWCAP{n}. If you think we need
> > to handle this case, I can address it in the next version.
> >
> > It is just a small optimization to stop iterating after handling all
> > entries. The code will work correctly even when HWCAP n+1 exists but n
> > doesn't.
>
> Indeed (I accidentally ignored the AT_VECTOR_SIZE condition), it turns
> out no big deal then.
> I like that it's not needlessly searched (and copied altogether).
>
> > The inherit_hwcap function is only called if MMF_USER_HWCAP is set (aux=
v was
> > modified via prctl). However, even if mm->saved_auxv hasn't been
> > modified, it still contains valid values.
>
> Hm, bprm_mm_init/mm_alloc/mm_init would tranfser the flag from
> current, I'm still unclear whether it is necessary here. (It should make
> no harm though.)

It is just another optimization. Without this flag, we would need to
parse mm->saved_auxv even when it hasn't been changed.

>
> saved_auxv validity seems OK then.
>
> One more thing came up to my mind -- synchronization between prctl'ing
> and exec'ing threads (I see de_thread() is relatively late after
> bprm__mm_init()).


Currently, it is a user responsibility to synchronize these calls.
The comment in prctl_set_mm_map states:
  Note this update of @saved_auxv is lockless thus
  if someone reads this member in procfs while we're
  updating -- it may get partly updated results. It's
  known and acceptable trade off: we leave it as is to
  not introduce additional locks here making the kernel
  more complex.

Without synchronization between threads calling prctl() and execve(), a
new process could be executed with inconsistent HWCAPs. However, this
would not trigger any issues within the kernel. If we decide to
synchronize access to saved_auxv, we can use mm->arg_lock for that
purpose.

Thanks,
Andrei

