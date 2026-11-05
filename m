Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2DD606A330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zce8u9kf
Received: by kanga.kvack.org (Postfix)
	id 15FC16B05B0; Thu,  5 Nov 2026 13:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110DD6B05B1; Thu,  5 Nov 2026 13:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0264A6B05B2; Thu,  5 Nov 2026 13:16:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4BE46B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:16:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A90F80BC6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:16:58 +0000 (UTC)
X-FDA: 85401871716.25.93ABAD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 88603C000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:16:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zce8u9kf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793902616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vMpWvkjgwpvMMa7+syhmsy3PKYx+lNXAcu0o7qMwcLg=;
	b=aDD1Y/EfM0phAqFkei1LrLVgXdSMBq6n+oKRdurx2Jk7XnhW9Xlg4zseaNZGGKD6k8xMo/
	/CTZeWvRZqoGK5224TbwolqPbWXLjxvOGntdCyNFtak1lA3yCWTjCj+GIvfN1IRIGB0MfQ
	+d7LkOD9cL1vmuzsKJUgTAn6p/76pGs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zce8u9kf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793902616;
	b=YWBXkCek7VRTareBKrafYHJD0hunhiB1Fd/3LeEwwRVDM+xIg1JDkP0ix9NFtaw/SjmVnk
	SSHBiNkIqB9xid4+Y7JgxWTvRsMrYyuK4/PSURa/IyQBWZ/4Vo1kArkCmSCGKerkAx5I4N
	7EB/7Y9HM6KKjo7MrVT6wVpN9T/iArI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9AAC60147;
	Thu,  5 Nov 2026 18:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6775A1F000C1;
	Thu,  5 Nov 2026 18:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902615;
	bh=vMpWvkjgwpvMMa7+syhmsy3PKYx+lNXAcu0o7qMwcLg=;
	h=From:Date:Subject:To:Cc;
	b=Zce8u9kfBUlYo6KPIi/Kk8ohVlE7iAqICTrnuxM4OKaYJT8CbiOb+lNyAvDEfG1zo
	 hjnQd9+iJlRqJieiLQaQ8FHaRzreH1IYeiVkIVs/7L0vdncoo4akHf/VCrGyWyqevH
	 uafdMf2itzKtADBAlzNGtQzKM0R6rbKZyDFUT49/eltsfUq/viuVCDVsyET7gxubUB
	 ifLonotA7eXw+8MFA0l25QnuqbtDVG5ixTQGTCJP7MYDAhPH5a+lnMKUqChCn+6mnx
	 FvJ2lGsBuTLNTSbMLHV4slSs6uJWnTRppiyrPmZQ47NdPAwVivq79Dc6LkUzAWWb6I
	 FUP4nD4UrGwyA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 05 Nov 2026 19:16:44 +0100
Subject: [PATCH] mm/khugepaged: don't map folios that are not uptodate in
 MADV_COLLAPSE
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAvI7GoC/yXMQQqDMBBA0avIrBuYRGqrVyklqBl1CmrIJKUg3
 t1Ul2/x/wZCgUmgKTYI9GXhdcnQtwL6qV1GUuyywaCptMa7Eop2SiNZPzubfFxdG0nVXf00WOJ
 jKBFy6wMN/Du/r/dlSd2H+vifwb4f8usBZ3kAAAA=
X-Change-ID: 20261105-set_huge_pmd_uptodate-9b9820307f30
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Hugh Dickins <hughd@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Zach O'Keefe <zokeefe@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1539; i=david@kernel.org;
 h=from:subject:message-id; bh=4vPRQgFKZMvkn+yRb7hUHK9P1W7c8xgEacmzWiDG098=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLenBDYF6dT1ebwouDdmfDrT5l/yqdorLYTb9qf9uJBx
 M5Pz6ovdJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjAR/WqGP7y3LZzkeI4/rtvC
 c09x08cjapfurVeL8DBW9bzbrLBWeAkjw23meu0ZiwLt81acetgfvmEH11qxjII83SPfTLrdD6b
 uYQMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 88603C000A
