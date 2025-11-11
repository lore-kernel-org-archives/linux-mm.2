Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97FCCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 15:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0288E0005; Tue, 11 Nov 2025 10:27:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7F18E0002; Tue, 11 Nov 2025 10:27:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDDD08E0005; Tue, 11 Nov 2025 10:27:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C66498E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:27:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DC7DC05FF
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:27:18 +0000 (UTC)
X-FDA: 84098704956.02.F6F150F
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3411814000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:27:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bOjnPnLZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762874836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lu6xqedUZpu06tEFPTZgP8w+N6x8oJvOkAJiVTdokuU=;
	b=WBr8c2bnOVsuQI6+EkH2bLgqQC8Ll6SnyIy+b6lvPn5nmnnTiSRQciMmJFq2U9ETaPS7v/
	TdlpDncEqo9xRApbmOm0M3xOKVmaqzMYH5ine3xbGdFFSGYssr/ZyElQ8SHg6eraUofuNY
	4Ii8uxaw91ubsRnECrLfkUCawAePuqQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762874836; a=rsa-sha256;
	cv=none;
	b=yIUeLHHFn9pivfJ25GLKlpIJSKXYIAKHOJe/0FF/c363M92/FxUdu/ggn4zkXUeaM9Ssau
	6fHySvod7mqkWZIegk4g5oe5BtgX4d9QMLENRErD1x0jbk+oewHT/KC4Wss9zR3ypbS6gR
	2kFqniMrJPqQN4vai6rIyIgex08qMzU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bOjnPnLZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-63b9da57cecso6822144a12.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762874834; x=1763479634; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lu6xqedUZpu06tEFPTZgP8w+N6x8oJvOkAJiVTdokuU=;
        b=bOjnPnLZh0kwBRHT8pCqozxogm3Y+psTn1v/LO0hgWqCu3g2OztzbmTsxg6zYHWh2b
         9Ov2QPHFsC1RYNnbI6t1hBb3SEfRxtpZ9uLqDpeXF+tWzUMGpHkjIuhp3VWyuvp4ztm7
         0zz+ptSOPVXgMU+vo1hjWN5G/jU+tnZLw+jGIahVLehdnkDhIw66gPQSfYGAxZWvXa0S
         CCmATP/6uuiCQmGjUO5B9hyumOovj0Nn68e0Ayw50mSVmrk5rK+1pWTm9/oTLSRPlqp3
         bdIc1Fzzwx/lJEl10FF9CF9jjRIJHIdd2kQp7ORpAnIHxTqaRCs4mGJN51m9JVkgQ/2e
         46Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762874834; x=1763479634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lu6xqedUZpu06tEFPTZgP8w+N6x8oJvOkAJiVTdokuU=;
        b=O6+cdPKKVUGfQyKLyqIJxyzmX1MKhcfRofF59zW/4E37wRMGaxSO5XTNInxxrEGg9T
         +XRit2ZYX3PS6ICDIgSXc60T00pIP9eWLfVcFBzotPcE3auCXX4opKrDbOT+jUbevhpZ
         Q4YDy4eIRU3fHhtZEo9++SvVFYNQXykISbJYye7O/an1ckZRYtQ+ZVbUwwLIkJEwfiOC
         CDyycCrQ3CigrMf1J2kLDtOsedxgZHKrANKLJx5NCbNQrF5Iu1GY6a7yHdvwpUrpB15/
         +ZCeMPTExr804w9lLGXwuXrfemfPI3PicRB3L8i3fsyUZVJSXcG8jw8krXDcx1zWcKuu
         KrVg==
X-Forwarded-Encrypted: i=1; AJvYcCUfLziRVcp1F139LvwTyENNA6MEaZ70lUnJeabSCOBC/CakR4LzSUSEXeozSYrhRpzpiL611iXNRQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6YnKgISqNvcAt9Giqeb9A1jxbIrGWkh7SCyui1aKODqvcGZtB
	xr9yhRSb51QB6A6DHm42U8EF2tGkkP2etnm3w3SxVKEEsjF6J/LLxiHvG23dXvdAFRY66UHYPE7
	hZXvziN3xttVrUpMeXNJ9wndJaaedHCMsjwHzGlKQAA==
