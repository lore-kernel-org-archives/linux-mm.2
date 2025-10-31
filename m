Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1791CCCF9FE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 23:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B76A8E0097; Fri, 31 Oct 2025 19:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369048E0068; Fri, 31 Oct 2025 19:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E6D8E0097; Fri, 31 Oct 2025 19:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 137AF8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:36:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B763813AC06
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 23:36:15 +0000 (UTC)
X-FDA: 84060020310.07.8254865
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id B733340010
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 23:36:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OZBLFpp0;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761953773;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Eq4jvviKUAzs1+1SoozEwcB6MMHVfZDN8rnqvceNns=;
	b=x9uFWCtktGn0wQWLR8KXXvFbJO8kO0BoCxB/UwwCaS6DNyvKyUbtlTVa7PGPJe+k8ApOQT
	h+KHbfAb3w474+dSMXCWd5VLfWaW2yeYLh19/2SsOlAhOxZ1VhOKpydokCe+I+WaY9GN1d
	prTRACv5IdUbSyD0Pq0+0FXWtcysqSk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OZBLFpp0;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761953773; a=rsa-sha256;
	cv=none;
	b=T2NccbLa8unJliXvXvG1v5qsdfAgugwbdFZ9UVEgWf5IZzo7hxT0a3spYM9r+dv99dx7MD
	y3Cl7nCRu1AJw+bRD9k/aXk4GWTecUbmaJu+Wk1D1RUkZ8hHpfMASFP99jaOk2BwzET3L6
	Gn2NTtjBQI43LOFYjvWy5xtKYgwpyZM=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63c3d913b3bso5184691a12.2
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761953772; x=1762558572; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Eq4jvviKUAzs1+1SoozEwcB6MMHVfZDN8rnqvceNns=;
        b=OZBLFpp0uCYDniCUv32mbI2Mxnc4OSmSzHBx+uq8bEq8Il4F6I10u+1FVvP+uOBtiC
         uEZP1am4+eR5Qgm8UCzWdozSl13slRnFFSQOvep67tv5MD7w9ZZviI1qkr8RENmdJkqI
         D/s0vKGrr75K8Q4wa4Q14bwIi5ZPxMGm1GHA/Gzrikc1Ri6ZYVLebi3h/GV0d7myyz1b
         gd99msx+BduPU3uFpm77lhfQmYYEzLPKalJtdKRa3LUlk2SjmdCdUmcGfjilrZkeWrO/
         jy1hcXJHbtPWoPCqwONZHcC87ZrO9mIRPawLtTIy8eZTzC5n4QE6qexVgY48s0j6jLBT
         wPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761953772; x=1762558572;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4Eq4jvviKUAzs1+1SoozEwcB6MMHVfZDN8rnqvceNns=;
        b=ulyg254Xos0lGMEINeJrSkq0aQqVrRhKMM3bcU3x7zTa0keVY+wqVTt7M7xaYI4ZSZ
         KwrfvLumVSDiI7WiTydxeblcJYPUBzh8UQESPajlkr/1SqRqB2Qiy6+nhalNjB3HdKX2
         n/FxhTKjHSdZb2YdvHJfbb8J0Iy6tTeVGajU9iMU8sZaa7JXX4KmaP0KX8YZQxgf4hx4
         0JQ3T8qv6dGBwsO/shEUSR+aBC6OahAOLMIVOxUrqq1ofQcLWoRQEN8B1i3uGAYE1bu1
         JzQrTvfxj6VrgQ+t0F2P/QMTuSleyIG9KJiyGbRvgpgywLyfQ9GmUP8GmOwM7UlekeLa
         BuRg==
X-Forwarded-Encrypted: i=1; AJvYcCUi5TycF7NY3vFu+yhHqLXwTG6S22O1TOOiQSxL2fE5okEcJbV8i7Cd5D+P4UYiJAHQWo6nouUBjA==@kvack.org
X-Gm-Message-State: AOJu0YykwGD7gkCc1c6WhLoANiJR3zgDA2JYbQ4PmEwRHD+r+A/dElK9
	57tQvyVRc7n5xBYbQjE4kcDygQYGh7boDZ1CfYZwsC6EG9gbzcupPG+3
X-Gm-Gg: ASbGnct4jfMVqpyLqtOZv7mD/QwhLR+rhxHO+IjuO+4KRspYFA6uh4YMOpWD7HFbqbk
	Co52C39fDs7IuZEW2qFU5A/j6xvafvMpcRkP/IJ5UpJ/nEJhxubVrp0IVlSy+IjmGvA1O1SkN/r
	EXezzmk6EjjHI9oOY5aRDrmLZsCv9xfXY29dcoilu1KU2WpcgklViRHJ0re7YcXQ4Zril2ybT41
	/BOiPK6OV1+1U+DfsKMCX4B8upU7RjxzjeDIwBNY/geK6KjkCbhDo8NFesDlPRsqMIzcjiRbggK
	4NuUDgd2BP00LiBXX/bmEPcLfPp3uWnd2HR7KolNDVIFAU6FF2n/7AMQZrbbwuX4M61RUyXQXTv
	wlzJnq9dHkRU47A2ySW8ymes8ETI6iMbvE2HWH6HRmvLYg8AEhZUNvwLGfXHlregBVd7ziBNyaF
	7PFa1R7I9LVw==
X-Google-Smtp-Source: AGHT+IE9oiA7ZS+LrMufBrhbfjlMC2OP7kCQdowNH5Jt1ngMTD0p89JzaMQE80nXkCPgIOmTZL/sqg==
X-Received: by 2002:a05:6402:510c:b0:63c:334c:fbc8 with SMTP id 4fb4d7f45d1cf-6407701851bmr4563108a12.17.1761953771822;
        Fri, 31 Oct 2025 16:36:11 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6409012a6a2sm1126819a12.23.2025.10.31.16.36.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 Oct 2025 16:36:10 -0700 (PDT)
Date: Fri, 31 Oct 2025 23:36:10 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
	kernel@pankajraghav.com, akpm@linux-foundation.org,
	mcgrof@kernel.org, nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <shy828301@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 3/3] mm/huge_memory: fix kernel-doc comments for
 folio_split() and related.
Message-ID: <20251031233610.ftpqyeosb4cedwtp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251031162001.670503-1-ziy@nvidia.com>
 <20251031162001.670503-4-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031162001.670503-4-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 9az1mr76j7sqhwq5rwqeey3pj3rk658n
X-Rspamd-Queue-Id: B733340010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761953773-177332
X-HE-Meta: U2FsdGVkX19gAnBEIKH+tJufYtSWlHCJ+C8FNAO0/aybcDLgRbS6UKldXP0IHcSiksR7QtRLDZMDDjOp3vw81aDnpsL2Fr3b92thGGIE3B53lllFfhW1r+a/T2A9ngrSVeoK7IJb8XzGafgdBCulYncdvefjbTaqGH5BkXWwzUuKD5zmdpWF9CKyeYGBxC9Wc6fCI74hKkLcml1isj9gxFRm8GiWXoQocSUHmBn7mhTjSlD4uqQY5fPJtXVpWnbdnVjSV113H2N+HTapzpHEH9MHrMIAHj2Fzw15HiZZu0AUc6iosVYEr+4eMK1NfuQEk/BKI482fzNgEkvU6GueAbabXbXr5UC1w1anUode+TAnQDwC2YucL6cIyBijv6r2YGCtz1gt+nGeAEhTM6gOgDzah85OYZ7xYBSDtRmSvtZEgHBn9baadBNgyPJ1pIceOFfvdMfns6Hn/DroWmGrDM0y4gkuNIYAtzgTdrPtONs85GHPUT+gnuBNmz6L/fyx0cgyCp9TbxVhlxUkgE+6H0tU/JNvw3biUpo+zP24oFSU2ufzu4nyDSNLP7DlEHBDiC5gAkhI3j6pVUwEf8iA7XQEwXVIHpPCivrt2BgONJ3LSeHeqZ2EhPhUhS2qPi1MflamamI+R5A79QC0n44p1NboeXL0cPCVUfEnNZcJCOtbpJNcqIcH4dhuqF2EPPxIBfv3KPxk7ad7TYHV7mhUZu2C1q2BeyXtx5z6+wJjdRWAsj7KtFsJK1Z73/CTDEjEHc9z+9wvKgevCHwAfh8DL1KFm+z/kTk20Z8VHeENqrC0KU85qRRibJIA12tSvuNuoxEzsOyOBTJrg3oOWN1ThxiyW3zNhuAFSgCC4N+b21WSLxdx7ViGyanIpZtIfLt7ZeSlWlmx2UTgtSOz+qvazuyDhjBb/ShO7NMYUvdwYg1g1fqmzU9kXH7Hm34v2YLCE6yVLGrUoaMeYkvejBn
 quey44+M
 +PuBo+25uzTr+akaY8fyTcp6i6Y2j7Eq+yxVDuHto3KfcbnhbUpyVBtnlZcx74JbgBBrDXnAAprXeJe3NMJJhvN4DlhGBsemwFbuuqnMwxXZWiB0iEWmlt9RWxFSRh9VkhVgKJTfBBIlbGFrLS0U91+DZvF2woi36Bojf04qn8gz5BOOPL4cg5mLBWcphWh3Oh20kBifKqVUdJOAOHWOTgd+FO8qOPaaKxuxvn5dhnS9duCqf6uqrLw5/Y9ovMdVb+BI9g9j+5taIeIFOHjaieKR8PpnEL3MoUAxdh8cMn/p8OdoG3VsRLlnIkGtRbQGQUmWrbi5z4RseSDK7b9Q0zRPA4ItU2lAHNkHO1oQiAWU+oQJFsVDQdE3sZbsblAm/9w65gkFoITMRUChYzAkrrCL3ZtynRtzbZXzWNnBL/JDX8jB8owbmoLXvrx1tUtTpDxbq741l7IGOYV8ChkRo/epYNT/dh6LLVkfG8TR+VmIUNuhbxXIBVm6u0sm8832qk+BaBQuyhFACXRA2U3eQwyvzoHxD80bXH9rZllhFBvsUUi5Q7RfRLNdPkAHgmFaG2CXZzY4m7xP9LkAch/fTLlQ3Y041DjfFtFpxZVx+NsTLo6KIFkRfosabBdy8Av9xlLjGWi2RgnazBp/ZwOPtG6iDXscbF6vRu0gZSiuFdAEGV2gkrgDV16eMCrP8slppZiZZa1X26iTH0BTcSph3YDXotw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 12:20:01PM -0400, Zi Yan wrote:
