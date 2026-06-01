Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 925BFCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1E556B047F; Mon,  1 Jun 2026 13:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0086B0481; Mon,  1 Jun 2026 13:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5BF6B0482; Mon,  1 Jun 2026 13:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE6F76B047F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:10:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B28C406FC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:10:49 +0000 (UTC)
X-FDA: 84831983418.10.4E9AFA3
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0BAE440012
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:10:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of whitebox@nefkom.net designates 212.18.0.9 as permitted sender) smtp.mailfrom=whitebox@nefkom.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780333847;
	b=HEDCqWPwdskIGawo711nOVhaIwbIDkKJ3e8KzJdaRJjYUH7N1qNXYGAfHqp44zHyaQxQdt
	za1Rr10hh6GsVD+JQxsPNc3zxI9qs7TJ2JH3+eFoMHNMQ/apbGSnZ4qiNJh2AEbiVRzAWE
	6XUvv/NWFbxSQV7W3aI8qj0uoJNPqAA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of whitebox@nefkom.net designates 212.18.0.9 as permitted sender) smtp.mailfrom=whitebox@nefkom.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780333847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C6TUzh6MlB2HLZAN1vA8DKG+owyLHnMdHM6yCFFqz14=;
	b=e8bgmUSWlCBF5m0jjUM0ryR0YIqTk6B9GcwUiDjbz+Ft29rQH6BTEinsEQTAx2ro5e0qr5
	eiE4b/Pb99L0wMRKgomWcZwNYmzSXye6a9Rebmf4XKNjJOP5YYaEV9MRF/Savvokz0tkCd
	YpaIzIhi254YwI5sgqWJPXylkG2kq04=
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by mail-out.m-online.net (Postfix) with ESMTP id 4gTgTK1XXDz1r5ht;
	Mon,  1 Jun 2026 19:10:45 +0200 (CEST)
Received: from frontend03.mail.m-online.net (unknown [192.168.6.182])
	by mail-out.m-online.net (Postfix) with ESMTP id 4gTgTC7201z1r5hh;
	Mon,  1 Jun 2026 19:10:39 +0200 (CEST)
Received: from localhost (dynscan3.mnet-online.de [192.168.6.87])
	by mail.m-online.net (Postfix) with ESMTP id 4gTgTC1bfWz1qqlT;
	Mon,  1 Jun 2026 19:10:39 +0200 (CEST)
X-Virus-Scanned: amavis at mnet-online.de
Received: from mail.mnet-online.de ([192.168.6.182])
 by localhost (dynscan3.mail.m-online.net [192.168.6.87]) (amavis, port 10024)
 with ESMTP id Vz4wsk_EBIwO; Mon,  1 Jun 2026 19:10:37 +0200 (CEST)
