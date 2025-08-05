Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D670C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 307C98E0003; Tue,  5 Aug 2025 06:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DF0A8E0001; Tue,  5 Aug 2025 06:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4D08E0003; Tue,  5 Aug 2025 06:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0338E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:07:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B11AC16025D
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:07:54 +0000 (UTC)
X-FDA: 83742277668.11.514B609
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id A723A40008
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:07:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=i2DhVf7q;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf04.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754388472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzkpoNOzt+u5kQVM9zOFVT8IwZAEKFaikGotzp0duDA=;
	b=SaAORLTOjic5W01xdGZhTyY60WH29rYrjvq/eNWn0PyxknInnKTwZDvTe2PMzNRhThku1O
	yvbZnIQpnPZrEAy37XKe07jYsnDGz4DdPKqSPM0S7CB2Li7sHDslq/RC5HxvG9PUTWO+tr
	o7pvUfCNBGWFWU3mkAWyx0/dN/Lku7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754388472; a=rsa-sha256;
	cv=none;
	b=yHyzK0YHgNJljxcLv4HF+5rQlth4IzIWOOtD1mwQVESI5+5Q3pKORDl3oGzjcudIJY2Gzp
	ejNQub9iWsgphersTdtP7/CFhDViEAP0DlVpp53Zmv+Q+itNx1TaT5J1CZQ6IcBrcEO3mZ
	j7Qy5+5tdqDq6BIMzo8/3JCdWP78ns8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=i2DhVf7q;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf04.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-236377f00a1so47212375ad.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 03:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754388471; x=1754993271; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzkpoNOzt+u5kQVM9zOFVT8IwZAEKFaikGotzp0duDA=;
        b=i2DhVf7q1a0STFYY40wttiqOA8nCabN6JG6cKPLJF3gwp654viT8oOGHzub2MitkmF
         fU1oeVATPcyrn4kul1U30Oj6Qt9aaYx6oCgtgIqot71CTsDgbWObZndul6vbTGcxfHcz
         jiZFAraf+XTzXawA4DgbGFOgK0m0HEG0gAFRWntGL71CTOm+veZpWJyQ+APHv0LLLkf4
         vZrCbxZEMQl42XVVb9fKPaRh67vT0Ho4QgcyOm07z7ZT+f7ZNX1Pl/Bz0MRyTbNfhzOw
         lBjb9v4kuOB6TYuoA6jpLKgTX5YNsIkK8Zt09ywhFXeZLEqSTc1nef+ov0xGol4AwV+4
         jXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754388471; x=1754993271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qzkpoNOzt+u5kQVM9zOFVT8IwZAEKFaikGotzp0duDA=;
        b=Y9sDdToUHzgEWg4uh6QfPprjDcHfWbbe20nbZniTKWjov4lRARxy30AjVB6TK4pCDR
         ANJCDj2h/RdiWWPTxaLoCoEVwotMU5M9N1sXqVlWoQYDNUM6QBCC9q3nm6sscoOSS2LJ
         232tsN3QgewHAMqN9YNxLmlUO69d2H60po0YZcCgZIqSI27I/s4rnNYMrrlnRozSJ8Wm
         0C/foWBuCB6Sx8bl2Fuvw3yo3+FEqQzUrqE6AkkyPfwlqSMEShynqx5daeR7+A00izci
         ovJFI0MJ3aFbQhxCxFrpRwrAFNAnn0eBoABacuYqMCw7Es9uj9owqVI6zUf2PEhE7jsU
         f+DA==
X-Forwarded-Encrypted: i=1; AJvYcCVHYy2PKN2cLQEfnZTEtbOyWJ2PwttBGwMqya2sN23vLZKvv5HDVyaeMNi/gsxlyJ+C7C9T4o6daw==@kvack.org
X-Gm-Message-State: AOJu0YwojFcj3Ft+is8fkehQK/Jb5Np5WWSB9lO6htacspxfZCidnll2
	FNUkRITtBzsAqZj9YGy8hvk8vdSnfUYGAh/P1+ysaBqylYIUOwogWUNoJ8geDYV9hH7a2yd7dBe
	uzsflZCXih7um8mBTgEQ8nFQdMl5kMlT6cO7tl1jZ5Q==
X-Gm-Gg: ASbGncvMnVRVy5p7k6zC/T6aY3GtMwwlLIUCm0qnfdUmMfL6veQnrgWhquJWneScb/e
	46y/UIsuJc8tOr/LZfGe9JrEDnXSO3xo+0me8RE81wbqkhJu1loiA3xNUv5ir9oz2DxJLnkfHrj
	kKEngLMc0QlXJmc4xh/sbQMIoVtJk2oDfvA30aG+VHAc91EYsg2ms+Ok+iXKRNqy5Sj7psJEaCx
	bKUBdgy4mz9X7BOgA==
