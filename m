Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F176C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53A996B00DA; Wed, 12 Aug 2026 07:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0D16B0178; Wed, 12 Aug 2026 07:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD5E6B0179; Wed, 12 Aug 2026 07:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 107D76B00DA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:50:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 236B3160218
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:50:24 +0000 (UTC)
X-FDA: 85092449568.03.745EBEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 65AAE14000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:50:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B1/yfaby";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786535422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzD8EjbNfwxWOr824IoqhG8JtzqQbE0vxinz7zy2JJg=;
	b=LT4FN1emeUngcfXHVwiWIxnx4t46hMImLcAqsctW8PgYaPoQV538/0yE56HPpEgYRT7ciq
	5fX84GNPYTT4m5GyqzMQJJ52Lbdj5twqxeTE4LuLtQxLmzXqLFQy10doTsy9XI9dbBey3e
	ITjTOQ7rNHBz4h7ciRVL4cnsphYrIb0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B1/yfaby";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786535422;
	b=VF8Vp0NYC9Nc65jquEfco/hlrUR8yabwMZPSVruUmWzlyi0FzfTCkdRexEfZJbt+ctD6m+
	5lyReC33M1WA0LNnnLcdClUFaDzzL5g23ldd6jIG1/lDBSPKPUhSCjTY/X7XQYmq0DSRXc
	R3YEnmxYHnu0mXIk4noFMvUoezCs1Dw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5C1361838;
	Wed, 12 Aug 2026 11:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17A91F00A3E;
	Wed, 12 Aug 2026 11:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786535421;
	bh=NzD8EjbNfwxWOr824IoqhG8JtzqQbE0vxinz7zy2JJg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B1/yfabyBjcixN4UA0vcVlXQ0twNP3kOpUIfZrRJ5Fu2xVyX3ggAcZfXZeCmhYKxl
	 naEE2DNROhkFbIb/vR3yZKYZ/W16PeVLE4tTZ9DdGiTW3YpFbsR7KZipVdPgDgNecq
	 QSGD2TN/HT+6CrE8Y0Kc/vx7WxFRUvAU9VzDReOchwM/BNC7M3JEGS/JwQ2KaJ7DrI
	 z9Dee90kEEgtpIAeqxYMWt8AK6iUNzezWHkbgETqVUvZoDSa6jcY74aG1DSMuyhnxF
	 BjNcg9JXXNIbYxVCflZeR67OdQg3/1g6UqFg6KjrD8AbNK4S9ZzuIey/F5H1vB2SCL
	 a7lhdpe4PNYqw==
Message-ID: <8a9d5a6f-a7c6-468f-8b50-a7aa2b4dea2c@kernel.org>
Date: Wed, 12 Aug 2026 13:50:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 3/8] mm/gup: split follow_page_pte_commit() out of
 follow_page_pte()
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org
References: <20260811025157.1632867-1-riel@surriel.com>
 <20260811025157.1632867-4-riel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811025157.1632867-4-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xmtiow5r83buktwbnr3dqwsajwd469pf
