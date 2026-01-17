Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C543FC98315
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 17:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BCDF6B0095; Sat, 17 Jan 2026 12:53:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364836B0096; Sat, 17 Jan 2026 12:53:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1546B6B0099; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E67416B0096
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A956F5830E
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:08 +0000 (UTC)
X-FDA: 84342202056.11.A493D38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 44E9B40007
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UfM8M+SM;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768672387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYMc4rcFkzTTI10yP4X3zEYHNwACyPE4X3pip9DWeSg=;
	b=sJI9pyO+lW09v1x2P7UBiBtpID9HGOdKNSeX2JiWNoW13zMl0Ln8tkhzqiw8cn8yc0fRMQ
	Cc33qXX1Qk4d17cib9pUGP3wzj0Uoqg8djo157OejD2KNLY5SAQnTzfOTGzBndsyZi6pAp
	DRlVL8fc0ZkDsC9KtHprYoOi+AtwZOY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768672387; a=rsa-sha256;
	cv=none;
	b=4jJektseIrpuGAC9/xlNdOabOybFH02my/tJS64dkHBrQ54IJfbVTP/D+yNoZAJ0Y4dVU5
	6jlqe1FnTtOC4P7vSq3Wpb1RW9ro0IDjf83mKxK/oO4DZCW9/0Cw6zzz7Z6jTSlbo6sM7E
	K9lIjzvUCa+KWvYK6r56HCtnno5AecU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UfM8M+SM;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DA4F4451D;
	Sat, 17 Jan 2026 17:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315A4C2BC86;
	Sat, 17 Jan 2026 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768672386;
	bh=7VEEVzVbGPHB0sjJISOx5ncW5ljPkQ2sov44I7vDx9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfM8M+SMAF0BMH7Y/czx8wjsNtMjpK6qxKcFNDq1uAuro2RDz5SmQDhDZgxVcckxW
	 oHwmY7YY24ge4I3TSAexHakUPVxF5vrAGp5nP8D4XeSv7VKXxnUgoDWTcUymeAffMx
	 0NckojFCHUHeb8fLIHrcNu6uq/iJ2IqsPmeo2Ekf+ivL3Urr9xf+aYwfjF8Aw0lY3t
	 lcmGsuS3MyaIInwmrHaNRVCAmyE81i3+iB9PmT0+XE8giU96meslckBAKAeATVN4Xd
	 h2BPRGje3+TCWCE2KqFOv4VBYRyLAlpGQDPE/IpVlT424mWtGJ8btmG2+kyINbbx4u
	 EpPLhEyy2tD5A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] mm/damon: document damon_call_control->dealloc_on_cancel repeat behavior
Date: Sat, 17 Jan 2026 09:52:52 -0800
Message-ID: <20260117175256.82826-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117175256.82826-1-sj@kernel.org>
References: <20260117175256.82826-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44E9B40007
X-Rspam-User: 
X-Stat-Signature: dg85bd8e5h6ggqar3w7ddk9uutjuddci
X-HE-Tag: 1768672387-572115
X-HE-Meta: U2FsdGVkX1/bvu1qp0S01bPQMZzA48g1Gkml6Vl+Xl/EY23uHNjHA6FgkGSSvTrvr2hyIBLGncKaYm5oG8aVp311hFphexFD54Fy/1LtukH7nZhpweZNpyoKSCAdL4FAiAnSGBB5gnJR4zctYKKoQcoibbed0luPv6qd+029qghJWd/wYMlTGGO7+EW0DjnMV0KV9DARtRl7FEsOJlEEavjXE6CVm83dtfPQlRJwpbcbt+W6dbMMW+uBe8+moslFe057kstmXncB3+Lv5VOszGrMfbVd+/M+/7bSsW+zKUQmNIQYe4hT1AizTsddl5HvgD+sz02Od17xNph2DrYkbetmVSN31fUE5LUwMGUs8/1Rn5PNQuSHIuQsvPtSiVvYiOHAiMV9gB/xxysXUVq6NrHIs9mqu7DCRt0pATvvlyyvnwWY4nD+iZrRjWwMGU/5PNb220cVbP2aOHhqcCmx6o5XPY++UhIK858rLfYe9M/PHmii1frarA4bCfe5MRgTUGBAXvAwwMEzfFqliovKsMCQPE3Wyi678BJuOFo6JegJdNkrbDCT1XwjxXA1SLLCQhkwTVfN+9JdEpOOb8TOtEBDaRBDX11ZmTucAH9q4sYVIHfeK098nvHyugVLa7MXA7nsmUyqb7E0rT4FDvHqqInItWsYtBu69J+bHBUq8tDQqfavxrXTxY9jmeqjTtnAdCW5zO08oNuQ4iaT4q8Qe2EGmv8wZwMYnhbZ7/LxH1/jwgTkVBrPi1T+Zp7rOEvM+86e6SoSPOcKWquCPLh6rmDTix6DaaPGUISJIhn8FXwoQtFJpifY0riyo87k2dQq/jKJyjM6at2PE0WFitB/A9D695ESF8rxbc8Y3FiEzE10jssGmZL0q4JwccgSbiGNC9TSepJqfHQJ/4DJ1vKPm7NHPU9cFvtfzEJcHDpQPTPZaZSC8RxMOy6nzIxT+1J4MHp/GWXMo/dMHozRapF
 1/mtLd7a
 gk6bYmAU7tyQOmGljJeSjI6jVsnAufjq0/PYn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_call_control->dealloc_on_cancel works only when ->repeat is true.
But the behavior is not clearly documented.  DAMON API callers can
understand the behavior only after reading kdamond_call() code.
Document the behavior on the kernel-doc comment of damon_call_control.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index bd4c76b126bd..bdca28e15e40 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -663,7 +663,7 @@ struct damon_operations {
  * @data:		Data that will be passed to @fn.
  * @repeat:		Repeat invocations.
  * @return_code:	Return code from @fn invocation.
- * @dealloc_on_cancel:	De-allocate when canceled.
+ * @dealloc_on_cancel:	If @repeat is true, de-allocate when canceled.
  *
  * Control damon_call(), which requests specific kdamond to invoke a given
  * function.  Refer to damon_call() for more details.
-- 
2.47.3

