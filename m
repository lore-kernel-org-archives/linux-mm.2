Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC68CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D57B6B0089; Thu,  2 Apr 2026 03:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A0A6B008C; Thu,  2 Apr 2026 03:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401396B0092; Thu,  2 Apr 2026 03:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6966B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:11:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C802A13B0F8
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:11:56 +0000 (UTC)
X-FDA: 84612746232.13.8EF38DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E0AFB1A0004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:11:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bDNylWvk;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775113915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCN1h4YUjU1TUO2mW+CPO5qtEe7xmaZRXXEUjip4ULc=;
	b=72Xbc2r2wysy+y+giXbUodLw7D8qRxo26pu7FGp7/DjMqRATgTNO4YUGPA6l49uKzk0G10
	E8XdrUxVHMMZVePZrh5labToQ12I0nL0kEw2qnHcVeO1sNs6ugLSyycIX+63oNBiRIliVr
	LFL2MEKe3z7zLjOPqEzUpheFwr5jA/s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775113915; a=rsa-sha256;
	cv=none;
	b=7rqbzPTSFdC0Iv5rcQ5lEawLrHRQFSSA0qK72HB2iH75+0g7aENg0GOOzgWtoqXgGyOg/x
	F3P9JH9uUnPQUjyYeictvPvTZvOhTHAePN3fcIfcuEbEBwQWaQLrqhS0VS1bpiKaWBuAVb
	BK8ss3gU32yvD+r/G1Z9G6KSpWhIong=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bDNylWvk;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 99D4843E2C;
	Thu,  2 Apr 2026 07:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE1FC2BC9E;
	Thu,  2 Apr 2026 07:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775113913;
	bh=U6Ht62+hahfkahDIt0j9cJXLVzKfBCnqoY8D17tKQ9E=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=bDNylWvk9bImq8elUm2p7+peERX/6ZTvIJ6Erqq5VChfrjkak2XQlRj1pIzrtTqyC
	 kw7EK4/BaZNZ/i9LN9JsZN25hSERkzmY1O7YQWAcXqImvkM8Mw33+v7VeqEq272HbS
	 sNKXHRnZTzGg+O3fuCY+rykC/whlNBumtevkU1VfXcCVVRmu08vdRPVLc7S3PeSJ9z
	 wH9FSPsjlzqOUtyCiTWiibN6kz/4iLfJVF+3V5Hi7XLWnzPtUNruVRZvDd5yvwbD/y
	 R3RAuSD0+0oSF4Kci9xbvYkKaF4edDKOJ94RpirkEdvocQathJkWMbhlIQH8n3tUFY
	 KloLrVpSn295w==
Message-ID: <8a5f088a-cdee-4b08-8784-b0805dde1472@kernel.org>
Date: Thu, 2 Apr 2026 09:11:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/mprotect: special-case small folios when
 applying write permissions
To: Andrew Morton <akpm@linux-foundation.org>,
 Pedro Falcato <pfalcato@suse.de>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260324154342.156640-1-pfalcato@suse.de>
 <20260324154342.156640-3-pfalcato@suse.de>
 <fbabc728-a87b-48e2-87dc-68ac21eb02d4@kernel.org>
 <dccxy3i3kaprljloxbyo2u346bu6xwev42cpvt5lfbbli2hbap@6n2rd5mftffh>
 <a7a903bf-10c2-4d2c-872d-9b31fefb5d1f@kernel.org>
 <20260401170931.9e455bbf679792b039d9770a@linux-foundation.org>
 <20260401204420.9e7342b7054a5809b8bdfa40@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260401204420.9e7342b7054a5809b8bdfa40@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: q7xjtrkz8pmorcy677kjx74gk4ke4nf5
