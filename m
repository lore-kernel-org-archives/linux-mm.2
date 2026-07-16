Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 931A2C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B51D56B00AC; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3F86B00B1; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8456B00AC; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62F846B00AE
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 366EFA0027
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:10:10 +0000 (UTC)
X-FDA: 84994370580.08.635E98E
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 67B83120002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:10:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p48uQ0aQ;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784200208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3qTUlAZtfyZ7xbFmZwVJHk1XibDL8ur0W2nLm7QO4U=;
	b=ptoj1u6aWGh8KtN0+y0K3ZiXrTS3fVDdc9IWOIrscxdL5P84iLLjoe1vMWNTDSULDGRoAQ
	FmCWQ60XwBtkCX/2MTMVcfbeeF8GZ838vaQ+llxGxueweOoHrsyGi848RLjsMpouHwgBbT
	6nT8AjSNNSgvYg+J5GBLzB2s8TyQIyA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p48uQ0aQ;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784200208;
	b=rlOq3LpWtzYChP6RBvM9su3HudpLh6oHFjWhW9dHEs/UocIYKipa21koQNlY3hcv7K/xSU
	zSuIiVDIE1CV7ENaGnIi81rvRf68vkybMa2Tg5ysU9RNRDpY+PgGrA6yH2NDcIEu9ARZJN
	l3dx/8knj7J6loWnc71zAzp2hADM1Wc=
Message-ID: <634a3188-daea-4ed3-b252-391931764814@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784200207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U3qTUlAZtfyZ7xbFmZwVJHk1XibDL8ur0W2nLm7QO4U=;
	b=p48uQ0aQW/jRWzis8FLe/UcULydMP18jko41frjQlMCHP/KTlrrgN7ekr3kmxr5Ut0B4YJ
	wNLPRO62gDyf/VDIodsGCwFja6fsz24DXxWldFfWDmw86zN434TB7yJlzce6dduxOlnmDJ
	BqpZiic3qA3hW1Jz5uEbD18X9fwyNME=
Date: Thu, 16 Jul 2026 12:09:50 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] mm/huge_memory: fold split_folio_to_list_to_order()
 into split_folio_to_order()
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260716100345.473473-1-kirill@shutemov.name>
 <20260716100345.473473-3-kirill@shutemov.name>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260716100345.473473-3-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 67B83120002
X-Stat-Signature: 6n7yft5814dwuwdj8uo1np996jhueiht
X-HE-Tag: 1784200208-410639
X-HE-Meta: U2FsdGVkX18Qd4YxRofEaM4Kl8pmikvDhpLVSLtNr3Vh6UqF9/CGEi4VMSvG1yt8jvgS2tkKEgQ14hXvohBdYyhl6T3h9f2IpRYcoLA1wJ90NHRWlzGiNQ/jkofPs5vpRXeH5zqg7D189NgYoWgWG2i4tLLoA7yL7WsYQtjSAxBugSXItMIwbrtWBob/xoMnL263LI+mfyeeh4RcaBS83b+jIoOvYrJIdqsCXV2vPuXVsUWyX+jObaWkvNdabo68s5VHBsX/9zIfsYWqH9fOVdtqy5uzIJRPJo90QXmh3Kf8mEiXDd8sg6cf4/Ebm/hjawvzqQq2a/UvYyzGNScwc+ERDCRZ98os3wXJgQhnOUDWSq5YhxHyFM3+Fpjgy70kEXjvnpDkN6Z5ZXXQoYO/DODgYkQftowQgTUgL8eP7yq/Ur+dlbn2ybsysTxn7xOc7rc5lrZZaCIYJHZ55VZNBhb0UcV4EQrZjJK03Ze4r2P37wwkL4uWwHB1w+yjH5zSecu7uz8LRF/VZqVA4RNk9jqTx1OIGLbBMVVokHaoWKNYtoHaSHfP8zCBBqCmnFh0CS08p3x2c3DlyWEtQPVZFfjLZA2iXUxdnYWzbcUz95eJFK5oJi0K1ifAMifbiHDFFbrNJ7s9cFin+JrecQKWmvXsp17RPGZvgkiWbHrsS6XlqO7QTz12wwKnC7t3XoS+Ah7qSzUGg9KB5uJJbjMvGzHL5GzvqsDKwzXOF5IETzEzGJo9KwNXblQtOAY7/iN/5KywN9n+QGsnqRN39PYnECe6RuUWOTRilK+JtlJ70I/5JyB5rm4R5XOlqW9D4mrbcC6NAMhjCG30Nbjwl1kLibk8w9IGzbgO6AT1ttSQFfrwxt7j4ZgAobcJl1QHFF9k+cMqX2iH+SDBILBcr79Ba+SyxNrvlvBAKUSOxY68nYWwtva3zX7c/FhV8V2IGeGTRSO9XbLp0dL5fEbKaws
 kFKmjCD4
 eJyG9B3HkOZNQ/zqLyFaRzqY9UAHJzbacptXz2jjvbS5eEO9VsFJmam9/eEwPZ6dBCEAcrlLSRYw95IO/3APj/+pTEqBiwrnadJ39nrKIXhQASkgaS77SIiivTADTCpA6ypG5tQJz/UeKg6Sn5u8UfXsWnQd0rJi2mVJoperoMleaxEt4+xWVfdHlDP3lP/Ont9V0CCky2YAwrMSb3uatRUEqVuopdVv+tW7ABMz/PCpwCoCHgZj6+MOxnAgTM+1qq5sUuHjv3AmxTnL4cNec+/ccWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/07/2026 11:03, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> split_folio_to_list_to_order() had no direct callers; its only user was
> split_folio_to_order(), which always passed a NULL list.  Fold it into
> split_folio_to_order() and call split_huge_page_to_list_to_order()
> directly.
> 
> No functional change.
> 
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/huge_mm.h | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
Acked-by: Usama Arif <usama.arif@linux.dev>


