Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F01BCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC6E6B008A; Fri,  2 Oct 2026 20:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F0B6B008C; Fri,  2 Oct 2026 20:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DC86B0092; Fri,  2 Oct 2026 20:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 056106B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:19:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A4EFA040A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:19:04 +0000 (UTC)
X-FDA: 85279405008.01.A51A8FA
Received: from mail-oi2-f42.google.com (mail-oi2-f42.google.com [74.125.231.234])
	by imf04.hostedemail.com (Postfix) with ESMTP id CA3E040004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:19:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dfliUdNW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.231.234 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alzFpna7whc/qd+JNdpZ8QaO0qS27ekiyNGSU2+s5WQ=;
	b=JWfyEVcDEd9VYjY6LKfh9sK3wsCR1zt3JgSvKMQ7t9otDqnXIhRFowRTbdjQC7y16rUMZN
	jJPjg0khD8LpvcxTZEqFrG7iWlgQlGdfNprI5QY6ic2SrCES4zvDTHzmTX2YXX9koft3Mh
	lTDa7pU6a9jHGIPq3eAfC3qdonDQESk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dfliUdNW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.231.234 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986742;
	b=8PZRdlXkv0+e0MtTbR3DWTMF5DShi9Nc+L+g0i/qZnSz96Yzw7LX6Am9HPfCq9pfTbtMDo
	qBYuN/Gnk/eM8BqXLJrkkGfO3H3kDvfg8lmgq9aHwp/8BrBo7xlSCP3kRbCtBuBT1blzI4
	N3jNT4ejtzOpQJPH6HriBZjDnA3B5/8=
Received: by mail-oi2-f42.google.com with SMTP id 5614622812f47-4e47db1adb8so188245b6e.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790986742; x=1791591542; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=alzFpna7whc/qd+JNdpZ8QaO0qS27ekiyNGSU2+s5WQ=;
        b=dfliUdNW0bBYV0zu/ZGvkl52Byi36/id0mz/dzFQSO4zskwcd23KTK6cyvqpphUk7W
         uKZe/M0LQZSzt8Dig1zsuZXfvNhfO54EJy43jK2hgm8KhwP7VtwYcFSk2tWnTYEogmBz
         ZtNN4mVGL4cgeGwIV2YcGDINDvZD5zwV5aOCpn0NH8RwMehyjLiQkH3pfymYbp6s27q8
         O8iSl3bW350SOZNTv7QzA8HTo486as5gqLo4A24f8yfe+X8EP0tgsr6/ytu1q9IsVtTX
         NG33D2bKIiDTr7rFTJ92iEEnTWPoSdGtTbJUuFIHczUFR1SlXflnvnhESi73n9TfeRF1
         am5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986742; x=1791591542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=alzFpna7whc/qd+JNdpZ8QaO0qS27ekiyNGSU2+s5WQ=;
        b=B6xDAv5mhxrrqDbIdk6UEVjPvKieTWTKE90i+Dc5odksJhoG/j9U9sYGCf0HZ3oE4e
         wsMYs99bUX+14wFufOatopgBpygDBAQ/zYmn6V3aVQ/ePyQgfY1n+H3x2UjP+P01GVRT
         EXTpBmXA2BIeIsP+hbSXMz/1npwYqrD5Q10jeLLQhUW0/PGPa/OfMvWUv1dEvXxIufhp
         8BzezIphfHIAYL0hmg7ERBGmkiAyPffymE8zPdHffiX/xPjU6Mds5FOEnLfEa4W0OXNM
         EgVarYJCa1k27sL+p+8+qtYDPaTgSoowDLuuiA9X1KJi1YdxmFt1h79UDTBkc6I17GFs
         hVAw==
X-Forwarded-Encrypted: i=1; AKwUvBxWhdrCza9Z1VFXwdJtvED2R18hC1qINHn5LsT/HUY8zboaNvST1lHJi67ykRHcGJrEf7IefAZHVw==@kvack.org
X-Gm-Message-State: AFuF++kCjo+rpo/upkM3pUPjShMUQGJeCUliAqL0WHwXSnj0btDvD5ej
	GS73w6pTuOdhr2pTwvTMNsjmSMeAj+5nynWnU9razmiuNghtr95vykvr
