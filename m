Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACA7CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0A16B00D5; Tue,  2 Jun 2026 06:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8C76B00D8; Tue,  2 Jun 2026 06:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDCD6B040C; Tue,  2 Jun 2026 06:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5FC6B00D5
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:23:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B08FC22FD
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:23:29 +0000 (UTC)
X-FDA: 84834585738.07.F532C1B
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1F7F816000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:23:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=xmission.com header.s=xmission header.b=PT1nwI4K;
	dmarc=pass (policy=none) header.from=xmission.com;
	spf=pass (imf08.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.232 as permitted sender) smtp.mailfrom=ebiederm@xmission.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOUWvgApIKw+92KT8RxRFcojdVTgW69lyiDjHGwti4Q=;
	b=jnTB4R3hyP5Nq2Lezh+aT6+xIE0JlSm68aHi1JEh4q6MCDIm2Gla5n1X/gg16H1IiIfeeN
	olpeYCBJGeQqMnfbsN8sntXL+ME9ISlcKTr36JgusfNTMGgo9YjWNTleqx6uSTqoYA3Mae
	yDCoGbyAiMhORHSVGzaiotKuvIeYz2I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=xmission.com header.s=xmission header.b=PT1nwI4K;
	dmarc=pass (policy=none) header.from=xmission.com;
	spf=pass (imf08.hostedemail.com: domain of ebiederm@xmission.com designates 166.70.13.232 as permitted sender) smtp.mailfrom=ebiederm@xmission.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395806;
	b=YObwR6VrcR7kXgs/PqayD7XqFpHiFSorvZbpOgaU2+3yxXtJJsUvShM1F99vH7QpXgmW4M
	mFYh/Xo27dxUI7eHQNIb4bLo9VkMlY+s1DGz6yV63nWFsdCxiUBdCXCuCnHOMZpBdti+gS
	uw4Uk35VoT/jxJY3qR4S3tMTtbKqZjM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/simple; d=xmission.com;
	 s=xmission; h=Subject:Content-Type:MIME-Version:Message-ID:Date:References:
	In-Reply-To:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vvILlsXaVQShutp1p5WceQi2Eaf3pB4ovG/S15HHsU4=; b=PT1nwI4K/LueK0DDSNL+s4C13J
	wCISW9cQ6Rku1p5e71v6LNcH9E8BpNOErgTq20OxsIi/JohdQWrgMebuwQrMKgen7pJXROs+AsRqv
	q/PDtUrCrIsMZAHrVRiLpwUsOkpysGxuDIlQz4e1uDX5u9eweqgYZDbb9a8545EZNJqI=;
Received: from in01.mta.xmission.com ([166.70.13.51]:57296)
	by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1wUMHI-00EQUk-Sf; Tue, 02 Jun 2026 04:23:20 -0600
Received: from ip72-198-198-28.om.om.cox.net ([72.198.198.28]:37600 helo=email.froward.int.ebiederm.org.xmission.com)
	by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1wUMHF-002RRp-JI; Tue, 02 Jun 2026 04:23:20 -0600
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Deepak Gupta <debug@rivosinc.com>,  Deepak Gupta via B4 Relay
 <devnull+debug.rivosinc.com@kernel.org>,  Thomas Gleixner
 <tglx@linutronix.de>,  Ingo Molnar <mingo@redhat.com>,  Borislav Petkov
 <bp@alien8.de>,  Dave Hansen <dave.hansen@linux.intel.com>,
  x86@kernel.org,  "H. Peter Anvin" <hpa@zytor.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>,
  Vlastimil Babka <vbabka@suse.cz>,  Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,  Paul Walmsley <paul.walmsley@sifive.com>,
  Palmer Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Conor Dooley <conor@kernel.org>,  Rob Herring <robh@kernel.org>,
  Krzysztof Kozlowski <krzk+dt@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,
  Christian Brauner <brauner@kernel.org>,  Peter Zijlstra
 <peterz@infradead.org>,  Oleg Nesterov <oleg@redhat.com>,  Kees Cook
 <kees@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,  Shuah Khan
 <shuah@kernel.org>,  Jann Horn <jannh@google.com>,  Conor Dooley
 <conor+dt@kernel.org>,  Miguel Ojeda <ojeda@kernel.org>,  Alex Gaynor
 <alex.gaynor@gmail.com>,  Boqun Feng <boqun.feng@gmail.com>,  Gary Guo
 <gary@garyguo.net>,  =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,  Andreas
 Hindborg <a.hindborg@kernel.org>,  Alice Ryhl <aliceryhl@google.com>,
  Trevor Gross <tmgross@umich.edu>,  Benno Lossin <lossin@kernel.org>,
  linux-kernel@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-mm@kvack.org,  linux-riscv@lists.infradead.org,
  devicetree@vger.kernel.org,  linux-arch@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  alistair.francis@wdc.com,  richard.henderson@linaro.org,
  jim.shu@sifive.com,  andybnac@gmail.com,  kito.cheng@sifive.com,
  charlie@rivosinc.com,  atishp@rivosinc.com,  evan@rivosinc.com,
  cleger@rivosinc.com,  alexghiti@rivosinc.com,  samitolvanen@google.com,
  broonie@kernel.org,  rick.p.edgecombe@intel.com,
  rust-for-linux@vger.kernel.org,  Zong Li <zong.li@sifive.com>
