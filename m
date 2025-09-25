Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FEDCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 15:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116F38E0005; Thu, 25 Sep 2025 11:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7CD8E0003; Thu, 25 Sep 2025 11:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F1A8E0005; Thu, 25 Sep 2025 11:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E33A58E0003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:48:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77831B80B0
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:48:03 +0000 (UTC)
X-FDA: 83928203646.06.88FCC11
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf11.hostedemail.com (Postfix) with ESMTP id 569804000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:48:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=flygoat.com header.s=fm2 header.b="O/GBpNmB";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="R 8oeF/I";
	spf=pass (imf11.hostedemail.com: domain of jiaxun.yang@flygoat.com designates 103.168.172.157 as permitted sender) smtp.mailfrom=jiaxun.yang@flygoat.com;
	dmarc=pass (policy=none) header.from=flygoat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758815281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1iw8sDU7WMAuqpMUwFBLGexpGmPqRn3XcfCHZlM+x8=;
	b=PZwhcrYH/iApvsoJ7l4Gf1rk5rc2Ol4cUZYX/sTu/etdS/Q5yHFpGKvbUgXZ0fjttrPzoS
	Nkye81SZmZcgyx710lUMZmlKZzFaMLH3P1ug0871nJIzChc4mNZWGiYl8OHrXkWM5S+x5w
	DwmeXgvwRne4z+1mIT96A6RF4KZkvl4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=flygoat.com header.s=fm2 header.b="O/GBpNmB";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="R 8oeF/I";
	spf=pass (imf11.hostedemail.com: domain of jiaxun.yang@flygoat.com designates 103.168.172.157 as permitted sender) smtp.mailfrom=jiaxun.yang@flygoat.com;
	dmarc=pass (policy=none) header.from=flygoat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758815281; a=rsa-sha256;
	cv=none;
	b=MJfva0npy28t9JZAdTs02aqBlYV6zM2/Y9ol36o4NK3KapJgHWPVNTxI8UDbaQefruXSGq
	05OpsMYM34BqtgMRDsaHb8UiC/98XgB5LmlBJHP4ZK2zPGtqNjIjeb5zwgzzfS5MtNyUTo
	uA4y3BfT9mycU7/UoOV4L6WeRCPwQ1M=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A214414000B2;
	Thu, 25 Sep 2025 11:48:00 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 25 Sep 2025 11:48:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1758815280;
	 x=1758901680; bh=N1iw8sDU7WMAuqpMUwFBLGexpGmPqRn3XcfCHZlM+x8=; b=
	O/GBpNmBS+Nf0OPIBgj2sj/PDCIKeC0j5S2VVZ/EOrg3RpCAU3O98ukVzvwuk6/A
	IRP8G7IkQvw+wQgSi683mZspBDS2sdaxTOWNew9AG8gAxO1q3BfTDUMYR2B91vN+
	W8UMVfnH1jI+IUfemiYRHmuBo66jnLXkG000inQvMG9kHmeL4C5yrhVl6iAwufAz
	osUIrj/clxIP2LdhsYSzBv9WFn0hK5HqgSrW2AO/rAHksurVN9ggGKu5z+WkaVsr
	SQhzVo4nAp5kXyaMci078CAXYEidGo9Wczj+iiHovW2kE8tSC6HwV3WSgBwjBq9O
	GoXgOqEqXg+QIpwQPwR9Mw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1758815280; x=
	1758901680; bh=N1iw8sDU7WMAuqpMUwFBLGexpGmPqRn3XcfCHZlM+x8=; b=R
	8oeF/IhEmuwV1X10Hz/vmfXFPxZUoQodsiaYBo503hrl/K127xg28RinCpb4A1cJ
	XsrQvIPnXKYvoSzPQcn6ZXvWXjveWVqGttjwiohRynGKnCftDj7Op7+NetzYzQH3
	AvFbQNQ170uD3c7BHGOvQBJz+HJAT1n44ybrSejzLXgNGvaBOtK9TGdWsXuCM52A
	Db2vYxAvJ4FjwF3frZQX6e93yhQQiAzvVefhRUzVHeAbm6iOkWo+kpfuhDVqHrEk
	+gXknvR3vza7fruiTLX1HLeJAgyGAiYDoKfZKsIn6y1EAIzuhmyt30xK0Ncnon+H
	Bduc7Ok85uxQyL1H36ALA==
