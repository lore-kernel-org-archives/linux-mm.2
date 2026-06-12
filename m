Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D8CCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 08:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273626B0088; Fri, 12 Jun 2026 04:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224216B008C; Fri, 12 Jun 2026 04:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1132E6B0092; Fri, 12 Jun 2026 04:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0090B6B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FBEA1C321C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:00:38 +0000 (UTC)
X-FDA: 84870513756.05.E669BF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id BD2E220014
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:00:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9w42EBs;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781251236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSmOpKrtLyjFjuqrcOC032kwv26ETgi73okhOGmIPp4=;
	b=lQXeVeCmOcHIBgcJv9slNPQnP2zwHGsaqJfffhzOW7SIpWDJulDFO2+ZMi5q5Vo1tzhM6e
	uQ5CEPly6vl9CKGxX2YLL4TECflkmjaQfDCfDi6wh1ppY25azYOh5QzMi4RlIxG/UlUpy5
	9qwZuBR6nHsDn8nUeSDwS0JUR25x+zs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9w42EBs;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781251236;
	b=wFF0LonnVkLlfgFPOHo7tIMqXBKEN7knNOMh1IkKoGk+hlu7z7M8dwxKSwyWbZP3iiLrWS
	RXSR6JnvizAwQx0QnRWhDMWCRP2cBLp3Vix2pv0Wn7F9RVMhI2N/3wpjv1F3U7ba0RF02H
	VCih4ThvT7YlIeyY+UhA6JlOZ/nnosI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E30C340519;
	Fri, 12 Jun 2026 08:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C12F1F00A3A;
	Fri, 12 Jun 2026 08:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781251235;
	bh=sSmOpKrtLyjFjuqrcOC032kwv26ETgi73okhOGmIPp4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B9w42EBsDcAxZ35or8FVaTxskZMgTXv5/cr/J5vCUy34TXVnAO1p/lJQvsi1MsNPy
	 gkQMRJ6kOW2kq6K7HYFwr8epLE3M/JtvnV5eedrj9ckQ8o60PHe0qbjnGBR2io8WVB
	 y2JZHTsIB8l1Q+BzB9FjCeOE5PlRigMDWRxbR0rgVxXVl7xE4y3bnPVMAdAL9Sq83x
	 KiJPrXrD3bD6iEBHC9qOVV1IbDCQN9WVNnKxaoV3dQbI7RQ+NmD7q+uIQhJA3j9zvf
	 3qqXrXsjhcu2w0K5IN7cVS2zMieajuKt2qnaaLek2XrlD8OrMjKBgYHmOFAKmUOqlF
	 2rOwNq8F5AOqQ==
Message-ID: <2cf7bff8-1681-4344-8bbc-16bf4306ade3@kernel.org>
Date: Fri, 12 Jun 2026 10:00:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Anthony Yznaga <anthony.yznaga@oracle.com>, Mark Brown <broonie@kernel.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Aishwarya TCV <Aishwarya.TCV@arm.com>
References: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
 <aiu39cOX1w9ICe_U@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aiu39cOX1w9ICe_U@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BD2E220014
X-Stat-Signature: iz7c86bcq7nb7dc9nhheso7omjffe9ge
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781251236-258158
X-HE-Meta: U2FsdGVkX1+XHorv7jM6NMjxArsrqYsO9JF/8DDwqKGEmX9XOJqchX5RTOJbPYTreMyt03tvOH1/rnCq8BDKHfnxNxg5LZJIaZOhlDqKNjTd6r0eAq8J8jZy4Ya4LVXUsxiVOng6lLe2E0KGqYdYfuJe1lr6hrZI8vl6h7/jhKz4Z1Cj6W++dtD1FqdPwb4HkTm3BXK5qk2t6ByGsiG5Q9V1YDZ+PLlHnTN139gL5VIaUNL/TBldCkwkG2C8LfNq1ur96Zk2uJNkf0go/gXNohUqBWSY+Wh5uw6An2qrnif+LYqkXRx8He/6rbWpDw7ip0c7HvCTBajfHr2wSk9T7XLv7xtH0f3sjMa3Y0qo7Z1NjcvdKGxNoVfTl6OHp30rz+mKYVLSYc3p4TZjuXx+pql8FtOc+uD5XCt1GEwLDSStGxWHfTBLrRNqeBuk35tJiX23YVkEE2wBi41LmEoF95BCsph2Cn8wc86ItRgCEg7gcPXDujw9NDbQlvhczty3KJxMlZOlmPbwh4slDaYG4wvj+U82/cagyrHx2i9E2bK0ve/i66q9x4tHRNwACpBdTgHRvx5eO5OqoOXepk+473iUlG7pi8iqoS8FlCUcp0L1LxpK/hCJAoi3VkzHiYM6UrmTVrsUfjB6IdxTYNW5O6Xb6SeR4njH8cP5Y3V2ftGI7n4ENKXGGGwaJmmOoVLTKY0yultvVPY5oZaxIP5eyqKeOFDgcouYyNuZ93T6TwvqoSgF8dEfiwyko3junbGg/G8t/YFkjPe+S13r1j4MKn7SRX9+AxjJSfIBlbzJdn29S81I2tO1pxfVyqaeZ/MfswpZH/Uoxgy47aXBIGe1Npn/0fBJEc2ec9303nMWnjap4i++1TOipbZl2kqn2YG5+bNjxaS+VtmwN4JvkWCrUhOCxY01O/AzOhDr/AeN6HruVwZnG53lpSu6VGzN0lQEcGXXjrDK/LqIA1kq1yi
 0fx2e87B
 hfHanMJSjSUlb/6omlGmA2N4KcPfstJTM0i5fbnhoYVsJD9St5crDWizByDF5YmBYZx712XC55iaXqGpCggUi9t2fFOz+67rkHsuQptyN8UuFxqfNVrdn+EJKI2hmSXK0XCFe6fs3x6O4IEBSHhSOnWqZXWaMMhjrlN+f3FUbUN7gzyCIbnuC/F4zP2ks6f7IzPszQuGYNbg89Oa2vMuid2jKVm3aUWYTT0zm8jV5u3sTK5c1xruMf8hZnd1f1MwND4dQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>  tools/testing/selftests/mm/droppable.c | 46 +++++++++++++++++++---------------
>>  1 file changed, 26 insertions(+), 20 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/droppable.c b/tools/testing/selftests/mm/droppable.c
>> index 30c8be37fcb9..57e1b6fc5569 100644
>> --- a/tools/testing/selftests/mm/droppable.c
>> +++ b/tools/testing/selftests/mm/droppable.c
>> @@ -17,10 +17,10 @@
>>
>>  int main(int argc, char *argv[])
>>  {
>> -	size_t alloc_size = 134217728;
>> -	size_t page_size = getpagesize();
>> +	const size_t alloc_size = 2 * 1024 * 1024;
> 
> I guess regardless of page size this suffices as an arbitrary range over which
> to check things work.

Yes, that was my thinking. "some pages".

I was briefly wondering whether to add separate tests for THP vs. !THP, but
decided to leave that for another day :)

-- 
Cheers,

David

