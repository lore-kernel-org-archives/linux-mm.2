Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EBE5606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 01:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=themaw.net header.i=@themaw.net header.a=rsa-sha256 header.s=fm1 header.b=IuANCG5d;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=ASgV40z7
Received: by kanga.kvack.org (Postfix)
	id 677A36B0609; Tue, 27 Oct 2026 21:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D436B060A; Tue, 27 Oct 2026 21:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 563236B060B; Tue, 27 Oct 2026 21:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5A96B0609
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:22:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC850A0C0A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:22:01 +0000 (UTC)
X-FDA: 85370283642.24.ABCB5BB
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	by imf01.hostedemail.com (Postfix) with ESMTP id A654E40002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:21:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=themaw.net header.s=fm1 header.b=IuANCG5d;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="A SgV40z";
	spf=pass (imf01.hostedemail.com: domain of raven@themaw.net designates 103.168.172.147 as permitted sender) smtp.mailfrom=raven@themaw.net;
	dmarc=pass (policy=none) header.from=themaw.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793150519;
	b=CZZp3jmAGda0ejdBMINEn0swKqdp/Hkp0BLUP6/MPfz1dd/92HFkzNU4z7xY6TztrsYcgq
	55qwnmydT+JfbXanmfcxoRbhGiwHJ1nqMVhjpxSrrdtiS4d7aT8HmzBFuCn4HvA2uf0d3O
	0GzXiPwx8Rl64jeVdPq2GR2pyZHMTFA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=themaw.net header.s=fm1 header.b=IuANCG5d;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="A SgV40z";
	spf=pass (imf01.hostedemail.com: domain of raven@themaw.net designates 103.168.172.147 as permitted sender) smtp.mailfrom=raven@themaw.net;
	dmarc=pass (policy=none) header.from=themaw.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793150519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cR+Jnw2vZTLedug2NT9bT/PNYuUzdhU9pnjK8Gk3b4=;
	b=t6ywREpPzJcRkxxsS2q+ar5lL1h1TZLpmPhWyehNAZZS6O5hZGElyrYcrkyLiQP+y6e0DA
	CTwZyT/Zmi/xd6Nkq6oCoF1BrfkkQjluThufLe/rKkLbKvlmTo4Vvx/Gvk970BFNG4jzEK
	6/D5PCDaEwwWBQDMdE95JtBqxyHEDz8=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 0F52EEC01C3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:21:59 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 27 Oct 2026 21:21:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1793150518;
	 x=1793236918; bh=4cR+Jnw2vZTLedug2NT9bT/PNYuUzdhU9pnjK8Gk3b4=; b=
	IuANCG5dx2AuLSzGWT1IlW0LpNdHwVHudaxvydOEnc3KSoJ/qoMeuRTBcuHevylW
	xUbQw+3IqU+mSDopyXhKpLMSyZdaIQYBWsp91BtQLJ6ivce7R1cuF7LYQVlluKOM
	55TmLfhzJ/XgFzpWKbku9XBEEHXvbqRJ5vOSHONPiAFeVL8JucBr1JOA/VFwvjKS
	w11r6SsVd0monzWXTSSRu9aCd1MnbVsYTMZQxq4e7JYEQg0XE3VlNJOsuLd4+Ahu
	M2i0unzEJI77CglJFd3yELGpyxcNPO6lBajkV1sZOKnC3Pk/qgxAH53X7FyqVsbo
	jkTWgUXOP8IFrAx0YIZ2Zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793150518; x=
	1793236918; bh=4cR+Jnw2vZTLedug2NT9bT/PNYuUzdhU9pnjK8Gk3b4=; b=A
	SgV40z7r6xfOgnty139gvV4mch5EP3LpzWKZnR0DqUM4+khkf+60HFQqKimBZ41O
	GpWenOjpJF06vWXJx6ne53P/sdpYna3Yh9kYveLMWrgn873gdVS2BPYroWQPhcxQ
	j8FQ/TYUcJyq1VEohzGMzcv/D5F9bKLVFzIGeGnwytFhspGcAad8f7oc6bXYjpg3
	1KZoPk5Y3HhjR0aN8sdnG6UAFbI98LFbZxfR31UoaDOWQ8AvKGLa+kRa/mXHpIUp
	RiAUDg4gSiO+zFjhCN9FDe+hrXJ9Cgl3iBmIcbzWpOWfT+LuuadMSvQcN3RGDqus
	BADMJIzTu3vtT/xhem48w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=themaw.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793150518; d=themaw.net;
	mf=PHJhdmVuQHRoZW1hdy5uZXQ+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:IvpZyJ5Po7sxwu8D/UcpMwjHh5W1x3LTfbmGnFtWO8MqzIo
	W2NUdFU7z9LhKSI02Sas5IolMpxcCjlU3gTPb7aPmiVc8ZJpL4lgefwhwYCRdvy5
	xyMxvqbHFoKSPzGeTtIgeaS8f5if9MTcUNafYUk0BifL8HA9sSXD22kCIa5bkyGf
	rV/6OEVffl22gmV1lVehBouITsI6Sx0i4rVVOlIxGVr7nnqvehmFio8EmsUp8UCR
	zj0VmNRv6gpkBo8QCiFhJiX048qDwNaMWDkWI3+gaZpfrE7nVWZgyR/+x5WkHoAE
	Bs7OexZ1+i4q/ZxbTgCWy5S7SF6Ey1eGRaHvytg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to,
	user-agent;
