Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89B6DCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 07:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6F46B008A; Mon,  8 Jun 2026 03:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61286B008C; Mon,  8 Jun 2026 03:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28E46B0092; Mon,  8 Jun 2026 03:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6B56B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:28:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C4D71C2AD8
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:28:11 +0000 (UTC)
X-FDA: 84855916782.02.553EB49
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2753C120003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:28:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JpHaj0hz;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780903689;
	b=4pwA4Zi2nYH2aNAlhGnMT19ZUPnwkepxv5BB9sMrRpYC1DMKkIJOlUvfWWXZ6uF4ZPgN01
	Qo2lNnWPJmP13nLQsiyPTkCqcKah7T5G4N7SKbg0csUjIKmCInO+S+mfYlAnn2uTrdpM5O
	knEEqwY5+yQXpMYX+XOdQ6uuYCjMCNE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JpHaj0hz;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780903689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+UEQbg6AU+TfmK805SP5EpbQqdODkwRVAGdZoxB4k0=;
	b=FocYn+99cssVO5ugo8RILQCjUdXR4louK7+yNTRIOdRdr0FQBYkHdKPNA+DNsFQaYsv95u
	wm7lg+xecGv8FAwpVPnmJvT1efKZ+fLrgWWDMhq+cquK3bB1OcRGe6dVKpQPmWmcMNGIRx
	eEa2OKeDWKlN/hjKipkX7uPf1Iq06TQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780903686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o+UEQbg6AU+TfmK805SP5EpbQqdODkwRVAGdZoxB4k0=;
	b=JpHaj0hzUy6GWQsoTGmReTbCiT4mzU8p/9whZkTeag+RVJS1KqdqB4P11lEZ5gdN3qeXnk
	Sc4Wh0u1hgK7ingH1qu7mkNb3ZzFeUCmIzLy5JbnPQinOCngV6DG7j0F77wzzvoaUgYYG9
	aNWKbMFCupxYA3dOUJp1SES55xPBXCk=
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
	zokeefe@google.com
Subject: Re: [PATCH mm-unstable v19 10/14] mm/khugepaged: introduce collapse_possible_orders helper functions
Date: Mon,  8 Jun 2026 15:27:47 +0800
Message-Id: <20260608072747.88417-1-lance.yang@linux.dev>
In-Reply-To: <20260605161422.213817-11-npache@redhat.com>
References: <20260605161422.213817-11-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2753C120003
X-Rspam-User: 
X-Stat-Signature: 6trmkfc1m73d8cqme578s15zzf9jgy5h
X-HE-Tag: 1780903689-274899
X-HE-Meta: U2FsdGVkX19uPyv7uyiBGkF+ztvXdX5ChTqt6SKRDzu5JUHANKPZPXJhDsXOtJigwpUB2wkn4m9qtw9mmW+AlQI2V68AgHxCJEDfxFMD0MAssvayPb++6/Mq5ei3J3zEp08DZDqqrNwy4fiU9zFQFCsh9QfeY3Xtaxjm2Nypa4wNEag4HdiwEUQqJo8eFuWIFC7SRC55F7DM3ZxQMAi3olAMW8aGNOAdSJKgEGo27MvGqlvSoMRKdnpto/8ypyJzCADb0e2OvSMoFGFOn/dxM/CoXW2SjhlyGGhEwBUqsOg9qk5D32nvLCPRZvNTAHjWfRxsSHyDXNIJpijebq2IU3TTeLAb0aI2POnZ/kLaHcXIDhVsGSkUPxBUMhZ0nbHapmsS76EzbgBVlbwTsHOkQTOkEjtPmneXJecDVMzrvZz0VTxw/lLcZ3eGY9u1sjkHNoww5WH2YO44LALKWHqn36VvV2I6CarTnEBVb9zj/uu/+j0LcJkdFih5MxqijFkRY2KevhTwLSGsfcwL2mbfoJj5DuG8gF4ZIIwPW7pLLPGq3c2VwRy6X+nqebv1gn/ljM2gNOMP/DiS8oPKpnPhmYAeH89t3SzuT89rIbN6V24Q7ZJ0lLvp4/CA9FfVZ40eBBUwUrMoSmlFr35Td9M6rwAlOGvL/M9XLsln2BgHsHxSsRIz+OBbcKFj0bf+U4QK5Y5e0v1by2Pc6cJKz9rVo+1pDRLzBasqlo1dZ8LFI9MjMSelM0hs2eRaniKTMfmEYJg8cOKPTz0UIXqmD37OziFpY9I1bMdrgz4JM+PZzyvY5GqjbpbArUhjmAmCzny+u/aqH24DPuEipqjixxitOdD6gzSfdSVM0Sioq8idMDoVChnidP8FAUBko7jEv9owOZSSiaz0d8cEOtam5LRGA2mpfSkXoy4rEJF9pBK83chXQzm4B2TTAv1U56LyR1Nucx7zUSGN5lK3A8ZL3GP
 MyiP9Jcl
 tcQ2f6cRU9TjCSdlSwtzHg3AgcNNa/MqoG4RPoqlYBI1pwdNLQZgJw4uYPJSNNpahYBSF1Xeml5ANvJAPJIGd1PLO4rByhT+XJfeGYnmyg2494PjP3nuVTVAQDd+kM4mX7mhsXgbJ2uGzbblp3pnJELpAwc4O5pyGJgm2uXm2CbcxhkPVd4GGw9S/xird3j2yh0lL1hb2KpXTGCjNJ7CDyAz89dzpJvTvRO61rsdoTRe/OtNeKmTdZ3Hn391TMiSGhFj2/aCwwt2u88r2VJUEthZy7clBx+3tZ+77OAj9muWETNgyW57xfmxfMugnxp+Zew3XgOIfV1LP13AP8ZDRfgjkXpv63NVE4FIRdTYJpQe7ZcO1qxhPqtaLBVGJXJjBrC1KX7xk+xAxLGR7LMp8ITYvOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 05, 2026 at 10:14:17AM -0600, Nico Pache wrote:
>Add collapse_possible_orders() to generalize THP order eligibility. The
>function determines which THP orders are permitted based on collapse
>context (khugepaged vs madv_collapse). We also add collapse_possible()
>as a thin wrapper around collapse_possible_orders() that returns a bool
>rather than the whole bitmap.
>
>This consolidates collapse configuration logic and provides a clean
>interface for future mTHP collapse support where the orders may be
>different.
>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