[...]
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 0e24bb7e90d0..ad2fc52651a6 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3567,8 +3567,9 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
> 		ClearPageCompound(&folio->page);
> }
> 
>-/*
>- * It splits an unmapped @folio to lower order smaller folios in two ways.
>+/**
>+ * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
>+ * two ways: uniform split or non-uniform split.
>  * @folio: the to-be-split folio
>  * @new_order: the smallest order of the after split folios (since buddy
>  *             allocator like split generates folios with orders from @folio's
>@@ -3589,22 +3590,22 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  *    uniform_split is false.
>  *
>  * The high level flow for these two methods are:
>- * 1. uniform split: a single __split_folio_to_order() is called to split the
>- *    @folio into @new_order, then we traverse all the resulting folios one by
>- *    one in PFN ascending order and perform stats, unfreeze, adding to list,
>- *    and file mapping index operations.
>- * 2. non-uniform split: in general, folio_order - @new_order calls to
>- *    __split_folio_to_order() are made in a for loop to split the @folio
>- *    to one lower order at a time. The resulting small folios are processed
>- *    like what is done during the traversal in 1, except the one containing
>- *    @page, which is split in next for loop.
>+ * 1. uniform split: @xas is split with no expectation of failure and a single
>+ *    __split_folio_to_order() is called to split the @folio into @new_order
>+ *    along with stats update.
>+ * 2. non-uniform split: folio_order - @new_order calls to
>+ *    __split_folio_to_order() are expected to be made in a for loop to split
>+ *    the @folio to one lower order at a time. The folio containing @page is

Hope it is not annoying.

The parameter's name is @split_at, maybe we misuse it?

s/containing @page/containing @split_at/

>+ *    split in each iteration. @xas is split into half in each iteration and
>+ *    can fail. A failed @xas split leaves split folios as is without merging
>+ *    them back.
>  *
>  * After splitting, the caller's folio reference will be transferred to the
>  * folio containing @page. The caller needs to unlock and/or free after-split

The same above.

And probably there is another one in above this comment(not shown here).

>  * folios if necessary.
>  *
>- * For !uniform_split, when -ENOMEM is returned, the original folio might be
>- * split. The caller needs to check the input folio.
>+ * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
>+ * split but not to @new_order, the caller needs to check)
>  */
> static int __split_unmapped_folio(struct folio *folio, int new_order,
> 		struct page *split_at, struct xa_state *xas,

-- 
Wei Yang
Help you, Help me

