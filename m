Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B12606A327
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZO3/k+0r
Received: by kanga.kvack.org (Postfix)
	id 071E96B05C7; Wed, 28 Oct 2026 10:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049336B05C8; Wed, 28 Oct 2026 10:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA14C6B05C9; Wed, 28 Oct 2026 10:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3E456B05C7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:17:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 457F5A86A7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:17:35 +0000 (UTC)
X-FDA: 85372238070.06.E1FFAE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A35581C0007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:17:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZO3/k+0r";
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793197053;
	b=ynrZljA7CKyufBrHIVFqSixAnDrgcJLbfGtknWdwwnkr6uy5lmmiEWBjFcqMH7u/mZaVod
	z0aiA2KsCy7eM24OMfNnk3A1eaYXgfVXHw86h20BwrNafaOlcfgZfLLHLSQpMxBE+Tv6+f
	q3lll4n6vJbVBqpiIuaVYK9I8AY3FS8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZO3/k+0r";
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793197053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yPa5wbC5qsV5ePJc3qyfqSfwGtResrr8GiaQmPYPZk=;
	b=DVN4xyiKH48hvX5974JFshfbEyD8AanFs7+WO8LawreLEOl0mwnuW6qCCVZK5q2iVwNqzg
	GbOZyWBjUVzMTsAlgo34in2ixj4tyRm4GQE8Z84nR4qih0E7W9NKhpldb4qaKRPvPDECpN
	jNo/WY2AglsiBD1XTn4q/gG6AkcuIE8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1C4443FE9;
	Wed, 28 Oct 2026 14:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDA91F031E7;
	Wed, 28 Oct 2026 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793197052;
	bh=0yPa5wbC5qsV5ePJc3qyfqSfwGtResrr8GiaQmPYPZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZO3/k+0rpGxjzv5FjESP8rdCYPHL0qIKSXYtMfk/WcjzeFRk0CxkzDIDcLvPixOzz
	 yOXzMWjKta0SNKf6DVx+eYL1ZsRKUiMRiQ/tJgCU/Aq8MY2mm6rLJld/ZIJ4Q2XYjT
	 c4vT4vI8X8+C8YkdZiP1Tic1uHVmk9V5FuxPpI5Q7KO7+kboZhWpl3FhaeX9iSLfbW
	 2Jlu8z38EAtvKzflNrl0CbJDKXLdcEsPguDC/MYxIc5BzHsenxBqGwAE2+5FA8x3j5
	 hQ2OWiY5D6JwD29cq3ADZ7HrkpoqnQBUBS8q6pI10dJwC9vR2mJgLn9f8Lu4ibs0cp
	 J0SC/B7f1YJ1Q==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.1.y 1/2] mm/damon/sysfs: put target pids for damon_start() failure
Date: Wed, 28 Oct 2026 07:17:21 -0700
Message-ID: <20261028141723.161776-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028141723.161776-1-sj@kernel.org>
References: <20261028141723.161776-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A35581C0007
X-Stat-Signature: si7hhyugostjzy4fxbu39q6th8jotn6h
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793197053-620954
X-HE-Meta: U2FsdGVkX19qNyCGN6sxQd/nr9OAw4wQGOAvzUWPnvWbzE0tagMWYnNaTPCRaWLXzzS9S7cYTidg7j2biSPgwQGp/5HxTC6b5wIDUsh2YCQtvXSmc/Nnc0sBlQQ5NSz24lx906gvRbeHCj7k8VQGAaCdwihaHo8aMN0Ct4EWNDBiQRdKfIuTmcdQPuZDPMLL/SxXhUoY4LHYE9RPXaWhy9fcw+OjevMrtmrij4gVgGvg0b7rHlCILTszfuI7S+fqk3AhZvVvfpxEw5ZPadwwFrupDsnjOxXygIuVG6JAFhqM7Vdhn+iCq+JoUH1b3DyTfQCgkFsunQjqOxryz0MeuGz3h2/Wg+lfhCg3wg+LwdiiDeA5IQzPF67SR89W2wOpkjAsJpNALMDaE/jw5xohr9YA1aDbNYWgx2Y0HjH5ZEpp/y2YJvbh3/WeBKWa2lqHo47KbdPic7BPAUFVl47GdPn8GOETDJg/Uz6q2hOVkKYqNKEZA2xkbZZ3B3OPuw3BPExsZqBLvPpyiCiJ3/FSv1yl2bdDPAEVFoKjdk8BvRFioaYWr36X0dOnt60iwwCtxihHaHUVcTFHraA3x0ThGMwJk4I0EtjlChoae9l0VhVB7ebfQLfYb+DVl0hgUGXN9oTEkCCOeMk1Ct7D++X80laJ/TUyuDfTubgKYsHS2ozRMgxnF7Mo1RrinU7OlcFx4jVhhyr2wMBzG/5/94A6IiSw8UvV3JB2/zRPNdzHPxcRcmWFZ1mwQcx83rTu1GqSXrgToLptEzLtCe+EXvCqqircVUpEEMnKSMpsYMBfQfEdXz+Fqm2LzRfY9twS7jB0g39c+WRoJevXzyaaqhbgF0SS3d6z3vRpwdluBpGVVfF26CHy+ywlx79+GX0elapL/GXpIQrsL4CYLUR+tJwsg9OEn0SxTAFTVBLDhDuzgzba53ACmWAixsC4ucuFqyIZ1sw7XjC9Obx9JRVbmC0
 gJQRsr9i
 cjBhs8N6Sn2DdGVdnqsNDjAMjxHRaSpc7ePdnQzeW+24ieTSsT9HnfBmm8J+SP5cTUjO1so7nha3Q265n2SB/LDZjHg4ZPL0XRuGdSCDUEQo1rnM2U2JEL+u+b7HfbKUTwlvo+UfykZ4ihPUIrhkCUvJz2sOpCW3dpZoWNyQMNoulYhK9u2GOsCVbOjojqUqsfgGM6eHAuZ3oKDpYlwOioStL2pdg+DTbqWkR5iVoI+ipCnMaM99Gp+zZp+fIgc7P0XinKU9POPOW5W8A8WlXjYdr+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_sysfs_turn_damon_on() allocates and sets up damon_ctx to start.
If it is for virtual address space monitoring, the setup increases the
reference counts of the target pids.  After the setup, the function
invokes damon_start().  If damon_start() fails, it deallocates the
damon_ctx object without decreasing the reference counts of target pids.
As a result, pids can be leaked.

Fix the leak by putting pids using damon_sysfs_destroy_targets() before
deallocating the damon_ctx object.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 9a918f8e4c6bf..4b28bb9ba0a24 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2547,6 +2547,7 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 		return PTR_ERR(ctx);
 	err = damon_start(&ctx, 1, false);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return err;
 	}
-- 
2.47.3