X-Google-Smtp-Source: AGHT+IFo7sBZG2nQNR4Qqn6h/BtEmQynqi/mmlaAe9drDkdKdA3SIWXqTNpWmyTn89LxOTt4eVUUkuShAQqGavwA65U=
X-Received: by 2002:a17:902:cec7:b0:23f:ecc1:ed75 with SMTP id
 d9443c01a7336-24246f2cc0cmr205040945ad.2.1754388471169; Tue, 05 Aug 2025
 03:07:51 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYumD2MGjECCv0wx2V_96_FKNtFQpT63qVNrrCmomoPYVQ@mail.gmail.com>
 <aJBnf738fPEmVqGo@hyeyoo>
In-Reply-To: <aJBnf738fPEmVqGo@hyeyoo>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 5 Aug 2025 15:37:38 +0530
X-Gm-Features: Ac12FXyw6TOMwASC6ZB_2ZN4s6VBBX9UgGTdGDvuZ-v7QPLadff-9vMSE0UqNXY
Message-ID: <CA+G9fYtJENPx+vxd+J3Zw5LwXceTS-dEsp74ZrH9cDe4DKfvsA@mail.gmail.com>
Subject: Re: next-20250729: PREEMPT_RT: rock Pi 4b Internal error Oops
 kmem_cache_alloc_bulk_noprof - kernel locking rtmutex.c at __rt_mutex_slowlock_locked
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-mm <linux-mm@kvack.org>, 
	open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>, Thomas Gleixner <tglx@linutronix.de>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Vlastimil Babka <vbabka@suse.cz>, "Paul E. McKenney" <paulmck@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ben Copeland <benjamin.copeland@linaro.org>, 
	kunit-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A723A40008
X-Stat-Signature: ysoq1hssm3rqijuuneckkrfwzs8rqica
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754388472-898567
X-HE-Meta: U2FsdGVkX19RVD1YRPS56Y18nxiCvCmzyglpbs34qMSH330fky/wsRA3cCkOhyolxUsVYPdvuUJF9pOKiKuc0f+nAty/bstahjvbu2LN2eGMHdw2QpxyZrvfEAlipyGZRdGzMLFZksAt7vy0UWD9CcFZLJS1ZnrcHlly//1r8k9cnrQJA1Hco2Rq581HZFnM12QZ9LD1E30s5YaGqsVcoIHRXbnqCtPuWLAQkuuGBcgL8rjfOPjcdK2lLOv7OPhL1YrFKSc377lTK5LWyGoWIgXPjpbCgIf9tlUOif7ak0b2/TezDoNWoIqIZgWPTbCwnyl8yB2pe0pdseiedsnstSCkE4yGezmBnQYiU9fvwa00u65qLSsFwhcC2SltNZ9cWWuSF2UzPn8Q6aHzBXeYbuhpaHjdOsgK7xL6aEjliVzvkiTiC2QadPXCwB1rcn8feXjxVAemPlNGQLweyOPNmxQ06OQCZ8olJdIB2yLpq9sIfQclM80JHY12td4qasCSP7aPwf2ZYpCgTZIrh7cFxsQAvheruSwOl0L608p+lJnD7f5abZ6PTQhjOmihAJu8WeVbfi4rWEpX/s2if55FLcK66tL35OoWrlAK4pKqYMf7y2BHcyZEfPrXKDItZgiGRvPH00AmgcwJUYhdEScQsEGv6BTmMrzanNhyXmQYaTQQzid0uA+YlIVfx8iX3rFYoZrcf0IBzmsBB+beTmZzduVqCCyGcxPFADUvDT8aLyfgSjnvh8tkFfnxebl3Y9ZHjzuJfYwJb9m9SpLzB+4WTh1ipBLF+93+1mQkqyBAHE9PS6gVBuc9jOmxDW8smh8m5QHq4n1bM/aW1HO3ppYxyIh74m78ITvE8ODSL9GGqw/Qe9Gjl052ynD+8TDOcBsSlQ99SiHTuIwDNoU0dPbGmz/IwZAObPJY17RGxrAJ6j7U8+dUD24Gdl6YZGruLhB10TyBJiOwsbeK1zg0KX7
 5Yw4okGM
 OBjUG+vW9cjRpyqNCTsFM2QnrGhckYXVsgFqE9dNcHUeafnqWDKeeJ0kkYr4T+C8qmd64N8D46xG6Fla+w8Ty2JupaMjwgOzzTWEJPq64LgKuqz4KQDeFF7Yt7HHbcwfz/g3Y+T+AcCfgfnWDTH9IPR7UQKCQOqS/e4Vsa/yGZGSPuY+73M+HM3LmKkFR0FBgBjen+OmPeRWEl/mMM9RQahSq0GR7ACPiNyAy2Kl1Kg2qBS2eUTNK2sTtxW/DxFxhMpLxOvs7c8Fi3njvYcd0+m+Csjuz1MtZJYnFCDes4lkzWHOGPG60ZqziJPIsbFfbKtILE5rxfzJNU1JZBLtEKEMjXuRniMM68q2uyLzbYHX+T87p54btpJ0TY/Ojxt48msKPXUxW0RsTcwJ12FkMuZymc3y+3fMvEvSxfZEUbb8fQOIQgqRHcrmUkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 4 Aug 2025 at 13:26, Harry Yoo <harry.yoo@oracle.com> wrote:
