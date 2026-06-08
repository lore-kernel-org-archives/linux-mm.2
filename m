Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3140BCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 07:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CB766B0088; Mon,  8 Jun 2026 03:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57CD96B008A; Mon,  8 Jun 2026 03:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B636B008C; Mon,  8 Jun 2026 03:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3998D6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:37:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEB7F1A099E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:37:47 +0000 (UTC)
X-FDA: 84855940974.02.392E90A
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 29C4F140006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:37:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ak6sWILD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780904266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wsy3SV/x9gKjvdWcQFrp0CjrpEuT+cadsrsidaj4rB8=;
	b=Xuq7j4ldm8jRnkhtMID4JD76eYOsnSpuNFN09hQ1FokVl55S8pe+jipH5O29viHZJ7Jh73
	nsiihNvV/cn1Lww1WqKi/akf6XgKuprRKLCZLtUYYYAeGEMv09vLRRwZpd5+EllRcPEvza
	yGYpCHG12G9BYjZtTuEQsgXjCTjJE0E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ak6sWILD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780904266;
	b=HRLhY+V7NWDDHcfNcc4OieIncfo+evZIjUadRPBMPIfXf3okWKD1JhcgCEHH/MrnvaH7rN
	7iE3bxFBOTabNSi4I2h9ezIBjF0OH5xqj1W5sglXIMGqx2xFaGP9oRLWpdEGF17GCfI3Y4
	uR2immGxQ0+/gpXUpynTeGS6pz8lWD8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780904262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wsy3SV/x9gKjvdWcQFrp0CjrpEuT+cadsrsidaj4rB8=;
	b=Ak6sWILDDx3J0D1mzuDOxeWn8ejkSI2YgDmzlNwy111F3FOcKNLITeLI7L5RS1mV3wHKKH
	SHYDnc4PExJJNYS6SWRZhJdtTLt84QeGYdYHR1KHKTSLnWprM08aXIk2QqdHZTt966lXoa
	/UgQul8jmc07M9P9KRQQLPUc+HzmVqs=
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
	usama.arif@linux.dev
Subject: Re: [PATCH mm-unstable v19 12/14] mm/khugepaged: avoid unnecessary mTHP collapse attempts
Date: Mon,  8 Jun 2026 15:36:49 +0800
Message-Id: <20260608073649.99133-1-lance.yang@linux.dev>
In-Reply-To: <20260605161422.213817-13-npache@redhat.com>
References: <20260605161422.213817-13-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 29C4F140006
X-Stat-Signature: xhm7n18h4w1xewcdcs4fxkm4fqkcx1s4
X-Rspam-User: 
X-HE-Tag: 1780904266-689063
X-HE-Meta: U2FsdGVkX1+2OChlhUyH0YghwAWaR4Db9sZ6bol3kdXmCy5PO9KBYmRYpEQWTt0lbkIKomDZIgqYu3GmIXBrA7ySc9fauCAf8BtnA2voDEA5uXXLk875So4nt30UR9lUX3uQkbqgf7mdRGsbC6InakFkTCHZPpxNXkt5uviO+HLbsWsqKPvKeHLbSZp4oYt/ao53HspeRGoEuJoDXYXPaYu98BqBJM4h7oS7qQh8/bouaJlXlynp7pT8bWBnoMilWY6M4wjrC5w0mq2kiTzLoRpPSL1jXpGZ2WbL0P2qx3i1gx7uTpTuTXUq5oU06Jucm6JMg3jUDss3xe4+zFfJEV+iDlgaRGeyO22MT6Q6pjnPqwdzH8VxJz915MKuzVPVR9tZXj1z0gaJgCl94hc6lxd/nC8WKYxkw/z9HJlINfQoYwwfaKdCHxiZT46p+uNhWK+kqPSn6m6oWUgulLC734iYcSALRdqxVslDqlxM2JUjqcwVqJOAeM0bitTT8oQcHR/bdzgoVUUt4Pb570guqsAW1EFF5Y+NVgHZJXtRc2aXOBjIxqDMlZB91qrl16rjdpqwb0lggHwFIaVEP56OnHw/SbKiKR6PHTRoJfCBfaI8lBwyu2gz2lNmzHATP/3AucqZlUtGREtvOlHOS6zZ7VDOFUGh3hGQycPuH5SBsAYp/YyKxMzZhYc+xFYtMhIZwMdzGC46Ek5CxgUKRYffWvXgc96P1ZFRN9k1k5CxmrQB7bgrRtyXiezOJR1j4onNuln0szfi70nWKRzLipwyNS0TArStRNVDz1cMygC7S3RTKQ4aDwQsTW1/q/5AJInhflx35uzghsNYigs4C9gun6RpREIxKlPMPNiGW/H4X9bnV/O+UUsjQMKPCfMBArPpsmulKe57uGkztGEbSPPLxoyhlmMHQcODMgIN6YtaKnuGJFSl0hFbCzVgAW1vn2x/iZOQmL4X5o7J3JmEX28
 R8pJ93eo
 2BZuLNXN5KmJZ+bP0DJAG38Z+BWidOSQmVgUHFds4mGR8shDpMfXr446f/WeKbTRrr4u/s1DmsSuK0mQBmJ/ECus4MPPLi7VVJP0Vuuid/evuV/7jTFrnyxtYWT5i+X0zAZIKv38F/YRsJOGAs8Mga9m/OB9LdSD1yrRLbs+SPFm5tHNBs5O+Mr5EoyJ8ui3CtOViaaR+fy3TH6NnGe0RXIf5vLgtY0vjuAortSmzcrhI424SKfdyUvz4bAu+EaxI3RbxIisACVNsxclD5nki/RCIWI6SthPehfFXnFmt0wuU9o39vZPpfuFbLN4XxHHxNsf3B9QQeCsPduDfSdcVyrHQv6wUQHjj+hWG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 05, 2026 at 10:14:19AM -0600, Nico Pache wrote:
>There are cases where, if an attempted collapse fails, all subsequent
>orders are guaranteed to also fail. Avoid these collapse attempts by
>bailing out early.
>
>Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>Acked-by: Usama Arif <usama.arif@linux.dev>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