X-Gm-Gg: AYBFou0a1Jx3i3uMXalgwvel6CjR6oex61em8YV3Y+Chc25d/e1TZVBSrsBAjYoL9aY
	tPz2HtAs5sMSbPwIPzFcX9rmibFLNoYprpmbOQmVhvJRROd+tX+MNf+Q/rofQpWo2/9bibs6d7y
	15EjDIBotEoDnpcLWeYRTvEIkNg9VL2gnm+nbuAd5A26rFKoWgRHSLz2m5KXs5+WyB3dyutgJgs
	pXh+2dPkOezu7EOiVFqloia/EXSa9vt/TT6kH2xtbaM2vvxWWSs2JynQBn6A0tSwnh7FW/obgKo
	4RB/QWvxUeEqUMc3ojkjFg4dvtHceV2XUHYOkON7ypGFO8fqEZxYdvLOSBIoqp7mUp2TZDdOyx+
	Cs98m7wHR01omO38ciBIhJzBoCHrkxcFkrxwgfhxzY9k37mU/gQ2vIt5Yrmcuuz0W4FLSCdVTCl
	B0kynITf0IVm24BPAP6MhjIpMyFuQuV/IYJz/Z86+ND8/JtduZ9FayL300sqHcn1e59c7JVq9Be
	nkdTjNCfYEnXxYYj1ec1PAG4teu07UyI1r8Z8T+Ahb1rK4lZA==
X-Received: by 2002:a05:6808:3084:b0:4e9:6a47:be26 with SMTP id 5614622812f47-4f5288bdacamr2628101b6e.22.1790986741784;
        Fri, 02 Oct 2026 17:19:01 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4f5243d47absm3330156b6e.8.2026.10.02.17.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 17:19:00 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	willy@infradead.org,
	jack@suse.cz
Cc: mhocko@suse.com,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	riel@surriel.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 1/3] mm: memcontrol: factor reclaim logic out of try_charge_memcg()
Date: Fri,  2 Oct 2026 17:15:53 -0700
Message-ID: <20261003001555.3498357-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261003001555.3498357-1-joannelkoong@gmail.com>
References: <20261003001555.3498357-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CA3E040004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: jwpg9bgfx7o3wm65unwwr6qf346xihxx
X-HE-Tag: 1790986742-68363
X-HE-Meta: U2FsdGVkX1/iVmrQqWkoN2SL6imZ6D7ofZRc5MX1aTRXlhSAqpZNuBUV01ToD6tnrFuhY4MTvlR1NY+D7GqSlLNTcT0NYJjYmbzci8jpC8jrW1NxdCrGhiuluaPDoWlHCCw3llteQ3iWKFqG04OhMu1UZRHpg/L6f8MCuUbygXycpCJmG6SXeJPubvze1PapReKokNxc5dfTD714E8oXlM6t1CW1iIyh/214EwiHNtJ17S6y915Xp3O7As6We6Pywh0vJTVygmlwGtZ/G49O1/hdBJX/57rsF5lw/n7nt/jNjP8+mrOWX74QshVb37usW70f9yXzaJWfgJGqg0At3KGxuBp/Rf9A1mtPfOsE0+YpWtRg3Jf9xfnFWZDHQPMGZJ3v+x/Ps6UISdkOOkM54J40RaaU6FBuoH6ZXm0p1+fe0XxR7OfTLk6D1WTGkBxXeQVIIUOSaI4wGbs8w76J5Js6QRqwlTdoFv1y9s2AYjNFL7eOc1MaMENj/Dc3Gr4lcU45fiQJYH1Pz0vFwMSq0j9Hlb2MP3TbWh4SSnvpK8S/Btolaxds3EYO24e2JamnUu3aBqXCyTqBZHT+OHri3ypZIb/OWkfESIVPKSKG8DB52RL62dyhg03u/TZPRy3ayYyQYZ1bXS5K3Pv/YrtIgaXG2fATM+qHj3UqNt6KSH3RWGugaI3GBe+G3UhexRcy5vUQVjVVXFOh6DpLc7708LlIi1gwg8AS5sXYK8zdT7VIaq1DksphMc6AjQMtBBkm0O6z1DdxOYbCboOfZy7lOlXotWmZchvQHohgqL7CpzMa0QMbmNo7yKlZqnodAjM22CQLQPZq9CLoJWWSHhqFaVIOF5M2AaD7WiIWEAQD/8ZroE9RpHKSbf/olppUiAB5wHnSyPniEnMXbNK5XbOsJKn+M6G122TzGD60TxCYBY9fsR48t4bqERl+O9oaqRpOfMFbScVW8x/wJ1Il06g
 gX5ZkvyM
 wtmGUUmjqd2FXzE5OrqL97T/DmieF/58nrJVO/xRKDtArCQMW4H1du01qtxAnEvJ972AqPqk3uIGiSIgxGpdSCgsUzk756WA2NG6+YI+tvA0tKzFYLPA4xDyQsDaH5KSoJKERZQXAFfm939qUUbDXsE/WnhNptcLU5DsHhnFR5opIULYwkRIGg10Ygq7HC3AvQPoi3zzsoqI/1x9JV19ZoDvhs8hw0ShzX/Q2cR8xjWim4JkRsa6VqQHbyGpVlW0FMGJ4tZDPY3k6ABNomhrSqOSzhbIA6e3twiHo4LByjNLvBpaAI3QeAeu9r/rDfHptsxXn8sAWVqoHrtCGIuGwy7EV7B8ZU98qJwMYQ9scgpQGX49RZY8cJdRhDKgQRJaUK/DwMAu8GOWu8IEgyHVNfSSI3vdBS0fw/WZMLMs9ZzFRnaE4v5uiX1kfB6OnoYXtXcEGuA/pz3Q5fQpNqtI/8gcr5VjTrzDClP+QNDibXxqKU3hy4d4gf9Ycqrhn+1LN/Qwq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move reclaim logic in try_charge_memcg() into helper functions so that
