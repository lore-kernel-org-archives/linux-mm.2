Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16D9C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF906B0112; Wed, 23 Jul 2025 10:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F926B0114; Wed, 23 Jul 2025 10:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE31C6B0115; Wed, 23 Jul 2025 10:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB3B06B0112
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 844E880756
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:27 +0000 (UTC)
X-FDA: 83695807734.17.71E3C9C
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id B5C93A000B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=0wqTMIVJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282045; a=rsa-sha256;
	cv=none;
	b=0Io1qLM4z8aqN8wO8CZfybSm6672kxSYMkKzqyTwIIe8sKSRDqlbRZSdkd1pyvnDCHyPE9
	oRyx/GCn68J/jf/zKDv522RdnOMtnObbutyYJ5qeL5hQ/mRurRvY7yHPMHJKb6TyqLxNMG
	UskDhOgIGwSpfhh6fq46bAHtIjRMB24=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=0wqTMIVJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sk38mGBhqK7qzK3HNwB+80JVX/lHD/SIvkcYryZBkd4=;
	b=vy1T3VDy7d+8ZeEsqZslh532s6YfvVUdt+8ZoyRiazUGdIMvOHVfyBP9W92WYbNSYikuO/
	6Bj0ZRVRSeMYHwlR+4mRNwlHb2jBreG7y6oqkzecRxtZT4wLXP9PfviNMsTJh4sr53drki
	CnIgaz1CcVjq8f2gJ116XnzPk1qs9Pw=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-70f94fe1e40so11240287b3.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282045; x=1753886845; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sk38mGBhqK7qzK3HNwB+80JVX/lHD/SIvkcYryZBkd4=;
        b=0wqTMIVJOThF+a4qNdweGisY6oWxph5jZweXHViSWfWDG2uwJGtvEmoWPlWDJwS/Lb
         A4tE7an7aQnfvhy1whIIwLYnXYv0GzfhzGO4oeqotzZIkcRoxNfBtxSZ5QfDq77gndNW
         3z50tHrZVk/ZrA2RVWCoG7OnsNEnmX+M6vf1q8fEXA91GBnKvyOs1l3FWmB2381qN/6L
         587UHffxCDP/GWMOrVLwMzt7YJx1JaQ0WMA5SCqhv8YtYwjQ9P+Jr49YAxpk+7sf0tVm
         pNfQsxV2CqBRJKo9eqzYRLT8FBRbHkUL/PpppihMDtBVelv2DWOwC5V8RPb7VMjPM8Im
         V96Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282045; x=1753886845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sk38mGBhqK7qzK3HNwB+80JVX/lHD/SIvkcYryZBkd4=;
        b=kcecNavPegCd0hXRM5nIbmBfrvFErw37Gs1qtw19DKvQjd8xVnaxfWKpAE3Tb/Xb2L
         hadhHZew5yh4eSB7DwSD9gGtWXRAFP4ITvcL+qBK8gJntegZ5uSmk0n0sNuj68Np9Stl
         Og+LImrWMi+yAWnfTneAwgBJVeDuIpcQj/VV0D61op5dpM8Ti9C8S0Z7X156VMNE5xhH
         XXElZtds+uQdXoVYw9JvahYi/MPmKZy6E950CJGm3QoNQE96iy/4AQrmhoxPO3YYNpKj
         TEc0dplwxZu8UVGmJYD7wRNX2wUqzQzmYjhthCw1Fx0ThiHDHJ5SY4wsG/m/Lhxk4G2r
         nDvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVk4FxW4CXs/6DETvFzyKKdXDdM0oqgo3Dai1v7janXf8OeX05KLttPpNnHDGXAqK8z/6Jqzoyvhw==@kvack.org
X-Gm-Message-State: AOJu0YydBugzrQIGS/4UqBn/22adu9q6IK9BYlSXRk60lJsNRIN3q2zR
	guhvAMkahz4zaPEGC+CC6ceDz946C2JG2qUSGvNxWGiRTJg9hLcrFSrM5IFw0rxWcOE=
