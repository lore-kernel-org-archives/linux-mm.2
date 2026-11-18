Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BFD1606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aUlNQ8fD
Received: by kanga.kvack.org (Postfix)
	id 771916B05B1; Tue, 17 Nov 2026 23:09:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749306B05B2; Tue, 17 Nov 2026 23:09:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65EE66B05B3; Tue, 17 Nov 2026 23:09:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1846B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:09:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D18A12065C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:09:17 +0000 (UTC)
X-FDA: 85446909954.27.AB807C8
Received: from mta1.migadu.com (out-219.mta1.migadu.com [95.215.58.219])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8871A20002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:09:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aUlNQ8fD;
	spf=pass (imf31.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.219 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794974955;
	b=s4IY6xyddUI9AlwDaNC3HQvIuNCUXbd6RNug5UHy58PZLyciJaJtCzCfsxbtAx8ldvt7QP
	AkUzZX2+1SgBK87SQAgIurWxALPCY4CTJzv/zbRA9B/lMxQIkhXqXSgYbK+fXb8DeiIFwb
	/vUGCIRSKpKeTZ2jj96Tb5TdiFJd6TI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aUlNQ8fD;
	spf=pass (imf31.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.219 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794974955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gO/JIfcgvTrlBo/baVGaxSVMIPH4zI1FEGs1Iqz/bPA=;
	b=u/lBHoh7P6emsaZauVzG2J0IEpdERfEwsPD9VBK+XLScCIEoMUZbrvko1a9//DE9b6VKq3
	8IF+reZb3f8qzEpGSLU+HgkG+DEQ6OK+A8xtqHA6CqgNtr9+HNLwo/qY+J1HD1cgUguhjw
	2DylELm5NDytoqIdiKto2pBCLNQoAy4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kKP1J72ZJeOQfMxDWBKM+TEV898mVVp1LwfsakS8ddk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794974953; v=1; x=1795579753;
 b=aUlNQ8fDSTm6yVezvnyz8/frbGAzn3IEaGWblRIw4JmRsujNkcnqkn5j2cC0P+QJ0DxA9EvE
 aBXh+QBS6wklViFxgUIkJBahCQAWCsTJt0H9Sinn9bcc2m2VxOqs4/EQlBDN/bPxCkL4fV0/8TB
 yMWOnrmNT9wThxo6MUKqGnz8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 29c80f066480eadb;
	Wed, 18 Nov 2026 04:09:13 +0000
X-Mizu-Trace-ID: 29c80f066480eadb
X-Migadu-Flow: FLOW_OUT
Message-ID: <38118330-5cd6-4f32-9098-a3d07cc7b3cf@linux.dev>
Date: Wed, 18 Nov 2026 12:09:01 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: allocate nr_pages based on pmd size for
 uffd pmd_move tests
To: "John J. Coleman" <jocolema@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, liam@infradead.org,
 ljs@kernel.org, mhocko@suse.com, peterx@redhat.com, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, audra@redhat.com
References: <20261113040045.1439391-1-jocolema@redhat.com>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20261113040045.1439391-1-jocolema@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: p86kyx8umosooqyizw5ngg5a3z381fb9
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8871A20002
X-HE-Tag: 1794974955-528533
X-HE-Meta: U2FsdGVkX19hPTWObujV7w46YLnl1C0EJn4idESdBQnB1cy2y5Pt9WtgQcWdFCMWypymFpF1sW2xBDzeSmMui4+5SPU8mg6TLihUnQ3GUbxkUFdjtzmileH9gUUUYMTZQrTHqRcn3wqK5LYn4QziAAGYmJQnm11W+ywmYmJkSQI1Ti/ztMAc3FcvVF9onaH8zC54nP4wgzF4h/GUrfeSRDJs0W897rdPuvT9tEoyTG9knd4yMApuDVVpVS4vLlSETGVZO+CrSYIMWeqP15kQSvDw837KVc+r8QtjrDGwyeU5TDRWslo+Q/xOEZ/uH3dkf9Te6GxnCPq0anffzw+CaVaCjaOqBpuqFdmDhNqlzG5yYXt95iA+hl+LGMjecgs4IIar32kG/qkpEJUF7y4OZHHj64FiYW+tlleHMkZ5+h23YzJVBUy2/iOEm2/izCU2eHwcxSNy8kOG7tBxVNsfXBp0Iovu0Adzld38JJohNgHes9fxe2sehdV7PBCGD242q1VUPbQ3HkADblb1Hm/UCPqbrftAaHyzYFAF5qN5fH/9tpg/aQzGDnyfHZykMTbYXzKFy+5Qdv3PKxHUArZBI0Z5Z4h0ckj4QjEsBlqcXRQTqX3z9O6G387FLxG9pXQ5TzOUCTz7OSbPTr6Z4YgQSxEWmTty3o9vLWklUeKHR3ynV9rOTA1XADM2n77IGHXlUuefAYmyOYwSywfTaliUoATgtQZVfA3NFH2ijn13dcvI9+XIHrhZ8xhIujplkuAJQFbnzFpGxYdak1AVVKWTmPemB1n441PugoeePihBPljUpnpV9nbNt673HGlIjdFjZm7LYV+5cY89Yd9uHAPSwwQqAy3SnVpksRK+ea4yiokK05Bg+ezmL06M6igodXWkpDP2arU9XFe/fAh5+1ntKOPT4+dNMpDVT2dqK7QdjzhDi0Zwo+TLBor8PEbo/Dmg+EQgW/xnf8fBD9nelmT
 SwaHp5gY
 Z7z3iPHdopug8GXHMyUYZ9VOB560zLIyIw9a+PhLP39nJuUXI/Cfu35KYiEfYd2iuDyT/8pQ7e4QRXKAbqlhadEhfQKzvLSwYn4WRGi1qpWDjnFRi+K9IJHMlhvWSxMIcHEZewSz3yq9WqqOxgbJeWdS7yTaz7GCcWI4HHeX9BxqUFj4k8BOmDvKVFwtSTUGp43VbwcgMNGitGlu/MBfWSwIYYwAesn3q+piM9XRd4HGOulZrq1mcoupEIszaMa4NtjC8tmNZnxWVjvLReoO8W7ek8opFSTrcKE5vqG0AXuM08xNieuR5IU1WQiNrDmvjcwvTUJ7zbv+M0B7/8LngPtoDx8DIuWUKWm125wxch0WOuiKW6E3cWcaAlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi John,

On 11/13/26 12:00 PM, John J. Coleman wrote:
> When executing the uffd-unit-test, the "move-pmd on anon" test will fail
> on aarch64+64k with a segmentation fault because the initial allocated
> memory region is too small.  This only happens with the move-pmd* tests
> because the architecture base page size is still utilized even though the
> memory region is specific to the size indicated by the pmd.
> 
> Patch 9f5c2aec3388 ("selftests/mm: fix uffd move-pmd test crash on 64K
> base page systems") implements an initial fix to the segmentation fault
> by skipping the test if the allocated memory region is not large enough
> for the number of pages x page size requested.  Since this will skip over
> the aarch64+64k pmd tests, this patch is intended to resolve the problem
> with 64k pages by pre-allocating the memory region with 2x the pmd page
> size (for area_src and area_dst) for only the move_pmd tests by using the
> uffd_test_case_ops pre_alloc hook.
> 
> Link: https://lore.kernel.org/all/20261103202049.499206-1-jocolema@redhat.com
> 
> Fixes: a2bf6a9ca805 ("selftests/mm: add UFFDIO_MOVE ioctl test")
> 
> Signed-off-by: John J. Coleman <jocolema@redhat.com>

Thanks for chasing it. I've tested mm-new (which already contains this
patch) on my 64k-page-size box.

Before this patch:

 ok 14 # SKIP move-pmd on anon (chunk size does not fit in the test area)
 ok 15 # SKIP move-pmd-huge-zeropage on anon (not enough pages for one PMD-sized move)
 ok 16 # SKIP move-pmd-split on anon (chunk size does not fit in the test area)

After this patch:

 ok 14 move-pmd on anon
 ok 15 move-pmd-huge-zeropage on anon
 ok 16 move-pmd-split on anon

So,

Tested-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Thanks,
Zenghui

