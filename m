Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 144CCCD8CBF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 01:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1078E0011; Thu, 13 Nov 2025 20:43:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8678E0002; Thu, 13 Nov 2025 20:43:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DE0B8E0011; Thu, 13 Nov 2025 20:43:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18B628E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:43:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A0D81A0218
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:43:03 +0000 (UTC)
X-FDA: 84107514246.28.649F187
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id EC473100003
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:43:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IS+Zbf2B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763084582; a=rsa-sha256;
	cv=none;
	b=yUTfLY2RjbiV+6u16+PXbFUf8el4bd5lLwsecDxZVURX9cFotiTK0K0DsrEQbEIiXQ6hNx
	e7yKLQ9LUHrWk0jfZW+JB8xrdbUm8aTpvC86+331TsTdsvl3IeIivcogc/9i9Ls769Qk3Q
	ft2CczOzKsAY87WUyBcFRiBgdn4ci3k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IS+Zbf2B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763084582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IuHTiVk16FNrVyP3pvF2tStE26owMiMpD6cUCyTAlSA=;
	b=oBCOZeYWw/BJcFXMpeHCALPgBfJrMfzEsQgTYE8lEkhwDkBw9tEP8fFwenwvcSerQS9GX6
	PMRFTduygVOQuUEsdx69Son5a+dBILjXM+A6aixcRMZPhnKkdLqiRyGOnagx2K6gXGYk/R
	mxB5O57hKxq+NgUXKGZ9v1h1Tyd2Q10=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 44C1F600CB;
	Fri, 14 Nov 2025 01:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A071CC4CEF5;
	Fri, 14 Nov 2025 01:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763084581;
	bh=aRE+wMnR2pS1uJvM8oQeGCIiCMvzPKaWlWT5NwcMf4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IS+Zbf2BOHCCtzc1IhDP4Cfa5hYLs1/tAaydWZPryWHjdiF+3LRrkbsKOkoBRGXM2
	 uyvnHggyYOKUDY9KfuROn6dFHzdWHSU4ciT95BNQh1fIhx9/IJP1Db6zzsY8vc/M6K
	 Mv2e7njpt5367w0T1pOMZgewma4iVQfeGalzRLQ5N7sKgvDaxGc2FOKd179R5V2P0h
	 OVlAWk6aMfsgwcEu1tRjAyw1h+VohQmoBDlLE8jH69HFntnt21qiQTz0HZV75jWuKr
	 19IwAxko9fHO+rCVsfUqAo77X6v02NB6byt7snP2hdhu62GDiV/lHVnrxfL5wv2Lau
	 +P7dtW7kJtWNQ==
From: SeongJae Park <sj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Fan Ni <nifan.cxl@gmail.com>,
	Gregory Price <gourry@gourry.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Raghavendra K T <rkodsara@amd.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	Wei Xu <weixugc@google.com>,
	Xuezheng Chu <xuezhengchu@huawei.com>,
	Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	damon@lists.linux.dev,
	Honggyu Kim <honggyu.kim@sk.com>,
	Yunjeong Mun <yunjeong.mun@sk.com>
