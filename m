Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F1BBE6BF00
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 11:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636216B00A7; Fri, 30 Jan 2026 06:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9886B00A9; Fri, 30 Jan 2026 06:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7786B00AA; Fri, 30 Jan 2026 06:14:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC806B00A7
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:14:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06CBB16043D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:14:32 +0000 (UTC)
X-FDA: 84388371984.03.5AD08A8
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 13F668000D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:14:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zo+c2pV7;
	spf=pass (imf30.hostedemail.com: domain of glider@google.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769771670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NX6/8aQxy3kGKKmxgUb8QfLiJ2pU03lf0e4EyOMnpg=;
	b=u8dcXLDKBui+ACQB1HVDHBYjM5wiB3vxBx0pGus1dHOPWLuOJOY4zNlcYVS1PJJ857gBZm
	eBz1pN9w6za5/RQlfys0SN60EUBAe2TDnehC+NDht3F36r2RPotgBjXEtIPHdgNb8zzssC
	QnAtKAU+F/w3sQNMlMTvqVcK/OkSwCs=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zo+c2pV7;
	spf=pass (imf30.hostedemail.com: domain of glider@google.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769771670; a=rsa-sha256;
	cv=pass;
	b=uDvFVKt6AeGsOHE8fZrB54Utqp780XciCr3Q0ZW/J6L2e/A1kTbj3vwzuvVlTuVMwZg08f
	Oo5FVvi1cUGDzH05xHyX5u1FY55nJxQVaKzIAAFSw5KCkREJbMcUlq7+f3bpu4GErVTVWS
	eQOZJfZUstEKj2/7tyLmDJd3478IfSQ=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3530715386cso1354102a91.2
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:14:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769771669; cv=none;
        d=google.com; s=arc-20240605;
        b=QEQeEfeELAg4FEKD0XFwC824c58QzoxOm3t2xWzAsy0UdTIKQYZRj6+9I8aunjNVDM
         7G3EnU2CCwrYigJR128HgjwmJyOERqY4Jzs5yA3WKrUecFQQ/qZjySMms27alQaI+SvE
         zvoqKALRnXYWQorJuexzxb3eKK9yRAof0VQ5EItj7Ttm7DHs8HA+Y1ppbq5J4jzcDp6G
         kdtgo8SL84GQfPj9vctdrK+31p84qnuvwyC2qRSji/smEBQbR0ZeEpoLQQBTqjRQJeId
         jk0MQCxGwPcB8b31bT+4CKgkVtcTCC4nPSVx1xEPljOBrROZiUO+l7IIFj4dXOqMVPsy
         yLMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5NX6/8aQxy3kGKKmxgUb8QfLiJ2pU03lf0e4EyOMnpg=;
        fh=BOGjn7s7ayBWfq2NXIMkfB/KMtY1tZSl7uoywHQUsWA=;
        b=PChcTzcKMiTyN1ONNvRbX9KIgpyRYC8SLewEs1JeCTy7KCVXCsKputxBnXbpGSX0uc
         VSpT5iMis75sssy0iUrylaymcL7vmLxQVWyyBafu7t5uXRTb/bWMrY7a0pyJp/6rJX7x
         O/HrQJbhR+XMR8F9392Oo5BkE7uhFwtas2IIgHI4uFzLpOQlU/KjHQP3Tuco+hy710tU
         krKRU6uUpXuU5kldBCCzE4S7Jp7gxIo6cXizBcz3aDh1NtqW1MmUOCcD0xcthpuBnZQc
         cvK1lpkxjsdTxA2YoV/oIARLmJapTMpJAUvOtEeWAf214uvZIXv5mMS9aOQQp+LBdHRR
         jDOg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769771669; x=1770376469; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NX6/8aQxy3kGKKmxgUb8QfLiJ2pU03lf0e4EyOMnpg=;
        b=Zo+c2pV7QI4AEJUp+7Rw6fmf6r4nJozPrSSusREbuHMIcu76Rq4w3Sg4AbqFGrILd2
         9kqBfYOfA5ibHtHh+MrXXeVEm75eGFgDlsH3XmoObjqQkRqWaPDON5Gb+8LUzQCrsVtf
         Tbvn+jfKv8ItXQrnLV6vbKLJdHkAxGlQg2B2IgNpYKcUkal2iDtubx2iqtduO/AGk9ZM
         BECK40ImJ5MqJq+kXzcuBMbcJac45eFWGiEmeKszxtHZWqpUCpd13B2bRb3lZSIM4eq7
         xzX5VSN1xwg24wPbxnYrE3olUw5Bb66YGjdmC9pKiHJdvLzTi2YcO5JQPHuPUxw3ZuqH
         RT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769771669; x=1770376469;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5NX6/8aQxy3kGKKmxgUb8QfLiJ2pU03lf0e4EyOMnpg=;
        b=ThjgtyZZWy6Ozf5TzgEQTz47iYkDbZn4ezrr+kCLtEj/yubkK8R4TRYgrHGuupE0ss
         a04H65rhDZsfLCaV7PhUs6UjOgFwyJvBEsczBKc5dLKZnpaUAjLxnc07+GiOMG9FHk3u
         tB1oOvPnPYcMh7fv2kVtA/mS1ste7UiXK1RtAts5Jcw9c0dHMcG4+C4WVvgS5yLE7TcW
         W6JiNXXjdpCZLGuybPkPv9w5HQ6vq/sYrbrQXP7ws1Z3ohm8aq/gdmb3psb23T/dloyu
         e2IPsfQxQZP0BGLv3MpH+TaGaDNNSVQBdV2dCIF+CHJyVvIGrUhAaZLb/EpvOrgpcRgH
         +EUA==
X-Forwarded-Encrypted: i=1; AJvYcCWx6Iy24JuarcR1uhV86/wVOb7g+y2NAVKitHxJIpaQKNRJs8maV4hnPLAll4Q81pvGwCmxQX9g5Q==@kvack.org
X-Gm-Message-State: AOJu0YwBjsVI+UtE0n+wyRmv8ikJvoN4ZwfVlFlp+iRyjtEGkHYM0nxC
	WU/ye03491m5H9cwrgkLZLsMENqXdRBKmRNPeIFWc+Fy1vpbCX7SIV+6vlCI01IFAadrdJsox2S
	brbaZj+/Uo5aL5rRQoguayQ30+KbGJjF2vGsIcdRt
X-Gm-Gg: AZuq6aIst8gIv05SjDVIZECEuhZCt9SKFwAdejYVfob2B7OahioK/2tRC9xTci6lEts
	jlNIakBPemEGB2Dq5LQ7DHBVyDnzxaAAiqVY+Oze7/Iow6hFr4TAq05SGfqxM++hGbRawcpTwzc
	8oh33DHaBRXNAAegZK5GeXSkV1+8Hc66d1vgC4E+9mugXcJ/+ptT/olVIy3x9uc94NuKPd7tju4
	nZIRrIxp1GYFxsG8eKo3PXKUskgm3B5wLlB7URbksrHwzh4aHRyxp0XysF7Vjnws6GBt0Whjb+E
	DYYvY+Ins6SJb8VxnmxInIeBfg==
X-Received: by 2002:a17:90b:3c43:b0:352:ccae:fe65 with SMTP id
 98e67ed59e1d1-3543b2dee06mr2832480a91.4.1769771668673; Fri, 30 Jan 2026
 03:14:28 -0800 (PST)
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com> <CAG_fn=W6wdFHYsEqkS37iWOkJUZqS0LUEg-N2HWo+3Rw-76v4A@mail.gmail.com>
In-Reply-To: <CAG_fn=W6wdFHYsEqkS37iWOkJUZqS0LUEg-N2HWo+3Rw-76v4A@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 30 Jan 2026 12:13:49 +0100
X-Gm-Features: AZwV_Qg0luMSY0y1N1xh2lvqYlNWV--Rlx3KALTJGGklX1gYVl6nq4JAZoKUMIQ
Message-ID: <CAG_fn=URHwuOuF_RNyxDCJZmjAFKSf4kHau6uTsFFPrTB=3-Kw@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] KFuzzTest: a new kernel fuzzing framework
To: shuah@kernel.org, skhan@linuxfoundation.org
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, Ethan Graham <ethan.w.s.graham@gmail.com>, jannh@google.com, 
	johannes@sipsolutions.net, kasan-dev@googlegroups.com, kees@kernel.org, 
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de, 
	mcgrof@kernel.org, rmoar@google.com, sj@kernel.org, tarasmadan@google.com, 
	wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 75jm98hqzksz6b6ebudqkb8azkwencwq
X-Rspamd-Queue-Id: 13F668000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769771669-111754
X-HE-Meta: U2FsdGVkX1+AtUOxOWYDAR/zHTaUDlR8fkmBeJW8CRfsCUXq/4ODqWUwxYmxOx3cDPO/fqOh6p64sFQTy9dnpHoSZA1beEoVjLWwV76fk1ypZK7ElIt/pfsplyuQXnxI3Liqt5eiokwzbv49C9YbP0Wt8FyixsuS006A5++TH+nQKyqpQPR6OYF91hBNm4p90FBnFioL4+qM/MRHM/GdIKb97OIIhZP0ACu5Pcps+/QohjiZNMDvBo4AvBrgP/mYFfV0KJn6xuqNjn+GED3MY/NsyW0aqDen/HBnCpBnQFx1C6fUGOpgWXu37/cH+WRD39THSbOa9Pf6chAiO3euL8NYoxaZR5JcbyPWWe076OGMY3E7tixtWMsvLKugKMDc8ebpngenj9Xvb1NqWMtbtdZPr75iEYKbrd+VREvFa83i411X3LUhn+ITnjfdCSa5saY8HUddkPITitqyhAT2n16aAt6DIE4YJqJ5G/PvLrL9doSrzU2ffor5RnSc1L8mzf5jgPyunrHemlCQmPFdgEgjb3Fz3WOEYNZui5V5/wROqHxe9s36gdnS/UqlnIt77mIMfI3Qvir+vS41C/+b35XoyYvJPQWRVDv/VyAYrlSkxDZoS2OEsFTOX7Kr7ivLGdMn11oweALPBhFMcX1okVIE2wqoTS3xsXpid94ngKeWznM6EL7jHWO8oA5ZUDlRBktIL85mkLIFe1w2dez2/hpj1LaZfjGPgyE1WCFbPwO/2gFPxdi82hVNe2hrxn66rNz15dCnmTOFdK2O7yBosgDnoN3MhalYCiXx7yYqA7sIXJzJ9Sz9yVmCGls84I9j6bge3tR86aKb4CVhfl35HFtxouLbu7sLOoC8Ya14yyWHOAxJIYhLBqrTv/3Lby148FuDvQj7TlSmiP9qy7gT3mQFVSpdhvgM9Q9yDr06Sd+eSzfnANMXj+OwT7jt9lOQarf8loFhMWCwl2i+YUM
 p1AegRmE
 8KSRGJaVVJ4YXvVeEmmG+jh1kJ20qw4gWLNkmSV+u4X98M9Km47IcrOv9xn2c2ibATOHaVGsqgar96GamcYdYR1ilT4eKQLHbGNs1qj5yOCgZWon3I4MMmZ6snjrdYlfL7bsyHKf4izpuhaRYIj+EzSm21HrlYAzQ80FbnCCzEvzZ87Aqyg/zcPAJoTb+TvIJ8f0RgAjR0Pz10bbYdgKmL4abB9CIHKGgQfSkmBuK4N2ebgG6ISKs6qMLTW7Ao4X0TEIIVhStbcFftTXPcjzjlQfylm1KTNfLuSOSSAxB19omogmbZ2rKIkWQ5BnI7/SM9cFvYWd9QpHs8O+F5XAnaF1uibcTb2XuL1QTJLNKcopMObE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 3:26=E2=80=AFPM Alexander Potapenko <glider@google.=
com> wrote:
>
> On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gm=
ail.com> wrote:
> >
> > This patch series introduces KFuzzTest, a lightweight framework for
> > creating in-kernel fuzz targets for internal kernel functions.
> >
> > The primary motivation for KFuzzTest is to simplify the fuzzing of
> > low-level, relatively stateless functions (e.g., data parsers, format
> > converters) that are difficult to exercise effectively from the syscall
> > boundary. It is intended for in-situ fuzzing of kernel code without
> > requiring that it be built as a separate userspace library or that its
> > dependencies be stubbed out.
> >
> > Following feedback from the Linux Plumbers Conference and mailing list
> > discussions, this version of the framework has been significantly
> > simplified. It now focuses exclusively on handling raw binary inputs,
> > removing the complexity of the custom serialization format and DWARF
> > parsing found in previous iterations.
>
> Thanks, Ethan!
> I left some comments, but overall I think we are almost there :)
>
> A remaining open question is how to handle concurrent attempts to
> write data to debugfs.
> Some kernel functions may not support reentrancy, so we'll need to
> either document this limitation or implement proper per-test case
> locking.

Hi Shuah, I wanted to bring this series to your attention.
There are some comments to be addressed in v5, but overall, do you
think the code qualifies as "having no dependency on syzkaller"?

Thanks!

