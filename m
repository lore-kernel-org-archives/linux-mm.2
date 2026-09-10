Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C7EC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384DE6B009F; Thu, 10 Sep 2026 07:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35AF16B00A1; Thu, 10 Sep 2026 07:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 271736B00A4; Thu, 10 Sep 2026 07:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E78956B009F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:08:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DC341C1E42
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:08:02 +0000 (UTC)
X-FDA: 85197578004.14.56E808C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7BFD9140007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:08:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UfY+BBiU;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCce3z8dCVOONWkuUk8CK4oY+wdLNQBPcWJtewhDSRE=;
	b=n7SeO+VW5E5JEEMcgFgUw6V6taBQ2L2eE79smTmtNdAk+XoI1a2ken+C9TvpKc+DSsE9rr
	HER+k5rU2WCX7x31Tqtqx/dTYryHNc2Gl47tgpPErOo1GTalNyuo/S7ZJduzEyZEXu0lUz
	Lzl8Tk+jrrGRj+AtpeKrfx0nVlnmYh4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038480;
	b=MmGHYHq6slCBkgKjHgPfdkS1tdjrhb/UJcJK/ga1tCKikohMZgTIphFgi0bBcjIzXEtfMH
	Y1eTykWvZdgcG6ouq/sOKCm59YI+L6trTrFTN5K/FXZ3aBEFqhwX+Gt7IIZ2YJJVnzmV/U
	wzK7kPVBUf1VWYXWQaRjOy7CY+b+aC4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UfY+BBiU;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB9FB600C8;
	Thu, 10 Sep 2026 11:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AB01F000FF;
	Thu, 10 Sep 2026 11:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038479;
	bh=pCce3z8dCVOONWkuUk8CK4oY+wdLNQBPcWJtewhDSRE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UfY+BBiU3GmNgRgmnmlEVQehpWmEe6l86q3IxlwNWdQOeajZTek9GZluUhB+HWPpl
	 ZUMpUSW4rTr6yoabrHmMs71qKbsBXqcJWBE7a0xczru8ePO5yh+L3rzSheSHvNPqEW
	 5jc21Yg2bOquawBDYkm2pXvYjuB/fLxQFnAA9Tlis1zCXUW5VaQzOH/bXisEQMdeGo
	 0eqTHhaNNVQgs2/X7Krzkzc18IAblcwPYjYpiQA62vH+OP0H7lRaN408h2QTybMQ78
	 yoWNU+D7kzbTs08abGRCeZbCDNqXI7WXPYPJeOyz2c4hkikZnOCWGCkWydxGtAFrOg
	 QcND5/OLUro9g==
Message-ID: <4f90d69e-e1a5-40ee-a3ef-38e38c1efb8a@kernel.org>
Date: Thu, 10 Sep 2026 13:07:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 15/21] x86: mm: skip collapse_pud_page() when
 CONFIG_X86_DIRECT_GBPAGES disabled
To: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-openrisc@vger.kernel.org
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
 <20260902-dummy_ptxp3-v3-15-5d8f5b17c25c@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260902-dummy_ptxp3-v3-15-5d8f5b17c25c@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hc86d8emu8nwca4ytgq693gxkin85r4x
X-Rspamd-Queue-Id: 7BFD9140007
X-HE-Tag: 1789038480-202526
X-HE-Meta: U2FsdGVkX18NMWupM+JqqOI63z8t6IAsTjpHqiW8+/9De7Magy5/+q/29+FS/khfqWciqlpqLMEnspme8oXArbi44QXWCUvlAYW+gWylp6GFi9oAKB49WQSqtomtEX6WNdrTqKLB1Q+707O3cZvyfVzFKvSi20DGJGDUBIOT6B4GE7I3AoGYTwRAsq6OGKNNxPhPnTDcAAcgcDYS41HR5mVZKrbMHW5D2ptndz9dDhQ/RsVjRyg/9J0XrxXKxcr1St0GLaHLqYx1rh3VdFmAy6q1N/u2hxjsd2AZN7ebHqGXVcdbk2dmjStq3dwtrFsnFVvf3s8PiTvP69sDRI5dgs1nIJ0+4cPmrHVOP8xuOpdGUm1v5A5mFsvNoB6nXOe25An+MrBqTjV+/HjlXHxFMG641d6Ds/GR2/caNYVrNa4Cu+B3UzMvsi4WUM+s5v0WfmpRTGR36HDYW25U28BV5CQlao9GNz40758Z9Dee9KPBmvNzy7VYuL3tr86YoWLMuTiA7aiTUuGyjRxokbXOPgl3+8+BmjFcbdh53585njT1CeJY2qqBhCgtytJ61Q0rbtTAJzhDz6h6tUCo2f0vBeiDoQzc16HUZIGJida5kr0LXllZjjj4H+ocI8vbpphKwPJ+/Vmd2jXW255Az/FjiS7jgQiawkNiB2QxceVd/zHDsi61DQmm4QB5JIMXOL+FcYC090oQETNb+cQfIzsgBXcxrLGQeiWymiyJVpBun51jcBcdHNyaEy2K34ErKoCoodzinlB6e1lZaoZwfQ8251+t/0j5Kd+Bu2HMQGq+1Ir7FWLy3n1VE7nj2QLUkuCP5///mqbOi+K0Z/XlhEpc2pYpObMmDz8yYohJdiccPMrFiLNXvIAZeIxXNE1++yInInQ9y27VR/oKf0io/DwAsnLVg1s00vJ2AcrWmB8eULH174MDNG7m9gVR6wqpjH/4KhMu/ULAIn88IX9h1C3
 1mYONjA7
 dcdEeNB84eByWKzEENa3iXG54ZFbc75kxKZTQL+1ghRjfZ1KiQ6mwtAdcoZNSdSgIweSD1+egSyjxZZbhx+jPrXD9icJWHz778H4D1vtT0o3YXx6G8Hi4juaic4fccN20SEH+cWsNm3IDmiJZHw/EDeTzTZdmwPQi14VWozYXu/XeEtR/PPqe6Fsmv7QlgeHrl7plj5PmbHso5s1JD2g056M3L3V/PnQqYnNKkuAuH3dymj5+PrFs5FMRxI9MSsdGwItkn0XDdiFD0GtPO91K5U6YDLY7phn5rAEx88RN25bfDl6tlniTT7a7iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 13:56, Yeoreum Yun wrote:
> The behaviour of pXd_page() will change with generic compile-time folded
> page tables by disallowing its use and triggering a compile-time error
> when it's used improperly, ensuring that the actual pXd_page() is used
> instead.
> 
> To prepare fot that, skip collapse_pud_page() when

s/fot/for/

Agreed that Dave's patch is better :)

-- 
Cheers,

David

