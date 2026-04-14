Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 299D1F9D0E8
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0FE6B0088; Tue, 14 Apr 2026 13:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662056B0089; Tue, 14 Apr 2026 13:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577AD6B0092; Tue, 14 Apr 2026 13:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48CDC6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:38:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDB52E06AB
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:38:22 +0000 (UTC)
X-FDA: 84657870444.21.E9521C6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8782F180005
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:38:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=A9nIZdW1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776188301; a=rsa-sha256;
	cv=none;
	b=rp8tMAxjoCHrMEo8azlIuREX9EYrPUecvKsuOfbpq9h4LynEULfxIjMfFf+sK9VilfKtLC
	nZZ4/AYboAbPd6Z7nUD/DK9PfFCEGECVKcFfOSB1inMXZ4B3Hu3k5EchcKo9KGI8NaON8b
	Kyz3xgrKSREZLoIdn4h7FgKWm7mU5D8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=A9nIZdW1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776188301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/J3zUOAklaUiPzrVFhNqCwOL13lCLa+Ofl5oUQRx/U=;
	b=xzDtbriTyVxGesb5JrzzBj7Wk731V6m3x7ayCKF2nOSVaZjghd0a1WkVQXUSm4G0qUi++l
	E7G6stjQOzprNUKcbysQLefZtvxbkIkSeFr9w3ZgKIqNjP0hDkd63icnJV2oy4cFOHnnsx
	7nMK8Wj/XKnsTqe+njOpeR3pLfMDd+Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D76125E0;
	Tue, 14 Apr 2026 10:38:13 -0700 (PDT)
Received: from [10.57.33.35] (unknown [10.57.33.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 017FC3F641;
	Tue, 14 Apr 2026 10:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776188299; bh=LuhkQ/zv/OtvVCg3FzLN+SqhZeScV2Hzlr/g41O5F2I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A9nIZdW1PiOaBm9npx6eosy3cJwTTO9WMk80QCCJdMFI37tgu7+eEUusEWBJ8DuiX
	 0OA9eo6hscO+Lb5nKIkXqEtAokwo8VgY3OsiH4y0IxTeOb31din/AMaCbjFOKYEcD8
	 Go6mFNzgpnA519rMBd9CmQkN9yd0gtPFW1bRhXok=
Message-ID: <d5a39861-0f5f-4aee-84e3-f4d956f83461@arm.com>
Date: Tue, 14 Apr 2026 19:38:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm: make lazy MMU mode context-aware
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774420056.git.agordeev@linux.ibm.com>
 <de89fd353a8dcd5e3bef4d91e9b6682d132ed9a0.1774420057.git.agordeev@linux.ibm.com>
 <44dd86c0-1845-4dd9-b4b4-2cef6d1c6357@kernel.org>
 <e096e88b-f1fe-44a1-bfa6-451eef028203-agordeev@linux.ibm.com>
 <665a19a0-47c2-404c-bd2b-482ab51b8f64@kernel.org>
 <896b3d93-8e60-42e2-b8bb-d3d4e8c99927-agordeev@linux.ibm.com>
 <534ed892-a6ab-454e-831b-e207930c35cc@kernel.org>
 <584f0f88-aef9-4a70-b0bb-abc797f741ed-agordeev@linux.ibm.com>
 <17505ac4-c5e5-4046-b362-830369b8d401@arm.com>
 <384c5b93-7939-4a9e-9298-66397cc6fa28-agordeev@linux.ibm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <384c5b93-7939-4a9e-9298-66397cc6fa28-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8782F180005
X-Stat-Signature: moip15uo797mm5qrb9tmn8fn5sq13ad5
X-HE-Tag: 1776188300-835876
X-HE-Meta: U2FsdGVkX1/WNxjHINX4Ay9KuOH/WU8Turmzw0WTyaRladmplvFfiAej5qBykxfaN89ONsep23sf5fa9++Zf0Zx2Qviimb++RMbYD0m9XuBSDbIORx5e4JImdxRVac/fQlugHurDU8NZk1+pByu83DzAlGnxb8o9styzHp0rCRD+ib6HC86vK9G8W1Q2kqTP5LmmPll4s/jW2nVjKOjTizQ6wU2WO7uBT54lqYMeVjTdZgbBUOc1p58pOqfIfHdGymsQWXL9iC6L2ov0cJ1xo2iD5Ud6qoevx1EuTcDa/MM+ow8jezS5GtLlrTthErQI9JmBct7jncGPv5uUW3GQGPljWTb8mtruuh+cvFoHIHOMZ/RlLizafH4aVSJvlVEjI16L+gcj7LrQNtESnotlsN5GfREOcrnin4bW7cg0IQweV2EUg4k+VaLGhYImJA39m7TF3hEm0rAP29yUdelGUrLZsWsjcJGckyityiJ8PmCQKtCOCsYbLZgZd18FK7v6mI9gSpr0XdjgPYTOR4wW5UyQnhpsEEhRB8QeZovWCVkbuvhhRPgQoTCFCcyNuWYHBpFwMrfdym89CgwYF3oD5vzSbSg3ryhuZ5/gD7XjXzz4sio+7Bp9+0oe0mGqAOl6/cFoc6zN2A+bXctJPxSaqGQORsxc6yDh4KU9nBmrDWFSEOS7ar6SwXjPjv0Uz1PEZsdMckKCzQJFWiWk3z6U5vFsvgxpjNiZivh4ZlSJx+ipAua0KQ1hGLST69tJzzOqJ9ekxpPJZdA+UV3Q0kwt7aYCazekg8G4Ws3TjGVCA9HUaKV38PPUNwq1r+V/f9qgolLVWRNN2Q8q38bxq5WgeqYViqFl1G3Lzk0D+wTkSQL57YfqQFmARKliRBFxqV1bN/cqeATksd6ii2RoLJnctkoJxE3PU5UY8PT4mhpJpk9qWj+rgoEwB1otOc6pQ1BQkyfLbjqRwjXbu1DIeeD
 Pt7jbWvP
 ArqkmenmlWCxoWxzl7hQyJLTYoZlHIgkUnumz9d8uyUqAioB1czWNjAivDosSPvRDDwhwapu3i7sEkpf+mDah7z+6FfZC2BE47V+imG3vv22SwR8AB/y9UVq1VQxjU/BU38On2sKS7cZGO8qBDAKTSMP8Ul7ECb5g16cpE6VQryDv912AuZ0S7Iq52BuwF0+9Zk3c9uSM7QkhzgE29ICMuXE/7AZ2faDqwLw84ertTz7xVqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/04/2026 18:08, Alexander Gordeev wrote:
> On Tue, Apr 14, 2026 at 04:30:10PM +0200, Kevin Brodsky wrote:
>>>  * @mm: Address space the ptes represent.
>> Not sure that makes sense, maybe something like "Address space the PTEs
>> belong to"?
>>
>>>  * @addr: Address of the first pte.
>> Isn't it the address of the underlying memory rather?
> Will update both and also the clear_not_present_full_ptes()
> comment, where I copied it from.

Oh I hadn't realised those comments came from there, that would be nice,
thanks. A better reference might be a function like clear_ptes(), which
was probably the inspiration for clear_not_present_full_ptes() (but
wording adjustments were needed for the latter since the PTEs don't
point to any memory).

- Kevin

