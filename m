Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B30E8CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 11:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FA68E0005; Mon, 20 Oct 2025 07:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1770F8E0002; Mon, 20 Oct 2025 07:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D338E0005; Mon, 20 Oct 2025 07:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBE4B8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:54:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AC75160131
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:54:42 +0000 (UTC)
X-FDA: 84018335604.04.F4E9ADC
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id CC71EC0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:54:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mAbichEG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760961281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JfZtgTFC2xLW8JG3Sq6LW+Xtc+Hd2xSva1xfVO5ocOM=;
	b=6Hgpy9MpyWm7ahwdsOdj16qDnBmzLuKx7tqRPKJ0NcY5p5XvcGxj115mAm9K0fXyf+59Oh
	5adYOzBYpx0GHsCw5+PPC6QF5wEp04vwUUQSuWCYaUZbl1442n63SFt6aOTSUUqbd+iwtS
	RpyD7UcRX9B07hvPzb6uxRhCT+33X04=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760961281; a=rsa-sha256;
	cv=none;
	b=BZUWhj43liDV+JZhw1bmTRZYHvYK5V2KcaHvTZtF1XhAEskqyIYcP1YjDmjYOV22gQFtNT
	PAiwXRQ2wUmpliRF0N91r1xMIQqQerhugKez8HE4xhm4UvbisPEr4M+oa1//BmdUNi1Dl1
	NTzVWsZ63lj6DcYWPAmlymfjGOlM2Ko=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mAbichEG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760961278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JfZtgTFC2xLW8JG3Sq6LW+Xtc+Hd2xSva1xfVO5ocOM=;
	b=mAbichEGPv3VKI6LwexBRgoU/QSVuP1fYQO99ezWI1n1Y9z7jBmcwlKAgQZ369iGYvMc++
	014QRmCT4doHj8SYo0rib32gNQFkfqMJqxuEDFuTRhbHnMboLzF7GyB5AoxXJ6zZgSN4Vc
	DuOZJ1lnrFVNM4rrDwQKvRMgcc9/LiM=
From: Leon Hwang <leon.hwang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Leon Hwang <leon.hwang@linux.dev>
Subject: [PATCH mm-new 1/1] mm/khugepaged: Factor out common logic in [scan,alloc]_sleep_millisecs_store()
Date: Mon, 20 Oct 2025 19:53:50 +0800
Message-ID: <20251020115350.8175-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: CC71EC0007
X-Rspamd-Server: rspam02
X-Stat-Signature: nadte56adwofpqn5wymsppmye7sj1z9m
X-HE-Tag: 1760961280-649314
X-HE-Meta: U2FsdGVkX19UlPUEq9AliXbRLUh+sJHgTfzzKw9w1+MaIrd5AVwIRnedrYLxz+kzwx3t0rpy1IYaAFe8INkmJQ1kb+1kKbTKpPlpSLlMqMTvTgL7m9S7pi310ufnDafvI97GwGPqS9faXoS/cqAP/uk8n2VZQ1T9CgcxbcyIZE6unRR0DOzGOd9JvurNOXglpflGyIOWNvIKK7aQZFs/E8V+71Nk4Quz7vNykvJiKeZ+Ypqb5IyN4ej7Pmarnofe0Bdc4eg39aVc3YiO9R/VMozm3wlnVIuQq2tMni9ZxP98J0OTfjmxzqoTpxOoaKdzQPGAxRNbmrM7FLxPXfOmNwj08JtBBGqtVwaWwQ4JY8QQmzzW+ZEhVGjHl/h7vWGGnX6T4edpDW+iXet2BG1bma/9gHumNQGLS5PvaMef10SsULaKYDD1TkCTSTCI2C7kNtDvn5vi8/gKlI27bTKFCJZN96W1+pjAhvAVvAywTVx+zjzWfzGvLx+srOU+sqyoO542G/HG4g4bvPp+Shr2noogHmgDynHSph6x7D/NQDtz6UBH5d2m6x3/M4zQxKTaEvKNbdLa5ddRyThGVgtJ8rdD8reyzD46sQAPz3zpQToRdX7DnTHN14FSHfgDBadkycqnkjyMZwRiSU/RQ8cXtzZp872e9L36suPKXx+hJeMD83jOc7/MnW7WqvRnOxKNI5vfGQGGH4kUFKwfMfqFKP3rXi0qhDTgefgGGBYRFpoXJMl6ZHcj7UTVPCaPQJMp2pDeJV9o72MNfzPU5C9RmmZKT/iH0t1gGjO+bC1Q0arR0ECY+yccxUZicfjHnTVyT3tCDFVKYq/YASZbptn/AyU+RJlMHbcyz9bm6VJL2CEYXD4LKyxVccI+H9g7KVsSBesRGmvslKknopu0eVl27ov/TvAUulwADqZkEGNu5tLzrCqttbkDmAs8B6TPQCTXKmFEbSF/wwEYAPhs/SZ
 SsxK8CMZ
 mHX3ZfNKYrpQJZnmitQF7mI85Q0tPzWO+3tMt/IBx7Yx7V68sUxSPsbhGT3IdNWrBr74AJi+JrnBK7VWHlWFypajLFXAaWtogzDrDupRkn14CPW7hAazZN9xEMu+AyyRN4g9Kn4z4E4pcZmJ4ZK5/QE1vx9Q+oopNFPqwL4qSa5+qC83cfu103iiqaZy039p6Tuzks28n6PMWl0v8EW0EgWaww+/5gG9/itdxH7k8xx6STh76maJ4Atjf8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both scan_sleep_millisecs_store() and alloc_sleep_millisecs_store()
