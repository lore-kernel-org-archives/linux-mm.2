Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E0A606A329
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=themaw.net header.i=@themaw.net header.a=rsa-sha256 header.s=fm1 header.b=UrEV8CO1;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=avGk9PqI
Received: by kanga.kvack.org (Postfix)
	id DD8D76B05B9; Mon, 26 Oct 2026 18:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89146B05BA; Mon, 26 Oct 2026 18:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C788C6B05BB; Mon, 26 Oct 2026 18:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 992086B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:08:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BF2912090B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:08:16 +0000 (UTC)
X-FDA: 85366166592.25.A24C3C4
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf04.hostedemail.com (Postfix) with ESMTP id DDAC340005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:08:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=themaw.net header.s=fm1 header.b=UrEV8CO1;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="a vGk9Pq";
	dmarc=pass (policy=none) header.from=themaw.net;
	spf=pass (imf04.hostedemail.com: domain of raven@themaw.net designates 202.12.124.148 as permitted sender) smtp.mailfrom=raven@themaw.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793052494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yw8gJOW94fTkjKACtcjzfr/YsSITaXsnUbgsLWBosFE=;
	b=h1f/Pqw4XVsQt9svbR+4aPwDlBLo7qjuXYnJRGuJnG1zuqwKREhrJyoVSjRyH9Vhg15sxN
	kKEVl95ysdHFy/NXP2tdAw4SNj4AXIKMMR9nAJnqOunUfDxR22SAvSU/EWgNI5/kiXUJdS
	ozrIcaRi7nKo2UIwpy1Ma+CVQz8KVqo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=themaw.net header.s=fm1 header.b=UrEV8CO1;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="a vGk9Pq";
	dmarc=pass (policy=none) header.from=themaw.net;
	spf=pass (imf04.hostedemail.com: domain of raven@themaw.net designates 202.12.124.148 as permitted sender) smtp.mailfrom=raven@themaw.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793052494;
	b=zLrNyvgNDbrEuChCakDZXnK07EeJBXiDPFkrZrFkvz7xlN/Z5mMIHZjpWCTBfZk7iZLYP3
	Lmo951MoXezqoXDodK4KA+iO5IoYtIm3A9DdZvnFDzyL51B5YaZTIYiQeH43ikao2EERfO
	uCs6ocUxtX1FQTkkdP5HZoSAH8wDZhc=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id B2F681D003D1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:08:12 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 26 Oct 2026 18:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1793052490;
	 x=1793138890; bh=yw8gJOW94fTkjKACtcjzfr/YsSITaXsnUbgsLWBosFE=; b=
	UrEV8CO1TUZnK8PJPLQEQ+mBDacfr1ualCI79fofyFxHp/qlH67Qk1zDha6ZDsUD
	FAJJYbbVRZH706lqEQ1NMx+s1EL71CQ+qJsAggeKG0vqBj/xL0+g9/cQe3EmmVdf
	OBP9oeiZdtOdhVjy/9V65hXNxM/X0M6KX3SXFOfk0nMcUaC4TuW9Lzuv2ZezXmX2
	Xm4f4UvRS5LSth3SslZmRV6M1ryJPxSBz8w0BPf9Iigy7LFomt5f2d4ANnD3HKLz
	lcSjcD+UjlJRdGQsr5RE78TsLBdHTwyWipS6UmHptFiSmVIO1/Q2QG9HEyR7jwi2
	EYnYOOJt/YEUKLEp9QlmYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793052490; x=
	1793138890; bh=yw8gJOW94fTkjKACtcjzfr/YsSITaXsnUbgsLWBosFE=; b=a
	vGk9PqIr6hEzkBG77k8GkpXeSQRT+MVDN4DUxSMcA1igxPIR/+ga1iuhPR87rrch
	o39J5JLbaroJv+WocVTRVwIurwoXClx0UWuccJ+RgdT0YRqkRq3PW3yzZKClbwX5
	3PZHhRjN82XGlHlJbp/bOyza6RhwVbJRIEDqU5PO7X908wlAZXc7i09ujPK/uSwP
	maqeWiARyT+wYltmETV8RrnGseapHSWp99e0Cf5kBm0Whh7W7jcTP1gtIbhSpiyR
	0u/vnbhHjLT8RNpOZZfIxnpiwmL5vNgnvKvxOb8zxwiBvIQ76xAQd8Rnn2fR98xe
	yIS/MWt0ERu5CwEw/HwWw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=themaw.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793052490; d=themaw.net;
	mf=PHJhdmVuQHRoZW1hdy5uZXQ+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:UVLtorp89mR0lwPR6WdTxZMFQiDJshy+smiRrgK/ZsMgWlk
	54q3MZ+BIHOiyh/EddG7hK+W0ojmdA+YIuMthVu4jlHR03ia2GHu95M7Mk3qMwC4
	yrOhrvj7VHAmxhAdBf9wiUizmpvOUie8q2xftn5qZlJkWT04CWZofwdcT5mnJnOT
	LfFCOPUm6tvYslTQMQ+eu6J21ZbnYiV90grXIM4Z0ZZXasMK13lyM/0qVC5MFrdV
	iImAnpTHaJO0tfpLJpT8PUtTrH13wCCFtEMJeBQgrP+uJ6TaDGKgiO98ntEKOoMi
	rER3RgtzFgnl1oW8u7YcIW9n5KAC64JftEOzNiA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to,
	user-agent;
