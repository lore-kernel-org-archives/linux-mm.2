Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A2FC88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 04:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832DE6B0088; Sun, 13 Sep 2026 00:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3E46B008C; Sun, 13 Sep 2026 00:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE7E6B0092; Sun, 13 Sep 2026 00:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44BC06B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 00:37:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8FBFA065B
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:37:39 +0000 (UTC)
X-FDA: 85207480638.19.02E7D8D
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf09.hostedemail.com (Postfix) with ESMTP id 667FB140003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:37:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789274257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XfiM8qodCndFvKsNtjk+GdFf7D5yszFJi1T37i6qvjI=;
	b=vH+lTYlIodAfXz5MzKQO7/0lJGKhfMv5AuSrlNVeKNaajlnii4427szyNXlK8haCv+EtW8
	Syeh2cp8K1tUiH1F9KRx6f2PAi2qUnkMs7RPdskN3GwOaff0KU1kXcgsu53X1tzGfsKci4
	rUlxtuKHiATaYiwNqHg78A2r1OSKf9s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789274257;
	b=bbwnQFgiwVJGdgb4tV6Hrlq+EBNhtcTsg4HqMN0haLfxSr/lemNHgNITNviWP0P9vo5s0g
	KHFhZ2YlLn7n6se4enuZ+JE8YaA9duGJwFaITBPIYOErqQEzkU3tUkebSyVkrk/Hjz6MVH
	Sa45zuYR+ohOqnZI3ZhmwthpbfzARBI=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hjFrG0NNpz8Xrnt;
	Sun, 13 Sep 2026 12:37:34 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 68D4bQe7054530;
	Sun, 13 Sep 2026 12:37:26 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 13 Sep 2026 12:37:26 +0800 (CST)
X-Zmail-TransId: 2afb6aa62886b18-d40f3
X-Mailer: Zmail v1.0
Message-ID: <20260913123726763Xj9aQ4CLYQy2_J5ovIJCG@zte.com.cn>
In-Reply-To: <20260912082407.75875-1-xialonglong2025@163.com>
References: 20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn,20260912082407.75875-1-xialonglong2025@163.com
Date: Sun, 13 Sep 2026 12:37:26 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xialonglong2025@163.com>
Cc: <akpm@linux-foundation.org>, <baohua@kernel.org>,
        <baolin.wang@linux.alibaba.com>, <borntraeger@linux.ibm.com>,
        <chengming.zhou@linux.dev>, <david@kernel.org>, <dev.jain@arm.com>,
        <gourry@gourry.net>, <harry@kernel.org>, <lance.yang@linux.dev>,
        <liam@infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <nico.pache@linux.dev>, <peterz@infradead.org>,
        <rppt@kernel.org>, <surenb@google.com>, <usama.arif@linux.dev>,
        <vbabka@kernel.org>, <ziy@nvidia.com>, <ljs@kernel.org>,
        <xialonglong@kylinos.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBSRkMgMC8zXSBtbS9rc206IHNjYW4gd2l0aCBwZXItVk1BIGxvY2tz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 68D4bQe7054530
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 13 Sep 2026 12:37:34 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA6288E.000/4hjFrG0NNpz8Xrnt
X-Rspam-User: 
X-Stat-Signature: 5us9qf9ntwm7tew7dirouyyp7rz3ximq
X-Rspamd-Queue-Id: 667FB140003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789274257-401382
X-HE-Meta: U2FsdGVkX1/tMedCQJkgN7If+8knIuxKOme2jGeqn88rGsQu+253pIVrsWhRkGs5E1yXNwGPukHKa9rwx2QYgfQJGNgDW2KJ+T1nu71fXxkMpTZosu4fA/qC7zPe7Ttz5aKfa+ibq+XumG0Nwl46trT4Pt0WtIVFc71e/NXuEsQi47YULASXUOaw+rNVf9aUQOynAXBqD5ldwpBAUuJoMGxERNfI0RI/MwDX4PQRaLJ4tUM3zCwrh+ZfEEtOzCQdOusIrgwC4vW7T7OOLiJNHRde0dLk8mB9Sfyd3pt6QExO+Br+J/juE3ZyQv9tA/EO3od127oPyovh+pHqv3qujaLKdoseBSf3fU0DcQUIJg2rCmxB44hq16JRLNBe0S7wZbQ1zKcXSr8PcqQwRO8oBIxYM9Lsf+QdiC/IxAuGcL+BY8JzUU8ND2iWgYTbwmgxkcL1a/Ex/ZRxRODWOyChv2S2d0BbBrb1e+bdD/BPajlztUeEAlJB+2/L3wgOliHkqA3HU6wjbUMPMxV/B9h5iGNiXgnDFrchCj9pVE2VmOnR2Y0akdCCen2JhJXwWR1WSFjp+q+A0skmkxnhZwzhfhbqALHZtr87deCSlLNz8IrhTMtyw8OgIeLfcf0WnM7O5QiRn595Gwo4qwqi6R6x94AVcrGBMid5HL/59S1vertxIw61tJEek4P+F0n8Rq7Z16rWrJyu+pZlc1nbgd8+AoQ380HOt1JzCzBR89ak+KhwxN1+QZ0rub6mMp6aeQ+KYK5OMKi7Ia0hcQh5tyydwNVWanH+sxXAoh3YNrD8w6WeYfMIOsQITwA+tTiprUGkImsdHXSyfOx8rjE1yisA5e0qxZLoDg+2aWU2j5pODeSJ9y72dVXeh4l1EOSg/8QpqeFwcVpCQVUzME9aUq9V7KK/h4M0c1ZyoPWtivMl+s4pXb+oaeWjAfITXVcOYrMz16pHso9fECyldzkmBG3
 fAc6tiqz
 /u6JtnhA2DLaFpOfE+A/Rho79Vi605/5VRAM4bQpC3gVL5oS5/8GjXPkkR2XHbd8qmcUnRvHODUVz6aTRE09QmFbpMUC/pCxdA7QdYImwOzJrAMecYQobA0TnZjl/Li5uSst3XQ/BFx9sALJgaLnW2SgqwPOYWAN3eNXs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> This work was developed independently before I saw the above series.
