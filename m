Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27032FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 06:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8048F6B0088; Sun, 26 Apr 2026 02:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4506B008A; Sun, 26 Apr 2026 02:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CB2B6B008C; Sun, 26 Apr 2026 02:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6CE6B0088
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:01:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3E00A0442
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:01:40 +0000 (UTC)
X-FDA: 84699660360.07.37FC9B3
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4ACAF80003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:01:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="mD/H9xBA";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777183299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+wabLzY7PQDl0SUnNEn2ncKgvz1hAOANX6yNTSodsQ=;
	b=22rcTd5Y9GTLrqHbgur9dc29Ew47Ne+7AsA9Z4LtLG1WJXohrI+xvJvfTMfzgVYgNW8ZqM
	Nfa/iEvwQa4DExaVigZA40Lroyt9j3x7Vk0waKtFj5K6DZqcBl8U263ssl2hFxU6ZMfDbe
	Df1WcpTVxHQMJJevSgVLJVGTIGzd8wQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777183299; a=rsa-sha256;
	cv=none;
	b=V4wKC0OTzvHTx0V9sgC/lR1lGBHJKTClv4a2NTxh0KZU81Bf/GAf2zmlpSamfy+804Whuy
	WdtLBrRBEKSYexY+az8vZHW1A2RJjmeBjpyqgHC5W8Wg6rrbZMTOMCSYxJBO00SNa6ZvC6
	GcYExH0voG23qBmdRmp0ws3lOaCsgqQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="mD/H9xBA";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777183295; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=b+wabLzY7PQDl0SUnNEn2ncKgvz1hAOANX6yNTSodsQ=;
	b=mD/H9xBAz6Jq09uKI5Ckro26gwVve6ObUrB2+4bVUWfIKZj8AHXTiVjj/ZtstBOzOtzjssmV69JMDZONJiejMv4v+NA9gGsWGxgWxZgjQdTt4A55TLfOzOT/cH2XLbsiDLHmFOTj+aMo0JU5gyCXzKqVeD1RuX6C8ikv0JPV7TI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1gM9NY_1777183293;
Received: from 192.168.0.100(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1gM9NY_1777183293 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 26 Apr 2026 14:01:34 +0800
Message-ID: <6a6f15ff-233a-4912-8be4-b2a43d442692@linux.alibaba.com>
Date: Sun, 26 Apr 2026 14:01:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v4 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-3-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260424024915.28758-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4ACAF80003
X-Rspamd-Server: rspam04
X-Stat-Signature: r5ftoqu9bnz4e1p8k8kq9g5entrzyseq
X-HE-Tag: 1777183297-473315
X-HE-Meta: U2FsdGVkX1/5aWneGOInp6NtKxv0+GhNUClxb8rw1Ap5vcTihAwI42553h0GJBOfhFayqUv3r5oKHnKM5AjNyUcuGkBsN19vDHzmySY8sWmCAVpcudAiKSkP7Xg45aQh/xLs10NC7eZtURSg7lpIzgb4SlnNEguMFxaltHfF35EBeLfrhYdXhyXghxiH3mo3ngJQJP6Mvl0sFRpwF399K12qkargRw0T0Xi/eeP0sp4PjwlQdNfdDvF7Lpksv/ppWXBRMCvDwzh0A8BMFgvXq3QafESj0SVXuqyQsHvvG8ort0D18E13PX9gAbLmnO9sOZ3lCuPqaK+/cJOQdJKAwT8/qb246FsktfcEop0ySz8SLxxwC0fxEIe/3G9xpHVJVtZK9l2S/TtJkOGk0gfWPSqna0PPKGaUD9BbC/fNGk9NyvcEvSRjiaJUQ3tLVCB9MVgFQuBhP/wxoBCS694Cwid30ZRYEDKcwLTsErPlYVm8YXN2ow43Wq4PFrqpG6L1VmQ/2nynuKq3ysxRrumqLzkMWkdtFGui/fWQUWEf1DJ6U3ChfaHmWlVjTAkNzduvfEofwgn9njQfmqOwEE2MJ2ejt/hqDHNJ8W3DwQUsroNALnPFnJW9r2M4JCeHgFTt6rVg9iTogzPdgqL6t3fezQeI+DeNQJUl44ouu3NQKxIbG9DuK4Lpk5FLCTIDbOhDkJyYDYIrE2FydCdVz+0Ihi42ZX3Z5Qg3Saw8p15gahWIpUdPXyNJ9Kzz+P8FVsp9M/4dc3sHiWoy4lAZR82JeM6TLa3ChqmLLWHj/37mgLOmQKegytoK5dzETOk20oN0VTxJk3j8aC6GuM1ftStVAhg47e+xyHwH8pmpPVRxsjiX5jiYzd1XYFK6Nt6McyHYO2ZeYVzRBh0rBPtI6SvbfqjyeYtPe3bBbp6grgGzCv1A/SNM/bcERJ6saUjl483A+DvxH1m2N8IefVUmZUZ
 yAG31o45
 fFrW4FoWkE77cOWrFILUbgQvRar3Lt/TBxIMyNBL3bKDKy1kyUXaOhL8WT50JiKrFM7iGm8VUHmdI/FLhkMmBJPz10cRNcs6UeHS4nTRGPGoPxrNCXOyg0lbHTdVAccTefhDNTh0iZWCbHT/pDEVoTeldTQFvtUI0BR0vIaTU2knKTVziN9NJkvuDco3PvqWqM0YVPkOJXHYfLwSuTUADxt9iImHDRSKZy3Ec2fnYnKGktXZTbdleqrlPzUBBX7ckO2WwFwtwOn3hcyjs2hTUlKc279usfcNnVLceJ5IQkrZzobzq3HbPGzz2IqJUiJG6MTNo+HAN4ON4pcamCAdHb+nWGKTBRlbp8+WAqmbHohnz3UBLkzjsJYYL2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/24/26 10:49 AM, Zi Yan wrote:
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

LGTM (Thanks to Lance for pointing out the xas lock issue in the 
previous version). Feel free to add:

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

