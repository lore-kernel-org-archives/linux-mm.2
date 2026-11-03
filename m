Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28FB606D83A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jazplH8Q
Received: by kanga.kvack.org (Postfix)
	id 7CD116B05B2; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706786B05B5; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE1B6B05B6; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 267716B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD121A0278
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:52 +0000 (UTC)
X-FDA: 85392000624.23.26BED70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 16115120002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jazplH8Q;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z1ZlDl54vy7oXT8lslczE9b+B9mUQeT7lKAv+hG8SGg=;
	b=G3sOALhcWhzTwGLCpK/BozjSfMnpgrqfXwtw/Tf7FbrFxlwcvEZf9vt7lBnpHnJGWHmvDJ
	SecbFpbgmCLGrNjoBZfGY0QELRM2774VEKN7ubGzLm3tyBrvxGYxupj4Ob7ghXUu5j35sn
	SAqlRzAX6ckK7ZNcq4dtav1zlZEuSGI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jazplH8Q;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667591;
	b=uiosZOfxbk++c6tNQq8DvOsY2SLNa4q/xlFu0wzVZPZeTpjBTtvu+ArdjodByrME2jyIG3
	8Jysk6nX71r8ZZ302HnVwvG4IOKhUiOPPcCH6Nsgq16OarsCpjWG5gK1DrMXDLOxSw01Ud
	3r9A910TbtyWDGmuxpFAE1h4NeksVGU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4404601EF;
	Tue,  3 Nov 2026 00:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066621F00A18;
	Tue,  3 Nov 2026 00:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793667590;
	bh=Z1ZlDl54vy7oXT8lslczE9b+B9mUQeT7lKAv+hG8SGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jazplH8Q4+HMTuyyZaVjxs1U13KiD2GjrY9G4xDQH56o3nlczZiz4JAVvot3IgDfx
	 GCC4Btk10IWcK+3iG78kQThpETV3woyhE4z8AR5Ir+Bu/peZQjRYsMXQeWjpNaGhOe
	 V8ApWwohjex7+gv2ecavvBmeoUPRolzmTvMj/tk2vrSK99tQMNHEGztUrpw9OYWj/N
	 sJzk/JJw1Jc0G38kEWTzEIEhLyYuwd25038XO+LqSvLnbfpGLLmIFw3mVAv5Cbbpo/
	 2fLZwdpN5KVpGtyZFY+WkCFggkPj9XCgsGZShw+N71ejt932frK+t4EquSnmiFv5IK
	 6oViV6BL0d+9g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Manuel Ebner <manuelebnerli@mailbox.org>