X-ME-Sender: <xms:L2TVaNqxig2ibN9a8thygIfSXKBuRM0_mG1WY_1p0xER15CC2rkuJg>
    <xme:L2TVaN4bSMNyhV3UbGo-6kG4GKYyIj8W1aHCoIHk4qOU_57Yj8K1S_f4asbXHArxw
    nJwdPumtYF5_UUF5w6she-zXai4bhDA27AXcZB240bGkuQzW5HpCY2X>
X-ME-Received: <xmr:L2TVaDiVsxodL4LmNUkp1Z2bpAFsKaMx03h5euE3aWnJoE-fF0sgJpDQ5IBFw161mLC4Y8m6Mj4gSi13hHbjSrzELkqBDSoeX44>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeiieeklecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogfuuh
    hsphgvtghtffhomhgrihhnucdlgeelmdenucfjughrpegtggfuhfgjffevgffkfhfvofes
    thhqmhdthhdtjeenucfhrhhomheplfhirgiguhhnucgjrghnghcuoehjihgrgihunhdrhi
    grnhhgsehflhihghhorghtrdgtohhmqeenucggtffrrghtthgvrhhnpedtueehheehgfff
    teeiudehteeuieehfeehtdevhffhudelgeffueeivefghfffleenucffohhmrghinhepkh
    gvrhhnvghlrdhorhhgpdhsohhurhgtvghfohhrghgvrdhnvghtpdhophgvnhgrmhhpphhr
    ohhjvggtthdrohhrghdprghtlhgrshhsihgrnhdrnhgvthdplhifnhdrnhgvthenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdr
    higrnhhgsehflhihghhorghtrdgtohhmpdhnsggprhgtphhtthhopeduuddpmhhouggvpe
    hsmhhtphhouhhtpdhrtghpthhtohepgihihihouhdrfigrnhhgtghonhhgsehgmhgrihhl
    rdgtohhmpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepphgrshhhrgdrthgrthgrshhhihhnsehsohhlvggvnhdr
    tghomhdprhgtphhtthhopegtfigrnhhgsehmuhhlthhikhgvrhhnvghlrdhiohdprhgtph
    htthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthht
    ohepsghhvgesrhgvughhrghtrdgtohhmpdhrtghpthhtohepghhrrghfsegrmhgriihonh
    drtghomhdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    tghhrghnghihuhgrnhhlsehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:L2TVaL6rC81P2MnLeQXLG-DPDWw2kWRhEws9MeVzcsqmrt6QhTRU4Q>
    <xmx:MGTVaAHvN7H1BeqiLDRqYpEyC7tOnofgGx_PI0QT-fZvWdLECM7W_w>
    <xmx:MGTVaFIUqaXye2U6E0-brzIggOQ6bI-KMzsiTd-lQJqfbAI-Giqi0g>
    <xmx:MGTVaFiMKBGmXSTda75Rh5rNw8QTnpQntpmbkkXqXWSzR1wb5nNdDA>
    <xmx:MGTVaN_ntiCc4vGSs6_4JTLw3piLbXyzWXwKHEJrVUavoHdmSQVCW3Pi>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 25 Sep 2025 11:47:55 -0400 (EDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
Date: Thu, 25 Sep 2025 23:47:43 +0800
Cc: linux-kernel@vger.kernel.org,
 pasha.tatashin@soleen.com,
 Cong Wang <cwang@multikernel.io>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baoquan He <bhe@redhat.com>,
 Alexander Graf <graf@amazon.com>,
 Mike Rapoport <rppt@kernel.org>,
 Changyuan Lyu <changyuanl@google.com>,
 kexec@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BC25CE95-75A1-48E7-86E7-4E5E933761B8@flygoat.com>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)
