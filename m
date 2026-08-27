Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1830C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 18:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CB56B0095; Thu, 27 Aug 2026 14:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BCD36B0096; Thu, 27 Aug 2026 14:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5C46B0098; Thu, 27 Aug 2026 14:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15D346B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:08:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A5F580141
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:08:56 +0000 (UTC)
X-FDA: 85147835472.03.3DA7B12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BE5FE14000F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:08:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cXyX6QAc;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787854134;
	b=2VgoAztt/rfPTJUgcsP1k+kzvij9o6HsY51lCybVTvm9AeMpqFy+OJ8wrcLMd0XSRlzsa7
	4mAjHhoTZ7bwAIXzjFLodaYmKwCa/1IRAfkLGNNbwyQj1KkADzPQfPSppmeD4ZadAa0xdm
	1wep1GYSOzgIIdd+BSdIf30EVoNMP4c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cXyX6QAc;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787854134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSl5wDfcIkAZ8O8qomImZnYhRdtX0c0/b/+iSOoYbbQ=;
	b=bkpIcRdSOxTLToaRqmEbcfDFzwlb2hYvCrwLCh0c0+7zYMtb+JG7nlFtEnus8Rjtu7Su5f
	oBIt96nLXfU5MqLorDq46DlpioiK8AKeG6/OrXLAfeyygcE9KXHoLLKZElVKAGfeQlwpj/
	PdJhmT38f7K6tdftJZmUgJkSq21qO/M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A86AC40C40;
	Thu, 27 Aug 2026 18:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EAB1F000E9;
	Thu, 27 Aug 2026 18:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787854133;
	bh=oSl5wDfcIkAZ8O8qomImZnYhRdtX0c0/b/+iSOoYbbQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cXyX6QAc2K4hCCa6m0zAE3YE+kol844hbwpydqer4TYoxKiPxU9IgtmzJzyCj+b6Q
	 HbZTJJirRawJp6wgO+QFl2O14dCAoQuGY8J5x15vAraWVlo5V1zIEToDQoMvHfTqfF
	 d+bO0MJLxRa/Ek6qVt6J+6z1fa+c06GVGlL+9vE99Bvi+eDwvRd6kwxT0POwAhGNAf
	 ED3biHX6G4Js7XuAL7Expnqsn3eqs9QIJhSf8DYmnz+lVOHdCOgsAa4x/xyB4UcIZe
	 KRQJJPfq+mQnHzMuh0PBCy45zrAFbWhn1Wr0kD+add/DyPLajZyBIyobOu/Vpw368x
	 gHi8Emr0IpY/Q==
Message-ID: <1dc8739e-4eb6-4a71-9534-e03a15afd620@kernel.org>
Date: Thu, 27 Aug 2026 20:08:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 13/25] mm: kpkeys: Introduce early page table
 allocator
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-13-743ad31b2c8f@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818-kpkeys-v9-13-743ad31b2c8f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: w87h3wzd53f8kdtab3fnyk4df5zeggo5
X-Rspamd-Queue-Id: BE5FE14000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1787854134-755012
X-HE-Meta: U2FsdGVkX19w6EcJcJqtfwQ8C3jqybcl/3NQ9ZR00DZ9RjNC+20fhm023m3LMQ1Z4tYqtd8xYb3gKotT+gI+Smd/y9VS2zP6n8UCxi5VG9/dp3xWUXlcdYKojPND6uDMPOW7WnQXRqkVSoQhnFcMryMQu3E3IQRW3g4CQSLRRhfQcgKfF5HWmsvOKc4jwWTUI5SeHhFh2wUHYGB5b7s4VuH8wQc/ntHWJkgsu7vaYMXHWIjQ+aFOyr+YTdkeusMz/xzqO7Xi52OB8r83CSZyg8ivVDaqMudNDm3q17kzCzo2nJJVVTiNqz88qwalvP3lxoeY8sTFV0+i8D/VUHXOBSC9jDKta7llsZsagNavQ7oiTel9Rt1jfeR5pX46TWdhqmcPg3e8z1ImW57s9ycLua7WGC5yztMzXPLKFabLYGTgqIS/LQiPPvYwG6X6WxHX3FGfxyVS2GAnybyqr05/Hz9YYNCe+XTTcpVbUrBJRRuq1OrlmkcrYZPrH8UMLTy3KiJTBggwlyx1BmqeAVgZlw3ptexIvPmm9m9tGk7wGPPkpMiSLUQPXpsJFAGOkOsxoHeg50hkxhUtjnyx5qgD/4Df3fyDid2QzDZgNtj42YincH8UYGZTq5tWIsckJGnT/pzDOU4h1RfoIqkTXTYim0K7jbupnI0SZmXe0uNIMSZ2oQI2oPMevYeC6+U1pDVhziUPIDNrXcZMis/+P/92YYY91rm7VwJgkLqL2PGUxMpR1JS8XnfRfobxg0SfeYobIaqgwXQ5oj8tA4Ii55KsoOii0zrUkSjHF3h9Sa8EX8o0vJrW+jGKBBK01PkUaVfWcBUOPMqqESkGrto9WRdhP05BBHVk86doWyV0AI/YNdFX+We7sMZLK6I3/kZcT8Ow5cuMIzAoan3ByVM9vXrAartI9LSCQsmAPrjMXqPwRIVlid8Ux5ImK2fnxtu4LusgIpZet2N7VbO1PDrSi2x
 QLJo3v4H
 soH2TvgA7DMpqzLW3ZDYzHY9R28Nv4ici0toW79SMH8Slv/jSb5XpYq1fw03sQw6xexwzeQjT/qyx0b8UIrj5TFekerWAXNa80oI1G+Qaz+pvGe2yDIlb4NrjtrDR/mwSmnfbusmMU4r2GFnqkrLlqNgHNCvT0XzHuKsxu5AwmICgaZPOLs5qRssfu6NrdOU62dcxMGYhs8OjgpyWKtHpz4rpBvCsVU8WKQAHrF/Qcf72aFldEZvUrMHcdA7sJ9hEBLEp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 16:08, Kevin Brodsky wrote:
> The kpkeys_hardened_pgtables feature aims to protect all page table
> pages (PTPs) by mapping them with a privileged pkey. This is primarily
> handled by kpkeys_pgtable_alloc(), called from pagetable_alloc().
> However, this does not cover PTPs allocated early, before the
> buddy allocator is available. These PTPs are allocated by architecture
> code, either 1. from static pools or 2. using the memblock allocator,
> and should also be protected.
> 
> This patch addresses the second category: PTPs allocated via memblock.
> Such PTPs are notably used to create the linear map. Protecting them as
> soon as they are allocated would require modifying the linear map while
> it is being created, which seems at best difficult. Instead, a
> simple allocator is introduced, obtaining pages from memblock and
> keeping track of all allocated ranges to set their pkey once it is
> safe to do so. PTPs allocated at that stage are not freed, so there
> is no need to manage a free list.

I'm think of ways to avoid remembering these ranges. I guess we get called that
early that we don't even have a ptdesc where we could just link the pages.

If only page tables would be linked in some datastructure where we could find
them all ... ;)

... why can't we just scan the page table hierarchy to find all page tables that
need protection?

-- 
Cheers,

David

