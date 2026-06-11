Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE760CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B84C6B0096; Thu, 11 Jun 2026 07:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F056B0098; Thu, 11 Jun 2026 07:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E006B0099; Thu, 11 Jun 2026 07:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E49226B0096
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:26:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74A6BA04B9
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:26:12 +0000 (UTC)
X-FDA: 84867402984.05.2892064
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 841061C0009
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:26:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gPcbs4uT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781177170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqjjulDH3Tmftd6bFVSbdFoziLNVvT1hh+/KsytHjBY=;
	b=qMa3LlZN6oEyzgttZutyLrUssqBi5g/NEV2mcHJWAS4VsHn+japNZC8EUkD5NcAEiUThMw
	gHBBAsK2WEPDpQ57Homi9RxkCUWzuE1TcTj0ELsKgVmMFS1GKfGzrIddAUq9ISifM0P2dX
	PLmmxzvI4KUwN83xyAAQgoUS9azjjM0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gPcbs4uT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781177170;
	b=X5RjVFimsTIt4HI48VEnk2C/aJxP16wCyltij7x5RxI9zRfX2NycYtn14c3NcrPRKNwv7D
	CpEipP3rL3lgiPdSVX6JQW3+F/bwMPROr1WoOLXRGzooR54i7Uny/xOTUsfUjjJbvSYqTN
	8TbW1T8f9mQsF+nHuguuxuJNUm/29hU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4827242D61;
	Thu, 11 Jun 2026 11:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF801F00893;
	Thu, 11 Jun 2026 11:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781177169;
	bh=RqjjulDH3Tmftd6bFVSbdFoziLNVvT1hh+/KsytHjBY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gPcbs4uT270KLUxvFhf5PCccdxHi/jLrUP1GCYzWkfed2AQJ0aIXEJerDVk1SewrM
	 iwkK/knNdRs72Hnzn39mz4J7gzeRD0m/9CirgWfe58HkzsuBsFPxqCND58xg29q7Dn
	 heSQJFFKwSpPD/qLff3aRio8TKObX7qPJcLifGpCxbaUsFjY8ozikSPq5guEPa9uLA
	 Z3B+s4NJKMZvnqhnZgWRyH0mngisLaQ2NzMjKXGGQ/AMj0BwXrBc78WboBjQnYU8SQ
	 zvn2gjy0GBqJ9nrrVd1MygWWkvKkng/A86V2P9hVqB0Kp0djUE6UKWbMzHJARvfE4u
	 eKf6c2GHq4Czg==
Message-ID: <bc29b740-8f1c-4e2b-9b01-c8c4a4183b3a@kernel.org>
Date: Thu, 11 Jun 2026 13:26:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Anthony Yznaga <anthony.yznaga@oracle.com>, Mark Brown <broonie@kernel.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Aishwarya TCV <Aishwarya.TCV@arm.com>
References: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
 <bd9d1353-3053-4665-8f35-ae3f6e379237@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <bd9d1353-3053-4665-8f35-ae3f6e379237@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 841061C0009
X-Stat-Signature: r4fk64ekuqchheybitcgisnofgx3c3op
X-Rspam-User: 
X-HE-Tag: 1781177170-195817
X-HE-Meta: U2FsdGVkX18vCN9Lt/0DKpHp8FI51DH//a57FedDE+ImOZOiVOatRZhIsJn4XihPCGh8T0jLgqjChnePXCT08VuHKAOZu7F/KqcTTGxu44ywzsp2Vzph96SPoLDCSFm3gHa6aTY4ZJb7TnEUEzNPmE0f73cSPDCneNjYNsTZGImjdwWJYtr9kXBKKOFKKJoRhy92N24q7wc+9EGLimaSbFfeohCF5Z6bqnG0wY7E/4NhKRHmfeFOmRWs9kr2gCAsm8OEZIKJDZ1zxzbB2fFz5ndibv+1x7PvdRvN/Lp0bMvwQKbHsQNN1FJd3EGgftlK+uE6kW2R8dkBYXLj+PIP8DQq5pderXWxTbH5Kv0KpPMFfbAUXt5dwtQo9bV2Cz1dUhdH5skszlCkk/BeimXp5khSyvlNY+VqxJ/AXpyQRzfBLr1oU0a0Kv7Lyr7d8bG0hujYZVKJvRIxTEtViGHdlai2112TXafrEmbhMK8pZhOHcMsgjKWSSl2fHPKDmUvBTFEaVQFScb1Us725Lsh7Vv4xKuuaXj1li59SFpIvsehse/J/COc/BHnPlhwZPntVBh99bNmZh//wGhTUjgHCIMhjTvTkL0n0LjmSS5k1nOqx57jx7yR4c5fCIOA98kc9bd+eUszfSJ/lrR+eXcSLccCn4uW0gv47pkFXO7VnJgCfBLGOjj5zv6xlRHs3Vjjup2aALhqofKWYCWQpZ8Ii4WVlJFdcSP9H7GiSHSQohGX/T4L8aUfyj0ZSKsQETHnV82/9EE9zbwcEiUTkUBl8BgcspP8+WIvQ/o8APrC/tzBgIo/qxg8Pzu+UJXfo9oc7or3Gc++UMj7aooiTdQOGNKi/BvqxxWlAAtDgttLYfVkXb6FYcPSR2dMwFd7k646M1i7d5rjiQueF7ANWCLs4ST6ppERXBumW3jkfC+fjuDwXqnmsjo2gaUFUP2QXLAQRE0LUa8fUeWObM4Dovo/
 dD6hE7JW
 7Qx3OmwhSCQTPEeXKnVuyl/CWB+jjCL+YfqREeei6nauSeupNhEpNPJq+VK1vkmHrOQ2+FOya9+N5Vji14LcBo0yznqp3KIj9GPsp7UFfEtlv2FaSt6l2qpJqXx9/NR/5vcFfDnCGS87btl4CC24KYZjx1joTfbpNlQdoxjyPrOSHT59CD+n7TBxjwzF1IUXt9NRJAu/Hu2Nl4MAaj3IeiLcwptJKme/HnzujdyLyjAjso1t5KTQX2OGbvceN5xKGpQjo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +		/*
>> +		 * Speculative reference can temporarily prevent some
>> +		 * pages from getting dropped. So sleep and retry.
>> +		 *
>> +		 * If a page is not droppable for 10s, something
>> +		 * is seriously messed up and we want to fail.
>> +		 */
>> +		if (dropped)
>> +			break;
>> +		sleep(1);
>>  	}
>> -	kill(child, SIGTERM);
>>  
>> -	ksft_test_result_pass("MAP_DROPPABLE: PASS\n");
>> -	exit(KSFT_PASS);
>> +	ksft_test_result(dropped, "madvise(MADV_PAGEOUT) behavior\n");
> 
> You meant "MAP_DROPPABLE" behaviour? Perhaps that can be folded in.

No, I did mean "madvise(MADV_PAGEOUT)" behaves as expected with droppable pages.

Reasoning being that we might want to add some other tests in the future that
trigger reclaim differently.

Thanks!

-- 
Cheers,

David

