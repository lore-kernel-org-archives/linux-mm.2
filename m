Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9133CC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899986B0095; Mon, 24 Aug 2026 09:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823AF6B0096; Mon, 24 Aug 2026 09:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EBA66B0099; Mon, 24 Aug 2026 09:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEE66B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:03:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 391CF140112
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:03:30 +0000 (UTC)
X-FDA: 85136179380.02.D9834F6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 90DA31C0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:03:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PRPwI+mH;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787576608;
	b=Lut58fXds5SCnc0s5kOq4AC37RFIU8lTvqojSX4hTkPBZhHHbybSUZ0wO0qb65awwnkJUh
	TD2s5ItUW/PtRerc7t1tjRoxJMnV8F3HL+qN2Yozapd9jKmy++qPDl2IzCskKWJiFKItxp
	OzowTI/F0M2t+j7D0J3OuYrBj/zqthA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PRPwI+mH;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787576608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2Scpyty4GH+eqGEvARQTzFRBjvGNIS26XjXcBDeF/Q=;
	b=v4H/BibyNzYmK/3w2x1yJd/YBOYo95b4DegthCoZUP78JrsBjxW71JjF7p80HNy8Zx/3wA
	LCSA0ivnnYEiiaFrqfbLfAFIqEsFxoHPJB0Syc4oGyCt7lwEDN6yTM8SNdk6tTKW48p7xR
	Rl8xKLuI9LdSTRddJUcf/zFfHY45kjc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O2Scpyty4GH+eqGEvARQTzFRBjvGNIS26XjXcBDeF/Q=; b=PRPwI+mHCGcb2sHUsdpeaL+JJu
	X3E4qrt0g1rrtHtkSflkI1EemlwQRZ8iOqWSvqBogthUK9dhLZogyMr0jo+ItJbTizL89gETEgzuG
	13nVdZUvGjF8Z5eSjawkUQnXJTsPV6x4TZGUE5LGoBQi3Rhr7WCV+kpjXmKl0OMh6g04nAr7eOeg2
	Y5CUxEqpoQSOVIoqbbCw1+PeRZUIb+M+Zv6r6UztlHIE8ye/dwTGLkruOj8UbGdI+rgE8Lc9wgbaD
	RjSKX9Y9usd0EAi2ip5o4l/8WMxB1XLzMKBu66AoOcL0VznfvBary2dneWvHkOqGwsd1lBYpwnmuC
	y6uoGmlQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wyUKV-00DgAo-09;
	Mon, 24 Aug 2026 13:03:11 +0000
Date: Mon, 24 Aug 2026 06:03:05 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
Message-ID: <aow_bfUQWZWh7Kxb@gmail.com>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
 <aog_uH5fTsJzXjjx@thinkstation>
 <aohIF6MmjiQpbz5j@gmail.com>
 <aohldTtzE2GJ76md@thinkstation>
 <aoh-3XJw82O8SmsA@gmail.com>
 <aowcYuXEeqdfHmn6@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aowcYuXEeqdfHmn6@thinkstation>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 90DA31C0003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ejnm5pdzfp1oqtaf9i51fzhruhkp34y8
