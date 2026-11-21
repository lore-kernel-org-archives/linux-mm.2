Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C06606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PFtMUWYg
Received: by kanga.kvack.org (Postfix)
	id 6B6D16B05CC; Sat, 21 Nov 2026 16:00:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619596B05CE; Sat, 21 Nov 2026 16:00:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52F646B05CF; Sat, 21 Nov 2026 16:00:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 222E46B05CC
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FB65A8196
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:32 +0000 (UTC)
X-FDA: 85460344704.25.D92FC31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id EA4D9A0008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PFtMUWYg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294831;
	b=uXwxSi7LF372nBsqTACD6YsBwndPpQgLQwYxgqnQpj00quzgV7zqu2BHCQRymFvWwaVyEZ
	aVdLB1KU0fQkmfiKMMZOq7rvt0/Gbf3oub2gAvIOYRf/zk7Ts4Htw7YUMgNj3wEczgtFBX
	sw8xJ6FN4uZ9LDUA+L/01SjHJX1lou4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlae4a7V9R97zMrEaNBWgX7mTwWMZswJckc2kKiXm6o=;
	b=IYGIvg9GbOAA7nVTk6EvY4jBs4dJfM+3tk5SQ6XQuezih2CBy6VZX+0Vy993SdsnbeEoqu
	VEerGjBiedkxcjqb7744XtnQh00GFyZAlts5WqqqU7JtZrfzRJ7pdHH0uICStKhvFmPVWG
	gUyemXFZ2ttVsa8BLko+5T1+qmy+vuA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PFtMUWYg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDB5A404C0;
	Sat, 21 Nov 2026 21:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E93A1F000C0;
	Sat, 21 Nov 2026 21:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294830;
	bh=qlae4a7V9R97zMrEaNBWgX7mTwWMZswJckc2kKiXm6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFtMUWYg20i0c4kDH/ri9zagoY3aCUoljyyjzyU4agj5cfhhRjW+75Xsm+Ao3WiOT
	 vEDR9k3F1V+HpU2jRXBg6wNss0M6DgTE/316p5lcuXK+pVkvk2QLNLjupfv3if3lK9
	 KjOCIXunuhQ/PsXXstTca15GmUyvHDV/RkD1gEQQtKT09+esXuBSf099Hcm/uWe6zZ
	 ROXwhsV0XhgnYWL38BzIHw3ZEfh7IAiczOZUbhtj4Q0aBOVquD381knyGlVrJuuPw/
	 l+bBCXf2TPzF+iD9wIDkpV/kRNggK18OTtqLuEE+M8JiIX3KcCXM0D7EF686XwWC4C
	 brCgRB8zNWFdA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 27/27] Docs/ABI/damon: update for user_report report support
Date: Sat, 21 Nov 2026 13:00:11 -0800
Message-ID: <20261121210013.130397-28-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA4D9A0008
X-Stat-Signature: zp4s6monrgrrgy4rhcu4xcnxqa9wwzb9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795294830-17631
X-HE-Meta: U2FsdGVkX1/v83Wqjy+Z2O364g6pTwNLXOoeK47AuGJv9LqTHP06oL5Woa63hvwK61LIPxHsJXIfX3Vz3JHZqmQcdZ4aV5ZzqCFzJ995G4UK98xpvRCh418rzaS+aY0MefXWWrzmkYkEAVmm9kaEs4Wpy8KHW9KGBOAvJGk/HvCHAKFhhHKUjfAYP4eyBwRW+MMVNllPjhSeAfpdQkj+l5fOhsC1y0SECdbmyplJz1XHjwf9+j6cePd85/Pj2BlpB05668La7+Nngm3DtsQmSBqP2ThGlj9ZLlEzBp11qhrFbDOcQPa9rIQuwbgdoS1uFjGvGMnCHJh9aZ5CWNmsmRxRglKtn2J+ZwGqC+e7ShDldBmFnWcLBH0LwZGbxLwZrQaoUjXU/3WvjKD8gGYP1Xf99mfaH/bfeGYh46t1Xo0TjfvlY0eyiSInvusfysRU0OM0yapDGvcnQP72NB1G1B1tBqiH96fAxjCem2aCY04RHs6HgxUzXcrz3dwmyTR94Xl1Wlvo1wNds3fzbOyZRdA8DAIFc/ZuX0ewqwJWMxlos5ZzbkfCf+r26MeE4xxWQMzSmw5tzA4VO+u7hPWPFi4L4oGR9HJaFzBH6eMKUDi4fTOmdMrlVCB7XwrG+jktpGjp7vqTda2DOfjfJi4/qv8dJTUduAfGKeGnZdI5DCYDVW8yzRF8q9FG9EzUg/wXLQ6F9XQZahXc2PJQS4EWnE/ot0qbOfdE5c++mFMRvgk+eOdm9rcBenUGwcJv8TePzISY9KOp9xyEYHhttvjsqB/t7p+B7Z+BOdH7UuTKVOUxusIktTmNSnB7NkmAQCt1KMKjqB0vTDuyaDP1isAmzasQ8kf07MnJHtNsPSPxP7L1hT+6arU/PS21qWsmAj4Vzu7SHIVmvMVGEa4RwcV8wAbcJU49HXnd5p1md7DjUSqBCODe5sx/EoocqbgL6gNDAbXSWgEJHjqoEhXohwl
 dVG6Trd7
 nvYl0lf59suqFYCSdB0zwqyCGKRdaPLJf8dpuYIhFKvcBXUnwYjQsS9ldDpgvNXRNOLHABxaX4IQ2ut5JEOM8K/eTeEuHEoWcs4J/9a3UMNQWulskJiJFbb5HjzCfgxOnQ9Cifq0dJUhB8LdiXMO7vh7Y0+ySw7gInzHS9uJ0XCPfloq2uV26uQ+/NNjKvtbNnlWVqq3/PJTjynwGkhTePT9/8XKnEFrCCTf2hGQ449M23BEHIBR8B52SHqjw8OnLT7g15XGIHuZ4NYqkD21t+2ktOxrx8NFND1SYIZx04lAdmp5lZ2QWRdubL2eeC7E2TpmuLr2lVtIu3o8jLIloKUPo59EZg52bVVMrQH6pa0J2UP7X67Hnn7t7QfTaxijNgm2NZ1y8Pgut8X/CvWRm4xdCpZpBP6vzUyJr5EIvmlGcJAhqsFrkPrtWc5bjUxflogVHpZOSrkv/2N0yDhxo8QGPPG91jtkl0kX0V2Ygl3oyiLe4leE+hmi2/Gn104PXWEcp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON ABI document for the newly added user_report type data
attribute report support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index e558dd4212f2c..41a4ce49fbd35 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -722,3 +722,19 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	A file for requesting actions including enablement and
 		disablement of the producer.  Refer to
 		Documentation/admin-guide/mm/damon/usage.rst for more details.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/addr_start
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing an integer to and reading from this file sets and gets
+		the start address of the report to manually generate and
+		submit, depending on the type of the report producer.  Note
+		that the start address is inclusive.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/addr_end
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing an integer to and reading from this file sets and gets
+		the end address of the report to manually generate and submit,
+		depending on the type of the report producer.  Note that the
+		end address is exclusive.
-- 
2.47.3

