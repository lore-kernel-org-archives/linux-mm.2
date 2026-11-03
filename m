Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71346606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UWjpaNQo
Received: by kanga.kvack.org (Postfix)
	id C84BE6B05B7; Mon,  2 Nov 2026 19:59:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C35F66B05B8; Mon,  2 Nov 2026 19:59:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24176B05B9; Mon,  2 Nov 2026 19:59:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6C36B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:59:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1256B801D7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:55 +0000 (UTC)
X-FDA: 85392000750.09.7AEDA61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 605F3C0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UWjpaNQo;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U+/s7Vb6ZoZJ6uW3ceyKnu6jy4tym2GZzS23JZFD/TI=;
	b=vYoa7V0lYelZFaBLEvUmAIUNvuEiAu6e7sOREgrzPd6kB1fxHwSCMMqFS6Pyi3PjR/1sDl
	ILx3JLNc7KxOHXcAbTLPUpqZ0URP4wTxEvauRcXuY1UuZbe7uLe+6TvfonwJPZuL3Mk821
	yHt40SwK139Bacv5LZ8qZrYa5c6B9kA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667593;
	b=3GYuDrl7FgD/EI2NXSrhSxRylEqE8msxZeE21w53Sr43dbhX27Jw8T+oEx/yvRsjXGeLOe
	sD6Q3b3uN9R0eQb6FAlgVG65/YW1kq5XPy9Jh1Lla076W86DopUK7lVQHItrlMtz+GqjCj
	UQhJY4v5dWlgPTmSnsvxsPgAXI8n8U0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UWjpaNQo;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A6F3C43E05;
	Tue,  3 Nov 2026 00:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B4B1F00A1A;
	Tue,  3 Nov 2026 00:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793667592;
	bh=U+/s7Vb6ZoZJ6uW3ceyKnu6jy4tym2GZzS23JZFD/TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWjpaNQowfbD0Vr9Rqfp3WWh/eEkoo573HHDC4GEyaHcoDnyaWD1gx4XydqwYQGtL
	 JzjaII3d6YxhQYdBOXoqXrLrjmkIwPgrk3uEcuAGnBB7wBEQdlYLJDtrgL094RZggq
	 i0IiGGl+UR/kidKZjutj3NXc7xj1rW39loo3GmqtebQeUU3WuTa3Hen5TCR7OVdT0S
	 IBOsCKzTiZw5CZntoy/SG32ySxgasubhGHV4uN2LNnNOgzthrr1aZBRGL7kAqCKKZE
	 K5yuaLOE0vJt+TgpafXM7hPbpRNvXGC7GtUf2/1bmk48mRQSDBtoLUiQl2ol2aOgow
	 uaQLHrqs8QDOA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 8/8] Docs/mm/damon/monitoring_intervals_tuning_example: fix grammar and typos
Date: Mon,  2 Nov 2026 16:59:38 -0800
Message-ID: <20261103005940.91432-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103005940.91432-1-sj@kernel.org>
References: <20261103005940.91432-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wf7gasqf3odz143yijbttowt4frn3hem
X-Rspamd-Queue-Id: 605F3C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793667593-466459
X-HE-Meta: U2FsdGVkX1/yqcc+28NuwLp8LvpVTAmfDb4HeRP1TIeTdzd7nbH2r/P6lKWJ9NqBC24lGbCT1xGtY02FUVFtxfUscRKMQPkcSI0u72DqE8D+20NKRDHVX8lFfX3LvTAToWlul0O04RZaK87KWQp+lHY0k3DqK3udTiZK+IjQmDFPQTCxi5/8dnJul5DzCrTi/f2A+uIS48DdRReTD38a0x7qnLiJbxigGpI02Ozr6cK9vll4ODoLlCfDUNEuYC197Sm2L0N3BAowOmruVc5OD4PzhtCPHnz1uBjrdsOJDvhEyvTdr4yJ9ennXo9mn6vYpIXH4jMDRlM6qZ3smvLy7GL25zierWCT1YnRoUQ28LRVtwCHGHOvJu43nF8jcL49jGB4owP4SdB/E+7v9M49WCTalxLtlaA6SE2MD9br5ChHTJiafHvISrI/E6S1ouQiCNUlpIYSJW6O/rIytLUnwazFLOV2Kn9jFChq8IkRxNB4l4F3KjuIWhzD56poZfbKKAM/lnGWmIoZlBbXJJLuyAPCuzOJYwafP56lK6YLaVjbp24GTcxQbpaKOkhCpbZ9w7YYSGCK7DPV/IvwxgNYC4RkOj1L12BNKk4abtfOrgguoOts3pci3iCUYArCJ1FQRlC3O0/RglCqIB6p3Hd4Zavb6uq1BQO3HwGwyfst1Bo46+TdOPBcFSO537nAoI4oCBq7iPiL9/nZx7oj467R9sHqmsG1zPNPGp3OlEBdrXQ1Fnz+KlRospHPPvE6y1DryhTFlFaxdlZTOPpLkPQglqDDazA/HeT/cmT2I4pUVM+63hQKXvEKdIanE4OvKq/9KDGJi/bpgi5fRe/+rL7+3P14wZnEgYbZ5VGGKgl1TIlP3Mny7RHQz3EpJQQisTPCCSZuPBDa/NM+8imfinEFaGhI4T56Rc2rdxJmbpiS9HETo5EiJ10Sz6jm99eHDpf+2hDTivvo9twXdScVe+j
 rgFlhdj1
 AJE7Fz17mHFAmAo5rWj21slJ8oqoTlFxSnf8Ef+KsJ6FumPZ64OwNhmd513vdJSGrCD34Pi1s/mS22BxlL8byU8FbQjqTzvZGnqyKYkMWiozlT45PBsMd4rdbt9uqFXj9QrKyEFe1Cfr5zQPwUZJKlk41QkBYNgUkmaMQlu5T5YnQyLfGDR/0UuqIf8QPANbjQ/ETeNYkQTRdyVnv7uN8GHeHYUCh+ufP/dnBGgCHmwuNn8GxY0Q6+Jeq8QeEWkMv1q40x8yEllzaGN47TSfOxs4GZp+XjEfS3/akwzGUmpL6FeZt51DwQ9Dd3ulZ9YpPMFMEUrhZYUYnug0XuS2DNF7XiyrjutaVyrrXGIZZKpQ3CxPV659Au77/9MJvrVUQt6FexqL1bxeQMqaQflfPIdM1BUiz7TlJalNNN3eMMNqZ3enRsgkwIPVEO8JnjiDoHH8xIr+C+Xjx9yItoiQaFVbtkIToBvjc8z5RCNIFBaboKhLYxLOwgr9YkKKud+Dw0xbd7ibrYI3hx6q2oB1OBk6u3zofcD0Ie1lgnu5DWjMnYRBlYh9gcyaGs089a2dB1Ay8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

