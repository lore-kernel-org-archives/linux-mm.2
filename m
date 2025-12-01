Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3029D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 13:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17FEE6B000A; Mon,  1 Dec 2025 08:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1301F6B0088; Mon,  1 Dec 2025 08:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01ECE6B0089; Mon,  1 Dec 2025 08:26:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBFC86B000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:26:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C5E91A01E9
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:26:40 +0000 (UTC)
X-FDA: 84170976960.27.806D526
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id A9D131C0016
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:26:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ToU/5xyi";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of sudipm.mukherjee@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=sudipm.mukherjee@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764595598; a=rsa-sha256;
	cv=none;
	b=oqtSJMNbc0yDNVfAh9nw1ROEzY1dGwlSdS9nWYfG5Htzcl3GdMrMr3H3qnU7hi1nNClbt/
	odPpAg9QzoObFGqOz4M1ZssYlRVlLUyr19bOomj4cxQLm7418mi2YaPfuJe9tDMKvXwVlw
	mggZeyKYSo7KYCQh5uEq1nmK3vh2H1s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ToU/5xyi";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of sudipm.mukherjee@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=sudipm.mukherjee@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764595598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OT69i5hYEy+xoWsqzEI4NzpRbIWfBlJ47+V/PV4cOqI=;
	b=oYHNtkiNLq2i9XyRbuLAd0vpL0Dw0gdXA068rb2mD46fBgVZWT9y1qI3VY1OmewEYI7PAF
	UMJtBfAaIgmdgQw0+o4Wtd83alCUTqoe1rdYb9AhYeVWGqW7/9JrbtTS8oMo1yNSjqX68s
	RCZUgmbd9Hju+43GrK1Vx2jmq61S13Y=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b7672a12eb8so47953866b.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 05:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764595597; x=1765200397; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OT69i5hYEy+xoWsqzEI4NzpRbIWfBlJ47+V/PV4cOqI=;
        b=ToU/5xyiyk53CWl2dMd3owgbwMOumHNOdpMy168vLNx3y0TqXXscGjB0fL0bo+uJnv
         bO/rIJG1l7g/Uv41POSCwT8XLtgv2rapwxHlYrUyLL0YXRt4W+E78t9qO/n2bAhQO3ZR
         xhk7Jpvby9Lb9+lg5HrLI09psUO6OzKA4WhNlajyteZKTbvlaTNNAyXfSiDofm6Ny3oA
         chA417zMJ1K4DRik9xCsFxGtiHfPDig4RXGRaCOYdBdeop3t2AgMLaxWTjISstv8qjwc
         ZtZIpjj6v+TW2Lb33THlCBuaKgqGEQnVi1SweTXPfnMPrpYidhWYSNYOkxZotCDgJ7N4
         PLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764595597; x=1765200397;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OT69i5hYEy+xoWsqzEI4NzpRbIWfBlJ47+V/PV4cOqI=;
        b=tgsC04c5XIRY+Fst+Xwd+74IOGqXipvwsNU6uVQx9Zzljv9DvrWjwmn3PtvCdM6ddN
         T/mugBe25M2R840CS9vu7eTuSvDPakuXxaL7zieKSungmKn1Ih179bjaX1Tf9PUEukkH
         LzkYQD3lZ/hQ+/wl03WIKy1TH5V/URCtXRhqbH96ToCU3LS1N28v3W7WU+ws/V6paOsF
         9VuwxztWDbaiTXqLbAEfIV+LCu4+EjF5loFfro2SqvGMratJ9UbIe6izvIcSXHxJLn23
         oJrw/sTfelmwdBPqkblzydEFCLsWPZr++oG3JUNfpDLgQLhG9J5Is0FWVl47dd8lQR2j
         pJKg==
X-Forwarded-Encrypted: i=1; AJvYcCVsZDjxEZjl0lobL/s/VDw1eyU1KlJAa/r2NbVhhAKVh8KL6i7Bf1hb0ZFtTi94GHU2blF0/WzgJA==@kvack.org
X-Gm-Message-State: AOJu0YzhbfsC2CgdIdVFJ5VBpwVZPxa3g0zG3qp4PfOc5N0MBjfQQgHb
	SKKPhON6+p2Q0haII09EeQGPusZztk2iFzC3uyGDPl3MVbUfQrfzqjwkU/zXdXiMwlCYO7Zpra+
	rZBSxuc0Ej+Wlme632DvhAyosZLWMvzI=
X-Gm-Gg: ASbGncuZwvhYA0rKbNgKT5PQ/inBDQwhGryF6/YbFcTDOTQI1MihReqZWuhkoCd2q9F
	qyavPXVtSbNDdKCPZOFxH89nlyET8IH1mKC55SOFhwVrD4YZkmdFemTb6nuTR0fDgTYdsvex33/
	ZkGyR4KoR1oueNe5Rnw2FPYpl96H6BixnTRUjQiBjdxwebyl4bci752C6bTb3XDhE6dhos29Qpi
	0fBbV/UaFo6rzytRQL+7tAk+w7U+15zL/ZUEi7N693NjIZ/68+ro6zuXuE71SkbuvyM/ig=
X-Google-Smtp-Source: AGHT+IFyO9+LGGmFyReTGUumTl17UewEI50V/5adbCYeJcarlzJzMBdYHfN5rbGaM751Bk5kYaq5rOTh2eihB1pVoqo=
X-Received: by 2002:a17:907:2d26:b0:b73:8bdb:9608 with SMTP id
 a640c23a62f3a-b767700c4a4mr2387387366b.2.1764595596886; Mon, 01 Dec 2025
 05:26:36 -0800 (PST)
MIME-Version: 1.0
References: <6ba903ad-9897-42bb-8c2d-337385cc3746@molgen.mpg.de> <db387081-345f-423a-a0ff-e13f3bec2d51@molgen.mpg.de>
In-Reply-To: <db387081-345f-423a-a0ff-e13f3bec2d51@molgen.mpg.de>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Mon, 1 Dec 2025 13:25:59 +0000
X-Gm-Features: AWmQ_blqLxd36fmljwIpQgggDAlKEhmUtfAyB3aAfy7nFPBq21RVnlHBcmLukQM
Message-ID: <CADVatmM_mRnkDX=hpUjbyKkZnGynxJfRSujGxm2LaWWMEL_2ew@mail.gmail.com>
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000000
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A9D131C0016
X-Stat-Signature: tamuu1qf4drmc58gjgi9xnjuxkmaxu5m
X-Rspam-User: 
X-HE-Tag: 1764595598-136455
X-HE-Meta: U2FsdGVkX18INN5obg7lXWS/pPu5A6zMx7/G1HZl1kWbMV2+75FMIBocryHNgyd10aYTYOmeTWiuZw8MdAmMgG5T3dIhShqVZqWBD5jTwwIRf4lLqdcoKyLJ/NLLp5xHPUt+E3uXZeloPEVwjxhyw4DHzhTOC/jhsR3SZoDAMxa367NnvmcmL852UztzdFE62PUkIM6p2+s62DkMZYjRgBGLx35lCNjny5Kr33i0SMmwLVPdlPCIbuMZSGUXdfiJ7FHcAaJvjpkQ6IHPdh0g1uVnmmsEMo7y/h9NdIW4GAJkq0Or7ZiEy3wKfqOMoq1vLpxEm9F+SbgigC/9fJ1+3JmWB3ZSnjr8nhDrIQVHzlAex49M8VFzts17wui7HabtlB3S8Mr/XXXIOp/bse052DJG1Kzn6JR5/KZPw+g2wlSkYs51tE/Seq7ZmWsDn43j+2YTDoWIrn7avSpaX2sZq5gLoH0LvA6p8I2x02B/CFPeSzI0uI8heeSLLd25KoDR0zqNiORTepqr+GyckhduNbqN6H4gg8ubFkW5PckCfjRw+hklXEOJ+IXqUBNOWo2SJ//PhfJA6SpmaN+/NyBdFfGwlWOjrQKtMsZ/PkBb694TR6qH35YLlG1G/zTcgeKBHESSbrlSjRzAS2roPOdQT+rtPfETUvuQG3JdtwLaci2XlsqSacE17pRiRzFG97xtNA5pQ1ya6nnBfAE3+iGDyzxrkEUIHs1yGNSytYqmwxn554fhRjbluQEBiGC/6ne03ndMCCSbdrpJl0dXARTP8Dmfju7mrG8QNhhKvY5feQrhElpSmm4rowyK/BVN5Mz8rZCQKveC1Uxe7mSHoAaIiBarptohBqWcxTYxO/AwRZLmBfFyJW1EuoQD7cskncThTRdY4V4FRcRu7ZiHBpReypfRITIOFd51zyXSLe4QOMfjmT4IqquHzbcvQZrL4HznOlfuuTmLh47Py+voD++
 F41XXXTe
 BJrIsP6ggO832sk+Ke/3IvlExbQAfQWW8dz6+yngwezbUbIuPuPR9W2BpjycsiuV51xCTDjJSSDPYASp2yX2mzGvBBA4h27iSB+COwC/mpqEh9F+L0OeLo0rvbkqs58nEAmWtQUAlZGhjnhorme6xc/mURuMoYX72vfszLYVRODXJ+NaqOO1fD6BHLw9DhC+YQVwTV869tkqsfNvb0ZqfeRX5Req6aXKfLzZ4JU/e0H04cezVurqwM2xfumFZnYUWXCN7WjojlJ7t9uDLfTHVe9KH580OvGxqlNGqPs57hH17FPuryhrRIe6IG/uVK1rN4U0NUTA5NFoQT/pgPGiys6UFukx5D92jKESXKdA1FvPBwWJhC+rG92yqQFTomaX2k6Ck
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Nov 2025 at 22:55, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Linux folks,
>
>
> Am 27.11.25 um 19:51 schrieb Paul Menzel:
>
> > Unfortunately, not reproducible, but starting with Linux 6.18-rc7, I got
> > the oops below *once*:
> >
> > ```

<snip>

>
> Building and booting Linux 6.18.0-rc7-00041-g765e56e41a5a, I got another
> oops.
>
>      [   15.234799] ppdev lp.0: really_probe: driver_sysfs_add failed
>      [   15.234852] ------------[ cut here ]------------
>      [   15.234854] refcount_t: addition on 0; use-after-free.
>      [   15.234864] WARNING: CPU: 0 PID: 353 at lib/refcount.c:25
> refcount_warn_saturate+0xcd/0xf0
>
> Please find the output of `dmesg` attached.
>
> (It might be related to booting with an USB-C mini-dock connected, but I
> do not know yet.)

In both cases, it seems the underlying hardware was removed  or the
module was unloaded while it was still registering.

In the first case, 'parport_default_proc_unregister' has been called
while parport driver is still checking for all the connected devices
and was executing 'lp_attach'.
'parport_default_proc_unregister' will only be called when the parport
module is exiting.

Same in the second case,  'lp_attach' was still executing and
'ppdev_cleanup' was called.

Are you seeing the crash only from v6.18-rc7 onwards? Was v6.18-rc6 or
v6.17 ok for you ?


-- 
Regards
Sudip

