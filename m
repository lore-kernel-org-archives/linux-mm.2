Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87511CCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 18:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04498E0008; Sat,  8 Nov 2025 13:13:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB4F8E0003; Sat,  8 Nov 2025 13:13:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0F38E0008; Sat,  8 Nov 2025 13:13:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5B1F8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 13:13:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 396BDC07ED
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 18:13:51 +0000 (UTC)
X-FDA: 84088238262.25.828C24B
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 48303C0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 18:13:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dSNNxseh;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762625629; a=rsa-sha256;
	cv=none;
	b=gCaW7YqXZZCFMDDDYJczbJqssX1fFuulDb0c2KIHw/5U6u+2/Wp8bbp8oNGhOlyfBUsc8i
	GL/umZ82N/A0KVmGvDPD/KybJ+rryMMfMG5/55lz4y49uGyWIl4JUpfZ48fVUYaFF6jmSI
	Gmt1khGDBqyE57hn9NgKrRfGWK3ptmw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dSNNxseh;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762625629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91HNoa+3K2lfUaegKxi2k7ABbReKqG9R1eEkUGhEO1o=;
	b=lt4EwpHAVJ80Og95SMygO7e9/KPaK7LF1vo+s66EaJAjToVHJPwDNBa6kDCklTTfn46Lvr
	diC6wclNwsa58CSUywNioMYe+ffVkZOiTKsmeoGYZVwRVJekYE5cYKcneNYCZfoHTwNLIQ
	h014ehjX2vOhdL+xoVLgoDXjepSf0KI=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-64175dfc338so284618a12.0
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 10:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762625628; x=1763230428; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91HNoa+3K2lfUaegKxi2k7ABbReKqG9R1eEkUGhEO1o=;
        b=dSNNxsehFg6YM69L7m6v3utRfxdONMjk2C/LWrjIMoMROuMuHomIjRVVktA3Tf3wSU
         sGFrC1oPNGyXn44Rtx4bT5JTPQJonUrHLOrrUkmMw4Yx8TyO/gUwv6mrwf45XevL6OsJ
         VnKYeoqk8BaQaMtiXDQgdxIgj3HIGakhG070at/9CyJ9F7U/WLsbK/JkVsoRfRj4fyxU
         zOkzbRiKxFCBPlQ4Uwctq8nYQlrXu7DkTpI43REL7i7LI9t29hD/oMWilnNUGnG0RO7Q
         ZEVLCZ6F0mpcMm0ZzVT3iRKkgbe1yFWU9Qq/gdQ9pg5oJP3KRPwvXQ/6XBahVHSsogkX
         U7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762625628; x=1763230428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=91HNoa+3K2lfUaegKxi2k7ABbReKqG9R1eEkUGhEO1o=;
        b=OIhBRNveGMvYWGuDaXNPAVxwuvF5EQxJel36i7pkmiP3t8AM166b7uXV3SEvGPSZce
         1wimLtiAyNb8BkZlyfGdz7YjXc34696Cz9G8ITCHA368V/jhZufXC9z92egBbLAf8WgQ
         bkt/0bdlZgX3KLQKAN8prkgHYcm1I84sNPlLcy7IHsW8KLhOC17KRJ52sjo+DTApFpm1
         1Qm4YVxGgXpjMLCRh4XDMimUVF2avkoO/0Uu/sg20Qd4y41s3ks5xdCdPGADNyY9VdAi
         IkJSW8PNZEJiR7MqCSmi+WjAl6mH2jALXS4dlto0C6EAbN6wW/nwLJL6usaZ3TWcnEIY
         zJmA==
X-Forwarded-Encrypted: i=1; AJvYcCUKMM6UMMsDkP/Q/z++m/N11g/SSzogDPOq1roUTQgBzwbtoEM+qDWoqjpWmSomG29j+EIe84L7KQ==@kvack.org
X-Gm-Message-State: AOJu0YzudXxNJuXPaeDUAY6NH3yQoWfrEoNrVy1guMrCSS8dSAnvsV1k
	S4q/VPHPO3t547Qj4m+zPIr3b6tbXTkktjBDiqdJZT+81eLvEyqgNisLIxdYAVFO6cl+HvBNkqM
	PpHvl03/a7BAynmVH9Id6GGPk3NNrBwdSVn+W2XbBOg==
