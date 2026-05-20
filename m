Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFBD2CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 04:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145006B0088; Wed, 20 May 2026 00:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11CA36B008A; Wed, 20 May 2026 00:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059E86B008C; Wed, 20 May 2026 00:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED6416B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 00:32:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0F691A0111
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:32:34 +0000 (UTC)
X-FDA: 84786527028.04.2B43312
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id BA9C34000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:32:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="aFpgww/L";
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779251552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJIEgWFvtgnHzamy+13H/bKQraSIMZQk01jyR9OjcIY=;
	b=0G7SDDCQ1eBb3linKH0foHuQUkOCcUpeX8Ld357L5lq3WJy0PrtlyyiY0JKRKH4bsU3CM2
	r1Hs0pLlNwtTlQwK4XjawQ/ZyycyjmAyuuCbYb5k38j7pKHXBKrSd4D1jpOBpuzSx6/VNk
	7AelxvVICpxZ6Y2uht3puiIQn6hh5no=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="aFpgww/L";
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779251552; a=rsa-sha256;
	cv=none;
	b=hlkcPBtYMOP/Oavjat5SR0UBi86ZzRFZV8Y36zxGg8hiMeUMvPQB389wqiAcvLliNqtlva
	OwQ/ienj2U2xRuoHbMkn3J/uPyXyp84cAMjNbIgyBC+hD259n+BCZ2Bd6WYMxgI8l45cF5
	4dcmfHc4dorzfXxIhais+V3S987DRnI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A538815A1;
	Tue, 19 May 2026 21:32:26 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50CAE3F85F;
	Tue, 19 May 2026 21:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779251551; bh=uK8/vpqcmE/MoIIzLPGgkI5PWGz3hNqG9Y+RY4UbO8E=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=aFpgww/Lz0nJH9vrNo4YXwGE4j65EOqHYsycy2EMXUZ+5Wz9oFwlfZkKujrRWQKRv
	 y2dNkcQzNeOkKfyO28Kcqz+wPyhypQfLGzMuLp3Pb9/gMUKKDZ5M5woPUmLlCXMpJN
	 97ZMwvLLVIKtZYj+wYOaVoHxCjHz0oDrUHQjMRbU=
Message-ID: <ff420a85-903e-4db7-a1f0-218b4b1d0f14@arm.com>
Date: Wed, 20 May 2026 10:02:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] kasan: avoid re-poisoning tag-based kmalloc redzones
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org, vbabka@kernel.org, harry@kernel.org,
 ryabinin.a.a@gmail.com
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, kasan-dev@googlegroups.com,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, catalin.marinas@arm.com
References: <20260513105734.3380544-1-dev.jain@arm.com>
 <20260513105734.3380544-3-dev.jain@arm.com>
 <14da7ffe-1332-45d0-86d6-e9d9ae0a4fe0@arm.com>
Content-Language: en-US
In-Reply-To: <14da7ffe-1332-45d0-86d6-e9d9ae0a4fe0@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BA9C34000E
X-Rspamd-Server: rspam06
X-Stat-Signature: ndmizf7oub88gx6ja4gaye3txu539wm4
X-HE-Tag: 1779251552-694912
X-HE-Meta: U2FsdGVkX18tWG6Z7uUXEKo3hqHGuRmhOvSu3JZvO4MgJl3p7eI7pfC7nRSkMBQPy7Iv7fGT6IrICOhv+eVYOa7siSFcRGMlgqy2wG9GAFbQQ7G90cNvh+Ggf70CF/iN15XSswu61++9CLldlg1vio0nI9BXDaLqXQVrmUoJGzR6CJogjJ66cd/zb2y3j99DiCs00Oyi40lCLmn/oiuZ4iBKWuWXvKUrJk8icdpvqZhQxatxXfeDLS9gXoJWkZ9aECKMsZoZE6Ik82ZDu+/Xz+FxHb4hfyPNi9uzcgaISc6I7oJs2kmMY3OzPNJYdwM+l+AHqvLX336p8n+xHRE7o0d+bVNWtFBdojmOA8KnDJMfXsYSJ4XJd4EgjY/n0yRgmmBEv/TUif7QWfMd0Jy08jlOhDu3599xNjzv0DRf2SwlasWzntKUYy4X9r3TlH/Fs0FLwVMfBNTduqPbq5M8QAQGqE/UtB5Rdscq7G3lDmNV/PGMBsvSIA7H3ohJXmWAZYIKar/N/90LsCGJt4IL9aTguiH21u+ctQBW2u0tNG05923t50AMlwBM9ZYw6sFSqTYtHnx+Fu7tA5siywbmrZBo5htafLVEnXOoJeSXNc1fmsW3BSbNkRF/2viPTocNSzfJMLW0od8+UUmjISjXlN2xzeKqvbenjHolU/1B+uNipILLWN1Es1/7sMmjNCmE3u/G8heiNQpv9CPYxbZI/6onto4INgnJRtyqdmgAB004oG8b1LRyeetpu4pqIyut8n0KTSTNSJadg26R3C+q4cUM4xB6ehd8c5TiiX+tLyaoFeFIQIkv2FgdrTih5ZbwMRGeCTql5SyvYT/zCM7fmDqUTlpJrbwNLvnnJairW7Z5XVLu5pSGokpTPZRc/QN2J72fq5N2LoQuIuyIFEgASHTjZxTx2eHpsf9ospGGIR9KqvKUMlnl8Tc6OA+ksKbJY45phocksna29KIMj7k
 ojL+mzoS
 DM9ccsKMzQhadzPfioM2Gori1L8w7j5cCI1wo0mpgXW1gKk+Xxd7LZjMHq55zsJobAR6MCco1/RusrriUWZQxuE/l/XtAB5qxxfGomf6Z+2eZfjvATCvZF2doI/6Fa8KYTvjGhMPle7BL/8JZektN4aBsWHLB3ce9XiYu7hufAI93xJcAdjQnBMRjgcXgWiS6VLVgGYIvGVX7riMFCitRnJFkkRKqvhj962+KjPLrZeeIAo1ggxHmd//nvIC3wnd7AdvLh5JcCkbHcgtf0deidTxbtI+gtc1l8C30Pc//V7CW76MPcZqk4yfdKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> Problem 1:
> 
> p = kzalloc(96, GFP_KERNEL);                 // kmalloc-128
> p = krealloc(p, 120, GFP_KERNEL | __GFP_ZERO);
> 
> Before my patch, kzalloc zeroed bytes 0..127, krealloc exposes bytes 96..119
> which are already zero from kzalloc.
> 
> After my patch, kzalloc zeroes only 0..95, krealloc may think old
> size is 128, so it does not zero 96..119, 96..119 may contain stale data.
> 
> Why is this a problem? Surely caller of krealloc shouldn't be
> relying on a previous zeroing. krealloc documentation explicitly says that
> GFP_ZERO is ignored.


My bad for looking at a very old tree :( the documentation in the upstream
kernel does not say that.

