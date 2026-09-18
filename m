Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A820C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE88D6B008C; Fri, 18 Sep 2026 16:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC1E86B0093; Fri, 18 Sep 2026 16:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF616B0095; Fri, 18 Sep 2026 16:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 606346B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:02:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB46EA07D6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:02:41 +0000 (UTC)
X-FDA: 85227955722.14.8069E99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id CCE59120006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:02:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lHo0ddht;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789761759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfXpuB3VssjezrYOYh9da35BTjf7OH9UxejBC4uYQV4=;
	b=oLC/zctxU0yTJluLZKUoVO7j5xHSzm5L2MaykbVxRqDD4CnVWoURovTwxCGDCibRBA+/uB
	eQYQFNKPSyrHbgw6lWAJHVe1hZUgr5q+buqped1MJo6DQLzABnAk7kYuFqZyVhDGaTTCaB
	Wj3oRPtc42ysk7aQMY1NVrA2vdty91Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789761759;
	b=muX7pgLJR9WWTeMXa5hd0joZ9AHdG1cAcQFXEkTbyNeyMiuyp4veBhr+sx5lBWa+8y2/Rn
	WFteG1iUEOzRsaOAd2zfWbzIq+tAdHoqBCjNQUvqzSanZX2/L6zKOGxi0P+Ho8c/pZmxlJ
	OaURDY9Y+Z/YGKF46Mez8aYI16fEb7c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lHo0ddht;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0503A419B2;
	Fri, 18 Sep 2026 20:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF641F000FF;
	Fri, 18 Sep 2026 20:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789761758;
	bh=DfXpuB3VssjezrYOYh9da35BTjf7OH9UxejBC4uYQV4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lHo0ddhtSXzPaWFlT4LKEJcI69Y8GtCiWLjac0fLbMkqFRJH9tpoJQwD4EsHWC/t3
	 LmslvShgiarvJx3xPRx9+xt/q5aybM1srUZ7NBAdevcKzZbWgQn1UvdGiq9L4TGxbT
	 5CRWqar8VMkouziUOguyZfeV4jqWKBfDMreqyeumJhs2MseiymlKY/IwXfk8365ZfS
	 vEiU47/lDUt2wM0k/hdLFRy2AHxZuiK996/G4xjlyffcHzKmmjwgY+o4RamtaPfBK6
	 L5DPTP3MuhOkpYYvzAq64SWXgl31xNAFNkjc8UnJeMSjs4DYCh54VQUzLJxZUiLTgz
	 ABxTBAAa6+X+Q==
Message-ID: <14a5d278-9790-4cb2-ae1f-4980cbee1bf9@kernel.org>
Date: Fri, 18 Sep 2026 22:02:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/9] mm/memory-failure: efi: answer whether a range is
 poisoned
To: Harry Yoo <harry@kernel.org>, Breno Leitao <leitao@debian.org>
Cc: sashiko-reviews@lists.linux.dev, Andrew Morton
 <akpm@linux-foundation.org>, hannes@cmpxchg.or,
 Borislav Petkov <bp@alien8.de>, Danilo Krummrich <dakr@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, x86@kernel.org, kas@kernel.org,
 Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 "Rafael J. Wysocki" <rafael@kernel.org>, shakeel.butt@linux.dev,
 Johannes Weiner <hannes@cmpxchg.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Mike Rapoport <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org,
 kexec@lists.infradead.org, linux-cxl@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, rmikey@meta.com,
 kernel-team@meta.com, driver-core@lists.linux.dev, riel@surriel.com
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-6-3bc7a57bd503@debian.org>
 <20260915134535.C3FC91F00899@smtp.kernel.org>
 <edafd246-0bd8-4335-9037-77f552968b56@kernel.org>
 <aq1Xr4b7BXZForCe@gmail.com> <aq1eWgGenthqMNd7@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aq1eWgGenthqMNd7@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: coarbbs4igjwfinj41map6ff1w9jfdyc
