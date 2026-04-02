Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 318D5CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22AA66B0089; Thu,  2 Apr 2026 00:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DBB56B008C; Thu,  2 Apr 2026 00:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118A76B0092; Thu,  2 Apr 2026 00:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F40566B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:59:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9ADF1160432
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:59:32 +0000 (UTC)
X-FDA: 84612412584.29.590BD10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0468B4000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:59:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GQNSxGvJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775105971; a=rsa-sha256;
	cv=none;
	b=P4UBSGUj1dtZQueZVSKh7MiM6OjFxbpdDJ9TizXsGDslHXO+4vYguslOW961YruIdQlzvX
	jDIbzrgbGyCydhecI3svex/0csWfCTU3JBxYScTXqpMZ7LtpS7Hdk+3RcwWvpqwXebYR7z
	5L9LE4feB1Nbpjh0Qk3V6xMbVPmsQ2s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GQNSxGvJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775105971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I9HJX7G/aT3EsFL57DxQRWUu7jGxvPhUWoMRnfjLbpo=;
	b=6YX/kXyStprk32ExEAyEhI1q9cA1K8/+wlc/XQfbc9l1vNX4TD3ot7yJo4Pa1/F0/TwKLl
	ajSDlqKygR7aF1OhH9cww6sHCjDTyvcjrfjXhxwBZpAbDjxzRJPAqlEWlfINvTd4hW/2vG
	TPL+4Imsjkgh2S1bLlkOyC7ow0AKY48=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E90F41986;
	Thu,  2 Apr 2026 04:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3824C19423;
	Thu,  2 Apr 2026 04:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775105969;
	bh=6b8L0fz6vN2/1FdAdwuuqgyRC2q1kGbwXl4DDedgmOI=;
	h=From:To:Cc:Subject:Date:From;
	b=GQNSxGvJXNxyEJ8v1iJtxRdhpFpT1UYFKJ2nnOYJl+ulwa6klYQoB6lX5VLEG+JCF
	 4iGHNsT1VIi/PO83r/d2jEJjs9so9qxp1loeCIPhgDZ5Fcn6FOF4M6Zt5uBSKj5DX2
	 LDdEXkgxEY7Flg/ZYxqN41UwCVFiOY4w++btd031t1Odw9qIlxV/TP4wzgSAk3Wa50
	 fVuq9QOr3nyRik1CAnheYNYAHjU3JkiE5g5MtwalsHw0d/Y91Dcf2pwdiCRxmnYdSb
	 X72Eaifh5mxpADuWsJOClBuFA1CTpt6uBcyCaDLYL5sjLBPpatQko5uXVL9ONmHQRp
	 75aHoyYgf7eEQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Wed,  1 Apr 2026 21:59:26 -0700
