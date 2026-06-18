Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BB4FCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:16:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347D46B00A2; Thu, 18 Jun 2026 11:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9CB6B00A4; Thu, 18 Jun 2026 11:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20BA26B00A2; Thu, 18 Jun 2026 11:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6AF16B00A2
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:15:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89654C02D2
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:41 +0000 (UTC)
X-FDA: 84893382882.22.18F8589
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id CC17440015
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ERjpiAqy;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795739;
	b=L9BAH0ugqMGgf3qNUloAqwktOOMH4DvpKnfc/EcrUL40uQOuJlyTbJQRRTbODhwBbjkUhA
	P096rrZc4EML2DzG7yWC+w4j9jesh9MDWkyt9B8NZKN/y8Ptzni1Peti+ODXzKBwgPCq3T
	vkmtv9TLcGGXTMwtZ9uXHbj+qyy1PHg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ERjpiAqy;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apeCKq9Hxx5icDF/JvpCpTO4zm17bsS1r78YB3ZGzD8=;
	b=WQ4N5tBs/KmUCBu7Wb1YJ/lvpF0o7RKpkxWY3VZ97jngupA2ItwtvpGraBBEqLosbFswDu
	W1hycKmihnCVcvM6WHe0Qm6P7qUI652Iivu1lp6vUIH14n2RbS8LwOsElIvOUD+rFwSmC2
	t8L8KE3kGZevOTkZYkqfne/bCtUwZg4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26D6E44242;
	Thu, 18 Jun 2026 15:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDF51F000E9;
	Thu, 18 Jun 2026 15:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795739;
	bh=apeCKq9Hxx5icDF/JvpCpTO4zm17bsS1r78YB3ZGzD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERjpiAqyeUT3jWBP+j8FtqDS7DMvTidfk4+DZF/xWda3eO7c2KJWWV8fVRn5kkCkC
	 pUlSPrCkVD7yazw9UfiTYgaatFzlYJVE3S+Z08eL3Xs2KlM8TOP01DHt38xT5bsPnd
	 cDRyvxXkOnzIopuS68IPLWxJq+RGE+SPRdXD1YfFXPZLP9PDwrgJBXsywWwdWppDqo
	 hjRDO4JwEUhoPk18Kaww5EU2OdUnBtiQHe17qD7dEOkkkYtNeE6XVoa302r3ARLXuk
	 kLiPK69jR9lFiaxSHlQIThGh4xaK7Crvow96fdndKkAcA1WInKTqhRvRQCXbHTfTpl
	 ibCPG2m6bwbSw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 09/11] mm/damon/sysfs: kobject_del() probe filter dirs
Date: Thu, 18 Jun 2026 08:15:13 -0700
Message-ID: <20260618151517.5366-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618151517.5366-1-sj@kernel.org>
References: <20260618151517.5366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e7ip7miph8ohzksqtkpbbxnb8oppjpqf
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC17440015
X-Rspam-User: 
X-HE-Tag: 1781795739-31915
X-HE-Meta: U2FsdGVkX1/f7Tro5zFz6S1g7x3KT5Un7uJzDQiOfI3t5iFkBrZG6hNZ7SLlTjwFES9I3Ccw37nxwdL8k0zFe6zciKVuH3iHAIOWXDGi3VvLkxwIsaNW9nvv9jQq3eGEsRSPbLoFvQtl9zd9YS7mVTL2wVMtleXFlVm2b5ZLiQeWLq+igyBXjg7p9XMaPl4QL7Ql+uj3W8ieTCUn6MwTjE6l2lMXjFIsrhGkcwVaKfweeMChQYI1zG5CmHhtvHpRF0BQhmBkANS5RE6v1EHJrN6ZxiNyHMxG6Xxx0CZ6mzJBPZE5gDlywP3R9wKpZLgPtoQdzpR/gwU6a5W8J46IkBGRhYvJhIvOqumnLkemNI9oQiL57n+68XCCE5DQ2rD5p7bUUPKa508uLHWEJ3YUA/tVouBi8Q+Ryz/BVm5JfeT8nuoFAq1nmXfn3oDQPsH9bLhf2UHf41OhcsU0Si6tpAYqkOFYhc+Q6tjP9YmbDspY/yWBcspkB0ZKd/Fd/q3ichZQJEEzd/IzugMiUPhfMkhZ3tyO5A7VqU3qqnJwyliwUXT72Hixy3okw0h0jwJbtsOyIuw5wIt6yADFdT/ibW4d+b8fYuKMVzUf36+FsCK4r+FghK1H+TQdgzCKKEkgwFa+AiQoPif14ejD63kS2hN4mEhN9aaqpD3gmo6cJlvkanfzbyasJuMqXRw1dXeEqGRXnJus1LXsRik4b6mt7/POREsUDohWytkJiPV+Y3wTkTlKUIzGJo6ILY6eU7/kgEQGdc8l9aE3qfpQD+Q2umARBf3akwd1tTVet958NkifQl055uiAcQgvOdEH3Y9eNgyM3TrVGe0f6k18XvKt5i5EDRhkBEkRnxAY0sYefuZK+vg8B9iA9HADJqzX/0/c3uRfDqJsTG99E+LagySDj+d7AUcKkPEpQw5ZoHPIS/xn6EupVfidWBlqNHJhGiICIALQwpz0ApXD1w3AT3N
 uCUI6H8X
 gqu/3974RZGna9egjW2fAos8Av6NozSDs2/4uhOr/JbI4eUJZcJL/yhThukoWXS4W2DRJJw0WD7HM2ZEw2I00eZLRc6eA0PgAWT7vwOw/1AuhkveUd0lVdnChvL1IupNXCV3f5Acl27badme1Npy/5XL7YCaWsDK3QKRYvhgaohGEH0/F/MKHNWFCoV5HQdAGyH/qNDI4GnkNL4ndLFp3fC2vJihu9stXC4vIxmypXwiQEQBR2DLZvbTatxgQWrgvzbLLKIqu9SXi9wxAV53pQDjKcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for data attribute probe filter directories by adding
kobject_del() calls.

Fixes: 82e66aef7714 ("mm/damon/sysfs: implement filter dir")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5ca45654cdd39..36a0e82601697 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -962,8 +962,10 @@ static void damon_sysfs_filters_rm_dirs(struct damon_sysfs_filters *filters)
 	struct damon_sysfs_filter **filters_arr = filters->filters_arr;
 	int i;
 
-	for (i = 0; i < filters->nr; i++)
+	for (i = 0; i < filters->nr; i++) {
+		kobject_del(&filters_arr[i]->kobj);
 		kobject_put(&filters_arr[i]->kobj);
+	}
 	filters->nr = 0;
 	kfree(filters_arr);
 	filters->filters_arr = NULL;
-- 
2.47.3

