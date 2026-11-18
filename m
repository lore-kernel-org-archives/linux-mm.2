Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68D9606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=njD0pyUP
Received: by kanga.kvack.org (Postfix)
	id C40666B05B0; Wed, 18 Nov 2026 12:05:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18BB6B05B2; Wed, 18 Nov 2026 12:05:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56196B05C2; Wed, 18 Nov 2026 12:05:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 884866B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:05:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0ECF680835
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:05:46 +0000 (UTC)
X-FDA: 85448866692.19.B30C5E1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 024D540017
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:05:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=njD0pyUP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQd7Q59/uJ09RDtnXaaw3syKdDGR5e1uWMGq/9Jn6+U=;
	b=TvudRvQj4dPKdgBS1NVvKVrH5JWazj1Ww/qXh1fYTPHx2e+4EJIrEaRTcswgjD54wdmzi/
	zL539dFaEvY/pile01pz5eZ4e8jhMRbZYPvjzY5zMBL/0kZ9H+ysoTZEGE2jv/LGHA4GtQ
	D/8UeqVZBhG6NVzbMgMI71SmP2tcRw4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=njD0pyUP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021544;
	b=C3T/MHVA5odUWk7dh2Yt3EbWlnMQjKKYc5CEUZNQLv2g6Mf3+A2HAXMlde3f/PquKQ55rA
	8HZ3M8mKRUjALRID9ugv96beo946Nyy/STCE0APbo4ILnsLLsLJ1+yBuUNI1EAFVrLEypB
	6L3hosE67aOI4E975EnuCT/MHZmZO7Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F6F01477;
	Wed, 18 Nov 2026 09:05:40 -0800 (PST)
