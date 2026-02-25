Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C83C8FD3758
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336936B009D; Wed, 25 Feb 2026 08:34:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F78B6B009E; Wed, 25 Feb 2026 08:34:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED376B009F; Wed, 25 Feb 2026 08:34:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 094816B009D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:29 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C4B6C1A05E8
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:34:28 +0000 (UTC)
X-FDA: 84483073416.03.B7F5CBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id F066D1A000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:34:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M2raHCHF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772026467; a=rsa-sha256;
	cv=none;
	b=7IEwdNkCUuUBs0ngRkzjT5wABqISI5aAMHecIe4PZ0q0/6gnX0xjtH8nEQKHRxReKK+djx
	VtIGW+mjvSwajdXoxHVT9vyOLeOSxxbQjKZHLeip9VUyTGbECxoetrp0JvOwFu9i7Doxe7
	lcJ9UNMtx/SSuHkKIfLK/zHxpQM8paU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M2raHCHF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772026467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9RsTWDf14QtNv3DKRjlmmqkSfCmRVGn4apdp3Oe3I5A=;
	b=vGt88zdBBBGzKFuUGsjysKqyAyEWokIUCCyVoLVmPTkgSebWLTwOWlR8NhoyOb+eDrvNEo
	knbYSUiwizQExktejoa9iBL59kMIXuauydaPJ/mCzHXQ561WKVX07YqPEI2fc8TtGQUGLZ
	DSleUfmw7wpQn+jq6QHAhkMPuNuh6lI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD242409BE;
	Wed, 25 Feb 2026 13:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA12C116D0;
	Wed, 25 Feb 2026 13:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772026465;
	bh=I4BmllZon4wXTUwY4iaEDQa03sd3XDaHKo3rrTsYu58=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M2raHCHFjbQuoKN+1JJ1ithXRJ/YlzK5Ob/8MKCToeVRYCT8YDXNPeJ8k2WgICu03
	 ufOVHoUR3FIRjOIWBF23a1EvEvFuORCt3Una+Mv+xUf0677TKWEmhmiHcGp+ElYZyO
	 xhessAvmAdb0RpW5u1m0cx9TKai5n7wDD0eUuoJwA2oCWdrQKTty1voqTXmUTf6rus
	 UXX9Xuoxu3WAYvzPK+Dl4vRDykQBY07Yn83bTzUEAOUHb5kGuqwKKulSAzmZJi1ypa
	 JUVvUUAz4mFtlHAgVyK9mkufEorz/9T0+UsBATDLdiz2GCFK9he3uaGkEXkf0gjV8H
	 SLUaGvJQT+tsw==
Message-ID: <01f4a679-bc4d-484b-a019-0e07fe520363@kernel.org>
Date: Wed, 25 Feb 2026 14:33:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] x86: shstk: Use the new common vm_mmap_shadow_stack()
 helper
To: Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>,
 Deepak Gupta <debug@rivosinc.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Will Deacon <will@kernel.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-mm@kvack.org
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
 <20260224175800.2500729-5-catalin.marinas@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224175800.2500729-5-catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3u3rh68gcegakdjbbuk9w8k3q5a6hm7y
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F066D1A000B
X-HE-Tag: 1772026466-251627
X-HE-Meta: U2FsdGVkX19+QWL+XqTim0xQVFgttSYq06TDHk/DZtGfSEiHsJTxc80B6hvmLg19qSyG8eXDwpCpyjIchD6xDc77HcEXBjnGn3TgD/a7Zt2AAwgShC/ym7Zbju7N+GX85HBBgJiQz2luZnHRy/EXVcMosa9EDVj4qFIJS3tg/VL80hiWtHLKb5M7MyQKo69qKY5W/tNQ7v4gM5gCwi3DTC+8ytMlyTabJHgxt5nso8VHoyYjdp5+QaBAMeRHNygULCWndEcnbBd1suVptHyePAOmSmsRToGNjMEj/RIzCS32lpt+0HPHQIgX1kiCb5exmaAdGbaQfTxnAsYUmizKSTxjOY+XcGSgL7jP0qjxY44ySoYnEK8LgQH9Mx4fOdx4FS0edRSfAURkXB+vIGbV6Uw0XLD6drfGDm+mWY6t4Ta5bW2QpOV7CQkBY7KWWv/raYYc4dsak7p1JKpdIzEOTH1fgpW4XUoMovdW4MjTZTXFUSANBh9VCsPNgD3eduewMk69gtP/QRueSNYoVE91/ysOVTkZHAovG0uiFcXMNMeONElXV2ume/oaca88jLjnWxS7xmCa+i6GBifFUU0n3RBJLOtmSWJEDLvbCrFMFxHdT60YuAtyIxCg8YHNAGG0e7HYe+Mk3/CqXT1gDrS+K39FzBYIPVn2qZdLiF3pxz4xKq7tpyn0rVbvrGj9vu+GD7dmspNvhmnNiN54Z6t1TrFmpD95BAz9+VIErvBn1JBiP4+pDzr+/GQnOrd/HLxJJYFk0L3QLGiXweYM9XtnLMpuNiTHBInGalhYISHxrf+czqHkW7mxoPrdF3o+SsEM9AXymSWKTcA7pZ4MsEGmv9OosXujREhY4J/0ClifY/MIs5Uey4j8iPaNAGw7NRYIJQnu6fNH9IcxGF/+qmFR+u17ZwxnodktaYg9OXWpebMpJ0vB2WnlY+d35DhW3nIzPTCOZPFVhzE7aSOx7jA
 rW+QZuCe
 fZQZiFBFCAQULFVZq8sRybjDHEI7ZxNUgY1b9NlhTTXAP/HEViYHlTBYztxlOYqhz/+3t9OLIptShLl+Ifhc2JVbEu3JN6xGPCmR4trCD+DPJYpNBAKGevQ8mwFGInkjSb0AoXl6NpMY6gWMXN9lFEY+aLuL4n4lS5X+2P/kJLXK3i7fQknP9NQKDh7QcBnKWbuy472VF2QC1pLCpFBOdg9WbysccjGyy6d2FhysOE9hq2gqs2ZiSfK3xUtc+OkyeqO8fw3NK/5MIunj9Xo1SjPDUEQf3b//GKMbcY0QazuH1/Ah++gc6V63WhQcUw1zumeTq4fofVhqnoSyoDYGyCuIxLYPmNISgFcLBNUS3u/wB9jrLvv47agq6A12b2ppYjsXYdw9fOfnC4ixWAyW2WauDWnda4VKgxG15HfsfHRIqyiHfXSr1U9i1AOI8hdOsiDOlaWHLjSRRIPbpYivQUv7EYTHFQH2NXw76wdfaZ4j1GG884wjhU64SwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 18:57, Catalin Marinas wrote:
> Replace part of the x86 alloc_shstk() content with a call to
> vm_mmap_shadow_stack().
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Thomas Gleixner <tglx@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

