Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0484C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 08:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56CA6B00D9; Mon, 21 Sep 2026 04:45:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2DE26B00DB; Mon, 21 Sep 2026 04:45:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6756B00DD; Mon, 21 Sep 2026 04:45:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96EA96B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:45:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2202680579
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:45:42 +0000 (UTC)
X-FDA: 85237136124.28.B0C35E3
Received: from mta1.migadu.com (out-142.mta1.migadu.com [95.215.58.142])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8789A1C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:45:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cAR916Ed;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.142 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789980340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BcFs4Wd4VaC8wyaDxYNPmIuUNckeXL3HDIxn9D7Ssf8=;
	b=dbJO+lNNfykHvyokPg0ceaA61vZT2bz62WWZjWg3D47p4kEyHVCQcgpMuR+Pr/ysM5eePm
	7iBuSRin6SnWrkscoKo9o+nv8lLnEq52HUN8loMVV87tBsAgejhbyJyzTxTAhH0WrynRBm
	MNSO/p7++pv9hR1h1SEmExhHemhK9Yw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cAR916Ed;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.142 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789980340;
	b=Ejzn8qUQ+ayVh0apUXbtFb3XBIsTkLd1TNbZHeiJKlaXFezwLQmn+sKclh2i9h5UZSp7uh
	MZWv0jMdHjYY+LVW7bZ34HjkOFYZU2cexThWRGGqlsP7ZOph7X9gtQ51VpoeYIq8UdE7it
	iOzteVo8f7lgD3CvLUyDUMcegkTfAgM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uUTNbuu97K8eZK4ytwE6k6w7euavFhJ9/KPf1WBW8ww=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789980336; v=1; x=1790585136;
 b=cAR916Ed8FlsGOhIBcKW0lTL4428nNIL8hKWZUD9rY6qBFLrQTSVxKdfAm5iX/lJcsgRhZHl
 eLOCgyMc8M6Hl1hQ0aVqJTPjwrhrsB4Vv5Vy08vGzZLYuersNpJWjMnKb8mAABSVJ/2DQaRXJRH
 v9LJ9934p3Y2KydUxeAr+ZOc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6597ae8b033e4958;
	Mon, 21 Sep 2026 08:45:22 +0000
X-Mizu-Trace-ID: 6597ae8b033e4958
X-Migadu-Flow: FLOW_OUT
Message-ID: <37d369cc-dac6-43e7-83a8-a5ecdab0d1f3@linux.dev>
Date: Mon, 21 Sep 2026 16:45:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/17] erofs: use folio_attach/detach_private() instead
 of direct assignment
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Dev Jain
 <dev.jain@arm.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Barry Song <baohua@kernel.org>,
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sandeep Dhavale <dhavale@google.com>,
 Michal Hocko <mhocko@suse.com>, Gregory Price <gourry@gourry.net>,
 Hongbo Li <hongbohbli@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Kairui Song <kasong@tencent.com>, Chunhai Guo <guochunhai@vivo.com>,
 linux-erofs@lists.ozlabs.org, Qi Zheng <qi.zheng@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Muchun Song <muchun.song@linux.dev>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-9-bb68b6a21869@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260920-remove-pg_private-v5-9-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8789A1C0002
