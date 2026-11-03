Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49D2606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 13:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=UY8T4xQg;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=wMMh74qP
Received: by kanga.kvack.org (Postfix)
	id E88A76B00EF; Tue,  3 Nov 2026 08:14:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E327D6B05B1; Tue,  3 Nov 2026 08:14:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22436B05B2; Tue,  3 Nov 2026 08:14:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AADD76B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:14:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43846A7F7A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:14:00 +0000 (UTC)
X-FDA: 85393850640.07.D58D048
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0B354100002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:13:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=UY8T4xQg;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="w MMh74q";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793711638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Uut5mkWx/3NAEsIwT1QlJR3fVGQS9QLbsjW5+7LTfQ=;
	b=mdw3uMM2YTRLDEu/KLCABo6FfOpdnHqEGgt1CRs61jMBqPBt+7dlEvE5L+i5QwBlmtH9BS
	FCMmD2EWjWJtQMt8/0aOzcWVUWHVRgfJ3kjfg822RKRV19GqXvvdv1IatOEmTViBlZR0YE
	yltWWqRoKLphMkKBIQ9rt8oPqHBKBfs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=UY8T4xQg;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="w MMh74q";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793711638;
	b=PR9mSrA9RZSrTXoTVPS59pFre1Rfqz1PiqgySt5zG+ZaaACTVgRqBHQ+lc4ME3MyCZXk54
	SZm5f8xoKqM8+Fk9JTzk9vazD3MeNDShju5Cp27olifVfMFLHz+9cIuWVYEh5MNxn3atlG
	4I6VkML4fTQ8TRvH6ps8GxqyZZHA+Nk=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id 28DCE1380651
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:13:57 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 03 Nov 2026 08:13:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793711624;
	 x=1793718824; bh=7Uut5mkWx/3NAEsIwT1QlJR3fVGQS9QLbsjW5+7LTfQ=; b=
	UY8T4xQgsrtJHlSlsbPCFv49Fu6y3+FNDxITfYYQ7oFaKnUROsQyQlppAvx5Y0qA
	2x1bZ9/062t/g7C/EnhxN2/QHCAmK+8LOotk3BYlnhzVgCy18UkSijt+gdV/7653
	3WFgQkvGceaQo7nCCVOGKzJLr3vhXH2LpsG3OY7E1MADcfZ9EJuofwR5bjp93LlP
	T6NwTkb0M5yVs1x+I6hmuzaw/AHkHnmgmHJzpl0ZskNqGfTBrDjfB8ptknRb4dap
	pJJ3GEICH6SRqhDCFtoQlgfcLrXkizgdfbr5wCUJV0ASNwpmx85jRYwb6MAO8qsb
	ntW0bArCpY4mbE4XHoPVAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793711624; x=
	1793718824; bh=7Uut5mkWx/3NAEsIwT1QlJR3fVGQS9QLbsjW5+7LTfQ=; b=w
	MMh74qPs1ZQgSr8/Td6zE+4gffcP1WdDsVta0Pl8vm92ZzzvvtTGJWedy/vM84R9
	/6PW1d7z/ME/7mWH6E00fELlb3PSJAdINWHU6fNqhkgI3bjnTo3No8nrt9EftFwf
	jKRvvHRfPpgb0HWg4K7leXmS3t0Y/rxlVk5kyjA5DczwT1MI+3EumsbHcgLiqj7e
	NrjLiRZYEURYA9QQzojhpZSvqkADSIBzSyISIrz4VRI/RXLg/9U5Xs2rBvEe0h1Z
	TXUwfrfZhGhOQZOvOEp5zjEdK+VjnLRoG4ujhDbe0Khlsr1MaDLr55/X94wJPw+/
	UejOH4ejUMw4NRktjE/Kw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793711624; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:QW8OjXGyPQ7nOkM2NlkaYlFSbdyNrCcQdflcX97TGSDLrE+
	E9RQkxEc8I00ZNfRP6eq0C5lvqS631hztt2n57xu8DsCi9BW/U4j1+2XSlDLzSH6
	IOAlaBYsfn+rI0bE0bx6Y3LSxN6YOEeO5WHc9ez0qWa3/dnL57M/dENnLz1SsB4H
	iwxpuktfCdAMoOEvWN5neMiqyeBZ9PdCD4iYMSgIncXrm250DHkLoBp6JinDv6Hq
	VQwVCbQrXoLFXHUw706D7vYt5oxfR/PY89aAtkEii8Ndk0jAMUTKNg0reavELtvp
	5r+t47fsMHefatdOqNXIZMljdyB9bddhojj6jkw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:UaizHl8egV/jrsixzSKLvKmdYvF4WtLCEGHA2kA3WkA=:zsolxs/hYbTrgyUK5mu6bC3loibRPhiWpdnp7Gh6Bz8=;
X-ME-Sender: <xms:-t3pamZn16O-F_dCjy0ATtHl3Rtsq3MeYosBdQT67QxXwoYiHJXcog>
    <xme:-t3pakN-M-t9UEqkehjusToniKsKaXk6s2EhWR4AnnIMSgzVxXSNj6DhYs__UNJEo
    ywpdK-tMkPZiqbmmhrKHKc9P-lrmDI3oOsUWQqov8biAoxOHk-oAn0>
X-ME-Proxy-Cause: dmFkZTE2L5a2p4A+UM6tRErQyKhPf0hJbRZZS3ULmbWFkCsy4zWWH2d08vZGKaEXzdKsY/
    OsKn0nkWj+LbsldmJ7mi6ZuoRi1WXwrCH7ZfDtHQZELafiVeD0qb1LvtRbrz6KtbNgiQ1d
    RRpQr8EhZHLXYQviRoKDmAS37qn041Q1n/dhGWRVclQQtMqcN8DjvxGXREFVU54e9IXKPG
    v/AEsdpvs7fhjVbViR/7hLy+moJ1RBCk56A6MloCwcof46fueMWMAA1FnxSX+Q2tQQrZTw
    gXJCfUEsID2E0jl3K+93j5O7z4KdF+nFKNIERbBBZt0KfkX1tYkYh07nWId2skS3AItFMW
    t0iukAVhIQd2ezU59xjYBhM5rUoCc+FdcZ7QOQ5aTQmyGjL/5hq7Wf0sAkG604j+2Z0a8T
    AiuiYneFWbPqR8ATufo1nFvBeezDBuMRpAUNEAQL1vuYeuL3QRN4a8o5neRS38LocSqAsk
    Stko79x6V9eUSevs+vfuiL+DAQWjWLK3BWYAtbKduRlT0Xxd6Vp2dW4+gfgZ4yRiMlLT43
    Eal/lj4sJLRFjZMmYw0S0Xb5YhkLf1q8apMh/4pRvVfZX5X2TouH+BMdNKEnHn08sXNesD
    JqO0NZRg3uBTqB4IZNSxf77ypOex0U96ZRlHD4nI17i/n6a6l7toXjwujyug
X-ME-Proxy: <xmx:AN7papP24kpc6s3jFYukNxjo65OEBVZ8v3fLlTygEn0DOCwXbBPOnw>
    <xmx:AN7pagYdjOm7CgSfQ3KLvqc_3hsynblm-FVse0Ub6AFh0oTC32Snzg>
    <xmx:AN7pajnUfCREr3qJmgREmVqjpV1wC2oVA88gl-jrSG0RchD7zw2CCg>
    <xmx:AN7pajA-AqUkF6H3U1HD62vvcX2UU2tFo-l4hxcdjiI67Kz1xAvJ2Q>
    <xmx:CN7pairgqP9A3xKBMGRViOFSYS7aO2otc__GwQlHgGJFDOVVfMbc4HnC>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 4983432A0097; Tue,  3 Nov 2026 08:13:30 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AHCvEt5753PB
Date: Tue, 03 Nov 2026 14:13:10 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Sasha Levin" <sashal@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>
Cc: "kernel test robot" <yi1.lai@intel.com>, oe-lkp@lists.linux.dev,
 "kernel test robot" <lkp@intel.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Kirill A. Shutemov" <kas@kernel.org>, "Finn Thain" <fthain@linux-m68k.org>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Ard Biesheuvel" <ardb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
 "Alexei Starovoitov" <ast@kernel.org>, "Andrii Nakryiko" <andrii@kernel.org>,
 "Boqun Feng" <boqun.feng@gmail.com>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "Dinh Nguyen" <dinguyen@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, guoren <guoren@kernel.org>,
 "Hao Luo" <haoluo@google.com>, "Jiri Olsa" <jolsa@kernel.org>,
 "John Fastabend" <john.fastabend@gmail.com>,
 "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>,
 "Jonas Bonn" <jonas@southpole.se>, "KP Singh" <kpsingh@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>,
 "Martin KaFai Lau" <martin.lau@linux.dev>, "Rich Felker" <dalias@libc.org>,
 "Song Liu" <song@kernel.org>, "Stafford Horne" <shorne@gmail.com>,
 "Stanislav Fomichev" <sdf@fomichev.me>,
 "Stefan Kristiansson" <stefan.kristiansson@saunalahti.fi>,
 "Will Deacon" <will@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>,
 "Yoshinori Sato" <ysato@users.sourceforge.jp>
Message-Id: <e69e6690-cfc0-4ea8-83e1-5ad2d98b84d5@app.fastmail.com>
In-Reply-To: <20261103123508.3910990-1-sashal@kernel.org>
References: <202611022259.def3e086-lkp@intel.com>
 <20261103122647.GL1813469@noisy.programming.kicks-ass.net>
 <20261103123508.3910990-1-sashal@kernel.org>
Subject: Re: [linus:master] [atomic] 80047d84ee:
 WARNING:at_include/linux/instrumented.h:#__split_huge_pmd_locked
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0B354100002
X-Stat-Signature: zk9ckkq7s6pcg3o7dq47xy59i6x5dm3x
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793711637-556191
X-HE-Meta: U2FsdGVkX1+HlRdl99iHxGALRkXOEwadHDcFjvYin6kA8vGHh0g2Np0pbQO/HD+5MoJvtYR7umZxbYXhgSH1zbcsIlcR+M94wKG2jk/10DTMqsMoXBok2n2/u3mPEZCxbcGhyOIdbGCwD2QDuLYfAosWJzSPCRTFXNvagH4nDX49zPgvCbl8GHHVOekDfwmqmCoBLymvdMu/wdFqTwXQ4yCM6PdyXaP1GNZyyAAZ3NVguSYM/CbYeLRTX6ob56c6pqMJdSGU2Tq2BdpjDu6xleTnPYKG7qzH9cVeeJH+6wIj1P4XY+JzMA+5Ys6D7CbygfxWfDBLGUU6epNZaI2W9PolGiueDv3I9jsZWTjdW7TeMFklSyFFRYC2nUUCOnz9RadDXW7gvuSVqU1C1CKab7Gf/xdz8QLWM386SlX0cUlIHSSczYKVcflq0UoLpnYkEJ/BxtXDTGK1gmo2g4DXi0nDgQkMI2KZYacnHjCL9iUmpIhYl/DdaYYmwFU+bUxHJ2HoU/JsxhWE9xAjqj1QxWClqvcs7sySL8q6y13IQgOz4VbDDVIzqILdTthZoZP4dEdryl0q9w8hQE6ui4cvH2Ho5kBRTknnPsClvej+W5xhbgTTkSPp4tloKLggqdSYZIyzIvcX4xCwDjcCP6TO2EaKOjgNsrXFpTfQvhfOzRulIGx/osaL1zNV93XC0VPEegWDZesNx6Q2mHblfDHWoxdMzmm4G1AsqCS3hrHjTt1dz5F85SMg0hInYSExZeoNft08TydhisMJZGbcewleeq7QmliujYQJ55yBGUClJ88aebYhFkJUGgxd/7nusZ+ZlrvlnHxnL9fXW8bMD74o7V+U0f6QTV6p9FoY7d2EZDrla0LTMdSH2etJta7yjSRL48EG9y1TgmkpVr1aAGGxmpgOOqhdCHYoP5logLHM4OD06itvzwnjI9UekLAt7O/xQFYRRsRAhny3aJ2PjEq
 zJIRczrT
 3oe1vZ2XyMSqJ/WEjkN9ryBUtZxPEYyhjtGwJjVEjnhkflD2XHEhl7ujw/Q2l6nKTMBdywVuFU1/OBPIvgQkNXixJLcKnJIpqW/+jKKRUJnTeAoMmRS0OHSoHIn2qXkFhtMcOvVWqaKSiXFuoxrAPvzo926pPn2PtO7KUx9aRQAc5zd5URKNs9wDcQrUGm6jB0yvhYw5TMstUBq0gtv4UzQAKMgncD92OqXGnXizIaqY/WQgvUcoT2os0dEb6ILg/e4m+LKnp/Qc2L/hb4WNd/Tlt3bU9aTjmfyrz1GQUkEX9N+gAT/hKfz8i60JHrvoLjRtaFhMVmRmiqLK1WQEuYDujZ1DutI8+HBrOGKUOjZK7wPGt9RpRUbxXEwYRKrE73/mniGXLZliUTPDJxLwxAdvUqFd3+9yvq/3Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026, at 13:35, Sasha Levin wrote:
>
> I tried the typedef change. It works, but gcc ends up realigning the
> stack in a lot of pte/pmd code (126 more functions with Arnd's version
> in a small config, 204 with yours), including handle_mm_fault(). Just
> aligning the two locals seems simpler:

The question is how many of the other functions may be affected by the
same bug. I see a variation of the same code in vmemmap_split_pmd(),
and aligning the types is clearly the safer option here, especially
given that most 32-bit architectures already align u64 all the time
the same way that 64-bit ones do.

     Arnd