X-Gm-Gg: ASbGnct0PDxdyaRFTGBqFVtsY9Z9t5NcEEha0u5YhETmJPk7M41rVHgz7/dW82CAsat
	KX3JkQnPcWhTgLnzb/axYywjZSvj3EPwhLPPK23pG7e5SyaruhHx2APhtxdzlMhedbSqR3y8+1d
	ktyGJ5B7msGuQe+JaolOUVunx+YPTYfTzrESFd5jIhKppkci7vJ8qanrkjHcCG5GJu8A95evO0Y
	/pSJYBOolud9bXuZOOFvmWwK5q4LQxePCnAHPPeB16SU4mPBINmEstacObn4zut4xzy3DrDHf+K
	a9CCUTfyIV6aw6Q1Zg==
X-Google-Smtp-Source: AGHT+IHZVBu8RRU1a/y3GTlLoIpZY/OsExrxtTacQ9lQl4JW8XPO7BtLSQRu2xOrmaWsBZtcsYsebXOpI3F0m4hWrgg=
X-Received: by 2002:a05:6402:1462:b0:640:eea7:c950 with SMTP id
 4fb4d7f45d1cf-6415dc0e21dmr2539062a12.13.1762625627658; Sat, 08 Nov 2025
 10:13:47 -0800 (PST)
MIME-Version: 1.0
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com> <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
 <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
 <CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com> <029090cf-9a4d-4f79-b857-04c3ada83323@linux.dev>
In-Reply-To: <029090cf-9a4d-4f79-b857-04c3ada83323@linux.dev>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 8 Nov 2025 13:13:11 -0500
X-Gm-Features: AWmQ_bmVwf9f5yvXg9QPmQc_QNNOtI32RAdJxezzIrbImc5UQioX_PtDH5nvgb8
Message-ID: <CA+CK2bByYPJXSNOh6R3swqFrGsS02m3Dfh=ZU7YhNjNX6siyqg@mail.gmail.com>
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, 
	tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 48303C0003
X-Stat-Signature: jzb7yk8dec8rs98cjx76p1t5no6kq895
X-HE-Tag: 1762625629-247322
X-HE-Meta: U2FsdGVkX18+xwM4VGzwUuoJvmPPuU+64BgOdqlXUUodPvnASTTVD9Zoj+0eHMcdZMn3uPCNut1RmPZJcOcNBM/wvrHckjfA7HD8pZuclGvdnSj4D9w8S9bx/nhx1PQfDNxeEtU+ybf1GVyrB2zDKX1v75ppTYNtClRQE+2TwnyZkALFBrVNDtwyRLX57XyjAcBfEFEYbEedxfWgcLggJ+UvcjeGOhHO/HqYSCGXCUP9RowI0+9Yz4ZfFqW/Dd5VI9XMkoJuuK35sm7XPrEawanGTtDLl4+kP3Pn5Xgm8rg9kNLnsK68OeSS0jHIvL+r3uTDzJftm7VeRpKl7XKMhtpPUG/9nv1IBXHQQiIoTfvawo/f0GZwXBKpSmPbn7u0lIh6Vu1toNvYT06BEZwCg2NQN8pA9GYujde8BCIUZtc5zy0VqAIz5txude9HWC98QcYOrEVhAv5Ab9ok3dKtb1tFwZZtEyF87MiZrbBkA+Sgr85IMZH+wHpJuy0pvU3YxVKqD7eClZyZdn9DU0CWU+X/Hzzk7WSw93XBNceUKoelEmg8DhwsH00whZtIH29NsstKVwO0XyzF+waPkMhOMA/cD2so3JqtQuFBRmgHWsN/3V3nMosVZxWxif7+NUJ9RaeFpNQBhThONTJ9N+dNzgjOa8u1ms4oufB4PkwjTY3FvJeB7cAXvwO1qRvSrFE9ozHTgAcrGaRXhbQ2qaJY8yqz8gN37ZpYR4qc0xVH1TN+lfUpItm0HiperYMAZe+npBGdqEunCO+YInGAaZYoZc0Q8jFOBE3BbZxCYOzhNLA1j2ZXEWk6j8dltwzLkRq7KMxCgfnlv5r6S+SSWcLRnfeRQX87aa8nw19znmo7WRnFn6h+ZIRR4SJVkX4xgBt3Ld2Ie80mSHuR9u1Gsr1sDwj7Fy7n/ygVTZXUX4oI1mSPCxk5XxD7cvoF07TWnipU9vnPUh4lZkEoXM7QLZX
 1AIqHe39
 gS3Ln2J+9OzT22TtPWac3+F18JG+vZGUCRog0plqKA90I3ge2sVqLMfXf7D7C3tTHSDhOcnU0pb9YLIgOkZ2Cf9w8vrRb4rFS9wzMf4kRXKqUPpfavIth67avP6oJPHG1/t4fDEE+1sbOCoRqll6wGYGqU2tVP8zLI1PhBwDXM99HaLtcMrE6y1bfSqVpGs6ibZXNSxLuPUfcWUw0Mw494MeIqAkLZ2lwxIMMEayCmj8gECc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 7, 2025 at 6:36=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@linux.dev> wr=
