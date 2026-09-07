Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F25F7C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111EA6B00A0; Mon,  7 Sep 2026 11:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA9E6B00A1; Mon,  7 Sep 2026 11:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027286B00A2; Mon,  7 Sep 2026 11:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D74666B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:24:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B06DA01B4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:24:11 +0000 (UTC)
X-FDA: 85187337102.17.9FE2DFD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id AA41F180004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:24:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=TwhS7pT7;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788794649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6c435i0Ybwx2SpPArP3T09GV23HR1EORsj2zutcyrsA=;
	b=etlEEgyMdEykMrReQthQr7fIJfWbLfzTjphrX/G0LSP3KNrwywnDpaCBt7eIBH2r3Hw4Gf
	CciZ0oT1tmcDVeC2Sh607vxheKlmIWzeDwsr2b60pAoos0u2MrztdeRvON7cWuLt+v6UxI
	4I3k29lFYVlszVoKdTK3FQ/ZKpa82kU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788794649;
	b=nwpINZvBJyljfM3PU8F92D8VYZ2FenQ9kPAC2Vi8iLbLcKTtFn6QuMSI32Z4bhMUL0V+Av
	YluUeoepU8s/JPkRwkGFwpqGlxilKedOsbT5s1O7mqI7oXolG/QRsj6fJroczd5O4PhuSf
	vSAbNAKRmtVwB7wS3/l0mwBE+V6E3a8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=TwhS7pT7;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6c435i0Ybwx2SpPArP3T09GV23HR1EORsj2zutcyrsA=; b=TwhS7pT7b6MrSEMKFQfGDeSRIA
	mv6TiijYkOzV3ljABhwcKRIImezX6VdLF59YDNzKwVu9XJSBnGJI+8bj+Zieec2dbmSX+dI64ObiU
	C6HdX1Joy5LOL3lb5qIr5LcgDoacSanCjFIsu3Kvf6RuotHWPs8FxHINv1Mo6Jw8NyZsEJZmyioRK
	Ei8ZzeJcwumibhpITvX9zwoCt14QChw+J8HOtulb9LVA4kEShJ+v6nO0XqbRUzgWQ7L1V+pSaiCHT
	tbHwZpkOABgvU1Qwurrtp391g+wt6DKKAT7yXWR5gRPtkmNkPLKZHrevAIYTNDGTBgmBkr3mc7fuO
	e3n1TF0Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x3bCK-001bGs-0M;
	Mon, 07 Sep 2026 15:23:52 +0000
Date: Mon, 7 Sep 2026 08:23:46 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
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
Message-ID: <ap7Tup6mahjIljVF@gmail.com>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-3-6f79c4b605bc@debian.org>
 <apGWUWi5-RbhFHpe@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apGWUWi5-RbhFHpe@thinkstation>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AA41F180004
X-Stat-Signature: gaxas849bercw9ig6djqecbg6nwtimrx
X-HE-Tag: 1788794649-812755
X-HE-Meta: U2FsdGVkX1+hZcti3rbBSEbceVwMyKwrAScotbUCVYszbVR4NkDNB5Fylj68gKfZKcCFmRUqw/6AlP2H5w/T2BRSeiwoh2yRKD/rmqrQt4JT5PrW/inGnY/k2TvYC4nAsTLPxjYieqUyMONknA+suNDZMzKfaNXI9NbORLZYoWrxcIOy+ZBReeYNBWPHoDnG9r3+UocYH5CInj9SCMQi9E7nJCHUcmljnMkSTCjF5zGklz6pRlKFcC8EuPuzmHFO6w7zRJkKXV5KXMM19K/az97jEovftjEoTdS2ugne+xvjXPCEM2+7mgIPilauPiTM4ln2NwwZoyXXzcIvITWF18hUqKBig01Ovuem80Vo0SaRVioxH9Us7f6G0gObKw7b2zcuCzfyAZWN8cY6PcP5yjfSqucVoQ/FOKBdlArf36KITrba5NmHLPmb5n2gGf8EywzyR3W5Ar1rfIQOjJBX5inwXZ8Zqyt2woqb/AjnDwIllv/vMkAr8vBK37/6TM5jLfJLEslhowVE6NCqbmA950/DzJJ3Txc1mHUEmuYFYR+LBrr5Nw7cl5fdd1/4OTi+gotfAgqz3mXEKNTkzEFkWzS55/q2Poz/EwVgNh9IL1eSQtxh4R5r2MCzzqrDWf04dwuHmmno1trMvdeQaPA3oFk/47OXajPjVZK1hNH8Y8rfPDuLAFZ95taqsMrhbb5DT4SwVOVTc+M5p1Gg44zaAwk8+RrBKelSFuv3s1v3Yp5mAeld+aD/yzB+4yutk12GE5gP1ykr8dM+0v5VKIk2JaH84vLSJlQbzsgtBLs5YkwHSanCDXorAAsoNWS9jQCgdQsVocpXYAvPnXbBDwVwVY4jj0AqkxFuugHg9Np5abN8pD+WwK2wC+ITJr8Q7JdisyPQGUgUbKgmUflEEo1t3tiEW+0vCBl76EZ802lAonG0UjJYcX3SCXRQGu0e7IlOxomHdEiBnuaU5UOBFhn
 KS7w5AoW
 CTYKSqrnm5c51lWN6SFAj2b7Pvo2ZV6dnigKPIeVFVBC3NIwh6Gg8e5wX2H1hVzpjjl0trZtK1rzpkCpN82FdXL4MWepvyF3KUTh6HshZUNqfTN7jhveLLmKJy8WSH8xnTM+QEKqM7v5BvoQTseAtw1btrz325Mjoo/1G3A6I0a6lN7zRzfqLxIeZEndiwPW6oh7iik5+Id9VyVNa4bpLvRTLBNeRbDZaOmN0+1UO9ith623TaKaJMtk7iPBzMeSzip05ncUdlfe83Y5HIqvyt1KJNZ0VE+bFimB/n9WdDfy8pEXZqNX0duFDZspLiWsaIZwr0QHV4niMfRA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 03:11:10PM +0100, Kiryl Shutsemau wrote:
> On Wed, Aug 26, 2026 at 05:03:54AM -0700, Breno Leitao wrote:
> > +#include <linux/memblock.h>
> 
> Is it leftover? I don't see any memblock usage.

Yes, good catch, I will remove.
> > +#include <linux/mm.h>
> > +#include <linux/overflow.h>
> > +
> > +static struct linux_efi_poisoned_memory *efi_poison __ro_after_init;
> > +static u64 efi_poison_nbits __ro_after_init;
> > +
> > +static u64 __init
> > +efi_poison_usable_size(const struct linux_efi_poisoned_memory *pm)
> > +{
> > +	u64 nr_units = DIV_ROUND_UP(PFN_PHYS(max_pfn), pm->unit_size);
> > +	u64 bytes = DIV_ROUND_UP(nr_units, BITS_PER_BYTE);
> > +
> > +	/* Whole words: the bitmap is reached an unsigned long at a time. */
> > +	return min(round_up(bytes, sizeof(unsigned long)), pm->size);
> 
> Hm. Why bother to clamp to max_pfn? What's what's wrong with just using
> pm->size directly?

The clamp is a min(), so it can only ever make the kernel use less of
the table than the table claims, just a silly and cheap optimization.

That said, pm->size is more than enought for now, and we optimize later.

I will drop efi_poison_usable_size() completely and replace it by
pm->size.

Thanks,
--breno

