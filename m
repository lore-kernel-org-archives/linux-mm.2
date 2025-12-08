Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED42FD3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C0C66B00AB; Mon,  8 Dec 2025 01:30:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC176B00AC; Mon,  8 Dec 2025 01:30:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313206B00AD; Mon,  8 Dec 2025 01:30:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19C9B6B00AB
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9DBD52F5E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:36 +0000 (UTC)
X-FDA: 84195330072.23.C90C51B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6081480007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lPzC8mFh;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175435; a=rsa-sha256;
	cv=none;
	b=ompJdZc2G2HXlarVBbFTw7IeJb/o5LEm+VdGdnxsxQ+KFe0Gfne1xkjYvpSQYpOKDPPVxV
	fc6G30ykZAOKgEAjsXtl7+zoqKQ+aQxLpFOCwtjpJgENlDWW/8OrqfIAprPMLuEqX6X9OG
	V4MLkWpdg0BbgIX3z0Wvagb4E6ptoBE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lPzC8mFh;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4WlPeXE9amujcZTP8h9sRpf+CxhEAFaROSbFlM2lgME=;
	b=j4pD0Z9QdMHWolzUus6XRM2xt3+OxigxzPUQPfDfXlyPCqjtBaRi8mTEJgBemp9xE3e5F8
	8IHrLfdkym5jFIhPz2hp3FuDyZGScvYSjJ3PlZdIcwRcLLUrkw6oCG0KpKEqSlCz8OEG9T
	xyZGQU4iuS+2tNuyfK3l6iEe+RFpsXE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F017560174;
	Mon,  8 Dec 2025 06:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AD8C19421;
	Mon,  8 Dec 2025 06:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175434;
	bh=3JZCkxkL4i/kCYq9wc6IiaTGi5wDXb4PyYdbk+AUHf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPzC8mFhApK44AZvUzvwj+vo6IrDlAMEE5iJ9ohs4vVx8YFqcfCPEy4nxJfKP1ppg
	 6ZznWeeXOhkl3NdXCkNyJU1vNhCTA3vjJmkw8vn4SnWbB44QcpBDsEVdjjP7SCY4c2
	 lRXZOJ1wVVY6hvlcor6fZLEeZcUdvZ2wqlRGMwZwcslxW8ohkFxNZpLvEqmJycs4UK
	 jOLUzQfTZMD45lsKWkW7xE3U0OYt6sG0g5PiUjkz3WJyt1t79cpLPtFIhiGsF6AEwY
	 eIzvmmkUmC1s8ca5DE672uyCZFaE0sPqSuNXj8g+1pzRf4AkUgqzCih/TEz5hTeYbk
	 y7ENPFpbIzg9g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 30/37] mm/damon/sysfs: support thread based access sample filtering
Date: Sun,  7 Dec 2025 22:29:34 -0800
Message-ID: <20251208062943.68824-31-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6081480007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: kthp5wkjyh93ost38xcp8hx8qzzk6syi
X-HE-Tag: 1765175435-738602
X-HE-Meta: U2FsdGVkX18ZpsRK7Kd+VXNJ6HZOOrLjZ04/GrAMI4K/NxEP+VeWkugyPa+zcqXisPnpaIt4gMefmxs+dF50sFDZGlvRyBVSk1UFNqwJGmSoEQT7syfoFte9KROSmf5nNhL1fuUPot6dgDJFwk2t1w4Wrei5wojj/k7zIBTgc3vCnhxn+xrEufTfHnWNbmbtExUj7JLhrw/XJLpC1Q/Um56Yt57l5SbicJoGiOWWj8Vx5yDqVWEsO1o5rJRsVY+7RdFyij7Di3JefPKgqCmtp1gA+9aIMLpv/4RXjhDljso+5lPxMb2jpjemnZ0r4vdIwVJKvtBq+B0r+GmELbtaIaY1h9w0VHi7Ou3jE0jzlA8N44BGMFliJPrR89tnp+41dYbL1Iipi724EnOhS2i867GYhitm6h5d9t3yQlvjdXi27Madg8L0v6xkkOW1CA993lpB3fdgBg/j1lb0enfsZ+eJsfkpIHgeIN9EfTiZ+6RgrvhODfctra3OSKKfeIXyFNxHiwvEeSLh7uXs580ZHTKjo+idU7JvxYF9gKjQ2bXJp0LX7RJJXPmgzJFGLItvAptnE36xEyiCzx0/ws2P3704ooRBYvVwgKlKmn0fW4uis5HUjTgX7KsEHQU40lfAcuiV5JtwGpD3oU4WOOR0deLvHNTN1V7fneGb/5yoIxo/oZWjd2H16SayCkgOuKWDZTx2edyWSA5skfn4RfyJDanx27jk29qkruOWxKLyi47mjOgukLZ3lOAh4KWOQNKvCoaAFiBUkswULvxNxqrgpo5uMWMdFtoc6r4uNt28pSvhYB9p4ZLOFXEBlDMPzuNHqh/s5C8xR1E779Cn7zo2dnpN/K3PMz3r9GC8U4BFkq4HYlJ5ptzbVKnhygO5rw+GAGKSlSKlvNSoFKpSeLt5H6pu14O1wsuaergycND9kcre0sd9Vk2RHkibvx3OCWQy00BT1BetHzCqxs9uXMi
 ySYa/ND8
 1QCb+9uJDiKQMJdHTD+SYfXmPvOwVkmwZd480tDdcpEglzCjw5f3cXFK0r5Ua4xAhOi3baKPapGd6FFIJY/nlfrVDgj6haJhwjpitVDRl9CgMc5aFgq/CU7d6wnLmuuYZ2ILOov9CB9NzLLK1G4qlWwkBOWj89DilGRRJfPUc30E2fUo+BkfFbAzGuslKRhiKaHJPujPdNQyvYZrnjwRN7Uvr8F5QtQ8ruFewGrSGcC2cc9PkaWfnVk1icxAzF7JpVHYnV3O3vsDeo6w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support of the threads based access sample filtering on DAMON sysfs
