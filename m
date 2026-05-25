Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12CB8CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 10:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E60E6B008A; Mon, 25 May 2026 06:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BDC06B008C; Mon, 25 May 2026 06:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3F46B0093; Mon, 25 May 2026 06:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29F196B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:48:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6EB118CFDE
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:48:28 +0000 (UTC)
X-FDA: 84805618296.11.37917C9
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf29.hostedemail.com (Postfix) with ESMTP id ACAB4120002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:48:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=PqvCCD3G;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf29.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779706106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sf5JLvSdJ6UBrNThmSSBvjbZUjNH9XNbGicNZw7870Y=;
	b=5vh3QO5r7E2TeCqsOax7hvWfC7vDMobfMl3/NgzgP2ezeP4QY5yK7Dx00tRwdV0oB8b17H
	ZMiCIihjrJ0v5YWgfFeoKKI1ill52SxIl7EnnqD3cv+eI6EY+7YCq7LwYgMjIwep/559UP
	RGNVKbkKbTp/77ltX+Aao19F0Mfp+7Y=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=PqvCCD3G;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf29.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779706106; a=rsa-sha256;
	cv=pass;
	b=kRsJ6D3Hdz6YrkOgK3sxon8GXxd/U+Bv/rttMOADQ08Wxc7tW3VLQmfAf2lCFCdUMKZLj2
	vNSNVJqssitUHd+4/tj1uY4sUn4Oh8j+VIQlMe/WropQMgr7Mxmh2O33BeEg0A4Hy1Zdwb
	khsSm71d4LthOES9g8wRnlUmYjkJ34c=
ARC-Seal: i=1; a=rsa-sha256; t=1779706081; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=BHTt+tMCffU34CoI1EgQyAKhvkzIuVWtLCcg13JVCEZbeSm4H5z2K/gDw1Aej2QwERcdi+6RURswHZlSyvt39Fchox2x22VvQn8p/6RCnLTEM2mY1n9AV3dJ/KaaWGUTSX34WPqTQpFVeU6aMgU/nSTvvajTpKl7Q6tyUmmbozg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1779706081; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=sf5JLvSdJ6UBrNThmSSBvjbZUjNH9XNbGicNZw7870Y=; 
	b=f3sfoQ4Z0xct6tmc4EbKJKzqYE13WbwLG8WZ37IU2R218w5EXXW6PI5BNSMa4lw6ijKVj7IxLmj+F9bIbcFOeJT52DDlXCiN7+yRkufxduI38TYj9OD+QU0FQqHukimGbQ7X2hZj2ugNXzx1bSPZ+s4GxkmLkgjy6lbcxV02bBM=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779706081;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=sf5JLvSdJ6UBrNThmSSBvjbZUjNH9XNbGicNZw7870Y=;
	b=PqvCCD3G1uVPJP3vyAiuXSSLHwAgDS9dZr79zbm2udINa4szvzsEW+qk42f1NR+S
	ek96Jz5+xTD2ekMhrwPaeyN9Cagzh8Cn48G5gR2PAXBBsvMmHq5Ii28fGL0zX1QpBB/
	wgYgL2oYk0S3JM7N2XSVPw34ua1xyWiJqMXEUat4=
Received: by mx.zoho.in with SMTPS id 1779706078270405.4730790262835;
	Mon, 25 May 2026 16:17:58 +0530 (IST)
Message-ID: <aff47da5-4fd5-481d-be18-e1eb99639490@zohomail.in>
Date: Mon, 25 May 2026 16:17:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 0/5] mm/vmalloc: free unused pages on vrealloc()
 shrink
From: Shivam Kalra <shivamkalra98@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
 <20260519110743.50a2ccd2489a05be6e056703@linux-foundation.org>
 <2462e6ab-3679-42c2-b553-afa44342b479@zohomail.in>
