Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16284C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108586B0098; Wed, 23 Sep 2026 11:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B95C6B0099; Wed, 23 Sep 2026 11:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEAC66B009B; Wed, 23 Sep 2026 11:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C11306B0098
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:24:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FB3F407DE
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:24:31 +0000 (UTC)
X-FDA: 85245398742.01.864342E
Received: from mail-vs2-f43.google.com (mail-vs2-f43.google.com [74.125.227.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8AE8680007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:24:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hSk1TGGi;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.227.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790177069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLCbEVM2yeFpINaieYUT1nKrAhZHHWf3GyoE7bLHvDg=;
	b=KyF3WvjFF77V87EdJprXFC4WFrBulLdqkthQbuaYtUy2s0spmIQM07c8qYZ2DTE2iN5Ocx
	6caBGBkX99HmV2ykj9yCZaR/3VKcN1HsoZybpVpRRzcuTeFxCkjmscPe6GBEYs1kDw9Oal
	O3wpJ/gIG4H6P62lj4lYnwz8brnYElQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hSk1TGGi;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.227.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790177069;
	b=ICVztHfBco/cqLoOCsmSsgBk4q5rEYIWCXcVhcyXGAAh16PkRXkY+5g3l63rrIb1XN2pez
	By5RnO/C8Q18mdEsJF3SopJTfOT38JtJN5Xttr1V9Af0biIMsYeVZtTRz/Kqw33g0rvsCq
	gD7j+aF4JXmnM7W3VBQ6+xbODf6+qAc=
Received: by mail-vs2-f43.google.com with SMTP id ada2fe7eead31-785643199baso398366137.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790177068; x=1790781868; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DLCbEVM2yeFpINaieYUT1nKrAhZHHWf3GyoE7bLHvDg=;
        b=hSk1TGGiy4wwyqEp6+GsL+GbHJBGu7OBqr8R8V83oevZI5zUM+S/TCgSloLmtAd06x
         S18VUvl5at7UUkZiEwFRhJYPCk4+OTthG6WzYSq4jQvHd9aAj0uIPLcOuWewRHfegQro
         W1nZJZQewa9oodYTPA2ncGA+Af+DvqP/9212yTW40p+Eht+gZqJEXLcI0XhpnAKrjXjY
         QjrpdxZt9Chb5bRxHMXTIn/oW8CX11jiAxnSWvo3Ty1N7nR5eO6Foin+lfCHRYBDzm4L
         9ovcqHB2hDQVYYOIxByum5HzEt8UwAW2M+lMao27vQLBjAG5VMKU7saDzN6KB8z8F9QV
         3zLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790177068; x=1790781868;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DLCbEVM2yeFpINaieYUT1nKrAhZHHWf3GyoE7bLHvDg=;
        b=wTSKjcSKcN0RnT/0viH7dhRLPjtI09I7E4Q6MjFgRr8sE7eES2IGp/+nr/Clq/vCt8
         K2q3EAGaWjy1DN3zHbpAcMwEQmb5UAM/NMplcxRK2B6tWebTRpYlSUPQ/nCzPoYbnF64
         MgsKwdfkobu975V45KG4oqvl0qCOaJ6VtjF6rfCaUtEICTcnExIJqMy9c4WPmWBWz7ic
         pfhGDFOxaeR0oO5Rc0trbiYoKSgxHLPC7Sa/PTrqr5+l5IpohVAELgN4scbukQx/Slt/
         4Q+X6kAV6dY7lPawX0lix3np5E4aw5G3JYMqth4xylUdCGX5dWIe78s7hlVKo7/EywNK
         hmDQ==
X-Forwarded-Encrypted: i=1; AKwUvBzSD2RZW45UtmaptQHMmUcxnqwrhN/ZqXUWgj1MUw5PIONevSU0kIc26JYKtGnPrrINucYQpf9+cg==@kvack.org
X-Gm-Message-State: AFuF++nsVh800m1iuMJY3X0lJrhiWL2lZFliziaFthxijzvSt0OBRBDV
	KVySVLjs5u0q0cTWdXELXYr6b6vnqKi/HEy16AKD+6RmOxO3qTmMaOi9LdNl8qnFGJo=
X-Gm-Gg: AYBFou0C5SPey5bX02yDy9Pz7HPTZmYpvVAJXGVXB+AOVxf0278On6Lh6qEvoRvLL5t
	F6xnE0yxcKYO+GssfJrirGn5NbvMalSaMoQbPlyWrdaZo8CcxE8xUpwlvJmP862p33iiSSptnml
	Jkbt9yRgCpsN7/PYlu1kdOnpaj8/Lpi/KYuvffobYk1C0eTMC7idGyCZyC47N7hzzi3TUxiTygo
	W23i5MpDx3fWjB7vf9J6YzSw2m2d7bKsH+tyPpRggZGRiek2zO3DwpYpPvanqGxlHjP4gmCGSVN
	6HjcvI+0XgpQdt+yIJt9/1pcXoPzt8zeY5mEZZPg+B6SoGWFFGEzi/if+vmyL2o082VwjMNGdsN
	QhLUUGAK8OdHVAu2f2RfXN+Sjgo6ohmj93RUjNnHIF5qDFjkm0rkuX3+hYx0pTID8Vz3qJtn3jM
	1OW/f9roeXfZHOftZ7hMs0zl/pZhnB6h9j8AUnfqYb4IXxH+g4Ppu0Efu3Ku0hSSqTKERSS5QEZ
	M2WGOWP8EySUyP0RK+Nh9qUS9AxADNVYzbW4/KnbN+bm/FGyCA2R1c9cA8eIXieYA==
X-Received: by 2002:a05:6102:2b89:b0:7a2:2148:c800 with SMTP id ada2fe7eead31-7ac1d2d4b61mr2458963137.17.1790177068540;
        Wed, 23 Sep 2026 08:24:28 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2485dce4sm250217085a.23.2026.09.23.08.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 08:24:27 -0700 (PDT)
Date: Wed, 23 Sep 2026 11:24:25 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	rppt@kernel.org, baolin.wang@linux.alibaba.com, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, 
	kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
Subject: Re: [PATCH] mm/page_alloc: let the bulk and folio allocators carry
 alloc_flags
Message-ID: <arPut2xL8oU6Hr3F@gourry-fedora-PF4VCD3F>
References: <20260914155115.439742-1-gourry@gourry.net>
 <20260922130558.48402-1-lance.yang@linux.dev>
 <arMxm4ia5Md-Zt4R@gourry-fedora-PF4VCD3F>
 <80206444-d0c3-4dab-a5e3-a2909e58ea33@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80206444-d0c3-4dab-a5e3-a2909e58ea33@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8AE8680007
X-Stat-Signature: 5dgihj8b5yc7715hjb67iicgtooamuee
X-HE-Tag: 1790177069-49124
X-HE-Meta: U2FsdGVkX19FcZdY1XAo8sc/t+Tlf19CrXngH3vnNyf9r+wTeJuLOXzcN1pm989qeMfau5OIyqW0hB5UACIGcBPOw8YX39ycgcyZPUVwQWcRKNZjk89xc7Qxe+RxXPs7wVZQhVQsf2N/S+9MTC4Jhwwu46DhkR0k1fHQoKfs1jGWELbxJZPW7U7JnjX33VdNNcpgdeTyEx2qJL79qJ4jQdxCedvvtlIRoqdx/0+KaWjybmQanE7yugs7ipA0Z+UzdlT+qaxJOjyV7G7gEmTCvNuZ6QmJybVQURj8hPGbJNBsoKEvEiRNmg2C7hkfugIb9m2cm4czk1lxGU7jfZOLa3CZT2SlOuCitGgDcIvp70IeTxBKjj+3aKcblX8c85Bev+IvR2Fa9LQTbkczSKSbE8e0qogR0TVUx5cyhuwhrfxKxJkFCoMeZctlTQQCn9UnKR8Sn90J85dPpHSnTpVsYHg+49Vqp/tHrM8n9LGvdQSlv8PjMg/V79eNabQXpDXPGWtVabkXdCq6x3n8IjGRWPG2l2hpHA9Dyww1+iUBM9xXgPmPUesSUjNyjIp8x4nMneLvdmao2wmLRVo0BtfTGXvpZtmdsLWOFLh6B0ep6f28yhwxcnSBWKS/i7ufOOAPAFQS69H2H4/3jpxxdg8pEth9V1Mrn9JiCR+r/yKx4uuggQCjTbUM1Ln7QsqrmvVGu9B0P5KNLu702EkpbFW5wvCcYhsXLn2FjrN9Ahh/7UUgqecl/Lp9eIY6ykuJWnX/XIHgYid36W69rI12bvXucUUop6oBaf/hoBwBBDAgNsS/TyC0h6M2O05r+hzkhhoHwcYk+G/fs8PSZ0pHk7yqoQJScwKmoYaE1w2/iOemo2OsOAGTMsPQeIfmaCbJyBbfaKnzlk28FJspKAUKjGPZ0RCNeTYQ93F2lyPxS7ddqB+tKbu3wKZcHYmiQ/5TC+mC541uJyFZ74irZG8ubDT
 C0mgBGFw
 XgeflubISAu7gBI0pDAflYYQBAgTNdMpGkqJOsx6APqEUxqB8sij+huBCl+51WnpyV6JEL67L27/QTZLWmrrENN/4vDe/+PdR+wEi5Ik9K+gxnhsUl2frE70cBHKMqM03IXyAEGVnhC7sX6/5YScqWLJADkTSsCHFasu0BcrKV5qdHkKYrTQN7OuDI2Wgm5Yys/MoIlpPLOpg0hl4LAKn9fqsNrKUKVTvPS0Oom7N1XhRnKmQu0Imc7C3mPTEH4yWyLA9ZFGzLyzkCr2nezmrqar5E36OZgA20yy81Wr15YoAdM5aIjLDER44eQqijpKvMIGwzs02BGPcuFAG96iaKe5AiAwSOycgJxl2EoRT8kHztI1IAsPRz9tZk/NWdhMzdguZwvebDbjJH4FOUXTJ4c5l3XdA641YeQOpAqb2k678nqlEVJWcyxkOctMmLxhwp9Wm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 08:32:29AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/23/26 03:59, Gregory Price wrote:
> > On Tue, Sep 22, 2026 at 09:05:58PM +0800, Lance Yang wrote:
> > 
> > There is some concern around NOLOCK here yes, in fact sashiko picked
> > this issue up and I've been poking at it.
> 
> It's possible to document it as unsupported, add a VM_WARN_ON_ONCE etc.
> It's not necessary for bulk alloc to support ALLOC_NOLOCK just because it
> takes flags. e.g. kmalloc_nolock() supports a subset of gfp flags as well.
> 

It seemed simpler to just support it than to create more future
footguns.  I can RFC my current rework if you like, i attempted
to deduplicate the logic via a prepare_alloc_flags() called from
both the bulk and non-bulk contexts.

But if we prefer the WARNs over adding the new semantics to the bulk
allocator, that also doesn't seem unreasonable.

~Gregory

