Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40A45C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 23:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8576B0088; Sun, 27 Sep 2026 19:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43DD6B008A; Sun, 27 Sep 2026 19:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B456B008C; Sun, 27 Sep 2026 19:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9B16B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 19:21:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAD9D1A0AA3
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:21:44 +0000 (UTC)
X-FDA: 85261116528.03.90542E2
Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
	by imf08.hostedemail.com (Postfix) with ESMTP id 66C65160005
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:21:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=p6j5AQQo;
	dmarc=none;
	spf=softfail (imf08.hostedemail.com: 23.83.218.248 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790551302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SwQbYI+bY99g1ejEPX/a+Ge6mlBgGLkJ4XTFloG11TU=;
	b=YnPpsKlqTwx8GZ5BMhCrH7DXQ9/MaUcga4rs51jGgg5JtHKS+XZFeWu/YZL0Cy9r4IhKhX
	mWjku01DBapTLhQT+f0/ezToi4L21AULUh4eXiLa42gPFV8R6BtQbWXX/TL5ngEP9yW/MT
	GjLjvFKBdoOIXcxTj0461m6wBas87pg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=p6j5AQQo;
	dmarc=none;
	spf=softfail (imf08.hostedemail.com: 23.83.218.248 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790551302;
	b=CJrdozOvVCb00DrhD9bvFfDw8q40I9QL7N5TPrlspOFgkWpcr2r1aLK2o77KP8VVwfL2C2
	IPYBPX+2h7srxyWN1hKN0Fo3Q669zlDuzzi75yXnvv4/OaHCSEhnPFbGjo3zA1p20aanow
	pAIdjyjVlUF9e4Vw64gfmSXTnm3wgvU=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 02DC47A04F3;
	Sun, 27 Sep 2026 23:21:41 +0000 (UTC)
Received: from pdx1-sub0-mail-a257.dreamhost.com (100-96-11-224.trex-nlb.outbound.svc.cluster.local [100.96.11.224])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 5627A7A1F7C;
	Sun, 27 Sep 2026 23:21:36 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Wiry-Chief: 41dddb1b6fc693b1_1790551300781_4061377477
X-MC-Loop-Signature: 1790551300781:2423337548
X-MC-Ingress-Time: 1790551300781
Received: from pdx1-sub0-mail-a257.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.11.224 (trex/8.0.2);
	Sun, 27 Sep 2026 23:21:40 +0000
Received: from offworld (unknown [172.58.116.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a257.dreamhost.com (Postfix) with ESMTPSA id 4htL6j5995z104l;
	Sun, 27 Sep 2026 16:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1790551296;
	bh=SwQbYI+bY99g1ejEPX/a+Ge6mlBgGLkJ4XTFloG11TU=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=p6j5AQQoTAl8TyeHmGBrv2YM0bPu6H+StLIwctD/vIjwYiSb42R592+joK0nxu6AM
	 EOJR0qlV+n/6qaLGP5z+3HT1aGKis5bYz92NORjbsvFbY1m3Gi950JrqDM4RMDDHii
	 /L+mgEQZlNAK0bEw65bJ1OTeqoc09dp2cs45IbQW2MAnlcNwyTeHTzn/Huqi9lPqwK
	 6j2yi0CnX448/5EdNKGPuM/MW2fXTqBRq+/nQLodmFFXikbAP8EFCzZJgy04WXdhXg
	 87uVIlmGqC2Xw5EoBS1hBELXVXwQM6/XL/0zMFvjruvmnWLu4nJYU2njoeIKM8wuhs
	 GyQyMHiHmTx5g==
Date: Sun, 27 Sep 2026 16:21:30 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Bharata B Rao <bharata@amd.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com, gourry@gourry.net,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, nifan.cxl@gmail.com,
	xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
	kinseyho@google.com, yuanchu@google.com, balbirs@nvidia.com,
	alok.rathore@samsung.com, shivankg@amd.com, donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Message-ID: <20260927232130.smxstw7f474k2qcl@offworld>
References: <20260911210859.1359875-1-joshua.hahnjy@gmail.com>
 <f871efd2-06b4-493f-87cc-919b6e0945c0@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f871efd2-06b4-493f-87cc-919b6e0945c0@amd.com>
User-Agent: NeoMutt/20220429
X-Stat-Signature: 1qc76nmjbuoaoo5j31m9y53o3ck3jkzs
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 66C65160005
X-HE-Tag: 1790551302-704494
X-HE-Meta: U2FsdGVkX1//2xOFzTlQ2rgUfuS/R2QyZ8h8/WoyymIpiMtXEFTnHSmfbiuMrJ+jEyqsh3O21m3vZ67mFwJdHVnIljta6vFWYAHcbLJW/BZYscP7OE7rC0Brhbqqg1Ngu6haAAFy15dWmyfWfx/6r7ARAeB9VB94UC/8KBKbGuXI18glnmIwxxMH6N2lXu3BOYocxq6XKef0wH3bh+scal8oLQSDecb0z/SjW0UqJ6y3c7SmcIw9clpk7sX1ow448e/CcxfVpr+DtAQSjwNXptiDNr8e5yRWmVRnooY9mOonP6gN9ls+V2uX1/IV/tyGeJAGjkRv7DrJWg67XZAGiHkzncBQkqvEDVhY6vXXXj0bMKd097VTASfOfhfVIFxHNJjvAnoVo1M4O/DXg2tD7/etCNa7hN8oe2q4dUCdYZ31norZBVOn4AFQvzIjflBsVUeXIjrhzqsKri35vqqhL4newV/94h5r18smocdQP+LV5F0hiOASvLUaRk7cxhAo2kp/Rp+QPsCVBbwHuyZVY8ErQ49C8mAknycPELldZYS8ZcN4S5Ojmak/I7In2VbjUFZbmkLf9AspGIgjcM1q+HxLU6gwyk/2VBrIBAAIuA4+6t+VdT4QGin/YMZV1GXyIbdxyLlg2/V+9cAJ3g6JwJMHtIGEKFRQa6MhHwxsh0ocXklBXETwGlcbdnbPVjo0cscSwYGK/uS98E3jmJVpEZMgts/vLyK/yjuaLpZ/iyYOzWuZyXvc7mtQw28dZS5SSMs6vi0xO1jEu3xeWf44WY/Kqg1iNrSvh26QomcbVUbZahj4YsWkLMLmW0X2r4D+02zqmDQ5ala8kpqNMCBTz737YEDqPtKYoc9DQlUBzPxxJ0Zuwq+hXSa1lrGq+PpLoRN9eWNnnYCjVI8Op6wa5y5FnP/jsI4fLB7mtN1DvjQoDg6PCHyXxDxUv3l+s6+LifEqYwpzp91O9LLSi46
 mhJymFHL
 be/eD9GZ4QmL/wAg4rWcxCF+vEkJEKa+6SYe+bxHnNrN64w3+uJZqiedfao2Xx9O/CMLH0TjeioW4+Aq60Rqn/EsniqP3TLAxirJU/appgH4JwuFkBTMlzPat1GZu91sHP9zLTa0Rm5WxDZM6Os2I3c+BGM5fHYQnxk4gIvmH1XVi4qjd5UUNkXPwjV2egO92388WXMCnA+dtTaET/q4wzXhW5KTxBDfkLKEy0Ub09MhLXdlweCmxZ8I3LwDIns/KpprAwaiLwCpLly2LAErVCFkOwEof8rr2bJGqmc3E4007dPG6PKtebUlslYCU3yvUs436V6Q6P1WXLW06nrzmIjuJBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026, Bharata B Rao wrote:

>On 12-Sep-26 2:38 AM, Joshua Hahn wrote:
>> - I also found a bug where the kmigrated thread isn't created for nodes
>>   that are onlined later after boot, like CXL nodes that get onlined
>>   with memory later on. I've been using a small hack commit in
>>   pghot_memhp_callback that just checks for the MEM_ONLINE case and
>>   spawns a kmigrated thread.
>
>I will take care of this scenario (CXL node online after boot) in my next posting.

I was also running into this for chmu integration. I have been carrying the
below in my own testing, fwiw.

Thanks,
Davidlohr

-------------8<------------------------------------------
diff --git a/mm/pghot.c b/mm/pghot.c
index c7f523a61683..2f1e16e5091d 100644
--- a/mm/pghot.c
+++ b/mm/pghot.c
@@ -602,6 +609,18 @@ static int kmigrated_run(int nid)
  	return 0;
  }
  
+static void kmigrated_stop(int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	struct task_struct *t;
+
+	t = pgdat->kmigrated;
+	if (t) {
+		kthread_stop(t);
+		pgdat->kmigrated = NULL;
+	}
+}
+
  static void pghot_free_hot_map(struct mem_section *ms)
  {
  	struct pghot_hot_map *hot_map;
@@ -707,6 +726,58 @@ static struct notifier_block pghot_mem_notifier = {
  	.priority = DEFAULT_CALLBACK_PRI,
  };
  
+/*
+ * The first memory block of a node is onlined before the node gets
+ * assigned to a memory tier (memory tiers react to
+ * NODE_ADDED_FIRST_MEMORY at MEMTIER_HOTPLUG_PRI), so at
+ * MEM_GOING_ONLINE time for that block node_is_toptier() still
+ * returns true and pghot_online_sec_hotmap() skips it. Backfill the
+ * hot maps once the node tier is known.
+ */
+static void pghot_alloc_node_hotmaps(int nid)
+{
+	unsigned long section_nr, s_begin, start_pfn;
+	struct mem_section *ms;
+	struct page *page;
+
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		ms = __nr_to_section(section_nr);
+		start_pfn = section_nr_to_pfn(section_nr);
+
+		page = pfn_to_online_page(start_pfn);
+		if (!page || page_to_nid(page) != nid)
+			continue;
+
+		if (rcu_access_pointer(ms->hot_map))
+			continue;
+
+		if (pghot_alloc_hot_map(ms, nid))
+			pr_warn("pghot: no hot map for section %lu on node %d\n",
+				section_nr, nid);
+	}
+}
+
+static int pghot_node_callback(struct notifier_block *self,
+			       unsigned long action, void *arg)
+{
+	struct node_notify *nn = arg;
+
+	switch (action) {
+	case NODE_ADDED_FIRST_MEMORY:
+		if (node_is_toptier(nn->nid))
+			break;
+		pghot_alloc_node_hotmaps(nn->nid);
+		kmigrated_run(nn->nid);
+		break;
+	case NODE_REMOVED_LAST_MEMORY:
+		kmigrated_stop(nn->nid);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
  static void pghot_destroy_hot_map(void)
  {
  	unsigned long section_nr, s_begin;
@@ -891,6 +962,11 @@ static int __init pghot_init(void)
  		if (ret)
  			goto out_stop_kthread;
  	}
+
+	ret = hotplug_node_notifier(pghot_node_callback, 0);
+	if (ret)
+		goto out_stop_kthread;
+
  	pghot_sysctl_init();
  	pghot_debug_init();
  	pghot_src_enabled_init();
-- 
2.39.5


