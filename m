Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C308EC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05426B00C5; Tue,  7 Jul 2026 09:53:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5406B00C7; Tue,  7 Jul 2026 09:53:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97CAB6B00C8; Tue,  7 Jul 2026 09:53:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 695AB6B00C5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:53:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D61948E03A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:53:26 +0000 (UTC)
X-FDA: 84962122812.23.F60E1F7
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf07.hostedemail.com (Postfix) with ESMTP id 45C1540007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:53:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bYkSyVJT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNieEZShBstUzDyBdKEZjg40ErjOe3pCONmkHz2f2NU=;
	b=53F888Affhx3GQyvMNtVhOpuZKMFTnLkaaIO641V5VMElVf1xPBzpWm0p7ZhfLMKgtAE9V
	Jpx7rBEgbY98bvV1yzB+zr5aon6u71+WgJS5Ac8Zt/ipUmDTZBU3QyR1sdhTFsKP+/p7lh
	5B5uYgNXO/tLf8oH+l9ICtVJsviActQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bYkSyVJT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432405;
	b=AFJIFA9nXw+5/GwKX1VmVlSbaDuQnMkD8vI0IIQ2eetpzRa4TCIwPFy75gXeyVj4QyfucO
	PE2uZTMKSENuCn96F5rbpj0CzaYDOhIMlXisl/SKLGYLusGH4/JeJ4GhwKMupsSfePUTcy
	T8xPDg/wB76TnYnVvwXMzNba7CWl/88=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783432403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZNieEZShBstUzDyBdKEZjg40ErjOe3pCONmkHz2f2NU=;
	b=bYkSyVJTtzsRN0UiAcHbt/cyKKroaVboVIWR3bg/YXaqXEkK2FTX+ZAGB6DDLW+Wby0YNr
	ggDdrVmcF2HoNHs60oL7e3lzWqxQCoKfPHvJKBQdOsJCUd9GWUHo1/amQmGExaFWDnYwce
	2z424wczcPb+6ghfs4nVRGIeNg61Wf8=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	npache@redhat.com,
	rakie.kim@sk.com,
	ryan.roberts@arm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org
Cc: sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH 2/3] mm/madvise: skip device-private PMDs in cold and pageout walks
Date: Tue,  7 Jul 2026 06:45:08 -0700
Message-ID: <20260707135255.292870-3-usama.arif@linux.dev>
In-Reply-To: <20260707135255.292870-1-usama.arif@linux.dev>
References: <20260707135255.292870-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 45C1540007
X-Stat-Signature: t4mg71zn88wu378s1tt9t481r53hqa8i
X-Rspam-User: 
X-HE-Tag: 1783432405-948171
X-HE-Meta: U2FsdGVkX1/hTDSLM2TcZZo6DBmt9zqCwcF8Mr4nIkrhyXe/MfNNx07hj42J5++T1F5thCitNxSy0Jq9FvGZq1iYVl80VQnMmoObp0pyNfAZiRCzODUt0/2sZoVUxGrBo6R9511gGQSEy4nxcRVPK5XP0z1FyyMJhrTpILT2hwh6S1oUJA17qYH57V16pxrLKU0MhdurnpNz+dC8kzBxJxmoky4PHm/+ZBQX8E3uA2HQ04+QP81rx3zYoCk2PmVdCP00QmdZKMFPH7w12kIdlPKYJFESIwVsV/fLwMIwnGtcXgpgDJnfD5XEdfdJPPR55VZyKb38KWVfwTQT+JGpppoz2f3y4AyvO8PBwv3pff7P0OzKssmN49GpYsd64YQQrOxWeT2x+YbVNSxGfw4mmoqeQuxXKy/Uk2NBhQaMXZTQRmAK5Bz7VMKryDJ7PasZW4gKZxZW4zMI1/UkM3nO1X9PtOYYLamHZN2ytDxNQg5b0czZOTMbVGMqpwkkdJTN1BY8A+yiy1aHQpYFt2niln/a8CvR2auQ1CMrIW7DJoe+W2EEq/mYou0GbI2LA5VbO8k4vcVJEGsO4OOu/2BHJBgf2l5Rxhv/6rE58Ur4aC94F2QDC8W5kxKb51du3oxm+SGjifF1ytEGQqk9eGy6RaSwKzODTtA60yOywPO2LyUfVHxHfTBNYrKniwsJ4VCvDc0U0g8wEsi9vrYL+XFLaj7LBS5XVnKr/EZ5A4Zv147wVmMVCibvT9dBuGi/g31xtYDV4Rh9DKptX33c5NIdXhXzpJAjSgDnAtiwjOJQd9Ak9ZmiWQMKtbPPb6pHBCa77ZTho4xy2bJn2yxTP/nq7tmrq54LNfizgKYDah+ZQFZX0jWJ5/7jJBkMaiPVsOG2m+bjpxmg/TbPhsR15JPibVXA0A+a1TYMK4gNV+ztRiBzbV/HvqEoJaudPeU/8rLmrdQm6ADWZBqH7+h4IsO
 8x8gUin9
 iEAVixeofhirxQM1II8QCeBflYa+tdrqef58fGdslImMbVt4D5X6SiO9dZhzuwxjj7GD6tlUjqVFh7PZOf90pple2QPpu4LpvEyndntw5xSYDFY5dqY/ZzKAMdCcqY5YRmZfTtuVvMBzn3s8uiMG4vQtEs4+Q2SnZUOB1xBpROHs8eVuszMPopbPeu0E3VvKb6FchT4IyAooLy2y+QLBxO/gNbqCNukTBY2gdRrffnZb+qr1CXG6dYBewUacJFnmPjLGJrY/qv26WTt0/NSA1YJXY1yZtMb1US38b08VSMfEbMbix1cl+XSyYGsVlbvWqCdMznmUMViRDVGY3TIZgrOoUBvR9WndWWv2R5AAkP2Q0lVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_cold_or_pageout_pte_range() takes pmd_trans_huge_lock(), whose
pmd_is_huge() check returns true for a device-private PMD. The subsequent
!pmd_present() branch has a VM_BUG_ON() asserting migration is the only
allowed non-present case; a device-private PMD trips it.

Potential trigger: an HMM-based GPU driver races with
madvise(MADV_COLD)/MADV_PAGEOUT: pmd_trans_huge(*pmd) reads true, then
migrate_vma_pages() flips the PMD to a device-private entry before the
PMD lock is acquired.

Skip device-private PMDs after taking the lock, before the !pmd_present()
check.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/madvise.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 9292f60b19aa..870be398c6f3 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -384,6 +384,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			return 0;
 
 		orig_pmd = *pmd;
+		if (pmd_is_device_private_entry(orig_pmd))
+			goto huge_unlock;
+
 		if (is_huge_zero_pmd(orig_pmd))
 			goto huge_unlock;
 
-- 
2.53.0-Meta


