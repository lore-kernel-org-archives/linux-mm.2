Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C4E3CF45CD
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 20:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7096B0088; Mon, 12 Jan 2026 15:08:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674726B0089; Mon, 12 Jan 2026 15:08:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548896B008C; Mon, 12 Jan 2026 15:08:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43FCB6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:08:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2B161A0D5A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:08:39 +0000 (UTC)
X-FDA: 84324399558.03.1B9ACC7
Received: from mail-10631.protonmail.ch (mail-10631.protonmail.ch [79.135.106.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id DB4891C0009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:08:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=QT4Gpkfe;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.31 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768248518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0xx91FMArzFMWklxJ23UJVUdtYrv0ESnhx5I4mmt2rU=;
	b=Ijssi1msErSCWktrZpJshvLeBl3VASRT4bbgnzWgglQ+uq/zk1GdYrJw9cQJNj2bbk02eY
	xe/G3u7NHRZRfFEUt/MSyZ6uJ6vffXs045lAyHbtLLSrdXyYHPQTNcNABLCrfKpLNV3m7T
	Yvyid56A6m9Z0q6dZ+bCZl6eKJdoL6Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=QT4Gpkfe;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.31 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768248518; a=rsa-sha256;
	cv=none;
	b=WqPJXlyCFTnCGXUQIfDwJPzdWS9MW8XlcWbefKu5NEPYc1Fox4FlYHR0rfYY0Ipf609m6S
	Sg/oUqIXP3TKa+J7zdAjmi8NT7DKFB+9lQ+650osNBxluAdCUwKwv0wZF+dUNCp19WbqlQ
	zUfDWPzS8DFs+ZASHo0ZZkwMIhyD5QU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768248514; x=1768507714;
	bh=0xx91FMArzFMWklxJ23UJVUdtYrv0ESnhx5I4mmt2rU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=QT4GpkfeDeiZhEH0UHFstVyzQKRlUDyyzO3NyBJ4KpGqlaKOkHJ9suj9ZyeqrjLMI
	 dU1YDifSGjmZNM3qKkvKMgpskAglgi05UxiDWwfhkh8rX+s/2lZb76KG3QD7v51syV
	 0B3XohFYhfPIvGVCtMKCqW5/zpjF9fPlI3L34+4MkYznIaFJ2Yc9D3QRFDR6w9Ijap
	 nrTxnMyLEwwurUV6I+I4XP8Hz1wtDy+uAR/LBbsc4LqgkTw2cK9GoTnicbBOiEonAf
	 OMQntpaTaWtrP2VUSiCzqFMGh5mkUD6C225v9M2ytPNklm/HL+ToP6GKFuKce+qo4B
	 OrUUPcrIkR7Bg==
Date: Mon, 12 Jan 2026 20:08:23 +0000
To: Andrew Morton <akpm@linux-foundation.org>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: corbet@lwn.net, morbo@google.com, rppt@kernel.org, lorenzo.stoakes@oracle.com, ubizjak@gmail.com, mingo@redhat.com, vincenzo.frascino@arm.com, maciej.wieczor-retman@intel.com, maz@kernel.org, catalin.marinas@arm.com, yeoreum.yun@arm.com, will@kernel.org, jackmanb@google.com, samuel.holland@sifive.com, glider@google.com, osandov@fb.com, nsc@kernel.org, luto@kernel.org, jpoimboe@kernel.org, Liam.Howlett@oracle.com, kees@kernel.org, jan.kiszka@siemens.com, thomas.lendacky@amd.com, jeremy.linton@arm.com, dvyukov@google.com, axelrasmussen@google.com, leitao@debian.org, ryabinin.a.a@gmail.com, bigeasy@linutronix.de, peterz@infradead.org, mark.rutland@arm.com, urezki@gmail.com, brgerst@gmail.com, hpa@zytor.com, mhocko@suse.com, andreyknvl@gmail.com, weixugc@google.com, kbingham@kernel.org, vbabka@suse.cz, nathan@kernel.org, trintaeoitogc@gmail.com, samitolvanen@google.com, tglx@kernel.org, thuth@redhat.com, surenb@google.com, anshuman.khandual@arm.com, smostafa@google.com,
	yuanchu@google.com, ada.coupriediaz@arm.com, dave.hansen@linux.intel.com, kas@kernel.org, nick.desaulniers+lkml@gmail.com, david@kernel.org, bp@alien8.de, ardb@kernel.org, justinstitt@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 00/14] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <aWU-oL8oYS_PTwzc@maciej>
In-Reply-To: <20260112102957.359c8de904b11dc23cffd575@linux-foundation.org>
References: <cover.1768233085.git.m.wieczorretman@pm.me> <20260112102957.359c8de904b11dc23cffd575@linux-foundation.org>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 74b6155b55c4853d5925984570fe14ed71d1c92c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DB4891C0009
X-Stat-Signature: 8q15s5bg6e7n7b65q1zf8gz3j81hco9y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768248517-300685
X-HE-Meta: U2FsdGVkX1/aTOyeDZa0Snf+1s+1aG6CGjb0TTHb4X8mGe6DUW67uPbmx2mWFe415GcjwtVyVWgCxPvQcJsJHtsOW3zAKDk08pF6s8Adi5D9JwR6X+8Il25DOJQEXm3837drzjQJPlezwBh+KF7HvPHK417nsaWnjz0nHizKFvNv1chEP/zWRMcrgCOi5U5zkVja47hCYEnpRF0+ox8XkpYUEjT+1QLgXhrAH7dsqnsb9fnnGW6seTrVfgSeAryE5AiQIyQRpAotM4cJVZFmsDtyqbZf6vHrx3n8U5/+ItDbAy+clZaBtD4RQHbJCksuo5TicECox1RHNyyCI7ObVaHWZOWBVQQnhZhyaokatQvmrZj20iUfTHaRKAjfVnyBBFUgyDIQVKfUsRCTzp38U4pJQt6B76pfPE/lbAuGZXXR67E4Pvl7QbzFH5ie7VvVAeVjCzSMLmVgYmm0woaSCBQPtwWQuvF9nhpjCzuiQIK519tzFvlrxAKDyyL9ldFwIDo/R0RtufGm9HrcdXqJZMffohPe7efZEa0xspUWytotqM6/tzcn2OeI0WmEbpSMjazCY4Z3WrhKe5+81blhIA6sxw0gboRnLvH3FKx4pVGQYiAeLReDOujIAdOhJAmwCYbCZpIDGHbDRqq3xMswjEU9djy/Vja40xsZt5gZr2JZlMx+vI54o3MQbTsGwcb/Yerl3unjfTDO9H16+9ulrY+whLF6UNlaqlaiZ7OXxxAhn5P7e+MAjKf++/Jv48tz/fvAuGcIwNSc/jwxMsKtIF4im8bnqOHqM4PKdASGtT6Y8/hIaB/O30E4aoYT/5CFmu3PTDlBy+OdxmJqBJEZfEtH5odvwsZVL1nDXWAx+pYssaMDZiTaj7Qf9nIfBMs8a9kky3B1uIYNlK5+NhwxhW7f7lWSGGFMF8x13gLSgu+TMMSI0j/J5v08qIkSKByK8Ebao3It1m1Kz+lSCmO
 jme3zeAW
 82OAxSpBVE5eeqoiUuy0fG6WEYh5RVvqjsuiHc/SbfCL8cwKbwMG+8LQFExRpeylRXO9u3+tWx+guANhcOPmorT7zNktGiI+sfG846/uaap2W6Mavbs+HlbUYXhFgzK9MryEWMCaUyXzOYX5I1Gs2IFnFZk8BK6mfi5kFU01U/hYn0Hv9ylNxNmLeuf+IcXkbY1QHiR0xS5T+HwtUuaDr04WAO328qnaYtNV27OXHSaHOABKrmDKOk4kQiiho05bg58tv1O4/s+8XQclIpSZHbM5X+/5I7NKgvKpaCl11bSlNqR5Wf8TOEGeo8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-12 at 10:29:57 -0800, Andrew Morton wrote:
>On Mon, 12 Jan 2026 17:26:29 +0000 Maciej Wieczor-Retman <m.wieczorretman@=
pm.me> wrote:
>
>> The patchset aims to add a KASAN tag-based mode for the x86 architecture
>> with the help of the new CPU feature called Linear Address Masking
>> (LAM). Main improvement introduced by the series is 2x lower memory
>> usage compared to KASAN's generic mode, the only currently available
>> mode on x86. The tag based mode may also find errors that the generic
>> mode couldn't because of differences in how these modes operate.
>
>Well this is a hearty mixture of arm, x86 and MM.  I guess that means
>mm.git.
>
>The review process seems to be proceeding OK so I'll add this to
>mm.git's mm-new branch, which is not included in linux-next.  I'll aim
>to hold it there for a week while people check the patches over and
>send out their acks (please).  Then I hope I can move it into mm.git's
>mm-unstable branch where it will receive linux-next exposure.

Thank you :)

