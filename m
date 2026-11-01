Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0420606A32C
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eW7Jg6QJ
Received: by kanga.kvack.org (Postfix)
	id ED10C6B05B3; Sun,  1 Nov 2026 13:02:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81F46B05B4; Sun,  1 Nov 2026 13:02:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D983B6B05B5; Sun,  1 Nov 2026 13:02:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5FBE6B05B3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:02:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BD43C095B
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:02:15 +0000 (UTC)
X-FDA: 85387319430.11.4B869C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9344B2000D
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:02:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eW7Jg6QJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793556133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PqNiwmu6idHErTlM4aRyLM7lhRtmfiQPGaaL0E482g=;
	b=2DDAtZsZNBxA6mcz8U5W/TK8s11nGVX3pjlvVEm4KO7ab1bv13ttOFyM7FXtYm0r+M7DIS
	IbRcUp6wuZfmCPaMb7KKdxRupWCki1zE3lBDr+HrqtFQ8YKNN3nraGHH7QYvRQWRiSTF2S
	Q95HfrmawVBgiOUAa7UWYlpTn+YnATI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eW7Jg6QJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793556133;
	b=Ii8MaUeT0qVdLhKCKLppbdXPHrvoGWpBdssYGTlBSf6rTA+7m6s/KHjMFBmNZVHy8BzSVU
	1wgQiHbd63XIXx1k/Z9ViA8ATC4w2tQIoICTSCccQbvI5jNvRAbEqqR7tviYPFoH9ORz/I
	bBvFkw3IA+2qXwTLvOjZvnzKQq/gk18=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2071060054;
	Sun,  1 Nov 2026 18:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAB01F000C1;
	Sun,  1 Nov 2026 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793556132;
	bh=3PqNiwmu6idHErTlM4aRyLM7lhRtmfiQPGaaL0E482g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eW7Jg6QJYxgjLyolk/6DfzEGYux3I7G6ldXSplLfTtNGZELaDfTuN5I8J2EqURODN
	 xpdN1FFl631aeqAs4oiVQb+q8AgXpdlK27CVhtweeYfZKR40sllRwmHOJUItRVxIHh
	 zEDIYzx7J0d2WjR5x6HMW3AgB0vunQ6ghpbWLrpAs+5GKbFNW+l6fWNhQr363yoHzR
	 /6B588wGbgrW6NOlHgre+rLVWTnNv0Bbsy2YXFFqZibH9S07UXXG2fBcQuM4Hw+nh0
	 Nqh9spsOA/d7B+9zw7QdP2R7HtpjbXaHv6jMa3mUVMc0a/WCq8BCyBWunei2L4bJ4X
	 P97Ey2VUelDQg==
Message-ID: <96fbe172-0b1d-4df0-b73d-432bb5df37b4@kernel.org>
Date: Sun, 1 Nov 2026 19:02:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] MAINTAINERS updates for page and slab allocators
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
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
In-Reply-To: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9344B2000D
X-Stat-Signature: 1h4jztbobkoq3tncbe4cocsynijc4hns
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793556133-702501
X-HE-Meta: U2FsdGVkX1/bihg6OxEAMMDKU9dDjOyfLHGAK+lFjtXN/Exq5R/ZkC58dfOXKds/vbSllhnU3cje7IQeogapFepjwoJpGLtqDWMPMo0a7A8vrtZLogEkYqgrZhry56cO0ojvHbFx/SUwH9NK3i+AVHjUY0jy/q6fYe9NNBMPl5yKecbQ2UDReoyArHAkRoU6UhTb7yyAuHUc8/xBPEMhDBakap8eTaVEJUZXjBP4KDQ0JXv+uIyxWlLag8nABWJTkUH9sOgMAzNovvptsVLO6aoidkZ39OavXXJojjKxVmk++zeEpJxSk6zMyEmXK6gbNIrJ0LN5QnONJ9P+EkdwX23JTH3JE+ck9+OOthnZML9mb4cCKNyhAOI1f7Kmw/9cdX+O8C6JSpN3F78d/USQxwz9k6EIyDov/T8dHg8Ze9OheuywgzRS4fNwS4NO4OuCNxMMnDdYdvIyHtGfETePjeJE8S9mebbal0Y91J8Z6lbF6epoxyjDZJtx33Jy8h5VgrS9Xa+drrLOrjwJZoDMRqERiPOf7MMYH03nF21DBJhyjcCJi+EnW6F1z9pnyAdF1NblsfJSXTA4TVggF2duwvgKMmsuPZfRLsLkwbld6obI/gJ/6E9BV13UaF0/y5OEyl5EmcIuCKw6V6uJYdVVRdO4B2yjosmY6RUKN+8hnS0K9mCpxPflVN2O0pPtK6xYNSj2YE+pEMBY6IowLg+Abgtew0U2L38/7cXcgePhq4e1avcPayC9c6rUPzLexDwTi8z5ewygYL6LSvMAo2ODm75GIed3u8WB25EMYLEBFVzIa0AuNucDHVVJ0V+n25Se+DolUgjDXDjlt0VJdZrtd55Edffrnkv03zAYamIku5GDJYtFa80hm+XvKx68L3HWmxuO1qHm3RUKzrpvobfRjeH2Prmms4coASA4cepMuybCbpxs6eHT6XxI+9i5nSdoOAIvPzWoz+NuzX/L+94
 SfxUjJGl
 3D2QI39EqFfF3guL91Oma24FTRnNaurDji9vbjhtZC9qKBtYFLOCqa9TuPVy+H2WrTlLQMaMoHoEUknH2QZqLNxWDBlbCc2RFbRx8fm4EidrmRTaioGLwNLNsB6drRc/6r4iUltRPENkaorHq2QlQkXmYSQNW0juwNystCo9T87IM2DqqShJfiRloM/JCAXHG/uoiq0aWA+UXPGbR3w8s2SFLTrfP0Uvwt3XA7Ibgy5Et7CUN8Kx/12PMHzetGK4PBVNk6NG8Qcv22Zgx6FkbLl47Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/1/26 17:34, Vlastimil Babka (SUSE) wrote:
> Following David's updates [1], perform similar updates for page and slab
> allocators to indicate the MM process transition for these
> subcomponents. Importantly, add Johannes as a page allocator
> co-maintainer.
> 
> [1] https://lore.kernel.org/all/20261030-maintainers-v1-0-97278f8a5f54@kernel.org/
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Thanks Vlastimil -- and thanks Johannes!!


-- 
Cheers,

David

