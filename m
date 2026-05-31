Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 959FCCD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 09:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D436E6B0121; Sun, 31 May 2026 05:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B1D6B0122; Sun, 31 May 2026 05:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58AD6B0123; Sun, 31 May 2026 05:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2EFC6B0121
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:28:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55B74120566
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:28:57 +0000 (UTC)
X-FDA: 84827190714.26.E659174
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C3E361C000B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:28:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rez7EVFp;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780219735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKVLCLu8XTfsvb4XdRoPm7KvsQtWzPp56I8MFy8zhao=;
	b=pPEWci4b1rbLjbuISH5BGWjrTq9RTmaotTzv19W+1EswY7lB+ezQ2uaT2nAojeDE4WvpYS
	khj7usjU/x6vKnMjMceoSBb/qYxXEAtp+zTdlqa0lqv9WwenJzmqSS0M7ty/PI5IChUrXn
	X9weCsCi9yiIGWEA6C3G2i6JR+pQJGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780219735; a=rsa-sha256;
	cv=none;
	b=jySeYt7VJytk314tqOTR9UvJ4tZBJrWT2Kj6KvVAeozq/AK8zeXUygs8ZOIJsHowa3VCTB
	tqKPWhRUUGUJGBjSgovCJPiCNFYx8+HWBIRGkrbghD2jZ4dLYFU7cZSr3da+WOTLdpXsDY
	CMooYD320GJPD+kkHppJlhQWHkAdsb8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rez7EVFp;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 40A66600AF;
	Sun, 31 May 2026 09:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0A11F00893;
	Sun, 31 May 2026 09:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780219735;
	bh=sKVLCLu8XTfsvb4XdRoPm7KvsQtWzPp56I8MFy8zhao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rez7EVFpovoH5ATL25xVJfV9kmDIZar9McePukksCWV9f6z3A32X4rp/Miehff7Pu
	 pSh6vOduka57MCJpt/oqUNBbev7WkZ5mUBS0z3YjxCJ+35wmJDqb3J8CGYMuup9CyX
	 RW3OhrJVLdjgyVZqAD6WN68jTQ2yPuTvwRu3G2tA5TrCR0kPk9trY3R4kZ1Xj5jGJc
	 Jd0iGSgxC68WFOdG3BFEzZ9IK9qw7cLjJ3CBAMzBGNbAuJ2ynJO1HTugu1aLHbuHTu
	 HBjZu/5dhv30F1d9FKs5DpoYZRJMKkKwAAyr8947gK76H1CPrR+CsHX00AZJ1MBpbD
	 hm+oilmW9WQTA==
Date: Sun, 31 May 2026 12:28:47 +0300
From: Mike Rapoport <rppt@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, Shuah Khan <shuah@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, Alexander Graf <graf@amazon.com>,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, George Guo <guodongtai@kylinos.cn>
Subject: Re:
Message-ID: <ahv_T6WwFEysgIeg@kernel.org>
References: <20260529143238.169169-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529143238.169169-1-dongtai.guo@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: C3E361C000B
X-Stat-Signature: 3w9yiuz5ubfqrx4pk33uyqd1y3nzaa9u
X-Rspamd-Server: rspam06
X-HE-Tag: 1780219735-63110
X-HE-Meta: U2FsdGVkX19X/qyh44YjXkBWYJ4qCtE8M+mF4gRxWzD3M2Pl2ybmozPOt0Ap/xep2x6/gBA4mHhHlVtjg8Y87ZVhPxOjQWl3ZRkLbnIPXcWjRy5EWIEU2WP/ySt/VXN81fbFRRwaULxS5yH7mR3fJdmpf1+u1Ddl+e91kS0Xli+w5Wlf4eGTQCHeK/HfEwqQx8zuQ3SBlqjS6IkqtaIRL3gZeL8aRp6AtJUg3w068F2UKX9afCxVbsvEN+/0J2hBbnXK8Yi6gdNQbupaSVj8neaJaBdDAcCbRAbJYX0aWPNfhgNgiu02R4mnGJsRQN49suemSeFnCvPl1G9Q2GLjARDeFMA81JybRN0cugPNhlsQ7cDApC0YnUwnWPjabYV0WkWez2nZj4RzdDNYTVnNmf19fo2agjHJH+qbWEWHxW/SyuQcs+UZcmYYlDv1qkpnx0fhM0Z4W6zIeEdncX8C+4u5cIzVCAsBvkK8L6zuRafqrLJjWE+qRnJDUWBicD3WhA9iWoYtQYHbEXiocDhD92KPrBgbrefLsMZGARP6pZs23hhnDbgxyLBsCYv47d1b2KCGLn0a2VrVUX+pQkUyTvdxBukut2TwCKFfcV9vuolXY+S5jMu4HluOSQutgkKuT+MCluoI67os6iBP5WNHgV7J3DJv8oOnUXBfW3+DtR7v6ZKZrWd1e3VdnsXwJP4tkS4LWvCPFJBa3xLiIQz2SF5TtESkxmG1zq0qyLrWtqiab1uer+orEPiHSUGsaxH6vaXcE06vjAXODW+2xJZJDPnRsGe509sNX0P4/zn2GYw+KCoC1fg4UD8ODl9cJ62Hd507Z4Qgpqs8HIjh5QzYgXW851GNTXZFpMHJackZVjyneWa05yff0mJ4c0ImltwPH5SNTDTTuRH/TiUfhuVY4wJnCA15KXI+Pzwp2izmowPJCcqHC2Qsp4TopyC9KfdUU9I9RuD7AaiCdWQIQth
 55stBMOl
 YAxS9jCkfhrzslL0Dq7uyY5AjaIyInpt9nYXmxi1xEENpVvv2tP24CMogXh8l5FlGpfx3E00BO+qglJgbH62JQcrsi7qAIkkWmGrB3SmOA1nP/FYSMgkSwlK3DQYvK/L6iCIhzZSsIHQOAVMHznUf5e62+6vs6LoY3nIF1LYwBPbZ2eyFb7EUQ164zqYpokUtsYqUNrHC8jCTWJ19KhA1SnpXIfDQqH4iGOZ+wqzKlCO6+1yRQrMBhrktX7WjNuzaebxt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, May 29, 2026 at 10:32:34PM +0800, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit description?)