X-Gm-Gg: ASbGncvnETx0i4ztdC2yoppA23X+y+hUhbdOgH7ToVXAwfu6g6nD5SpozODK8KyHRtl
	av/3ayyvC7QRdU76rGq9YjYh60rrhUMnfdLd5VMYuWyW73BLxQnbnjneNs2JmPq5tC3FLArCoVj
	I2wGcEfZNTaNwzk9fpmK8z/3+gOQWW4fJHYD5q1LAts3XYFdTOvkeBVRRp7pUeGEjkO0Q1UGt/y
	yZ7zUdbKVzJDGEKCsHkCokvV5gfMRl2cKNir4z0EMHP5mc8ZceGZyf1pQ==
X-Google-Smtp-Source: AGHT+IGfpzw30I50uzhP4zU1mSQ9H6EkikBegZxPU5LLVKtN3RM+oen2ff0GDhVd9BnhapB0BApwf174qkOpARMYJRI=
X-Received: by 2002:a05:6402:2688:b0:640:c3c4:45fd with SMTP id
 4fb4d7f45d1cf-6415dc00b0bmr10748897a12.5.1762874834355; Tue, 11 Nov 2025
 07:27:14 -0800 (PST)
MIME-Version: 1.0
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com> <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
 <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
 <CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com>
 <029090cf-9a4d-4f79-b857-04c3ada83323@linux.dev> <CA+CK2bByYPJXSNOh6R3swqFrGsS02m3Dfh=ZU7YhNjNX6siyqg@mail.gmail.com>
 <442fa82e-16ef-4bde-84eb-743450222468@linux.dev> <mafs0qzu69gei.fsf@kernel.org>
 <CA+CK2bBEe16x0em1gRxQD3jhfV9t3QA2vx5ifk2pKb_WEoMTeg@mail.gmail.com> <0735e1ef-2b65-4a54-b4d5-964fb875cd09@linux.dev>
In-Reply-To: <0735e1ef-2b65-4a54-b4d5-964fb875cd09@linux.dev>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 11 Nov 2025 10:26:38 -0500
X-Gm-Features: AWmQ_bnTJun9_-b7oKykqWTYNLwDN30PScTynxGQ0sII17gfGixQqv4sWCWauz0
Message-ID: <CA+CK2bBnnGyQ-N8-XS3W3tnSRwvFbstOdo0oDSdkF70KP1AVxw@mail.gmail.com>
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org, brauner@kernel.org, 
	corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4r8esfnpwpuwaw5as9b1x3fk1peqcnow
