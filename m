Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7463606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hw1XJmxT
Received: by kanga.kvack.org (Postfix)
	id 5D2596B0789; Tue, 24 Nov 2026 10:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5821E6B078B; Tue, 24 Nov 2026 10:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44ADC6B078C; Tue, 24 Nov 2026 10:37:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21E626B0789
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:37:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCF131A0BB1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:08 +0000 (UTC)
X-FDA: 85470416136.11.8C7C0D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 218A140009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hw1XJmxT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534627;
	b=PS6ZlPP/qYBRWVxAKXU0k6T2yVhSOnPVt3g5x8mlJYGe9I9x7ltf8X2ovZAKhLd+recWi9
	PG2/LHQMx5Go0TMr2oCMtG4woNGF2gij8QQ41kdNhMbuiN3T/OR0NuXfWAAOYkXuUGXAQT
	vU5f1wAbQRH7DKeKD8ctU9T5xaemAUw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvFg40ri3tkHSBUAkoSTy8n/DE+W2/M8YAn0b3vMqCE=;
	b=SIf/AjskuihEvbijSKb6dQa6ebSh9n4adfPHsccoTZ28Of3XCBfeTfvv1zU2jf/2KT6LW8
	pxkFcA7TspbHxPP5R96gCgu15NSaFzWWwotFWBwL9Z7f7HzCw32S/+rXc8thtCy+Lz85Cv
	Pxufff7C3z2iTAAk/Oh0gEkLSt90FjY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hw1XJmxT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7361040289;
	Tue, 24 Nov 2026 15:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2911F000D0;
	Tue, 24 Nov 2026 15:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534626;
	bh=SvFg40ri3tkHSBUAkoSTy8n/DE+W2/M8YAn0b3vMqCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hw1XJmxTbxm+07JsDeOGRhUXknupq3nYzmsvfY0BKULbr4KQjcLBt5LxXfvPu2Fgz
	 vmXz7ARLRB0/1JfTxzM5DJxJiURZ2zc5pEBsROdJ38rukJtDaw0dXLB33ztB8+IdU4
	 XXltBazzPUdnoFHKgMsRqO+3526ixJan76ElNqlbkkb3pJPp6a603ecKP/L1uzLwtq
	 w0bPZ855GdQilU2midbGNKzBCzXnGbBctf/G2k1s/7Kf2eWRM/DSZ8tQmHhLzFpGXY
	 ggKLeWA7WdPirEkxar6aHmLeHRsWWNG89zV73j7ucrJcRHhG7c38Lv3tiXq1thKzZz
	 Oy9gJN4XbKibQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH v2 27/27] Docs/ABI/damon: update for user_report report support
Date: Tue, 24 Nov 2026 07:36:33 -0800
Message-ID: <20261124153636.91854-28-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 218A140009
X-Stat-Signature: 7inwp6ntxgz7uj7jw9cqhkn7kyseddax
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534626-464137
X-HE-Meta: U2FsdGVkX19OIQs6iE2LJHY2IHp1Ko96yCi7jlbklAKkmCE2TsDelo/c33easJTJjCfF8p4GzZvzRTR3bHejMi8uj/P7Z9KIDZkl9nRxyhNHpMTQa6qRXjsPPWRpO2sUQCFfinJL1pzm+0ftNVWuu7K/swJl38QGj6ZUKRsr56tyC0JmQKWAl4bkdkrAECy7CKb3NdjWTP6kYh3aJioXP5lQDKvUzVrLx24j/NJlwm8jPMBTYIMGOVXW2bNlR3sqV8C+eb/9eokOZd7Hwpf7vMW+SvL/MZJoFk4b0G4wDIARk/wRgNi3dp9XoHrLIECjXgueNG6/4XCPujWTYMe6/H56l5dYmtUrRhYH21emwR76RmMh/w9OTh+vrf0M+40Hqfega2rCzXuhSl2wnenPrWrnpKw6yScUXXnFT8P/irBkQ0toaO7MfExbiATWfhbv8XGSEzojtUYbFFi4Sa/+GcI+TjOjJ0So23mArYyPQkCEbKYuQagHwSjc+/kRCo6+uOBNWV0D0kQD1711HZ3jRoOu+TdTmnwi7reVeGoBN3iZYYB0HhK+27IMiAh3kyJXwkPddxUW+5RvlF0BePyZfzKwvW3Yp6emn3UvyseXmkfRXfC7htdYrzB4upv3FYt6p5TqAdMJ2s8/YHyZT0ZnCtzedZWqjtywYc7GaiGUA8ezFHI1l0gi2xlu+mS0AcUoirAiogcUR0yCIpVJxN0kUHDMkYYrNQ3bE+JJV7UE9VP031FuuSVv0IdCIVjv+q61toXFdZkX0PcSALonq01iv2BmmN7jJwpEi2C3QrKsTsxGgIy4qJPPh4ZxiWjX1glHCaRSdaZvpD3mk97+1MoGEPaEH8FVjyisKLkRJZ2dGdoxrfZ+EtkoFw3L3OWhGCXDu64h6AFlW+nHrsViteGtotqneEYu1dzxggOGH5p9aiN45B8jXBsx9n+8yPW7rC4OET1KJmSDaP7X2nIHBLm
 fpzsKLQ7
 3eM/4TYPEurw5zQA0+o+HeYYAO65WYk0oeIEw1udZ1+kPenoszhdlbjf9n9gJRtXl60hLjJ3Pscs8lAgsRQOWjtXzrqJSGI3voqP8y+aNrM0GsAXLDVx12Ucvdzs05CTZGsb8KcLg2fp1KmkWi62jfi60Va6ckXz6fFltGuZst/OF8KyAyIexiWy2S0X7YB4oz0qsFG93jc0IiKAFnL7nogpH30IEFwvZBkz7yGpdBAaUq/JCDLZcsPERHmPqigQ8BGoXSgIILyNtINo6cC+mhpg8MJUuW5Ru8guIfX6X0Fb8Wu9G+txbCK5ictEeTDWUtt9T1LjIvYCngvvj2J/HFV3MBxFWoyxs/NEylvPPZWy0hKyELK+NAcRyrkm+JfRtcxvA4DdPSVa/SQbWnyDHcVqhYEEFrf+hJ/DtZMNFX0yg284ZC/38oGws1J1Xa0Wm7PGzEPxh51k9y3RirWr4fAV1vfuv3pbDq0hTXGRKP0QCEg+aBGN8Yhm6UvWZFruBoltMHnexSl4usju9mC4OnOfBiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON ABI document for the newly added user_report type data
attribute report support.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 692827674a773..125b615e32ec4 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -729,3 +729,19 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	A file for requesting actions including enablement and
 		disablement of the producer.  Refer to
 		Documentation/admin-guide/mm/damon/usage.rst for more details.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/addr_start
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing an integer to and reading from this file sets and gets
+		the start address of the report to manually generate and
+		submit, depending on the type of the report producer.  Note
+		that the start address is inclusive.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/addr_end
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing an integer to and reading from this file sets and gets
+		the end address of the report to manually generate and submit,
+		depending on the type of the report producer.  Note that the
+		end address is exclusive.
-- 
2.47.3