X-Auth-Info: 5KwVlaw+khWHn6gx4eE0zoJA0qIH7ypG7QdiocwwDCnNkXIZNIRcKtK9irFsGuR+
Received: from igel.home (aftr-82-135-83-133.dynamic.mnet-online.de [82.135.83.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.mnet-online.de (Postfix) with ESMTPSA;
	Mon,  1 Jun 2026 19:10:37 +0200 (CEST)
Received: by igel.home (Postfix, from userid 1000)
	id C844A2C16DB; Mon,  1 Jun 2026 19:10:36 +0200 (CEST)
From: Andreas Schwab <schwab@linux-m68k.org>
To: Deepak Gupta <debug@rivosinc.com>
Cc: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>,
  Thomas Gleixner <tglx@linutronix.de>,  Ingo Molnar <mingo@redhat.com>,
  Borislav Petkov <bp@alien8.de>,  Dave Hansen
 <dave.hansen@linux.intel.com>,  x86@kernel.org,  "H. Peter Anvin"
 <hpa@zytor.com>,  Andrew Morton <akpm@linux-foundation.org>,  "Liam R.
 Howlett" <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,
  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  Paul Walmsley
 <paul.walmsley@sifive.com>,  Palmer Dabbelt <palmer@dabbelt.com>,  Albert
 Ou <aou@eecs.berkeley.edu>,  Conor Dooley <conor@kernel.org>,  Rob Herring
 <robh@kernel.org>,  Krzysztof Kozlowski <krzk+dt@kernel.org>,  Arnd
 Bergmann <arnd@arndb.de>,  Christian Brauner <brauner@kernel.org>,  Peter
 Zijlstra <peterz@infradead.org>,  Oleg Nesterov <oleg@redhat.com>,  Eric
 Biederman <ebiederm@xmission.com>,  Kees Cook <kees@kernel.org>,  Jonathan
 Corbet <corbet@lwn.net>,  Shuah Khan <shuah@kernel.org>,  Jann Horn
 <jannh@google.com>,  Conor Dooley <conor+dt@kernel.org>,  Miguel Ojeda
 <ojeda@kernel.org>,  Alex Gaynor <alex.gaynor@gmail.com>,  Boqun Feng
 <boqun.feng@gmail.com>,  Gary Guo <gary@garyguo.net>,  =?utf-8?Q?Bj=C3=B6?=
 =?utf-8?Q?rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,  Andreas Hindborg <a.hindborg@kernel.org>,
  Alice Ryhl <aliceryhl@google.com>,  Trevor Gross <tmgross@umich.edu>,
  Benno Lossin <lossin@kernel.org>,  linux-kernel@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  linux-mm@kvack.org,
  linux-riscv@lists.infradead.org,  devicetree@vger.kernel.org,
  linux-arch@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  alistair.francis@wdc.com,
  richard.henderson@linaro.org,  jim.shu@sifive.com,  andybnac@gmail.com,
  kito.cheng@sifive.com,  charlie@rivosinc.com,  atishp@rivosinc.com,
  evan@rivosinc.com,  cleger@rivosinc.com,  alexghiti@rivosinc.com,
  samitolvanen@google.com,  broonie@kernel.org,
  rick.p.edgecombe@intel.com,  rust-for-linux@vger.kernel.org,  Zong Li
 <zong.li@sifive.com>
Subject: Re: [PATCH v23 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ
 | VM_WRITE
In-Reply-To: <CAKC1njSn_rtCj8ii876PNQTk0nsCTfWsb4DzdymufHVthh1Rkg@mail.gmail.com>
	(Deepak Gupta's message of "Mon, 1 Jun 2026 09:22:17 -0700")
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
	<20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com>
	<87jyslndo4.fsf@igel.home>
	<CAKC1njS=AHu6uHrH4ae8VxcdEbhgiPXYCAoN3F_mnppBd3SwOA@mail.gmail.com>
	<875x44o9hj.fsf@igel.home>
	<CAKC1njSn_rtCj8ii876PNQTk0nsCTfWsb4DzdymufHVthh1Rkg@mail.gmail.com>
Date: Mon, 01 Jun 2026 19:10:36 +0200
Message-ID: <871peqgp9v.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 0BAE440012
X-Stat-Signature: w3c19pa6usobz5bn1xdbh8mkkg3wcocu
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780333846-772000
X-HE-Meta: U2FsdGVkX1/oeklmph0bf1ezy45u0yrEHkQ0D1blhDcIl+mVdaiF8fJJaPF+0Fk5DMfvFBo5V0buWObRayj0bsXLGCVgPCa1tPS0GZM8J5721+5r4+jXOfPIk3yVuSZIxOZkbfaqlQ9Mfnkp9R5KOxhu9QXNy23NEGfDLXr26QCifeOE1dDlkiM3oDuaxPoLmrsujVGRi14ksfm7UugBglfGUVRIoiPIOcc9uk+dIR6PB1X1hvyfFeAj+n4NFkTc78vf23pd2Jcnm+zf3XIqoGvDQG1jjNIn28i0KzOWaP0j6bvKF5LfS+OTVd3A9dcvT7ci3HuLkPrx1nELtpFyz6ExEVj7bN/+Je2zVNIWZiXzYjdDvrpU+US/2aJ5AzwgI5s5mQLMlWjFO+Wm3I52cxqmG1vItzLTco/XgnubulT5VTmul2lI5CYEcVMmMWyAljIleW23kuCnVAfjeY09DAB88n0QhJqrRbqloU6WB30RTykKF4lrAeoFKF5wmII4dBxN16kLSe/coO9GEDBh2TDxmumVRVSMyvzYx/w9Qn2gN/Ep/w06r6vWCZehUI2loxwjyekIsHXhY5ckTRVym2LDe0BfUVYdb84G6O8jd9Uj9g2pnwgkvHcu1w7ZaPPc6+7RnfKEI8zQSuR8fOexRr+9pxxPxuHzF5bESRJxIalpKGWNkd96KG7sR7LHvaHj6Fe5iq/SiEvLhiieiNAUb7cMKrIFdWSWA9CHe4Ua67lx3/JMzJMwGLXt98K6Te31HhNCygC7JoROSoK87iIbb5xNPvBzC9nV7B0K8mWLpuHZPA0PaiVrVeYIItrGm6PhRydhyDQ2g0rIwUxfxMY0B5pZBLyfj6KyteaG9NWFxvIBjG5QAiIkMnzQvtBROqbSgGaDpLykQ5t45vvamgF3kgiuEasbzq8FQgLgiUh3HtxtGPcH/Cw84FkoD/I6BnyoER0wBaddUD6dMK+uK9C
 yma/JvWL
 FLHMTI7EtZt9sUPczrwJu8rdlvSc9rWsbeHhjJlQ2dsNDHsiRyR4AVDltYmDY8oyUvvNa8tVSIT2KAX/81ZctkHwFtUcktHVQA8rGTKQ9f9u6mzmE59+m/wemJEO1houuf6KliYq7LPoklma2COICjIs8Uh8qX2lyes3EH91RDhYtC65ZbWBOY+PvPUVIVpTzcQKejRQIbu1a3fJkMgrheMNUeXet+Bj2qA+KqoFyBGpUpmdHBVqdVTYkso+E3BFBQvPE7OgTlwF9On3LS6xcAfjcHbwo/f11RquZJDII9KbESVfFLQDB51Pe7Ph6ARzNIiRCyy4OUmw+1Cem/TUPtaDR4TLkKm484Q4xF4gofMT53fN30KP/XTFreDMytRhT6Bm3ZRWVoJOActgq27q3t+4i4hPCbcbBI+3I8qIqXT/lG9KB2mmIs0TC4/rRIgqvDVLf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Jun 01 2026, Deepak Gupta wrote:

> This was settled when x86 introduced shadow stack. Instead of having
> new `PROT_`, it was agreed to create a new syscall for mapping shadow
> stack memory (syscall: `map_shadow_stack`). Scenarios like `clone3` or
> co-routines required manufacturing a shadow stack, thus necessitating a
> new mechanism to create shadow stack style memory in demand. Instead
> of having a new PROT_ flag,  a new syscall was created.

So what prevents riscv from making use of VM_SHADOW_STACK similar as
x86, without the user visible effects?

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."

