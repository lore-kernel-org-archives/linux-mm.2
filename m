Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06FF606B9A6
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RlKF2zAV
Received: by kanga.kvack.org (Postfix)
	id C92CA6B05BC; Fri, 20 Nov 2026 13:09:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5CB6B05BD; Fri, 20 Nov 2026 13:09:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A238F6B05BE; Fri, 20 Nov 2026 13:09:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 637066B05BC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:09:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F03EF1A012E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:57 +0000 (UTC)
X-FDA: 85456286034.22.A074E6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C7D254000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RlKF2zAV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198195;
	b=pqrhggu4xxPWGbte2AlheJkb8R41y5NwUiHjk2aufyS6wzOJZWzN+X9pONN0x92UTepxr+
	dvWgry9RYR/3JlKShufEiOsHU9CxUYldKdaSkhQNv1cINHNu6VJWdUPRk8XdKRwOajMdEH
	ChSpQqRx45pYpP3fA/iXP3S9B14+REs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198195;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Im7ezlywxNUuwRgGis5+rWWOQyX3m2uPTqHdnIjcZAs=;
	b=WvdgHKEGvFdSr2hXQq3pcg80IpUe7KQGgY5yHZXGIgwkZkT0Xp1S5vE45sEX9g8hyVw+bw
	bJPqpT1oq50bgYrwv8kLcb24fvRqb/T6LR1qCflzCDokz9oJ3B7e2Er0PZ5bEZoOW+0oJP
	7jRjpEJcbOKNji3m3wKv+zCJOs+aP2U=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RlKF2zAV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60D26633E8;
	Fri, 20 Nov 2026 18:09:55 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198195;
	b=ZnTn4olhIMfTKOch1I7uT+MyQKIEpff9KQuVe4jZ7sMhQ240FJBMmBl/XNqWCsbE2OTy
	 e/6sjvviMy/Hk4xI1q+AsBvs2fysXDAkbvrh9AeTOrSpEpH3sXMhLWpljg5Hmrr6DCkSK
	 ebUAa0Wvgcw3iheHezOJbZSKKFNLNNEDg/IfTO642QkW0le98pxlU3n1CVPggfJkVJNEY
	 TyH+SZq0q3oKD+Ve4TpWQFn6z6usIMvexXVWn32hspKuzdQEAoMiWY5Qrez/oxAjTOIGP
	 GSNpWADrTnTaRJcwauZWkmxop7k6/RF+QzQybgr8pM6Daq1Eepdsecp/chz/nl2VzFA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198195;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Im7ezlywxNUuwRgGis5+rWWOQyX3m2uPTqHdnIjcZAs=;
	b=005bSvWt/CHrVc4o5R6UPnCD1Z9eZD9MRCCsgQb5Dw5eBcuHL278Os2UYZb2D3DU5q8R
	 IfB9jdeVi2gSoFsUpzpZdG7n+KhGMgQ98n4LG3KsXEKsJEYnGf7mug+OT5d5+vuP8qRdd
	 qgArhGv7rJrIR8eSAhI24yVQ3zg+P6DVdD23Y9jxJfIZ0JfaP1geOGMBP5kuWMz9F7+W0
	 qYuO/sjleVhFXKYBU3vpjuWUtIphCFEKYbWrL0sr4Vx1ahCFPQhDR/awttXd1VkoktVeZ
	 dpFhVmpw6EGgCtCfZRZep3WCHrwtxh7ny+sWx4Gb9R7VjXXDwgi8gD64jVvFdIjNSoA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BD15D1F01805;
	Fri, 20 Nov 2026 18:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198195;
	bh=Im7ezlywxNUuwRgGis5+rWWOQyX3m2uPTqHdnIjcZAs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=RlKF2zAVcq3I3QMrgNGuWt0XJVf+p0cRcd+r42sCLDv25kIQRGh7bYxe4rJCWuMjG
	 NBRiz/XDA0mZcB1eQBgDhWybdN0jp1HWQ2KdvI+R2jzsnWPEO4mYJufxyZ+JOcakmP
	 8whOo+b71zbxSYVRAguQz4qdrg4JJn1jI/6vYcbGxw+ZygP4RUpWGj7HM1QbvU/Xgi
	 18YJSAOf9NPTcXAiyI8r9Jccey5joOqFitVORARfaciTGRqEZtuK4KhD+AnsaTvZn1
	 H9Js+YwehcWuGc7sMMKFUdYLAKhin7EVD2nlG7PWwx8ISU+2XBmkGqwK8rzICJjzSW
	 JTeLIo482oWTg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DDC054B901;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:07 -0500
Subject: [PATCH 16/60] mm/oom_kill: compare OOM constraints against common
 memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-16-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1433;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=CGbgCesiUK7FaS3uE7XEsjS4RivbEoofszYkkl9tolQ=;
 b=Rl5iRdBywuqFmQMQRF7nrZzOaOma19N8ic11E9/UVk+2PB3MAEYUmgBsm8qCfHUD/luGjWSnn
 1y963MhGKdIDVXBwN1DmjehCfEvUCZJcZl0Bhfm95sNHcGlPv8/lJgd
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C7D254000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5in3rfi55198q7ia7uei1mzxhm1tgzfj
X-HE-Tag: 1795198195-663036
X-HE-Meta: U2FsdGVkX1/N+GgnEpPhAUCJwkFtKWQXUT3IgN7i35BZz4BlN3HUoer46X/kmt9ggnQcEcYYd9enwIRnlk9ACjUOLn8fqupcbAfwamjJ5v3wadtv3B+h3qOLr0UvP9fePdHLCxmKcTqG3WC0HWX9W6fTznuLhDgx6SHOY44DbrB5ovpSQm1PjP9y5fy7aE/ETKaqtyljtqlxQAGvcFTHrtvmsuAuTU2Qu7n5EHf+LYHCHLvARtBenVW2++Zd2HNabSAVPmwD949xYNr3d3Os4ksJILSrF/LV9F/NMR5pWgJq54CmxxAs6VkKoCb+UGs9g7TW+WSxusb6ne+D7S0eStxgcgp6/uyUOW1E/KAWOaxddjS1TIZUbe217CJlQ3sbP2tCULE/kRAEKSQVuFD3eE/8AitpSkHrUcE71akk685eFFcYEymbArBjkt95V+ABlmKK7brXySAaUtTCxqn1Lal6pASOqXhYm5mOkBKm7N/iBu5porBFuGnBlS15pYXgzrJ+qQ/6+OsHPhpAKHHlZDPuyTDmNaiOdTBMBB/snGOMyQjRzaP6JKkQVCoVl3XhqnPkBNVk0Oq97gy24hwbO99VgNnDzkCqC7ks/fFOgiHwAJO9Ism7Y5tUn7sekez97fPHya3tsPm7GA4ykKLaPEXnHKPclw2G4TEeGmaj/WdsSDS5T8etP2gSghcSI3D/cBHB/9rve15IUw45QAl8iF4CAwj3nw1FC6Dqq1QeciLLab7QZzBA3ipXhCQNvLL4GqPA3BCKBtZOnUTtjy/CQDjAzzGrR3UVEO+Ar+cWEvCaf+Knydh7JbbnijrplfCN22cARf9OWlPzcQTphU0KImqbpgaLHMkoU0JdS8UxS/6/RpLbqR+gMHhPWplvtlKBef+1wdEE46bMMhORBud7cwyov4mZyWFGGSIMrZt25x+t0/wvFA0yaV5ek8N2/eMdkxpMpOjzsAPUC70/mW7
 7KCjdGgc
 4wq5hH0BAcn2xCNZO/RU1uJJ+QAQsySaCG0+ZvFNbik/JjndSmI/ZCYMSzzUciMWuYHwnbNNZ0+zsjypeX/ZfrFtiBJRBjuCVIsQ0BW6UuFvYZQTN5+f3XVGKJCCvccDJfPUvG1WPDUkA90BS8sxvI5HvDfqx2R/qm0I58BqlN9TRzCb8su0QQzI8MwQGeqDo7AM43yxK9L++bRrReIRtqoedage5IUDrypS027OvhI5pTKiW43mtdu7FeJY61TAGpOQZ7ZrLKNcBckitI4KWLh83Auq7Yt+Iaq3Q2EY66tfbEM3RPmcrUqkLczs3/xhWtcJ1JfKhFyRBWfhTIFYwMGy6v+nV9xRnMua2wVmWl76daOeNKO91sXGGMbooJmfZ3SKRBAE/NnjKigU3Zi8kNzVHvPcExzQMtJLrwszq108Ea1BD9+HXmgomQEzgpCuupf4NTle0Po9kbqRzkHvh2AEY57USJSMfke7DZH9u0zfL74FK0Dr6JBxFFCDGpRfzoiEBQ32QM4zAl1cv99wkEl/7lhpYZDnHftEXV7gwFsvfc4tm+ma9FX1jVPp02MAc0krsKRtxXaQoiaTB+Ko89QW1jTIE75lnxeNzK3HRcuC+YPKtXMigSBbyfeL+qSbVTWB+YXefYc3sP4fnzLtz5Gh4hFm2s0BSDa10Pb3mhRORjQhdfIBxN2xupIP2eJrqLLvJ2uLRy/GiJfd4n5OpPcB1M1vcZfrlua15ww+/G9q2zngdjXX/UETDjtk1VPpobINDq/gjIR2s7TImJ49eLJeYTYO1A8b3Une83yzogfhmdFlij68CTUSDgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Ordinary allocations reach only common-memory zonelists. Compare policy
and cpuset constraints against N_MEMORY_COMMON, so nodes outside it
neither make an otherwise global policy appear constrained nor inflate
the constrained capacity.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/oom_kill.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5d48bd862c27..1ec22bdad1fd 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -274,9 +274,9 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 	 * get_page_from_freelist().
 	 */
 	if (oc->nodemask &&
-	    !nodes_subset(node_states[N_MEMORY], *oc->nodemask)) {
+	    !nodes_subset(node_states[N_MEMORY_COMMON], *oc->nodemask)) {
 		oc->totalpages = total_swap_pages;
-		for_each_node_mask(nid, *oc->nodemask)
+		for_each_node_mask_state(nid, *oc->nodemask, N_MEMORY_COMMON)
 			oc->totalpages += node_present_pages(nid);
 		return CONSTRAINT_MEMORY_POLICY;
 	}
@@ -289,7 +289,8 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 
 	if (cpuset_limited) {
 		oc->totalpages = total_swap_pages;
-		for_each_node_mask(nid, cpuset_current_mems_allowed)
+		for_each_node_mask_state(nid, cpuset_current_mems_allowed,
+					 N_MEMORY_COMMON)
 			oc->totalpages += node_present_pages(nid);
 		return CONSTRAINT_CPUSET;
 	}

-- 
2.56.1



