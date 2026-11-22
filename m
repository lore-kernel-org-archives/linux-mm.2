Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD738606A6AF
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KRsIXVOv
Received: by kanga.kvack.org (Postfix)
	id E43966B05B3; Sun, 22 Nov 2026 11:14:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE846B05B4; Sun, 22 Nov 2026 11:14:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E666B05B5; Sun, 22 Nov 2026 11:14:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9475D6B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:14:55 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2944AA04D0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:14:55 +0000 (UTC)
X-FDA: 85463253750.27.CD42768
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 58E12A0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:14:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KRsIXVOv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795364093;
	b=SyG5Ns0YK8XuDCmy6HVEogJTKXTq+ne/yYojrU1LXb33LD1RkUU7b7e485CMRK46cnuqy7
	nw7uWOcIuHAnSpJCn5Lvm2lA2UHg0WRJ8ezkk1/jwFt/TFIFkLIOxiKSkOGLK0hSAw4EQR
	3TEakpWwjLCUCqvlMlFrNC9xjtUjcHE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795364093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0XQPV+kx4upVZMbk4LNgSWgp4hVc8/l0NFR7dE4f7k=;
	b=O71bbbC6vy/e8M1O7o/Uo0R0BTlbVwHsoa+W3pAqTuYbjf3T+2HQRpos4udAVvWocrZW77
	7zztPPNYR0j57u8dCgQSxPzijGQ/wv8C2AOjTt5uUIjoxtn+0lAQFW7D220zQcZKpegEYj
	Q1QhY9NLlIRqkmgHKp4s/++lKJRVEDE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KRsIXVOv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B3A240232;
	Sun, 22 Nov 2026 16:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D214E1F000C0;
	Sun, 22 Nov 2026 16:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795364092;
	bh=M0XQPV+kx4upVZMbk4LNgSWgp4hVc8/l0NFR7dE4f7k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KRsIXVOvqYXoxEwFU782dp+LyTgf1irzunY5nI4cCpkfJH6//6Zw4QWkZtB9LQAbP
	 f904tQ0OgN+tUDsP2EcjKHiOME1qRz3Z48Ji8AfaMwxLpYvfeW6FUnS9YVwhM3YTLY
	 XEvD7E4i6XSXX85O66ysqgSYHbqSFq4jMawhGtnvOpwnYk4+ymjzpzBpaGYTa1yVLM
	 8pYPgk4nj5bp/xDZeh9vv70aeSEgR6te6q4iddfvTWJI5/umz1aK4q4KXIZm/M4W1U
	 6CYdYW7AgDt2knmuVpxcA+0tHAu38O6PB19J93HAeOb5jaWyQyLiuh6DHFWbdwmI7r
	 2JKeAsghKlt5Q==
Message-ID: <b9569459-cb8b-48f9-a2fa-233cffe01a28@kernel.org>
Date: Sun, 22 Nov 2026 17:14:35 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: make folio_walk_start()'s locking asserts
 scalable
To: sashiko-reviews@lists.linux.dev, xu.xin@linux.dev
Cc: acme@kernel.org, adrian.hunter@intel.com,
 Alexander Gordeev <agordeev@linux.ibm.com>, akpm@linux-foundation.org,
 alexander.shishkin@linux.intel.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com,
 Christian Borntraeger <borntraeger@linux.ibm.com>, byungchul@sk.com,
 chengming.zhou@linux.dev, dev.jain@arm.com, gerald.schaefer@linux.ibm.com,
 Vasily Gorbik <gor@linux.ibm.com>, gourry@gourry.net, harry@kernel.org,
 Heiko Carstens <hca@linux.ibm.com>, irogers@google.com,
 james.clark@linaro.org, jannh@google.com, jolsa@kernel.org,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, linux-mm@kvack.org, linux-s390@vger.kernel.org,
 ljs@kernel.org, mark.rutland@arm.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, mingo@redhat.com, namhyung@kernel.org,
 nico.pache@linux.dev, oleg@redhat.com, peterz@infradead.org,
 riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, surenb@google.com,
 svens@linux.ibm.com, usama.arif@linux.dev, vbabka@kernel.org,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, xialonglong2025@163.com