X-Rspam-User: 
X-Rspamd-Queue-Id: 3411814000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1762874836-83040
X-HE-Meta: U2FsdGVkX19CGR9ufA9foLve0Mfak4F+gD9+1XBy2gDoB4dRX2ehYfAo2aAcdAHLqCTgFyaU2l/fAVdAqrTSnp+nr7WpSAjJlVdZW32uNSqTeyOW4fDIZ10C/cKfPc4p6g0wqGyhUAVYNlEfOJLvdW4uazRl4xX420qx6F2PVqwNQuguixdhFsPsSJRoNkk6bJsEPmhoj/pK+21niUQlTH0hBl2qxqP80bDuV1gfR7lE2waI1kryQnCtIeoqDYzjvPqm/BTFNgWUDzbMC5MWn4bq16Sj476tIMnT424JJ/f3BznuULBV2ks13k5BtdvHKEjBxSYq4i4KZzvcEY3Uh1KPsHPiIFVaN7cLoICMHyn090uWXDQEVRN+L5IUlNHWj8RoUwhqk+ZMKUgsBtYxtlB+qgpYlS5zB3C9P3ggWdD3OM4REDG/bu7jJJcYAmJYZCnkGju6DPHdH854popK2bGPu+A86zkWhA63ktWpHjzsP1ZotaVX+rQNzdET+MmgLpPsNkhX7C6PZMsohbRhyJAlqrvFL8FjbvCfZ5OKk4wvbz1nFzRWrEZqFMys15cC4q39FLRcAuqyS3s39ItH1hayixHvEMpO76x+drijvRs7/+2PwtJ4BPSi1uj/YtlUGHE8eRYS+wskwMUAPnbY2+u2ilZegPm40fZQUxo2zAqQvk2TI75B7REkdiNEXwVNu0E6Nyxmhk0aO6m8yPcQQLFikHTvjwnD0Z51smAhYZKnLnk9KZcqUr6uRQbZw0PCJP+xCeI/CZeIepzLaPWOdphq/6Vzec3fFduvFlZRuX2RQildcmzoLBxKHAA1SdMPXkFkZafieMzylw06ruNySOyBwoOmVlUdztNF20ZwnEMJVsVUk+fPgPrJgA07Q2KauYEyCjdqeIKal4krBzUhU/SdJnFlVWDHu7DRvUx8cm5Kna1sOJTbTyHllk8xIY/XK+1QVKe1NP2kpOPl/Iu
 NdIKqyO1
 CEHqomgcyzn315nQ7LzFmJCUe4iIAUCM3VDqsOyjktMIX1bacP1NuJ5abe4dUe9S5xuxkFP3ehV/VqQ3wugxzm2Wx4U9RywaahJdpE5OABLygEOEwUe3SiQcBgnjm7IycmcTy30oEy+F/K1nVtdx531TAHXaim7m8qWHGDKzgUge1OcE0C02dBoD+ZOwnMkvEtkYXSjLwlJPEFmSj/iWBShe17onUOMQq0FscTW8PQHv/Mvl0UWUeYxy7uzn9wnZdISdH2ENLs0tthiAigRAmlEraiwsS1RifXRGP93FcCTRj7Ds7axqORPM4ZbKDLv0+LK64D5aJdTnLphDX/qecLH9GczXATyMl04JrJPWZ0jFzxynqiUvlUkkukowsmDjJPFs3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 11:11=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.dev> =
wrote:
>
> In FC42, when I run "./luo_multi_session"
>
> # ./luo_multi_session
> # [STAGE 1] Starting pre-kexec setup for multi-session test...
> # [STAGE 1] Creating state file for next stage (2)...
> # [STAGE 1] Creating empty sessions 'multi-test-empty-1' and
> 'multi-test-empty-2'...
> # [STAGE 1] Creating session 'multi-test-files-1' with one memfd...
> # [STAGE 1] Creating session 'multi-test-files-2' with two memfds...
> # [STAGE 1] Executing kexec...
>
> Then the system hang. And via virt-viewer, a calltrace will appear.

Looks like mountroot fails, are you passing the same kernel parameters
as the during cold boot?
i.e. kexec -l -s --reuse-cmdline --initrd=3D[initramfs] [kernel]

Pasha

