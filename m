Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD63D46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16E7B6B0088; Thu, 15 Jan 2026 12:45:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11CA96B0089; Thu, 15 Jan 2026 12:45:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F176B008A; Thu, 15 Jan 2026 12:45:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E75566B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:45:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FBA7140414
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:45:49 +0000 (UTC)
X-FDA: 84334926018.06.29192E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A6F8C180004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:45:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nYJy6A9T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499147; a=rsa-sha256;
	cv=none;
	b=xYLBKvp5WKK/rwuRJKI9CelR5FdIuwDWisGf4k8NW+j5a3Z0IpjE3TDEPpzHbZcvARBw4e
	PRh29DGjQN0XfU2jkviEeg+m4H/544WWpkjwFsM73AUMEEPo8OrUEifBjbuRtQCMQ7F9WQ
	oklJd+Kw/JkJTrREHhbUU6wdgoDBmZA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nYJy6A9T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6oSYpWu7GGXcDoy1LiPrg0RmKnqdyyX94CIN3T2gqsE=;
	b=1taGYaiTkaNFphwwbbyBtuaorg/NoS7CwnT/aB9KKYJnpWR7M075LA+7gC0FXVj1vDB7G0
	mOPDrpRe7y9bCU7supSa9nL/fqy4hBc9rxLXFZ5NtwBcMbV4AMeMW7hfoS4Q7dPVl18eow
	nsscDE525gq8r441g1uAejtjVzeG1gI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B993E40D70;
	Thu, 15 Jan 2026 17:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A14CC16AAE;
	Thu, 15 Jan 2026 17:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499146;
	bh=NKP/tku6cMDuVGoK2diSQ2fB/LmycsGoKdg789sJ9Os=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nYJy6A9T9kR4JzP3jLbFrMuhD5QSni458tPEJNyZe9FnKgyjHYih4jU0WRXNUw0LH
	 pTfMZriffkXiZFrvSAmt26mME740xZvARzVdizcMhnRc89em6g58j90U8fliJfpYwe
	 tFUU+KlCvMBpPF+bLn4w7s4XRCwgC+B0vm1IyFUZ42QTOICVZNSrT62YkoTsI7DamE
	 HNrdZNKrSI9J3wtjVhk5Cy8AK8PvjrHFv7Gj/IjQYvxCF8FCRMmYqGKlP59yLokCVg
	 2HALZ1mRoGMKbke+ujLSlpAU0HvbyypzJsd/AG/kSOirOW1Lhoj2+gs5groxWjFcit
	 Tz2O0IjV/zg0Q==
Message-ID: <bdf9681f-04a0-42e0-b319-d247b14a7cba@kernel.org>
Date: Thu, 15 Jan 2026 18:45:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3 02/15] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-3-kas@kernel.org>
 <be57dfa5-e6fa-4ce6-93c1-239436ff6e89@kernel.org>
 <bf788cfe-ac2e-4ffc-9349-64d9c36bf072@kernel.org>
 <aWkivSMMKX3AGdMw@thinkstation>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aWkivSMMKX3AGdMw@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A6F8C180004
X-Stat-Signature: 1d8dd4fnz3o16rhmdanytwp4unhr1h7i
X-Rspam-User: 
X-HE-Tag: 1768499147-256820
X-HE-Meta: U2FsdGVkX1+aghgBMGuS9/oBFkEs/IvpllSC+SE3DWOXGEoQEyOzPIpsK4zp80GhjH+gDOVJ03HigVNtUbKpzgdEa3L+9Yxj+uWwwWXR+EMjfUAxxdH9aBDMryy63HjGXdlLjuHwDtnDPhVQBPfEkRfa+r1z/GuX8VvPeKDEfQZj7BzahUlgK8NOI1mEQqg3lrdn8Kt169UsvGLCFmIh9nc2zVt9MX10t270ZLNOU3Gp984ecIYpKFcVkuDcN7ScuCfBLxer6YZ3ZM5yav/4SofpbV8+5E1SGBIkuGUY/qIsIHWj1vEiN0COo1OFiao9EFHDof6xwOordpmllpXS3vOjHp/SpqNpSwOs1sxVIuWP3Ewlo14R/0qp6Zo32KmZdnuD86e5k0KtJ5M6EZRMFzBJxELUC0N/j75x382QqpaNHhN7EKnf+sJxE6QkVSzCHwDxuq1Om6K+QzKt92D11Buk4qTRjdsnBLkJGli6i44ctOuZVW8YErqWAZYfpE23mXauyTkYwE6qQp7Dopyx+q6Wmh0tQqFeJ+oj+7ApiNDQFKxIAxGjdRYMLGQ+06mgVGZ1jd8tHeOcTmWsnLHmE3FXYljeUJO3HF2H0GAe7czvLVmTWipb0Cbiw/yRs28oMh2l0SM6tz2lc4H3geGkGNeN1OqoWEpwXzrEC1rHpUSUp7Y4k5kSVxZTNkn6zFGg81YYYP/4cTRgHNaxHmEuj5sqkaUTk/wyutIVRnqeq5xdspOzO707UgiR5351kAUS43XKeP1tigg6dz/e5qwpktQHPWqCu7IJrflcbYozJ3gJz+6FaFcUNzMyvQ1gKYlVVLoHkyna7YNl1uuHWJ0WugksNcV5dtUFQTklhKVVVaVZhVbT0d4lXUBM73abUMGT/lO5NUJNs6crrWGlOf4GgudL3wRO9k7kILVkK7DoRS+qhIQpy25yPGhwmVWekqvMTqOYxfMI56ES9S/ELaj
 Mr+oefRu
 quhFe8mFuTnxAneXZsoisNu6CMIJbD6HGxwDZPCMMn8Fxs/e8RbTKEqWHbV14nHMCko2m+LmoA8GhIF2mlGBMBiH0fBIweRn3UgH8zNR+c4sGpvXE0hbdoZL7ruOfiyUnlRHf1qLwoxWIdSpba9kqfJl+KhctjllZf5TMyNqTvW1FlzFK2lNBWxiyhDEJfBvQH/IB9O49e/Ak4Ybf3Q4RTetR3q7ARQOicrPWZNj2RG+sS4ki4WOldTTopUciS2SKV0Jtg2kZ0Y/NB94mQSc/EjjXdwHvFOOAjbNEX7gxpbuSmrX/4mNoeIJuCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 18:26, Kiryl Shutsemau wrote:
> On Thu, Jan 15, 2026 at 05:48:20PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/15/26 17:35, David Hildenbrand (Red Hat) wrote:
>>> On 1/15/26 15:45, Kiryl Shutsemau wrote:
>>>> Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.
>>>
>>> Why should that belong to mmzone.h ? Semantically doesn't make sense, no?
>>
>> To clarify, I would have moved it to something more folio-type specific, not
>> something buddy/zone specific.
>>
>> I guess page-flags.h + mm.h are our dumping ground for folio handling. I
>> would have moved it to the former.
> 
> I moved it next to MAX_PAGE_ORDER definition which seemed to be logical.

MAX_PAGE_ORDER is a buddy concept. MAX_FOLIO_ORDER is not a buddy concept.

-- 
Cheers

David

