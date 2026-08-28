Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE4F9C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 17:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E74B6B008C; Fri, 28 Aug 2026 13:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BE986B0092; Fri, 28 Aug 2026 13:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FACD6B0095; Fri, 28 Aug 2026 13:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 522866B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:51:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7063A3E2C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:51:07 +0000 (UTC)
X-FDA: 85151419374.20.23BC0F1
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 412F8100007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:51:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="hz wq2uT";
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787939466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HRZSERTM0W44dOUuuxbU9VU3oVx0AWLYRmfUpfpxEzc=;
	b=SpkCdJK4we4R+k1R9ftaYHxF3leBW/0HDWc757jiMQPBaQqXSR4pPN5TJ20qWFlMOJLym4
	SxCargX/kYxeSHG9uEOUEImhtbkTdiMU7vD26MAcXfoL2YsT/MtJ4AP7EDYgCRCPfIBqYb
	T0yHTciJw2JDU7ulivxxnqdC4DUbrfk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="hz wq2uT";
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787939466;
	b=mzJ3u8o4wSmhZeG2ZtBg9x+ERdeaDCprkakBZpYOFep2Z0nHM5jSNJ1KpHDzLCtnOJvqaS
	zEgdhMJKffe3XVnxz4Oe/8H7w5bNlo6G0JiVmOklrZmTEsrFqFLv/S15+lxUFtWMiioOZk
	ly3QbOXMJUEWK4GIbro/Qa/8Tj0b9UE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=HRZSERTM0W44dOUuuxbU9VU3oVx0AWLYRmfUpfpxEzc=; b=hz
	wq2uTiBTs8IkwanKDfjgJVs1pnY2pp2w3uzTcO7HgW8d1Hvy8ZeNbPuQ1SxbBooaq/QUzSrOHiEpb
	7TQD2iTEBnTiB5qScFe5IN6zrGaNINE4x7Q1uv1k9OOr+Z0zhRQcUnP81v+8Mv/7ukzZYYpLDumoX
	ENifvuszFTj8zU5VW+5QRvMWO0Qv5oDaSEBrPqru6G8G5DVTbHnIWfox7sOJTlmHwXCx2iXrYkU1E
	GDP44K8sM89Eueh9TO2HSnS+0JVnmrlSf6N3N9WgA7onuMh2BfLA3nya5z6wXkJ8DlMtFo8KxS5rM
	vaQlQ8hR5eHXWUSKVMy7/0Wvvbw/aORw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x00ir-000000093Tk-0mpH;
	Fri, 28 Aug 2026 17:50:37 +0000
Date: Fri, 28 Aug 2026 13:50:36 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew
 Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com
Subject: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on
 isolated cpus
