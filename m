Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 883C9FC590F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 08:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBCA36B0088; Thu, 26 Feb 2026 03:57:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69FE6B0089; Thu, 26 Feb 2026 03:57:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93626B008A; Thu, 26 Feb 2026 03:57:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C71D36B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:57:10 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 790011B7994
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:57:10 +0000 (UTC)
X-FDA: 84486003420.05.403E41F
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf28.hostedemail.com (Postfix) with ESMTP id C1A67C0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:57:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="BytB/PsA";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772096228; a=rsa-sha256;
	cv=none;
	b=yTuU8zhekCJdALzrFP6yGgiyfek7Oc/YXapReMhrqMbuEpdvOScCxt12ef0+zFSiygD4QK
	eFVB1/Ml5zDAF6I+NX2AYWo5Wm8peulGGoV49Zf0N8o8q3VzbxCo3JDkcWeRniBWKsCALi
	YMeZEwD8QjK6+7PCEBhA0x5BiNK/vH4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="BytB/PsA";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772096228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7BoKbMMMJWHf1VjGKYbdXsNGYJY+/g+XoYY+Ydm1ps=;
	b=tFbqwCTBxAaSpILd9/gmNlLAK2SC54m5s92suQutzWNGj2cGG6voiFQCSdA5rCc0ATqefg
	DmGEQf+b6cnMixu0RMOfr4/MUL9wHuLq++HfiFqpigVV+4yJ43Rm8QnyyjjMMRIq5VCFvV
	5hMLHJ538YlvFHfRpVGZmnSGhcSUhso=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772096221; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Z7BoKbMMMJWHf1VjGKYbdXsNGYJY+/g+XoYY+Ydm1ps=;
	b=BytB/PsA15A22qLvkEqBVfAp4QcnzeKFLDBi7fkmfannoo6giAGaTtI7wFhywXRoRurOHrBvlU3GhqI0G/ST3unzPtDF/v9cX3HY6eCa/CXwfWWPUGjTEzP96tzEGP+R7/TcRq8d08GgXMbUe1FwMubTWUJ3ilQBcFV3kjYA/y4=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WzqmKHv_1772096217 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Feb 2026 16:56:59 +0800
Message-ID: <9038265b-7066-4fcd-9b41-fa7ad6c5a07c@linux.alibaba.com>
Date: Thu, 26 Feb 2026 16:56:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v2 3/5] mm/khugepaged: define
 COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226012929.169479-1-npache@redhat.com>
 <20260226012929.169479-4-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260226012929.169479-4-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9cqm8yjtayak5chbqjxdr144wwk6w9h1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1A67C0005
X-HE-Tag: 1772096226-923839
X-HE-Meta: U2FsdGVkX19vBGi6P1wcFUyRnEQCuwHnmkCSfMFm3nQXJab7W4ISFKmiMXIr0qprlRVBQYJjUftA24DMvWcLYQc5oK+hfMjoymWW53+6hnSnEglNn1FGTIz+jKkump6u8hWLNEwjcB8byAfv8ZuR7B7uwyGxG/tqNLElKLF4N2+xMKQj2qSrFC36A2WNKZcMq2ceFYG62pmUWXubuE1GGP51Jr4DdIGU6uVnRhYd2VvtTS/rUbjWce/8PLst93zvl3PFsLeymsTCtYVcLTOSJ3wzaI+TasWPoWWsnQk2R3LHvuamyUpnMhtZWyQyDlOwYWjjBP7IfKD+0VnT7YVJloI4B1ahaqd/z67IB2RpCsb9H9noTy+VyGQdu3CbbOEzjnyPhAu8+1bUyrV6vkbAfyOQpfI+fP92Z9nn8SlA+0Ly50UIi7qphevWX1rnq6uWCglqD5x5oh4DOxQgLI2MG8Lipsm/bN7inB4IljtK9jImZzr/KZ5O3Zwf2qYSjxneippLlDCAkoo1/9sCNuKSNa7UjeN+u2bKXBOPXBguHzcXyz9hJ0+FrULIPN2Fe/vKlbsr5qj/angguglXBsUxG8MzxxX3AmaIFLMX0ZHlqtP2hOx5TAp3mmilia3GsQ+Xi6MeW41VbBt9fiVD+ZLMFnhVu+vtP1WWQzywCx/VWZP924gdqurS8exQS/0nwVyIjQhMN+P+Jh5no0m9Oa0m0AG034Nf2nypOX2OThASh1gGTy8VlVRJRp8IiJBJl6h5deycxriOx6cb2MOjHPiyd0Kv0AUAsh0LONaZMnaGywWsMTTT+LwIcZhtRff9B4Fesa3Gl7dxzKbjW8OVCQ6NjBO2i4bUU9uD8HIXSjPV4tfEJul0AGbkiquL/kn/WWC+VfqQfYF6wvyNK+51pUVaxgQf8N8/K0x0QtErPQLD0zaI128ymxKn3iCSJIJvKuiOWIUbsPygFOVNHG6lKo+
 XorcXmjd
 i0c1iPpTFsKGgDSjegMwY/IlKKekPJ2t35ZFU+GPru2AX4L5zDAc/WI6Jdf4jN9dctUVboTS7cg1iJyeUxKxoLBr5J4LyawNQXcjl42BWxh0K3v8pbxd5xBrPWddiISGAFUDHa86REEqVSYBuD+u08xy/OAtpvFQkwPKrfJDYXRWuV2g06LhWfzT6XnPNI6/m0lyhy7ArqHdWfIyLwoqqUEDG8Z9E43ZhTjIx9bsVH6UX5f7pklkUZbv7k8jxVCqsfH46kPPI8LOlLfk/hgv0nGO8U9u4wNQAbwRjrBeNItxQVc/OEzCa1GoxogwDiLqyuti4NG1fGqziE7thwiU2+AxCPHppCMtzshSZ9RF8cC2zK4YXKU/FGq5MvgSfDYhL5MXzS8RlQYR3gmqbyHd12LbofU+ccY0KMuqG792sCX529/tejrbp3a2+Ti6LccN/6h29bbT42ALH2SG9m7loVdIcXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/26/26 9:29 AM, Nico Pache wrote:
> The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
> signify the limit of the max_ptes_* values. Add a define for this to
> increase code readability and reuse.
> 
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

