Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C5DCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 11:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BA6F6B0088; Mon, 22 Jun 2026 07:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CE56B008A; Mon, 22 Jun 2026 07:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135896B008C; Mon, 22 Jun 2026 07:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D01956B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:33:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DCC21C00CA
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:33:35 +0000 (UTC)
X-FDA: 84907338390.07.4D3A3AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 730CE1A0009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:33:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GV7WUOR3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782128013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdAHnBdpZTVQI6juQSN7tgkFMstxWIXJjISjq/WP2WU=;
	b=QFyHCstPFBZw0MOS/IE6Tz5z69q4HwHqdsfq6DELTQWenT6a72oFRdKsFDJS8j78PRMpK7
	8lujOff38e5H/hmIxJUsFa4riKMn9bPzJ1KcEJK5TumIdb/fgxOohh8Sacbkvw3Ui0FEE8
	J60E+DcihtMfxVuxmKqqjCosbBUolCQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GV7WUOR3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782128013;
	b=O1AkeQb+1oRuMFwSKA0cQxvSp5c3A7GvgGOtAAu+ksBrz+nXdE/tZIwdMAgxm7KuC6Grvb
	SKhF6qrP8NNtqKrqQlmaEj6p+MdC3Le/d+MXtB9ccMx83nuUwCtYuP71n1CqGMpWPUtRFE
	7oVjkD+Des1jpHZ3TkajVUgSYvMOjAA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CB4743B75;
	Mon, 22 Jun 2026 11:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E83E1F000E9;
	Mon, 22 Jun 2026 11:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782128012;
	bh=kdAHnBdpZTVQI6juQSN7tgkFMstxWIXJjISjq/WP2WU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GV7WUOR3AKzyuoyutFs2YXlaNT29n2+g5sSGF91wr8n4mM+tAuY/Yn/RROb5L5VeK
	 WOKciHW3pMe5vks9O8qElaXX7Viqz6vnJWaT3HPP1m58rajXIVBTJo8Zggr2VZyoQ+
	 Af8KNEFcYbHd80QCcNPsWOgPKVsy+DRMqWjf/AhyZ2KjABigK/lg7a3+FgnAgJBYQg
	 HQlkyFUDE4LdL/n9maBixJzJR8QlfBOfBbaHNM132BuEFVtcxtMKQZ+LGOeNJZ9Scb
	 k0KMMctAjURC4tmPhQxot9lVafqX/z1NyZNDNdYRhx5Sj3a7N2aVGXFUDHK58cNZIt
	 9CjY/hlc97c8Q==
Message-ID: <35b8dea6-3f0e-4e95-bbcc-bb778e567d20@kernel.org>
Date: Mon, 22 Jun 2026 13:33:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, akpm@linux-foundation.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, balbirs@nvidia.com, ziy@nvidia.com, sj@kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260616063436.20455-1-richard.weiyang@gmail.com>
 <ajUXNjRMraKb6k2n@lucifer> <5e7f7fe5-221a-4fca-aa76-297ae19eb80d@kernel.org>
 <20260620021353.nn7xp2ldqachq7gp@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260620021353.nn7xp2ldqachq7gp@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 730CE1A0009
X-Stat-Signature: c7phj6gcohteafjr6e6bxppd8nzc139f
X-Rspam-User: 
X-HE-Tag: 1782128013-996930
X-HE-Meta: U2FsdGVkX1+rWJaByzzY5RYKB5kAIztpQUCSBgTl2ObKSP8ZvWspu8e5vUikdLNwXTzVemBo4/Mh0ndocWMbTUK8mK96klBYj3bh1IF8xll7WGFqUSUHAAQ+wYeIDoiaumfxD9pGlw/H8x8XuZFS0XYxSgDcy+2ZlfVb6JdF2iq4ByRDvCLXiMfjUJbQqJ1vAEk4O8/04QMD2JEzQI+EsUDzpOkDogwnoDmQi7qfTpoFi3PRZTp5FIaWqAj1/tlJHPFqqyYRfbna0lVROjwEdwFgcAJE7ho5YISkNSN0RGNUUPqJ7P2+Mp5fChH5cSOToJqy5mvkTVWnGbsviUqSsqF8712AaA+8PQAnfF6zE2rJKt4hy0MWdcXtRTbppDKkSp4j+pL/Cb67uUqC/Xea13Q1M0QLJMhd5weSvzUw9E/2zomuft82zlSvHfXs4Y1SFKSugmC0qEvepz2jTLCxwDEko2+obMnL8fBR1zhbX86q4RrgoJO5RH7WbCz2RLQr52jguJoDRA3lGGJg9riMC6DnzhW3ZJd440UOOJS9Za9ruuJiCsFQ+ZWqG/88PjvzbbCNUwGgQMJcf4do43Dltor2j14pod8jX4uMEQyECFQRXwux1B/rhnHwo7j38Vow7jJYl+Ri/2bMgI0rwJBGYOBH9UKSickGL3beUwQp9UNae71DkoYa/VOkprEbY9zE2/hHYTMRHQRCvNXT7F+fBWgSpueXPl0HHFNveO8QtyDGA+6bDur3jpU4l1DVEfMU+y6YOtjmLgwlMTwTX8Dq/G01/55tXSP1Ygrs+HjRc4WvKVb+ASREBxllSN/3GnoIYBzrslL8Xas6KuAaMLJtIAuvAYEh0D3eRV2ynbhuZ5Ok3ador64S2rgYo4HSsPHzdKdDRGJTcgV0e5pNve2IuKZljcE2G4cmZ12Tv0uRe2p0k9p9qKR8FTjEFfWlXpqQ1GCkDhvkeDF8MdXcwxO
 0zM/MUiH
 NEt69O15zeDW2VONqMN4chu3HgWUuyC/H/6qm8+bu8eiHhKIl+GRN+LPsPpJ7JMYKtZkffgdtnsjaAk+hwubxWRI46JHrWdwpswDunkz4gHSyo3/q45agUFraIuaX6nGdDnwtOrr/mEi3uADN3b32nmXJ/eZppHiEFQtF3C/qGWdQ7NruDSIyz55jZLATrzIQDtcTXMrOfsEmzHl/db0lNUoaipHu5/Y9wn67a+i4FEs2Xe1t3d/Ii5PYkzODKsnyxN1Cy/c+g/LiFXfg7iCTjMzxGqbouFMZUcMBTmXvI61M8nzs1mLtNzMUM9kn+YZaPyQc6BdDvYHMH4hnKDZfogkrpEn8/ZZLkfNoQE9vg8yvZPV2L/3uOgKJXcvdb3TmPc3X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
>>
>> I can then follow up with a proper cleanup.
>>
> 
> I would like to do a followup cleanup for this, may I have this chance?

Let's fix it first and then decide how to proceed with this code here. I get the
feeling that some more of this code might deserve a cleanup.

-- 
Cheers,

David