Message-Instance: m=1; h=sha256:bLZaW/+c77h1LhtpnAtMkoSIjWiZ2pBNMO0v3iO12fE=:4cR+Jnw2vZTLedug2NT9bT/PNYuUzdhU9pnjK8Gk3b4=;
X-ME-Sender: <xms:NU7havTQm7CONmk_vTIxyQr2bggizao4KrnCTHOZ-DkioGzPn_0_Cg>
    <xme:NU7hanuN5n0amtHDXTfCLVNahO5-mo9vXcMLvteA_LdixJ2JqjfE2OXpSqZAoRDw9
    9zB2o5kCwdI5nC3rzACzyLVfBUMdUUkzLm9ZMp9wz4XqggaUQ>
X-ME-Received: <xmr:NU7hap4Rmoc1y1NiVdhky5AhS2soreP5Mn4L00ThsQUenIhtq7rJNcu1pb49HmmEVaVYZMSVJiGWZtrqfBzV2zNcfOaCUTc66JS2LcokcUPuk2veGHDtkWAnPBE>
X-ME-Proxy-Cause: dmFkZTExjEu5Z4ShUEEPbIUBi9jvlntQl3xywqhol0VilT1H3riwx+R5F5xJP13Eevy37Q
    0i2tM3JNLjjIE4RnafdrKckgTZgF7WVXIi2BOm3qqKixBS/Irug73Tiau0YR/vN5tre4hn
    maQ7bdbQdERoqsBHTuky/6kPN1uRRdMEQp7qfaGblPSG+4EBzlUBu4KVifRQGZl+JiSvgw
    9mSbn8dIqXi2WXNiWFaTJHHZ4Jih2f4J8Zf8XQJs9Or+djBfP7qo+n/CcBwnndgEEsWDvn
    dde2XKLK1ANi3gu15BOxuI5tGRXcf4I/n59a/Jk8KMuRhC+UWXSiv/46euNQ6JSTIIAimv
    7jcAW/tdVBGXJXklC1RRPUglHq4hH5Bc64PIl28tFEzC6NIzPjSltWekhutJo/tT2majGT
    sswf9kF/mQ7bfD6GGD2BLOWWsUXcYZgnu4j4D7tHPb/zynsKGK6m+AhMOPYjmUzMOzh5dT
    b4rWxbMHiL5nnjAdO5ldN4zD++TlD1rdyXqAHwBHPTOIS8FN/SKiiEb38SpBdbZorRtZ3g
    6HKFrjuDJITZTWSsi/aiCUAXSktyenMIc8kN6yeNsZHz8HdWRAJlXYnV78lUl5wNp4dJzJ
    K2wtUluCHNuU9Ak5O20DPSdgweZAMliMgfRfP/R4THeQWT2Cq5n/XeaklCLw