Message-ID: <20260402045928.71170-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ybuj6rehinnyx1fnn7hmksfjxog4tnpr
X-Rspamd-Queue-Id: 0468B4000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775105970-586626
X-HE-Meta: U2FsdGVkX1+btjNw9WuRQ5j8/bfngbJsth0eP8Z3P8FRntVdOmiZthg5fACQfjLwPDYpPJcSi0TF4KEVy67Ussd0to74ew2EKngCDUAu+5hQZGE8UlHb94xUb+zLhMKshUS60Jxa9BieWLruNC/FzKQOhhLt3mAEaDNmfRzuj4GWF4blnLS6eg+I65/WiYiwa9NS32yE6BWFr3rXvN+p+e494EvIlQeo1AMeBUG3O9tJK71pLKXwtIWZ8gh+X2tSuTbMpYTKsAUeuQe/1C9k//2iYAA/F/gI3S0qpfx1cfSr9cqtlCn4RV1dsELb5+ZFH7qknqPqtAWl3Uvfj8ZDXp5TcELO4NlnnaXvrvX2jKhiJJlfYfY0jXQQLSHqWbG4QyE3R+MOGdu4ycnH83GyqMl31Gc/k6Gwjw/8M/fJ1zn/3Ax+2Snr8Vkw8Wf/4vXc1Tg5JNo9D4DYPX0+2E3aOQIs2NsrK9lzMk8d9zbiNdJd1B3sysQWzjvYN6BVixvwfZHwbQ6FMKXEHqhhZeqwQh6DOcs2NXosVPSsUOcbxfxhYYWhxVbdi+iESWhTrDgzfkYSxH9dapawTUWrSqkUXBfPeJ9Kb3SaLT3QFH70xSbG45d0VRHjHsrpmyGC1bXq9/T7rXBIUdol8YQGkDOoZ0Bu4RDrWrQjQMoudYS8+dYWeYZD8TpYjbK2czL1vz+P5vf8ZecCQQEE/yFV8wzBdukhfFLtN33lRqp4cIKR0DHD/0cNGCcTucVA8507QQo0wqa+gHA8WMFfHvEjzo9nvj1qEpVu6t185BcVnKdk6gwLFUoJU+m2kyYezWf2PGTPv/hMNgVQJbdmqzOyInRb9wlwKYgg4Q+kTrlSrkaWcx6fUVY9ZoYBhDMfg+YisdP93znt8DiUNAbmADB08FVGgphev/wPopAIo857sE2oUkN08DeuFnpapjwQsb5JYeMyFpkIiflj5znNZv522NR
 ImGyABhV
 AOvjaJ50VlxZgxLXTsZjQA7Xl/bvM6PLEtn5RpQfye1MRUR2oi8xvxyeyJTY6Ci294+N8aHuqszrCYwOhCWvr5eTWZKbBCGPHX41Zr3ZNfsVorto7khbgyv6Le8OdR3JtNem9oNH4UqQ+L1vxS7q7twvtt6JuUeju/8GsmpPiwuMvMRqM4BOvZtDLkppuv7AwBpoTAU4rO0QFROsXXB/iDwlL85QePx2d6gZ1Q2bVZvXABa64+VDTp9ywnGWB1L+aOot4wEWa3FUB5xuo7LM1ID5aTgF3ocLa5WTdQTGSVlCsPvS40qrpGaINMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stat_start() always allocates the module's damon_ctx object
(damon_stat_context).  Meanwhile, if damon_call() in the function fails,
the damon_ctx object is not deallocated.  Hence, if the damon_call() is
failed, and the user writes Y to “enabled” again, the previously
allocated damon_ctx object is leaked.

This cannot simply be fixed by deallocating the damon_ctx object when
damon_call() fails.  That's because damon_call() failure doesn't
guarantee the kdamond main function, which accesses the damon_ctx
object, is completely finished.  In other words, if damon_stat_start()
deallocates the damon_ctx object after damon_call() failure, the
not-yet-terminated kdamond could access the freed memory
(use-after-free).

Fix the leak while avoiding the use-after-free by keeping returning
damon_stat_start() without deallocating the damon_ctx object after
damon_call() failure, but deallocating it when the function is invoked
again and the kdamond is completely terminated.  If the kdamond is not
yet terminated, simply return -EAGAIN, as the kdamond will soon be
terminated.

The issue was discovered [1] by sashiko.

[1] https://lore.kernel.org/20260401012428.86694-1-sj@kernel.org

Fixes: 405f61996d9d ("mm/damon/stat: use damon_call() repeat mode instead of damon_callback")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v1
(https://lore.kernel.org/20260402010457.66860-1-sj@kernel.org)
- Avoid use-after-free.
- Add RFC tag.

 mm/damon/stat.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 5a742fc157e4..99ba346f9e32 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -245,6 +245,12 @@ static int damon_stat_start(void)
 {
 	int err;
 
+	if (damon_stat_context) {
+		if (damon_is_running(damon_stat_context))
+			return -EAGAIN;
+		damon_destroy_ctx(damon_stat_context);
+	}
+
 	damon_stat_context = damon_stat_build_ctx();
 	if (!damon_stat_context)
 		return -ENOMEM;
@@ -264,6 +270,7 @@ static void damon_stat_stop(void)
 {
 	damon_stop(&damon_stat_context, 1);
 	damon_destroy_ctx(damon_stat_context);
+	damon_stat_context = NULL;
 }
 
 static int damon_stat_enabled_store(

base-commit: 4fd04f750d79667937931314ed64c9d79b0d82ef
-- 
2.47.3

