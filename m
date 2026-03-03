Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 840DBEB3659
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 03:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54146B00A8; Mon,  2 Mar 2026 22:09:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE816B00AA; Mon,  2 Mar 2026 22:09:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B8E6B00AB; Mon,  2 Mar 2026 22:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C06C16B00A8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:09:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 798AA1B81B9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:09:28 +0000 (UTC)
X-FDA: 84503271216.17.A4A1B4C
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 72BAEC0007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:09:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QyVeESPa;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772507366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SBs9bcabgCEvuY4u0v9/Zsg1qM7B1u6PtJQeoLsqsQQ=;
	b=LR8awPAmtG30GaxgoMimWwSDvVQ3Vc+BdObv3hQnzZ9OSV+4bzUVf7yZEoMxxW5GLC6qMk
	l1g7djJHUaOhcGbrNXk1BimO6jNnWSMoxlntjVdPYYvHVOIfPO/0BqH5lHnqbzxN+KXwGv
	0fhJlzm+JOEpSJqwgl7Dc6adSDRvTNI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QyVeESPa;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772507366; a=rsa-sha256;
	cv=none;
	b=gwg0Y/kQPBCFUq5p/JtRQrTb2TUdu+Dfny0vSjhdd+znuZWz9nuiIfYc07ncT3QCpQkNH2
	+G+PukvaEvB4xUq+mq8BKKq3j+DHFjo8izJhBmzzXnq1a51kOaZmm3ODPqt5FCiHSPhb5I
	zNtH7eAy+zwBT0Xbs0sNk1g4xQWaAt0=
Message-ID: <de1476aa-20a3-420e-9cd7-9238efd3c85f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772507363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SBs9bcabgCEvuY4u0v9/Zsg1qM7B1u6PtJQeoLsqsQQ=;
	b=QyVeESPaWFJLoQzS37FHot8bE0Mv+NxgIBjalY7avmEkv0ZeizppPT+OoVZJEzwHQOX2IT
	U3njDt7ffGXBk2bUNFimSYNg+4wknqLnu0vTTmgV+E782nA1Mhg9gqTLtOr3BeTQhLjTRB
	J/nsZ1VHUXl8ykXDxlffhIrVdjuTb7I=
Date: Tue, 3 Mar 2026 11:08:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
 usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <20260228072556.31793-1-qi.zheng@linux.dev>
 <CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: od7j1upamyga9d51h3t6xh11utdayoro
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 72BAEC0007
X-HE-Tag: 1772507366-56593
X-HE-Meta: U2FsdGVkX1+JrUE9kWQ1e1YNPgfF+tx0IyCjou6a4lyhdGNLZqeJzyMZUk3dYSw1u9y6Jizu0MlqDKJfTUsS3CAddYn3l+B1MYMFFeEgiA67dmcUlM73ssP/xEGtNA6fGCR47sIfqPEVTnXz8JoeFOUnvqo+M01Z4Zs1Csh0288rNUXNPSfZOTnimQ2rfZ0/JdHnpl/W8Mh0KC9jxxUtHOZ1QbYu0hjaBEqxd4M3gD1zBpVM1DUkgIMvzB2U1LBQhYQYrHx1zB1nVySRdw+a71RZYU09RWUG0L0cYyMTHE6cK7/sW+XBoU9rgbJ4Bh/iXMSvOBZKU94CbfMSpysp+OVGWAQUz3ywYN1g087WCpfBPIRrKBM0QSYEjNFV6rQo3FdiiK71mlj4XAhjQLHAj4V1UWNQsxFPVCcvAv/O7eU4XY41eW0W32Smu/gcVDBoj2yffnzsj+cEDrZFGj2fkrULJUsduxfxvu/TuiEZgDn+Kd5na3jNRfoey7KBB9zFimEhWEyzqiPP0dLzODtA4g1DxNbeD+iXAOqzn3xSoc7mjMVzc+E4JcZGAVIpbTS0KBkodDlK27E+JmBXxLssTFevjOC9mVvRTXTT04Nnlz8sbwm4Sig4cR2VbG9X9hUdUpoiq6bkW4OszTxFq20c9Sk1jLcoX1/kgVnUr8CRQSjZrrXsOZHwfSG9lfVdsOeMqTY3BDvfaq+KHO7qPzuoccl09Lllrl432wAGjLthxAHlXyPQ9WKoIwABzV2exu5jY6vdeV9ovkocODTyh+bcd8/UY0NweEDEce5WfP6C6V96wHpoS4qkmM7rVKXAN2pVltKtokaveoDW8IAyTe4q/1KE9SOyPqfAUTXStRwRgNudbQ7JNbvawo6pdg56zRMURPzgMjgAY2Dy3vno7b3dcVQUAVk3b5EiJpnyfjhOgEslgk1b+KfKBe7BX1gkNN4Yl8zhfZlkBNjhARkhzmI
 gJ3zQ+Tj
 EgedEhnroPn1CMYNmMjHk2iYZx3gsWMeRmet83hAAPCTZKwIqHzY1BHjWL/9DWyYF6SosooYayRMfTOELyGS/4kQOkrTdk8lTUxDz6IXfdl7SOoGR6CBLBN1LqFtfmiAlk5ELFNlUjvffKyfxtJkC6c48zRsHlA/LZsAg5nSzpOd3aAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yosry,

