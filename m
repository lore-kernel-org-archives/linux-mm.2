Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC02CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 23:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30308E0006; Wed, 27 Aug 2025 19:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07768E0001; Wed, 27 Aug 2025 19:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D458E0006; Wed, 27 Aug 2025 19:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1A068E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:53:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49B24B7FA0
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:53:13 +0000 (UTC)
X-FDA: 83824191066.15.2CBDFF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A2DB2140008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:53:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V+4gzN75;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756338791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeevWolyHIBNZuYTU9HxK3D6A38Q6eiO4+hDuqDUo4c=;
	b=witSgHT7Ew3wucqmY664Dcjv18qAU2RpwYz0k1to3fMzAxsd4gUn2EK9PhpMJUzw5l14WQ
	O0tyrb656tyvTW0EwL5xtSJ8WtbSsME9mI9J+h2ObqIqrifjZYb+0dXSje+/b14XeDDoJH
	LHL0xxsvKPz9I73g5q0a0lGoCZFPM+I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V+4gzN75;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756338791; a=rsa-sha256;
	cv=none;
	b=H0IqktEy4j1WsGFw3itaEAtdl6SnQISDdl44FvQmrw7Z173r46khRfn5mnND3nuFJ6dHDK
	wlnwEWB8rzY0bzVWeiy4tOdeG8JIvmPsxZGMuFzQgAS9d98jTi9hYur5yqGonYF2o0MU1L
	jaVw4nIn7chjpto0dbFZqQBCSJnAekg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF39F60233;
	Wed, 27 Aug 2025 23:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7974C4CEEB;
	Wed, 27 Aug 2025 23:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756338790;
	bh=OiOLYJb2Zd5nJ4kFjVVVoam9t8cIRUYfLzwKKyXHnpk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=V+4gzN75/R/uxO0d6n902wfPpwNcKXxYvim8iTOEcOW2FctPSVv/cknX5aKQ+oa2G
	 0J6K3m12nPnf/tiqge5xDMw6idP0rJmYpq9WZTpO+TGSObxliabGRS8NZBxN+oGfcq
	 +4X35cjB9q75g/V7gp7bz46O8+/xuYVX6oAPq2tE=
Date: Wed, 27 Aug 2025 16:53:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] huge_mm.h: disallow is_huge_zero_folio(NULL)
Message-Id: <20250827165309.44e465ff214e45f1a6665b24@linux-foundation.org>
In-Reply-To: <20250827150330.280399-1-max.kellermann@ionos.com>
References: <2aa3f478-9c87-4102-b83e-bf235372d834@redhat.com>
	<20250827150330.280399-1-max.kellermann@ionos.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A2DB2140008
