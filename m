Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA6E4FED9E8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C2D36B0005; Tue, 17 Mar 2026 12:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59AA36B008A; Tue, 17 Mar 2026 12:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7106B008C; Tue, 17 Mar 2026 12:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 406D76B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:52:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0992D1A02A1
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:52:19 +0000 (UTC)
X-FDA: 84556147998.07.44DB6AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4AB0716000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:52:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XpIlqsRY;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mRPink/CGZvESsnn0HJkI/kxX1Yf3lMocbpsQtBlpSY=;
	b=4d/jpdJo4oWBlzjq7IxqHNlq3JWkI+7y67WcJLAGajmsq+LxQ2XRoy9QAXyfjx/HGaJR4l
	7WhEh1z1g8jUtzCLpz07/V6nNpUvIDozHcf07yl/SV1tm+wJOIgk7l6SBlU4SrWvl/g2si
	+yE4w3gaOD9Y+7Ae5WjGvWg5S5uBEpk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XpIlqsRY;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766337; a=rsa-sha256;
	cv=none;
	b=WEkTSX2mtY1DlTsKuIHJRzW066FVWwPyZsa/QVUirX7KB+CPVMf6LHuzhKWjXGwcSm5CmT
	GgUB8ihiHkcjFQXZtkz1NdilwhtU0dmldu1JlVEL+jkQ0SIGNVc5Jf9/vQ+iu9gLqbUvXn
	mSVKVfz2OikdvK9FOxzgcpLvlAczaaw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C401260126;
	Tue, 17 Mar 2026 16:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4487C4CEF7;
	Tue, 17 Mar 2026 16:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773766336;
	bh=/hoB1sO0J8/RDD1AeuSJTXY291QSQFnBtallbctCtdY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XpIlqsRYEe2SxDQVq5auvQeATk74ih0mn9WgbAexAhU+Rq1ZO0SnKKK19K9S6V/u7
	 S2sQ8XWpFAPiML62L0t3w2HlOry6WIGT6DIZu+w4lSfcphMLG9VrhzLdXLrSzPpCm4
	 DnhY3Sb72RWi1L6MWWt0ACeOCV6HhdpaiBAiakOg=
Date: Tue, 17 Mar 2026 09:52:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org,
 kernel-team@meta.com, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>
Subject: Re: [PATCH v7 0/4] mm: thp: reduce unnecessary
 start_stop_khugepaged() calls
Message-Id: <20260317095215.26a696018c6d3d1acb8e35f2@linux-foundation.org>
In-Reply-To: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
References: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4AB0716000A
X-Rspamd-Server: rspam07
X-Stat-Signature: sih3p1nqaemyfx1k5oupwy1tfjajhxy8
X-Rspam-User: 
X-HE-Tag: 1773766337-515705
X-HE-Meta: U2FsdGVkX1/HWb9LBF5toc88ykqAgIw1Qrr1QgM51BlmgWuLTFs0y1Xh+lun45gMlPMt195NQCCYn+tDMga4BYkHo9BzZuEncUiIRygFXQLaGRBnfVoFFXDwrUyRWdv8RxopHUPyaI3M7WuydmkXkEdiq++ZSmCkit9pmgG/JDlVi5VvE3ZNtL4YAPJ4Xz+nJlIEHQyiA+OltVjVjy3qEmAmL1b2af9AVyxNucM15QGCRAxFjCdnJAXYulL/uJP7Cr9UvgK6siPH9WJmF9sE8n1YH7XK9emIsLdPTzXqoirJoIfx78W/R6xg4wpzJeCZdZNCztAIVYXNWc62VjcXMendkJpdnaJ++FblwJRN1qSjcuzDu+l9SeHjcZo6bzILtgGPc/xJIcYt3lG1qqWULunjIeMOfqJlnFYSi1aI3sYNYO8MfCfTu+fxPaJwB71tmHQJPdqls7zCQAJufOHbDbytflF0rNImP+wm1UJYEwnjal8Abzh5yzpxpLFRRYY/PkCLfF8Lwkpi0wi60LMgRyxXMU/qz7+bvXYAkC/KL7lnUJDo5uVUOryN5ZPUjPqcniscDODctc6K839eRuvt6YMlEhvgbDh8ZPHrcB9gQkWjzZF25B+L6NBL0wGjiy6bzgkTXoW7RcyTUMQIZIv8QxXJo8SAJModf/sHJK64PtrcgDH7OCwT5CkJT+npROzomyMi4e6g9b+CQI6zBjeKpIVZk28VhpkoxKvqvGYZX5DCT6S8PBHyCpfLU5Hl0+ZKS4FoSWCJOFuE9UGEhQg+3NZCF06740axSdrqVwCDTADZIkLGf08lu2m+rQqjCEEkAWQqK6OJqWX/H++aV2WFbpJfjrTuKOC5hZDVGau+PCkYQhDdO6MSmXV6REevjN2F/fqTWDDea2hNFRDXQj5n+jKUYtt3WbijHXNzMOQ5XB/kZ3FY4IUEG6G4GCihY4pEt6CnMnNDXYq6mbuDeIk
 2qzk9+bH
 drc6E3q8HcG+cMCJxelr4UARb5iK0/z1iQlfy4forCDZNAA52xiDCIESYYQG3QZmUIy5qxHC4nPblhCmJ9Ono/rpI4effU/IXd+5XsCv2FXTRxfpqONYMvlNaQLH80vscCxsSK36jA3seQJo4YhBmwAUXys//oXehALe/pJgxL/VVsKdZeh3+W3dhGTiCpuucKZYVBOth6bIAmt/yZEJU4yfD4JWRL7ttvWnMo2IdujX1EsnA686RgO8zntWNlBXauALpZvA0Ou0m+MeRNcwVrBZim1B9FoDngjxJ9W+pwJO8TGqOI9oxHvz3M9n0vxwIBKUI1uueylCrCl8csSpozM/ntLNreusVCFQpXp8Uzx/95/TqVrf0LURCVqSjutAo0VEC1BXH2rWu1t36AD0lL+3LGrirjvtjhQM06U8ej+Mw0wh68ubTt8d1Bj/0UDFzZ9qdqfx5ck6K8rdfoD5vPIFNEMuvpyX7cf/X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 08:33:55 -0700 Breno Leitao <leitao@debian.org> wrote:

