Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70004CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 07:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE0C6B0092; Thu, 15 Oct 2026 03:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86EE86B0095; Thu, 15 Oct 2026 03:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75DAC6B0096; Thu, 15 Oct 2026 03:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57FAF6B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:22:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC4FF160975
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:22:04 +0000 (UTC)
X-FDA: 85324016568.22.5F3BC31
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf21.hostedemail.com (Postfix) with ESMTP id 71CBD1C0003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:22:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="dhB/h3to";
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792048923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bvlFkN4iufResh8aUq5gkEp0wJLrW82dGbm62yfvPuo=;
	b=IosFv4wDiDxkAbcbD1OYT2dJlxwp3JXYofCJd4TKr1nlKNGLzF3VZqqdXd8ATK/tH7b0Gr
	sbDBTP7YDPUln+QiVD6QbAbq4tatPP26OELkZ47Q+WOGw5G9/i3C9jg5akhCEwQZ0hdN5X
	4cb3M3kveA8wAhpYNieH61fB56fNP2E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792048923;
	b=BdGTUHqj3KUCTU/Zyn2R1reScGPX9wFEsmOBVIhdiViELVfKEYUgV54J9j4zU57vFJ/HtV
	bbmOFipVTGm0gkYAkFfw1PuSv+kDrHeiYolYaDqekkIJB+jnbKKkb9LssqMClp8DZ5/BXR
	QO0Cnbx/wrdVw7aC5Yu8Rmwv0XjZmWk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="dhB/h3to";
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792048916; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=bvlFkN4iufResh8aUq5gkEp0wJLrW82dGbm62yfvPuo=;
	b=dhB/h3toyepzpe8s8VBz/MGZYh0hvm3gyAZZ40dyrrulBPXK7rMScJGySTMoICMSCRaKUZM9P6pkmuZl4v854l95vyqqLz8O5vZmcCgkoZZElJcmP4uEjRGIEr4NTbf4v8cMfWcJrV9NVW904YvB7l1iQvMzTZcF99VGRdsGVCM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XCr-GAv_1792048913;
Received: from 30.74.144.143(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCr-GAv_1792048913 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 15 Oct 2026 15:21:54 +0800
Message-ID: <6cb37e99-c84d-4832-9f45-64b816281908@linux.alibaba.com>
Date: Thu, 15 Oct 2026 15:21:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/9] mm/collapse: call collapse_file() from
 collapse_single_pmd()
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20261014171145.3292736-1-kas@kernel.org>
 <20261014171145.3292736-9-kas@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261014171145.3292736-9-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71CBD1C0003
X-Rspam-User: 
X-Stat-Signature: gxr3x873dyc58hojrdbntiy38q15abdi
X-HE-Tag: 1792048920-372397
X-HE-Meta: U2FsdGVkX189vWohtQ15T+yMrf3bKYpsm5a6teKAzBXiQ1tVOZr+1S1TvRSxOMZVcTTaFxBjZXVkYDdrQ8J0wovdU0avUFloSJ9A98EtCY4Qm7HaudpmRcqoHqOlRCAjrpYUCs7Jp2l7dLP4omDfH0dS5b6r5fMjU0N1vgaUYwLb23bcjt+fI8JKzQRunR+cvDan1trUzlaePbdDxGv2oyk53iRnrRGhcUuvYnds9ktjlEp6rMLejzOghxgr8PL/PV61JGfijgfOmZTusNSif9Cf2wyT+oIC5cptC3zqcF9A1i0IpKtxN5I/e+bU97re5q20MU6Wa4Rt0ikljD07FAUmDsltc1F6CBIPPEsPkYZeyB6PjYFb6dGV/1kNYS6BrBwqeXAG9cqhaL88JVlluVS7ts6qJF6VFPpL7Ng2+9LFWwTmflTqvkDkahMBvfIh56+Pv2PfJgcMe6kzsMJQq/qM1XiV+g+SoK1qnazpVNc3cHaZP2J1icLI3E9GrRr8kSV8pOB33DyqPTNeRQy22Ku6pqpXvYwJEp8Hj6FPLZWxQoC42ScNSsE5Gd0btcaRdWaJkdRUX8Aaes06NFhrQPtNm7u6NqoTvLqLPImAa1cxEgzZ72QBTIR+08Pefa8S+syHU12fugvjsF0UHO50XqK1LmWZpPFp1UNPIOUi9k+YxDfbhN+qEBMOKH821e0DLD7ZSArDZVfns0GlRGyeLLQK3shYlv3jn7kLa4bFoxbS95imBrp1LHYfoRtdlGVmMTQroAdGquBQG7RcyLu8g6cQshDJYWM9mGn+0xfDCC0ojNEJUWVqx87qZYVd4MoPJV1Tl1RHL0kvGvaQPsTTXSVBwDLnJ69ltr5zDubrVvbqWaE6kJ5bog6rIhpx9KFXDNyIxMpZnxlp/ihtAHTD0LBYoB1lvAYbvmtKuaKZoGMBqDltns5WN5apYyHsq9lTCPvsI8wHols2uyltnD7
 CRTs0AkG
 4snhHtTbygXBEnpo/lfTugeCWfzKthObhH9KZTXnwujTxA591LMmTtYAwoKHFK5PFIRW4jtXDyAtelnpc5E3aZwydaoIeo4T8W6xltyWG6a0nqN7GUgqh7nuXzLO6tjGA4obFCE3mt46SSza91Cvm9CgJt843Hn2zJyuUe68yel5ErQ8uSpvG1f9cy+tb5ZClIUH04Eh8MSoC0aX6DQqGZmpKkSkPfRW0KcrFoHGnVcUOxZ6XEhHWUUbyvAyb6UoQDHIjiwu+C4puD0ocn0h+4//Ja5MMhqLpe77X2Qind0I5Js7aLdWw9LkFjTHC6iDkgf5O6XDwp5MjF7aiOt8yojSHGoYFr3bFNTr31mcK/MGk4Gt1gA78PWxxirRdMM73BzbKzj0OqeDEYNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/15/26 1:11 AM, Kiryl Shutsemau (Meta) wrote:
> collapse_scan_file() reads the page cache to decide whether a table is
> worth collapsing and, when it is, calls collapse_file() itself.  The
> caller cannot get between the decision and the collapse.
> 
> Move the collapse_file() call up into collapse_single_pmd(), so the scan
> stops at the decision.
> 
> Two things change with it.  The writeback retry re-runs collapse_file()
> alone instead of rescanning first; collapse_file() repeats the scan's
> checks under the page cache lock anyway.  And mm_khugepaged_scan_file
> fires before the collapse, so for an accepted table its status reads
> SCAN_SUCCEED; what the collapse made of the table is for
> mm_khugepaged_collapse_file to report.
> 
> Preparation for splitting a collapse into a scan under mmap_lock and a
> run without it.  The file scan has to stop where the anonymous one will.
> 
> Assisted-by: LLM
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