Subject: Re: [Linux Memory Hotness and Promotion] Notes from October 23, 2025
Date: Thu, 13 Nov 2025 17:42:54 -0800
Message-ID: <20251114014255.72884-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <d952a84f-332e-8f7a-4816-2c1cbd8f5b00@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC473100003
X-Stat-Signature: itq1nir93ibs3ahh6e3zzyzfwhkbbquc
X-HE-Tag: 1763084581-486476
X-HE-Meta: U2FsdGVkX18qeyiG0+2fcqTbUWkHIgM1ep+PWtEB+kZiT6zVgQekQH1p7obZNu7ILGB+sgmI2XdICL3FhTJdCNdnc9kSNBdDt4Bx9mhLgmtxN/r5n82uXfphjtl7UhYIlXXhv244SBYfToNUwlTCpEPPRPfUctym6wodEQatVQ9BHq/54dfGaEElvQRauZG9gyX4Q6u6r/SVC9MbUmQOLgqBC+IwTzp4SEQy43OL7voOHlpiGLPqM8SJwmljzM5mg9bC29UHtSRrd2nW9S1bVwIzgnM94WPbOgN2LLGJpqV5TJGMJXh/uIEdMTbxP5k1TwskA9W49vZ4fOnXeu1ZsHc2zgzmEkC9UH5bD5Mk/k6eyrcis1XmMck6cue+CUnErrVtvZF1EEM8bka7EXLl+tnCvtNOTKhu9sZwTkwO3NYOkloNlpVXzsP5XkwI3Fgq48FeEreK2KWOUrAze2ts9Q8G+qc/9qScREPVDsrsvfTAn9+HirB9DuaUALNxHDpS3K740Qx9mh/LzVFwXkwM/VvA9jSOB4itfRqJ85YhC6wZrbwqnKRFz1a0dipjpNhkt5C/SgI+88xJ4NRsAxPhk3gYNKjAlGORxV9RA38aMazjYNGUinVpJFzHiQ01YSv4XqiDstRrst90z3qIpQ6+Ow5MddFRJe9lvbrc2c4XjFuuJntmhBOwaQG5sUQWVc/2f1O/cTkArmAilKkKNv9/m+8BFntBx3C/LVFNoXH1QFzLU35l4aAo6I9RBiH3hWeQivg9cAKNSLke4OQeNM/IoNO6RloXJo6/2MXpqvlZNhPf68gSw/GP68/kp/1BTu6L0KBRrT/SO2ESxONWXQfj0o7z4jGjQcUZTssRrV5UqAXU05FyCPvc/BtzMKTuKHFNF3bW8PnsDV3lIKr7ChLeYy/FjcWbDhxUv86g8Y0lfhq8I/PHUicedd2SwHF6gT8w6xigPlk+K8zUNHQdHfA
 eN6nmEpN
 C9DE/bFL29lePfNMqzvc1QDaeDoH3wLDz0Wb8EE0fIIPPlM7cODxoU/B1rXu1o8y17NKP6s7rpQZx8k1ShabNBbi9wRBMEmUWzerwCNg1eSohOKgKnvY9qAjH7BwuHPYa99W9fhanSh57uGK6JMzz4p42szA0iLfcosGGmtyGM5Rh5wwXxEjUG14GdkMPxDGy6vAddXUeviKDSljckWFEQW3sM1XP7EycxCBGHFdeAQePoohqH3nrsd0RhA2+ez77qn5Tt6lK0qWHWrTa9PPyaQbzUcvSsOl3pJb2b/CjBjrgJpv8TIfiMaOIAiE0jPQfpXS3bkzj5E9IiHFBxutGYgZRzRYCYfVaEAJvptOykpH/VkBiVo/kl4UxTdh2a5aQcGgAKAGuxKXqberaxh5+C9L1lJFr755H4BR0n+g9FNVsqTp1YbhQBENGYFWD59SeGXhQlFh9/adm5ThDFyFVsS6E0/XygLtGLVcq7m4ziNXDWYwUO0quDZ2i2bu++/4S4O8DUNYVYs1NqCu/vU/QJ+dGvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc-ing HMSDK developers and DAMON mailing list.

On Sun, 2 Nov 2025 16:41:19 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> Hi everybody,
> 
> Here are the notes from the last Linux Memory Hotness and Promotion call
> that happened on Thursday, October 9.  Thanks to everybody who was 
> involved!
> 
> These notes are intended to bring people up to speed who could not attend 
> the call as well as keep the conversation going in between meetings.

I was unable to join the call due to a conflict.  This note is very helpful.
Thank you for taking and sharing this note, David!

> 
> ----->o-----
> Ravi Jonnalagadda presented dynamic interleaving slides, co-developed with 
> Bijan Tabatabai, discussing the current approach of promoting all hot 
> pages into DRAM tier and demoting all cold pages.  If the bandwidth 
> utilization is high, it will saturate the top tier even though there is 
> bandwidth available on the lower tier.  The preference was to demote cold 
> pages when under-utilizing memory in the top tier and then interleave hot 
> pages to maximize bandwidth utilization.  For Ravi's experimentation, this 
> has been 3/4 of maximum write bandwidth for the top tier.  If this 
> threshold is not reached, memory is demoted.

