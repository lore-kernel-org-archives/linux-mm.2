Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E211098786
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20A376B0119; Fri, 20 Mar 2026 10:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1DE6B011A; Fri, 20 Mar 2026 10:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F8C6B011B; Fri, 20 Mar 2026 10:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EFE726B0119
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:08:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B656A89D30
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:08:49 +0000 (UTC)
X-FDA: 84566622378.24.627E13F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 202A3A0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:08:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NhAaxFSr;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774015728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AsIfkw4DSl5JAS/CdG8EekIlxgyUOUGLXJmYbxjdUY=;
	b=I8VzGmELiq4CuR+JFEfy9cP4aN5oicaW67qME/Mp73nhhhajgXV+iKykhBiYFTUIcGF1Bg
	C2FKw09ZGdrSf86IJk8zLBbAid/5cCHqfE6hQ+c3BKBNbJv7yhOGWV4OBYpEY0c1Tq8thO
	is6uaO6NzbOrjkSr0L9xnWSu3CIG8i8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NhAaxFSr;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774015728; a=rsa-sha256;
	cv=none;
	b=Kz/DXKwkAina3PokEirYUjZPCvaiQR4tzL4kozgyjNIFNvohI05CqBIFIjNM1/LWeSTkcq
	CqTLOUtiW7fI/nHW1+vzf/8ebqOJlvQdfJWfn8MJG5GznE2rva+Ax9sUMyU1CQg/aexKW/
	7tCGagi7YwUVd9J9ePHPYPtALRJS4tw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 770666185A;
	Fri, 20 Mar 2026 14:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281DBC4CEF7;
	Fri, 20 Mar 2026 14:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774015727;
	bh=WVfZ6L3FLNwGx30VAAwIZX8hW08FXLNTDmV3F+t04M8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NhAaxFSrV4BUv1KSuYXShMeuUJzOWECv9F5WlASjf1RgEmQiERGW2NKQ1HK2d1LkF
	 yuQO86/wJx4eBlMJhreQPiApetKUnm1bWlXZGfqxHgjIPJ05zE+5QKpBsDWp0oc9dW
	 bvyz2++8asRAjzLChvN7iVZ/WKgyiB0Z/zGbZSjtSHZXD14XE0MGBATfVywy2fv7E3
	 kpGnRjXXvtFpuJlOb3mEWUag/IKfDzOkhcp+3JlIr4GnE3b0jgXiVE7lC5ag1efQju
	 6BKgUM0Fo2tZGyolod/yUxlZClln7KfD2GVAF09ve6dLkCXL1/TjijDwMU3lPauReF
	 coD04aYxlRAlg==
Date: Fri, 20 Mar 2026 16:08:39 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@kernel.org>, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
Message-ID: <ab1U59ye2eBOz6x3@kernel.org>
References: <20260225065555.2471844-1-rppt@kernel.org>
 <100b9ae1-74cc-48b3-ba63-1a72cfa2ebbd@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <100b9ae1-74cc-48b3-ba63-1a72cfa2ebbd@roeck-us.net>
