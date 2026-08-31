Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE51C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 23:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE936B0088; Mon, 31 Aug 2026 19:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6096B008A; Mon, 31 Aug 2026 19:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE556B008C; Mon, 31 Aug 2026 19:44:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA806B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:44:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 189B8802EC
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:44:35 +0000 (UTC)
X-FDA: 85163196510.16.500C43B
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4E730140003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:44:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=paVPM6qT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 33xGWaggKCLYoparajoZckkcha.Ykihejqt-iigrWYg.knc@flex--stevensd.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=33xGWaggKCLYoparajoZckkcha.Ykihejqt-iigrWYg.knc@flex--stevensd.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788219873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mDLxU8rCSMehNxTB2JsY1Ut5xWqdS5v5v0phXyAcsEU=;
	b=JNFDGk9Mv8OEuyqkorLSxcavCqvl4mYFfsYW9vZL0HsUeQDnUJ3yzF6N/1xIPHf+F6SK75
	bmLH5QP0C+T92MPEC9aqIhH0W++b97PrK5CWeYGnhaaLDQAu38lVrHfUtcFTY9a2sJqVYM
	cBm4rmJBJeQQIrGOvO59zlbGw1WZjJ4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=paVPM6qT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 33xGWaggKCLYoparajoZckkcha.Ykihejqt-iigrWYg.knc@flex--stevensd.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=33xGWaggKCLYoparajoZckkcha.Ykihejqt-iigrWYg.knc@flex--stevensd.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788219873;
	b=pPlNmnEgkMAZeHTGFgvKRUZvsh1mDrHw60zQRlSUyH0Gg16At57zdE/GGFKAl7VoEjOOoi
	fRrjsDevU9RDh4twqAlbjtVC2XhwT+ket+2z7v+XQVaUrqIuzeFXzulzmjP5BkUaKldqst
	1/gku0otiGtawcp3dP1coSt1l8rbdsw=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc21bc2923fso2228660a12.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788219872; x=1788824672; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mDLxU8rCSMehNxTB2JsY1Ut5xWqdS5v5v0phXyAcsEU=;
        b=paVPM6qTUmBzL4P3GwyoECQfi0i0Fz3WYTOpTTj+MlNwNZ3E2ECXly3JgXDBZegolL
         x4hrbu704IjtwWiGX61QRs+SQ2ppf8LF5XggrPns+q9nUiyJDVqUzDzidJgazDpMH6xX
         IpdRC6Y8d5s6y+wGMDnd+c0YZnVkyIt038qwq+hpHTW+5vb8/a74ylu38BF0qtHjDFH6
         mU6ZJwP/GgBdPEW91CayhOmlPSwD8uiRdHRR40Oj6E2xOUEvoDpRdgESYsKzZXL8Y2Eg
         a7g3nMl0NiQETnUvDdk86fePw2KXKpyiC/e/erZO2xiZz0Gl1KlKJmloFXE2xdQ8UUu1
         yGsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788219872; x=1788824672;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mDLxU8rCSMehNxTB2JsY1Ut5xWqdS5v5v0phXyAcsEU=;
        b=ooqPRt40N1Lio6D0ZoudU7kqScx6nB2IknIXhT4X1buIp0kcquTOIJfM5Laho0MbtG
         iI5E0ij5+ecomrXqgjjCFg3LOFpdIBKhqZz8Uis7YYagZ4zwdzLf3FgPh/tbkadsYna8
         901JLGVFWQX8zlX+n5+Sl3ElQg/BpE5pqBgI1qTivxy7GLwa0dWYrReVdNtMgz8dJbot
         b7q3lfBosZVfu4yR+eXKeq6ZznUpQFVuDLi/yG5zfIJ0laI4mCL/ktfvMF8M/lJVAmXg
         qwrt4t7PkH4AeHM6hPs/KzZrfVcYvSwQRIikSRDPUyYpQrk8LpKwguHKz+Khcci7e5I5
         wVMg==
X-Forwarded-Encrypted: i=1; AHgh+RqKSnxaTyFo/J2z8rvTO6GtadtE0lLGbO1piMhI5dHcVvngKGlH1Cc5g7yNa8Bj+QoU9p8IJaI0GQ==@kvack.org
X-Gm-Message-State: AFuF++nT0HRnHBBC/rV0aF5jPY4gr4GrUbYDI4sJmE5jcP+f1+y22H0h
	Uv1k4DJm/OweQqj2YAJTLzBRRJ77Bpr5h24gkfzeru+slWOu5ttMln3bnSc8tAgMQpup+XJguz6
	AisesZIMzOn3gRA==
X-Received: from dlbts8-n1.prod.google.com ([2002:a05:7022:b048:10b0:142:e77e:11fa])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3a87:b0:3d3:af86:fb94 with SMTP id adf61e73a8af0-3d3af87e902mr34342527637.26.1788219871732;
 Mon, 31 Aug 2026 16:44:31 -0700 (PDT)