Subject: [PATCH v2 4/8] Docs/admin-guide/mm/damon/lru_sort: fix remaining grammar
Date: Mon,  2 Nov 2026 16:59:34 -0800
Message-ID: <20261103005940.91432-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103005940.91432-1-sj@kernel.org>
References: <20261103005940.91432-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4nspwnrbsfwzhkrwaki499sxqfm5twmz
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 16115120002
X-HE-Tag: 1793667590-509117
X-HE-Meta: U2FsdGVkX1/ThQH78OMqXKOWmV4UPR6MftSEiZAYDykaisuZ7hlC4QEWKYwey+MkAqVIxU1HJgQAKIYLT5xm0xnSpiw0b02XqpLjSRvNxd7JHtlv6UHRuqqQ0w0QRQgsFdC4zq/RwKgeW7KQfyQJhamr+wVJtcQVR/bRdSjd6RsZHDDqqRJd/eNETxPvYt5B3/GVgxRU7yu4vNKnxEFl0gOUkxv56ElTKKkwl+xnDqM1JfIpdQHgE4Z/2CWv5UgSEvRhgyJOl3XxP3JLWbSOoaFp6b8KQqpIrRa+zu12hy53vOouoiPyBkcntnzi/yj9CSfUBYFtlL1L0YxcyyYvzBkSxDvuQyPlNIySd1IF94EBm4PxZS5CHxszfKJRM8PRsN0R2YuDyMb2UN9l5wQC5/4CROL5utWIkMjnqmmz9VQvXkZV2idNNDDE8rWy7m9/i+61iJLHnnIKjfNZkZKRbHBWOZwGC47a9PJztXbEmSegp7M0I4AIcQ96bl0y7Ehbaex0L2bHGe+F9SJRkQoMmsVrsN5A9mx2DVKSEajnXbPu2AFNvtWq+B3YnWHqoEspPiL+STtHMIlIoiBy6/eNsmytjSBNBpzYrQixOhBhc9Nm2xfqp1uYcs0Vzkv90KZTf1nOM/riUN6vLulzwwyBZEHygYl7zLfljp5+B7yRNnxGHE+irdTSfyz7UFJstLzOnMpO7Lr4dskSvUwcUoZ5ATKvGj0PG6HGPbueUkBraiLlVnptPYQl/S5n4+mk6P+n0iiS9M11n9Q4iebLb5Fx9bNzc+jG55bJmNbtH+TAxZ943Qu+RzKSlfolLKnNli8VEhliTOTQ0m2E6+6B98LvqJ6w5s1lT/CFKTm6VVauq5bCtgJRevSe+qdD5RpZQzDZYuIj/zICXYnulehveYharz+e69w62yl4cyLM7yBRz6jQIQ/nT603uQ7S2q8iDg/3EHLbT8ArCGDLhdZm6z8
 qTIVXKvb
 e/wSb6Xip0XNoYmc4eyVNU02boxHm5uNJZVxGpfnUAWJDM5NRKV2dWG0ZjSg9ictmYEWvo8+vZX5bxTNNaeL+WtQdJ3GdNuLyHih9dFIdq4ubu1lotHo0s2scikRxyZCileB0osL212peq9CytDyUMPk83fyT+28+kYma4IRc4feZNjDjUNZlBCN22lqVjQkL19If+QnGYt7ZG1d42uz7V7oJmnd00qaNafd7lzLlDmVbu0pv0yyWOkhGx7Wni2Il9LNIoOXHljkVTjY1ouFYD+NEJ/MznIqNwH8FbnLUKQszJRawpFemu3ZxAUlh3GJr/Dilm/7ofDTVtB+4EHky26doB5Fhfe7/4EAoWuT6VKtFYvpuJ2i0qeiSLbHTsDt94ny75LU/2MWjqqSPnpoI/ejHgjVDcYZnvJqp3O8nR9URRer7Gd/kKXgFJxffACMobn6dgkahWQxyA+sFS2gTzxmtIpAX8w6ymG21DU6kUSQTVD3Gn1sFm55VhcnGvLBIR49xPqIcPCJYTFUxMry/AUwAjBpnfggnofJs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

Manuel's recent grammar fix for this file, now in damon/next, covered a
good part of it.  This should take care of the few mistakes that are
left, like "should automatically activated" and "Make DAMON_LRU_SORT
reads".  Rewrap where the lines got too long.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Manuel Ebner <manuelebnerli@mailbox.org>
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Manuel Ebner <manuelebnerli@mailbox.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 .../admin-guide/mm/damon/lru_sort.rst         | 45 ++++++++++---------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index aa4cc90ca57c6..6b2cdb48fabe6 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -35,7 +35,7 @@ deprioritizing cold pages on their LRU-lists.  To avoid it consuming too much
 CPU for the prioritizations, a CPU time usage limit can be configured.  Under
 the limit, it prioritizes and deprioritizes more hot and cold pages first,
 respectively.  System administrators can also configure under what situation
-this scheme should automatically activated and deactivated with three memory
+this scheme should be automatically activated and deactivated with three memory
 pressure watermarks.
 
 Its default parameters for hotness/coldness thresholds and CPU quota limit are
@@ -55,7 +55,7 @@ DAMON_LRU_SORT utilizes module parameters.  That is, you can put
 ``damon_lru_sort.<parameter>=<value>`` on the kernel boot command line or write
 proper values to ``/sys/module/damon_lru_sort/parameters/<parameter>`` files.
 
-Below are the description of each parameter.
+Below are the descriptions of each parameter.
 
 enabled
 -------
@@ -70,12 +70,12 @@ condition.  Refer to below descriptions of the watermarks parameter for this.
 commit_inputs
 -------------
 
-Make DAMON_LRU_SORT reads the input parameters again, except ``enabled``.
+Make DAMON_LRU_SORT read the input parameters again, except ``enabled``.
 
-Input parameters that updated while DAMON_LRU_SORT is running are not applied
-by default.  Once this parameter is set to ``Y``, DAMON_LRU_SORT reads values
-of parameters except ``enabled`` again.  Once the re-reading is done, this
-parameter is set to ``N``.  If invalid parameters are found while the
+Input parameters that are updated while DAMON_LRU_SORT is running are not
+applied by default.  Once this parameter is set to ``Y``, DAMON_LRU_SORT reads
+values of parameters except ``enabled`` again.  Once the re-reading is done,
+this parameter is set to ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
 Once ``Y`` is written to this parameter, the user must not write to any
