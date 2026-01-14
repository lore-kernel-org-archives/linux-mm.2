Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67833D30CF5
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 00:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0366B0088; Tue, 13 Jan 2026 19:37:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523A36B0089; Tue, 13 Jan 2026 19:37:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42FD06B008A; Tue, 13 Jan 2026 19:37:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEB96B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:37:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB08A1A0304
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:37:43 +0000 (UTC)
X-FDA: 84328706406.04.36A2FC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 10FB5180004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:37:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BfSRPP9E;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768351062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afFjTxwbXHzfuFqdBi1UNdoet5NSFRpR8r6v/K1RDt4=;
	b=WX4cIqoL8LfHiln6k9lth3eX1jZzo14kyhrVlPYjfLk1Ia45xmFxoiry1nrrS348Sx71P3
	aKeaa34U5dAfS38Tqk3piDf0SmzzCcwog/2eDNvxuT/92E+elSksJTdcQgh4K1MaRksWrQ
	V90znV0NZk5RiQWOWmUKR2z9S97xQ2U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BfSRPP9E;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768351062; a=rsa-sha256;
	cv=none;
	b=7y9ongtPfn7thHAlX3WWgGcLbnUL/JFBQIxEsbAllKQUSvhLVBDhUQ7uw70WpwcNfKcx81
	wfYxvOJKVJUBPH/PLEqhsEBsYXq9eAo8nHyyD7yHCF6VrydAprEby76PR04vWt63if91yI
	IRjLUjXkFgaYTdvsj4t0lv7tZCJqXSg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C347941A40;
	Wed, 14 Jan 2026 00:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2CFC116C6;
	Wed, 14 Jan 2026 00:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768351060;
	bh=Q+UtH2RbgPc82AgFy6jnFT0vTWt7pDcnb7349/cBW0s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BfSRPP9Ex+pPVwS+Qja8scCLs4R9WWSs3LJRXDqoz4N1uEKtpYHKgAWZfN/cHRiAT
	 CWPvgi+rY1vq1HnC1iO89Zzvu2VVFkvutamjL4akHIN8wB/+fdkGa8ChTF/FpnugLT
	 xXN+S4h7tTTZr+VBY5Mc13t1C369RH8udaXhL7nA=
Date: Tue, 13 Jan 2026 16:37:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <akpm@linuxfoundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
 <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
 <byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
 <apopple@nvidia.com>, <mgorman@suse.de>, <linux-mm@kvack.org>,
 <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v3] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
Message-Id: <20260113163739.902aade0c1b474723e20de86@linux-foundation.org>
In-Reply-To: <25e3d755-4d4d-48c5-b1ac-ff62d37694dd@huawei.com>
References: <20251223110523.1161421-1-tujinjiang@huawei.com>
	<25e3d755-4d4d-48c5-b1ac-ff62d37694dd@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mu16ujk637cdx6m3jy9zfdbyewqgz7qm
