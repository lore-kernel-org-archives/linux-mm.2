Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF47C79FA3
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751556B009D; Mon,  7 Sep 2026 11:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729076B009E; Mon,  7 Sep 2026 11:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63FA56B00A0; Mon,  7 Sep 2026 11:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 438E66B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:22:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCFD6A3CA9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:22:40 +0000 (UTC)
X-FDA: 85187333280.16.40CEE60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1C848A0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:22:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KNF6zczO;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788794559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iV4wmxbLboD5m61BUcdgszYN9JR7rqtg6uMfGNK+Pw=;
	b=bAeNgAQk9y9Qbgisig0Xme7UYdngfnhJY15fkLZ4KjWH6RsN0rjh2zZ1u9SH7y2TCs8tzD
	d8mgJ2rpHkMk7zewyDgNIItpoOORUBjoWs+uchEOgjlOd6BiSvfNxwS1PjDlgsAIs8r5WU
	c4qbGCoeXNcpimvlZda0bWBn10LdEl8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788794559;
	b=kneTDJ++M3Fg+T5q1BcbvcjyAF+7jStdWblRwJjg2XNG+VHFzcg3+iaRhUyhTKePTGKHEN
	r67EfZaSgwfNggfblw0MjU7g5OX59LifzX98N7yNry2NeUAYkg3J6XXthEzMJryGKHYFyi
	lUJwwEQpuYEF+pccSC6faQluyUg5vAY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KNF6zczO;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D9DB406D3;
	Mon,  7 Sep 2026 15:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486461F00A3A;
	Mon,  7 Sep 2026 15:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788794557;
	bh=2iV4wmxbLboD5m61BUcdgszYN9JR7rqtg6uMfGNK+Pw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KNF6zczOnUC280nScMOfHKGnsEhksMAL+0VbRvZvnl4CSfyvRBZbv2thM+uYmElMw
	 6DuJILmh6kZ9mgi6RDXXkSy9Q4WY/oeLwkQyCHgkxziG2LrqrmgxJ9fijG3M+wFwt7
	 Ao+SfjuFlLDZ0v0q7wt7jwoLje4eyliSQI4M2b8Yj0u5MLpzWywWt43ICRi0wfHGHZ
	 aE+nmclaBKRvpV1ZduOdoBjPHJqU3xePzHjV5pWdXZ1qzVjYh5rptcD/EDOuVu1ya8
	 CjTE1/jpB71QuGqq9f9mkKTkpPxAVDGuu78RBjrCNGSExCcA+6N6tvD+Ndn7fDl0T5
	 WNI4EWfCcaAKA==
Message-ID: <9a21fc3c-1ca9-42a3-a044-6421f20341f6@kernel.org>
Date: Mon, 7 Sep 2026 17:22:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix size truncation in pagemap_ioctl test
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org
References: <20260907135613.68692-1-zenghui.yu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907135613.68692-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1C848A0006
X-Stat-Signature: wfuoxpzu16zrmr8swiefqahii39s5poz
X-HE-Tag: 1788794558-565589
X-HE-Meta: U2FsdGVkX19pY2QSkY4E3a66x4m4gTTlFUYMp1eUTt00OhUsWUAiMPgfuhLIOlm4i7sWA8pJJf5erNtxznJgbz/IJ3O6TwBG9WeXRthuSSfn9fzQfFEIv5tF/zCnRs6P/EUR35nljcqYBHvI2iUz5wbPgYdEqXyUjV1TPyeysjqmcv56JedRSKV5+aOFONOdc2ZYCtRvEafNCffVUQ1rZiOvT1i+n84DkmtHCrGbXNcHF30QpRLO9RTLP//Pobxa1H3zioBYu2LERrgsGeI2dyFEsJLUBcPpkBAHT8XyES26LHooSqvN7/bkKCCFFBnZH1nio4UUG04mIw7mGeQOPgD8kBiEAdb3JCmDJNbdH23F6Ok9bhK/NEj9NxOkK4pCoB9ar0ojFS7cZhJAQXSAX2/NWZQC5rP46pkrR+ry7Ksrt1lAlhRuF2LAJBnF0w+WVzkgByi9fc0s4E0JWijZ7uJ82+HBBeIWW18DfdqNgAZkXAixod4Z54hlJ64zX7nuCc/oqhKaVdF+lMN+vfDiMl3T9JhPqnEj9UVCdkRY24087ErXingOFCuUnlO12Wrgep32306DmVwzz0e92w/aDKbLNeIoEfHwZHyVsrFtzKFchLxje6FrnJ0Lg4SgVo7KBlCH/JZMn4S/6YsilNwyj8PKQcuSb4CxrzcMvNSTIXthiOOmmxblmCh/TJJ1G8GdjxTggcyvAhVlAd1sFBt72rcKYo3rHBzD6hHY98qpF2uO4cqWxyae4y6hV+40D8VlIe3+KGStkIhiZSxzHCfXwZ8Euz2OVzV3K0BLpHbSbBqI3i7ls8u6euqCleAl7f0BvVJgxiTxFEtJ5yXqhij3ykoXdrhiEC01ojC1RRd3gvC/w1QwVUxdykAL1JkSvot6IUYWRQ/3FE3l5bsSKRuMTEzGBtPXSjtGxPhlH1QpXiUdPW3TU4+jgRQBpJAWEQtI/WmAs/ausKnP9ori7KN
 eNk1TGpS
 4AqjyLYQOd1B4S/59HeGWEZDhIrE2odd9BOwXiL6w47nqUdoCVZ0af4Q8HwZAyUmLge2gmwVlJ1hgbn87Zqms5IPqbDBwl1j+lnbCmXKIYF0fcFczVV1yzgYG91oas6NIfSikNHPLxvCTRH/8JIj8MA5VVItGIrNJIHPM6bY3Msy3zvEFCqq6YBX3cMss2cn1JDKAwStIR+wlk+uQHObygThgOlW9Ln55OX23ZGeHORd7hPAoDk+YbWVb05zYJ/nCa04k8BEwpCn6cao4OIONjQEvNRdsf0IpQrmLeTpvIs0LYwzpuDdj5R+R8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 15:56, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> On arm64 with 64K base pages, the huge page size is 512 MiB, and
> hpage_unit_tests() builds a 5 GiB range (10 * 512 MiB) for its tests.  This
> exceeds the range of the int size parameters of gethugepage(),
> wp_addr_range() and pagemap_ioctl().  The implicit truncation to 1 GiB
> makes gethugepage() allocate a too small buffer, while the callers keep
> operating on the original 5 GiB range, resulting in spurious failures or
> SIGSEGV.
> 
> Change those size parameters to size_t.
> 
> Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
> Assisted-by: GLM-5.3 OpenCode
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---

Looking at pagemap_ioctl.c ... I think most functions should actually be "static".


Using size_t is ok. But then we should also change "unsigned long long mem_size"
to size_t, no?

Also, in wp_free() we are suddenly using "long size". In pagemap_ioc() we're
also still using "int len".

Can we consistently use one type please?

-- 
Cheers,

David