X-Rspamd-Queue-Id: 569804000A
X-Rspamd-Server: rspam05
X-Stat-Signature: nyygk3cqx8en5rpe4don6ut4gte8ktpw
X-Rspam-User: 
X-HE-Tag: 1758815281-585486
X-HE-Meta: U2FsdGVkX194waxVkAcHnzq5qNeyBSMLixIq8nKG7EsqkdkX+bd1lrBRvPMw3RSVY5vZrk3WS6Z89Orj2rklOfZkYUAIvFStPGjApPAB3b+QXzBRREI+anzLHdH96dGUVt/TGTZsxiBmpp2pfcH0YyjAQqQ/OHMTzrTGzWxHNHyb8rqroZdvgp88RBciaK3TIcTaaNCAQV5py2kTvRm1Za4hNRLd9BcJLiXlgOLmBMQNBLRw04E3qlHmsa8LzcsYlTyVPriM585T1WjXU42FjC6l/AtMSuo+/PcJdPj1BQXBrRpNybu+MlVB7yt5bbhz5OkptLfBFJ58R9pl9tS0M4+illGzc5iMHa9d8mAr/BkD8VX3/E7uJcQfcwo2Zj+IZjQ4+ltaX1yG/+pkMAqpOtD+etZmFcCvFv8cxuIRkPDkqZapyDmeRxAhElTzj9UJ9NzbidvEFMmL1KBmldhoSB+duy3I27liJNKvNQOqPB37Bp0fJPQLAigK2lpJkM/u7bkE8/fF7bAoNrMzNbylWyadcpubg/at7mSZtYG8tHI2zebbgMDJ0e/9RuD8ymYNEP59rHlbVTL+VBLht24vxbFz2mNVK2Z799pC41uGY1eE1SRYYl9o8MVAPSgU6I2KAtGdEsRW8RERfGpBNUwoZga2d8iNCthbJJC5eNISUhfWbeGdCLF0/RGHrkLk6ztwmKkWrULMmdGcGUg1Rzx9RMHvKFu+q3/dw1aEvT5Ad0qJc5bgdddswZ4HkN3q2WSAjzir9Is1Jq8/PY4MEXj/EnEDnYLB3Fy2AiIXdbENgv3HZCsiaCwMM+549Rf0ylGDVrffYRMziBYDRJ4Un8yaAiSdEW5HHqhxHtaYFFWKq7Ta5i477S3ugrMSb/nOOOWGV+MV6j0aPbrM1KvF0I6yStWlfEvQ5npP0N1eBTrSbfaKgP7Xwuv5fSvYr048bnqHd+Nv0QXXTr+2cRx7BwU
 niOyKoOY
 fcbnV4+ye1CtyS7HfowZMdTf3tNGPB8TG22NGBY8UifbuUqLFxSaPNZBspo8c4eNT+x9Wp+LxyVmmjwq2Ch+yjAq8JCQfcYGn0dvASyYyV9GJ28mpD65hKIZTJco6VUid4ve2KwGFKbmxrRDirLLqdW3cOD7WYI9ODEXoBu+N1+/jA6Y2rX22gYFZMpRdrPGAwQChtSc+DvqS/sde5peDAmdTFzCMUPpt3KMxOIDenxYA0Jb2w9Eycy2R3mI2I+ecwEPzBup/D7sH6j0nhYFWqjL/ZmZPPmxDUpVjrmsrKXB6rKTlKh7r+641uzm85jxE+ORE03GJ+meT9cTZuLxz1h6W+t6DsHxiwoKwyFnk/F02+Ojc5Y5dxmNvIi03ux+7jH8BEPhCOINmHijZY1AfK6Yk3fxjSeSj3YP4sN46ftcPyKgJ6CMoW7UZ3JCP3MqpQ2j1RX1w5Da7ZoaeVcDaxngJGVH92KTqTEhyQCTxu8rgP4HqJ0q9ojpIQCmpMtd63+t5KFBf9Y8R33pa07OHQs/uYI3Daz3PRErXytd/+CKnegNAAjr7OcJwEonkC5FbiqjenFd9NuRem2/AmrHm+65axSmqWvuUzgenr4yrPw6E+S+xeRZpyQgaJ4iGh0fQ7sJvmoxUKpeYj+iwXSGUWItxoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> 2025=E5=B9=B49=E6=9C=8819=E6=97=A5 06:25=EF=BC=8CCong Wang =
