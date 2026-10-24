Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8700C606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 11:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cslab.ece.ntua.gr header.i=@cslab.ece.ntua.gr header.a=rsa-sha256 header.s=smtp-cslab header.b=gyDtI9+1
Received: by kanga.kvack.org (Postfix)
	id A66B76B0A8B; Sat, 24 Oct 2026 07:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A177E6B0A8C; Sat, 24 Oct 2026 07:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9056A6B0A8E; Sat, 24 Oct 2026 07:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3836B0A8B
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 07:26:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07C94140259
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:26:55 +0000 (UTC)
X-FDA: 85357292790.24.DCBEFEB
Received: from danaos.cslab.ece.ntua.gr (danaos.cslab.ece.ntua.gr [147.102.3.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8BE4A40003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:26:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=gyDtI9+1;
	spf=pass (imf27.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792841213;
	b=2MWqsVsD5H1TfXOaZDp7H6z9X1Gtq9n9/GdHsf0OrTTLlYaSpzPFSF2tQnV9H6se0aiQhK
	CZHjxtB5seMgfXCQWV1r1xMwgufwql9Iy2q8L918A1JYjvrZi+DPHMmLFIPQdQ44i7EhQ6
	JlremD5Vf9aCcQRLDFfz+7rcog4Ssu4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=gyDtI9+1;
	spf=pass (imf27.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792841213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SODtelJKNz5lpKljfUqqvtwJpgZo4GIqzSkNOmKgNxM=;
	b=ZcCF0hi+recLpUdbPo/MNSOKXQjpI7hZE3JMMhJvbtCOgk3jgcFNbQTWZhl79e0Fxvlp2v
	euyaJbcb+KLzwyexPG6sz+8mDnSkXUBZYiznS/Eb4SRfWO7jzV45+qH48QUKrZnZOEqETO
	QtNHatwatEfMYGUlSknsW7mtX9gxhdo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cslab.ece.ntua.gr;
	s=smtp-cslab; t=1792841208;
	bh=XjHt8HPKu1fEim6ZRYfiWk1ofwZMfFScMlz9vo5EbY4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gyDtI9+16mLjv1PQsjT5HoEL5XLArVqapqmrFV1EDs/QfMs1JEn96Do6DCOEKLo3N
	 KZUfGWVDMKq5Si/WwdWqz1m0Bq7aYWM0pwu2KnBnGGYAhU6AoREGgtEe/N6gP1t2E7
	 3NXU3enzXJEIVh9QBotS94Kk+aJJlxEuC+f9I6C4=
Received: from [192.168.1.5] (130.43.37.55.dsl.dyn.forthnet.gr [130.43.37.55])
	by danaos.cslab.ece.ntua.gr (Postfix) with ESMTPSA id 182FE120040;
	Sat, 24 Oct 2026 14:26:48 +0300 (EEST)
Message-ID: <5c05a17b-167e-4379-82f0-dbdff783d050@cslab.ece.ntua.gr>
Date: Sat, 24 Oct 2026 14:26:47 +0300
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] test_maple_tree: test maple_range_64 node in RCU
 mode
To: Florian Schmaus <florian.schmaus@codasip.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>,
 Andrew Ballance <andrewjballance@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261005-fix-maple-tree-range64-rcu-v3-0-ebe7fb278e20@cslab.ece.ntua.gr>
 <20261005-fix-maple-tree-range64-rcu-v3-2-ebe7fb278e20@cslab.ece.ntua.gr>
 <179276488829.1655926.9998832837982828676.b4-review@b4>
Content-Language: en-US
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
In-Reply-To: <179276488829.1655926.9998832837982828676.b4-review@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BE4A40003
X-Stat-Signature: eodh5fu8myfufgknoixy1bhyqp13pdo7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792841212-704921
X-HE-Meta: U2FsdGVkX19D6wNCpSRiHupahXPLNbYHqiYzwjYK0eoih0hCwvWkea4CICwev6pv/gbkCx9tLwAlDnKQ/hXITLy0OMp7wFe8ItgkbN7hVS3KC4Tov9ldtB0Y6fFQXJhdk4ck+a5oLMmCjEcBhrgFWCeoZ4xLtHUOmx19q5AxED1CmNhvRgRVr7+QxUzufHfEIgOn7acwOiXvjexih9VwNFMAHS8Wu+gUvkn3FvcIUU/1knstpIxfiJ4ePD/2yWuZ5Ng0zLyQXPBA5LTmFhFs/dzzR0HxO/F31rW4940MERCIULrRTmei9Q6fRBM4np2kD+ip5wTG+DEMuTktcx4u+UGQhPH2f5NccmIeE0xF14Np0Z5NS1ThIMeOWRyEk8xZGZwoknwXqNEH+d6BcGIctrkLmPXYxyTfwwgE/qVMwlYf5SIomDgDWpC8ZEcXHB/4cmsxsETNY9jFXxLyu36AD7jWpvlCbStqipc+ZUuf27PtSVMJmizjDl36Zb6qaeWtK7hJwjkazv9anucxzh0o4EU6cFwFQ5fbOVWJCtdlYAm7NiofS+kuYaSkADYJLyZWx1M1/zbAc48aUjdBOeO8ThTc5blFsIJ3jnTF4ENBf9cY0mqt8ejWUwNOMI7avSMmNX10ZqpeEQI4df7pyRH7DBpwB5Mdig2cVT5xD8s6Bbrzcl3g3zIp+2y0J/wNkjPuWhrSzBixehjJlCg56X4N9tvEkQYVuy8cmcMbXARru3dP9WFUI2ISTJZCXCG/Z4/TInZfScBK3CiicBxi2/nEZ/xPTz2N4NXWZkh7JsqaTV/0tJPybCsoWRTXGXeXeq0wj94a3rV5J/Z9wrasKZCwajDd+0bsz3LgBIQ9ot5txJ1+bFradpYsQWkattYnw19LoKo0QViT0+s8JD8MoKyKRxR2v4Sg8Vh82ktTORiL9ZdkockejYXpAcuu0ANcS47hXlsXQtTvQ9uXu9MTS0g
 W38AQIzP
 5q3B13k+npwSeea7YVIP/p1EVAtqOR1d+xlVODFvtQAVLNwGUSG+rC9I7t3OblmcINzJn+AiPs0T98yEN/A+wT22xqdjil/1mxXVr0Fh3nvrUJlgddi3ABbR7uXH3nVvocOhvdB4jyC+wexTKwwQhhRho5IqD+WafOaa6lpJPWwZrYr98tdRqCxjQhZ53oxETMwbLtFFrOwNylQ/m4U1zpoSCNGqLgxZ8FBWzlx4RSP9I+lS2igkrhvG+3DXZUuMKMFx/lijCV/PJYzIJ8Dc/Q2K2AdEScRzTZHKuheyJiEKcT8cua13uFAcREleGvPTQWGaw/2RHrzWDZjQzeB9woe01T3KYdOSEV6+NKf1HLqNm4VtuQ+juSCOvW+7FsUfzDe2HdaqMxYcpxJ4UnQan6gT7X2nsurnT+6zKu9ngXzq2WNK9tqhvuurTJMTjZgwF3HQiF6WODoFOyeCwkLEb7iyKqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 10/23/26 17:14, Florian Schmaus wrote:
>> This commit adds a test that builds two maple_range_64 trees in RCU
>> mode.  The first tree has a root that is a full maple_range_64 node and
>> ensures that the destruction under RCU does not misinterpret the last
>> slot as metadata. 226 insertions produce such a root on a 64-bit build.
>>
>> The second tree is a height 3 tree whose root holds 15 child pointers
>> and metadata in its last slot, so every slot is non-zero and ensures
>> that the destruction under RCU does not descend into the metadata slot.
>> 3166 insertions produce such a tree on a 64-bit build.
>>
>> Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
>>
>> diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
>> index b9367c61e8b5..fb40e193a3cb 100644
>> --- a/lib/test_maple_tree.c
>> +++ b/lib/test_maple_tree.c
>> @@ -3710,6 +3710,36 @@ static noinline void __init alloc_cyclic_testing(struct maple_tree *mt)
>>   	MT_BUG_ON(mt, ret != 1);
>>   }
>>   
>> +static noinline void __init check_range64_in_rcu(struct maple_tree *mt)
>> +{
>> +	unsigned long i;
>> +	unsigned long nr_entries = 226; /* Build a full maple_range_64 root node */
>> +
>> +	MT_BUG_ON(mt, !mtree_empty(mt));
>> +	mt_init_flags(mt, MT_FLAGS_USE_RCU);
>> +
>> +	for (i = 0; i < nr_entries; i++) {
>> +		MT_BUG_ON(mt, mtree_test_insert_range(mt, i*10, i*10 + 9,
>> +						      xa_mk_value(i)));
>> +	}
>> +
>> +	mtree_destroy(mt);
>> +	rcu_barrier();
>> +
>> +	nr_entries = 3166; /* Height 3. Root has 15 children + metadata */
>> +
>> +	MT_BUG_ON(mt, !mtree_empty(mt));
>> +	mt_init_flags(mt, MT_FLAGS_USE_RCU);
>> +
>> +	for (i = 0; i < nr_entries; i++) {
>> +		MT_BUG_ON(mt, mtree_test_insert_range(mt, i*10, i*10 + 9,
>> +						      xa_mk_value(i)));
>> +	}
>> +
>> +	mtree_destroy(mt);
>> +	rcu_barrier();
> This case passes on an unfixed kernel.
>
> The bug that exists today requires a non-root node with 15 children and a
> tree of height 4. The size-2768 test case in my series covers that. You can
> find my test at
>
> https://lore.kernel.org/all/20261015-maple-tree-fix-slab-corruption-v1-3-160d97f7304c@codasip.com/
>
> and may fold it into your check_range64_in_rcu(). It fails without your (or
> my) fix and succeed with.
Hi Florian!

KASAN catches the invalid pointer access in the first tested tree on
an unmodified kernel. The second test guards against the cause of the
second bug: a node (at least) two levels above the leaves with exactly
15 valid child pointers.

That being said, I do think that covering the case where this is an
intermediate node has its own value. After all, more testing is never
bad :-).  Feel free to send / extend the test. Since it exercises the
same underlying issue, extending check_range64_in_rcu() seems like
the right place to me.

Dimitris

