Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D391CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 20:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB87F8E0147; Tue, 14 Oct 2025 16:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68AE8E0090; Tue, 14 Oct 2025 16:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9316A8E0147; Tue, 14 Oct 2025 16:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5D48E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:53:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 363B61A0A7A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:53:21 +0000 (UTC)
X-FDA: 83997920202.20.4FD315E
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 47ECF180006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:53:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iW13CVhA;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760475199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4JFsuSiVOqgbcHX6dcWl4uWddnz/5FUG4MhwGgmr6aU=;
	b=b4eCRX3YacRnTPcGLoCRPMlC6g5379ydld//Zg/Hy4SYXPPydvGSSW9gBvsGyXXZNd8kuy
	7r7Wmp2XaBzCXsorjlLfgthJKQqLrHdeOO5xqJKMSRV0E5MZ74/9suQamfNpqlV/Y3P03Y
	M/hd43+Xi9UrarUH5VEyHbRVi0F0p7E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iW13CVhA;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760475199; a=rsa-sha256;
	cv=none;
	b=SMVcKWR/Fo9yHKLhIFUXmWo8Kqmm0O3LIdzKrx1gmZWAwYx/8Hw4p5fY4c7dwufHgLRhAf
	5+1m2A9+h1/uSv6CTSPHfKJlo7YNc+GiD5egbtuVspjoklS6Umt6gIH0Q1wJgmrT+z0mBK
	YttVFJA26Bw3S0MY3v1GYbgAcduWsAA=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-426edfffc66so188278f8f.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760475198; x=1761079998; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4JFsuSiVOqgbcHX6dcWl4uWddnz/5FUG4MhwGgmr6aU=;
        b=iW13CVhASwOD6b/wNmLUywrLGVlozhOqmNVixKQxeR7rLr+eNsL0kpaVbb8N5tOGDP
         ih7bfCSqrPPO+qIeqi8bPzVbjApv02FPCdFW5pLJYVjSzGX7tM+wrKw0WWrHwrsCizyO
         teOZV+nGz2K9SLXaWtYAXFw/FPq/xnhaAOpdV77FuSCMhxrCSypeLZARC+G13ZbGdPdR
         z0Q4S4bMAY8PAsTTfCq4LFIVf2a2vHEqRo8QJUjn6vGb1roTy8dDWT8Q2goyw52h59Oi
         dZT75uzz0cQgdZLpdvhH5mYSkjZojXDcNRZwS4vCPRROIgVGgtlwaCIloCrGrxOAc3+0
         WKmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760475198; x=1761079998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JFsuSiVOqgbcHX6dcWl4uWddnz/5FUG4MhwGgmr6aU=;
        b=k/MJzB6SRmDLs2l0YELJgXEov9BMtAWqI6QIy8NBH7p0accB95HurREFkIaNmHU04X
         XcfF4PTQTNvxlpahbKfFQF6AR4SFHP3yIlaFPbFt54fctcEXzHsJrfZJDZ5oWUV3tebw
         20KCHfKF1ILRVd+cpiQ3JixA5NS8X6xp2UHQjEvt2ru8f4+xyXtvYE+1EMtfGmsyCaJO
         aYm1U4+aQDX9N1BJ5yv0SN9UXcX+d9MeePvlmiH/BbPmrtqycv0LTC5OUo2UX79DqbtG
         t5yqDjEOiraX5YGYLUV0dGgrunzTwkYuBlSVGX9OyXAfQRu41T2GyQ5DLZQqp497SR95
         1axQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJ/VNSFN6Zev3DdfNO2xDh6fCQvggD7j9iuD0Ydhxo76s4EKQzb1bcNrveZmxwiKT7kuEFJ/J1Aw==@kvack.org
X-Gm-Message-State: AOJu0Yyl00dsLeNxqGtCcpKUD9sEVinzs0Uk2w2rAA2Sjh7GrPi4WPZA
	y9HrZWAr3FgTgssbIuHplyrtHIngmd6+9slQSbhL3b2m1xD0tbyIpTjBLtH7KUibqhBYsSaXtO2
	AYFBfe2ATOzzrkyVW/39R5MuE9/NQsPw=
X-Gm-Gg: ASbGncuCCQ/dgTjLaRDhbs266isq4KB7835sEjKW9tiMGHOVYBDuyqvm6zspDWhWp/O
	lMhVCZkWg/a5RW8Cfa1MxVx/UI04miiDcfXM5nJKRs7nMVF3A06/4yhAKIz85gdgWWOccYKP5nO
	g68L3nhw2xv8brICnp2l2Xqm59FW+ICICH3mcyCylZfjb2r8JsxSOxYuqTTJy9mPKdSfujtrHgn
	CSCXb08otdGOsnizHpPHRq7qh7/vFhgxoJei8A67w==
X-Google-Smtp-Source: AGHT+IGdKnsarC8XEuiLJTR0Z+LCHOtiSbPZRsxVDK/PIpmylC7qZ52/5RseqFkxsoYOBt1a0lL5ap49imUx4AxY4PU=
X-Received: by 2002:a05:6000:4301:b0:3e7:428f:d33 with SMTP id
 ffacd0b85a97d-4266e6ca4f2mr20054019f8f.16.1760475197482; Tue, 14 Oct 2025
 13:53:17 -0700 (PDT)