Message-Instance: m=1; h=sha256:tdg6ua8/hQS/iYkk+8+1oIbT4XjyplM8CQ3hPjDL8gU=:yw8gJOW94fTkjKACtcjzfr/YsSITaXsnUbgsLWBosFE=;
X-ME-Sender: <xms:SM_falmJYKjuMXVHDQt2QQt2e9GRe6P_ZlHx9B0jy3DtnwU-Mhwilw>
    <xme:SM_fanzOb00shgf6BVLGTvm3wWAEqDvLNbmTrEUBM6t2vXp1Jn27RhxW-QSd6_ZcG
    FynuGh_Zd1AH-3TXIyVt0MGvELm2hQ0AdlawiG__NQvzM1M>
X-ME-Received: <xmr:SM_fagulXQAxGdh47J-3Sc9EZB76wUhrIZV1bSoHJVRcNT9CV3-XLvoY5_ae3ExFkPIKFqbwCSLPkds1UqaKAorpiepGRidZUelVzfY9gax3aZgg4D9bQFfcjNM>
X-ME-Proxy-Cause: dmFkZTF5HCOsxN9EPzsQKkgStD/Ff4WaJ8kNbHpSExIutymQMzNLPQM/4D7eFPnNuRZhMM
    yiFZU29YFLK097HXfiVZtxDexZrGtWPk8oIS0KHK9LJ+COj6lx72D3NGicQiveM66XsuuI
    T5hdMIkNOs99rmLKIhonQkKb4GS6BpcgwfRht1cF14LSexGc7Vuh+dOSrMRFPPDR2vDdp+
    I2Kj5kQbVl3rdYwlSzYKD6Ljbc/jI3yCouc8I227ttT1dc69wA3DVKDYh6Dxx4CnJAsGMx
    dRdBm2OsEUCbGYBG+rLKXIe7ZjFMsj4ic7Jo/KwKEtc8FlEvgmpa4M2QKds/GCXUxeH3mV
    hlatiPuA1PlYXizqCztg6HNVhQRmacIaSHc8Qwq2Br5SvRSQdKCk92iWVbYNmY5u7sdCPv
    eI9FmIM1vtGGAJVQBqh7+2hzdk6ENCtM8BtYfw4MCq8+yiVA4HOqdWvKKVC2aMSUyYSNNs
    GjuuWW6QfDWQPLpxyjyyRbSKdpIIyL3Tg4q94xEIkUtYDseeq5zvDy0TxIe/8uq6trsyvq
    12FxalXYe67wUyQOKOMK+vxsxR9oRudyupWfujyodN+jFjBk8gVG3TaBeGM0J1IM+Kt/YQ
    9kpaZYdH824878CQeB9Hov1Tbl+TNTcopCEAWeu9r3TVYfVORKt387XTeRNw