Message-ID: <20260828135036.7d44361f@fangorn>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yszfjsah5xjxnp84ts5mg9b46s9od83o
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 412F8100007
X-Rspam-User: 
X-HE-Tag: 1787939466-400204
X-HE-Meta: U2FsdGVkX1/Km7xXdP0quFyjtn3YJvMvaa2v7qON/f2Jyx2EQ0ZrXPTC++YuijywrthPfM5xmiJyl47yQxUaDwsN9LtKivzvv1GygCuQz/K7Jl5X/+4CvssfIyZbL6ecyeBZdGXf+Nxu5AamlpagOcKdQr8v1Czaqvtey1TKkH1SQuDmLk2Y6I6iNWh4kwcaErvVvjiA9t/ERyaL757SFdc4guU91ZJvClILEFGfEOnjWGP7fSJ76gKdSn2wLFjeAjcTmCsZpy7smpLsNohlPJ3aHzL0be/p0Io2EG16EwaMsZa2qUu8XEqlb+X/RPPHTXJBiS5FZRwDqU+C/Hk6Omft7scZ67laQ7Wj5qBMOtI3AaF5/qWQAwBaKEwLbd1l/+MPFLBxu1Cb6ZWxIGBJwVRk0p1Sv2E5q8S/tVCWg+DnJo1Nz3vtDCAheAmhf9nxzqGUMNKhAypyhOTWMvKL5gV0WY8q+Z3WInvZiyxpN+j2bp62yC0qcfhyHbOHx0f7ZhbO1M7tPj0wDgPfJgZP4TvhgVNqrr9gPLN1nN2dZEi87eQJaYIQhpqF82iP6yHOPY/vat7pSV+4U+lIyAz+PMMVgvT8H5rkOFoxW5MjFcgbQ4M1uDemxM5O/Wl5bhS1dyef7Z+1u0Bex7ETmCb8NECa1Y3RDWbuXLnL4AV5POLTVTH5XQbMylWT1BaIoSjVn3CJWvWxZF/E5RDFu1IPqy7WxUb3pp8sXRCIHTWPMgYDv5sV3mSKIxG07p+PgY+hyvE4lfRc7qFn0uQAwNb6F5/v65i1puJGF2sYaUVCitbWB6F9h+j7XBgTP/vWviMFg0EYk41Yw+6TTW7TZBgfRisJbtnDmaPaxl/IWOQtEu/0pI6sSSgk6yNsdb3JqkeN1vWbjMIwx+iHOwnhzU3+5NEIho5LanhMcVKjQcmrChAGl43KLanswGdyQGQe5E06I583B6TpBC2YePSahQi
 KfuXZ86J
 Z6G41Oqn4w74k7XN1kLD2oDrZf/84SSrmIKLJtuSPWHZB/jHFiOXvPbwJTQN0FMZR3t58XW6d+huBe+MVgODajCYVoHbO0u8qwUhXlW2mseRPjDgx4nmtcQHTXdZX7uE6WCdq9DNwvqag1rdE7qGJrwHit9aKxMDTI+BH+aUTYyXOewTb/X2qA48SjA3nY3dNMPJW58cofamlL8NDmmrVcMz/JMgD5zctVgmmaCpIq4HlnMH3qzgQ3nMsL833l7clO6+YAyQBPvgut7RQ/vzJYXCDiApl2WJc90wD3nQ/nY9SnarE+akl8aggJmOFjzdpiiYt+HEjWLTYoBwrFghK/sgM1jbiWWxMHmd1Dyc3eBIYl9iygoen5eH558+lyq8CmiqDLxLuKNUntNmPsI8PNoRIXjvqVdIcXrQsMQZAoMPEQ7Mk44o6aV12MmgAshKMMc6cOZj3FlO7DJUpykGV9B6mUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
isolation, schedule_drain_work() can drop the work in a separate RCU
critical section, and housekeeping_update()'s synchronize_rcu() can race
that second check, leaving the flag set.

drain_local_stock() only clears the bit for work that ran, so the flag
remains set and the stock is never drained again.

Have schedule_drain_work() return whether the work was queued, and clear
FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
isolated, so future drains can retry.

Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
Cc: stable@vger.kernel.org
Suggested-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
v2: use the approach suggested by Michal and Shakeel

Link: https://lore.kernel.org/all/cover.1787890328.git.riel@surriel.com/

 mm/memcontrol.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..309398e943ca 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2306,7 +2306,7 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
-static void schedule_drain_work(int cpu, struct work_struct *work)
+static bool schedule_drain_work(int cpu, struct work_struct *work)
 {
 	/*
 	 * Protect housekeeping cpumask read and work enqueue together
@@ -2315,8 +2315,11 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 	 * pending work on newly isolated CPUs.
 	 */
 	guard(rcu)();
-	if (!cpu_is_isolated(cpu))
-		queue_work_on(cpu, memcg_wq, work);
+	if (cpu_is_isolated(cpu))
+		return false;
+
+	queue_work_on(cpu, memcg_wq, work);
+	return true;
 }
 
 /*
@@ -2348,8 +2351,9 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &memcg_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
-			else
-				schedule_drain_work(cpu, &memcg_st->work);
+			else if (!schedule_drain_work(cpu, &memcg_st->work))
+				clear_bit(FLUSHING_CACHED_CHARGE,
+					  &memcg_st->flags);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2358,8 +2362,9 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &obj_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
-			else
-				schedule_drain_work(cpu, &obj_st->work);
+			else if (!schedule_drain_work(cpu, &obj_st->work))
+				clear_bit(FLUSHING_CACHED_CHARGE,
+					  &obj_st->flags);
 		}
 	}
 	migrate_enable();
-- 
2.55.0