On 3/2/26 11:53 PM, Yosry Ahmed wrote:
> [..]
>> @@ -763,6 +851,64 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
>>   #endif
>>          return x;
>>   }
>> +
>> +static void __mod_memcg_state(struct mem_cgroup *memcg,
>> +                             enum memcg_stat_item idx, int val)
>> +{
>> +       int i = memcg_stats_index(idx);
>> +       int cpu;
>> +
>> +       if (mem_cgroup_disabled())
>> +               return;
>> +
>> +       cpu = get_cpu();
>> +
>> +       this_cpu_add(memcg->vmstats_percpu->state[i], val);
>> +       val = memcg_state_val_in_pages(idx, val);
>> +       memcg_rstat_updated(memcg, val, cpu);
>> +       trace_mod_memcg_state(memcg, idx, val);
>> +
>> +       put_cpu();
>> +}
>> +
>> +static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
>> +                                    enum node_stat_item idx, int val)
>> +{
>> +       struct mem_cgroup_per_node *pn;
>> +       struct mem_cgroup *memcg;
>> +       int i = memcg_stats_index(idx);
>> +       int cpu;
>> +
>> +       pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
>> +       memcg = pn->memcg;
>> +
>> +       cpu = get_cpu();
>> +
>> +       /* Update memcg */
>> +       this_cpu_add(memcg->vmstats_percpu->state[i], val);
>> +
>> +       /* Update lruvec */
>> +       this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
>> +
>> +       val = memcg_state_val_in_pages(idx, val);
>> +       memcg_rstat_updated(memcg, val, cpu);
>> +       trace_mod_memcg_lruvec_state(memcg, idx, val);
>> +
>> +       put_cpu();
>> +}
> 
> I don't think we should end up with two copies of
> __mod_memcg_state/mod_memcg_state() and
> __mod_memcg_lruvec_state/mod_memcg_lruvec_state(). I meant to refactor
> mod_memcg_state() to call __mod_memcg_state(), where the latter does
> not call get_non_dying_memcg_{start/end}(). Same for
> mod_memcg_lruvec_state().

Okay, like the following? But this would require modifications to
[PATCH v5 31/32]. If there are no problems, I will send the updated
patch to [PATCH v5 29/32] and [PATCH v5 31/32].

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e927530156fee..3d9e2cfad5b12 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -528,7 +528,8 @@ unsigned long lruvec_page_state_local(struct lruvec 
*lruvec,

  #ifdef CONFIG_MEMCG_V1
  static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
-                                    enum node_stat_item idx, int val);
+                                    enum node_stat_item idx, int val,
+                                    bool reparent);

  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
                                        struct mem_cgroup *parent, int idx)
@@ -544,8 +545,8 @@ void reparent_memcg_lruvec_state_local(struct 
mem_cgroup *memcg,
                 struct lruvec *parent_lruvec = 
mem_cgroup_lruvec(parent, NODE_DATA(nid));
                 unsigned long value = 
lruvec_page_state_local(child_lruvec, idx);

-               __mod_memcg_lruvec_state(child_lruvec, idx, -value);
-               __mod_memcg_lruvec_state(parent_lruvec, idx, value);
+               __mod_memcg_lruvec_state(child_lruvec, idx, -value, true);
+               __mod_memcg_lruvec_state(parent_lruvec, idx, value, true);
         }
  }
  #endif
@@ -831,14 +832,9 @@ static inline void get_non_dying_memcg_end(void)
  }
  #endif

-/**
- * mod_memcg_state - update cgroup memory statistics
- * @memcg: the memory cgroup
- * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
- * @val: delta to add to the counter, can be negative
- */
-void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
-                      int val)
+static void __mod_memcg_state(struct mem_cgroup *memcg,
+                             enum memcg_stat_item idx, int val,
+                             bool reparent)
  {
         int i = memcg_stats_index(idx);
         int cpu;
@@ -846,24 +842,38 @@ void mod_memcg_state(struct mem_cgroup *memcg, 
enum memcg_stat_item idx,
         if (mem_cgroup_disabled())
                 return;

-       if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", 
__func__, idx))
+       if (!reparent && WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat 
item %d\n", __func__, idx))
                 return;

         cpu = get_cpu();

-       memcg = get_non_dying_memcg_start(memcg);
+       if (!reparent)
+               memcg = get_non_dying_memcg_start(memcg);

         this_cpu_add(memcg->vmstats_percpu->state[i], val);
         val = memcg_state_val_in_pages(idx, val);
         memcg_rstat_updated(memcg, val, cpu);

-       get_non_dying_memcg_end();
+       if (!reparent)
+               get_non_dying_memcg_end();

         trace_mod_memcg_state(memcg, idx, val);

         put_cpu();
  }

