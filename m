Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD1BCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 18:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774C96B0012; Mon, 24 Nov 2025 13:04:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724E66B0022; Mon, 24 Nov 2025 13:04:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63AA46B0023; Mon, 24 Nov 2025 13:04:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5269F6B0012
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:04:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0555216053C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:04:41 +0000 (UTC)
X-FDA: 84146276004.20.25712D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 19F8C160017
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:04:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xyI9E9od;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764007480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8vvSY+YMFgu2Fj+wiyDitIMwCCBr+HDQMt2kOTnDOE=;
	b=vLvBTmVQbDZExwOBKfw4BtVH7nG33NPpCZ5T7m7kgGcnD0ARCSsmbgb4vVa41SE/DaeuZ7
	MVKKloJrOeiH8eGsDnowRO19zn6tXcHtXLTL/cnZwlj5qjE5h0URan8hNfpRPsqyRQs3aB
	H27fiP9sHQ/H7SxBztmm0OG5/qrbzcA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764007480; a=rsa-sha256;
	cv=none;
	b=dXpS5Kkj8QoATndLthBYN1dVmLN05WSj3I8h4OnWUpQrV3rrWufOyAisknfRILA/wxvqn6
	OwZ7+NTHNVa8yxe5qqjx5bIWshZBFMp0fe736PDXVao6fI3T7fGrM3VEXwrcGkRQWuv8i3
	vCZll5I8ddfz2J9WT6t5pknEWNe+N/Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xyI9E9od;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08818435F2;
	Mon, 24 Nov 2025 18:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97B0C4CEF1;
	Mon, 24 Nov 2025 18:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764007478;
	bh=Buz89wV/XVRY7PHLg2aVA1DAoOfcPJ65WQO4XoSmrzI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xyI9E9od5lVrE4kHG4x9twVnaDACV/2qZqaLgwff9DcB6X+ci1UtO8BJ8idl78jZh
	 JPm1bnkVQz7FOKFpBIk2GcAnwN60r8E82ewlguVLQJGRtJAmIndk4UnSinKDANlozZ
	 Fodw67tClV9Br70Br21nFRSztMX9zsmGyHM6DfBk=
Date: Mon, 24 Nov 2025 10:04:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@redhat.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Peter Xu
 <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel
 Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Kees
 Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn
 <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Pedro
 Falcato <pfalcato@suse.de>, Shakeel Butt <shakeel.butt@linux.dev>, David
 Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song
 <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v2 3/4] tools/testing/vma: eliminate dependency on
 vma->__vm_flags
Message-Id: <20251124100436.cad9c3ecd7fc592e8ff23e3a@linux-foundation.org>
In-Reply-To: <09c2d927-6d34-4e72-a593-4a3f2b739a60@lucifer.local>
References: <cover.1763126447.git.lorenzo.stoakes@oracle.com>
	<fb709773edcaf13d7a2c4cede046e454b4e88b1e.1763126447.git.lorenzo.stoakes@oracle.com>
	<4aff8bf7-d367-4ba3-90ad-13eef7a063fa@lucifer.local>
	<09c2d927-6d34-4e72-a593-4a3f2b739a60@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 19F8C160017
X-Stat-Signature: wxgfmsfist1hjjtsn7y5yc55c47q6kdf
X-HE-Tag: 1764007479-815568
X-HE-Meta: U2FsdGVkX18ff0jn6VLS0wGxP6IAe/0tZbYrvI43abOSy2MPrlpozwxpqSW3tvn3Mt/Hi4Fd31IVDIEbm5NbkeLjIEnGKMC7XaOvkTEnS7i5vrdnoin9C7KaQueIGvhEzqTsJc8Z8eVI2V0R3G2rOT0m8bSD+tqysin0Adfs/RLphA9Ur3FxD19vlLAlPl9EK8I/nP1qRqnv5JCHIZjEuPdTepy3GuFhyMMzb/EJH+03mvanlqJLuRB3j2XB7fAD/bUw/qPOhbXLbgG+LuMWhpPyqyLrLdjtSKKf7Jhswh9q7hhPl6OcfK3Pkp/wGjyiUXss1Ox4xJnhslhwvEbP/o61fCeloAP9pra48mIEqBT4ePj4Zg11HNE9uCLikqJeDrbLmGBwhNo8+67XiY72oVj606/7tDWOKOWL/82PJB3LOafPekB0zrhPCB6WSw9wDc8dZAK5D+D05O7Z7TYZYSJ55dDbAReh7wbsxC+vqKvlbBS/Q+XIuUrw12Cu1te9UMWrJYpHAIfMdk+gVqH+fBCWGLj98nMrZIgo+YuhiCuryP1z8ggI0aEOec+Fu1C6EWy46nsiq+vYfj909c7v/daEsMPwHcDW3xBx0wryubBwwisNCgc0zbJwsu+8MXKt6Gp6jczOHomXK+lL+ilF1Ov+6uUhfPFCfjCAg0lItZwscY5WL21ub1cpXwSFIjFlp1DgVcE+AdRyrj1fX57j8WQm9JCNRx33yo7ypthZNvnZStI4sXnGozJfM8+S0fI/wiTqRIgYZPIwWvAqacGCA1uYErjk22AbLk9YrDCF3eyWWQhwRgS8/xCiOMW6A2IwvaveN4XoFWLmCaXM1hKFmeNVRF1Xwy5Ez783f7BLtPYNVmjTMZ1xCIC0pKf6+SL0T0R7t728gUcZsMYq1LJ3E11NZfVsp90Rk18Yevixa9ADvpmdTWElss17beTSjMCuYZRziot+c2GlzuTOrYx
 /O0AOEGh
 2qj1X/FRgh/1h/VSSN+oLBjvOlS4TyOHHH2JhQASV2zPo6+u8Hf3eROKqjbS7X91nUaLSpgC7kKwagB5akfxbWLnOH7uswjYFvTB9nVpnlaHDvJc94pxKEIhZeRbiNj4piREWjZ653GfG4Jb2xV06NYjLzzmqXqbd3kg51PjlkkXG3wy1cy0p5zCDg96lteiTaKGNkCGS+dKfHwNo+WoCFcC/BZ+mm1+QFNX7lHoXN0XtyangRPskIajUcVVYFOSagIp+OSnimetVOLtosvM7n3NnbXrRnDJ0JmjaFDuDCTFR2eqmX+f/Yhmg1PvQfCIL9YRvOFeSYQlXzqoMiz2K5wHD5EuhZkElN1r3aqMjDKo0JvYDLsBWFJPYQiHF4l1C9Ky/HjrhY+htzAU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Nov 2025 12:43:18 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> It seems that the ordering of things has messed us up a bit here!
> 
> So this patch (3/4) currently introduces an issue where vm_flags_reset() is
> missing from the VMA userland tests.
> 
> Then 4/4, now with the vma_internal.h fixes in place, puts vm_flags_reset()
> back in place (this was my mistake in the series originally!).
> 
> But then this fix-patch, now applied as the latest patch from me in mm-new,
> breaks the tests again by duplicating this function :)
> 
> So, I'm not sure if too late for rebases - if not, then just squash this
> into 3/4.
> 
> If it is - then just drop this patch altogether and we'll live with this
> being broken for a single commit!

All confused.  I dropped the whole series - please resend?

