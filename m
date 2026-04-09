Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBEC4EA3C59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 11:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DE966B0005; Thu,  9 Apr 2026 07:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B63C6B0088; Thu,  9 Apr 2026 07:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4226B008A; Thu,  9 Apr 2026 07:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 243B46B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:59:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEBC08B383
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:59:56 +0000 (UTC)
X-FDA: 84638873592.30.207D38B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2DFA21C0008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:59:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hxtT42Qa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775735995; a=rsa-sha256;
	cv=none;
	b=xX0RpfT04ctVCEVrfpWowBjgCEx14VoJvqwn+0JfOf02PdS3psdSejEq3jnDyi6vzaKCqy
	PY0nJiuf/VihboWYkc62YekPfEjkd9C9B1R+nXb7H87uWvMG+rD+UPpRviId4x9GyQETM+
	TfzwsCkQgh+zinVd6G9EFHhRZNmMaKs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hxtT42Qa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775735995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3LKkEZToh4D38gUMLJfH9iQU9PqkNIiTKUKC79efwQ=;
	b=6O8SR3OdwTVDi5CNuzVrKCD79TQDOF0KjhsgiK311BJaeCV1GKy+0VCw2/CCM1gDESaXMG
	FFM9TCfC/pqL8Jz9E3KHLXCi5QcfXhDOCzt6Jv/W99ZX77qzt8UIIUbaB3QYhEN2n6fsNY
	1Iij/3i6EXaWL8WHhl/JbHNuggdyjBo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92276600CB;
	Thu,  9 Apr 2026 11:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FB7C4CEF7;
	Thu,  9 Apr 2026 11:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775735994;
	bh=fTTkHCuIQCSNmktK8innsRZQWyUUgjZd5seY4VpXbVs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hxtT42Qap/OR/BZVQ+kWHjpYdObAqawVX0mN7pc9AcALNJrZE+K3aWaYr66kRnIxU
	 37WwL+D03qGWB9DT560Dp7NY1KFxReTS0HqSikgfwznJw7Na5bPCAyfoe64hSlUn7A
	 AZHGEXNfgaIc8hcAJd1r6xKapcDvKvvTNxtievbA2pJDCW/oFY19WJZgHDU/W0FefJ
	 YJ8CZouOi19PQTG15tNlFuKLmmnxQaSJrdBO18qYyk4ranEpCDBiXfPxXi6VC6WpZX
	 nUZC6jj2Ao3gplEPqeXdFmP5JNLqfdo4UJ7/fHdU4kcAE7ivyL29n7X0FYqCy4zEK9
	 x37mITIQrDj7Q==
Message-ID: <d473917c-468b-46d0-adfd-b8a1d075f8b2@kernel.org>
Date: Thu, 9 Apr 2026 13:59:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIIHYzIDIvMl0ga3NtOiBPcHRpbWl6ZSBy?=
 =?UTF-8?Q?map=5Fwalk=5Fksm_by_passing_a_suitable_address_range?=
To: xu.xin16@zte.com.cn, shr@devkernel.io, ljs@kernel.org
Cc: hughd@google.com, akpm@linux-foundation.org, chengming.zhou@linux.dev,
 wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, michel@lespinasse.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260409185610930gKQqJsFs5KoTU4S8MrflI@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260409185610930gKQqJsFs5KoTU4S8MrflI@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nkctwa1gsec7m91caousdc64nbhrkrgc
