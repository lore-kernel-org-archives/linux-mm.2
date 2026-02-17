Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527A9E9A03B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 21:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9506B0088; Tue, 17 Feb 2026 16:54:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D6C6B0089; Tue, 17 Feb 2026 16:54:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B726B008A; Tue, 17 Feb 2026 16:54:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 211546B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:54:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9AB31C357
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:53:59 +0000 (UTC)
X-FDA: 84455301798.24.AE9C037
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9587780009
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:53:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uT5S23n/";
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771365237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbP5ftJKMP9nz6Wv2BTTRqQOphr364mJnPw+xAQtBH0=;
	b=5yFWQCCMN8XbV9rCKbegg4leas9mpvmvy6NXNX3CowCgZY9ds+3xxm4l8SpdTvpvS4ygZ+
	lb4olP2Vr/vHpzrgrAlBEiq+862lbPTeZgDulOr1Fmks14bZeKtW9EMeF2ZpE219qzugbp
	1yxlG9uyic53L3iJgsN8LKyMriSPmXE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uT5S23n/";
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771365237; a=rsa-sha256;
	cv=none;
	b=1EtyQa0hGPPlECOEm06JmvEHhgxBfouLUV6UNSYLb9pN5l+fJ9SKRMv8L1Vspn7DlV1kCv
	PAmhzwyP4wBtRejtqH0e36ljQVggoU92Bc0It724wrIilZgzfdqRYMoW35Wss3ITvI5L+w
	oG4p9aLcpFG+JX651Cg/1o+w1laNLu0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EB8D437DE;
	Tue, 17 Feb 2026 21:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A801C19425;
	Tue, 17 Feb 2026 21:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771365236;
	bh=Vby3374M9lnzfgcnrauQ3GRnMScLxM10VMQm8vPpG8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uT5S23n/X/Ts82XsxoPXcIY17mciRul7R283oDMQhFRHK6N56YEAKICElByg5n0yv
	 0IIxcZwkc6tLoeyMNFhXEActUTOzr/xS8WZA8ve2LClKnCl5tLZsOyw0sOybVJZfBb
	 J5t17JdPTBES3l5s59/kbs2UFU13MOKiQro3xOMS7G+UT1ImXgRJYEycjFIMIcezJF
	 lPAImiOdplLrPriKjxiDs8ijwSKVkRBFmkrKDIwRQTqvKHf7h9rEYOs1PgJLdKV5rX
	 5i0zXpMdf8yt7u6zT7u/74wZ5VONQowxZ1x0M6qkSqXCFy9ThyAdhzQZMHEaPF/wrP
	 KJ1VUi9PCn0gQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id A894EF40068;
	Tue, 17 Feb 2026 16:53:54 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 17 Feb 2026 16:53:54 -0500
X-ME-Sender: <xms:cuOUab7qqvlwDvuko4Lp4iedlF_9ybTfQb-t5Fp0V-oDDaycxdzLEw>
    <xme:cuOUaSNYpqWgewsGBEMlGh0MHDlq6wfLRSD0XeiCdk2ONPtjFXYMnO_BSa_QkWg-V
    -B00Pm10sF_8BDr03JZVM7gadogrtJH1getGU48TzOzDREPNQfVWqlr>
X-ME-Received: <xmr:cuOUaXH9dTAQRel6tqJcDKHZjMBGAA-uEeWjJjFE0sAiJFriOZE0qbRXttiJaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvddtkeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeortddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpefhffeihedtgeekleekgeekieejhfeiiedtveeludejueetkefgteevjeejieet
    keenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhp
    vghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppe
    hkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohep
    vddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehhrghofigvnhgthhgrohdvvdesghhmrghilhdrtghomhdp
    rhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtg
    hpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghp
    thhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhope
    hvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopehrphhptheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhope
    hmhhhotghkohesshhushgvrdgtohhm
