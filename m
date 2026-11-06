Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A53606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IYXRShHc
Received: by kanga.kvack.org (Postfix)
	id 802156B05B0; Thu,  5 Nov 2026 21:06:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2D06B05B1; Thu,  5 Nov 2026 21:06:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674776B05B6; Thu,  5 Nov 2026 21:06:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BACA6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:06:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D99771C4710
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:06:09 +0000 (UTC)
X-FDA: 85403054058.13.9C1DAE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4B78C40002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:06:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IYXRShHc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793930768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JU/kEulr0sCfPlgQi9t7wGxnFtKUBD8hcPHbhMmyvTo=;
	b=5WC6UTQjVw86ZQDdC37WSqLKAs0cgiSKNuOeuCsgHFUOgNs5e7RnjMZFgOcAN697LFRGiT
	0stAORhpKdgBf4ShuBClChA9tacTxJP2HCHXzqi6sf4+HhehujXr7MvxAGutcH83OhQMAH
	GA1B4JRRAoDEQwb/HRrk797CfNX+aDg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793930768;
	b=RhpuG8madbJTbCmCt4RwBrs7oCCQaY8mrgIyye1AZY4y6vkaKFZ3eN6LOU0PvlQ6wynVmJ
	8GzYEd1aQbTbPFIUiCcXC069poo9BEmlQyDI22Zcp9SsMRvNaQGzcntkjXNtXpCbWEfK7w
	R0m0oQQR4kMhbhX74c8ZjZwPmgdLx14=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IYXRShHc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB3116020A;
	Fri,  6 Nov 2026 02:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A191F008A3;
	Fri,  6 Nov 2026 02:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793930767;
	bh=JU/kEulr0sCfPlgQi9t7wGxnFtKUBD8hcPHbhMmyvTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYXRShHcXsbYaO0cZRrtcV7bQEp07dVMcV5AHu8xHpmHI7Sn4sKEv3CrQoHEDTpNO
	 AZotsx3lhmFGBIua6I/LILHRLT4tBBBYljA/oYz1hwD5lMetrGbdsk0H45fVGc2SBW
	 Dpy99ebFeB+E6KY9Q4ihu8FIRXyw3uhr25fHIEIqsyWb9pjTA37hT3UxXst3fZ/UdH
	 ErHvpMmy2WyE38c40ruQDGM/ykpfqc1/2eSqewvF5oiQet+6rhp2RJfnjAmHJEnik7
	 L1i1dNeYCiWWqa3irkm6pzHndH0rRVYP9vPIePcBT+eFACJs81sVW1u/OD57ipui4Q
	 ecWH3504Vb5GA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH 2/4] mm/damon/sysfs-schemes: support DAMOS_FILTER_TYPE_AGE_MS
Date: Thu,  5 Nov 2026 18:05:56 -0800
Message-ID: <20261106020559.98352-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106020559.98352-1-sj@kernel.org>
References: <20261106020559.98352-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ikdzjfjtepxo7x1ycniw5u1pc5jpyxk
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B78C40002
X-HE-Tag: 1793930768-532138
X-HE-Meta: U2FsdGVkX1/JeiuF3P7xtK75O+A7Pu2g+bnerEl1vwpDQGMEoGXoBrQi0wKWLpAcu+1O+WZm7WYl5N1F7w5EY0/3bi2yDv+NRo7302xndjWDDaFpfuUPIbvOLJxz5Fiy5LLGZLKWc80c/cvwO25BdP7DEkl3gqa4zWVCWDbXzoG+YG7wa6kcpuvbNC2fym865s028TVPiQiwBiWWQeJFwH23dUPrhaZ2w3i115q/cRwyPPC6QC7raVRvV7UFLU1T9azlcHDo7ggl6NS1uZDcOTbJ59CbRIQG4Vs5KlPgrnsMN+tHskbh02dG83vsDEORI0McQ29qze/R7C6Azadz0D8p9vShrT8Jdai75Ghej/QN8eK/vWA0IvFKD7mWN2FxJJYss3yPaXW+pWitaYz2K/wl1ucG9XBjg30fDu3Vt/YIjtoLJF4H1FnjCTax3oG1c9CVqb3vJXeRNNiyYLaOZjgs4LBCeHXv7C+OtYgA4+Fcushj+bvq2GaXwkT5r5ygi7BO0vK6c0T67zd1WkjJwjH9QJCVnw9KgO3jUJa3e6esWsP+ah26BEh+JtteWHvItf2LuPwSPBg68DhrqO2lf8++YqWfjT+zBQDCWStfqZY8FC0lbI3LqVb+d4QR8goM+FQr2hDM2EVua0GVFbWH8ZcyNYU9JE8vVZorEq9SflDb0+Ow6eu0dSDE2EqbsE7lWaaXmlChsxOBwqKbF+zPkt56r7t9JY2i5roYtZMAHGsKoyYnKebNIJCpJiEldTM1dO+j373LgYhxlG4aovOT56l9T9dDwnpzBaVo2n+ni0bXelo+LKMEEaBkg5xKIJ9GcTIY+WP88oDoUJfMpKG5ifc2oYqdV+svEg2d0+qoK8LY0NgFbV7E1z8ibG3KWGguRNsdGkHVlB4RJkJ9TKns6uBneqx2xA96tlE0xuw1SVse+hutTDIR/S0M02WggZ0cRgO7Rwz+x8NQcQLUYyW
 7a+SHvOd
 lsVl+OvyBE6beQ60/QEnb3SBlNDusdzcJb8dex5vvxVXC05WTHvTrD7NTKRYb0Im6EqU6xyfxmAykWS7ROooCdZbY/5Gmgx8eKfwO4JKlEAP+i/beSOIgH/+Wqt7J8/bxwxHvhgg1S5pspd8ml2o+GGk5Cs9jKUy8te+OxYUPgQWinlTBo9rnKQzHm/tEzyajeArmYejPtieDn5VCcxQLABPex+rP13rXdqqjN37R4sTTtCsSfC9rLMmqbqEiG1Vdc+FrXVPs1EqLVRw03S3OvwAdTmTMU0eha2vJNvXYRGJWwFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Support use of DAMOS_FILTER_TYPE_AGE_MS via DAMON sysfs ABI.  Add a user
keyword "age_ms" for configuring a filter of the type using the existing
filter configuration interface.  Reuse existing 'min' and 'max' sysfs
files in the filter configuration directory for storing the age range in
milliseconds.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 637f1bd0c950b..230987efac3ac 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -593,6 +593,10 @@ damos_sysfs_filter_type_names[] = {
 		.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
 		.name = "probe_hits_wsum",
 	},
+	{
+		.type = DAMOS_FILTER_TYPE_AGE_MS,
+		.name = "age_ms",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2875,6 +2879,7 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 			filter->sz_range.max = sysfs_filter->range_max;
 			break;
 		case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		case DAMOS_FILTER_TYPE_AGE_MS:
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
 			break;
-- 
2.47.3

