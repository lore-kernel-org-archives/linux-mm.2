Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3C1CCD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 07:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66DFC6B008C; Mon,  8 Jun 2026 03:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645476B0092; Mon,  8 Jun 2026 03:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534B36B0093; Mon,  8 Jun 2026 03:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42F8E6B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:41:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03473409BE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:41:28 +0000 (UTC)
X-FDA: 84855950298.16.D586009
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id BEC43140011
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:41:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UOQYKXQD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780904487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CyzJ9u89Ow4fnNhFsEexe5yqj0DRaCFbLEw4ahhTDo8=;
	b=LJJ92wHHr3G3SQoAxJA7SwAoofxRG30VyKK/eXAByLOUulJIU8WDyrZ+o7WlgRlwleKEpK
	q5k1O6+EcFnsJyZf2hcDFClB+/Aaj6tk2OGBBzoZVhd9z6ROjNgLri03hc0/nJEzGzr98h
	5xLuUO2+EUss6V3au2gg8r7QmolG6r0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UOQYKXQD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780904487;
	b=NVKEw+63vnM4GnFPXdxF6GU2/vlRccm+6kE6MFCHu3bZLeCzjxo94nu1i+lttPOsFw7DbC
	3ML06L4tJI+KrgaOLh9yd5k+/GTNRylNhnH/+kCwl4ALx3pBNQVugQXi1NsbfULlGtE8Ab
	7qpjwpwCAEyek2B+G03Ufmvn9isttMM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780904481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CyzJ9u89Ow4fnNhFsEexe5yqj0DRaCFbLEw4ahhTDo8=;
	b=UOQYKXQDWMlxueS2KveD1eFP9YEyiTVoQNYGe9ZCf7hsfPLtvsZl3JZRIEYi9Hfn472pCH
	n6gJQpBOq/1a+eHXexJrfeCgJAEOqbloKJHSlmTRkj5YoBlTDuZSriZskIOMh920Hrzmuk
	ICeMI+zNbtQtgAmUmiMn8rBsBEStbO4=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	bagasdotme@gmail.com
Subject: Re: [PATCH mm-unstable v19 14/14] Documentation: mm: update the admin guide for mTHP collapse
Date: Mon,  8 Jun 2026 15:41:06 +0800
Message-Id: <20260608074106.2945-1-lance.yang@linux.dev>
In-Reply-To: <20260605161422.213817-15-npache@redhat.com>
References: <20260605161422.213817-15-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BEC43140011
X-Stat-Signature: huc7e8hhizpo8w7mzk98buunhn4wqe9z
X-Rspam-User: 
X-HE-Tag: 1780904485-702968
X-HE-Meta: U2FsdGVkX1+0Td3GsrcHMhK5R7HYd0S3lU9ojH/Umvttbs4vVQ2Gg/cNMPj4/I5CK1TpPLBV3/Sl8KdCMp5P2CEIfVazmJ3lcz5dgbFQYnzFk892G3Y1ohVwvKrobh6puCIMgE3BOLbKVhDRTby1W5HG6db16yfhciG9VZv3c36/yBw5zkAuKN3Jdb7chxzg9B+3q4ktXzyw+tK7zIqbsMqa9jQGJIhmPVcoLjR13m1kKdY/KzwUR017cjk0ngTgTh9YdG13+ncwCUM+W/AVuOTAAv0l+/ReIll5/gvJWSV5hRK1HoRfMk3lfBni4zq+u1Aww74z7FpNYg4d2h5/AvEk1zC/pNpiA7YdBeQgzkE5j0TJ9R8JYuEc/kRqHYnOJ8+Ta+Y1aSyoRyMWYuHGlfNKBTghJtN+E1TejjfIJQsl3lzIla5hgkdlo/7VdiPUbv+A4yUPp9SP0jApfm/ehB0z4Zw+D1EaXyZ9RfcoYmoKVLJDPBvQolUfudmViIvx+2yUWLBnlkFkOcjIALgl6x/T70JlkrlkUIPZi6vOB7Ax2HcdZb4WVRPRS4EuTMOJ5HehO/pe8B09C9jdzaXw4MFf/lyyx0YF2VTE/+T5X6lHLFksFjk/fNRCWYkP1n8y034QkC+QFBfjMQJeadJPX7Bn136fNIuvGijGP+i/fshPq4S55C0Sk3d+WrgbjVawCtftJbBPF8dN2/ImxKQh6Au1GyD82tn2uEKHlHE2GBQbDIZBn1oUeTtzGHUYILY7HhjnJT1JqQFSjzn7+JQBxVDet5o0JPBzIbRmWFiZU7St9kiKVgfPUjhdqWz1RBq+CtKd9G1j93lEP8d5u1yQpEVwfW17T80XTCSfXsgARyn/2T82bGU+qbUb+4OIur1LG/oATcTSIHiIxajtLYWPhFVQLbG3o4LL248si7JidHnKUTDD994b5fWXz34EknsbLxEzmjmJr8tujePQXlR
 1gJE+s9e
 RAJg8a+5D8YFeWAx6gPWu23sMRnXOpBy3KfXO0lO3Jp59Obo6HqO5qhaOUS8I6mQXB4yXVMJQSRq73yR/KSz1kocY1aY+CWkUrYAgIkjfJKqUhfT7rM0DSiv8fltzgBaKcwQdZlQykorzfk9A0n1x38LpOVZaqAbKIxTu+pM4fxps2w5fKlscAm4F6aUxXb98HaUaT/c9F8WLnbzXM9LQ2eIb3ZmAYO/RBHymALioklKMsPuI/xa4amhxTuDYExgdWCz2awVCmTR6uVn4ok90jKY48pifLq6pXJ1Q+Wvk/uCfz+uxcLJZZdybjHPX+h/hR9gNqPZwxT5lHsHygp+52Rrgy6WyHGrh52J+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 05, 2026 at 10:14:21AM -0600, Nico Pache wrote:
>Now that we can collapse to mTHPs lets update the admin guide to
>reflect these changes and provide proper guidance on how to utilize it.
>
>Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

