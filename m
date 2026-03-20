Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 479B9109878D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AAF76B0153; Fri, 20 Mar 2026 10:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75B626B0155; Fri, 20 Mar 2026 10:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6233E6B0156; Fri, 20 Mar 2026 10:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3BF6B0153
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:32:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F1118A984
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:32:22 +0000 (UTC)
X-FDA: 84566681724.24.076729A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C8B6B4000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:32:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GahkMbt5;
	spf=pass (imf27.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774017140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqGloG7tHF3DMyujlPY0OGG8+IpZoISXZB4xRwpDNzg=;
	b=jmvSTODuDfKZpKqBCCTitStmU8wn4imslIYdy2gyPjiHWOOaqwglInrqukEesTjxbw8MOV
	nQ3b/BOHIIpyrUYHkcvLdJJFk/PbKGOmKtUBsYW+p3ZrjF2z1T9nB9TzDwB3ErIXkPipH/
	Dw6lIIf60s8hYF1kyfJAFDYUjJxL8lQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GahkMbt5;
	spf=pass (imf27.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774017140; a=rsa-sha256;
	cv=none;
	b=U9VzBx2pjhdc6XnY9mMMyCygFycQo7s3nmZyUphTB9S821Phq9thtAJROl+ckzAOiP1Vvh
	eK6rOp4DVeB8G3xkpMzPyyhfwU/WddDmAxHqIiwfC0i4fe85N7eqazCCCVYQzFDcGCltyi
	ObfmRd7xWlgMK10Lvu6TEFjPqXdWJlM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA06C43B01;
	Fri, 20 Mar 2026 14:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16174C4AF0C;
	Fri, 20 Mar 2026 14:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774017138;
	bh=pjKkpuJTqDNqdFPFCHnUMaKFMriTElNabT9wDx4wYTs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=GahkMbt5FMp1DK7FfXCrm5bAaoZtxPrfYmHySQhIY9KJCEz3JCd5OECUufWQKdPtv
	 erDtuuFcq2n32eNi3Vmo+kYuY3w8s4GxPvVkx1I/UumFlHE+VgmUsXF6bnyAjmYaJP
	 EcCJI/6z5OP97TH9B0IH7Bqmh8DaS/3Z9WtgsxiPOxl0tD7gSWT9ptntG02c5udKhM
	 Lbb/z3+rpLkrGGQqDKvVFYK7OzZ9fFPHmS5Hj2ndj0jNJexgmXW/1pVsQ9b28sUFbn
	 QWtsU8nvtuuWRMYSdpN9TxGTVNFLBbAoOtE2di1u2Po+YYlaZ8Bn/mtk/cvlhCuwzX
	 ahFpRME4Z65jA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id BFF9EF40078;
	Fri, 20 Mar 2026 10:32:16 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 20 Mar 2026 10:32:16 -0400
X-ME-Sender: <xms:cFq9aXjjJKnYZZQrqxZPP12ETP_RoqAv91P4D2bKoG-uRB-CJFoY-w>
    <xme:cFq9ae19QcecVROab9pSrLE3vn6CIv51RCwzS8rV1oVhdlnc2gxCEh-kMM3mvi7IW
    R2MSB6ZBEGxCqn31Gb6LfdZEuUCGDyACdAlspL4BkQPxo3fFT2I296v>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefuddtudeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeetvdejhfdvheelieegieevtdelgfdtgfevfffgvdetveekveelgeejhffg
    feeivdenucffohhmrghinhepmhgvmhhmrghprdhnrhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhguodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieejtdehtddtjeelqdeffedvudeigeduhedqrghruggspeepkh
    gvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurdgtohhmpdhnsggprhgtphhtthhopedu
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpd
    hrtghpthhtohepsggvnhhhsehkvghrnhgvlhdrtghrrghshhhinhhgrdhorhhgpdhrtghp
    thhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepihhlihgrshdrrg
    hprghlohguihhmrghssehlihhnrghrohdrohhrghdprhgtphhtthhopegurghvvgdrhhgr
    nhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtohepmhhinhhgohesrh
    gvughhrghtrdgtohhm
X-ME-Proxy: <xmx:cFq9aTfSA2oBX6GJaAA5qyyvG0mgaUgov9jMikJ7n1tm-SWyZjqk2A>
    <xmx:cFq9aYoPmSpOJiRimPO6JUcxW6rckwvIwWYhoAzAtm7W8PXWWWLLJg>
    <xmx:cFq9admehDp1NgrNHW2LI5b2sDZUR2Y10AvFO8_XXCKqw6zHor1KsA>
    <xmx:cFq9aZQL5eJ9e16N8XH79b3tAZeRW6_mz_AETcgwzlCfUJsN_c2M3g>
    <xmx:cFq9aTZWQMkWdqa4eN_oNNl3xHNXDOPWG8jIAIXQYNKrpha2ruCMU1m->
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9080070006A; Fri, 20 Mar 2026 10:32:16 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AusYBuezkfp3
Date: Fri, 20 Mar 2026 15:31:56 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Mike Rapoport" <rppt@kernel.org>, "Guenter Roeck" <linux@roeck-us.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Ingo Molnar" <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 "Thomas Gleixner" <tglx@kernel.org>, linux-efi@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Message-Id: <f9d55606-178c-4dc3-9f3c-94185ae4cbd2@app.fastmail.com>
In-Reply-To: <ab1U59ye2eBOz6x3@kernel.org>
References: <20260225065555.2471844-1-rppt@kernel.org>
 <100b9ae1-74cc-48b3-ba63-1a72cfa2ebbd@roeck-us.net>
 <ab1U59ye2eBOz6x3@kernel.org>
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C8B6B4000F
X-Rspamd-Server: rspam07
X-Stat-Signature: zxurciedmym5f7mppyfofncrskgehsxs
X-Rspam-User: 
X-HE-Tag: 1774017139-255434
X-HE-Meta: U2FsdGVkX1+yaJ9BptfC108+w/nL8kjRCvDD8ea8HK+ZBkvm3ldE3cLh2/KYw5ST8M8tCNDD4f50FN/6GAurOWVhoz9wGBwHAD3qTMGECf6V+jJjggqUlXHlnKycuvl2ManMRw0vOGLKEpEBxzUBY8/buTVkVZWTdY8oBWN4bm/qoSdQdvDTmHV8VWePySFoCuYwNB0f4njsQ1HaAHFgxNKxpSYIwelOP4+d57BuTdht4PtH2tOnS895G/OuVoNz1iQkvOPT2twT097qXRHtxhYX8WQRq9E+yIqvVG92YffbTg+aaba92S5mhcHL7Pdo/NVstFSPH1jfyDRlg/KSO2rmSltoV4JV+oNrpKCnozVxUvmPdT2MlJfocmHL88f0iF1v1nN33yPdPMICioDnfIibqKQN2gimx3QLEcV7YsJI3lXnaUXEEnr1qipnp/oTEH3ZQsbkda9ZHC0WMX52oOWymtwmuH78URf/LrEu9nzHi3CTE97ltp8/I8PkpJOZu0s1etKZCDst5Xav2Fc/WqRBXzJ3iHq+J+ToanlVPChTSHlB6sOUvcLLFfLNH5lKC5p16uwvNyCtRJKQNjA4OhZPuCc5C3m0fRUJww5FUJNrRyX4YnrSiDpOE29JqbiR4TDsgdkSx2iEFmYxwCsRGjyc3dUaQyt72KeiCEc5Y0vyH3rLoYz8GEviUH5J/jscpvmwGoUXCZeLx4us5zlvTFw0gort+L89AJwm6OKs2caqDdDVC00nZxoTqKaNd/nt41w5W5Cflj70M1eo0HxEkFHkKiX6X5nCv3+mjptDb5qtcBf+7TjgVYwQkjD9qi07ZKyumgoMv4iA5wV+HPWCuEwm8jQYembr/UExagodkd0h5EJePDdPahRXdqY6tR2EcxB9/w2hIToZJcoVAW2F9UPzh4DLhvzfv+obWMzcmGx7oFVnaSiMfZqVg+hvLPHyebYQO0PZrRZgHvd1dND
 PKWqZdmI
 Kjh2bUABv8Zfx44b9CVvr+zYK4qjvZwo8xaI8McBxheNWRL7VhMAFxyXGoxY7sHvRO9O2TOEne7DxWCphO/DnOLeLPEJ1pIpEv1QjjfY2Ady4jLsU9Oa4lCqtqjgVm/vSOkE1F46KZL5ZcT/OAlFwlPhKg6Qcw3lbZLqjMFvvd53teN+fTacjE6r1EM5kb+CdfUibtkJ23HxifrGN83l+cEGMZ5VOz/Ua0HdCDMdkSBbpz6xiqUocojsxH2arlERKVZORGYE/H2Uy4NRFKto8SRzGzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026, at 15:08, Mike Rapoport wrote:
> On Thu, Mar 19, 2026 at 09:06:52PM -0700, Guenter Roeck wrote:
>> Hi,
>> 
>> > +void __init efi_unmap_boot_services(void)
>> >  {
>> >  	struct efi_memory_map_data data = { 0 };
>> >  	efi_memory_desc_t *md;
>> >  	int num_entries = 0;
>> > +	int idx = 0;
>> > +	size_t sz;
>> >  	void *new, *new_md;
>> >  
>> >  	/* Keep all regions for /sys/kernel/debug/efi */
>> >  	if (efi_enabled(EFI_DBG))
>> >  		return;
>> >  
>> > +	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
>> 
>> Was this possibly supposed to be
>> 	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
>> 				       ^		     ^
>> ?
>
> Yes, thanks for catching this.
> 
> @Ard, can you please pick the fix:
>

Yep, queued up now.

Thanks for the fix.

> From 8fc5c5e828e7d127e6210bc9952451300591cdce Mon Sep 17 00:00:00 2001
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Date: Fri, 20 Mar 2026 15:59:48 +0200
> Subject: [PATCH] x86/efi: efi_unmap_boot_services: fix calculation of
>  ranges_to_free size
>
> ranges_to_free array should have enough room to store the entire EFI
> memmap plus an extra element for NULL entry.
> The calculation of this array size wrongly adds 1 to the overall size
> instead of adding 1 to the number of elements.
>
> Add parentheses to properly size the array.
>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Fixes: a4b0bf6a40f3 ("x86/efi: defer freeing of boot services memory")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/x86/platform/efi/quirks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 35caa5746115..79f0818131e8 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -424,7 +424,7 @@ void __init efi_unmap_boot_services(void)
>  	if (efi_enabled(EFI_DBG))
>  		return;
> 
> -	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
> +	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
>  	ranges_to_free = kzalloc(sz, GFP_KERNEL);
>  	if (!ranges_to_free) {
>  		pr_err("Failed to allocate storage for freeable EFI regions\n");


