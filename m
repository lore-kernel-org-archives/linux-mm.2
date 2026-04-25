Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A775FF8860
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 16:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75A56B0088; Sat, 25 Apr 2026 12:09:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D0F6B008A; Sat, 25 Apr 2026 12:09:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8AB66B008C; Sat, 25 Apr 2026 12:09:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A679E6B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 12:09:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 425DDC194C
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 16:09:50 +0000 (UTC)
X-FDA: 84697564140.19.B8B1301
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 73EAE40008
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 16:09:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tzPVVKPi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777133388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2Xbr42KweWlmug1UU1TR8tzObfVgePq2EtP7k/7/w8=;
	b=ELnl8m3qOnE+NCWqKGpSoOJaxrw26QPADn/tNxOswxtmDNlNOSkhpgtjGM9JZs3Dzv8+us
	yo0L+0N017Uv0cSS9A6RRZcAOq7zFzMxFE6cVuiz1SAcLTsMvH3o2x3cr1DvyL88kP7GF+
	+RyOmK0ofqGGXD8rBoKvOOAQuLuKhyk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777133388; a=rsa-sha256;
	cv=none;
	b=0aUt9Y/VzoBeO+juZnbwjOCjmwE41VV+h7/rJKnJn5JVUsui3RUmPAEMUaRa8GR85iCfyW
	SHyQ4tk3I0gtxxDB6ZHq0pyARR8IVG0HRK9XJwMXo+8p9Pk40QKY4PIFQ7niZbX62frTOv
	7sulYmghxv3AH7biCYmqVfCfd5LJaCM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tzPVVKPi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C77043F80;
	Sat, 25 Apr 2026 16:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81E6C2BCB0;
	Sat, 25 Apr 2026 16:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777133387;
	bh=B/lgklGe1J5JXKAyck0MPX6Wmp6wz1ndCOue9ot4ns8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tzPVVKPihQ9cAeGJzgRwLIjBHoZIftqV9ajNQhJmX+k02XFjVI5kgwRu8DbVr7QMn
	 J7qIPnY+opMqspKI6iSzRLacFQnXaP/MLfT3tYBBFWGjefvrRFp+bvVN2AcJ6XSjup
	 NOeJCnWOZdKz0JOSS+bQlO5gjgYhAHNn3FtpUY6EFm/RmRlJiA3P10UY43WhMwAQ2x
	 fiOmqIyXgDWVZm+leyJJ/a5MxbkfFftUuPk/i0P2gISGXCL3SL8o4NZX10cKpSNoQu
	 iNsOT06S0XKdPzDyHFoe85HoMkjwetveI1r7TC4Ak41RonQQgqkl/lQX5LG+VBpybP
	 lD8B5e2YkPIIQ==
Date: Sat, 25 Apr 2026 12:09:45 -0400
From: Sasha Levin <sashal@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, akpm@linux-foundation.org,
	corbet@lwn.net, ljs@kernel.org, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	skhan@linuxfoundation.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/7] mm: dual-bitmap page allocator consistency checker
Message-ID: <aeznSeoi1qFAVu3n@laps>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <b001932c-e376-462e-895a-5e4a9c7c0dc5@kernel.org>
 <aeuZcY0u_7PIQb6R@laps>
 <b2a15eea-6ed9-4b35-af68-4586554ad2a3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b2a15eea-6ed9-4b35-af68-4586554ad2a3@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 73EAE40008
