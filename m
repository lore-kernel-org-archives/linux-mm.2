Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9FD606A32A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pek9s7zB
Received: by kanga.kvack.org (Postfix)
	id BA1896B05C6; Mon,  9 Nov 2026 12:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B51956B05C7; Mon,  9 Nov 2026 12:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3DE6B05C8; Mon,  9 Nov 2026 12:48:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70F7A6B05C6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:48:58 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01414C0763
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:48:57 +0000 (UTC)
X-FDA: 85416316356.11.40C0E88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 33FA080003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:48:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pek9s7zB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794246536;
	b=M/MYroM0Gwr9ILVXR19ldmbEiMlLorwfRN/9EqGmSJL4yUamlHhpnZVqHwKgpuf8xr7drJ
	ytq6nCkPE7c/lrJeQvByKY8RALshGWSVqVq/AwhVDXEIvvND/haVOVqS3UQKFBuVQJxHHi
	l6/wc/eQNLTcrwg72UROPzazv12iuaA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794246536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHxEdjexbDAxhEaz003lOiCE3vg4apNJPfNwG6nSAow=;
	b=6t46cRadHUkpWbeqePMUHczSuzZ5Smhtu2WLPiOpZ9Frr4QHKbgdh+kyh46lk5wTNoX3t2
	Eug+bqJGySSY0h4CjeFOtj5o9kP17m9RISh9Ar5k4Wu2Z+Qqj/H/yB4HKY0MyeCoydWDbm
	IP7Fyzuq0gv5zcxgM4Gib4tVCQIRWnU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pek9s7zB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BCBA40208;
	Mon,  9 Nov 2026 17:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE031F008A1;
	Mon,  9 Nov 2026 17:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794246535;
	bh=dHxEdjexbDAxhEaz003lOiCE3vg4apNJPfNwG6nSAow=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Pek9s7zBH0iPwsSpcUG005YFC1HK89pX4jsQNNeogHCzt4HyJI7X/6lZf5+7iMxvc
	 rXQIj8PlSNmYODFFj3rXKyfHyW2qPFSVPc8dbbTFYccpGhJtNDSawBiSC5j9x9sxed
	 Olr2iyiFE3ie6Jw2rtzed5xGk2A9JiOt0cbquzPkVQSveOB7CQC1IJKgHX/L/OPmUh
	 PKo0zYmMFGSKAJXUMd9+fwEbQ4vNbukBOV5EsWL3wuja6tSb4TAKLpxGLu1BYHQ3TR
	 kjxMEhHWj/i76fDu4ytgwvqaaqRAlhaIncCx2xVGCxVf0hHuEl+L/KVequLYiOHkh7
	 aEHPTMDRdPT4Q==
