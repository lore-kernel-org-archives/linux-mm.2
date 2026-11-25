Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17DE5606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 04:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jYILALBk
Received: by kanga.kvack.org (Postfix)
	id 14A626B08E6; Tue, 24 Nov 2026 23:32:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FC6C6B08E7; Tue, 24 Nov 2026 23:32:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C726B08E8; Tue, 24 Nov 2026 23:32:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD7E16B08E6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:32:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF148120CFF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:32:33 +0000 (UTC)
X-FDA: 85472370186.15.F77E1B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9812140005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:32:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYILALBk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795581151;
	b=b7tO5tmZMhnJ5i6FxuT89+UnX1L6mQyKGoHxLNQn+KQKm6EzwDZDKYKRh79M0o2nPuon0Q
	ICylV2D+3FyPcyswk5BAsiuQrKLlkZmi5iZ3buEUgwddBrXReN6+OqKI8mIerodAGsHRMN
	T93bOxE9Gdn7kfbNcQinwMvwo7cEExk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795581151;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7xv7NqRPboZD8n16IYobKNVKDgaIUvKlpeGZVo5xpek=;
	b=LJpJSjCF4VoQVkwJHtGHyCrdGDPq5bbe7I1Qaz5ZkPe0QVGeNy9ieoAJ2NztK+BF6k+DCG
	655gtDUapbVJWm8j2HIAXHVLCzv2QChSSqnjYLVzMssYELFwD4t3Is2irbkv2SMsE5JIeP
	2obSm4/BtW/ZfFc0FpimqhxUGIMZUVQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYILALBk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C7A061157;
	Wed, 25 Nov 2026 04:32:30 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795581149;
	b=hmcqr5LB+2LhCy8rDA4reEgZmoCWIJ8vjLKBVzqrzW0DLQmkdYuQJyFWvphxioYGHWW9
	 Cyp5R8zPSCKVzUCUh2pUXFVmBmCwmh4R/rzFV8moNFpOP/rHUuEfRdx3SGXXW82dqGzcA
	 8tLaYwm7Owdu06UiGWRg3+m2vyx64VWmfwfMmsTYMUksdi/yRQefBlTtS2OZEdDAfh8TO
	 FCd33FrvcPpusV24m2AIDBUUUMkZhV3RQCOZ2dZwq7eu8usZNTlDFIkv3cQnWyQE4c29i
	 WhUyW9xL/2vqBLqFN6wOpycKd95xBqd+e3CgM9ZPgcZlh0wJJ//g6c9MYsLQhifWJLA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795581149;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7xv7NqRPboZD8n16IYobKNVKDgaIUvKlpeGZVo5xpek=;
	b=cT9mUDxYvWxpwOKL4IMOT/yEnw/t7M/GgR49qD5Ub/vRt5OiLyzhgz/MvtlnwTn8HlPM
	 zBgl151PBv6rW7ChvrBivm1ECpNBcSwPzIQfk/du6EsQUBgasSbIIwDFCw09SmDDxNxW7
	 OgMqu09afqcraG3v8qnLyLmlGZtyx57kHNIEHW/vrZm0NttoGO55kjdwpZ63n5wazoY0N
	 9H+8P+0DopqS7QuZgj6AGqLMr3VABeBE4PeDoGoDFI/4SIKcQ9lrbihEBeZ8BL6H222c8
	 1zkoYyOLdqllQ1cMSKwT+NIh67Fy/6/gKmtq35XT2s04J/gyG4yvjAlKfM7Q0zrPf/g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 07D081F000D0;
	Wed, 25 Nov 2026 04:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795581149;
	bh=7xv7NqRPboZD8n16IYobKNVKDgaIUvKlpeGZVo5xpek=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=jYILALBkmVyPpqeIaCvXloKfkSZxc04kYD1KU81hG9hdFleABl5Jv2mXccnFtV+bD
	 xdwbHeXZJty0881h+Tp6LBagqM4eIB/PVGcTR52sZ32vkytNnduebxANBVxHa0hGhK
	 pVuyuUdJA5e+xCRwTnL98FgqpyjqEP8I9UR1xuOI1j/0qnXTzv9O3B3X/cHE3piA5J
	 gh+Nt2ZTZIdyTT8elNA+o6q7177FTMDw5cepUFkQVfB1xxuFaoY2HjjIhIMn98njlr
	 otBGBQu/O5CLP0jmedwufMMTBdEw8N/1zgOvrnxuBZGB/OVVFc8QA96EXmbco2z5Tb
	 DZgaipeufNbUQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8E2A94CCDA;
	Wed, 25 Nov 2026 04:32:23 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Wed, 25 Nov 2026 04:32:19 +0000
