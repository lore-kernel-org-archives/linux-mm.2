Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFC3CF36C26
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 06:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92356B00FC; Mon, 20 Apr 2026 02:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A006B00FE; Mon, 20 Apr 2026 02:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6C76B0100; Mon, 20 Apr 2026 02:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDE0B6B00FC
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:28:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4005F1604A7
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:28:53 +0000 (UTC)
X-FDA: 84677956146.27.C0D8E03
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf23.hostedemail.com (Postfix) with ESMTP id 01FA9140012
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:28:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jMU5JZpW;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776666531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnJNP5Zf8rEkIUqerK5GYr5N8IvbRMuI+6hpj6QnM5w=;
	b=XTSSP2Zibl+qpMPJ85qD1p8CKXmI/TkUmLU1+CTLryjwMyWrPIo5Gu3whoWHfhB6tFyImz
	ynBvuYB+zt3eEK/pBEfYFuzLX8Vs39aGdv0hHzfSJ766wEJ0Tu2KgZrgxUDttWxi2U914E
	a1YRUOyjP1k21+ESKfouyVHuKUdwbh4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jMU5JZpW;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776666531; a=rsa-sha256;
	cv=none;
	b=30VymsWfYJa1SeinXqk+PACTTTun5bg2hZVQSPw9uO4cuFaeQ9E1hUyLXJVCC9OBfLv00W
	fws/78mwy5B9Pmg1Fbi8TQMUPICIO0Z0sHv2CU85P5CkODIO5OzzlHT0fDB82cQKY5gD29
	mUO+sjzR8AcJ0MrZ3O8qXGsmFcldZdM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776666527; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TnJNP5Zf8rEkIUqerK5GYr5N8IvbRMuI+6hpj6QnM5w=;
	b=jMU5JZpW3KLg1XBncvIP2FslPASH2eE7GhRKKTUMFOL023jjgzslNBhPAGmxLynheCO6sJoRtnZ3FQa01vQUg0HG8MAHlUrch3lJ8ITTJOlJUU+ASnMtjlDsYbVGLKiFOD4ZBb5juU6TuJYHphuQYm5MD0Omqu2hGVjdguJl/qU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1I6o8n_1776666524;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1I6o8n_1776666524 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 14:28:46 +0800
Message-ID: <78a05609-05f3-4b2f-861c-30dab49083c1@linux.alibaba.com>
Date: Mon, 20 Apr 2026 14:28:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v3 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260418024429.4055056-1-ziy@nvidia.com>
 <20260418024429.4055056-3-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260418024429.4055056-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 01FA9140012
X-Stat-Signature: bb5qpjd3mbsup7q5ix6jy51giyoi8wyi
X-Rspam-User: 
X-HE-Tag: 1776666529-228036
X-HE-Meta: U2FsdGVkX18oz5ePg/r87NyNhrBi0KGcG+gsvUhCm3Dn2k2aSehFGXEgXfzLu4WB4VRPdOw/f3uUyn3hO+zsL+P4KD1Cf4WtV6Nl1Zdv9gLfH+oNTceeTIXgkJTRjagGWKHZErXbG/PXcz8KNcDqybmVOSNORtOv8b9jiaF3E6BBmIDE9Hyne+oU5EWCeDDMYTKnfMFN1fJh3jNVCA4UtZG535buwoJYd2p+oyH6z7TAfbwmNDmC5+ZLr7YgyXEfjklOjJ2MNftj/R7/8nXihaR8lMrkRb40/KW8IsU0BJemeLvfUHtcIH+jEAN/Vflc6s/heLSvvilGVV/zlo8aFMJHitjKxEnmjqrVw3tmp9mLyIw7A5G+QHxPEBMyO84L+Ak83PxCvSl68rWoFEeXsSwvd3UsdjR/JC7NmAGbstuNhXJekdGoITAcddFN2bVMB93NviqIdbe1n+cKzqQz56wvtAtiABjMKcvNmZH+CiwoMddqts32ZlH99DkPSsAoIpMGPHT1anfv2yH2TkqCiLLbAG3S6NthH2MrnuntkbAEPC53s4qgIuC2Nxg+zhtU9Xtw32bR274eIpYxC0Wpnx6+kjhuc3F4v8m6VTeAgA3hTBOGE6h/gmZxQOWB4awGI9pK9JZU62aAF70DJLiGOV7pizihW0TuOD9BQzcD4n0KZXG8DNM+FYwGH4dqj62IFHxZCZ7sCgMBc2ZEGwmWDItGCRm44vxJt9MeXEQbwgmVCsd0yg/EJx7yfrWuEzvtNHs3Q5DRBiTuj5JemV1OEi1nQ2wr/xgj8HmscUpaZJJC7KWQ0Y5/ja9uNBs4PN1HzvUgRt7Dka0ntWfNVgmfhMAZpYA4kFJzMLsbbxl3k8mYNuXffoQkQikWkh9lWxq7vNg8bWBdIvxDFaaCPr29MeJcoYmhfCFkUTwEX6VCCV6inGtJAeIvA3kZKjAM1izeULMUcHmZ/v8AljZsQwt
 rhSz5xYW
 zVGhLGuznmUatJIjfnDJQzbJ1ogNH6xVAgAdAIzZtrINXLlShjUdzyogRGQfV9fTSMX2KfTD9LlSUznbEUJmiPA2hH4dNs/yROJ9xsBQdHkVQm8PgMByiAuUZTBdgALNP5x4xU0K4TZ5Rz+hxABHn4R9n79Dhfa5trGylhlkENXNwURpoWl9k/OpuUYZJAHTUAgLc1MzVxlwIlckM/SBScavMssCKbN771fwE8ORPQkH0R2y1RNMLUZXDH2XmP4j0Tf4+bD+N5xtylTbtYFnqeImE8Gq29Fux9FSPszv3fNka/as9dVdXJAcHb+bGwaN8oZ9B+bbSUSB+VtksOejVFkJUg73ls7VFNNtW9CruexhGk3v/2rlzxoixbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/18/26 10:44 AM, Zi Yan wrote:
> This check ensures the correctness of collapse read-only THPs for FSes
> after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporting
> PMD THP pagecache.
> 
> READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
> and inode->i_writecount to prevent any write to read-only to-be-collapsed
> folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
> aforementioned mechanism will go away too. To ensure khugepaged functions
> as expected after the changes, skip if any folio is dirty after
> try_to_unmap(), since a dirty folio means this read-only folio
> got some writes via mmap can happen between try_to_unmap() and
> try_to_unmap_flush() via cached TLB entries and khugepaged does not support
> writable pagecache folio collapse yet.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