References: <20261102132416.300084-1-xu.xin@linux.dev>
 <20261102132927.301921-1-xu.xin@linux.dev> <sashiko-outbox-195353@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <sashiko-outbox-195353@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 58E12A0005
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: fnfzwm8b57x7x76gq6gwiqiy19fg418g
X-Rspam-User:
X-HE-Tag: 1795364093-613217
X-HE-Meta: U2FsdGVkX1+/mSV96ADIUOghMOMuUT+eAS52BCkUxsBFj+4GBA2lGgR9ScNJnqMO64OTXOMYykOzNjvTiKOzg7654ZIUeIFHkwpD6t+lRK5DsKdKlVqjOTsW6DA1+JOIhDcnGOggo7jDC8A3PZehdDTthUGWBFXRadA/tfMLkRdjM4qW1FjryiuUfuvucuiaYXnpTe/qYoOyqJXkVu5j7Py9PPsBX3SS9UzbW322uQJ7c9gvNmpahB2lqBN8AqasmwPe3amJoy4WVSkNkQXnqlbKAK7Et9hw8uJVM+U0CEiGMcptKYW8K5cfbNTQ4hm4QMOxGfwIlH5jn49OwDUny4KKSR1PKFX9qlcCntSHqGdbM+L6qgwK9jfaOSfLGpz0elXWpm1/ER2GecbxM+Pl1GViOingiv/IFhyMzdmV2Cg+iSrAApOoz45ANDBOWT/pnI9IYteLN1ZEt90adneN1dYxDFMgjYJRE8NxL1vjlh4AP19Fl1WDnRMnrHm3yQe27GjMRaXuUIdG9sWoAOhF+j9zmyMcqWPOGQ1J+G+Sz8myEFWoUCJI5JOTXNe159tmwCO1X0d8vYcYlV2oPISbugvOV3rxc2g12ocerpqIoTOzQ9EgMaEcnjzEQAbHYBRiFKNNRv6gNSYvLPgabhvYe72g5hjNPpyHo86xkkwEFFt1iXrrSk/HkzHQugakXdZmq4GsCHGXYSdMS+HPfU0NmJmsrRzHbM4hDpR3BFosIHhQTEF5z7fQEcTCeXq+HkqoxIfDOpCSEI9zD7i69c2nrBSDMVE9hQDS7IWUA7YMmQFB2kpJeGbdifa1nEl3+mSj5AxrPWzXYMGjlIH45THhPPwWAuUt5eNzcr1jXmRBXoL/adlLsBFaGcosYp1R2FM0AfvSzMYd0IkS6lfS7UVW9QHUUNgd6osP2zdsncgOEDSup72YibLwl9sZ8a/iSRKt76LdJWko8DdzKTGe7ZC
 NpInYtL+
 F3hoddO3s5Fa8kJlquUiSh5FXR5N5TKoAo06j930KrMjGaBXZN6yYMXZP35RMwvG1oyzAj7cGLRKMtt/cp1NXgi7dw/j5ymBpDwhEAK82n8IsHJalYKElzXJ7W1lyATYniHk7pYm/kKLouFUwwMUMGf66TqZ41ys6R0CdOrUFAO2MiEaIPgaPnRBniAgieIVhYJPFB1zEZfGTm/OTQukeveABq49t/LIzrTyB1frOfUITnoOUyDz5CuxOPF2/8dVZlp9tmGxmriUmDv5HZO6BlUlSzY/NkIavwZwzMCREjFYYgwaZrzHgcouJ1VY9fd2KITynYLXxdMMBfxw+00rF5416ZSdNYrjKGWduVenizUqjvWVJGzIXlgW3K27L9jd0Hl1CQXmjhP+7R0M+7cFfPVDmzixS4PSn3XOItvKQoAUtD6z7c39Y/9gsF1KWzD5FBBVWP8G3Yy3orDvJDK806cKNSKScuPBLSRKzPeUNf0zeFAx3cCJ8uQCP969DBuB2iCA4aINg3oq+6Z/207gpAS0EolVQfes/+j0cHKlR+l8bmkXWJh/qjvnO0Qg6N6dvAnur9aKPSkFgKZSCeCqpaJHL2abtP8C5oJCXNptEW1F+WMSMdMmMb97n1DT2X31aQq1m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 14:31, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Medium] mm: inaccurate commit message on write-locking in folio_walk_start()
> - [Low] mm: folio_walk_start() duplicates vma_assert_stabilised() via walk_lock
> - [Low] mm: missing kernel-doc and private placement for folio_walk::walk_lock

Can all be ignored.

-- 
Cheers,

David

