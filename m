Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9A8D2D0E4
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20BDE6B008C; Tue, 13 Jan 2026 07:33:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6246B0092; Tue, 13 Jan 2026 07:33:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F65C6B0093; Tue, 13 Jan 2026 07:33:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F386E6B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:33:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A453957AF4
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:33:30 +0000 (UTC)
X-FDA: 84326881380.16.2471C6D
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id BADFE14000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:33:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a4oUAQ9q;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768307608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4BCb4tuwUydlXX/lekB/MWAbo5xTWmBY98lhxIZgCk=;
	b=nkyxAaeGaP6ed6C84pefB5QtCwx/4LiktT3ZwTs0pNQjedLSs8zLfDIVTE1+lIwMZQegWY
	NZZsKF0y1qgvDf/pHy81PQBbB+NB38qbH1YxlZQCgjVGXNEvS7mgTxVu29VCtgm01YFXpS
	/NdX1FBuPCL2Z8DDR+SLkvhqpKL1iSQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a4oUAQ9q;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768307608; a=rsa-sha256;
	cv=none;
	b=01BHCHzktJ6SRLPYOFAu/eFeT/ctB+4EH0R6LDyBqRylVB+dyM1tJA8nWNc8+2/PKdx+/r
	u02qc/LfqQsmQ0aDHgdoaXUADqgAyTGlHaKZlGntE3vcUnnZUHL4UCdfu05UuJ6XdGIDqH
	nzJsPYhxRHxBVgAFVB7HO27v66C4LFM=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c0ec27cad8cso3172091a12.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768307607; x=1768912407; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=j4BCb4tuwUydlXX/lekB/MWAbo5xTWmBY98lhxIZgCk=;
        b=a4oUAQ9q4vBZkmbXsQl7pVFOTt0UxGh0V3LZnVxXdWONm6v97dFExO3qvAVlSljB8r
         9TfPvcrRfo4BQdlN+0e8PWjDiZOY2UpFjvnlbWF1FXeU/qIHwn84FmZvYXUoj4dNK+Dy
         WtbuIN8p29s+VMx9SzXBlREyI/hJA59JoNHMLvGIRujero5QUjeIqE3NYadh+2mNpUB4
         gE36OF9HgouJKxEwP1uq60Pnfe1M/7CIBtMvHR5N9poWHZe3laYMVmE0QibFSVCUzR0P
         shqfDSKh1myPhWstaFz5mhaGPQQ+0MMuwG3xi2GHUuoodfybunPJBvaoweYVpsIOCnmw
         Fqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768307607; x=1768912407;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j4BCb4tuwUydlXX/lekB/MWAbo5xTWmBY98lhxIZgCk=;
        b=k3jaEIj1mbmDmUkqMYWn0xucfWMN3jCHKoUcxsWDJKByxEDO2XMyLy21ge0zUq7fwM
         ZiCTbC661tLmmfoze6AH4gkGnRolgiGA2hACWz0LnvCex3wd3JpU9ApegCXAaKeB81TL
         kKrSoifJYTSoTYcYj8SDVMfWb19uBQUaX2Vwqf4CXJ7IPmK9Sk7g22hgpXzaKAwbq6PO
         PYzSgXlieke7Q/lYmsLkz4UhTWUui7Uq6sMTo8XzUeZse/5YknIFjj2lgpnjxs3xwaJb
         fTVQsJeIxq2fCGYWz7ug71o+O87R5nXM9CTEuZUN6pOxgt77JAQqLK4dsBOdCoL+y+W5
         tAOg==
X-Forwarded-Encrypted: i=1; AJvYcCUPItFyo6dfpUjOh/h//Xa44EZkX0vQNrY5IvotB+r3vhvG1I5VJRQthTAsHZUgqsBjX5lmjXoULg==@kvack.org
X-Gm-Message-State: AOJu0Yx56t0bAZL6cpD6O0F/3AzAECO/8wm4FTuVkZh5sTeoLeYc4/A7
	XW/41CRLzY9ka1UePM+fTMxt5u7AM2ZQ+lzHTA8ytajB4Ee9qHUDx4tl
X-Gm-Gg: AY/fxX7WuEImGJjEeqVFXTOBmCVVAmvd+dPqAMOIc9Q5q9yVInqbqgBvbYtvJzEdhfV
	aLkHIglyx47FdxmDvcgdCNwMEc4rGGyko6DZgbldLj0IdzBG+zPEtEWAl0zMk17DXbSSI8L1G1B
	E/CdtDWSCAQq5qN6BcWkKL4X/5Q46f7AhjxKFwChM7466+CWRygm78SzgU8rQmlfg9yMvPatrBB
	R/Le+Gl0tMioP2sE05ud8jEfkpCbd7JZnoFQaVLnkXp/S9hgaZsD6cX+dYRiWrd1K9aLNFJUBoo
	DLJLiq9a3e1SpqLwpSJ77SbGeEOBZsvqEz0IPQ+3QZ3IjKD3ph8kSI9oJt5ny78BlkzTyguxq9A
	ibd5rF6tfQ/9GWMSH8HA+ZtxVADHhWiLs91p7/4aMv6HGg9q27BQ3fEr8zAPpPNrX8aMgfxiXzF
	ay1Xpy
