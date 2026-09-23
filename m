Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9898CC98307
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B7D6B008A; Wed, 23 Sep 2026 05:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC686B008C; Wed, 23 Sep 2026 05:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB466B0093; Wed, 23 Sep 2026 05:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C80E6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:13:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D4AF14073C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:13:17 +0000 (UTC)
X-FDA: 85244463234.23.0897260
Received: from mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	by imf10.hostedemail.com (Postfix) with ESMTP id 661A6C0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:13:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cnsBnZaq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.241 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790154795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MqDx2uNPV3E/fiWMTSd/dV4UjPLeNNzFK2C1QLD5Gus=;
	b=C3SNjfviS1vSau81Uk2w50HylmhwVqQB0WGUcCBSN+UsHG5Xrd2gSKZfH2SwKF7YIxFa7b
	73Fxu1EmLe+wBrgWWs9uzxmX70zn8tKmIXNvMRReERjERWMB8feDCO/4EfQMbtu/8SYESE
	+JyL/cdF5uUFGsW0/GiWC3kADwO9nWs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cnsBnZaq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.241 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790154795;
	b=oLAn0/YMWW+kMQD5QGaKC9JTutX+Lzp+vLyUsKlq52ifbs5rHGqB0Lx/pIxdn4mXwqIlNY
	r0RC1fn9VCCp4eSYP35HvRcDk8MIdsUdcVTQOuVd1zMVPeOnJpTeWYCaGwLcWyV1oropMb
	pzos1ZK5Q7ybhOmNAH9Ihe8Zw4/u2NI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MqDx2uNPV3E/fiWMTSd/dV4UjPLeNNzFK2C1QLD5Gus=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790154793; v=1; x=1790759593;
 b=cnsBnZaqlKuzFKjBCZrA3WMFV/Im3vFSfZKhMAkPNScjMRtBbIeu1iPgD69t/jRSwurtgL+O
 a2Vz7xXdr71XVinWlSHycoN2BSBPZJL3h9qKMiFw6YSU7oP6LrE/ZuZOurGBSQd24Ahu+OsgUVE
 cQ03ChwaT7l3ZkN+fDeLMHXc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ad223138143f3bbe;
	Wed, 23 Sep 2026 09:13:09 +0000
X-Mizu-Trace-ID: ad223138143f3bbe
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	guoren@kernel.org,
	bcain@kernel.org,
	geert@linux-m68k.org,
	dinguyen@kernel.org,
	schuster.simon@siemens-energy.com,
	jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi,
	shorne@gmail.com,
	dalias@libc.org,
	glaubitz@physik.fu-berlin.de,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	linux@armlinux.org.uk,
	vgupta@kernel.org,
	monstr@monstr.eu,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	davem@davemloft.net,
	andreas@gaisler.com,
	richard.henderson@linaro.org,
	mattst88@gmail.com,
	linmag7@gmail.com,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	tsbogend@alpha.franken.de,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	chleroy@kernel.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	ysato@users.sourceforge.jp,
	shakeel.butt@linux.dev,
	corbet@lwn.net,
	rdunlap@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-snps-arc@lists.infradead.org,
	linux-arch@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	hughd@google.com,
	qi.zheng@linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 07/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for m68k-coldfire
Date: Wed, 23 Sep 2026 17:13:03 +0800
Message-ID: <20260923091303.19671-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-7-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-7-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3ijg9soto5zx7i4b8nfpcfbutgx34hqa
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 661A6C0002
X-HE-Tag: 1790154795-933121
X-HE-Meta: U2FsdGVkX1/X5beaTNfRN1AUZABwTwLvnLokGm/7/C4Hti/PlJGksoCQGbupSaLRc5v+aYkcTOwV3QZNS39HcHL854FBx3atJLjq4WdBd3Cyxcql4AHPtHUQ3d1w3coL6CKgYG4Z9OrX3E0mv2wwWEhAIvbPGbz3Ez1xFQCdmmzFuyhwLrGy9V+2zoLURuJT1x6uCPElIr/5/mxU6gpDm94jLD+iwZe7gAiiZfqeDGvEjtIWZ+Q3/aXqCjHWzZ7oTVMBT6hr4H0Up9c488AFmWZDMvkltdo/H49SMPf6mxPmjAKtUOq8Vb5etpwpA/VAmWAl+qK6by3sxMvlx59hPcpHfV5alggUIXSO37SeQFN1yZJMlM6qsiDi+oCZsnbueMl8j76tnNtInyuwLUdwy1n0qzgy4I5+R2YzieyJyKF7yWPd24uscNXzk1/iA1hgAV6I1Qf3VHmXfazi6yDgCIddwUj1C5fgOdKEE+1m7koG1jVsvNynjpOPG719VYyZhq4mXsGy5BOmgBE/y714Ynx4p8IAcmwVSkH892tVm3SnnOsHpFFo4BeoYdmW2dXUinx8eXN4EF4mLnx+C3khNSTNpW1QWPXHCfWPKraKR0mdqtO9Yv5YKGQGVDqN2KdElRVsGWeeflSVdmSm0lK1gMYWvSlbgvrvQ88LTciJ+tRXGJxw1/UsrOocEfnrduBebtM5jmox/uFftJ/+JIvmLznmJCnoRhjzzY1E0nuIFekD98lM1lQA0ThNOOpKWhC+3wggnydPUR2Jq+qyE39MlFJs/uA17aWFlvC1evKpEMOME3UFsv5mkv0MmUgG7jCvq33tKTLf42L+c/qRafxaJ67r4y5zhlAuXdvVRNsS2AsDgAQe4ZDaWApkNnCvp5evr37j5a4pXrOjC92n+1D31APUe3TJWJun13D2yNtGS7dmZzypgRfZibqxOXQNdP21CUe6fVsUUzsNkpcXQhn
 lhC+iciS
 Tcv8JKIhNCKKTfcW3Jk9dAKVAPqWVXF5IuLlc9946/LrBb/fJFFRD2eF9qSJU+/GOyzlooh0bcDcy2sEa7i7xgZS2+h+MhPNwvKfQJHFOPBQ4QMO+uuQ7L8WR7rgYzjxa1jybkJdLOwPb28XYV1KnqtnY/0iqDVzAVSatZ87Ab0DPLA3E+LtkD+t6raMICqt2J4HBAAuAUbTO5GQS7SqWmo6BIddBN1X5v2KBK3IhaD9Lrtoz4clVcqb/g7IpIhfdQ/FDtUw4u+Ub+SRDHG3iKh1eA52qSYb78+alFIlOKS0fFkknDYRUH61vzpkqqy8LH9fAnmR9l1DzHlkBQNm5HIF9FmkszVNWCGhwmJra7UojukACQu6O+8JYQWs7FhpFk36i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 22, 2026 at 04:35:38PM +0100, Lorenzo Stoakes (ARM) wrote:
>Similar to sun3, the coldfire variant of m68k uses 2-level page tables.
>
>Update its __pte_free_tlb() function to use tlb_remove_ptdesc() in order
>that, with CONFIG_MMU_GATHER_RCU_TABLE_FREE, page tables are freed under
>RCU.
>
>The page tables occupy a page each and have no odd semantics, so this
>change suffices to allow enabling of CONFIG_MMU_GATHER_RCU_TABLE_FREE for
>m68k-coldfire, so do so.
>
>This forms part of an overall effort to switch every architecture to this
>mode.
>
>Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Yep, ColdFire PTE freeing now goes through tlb_remove_ptdesc() :)

Feel free to add:

Acked-by: Lance Yang <lance.yang@linux.dev>

