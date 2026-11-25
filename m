Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93824606A33F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=FQBXh1gs
Received: by kanga.kvack.org (Postfix)
	id B2B8E6B0951; Wed, 25 Nov 2026 04:14:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02436B0952; Wed, 25 Nov 2026 04:14:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18546B0953; Wed, 25 Nov 2026 04:14:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 815276B0951
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:14:50 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BF06160D8B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:14:50 +0000 (UTC)
X-FDA: 85473081540.05.701739F
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf17.hostedemail.com (Postfix) with ESMTP id 140CB40006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:14:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FQBXh1gs;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf17.hostedemail.com: domain of wangxuewen_ky@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795598088;
	b=fSjgPEPa+o+Co3MvL/LUlMleJpCAy2jVALVGGDX4Llvm9TTfvpg44RmUOblBN5EKjDRFw2
	6LP2UhwHBoCZWVTPuQxP9HdUu6k0i4NyZsvw9YmygqKaBLBlYSM4P+5hsUwuPkZYcCwJlf
	9ip+wDoGS9a0+8i5OiVSoDTAFdtZCnw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795598088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uxn3jxNdlE5+3G+0a/jOfGNwju6eb5abMXfzyttYx/I=;
	b=ALYY1hw5BcUT48Wvt8eAldjBhrZ6yxI3Y04h1T5ZJnNWUnY31e2/icQ5622Fnp7dFhpzuf
	nO7BF8jm512uRI3IhHlC4un+M9RdI/gFwqORAecvUO3PlNrhtx9qYpjmM8mfR+kEmmVVy4
	7/vVI/E4NhgkAYBvbJ58PvvBXyPWF2g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FQBXh1gs;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf17.hostedemail.com: domain of wangxuewen_ky@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=Uxn3jxNdlE5+3G+0a/jOfGNwju6eb5abMXfzyttYx/I=;
	b=FQBXh1gsaj7wA1AY0uC5hnMdhUInKaGZN5DgzUSUA5PzR5R2NzUw1c82gXWs1j
	WrKr2XBNHi4cV62xghVsCLd8VjFP/afu5nQw90lyK8zjp4pcs+ysSkIyuzT10T9B
	hnS0fAmEvHQn7krH1HJoS4n9AUTvc6PuPJhhrfuUF3zpM=
Message-ID: <dcf71430-9c9a-4b41-a36f-4af2549e3683@163.com>
Date: Wed, 25 Nov 2026 17:13:57 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] tools/mm: page-types: flush pending idle bitmap bits
 after walking
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, sj@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Xuewen Wang <wangxuewen@kylinos.cn>
References: <20261118021253.1691428-1-wangxuewen_ky@163.com>
 <20261124184653.d6e1d627154d526e6cd85d27@linux-foundation.org>
From: Xuewen Wang <wangxuewen_ky@163.com>
In-Reply-To: <20261124184653.d6e1d627154d526e6cd85d27@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3P9XVpgZrYVVvJw--.49914S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFWxGr1kJr1xZw4rtF1fJFb_yoW8XrWDp3
	yYka17Kw4ktrW3GwnxAFs7AF1IyryfXFWfGws3Ar98uF45Xry2qFWFgry093W8Wr4fCF12
	vw4UK398u3WrZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07joSoJUUUUU=
