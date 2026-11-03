Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6A4606BA38
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A386B05B2; Tue,  3 Nov 2026 10:10:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F506B05B4; Tue,  3 Nov 2026 10:10:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B016B05B7; Tue,  3 Nov 2026 10:10:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 813DA6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:10:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0DF8AA0489
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:10:37 +0000 (UTC)
X-FDA: 85394144514.13.49AD42D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1EC6514000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:10:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Qjph4BUN;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4ejFprHMn7fbA6AWJoEiEq8rfSRXpFulq4sNe2AGUA=;
	b=K+5ojqq6V6liBOvIN1KyPYw5bYrvmS86Xkb6hzyapYHHaG+4TxY/t/ecg5kYJhJdL9i5yi
	BKTLDs+AmrQ5si5PpyGofMu2dJMY3W52tChCu3CXhnB3n7JggRHgYLoZnxKb7OO71LXO9V
	KpwC0oFex+OdbgVwhxv7bGMT0fZbjP0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Qjph4BUN;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718635;
	b=3K0oywxqqSpFdYNgJzZz+NwQEHoovRPBe+tx/YNkhMP8sBR6zcGpwnfnjgUZZh6EcWBHYO
	JbCm0A6V1CgtOZgK+qYztxCefggl+GrN+rNB00+p1+3VyOglehzXqofaw+DrA/aMvTryda
	kYw19Cg7jtDSsTAb3nsdA0hLsqwJJKo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A16B43F9B;
	Tue,  3 Nov 2026 15:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224FA1F00A02;
	Tue,  3 Nov 2026 15:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793718634;
	bh=y4ejFprHMn7fbA6AWJoEiEq8rfSRXpFulq4sNe2AGUA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Qjph4BUN/7Bx65go6uOjaS6ro8gpXeSXABxtg2sKX1STgEQbQocSdVe/GUvVSZBL6
	 /WV94KXfhUMncqUJ+s8QUo9vlBuudYt5mH9DSWfyjvwA6FpjLONymuSiKLTWWo7H1j
	 UweUoz3VZpQlfrR5Z1r0qnEjCKrgoPx5ReOz+1Lg=
Date: Tue, 3 Nov 2026 07:10:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Alistair Popple
 <apopple@nvidia.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Brendan Jackman
 <brendan.jackman@linux.dev>, Byungchul Park <byungchul@sk.com>, Chengming
 Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, Christoph
 Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>, David Rientjes
 <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>, Dev Jain
 <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, Hao Li
 <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, Jann Horn
 <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>, John Hubbard
 <jhubbard@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song
 <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl
 Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>, Muchun
 Song <muchun.song@linux.dev>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, Nico Pache
 <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, Pedro Falcato
 <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim
 <rakie.kim@sk.com>, Rik van Riel <riel@surriel.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Shakeel
 Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, Usama Arif
 <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Will Deacon
 <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, Ying Huang
 <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi
 Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Manfred Spraul
 <manfred@colorfullife.com>, Christian Brauner <brauner@kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 2/7] MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
