Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5881C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16A36B0098; Fri, 11 Sep 2026 03:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC74E6B0099; Fri, 11 Sep 2026 03:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92616B009B; Fri, 11 Sep 2026 03:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87D8F6B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:59:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E383C4012A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:59:08 +0000 (UTC)
X-FDA: 85200730776.01.F15D2AA
Received: from mta0.migadu.com (out-88.mta0.migadu.com [91.218.175.88])
	by imf25.hostedemail.com (Postfix) with ESMTP id E6A57A0008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:59:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VMFbb681;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.88 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6EWZS7NVvULYrLMEpMpH4Unk//Ya1/mz4DW05XFSgo=;
	b=bxGSSdmNguEthesXcPS3xAS5rv7TuuhrpanEFVa20r2I7Otvec2WtkxTrK83hs3egyrlcA
	rl96npCfFy+aw3NIs1hrVfjBuOAvbNWmXXW1KSinXT4NTXs6LkfNx6OLtj1QQc1u6KtxaC
	s6YO9JGFoLmIWcpr1oJDl6CEi0+hImk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113547;
	b=1lCHoTvXUJVle+vZHm4e44dDxW851pw9i+zb0QMPKapYlw1OFgZpqgEXbz/Y1tOArW+ERG
	UtV7g4Ev1VKTAF9KsXEKan+sCzuZ8WG3IQajR5G68Ier/OP7WCKcY6NdPP4y8TLZGdHFwJ
	SKECCEVdJYQtsVLjifUCu2E2eL7BXQU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VMFbb681;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.88 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QXWV2YjR1N2qilXRn4ZL7vqePEkKN4kK8nW2DqNMaW0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113545; v=1; x=1789718345;
 b=VMFbb681nsr3Q2UeYWmN12jBTTR+wN3QxH7ZniVkfk9Pxn4IGGhxdxSxhdNej97M2YWbwsHS
 Atr1+MiFXn8CdACLwAr3gmcBMDF9nck0ER4klm1CoC7Hef3votFxB7a7njSLRrATAh6LWW6JVg2
 UR8kA0nzR/cspdFLDgo8PXjc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 70c9cc29d1278767;
	Fri, 11 Sep 2026 07:59:05 +0000
X-Mizu-Trace-ID: 70c9cc29d1278767
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	oleg@redhat.com,
	tglx@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
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
	babu.moger@amd.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v3 03/15] mm/ksm: convert process iterator to for_each_process_rculock
Date: Fri, 11 Sep 2026 15:57:48 +0800
Message-Id: <20260911075800.491472-4-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: knfqoac8eqz9987zxzdx8iu81sbuc5wo
X-Rspam-User: 
X-Rspamd-Queue-Id: E6A57A0008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789113546-502709
X-HE-Meta: U2FsdGVkX1/8VF4zSUgKqFtyAMAq0WvRxqTT0JglLKX5OX2TEdXnwGTm97mAOnMEHpmPN+eVU2xZnSJ64+mal7ofTlGeUMZVB+Phnv3Ccqgdv1ygT2RZjXoKwVo34Evs+sd2ek7+SscYdjKxhP0FizkS90g5t1CtGQUoMZ4tAsfWdUO7ADo9A+vfs/ZFsdTP2ekZ3Xy2ri0kGmukc4t0O3Prbgeq2nXFUzY5id9woD7DB6TBpZwFsS4rUrI5J28uvs95M7k4aWYmqn/9P1z9eNcaOGKwIZmppFs7yEHYb1dNnG+oMIT3nW1KxJb65w+VGS5lvwjp441UD1zw8YY2CPiQCelGjzuO4z3A6GZyb47s4RPilvbTjqSxG5xcktgbWF+3PZhZ3ykzZtt9BYoYsCBAw8NE2znaD8yuSkok1gR9kE6XL4YrGSFeRW4nscGtuagVnxBom6jKg7Ji8LiNCjBggL0T0k8RkNURA8A9oG2kRHwCMKNZ6GD4Z/Yyf2KoBWxbo6L/GmtwjdOT9G+F9OtaornIJxgu2BmfGfRPXQhbRVrdOF6aOylXTim85oC4HDtvTvYRbLWSpx1zI4F7oFqtig1rMj8JmXcC7i4bCuuP4Yhoc3FYWWi2aRZFJOBqJgnI6nloBuREEtLo+gN6plmUJSKRsWVlLVGWXZYSi1cPWv++hHnjzOAAX921j3BvqTN0z8MNFTbs/0j4YcmKNpuIQ7OnExP5+SkC2n3MUGlJuOB18NVj96b5qPlwBXJS6YxCxvqUGxvdFalN1stRV8C32aZvQpj97s/4NEl7fD0AabNBivQAZD4Lj2IE2auY8yTW69J2olVgsm/P8lMEJr445xNfOBicI+uRoLFdz/ywk/a8255I9WOceMZzrMUruSKwXpqoxGRiPHsUAqcREWhle1Sojg1a2PRZfXTXcLOHIhm6p2ahgJwPPz15L085QaVb3Puopr7YOuyyv3M
 nFrcgLpL
 gN6/Vlenz9fvThskHaeuACaYfdiDuBK9MSkOL/B6JM8r0ZqdBBNF/BgPGMV1alYYi2ZcV6vcCsQEACJx2Pl3aGVgSfvVvw6aei0LVfr3TfjzfSiZO+OGNUqIeGflw8CtE24U9zNXif6RaZmKpDyARZZt5HiaLoppztGw6TkYdPXeb2choD6yLnm47Pk4a/CtG0+cst4X+hnpieBDiRtLkjPGYq+srCOhGR+HggzYUNnq8u0bVH8it+WO48e/IJreIaUgnDW+74p4KrUPlxyFCPXMk4NYs2wdE9FUWj/gKVTHW/Br0LmntbGdD6N4QbK/QRJAYsRZAVCJQisEIQRaGcPZBDqSiEtQbJ0D0xMxFIsOeoJ1DWExgFMYRjnOR02b/xBJfeOZZDs16Laag3PQeyMDII3xiEmNZWphNHOO0chN1Veme3ePdGdO4WuYKMbK/uxMZhjNfXPbGLdmu7pFKeDMuYZ2wvWvSy7ShodFQqpxufoA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process() loop in mm/ksm.c with for_each_process_rculock(),
which scopes the RCU read lock to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Changes in v2:
  - Rename *_rcu to *_rculock
 mm/ksm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 49d48d1e0998..69d30e80a090 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3280,8 +3280,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 		struct anon_vma *av = rmap_item->anon_vma;
 
 		anon_vma_lock_read(av);
-		rcu_read_lock();
-		for_each_process(tsk) {
+		for_each_process_rculock(tsk) {
 			struct anon_vma_chain *vmac;
 			const unsigned long addr = rmap_item->address & PAGE_MASK;
 			const unsigned long index = rmap_item->linear_page_index;
@@ -3298,7 +3297,6 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 				}
 			}
 		}
-		rcu_read_unlock();
 		anon_vma_unlock_read(av);
 	}
 }
-- 
2.25.1