>
> On Sat, Aug 02, 2025 at 03:45:51PM +0530, Naresh Kamboju wrote:
> > Regressions found while validating Linux next on the Radxa Rock Pi 4B
> > platform, we observed kernel crashes and deadlock warnings when running=
 LTP
> > syscall and controller tests under specific PREEMPT_RT configurations.
> > These issues appear to be regressions introduced in next-20250729.
> >
> > * CONFIG_EXPERT=3Dy
> > * CONFIG_PREEMPT_RT=3Dy
> > * CONFIG_LAZY_PREEMPT=3Dy
> >
> > Regression Analysis:
> > - New regression? Yes
> > - Reproducibility? Intermittent
> >
> > First seen on the next-20250729
> > Good: next-20250728
> > Bad: next-20250729 and next-20250801
> >
> > Test regression: next-20250729 rock Pi 4b Internal error Oops
> > kmem_cache_alloc_bulk_noprof
> > Test regression: next-20250729 rock Pi 4b WARNING kernel locking
> > rtmutex.c at __rt_mutex_slowlock_locked
> > Test regression: next-20250729 rock Pi 4b WARNING kernel rcu
> > tree_plugin.h at rcu_note_context_switch
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Thanks for the report, Naresh!
>
> based on the stack trace, I think there might be a use-after-free or
> buffer overflow bug that could trigger this.
>
> Could you please try to reproduce it with KASAN enabled to confirm that
> it is the case?


I have recompiled the kernel with KASAN enabled and rerun the KUNIT tests,
along with the LTP syscall tests, in an effort to reproduce the previously
reported issue.

While the LTP syscall tests did not reproduce the problem, I consistently
observed a null pointer dereference during KUNIT testing, specifically in
the kunit_fault test, as shown in the log below.

I=E2=80=99ve seen this same crash across several kernel versions, and it is=
 always
reproducible when running KUNIT tests.

Could you please confirm if this behavior is expected from the
kunit_fault test, or if it indicates an issue that requires further
investigation?

