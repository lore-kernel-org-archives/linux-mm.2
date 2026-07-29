Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B4CC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801EB6B00A0; Tue, 28 Jul 2026 23:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7365A6B00A2; Tue, 28 Jul 2026 23:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6228A6B00A0; Tue, 28 Jul 2026 23:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39A8E6B00A0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:38:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA70AC053E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:06 +0000 (UTC)
X-FDA: 85040405772.14.478C188
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 53DE020004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y0OTsjK+;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTkFqCNT/LseVbtXKhwVw4AevH2QQucXk6b0DrI2IK0=;
	b=2mtulvAo7zkANjGsnFr7+bqPOfQeOLb2+rl5xbPOV4m1mcaZKSkm7SQmBkUmW6cq68eUOD
	R4Ntp02FGpS9G4M5ZLB9hLjSWF2/TKE86QcG7AZmbL+Rr5e1qhqxaUn7Ao5Jrw03LuWODv
	jm968iCxhiUoHWkp6LcsTfKvn0sYqZ0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y0OTsjK+;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296285;
	b=4HvzBheBaUmEt/UwIYLt7tlNHfVibVA0fBqk/VD/SSvg5Ix2x8ulnbrthVe94KBwQYLN5x
	WZafZxNEvhxvZTrfBYvzkM4mIFU0VCf9eQrdO9oHHh3U18veY7kjiUXSpNM4AphMYCQD5Z
	FnmK2Rv9zXAKqx6oMP7l/uNdqGWQahE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E072560AA8;
	Wed, 29 Jul 2026 03:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3181F00AC4;
	Wed, 29 Jul 2026 03:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296284;
	bh=FTkFqCNT/LseVbtXKhwVw4AevH2QQucXk6b0DrI2IK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0OTsjK+UBuvpS8e602ZtYk9Hmif5n4eAuC6HPfpQsl3tRoc4RPhL++nz1m5Vok/l
	 u+Epq3UQbswPOP2dk4sy3p79IJRCo2+dhrkKDjc1/VcIuTTbcI6FzalDvqmAxdrGo6
	 1n2z9pxFbRY3WPNIeX2koWzpJ59r2dUh43BRxl7v09tlq/7t1AD3PABjqBJmIEqPdz
	 V7x+ZsI/tCGAmR5287U7dhjHc9FymJNPc8E2PSnT+4O63TExLis+RT7FlmOcYmmHSE
	 IscfpUpUt5388X66o4k2jpc+QGURquznVouOL0yTuuq+McXQlRYmbS3YtcthN8zVHg
	 85cEQ3lfgqYEQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 10/10] Docs/ABI/damon: recommend subsystem doc instead of admin-guide
Date: Tue, 28 Jul 2026 20:37:50 -0700
Message-ID: <20260729033751.131213-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729033751.131213-1-sj@kernel.org>
References: <20260729033751.131213-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 53DE020004
X-Stat-Signature: dj3zh4i6c7ocgf1scy97ynwwgpqndmsi
X-HE-Tag: 1785296285-614053
X-HE-Meta: U2FsdGVkX18iZDX952t23HrmJ7UTSXGgd/U/XsAyy7v8c0vjr4avSFNTp5VPSnqX2T6OjSj7EDbVveXUU4pwaXjmebJJd/g/WJdg3kzBAvqllKhqOD7guHRlJZbuB0igpX9bM5bRsmnYC3oVzkKo8zC5cJfAXz2pJrs8BUlIfJLjzzrXa1V5jFts8jFH0lD2tPbqCABVEEFjrZCwGzhVSXh/Q1q8eLxkBmKRjdtZCxR4DK8N7Qip2ht1X0QXZlWuEf3ak5DqMFcqmBiVtf6+Is9BQVujydiQWoFhy1pFPVuZYuY/J9i+qRUrzYpcODM/dtEjqufVActQsrNFhyE/PlIfiBs5BFzoFHEte7KJWkvW3ADgaXsRel/3lYolmpDBa8DGwH35nu/9g9df38ftaT88T7eyVgS+9jV+ZKziX4o5uWrqFwm8iaQIF51w5BmDaBCtl5RlA1WGsiQWUscZDje/d3fAKCIulZ77dJYE+f/6NBhP6jDZG443rVTLE21Qdl7bu8Oks//HejbWuycoCrhRkcQoD5dgz+cQBuTneOAGz+Wlb/9kMQL8ZC6jKG+J5VaJl+5LIHdkJcVbwb0PWQlu+fAIS5GvUoHZaPk4D43Ty7yqG5lz08flb7/jT7DogYHyBqizo6y9bwYfY7UoaSvLPvW/tHOpjFQ9GDS9Wubk+Pk+lK94VNpSvCSB8tP39k+/0MDuxVwNQT864jdeL3d/rWNv/v1/X2Eezl/Vr7iqVZDDrXW7bgkcfe577kXRfZIVepUqzkzrD70L3CQGHjoBxF0ORosrfV5Z8TeVojuCBNf2QaQZ3wIcpgek/GYbanvSvw5SJd3M+KbLxTPPA4eJXYfSfUq1y5HPbg1roAC5je6wEjSvo2UeLEf5I/Y/OeXhsNympcibVxtSrfJCJltFHohwnSg8Vabpiu9qQGe3lYI5wbxUWwpq7yxApAqUVOgP4yfjS+T/9Rc6omi
 PIoaAdCi
 Ib8cI2ylYQINbD3IRvWrsu3elfzjpDtBHig/U2/3OGZV7XfD5XZ6MvFbGx2eKGWXOkhUbHXYRxxmrrChqH4e4PMOrQ13g5XfM/PhTLozZWwcr+2IeU+h1sCdEaG/SZRKSChve1huTaGG9dV4l/2ujWV89+LHVWhaaTi96K6KGBxzFsZfoqSOEPXzbjh8kx6dF05Tw7nrGrHj38ApMXbV8pdiZhsZE5A1OSggwkykPS8+Cxvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON ABI doc is recommending DAMON admin-guide for people who are
willing to know further about DAMON.  Nowadays the subsystem doc
(Documentation/mm/damon) is a more recommended place for even beginners.
Recommend the subsystem doc over admin-guide.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index f8d2601e82904..ad21f58f3c912 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -3,7 +3,7 @@ Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
 Description:	Interface for Data Access MONitoring (DAMON).  Contains files
 		for controlling DAMON.  For more details on DAMON itself,
-		please refer to Documentation/admin-guide/mm/damon/index.rst.
+		please refer to Documentation/mm/damon/index.rst.
 
 What:		/sys/kernel/mm/damon/admin/
 Date:		Mar 2022
-- 
2.47.3

