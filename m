Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A3F5F9D0EF
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 18:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2146B0088; Tue, 14 Apr 2026 14:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6733A6B0089; Tue, 14 Apr 2026 14:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5618E6B0092; Tue, 14 Apr 2026 14:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 413526B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:42:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E058C12C4
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 18:42:02 +0000 (UTC)
X-FDA: 84658030884.05.1AF7F8B
Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 233BC140019
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 18:41:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=LJlMRDg+;
	dmarc=pass (policy=reject) header.from=bootlin.com;
	spf=pass (imf23.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776192120; a=rsa-sha256;
	cv=none;
	b=mANVxBf6Qkl23u8yEQpTvLWgg2pHoGqip2OqiPg600/fb55j5LcKfAbnKs5nsjYtu8A5Ok
	qbeepZo2PpPPt5qhSdXeikdxZeqB5kfxbNlCPvCQ6hvroKrxLcxICXqmMVoZALN/7REP/q
	XfVYzYUauIOUTAHCoodhaTGG9YL5Ijg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=LJlMRDg+;
	dmarc=pass (policy=reject) header.from=bootlin.com;
	spf=pass (imf23.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776192120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIr13OXyvqQI13ILw4f4y0L0essgxoSoxIUr/ZMmVb4=;
	b=yUAIr8spiEKjuwShhf2D5DdYU44E/0+HPv8RfWKxcDcti7Ge84aKnyW78j34blfmfH5rYM
	e4zP0Smkdwmxz32XiwQZHqo67fnSCQLuwVoR1YDCBiQZoE7ttKiIi+QDLbeW4BEvdbpf1c
	UO3ldwWNn89tsZLCqC8cBpvR7rr/A34=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id D2FAB1A329E;
	Tue, 14 Apr 2026 18:41:57 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 9A0AB60410;
	Tue, 14 Apr 2026 18:41:57 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E8DF710451333;
	Tue, 14 Apr 2026 20:41:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776192115; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=PIr13OXyvqQI13ILw4f4y0L0essgxoSoxIUr/ZMmVb4=;
	b=LJlMRDg+IR59Wd/DECLqU70wLASm1Z510eZOEYERg65QVMD7HevQcKcFSFn4ExyLIN9Wcu
	eZPRoEPIMbNNyEhW6ixrnG0gP6QRyaA64iP3a4hxRrbhU/QWuTCH4aZ36RE+uK8FYkyljL
	QUiKvI64VGrTMaDSQRwQ6Ot3AorBs1Y5UNJBo0jNrCvmEasqN+jIVXValz6c8fRSFOmKfs
	XAO75NGEjOi4zCGbhKMOvpz1fZ6pOrJyAVLNyiELzgr5CNVU14ocpDTafsWCkxnjHktiJr
	Q77KcdFV9qwJPOElw6PEmuEU5ULPjUTGDVeUrl1tC4ffCCtjAg2sugdc6CutDw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Apr 2026 20:41:42 +0200
Message-Id: <DHT3JV7GTOBL.29205LGGNEDSH@bootlin.com>
Subject: Re: [PATCH RFC bpf-next 1/8] kasan: expose generic kasan helpers
Cc: "Andrey Konovalov" <andreyknvl@gmail.com>, "Alexei Starovoitov"
 <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii
 Nakryiko" <andrii@kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>,
 "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Song Liu" <song@kernel.org>, "Yonghong Song"
 <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>, "John Fastabend"
 <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, "David
 Ahern" <dsahern@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "X86 ML" <x86@kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, "Shuah Khan" <shuah@kernel.org>, "Maxime Coquelin"
 <mcoquelin.stm32@gmail.com>, "Alexandre Torgue"
 <alexandre.torgue@foss.st.com>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Alexander Potapenko" <glider@google.com>, "Dmitry Vyukov"
 <dvyukov@google.com>, "Vincenzo Frascino" <vincenzo.frascino@arm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, <ebpf@linuxfoundation.org>,
 "Bastien Curutchet" <bastien.curutchet@bootlin.com>, "Thomas Petazzoni"
 <thomas.petazzoni@bootlin.com>, "Xu Kuohai" <xukuohai@huawei.com>, "bpf"
 <bpf@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>, "Network
 Development" <netdev@vger.kernel.org>, "open list:KERNEL SELFTEST
 FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 <linux-stm32@st-md-mailman.stormreply.com>, "linux-arm-kernel"
 <linux-arm-kernel@lists.infradead.org>, "kasan-dev"
 <kasan-dev@googlegroups.com>, "linux-mm" <linux-mm@kvack.org>
From: =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
To: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
 =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <20260413-kasan-v1-1-1a5831230821@bootlin.com>
 <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com>
 <DHSWK17EZUDP.GIJ6BX2NFR6U@bootlin.com>
 <CAADnVQLJ=fJ7t1i2+_RYqU1gqYqiLP9Zrwo4vdZsgzjK_yzJTQ@mail.gmail.com>
In-Reply-To: <CAADnVQLJ=fJ7t1i2+_RYqU1gqYqiLP9Zrwo4vdZsgzjK_yzJTQ@mail.gmail.com>
X-Last-TLS-Session-Version: TLSv1.3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 233BC140019
X-Stat-Signature: zzzr3qm8zdjuxaxm33rup16t3u4yo8fw
X-Rspam-User: 
X-HE-Tag: 1776192119-735428
X-HE-Meta: U2FsdGVkX18S1zfTshSO8sga1hqPHtFRMKoyuxcOAEbIcDmJPNZG21ilW1aCZTXIinqF6nf24bUJzYlG41MUqCxYea3zdlXNwdS/B7Wmr8GkM9kp92chS2MeSzaPHf4s9kP/SxmjrkfPpI2ps179/k9pDk+9SmBGyCr0KR29Mq1yRLH7/Y+3yInMvGnoVraisx7gm0cpMbXfuK4ZcFesymFBqqQPm4AuhFOsASLrzrKwx37I/I53OGnRZ50smbib3akxwdTKzKYpPsBSTZuihBGWeSVZfIxAnXOKYEASOMAlzomhuZGePTLC/DQXwKaor3DAIBanDDf9Svx45kvDJSn2BeXBrv3yCoH42gB3g1i4613okSj+rmlqhnYF5MSy3oBTbPOY9B3DXSGnCp8gsgfLP+G2hB2GiDSXjQebuqpnojLs70fFaTAOkLFlts6khAyzN/PEkUzdrlpARcl1phmKfxeQ0mtLvWkGbhSupYjnygs72h403SYFZOL38XuRqNRKBztoxzivAPAmfmYSDqiXdZ4owLOPeQvMKp/gg/dP4WwT3fA8AXwdz9RkPslwM0DN5v/edZiki71lxOh7ElM61p0kT/5nvICOqUHkyn/eHnLuildfDC5BLCD8xt5jkHZfEh8BC/WzVHLDwTD+GxEMRqSayIHyQCxpFRteR3xTLiM61DaUib/WvppMNSZMTojUyZd6b7S0cwrXBB2/jP4qyRdhfTl1tuTFmOXpkndBrlVxnXq1NR5cDklycV5t7fjmGpX+bSH8Bt3ipCqqRIj9cXXGoJ0Bd/qCrqKtuDWB2Puu3Gwzj/Gqrm8uWdXk6rFYiXlTabdhRJee2ljeVTIJLvBBdOn0phq2mELIB1OVDOdvgnHj96HYEb/ysF82BuCHoQE+sPMSl+YODY2VUOXfNQ+PF0M3RCWKIwOaykwF5cDSH372X235lPCVhBERnhvW/vZLyT1Qc7XD6Yk
 ljtTrN83
 SWFn6Z7crUdvLYQJ/rL95W06d/AFU7cKiOcOuD+WqPosVxRvzrMppnbJDSu3PBLxS0z1zUxIud5e0Xu7w7E3NG5gCuucuxTudISQEECXVtKcU6nTdDbRXUaPiqM2dGYyKzFPxn1qG0tvI3SDB5L6mkLstn6hRO2RenGlJ7PdiBbUMPvsOoup3aajWwWAyPiQaP/6aI+G1rJxnUy2jIA9VhQELcbW/5KzR3IV7x27BlZbT0BlB9MLhgnai0BwfPFMIobqt1cVX7I0nNRV4ObwvQtXtlpxXCBMDPhkJqUSlVh/xLtHk7vMfc380+Re7h5+Fz7L4iNDIHdKUSc6UcmTKhOpNY77yAnbTaQWxLlzvrY2FZSX86RGZKItphINaEvDJAT1k4DUrmL0VokBoilH88OmZEM0/cKAxKwfxI5wheK/LuIesGZZyCZf+9EVgxMIL/v2Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Apr 14, 2026 at 4:36 PM CEST, Alexei Starovoitov wrote:
> On Tue, Apr 14, 2026 at 6:13=E2=80=AFAM Alexis Lothor=C3=A9
> <alexis.lothore@bootlin.com> wrote:
>>
>> Hi Andrey, thanks for the prompt review !
>>
>> On Tue Apr 14, 2026 at 12:19 AM CEST, Andrey Konovalov wrote:
>> > On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF Foun=
dation)
>> > <alexis.lothore@bootlin.com> wrote:
>> >>
>>
>> [...]
>>
>> >> +#ifdef CONFIG_KASAN_GENERIC
>> >> +void __asan_load1(void *p);
>> >> +void __asan_store1(void *p);
>> >> +void __asan_load2(void *p);
>> >> +void __asan_store2(void *p);
>> >> +void __asan_load4(void *p);
>> >> +void __asan_store4(void *p);
>> >> +void __asan_load8(void *p);
>> >> +void __asan_store8(void *p);
>> >> +void __asan_load16(void *p);
>> >> +void __asan_store16(void *p);
>> >> +#endif /* CONFIG_KASAN_GENERIC */
>> >
>> > This looks ugly, let's not do this unless it's really required.
>> >
>> > You can just use kasan_check_read/write() instead - these are public
>> > wrappers around the same shadow memory checking functions. And they
>> > also work with the SW_TAGS mode, in case the BPF would want to use
>> > that mode at some point. (For HW_TAGS, we only have kasan_check_byte()
>> > that checks a single byte, but it can be extended in the future if
>> > required to be used by BPF.)
>>
>> ACK, I'll try to use those kasan_check_read and kasan_check_write rather
>> than __asan_{load,store}X.
>
> No. The performance penalty will be too high.

Since we are mentioning it, I did not consider yet any performance
comparision/benchmarking (and I am not really familiar with usual bpf
performance validation practices for new bpf features). Is there any
existing test I should take a look at for this ? Maybe some specific
benches in tools/testing/selftests/bpf/bench ?=20

> hw_tags won't work without corresponding JIT work.
> I see no point sacrificing performance for aesthetics.
> __asan_load/storeX is what compilers emit.
> In that sense JIT is a compiler it should emit exactly the same.




--=20
Alexis Lothor=C3=A9, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


