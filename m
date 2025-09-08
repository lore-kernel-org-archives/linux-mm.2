Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80F48CAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0668E000B; Mon,  8 Sep 2025 16:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69A68E0001; Mon,  8 Sep 2025 16:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B0B8E000B; Mon,  8 Sep 2025 16:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC6BB8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:15:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E9BBB6ED0
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:15:26 +0000 (UTC)
X-FDA: 83867187852.19.D0F53E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C300240008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:15:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lQWmdD75;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757362524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZpez/r2XyGsarCWBAxM+HLv+cf8q43kElVKkak9Brw=;
	b=PmBgLK14/mNd4EJ6NBTvzL0J7QePGDkbufsCJA27Znm9z4/bkQofo5o7lkva7TI3iw6gl3
	CebwvuufhxuLNZHSLaQjYzcmknnlqzeCpB23cUsm77d0sorNfiq1wm+yFUM2vDKDdsh1ws
	LOhR4ySPuuaPusURfw+afs1SYHItuzM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757362524; a=rsa-sha256;
	cv=none;
	b=sb9GSqHs8q176IW54sGoxyQDMDqWnvAxLIoNw11HVrM25pRSWi4QbVkEPoQ6MVzjdPW3Uc
	Kjcvode6kUP91vi7Mh830d+i5+Gouq0nMX1I9gh67iuL5vu0yy1MzB/nPyHCZMoiPsCYt4
	aYsgVvndfnv9ILkuT8lFxdTyydYV7vU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lQWmdD75;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89C4E4494B;
	Mon,  8 Sep 2025 20:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C98C4CEF1;
	Mon,  8 Sep 2025 20:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757362523;
	bh=9plYFMqBRkh39dTcvpAtaB83IpFv91F16IOlzHIVMp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQWmdD75oE1fORIEtDVZnUGfijmdYkpohDkXtBTHcEbRMY3i0VEH9bmAyXuWUZEvN
	 etTP0HbCeutdXuPv7Tusyu9nrQOG3XZaBWORXdBf3yRK4T+94mFI+j+rm0fjVDkW1U
	 lSRcPraqITfV2GnEQ36gYNVMVfoX4tUV5z0090tTtFCe63uo51STI7vEFtT+ueFTV0
	 3hRFv2ByyMd9Emh1Jl5Vscb0IfiD2Cub7tRB0FDPj5M+Ft2QgOlIxGf7zky8Y/E1El
	 LrlHS4VteRmDM87wm3TK8btsoB+hrSZwKpO1vPDxlTC53wdvcCZLc17YjBqGqSP79f
	 lFwCrw58BKScg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/core: introduce damon_call_control->dealloc_on_cancel
