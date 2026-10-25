Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5D87606A330
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JIe4dQ9q
Received: by kanga.kvack.org (Postfix)
	id D71716B05B4; Sun, 25 Oct 2026 12:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB4B6B05B5; Sun, 25 Oct 2026 12:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9AC6B05B6; Sun, 25 Oct 2026 12:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92C886B05B4
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 12:48:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 03239805CA
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:48:22 +0000 (UTC)
X-FDA: 85361731686.16.D1CA26A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 62DB51C0003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:48:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JIe4dQ9q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792946901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aV53s/thMev0qSzH+ayYeyKX09O6kEW4ly1bV0/xJfs=;
	b=Lhxpqjv7FxkyJxpkp8B8gpT+k7owx3MfEC+D0Fzu1B4vhQya7X77mciieUdyxQqAjdAKkl
	hP/gQG9Wgk4wEEEYHP2FDpkXI8MLvpXWeBP4TuyLSmT1o+iaWgD7l2TrEikReBq3T26VqU
	KWYVY/kPd5Ld4AmZICmuhUNT1BktpwU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JIe4dQ9q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792946901;
	b=qEY1Ues89OjLL+Tl/jYvozQP7KG4U3YFqOc8TJyURwTLk0GwaTOJpAlcuLiNQNiigQCJXx
	J7gvIDsr574uFy3tcVZ9CPNJURgoO0pRYLNvijwb44duWykz+/FWZIt1OSGBAWauqwOu6N
	Z3BHIELyCqOX88CYiLFGkPpbnVEzRUE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A89D440702;
	Sun, 25 Oct 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6C91F01829;
	Sun, 25 Oct 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792946900;
	bh=aV53s/thMev0qSzH+ayYeyKX09O6kEW4ly1bV0/xJfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIe4dQ9qRQgWpsb/mRrXjKCjVVbAKxbT6CyYHEfHil+iMfY9QDQpl4SnqHqhXa3ZN
	 d7Pjd5laCwnvrJFS3zP5mPQL9NVXYkisr6Z4fJD8UW11XmKAlkrlNjzgKCR3DwdmlP
	 d8Tw/x4VxMpdNL5pMz06JQetUNROL7/E+wYHHsqt0g0OZ4xivpDk7u2C/bD7cFoqk1
	 WU1JwW8YyN1Of8fiPpEyAJvjXi6sjsh3RNu2ZuP4GxQSWCCmi0yQ5lfqUYSoasHI2E
	 ljrX4OISIStTzZfidTBBU94ItWf/q3DP0E7911YIJYRowJL+fJl2Tj1aDXPpgkbr5Q
	 yXt7XVHdPRgQQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()
