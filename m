Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4055DC88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 01:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84E9D6B0096; Thu, 10 Sep 2026 21:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8156B0098; Thu, 10 Sep 2026 21:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B346B0099; Thu, 10 Sep 2026 21:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6EA6B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:13:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F3651C28BD
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:42 +0000 (UTC)
X-FDA: 85199709084.25.774A7AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1C93E140008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=By+QnNE9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789089221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6W4HqJKZTtS8lrUgM9flAHj2CUZu3m4em5eZnB2Nzv8=;
	b=2WDLlF2L/jGV1vVCH/bp7PKFbxrFUBmRMDLwRMb0OO+IknwWvdpotzZ1lnJXBxM+D0AwcH
	l+LgHSASHPEu5Yy8FsAwktiEfoD6YwePFNWkUnNnpAfG/yaNsYjr9CvKax9glmoqoWvGVm
	1kUA/PUPkkecNn2LTfT/rwcZD4s0keQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789089221;
	b=DZeWzq2Bwn/4zdd00J+MucaYP/+q860lhLIcRKSHMJLPUASUHBTc6KtMoZepre4yY8qSwA
	MXQ+1ztA/tR4OAJJxWJDmQjj3HiAvgsB7WF+eTuPZcVgT+XVYOg+KK5qo5MtLU9TSLEHla
	3t/Vulg71ToLoUAsbvB4c8m9s9iYdcA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=By+QnNE9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2796060202;
	Fri, 11 Sep 2026 01:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79BD1F0089C;
	Fri, 11 Sep 2026 01:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789089219;
	bh=6W4HqJKZTtS8lrUgM9flAHj2CUZu3m4em5eZnB2Nzv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=By+QnNE9go4mKfn7GmKuFDIM9o92tXdwMct7p5PUR31gHqyTNHzSgJ6XCR4PJ5W8p
	 SlRsQXFWMBLcEFckzTmevCUw9InR7EbgC0zUq7P0YGC/UWswIc0K7peOKwYUkrriHW
	 Rw06moqhyRMDxAOJH8V7p5XY8WEwPCEjUfzgTW99X3bEJL6fiK9+cD2FbG28RPUdrx
	 K3n4fVxOFvx6q1cLrSoyv+rWVx6bjTSviV7nLAnc0lhT+Ruwl5CxuZIMVEHjChzmS6
	 6c3US9IKBa9pWquwSHj/mK6C4HLxQhQjBnNK8vID6mJx8LFtofnPbnakx8HqkVaLf+
	 6AxsIp2pA6P0g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 5/7] mm/damon/sysfs-schemes: support probe_hits_wsum damos core filter
Date: Thu, 10 Sep 2026 18:13:26 -0700
Message-ID: <20260911011330.93678-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911011330.93678-1-sj@kernel.org>
References: <20260911011330.93678-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1C93E140008
X-Stat-Signature: 9o6t8ehkxjohpxmc8eyycc9cxggpxki4
X-HE-Tag: 1789089220-749988
X-HE-Meta: U2FsdGVkX1/O98WFb3fHZ2m/a9CM8mKCnln+uk0GveEQ6j9jPUVRibMEekzClArrJMiT/ch4N09wl6PLLOd3YC+oYfsdHU3yndbYidunLDpQj/+cS+lED7IHvuyI45Zwdy/qQmQ63G1y3f5GjGmr7IzSZibqflT0cptaFwKn98i9tXDYC115GJ+p/YC0lCoq7r6L3spSb4/XRXq2i5wss1L3ZFiJDQyhfTE4+hEK2+5cz4N4MEYJ/UEzKaxT8CegLbgQOeJL+TfhD642lzDRkgNkPp0n+b/rnFPW665KDye57DM5neI+yfKj62EqlZ938+pzMKFhgNGpnqB5pbhq21Gzp+oJCpX0ar+mE0fK6cPQDAO522aOxbZYMONLazzTP6WxXnFnI1rDBzXhjkBXgDZxpDBWcJXdbL/cPGg71oGkAv20YUWo0C6VYT5adIa9cg7jPBOai4Yiip9RDYhoqse+ljzCGnRdbj+EUtfL0YHnzsP8LhpZds1YtPQVHhdwNi7RP7f7ntscwtLFcLAPbFzuaz+q6HqDCNI+aTc5VwBgmsIVVSR/QsebtL8IvUtMSfgT8zKaP6zeEstiH/vUcNkrw0EmnVMQLmkOEV/zfT9hFDkf+Gjqy7tj8Ri6oAiPkoe931xBLAbJc4LLXYsNHVvnUhSYnv5mjGFD36fs72biRdd1P5gZUG1hp3BNG0QMDhFFFXtnHGu9BU5jL2GnuoNie7yow1QbSY8h3INVpMI24WRVpSold6slmPOo+BVgR4RoQJte65riOnip0YsiFjFwg0VNkX+8CjOZTAXn585eHu0mAPQ2bwlu3LY6wLbySH/q/tswKXoOSyyvTAA5WokD/V5ccOhd34r6Ke6kZGmaK6HykInBE6cM49PRJfx1KoZLcX7+tsMoTCAkSSHFRQmXxj6dEPFre9KsT49uETSXTHMzm8Wf54wRrLgPe5gYzmYOGtID72CH2L30UFW
 Vh7Vjjfy
 kwOOay7h3fLNfkfmtXmXx8k5FHoLx3ratw5XInxQv5OZYMzXNXSRrfdUW6nig9nI2wrvVC+4Go17mQpxgpkHIxmY89Bpsw7Mtj2FqJaHcyAuttSZ2Hzt8IWz8phOirkxSjUeuVZfuDdaJwJDgGrHW1lhezxUAR1LfxTAmZm7Hw4ZL4BZA9TKhtVI+//zUy6Purbg3PlRSGX4PI6nZS0b/si7m7XBCJ6biD5I0Kl/hyAEEIwKZCExG7H7tw/DtgyuIefkIWYvneg9FtE5RZmVYBf005g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to support probe_hits_wsum input.  Also
update sysfs input based scheme build logic to setup the min/max probe
hits weighted sum range as user provided.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 4d9147d2a269e..3de4d804e049f 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -589,7 +589,10 @@ damos_sysfs_filter_type_names[] = {
 		.type = DAMOS_FILTER_TYPE_TARGET,
 		.name = "target",
 	},
-
+	{
+		.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+		.name = "probe_hits_wsum",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2844,6 +2847,13 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 			}
 			filter->sz_range.min = sysfs_filter->range_min;
 			filter->sz_range.max = sysfs_filter->range_max;
+		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
+			filter->range_min = sysfs_filter->range_min;
+			filter->range_max = sysfs_filter->range_max;
+			if (filter->range_min > filter->range_max) {
+				damos_destroy_filter(filter);
+				return -EINVAL;
+			}
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