>
>> [1] Currently inline mode doesn't work on x86 due to things missing in
>> the compiler. I have written a patch for clang that seems to fix the
>> inline mode and I was able to boot and check that all patches regarding
>> the inline mode work as expected. My hope is to post the patch to LLVM
>> once this series is completed, and then make inline mode available in
>> the kernel config.
>>
>> [2] While I was able to boot the inline tag-based kernel with my
>> compiler changes in a simulated environment, due to toolchain
>> difficulties I couldn't get it to boot on the machine I had access to.
>> Also boot time results from the simulation seem too good to be true, and
>> they're much too worse for the generic case to be believable. Therefore
>> I'm posting only results from the physical server platform.
>>
>> =3D=3D=3D=3D=3D=3D=3D Compilation
>> Clang was used to compile the series (make LLVM=3D1) since gcc doesn't
>> seem to have support for KASAN tag-based compiler instrumentation on
>> x86.
>
>OK, known issues and they are understandable.  With this patchset is
>there any way in which our testers can encounter these things?  If so
>can we make changes to protect them from hitting known issues?

The gcc documentation states that the -fsanitize=3Dkernel-hwaddress is
similar to -fsanitize=3Dhwaddress, which only works on AArch64. So that
hints that it shouldn't work.

But while with KASAN sw_tags enabled the kernel compiles fine with gcc,
at least in my patched qemu it doesn't run. I remember Ada Couprie Diaz
mention that passing -march=3Darrowlake might help since the tag support
seems to be based on arch.

I'll check if there's a non-hacky way to have gcc work too, but perhaps
to minimize hitting known issue, for now HAVE_ARCH_KASAN_SW_TAGS should
be locked behind both ADDRESS_MASKING and CC_IS_CLANG in the Kconfig?

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


