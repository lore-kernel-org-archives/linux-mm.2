Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A861E81BD3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 16:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 614926B008A; Mon,  9 Feb 2026 11:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC9D6B0092; Mon,  9 Feb 2026 11:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D86D6B0093; Mon,  9 Feb 2026 11:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4926B008A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:03:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B38F41A0232
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:03:27 +0000 (UTC)
X-FDA: 84425388054.12.2ECDC11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E541D140015
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:03:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kBVLE9Fk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770653005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XG3CvkYT+9G6qiMbq+JgmSAm0RLQNMtp8qo7HfMRmyE=;
	b=G2k/dbcVJTyQ2yWHPWNr+B2LXHzewZd+qam3hWL8B15OFo3TOWeVrtEcs4xXx9U+xLgJzW
	bRZjDcfefMa3rk4P0NKzxw8W6ae13iMIzbZtuogigg67dOfHLzDW+ZyYgzjdB043gq/dE8
	uYwKuN25vwHUYvChxvHAJTLn7ncOFUg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770653005; a=rsa-sha256;
	cv=none;
	b=K+brOfaB0xYTEOOL2rhxcaGigGMKwgjWNPquXe2FnGFWNkzJKoHrNgrG9Py/dhblJBskri
	xH4BuJY4jeeCvEDXplfV1mnjS18aNdH+yO0CikGuy4K1ygjAdjnqMug/vBEiCAvQvbHn2w
	gybWkOES10Cw4t1L3Hx0O+UZLXsDgLQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kBVLE9Fk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 009CB60008;
	Mon,  9 Feb 2026 16:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7DBC116C6;
	Mon,  9 Feb 2026 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770653004;
	bh=601ehsz0i2YcBgU5cTr6tPAeMf3hJYVCR7H0vpI2uTg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kBVLE9FkkIIsMKOtrxXdEEiwCXevF/PIaAObW4zLdjVaHFPLE/BIIsvU3Hv+I/5Pg
	 UCfvU89rsD7fvrcuAkPqbq/+o/inP9vjfg/9MK6jbBUmcCha6w0DH9xZO2l9apPzR9
	 FDVxl8y4Kl4nNfmdfWCkKxBT7YS0+KG92suqdm9P/8NwG78tVr7HpAzrSY1y8MPQ8S
	 vBmYqVpcdgYMAUAWV3WNS3P4Rp22pf/lyeLPFoSlGN8wXWXivLjwtw6JW8JavmC1w+
	 9ttMFU9r29etOP5oQYQ84CZLfkvpc3D9Wt9atddMTCqacDFAj8ItSJYT4yMOxz263r
	 NfAlawwuc9L6g==
Message-ID: <42b977d1-4873-4b3e-9107-7055836cde11@kernel.org>
Date: Mon, 9 Feb 2026 17:03:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
To: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <51f96b31-fb59-4cda-9d33-e3cebc45686b@kernel.org>
 <a38fb457-c0e8-4089-a31a-ac59d06a796f@suse.cz>
 <c0b93b3f-bc4f-42f6-8287-72d015a0a79b@kernel.org>
 <FD637A2F-909C-4039-BEE2-B60F85FEC7E8@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <FD637A2F-909C-4039-BEE2-B60F85FEC7E8@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E541D140015
