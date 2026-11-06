Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BF5606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=bGuAwZXj
Received: by kanga.kvack.org (Postfix)
	id 1ABB76B05B1; Thu,  5 Nov 2026 21:37:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15CE06B05B2; Thu,  5 Nov 2026 21:37:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B5A6B05B3; Thu,  5 Nov 2026 21:37:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D14FF6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:37:54 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D946A0CC3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:37:54 +0000 (UTC)
X-FDA: 85403134068.07.7D91F31
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3907A1C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:37:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bGuAwZXj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793932672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHeH0IW/I0H82vbyYEbCANX2fIPlHkjru1hf4L33oJk=;
	b=3HsZNmIPdb7pbbo/e/kgl9zfLTFnb4c0LPMpyeG0zMG4j6UBeBcPeXxI2P7jEL37vKtNyu
	AO5dwYf+tviU5fbCahoBtvZnBn32jNW0QrqTsRmSItX/lTuBc5eCpor7DIyq0FT7iaApTx
	0vKcnknHMoLjhT3OJG10jdPf1UEvHgc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bGuAwZXj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793932672;
	b=HnYSiNC1uauTczkQMacbAYjiEqkBl/S7PWW44BJtrUEqcjjDWHXUilb5V+T/3mcaR1WtrC
	uwVkMn8r1HquYU/83CpeDp4OCWBpW0wZU5kmGDGrbLfuymp+9TzLW0xRxQXZVK/bqUSSku
	4+D86FyhaW0q8T+03R7rtwpmwdUKPwc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793932668; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VHeH0IW/I0H82vbyYEbCANX2fIPlHkjru1hf4L33oJk=;
	b=bGuAwZXj6Ioko+pA3aD2Ps1kMh33MvTko6TZoxa/v9GDROZ2ashlQevxgJK7ccP5WkP6GnL+RU9rnP+7cd5freTbEx43SqOWn2TPDeHOEzw/Z7oU/GtBH3Dzn6LkxaCow7hgwzs0psZON6wytF3R/WYzuHC6j7Aazn6JOS02Ij8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XEA2RB4_1793932666;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEA2RB4_1793932666 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 10:37:47 +0800
Message-ID: <58530883-4b3e-4e6c-aec7-4e551cba608d@linux.alibaba.com>
Date: Fri, 6 Nov 2026 10:37:45 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: skip split_huge_page_test without the
 split_huge_pages file
To: Sasha Levin <sashal@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261105030242.1241448-1-sashal@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261105030242.1241448-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3907A1C0005
X-Stat-Signature: xcms5ph8si84twh47dgas18qswqr4h7b
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793932670-32499
X-HE-Meta: U2FsdGVkX1/9I6ouWUcodtGyRMIrxYqRGcrFLonrd3kCa0zYVFzajXKRkXx+eaG94rl+uVioKWCQ5uU7xfHzc1MdEBqoSAw1BztiiYlvC0IoxPSG+CAThVxd9/81Ech1FeZmDZJNV5i60DU2k1MYM5gl9p95iPFuJvLDnuzgWuWSKdxBTONkVTjrH9Knf4xpTLPGnWuoO391uD5kz944SuWz4obj5UO2nYQjwg81pDHy7W+uBA2YaBqaahJpe9vomfqL6iLF/s4VXP9fYwppR7xG1f4i638QspVV67V47Vcpo6y8MK55dmn/qckxFiHXgKy2WI+LUow1/LTgyk8ZdKnm8Z10CxnSaQsY7Rd0bxRbxyV4eHQFwmYkdNbcKtpiDLqXGWQe3fIIsUX6N3/iehcWgy1+G53aKSN5/ANJqFYykZ5U5QHy8h4xv6kMk/uUiX9jZ6gjuaT3WNvv3cuvllpBTrp+I/mNGaRWsPNL3r0h9EjgEqkVZRKFmOlLbtFw6rs2vPxoIkTwDO02tqQuLubLJk9iDWPCPXMrBUqg/lLDXiQq31053mwskJ3PuOBzkfn5Q4+O+5xJo+EW3QQYk5/Z6gNQfup/aevwsJ1cTiTX6J0o9rVUuWTcpsodk6pQp9kwXc5ypBdFSOezqwkuSl59tEAR32/wqZ5wn/2CXHfwzR6vA5bQ9fIeHtnxbvfi1c40CmTWTefjxyoQWCA+y7mBF2sCmbgMUz1Aa9Xkmuixd0T8rTyde8BXslsr8ALhtrea5g0OTQ3HaHkKrCt1n+r7b4k1pZsUukejGvsuzvXq6Y8gixkF08qJK6Bc10I6zzRfrPDMM6u1iKVp0SHB60JHbK4rJMFgBlpfNIX6bAgwOmeBFb0xOuyqRRFZBrUfMgCbSHpvmPlSjKlTGhoRmQ2nZGsWvBrNcjP8gcmahkNZaTDlB2IopmYKzREU6bpiU3IAr5KMJ3xZOjk7+Bp
 g2BIoSkv
 U3kTWy2U6q1G0JHLTFmATazz7ICr2gnCUTDV91p8mDIzyeIMwAbOwf+/qnSw95IOO0GmuVPOk2MYc0KrKXQ1KWPopDcqAaZX5fKSBWFLSap/W0GlM7Qr74FPcc/q07HopRLNymags6TLjmF2GO3YshBCAvDPfj8MypOulPwcydIpijHx2tGD0ur8OJ+fel2hXWE74odYFza+P3waLjWGiSC4sd+kemp7CRdAJXjfQr5hMNKu8vsWjO6tDCeLeGV4XNTkBVQEIbfDfmTLr84uOld6lGfPX8JXc+etsAvmlG0MhYhLC9Ot52f0A4NzTadfVSASBXhHpooNppHrvf5XsMmy1bC0mNR7cFe0NScImdZnWW+Uus5uXm/5bPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/5/26 11:02 AM, Sasha Levin wrote:
> Every case in split_huge_page_test goes through
> /sys/kernel/debug/split_huge_pages. When that file does not exist,
> because debugfs is not mounted or the kernel has no CONFIG_DEBUG_FS, the
> first write bails out of the whole test and it is reported as a failure:
> 
>    Bail out! write_file(/sys/kernel/debug/split_huge_pages): No such file or directory
> 
> Skip the test in that case.
> 
> Fixes: fa6c02315f74 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

