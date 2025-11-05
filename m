Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D94CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A718E0014; Wed,  5 Nov 2025 04:49:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2818E0005; Wed,  5 Nov 2025 04:49:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F0C8E0014; Wed,  5 Nov 2025 04:49:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B23BD8E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:49:29 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6569913A007
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:49:29 +0000 (UTC)
X-FDA: 84076080858.02.F00E462
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 975C5140005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:49:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UJmehP6X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762336167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSkImeW26wxHMAXfbe7WvrT7t//6KWteMn9Q9gZQJTU=;
	b=oKtCZXktoQ3WIwsJQqRf4VfRgUjqlPE2XgCOKOkqyG+FZgyf60PlRfdDdbIj1t4MZ2t7W7
	bqGZeiF6T1nMr1ir/9RE62Rw/RPuNyO713mKTOSU+2Lplu/kbPOs/NSIvNWDeL+1WgPlA3
	93gJDYatT2Eymxt6DbtyMbQF46uWe7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762336167; a=rsa-sha256;
	cv=none;
	b=v//1nwDiLX8A667tLkoJJpKXBHg3VyUOXQMC7XMey6StpMuDHMDbNID/bBg1ZDX28zG815
	tvWoCxj/NmRlFnT0T1wfk4s+AW1BAejgfRvuSYy4igddsR6yEBPhBHM8fH0/RUU/zfuwU2
	WREc3/yvU13yI+XsIJvP5ZCnAPcNcMM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UJmehP6X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b996c8db896so3614682a12.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 01:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762336166; x=1762940966; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=KSkImeW26wxHMAXfbe7WvrT7t//6KWteMn9Q9gZQJTU=;
        b=UJmehP6XMPeCHQLKf2cn3NUniRFHq8u8iRdbjMWgS14CUa+5ARiPOpumUSEeeQtl2q
         Y20g2sV5VvOht+Zkg6wpm3qgsDmZEfDwqZjwD2XLBRCWO+X/1DV1jUAfdQ7w3uN5vpwV
         +O4bKnPln0pdTrJ582l+ckAYBRLccm7K8iBrZre6dGM8xion7HvkZodCKJl0JKAVIoLg
         nm86Wv3poNyOjBkaKQrXSf9oE50kGeHRNsFC58ZaX/pYrwrtFPHXbvGTIXCdKrNkQGtW
         kYhQYk1mbJpiUB4WrExOdCRtdt0QmqJROh5DOsPZAY31ewocSXgtnzMftYjkw5NwrzZW
         mmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762336166; x=1762940966;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KSkImeW26wxHMAXfbe7WvrT7t//6KWteMn9Q9gZQJTU=;
        b=Oib0Owok8hTDBzh5fO7XckvKVHv16OBnrNY9+LwP9v3xkBBKoX1E0Sc8FRi4RPZZQQ
         3I3Dv7iXoykzoP1HCoKZfJMbpeg5kqcfpG/gHJ03jG4ctsbFFojTrtdAT7lMzxPiHefB
         WIoGSdS6mXRVG6L2VCth3nLK7wZ5vz/JDMy5BlA9eeSEwW8B/KNKuwqJFXfcTFrU4xz1
         v8QTMDmZxqrASXABE48NZ2bTO1TNUY4zhC8Bro68DY8IltP7j9smql/E4U6CESAJNQkZ
         8p7r/Vv3upiNctQ/GKE2fDHNz4k/8pPzSCiC0qBupBfw7S30l9TehCJLJq02RCd2PIUW
         4lPA==
X-Forwarded-Encrypted: i=1; AJvYcCUJI2CAGKRjkrnU+wFXaAf4ccCjxk7zBL7FK9qe9khjsEJqyZGpCRtFh2cOOK7FedZK2+Xvpv88vw==@kvack.org
X-Gm-Message-State: AOJu0YwBDDEZx+MVZN5zQvjgVJnNlU7+I8kgV8KdS4ifYq+qpVe9cJPZ
	yYU1wrdTjD91p0HAExDo5mZt0kIAuc1FS4BsYZP6j9CeCXPyuQDwnBTVruYMqPXi
X-Gm-Gg: ASbGnctHPaDk6Gz/mheagUorarCY+SGTu1wyF2FHml/L7GIAE4x2Czn2lH0Uo2nBh+J
	hNnAQ6HJtgHyjwI7m80+z4am5W4vKhxHmqzJQt+UnnCCJD3d/R04YHk+GepEGZk9Nr7FUmkPIKc
	BYqcUb5j+07buNwXEE+kZ2/qdk+8BxLdogktMy1ZQplKYbWHA06IGP41IUdsAXRPBL9EXURpDdH
	/DcI+SCaPCuV7zNUn1eRjkPnIaxvJUG1+ymtn9GnJGdlk/znSuTPXFiyyRtbDwHYHckgRmjClAX
	f1/CXWqkUZv2SmduagpZyi37XKN3w81uxy4/oJjQLO9NL4P2N1vkzod+Aw71x3DhaCxdsaIuE1P
	hlu+QUTpuPGCkYVgPZohSd4PJwHYfOcAaCGfqjwqKQxA9jGnMKVOe1ovRPAHtQPj0fWQ9fw==
