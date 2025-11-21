Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6067DCFC501
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8EF46B0008; Fri, 21 Nov 2025 14:55:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66686B0095; Fri, 21 Nov 2025 14:55:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3566B0098; Fri, 21 Nov 2025 14:55:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 988016B0008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:55:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3FFCE13025A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:55:56 +0000 (UTC)
X-FDA: 84135669912.07.9979ABC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7630B1A0005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:55:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1gsWB9CG;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763754954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdwVRPLzKiQauOsJu0jJhEHQRniyilDOudPTuQE7QC4=;
	b=fONQaxuZEIFiy/TdwZb2h6OMHqtlsKkbQH3mQWAdg7xnaUfkxaFp34K5zuTFNjxEIMQFpx
	ly1AwdanE2fUTzrqRtcL5/I3b16yrOsmJCBji7Xj6GGx8u+MS/a1xb79K4oql4Pc87EhKB
	ziWZ5tNzRWGfrZAK5Yq9t6LPcGU0fbc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763754954; a=rsa-sha256;
	cv=none;
	b=Xsbr0ZRiJiosQ45m7ZHskJoKoo5o00aZISYjXaatPz4zyXllLgZ8tU5PHF3DC4/GaYfeft
	fg8giy7Bczftx2YXioNloFRFeZuH9cAMLco83ajGtiIFlKOi0L70+ySlEZkGfwe5tLZeAF
	KVd5FRZiC1siGBqSYEUdq2MYHpL89ZE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1gsWB9CG;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D5E54197A;
	Fri, 21 Nov 2025 19:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01299C4CEF1;
	Fri, 21 Nov 2025 19:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763754952;
	bh=ZJ2imUn9Mco77w7/pdIgQXc4oF4zUj7dqNGxM1kbtZk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1gsWB9CGDheDWsUEWoqPq+K2Og2h9mfP0NvvauyDN66X4mW929BZ9UKFHwPQXSfGy
	 Gg/r2nAupA9992Bws/OHN7TpqhJa/fZ+kEl8obZ1dppTp69FiQnjzoYkWIqOioVhAF
	 8wQM/kxEwdZcv6ztDi7xcMyEi6B3+NUgFaO93Jbo=
Date: Fri, 21 Nov 2025 11:55:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio
 Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Peter Xu
 <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Arnd Bergmann
 <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Kairui
 Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, SeongJae Park
 <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn
 <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 07/16] mm: avoid unnecessary use of is_swap_pmd()
Message-Id: <20251121115550.8a8f9b39189b215849ce165d@linux-foundation.org>
In-Reply-To: <67c63cce-f1b8-48d3-83a6-6de1f2d86dda@lucifer.local>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
	<8a1704b36a009c18032d5bea4cb68e71448fbbe5.1762812360.git.lorenzo.stoakes@oracle.com>
	<a623f785-6928-4037-b4be-5d42b46aa603@suse.cz>
	<67c63cce-f1b8-48d3-83a6-6de1f2d86dda@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fe1rf9sa7h1iufjfyy1hcb9h3gfn818s
X-Rspam-User: 
X-Rspamd-Queue-Id: 7630B1A0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763754954-685406
X-HE-Meta: U2FsdGVkX1/InknCeWj8YcrQ5WB1SA+1kY8EcltHLSAkNM5pFbArDy7KCRwuCN77JKVrz6RqDXzQIvT4Smr9zfm/QBbT7iaXvPxDXfNuYRcS3jNgjEEekTc39ViAgpu63O+qPHcNz49YQBxjZgkGgrfqtWm7cJKuHsg8xGlARhMdx7HX1BEBvA7at2UY2BNJsMSi0yH7lOZqpVtl/NUniub2dFJWLoGjYnObs605xJMzUfyoJg1nM8ebxawJzqtXfHH40pm7Wdry7t/C3yiQpLnkWRZQ4YKcwplFVQomGDI/01EJDUbtfsc9CsqxX0Z8U0+Ev9CX71ObtifBIYUbNelL2vnMVfszvFuDoyXK3gq2PNdltXVxNBtmZyVQy618PmgLlFHzBomBWiQx37zWkQv/Vn84/jdSXVQIRVwa444TxYdp0lBgwHsRHIW2WmiMT1PSq9879+goiFkv5AbNwK+1AEm36nYf0rq+k9Wt0u1IS0fROwn6omOZyA2t+wuy/y2LdrYICK023a1yZtXQoQMsOn8n9ZqPPOl0w4sCRJ8FqicK9pX8zh7U0tnvVJRESdQuFlTCSkcJ/LEuSqdbxwYZ71HiOV/ZJFKXVfSvoTfcHCTvrjDA/8LpM23jpg64ruAY/3zCZ7fxedSnHujqPzgBcBRczm0GcG9MifxZTsxB1h81ycuf3rAIEFq639QwDmtBWr15G/f8NsZLsoghKm6aHXsOHPHt97ACldfHaeSUrJHvY+Sk/ZxLG9uicKctmzx8OPt6DC+P8D//zGARqkvy1v4LtvqayUwWlYH8vkimYfvIccizXWfNcSBdOfwVaGgIrGdmUvZcLOBu/0MOTAe5r1UFey4t19HjpkZHAFD2LQnViqfiJW9nz5OrTD6jYn0Bh44PtA3rmUzkcxfi3XoSLeDRykheVxVNdwyy5qCSr71g5GNfzXCWaeeS46Q6PSeELcHVlW23xSP6rfZ
 zS93/JPS
 EFM0AhK15uZcVXYgaoyBiWajjjTAkKs3As67XhsZhHm5WF/pe2ioynJ+M2KERToo9TTlo7TpmugmhHAWpfCAfVIiEKcTteKpL2AZJQCEr72kd90f9iTQhQXAlGMc82X0uquUGvPkGvGnpgZeyhJbzE84VRujig0O0+d/EK2N4Z+rT9phK1bNF42HiPwwrJ5pG5sXO2mOpOvKuuq7xS9idJ1khmdWiYE3p5n7gu20oYcdOSpDgxsqjz+0SVX43aaVVkr/upIZ0Q5UMf8KrZQRuBc/kGTNzd2Fie0IuZdTVQ2XiZn4K000yfeL6Iko+xmGWpqquk+vIUTNGOr/jzOqPF3FtQLk/hNG/TCh+1lBypSItSJu3rWMGNU4JDm8HYOQ9idz/+C1tL0PROsoztG9XczMgR3E2/E7uuBFr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 19:25:46 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> > > To add to the confusion in this terminology we use is_swap_pmd() in an
> > > inconsistent way similar to how is_swap_pte() was being used - sometimes
> > > adopting the convention that pmd_none(), !pmd_present() implies PMD 'swap'
> >
> > 			       !pmd_none()
> >
> > ?
> 
> Yeah sorry this is a typo.
> 
> Andrew, if it's easy to fix could you?

a few hours ago ;)

> If too late then never mind :)

"too late" is a thing I try to avoid!

