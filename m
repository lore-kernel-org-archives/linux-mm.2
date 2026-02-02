Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A12EE73144
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 08:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3823D6B0088; Mon,  2 Feb 2026 03:11:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330626B0089; Mon,  2 Feb 2026 03:11:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208096B0092; Mon,  2 Feb 2026 03:11:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1146B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:11:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 705DF5C383
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:11:51 +0000 (UTC)
X-FDA: 84398798022.30.BE48350
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1EAC9140003
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:11:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=HpDEbFSs;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="q gM8njL";
	spf=pass (imf26.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770019909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gsrm17c8fPEfOLtJcs7cB1KMkBd+mtB4o/EnIcCBhE4=;
	b=rKbAU7sumo+99JDgdqBf/KrotHjHqbDjGP0UBh+bJ8CQoCKT9ms7XtV+zviwR1uymobBoj
	/Zx7fRAP5ZB1Cvvi6Axp3oQZPra4F8FC8CrYmW1oS5hmmjgxxFU9jPud1/i/9VfgGFZxWj
	+zOqp51DDqPLktfhsEzgzZvEkU9Xkqo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770019909; a=rsa-sha256;
	cv=none;
	b=2v9WFL2MjnAeV3CdlJ+JvT6SC7UR/w1NvEnNXDNsf1pCqWVCyRe79p2fmE2njCanlqS6JK
	7sYlwujg5NJbzS+hWBTrf0Bnkw7B9gmtL01VQk3tkUS2QRjFR9fMxSRYk7tx+TZOUdjcZy
	bNSk644/YeQI8tm78g4kbD0cF3qiE2E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=HpDEbFSs;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="q gM8njL";
	spf=pass (imf26.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 8F8771D00068;
	Mon,  2 Feb 2026 03:11:47 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 02 Feb 2026 03:11:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770019907;
	 x=1770106307; bh=Gsrm17c8fPEfOLtJcs7cB1KMkBd+mtB4o/EnIcCBhE4=; b=
	HpDEbFSsQKFqv4e6EfskisNSlsEctkJhAlc4ZCRUh4/gLtrEbh3280hs4t0+ObyU
	YGMK47WQ1j3GjoIUKJ1YwhmkA7pT1TD0W/t7pMUS5BSHY/I/UHXALeXPhdMrIfPx
	SWfCF9Ih+IZbDQP3PJz3v4uOOYl17HB0PQF+GQk5SHx3JS9z6al1DbIlAbfOW60Q
	qSfmb5bmNnY7okTYBWHo0GeZchhBJ2k8pTDOGRG7Ce3UFJvZlI2wenfbMGgvM/mq
	kTD4TOW8BKP3b0JuhJXLbvJ58CX+2nmVCrekP9syeXRifcYp4Ue1BI3OGTPbuez6
	ngrsYRg5So1XWl5fZnp0nQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770019907; x=
	1770106307; bh=Gsrm17c8fPEfOLtJcs7cB1KMkBd+mtB4o/EnIcCBhE4=; b=q
	gM8njLhk+eSW0ciRg/a9v8SLgn8KJ1gvKr+094EeNHiXZYgzU/241BFpIRYafCHW
	sZ8lwyOkgq/X3zZk7xSoXtJvZwZIwZ1vsCcookgwAS5GWnbk2PTgVGPi/9EhzJtC
	h2k49shexjNBv2pfef3W21GUxTREmQZc2TUb+hG54gzsWxBGTRJAFuLIPeusyslN
	LIN/hUwId7JeFNYt3JGoXesDiM/Jqu0FMOtGuNSc1JlgE04mtOI45pvZZsyzq7en
	eNTMm2avo0dI6QgmmVnBnVUl7msKRtB6JfzmHTwuY4cs2jdcceSDsHznUXcaty9a
	yiuK1HLcajYnA6tgNSHUw==
X-ME-Sender: <xms:QlyAaTO9VaKm2YrwD8nxxnMET30y2vdMHg60P-Cj2a8KNhhjgkXSAA>
    <xme:QlyAaYw0EKfSNErjVBiA0nfNIjy-0qrxxbSQma26Y0j93XOGb3vLwjgyxzZ7Oza0u
    UInCcK0JojbJSbvJX5HMFwilTI3q4R_pheXnmz_2PGckcwhA6vuLqc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeejudefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepfeekleevtdfgueeggfdvveevueekveffgfekkefhudektdekjefhveevffffffei
    necuffhomhgrihhnpehprhhotgdrshgsnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthht
    ohepudegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegtrghtrghlihhnrdhmrg
    hrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohepuggvvhdrjhgrihhnsegrrhhmrdgt
    ohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpth
    htoheptghlsehgvghnthifohdrohhrghdprhgtphhtthhopegrrhgusgeskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtohepfihilhhlsehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhu
    gidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkh
    gvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhg
X-ME-Proxy: <xmx:QlyAaT9RoYXbVz9I__xu4oC7T1NZNOJu7TuPnxFdoEHPzOCyXJLFrg>
    <xmx:QlyAaaFG9-O0obOBi98-WewrwkCNHaQ1euV90NLr0qtrAJQkIDSnFQ>
    <xmx:QlyAaXJY8KAThzkPWGLPje5TdjTwf7s3LhCf8j3GgUk6d_Lg2R76HA>
    <xmx:QlyAaak4S_YcV1Vef4dUzO-R-g4lWRNPQTrTaNTFcGR8ZwsWWOp5FQ>
    <xmx:Q1yAaUaLZy3OIWSZRR-gtlk8lQyClrfgJxvCDVRu9cq-3GB0gUPqbkpd>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 4CC08700065; Mon,  2 Feb 2026 03:11:46 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ASnEhGskTYsw
Date: Mon, 02 Feb 2026 09:11:26 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Ard Biesheuvel" <ardb@kernel.org>,
 "Yang Shi" <yang@os.amperecomputing.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Ryan Roberts" <ryan.roberts@arm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand" <david@redhat.com>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Dev Jain" <dev.jain@arm.com>, scott@os.amperecomputing.com,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Message-Id: <625eaac4-6972-4d4e-ac8d-52cc19e4fe33@app.fastmail.com>
In-Reply-To: <bf94fb74-d391-440c-a90e-1346312328c4@app.fastmail.com>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-5-yang@os.amperecomputing.com>
 <fd18c462-60ce-4dc1-9877-2a1d162d5879@app.fastmail.com>
 <bf94fb74-d391-440c-a90e-1346312328c4@app.fastmail.com>
Subject: Re: [PATCH v8 4/5] arm64: mm: split linear mapping if BBML2 unsupported on
 secondary CPUs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1EAC9140003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kz3jarrdz6iscuci1emk5iuboj1qbduc
X-HE-Tag: 1770019908-615676
X-HE-Meta: U2FsdGVkX19f3oyAUbhjsuceXtjqZmrZMAN6WazTpoumysXrJS/EsF7GdLVDaTGe0SSxONWOErMyLSF+iIg/Mm3g/b7geuq6LFm26SZz5RgxHxVJ78It6BypkXEOrTMTHwjVSctm3Ip2gf4IBvGs2h5g7oohcR0CE1pwwBqso8immyrxLQLSn803CNyBbUANeZUOnHFciys31aWfUWtrH0tbRLC8BHzjg1l2B/Qq8NVsiDfxYyZMBvxf9nnPiXveLC0oUXjNX+idXQAImeouY0VGnsJ5NY7U/Prmfi5TD1aAAy2Pxe9LnLLqhZuU4Qw9nRV/7b4q2ti9mcO1X6teVyeFFArKE0q2Qn8Yo/2Wj3eKPB6qydFs+bZPWuU54IIFi0MukL/N4FPLO2V7DwW1EFrptEtkJ7zavu/qEO2/QmQEIUnsqbFwtSmEu7WvCzhOh75NskAuUIFjob37jZ3BuxH2CXizr4x3tbvMJVSfXAAKZfju+BI1Y0s8UFj5dDnKcyOAtDwze7ckdKHpWs60llNEGH9cnpBL5ZFcvSTG6RCOohALeT4vnWh2uAc9SJ3dNNeZpXd3VZ8kwjFaf04ipiYNGGdSgfKYbSMRHdwVnl7FEg7MwoAsz9CcGLHpraZ5jFPC6try33pNjqg96zGXu1uUEQMTeG7B06cTlPWEYITkGYyStiKlR6WDEWd3WOZc3A44QFRBhd8S+VRQ7G18sJOHf6N2SKcAtkuOH1PLIiYS54bjrYcnQVfQUvJA/aSlW3V3va//ok5uWGZ30TXc5l5eOvpAx0xoHXFPbMkTGTP81KdBxvPwhaF0NAzNXsky1eDYI3uCFPwWaACVVOXMuM3eebIN55N+luYc5JH6hb7iCVNfYSCsnEGE3XbL4qIS/1tqn7YKcpm2Mo5W6wQI7QGuOQ7pbrU1ajSQsRgssvaTzwjndEMqExy/uqho4p8kK5+cWSvyB9nzNSNKNyL
 OKpS8q75
 COY7zQgbmF/GNAFb0PkEIZjl1sPkUlpDun8vHha1pjtkvL2FFVN+YECN5nkU4H0iqeIcm2wdMavG8jwhJdrROYcTKbaWs3FdkZWwS2iZTpp8EAj1n2vh3QKuZBR0C2hpYPzZCNYNWXkDVrIKi9l8+SIEMzej81eqkua5YCl64GfS9p+HTzZiU6ei+aL5yOtYxuqe/ZN9WQItvw9LSyWmGE2Knirx9dTbMUAjj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 2, 2026, at 08:43, Ard Biesheuvel wrote:
> On Mon, 2 Feb 2026, at 08:18, Arnd Bergmann wrote:
>> On Wed, Sep 17, 2025, at 21:02, Yang Shi wrote:
>> --- a/arch/arm64/mm/proc.S
>> +++ b/arch/arm64/mm/proc.S
>> @@ -439,7 +439,7 @@ SYM_FUNC_END(idmap_kpti_install_ng_mappings)
>>  #endif
>> 
>>         .pushsection ".idmap.text", "a"
>> -SYM_TYPED_FUNC_START(wait_linear_map_split_to_ptes)
>> +SYM_FUNC_START(wait_linear_map_split_to_ptes)
>>         /* Must be same registers as in idmap_kpti_install_ng_mappings */
>>         swapper_ttb     .req    x3
>>         flag_ptr        .req    x4
>>
>
> This is not the right fix: the indirect call from 
> linear_map_split_to_ptes() will be instrumented, and so it requires the 
> CFI annotation to precede the function entry point, which is what 
> SYM_TYPED_FUNC_START() is supposed to emit.
>
> The typeid symbol is injected by the compiler into every object file 
> that takes the address of the function in question, and so the fact 
> that it is missing seems to suggest that linear_map_split_to_ptes() has 
> been optimized away entirely. Could you double check 
> arch/arm64/mm/mmu.o if that is the case?

Ah, thanks for the explanation. This has indeed been optimized out
by a patch in my randconfig tree that makes CONFIG_SMP optional
for arm64. Without SMP, the calling code path is never used because
smp_processor_id() is fixed to 0.

I'll fix up that other patch then.

     Arnd

