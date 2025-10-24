Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 695CDCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 00:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5B448E0020; Thu, 23 Oct 2025 20:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0BA88E0002; Thu, 23 Oct 2025 20:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9212C8E0020; Thu, 23 Oct 2025 20:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9778E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:47:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF4305CA86
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:47:07 +0000 (UTC)
X-FDA: 84031168494.19.4A27D61
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7CD6C0006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:47:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DfLaWJ72;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761266826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qJamjzk22RA6jKfjKnU6G0J/c4HWnTcWAnWK01wqPs=;
	b=42jkf7bzuqsBVClSt7SHWKdnL3nqKN7XMiWio3/ThTPk86BSKyF2PdV89/AZkV0LMhM1ZC
	XoaAv5Hl/pDhI6E7lPbz1I4AToihuVHm0kSx/eiEaAIwyG0kBZ1VYS+9AoiGNdbQOJreEn
	p7lCOO4rCpiAgjTHoM/QHbisN5NsE94=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761266826; a=rsa-sha256;
	cv=none;
	b=qtrTOWW5G6ZZDj19UgMXgPIVQiSGPKvItVkqjY0nOZwFLlvlvg7QTTal5NihDBYz5Ti6i8
	5TfAXCMnYgG/2kCKhvO5H27LsLdHoX9tUJYbUkLOBT30o2Vj7zPJqwR/Pn9noSqe1E90Ly
	vXdndqlLGLuY81mq6jACBFy6C7QV9Ck=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DfLaWJ72;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761266821; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9qJamjzk22RA6jKfjKnU6G0J/c4HWnTcWAnWK01wqPs=;
	b=DfLaWJ72PrWDIU+dYST8GwvCzvGtTVIwnn3CVHRWNp8lSdNS+CLFXD6enIQKJe86YkHdBCRUiZ2Xk/UY0SS9+h+rg30JlwZ55ulnZZePpSzcWn/UPWkjMEaZaMAmZpDL927Cdm/Ne6X4+UOn+TSHX376Aj1QOs0KHThwe02XSw8=
Received: from 30.74.144.122(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqsGyEe_1761266819 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Oct 2025 08:46:59 +0800
Message-ID: <6a0cd943-a3cf-41fe-b666-47d250413a77@linux.alibaba.com>
Date: Fri, 24 Oct 2025 08:46:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/shmem: fix THP allocation and fallback loop
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins
 <hughd@google.com>, Dev Jain <dev.jain@arm.com>,
 David Hildenbrand <david@redhat.com>, Barry Song <baohua@kernel.org>,
 Liam Howlett <liam.howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Mariano Pache <npache@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 stable@vger.kernel.org
References: <20251023065913.36925-1-ryncsn@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251023065913.36925-1-ryncsn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: fo44iysg8juhqxj9skqww71u95aqx4ne
X-Rspam-User: 
X-Rspamd-Queue-Id: C7CD6C0006
X-HE-Tag: 1761266824-835760
X-HE-Meta: U2FsdGVkX19y8dG3DYZngO933wC2t4xcGQYoRzG+e2Bc2LOZpmkUdAax/6xj8gcVfbCikbEuEnI6nUwhANtB7eRjKNVwGpHCXQq5CnX2OWr+z4EDU7u6TEHBAv64t7KrrrbyoFZAqZI0qybtQo+gly3629pWaG+XG0s07GUsy0NEQsHbShHJlEY9hOIn0KZHwjJQeJ7+4z3NbuUiFlshkvz3QDVLYmW0WtYLvM8fbAmNvOiN6QJOx0PF1QQrjgFb0l6vZKBLtmgSVAO7psCgkFT+nMeCtGX+1yVtBxlBwQGzWBj5wkKlxvSVHVYpy/2gSjKazgwFIcZ2NMEF7ScaPX4iFu2qpiZMgeNgURuKgGQY9XVlMY1Vm0aZxfE/0WRHBOxxDYwPD7HuhCOKUjgqJvxX9MXFPbcsSnhzNB5UJS+c6sA1qPtjFrQ5zO4U/sXmkywK6ZNy9cIk8UMXJE6com/Tugd5NTGxDvtYjSvrbdZfUYThGgUUPBCR5ypxZFuI7FXFLlPIa7FECLxouhzDRvd/lDP+rrrBFeRVegkUo82tA3kK9WFZL9sGoFbHokrQgikBzEqrXx5Ioq2oat7RZbJO3BagP9pdiQGu9Oxf3YlaS46XjuRKF4RLYz2PX3eAzPQfFPucxYN6Ls6j/IFbu73UoCExYQW29dLsrzvPJAb2ut9oSXX6zwacVZAIWD+nUBmUp+tPmrW8E4qb2CrdiaLQeT7lENhgF4ygWq58s481yJhiM2LVHNCnjSfeZVCfL95TnTTNF2Vj/jXZ806R6MPRyct0vxqEMhs2BvtcZ2121nYwV03Y05kTRAXpvtrXzY4ZTbgL8yZPtiJlqsdUmsWwOO8/H3RzYDf4fR8OVlyoKOypjd75x78Tf8RPIUOXOUe7YYgThkjJw2iFLLlzDonkz7JYOai6Ue6ByCwVeNVBCGyZolyCRwZ6LilhO02eSSEOveJZXnI61t8RJHZ
 HImveYVr
 pJAFX0CFCcA0PLt4mR2I+ACg5R8iBP9PScm/0we5uN4LOIZoRGuYglNfyG5ga+ZohsGOqTbgNp/b1qfjmpMZlXflJwYDTg76j5XN/Etznkjsf6oVFLzHng+q1y8ibarF3bGD1j3y160sxKzhqAlGdwFsLZe//F9pqEnKuVx+HEXKqwWyOkHzW4Koh+OABJGBc62v24wsGWkbFD/TAcT3vbETI5brb7+N23PoEwnNQ5GyABw8T9kfoOeBNp/B+8+cpOa0fvIdVF7P6OtpkcmFPgaUIyNppE+Q1EprLx6SBLcyQDbh6paSiNdFwuNYL0Z4+/zLnY1TIF9KpVhmZc8VkRwBmjFI4vXVGKscU1+c12PnEAkoTUbpaeHV4TA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/23 14:59, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The order check and fallback loop is updating the index value on every
> loop, this will cause the index to be wrongly aligned by a larger value
> while the loop shrinks the order.
> 
> This may result in inserting and returning a folio of the wrong index
> and cause data corruption with some userspace workloads [1].
> 
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
> Fixes: e7a2ab7b3bb5d ("mm: shmem: add mTHP support for anonymous shmem")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> 
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

