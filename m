Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB63CC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA696B009B; Tue, 22 Sep 2026 09:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1926B009D; Tue, 22 Sep 2026 09:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C127D6B009F; Tue, 22 Sep 2026 09:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9861F6B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:48:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C7D41404E3
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:48:18 +0000 (UTC)
X-FDA: 85241527476.10.39431F6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2522340013
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:48:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iqMOITd1;
	spf=pass (imf04.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790084896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IrbNKYXaxBgTnuatiYDHte9IqTtxWZJRiUhRvSTwak=;
	b=BO2XFOOO/dsKiW/4xJPeSKqv5SbBOatuEyeduVn6kLOlIuCsJbIoT95tlhMw70FMz35gu5
	0Z4hqLUrBQhqNBduXIK+YtJVBHzcRTumDhkUAhY7cy3uj7VewxaQWAmvq0+6+Ux2hG4JqW
	q3rBfPvQx7ZJQF693MYTq+VjJMpzOHY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iqMOITd1;
	spf=pass (imf04.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790084896;
	b=NX+acOPEl7liiDN+IRd3o+DrtXX7oPudOi6ecuq/JBrHcueMHU6W+K4lA2Apo+CtRHtSjV
	Gknb1P7mLqM8QLRDuIvBwylCVmDRUxdUVphif39pkp6MkHiOZBYDNKl0/QoLqC8XlzdBXl
	zqiLZgnF1vfEXvJhs5zB1hOZ0AoBqNc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790084895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6IrbNKYXaxBgTnuatiYDHte9IqTtxWZJRiUhRvSTwak=;
	b=iqMOITd13xmvy/DSRXNUxqAiQOVd+tftAh5Y3r7hWqjrmQpW3jDjj/9oG0EJkRbLbCbZoZ
	C9gW3Mo1g61XVInuxlKF0vj8MHAcnvlvCtnEaOUdqpn7W4D5x3MI5bF6QqSZd7NaWuXd1c
	opiQpHnwdcnk7dMMmdnKXFOyt1AuV8w=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-299--PafZw6uO163-ZRW7g_LJA-1; Tue,
 22 Sep 2026 09:48:11 -0400
X-MC-Unique: -PafZw6uO163-ZRW7g_LJA-1
X-Mimecast-MFC-AGG-ID: -PafZw6uO163-ZRW7g_LJA_1790084888
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E1E8183090D;
	Tue, 22 Sep 2026 13:48:06 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6486930001B9;
	Tue, 22 Sep 2026 13:48:00 +0000 (UTC)
Date: Tue, 22 Sep 2026 09:47:58 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, hughd@google.com,
	baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
	ziy@nvidia.com, joannelkoong@gmail.com, djwong@kernel.org,
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
	chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH v4 0/4] mm/truncate: fix data loss when truncating
 straddling large folios
Message-ID: <arKHDqdDkQajvAk6@bfoster>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: JnpoQaYqlk9rQqeUGc8JClMlZrxrm6M23EtYSDeakHI_1790084888
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2522340013
X-Stat-Signature: 6u83cbp1pmy87a1c77xaukgzkkg6zigp
X-HE-Tag: 1790084896-173760
X-HE-Meta: U2FsdGVkX1/dsJ7YOvmTZTrtUh7c+LnCg7pHY0kDY60Wmh9SS08ZalFgCpSpQX6c8T/V1pc2dGXl3S6kgdkyEXadDEptlQm2Cv5FSGJvNWVzF3dpwpP3245hFb5uqmG7DYH9z6Q+HLB3fDnlRiGyK11vpt1KGF8rAW4cow4ukKeb/ZjFWe49NO9fknPxOH2hJPBiwN29LykgrFMV6bhY8/iwrEg8n7rytKQnmsojIUpRqilXnb5ii3stefRwApStp+vBpcRAC+/mLb1bZH9uUY4QoqUqpLC4oHcSUxmwXrXn8wpvEGWpwi313gRy7f2B+WXrwzOgECpkiwZo2JFo73bQu83sWH6BrfD35WoFVYaSgN5BG8tuJpAQDVrIy5q185ZNhzZ582CdcpfXKOv2eLphiovkum4V7ffFHcyDVSDKAfsB9MkpTIbNbKnlZj87PrTGLJc2qL3g0pTYURrN7DkH7WN9q5yVJ3tAMXFYu+I343sRUc6zc2pSDdHyceC+ZhDaL73IklN/b25PT+8ym9IrsAsNXBjgnjYV7eoyhIFIOQ0nG3xoPVu9UQhpyG4PLzvgRkuI9mQqkA8N/OryH5H99Sx8n7phn4jzHrl40EJ01jxS8rCqUEr3bqmdU5aTWoQn+T3parseHuon+u7ISNu2rSnVbCQQFC7DtCR63GDxahDcTf+XF73boFXhDv9KugMHfUA8KS6pjEUuhdNZHwfCufd9KQabdnkvK6lcEgMVOmIloBROaLnKgiUqPAcEZ8gLsA8CRs/i7ICpcncOvRI2tB0gg+bA2c4L3g2rEMIrJmtE9jC9ssIp6CemgfwBtG5MGz7sOppVLdrp+kAJqNPOvRNJWq35+RiwwSBgcrHaRAmndquk13pGlSG3T4vw+KAkd0yrkSw1wDOy51ZLqFNlvGB/LS5lWT1TgCINRbbTXSG2pmDqKKh2TmIXeXEAIAJaeQwe9vvxk+R1Uof
 7KtK2zQk
 8xYCrlTS2l5+SjaaSMdJTeaj0lfTYmUsByzJd3k+SIbjRR8BvQ0NUKgiK9ebRrEXD00TxikisWHA2Y1fSDOka7oI71kv8m40T+ThbtVBPZed6q4KQX2SqgWj5evIH6eWyqaAhRgTga2gToBBcIxMshBXiajkc9/3rSQtEsG9RwEqrOvL1Q0bPc7TzxvjI141CaZ47+Cr+g8/9ohNfqlvOev45WJMZ3ZXqPmfb+T2eLUR6mqWtOujR8ABvipC10/jFoCVGHcMrthberX9Om03FSTF39U0zV1aqhNZE/Ml7XCGW5TKfNQ/5AfTExed6L41qiQLwSW9P4mXot1meAY7i6o0AeIdaNXk5LPbgosApT6OO/IZKYv8bDeUsNICrsOsR9wso8jXJDlvRTrsKCy2O07vB1cjKSK3jUVPpioiR9vk+cB6pUdneRMVOvjfSigCwWa3IsY9ACTjoGZbPnKCGnfEzBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 07:06:59PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Hello,
> 
> This is the fourth version fixing data loss when truncating straddling
> large folios caught on the upcomming ext4 + iomap buffered I/O
> conversion.
> 
> When truncate_inode_pages_range() punches a hole or truncates a file,
> truncate_inode_partial_folio() splits a large folio so that the caller
> can drop the in-range sub-folios while keeping the out-of-range tail
> intact.  This series fixes three distinct problems in that path that
> can each lose the valid out-of-range tail of a straddling folio, plus a
> follow-up that clarifies the return value semantics.
> 
> Patch 01 aligns the truncation boundaries inwards to the mapping minimum
> folio order in truncate_inode_pages_range().  With a non-zero min_order,
> folio_split() stops at min_order instead of order 0, so a boundary
> computed at page granularity can land inside a min-order-aligned
> sub-folio and the truncate loop drops that whole chunk, valid tail
> included, causing data loss.
> 
> Patch 02 looks the end-edge straddler up by its page index through
> __filemap_get_folio() in truncate_inode_partial_folio().  After the
> first split the straddler is unlocked and only transiently ref'd in the
> page cache, so the page pointer derived from the original folio can be
> freed and reallocated as a different folio in the same mapping, and the
> mapping check cannot catch it, which may cause incorrect splitting and
> potential data loss.
> 
> Patch 03 reworks the contract between truncate_inode_partial_folio() and
> its callers.  If the second split of the straddler fails, the function
> reported success unconditionally, and the leftover incorrect end
> position could cause the truncate loop to drop that valid tail.  After
> rework, it tells the caller the exact page range safe to discard via new
> pstart/pend out-parameters, so the truncate loop never touches a
> straddling folio that still holds valid out-of-range data.
> 
> Patch 04 clarifies the return value semantics to "at least one split
> succeeded", which is all the shmem caller needs to decide whether to
> reset its scan loop.
> 
> 
> The second patch fixes a pre-existing race issue that is reachable
> today, so it is Cc'd to stable.  Patches 01 and 03 require a dirty large
> folio that carries no filesystem private data, so they are not reachable
> on current filesystems.  They were found while developing the upcoming
> ext4 iomap buffered I/O path[1].
> 
> Thanks,
> Yi.
> 

Hi Yi,

Modulo Jan's comment on patch 4, this series looks good to me. FWIW:

Reviewed-by: Brian Foster <bfoster@redhat.com>

Brian

> [1] https://lore.kernel.org/linux-fsdevel/a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com/
> 
> 
> v3->v4:
>  - Move the patch that fixes data loss when min_order is non-zero to the
>    first patch position, aligning start and end in
>    truncate_inode_pages_range(). (Zi Yan)
>  - Add patch 2, fixing the invalid folio2 issue under concurrency when
>    truncate_inode_partial_folio() splits at the end position. Use
>    __filemap_get_folio() to obtain a reliable folio2. (Jan Kara)
> 
> v2->v3:
>  - Rework the folio2 validity check logic to fix the invalid
>    folio->index issue. (sashiko)
>  - Clarify the pstart and pend setting logic and the corresponding
>    comments to make it more readable. (Brian, Joanne)
>  - Split the patch into 3 small patches. (Zi Yan)
> 
> v1->v2:
>  - Export pstart as a new parameter so that the generic and shmem
>    truncate paths don't need to recompute the start value from the
>    return value. (Brian)
>  - When min_order is non-zero, align [pstart, pend] to the inner
>    boundaries of the folio to ensure they do not point into the middle
>    of a large folio, which could otherwise cause valid data within the
>    folio to be incorrectly cleared. (Joanne)
> 
> v3: https://lore.kernel.org/linux-mm/20260916092450.654408-1-yi.zhang@huaweicloud.com/
> v2: https://lore.kernel.org/linux-mm/20260909062339.473816-1-yi.zhang@huaweicloud.com/
> v1: https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@huaweicloud.com/
> 
> 
> Zhang Yi (4):
>   mm/truncate: align truncation boundaries to mapping minimum folio
>     order
>   mm/truncate: look up the end-edge straddler by index
>   mm/truncate: fix data loss when splitting straddling large folios
>     fails
>   mm/truncate: clarify return value of truncate_inode_partial_folio()
> 
>  mm/internal.h |   4 +-
>  mm/shmem.c    |  13 ++---
>  mm/truncate.c | 128 +++++++++++++++++++++++++++++++++-----------------
>  3 files changed, 91 insertions(+), 54 deletions(-)
> 
> --
> 2.54.0
> 


