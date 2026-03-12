Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E7A106ACEE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 22:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411986B0092; Thu, 12 Mar 2026 18:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BEF96B00B5; Thu, 12 Mar 2026 18:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0D56B00B7; Thu, 12 Mar 2026 18:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 173D76B00B5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:05:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6C5C8A728
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:05:30 +0000 (UTC)
X-FDA: 84538793220.21.B70C5F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2820B14000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:05:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZsTJnAFO;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773353129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJCr2vGKsIHLS37rJqTuGj2Z8U6oKmj2uaVBuadFi8g=;
	b=TdzkQpBxG2OsyqzwjBh6Tv3+qYBiJL/eAgrgMUjfxuVfcQvCIR5jUxu5cYTBX0WYui3nYj
	BGcY+dRqpDIIznhtEp17yk9Xwnq76+5omKgiGYSadLW2bv0AnJmrszhFnszi03JdnksOBq
	T3BgpGFi9NViRz70v7eS5ULferYc38E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZsTJnAFO;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773353129; a=rsa-sha256;
	cv=none;
	b=KHUwB7wy0Xftpddny3e6tQ901uSssLAA1qFgcuj4/H3VlogxB/uurJ3AbiqkViBy6oB512
	Kcul7Pa/5wat2U9mzMToEK4qIOE6rcYYsjWhn/Ihwl/ZVbbVwd3PqMJOyBFk1JC2eRyCrn
	2uRY6CTquz+bfgE8VVy/uiqD/qAs6CQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7BC2360142;
	Thu, 12 Mar 2026 22:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E28C4CEF7;
	Thu, 12 Mar 2026 22:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773353128;
	bh=kJpOMXmeVrgv0HG/rFG8bTekmGeeG6gm/5I211m0F2s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZsTJnAFOvr36+k42PB7o8XC4L8ru8l4Pwk5EqtRL49hE3Afi6x8ed3VLafByWN8ek
	 b1Uh8rOn14iieth4yKSCmtemSITG3j5PoDpI762Vf2n+jiVAHL7MrnoQArrm5MWVyX
	 ao/3KIJbyb4xf/LbczAsiBmxmjquDbsgMM7uMdDs=
Date: Thu, 12 Mar 2026 15:05:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Ritesh
 Harjani <ritesh.list@gmail.com>, David Hildenbrand <david@kernel.org>, Zi
 Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain
 <dev.jain@arm.com>, Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 00/13] selftests/mm: fix failures and robustness
 improvements
Message-Id: <20260312150526.3662b2717b9a91776a2e43f5@linux-foundation.org>
In-Reply-To: <cover.1773305677.git.sayalip@linux.ibm.com>
References: <cover.1773305677.git.sayalip@linux.ibm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2820B14000B
X-Rspamd-Server: rspam08
X-Stat-Signature: offdongk4zsubsxzabtbmhbb59o3xx1y
X-HE-Tag: 1773353129-173632
X-HE-Meta: U2FsdGVkX1/F2bcE4Xesqr4aBwPePfKU6Yot3xkAeIQdZtyADZ3RN5ixNmJN0Fyyj65KJ3WSNpLc1i0Fm6BjsEu2DpW6hEwWq19HW5hstX8S08fSkImLxIoTYf/t67K+eEN1Ig9AIBQp78pUs1R++8QoGhlBYyQYH4vLd1YjKRCweQ7jg2NkXMEYMZMF5WtQ041FfHcWp88LlQ4yHhd+/lHqVi20BAQdPE1E2ae4mAzsjGA9QhOjllHFH2ioJ+uLM+lRbd5kcMc25x1pTHfTU2Lc+BWYowVNMtg2QPhhbiP/5F3cC4C+IAMIVXayQZZECA81HC9ofztlqQvu43ZbEdpSe4cULaAuPPA1F0dY3Pf/HVp4SkOM1AcBHy0iPhXgq+4YsJMewGXrERu3HxBUBYbUUhrtuz/cJrOowKzlstNt4QOQaKwWp5ZWllrd2PfBHtk7qF4ea9/yKTwF+nw8TZ8gF5yfcPI9st+8R7WR13f/lKnYJ3vBmKGxDwadutqnvkNR1kO1/A+dSFTUfubg2/M7aBbfllc8as+zT48j/U1ZnzpEMUHZDg2J0gFr45eTNBy0seIWyveWIcsrm00qFBW/n+Ls1zeEtUYzA7szPlLEzhM0RUZEbk4uWQtf4bVX1pNlA3it2A9bOfgADfEfTEBN7HCEfVKYWetuIMJjVC/l+gflXk5wa6teZ5uW82yJ8NqZL+mHOJWdYxB/6VmgFjqzMMSolqTN7g4LZ//reRr04EnK0fs3o5fN6UhKJgo+GE2CZAtBjghsCyJmced8dJ90gPIG8Tf0u3VSJRhixNkOGXioaC87mjbl9Zsz8jRVtZ8DzpDcS73yG7SHjj84gpyMjPYNJN53IMEESkDmU7k0KTtlDBSJN7hbn2LOYnGJ1R6NKwm7MHp2MElpoaTA37qIJsnLinS5olz+bPsgGdFKHeFHEDf819qfg16ikrUIZ9Bm3+NAv5oceH6eP6U
 pRTL6XTC
 LofTI4Zfsw0d/jDvAar/z0WfACA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 17:55:27 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:

> Hi all,
> 
> Powerpc systems with a 64K base page size exposed several issues while
> running mm selftests. Some tests assume specific hugetlb configurations,
> use incorrect interfaces, or fail instead of skipping when the required
> kernel features are not available.
> 
> This series fixes these issues and improves test robustness.

Thanks, I updated mm.git's mm-new branch to this version.

> ---
> v1->v2
>   - For "selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap":
>     update FLAGS definition to MAP_HUGETLB | MAP_SHARED | MAP_POPULATE and
>     used it for mmap() calls as suggested during review.

That was a really small change (below).  It's better to wait a while
(half to one week) before resending an entire series.  So as to
hopefully accumulate more changes.



--- a/tools/testing/selftests/mm/hugepage-mremap.c~b
+++ a/tools/testing/selftests/mm/hugepage-mremap.c
@@ -31,7 +31,7 @@
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
 
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
-#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
+#define FLAGS (MAP_HUGETLB | MAP_SHARED | MAP_POPULATE)
 
 static void check_bytes(char *addr)
 {
@@ -121,23 +121,20 @@ int main(int argc, char *argv[])
 
 	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
 	unsigned long suggested_addr = 0x7eaa40000000;
-	void *haddr = mmap((void *)suggested_addr, length, PROTECTION,
-			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	void *haddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
 	if (haddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
 
 	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
 	suggested_addr = 0x7daa40000000;
-	void *daddr = mmap((void *)suggested_addr, length, PROTECTION,
-			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	void *daddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
 	if (daddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
 
 	suggested_addr = 0x7faa40000000;
-	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION,
-			MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
 	if (vaddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
_