X-Gm-Gg: ASbGncsACBR9sJobvMe4+jxY4pDrogTctlQCNnKMKlL+GVyjbYkFW4ycdoOVXu5qi6n
	0/sED9Y4fxwtgnjdLZps1ooIdTq+68B3YL7d9rMfEIIKWlvBhGUI1xX/uSnRZ22DILnYEkRePqp
	pbrXwDb5s4s8NpEadz9VJPEuYVPLuGr7413otr0jhU4NqqFy5kPifzFh/K1YdYQ+KF/FCTn/fQ1
	lzsgBlwXYF6dTgqXZurgFXe7S5naXJBpRG92PVXJTfNdSVSEob9CsAEr6t+L276AWumCjbRa4or
	2z2jyypd5YEgcLGmLmsmHhewOWZgAVuXc2roo72jM2QuksPjmJl/18dHMtD5HfRele17lUtnxLE
	4rdn9NOtDqIkpydHS11cJjIkL+ZuGAXYxDEYeo7OEWoK4iD8tu1wIf1tZwTI7bKa6uVLRfMtiE7
	weciUSXfnyDvZkjQ==
X-Google-Smtp-Source: AGHT+IHGYfjoIy8qo73uD860AaG0pKa+DBLv7UTBP+7WtZjAXyEb/laqBGmfDkMsPVthzLrkCs+A9A==
X-Received: by 2002:a05:690c:d84:b0:712:c5f7:1f11 with SMTP id 00721157ae682-719a0b52782mr94165947b3.10.1753282044761;
        Wed, 23 Jul 2025 07:47:24 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:23 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v2 15/32] liveupdate: luo_files: implement file systems callbacks
Date: Wed, 23 Jul 2025 14:46:28 +0000
Message-ID: <20250723144649.1696299-16-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B5C93A000B
X-Stat-Signature: whso96se4wtauwhbrowy3jc9jr6rjda7
X-Rspam-User: 
X-HE-Tag: 1753282045-651920
X-HE-Meta: U2FsdGVkX1/WALrJCzMONNE6tuvuXgLbLrBLQs7qc5a7yyqQTnorJMOFGjb/QhXXmC3crvAaU5KbqU/fwAGyRkwqSs4p/IyGouaqwZNWbUGgw+9nqIu3T8Fc0A4uOLI70XIL3cY7fkMnjWTE9MHE1OV+Cq21SMFJ9/2UcrYHfaYaJEarNLoM/Eudilfp2duciDk5sDFwH7ynehn50GI++vwWw+t77cjfmE9HLGusn3ODhtiw2eqdBLzUCcNq3Z4tYcmb1fHhvoB1pUSPU7aj6MxTmL+iRgzljI3ETZA1NyocXHo7gDZ64IwA+rCltiOgdEyhK3UTADapiisEgGQvfCYKK9xfVfRYylEvi6p5k/5KPU1a6qZ696F552zHfUgk0sawBKNZeIhcDHSAdyTHKfPG+/8oa71DqUSgK8ZJgbPZv6v7jzG6Ne3d0wJGigrL/J72Z9UvWy11FpDHOOC0fHZ/I26xqvAqjCGY4BSIPHKpPmzKfg+ctJoEGBsY3OgB9L3ClFmveMoLUzsWkNWOVpq83eWSHW5rH3F4uGmcCBJh6VsQKd7Ggdzk2vHSPWbsmn9Dja+XF+HwaKxURzLTvsCdp7S5P1WpmozaA84RmGrkhRoKS86+0TL8LHHv1gVZaNdSw4KB/mvWpxHCtUL72eUDbGE5hehVmz24s8CS064I5Gi245FJfpvvWmccCsskIlYVpAZcCZ/cFfalRHmIWDtcF8DeVzXmT8hwj5Fhw0jnAEdw8066iUrdOMCXvIGMbs7hfMxL4sfYoCm861t67mDq+xD0ixr/oDGAB1YFBGIChR5tqYwHie1WB7FDDTQi8aRmamo5J9ODLFEXsBNE51g72QJ8MhFqXh46ApajdBfzvk4zycG+qYxgjgFQasgQUfb/Us0E7IwW1d7jimjUjFjTivuX9/WtFAABdfwjIzIdb6lcucn4ShVCpDfVQkA0rMVjlPQRBqOjDkEXhVf
 lArg7tQ0
 WkqBW0VZJwkHIIh6XN0E/McJxssluXO4Q8LOCVPC0rJLNx/QqHhCIARrPiEQbd8wT3BUMXQB21RDPo4Yw3ac8nzY9+zBvL+Df+yTpY0cvarhB/QXGoKml8dxN8XMtMzGiEPdex5cLuvgzZqih8tFCyJJfvP3qO5p8cGaB8TACZwyNk4Rr8/5r6JTWxkWx/L8ZqDYJXksMzgx/MVhq46rPq1bbYr381o1eoawEAAaP6DopLkPFg8sSQTqbs3kAduDQoFyofLm6JRC6KrC8rKsHiwFxIBCjt4tTMkuxLIWYNyZaDd54M6MgZXMaEquW+ZuvtzbtjKdTXq5ad5b4ybgaSu7GjDDy8B4Nv1Hs+Xt7OZtytM4GxMLgExBvFBwW+q26qvgODLW7GyJsuTIKgr3ipqSogzQZcQq9A7OtXJGWSQlHwa0ZMhFt1OMfUWXk0Q/c74Q2XuHzAr/1SG+jx+TodZMWuXFAFr+Se/vUSkxqE6zx5o7ktO16sxMgaOipsVlV5kW5LIQgwQqYG+l38xkK6HOwdCzjFOSCr9C7aAycV3XvBbM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implements the core logic within luo_files.c to invoke the prepare,
