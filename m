Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2697CFD531D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 09:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45FE36B0099; Fri, 27 Feb 2026 04:24:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D3D6B009B; Fri, 27 Feb 2026 04:24:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32C9E6B009D; Fri, 27 Feb 2026 04:24:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 204AD6B0099
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:24:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 903F01C6FB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:23:59 +0000 (UTC)
X-FDA: 84489699798.04.ACD7D25
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 99E9C180005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:23:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y4IV3lkr;
	spf=pass (imf24.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772184237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ahYWbUe0DXVnmog0OWvwx1sBk5tywROJKEZUGn5BcUM=;
	b=ysp7SFD2mDPM60vJf/02oRrOscJ71QyMHjEBFBPUlWww+hKOyaRzploGJS9y20ZgSHdQ6W
	cNgQlguQmAx6NRRP7LqH9s54fVhHMW2Ftj8l1dTMJavZDukwu32bm+iQdPuy57Zwf+yOSQ
	bzFR8OQuLqtqdjcPJIJAmG8bvYyy4wU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y4IV3lkr;
	spf=pass (imf24.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772184237; a=rsa-sha256;
	cv=none;
	b=FnD4wYDaskcnT0bkAG8EYAlUigV2KvkLk6Ai0CXUpSb3C3DXd7//NjH2oOuZB29Wt/yT2X
	s/HpUBSMMNSOErtCVhN/C6R7UBlqp+R3q0A9hkgFl2mn90tTYrsAdIP5KxyEFUmXy+L7s9
	0g3KFC5/nZmoLFZJYhnXmM3+6iGd3iI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772184236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ahYWbUe0DXVnmog0OWvwx1sBk5tywROJKEZUGn5BcUM=;
	b=Y4IV3lkrAlOUt9vfGs/pqoSMD0Ri7Dv/ynui1lfNcWE/Sr2pHxEml3UbJtERDllGu+5a3Y
	1jiHC/WaiggzRHSkwZxWVguD5rRkpBzfKwc2pUdVLyvlVYQ7NuALPVM5E5NKs3weFkf/CL
	AzAnxuaL9GmrWtvhSwi7xEEw9d3UJNM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-44-oMJTYj7_MOuMKnVxUWadnA-1; Fri,
 27 Feb 2026 04:23:53 -0500
X-MC-Unique: oMJTYj7_MOuMKnVxUWadnA-1
X-Mimecast-MFC-AGG-ID: oMJTYj7_MOuMKnVxUWadnA_1772184232
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E3A6195608D;
	Fri, 27 Feb 2026 09:23:51 +0000 (UTC)
Received: from fedora (unknown [10.72.116.93])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5CD91800666;
	Fri, 27 Feb 2026 09:23:45 +0000 (UTC)
Date: Fri, 27 Feb 2026 17:23:40 +0800
From: Ming Lei <ming.lei@redhat.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <aaFinIsCmitHSP_c@fedora>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
 <724310c2-46a2-4410-8a5d-c69dcc8de35d@kernel.org>
 <aZ7BbosIr2FvZFAe@fedora>
 <c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org>
MIME-Version: 1.0
In-Reply-To: <c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: lvLWFD_K66vkk4NI5I2emadcn7mHQbT0H5rO_EYclJg_1772184232
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 99E9C180005
X-Stat-Signature: c9ttxn5cofkke34916sjn9pwytgykcr6
X-Rspam-User: 
X-HE-Tag: 1772184237-954790
X-HE-Meta: U2FsdGVkX18+Pt3j34WhOr8pdEcS6N6gAfJbQknOUwFg+hMXIlgD8bnfiDH2vktWpflT8eFiKf5s+UAS2pSzllFGMgY5WXYVbCV6Ym7awKm1ZJg8AAwK5zzh/7q7mzUIKs2MHp3E1obZl3T1PnIi0j0/d7Ohs6Srr0VgDVjz29cf4oay3DBeToJgxm/h+eccrKqfABuRf9/1HDuSdqZIsDk20mHoG93mOO6oBT0s7uiBIuxbCO/zxv3FCerHaMi9CNBxxbc3bKJmLuI7XE3aO/tysPO8pQd48jI/dvCvgkZImj29F0gvGCJWLaRKVoGuEZFsSohlpBcOEpIw8jfi568/WPRrVacI9FIA43Eyga/H28vtB5uU9TKtQRU9oM8fCoq5aXulFxpAmOMhaDthdkgW6Lp796ljEz+ud5mYd+u/qdJrbrYnPUJCLp30dFpNfjfEpHN3mhZR3yekeDSYehct31/a7G3SoWzJa9eMNh9EhXScuCSBnKTPcscB08S6UKd16HWdIRM4i8C4oJEu1v/0v4as+jkEo3thJGVhkjVPdfpifASa4ycK1ikRNNpmlod/WfN4V9Se5+5CzS+tehMmyWqcxBQWYDM2S4ElOuEMKYx0hVqKqxeZ2VPmS3NpjiCsjsqa6cOUpcD0YR96kdPcjibZ4oVSw1rxuUef/gc2PTv2Jmdqt1bf3n9PWAGdkz0LiMEUK1krYFwPuUNWUL1umdHG1R8YEzbFDzij9VCrO4mbnWRGXnK77ojNhpmo/MItcMiiigFAiRc4Icv0BAF1E0/Y0etkFjqg/IU56mgP3UGrcCjWDjncJFc/CVkrIXA8rI7vxxbFJjW2zW+LEx62vlIrROMGjfmBFQExj7YkHzD0+8lWBbeB0+jsht6jz8ir14yRTQLMxAotbZdZhohTg6v7hVirh28b67mtu4z2kHAN3rjtWlyjXNKL4KvIiIG7l2QWN0OrZ0XtGZy
 1Ru5QTk8
 lkMtpwE8zY/PqL9bEGZP5maHR7DbTeZ6ZWXIGwZUk6ONGXmaAuCHpU1crW2NBEf6MdWd+z9MB0xjzjrsPRTsWIUhAAYRJ+/p3eE2uRTX0iwQtirwBkyH5blyc1ouq4wc8OwUZY1pl1qYCpT+0yzs8KCrG8L9oWv/m5ta66x52rk3DoO9vzUtcKIeh0KdcDAAGiHlzhvsdQ63sw0qmPJ3/L0O5Kv3fPH5jgQHpOHGdxtUtEoK9KNrxu6TNbtbecxgYE/dINs8Ab7VooOTr6SYTOsvf5FoqYUqCoqPpqLNmZ643k2YqMY2JcOsguNKcWkuNsrj2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 07:02:11PM +0100, Vlastimil Babka (SUSE) wrote:
> On 2/25/26 10:31, Ming Lei wrote:
> > Hi Vlastimil,
> > 
> > On Wed, Feb 25, 2026 at 09:45:03AM +0100, Vlastimil Babka (SUSE) wrote:
> >> On 2/24/26 21:27, Vlastimil Babka wrote:
> >> > 
> >> > It made sense to me not to refill sheaves when we can't reclaim, but I
> >> > didn't anticipate this interaction with mempools. We could change them
> >> > but there might be others using a similar pattern. Maybe it would be for
> >> > the best to just drop that heuristic from __pcs_replace_empty_main()
> >> > (but carefully as some deadlock avoidance depends on it, we might need
> >> > to e.g. replace it with gfpflags_allow_spinning()). I'll send a patch
> >> > tomorrow to test this theory, unless someone beats me to it (feel free to).
> >> Could you try this then, please? Thanks!
> > 
> > Thanks for working on this issue!
> > 
> > Unfortunately the patch doesn't make a difference on IOPS in the perf test,
> > follows the collected perf profile on linus tree(basically 7.0-rc1 with your patch):
> 
> what about this patch in addition to the previous one? Thanks.

With the two patches, IOPS increases to 22M from 13M, but still much less than
36M which is obtained in v6.19-rc5, and slab-sheave PR follows v6.19-rc5.

Also alloc_slowpath can't be observed any more.

Follows perf profile with the two patches:


-    8.30%     0.19%  io_uring         [kernel.kallsyms]               [k] mempool_alloc_noprof
   - 8.11% mempool_alloc_noprof
      - 7.64% kmem_cache_alloc_noprof
         - 6.15% __pcs_replace_empty_main
            - 5.96% refill_sheaf
               + 5.95% refill_objects
+    8.06%     0.44%  io_uring         [kernel.kallsyms]               [k] kmem_cache_alloc_noprof
+    7.44%     0.00%  kublk            [ublk_drv]                      [k] 0xffffffffc140c71b
+    6.63%     0.03%  kublk            [kernel.kallsyms]               [k] __io_run_local_work
+    6.19%     0.05%  io_uring         [kernel.kallsyms]               [k] __pcs_replace_empty_main
-    5.97%     0.01%  io_uring         [kernel.kallsyms]               [k] refill_sheaf
   - 5.96% refill_sheaf
      - 5.95% refill_objects
         - 4.87% __refill_objects_any
            - 4.76% __refill_objects_node
                 0.72% __slab_free
         - 1.00% allocate_slab
            - 0.80% __alloc_frozen_pages_noprof
               - 0.79% get_page_from_freelist
                  + 0.72% post_alloc_hook
+    5.96%     0.02%  io_uring         [kernel.kallsyms]               [k] refill_objects


thanks,
Ming