I had a grateful chance to discuss about above in more detail with Ravi.
Sharing my detailed thoughts here, too.

I agree to the concern.  I also heard similar concerns for general
latency-aware memory tiering approaches from multiple people in the past.

The memory capacity extension solution of HMSDK [1], which is developed by SK
Hynix, is one good example.  To my understanding (please correct me if I'm
wrong), HMSDK is providing separate solutions for bandwidth and capacity
expansions.  The user should first understand whether their workload is
bandwidth-hungry or capacity-hungry, and select a proper solution.  I suspect
the concern from Ravi was one of the reasons.

I also recently developed a DAMON-based memory tiering approach [2] that
implementing the main idea of TPP [3]: promoting and demoting hot and cold
pages aiming a level of the faster node's space utilization.  I didn't see the
bandwidth issue from my simple tests of it, but I think the very same problem
can be applied to both DAMON-based approach and the original TPP
implementation.

> 
> Ravi suggested adaptive interleaving of memory to optimize both bandwidth 
> and capacity utilization.  He suggested an approach of a migrator in 
> kernel space and a calibrator in userspace.  The calibrator would monitor 
> system bandwidth utilization and, using different weights, determine the 
> optimal weights for interleaving the hot pages for the highest bandwidth.  
> If bandwidth saturation is not hit, only cold pages get demoted.  The 
> migrator reads the target interleave ratio and rearrange the hot pages 
> from the calibrator and demotes cold pages to the target node.  Currently 
> this uses DAMOS policies, Migrate_hot and Migrate_cold.

This implementation makes sense to me, especially if the aimed use case is for
specific virtual address spaces.  Nevertheless, if a physical address space
based version is also an option, I think there could be yet another way to
achive the goal (optimizing both bandwidth and capacity).

My idea is tweaking TPP idea a little bit: migrate pages among NUMA nodees
aiming a level of both space and bandwidth utilization of the faster (e.g.,
DRAM) node.  In more detail, do the hot pages promotion and cold pages
demotions for the target level of faster node space utilization, same to the
original TPP idea.  But, stop the hot page promotions if the memory bandwidth
consumption of the faster node exceeds a level.  In the case, instead, start
demoting _hot_ pages until the memory bandwidth consumption on the faster node
decreases below the limit level.

I think this idea could easily be prototyped by extending the
DAMON-based TPP implementation [2].  Let me briefly explain the prototyping
idea assuming the readers are familiar with the DAMON-based TPP implementation.
If you are not familiar with, please feel free to ask questions to me, or refer
to the cover letter [2] of the patch series.

First, add another DAMOS quota goal for the hot pages promotion scheme.  The
goal will aim to achieve a high level memory bandwidth consumption of the
faster node.  The target level will be reasonably high but not too high to keep
head room remained.  So the hot pages promotion scheme will be activated at the
beginning, promote hot pages, make the faster node's space and bandwidth
utilization increase.  But if the memory bandwidth consumption of the faster
node surpasses the target leevel as a result of the hot pages promotion or the
workload's access pattern change, the hot pages promotion scheme will be less
aggressive and eventually stop.

Second, add another DAMOS scheme to the faster node access monitoring DAMON
context.  The new scheme does hot pages demotion with a quota goal that aim to
make unused (free, or available) memory bandwidth of the faster node a headroom
level.  This scheme will do nothing at the beginning of the system since the
faster node may have available (unused) memory bandwidth more than the headroom
level.  This scheme will start the hot pages demotion once the faster node's
available memory bandwidth becomes less than the desired headroom level, due to
increased loads or the hot pages promotion.  And once the unused memory
bandwidth of the faster node becomes higher than the head room level as a
result of the hot pages demotion or access pattern change, the hot pages
demotion will be deactivated again.

For example, a change like below can be made to the simple DAMON-based TPP
implementation [4].

diff --git a/scripts/mem_tier.sh b/scripts/mem_tier.sh
index 9e685751..83757fa9 100644
--- a/scripts/mem_tier.sh
+++ b/scripts/mem_tier.sh
@@ -30,16 +30,25 @@ fi
 "$damo_bin" module stat write enabled N
 "$damo_bin" start \
        --numa_node 0 --monitoring_intervals_goal 4% 3 5ms 10s \