Received: from [10.163.128.4] (unknown [10.163.128.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3386E3F632;
	Wed, 18 Nov 2026 09:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795021543; bh=lm8fR4VGPjinFRA2VTQV8MBU1YPZJR5e08gMeF/5ntA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=njD0pyUP0lvvOgYBBd1phTCojAQtgwJJe0bSG2aHoDsu5LGv3u9LxG2/95Se29cZ2
	 ZxB+zeWoPWlqia5030YhGIOEFbjM8ukjEvdI2mVqqP0SPIXi6mT+zZPZsvZUgBbnFn
	 SumFgAPdZeQqht5/9YBht7kT3VM+GxwiZQRpz7iQ=
Message-ID: <f3219880-c944-473e-82cc-bd6b4196badf@arm.com>
Date: Wed, 18 Nov 2026 22:35:32 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 0/5] mm: remove unused functions
To: Shivank Garg <shivankg@amd.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 024D540017
X-Stat-Signature: ww16kfm6bpyimgiaqsmnbxpcop6wjd5a
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795021543-619694
X-HE-Meta: U2FsdGVkX1+SHbDmXZa5IpMy3SSXn39hRZmVI3rCH7QNy4df3YrCd4ghXfWdlEtu+mzGdZGYYhh3Q4lsiQqRSxNtFpkAR5JIU+YdE6GDYRC6cm5iHavMgUDFrSueMaj9mcES6iHDmWxrMQ5C9tv1qu5hJkRS0kssarXRzQwOgXgNnxp176GRV+w0CfXDkUbeUm9J/Mi/QhjAo1/sQnKe6bsGzybdyyvHii+N8efqxGPug1x+NJv+FwTfK6B9Jp5SdN8tir59BWwSSDkc2s3ozBW5dst/UvS2/AELOl9n0sOeXacDzBr5pr4NXuItQi+Z71a8UbZ37z/+uoKxXmBuN4wc//c5D9EwIssIkJnSLZ8N7oMbmRTUSbR9GxouUpFTJPx3xlvzn/zamCShqF0z7q8DfGeAy39yIVYQVjn+mam1ipBnDkAraslJXL5cpTrbqzGZxPMWFaZLaIwzpC+NJP5dEsdjQ+Dw+KbltaCNfdQifo5gUBhlSiKEETWx5NYl03mIYF1yIPZOR7QxIsbaNw6bx0UV+s2YyqPVXwKO/lExjNx1sORvnxG77WqqTy2oJc/C460bfNsW1wKEUyvFi/oMKP0zSSiiqx2jX+/2/rftKAKSBwFCIEdps62y3ES/eQrug07faKCD4H3gyVvJEEVAwZOCPx6Yq4vg2K/+ErL5es1LMxdwonBB9vwLf2AojByXLQ9DdNoOLBopuRJuaNrSss2/HO5KczLZWiUNyb3ftS2QeO94kXgterOjdYg9IM+yMuIbvrF5or3RcYkdu7qaqEPHtTr0kn0X3D857HXQ6Jkj+QLp3t9JfiiZwyRlbXrz4vFrCZYd+rGDmklY8bCZxJ4FDz2mq19uOFjotWKYrXsLLR5N04qwKMtbhQSgHzUpL8ZvPsN0l/Dzqg0OZwGqIB42DVPv0QrDPcZDnVnb6PMqBXugaJ3AvHQAzKR58Uca5zbtmvUDbwFkQ3c
 MZL9xl/7
 P156ZRJdFRm3AZDN8B6yVxQyTdpVamQLgJmxH/woEOq6EGcXVSmnNrShrSZKe3c8AOUxIAj7X8lhCyoUlJ0h2XpBWQnPzu03a8B9r338qAT1j/cKXMdxAQ+bXDKliPCfyhDm3pIESql6gKQxb762cZUc14hRHwB1wVFsAsjFNhwjCkYVtjeN7NMcojtXuIXmU2IwQkPoj46H6WKU/1lQcql//mfzltD5m655dIGq27Pf8VakGLl/8k6m3S1Vwz2CsX3zAX6mEB3j/4FIuWxlZOSaAy7jaKmtNKRVHoQ3AkDL51D/ZPiV8sonOiRzerhjTPq+I/ndZgwW6+L4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 17/11/26 12:46 pm, Shivank Garg wrote:
> This series removes five functions and one variable in mm that have no
> users left anywhere in the tree. I found them with the kunused scripts
> [1], which I wrote with LLM's help. The v1 cover letter [2] has more
> details on the scripts and how LLM was used.
> 
> Changes in v2:
> - Split v1 [2] up by MM tree, as David suggested. These five patches
>   are based on mm-new. 
> - No changes to the patches themselves.
> 
> [1] https://github.com/AMDESE/linux-mm/tree/shivank/kunused
> [2] https://lore.kernel.org/r/20261026-unused-sym-v1-0-82ca2dceabe1@amd.com
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Okay I just recalled that there have been numerous cases where people ran
scripts / compiler with flags etc and sent patches to remove unused functions,
but maintainers rejected them citing they are there for a future use. Here
are some of those instances:

https://lore.kernel.org/all/20240907021506.4018676-1-Liam.Howlett@oracle.com/
https://lore.kernel.org/linux-mm/20100211052247.GA15392@localhost/

So I think the commit messages need to do more, they need to prove that the
unused function was a genuine oversight.



> Shivank Garg (5):
>       mm: remove unused helpers from pagemap.h
>       mm/swapops: remove unused make_guard_swp_entry()
>       mm/swap: remove unused folio_to_swp_tb()
>       mm/zsmalloc: remove unused zpdesc_lock()
>       mm: nommu: remove unused heap_stack_gap
> 
>  include/linux/pagemap.h | 11 -----------
>  include/linux/swapops.h |  5 -----
>  mm/nommu.c              |  1 -
>  mm/swap_table.h         |  5 -----
>  mm/zpdesc.h             |  5 -----
>  5 files changed, 27 deletions(-)
> ---
> base-commit: 67f3b04b277373438f17300e056306adbd9edf7b
> change-id: 20261109-unused-sym-mm-8fa76462573e
> 
> Best regards,


