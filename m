Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45F4606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 13:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=KkN/+8PM;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gsz0dw+7
Received: by kanga.kvack.org (Postfix)
	id C45326B05B2; Tue,  3 Nov 2026 08:42:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCED36B05B3; Tue,  3 Nov 2026 08:42:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70146B05B5; Tue,  3 Nov 2026 08:42:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 793DA6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:42:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECBEF40436
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:42:22 +0000 (UTC)
X-FDA: 85393922124.04.84CDEE1
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf06.hostedemail.com (Postfix) with ESMTP id BB15518000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:42:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b="KkN/+8PM";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="g sz0dw+";
	spf=pass (imf06.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793713340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6BsRfaEgIRLQQWK6sElJj2ULb7RxiZTRv6a00pf8q4=;
	b=XoqmW9DRLkEC16lGBDFWnsXuaxo6uqMtFyJO+QtFig9mTJsDa3qoQkmwPghBOQBTTlGLDj
	ef1skBK84TRsd1F95PKrFeNZPwYyVM2V31n7LMjfxQEDsI09U+to6+kr4//rN+hIs7AnRp
	RbdmlrijCyxYUy98xYoSAa2mllVBIiY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793713340;
	b=NFInWae1nFHS5Cn4he1gy9dTiTUU7fvcmQ2cHYCuHXSB4n4gww46X5n76+9W0fEsbbIQwE
	lJY0qhdjSh+Idk+j2oW2R6C8tNG2uPutBDg/vGVgA1AAChNpxbvialghBqJtsOnjJADxT3
	vMO9b2vIThfBghagGbZ8/MvEdNbj/0o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b="KkN/+8PM";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="g sz0dw+";
	spf=pass (imf06.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id 19E0613807C4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:42:20 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 03 Nov 2026 08:42:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793713327;
	 x=1793720527; bh=C6BsRfaEgIRLQQWK6sElJj2ULb7RxiZTRv6a00pf8q4=; b=
	KkN/+8PMCJmN9+oJDv1PT2v8YZWiIx0HgEHZi/kgNA/HhDba5WP1BuWQNOZOURbV
	Hrj/ZLB5gspp7ptXLCWd2/lcTCZvqc/UiLbYblYrtfSBf+oSCoLS9Yt3LCf1ulBj
	lg1TYfpqS16gvfgfu4EHr85s4ixt1DDrbKFtPydgVIzB9cPvJ5BmeNYM3yNu9Z0n
	FAXefH0FFZUkBX8NR+6WOj4j3rloPScdno3dG1HXBGsIv/fnPE3Kz/SGuwq3NtTI
	dudCN7ANM/SRMQf6LVw2OntByOGKb8K3+NWBsyIZjE0fc1ImLBgPxjPKGQopgLDz
	ruitXt5rpbx7Tq5bSgwmUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793713327; x=
	1793720527; bh=C6BsRfaEgIRLQQWK6sElJj2ULb7RxiZTRv6a00pf8q4=; b=g
	sz0dw+77oExHBK39kaNw32WrtTlwOJhqphNMVRGuWcrVG3KBO7SUns78QvkvuR1U
	ovHSscfd8k54mBoeP2/T1l1J0pfxstu/JooCt1G1kXyu6s6J5TU8AxiTdQ3pztNo
	1i83BBorBn5uaYx5ieRd3kmTsaIIqEDwSBmqZCXK479b2CQBdsSEVgAuXEhtj06g
	f2xYXuraOvh+cMnFS+sOgVd8XZ+DN493zKM1YLf2pr4N61dfphFj15e8MHu2eCcD
	er7TAc1AvgPhPTdWRzFFJc6ya0hvsc8C5ZOySQBplVAwy7Mlf3/XoaT+Yax0/SSF
	OB5b7Wc9BHM4pI2uH/4+g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793713327; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:Hv+CKh9TWqI44gJcIUYYDQc8HGV55s5m8i2rD4TY2axvEWn
	XPc5CPyrvN5gXGVhXkdVYh9MNBX1RW4SRAiC7F16u6Ar3x/mwr3E35VGLpfI9cVK
	JGQTfsgjzvRT2Xxus7yrLogk38Qm/nJAZvKJoe/quH99Ij0jddS6DyYosELppLUw
	ZkydAXl9LqWVMI7+QH5DckF67jhEoZiEhj/qzVF4IHc3SxRAMD6VLU77j754RXoi
	G6tOQYFQzGKV+H0Bh1/JeM3ncVrGeqSyj4ihrJUo1LZk7RrGLTkclQfeSIOte9x4
	JGRASHKcu+laTiGLwUTy+BciqBR/9Qs65e+u/ag==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:6lfwly49jdk/TRQzQzohVpgwjHD/wkTSstU+gGerY1o=:h/NM9bjvMaJEdmp3okr+dW8dFy0qHLVaOWeZgTL04zo=;
X-ME-Sender: <xms:oeTpatWZDpRRNZMWjhAskAQCMLqYvau0PUyGwPOYFLY0pY6Y9njaiQ>
    <xme:oeTpaoaxV4qoKNi5Ha6QuCd6u5HJZEERfSmA_tlbmn0FuwbNeMxgM4D80-yFTbUaX
    1cbqN1e5bOFSx23ABc5q4LlDVGSq1-KR4WsXI6AIE_4tL5z2z-EtEx7>
X-ME-Proxy-Cause: dmFkZTEA4KzNuwOsua5pffRMjkBOk8wzkxvQ/2CpeYBWTRKldBKNhQCsSJE8Uh9dEQ0Ef0
    GZHbXMgWrOiuBvBaWlxEbzf5C4JmAB81c5UxCXTIHaP/8pbXByeVsb/te6GpmqZXZlblAg
    cKGjztPo3uHjg+8wCId1LCLEttpHXAcoPDOOz/66xY7x28JRQSuiF2Kqea58r7ttfq13S3
    vy/rynGbxesfWoFi0HCPVVWm9XxX9JVLVWEhx/hoN7T4hNR+A0wUjV33nFR6E5KwtUgHee
    5HY5ePjyfCf2olwovw2KYth+I2fo+vLeN24GLXo3DbsdCMBSrrFPTbK5R3zN8lQ3nGBVRD
    7A4WcGepoqTPXzuv6+agcCPg7oTJe9F+HWtlF7Z4ISIU5FI04YMIQrBBNBu3NmBVQwwxeh
    kJlxgwLuCEvccGYTJOZI3KhHXSQfZ7r4qm8sFi73x/cP4J5H5gKnM2iNKfhWsNh3IDTvxP
    YKkWDuvUXsg9aFQEUPRjj6Ks8b1xBqLIr2L56C3vMDoJ3IEwEtMX5enoas8JQFqZDr+yL4
    yPtrobI2V9uesTkvFL1E3x0YPCUwvluj3uzHDLrERF0ZNYro2piN6RGU0NvkoUFSPSftdN
    rB8URlSfV0C2tKh9aRLdepIKneucn81ERHwkoQmItOqAMOOnShSiRfl/ESBQ
X-ME-Proxy: <xmx:p-TpampxcJCb0YP76X94qK88tf_J79dTHp214itTmMD_LbR71BcL0A>
    <xmx:p-TpapGUWlOsHG7W7wuO7uNqAusEcz8_mP2VgpOYxjzS8xfhgmVa1A>
    <xmx:p-Tpamic8G5a7o4akCQHtMOCub9DetJVBRrpWGFMVhanMfwGsFu4sA>
    <xmx:p-TpajO0fKvscWeKk5uMiINqSqzFYwLlqKRDd6c50uDQ5K5IY-z27g>
    <xmx:r-TpanHhEjtwrLSxgMyCywLuGWEPXQp6v4HPDY2KlB8m2jguXX7K5daW>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 31DC432A0097; Tue,  3 Nov 2026 08:41:53 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AHCvEt5753PB
Date: Tue, 03 Nov 2026 14:41:32 +0100
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
Message-Id: <846703eb-111c-4376-a0ba-36bd3e13f632@app.fastmail.com>
In-Reply-To: <e69e6690-cfc0-4ea8-83e1-5ad2d98b84d5@app.fastmail.com>
References: <202611022259.def3e086-lkp@intel.com>
 <20261103122647.GL1813469@noisy.programming.kicks-ass.net>
 <20261103123508.3910990-1-sashal@kernel.org>
 <e69e6690-cfc0-4ea8-83e1-5ad2d98b84d5@app.fastmail.com>
Subject: Re: [linus:master] [atomic] 80047d84ee:
 WARNING:at_include/linux/instrumented.h:#__split_huge_pmd_locked
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: r8okseijtxkw3fx4wd5g85mq3b8b6izn
X-Rspamd-Queue-Id: BB15518000A
X-Rspam-User: 
X-HE-Tag: 1793713340-318127
X-HE-Meta: U2FsdGVkX19nbHm4pPkCiDYEBJJs4liMFXLGjk8CW3yJrTTgWjNONP7MKvTO2jFwetJ2giYEjL0aRXGbdmGKKgYFlGLByl+bvJ1MhkIBOsbw6s6DzVBe/ZXdSWqgeS2I7kZ/d2FaTmMk0LM4y5P4q/uTLoSTbTjsMTZXII8rVRebVGbGwF3io70ZC9txsTrBcDuMUr8Kc/ZQMSPrZX+qpvRjdPuwipzqjXcwyhCltZaKonFdBH41b7e2ff/8mEpPHt99801lhDGM2dwNm2zg4epMxBPOZQlXElFkJvZkI8+nHLYm7mhWgeRdOgebrQpFMXLq+q1KWeG6A+unMykHrPqODXViglQ6p5yUOE+49BUHt0tJwa8CS27ikPZRrCGufldE6qNslFBZpQfh1j6gwqsKAppucWSKmlJmyGODsozB6o6l0yV9foQfgQe7qUix3rJSJpnUlmOGp1A9+vXrO+H95a7bK57iB3ObmDtyvP92a9eThr2PxmQqd6gMhWo6H36v1EoXaZedXBQVO6mzNGdiAyZATyrqvJu1KeKs01MkIQ3nzVQejFq498rSpTiw4dDj7RdJLB+T1Fm3+U5ojmLvokmymtTCy2buqolb1GBIwRlQSdmxmlvVhN73RHaw2SbzA5r20mOubIddPC8y4dfucREgWIhvkWxvP6LlHwuDycqfkcJjir0hA4sk6IO4Gkqlxe5u1RvLc/t3qH7Lo2vtL86FW1O2ZJldpexUIWjpDWJ1l2bmfH0gzVWVic2s2woGC1dnY9ef0XkunsyYFrdJJ2iuyBsUyFxB2Lort+QwcZB5uUshvtvzlLsrE8Y9RCsNwlW/a2qhN8v+0fLt49H8Cd2ZwZhissP8WGTRqnP3MMIBR3tI5g3rfSmhOLkt5I3BtkRZiNLziVT2Ut/3RkpWVcjWpA4F9Rt3PjvwoRUg7M+9KKqd8S4FNZjt/oYXzkhn6V0tdluKEwUTOWe
 AZJzazrJ
 omkSYJS5wCxg8PCeGSl9WOsprW7sbjd4i0L4JN0TlDNmmP1q/Gc7m5JqenXhS31Yu3qwmSfIskv758/F3DkgFOmsxiHI2ODbCQgJDbGp4C7hD1c2P52fjLETaSSg0boPpdwoBhh1vNDaOXuicWUbTny1P4j+0M7utcuJd5diUxUOo4OK25cqRF2bjk3iXxhaTTjc/wnPKMzK4pYEAxmtDfZ3xcH6zA7RuQW2mS5/Qi7XYX/OzLo+xiFxSk3Mj/6ibUnb4S1JE7WlHr4lxa4rwNrXo8jRNRdPnPjD2/G9K8QFQG+tp2A9QJL47/8dUBgrbRhz4SgdWoyVPZBD13Dqcl62zKLFkzUZDTF6mEHWLhuyCgFZjQeMQAqOPTu0RUEoNDeviQ/ohjlXP6uvrorM/KfmTF1NUWLmCTGdt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026, at 14:13, Arnd Bergmann wrote:
> On Tue, Nov 3, 2026, at 13:35, Sasha Levin wrote:
>>
>> I tried the typedef change. It works, but gcc ends up realigning the
>> stack in a lot of pte/pmd code (126 more functions with Arnd's version
>> in a small config, 204 with yours), including handle_mm_fault(). Just
>> aligning the two locals seems simpler:
>
> The question is how many of the other functions may be affected by the
> same bug. I see a variation of the same code in vmemmap_split_pmd(),
> and aligning the types is clearly the safer option here, especially
> given that most 32-bit architectures already align u64 all the time
> the same way that 64-bit ones do.

FWIW, I checked the other architectures that may be affected:

- 32-bit arm has transparent hugepages and a 64-bit pmd_t with lpae,
  but that type has natural alignment, and pmd_populate is a
  simple assignment.

- arc has transparent hugepages and a 32-bit pmd_t but a 64-bit
  pte_t that is not naturally aligned. It probably should be
  aligned, even though I don't see any actual bugs

- sh has a 64-bit pmd_t on sh4a CPUs that is not naturally
  aligned and probably should be, but there are no transparent
  hugepages.

All other 32-bit targets don't use transparent hugepages
or 64-bit pmd_t. 

We probably only need to align p?d_t though, not p?dval_t.
How about the version below?

    Arnd

diff --git a/arch/arc/include/asm/page.h b/arch/arc/include/asm/page.h
index 9720fe6b2c24..af5303459d56 100644
--- a/arch/arc/include/asm/page.h
+++ b/arch/arc/include/asm/page.h
@@ -65,7 +65,7 @@ typedef struct {
 
 typedef struct {
 #ifdef CONFIG_ARC_HAS_PAE40
-	unsigned long long pte;
+	unsigned long long pte __aligned(8);
 #else
 	unsigned long pte;
 #endif
diff --git a/arch/sh/include/asm/pgtable-3level.h b/arch/sh/include/asm/pgtable-3level.h
index d1ce73f3bd85..6d5e2e3248f2 100644
--- a/arch/sh/include/asm/pgtable-3level.h
+++ b/arch/sh/include/asm/pgtable-3level.h
@@ -33,7 +33,7 @@ typedef union {
 		unsigned long pmd_low;
 		unsigned long pmd_high;
 	};
-	unsigned long long pmd;
+	unsigned long long pmd __aligned(8);
 } pmd_t;
 #define pmd_val(x)	((x).pmd)
 #define __pmd(x)	((pmd_t) { .pmd = (x) } )
diff --git a/arch/x86/include/asm/pgtable-3level_types.h b/arch/x86/include/asm/pgtable-3level_types.h
index 580b09bf6a45..061283293341 100644
--- a/arch/x86/include/asm/pgtable-3level_types.h
+++ b/arch/x86/include/asm/pgtable-3level_types.h
@@ -16,14 +16,14 @@ typedef union {
 	struct {
 		unsigned long pte_low, pte_high;
 	};
-	pteval_t pte;
+	pteval_t pte __aligned(8);
 } pte_t;
 
 typedef union {
 	struct {
 		unsigned long pmd_low, pmd_high;
 	};
-	pmdval_t pmd;
+	pmdval_t pmd __aligned(8);
 } pmd_t;
 #endif	/* !__ASSEMBLER__ */
 
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 2ec250ba467e..5c028b3f59c4 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -292,7 +292,7 @@ enum page_cache_mode {
 
 typedef struct pgprot { pgprotval_t pgprot; } pgprot_t;
 
-typedef struct { pgdval_t pgd; } pgd_t;
+typedef struct { pgdval_t pgd __aligned(sizeof(pgdval_t)); } pgd_t;
 
 static inline pgprot_t pgprot_nx(pgprot_t prot)
 {

