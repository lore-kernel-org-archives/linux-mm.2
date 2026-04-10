Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A02ABE99052
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 08:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1C8B6B0089; Fri, 10 Apr 2026 03:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4206B008A; Fri, 10 Apr 2026 03:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09D46B008C; Fri, 10 Apr 2026 03:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFC3C6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:59:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DE738B8B1
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:59:59 +0000 (UTC)
X-FDA: 84641897718.27.06E357C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id B2A27A0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:59:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bk0e4BNX;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775807997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=joHTFbhY3Xpp9kkK3lQ0iapaVEXdYngH8K+Bki/pKZE=;
	b=kqckTZnPpRSO3vvVX1PwCfQZA1uz/chVN5chul2PT7CWgaK0HAiynSfdqyGiCuru/gmreh
	YhT/oijQJpVVqHhBelz56bnPE93z/gmEnQYQFrO2dSKotfhrfGGme27nBB027aZAJARZuJ
	fUVLQ4e4uG1dWfcrJNhZizp6uTINwYU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bk0e4BNX;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775807997; a=rsa-sha256;
	cv=none;
	b=e2HxfRLQqOtlPjG/AxL7WJvAzoWg5+YhjbZVLbpBfOpQptB1lW98GV7LcSmDL1AISdgnOZ
	IqYspvgSbhchu7nzjqlGfC2FW2f0W830U2wYhkgzUVRTzHBFshIjdMy/Hryz+tX2VFMs0e
	NWJCYQd9XRcc4bw2v9KZUDU5USbOsLA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7E2641853;
	Fri, 10 Apr 2026 07:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E4BC19424;
	Fri, 10 Apr 2026 07:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775807996;
	bh=SxrLNnYLw7RM2+RAMFd5Z9aLlerg3Bl5esgirC0unYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bk0e4BNXD6Yt7f4mKRojtk8ruecTagIIEG5ZStNZDXOJpUmflQARjCnJhnRz+paso
	 roEnmnTZ/3YOwcWe24nYpk6kuNpdCBLakaiK6zYS+gzTDqq+QmsSOQ65c1vUMYn2/E
	 tCcBDdNjvnqRhAw2ZL2IpfCQ5+NnBVg9CogjjWTrHur7cL+kyD3ZDma3KswYbArbZI
	 zFuoEqE5eTB6wRIQI5VVRjH5zWbWsl/Yoy2UtK0na15HGAg0ukDR9WwlFRSKyB8Q5H
	 ncK6y9yjMjyAMKOjFOa4svGHzlTF37gjH09YIdRl2GFIuzKWmdirlkLYsXuRmpqj8x
	 lXfm1lzH96/Zg==