X-CM-SenderInfo: pzdqw5pxhzv0xbn1qiywtou0bp/xtbC8BY7JGsGptaFlAAA31
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 140CB40006
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: kxhq8rua1d4g1sbmjqmq5rzqj6ij4gde
X-HE-Tag: 1795598085-155113
X-HE-Meta: U2FsdGVkX1/wbGGJe7OqJk6WkCpj9RfUq69BsLfHXuAIr1Jmh+v1wvOsubhdWW89e2YZSC+OLUsjnyk/5RR94d+rBa1o4DZkWPyj2BOb2WHon6Vmnw/UYkWU3iHQJaPbuDOBljh5GkH4Mr55qPiXAQ4sD3KG5CkW2l2YELKP8sHzfR38pYw/ZuVU5tW8PHLSoc3JpdJ5zp+j36bSaaLIdQUubkO4UKxNMo5Iyk3kxwFRmn2OXtvtyMbnxC6QWXyeX5UX31rlc9fBaYkCUCcQhyJQ9k4CcOE5oSPqwPFmj42IelaneP9R3O0C9T6j7Ye8evKW3dHZMTr69yDAe3hs+8evObAfjRESTk4ZwGqW2ldGbQ3zuDlglkIkdq5SCetnH/43gg9IKENEC8dJd1ZK0gjJyaaLn2a/7Kksq7nmZnOcaqItNp35Oz4N3LYdjIK369LoUr+PawlsVlFbcPYvyeHMbq5+BjI1iGLliAXzGL3WR4ZyLEQF7SZlMoYQaigXy6WX/Bl20+f3qUBQJImnMMktOXhhcxIccRCsXrN3fwd93YdSz8CuUe8WCG5RoX9J/pX8+D5T5he4d2wZ21W//+trtwjCrhVECXsqjUwFI6VgJ3uzA4Y1Al27Asm78j6yV3mq6Za/m1LFjCxojIOtgyh9C56RX0ZCM5HB+zw8dUjPSE8SFH94zuq9UbEdXTmiVUTtLNH/fZCMHH+nCjSXBGm8en7r859iF6pMdw5vmJa2px14IBykQIYM5yOeP0egp3RFE7cQJD0e4lC7i0zht3NmMfKQ2GdplD0f15vz7WWp4y9pVz2/NRQPknObc2slMvbpNETzKraPsZdtbSrf5/DaW7ozKIs7mkU4oa9cW3bhOhFv+hL/tU7/ZbtmVDOBbzCGTHi957vaBP6JHbifk0doIFXUjKYMB22Z7mutVTpFTSFlptTX3VuppbFmZmpLzYUGgK7tSJEPNXso/hO
 fZlk2hSe
 BEXifwsywg3WXs0NdY7C8+dl4AUBD1+baDdLd2+gWxWKks9tDP7KNTjZAVx9+uUmEx1WHEXeJMvP385PYay4uof8K1jRJysWPyMsE0q747i9Jizl04RcoaYPcuAgk2wRyKf9cHvyyYF/dzGDEITjTWtupA1/MzLLUBAWuqlTc/wQlJh96LMnK9mrMx5ILmHnTqoKrgOIJ/asFRAP1ZusHs4V3QVVQxDpSSm26hUbsV6DL8/ORlUGltcHgn95ZSSYBORHrYWiAPxHyj+Tt2ehpS0jwkimo/utuVryoepe0V49C7lWqWQpJhWwxBY6aQEjXVqX5mgGERPHpMZRyP0GaPVCujVsxDWTzLDsrUoO6mofxja/uD5zm3rAFXuruKCXYFBTH5vHZhvlWXJU/PkR06mVOhFSBmaBGmrM048a+PRUsxiXxuHNkjWHeeJOvbvtgxt9cQJ17Rf4WYKhxq51eywMPWlPhcL/IWfi9T0KFhlqv5laKVxQT89Gdr+LdvtwYHunJJi+HN4Ee5grc7Yw2dikNO8W7q+fIXUqgQGItfjVDwmFNtuw3eO/FDNMUdeQUWRBSZajXSb9LHWb/OfRysC4+zA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/11/25 10:46, Andrew Morton 写道:
> On Wed, 18 Nov 2026 10:12:53 +0800 Xuewen Wang <wangxuewen_ky@163.com> wrote:
> 
>> From: Xuewen Wang <wangxuewen@kylinos.cn>
>>
>> mark_page_idle() buffers bits for one 64-page bitmap word and writes
>> that word when a page in another word is encountered.
>>
>> walk_addr_ranges() tries to flush the final word by marking PFN 0.
>> If the last buffered PFN is below 64, this only adds a bit to the same
>> word and nothing is written. Otherwise it writes the pending word but
>> leaves an unwanted PFN 0 bit buffered. walk_page_cache() does not flush
>> at all, so its final pending bits are not written.
>>
>> Extract the write operation into flush_page_idle() and use it both when
>> changing words and after either walker returns to main(). Clear the
>> buffer after a successful write and skip writes when it is empty.
>> Place the final flush before the no-summary early return.
>>
>> Use 1ULL for the bit mask so shifts by 32 through 63 are also valid
>> on 32-bit hosts.
>>
>> ...
>>   
>> @@ -1364,6 +1373,9 @@ int main(int argc, char *argv[])
>>   	else
>>   		walk_addr_ranges();
>>   
>> +	if (opt_mark_idle)
>> +		flush_page_idle();
> 
> Very minor, but we shouldn't exit(0) if that flush_page_idle() returned
> error?
Hi Andrew,

Thanks for reviewing the patch and pointing this out. I've updated 
main() to return EXIT_FAILURE if the final flush_page_idle() call fails.
I'll send v2 shortly.

Thanks,
Xuewen
> 
>>   	if (opt_list == 1)
>>   		flush_page_range();
>>   