perform the same operations: parse the input value, update their
respective sleep interval, reset khugepaged_sleep_expire, and wake up
the khugepaged thread.

Factor out this duplicated logic into a helper function
__sleep_millisecs_store(), and simplify both store functions.

No functional change intended.

Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
---
 mm/khugepaged.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0341c3d13e9e..0b7915015e9e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -129,9 +129,8 @@ static ssize_t scan_sleep_millisecs_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%u\n", khugepaged_scan_sleep_millisecs);
 }
 
-static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
-					  struct kobj_attribute *attr,
-					  const char *buf, size_t count)
+static ssize_t __sleep_millisecs_store(const char *buf, size_t count,
+				       unsigned int *millisecs)
 {
 	unsigned int msecs;
 	int err;
@@ -140,12 +139,21 @@ static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
 	if (err)
 		return -EINVAL;
 
-	khugepaged_scan_sleep_millisecs = msecs;
+	*millisecs = msecs;
 	khugepaged_sleep_expire = 0;
 	wake_up_interruptible(&khugepaged_wait);
 
 	return count;
 }
+
+static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
+					  struct kobj_attribute *attr,
+					  const char *buf, size_t count)
+{
+	unsigned int *millisecs = &khugepaged_scan_sleep_millisecs;
+
+	return __sleep_millisecs_store(buf, count, millisecs);
+}
 static struct kobj_attribute scan_sleep_millisecs_attr =
 	__ATTR_RW(scan_sleep_millisecs);
 
@@ -160,18 +168,9 @@ static ssize_t alloc_sleep_millisecs_store(struct kobject *kobj,
 					   struct kobj_attribute *attr,
 					   const char *buf, size_t count)
 {
-	unsigned int msecs;
-	int err;
-
-	err = kstrtouint(buf, 10, &msecs);
-	if (err)
-		return -EINVAL;
+	unsigned int *millisecs = &khugepaged_alloc_sleep_millisecs;
 
-	khugepaged_alloc_sleep_millisecs = msecs;
-	khugepaged_sleep_expire = 0;
-	wake_up_interruptible(&khugepaged_wait);
-
-	return count;
+	return __sleep_millisecs_store(buf, count, millisecs);
 }
 static struct kobj_attribute alloc_sleep_millisecs_attr =
 	__ATTR_RW(alloc_sleep_millisecs);
-- 
2.51.0


