Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65E8606A338
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WkqpfmLb
Received: by kanga.kvack.org (Postfix)
	id E072E6B05B1; Thu,  5 Nov 2026 22:58:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90D96B05B6; Thu,  5 Nov 2026 22:58:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7FFB6B05B9; Thu,  5 Nov 2026 22:58:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9983A6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:58:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D9D080C24
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:58:03 +0000 (UTC)
X-FDA: 85403336046.01.BD17B37
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id B79981A0007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:58:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WkqpfmLb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793937481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9akG+nDtIvJDcRYJ/oAtRMDaGCKBlqt1RbnUpTcKFrU=;
	b=J1GMLm8JzUs1OTsDFLrptf+eBfwOAfhvkxxIDdShirNbiK3xavqEM0f5igVh2stv0O9YUc
	yfFIbzxI80n28W6wkt0HFYtz7NI1XLKMLU08GboGMBdKVZBWUvD30fvKp9KCo3xwz1MONv
	HBg5ZnS8Xy1+7xvoIrGqOElBAuYKvj4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WkqpfmLb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793937481;
	b=LGSXyn+F3fGmo87He3HEaDzR5qOr4AaDTTf5hMfMehfPJplj5gM+LqfINuJ8P5qfV101qH
	ic4KqWihwkvGmrcZmAhVGmsd634OMzGoE0kBp4jietHJBk2iGm3+xDWkl72sDm++UwjL45
	L2SlXdvA0q9NwIR7/8gxltNLnn00LLY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793937480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9akG+nDtIvJDcRYJ/oAtRMDaGCKBlqt1RbnUpTcKFrU=;
	b=WkqpfmLb86STo6pkTZCgVlyjM8fHpT4OE0FMuHzSKSBdgnoyMuf/GlITl9h+0PL8XRmwCl
	Eb2NHC2uh7SqpC2sgeeWcgniXsv1SKxYVksWUdcMt/aB+uXuxzVGLsCcI4hk5fRpOISp/V
	YQvL4NZY/YsHTBmHvkHMXHxylitcO1Y=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-NItpbNvcMjq71dLQY-DXuw-1; Thu, 05 Nov 2026 22:57:58 -0500
X-MC-Unique: NItpbNvcMjq71dLQY-DXuw-1
X-Mimecast-MFC-AGG-ID: NItpbNvcMjq71dLQY-DXuw_1793937478
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e987ec84afso2594985ad.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 19:57:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793937478; x=1794542278;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9akG+nDtIvJDcRYJ/oAtRMDaGCKBlqt1RbnUpTcKFrU=;
        b=JIjpTTl6DnKdiu8vp61pP2ZXhtFHvLLu9i2OkVfECMadrZVQn3KbGZLltWJfDYjMOT
         ahXITOIjaRRKB3sR+OkLCe9IrkIDnCYsgEekb/cNbBEfV2QP4Nh/vMzRWqGZxcYQjHki
         Aln0N9r2EBbLYkaDISBsHcQfCqaEuqP5jV74RwiG2f+cy+BuvxixF5dk7KOJCyZdPrAj
         lBVOnRLeoepx8bM+Pdzgi+dHJsQVCfAUdokUCaB6Ki4Y/RgceHcS99CiqdAZXrqa9JhS
         d5t2Vc1uPuJd57hNKESRMPbOyh7N6bvb7eouzohMA6bOZm/1F+QyfQaH4JrSHR3bkaPJ
         U/Qw==
X-Forwarded-Encrypted: i=1; AL+hErEJ9m5hGPUcEl6M3MODKTOJoE3W1vORxcQmnNK04PIF3aBGXt81gHe9OQBYRzIuMpsyqduWvn0b1w==@kvack.org
X-Gm-Message-State: APuU4Z+4U/JI5jsI6lF5SbIF2yFthDSgbKAjQ58A2XxbSORszCcyoEKp
	o/0A2tFEw+AOZmfsAgjap0lLj62YSIbGJRI+dHQ9GY/VAlDY6RW83/PAnPy5u05sfpvUbG9aOVW
	lMJN0Qey1G49pfAd7Az+kJ0J1c9GLb8+mWnj4A/dfKboQojAJHVvG
X-Gm-Gg: AYBFou3z8oRDUzwCwKVdYiSpTfYqJS1xkj5NADlbUq0YyuJRoa1yLQlP6yTRET4xUNO
	NpIt9qkiGqzP0xNjA2sgGDH6s3jXSvsLDRkGwCIHkPOcu3mIUA00rJURhNlc0yiK9Ds6a3cgWUt
	G5N+nKLkgZwyMjxDbRmxfxV5o29WQD3Y9nB3RXZHrXD9WbSBa0lkGYdsIXwfGYBtB+B+74fXlHQ
	sL+mZCNZLbUTR8Z6Hij3/dYhn83M0FDFTLX020uFriGFKiw4g5pcXXJ3UdlvNw5M5HaVPbVvq1Q
	NZi/S7cCMmYix+8Q1Xf2k4LoV2t/YIZxaFRNzbeE8XAP0BgOPSYvkisUBlCtpHn9bdGIO6pHrc9
	EMDTTemagVrxv8yS6ZAFZiDoxEyHFrJVEfPFEvkfSk8BXJ/8iA9zeIZpWLu8hlbbfiZC2lspkrh
	HhBUqYveIQViQlMJbpQDPZ0QlGFt5uM8kgaA5izQ==
