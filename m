Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A79C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D64D6B0092; Tue, 15 Sep 2026 10:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE646B0098; Tue, 15 Sep 2026 10:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C4676B0099; Tue, 15 Sep 2026 10:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEFB86B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:00:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6EC181C22EB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:00:59 +0000 (UTC)
X-FDA: 85216157838.02.7BBA549
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6E42E80029
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:00:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vqajrmCt;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789480857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0JxQYBjmO1vYJSywAUW1OOBMLXNRVrkgSCeVPxsXPU=;
	b=P3zMlWU32dyQyREKlQfc0+MhxIXZU1VpbBW2BoWr9ypNCLjbCbtBcmUSzHkWhnrwUyZd4e
	+U5+lHwII0MZbLs+FkQhbWB/rnkfAYNVJNIiQaiSJtqLPhTYuIvbMBA7j2ORafpuofb1Bv
	jEnM29bzHP3xKA4uczsG05BbXgHbPk4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789480857;
	b=SFL1KYlDEmuMJZ41S8S+dXtEhhjS/KZbk2ci7yz4GXXcjnwowp1uVPjCY6Y5lMwVEqqCqq
	f83g5bMR3a/M00jphdL7KdGZDAPhbC2WUqkMKLWsZZe5QWZmqakLRsTy4uzx0rhzq/3zdb
	34GAOZj3rrMQgX7aMbU1NIyzXMKDUnU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vqajrmCt;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P0JxQYBjmO1vYJSywAUW1OOBMLXNRVrkgSCeVPxsXPU=; b=vqajrmCt1aMjHrgjKgf9nsMc8t
	1HTSPbrZ2Nu9GG4g/qb+VIW8VrZfKXNfmRiDThFCCgEbVDUPaF2MOej9pzOvolOO1Q4ULqu61+vWA
	JUHnoFVkpIBkIeFhbh44R1GkHpUH4RmS/d8uEKQHexTpSubRTJ9JmtyjJP5ZB71J43qi+QIxG0miR
	JC65jdSlXGG3axUCE8+IDglXpMmSaBmLQyZ8pivc9K5fqmz88ngwG++duTsmzfmH7dJnPqJVHuvQo
	Z58o30vNw2QLRJymW71I3AEVrmdxMAUI0O3y/MSbGXx0CDPON0t7fbMHwIjQ6x6hWv69xAJRAf1gQ
	09t+H54A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6Thi-004RXm-32;
	Tue, 15 Sep 2026 14:00:11 +0000
Date: Tue, 15 Sep 2026 07:00:02 -0700
From: Breno Leitao <leitao@debian.org>
To: sashiko-bot@kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Zi Yan <ziy@nvidia.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, shakeel.butt@linux.dev, kas@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, x86@kernel.org, hannes@cmpxchg.or, 
	Thomas Gleixner <tglx@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, kernel-team@meta.com, 
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, 
	rmikey@meta.com, riel@surriel.com, harry@kernel.org, kexec@lists.infradead.org, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 3/9] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqlPIbH1zCHtPNcZ@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-3-3bc7a57bd503@debian.org>
 <20260915131527.AFB261F0089A@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915131527.AFB261F0089A@smtp.kernel.org>
