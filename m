Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9180C87FCC
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 20:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4756B0092; Sun, 27 Jul 2025 16:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A565E6B0093; Sun, 27 Jul 2025 16:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943E26B0095; Sun, 27 Jul 2025 16:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8306B6B0092
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 16:18:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0CAFE1A0C77
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:24 +0000 (UTC)
X-FDA: 83711156928.30.B30E41B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 83A5540017
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F4IztOny;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753647502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAtaOS977AhfAqjl0SBE5F/WkMoQk7y3poWER52rZ04=;
	b=DX+ORmtBz3Wk3Fty5o12LK9FhtxCGSRFYbaa4GQenTRpxuj/p1YVjBoogK6rdZnDW0nocL
	FBdgfb3PJjxH5vJPa1EBLaXBD8EnBDSUEsiuFUmH3FblwuoTOrfNAtL9+I1z1RzrE6gq0F
	MfA2Bnr+cJKNA+zQTxnWA7s6Q1Z05G0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F4IztOny;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753647502; a=rsa-sha256;
	cv=none;
	b=PXDU8A25W33s3qmo7rjvdy/Jvx5Eud9ADCmssGNIzsP6rSUjvIp7XXPG/4fyN1qhHaNDMA
	XUHGRhpK5khqMx+DM+sGvlADMknTB2D0nZoEO5fdq0K6BRuelulWC4YUnAg7YSTVnrroSp
	Pwi/+cP5o/2oaLQlZxVs8v/yNNwuxUU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8462345C61;
	Sun, 27 Jul 2025 20:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4808DC4CEEF;
	Sun, 27 Jul 2025 20:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753647501;
	bh=NkOlFUXA+qPHhiPIn4M4gJxZzGyprOZBn0h+Dwp+Qx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4IztOny+fn1C3EUh1pj9ARTeeD8TOf9NgKIVCaojvSByCCvki3xxfOrbkuouJxzl
	 XHorGjFUUMs/o71G7GUlAEm2M1DAVPpg47dNVSiMLBvoZNU/5D1aBZtxVxILIm30kB
	 5mAThhUy+RjFprJ7rcR3XH/j2lUKwiNc9Fvn3mxf2Qi0uRLk5qpUtTW9Bam32otJ0r
	 eqG2XxZNmvzLwnGxKLy0duXGxLU3zCk2EGkMjsb/kZwT3r9lHeKNC4Ezv/pYILS/2s
	 rtdicMP3GtNeB02eOtUwNVKWbe2oh8Zubeuv7GaB57bD2fiUPqysv2doZ8UZlkcVfs
	 k5A1f6ES8eVlQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC v2 3/7] mm/damon/vaddr: implement eligible_report()
Date: Sun, 27 Jul 2025 13:18:09 -0700
Message-Id: <20250727201813.53858-4-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250727201813.53858-1-sj@kernel.org>
References: <20250727201813.53858-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 83A5540017
X-Rspamd-Server: rspam06
X-Stat-Signature: eqnc38k88cdk59prm738fnea3wbuhjso
X-HE-Tag: 1753647502-537150
X-HE-Meta: U2FsdGVkX1+EhQKS5W6xSR0TsOj77WysE5aAgVy4j11nAn3tizVcid6129bBXYTUKQnDg7/5zC5GIHs0+8J4GJq587zPmA8OKEgpHHhshQfLsZPGyRvC0oWxVnYPUf741T4Nirsl7nn5Ko137tPERvGTqxX2d6kOX5EIsuzR21YpR2QVwPuY1CHtxnrms4ijvmrdng11lGcVcWwVEPNkOmDDYzxrlYk6QpX7mv4ZA1jUTibFn9w9VYbRYMfELijzLi8GaO3qecjFVpw+M0iD6zxspYlOFdnu2SSJMKbRVImhDEVCppsua/5cja6PzNEiMIcqGod7j9Q9OFAevfq6GQdyD18kw0lon3wLeV0Y0/7FzJCLyAIM/5fZCxK46TsIKi7QibwGQA1TQqY2LZO06eVuAKlRiMd/0Zzh6gdjke8vfICJHLDQDJ8AGLoBPeccr0NGo9RAc+VT5VdnBSKi8L9mQxTx6DdgXyyN9d4Mvngphap7870jgPaJT+aGa1m8zepeRLWo1LviKJyJ2B2R6k5I856gHHdKsmiCly1dMop5rDgeuxBe6l5bzos3qt8dKTvCUZjWhoIloZuDrkSMAI23Lwwp2tJYr4OQSq0VbRDzsht7SC5AZtrpBoGndBSrfYIyAc3fSeYV6+N0qYyHcwkVYSw5TE9+AcSpQlR0oHPKcSWMR1JLhGY3+rh15TIV+gbQTWGaUzgFbuHzNkQW5z+1aDUB5Zllgk6OMge3OJZ0a/jmaHER+ZJyikNZfaG1Sf9kDCsEWBO4+ZFq9S2lSFCicnsMcXTXii2PAQHDL7s3mSZYEGnJOxaKNE6h9BtpUNuostU47n3C+f1MxUvXuM4v5Vw3iuJbSQkrJShksoI5ulBbEBnYFiuoycGg0fxVfw3zTXsHfPanaqr20XtYjB7YtFXoVNIjk6juXGDyE51Ckkh0BA4d7ipNC5BOBW62REAzP/mSzqT5wyZMyRy
 yDidVYP0
 tKZcZS2mzFC0/GelnuWaAv097huy4W7wsKCnz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement eligible_report() operation for vaddr operation set.  It
checks the eligibility of the report based on the pid of the report and
the current monitoring target.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 87e825349bdf..a80cd34e5232 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -792,6 +792,12 @@ static int damos_va_migrate_pte_entry(pte_t *pte, unsigned long addr,
 	return 0;
 }
 
+static bool damon_va_eligible_report(struct damon_access_report *report,
+		struct damon_target *t)
+{
+	return report->pid == t->pid;
+}
+
 /*
  * Functions for the target validity check and cleanup
  */
@@ -954,6 +960,7 @@ static int __init damon_va_initcall(void)
 		.update = damon_va_update,
 		.prepare_access_checks = damon_va_prepare_access_checks,
 		.check_accesses = damon_va_check_accesses,
+		.eligible_report = damon_va_eligible_report,
 		.target_valid = damon_va_target_valid,
 		.cleanup_target = damon_va_cleanup_target,
 		.cleanup = NULL,
-- 
2.39.5