X-Stat-Signature: 37gya1g9ejgxpk8u733tzikos8bw7i4c
X-Rspam-User: 
X-HE-Tag: 1789980337-746225
X-HE-Meta: U2FsdGVkX19nrdJcZKbbDGMK4bjctUistoY4vNK3JBw8KGZJGhuFtPLKOeYqxurX4ljlZiNmImsO9yXJWFwuLWn80UxeGuQZRpGgFX3rVUnsnjoI+8ckOy8smWS+XpTsLWhet+W8sYLIE17Cj/f1lzBitblHHNGtiaAZXoW11+wkCMJcOqdY4bmFLmsOGjuF+ZgIuuI5LKDXXMwY2t8PRwZx7fmi+k0HHKI87pWYgQhA/WsiWv3zMwgCom0+0E+pI6w6a7gV67uftX/+c9380d39FyQaDoLEO+1FLEz+AbX+7I34bG66+jwGQ+dqr2wB73hDazJiGzj33dL1QhXU5GD9w3GncO8bUFYU3TMwv7folbQL66cGZ1oYpPFre2B6nYHFcEM9yhgJqm0uG0uFb5mRjdqOGyKui9eZC8RWzLWOsHsTGcWAsLt+yQhq4jbAEwVyvJp+VPt+nn+f7oive3Z1b0uNMj7ZvdGblartFNZdLMPGoK8UjicyYMbilZwdrN5OT1ASwIyuAwCrbsSI7rMR2KFyiYRZX6DpmUATDrTRjHslF3XmD3pMRxcLv1mQVpOQ9oHVqS+fbRVD57tYsRqEOWID8XlAajLklX0ofIVtkCgRewxm7oszoepDNK8qwTn9kntI8vc6+OXJDcVAcxPncGfAFrz1hrCTNvpVZ0hPULlSjH5MXCTte+BiWHStQ29xCgIahzoGNZ8t2wSWMiw6oE3XL7VgVLRsOgySQ/nGd3KSaLuVvGYBpaa80aUrSYwBgIaEdXXBOgGs7B22dwn4Cb2HNg0GQgjC6Q4KG7T3aGIRhs3hMUQYGGzK5yFipJlkhZt0qTvX46P8rWbh12ov5cEHsJgrwVE+rXHpZU0hmv3Z9iMAyg1Yhw8UfRTKHEr8156TloLLilfV5ZBt9KFUHD1e2/atWrl+Zk96la+YXH5aojC244a22GNvNHa7BqtYfHI1jwVIEWqDLGs
 FNog/pEE
 G9e+R+jclBpTvTAPT1mQajflEu2hff32zmNeA/pM8e3oDXD05nfMz30ckbVEfQe0uYBkR7Y85BvJgEdmij8XrAYRdH5PWanAAtMyqn7Oit1NSjHq/ku4+O9zQX6WtSwQpx6WDm6LT5IhHgE55LywBHiCxM3q3lebhPqgTnkhmNvMJ1WEaoJff+QtKHwHN6uv23b2G1UB13WuJNuxz9fZma8XAiF2h9xM002Jv5riasvwoN8p+XuVZ1qxKwdZC2D4jkYKkGfRtLVVexIYZAOAw+VNQO2ozvvTYuXrnAu9ngOhC7GRmi9J+Rk3tqRCAkKMaqmp84StrY4XRNyWmvx4WeTpNyiUGr8eWFtgS2VBLIfiiD4PsKqHI8snhenRZIMjY3wum7WZw8D2dwpNN68+CKvpDvDQO1/434rPGvBW6ozDJ8QKTRPfwwzRHTq9fwy151raqju5AD7YRda+9HZrY727OoVN1f3XZt5o259urJ687+BosipC7gOPV51pr9ynp7NQTXENG0GCqbhkA4ARVTh5V/ieeXSpAbHmx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/21 10:28, Zi Yan wrote:
> erofs_onlinefolio_init/split/end() use folio->private without setting
> PG_private or increasing folio refcount and it works. But after PG_private
> is replaced by checking folio->private in a future commit, it can break
> folio_expected_ref_count(), since the folio has private data without
> elevated refcount. Change them to use folio_attach/detach_private().
> Folios during this process are locked as they are in the process of
> readahead, so no parallel migration/folio split can happen.
> 
> Furthermore, because folio->private is used to store in-flight I/O counter
> and the counter reaches 0 when all I/O completes successfully without error
> or being dirty, ->private=0 causes folio_detach_private() to not drop the
> elevated folio refcount. Solve this issue by using bias=1 for the counter,
> so that ->private stays non NULL throughout every attach-to-detach process.
> Add a macro EROFS_ONLINEFOLIO_BIAS=1. While at it, fix the comment about
> ->private bit layout and add EROFS_ONLINEFOLIO_COUNT_MASK.
> 
> It prepares for a future commit that removes PG_private.
> 
> Assisted-by: LLM
> To: Gao Xiang <xiang@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: Yue Hu <zbestahu@gmail.com>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: Sandeep Dhavale <dhavale@google.com>
> Cc: Hongbo Li <hongbohbli@tencent.com>
> Cc: Chunhai Guo <guochunhai@vivo.com>
> Cc: linux-erofs@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Gao Xiang <xiang@kernel.org>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