X-Stat-Signature: 4k5qg7wc9k5eodywkofo7pae5hftdeer
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 202A3A0005
X-HE-Tag: 1774015727-451894
X-HE-Meta: U2FsdGVkX19nJq9AuRndYyV92r/oHBYyFU4IrelG3q4CG9+/xYB+lANePz31r2C0lDofNIxNEn2ugaSQSfaS8aE1ipMRa9TNdwUCaSDgnS4RSpSqHITXespkey1rzYI2cvd70fwNLIAmRlEx6o/ObFF+7eIk7x1DLwFnTJSGMaiUnO2AJprBrDrMV+N3UlebK7Uw/vSVoQBQ3pjp9JjGpdlqz04c4GumYG08l3APyEbKa/FroA4zMzXkCUDL0d1al1+5iaiWjZ89tvfqCWZP97hpgUavdWPup/277UfB7S2B7Myh5IcfCuZkmQ0TbK+1llTUvqqFwnng1lkY3QKtPrli1mb8/ohynZAm+FiMEmxEGJip3wVlpch8zDQCYgG4j8ypBLpYedsfZ7eVQ9KbCsPGiGpyVHNf1O3h5X9pchWKv5ZwjcNRyMoQpHSjcCq8hdZBUZoYbzHys+x5S/sA4HNwdHbBURgIkGIL94NezDGli9ywXR9rqcPtSkZsPTPpxH6WNVsIcZpv6tlrzGsoGiotlvrcyF8KJyH5gNu5eWKGT3jZKrpbdfNScO4VOVqKsn2QyApCpM71Bj48MbCw38uVLhS5387IwFtuDE9ulNWw3EC9rHOcWXgb6178VD+VMXWIWt7H0zg/5HqNp42VXTV/YlaxkfpIv7LCSKVnCvyFdxompFVAd9uzPGS0sblWILl6mCcZslfg1g1ygBM68Qh+3QYAPD1hWngpJ+WdLudPxOyZ5TkB3ie9JKUfdeAkl5vwiL0Q7nu0Rg9wy/UlYLOn5jq7749fAM6MMiuBkLJB487ilIbgcECj0kyepfnqCt58hEDL6qoJgORmTAHIDbAXje43KWSED4pEhCTwrvZ81kesSpKkM2f098KcghmON9+DLq8XwC1YNeKbb+g/otSn88i/xXuGXg+yJCaKZtNFlKvUSyLp6CzxZ7YEHXcfQQF3ILL5ZvLxD9U/4I6
 uwoolMCf
 O37ppQKe02s5NE5ptRQuzbKn+1VUTlU0fPKTOniXbfrjDZ6KFR9OGdqC5yTKNKeS3YwWASDqkMH/wvTbs2j7xr9bED9jOq0iTAe7XlaMgfsFcS9qT0zSiGpIoljATUiePWHfWU9LjRO3rOQRy2LHbi3B2z6UXfnpSacvDR6TNqj3p6Vyri4Dg5kIroBalzuNzK2hnNNJ9oU4+BHELn3onh/NpznaoWmpMXcxw6QRs0Z/aW+JAlIC1stZ8Tycn24r7bwUF9U7IG9bSplH+rg9OiFzWRIangHzHJkvn3Hw9TwWy9/Ex8rbR3ZPTb8qAM36fnc6hKMnguN98zcjomYf2QAOx8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 09:06:52PM -0700, Guenter Roeck wrote:
> Hi,
> 
> > +void __init efi_unmap_boot_services(void)
> >  {
> >  	struct efi_memory_map_data data = { 0 };
> >  	efi_memory_desc_t *md;
> >  	int num_entries = 0;
> > +	int idx = 0;
> > +	size_t sz;
> >  	void *new, *new_md;
> >  
> >  	/* Keep all regions for /sys/kernel/debug/efi */
> >  	if (efi_enabled(EFI_DBG))
> >  		return;
> >  
> > +	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
> 
> Was this possibly supposed to be
> 	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
> 				       ^		     ^
> ?

Yes, thanks for catching this.
 
@Ard, can you please pick the fix:

From 8fc5c5e828e7d127e6210bc9952451300591cdce Mon Sep 17 00:00:00 2001
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Fri, 20 Mar 2026 15:59:48 +0200
Subject: [PATCH] x86/efi: efi_unmap_boot_services: fix calculation of
 ranges_to_free size

ranges_to_free array should have enough room to store the entire EFI
memmap plus an extra element for NULL entry.
The calculation of this array size wrongly adds 1 to the overall size
instead of adding 1 to the number of elements.

Add parentheses to properly size the array.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: a4b0bf6a40f3 ("x86/efi: defer freeing of boot services memory")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 35caa5746115..79f0818131e8 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -424,7 +424,7 @@ void __init efi_unmap_boot_services(void)
 	if (efi_enabled(EFI_DBG))
 		return;
 
-	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
+	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
 	ranges_to_free = kzalloc(sz, GFP_KERNEL);
 	if (!ranges_to_free) {
 		pr_err("Failed to allocate storage for freeable EFI regions\n");
-- 
2.53.0


