Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D3A4CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 19:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956508E000C; Fri, 26 Sep 2025 15:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92C6D8E0001; Fri, 26 Sep 2025 15:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841D58E000C; Fri, 26 Sep 2025 15:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7416A8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:52:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E1F61A075D
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:52:56 +0000 (UTC)
X-FDA: 83932449552.07.782E1D0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 68BD140004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:52:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BLt75jv8;
	spf=pass (imf17.hostedemail.com: domain of cmirabil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=cmirabil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758916374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XHvwAIHkoSzj/0sM3EQyAOJu3zkKVKdDZuOCGzwODmg=;
	b=xHZg/FBBEBJSteZIRX48LTgkN+hNOSxNQ8WKVFJie9Azu9gnmeW4/HZvJODXjyoIryRFsx
	cic7g857THyuptZ4PFcTHAayvjihS4zRhjCQHtJ6onnRCE3IHIP3PZPWqWac92y/70YMcb
	QOtPoZ6JYOQp70Y5h3jBF5UE49ZuWcI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BLt75jv8;
	spf=pass (imf17.hostedemail.com: domain of cmirabil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=cmirabil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758916374; a=rsa-sha256;
	cv=none;
	b=48vFBUae0vsyxruiZLvTk2qNCwx/8fwR0LRgBPZNqcaYfNyXwkY1kxg2ZH42AarMiJoWcm
	YphCb2FeUSBh9BEctZpr/hu/ocDi+KGh/m6bN/w9qHasOE+vgWfEWFaWIpOYH0o71mrKfc
	TR87267kt7suC0W0nm4TR/Q7kUcfElU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758916373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XHvwAIHkoSzj/0sM3EQyAOJu3zkKVKdDZuOCGzwODmg=;
	b=BLt75jv8kp+P0Yemlf57LsPYrbw2dRyyMdtMPbufJTrBp/LrvoAbkDgd2J1M6wkYTd6DlF
	IKSq+2znCtwfI7LS85kSku5Lumo2fDzbnCzMDzIbVjOpNzgP3488lW8KMhk/YzPhZvNWk2
	D6e1tV9tlEjHVtRHEjAQCCKLpMTwcz8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-189-rrOIcbkzPfS1s4VWnAN7zg-1; Fri,
 26 Sep 2025 15:52:49 -0400
X-MC-Unique: rrOIcbkzPfS1s4VWnAN7zg-1
X-Mimecast-MFC-AGG-ID: rrOIcbkzPfS1s4VWnAN7zg_1758916364
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B72218004D8;
	Fri, 26 Sep 2025 19:52:42 +0000 (UTC)
Received: from cmirabil.redhat.com (unknown [10.22.90.77])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 71B901800446;
	Fri, 26 Sep 2025 19:52:30 +0000 (UTC)
From: Charles Mirabile <cmirabil@redhat.com>
To: cmirabil@redhat.com
Cc: Liam.Howlett@oracle.com,
	a.hindborg@kernel.org,
	akpm@linux-foundation.org,
	alex.gaynor@gmail.com,
	alexghiti@rivosinc.com,
	aliceryhl@google.com,
	alistair.francis@wdc.com,
	andybnac@gmail.com,
	aou@eecs.berkeley.edu,
	arnd@arndb.de,
	atishp@rivosinc.com,
	bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com,
	bp@alien8.de,
	brauner@kernel.org,
	broonie@kernel.org,
	charlie@rivosinc.com,
	cleger@rivosinc.com,
	conor+dt@kernel.org,
	conor@kernel.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@redhat.com,
	debug@rivosinc.com,
	devicetree@vger.kernel.org,
	ebiederm@xmission.com,
	evan@rivosinc.com,
	gary@garyguo.net,
	hpa@zytor.com,
	jannh@google.com,
	jim.shu@sifive.com,
	kees@kernel.org,
	kito.cheng@sifive.com,
	krzk+dt@kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	lorenzo.stoakes@oracle.com,
	lossin@kernel.org,
	mingo@redhat.com,
	ojeda@kernel.org,
	oleg@redhat.com,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	peterz@infradead.org,
	pjw@kernel.org,
	richard.henderson@linaro.org,
	rick.p.edgecombe@intel.com,
	robh@kernel.org,
	rust-for-linux@vger.kernel.org,
	samitolvanen@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	tmgross@umich.edu,
	vbabka@suse.cz,
	x86@kernel.org,
	zong.li@sifive.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Date: Fri, 26 Sep 2025 15:52:24 -0400
Message-ID: <20250926195224.351862-1-cmirabil@redhat.com>
In-Reply-To: <20250926192919.349578-1-cmirabil@redhat.com>
References: <20250926192919.349578-1-cmirabil@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 68BD140004
X-Stat-Signature: jo3ekbexfasdmg3uj385kbat8pxcpo8m
X-HE-Tag: 1758916374-49786
X-HE-Meta: U2FsdGVkX19bXhIFzUpbhsj8Qp0jr/V027gj+hURrKAMHWYmYEnXMrOlBsjlaisbPX8EjcBJBLJpXTytwN6GqKFLIWQEs8RSCEN527I7Vq0x2ONhztRTNye+0FH7805GxZcf+IbsebTxmla/YCwq9Y/AUzX9Nhm/gGMNO3Mr/wvviNpZMvs2mmDoLivd/TeZCgecZM5n6V7DHnX4NH1awI/MeQoL26lP4lpXYgEGg8vK/oKHDcod+rTsrHAR7DpTFQxXE3LfihS5UxxvcX89aVCKI5LB7OCEv8grX8K6FPb4gj4LHSiOTAZIskUGroO4SYcmlVa4YvhVga1OkPAIq4ICZlGKOkEaiZ4Dac6XXEPTEqufKqzVUQHMN7EVvbKllUY6d4g8JuWnN1vFmxlK019iC8tO0AyE3wrw6DQ6e5L6e+nef8WNErxM9MRKgGQssHKwb6yC7RFtqaHvP/+gR0ZICZmctw8aCeaTQTDUfbqByhJH4YGB4rK0AUImPBM/INM231/J+UGW4G2bO4Fgum5rtSDFp8cYDgxvR2+XoxjJ9MhcxD14Okzqvykl4TLj36hVAW1v0XgvIK7+MdQ+qVGCtlq/Jm+112uBwFXzpV6F7vN4+jqMNeEpohwAX+yg7gRtPoQYj4RvtrgYPw/Z78GhDXfbRgNfyLvHULM6PMUoXW8Qo2LkCaaYjrBXuwass/UQoAWpO/M8jo4DUjW11Xnz/7p9JOM+PnIE/uQTIg5htEGfUzS/EQKXHLY8RjAXDzBxtRU3GcplDXctc2f4UwFBWT0WUgnTRAzqxTK/y1kbr6HNjdHYyZ82Mg1QaDFuySeTe5MVYgQtYPiQUvwVw7NwpdBuQvvxhfaFJg+SetCByhGBwuhgYfRbf/vEA4WGjWSbYWLsusWUI/kKvFM94HrmiuSB/R4DsN73lIQ0qFxLqmkuN9T2oRphn5pg5ZP8hZRUXU4qoUB0CqNdU8q
 JvdHPIyd
 l18tmxpako07Wqn3CO58kjRtMmMF+0iNMUBWjmcqc3Yx+5hT8NFtfuzWMy7dCAPfYck3GGKo7uQ51iIWSbrgojh5sW0u7J4pY93CdQHMAlSEyOn9jqlc4cgZ90pZdGnx7bVgUz36l3bgEdZDTeoAyZZNiVZeO0Bl/9jFFobByndwwNb4BkTKMZ5yG8R2XpokCDNnxnDm/z7sDsTh4fH639zW7zt0XNsnuWwe+T9XlC74PiFxHBNYQ1Mgj9CzqKV11uSRjOrPPJv7c5jtlKdqgVgsVYAPUn2hhsq1Is27qwg9945g/neYo7LlKc7avg2aUJwz8fgF9bNLophd+GMmpf6inA8fSQmTbKR7gDRtqRbNqxQqI1g8t3kJg+iwENZXxx/9E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi -

Sorry for my previous email, I realized I was mistaken...

On Fri, Sep 26, 2025 at 03:29:19PM -0400, Charles Mirabile wrote:
> Hi - 
> 
> Hoping that I got everything right with git-send-email so that this is
> delivered alright...
> 
> Wanted to jump in to head off a potential talking past one another / 
> miscommunication situation I see here.
> 
> On Wed, Sep 24, 2025 at 08:36:11AM -0600, Paul Walmsley wrote:
> > Hi,
> > 
> > On Thu, 31 Jul 2025, Deepak Gupta wrote:
> > 
> > [ ... ]
> > 
> > > vDSO related Opens (in the flux)
> > > =================================
> > > 
> > > I am listing these opens for laying out plan and what to expect in future
> > > patch sets. And of course for the sake of discussion.
> > > 
> > 
> > [ ... ]
> > 
> > > How many vDSOs
> > > ---------------
> > > Shadow stack instructions are carved out of zimop (may be operations) and if CPU
> > > doesn't implement zimop, they're illegal instructions. Kernel could be running on
> > > a CPU which may or may not implement zimop. And thus kernel will have to carry 2
> > > different vDSOs and expose the appropriate one depending on whether CPU implements
> > > zimop or not.
> > 
> > If we merge this series without this, then when CFI is enabled in the 
> > Kconfig, we'll wind up with a non-portable kernel that won't run on older 
> > hardware.  We go to great lengths to enable kernel binary portability 
> > across the presence or absence of other RISC-V extensions, and I think 
> > these CFI extensions should be no different.
> 
> That is not true, this series does not contain the VDSO changes so it can
> be merged as is.

Oops... no sorry, it looks like it does. See 19/27. I was misled by the
cover letter which said to pick that patch separately. I completely agree
that that needs to not be included if this is to be merged.

> 
> > 
> > So before considering this for merging, I'd like to see at least an 
> > attempt to implement the dual-vDSO approach (or something equivalent) 
> > where the same kernel binary with CFI enabled can run on both pre-Zimop 
> > and post-Zimop hardware, with the existing userspaces that are common 
> > today.
> 
> I agree that when the VDSO patches are submitted for inclusion they should
> be written in a way that avoids limiting the entire kernel to either
> pre-Zimop or post-Zimop hardware based on the config, but I think it
> should be quite possible to perform e.g. runtime patching of the VDSO
> to replace the Zimop instructions with nops if the config is enabled but
> the hardware does not support Zimop.
> 
> However, that concern should not hold up this patch series. Raise it again
> when the VDSO patches are posted.

@Deepak, would it be possible to just resend this without the VDSO patch?

Or to rework as I had alluded to to check for the presense of the extension
and remove the instructions from the VDSO at boot if it is not found?

> 
> > 
> > thanks Deepak,
> > 
> > - Paul
> 
> Best - Charlie
> 

Best - Charlie