X-Stat-Signature: acizf3cc5cjyo7o6rqh3ofmmio1yuqxw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770653005-520982
X-HE-Meta: U2FsdGVkX181GWM/XPRwMXOKxf7AECgL+fjA3rwFK4QgI97yvHq3QNYdHrro4WiAyisZDxGA1/e+WuQdQQjHTnBetGjw7JAdYc8WdKgoQqlqlRs3m/gQzZ4yFTtK4a3uAH6Y0r+doODVkGGGLHJfZi1GFHntj6lsSxbG1miKwsJ5E5aY7BIKCmKhowtTM1b5QFnj8m/QwSAQWoyJVHtL5hrv49brFx0TGr1fSQwrgtk2eJBSI0k7RsDztHsKI5TiXTtBK5ONXheLrmLwbOawpHP+JS4GR8xML7/YjV279iWx1r03bACDFRQ0dRzNDGOAF5XMReX5gI69fqdMmQq4slCW38sTlQVQv5LjZw6ALzCLyir0lRwrmj2JaC9KJIcM9m88teIA7zmaI239d293p67bBd8wtvGSwohdKBk7B/s5jA1BnjOk6LmiPEgR5BCZZ8Dji4FekKqpnHXGtvwrRPi+xK9tYyfQqiIX5ToRnaW7SlqH64w68HoWC/arsAcmnFNTkWQSvW8P4nXuHrSDxcE6+UtYtzHTiN8KM7dsHe48AQhERBL0Ug/hvowZlwSILOlT/HfmFkPpHJcY7wnaN3W/ocnBM4wBaMQs2EA7BOZyAeg21mgu5IfluJkeoLg9g3aZpCfOkf/To8aWPvLRi+wB2Mavx1ACKbVtEIlhd9CcK3wtvcrDEyWXujjpvbdJv0gCWz03C0yEH+l17to6vWarpIkVtUIP8+RC2J8FEH9rGus3/OTa8WzMOMoGNjpQ+tX+yxy3CAjzy4FswjZfabYRJbLbzQOkY/WGsiMpK8IaDyor1/MU9Uwilrxp9Pb6eKETcPn0BTPCbZjrMMOpvQHIKDJh2q9UZ+ML5A6Ui6T4jOP+Qo0mQ1o+a7CNdwsBsvhEzhMG0qxJqBbtFTDVVUJZgUdM0NFCv78ZW7AdrxQzkuQhANHpBhg4Yl6Z5OEz7iq7b0xC7FRr20lkbhn
 5CKXktEO
 hSAw7oO0RdVL/EFx8LIW7oLkmoUykZORtEo2DeXQlnLhmPh7WX7THzYPEfrJCNy9PWQuomDJNcePh6KkmqtKJMKhGjWl5A0f9syCK/NzhwbQZBGQdFXApaapi9vFA/hpLKYZhMQhb4wbJPBeuOp3c/HcLJI7356jynNOWxSobpX2kLYCmaqIOPvrA4W7m6WLQSzxs7iyCSmhS2hC1lMCLZn5NwAw4HgvbsRlqsu1DN2ZiPdSaVAf3neLUNc35MrAQpdEyRlpOtdT2+eD0oIw4i6Vt1Aj5tcgbU7xvCNzDm/uzBFAJw6aIFzV9AYVAphlpOmJSMoY/kXuE9DtlV0gbcraFGiYe0lOFQRhh4A5HEsw5Yd5b0CUbluhDG35AVlUNSOS1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 17:00, Zi Yan wrote:
> On 9 Feb 2026, at 10:46, David Hildenbrand (Arm) wrote:
> 
>> On 2/9/26 12:17, Vlastimil Babka wrote:
>>>
>>> If the rule is now that when upon freeing in free_pages_prepare() we clear
>>> private in the head page and not tail pages (where we expect the owner of
>>> the page to do it), maybe that check for tail pages should be done in the
>>> is_check_pages_enabled() part of free_pages_prepare().
>>>
>>> Or should the check be also in the split path because somebody can set a
>>> tail private between allocation and split? (and not just inherit it from a
>>> previous allocation that didn't clear it?).
>>
>> We ran into that check in the past, when folio->X overlayed page->private in a tail, and would actually have to be zeroed out.
> 
> Currently, _mm_id (_mm_ids) overlaps with page->private. At split time,
> it should be MM_ID_DUMMY (0), so page->private should be 0 all time.

Yes, it's designed like that; because that check here caught it during 
development :)

> 
>>
>> So it should be part of this splitting code I think.
> 
> It is still better to have the check and fix in place. Why do we want to
> skip device private folio?

I don't understand the question, can you elaborate?

I asked Balbir why the check was dropped in the first place.

-- 
Cheers,

David

