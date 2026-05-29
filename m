Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8BE5CD6E51
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 11:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8886B0005; Fri, 29 May 2026 07:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99586B0088; Fri, 29 May 2026 07:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A056B008A; Fri, 29 May 2026 07:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A40F26B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:48:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CA0F9D4A3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:48:30 +0000 (UTC)
X-FDA: 84820284780.02.C79FAC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3D8B82000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:48:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JRO772ou;
	spf=pass (imf31.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780055308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIeVd/WX/TWHB/VJyICGafCV81ZvEMJIfeKTRzi4YyU=;
	b=mrIOmA5AUfq8L67gHe1Tbmdwu/NZ7aqMN3M7icCfelV5TeXlb+v2iZkd9myD9PmLrc7Q1k
	RDgXCThAkHym3YILvkLV1rDxtp2w242+rHLYw18msSpDbjOl6NKjCC8RUq6f/QHVEqd4ZX
	PS+rFOKVXGbSA87fey/5FUeXIhT2k5s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JRO772ou;
	spf=pass (imf31.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780055308; a=rsa-sha256;
	cv=none;
	b=UoRC90FfDgArfBb0+I4dyx0uSs7aScr11aa3ON9a0DwCqfmwGBr1VheJeKEuC4ix0+MWcr
	T3/MaBqFRgizWUI8lHpgZG1VPlzte/liekDCsMeKsaqYeCgjap0ULGX1flClKw/t+4vD5y
	x5qNeh7RAQvrowliab6GS2GZxIkiTOA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC79D4066C;
	Fri, 29 May 2026 11:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEED1F00898;
	Fri, 29 May 2026 11:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780055306;
	bh=sIeVd/WX/TWHB/VJyICGafCV81ZvEMJIfeKTRzi4YyU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=JRO772ouOdhT+jOQJ0OTbNHxgdzgvxi473owGgUo4TE57zUhwukVR0+C+fpHEsL92
	 fUVrUiHHHckcGymqGSKgE4CWyPhCY2v/Gt0NycMsYvqVnYk4x5muiJhKJVFCtDgKJP
	 qPhb2qvrQcWq0x8XmZeLnojxrZQZgrkS61hCbjqhs5GJq3CnheRLlZ7PGBXI9vBwxP
	 NN7nD+As59I/v/CjdM5jvCr8K65cs7ezJ5VLQ7Bx1MfdpM9sXLjmhDvAOo6Y7lhGT3
	 fzgx4us/z4Z+CnkRRgLRDpzwYHCeBByicEWc9iDnSb9ih93N8eYpiCPeaFNLE+JULK
	 boLKl1E8SsPGA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5C985F40068;
	Fri, 29 May 2026 07:48:25 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Fri, 29 May 2026 07:48:25 -0400
X-ME-Sender: <xms:CX0ZagN3aQtnP5COtTHB95DuxR1C1PNBgVxGl18aCXuND6jeeqckiw>
    <xme:CX0ZahwyJ8letx_9aBqmekV7icYDJoKqohBqLWMpvVtp53-keo9G82lVoEKGv84Jt
    eNVudLoKHRxrjpE44-4QHGCJ-S6Pu72-sY9DE1-y8ECJMmJYgW79qU>
X-ME-Proxy-Cause: dmFkZTEZo0PmK4mVB+fFM0IN1SyU0XoyCS4JtFVZ5bJycosU9Xxdllrud3l8Di6ocFbe5N
    HEklJ59M+C805Cm4eym0UqzqtnTUFRvNdnKZ8X1TMfo6I03dE5uih4Vqp1hkE80h74zsWF
    2ltZ/T3xvnpSusp3LJ0hMNAUQlyq1C1oIbvywWhQHwhCzEZui5yARzH7uSNzEqRwl3CkfL
    81udAFrbb1pHb25iUo9sopmerAdCubWvBJgnRkMS1JcOjioNciLlaIqOX/MIH7t9grkDqv
    VCqC6913tLnFO5KvwlaytX17z6eAcG7QjcGkp2vjNsx3WSh27qiy35mJdl+ogoOHiiNlAx
    RTD/Zl+pGjPdayDQvssU9/4Pn2g9XOvFTKlf9A7BBg2RlDplKNj91dg6kC06Sk4CaHnXue
    tdK3k5SQs4G1GyPAXF210G5E7yRaZeS3rkj6JQ5+fZln4NVAW9ii6cpmuibsM9izO10mSp
    TRB/s+D+ZTUllXeG4AIvlwB+S7HNLNNKI9mcLAr+Me0DQ0I/F1uHG47+V8nGVI4e9wwSfW
    TLbZPErXQ4GTogQTz51PhpGN3fNwBATIOK3i5dos6l0JxJXNG7JAuf9rdDwAnNezvRbJr/
    lxxwjSL+5t9OJkSnrY0pM2yq/TpsykeyFonsIGIwNyMsOqLLbuQLGhikVh0A
X-ME-Proxy: <xmx:CX0Zap16tX7A2oLaMjBjQAzRHEsI65FLz7uHu4CX9VagJUHaDTOx8g>
    <xmx:CX0ZanLZhe5zBc8zPzIUwmo0FHz66Gw4nyjgOOIQhcZxrhMm7lAbmw>
    <xmx:CX0ZahkjPCu6whROyp9OvLCnjBPsNyVZnm_q_TY9yheAvvfpMJu_pA>
    <xmx:CX0ZatMbPkNztnNyEwLga96pIQj92RQmP17RQF58EO8XjM79j38WDg>
    <xmx:CX0Zaox4r43qBEISSLnS04jJIkSlhY96ahChUyzXn09Ys7cTJ2_N2bfv>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 3991F182007A; Fri, 29 May 2026 07:48:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Fri, 29 May 2026 13:48:04 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
Message-Id: <c96591f0-fcf9-43c9-8e45-4a688b3aa116@app.fastmail.com>
In-Reply-To: <32458c49-0e3c-4d27-b1cf-0e2d7ee0273d@arm.com>
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-32-ardb+git@google.com>
 <22042b98-cfcc-428e-bb08-ebcfe785eb69@arm.com>
 <8082b77d-6522-472a-9030-317087ecd7e9@app.fastmail.com>
 <32458c49-0e3c-4d27-b1cf-0e2d7ee0273d@arm.com>
Subject: Re: [PATCH v6 15/15] arm64: mm: Unmap kernel data/bss entirely from the linear
 map
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3D8B82000C
X-Stat-Signature: z7s3uymsk84desatjf5apmqdhdzdyeq3
X-HE-Tag: 1780055308-429375
X-HE-Meta: U2FsdGVkX18BpON7Fbdc74GmDBDMRO8hSlh+lWwbpJtfe1tJYoSL3ixzOzc7P/ARjyzEMWMJqfAcnyVquliPFza3nvqe6svKfIyaGiPsqQ65JeJwLURPiPga/D1B669NkgLdmLsdhYJdvmSFJx/Jbhoh1ekG5wn238UEKSPa4bcTjphy1wx4ibXOu+CRGGRY+ar5KX+CXRqTK2dpNefQ6iq7FPjGf+A8n2fbkqimV35/Fu39hXBrUmDlIK7ovbmW24jdc0j1JYP75ghDMA4zfifpxDCPz9zt2sCb5KetEW3sSApNk9ccUjgP41b7dHA/KvsjjjzQWgUBhIXHTPcDLHEXIcGVdE3j0AtqRrbuicv4CXu5JOaCo9Rrua3DJTRF0RanqK1zdypwaNrAIOaL6Z0FpGo36+NKeaduhrLNpAO/2T7jDht3w9HD2mE9yJCYFbkinCwQIBDP62OFuQHkjxhuxw0fTE2gGOdejeErhLJt/qjqes0n0qL0yLtJdTKBfg1w0IRdlp1R/3k+Z1VMAguxe0j/Gaf22scix7B7apwDcgYnd3mDltlO6WHp6lMnQOB+SNtTeLKif2mtA9StRrCuxPD9ugZ0qqIXF/+45KhuE2jQShxKF2GUzRJkssXoIDTlVIKcgq8zr2kyxOUoMsFl+fvSKq6izr+4fO59vVwVd+Vwm/h8NBwIYTcc4t/ZbIHsxHfeASm3RbHdKAX8xuUG/bKiLsTt21q3jL9K7rlOHau5pAluRvJZZ1udVPvJKxTnHUsuKSxoecFS02+eWkWc6wpnvetsd2MR0k4XSEASjTypJQigKOUdTBXmPSwDqjBZebnBeS9uBlCc/jw52+MbxdnhCardLvp4J54OEcllc98oeo0I/oWv/OIHVmlLzeTnQ44+hdqKUZyOz0izvTx8EGYPdoSo7wM/xFOXpuk2efYq9I6fITfrxesuBmKU0MTXnPVFsa7pMQ3UmPA
 tzpmErxc
 6mwpvDokCMiIlPiCZu6IFHD9SKrQQo4iuVOnsr12IP/PKzDGXK2uOuATSQPiMZ3HLn4QVy9tkPuNC6nJGI7eccpQzIrQPWqGjeCESHvcLzHKy/1AI151cEaIL/Xxy1+fMe85ruwF0N7DMVc85mFo4mV92DVUbL1hu1Hjt0RSSQ1INz5x27nMRPbTlgghmK//oDfKh7HquMFyH7DPJfD1PyX/fPeLBnLFg5+SWkaL2pvpghyOThRlhLGu8qSWjBwoxjsCsZvH4F5L0B3EKnbXet3QdAiMkYuJeKFZYoQCFhytke6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 29 May 2026, at 10:49, Kevin Brodsky wrote:
> On 29/05/2026 10:34, Ard Biesheuvel wrote:
>> On Fri, 29 May 2026, at 10:29, Kevin Brodsky wrote:
>>> On 26/05/2026 19:59, Ard Biesheuvel wrote:
>>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>>
>>>> The linear aliases of the kernel text and rodata are mapped read-only in
>>>> the linear map as well. Given that the contents of these regions are
>>>> mostly identical to the version in the loadable image, mapping them
>>>> read-only and leaving their contents visible is a reasonable hardening
>>>> measure.
>>>>
>>>> Data and bss, however, are now also mapped read-only but the contents of
>>>> these regions are more likely to contain data that we'd rather not leak.
>>>> So let's unmap these entirely in the linear map when the kernel is
>>>> running normally.
>>>>
>>>> When going into hibernation or waking up from it, these regions need to
>>>> be mapped, so map the region initially, and toggle the valid bit so
>>>> map/unmap the region as needed. (While the hibernation snapshot logic
>>>> seems able to map inaccessible pages as needed, it currently disregards
>>>> non-present pages entirely.)
>>> I'm not sure I understand this, is there something wrong with the
>>> kernel_page_present() check in safe_copy_page()?
>>>
>> No. If the hibernate code decides to snapshot a page and it is not mapped,
>> safe_copy_page() will do the right thing and map it on demand.
>>
>> The problem is that pages belonging to the kernel image are marked as
>> PageReserved, and so the hibernation logic will not even consider the
>> pages for snapshotting if they are not mapped.
>
> Right I see the check in saveable_page() now. Maybe it would be worth
> spelling it out in the commit message (hibernation logic ignores
> non-present Reserved pages).
>

Yeah it's there but clearly not spelled out sufficiently :-)


