Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3345A606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=h+5EGASZ
Received: by kanga.kvack.org (Postfix)
	id 5A2BA6B05BA; Mon,  9 Nov 2026 06:01:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553666B05BC; Mon,  9 Nov 2026 06:01:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4960D6B05BA; Mon,  9 Nov 2026 06:01:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2616B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:01:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A75C5A0645
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:51 +0000 (UTC)
X-FDA: 85415290422.15.EEE9C8E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id CE6241A000E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=h+5EGASZ;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794222110;
	b=2HRA+fPTi/X1X/RjF6Q1n1/q/PniQj574W5YI71v35BBQbYfckN9GaqzwF9+qhWw53GrzV
	KFcxci63jXys2I/l5aT7L71t+ZuoWoK45okNSw34c1nQIASgkx8W08olz8aT+bpIZeLZlZ
	14+qaFBXACZiMQQCkWFIgAXrcWAKjnk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=h+5EGASZ;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794222110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=P1q1C/a9QiwEb53yKMxHM/wi7D22xCM+hnEZR059szc=;
	b=dAlythxZFZlrMPrdJaJyJhVLXQxlShN/0wvsUI/+qas++SBt5to/NxCE4w/6xgbLWo5/Xh
	F/jcwX9oVDFVm6zgZbjZCXfQvbWnox62b2BPkBii6JBCgeZVWnvfrvlR64qd1ykWM0DXdK
	+/YiY/OHKAJDHBlZn2w6NYez+Pn7dj0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5AD91576;
	Mon,  9 Nov 2026 03:01:45 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.167.155])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 539D53F632;
	Mon,  9 Nov 2026 03:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794222108; bh=wBOvuFzqHwhioAeXRHhM2TmRHYOrpJxrqcK2vl7GtaA=;
	h=From:To:Cc:Subject:Date:From;
	b=h+5EGASZ1f8gbLio5gY5nhY8K63rukruJ6kpJHClxcXpC2IBi1jCvrWL+xZC1gMeX
	 nxS73CvQFry5eRkN83HvJ8XjDihDC5fXQ/sBbwLGlXjkbG1qrm+Uv3MI3RpGcNOuHc
	 n1TiFym/xxKzvEGZVTNn+iok2Ie4ukfQc5r9rh8w=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH] tools/mm: add page_owner_filter to .gitignore
Date: Mon,  9 Nov 2026 16:31:39 +0530
Message-ID: <20261109110139.216653-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CE6241A000E
X-Stat-Signature: oi17wbtmaqoznsept6q3yfiff39t4g4k
X-Rspam-User: 
X-HE-Tag: 1794222109-862159
X-HE-Meta: U2FsdGVkX19Uzz+TwBm3WZzDBVWbEvxoCMK14Q/aqpv7N33l+i3EtVodStp/6UVQx2t+sQkAgC/x1cLzB6GBNsaF5c/fwS2QldClotsL2j3D2Y2WN/l7JurgRgGRsDdIyiHadeBIBtXG5l7Rvbl7DANJ36ypCfGB+1XRs0+ZqOxJNCQYUcRn2wG3eHWKuF8S/+EdyHrZY9mHzipYTH4241MGH0Av9MFPCfHyFC61e4lid1Kd2RpYDZKM9HX6nx86lGwzs63LwaVK7ooJ1kAaVDZYpwRiLeG0NlyeZByCdjQ3mINX7YD27oPBsL3hQvdinjAz8v3d5ShPVsKIjuu/dE8p8j5pOu5fJrgt5AP91KEMePaVmFbptbN58BvIgdUcybfY0Jv8VJRH1CWDRdA7N1CvA6LO8A0vAMm8Ajr8DJ4P7JjJ9lHs0YkWhGQkV3tv7UB1DdPDWBVxhcsBAUFDPeZCdft4UZE7m3RwThvojFfeGI6MbhIV19vbwhE8sI3wloAU1cISqWeoyxv6P0igwYLNYWjyDABj6pB+aq0F8lnQmB6Oxg2Bt+6N3ZLPceNJKnAeOuGOiOd1oN/vRAr1PTKY4fY8kEaWdK0xwdceNeSusMpY/J/fhDuCFCtjpqdOTj8oAxqZn1EH92z5B+BFlWEkNGyUowkaeJjMwJb0C73qbwq5bw9O/uHVLnzl2aeuOgsPqMNP/5NnrpA6nU0MLEcJSiT/gF8cdc65IEa8sDFe23GC+V8YdqPe8u5edz1CvTbhGfQDG2uaVxYK/QjDQQo3bEYq/oT+wh+MI8KKajZ2hM27SmMnzNc9SUr2u9ZiVbc9TsJZiL4vQ1w3JTbCeYqruGI9Y+RVzxqVU9exNJvc/Kj9tIHkmJpR3cJ8QdLVuCg+u1o/ii+lqS6LKp+sliy09cGjrvPFtppG/Agw50OI/X0tTdg9cfED9ivCXYbVSo4G1esg4gVSMQyQJ7q
 afZWHgUl
 8vES28PCmH+xuy2bugQuabE/fBT071B/etpbkWV5+6lst/EqYZS7ZhIkE3KRTSVyg2N9NeU66v9iIL5nub7R4ggqG2oUJvyB95XoRESUsf3TxgRm0p8FJfX4RYOA3zoeyh+Qc+wkvHoReU6YMFOLJArGl5eeCilVccAJZ/4JguphI3CRoYtm68geOLMjoYsCjTk4WFHkbKt0yVf/maV6B4O9xjL4NKfO0GrxlCoACfU76C65Y1k+DHE4BtcixFEzVc3cvxMnOGvc/+tNI+SxJbWZqadEYQv91QxyD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the missing page_owner_filter to .gitignore in
tools/mm.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/mm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
index b4ac68a08e1a..2d08f713b664 100644
--- a/tools/mm/.gitignore
+++ b/tools/mm/.gitignore
@@ -2,6 +2,7 @@
 slabinfo
 page-types
 page_owner_sort
+page_owner_filter
 thp_swap_allocator_test
 gup_bench
 memory-failure/hwpoison-panic
-- 
2.53.0


