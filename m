Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A489C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534A76B00E6; Mon, 21 Sep 2026 05:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D926B00E7; Mon, 21 Sep 2026 05:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4238A6B00E8; Mon, 21 Sep 2026 05:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1961C6B00E6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:22:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C883A5C35
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:22:28 +0000 (UTC)
X-FDA: 85237228776.11.EA615FA
Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	by imf13.hostedemail.com (Postfix) with ESMTP id 338EB20007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:22:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gvcCXz8O;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982546;
	b=ZMrDLg0m5+jGZN6Hwx6RtDRMVmZ2W3NIfZlWzlj4KG3T+4tytMF3ZE02hYXXY5qX9ufpLl
	tttE1dXVn6XYkwqu7PMirYWB5yvkFZlAnV323S61a4iZCGFsGwrJMJWZgwnKf7jaR5iKo0
	X7KDsj/qRbnL25DKwVVEhDPvuGOM+Ho=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gvcCXz8O;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOKknHcP73nbkRKFnVCIb4yPCiHlV575inRm8Pf3kw0=;
	b=DqREhPjq46DNBA9RTZYLkA7ca1MJAyFSzR1OK8FYhodTWxpf/UxPPFpDYjWeUS/qqdZF2t
	RVO4wGSjA2+jZBn1YWF79MVLhAvwYE+kotGDvHl2uF/1I6Sn0wSiWOUNVIXTHgMQiEr4DH
	756JYKA5oUfKL6EV2a+7iovaQvznIvU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=surk1BCLeF5avvHG1soFt6VKsUb3Tew+Oslt4WkzeFY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982544; v=1; x=1790587344;
 b=gvcCXz8OGYtJMrZKg6eGQrflPUdG4L1eQa3e/ha4/vQd2MBjhhFiWJhafmmMDHwfm8B81AbR
 5SyPg2zmaPoaeengg3pxFlxQhf6veQYbzKjXAldJoj/6/kL7Gr9Kvph+q+/k6AOsztjuo+BqIbM
 xDKM0K8jQD6wuw0vftZP49CA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ae900405219d419d;
	Mon, 21 Sep 2026 09:22:24 +0000
X-Mizu-Trace-ID: ae900405219d419d
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	oleg@redhat.com,
	tglx@kernel.org,
	david@kernel.org,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	will@kernel.org,
	boqun@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	pavel@kernel.org,
	lance.yang@linux.dev,
	mhiramat@kernel.org,
	pmladek@suse.com,
	longman@redhat.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	mark.rutland@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com
Subject: [PATCH v4 04/15] mm/memory-failure: convert process iterator to for_each_process_rculock
Date: Mon, 21 Sep 2026 17:20:50 +0800
Message-Id: <20260921092101.89285-5-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 338EB20007
X-Rspam-User: 
X-Stat-Signature: 46o4bkr8u8qb73gwdqwrxdojib95qdou
X-HE-Tag: 1789982545-267015
X-HE-Meta: U2FsdGVkX1/MiKBw6VKzlA6nHbA2rSdOYzdRO9Z42nn2J8YHFeoMpkiyyW4+MNScumnKUYxxWj4ErZJyU2lfx2f6HppDT8OIUefuuRwB99Y3lbpNiWkRwaemIFqngIYpuR6j3e+gcBb6/kt5jJXRZ+6U3+p3pmerxWOlWVwfYq422Wza+a4alWbo1FbD0PYXbdEkclKpbl9DXCMaOTDTQFP/zr3hLS+xBpewPt54L1yAnoj65wG8fpM15i71gnuoFyEih8Abn1aDe5gIgJfODJXo+lzHYXj7vZDFzmGd6+9oRDw2dtxLX+e7ZK2EHPy8mOv64Z+BxTulgOtBb/PaFgDs+mige7ZczoJZCQPmfqT2mDcoD91Z5mW3UV4I2624jz3+GMVdEliLvkDJiNXx9VUzoJWdjJujsdgDzC/vT+YtF3Xr3doomg1XSfDs1Qf3dJPloIs6XGBEWvDGTWGaRfxAlT72BV7cMWAvgV0juvr00JmYyDFv/+525YPjy5xvMvcomWWogAsVOMrLmePJWg7F8JQ8yQF72SGcMXwHISEvp2hX8JJUJFCk9eO+Uis3ps/NWYvoEQmOvbQZTVJHZNWmDQYDDhFdgYMnJXRQIEfYp3/5ASHvKdDy1Ebl1hCQS7nquxc0W5R4IlRgBFFUrbcbBh6ghL8HHtJGHqGGFKRzYwln0CULiYSudbXvN3+bG8aTIcH1WbyoqjQ9MkQL8LOJn4vWRuGzYCIFzw6LCh0rOJ/KS/46kx2O16tiaBSiz4YqlwEA52lVsU+dySrykaz0R4EEOkeSJ1h+CMeUMrnxpGOKVFnhY+Xbd2OCo07WKNf1W+1mi3rkChiP+EUsLVM+N2SDV2FVVMQSvQWNfmzi3ltkDal/nOTVxaHyA9jWdOK3KAJfusEJ4YmnA61C23GeoUWqBzKScTk/b34fxQsRzbnu32h7IwVTo5m230BiO/Gva2RLcyBBWhoLhms
 gTNVsTw2
 9LORNeTSjozCaZDDHfekc5QgkZgHtwppOgacebq54qLQ21h2h+KJaii7DtD8nRH++4gqfsix1oHH7ILp5ztaf2/6S1/FCr+K2urYXLvfZrBqv23KowHZPRqxGHDRBQbvp2DJ5UZsVNIML5HMfc6JLN+KMo5f77PuUpk9Tc51L6I/AvgyC3xCG3AwLMhBPEX7P0jKUxVZW29YucRdy+9cbEjzmmFLlURYEgWmEvMggCr2DV/DK/Igr1w8BqUIdOXsDZ6zQmLRq09EMPmsrHJtLFtcbpfsEk9QOXNP2oWidfFGDFnRxvJVI2ce/aO21IEu9D0XSpCKuzj6+2emGZTGPfEcdzkmpl0Xu+5ykH6bGnQVPuQ4u2/egKu3vIlbXTiEONdBbeQ2xa0podJX0L3XEWX3Pwz6XS5BvoghZqIAePRO3M/ADrCQCwJPkZwtya/EWzU1iHwIlOCqQYnsysI2acEq2DOXIBL/PItPiSeyhJ1c1lfM+swQDNkRmyOVZEEG9tC3JtczoZUJqx4n1nhza7KckTvk7mTtzu01/vAg/IgpgnRU/ml6tr9BFIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