Date: Sun, 25 Oct 2026 09:48:04 -0700
Message-ID: <20261025164808.152048-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025164808.152048-1-sj@kernel.org>
References: <20261025164808.152048-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 62DB51C0003
X-Stat-Signature: dzd7e4dtqtkpc11nyk8nxqu68idjyeri
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792946901-785672
X-HE-Meta: U2FsdGVkX1+SJrVGjrNB6q2n1Exv9w1yMI4mzfclg/02APcZGUsK5+0WGc4itZOqiOhyt4NeKbDNyWsJ2F8Mk/BKPvQtRUgZmYTwbSJQ49UWPBf/SYkKvoSqddOpxZedDk88zRzqhXtFZrs8AmlqgCbekTkTNyEllZn23UAph4dPHT8QgO8taVQ3xyvb1AxNKnWK288yQoDDL4dFZ4ZGu/NJBvTJjDUObVcYVsBgeECo6jqBV8dtCBgtkVA464bV8wbUkbM2Cwk9rcdnNr1M00HAYmYmkBfvknQpByZGYOEiNYF4BD3yos2uAQhVG9WaLwr2VSM1cHgvweyTMhxOmUWHT8I9IESQEkHRGcEv8AIkKu6WHOMgmSlqoNHAGyJ41fFmw7lVAt09YIlJNyeaNtoEqw1aQGZOm8CS/tXs9QQ3ecx0axNtgqnIQ/KYz9bUDw+TuB9uY7K6XAsFulDuwZx55Hc1YwVblZg0IdYHJZ7olzOiXlSmJusQj98yphYWOiF2ACj8Rd4+JT4ee5aL51vtzfyWL/+p61GFqFQzvgHYtrcb6B+xjjckvAqwafEPtZJEBcaU6K8I56WvT2TmM0lVfjSk8jWn5N0Z3sJAjLnPHrGQdDHw4u6w+LOV9QVHG3x4yrKBoabVCorxFmFplr1vSA6UuGC+/B0wQznjyZAbEvJyWKSk8PeW+JPE2rwIphDlvUMtC8ckjpFwqafsw6TM0mEGdaSriZZPbpBQ67TmT0iGSGJ0u1cPIyvsHy4fl/7wwdFsgu8/UnPdQ/ol2t1XODS6qGJqhGVNM5WdwiFd7EZqjndxHmVGb3r92/Rcw8vYOcFdgSkESTOMcWe783cSeBOzuxh0zojo2kjunk4PCdqj/NJ8QoXGEaYtzasP+Yx1UdaXEMK1MUNSKBkfPAmkmHQC31tR0pl3kTcIfVSjUhM8c5gilV65ySmRcczoOYs2bOmcenDBFAVl6fe
 OYjFoBjM
 4Y/XlIJY7lq1ITZcYaRw6vhRARLUiLrjppve1zN479WkqAiu/8DE7AklXTndrsRnV/G/bBy3TUnmKmwyo/nGv/8vqBtPXHQn1Ds2NasFGMrjl3NRiKYKf2eeJHkuYKBwEJqyNxXSavdoHCa3GZ7rsp7IRa8dWcqKO1K7xQegktIwCUsBMyk20k25UexYn+JcBga1AcSqRr5PrWbCcceI7ndfZ7sFiTrl4CqKPQ6gjrp78Pv0tMKHTOlgq99ulQ6eUflTfe82IcF4fCMt2arbfQ8tD5YTBOz76eYLeQN8J6jCNZ2VabOpHxwFaYmAQgEwLtWXRtFMUuu8TVe7w7iQimfEsiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_sysfs_add_quota_score() reads damos_sysfs_quota_goal->metric
twice, once to set damos_quota_goal->metric to the value, and once again
to set the metric-dependent damos_quota_goal unions based on the value.

target_metrics_score() can update damos_sysfs_quota_goal->metric between
the two reads.  This time-of-check to time-of-use (toctou) race can make
the union fields incorrectly set.  The incorrect damos_quota_goal will
be passed to the core layer and make DAMOS incorrectly behave.

Users could reproduce the race by writing a new value to the
target_metric sysfs file while DAMON is starting, or online parameters
update is ongoing.  The issue will only rarely happen in the real use
cases.  It requires sysfs write permission.  The race window is short.
Sane users wouldn't do such writes while DAMON enablement and/or online
parameters update is ongoing.

The user impact is not very critical.  The race is not easy to
unintentionally trigger.  No leak or crash happens.  Nonetheless, DAMOS
could be unexpectedly more or less aggressive and does not achieve the
auto-tune goal.  Because of the nature of races, investigating will be
difficult.  Users can control the impact from unexpected aggressiveness
using additional quotas and resolve the issue in runtime by
re-installing the quota goal, though.

Avoid the race by protecting damos_sysfs_quota_goal->metric write in
target_metric_store() with damon_sysfs_lock.  Because
damon_sysfs_add_quota_score() is called while holding the same lock, the
race is removed.

The issue was discovered as a part of a bug report [1] from Sashiko,
which is partially outdated.  In more detail, the Sashiko report [1] was
mainly for an outdated bug [2].  But it was also mentioning the issue of
this patch as a similar class bug.

[1] https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b
[2] https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org

Fixes: 85fcf0ffc460 ("mm/damon/sysfs-schemes: connect damos_quota_goal nid with core layer")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 8f083611741fd..637f1bd0c950b 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1310,7 +1310,10 @@ static ssize_t target_metric_store(struct kobject *kobj,
 
 		metric_name = &damos_sysfs_qgoal_metric_names[i];
 		if (sysfs_streq(buf, metric_name->name)) {
+			if (!mutex_trylock(&damon_sysfs_lock))
+				return -EBUSY;
 			goal->metric = metric_name->metric;
+			mutex_unlock(&damon_sysfs_lock);
 			return count;
 		}
 	}
-- 
2.47.3