X-ME-Proxy: <xmx:NU7hamKsy46mFaILnzutP5LNXCeEcEkH7ASldNGwyMSr1vsmEA_XLQ>
    <xmx:NU7hajRmT8qLJPv58aR7XoaIN4e0ZQloPg1Re3nCph4Fgy5gL4tmng>
    <xmx:NU7hapoTY0a-MqM5sQVzrhTvHncNfTKm3VeNlXgeqpDve-iSMPWQrg>
    <xmx:NU7hahb9D81m8XEdG4qqwPK-ysKtigp5k8VzEshrenjpsUJ67MPPlQ>
    <xmx:Nk7hairIFIEEI4qphXaATaK3ls9tH3EoMbCthRQcYtN9uyTpEesD-K0G>
Feedback-ID: i31e841b0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 21:21:52 -0400 (EDT)
Message-ID: <5de6de037706e45ba88939e8f36e7dae48005e6c.camel@themaw.net>
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
Date: Wed, 28 Oct 2026 09:21:48 +0800
In-Reply-To: <083c2bb0-85b6-480e-afcb-bd2f386f2ddd@gmail.com>
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
	 <cover.1792577179.git.krystianmkaniewski@gmail.com>
	 <dc65c28e408d6b64d4b13b7ad30e5fe70ddaa441.camel@themaw.net>
	 <4f56c93a9fc5fee152364974773df0a319c84af9.camel@themaw.net>
	 <083c2bb0-85b6-480e-afcb-bd2f386f2ddd@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44app2) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: uzhjrr83kfbyoa1spnymgmmbdhjt7bif
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A654E40002
X-Rspam-User: 
X-HE-Tag: 1793150519-571022
X-HE-Meta: U2FsdGVkX198NHWHYWwcCSY6UIhdYLb6rSG/ZJq/tpSPvHsPXy3WKQtjyL/QFEh3DFqgdkiDn/M8DSgtESy7Rh1uIwbbO/f9rbgNNMMnEq8gFie04KauMW6/iJ/ejD3n4ca7BfoiJQz0a5uMrKGldYZTAEw68rL9i91RnJ+4z7NEmdqMfxqeyIgh9jCs5t0r8TJlYZSIvjaT2PFjgxxxm+VwdPBFbBOFmQy6/ZsUpuxQQUXViQQJxoPfHFDd+f/HEi/+S09av8apxzomRt2xudpiFXcCV1E047pcw/5dGkyfaXacr8bUaUpn3Wm8tdOesgOnUqVUERsc9fnNYl+OcRx0PXYoQ3LIpVP9joBsH8yMMpD5NVHB6PBJ8Ri5Z6K6p6iJeE08LKRZWAepmDVIS/Q99+qih6NnctlZRYwdJtCDQLvY/yczl0hI5oCc3+5Y8IcgR09CLL+FX/rWNWIjyikOXlnDmktP/frXl/GvgPPfFVc7hbsEd2B+YEHUXz1bD74uiA2VaM8/SWJ1cQEEbe8RAq1U0chwanAwL5pJGG9Zbu6iK1+dKjsgT/RP5Tp5zFpJIpo4EwFA3vHb9TMsZWYjEAu4kl4bukFsP5L46LYYRDix2DBp0FvbHkWDynSsIYIBHaR2Uvmn+NyAYt66NHzwkiNV9X5mKe9q3oY/CKG0nolihXJ2cw/sWTavYnbke8idSgKOQa+vHVACWCJgNWKuP+G68TLLi3G+m7KmW1OisHH4JoVvMxRR55+0uLx8uN70SJfdwMhn7Y/xb85V75alubg51QOOig11/7fDH8QDb3LU96Ml+tMIybySk0gq8N7soFJ1a33IFuowQKJx3M/LJp4iUXK0fu2hhREkLl92wSUMrsVocZdUMMFp+0Hb9cebsCKdgUc4iF2qbVefcqeE1cw7jf7cLtfmEH553JZZeOOZTJbD+9lVT8B6gcWW8BLEKGJJfZtysUq8Nv0
 LyZuJXca
 4ZdavLXzD8OjOZS8jxEPLHpeVogNzmX2Ivv+C97Gg3g3ELha5NIWHDBXqzM7cuowFRf8guJmHTLfCIDBuHvjk7C6Vv/8nRzCwKcdPJbrzLV82XUsdra9kHyBrTLZQ4M8w9cFO76urwhTJJkmK+xIFbMg9HCcFHElgM3TpdB3yBY098gEg2v+TNDAwcCFH8QRD0zENp1eS+PWDK/Pxdbc8A3auvlaMqrR3jyNQPQ244saSOb4ZMhJa68qrMQ7H16wpD5e5kf3Hxi77YWWbXYMfmvbPwxXtZ/DwQf9z1+29p21bAFXH9TWaSSLWanVOBJhRVaNORl9DNXGpV2/b0gZEWD5tq6YCeogPmFPi6LimnaK5zbs4+HmUtev1F5VD5s/r/o5ZPHfO91pXYRwp3tZQiZEOYnGomsZdqXkW/IFNLq/9E0BP3ZULDsmicECtPu2jUpORNDusntN+GFDWo+EK/2ywB3RFTo1EvR2AW+/q97hvfiTgaxlZvC4FVvz8Aqj6VQdgVwd39t8VJJ/YQylieN7sT6y9rW0Qd4O5QXXffmKkxcYz11T81P0JwEiLmIQ7PutmVlUBttikRjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-10-27 at 01:57 +0100, Krystian Kaniewski wrote:
