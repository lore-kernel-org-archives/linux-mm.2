Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8189BC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6177B6B0093; Wed,  5 Aug 2026 02:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C6996B0095; Wed,  5 Aug 2026 02:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491A46B0096; Wed,  5 Aug 2026 02:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0706B0093
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:12:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7540D16011A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:12:28 +0000 (UTC)
X-FDA: 85066196376.05.109F4A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9C451180005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:12:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nuE1953L;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785910346;
	b=yzzCaM2wCmgPjxqpypYYe0zGD2LqiWzUNuihVupW01coD4aW+vXxHSAeWxKu0kyPy7hxbF
	eKTqI4ZRvYQpA4KKg+wpst43xbSfF5vlPFXP7rhXuX0cZe5kEg9sqVswDl6TZ5ZMa+oIIc
	phtyZgoxnUAmHHU4ueKAgb6GnG2woq8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nuE1953L;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785910346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hLSDYK85M3wvI1xgsH2onhHuYsbD0hLp15Rb5kZzBE=;
	b=mOr2ojwKv+q1Qyk0/+66q9ScPiZuT5Uf0Gni3X3VBRP+F3lUQJ01fq406rqizbJ1QrkaIp
	gLE231oAlekCh1HBKt3kOri+zW+xhhiVW3E9wqm+RigwNi/0HTHTRiu9FdPXOETF8A5yNZ
	tJm2nOsLkoS+VzNVolpYggQRMy4kyZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37141600B1;
	Wed,  5 Aug 2026 06:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875871F000E9;
	Wed,  5 Aug 2026 06:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785910345;
	bh=1hLSDYK85M3wvI1xgsH2onhHuYsbD0hLp15Rb5kZzBE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nuE1953L+3uAi2FMf+5JWzAAPNWofIinBa7crSNrCgsraRRSMNncnBoftKUUhA5LL
	 /XIkABmVioCXWD4/nqjYmth/a1BqShCVNeIs7MmkY6QKmNe6Dvi3MLmVkn3ZW8hp4r
	 J1JZnb8ds2VXplLPxeIVmoCSL4Fg7LHyb2LyBN0peX6uskmvX2dh3QvTH2gYNSjJsO
	 8Zp2JJSrNU+DR4D6sh2qRdh8Yz+JWGD+C/ptATgjG917Ygf+zbXpdqYGkbZe0pJynV
	 5DJCfmXRCnd5OH1mNCKU7fwmztu2DGU0+YCUuG0hbBKL1otTwnPAT8MvOcZWn9Y0nD
	 ckE0cMYWtKaww==
Message-ID: <3d5f0435-59a8-4eb8-825a-d8451c6dfb81@kernel.org>
Date: Wed, 5 Aug 2026 08:12:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
 Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org,
 urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
 <63ea8156-a109-b2a2-6d35-1c17ad7f1a9d@gentwo.org>
 <84b31836-1d10-4bec-a469-468b91fd4645@kernel.org>
 <9f146ce0-4adc-0c00-a2d8-c01b47edc9d1@gentwo.org>
 <ea268481-d584-4744-99d6-0b05aade7d5d@kernel.org>
 <b4b79f6b-e09d-bbb1-2181-07e756e849bb@gentwo.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b4b79f6b-e09d-bbb1-2181-07e756e849bb@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9C451180005
X-Stat-Signature: myarrp5k7sx5n76byfz5x97ue8fjzmwe
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785910346-406773
X-HE-Meta: U2FsdGVkX1+am4ZATKzxM0LtkBLQ2BqRctxpWtwu9I0gKou9KvPUl9HelpQvNBXteE77pt7xC/UzkH26fd3WztozsUt/RNaGj7bEaxfOeeE1xlQ7+CRI62dKgiHu34LO2gpAEzJeSDxHa53R0bgS5SSAomtBydP2tFxwTmxGUxdpBsZ0Dg3P1LDzF9Tr3T4NUst0RNHDOK31paoVN+kXyrOTtwbAGcuEBzweo3baGbvvjPzNJI2shIZ2KjBC4BkrrwRaNh/cF1ohVWILVRQJHJP8aR806j12n9yvASIZ3WctkSSlrNNPYo0NNdG6XYCClzaCjDWLNcs7cG9ZyygqWOp1G5kmoIUvticH5dTWplJSB7l7+0oSkx5RTTNi0JucPCerqn8NUGTwTAYtMSvzu5Y00HRniKvkJuecVH8PdwC0zEPZT08ornetyFrV6Mz4KSsPvtx+vooqlAGrA3WJSfwobOJy7S4Grqa60fiDJF/oUxnmsHoHjrbGsBRJxM76RJPzN1+oLPYexKyRQuuQPVFRVvu1aQLYuCR24zRmp9AxNsPDr9wJfJs+H6wn8jJfJJyLAtq9AsKQwg+PuBHsPoKERrUj/G9H/gtrg+SNh8/gbIN4zYfxtmcAPVKjsH6Njgohqug2hqSON4yxJDpd4pDO++pBELBvKfPOyzqHR6lgHLDWC3SJNFNXGQX3YeyP5yIHD6VDAriJpK+uyplME+FjU7pnMrwUVEFx7K91HPol+ij5RouGx/kQ7mV0reX6PvPrzR67C/mCN9u/dXTes48BYWlPxmNiex6s3PTHZ88oAXPppofYwj8NSlAxmKwFXURDiLpgrJcL+L1bxOmOkbG+GbH7heUtxK/K0SpV5LVmTuwPA2d342yThHLF4xJuFbphxPHBCxOS2oPD/3EMyKWo7oexhw5HfpEGLuK91FHcTvblCU4rB4GZI4HIjAINd9erQjW92KePPb5binB
 rNcghDqK
 YF/WJhSokI/PpfWeCkaVZXdXiSROk6F7LiWBOCj9CCFhKt9zwrodzjZBh7JoVhPs9l6njE4lU+1sM4GyJWKZ/WBNqO0GdtAgfTw8MwZc3RqrN8n7WRBhXbnhBn8lHSGnxuKXyYJ7id34ZE6Y3yyqqsxU2uAZfYvnMVqWAGlVZvsCfE4ZalwQa4rmQJr8610pysqJmBTHmycnKd6zfpHqbawduKNcOGThookL6xnGe6Bo3QNF5vKWddOF7JBq7xSqsAiIN8L2zyWPZWO9uA0DNnNv3BRPQz19IgOstaKn+OGAOpIjLBoMUPXrl2/E+rDxgtusD4QM9yXIEPvk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 00:01, Christoph Lameter (Ampere) wrote:
> On Tue, 4 Aug 2026, David Hildenbrand (Arm) wrote:
> 
>>>
>>> You cannot accept that one instruction is faster than the same
>>> instruction prefixed with another and something else at its tail?
>>
>> I am pretty sure that you got exactly what I meant, you likely just don't have
>> the data to back it up.
>>
>> Proof me wrong!
> 
> Well you seem to have alrady seen the benchmarks that we ran and are
> running. So I had doubts on your sincerety with this comment. Seemes to be
> be just there for effect.

Let me repeat a third time:

So to be clear: claiming that the additional instructions are unacceptable I'd
expect something minimal like: "removing these 3 instructions speeds up
micro-benchmark (a, b, c) by X% and macro-benchmarks (d, e, f) by Y% compared to
Mark's approach". [1]

[1] https://lore.kernel.org/r/ea268481-d584-4744-99d6-0b05aade7d5d@kernel.org

-- 
Cheers,

David

