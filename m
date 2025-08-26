Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F22DCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2658E00A7; Tue, 26 Aug 2025 03:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A627A8E0090; Tue, 26 Aug 2025 03:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978EA8E00A7; Tue, 26 Aug 2025 03:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FE7C8E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:07:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12758BA938
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:07:45 +0000 (UTC)
X-FDA: 83818028490.08.EE175B2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3076018000D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:07:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192063; a=rsa-sha256;
	cv=none;
	b=iLpztKzKGMdcmasWBRq93YCz6j95jVAvOAMrmLivY+RVM4Ww2xt3/sqMPXGKW/ycGD75mj
	NJPlv3+8q1AFbRNBIPpKQpMkg6QOTfTSfYymd60eTL/KmBMpFrs2kgmUOBx692vJbQvi5z
	5vq7bOsEUUYj07baGJd5LP0eSLIaYrY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=sKAakFoGLWYVQ0TpKA08BOT1tW5QsH2hQlun/NF7VgA=;
	b=ONBqYu4GVdzn1g8QP47rFbtqdhph0lgaQ5kMSCobvSpbBMBL4qFXYuPCSiRhKODgAQTMvl
	2FYVe8/TfndFef6487GveIDn9K1G/hR+jdtYd8iEB6ps/ah3Y/7S/zWl3j6CCNlrVbUTZs
	VShUKarCOdFZ7+d71w/G7rXcEalvbWI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D68711BC0;
	Tue, 26 Aug 2025 00:07:28 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.163.65.202])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 15C723F63F;
	Tue, 26 Aug 2025 00:07:30 -0700 (PDT)
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
Subject: [PATCH 0/2] selftests/mm: uffd-stress fixes
Date: Tue, 26 Aug 2025 12:37:03 +0530
Message-Id: <20250826070705.53841-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3076018000D
X-Stat-Signature: 8fcmjeorpwi4kwa3armokbg5j7nng6mt
X-HE-Tag: 1756192058-863228
X-HE-Meta: U2FsdGVkX18JBMQ961ChcWJg6633aWEPaXszP6jt1ebCPoJa/8oauD7BlkqZYkBUlL/8s6l9bb8zYp12JFcPKKroI6GFlw63wcGv4DHyhVICQL1WaPpXj2JQqFYKz99USSpZxTYML3PgGC8beXgo3cQ09CpMaahBN+rhTSqbt+a4lnXAn+mb1loHvEbhp83PR/muDpXDLXDMtAIpINTNKFTSxL5J+QLCnHfLAq1MxSk4IWiy2n+lcrEjE0qpAqK15koEhefFtm+JOXnWd5sitNg+B1k7ANr4MtAs/NUSYJTD1zcONibEsAmeV9mkn9AaVHKeT0M/qWDvnY3/gpnw9WSKnsi/SbkWNwg+NmgRHCSsvPr5+sfFSF28LwkZHDAWV3XtWlzGGXvEIjwdAREkrS5Db9YEmtQu6UTwtrqeD9RjOKO7X9TClXpgrGSmWy3CFGS5ompSZ56iFmZ/kjyHl+mqUA+Duu/F/wAkEQvGHrLJ1Gmnik1ruU3oMJGhARjYnZffngIEQeRdP0OeC1P70G8wrnl1cRZBrGOF3pidK5takx8MuGT5Vzws6mG0AiWHsa8oICYfoz6k3bNJM7Mh9kn9XoTlH0BuYujm1gSeVPFl4C4RcsrpBfUdqOGnozYeDBQmpmOSi3St4RkI4UU8R2M/Yp0WehaSMFGrJbLoRR438rSzpjchoqC0e5I2YHw6hyuzI4FUyCazRzkVU5hj7PufLN+cT+KpRAuTXxWyFs5H+Lu3x/gHwuW+/rA88wcPRmDcjbks46b5WCmdfZKXjY2bhrU2xFoapM3UNqEYLOHHiuZsY6I4vMZ1EdQxIrw1F3nkReXmMMIzRKvufsUKqN672D+Tcw8/GJ7ZExe6KGb20VlOJm023IkMGgExteOzgpgqcNFv08Z87bg1w9+Uf7Sny5icBF8g+N9xvn+PE8fZrtb5uRAsXivkvF+/wA+vVQhvcC/in19SRo4mIkP
 zNJPdoK6
 aKz/ZWBZBjiz6zdGC0HCgw60EKjsrKcTBY8gw78LbJCU2EgTR3aewge6LPn5+7AhzKhqanZ3aHmNQ6LhGnreEwt4+UKf5FZsatH2S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset ensures that the number of hugepages is correctly set in the
system so that the uffd-stress test does not fail due to the racy nature of
the test. Patch 1 corrects the hugepage constraint in the run_vmtests.sh
script, whereas patch 2 corrects the constraint in the test itself.

Dev Jain (2):
  selftests/mm/uffd-stress: Make test operate on less hugetlb memory
  selftests/mm/uffd-stress: Stricten constraint on free hugepages before
    the test

 tools/testing/selftests/mm/run_vmtests.sh | 2 +-
 tools/testing/selftests/mm/uffd-stress.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.30.2


