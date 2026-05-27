Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFF8CCD6E45
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 16:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00CF26B00B4; Wed, 27 May 2026 12:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF706B00B6; Wed, 27 May 2026 12:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7D66B00B8; Wed, 27 May 2026 12:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C89BC6B00B4
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:10:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AD3B90B2F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:10:54 +0000 (UTC)
X-FDA: 84813688428.04.341385A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id DB19218000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:10:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MPuOzV3i;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779898252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CX3exghaEU7oijl4Qm+XajRGZGjWFznqdUxi59T5X4w=;
	b=ilNTRKpn7RiS0Uiy+Y/4QZF5m6hhEJHoBrWWzkwo2TOHfZ59jb5p1OPthiImorwdMlIMwh
	5sALDIXjcmMllbn1C57gbwu9VHCauCyiV9f38x9+5c0HYkbLNRGjhXO+62fh8d2PBmhPdH
	zVM1H68r3/jRtUzGgZZCGxYwtAn5nLA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MPuOzV3i;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779898252; a=rsa-sha256;
	cv=none;
	b=IM3OA1ChRlZIpyPqMgmYeNwdOu5/jxLJrnLf8aP4gTflT6nvhBksqUKeua5LV5+lLtaLYD
	fr2er1gjYbZALxvKkft3irj6TW7R8liOBD4V7CA9ey1AY72lKZ2gyv9WTkTMS6SC8ExgJF
	c8JLYu8ZjuaNnIvkwVG1cw6zWd+eehQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9FDB4168F;
	Wed, 27 May 2026 16:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D101F000E9;
	Wed, 27 May 2026 16:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779898251;
	bh=CX3exghaEU7oijl4Qm+XajRGZGjWFznqdUxi59T5X4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MPuOzV3ikmn3ser1vdTu0I7pRDht3seabVH7Hg/9v9USEHiof8yUdQnShFjScSoTb
	 wdlaE+ErrX6xUpzLPhl9U+fXdVTfi0yRbZeC00fJS2ccPaDv0gMC5+6XhPblJ5PeS6
	 i+7lP7lyQ8xf17fO5n6Fk+MPMcTxWkgkfthrAyTYwzQja+or0O0RVqC2yaVkuPPHQS
	 3ScbA9+3q0nykiU5eDEWY+WnpI9zPngSRPNxobjR/zDfX+lBOmEpm4Xj/opPKsuM4s
	 sW5CviajEZlNQ2CHFGIvSbiwSzQdY5KFZ3qlNiC5BnbBRNa8LgJpKZGSN/u1OBCmAl
	 r7dqJXWThO+wg==
Date: Wed, 27 May 2026 17:10:43 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yin Tirui <yintirui@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Yang Shi <yang.shi@linux.alibaba.com>, 
	wangkefeng.wang@huawei.com, chenjun102@huawei.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: update file PMD counter before
 folio_put()
Message-ID: <ahcXZQCA0TsC1Qjc@lucifer>
References: <20260526101337.1984081-1-yintirui@huawei.com>
 <ahV8PuP2sg7fV_DR@lucifer>
 <58434ba7-78c8-44a5-8262-98fcaf131e6e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58434ba7-78c8-44a5-8262-98fcaf131e6e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DB19218000B