X-Stat-Signature: zsa3ma7fge6xd3e4m3gxd5zkq9rcgrje
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793902616-116179
X-HE-Meta: U2FsdGVkX19hcthjp5x1m6E4JXxw9+owzHs5FpmeIAo2VHgKdnrg0kgwmVO5bVDQzi0Yoix+l1P9yHxknZdhcfoQ0KeyYQpCSF2mVzXoPf1dTZ0pARU4L7jAx/nRcg3XYcMcfRAkwyYwa3TvCRTRwT5fLmL2RlRGQWufkUb0PpNMwUulj3FsTNbo1U05Y0wKKEf3RByWypaXYLKbiuExsxDLKGnUUrqDKs+8GkEK6JypR6Jwt0k0aV8ZcDiJM7/Bu1PKZDBJ+HSDwvkNNA4FnDJ3L7z8DMFEGRMOZQ3Lha8R97DpdjPSzk+UDnxOtwFgTS7gWxMob11HG3JHffRIpugukPp+cExed3VxKeVYi+sViJGqLKZ7WB6RORqY9/rWZq0ZLFLGVrRIK3s19RJ+sEWdCMPSpVXgagulwiLWi3jVz0Z0rdkUV32Mn1FV7Hlm5pAoHXK3ODF4jXKc0nJD9Zb13bTNVfhZw8c1lWQy8uLbqZIUsVXKA3zn3YlXG/G4qqfkLx84R/iX82l/t4PxsJppZZvRc0jLKZwT1s7YkKa36i9eOwr3+dn48SHfRbmtRWyt/ZM7+v00Z9cUg2bLxKjP6DKoqBTi06jzmzhvZ9JyJu2uvvQn1ZhbXEj+o1fXs/9LODRWyyFX60gPu7M8kys/2SEyZGijqO/R/BvZ0OzOi3OJmWl2pOaVvYkktIaenCDp/JvK7Y2p2RLxkkmzoksXH2QAZ54gJoDby5hNUrVwCTFfhWcWAJCpvfHoCdk07FPZw/pyajPwCVHeKdnEPP4mKmw83XoWW1M29pOlVC4iO+xvvJ+cvwibi+8pSzj+XxZWZics4eAlOs3bu8OSrdpK/yjLzmK5yPFN0IK8CbafBW0swdwTT0pPAn1sCCaqbxDWsK5iOnAkmpGV7XQvIoSnPsldBFmf7B1aAFW0u263Ioc3uWlqZkc/BUru7LEnegckhWxDuuzsV3woMKL
 do9DcknY
 tW7YF01iNDYzrwfKcNHpavwhAL5gYBYJ6+aUifMWA2K8VlmnSaalw55A9+qnlS46eA7ohJVwqoodEmfLuindVNGK0mHVp/yKtUV8ydH48kFU6YdtMWWwW7Ffz6V0TuISPQIUQZJHlC5RpqTgbEinP/eN4fJK6JAKzM8ox5W34b9QN/C4/PIfYNchoyf/sWlOC1J1Vy6nUHrH3kPOKW6OYeBAEe+b/V9yUhE8fk0mrxzvUCW4kMelfrO+9fqGsni/U+3pcYa7VT/KkwDOIvmhgyYzDKCf5AlZr4nBt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
uptodate. For example, shmem fallocate() can put such folios into the
page cache.

collapse_file() already refuses to proceed with folios that are not
uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and skip
such folios, leaving handling to the page faults.

Note that collapse_file() effectively clears shmem folios through
shmem_get_folio(); let's keep this fix simple and simply let the page
fault path deal with that.

Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Reported-by: Chris Mason <mason@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Once reviewed, I will pick this up in a timely manner.
---
 mm/khugepaged.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8d9f05a39afb3..db135b3c44ef1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1900,6 +1900,12 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 		goto drop_folio;
 	}
 
+	/* Leave any uninitialized folios to the page fault path. */
+	if (!folio_test_uptodate(folio)) {
+		result = SCAN_FAIL;
+		goto drop_folio;
+	}
+
 	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
 	switch (result) {
 	case SCAN_SUCCEED:

---

base-commit: f44fd601f72e09e44c667b9234c9cd469856679c

change-id: 20261105-set_huge_pmd_uptodate-9b9820307f30

--

Cheers,

David


