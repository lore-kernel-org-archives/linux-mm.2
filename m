Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3467ACD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 05:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01AD56B0005; Tue, 26 May 2026 01:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DE26B0088; Tue, 26 May 2026 01:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23D26B008A; Tue, 26 May 2026 01:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEC526B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:44:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 099A9402BA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:44:28 +0000 (UTC)
X-FDA: 84808481016.08.C08AEEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5D823140005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:44:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nq04UDJh;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779774266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LOeGxgwB1u3VB8Q18Mmd6WSv8GQDWdxyl8YN5KUzh0=;
	b=G5R5+jqD2wQFdvPSIgMrFrTKRLijPBoT+RzybrXoPFha5mvNUe9G3fmaMeiRPCfEWYq+Ni
	HgdMkned3Avc2UZp6y+BeHGGU3tKpOkKXbSA9YOBtESkeO9X7q3vkpkaV9yThz/ilQIefX
	ioqPmhhIXQ1V3RUuRY5XFzAtg3h08Lc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779774266; a=rsa-sha256;
	cv=none;
	b=GjxQXjvRycCdxuVRW1ezuM+XJJdffKdvcCoOQZUdfTZNpmb5ItOxuNNqDH5pX5DN+ZW0z/
	ibY79/ntrLzWCC4ZVPhJQHYU8Sq5F8yo8+my0qlNNOcnFg1qVZnml1MlcQe5rMzhujSbA9
	t2AyKzotP9yflgH3gYMSqQA0QQmVorw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nq04UDJh;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C661360018;
	Tue, 26 May 2026 05:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A101F000E9;
	Tue, 26 May 2026 05:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779774265;
	bh=3LOeGxgwB1u3VB8Q18Mmd6WSv8GQDWdxyl8YN5KUzh0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nq04UDJhGT7I6ZyKgOKhlOU2vI2Gz8n1X0V80IftTAF9gZBfmk28aGNvgAY1ORehc
	 ruai1IVtmqjSfo44/I6fbdYOVqpxvL+1929F5bp1/pH5HYB3dOqwRW7YWBlpTOVjyt
	 8TliOeKRU+O/WTWqVT4z5hc+y7AyMshF35rVTpH0x+ZpyE5a+suLLpewyvEifFzACp
	 rU8QFbyPKrBaaJcCPQlDWVc9MeKngzVq7hNWy8dgW850yXHMVCY52QGHPMnYmbY/ih
	 0Sl+VdkCyjtMfLnrQGD9BsQGy5/Oy22bFsOQAeIubfXGS4Okcc5wblSAzY9djw9tE9
	 J/epgrSL3JDSg==
Message-ID: <a3c9c8df-5836-4467-a3ce-a8142b754547@kernel.org>
Date: Tue, 26 May 2026 14:44:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] memcg: multi objcg charge support
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 David Laight <david.laight.linux@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260526033931.1760588-1-shakeel.butt@linux.dev>
 <20260526033931.1760588-5-shakeel.butt@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260526033931.1760588-5-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: hkz648u738e9zxszrktgcn55rgox3em9
