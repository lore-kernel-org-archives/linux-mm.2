Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 956F8C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6A8E6B0088; Fri, 28 Aug 2026 10:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B596B008C; Fri, 28 Aug 2026 10:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9099C6B0092; Fri, 28 Aug 2026 10:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68C376B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:11:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EE0BA3D55
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:11:23 +0000 (UTC)
X-FDA: 85150865646.26.3EEA8FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id F4141100005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:11:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=URfLviro;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787926281;
	b=qzililUaM5KWBqH3uz9F+LAQWrwE5u/1OmGSJOVP1dpwOaMfjDivrrc2iBvuuvHsluzmKp
	xIl9Ro//dt9FH7G2ER6vrPnh+nbzZ8sYbJX6ERahjowF2VVOvb/RvdlHqiKdXL69WH6OwC
	lwbcxutBY8h8CYidVIgtiGaxhHag/rI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787926281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7b6NXuQpbm+Bpwe770MpMgWC/+r6IvbVv/YGtdtPR8=;
	b=tqr87d8HrUelqSb2YoldtaNYRraTmGgb8uDaql3OSj6cj5mB/RqVWueNPSjZAVSd25/BmV
	QuQh39a/I9Se6Lwvj/I3end7nlyC6BsHnro5V0Tq8MKUevfMyGP50vkCkYK9rjN7krt0SW
	9cwxpnOCsrwrB8bk5HSSnON4OE/Uzfk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=URfLviro;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 790FF41372;
	Fri, 28 Aug 2026 14:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706C41F00A3A;
	Fri, 28 Aug 2026 14:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787926279;
	bh=U7b6NXuQpbm+Bpwe770MpMgWC/+r6IvbVv/YGtdtPR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=URfLviro2w0VdJ4YO8neeZvUxtIdNwrPWpvPo48fNJ8y84NnI1SrupmK5IKxoSOny
	 n+fC7M1OrWiec6Ar1qgigzfapw4D/MkkurtVnFwnp8FqLyTa5wd76JTmA+0klf8cx7
	 I12MgxdC88orwWRC/waMtG3j6M5KsSimDuLC9jWVROYPDlF9kZ3Ib6yI3++Eg4yzl7
	 m7fcdj1sN25g+P9JHwJF3gDCGg49Bpl5+94pckjbqGHpaKSvWDa9F+BQpv5O9GUZHM
	 MdSKP7Cvh7/nBMkuA4W5AXbbiT5Y6lzR+bBK2JFFLQBJLP6Jr13EBYRjt8Yi+KAFet
	 pKbM60O03S71w==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.ams.internal (Postfix) with ESMTP id E6CB4198003A;
	Fri, 28 Aug 2026 10:11:12 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Fri, 28 Aug 2026 10:11:16 -0400
X-ME-Sender: <xms:AJeRas1aZk9opjMSiGX5jElAqjZ4yIFj2k79pkjQWBBDs2rRAZz-GQ>
    <xme:AJeRaqPZSBLSs0GN8Ma9LdPe9x3z3EXOw3X4xZZ3t6AdjbQEFNUAw03QHcz8KE-4c
    gfOnZTcW8a2Jq_e4kyjWntEV2vEZ231XWkT4_Qb_6D4Pub9gbb2G14>
X-ME-Received: <xmr:AJeRaiWuEV238jidr06ojGeBuk6qzsjid56OXlDDKuTMiedxTLZPhL_oZmY>
X-ME-Proxy-Cause: dmFkZTGfMEtIdxK9TZhqZLeRbfNvLYXlwoNy36VBDoEf9Mft6xswYTLKr5+mL4ccPtdqIJ
    +vUC/Jlk/xplE2julyVEiux1aCh0eTADY2ObZjiUqkrKT5Ef1K/Qc+X4X0h0mCPmpbKqPL
    AjDnxuLaEDPB4g2sNEZHXSXz0it2PYy7eaS5EAF/3j8NDfbb1e2T+8R6ZWYLnhBvUGl17y
    1sAzCDfz5CMOQDgVGhn24L+BZer5Uyqd71kfJ6/xMXI3m8JiQIMTFF4KPRsN79kPqDCBAY
    w1NnkXoPPSuNed5UOjneSlrXRudTr2DT8EOVI2Rn2XM0JKcyccE5oUSCd89xeQcNPWIMqW
    2o/KtmRCeONuaV8kcZ3bSQ9t3OqJhmCbPkO1VXJO6s3+D7dlY6dmU9D3tPPOqBhNvdtKTK
    OlaIZTh4bSsVAY/aKs93BhArFKW2i3ZdUkEb81t3r9qa1ONHeB9sHjOY0dXWaLTARhkva4
    vIi3zi/TNm4LExcwt8SOAO0b1TWucerQhHfZrj1XTyd44r1NHzSJG1WmyL7CUUMDkVGO6H
    SpcvpmXTUDEpUJJ5+nx0UJxYbn1u7Wz+yOACY9/dhRipLWlz+rP1JSLvg/ZlrszAEwRUbV
    tDHQCBk21ZXc2A2ldQQ9t4qy/RXSjvgl7kAflQd5gF1SRV3DvYJUOlXmZruw
X-ME-Proxy: <xmx:AJeRaqbiOjLtG_O770h2bh6BHEdo4Bfr0xoea3h137RsTu7NgBpFug>
    <xmx:AJeRatvSmGpff_pBo8O3gYONJARpaii_gjMdzsVD37p2L3pNXZ5jqw>
    <xmx:AJeRasls8flkBSEysMaaYuVugCPUBY3Vj4AGw7dHVBnplXF-iqOgAw>
    <xmx:AJeRanSZBbWnVQE4lXp4-_7P4acsvBKQPgaH-3fdXqdmG9QsGgIrXg>
    <xmx:AJeRauMjyfqAE17oyt7EQXafma_xxc_kKuxVOfPciLs7NHoGagJ_eI5B>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Aug 2026 10:11:11 -0400 (EDT)
Date: Fri, 28 Aug 2026 15:11:10 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 3/5] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
Message-ID: <apGWUWi5-RbhFHpe@thinkstation>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-3-6f79c4b605bc@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826-hwpoison-kho-v3-3-6f79c4b605bc@debian.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F4141100005
X-Stat-Signature: g67kegp8gupobgybj7p4r9m1erarik5a
X-HE-Tag: 1787926280-114094
X-HE-Meta: U2FsdGVkX1/B8sd39iiTrFWJdz3PFCb0CyDxNxFaL/Vyifk7iunIKYMG31zHTaLmtmvXSMlxr2MM/ZjwHuy7kNxVyKE9q/WDPTbZHc+tNjfnozdtcN/D6J1NjhvF90LmVPux1r0XPAP6bMcz6XWnJorFIdiDA3hczUH0aWBsNCxy7Yg9ETtG9E7qCJDElORwRXa2ej+B76AmLi4kS1/NsZqeimQ+YQ7vYfGHhgHy1CwG/FBcSGa55Tw98j8YjkT9UlWkaCZ4xRBsY1a2EW2C1a6XCDNTT1nrdandnj/BXhRePgDhnnP+kDRzcnoKUTx+ozNhOqJeIqdwqN4eaa3pfJCbH996adC/S0MoxonbmetbQbl7aROeiN3sh/njosmkMITXE/pMURpNpCBwHdsSKxrlyul93P8C//EgRLK+30bYQGI/EiVAYQSJmbiGgT/qobvRqYvwMbEmKeQUGRoenU877wC0oYhfdZ5UVCbbzYQGzhIsJdT5FW4oPYlE9R3Xd0LKo3t5vwaOgVAURoLkT/tIK0Ny6c8Nj5v97ap+J4DafrUmJKT7FZW8IYVLzTcZNDe/dAcbm2aGMx9nGTq7iR7tOTelDNUSA8uUmSYINFDCE/gYgcLSDh2akjxHTdcSCcjSfvq4pQL8lJfIcEASsSO56GmXCTNCQN+HLEJq9KLWT6WRt1MJvlvUAmFo87Y4jEKrU6iL+3j4gebq1TmAJrf9wxJ8latPCQvWptaELtpbj17JTbaXxzJjhUh5t2g8dQSocChyHXlpvmLkVmk0iCsJeDj9QpOoYj6tvj4LbvcAqLLi78cpyrFJ2DtIopr59qsY+kzWlf8l3bEjvWt+6D2E+FG7ReN/T+Accg6v2HusxHVQbfSeyQudiMgtAlDOgieV3nDD/HmRAstLQv5xatt8E1OVDsNdXFJz91PkX220GV/O4wjryr4q8BNGzQB6nwgZJL7gDeAQkjgCfJ+
 7B5YIptT
 6kTknbKnHECNuUF0mHflTuvbWiC+mqdG2c3HfhFDOjE7igFWR4Nni2j5Brz91AQoT/Fb6ejLVOgvvLqsmx3TxVwD7lMcFzT2g1DrTpYWWL7O5PqkLdYJVbUa2CW0qm/mArXgBfiI1a8m73ssyW/UtXV6hWOaaEWIbBKRi9wSDiVBsIN5l7b4biw6r8/YORTjpD1v1VeJE5RHnosLVB8dg29cB5pN1YQ5GRuUVxPXLY9gHipN9VoZ1k/Uw+WeROvPsi5fHGUie84x3sX1gCeCnPIX9rKQXesuXJmfQonSRiKdn9gkcXWXI5TxpW8t0TA0gbjofOcKTrQbJcyH0nbFlv45eb/n+iLY64gSiaBB0cvMqYvLYKJJEpkJ1lwusOPRMJIu5UddxB9IIHecTV1DmDApjlNiY18l9+EyW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 05:03:54AM -0700, Breno Leitao wrote:
> diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
> new file mode 100644
> index 0000000000000..d6855e712832c
> --- /dev/null
> +++ b/drivers/firmware/efi/poison.c
> @@ -0,0 +1,126 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Runtime side of the LINUX_EFI_POISONED_MEMORY table: one bit per
> + * EFI_POISON_UNIT_SIZE, set here as frames go bad, honored by the next kernel.
> + *
> + * Copyright (c) 2026 Meta Platforms, Inc. and affiliates.
> + * Copyright (c) 2026 Breno Leitao <leitao@debian.org>
> + */
> +
> +#define pr_fmt(fmt) "efi: " fmt
> +
> +#include <linux/bitmap.h>
> +#include <linux/efi.h>
> +#include <linux/io.h>
> +#include <linux/log2.h>
> +#include <linux/memblock.h>

Is it leftover? I don't see any memblock usage.

> +#include <linux/mm.h>
> +#include <linux/overflow.h>
> +
> +static struct linux_efi_poisoned_memory *efi_poison __ro_after_init;
> +static u64 efi_poison_nbits __ro_after_init;
> +
> +static u64 __init
> +efi_poison_usable_size(const struct linux_efi_poisoned_memory *pm)
> +{
> +	u64 nr_units = DIV_ROUND_UP(PFN_PHYS(max_pfn), pm->unit_size);
> +	u64 bytes = DIV_ROUND_UP(nr_units, BITS_PER_BYTE);
> +
> +	/* Whole words: the bitmap is reached an unsigned long at a time. */
> +	return min(round_up(bytes, sizeof(unsigned long)), pm->size);

Hm. Why bother to clamp to max_pfn? What's what's wrong with just using
pm->size directly?

> +}
> +

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