In-Reply-To: <87wlwif04z.fsf@igel.home> (Andreas Schwab's message of "Mon, 01
	Jun 2026 22:58:52 +0200")
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
	<20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com>
	<87jyslndo4.fsf@igel.home>
	<CAKC1njS=AHu6uHrH4ae8VxcdEbhgiPXYCAoN3F_mnppBd3SwOA@mail.gmail.com>
	<875x44o9hj.fsf@igel.home>
	<CAKC1njSn_rtCj8ii876PNQTk0nsCTfWsb4DzdymufHVthh1Rkg@mail.gmail.com>
	<871peqgp9v.fsf@igel.home>
	<CAKC1njR+dTdvp+BmLGPtgd8dufiUwBtkQ9a-qinELT_Fmi13sQ@mail.gmail.com>
	<87wlwif04z.fsf@igel.home>
Date: Tue, 02 Jun 2026 05:23:10 -0500
Message-ID: <87tsrli6lt.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1wUMHF-002RRp-JI;;;mid=<87tsrli6lt.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=72.198.198.28;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX19J6tpF2AGRJ9xglxGPNzSSZeVg13KZsgY=
Subject: Re: [PATCH v23 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ
 | VM_WRITE
X-SA-Exim-Connect-IP: 166.70.13.51
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 512 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out02.mta.xmission.com); SAEximRunCond expanded to false
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 3y8qw78cnf1mst1e8bz8ou3ue5ahjyds
X-Rspamd-Queue-Id: 1F7F816000D
X-HE-Tag: 1780395805-229902
X-HE-Meta: U2FsdGVkX197wBLerMrXM21/D9nk50GVZAIeVKap+wVaJhXg/tFF59B2q2HAO+/tSkQtqZa3Mb9vTLWE2ZI012wyGizQHCbYDT9xvchsUgb5bbcgdkVvc8Z+uNJHedQZzQ06Ji4c0915fYmzh21RR3cDD6WgckoO9t1uVk09xkodEp2/eAmc/GvJnjYhMph1kdw0pH6oT9eixf7UA9o7VRTUjDe+o++1PtPuv80bBZnI10dgvre/CRdQDt7bI636ddhbd5gh+kbt0KgJBx0+xG6ze4u/htK13mDwJfTr9wXyZcSkAwjpp3mEQd1nJi91xqY2uti1mjr+MgEElju4uXWShRl7bB91hjAfa4MlspkZ9S0fRZ4bkYNTYMGLz6HMU+otZsW+pUrPotlWg1o9tnqpB4FJsnaj/QRDEncoCzwQb7D/jyCb9EoEf1XNlwRKur5jVgi9Tnh5PUvBhCLrJ830jasBX26kevJ8wf+Q1OB6bIfxeiEgzILpsRHD/3SSza4sH/pmmKI33IbSQB6bSCh/oDLGbVNCUhmanJq5Drjqm2CH3/jq9fp7wSZ6DFyjR76/Rj3J6e57UK8Japfo3VCe4wLLHAC3Ydn0ILeKW0GIjkfKZyNpAk2Cgp6K++ZxMcddSyXPj/XOFrPSGCiAjY+usMo/V2Jzp6CLbV9y4Kj9L03bzod5yLYRaUJqboYMbEFf9wUNA56k3FReyaYUKnhzuhZaYqffUW5Cz2Egjy5kMEFEcnJXPNuLWfKmN1ds6RgBJ1sEs2cN61FU3M7BTW5uqLdfLJkineDH8WEkx8sUP0YLAncrBBrOVNi1rUExsXEqmaJ2JVhcqoIIB2sUiOX0DR5kgqT1MA34/V2yy7Diy2r5rwfJYV+jLG2pFRmB/wb3Sce6O5AHtx2qL0vFsS4Nifvl0PcsMGe6FcBaJNIOKWdU5//YlLAWgt8wHK1Jk5WN8stUqvGwuc31/pb
 kMdgzcej
 g3iBX/Wc2uWNq/4I0qibdpeVndlQYfTKkTuA60qkGVCfaAF/oq6Vbf2MBIpg/G+G7qFaA4lBWyBGpsVUIJTx6XWUj8bhE2zW9ECIKvahwANuIBfKeKphoAP4jjSMk/Uv+Qx/rZppq276d+el5O20Oo+qWAMqfzuXDj2V7+wGfDU3nb+igClNPIxjD+WUCTI/dJAumOmGrhggasnZdKk40EwO8V8ZaZA0wTKGvH/kdUNlXexFJgWiVvFmov/Z6s3lwHq+fMnUAacHLa5EDukB6siON38IMIwqD2ObLIaEV4YH1Y7Exgwk572nXuSyr+LGUvA2y7ECQxYAqSVAlRGEuTPm/XmWCsgqpmVI/Dk4sSFBBzf/jm22RO40kfDinmlNH4Yyg+G8H/xe+gigdCt0eQrVb8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andreas Schwab <schwab@linux-m68k.org> writes:

> On Jun 01 2026, Deepak Gupta wrote:
>
>> riscv uses `VM_SHADOW_STACK`. It's just very simple to use `protection_map`
>> with just `VM_WRITE`. On RISC-V, `-W-` is a shadow stack mapping. It's not same
>> on x86 or arm64. So `protection_map[VM_WRITE]` simply picks shadow stack
>> encoding. We just ensure that PROT_WRITE is converted to
>> "VM_READ | VM_WRITE" at vma level.
>
> That does not explain _why_ you need to make that user visible change,
> when others can get away without it.

Especially since as I recall the decision was made was that the user
visible protection bits would match the mmap call.  If there is some
combination an architecture does not support that would simply not be
reflected in hardware until some future version of the hardware gets
around to supporting it.

This is what happened with executable page permissions on x86 for
example.  It used to be that it was not possible to deny execute
permission on a readable page.  Later that proved sufficiently valuable
that support for denying execute permission was added to the hardware.

That all happened quite transparently to userspace, that wasn't trying
to assuming PROT_READ implied PROT_EXEC.

So I am at a complete loss why someone would choose to break userspace
by confusing hardware limitations with what userspace asks for in mmap.

Eric


