Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49377F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21BF6B00F7; Mon,  6 Apr 2026 10:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8EB6B00F9; Mon,  6 Apr 2026 10:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A36C46B00FA; Mon,  6 Apr 2026 10:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9526E6B00F7
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:22:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F05C1B7E79
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:38 +0000 (UTC)
X-FDA: 84628346796.13.F054623
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A04F81A0003
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cEsblsUH;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yd1m2f78yDrXMiqMFIv+S4+GfV+hGzgCDXMBcoxkGss=;
	b=gwBw8FCLifN8JESeLp5SZRjD5QvKo68q3wmeik8KN61yO0rPWo+oRkHIvUBSh9ejSqD8YL
	NEAr8K8rWeEqfMxTBdLGaL0u7/l0G5WyeVtKwemu9kpGW50q5FOMVwBhgIrFtjpvPMczz1
	i9YH3OpGSIPDv43gPGbZR2VGjhLWvd8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cEsblsUH;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485356; a=rsa-sha256;
	cv=none;
	b=4RGqYSORaFA3PUcxktyV7jgtXVfoFNAWUR6zJb0MhSrbacbZRO3dAXeWb/t2ZrvtuMNvyo
	ZU8Ql6Go/Q7ZUzqlKiuGP19rCRVSvdJTeuVZGwPlwhiswBjZw2ImTjUMe1mRn1Cb4dXBwR
	NPpCFy/PRYz06xdHiMia3YyL/tbeHAY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA37F41A43;
	Mon,  6 Apr 2026 14:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0CAC4CEF7;
	Mon,  6 Apr 2026 14:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485355;
	bh=c9lUlZ2MxGuh/r9cAcf/coqCUPJYBUQSQ+lZzu+qpn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEsblsUH9azMAcK080g7t0QSFUTGfc0iQBF1lE3jnkjzFQa/DMnrgcwQUtQO+SuN1
	 kBF7m5lf6V37cqCz7rpVEBp6W9JgYWkZvFXO+rFlGze9jJ7t5TJU8Qm9LnhqkmiBcC
	 ntTHXQm9+5JJ4Pnw2gK/n4QZO2kzXv4Zyo4qbxciumi9G/NBYvvvjIQkWprEUEpMOF
	 Np4dS/XumqPG/6xZCq2IP6I+W/V1FkNHXRAzah/r+CTsqZZNsWUda5kZ4NWb1iXdW7
	 ufqCernM6yxBTGLRLK9YW+EGR/GSww82H5huWVykgk7zjoUYssPv7J0y58xkeMfq1K
	 zF5S++tOYandQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 50/53] selftests/mm: va_high_addr_switch: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:32 +0300
Message-ID: <20260406141735.2179309-51-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A04F81A0003
X-Stat-Signature: mursmxrazu19cnytrh3oorgp8z654aum
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775485356-145965
X-HE-Meta: U2FsdGVkX1+jnOAqlZqSyMFr/8GrdYRRUoWfZH8f3rKHfetWHwAKaK1F9XC9y6f8hbFLKq0jRcT+twhqs7lZuVZcSTTDMe5HV6J4Svzt2ezZFQaR7EAgU/DmrkNL1nWW+XB14IIWgmOaNDLXOQzaHiiKQw1lIRJ30TL1LUFZnhjmfJBMd+BjSaN/famB5NtdCxGRPNE+I0oFDevE4iPQbEOBacgCf58UgDILjPqTpFa/U60t5ecCh081DME0zetw+TlhseE/1VAJQv1r6MGyUdja6vxi4HaVFxF/pqagXI3zzTgrO/I12uUENhxLMmAirAC+TR4WU9e5hcxfC8v/AP7/5Etm1ugNjbSvR9ybXd4osY/Lyp2ezvlVn8MCJWiHNWDXympN4YLH2xeF6Gu+9qHk0lQ8r5+LMEYtSKFzyPpEG6/Cf0TbWZi6urNk1SVhCygZtCBsmbC/wZBinHcgahGvkLeU4PS24oLm/Ig+BnvG33eGr+ozKGikW0wIR3KJ2Ic7FwDWhBeo8+JP34VmZ3d99CjOHaIl+QrgIoaw8pn8Unf0g09cnIwuQ0Og+S235WKBDwUuY2fiHid0ntM5D/V2qtowkynAtVakg6te0Hl0Tlt46SqTjgviZVQ4d38jpM4RbhCXajiy2UXRqPkFVOCVbfbEyzJ9gLWJP3PdKam9F50ZV5K4J3nM9n9Z5Hg+7DGBhKiJhRBVGwaXDmiQ08aG9x86dAkLRaMvPzsQ2VIBPQbVariOFbBNuhRBPDxJZ3w4BY3SBj0awWFn6f38FST9WFzs+xruExe4GWDi6oy4n9BIJLYXVmKq80oukxStrVgSg1O26HLgzGN8zx483YPFWQztz55lpZZ0ixno3CctOjsRyfHRfn3rQj29T/kJP0Fmuu/jBk4BlZqJACRYPXlRCKMUFrgPI7c5KlGtCGIdkiHVul5PyBDfAJp3ITUkymg+g5IGvP5CTQe/ioJ
 E/TsuzKF
 xgvdR3Xu495Flob5YweEZ4WL7VpemU2lX4etqKxxfRHNxYBJin/MXBclyhEfOXZmS7POC4VJWuoB1NNtdRxfMtNJzAKiVMrDakYT/hFd68/vsemPYWh8YhlJ9J2jZPFhDEXumkeVWZe0VifmaLwVqS3c6H3rmkk2bkwinhq+yGSEBviU2x9HiaXSEgvQBJPiXebkBgfGjHAfRqvOVuAyrDdofknHFYTCDgidcgvTh3HOCHaW/7fXfP48PyW+VD/utjofoXlyF8U33KX6KyQ40Tnv97OXSN9VuPyVG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

va_high_addr_switch skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/va_high_addr_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index d42ad50eb2d3..4a764589f553 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -323,7 +323,7 @@ int main(int argc, char **argv)
 	if (!supported_arch())
 		ksft_exit_skip("Architecture not supported\n");
 
-	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
+	if (hugetlb_setup_default(6))
 		run_hugetlb = true;
 
 	testcases_init();
-- 
2.53.0