the next patch can reuse them.

In memcg_charge_reclaim(), we can call memcg_memory_event() directly
instead of passing in allow_spinning. allow_spinning must always be true
here since memcg_charge_may_reclaim() has already checked that the gfp
mask allows blocking, which implies spinning is also allowed.

No functional changes.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/memcontrol.c | 67 +++++++++++++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aad0498a7bd6..1d4b603085a5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2696,6 +2696,46 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	css_put(&memcg->css);
 }
 
+static bool memcg_charge_may_reclaim(gfp_t gfp_mask)
+{
+	if (unlikely(task_in_memcg_oom(current)))
+		return false;
+
+	if (!gfpflags_allow_blocking(gfp_mask))
+		return false;
+
+	/*
+	 * OOM victim still needs to charge memory to exit. OOM reaper should
+	 * help but it might fail on mmap_lock contention. If the victim is a
+	 * large thread group then all exiting threads might compete on oom_lock
+	 * just to learn that there is nothing really killable anymore. Bail
+	 * out early and fail the charge to expedite their exit. They are
+	 * considered fully reclaimed by the oom reaper and they shouldn't
+	 * contribute further charges.
+	 */
+	if (tsk_is_oom_victim(current) &&
+	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
+		return false;
+
+	return true;
+}
+
+static unsigned long memcg_charge_reclaim(struct mem_cgroup *memcg,
+					  unsigned long nr_pages,
+					  gfp_t gfp_mask,
+					  unsigned int reclaim_options)
+{
+	unsigned long nr_reclaimed, pflags;
+
+	memcg_memory_event(memcg, MEMCG_MAX);
+	psi_memstall_enter(&pflags);
+	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask,
+						    reclaim_options, NULL);
+	psi_memstall_leave(&pflags);
+
+	return nr_reclaimed;
+}
+
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
@@ -2708,7 +2748,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	unsigned int reclaim_options;
 	bool drained = false;
 	bool raised_max_event = false;
-	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 	int ret = 0;
 
@@ -2747,33 +2786,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (unlikely(current->flags & PF_MEMALLOC))
 		goto force;
 
-	if (unlikely(task_in_memcg_oom(current)))
-		goto nomem;
-
-	if (!gfpflags_allow_blocking(gfp_mask))
-		goto nomem;
-
-	/*
-	 * OOM victim still needs to charge memory to exit. OOM reaper should
-	 * help but it might fail on mmap_lock contention. If the victim is a
-	 * large thread group then all exiting threads might compete on oom_lock
-	 * just to learn that there is nothing really killable anymore. Bail
-	 * out early and fail the charge to expedite their exit. They are
-	 * considered fully reclaimed by the oom reaper and they shouldn't
-	 * contribute further charges.
-	 */
-	if (tsk_is_oom_victim(current) &&
-	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
+	if (!memcg_charge_may_reclaim(gfp_mask))
 		goto nomem;
 
-	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
+	nr_reclaimed = memcg_charge_reclaim(mem_over_limit, nr_pages, gfp_mask,
+					    reclaim_options);
 	raised_max_event = true;
 
-	psi_memstall_enter(&pflags);
-	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
-	psi_memstall_leave(&pflags);
-
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
 		goto retry;
 
-- 
2.52.0


