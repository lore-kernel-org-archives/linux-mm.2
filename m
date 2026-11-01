Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D0B1606A333
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 07:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QlYZS2a7
Received: by kanga.kvack.org (Postfix)
	id 371096B00EF; Sun,  1 Nov 2026 02:18:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321376B05B1; Sun,  1 Nov 2026 02:18:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260146B05B6; Sun,  1 Nov 2026 02:18:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF8C76B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:18:40 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 746231609F4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:18:40 +0000 (UTC)
X-FDA: 85385697600.19.F8EDE96
Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6E97A120006
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:18:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QlYZS2a7;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.115 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793517518;
	b=LzdPRrj8jJDIzQuQbE5joAO14Y2prOXBn5vkRqHTNyT6BoX3Ee7ETcTZLCUw2yN63M8zn/
	k4rXCzSeNVPT86KgcZrQA83DzDHEDzhWotgQcok4K/mkxh9/seUp0MGtZkg83yjgWyBx7B
	0s3Hb4nVGJ9TMKbAHAUd4lAg7bPvpdA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QlYZS2a7;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.115 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793517518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgSF75huK5lq6JDQkVCdSAQMAD+xLgu3G0GXHmKK5Dk=;
	b=zVuAgJiNvsdlCoVl78BxtxwogJJF9zt+LyQKv9/n0hUtMThWICffNcBs6U3mYpSyh/43Mc
	iJqUhVQdk55TwfwZNl0Ar4T62A0Y9LMyD+hYKWyy6ZzDzVfCvX4Ix3ahp9zHOIsQ+DmWdg
	5jWeTjWio5+XSpIPxbhPpl0Fcgza+no=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BBXd3+OxUyf5WsG1NDuZHkvK3T+6qnkUwUPM6ID5tqk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793517517; v=1; x=1794122317;
 b=QlYZS2a7eKbaORr55Lgn68numsDnacZy4+GYQzykFJS/zWy01sg4BSsXEc+qekgmmkBYChRJ
 xidkXBA2vQE8HWIPsDb2l0cGBG+vA+mM7823UtcLSR43maLttvLN2309nUFUO0tszKQIWgCp5Gm
 Ji4B04y+DyJi0OrNd3FZr1MI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d3aa89a8db00bc1d;
	Sun, 01 Nov 2026 07:18:36 +0000
X-Mizu-Trace-ID: d3aa89a8db00bc1d
X-Migadu-Flow: FLOW_OUT
Message-ID: <ec140fbd-da68-43e2-b7c9-893e494f5925@linux.dev>
Date: Sun, 1 Nov 2026 15:18:28 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/12] mm: hugetlb_vmemmap: make vmemmap PTE conversion
 folio-oriented
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, James Houghton
 <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <20261020115824.823278-11-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020115824.823278-11-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E97A120006
X-Stat-Signature: 519cw8x3mmf46p7eduw4ktfeeq6xdwit
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793517518-192722
X-HE-Meta: U2FsdGVkX1/9IEsafU5mdYK8NErATC2sLah+oj7AeLRaXoIJCJzmjPlpEObTp7zB7TVEdczxiAE/+rgtb3J4QjzJwMPTaLxqFfriTnYIMWrPfWIYoRwBhtttoxzv1EA/zPRjAtwsC5w/ApwNMAvH4wZ5LBf5RKUhrqFbdxSRR4rwwm2TqbwY8i/H59t81oy31hf3gRl63RutNyj0DozpW/JT98S3DS9yT+D1Kvh1sSVuBZzjUJS2GCVjfsLHTfAFg/sdwocvkgXvp77gsz5SsMeezYVIrJrLcgk3zdXuO6WBrC7oYx4Gx/1qstBK8jG8LddWGbEtSQljDnA5K1oN5WtYSCnRyjg2MrlLJ81IK6YPtgw9jPP0X81B2wDQnViXg01l3++4A75Y762noCy8FdcB7glumFzVyXqGAayi2kPJ94XpLBNEOTBJy+Hj51ZtHBBajuZdMBgAE0KU4psDZBwGq8KttFqOxxz7fIvFAjOaBbPERnEbvSaNBl4DU9vve1ox7cvAp9RNf8WWrLTbA9BFR8w1D7hAxVyFXCy4lsjUv4yXQFT7sRLY5B6Xexa7kKkwLpKKUd7ThQ5zinNnwnf1skK/J7qKGk2vOg8PLBVzWRYdUnK4h9R4+hVdT4IJ32gzgzgd9MLzExouCDWglXAhdXVE4lF0N5lC5q2OfSXJ1OpUdxeBlD+AQ2flwW1vifgHZlBi0jRk23UxPhXU6ACKqJW7chHGsM+0ZQlbkzus0HA28ay+ws2LPO26kJZpPgN2la6h+Nq+mvpQMx//+asdJa8o+wJcEHsdH5+lYDr856zbk5HiVRJsAYsXNV0xrK1czGuu4CuFJ4ifuaEPK1N0+ZOlle9blybSWBnKK3YT2P+VMf9AxdD9WkNthN041HCtj4/Mnod8upAkyFIZgbeGyvaGSDsdKCEb70+Ls7f7JXk84TQflTMUpybwM/SugX8FKd5xjqqneCTcbWy
 OEhjM3a2
 T5Gv5/AoscP4Akxp/Zp3rBIUxBFZT9GMVNXrfsbXM8U+qBMNm9/f0R5CXPMJxOkaW2UAjoYL/bkA3c+VYrcIOkleJImavL2kDObW+LsQbsmAfFMXlEKj8AEm9GclR9cjGNDFzNbcHBWaQLroKSqYIhgOvZQBAUougmEYYviPKXjN5QHUcpDEga24Bk3PJCO0ttnUqbZr4Gt4VMeBBKM0dqrYY+MzOXnEux93XRCkAHO2OUV1IGUiAMBQETmbgl9v5MipHcXdY3Y/ai+6IebAnii0QHVzcxg+jdogCtLuYkyMolKndGvVMel4pRxmo3emBqd1j7OgpjROmOfP6nDb+ZF/fhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:58 PM, Muchun Song wrote:
> Converting a folio's vmemmap mappings from PMDs to PTEs is a per-folio
> operation, but the current interface exposes a raw address range and
> hardcodes deferred TLB flushing.  This splits the common mechanism
> across layers and couples it to the HugeTLB batching policy.
> 
> Make the folio the unit of PTE conversion and let callers select the TLB
> flush policy through the folio-oriented interface.  This keeps
> HugeTLB-specific eligibility and batching outside the common operation.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/hugetlb_vmemmap.c | 40 +++++++++++++++++++---------------------
>   1 file changed, 19 insertions(+), 21 deletions(-)
> 

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


