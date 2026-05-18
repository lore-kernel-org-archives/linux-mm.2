Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49D8ACD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA256B008C; Mon, 18 May 2026 15:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A917A6B0092; Mon, 18 May 2026 15:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95AF26B0093; Mon, 18 May 2026 15:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8140B6B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:12:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3104793607
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:16 +0000 (UTC)
X-FDA: 84781486272.24.9D42D07
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 45FA440016
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IxWHCGda;
	spf=pass (imf12.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779131534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tvA0jsT56XFOzdzNJ2doFH+eXNoXIcVbsna/QX/3LyM=;
	b=VcIKfAzqlbh+nkMFZFooQAwF5zDOxfJs+ew+0pddPujkbdlldpKxbUKQKJonSLJFclVMxT
	BwronIcdJkT69xfE+ksatur3psz7o9LtS8DNp3mVoGzZJYFgYsGdsK7+/Srau73LwpaqI4
	8lBFYFq3TfMj5+/inFDA+wnxEHUdT90=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IxWHCGda;
	spf=pass (imf12.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779131534; a=rsa-sha256;
	cv=none;
	b=7IoNN58WwS/2z1Ol5RYWfal0RjmTSQ8ooPoaV6cCgu9loJsCeKv4pfZWnGjB4r1ovdPfld
	PIr9jQmQA6UfVwfgCO+03foJ85znwweSDs0muXFKlQt5IWYsBGO51pSohRLDUKfm5d1yeb
	hItGUSHcz0C67lMjBiLANPCJumH7ac4=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so40101555e9.2
        for <linux-mm@kvack.org>; Mon, 18 May 2026 12:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779131533; x=1779736333; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tvA0jsT56XFOzdzNJ2doFH+eXNoXIcVbsna/QX/3LyM=;
        b=IxWHCGda/UZsKClFud+50DtxV7mahBQxHSqiWaRlHtMpC3oUFVVvd8t6KxPFlLWuGa
         6kVKU8w3V/9Xe1upMLZI+KTKc/1O7kBMkfyQW+fKp4GrcH0aF+f7L9RST3t3TFJIhBBh
         udPBU/yROiJOMRpsJ6Ur76/OyW78mVoGoEbKHSbi8R1Oom2UpVxMABVUOvEJEw0ySLxq
         U5TsnDTq7s6MVue/+J4dQaZvtjQx0GaGE42X7yowDrW9CXkZzKUDl3khojL+KkqHxKgs
         FQTCROgaF+LByTw22dMjRSvuRd/USojTWnBVliWhIpLMRfvhIYLg5GadDn33GtcNArOn
         dD9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779131533; x=1779736333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tvA0jsT56XFOzdzNJ2doFH+eXNoXIcVbsna/QX/3LyM=;
        b=GtVkw1s5e+H2Kp8MMxcX20eBgAA6OeJqiPV6arAyK5cSxyWyaOsRWqQuh/gIh5nYr7
         0J5dALDCYVCem7WkugQPMLMso92eeiI/wug/dm/n3V/r9bKPTPMHntwWjTtUZC/c3LIE
         fE3yi+CdWASBkl8zRL1w5cA3d1+KmFqcyfN/BofAaNU6merfUBWVzkrJaKHnrs0cYnPv
         eTNTKdcnZU2oTYTyh/DxE2wBK9IjKXOIV9sencYa27fvuw1NmEtKpEabLFvv37qKghs0
         jesslSCgRHLKnXTmipmw3aBV+YNORTa+sL9wxa4xvYsSIfbDaIrunFM8LwT18TKmZaYl
         5s+g==
X-Forwarded-Encrypted: i=1; AFNElJ/OElf09zUVc1C7g52YgWhngCLQ8Xo4qvj++8KGBBlWzawQmfsvwZLZR+zmrcZulW3E2H0UKxGQ4A==@kvack.org
X-Gm-Message-State: AOJu0YxPBZwU9u7Z3kio+Nsag243I5rAaV/dSKYP1ZT3wKrHMA5PaOpr
	lwywUbzmliGZ/J+9W7HhEEATRpgzlXPR8eQQcImS4bZsfJRw8kFUoKZI
X-Gm-Gg: Acq92OF2PvPV3MjwlAuApz6p3CMq0ihC2lNXiMCqtl40m7SFtr1qoMnfdN3ASDktY6F
	u0brOdwJ3eZ6VUcrCXUzw2wWFrWhdpMkowo+wKqzJm+VFgd31dBrpitiJo01c8VzJdICnJBBbQp
	GxMQBZ1NCUZyjUmdAO6Iz2ikMrQR8RQFyym53R+BNzfq4bUtmjXXei9Tz8j6x4SubOX2lljcQAb
	SO/WuEuRqJhAM4bydcScBA9Xkc6xz8YD/WB0Xphew7WjChmH1gh8ZSSXJ/wrH6UHuBEFGCI7VHq
	fRtfqoWuAhStintaMXBx5ak9Sp16MnI1Uu1v+cyV0qELbQLxFTduTH1SPHYearGRH/GL2t3b8yZ
	JX+08RTY7OHfDIneucdU1qsW4By4zsViBPrAVLW9KkmxpXVRJ7xI488x0TEvcevDZE+JJejkipl
	ICkeh663/Zp5JLfZgGueeYt1xdtYi3wO/RdP+BPJilIFVZZqJBtdk=
X-Received: by 2002:a05:6000:2c06:b0:43f:e9ee:5610 with SMTP id ffacd0b85a97d-45e5c5e2ce0mr26609560f8f.43.1779131532440;
        Mon, 18 May 2026 12:12:12 -0700 (PDT)
Received: from mshcherba-RedmiBook-16.. ([188.163.115.207])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm40043167f8f.34.2026.05.18.12.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 12:12:12 -0700 (PDT)
From: Maksym Shcherba <mshcherba2000@gmail.com>
X-Google-Original-From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Subject: [PATCH 2/6] mm/damon/sysfs: implement update_schemes_quota_goals command
Date: Mon, 18 May 2026 22:09:28 +0300
Message-Id: <20260518190932.42270-2-maksym.shcherba@lnu.edu.ua>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518190932.42270-1-maksym.shcherba@lnu.edu.ua>
References: <20260518190932.42270-1-maksym.shcherba@lnu.edu.ua>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 45FA440016
X-Rspam-User: 
X-Stat-Signature: 5yy7cuuim3hr8jbgwz1s3tzaut9fcqon
X-HE-Tag: 1779131534-512448
X-HE-Meta: U2FsdGVkX1/0ifbOwc78BerXKTFY3NvydTPqYJnmNTVBgtW0C7IYglJHcYXHieT3p7XJTnMzdh5d+6Xai2kr/YRyxqlQKzYrLwCorTiMltSllsoGqF9QpQ1w6nNdTqwqcA3ucvdRhKam8tpsaRZ7oXn1mu5MeaSAy3VavbRrlzx1H36C6cRw7OAHOKv+TZJK3FDOrHPLIv4nz/5vGkY/cEkCTseROZktW4+pLIo1nVPD9MsVoNw7IsDZNgn/pNuTw/hpxDQGew9i6OA7ZJfRHcDGhWdPrsVu9rCZKJGcxOZoAOv48IUGV0a0A/zvHHxKv+/r3jvTp7ltu4b/aCnbrXZ4svabpcZOTeRDpZMlguUv7ebA6yIYgcxsGffwNU8hki7oCQSdzY6xFyQ1aoYY7eSzCPfgCJHe+tyaAIt+aAY1f1FodP2l0D/Wayt0BF2l6TGUbjFPWpy3hljSO3GRQbZZh+Yy6v8wcze+r6acnQ7jziHYBZnxCuHYBhoW8Z3FSCbiYCBRTWwOibCSAn1auKQ59P5LUIkvz9lKcpJcN+dc9Nju59bsVHMT+/yDrdNjWD2BSELvlpFv6+/fU2C02MF6go7u0D/Uv1fwo4b35W3qGjqNYPDC6x57I1GGoIfBTBTZs0wB2VeVYhKA4A2EQ07fMY3sdm/oIcCPHVNuPdyIdeDCXHtf7WVKmIwN2zt86+CGYkA0ZA26I56xNef1V+XWfTuA9wipxokmria1H7UH91w0qA8o9+1oYogBeZdYtVR7EuO3ECC9ia7P6LWf3KsEkUWf+0V1FlRfItWLsmQEsTrNETQox1EJSC4qNgpOt7G2YUTh85NOx1yqM8KCls4tBqwpywrgIzd4K5IWpZZBl4v86y30XRoRWdvh8HgBLBfB64dbUSV4kwx0ZR/X/e71OhFdquW0o0QbqXMgt6fbGvhOBJJHAeTBF/YDAdrCJFgIu0nMFzmPZM0hhOq
 99h4RhMs
 L533eJyvRK+oAIxko+F7JhDdpDhFRanTyoRkaypG7/GPeeKJrF+EknDo2yKcf3dXahympApkcBSo5PXeu9C3Gzji8VydOWgB4AnQ16GLYLXeW9mojmwRouHzi032i2riG9ayy86xIK48i6V7qby0YId9d6pd7i5jh9gmBVhGt+V0U4b7/HvjzV+Ub6hyDm6viR7WQiNUfamexEv0pr3TTX09sUoYp/4H5Nnvh8hRjrl4SrSchQkjJllx0XGth7hdBsCLL4RKOrTYa5uxPLBCA/XuZjSmYaqovAdnHCa5O9mG9eUp4AwNFCiOQMJCQ1GrI7GgePOazWBP8iIjN6NmDXOmMo6YMnBf2TArvmk/vd8jpJLGaMlbE+nQkWbu+FBMxdu5N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the logic to copy the current_value from the internal
damos_quota_goal structure to the damos_sysfs_quota_goal sysfs structure.
Introduce the DAMON_SYSFS_CMD_UPDATE_SCHEMES_QUOTA_GOALS command
and integrate it with the sysfs interface via the 'state' file.

Assisted-by: Antigravity:Gemini-3.1-Pro
Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
---
 mm/damon/sysfs-common.h  |  4 ++++
 mm/damon/sysfs-schemes.c | 29 +++++++++++++++++++++++++++++
 mm/damon/sysfs.c         | 21 +++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/mm/damon/sysfs-common.h b/mm/damon/sysfs-common.h
index 2099adee11d0..9703414fa15f 100644
--- a/mm/damon/sysfs-common.h
+++ b/mm/damon/sysfs-common.h
@@ -59,3 +59,7 @@ int damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
 void damos_sysfs_update_effective_quotas(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
+
+void damos_sysfs_update_quota_goals(
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx);
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 5d966ac86419..5793659403ca 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2812,6 +2812,35 @@ void damos_sysfs_update_effective_quotas(
 	}
 }
 
+void damos_sysfs_update_quota_goals(
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx)
+{
+	struct damos *scheme;
+	int schemes_idx = 0;
+
+	damon_for_each_scheme(scheme, ctx) {
+		struct damos_sysfs_quota_goals *sysfs_goals;
+		struct damos_quota_goal *goal;
+		int goals_idx = 0;
+
+		/* user could have removed the scheme sysfs dir */
+		if (schemes_idx >= sysfs_schemes->nr)
+			break;
+
+		sysfs_goals =
+			sysfs_schemes->schemes_arr[schemes_idx++]->quotas->goals;
+
+		damos_for_each_quota_goal(goal, &scheme->quota) {
+			if (goals_idx >= sysfs_goals->nr)
+				break;
+
+			sysfs_goals->goals_arr[goals_idx++]->current_value =
+				goal->current_value;
+		}
+	}
+}
+
 static int damos_sysfs_add_migrate_dest(struct damos *scheme,
 		struct damos_sysfs_dests *sysfs_dests)
 {
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index d5863cc33d23..ecc880b52b32 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1320,6 +1320,11 @@ enum damon_sysfs_cmd {
 	 * effective size quota of the scheme in bytes.
 	 */
 	DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS,
+	/*
+	 * @DAMON_SYSFS_CMD_UPDATE_SCHEMES_QUOTA_GOALS: Update the
+	 * current value of the scheme quota goals.
+	 */
+	DAMON_SYSFS_CMD_UPDATE_SCHEMES_QUOTA_GOALS,
 	/*
 	 * @DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS: Update the tuned monitoring
 	 * intervals.
@@ -1342,6 +1347,7 @@ static const char * const damon_sysfs_cmd_strs[] = {
 	"update_schemes_tried_regions",
 	"clear_schemes_tried_regions",
 	"update_schemes_effective_quotas",
+	"update_schemes_quota_goals",
 	"update_tuned_intervals",
 };
 
@@ -1606,6 +1612,16 @@ static int damon_sysfs_upd_schemes_effective_quotas(void *data)
 	return 0;
 }
 
+static int damon_sysfs_upd_schemes_quota_goals(void *data)
+{
+	struct damon_sysfs_kdamond *kdamond = data;
+	struct damon_ctx *ctx = kdamond->damon_ctx;
+
+	damos_sysfs_update_quota_goals(
+			kdamond->contexts->contexts_arr[0]->schemes, ctx);
+	return 0;
+}
+
 static int damon_sysfs_upd_tuned_intervals(void *data)
 {
 	struct damon_sysfs_kdamond *kdamond = data;
@@ -1656,6 +1672,7 @@ static int damon_sysfs_repeat_call_fn(void *data)
 	damon_sysfs_upd_tuned_intervals(sysfs_kdamond);
 	damon_sysfs_upd_schemes_stats(sysfs_kdamond);
 	damon_sysfs_upd_schemes_effective_quotas(sysfs_kdamond);
+	damon_sysfs_upd_schemes_quota_goals(sysfs_kdamond);
 out:
 	mutex_unlock(&damon_sysfs_lock);
 	return 0;
@@ -1813,6 +1830,10 @@ static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 		return damon_sysfs_damon_call(
 				damon_sysfs_upd_schemes_effective_quotas,
 				kdamond);
+	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_QUOTA_GOALS:
+		return damon_sysfs_damon_call(
+				damon_sysfs_upd_schemes_quota_goals,
+				kdamond);
 	case DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS:
 		return damon_sysfs_damon_call(
 				damon_sysfs_upd_tuned_intervals, kdamond);
-- 
2.43.0


