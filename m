Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5BFFF55425
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 00:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93606B0005; Tue, 24 Feb 2026 19:06:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41376B0089; Tue, 24 Feb 2026 19:06:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D228E6B008A; Tue, 24 Feb 2026 19:06:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD8426B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:06:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 522FDC1A58
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:06:19 +0000 (UTC)
X-FDA: 84481036878.27.8F64703
Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7E5102000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:06:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=AkgzLPse;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771977977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hwbo+qh3ZKjcL1ArZ2cEab76Y3DqcSCVeG8QenLMGQ=;
	b=GlER5C1G9XSoo3fV5mjJeK+F612VPGmzrdkUQ/214wR2scC/MKTn7Cthm9bMhhaWPDTazT
	HdtGl45aSY/ixLbzOoX3TsH4iT6aI+FyGTqhXKXiu+vEt0mI8Jny/tuZwyPjnaDgs2DHWi
	9jDBWHrxM1wXnZi9wjPpEK+lYOmHWlY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=AkgzLPse;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771977977; a=rsa-sha256;
	cv=none;
	b=No6FBZ8eKZAZ1npWLnopJHhLYLuUHn4qV2IzKh+p2rQ4iRoTLmwlwIkl0YTcI8cxs9hnma
	hZ006GOxKT95wXd11hGYRf1SCMBGYXPPu63DyMCImbo5vdiB9KI9xhMs5//A8GjDbnEW20
	hxo3OOph7mEJ/6A2gbB6E+UEvbnwoYQ=
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-12732165d1eso6688797c88.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1771977976; x=1772582776; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2hwbo+qh3ZKjcL1ArZ2cEab76Y3DqcSCVeG8QenLMGQ=;
        b=AkgzLPseSPLtLgvPE4Nv4s4a3YobFC4dHA+w3HTLS3DKGmnFRJPrMMjla16u6QJKol
         254h0Wk4WLzUOoIzJZebWUUTK0L/sFDpn0VWwHFnaDPdUTcQwZrfbu49Y1WZRTOc9CaD
         F5V6vMz90FxtFFai4QJGlX84+wUbIV6Q8WrR7IeGir3Z24p2hzpmAOhSopsYsVf0ErF1
         G1LOsOQ6ju40ggHNj1TjoM+RqzESXXY3JFHdEn63cV4L5aivsZ0Mk49Url7yB139UK77
         alO7r853a9d3PWzqnc5erknxCVCzYl+XzKLIoN77fRSk9pGMbHhj+Sh0PDUlCtEA8ru4
         cbQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771977976; x=1772582776;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2hwbo+qh3ZKjcL1ArZ2cEab76Y3DqcSCVeG8QenLMGQ=;
        b=vW4GW9rvZWkyTaMRReZS5V4XpWAVlVI/sQj7DgmefnTTwQHhQLRzhZ5a2aM4Fe+r9p
         IvR1AofFfH0Cws48xkBl/d7vrqX71mcZYVxnAoDriMdcBAYE6nSCDnLGfTKFzn3nn3Rw
         y6y4/XnfioEap6vQg3PcDyyLkjm3uqnjzerprirGUbCVAmx10mPzBswtbIRLJIHU5L/F
         6lOxgUnnOwohGBBsCO88ebRzt3AadY/hDymWSLd3/FwrMam+ffoJED6+XIe6gyjz5SqK
         eg23L01+d3FbNQb2j5kQkpyUeV1LNifbaZ5RLhEK1LJFFIbKI+w5qoGJov+v5GzjoQo6
         g7LA==
X-Forwarded-Encrypted: i=1; AJvYcCV6McGehLy/SFBuqc292qekaa4Z5/rkTNeon23jRGc43FnK7Ykaqtz/k5MNCBRRRW8m1i8OkY26hw==@kvack.org
X-Gm-Message-State: AOJu0YwoWRawOdiZDHDGqrE/xwBm/IkyMdfjE6lPzxZLt8k4LeVs7O1Z
	hrBe9t5LJBmc+DH6zsRbSnBMS+RPIkB79MeH0GSN8GiOnkzC7TMFQPl53wgS2Yez024=
X-Gm-Gg: ATEYQzx1L0wK9EfJDvD2Hb/nMLEuRy0GODSbQR8xq8vz+HJyimVoa2xGYp8Yv5jKkUN
	Zfnn0z61U4MXu2XBDQjV8TatO/r99h/Iw+CgHOLCmHQBnleInnRehVCUESyRbdf1IwJMuFmJ5N+
	rXgqhCnXiK1r9U7Ku7+wCpm4loRYx34NH8rYT+ItX/RySYPnbFJnKSFJ06Vu9oLUGok6MkiMnBM
	QMsNFWZRtCYm65dAaKc+Xv1FEXONjMD9QRFC+3uGUdZnyZDopSMIQNGEpj6VymJJAX4mXxPgPRt
	zW3W+ryjP3PYnthjSvBn6ya2E3eiB4nwykQtSKckSQhKR7OTq6fJjlb68J1p/WfkDj9qynZkxBY
	3g7i1ngOgj/zSvhTLMQi3aTGaVLUZ755bN0gpuXGA4corS2sVH1+Mv7r+dNSuOEevy/lfulUK3d
	mOxSQhm1UPxoSwss7/CyZWj8SbIeWS0zRL9xCjAF1o7kc=
X-Received: by 2002:a05:7022:396:b0:127:c88:d597 with SMTP id a92af1059eb24-1276acec1a2mr5538246c88.10.1771977975966;
        Tue, 24 Feb 2026 16:06:15 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1276af2edd7sm12707115c88.8.2026.02.24.16.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 16:06:15 -0800 (PST)
Date: Tue, 24 Feb 2026 16:06:13 -0800
From: Deepak Gupta <debug@rivosinc.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Will Deacon <will@kernel.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Jesse Huang <jesse.huang@sifive.com>,
	valentin.haudiquet@canonical.com, heinrich.schuchardt@canonical.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] mm: arch/shstk: Common shadow stack mapping helper
 and VM_NOHUGEPAGE
Message-ID: <aZ489QDHxEZfLydn@debug.ba.rivosinc.com>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260224175800.2500729-1-catalin.marinas@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7E5102000B
X-Stat-Signature: cz8chcwp4kk4fkgjjbeasanw1749e8yp
X-HE-Tag: 1771977977-214
X-HE-Meta: U2FsdGVkX1/fxSwJAIqwOhZS1sDvuXwacdKUGHOTHZNC+ZoB/eHnxJu20sU2cHtbXVNkUCd8capoZtoHU2LrCbkFKlxnYh0FG9PxdNeGNR7NadNVuxa7BrsTpjL7j9piWEvpFynDzdIYjqFuI524tsdkbL9jUd2Wv2fPuL5HFh7CjkisAK6IoVTifZYcmXfQaHhz7GJgXo/+cFs750KlYis/M23fU+fl0wfdmevW1AXIoNeJh3qk8bzTDniXRwya7nU6BNqyOjuJYxxx3mamnFUe0GTJMmLWZxcxIwXVVPTF2Vb+HUgPCL6TLIdI/pUWEnQkGFO7cYrZfA7s5RvU9lQW5te+NKSMjXpnLbUMbB/W03uFFTIAS0WD+oZUVKLAtJqblhOypsaoHbbxdLT/ZV7WLyueITjnSyX4hb9iPq2tIFNBqcPGn9w/Sbbz3jZ6ol5DqUGXwi0R+mf/4wNnm9bc/IMmH9fwCdWgfGTQ+hKleXoI9Kj9M1mpOTom68cUcDVtUWcBW3/TRyjya53kHcbJN/N46ipPMos/Ghquao/J/wT25vPVfJHc7ivyTuU0IRjcw5rlyZfyDOzOdF9v3RMRnxiOV1zqn6Q9nj1e3v1a9lLFYiqgzzmPjGTXv3hxUEL9xd6YxirnaI+4uPKjGjxXVLqwH8N7CkhpuLNGB+JWCCxu34r+p7S+j0yHhgwvtxADtKjCXqx9qbid2qEGIU9hviHW8HdRdd9YYi92V7nJsWrGkul1Hoygv5Lir+mTwuqvXzvhxIck8S1PB1svcP7b+DJqlvlbz++7cuMFw4qXlevfSb7VY0DpOoTIsPGPo/2St7LXpgy8lnr0ABytyQwvcbpb2fa9uA0mHEwKo0mlt+3ZMvmAUsEzhLI906ROTmXlN2Jk84g16UgZCNeSgRDAOs/4o1oG6U7hdA1mWWMiSwdHfHdOafN6k3sKK0cmE3s0+FVOlZUBGgnrkir
 RN2H/kuc
 FLptjkqEGKDl6KD0blODtLnxDWqmmSk7orrG/5FWhIWpCUfLq0/vwuGX7Nm+H5jcpt9Ia36qAMei7K7P1LUMdt85hqfg8Jn+SR4U+qZMgG34+8SMiSo3ZT4zvDcIQnMqy9VD9pf/1ra8TWhMKw5ggqU89abAsANoRjnXO/NEoyxbmyYpnefiJ2jC6Cw7LMZMlBEFUtxrKy2rfxEgq1kS8npTl8BWV37H96J0CW3A+FyigvlS46R1pw1uX6sdBE6cdXoIgn+iXC0P593jHbY1OFAJkaW/xBjifztu6tfFC8AZnmaQVSjukcgAGlMaoL7su8lE3cchflxdOeoHkCtihuqx0xiR4ArdFT5rcwYeryie4cJybaKKbjQu0K00o69/GObqkSDVfRC5USJz0gKPfnjPrNhkwKtRh82nr7oyPTThAmdMh/tj8sI7iR1zNZ+eFdopVLCac1mGrYLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Kito, Jesse, Valentin and Heinrich.

