Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5970CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CBA26B0088; Mon, 18 May 2026 02:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CAF6B008C; Mon, 18 May 2026 02:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86B8C6B0092; Mon, 18 May 2026 02:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72A376B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:29:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0371140813
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:29:20 +0000 (UTC)
X-FDA: 84779563722.04.737D123
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 601D880003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:29:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hX9L/8rq";
	spf=pass (imf30.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779085759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aash4ERkFY1Gt3LoUbMhPm2eq1KEhu8LqF+7BxthrWU=;
	b=pQ0brGvYg57912qlGmK8sMRSR7WHWlup7aKQRjVByYcfGLeWZ3zJhs1rZ6H+Xf2++jYfbT
	z9iJD2p2WluKxgYHb9/bICie0IMckfObQAgjAT/ZuXF29ynNRGUPdu8N+u8sPlIov423FH
	/6/7fR/blADFbVqXe6GCx8S9xWVAFFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779085759; a=rsa-sha256;
	cv=none;
	b=CXdsiiOmBywVf1Wtt6HZKTgrN66HZfku1d0G0BrOUl6rFR0OWBQO/jH77jj888oqDvV5SF
	kIlVNSY8iBSj8okZCVte825n/n4QRzN5lF5XLfZKZ3lPcOfn1jrQozsLtUl8fCYnTpDuLS
	gcmXjP12leCs/XFRWCUY2YwmUV9b//8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hX9L/8rq";
	spf=pass (imf30.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CF6443376;
	Mon, 18 May 2026 06:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E447FC2BCB7;
	Mon, 18 May 2026 06:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779085758;
	bh=I/XS70rALR6MwZ5SM6q/C17Gn2ByJj0otYaz4sWXm2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hX9L/8rquXn48G5XFv9DP46PUROid7yK9Oysd2Zo4UMpN/4d4QKBzRgMPZtjwufTc
	 fmK1ZqrLN/XLDZ+/e9ZgON2hy26aOfYKk4RqkjqkX8norpOpooJye2aAw2HiDqS/bT
	 MrAY0+DGMJGzGzQwuTk70hFHq3OBD/sA4J770ZdoHd08yUXmMjjqkwA0PysJWJ78QY
	 EOaNXk8xZ7sTeC8mTNqyyjgdL+CfLjLtKaspea5fpf9zgJteTl7/zhC3rXCPqtT8cl
	 lTd2AMkgG/pHPTOgPwPbNxdGaFMXbitTvvLp39TQLdG4Tsh9GTJQqD4yQMT9XxfCH7
	 byTmYwMD6YDbA==
Date: Mon, 18 May 2026 08:29:07 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/69] mm/mm_init: Defer sparse_init() until after
 zone initialization
Message-ID: <agqxs2-EQ06mFKun@localhost.localdomain>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-9-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513130542.35604-9-songmuchun@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 601D880003
X-Stat-Signature: jnor3pecxdpumktasxtcac7u6qc6mweg
X-Rspam-User: 
X-HE-Tag: 1779085759-127914
X-HE-Meta: U2FsdGVkX19AfRq9cbwasZqyu1AxQarTmTw2b9RbX/xZx6kFAWBXDO2oG5rXxjPdjO8TP0ym7/7TftKMgbsV2/eAgEYhlb0MHCxvlA5cvlcyjYVh8SoqpQjuTuQZMWMDa3MgBmKdavSBULDDptOgtc6ad5sAfaggAy25871HDtF2/yWRW//97a+QyQr3fsbvqKrwF6m2XjVSvlUpIRVWsGnZwT5yEmaGMXlG8G/IEYkiQ44l/rHPbJUP9jbZ8TzsJ7m9fP/QWWiLzCR1vQY3EDiADKUWAK5q//54IQaYXy7tze7EX/AqEn+/etUCB4sGXDeG+kbuTb7XQFCeN3U2fUM7DExRwv5P5vssx23ks2FndVarOX+viApvCO473Y//ZvTTS0lYAP/iZpSUZYRdIf/Xo+unyCwrB6ihFFbVp3JphHR6cMZzzKFmjbJDIdFMZfb2dlxPGwnaJR3K5sRcuWZMJ7NIWhppl4U7iYh945nUJCgwqkxpHsL96dMbPdASE8GaZGMQmo5EicYPwag8mF5uuBoIlUghAL4yEmFn/U+UkFfrYGOxmha+DoU7se4BCoisbSbhvTxxkolqkX0FtNLUOorCOcqszEHa7fVe5aMM8qMN2i/0OMqahf245WsWJVMl67usRbYhCBQjgo8TIKPg23htGrYry3oC1rHO5NYlwe6u9deamPqHSaEeogGo/JdRKPjyGHQ30fzcUkyhjHgRmhDB5ss8l4b19F28WO6QrPMm2c5ud36XzSJEvrjemgs1nJJ5QN9Y4SO90FAD0SzWIzlNEJqKhldcY8g2YaSoNW7lvSw0Mg7Zqlshdccki9Pwk4d+QA1VBNibLA/usB/dDkPIsPSR4Oyh/oe5SfYGbybb0lc/yreue2S12RyDHa8s4lIb1WDqHRIsmVxXBE/0x4YCqqQZryokjOtTfbbNbNuwEkJLnZcZfcbZzkTMbA7IRvYXKNKoFGo6TNf
 y0RjC0Ml
 xh7BpwVXeWGjGN2fuQ9ZgP9p6ZtaXAppd1okl3LR0POICVk/djANIdy7eBu2SUolBm2HhKKXklgnpBGl6bYoEBrDBXEfRzJcqsi07hAAu/EEs+TQ0Nz66vVYBFTjp1WJcfz75Z34CMIEMkafHxzy30ADCB47iG/cPClgoo1mWSWenDjbLiasMGOPJRM7KgaclUr3oI5EwJXmAGlaMxDk+Lm/aoJui430IAwxuerHlw6sCcoEZ7++Izs4D6EyWO4X7Iws4L+Rz22DMJyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:04:36PM +0800, Muchun Song wrote:
>  void __init mm_core_init_early(void)
>  {
> +	int nid;
> +
>  	hugetlb_cma_reserve();
>  	hugetlb_bootmem_alloc();
>  
>  	free_area_init();
> +
> +	sparse_init();
> +	for_each_node_state(nid, N_MEMORY)
> +		sparse_vmemmap_init_nid_late(nid);

Would it not make more sense to hide sparse_vmemmap_init_nid_late()
within sparse_init() and have it called at the end of the function?

The flow would be:

 sparse_init()
  sparse_init_nid
   sparse_vmemmap_init_nid_early
   ...
  sparse_vmemmap_init_nid_late

I think it is better to have sparse stuff all together in one place instead of scattered.

 

-- 
Oscar Salvador
SUSE Labs