X-Rspamd-Server: rspam04
X-Stat-Signature: byr5ewwhr9jx5oo1tfwt34jxttja5zp5
X-HE-Tag: 1777133388-296428
X-HE-Meta: U2FsdGVkX18PW1V1hSv8C1RTfQid2K1b4BAE8q0RqnR4QSa3q+n9HFOJRNRtJep6zLWeCk7UrYhXM0J7ADnW5dLINZMsnSttl5IjXOkl8q0EAl9kf0DeVmZ0DbCXBpNl5pFgVbVnTL0ZVIXM+u/ktd3YHF5aDx07kjHj7ltxrzkxdGiQ+MTEM6k94B+Q09glY4Q7amH1fycS61eemw75jfHIdj+bXoD+PqXf1Nn3iUMTIHIHhO35AWA2cKSCiygfEYcHlsKV8tqD3cxo6TN9Dpi5uHHJSNH+4OkakmA1EiSfB9/NWFkscgD4Icz6SNHKakQ/388e25oa84ppH4lysl8vo3wamx9xtHY5AW1hrgrBJz8x0+4UPrp54csU6n7y7vLTO+X1f3zjvaCdQugTNKxfhbR0CT5o5aBcvIcFkK270YgSnBKYeWgMSYzPaSotMW+gvDPEvJDI2zm5SRTkoB8Yas9RqqIvby8m5ubJo96WmCednIHUMrQ9FpPDdthpr0VHWk8f6dZnndx0EC3nhT9oawaYPtdytL1/s2w25RoLPbfMaast9nsrYp4dsR4YPSwURma2y6lV0zA2IhheDUTAAgo2xCdteOPmflruSE9wSlwqSB3Gygb1tSav9GIyLiqojKhZVTiRPGojyhfbz5FkdAg6yLjCNgCmBHq4ii0o2kUd5HwbpbRW0d6hSoPM3MYlXgHdhdnZBjjnJ2anKH55EbIe6UuT5ObFXn2hH3m/mhT5xvEgIHi3svMu/IJhHC5Kow9ecrMu2le0pRFm5i1H3GDHc1kRFhRKg4wmbx0ua421dJ0af/zzKnr7SNsgZg9xJjgGBd4SQ677E+50LUQ0WaBjf0HB9EwqKPqwIMQAjCU7vkWclVuULkwmbqNlhaXhpc4uYFnNOX1IIgNMYQu6d+JG1sQxVtnnrFktwdSkGfx/CGy+zJGGWtgnM5GTvABcuWUnzl3rHU/bEdw
 4VtTSwxo
 HJTQaFWMe++YuH2Iy73WFxoBqNby1v5VnSnNMrJ2oCbk6kD/T9iLe9g0JbuWfEZwK08vehkfhnRDW3/y3+Z/mqiI+R1UnE47CaCE97Gsk4KbMQJrGTo60ImgV8JH6gkM4fY4I+1OzoQ6kK8bcLgWnH8m8L3HF1jMeTTR/3hJsLPPLNRtiWiesHLrgmmWznzjvcEW/PctMNUMMg2wzAYKKRKlqEFKyODY8EhOwWyLaudLj97A3/sZuTz/YltnJujbmkTsD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 07:51:10AM +0200, David Hildenbrand (Arm) wrote:
>On 4/24/26 18:25, Sasha Levin wrote:
>> On Fri, Apr 24, 2026 at 05:42:53PM +0200, Vlastimil Babka (SUSE) wrote:
>>> On 4/24/26 16:00, Sasha Levin wrote:
>>>> Existing memory debugging tools - KASAN, KFENCE, page_poisoning - detect
>>>> access violations and content corruption, but none of them can detect
>>>> silent corruption in the page allocator's own metadata. If a hardware
>>>> bit flip corrupts an allocation bitmap, the allocator hands out a page
>>>
>>> An allocation what? The page allocator is a buddy allocator, it has no
>>> bitmap to track free/allocated state of pages?
>>
>> You're right, the cover letter is misleading there. Buddy doesn't use a bitmap:
>> PageBuddy lives in page_type, the free list is a list, and page->private holds
>> the order. The dual-bitmap is new metadata the feature adds, maintained from
>> the alloc/free hooks.
>
>Given that you have PageBuddy (first "bit"), could we use a second bit in page_ext?

Hmm... Thats an interesting idea.

I can see two concerns with something like this:

1. The checker has to be live before memblock_free_all() hands pages to buddy.
page_ext isn't fully up that early I think.

2. page_type encodes buddy, offline, slab tags, etc... and a page that isn't
PageBuddy isn't necessarily allocated through alloc_pages. The invariant gets
case-y.

But let me think about it a bit more.

-- 
Thanks,
Sasha