X-Google-Smtp-Source: AGHT+IFw8NQUhXWsNFLNcy9VnhtaeqSccMp4bageDierszWlx1Kxyih6osyfD1+uAcqTN4o2oK4SYQ==
X-Received: by 2002:a17:90b:3ccc:b0:340:9ba6:8af4 with SMTP id 98e67ed59e1d1-34f68c47f0amr18570023a91.35.1768307607428;
        Tue, 13 Jan 2026 04:33:27 -0800 (PST)
Received: from dw-tp ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-350fd6e343bsm1428958a91.1.2026.01.13.04.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 04:33:26 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	"David S. Miller" <davem@davemloft.net>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Jonathan Corbet <corbet@lwn.net>, 
	Klara Modin <klarasmodin@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Magnus Lindholm <linmag7@gmail.com>, 
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Richard Weinberger <richard@nod.at>, 
	Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, x86@kernel.org, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-csky@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-um@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev, sparclinux@vger.kernel.org
Subject: Re: [PATCH v3 15/29] powerpc: introduce arch_zone_limits_init()
In-Reply-To: <20260111082105.290734-16-rppt@kernel.org>
Date: Tue, 13 Jan 2026 17:59:49 +0530
Message-ID: <87zf6hu24i.ritesh.list@gmail.com>
References: <20260111082105.290734-1-rppt@kernel.org> <20260111082105.290734-16-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: BADFE14000B
X-Stat-Signature: qs8p55ee384x4cxo75whco1df7ioa1xt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768307608-45426
X-HE-Meta: U2FsdGVkX1+8mV5am8GNJKkkom9rrUgGuTjK/OAKm6caR6blhavUcOps4GZrahEuQRvRgs792xCo4iVgl6wCU2OxMBperb6+bw4+HzaA8hPgoUoPsDNAeNlAngdnnJIWiUb6i+8/R8hpntUk0VrgudipT+yeNrXN26Kw1YrWrn/NNOrLRv0QYiilcCBdwsKYfFH+CEq9O5lYBA8YRxpDVMHZNaPnN6dAmRm+I9nGnrxJ86/hrZfX5PoFcVaGZ9nRO9Fhr0NUfuQB8I5eAhA10M+IGD+30zRs3O90hjbdSNYkkkS3qagDDEi+o7OjSp96jfttKY3mvX02SJnkQ+NxRbrZ+zayz5R0Gir164XS8FJwb1Vaw+ntMV40yDpfIgSahaZ1R1N1zHHX/kc8lB4ji/5nhhl010wvocnr/p859QgFEjruY13jLrfU8OT2UNzBvFpDoxlEbq+zbdMG0Pz2eSSoX5jP3aFQq00QNyYMZiRSfcu3BcMTgDCQzjGRcXdXXIZH9zxkn+VmyNQYrxfzAbovYv+ZTFT+wKoFP3Beraro4zc91bsEdZ4v2eoVbGwLiiKlOrBnIJ/hnyy4TTbLy1Q8hVY9bbCzL11W1EWXyibIEnlDTEJgiocmr+a5VnN+DqX5pdaRMLU21gFKKuL+SDnzEFa7mvL/J7a3YcO/2T/u9wwdOHkECkyXH+a/ltp2+0O9SmlEhMQ3n3f/THGwtCSdTQookDeEUFPh3QSeBcoQyHYyhdcDpGET/i6HwX0vSB2z4jsprpt2JMljA2mRdM+D96bP6S1ZOkarINfd6LxBN8C7e/6X7AonWoBDvIeh8POfgnT+oPnyU69nejUP3l12w/RP2PyhFL7yn8/0oF/hgOkaHaoGrFJ7Q+KeNFa3wHnvAA9v+pre+R2Rh0UFFbI9+474t0eYZHxu0E816BsHTPFWMy5PAjtKlkM+hw5320/wYc8zIF7XV1O4Eqk
 YPl2E9Sp
 GqAhmEN6IPgOJ+rC/0MFmtwQm4GEtIZl9Hty4w566uPvUG+gpNT7nFyJ+M0WA/gC3qKR1sECPoDHvmVGPlR4wyX9RATbCs8hcwlz6qblNPfr0C7u7CLO7gMMTWBTqkqr+sXzgeyfrI/3vWFFz46rVeKkPptfTeppIKNEtQRFFoRo0nUh/dUFrq+pl++ecrEu/R5i2LXFy1coGtKioT6b8u2d0hlZ6asnj7iSwl8dwWzg13QG8eH5YrdiqARCiF8kTxZnpNLTdR99FQj2ckXk3ltvdcuYTwmaDuKM35opmFxlhIJZH6paLUKFWLlltZtiJFtI+HNSQRR7NYvRppZuh1qtIpfqkyOz13YV2XuYvLDMBvZrbG/AQUlhSsZgs5KUdqLPXQA9DD6l8qeE2HE6s9iP/FoRA9inbH5yTRpsX9RyC8C/9/Mrvqcbzr0DiRks3jS14c/SjRLHep+FBpcOvXT28ZPF5toL9m81Bc85E0vJw/kU4Ert/qj5izVeZlumUgUEb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Move calculations of zone limits to a dedicated arch_zone_limits_init()
> function.
>
> Later MM core will use this function as an architecture specific callback
> during nodes and zones initialization and thus there won't be a need to
> call free_area_init() from every architecture.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/powerpc/mm/mem.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)

This v2 looks good to me. 
I have also done a basic bootup testing using Linux PPC CI.

Please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

