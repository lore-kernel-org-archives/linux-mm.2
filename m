Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E600DCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025286B008C; Mon, 28 Sep 2026 15:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F086B0092; Mon, 28 Sep 2026 15:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E570D6B0093; Mon, 28 Sep 2026 15:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE3D46B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:12:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5987BA6647
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:12:37 +0000 (UTC)
X-FDA: 85264117554.21.F6D0B8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A2B7EC0006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:12:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HF4S1Z78;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790622755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+/0gNUnAEU8rNmsasP2G1qveGjqqxqRYFGhYDQK2wU=;
	b=DSwmML5aAn15HOWsNgvsIK/yQuafQURSV+NIfjoI1GAKWKrMubL5OPpzWV+xHzmYECw6L6
	JvGh2HDg2ZZ16JiYX6cW0hJDJAk3WKRxatkvLSQ7eNBtovL7ApD37wq0RjlcZvO3Nb5BvG
	zYEiUu2KBUbLi8vIyY++8AJ2wW7QON8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790622755;
	b=4E53t11a4Fh5o65ipldkQHg1Edfzvwu6FlhZo92o0LCEhmTTqqmiVrfFVPMyI8UPJ1aB3e
	nlPqZo2GFccE1/B23+BXXKho20WPRcIzc11npLT2UW9OYLHMw/GvxheK3LlUDL+TaLdrqu
	uV+Kz5TMR45TpqldWNuuUhB2ndszLbI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HF4S1Z78;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 363EB600D1;
	Mon, 28 Sep 2026 19:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342441F000FF;
	Mon, 28 Sep 2026 19:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790622754;
	bh=3+/0gNUnAEU8rNmsasP2G1qveGjqqxqRYFGhYDQK2wU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HF4S1Z78mScB4lUcYE6JWgmNHRRxIQxkpRj14G/OgV77GYc4NE9XRSxU/WrA7/o8T
	 jHkuFt25YUOT+mG7iVW/hfP8bxMYMWq+WXAe+owB06S0SeE7wPQfrkwVXLE/DAcWtM
	 ARw16ifk79EF7PM9ra6qxCAQxqKbrhfgbt8qls/bYL6rB77cjM4/+zlUULjLLBP+6h
	 LFlEEaVZ0FA6vtFPLORpsHWqiw8cLu9tB3uLGAvnMpvEPc5eo9P2DMndfHhT7A5ikY
	 TB/6cHvErfozrqwxtPPtJqT7/S6cCELTRktjxG3EPzSnTXaoCjxGwaMJKZBMkp8Q/E
	 RSAYk6NBbI7bw==
Message-ID: <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org>
Date: Mon, 28 Sep 2026 21:12:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file
 mappings
To: =?UTF-8?B?5aSp54u8?= <rockeet@gmail.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
 <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org>
 <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A2B7EC0006
