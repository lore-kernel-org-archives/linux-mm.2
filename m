Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801FA606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 06:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fdMM5zPn
Received: by kanga.kvack.org (Postfix)
	id 8EAFD6B05B3; Tue, 10 Nov 2026 01:38:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B8E6B05B4; Tue, 10 Nov 2026 01:38:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1BF6B05B5; Tue, 10 Nov 2026 01:38:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5741B6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:38:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5C1CC079B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:38:08 +0000 (UTC)
X-FDA: 85418254656.16.004E9CE
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2A31C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:38:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fdMM5zPn;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794292687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=788eD6EYFiPFkFjsWwu7gXMD/5pQr2HRYw9Oa5iyE+c=;
	b=4e0wX4YstbmsLBipxq+3Vp09ZhB6tEntnhBStLe7iP+5Hzz2kekPkWU5WtVUBt8ca7wgaX
	aMcOpV+W8G97Ft66GwuXoLZBnY6t9i+WQRuWawZcjzozNpQAjzC0rdFrLwcAKgZXV+T8VC
	wBRDB63QRJJiTKakbMqbR8sT/ZFu740=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794292687;
	b=Vdch81CCIVtkY0E/LYunNBd4Gq4F3ejUXztLWaoarexr3HmsfABl+UdRTgPeJcsmYaGAOF
	2iCjU5eMSd3TEPCaU5dgyAwRfCCc4tgaMVMlNzhtfZ/o4rN0ZYxdBQE/QZxq+t4ZXlwog/
	436YfFqblcvPx9FPspimmR6wXLxXLXM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fdMM5zPn;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794292681; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=788eD6EYFiPFkFjsWwu7gXMD/5pQr2HRYw9Oa5iyE+c=;
	b=fdMM5zPnLkC66yxP9Oz6oBKyzALrZKMlKpF10HZlg6pyVrVAiRf5jEx25KkQVvEQTPYi6k0/b+9bBG6G13BO/plE/f5dlQ6ZCDx7fT9woTVfEZdKSCIrAsI4R5Z4PJC1NKUzjOoQySScn7nKhiXzkq0dEIZbvtRo1lFqgX6sjuc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XEUOs81_1794292679;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEUOs81_1794292679 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 14:38:00 +0800
Message-ID: <f0ff3284-53a6-4555-9e8b-fc6198be84eb@linux.alibaba.com>
Date: Tue, 10 Nov 2026 14:37:58 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: free unused page table allocated by
 do_set_pmd()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261106-khugepaged_set_pmd-v2-0-d2457b5e377a@kernel.org>
 <20261106-khugepaged_set_pmd-v2-1-d2457b5e377a@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261106-khugepaged_set_pmd-v2-1-d2457b5e377a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sfqd1ackwk7ik797an9bf4e9x3ej11ct
X-Rspamd-Queue-Id: E2A31C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794292684-314751
X-HE-Meta: U2FsdGVkX19S1gmsr1/FXdqFOeSLtJrrD2GMrUnY011IylJpMrHAT7lH88xPkALuH6Z6bWij8KAvZslgEH8OkgnSWTCCI+8o5ajp+wiXWPVjC4k86qgn5iRteX00ZjpVyTwwzWsZEUu6fLcmsGVtGz8iqwOUmV4iF1HNaW8OcVKpv2ZgnatK3SHoXT9OrQhHLFAVlXt+bh1+QmIlL7ZtUnyUzGInO3x07CSdtCv/XmLLGNfGcUT5WjI0FYiujFye4GVt9rNF8pa2Zi8Px3h4aCATQXfRfrejIfxSORA7RnJV684FKbvWNPUf28MTdlVBiQb/yj9PAkA3aeJyLveeKgG+Stj5v/KZT9JQM9ZZHQVjn0MTtmJeoR488+GkfPJumnzUi7LCXJC1M4lBOe+4FwoxMtIC9WKral4SgxggLX7KBjRPo4hkN9GgpraJQ11+uRL+7M9F7r4ZnFunW1vA2mTQMKouErz/uTr02w9SrXKmpEbrFS8awebi/SpMD4NfntqEdw0CA5OyySHlmsGkGKOrLPVgmmvL+a9tzQUPlAKybm5ADN9Tp028yr69QhKuMt5ID87yCK1jj53cDPM/d2zsckI+YDQvx4xDpPHzdNkPNIHPpcTwlVCwMA7IjntlOYSMGJslqEH/AJ51QVC8XJUS2ePdIx0kwW/C1AQHTeVF+hqEC/ySw61j7VDKmauTrIG/11WBd65yaqA7jjxh2WFS4PTQGZyWHRI3IJughfLdyYjg7Vsd0CD85AZs7aLlDqi9L6kgJW2IbQ8h74WZee00p90IWtVFD8SqohLtLcD7ZQsHQARZpUSQkNl73+blwMwQ8KOsPN82JnXv9RWTcJg1Our7WsszDf34XNE/dZ4MDjQ+ZiYEvK9f+n/sdgzQfCDqITvXvPNVHHD7t96e2ehgFWh1Buf2I7ETwl+zs8xKomPtGxBGXcpXjgaQk34m890T+dFD/5QLMMdeRdU
 BDuysFcM
 HaJ004VsDY0FUArxaYQFvQzr9Ljhv6C5zenGXoMOWWu+mvAVpnJrGxw9vfhN86cxFmXVkmEaVKq4/TVSLveQfSQYoG0LYIZRiAmy9Ue4A8Lv4lETnyLSIELUBiLaJYti5enDPd2I/glb3PwHSgp1DfOKZA8iYwj2ZBLfd+HKQxg7Y+LCYMZsockawQGxi7fhz8w1MonwzKAPxuwe5kbYkNod8ufMxsjgSU4B72X4wC97Dc6+DKzpgOO8YjCASrxKvPKfstB0IgHGCkZZuliVkCpUnnmd0+7799Ah2xK6wN22B8dNLGuAiibK6VXlxekdK6t/B9x6x6oNW+5le+sYr5UyOZN6Mys9/cMSDKtECPDNA15D/lnhHfdd2iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 8:36 PM, David Hildenbrand (Arm) wrote:
> do_set_pmd() can allocate vmf->prealloc_pte on architectures that need a
> deposited page table, such as PowerPC with the hash MMU. If the PMD is
> no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
> without consuming that table.
> 
> Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
> userfaultfd operation can install a PTE table before taking the folio
> lock. If that races with set_huge_pmd(), the unused preallocated table
> is lost when its local vm_fault goes out of scope.
> 
> Track whether do_set_pmd() allocated the table and free it after dropping
> the PMD lock if it was not consumed. Preserve any preallocated table
> supplied by the caller for PTE fallback. Successful PMD installation
> consumes the table and clears the pointer.
> 
> Returning without a preallocated table matches the existing behavior on
> architectures that do not need a deposited table. All callers
> already handle that case.
> 
> Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
> Cc: stable@vger.kernel.org
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