Fix a few typos, including "Moniting" in the title, and some grammar in
the interval tuning example.

"starts looking degrading" should be "start looking degraded for", as I
think the sentence means the cold region detection starts to look worse.
Rewrap where the lines got too long.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 .../monitoring_intervals_tuning_example.rst   | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/mm/damon/monitoring_intervals_tuning_example.rst b/Documentation/mm/damon/monitoring_intervals_tuning_example.rst
index 7207cbed591f9..367b031ce55a3 100644
--- a/Documentation/mm/damon/monitoring_intervals_tuning_example.rst
+++ b/Documentation/mm/damon/monitoring_intervals_tuning_example.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-=================================================
-DAMON Moniting Interval Parameters Tuning Example
-=================================================
+===================================================
+DAMON Monitoring Interval Parameters Tuning Example
+===================================================
 
 DAMON's monitoring parameters need tuning based on given workload and the
 monitoring purpose.  There is a :ref:`tuning guide
@@ -38,7 +38,7 @@ access-hotness of a region.  It is calculated as a weighted sum of the access
 frequency and the age of the region.  If the access frequency is 0 %, the
 temperature is multiplied by minus one.  That is, if a region is not accessed,
 it gets minus temperature and it gets lower as not accessed for longer time.
-The sorting is in temperature-ascendint order, so the region at the top of the
+The sorting is in temperature-ascending order, so the region at the top of the
 list is the coldest, and the one at the bottom is the hottest one. ::
 
     # damo report access --sort_regions_by temperature
@@ -56,7 +56,7 @@ list is the coldest, and the one at the bottom is the hottest one. ::
     total size: 62.000 GiB
 
 The list shows not seemingly hot regions, and only minimum access pattern
-diversity.  Every region has zero access frequency.  The number of region is
+diversity.  Every region has zero access frequency.  The number of regions is
 10, which is the default ``min_nr_regions value``.  Size of each region is also
 nearly identical.  We can suspect this is because “adaptive regions adjustment”
 mechanism was not well working.  As the guide suggested, we can get relative
@@ -91,7 +91,7 @@ aggregation interval.
 100ms/2s intervals: Starts Showing Small Hot Regions
 ====================================================
 
-Following the guide, increase the interval 20 times (100 milliseocnds and 2
+Following the guide, increase the interval 20 times (100 milliseconds and 2
 seconds for sampling and aggregation intervals, respectively). ::
 
     # damo start -s 100ms -a 2s
@@ -129,17 +129,17 @@ seconds for sampling and aggregation intervals, respectively). ::
     [50,400,010,000, 59,720,011,000)   4.000 KiB  |*                   |
     total size: 62.000 GiB
 
-DAMON found two distinct 4 KiB regions that pretty hot.  The regions are also
-well aged.  The hottest 4 KiB region was keeping the access frequency for about
-8 minutes, and the coldest region was keeping no access for about 7 minutes.
-The distribution on the histogram also looks like having a pattern.
+DAMON found two distinct 4 KiB regions that are pretty hot.  The regions are
+also well aged.  The hottest 4 KiB region was keeping the access frequency for
+about 8 minutes, and the coldest region was keeping no access for about 7
+minutes.  The distribution on the histogram also looks like having a pattern.
 
 Especially, the finding of the 4 KiB regions among the 62 GiB total memory
 shows DAMON’s adaptive regions adjustment is working as designed.
 
 Still the number of regions is close to the ``min_nr_regions``, and sizes of
 cold regions are similar, though.  Apparently it is improved, but it still has
-rooms to improve.
+room to improve.
 
 400ms/8s intervals: Pretty Improved Results
 ===========================================
@@ -196,8 +196,8 @@ good enough to make some meaningful memory management efficiency changes.
 =================================
 
 Further double the intervals (800 milliseconds and 16 seconds for sampling
-and aggregation intervals, respectively).  The results is more improved for the
-hot regions detection, but starts looking degrading cold regions detection. ::
+and aggregation intervals, respectively).  The results are more improved for the
+hot regions detection, but start looking degraded for cold regions detection. ::
 
     # damo start -s 800ms -a 16s
     # sleep 600
@@ -243,5 +243,5 @@ Conclusion
 ==========
 
 With the above experimental tuning results, we can conclude the theory and the
-guide makes sense to at least this workload, and could be applied to similar
+guide make sense to at least this workload, and could be applied to similar
 cases.
-- 
2.47.3

