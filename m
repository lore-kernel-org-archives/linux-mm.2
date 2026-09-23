Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A86EC98307
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776496B0088; Wed, 23 Sep 2026 06:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7278B6B008A; Wed, 23 Sep 2026 06:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63CC66B008C; Wed, 23 Sep 2026 06:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 455016B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:55:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B320914073D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:54:59 +0000 (UTC)
X-FDA: 85244719518.13.379FD68
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id F1F5E140003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:54:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rs5p7XvF;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790160898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HsAx4SnQNnifpqt+gsKp8m+X/PyTqK51tRJcr1wuFo=;
	b=VOUCd7ROYeyneGrDXbsGnJ4Xta0O6/40Wkjc/b80F4DDmOx6Wp0HGVKSBQGrOJMamYFsjz
	QynNgswyoxETypRAVxc3g6ashW0VaEWEiIuD3u//7G4cquy81qgC85kM0jNWAddtK/LmV+
	UCN2DesP60mvMzawK0MZIuUeDzaN+cY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790160898;
	b=GbLwQ0hKn2x2kScyh+OOA4JLEeTSO8cY1Aom9as+KaGCbUA9l8RLNS/LyMeWynEJnObDtZ
	IhaIrN6b3JHZi/ZWjaN9jN9HQdGPhL2Smx8okjHGowqscCd402kalLP7i60AAsqjzS3PuY
	bKLMzzeTTo4894amneqVFPYLDp9WjQA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rs5p7XvF;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F41D143D;
	Wed, 23 Sep 2026 03:54:53 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 81FC73F86C;
	Wed, 23 Sep 2026 03:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790160897; bh=BpeVTxo8pLgcSW2YiS7/ckITm/ybEWASP4RjJ0ASVmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rs5p7XvF0Ft9Yi/Fzm0XXqA8PO/mRcv3yu9ouhDSO04aqTZP1c24oOzVwgTG084jT
	 W1TCTnDKzI8Sfnm8WWWg2tqspjmLG+ZY/T26c8B7xF/1xISdWOmkvC8nX46uLjhB8C
	 vZIKo6RWhnv/8GyzOFnVvMpThvouKE48FnMRJpLo=
Date: Wed, 23 Sep 2026 11:54:52 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v2 2/2] kselftest: mm: fix intermittent failure
 khugepaged test
Message-ID: <arOv_EFOPg0HwBk5@e129823.arm.com>
References: <20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com>
 <20260921-fix_khugepagd_fail-v2-2-3c2877beef61@arm.com>
 <6cc12fe6-4f2f-47b6-b821-8a507eb80b46@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cc12fe6-4f2f-47b6-b821-8a507eb80b46@linux.alibaba.com>