@@ -87,10 +87,11 @@ active_mem_bp
 
 Desired active to (in)active memory ratio in bp (1/10,000).
 
-While keeping the caps that set by other quotas, DAMON_LRU_SORT automatically
-increases and decreases the effective level of the quota aiming the LRU
-(de)prioritizations of the hot and cold memory resulting in this active to
-(in)active memory ratio.  Value zero means disabling this auto-tuning feature.
+While keeping the caps that are set by other quotas, DAMON_LRU_SORT
+automatically increases and decreases the effective level of the quota aiming
+the LRU (de)prioritizations of the hot and cold memory resulting in this active
+to (in)active memory ratio.  Value zero means disabling this auto-tuning
+feature.
 
 Disabled by default.
 
@@ -112,8 +113,8 @@ Filter (non-)young pages accordingly for LRU (de)prioritizations.
 
 If this is set, check page level access (youngness) once again before each
 LRU (de)prioritization operation.  LRU prioritization operation is skipped
-if the page has not accessed since the last check (not young).  LRU
-deprioritization operation is skipped if the page has accessed since the
+if the page has not been accessed since the last check (not young).  LRU
+deprioritization operation is skipped if the page has been accessed since the
 last check (young).  The feature is enabled or disabled if this parameter is
 set to ``Y`` or ``N``, respectively.
 
@@ -125,7 +126,7 @@ hot_thres_access_freq
 Access frequency threshold for hot memory regions identification in permil.
 
 If a memory region is accessed in frequency of this or higher, DAMON_LRU_SORT
-identifies the region as hot, and mark it as accessed on the LRU list, so that
+identifies the region as hot, and marks it as accessed on the LRU list, so that
 it could not be reclaimed under memory pressure.  50% by default.
 
 cold_min_age
@@ -134,7 +135,7 @@ cold_min_age
 Time threshold for cold memory regions identification in microseconds.
 
 If a memory region is not accessed for this or longer time, DAMON_LRU_SORT
-identifies the region as cold, and mark it as unaccessed on the LRU list, so
+identifies the region as cold, and marks it as unaccessed on the LRU list, so
 that it could be reclaimed first under memory pressure.  120 seconds by
 default.
 
@@ -237,7 +238,7 @@ The maximum number of monitoring regions of DAMON for the cold memory
 monitoring.  This can be used to set the upper-bound of the monitoring overhead.
 However, setting this too low could result in bad monitoring quality.  Please
 refer to the DAMON documentation (:doc:`usage`) for more detail.  1000 by
-defaults.
+default.
 
 monitor_region_start
 --------------------
@@ -310,7 +311,7 @@ Total bytes of hot memory regions that were successfully LRU-sorted.
 nr_hot_quota_exceeds
 --------------------
 
-Number of times that the time quota limit for hot regions have exceeded.
+Number of times that the time quota limit for hot regions has been exceeded.
 
 nr_lru_sort_tried_cold_regions
 ------------------------------
@@ -325,24 +326,24 @@ Total bytes of cold memory regions that tried to be LRU-sorted.
 nr_lru_sorted_cold_regions
 --------------------------
 
-Number of cold memory regions that successfully be LRU-sorted.
+Number of cold memory regions that were successfully LRU-sorted.
 
 bytes_lru_sorted_cold_regions
 -----------------------------
 
-Total bytes of cold memory regions that successfully be LRU-sorted.
+Total bytes of cold memory regions that were successfully LRU-sorted.
 
 nr_cold_quota_exceeds
 ---------------------
 
-Number of times that the time quota limit for cold regions have exceeded.
+Number of times that the time quota limit for cold regions has been exceeded.
 
 Example
 =======
 
-Below runtime example commands make DAMON_LRU_SORT to find memory regions
+Below runtime example commands make DAMON_LRU_SORT find memory regions
 having >=50% access frequency and LRU-prioritize while LRU-deprioritizing
-memory regions that not accessed for 120 seconds.  The prioritization and
+memory regions that are not accessed for 120 seconds.  The prioritization and
 deprioritization is limited to be done using only up to 1% CPU time to avoid
 DAMON_LRU_SORT consuming too much CPU time for the (de)prioritization.  It also
 asks DAMON_LRU_SORT to do nothing if the system's free memory rate is more than
-- 
2.47.3

