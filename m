Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD80CD5BAA
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 08:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7616B0088; Thu, 21 May 2026 04:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7EDE6B008A; Thu, 21 May 2026 04:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96696B008C; Thu, 21 May 2026 04:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 990406B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:47:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4746C140598
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:47:31 +0000 (UTC)
X-FDA: 84790798302.01.96C1D28
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8FC2280008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:47:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="p/o56LCe";
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779353249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ce0YsJDZhijtzDvB+cpUwwO/m6mCN3ATBf0wLj4s7bQ=;
	b=BsGAvN9tR/6UApHxRK1HcKUwLIfl5r7hZS/3R+HjnGbISBaWEOs/PNFI+hxccSOp9AS+Jf
	kNhztgUNKmWMEvzbT4DI2n1ukG6gOIBH1Ktj7vtCz98H/GMV/n5iPpFkZWNFtD15hyS92+
	Do1pChJpCQjc+Ia2GUhcFfBUCklZKmE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779353249; a=rsa-sha256;
	cv=none;
	b=HxUQ07/RAgksJDRjcrE5Cgk63N2WANDV8B6u3KziWOauByJ7gb/6CAYQS80pU2LMV46msQ
	zSwtpV4C0mlSOTqILsOf5k93x3uJwCl2y7v1mNKLwV1AlVDejhTsE/oodVr+KebT1CgP0x
	Gko+1ozcJbXx3fjmcqkDi73hvu3SR5E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="p/o56LCe";
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779353247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ce0YsJDZhijtzDvB+cpUwwO/m6mCN3ATBf0wLj4s7bQ=;
	b=p/o56LCeHYPXPT9ntpy7ijsSA6U2XV1q/IBxgTL/awZNyuXPbTR8nUqPg1fOGGNvmHFIc0
	+K/9omdB3BHMb1jH0Ko3eYnwfwaqGJr9EmwxM9iQdlkJ157w8nTXKiIgoFtsoY0SjzL+uG
	hQxO7Q43dKvRrpA5oNJkOQUMed1HVEo=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: davem@davemloft.net,
	andreas@gaisler.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 8/8] powerpc/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
Date: Thu, 21 May 2026 16:47:18 +0800
Message-Id: <20260521084718.36436-1-lance.yang@linux.dev>
In-Reply-To: <20260511-bootmem_info_prep-v1-8-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-8-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FC2280008
X-Stat-Signature: pnjz4qmfha869j38qoc5jxcxpc397qt7
X-Rspamd-Server: rspam06
X-HE-Tag: 1779353249-56082
X-HE-Meta: U2FsdGVkX194iOhUW/x6T3fFRdm+F7ZBgbMdEbir7+4a1o/MyclzH4Zy3oa5deoKGlKQS2bUQ69ucq10244Cfx+LSWmif3ZOYotB6FPlwTv/dykvTpmMnOHWk4G0P3N4fxfJgrMqQX9zbHw8b/q/iL/JCDjpxizSFLo73t1Bz6XDDcg6Fnah9jw+SvSsT7B+uju+dIwyWeQYtBmYSMtOn5jB7H3joHXj/GbTXSCdHaUDj2C3J8dK13ykGyWoAksvYBIGcQmNyTgqSqrXoiKpYrKRGxCDZAkumztxDgsVqu38wzbYqoQr0ioeJctGHdXXAtxhp7a/ZtRtGek9xmrjgyEqZ0mE15zaWe4cw7eozyksTl8IeumnTt+V695wfoyRDWGMwYthkr0a6ihxkVeCYpuM/Le010CAwxOmeaGUNv5EiaP08bmTCDP+p2sft3/RH3vLyTbvyG8ssi8Zie/r3ZCTCNFPaGy1zc2O72i+SJmB1f7Y2Si7fC5+MjjPSTLIhQtxFfUHJjhgqq/PRf2VrSwbuLhMOj8kGA61+0TRv2lp1hxcL/0JTE3k5faHeCsqTSNSUBlkQK1D6kIS7nngD1oRzKy4OET2JH+pl110UMoBn634z/XnW9smZKh9WCSNVaUa/GzDDyDb1FK+MwvuNTI88AE3eTHB9qH19qC+sr1lA6E2FYf98OoRqMIt7Aj7oVDWPoeTlDGYCE36jppeQ672teRQsQVSj0CncqZ7kY1YLC/a4UG3JsxkQFSll2ilMmARQEdu1rJp7wwh7HTL8+8oc+6PZzBAcSNbqbDqnt6cL/vRiJswWCVmbRFv/a3Z9S2dO/bosNVWI3hOj6RbvkUV5XbwWggtJQpzZaNd09VmKiO1mSON0ymBniLqrwVvN9X7Ew1Ym0rsExHrGFs0B3m3k5VlUbpxtIbeHDhVTNx7w6H+BWBQcr+0EVGjBlV/puEcfXj5R4x31bMW654
 gCCGPRS1
 3X9ObVBwRI8wfcFxTPaq0X0mJai1yc8M/mr6iIkjdEaxPZK+EU70SmprHO5slcxrxJOybKJY7N6Aaqb+ff7rWo3eK7iJu/F0ynI37o0FFleUVGuwHD5bmiOHo4m3/ZEZ8RjHFypTWKjnsoZ6hcp78h4G0cIHMwOeQKR1F+0fp4oZVsAGU70ZtfHLyjTQ1pP+9KtilDXND+JnHQ4FIxqsQVUGCxbSM2pumLL82QMrXCPfoXAZsXzWsXNjzyC/N6YvBv/iCgjrCpRR/lDUOcOe4c4m9RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, May 11, 2026 at 04:05:36PM +0200, David Hildenbrand (Arm) wrote:
>register_page_bootmem_info_node() essentially only calls
>register_page_bootmem_memmap(). However, on powerpc that function is a
>nop. So there is not benefit in using CONFIG_HAVE_BOOTMEM_INFO_NODE
>anymore, let's just drop it.
>
>We can stop including bootmem_info.h.
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nice cleanup! Feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