> Hi Ian,
>=20
Thanks for replying, ;)

> On Tue, 2026-10-27 at 07:11 +0800, Ian Kent wrote:
> > Commit 1e8c813b083c ("PM: hibernate: don't use early_lookup_bdev
> > in resume_store") looks like it's been around for a while so I
> > assume the reproducer should work on 7.2.12?
>=20
> Yes. That commit entered v6.5-rc1, so 7.2.12 contains the relevant
> code.
>=20
> I used the unmodified C reproducer linked from the syzbot report:
>=20
> https://syzkaller.appspot.com/text?tag=3DReproC&x=3D11c0f4c9580000
>=20
> I also used the configuration provided with the report:
>=20
> https://syzkaller.appspot.com/text?tag=3DKernelConfig&x=3D7d012d9c67977ee=
4
>=20
> > What should I expect, a hang, it doesn't.
>=20
> A permanent hang is not expected. The result to look for is this
> lockdep warning in dmesg:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARNING: possible circular loc=
king dependency detected
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &pipe->mutex --> &of->mutex --=
> &sbi->pipe_mutex
>=20
> The reproducer records the first dependency by splicing into the
> cgroup v1 devices.deny file. It records the opposite dependencies
> through a normal write to /sys/power/resume. These operations use
> different lock instances, so the exact reproducer reports a possible
> cycle rather than deadlocking.
>=20
> The write waits for an autofs daemon that never replies, but the C
> wrapper kills the blocked child after five seconds and starts another
> iteration. In my test the warning appeared in the first iteration.
>=20
> The test needs lockdep and CONFIG_PROVE_LOCKING, the cgroup v1
> devices
> controller, autofs, and working hibernation support. It must also run
> as root. Without lockdep, the program can appear to do nothing
> useful.

Ok, I'll check on those, not sure about hibernation support in my
VM ...

>=20
> > Also it looks to me like the reproducer is trying exploit an
> > invalid request similar to what I described earlier
>=20
> Whether the string identifies a usable resume device is separate from
> the autofs request. resume_store() first passes it to lookup_bdev(),
> which performs a pathname lookup before the numeric fallback.
>=20
> The reproducer changes its current directory to the root of a
> detached
> indirect autofs mount. It then opens /sys/power/resume using an
> absolute path and writes the relative name
> "0x0000000004000921".
>=20
> The resulting lookup is therefore:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <autofs root>/0x00000000040009=
21
>=20
> For autofs, this is an ordinary lookup of a new immediate child of
> the
> indirect mount root, so it is a normal mount trigger. There is no
> autofs mount under /sys/power.

Right, enabling the autofs pr-debug logging and looking at the
reproducer verified the exection flow for me. I didn't see a
lockdep splat but my environment is probably not quite right.
I'll check what I can and see if I can reproduce.

>=20
> In parallel, I am preparing a revised patch following Tejun's
> suggestion. It disables splice for writable opens of
> /sys/power/resume and gives its of->mutex a separate lockdep class.
>=20
> If you send your autofs change, I can run the same reproducer against
> it and check both the request and the lockdep warning.
>=20
> Thanks,
> Krystian

