Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45401EF4EA4
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D83B6B0088; Mon,  6 Apr 2026 05:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861FA6B0089; Mon,  6 Apr 2026 05:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729C16B008A; Mon,  6 Apr 2026 05:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D2776B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:09:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0617F1A0365
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:09:10 +0000 (UTC)
X-FDA: 84627556860.04.D0C0A17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2AF90100006
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:09:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GGIZDmfj;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775466548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUT07yNXCFl5AYJ7g1Kuy48a2rpGzkOjQj30RFh+Ks0=;
	b=vNb3xL8UE+q/UtGBB6ow+1lA1P3sXA+EIL9JNZtUw5QBWpra4P3mUvswPrI6QYjRvpmIoP
	ckoL0iuYV0MjHnzna8JtMG497c4CCFLE5C4hoQKOqIwR0B/1phsN1b8EVKp6k5F8vcJfAs
	wBbebTMsHndBFSQVl/hukDmY1ht8pug=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GGIZDmfj;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775466548; a=rsa-sha256;
	cv=none;
	b=l/b4mn5WH4SeufimQ6eQKmF8zutz04/Bm6F37y2vXCR9XBOcoHSb6FSesMRO1700Bkb1g0
	uxTmYuLNjINleva2Khg+adb5WZanFFe39eMnY3S4rJgrTtxIYQ9ujjG/GkXtf9ts+CHZ/x
	4AUYZZnGNqNJfRYirZMbK+i3jLt5ju0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5428438B3;
	Mon,  6 Apr 2026 09:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506DAC4CEF7;
	Mon,  6 Apr 2026 09:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775466546;
	bh=kTvQOxi9v0Ao8ynx3e3v1BGRBJ7SdjlvC+iknAxEWKo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GGIZDmfj1hAIxY2nlRJE8ZQeQVIh/HNvLL8JIIWMSTRysvChuc53PgrZB3RI3MQwj
	 r8mP0XZ9JFt3SR/wK7OLkfzvDDEQ7XNY573uCqieb2Qufxt8KlGZdyF1cra6ZN8/lr
	 B7jjGlASyUAShPCu0gf6kyLtVo6SxVBKtXbH2WpWdUk+LbbwvLC4JKj9d8UAc+NpqB
	 4yTMW8HZe9bChLYJ/Qh7Ii9PxGIv9L70u7uID8gIA8gvNlbgK8Z6zwTR5viiWxmikr
	 C4FNUPCC4un9jV/VW3BoQuN8UUH0VxYgiJ5mpLMfEexJh3I4g3EUsQY2IpIGrM7zPb
	 DCjYhkbFoPNXw==
Message-ID: <a3ace37b-b75b-47dd-ad7c-c7c3f799dfdb@kernel.org>
Date: Mon, 6 Apr 2026 11:09:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] mm/mprotect: micro-optimization work
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>,
 Luke Yang <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260402141628.3367596-1-pfalcato@suse.de>
 <20260402113328.fd0a6f0e28cf74a651fa2291@linux-foundation.org>
 <6bl5bzq742c522nmhlshlnf6ho6y6a747l3zh63aagp7kfxymv@s2c6fsuikn4m>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <6bl5bzq742c522nmhlshlnf6ho6y6a747l3zh63aagp7kfxymv@s2c6fsuikn4m>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2AF90100006
X-Stat-Signature: eykn9dqbbcziofa5irgbnis9c1ptt1jw
X-Rspam-User: 
X-HE-Tag: 1775466547-903082
X-HE-Meta: U2FsdGVkX1/83c032s6iLix6yZa/YUI90vOCkCcRsuDxJEh3C/ao0v80HWD3Z6uJ0i3qsqnf1EYa3CNBcv9ev0ObBhEqgIbub0bBylC15GgqMHrVMyyGmNMIlZ3BCwVTySbSgtLpgr2B78DJ3oAgoVCUlWMVHyE3UJeQa/Vy0eIZ6kXadVlsIUvX8F8b6AldrJRACu0N3jwoY6+PKS12pDzd/MhJH+v2/1uRsA7pLVh9kwMvtXP81T99SZNoXwONbUeO6SxFTz1uFrX5p/6dhcg6qa6EOJ2T/QL6JTksygeZ+rrQkLGzcSFGu9KIa3LVIDozx3bOL1kezhwZoqP8B16lNmPaIg0nrh0FVJmqWQnpgYWHzzwXJbw/bzylg0awmu418JHE+PjXXJ9w4JLUyp3nID3IyfDekNbunE0toAtbKbfJoQLKy34XPKSbHkeBWaoDioU59J7kHCGodyUEC7P4Riqdv/n1OQwnCVSERrjlWdP/hRg4qVunq523BU5/G/q7SctBA95F8PftYLH00iy3sAYQp7ZDnaMeh2QsPBlHHfJd9h/TQR5uhWTH5lEaDC7Nb6HAB7KfOxiiiKBsxgwrgecGJN6dQ6USzDeV5/dTGSfGD5X9Dxdg6u9QLnPrujmOvRSltrm3opmTF3Ig0oQjRD3xZBLP9S0M+AhfkNzF0fM5oAa22tiLhUORCosUJsvboHG7rxmmXuMcS7C2S8oQ2NnmsNG0CWRBH25jYT+XEF0EdrhzYCYHsWlOF5l0+vDnNAGLIv0lpo68T/dPymtlWLsvUoHAl5yfbx/Ux89BCjy2H3/JOQ+qIyKeToS5gY72h2cgxBg6Fo/DwAksAO4AwiUkY6nYeaqY8tJBbNxqDekiHTPC9+48BKJmmyq0bqVl+a1d1wJcmy+d/nKWHzLSvAqiJUFjH2A+SWNWjQi50BHTfqgtaNuoNmHOgoFT0HG9iApcPPAsNbWaF9R
 unFE7lea
 IHirOc3I0kPi5LuGaYUge7evrzQtc0/FRyj42wED6J5mhUAWQYqrl4YFIbAvxUcVQxSR8mcjgcfCHeLkpXutgr13N2siPSfNlr0PzWFIerzidfaHQz7Yi/Bug/Lez9SfyUv/Q+7iD9f2l2AB8prAGNZc/Eb66CsRn6rHKO7vxOIeNWgS2E+/9GFHIL+JS9GMo2rqE9xEYHZbI2+IYzv3kQbSvqBs25rwaVrsMwZDyH4xxM/p7fcNiecWwPfKo/Zz4rP4I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/6/26 10:29, Pedro Falcato wrote:
> On Thu, Apr 02, 2026 at 11:33:28AM -0700, Andrew Morton wrote:
>> On Thu,  2 Apr 2026 15:16:26 +0100 Pedro Falcato <pfalcato@suse.de> wrote:
>>
>>> Micro-optimize the change_protection functionality and the
>>> change_pte_range() routine. This set of functions works in an incredibly
>>> tight loop, and even small inefficiencies are incredibly evident when spun
>>> hundreds, thousands or hundreds of thousands of times.
>>
>> Thanks, I updated mm.git's mm-unstable branch to this version.
>>
>> The update is rather large.  If people think it best to spill this work
>> into next -rc1 then please advise.
> 
> I think it's a fairly safe change for 7.1, but I'm biased :) Perhaps others think
> otherwise.

It's mostly code movement, so it should be fine (unless we messed up 
passed parameters somehow :) )

-- 
Cheers,

David