X-Rspamd-Queue-Id: 2DFA21C0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775735995-699087
X-HE-Meta: U2FsdGVkX1/mPfBrJiSe/yAVGEOPxAy4GAaZA7xr3AaizuzJvcC7Z+uBRJBPWrkg7luOcITkbCtfN1WfGw7t+u2ndYCKntwHOv3QTAbpwAtlTuscYKhnUa1jxV5bDLIOUy/0n/Oc8Uefk6r7GRLqI8VInVCaoxVYMwq7l3k9KFPBAOLZ3hJ6Vk770gcdagO7V4CDgM0WbZjIz7VcuPZTba5pJUvPSSFyoAzXFtqoGzkUcf8ZDphOoLASvrzrJwo+PMWjVqqdNDw3Cvrul0jUo4QgEVG3OC5yQkYTxF5juOAF8uasSCnlbnRFRtIwsKm8DAzh67H9wmXpoBLvgoFRDlRpcqH/BvRy/QtFA6ph0GrN05BuPuUIYkSzLan9Cp2qxoiNE27VCF2XjWaUAXKeiqnq/1Tx0NCTPR52t2ZHJrjrnEKo3B6gRwpPm5yykvHf1BA374djoJejqY/29lUNcLdE0HIxxyCsOIyBveGrIz27U+KDyYzQPlBmPwmLIg4vt8T6Nh5FrukbcfYsXGFT7gLalR2t+U5YHDy3iPOWXACji5WZEg9VrVLq9lDCM+0zodFZH7KzWbIg/fZ487GPa5jsyVrXqyBHhyX40BozTULtHcKA/tb2/ilnMHw7+a5euzZxAm60S3wNeb7nTL5XYiCKX+XZg6s7EEBzNH74sm1gG515PJk/EZSdsD4P58rVZMD5jPFQ7ncfw9Kc3iiAYK33UST1QRJbEh9/wKc7aGKAd+FT2dqWHyzpkYzGi8BR2c9zl6+/74fUJ48ksETvYkAXNBs5pwW6zxrIrcR6DmCutGuIsOQCdbWFthxfOvbTN9N3/ruN+lDdrbQiUaykaigsyr+1jdXN0vq/IzItDa1iNZ61frpXJ44gsyYw3oopz3tGFJyQiOujrg8lBlJsQMreYwogaaAZsKaWKpBBBYeUOf4Tk23lAqsoYh+nmiYcKXxBKeTZrOxLKkozZHh
 JmvxwwiB
 wVyZCh+RQf4Dv/ySSOsLFH9NKUCVaNHQV3gqU4Eu6oucwj4D1XOTZQ+hSFOJ07jLHjbkG7W7AXOlvguOM9D9UL2Bh17XOOXJFjCGnEnmWqWWspaEo3XMGyIzKroDz1kQf0hCVWzNKGYtSUue8lWu8xgx6L3lRkOQiYBfVg9cjt7xGPIHlnQR/7zbQuq+ChkBIrin1vFLqTax0ZHxMA6U1ygnhXQXn8e6/OChgUEs/K0m2WISjSmcVyXvLurMjF91oWCu1143zkpnVE8PDKyItEravKXbmV/h4xfTucyGX0pP2E2lr+97HmdvGbMjZTjh03vrBud+V+fpXE4XM14enpli2eb1uVH2fuAAFuzEDvTHmzpLmXnf4o9qSy7bwQntUviIqlGK4weZXjyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 12:56, xu.xin16@zte.com.cn wrote:
>> On 4/9/26 11:41, David Hildenbrand (Arm) wrote:
>>>
>>> As we're using a dedicate kmem cache it might "only" add 8 bytes, not
>>> sure. Still an undesired increase given that we need that for each entry
>>> in the stable/unstable tree.
>>>
>>
>> Hmm, maybe we could do the following. I think the other members are only
>> relevant for the unstable tree.
> 
> Well, I suspect that "SmartScan-Related" members might be also needed and used even when
> 
> it's a stable rmap_item. In should_skip_rmap_item(), if its page is KSM, it can't be skip.

Yes, needs some more thought on details. We might have to ignore/skip
the fields for stable tree entries that have not a KSM page.

> 
> What if the rmap_item is stable, but its page is not KSM?

I guess that would happen if we had a rmap_item at that address, and
then changed the page (e.g., COW).

ksm_do_scan() would call cmp_and_merge_page() after obtaining such an
rmap item from scan_get_next_rmap_item().

In cmp_and_merge_page() we'd call remove_rmap_item_from_tree() and
recalculate the checksum.

In remove_rmap_item_from_tree() we remove the item from the stable tree.

So we'd want to ignore the entries in STABLE_FLAG in
scan_get_next_rmap_item() to then reinitialize the fields in
cmp_and_merge_page() after remove_rmap_item_from_tree() I guess.

-- 
Cheers,

David

