Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2682ACD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE586B0005; Thu, 28 May 2026 04:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE1A6B0093; Thu, 28 May 2026 04:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4767C6B0096; Thu, 28 May 2026 04:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 380226B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:16:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 057E4161E30
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:16:01 +0000 (UTC)
X-FDA: 84816120522.07.2094B45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 548BE40009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:15:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aSlrDZfb;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779956159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYivG+khnFG9l2jgbn4uQMtFgxumzEgDULtiQJb8tf8=;
	b=0dbYoqo2C2t5sqTp8vTrglSmIUkxVMvxK1o/90O+UrnZeZrOeWW4r6woN71noqH6/MOOrB
	Bh6RRbedfj79snM+tBs+mle/nizGdSud9hQHHpvWiV1Re63mwr4ZyyQDRQa5nRVd4p8kKY
	E7pUEmcIoMKMWf2uVu9Ro2lkfdmVwy4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aSlrDZfb;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779956159; a=rsa-sha256;
	cv=none;
	b=6Sq9rW+udy6KB7gOgexDdTSqN8gAgoE+XnlgTSIRv3eVljubUyN+WQOtMCgfuV50CvZ858
	v2gCETF+FEPr1pciUNYXkcLZU1HhNIFLazXXKPumK1VLA9NkOVioVB1oxjPP081jBN6e0f
	FP5bgtXVq+DXgt/N7dfD7HsdMQPjVBY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63F5440897;
	Thu, 28 May 2026 08:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B7A1F00A3A;
	Thu, 28 May 2026 08:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779956158;
	bh=rYivG+khnFG9l2jgbn4uQMtFgxumzEgDULtiQJb8tf8=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=aSlrDZfb/5RsiSrR8rmCTTypOOOKFVgi9zYKSlF3sd4mgApK9155eC+hyaurxtkfI
	 ruaWl73zB/O9mV3KdPmWUXwN6mLqeg+gky6zhChycDMWgVy7NsSFdesVY1NCV8yIeG
	 91bBe9LEqG1fgxU2uNTnyd2RntEr3klMjimGrw/nhroQ3CnGqlV4+RBtW+8uNihRwH
	 4rBRzbbIyfIlS7yYx98cpHuZyK8YSY8fOoP9Sf1SBFcWTUWgkNuPvrJM1nlvlTOPQu
	 pDd2XGZAVKM3AXDIyor9vr61JDAhikEdDnrxrOpIteMevFHP+i/pKqnVPjp8pRkHZ7
	 h0tKdLaXs4YnQ==
Message-ID: <98aadcdf-6062-4aea-9b33-e64b4b613618@kernel.org>
Date: Thu, 28 May 2026 17:15:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Harry Yoo <harry@kernel.org>
Subject: Re: [PATCH v3 1/2] mm, slab: add an optimistic
 __slab_try_return_freelist()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hu.shengming@zte.com.cn,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
References: <20260522-b4-refill-optimistic-return-v3-0-2ba78ec1c6ed@kernel.org>
 <20260522-b4-refill-optimistic-return-v3-1-2ba78ec1c6ed@kernel.org>
