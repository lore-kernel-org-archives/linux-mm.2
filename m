Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E3AAEDEBF0
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 20:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21BC96B008C; Tue,  3 Mar 2026 15:16:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C99B6B0092; Tue,  3 Mar 2026 15:16:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CC066B0093; Tue,  3 Mar 2026 15:16:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F0B556B008C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:16:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A4301C30C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:16:07 +0000 (UTC)
X-FDA: 84505858374.28.CD47885
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3B01640005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:16:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jHyVoIm+;
	spf=pass (imf07.hostedemail.com: domain of ak@linux.intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772568964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pJiyYHqHmu6Uw5GG+0ZZS5VePqSA4vgStdBOj8icPT4=;
	b=WJZWRCHXM8oM/KTSnqdsuP9Li/9Px3HUGWPbLdX9gXJiJ/wLOdkLqIo1qyGz9YyE1aD6WZ
	85KztfSEq3vMlRCpAYtGTcZ5Z+YVkXX0vCFpp3xlo+TB7w6zNjli2XiFCO1Py/bS4DzMQC
	NB6/g05jWiufQfvMz0HvW1eQJxSZ9ww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772568964; a=rsa-sha256;
	cv=none;
	b=OsussbK6LflR7t0cjp1fZbVu/lTszpfru05TlVJfk05m439oXMVjfoJNWSMta50eDOxtZF
	gVjuf9XI2iEqSSfp4f7X7TmPMSQO9N5fSbFccCrWGa419fiMhrlBsMSoHhyN8pI6ejkMet
	rOc91UrKPAjRiO4vBjCwC+hTRM4K2gM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jHyVoIm+;
	spf=pass (imf07.hostedemail.com: domain of ak@linux.intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772568965; x=1804104965;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RP1FGoCSTOKjlxXCBxwlnh+fXZZuy5cCIfTZ1L2PRak=;
  b=jHyVoIm+OdzdwSRSE+OEdW8gTKI8Mxqckumrt9inTf8Ki+pZOSSz6gBM
   qhtTPr/wnAu2NZJwonJ7M94Eg/JIWP/NDT5q/d6n1hyt0ju2yEedtdGuB
   JMO2YyxN3oVqwhHImZjwLa3ltDHD8gkxh31/TosLvnheWEMuwYwsKHeQI
   8Fh1NqyOB3c0hxrgai/Zf5+UcuTIsdZbyzXHVDgY1GldKFevR3BHhRxYG
   8a1foE8npYmblhceqNiYr5I7kEqjhTW2dUH/Hcy5vtdodQYgGulVhlMuo
   rYB69p86poZ15+kLZ7PQxSl8J6i+XQ5a7jGq3rlt7AAYdNdG/1k3LwB9Z
   Q==;
X-CSE-ConnectionGUID: m++V6olDS9+uh0Cj2ETisg==
X-CSE-MsgGUID: OdHEWAhjTmynz2ccTjvkHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73537420"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="73537420"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 12:16:01 -0800
X-CSE-ConnectionGUID: t0JXuwq8SVuvrW/KKosdmQ==
X-CSE-MsgGUID: x80tjf9DRCeEoOHMfxuOig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="248598431"
Received: from tassilo.jf.intel.com ([10.54.38.190])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 12:16:01 -0800
From: Andi Kleen <ak@linux.intel.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v3] smaps: Report PMD page size for pure PMD mappings
Date: Tue,  3 Mar 2026 12:15:56 -0800
Message-ID: <20260303201556.107960-1-ak@linux.intel.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3B01640005
X-Stat-Signature: dwis8bm4sgn9s7hb7jx6hrm559f8e96r
X-Rspam-User: 
X-HE-Tag: 1772568964-256250
X-HE-Meta: U2FsdGVkX1/A+mKJC66cS+jjljq3hWvciCM+GAPoVbGCnuxjdmm7W6eEVUMJiHco+Hbxpkgnw5BFyavER4mw0xA59f32tqT76r6IqPGbghybWfBG9Ogbw3JzfHuh2CLFFRWdoYbaEugSkySNVY7ECb97CU3NY6qYTUsRNpl00TYO9C+Nmu1pA49nR+R+skxQ2T87hf6uELiWt7xIYi1EooibH1cykzfJl8eQo2lK+ZreSYta4W3wHqrSY9Fj4W3QAR+M5h9C7g/uvW+DZntJtpuXSNVelBNKtBJvZ1k8WOnHEZrt8F/evY7noLL4W3GWzqSZc4B7rufbV+dBY1hzVl5oH3Mc5zowMe+0udgha+dcSNv4AKiO3KhX0TiUKRb3UmiK9Hlqso+MJnDBKyI486F/WAnx9nqWM4EiySGXatHSFk5N/GFqO12+S0Oid10w7F7qPPhU+xbQRmgJrbPWYIEUgTxNmadnH8xmT7GNvHay9KDEFM7RYPOW53nnJBRCPvKEX5ev/o9fSn6K3XxHX3JyNgXZABce72AphTqt7sOPe0ATSn2hWl82gqGAZKO+WRVWwlYt5hn44b9beBzGQSQPWc/rW8X5TC1/+CLEReQVUV2QXOKn4oxeFCJXfKZv3dHPeQYagokynnkr32RfMogXB9uV3TEdYu+X17Za4x15BScY2wUiDl7A0DXp39s7XK3/hsK2iwuS4kLmoPV8qZcsT9+E4Cgdmc4il+KYDlcKNAVhr/zHBks0HEoDG3blMAYsQiGKaz83tOkeNXJ0kSmrVYKvE88QI20elbkaLSIwU3+p2DCWpgte5O/Hx9IWIN0ZagW5Jvioyk/jzRWv25lSKv6QvN+oVrVsgl6zCcRktUjE/s3W50F0IIGmFnq3m6TagLUKlyleaRGwh4Ikf2FlBlSV9Qs2mL/mI71A8WgKcqlm+OiRctHvbLe4OGarX8i2kZ6O1mg2WCnY6GK
 NYlKkJSP
 6AM3DS+5tCT6ihMWSWcqNTFddfwo69mxJxj3hNI3mWrH130ZQjFCfrm6zj7z/B++hTicIPnw4q1mflO5+XkmQHXide99CTWiwshhIjGH1qEzO2971PtYU+9x0BkH8jYeURxxYYbB0zatybYAv7VLd5A7vqU6SmbG6dkNTad6zexQLKM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a smaps mapping is only PMD mappings report the
PMD page size for MMUPageSize instead of the base page size.

This is a revised version of an earlier patch that tried
to report multiple page sizes, but there were many objections
mainly centered around compatibility for mixed page size
reporting. This patch side steps all of this by
only handling the non mixed case in the simplest possible way.
It also avoids a problem introduced with v2 that page sizes
for mappings with no pages were incorrectly reported.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/proc/task_mmu.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca1..a5c7bc88a539 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1371,6 +1371,7 @@ static int show_smap(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss = {};
+	unsigned ps;
 
 	smap_gather_stats(vma, &mss, 0);
 
@@ -1378,7 +1379,16 @@ static int show_smap(struct seq_file *m, void *v)
 
 	SEQ_PUT_DEC("Size:           ", vma->vm_end - vma->vm_start);
 	SEQ_PUT_DEC(" kB\nKernelPageSize: ", vma_kernel_pagesize(vma));
-	SEQ_PUT_DEC(" kB\nMMUPageSize:    ", vma_mmu_pagesize(vma));
+	ps = vma_mmu_pagesize(vma);
+	/*
+	 * When the mapping is only PMD THP report the correct page size.
+	 * When multiple pages are there the user has to figure it out
+	 * from other fields.
+	 */
+	if (mss.shmem_thp + mss.file_thp + mss.anonymous_thp == mss.resident &&
+	    mss.resident)
+		ps = HPAGE_PMD_SIZE;
+	SEQ_PUT_DEC(" kB\nMMUPageSize:    ", ps);
 	seq_puts(m, " kB\n");
 
 	__show_smap(m, &mss, false);
-- 
2.53.0


