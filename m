Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1388EEF99EC
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 07:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452366B0005; Sat, 14 Feb 2026 02:24:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FFBA6B0088; Sat, 14 Feb 2026 02:24:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BEC6B008A; Sat, 14 Feb 2026 02:24:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21DE06B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 02:24:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0ED6C26AA
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 07:24:25 +0000 (UTC)
X-FDA: 84442224090.13.1D2CB5D
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id B8E8720003
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 07:24:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i2yxNUai;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771053864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLBetFBaYu2PeLbGVLo1UPd6kKPXLNuBM/BqMSFx1P0=;
	b=OMNO0g0LCsAwx4iVVLABmO//f8eOkTT7fED7v95IqGaSdIxdt5hikSovpFiMrdJFYeRwyI
	CsxTC5b1TgExlm2s7C35W2qHrCO8h5pDbBQrEY4lcUIgid9sbYHF5KPCQH6eORQKE+wYqC
	+g+U2cOtN2fG9RlS43p4aggccsCfM7g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i2yxNUai;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771053864; a=rsa-sha256;
	cv=none;
	b=i0jt2BqRcHuY+NhyIP/Wu98JtkKvgw1+B72LXlhYJyRGvj7/6ep0dXUjpXZpuxu6IZHo3u
	bhqH7KTqNrz14T+AArxSc1FOQKdqB6wUZAgKRxjZ4okSV8oGmD6Kq2PVLy5mpdyNxKedEg
	jL0yrzfDWnuYMClmYlP3sk3MFfwHu4w=
Message-ID: <74dfa08c-088d-474b-a56a-c55b6f1d2e32@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771053859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sLBetFBaYu2PeLbGVLo1UPd6kKPXLNuBM/BqMSFx1P0=;
	b=i2yxNUaiSSgBGp/PtcqcZYOilu3AwydVHA5Ap3PWi0LiC6IK37/YKBzGgUaxda26FOTPpo
	YUZmjZJcjy7HdpJUh4unDETk0gLA6oWu/EHKPx1DhvjrPDtYL6N5ZUYvB5gLlklSgcL3UN
	4nMJuv1z8QSDjapanllmC3ykH/Dbi48=
Date: Sat, 14 Feb 2026 15:24:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v1 2/5] mm: introduce is_pmd_order helper
Content-Language: en-US
To: Nico Pache <npache@redhat.com>
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 linux-kernel@vger.kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, linux-mm@kvack.org, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-3-npache@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260212021835.17755-3-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: iozcwprcx5exc819wisbp7h5w6i4sd39
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B8E8720003
X-HE-Tag: 1771053863-968979
X-HE-Meta: U2FsdGVkX19DrckvI2C1PXGQsTGApLBDvY5GN26fVII/UpMAQXHdFWwUM6kz5cWvkrfGcp5a9ywQSn7+eZoE6wuB5+y1m3zbfjGQx4uWN6quyBP0LgEvM6H9iMU41WVI+Gr0I7X34kzmfBoW7Z+TQPCFmTUN7n4y/+/3wOtZso/frBtiOtm7rG54isXVaGwzkBCxLrMqi1j0hI79zUFvHNx8E3iuPrtfqNmbzMRgWo+RyRvoHB6mS+5OdzSynTSpY+i5TB0jYK1Eu7LnbeDdQ9hhvW/U0yUDG4ojWPOESDJvx/q6CwB2GDspoTjEWqCU2QSDcX5D8dhm2RbZG2cBiEnJnUwgpAcIrqvabwQjZ5RFBFWrIQg1Dx0cf8wvWkDZIhbfDo16/nUyvhjhlmiUey/8WtiA1pNkwY2CaOJm3zRCUnxXTkn8Bovl6G9508AI1HjTCBqJOokaQeW5m6q8giLdJpU3oYzAD7ug3WJy3/rj0rdcmU10ejI8qxfzXGksp/atQ0xl1Ph9I4HlCoKRhtyyC70cJXlGLa7GoDIxmsObWVvLvqgjiSuiQDrfrmFLRJIQES9Rl9a59FG37v4umN2AeiAuoX6EFbNpCg5tJ6ztxNpGYXvqhktBfrQwm6C2X7ZztiXj6P2xXAOcjHk4ahg7j4TxZ3fwnDmYNQBY1zWxFttv3FclRio1PEE7zIoCk6IsDpxm1eDIOzcr35OK3HE6ho4z7zhYirShZbNdH1OdbrHnRFp2X4MkV/kzqMdaFsg4dv3NasplqPTNAG7y3KXeSd+pNHQpjsi7P7duFlY1bPeID+cThKQaumMG1LEWu5YGV28DQPATK9HOkzuW2lPHOz6xKNiBqBu6vtTJf9u+FUK54+o/63XCrfXuh6uyjssHOyr0h2zdl9bmbOhbQvpmKc+1Ai7V0icXdzuv5oIj6xGaPczwIvlWIQU8NW+DjBqgr1eI0A4SluFEbB/
 0ci3E1WV
 7JRu/GdQe9Qsl7cEVVbMgYHBkgFcFVwke+1zicLo4a39A3VtkwAiwCG7j7p04xzRNFd12TmdKsKV72VwYiiH/XutDfQy/65GjpkJh/7v91LuikfIlqtLBz38XN4poLpZxHjoKuJokjYWuKEN9arOJb/AMi5zbjOONDXG0BujJrWkVeD9wKsbBhBTzQ2tUl6IUsnH7u4LZkHFSGeLeybTQyiLjOgPUYMl4HV17TBoSSbHBLGdrQAR8s9ig1xsdzHzgJuIE1wSLwgqQTsTXZmueKR+nPehPjNfKqG51N/F+Mob0RMugUf3SCaueIExPy2XvKjTzzXkqpVD2GnVcpx6BiFYtwBrX2NH0jMnmnXyKX0KsN0Bi6VT9URl0ElmYElijBrWcO6oioCyWyj+VFdrwHBdBWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/12 10:18, Nico Pache wrote:
> In order to add mTHP support to khugepaged, we will often be checking if a
> given order is (or is not) a PMD order. Some places in the kernel already
> use this check, so lets create a simple helper function to keep the code
> clean and readable.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> 
> arches#    pick b3ace8be204f # mm/khugepaged: rename hpage_collapse_* to collapse_*
> ---

Looks good to me.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

