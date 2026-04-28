Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3999FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 19:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5946C6B0005; Tue, 28 Apr 2026 15:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CB26B008A; Tue, 28 Apr 2026 15:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482556B008C; Tue, 28 Apr 2026 15:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37BCF6B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:38:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD134C163C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:38:15 +0000 (UTC)
X-FDA: 84708975750.30.A7A18D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 045C31C0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:38:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dZCd33P9;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777405094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usJgC4r7W4jplC1bxHQ7WWalUBOWBHLcnL6pbbiOd/g=;
	b=KHqHAhsL8PAWOK3eJLQ5zIUQxjfX2EZOu5bohA4ngDdhwLGNhIU2L7GZoq/aIH792V3OJr
	VbhtxJENUrTIUh5NiGIaUc2aazpWwyjYFHjAu5dod0ViLHmGbAOs4XJF1fhuJSh7sxijoc
	lLHNU9ZWls9i9bd+HbA3O09+p53fel4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dZCd33P9;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777405094; a=rsa-sha256;
	cv=none;
	b=ndq67P7FayVIHLjFpiy3ekNLfFhA/74S0x97sr35DxhfPhjy5/ykIwg3uhmaQHEXknfH8a
	jJYcxL7/EwxCnFNg8M1Y7JdtWaYuuoqhr2QLS0Fca22+o1m4MqfCa8jiToepdii0NMeMtM
	N3lJl0z4DdJUZeGlo6po/qeCYP37xYM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D4A4437AA;
	Tue, 28 Apr 2026 19:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5267C2BCAF;
	Tue, 28 Apr 2026 19:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777405093;
	bh=EvIkYK52K0rLotm9PNd5ZD8pkIHIf0w1KVvAhcPh19Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dZCd33P9zFZ/aTLdNx5zcMFUPzSh4b0lZ+a1mfBhbwCILbKGz0K2boJQfav48xKB/
	 6F2nMJLICFuha/ubYI84SQoTqmNy2U5Vsi8qHMeHTBF39g/LWUAg17DOxRA1/b/RYu
	 hBH7+wytalclrQx7utPSQ9NFAgEvOlFJzuQLW2Y7bXI9pMkHRJ8HtyFkCl6XRTsxu4
	 iE/T1vbwocE0jkt5RM6PdmPGt7V0Ul0Ygifl4eNmAYI9JmOWhUsmfdcFwAFejg8Azg
	 jcZZzPv9YeSd3h8L8UtNOjDjjaa9CkzBe6+BH6XW9ArW5MckWihBVWGU81rriLHhKY
	 UTBdWnUm2HJ7w==
Message-ID: <92d8f449-682b-441a-bb4d-4a2b9299a5a3@kernel.org>
Date: Tue, 28 Apr 2026 21:38:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] bpf: arena: use page_ref_count() instead of
 page_mapped() in arena_free_pages()
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett"
 <liam@infradead.org>, linux-sh@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <20260427-page_mapped-v1-2-e89c3592c74c@kernel.org>
 <20260427051758.e1b714a4b567917971920eaa@linux-foundation.org>
 <CAADnVQJ9JXrtAnFgE8UFK=W1GDeT6T6Wi5zB7g0AfRjU8M4=bQ@mail.gmail.com>
 <2b2eecf0-72f9-4959-9663-c80e3cd0c517@kernel.org>
 <CAADnVQJp30BhhB6N3-GxtYmMpaMTaYvGcK9R5=8PxWD6qEXJhA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAADnVQJp30BhhB6N3-GxtYmMpaMTaYvGcK9R5=8PxWD6qEXJhA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 045C31C0005