X-Rspam-User: 
X-Rspamd-Queue-Id: CCE59120006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789761759-493745
X-HE-Meta: U2FsdGVkX1/Wto92MJxbQGxgLe3y5J54AhtQu60BbWHnHP/2N/R0VLpuZ8ALE6Tzxir3JHQA5V5dV4QkSCWV5DsEhgurdP+6yC/ZQIko/01vI9x1En5pVBt4JcTPgxrUn677J4YYf7ChfMXsMK9jaZtQ9KGrkkqrrUAGV+X5ixstNss5XkckhH92pYP3ztQnWjJQKfz2OGwExBMEqvBG0RzJRFBUw62P3vvIt/8/yJ7IeOxXJ0Jcp85nR/BJLohEMVGmdqcorBvRU2TqEJqKr+HTrrDN4hYxdUVy4hr5uKfG4QveEOxnAks9M8/CcZ8dtb39Bu6jxJlszSGJ9349C8U88TxGQMl64pcRZu90PWELHR4X1U9z9ma0dwC/FL1rn9S8dtngISZAF9/dxiKDW1FxUpHaT1JCsJ/gf/ntI5fG01hTrIBCKvt+Bahr6fBMBLLQmP0YxSi6nOiRlsTCz8IeQdBt8u5JvFeZHGcPJJNir/8JZDUzcGMt1PGF1uUKuRmhdabEOOg75LYjhrN3RBSBK7g9Tfc/J1aFydOkzaOGB2BRQt/rrcaRQZWN4Eei599asor9A2jzRaVeFTX0WgEAaaC5SKK/h4NwaJm7AzubDC4kI70msLYgm/OSdEIIT1j49fE6T+tWRSxm3I+JQBbpdYZu/5HhYDyqM2L9Dq/qWtxMsGA1Dzy7M/B0bUREvap6eO9t6Yl3mhJFWaYXk3GQZci43Wl0XIedcM8pG34zWYdwJ+TjVr2EyfMFvm10SW5A7P6fh2kEuUJPCVJ+8etWBKITpArJszcnJPDcgMti68tbiOMHVggxBzwNgpk8WTfr8pY/vCoD2XeNRSKQlBQrAH/yAjP3aikP28sxi9mxHBWnCUreBxpEfG11KP8rn13+Rwd5uI0PH7M+o/LCrUh+n/WiYJfqiy31DDsgC1vQ5VGiFFdwPNtiB2Gjy9+QAlGp1F+YD41MLOlMuQR
 80EOObHW
 ASkO6b5IMh4wqc6VbnxQ1Uw38ngYKheGoZg3Azujlo2+BXTa4iqQ0HEerdAyKCnvNpkm8Z8OWer3FiZmcaxZSQb68hvsI+nSM91jlafd/hkVPhbiAfPkV0dMFpRNqmbqZbmk/gEmFydYRk23TJZV6EvdJRtcCpGHxFZSQSN3CaCoTMawXdYXe10K6sLGUvkK/mrOPG6uwwyVv+4bYJpsFpK+2+IGmaleXGqHcV5mM4bHc5WdfC7sybmFguHO4Vb6MZ5AptkzzkWBPKRlWnomAP6e99vT9zyO6/v3nI/kicQRXkU78lEOxIBdZiLy+dFpP+GVHAcO8OIYSnwx3mSw4E73sCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 17:53, Harry Yoo wrote:
> On Fri, Sep 18, 2026 at 08:27:40AM -0700, Breno Leitao wrote:
>> On Wed, Sep 16, 2026 at 08:44:30AM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> David has reviewed this mail and it annoyed him.
>>
>> Breno is curious what annoyed David here.
> 
> Harry assumed David was annoyed by Sashiko replying with
> every 'LGTM' email :-)

Harry has reviewed David's reply and has understood his intention.

Harry's mail looks great. Breno's mail looks great. Everything looks great.

Happy days, let's write more emails about how great something looks.

-- 
Cheers,

David