+               `# demote cold pages for faster node headroom space` \
                --damos_action migrate_cold 1 --damos_access_rate 0% 0% \
                --damos_apply_interval 1s \
                --damos_quota_interval 1s --damos_quota_space 200MB \
                --damos_quota_goal node_mem_free_bp 0.5% 0 \
                --damos_filter reject young \
+               `# demote hot pages for faster node headroom bandwidth` \
+               --damos_action migrate_hot 1 --damos_access_rate 5% max \
+                       --damos_apply_interval 1s \
+                       --damos_quota_interval 1s --damos_quota_space 200MB \
+                       --damos_quota_goal node_membw_free_bp 5% 0 \
+                       --damos_filter allow young \
        --numa_node 1 --monitoring_intervals_goal 4% 3 5ms 10s \
+               `# promote hot pages for faster node space/bandwidth high utilization` \
                --damos_action migrate_hot 0 --damos_access_rate 5% max \
                --damos_apply_interval 1s \
                --damos_quota_interval 1s --damos_quota_space 200MB \
                --damos_quota_goal node_mem_used_bp 99.7% 0 \
+               --damos_quota_goal node_membw_used_bp 95% 0 \
                --damos_filter allow young \
-               --damos_nr_quota_goals 1 1 --damos_nr_filters 1 1 \
-       --nr_targets 1 1 --nr_schemes 1 1 --nr_ctxs 1 1
+               --damos_nr_quota_goals 1 1 2 --damos_nr_filters 1 1 1 \
+       --nr_targets 1 1 --nr_schemes 2 1 --nr_ctxs 1 1

"node_membw_free_bp" and "node_membw_used_bp" are _imaginary_ DAMOS quota goal
metrics representing the available (unused) or consuming level of memory
bandiwdth of a given NUMA node.  Those are imaginery ones that arenot supported
on DAMON of today.  If this idea makes sense, we may develop the support of the
metrics.

But even before the metrics are implemented, we could prototype this for early
proof of concepts by setting the DAMOS quota goals using the user_input goal
metric [5] and run a user-space program that measures the memory bandwidth of
the faster node and feeds it to DAMON using the DAMON sysfs interface.

Implementing both the memory bandwidth/space utilization monitoring and the
quota auto-tuning logic on user-space, and directly adjusting the quotas of
DAMOS schemes instead of using the quota goals could also be an option.

I have no plan to implement the "node_membw_{free,used}_bp" quota goal metrics
or do the user_input based prototyping at the moment.  But, as always, if you
watn the features and/or willing to step up for development of the features, I
will be happy to help.

[...]
> Ravi suggested hotness information need not be used exclusively for 
> promotion and that there is an advantage seen in rearranging hot pages 
> based on weights.  He also suggested a standard subsystem that can provide 
> bandwidth information would be very useful (including sources such as IBS, 
> PEBS, and PMU sources).

If we decide to implement the above per-node memory bandwidth based DAMOS quota
goal metrics, I think this standard subsystem could also be useful for the
implementation.

FYI, users can _estimate_ memory bandwidth of the system or workloads from
DAMON's monitoring results snapshot.  For example, if DAMON is seeing a 1 GiB
memory region that is consistently being accessed about 10 times per second, we
can estimate it is consuming 10 GiB/s memory bandwidth.

DAMON user-space tool provides this estimated bandwidth per monitoring results
snapshot with 'damo report access' command.  DAMON_STAT module, which is
recently developed for providing system wide high level data access pattern in
an easy way, also provides this _estimated_ memory bandwidth usage.

[1] https://events.linuxfoundation.org/open-source-summit-korea/program/schedule/
[2] https://lore.kernel.org/all/20250420194030.75838-1-sj@kernel.org/
[3] https://symbioticlab.org/publications/files/tpp:asplos23/tpp-asplos23.pdf
[4] https://github.com/damonitor/damo/blob/v3.0.4/scripts/mem_tier.sh
[5] https://docs.kernel.org/mm/damon/design.html#aim-oriented-feedback-driven-auto-tuning


Thanks,
SJ

[...]