<xiyou.wangcong@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> This patch series introduces multikernel architecture support, =
enabling
> multiple independent kernel instances to coexist and communicate on a
> single physical machine. Each kernel instance can run on dedicated CPU
> cores while sharing the underlying hardware resources.

Hi Cong,

Sorry for chime in here, and thanks for brining replicated-kernel back =
to the life.

I have some experience on original Popcorn Linux [1] [2], which seems to =
be the
root of most code in this series, please see my comments below.

>=20
> The multikernel architecture provides several key benefits:
> - Improved fault isolation between different workloads
> - Enhanced security through kernel-level separation

I=E2=80=99d agree with Stefen=E2=80=99s comments [3], an "isolation=E2=80=9D=
 solution is critical for adaptation
of multikernel OS, given that multi-tenant system is almost everywhere.

Also allowing other kernel to inject IPI without any restriction can =
impose DOS attack
risk.

> - Better resource utilization than traditional VM (KVM, Xen etc.)
> - Potential zero-down kernel update with KHO (Kernel Hand Over)
>=20
> Architecture Overview:
> The implementation leverages kexec infrastructure to load and manage
> multiple kernel images, with each kernel instance assigned to specific
> CPU cores. Inter-kernel communication is facilitated through a =
dedicated
> IPI framework that allows kernels to coordinate and share information
> when necessary.
>=20
> Key Components:
> 1. Enhanced kexec subsystem with dynamic kimage tracking
> 2. Generic IPI communication framework for inter-kernel messaging

I actually have concerns over inter-kernel communication. The origin =
Popcorn
IPI protocol, which seems to be inherited here, was designed as a =
prototype,
without much consideration on the ecosystem. It would be nice if we can =
reused
existing infra design for inter kernel communication.

I would suggest look into OpenAMP [4] and remoteproc subsystem in =
kernel. They
already have mature solutions on communication between different kernels =
over coherent
memory and mailboxes (rpmsg [5] co). They also defined ELF extensions to =
pass side band
information for other kernel images.=20

Linaro folks are also working on a new VirtIO transport called =
virtio-msg [6], [7], which is designed
with Linux-Linux hardware partitioning scenario in mind.

> 3. Architecture-specific CPU bootstrap mechanisms (only x86 so far)
> 4. Proc interface for monitoring loaded kernel instances
>=20
>=20

[=E2=80=A6]

Thanks
- Jiaxun

[1]: https://www.kernel.org/doc/ols/2014/ols2014-barbalace.pdf
[2]: https://sourceforge.net/projects/popcornlinux/
[3]: =
https://lore.kernel.org/all/CAM_iQpXnHr7WC6VN3WB-+=3DCZGF5pyfo9y9D4MCc_Wwg=
p29hBrw@mail.gmail.com/
[4]: https://www.openampproject.org/
[5]: https://docs.kernel.org/staging/rpmsg.html
[6]: https://linaro.atlassian.net/wiki/spaces/HVAC/overview
[7]: https://lwn.net/Articles/1031928/

>=20
>=20
> --
> 2.34.1


