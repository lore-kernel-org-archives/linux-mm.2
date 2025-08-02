Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B90EC87FD2
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 03:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2C246B008A; Fri,  1 Aug 2025 23:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDCC26B008C; Fri,  1 Aug 2025 23:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3956B0092; Fri,  1 Aug 2025 23:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE97E6B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:53:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4846C59926
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:53:42 +0000 (UTC)
X-FDA: 83730448284.10.C021C03
Received: from iodev.co.uk (iodev.co.uk [46.30.189.100])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6FF0E40005
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:53:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=iodev.co.uk;
	spf=pass (imf12.hostedemail.com: domain of ismael@iodev.co.uk designates 46.30.189.100 as permitted sender) smtp.mailfrom=ismael@iodev.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754106820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=/jYhSCPGln3DnTEUEqg9bdXyN1YQw/iy1VN9AuqU/5c=;
	b=t6vBjCGk7E1ilhTj94G0wfVFYeHtbFKQLM+itzOYat8aauvlPTtopST9/rlLfOcgVniL0z
	18biLEDw/Vw60GY2U8mM3SPJA6Ip3meYdKx+QeshVjQkzYIcDMfJZxGegjCy9O3uy9xHuj
	0oJtKGDfNkHf9WUVSKIsKxva8MvuRwY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754106820; a=rsa-sha256;
	cv=none;
	b=I9Os5lI85LAV3BM04TyGDgEkciIrb2boDu6tI80lyaKNceA2tlC+vZY7UFEopfIMVv2kMo
	IB/HtrgTAi6ekKfDCY7e3shUswNt0BNXAUyh85wE3tUZD2GiNPSkPbm3+Lc+aXggM1Egmf
	23tDxWFhkLz5TrvHAJHrz9LNLV4g004=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=iodev.co.uk;
	spf=pass (imf12.hostedemail.com: domain of ismael@iodev.co.uk designates 46.30.189.100 as permitted sender) smtp.mailfrom=ismael@iodev.co.uk
Received: from pirotess (112.red-83-45-208.dynamicip.rima-tde.net [83.45.208.112])
	by iodev.co.uk (Postfix) with ESMTPSA id E10AE453C4D;
	Sat, 02 Aug 2025 05:53:38 +0200 (CEST)
Date: Sat, 2 Aug 2025 05:53:37 +0200
From: Ismael Luceno <ismael@iodev.co.uk>
To: YinFengwei <fengwei_yin@linux.alibaba.com>, Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	zhourundong.zrd@linux.alibaba.com
Subject: Re: [PATCH] binfmt_elf: remove the 4k limitation of program header
 size
