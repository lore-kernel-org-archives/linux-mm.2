Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0232C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 08:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E976B02F7; Fri, 14 Aug 2026 04:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDEEF6B02F8; Fri, 14 Aug 2026 04:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE846B02F9; Fri, 14 Aug 2026 04:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAD6D6B02F7
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:00:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45E1C8037F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:00:50 +0000 (UTC)
X-FDA: 85099128660.23.CFF1573
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 559BF120003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:00:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U9L/FnTF";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786694448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhcKZrWhDB0YnVEKvdcLGekKlgN58T3c/92Y6hAn+l4=;
	b=qG3UppT0Ph8u8YmKeb0Y6dVaCJs1GkOiOHEncR9WS9k3T1ed/VRt8l32+ZNAWJSFK7kxLb
	FMhnKGhLS+xtKCVGglDM7qFKigx3R7ajAzn1yDVyHl243fNRBRouj1PqD/l4anzRmwalYK
	ZT8Cz/FSwjhHX+4XXC1XK+l+JkqAqAQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786694448;
	b=IEi79B2ecwejXajshJkp9hsM3iVf9Ayvf5NWhjVclkdRS1p16mxd2NpwQueG67hefVDU7T
	Grb8ihDlk/OQ9LT/1hMjfmlEF5FvvcCaAshwqPMU0l6s2e8mYxLESPhzTFfsYGTAJTO1X/
	7m9yyGBCzZhY3b+No3+3JJep0VcMc6E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U9L/FnTF";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E18140428;
	Fri, 14 Aug 2026 08:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A541F000E9;
	Fri, 14 Aug 2026 08:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786694447;
	bh=xhcKZrWhDB0YnVEKvdcLGekKlgN58T3c/92Y6hAn+l4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U9L/FnTFNJPjsdCpnSGdqy8pWWn5a+XlpxtAuN9SSN3+APUg5fQSrgMHyGoxzWEOC
	 fXfHqy/BZDHMl+kIgVPOVF+RwS46T27OvbBqCn3qPAuxfawakwGXHWNPLd/SniIC4X
	 djHFPft96i2hBs0FNSlpG4cLxCLJpRa5vHtYlnh2eent8vbyk8zQlGRV6yQx81HJGq
	 ME/vF55kgT+QA8lh0cqFWIfYCIJbyGUpRytiGCnZA8Y2jIlsh86uG/SvFCNY9S1DxV
	 CH7D/Wyfiqv0JbAcOpeF+LYFssWaxGZRLSdqCGxV5h3ZosVSVajb2BoHk1dsrKrOK0
	 T32F0tl/Og2FA==
Message-ID: <aef7eb6f-f7c9-44dc-9126-b70a38659e16@kernel.org>
Date: Fri, 14 Aug 2026 10:00:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm.git review status at 7.2-rc7
To: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org
References: <20260811205836.59301ca91b65781c6292a439@linux-foundation.org>
 <6023e19e-32b1-4110-b9ce-5063f7976108@kernel.org>
 <4535a2ca-d145-48b7-aacb-027e9ba258c1@kernel.org>
 <an0F5e6I7OJWTCLa@casper.infradead.org>
 <20260813141440.2010c9d9c34a24ae453a9ba4@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813141440.2010c9d9c34a24ae453a9ba4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: n6m9a9zut19dai9yka1zfgpn83o463wq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 559BF120003
