Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6525606A335
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EHsC4CTY
Received: by kanga.kvack.org (Postfix)
	id 0B3B26B05B1; Sun, 22 Nov 2026 11:17:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065AF6B05B5; Sun, 22 Nov 2026 11:17:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96166B05B6; Sun, 22 Nov 2026 11:17:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD6576B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:17:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58BF3806BD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:17:27 +0000 (UTC)
X-FDA: 85463260134.18.8D4E48D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 89E1E16000D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:17:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EHsC4CTY;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795364245;
	b=WKgjWWaEEaep4oboEhUslHPG5GLEf8ARm4yunszqqs8262nZpT6IM0DFWae5WbHkkQpDxh
	j5qiU7sC24OFnmtorZ9S7uU05E71B+eLKglid21NLfqxUuX2lrwcb4+a5pLgMR0Xl6D7b0
	XrSRyhn9zr16tKcNCoLMlRVO4GRcI/Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795364245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nR/Mv8pU+awzbKHVLVTOvIJwcSoB3/LbebgRm55ntSw=;
	b=ymg8Y4re3VjPiz2gkQhWzN4oKgc+35X4sbS5yIFiZ7YwAxLrcHKPSaEZskn700PzpADTc6
	mRcskvjrUuYtwHgPWTrbD/ZFvqBnkuU4cuStM09CgfGskH1bgORObwu5sVccV62lV8O/03
	8CxibZaLcDgDaWP5nlo+0vF9igEJfSk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EHsC4CTY;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12C3560D3C;
	Sun, 22 Nov 2026 16:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E891F000C4;
	Sun, 22 Nov 2026 16:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795364244;
	bh=nR/Mv8pU+awzbKHVLVTOvIJwcSoB3/LbebgRm55ntSw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EHsC4CTYewr8mI8OaADDEq5jIWtfCtl6qJKSpZCWS+G638u1IEt6FEddjKRZ/1mjW
	 iZ9bkOoAYfW6hNFTyBpzFs1sCJq1P32mkZ2JUK2v4GgWBNdBM7oXuciS59RGfSvxsD
	 d9X2GMgmRijAwtma/G0cv3+I/xsjjC7rYIGbaKPsCBNvIZF7jiFCdws8Zz2fX4JvV8
	 lyoGGSvbI2wnVbcexJaQe5Gxdc12IF+re7h6Bc9Kp9H7RQILVWIsHXXOx1Fm91JKWm
	 +cPqYYVeteRw5jTtrIl6EBP/JGBumLtlm5lLmwekdRW06eS1f5+758PSLk//NQcQXg
	 LLs/BqBJBrtOQ==
Message-ID: <a8aa2827-520f-4e64-92d3-776e891b3927@kernel.org>
Date: Sun, 22 Nov 2026 17:17:07 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm/pagewalk: delete the unused member
To: xu.xin@linux.dev
Cc: acme@kernel.org, adrian.hunter@intel.com, agordeev@linux.ibm.com,
 akpm@linux-foundation.org, alexander.shishkin@linux.intel.com,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 borntraeger@linux.ibm.com, byungchul@sk.com, chengming.zhou@linux.dev,
 dev.jain@arm.com, gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
 gourry@gourry.net, harry@kernel.org, hca@linux.ibm.com, irogers@google.com,
 james.clark@linaro.org, jannh@google.com, jolsa@kernel.org,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, ljs@kernel.org, mark.rutland@arm.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 mingo@redhat.com, namhyung@kernel.org, nico.pache@linux.dev,
 oleg@redhat.com, peterz@infradead.org, riel@surriel.com, rppt@kernel.org,
 ryan.roberts@arm.com, surenb@google.com, svens@linux.ibm.com,
 usama.arif@linux.dev, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, xialonglong2025@163.com
References: <20261102132416.300084-1-xu.xin@linux.dev>
 <20261102132844.301730-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261102132844.301730-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 89E1E16000D
