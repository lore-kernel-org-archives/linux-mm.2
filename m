Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1211ED4A5EE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 02:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59ED56B0005; Thu, 15 Jan 2026 21:56:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523196B0088; Thu, 15 Jan 2026 21:56:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42EB46B0089; Thu, 15 Jan 2026 21:56:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7146B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:56:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7CBB13B222
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:56:57 +0000 (UTC)
X-FDA: 84336314874.16.44961C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3BFF8180002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:56:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RRlZmBcW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768532216; a=rsa-sha256;
	cv=none;
	b=MuNs9KP7G/bD1zbZhzxNeQop+7Kko1+Y92tZC25KT4V+vjNTOMKmmpVRHgLz9kTS6ZBfJj
	K7PEJoIzjUrH7t9miyZAo0beP3J3rsagTfxkxSgaVhDPEGSeg62mb6p/jSb3+b/1oE5uUJ
	v26BckbOF0Ke45VWFlM7rtDcSOXRA40=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RRlZmBcW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768532216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFtB7VTRFz+CPEMjLUO7EcLRviyrG8Dw2qQFqHnBBRU=;
	b=7rg2fyoFEPOUMKPAhFw5sRQ2/QN4utdQV9tJ95IOUaWuAzMVT4kk65J2+P31wDAXMgIzge
	Cc5W6Q+jmwboIRUh8g0cBmDDXl6e968jtkiWpwagD/onlYF0XrwxvoiFPwrWbHWrG1UZAH
	1TnRL4wv2oTxa6AMtsYbXEqP6X2AJQI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 856B86016B;
	Fri, 16 Jan 2026 02:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BEEC116D0;
	Fri, 16 Jan 2026 02:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768532215;
	bh=XIQ/LMAxOLSbCnga9pI2EipPL632Vn+o0hlH5sLUIVA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RRlZmBcWP2NQcxLwAQ6897cyN9K3nOvz89Z+Zqt4rxkX/5ByQELlnxqe43/A+W+Vk
	 zoX7uqyVUXDU3gj1/xXvN1fxro+n8qP7+sdme5AruuBgJlkOIuk9qyt3iyDAoxiIu/
	 pxTeJH1gZniYaYTQagl+8IuatfqHLN31OnkmMvsM9OvB+LXMTjgDqouQ6fjTVTLWBI
	 yk6t98iFvBhquneN1hHWKowSxLJUn/JYeljYJa94UUbGZMqZ27PQ6u42f5HO8OpSQd
	 BkdiaLdRWZtYtcS+3crUUtoFj4dHdgo6NTJEKRMg8KZqfjun6lGYRmxmtELlgE+gGB
	 qQweIH1MikUpQ==
Date: Thu, 15 Jan 2026 18:56:53 -0800
From: Dennis Zhou <dennis@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@meta.com>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] percpu: add basic double free check
Message-ID: <aWmo9elLCfyb96VR@snowbird>
References: <20251220002737.84100-1-dennis@kernel.org>
 <20260114122209.1075584-1-clm@meta.com>
 <20260115151328.38cc7cf0d0b8bf97ee5b3791@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115151328.38cc7cf0d0b8bf97ee5b3791@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3BFF8180002
