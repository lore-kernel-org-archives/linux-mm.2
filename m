Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51CF2C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256B56B0088; Tue, 28 Jul 2026 10:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E7E6B0095; Tue, 28 Jul 2026 10:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16CC26B0096; Tue, 28 Jul 2026 10:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E975B6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:46:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 842DC803CE
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:46:45 +0000 (UTC)
X-FDA: 85038461970.26.33BE9D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D948A180011
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:46:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IcLhbjoi;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785250003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHMN8cA8fITPlPJWm1+s1dgIvNUxrIp2dw8vHkotxoU=;
	b=bqTM2ho3QpOTrY1rDPZL5cMq4183qSw5P8A0cqDHQbPOYp8ZQk92pFiO1wvYjuIw104hNE
	PGQzlkoUA0fV/tLmr8HLYCbR4ovb+wN4Afq6U0XdsHfMZMmIjEqsgJQsIRwyAnhhNbFtBE
	7ifx3jmT2CsezRg+L6wIQ+K43rx4O4s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IcLhbjoi;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785250003;
	b=kOTwNhM1tHm+I5LF/3Fs6MX6IAi/AVv2p4fX72T9x5joRwietY/ckAL5mA8swvlqKxaxFk
	41RoNtfXdKuU5nc/Y09BL50iRDfEv/feYDoH3WII/5dzE6v8bTNcwVdhspkrqSLeU/CQH7
	NRwC0Uwpf6uvykl1vyJH44gSuGEm7ZY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 16178600FC;
	Tue, 28 Jul 2026 14:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB901F000E9;
	Tue, 28 Jul 2026 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785250002;
	bh=OHMN8cA8fITPlPJWm1+s1dgIvNUxrIp2dw8vHkotxoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IcLhbjoifecXqh6wJXtKrMKtUKA7SHBfbvqA+CIeIbTdnLpLzptuCxCC2vw2VlrHG
	 yPtd1sj5tRxEBE2k3LKb2mnZfdeVzetU0cKtHmQHwAq2NTGvUBLsrfk9hE4MpGsZxu
	 jErf6p5eZT+qPe9vZo/c6m5IsiEFu8tUlStFHa4yZYfXl+elMs/hPhcERHRIUeVIte
	 Jz7P4a3kTkkEn3Ok81eal3HUI+qmg1EZ4mjrMm7Qa2p+6/JE0GVKrFRTUYORDWuL/I
	 a9OfJ0A5++kgn5ZPHOv0DMq5A2UAR4Hl7KamuopGcI/0TyF6d2017I+PmJUeQ8qGBN
	 qbNWfIrlAef+Q==
Date: Tue, 28 Jul 2026 17:46:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David CARLIER <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
Message-ID: <amjAxhL-IeeJITEv@kernel.org>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
 <20260728142108.GW751831@noisy.programming.kicks-ass.net>
 <adfffb36-9943-4af7-a0ee-0e762e47fa11@intel.com>
 <20260728143135.GG651302@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728143135.GG651302@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D948A180011
X-Stat-Signature: rcxh73jejpi4mqb3z9bap4kccwtwnatf
X-HE-Tag: 1785250003-617232
X-HE-Meta: U2FsdGVkX181buOibP0u48eYoD5PQGwKOYNp5QbFL9b+ZItCI/swTpB6Yzlhx0OTG2zFPS9MgWpMaoLqolHuC5xfgJlk0UDFsDStju+eOi/AFM5Dp0vNlYAAM1IyDGIHiFLNXUXcIueGXn3vmf9IJrO0O5RUtGPBORfgnFlWMyabFzdMLEigT1bAg0hwcFvWQtM7i08NjLnVZmeokv1yczLZoV1x1IZB5bwrO9oL52sMnWKhWPzTLp5QlMxAhQwEHAVEimh3u/AQocxWpQNAZH18tYpDFg5ET4qp2ObGismzR1FcSvmXhlJFts//hc2YazjIn7rYkzdXjANIZI5v5Wyx0IqtEApeea1K/flhdTvk/hGZgIX8RhzfPM2YDcvab+cCq3PHwElnAdVPeekYVk8w1fAdAzKe4hSgn+Tc4hZPWKriX8iUyAdMqNWr2sEAoCPS9+e9ppHZ5N8ALCIq0Haa7AYRxzuweYZtgkCd4UszS3J/lcxtWvHi8NmKRrv0Pc3sqsuY+3jQoyzxuNaB6CQNUc6JnP4gzvpwr+lRvX+4MXCTg1WoF60aAA4htG6E+wk4OoI+pcjPFwOkyF2BP8CaMvwGg0BU3ZLgn+lI3bKFL+TaEuJe8lBPMKUrue4Dm2z+8ZcXFXP02pbPpMQey2CgtloiJFMBMBhl2EJbDLzBEcpCXq7UbIjk7GhzwukiOGdUcgMLAXcgeZQ1LdotKB9mlZ5la8QS7AaFwylL7zI1oIJXRcv3KFu4i617kRs6W890Pg4Bl1mcht7LsEZA2krCCMKs/6jO3GO6Yfnox3krjx1dk2KmAIBmzxacbup4Y/RvFweXC45Dh1bNuPPq1GGvfvYr8PQx83B/IlOV5apKggan8hVmBbAxlqtgpLbmCyxbRMl/nMP0VSReIElv0WDQfrRfUrMhyfoWA/Y3HIYof8XLjW9Kom8XLiKv7oqxOp3gjKaLFjBnjb8LLdc
 NEMF8+IQ
 7ipukG00+vkGz0ysdW5PNm4KuJkhVBO6IRLrub3GlQq/3/7RAv6Q1Os5ZOhh36b0oli0GnOkTiRPBrRwm0gLBC1Y+Eqn5i4I13pKy/0HpRwYCR8LXywL6fBRioCE2z6wzCmjtHPhu+5fP6fadhuSEeABJ84nf5kNHx4ECu8ussOgc/wGUduQO8c12xXabfo0W43qxE2DUH6433DqXXzy6LCJBjko+Wq2RnbfJ9FSRIuNI/MebqynLaOOFidPuYzs/8wPUtyJTcdLxs0r0/LYVZz3J5uqum8mAvFQNfNMU8XfJS8g+0FEJndkRJqWSrS5C4ZzRhwgKrqtEo481PSf1v4SwKzNOcvbyYAHgzINQLm3ggl9aOIMpE2wDmNGosyQ2uz0p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 04:31:35PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 28, 2026 at 07:30:27AM -0700, Dave Hansen wrote:
> > On 7/28/26 07:21, Peter Zijlstra wrote:
> > > There was already a patch merged that removed the shole debug_pagealloc
> > > exception. Is that not better?
> > 
> > As I'm scanning through email this morning, there's another issue that
> > popped up with that patch. It's causing hangs on boot.
> > 
> > It's looking like debug pagealloc not taking the lock is actually
> > functional, not an optimization. Although, I hesitate to say
> > "functional" and would prefer to use much less nice words to describe it.
> 
> Yeah, lets figure out why that is before we retain this wart ;-)

As Lorenzo said:

  __kernel_map_pages() can be called from irq context:

  < GFP_ATOMIC context >
  kfree() or whatever
  -> ...
  -> __free_pages_prepare()
  -> debug_pagealloc_unmap_pages()
  -> __kernel_map_pages()
  -> __change_page_attr_set_clr()
  -> cpa_lock


-- 
Sincerely yours,
Mike.