Date: Mon, 31 Aug 2026 16:43:39 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260831234339.280376-1-stevensd@google.com>
Subject: [PATCH] memcg: Don't call schedule_work when no spinning is allowed
From: David Stevens <stevensd@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yhrjzusjsmupangnk8w1p79s7ji3fsu9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4E730140003
X-Rspam-User: 
X-HE-Tag: 1788219873-404157
X-HE-Meta: U2FsdGVkX19Rqep4SniYnOt7yL+a6g9df8sX+e1Gb/bcpzbzDb3sKbtHnLhTtPOe8duzM2lDNFXIRpjlaC97zZBl3QR5+Jaz+k+Pn7yHleUsqONppynyFG/+jGhm168zO3s57vBqAIoIMtg9f9biQp17EBefpX2xx8BuVHidB68m2bwjxJ2hg2s7ZgdhzWEfB44nEq0QbjKBlH8nMjpv+2/KYlEvrSTGTducu099lWkjfCet9kq17eGpYbCWnVwO6N4N2d42O7vP1krgykh9LruJXf7hJHSV4vpCtDcZMVGVbJAx2bZ+Y33Pgyl6T0+MnoK0Ah2ABI1uRP/T/qsxyfnRJySybv8BEevfZMjSmRsxNDqfVcVavTCQJMUr1aQaoZzveN2WM3EhJbi5ZjjXjIszJMdx3Q/ySGXBHulDhFYH45HjKaoWXMbGuu/pvntcBANl35nDA3Gnx9yJDfnN5lRibwpBYO6IXXz8G9ImDW8vH87FMsKn2pXvTeMeMKpUY3FYaEE9FGq0C+YD0WNblV/Bymd4pfkKQtBwMBe6sHazARPBZ7owHnFIO53v9kCqx0b2wCT/n1jZXO+q3Z8mzIv+SmSEhhcTh4FI6lW62CfZSX/1mHC2ZOBgCAG8XX8ehZoYsYKcedT5oWQxt2PQGV51uqdDqcRBMIJqSEzbOkGFXKvSub4yUx/dIeL3w65Wpxum75cJngvS+APbsaxC8TVewWp1ss8fkQleXhyrthCUcbSzQmsOpA10HM0aKm+Z9MjDgnaQ0omSduytojMVycedxSq4NYY9BevuBHuH7JSXfWceAeZ8W3LnFRh3zP8SNM05V+9i67QLb0ADSwEglwo4FM1dotz3Pl+fd9WQ0WzzCgqA3FDb42hf+GmZyNLQ3tKIuW1pKocV3CKQ/qnwXY/eIuma6FLnLAzNWoyB4deLvrjj1XIvvBVKFO7CbZi4nc+QbE0SsamNsprpsxW
 JO1QV3yk
 1z8oxLW4MkGmmfzAYZMWN5dyKdbpmBYX9e1QUrE0pioK3rbVzmH6Qr+nZW4isygKmuIfwqo4WFIRo4apXO2MCq1wPqpl3RNhIuz8lOSkMqgHE1FIjEHfU4HpBYjqDy0gk373xEGWEywuV4iHEvBs6Ho27DK+oGh8db5X3DfIagqHcRZh6iByfgJdWgx+7vNYpqZ7Vw7PqyFDNSgaoUySK3qSawHQ3MTWjuoinwllVZSQYumb8lUlSTp+8UOSfNe+fbb4hkCVzoGKmKzzvnlHKRd2PpSvvStHqGikLsOApu887ucLzlMOImycRabhrQwgd3n5k7NwF7OrWspXnM5+vMkKsv9cQJ85EEyGMr/DX0ivPij8yzoRcHbzxd28DUJwDf4jrBv7RpXTjYmJ0apZl1ks3NNH7ycLV/nTpWVfZsc1iMZLa/FofS8nBvAouYK7wJyP0l6HK5kgUm7GHw0IGV5pgyc0WY78aw5ggoEvwY9wKuPI4NVstmJAfDWzq94O+/j8tzRjYgCizeaJJIm6Jv7eDBN1Bw1LpPCr9PeCL5jyrqLPNdZXG7FuzYswpxugEZ/ZBfjs2OWhMC7aWAIF6r51ElvXgBhAkRyziXVxTj/kmG+NZIO2Vlk/Mq6wC7oh/dvuVBvExGAJKxZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memcg charging can be done from any context, but calling schedule_work()
isn't safe from an NMI. If memory.high is breached from a context where
spinning isn't allowed, use irq_work to schedule the reclaim work.

Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
Signed-off-by: David Stevens <stevensd@google.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8170bb8066a2..036d973ceca6 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -219,6 +219,7 @@ struct mem_cgroup {
 	spinlock_t	 peaks_lock;
 
 	/* Range enforcement for interrupt charges */
+	struct irq_work high_irq_work;
 	struct work_struct high_work;
 
 #ifdef CONFIG_ZSWAP
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..5e2f749067cb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2360,6 +2360,11 @@ static void high_work_func(struct work_struct *work)
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
 }
 
+static void high_irq_work_func(struct irq_work *work)
+{
+	schedule_work(&container_of(work, struct mem_cgroup, high_irq_work)->high_work);
+}
+
 /*
  * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
  * enough to still cause a significant slowdown in most cases, while still
@@ -2752,7 +2757,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		/* Don't bother a random interrupted task */
 		if (!in_task()) {
 			if (mem_high) {
-				schedule_work(&memcg->high_work);
+				if (allow_spinning)
+					schedule_work(&memcg->high_work);
+				else
+					irq_work_queue(&memcg->high_irq_work);
 				break;
 			}
 			continue;
@@ -4129,6 +4137,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 		goto fail;
 
 	INIT_WORK(&memcg->high_work, high_work_func);
+	init_irq_work(&memcg->high_irq_work, high_irq_work_func);
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->memory_peaks);
 	INIT_LIST_HEAD(&memcg->swap_peaks);
@@ -4337,6 +4346,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 		static_branch_dec(&memcg_bpf_enabled_key);
 
 	vmpressure_cleanup(&memcg->vmpressure);
+	irq_work_sync(&memcg->high_irq_work);
 	cancel_work_sync(&memcg->high_work);
 	memcg1_remove_from_trees(memcg);
 	free_shrinker_info(memcg);

base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
2.55.0.897.gb25b4bd76c-goog


