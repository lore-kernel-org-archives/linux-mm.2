Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72383606D807
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FHJxEDOr
Received: by kanga.kvack.org (Postfix)
	id 9E6A06B05C0; Fri,  6 Nov 2026 05:06:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD096B05C1; Fri,  6 Nov 2026 05:06:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FDF56B05C2; Fri,  6 Nov 2026 05:06:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE866B05C0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:06:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0EF3A1C4160
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:06:38 +0000 (UTC)
X-FDA: 85404264876.08.0F15262
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6ECA810000D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:06:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHJxEDOr;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793959596;
	b=DPy7FwDG32rP8uEQN5Ke0jSxnTYc8VDjrurleL5+tipw0juTyQnhEqprZPFuqzLQkzTEyC
	sUY62e7vRuFNm9Ky8+Jegaiy5h8NVUMVQwc0FzBuTmykQeqzXLOFOpwyuCaYJJd17pxDVr
	mk4BBVLZlHMadzLAbeafdvgpHtWjCiw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHJxEDOr;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793959596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFGqHmlZ7kyyucv0XoyuudTtcwfUCAlrm/1qIgBDADc=;
	b=rlifxHBk+0jkUE2j75h6jfluuUDKU+7E9w8Tq8+nlyRtwgw0OmTZAuwwAbaDpT7dY0zBTO
	aBziPxgDLGTvKnsUfij+rBqzDGXI8tOjJt0S8HYiELuM5HMOJGWsTm1nzbJejmakbkgZUt
	RaQh0ym3jtAyDVXvik7tWk5UUZZs1as=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BC9160232;
	Fri,  6 Nov 2026 10:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56491F008A3;
	Fri,  6 Nov 2026 10:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793959595;
	bh=KFGqHmlZ7kyyucv0XoyuudTtcwfUCAlrm/1qIgBDADc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FHJxEDOriuMSmbOrU4SpGNiSBKw/9Jb3uq4aMlW72XQdEaI0v+BxNt2FtxfjKcb+/
	 ZPsDBhnXm8lOz6yhMBT2nLrbPdLZRVXBGuIZzUJPXebDCVraSzlADyzTMcotPyQgU/
	 aTxPZwGvLAZK6QwWmv5JLrHB/AjfTEAn5GYGsbmZVCL2U92/3LEd+E1ly0V8uuPb7C
	 h5mkmVQqo+473q5g29BJQy2CuKty2qQOJtZfqNskDjfEPImTI6UIndQCCZ4Gsm+eRu
	 l1bA0vdJwJSinqCKRZ/5/GusscDywb+rHrmooSrY4uamHQMWQyFvOdjFzFuSoTuEG9
	 w9CGcyUhKyoXA==
Date: Fri, 6 Nov 2026 10:06:31 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/ksm: avoid unsafe anon rmap dereference in KSM merge
Message-ID: <au2mm0Y9PdumuzgE@gremlin>
References: <20261102-ksm-anon-rmap-fix-v1-1-68962acfb59b@kernel.org>
 <179387163181.11797.15205182972949028650.b4-ty@b4>
 <75926835-508f-48d3-a5d9-176cea61546d@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75926835-508f-48d3-a5d9-176cea61546d@bytedance.com>
X-Stat-Signature: i1duo56kx3grdj5sgpn8x1bh8r6a63qs
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6ECA810000D
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793959596-225601
X-HE-Meta: U2FsdGVkX185mybuM5S5ig8cUd4dwTJ8Rln12XritclQ9syQL6wjLidK0ILB8p9GHY4d7uouB+uFyzf/hdFbZQYZoQ8SqZwP/XVicevhkpJ90vkOY76QQAGPM2sXixh5hHW58vrv6ln3jFCq51ARjrnNfllitUqeo+HaX5ixZPHgZRlAYO7fmpQjmB+Y3cwEWonJmHtxO95PjGv5+9l2uRcQmXdIJG03a811jjp1OKWaIcHvErw7tu2GbwhAGXcFID9fwaXj/siP7xAgX0rtlpRjG8n1SSDj9Z5uphYjSZml32cMXS61IfvlvHeAX/A+zqioisk70GjnKkaVnbZZYGmRCJUqPwGtA0cF2BF/hcvfb0wdhI6McO0TdZ0I6lkJaKnNTQZHg5/TH1FR8TDq1a939tqyHZf37XSwccZA0r1cA4enOobXJFmZV8QX7IrUNFoaZOyr+GoU5tPqj4BCpj1bCw181nwmfCurfN9PEEjRyG1BiFFcVkZ5MweC9Zt9kNyLUkkTWncKK913wJrpiC/QO830abfsIwVq5FlGeiEPy3pywRrlZJTjYsMptgs5tLUOb3hB8RRF+a2cnYmKWE+/k0eAtNWkP9TBvb90DwOYKUcUDZjAZhKNVfgl7onL+1eBiAIt/M1AbMLRh3IFHIaCncikNFf+G0qSBjDCgPutaPCCQFAjVYJD7s/yGyFB8Oy8f0VVfEH4YIKOUXS2yPsmhj5GNYum274pyGDmD2EO1ayQyjNc411+iUUL0Mcz2Szb5wpsDDW9mqNUuSpXp6Mf2Dsi2QcVwy54AAhKJcfwcN7Ga10OlQRCDIDKVwHozpyEImQRsP74vZTI6+BSOh4FOR2WMwi8Kpzm5Rs7O+lieivkMiNUdPEJYT5MfMHIE3xext8HlpFgwOINLVat6eY3xjZHwuCF4lvcoo22YZ2fyDVNRQZNcPTqCzrFlFdCyqXF/pSIyERGjCxr40X
 H8FkgWWh
 x+IL43wmF6i5HAT2YPI11mjSD3XcIqhPutOjpciiIUeP3HD3bJ0DG/lKqRpC5eUDCpCX6ynZGfpcft1COYTawhnrRGPqza9H4SybPTlJavyiwcXWIk/u3U7CqMSJVHpmdoXmLvSLYv6et7tddnLAbMUTlpU+ZSUAZsLEP17ISi2wEWe9HJS+fD3PpAnBOc9LpwOT1iL7MTfwX6HWkJeHfHqAdvNV+cLY3f5NFzjDK5SoW8lfszalsBJouIPD4EzWV0daI8Dwtuu5c+rCwzIye0fyHOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 10:43:45AM +0800, Zhao Gongyi wrote:
> I tested Lorenzo's posted patch on Linux 7.3.0-syz-13001714+
> with CONFIG_KSM=y, CONFIG_KASAN=y and CONFIG_SLUB_RCU_DEBUG=y.
>
> An earlier unpatched run of the fixed-pool KSM/mremap reproducer hit a
> KASAN slab-use-after-free in page_address_in_vma() after about 342 seconds.
> With the patch applied, the workload ran for 12 minutes (1027 KSM full
> scans) without KASAN, BUG or panic. The fork/COW smoke test passed.
>
> ksm_functional_tests reported 8 passes, 1 failure and 1 skip. The
> "ptrace write failed" failure is a known test-environment issue; dmesg
> showed no kernel error.
>
> Tested-by: Zhao Gongyi <zhaogongyi@bytedance.com>

Thanks!

--
Cheers, Lorenzo

