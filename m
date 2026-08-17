Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B76C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 08:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19FD6B0088; Mon, 17 Aug 2026 04:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D0A6B009B; Mon, 17 Aug 2026 04:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C7F6B009E; Mon, 17 Aug 2026 04:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1C06B0088
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:04:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F7371C19F6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:04:49 +0000 (UTC)
X-FDA: 85110025098.05.1B9D8E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E403100005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:04:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jlsg3MZQ;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786953887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8YEgw0OcGhLggCgZu0df/8CubxvmgeZk0MDZaoHme4=;
	b=D7+rGzeoKqFnaH22aDEIYN2YPUbJGPIti1wUi8ZQIuUsgb7k8HsoiNAy0vWBDIPxoMM4nB
	2zHYFQCqAlWpsNF9EJ7kONCES7MFH0Wn116NdcIXawAL9HtBEme4sb9sFFEQgBUQp1VEMF
	uFqZQgXFSiEJPEY0gLPwJNcC5N457bE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jlsg3MZQ;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786953887;
	b=GXbgxrcJ+SDLLV1igF+KpnjwxZ6+ZpbsdVH79JVuRrIPfNgGqxRWegzo7aaGnul2EV+7Oe
	l2j5V/2oynDox80xPDBM53zOdtAcI85AFVZSmacaPN5HCrGvvsT/rnvt+BLsJNPbLU1wH6
	2LJJvLdQ8h2iNBmAgfq5vwB95lQtdFE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11CB06013A;
	Mon, 17 Aug 2026 08:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE351F000E9;
	Mon, 17 Aug 2026 08:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786953886;
	bh=/8YEgw0OcGhLggCgZu0df/8CubxvmgeZk0MDZaoHme4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jlsg3MZQb936uD7sRHVGzRJsM4FPP06SzC3LJGqDw3Ziw3v0yU1MFVOvQeRHx3m8o
	 2tS/8PUESGgMjjAPH43sdrcpv3blq0zwFE7Y9/Jwus9K5nh2OSeLV4CUWEWbjXRLLY
	 uzLKcaBO52LJeRgop+GD7611SUufWlz9v8BtmwWELgHKrQ3CopYlUrafbxLptgRsXS
	 ZcxocQSRRySex3jfHuDZLY/ig8HI2qtgXuVA2LIrKB17xKtWo08XOMKjeNz+eKD84x
	 m+qvoZlHD469WMQh3awtCO952TARRFzZDrvSk2C/1IZ4CGLsOtVxFr5sbaGd4V851Y
	 g9g+uW3thmbhQ==
Date: Mon, 17 Aug 2026 09:04:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de, 
	rostedt@goodmis.org, mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 57/57] MAINTAINERS: add an entry for collapse