X-HE-Tag: 1786694448-837833
X-HE-Meta: U2FsdGVkX1/675/T9CywvD5ZmAWepSmhSWT8AVPME8mszD58HgVAyKurJVqcbOCGK6iMcOsD/fGBAeMvpQR8BmTa0LeK2nCrWt5eKL/buYxsZDJ2/CG7K08b8hqb6QN0zIPUHRFCQZYjI6ALZ4oskpJAfGiytm09Z2nt2EJwi8vfJhJdmQjl6emjShbfPWuF8PGcri+YgDw0gW5G6VtPrkZOUhvyWuzfg8mrCdgYtFJroHg4b0f+rzGSHuY1sdTU7ppcU5CW6NMfuS4vg7CKlkf3X0BFZAzbu+2FBCe8WsmNivJrsrCAXfvVS5TyHyrveBfPeMTki5Q8dhIQQl0B4DTE64KWTHzy/+w40mIq2N8bh8rj/A4CjeU/daKEAz8r6FUepmPNkfSQt9kRTejQWrN3pYetdqQRXcUCdXYF+KElxny8w96C39pnihDcIHteKh3/mlPtRCVIlvvmZUPi0alczoafy+78P+AznQ9iBdWi7veZPaZ3T9ypY2ZEa2kdRfyj//r61iBIBpfo1b6uCoUCA13oWmHSrLQJIo1n59pPT5PpUazgFh8CRql+F/6sc24F48gG+pYIw04Tj5TI6Nym+7uhDGUXe6vMzMuJLzpEkLlPJMlr1J2nrhmfOACgpuEd23HBurj3rN8ZJ4faGlJAEmH/K1NZgXuRvvr/oWPdBUzgG+ZtYNKP5q7evHEcB0YCdvW9uG+CD3A+0pvKtmtwZtN4W7k0sqiHcwu3o6n0Gb2t2tCJ+h3kdUEBC7v7z7h9/OYLKYQasMWgWhiV4hMZX7GW7ib3uOfoj3hHCeN8+Uqiwf8dFBvZ3gQba30t7tDKJL+1gDvTslcoe70ID3MvQo/igxIRmBm5rZktAx71VZLMwCDsvRDAdT3EA2xXEx2WXZsZirHDKMS7Qel1wiL/Uzbid+zae8wHHJWY5XoaIlbTOi6MEjw+YlPGvgyBZ4/tis1JpuT0blzZrgr
 9feQ5onq
 kSFeK1tZb4+mYo7vSu4pRNqpr4ylewIn/cLeAgB+7Ezn3XMGNz8yGrMdGDqhDse+Szwx6bFlOjti4J33XhZHdy4eLCroncYpHOr+r5AoUu6IyrEBBhiFfpVNLlL65SPbSExDzSm0WrIJ8wzsAVgqu70rH/hpmStIcuKMYc4Ekj/J5otAPNZb9PCaB8jfXteDiXEprTM5eVVUa2hYa2yYvHbx+Y0ULxZrNypxLCrlsJABUPJMlkpL8y3dJFGi/Kh7+wcI3VxBRK5Y3rcFtAj2Ilctv/Qn514WiDfKQKiOtI0GuDhnFrZzPepuP8frMZgHmxEp5wOJZ0ILh1ca1H7G4zaXzrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 23:14, Andrew Morton wrote:
> On Thu, 13 Aug 2026 00:46:45 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
>> On Wed, Aug 12, 2026 at 10:37:13AM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Oh, good, we fast-tracked an unreviewed cleanup as a stable fix upstream.
>>>
>>> What is happening.
> 
> Yes, the fix should have been tested, sent and merged as a standalone
> thing.  But I'm reluctant to split a series because that results in
> merging code which the author didn't test.
> 
>> Meanwhile a well-reviewed series which includes bugfixes is apparently
>> not even being considered for this merge window because I spent a lot of
>> time figuring out what Sashiko was concerned about?
>>
>> https://lore.kernel.org/linux-mm/20260805210557.1118966-1-willy@infradead.org/
>>
>> This was originally posted 5 weeks ago (ie when rc2 was current), so I
>> don't understand why it's not being considered.  It's been tested by the
>> people most likely to uncover bugs in it.  It's not going to get any
>> realistic testing in -next because most people use neither hugetlb nor
>> hwpoison.
> 
> Sorry, this simply fell through a crack.  Happens sometimes - poke me!
> 

Just noting that it's the right thing to do to not merge code without component
maintainer's ACKs :)

-- 
Cheers,

David