Message-ID: <aI2KQaWpPLSAqdXg@pirotess>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xd6zp5ytq6iakxkqoqqtseomgu5oohau4ynj3xbo7ejohpv7dv@skp2v7awzab4>
X-Rspamd-Queue-Id: 6FF0E40005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: pzc9ojbm4ckjhw6hcfz9m5ponwsozqpi
X-HE-Tag: 1754106820-961272
X-HE-Meta: U2FsdGVkX196YUzsKWBNXT3PLI5C1sGPyt5BTX3akiIMcovUrXKM2fbEolRATFnP68/0tKx5Qf0jUkdu6868ZegNVUYC3YA/a9ziX6S08jpxf9FmaP/r5npJOf8EAtMwtM4XaBVyGbtK8vTuw0UW5bIxdStTs5lHrq56BPozsFReapv1CtdPSagAnXILae1ZPZFLi+5pgcSFmOYSPe3bfMhbkX52n65uv0huEA6gtdEnA/H6SauISNb29QgsoKzvOKDP0itqalIxpQ0GnThpduKGUTWVDQ47T1lvTid3UZLQI/OrZ4yjrfJu2Dbg2CsjFynOrC6iFc0j+yCevdr/hxWfGZRfbC7IHids3teUBk2jvWdeWJ13ph281ruH/Nj2B0jg3mKOcWtrKbHPCkCxpl5iwMTQe1JnW7Y61P0HpauUIORWVwsmVhG5nhJddgIflCYwxEL58hHej5VtIL+7qrXkwbUWWpDeBUQ7ZtUGqt+EvLXaekLo8/cwO++IhyFSRHUDh+vTmnB137LK7GyxekqOejdEhyyQ+eMTWo8VXqtmnU1D/oVeh9KdYHj6ApXk2qVPEwTZfANe9y5T8u4pXEzVG1nFlh5Zm98hStyWY+QmDDLs53n/pGaYNOInIwz9okKIMFfpx8JRjW/JsiVFRGBZSDVSBydJoueSaGEpG8FmjJ8qtVdUwPIweYob2LYQpUFC+4NXyN3DGcneHihsn7eWBNPsnFy/FOf022hclq6Ojeu5Y2I0t0hSoizJqhRNAe4MaaMDQbgZHKjpENZ0ZMwHcNq6jg1Cp3HOj2ag+GOkuPrCYginFJpIMFa9QT559DGsCI/zfYqyAuQ28qZP5sOicVSFMmD+OyT0lqQh2RYPI3m6TBaBCv/ga9Tq1iD6+OZ8UoFxwGZvDlTnZrZm7QwH3X75OU2RC8boQ6B2hneAe19/aXgjD9XHXtljW0c7fQJBzjistKC0UnmvdNA
 r2FNJYtg
 s0oab4mrmsxoY8xUB5peL/jZ3/KKO3VOWfp5C20/HK1OhRbUG5sTwGxS8BdLlpIivI2YKKmjjfp2i01m+e8m0H2Vd1/FVSVx/+ulWhjEF7IF20ehAHt2P/4U5UpjQEvBQvOtU6QneN4u4AF/7SCjM859yQu29Q33RXWJvnjRRkEFmUBk0CMhIdNycImMIKL/1tYTOTI2Cy0fSiexXVmaJvfy/cDx9zGn/ZM2/5OFVD0Aruz4gZcdWZNgPZEFzNoZ/IHcZzAs8k1dVJlg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 19, 2025 at 17:17:09 +0800, YinFengwei wrote:
> On Thu, Jul 17, 2025 at 04:31:50PM +0800, Kees Cook wrote:
> > On Thu, 17 Jul 2025 19:01:08 +0800, fengwei_yin@linux.alibaba.com wrote:
> > > We have assembly code generated by a script. GCC successfully compiles
> > > it. However, the kernel cannot load it on an ARM64 platform with a 4K
> > > page size. In contrast, the same ELF file loads correctly on the same
> > > platform with a 64K page size.
> > > 
> > > The root cause is the Linux kernel's ELF_MIN_ALIGN limitation on the
> > > program headers of ELF files. The ELF file contains 78 program headers
> > > (the script inserts many holes when generating the assembly code). On
> > > ARM64 with a 4K page size, the ELF_MIN_ALLIGN enforces a maximum of 74
> > > program headers, causing the ELF file to fail. However, with a 64K page
> > > size, the ELF_MIN_ALIGN is relaxed to over 1,184 program headers, allowing
> > > the file to run correctly.
> > > 
> > > [...]
> > 
> > Applied to for-next/execve, thanks!
> Cook, thanks a lot.
> 
> Regards
> Yin, Fengwei
> 
> > 
> > [1/1] binfmt_elf: remove the 4k limitation of program header size
> >       https://git.kernel.org/kees/c/8030790477e8
> > 
> > Take care,

Hi,

I noticed this removal and wonder whether it could be a problem on
smaller platforms.

IIRC that code has been there since ELF support was added in one
form or another; and the idea behind it was to simplify the code
by ensuring no cross-page reads could happen, as these could cause
undefined behaviours or read abort exceptions.

Best regards.