interface.  For this, add a new file for setting the threads of interest
of the filter, and pass it to the core layer.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 3aac2aea6b0c..b96df2d2d17e 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -759,6 +759,7 @@ struct damon_sysfs_sample_filter {
 	bool matching;
 	bool allow;
 	cpumask_t cpumask;
+	int *tid_arr;	/* first entry is the length of the array */
 };
 
 static struct damon_sysfs_sample_filter *damon_sysfs_sample_filter_alloc(void)
@@ -777,6 +778,10 @@ damon_sysfs_sample_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_CPUMASK,
 		.name = "cpumask",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_THREADS,
+		.name = "threads",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -888,6 +893,47 @@ static ssize_t cpumask_store(struct kobject *kobj, struct kobj_attribute *attr,
 	return count;
 }
 
+static ssize_t tid_arr_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_sample_filter *sample_filter = container_of(kobj,
+			struct damon_sysfs_sample_filter, kobj);
+	char *str;
+	int nr_tids, *tid_arr;
+	int i, ret;
+
+	if (!sample_filter->tid_arr)
+		return sysfs_emit(buf, "\n");
+
+	str = kcalloc(2048, sizeof(*str), GFP_KERNEL);
+	if (!str)
+		return -ENOMEM;
+	nr_tids = sample_filter->tid_arr[0];
+	tid_arr = &sample_filter->tid_arr[1];
+	for (i = 0; i < nr_tids; i++) {
+		snprintf(&str[strlen(str)], 2048 - strlen(str), "%d",
+				tid_arr[i]);
+		if (i < nr_tids - 1)
+			snprintf(&str[strlen(str)], 2048 - strlen(str), ",");
+	}
+	ret = sysfs_emit(buf, "%s\n", str);
+	kfree(str);
+	return ret;
+}
+
+static ssize_t tid_arr_store(struct kobject *kobj, struct kobj_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct damon_sysfs_sample_filter *sample_filter = container_of(kobj,
+			struct damon_sysfs_sample_filter, kobj);
+	int err;
+
+	err = parse_int_array(buf, count, &sample_filter->tid_arr);
+	if (err)
+		return err;
+	return count;
+}
+
 static void damon_sysfs_sample_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_sample_filter *filter = container_of(kobj,
@@ -908,11 +954,15 @@ static struct kobj_attribute damon_sysfs_sample_filter_allow_attr =
 static struct kobj_attribute damon_sysfs_sample_filter_cpumask_attr =
 		__ATTR_RW_MODE(cpumask, 0600);
 
+static struct kobj_attribute damon_sysfs_sample_filter_tid_arr_attr =
+		__ATTR_RW_MODE(tid_arr, 0600);
+
 static struct attribute *damon_sysfs_sample_filter_attrs[] = {
 	&damon_sysfs_sample_filter_type_attr.attr,
 	&damon_sysfs_sample_filter_matching_attr.attr,
 	&damon_sysfs_sample_filter_allow_attr.attr,
 	&damon_sysfs_sample_filter_cpumask_attr.attr,
+	&damon_sysfs_sample_filter_tid_arr_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_sample_filter);
@@ -1952,6 +2002,25 @@ static inline bool damon_sysfs_kdamond_running(
 		damon_is_running(kdamond->damon_ctx);
 }
 
+static int damon_sysfs_set_threads_filter(struct damon_sample_filter *filter,
+		int *sysfs_tid_arr)
+{
+	int nr_tids, i;
+	pid_t *tid_arr;
+
+	if (!sysfs_tid_arr)
+		return -EINVAL;
+	nr_tids = sysfs_tid_arr[0];
+	tid_arr = kmalloc_array(nr_tids, sizeof(*tid_arr), GFP_KERNEL);
+	if (!tid_arr)
+		return -ENOMEM;
+	for (i = 0; i < nr_tids; i++)
+		tid_arr[i] = sysfs_tid_arr[i + 1];
+	filter->tid_arr = tid_arr;
+	filter->nr_tids = nr_tids;
+	return 0;
+}
+
 static int damon_sysfs_set_sample_filters(
 		struct damon_sample_control *control,
 		struct damon_sysfs_sample_filters *sysfs_filters)
@@ -1972,6 +2041,12 @@ static int damon_sysfs_set_sample_filters(
 		case DAMON_FILTER_TYPE_CPUMASK:
 			filter->cpumask = sysfs_filter->cpumask;
 			break;
+		case DAMON_FILTER_TYPE_THREADS:
+			err = damon_sysfs_set_threads_filter(filter,
+					sysfs_filter->tid_arr);
+			if (err)
+				damon_free_sample_filter(filter);
+			break;
 		default:
 			break;
 		}
-- 
2.47.3

