Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56305F436BF
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 05:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68D276B0193; Sat, 18 Apr 2026 01:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6174C6B0194; Sat, 18 Apr 2026 01:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DEB26B0195; Sat, 18 Apr 2026 01:04:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3861D6B0193
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:04:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFE9B1B769C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 05:04:44 +0000 (UTC)
X-FDA: 84670486488.16.5C1EA11
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id AC209180005
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 05:04:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DoM7XdLh;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776488683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXPL1oY4ZjCE0WWtEdPPz6N7I9mzftnuX51EgaElACA=;
	b=Z2+FzPZO6InVFqj2Mx8g4Z5X39lwq4jGkPqO9Ctlt1Lg3j6RL9Z7pNW0ZiyKS649V6AUA4
	dcZz5TvcSHF/zSV8sgdPjiIPIPhlbhY7/bSeMLqPMjRTeohW9TZE1zpIicSTwyHjsFvTyn
	4QeEt3+Gdjs+lklCUxieen86b2yyT3o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776488683; a=rsa-sha256;
	cv=none;
	b=KZfvbYVHtCBkaCGbTh3BBGKVtJm4jegjJCh2tYGImY/i7KLBvQmp1T+BsOovf8cStaaLjT
	wJSjDYYk8z+r3V+MFFEpbZSYyguR1+tcsVPkqPhprLZfIkgD9HuhydwLtOxy+Pw0sT+isv
	vdCysvbYmx0SZMsnDvw+wpJVLcSsVsM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DoM7XdLh;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gXPL1oY4ZjCE0WWtEdPPz6N7I9mzftnuX51EgaElACA=; b=DoM7XdLhtZYC5qSA4Cp/MzhWAg
	pEIllgUcmdv5SXB1MIM7eWxfrd5O1GYf37vRCkxMxGBP/+gDP/JoFBgGwPynbyEClCqeIFtD7OvQs
	mEjPmSAv9laDPg3OGWwKRa/SkfyZ9rgZpDUraNUTGna56eTcqTbD/UL4q8XfL0hbWVi0P4IRtUqsg
	cv6/rSpBcRrpkdsppPnLDCr3f/AobljlB5hT4og1lq95+yuvFce+NtLpl9O6o7U8ZaV1VpSXfSaYH
	FkHlNUJ+F3X3ggIzyYn0puaSa2H8lxP2E0nAdVmovb+uVBGhO6+vIIQ8Oc0pnoFLwYOwZV9qm7BUb
	uMDoGrww==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDxr5-00000004zL8-2q3y;
	Sat, 18 Apr 2026 05:04:31 +0000
Date: Sat, 18 Apr 2026 06:04:31 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Nick Huang <sef1548@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab
 documentation
