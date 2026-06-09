Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7DEACD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379EA6B008A; Tue,  9 Jun 2026 05:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32AC56B008C; Tue,  9 Jun 2026 05:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240C46B0092; Tue,  9 Jun 2026 05:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1728E6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:08:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5284A0413
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:08:38 +0000 (UTC)
X-FDA: 84859798716.06.5ECA0A2
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8A991C0009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:08:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hfr7GTaI;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bk+cuqVkiscfXQOg4Fx57mt0jx9ijz84xEuHbEOrHnY=;
	b=NLgTCfbd9RwKbl2GiqT60u75GnUtum23W7+11Z4s58SV1bb2vnzE9xiqLE6V+pCur4ZaCz
	q6O4z3wONu3uslxH/bFVdpdjCaKWIvZGYfLa2OjgOEzCVszCUzVDLF1CIdJE3kAy1KQycD
	yxIaPcEKE+Dv768daEc0k59tTDCu/xA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996117;
	b=s8z1p6Hqc54shPiG2EL2HDHnpDVGvMHNDO9HXatlRlz2gooZ8cGcsdwjHG8HeMODDQTC/p
	pCi2DKB4pLSBr833Y3GkjFWN501d4VaXHLMzdYcPuezZg9E/5rS+vC4lkWvLT6KwnhMneN
	ZENKaeSoheKU4UssZ6rbXNfDkGXVwOY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hfr7GTaI;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <f21d7c12-e6c7-49b0-8d83-c26946d0d4ee@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780996114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bk+cuqVkiscfXQOg4Fx57mt0jx9ijz84xEuHbEOrHnY=;
	b=hfr7GTaIOxEAe5xwodnf8gchpVC+CiIkwRdFShplJcUJFtzPmOK1trlHgkVaZMgy9vt+zM
	+j/MS1T1gPELGLosMYUNtpIGnqJcb/YWUD5btv+XufH/GnFFMvuwx5Sdpu1v0Rfj92qnKZ
	GJ7UF+QuxRptHJRUZ9++OfMXio3i5ic=
Date: Tue, 9 Jun 2026 17:08:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Breno Leitao <leitao@debian.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
 <19f968f5-1289-f573-4406-e5c91dcd8923@huawei.com>
 <e3d023f1-ab6e-4424-b304-55f1294480c3@kernel.org>
 <33ef8821-c809-b7d1-ea77-6e8a07a6e784@huawei.com>
 <21732071-14a1-486a-951c-34de97b7c757@kernel.org>
 <4b27467e-935f-5587-2f48-5a794c30a592@huawei.com>
 <aiKXrovzrNN-gExm@gmail.com>
 <f1a742be-80cb-4256-b1f9-e50a0f83cb15@kernel.org>
 <aibN4osY_QF1Rejh@gmail.com>
 <4953bcee-5a0f-2bc5-7295-63e5e7513e8b@huawei.com>
 <f2a4d5c8-3d7d-4fc3-8769-66e0c24866fb@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <f2a4d5c8-3d7d-4fc3-8769-66e0c24866fb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8A991C0009
X-Rspam-User: 
X-Stat-Signature: 6jwfjcgwp4bxauy5xd3mkwumr9hnygxq
X-Rspamd-Server: rspam08
X-HE-Tag: 1780996116-538354
X-HE-Meta: U2FsdGVkX1/p7qlqxYb1loHKk5s4ohW2JqaeEpbn/JHZmyErbDKDlcV0AiewQUvrdgZxxBiDHes9KqwwthEVRjj8aPTPprBuvWCaLzGQc9Vf93jVd5U+J/EoytrjzHmlc4ihcJsRKPrhtNMh53gQrdUppm1UQStcPAwpcqAWIG1blKQxEuYvcd4m3g9p026e0HXcRQlSDl6emf4dAmJ3uZTdwqV/JWus0UZgPN5IapDsMqZernLqkwJHxf0weVbL5LST74rbVfL+GsAVPJLs3KcpyNtIJylFIqA0JJ4Pm1PNHirzLvIXI1AV6HDsBU6v6e/eF27aPmw5sFnxzV/BEL/EM0PGKAbGbs3r7iSn+xZDpTcPWc52Xgtsz8rXaD3IDRC04jiMwVTq7kY77U4845tQP+/VBG4qRvRVixU3QMJhMkSe/Z1cWPgNfQencRuFMXwIErl9u15gFsN2TJ52whMbUKfkJQnSwFTuegE4YPcFp0XbJGjIj0JErRN1mrXhBoCyjrm64mxpmclEHvodJadXgZbVxHhKR9GIWESg+wjboyESDD3EVypZj2avsnZyTgSJDv1WQD1bXAbFORJBj8rXT0STeOnzamSZBkLrPVDicA0d5+cK1Bw+gYnvBzdESWuK5yJzWpGx6vEOWWnhkdhteexm14AnoerqgxOhBSKTMTI0YEKi8G6AKUKviL2pejj+z+ZIbV5B7zBg4+iyu+IcAKgU+KSJuIRKyweAHrhU5EQbz/yqQpcnDzNHLd0icoFCBmdNjnH2zdEVPMxe+0l+YQUuSvTR0Xf9cm7RmJbwXrXFLeuMY4GKBapa7qjX1g0U00qDSZ8214sWlJiyFinOaMgPJKQIRTWzI/qUgwKC51asgGqcTRYxmQYghWrkOcOQPe0rZabTKOQU2kT0qXyhuoZ7MaKGU3tS8RcPYGRq8ep/Mf0HDUCi14vuqL9tym3ZrCj805Hl77QEffM
 TZlevW+9
 GjgLhjMe/l7vlt2bwcheaKZQkYLK6HqzSPzK+Lji+ot6EfyXh2aehVzpVIylqKMT8Y/hMH6QghT634MPEByV96LjWL5a3nv45RCj+CLpxCrwfaNGIkHtKJZVJWDWtoMxnJXVu9DrOmIyfLLGNnyRN5atsn6BFHgfQ09EY4IiWRqzpP6vPtiqbBjFan3Sz90V5lluRC/93O/+WKh5QGMGqZKdehOOcWu/F+pXwBOiIi/cgIISOuLKAZEctUqvTfyqAJHCbzxqk1+vJcle9OZqyYT7sd57z07Sj/0Kz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/9 15:09, David Hildenbrand (Arm) wrote:
> On 6/9/26 04:39, Miaohe Lin wrote:
>> On 2026/6/8 22:15, Breno Leitao wrote:
>>> On Fri, Jun 05, 2026 at 11:42:53AM +0200, David Hildenbrand (Arm) wrote:
>>>>
>>>> I mean, any such races can currently already happen one way or the other?
>>>>
>>>> Really, the only way to not get races is to tryget the (compound)page,
>>>> revalidate that the page is still part of the compound page.
>>>>
>>>> I'm not sure if that's really a good idea.
>>>>
>>>> But my memory is a bit vague in which scenarios we already hold a page reference
>>>> here to prevent any concurrent freeing?
>>>
>>> No, we don't hold one here in the case that matters.
>>>
>>> HWPoisonKernelOwned() runs at the very top of get_any_page(), before
>>> try_again: and before __get_hwpoison_page(). The first refcount taken in
>>> the whole path is the folio_try_get() inside __get_hwpoison_page(), which
>>> runs *after* the short-circuit.
>>>
>>> So get_any_page() itself never holds a reference at the check -- the only way
>>> one exists is if the caller passed MF_COUNT_INCREASED (count_increased ==
>>> true).
>>>
>>> So on the MCE/GHES path -- the one this panic option exists for -- no
>>> reference is held when HWPoisonKernelOwned() does its compound_head() +
>>> PageSlab()/PageTable()/PageLargeKmalloc() checks.
>>>
>>> Given that, I'd rather keep it racy and take no refcount than add a
>>> tryget + revalidate purely for this check. As I've said earleir, an operator
>>
>> Would it be acceptable to add a simple recheck? Something like below:
>>
>> retry:
>> head = compound_head(page);
>> PageSlab()/PageTable()/PageLargeKmalloc() checks
>> if (head != compound_head(page))
>> 	goto retry
> 
> Sure. I guess it could still be racy in some weird scenarios where we
> free+allocate+free in-between.

+1, sounds reasonable to me. Still racy, but acceptable here I guess :D

