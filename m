Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D0BCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901566B0093; Fri, 22 May 2026 06:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B22C6B0095; Fri, 22 May 2026 06:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8806B0096; Fri, 22 May 2026 06:38:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7C56B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:38:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 007511A05B5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:38:47 +0000 (UTC)
X-FDA: 84794707536.13.834BB82
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 38AE61C0006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:38:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UspOzoJC;
	spf=pass (imf21.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779446326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IioT8eni5JJe4Tsa75pm/0B/3IuJLRVJTGewS2qygYo=;
	b=6S/J3Yloxo4DxVISiH/Fiko633Kkjfc8iCA7N2pUzIKFanbCsNGMkuZvy5elzgYhkArZbF
	mOh+hJj7eK2AFtsDXnSMN2Uo5mRrZfIL6LoqzMUX1zECWHTGQYNJTERL30Kak0HLFE/tOh
	NM52nUxs+mk9nyyXY+cwvjayb1oXRok=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UspOzoJC;
	spf=pass (imf21.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779446326; a=rsa-sha256;
	cv=none;
	b=1AGtxrMhFZbhSZTIK9KLS+olIaHl7VLr9WDLxpoRSkyMSYP42+UHL6ccZpKtfodOZwGZxQ
	G8nDv5i+kCW89UAonFEMmfIj+tFqyMrNeYiw0JRTkeCTN7xPMzXg4sS2EkdR2UvTOlC9L0
	Vo1V95jS3mi2k8trncXj19uYwMt+aTI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97FF726BC;
	Fri, 22 May 2026 03:38:39 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A20B3F85F;
	Fri, 22 May 2026 03:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779446324; bh=RqkMYho4Yc7kOH0LueJfnc6XODgDoRr5RXGQOP2xdjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UspOzoJCY9ZHGdIe6Cyq0b0XfQrNkoc31Jtobq+h2ZXnoL67m4lM9te6G9lQ31fcE
	 C/jprDrxXZsnHPX1BAGqyqOsKbbv7G3ejV/aOZKPyAjHhx0fda5F+xWeyqlUHlKcV+
	 WX3LAGb/VFlU93zbcYID9+eyjTgopzgrgHu9OPMQ=
Date: Fri, 22 May 2026 11:38:40 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zeng Heng <zengheng@huaweicloud.com>
Cc: yezhenyu2@huawei.com, zhurui3@huawei.com, will@kernel.org,
	akpm@linux-foundation.org, npiggin@gmail.com,
	aneesh.kumar@kernel.org, peterz@infradead.org,
	linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, David Hildenbrand <david@kernel.org>,
	zengheng4@huawei.com
Subject: Re: [PATCH] arm64: tlb: Flush walk cache when unsharing PMD tables
Message-ID: <ahAyMO_6UcPc2q4U@arm.com>
References: <20260521073011.4121277-1-zengheng@huaweicloud.com>
 <ag8fHYL-S26uO0yZ@arm.com>
 <ag8hmZ3kjtJINyIT@arm.com>
 <b7098272-a348-d918-774a-d5d2645fc7f4@huaweicloud.com>
 <ahAsPU00ZTTJV3Ye@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahAsPU00ZTTJV3Ye@arm.com>
X-Stat-Signature: wa8u683ezbngucmyzx6i6eo19qd7jjra
X-Rspamd-Queue-Id: 38AE61C0006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779446326-778924
X-HE-Meta: U2FsdGVkX1/Sc/m+KuQh0cg/YM6lJYEhDboO/B84YqS7xU4yBjPC6TG+hmTEujrcV4s+57mj9Q0A38jrYmuzmpM5q3NgWMVeprOI3aqJgFLG5s6RccgZ0Lu+jZiMA6Fi91bngcrgcq2ZLsk1uEuEWYWsSBEw7KIAnEJp8Z2TResm2lNN05mvXyAmNima8z2kWpCiD3m+4rEIsouHENLmXF3dtaxUF6wCy5Za0PiVGGual5lZX7whaUGtkbLRW7dTw3uxRGS8nxp+/3EHLTSOKYxsjJHFUpM6A4BFTdu4XNlAWGk4hnTFCrPOLa85YnFEwfutwK2v7kiqhtVp2DHCMdBDDEwf1DILBo+WbSyuvtX4w6T5O+nhRo+UhIkmYYOAZJBrP19vxzu+XKllT9I/gjDSUV5ZyQRF5Au5JEf035VvA7N3fZ9jENbqNv1HlfkFRS1txQBtx76HxqusDFgRhbWkL6NTXN6O0dVXZVuw6YgPpulZ9QfeSCRHY5iEkA1DJgRoBGSS9SMBTbZo3mX4fbvjLA86yNSQTsW7Tl5T4F2BV9oHYriMKPBIjvQoIGlKheoEMvJeLaf62xqQJpstymZPQgTOVnlSoe+/MXCuwV3C5pCSaeU3WTbthPYA3ziu4sdLaG9t6DWjb8huO1fcEV4jsbI4UITqbBf1dBO+QMsPJG/RXzyaIpMsPlIDqCwIjfTvLSIbvk5uFFnHm7zt90bK9BkYoajLlGjF1aq2p5Jfx2wL3u9YSdOJKd+ItYRSRVgocsWmc7V8lawIxPTZfr7JACsTj++NSKRAxglU3W6ufADWmPBVYubmBYx29s2wp/CqwX0Yosy4HzkIGa27fDJIUHwTchsBv0fhrmBnYcXGJ3n2LAeGO4yEJ5u/qL9FIXNP/OZFO+fTIPTXtTA6nlUCVUrk5bV6kZrJ7Esr9KDTOvxZW44cwj1sWzpp/aiNGWptrUsDblpgIGvKo6k
 mROMguZ7
 sWZo081ncbKAyf/UCY/aP4Rj72CuA/suRncquTEvulDvq/HgdEw+ayuTh+9YH61ydpIzH5pP7KI6eQ+sST0IO3hH4unVT+mwAkCzD91iLN6Ir/xN0tzDlAbJsSKnPPOND1eWm1QxARLiVHpseI94HwHoE8n5x/E5/J59VOlxUYUy4+/rNC7q/2VpI8dTGwLLHTSjyr6nn1gXDbTMjkT4+UGqSN0tNEQodLt7qvr2kyEII9IOXSZcb2uYW7oWfxs6wfDNt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 11:13:17AM +0100, Catalin Marinas wrote:
> On Fri, May 22, 2026 at 01:32:07PM +0800, Zeng Heng wrote:
> > On 2026/5/21 23:15, Catalin Marinas wrote:
> > > On Thu, May 21, 2026 at 04:05:07PM +0100, Catalin Marinas wrote:
> > > > On Thu, May 21, 2026 at 03:30:11PM +0800, Zeng Heng wrote:
> > > > > From: Zeng Heng <zengheng4@huawei.com>
> > > > > 
> > > > > When huge_pmd_unshare() is called to unshare a PMD table, the
> > > > > tlb_unshare_pmd_ptdesc() function sets tlb->unshared_tables=true
> > > > > but the aarch64 tlb_flush() only checked tlb->freed_tables to
> > > > > determine whether to use TLBF_NONE (vae1is, invalidates walk
> > > > > cache) or TLBF_NOWALKCACHE (vale1is, leaf-only).
> > > > > 
> > > > > This caused the stale PMD page table entry to remain in the walk cache
> > > > > after unshare, potentially leading to incorrect page table walks.
> > > > > 
> > > > > Fix by including unshared_tables in the check, so that when
> > > > > unsharing tables, TLBF_NONE is used and the walk cache is properly
> > > > > invalidated.
> > > > > 
> > > > > Here is the detailed distinction between vae1is and vale1is:
> > > > > 
> > > > > | Instruction Combination  | Actual Invalidation Scope                         |
> > > > > | ------------------------ | --------------------------------------------------|
> > > > > | `VAE1IS`  + TTL=`0`      | All entries at all levels (full invalidation)     |
> > > > > | `VAE1IS`  + TTL=`2` (L2) | Non-leaf at Level 0/1 + leaf at Level 2           |
> > > > > | `VALE1IS` + TTL=`0`      | Leaf entries at all levels (non-leaf not cleared) |
> > > > > | `VALE1IS` + TTL=`2` (L2) | Leaf entry at Level 2 only                        |
[...]
> > Per the ARM Architecture Reference Manual, whether only the last-level
> > page table entry is invalidated is determined by the instruction used
> > (vale1is for leaf entry only, vae1is for walk cache including leaf entry and
> > non-leaf entry), rather than the TTL field. The TTL field merely specifies
> > which level the leaf entry belongs to.
> 
> Ah, yes, you are right. The TTL is still 2 in this case for a huge pmd,
> we just want the walk cache leading to it to be invalidated. So no need
> for the additional tlb_get_level().

The Arm ARM is still unclear. The RVAE1IS has this wording:

  The TTL hint is only guaranteed to invalidate:

  - Non-leaf-level entries in the range up to but not including the
    level described by the TTL hint.

  - Leaf-level entries in the range that match the level described by
    the TTL hint.

But we don't have such wording around non-leaf-level entries for VAE1IS.
I presume it would be the same but I'll ask internally next week. In the
meantime, I'll take this patch.

-- 
Catalin