X-Rspamd-Queue-Id: 5D823140005
X-Rspam-User: 
X-HE-Tag: 1779774266-885043
X-HE-Meta: U2FsdGVkX1+roiuaWh8QYo+tmwYS4ZX9EkJ0njkYnUauDrCRvECnJMduqZ1Ncv4YV5mOW6M+tOqtq6a+AmFDMH9ScGIa517JSLvpamulmhxcqFymyk8evye+ktZ6zy/CjTyEvV+jH4sh6efU7Ye2V0OY/Jc4p9svGGs5x1pnrmH8r8UIG8HEnN6xilKDwq+h08hnxrSU72ZeGoMim6fNNH1gWuZQMrgIqBsW0WQUyWl9ZzsK+aj4m0Unotg9+c+XYGWtQ7V9E7ogpLzbm0/TW/fW/5HDfyoLw9x30TChY57Py8swS1rc2OvMBWMNYLHapJSDhzyoEUMOlLTkBF6VM+eRiv/qi6SAAdbVeZHiX96lFGoZTdj4L9Za6Sf0WK96IBhh+HSfq+rGi+3gfQCOqvznrW4YyS2Lnj6T81FrpP/NmC+ObY2j7K8SQ+nH1phjCXMBbZEFmmbIGGAkHYQSGAcIe6YqpjzNtv5WDrgrz3eP/CwWDTQVIBD7sECS578sfX5p82XPGALnFHoI4BqohjVxY5b1TWyzYEOFRGHN+VZTY4Qun0xlRrXzXvBr8gLa/Cw6AJfTvZWQrD0nyrBLE1KXrzWtj8UU7oTGzV4zJCXNrQnbM1YJ8frEzr5BgwI/SzBx4LZTxx+p6FDLIctXdTL9E2WRzHdkBxszgALV1IETBk6f/wmHjzsmMjO4y3n1PluZtYG1veOZYqrJSoakC++JNUXQacVZeCAt4UrRXfmunif4NwyEt8xo9gpHQuXVClnGBFec0I8eEpgRjVuQ2Nbdr66tPOUB2s5kDPj+h8DwUmgNYaCeWezhNsZfMmEGG+749A9adebnk5KlwDNOcT059t45nF6FsixIoJgqTuMTCfqW4rWD7sZ5/3SCkGWLwI9tdwWC5J9ul8aXAC4YLNL26DEqK8c7PF13FWi0pEgmKfLc89/M58QcKzw8KemEqPb6v5yKfu0EX4+sdTv
 vQ7IB7Oh
 CMbuRcIyoziEx1Qqs9dm8j0QVC/0nRvvq4QdA2vTi2vzy8C2+ruDn2E0Uq5fUNZrdNHYz5fCzPeEFBITSjMGq0mfUPtISdRtwYjP2+SXxLPBYVUqUDbDrVdKsuZFTgtXYmoqkFGBwR6aZDOcLWph1p7lN4dFBRaT1a8JWPodOTP9o7jBe7UDSO8KOEiihlkfLXNpw45jUY55B2E8Y596W83/oy/FKX9DXiFm079OH5g4sdUGp+miMCirljD3uIZylaHL3frm7ipFDY9WYMK+Rc97Pmq21Zpnon/9MkuTpC4IFrMwyolExFVDgbsN8xGDiwdsfKeVbZPPCohO5qr/Ba1zVxW/dZ4cIfo4bxcWTUMCICAKz8ruFtvjqWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/26/26 12:39 PM, Shakeel Butt wrote:
> Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
> per-node type") split a memcg's single obj_cgroup into one per NUMA
> node so that reparenting LRU folios can take per-node lru locks. As a
> side effect, the per-CPU obj_stock_pcp -- which caches exactly one
> cached_objcg -- thrashes on workloads where threads of the same memcg
> run on different NUMA nodes. The kernel test robot reported a 67.7%
> regression on stress-ng.switch.ops_per_sec from this pattern.
> 
> Mirror the multi-slot pattern already used by memcg_stock_pcp: turn
> nr_bytes and cached_objcg into NR_OBJ_STOCK-element arrays, scan all
> slots on consume/refill/account, prefer empty slots when inserting,
> and evict a random slot only when full. With multiple slots a CPU can
> hold the per-node objcg variants of one memcg plus a few siblings
> without ever forcing a drain.

nit: evict a random slot -> evict a slot round-robin
> A single int8_t index records which slot the cached slab stats belong
> to; the stats are flushed on slot or pgdat change. With NR_OBJ_STOCK
> = 5 the layout (verified with pahole) is:
> 
>    offset 0  : lock(1) + index(1) + node_id(2) + slab stats(4) = 8B
>    offset 8  : nr_bytes[5]                                     = 10B
>    offset 18 : padding                                         = 6B
>    offset 24 : cached[5]                                       = 40B
>    offset 64 : (line 2) work_struct + flags (cold)
> 
> so consume_obj_stock, refill_obj_stock and the slab account path each
> touch exactly one 64-byte cache line on non-debug 64-bit builds.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> Tested-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon


