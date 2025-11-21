Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16DCACFA761
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21CA46B0095; Fri, 21 Nov 2025 05:09:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CED06B0096; Fri, 21 Nov 2025 05:09:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0959E6B0098; Fri, 21 Nov 2025 05:09:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E4AA56B0095
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:08:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E2161A03EA
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:08:59 +0000 (UTC)
X-FDA: 84134190798.22.8342D44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id DE242140008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:08:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=OE+Qdh+3;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf23.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763719738; a=rsa-sha256;
	cv=none;
	b=39EITO6wJAVIVSZ6BxCvYlbx7p6MwKnu6F60sXFe2GhcgoS0Nv0r3AHK8/iVYXjKj1tunM
	+a2KlSbOOnlByLqFMlMrFUwXv+Zv3z5luuAfkkE46GC5DQJDg6p5viZDcliAEmlxojTSoU
	sfm0Kh5PiAjVikjF+qO31iSZozrjhYU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=OE+Qdh+3;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf23.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763719738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=UcgRnCditBv2eJwMDHOifbkjHe6XRimmMmhDcR5tyHM=;
	b=I4DBeInOh+0hOwoNg9JJzKi61tiiWXc2CrRuDDZCeIyQuLGCH+7oLddGlEBuS3jN2imziX
	ntguQluEoFZksg9CWDZtrZEj0aFNKkFstEjx3oru39ExGUZcY0D0Btm7PeRfXI4ik1jG3V
	J/R3DOpku3gTcEB7ffwZZKrtEO6DaHI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F283142DB7;
	Fri, 21 Nov 2025 10:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E453C4CEF1;
	Fri, 21 Nov 2025 10:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763719736;
	bh=teCSbMiSab38p9A+cMQaGZJt+rU0hFJrpyjDOOXXwF4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=OE+Qdh+3HqBWvJcV0dSE/w5mnSLQodC0WE+vsT+llF41uCBKpRGuKVVll5tOJUYaJ
	 be+QsuitoPEoBT22J5IDxblWcRGEXkgZQ1y3eyMdDAzzBSDyuhpWYCLP14sdqJ2vaE
	 g525VcmKtzZ9jN+Gns6vYgQ9zcnVjUSxfwqodSMk=
Subject: Patch "mm: memcg: change flush_next_time to flush_last_time" has been added to the 6.6-stable tree
To: akpm@linux-foundation.org,bagasdotme@gmail.com,cerasuolodomenico@gmail.com,chrisl@kernel.org,corbet@lwn.net,ddstreet@ieee.org,greg@kroah.com,gregkh@linuxfoundation.org,gthelen@google.com,hannes@cmpxchg.org,ivan@cloudflare.com,lance.yang@linux.dev,leon.huangfu@shopee.com,linux-mm@kvack.org,lizefan.x@bytedance.com,longman@redhat.com,mhocko@kernel.org,mkoutny@suse.com,muchun.song@linux.dev,nphamcs@gmail.com,roman.gushchin@linux.dev,sashal@kernel.org,shakeelb@google.com,shy828301@gmail.com,sjenning@redhat.com,tj@kernel.org,vishal.moola@gmail.com,vitaly.wool@konsulko.com,weixugc@google.com,yosryahmed@google.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 21 Nov 2025 11:08:43 +0100
In-Reply-To: <20251103075135.20254-4-leon.huangfu@shopee.com>
Message-ID: <2025112143-mummified-sauciness-e731@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DE242140008
X-Stat-Signature: 1m3wx5td4594ay3dtc5nndx5wmnpmhe1
X-Rspam-User: 
X-HE-Tag: 1763719737-87344
X-HE-Meta: U2FsdGVkX1/yzINkX0SNvkuoE0k3QeYlkG6ocdeJeJdKGAL/Mt2vfKywlBkmty8pNKCjaWXh11+OlWP5UfRgm6av19puectFI/vURQuZA42DZxv8+sVcUfcQXJU+MiMcuEtSA50JIGJFNdteGJwTUbPDBT+ZJFm4GqZQnMrFY590xNePzaJuIJgNbRO4Wj+ACJSVzYm9T54dtpRhD2FqKpZfSJEwzteKvNQzkWuB9GgpbwSyILBEAROEeQ4xFLaJHf6nMdaj9x8HXzeNYBse5OGaEt/Bhd45P/eHo5fJvcf0zVNzbbeakSpKP9JagMUvn8Xqxb4Rx4HmRiWdRUgdo66EojLPG6FvuP5bKLgEvh0fIsc31KGIU7OavKsJuFhTbkfoSXmtMLRWTMGDBAu6WCUzKR8pp0j8SlFEfHqF979q/rDZaMaIPraXTb29g3ZkMRvZR8CeTfQ9YG84mQmafyI6cc5Ej6n9k25b9lDt5r2DfGMSDdTrty8y5SMd4fiATqe3hDIpOoxz8PMjA78DdYVyA0dGAhczCmy5hMhKUt/RQaXMIdCf4TkOh/02K4McIBrF3VoulqpUpwqqca0oe0Tm0S6c2czxBQOcx0eNHXrDyw+Jovyt7kMzOoXpqO8g9BTfqEFDoHAtEVjxFrbkpU7Qe9p3sxl6mVC9Iq0vB/IoBr38s5WKhc5tF1E8IXzzzb05v+T3IlymVf0/W6PDB4VUHvYqd6Y62BZtHZNOVZgvuuGRQAA2TYDzUTEQUoGeWfGZo5lD+IslmbSwLvN7yg4DdcsFBFshUCM1g8adNfoRbs8oojV/O7LNdHXvrZPU4bnyWTdl4EJerhzbWWhBNNH+UEfz6EHMKSuSkouj+Obvb8i1X1If8NR9jt4l3pAns3+aXLzy/2HMsY62CnXvaiGugZL5gC8P+Y5Zjan+wvvVqGbw4GZCvuI0tXE4pNLy5+XrhY2Os7BjZMaRgJh
 ufN+qDPQ
 lWAd0o91N3AFF2uU/yz23mfnqAGbx3XaLI1QYs9Y3Y9qyr2oyeWSf39ARBhO2slOozZ4tjr+fc8+4Rv4f+fgJpnDbUy7rRCbj/I1BUbXUF/Twc12FonHZe9LO7Vvdhfqv3Pwy24SaxH6q7Y6pVLjXI5K9RYBakUUmVwTuUbz5cgYm102TTnJCWFuVIL55NbzI9ur5MIxlh5m4hstgSLEydpO+8+eOnAcrpaqoLuDpzfO72juEsGM9zJfg+W3WRGCzbv9HumQ7urdTczTlSER93vKVue4pkRvc3SIpsm0BWD6rhl57MjzpyyZCFpgjozhpjJ8jbUpitYM7cIyQURwwEEFdX3rTvqvzphfPeevMYRNr/kHj8U3wuBUgxgARhOEyK41Qzeik8HN1SNLdcTm0XL/PhOcKj9+MdqDIjxZljvD2JN/PwB9Ou+Fe0k/lqUiXvIa/ibQ+Da8UztY2rLwBWVlqptABmAWvgEiYyRPHOtdfoVqQeFdP79aiiKclbA79EwQOBgXZTmN0gHwO8z4HBHl1uMlKZcYkJE7DQIOOhTJBvCKQdKfnlpvcLrP8VCbs+RPW/7A0NBglK7grlYJAS6wpLgeenDkEKXa2AxcsN4EtXTAnqjGvg8etAUoGVlB+G7Y38UEOgjd4/sVhshbhlPyS8fsTfLEsdjFHyFZj2UYm9cXSmMSNGEsEY7ZAFBKI+OLjmhmPHRl/ZqrKnOVRu9y2GH4WRM5RuiHFhxktAuh5kCSnAo8JIynWW/bdCWG5rbwKKPOG6r8tPSaVE9nyjiRARUPCSJB/qgiyeXZoLBOS9H4ni/eHVzmK44xo/iqDtxyC//rQVM/kfDplcprsnTDqokyisQnK/xTW2h549FImA5VgbBd5v9rCZGP/y8PWZuHNMZk+RBy7Xo55+UjAJvpEfgzTVdg1TsVlOpv6kNir6xpeb/4CNvdPNTVR9cZ/EY4gxCOfxh1qX1y1PYuS1JrB5X/l
 0cvRgILk
 OiPg1WZCYfmGUqWPBvG85QIHPwYLIDS52Pmweod/prx34IfUpARc8ng9fysf42PuV21ozYZvhDMsBLI/5p2EOvcRtBS/V/TgXdydzrxv7VBiJ4+p0h/eS1VN94qTBgq9/0sBD5m2I2XGiFDnpm1nuN9ehYa2XG8c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: memcg: change flush_next_time to flush_last_time

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-memcg-change-flush_next_time-to-flush_last_time.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From leon.huangfu@shopee.com Mon Nov  3 08:53:16 2025
From: Leon Huang Fu <leon.huangfu@shopee.com>
Date: Mon,  3 Nov 2025 15:51:31 +0800
Subject: mm: memcg: change flush_next_time to flush_last_time
To: stable@vger.kernel.org, greg@kroah.com
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org, vitaly.wool@konsulko.com, lance.yang@linux.dev, leon.huangfu@shopee.com, shy828301@gmail.com, yosryahmed@google.com, sashal@kernel.org, vishal.moola@gmail.com, cerasuolodomenico@gmail.com, nphamcs@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chris Li <chrisl@kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>, Greg Thelen <gthelen@google.com>, Ivan Babrou <ivan@cloudflare.com>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, Wei Xu <weixugc@google.com>
Message-ID: <20251103075135.20254-4-leon.huangfu@shopee.com>

From: Yosry Ahmed <yosryahmed@google.com>

[ Upstream commit 508bed884767a8eb394640bae9edcdf082816c43 ]

Patch series "mm: memcg: subtree stats flushing and thresholds", v4.

This series attempts to address shortages in today's approach for memcg
stats flushing, namely occasionally stale or expensive stat reads.  The
series does so by changing the threshold that we use to decide whether to
trigger a flush to be per memcg instead of global (patch 3), and then
changing flushing to be per memcg (i.e.  subtree flushes) instead of
global (patch 5).

This patch (of 5):

flush_next_time is an inaccurate name.  It's not the next time that
periodic flushing will happen, it's rather the next time that ratelimited
flushing can happen if the periodic flusher is late.

Simplify its semantics by just storing the timestamp of the last flush
instead, flush_last_time.  Move the 2*FLUSH_TIME addition to
mem_cgroup_flush_stats_ratelimited(), and add a comment explaining it.
This way, all the ratelimiting semantics live in one place.

No functional change intended.

Link: https://lkml.kernel.org/r/20231129032154.3710765-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20231129032154.3710765-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Tested-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Chris Li <chrisl@kernel.org> (Google)
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -590,7 +590,7 @@ static DECLARE_DEFERRABLE_WORK(stats_flu
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_ongoing = ATOMIC_INIT(0);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
-static u64 flush_next_time;
+static u64 flush_last_time;
 
 #define FLUSH_TIME (2UL*HZ)
 
@@ -650,7 +650,7 @@ static void do_flush_stats(void)
 	    atomic_xchg(&stats_flush_ongoing, 1))
 		return;
 
-	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
+	WRITE_ONCE(flush_last_time, jiffies_64);
 
 	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
 
@@ -666,7 +666,8 @@ void mem_cgroup_flush_stats(void)
 
 void mem_cgroup_flush_stats_ratelimited(void)
 {
-	if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
+	/* Only flush if the periodic flusher is one full cycle late */
+	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
 		mem_cgroup_flush_stats();
 }
 


Patches currently in stable-queue which might be from leon.huangfu@shopee.com are

queue-6.6/mm-memcg-make-stats-flushing-threshold-per-memcg.patch
queue-6.6/mm-memcg-change-flush_next_time-to-flush_last_time.patch
queue-6.6/mm-memcg-restore-subtree-stats-flushing.patch
queue-6.6/mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
queue-6.6/mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch
queue-6.6/mm-memcg-add-per-memcg-zswap-writeback-stat.patch
queue-6.6/mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch

