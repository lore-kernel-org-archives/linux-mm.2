Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A32F589CD
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56616B0005; Thu, 23 Apr 2026 09:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E816B008A; Thu, 23 Apr 2026 09:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44036B008C; Thu, 23 Apr 2026 09:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5DDB6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:05:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CAD587B06
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:05:03 +0000 (UTC)
X-FDA: 84689840886.16.CDF11E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id ABC44C0018
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:05:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HERcRnQJ;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776949501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HfxxOr0aaqSCHTa+SRaJ/ikgjWg3V8ZOReuUxCiJSM=;
	b=cmcMSq8h3sDU7PbjhJJ3RSK/x9gq+4VzTc3UiXUgGqKFYfU/A77kRmH1oqqoN/cNfWk5lN
	LOh/BNzNIy5FXKY0i2kY07ryj2ee9Jz5P1B+zLfO4I+juI4+D3qsBfEzQl4Z+lKpHTJy7o
	wGwDapmKFNx1Bf0IDUaAIriz79t4ukQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776949501; a=rsa-sha256;
	cv=none;
	b=orUhgDqqemf9vPhEPc/LGF3ZhmmvpD5s353l2avznVGR0q4uH6S4+hAaiqK9m0/tt3o0kD
	rQnm47VeTc+wJhOY8Y09pH9Qe20DA2qsLeYRAoEgFPDP//6C4xPBjwB0NZJozW/Yiyg4iy
	Q0HjBACIk3m85FMronSxPSjbxkUAYyk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HERcRnQJ;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B507140785;
	Thu, 23 Apr 2026 13:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7832DC2BCAF;
	Thu, 23 Apr 2026 13:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776949500;
	bh=dFYjmc1IpIkwPQyVq3iWTo4bxWHZ/cGa43crlT3FpFg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HERcRnQJIVyzlX4GI8tM0lL03oWq6Sz2rY4lAo4NLLA6lhiufVUqyR/K6xYb4lWh+
	 KPX2LQsSl1L21PnwjtEVOdkxH5SAJuQkBC9VQNEjqGTffPWOcXNjdxxy1ammKXKoDO
	 HedN1LPRIWc14gfv7Z6FeiLPBSpOdJBaY7T49JRGyvctiEJT9N+GK0JTU7MoK4QHTe
	 qZG/GYKlq0bF4vwmnhkhTIQ/KYfc/F0IRSjLaJlkJNxBerb1GdFWNp00VYaRAkG4iE
	 e1fptp4O3nI+9X1DfuD4bzLTeCHeslxUkd2jID6OK71TkeTB0XAQqjxJi48DnCZ6B7
	 DQqStQvtjhtqg==
Message-ID: <b4e0877c-230b-463f-99b6-c363595e7ac0@kernel.org>
Date: Thu, 23 Apr 2026 15:04:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
References: <2026042334-acutely-unadorned-e05c@gregkh>
 <dee5b7e8-864d-48b5-99cf-282eedaba927@kernel.org>
 <2026042314-traffic-riverbank-d9a1@gregkh>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2026042314-traffic-riverbank-d9a1@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ABC44C0018