X-Rspam-User: 
X-Stat-Signature: 367opz9kbjnkn3scs9umdzkopqmt38wo
X-Rspamd-Server: rspam09
X-HE-Tag: 1756338791-202737
X-HE-Meta: U2FsdGVkX19izdariTs3uPndP3YiiobWXYaNYADAVyCYGQzrVpVW3gh71IkC7BNp8TzkecQpmxOQBJxBLELmNB8wjhvHYqWGWVEm4v+8mah+5rU8X3tBaFOy/B9IHCOA0l+ScszwFHkO8k8iyTUvh0sRWZfY5K3xebyyX/5JDZlKHdfcbsqD487jVXOd1XWfqC1zZAdImw6kQuBGIg+8BjmdxnbdaLwh6ihxvv2FDy2jvugHtcfaZy3Fz4ckAoU4WherjuEpKvDYa0dpXEStOpCXaCfKgBQmprfQZ/CE4yAk1WUeLfO2bItW/AfTVfd9ZfhyIIOs6gWZqdWV8hEw/xNwP6+4dY3rq+EjT6xHuP2luKZ8dZsuasOMkJtcLBpb4SiTdxPeprXzk/5TTbHCvzyZYrel5MiV5hhPqvkSHHNcSGU9NrTyXMAsYo0VGjt97pSI5cAuZe30L+9+0dkirYUdwKiiJmj0fwuXZiQAO/j4cJ6uhSxP+MP8WidjSSSYo0ZuCbYIvJ0F2n3aB3CTfo3/wSPOHycnH02S7BDDqCvI4I37DRTwk2s1pavbdbuqWiO09swhhqu75lY6hsisVAnt2HpYO7BVmGo0e4RoJE7VJejagp+EsutGKkekRyIXc05fUuosonG8A9edqo+Fii4SwryHDeWTs20s7qC+JufCZoBLyGke915ndEKSR+q4tse2bKhog4iZD8sBWWYxbezZ50OR1M210IlZuiajSsQxKHQrFVC+QxR0m/fSvV2TgfQYBR1ZxpT5qUMd7MkCC9PS11/MB03uEJOHG6t5YK0srU+ma5yNV8Q9U7HCOEBye7vR2NoZhHfXmzo+DBAX1+xsVRppet9MU1jISgqgo/7tlcP9gg/igBa60VjUKSH7I1xzuzaFUkIJhyYtgwqw4QoTz1Gk9oERz5q5WtRbfi0ySJvNLl1inMeQKoZcUBAo4TOvBwu2/FWcrd6a3FK
 UOFthAzJ
 cRiyWotnwq4pSAw0QCoR3pjwA/g4DsIkDROFLLxgMjr2T3X3FBbMrXypG2J2fpDbDPJSP45NkA31mXdhwO0hd3Ie+lW7kQMU7SSMnsE50JAtq85o/CgF0m2hECm5XbJnKJwg62FBy43LeUGR3JIZC6Y0t5NBVv8GYT5LAQiercQYDknG28weohNPeug+crz5WDgKGfuGuNqTneFnzq7nkdcACNPwHUhepkUWwt7FWzn3qZAErDlb80mNGOFCgIdJTDLz+LZVUfJHlS0SZoUqjjTIxB1sss+O18Opd1VcNz5pcw/X0oD0E3EvoiHDFMNWWiLzmFT//2ka8Xm/+1j/swtdDyxoe8yBHbfL91Wqy2FlrC8OAL45cd5/zUUOB8if9kb03TnMSNry3clSAaEUHOYRMlJZRwuDkoRBrugVraChBW/4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 17:03:30 +0200 Max Kellermann <max.kellermann@ionos.com> wrote:

> Calling is_huge_zero_folio(NULL) should not be legal - it makes no
> sense, and a different (theoretical) implementation may dereference
> the pointer.  But currently, lacking any explicit documentation, this
> call is possible.
> 
> But if somebody really passes NULL, the function should not return
> true - this isn't the huge zero folio after all!  However, if the
> `huge_zero_folio` hasn't been allocated yet, it's NULL, and
> is_huge_zero_folio(NULL) just happens to return true, which is a lie.
> 
> This weird side effect prevented me from reproducing a kernel crash
> that occurred when the elements of a folio_batch were NULL - since
> folios_put_refs() skips huge zero folios, this sometimes causes a
> crash, but sometimes does not.  For debugging, it is better to reveal
> such bugs reliably and not hide them behind random preconditions like
> "has the huge zero folio already been created?"
> 
> To improve detection of such bugs, David Hildenbrand suggested adding
> a VM_WARN_ON_ONCE().
>
> ...
>
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -2,6 +2,7 @@
>  #ifndef _LINUX_HUGE_MM_H
>  #define _LINUX_HUGE_MM_H
>  
> +#include <linux/mmdebug.h> // for VM_WARN_ON_ONCE()
>  #include <linux/mm_types.h>
>  
>  #include <linux/fs.h> /* only for vma_is_dax() */
> @@ -479,6 +480,8 @@ extern unsigned long huge_zero_pfn;
>  
>  static inline bool is_huge_zero_folio(const struct folio *folio)
>  {
> +	VM_WARN_ON_ONCE(folio == NULL);
> +
>  	return READ_ONCE(huge_zero_folio) == folio;
>  }

OK, but it remains the case that we have seen code which calls
is_huge_zero_folio() prior to the initialization of huge_zero_folio.

Is this a bug?  I think so.  Should we be checking for recurrences of
this bug?


Also, sigh.  I do dislike seeing VM_WARN_ON_ONCE() in an inline
function - heaven knows how much bloat that adds.  Defconfig
mm/huge_memory.o (which has three calls) grows by 80 bytes so I guess
that's livable with.