Subject: [PATCH v2] mm/mglru: skip oom killing for order != 0 allocs in
 kswapd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261125-fix-mglru-kswapd-age-v2-1-4cc37437af9b@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NQQ6CMBBFr0Jm7RhaEcSV9zAsShmgKi1pC2pI7
 27BuHMxi5e8+W8BR1aRg3OygKVZOWV0BL5LQPZCd4SqiQw85TmLh6164dA97IR39xRjgyI65el
 QpjnLZJHlEF9HS9HbZq/Vl91U30j6dWs1euW8se+tO7PV+yWK/4mZIcOatW1DMhN05BdPWpL2e
 2kGqEIIH9I7E4fMAAAA
X-Change-ID: 20261026-fix-mglru-kswapd-age-98390614c746
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Yu Zhao <yuzhao@google.com>, 
 Bingfang Guo <bfguo@icloud.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795581142; l=2716;
 i=bingfangguo@tencent.com; s=20260905; h=from:subject:message-id;
 bh=qV2l1gYt5Q96N5XOUnCBfwyMyXQq9VOKcjW+/oh4RQU=;
 b=S50EhNmVKqI1zc8Itdg9ig9CLE0dcM5ia7nxqwpj/tzGTLAG6/LlpCYTP4xUP/YJbJAfurPnW
 JIZfOZMkqW5BSmD9w/7MpCOjXskbmcPqC3VT2QBmY65mCiJkaw3fCeU
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=7YoBtD5pTW/XZHfmJ9x+FaHVq1TstMOvF31LTY3F+0w=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260905 with
 auth_id=1006
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9812140005
X-Stat-Signature: sf78srsa7fnd6t8ysdeh6dw67suays6p
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795581151-848188
X-HE-Meta: U2FsdGVkX19y5GR9CdKIduSmU+Fj6WmSAw4K9tkgEmGGYF7ATgoFgssLs1Cc0r3PxKf+2ZcE29dZr1QGeSXBkPGwD8tQtgrLZIlivtOtEtG71eAEmAll+4+G2tVoVcAG9zMdgUdiVQ3GbZuP59V/pr45yWkXqpmmINhJJfiuTBlBxPp9SjhSliaea7iGKiXJkzXTPT+WuImbs/uHBwhiQQ2og+DuRcvwpKZXP0CPKpxwZMbSqmpkUjDPhEiI8Vxep/gxuDF3bMLmG4SHrYfL2AuRRcovMsTvVXEWpwXcaKWiSd3EqiQ2aHJbUAhUV/YOB36fDVOxF3KURvpuVpPS/mK6zk8ytQ1yufhqaCvOFM1flk254YLFOtcSB0hoHFIcowyWQX85YduHZzzvxMscLCfWzWwGxwIQST/uqFsAo2WtBbOkjh32GmKvuW3cuWq35TLAdPgk26E8yTxzgmg9Hef0PU5oabgkZt8DZiqyvbXe+atdLq/wzcGaRWPe5lDX7769X+MPwuECtqgxEQEaV9hUkl2Ow74fmxP1YJTQlTTQ6M+ld4C8ERfFY3uNs6xq5O7GztY2oeNjofD7lDSG2npfdZuCua0L5ODYKjunVnzPQBiwLPnO/QEq28xF22z9RsPH/FBaP0e26FhIex6x7t6F0WOPMEXr5vJMBsZxIJPJuIzarL3N912EzJNF1gdg4Owdhr7RNkShXYXzzwpqsaKQE1oz5Day8glHyWNGiNDUQRIWSM9a8Y+Jmz6oxKUb7aHhan6/nD80ybsv4nkIHDowGHJJ8oDfuobqZ/HEFr9lAYz+NpxG4ytstbwPSKAtis5BfJL+R1TnNDnmJU1b4QCewx6YbVnr4L72CKlkGJDCzu5NdQxTLh7rlIcp3uKjpTWJYQhVEQKbhsVC1Oy4RUxaO+d7hKURTaX6bivFYMRTNYLRdONlPcmBLysVIPRCuYvTQRgKhipUtBbICPo
 rBqpl8bN
 Sb0Nl4y8WM4PqT8/q84pZvVhn4ACAJrHE9P7vSUszmT9jZRXUR3DlnC1FY/yo3M0l7N8MQiWUTIEqG/dmRnINSbqz9RPaIVY5qGB7L75C/WJc4bj6KGJKrL6WJwYhO9hQd/EqaOKP/0gG1PXAMSwYGuOzkvPTnps9d+RabtuPFFTack0HXhyiglfl4Z+FnZB2mG61XW/UUKNTzt0Q7hUqB40ebLPX+kgUG1gw/W1IhZ+/b8CnMCwl53MMSWqP1cIlqkWUSMTxnXIekMBMWBNLMrFVZHPFHvxwk5t+RHz4Qdu+7x8wRPZEosotjyyDzHvbFZFm/HVymeirBHB1zz5xAsTw84pQwqBmV4gO8tmJ6X/xQcMjPe6kj8rx5RLirWaADLxBRGXyXFFT+Fs5ealiPjEzgryq0sOAl4SBRpPOKNWzU3qHDSkFWxdkcK7Yti3epg2MthUn4zcncIUV2abaifVgPg7Kh2P3P+vLSH69t/4hQaEwUjcWK+PDZwEAOZ6xt3gpc0whpQBadCI1m+HRDsrfUoAs7/6PUeE97yt3A2TAmnCeE89+ktVwS1YT3yrM10KZ3gglZevjQB1FPPvlq60hbKWnROImI/u8qTSMx8m+w3VlUxF2WLqcvM59vYRJjrGsnFZ4DTrMczYITDGxJVvLHEGOoIUGqC96TwlCX9hWK0Zml46zGKIaNYaomQ5FTPxjFZ46WWMyDNGuJoRNWinLDVLghpnHovqxPg1XGOJ82uvM6+PBACGTj+OUsOhARYkx8d7ycBTTuam89UWV2wapRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Bingfang Guo <bingfangguo@tencent.com>

