Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47B89C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD1D6B00A0; Sun,  2 Aug 2026 12:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D43F6B00A1; Sun,  2 Aug 2026 12:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24DE86B00A3; Sun,  2 Aug 2026 12:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE9566B00A0
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6AF6816050C
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:45 +0000 (UTC)
X-FDA: 85056857970.14.58B7848
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D85DC160003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i93KIxE6;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785688003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UlahV7MXYAlqB2Rb+2/EWA2ZT0Z/bDkXZ3DtwrXgJX8=;
	b=WHuCRPjdGi9J+/U0GiTkfWk1lvIKh7b6fybsyutJ7XXY+J5xjwm/IiKCT0YMB3c4+p16ju
	pmZtac5T7anh8Z76+Zw22p980jAWWs15VRZOD6T67QTuv6g5UWlbxtwxoyU2VhFfjRBwId
	Qtz6v3ZGBikAjVvjnB15AAPes8SmKeg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785688003;
	b=LbBjSNuVM3cKSodFbJ9U4tvDOBU0IZ6fyJkq15Umws07uHvoI263/SCw3gOmziLoKbAyk7
	cSnIcOxinUishCmfOgNaRbw2MjqE/fxfGr1VkHeNRNXW93DibIYNbbpJfbZnr0vcq05OC6
	LtZFBL9TPXcgX9Kye1sVPV1/hWeW0lo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i93KIxE6;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F5BB60DD8;
	Sun,  2 Aug 2026 16:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096EC1F00A3A;
	Sun,  2 Aug 2026 16:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785688003;
	bh=UlahV7MXYAlqB2Rb+2/EWA2ZT0Z/bDkXZ3DtwrXgJX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i93KIxE6IhKofsUKUjSvoeTgC+o3fRHexLU8S91bisem0Lp1CY8/A9/xz5YySiK0Q
	 DbxNTTvq6m2hy8D8QfWt79E95h9+vbIKCtq0dp65YKgGjRYF056e6++4Qo1uxQCrTB
	 d5R+gLEHMfovUlT5Zh17788JeytKKcbJADVpsmuVsXtpqrcyEAmLbAFUUfPP8wMG86
	 VdV22kxE5i5yj+U2mmK1zZRiAQSM/YwnrWzamUK4AqKjapmqCXHb6gEhrQj2Yn114h
	 YT3pGUA7OGqhLWE0GigIzBIlukKcgYSz8r+HAqrrXcwT3lNbzDmzopv7g175tufi4C
	 6fNpVrcK2xMGg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 8/9] mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
Date: Sun,  2 Aug 2026 09:26:29 -0700
Message-ID: <20260802162631.90304-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802162631.90304-1-sj@kernel.org>
References: <20260802162631.90304-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D85DC160003
X-Stat-Signature: 3zubb9xtiedddzx1he4pbmsionia6cck
X-HE-Tag: 1785688003-52713
X-HE-Meta: U2FsdGVkX1/g3NGzw/O/da35zP3ZngtqeMocDgz4URLFz4/N63KesBVovE97kBbYJ2euTDVqFDmOeZrCrk9LUi6MGKtPvEL0sfLphH/sAt1A1cpHcSlpU5B9idtxpo2+xnFqvxQGG1xybST2OztHiztQ6qwFJnEGyXV+p65myFiUQ9cX5DOwq7RkQirGBLLZYJHDA90zjGlCPHqom5daIEPZH8SeB0ITffkZZxQdBmLjigYcXeSUAeSaCCd8MDHHZFDeK0LPMePvAtyAAONYBX+HREGBhbvVdZUOqIO91rXW5Re+0tGTVMHHq/rN7g9QToO5IS/HJZWGwQPTG7wMD8iI891rOiRaWGSz5XElboWgc61xeZ9Q53egwpfSgZkrmpVTqKjIe715sQPS0Lu4M0rAVOxl/1axVWmyBhqWr0pVK28DzsKHghgDq9kK6Yrl2QLvF/O2AmVdbzrdsIt39cnGDkDchS5jaUeoJFZXY4Xt1lzMcusghflpNTZVfmfmU5KBuPtnLSXNg2Yz9X+A9k3zFXvjgr6oym/l/jm7r/AtUMqiADyAPP1zZbpu2hzU2Z0brAmHqeyhVuSxeIz6YKLqyUPSKG33oaqgdq7c7U+jIBeL76AtFCD2qJOQj3kyVNzE6bT+LcHhsuugsDB0iJN7GwaBlbZbNNoe1+v6CsywkQFXT8IykYpxI+qcH5WkVTasmCOjO0bmmcbX8I0cM7z0PqomQnVfNHCRBXuGMU4GWK5UdzBvOyeTEqWH8C4I3kJ9uY7/UIZ9E6fIa3C0B5yqmEN+HTvLm0SekLuffOyiLHkqYJpgDB4W6OWIFKiYTRmrRZODOIdhmYH+vCe2WhWSUUgokAX9fatSeHrg8JFgrMasA+vxeaX+h5R1Q1FqaCmg8pbnWbWYjkvnRFkxKKWRtMOForGBfmcxmLgALuWfGKZbzsV7/IUWabDfI2wBiNjj1+vhTA6SOQIUh7k
 EC2+YB52
 xbtichEvZPKsch8mPjAWcJe+R86dBQWGGtspJ++ubcHxav4X3HesqNlRpOxg74zeeHvHfQTQpVqJg5QvqBHOywYAlA+qsJoW2axOjue4p/cnb1gowSbrdFyw5216UoNTzvoQ8y+KgkiI5cy1r8ZpPiZVyTVYvIVHLQCWxh/MUQxKbTaDMUvjOPiZJjOOcl3PVWZyOxJeDMcv8SvJ72vbv2l0EgDaQWj7B0d//Wdpke9MEG6u0RWUJyVMvUtDmpHlikoD9wH3WfwGlxqDMm6bw0+p+IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In extreme unlikely situations, total memory might be zero.  In less
extreme but still very unlikely situations, lruvec_page_state() calls
might let the caller show used memory larger than total memory.  In the
two cases, damos_get_node_memcg_used_bp() could cause division by zero,
or return underflowed value, respectively.  Handle the cases by
returning 100% and 0% for the two cases, respectively.

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260329154813.47382-1-sj@kernel.org

Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e3f3ee75a3d33..67ad1f07c29a4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2862,10 +2862,16 @@ static unsigned long damos_get_node_memcg_used_bp(
 	mem_cgroup_put(memcg);
 
 	si_meminfo_node(&i, goal->nid);
-	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+	if (!i.totalram)
+		return 10000;
+	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP) {
 		numerator = used_pages;
-	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+	} else {
+		/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+		if (i.totalram < used_pages)
+			return 0;
 		numerator = i.totalram - used_pages;
+	}
 	return mult_frac(numerator, 10000, i.totalram);
 }
 
-- 
2.47.3