+/**
+ * mod_memcg_state - update cgroup memory statistics
+ * @memcg: the memory cgroup
+ * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
+ * @val: delta to add to the counter, can be negative
+ */
+void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
+                      int val)
+{
+       __mod_memcg_state(memcg, idx, val, false);
+}
+
  #ifdef CONFIG_MEMCG_V1
  /* idx can be of type enum memcg_stat_item or node_stat_item. */
  unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
@@ -882,51 +892,6 @@ unsigned long memcg_page_state_local(struct 
mem_cgroup *memcg, int idx)
         return x;
  }

-static void __mod_memcg_state(struct mem_cgroup *memcg,
-                             enum memcg_stat_item idx, int val)
-{
-       int i = memcg_stats_index(idx);
-       int cpu;
-
-       if (mem_cgroup_disabled())
-               return;
-
-       cpu = get_cpu();
-
-       this_cpu_add(memcg->vmstats_percpu->state[i], val);
-       val = memcg_state_val_in_pages(idx, val);
-       memcg_rstat_updated(memcg, val, cpu);
-       trace_mod_memcg_state(memcg, idx, val);
-
-       put_cpu();
-}
-
-static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
-                                    enum node_stat_item idx, int val)
-{
-       struct mem_cgroup_per_node *pn;
-       struct mem_cgroup *memcg;
-       int i = memcg_stats_index(idx);
-       int cpu;
-
-       pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-       memcg = pn->memcg;
-
-       cpu = get_cpu();
-
-       /* Update memcg */
-       this_cpu_add(memcg->vmstats_percpu->state[i], val);
-
-       /* Update lruvec */
-       this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
-
-       val = memcg_state_val_in_pages(idx, val);
-       memcg_rstat_updated(memcg, val, cpu);
-       trace_mod_memcg_lruvec_state(memcg, idx, val);
-
-       put_cpu();
-}
-
  void reparent_memcg_state_local(struct mem_cgroup *memcg,
                                 struct mem_cgroup *parent, int idx)
  {
@@ -936,14 +901,14 @@ void reparent_memcg_state_local(struct mem_cgroup 
*memcg,
         if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", 
__func__, idx))
                 return;

-       __mod_memcg_state(memcg, idx, -value);
-       __mod_memcg_state(parent, idx, value);
+       __mod_memcg_state(memcg, idx, -value, true);
+       __mod_memcg_state(parent, idx, value, true);
  }
  #endif

-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-                                    enum node_stat_item idx,
-                                    int val)
+static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+                                    enum node_stat_item idx, int val,
+                                    bool reparent)
  {
         struct pglist_data *pgdat = lruvec_pgdat(lruvec);
         struct mem_cgroup_per_node *pn;
@@ -951,7 +916,7 @@ static void mod_memcg_lruvec_state(struct lruvec 
*lruvec,
         int i = memcg_stats_index(idx);
         int cpu;

-       if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", 
__func__, idx))
+       if (!reparent && WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat 
item %d\n", __func__, idx))
                 return;

         pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
@@ -959,8 +924,10 @@ static void mod_memcg_lruvec_state(struct lruvec 
*lruvec,

         cpu = get_cpu();

-       memcg = get_non_dying_memcg_start(memcg);
-       pn = memcg->nodeinfo[pgdat->node_id];
+       if (!reparent) {
+               memcg = get_non_dying_memcg_start(memcg);
+               pn = memcg->nodeinfo[pgdat->node_id];
+       }

         /* Update memcg */
         this_cpu_add(memcg->vmstats_percpu->state[i], val);
@@ -969,13 +936,21 @@ static void mod_memcg_lruvec_state(struct lruvec 
*lruvec,
         val = memcg_state_val_in_pages(idx, val);
         memcg_rstat_updated(memcg, val, cpu);

-       get_non_dying_memcg_end();
+       if (!reparent)
+               get_non_dying_memcg_end();

         trace_mod_memcg_lruvec_state(memcg, idx, val);

         put_cpu();
  }

+static void mod_memcg_lruvec_state(struct lruvec *lruvec,
+                                    enum node_stat_item idx,
+                                    int val)
+{
+       __mod_memcg_lruvec_state(lruvec, idx, val, false);
+}
+
  /**
   * mod_lruvec_state - update lruvec memory statistics
   * @lruvec: the lruvec

> 