X-ME-Proxy: <xmx:cuOUae0W2PAS8JdGg7BVbkHU9trTyYCrT5ZASmOKNQIo_0E2DfJ2JA>
    <xmx:cuOUaWFOPJ8edno8NBRd84DaeQD0vXN2L36PLJF0jjvYIupCd0t8bg>
    <xmx:cuOUaXxM8XWaMTZ-lGBOKcyHXJ-ouz_CbNglV6ubWzvmjNiRqDlTLQ>
    <xmx:cuOUaVk8g-G45MhXJSh10IjhiMDfihNALpAtDDljTzVjnFF9I4hMYw>
    <xmx:cuOUaeD-XNP5M80-nP3sCISeqxPxPghOysoa7lhsFgCxNEM88vpNPDxz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Feb 2026 16:53:54 -0500 (EST)
Date: Tue, 17 Feb 2026 21:53:53 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
Message-ID: <aZTgnAkXecRPUGxs@thinkstation>
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <CAOptpSP1zx1akeGkZEuPBx1Fk8uz8rs4_m5c55GwPUROmCGxKg@mail.gmail.com>
 <419053a2-9784-4051-b73e-5871d3c32be9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <419053a2-9784-4051-b73e-5871d3c32be9@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9587780009
X-Rspamd-Server: rspam02
X-Stat-Signature: 8hoop77ij9w9z1z9q7p4sg5ornpkap54
X-HE-Tag: 1771365237-241491
X-HE-Meta: U2FsdGVkX18P/bc37hp3F4zXAReRNqQuosJUskWV38WC522ILfpL+kCfmYTklOP6naCfJAg/nQw/2fnzUpbu63emGG6VWzoYkiGr1cjVBkjW4gU7rUAIZc/fLN6w1Se08qfb1Rxu9GTOWPCuMOXXAaEMQaxrLkWIv1G7YnpfF5JKT0yppxUvEJXLZtd1iaVkYgQFIhPhYVizVmWgQpFI6Z/wxy07VNC4PoBP1KAW5ogdSkdhtls0kytYZpoA/HVBy+pm26tK190yZG5FTANkadv4Ozi7KwSuZLEaxtp/JWIDrjQadztzW6j+nktM+xKiO5rnrr4rNhi08WYOSQvLm2uJnsEIM97kwkYn1ZI/X0Ua07vL/51o/lOGFLRGORIWy60SWWq647PlYrnDsgDxtoI4Ctv2MqQNyFr9DDh22ZSRNFKHBOmlmJsfkzNHLtHAptPzoSgrYd/GzFUL0e/J/yR1jkLEliijUvzbfWPufIpGYjgSIcG38ZbUK4nqKPN06HIjcWcEoEfhIzdFdVJlsJ9ymRlZzbTWyb7wNh44hZrELlEaRX4MqGDC0Jsx65weELEh32G9ePu6yb0/XZ/dn709Wh3ZPZqwJIJyU/wciDpAni1VzVaBsHK2sjkAr851p7PXBndUnXDP1cyHx8ABKppfdHK/4MmVYmicIYsEHM8FUDG4miLzsgZhMv9AFEg3vZXf4erD6OB5BU7Mkho8pQfh8VDWJj2ZfZevNDC4OUjJDSKbCyyo7eUWIoJzU218ojHGGU/zN/pSS4s/h4uRru2qUWwCC5kh4vFc92jcM52jXX3t4dwOcTX9Jrbqe8IhLm01etsX8cYdMvDYpi0sztwdUgzMwxcZHPqIUvt4W+bHnR0cG+7n4CmeIiSbtdSYeG1wcpKlhSZkjcnR72ugLi7uSrbvC0cbe2NZ1QVOpgRzs+filoK4bDO6p7ZhcLDXZHT74G+UR4RBqJVFnej
 reLkAO6B
 teNB9vtxT/D8b5fGVtk7sveKliWy4PRlaK/7aJ4/VxMRLt+0NwsfG3P4MUiKlzLAopcEPt09T/3Uabi5CLEr8s5X4KLT/IPWEStJFpuNohHsZ0sibl6sWiOqctWSJVHxj9hR5VDp/hM48aMHsKhJI/olj7ID0xNw7U/8nlGqyVjxFdjxD9Lrb4FokC9N/r7MdBur6L/ZGB45BdZ8LGSHUOhxoB3se0x6Ky9H1+kssxs4IOuM37aBFDURJeEhZ0cUPP5D2jLqC4fmQn8cArTZgjhHBQzKTxoSL3HNvSr3PyYTWbi6K5K0fNzZP2G0/2ht9vAHyiA546+Ab9+paHokEV9Df3qTeuwbQnjXy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 09:29:02PM +0100, David Hildenbrand (Arm) wrote:
