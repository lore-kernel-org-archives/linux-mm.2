Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A039CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 21:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C766B0005; Thu, 28 May 2026 17:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D796B0088; Thu, 28 May 2026 17:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463A56B008A; Thu, 28 May 2026 17:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 377EA6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:04:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF09C8E03D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:04:09 +0000 (UTC)
X-FDA: 84818056218.22.04E9397
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6116380018
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:04:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wnejSj9f;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780002247; a=rsa-sha256;
	cv=none;
	b=aL8/wLWj4dNHhqlXQl6JKoD5QOejYXxam29uFQZCCow/1O34CNof6x6kV0HseDUNcigqua
	guu2oOFOxAxqqcDT4HJgwsFeSKrRGFfW7vktakeoZuKYp+mrpNFhKEc5PTx+CHvbmR54u+
	7CV/grD+3utqcI6rip0PpAG5R5HPE+0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wnejSj9f;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780002247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F/ydXEXga9pNCCOc8jvViQzYBjBkNoYRPo4F/Eempj0=;
	b=6PUvsPcyZAOKWtL+U3R15HfyuAR84ufHaB4D3pt/EfvbV6UggXhEkmdB7fuLFq+qhiymKU
	/W4UMeCtVOzp3Wg6nKGcbaMlcEQZ//K8HB7bAx3rafnpytoIcXoNBkXtv6mBA8JehGLx4P
	iF6msk8K37DT0DNhRH50UWpA+ksEh10=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CF4740DB4;
	Thu, 28 May 2026 21:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B891F000E9;
	Thu, 28 May 2026 21:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780002245;
	bh=F/ydXEXga9pNCCOc8jvViQzYBjBkNoYRPo4F/Eempj0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wnejSj9fUWGrOa2ToWl3nhRdwLnsxqVSOGP0q5zoCpAHPw7FEdI8j9HeCJ7NNbrgH
	 YqyCilBAbVA70LNwovX9djz/q5OE/sR6QeyRoUrUyugxvh64HnuvYDht8Pksyn/gvH
	 uTBMcxYtOArp0RtT+tiZXoZgbmYo4pwHc1IIJhK8=
Date: Thu, 28 May 2026 14:04:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, David Carlier <devnexen@gmail.com>,
 David Hildenbrand <david@kernel.org>, Heechan Kang <gganji11@naver.com>,
 "Liam R. Howlett" <liam@infradead.org>, Michael Bommarito
 <michael.bommarito@gmail.com>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] userfaultfd: verify VMA state across UFFDIO_COPY
 retry
Message-Id: <20260528140405.14631ae47653ebec5770b956@linux-foundation.org>
In-Reply-To: <ahhUM0A8-q0UqFv1@kernel.org>
References: <20260527184751.4147364-1-rppt@kernel.org>
	<20260527184751.4147364-2-rppt@kernel.org>
	<ahhAHNSZOeW49ms2@lucifer>
	<ahhUM0A8-q0UqFv1@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6116380018
X-Stat-Signature: eyom155shbz3ycqw8yi3zk4ytmx97edo
X-HE-Tag: 1780002247-516777
X-HE-Meta: U2FsdGVkX19LXK/I/ppd1TxUXIzUY/oA5fYUdzalZ7yo2Rw5NC3DxhuiwRuAKgsll6uQKyeQbFmpoiQRiMvOMHKSTOAN/nRI2nDmO2EnQYSoC+Ua9J2pFaOHLMzuHcUczh1OkPLsgcMudCOlk7u1arnX55Y55ek8zIzl04MqHJoh7fNuyVq4LtmnfY5vJ0zN98TVVsrhrP6+WOCGz5z+cQCLraG9oVsRmkihewn/6poo1hbZWfC9O5geBEafXXKDkWOTUWpHBe9Cr0rtnTJ7/pkRuM+DcyHmPemEXkuA9NgIr7P0IF4oWNf8W4nR0IbUpSzTzKRslDdP5rFW5TwmI5MchusmUDarrnqdl5PFDFzBk+UaxBFNMs4TzDyUekfUGefYt/f246WeizBIf5/noEySkGxLlW/bA49tbTtIwjAni6Z0oIVFk/NTkhOkA8CyhxMCqWhf5yBUBy0fv4gp+4QJeWVFxYafiBZnveDsQYn1Ig4rGCsvU1RH/TZ2lVlxOWhIZ+1DEGxHOLOdMgIezvkWuCx8qiXgoXv9w8E7nlJzBSOdjzknC+I2H6xBill7opoYA+2Mt2GDQVJ/BYsr9jl/Hp2SrqBrJIk4MvafpywyM9/Qaq0WZ5ykbbwGDgYYwCaUxX6I1rG60V/oycstnrpQw3z7L+JJK/2zIGIk0lr1dtS+E7o6JLC92YQAXBBwYgtCQPbfa6JkLlLSwyZOLNiTw6DqPP56RYQd7zXDGw922aaccVP26TOjmvBCUXixMoFRX3A469WkHG8/afBFzzicdwEKnWMkgeZ7oyh8kSFRFkonODfwbXRZ3PmvgYGjgQ0fq/WGAgpWEbv17oUEdPefBfATucDMgzENtYKHAd9/1MP/NFoeTbKkBZkksWFZpp3PwkRIxxq+F2DiZ9OIYGg+LCUxcH+mVK9necZI0eHuGIJbpRiL2bzMKpQUErjGN0S1zPOQCvTQ785J7M1
 kvG9ZaT2
 TsmTP5MF/EsL70kZdJ0pnoYqx23mem37yRhu8Qa9gbSqdKJ48ZNTQJ+BDE4uJgjS6pQYp36QP8VG2sk5jC+3WynpKg5vdws8Z4u2bEVfVFboUz6IdLvFeC36ZwqRn4Yjv11/GwjHmRLQiZGi2zun1gu4B2nS3NsWFFL/aDNOJ0suJgLZbdbAevYaQzpEt67YcbsclZ56kY5NBkhrnsw+XLn4kmqqlOVve3YhqnWr7TC40tLmNBu2SWdFdeLrFQnhkTyWLB15RCpGeXm2Y6cW++UDCsfDcPe9pES5OFx6D2+t2rDVDPDlD9BqxsdBadwIquSOC1+Gw6IJf4HcqLBJcolUp7fMdZb3wQwEl/dgGrhvo15bxwvEV70urc0llMGr737DTcuIW0q2zpW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 17:41:55 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> > > Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
> > > Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
> > 
> > Did we want a Cc: Stable?
> 
> Andrew adds it when applying.

Both the above commits were added to 7.1-rc1, so I haven't added cc:stable.

