Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C48CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47E68E0020; Wed, 12 Nov 2025 06:08:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F1B8E001A; Wed, 12 Nov 2025 06:08:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35548E0020; Wed, 12 Nov 2025 06:08:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C440F8E001A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:08:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D77C160496
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:08:20 +0000 (UTC)
X-FDA: 84101681160.15.8ECC18B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id E3B1440009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:08:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762945699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=2kO2vWIGsxvP5jIy7quJYT/UfLR+pgK9lzFV+ZhbJnU=;
	b=eiNdfEm2EFAl9QcU8yB5LdPEcbW9VHPi/ByEDsLcM3Qk3D/TRch9HrbuGvUU1Wx+w0/Mzb
	O1dDW9SzVEAhyA0dAYR1AWROMUfrDUqtG7QHhJTQjAr+i88vZsyt3/7hTfUlibYp7y/1QF
	quVwUPjcXteEZT210y45bdowCKz9fhE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762945699; a=rsa-sha256;
	cv=none;
	b=LsaL2xoXFLzECUKgjwZNm88c2rlRiE4bo+jyklTwzOsjFSxW+rSNv2XjFau303PLUr1s4u
	H96Hk5SEe4BpwPJmwXOfZ6hygkkoIxuRqbuqMEIIfRmf+8zz/7caIyF74GwWyBlyckFFHD
	GTPa9mTf75BbpJyyiud1Ax7cbK/3clU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F6F31515;
	Wed, 12 Nov 2025 03:08:10 -0800 (PST)
Received: from MacBook-Pro.blr.arm.com.com (unknown [10.164.18.56])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AD24E3F66E;
	Wed, 12 Nov 2025 03:08:12 -0800 (PST)
From: Dev Jain <dev.jain@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	akpm@linux-foundation.org
Cc: ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	shijie@os.amperecomputing.com,
	yang@os.amperecomputing.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	npiggin@gmail.com,
	willy@infradead.org,
	david@kernel.org,
	ziy@nvidia.com,
	Dev Jain <dev.jain@arm.com>
Subject: [RFC PATCH 0/2] Enable vmalloc block mappings by default on arm64
Date: Wed, 12 Nov 2025 16:38:05 +0530
Message-Id: <20251112110807.69958-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E3B1440009
X-Stat-Signature: 6iu711efoofd8iqysjzce85m9g4eypqq
X-Rspam-User: 
X-HE-Tag: 1762945698-802914
X-HE-Meta: U2FsdGVkX1/ojmE6PeTWdHLM2Qk+6RjzgoBT58+GD28aHvlln60jHky9fd6qmGisBlrfvABE2wXXavLdg1ilQYSAkgz7m+LsffkXUKWJgAv6o6Gae0oVWV5vrATJMolws+kCbx+IHAaeEPCFs8bP9TjO/PNc5Uyf/GVO0f3Cbnh76tsBJ2aMBidjKIYWBFAx89xTjUexpIfUDMGDcJ1LWnfXDeqyfogX91af/z70GvVTaa5D5g1RHKShC7Co3i55W+al6+W6c7e0fXVOHBnY2mWanf6gh4Aqc5hrNn75dD8o3rsZbGRglMFIL17cC4IXVGWcwiHaA7g85v9wnox/v9TSJpTgyz83jjTa/JOAMQGijkduaJhYGLBZEX2WL6ocs5aoUKt5S8ISYAgqWJti1CTgNbBoI2Lmywbk0/T+etY6GtBrwsSy6bBJUe1SMtrT0dX7t/86q3y9ol3D1eRXPLoyCWo/mAw/vBO9e8YtMrzsofKZE0q5ULzxN2lqN9CstCABEdfNOfJszTCaBfKx4JN9rfFs9FVAOvt+nDlmwAq7HvXya6AxZb8FLiKJN4eOWjwcRNGg4qfTXkK26VvWgoNRlSbssYSk9rgqZp47czzvGWJTmyUfjGU55FanPrm6OFmc0o2JPggwUfTx7R2cUrL8adKDy3xVdgguEBxB+fHIFk+NAiTO/DgqdE1cEpQWollYOJI4VGz3RaU7tELhJPxCjRBDz0NqpOcCSpWntCHHDyXCmR1FdbB/D+Y2CPkSPZ7EgFnzikp9t4alji8ipdc1Yf/7nwVofqFimOe6JchscF1mFySR9OEX/2vTlILUI4q9pXS+5XsnrF57hZOIVGf1dGZWcAAlH94UiW98yXYgv40plXZlg97Oy3g/Fzd0jhrNT9SG/6jYFILcUJqMWMj2xMpdVuuBW3mJn/DFXk1EkaMaSlvUVE7AW6swrUJG23a5qj3ekWjeu2CLPDB
 mn1E0AIZ
 RAqUoyoQp7KZq1icmQpFnTXF1Bp7YN8oMLtoNRjypKW/JCRoqeSgSTwl6dMksdllbiEjH5n6Qqb3s7hQ5wMZNQ3TcgfUxpSasrVIf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the quest for reducing TLB pressure via block mappings, enable huge
vmalloc by default on arm64 for BBML2-noabort systems which support kernel
live mapping split.

This series is an RFC, because I cannot get a performance improvement for
the usual benchmarks which we have. Currently, vmalloc follows an opt-in
approach for block mappings - the users calling vmalloc_huge() are the ones
which expect the most advantage from block mappings. Most users of
vmalloc(), kvmalloc() and kvzalloc() map a single page. After applying this
series, it is expected that a considerable number of users will produce
cont mappings, and probably none will produce PMD mappings.

I am asking for help from the community in testing - I believe that one of
the testing methods is xfstests: a lot of code uses the APIs mentioned
above. I am hoping that someone can jump in and run at least xfstests, and
probably some other tests which can take advantage of the reduced TLB
pressure from vmalloc cont mappings.

Dev Jain (2):
  mm/vmalloc: Do not align size to huge size
  arm64/mm: Enable vmalloc-huge by default

 arch/arm64/include/asm/vmalloc.h |  6 +++++
 arch/arm64/mm/pageattr.c         |  4 +--
 include/linux/vmalloc.h          |  7 +++++
 mm/vmalloc.c                     | 44 +++++++++++++++++++++++++-------
 4 files changed, 49 insertions(+), 12 deletions(-)

-- 
2.30.2