X-Stat-Signature: 9ekieccjkhm7ne7rfjmbtjtx6yrjxn8u
X-Rspam-User:
X-HE-Tag: 1795364245-422151
X-HE-Meta: U2FsdGVkX1+vv66kQpUNVahnJQfb3YmJJo0U9KxTS481PIMGQxX7QmN8D8HB9vt7dF8/f4eXztDfEgsjWr6ljpXAnwOPEDvx7CPOOeanwMLtBuNuVVkbOlfc2/ehJ4E1xqJXIJ7OzuePKHWfdqkRUpXxhbf9fSmPDnRIWuBpwwtOs6JzEWSk2pGzue2+BV8Z2GK+WhV+6xZcfuDFX3qd7lco7/R450kUaff/Tozoo5vczQrwQ8mIIMJdCYMv+KOwGAKA39W6iVc9gbg8vZY3RVJ9GfAYUB/1tfOBMm6OycG+9iPawAoXS9zVcxN2jAqx2pzy893OOJL5kc7eceSKldUqvThnjaRa1j0kxJUO3+W4aj41z1OxMIdQGeXfw3+wadmDpBUZkzu2QkmaeQVzvbepZyBu95WHxo4lMgjDQ9ozIvqvet7i6aN7UXbYx2F5RIRPzPQS/VVb9OSxMcja+LqW56Qsi+n/J1OLJ/MM4apVtUCYB6WuN/XLloL3HOxWKiQ35NTG5xVe7Kj/jIz0czQLf21SXkcu9dlDbz66L96HOKSp7DzlYWFCu5C95tm3Lo1iarW+3p54IYof132ROYadB6RiEsrw/1tyAVDAdsiid9V89GsoZI/HxvUhNMsmo6gqtI4BJMJv0/KgfpoO+/JQi7lfCoKrurBS+7LZn3s8ZoPxt843aFoNAc/1aVh8TtFmWvAzydrxQCZoQ9dBma7d/coRcgAMz4Q8aGExVoqM2j8IxfV/YjKNDI1AZlOvUU3QIic+oLT+U5UHdVY+48aQnhXRBzVh2iP66+eC2PuttfIwoiolEPzcQR3xmJgMRFd+jB9CYodA9auDEy8ouyhvycrF/3qppGOOLtZlVsxxJOXC2c2+3ihbkxAvxcnvOKh6IDB67QfiaYXmo+jFPipdTX3UjHExYRMz6pjnbjb6dUTY9NJGpSglIZK4gg22cnNAo/1G/zRptAK8pRf
 QOrDn7IA
 6GgpCH4+FJZS6FqWUNHHL4aejj5/ZLqkEn+WfvU8tZ3BLfUp1GCd5e/tHmJLHgWs/4nybLrH/KiMemGeNj2JAUPw/WvUVgyBd3s8QMOXxh6TCqUkmeYsCYadakozNxXhQQ/90HAJyNsTx6GyAYq8FNjk+BmlmnF8ijiCwrj04rk+dWyUIUZ1QaD0TEQjwZaia2CTYyFvxxl9MgupHKJ7iAe5RID7a+OqHtBzQU3sdImH2Fg3wwcDjuFPdkLaqSH16DfNjHgDUi2ZSdda6+PHgaSZq8mYsfkvh3ZfltgcsKBmaU69Q81WfGpqUVJNcqx0Ej5xd1JmrOhpuLVoG6qnSyNBPCKN5YLY4JDjAn9KZMejBf5O9eFRR8WbtT+4RrIyvNGlZmmPJRbQ57hhgyqoo1WmCF9L6oTga2kPe5CcSu79ATdP9lh0ve8t7nyuRrQpER6O42IsivXyPdLDOlt6SLusW6RARY8aMB/mjsOqNG/G9TLtoaGOxmUrifywQ2NSI8i0XUmm84d172S+oUb21BY7zvckho5WOJ2Rdru9ShpeZhRBGUF8VOcdpvFPp21XNn3cOc9zBQhxbEN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 14:28, xu.xin@linux.dev wrote:
> From: Xu Xin <xu.xin@linux.dev>
> 
> The 'vma' member of struct folio_walk has never been used since it was
> introduced by commit aa39ca6940f1a ("mm/pagewalk: introduce
> folio_walk_start() + folio_walk_end()").
Right, I went back and forth whether to pass it to folio_walk_end() or not and
ended up leaving this stale member in.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

