Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A21CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 094636B0088; Wed, 14 Oct 2026 10:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045286B008A; Wed, 14 Oct 2026 10:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75A66B0092; Wed, 14 Oct 2026 10:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C194C6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:54:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4325A1C3E23
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:54:51 +0000 (UTC)
X-FDA: 85321528782.09.2685FC9
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9501C4000D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:54:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=V1WGQBEK;
	spf=pass (imf04.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791989689;
	b=yyHsV0Iux9s5++SWyahcbaEQL2DcAtCl3IzzMj4rj+JL9wRfYzGQpWcJ8M+5PRC7HtI2f8
	q1ea62NJcP4TEPfQASLb/mo2GyiELSTIyplextAALaZvKd5pBtW02Ky8Dg9G0I7D+gF3gD
	xJVgEUWXuHXfqMAnR9SzgMccfOZy8ZI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=V1WGQBEK;
	spf=pass (imf04.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791989689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWkLknY7xKuy1SA57I+rolv6ltWrRmW9nqFyBjSVvQU=;
	b=A3S06I0CLFM10NwrczRyAnBtWp1agx6+ASF6u7BKOr6tmHm3j01W5fIqVpIIzwG4njw/jP
	T+msdtrpSeoUScQnogvzLHfsEK4r2ZuL8Z8WbrVM1ck7lsT0XnGQSgkfUBFohQJbCcxlFL
	li4/KaVhjksxdlSum1dna/HmElHa/u8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=HWkLknY7xKuy1SA57I+rolv6ltWrRmW9nqFyBjSVvQU=; b=V1WGQBEKONr07ayyPOq
	f59wHfgGQCXmctUhu4aQGgSJKvgHsJnKSTouvxK9sfyv8boIWdyvHm/i1C4bBnzSsBgsfd0PMeN6D
	NDISZRH7uTU3M1lqZFdtzwxTH80pg88JI4FLUYc05mU+zX6esk7o+VFHEeaYyJNW3HC73dDKRcQNu
	1MH4uGox25QJDGBcQzgxTOlMiAFphadKDKBpDn17SNaMOgP70AYO2dvY7suLnH4vPXsLbwxMWp3Kz
	NlFQeZCnVZYqmgC6cw3/hzlct944W91ADQRh/4YODFKtOxDwVyskK5+UulXUI5iSlUep3alkSISXk
	th41TVl7iqmJipw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xH0Jy-005Oui-08;
	Wed, 14 Oct 2026 16:54:42 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 14 Oct 2026 16:54:37 +0200
Subject: [PATCH v2 1/2] mm/shrinker: size shrinker_info_unit to a power of
 two
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-1-51af2aedbe6c@virtuozzo.com>
References: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
In-Reply-To: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3201;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=S5pKXlc8nyAL42PzwQoBsDoCOCSgtHQeHvMgfKY+ET4=;
 b=kA0DAAoBUZYKR/lhXCoByyZiAGrPl7Cj+MS2MZcYboAZyGfaWxUgNJHSegFzxv1aZwzsnYJY1
 YkCMwQAAQoAHRYhBFYPbcg9xdPQY70ILFGWCkf5YVwqBQJqz5ewAAoJEFGWCkf5YVwq+g8P/j71
 4qOS1vdUF33iiqyre5o6E4LH1jmZ8aERi2jJnKkQPqXBGQab5QFxVfVOV4OxX1DS0rPYy89LVhX
 jvirxoS1MDu3fWxpXe7pwgLcPHMK+9uYsei3l6ghVsnEALpriZWvv6urqvtTUaL1MRFyWVp3dZ4
 MqfkPG50rMArlFl9bHXZ0qizhPy6C869lDHsu0UoGXhZagS2Pj8zEhn92V0NvwlvSErzHRPRvhO
 b6jFYkkGVwjtOgHdUv4TnO1rKQ/991MKZcXMO+4P3ZKcffVLCyuX4CI1hN1WQHFihynBJzlVjmX
 6Anie+1bM6zRslYp3Vi9bHHnVorRre86BLtgVrEc15g+SWtXFm4pc238Vb0F+efwAKR9lvoCDPV
 r/WVII5avltoH+MbIcilws8hvPwbIOHXZGdTAtTXWIkrj5KZ4beqLSJuoczqeP6MVQD77wm4BCT
 nuvzyV35XOscvwRVtVHtTzsLn4S6EaP1A4LrzEydsKbv7Qitht0cNIdTgrmO5TnDSfN/RdJuXQF
 IaKszmxzQtzh38MGRKl3dEvXPKaPpL/urMvrGF+xcSySAo/JL/1gaPHe7L8xgDMBQSLrO2lpALx
 p+oCDejJw3R+pkiprYf8q8wpAgiPW8ic94Y0kycYPIM3rD0eRRfHvznJ8N83QTsbnJxcjY4H+E8
 Ztnyr
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9501C4000D
X-Stat-Signature: 4t5q4z53w31wnfeazdcw3gskcnsa7r6j
X-HE-Tag: 1791989689-381977
X-HE-Meta: U2FsdGVkX18fNjN8n4vcXWLdM8vt4zk9jTQUYGcwZtrGBLRpNf0mWVXnOmjffF2pe9P12hC4sec7W69mwDnXshNTZTrbdcW+1y39LBqz9cvmfwOSC/OVj/Y9qN1x419Co4eEPMZLWlKZSaku2o+I2P+1M0C6KC9uID30QEtVbID0q/RnJT2vq2yWLGRxIUU3areiIuo4i/Rh8annFeXly6sj5pTBHkiAuZBsvxUU8qhB4Cwcs2szvinXoTStEwXslRA92M/6cUbRM7i29dPJf21V4DF+W5sSdhCMfd0+aJO7pBvJ7WNmfcbIMX+lJO1y0kvYmcbbyg1+0XavKiEjOpuGiIwdPQaHnvF2aZRtB1LW0vp6RJv1jgbypPFTu7dsZaS5hle7NRocmVF8No4+YCC2lC5bG6RJ9Uopm0UQaBXwfzjF6hKHCjPgl+cEoxGNy2sLmM9zOSIxILEAnCzCu/ZhlepnlcoZ13xtKGmXcOJ00nuimp6GyZuv4gN+mlKi0IvKN3pHTataZGw9IiMwtMxmtOl0OkhJB2Zajdz/FfJUG78+00jT8HpAi7oH+YvJ4SMH2JP4K6CloM3A5UZrCzVzFFO8Tknz9hSYpf9iA/D7r7xUBZ/meJ+HUxPZ5JrCxTCvRQrelYreNh3QGI/dBytoArFgBz3BsU9drcP3ybjvLGU7KnHmRav2x27PM71g+huuunyTlAioe4wuFR9IsmPYs3U/WG0963GyPwMu18054rG7/N6nEuezWW6M2I8wSzHJKsII5ziuranu/gK8kAo/Q5juRzd8/bkF1294exBRcgKYH/79Ko0N8/ujvNiKgZUmKXaQnZv9yfLQe4PzgfuxrWQwriSmxDLXqDuMIzk2gJOzMS/MIeedO28rl6H3A7wFFFuM8fjhinRcerGkhmauOtbnrggAvxGT6Uv0W5dpNgGmimwk+TxZNRPHOrX5v64sDa5/xXIlL4jaEMm
 QiAoftpP
 seHyfmfT5kFnCMGfplkN0FmapCUV3qia3jb5Ig1hl9n9E4EYKhlG/dj84wvDSlf3kf9OvWCgV7sSQODJmEevbuZu/BjXsIIVur9jImaGSD9cj9+omz9mQWlkeocJJvBeppXeHgJrefqEecXuGFSNGMHMK3cRCzU1nSc/klrMjRZGDVz51MJ6mjZmgbAwELpoHNBKz7MHiE33T9Qp0w4a8iDYY5otM3LMc2iIS7Sumr5vKBm45xo0gK36OHIyehPUJRv0Atvh4E4dL4nXV7mLTBaYDbyhx30nt2arbr5qXAb31QdM80eEPiasdgeh8Mme1RsUzo3QGTC/P0uU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
for every SHRINKER_UNIT_BITS shrinker ids up to shrinker_nr_max. The
unit holds BITS_PER_LONG atomic_long_t of deferred work, a power of
two, plus the one-word bitmap of shrinkers with objects charged to the
cgroup. That word takes the unit just past the power of two, to 520
bytes on 64-bit, so every unit comes from kmalloc-1k and almost half of
it is padding.

The units are allocated when the cgroup goes online and freed when it is
freed, so a dying cgroup keeps them until the last reference to it is
gone. Their number is the number of memory cgroups, times the NUMA
nodes, times shrinker_nr_max / SHRINKER_UNIT_BITS. shrinker_nr_max is
the peak number of memcg-aware shrinkers registered at once, and every
superblock registers one, so a host that mounts many filesystems and
runs many cgroups carries the padding as unreclaimable slab, and keeps
paying it for new cgroups after the mounts are gone.

Let a unit cover one id less than a word holds. The bitmap still fits
one word, and nr_deferred[] plus that word add up to BITS_PER_LONG
longs, so the unit fills a power-of-two kmalloc slot exactly and, on
64-bit, the memory taken by units halves, for about one unit more in
BITS_PER_LONG.
round_up() in expand_shrinker_info() needs a power-of-two step and
becomes roundup(); the other uses of SHRINKER_UNIT_BITS are divisions,
modulos and multiplications that do not care. Assert the unit size at
build time, since the layout depends on it.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/shrinker.h | 6 +++++-
 mm/shrinker.c            | 4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 1a00be90d93a9..f1cf6096a7a06 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -7,7 +7,11 @@
 #include <linux/refcount.h>
 #include <linux/completion.h>
 
-#define SHRINKER_UNIT_BITS	BITS_PER_LONG
+/*
+ * One id less than a word holds, so that nr_deferred[] and the map word add
+ * up to BITS_PER_LONG longs: a power of two, which fills a kmalloc slot.
+ */
+#define SHRINKER_UNIT_BITS	(BITS_PER_LONG - 1)
 
 /*
  * Bitmap and deferred work of shrinker::id corresponding to memcg-aware
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7ec2a9704f6f2..5e4a5ce231868 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -46,6 +46,8 @@ static inline int shrinker_unit_alloc(struct shrinker_info *new,
 	int start = old ? DIV_ROUND_UP(old->map_nr_max, SHRINKER_UNIT_BITS) : 0;
 	int i;
 
+	BUILD_BUG_ON(!is_power_of_2(sizeof(struct shrinker_info_unit)));
+
 	for (i = start; i < nr; i++) {
 		unit = kzalloc_node(sizeof(*unit), GFP_KERNEL, nid);
 		if (!unit) {
@@ -159,7 +161,7 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
 static int expand_shrinker_info(int new_id)
 {
 	int ret = 0;
-	int new_nr_max = round_up(new_id + 1, SHRINKER_UNIT_BITS);
+	int new_nr_max = roundup(new_id + 1, SHRINKER_UNIT_BITS);
 	int new_size, old_size = 0;
 	struct mem_cgroup *memcg;
 

-- 
2.43.0


