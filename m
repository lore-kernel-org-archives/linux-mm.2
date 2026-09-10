Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E4DC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3E86B0093; Thu, 10 Sep 2026 07:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4DD6B0095; Thu, 10 Sep 2026 07:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BABA6B009B; Thu, 10 Sep 2026 07:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0494A6B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:05:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 903641604B6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:05:37 +0000 (UTC)
X-FDA: 85197571914.08.512431E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B073B4000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:05:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O9P4brTB;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YZk2wCzZD7ud7nbBKJ04FWJsPn8EDTK/gTOXxFQNOk=;
	b=Yqiy9JHF45EOv35yk1MWUHZD4xwButIrSNPWFoz7lVccHPDDrWS84ytmi2MZ4Z/op1ulI4
	SPu+Wbb4By7EbktD0CZUzWTi7PtaxnZ1K2KxBQpOcb/eVnUWl3+RYpWV8QsS5MzyFBouD1
	xq+v/2lG7vlYpqhC6vdEXf7HpXIyVXI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O9P4brTB;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038335;
	b=k75RkHhtDH2kS6Ia8QjJO4SNuWPzNuaEOmP6JCP9XacQTwiDtwQJy8mWAE+CIaRbETilm5
	FUp7+30zwgKoJJ8eGeCkzEjHNyybiDY7bb3X/IGhioch0WnzhgUHRd9kRIkwxWafeFkgJV
	XlF9PiRRr+0pU3R/N885DpA1Qup/Ygo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FFE941FE2;
	Thu, 10 Sep 2026 11:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0541F000FF;
	Thu, 10 Sep 2026 11:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038333;
	bh=9YZk2wCzZD7ud7nbBKJ04FWJsPn8EDTK/gTOXxFQNOk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O9P4brTBs+SaRO9GQMBGP55ozrj8eS/wvn34kbSVOVVvQGSv+4hQWqHtjF2Onz9AN
	 /ZlxWsqUVNcxSq+6K2ChEbK2QSC0ahYV+IaDzTtpnV5KIEA34pSjHKM/7MiMMaRg4N
	 6NGjbWhVcr++iGsRLdFZbdsf/hVDhqjrx8QWxMfTYgWBo7qhIU0H+PuySBwNV8ZW74
	 Z7DtwGRBvklEoKCi+kEiUWK8uvvtvZFWP+zSaQfmwL4UlRv+cX3UlhBnZjUnzZtiEi
	 0Jq8KHz8OyRyjw2fZOKgZ3v9cRudaLuE0woLzUhit0+rbKiNXIUYldYZPMLGJ25LzP
	 fQeVdpHeQUxsA==
Message-ID: <4b9f8ff1-8b9d-45f5-9012-b648d6e16689@kernel.org>
Date: Thu, 10 Sep 2026 13:05:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 12/21] mm/pgtable: redefine PGTABLE_LEVEL enum with
 ascend order from PGD
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
 <20260902-dummy_ptxp3-v3-12-5d8f5b17c25c@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260902-dummy_ptxp3-v3-12-5d8f5b17c25c@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B073B4000C
X-Stat-Signature: qnoywzcck1tf8amgw4rmjkrgusn848yj
X-Rspam-User: 
X-HE-Tag: 1789038335-301819
X-HE-Meta: U2FsdGVkX1+udpxq6JeR2SLgU/jW2P6i+qV3G/mrIgKb5mvFX1UdxgEAb8T3TvvryDHefGrvd/oj/ggpzaoC8s5EwCaDNREtJlME1nfhXL6dMxnWqUPAvgLi684YfjpGC1UGWbCqy00qlzMDIqA5vBoMvkbT/t9twG1oVV5ZTXv23CH6FmFxEd9iMTWQMlohUhMvO2jUaEI5mug+RRqhnmlWu10CUoCk80G4f0edhDMATM37nD6qStg4/Hb8wTIQjaiNhe5bO9gESKnoMylpLbBXDxEo9lHbxqoU3G2DgjPkkh6unRAMVmQSnZWVzVJoojtmu8d8BNKF5jvHxnhwLbpNVoZbUBEXb+yW3p0y/9qKhlKR6+1l3U3i1Qctd81sABKmQXJ+ZYcplaxuMUr205FXjL3SXDBN5yunrcH/yoW6hK+UNSFADxTZKcv3RkJLlI3sbPH9MxtKrpOteb2AWbXRa7fPDRRnqla/WlxgKi7O3SA54Hn8CYyASES7h8L+vTLoPObWZ3DIJmHTpfr0+R9ViI39P5mEw6k9L+WAdH20OOp73MMgG8p7084BQnYvbrzp1moKokiqzngt1Xvp5vsHkDcvpovdsGePKb3N6pHWSoWToQR3xy17k1qxkGDL5yhTE9yniYw6migR4NDUQkQycfe0Z+qtJSwaR7iZSVCJKy7RCvPWjM++onEfFwH3L8oWI9shbDjSgca+MG9sYcTimnsE/5MelCY0IFhND3orU/WfYzHXQzpc7By1UoCF+q3fZXnoq8gxsG01bpFGWDUfMEmVR2sNu4L9L34SFXlCZVr3A6VlcPD24v1lpwIVe+8+7ADU5q2gVjzS9gp7qsxY3yDUtxhAKz7ByCQ62elXEFNwGxn+JyUDCwINdbk/XR+/ojOPVvuNzRwsx7JMydj6XHCTBl2HNMj37+HZCMPbRQarSM7Yk9PnRbDgKphtvt3laYyVxEKIm54MhSS
 uePP3JSO
 E162uKjBgcy1cHFfaxM0WRsrSupFZppKd787ZEkn73tgm5KWS229NirOt+tsViZ88Plg89UH9UtbeQPcVuZZYlC72fr5PW5HTOTgLOUOLSx9p1N2X6b9FIvg26n0pST6Z7qqiQ1YJap+VbVzXGxQ+dY062u0HVgZlm5I3uGw01MFOH+5g439x55vdfpTj88PO5/cETS19FburOorkOaTNHnAju8tAVQWq7RiYZCEzKGSr6OYOM6vKws/GkLzXP1AZyEoCzwjhDDaRiUwiyBpmUq+GNT5ojiFPOk7fAMBF+IS669bPopNItzkZcT7Su22R8JIUdL1okxPR2gmJZi7QyS94cy1TI5VYztdFXtQaHWuDA5iVnqUPIKqs+M5379WdHScK2u69Ab8jDQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 13:56, Yeoreum Yun wrote:
> The PGTABLE_LEVEL enum values appear to be ordered in the opposite direction
> from their intended usage.
> 
> Intuitively, higher page table levels should have smaller enum values,
> but PTE is currently assigned 0.
> 
> For consistency and cleanup, reverse the enum value ordering.
> 
> Since there is no current user relies on these numbers to be ascending from
> PTE->PGD, so it can be changed to be ascending from PGD->PTE, in the
> direction of the page table walk.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