reboot, finish, and cancel callbacks for preserved file instances,
replacing the previous stub implementations. It also handles
the persistence and retrieval of the u64 data payload associated with
each file via the LUO FDT.

This completes the core mechanism enabling registered files handlers to actively
manage file state across the live update transition using the LUO framework.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_files.c | 166 +++++++++++++++++++++++++++++++++-
 1 file changed, 164 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_files.c b/kernel/liveupdate/luo_files.c
index 3582f1ec96c4..cd956ea69f43 100644
--- a/kernel/liveupdate/luo_files.c
+++ b/kernel/liveupdate/luo_files.c
@@ -325,31 +325,193 @@ static int luo_files_fdt_setup(void)
 	return ret;
 }
 
+static int luo_files_prepare_one(struct luo_file *h)
+{
+	int ret = 0;
+
+	mutex_lock(&h->mutex);
+	if (h->state == LIVEUPDATE_STATE_NORMAL) {
+		if (h->fh->ops->prepare) {
+			ret = h->fh->ops->prepare(h->file, h->fh->arg,
+						  &h->private_data);
+		}
+		if (!ret)
+			h->state = LIVEUPDATE_STATE_PREPARED;
+	} else {
+		WARN_ON_ONCE(h->state != LIVEUPDATE_STATE_PREPARED &&
+			     h->state != LIVEUPDATE_STATE_FROZEN);
+	}
+	mutex_unlock(&h->mutex);
+
+	return ret;
+}
+
+static int luo_files_freeze_one(struct luo_file *h)
+{
+	int ret = 0;
+
+	mutex_lock(&h->mutex);
+	if (h->state == LIVEUPDATE_STATE_PREPARED) {
+		if (h->fh->ops->freeze) {
+			ret = h->fh->ops->freeze(h->file, h->fh->arg,
+						 &h->private_data);
+		}
+		if (!ret)
+			h->state = LIVEUPDATE_STATE_FROZEN;
+	} else {
+		WARN_ON_ONCE(h->state != LIVEUPDATE_STATE_FROZEN);
+	}
+	mutex_unlock(&h->mutex);
+
+	return ret;
+}
+
+static void luo_files_finish_one(struct luo_file *h)
+{
+	mutex_lock(&h->mutex);
+	if (h->state == LIVEUPDATE_STATE_UPDATED) {
+		if (h->fh->ops->finish) {
+			h->fh->ops->finish(h->file, h->fh->arg, h->private_data,
+				      h->reclaimed);
+		}
+		h->state = LIVEUPDATE_STATE_NORMAL;
+	} else {
+		WARN_ON_ONCE(h->state != LIVEUPDATE_STATE_NORMAL);
+	}
+	mutex_unlock(&h->mutex);
+}
+
+static void luo_files_cancel_one(struct luo_file *h)
+{
+	int ret;
+
+	mutex_lock(&h->mutex);
+	if (h->state == LIVEUPDATE_STATE_NORMAL)
+		goto exit_unlock;
+
+	ret = WARN_ON_ONCE(h->state != LIVEUPDATE_STATE_PREPARED &&
+			   h->state != LIVEUPDATE_STATE_FROZEN);
+	if (ret)
+		goto exit_unlock;
+
+	if (h->fh->ops->cancel)
+		h->fh->ops->cancel(h->file, h->fh->arg, h->private_data);
+	h->private_data = 0;
+	h->state = LIVEUPDATE_STATE_NORMAL;
+
+exit_unlock:
+	mutex_unlock(&h->mutex);
+}
+
+static void __luo_files_cancel(struct luo_file *boundary_file)
+{
+	unsigned long token;
+	struct luo_file *h;
+
+	xa_for_each(&luo_files_xa_out, token, h) {
+		if (h == boundary_file)
+			break;
+
+		luo_files_cancel_one(h);
+	}
+	luo_files_fdt_cleanup();
+}
+
+static int luo_files_commit_data_to_fdt(void)
+{
+	int node_offset, ret;
+	unsigned long token;
+	char token_str[19];
+	struct luo_file *h;
+
+	xa_for_each(&luo_files_xa_out, token, h) {
+		snprintf(token_str, sizeof(token_str), "%#0llx", (u64)token);
+		node_offset = fdt_subnode_offset(luo_file_fdt_out,
+						 0,
+						 token_str);
+		ret = fdt_setprop(luo_file_fdt_out, node_offset, "data",
+				  &h->private_data, sizeof(h->private_data));
+		if (ret < 0) {
+			pr_err("Failed to set data property for token %s: %s\n",
+			       token_str, fdt_strerror(ret));
+			return -ENOSPC;
+		}
+	}
+
+	return 0;
+}
+
 static int luo_files_prepare(void *arg, u64 *data)
 {
+	unsigned long token;
+	struct luo_file *h;
 	int ret;
 
 	ret = luo_files_fdt_setup();
 	if (ret)
 		return ret;
 
-	*data = __pa(luo_file_fdt_out);
+	xa_for_each(&luo_files_xa_out, token, h) {
+		ret = luo_files_prepare_one(h);
+		if (ret < 0) {
+			pr_err("Prepare failed for file token %#0llx handler '%s' [%d]\n",
+			       (u64)token, h->fh->compatible, ret);
+			__luo_files_cancel(h);
+
+			return ret;
+		}
+	}
+
+	ret = luo_files_commit_data_to_fdt();
+	if (ret)
+		__luo_files_cancel(NULL);
+	else
+		*data = __pa(luo_file_fdt_out);
 
 	return ret;
 }
 
 static int luo_files_freeze(void *arg, u64 *data)
 {
-	return 0;
+	unsigned long token;
+	struct luo_file *h;
+	int ret;
+
+	xa_for_each(&luo_files_xa_out, token, h) {
+		ret = luo_files_freeze_one(h);
+		if (ret < 0) {
+			pr_err("Freeze callback failed for file token %#0llx handler '%s' [%d]\n",
+			       (u64)token, h->fh->compatible, ret);
+			__luo_files_cancel(h);
+
+			return ret;
+		}
+	}
+
+	ret = luo_files_commit_data_to_fdt();
+	if (ret)
+		__luo_files_cancel(NULL);
+
+	return ret;
 }
 
 static void luo_files_finish(void *arg, u64 data)
 {
+	unsigned long token;
+	struct luo_file *h;
+
 	luo_files_recreate_luo_files_xa_in();
+	xa_for_each(&luo_files_xa_in, token, h) {
+		luo_files_finish_one(h);
+		mutex_destroy(&h->mutex);
+		kfree(h);
+	}
+	xa_destroy(&luo_files_xa_in);
 }
 
 static void luo_files_cancel(void *arg, u64 data)
 {
+	__luo_files_cancel(NULL);
 }
 
 static const struct liveupdate_subsystem_ops luo_file_subsys_ops = {
-- 
2.50.0.727.gbf7dc18ff4-goog