We observed that when MGLRU min_ttl is set and the system is highly
fragmented, high order allocations (e.g. order == 9) will fail and wake
up kswapd. It can not make any progress, while pushing generations of
memcgs so that they all end up younger than min_ttl_ms, repeatedly
triggering the OOM killer in lru_gen_age_node(). Then the whole process
repeats until all processes are killed and the kernel panics.

The purpose of the min_ttl is to prevent thrashing when all memcgs are
too young to reclaim instead of preventing fragmentation. So fix this by
restoring the behavior in commit 30d77b7eef019 ("mm/mglru: fix
ineffective protection calculation"), which skips OOM killer invocations
in lru_gen_age_node() for sc->order != 0.

Fixes: 30d77b7eef019 ("mm/mglru: fix ineffective protection calculation")
Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
==== Testing ====

Tested on a VM with 6 cores and 6GiB of memory, HZ=1000, MGLRU enabled,
min_ttl_ms set to 1000, and a workload that fragments the memory then
allocates 2M pages.

Without the patch, kswapd kills all processes and panics the system even
with plenty of memory available. With the patch, allocations fail but
the system remains stable.

--
Changes in v2:
- Reword the comments to explain the purpose clearly. (Kairui)
- Relax the skip condition to sc->order != 0 for soundness. (sashiko)
- Rebase to mm-unstable.
- Cc stable.
- Link to v1: https://lore.kernel.org/all/20261027-fix-mglru-kswapd-age-v1-1-b1ffdec4ae52@tencent.com/
---
 mm/vmscan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 836f50814ffa..9fadc6f9da49 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4351,7 +4351,7 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg;
 	unsigned long min_ttl = READ_ONCE(lru_gen_min_ttl);
-	bool reclaimable = !min_ttl;
+	bool reclaimable = !min_ttl || sc->order;
 
 	VM_WARN_ON_ONCE(!current_is_kswapd());
 
@@ -4371,6 +4371,9 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 	 * The main goal is to OOM kill if every generation from all memcgs is
 	 * younger than min_ttl. However, another possibility is all memcgs are
 	 * either too small or below min.
+	 *
+	 * OOM killing for fragmentation is not desired. So skip this when
+	 * sc->order != 0.
 	 */
 	if (!reclaimable && mutex_trylock(&oom_lock)) {
 		struct oom_control oc = {

---
base-commit: a3d0117e02bfa1c3bb6c50e7afe42bbecdbb3459
change-id: 20261026-fix-mglru-kswapd-age-98390614c746

Best regards,
-- 
Bingfang Guo <bingfangguo@tencent.com>