X-Google-Smtp-Source: AGHT+IGvXEix8Ale69u5jY13ojKwbWl3rHLnPywsClHEKGLTCQBX8z03LTjZkKtfW5wInDfRAomLmQ==
X-Received: by 2002:a05:6a20:7283:b0:343:88b4:a722 with SMTP id adf61e73a8af0-34f862ff4a8mr3711914637.52.1762336166397;
        Wed, 05 Nov 2025 01:49:26 -0800 (PST)
Received: from dw-tp ([171.76.85.117])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba1f765f148sm5030694a12.24.2025.11.05.01.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 01:49:25 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, 
	Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
Subject: Re: [PATCH v4 09/12] powerpc/mm: replace batch->active with in_lazy_mmu_mode()
In-Reply-To: <20251029100909.3381140-10-kevin.brodsky@arm.com>
Date: Wed, 05 Nov 2025 15:10:20 +0530
Message-ID: <87ldkk4y2j.ritesh.list@gmail.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com> <20251029100909.3381140-10-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: u1w15gb5a17btico3f3tyi7tigztf5dh
X-Rspam-User: 
X-Rspamd-Queue-Id: 975C5140005
X-Rspamd-Server: rspam10
X-HE-Tag: 1762336167-812788
X-HE-Meta: U2FsdGVkX1/pP42cOvQ14UKIxo8B8k+shVmU1fygcoFkpgp3rSRd376X28eYJ4q4LHkVh49crAn3oiejAo+WOBHFFnn2hBG4hNYcHy7ONTZCYUmKIBSuq0UZBDfccjKIbLTjcynHfGdyWNBh9d6Kvb7/nUVsAS56LIuxPIhEs5qYPyG+mRAWXI+t98qv1qijtzfjdOg+Cd+wK2LzW2zhevlzi/9O5O0KXpxfH/8DEcW9clCA1VS1YelTM4Z2XqpV+m/uyAXhlueLZnjeUB0gcyj2IjVv8U3O7Pn17x6dLEnjCwJVGne74acxPbjO0TEetJImQn6cAXZ3Htk7nqBlspMBZANS6syfSBJZTxhVwSia/AlhSfQ6uGBOTo5dWqmJsS+dTX37jpcNehkipUGforo5kW7XHeUG0qZ2desrfyeYlPdVTM63MvlnoGKNujvIiPHeJkVTJpgwm7KSZPrXpBjaS3eYsupx6evO3Gvr+ftas3gsTocV0rayMZM6pKRPGrMv7E3oFY3Jah6SM0nFjBIIb6XDm1gh48xsiizncxc+uevlgaymTa5+TFaRExG0msO6QC9W8ez1oyqOvwDTmRGCpJYZ6vcK0+/Ekgx/EVfaaE+BBwYHR3WVRkVxBi6M9t1zL8fMC5VrkinAOw8jL3TZgzzh5CW90dG4QuSFMnsY8/SNLz3FjAx8oaLjt1Ke9cq/HrCdlCv6KEkdtSbkVLlgB1ymJROlWHR1mnDug3ymuW0D7XglfNbMYTwuYVaqEO/lfaKnJmOixqA5iDHvLhy4QmXjreySKDIls2slVG//6gfzbxVOxMGK52ObcAh+FT1Ogqh2VqTRCoMGAP23TNPoP7H3CqF5KaMNeZeBsBERXbJjmgBHs9zWLK9myltF5vxB3cNcUNX07ujWxUz022m/bVai1mbcJkAc4u5Up5+v/4Eu1WFpchuPGBQgEktWPdUwzCZjMheVxmiwQMu
 rXeuy9p9
 ptYRZLsFwnZgU/MqLWQhwb/cx7L6BKliguqBQAm9qU2A436USXLJLs9U6NOlVBlM1GKksYd2EHG0uuniaZF7uBHmreWgXHtVa4QpA0bMGEMKUagdd1eLV7Vsp3YAYPVOyknnEY+EpewMK7067DNeRZXNAmK4oPuVDtoJLVL6HVOGdJuOykkVrBt7+2klJRY87cVYh5NvZV1NAeptnULheXSut3UhsWvGiD6k9PNqAxT10aabBrPw/g0/WA6GfGBsv34t9m78iO88byjJmybRw7MNky3d7iAlcfh6hfMoL0gTzBoG2t3z5lj4FlzxKSMmXaLRmBH1yAxhsm9Wk1uPqZhOeSFo2iDbp8TFidk3nPePC/XQVuSQI/eusVGP4JO14KLXoIP5Kv05a++Oq3fTtIybx+8nix9tZ4IpLQBNyyW9nnSIoEv5H+iGh7NND+vcprYS9u3qKvWxO94B7b42YVuhCjJ168pBNRJx1th9xslwJi4NLoZRbBUefvq1iuXeBxafTLzzvgEBbp2+ExgvYrDDstR1zKT4mOetkiByQJbMaNak=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin Brodsky <kevin.brodsky@arm.com> writes:

> A per-CPU batch struct is activated when entering lazy MMU mode; its
> lifetime is the same as the lazy MMU section (it is deactivated when
> leaving the mode). Preemption is disabled in that interval to ensure
> that the per-CPU reference remains valid.
>
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode. We can therefore use the generic helper in_lazy_mmu_mode()
> to tell whether a batch struct is active instead of tracking it
> explicitly.
>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/powerpc/include/asm/book3s/64/tlbflush-hash.h | 9 ---------
>  arch/powerpc/mm/book3s64/hash_tlb.c                | 2 +-
>  2 files changed, 1 insertion(+), 10 deletions(-)
>

This looks good to me.

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