X-ME-Proxy: <xmx:SM_fastfAR-nbfD779bC72wWAQSNDoTOifg7ia6nkQp1Uu6Wl9JC8w>
    <xmx:SM_faukfKeNv0QfbzQ1Mdz-dRnCEs-2QfPbeNcc7818FyLAicMNf6g>
    <xmx:SM_faqvDy6DYaKkRzWH01Rnp9FtgDFJd7PuUy91kFsJxUMfQVADTGw>
    <xmx:SM_falM6fmdy7zX8HjhUCgmquQTDw-Dbj4SPd2ytgaZzwcTjJj6Log>
    <xmx:Ss_fas8XLcMNaCaKXBRNJwdR2hfN8SrYNk_YE7dtRdyQgT0KrlyGPJI4>
Feedback-ID: i31e841b0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 18:08:03 -0400 (EDT)
Message-ID: <dc65c28e408d6b64d4b13b7ad30e5fe70ddaa441.camel@themaw.net>
Subject: Re: [PATCH 0/2] kernfs, autofs: fix pipe lock cycles through sysfs
 stores
From: Ian Kent <raven@themaw.net>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>, Greg Kroah-Hartman
	 <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
 Danilo Krummrich	 <dakr@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner	 <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,  Peter Zijlstra
 <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Jens
 Axboe <axboe@kernel.dk>, 	driver-core@lists.linux.dev,
 autofs@vger.kernel.org, 	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, 
	syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Date: Tue, 27 Oct 2026 06:07:59 +0800
In-Reply-To: <cover.1792577179.git.krystianmkaniewski@gmail.com>
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
	 <cover.1792577179.git.krystianmkaniewski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44app2) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DDAC340005
X-Stat-Signature: 7xfyjk8jj96kiecb1hd3pmy8exfo56pr
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793052493-252435
X-HE-Meta: U2FsdGVkX1/zLjtoOdvVEf8+T5bCnVS/7daUIPR1+PbgVKBTEsN/3zqYsLkQ6/jMAcPoC9bkVGYN3Hf2Dy6ZDJ9jGJZHue7muXv+kYrMy+B0FpgVVqmwe/iIuG0yFOC30i9dFRCdp/qCmqG7dExMqSHHcBww6AOlfSjZ7f1MmT1SS9pI1tH/j+jMWJbtxp+8+cHgY9PF8d0QiPqK7sJ2wVdFyjZG4aa1hswGr9KPOlRPFYeru6Ulh6XCS30H1ttoeiogEv0ih0N4yUP9IRce6QwKqVoUmB1MCYBfVjPK7cLHXhiMqdzs7pdhkeUMyrazGnjJ/izBEhEFslveH0wtCPJyn3rvEP6jM8LgX068T0iE1FUdrKKGQ0UASeae1QBOsu9HAEFNrPac5yjBexamU13MFEYsgEBP4WYFvdjGogrLVcovRrykqej1NY4Qq2MNWOVcYbJRvo/FP5etKTntXNvbc78nmckKgPgqaz8EvTiNPAv8GOsmJ3EuQjVE9Ntt95jslqpvkt6KV4ErLsYEurxxTU6axiBgXMRti1XfUVBg9C3XIx5jUMnWFKMUldyTvP3oIbUCgGxDGWXWNKxrV9Os/rFNd6qRgZ+MjN6IHCqvSsohyK0STyygaW2VFJmq3wWxyzvAXzUFro5iDRgHjWbHsxfYYz3Lf1BtEk5D48Hnsv7pi6KrrCQibG5NHSgaRLFy3PAKikUd/LHSZaUVX6MDNXSaviyfMIJ+BYt2M93eG3wru3hgSbJcVN59UtCG3Rupts07BykhknilCWauIMNrnw4TxDcF4e2Fts9Iif61qWykn7qlYST4+PXxCSGCpmd+268xR8qQ126V2x///aRjaTEW5Np1h+23oLHwHYSsJ6PWjtlRD0fk0jkEwhLV+lWIAQiFMhraVz2UdJm7dRqH5bBybgAvVLPVxTyVdfLg/Mi6hrJNFbq4w5MEcgtQ+jYcLv4zetOyQIjErf1
 ZBaKGjxv
 UnaZ3mHZW9MnEborrtDpgBHT9CNxiAESeu//GklnduuWheI3hdQm8LhtQH4OH8lgZ0xTLW9tvqSjjn4AKhDaVc3z8px0eazoORvISGTRpbaZr7o2XKZ92PWmZPj5zi5WZ6V6A0MedhKDrEIQTErZbes4jZaKGSsuOAcU5uERyVgXGwwVzHTNTcUniooK2nj8k82gTNMzi4o1MBLtAextWgqIy9luHWIJpN4wV04RN//eQHRne8acJybDQF2VccRngDTx/mgyIp8z9+Nq/lJdQ3LdnsbDaMTXGJ6RgzFV4JPldOa1Qy4R2FJThkKRXi8tNdMsQoMUP1h8t08QLs5D8w9UPCe064xHr927LMPxHFaOcMa4E07bnYX7sF3dKw5qmRHhOaspS1rT2OUkt6vVAJElDQ5f879z2EsZ26h3oLZ8VXG1JlfMX5REklI6Hcxg2mPYmmKjjja5mOSSoPktX+lLe8aPAqg72AfEg0OBUdCe7yjhbS0YpcuoL7AhIQEeR5iUdYqdTpX5W4Bw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 2026-10-21 at 14:51 +0200, Krystian Kaniewski wrote:
> syzbot reports a lockdep cycle &pipe->mutex --> &of->mutex -->
> &sbi->pipe_mutex. splice holds a pipe mutex while it calls the write
> or
> read handler of a kernfs file, kernfs takes of->mutex there, and a
> write
> to /sys/power/resume looks up a path that can make autofs write a
> request
> into its daemon pipe and wait for the daemon.
>=20
> Patch 1 stops holding of->mutex around the ->store() callback of
> regular
> sysfs attributes, which do not get the open file and already run
> concurrently for separate opens.
>=20
> Patch 2 handles the case that patch 1 leaves. A store called from
> splice
> still runs with the pipe locked. autofs no longer sends or waits for
> a
> request in that context and returns -EAGAIN instead. A new mount is
> refused before it is marked pending, so no other lookup sends the
> request
> in its place. This also removes a deadlock in which the spliced pipe
> is
> the autofs daemon pipe itself.
>=20
> Patch 2 changes behavior for one narrow case. A lookup from a splice
> callback that needs an automount fails with -EAGAIN instead of
> waiting.
>=20
> The series was tested in QEMU with lockdep using the original C and
> syz
> reproducers and focused splice and autofs cases. The target reports
> were
> not reproduced with the series applied, and the paired functional
> cases
> matched the unpatched baseline.
I can't seem to find a reproducer that reproduces the bug or maybe
I don't know what to expect from running the syzbot reproducer I
did locate.

Can anyone help please.

Ian
>=20
> Krystian Kaniewski (2):
> =C2=A0 kernfs: do not hold of->mutex across sysfs ->store()
> =C2=A0 autofs: do not wait for the daemon while splice holds a pipe
>=20
> =C2=A0fs/autofs/expire.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 6 +++++
> =C2=A0fs/autofs/root.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 28 +++++++++=
++++++++++++--
> =C2=A0fs/kernfs/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 52 +++++++++=
++++++++++++++++++-------------
> --
> =C2=A0fs/splice.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 13 ++++++++++-
> =C2=A0fs/sysfs/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 18 ++++=
++++++++++-
> =C2=A0include/linux/kernfs.h | 11 +++++++++
> =C2=A0include/linux/sched.h=C2=A0 |=C2=A0 2 ++
> =C2=A0kernel/fork.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 |=C2=A0 1 +
> =C2=A08 files changed, 109 insertions(+), 22 deletions(-)
>=20
>=20
> base-commit: 93f51579e7df248780214094418f205253383cc5

