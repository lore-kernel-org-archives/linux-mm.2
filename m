Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D401C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EDEF6B0088; Wed, 29 Jul 2026 10:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4706B00D2; Wed, 29 Jul 2026 10:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B48E6B00DA; Wed, 29 Jul 2026 10:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F280C6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:37:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC60D1C0F3B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:42:34 +0000 (UTC)
X-FDA: 85041173028.28.1E5DB12
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0DAC820006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:42:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aVEYwPiz;
	spf=pass (imf31.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785314553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lt/d2kAncfp9Acac5Bt6s8eLHi0HnyPmHLMXZYN4/j8=;
	b=cIOeAIt8hft8tExET8NY4TmRF7cPf7z+ywlmO6F2FpKVoCCo4KDQSQdSC7WgBMsqCIFfqn
	fRGeXeonMbVTVM6rO8tBhTtH3+SJHeDOHAOwhT+CrBNb66u0Btb9wewgw3O7D5HnAJZ0Kj
	I7udVvyr5mFAylNY8yOlRGfS9BWQarY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785314553;
	b=q3WE9ARQCfgIf3v+N7Fdb283JUbuIL93oZeb7/i2pPX4UYdFWS6UiKfsN2VwIsgKl0gLB3
	XYcTiRvp6jykl4FRpit2YJmFEfgPWayfh5LVW/8iUeaQ7XJZFxWhfEG7xGgTGPnq0jBYJc
	wFmMZNlX6klQEr+KvyNvg6VHyn/0EII=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aVEYwPiz;
	spf=pass (imf31.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso906760a91.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785314552; x=1785919352; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lt/d2kAncfp9Acac5Bt6s8eLHi0HnyPmHLMXZYN4/j8=;
        b=aVEYwPizMBu9mNYHIy/PKkbqGYx9zAypAfjGuOYzavt02dF14u8I1yq5QF5VXnzoPD
         3yDw52/UtuTbojLOptIJW03vilkKcTvc8aTeG/XFsPJEgYyDwVa2QDYYuIzyZiipaOjW
         R6q9rAEYatyWMOIW6P0hZygRwDxs+GLGPXsXVmWRoIhIJ0s2QZagOsCUCaN/7MXUguEh
         zb8EpM/ByVDfNxg8QdeQ0ftpFVQ/5vASfJWvIKR61wS6tDf00kECBcPx0xaxiJ2zvCWr
         CN7vsGGVk/nlb/lrV8Ohl11bTYuqW3ZBQh2OdrHHDBHQb8yPvxAWOGcl7hthIpsa6l0J
         580Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785314552; x=1785919352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lt/d2kAncfp9Acac5Bt6s8eLHi0HnyPmHLMXZYN4/j8=;
        b=iWmyop8PMc8imUeZdX0LxQ4F8AhO9PcbpJGOu90a2wf5ujkeIxerfLzJZ/PlDE7961
         ybHx1K5eaxrCncntJqwIqJZu/YwdPmRE5fqje3ofLBc++qrLsR9VkfSvBWkEisjpvtEn
         WJ0/Wh9XdH3L4NaYgQTyUy1j5gll+c5UNv2RBukhbfvNut0+zq2riwXHqtfFKCzyGqT5
         vPtA9k7eufCH8qMA709N3LCNInAhwAc8FkWml5hTe/9n14xUACo/0g33ydzULc+Oacrj
         IyoPwA8mfyScaMDCnl2mDaThLsE4GTLw2vi8EDWlip6cJN7cv7rpFeDRB8tvkQgWqeGB
         BpFg==
X-Gm-Message-State: AOJu0YznRc20x1SpPGZVx4Dh6fdTTnrDcUQnBV03ex5j4FaC6reSmUGV
	gDJN0v9+UM+8Ez8HtbHHx6XNJw5mKJgwRpN2LiW4zEHq9XDjw+KQrCpf
X-Gm-Gg: AR+sD115f0hJveF6MmgemJvySJCKFsYuvnr4rN71VQocUz343TZuIOG76nZxoPJmKs6
	Cdb/XVXWKhuZO5sEkysalI8NoW002+8478PNfH/w3jDlygrPfmvMN0P8KlBocmtmaChuDKZbpV6
	u2z0YaNx+rUndrRrT5evLvhmBH2/e2bgV0CkpoYLDbOR+b4udx6W8bxNZP5a7sESZDrWOF7YKjt
	lnPcHOF/3W+O1aE09buKvI6jLn/bc06tEgn7czqfeuKZdT/ZonfRz0tGAI+Sfg27eQG5GVcX3mv
	SnqlzdwkfT++pXjjAdQuGmUbAhY3i6b6T6Q009ome6RpRE2pufn2JGY3uJffC/ymAcBsGm1JMhU
	pUFMRTeLkAoAn5pxLKbNhdbW9wtsMz1eBApSUG5HZ+soCtvPYiCCet72D6FdKxjgttwhlT1IVPB
	NufCnHQyiehuqfOO8nyYneN2L2bb029uhKreU59XMjwo5i/kJXmxr/P19BY/9fH4QPOT8CmkgpB
	7aN8CCzlFTJYf+C
X-Received: by 2002:a17:90b:3a8d:b0:38e:6c37:d95a with SMTP id 98e67ed59e1d1-38f6a445e64mr5503868a91.19.1785314551939;
        Wed, 29 Jul 2026 01:42:31 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f642fbf74sm2447744a91.17.2026.07.29.01.42.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Jul 2026 01:42:31 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] mm/zswap: Fix global shrinker when memory cgroup is disabled
Date: Wed, 29 Jul 2026 16:42:05 +0800
Message-Id: <20260729084206.77793-2-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260729084206.77793-1-jiahao.kernel@gmail.com>
References: <20260729084206.77793-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0DAC820006
X-Stat-Signature: z6zpkn3dxgfby79kmu4q475gdumprz1f
X-Rspam-User: 
X-HE-Tag: 1785314552-56267
X-HE-Meta: U2FsdGVkX1/bmJZZR0u3g1PK+rBDapwHIONs1VnSOgc4BlWvKiCjDFcclLTDFiyqXebX81n16iy6WjuXYcws+M6vKCXwKD1khYGch4VMsDp4LPEJwzTY7BAc9b9FbKOUs9xZCuNg+GLgHg36dZjAiuDQOM9fh//op8S91wt6xQh3YrfupQMDrzFEerFUxy33kMLaf7CiI35+JEPXHybBpu6gilJQzWGHxnnhVl08v2wfjhDR7yH9o9N5IH89jUDkm+A3ap6Hdh/VCaZ+mfM+BOyEph75SXxX0K7gDdF6YJKwHj796War176lskDB4Dn28r/RfkTAiUW4p12AHNWFTVXPx0toyvLhKgrsYpycBDMBcwac96hWX0uhW0bDJPvOGBJeZONOMLiovWDcS7iHJNhb+4c54S9gpxoD8Ug5V/2BfgwcklRyJk0AjoptlqGZ2P1I3D7x0izAppF4J//I+IOSv/90eB/DFTuecpxdh28SxSQHDWE2jEjeZRNfywjc1K9aEA9CV4PZC9YGOkVAxPrm+a1DG/TfKp/2zkNoUbWQMfATtc4sXk7GmxVcJG0oL0WkAP8Dv+YC5WLaECY9AVh8j6Bb7BzLwlRTYXgJs0tHuhBC97cYQZzJxryw/OlgYF5exxVnI0atSqa0dy3bIwRaNaVh0+ZfRfqci/BrkcZ05YpbSEpaUR3IrZEuinEQqxh5vZmtqgVAGUNddw7xI7GjJ/gLq5tw7j5ODAxiIR1I6RYosgkal6TR7Gsq2dbRM3cvRRnDF1SAH2arHlT2hJYWoJ9wYDXYmlo6gj0UPko8N4btoac89L9m+WwKpSKNkI8/8NAc8FW+ZvhRg4pwYT1xDZr2/YcIHWn0r9EyZe87CkxU1SI2ylYEvDeKLjK8Gc34p/dJbansbG2/WCK1v/Kv4Qa5ogd7Z5gVbpt7V7P29e2U4ffm0N2/U5pD+7e7aUp639g/amFR9Y3Se4N
 Go6A26xr
 6LlYOvsudxPcw8L5mehh4YSzVuJcdbwjPxBEs+Wbnc3Z+hqoTF9lubdJv7H47KLxsfPbcJaRSu306Kekrrw5q6MQIDWFZSRhMjMjEV3j5+4ps9Jxdy+K2iSky0swYDm2RemFoKjR+qcP8w5C2yAFou0LWDO8y6Y6HMqXHbDDa6zY/KD8b31cO8SiSvLGJqXqmWOQ7oXA2YBx1nh3+TU2AVGyohW+FMACw1Sr7LdjG9q8ybq1c286hbYWV96CBc2frxHFWjaItq2Nn4FeLDu4WzgoEAZI9KWhjGlEn50LPJ1e/BLa8Nj0R38BRI2mDunsSxtJuLQaZOl0Q4XuCc55TeWL/KHrA8j7QV0VEjNS5Qc0b8qs2E1ZUUd+Vg138cEI+ZcbFDcv9rI8BwoO9cY23vBLbFGNAcsxjWViloDhGR+DSAeJlqK3UbCf6FWCv3IBV2zRt1uj0I5LpFbo5vZPX9UqIwxPaKY38eit2A8Vniw4Z/7ge/WuG6p2YCQpROpzYHR71ml+Vr5hyy7TV63+g9ejk/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Zswap writeback when the global pool limit is hit fails when memory
cgroup is disabled. The pool remains full until it is organically
drained by swapins or memory freeing, leading to zswap store failures
and pages bypassing getting written directly to the backing swap device,
causing LRU inversion (hotter pages with higher fault latency).

This happens because mem_cgroup_iter() always returns NULL when
memory cgroups are disabled. As a result, the global shrinker
shrink_worker() repeatedly takes empty walks. After MAX_RECLAIM_RETRIES
failed attempts, the worker gives up without writing back any pages.

Therefore, when memory cgroup is disabled, fall through with the !memcg
branch and shrink the root memcg directly.

With memcg disabled, shrink_memcg() only returns -ENOENT when the root
LRU is empty, which means the total pages are already below thr. In the
absence of heavy concurrent zswap stores, the loop then safely bails out
via the zswap_total_pages() <= thr check; otherwise, it will resume
shrinking the memcg after processing the reschedule check. For any other
return value from shrink_memcg(), the loop is guaranteed to terminate,
either after MAX_RECLAIM_RETRIES failures or once the threshold is met.

Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
Cc: stable@vger.kernel.org
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reported-by: Yosry Ahmed <yosry@kernel.org>
Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 mm/zswap.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index b5a17ea20237..48fc7b575e24 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1356,11 +1356,12 @@ static void shrink_worker(struct work_struct *w)
 		} while (memcg && !mem_cgroup_tryget_online(memcg));
 		spin_unlock(&zswap_shrink_lock);
 
-		if (!memcg) {
-			/*
-			 * Continue shrinking without incrementing failures if
-			 * we found candidate memcgs in the last tree walk.
-			 */
+		/*
+		 * A NULL memcg ends a full hierarchy pass (except when memcg is
+		 * disabled, where it is always NULL: fall through to the root LRU).
+		 * Count a failure only if the last pass found no candidates.
+		 */
+		if (!memcg && !mem_cgroup_disabled()) {
 			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
 				break;
 
@@ -1379,7 +1380,7 @@ static void shrink_worker(struct work_struct *w)
 		 * and failures.
 		 */
 		if (ret == -ENOENT)
-			continue;
+			goto resched;
 		++attempts;
 
 		if (ret && ++failures == MAX_RECLAIM_RETRIES)
-- 
2.34.1


