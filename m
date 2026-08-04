Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F30C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 22:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483EF6B008A; Tue,  4 Aug 2026 18:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45B976B0092; Tue,  4 Aug 2026 18:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3724F6B0093; Tue,  4 Aug 2026 18:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4F86B008A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:01:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9219B4023C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:01:32 +0000 (UTC)
X-FDA: 85064959224.19.ED041C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D57F716000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:01:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kAjw7zJu;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785880890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUuLD8pBXpxetyWSDP6sLwCx7hfJucK9OdsS4BwclOA=;
	b=JemFTihMq2GGMeHbyK39sObZOmYuXEc0caDOT5M9h+XcFOHnYfmfdhz0OP9idUWlPy3vfE
	VtHnITCrk7pVuJ+oPY6SVhblsb7oYQaSvEtzd7MIyoMlTDJQ/jLrAElhY6X+OQdzxh+gXC
	5fmQwJD60cbLvkDK8yU43jFmpB6iTsE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785880890;
	b=ErDX+kB7jRgalU3A8V1g/kWyhriPPtrqD0qfTUhRQap+9citvty+NAMSzRRNTw9gfkGeRx
	ogi2XMkhOpDsKXOPQWMC3gTRXwBoTiN/3ukid611k0cP5r5t3Exb2mwGOe5FutT6cjVH8X
	EeYpRn6wDw+BOPuB/2KSbsCvdpiUNUk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kAjw7zJu;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F8D6600AA;
	Tue,  4 Aug 2026 22:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1001F000E9;
	Tue,  4 Aug 2026 22:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785880890;
	bh=wUuLD8pBXpxetyWSDP6sLwCx7hfJucK9OdsS4BwclOA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kAjw7zJu6exQmrGC2lB1KRNaAMyyXdP5zNcwwsxzJN3yYvdjwq2FQPEGrwoGc/uQ9
	 EEoYiJT6sfuDPBk9VFp23uX7QZSc5r/PJQdHmzNH+2rc0ZHooSkpNqCngF4SLCdJtY
	 ORAGz3f0eo12Gy+YG5MyyeyOiGS31NAvx1g97a5fvhtAytRAtMzvLPEk3xLNlxKemq
	 yEmvF6eNsopNkIsuo+EIREPNBC/n1Z7/lNVlkGCreiXSCLC8OtQoqS9oyyRpdlOS/8
	 4+GXN3PvOjEIpycgoZO8M2neVs2cc68J8FZBIEz6Tg8+VzHDpxOx/5JkHxnMQnrUGY
	 JAQpxBe2spC+Q==
Message-ID: <44a20360-c791-491d-bd84-e161b7c6a9f0@kernel.org>
Date: Wed, 5 Aug 2026 00:01:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Mark Rutland <mark.rutland@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
 Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org,
 urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>
References: <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
 <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
 <CAHk-=whjfRaeYsAVS9VfYO5uaSB43sT7zPOmNWR6gC8h=t60=g@mail.gmail.com>
 <anIhSGs70TTzymHM@lucifer> <8d6119c7-2216-fcdd-d0b9-cc60ccc8caf3@gentwo.org>
 <4baf6edb-c84b-4da9-b905-4d40d4bf5fdc@kernel.org>
 <7f2b2030-b912-70ee-5019-02dad2e87ca6@gentwo.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7f2b2030-b912-70ee-5019-02dad2e87ca6@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D57F716000B
X-Stat-Signature: jbxt3cx5f6tzbirfa1twezp7fts8qdxb
X-Rspam-User: 
X-HE-Tag: 1785880890-897244
X-HE-Meta: U2FsdGVkX19yHshUWpY2mUuKhEwPVbz6lpwDY8oV3ap8zLkXRpV7Y9NaM/zg7SFixc9BHwCYIUOSYzBaMMbUEXJrayN65BIwq/p/biKSahyo2LqRcMPN8yrYX1hRy3R4kVjehWFCNn8AX6kQpXVqBlJqOj+U2NVBgHd2bJy+UfF8V+wU8LCiqreZc0IO3Dw/G5UjwajbUad84T7yVmo1uXjRvAnolbCxq3xTmQggqsaZkWxWor7TTwiU4exK4nbqR91uwA91Z/B8DLRtKqvEqygADlBjZBL22pZBwRFztOzzFXIhgAplEKrGqGaxqyuM2iD080mjt3H6AQBK+eKfUL7ShKBfkF+wYXtC502ZmdYTUftN/0pbhGOCPb/UVAN4/ibciNHrgtUTbq377r8GlrPk7//8K1hZUvcvjtkglqJia++0KEkdskjC+uKRcD4FqH8V419r6YIOrBkBnu7f7kMpTyT5zmfkxMFtgySLJgl0AgA1Wm97akRK1b0ReNRlfw7t7ZgPKB1CvI+M9cRBdIQpZPNaqnYD1Kpjtuec3ZYav0ZTb0QUlwxCKfamFj2MHUA4tHmV1bBluyCQp3mlaiIE+DR6LA8RBOudMMAfZv+bMBEKcE8VDMoWbyhR9Cey4nDQiEdTMr1F8/S6GkPVznX3LmX68uSeXspvzdLJJF0RcYTH+Xpbyin3DP5iZn7g7SI3IPWE7aNpfH+g7tpic+SxB73RQXtHDPEsXycL6IWPKHBBm6P0COj1P+cJtk34fNahavgPrOULWqob4JixUngN2Jw3D5GM3W7gQ8cf1KsQ4c3zxL/t6ytQKE1tZHgceAZH4GUPG2JokuA9k3G3KfYPxDW3fhBLJswb2o6/itStRkRihPRyHinj3o6zpXZtSaRj5tsegGMD2sR4khHZQcj+850rFQ8ZhOvJUPSTKTiYSL89xRDQwXMKL1l5PtvbY2xS62QKOFtztdMWSwh
 j4BWRsaw
 wzlM9IjzRnCouEfNUcpn9CoZTEdVeMHS3tjwkayZUgXh+0ZmuxfREYKd0YEjNJNXf30p7yC1khPdO4RpTVi7tKnaC4xSGuUirlIMvAw2QEiQviPIROBD2ZiF1LVUPs+ebfjVGcpWXnaDydsjcXrMU/ENB4b1XxK6VgAdMV2UMhIBS/TQH7SDEWqTFXxqpbYOiUyqI0iJy0IXGIHfGApuKRgdoct/WPxISbY25ffOyc9fp6kqi99vsC3xFS6+Xag0jgzTTzF7lwusskAh8bqhwhRreHje7q3RoMq8mSNdjPZuzbU764CvDqFtQeGRrpaQOx16rNneGFXrM32k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 23:56, Christoph Lameter (Ampere) wrote:
> On Tue, 4 Aug 2026, David Hildenbrand (Arm) wrote:
> 
>>> These are operations that are key to the performance in critical parts of
>>> memory management and this code is replicated by being inlined thousands
>>> of times in the kernel.
>>
>> Cool, then it is easy to show the difference by running micro + macro benchmarks.
> 
> And we have done so repeatedly. Look at Yang's posts.
> 

I'm getting tired of this.

So to be clear: claiming that the additional instructions are unacceptable I'd
expect something minimal like: "removing these 3 instructions speeds up
micro-benchmark (a, b, c) by X% and macro-benchmarks (d, e, f) by Y% compared to
Mark's approach". [1]

https://lore.kernel.org/r/ea268481-d584-4744-99d6-0b05aade7d5d@kernel.org

-- 
Cheers,

David