Message-ID: <aeMQ36jFnCKmCSyA@casper.infradead.org>
References: <20260418000635.17499-1-sef1548@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418000635.17499-1-sef1548@gmail.com>
X-Rspamd-Queue-Id: AC209180005
X-Rspamd-Server: rspam07
X-Stat-Signature: 4zsjiqwwxbk5ucwhke3zisgeiqtpjfjt
X-Rspam-User: 
X-HE-Tag: 1776488682-295473
X-HE-Meta: U2FsdGVkX19iw7bCNSG+K3jyL3ukO4HCwJoqX2J0kdgW3qbTBWol4Dq8r+ky4gE+5nDkXi1MnGsonarRs1ePhYFFplWxFsQVkNQlA7nFU/LrEC6Mz8tqTD1YQc8Dp9gqSu8TpcN0qQuXb8UNurTt7S1oHplvG8tEcJwv+yc4QROAE9Zn2elHSfCuzXf4lCS9qRircm4ZISnGmj3DQQFwcALG5wW6CtBOMcn6zoGHPlDHVyTpxTGc3rlzsaXMNJE+P+tWBIpYbay997i4uZ2Dv83bAaSZmIdW4j5EUdSBUfg6nzhzH/vDM1FEdWV2c/yjKV4I1D5z4fAxNaj1dOtFqNaf6y5EZ3bJHi0jxqa239noefIbZrD42DWbt7OTszHCLzspZjpibuzGA7U2EERZB2fFyGIMGNzA9i3+eScjgVeGZiL7BqX2YvHQZbfIN1UrYEROtfN4x770L95ajXQmROIZ09hqLFOzhQReCYzD7BpLQU099ojU1iDwyVNNIqdo7ze/7fzHajyaDNKeKtB1CbVAjDO28qiZKQxefOBzYNSNdgE3eF41eQvx1KU5Bp8fqF7GTy1vWF5s4sYMVgTlAJNJfpOydhyPeX0DoCXDwCydbSzNeg9pqjf7YEkvMWcuIxMMsXM8F2y4hDXIdiuffMfmdLqWdJ5Cj9WHrrk6DoJ6VSAS+CnvUee8BadbGH6OnUPVqiqzfxBgLkTPWqt2iX2e1Qh63VA/yof8LhyIvjghwKd2I9i+80r0lZ1BrVbgz2IiByOc+1UyY884loI84qlOI6IaFjIcgngBq1lnbxZXHTtA8vU/fjg2SRzgV8pXHCb7CR8Tl/qvEes5D6Cm2KHbPaC9GVRqJi/uYJf8noLneM7qg0BEg/L3fgxUOFmxI5lfoPOtys3qFt58vnBfafd4xeRcLQogMLsnURZGZrqBFRN8c2guH8osfRJ3GZW/6/Q99JSfevAQ1hfExb1
 MioD+ueg
 99Q20aWc1NxHEuGpAtEcCMUoyy28L1dYRZwOysooVPjisLjs1xw8CCwsetJ+4gjyRaB5GcipkjQnuwbkK4Xsn3FhJ6UqMELOmsVc7Tp85G7WCoJAz3ErjgxouNgsx+SmDSkvVRmZAQ1qrS8GAM0qrLWOBEm0wZ3dDueDeNsoDJd6pSHgrmS/Iw/FMYJ0L9x3vMX0YiZhf4itj1RatyMAxDZ0Sa/4RDKSlWBrPrp4GncWeZfC6FtHxkCqUWguVypANE2X8IFwnB7UkNnNIkJiAcMkDYhxmkwU2PvuAfQ0G+Hi18/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
> - Add "Overview" section explaining the slab allocator's role and purpose
> - Document the three main slab allocator implementations (SLAB, SLUB, SLOB)

Umm.

commit 6630e950d532
Author: Vlastimil Babka <vbabka@kernel.org>
Date:   Tue Feb 28 15:38:07 2023 +0100

    mm/slob: remove slob.c

commit 16a1d968358a
Author: Vlastimil Babka <vbabka@kernel.org>
Date:   Mon Oct 2 20:43:43 2023 +0200

    mm/slab: remove mm/slab.c and slab_def.h

Care to revise?

> - Highlight SLUB as the default allocator on modern systems
> - Add "SLUB Allocator" subsection with detailed information:
> - Explain SLUB's design goals and advantages over legacy SLAB
> - Document its focus on simplification and performance
> - Note support for both uniprocessor and SMP systems
> 
> Signed-off-by: Nick Huang <sef1548@gmail.com>
> ---
>  Documentation/mm/slab.rst | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/Documentation/mm/slab.rst b/Documentation/mm/slab.rst
> index 2bcc58ada302..2d1d093afb7b 100644
> --- a/Documentation/mm/slab.rst
> +++ b/Documentation/mm/slab.rst
> @@ -4,6 +4,32 @@
>  Slab Allocation
>  ===============
>  
> +Overview
> +========
> +
> +The slab allocator is responsible for efficient allocation and reuse of
> +small kernel objects. It reduces internal fragmentation and improves
> +performance by caching frequently used objects.
> +
> +The Linux kernel provides multiple slab allocator implementations,
> +including SLAB, SLUB, and SLOB. Among these, SLUB is the default
> +allocator on most modern systems.
> +
> +SLUB Allocator
> +==============
> +
> +Overview
> +--------
> +
> +SLUB is a slab allocator designed to replace the legacy SLAB allocator
> +(mm/slab.c). It addresses the complexity, scalability limitations, and
> +memory overhead of the SLAB implementation.
> +
> +The primary goal of SLUB is to simplify slab allocation while improving
> +performance on both uniprocessor (UP) and symmetric multiprocessing (SMP)
> +systems.
> +
> +
>  Functions and structures
>  ========================
>  
> -- 
> 2.43.0
> 
> 

