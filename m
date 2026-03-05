Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FED9EEF319
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 08:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAB346B008C; Thu,  5 Mar 2026 03:11:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55706B0092; Thu,  5 Mar 2026 03:11:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82B76B0093; Thu,  5 Mar 2026 03:11:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B424F6B008C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:11:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5134A1C97B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:11:21 +0000 (UTC)
X-FDA: 84511289562.04.DC5F8E8
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf16.hostedemail.com (Postfix) with ESMTP id E24CB180003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:11:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=nZ0KaaOs;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf16.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772698279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNRuvtDzBCCTYlNSNEuQJ/EYX0IFXWkYlUXQWsn6spY=;
	b=uQtPQmmFh40Vae7QvslG5pQ+G5+g4egdVV9Mb9mn8GQEKTHl+hJd+tJJqtDwPWzuqpdyg3
	LsPHkkTso3MR5BJMrdGorWesjEvS1TeMbaEUtHfWgtdUZnhqprlVvHWLrLu6u+KastpWva
	g/lFFrjXmR056d2xJFjcg02tGd8bcJI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772698279; a=rsa-sha256;
	cv=pass;
	b=Py6CFTJBS38Yx23M6UqWfu/+B+mJvgXrur6PRTvCcAdctILvFq+5bjtgqUdR1bDzjXcYyI
	lgpLcETvqtoqX7XQSx9fJuKnla583s12IRDR4YAsDU+iSHxZEEQxvAH4lo02jD+Zvf+89f
	jbVwn9KTLGG7D9RMEuPKOTVkU3ZR5uU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=nZ0KaaOs;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf16.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1772698259; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=Fe1+MdloffKjCxalMXZ8sy9moreB2j7xIM5grtno9AvGGEwL/iRrb2R/gvWZjzpk3AGKrebTkk1DxV7ln6W2WVBVN50ZDy7QIFDprnZFLSoWAH9bt3H4CPtuxlbl8KC2ayNzq1XwE9G2jjnRCUUHbxoRKXo97L5LjiSdXOFzKJ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1772698259; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=YNRuvtDzBCCTYlNSNEuQJ/EYX0IFXWkYlUXQWsn6spY=; 
	b=QZVt7mZoWvP7ouMRv3tBe3L0iAJOZsAf1HH9NkOQDlFxt52xiOKCXH75tC6S2pkNnXXeRUAMOS/Nps/RcCmLSj59moJCACmsH6LZJ55idmW/WLYX6AYYBgDR19b/CBpbHsdbhck0yVY/8XVIx8+eXC80OVOYLQqLtYO3dLAVq0U=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772698259;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=YNRuvtDzBCCTYlNSNEuQJ/EYX0IFXWkYlUXQWsn6spY=;
	b=nZ0KaaOs0Ha8vRd6T2wyzR7kPsJZyBLvOUKA39nmr23moycwPcYG5hgOvu0/fFvJ
	yi0RKV6CejJ8aWLJeLyIHVeHDk2MGbklE2P4mQSXapjw+NaBPCoZzdJKR9/x7slVWtf
	lRqszCBfjUCWN45gJVzObk64LW+kKmiwNQQ85wOU=
Received: by mx.zoho.in with SMTPS id 1772698258745228.0871570809478;
	Thu, 5 Mar 2026 13:40:58 +0530 (IST)
Message-ID: <c3e91089-fa0f-4d11-8fd3-80c5d068c072@zohomail.in>
Date: Thu, 5 Mar 2026 13:40:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Shivam Kalra <shivamkalra98@zohomail.in>
Subject: Re: [PATCH v2 1/2] mm/vmalloc: extract vmalloc_free_pages() helper
 from vfree()
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
References: <20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in>
 <20260304-vmalloc-shrink-v2-1-28c291d60100@zohomail.in>
 <aain23Jm2EFsuqDN@google.com>