X-Stat-Signature: egc93k6jy3buasdppwh1muqqpfzmtwwi
X-HE-Tag: 1779898252-32910
X-HE-Meta: U2FsdGVkX1+3ScrVT6Eh+LiNv0go8Ma4ACFzgHJfGyIsPlz850rK2lyT5f6qvPFwEFWmxvZ095Uj4TwpzGuZOYjelyVcmj2+bDtXVZualbB+GZwAML36jtsexj9O4PWoZPLwgQuCCkWGhG9XJOgymmRkVKDhT7xXPJ3wU/wc5GLwkxKJVfOTCUWzBBaPPjboH04GPcfp+qPisPw8Z1Fgy9GUEncZiFXShee1aolq/QCs5fnSsISzlByqPEUt9+qKsySnMGStfMX9MV3FH9XCDNKGKJoMn7TIKjwkfr+jJ44bLkRnS8npkKHmFCPfYoLxOcsvgLLFGqxxeYsxZ8a1vn3cONzx90X/neypxD6pEOS+z2uwhAAghJjby/3acyLpCcLpALjNzmSUNPlQQLp0k4EZWVh9278upzGBYqwObBr8WEahBFBdkXIRbZg80kEaQnA568FxHW4Syt4aYFVKPHwgfAP12c+bORxDbb/A5L+tYjwHxaDOiBwQNrYOA3I1+CoKj/c7281P8gXGOasG7e0yc8s6Kw/jDNyI7HhRps/tmTXG41yfnNGOMBZ8djgLQzp/hh3ztBmZ4mRsmz406lKh5z9Lrj10tI/WrL0aoK2ApFKh79KWZv1AxPhUauv+I5531zs/H8KzCWoPW01h3q+u+KLORX3ih3dVTKVhTj0maxh9SHVMvqKYB1xMSN1p0IV2PQRoIL4mbPr7ClyOh6dCbSY5UbKfUXIkDLcrJ5iWzl6eBiuoLHFVPDFPZUwSslsjaPS5TlMlNlHXngvbJjTXp35bIc+n7fztFEFharcJVk0MJBYoDky5h1IsAL0m8vlsChQiKmDRl+If++YWW7jNOEL7z/0BwrTsjXc/3ncj2fYccL3eyvrOy2E6PHTsNd/TmfnyGp+aeOPLYVRw6LTpktsFRdQmz/O/vh8HqWk/gR/OtyF5qS99TcRHj8KwGI+wi7d12ObYKj2jZ5y
 IRSPgzuX
 kcUsqOuzHYhKBsD6UhQGTdH64bmSzan8lpZH9RSGZz2O6+jo8ibeHFtbAuyg+Ib51EWcyzDwYZS3dFbaeHKsmPEK9TwZp0cDOwpMJIfadh3bVteXtOHv/NMMo6oS8IIDcDfm3XJ43BL2ZvAkTGv5Hgk0xRQuRWq4DAMQGS3bdegFAe0FNOIRgjXbN+ATfFeAdbWHAklKyqCUO+0geUnuFAeWbtrAkIIWV57oAuGjwENYq/Gh05/jyIgfrd00Km2D311wCe2jKHiBzoTuVUUuH33RgtZXv6RJzrV1GPJMLgExhi+iilOErNHWigtjn/jnlS/MC2Sqpt6RlhkG6k6uFnKz49tgWTp7mrl2N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 02:25:35PM +0200, David Hildenbrand (Arm) wrote:
> On 5/26/26 13:05, Lorenzo Stoakes wrote:
> > On Tue, May 26, 2026 at 06:13:37PM +0800, Yin Tirui wrote:
> >> __split_huge_pmd_locked() updates the file/shmem RSS counter after
> >> dropping the PMD mapping's folio reference. If folio_put() drops the
> >> last reference, mm_counter_file() can later read freed folio state via
> >> folio_test_swapbacked().
> >>
> >> Move the counter update before folio_put().
> >>
> >> Fixes: fadae2953072 ("thp: use mm_file_counter to determine update which rss counter")
> >
> > That's an old commit :) I mean I suspect we're probably not actually ever
> > dropping the folio ref to 0 here since we never had a report since ~2018.
> >
> > The page cache keeping a reference I guess?
>
> I assume we could be racing with truncation.
>
> Truncation would have to trigger unmap itself before we do the
> folio_remove_rmap_pmd().
>
> While the race could happen in theory I think, I do assume this would be rather
> hard to trigger.

Yeah, I mean unless we missed it somehow it seems like any such race if it
exists is very tiny.

But obviously we really do need to fix this! :)

>
> >
> > But doesn't mean we shouldn't fix this on principal/there being some way
> > this could happen.
> >
> >> Cc: <stable@vger.kernel.org>
> >> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> >
> > LGTM, so:
> >
> > Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Acked-by: David Hildenbrand (arm) <david@kernel.org>
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