Message-ID: <aoLASuFkQ3rUrWa0@lucifer>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-58-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260816224609.308019-58-kirill@shutemov.name>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9E403100005
X-Stat-Signature: pqccmtg348sandpbe4wfzno7ppug14s4
X-Rspam-User: 
X-HE-Tag: 1786953887-751356
X-HE-Meta: U2FsdGVkX1/vq38QAZq3YXzDeuVtd+Vmjo/fCfjAQUKL0lc8IxCoFqMRxwLQkFchTZcQGZi1+rDe0/LfchUOQJ/ZGqtDVG1D7Oi8uUYmWJo46W4umHaIkGoo969qZets3cHLfIchaoSC0xZ9A+2cjHjjjnJKqJOmaw1w9mDm2GTQGQkN6uY912lSsaOt3sEcK45TCaFkbwwSOAHKhn44+LT+pk1TF5gPBfvOrXvd2ppyXL1JG0YCXW/2rMQ4h63mpmgFKE8Pf/KAZ7rm6/F8MFXCqZi9t+4biPIyb/muLMcpfJiV5a2oeZcskXTX+/Q0sBhFUTIjUJEmG75Ir/9/NiKeNLPuG5Zc5qvL3ncl6Iq7vLt0beDqhIjzA19VVV+XsoBMyEmleXqPz+NtopeS8D30FewtQukW67jz7oe5G9TYgbeG6nd4KbKlWvu7ClICUJLa+yWiByGzNM9CT4MAWWu/Er8ybszqIvgX5dYXAGaAUG6a1caLluyyTHHQnv9FCzdmikbR7/NHggeQh1+aHmFsoRJAM8+jaECd4xTBsnL1Y0QVJL9cLsCBoQwFW9bEsvF2e/NVUncqp1et/MekJnmMB0YTByOIA83iDEvuOLsRoIomEKvUw1tDor9tFVNX+BMRmmFCpk5PjIPWrpzo34W1gJslFcds/kfsv1vrbGbJJGUS1LG/mlAfayXSi8vja16W4kco/PY+q3rQDtg4/yjdZ6B98psJF+modbfw0zFjZqrdQPjjU/jDts58N5XLm9ocz6LL9rckThKFM/kVJsHdrnW/42qbuzxtC6ZxYt8iIrcIQ1vSET7De2FOqtkTxF78DNCwdht2OJdrHlRR6Xg/ZnSmu4BYsCYq1FGVYZYNf2Fymd5GuMmX4Nsbclct2bQG4auWpbzWJHeTQGiydqOs/X9gChsDe7i7RAcuPCTcyXCrRAziPuoF23mMBaF+2LiofNJS9fXI6+Ro/j7
 bCIrHYJZ
 m2bDmPf6dAWgk9kQRkkUw3Ei1aeRJ8D3mgRzYxvldZC3Q2YLusEvVAAWDch2U0pOBViWG2fUBHhSkxZZdA+s7BqJ/5KH2bwSZ8gHzWZ4w0c+sBhOu5l1N+R90ajFMw4cMGGA0Yl9py73RR+DDxV1T1V5Q5ecT2cJpmfoqvvGQdPhXwP+YSljyQRJ4OX9vSj5Eq23Bke2l0xarRHaAR6r7sy+njZC5brNBsFbn6bhDvGp1niywCpmrEMN8+Qom6Bzxdpw/wsUL2lKUelfHE319fHS2Vi1ewv4LS4yEdwGqjpiiLipKEpt8+hm7zHO8cGWm0WWvdFGxLtKXiAcqRwmsMDrAQFVhLexIN78uavzq3fXGUD3BrMZfCNHseFYtqh5v8qPTKiBXR0Lw23ILLhLFr7XILLP7jjlOfnBpmqzQm14sZ+TdtiRCQp0Hc1sIeVH7q8ZPcRMn/soORBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 11:46:09PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> Collapse is now its own body of code: mm/collapse.c, a header stating what
> it offers a caller, and its own tracepoint family.  It has two callers,
> the khugepaged daemon and MADV_COLLAPSE, rather than living inside one of
> them.
>
> Add a section for it, and move what belongs to it out of the THP entry:
> khugepaged.c and its header, the trace header, the selftests, and
> mm_slot.h.
>
> The selftests are matched as khugepaged*.c, which also covers the race and
> sync-check harnesses the THP entry did not list.  mm_slot.h stays listed
> under KSM as well, which is the other user of it.
>
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  MAINTAINERS | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7c179b333e4e..4e4e5030b979 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16955,6 +16955,20 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	include/linux/balloon.h
>  F:	mm/balloon.c
>
> +MEMORY MANAGEMENT - COLLAPSE
> +M:	Kiryl Shutsemau <kas@kernel.org>
> +L:	linux-mm@kvack.org
> +S:	Maintained
> +W:	http://www.linux-mm.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	include/linux/khugepaged.h
> +F:	include/trace/events/collapse.h
> +F:	mm/collapse.c
> +F:	mm/collapse.h
> +F:	mm/khugepaged.c
> +F:	mm/mm_slot.h
> +F:	tools/testing/selftests/mm/khugepaged*.c
> +

I'll look through the series properly, but presumably this is a separation of
the THP collapse logic, and therefore should have the same maintainers/reviewers
as the rest of THP.

>  MEMORY MANAGEMENT - CORE
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
> @@ -17272,12 +17286,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
>  F:	Documentation/admin-guide/mm/transhuge.rst
>  F:	include/linux/huge_mm.h
> -F:	include/linux/khugepaged.h
> -F:	include/trace/events/collapse.h
>  F:	mm/huge_memory.c
> -F:	mm/khugepaged.c
> -F:	mm/mm_slot.h
> -F:	tools/testing/selftests/mm/khugepaged.c
>  F:	tools/testing/selftests/mm/split_huge_page_test.c
>  F:	tools/testing/selftests/mm/transhuge-stress.c
>
> --
> 2.54.0
>

--
Cheers, Lorenzo