X-Rspamd-Queue-Id: 65AAE14000B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786535422-155359
X-HE-Meta: U2FsdGVkX19maus5gz7Hc78VOnPOJsAZ01iqo0RUorHYU5H2L3o8vEjTF4lsrFGWSqmpg/UF6mqI+kUIz7wSDXAKY0f06CtUTx9P5GKaJ0X56z/XNIcD4kPjdzPkRToLKcTrAxTIwMfosi1SafRHaYhg95ImJhAe3hGMnXzNbGnVhJSlsvEfy2IxShGtsN+gMClw6qpn7EgsSvOPg15rqBN4vFyzULpRRTHAZIlJZ2SZhfstEbem7hSw9VJ8doLu2/H3e/OAIWySurGDl5irEb+7DmE458hQSbmFHtXwzKOS1h0MrdNopcoG3gS5vg8SnuNBknD7B2szA1aal5AgrkbjrNJ4GC0Lg8EJdxJFZic8uVbwJvcu2XliKch6vzyCHK32oi0hle9vo/sE5pVW8urIpxWFe/Ortb1hhdBj9P/CVjndSMR3DAP2eNBHBnZs1T42zDGzZLdCDU9ubN/Lk8WSy3CfA1j50uMoWxr4/6ILr7Xd11HS32lK3Gd0FaPoW8ScPyB5OxwX6YP7kr7UOEWZe4oWN8mC9wyWtMZkdehY51p1OYgfhNh0080RJGfgcIQsTHYHxCAQg390TsqUxb1+hmEYIOCnEObsv2SnnYJLI1FQU4kHvPO8HkpnOS9roBvFcHXSYAape3pMOUt+mXdz//JSw+dbFZy4u43qbLpWZU+786/M2qmsgJeC+d1JWe+j+qEiTHdslfwF56ne1uT/0CpZOPhPyi2S7KKg0bZwdkxdok+7jrot50R6jCQkpbqiYZutW29oMypBpMSySfeM7fV+dfaxEiLp8rcZz9a6x+8VyZvA89VRg/9NlIys2e1nt6vcQv9286Qn2ZRWQvRyXwfepyjn2b0R4yG7IHwLcMN1gPO1GJjJbX5f2JQAHdwHB2Xw/7QepjbJppz22Vq7vyIgl+HxJqHUVFlzfPIqQSu3XM/YIhd4ejop4daAiGxh0odrInWufEeMy3Q
 z9NfGmRX
 PqEz+pzNefwOu7DRQrHvzBH9VNdy3ICXYCJl8f3xeVXCUxMUV2nWdE41ZJusVtb1SXZuUpV7nivxG1sG5P2DY0E8VY/BrKZeBWUKk9DtNm3PsrOaqiluOVi0wwHwlZODzuIGoQQSt/dz36PcBQRSgDn7hWdi8Qy0TcPxSF3is78q7UlVlpuyGNJnR+spxUBQ6u8nX5BWBW5Fyzqdsn+suKjiwAQcmZavwA+oop13OUCL4WpEjXvoDT0ypsOo0onAYL31rFdm5FChTFp2lNRo2USBgZ+nzAUP5UqZH4M+r2q4595Crn3AisNsQpOPVP2iVtMH0t0XIUa9+MLmgOEXw6xt3o9Zr2OFRdHtKi8SHt7EBbMC6+VheWEY1YQ53GNRda9sv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 04:51, Rik van Riel wrote:
> follow_page_pte() does two things once it has resolved a present PTE
> to a page: run the per-PTE safety checks (write-fault, unshare), then
> commit to that page: grab a ref, fault it in if pinning, mark it
> dirty/accessed, and hand it back to the caller.
> 
> Split the second part into its own follow_page_pte_commit(), unchanged
> except for taking its inputs as parameters instead of local variables,
> so the checks and the commit can be applied at different granularities.
> 
> No functional changes intended.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/gup.c | 78 +++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 49 insertions(+), 29 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index e4e6d0993424..b755ceaac0f5 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -822,6 +822,52 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
>  	return !userfaultfd_pte_wp(vma, pte);
>  }
>  
> +/*
> + * The caller has already run every per-PTE safety check (present,
> + * write-fault, gup_must_unshare()) on the PTE, so this only does the
> + * per-folio work: the refcount grab, the FOLL_PIN accessibility fault-in,
> + * dirty/accessed marking, and the array fill with the cache flush.
> + */

If a function needs 4 lines of internal doc to understand what it does, then
maybe it's not the right function name or abstraction. :)

I don't particularly enjoy the "commit" terminology, it looses the detail of the
most important thing this function is supposed to to: grab a folio reference.

We're passing in the pte only to do a single pte_dirty(). If the helper is
actually what we want, likely we just just pass in the pte_dirty() directly and
remove all pte leftovers from the helper.

I'd assume that we'd want a function where we can similarly punch in a PMD/PUD
and have it do the same thing as well, instead of special-casing ptes.

Let me think about this some more, I might have to play with the code myself to
understand how this should all be cleaned up.

-- 
Cheers,

David

