Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD3C8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88026B00A0; Wed,  1 Jul 2026 07:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A38D36B00AB; Wed,  1 Jul 2026 07:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900316B00AC; Wed,  1 Jul 2026 07:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 639416B00A0
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:05:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5DF340326
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:05:34 +0000 (UTC)
X-FDA: 84939926988.30.144D49D
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by imf23.hostedemail.com (Postfix) with ESMTP id B55C614000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:05:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of schwab@linux-m68k.org has no SPF policy when checking 212.18.0.9) smtp.mailfrom=schwab@linux-m68k.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782903933;
	b=TmKXO1FPUlWpABWuN7lwrMPrQmdqiQjVW1ss/wwT1xH4VyDEFvqZBkl4bJpdkvQXr1H4xX
	lfG8+PAe/sM1Foh6jEpCWHI7uoveQ8wVHLtB0k9n54gJ8lzvBEW/iZCUi6Tp5qvXYd4GAF
	axDTa5fN51Jk+opJ7f0J1Gz6e2q9xPs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782903933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ie0Xb+kW7hcy+X6ih+rt32aJMFM8pnIHwdmk0D3/mnA=;
	b=ueY6S7JtTDJGz8hZ4dPcFFfp7ojj4dskP602JgdGpGDm3LYLh+hZlzClQLtCQ0Bzx/QbZV
	KMAudtuDOB653Ufn2+S4Ry5qS9H9ImSJaorIUTQeg73DIeaoyKI4kD8eHNwJNgqMqaC1fA
	wBDY1ySANapErm3um4EOcFdVeziM+Nk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of schwab@linux-m68k.org has no SPF policy when checking 212.18.0.9) smtp.mailfrom=schwab@linux-m68k.org
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by mail-out.m-online.net (Postfix) with ESMTP id 4gqxy30lzFz1r5hd;
	Wed,  1 Jul 2026 13:05:31 +0200 (CEST)
Received: from frontend03.mail.m-online.net (unknown [192.168.6.182])
	by mail-out.m-online.net (Postfix) with ESMTP id 4gqxxq4bkDz1r5hL;
	Wed,  1 Jul 2026 13:05:19 +0200 (CEST)
Received: from localhost (dynscan3.mnet-online.de [192.168.6.87])
	by mail.m-online.net (Postfix) with ESMTP id 4gqxxp59v1z1qqlT;
	Wed,  1 Jul 2026 13:05:18 +0200 (CEST)
X-Virus-Scanned: amavis at mnet-online.de
Received: from mail.mnet-online.de ([192.168.6.182])
 by localhost (dynscan3.mail.m-online.net [192.168.6.87]) (amavis, port 10024)
 with ESMTP id tQZ9_tKXpaIT; Wed,  1 Jul 2026 13:05:09 +0200 (CEST)
X-Auth-Info: Pt4uSQGEyIjPFT3BPFolkb81GA8tMoI4Th+4yeNg3MiwksamljRMriYVf7/YBrTR
Received: from hawking (unknown [80.255.5.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.mnet-online.de (Postfix) with ESMTPSA;
	Wed,  1 Jul 2026 13:05:09 +0200 (CEST)
From: Andreas Schwab <schwab@linux-m68k.org>
To: Deepak Gupta <debug@rivosinc.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,  Deepak Gupta via B4 Relay
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
Subject: Re: [PATCH v23 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ
 | VM_WRITE
In-Reply-To: <CAKC1njRapOxS6ibQdCuES1E3aAjsA+yGz4yZ1xJAZHU2vkAm_A@mail.gmail.com>
	(Deepak Gupta's message of "Tue, 2 Jun 2026 09:19:50 -0700")
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
	<20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com>
	<87jyslndo4.fsf@igel.home>
	<CAKC1njS=AHu6uHrH4ae8VxcdEbhgiPXYCAoN3F_mnppBd3SwOA@mail.gmail.com>
	<875x44o9hj.fsf@igel.home>
	<CAKC1njSn_rtCj8ii876PNQTk0nsCTfWsb4DzdymufHVthh1Rkg@mail.gmail.com>
	<871peqgp9v.fsf@igel.home>
	<CAKC1njR+dTdvp+BmLGPtgd8dufiUwBtkQ9a-qinELT_Fmi13sQ@mail.gmail.com>
	<87wlwif04z.fsf@igel.home>
	<87tsrli6lt.fsf@email.froward.int.ebiederm.org>
	<CAKC1njRapOxS6ibQdCuES1E3aAjsA+yGz4yZ1xJAZHU2vkAm_A@mail.gmail.com>
Date: Wed, 01 Jul 2026 13:05:09 +0200
Message-ID: <mvm8q7vt1ga.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B55C614000A
X-Stat-Signature: mksmo19ay667umee6weq4aqnfwdqecm5
X-HE-Tag: 1782903932-442914
X-HE-Meta: U2FsdGVkX19lwvm+29g3+mh7zWU4Yno9+81GbH/Gaevyn33HvJhTHjCU3x6GFELkfEvQQQqJXlh2VOcfXdWJ50mYmIdpzoEBZFt7XpgRXd3Pwe62zXetalXhPbkvLtIU20g71POBEODk4iXY/LRW2I+CIQKZSdYeoa0+XrNlAIQeZpwpN357H5dy25X9WugGmpEZj/EtVygAMNSqqs0Hd7rwHNii75/fo/EogOw2AtNlEcU6vkUGedNvu5O7duPkPYJZAi6vvQPSvE1vIaWex34A9nhzZF19W67hTmSihxzkGoCSHJaYjw+xa/vRGTvl8yXSJg3vxbt1xzTZ/At6Z5N0+73Zo8SVxnxio1/8eWYNOk+s2hAXq/gtdfwxZ9d8YW7LP0+ZhRIAZ9uqfJanq5Ulh31fyb4vWokODhhZetiEbsdb4XRiF0s0BxOZwCgGsLCfSyxtZoNv1Lo153psatcMHmOZxgnJaLBbbgSDqSGO3yr59GFLAIhh4JiP4VkGOvinhpmaPBxAz4kimQ78LQdS1pMhTMKIcmfioAqfPFs0dGLLz+lbuapw+bCDYArMlNXMux9UH5/pm3JqigrsNI7pw/SkBz1iySlOOcaNezTROjU8fSanFCtUaRsCqHwknjgyN5D8zK3NN+pSu4GbKQenRwDah6rwvSMhYT9yF4Sldk96XZGGpmgFQyW+BUKlNFHvByJPpGL+8r1WgExqU2nGas1qnCk+xG2RF8/RwNfmG6BPqT+u4uaraqsMTEWyeT+rLt4jMam0kBJumboOSaXhuRmvh8Y64RoHpXSXUXk6LS6bBZUncivLX7kbu7ylnL88m1PAfdEag4PAoAk7eAdb0kKZ0Ui65wrpkV5KBonm/6V0gKYpNn7wrT9wdrdjxaWj566yE1fcXtzHXyAFobVCEI0cucu68Na0Xl2QMAGiXyUEx1624HQ5sCruruSdv/LX8/B7B9OEkqDkKn0
 n/ytQRwk
 dAFMdfeqhHxobhA8Jit79g714nw+5DvLVJ/qHpF4r9Y9OQmUyBuEFY8/Z2sEt0UiyJHF7Chhx8W7D5Z1u+sUniMk7W5XmUYccd66fYFKtDLtwV1qL19S47B6LiE/UcCt8QdgfRL/bKlY1MDOi+0okMjIXwoD7Qxe21Za7mXLQzNdJbQG094OAY6J5pR0H4HUjFLYTuZ/rIe+IAQUpkwUCuRW+0WQd4mVbWrcThyx8pf4cqFyhio9/R6XfXNPnMh0VjQFCDrma6pK0yMEc3nVxAYMQlXRkStoT47N+udy6qRHnyEhgiVivg2nwR0RHAUNt4BYl6jnj5ituPNaO750bN4unU35qBgTf0uQvCNbdgfII/qdv6hsp5TbKTTmtLnVmWy2kO8Yc88JeJx4MMmPN+IeEfr82wIlwMbis
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Any news? This is still broken in 7.2-rc1.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."