Message-Id: <20261103071031.803bcf7ef27349e5035625e3@linux-foundation.org>
In-Reply-To: <b04d8d01-b42d-d948-b7b8-c360f8ec6002@google.com>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
	<20261030-maintainers-v1-2-97278f8a5f54@kernel.org>
	<b04d8d01-b42d-d948-b7b8-c360f8ec6002@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fmho5jb5cego6q7ejrgicuregx5cpp6t
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1EC6514000C
X-HE-Tag: 1793718634-850620
X-HE-Meta: U2FsdGVkX1+eZ5+sZVe2VWjXYphRcTlmzoAR3UsEGQGw2aMdJXj5ptbbSVLE0a6viObygvQ0sU169wyUg5TkCbuobV/l/HuoCYZ03+K22SDI0LpeMdrpXUYDWXrntzlehUh1TtHsEeqpgOtk11CXPhM5D/qj7k3M+N+oDhdyf9oEXVfZ6I326GnbMIwUy0Dlmw1tzckVpVPttHemqjSqXTdFEI6VYNhf4RzKF8jlItijpY3LpVdv+IPNEqudThb1AQ2xCObrMJi5p0icRSimtnQmXUkiyrXMwQPN/JeznADQcrxDxV57ibE4YNdRa9yeT0VMeU5lQqp82MD5vXDqVy4ssK+i2bpoperp6OpbBGt0zZDuPjagT/PAjgBHP33TvW/Yj5WyC0MyzQSZf6e5sX7o70RrfqbEus2pq1d5020aHAMGnTudwM5cnnVApc/aGBz9VN/XCt3+5GXr4XipW1KzMtpYGQYduEB1lWT03W3p37iAA6/givMZlo2tMYB8aGDiWBRcqQ/XnI57Vwu+OV8pjFzp/LwvVV2Z+4G2WQIU9C5hwTMT5nIEWdZtkOGRzJxFn8zhy40qlVUGuSOeHy3laidCfS40ap6Qs0jLR5PRWjFCmghWBN+aHBOQ1hC5V2QQNSJ8GX15pvX/hg6Zce1C1aCE+q7XNZpdn3WCG6fsLugoTw8m9eh4vKfMPXrumupWSKiXV0WrWopI5HeXHhZ1hjj89ExzOuwMouipXWrWXvfhE5QnxWEtNG33XbRMDPI1F5eh9pKoiJKUdQ1vHnHsSGm+9MaGjehLt187MZQUwxj6JUMjYzA3pBe/2zJscDB4JkFx9xU/B6/S1mPS9sl1GlXey0Xj91w0+cIcM3ItpiW0VNR9sjz5iFWn2iQ2+N+mkPTFqO2Tzglo1R+bGzimKnKIzcxJTAFVrh5xQV+eJWtFFAdOqu/Yeb77OAYVh9rvL+o2U9pmGHrD7fz
 q9s9+tfL
 xRyVqlMp7nGEWzTy70uqgrAAktwrx8GcgX0rKQ73sA0Q8U38vYiao+DJ8MhU+cNdmCvV+4bbqd9QR55z9P6OuH2M00dohks+zqSOM8qLviYtnXwDesspyHf1j2/zQ6Ob0RL97tx/Ld+bPUfBO+OW4RGAJff1Qqp6msqjb6aPfI228uYnQIYPBs3sRjOZrRAP2sJd7/XGPtdj558EpQYZGi5c1dImnDEm9NT+9dDcZMgZLWBTMxkFeKg2YKZI9HHxnuxVLxN3RNVQ3vXSs7rRzdaHxnZk8hyviDfG6DXe7SZPRdxPli2vUF1YY9ImDUcoVEJcIxEd7KoyG8qKgBtxoQA2leDqvLC34bcy1KGlHFXM/tfVGzNJdb9K+ZU9IPsoNxHuvM1rPJ03OaBfB9zvQrHSLJQdxe6ceKZJZ/Ti/vSuWHThRlvqGDnGvpVDHAyGrcqjBfpHspmTL452189FDNwV9nM0M4TQZnOuJha8orghRCQQ4xW+5eE1hxgpn2dVJ1XV1dDgCc/Nnst1ROEZ8LOe3SVIeGRZMwY5lvkw8bQislEAcdHfIkt2IrVvkf5dzp6wo6e5loZAobHXvBLBXWI7Km+LQ+sHmzcfrz2CM7cB0ySVRfBAihrTOSwYZBKln/P9v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 3 Nov 2026 00:27:22 -0800 (PST) Hugh Dickins <hughd@google.com> wrote:

> On Fri, 30 Oct 2026, David Hildenbrand (Arm) wrote:
> 
> > I am not really the best shmem/tmpfs/memfd expert around, but it should
> > be good enough to judge when something is ready to be picked up, to then
> > pick it up. I'll have to heavily rely on Hugh and Baolin on judgment
> > for the more involved and more controversial bits.
> > 
> > Rename "TMPFS (SHMEM FILESYSTEM)" to "MEMORY MANAGEMENT - SHARED MEMORY
> > (SHMEM/TMPFS/MEMFD)" and move it accordingly. Add myself as a MAINTAINER
> > so people know whom to CC.
> 
> Thank you for taking this on, David. And thank you of course to the
> unlisted Andrew Morton, who has been uncomplainingly filling in for
> me year after year; and thank you to Baolin too.
> 
> "SHARED MEMORY": should ipc/shm.c be added to our list of files below,
> as mm/memfd.c is? (Though both can also go off to hugetlbfs instead.)
> Or do you prefer to regard ipc/shm.c more as a client of mm/shmem.c,
> rather as drivers/gpu/drm is?
> 
> We don't often have to touch ipc/shm.c, and generally ipc/ is well cared
> for by Manfred Spraul (but I couldn't see a block in MAINTAINERS for it).

I actually have this queued in mm-nonmm-hotfixes-stable:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: add an IPC entry
Date: Tue, 27 Oct 2026 21:09:52 -0700

Add an entry covering ipc/ and its IPC and POSIX message queue selftests,
with Andrew Morton as maintainer and Manfred Spraul and Davidlohr Bueso as
reviewers.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/MAINTAINERS~maintainers-add-ipc-maintainers
+++ a/MAINTAINERS
@@ -14070,6 +14070,16 @@ S:	Maintained
 F:	io_uring/bpf-ops.*
 F:	io_uring/loop.*
 
+IPC
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Manfred Spraul <manfred@colorfullife.com>
+R:	Davidlohr Bueso <dave@stgolabs.net>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	ipc/
+F:	tools/testing/selftests/ipc/
+F:	tools/testing/selftests/mqueue/
+
 IPMI SUBSYSTEM
 M:	Corey Minyard <corey@minyard.net>
 L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
_