Content-Language: en-US
In-Reply-To: <20260522-b4-refill-optimistic-return-v3-1-2ba78ec1c6ed@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nbdsirnnub11aunykn8tke5ykk6jbfwq
X-Rspamd-Queue-Id: 548BE40009
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779956159-593993
X-HE-Meta: U2FsdGVkX18ZhBEVivZO7XqbVG/AM4DkGObOB5lQhQen0FXoEHgEfFVGxQMufhmDhZLBjTelRzyPB32h80B//Z1ljWEaxXKccgtpSyGvIvp34MaM64vvwT6fXUwycdRLTRLadfsJLn4BdxVGcebcs0h18EWMnOyB61w707v2rKly/ViUkzWN2Xpor3xeK6V1C+2Pb3FSxcOGxWKfocpi1FPlGnPv5lZoBky7zW0X5SgLkrNyhdnDhzXslYKRGCnEqYFUw4HaFW9wd8MUQKPDMZOn3LrCv0WChIJfG7Sl96xij44pqT0RlhTBMzI7G/6BTD1vdOYMiXO3IA7nVk/p+r9ZhGmORWe0frEXvGL8SoyBNJXrKkPkRfuRyDKBHZAwGy+0ODocU+dLaY2bKeakTlu42tntwuTFh4/wVpB1EjggAQ6sd/iRRcUSMVy0GX/a85MtJWKnxEtLc/TwlUiapyqgA/okVUxTegsGxj0X3zforWBC5Glo+A6f1uqFeKcIn9RVYgiWwQzeC+nN0C/6QfOt6+OK5x2NQ1/7jw7x7MqwM4rmrstC0Ho8M82VmyBroWRTMdDe7I3CmibSykfq5P7Z0RoCXwbAai4vbuSJXgukEuraWRQ4Yk7xwqVAKQrBWlAd0WqTUXMwo5zICayOtwrrSmkU33QWMKvslMxvWllHkd9zEJpqLBLojWABmX3FFvIpkB0Cg0YMfJIdmWEJ5RDFE9tPC4sYLdweOpaBh2b0iiUyuddz3X8peKJ4OknzPwKUbRhOnyLR0n0WEHkYBluu32bNE9khUIN3FM44QI2GWGIetTGRWq4wQ2JYM5pPI4fd671gs6CGDRF+84CBnKw1Hl4V+1pRG8Fma53t/yAwntEZfBasqeVhFESVC9nikxDzsXeC3PoOeTmJyl4AoRCc1bUfInXiqNBqVfshFnJPDVeKQsS2YMun4N46o1vVI9Ey99xMtZ973ePP6li
 AZHjaAKl
 UnFEamkxgg8k4IuEzQueR+4sOEXsryfOWAadN9cMZ+nG0/hw52Y/o4/v4RoA4hqp5B0eRifILHoY8KehrvwTO6ICmo3nfAe3nod0gjDi3FXNMQMgl6kcMEXkstG4c1nzssw6RVTjGAD5ium/guPstB0ETrDWZmJIJ9vxHe8rzQV6PKGJRQclS3jXzEKyckso3IkbJMJQawTplGfV9X7p/nDagDuiemnDUnpU4jsxoN8ZCmeliSDW/NQpbMZpD3dH81pcGLArjP3tfPUSVl5Kz9uPQvsFOTi+7Ag/iHJZdcd7rMgyil689SK04KYRvBcqvdUhbp9P2kMIlL0x4a9gwlQy1i+wobJeCL+7B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/22/26 11:23 PM, Vlastimil Babka (SUSE) wrote:
> When we end up returning extraneous objects during refill to a slab
> where we just did a get_freelist_nofreeze(), it is likely no other CPU
> has freed objects to it meanwhile. We can then reattach the remainder of
> the freelist without having to walk the (potentially cache cold)
> freelist for finding its tail to connect slab->freelist to it.
>
> Add a __slab_try_return_freelist() function that does that. As suggested
> by Hao Li, it doesn't need to also return the slab to the partial list,
> because there's code in __refill_objects_node() that already does that
> for any slabs where we don't detach the freelist in the first place. So
> we just put the slab back to the pc.slabs list. It's no longer likely
> that the list will be empty now, so remove the unlikely() annotation.
>
> However, also change that code to add to the tail of the partial list
> instead of head to match what __slab_free() did and avoid a regression,
> that was reported for the earlier version by the kernel test robot [1].
> This change will also affect slabs which were grabbed from the partial
> list and not refilled from even partially, but those should be much more
> rare than a partial refill.
>
> [1]https://lore.kernel.org/all/202605112204.9382cecf-lkp@intel.com/
>
> Reviewed-by: Hao Li<hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka (SUSE)<vbabka@kernel.org>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon


