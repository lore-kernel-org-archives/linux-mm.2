Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18DACA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 16:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72AF98E0173; Tue, 12 Aug 2025 12:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702AC8E0168; Tue, 12 Aug 2025 12:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA458E0173; Tue, 12 Aug 2025 12:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49E1D8E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:57:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E25A816011F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:57:52 +0000 (UTC)
X-FDA: 83768712384.05.6A76676
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 084C5C0008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:57:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G85dTLkB;
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755017871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THi5EeRjYjU12pg786HqRQnWCXSwecn27iJQLPTdTuM=;
	b=BN7UuW1t+AmT6rQZXi2PtZjfNuvn1MLBy3uQJbb1A002Vf8cU/3VhK6zdCb4Doq9c3zKYt
	P/pRK1VC54NCJtEeoB3BmqXtV6iXh2f0d5Y8cSSxTeJdVMaVp1INfRGYQaxougQvUsqb2m
	yYGP0foA5C6bVNVLhz37Ep/n/lN6vHM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G85dTLkB;
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755017871; a=rsa-sha256;
	cv=none;
	b=TMWGDowND4Tywuf5ucpfYVpzHGCjw6Em11noAG3Jx4tLEKPca2y/aUM/BeDPYSwY0fE686
	VGMi9PokQEjCRfw6lWdpaFEJjjRzJhLVTJsDQUoeNYBA5iuMk8orJlFbcx7b54T8SMk8/0
	g4vaAWSt1eQPr5Ux8GiPJHvE1MtHCNc=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45a12b3f4b3so6623395e9.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755017869; x=1755622669; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=THi5EeRjYjU12pg786HqRQnWCXSwecn27iJQLPTdTuM=;
        b=G85dTLkBO0Mu6XAYjgJg3zLezTQMef1vC1yrGws4HVCdxVwz4mz/KoSEU5YOW+QMLX
         zxiu8Aj4Q40VhJIdDj7bN/2aDFtN1ZOeIHO4H05vnzyH6c3J0UA2x05w50GF+w9dl6h/
         vObNpN0tYbFQJqaBzZvUj9qPNV0sV0dbetdWR2D2flKVjuLrLQH+vaBptz8MzEo08zLW
         i6C0BDDxw/n3sxlDwsoHikZdTe3Y4uCk7GIp65zHZMDD+g9QQg5zKKxdXpi3OMqTQlfM
         1hSsvY50+sMoiD1tUL2cF9rRhQrKUE0Giy5yfnCGH/EvbYPGTYO/hOis5xG71S3cfStO
         ynxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755017869; x=1755622669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=THi5EeRjYjU12pg786HqRQnWCXSwecn27iJQLPTdTuM=;
        b=ac2AC3Lsn8Fo03XF5JdA2iQ4ssPpyCn76FOWM2Jlayz1j+qocIwO09z7AmHOlzJO8M
         RffYXrrLgxK1yYwNS5k+gjI77ccd3Ol/CArAE26SFxUQFn9QffK3xcW/EmPdiANfHscO
         AL9mRdiXtXd5iEwQSJwrBAG7OMwcDudQcWKtNI/j9R9VYm0k+f3CNarkcZNuwh4w2qv8
         TV6tNOnXhTIc+G4pzMVWdhhAi5WSBtYnQEQShz7I0HrcHrYb/tqnOW4SARHJV21omv2z
         GG2dF4G4ZK6ATMNmgdROp4hX70rl/jIgy6cEg1MpnsyATXQvzyZx3roFSppYUuXF9INj
         Xi7g==
X-Gm-Message-State: AOJu0YxlHuP9ZcPUAJtxL+a81CZ4dvOT60XODdBUDoNk+lHFDmshRWAt
	6GOhg6atxjZQNo0jD2C+AqN7bHqTORF/Yr8A4pqxW9dCqbQbXzqnFPBsdsmTUGNKBA3VS81aDUf
	WdOWK6yMFrthJnL3pp79kMVTTw0i3NPE=
X-Gm-Gg: ASbGncvpo3yrXUsleffRxHilWarKLgsCGxrAkrTzxAeGEDkjrtUw/E82iOjar0UVLnA
	Wanko1bemTMCQUbxdlXCYOradHaUeMMWzQreH6Gtapc3df0sxcgEUi+3MNqbwgNwBepatVeL+iE
	pnhEq4wldz8XBf4F09MfcbUpwvSCP+/uNihoG1Ob60O+qeM/ZD53+dmDajGYiBzyxBkUzoUNymJ
	8TBkdkwyw==
X-Google-Smtp-Source: AGHT+IEsQlhEeOC6eiZ93gGJ4m8uomE3V15azZrYXmJyDSkXZ3M01xCGgAXrwPBIlc9YO4MZyr7dBEomuI8DNX20blc=
X-Received: by 2002:a05:600c:548b:b0:456:1c4a:82ca with SMTP id
 5b1f17b1804b1-45a15b8ff7cmr4280275e9.32.1755017869451; Tue, 12 Aug 2025
 09:57:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250812124941.69508-1-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 12 Aug 2025 18:57:37 +0200