> After comparing the two implementations, I found that the approaches
> overlap, so I am posting this draft version as an alternative 
> implementation and would be happy to combine the useful parts.
> 
>   The main differences are:
> 
>   - use per-VMA locking in the ksmd VMA scanner;
>   - revalidate the mmap-lock sequence before skipping the fallback walk;
>   - avoid repeating a completed VMA traversal when no candidate page is
>     found.
> 
> Benchmark (QEMU q35, TCG multi-thread, 4 vCPUs, 8 GiB, x86_64 guest on
> Ubuntu 24.04, 7.3-rc2 base, CONFIG_KSM=y + CONFIG_PER_VMA_LOCK=y;
> victim: 32 MiB anon, 2048 unique pages x4 duplicates,
> pages_to_scan=100000, sleep_millisecs=0, 3 runs each; churners: 4
> threads mmap/munmaping 256 MiB in the same mm. Microbenchmark as
> posted in [3]; relative numbers only, TCG is not native hardware):
> 
>                        0 churners      4 churners (mean)   
>   7.3-rc2              1.21-1.41 s     90.9 s             
>   + patch 2/3          1.41 s          48.7 s   (-46%)   
>   + patch 2/3 + 3/3    1.21-1.41 s     30.1 s   (-67%)  
> 
> 
>  1. mm/pagewalk: allow folio_walk_start() under a vma read lock
> 
>  2. mm/ksm: use the VMA lock when looking up mergeable pages
> 
>  3. mm/ksm: scan VMAs with per-VMA locks
> 

it seems your patches may not be rebased on the latest mm-unstable or linux-next. 
It might also be worth double-checking any AI-generated code before sending it out.

I also noticed that the content of patches 1 and 2 is already included in my patch series.
Perhaps it would be better to focus on my series for those and I'd appreciate your help
reviewing them. For patch 3, feel free to start a separate email thread if that works better.

Thanks

