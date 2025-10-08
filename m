Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6703BCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 14:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22B78E0025; Wed,  8 Oct 2025 10:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA9F8E0002; Wed,  8 Oct 2025 10:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9638E0025; Wed,  8 Oct 2025 10:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8A18E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:49:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22DF359B50
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:49:35 +0000 (UTC)
X-FDA: 83975230710.20.523338B
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 37FF54000C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:49:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=StLNWeb+;
	spf=pass (imf12.hostedemail.com: domain of jpewhacker@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=jpewhacker@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759934973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcyaXLUPShgmIDCl33cHm/vwKuNgk2xrFWZ6LINoljM=;
	b=jXinm1y65EfNoi1+8lknMjmsBFUOC/Xo0dguX8NMs+gk/YW5CLzAcdbx07oSMkwgaTByiN
	oTgJouDm+ZgLfmMIcNhf+tOsgfuezXp7Xe4CPoPyWNrKQ4s90jt76YZTqh7/U1+kygNhAB
	P1geI78sPL2ucnE+pIMDE8wP3dLyuW8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=StLNWeb+;
	spf=pass (imf12.hostedemail.com: domain of jpewhacker@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=jpewhacker@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759934973; a=rsa-sha256;
	cv=none;
	b=Cb3RIDfHzzAZlyc7B/ojJOgVPtDmyg+lufx4jUMCbX51goqQJN5+R3/kL1Dni01KzYmjdk
	UkOuty7slrfcs0fQ2R1a7pcZNeA1RZBFiyIGGPH6Qx0fs2V93G7A6xGy8EEwhIhB21IoD+
	696ZJ8ZFi/sYGT28q0mIcfQVhIfPP7M=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-63bcdf5f241so1520348d50.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 07:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759934972; x=1760539772; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lcyaXLUPShgmIDCl33cHm/vwKuNgk2xrFWZ6LINoljM=;
        b=StLNWeb+i1BIpnq7q3+3zWrUxc/I4nqlR2VvHrw+5k3OdZcJir6i4Bw5jxh8dBUnAj
         OwQ4ZHYPeXHNJs4PEBecX4Nnq6UBPmU8Wsi8nUkUofn+/tJDMsPl0Cn50Z3yTTmVyeya
         aR33ONek/FcZuybRqhoydsIhhOtCf6QqKpHGk+C2xXRcNG3dbXgzolw2/F2l41M+XahB
         5PKbhiOYXNLGi7IrltJ1KcoONsvrcTckeXVElLoSXgfgDb85FfoVZOwR/mI4fmPZJjwp
         +LA4NYTde2L3/omJ85Ss6jaNYauEaj5DAMVkSz8PjkhK7KDgMjMOXmb3GeZEx1MhaCCq
         QVlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759934972; x=1760539772;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lcyaXLUPShgmIDCl33cHm/vwKuNgk2xrFWZ6LINoljM=;
        b=c5Unu5DyEmBeISNHiOMPdcJxbU6WEAPRi8q9um/oYG299wzWlbRF852hbByN2phvpt
         JD7geV54lvlGw2xtZOTnYgCyr6kAbV9qvJTxXbQaAb5W5XJfezppXmeFZog9F8ZX2x7E
         2jsGwi1iUKhUImJCyyYLmm/zfsUr2vNzKFVq12ph0Z3kPB9Ha9v4TC9LB7pLjIhIegjy
         enc+9pCKOCy2S9u8eilYfqQ1dPWi2suRw0GLwr8YmgjzwF+i2sUNcnFgQz8DW6Cb6R3K
         cjtyGweFdesC6soj4ETHmcCNMrrPmuSFzjzlZUweVkB9GAAAt4dzUaU03HnwqxWDGQs+
         GOpg==
X-Forwarded-Encrypted: i=1; AJvYcCV1uh9aRrwgLMD/FU5ZmFJkh/CPG+8nHVYz7IkpdhE/aQLRgJJYgwNrOesNINcsjaaDBFMNhKPo6g==@kvack.org
X-Gm-Message-State: AOJu0YylUUaDxZG3Fc03pZdYA/P804yKuqbyUBdAPctZ0GsRlY7qtYWP
	cOjR/BZ+qW9McH7UIUZXDliU5j+yVLQJ8OHSA3+NzNaNauMj2NWnKyyVa8XFtXi8X7zES/+Afal
	+P3ez3hlN32e0L93n58EBw9PQBCTRFlw=
X-Gm-Gg: ASbGncvBCG6mJgalTQ89zhxPHK9QWWhI049ycKEThzY0oSPfWY8nzO5ofyNhVs33rBA
	jd7AmEqWcRJp/hpIMv1e8yN1uTIVnPA0APhmMXP7PoYkXOoiNr6WGv9aAST6CS2PExuyzc546yB
	ite3moyHINGVJbeMJYGNbbsncJbw5jDmX6l82QN6xosI/PoLISEz54EyJf/zXHavLM1SF/KNKsS
	jL4MvIX95FY1YSOYIssSMAALAZUCsAa4NCsJQWkMRJRqw==
X-Google-Smtp-Source: AGHT+IEEvRqkuJ82Z/1uDguuR+kVgtpAwObB6vWeI3q8N/eP1FxDL09AonZPB36dClmDoJcAb7GULptIPduQRTZOjdw=
X-Received: by 2002:a53:b847:0:b0:635:4ecf:f0ce with SMTP id
 956f58d0204a3-63cbe14cc08mr6282876d50.26.1759934971823; Wed, 08 Oct 2025
 07:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <20241121100539.605818-1-jimzhao.ai@gmail.com> <20251007161711.468149-1-JPEWhacker@gmail.com>
 <ywwhwyc4el6vikghnd5yoejteld6dudemta7lsrtacvecshst5@avvpac27felp>
In-Reply-To: <ywwhwyc4el6vikghnd5yoejteld6dudemta7lsrtacvecshst5@avvpac27felp>
From: Joshua Watt <jpewhacker@gmail.com>
Date: Wed, 8 Oct 2025 08:49:20 -0600
X-Gm-Features: AS18NWCpKHFseMz7HnNNaZWGPOtA5ZcFiGPgcQxn7wnVm-h7S75ViS7O41MSTZM
Message-ID: <CAJdd5GY1mmi83V8DyiUJSZoLRVhUz_hY=qR-SjZ8Ss9bxQ002w@mail.gmail.com>
Subject: Re: [PATCH] mm/page-writeback: Consolidate wb_thresh bumping logic
 into __wb_calc_thresh
To: Jan Kara <jack@suse.cz>
Cc: jimzhao.ai@gmail.com, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 37FF54000C
X-Stat-Signature: sbhi768uss49u84nedd1wfx4jycrsh8u
X-Rspam-User: 
X-HE-Tag: 1759934972-89342
X-HE-Meta: U2FsdGVkX1/OB9GwamPbyBESN8PUZsvpMYCxrSG14f6m3YW6kPC5Zh3Ty0BUwmAF1+UpaQbBYI2lA+AnEH4UizPUkTuqlr0boKxDkxIgkcowT56R0xkc/stPnPpCyC4XrPXGJCTRmyb2tf+8rVyl8oJFlTz4wKjQFqRsOXs8x7E3iKcIl708gVsXM2LTOFflaw0BLzKO681HuOaUiXFOhM9yXgCm1+5L/4NnVVpH3gJYpKtwMVF8qlExUcOkRD7PMTrInfcvZrKd0bztNr3fDS6QqSVexp9fj5re3Zs9znkXw4y+58QPpGMVpQnf5Mgis4Cr2zGI/y3A7csxosvsd2u6zWNOhQvlCJkI6WD/B5RPMWVM21CI7HPRY6NOYlIbuujuWW8O5qW0llDmLAWulfB1Hjx2bQrb2cAO1ZoftMuQzR/gpSRx+4njmVTQlHvGfL0uE9qisExQUvYTvq9WmPRVY+aI96Hlh4pLL8/Q2A2fFvlb7cgZOSNDf74nnuxN+prf8V5hECeY2C8pHrodnIe6cHH6483iVw8R0guBNHQDte+t+okGNVVcPobZt9mujxn0RITCoukx5/5i1YXSWfu5/Zocc2d+KsrjqhF4TZuJweN8zeQBaf+yILky5aOrN5ClEGfnwQ7LxsJyNqwcAlljJQ7veUum1UO5UKXX1hVLCy9wBGvOytm4Cb6MDkRFdFvSKCP7GgIUMOe7Vnb8LxlzMeyeUZtApgQKIa5qPH1pZvrvVkbWp580xHCN21cwSaQtHL4pFqIbcom58WJGhQ5IMQUJ2CYxg2/3MhZhClK2rK9dJuk1n8ZzgSVk8BMbPjUGF0kpZ9AAIhlDzzQ+Tp6qDvHrbtBiNkZKSYRoBSfSmt4Q6kQY/qTtKF3UHr+PRkN3DKs2TeyZ1j0elS5ulkAuWfWSaLvk7E8Itin/vX55p/lJ2QdJy6Oi/Cip9rUPPkToqen9BlKfOL7MPhc
 EXGuRfAn
 wwQNcgRDO1BAvtph6hBudoBqXDvFOfPh9t0oswZ63b5p9qq0NjVCKnu2oD4OUYPyZtWCRlKS5n6yVA+1Fy/LC6qfJrd/t3andLYGE0gEqf9uEmYXNYGXkW6zVf/skIYSme+6U0XdKO1omvRqyRsr5bgn3aNiz3j3ndLKZoc2VDzQIxeWmrym2+GCeTHV94ULfVIw2OUwp437NDci2b5NTkoMJJYnZ5nFuq1WwseCxXG6tDsSxGSU8W2QcxshRC0X5lXIpbLXW8SO+735BdbwKWWTVZmvi33VWo4GUjLMpwj3AH5XJI6R4rMgAS/mf4RY08FjPHEFPrgQ/iUg0Iz7PcKniqqe7ONfxQiGbN6W7SsYRZQ3oYRyVjKYyrLNzR5OFOwQuIJsLGdId1z+EY4YrsZ2CEWa8IMb3im2WAklpPd3MysAw9LQWtL/QwvaunwTuIlFB/b+70i3dVvX+ZYn4CbyXdJQsmM3YCpqW/fdXJhgLJo9boPoFR8b7wgU6bALqNCzOAlCGabx7TME9SLagpflJrC0nOVPN7K77HMZQ8XJlFxg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 5:14=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> Hello!
>
> On Tue 07-10-25 10:17:11, Joshua Watt wrote:
> > From: Joshua Watt <jpewhacker@gmail.com>
> >
> > This patch strangely breaks NFS 4 clients for me. The behavior is that =
a
> > client will start getting an I/O error which in turn is caused by the c=
lient
> > getting a NFS3ERR_BADSESSION when attempting to write data to the serve=
r. I
> > bisected the kernel from the latest master
> > (9029dc666353504ea7c1ebfdf09bc1aab40f6147) to this commit (log below). =
Also,
> > when I revert this commit on master the bug disappears.
> >
> > The server is running kernel 5.4.161, and the client that exhibits the
> > behavior is running in qemux86, and has mounted the server with the opt=
ions
> > rw,relatime,vers=3D4.1,rsize=3D1048576,wsize=3D1048576,namlen=3D255,sof=
t,proto=3Dtcp,port=3D52049,timeo=3D600,retrans=3D2,sec=3Dnull,clientaddr=3D=
172.16.6.90,local_lock=3Dnone,addr=3D172.16.6.0
> >
> > The program that I wrote to reproduce this is pretty simple; it does a =
file
> > lock over NFS, then writes data to the file once per second. After abou=
t 32
> > seconds, it receives the I/O error, and this reproduced every time. I c=
an
> > provide the sample program if necessary.
>
> This is indeed rather curious.
>
> > I also captured the NFS traffic both in the passing case and the failur=
e case,
> > and can provide them if useful.
> >
> > I did look at the two dumps and I'm not exactly sure what the differenc=
e is,
> > other than with this patch the client tries to write every 30 seconds (=
and
> > fails), where as without it attempts to write back every 5 seconds. I h=
ave no
> > idea why this patch would cause this problem.
>
> So the change in writeback behavior is not surprising. The commit does
> modify the logic computing dirty limits in some corner cases and your
> description matches the fact that previously the computed limits were low=
er
> so we've started writeback after 5s (dirty_writeback_interval) while with
> the patch we didn't cross the threshold and thus started writeback only
> once the dirty data was old enough, which is 30s (dirty_expire_interval).
>
> But that's all, you should be able to observe exactly the same writeback
> behavior if you write less even without this patch. So I suspect that the
> different writeback behavior is just triggering some bug in the NFS (eith=
er
> on the client or the server side). The NFS3ERR_BADSESSION error you're
> getting back sounds like something times out somewhere, falls out of cach=
e
> and reports this error (which doesn't happen if we writeback after 5s
> instead of 30s). NFS guys maybe have better idea what's going on here.
>
> You could possibly workaround this problem (and verify my theory) by tuni=
ng
> /proc/sys/vm/dirty_expire_centisecs to a lower value (say 500). This will
> make inode writeback start earlier and thus should effectively mask the
> problem again.

Changing /proc/sys/vm/dirty_expire_centisecs did indeed prevent the
issue from occurring. As an experiment, I tried to see what the lowest
value I could use that worked, and it was also 500. Even setting it to
600 would cause it to error out eventually. This would indicate to me
a server problem (which is unfortunate because that's much harder for
me to debug), but perhaps the NFS folks could weigh in.

>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