X-Received: by 2002:a17:903:3d10:b0:2ed:69b:9e76 with SMTP id d9443c01a7336-2ed40c59069mr18818615ad.28.1793937477685;
        Thu, 05 Nov 2026 19:57:57 -0800 (PST)
X-Received: by 2002:a17:903:3d10:b0:2ed:69b:9e76 with SMTP id d9443c01a7336-2ed40c59069mr18818435ad.28.1793937477119;
        Thu, 05 Nov 2026 19:57:57 -0800 (PST)
Received: from ?IPV6:2401:4900:1f28:63e0:a033:fd4:21a3:8f1? ([2401:4900:1f28:63e0:a033:fd4:21a3:8f1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed477a941csm1173495ad.18.2026.11.05.19.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 19:57:56 -0800 (PST)
Message-ID: <d928099c-4e43-4af8-a929-b510819967ce@redhat.com>
Date: Fri, 6 Nov 2026 09:27:50 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] memblock: don't allocate new reserve_mem regions on a
 KHO boot
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kees Cook <kees@kernel.org>, Changyuan Lyu <changyuanl@google.com>,
 Alexander Graf <graf@amazon.com>
Cc: Tony Luck <tony.luck@intel.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, linux-mm@kvack.org,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
 Pratyush Yadav <pratyush@kernel.org>
References: <20261105213153.9572-1-azpijr@gmail.com>
From: Mukesh Pilaniya <mpilaniy@redhat.com>
In-Reply-To: <20261105213153.9572-1-azpijr@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q7QWksKl-A5-tLPeLJaD32tAzcqx2ywAckxOvCv27NE_1793937478
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B79981A0007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: md87bmdgttbr9afhc77mnwbkm7mtkkjs
X-HE-Tag: 1793937480-97505
X-HE-Meta: U2FsdGVkX1+/8HnwSqbVmCocqIlT5Z/m1P/3Hx1igZOe69SQbRhb3xM5hw3NwLOTvfmpU8FRulUe3//P1ZshDSfJ1GVy7smlF/z6GKGdRhOqc2dOxULimMBn8eg90G7mIdOLznuv2QOoL6mxeZR03TXq2u+xhbtCKN1RPo0NRQX4YpIe5im/mkK3tMTwZyp2t5tHyIEinTwMimFFqimLXa9pkzdq/kHf9M4ilSCRi0+ldoXTxHnnvtocOtvf25VE7T4+JCxR+D6BpGTvzhEzSaEnPKK+Rxu9wUfH7TfVPLb9L6hMKFa1khUt9VsmiQlI34ZCrGrTXebPiz/+IapVlivpkdhIpERQ3dKTvUkAZDq0GCuJ1/qLnaCXEvE8si0aYhHoQJNK3mXyG4OtUM8YiqOn/+Kd0fjlvZEVwPoooC8eBoZeDoCCsbvaXyP3nDeRFwKg9SOwlIntH0JUGT2VB+p+ncoiPk0TP8rMt3toG74iJYKZEOg2mXbzhuc9Bp7MMwzknrtFcMC1O+VCiDPuRn+LZOAmSvviWXYF8C2PwcdPcv2rT3PTW/C7fv7bgZswTebVqsxgimlvDtedPL0CaWisADVSWxwDOGUYJJFPIGtLoSs961UkVMhqOwBwqbVMerjQgA25Fro1zi5pPDAo3FodMhpltNM0Teo/G3mOzNoRUDTouuuWHD3955+1m9mcIG8UeUiNosD6f0O1byrzixuH+r1NJus6dBm7CG019cxy492fOPuttvwVLl2/ckeECaq3Nhb08izkaOElnpSbAXPiOH7XBAzj7DUDNA4x8Vs1YUE60HojLBXPF7qXX3UalC2KTrFvry/f56c4nwj0ZNLyBKvlRRTZbEv/W4JExaidOdDvKNz4tnG5M6r+b/TrGM1oxcTTikPD1jPBZqvlpl2xgFONEkB9Kyd7WCI65tu8Y+M7n6IhH/arTSSbFm/ICc+pqjZkQeG8aOxemQc
 SbSOazZv
 rjFuOVXo2OKikdxqHbfzCH/K7FonmaHmHI0bxs02VuBhE6H+82hOr2+vTR0OT99PyRxF0YYCdyMQqV2gqiW3raEO6IewcsEfDWzIwNh/Iv4TJxp3AK/66RhXn0Mfg9fj61tb5My8Lnf+GUDnUbrEEVXLCF4pVCmFmpf53iDjuW8b6SLGoIOagTgsGMlcautqjz9h0+5GRYa0GFhBsUqZDLNHBpaCnuFTHsIovBdbW1m3Wd/cqoJrDIY0Mwf5Ehsknlqy7OGrK59aJ4+B0plC/grxrh3r9g4TI6rMacK/Bzvj9cOGWWhpPl2jM8Jb+T4I/yHHLtQqlVYWHkXA/N0o0N6GObK+lz9prwiMGLxDq5ampzj1C+1QoPiGEGYu9SkKPWHHzy2eTzr2WFL3NcKBPPgQeZOeGhYRMCc/VHk/NA1eyzpT/DUl8UW+Vz40JzrrO+xGakOjVcNpEknG9kIGplcn2VAqAjduQoJ39a2wtjD1zlovOB1RTxHZLF+WOlZh4DumP4GtOf4zTX5Quw6tl4jbBqxX+4Ijtnijw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jose, Thanks for the patch!

On 06/11/26 3:01 am, Jose A. Perez de Azpillaga wrote:
> On a KHO boot, a reserve_mem region that can't be revived is allocated
> from KHO_NOPRSRV memory, which includes the bootmem the next kernel
> boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG, preserving the region
> then fails:
> 
>   WARNING: kernel/liveupdate/kexec_handover.c:1245 at kho_preserve_pages+0x168/0x180
>   failed to prepare memblock FDT for KHO: -22
> 
> Without it, the next kernel puts its memmap on top of the region and
> the ramoops records in it are lost.
> 
> There is no use case for adding regions across a live update, so fail
> instead of allocating, and drop the TODO.
> 
> Add an is_kho_boot() stub so the memblock tests still build.
> 
> Fixes: f99230780211 ("memblock: add KHO support for reserve_mem")
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> ---
> Changes in v3:
> - add an is_kho_boot() stub to the memblock tests (Mike).
> - add Pasha's Reviewed-by.
> 
> Changes in v2:
> - fail on a KHO boot instead of allocating outside bootmem, as agreed
>   with Pratyush [1]. this drops v1's patch 1.
> - not an RFC anymore.
> - based on v7.4-rc1.
> 
> v2: https://lore.kernel.org/all/20261104204235.9066-1-azpijr@gmail.com/
> v1: https://lore.kernel.org/all/20261021211058.83483-3-azpijr@gmail.com/
> 
> [1] https://lore.kernel.org/all/2vxzfqxglrg6.fsf@kernel.org/
> 
>  mm/memblock.c                     | 11 ++++++++++-
>  tools/testing/memblock/internal.h |  5 +++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index a450092a80fb..e325e0542c9a 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2827,7 +2827,16 @@ static int __init reserve_mem(char *p)
>  	if (reserve_mem_kho_revive(name, size, align))
>  		return 1;
>  
> -	/* TODO: Allocation must be outside of KHO_NOPRSRV region */
> +	/*
> +	 * On a KHO boot memblock only allocates from KHO_NOPRSRV memory here,
> +	 * which includes the bootmem the next kernel boots out of. Only regions
> +	 * handed over by the previous kernel are supported.
> +	 */
> +	if (is_kho_boot()) {
> +		pr_err("reserve_mem: can't allocate \"%s\" on a KHO boot\n", name);
> +		return -EOPNOTSUPP;
> +	}
I think this over-restricts when KHO is explicitly disabled. kho= is an
early_param parsed before reserve_mem=, but kho_populate records the
incoming FDT without checking kho_enable. So a KHO payload booted with
kho=off ends up with is_kho_boot() == true and kho_is_enabled() ==false.

In that config nothing can be handed over again; reserve_mem_init
returns early on !kho_is_enabled(), and kho_fill_kimage bails on
!kho_enable. Allocating the region from KHO_NOPRSRV is therefore
harmless, and the documented best-effort reserve_mem= behaviour is
preserved.
That said, a new reserve_mem= line is rejected and its ramoops/ftrace
boot-instance consumers lose their region.

So, Would

	if (kho_is_enabled() && is_kho_boot())

be better here? If so, the memblock tests will also need a
kho_is_enabled() stub, since
tools/testing/memblock/linux/kexec_handover.h is empty and reserve_mem()
sits outside the CONFIG_KEXEC_HANDOVER ifdef.

Otherwise, the patch looks good to me.
> +
>  	start = memblock_phys_alloc(size, align);
>  	if (!start) {
>  		pr_err("reserve_mem: memblock allocation failed\n");
> diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
> index ba4d1c02fde5..84f22a964510 100644
> --- a/tools/testing/memblock/internal.h
> +++ b/tools/testing/memblock/internal.h
> @@ -51,4 +51,9 @@ static inline bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
>  	return false;
>  }
>  
> +static inline bool is_kho_boot(void)
> +{
> +	return false;
> +}
> +
>  #endif
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4

-- 
Regards,
Mukesh Pilaniya


