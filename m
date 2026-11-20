Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B217606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IGBGu8Pc
Received: by kanga.kvack.org (Postfix)
	id 9E28A6B05B0; Fri, 20 Nov 2026 05:39:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3E76B05B2; Fri, 20 Nov 2026 05:39:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA216B05C5; Fri, 20 Nov 2026 05:39:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 671376B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:39:43 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08E73A8E79
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:39:43 +0000 (UTC)
X-FDA: 85455151446.19.D6C10C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F080A000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:39:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGBGu8Pc;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795171181;
	b=lAmBBnvbmgCTIYFIVJqmDh+vkzaXzp+r5aHhydZ3p3AuqAniN63fHgCiaNXGfLy9uNllD/
	JCN489vT+IsMuacRDluF0gAU+y5v3tG/yLbZMIwXb81tBt+lTQSy7HZIP2aQf1b88bY/2p
	SpsNngNFt4KeYUbR8NcPh3DpmpTzfk4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795171181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vGIW9I1ju4o1yJGSu39nk3CaJ8NQdo93J8CXX8CWrdo=;
	b=ep9QPAU5xqXRGOo6QqK27O13Rc1/tEKL1c1vl18OJE84uz48tcOxgO57EkCniABUKbeM+8
	PB4zT4xMx+MEdTPgjK5KDx4WrIEn4Bio2tNBv+WOT1YenSZjKVZoSQpO0v24CP29O8ZsA5
	GwkTbscy+4h5SFxT3ZwZpOawsmRyCEI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGBGu8Pc;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6ED684150A;
	Fri, 20 Nov 2026 10:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEB51F000C0;
	Fri, 20 Nov 2026 10:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795171180;
	bh=vGIW9I1ju4o1yJGSu39nk3CaJ8NQdo93J8CXX8CWrdo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IGBGu8PcmiFc8kFSm5YOE+U19GwPgF+o8NDkNsg1tj9YkoyZ+5alsM8cO2U4sebtx
	 cjGYUFaxIoh/bzAvm9ZDG932gYkLjexyJDNSkghGIrSTqkhupNHKxeeqFXKSMftGwv
	 LacEuCexP+Mjv52VHF1yXPFWZbRIiQVXEnCENMgeIbGbjfdGgmhqUjaCkQf8hIxpat
	 KDGdFFFNxtDeG3Aa4ExrLhy3whA/Y9d1fKtCKKmp0848c+f98nedXelZRgZ+Z8NjRw
	 Aymihtefuu1JYhRz+1eBkq2kIuLQ/Ky2olyPPWnUWqTYjdQ13xMSLtdrkISnPjcoVE
	 l7H/xSCOusr8g==
Message-ID: <87218525-12f3-4259-9950-877c8e36c83e@kernel.org>
Date: Fri, 20 Nov 2026 11:39:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] [v2] mm/mempolicy: fix copy_nodes_to_user() for odd
 inputs
To: Arnd Bergmann <arnd@arndb.de>, sashiko-reviews@lists.linux.dev,
 Arnd Bergmann <arnd@kernel.org>, Gregory Price <gourry@gourry.net>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: larips <larips950@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Jackie Liu <liuyun01@kylinos.cn>,
 linux-mm@kvack.org
References: <20261117211635.2472067-1-arnd@kernel.org>
 <sashiko-outbox-221983@kernel.org>
 <c420ec17-b297-469a-927a-85934a05fda4@app.fastmail.com>
 <3b00e53f-b4eb-41d4-b3e6-791660da3342@kernel.org>
 <45a71e8e-0c8c-4b5e-96c9-be6f2ad0e364@app.fastmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <45a71e8e-0c8c-4b5e-96c9-be6f2ad0e364@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3F080A000B