X-Debian-User: leitao
X-Stat-Signature: k1dmmp3yaitb3z6ypwedd63xypsha8sq
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E42E80029
X-Rspamd-Server: rspam03
X-HE-Tag: 1789480857-808024
X-HE-Meta: U2FsdGVkX1/EdvW5xhcmWim3psgFLwpKrqUVksFYduC1vwp/wpt4IP8ddgnPFV+YYAkpTVWG+MpAPk/tRzgG8sWyVeVgpl0CRxXfZzorW2bEJY9XwphFMQpTjKyFESL4z9ApoZqfHmfeBHPLF/zWEaCzrrLU0sn/FwzO4fD8E9l8/Ll35r+qgqUVoF9XmyuvhFYCFp3Rr/ANI+hNdn4oUVbGBqqWGILm/+KyYzeBuiQNV4ae9g260RgCkD2SS5BZJhWcNVs7hukACbhYMP+wrUVD5wxtdILk3IpWlAJbLI6kmxeD3ylJUgs7BWirqsi+5kD85EU2g/eIRZnerdArddS8IYeNUsOOgPk5fODwBlKqnkUc2sHdrTeJPkeq5kWlP09358lelzh2K067IAis6oFJ3dummPiMHS95nSKPwjZe/PqV4HGQ/Q6lyQ9snN60kLvReCJb/lSpZioQ2RKxM34KN8gXpG4gnu/EveZ6mM4iutVnZE3SG4JsfqnOYSUDz01LqRKVGFI2A6NNFZofI2vYtDoHFQVV96VJKYlQyTX7cxEkTVLi2bVKzDO/wFvbNqhB+5+lj69riSbq14aIGi7nte8UBV8HLWjdG3khae7s9t/arDDTzJCayIKosHNPR9HGQueBQRbfn2DKFVZt7q7BVufltBOL/Bjnly52R1hCfKLA9fyuqyFyzTqq6hrAwFtbfWShFxpUiKc9DAzEsTRM5fEjXcfxAnzY8mbLcVeaocOWI4mYfxm+WfWS3w/gzNtOp2RNGWsIaPrUqQbWzzKoiVRBF5GeJrQ59sN18PGaRFz8shYbmjaoXI2xxVFWfmdnnsM6lGTh1rTFJyObuIGN6rguOvaNTYxuXYRZFkpomzpoWrua4+0x5yx++L2PXIuGWwjwxYH2VO1ctTXZrUAhYRBlf5YLu/RZaMoxraYRgGblEihtVctePcqis1xDwohcJ89RyBAjMxKLRLO
 vBl6SqIa
 ouJm8Qbt9kiLIZsrZbDCLwpMjt0nRtPknQqOYNdJ9UA36JK4vxS9pNgHrsfdvbT1/NMxSzdJXAPT5FIwgv0EKFkbHUFshEIx+T3DLq8dAPKoeBTt7qtus249giHMYYd5DrtChPGDa5cr8FcYlV62/pMzicaz/HFwEx1YBTNzm3PdsA3fLFofDW465tzStVko/IUnb5WaZuppk7EzJT+/JCvTZ2OX2yqrXWtHVN+B+5ffiyBoxAggaVVuyPANnKV3vqYFgUIoYMwD3gQ33kS1YAQeEbybZcOstPpSoE1bG6/VMPI1lXcLGLeOKxp6FU55o7eGf0I60+HGtxp+aBdRu8PYtfvV4sUtzbdruVZ3g7kI9UMQ12UZ2vUU/xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 01:15:27PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] mm: efi: integer overflow in poisoned memory bitmap allocation on 32-bit
> --
> 
> commit 591eef51f672049b14b50a75d67dac823925a19a
> Author: Breno Leitao <leitao@debian.org>
> 
> mm/memory-failure: libstub: install the poisoned-memory EFI table
> 
> This commit introduces a new poisoned-memory EFI table installed by the stub.
> It sizes a bitmap based on the UEFI memory map to describe the RAM span and
> allocates it as EFI_ACPI_RECLAIM_MEMORY so the next kernel does not take it
> as free RAM.
> 
> > diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> > index 48f93f7758e9e..9c66e06c972c5 100644
> > --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> > +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> 
> [ ... ]
> 
> > +static struct linux_efi_poisoned_memory *efi_poison_alloc(u64 phys_base,
> > +							  u64 bitmap_size)
> > +{
> > +	struct linux_efi_poisoned_memory *pm;
> > +	efi_status_t status;
> > +
> > +	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
> > +			     sizeof(*pm) + bitmap_size, (void **)&pm);
> 
> [Severity: High]
> Could this allocation size wrap around on 32-bit EFI architectures if the
> memory map is extremely sparse?

This feature is limited to 64-bits only, so, these wraps on 32-bit
architectures are not real:

config EFI_POISONED_MEMORY
	def_bool y
	depends on EFI_STUB && MEMORY_FAILURE && 64BIT