X-Stat-Signature: di6u4o3tz4r5prdydjymafmhw3atudu3
X-HE-Tag: 1777405093-776934
X-HE-Meta: U2FsdGVkX1+YPD+smxoVH6sGNjjlXGGJTEzWRfmtW2kBBKi82Ds8MQFNXqrJtv1DDJMv76I8J0RYdabR96rfVgbiJR5Rfgg+m33vUg154W76C7+ZR9+xW2/efJeccOLNN7X9gGt76TXrnuW/y9xLO6C9REeJSPqPuYaCskadBkmvRqPuj3KXukt93HOPhvTgyiRK79+wO9qiLZTlLhcyMzX1M8Kd+te7N8vc3ruI1TujXZ4fkWwlsVrzOLk/kz8xKYZajXdJjlXn9lKKgLSvO7dvHu3/g2U8JcacEA3JB+hVTwnrQCfdAdQUOQCcPnHmwkS5A0lnllPpo05POMp11/JK8VtiO/c7r0O3KT7/CjAFciuiNlpYACgxCvdKhMMAdmuAXQt47n7UIpmm5YXzj3zN+mm/qyNVXWCou9AP7rdBWlEVuLckrZgb7UXwfWbIORdQMG7Gid4++r91r6iTkFbw7qlU9lWujSPxvKFzdeMCmOAh52vjuiORVYPk0jvHI0wPiRFYLlp+ArJonRLWq5KVwRdj7oHYCHA1uqAQVrExGQTKseTiMWdgPVh4pdhuNJlqsJj7jg3yXF+dayxiq7m67AKZhQkBzdozAwwLW78omP+9RFcbjBfumXwGT3fOMbzXf7FbESgh9ITdu+h7OQggK3jezhnovLZRem8MBQMvBaehcs2u89BEXUqysffvuG/qWCyNraqkKiQmqDIhinKVZ+6whIAfXjlZ01/wbXkEiGNXTAgMxyZi1EjnQSLNfDqGNXQra2jm4L1ypol23BcmguIDRlMckGf9Fp9ER2Kq6WX7yraNs40yUdGXU1O5qsl57Gt+hd+Eu2ijG5DWU1FpM7XU1BphGCWE1gr11oIKVbff+fz/R3n9Ij/oajeqq38+n36deqMJ/nGWVvX/8CLBcbggH7GHImzaLXDipP5hvTbBmNxAU+j8V49YY/e28gyXRh5zZz/4xPlE+4A
 1iF7CE+E
 fQXq9DBhU2Nh9xs9AEW5Ux753+pXJp5r/e/QQN27X4KzAQze+rHxc1Gm1DPFukEJKwcOOBN/96MedwYzszWVFv27PON0V23IGqSvQlfpyj6yrKdhW51LXsOuz5NNsWQ4yrtu7EiZ2pdcEIzJdstI+VyefAlmiD2x4xVT2KO0qXaV+PzCTyifkRLsF1mycP3mSOaDxiOS16Jw13iyP8i4wfI58QMV1sv+08LMQdlv25AoXbOGNU7z4y/CP5HgTl4VKfItpFMENHPrHBGAIKvLfSTFKxtu1Zp0lQFYZ88qRpiv4AZGErSF+7b3EI4CJwtHUx9nY8DIULvqjvazbOGranjE1QtbS/FtFRKyCz8ltv0EIP6OBSAYiKg2jQNfUqWz4seyWY8Bsf6hI1PO2REjXlzRB6iUHEv/oZaKqexZmVCqoGmdpcJ56kKSUBJZpS6MkJXf/xvRvj97OFHC7dDsy8QJF/NUs9ZcA+z1r4/imUv982mU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 18:58, Alexei Starovoitov wrote:
> On Tue, Apr 28, 2026 at 9:16 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>>>
>>> We cannot carry the same patch in 2 trees.
>>> Sooner or later it will create problems for linux-next
>>> and issues during merge window if more changes
>>> are done in the same area.
>>> The only way to share a patch between trees is to
>>> create a stable branch and pull it into 2 trees
>>> then sha will be the same,
>>
>> As lack of stable trees was raised a couple of times in the past, once we're
>> done with a transition to a fully git-based mm-next workflow [1], we should be
>> able to provide stable trees.
>>
>> [1]
>> https://lore.kernel.org/r/20260421094216.8dfe14a8c62f2420fa5aace1@linux-foundation.org
> 
> Ohh. Thanks for the link. Full git sounds great to me.
> Reading the thread it sounds like you guys want to explore
> your own way of managing the tree.
> If there is interest we can share during lsfmm
> how net and bpf trees are maintained from git pov.

Yes, I was planning on reaching out either way, talking at lsf/mm would be great!

-- 
Cheers,

David