X-Rspam-User: 
X-Stat-Signature: xsgeit9ogmk3gxib5piq1yb6hwko4kfj
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F1F5E140003
X-HE-Tag: 1790160897-301577
X-HE-Meta: U2FsdGVkX1/OKfUEj71XVoUvfPRBkWJXzu3Pn3b5WVDkuo2XdV5+U+7g5JPeZ5jnH72TgpUoMEtpPeuto6BD74CjmyFGNaQH/LYnlflSLpK2PYtG0kAo3ghBvxlJEuA7Rj9Z9jWCeTvg5h7yV4yod5nX/IYB4gFq9ANQrbV5TXjejHZ0Nvr3g/LquV6LqKVRdSKnlYoR+Pu2O3OtmpRlvJW/0SyB+8G3aTu3heuA4n3xoFus0Ur6zn9ge9hd7Ywy9s/326ZZ9EiwSZ3NZQlDnTpsdOSTew14heGXcNQC3ybEK5mS8qQEemvR6ZP0PXAKcpq0VMzXGsA3Mv6/m5VzbVZMPQ01hcHsACgOoEVs7tbACRkBP5ySmaaaojtnPiar+jmmWmG+yA8cVjQovaSq0GOKEvS+yTH2GxfYw2VQCrzEzAT/Sw0ssc65i0YWY94CMHDZGUPVRGcQjR1A+1Kt1El6wY7cLdYl7M3LPUu+R0hc70NceZuu71iiFN70BEt20gXnaXPO1+Q9eLA1fH2xBSXOOEBFnynRiKiSgkaykkP+C9jpZyYS3ZAPceG4EAanIPkmltX/FZ3mvpSBOCHuDSfYQAByecoIVhjKlOtEnQbscPdZhDtrRYwtB817Zxbm5Fm6Zg5LiAKLl42HrRe8gL5WdH8uNnz42rKrOB7i6Ra2OdOn/v1/aTcQV4DFGGSnfwfYenKgF7s5VVtr4rB+Cy1I62LBj8OTHtrVrWwJKEjs+NF/vNtBPpLWhHuvqyyT8d0ap5wvafMDY0VJkjdGJZ2REnRjdnf1PxG+FioEL/iWbYFt0i9f4lTDbxQJTPDJK/HbvMUvogfwaMuXZuJr7sofrACwM8hjMPDwYS4OVZGR5orxvJa0kSYVnCnzLUcwwQUZerOgVywIF7c8lAaE3lJX/fzg+mwRUk5Ej+kZ3zexpefTGzjDqLR4lj6vh25nwldnc0iZMgmsX0pkAc+
 EwTKGFVS
 CQCEFLAyLK3crfmwYYrbJlIUrW2C/8+xvdl1qmDMEpibhJrEzuJdyhOxSalLW8CRdu11w74SLCrUYLOfcrQWVTBkZ1ko62+5f+5M4O94JgAeLnLn/PwBmGC+HGnsRNtQGWnNepctiqh+XnbcYPih9YEwFf5IzQFhiOPvCoZui0IWIVZt3Pf9OlACJ1+99o6alavBpfBO1btW2GdsVg7na1zuRqbt45VsQdYaySvFffmYBTK6ufbHS9eVYpVMI2RwlkDEsgeRqleLfXikO90Di5SZQCeYicg3B5nBS0pCK6Kw+ZnkESqUdNZeJ9yQqNX8cSbrj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> 
> On 9/21/26 6:35 PM, Yeoreum Yun wrote:
> > There are intermittent failures in collapse_max_ptes_swap() and
> > collapse_max_ptes_shared() when using the khugepaged_context:
> > 
> >    // while running ./khugepaged -s 2
> > 
> >    # Run test: collapse_max_ptes_shared (khugepaged:anon)
> >    # Allocate huge page... OK
> >    # Share huge page over fork()... OK
> >    # Trigger CoW on page 1023 of 2048... OK
> >    # Maybe collapse with max_ptes_shared exceeded.... OK
> >    # Trigger CoW on page 1024 of 2048... Fail
> >    Bail out! Unexpected huge page
> >    # Planned tests != run tests (26 != 23)
> >    # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
> > 
> >    # Run test: collapse_max_ptes_swap (khugepaged:anon)
> >    # Swapout 257 of 2048 pages... OK
> >    # Maybe collapse with max_ptes_swap exceeded.... OK
> >    # Swapout 256 of 2048 pages... OK
> >    Bail out! Unexpected huge page
> >    # Planned tests != run tests (26 != 17)
> >    # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
> > 
> > This happens because khugepaged may collapse the pages before wait_for_scan()
> > is called, causing a sanity check that expects uncollapsed pages to fail.
> > 
> > For example, in collapse_max_ptes_swap(), after faulting the pages back in
> > and paging out up to max_ptes_swap pages, khugepaged may collapse them again
> > before c->collapse() is called.
> > 
> > To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
> > collapsed by wait_for_scan() for anon. This prevents khugepaged from
> > collapsing it again before c->collapse() is called.
> > 
> > This failure was observed on NVIDIA Spark with 16KB page.
> > 
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >   tools/testing/selftests/mm/khugepaged.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> > index c32244b565658..1aad4bb427ece 100644
> > --- a/tools/testing/selftests/mm/khugepaged.c
> > +++ b/tools/testing/selftests/mm/khugepaged.c
> > @@ -578,6 +578,9 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
> >   		usleep(TICK);
> >   	}
> > +	if (!strncmp(ops->name, "anon", 4))
> 
> We usually use the 'if (ops == &__anon_ops)' check in this file to identify
> anonymous test cases.
> 
> With that, LGTM.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

I think this is merged at mm/mm-unstable already So, I'll send
another patch to change it with is_anon().

Thanks!

-- 
Sincerely,
Yeoreum Yun

