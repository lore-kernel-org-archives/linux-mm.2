Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47DD1C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398CC6B00A1; Mon,  7 Sep 2026 04:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB936B00A2; Mon,  7 Sep 2026 04:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C36B6B00A3; Mon,  7 Sep 2026 04:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB9536B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:14:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75C58140680
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:14:32 +0000 (UTC)
X-FDA: 85186254384.27.57FEAE5
Received: from mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8D1AFC0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:14:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SeAR3wC+;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.45 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788768870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Z/JDj/+FquM4sgkiuxbykuJrVttrhO/76EDzlkEecg=;
	b=PRLvATNZSoLwMfhn7/lMxE1GHCBxig1C6W6nXrE1mKFj+APtJxPoHktNdRx2DWhRQW0NnO
	GDnm5+JbC4mpiwB/RclKylkMmfmRwfx/U/v9C/FZD4Z/YeT9xKjeMikvuMfztLz/emWr0Y
	hjg/Y3w2I7taXQ4sSRusXtssVQK1vBw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SeAR3wC+;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.45 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788768870;
	b=p41uZEyfGjpIWT68YMNjv+pItV72PLizxr6rg0oH61C8YnkMWM2u2h8yZiSrMwVQbJuiNu
	fzTMDMzgeEQ3b3hP123JIZoCgDpBtt4yV6vQOlZU8Iwf1L1Y2nKjb+GNzrzyUXI9dcQRq+
	sWZEgXzxCW8Z6eUXUhmyohPL8rqvBj0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6kM1mhZIXKCqG82ZEU8Zg2E+W3wWN+Noa5dvNKDqX9Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788768869; v=1; x=1789373669;
 b=SeAR3wC+S+BoPeOWhiwZ1ExCMOL33F8+JW2ndzYMAcibmCHzhG7YQeJV7yOSX1v3dDe2Cu0k
 c/2p9mcAhFS7cGoAYbno/JD4rakdHS0TJ2R6YM+dCd0+yYizFekwwdnC9p/wiK/vj3ehjrAonSd
 7lVtdFOsHjAxcrFMllVj4oNA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2731654c1e840797;
	Mon, 07 Sep 2026 08:14:28 +0000
X-Mizu-Trace-ID: 2731654c1e840797
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
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
	ljs@kernel.org,
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
Subject: [PATCH v2 3/8] mm/ksm: convert process iterator to for_each_process_rculock
Date: Mon,  7 Sep 2026 16:13:29 +0800
Message-Id: <20260907081334.1152889-4-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907081334.1152889-1-ye.liu@linux.dev>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: effpikj7ymhz13ckugty6y4b94gbsook
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8D1AFC0003
X-Rspam-User: 
X-HE-Tag: 1788768870-264251
X-HE-Meta: U2FsdGVkX187GWmwXHElvMMOK95Tk5yYt8R9wF90IocHAdL9KbXz6dKxLBn5X+2DCvbeFEky/LEq1kgweW2dtd0OdqjsMoytoPorjEbZa4TKYXJCuBea0c8rLYRI4Rc9bIt5OcEu8G2WwVl99LfZHIHxbFxI+1PCpgsIfJ9GtuMGg5meANI7T7vryLgRfk86JMMSvvNCFKCkz2dPgbKC0hXzBR3GVCHHctJTal6Q63xkEYf56A/MrIJ3rgrB664p2REt+v/dc6yMwfxAnZKykAwD3z+9kDPI3QJ7IiSjid+Qv58muf3c+cIy0s/b/c2S2UwvWrSSM+E+n7k7BHNSQ2zC1vpkxRtpKV1mqnG0BCdUXbzxa9S7jSwgzjimOox2KRYFMG07hLhfyeFy+Ijs3UO/4As12TIHiQILs9zozQE3d1ybspoZh5i53zPgeZkZiCfEC/w2s7I2yTSWpyCM3mvo33zQgulor9rtf6zhCLWn9SoQ9G1BaFoM2bDLEeGdDkKkf5eIRY0OVX2vvbLbREwFDNTZ5kgSDcScVy8+Wq7mSYb2HQySb7/vwZmBIhgJ/z/uCJxKbm8nZcqaM4LK3yBPJUAqYiKOguFa99fjTel/DW7jWwoBr7r5z5TI8JinVHdK+1kZJ2bJ9sH/beXr8ti+apvdAgrw6Y6rrJhrEp3aBTRk7+KKSll+IuASZc0O7My3xLy4v5Qucz2jydyqXAGNhlfJEC5c1nEituw+2gvaILrzzEe1VhtqFom4+JyLbm1XeDBThKtn2TsaDLloU2Bh8Qh3YWkfj2QQK5HvnwSuTuNuV8o/EI1kEkGbvVxw1kBe6wUGcm6hmISrBxl0XHQkqx2DW9zeKpK7iMqgcV95wJjCpBlHAdAcCqFV6GE9mkjdVzjUb28L0Mh0bcIeoozekfywAupu/sPgcLBbdki1KoJqOHJtcXOXD1IYJEf9mgxbJReBgVFH3mNyaxr
 co7kVnSy
 T5sMkiuuPJ/UsqoHJO6QDL09tScAPF7xV28P3sT0cZBCQ4kmNhv0afZ0LNGKc9LMIyYk6193vh9yJXSWNo5kOx2CJDcdbRPEMAoZpy2v+TYe+7qfva0BR8mahXvgFlASg6OD1e2YeVFQC2vQmn2e+h8Tdo1KtZDZTvESDx3Y8erNbnVOnZJqTIDs4GjYd8lbx/nnLFAGCzxSXdbpoXokwIXyY66ybEPJKduCRXnWTRy6WDM5baXPsehEsdHNVaMlne3nvoaU7G2BtVR1xuH/bpwq//Pmnu3C5CE/r03HRyf/15/T7cFphJOZQwSE2LyinxGjhqrIeRV9kay+dtqdOIEkw46h8VEtmfbMkz8WyeQjPvkmiHMeNm/aqvb9C6MXMmuEcDhVt85HK8qg3pXsrd/WpcnqOl1wvAeJV9GVYmKk+GVMMHa8MieBBhg==
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