X-Stat-Signature: jmfb6nz5sq3c59o4h4raktzzn7bdwef6
X-Rspam-User: 
X-HE-Tag: 1768532216-4900
X-HE-Meta: U2FsdGVkX1+9vy+VODQV6UcnVDiFgX9+R5Ba9dlVBbCvq/ellP9RrSPPhyENCjA62mFefAoKGGzsNwCOAlPD+lhCobMPujFoM1GqeLz2keNAyp2P9WQLeydxFmaPRXF+LDCXVKVmTivKB/3o6zuwjXjVIjA/HiThAUu3COGX4lOsfUizDrWBPINSeVOLl3p6CNWFP9LnnIE34+eWhgSA027Kp4eEJM8INm+Str285wDZYkpWhyCUvpiglXxIACNrdtAUDVlOAKVS0dKqHkO1W89wU/+1Ish1Z/hy/QnjQJT07XY3KNoS7pR1D25PCIeO5G9GWqL2TJt8prM5Jur7gR5cCYAINIkRo47vGATDIKD6tLoRPkv0nFn/y7x+9sWfN38YYthN+kQILv6Q4RGN3CaitOTaltDnao22ojf/3+cGl3wuMVADQ5g9eJABKwTxonnNQQSWoQPghRNmHSV/ljI8CG+0SDsfi5KpQT0xUXP1gNtaXtVJpw/sioX14h8uE6/7hXtEfzX9uMeuSgtcMAhkREZywrjkHBe1IU1/nyIphTgC16eVzp9OHnxub0enF6SH6TjrNOLhwPCXtf9Vlj6NCMcqQJ3x9ejQ675RFIEis2Bp2idTz/KXgG7xORNHpDxUmyaNm2m3tz2g06yY3b6n1u7KQ1bf01n6GzKpqz7cb8R1k9loLLzNZKEOdgC4x37MVVMbfc3zU/rnKJV+aKKZGs67d2NXi7L3WrnlKsyKaW/dm29D+hY+4WZ6GZ5VVY8KciGEGSqGuaNLiMElwmY+PBAjMBHUN26xj9/cEfYwp7a7I4dFyC4N8GUuTEyhg8IoACOdY/zmWBaXV8hOm4XK64xoq6R37S4PY3d9G9p3kCAhsnqV+Y0pBnGlA/HNkLL7lgWdpcELx3dkvEQJ03otYfJiQgbs5naMdThwTgpZp6FnMPqC4XruQwWUSZqVVH2t90dxr15Ph/X7ema
 cXDFuOv3
 7iyJFtUhDaXm14sD7biG9BNZdtgvpgMjHHT3M9sNgRkaWxkEkkUe0vAL1WGWsycS+vDkANsnOirLqyn/lKqdEiz4kwawW1+81mBVMns/77F2zCq9FQ3XeOFRgBs2HtOLXXQt2ATabWZ1d72TxU0054w2RD/hVcgitVfeMp6SSOD1OvHByrBljPLBvrEqTgGP6G9nYUalmdSdfTp8g9F/lUU8j7MfiLt1X6yGJBxA9KqwpuM639z1huWfGYxPRs5JOkYKru2gwIi/TowMdIbL5ErCHZ3b3aXIVnr8q8eh66NEFNZrzqt7nL2zmjX2WIv9rniwy7zh96dBLOIg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Thu, Jan 15, 2026 at 03:13:28PM -0800, Andrew Morton wrote:
> On Wed, 14 Jan 2026 04:22:00 -0800 Chris Mason <clm@meta.com> wrote:
> 
> > On Fri, 19 Dec 2025 16:27:37 -0800 Dennis Zhou <dennis@kernel.org> wrote:
> > 
> > > This adds a basic double free check by validating the first bit of the
> > > allocation in alloc_map and bound_map are set. If the alloc_map bit is
> > > not set, then this means the area is currently unallocated. If the
> > > bound_map bit is not set, then we are not freeing from the beginning of
> > > the allocation.
> > 
> > Hi Dennis,
> > 
> > I ran mm-new through the AI review prompts, and this one was flagged:
> 
> So good.
> 
> > If nr_alloc is underreported due to this bug, the buffer may be undersized
> > for the actual number of allocations tracked in alloc_map, which
> > chunk_map_stats() iterates based on the actual bitmap contents.
> 
> That's pretty serious, although unlikely to occur.  I'll drop this
> version of the patch, thanks.
> 

It's a good catch by AI, I fixed it in v2 [1].

My thoughts are this is really to serve developers. It's not really a
recoverable error because if the pointer is re-allocated before the
double free, then you'll only find out in the future when the new owner
tries to free memory that it doesn't own. An even more contrived case is
the pages get freed out from under it and then the new owner seg faults.

Thanks,
Dennis


[1] https://lore.kernel.org/lkml/20260116023216.14515-1-dennis@kernel.org/