X-Gm-Features: Ac12FXxO7VtFtbvMzrNpRmaaDrUzWKgNXXMRGHfAEt4lFzHjRoU7D-oGMR2kngk
Message-ID: <CA+fCnZcAa62uXqnUwxFmDYh1xPqKBOQqOT55kU8iY_pgQg2+NA@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com, 
	elver@google.com, snovitoll@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 084C5C0008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4fzoquj517emnq6qums7cy7ra1a8p74x
X-HE-Tag: 1755017870-269664
X-HE-Meta: U2FsdGVkX1/aRFG8dgHhsGsn2I5MWOy23oPaAPutUnq0tRt5dSBzmhWoFqIzgwPY7GZwjH7iprc0XYq4ff9pRkU1GCzWC4/FolXQmwxf9tyzdVOn6LqprMjM2slbqTev4nCgr3TgRgstRFnE8cH6i2D2Tm7lZgo2L1tU0otEacqMcowiQpXVF1vQgo0TG6/NFuk2zOMSLehJmKJByeL7cq/CZFiauvqC8MtFwYjvbI7IVPbnUc1TicV0jN2eGfNEMftQqM8zVHKrUKm8THEblf0oIGfQbXoeGj5XtcLXpSxzXAlTLzA975r2dzrbSlS53ai+YV2U9XVKTYZQfxtZDNpD6mqC/cRRHMGZla0dqnxr6SILuTBO23fEEEeGyPW769oBeaqWAAXObbIgk3VCEWpuovjW8/YVO1HHmoDOSNPGmBj082uzaYnoTM9SyO7UKBJIoTe9YIqlPRMX9BqHW6+PD3kE/YAS68P77TgY9DBlh2ASUHHxRchJnC95FYmSyaFH3wjMu9Hgtgp5yH36jsyeyd59GmBNsLzS8rZh6CvgXVPQ+VvB0F2akTAafO2zKfdAeys/aAPtIScvcdHYb9SujxuFspUmetv/VnZELcvNAbiyb34L0Uf6bko+gnm1vrBsoohsWOpDXPA6iJzs1ygN4ZJohfcQ4aqK07Aw45LF+Tb2DHDLQKXFl4N4Af7zJC6/+uPnWwRBylj536fphEgxd0PIkard6bi0YaIIvBGWD1EBS8E+RRYgxAV/h7vci3PdIoGqGgexoT+xYlPwEFOU59zqFUj8UceJVcXrKIWUtQjhioIXzqyZ6HAFsVhTq6etN57AZeFDv9HEbXzn4xEkFy+9Ke39nW5Obm7x651JSmn5O3h0OBb5ITfpdZK0DnLKcm6jfvnfeA0khVLOHUXaj190o1aWFenbZHKneUYtiVsGGGbPR+0UWho5mfQmocm4Ne/mHLfa/MjW973
 syv00FK0
 vWlHmQAyoyuXP61vAfJVz6/owkFtLNY5XDkQCeLVKuHQevfQ4w/7nJbj/+Gjpbdm+TDMtZ8MT/Vk78siI+IrYG4dx8mQ2p/y4WqatEM1JPMKG/1LTcDvmmU51AUoMsKu+bFGFqnwHtrBHXY+pGFwCMt04EI960Yzua8bE72CylGe7iFcgU/CV45YyfJiDApPRE/U6Go16e+JI10AGNFQ4bR8X/wtyAJPxKRgPV/RrHIQY09VXEjR9V9HI/YIoD0YII3AQKIoe0Wv5UHIF6EMDhMLrYg6UZkhawgZoMaG4TXCfvPvtvKcnrp/MNrgogj+s9uZjrWxYI4Rw/XJHK1znOyRe/vIETbfUDpPnRfDGS0UQlh1mxvUXLwKFR7FYpFlsvAweWk2PtxnWPv3a4XSsxbfILX2g90IV+nHzqBy5NyOJHND2+r4HFeLRnIPBmHuPPk3F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 2:49=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> Currently only hw_tags mode of kasan can be enabled or disabled with
> kernel parameter kasan=3Don|off for built kernel. For kasan generic and
> sw_tags mode, there's no way to disable them once kernel is built.
> This is not convenient sometime, e.g in system kdump is configured.
> When the 1st kernel has KASAN enabled and crash triggered to switch to
> kdump kernel, the generic or sw_tags mode will cost much extra memory
> for kasan shadow while in fact it's meaningless to have kasan in kdump
> kernel.
>
> So this patchset moves the kasan=3Don|off out of hw_tags scope and into
> common code to make it visible in generic and sw_tags mode too. Then we
> can add kasan=3Doff in kdump kernel to reduce the unneeded meomry cost fo=
r
> kasan.

Hi Baoquan,

Could you clarify what are you trying to achieve by disabling
Generic/SW_TAGS KASAN via command-line? Do you want not to see any
KASAN reports produced? Or gain back the performance?

Because for the no reports goal, it would be much easier to add a
command-line parameter to silent the reports.

And the performance goal can only be partially achieved, as you cannot
remove the compiler instrumentation without rebuilding the kernel.
(What are the boot times for KASAN_GENERIC=3Dn vs KASAN_GENERIC=3Dy +
kasan=3Doff vs KASAN_GENERIC=3Dy btw?)

Thank you!

