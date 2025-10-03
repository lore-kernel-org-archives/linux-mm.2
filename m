Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F03CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 20:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520048E0003; Fri,  3 Oct 2025 16:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F058E0008; Fri,  3 Oct 2025 16:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DC208E0003; Fri,  3 Oct 2025 16:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 176D38E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:15:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE41E5BC19
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:15:15 +0000 (UTC)
X-FDA: 83957907390.21.B72F9BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2E75D20010
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:15:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bll7mUUA;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759522514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVjiKCUWN3y5aWNmPwFhq+7+YGD2/KbLztcZ/ymWM0U=;
	b=omTMtiKPAaBZaY8gK92ETUdKJjf3R5PfJ84tVDIRj51QAO3csACHHmlR6ghWwttx54BpK/
	udFBS8T6K7XujndRWI7peEQbnMZ3P9TJZeXTgUn3n7r4S5VuJnNylqtfCe77x6e/K15zEy
	ZlpI13e2pm4PlF/RGnQpj+o/NSMBbhA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759522514; a=rsa-sha256;
	cv=none;
	b=xFeXIjkMK97mxc8v5Eu5ynA1tBADBo9zt3hWFl2QIrugQPVDNJ5MHK6j9CFzzrv0dY9Ez7
	MRVyHnKtl7umE+F3HwIfwHJshVddZMD5ufVhsWims/jhdvMYfwyF10VgZcPZbfRLfz8fDT
	VCtlvo33GIJYbkm0deykzjlZZMZyk/4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bll7mUUA;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3057349106;
	Fri,  3 Oct 2025 20:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58E3C4CEFC;
	Fri,  3 Oct 2025 20:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759522513;
	bh=RUym5ecXxJyHPu+yV0bLUP/4AGHYamHBJdCCq97kIHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bll7mUUA+UwhEStyFuFQwNoFvZilUR/YeNEuPz/sr6fMhzx1574r+bKBZdS0eHDlL
	 3cdi3UyPSuoK19/y0jPQlf92hGKUPPAnnE246oXAPOhaeSYyv27mJOzD1bnYmMhCdd
	 sSVE+7g9o/b3G7IEYV6nEE+nVYGxPUXjkKA9tnIjOB430/1OMD2osnmr3yOws0HiD0
	 k+D0H+Q3WLxaJ3tjz6bXrZWD46E48RjQS82lZUUlZ15ieaeVG1fmAkypr/yDhjqhEA
	 3hqbZYDymnHP8cEJd1VeQcKtVTT6FdWDKy0RXUiyJQreVcG3C+VC9rwt2+4AhBA2Ij
	 +HTuxp3gZu9VQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 15 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/damon/sysfs: dealloc commit test ctx always
Date: Fri,  3 Oct 2025 13:14:55 -0700
Message-Id: <20251003201455.41448-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251003201455.41448-1-sj@kernel.org>
References: <20251003201455.41448-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ysbf8gafpnccq85qkfx45fp37fea66j
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E75D20010
X-Rspamd-Server: rspam10
X-HE-Tag: 1759522513-332237
X-HE-Meta: U2FsdGVkX18ST46HklKgv9wsO63v0W9Yq6PVJKrr1qf361ZxFmErVqoX0bC+n7I4jLX5iZT5+CoEPW56yAc5jBztxLLUbVmPxBD6gZelH0TkFMXlmlFcXuMSaJNueOzXdPloocqVUHBZFhqQ7i2nusJVA+wMO2DxFvT93nTkNJCEXThJQ1ZW8xqx6wtfCFqGSrmh1Uztw1S5HJeB021MTqZIdmXIhw8Una8DWaIOjyhbTn4553hm5/UzMhE+EZN0F+eDVrswYp7Z0n4+R/MbuCdylA1sVYRxMq3NzI34VA7qoOTeNKn47sOw36USMGVFDDeuWzi7P3cgCpkZk2tpCcvTEGNlwKmcmK7cvz9XmhN341ra0wc5egBPVTTYV24XwsskKBStLFuLDc8dWbgSDfJHBsOzo4HscMk8aRt2enhkERJw7Tjds9rPh3l/hY17xMtSKiFUDuRAKkPH9q5cJjIw0Djv7DGj7ZTVaSWuTY6cQkhrI16d4i/Eci0VuAl71de9PVSw6O1Xe3kHK6UNKfZQibivccLU/wGLapDoy/7pqkRuHB0C/SuhK0I4PmEx+EkjZdZiD0DsQqFdvE/vlpmUIg2ug5+FHtoE2/D8mH+atyVJahMgWm56ZASCkwzRqE1zzPnVcoVKEJ1QRLduj6Wp5AvDxKLAzPRxjFAgRjGhtdLLq4IodJRImoD1N/UPW10ztMVcmjKWw4nas2X7gMtz+lsHBpJDvZ+B3LXPOFbWvZjl7v0Q64GQe7bz3Yh/RM/3bwjSB7sL8WuDx3Gm1EuDEVD8E8QdU0AwM7PxDAj8cDAmpxfMWwcfDHwzYRTBAZxGvzG+3T2NlRiqDcisfzBHa3Y95YyyFOYQ9ZSTriARBkR3e53d/YSVHumu3LZ0L5307TSX+hHfsZc2sYOxX/mJvjzOlJHQkc8rGL8XtEnNsKgU6kb76YXVCq0QUfZ+pJ1nzrD6mkNxcS3H/j9
 gBfvaKO6
 4Ocr1dGGPHSAiWxYvc4PLJJNgJsmYJqi7Yyhhmm4xT1g+vFbjWuI7o+df/5A0pDL+kQISaCWTHkcfONsBhzWt7IQDLshtzuk7YYk2/lTHA+DhE4TK2mXLdoklWxGoiETPy66DzrMqKwRZo4IJziN9voHFqqI6FFZmjFGffKJOJAlpo+1ySrkWJWC8xLKtquNkAAgxjOKm2AmmoiQ93JTja+iR6RQ8cuLvKD/bCLRXlt3ZYrw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The damon_ctx for testing online DAMON parameters commit inputs is
deallocated only when the test fails.  This means memory is leaked for
every successful online DAMON parameters commit.  Fix the leak by always
deallocating it.

Fixes: 4c9ea539ad59 ("mm/damon/sysfs: validate user inputs from damon_sysfs_commit_input()")
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 27ebfe016871..ccfb624a94b8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1476,12 +1476,11 @@ static int damon_sysfs_commit_input(void *data)
 	if (!test_ctx)
 		return -ENOMEM;
 	err = damon_commit_ctx(test_ctx, param_ctx);
-	if (err) {
-		damon_destroy_ctx(test_ctx);
+	if (err)
 		goto out;
-	}
 	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
 out:
+	damon_destroy_ctx(test_ctx);
 	damon_destroy_ctx(param_ctx);
 	return err;
 }
-- 
2.39.5