X-Rspamd-Queue-Id: 10FB5180004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768351061-610432
X-HE-Meta: U2FsdGVkX18Bj52jo3JFXh8jvbmPGhv0Ns2cWIwisQAqzsGqHIsMXKKzx2jCOdNxqdLiDUtwSc8hxS6w54i7cwNIk4W1ds819Fi+VkYswGPmetWbGSratELic2ilrV+KkHSG65PK8op/wxL4DDF5S+KQWOlhrpOYjoQM4//Y6HapfxRVbDOWpcpiLbVnq9t7GSDinFbJsdNCZyoNT6Sm3ox2MuJQ1C0tNs67pLWBySwKP/V2muC5cGtvGj35XyWSg6DwzhCJ54pYqWBBLscCLOdRiDTU3d+1Yyyaogse2dnlTDEANRM9XzzLiHawhmaUFoThPjkQT1X6fBhjaGHe67Nadr06jGlwqaDtndrRDx854XZxzVVr2i9e8QDqUJablVjErcn0mebG3AaZ1Bi/yKCz+HnoDiLcodZkNLE46FtfDzel3sO2fU/yANl8uLW2bUKThV1s2Mf+ZQtd02ah24mQPnI5Q+6cbXF2+LN3JlrW/RmN8bEsS321rJK8vVbM7leXS/cdZyE0XrCC32d9UFkbqKtd96JErNGQufeEd4HIUdfPhmZvYfpjUGVyGR0aAWVJTEq1xLCHOeCWBFS1BpT6CY2pVGzp5VS7oWZbLD3J2GNckMjXeI+652/36QcNjFMVHpxLOBwXL+K+UpbG758kCLiEFUrTRartawW/xq4hu2ICu8HftmHurmHL21PPh9uxRGbm6gmlq0vJnJ/tO66w2N9d+uCuymoTRUDtoU1+iqotEtH4+dUfm3ZfYj2KVhkkNFGkP4fJFUOjhv2IeuCFzu8Jxaos7cSuTfSh4IOr/m40o22ayfJFl2DiNBtw1yj9/Yb1a94btCGFXK/N4dvmRzVirEcD5+D1TMEaMY8UqjX6mz6b1Sc4sC6chyPr6ECtaCX/qwoiRcPr/k8PQ2LkYZUx2QPFDOdddE5boaGj5MinQU7xTbSeokSDmHN4Jg5Eax0PsD1EhVbq2p6
 zXzYhvI2
 1NEQ/BED5w9o4CBKe5l8j2pOMW0AuMBH2BKqri2MFJtGZIOLKiItahIhc7KF6CbzJzWFRArc8S9bPB8dIV1w2EOWjBHpJ9E8DswlFIDqT0XDKcCuMTl+PHt6sOzHuCCEEoYeKk5axvIN50p0GZ3kENG0wxUORkz6QitHq4frkoDs7coafaAgbPIp8jte58RyP7a/fjqmJdo2IQZt7xjiUDZNzFhbaN5kmUaUTlwfTPhwdCY7SzF4ATqtGq21iS3TAjsE2TkJ9G/GHbBQA8fBieDPVqDzqP/2CCRTDf+Rdk3FFeRUw8zkf7ZdHnaNmPyL6vSzTH8JrnSmsgfFDceEOKY1NfrAtlAB+8Ghcfmszm6XQCDXF7y7BETNU7ZbEgaxv3JQoPQm65fySrPxlbdK47Bkl7slRFnpD/B8rv1SRg+awi5ls3VUcP3LzIPRgf43o3m78UQcnMfkj3vo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 09:52:42 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> 
> 在 2025/12/23 19:05, Jinjiang Tu 写道:
> > commit bda420b98505 ("numa balancing: migrate on fault among multiple
> > bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
> > for MPOL_BIND memory policy.
> >
> > When the cpuset of tasks changes, the mempolicy of the task is rebound by
> > mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES
> > are both not set, the behaviour of rebinding should be same whenever
> > MPOL_F_NUMA_BALANCING is set or not. So, when an application calls
> > set_mempolicy() with MPOL_F_NUMA_BALANCING set but both MPOL_F_STATIC_NODES
> > and MPOL_F_RELATIVE_NODES cleared, mempolicy.w.cpuset_mems_allowed should
> > be set to cpuset_current_mems_allowed nodemask. However, in current
> > implementation, mpol_store_user_nodemask() wrongly returns true, causing
> > mempolicy->w.user_nodemask to be incorrectly set to the user-specified
> > nodemask. Later, when the cpuset of the application changes,
> > mpol_rebind_nodemask() ends up rebinding based on the user-specified
> > nodemask rather than the cpuset_mems_allowed nodemask as intended.
> >
> > To fix this, only set mempolicy->w.user_nodemask to the user-specified
> > nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.
> >
> > Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
> > Reviewed-by: Gregory Price <gourry@gourry.net>
> > Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> > Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> > ---
> > Change in v3:
> >   * update changelog
> >   * collect RB from Huang Ying
> 
> Hi, Andrew
> 
> This patch has been reviewed, could you queue this patch into mm branch?

It has been in mm.git since Dec 23 ;)

The changelog led me to believe that earlier (-stable) kernels don't
need this fix.  Maybe that was wrong?

