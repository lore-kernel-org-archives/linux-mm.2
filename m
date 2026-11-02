Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F8AA606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hN2KP4pN
Received: by kanga.kvack.org (Postfix)
	id 9E3F76B05B3; Mon,  2 Nov 2026 03:36:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC596B05B6; Mon,  2 Nov 2026 03:36:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9436B05BB; Mon,  2 Nov 2026 03:36:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 674306B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:36:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2535C0C5F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:36:18 +0000 (UTC)
X-FDA: 85389522036.23.4A2F72F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 54C2B1A0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:36:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hN2KP4pN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793608577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71To1F+Ha52gfiOXVzuzWJ0D7FrFND/yLtAE+8lZwmk=;
	b=4i71BB1JM9x766Uk2o8h/d6jhTbHpFWOS0evq82BYYs2rbmGJ+X6svMI00XZfnyvu4DEV/
	kc6uVwk8N1Z45IBrWKTgLFJ95eiO7OeEI7sLygv142GF1LJfS86cwXoQ2oMW556aGGUWdT
	bP+ZFtofWRdsLUOnl1aXZhEcinWrQN0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hN2KP4pN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793608577;
	b=LNa293cCJld7VWtBUeZK86thdTG485lPgY/d2gJouMspP+1o5lnrguh/TCpVOgOzz5y1oQ
	tF68Tbi7jqePWtlDqRCEksIeeTAHvDqUWcgGaaOYLE5n5LH5OZXjunpMH39MAB2AGKVI1x
	RESZQe5mph95LzBWJCpUWD0Ky0kPAuE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C989560EF5;
	Mon,  2 Nov 2026 08:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698601F00919;
	Mon,  2 Nov 2026 08:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793608576;
	bh=71To1F+Ha52gfiOXVzuzWJ0D7FrFND/yLtAE+8lZwmk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hN2KP4pNFL2p90V8j3d/hLfQeX2QZzb9dkQfAat0qfzSTf5GYlqtJ1PzjKS3P2zkJ
	 RrjjMqw+iYfqFbInhZ3OrlHp5yEbrrPc+3VPUCVPVwd4Y77RXJWajAGWelPr76iq/X
	 j1acplbF3c8IQ5DGD30RFStFv7VTdoX+KHqeGgwbXJYgXaEen+icaidGQPc/upEpxg
	 QzHtvAqKv5xIeq01p4QdTNiIBlicUcI9sypwrt2z3DX8n04rS9oYy77b8b1NTVwBW+
	 H3n7kH9vKsu9goozvQPdw88H+cmY5p22CzQdSDTZ+7JEX2eFYcQr2pCjOPcyuiyy/J
	 iaAlGW95UJnlA==
Date: Mon, 2 Nov 2026 10:36:09 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Greg Thelen <gthelen@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Evangelos Petrongonas <epetron@amazon.de>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: check fdt_phys in is_kho_boot()
Message-ID: <auhLedAuD32WNcXW@kernel.org>
References: <20261023054518.3258350-1-gthelen@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023054518.3258350-1-gthelen@google.com>
X-Rspamd-Queue-Id: 54C2B1A0002
X-Stat-Signature: fss5giduwp31orss57gb5inidpsy34gk
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793608577-619160
X-HE-Meta: U2FsdGVkX1/NmuIJm4NlArkZE8qNC5r/tpc80F1bgGCPJldNYF1QT5GOwmWgPEQQu9pJFXfrsmJj+ydeqk7HLRKyp32u59VSpUOf84dl7YZnEd/QHtqiyQGi/MjBAAl2Q13kSHWcw3n5PdI3yKC25D+dynjoiwdVhy3RE9jM3Kdky5QGU2R4OzfvSV1RBxuXKGLn0cWbPXOrBwZ9ZMed1eVDEL44+3R0p2HuVCce3pmeXmLAy88ZMcoSuvBDQQGJZnXWdxlZkAA9+H3v/Img2V59d9dTaC6WxjpjczROqUAwDR+SrjUjM6P66r/iouYaoYOABheKoxxlTz6zJ5lMVKTLnvtYskWOwj8vQJ6b3E6xWpGyLIzMC+pNYUcYz5gjntZN69cYyx0m/MozmuyWTel37p6sZ8KbECUFrk/uLDQ9vrk8r2D0CckONtNeyiTYsBnQII6DmoGyTh7ouWWttEJ0ha5iBos/SAkn/FrfJf1cwHiD9puPdmbLGUuT6F5iiKkku10QSwfTWVVcF245UhEhwaoN9S/vJTIcRktuh5BNHVP0UktIpf/epyuhZC4/7+I8oZaNPlRYOACSG4w88DHe6XGK/GIMH4FBQ32hYsnezDGcDodRb8PF0EzQ3CGTDi33akbT3LpOWg2VkbY8XpLWk4wNTCnTjbgv8CEHYypHEBFfVKN5qADyOTs+DHaW5nDh2Ar3DaARS4XUEMusUGdTghAGMgxjAkgl/RSMvrraH3rgqFccpcpm047wsZOxna0wM4FErWokNLG1YFxqFcex8k5CBSqAsD96GayFG2tq/7cy9SPmnWnchQPbS54rKdEIsvGPDlkG5GvgcnPhsr2xjsH4S7S7j4LLrfM20vdP937dqDlURg4ULeUx7gSFKOByLTo5nnl0/ozUSzL9/l48kzuTu1fNTrLoNnjZzIU1skqqfmdMVb+rsLScObZRCigFhr9pei1aM68UjuI
 Wb4h6mkE
 CTSRktRnRjlzhNRoOlyEeWOL04NBfF/sQc8WrqvBEUK/rTDTbc2uJ7OTuvGqf1AnjnIHBNBczvUQvcj6bONwJzqILBZmiSE6uV+bGimKHW0VF4TgzMm1z/LdO4+Q3JzuMX0PVectSCDkcKXd9+k/3yIey6TSS1AM8Er3db9MWQHmU8Jj0K+13wQOVOM1/GF94SuH45q3kI7yS/h2JMp2QEhyaUvR4zgjbessJ58wBXcoq4e89RnZASabr0thoGVCTSymR8wuOMhR1XCJzsXwsdn9IGaK7WhKb8v6k7U/Sr96bDJPwp/HVtz5DrDU4za8y0BGv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Thu, Oct 22, 2026 at 10:45:18PM -0700, Greg Thelen wrote:
> During arm64 setup_arch(), efi_init() -> reserve_regions() calls
> is_kho_boot() before arm64_memblock_init() initializes memstart_addr.
> At this point memstart_addr still holds its initial sentinel value (-1).
> 
> When booting via kexec with KHO enabled, kho_populate() sets
> kho_in.fdt_phys from the /chosen FDT node. Calling is_kho_boot() ->
> kho_get_fdt() invokes phys_to_virt(kho_in.fdt_phys), which evaluates
> PHYS_OFFSET and triggers VM_BUG_ON(memstart_addr & 1) on arm64 kernels
> built with CONFIG_DEBUG_VM=y:

Can't see the forest for the trees ;-)

Can you please translate the gist of the issue from LLMish to English?
 
>   kernel BUG at ./arch/arm64/include/asm/memory.h:377!
>   Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
>   Call trace:
>    is_kho_boot+0x2c/0x38 (P)
>    efi_init+0x94/0xf8
>    setup_arch+0xf0/0x240
>    start_kernel+0x84/0x490
>    __primary_switched+0x88/0x98
> 
> Check kho_in.fdt_phys directly in is_kho_boot() instead of calling
> kho_get_fdt() so that early boot callers do not invoke phys_to_virt()
> before the linear map offset is initialized.
> 
> Fixes: d6d511639185 ("kexec: introduce is_kho_boot()")
> Assisted-by: Gemini:gemini-3.8-flash
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 7c4d86daf86d..d81baa38497f 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1630,7 +1630,7 @@ EXPORT_SYMBOL_GPL(kho_restore_free);
>   */
>  bool is_kho_boot(void)
>  {
> -	return !!kho_get_fdt();
> +	return !!kho_in.fdt_phys;
>  }
>  EXPORT_SYMBOL_GPL(is_kho_boot);
>  
> -- 
> 2.56.0.257.gf7497c7d27-goog
> 

-- 
Sincerely yours,
Mike.

