Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F019C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C086B00B5; Thu,  3 Sep 2026 02:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF3746B00B7; Thu,  3 Sep 2026 02:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B30686B00B8; Thu,  3 Sep 2026 02:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95C6E6B00B5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:15:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 127AD1601F9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:15:52 +0000 (UTC)
X-FDA: 85171440144.17.866A643
Received: from mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
	by imf17.hostedemail.com (Postfix) with ESMTP id ED2BB40008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:15:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jZnAZkwp;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788416150;
	b=a7NT+TW/j09WNS5ncMRDdir8sNpoopAcfaiW5h4PhgeJmSTH1euWis0G6JNZuzDPDxITP5
	nublYYmfcjWqb+hqwurcnoHFl9qmeNP1+dlg66RkySpJku/LEtL4wBJAfuyDBwiuYL+0iz
	hNx/LiSO02CZHZMvG3AvpXyk9fnVneg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jZnAZkwp;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788416150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enjAENIxnEzzkklOh2c2n2pZQ4Dal5qozbND4nSTg0g=;
	b=ZgRF+QptdBjnmRcWMJgvpCD/JvPUyl4nyj4dAPhJBln0voWj50WPvfOZtTNKkwWrJURYwV
	XrC90YD/su6xpXnGzwGLEeaK1ujmm9DGU9Kyn2GXdDfWGZ3grSuHw7f8ysKAo6icPO88qv
	9EnAU1k3+Wh5XSzkPIrMYn6U+ijb5pw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ozxwDUyi2Jrz5fmCCNaXY1cqHon49rF3ga5YguJGK5k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788416148; v=1; x=1789020948;
 b=jZnAZkwpZy2pYbEnZW1HPAz40kg78Khchq3n5lbJWfY9IDPXB8b7wgWYs5yJSMTPi8viViKA
 5WxbYLwLZopmAN3rrIFNe95bZdUeV4mJRts++m9QgK+NHAo24Be00+kjwQ+tLWvtrCObLiJw3g/
 E1rK6qB162Q0wTUftavmWmxM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id c28caae6b09f6708;
	Thu, 03 Sep 2026 06:15:48 +0000
X-Mizu-Trace-ID: c28caae6b09f6708
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/2] mm/page-flags: Define HWPoison test-and-change
 helpers unconditionally
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260903053535.17611-2-kaitao.cheng@linux.dev>
Date: Thu, 3 Sep 2026 14:15:27 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Ira Weiny <iweiny@kernel.org>,
 linux-mm@kvack.org,
 nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <2F4B7639-9C33-4907-BCBE-C6C9DB845D7F@linux.dev>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
 <20260903053535.17611-2-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED2BB40008
X-Stat-Signature: eui3mqiapix35u1mzwxdh8ffic8xhfjp
X-Rspam-User: 
X-HE-Tag: 1788416149-68902
X-HE-Meta: U2FsdGVkX1/SJTiZBbb6Dbu14IRV04x9LAHDdnWKLFWakKkZVoQODmOKtSNqXw/g4WFi+2Dl1GuqYwHfxLYMOOhb5X4UMMjYCYJ5BFNU2MSE50ir3F0BP8OPoBNHehUZtbLEoWka1tzsb28DdYjcsChz/kltbWf/AMwPGSYdEVQifdnL3jKiMAtVpul93wMt4tQ374acmKbQN7LgzM5STQpNYyZ/WTlkC+nrjF2VNrGbDCvGB6sGMytcjPvxbJv66h34hD7u+Gmz1A4JXc7oJ0/1XQaKaM6+Ioz+ABhMC0e5ecWXP9gDHqjqurGy84Va8v6+oZKaubOohLWaTVwiLRDQDoL4oSM10I70f56hZekV75L4RTN4lKLsxzcfmiIuIP/D0jcfQ2EHrwa0zqK1iphzMsBQgZYNZC1Toy+CxQIj7F15diOLkHPF6f/CEjUpjQVU00oF26QBwAiCBHPqGvXLuInS4e/zKex6lX9dfahn/WpjGyyIDNXyOO+JFrQW8kgCEDyH2Xj5Mz8/Qc3mwtIaXFSKY1yg5Td2vge/Rqk25IwiEjhS3kz58uJ4Zx1irO+xz2d5lwQ9esXXL21+kIgBpoATWXzfyAfVI3YZ08FhkQ8k+agya7fYyapoZGUqMbaHZOdU+pFLREA06uA6LUbcVrPUyldcru5e5fe5/r7DP85kqOQ2kYCEuVo03q+U9BeqWzgA6yK3ZuuL6BypowokIe9S9mMRGOScjgzIaTa9ADhAzZo9+/Di8UQ5OsWMQ8eATpPSqn3/7me+Ni6w9OazBA2c+0y6ROsyRbaCa0ifcH9Pq4zCmyh9Lev7qiNSMdv2R4gd3R1tGVEKhMA6vzaJwabZy/OnPJByLEbghSRS+Jf+CvvMueWbeTqUfBRZo8lJb7RWPxlv58g7UDKgmUWOIcBLYSCRpG8PHhl+OR8ATNWaREq+hNAnkRoUsqcSWzR9kUbV+yme8sD5wut
 LMy1D4V4
 HnMhOGnwKACv+tfO9ChsgJTrQjoaqTcMUeeMVELuiTTzhWbYJWfeCsgr843vm2JVMTWwF+yzfCRJtxoHebPMGhsiOK9DOHiGHLQTDF2angN/R3DK0RpWe1dHWeCPIJRP97hdbkPG5vtdtI+ybP/imqWxSuJOohzWE8LoKRAFNeyQMCzrZiT9cSILT3e7g6I7bO03I5eOODIWWKjrKU0zlfARNq6N0MfVMAQXSF9f5pUa0WOvoVxxMi7AKwhI0cshToCZMFV1SKWfjsh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 3, 2026, at 13:35, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Page flag helpers for configuration-dependent flags provide false or no-op
> variants so that their users can be independent of the configuration.
> 
> The HWPoison helpers do not fully follow this pattern. When
> CONFIG_MEMORY_FAILURE is enabled, PAGEFLAG() and TESTSCFLAG() provide the
> regular, test-and-set, and test-and-clear operations. When it is disabled,
> only PAGEFLAG_FALSE() is instantiated, leaving TestSetPageHWPoison() and
> TestClearPageHWPoison() undefined.
> 
> Use TESTSCFLAG_FALSE() to provide the missing accessors when memory failure
> handling is disabled. Both accessors return false, which is consistent with
> HWPoison state being unavailable, and makes the accessor interface
> consistent across configurations.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