Message-ID: <befbf3e1-d25d-42fc-86df-e4b695b017a2@kernel.org>
Date: Mon, 9 Nov 2026 18:48:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 03/18] fuse: don't move a folio with PG_rcu_free
 into a fuse file
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Harry Yoo <harry@kernel.org>,
 Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador
 <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 "Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Luis Chamberlain <mcgrof@kernel.org>,
 Ilya Gladyshev <ilya.gladyshev@linux.dev>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 kernel-team@meta.com
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-4-kas@kernel.org>
 <f21433af-afc6-4a8f-8d2d-3a377cd3bd6e@kernel.org>
 <CAHk-=whn=xc9J3qApHWRGTaBpwVRtGbvJ0LURGF=dqC9B3swUw@mail.gmail.com>
 <CAHk-=whhp=Q8qR+wPoM9+mxYPQ_OXMOEoKmT7J0JZikFZusuqw@mail.gmail.com>
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
In-Reply-To: <CAHk-=whhp=Q8qR+wPoM9+mxYPQ_OXMOEoKmT7J0JZikFZusuqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 33FA080003
X-Rspamd-Server: rspam12
X-Stat-Signature: sen5yow8heaiyg7mczpgw3sbg7uozoph
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794246536-438702
X-HE-Meta: U2FsdGVkX1/Shsioaoxw0ubpPaT2toFONWUius6mf+aXxMiJfKMAQm/tmixn3lEDy3L6+IHmPdYA9N8l6RHMTKyPeFBEGmWVX8u+cKVTmakb26DiAp02uvOKnzsSfW6uOXeVArUSOiN4WeLNh/vTr2sNuwWx37ioVtWQyqrapHikcIX6YNAAnof/H+4fsNlbZOjGL01tR6bDYY5VlscvCMkxdPL2s3doiAimSZpZmuwoH4O7HgIPK0XsYxF0uYbiBjdgvkdEeveQrY5vvO+ftCXrtWQxzhsfcn3M2Hgb0+rg/QgkzCl+ksFVWcWLZSXZvn9q7Hxn/OgekXs7aBGDEGevBbqKXbeSkEyWsN9gMGBjGGzY8IhVZOGaBBLwmvaXw2woDte3kaIJtuvp7er53MPow2P9ZzyczMEp9cXaVdo1FMcD2HEPgllGX+LIjBQ46PVBVtSv3DG9mJNtoI9B02bhbBMZHDjdEOR2/qyFOBLfP8l0zecze9LMHggFtNznOOSTYsZBW5e/dp4RaQLLShuTuNgng0COegIpDEIDYyPEy9YO9xZXlFZlEAp1Mc+4Y1uDx//mgqzdHPIFbXPVIfqRZXeYMFD7F96qb6U7/XXI7HM3xvFRVceFZ3JrBt/TH4LzNUH+zs+ocCwzdBmUCOWK/gsLCCUZAEcFnPedw1eDNWX8Dhrbcdd9owcUXw7+25V65EfRPVsZ/6MDq/Xc5JlnKaM97fHeTzXttekUF7Oau0FgYuZCGhRoTq5XfGwkhjKbz0ryoIFUtwXfNH9X1yxKStlfultgFG50WW/YRj780IlIAzm4v2OANIkCCxlRuFREltEC7njgdpa8MF6a4rBsDcza+4CaPlTO3nFtwxVfAXudltvJNhpVo27agAP80hmTriTnUdEPZTSQB8dMkPk7J5k84D+uWkcnYe4L8FT2IICAGJrWlNsD24IwNF47qZYUURVjwPMpErWYIQq
 kPz43F+L
 VK+IHcamzJx/m4zOAcdDEQuoidgTX6JCei7y2W2wsQXAlxdg7uhuPlOCZM8TIHXy5J644uKd5WgyP+BF6/knBtfY0kmiWxL9Xj00U5ze3BDmdrDwHsExA5aKg2egCIXq2x+n7Jbgcu34MzgVYk5Qd/+s8dTm9pJOYRyke/XczIRlrVGaslWw1lOrxVlnndM7ILX8vXd9zjyUTmRS3qMyFafMFfoQ8jg6yDrhFyE2JDR+8ifR6B312QUmn7+Ivub6yqvawVUMHwXUcrVRdABOBveg6x5Xm+//gGp7IxsoeAR6LVoN+BzOnlLBmG10/RcsYiyX1h/kUNoA0Tox/fKTzQKBB6JT7+1XAH28s+v3exHwhNj8XXtWFkbvICxRixkGKk9QGSL/LSP6e8OfqskVv54tCORkyFkpFq1nzwkrXMwqJn1aPxXyqpDQHy+4GxwUVvc3Wim6NoRMSOgZAoavlR5B8a61ZOhQCz7SvCojmKTstLUtcMhoA0yMiF/SwXxE0vNu5gNy8K+xc+/3I9/gSdA7asOOwn+s4pRo4sqtLXk5vje0Bvyq8xxhwR4mm2M62FJkVBrteMXvTNQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 17:35, Linus Torvalds wrote:
> On Mon, 9 Nov 2026 at 08:28, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> On Mon, 9 Nov 2026 at 06:46, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>
>>> Could we get rid of fuse_try_move_folio() entirely?
>>
>> Please. That would be great.
> 
> .. and in a similar vein, we should get rid of splice doing the same entirely.
> 
> Kirly's patch to just remove page_cache_pipe_buf_try_steal() entirely
> (ok, it was originally mine, but Kiryl took ownership of that series:
> "Tag, you're it") is worth doing, but I think worth doubling down on.
> I think we sh ould just get rid of 'try_steal' entirely. I don't think
> anybody really uses it. I think it exists in fuse and in the virtio
> console, and neither is worth it.
> 
> Removing pipe_buf_try_steal() would basically remove all of
> fuse_try_move_folio().
> 
> Conversely, removing fuse_try_move_folio() would make
> pipe_buf_try_steal() even less useful than it is now.
> 
> Just remove them both. Good riddance.

Yes, that would be very nice.

-- 
Cheers,

David