## Boot log
[   69.507629]     KTAP version 1
[   69.507638]     # Subtest: kunit_fault
[   69.507651]     # module: kunit_test
[   69.507677]     1..1
[   69.508631] Unable to handle kernel paging request at virtual
address dfff800000000000
[   69.508661] KASAN: null-ptr-deref in range
[0x0000000000000000-0x0000000000000007]
[   69.508676] Mem abort info:
[   69.508684]   ESR =3D 0x0000000096000005
[   69.508695]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[   69.508709]   SET =3D 0, FnV =3D 0
[   69.508719]   EA =3D 0, S1PTW =3D 0
[   69.508730]   FSC =3D 0x05: level 1 translation fault
[   69.508742] Data abort info:
[   69.508750]   ISV =3D 0, ISS =3D 0x00000005, ISS2 =3D 0x00000000
[   69.508761]   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
[   69.508774]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
[   69.508787] [dfff800000000000] address between user and kernel address r=
anges
[   69.508804] Internal error: Oops: 0000000096000005 [#1]  SMP
[   69.508819] Modules linked in:
[   69.508846] CPU: 3 UID: 0 PID: 683 Comm: kunit_try_catch Tainted: G
   B            N  6.16.0-next-20250801 #1 PREEMPT_RT
[   69.508873] Tainted: [B]=3DBAD_PAGE, [N]=3DTEST
[   69.508881] Hardware name: Radxa ROCK Pi 4B (DT)
[   69.508891] pstate: 10000005 (nzcV daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   69.508907] pc : kunit_test_null_dereference+0x70/0x170
[   69.508940] lr : kunit_generic_run_threadfn_adapter+0x88/0x100
[   69.508959] sp : ffff80008a867d30
[   69.508967] x29: ffff80008a867d90 x28: 0000000000000000 x27: 00000000000=
00000
[   69.508992] x26: 0000000000000000 x25: 1fffe00001777601 x24: 00000000000=
00004
[   69.509017] x23: ffff00000bbbb00c x22: ffff800081203028 x21: ffff0000020=
1aa08
[   69.509042] x20: 1ffff0001150cfa6 x19: ffff800088077970 x18: ffff8000893=
86ed0
[   69.509067] x17: 0000000000000001 x16: ffff0000d1660de8 x15: 00000000000=
00000
[   69.509091] x14: 1fffe0001a2cc0c0 x13: 0002000000000000 x12: ffff6000022=
f7620
[   69.509116] x11: 1fffe000022f761f x10: ffff6000022f761f x9 : ffff8000811=
fa7b8
[   69.509141] x8 : ffff80008a867c18 x7 : 0000000000000000 x6 : 0000000041b=
58ab3
[   69.509165] x5 : ffff70001150cfa6 x4 : 00000000f1f1f1f1 x3 : 00000000000=
00003
[   69.509189] x2 : dfff800000000000 x1 : ffff0000117ba800 x0 : ffff8000880=
77970
[   69.509214] Call trace:
[   69.509223]  kunit_test_null_dereference+0x70/0x170 (P)
[   69.509246]  kunit_generic_run_threadfn_adapter+0x88/0x100
[   69.509267]  kthread+0x328/0x648
[   69.509286]  ret_from_fork+0x10/0x20
[   69.509316] Code: b90004a3 d5384101 52800063 aa0003f3 (39c00042)
[   69.509330] ---[ end trace 0000000000000000 ]---

Links:
 * https://lkft.validation.linaro.org/scheduler/job/8383286#L7826
 * https://lkft.validation.linaro.org/scheduler/job/8383276#L7984
 * https://lkft.validation.linaro.org/scheduler/job/8383282#L8011
 * https://lkft.validation.linaro.org/scheduler/job/8383281#L7992
 * https://storage.tuxsuite.com/public/linaro/lkft/builds/30ptGIUaeIy9JtIhx=
9OmKXrzop5/

> > ## Test log
> > [  527.570253] Unable to handle kernel paging request at virtual
> > address 003f0020f94020a1
> > [  527.570274] Mem abort info:
> > [  527.570277]   ESR =3D 0x0000000096000004
> > [  527.570282]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> > [  527.570288]   SET =3D 0, FnV =3D 0
> > [  527.570292]   EA =3D 0, S1PTW =3D 0
> > [  527.570297]   FSC =3D 0x04: level 0 translation fault
> > [  527.570302] Data abort info:
> > [  527.570305]   ISV =3D 0, ISS =3D 0x00000004, ISS2 =3D 0x00000000
> > [  527.570310]   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
> > [  527.570316]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
> > [  527.570322] [003f0020f94020a1] address between user and kernel addre=
ss ranges
> > [  527.570330] Internal error: Oops: 0000000096000004 [#1]  SMP
> > [  527.570336] Modules linked in: brcmfmac rockchip_dfi brcmutil
> > cfg80211 snd_soc_hdmi_codec dw_hdmi_i2s_audio dw_hdmi_cec
> > snd_soc_simple_card snd_soc_audio_graph_card hci_uart
> > snd_soc_rockchip_i2s snd_soc_es8316 snd_soc_spdif_tx
> > snd_soc_simple_card_utils btqca rtc_rk808 rockchipdrm btbcm
> > snd_soc_core dw_hdmi_qp bluetooth snd_compress reset_gpio analogix_dp
> > snd_pcm_dmaengine panfrost hantro_vpu dw_mipi_dsi rfkill rockchip_rga
> > drm_shmem_helper drm_dp_aux_bus snd_pcm gpu_sched dw_hdmi pwrseq_core
> > videobuf2_dma_sg v4l2_vp9 snd_timer drm_display_helper v4l2_h264
> > v4l2_jpeg phy_rockchip_pcie snd v4l2_mem2mem cec videobuf2_dma_contig
> > soundcore videobuf2_memops drm_client_lib videobuf2_v4l2
> > drm_dma_helper videobuf2_common rockchip_saradc drm_kms_helper
> > industrialio_triggered_buffer kfifo_buf rockchip_thermal
> > pcie_rockchip_host coresight_cpu_debug fuse drm backlight
> > [  527.570493] CPU: 3 UID: 0 PID: 34254 Comm: mkdir Not tainted
> > 6.16.0-next-20250801 #1 PREEMPT_RT
> > [  527.570502] Hardware name: Radxa ROCK Pi 4B (DT)
> > [  527.570506] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
> > [  527.570512] pc : kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
> > (discriminator 1) mm/slub.c:5403 (discriminator 1))
> > [  527.570527] lr : kmem_cache_alloc_bulk_noprof
> > (include/linux/atomic/atomic-arch-fallback.h:457
> > include/linux/atomic/atomic-instrumented.h:33
> > include/linux/kfence.h:127 mm/slub.c:5307 mm/slub.c:5403)
> > [  527.570533] sp : ffff80008e24b8f0
> > [  527.570536] x29: ffff80008e24b930 x28: 00ff000000584610 x27: ffff800=
082b30538
> > [  527.570545] x26: ffff8000816b64dc x25: 0000000000000cc0 x24: 0000000=
000000000
> > [  527.570554] x23: 0000000000000004 x22: ffff0000f7579d20 x21: 0000000=
000000001
> > [  527.570563] x20: 0000000000000001 x19: ffff000000405b00 x18: ffff800=
08e24bcd0
> > [  527.570572] x17: 0000000000000000 x16: ffff800081e18420 x15: 0000fff=
fa2670fff
> > [  527.570582] x14: 0000000000000000 x13: 1fffe000017942e1 x12: 0000fff=
fa2470fff
> > [  527.570591] x11: ffff00000bca1708 x10: 0000000000000001 x9 : ffff800=
0816e41a4
> > [  527.570600] x8 : ffff80008e24b850 x7 : fefefefefefefefe x6 : ffff800=
082b30000
> > [  527.570608] x5 : d63f0020f9402021 x4 : ffff0000f7579d58 x3 : 0000000=
000000000
> > [  527.570617] x2 : 0000000000000000 x1 : 0000000000000100 x0 : 0000000=
000000080
> > [  527.570627] Call trace:
> > [  527.570631] kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
>
> It crashes in get_freepointer() because a bad pointer is passed to it.
>
> I think it is reasonable to suspect that the freelist chain is corrupt
> due to a use-after-free or buffer overflow (either in maple tree code,
> or something else that shares the cache with maple tree nodes).
>
> > (discriminator 1) mm/slub.c:5403 (discriminator 1)) (P)
> > [  527.570639] mas_alloc_nodes (lib/maple_tree.c:1278)
> > [  527.570651] mas_node_count_gfp (lib/maple_tree.c:1339)
> > [  527.570661] mas_preallocate (lib/maple_tree.c:5538 (discriminator 1)=
)
> > [  527.570667] __split_vma (mm/vma.c:528 (discriminator 1))
> > [  527.570677] vma_modify (mm/vma.c:1633)
> > [  527.570685] vma_modify_flags (mm/vma.c:1650)
> > [  527.570694] mprotect_fixup (mm/mprotect.c:819)
> > [  527.570704] do_mprotect_pkey (mm/mprotect.c:993)
> > [  527.570713] __arm64_sys_mprotect (mm/mprotect.c:1011)
> > [  527.570722] invoke_syscall (arch/arm64/include/asm/current.h:19
> > arch/arm64/kernel/syscall.c:54)
> > [  527.570731] el0_svc_common.constprop.0
> > (include/linux/thread_info.h:135 (discriminator 2)
> > arch/arm64/kernel/syscall.c:140 (discriminator 2))
> > [  527.570737] do_el0_svc (arch/arm64/kernel/syscall.c:152)
> > [  527.570744] el0_svc (arch/arm64/include/asm/irqflags.h:82
> > (discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
> > 1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:169 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:182 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:880 (discriminator 1))
> > [  527.570752] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:8=
99)
> > [  527.570760] el0t_64_sync (arch/arm64/kernel/entry.S:596)
> > [ 527.570772] Code: 1400000c f94002c5 b4000aa5 b9402a60 (f86068a0)
> > All code
> > =3D=3D=3D=3D=3D=3D=3D=3D
> >    0: 1400000c b 0x30
> >    4: f94002c5 ldr x5, [x22]
> >    8: b4000aa5 cbz x5, 0x15c
> >    c: b9402a60 ldr w0, [x19, #40]
> >   10:* f86068a0 ldr x0, [x5, x0] <-- trapping instruction
> >
> > Code starting with the faulting instruction
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >    0: f86068a0 ldr x0, [x5, x0]
> > [  527.570778] ---[ end trace 0000000000000000 ]---
> > [  527.570800] ------------[ cut here ]------------
> > [  527.570803] rtmutex deadlock detected
> > [  527.570827] WARNING: kernel/locking/rtmutex.c:1674 at
> > __rt_mutex_slowlock_locked.constprop.0+0x800/0x8e0, CPU#3: mkdir/34254
> > [  527.570841] Modules linked in: brcmfmac rockchip_dfi brcmutil
> > cfg80211 snd_soc_hdmi_codec dw_hdmi_i2s_audio dw_hdmi_cec
> > snd_soc_simple_card snd_soc_audio_graph_card hci_uart
> > snd_soc_rockchip_i2s snd_soc_es8316 snd_soc_spdif_tx
> > snd_soc_simple_card_utils btqca rtc_rk808 rockchipdrm btbcm
> > snd_soc_core dw_hdmi_qp bluetooth snd_compress reset_gpio analogix_dp
> > snd_pcm_dmaengine panfrost hantro_vpu dw_mipi_dsi rfkill rockchip_rga
> > drm_shmem_helper drm_dp_aux_bus snd_pcm gpu_sched dw_hdmi pwrseq_core
> > videobuf2_dma_sg v4l2_vp9 snd_timer drm_display_helper v4l2_h264
> > v4l2_jpeg phy_rockchip_pcie snd v4l2_mem2mem cec videobuf2_dma_contig
> > soundcore videobuf2_memops drm_client_lib videobuf2_v4l2
> > drm_dma_helper videobuf2_common rockchip_saradc drm_kms_helper
> > industrialio_triggered_buffer kfifo_buf rockchip_thermal
> > pcie_rockchip_host coresight_cpu_debug fuse drm backlight
> > [  527.570965] CPU: 3 UID: 0 PID: 34254 Comm: mkdir Tainted: G      D
> >            6.16.0-next-20250801 #1 PREEMPT_RT
> > [  527.570973] Tainted: [D]=3DDIE
> > [  527.570976] Hardware name: Radxa ROCK Pi 4B (DT)
> > [  527.570979] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
> > [  527.570985] pc : __rt_mutex_slowlock_locked.constprop.0
> > (kernel/locking/rtmutex.c:1674 (discriminator 1)
> > kernel/locking/rtmutex.c:1734 (discriminator 1)
> > kernel/locking/rtmutex.c:1760 (discriminator 1))
> > [  527.570993] lr : __rt_mutex_slowlock_locked.constprop.0
> > (kernel/locking/rtmutex.c:1674 (discriminator 1)
> > kernel/locking/rtmutex.c:1734 (discriminator 1)
> > kernel/locking/rtmutex.c:1760 (discriminator 1))
> > [  527.571001] sp : ffff80008e24b2e0
> > [  527.571004] x29: ffff80008e24b370 x28: ffff000007c1a600 x27: ffff000=
007c1a601
> > [  527.571013] x26: ffff80008e24b318 x25: ffff000007c1a600 x24: 0000000=
0ffffffdd
> > [  527.571023] x23: 00000000ffffffdd x22: 0000000000000001 x21: ffff000=
007c1a601
> > [  527.571032] x20: ffff80008e24b2f0 x19: ffff00001d756e30 x18: 0000000=
000000000
> > [  527.571041] x17: 65676e6172207373 x16: 6572646461206c65 x15: 0000000=
000000000
> > [  527.571050] x14: 0000000000000020 x13: 0a64657463657465 x12: 64206b6=
36f6c6461
> > [  527.571059] x11: 656820747563205b x10: ffff800082adac08 x9 : ffff800=
08015020c
> > [  527.571068] x8 : ffff80008e24af08 x7 : 0000000000000001 x6 : ffff800=
082a5e000
> > [  527.571077] x5 : ffff000007c1a600 x4 : 0000000000000000 x3 : 0000000=
000000027
> > [  527.571086] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000=
007c1a600
> > [  527.571094] Call trace:
> > [  527.571097] __rt_mutex_slowlock_locked.constprop.0
> > (kernel/locking/rtmutex.c:1674 (discriminator 1)
> > kernel/locking/rtmutex.c:1734 (discriminator 1)
> > kernel/locking/rtmutex.c:1760 (discriminator 1)) (P)
> > [  527.571107] __rwbase_read_lock (kernel/locking/rwbase_rt.c:114)
> > [  527.571117] down_read (kernel/locking/rwsem.c:1540)
> > [  527.571126] acct_collect (arch/arm64/include/asm/jump_label.h:36
> > include/linux/mmap_lock.h:41 include/linux/mmap_lock.h:454
> > kernel/acct.c:597)
> > [  527.571135] do_exit (kernel/exit.c:932)
> > [  527.571143] make_task_dead
> > (arch/arm64/include/asm/atomic_ll_sc.h:95 (discriminator 2)
> > arch/arm64/include/asm/atomic.h:52 (discriminator 2)
> > include/linux/atomic/atomic-arch-fallback.h:564 (discriminator 2)
> > include/linux/atomic/atomic-arch-fallback.h:1020 (discriminator 2)
> > include/linux/atomic/atomic-instrumented.h:454 (discriminator 2)
> > kernel/exit.c:1049 (discriminator 2))
> > [  527.571150] die (arch/arm64/kernel/traps.c:231)
> > [  527.571157] die_kernel_fault (arch/arm64/mm/fault.c:313)
> > [  527.571167] __do_kernel_fault (arch/arm64/mm/fault.c:375 (discrimina=
tor 5))
> > [  527.571177] do_bad_area (arch/arm64/mm/fault.c:482)
> > [  527.571186] do_translation_fault (arch/arm64/mm/fault.c:792)
> > [  527.571195] do_mem_abort (arch/arm64/mm/fault.c:929 (discriminator 1=
))
> > [  527.571204] el1_abort (arch/arm64/include/asm/daifflags.h:28
> > arch/arm64/kernel/entry-common.c:482)
> > [  527.571210] el1h_64_sync_handler (arch/arm64/kernel/entry-common.c:6=
37)
> > [  527.571218] el1h_64_sync (arch/arm64/kernel/entry.S:591)
>
> The deadlock wouldn't have been triggered if it didn't crash in SLUB, so
> this looks rather irrelevant.
>
> --
> Cheers,
> Harry / Hyeonggon
>
> > [  527.571225] kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
> > (discriminator 1) mm/slub.c:5403 (discriminator 1)) (P)
> > [  527.571232] mas_alloc_nodes (lib/maple_tree.c:1278)
> > [  527.571241] mas_node_count_gfp (lib/maple_tree.c:1339)
> > [  527.571251] mas_preallocate (lib/maple_tree.c:5538 (discriminator 1)=
)
> > [  527.571257] __split_vma (mm/vma.c:528 (discriminator 1))
> > [  527.571265] vma_modify (mm/vma.c:1633)
> > [  527.571273] vma_modify_flags (mm/vma.c:1650)
> > [  527.571282] mprotect_fixup (mm/mprotect.c:819)
> > [  527.571290] do_mprotect_pkey (mm/mprotect.c:993)
> > [  527.571299] __arm64_sys_mprotect (mm/mprotect.c:1011)
> > [  527.571308] invoke_syscall (arch/arm64/include/asm/current.h:19
> > arch/arm64/kernel/syscall.c:54)
> > [  527.571314] el0_svc_common.constprop.0
> > (include/linux/thread_info.h:135 (discriminator 2)
> > arch/arm64/kernel/syscall.c:140 (discriminator 2))
> > [  527.571321] do_el0_svc (arch/arm64/kernel/syscall.c:152)
> > [  527.571327] el0_svc (arch/arm64/include/asm/irqflags.h:82
> > (discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
> > 1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:169 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:182 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:880 (discriminator 1))
> > [  527.571334] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:8=
99)
> > [  527.571341] el0t_64_sync (arch/arm64/kernel/entry.S:596)
> > [  527.571349] ---[ end trace 0000000000000000 ]---
> > [  527.571354] ------------[ cut here ]------------
> > [  527.571356] Voluntary context switch within RCU read-side critical s=
ection!
> > [  527.571372] WARNING: kernel/rcu/tree_plugin.h:332 at
> > rcu_note_context_switch+0x4ec/0x538, CPU#3: mkdir/34254
> > [  527.571383] Modules linked in: brcmfmac rockchip_dfi brcmutil
> > cfg80211 snd_soc_hdmi_codec dw_hdmi_i2s_audio dw_hdmi_cec
> > snd_soc_simple_card snd_soc_audio_graph_card hci_uart
> > snd_soc_rockchip_i2s snd_soc_es8316 snd_soc_spdif_tx
> > snd_soc_simple_card_utils btqca rtc_rk808 rockchipdrm btbcm
> > snd_soc_core dw_hdmi_qp bluetooth snd_compress reset_gpio analogix_dp
> > snd_pcm_dmaengine panfrost hantro_vpu dw_mipi_dsi rfkill rockchip_rga
> > drm_shmem_helper drm_dp_aux_bus snd_pcm gpu_sched dw_hdmi pwrseq_core
> > videobuf2_dma_sg v4l2_vp9 snd_timer drm_display_helper v4l2_h264
> > v4l2_jpeg phy_rockchip_pcie snd v4l2_mem2mem cec videobuf2_dma_contig
> > soundcore videobuf2_memops drm_client_lib videobuf2_v4l2
> > drm_dma_helper videobuf2_common rockchip_saradc drm_kms_helper
> > industrialio_triggered_buffer kfifo_buf rockchip_thermal
> > pcie_rockchip_host coresight_cpu_debug fuse drm backlight
> > [  527.571503] CPU: 3 UID: 0 PID: 34254 Comm: mkdir Tainted: G      D
> > W           6.16.0-next-20250801 #1 PREEMPT_RT
> > [  527.571512] Tainted: [D]=3DDIE, [W]=3DWARN
> > [  527.571514] Hardware name: Radxa ROCK Pi 4B (DT)
> > [  527.571517] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
> > [  527.571523] pc : rcu_note_context_switch
> > (kernel/rcu/tree_plugin.h:332 (discriminator 1))
> > [  527.571529] lr : rcu_note_context_switch
> > (kernel/rcu/tree_plugin.h:332 (discriminator 1))
> > [  527.571535] sp : ffff80008e24b1e0
> > [  527.571538] x29: ffff80008e24b1e0 x28: ffff000007c1a600 x27: ffff000=
007c1a601
> > [  527.571548] x26: 0000000000000000 x25: ffff000007c1a600 x24: ffff800=
082a60368
> > [  527.571557] x23: 0000000000000000 x22: ffff000007c1a600 x21: ffff800=
083125260
> > [  527.571566] x20: 0000000000000000 x19: ffff0000f7576080 x18: 0000000=
000000000
> > [  527.571575] x17: 65676e6172207373 x16: 6572646461206c65 x15: 0000000=
000000000
> > [  527.571583] x14: 0000000000000020 x13: 216e6f6974636573 x12: 206c616=
369746972
> > [  527.571593] x11: 6320656469732d64 x10: 6165722055435220 x9 : ffff800=
08015020c
> > [  527.571602] x8 : 6863746977732074 x7 : 7865746e6f632079 x6 : 7261746=
e756c6f56
> > [  527.571611] x5 : ffff80008317146f x4 : 0000000000000000 x3 : 0000000=
000000027
> > [  527.571619] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000=
007c1a600
> > [  527.571628] Call trace:
> > [  527.571630] rcu_note_context_switch (kernel/rcu/tree_plugin.h:332
> > (discriminator 1)) (P)
> > [  527.571638] __schedule (kernel/sched/core.c:634
> > kernel/sched/sched.h:1519 kernel/sched/sched.h:1841
> > kernel/sched/core.c:6865)
> > [  527.571647] rt_mutex_schedule (kernel/sched/core.c:7044
> > kernel/sched/core.c:7339)
> > [  527.571655] __rt_mutex_slowlock_locked.constprop.0
> > (kernel/locking/rtmutex.c:1676 kernel/locking/rtmutex.c:1734
> > kernel/locking/rtmutex.c:1760)
> > [  527.571665] __rwbase_read_lock (kernel/locking/rwbase_rt.c:114)
> > [  527.571674] down_read (kernel/locking/rwsem.c:1540)
> > [  527.571683] acct_collect (arch/arm64/include/asm/jump_label.h:36
> > include/linux/mmap_lock.h:41 include/linux/mmap_lock.h:454
> > kernel/acct.c:597)
> > [  527.571690] do_exit (kernel/exit.c:932)
> > [  527.571696] make_task_dead
> > (arch/arm64/include/asm/atomic_ll_sc.h:95 (discriminator 2)
> > arch/arm64/include/asm/atomic.h:52 (discriminator 2)
> > include/linux/atomic/atomic-arch-fallback.h:564 (discriminator 2)
> > include/linux/atomic/atomic-arch-fallback.h:1020 (discriminator 2)
> > include/linux/atomic/atomic-instrumented.h:454 (discriminator 2)
> > kernel/exit.c:1049 (discriminator 2))
> > [  527.571703] die (arch/arm64/kernel/traps.c:231)
> > [  527.571710] die_kernel_fault (arch/arm64/mm/fault.c:313)
> > [  527.571719] __do_kernel_fault (arch/arm64/mm/fault.c:375 (discrimina=
tor 5))
> > [  527.571729] do_bad_area (arch/arm64/mm/fault.c:482)
> > [  527.571738] do_translation_fault (arch/arm64/mm/fault.c:792)
> > [  527.571746] do_mem_abort (arch/arm64/mm/fault.c:929 (discriminator 1=
))
> > [  527.571755] el1_abort (arch/arm64/include/asm/daifflags.h:28
> > arch/arm64/kernel/entry-common.c:482)
> > [  527.571761] el1h_64_sync_handler (arch/arm64/kernel/entry-common.c:6=
37)
> > [  527.571769] el1h_64_sync (arch/arm64/kernel/entry.S:591)
> > [  527.571775] kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
> > (discriminator 1) mm/slub.c:5403 (discriminator 1)) (P)
> > [  527.571782] mas_alloc_nodes (lib/maple_tree.c:1278)
> > [  527.571792] mas_node_count_gfp (lib/maple_tree.c:1339)
> > [  527.571802] mas_preallocate (lib/maple_tree.c:5538 (discriminator 1)=
)
> > [  527.571808] __split_vma (mm/vma.c:528 (discriminator 1))
> > [  527.571816] vma_modify (mm/vma.c:1633)
> > [  527.571824] vma_modify_flags (mm/vma.c:1650)
> > [  527.571833] mprotect_fixup (mm/mprotect.c:819)
> > [  527.571842] do_mprotect_pkey (mm/mprotect.c:993)
> > [  527.571850] __arm64_sys_mprotect (mm/mprotect.c:1011)
> > [  527.571859] invoke_syscall (arch/arm64/include/asm/current.h:19
> > arch/arm64/kernel/syscall.c:54)
> > [  527.571866] el0_svc_common.constprop.0
> > (include/linux/thread_info.h:135 (discriminator 2)
> > arch/arm64/kernel/syscall.c:140 (discriminator 2))
> > [  527.571872] do_el0_svc (arch/arm64/kernel/syscall.c:152)
> > [  527.571878] el0_svc (arch/arm64/include/asm/irqflags.h:82
> > (discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
> > 1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:169 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:182 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:880 (discriminator 1))
> > [  527.571885] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:8=
99)
> > [  527.571893] el0t_64_sync (arch/arm64/kernel/entry.S:596)
> > [  527.571900] ---[ end trace 0000000000000000 ]---
> > [  540.645451] sched: DL replenish lagged too much
> >
> > ## Source
> > * Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/ne=
xt/linux-next.git
> > * Git sha: 54efec8782214652b331c50646013f8526570e8d
> > * Git describe: next-20250729
> > * Project details:
> > https://qa-reports.linaro.org/lkft/linux-next-master/build/next-2025072=
9
> > * Architectures: arm64
> > * Toolchains: gcc-13
> > * Kconfigs: Preempt_rt
> >
> > ## Test
> > * Test log 1: https://qa-reports.linaro.org/api/testruns/29282584/log_f=
ile/
> > * Test log 2:https://qa-reports.linaro.org/api/testruns/29337984/log_fi=
le/
> > * Test lava log: https://lkft.validation.linaro.org/scheduler/job/83731=
14#L19186
> > * Test details:
> > https://regressions.linaro.org/lkft/linux-next-master/next-20250729/log=
-parser-test/exception-rtmutex-deadlock-detected/
> > * Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft=
/tests/30XMjtCEi0VzsU1gYZ0a7kcTkLJ
> > * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/30=
fq2ElntxgscJ13dnaD7iL5Z1G/
> > * Kernel config:
> > https://storage.tuxsuite.com/public/linaro/lkft/builds/30fq2ElntxgscJ13=
dnaD7iL5Z1G/config

- Naresh

