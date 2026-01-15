Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D813DD46627
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:34:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98306B00CF; Thu, 15 Jan 2026 16:34:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2EF56B00D0; Thu, 15 Jan 2026 16:34:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51D46B00D1; Thu, 15 Jan 2026 16:34:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C11316B00CF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:34:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71DCF8A866
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:34:31 +0000 (UTC)
X-FDA: 84335502342.03.BA34E23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8465F14000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:34:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2ISp4b1;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768512869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGpn9FbHKFqf9d1MqKArdMz27a+K/qjUaMw4b4Nr/fk=;
	b=DRDHihUcVO/0uWlujYpIuFjtd9ssT6JtxmMd+wvskL5RWTSL8SriCasC7EbF2mrS0QMeFt
	AJXNo9+l8CPUBBd5WprC2DRQOS229v3xafr4+o0KZdCVhq5oJrY66P/3K9+HyJBZUxB6BT
	ANsQHYRCwzdXsa3isPsdC04G0lNx3Tk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2ISp4b1;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768512869; a=rsa-sha256;
	cv=none;
	b=ezvxWj2duEulBxTeo1PBbsBqMWgp33XAFekWkbSRCGqimkOVX2Mi1iyGkguWVgj07mdxFp
	p/yanSQablrxfPRB4bf0e0yDISBaSAsfDWobl30mBQzo3KjpiyFOvhU3hXeo7dM0YAqVsA
	VnVmUILNvLk3dApFgqdsYrf80NoZxJs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77F614394C;
	Thu, 15 Jan 2026 21:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CFDC116D0;
	Thu, 15 Jan 2026 21:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768512868;
	bh=ecMo0hL7WHMaPlM6mA68VqLafm/0FTfyXJVHdaGSl5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U2ISp4b1yxaRXXBRwr4jhGGzkRnOU2lLqd7dgqIxOx0mJszWojhm0yTZJg4F2XcKK
	 XfwJiU0524cuYRsy3K5NPSak2fj3iBLY0Y+P7f8IpBGO15GSHFXqwMIWpWNS6iEw0U
	 Czku3y4DWMM0jBn9fE6go49fqCrEvKIfPohetgh0lkcPVeibuAl2nktlku/54KLDQp
	 riX1lJS2YIDTkY8cac3IOossGqbzKwwDgHoc1QQzrwiMulAgIEArFN8HJnkbbCrYJz
	 SgidSX1YWoqAnwmJ4lZy2LFsJsKIf4nuFTRY4oYsVfXZOM403/I7zMCzpRm6I7VIC6
	 wCRZ2eZPpjo8g==
Message-ID: <32c86644-d1b1-46a7-89a6-da5e99ba21c6@kernel.org>
Date: Thu, 15 Jan 2026 22:34:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix VM_WARN_ONCE indentation in page_alloc.c
To: Matthew Wilcox <willy@infradead.org>, Manish Kumar <manish1588@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260115201305.119383-1-manish1588@gmail.com>
 <aWlMp50lLH8xhx-Z@casper.infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aWlMp50lLH8xhx-Z@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t7s3uwj79bhetfdcisup6b6nkftasnax
X-Rspamd-Queue-Id: 8465F14000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768512869-59095
X-HE-Meta: U2FsdGVkX1+AZl06KMQDnS82Ur1+ll9ZOOBRcgWVxJLLqrPjJxqeP6g7GE1Shu90yodEFwScCL1HdFrhwuXxJzVHia6OLXroxs+kY4Ym7933KNnhbrDBoe18aIfLi9qfYskBnOSKQay3etYzqkpAU0KJz7ILk1UFbsKhNef6SC194KDncIITFfAN6laFK2CmVs1qJtvnf7EgxpiaHubkF1l7sDjLRjlczkc568qvlNJuGp/+pxPVEnt5CBrv84K10FCk5yrry/rTMu+Goi//tKqGiaJVFkFEFjI5lsQA+kMrkps1iFnVva683wfLwEk0zb+KiYLjLouEJJ8i45bLfptAkeNkKYB40PNO+HM044LWeHuy5eipQZPRHRIWYYoP2ToGzJdjorpKI2IzLPE2Y5YgQCODcyVAMuGK7B8fN9iuJz8KlYQuWs1+VnKoHflPMbOqIGsazaXteKSJ/ACwZZf8zGqxjrnYWlmBYx0KcbQ7X20sCcUdzd2peMk/PBE4pgVwKqYE+Fn9gDtqlMvGAz1dZyHvcan86DXKizlbSdNnTF2P0Azf0az50wA9R0XW45IiZRT99qshEwOY96r3BEeVaFE6zv6IX+y9rOjGbUb9aVgVh4gMxLPr2yp6Nq/8pQ5nkrr00X11kntTqlHHvBjJftEOzsiAKrmZsNEumOvkdQ5B2LlNZyJrMrNpDmrN4jaVtI8TvHn+5/vGZ8xYsexTqLxOIVtEfqr9GFsE3jB+S3SQ5P3s/nVjIsb1pLihfhO+t8kMNJPGQDckbISUEtKf0deAAhh5dERl3L+AP7Kkrb0kdRukNZCROVED2FaX+boQrf3PqK0PVMnUItfJ7O7Si+NRviIYgO8Z6U8BYASyWX9RK7dnXK2mdpxq69ZogsbdcsPPc212WHPL+vmh0lZEA4O7uEzqhKpSi80jWHixm8hdM2HrkzQUPaa5eub5SNXvmgOqp+ZxUbFh7h/
 Lk76vA1e
 pMQ9juexUfXfsFCUH8LQamrDwFziG0Xv1nxjJweXe7iKQ/M2JEz75igpoQAalJsxE/EQR7TgX5rp9opF7mK3UqOGC185dTlu2+5WqqhHeVFuSIyMbtGN25+6/TTD428Yd0PysLsmE8PF2IfxHuIMjZGotBaoqB6iHv5Mq0U6Y9FM+AxL08aGUjhX4LuxqOFSpzyyDdjgYDnIxAHaHG56dMkvA477WiQiqgAHWgLBF0gM9cFD2P7lPxQIQWlry/cjMvqVHSYKGjpkuHDVwlcMSS+jZn5UmcKXgZsvILAKcfx8NBg1tBtgZJ/G3pxXkB1EazYZ+vrE8H6pqiQw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 21:23, Matthew Wilcox wrote:
> On Fri, Jan 16, 2026 at 01:43:05AM +0530, Manish Kumar wrote:
>> Signed-off-by: Manish Kumar <manish1588@gmail.com>
> 
> Stop it.
> 

Manish, these tiny cleanup patches that don't add any real value just 
consume reviewer and maintainer load.

Flooding the list with them is frowned upon ;)

-- 
Cheers

David

