Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E34B0CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 13:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E5A6B008A; Fri, 19 Jun 2026 09:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0136B008C; Fri, 19 Jun 2026 09:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EEFE6B0092; Fri, 19 Jun 2026 09:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63FC06B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:45:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C98598DD95
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:45:38 +0000 (UTC)
X-FDA: 84896784756.06.E2B680D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 15E791C000D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:45:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsjnKBIv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781876737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjW1D3wAlx6YDOQQhvQRpWc1UvSBeQonEhDfLUEQvko=;
	b=VFnGUYNGAGFBGE3siPlWzajY+L/d42JfaoiJ2maw9S7YwjROBobN+Zu6DP2axxslAKwKw5
	/mB2AQ83BIpB6smPO78XPxMjzi7awlNmMykjvus/bnvGSGYFgAG67OSo4S6lMTXfTbrFBg
	QTIttcUjwHSAHfxa+OHxaBK0QlK3x/c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781876737;
	b=DynM2hvc59I8R9W0BKdblLH9Z5YUG1uTIwLDC2BSbFp/s3vk9qNRqFqSsEhx4egTtr0gjC
	xHr/Lf8RYuJPQweXDd48zjtVOqCMF9QjEUQAx1LkaQYc1NtWKMGu2EkxpevsjECCc9P2vs
	E0MCLAr/jhGkOCklKKzE0VqhRdmO4T0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsjnKBIv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99E8E601E1;
	Fri, 19 Jun 2026 13:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B93B1F000E9;
	Fri, 19 Jun 2026 13:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781876736;
	bh=bjW1D3wAlx6YDOQQhvQRpWc1UvSBeQonEhDfLUEQvko=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QsjnKBIveTMF7UYQJeJoj497i829x0ccFzZw4zOgFOiqRBg6lnNi6YuIYuCoQrJf5
	 oQ7wa6yF63oSUGq2PYrM9Fv1rsp0g/EDZlOrW9ApS+j2DlOQsfOSipK4XaDhlnLePF
	 dEV5JIqYjb2thSuFnM1aSxTYdzqxerudU2HhxThvavNxaglycBpeiWWBZ9yV0vYLAd
	 tSeqmeXjnlENqPk5D4BKc306FogQneS3lTFMgxpErif8+sk+sU7dfNiJn/1wwdh1Un
	 U/NwJMakKBbdpc42QpxEknf7Xc8XW5wK2GW5NEepWE/0UReU4nT+6dSMc+hNeq9QpE
	 9dW/3OCIJnYCQ==
Message-ID: <4621037e-d051-4db1-bb58-ffe8c0afa3de@kernel.org>
Date: Fri, 19 Jun 2026 15:45:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_ext: validate section in for_each_page_ext
 iterator
To: Matthew Wilcox <willy@infradead.org>
Cc: Luiz Capitulino <luizcap@redhat.com>,
 Ketan <ketan.kishore@oss.qualcomm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 kernel@oss.qualcomm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com>
 <1dbebf73-6c46-44e1-ac6a-f5ffa9849b37@kernel.org>
 <698e5cdc-8f1d-4984-bb54-a4b7979b4dc8@redhat.com>
 <3149fcee-eded-49b0-baf4-ab69c27ff063@kernel.org>
 <ajVGQg0hJCUThz5Q@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajVGQg0hJCUThz5Q@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 15E791C000D
X-Stat-Signature: 5fte7r3pj5onqhzi63teaz54f59ruach
X-HE-Tag: 1781876736-455254
X-HE-Meta: U2FsdGVkX1968MGqT1KVyjeIMJSnGPEl5mUt5RYVIzULh56YvYurH5Iz0jSFOuDInSQbkjDeCrqAQaNfNM8VphaPF0Y9cjRv131H8o2ZblhugPb2iArqyPsMDeYEwDgdJ08qDW0EtWPffzdAr/+fey2tBxDZe+A0WNqcnVPsE2gI3oXvUFWUarOklaEzbiTnd0pvZqBDjLwJgcn9IyCpczu9c41yTfbBYU1yAennF1tMsoKRY22tv9QMiC6sg7IGkMsaELerJgkOIXgoGZPGjSsugJPARtbn9I8UuMav0lCJCJjc5xBkYhmVmLYmABTVe/XcfaWoPx2b357V0/EgqjYBtCOmusBdYs8CCPMzOxjo+lkcawe0X7apTX15N59TgY36goTdnNOKkdECedepGPJh5kP+byrj19C6u94uL5x8BQtZqk4JKjimZsHXtkNT5jU2kpcFSuIQhcJzKboqAeWrEMmxolqWfxcKB6epZSWjWsk/cSMo0yuW/gedGUrqj+YWXGQccZM25dVVzrEBTkWVthX2oDPbhKUv80ad/kkmX8eDe772tHjFwwUJJx6/4K0jzQGEocXFFtM/Oalbvd36CXA7bdfFUvjpYLy3AwNwvLVpAEoGBw27MU1MZbeV426ce2f76ufJ0FnSA1MCmFJYKT3QMQB8lvuWjFeFUwek1fb5e/8LZywYt54xBHW7RF5AiK1G0cLayeFuKkLL4uKY0ERqnjia8SCQktS5n9ljTd6lpYzrvRakfnJH97W7nAaInmfU0bRYvIhga8q0S3Ab60PyhyxiKzDAyVKC4kPB5Bn8yXDrTbmCERqIIx0GZRqhK4xAXwTQyfi4invIcq/yeP6Bh6XthLHeSp+P6ZmLurBldo9PcC1ZfAgVRaNFHoGg6ff79Josc//u5OyNc1Tbt5uLO/bhLiiulibosVcKjB1jtrwD06tFe7QdZ/CRUHfMuT6twbUd8EBOmWN
 cN1cT6Ov
 LCELZwO1XF0wCeHT6D6nPzmU8AUeThfB1PwPQYq0aT7BCWNr0bqTyU1gqfEX266mZejFpYyl8BmSHYDWE+lZNEiGEid8pkFgMzkWKLIzjthHfJNCBmSSFyZHrXA8M+aYEZ6OdsmSpjywHwiqzMZD6ahcuqBr+vnnxGxQBCQymml0UWcNdgMKHE+FSgNNTQPjMtMq0m7+cpMFL3skQP6NgkisOonyWtDFOp936Yb/rLFvaP7N65DP8NpSWXDfBX4yGmOVUa5nNAZyUA4iJho+7ntIOc5oUYyseO4xSRQir25VTvmHpJIx5YhUWEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 15:38, Matthew Wilcox wrote:
> On Fri, Jun 19, 2026 at 10:00:59AM +0200, David Hildenbrand (Arm) wrote:
>> Likely we should just handle that in the iterator, looking up page-ext for something
>> that doesn't exist is weird.
> 
> Yes, but I prefer to pass 'max' to the _next step explicitly, rather
> than put it in the iterator struct.  Untested patch attached.

Yeah, no strong opinion, same fix idea.

> 
> The other way to do it is s/index/remaining/ and count it down rather
> than upwards.  But that assumes none of the iterator users look at
> iter->index, and I don't have the patience to check that.
> 
> I find it weird that somebody botheresd to add kernel-doc for
> page_ext_iter_begin/next.  They're internal implementation and really
> shouldn't have public documentation.

Yeah, Luiz was just very thorough :)


-- 
Cheers,

David