ote:
>
>
> On 11/7/25 4:02 AM, Pasha Tatashin wrote:
> > On Fri, Nov 7, 2025 at 7:00=E2=80=AFAM Pasha Tatashin <pasha.tatashin@s=
oleen.com> wrote:
> >>> Hi, Pasha
> >>>
> >>> In our previous discussion, we talked about counting the number of ti=
mes
> >>> the kernel is rebooted via kexec. At that time, you suggested adding =
a
> >>> variable in debugfs to keep track of this count.
> >>> However, since debugfs is now optional, where would be an appropriate
> >>> place to store this variable?
> >> It is an optional config and can still be enabled if the live update
> >> reboot number value needs to be accessed through debugfs. However,
> >> given that debugfs does not guarantee a stable interface, tooling
> >> should not be built to require these interfaces.
> >>
> >> In the WIP LUO [1] I have, I pr_info() the live update number during
> >> boot and also store it in the incoming LUO FDT tree, which can also be
> >> accessed through this optional debugfs interface.
> >>
> >> The pr_info message appears like this during boot:
> >> [    0.000000] luo: Retrieved live update data, liveupdate number: 17
> >>
> >> Pasha
> > Forgot to add link to WIP LUOv5:
> > [1] https://github.com/soleen/linux/tree/luo/v5rc04
>
>
> Thanks a lot. I=E2=80=99ve carefully read this commit:
> https://github.com/soleen/linux/commit/60205b9a95c319dc9965f119303a1d83f0=
ff08fa.
>
> To be honest, I=E2=80=99d like to run some tests with who/luo, including =
the
> selftest for kho/luo. Could you please share the steps with me?
>
> If the testing steps have already been documented somewhere, could you
> please share the link?

Currently the test performs in-kernel tests for FLB data, it creates a
number of FLB for every registered LUO file-handler, which at the
moment is only memfd.

It works together with any of the kexec based live update tests. In
v5, I introduce two tests:
luo_kexec_simple
luo_multi_session

For example, with luo_multi_session:
# ./luo_multi_session
# [STAGE 1] Starting pre-kexec setup for multi-session test...
# [STAGE 1] Creating state file for next stage (2)...
# [STAGE 1] Creating empty sessions 'multi-test-empty-1' and
'multi-test-empty-2'...
# [STAGE 1] Creating session 'multi-test-files-1' with one memfd...
# [STAGE 1] Creating session 'multi-test-files-2' with two memfds...
# [STAGE 1] Executing kexec...

... reboot ...
After reboot:

$ ./luo_multi_session
# [STAGE 2] Starting post-kexec verification...
# [STAGE 2] Retrieving all sessions...
# [STAGE 2] Verifying contents of session 'multi-test-files-1'...
# [STAGE 2] Verifying contents of session 'multi-test-files-2'...
# [STAGE 2] Test data verified successfully.
# [STAGE 2] Finalizing all test sessions...
# [STAGE 2] Finalizing state session...
#
--- MULTI-SESSION KEXEC TEST PASSED ---

Dmesg data, shows that in-kernel live update test was also successful:

[    0.000000] luo: Retrieved live update data, liveupdate number: 1
[    0.034513] liveupdate test: test-flb-v0: found flb data from the
previous boot
[    0.034517] liveupdate test: test-flb-v1: found flb data from the
previous boot
[    0.034518] liveupdate test: test-flb-v2: found flb data from the
previous boot
[    0.676891] liveupdate test: Registered 3 FLBs with file handler: [memfd=
-v1]

Pasha

> Best Regards,
>
> Yanjun.Zhu
>