>
> The call trace is in the attachment.
>
> Yanjun.Zhu
>
> =E5=9C=A8 2025/11/10 7:26, Pasha Tatashin =E5=86=99=E9=81=93:
> > On Mon, Nov 10, 2025 at 8:16=E2=80=AFAM Pratyush Yadav <pratyush@kernel=
.org> wrote:
> >> On Sun, Nov 09 2025, Zhu Yanjun wrote:
> >>
> >>> =E5=9C=A8 2025/11/8 10:13, Pasha Tatashin =E5=86=99=E9=81=93:
> >>>> On Fri, Nov 7, 2025 at 6:36=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@linux.=
dev> wrote:
> >>>>> On 11/7/25 4:02 AM, Pasha Tatashin wrote:
> >>>>>> On Fri, Nov 7, 2025 at 7:00=E2=80=AFAM Pasha Tatashin <pasha.tatas=
hin@soleen.com> wrote:
> >>>>>>>> Hi, Pasha
> >>>>>>>>
> >>>>>>>> In our previous discussion, we talked about counting the number =
of times
> >>>>>>>> the kernel is rebooted via kexec. At that time, you suggested ad=
ding a
> >>>>>>>> variable in debugfs to keep track of this count.
> >>>>>>>> However, since debugfs is now optional, where would be an approp=
riate
> >>>>>>>> place to store this variable?
> >>>>>>> It is an optional config and can still be enabled if the live upd=
ate
> >>>>>>> reboot number value needs to be accessed through debugfs. However=
,
> >>>>>>> given that debugfs does not guarantee a stable interface, tooling
> >>>>>>> should not be built to require these interfaces.
> >>>>>>>
> >>>>>>> In the WIP LUO [1] I have, I pr_info() the live update number dur=
ing
> >>>>>>> boot and also store it in the incoming LUO FDT tree, which can al=
so be
> >>>>>>> accessed through this optional debugfs interface.
> >>>>>>>
> >>>>>>> The pr_info message appears like this during boot:
> >>>>>>> [    0.000000] luo: Retrieved live update data, liveupdate number=
: 17
> >>>>>>>
> >>>>>>> Pasha
> >>>>>> Forgot to add link to WIP LUOv5:
> >>>>>> [1] https://github.com/soleen/linux/tree/luo/v5rc04
> >>>>> Thanks a lot. I=E2=80=99ve carefully read this commit:
> >>>>> https://github.com/soleen/linux/commit/60205b9a95c319dc9965f119303a=
1d83f0ff08fa.
> >>>>>
> >>>>> To be honest, I=E2=80=99d like to run some tests with who/luo, incl=
uding the
> >>>>> selftest for kho/luo. Could you please share the steps with me?
> >>>>>
> >>>>> If the testing steps have already been documented somewhere, could =
you
> >>>>> please share the link?
> >>>> Currently the test performs in-kernel tests for FLB data, it creates=
 a
> >>>> number of FLB for every registered LUO file-handler, which at the
> >>>> moment is only memfd.
> >>>>
> >>>> It works together with any of the kexec based live update tests. In
> >>>> v5, I introduce two tests:
> >>>> luo_kexec_simple
> >>>> luo_multi_session
> >>>>
> >>>> For example, with luo_multi_session:
> >>> Hi, Pasha
> >>>
> >>> I enabled "CONFIG_LIVEUPDATE=3Dy"
> >>>
> >>> # ./luo_multi_session
> >>> 1..0 # SKIP Failed to open /dev/liveupdate. Is the luo module loaded?
> >>>
> >>> # ls /dev/liveupdate
> >>> ls: cannot access '/dev/liveupdate': No such file or directory
> >>>
> >>> # grep "LIVEUPDATE" -inrHI /boot/config-`uname -r`
> >>> /boot/config-next-20251107-luo+:349:CONFIG_LIVEUPDATE=3Dy
> >>> /boot/config-next-20251107-luo+:11985:CONFIG_LIVEUPDATE_TEST=3Dy
> >>>
> >>> I made tests on FC42. But /dev/liveupdate is missing.
> >> You need to add liveupdate=3D1 to your kernel cmdline to enable LUO an=
d
> >> get /dev/liveupdate.
> > +1, kernel parameters require: kho=3D1 liveupdate=3D1
> >
> >> Pasha, your LUO series doesn't add the liveupdate parameter to
> >> kernel-parameters.txt. I think it should be done in the next version t=
o
> >> this parameter is discoverable.
> > Yeah, that is missing, I will update that in a standalone patch, or in
> > a next version.
> >
> > Thanks,
> > Pasha
>
> --
> Best Regards,
> Yanjun.Zhu