> #26: 
> containing only /chosen with the two KHO properties.  Since DEVICE_TREE_GUID
> 
> ERROR: Invalid commit separator - some tools may have problems applying this
> #34: 
> -------------------------------
> 
> total: 2 errors, 1 warnings, 0 lines checked

I believe something went wrong with sending the emails :)

Please include changes from revision to revision in the cover letter next
time.

You also may want to consider using b4 prep/send for sending the patches.

> >
> Date: Fri, 29 May 2026 21:54:01 +0800
> Subject: [PATCH v2 0/4] LoongArch: add KHO support and selftests
> 
> This series adds Kexec Handover (KHO) support for LoongArch and extends
> the KHO selftest infrastructure to run on LoongArch under QEMU.
> 
> KHO passes metadata (the KHO state FDT and scratch area addresses) to the
> second kernel via the FDT /chosen node, using the linux,kho-fdt and
> linux,kho-scratch properties that drivers/of/kexec.c:kho_add_chosen()
> writes and drivers/of/fdt.c:early_init_dt_check_kho() reads.
> 
> Selftest support (patches 3-4):
> 
> Patch 3 adds loongarch.conf and extends vmtest.sh to recognise loongarch64
> as a build target.  The LoongArch virt machine is FDT-only (no ACPI), so
> 'earlycon' must appear on the kernel cmdline or the console UART is never
> discovered.  PS/2 input devices are also disabled since QEMU's LoongArch
> virt machine has no i8042 controller; the fallback port probe hits a page
> fault and panics before reaching userspace.

Patch 3 should not introduce regressions
 
> Patch 4 handles QEMU not exiting after kexec on LoongArch.  QEMU provides
> no EFI runtime services, so machine_restart() falls through to an infinite
> idle loop.  QEMU_NEEDS_KILL=1 in loongarch.conf signals vmtest.sh to run
> QEMU in the background, poll the serial output for the test verdict, and
> kill QEMU once it appears, so the test completes unattended.

And patch 4 should be folded into patch 3.
As I said during v1 review, the whole wait and kill loop can be replaced
with 'timeout' command which does not need to be specific for LoongArch.
The actual timeout value might, though.

Will wait for v3 for more detailed review.
 
> George Guo (4):
>   LoongArch: kexec: add KHO support for FDT-based systems
>   LoongArch: kexec: add KHO support for ACPI-only systems
>   selftests/kho: add LoongArch vmtest support
>   selftests/kho: handle QEMU not exiting after kexec on LoongArch
> 
>  arch/loongarch/Kconfig                     |   3 +
>  arch/loongarch/include/asm/kexec.h         |   7 +
>  arch/loongarch/kernel/machine_kexec.c      |  38 +++
>  arch/loongarch/kernel/machine_kexec_file.c | 256 +++++++++++++++++++++
>  arch/loongarch/kernel/setup.c              |  21 +-
>  tools/testing/selftests/kho/loongarch.conf |  13 ++
>  tools/testing/selftests/kho/vmtest.sh      |  35 ++-
>  7 files changed, 365 insertions(+), 8 deletions(-)
>  create mode 100644 tools/testing/selftests/kho/loongarch.conf
> 
> -- 
> 2.25.1
> 
> 

-- 
Sincerely yours,
Mike.

