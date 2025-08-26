Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC718CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBEDF8E00A9; Tue, 26 Aug 2025 03:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75048E00A8; Tue, 26 Aug 2025 03:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC918E00A9; Tue, 26 Aug 2025 03:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B216F8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:07:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64258BA967
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:07:52 +0000 (UTC)
X-FDA: 83818028784.13.1521155
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id C05D81C0006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:07:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ui/bniHOXISjDlVmRpJRQWkjdsRtFdvaFdofPM0F/Ho=;
	b=hXsjfKAf71hyGd5WeOVF42ehyysAKOqCrS9ATBEVwp/dn1e+XeHQjjlznSvPZwGR70AlYC
	Z5+DeNpD5FLFLssLSLG/lts5y3FjQvZttbmkqU1JDvzTXZ981e9om8LyZ0djG4JD+1nXNM
	JTq3JLIzExVjNJqsXaRBhtjd4Gw/EGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192070; a=rsa-sha256;
	cv=none;
	b=z/YquEPqGB+A+eNA5t1dM1xRqvCO1jhSTxwX/Cp6gOXUvvd1fIVOgXyqdsfVpw+At+CfC7
	lElnP95ySG1iJ/dqfAvZaeOOvF9sE2nn7owX4ZSsyi8vmLVwxOWXBiL2rY7b6HgsKJALhO
	+uugMkr12R72QuMrHtpjCNMgF40gv8I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B63031BC0;
	Tue, 26 Aug 2025 00:07:41 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.163.65.202])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4CB183F63F;
	Tue, 26 Aug 2025 00:07:43 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	shuah@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH 2/2] selftests/mm/uffd-stress: Stricten constraint on free hugepages before the test
Date: Tue, 26 Aug 2025 12:37:05 +0530
Message-Id: <20250826070705.53841-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250826070705.53841-1-dev.jain@arm.com>
References: <20250826070705.53841-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C05D81C0006
X-Stat-Signature: 5wiua5kpj9198in3kpckawjsppg15ibd
X-HE-Tag: 1756192070-544622
X-HE-Meta: U2FsdGVkX1/jRtj50RfVFLP6ErzcA8v8pOFahoS4aEiYiIRyIO3WwH2vPy+ChNlCN9ThKN0JnP/Gh+K+jTfBE7e5b2d/g5I6UDV9LRbYE0HHCGtNQqOwxG0rNhzksY4n3fRSpdvWaaIHqOzis18gCtZ/rTBTit9U2l96rCQFwFx6CCm9aYS/BIK3c8PqfuC9i/VowhkhgKIAvg9zdJeymisxxWo4i888uZ1U3gnEIKXst1R8ApZqO+pC7aMV8+1iWUckQnWxs1Vu8jPCwwACSTpdDoBlwg9x+d6MYxj6hTEIbhpuQ0A/UcejAgPZCaZ4CV1Tg33Xytay4kS9DOs1g6GURAjP1u9yQZ+OVZ2JPqWFqsudx3I+saXnMJ4W0Ise1GgcM9wpHmmjNAPTEy40VPt4DmjPE49ENEBib4ssICRLC7Yr8i/vpA6vnLMVwMRjcyz2PX1Rmns5U5jXtAfDGGv/sQmk3aChrhGR33QvjjEbCmmIP+8ZRAvFi0T2jpQ1wKM5H044YSjis4seIBws6s5yPynOssZgrzpNRRnkpwwb2BGUly/kjToBwVCJXquxmJIzE3jkGRCpDXBTpMrRjUNiFzH7QudmxBVrrL8mrpuIkqJ0SzG1AzX+7owa2gKRcbpqOOGwiHWKm8ZefNFWJcaUW27mLQ03slvPxn+rLJjbizDd5wb4EN6sahRcaVmnaid1GXu/pCHSpkZMuivLS0oFuTarUczCleV1RTPPu1qi6bBLT5oZX9iMrG5ZRf2uOZS82m7a79ZhQGSwFdX19/r1lmWnA+xQHDmihIY/tUirNlChjQHcWAzxr3BDV6g2biTEiMEbKkTSlPQpHpI5AnlTU6eJiQYo3MZZFbg+fvQBTLLyoCWx+IIFgU58Bfk/w+yXzH1H3dWEKxys2xtXd5Ix/jwvOG8gRk+zRfY3LmFnrBKC0OEHz2tWBO+KHSUSOhziOGnMrpRRy/FAt/V
 g3nPCLm/
 UXAhLxWc+9u/x9EMc4STbZfJTnpFkbkd+p3M0B5yWj7sjLXvg8LKS9HjQq1VcLXbYqqqoChAfPWu6NjAnzj1z/9iHyBQ0ILYgZUkyjBuQPMDBtc6GZnwaNgSVLFae/N2ErPjUlWqOmmXqqu/LXMeUWi8jHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test requires at least 2 * (bytes/page_size) hugetlb memory, since
we require identical number of hugepages for src and dst location. Fix
this.

Along with the above, as explained in patch "selftests/mm/uffd-stress:
Make test operate on less hugetlb memory", the racy nature of the test
requires that we have some extra number of hugepages left beyond what is
required. Therefore, stricten this constraint.

Fixes: 5a6aa60d1823 ("selftests/mm: skip uffd hugetlb tests with insufficient hugepages")
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 tools/testing/selftests/mm/uffd-stress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 40af7f67c407..eb0b37f08061 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -449,7 +449,7 @@ int main(int argc, char **argv)
 	bytes = atol(argv[2]) * 1024 * 1024;
 
 	if (test_type == TEST_HUGETLB &&
-	   get_free_hugepages() < bytes / page_size) {
+	   get_free_hugepages() < 2 * (bytes / page_size) + 10) {
 		printf("skip: Skipping userfaultfd... not enough hugepages\n");
 		return KSFT_SKIP;
 	}
-- 
2.30.2


