Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72C65C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30FD36B0095; Tue, 21 Jul 2026 10:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0A36B0096; Tue, 21 Jul 2026 10:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AF636B0098; Tue, 21 Jul 2026 10:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBF376B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:55:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6602D1A01B7
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:55:05 +0000 (UTC)
X-FDA: 85013081370.12.59BEBAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9AFC220003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:55:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjfmhz7N;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784645703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXvMkjXAn7y2m4HY7s7QUvSgtEyYKfTxuKxsFjU19Mk=;
	b=no8s6ndPnRtqqr2ThvO/F5AT7Hk67N+1bbrBa1XMu76kqQ/h1CjsX3LFKJvYS8GmSKRVq3
	ij1za83B0PjLNE1yH9Pwm73qMZjDmGj/NMq+C/YAwC7oOhpGFn3cXG7lmnO0IKgrjRYcot
	Y82kvEjtLkdcMDnqsRvvtYiukyJgsH0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjfmhz7N;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784645703;
	b=eTCSE+7uKA1tbVvWJ5oP2udorc8O96FfiI84YgYg94FQj9OSepArmmyc0eSpEQlFvsK9o+
	/qMwPhcfl7ai+bF2H9Q0xNf200g0c++ZjNHKuuTvjkeiEy6EUn9E+A6GdWMp+baeTLls+/
	74RXb10rYAs/l91epsF5UM5lYVoAGl0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C492E40949;
	Tue, 21 Jul 2026 14:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F4C1F000E9;
	Tue, 21 Jul 2026 14:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784645702;
	bh=tXvMkjXAn7y2m4HY7s7QUvSgtEyYKfTxuKxsFjU19Mk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mjfmhz7NR5yJZTJdX1z31PRts2NK/a4cqCWaMBfl4jwVaRpkq/t+dQUoJihlx7yBF
	 jnTH4ge8oxxPrj7ph8sEb5t7R9IZdX1eHl5QOF4AsAjdWpwJIN4n2bU9bEs2dcw3u6
	 sUXCgZGcFh4JF/IyKXsqUyg1HHH0SSUX9jH97narrkWcXpPEvWKogCVIpC1BDgFCpt
	 k1xFsKvE1UdeT0dE5hLHq8CVUt+fmKnZflpvll8CfsXsrZN37ZMGck6ezOcw5dsmPS
	 F3VWeemCIdg/Lds/BCV5wW4iEHYIXaPRHpa+663/5H+x2o9PL4b+g+FFm6+psLYydC
	 NMTnpGthyVzjA==
Message-ID: <cefe62b7-0167-46c1-9fe3-fe7efee90a7e@kernel.org>
Date: Tue, 21 Jul 2026 16:54:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] selftests/mm: make file helpers return errors
To: Mark Brown <broonie@kernel.org>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
 <20260716123226.197736-2-sarthak.sharma@arm.com>
 <b66c233a-7956-461a-a3d8-3421c76c937a@kernel.org>
 <004e11f5-ab21-479d-80a3-64ab89465b85@sirena.org.uk>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <004e11f5-ab21-479d-80a3-64ab89465b85@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9AFC220003
X-Rspam-User: 
X-Stat-Signature: m1ft8f4heu5yb4hccp4bgssh4ez8caf5
X-Rspamd-Server: rspam04
X-HE-Tag: 1784645703-916688
X-HE-Meta: U2FsdGVkX1/zAAUtrsmECetbHx9oHxSLyOT947wzFjJR70DEto8Q3bxg2S19L4yzD9OwG3E/Qk8J/G5Mz6V5TlhvZwWrYI99norKAL8IZr5xQ6u9GIQllFvkyFNyD6DIKjz8jEs0kdlP4DSTRVhgjhVhMv0JYWp2bIkKr89eI2uxERYTHt/ZYPLMFofv7trJGOgirT3C+j7LOyYQFkQbbNJmQxF4DHgdFyNAXu3XE4Q/YITXASuBZvf1OU0P7dEaYFjpk3+eEeMCUVWhNf4DHMSDyeLJH+kI3bcMNjUvTWKh/CTYmrYRRANHb3deYasJluZdQcmh08AsrvyLmgwc6ZwhkjF8+v2LB0jJZJBMi6pkZywHDW5YjeeU9pcXJkSc+9NphEUv2hpFas70N46r3GEeUmosc4ecTvH0EdInKr1yfRphqF1/ns4wrdZyssWB4ZUi9/yCpvtZZSePUBrLOuBq9MTYGZKR4UriWwuKyQx5cfIXP+IMWtAqd4R8Ks3sAZ7qS9cq+teWsLMmKckz7XI1Or45Y8TdfVlW6tw9H9P879eAxvCRsEMqsQ3rGJopUjUUy+AXXsRE2FQarewT1EbA7TaE1u7Hh3s6ZVP19xxV6N2IoPcAjFkx7iBE7BtaoV8ndtQ/w9fqQCo/efTer5/UN0auh25zC/AQ7v1gX4xIWL0jcyYqKLTzZuZFAHEYVoqTjllLuys/uUAArcjDGUQt+b4P72pqMDELzNq1e5sNWonUqYnukSBW5XBmnQ3Ik0mgebGZreVmiNp308ExSVyBj8cqPeiL61ccbxvzZan0v8N1E6aSy5jSV7N7ZyeB8zJmu7mR0iF6Y8eTmKrCDvZG4zc2EckPq+gICB9FgBl7fG1Nk0FEwAW0pEVYTSa9ZMzcKbig0+0JW0gzNe/+5ZKI4Sa93dZSL2ceZVNL1fjJlEJd/FhfUCvlj5eIH1MhkUrSP+icXEkoZNpEdnS
 fY5RMjro
 svYoexpln3XjV1DrdMa2jS0YJxXjoNqdklKrkfr7Bavuqbfdj+zzaplHysio3345UYbAH/S4ODphbfZqbi8LN6L/LM3RruBUpFzI0SYiUSos0HU7WylwhinbH4X+Dii1nnaoyZANqJS1EXkrbWOnt45YKmnyiQ468BNuHjQLTJ1/33+yU4pKCQC7dOP9TfkKkiDIIPpsyseCUsAKKvFfBzCtDqQ/ucCZlfPLn+ocrLwsuAbse6MDyGOhlh/3oSvEdVt3R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 15:48, Mark Brown wrote:
> On Tue, Jul 21, 2026 at 03:39:09PM +0200, David Hildenbrand (Arm) wrote:
>> On 7/16/26 14:32, Sarthak Sharma wrote:
> 
>>>  	fd = open(path, O_RDONLY);
>>> -	if (fd == -1)
>>> -		return 0;
>>> +	if (fd == -1) {
>>> +		int err = errno;
>>> +
>>> +		printf("# %s: %s (%d)\n", path, strerror(err), err);
> 
>> Shouldn't we be using
> 
>> ksft_print_msg()
> 
>> That does the magic "# " for us.
> 
> Or ksft_perror().


Right, and if we want to move this to tools/lib/mm later, maybe we can just not
print anything and instead only return expressive errnos.

-- 
Cheers,

David