Content-Language: en-US
In-Reply-To: <2462e6ab-3679-42c2-b553-afa44342b479@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Stat-Signature: kf6gfr8mcottqfkxc5wm5gfrc44s633h
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ACAB4120002
X-HE-Tag: 1779706105-785505
X-HE-Meta: U2FsdGVkX1985EKVxOqQzVjcaiTX4+12lB0JmLE5M8Nb7kkAFsghXxizvAhQQj3ya61exneJAEawE5EzlUbQ+Hi7n3udhJEFtdE+UEPRfdqoWeMIC36izFcsxGZOcmA0NgFV10rqILyR/MymzFtNhusdzCdJtvtpWOcaT/sOVvwS/w24SVnDF0+Ipz6Xs+N9r17aE5NfihQV9Nl5OM4ddnP5GcxhG1g7CKH7hhEtVlgQf+eRe1sEF9zQiAJ+lFoT4ayU5crTCjbnCiwxDHf3Sh6J9Me3oFPc3Qq0C2+AYdqlzE4Hu67TE7z7gwpoC/6Q6IaoIJV0RRSXAok8JIeivN72x+Rfmmqx0x685NHPPj5ZnJr/+Hxx5HvvYKNH2GsqwdFZSxm8NmY85A1iFWGxefdDtQzo1Xml8YQg4DWA9OhLSwPP4KAU6uo9u7CP4TGTTgeFt1ygqTHBxefE8EpqlNvygdaA2tnD0jC13HR2abim8FgVbVYwvKUX6IncT2F/jn2owPxUM8XGTRy3Mq1MPlTQbQcZTuhHFsBeiwwBsZ6LqgL38eqR6XAqirQdAI+5LWR97ey2joO2RXiHbvAYSZUbcT5uySSnpkKSb7MWe3thhX3LdxHtpTJ7hO/SCTfhq986Cv3IGjcrRAcqv8MPdxNxlkOB311Sf3LLsTjJRy4m3Y/XE7AFbP5jS9QUXAw9Hn/pbF6qp4XgCX7lHgmh9PrH2WLoWHb+UbgXkyiTRqJlXSKpLhPy1Xri+BfFXJA8vVKpOWeXdrlmRlm9QWn/cFynAKmNghNavPFLTck4edk3yVdwqJxXVDffTtHVB9m3yaWLfNX4P/dhA3riqe5dgMCH2YdZGBxFZP/j6izw3UCTgFoTywXzfESVb9qa7sYx7y+ftOl5IXK3ldsWfNNcDcGAZ27I270TLG2Fut6YK4t5+kgE93MvGaDd6K6JNcgb2uIk1MGAsgyl6lRaZs4
 H5cBY7WP
 U+evVWrr6pwXRqrPqUL5DGfYxS0PuaZDlb5ahvqwJuukKyGdkFxUTfHznT4C5c5HcEnATlKSDCneBC+cGP7uNMNH687OjzZxp6tBe2kuGUVqx+pb/ID6VZ+BsfvCF4Xx40ovR9GoicygcbDlrA6kHaxXZM//OwOMbUz8GWl0UBRGr0JIlBbracO2K04CgYgWe/pdpQ9Iiq2GLUAVQIWZNcOQyj6iJNAdS1BRzE8QRfoVASBLkT7+JqXUxA2HmVx3Lmqg3ABDJu21L71ezm96WajDVRf3cTkI0iDjuaKQZReicQGMgsR5W1F5GkMCMugOjWYN78E7IxuAW6aPWZoG6MlJH9odFhF/jPD04aNKubT0HWtflDYuDQ+3hgE0UbOFWvVN1kkI1tQIRVdzaB8dxlFrqQll3capCkCKJWlFK0Xw7Xe6GStXjz+5ZoLkuxOMNH7Ne9yECWb8vfA1/IngfEJNhXufKhMD4JapEOfUkj6G5cL5arQhzBOBHUDOFTpSBW6Gcxtk2Om4lwBZYoI9ZiuKrjcuOF/dxNhFeed9ZI7iuRYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/05/26 03:01, Shivam Kalra wrote:
> On 19/05/26 23:37, Andrew Morton wrote:
>> On Tue, 19 May 2026 17:42:13 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:
>>
>>> This series implements the TODO in vrealloc() to unmap and free unused
>>> pages when shrinking across a page boundary.
>>
>> Thanks, I'll add this to mm.git's mm-new branch for testing.  A few
>> days hence I'll hopefully move it into the mm-unstable branch for
>> linux-next exposure.
>>
>> Sashiko is still saying things.  Please double-check that it's all been
>> dealt with and there's nothing new in there?
>>
>> 	https://sashiko.dev/#/patchset/20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in
> I've reviewed all five Sashiko findings:
> 
> - Issues 1+2 (32-bit shift overflow in nr_pages << PAGE_SHIFT):
>   nr_pages is unsigned int; a pre-existing type choice in struct
>   vm_struct. Uladzislau reviewed this and explicitly asked to
>   drop the (size_t) cast in v11.
> 
> - Issue 3 (VM_ALLOC areas with nr_pages==0): Valid point.
>   pcpu_get_vm_areas() creates VM_ALLOC areas but manages pages through
>   its own path and never sets nr_pages. With patch 3, vread_iter would
>   skip these areas instead of reading them; a minor /proc/kcore
>   observability regression. I'll send a follow-up fix to fall back to
>   get_vm_area_size() when nr_pages is 0.
> 
> - Issue 4 (kmemleak scanner race): __delete_object() clears
>   OBJECT_ALLOCATED under object->lock, and
>   scan_object() re-checks that flag under the same lock after
>   cond_resched(). Additionally, kmemleak_free_part()
>   is called before vunmap_range(), so pages are still mapped during
>   any scan window.
> 
> - Issue 5 (__GFP_ZERO on grow-after-shrink): Not a regression per
>   Sashiko's own assessment. The API doc already requires callers to
>   consistently pass __GFP_ZERO for every call.
> 

Andrew, could you please fold this into
"mm/vmalloc: use physical page count in vread_iter() for VM_ALLOC areas"?

pcpu_get_vm_areas() creates VM_ALLOC areas without setting nr_pages.
Add an nr_pages check to fall back to get_vm_area_size() for these
areas.

-			size = (vm->flags & VM_ALLOC) ?
+			size = (vm->flags & VM_ALLOC && vm->nr_pages) ?


