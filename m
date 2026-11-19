Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FEC4606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BfWMwLSo
Received: by kanga.kvack.org (Postfix)
	id C2E776B0668; Thu, 19 Nov 2026 08:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C06706B0669; Thu, 19 Nov 2026 08:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C286B066A; Thu, 19 Nov 2026 08:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D27E6B0668
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:53:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 23EA780B0A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:53:25 +0000 (UTC)
X-FDA: 85452010770.19.28C1BBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 55FD980005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:53:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BfWMwLSo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795096403;
	b=augzyIoTJlyvsEf+/D9I0qfmSHUwuOSRC4zKlMR/c7Obq6jIXwjTM+X26KlDjUf2U0ywpP
	Q/j5A5jdGjHvkY5+RoTq8NcO9zUOR2XC8JOneyHa0iRU0q1ZKqPPlObzBN4oLuAhXEgRk6
	t6XWbQ2o/VWBpETkBvsnak9CeiN4qHk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795096403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uBfFopsIi7MLy7pYrN7B1qUteLhkE5uPYkUUmww/QE=;
	b=8gyGonEgS8xIick3kUmCCy4H5xtW3Cr2zqEHPzRPMPDGRrUCaNYUK4GDqwXYpwsXyQgkWo
	rGjtz/gMj4sPeVq2nbEEmZEpR8xDaWKZW3acZ2xzgguY+e4dzOHbcdM7GKEJBozauWBw4k
	7a81LJn9SW4coC/Kol4H1CiYGJ3nzBU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BfWMwLSo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8805E48C74;
	Thu, 19 Nov 2026 13:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BCD1F000C6;
	Thu, 19 Nov 2026 13:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795096402;
	bh=1uBfFopsIi7MLy7pYrN7B1qUteLhkE5uPYkUUmww/QE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BfWMwLSoXYj7iwS+h2skIUrs0bW6IH0jWUZmq653nZtWMeeKFiLQAj+OrLjV4f0SZ
	 W0gbrNY5P5TgBOSJjSVK2KevkbxtHFvadSPE3SrE6s4tlkxcEsSQOF2j+3iV9O7jHd
	 9wi1R+KAUbDezPqAQVe49ZybpMc/k6phzerjSgbsrygO1hjFCLv5IzZPZSL2K9wuum
	 WQyCI809IzNhWM3NZAy2vBJOCB1+ZFUhYIKwp5r0QYUnMKa8b7AdQ7PHpYeYotHSc9
	 eWZGi0ya93xnv8gM9VOMRr786inZYY51iidzZSqCYAujZxoIhIxjA58TM9E1OFtHQS
	 MPpNms/pNYPoQ==
Message-ID: <1679bb5c-197a-4192-bc22-d6c15ad55eed@kernel.org>
Date: Thu, 19 Nov 2026 14:53:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/4] net: skbuff: limit folio refcount when copying
 skb frag references
To: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>,
 Song Liu <songliubraving@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Rik van Riel <riel@surriel.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org>
 <20261118-skb_refcount_overflow-v1-1-5551b4954c3f@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261118-skb_refcount_overflow-v1-1-5551b4954c3f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xjupc9c4couutjacaec8u1ex1nignbjz
X-Rspam-User:
X-Rspamd-Queue-Id: 55FD980005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795096403-628047
X-HE-Meta: U2FsdGVkX18ohUZwjxhFsyCG87h9c+AOXe7urIkmtSH9W0TKMOUKb08fWWf8UBnw+Jlfk4OXDHNNv/u3PZ+adlj7Y7j6IkZ1c8f7DgySZau78/EBmcKg5z8u2WiY9Um6YHLz5zLy6KwaMrkqMjATWWgpBLx3FQtGmAr+DQ+3upNBnORF5dEPzgUylzsTmBbTtxVBNxt0mf3/MQzyrKRPoKJuQ1MFdkLLCpGybbByJdAJ6J94a4WcXxo5wOpmugEq5gX9LQliThadn0S7N6UvRJzkQYNY94Z+CP0CIwI02gZp2tt4Q0Jcp/ZoOX9aT4r7qsdHvyqIvt0xmvCshN/Eg49c9Qsc/0RmeIqosnNfqy9wIW5v7ZOXKPyEoyFEPk3nDcGY7kwf5tpMYfWptwpUuI+C2bqjorA2Y3zXWE/eg5aNGGJZPqhWWaPf1sRofHf5XCdrhXo/ueD4dtkP3E1ooPQKPYK8a2/wxnRwqszOfdGuppD3n4DVkvzgeXzbwzyyRn3mKHgXIFyzBe9azPmdnU/K9jIFDhddj7KqxG95ZLivq13TjQi2unuuAmdQH8tA20PfWWCMvAhJcIt950F97td85G4Z65qRfNSMrklPOnoOLKCcwt9eSCj0V+0IqgTcuV5WNMXpe8Kg9FQOUTMj1VJkqqnR5lTNMK2QBrRUCVyaOYffQbNg3B7sLHwQKeUUs4wOvOvpt9N5ec0m0t+pfS96OA9ZRtfjmsEk9ip4H7ZLnjVyqJEsyC9t0VZLl+7SFEZ4fnix6ty6T8vQTzD7sTDlT1VLxQ5YnZhOG/e2i1OytdLTmW15ABiiS/9g+y4mjmqgUvMDZHfLtmpKdtMlcl13hLazQSuGXqnZ+ommV9rnfwHYNzGnIoKZhcQLzUDK1jM17XhgIF4AaR6245C8KTPazRz/eUNWIpqG1BnFO4jjpyiR6DECGR6MzFbnuZeditw0FlOhygAjGQSRr+Y
 TG2ZVXfs
 N6BjaHvjTc5PJmTDaEudOSKd0adK7HshHeR31HRlqxxBszR0ZC6TY1auhI4f+76yRQ3fLfuKBsqmVG6FO0gh1pPKiWphobRo+njxWz2KtXMmGCpBVbqVkGoSIrX5X/fGJ1tmUpaKr6TKMSUzgABu/HKg13q2IkIbhH/zQz7TST4ycK/j6oCzm+SOYvRhiFYvYdMyC5eqajdFhvSk9+1eFL7yxfCLDzTLbpa+sUvjKbX4WVDnJX7Fwc5MQtLmv6EVwaJaAnw/DzIHLq/7lD3RpPn/howIsQJXGRFlBn/vVRSR258z6QR5E4ClDxJ03hurlU+W9m6AHSW5ryhzCAmWgOganBEiAG9qouGMUpYHIJycABGddnvgTH+g+CAKrb75cEb+FSTyP9qmQqNFSPPl1OxH3RQfaKWTA+ovNRxG1b0Mb4lnfMG/O/iO/c2kQd8JipEHz4FlQ3fM6r6O7DoO97P5TWKSNgW90nDvf4fhn7m0o1Dld3ORnCbfdwCMdA56bIazI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>   *
>   *	Return value:
>   *	0: everything is OK
> - *	-ENOMEM: couldn't orphan frags of @from due to lack of memory
> + *	-ENOMEM: couldn't orphan frags of @from due to lack of memory, or
> + *	         couldn't take additional references to the frags of @from

To avoid a html docs warning we might have to drop the spaces for indenting this
line.

-- 
Cheers,

David

