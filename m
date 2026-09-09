Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C3AC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB1C6B0092; Wed,  9 Sep 2026 10:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92116B0093; Wed,  9 Sep 2026 10:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A466B0095; Wed,  9 Sep 2026 10:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE196B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:23:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12973120223
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:23:25 +0000 (UTC)
X-FDA: 85194441570.01.ADCBA91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 488CF40007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:23:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQiuCrQG;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788963803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i6W2FGwXgxwv6NRv5ZRSdh10FfBE7WUHV7rXrybSwJ8=;
	b=O0ii5JnXdUzN/hfkZl3071cfiQh82pCUAjHMMRZiTFnPgc5Beayc2yXRUNrs/m0m/W7Fzb
	0hp3LV9YvkarFoDJp868zBRaMP1qBa81WAoRk/VhHv6+ITSCAFEHhjiIlDWPjTItZPl82n
	Q6ZfZ05TSbitUDtTvM25p8+WU99+iVA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788963803;
	b=v71Hjr2quajTYpNhwXjYLuGKoBmr16snuyet17e6hxxFNLRdVJRTehZJrjbBEEkWrDr7IL
	4VZG99nz+g2rL2uIDchZybjuTBmTt7v5DfaRSzcBZ7HSUNOGdfGuYgDV8vWcxlt0k/4EAX
	gFAKaK6G8EUSomWDqzDCU3CAfnBNHt8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQiuCrQG;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60DA94359A;
	Wed,  9 Sep 2026 14:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D312F1F00A3A;
	Wed,  9 Sep 2026 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788963802;
	bh=i6W2FGwXgxwv6NRv5ZRSdh10FfBE7WUHV7rXrybSwJ8=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=IQiuCrQGfz/BNM0KjlCtC6onVCVz8KRUfEkYfYaus7vqqG27w98ZjrAnsKsKOzPHt
	 4fH96H8AwHsQOjwGzabUEx27K1X7KBLc4EqiSufWnxQ46vitgzJfGTBy28c7C4WAjv
	 i9byds1do2aeLwOEdHAyfRQyKVWihBqcTTdDplc+OYOi9U7UlUaRe7tayrhF5DOS8W
	 563z85pdqkMIzG9Mv0VEn2tXd6vjaelbCchqReVT/whqJRFnb23yL6aBQ9Sk1FahoC
	 D3RCMc6ohPHre8ZPzLd+XuEb8mhS4HWwD7CVFSHJO7Yn6OsdQJPwWo5EIAGHMLllkJ
	 bM9QojvCuIZvA==
Message-ID: <fb37c097-4c12-4eb8-9739-e3513127eb35@kernel.org>
Date: Wed, 9 Sep 2026 16:23:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/14] treewide: replace PagePrivate() with
 page_private()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Li Nan <magiclinan@didiglobal.com>,
 Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-12-6ae22f9d9272@nvidia.com>
 <afc196d8-8e17-4cdd-a6be-94b8816f2a57@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afc196d8-8e17-4cdd-a6be-94b8816f2a57@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d5h5uyhejq6psuwzpf1nhqq4ta4k14m6
X-Rspam-User: 
X-Rspamd-Queue-Id: 488CF40007
X-Rspamd-Server: rspam03
X-HE-Tag: 1788963803-765770
X-HE-Meta: U2FsdGVkX1/3n2Gkhi3RtiWxwV6E7te+R7+FqJstgIDdPToaoaW7DdQnA3gQFhiX4PxAdy+I4oZcAxeeTStvoMj9vZoi3yY6OF10yS345K+zDCvnBbXW3m03T3qA4pi3aCS4I3mU3/8F4/pGJQJ4Nt3M7DKWhyyg6t6DdzInTeD+18RB90PKsf+ONCGzR1CPBQ/Y2TFk1UQf2R2glDg2XkCH/oci7qk+lpnXZkWzR05iwpk+C+oiZ6pVsVLdZ4OYD2fBLeOk+Pbl7P74ewSfdyGaTAuKjh4g7mw7p1PjQ7Mohi1fdeMM7jXu16H0a4xlECloX+iuh/gdyZ9aj6BqRtoaF8J5qxz1BQgsi+ZGmwVIzz5mNZooBVl4+UMwWVXtAglV0+aLEVENsGIEnKnrwV46xY4uCWgAWxiq5JRXeaTIbFY25iOChLxRWMAeNClPVEFSXYQhc8HPf+WwUPF18q262tDSfPyNjP4i0hQxXyJs2ppBoX9AWI170N79/EtQa9c7oEF8xStrkvVgep9V9jfO1KyiSLlFqWdv7WcN0QjkyYaLLgRedpyGDrMKZQTkUQ61ttyJDksxcHNrrGbmVUcmN6/cBIpAMhNBy+NXgKk+ZtX58MTu+4JIAGhvIrMZBaMB0STHk5U6wnCzB7rgicyBTOWCHSPTaPbmnaL33gxl8OHc47OcwYvckRbFHGGG4WSjYvESqhelBSWEu8yAt8+wbjhWcd6u67w9u4cGothEIJEwknOBslNXq5rXY85QftevAuBVRejsJoKBZPwQhjvgjilZv0BYRyn8hnu6is00QCJWoVevyjODS5YPm6lyeMQgRizRfctBn+sYkfUSr7qfswW4Tb2XtArang3oMg6EJu22Z4MFvKMppVnpsPnC6BFAXKsmSuybO1dbutxmwKwg/cBcqYShp1YKUdCyRsfufTvVzQ1+P7pQAopTUHXSpdcoXoKsGwhCa5pWF3y
 gTDNsOTe
 Har6BOqh201O6F0LvI8XBEc9jU4lQiYmZ+J016Qi7T8YBrtP7LilUUw6TPf7ivVgE+FUNZUI7JigXFan3CcuazHr9biMNwrZVbeoFFsaKHhCxag7ohovkCwTCyZEJ9LaJzGydiawrPJ/z24aLcl8Ft2fIqAGkaQjqHBLl2Ed1NBgcW1XM9cksd6Zce2UZYnDv2/XQsjHzrWGPD+6he2IXq8zhrnUB1lUZkKajSZAULtYlM5n5HkXxrGC39JJVUa3NS97siz1OU6hNRFBxYwzjeroiQoeLEmLXNfKhY28osaIJRd2WuMkSA4C3udjzLeas1dal50c78+GfL8M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 16:18, David Hildenbrand (Arm) wrote:
> On 9/8/26 04:56, Zi Yan wrote:
>> PG_private is going to be removed and its check is replaced by checking
>> page->private != NULL.
>>
> 
> You should likely clarify here that, for these users (the pages they deal with),
> PG_private is set if and only if page->private != NULL. Consequently, there is
> no functional change.

Ah, in previous patch:

+static __always_inline int PagePrivate(const struct page *page)
+{
+	return !!page->private;
+}

So this is not about PG_private *at all* :) Best to clarify that.

-- 
Cheers,

David