> Writing to /sys/kernel/mm/transparent_hugepage/enabled causes
> start_stop_khugepaged() called independent of any change.
> start_stop_khugepaged() SPAMs the printk ring buffer overflow with the
> exact same message, even when nothing changes.
> 
> For instance, if you have a custom vm.min_free_kbytes, just touching
> /sys/kernel/mm/transparent_hugepage/enabled causes a printk message.
> Example:
> 
>       # sysctl -w vm.min_free_kbytes=112382
>       # for i in $(seq 100); do echo never > /sys/kernel/mm/transparent_hugepage/enabled ; done
> 
> and you have 100 WARN messages like the following, which is pretty dull:
> 
>       khugepaged: min_free_kbytes is not updated to 112381 because user defined value 112382 is preferred
> 
> A similar message shows up when setting thp to "always":
> 
>       # for i in $(seq 100); do
>       #       echo 1024 > /proc/sys/vm/min_free_kbytes
>       #       echo always > /sys/kernel/mm/transparent_hugepage/enabled
>       # done
> 
> And then, we have 100 messages like:
> 
>       khugepaged: raising min_free_kbytes from 1024 to 67584 to help transparent hugepage allocations
> 
> This is more common when you have a configuration management system that
> writes the THP configuration without an extra read, assuming that
> nothing will happen if there is no change in the configuration, but it
> prints these annoying messages.
> 
> For instance, at Meta's fleet, ~10K servers were producing 3.5M of
> these messages per day.
> 
> Fix this by making the sysfs _store helpers easier to digest and
> ratelimiting the message.
> 
> This version is heavily based on Lorenzo's suggestion on V1.
> 
> ---
> Changes in v7:
> - Keep the atomic test_and_set_bit() in set_global_enabled_mode (Sohil)
> - Link to v6: https://patch.msgid.link/20260311-thp_logs-v6-0-421e30d881e0@debian.org

Thanks, I updated mm.git's mm-unstable branch.

Below is how v7 altered mm.git:


--- a/mm/huge_memory.c~b
+++ a/mm/huge_memory.c
@@ -353,11 +353,11 @@ static bool set_global_enabled_mode(enum
 
 	for (m = 0; m < ARRAY_SIZE(thp_flags); m++) {
 		if (m == mode)
-			changed |= !__test_and_set_bit(thp_flags[m],
-						       &transparent_hugepage_flags);
+			changed |= !test_and_set_bit(thp_flags[m],
+						     &transparent_hugepage_flags);
 		else
-			changed |= __test_and_clear_bit(thp_flags[m],
-							&transparent_hugepage_flags);
+			changed |= test_and_clear_bit(thp_flags[m],
+						      &transparent_hugepage_flags);
 	}
 
 	return changed;
_


