Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A43A3C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 09:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77A2B6B0088; Sun, 20 Sep 2026 05:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72B4F6B008A; Sun, 20 Sep 2026 05:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A776B008C; Sun, 20 Sep 2026 05:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 350656B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:59:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 09948A58ED
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:59:51 +0000 (UTC)
X-FDA: 85233694182.21.EF6C698
Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	by imf13.hostedemail.com (Postfix) with ESMTP id C1AA120004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:59:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gKe5u8bc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789898389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fc88VjcCV0XaevewX7yikgL1Gb1gpQ11lQMw7l75aVs=;
	b=vRF3p9/OLrN/b1Ztv0tqsxmqaup1PePeZm93sAH1CD47PJpt1+Q1OWhyYJEVVnzc4aFUE8
	wZjQ/2aVpBL9gFtUn7A+P2Fu7imqjpQy/hHV7v+P/Gor6SPkKVttXYdYzdUNTUR5WOWkio
	5aRk4feEOA2jZbqvtEnBlL6PQhZcx6U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789898389;
	b=u27zyvk78SKldZgKh2dqJb0GW2B1R/Pwct3wDddMHZxLtMd2UWJxJ8N5qca2b+uVMUo1Y2
	iFhxMRlFa/iKlyHP8bLkfX5nnXHCbQCLsnbb71zmCQdULTWg0TDIsy/kl6H4tCKryeGZ5+
	oh/a2iyxt/zrz8V+4+nkgVeKBiayjW4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gKe5u8bc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=i1HleDRhgKWtFLvlkCLckONA588VkME6KNONTyekZJA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789898387; v=1; x=1790503187;
 b=gKe5u8bcA5blqDZ2W/6YxWa/Q1UaPWfwDTqtz6C66wlLepDdwbLquAIHCYjjeTjX2xVPLdOu
 Xlv6SC60cIIqJBx6gDXISFvmpjiu66GL5jOtFPom8Z4sG+oHS5tuPhLH4VKPNDDLNWxrTsZnkzY
 WFIYeQX2ahDN6yKuWjJuY28Q=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 78e13bd88616e780;
	Sun, 20 Sep 2026 09:59:46 +0000
X-Mizu-Trace-ID: 78e13bd88616e780
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] mm: Add CONFIG_SPARSEMEM_CLASSIC
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260920070406.95354-1-kaitao.cheng@linux.dev>
Date: Sun, 20 Sep 2026 17:59:22 +0800
Cc: Andy Lutomirski <luto@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <85F48B20-68C5-45D7-A8E7-27E601283743@linux.dev>
References: <20260920070406.95354-1-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C1AA120004
X-Stat-Signature: 991hs4hoydbq6b8gdcgw4aiz47cxys9m
X-HE-Tag: 1789898388-91478
X-HE-Meta: U2FsdGVkX1+35eWbXuTGwcGPW1un48wlIB7888b5l3+GUWij4XDChpKil2AWvfYjivPWVwX+sYO0tE3A0nZfKJirQR8vDJtfGyUo8Hn5dzSH4+24J4xERnHQOLmVyt8Drc3UzoeRl6Na70RaSb9otYOXO5siEOl4Hlua2f531waNruq3hAoFdtI5etQszBVUdpE3uihw/cN9MQmRWiSeGBHYdlzRqD7+DJZ900ry7+q2wQu/F1AdERrVYmdehB7TiPdzXBtJal54YmhSk7gs0Pu/ln3o5ISwakPi7hKCtMZS5jhyfnSE4kG4a/SzwO4StUTQ7Ryham+p3G6od+lcMcVRASf1673o4TuibZypLq9gx/FJtgiUbmheRqrA2uNiENN41AAYdgMNhPqenBfK0Sibij8r89lzMZ2YBSN7W8PzihXKZLhSxG4RxlMSJwORMrjsKzSP5TGYPIma2bqYnGSDMmoZ44ofAsFHKrY4QNW/g0E/c/bL+XqX5MJGnc8mZYQEGi2lPqEKdg/rie0tXATqSxKpbQjnBS9SSd4UJRxk2Dy5J0nyWPzPIn5GjzKhjyrCk3mpIUd+j26dlTYUvR8OZu2Vk1Q95jOazU6KGKtPgjAAsjIpR9tPL5hPebsXgipLwh87nFoPFU1hfZpUY6g6CiqUViyImYliug9RNb5zGKyQeMZhzthXrFTybo/5xkbWQQ5j5dE5mOX6A7Fq6lFRI0fo30PWmLNb7KxrA/dNHWnpffAWUI/QPb7Tcvh6mWpRn7XwlQ5V78R4Jr8dIDYxt22n/rJGeO34e9RHf82hUl15N4ezeY2tyAwHUOR2yu8m7sLtQ/o0cvtCQ8P6uGVhksk8pTAEscQJvB5xDRsE3he0zzoplkw6LDbDoQmGzlZ8a6WUzjiM70HHG9h5Tnx0pjq4/V7wUq+RBB2HnJD3LhBSkn+UFeiZBpREFh3l6+354Fhn9XhAQjrMVkO
 a7cJjHDf
 pP3ikozCuOBcpeOLUalsuWKwz35Kp2pA6ymLLNqe44ScN6/woX3SpRfntfUIqschyDywX6FQ9OpSCeJGHjCkgliFlZg25wTdkT1fQDfGjWQgAyuHvbFhw2PP7tFTFS3WGGdI84ksg57MwQ82VM+jxs0r6BbHrsAOo5MjXNpJV+98AeHHn26Ex/ojNWUwRQCPUGKe6pJyQ6WSVnQJqirhZ+mw7sdBKHwk/iLkqRHSR1fv5KVCgVgT3YtsrptAoK9Vn6Z9aQQJsg1SchcCYh6MA7jnL7vqKUaQYXZeG+tzF5kjvyUC2K3EOO3ztXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 20, 2026, at 15:04, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Several MM paths identify classic sparse memory by testing
> CONFIG_SPARSEMEM while also testing that CONFIG_SPARSEMEM_VMEMMAP is
> disabled. Repeating the compound condition obscures the memory model being
> selected and requires the local SECTION_IN_PAGE_FLAGS alias for the same
> state.
> 
> Add CONFIG_SPARSEMEM_CLASSIC as a hidden derived option and use it at the
> conditional sites. Remove SECTION_IN_PAGE_FLAGS and test the new option
> directly.
> 
> The x86 32-bit vDSO build starts with the x86_64 configuration and then
> undefines CONFIG_SPARSEMEM_VMEMMAP to emulate a 32-bit configuration.
> Kconfig-derived symbols are not recomputed by the C preprocessor, so define
> CONFIG_SPARSEMEM_CLASSIC there when CONFIG_SPARSEMEM is enabled. This
> preserves the existing behavior.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