X-Rspamd-Queue-Id: E0AFB1A0004
X-Rspam-User: 
X-HE-Tag: 1775113914-642774
X-HE-Meta: U2FsdGVkX19Ba3fmwJz/DA6TN9j4sCVu8pGW2+848DAOajPLRe0xMUQztglu/w1SzfZcXAOt2zGtuypLbUf/HBHrpGs9e4Cd4/9j3wyGKAmNDoXIdVrgndtLmd12KhDJXkdd5jWljzS5O+O7gXx9/XuTAS7vGumduoiNT9X6K50SjsgZi7P6ih/RNy+ZMhyp9aiEkXR5AWXHnIdCvuPpD80D8svmqGvnGnl8NXibf+NpdU21L20Xbtg4sGyjYY63s/nSn+c8oQTTeho+3fZJbcWLd5AX1TYbWMrBgM6IjVxYu8L0e/sofGWki4N1GONO5ZXZvnPBFJFnpLX7C28E2YrKc2+kNxGADoVdZCMuyjvIGb6HEWeAezLQDpW49qT/wUcdBHqF8F83+vOy3av6mIZMXpLfj4f3wbd6lKkr04pgWURSWwyG23Hy0pXU4MC01JaFN52ShmQp1xDUfIWCkgZTFQ3SnDx0ExGRVlPE8jumwJhr3uKIp7z8v8/NcWuSjRmAAPPYq+22drcyiSMluJP5l+gKFqB+ASI1kenhs4V/5kC8ljjNImxGQuhysXXF2xQdeb0N7fV4uS/gbH3aaPX5TFImqoRCl1wsiw0RO2nw9Dor8AfjaTc68DutXD9f59louzVtrPcwT4L/O01zGDd2K2F5Y3OLiQoYKBlD0XSDxUut7u0CTt1ZQpA2+UG0F/yAbP98JyG3YbJAFSXqpoM2eMdkLl7jOsiCFcatQ+orwnYps5esfnd6EFOTltoyjsZSNdny38JCB2W6cV/P6FdSg6AK0VW4D73HezCd94kGnxvPbIJ9bKh6VUFfFk023SMbD+/36xOd+fd6U3b9PVgP+5pIx2fUDq7pPEaCjTbjmrZFAJ/OwNPN2aRxDNRdx45ga+kStHYlJRx72NEhb5acT8m5JP3yzO4vN7yG/X14f2FhuHQBiHfUlZQbYWButOi9Eg1fPFPho1RTYB6
 NfX+0V/u
 yYfJUXMnb0F6BO7dlVshRiO9jJvYWY/mBn8/pto2SfK0oqsCU0TJvwY0xcQuIfyYasX5t6emRtw3kYxrqN0uyDd06nQfBrQyrYOKaJn/lqVonHombHgn/QQe4evHB82n38HmzLjJ5jM5X9MNOdnXAxzug4pJyWUHDPN7EIdaXaFsanv1oOpEOSk0fpOJoqTUntKowSkT5qeDtDl5/gUF5wtB10NLrRiq7zX8c+I3cbLE79t/oKnU+7BZXrQSb2DP2t3zwN/RX8ypOLDxeAup7fE3DLopUe4LaggPYT56hQ4+trvQ57Fv1cdRYv3Mr5Z/2C8CJEnTM0hYl/4uOT06kkr1nXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/2/26 05:44, Andrew Morton wrote:
> On Wed, 1 Apr 2026 17:09:31 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>>> I can easily extending
>>>
>>> 	https://gitlab.com/davidhildenbrand/scratchspace/-/blob/main/pte-mapped-folio-benchmarks.c
>>>
>>> to have an "mprotect" mode. I had that in the past bit discarded it.
>>>
>>> Then, we can easily measure the effect on various folio sizes when
>>> mprotect'ing a larger memory area.
>>>
>>> With order-0 we can then benchmark small folios exclusively.
>>
>> It sounds like this is all possible future work?
>>
>> We have Lorenzo's R-b on this [2/2].  I'm reading this discussion as
>> "upstream both"?
> 
> Sorry, please ignore.  Reading skills.

Maybe writing skills on my end. I think we should do #2 properly.

#1 is good to go.

-- 
Cheers,

David

