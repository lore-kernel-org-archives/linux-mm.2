Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50376606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=Ry62G1xd
Received: by kanga.kvack.org (Postfix)
	id 3E9EB6B0765; Tue, 27 Oct 2026 15:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0E06B08AD; Tue, 27 Oct 2026 15:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE406B08AE; Tue, 27 Oct 2026 15:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4966B0765
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:07:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C133240AD4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:07:51 +0000 (UTC)
X-FDA: 85369340742.28.FC2C851
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf18.hostedemail.com (Postfix) with ESMTP id 05E2A1C0004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:07:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Ry62G1xd;
	spf=pass (imf18.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793128070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRuPMmOS6McljgCPJBgSELMHJlD+eLMjBuZnizEmEAs=;
	b=Q7jsO27YHPYsETemysFrDkw9GGdxApbVHkme3KYy8geBg3neDHPxkgMDICiIFFj0p2JCIH
	sS2w2iOQrLwbuVsw7VSvZNFurwV1lSvD79I882K1jmJFbsSdz+AA2ZM0YNIz0pPu8qe9mt
	RRw9uCRRUJEY2h2mjDvcP+UwWZP/b18=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793128070;
	b=xx/iN0EttrJ4hK4gjSfgkzDdTqDJzlqlgTrHGKinI5ctiKsQ+nG2j1VlZdJFu+L7Uv8Kx4
	2ZoN9Mlkl4dOoecAvBkFxPFHumFLRbqZIDHba9fb1zo8h7zxllF1q65X0/q5i2+pO+Dquf
	cfx5G/1p9g+6/LWxHxKu2ItaajhJaGs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Ry62G1xd;
	spf=pass (imf18.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4jDg432DPMzKmGs;
	Tue, 27 Oct 2026 20:07:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793128067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRuPMmOS6McljgCPJBgSELMHJlD+eLMjBuZnizEmEAs=;
	b=Ry62G1xdN8ZmmhW7Y/RXSyDA68Vc3r14Q9axS4Tr2SP521hTKuMYv8Qqgh9vyfK8pRhD3N
	c4C5zi+c0NWuMiDzZwsPzxNg4HHmg1goIqNyzRopphSdZwwTMLb/xJp32LoZY/FTGjtedw
	KN+JNnLViqif/KHKo0WnkFw0MSvatGz+t+TnJO6OLptiLIaa1Q5i6z345cD38eQH3Vhx4t
	UjzsLgnrVu5J+W8PGuYD1boR02XgnW9c3mFqrA/dY5bnJrBcXz3Lm41P7UHujrhcsj+cYd
	OD3uMLSEnzwGRcjSmaZSOm5v0si86Mt7k0mUiqHj20tAJi9kA1QLzccKHyw34w==
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
Date: Tue, 27 Oct 2026 20:06:29 +0100
Message-ID: <20261027190628.2527100-2-manuelebnerli@mailbox.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261027185938.2526259-2-manuelebnerli@mailbox.org>
References: <20261027185938.2526259-2-manuelebnerli@mailbox.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 974632ddab852ae7c8d
X-MBO-RS-META: 476t4rounsybtiebjgsckpozx5zahxis
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05E2A1C0004
X-Stat-Signature: ttcmpgwz5811ica741549qktnnwi9da9
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793128069-469900
X-HE-Meta: U2FsdGVkX18oZhNVtxmN1iJW0da56oOy8QrYnqV6DqEIUmtHFa8CJR81lca0FWOqeG9SmAIz9yYLxIq+tC4dQgVSXYD2MOrYeezejJ7JoBwYhQUuh47BVbAo/9yfJmB2vFBS4FycjO8OEpwYbSGuDIcb28B/VsnuopGV8T5sWPT6LHJD0RHvMMP5e+sPMkBdG2VrHO/2k/WBYYe4+F4SJxtDZV5llxT0otkl+K/iK+D6EUKAGU+dwFW6WzxFd7Ml3JBKU/ijsBswSuusMJ946N1B+P/53lf3WbIHWQAT0bRZIm63AKu9+kY3Uj1Bm+QOALLYMszTk27RIacjj5bWbDfNEQAXE5iZ60JdH/GU5LxStBe+dNVD18HG9P42+oQ0DqvR52gF5VRcDyzK/la0xwY6oE86S0KR7rpaOsMIIu0J4OEN9esWYbZtELB1snLtgkcGDkSrcPXtaazwAs9MdahaMO8GV+SR7IwJdVlS78/VozaxlxGHeTbjieQ+HjVVp1rVxBbyaIcaOV/XOWOif6pHdNGly6vdOhO78nz7wOwR9odbonUuqYO2eQUNUtoNXJ2arN6FXcFXjpaDw8wBDHSHT0MrPr1VcW1Y/la1zj5jjXjLqaBw1MCnBYoAYKAb53BX1idrfb5t7UiUbzyGSbw6qfU2ONJSxi0oYunNrx3+PiRCEEm4UGjrB1OSM6AbFjZtIMJ9X0STvA0W2gVybl9Aea386Z0nC2z3uE7hi50HHET9CYNyHL82wjIFo3oFFM+dWxjXUl2ueS3UsWv8Um8U0a8hKuSQSkrEEFp35HmL25Au2JdXO65FMWQUnwPir84EY7iDXDFosy1Y0PhCUbcpGjhWUHPx8eGD8Eo5z/oZGar3BFqPXesAwymvFn7knVVKPidoihvaknERl+9xjrxP/Jvb7er4O0tEE43vsDL8uzQpYe4Oj0wYUfoKnVUvHaOKtn6pIdSpvjiE1fv
 ZzfEoayy
 e0CrcmCK5qlVMYGuzRI1VGNccEnF4ktd45/Vql9m3c/sDdlfWKCy+0kBKo4owP5ciJk84RaxM0iw3t8ejlbSWfSjqrHP5Dp/7m1JmfwJZftWrHsrV+busyQ3ai8QbfpQY74GExLcMLJu0NNbind3NACkZnd/q5e0OcaT3WQJx/hz5hhrU6vXekYoK06wcW+F/InJueVd3FLh+qSTKpYNBPPJ4qziDH/IBT65Vr9CnV/ah5Tgew5riqxhUQyCpEHkyzUKuO8CINjy2KvVMIrCFdoxCGw0EEkSHlANUeafH1oRGjT3XdyuNjMBfZnlBdk2SnHm7gzClKLqURnQ47gS6Mg4eG7Q1as94Pl9G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Rewrite and refine complex sentences.

Suggested-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
---
 Documentation/admin-guide/mm/damon/reclaim.rst | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 0bab2299ea..a18c8e2165 100644
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
+specified period and attempts to pages out those.  To avoid it consuming
+too much CPU for the paging out operation, a speed limit can be configured.
+Within the configured speed limit, it prioritizes regions that have been
+idle longer for reclamation.  System administrators can also configure under
+what situation this scheme should automatically be activated and deactivated
+with three memory pressure watermarks.
 
 Interface: Module Parameters
 ============================
@@ -137,7 +138,7 @@ quota_mem_pressure_us
 
 Desired level of memory pressure-stall time in microseconds.
 
-While keeping the caps that are set by other quotas, DAMON_RECLAIM automatically
+While respecting the limits imposed by other quotas, DAMON_RECLAIM automatically
 increases and decreases the effective level of the quota aiming this level of
 memory pressure is incurred.  System-wide ``some`` memory PSI in microseconds
 per quota reset interval (``quota_reset_interval_ms``) is collected and
-- 
2.55.0