I had to rebuild toolchain by bumping up prctl (prctl conflict in 7.0 merge led
to landing pad prctls bumping by 1)

Jesse/Kito,

So you might want to do that as well before sending out next iteration of libc
changes.

Rest inline.

On Tue, Feb 24, 2026 at 05:57:52PM +0000, Catalin Marinas wrote:
>Hi,
>
>arm64, riscv and x86 all implement shadow stack support and use a
>similar pattern for mapping the user shadow stack (originally cloned
>from x86). Extract this common pattern into a shared helper -
>vm_mmap_shadow_stack().
>
>Patch 1 introduces vm_mmap_shadow_stack() in mm/util.c, which wraps
>do_mmap() with the flags required for a VM_SHADOW_STACK mapping. The
>helper uses PROT_READ|PROT_WRITE prot bits instead of the earlier x86
>approach of PROT_READ with an explicit VM_WRITE vm_flag. Functionally
>there is no difference. I looked up the history of this flag on the
>lists but it wasn't conclusive. My guess is that the original aim was to
>mark the vma not writable but that would confuse the kernel, so it ended
>up with the VM_WRITE flag instead.
>
>Patches 2-4 update arm64, riscv and x86 respectively to use the new
>helper, removing the duplicated mmap logic.
>
>Patch 5 forces VM_NOHUGEPAGE when allocating the shadow stack via the
>new helper, mirroring what commit c4608d1bf7c6 ("mm: mmap: map MAP_STACK
>to VM_NOHUGEPAGE") did for normal stacks. It will save some memory,
>especially when the ulimit -s is high.
>
>Boot-tested on x86, fully tested on arm64. I do not have a compiler
>version that supports the -march=rv64ima_zicfiss_zicfilp option for
>riscv, so any help with testing is welcome.

Catalin,

FWIW, I applied your patches on v7.0-rc1 and risc-v cfi kselftest passes

# ./cfitests
TAP version 13
# Starting risc-v tests
# Landing pad and shadow stack are enabled for binary
# cfi_ptrace_test, ptrace test succeeded
# Executing RISC-V shadow stack self tests
1..5
# Exercising shadow stack fork test
# Parent pid 130 and child pid 132
# dummy calls for sspush and sspopchk in context of parent
# Spewing out shadow stack ptr: 7fff914b7fb8
   This is to ensure shadow stack is indeed enabled and working
# Waiting on child to finish
# dummy calls for sspush and sspopchk in context of child
# Spewing out shadow stack ptr: 7fff914b7fb8
   This is to ensure shadow stack is indeed enabled and working
ok 1 shstk fork test
# Exercising shadow stack map test
ok 2 map shadow stack syscall
# Exercising shadow stack gup tests
ok 3 shadow stack gup tests
# Exercising shadow stack signal test
ok 4 shadow stack signal tests
# Exercising shadow stack protection test (WPT)
ok 5 memory protections of shadow stack memory
# Totals: pass:5 fail:0 xfail:0 xpass:0 skip:0 error:0
#

So you can tag tested by for risc-v.

>
>Thanks.
>
>Catalin Marinas (5):
>  mm: Introduce vm_mmap_shadow_stack() as a helper for VM_SHADOW_STACK
>    mappings
>  arm64: gcs: Use the new common vm_mmap_shadow_stack() helper
>  riscv: shstk: Use the new common vm_mmap_shadow_stack() helper
>  x86: shstk: Use the new common vm_mmap_shadow_stack() helper
>  mm: Do not map the shadow stack as THP
>
> arch/arm64/mm/gcs.c         | 14 +-------------
> arch/riscv/kernel/usercfi.c | 12 +-----------
> arch/x86/kernel/shstk.c     | 12 ++----------
> include/linux/mm.h          |  4 ++++
> mm/util.c                   | 29 +++++++++++++++++++++++++++++
> 5 files changed, 37 insertions(+), 34 deletions(-)
>

