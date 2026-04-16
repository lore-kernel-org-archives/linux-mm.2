Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECD52F8D75F
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 16:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A49C6B0005; Thu, 16 Apr 2026 12:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2552F6B0089; Thu, 16 Apr 2026 12:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144946B008A; Thu, 16 Apr 2026 12:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F18B06B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:17:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D00D5B883
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 16:17:56 +0000 (UTC)
X-FDA: 84664925352.01.F7F324A
Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	by imf25.hostedemail.com (Postfix) with ESMTP id CFB23A0015
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 16:17:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=eNZb1Z3v;
	spf=pass (imf25.hostedemail.com: domain of "prvs=5593aa174=epetron@amazon.de" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=5593aa174=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776356274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EoN1CWGLCZOdklUYrgE5XBMTZqfsWrhlj/7/48ef/xg=;
	b=1V77vlykq5gQEbvUqdcY85cGcbDv/qsck+6XZblLAg1QNRqInb/yda2WuVoZSfa1BctjEa
	0g65GzjVdUE6CpnT9e5xQWAGNpAC5l4BT+3eZpvfDqNs4hxO0NMBClL4AdwWYzZFMk9J3E
	kmIaYz6ySJtlqgiW/A/CZ2bJ/2rmRfI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776356274; a=rsa-sha256;
	cv=none;
	b=4vOzky4hLmfeHJALHj2EykSkAkHddU3mH6Q+GtcNrl+eCb+ri0KLhGswsobRXOQIXFV+dU
	kyC489ahnK69yjtsY1bs3Wdqdp67ODfTFCwJxIOZTm9aoysDiUj+jg+0xm769xyErHR9hn
	21GO8ydTtmh4z8loxD30NMygxYYBIyM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=eNZb1Z3v;
	spf=pass (imf25.hostedemail.com: domain of "prvs=5593aa174=epetron@amazon.de" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=5593aa174=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1776356273; x=1807892273;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EoN1CWGLCZOdklUYrgE5XBMTZqfsWrhlj/7/48ef/xg=;
  b=eNZb1Z3vA9O+k6eNuIX2twjsogFlDDGO9w3WxECJuvCL3uujIGxGQRvu
   vBfuLxw/n1uLv994WQA71DAGLohC5kbQIctlGk/1mzq+QEmBituhQ56Iu
   5Gah36siK7VrmFmDvXndSRoUp6/3hB37bSgDHkM1XRLKYMmykdMePhEo2
   kmgeU4C+j/ht65uKysvJv2MJBcLJv8BhjZqXwJ4SwzH9edAVuFDNeL4hJ
   x+tW4mY0uZLl6giaNivWG4Uhc+gYxuL9WSUa4y9yBQaWL96yoUmuMofmV
   soCEQPRoMAObaQqSvLhsdcOEciy375oq8rbsevuCzNRHDxzE1zEvuoHjx
   A==;
X-CSE-ConnectionGUID: x4INR6wCRPuVGINf1EHiAw==
X-CSE-MsgGUID: 11m9AFWQQMqcMoYGCg4QbQ==
X-IronPort-AV: E=Sophos;i="6.23,181,1770595200"; 
   d="scan'208";a="17298797"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 16:17:49 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:2261]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.173:2525] with esmtp (Farcaster)
 id 8e1c12c2-e53f-4a55-8a68-57cfbc2e1bde; Thu, 16 Apr 2026 16:17:49 +0000 (UTC)
X-Farcaster-Flow-ID: 8e1c12c2-e53f-4a55-8a68-57cfbc2e1bde
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 16 Apr 2026 16:17:48 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Thu, 16 Apr 2026
 16:17:46 +0000
Date: Thu, 16 Apr 2026 16:17:44 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Pratyush Yadav <pratyush@kernel.org>
CC: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Alexander Graf
	<graf@amazon.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, Rob Herring
	<robh@kernel.org>, Saravana Kannan <saravanak@google.com>, Changyuan Lyu
	<changyuanl@google.com>, Andrew Morton <akpm@linux-foundation.org>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>