Date: Fri, 10 Apr 2026 10:59:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, nh-open-source@amazon.com
Subject: Re: [PATCH v2] kho: skip KHO for crash kernel
Message-ID: <adit9fCs2O6t3vd1@kernel.org>
References: <20260410011609.1103-1-epetron@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410011609.1103-1-epetron@amazon.de>
X-Rspamd-Queue-Id: B2A27A0005
X-Stat-Signature: 6qwkcbm7qkawr3s3h8iqrxgux5aqnxbg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775807997-640355
X-HE-Meta: U2FsdGVkX1/bR2FL/+1BFvIt5nmzoESR85jBIyfqHRDLw7kwlKtiQ8PVXI2Dw8v71MigKCTaqsQei41GoVDX0sehGMZDJqf8b+xRbvvFBJlyKA1MHYN03uVDUaETkymbvL6qziD1XRcDE39rNxkFpkpoB3Q5icb1oX9Toa0eW6fChavGxjHPXjnm+nA4OAIXaIP7+v2dbhB2t2ml3qZnGas8Lg+JEYNjWwnf51eujES+1DLfu1xRsnI+Bgjo49DvKl5JU5AfMCneIRtLazjh5xDQhgRGkrTKKGUtr1CRg4RLXwDKR2FXjR2KPs0NR7WzQPSSxtapsJOAwef3i5U33tsxzFhcLPVXMIVofiJJf2sIZ8NSytebjn+eZPG76wZ0lCBLXv/dZQ2pVeEpjRKmev82nevZUp082GeUHbu7UAntTq9qZroUBTUmNrz/dhTreRwB+m3jbN0JQGhIxHktzN+6OWlCTlK5KKjomjYFU3Y6ODBD7C3nX+tAxTfD+QeCD+TPK7lCwhkoQ1xnQORvuMR/DJmLDo0IZT7nRYAhutsWn6VVlw/1kzPJd0R8mIP2NDoY9YtwT0Lr+Gb/wTyJmuH0O1eunBjfH1E2XlPQSmJKF88F7JQOeCUdFnt6YuAFPl5kTpKWao5q3sp94nlpxxX+FkhTakwbfZyPuYgYuj14oRc/zv0CCHgy4lMT3HQmdxBCMhnq4T1ZOm1mR88cwE3b9+aC9kwTadkO9+xvrT4zUGsPGcwZ36un/V9QW4Tja1Qw0T7H811xC8fBCXgo0bkvuiklbYrt0iZZ3KNiCZuCZWGm1rTiQMaWY77NIOFKju5cvXxoHTNni3h6x48Gm99jJvln0vitumOS2EbAuvVR92eJtnhl7kaYVPqfmYx4Klfw+AWaxr7To5bJKspmjqNo+TbPCD3B9QR9/SKxi4Byr6rZXfAXufKxsnhvJtzNkB11PINCTTTS2oYhuy+
 Nyska9iR
 pobUPWxJjGvXlHEWI5ZGweegeV5Zc7Bi2Hm41yy+VGVKkpKSxU0f/7tCcMPy8AaTOsr32yojtwonIYPXRTLlNam+AWVj0kYvFryyf4K7u6PrivfPs83Frc/cKyeWPQnXDffiltEez92/15uf1/4QUjhcIGR63wYpMXPjm3lcBYBcide5ha55JZl0EnNNh/0IqDCYbs4PRdnpa0L8FfaQc72EDp4+sqckvs+ze6cC+0JK1GPti5j9xj1S1Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 01:16:05AM +0000, Evangelos Petrongonas wrote:
> kho_fill_kimage() unconditionally populates the kimage with KHO
> metadata for every kexec image type. When the image is a crash kernel,
> this can be problematic as the crash kernel can run in a small reserved
> region and the KHO scratch areas can sit outside it.
> The crash kernel then faults during kho_memory_init() when it
> tries phys_to_virt() on the KHO FDT address:
> 
>   Unable to handle kernel paging request at virtual address xxxxxxxx
>   ...
>     fdt_offset_ptr+...
>     fdt_check_node_offset_+...
>     fdt_first_property_offset+...
>     fdt_get_property_namelen_+...
>     fdt_getprop+...
>     kho_memory_init+...
>     mm_core_init+...
>     start_kernel+...
> 
> kho_locate_mem_hole() already skips KHO logic for KEXEC_TYPE_CRASH
> images, but kho_fill_kimage() was missing the same guard. As
> kho_fill_kimage() is the single point that populates image->kho.fdt
> and image->kho.scratch, fixing it here is sufficient for both arm64
> and x86 as the FDT and boot_params path are bailing out when these
> fields are unset.
> 
> Fixes: d7255959b69a ("kho: allow kexec load before KHO finalization")
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
> v2: Per Mike's review [1], move the guard into kho_fill_kimage() instead
>     of patching the arch-level producers and consumers. This fixes
>     both arm64 and x86 in one place and avoids redundant checks. Tested again.
> 
> Note regarding backporting
> The offending commit was deployed with 6.19. The only other supported
> kernel version with 6.18, unless I miss someting uses
> ```
> if (!kho_out.finalized)
> ```
> which in the case of crash kernel it shouldn't be finalised.

Yes, this seems about right :) 
The only released kernel that has this issue is v6.19 and it will be EOL in
less than a week.
 
> [1] https://lore.kernel.org/all/ade2ExpM8ROXV-vy@kernel.org/
> 
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index cc68a3692905..1029fe8778f2 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1551,7 +1551,7 @@ int kho_fill_kimage(struct kimage *image)
>  	int err = 0;
>  	struct kexec_buf scratch;
>  
> -	if (!kho_enable)
> +	if (!kho_enable || image->type == KEXEC_TYPE_CRASH)
>  		return 0;
>  
>  	image->kho.fdt = virt_to_phys(kho_out.fdt);
> -- 
> 2.47.3
> 
> 
> 
> 
> Amazon Web Services Development Center Germany GmbH
> Tamara-Danz-Str. 13
> 10243 Berlin
> Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597
> 

-- 
Sincerely yours,
Mike.