X-Rspamd-Server: rspam07
X-Stat-Signature: znrobe99n6qyy4wka4iqsj7xcujzqbbr
X-Rspam-User: 
X-HE-Tag: 1776949501-602870
X-HE-Meta: U2FsdGVkX19cI8ops4NYCxZTxjwzMa2RSoik9qGuXj5ckLxiNfDUXSxbz2x60dv1Ej5zei38Pq7olIKlsIQT3GEu8CZOh/h73FNgMGP1ya9mqga+DzL2inIs8Ic/erVQRC8bpWIujHOUB7LAiJOb2O2gBbGS8LufaThFE2OzI2KMVtUiG0BEdRLTU3rLVC/NQoyNeYlrTXp3/R2D1GDk5vkJiPIQZ7/+bKD6uQI/fJqxlDVglnTFPbwzH55792Svaf8dd/xAx6w+1Jvnid6rsD67bp0jMLGBSlVEr5igtkLv14XbAoiaLOjuUUXLw7r+bVYWMHZh0T3Jmhv+8zEZCqVsOvqAxfE39gRaf6f3fGOeySgMkuXsjzG+4npMXWSj51Prt4MTlRerha+cJ0laLsKlguUvsOmDw5MLV4UrBDAWTcMkXvjr+ctSsy3DqY6TvRCIm2xs4nSemHgZUhv1LSeiyDa43tqAZ1QbmO965PCEgBBuOuHDNRAMmluucolUwGkDXimkDYivLxchXe7rUpPm68v+kGygKYzurHbLcAEMqKBdeO+aaWHEJec5a2ijVVCKgpTdyhfbWancraWebJpy8o9A6/l/2t4OHOR6DyVNFK53qt+bbt+knfe0/bd/0rraksjpvWOccoO9vyBP3248GC+mYIaXZvJLYM+HFwd6DcqAG6RjZSrjp+xG8Coa1Mx+/z5iMi37mf2PkP1oFeErSRy8Tx71Q5aq2Y5YEln1eyLpZAE9iVG3ZIy1SRumg3VaZ2BGUoqzoOrY2iV3jQZ/BVn9niTJF3oeuKnh5HWnocaLGKjJnfB0kEhpZxKHvgJIAPBXzgLN4ue1GQfVD//a/POD1+b43G6qlNyk48G5Yq8JA7oesPqpc/fkFWIg55swcQAkTAI6N4jDDQg4KKaUt0Z5M6g1mdXuSO9BYhYfy11so05Up+cg01XX8tfoVUZkXMHSivpzh7H+w5W
 ZEUYQPvy
 cQzukmoy0rNmNW/cF2Qekan30/F688F3FhafuGvpulVcMBk2fLIlCmsMzasj2fISF608IpaM2BMG9aFrxXNyrWqch13pskl+kK3iqBaPRT8veTJCL1Daodl1QGpZRRPLPCtay4Y8H6JJ5ovFGdh65CcyXXkp9rsVgifyeHhKIH++UACJIdTGXZUS9AnB+JgfWjuvaNb6PA0Mvjla6bO+BNqvgHYC7rQLWjYOqBYVZXnPCEo25O8YcyTzMv4sE3RNpEntKtyYnoHzJwszCPa5ibIsHgKGUwrE/4bT7Mi071EHN8P96WiltWx7biEA5QwUhlq47qx221TqWyrUQjhPKEI38pQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> It just follows what we do everywhere else (e.g., follow_page_pte()).
>>
>>
>>> +				if (try_grab_folio(page_folio(pages[i]), 1,
>>> +						   foll_flags)) {
>>> +					pages[i] = NULL;
>>> +					break;
>>> +				}
>>> +			}
>>
>> If it fails on the first iteration, we return -EFAULT instead of -ENOMEM.
>>
>> I know, I know, nobody cares. But if we touch it, we might just want to return
>> the error we get from try_grab_folio().
> 
> So just abort here and return it?  No, that will not work, there's a
> lock we would jump around.  How about something like this horrid thing,
> adding back in the relevant unlikely() to match the other calls like
> this:
> 
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index ad9ded39609c..8fa5b37be8b7 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
>  	struct vm_area_struct *vma;
>  	bool must_unlock = false;
>  	vm_flags_t vm_flags;
> +	int ret;
>  	long i;
>  
>  	if (!nr_pages)
> @@ -2019,8 +2020,15 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
>  
>  		if (pages) {
>  			pages[i] = virt_to_page((void *)start);
> -			if (pages[i])
> -				get_page(pages[i]);
> +			if (pages[i]) {
> +				ret = try_grab_folio(page_folio(pages[i]), 1,
> +						     foll_flags);
> +				if (unlikely(ret)) {
> +					pages[i] = NULL;
> +					i = ret;
> +					break;

So, we have to report the old i in case of an error.

Assuming we want to also return -EFAULT on !pages[i] -- which i think we want,
maybe the following (uncompiled and untested)?

diff --git a/mm/gup.c b/mm/gup.c
index ad9ded39609c..d00ff8d988fa 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
        struct vm_area_struct *vma;
        bool must_unlock = false;
        vm_flags_t vm_flags;
+       int ret, err = -EFAULT;
        long i;
 
        if (!nr_pages)
@@ -2019,8 +2020,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 
                if (pages) {
                        pages[i] = virt_to_page((void *)start);
-                       if (pages[i])
-                               get_page(pages[i]);
+                       if (!pages[i])
+                               break;
+                       ret = try_grab_folio(page_folio(pages[i]), 1, foll_flags);
+                       if (ret) {
+                               pages[i] = NULL;
+                               err = ret;
+                               break
+                       }
                }
 
                start = (start + PAGE_SIZE) & PAGE_MASK;
@@ -2031,7 +2038,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
                *locked = 0;
        }
 
-       return i ? : -EFAULT;
+       return i ? : err;
 }
 #endif /* !CONFIG_MMU */


-- 
Cheers,

David

