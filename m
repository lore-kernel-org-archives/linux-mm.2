Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1EF606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJtoCHVo
Received: by kanga.kvack.org (Postfix)
	id 9BAA46B05B3; Thu, 29 Oct 2026 06:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B0D6B05B8; Thu, 29 Oct 2026 06:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880886B05D1; Thu, 29 Oct 2026 06:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 678DD6B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:48:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A7BFC0357
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:48:00 +0000 (UTC)
X-FDA: 85375338720.16.8A39187
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3AA091A000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:47:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJtoCHVo;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270878;
	b=dvTasVme1qPe2eGT8U+jAV9DEiL0t/EZbeVqe91/QAWuitDo8msXOt2MoaU96RjqCh/7ZO
	c0/f2IUU+1WzuNZ+i9c0KyAOWbVoqumsMV1O4x7bBFOT4mjFivMYBTQuTq/HrjjNbkdh/f
	xA8tIQIL9PWwcvTmFmUKbfia8Gqw8Cc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJtoCHVo;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIn/L67Nz8xoFm8DVsefws4Ds0cJslZlv9huIPv9SZI=;
	b=xd51Yr643uKFMhvJTtwEedb9Pa23gpr1lg5bgo6Fj63gVMFA8TepUqyfuDxnU545AZ7cTE
	nqqlXNyaTHxzxLWeMGxdZUiF6/B8heSEMvaDB0PLsNAUb2m6iGrfpTC+p+UuU/XAylcKXr
	3MI37H3jHEof2SILs8GyeJkUHfZxeLA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EF2D40A52;
	Thu, 29 Oct 2026 10:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4821F01825;
	Thu, 29 Oct 2026 10:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270877;
	bh=TIn/L67Nz8xoFm8DVsefws4Ds0cJslZlv9huIPv9SZI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PJtoCHVozZ63TA0MuvaqjW2GMc7IggkFNT/08YgIntTpAgmcQ0wDY3WtXONW0hlA+
	 9l6Q9p3GOpWrURdMUrvLnI0/khdOsXIW+06Jtku7aBFQRIt/q/G6CnUZ42K+XrdT49
	 CKKYigLnfdKTEur/4bmGnbf+UZGguz8ahNNYjWS5YxEvQ8ywehoUI4oihlWEIbI8cB
	 0aHXGTpO/MOh6cN1Kt9swieCV+edM2VvJAReg4lSYE0yVeeutsteRZTjbbnLmj3oj0
	 1jr0oxcwFSXcwr634VwMwzuPySeLdPJm2K8dMb6xEXET+P6mpCNakkg6s6ncyCl5tZ
	 c5K2aN17zV0Iw==
Message-ID: <b5dccfe1-3209-471a-a34e-f77fffdee797@kernel.org>
Date: Thu, 29 Oct 2026 11:47:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: use READ_ONCE() when cloning folio flags
 during split
To: Barry Song <baohua@kernel.org>, Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
References: <20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev>
 <CAGsJ_4wndM+uFwhX+7wdkm2Q8AkgVcw_4wgpObfw0DAZ1w+sVQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4wndM+uFwhX+7wdkm2Q8AkgVcw_4wgpObfw0DAZ1w+sVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rbbuysx5ohhg9941jggnzs6dxamtffxr
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3AA091A000A
X-Rspam-User: 
X-HE-Tag: 1793270878-454637
X-HE-Meta: U2FsdGVkX1+qrG+oRyIAjwZT+R7zSKb9BtyFbUpJtmdUlmGYsQ7iT8YPS8jsnScEtZs8y2Eq48iGjYpbORhPxMDm+bhXOjlYRy3rjHq8CxoBnu9TuJ9/6ZcFUGFUtwq2Tl1ljosy2iCIV9XcZCbuazcv+orD2ulOaHub/PTvm8kpgNWHqtOQbfPIZmrivckiUGg0cIV4FzYf+D8PaxYshM71Szh/tM3McO2KQ9VLFHEA0UNMk+tHs+OoSBFjS/CbDQhDPBXZUxTe64B2EkTP1BWn8PSrc1he2kc05Eg9dYF1uFAdElt1Wb+gMbkEInMP72v+TZfk+/LdUzpvTYmmYe66mUx6siIAUGiPOHH5iSj5TRgJCX2PqAESonqqXyNOJ42nngQ8oVUryrWW43yYzahuSkFhEWWRg3vNItTqVV+n8Y1akQmE7VBhEMlV2ypE31plIT1ybPL8db9Cx67hc0ZWxDD17M1WOaYIt4GcTj6sM80gGIIXAQ/rdrJtE+YpW1W4CO5RjjdDsGJIGDg1G0PaIx+4iFTvltwpEdA2PF9T2YYyNU9z0yC5ZmRUZR0hYVwIMWEZ81FaUoGUeIRzNAvRNqP2utH234yxRd/hmFLIgrPUhld4c0lGmkk9ZMtLziU6svY1OpQQ63/oak2IolLF+iwIOjKMyNcXsIoKDqTYcPZtGb9u/TBu3c8/LhPX2jbr5rjJ/lvIUyXG+kkmk0t38GH6pBzz2VWVtAT/dM1J8tjq3FKPpEoS31BleRiStH4t1P/H38DCHwgJ6tjSmHgxf9WsYDCzUa5zqzU0iupqdfNJNgaNZg1bmA+PRYHeO+ufdHunu0PcsEFqDAReggelKtmbjYoKOWZAAcdvK2BNtU+teG3zDP2cldt6eGuSfMMKNzqFoskR78ywwpFBVOiLNK0UfX/Ig5npicbAxASy4GQttnaMSXM0wOvpr6rYWJwNPaFlR3AmGML6ezV
 J3GLkMBl
 MhiqC2nhasHff3qLiPs4W7JxflGYVzKJ3GPQbYGmAJMHpwFpkp7g3LD8k2mgpc8i3shKSUoxT3XXx7vS7A9DMsaWMxOgxlLke7T0+KQDBan4wBKhBGM79hH8G3H/gKv6S9TMOiiA+umKnPmy2KW/AGi69RAf6fu+t7aksZtRy8AfBNGKeqYsEUHVenJuo9Cp23LieMpSnqHusCNKpZ7uX4Jv8UfaaQYz0URoj5ohfe94T7tqvHf/ktdYGXVMYimSiq7goTlWZbCHU6VtQUJ4qzg0+Hv3YWkokKi1AFqX4fRosk+zcie34vHn/Sdkll/ytyesh1BWR4VPLebY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 10:08, Barry Song wrote:
> On Thu, Oct 29, 2026 at 3:41 PM Ye Liu <ye.liu@linux.dev> wrote:
>>
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> The head folio's flags are read as a whole word to clone specific bits
>> into tail folios during a THP split.  This plain read can race with
>> concurrent atomic flag modifications such as folio_set_waiters()
>> (PG_waiters), as reported by KCSAN:
>>
>>   BUG: KCSAN: data-race in __split_huge_page_tail / migration_entry_wait_on_locked
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
> 
> I assume the race is harmless, but silencing KCSAN is still worthwhile.

Isn't there a way we could lose the PG_waiters flag?

-- 
Cheers,

David