> On 2/17/26 16:22, Wenchao Hao wrote:
> > On Sat, Feb 14, 2026 at 4:45 PM Wenchao Hao <haowenchao22@gmail.com> wrote:
> > > 
> > > Add kernel command line option "count_zero_page" to track anonymous pages
> > > have been allocated and mapped to userspace but zero-filled.
> > > 
> > > This feature is mainly used to debug large folio mechanism, which
> > > pre-allocates and map more pages than actually needed, leading to memory
> > > waste from unaccessed pages.
> > > 
> > > Export the result in /proc/pid/smaps as "AnonZero" field.
> > > 
> > > Link: https://lore.kernel.org/linux-mm/20260210043456.2137482-1-haowenchao22@gmail.com/
> > 
> > Sorry for the late reply. We are now on Chinese New Year holiday, so...
> > 
> > The original goal of this patch is to measure memory waste from anonymous
> > THPs - pages pre-allocated on fault but never accessed.
> > 
> > On memory-sensitive devices like mobile phones, this helps us make better
> > decisions about when and how to enable THP. I think this is useful for
> > guiding THP policies, even as a debugging feature.
> > 
> > Let me summarize the discussion so far:
> > - Matthew Wilcox questioned the value and raised concerns fork but haven't
> >    exec path
> > - Michal Hocko criticized the inefficiency of scanning zero-filled pages.
> > - Kiryl Shutsemau prefers a system-call-based interface.
> > - David Hildenbrand acknowledged the value and suggested implementation
> >    improvements.
> > Please correct me if I missed or misrepresented anything.
> > 
> > I suggest we first agree whether this functionality is useful for upstream,
> > before discussing implementation details.
> > 
> > Reasons why this should go upstream from me:
> > 
> > - Anonymous THP can introduce real memory waste, but we currently have no
> >    good way to measure it.
> > - With accurate metrics, we can make better THP policy: disable for
> >    low-utilization cases, or early-unmap to relieve memory pressure and so
> >    on. This is especially valuable for mobile/embedded devices.
> > 
> > Possible implementations:
> > 
> > 1. A new smaps counter (default-off) to count zero-filled pages.
> > 2. A new madvise command like MADV_GET_ZEROPAGE
> > 3. A dedicated system call
> 
> I understand Kiyls point about smaps providing too much information users
> might not be interested in already. So sorting that out might provide a real
> benefit to other users that are only interested in specific stats (e.g.,
> Rss).

You can also limit the range of virtual address space you want to look
at.

> Providing a system call where one can specify/filter in theory sounds like a
> good idea. A syscall implies that one has to write a tool to obtain these
> metrics.
> 
> The nice thing about smaps/smaps_rollup is that it can be easily consumed on
> any system while debugging.
> 
> I wonder if there could be a way to achieve something similar with a file.
> Likely not, but maybe someone reading along can surprise me :)

I guess you can open a file write to it what you want to get and then
read. It is awkward from shell to keep file descriptor around, but doable.

> Otherwise we'd have to go with a tool.

A tool might be more ergonomic.

To minimize friction, it would be nice to put the tool into util-linux
(or whatever trendy Rust-rewrite called), so it would find its way to
every machine. Eventually.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

