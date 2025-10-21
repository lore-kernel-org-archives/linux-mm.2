Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422EFCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12548E001B; Tue, 21 Oct 2025 09:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9D88E0009; Tue, 21 Oct 2025 09:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926B78E001B; Tue, 21 Oct 2025 09:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 809288E0009
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:45:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B33211A3B8
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:45:40 +0000 (UTC)
X-FDA: 84022244040.05.7F58EAE
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D98A4000D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:45:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t8o4u0mj;
	spf=pass (imf27.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761054338; a=rsa-sha256;
	cv=none;
	b=DMBMULmbEuRpZYx8U5pjckH+M4mWoOOUpi96IDTOq7omKMRL9H1UkIahLyukzVmdiyXMef
	VHLEvPiIMRCoh+Hh7Vo078wNwMoGP6b8Jm5PQ1Rk5+F15SSIVd0YuAJH6eVmANd6Wn/Skv
	FYZ3ot1CgCGcBDOkPyTDTPj/ZCcVigs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t8o4u0mj;
	spf=pass (imf27.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761054338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=U3IAMZcKI0CNuYk+5K7fOPsEQkH4wvzXZfY4YoK+dkg=;
	b=uvcn7OD9Vl09YR/rZ6981iQpCZdmWrde1L1Z1BhvEGjkWxzIApPmp8ojcUg9G5np1mQMfP
	lmljFrQj7SD0mHOSW2qezTRR4oDShXfibTgVRlHXQIsZO8MFx1TybqQNKjAjz3eekXHL0T
	KxC0d7/W4TKBIqWoXWJwMoyZB1H5wcY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761054332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U3IAMZcKI0CNuYk+5K7fOPsEQkH4wvzXZfY4YoK+dkg=;
	b=t8o4u0mjO5fMJbKLrCBGg0yMIR+ZV58xYt0Ro2LpIlpKGKOwpHiskWUe91eeejMB8y0B4K
	FoBvZgWO1n0NaLJBwdLQxQKRkBvJ7tvNpBvOFFanEga5FGFVTFl+FK5BwEXFP4DXdmheWB
	gnPssnYFuD4R4tfD76xHYFhzags6N/Y=
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
Subject: [PATCH mm-new v2] mm/khugepaged: Factor out common logic in [scan,alloc]_sleep_millisecs_store()
Date: Tue, 21 Oct 2025 21:44:31 +0800
Message-ID: <20251021134431.26488-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: nzydqqms4eazbsr6zgtzsyund5ixebqp
X-Rspamd-Queue-Id: 6D98A4000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1761054338-771366
X-HE-Meta: U2FsdGVkX19A9cy8GR3IqAPvcuYQH0YzA5FA02ubL4FqpOCaYZA69n85B9CJU4grsX3INTRMBG/lwgcpjzjtkr3xkFRfvD0LYSkzUMt+aWdOifkguouaY1SO63mqXR1KEdzlI9YRbf06D30RWXUGNGad66JnkuN0K/Y7itjEpi023mbg6qiXO9SKp7nMN08tjUvMhrdCTw5xM7FDs/SbOtnPidq+OD1LdT3HJO4qJa6RlDH+w7Gpu2vY3DE1BW2fvSV66oFwgZTWSSpI2mrDxPJR6GViyQvkVEW0wyHHoKweDspfm+xVqUNC3iZUeIek1Ky1PDtE2xmrotSt1xR4fChjChZ5JludeadlcojDrp2tI6smgnZ1RgfDosGTcnTfnbcQUXmfDz4YmUXU3xpQWppteX8/25tmPgmhvj4SJiCUhVX5jENS2K93lh/cN2jp8tfTyj3viwN0cBlAwX5MWGr0ZyqM3nsQx2NUV4pGpWsltjxla7KMcxqj+Dhxl+Pu5kmC2s2f2G4H6LS7jcf0znUvHWVCLyb+H4/EcqaL5hWRQMwgKeDzyU+tNo4R4uMzPjvKAEVTIyr2Zu5T6YVkqRZHBhAK99qNKyhyNXDR8aosYpblY9urEM5pIPYNFhsxSt5A/kEmujOVfdThJ7jo7XYk/hKnsJJV0Udfm79UV2cH/fYcONP/v9FI6U+pti73Ha88cRxKxq0nFpwQFOJcJ8Uhnx9lD5KctkGV6olwcrY6lmsQHEn8IZufJTF5UaPn2rU9IJfXqoMxPUQ49qujI+uP/huq17yk8i7brLTCOfrqQw1CXUTSUtkuUOaC+du7TLzGnPhkGbf0UuOOAWOe6Gf5eSRyX9WDZbAG2A/ZOmo2MyytFR6+NLLISTPxUbBbfdtY4zXv4/l2U/z7+Q8DOjK26MYiydiKAO3f+88YP8pUHApYG/dp3nQh6XpZrtwfZgmavUPuIJLXCGe/3p/
 YCJuIVPD
 Uj57KqmAKnw4KeA1njPuDx+SO180KgXnpkN+nDaq8iR/+dxRUyYqlLpmUSp3fVQ9bsAsOFteudaJKn6SKVQAGrC+Cabr1jgroh3WNdhV/mKupfpUVPHhdiIe5Na9HL2O1w23RBfCKPt6lDEE6hjZV12NTIf6iUiLqzMcsLl2jCeA2VOb7pU0Y81HE7bhQRxf+k511QL1r+dyJZ4hZVReugT86FxDV44IS3VEUKzFvbd2Gbf6dzvrR/7mN5NduysrffLyMrlJHzY7SvOGTBwpmZds6T9MLMg+A1DbdwShxo37VtUNPfHgq7P+EoRv0ycKzl1Fq
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

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
---
v1 -> v2:
  - Simplify callsites of __sleep_millisecs_store() (per Lorenzo).
  - Collect Reviewed-by from Lorenzo, Zi and Lance - thanks!
  - https://lore.kernel.org/linux-mm/20251020115350.8175-1-leon.hwang@linux.dev/

 mm/khugepaged.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6f2ae2238b5b..5b7276bc14b1 100644
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
@@ -140,12 +139,19 @@ static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
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
+	return __sleep_millisecs_store(buf, count, &khugepaged_scan_sleep_millisecs);
+}
 static struct kobj_attribute scan_sleep_millisecs_attr =
 	__ATTR_RW(scan_sleep_millisecs);

@@ -160,18 +166,7 @@ static ssize_t alloc_sleep_millisecs_store(struct kobject *kobj,
 					   struct kobj_attribute *attr,
 					   const char *buf, size_t count)
 {
-	unsigned int msecs;
-	int err;
-
-	err = kstrtouint(buf, 10, &msecs);
-	if (err)
-		return -EINVAL;
-
-	khugepaged_alloc_sleep_millisecs = msecs;
-	khugepaged_sleep_expire = 0;
-	wake_up_interruptible(&khugepaged_wait);
-
-	return count;
+	return __sleep_millisecs_store(buf, count, &khugepaged_alloc_sleep_millisecs);
 }
 static struct kobj_attribute alloc_sleep_millisecs_attr =
 	__ATTR_RW(alloc_sleep_millisecs);
--
2.51.0


