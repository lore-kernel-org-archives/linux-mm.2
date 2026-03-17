Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 951FEF3382D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A78E6B0005; Tue, 17 Mar 2026 05:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 058476B008A; Tue, 17 Mar 2026 05:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0DC6B008C; Tue, 17 Mar 2026 05:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8BB46B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:44:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F7978B436
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:44:34 +0000 (UTC)
X-FDA: 84555070068.08.C6AE305
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89E4EC000D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:44:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ik1DuBbz;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VXuQ/J4GNt7oT6zblkmq9qlCO5ESuQM+7pQynQnbcQ=;
	b=UAnzpc8uWpxpIf4helMqwi7i82uWasBKphRzgKBzmkR+EheKQgqi4WFbqB5owfV4m26Ryf
	Kv1aJr+rtoNOVSCGz0y2/ahJeJIUiEWn7lGOKR+SSWxfCv/1G5HamUsQBWwX3pQqwrxpcp
	pbJbQYbYChtUhlt9dA54lINeAr4KQXw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773740672; a=rsa-sha256;
	cv=none;
	b=OnA55wcYD9Fg+edCSDOs4y/univoeLopuYOTpOPWn7D+e08k9QzWN2xaBWBxZwLOZUpRQa
	9VHNFWQUbNMpl5yd6VqVOgYbmTR+Q4Q6yJ27X0x2X0KvoZdFYoinj1gSgWkK3DuEWmxb1G
	xu8+624iH49UJIiayA5Htmhd3c5xnrc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ik1DuBbz;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8691742ADA;
	Tue, 17 Mar 2026 09:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F74C19425;
	Tue, 17 Mar 2026 09:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773740671;
	bh=dz15afUHBIoUObQ1NXSFU8reFN91RYDiKdcZru1b1cc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ik1DuBbzAOADEx+qkFh0Cs9VhtkXAm79396O/H6DpbI6WJDxsQHizL78/PkfoFJpA
	 nI1XnsvpN/lHd1JC30rCmAKQqmQcJvqGC8QaTrLe7rB+mSC+5683g1PJRpIpDoYWzT
	 1SHTPblIlfweA9k1RlEeIUrYxPIhfPG5GVh5zN8twYkxsd5YLgWyjo8LRqQ5JfYJV0
	 ysgOgu5k6FAYvFypJfjdOVqfKncQrbvPoDj0ZDUMDNtr1xM8vACnWu1cMW66Qm5Qsc
	 npOgYhpS264pmB0a7YI1rU5rvS9l2SP/vCpBYsjxpTfkDgrY+WEmWGnvOgjK4OnmlI
	 cr4Njo9rkIHTQ==
Message-ID: <ea531433-7596-4888-b257-f1caa8fcb793@kernel.org>
Date: Tue, 17 Mar 2026 10:44:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: list_lru: deduplicate unlock_list_lru()
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed
 <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-3-hannes@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260312205321.638053-3-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: g6nwbaagizaz6udxdotqrx4ptmupyokk
X-Rspamd-Queue-Id: 89E4EC000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1773740672-560852
X-HE-Meta: U2FsdGVkX1/5eArTxzXnybziTYEfT/seaQ9cL3CcEHGF0IhV5fqKsckruC9WQK0OyaL5CAV0aoLjIk1AOKVGdzzbFBkiV2U3WJlhl7UTaxLJ6hhDU29fTwnGsUf6CLcHbdppIQObNyE/SbsiXQUBSTqYcopkPJpM89jdbRNo3e2qYDppGZGinMqs7SY4J/sF5O+Sfw4e3J+tj4TkIdjp5UQQcl/P2C9JXuaKZS9FmKsAcTCdF1ogYnwRrlUUmh93sb1GOGkcvp2qnXxEdLd4JIscKDwSztmHSikpj/037gRJ3mIBS1oX6SjznqebzNJLaOyv+7gNrrLT9ZEgkpHVf+nRbFnEb3c0MfBEw4iCbZNdDQ7g/bgvIlea771NYSW3w16+JZznJJSgqwhQPOB3GbormDD7NK/PGy1wZW/K+KWO2lvEkKxbBCgfkoWbd1Jyfu8ZKfZiBRVH+WyvvBaQHxAD5OWRZI//VpdX0Qa7hhY63+THG5oX2RNxzWIuf/mpXMdmcVWgIwtWNbXu2QZqgvthE1Cq6RfRjJUeP0aWiscPaGfuviIdwZxgtjTEviFSQj0qfxwvn48HH3hrKGRuJv4rTx2mNJJVGNngSk29c/SOGvKBSyCTL4tFhF1z1++zH4DjgKkql6GexE3VtNtiasw8ZT4ETw5MLHYzseEj4ToaWbRDlQcfLlrlErGOkaCSbRhrxcRFZPrddaljoG8SLK2NG2Dp9WHgviH4TBUcuu5pJ69zw6XAYqQzx7+gMcJszhVzlzQYbePlZ1JcBDpVDMX3iMxh607gaTV9RB/ySnWVCpAMlL8CbnDdHp48IvfVRib4xOU9vHUxCrrsee+AUfj32iiTTqQZTZUDe80jj7lC6Aysr7nQy84hoU+Y8PNTIvFfJs+iGRjajBzZL+63mzA3eY21H56PstKoyL3HcuJ8Qkj/O/MmwmKdW6RebHnoFBr8RZ2TYj4eVmGxG2/
 rEDoQknf
 5g0Sb6BptMnazKqfeZV5vlpRXFTQqMRe5TF8ezQ/CAV6Aojhjj6ui9YDyovkIOhc6bP7VJR6dgybQPTATdKlLHKHGPv2a29YrAI0Kqn/QZAkj8fMvghOF0yiVoOTbpT6i7dSnGvgbHqWrTkUw00VGLjkmm20PC0Nxo/IgtlplLQaUNf9QvUOnpz6/jZXd5LLiTq/wpSY3f9Y2j6xU8cgCcY20fzPVj3bHrd5C1BRG6z2Whrf8OjnhG2veMhe01my3AFFZxrRCZeWcPWw3/wH1iZAwZPvMw7m9ie9KHa0keiK28cqwHj05TYeD5OIVGIXNPkh6QIY1mggLEkjt7Cc5buhLqYxxzxuY6NZL+v1XenBmY2sncwoq5qfsGP43nLjgJQG2OdWfQCMNVxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 21:51, Johannes Weiner wrote:
> The MEMCG and !MEMCG variants are the same. lock_list_lru() has the
> same pattern when bailing. Consolidate into a common implementation.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