Subject: Re: [PATCH v2] kho: skip KHO for crash kernel
Message-ID: <20260416161744.GA65710@dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com>
References: <20260410011609.1103-1-epetron@amazon.de>
 <2vxztstf7ys7.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2vxztstf7ys7.fsf@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D035UWA003.ant.amazon.com (10.13.139.86) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: tjsd5cc5q3bo6y77htzqjnisgqhtycpb
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CFB23A0015
X-Rspam-User: 
X-HE-Tag: 1776356273-806464
X-HE-Meta: U2FsdGVkX1+afcw0lAu0RfYpKrA2+qDX6ynQyd/uTv/UIJ1zW7MIAj5LlqQtHBZ816TQAeNMKQceXzUk6p7fA6IAKjs2KMGXLVAWWUrMdXc0V7ayWAUBbo7KKnmN/EUhkKU+UEEJbMP3egsOzKEOFo7e2GNRgIa4KhRbl/3JGjZE4hLIghU7yqfKtngiqnKBcEmg9GqQGqAQSlFC1bYndNLeRf0WlRNn/WGvplnCr9m3apWVzvzRCpOtQAn38wz8v8jgGbj8i+ogirUFYcG/90+RfIiIsJS/DMmfXluyUFQ84j4iLWh/s6y2gC8N5+ioE5gDaSJTI7PhcW2xrwKaeQfpIIu13YIxadLQTtuG0FB1q5eClqDEqorxCx8i+5cBr5LpATT+VEzcbu+bm6RgriwExSXSH14w/gjkypytmf6i17/kPHLZn46ksU6XH5+wuiDtrJZ40BZhHeBlVIHRdVkoRrhWJrmN/UMgybrMKZb2rCwzq9z3yVkEc95oVLWUj201YKIAT191Rid5KtLa2H6fY6VYQDHEsh0Xt7qLC7BwJk9nX6TFHmm1XfGdUVWf5vTu3/hG+ChqWgsj+7FJX2YE+w7G4Fh+cnmiQD/5td8t5gcVrlVObIhf9maMtDhHaEBC9xdMGprlh0GxbSELbEedENSPqvxcvXRXI4dILfK0tWXALt6rtcFRNrHDu+ntiRQ4MGt9VaEUzE31C3DBvSrKHs7rED+9ocDSwW/RPn3BE3bw1z85lnT3UClcsrOswUh7A3xvyU6aRwAzX4Ayut5OPmDPd88lawyS7rI5toldntcu5fpBqkSpDi5+eDTiH4RqBKythlIgV2wTu69zqoFONMSSv3jdKpICvZfC0Lq/l8j1hJFsANA0+gpOe0Ftnvf7u97p6DhTLxh/AUwTdPrG9Hk/6c8ia/Ko1RlTnQfuFmRQYoVm4nbc+F5O3VAgS0/X0lYGsqfsrMG9TiA
 iNfz82Vm
 437zCcR8qr2YzwxSMEzzY3PCPAuC9xlVN7MEFynsGyssxgiK3ci3XLYzPL0T4OMILsjLvvHAqesxyQ3dFaXfTsqK8aIorI1EVllp9JGEPjU/QyyIBL8CkwuSPHWvT6aptPuuEaTXYTWr8qVkL3Wq5jcsr+tm2Bdae7ko5LCgqQQllBC3nWtpDbuDuFWkkCb6G/mct9VJsHZC/GHDPYo7diXLox7oFFGbw8gBNxm1gXItfIyNVCJ0GMKlznHvUj6GdNeDM6F7mWFegBbI6X6L3xdzOtWhF9/6fo8zV6cQDChvYaPdhqg8+TFanPUBwJaoMDdRUsrGVmufoTeo5kPHyn9tj2oefdN5BdJHB4FdQBCUVlp4yK7nRgUA5g8wnss5KRWriDBzFSjvy0C1Hj1vD16aIDcmjsHCeG9S/1tfadmv76zIjUU0b/8LNN1C+2hvw4msFVl3kHGr7X7hoTcQVEjrQvoMqTv0Z6+sIfRbCX22hmQa6jY7Ym6m4ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 01:52:40PM +0000 Pratyush Yadav wrote:
> Hi Evangelos,
> 
> On Fri, Apr 10 2026, Evangelos Petrongonas wrote:
> 
> > kho_fill_kimage() unconditionally populates the kimage with KHO
> > metadata for every kexec image type. When the image is a crash kernel,
> > this can be problematic as the crash kernel can run in a small reserved
> > region and the KHO scratch areas can sit outside it.
> > The crash kernel then faults during kho_memory_init() when it
> > tries phys_to_virt() on the KHO FDT address:
> >
> >   Unable to handle kernel paging request at virtual address xxxxxxxx
> >   ...
> >     fdt_offset_ptr+...
> >     fdt_check_node_offset_+...
> >     fdt_first_property_offset+...
> >     fdt_get_property_namelen_+...
> >     fdt_getprop+...
> >     kho_memory_init+...
> >     mm_core_init+...
> >     start_kernel+...
> >
> > kho_locate_mem_hole() already skips KHO logic for KEXEC_TYPE_CRASH
> > images, but kho_fill_kimage() was missing the same guard. As
> > kho_fill_kimage() is the single point that populates image->kho.fdt
> > and image->kho.scratch, fixing it here is sufficient for both arm64
> > and x86 as the FDT and boot_params path are bailing out when these
> > fields are unset.
> >
> > Fixes: d7255959b69a ("kho: allow kexec load before KHO finalization")
> > Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> > ---
> >
> > v2: Per Mike's review [1], move the guard into kho_fill_kimage() instead
> >     of patching the arch-level producers and consumers. This fixes
> >     both arm64 and x86 in one place and avoids redundant checks. Tested again.
> >
> > Note regarding backporting
> > The offending commit was deployed with 6.19. The only other supported
> > kernel version with 6.18, unless I miss someting uses
> > ```
> > if (!kho_out.finalized)
> > ```
> > which in the case of crash kernel it shouldn't be finalised.
> 
> While normally you should load the crash kernel early in boot and at
> that point KHO should not be finalized, I don't see anything that
> prevents crash kernel from being loaded after finalize. In which case,
> you can trigger this bug before d7255959b69a ("kho: allow kexec load
> before KHO finalization") as well. Also, before f322a97aeb2a ("kho: only
> fill kimage if KHO is finalized") (landed in v6.18) kho_fill_kimage()
> was also guarded by if (!kho_enable). So you'd hit this bug in all
> kernels before that point in the very same way as today.
> 
> So should we update Fixes to 3bdecc3c93f9 ("kexec: add KHO support to
> kexec file loads") and Cc stable?
> 
But in this case it seems a userspace misuse if it finalizes kho for
crash kernel. Whereas with the current state we hit the bug with a sane
userspace. Yeap we would hit that in earlier kernel than 6.18, but none
with KHO is supported is it?

I don't have strong objection for backporting it to 6.18, but it feels
unnecessary. 
> >
> > [1] https://lore.kernel.org/all/ade2ExpM8ROXV-vy@kernel.org/
> >
> >  kernel/liveupdate/kexec_handover.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index cc68a3692905..1029fe8778f2 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -1551,7 +1551,7 @@ int kho_fill_kimage(struct kimage *image)
> >  	int err = 0;
> >  	struct kexec_buf scratch;
> >  
> > -	if (!kho_enable)
> > +	if (!kho_enable || image->type == KEXEC_TYPE_CRASH)
> >  		return 0;
> >  
> >  	image->kho.fdt = virt_to_phys(kho_out.fdt);
> 
> -- 
> Regards,
> Pratyush Yadav

Kind Regards,
Evangelos



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


