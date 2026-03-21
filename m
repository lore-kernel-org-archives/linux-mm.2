Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74BAC109448B
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7546B010F; Sat, 21 Mar 2026 14:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F5E6B0115; Sat, 21 Mar 2026 14:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424E36B0113; Sat, 21 Mar 2026 14:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23C926B0111
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:13:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C09621A05B3
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:56 +0000 (UTC)
X-FDA: 84570868872.15.EF3DDDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 45ED140005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aetrf1Uy;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbxQY3lvzqhT/iqaqHhhtJ4GZyPdebweaPj+BWQtC58=;
	b=xgtEyBl9b7o2pFDnP8whzzvKDbxN8IACdIYPa/64FndC2f3OBjSnYWssK2G1epwJmoVdcL
	NvEibAlqh+993brhtS0BOjkFQnKXk1hgoc2iIpndJn9GggK8Ctk9i5CThBxoc1Tp8jPstY
	pyVd8+Kin3w0Ch41wcCAyCLquiw2tD8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aetrf1Uy;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116835; a=rsa-sha256;
	cv=none;
	b=Ha9VGXO5w2wtWoOeOaHdqiIg6hETsniUCg2ErjXMG8jRROvs4ZqLj4tAjF0lU/BWKtLDzP
	tKU6ZCl6anDnl5OGSA94ZsNguf7cfQVx9MZRiWlrHk9Rh3EaOx5vNoB7/Uuo7KCH2fNORL
	ZDb8cn1YIPpr16OaBn98CcU96NEf2uI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71101445AE;
	Sat, 21 Mar 2026 18:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43515C4AF0B;
	Sat, 21 Mar 2026 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116834;
	bh=acrZio7SwTIWWe0wc5YY1SpE9hMTqgCgT01pPcG9A6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aetrf1Uydmah2EizI4lkISB5+xJaT6Nm9dBOBkqWNOGduoikVochvnDQg1tvzv3RR
	 IgbpqLSuLqL3sqI0yMR0eMNfkgVlA0ui1l/WvZAKqUfFg7aSud0iU27hYRLcFMolfR
	 ++ckTTBOOO3w8gsrrgN/fgCLldaNCRne4/t3TT3Ed+rtp7zZ5emRChnES3pqpuEK2t
	 6bIMuLBO+bRNS1jVCkQla8GIAclEHMw65kD8E3j8Edw1qjd27HdCSPWyaOqYSAWssn
	 MC12zIo15NzxLcOG+KjCrBmaKVWXk8mDqoOWLrszeFSC6vIkxsuNfu48f8RtKbwrfE
	 JFntlnLdPqGhA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/10] Docs/ABI/damon: update for pause sysfs file
Date: Sat, 21 Mar 2026 11:13:35 -0700
Message-ID: <20260321181343.93971-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-1-sj@kernel.org>
References: <20260321181343.93971-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 45ED140005
X-Stat-Signature: iqjs1ykfsoobd56qqwx5uiamrb7d6cp4
X-Rspam-User: 
X-HE-Tag: 1774116835-888035
X-HE-Meta: U2FsdGVkX1+e5Cc1l155zICy1+NOMYhio9xzg8zRG7mVWkEdBUjhRijeOJtMf4NtQMgNioRyYAPkvAe4ju+khZvKY9NJl9z7vKT/p5vXIVjF4lvrk9uVocN9Jh+ujZfz7rnIuyphluXSQqyUfgmk4qFLM8YbCidXcU6nb0WNCmyKUpho7CQTx/F/c60YCclb3hB5eWFofMzV11FUqfZ8DRAH8x4PU4BFgrzE/M9x1AbcNqn1CC4vnEB0iUOJVuI3LBQYIRBHpE0uHMZiVD2EHkwoptBtCuXAa52XSA2fT2P286RpDL/DRNWSGTQSs8l8pzdiIAmi9u2RSA/euiTwuhYURB72Of3QPe07LTA9sEE4BTGFxCU/OAMEInsj8bd+GohoU9736rDm7ADrIygKx1jNGWbYo3Rwm5mGUWglJc5Voa/hxtrbfqSBB7iBk2EXQqcksIsLdALOWWShXtAmBH8D7SHBnAoum4q2CMCPw9GjXG/hJ8ddA7qfH39URT0CukTQiisfDI3Pp/YHUGPAFR+XTMmi7dhD9PEoyB9LIPB+qldNLcKQVnXbXZVc54z+cb02kyq9dc39k8HsAgdq84+aL0JyKHlo9mvm2zpq3xQriIT0lqUPnQf1lcU8VrGw1WIIVuy+43+vzt6LoKjAXtPKe6OTrws1CaieVJ/NWzbhtXpQN7k3QlgUWUXa89GT/7Kf9Os8Yvo6cyQ8JfLGQRGQpaZEwjLvB+eww5m2AWcamarFonrO1TlukRF9VVQmzIu13SnZ/sN5e8o/Xdq/4l9coKNmM3+9QKTWWzas1E2q20UoHwzuGVdYza/2t0SnbW+PXnJ3Q8wT/nKKUK8o5Cpe6Ffth+Q8AqeEepHU7nGr0jOf9ub5FEI14Txs809RwYqSZdk1v/RdXvE7ZEz7PlkHJMS6z7pQheeW7KStlufPOSnvCEe+hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the DAMON context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 2424237ebb105..7059f540940f0 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -84,6 +84,13 @@ Description:	Writing an integer to this file sets the 'address unit'
 		parameter of the given operations set of the context.  Reading
 		the file returns the last-written 'address unit' value.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/pause
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a boolean keyword to this file sets the 'pause' request
+		parameter for the context.  Reading the file returns the
+		last-written 'pause' value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

