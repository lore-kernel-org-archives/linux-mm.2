Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E0C1C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C1006B00A0; Tue,  7 Jul 2026 05:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698586B00A1; Tue,  7 Jul 2026 05:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6556B00A3; Tue,  7 Jul 2026 05:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7A46B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:38:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A955B8D94E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:38:34 +0000 (UTC)
X-FDA: 84961480548.21.2806057
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id AA973A000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:38:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oTcK4EVx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783417113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=81JSG6w2tPh5xLW4dgWvCCuTi+vlHxWAgKmbEEuJMmI=;
	b=zI8yhoEH05AN/wS/Mll2USe5Z/a85Sei4qhK2m9XjiDQbtfqH5k4CaWHBj1CmcU891f8Vg
	daSjWKWrjWKMnlloe0IG81D8qDKzdLqQ//0IC6M7abeOUHd9IgMwzzi0u3Soms8KV4OsDv
	KmpkZH+DZYRY6bAZaoRbrOorQOoK8os=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oTcK4EVx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783417113;
	b=IHCX0fiMp5pwjn9fR/t+GX3vVLN4a8ml/DkzSeeQJt9oSoktTmZvr698U1YULBQvex9IWS
	3xoUS+lmJPmbWpUuGr2kyse9MnAUB8Fi9s4SBiyuP0qO93fMHECP9U7TxBFXJQT4n4uAC9
	a+C9M8+RNG6NKOxo8vAQ557/+qTu7SQ=
Message-ID: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783417110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=81JSG6w2tPh5xLW4dgWvCCuTi+vlHxWAgKmbEEuJMmI=;
	b=oTcK4EVx2B8Ljv/pIfP+FxJpn76Oi0kUf3J23SeIOMhzRT3149x1fiJ51nZ/X39c5ViT/j
	eAAZqMFSbGlvr82wJ/GBtyVd86/HH99DRyhRcFwWvgEDx4d2RjIOEF3A4eJA8zA3c3uQsL
	gICmKcQwZKkcUPNad2N2MuofNU4E3Wk=
Date: Tue, 7 Jul 2026 17:38:13 +0800
MIME-Version: 1.0
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: cgroup/test_zswap failed with "zswpout does not increase after test
 program"
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, tj@kernel.org, mkoutny@suse.com,
 Shuah Khan <shuah@kernel.org>, mhocko@kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: chasftsogtmietfu7mpw45kzpwphyon9
X-Rspamd-Queue-Id: AA973A000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783417112-676403
X-HE-Meta: U2FsdGVkX1+uOqk4pyMIPreurWTNWStrTB3edYa+mMVdB4ypeISE9uI6pUp21m3q7A3vkEHVp/PI85wkU2kwYIPsfDzRrWrCFIbLoltUrhrBcuti84lYvTA1PZrU9iyYFkcRWzPtKn/DSMHh4b4e4b1sfHDrKnR/fih/tanmbZVXlbXn7Pko0Td4jaYnRrp0tw9XD/+n6gASs6OyRdnvltDnr52tQoT8B9MIVdwLotwpDQoBa+qWxMUGFQWXDAZcUhc36KlNpuL8GY1shBdlW6lrL0WrvxeyxSfFNp4k2Ry2XiuyhlZ/ih3wGuKLOB5T1t8KtwH+7h0hncK1chzO8N6w+fE4uXbNWO764TIlzonjD+fg4HAkTcsGuIiZeSgP/PiWnEiPaYXf/MY9Yvp5nIB2bfj694i+Dna+IJt3OkybD6l8e959aBmdytQwLOKo9lWciNJbLyggMQ+eac7NFSa3Cvh1Mnc8UET+0InRZXbYm16WgbwYvX9gU4wPE7dE2b+d+sN838Ti3ovi2xR2Wgip+zLHk1AeeeNK0m5EzF69k1AkZtnqaxlO8dxdFckEOsVCDtKOvMXHZlk8zF3Ux185iPEqgd3OpBN+xC0C67YuOD22WY5lxJFfNLhwTVBbGmaI7fUQqoVNM4Wc020VZXhI7/ObU9ugaOW67ItxvPu8vyPi753mX8SAu8bsnFVKtahWWJkfaKYh4Rk0QDBfQ+TIqVFsHuNDHiuZF+wtQ1bZsSFs7az3bVTzvVGYgS+Hvx8NdEGAhZMS3GFxyL6TyvvwK8KbtgpStH+eHctcr8EuNi5xpOBAR1mFNLmQ9keLJW2DSoudHD1x9l8Q7l+raYRoh02DX9yD8nBpSLzDBIXca465CVF5iAFiJI1cV1Qj8I2ZVQVyWEQrZZLLYMhr3Lm7yUdhAs72pmSv319Ngo4sfgnS8C54FUJjrQLaZaj86P13c7oXmWLKmdvDkgl
 8daL7gEP
 +Gw7DiNoJ4ycw9hmFlV5ENBso8M0ICVe3rMVGulparNArlRHLoDPXXiQx0oB7ttxbkab9lNzEY0Qii3UWDop5+bWD6nTBwj+0/Dye8it8am7DprCIl10jApHuPpqNeuxUJnqjV9B+XR2zzm8FLIy+8pH+63xdypw1rHaRPP+IdpdmjzSy/fQeqkH/d6LbBi1rbxElUz065rPQHFJS1S6JXZf7PgZ23Vm5HGjkfBnt/aGU8XKkvd2/tmECoyV+fNM6rtHa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Running cgroup/test_zswap on my arm64 box failed immediately with:

  [root@localhost cgroup]# ./test_zswap 
  TAP version 13
  1..8
  # zswpout does not increase after test program
  not ok 1 test_zswap_usage
  [...]

I'm sure that pages are successfully written into zswap by checking the
count_memcg_events(.., idx=ZSWPOUT, ..) trace events. But "zswpout_after"
in test_zswap_usage() is 0 and results in this failure.

I guess the problem is that (in this particular case) the memcg stats has
not been flushed when userspace reads it.

 memcg_stat_format()
   mem_cgroup_flush_stats()
     __mem_cgroup_flush_stats(.., force=false)
       needs_flush = memcg_vmstats_needs_flush();

 static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
 {
 	return atomic_long_read(&vmstats->stats_updates) >
 		MEMCG_CHARGE_BATCH * num_online_cpus();
 }

I can image that memcg_vmstats_needs_flush() will return false because I'm
testing a 16k-page-size kernel on a box with 96 cpus..

As we have a periodic flusher flushed all the stats every 2 seconds, I use
the following diff to wait the flusher to expose the accurate stats to
userspace.

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 3ce134509041..9596f294da0b 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -95,6 +95,8 @@ int cg_read(const char *cgroup, const char *control, char *buf, size_t len)
 
 	snprintf(path, sizeof(path), "%s/%s", cgroup, control);
 
+	sleep(2);
+
 	ret = read_text(path, buf, len);
 	return ret >= 0 ? 0 : ret;
 }

I have no idea how to "fix" it properly. Please have a look!

Thanks,
Zenghui

