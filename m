Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F5E4C88E7F
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 17:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04E1F6B0092; Wed, 16 Sep 2026 13:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41426B0093; Wed, 16 Sep 2026 13:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E088A6B0095; Wed, 16 Sep 2026 13:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBF196B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:51:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 020C6140757
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:51:14 +0000 (UTC)
X-FDA: 85220366910.04.6990AE6
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf25.hostedemail.com (Postfix) with ESMTP id C6440A0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:51:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=E7FjhsZ1;
	spf=pass (imf25.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789581073;
	b=ELfKwY6zdYNVuNFF90gk2qHdqYZhY3qEmqkaMhgjkGxftQE6mKtFlnanysYzj+NbrCLWk7
	edisRyp5YhIQ/oo7IULawKO5HFhDkDCA27TyfqW1+VXTTs5P7DgThsmVwT8vGw4tphA1BA
	nJVCQQK4vU7rZGwztATNMYO1xsfrIqM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=E7FjhsZ1;
	spf=pass (imf25.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789581073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=or2++1LeeipZYCb3G9WRgyA4slOHEhMs91sMxm37PrE=;
	b=3BqK1q42VXekRjgIcA9lOahto+UPkPAEXLfcfH9spWnxm8Eee9ktYcD/gl2KtZOnDTq3Oz
	Z8eG6NdRW93FnZrFzJ3ShkINY5okx5hmuB2XEl+miVH4lN3knKsFrF7lKLmlxXn7wjvMbU
	v2ckcpdNxhakPvSL7WRSzTBUWM4doUE=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 99E4540E00E8;
	Wed, 16 Sep 2026 17:51:09 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 9zV9muLWubjt; Wed, 16 Sep 2026 17:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789581064; bh=or2++1LeeipZYCb3G9WRgyA4slOHEhMs91sMxm37PrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E7FjhsZ1898C+iRkHA2e9itQoyiqH/Ch3CRAiwQscnU0CXAU1B3A58i/8qF7CWRQh
	 G9fmEyLGGIFdYQql64Uc91Gneuv+SDG6aDTZnURc3lGHscWFc5r5ZPh1vPnn+mqjo9
	 KFHhO1O53B1kflUQZ5pwBl1X+TZ/YeOf6S4ukWau6F9Oy2bvc2AkWVFtpJFZA/d20Q
	 giWI8kOs24tcni/YN9qyJ2ifRbE9E3/xTzGmQUWsiuXTEhyoEZljOUczoL/sJ+VORm
	 Jkvi5hPfZD2JyHdgx2JTUeJM+9EfC5lNAKlo3wpXrtxjuZdy0HbqzBa/nrDlGGXUEB
	 T6ChTVHnrHjzueQm9iG6UjvNvWs1Ci2nBGXVxdIW5G0N5g5YvMPiyWBQmN/KIt+8BJ
	 4nMWbx4zbda4r5Pe4F71yKd9gdBn5WVrThXpykty5Y9ZS6rxK/Zy/4imk+qiuwIQBK
	 +J/Y7B2Xd/vbfAw0NWAJZRMYwlCrFpuzM/A8ynROZCZpyn7YbI8CMVxBS6k2Zrpwya
	 T6Y4mlUo4kZxEKXRc1Vy6jsORFjfP4A+DtCjZKq1wSzIccfVVxpJX103Kp6LkYYPGE
	 WV11UFcMReR+2ndH81MYlmJrtQ8QF3VCSlMJid4YqIKWMK9eHGy2UwsKc4B1bjlrvo
	 ZcjWPKxqQS0jjFQdEECxxF+M=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6DA8240E00B9;
	Wed, 16 Sep 2026 17:49:32 +0000 (UTC)
Date: Wed, 16 Sep 2026 10:49:29 -0700
From: Borislav Petkov <bp@alien8.de>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jini Susan George <jinisusan.george@amd.com>,
	Kees Cook <kees@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Kim Phillips <kim.phillips@amd.com>, Joerg Roedel <jroedel@suse.de>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Liam Merwick <liam.merwick@oracle.com>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Xiaotian Feng <dfeng@redhat.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Andi Kleen <ak@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>,
	Tony Luck <tony.luck@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>,
	Jonathan Cameron <jic23@kernel.org>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
	Petr Tesarik <ptesarik@suse.com>,
	David Howells <dhowells@redhat.com>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Ilias Stamatis <ilstam@amazon.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Toshi Kani <toshi.kani@hp.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Vinod Koul <vkoul@kernel.org>,
	Jiang Liu <jiang.liu@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	linux-coco@lists.linux.dev, xen-devel@lists.xenproject.org,
	iommu@lists.linux.dev, linux-mm@kvack.org, aik@ozlabs.ru,
	Santosh Shukla <santosh.shukla@amd.com>,
	"Pratik R . Sampat" <prsampat@amd.com>,
	Scott Soule Cheloha <scott.cheloha@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH kernel 01/17] pci/dma/tsm: Call disable DMA bus hook
 on cleanup
Message-ID: <20260916174929.GCaqrWqZ1fIhi4Rgbn@fat_crate.local>
References: <20260916115159.1938195-1-aik@amd.com>
 <20260916115159.1938195-2-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260916115159.1938195-2-aik@amd.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6440A0007
X-Rspam-User: 
X-Stat-Signature: zombqqyhbucj6tsktbqwuz6d73hckr7f
X-HE-Tag: 1789581072-350043
X-HE-Meta: U2FsdGVkX1+WP8wReWzpFCvkABkc7GrYbbrzO1yQCSpSv6eAMTJg/wRLxZR5t2Oqu2b0RB+6jgu4A7X0i8KRkjZlF3pRzjA5xEl4X2o98Sf1XSn2qqkn/o5JXaWA4kFOQyLGxYgFw1v3F0qGuR8gCAvT9qC/pZtHjYcW1UDDDN4eTraSWu6LmGIhUXQk+go/HAI6szVXDmmqyWaxCHYnFh9+jb7loHQv7B57BoiVdtxF4JbfqMpYSNxkHUfJcfK/WjivHA9QuGcJIL4qRpjrds4bQdemxBGjnnqXGUzNjD5MHH3mIcJipfnnbRm2IoPTOEZMTdUjr9me/NHL4ME8lqQWapNwxbc38fGIlJZVL+n3Zo1YDR+OGj924ufAXZyNxyl0MFQVyvnfqBX4QMavLrsTgvi7eSiZn4hCgwFlUBX5owS044hMMhQC8TeXippTgusoXo1C2d2tgfXcZHkoC4SL5dASRls2JgHFNkGM7f5zClNInyZn80AS6E+ijXQMdPS/42/2F0TMLvHBR++eF5ZUfEpA+Em2JUnjySnCwNSj6gZNlHCW3QWDHdjRJ78+jcKvgRWDvsmoego9hr6t2fZzfwdEUoP7GSWaciA/He/vD4Mrr4iU7mu6mnYFYBhs5jXK/k9Io75KsSrUohvMXqCTqRaVeVM1/mJvipclECXHfuXRvhzb9Q/v14VJArA/4mVUv+847gGOba0MWvHp86sTTgF+tliDtlCxiITJRE/i35usm9wotYycVWPKbb8mfxr0Zu/SgNjou5XbReHtg3Q/l2JRfBJRYpym+5RR/xdd58y/Yvj6+jM8kh4aqcYr1vD2V37SoPFZGn8gnE1zTD2myEv0NxZDXXQ4UJ2P6/+3uEYK5xZLGGLuAzSrxNnCsR19qPn+VQDffKZdGGHvO5QknmUR5m/jzb3wyuPTPqJ+vtn/rlMFoBa2f74vKheMv+yYKm4BxgD3HWQjppY
 DeVEuspK
 9fyKCsfmssFHNlrVftfkyJhw2EEq/FmlT2Tv83CXoy+az76ViCU7UrcEseWMjLS5HlmqILIF68GmM+pY4vfqwb4mZu2671AhMax504o8vRtCTwVrvfXDkxiBPuHFkrMh5D9syFmaUuRsAqjpUA1pRW4dhKqW2fx2UfR5XHHDKUcliC2Xmwcpfu3tg8BVytlYMXfbatlNqKSertWEOtaW9ULMOZCuJSID4wd2fSyzeNiSgtRuVLdZrtGps4kE7f0OaLriQMlMzLQkQdVw82Xje9uHoHb4m264BA720IJYxuIzY8O/bjK9WK+2v2xG2nlq8+4i5j+3vLpYPb0eVTSbYRIgJmket0NAoqwQkymLq7qkROP3l6xQuU6LTCtWp1bG+9uSV+u0Y4LJGhBQIvV80Za4ds5XOful9TPmlAVVu4e92qEQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 09:51:41PM +1000, Alexey Kardashevskiy wrote:
> +	if (device_tcb_trusted(dev))

Where is that function and the rest of the gunk needed for me to apply before
I review those?

The patches on that branch:

https://github.com/AMDESE/linux-kvm/commits/tsm-next

which come before those here are enough?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