X-HE-Tag: 1787576608-186914
X-HE-Meta: U2FsdGVkX1+TdXj8AAHTUOJtkpptwcPlpnb1ne1W1goV5N+Y+/7+0volzDS90x9jqQUoqY/FM2uAoAqhVdKUY743FIz+JC30nGYgTPFW38UkZUgYUgE1L14BrvBrvzc4ez/PPGAhn9iOG8lbHCDwsq0tNqCfcSCJH751sX9H/ZObxPpy5BtTtAfXHgbCThZx/R1DeC+eS0rXkTlCgroIc+TN8KphMAxzhyl/gW52XdQEx7SD0wvoGYjEBd39Fg5dgTuVIW3aqcHLeX1TbCzyJa9OQkQxQdJJLNyIlNnblR2fnPCukcCs5hU89cDrhkvSn1xnqPU4fNAdv1ydTlPL7NedFk7bVfd2DCGfq+WIoUX0S1uKJ2GNsIRh7lAaUu9eaLhlQoTj6IHHd7j1qy8bfwq/t2Nfxv72Fum7RJwsnS+7gRP/5P+4uNj71cxl3NhwkiZvGx5+wcKqZrF8RYKh0kOML9iGoLL8s8mAJjvIiEpa77NKgkn/Z62WotF9xYhjruT9RX3pVtnkglI9sfWCr7oxmiLr7IT3YA8ZRiTQtlT/Ly0TvjY7vSd7g+vHJW/grS7XV2Kf3QUVSf4fcSH4T+0lZrhG0elulotUfnim9+fqV8TgzKFoh7C1+jBGFm72G4rxn2b5F5EuUjacBXKrNCui7Di7Igf7WrWrhbEJX3ZuBwIYOp6lO6gnTtwDyo3nAQS/frZdw5C8bRfrRyNXK5mrjueVzRfNpuhCGvgIUdIw4nMECr3c0IRVM75mG/BEDR9eeArjl9c3XsUpqC2t0NrliOV6yODqDIOLLseXWeEhptUAEjtVOqjthMZ9Qx25ofwncPPqWiVip72knMQCG6pdPf3XlsiS12Jqiqq5t3qGgOBEQDtD8N9bF7rGUMma6E9OFz6Lq9UL34YfXesuyP5KV1uo22FdY/Q1zYxzxpAlLEEddH/zcZEI2A1L90CbBJUDTDQZgpZCJcfxmKG
 gCXh8e6v
 B+FFMx/3ztPvfr5eFF/WmSEABLIFAvQZ8TOHxpZT6krQN1hNix33qvwDDXd+BaKv3GGfP1LTvg6cnXSzWXRrKbNWseRrHLCDqdorcHG/h9Sa7FFsrwmV0E+CPvNUQ8V/LHGuV+uwU3+jJ013Lhpt3ByfNbpNJRV8gjsWT3Wvtnv7QgJsgry5FNvS7kSLjVwXwCOMTNpTmduASCa8eZCL7hdpkloTSZZt2Ef34C9o89Qh1ccVCyCEekLzRTkTdh2vcp13iV7ZfICvHBrR8N6FHkxR/SPFwoqbI/X+u5ZM+4+sZwRZ6ULf5g/qgplEyou2veoGFCK22/+L297g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 11:32:35AM +0100, Kiryl Shutsemau wrote:
> I wounder if the fix would be to make page allocator consume the table
> and not do memblock_reserve() here? So we would allocate struct pages
> for the memory and poison them on init. And your fix by the link below
> would do the rest.

Makes sense. Probably dropping memblock_reserve() altogether, for the
units and the table, and poisoning the recorded frames at
mm_core_init(), right after memblock_free_all().

Roughly what I have in mind:

        memblock_free_all();
        hwpoison_init_boot();
        mem_init();

and hwpoison_init_boot() drives it from the table, walking the bitmap on
the EFI side where the geometry lives:

        for_each_set_bit(bit, map, nbits) {
                u64 unit = off * BITS_PER_BYTE + bit;
                unsigned long pfn, i;

                pfn = PHYS_PFN(phys_base + unit * unit_size);
                for (i = 0; i < unit_size >> PAGE_SHIFT; i++)
                        hwpoison_boot_pfn(pfn + i);
        }

mm/memory-failure.c gets the per page primitive:

        bool __init hwpoison_boot_pfn(unsigned long pfn)
        {
                struct page *page = pfn_to_online_page(pfn);

                if (!page || PageHWPoison(page))
                        return false;

                if (!is_free_buddy_page(page) || !take_page_off_buddy(page))
                        return false;

                SetPageHWPoison(page);
                page_ref_inc(page);
                atomic_long_inc(&num_poisoned_pages);

                return true;
        }

Yea, this seems better in fact. Let me know if that matches what you
had in mind.

Thanks!
--breno

