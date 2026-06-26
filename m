Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D136CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BF4D6B00DE; Thu, 25 Jun 2026 20:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA0E6B00E1; Thu, 25 Jun 2026 20:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C72F6B00DE; Thu, 25 Jun 2026 20:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CA166B00DE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 879F11C1FEA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:04 +0000 (UTC)
X-FDA: 84920148768.28.FA09485
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D1429180003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kOEykp8A;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433023;
	b=w3WvulDqgUu5XdLWw5/am6ElpAiIxLg8nwrF0jWOAz30P+7W8ghcx8MaisVe/kHZBr552Q
	wD13+8/gRAuJur5zcECNYv57F2YpiUajzLiw/1eanPamqj8c0Sv7QgzVKPUrVwfFXMCAST
	ut/4lvOu7ZoGmAT+qtJ0ra0djbcvHu8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5OttG5aZqvfe3QoWDGJ8CJoxJmlu+HgiCPFZDVymoA=;
	b=gQY1Y6hDvrcYylWhWoO0yfEeasu9gnZTptEsw9KvZxQ/FNXyO00QrAAs3+A+95aaWCAYpF
	krZWfxgl1YsdTVG7NrFEEn3SdncCybuuF4EUN6gRvvxrnKejjHmUdPyq4igNBgILSigOsM
	LzcESU01KNMGVc+SCApZqDFqKRwfEwk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kOEykp8A;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D72D4436E;
	Fri, 26 Jun 2026 00:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC641F000E9;
	Fri, 26 Jun 2026 00:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782433022;
	bh=o5OttG5aZqvfe3QoWDGJ8CJoxJmlu+HgiCPFZDVymoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOEykp8Aw4uSG4MkL/hC+myXzf5b/i6f4lWOYRGYw0UrtrwpIoObKUx8k8bDRzECj
	 04UfY5cs5t3evs/EauKc0MMeoa+grytqlqfAEjO2I7KxdAHk4X8zzUV/VJO6yB0EVs
	 BLui4h1dr7WL3v0BUmj6DKHKCKFH1YBoCPkPSqegWXWwwID8fcRDI9JHuO/oAm2pwa
	 UvLKIsYWih7X/5ekyQzAap8178gKbCWGU0IHgbiix2v1x+NmRVB9NjLsbhxrdIIAdG
	 4ZY3+KUyr9EWdw3C0S8qdqWmek83h0ai/YBkiVoOGXByl4cO879gOm75mVttd/Flan
	 +737vQcnTDujQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
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
Subject: [RFC PATCH v1.3 02/11] Docs/ABI/damon: document probe files
Date: Thu, 25 Jun 2026 17:16:33 -0700
Message-ID: <20260626001644.85825-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626001644.85825-1-sj@kernel.org>
References: <20260626001644.85825-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1429180003
X-Stat-Signature: fnndn9b14xchhguq1hz76eqpoykm7rob
X-HE-Tag: 1782433022-209657
X-HE-Meta: U2FsdGVkX19Pr/M4zyBizs3CR3ndire8OAOIKTu4N5lsFSvj2ZaDijrgn/FKXo2PYnjX+8934iVrfYnIRDc0WCbgZ1fzuNlV637WZSHgnBonqzy3NfYtstX++RegOqnUS3X7wk+utidco4ZGrgFw2GcE3j3G1Bx0UNgCg2URlKkYZ8W0Za6d37lL7rV0u7pLQObebSBugiTrexZIlfebX4FIyzwZSbOu/QykLDI18qZf+EuiKNhb1PfRhjBSWnzzNeU5QXSISUkeGVoZ76HfxI+7R/kLzwZnthzungjVHuXoGLnTa9iMS/WmYw4/lIrLZWnjXy/dVsFgStl2fO7YrJRWt3MD6TDYjWNxAgZID3EkC2Na0fimlNZJ3n/Ifkg/R80n/9wNTtcnVCXaAwcvoucWPaubyxdHrlLldSPOutg37Mdr9n1QY1oDDAsLBRlxkGm4PZnVcT2yMud+iAVCADVjhwKRFbHcFTXwU3IRPUinQlk4GNT3EP3QmiMtVPIk93Mt/u/xU5rsYKEN/hYhEePhvNdfXGCxKb0BHbhnVTFVrVOzIlq+Ikj48WzBeR3Hkq/K3fir3mTX8OM9fBTmrrKjRn+yd6KOHJ2UXeMMuKHQDIJp9LUK2A0ntomvpda9cHp8nl3v/6W8GBYeH6EyBGh3pYrDC10taN1Cn6hCExjBs3KKFRdXuDN8JgsxeHISbvgXjLSQrneOA177t1N2veLFgoxnpT0KLOJM+IwVcHwEub4HkUMdWnitaiSYiBjesZ4Ax9o6nRVWGltWPNSJii7ZHxVyidX0vOcsfJGk3CVQkxYHnMdqepb2s5+SQenU4jY86P1uFAvFEfL/HN+9pQ8zwv7EDrJDw0nCuBJDoPwVybyigjOyZhzB5uDlS3IKtMlciA9Ksz+1aAAfuQITYp3r0fMIcc+hSAEdYDn8I00dh3YgO6DxXr9a1jpdFpRxObrFatAP32V2f6uZvod
 hQu5phtO
 j53TacUAB5s5w8trRFCN8BsCYz3qNrvGouBpWDePe7e/foy92f4+Bj2gJqduBxAj8V84L6ZLJ3aXT8K58/u/WFQP8SF9KizWbxPB5wxZvt5sGFx68zmiM7JcjTyqWzniwg4n9gnf4ZkEmIm8uPxGASGL2dR/gBcrZ/o4a51mV8DK7r25DjAn+ZXBkCts6YVXWsaICmRQf9JdvsPwCQyIlIxjZ+XAbUIvZqrekZytrL9txfJ4opx9MoDuVjZDOmlrtbCKWgjOm5HPX0Mo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON ABI document is not updated for the DAMON probe sysfs files.
Update.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 .../ABI/testing/sysfs-kernel-mm-damon         | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index b73e6bc28ea5f..f914aab79fced 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -157,6 +157,46 @@ Description:	Writing a value to this file sets the maximum number of
 		monitoring regions of the DAMON context as the value.  Reading
 		this file returns the value.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/nr_probes
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for each DAMON probe named '0' to 'N-1' under the
+		probes/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for each DAMON probe filter named '0' to 'N-1'
+		under the filters/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/type
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the type of
+		the memory of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/path
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	If 'memcg' is written to the 'type' file, writing to and
+		reading from this file sets and gets the path to the memory
+		cgroup of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/matching
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing 'Y' or 'N' to this file sets whether the filter is for
+		the memory of the 'type', or all except the 'type'.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/allow
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
+		hitting the probe for the memory that satisfies the 'type' and
+		the 'matching' of the directory.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/nr_targets
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

