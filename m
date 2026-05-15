Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B306CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 13:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48A896B009F; Fri, 15 May 2026 09:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4297B6B00A0; Fri, 15 May 2026 09:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33F466B00A1; Fri, 15 May 2026 09:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3386B009F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:00:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C39DB160F4D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:00:03 +0000 (UTC)
X-FDA: 84769661886.22.3F48806
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id B2B3920011
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:00:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YUFW8+oz;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778850002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=i20zBf0isvQBrctVZkMXxXbD7OJ/2pAVywuOIo9BInU=;
	b=EX/MBII+C47IKMV2I5pfj+d6IY7JQFJU+PELRgr23+Cpp/fVz5JVLKPlxHWKGoea6CH66I
	0Czk+XyWDeSkXla9Br8OTpfoTVwr8mbtFOVXcDuF7WQyUADjYDixvgEDMly+U87PGpgkuS
	EJ2cTyPWuUnmMRMrWz+CjfS21un/BRE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YUFW8+oz;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778850002; a=rsa-sha256;
	cv=none;
	b=LWiiocAf9ZQtbRtpKnTeWMdFxPCJb0f4aSPLFXRLfHjMUkP20thR5COw6dBdRYBGG0oAFl
	Yh+9j5cfPK3UGfTpSOB2zeR4XbJ7eAJlkvhvn4EyIMHxczIQa3DffmCv0KzEFzcQXLLqgu
	fybb+yxm5it0jiEA0xC1qy2UUF+sSEE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6444827D3;
	Fri, 15 May 2026 05:59:55 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ECAED3F836;
	Fri, 15 May 2026 05:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778850000; bh=+2xRSrQDtDWLYEFX/q/RbrP/TC4sM3bOmJsEvKC8zfA=;
	h=From:To:Cc:Subject:Date:From;
	b=YUFW8+ozWcK8YoPH90cYdeTuObSnNrZtlgq6GXeS23BZNL2hPCLsS6IAeGSbwrJog
	 giN3V9HRM6QSYUJgZubDaIUyF+tCsFD98gppo/T5AtZW5X5uVWzwlkCTLwFyZqVdwR
	 FXi3kHYboDoUotSKDRQwjP7C+KXjFNLw7PnU6CHg=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH] selftests/mm: add pkey_sighandler_tests to .gitignore
Date: Fri, 15 May 2026 18:29:49 +0530
Message-ID: <20260515125949.315964-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mt5k8n4c7f76cian51krg5iqs8ezus9n
X-Rspamd-Queue-Id: B2B3920011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778850001-618010
X-HE-Meta: U2FsdGVkX18Dml5o5nysciFTKllPTipfn0zpDE/Brx3NFTpVQ0whAGoDCePbMzEtEXQryoGl07CSG0XoRzq/QXhSibBVmeqonMt+VT6qw7i+yzbQlV0EV8nSpZT23Ex7cSHffg8ShFzRsabzchpBfeR2gmOfJ7aGuX/Q0TjdI8voCM1oZcAqFoNAITdb1Af8xcnVaysRt0T8MqQVj1wpw0F9iQNXNdMpcQUJcQsoDO2klxjCdTz4cUN5agio+D+yy88W8D6N/zGb33UB4LozqI2Sv9AOAy2WkoAjCGoUJtZSZlZHWzuC11Brm+jRd1IUy1GIkiP8yKoDKK8ndQnqeMGkNaNLl0rMw+yKI05M35XsKUuXTBH9FKjBZaiLjVczwA4Ovay+5nu450NJsi+oeFY349wzhzwCf08VuQTVFNrFe5EUawESkMb47nAkll0uyrPOhRedbVacuvhT0thvt4QjZ28r+yvQ/1p9HBvFRRrkbSDp9XBy9Jns9O1R8+GVgVa+1ifOWAH+Wb5CnfkTQxYuDUhL006PutgVyKk3enQElaxF/XGdhJaTurI3dF5HUD6+yT4O4ZaKtre4UynV7NtZS/Of8hQvaV+josPSGLSuLQikpnZF+EdDcdGtCH4irxOKsLpecCKK6kwjom+8g+KneljUERYS7xqNbG/tO685oVUIcn2NCdh127EE/4ZqHJcFA2kQ0iNFBE2VW6G9bSFhtaTClw5tVrqV+CgPqXxtRen2NOGj17shOZJRRqBCls4iP+OmOn22gY8qC39A6UYZAGFYspJgx7ZtU74BJVZpjFYb34LwjUVcceKb7tObzh23wXJhge1z/5gnAfNfMFEks0Hd1TuhEly3ZUHqI6zYDTqVjFPKUR78DB2j/jALUBxoAskbJ5G/HtPMeQGFwtjYrxKCC0XmdGIDiGEgTtVNd144DoPSE63terQqYd68rD9F9aFV2EIs3PwCVVu
 d+swH3VC
 0gCJjaULNDx7ivEJsrqyobuF3xKlo6eE0RWOYKe5nFv19jEwLBB1WfprkmiS/cQGcUaAYMWMaY5/ffjoSx92ZjbGFtuxeTFvQgUm3wR5C9uVmFhghAFYEVOJ6W0AnZqyMMzYrsYGHh16KTOEuTewNT1TRy6AmGAMOJumpkBVe/7OBGUIs22ultIpG4Aufjjw+Ir4skR4vwI/oDM6HiTSXjOAui/tuxkzQcWtebKCX4s4cXSTZ+EXEJmVg417yVvQqYHO9XPzjXhjUE13AKX8eDYx+4JgZF4E2xrLx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

.gitignore currently does not include the binary
pkey_sighandler_tests. Add it to .gitignore.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index b0c30c5ee9e3..1b1d9ed87039 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -62,3 +62,4 @@ merge
 prctl_thp_disable
 rmap
 folio_split_race_test
+pkey_sighandler_tests
-- 
2.39.5