X-Rspam-User:
X-Stat-Signature: xjdnicr13myt5tnqo8yzzosw9x4kmgcr
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795171181-1749
X-HE-Meta: U2FsdGVkX18PRdRUVLD/a/+i1aDYOMhX/AmG5Qka6ZZ2gB2Ps8xQVJCFk91swEGWiuMJ+y9d8IHu3TMKN+YvPZwBH33oDGGimV1jeN8/vPyZJdIefMoJQ3cak3G9AIdFDN6fFTy/5q3Rjomale7pdRaHh/q5LTyY4083AYpp3xx+WGVVgVzlXOnpvMSDIyJtYzWbyX8d1kx+KhX71K+xTNvGwAOkmqMVaTQQ1OVP3xADfylXqGZysaw9PbmWwAgWgnGyjipnKJZiFKJ25o8H5BNQa4IaXR0gyVMryKCjKs3ia4Ia25j8dg8vbqGy7nJpAWM903hu377S0oXyx8RNFlUvMJwJLUNAeKp6O1cOIHhOqdaSRGo6Sf9TszWt08Hw8johevhgYApnRZ2YLLGTJM64h2bF2LmhDUWsDfPxwQNif73ex/Efup2mW5t2JSmhD76K+aMNVdEnw4qmJifGVAB6c1q8z4Gc4cSDP3BsVX9xJak6YEtSxW3EDvuFyQPnnoCLCKf51/dCZ4B/DhWwyAIHPDWbgUWdlQ/MK6MovdG073bu20PtlpLiwYaaXgjfJUz7GtSRpX3IPWZqC0hoZM7CxdoWHC5FXLQBYPo9PSCHtpQZmFxcYuD8msG7wQB74tmlZEMksS5oGciMFocEt0dGWFbXiuBmLP41M8ELmRmiVipmo5mjEk0n3QvIkFidOHqYL7SB8n5z8UkYn9wsOeStnXlhgBh0yDyK21IhNwpkCKFcnT3OjGQd8sZrCUoU83m2VwILbqD5fjGPGWJ0nXC5+0JS+N+kcpYfIbewLI8ZQSAI7Bnix1o79AOEGZfX2WhLWjaoO7t74uTa1k6guoqG1qxkM4tM0c252f27whUKTsBbFTFZj0tQW8CP1gcF2UdOZ/5fxslXk3+0IgORWSA1TVEXpOjP7kb2pKgXq0S1KC7EsxvPfxudiaAQQTL6FKjpMSidciyXXsPR1dX
 Zl0nDCW/
 3iyimvvCfLbkeHNWolvxfLFig6BzZnk9X+HordHMf500XSgSRPLwqqVQ5CecMprr1nnKya6+pWGGTS5f+S6K9ryyFlqJ803QlNjEkIpyGeqCEvI+5ATPnkSWIjqQufNK9Yy8uMz46Khikxa+CcTgTrXQdlRCynyl3pl0rFw+uQ92eXgeUPQVA7aQRx8xhA03ZnBKw0EyB/jbZhJ4khNSHZ/EaUiwbOMls8L009gXT3JI10ulPwL7nO4kNsQoCiU5PpUX80+3VZzhhFR6+ZXhg/htul0LwNX+dKGwFhv5rZVUO0nZ0ng4qz/3cIKs7B1ED3FeNaj8lQo8bygaxKjBJhMz2pGXWP8T6DoT9IiIBCkmT5JlrICfVI5eq1Wc5PQQCRHIyTAPdOOHuPHeyhTzrSmkhAnZsJCHTorPLNyXOm+dO1bpZaQTQ3ekeNbaJlqtX/vobFzVQc/xp3LhV60hGFSGK/0nM222KO+ilAuDXJ3HMra7fh4ExBNzivhLZyIludSFmIIm5VTfJGR1xz57PmXsPZ8vg3KMZ5xzwBsMPZ2mKj3wVO2sSlCLCCyZMncq+8CpxtiOXl1IsPg3hjJPvoj5jbQCn4zk5UUdtiJt/HXvfUiI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 11:16, Arnd Bergmann wrote:
> On Fri, Nov 20, 2026, at 10:55, David Hildenbrand (Arm) wrote:
>> On 11/19/26 16:52, Arnd Bergmann wrote:
>>>
>>>
>>> Same as my reply for patch 2/2: no, this is fine as the size of the in-kernel
>>> buffer does not depend on the word size in userspace. Copying the extra
>>> zeroes from it is fine.
>>
>> I'm not convinced, especially given Gregory's test case. It's all a
>> confusing mess.
> 
> Right, I see now where I went wrong: 'maxnode' is adjusted down to
> the nr_node_ids, not the number of bits in the bitmap. So my patch
> was wrong, and Gregory's was correct.
> 
>> I do wonder whether this whole function should be thinking in terms of 
>> bits to make
>> it easier to follow. A bit more churn, but at least I can understand 
>> what is happening there:
> 
> I like this version as well.

Does your #2 still apply once we would have that (in a reworked form)?

I'd appreciate if you could resend based on my suggestion. Feel free to adjust
what you want and just keep it to a Suggested-by (No need for Author,
co-developed-by or any of that).

-- 
Cheers,

David

