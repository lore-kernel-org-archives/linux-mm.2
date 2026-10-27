Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7533606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 21:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=PEjfA7Jh
Received: by kanga.kvack.org (Postfix)
	id C40A86B0606; Tue, 27 Oct 2026 17:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF12B6B0607; Tue, 27 Oct 2026 17:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DF06B0608; Tue, 27 Oct 2026 17:28:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE816B0606
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:28:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1DC1CA88FC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:28:27 +0000 (UTC)
X-FDA: 85369695054.10.E339340
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf13.hostedemail.com (Postfix) with ESMTP id 30C312000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:28:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=PEjfA7Jh;
	spf=pass (imf13.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793136505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ZcefObpE2rrm+ga5uEHO3LEMifW2uFgmof4Smx6N7c=;
	b=oYdx5kBaE7qv9cSYM8EQxJTliG17lb6NHV2VHvswqqHw+tIwijVpmSuuiTuKgE2/0n3LnQ
	lrEz74JNI+Ozh+xEytLa7bUa/kVuqZ5bmtkZzIGfexqzxRhsyeGHtY/8QnkJlcFLmJGk/w
	rfjfZkxv3L5IpRKphfMvpGjMldrMyF0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=PEjfA7Jh;
	spf=pass (imf13.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793136505;
	b=0EjeeRP44Ihwhx1ZamYrTdqbDk5cAV5JJcLkk8qRJP1lPGmYnZ3BrOPQ1B5iXeyQ9lR8tQ
	2gzko4j70ZdsBJvaSG+5lV12Mhs3/+eCXfzFPVrLLYZPAjBki2miXg9YPa4zXO4l4DB6G4
	Lzp3uVA5DmRsmh1SNqeH52L4paTj/Zg=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4jDkBG3Fx2zKmLf;
	Tue, 27 Oct 2026 22:28:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793136502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ZcefObpE2rrm+ga5uEHO3LEMifW2uFgmof4Smx6N7c=;
	b=PEjfA7JhLtXHkEkXY0y+Sz/oezTaehWwA+IPyY2Jb4P/waxTQmmqjoUBQrOTlvW/R2iSHO
	BGdQwdww6vuLSa4gK3/5/uNgxpWHPADhwdxm8Kusc7EfTxiDPc/gyi8xbZO4prQyjNWH0K
	lod/NqX8OsElQ/wn3OdnfSKKyBG4UQcWKCCVELp1KdiHc3ZoltCUiCZBzfK6pLaj5fqdi1
	Bgj4BgbLmw3NGUNvqW7M7+snNsR2eWjjjV1EpxtRWYvnFrtf8X302MsUExMZaQJSiAvEPf
	zBX5EXf/IuORh4jkdwAc2/YUL+m2SlDkmH8AHT6TLmNoC9ODVEGKi6guxwZhrw==
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: manuelebnerli@mailbox.org
Cc: corbet@lwn.net,
	damon@lists.linux.dev,
	jm5905938@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	sj@kernel.org,
	skhan@linuxfoundation.org
Subject: [PATCH v2 2/2] Docs/admin-guide/mm/damon/reclaim: rewrite complex parts
Date: Tue, 27 Oct 2026 22:23:46 +0100
Message-ID: <20261027212345.2586628-2-manuelebnerli@mailbox.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261027185938.2526259-2-manuelebnerli@mailbox.org>
References: <20261027185938.2526259-2-manuelebnerli@mailbox.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: zkn5gizzhos5yth6gkn8gqewj5aihmqs
X-MBO-RS-ID: fa7e08e0a3bd8cf13af
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 30C312000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6611x9dqsfckudxrsy85bbknw5wwx4xn
X-HE-Tag: 1793136505-402969
X-HE-Meta: U2FsdGVkX1/Br7AGCttphN587QZR7UIzqFIuCwhTutwJ/CGOA+vr+gswRh4rscyQaxSZmZl2P8idPJ9JRppzInKoEMIr4KcscuS3PfdBdULmBw+0iXNizfhHfDu6MIYudviUcLqje1BgPcoEBiCt8UgtO0BKULMZ0m3agNcGRVoIGzgyFwOgA7zCjt7reDKYXFi/BOOcL5l03PIiYH85TZTM2qwDhx7kLrOylv8mQAlXtyXNceW/CqqkjV/0ihabATo3p7Yj4KXQajwtgLj6VjD62/dxrGlpYzj8KuvsYWAd/C5swrzv7so7NirPo3suZDtgX1naa9OEKw0lcH7XSH4ptvcWclFIa4mBJDLLHRu7PDJWKTLwF6OLiYCkyS6f4uTzvstnTnJTcu5vnNLYrL885W8nrRUyC4IkFnUJriZGPQCjK2gXzMOwz07KW9ncItxS0rv/cNeVYSv+ohdentlKx5FoIN088yJceoW4Hv9LaPDqz1N/hj/wbr1+m4bmij2DyKt8B3UwMj9Bgh+Cmciu8VK/trgn/gFJmXNR8Dk9tHg5yI+qSKfGGruJXg3Kmp7t7Ib3XikxCjVnDMZIAM5buf4F9Lx45D77SCk6jFAu6LhkCbsQE0RGZX/+FCpPq1tzFunEhvuyf8nBHFNX66LO2sh07mZDjmsn4qxoI+paC1Lsfe19p3OxEK00SjDrzMowT484AS02VsM+drd6I28Cnn3Fr2mmecVt/mB2syBURtbGrq2VRnVT0NAEON8W0tIMcZD+bxYdpmQCzy5KLXx+EwG/y8qhn/9I3OpvyNdALFh4Hk/RSV3o7vVl58L1APLfwpVNTETvLmxYz0jhd6cSw4xAoAKTb5X5KEY3SGH5ru6r+Qg/nyR/LMr2svxo0YeU1zaCVwp3BVQGySvwjRbg/KDuxeuC112nMW8J/GXJOHAgJeLRf5ZN7jN1AskXPtqxj3xoFpMD9rxWRyL
 ya0BnLmx
 meqOrBjdJ0R/VfpbolXe5ufRibhGSbnH4tVyMSspsLkOVHeR2UQ48f7zgZf5U/Dax65QI9Z/vGedm6haMcCZ6k7lwLyNDbpFnm53tkB7vK4khvcmzJB7NqPTEw2JbaPGn718q33dg+CetEd342LSnX3Cbqgld8f2GEM2obgSeK28wwZNPp9p659FeZlOdfi6uV+CyJ45RaXh5GCfDzwMxfIv3WG0205CvDXumukZY/qR3eXd5TIXfTeis1NkcpHOKRyGvup6sSKbt6XZbrkZxt474SoG7imkkmpTmI1r2bgQ3+6E/oqbVOt7GaYQohUSsQGjcBgfvhTzGBAtkSyQdbwHCYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Rewrite complex sentences.

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
Suggested-by: Aveline Noir <jm5905938@gmail.com>
---
Two more minor changes
@ 31
/s/attempts to pages out those/attempts to page out those/
@ 126
+ 'is' to fix grammar

 .../admin-guide/mm/damon/reclaim.rst          | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 0bab2299ea..033686f410 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -30,12 +30,13 @@ guests could mitigate this problem.
 How It Works?
 =============
 
-DAMON_RECLAIM finds memory regions that weren't accessed for specific time
-duration and page out.  To avoid it consuming too much CPU for the paging out
-operation, a speed limit can be configured.  Under the speed limit, it pages
-out memory regions that weren't accessed longer time first.  System
-administrators can also configure under what situation this scheme should
-automatically be activated and deactivated with three memory pressure watermarks.
+DAMON_RECLAIM identifies memory regions that have not been accessed for a
+specified period and attempts to page out those.  To avoid it consuming
+too much CPU for the paging out operation, a speed limit can be configured.
+Within the configured speed limit, it prioritizes regions that have been
+idle longer for reclamation.  System administrators can also configure under
+what situation this scheme should automatically be activated and deactivated
+with three memory pressure watermarks.
 
 Interface: Module Parameters
 ============================
@@ -125,8 +126,8 @@ quota_reset_interval_ms
 
 The time/size quota charge reset interval in milliseconds.
 
-The charge reset interval for the quota of time (quota_ms) and size
-(quota_sz).  That is, DAMON_RECLAIM does not try reclamation for more than
+The charge reset interval for the quota of time is quota_ms and for the quota of
+size is quota_sz.  That is, DAMON_RECLAIM does not try reclamation for more than
 quota_ms milliseconds or quota_sz bytes within quota_reset_interval_ms
 milliseconds.
 
@@ -137,7 +138,7 @@ quota_mem_pressure_us
 
 Desired level of memory pressure-stall time in microseconds.
 
-While keeping the caps that are set by other quotas, DAMON_RECLAIM automatically
+While respecting the limits imposed by other quotas, DAMON_RECLAIM automatically
 increases and decreases the effective level of the quota aiming this level of
 memory pressure is incurred.  System-wide ``some`` memory PSI in microseconds
 per quota reset interval (``quota_reset_interval_ms``) is collected and
-- 
2.55.0