Date: Mon,  8 Sep 2025 13:15:12 -0700
Message-Id: <20250908201513.60802-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250908201513.60802-1-sj@kernel.org>
References: <20250908201513.60802-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C300240008
X-Stat-Signature: 58w7tto9rdbystjmm8hm83tki9tzmki5
X-Rspam-User: 
X-HE-Tag: 1757362524-88399
X-HE-Meta: U2FsdGVkX19VcZEoGqWcsmgx/A7dGH3Uik7kbBkk7JrHjCYVQToSRyd6ZK4uAs9GYN01AB+OmgCcoxxksBWCG60U8EZNcDS7rkzEhlnPf3sUmZezStggsODr94ux+Tt/HRhNH5tCZ2i5UChQkD8I+e636kkiR7pwVebhAfpXoMY0fYTdL9K2em/7IVQ5sB3Y2oSXbVg9CQfP+aWak2mvyNYbrd29uKe6JyVW3IPuh+0AvFdD49IAarwj5caUXxvnDBWDZs+03AKPyPr9QRP45gZt177727xYrf4JSpzIaSnLDLMVZ+Sw889W4PzqPLr/eCxjUWdCeBBqjUboK8zBlYEXx8/arKX9wdMWiEi1WCDur4jlAXJgmAg5B6jNhYuUkcZwl8Tp8pLMzbFaqIClnOXof4K0tHcSZl6Q4zo1TntKytL7x/wT0amyveXDgGxrVzEcbEJmS5eGpKkuZzTLG9yDlq1i1AgH5jyhYMqm5bh/NLnplyhK5WvZ9lTUU/pTR3gE3Vh0sDedBpR7J+w6gJu7cLuGsfd7klQwZGLeELfmjPfIy6fkFrWAxshfaY5ihzKcHofLW13pjfZGu/FS4HIa/Hnr89tKaA2S/JQ4OEmJJVrXvUVCXff+XpJyRJNta3tTkV/d70uyzrJfnQYUIho1jLGKun09WhBzFvCUpNNinQ8KPbQxZzAJqhZSwzTXd5pP7J7i1BYRqXfjYLUZfNYa5iPR/2kH85XaiMXk7rQZAHxtAbza3R9xwTre2k/+cX8QDORuvrUaAu2qaPnGxIgDeU9lz73U6G7RJbffSc2k0ow+FJmqWkCtXe1+e/Z7VMBOQ5sfvm1WnJs4NXRvcVbdfwcYSS2oF46Y3xtpcPV59FvMU1ftLaLk9fD9DFJMrrU4nikQwtP9RFSRJ/7cMc7KUUPpRAsFvAcEAjGJ18ziDR/AV+q3y71MY/pq47+oylTnq3B4d21MrF6G9/C
 JktE45fV
 4J5XE+XRr1YCkh5r/PsvHA+lonlju104LflIz6H/y15cEqZ/uFF+soI1YpuU/ii+ExFgMZvsJS1tFD0vJ+Fh/ugW6HL06uMHQOWnXSk+iE16d4P81b0EUNJc5G4M0Z3zRzqqUHWPLqDThM7xbQRoKxFHctn4Y1XIcwxnKdjnoWlq/nbclQjwj7zANMuT9g/ndqVHZK3TSdvTSYB0pmt2ZY29P+ZTRLOsLF7NkVZED3YTXWvx87kNk/Qmo+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When damon_call_control->repeat is set, damon_call() is executed
asynchronously, and eventually be canceled when kdamond finishes.  If
the damon_call_control object is dynamically allocated, hence, finding
the place to deallocate the object is difficult.  Introduce a new
damon_call_control field, namely dealloc_on_cancel, to ask the kdamond
deallocates those dynamically allocated objects when those are canceled.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 mm/damon/core.c       | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index ec8716292c09..aa7381be388c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -636,6 +636,7 @@ struct damon_operations {
  * @data:		Data that will be passed to @fn.
  * @repeat:		Repeat invocations.
  * @return_code:	Return code from @fn invocation.
+ * @dealloc_on_cancel:	De-allocate when canceled.
  *
  * Control damon_call(), which requests specific kdamond to invoke a given
  * function.  Refer to damon_call() for more details.
@@ -645,6 +646,7 @@ struct damon_call_control {
 	void *data;
 	bool repeat;
 	int return_code;
+	bool dealloc_on_cancel;
 /* private: internal use only */
 	/* informs if the kdamond finished handling of the request */
 	struct completion completion;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7aeb3f24aae8..be5942435d78 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2510,10 +2510,14 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 		mutex_lock(&ctx->call_controls_lock);
 		list_del(&control->list);
 		mutex_unlock(&ctx->call_controls_lock);
-		if (!control->repeat)
+		if (!control->repeat) {
 			complete(&control->completion);
-		else
+		} else if (control->canceled && control->dealloc_on_cancel) {
+			kfree(control);
+			continue;
+		} else {
 			list_add(&control->list, &repeat_controls);
+		}
 	}
 	control = list_first_entry_or_null(&repeat_controls,
 			struct damon_call_control, list);
-- 
2.39.5