MIME-Version: 1.0
References: <202510101652.7921fdc6-lkp@intel.com> <aOzKEsav2RubINEO@hyeyoo>
In-Reply-To: <aOzKEsav2RubINEO@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 14 Oct 2025 13:53:04 -0700
X-Gm-Features: AS18NWAWcf_MT4SkGxMNw4WzewXOKnGlmlXtd7IoU2eahWJ0OnVXdm74h9uv2Ek
Message-ID: <CAADnVQLA=q573GEQukX63vfoqdAJK1CjoyD2=DZcQgeqAg-XMA@mail.gmail.com>
Subject: kmemleak and bpf_timer. Was: [linus:master] [slab] af92793e52: BUG_kmalloc-#(Not_tainted):Freepointer_corrupt
To: Harry Yoo <harry.yoo@oracle.com>, Peilin Ye <yepeilin@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>
Cc: kernel test robot <oliver.sang@intel.com>, kbuild test robot <lkp@intel.com>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p8zkcp3e4bgi5s7qqdoijzru1d6ez1fy
X-Rspamd-Queue-Id: 47ECF180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760475199-955102
X-HE-Meta: U2FsdGVkX19diGk6ajvdSg8FushE1h7/Z3VwsMNYVSe9ikA12bHGz3Wap+PGakRRwsaLur08r8KgPyn6T0MFsScpmq5IWu6F5ZWrKaM6KbJvaSfcMbfujJr2d2/vIf+LRuNhaLCjwsQBlmO4ESE1BEfzRZ0KCWO7DGZ7q+yq9+yiC9ZU/4wJSYcAVTz2RgXcysP/SejVhvnxgIFY4nAVxV/q3TfNCafYrtMZgwGtBFsHfGqcXp3CfB24NaByfDk0WI3T5jCTilDfgs9K/CANsQ2QlhdCwQ0UOY4rGUpCRe6b3nIaj8PcIicRDxGphn8s3CCx0Ur69p9eGmQVHxOEhNk9D1nPlEeGr4FIMwBlF5iSYr4PMvsvxNeZq1paiVkc7QO6x8yFlZLf1HMiO46P0O6RP5lSiSMja/sQtU3xp/XexAGOLuj2QRxS4dqOq92cH1cv07nP6aLW8YeIntyDWU+IERocRpt9mgcfD4h55mmXKxGHkK/VcerVNWT50iykFdpGQT2tDaq+TmDk8FDWQCwYSHWenAmNxX/wfHk5YzHAB8EjC+T71u8xPtU8xvs04KAkDWkXZPk68TrU2iKoumnDzTU4oUl+dCX7rp9+xp2jymvePuLmkodjmhzlm3LTND+JebZltZ5MnxSKd12aIKkNb27D1Eot1xk+V6+bhkupyk97AB8GOJekaIG6lfd0fR87/PbtCogJ9C8JejPxcO3Ege3BoDC4YQ1A7qEDhtxYokqIJszTCpLpYrkehAaOhPsmyfX8Pv/OXxjvPpWx54jnnF3RBi8gNb6nCZ9JqM4Cao4XV/ooUDjhXo22UIA2q79X2izHlNsHM+/ulwBjFYCyZF7K5z4Z/dGuhDCcQp1951Ko8W+D64twrJeQRwcWq2j1QPlNMYM0SQzqBI9nJR2/cQL5bRQEc0FT1Zz9UyDwAB3SklchckVdYxzMcL+XRkMD2jHs3rQw8Ohfa6r
 XStGyuo+
 su+S8GbdCowCqvbk6VrN7bhNdUdMbAYZfK87pM8QGmOkCkcA4HoZBtja1dyigKCPFhD1yXF/Z6QEBGP66h7z2HNkmpsJzKXh2ipucPVUZ0gx4zWRaKmLkBANzDM+F78C/YoReCkET4rEt6ftwhIBB6/J1a341QdqJ9uhlpA8hkMhq4Ot9vqdlIrcgxZhecfoU0BpPRRCFfgB0abumdsWkA/pXMUdV4ztot9MUjA/MG0qagNYGW4SqSidFWbHIBucJMH1faaXEa5S9HyY0iSbNHZcif3Z45M/f8oxIxn8sg3pYD4KoU8cA8CVeOWDQCsfHtBGon5STsgJt3aMschdQp4vKQjXw60quSUh/Lyh0biHQnRSB8zPkrNXgTQtRr4oONICiLUOSE2PCzbvOKP04begY+zMjnB3AIy1mQLBm6X4k7xLx6/5glMUp3Bi4L91K+GomdoP7tjbrPmo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 2:45=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> So here we are freeing an object that is allocated via kmalloc_nolock().
> (And before being allocated via kmalloc_nolock(), it was freed via
> kfree_rcu()).

There is another problem here, but the root cause is the same.

I see this kmemleak splat:
[    8.105530] kmemleak: Trying to color unknown object at
0xff11000100e918c0 as Black
[    8.106521] Call Trace:
[    8.106521]  <TASK>
[    8.106521]  dump_stack_lvl+0x4b/0x70
[    8.106521]  kvfree_call_rcu+0xcb/0x3b0
[    8.106521]  ? hrtimer_cancel+0x21/0x40
[    8.106521]  bpf_obj_free_fields+0x193/0x200
[    8.106521]  htab_map_update_elem+0x29c/0x410
[    8.106521]  bpf_prog_cfc8cd0f42c04044_overwrite_cb+0x47/0x4b
[    8.106521]  bpf_prog_8c30cd7c4db2e963_overwrite_timer+0x65/0x86
[    8.106521]  bpf_prog_test_run_syscall+0xe1/0x2a0

it's due to combination of features and fixes,
but mainly this
commit 6d78b4473cdb ("bpf: Tell memcg to use allow_spinning=3Dfalse path
in bpf_timer_init()")

__GFP_HIGH is confusing slab/kmemleak internals to skip
caling kmemleak_alloc_recursive(), so subsequent kfree_rcu()->
kvfree_call_rcu()->kmemleak_ignore() complains with above splat.

I think the only proper fix is to covert bpf_timer to use
kmalloc_nolock/kfree_nolock. I have a wip fix. Will send soon.