Content-Language: en-US
In-Reply-To: <aain23Jm2EFsuqDN@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E24CB180003
X-Stat-Signature: 9oz9de88q9p455jr4jmagyzmtez3rm3f
X-Rspam-User: 
X-HE-Tag: 1772698278-562725
X-HE-Meta: U2FsdGVkX1+4auxJQpKK5mIyTCVMdvDEbzPEvOAeXNMPAHHvD6xpE+Jy9S4r72ecmyffZl7qFANogSkQS4KRmV4u8513fuyHX1z2DBOQybTUjifSIbjwCknajfLYOIctqVfFEPR99N3/SZ6tPgqtzz0s73JE9A7BD8w8tgGcwqJJWztNm8E68GQHQtks4PMdBFgWTxXFHXNLMVSiQIMxCrPTIb5mJOpIUwsqxedJgY7JJb81xYBbYB9iyCr4Als52JD+A17X/X8XkHfZ0oVBEc7CtfwkymS+dOKjXFDi/VBT5Epw/1y68CEy32r6R88Vd5qvAM6lSGKtJX8SCgVuJPSyKChg76TBDA1IOZwvGM8Px59e9T4tj2/Ys1vZsIpcrEDOlBZFCqvGueWRl377aWYVhlkbTTup6gIw1Rg7FuUL1dpPlGfElUKa+ux4VxBbryToGhHEwof4vAYH5gZ2DmXFuMYR/9w9SJqxGStnfuW5UbFQGXiAhXPuIQRSzWKYdnFWFTNK66qGGyGqkVVwiHFdwbdid/WWXM2XEteFEC0iFdtrfcvJGwVvRvDdC1PIqS3/Aqr7XTUlrcIz6ewMajKsk2WDqn3b8uiok/SZaJ7N5gY170UEeL0vE67cs/vqIYVZo3pZeKBFhR/HDYcS6t8cxkKxDe9w67SZz9Rv7aay8LoiZNAxbNyjNxnfT8pzBVyfiqGa9brBdZtlFWsIRUHJFBoYo6bNh44OzgJOOXmjAqlJpwLYpHeuome+0SaymrvmLy4RbdWu2Gg4zZ9aeYI91ArCU2YMtEljIEVn9EVC9mutMqBXKZG1Vydz3ui5Njrp/fHi8svfWVYmduyeH8FMFTJNn6t8PfDb/KcIA5ioQEqkzNG2mWWDN/iygD3XY0rOMxoC8lQ8FCEn7ueCNU4NIEWJOJfDDC8/Hk8mzWNq59ms8UeXxdXCk7VMnTID7G8nqSz/n0di71IKBeX
 WkSMUhd1
 6SIioyblbBQsbyJBJRjUsFANZ6DQvgFdnhLm+kn1F540I8hDwljuuTvE/PSrPvG7b1tgI0ZqB1ER00WHMw03aNoQSSZXEUmyX40GaNZq7Dop8C8JTQa2tvAX8vVeu8vl/5Me4GTOWh9nPq3Fyk0My3KqH2rvD7btEHqZ3Tc9zg5m4jOdKjnguSMup33nd7fdLm8QDMs8nDgbP+R/861A0Vb4KjYzDadS862shCY/Hm3TeSDWLYqkTAG4uKt+B7GB2EEAXBL5ZhPbYaDDwRIUT3Vta1G+do0VSIVD+kuC598l6Hv/MnS6gRS0Ix4Ie7LnC+BqjKodvvndfc+IxZ7KD9EwBs0mdyQKwD17YkLdOGYP6koIZJEaW5CeyTDiOQK1omaOh4GkcAXUOHrRalSYcTlB7WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/03/26 03:14, Alice Ryhl wrote:
> On Wed, Mar 04, 2026 at 08:23:15PM +0530, Shivam Kalra via B4 Relay wrote:
>> From: Shivam Kalra <shivamkalra98@zohomail.in>
>>
>> Extract the page-freeing loop and NR_VMALLOC stat accounting from
>> vfree() into a reusable vmalloc_free_pages() helper. The helper operates
>> on a range [start, end) of pages from a vm_struct, making it suitable
>> for both full free (vfree) and partial free (upcoming vrealloc shrink).
>>
>> No functional change.
>>
>> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> 
>> -		/*
>> -		 * High-order allocs for huge vmallocs are split, so
>> -		 * can be freed as an array of order-0 allocations
>> -		 */
>> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
>> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> 
> Any reason this comment was dropped?
> 
> Alice
Great catch. This regressed during the rebase. I will add this back in
the next version. However, I'll wait for more feedback before the next
version.