with for_each_process() loop in mm/memory-failure.c with
for_each_process_rculock(), which scopes the RCU read lock to the
loop body via scoped_guard(rcu).

In collect_procs_file(), the page_pgoff() call now falls outside the
RCU read-side critical section.  This is safe because page_pgoff()
only reads folio->index and does not traverse any RCU-protected
structures.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory-failure.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba..7d93deb1f7b3 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -555,8 +555,7 @@ static void collect_procs_anon(const struct folio *folio,
 		return;
 
 	pgoff = page_pgoff(folio, page);
-	rcu_read_lock();
-	for_each_process(tsk) {
+	for_each_process_rculock(tsk) {
 		struct vm_area_struct *vma;
 		struct anon_vma_chain *vmac;
 		struct task_struct *t = task_early_kill(tsk, force_early);
@@ -572,7 +571,6 @@ static void collect_procs_anon(const struct folio *folio,
 			add_to_kill_anon_file(t, page, vma, to_kill, addr);
 		}
 	}
-	rcu_read_unlock();
 	anon_vma_unlock_read(av);
 }
 
@@ -589,9 +587,8 @@ static void collect_procs_file(const struct folio *folio,
 	pgoff_t pgoff;
 
 	i_mmap_lock_read(mapping);
-	rcu_read_lock();
 	pgoff = page_pgoff(folio, page);
-	for_each_process(tsk) {
+	for_each_process_rculock(tsk) {
 		struct task_struct *t = task_early_kill(tsk, force_early);
 		unsigned long addr;
 
@@ -611,7 +608,6 @@ static void collect_procs_file(const struct folio *folio,
 			add_to_kill_anon_file(t, page, vma, to_kill, addr);
 		}
 	}
-	rcu_read_unlock();
 	i_mmap_unlock_read(mapping);
 }
 
@@ -635,8 +631,7 @@ static void collect_procs_fsdax(const struct page *page,
 	struct task_struct *tsk;
 
 	i_mmap_lock_read(mapping);
-	rcu_read_lock();
-	for_each_process(tsk) {
+	for_each_process_rculock(tsk) {
 		struct task_struct *t = tsk;
 
 		/*
@@ -653,7 +648,6 @@ static void collect_procs_fsdax(const struct page *page,
 				add_to_kill_fsdax(t, page, vma, to_kill, pgoff);
 		}
 	}
-	rcu_read_unlock();
 	i_mmap_unlock_read(mapping);
 }
 #endif /* CONFIG_FS_DAX */
@@ -2288,8 +2282,7 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
 	struct address_space *mapping = pfn_space->mapping;
 
 	i_mmap_lock_read(mapping);
-	rcu_read_lock();
-	for_each_process(tsk) {
+	for_each_process_rculock(tsk) {
 		struct task_struct *t = tsk;
 
 		t = task_early_kill(tsk, true);
@@ -2303,7 +2296,6 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
 				add_to_kill_pgoff(t, vma, to_kill, pgoff);
 		}
 	}
-	rcu_read_unlock();
 	i_mmap_unlock_read(mapping);
 }
 
-- 
2.25.1