X-Stat-Signature: 4i8iteg5pkrj1ozgguioc5ydt94sg9ot
X-Rspam-User: 
X-HE-Tag: 1790622755-226653
X-HE-Meta: U2FsdGVkX19qmkRV1wJC/9eC8PbEmIJq81OX6BtZtbLV/JPGjb8Vp5ZaEe2S96FV4kqKRCAJLMQMDWcc+6panu4bq5recUaRqX/EpdFKaKBPXPn4Fy21GjU+lsyPYgEdPU+IELM+Zi+pg5sHHzgQvoBgjn4HJop9qwxpkdsoYmsGm+jSK7B/IvhXkcxX80iBhnY6b+VjBeqp2YFkM3vvfYhKqXzgC01FTI1wF6SCNtnddUkn20HDQJoLdJeYdKHAglH3jAcqgIpa6TopNbIaHNw4TbexGKjI6utH+p/9F8A/lchpyXxW5iGt63LPdzNaiiB85ohGCxvpI8Ooi9agSi7SiR2Tk3QrdOMaw9aaPCGy7f943ve3HYqZNuwA6iPtZ5tHi5R3CmqlW/VV5tM8863Oej799J7nRhoOGbkKoMOSMqOHqkdTs/Sp9eE2P8TQlP3af26h3jiPc783IS7sRmwFXoIv2O13YoRWkbC1SLgYiL8lZRCNHWVAeU6t1iTebkh3O01kgKkIy1cPSp1CP7ukaiV842aBX5LQweKsZPanD8gKmrwy7pYcwSNEwlVanhTl9AWgV5k7/uPQL4WltThlYKCLPcgkCIfPv9mjA2w4DbaX7o1bYDryKkf1+599ez8ZeouMXGCl5n8/r25zb4qpwHd1Wos1xxvtmUeOnVma0KdUn6sCiDXXKoIkw3Qkm7zxBaho1lXEadhfVi94xibq7jzrpMijNSM3TeQK94Z/BujgP3SBvLfqtJjDZsqkF49SiGtIM/NiXi/DX6oc53iCbL7i/JkLErqlP1lxe2pV0yaRdxl6h+JGOViqvdSfCD2UraLdY/rzg1qVrZasn1CxYTtTmhXC0v8rAXWa9N5YS0v2gun065+WgoqDzdMRlNMw043j9ihU3at3PZ0mK7/LFtjBvPJsi8XArFva4wLSQMh+dmD0ZT7JMgILvGbkjM0V/a/FTMy29F/dSlW
 FGhu5J7G
 eLnViZTSXrDAUJWNdNFl+UJVK1HTkWHbyaO+0x106h8eITnQjOfeFcvPohLE/vR2O/+uqbjuj11aYszK9OqYYXa5qpv4JJSxP30tBQJ5l4VeHVvf672xM0Ww90Mulr5NfWs92K/uD9nnCuUb9j2UqoYW+jO1ZRt3GyLkzsnmzrYn7VmbklD0z+hqJw3hYTr3EMQ0EzrVzsm4VdIW3bWVPu5pWH5rBd4jRe9e1tyYu22QizapXokc/0928wTZA7iuRAuvfZX7068RvHD2bJqkaQpGDew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 15:09, 天狼 wrote:
> Hi David,

Hi,

> 
> The use case is a concurrent, lock-free, relocatable data structure that
> uses offsets rather than absolute pointers. It implements copy-on-write
> at the data-structure level and is designed to remain recoverable after
> a process crash. We therefore build it directly in a file-backed
> MAP_SHARED mapping, so its state is not lost when the constructing
> process exits unexpectedly.

What is supposed to happen if the process crashes when updating the MAP_SHARED
region halfway through?

It would be helpful if the use case + data structure would be explained in a
bit more detail.

> 
> Building it in anonymous memory and calling write() only after
> construction would lose that state if the process crashed before the
> write. It would also require copying the entire structure into the
> file's page cache.

Yes. Unless to would try to bypass the page cache of course (if possible for
your use case).

> 
> During construction, writes are scattered throughout the mapping,
> dirtying pages rapidly and repeatedly redirtying pages that may already
> have been written back. The goal is to reduce writeback of these
> intermediate states while retaining the same page-cache pages for
> subsequent readers.

What exactly is the poblem with writeback here? Unnecessary I/O? Is writeback
the problem or actual reclaim after writeback?

(I recall that in a fuse server you can in theory delay the writeback request.
So maybe you could get something going by serving your file through fuse and
enlightening the fuse server about it. Just a random idea.)

> 
> The hint would remain strictly best-effort: memory pressure and explicit
> synchronization could override it. By "process crash," I mean termination
> of the process while the kernel remains running; recovery after a system
> crash or power loss is a separate durability concern.
> 
> Regarding the interface, madvise was only a suggestion. A file-level
> advisory interface would also work for this use case: deferring background
> writeback for the entire file, rather than individual mapped ranges, is
> acceptable.

So fadvise would be an option. However, this "defer mode" is really odd. It
sounds more like you would want to have a custom policy there, instead of
hardcoding something that really not a lot might want. Hmmm

-- 
Cheers,

David

