Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC3AC606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=FrVDQJkA;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=PWsvFXSP
Received: by kanga.kvack.org (Postfix)
	id 77BD76B05B1; Mon, 26 Oct 2026 13:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7037D6B05B5; Mon, 26 Oct 2026 13:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D8D6B05B3; Mon, 26 Oct 2026 13:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7D76B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:39:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 908601A06BE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:39:39 +0000 (UTC)
X-FDA: 85365489678.02.F8ACA7A
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7046620005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:39:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="F rVDQJk";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=PWsvFXSP;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793036377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjwL+dOXl1G0XYM6+finyh9q+bDo7EQ0zXCdvP4sKUY=;
	b=MLTiEuFbkiwK7vDEJvboznE0LXywoyWSBmq/BsrFFT1nEOjI787UR+q/StLyCI3T3go6fO
	dQSFRtZ7kBCCjFH8MwynCAYsi9qKO3JBhHI5AQ9zzTcTD99Tkeqmv0nRUB7QKwyyGWtpME
	E3wODlGK5xweSLzLf8mqMZIFqTpglt4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793036377;
	b=rYKBI5J8o17jJJFYCDzhZhHKC82auUzh+d/6tAX4s/cl6eGXmUVNz/vqq6orFUjXdTfexc
	vTpS6jYgC14M35nkrTkTh5tk6R4rbBLSTD8zvSzuS63DS+bokMSLZvnrL0EAi7eb1FLKj+
	Gab/ygT4BI642FFcWvCm0o/ljN83YLg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="F rVDQJk";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=PWsvFXSP;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id E32661380206
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:39:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 26 Oct 2026 13:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793036376; x=
	1793043576; bh=OjwL+dOXl1G0XYM6+finyh9q+bDo7EQ0zXCdvP4sKUY=; b=F
	rVDQJkAnwkechcedtUGj+LlJKPVJxedWqltj8oi1vF61VyeKCt36pkyuCO99sxtk
	WZiGJ07h+f8//gF4HvxL4FWzL8Z6bvThxlk+lrnMDkNCUQZyXFj8d0Q3UdyTKt2l
	9iuMoTgmEnBwoxJmtJMsr6NwJ/CY0RV8i0i9rwBeUEET0NdcD1b6Az/Xa4IRiczx
	YHDkbydGvvTDHRvFuGm0EgYw//c2gwCHBbh3dRJRldyEP9ANvg82ix4frg+0lAYe
	E0K5CnlCz5p7z0/VFxmZbBptZAv65ZrTpS4H/6F3UKnHcQ6rTbmETipC29I+7n9K
	kuaI3j+2Xekb5rDOQ2+sw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793036376; x=1793043576; bh=OjwL+dOXl1G0XYM6+finyh9q+bDo7EQ0zXC
	dvP4sKUY=; b=PWsvFXSPHwOA7U63+FmsIT5MJ91tmnaoVdIO3ZUPNtH1Ab98ug7
	6yRLTsnP0VZYP4arU+dkW54hbAXMiH/3avrcLaDlx8VQi5U5X2CaxWFFE6ql9IvH
	u2KWd57w4YJQ39WjdP1yEr5vXSFiCsczCwW72tOywJYnGGFP5IjHGlc3xUc2zIGJ
	IuqjRRsuGWnrWtDoBR4G47nB03Yg6FvGmMYfG/gPsCV/5yAoylo+T3aqJXwBsxPG
	NxVBXkZWY9JY7jTGuC2TYoiFaYmOvxqntUjmj0EzHbSV/SWY2wxpzX/NJVfP+PMs
	lF55pPKm/iQJGbRExFpKi+RoxKlLRrZTxZw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793036376; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:UZYEEYDYPByAVGuieuaxE6yRQjgAcxJY+xPvLMVHMuLQMcK
	4nsXcEMyIkqBhF1um5kpPrgyeckZRM/puVoTzwM6kNeb+9fxWg0IE6cW2G1hlnpX
	KtyCERvzrbv+b9aA0BAAC3BLblBjA6qB8JE+AhY+LIRvc9REkIo1ML6eYyMcXq6p
	bIfTWE7qRw7GqwS7fol2tDu3mgc0QsEU+ss+oGv0pzU3OWLuhJ788kT/jz3UToA6
	mhElNA8iW7Xu0Qt3MLAQuAY0QQJcKniE0L8VgZer2Z8m56lguTeD+ZVXMYLssFD2
	y+9C0ON2mM3ZHzke0WZHOmB0qBnpiMx1+V95oQQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:6Ww9OTLtowtBqWiQULkq+ViRqleNawRqoZVwSFz61xs=:HK5PFLyxFNzFgXX9dEXISx5+CcuJoukdbYSiqq5cWfw=;
X-ME-Sender: <xms:VpDfakvPYGwmN_RcJhMM65tFUhC25CZ0upVwgyH3PxSnClQheEyqWQ>
    <xme:VpDfagngJAvfN0X7xcKjN6W8bBdHw39DCvlKQ9KHbLnrX4g-bjZ3ZUPEqIe3OEU2E
    Bf6sFD51XGQsFxCbFmazWK4kihPX--4aOQhJ_WnQGcKxP4saAk8cw>
X-ME-Received: <xmr:VpDfakyMxTAcw7YAFXhGLBb7cSk8qCGR1MZW7lU55Eq8QTsPAyQX5K4-lzs>
X-ME-Proxy-Cause: dmFkZTF6H3SEpQShDd/kr54hvdkdt3MDjTF28+OqAC/bxg6UM4iEJWWMlnnT27v9jePEmz
    vGMx8mJpChUjh8v1OiOAzIMSlkJxTEn6JkrbUpKe5ErfD84wXqDBMbWsH0xqlTzlt+hdpX
    HDMnRTKOD4gayTPO77h+/Ew/lA79lBP4gW3fvzv7nBS/pThjI7OlhteCj0KZuy/1hMJ6hl
    7wmBRBmCVaoZTUGA4TbSiu2cZAiVpR2sAcoEBREPHEr0+AEhMBFYMn8kihpTBwQKSYCN0e
    19KCYnBmkwGoKFl6OLcnuRebfdT7MuZ9XNsKec6UnbEsx7bfq/xEUZydvzTLi/RATFXjpR
    wg+k4o4CXPH2SHleMmZd+BJOxQjRUBedVDMhgIl4OfPGAJcx+beaQw6YEv7A+FqYkHm/ut
    zSnQBLlCtTdKLQafgvSYYz/RytMnVVsxTnFXIt2nl75Gv3qZpsXjjxUKpHBOrTZ3ZdkISo
    NDQKKsOTGpDz/LwIrqV5boxfnXtPK9RxGT6X8zV4kMwZ3tPcECJ7n2FNAQCeI3MmONSZNa
    zVwHbzNgIkWSjZgZz2TmJOap4iORe69JcFquTFfiuvDTwYx10HKrvTSr8EO0wMyplkS86w
    xvaW1X0JnKp3AcjJQzKKgJbBSrQco6NzrXRHjs/+lbO8Y53HXH+/w7g09DeA
X-ME-Proxy: <xmx:VpDfamwXPRg6kIALhDkqagVgg6yM9zrSZqcuQeKsPQDYoDoh9idcQA>
    <xmx:VpDfatB2V75JiLUBZeB-0A6yudE42QZQZm0BSVgir-yaurDCmJEAbQ>
    <xmx:VpDfahph8RNX-Vy4wt4o9RDAs4PQ-LNcicnx_uZWvyvHj56NtyDaZg>
    <xmx:VpDfarQEV2WjxZIMj2k32K03Eq43nNqa66hkd6edr_rcG7lSkx5J_g>
    <xmx:WJDfahffJM9mqtUXpu9sfOKyk63ISmf__apPCjOjkhdYXJi2hYZ9tLFA>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 13:39:33 -0400 (EDT)
Date: Mon, 26 Oct 2026 17:39:32 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 12/16] mm/shmem: fix truncate hang in large swap entry
Message-ID: <at-Pen0rJcHRDnBv@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-12-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-12-703206d5fa0c@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7046620005
X-Stat-Signature: p1qj6t3kx3jymm8a6q6jii7a4cgagkxc
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793036377-397093
X-HE-Meta: U2FsdGVkX19+7CZkSyraH3G8BqZZ88aqomGg+p6gTMIjaBWCK20jnz2tGzKLyXlCoZDSqp3nMLYuAKd6P9HrQE6X4xt3Yq5UWQ7Ib3s5X806IoBgCjE0a0ET34+GUzk42KcSz0bC/jPorPrz/vNEsRJqXkT9CJiZTbbK7NSQzCtOE0BmT7biPgbWDcXe4l8fECbqTk+2v8Em123t1UBBIJrf2jv5iYBQBRJ2yk96gsn6EF3VFiGj0LkEDSRkNMiWHLOku+A0vIsDXXHxHbcrMt1TxtTr6Xpg9vWpCxRTjCLWF4NkaJV4FrwxT0NgKoO20jSAv7Dx0J71bdOPaWo1La7m5tOJTyy168cuUd7qCt8/c0ZhP+oFFhQtDx+wDuWGMzDLAt5LLrw+kkwRLWSalg7tQ231h4y9fiuGg9ZrbtyM0x7SJX1de11d3XN28y2+LKXp2yEYG8FQlcNXpJNdMx2uKaRnzIzZumDQuoTySy3zV1nYtOXqsvi4JW7PKc0fx6KwK7nl5REDYIy2QPVpAZPS0icEHvjYW544k0JpihRKzJ6HBgXJGsj9hOT/59GW3iwO9PTFS0xyAPjEs1ArMVyl4R3zToyf/sNaznXr82nk/RRaysygnBgIMSjbaUxU1ejCF6h1QsDvkZLEMWKkNPd+M3r6yziiJ6cX/TrOaRjuLxnBc48STjAZ1PPyrPbumxfjVVk2roUV+WIBC9D/wfwMU+Dnsb7AjmC7EPTWXxf/UQ3uvYn1L9xPGC2/YUVYu2iCB3Vgy0Ts9OeTvGwKQZHoGyNe2yISIAgRkuZnsaXjxQB8Se4XLvdp5Vl0QdWa7/PxNKpdra3AnbIM5B0UupT5hZYNWt9DB+GWyhwbpUD3NmgUMyL3ARpM94M9415HJ+ApneOP9ZNbGfinJQVRvbKnW4cJy/1Yd9e/2Rkg78aO8em5k9+P2SyI8P199OKWMDwSJ2STtz8BP7gtyLd
 RA2pwRvZ
 zJqeVJiNAC3RQrFAxfgfbXIf8LiaiRUaoiVj4xvzwlBG1xparhXaD4WlDvWsdmr6BiCcgEMPxM6mqraWwy5THdjIFH9ASVzBbW0bbsB+Qg7rfX4KdN8o2gx0XzbsKuKR36u4IaRObBfM4JWp/iA7lDMwM462G3GgY3sVMJZSFX+lC+cJtQ/4olY/R5Lc6zamoLZ48KJmYj9hBqEzMnEZ1IGe5pkoAYYeOEpzmiQq3RC/f8ErSeX1PvZZJ6rZlAZuUR73FUWw8g3ZP2+83GNE0T5ogYf1oJ8Frn7gjWe1qNScmUa6p9XM0qITvzEa9R8Bdlti9jsv3HESDMXaYwrBJPAPhttirHlrb08ZPiBd3zuY2ypCxV4lV62mEzaSGBkprqTGSzD+kK9rcN5bWz/7IruCoCW0iunHRTK7U+nJCyBvxqveELAOV8q1rUmzVjrbWLtVgg26SlpFp7mANDhcRwaVKFqhb0lPNQQkfPTVxoyAl5Anrm6DuJfY4C7Sy6kiZOFRuxgVYLwSlGX1wq5uiwp4GDnF0l5N1MzVJSNl1yc3H0P1T/fNCL3wZHVasQzJtFjEZy2XmWMleVYIYzBy6KndYzeVmnAz+UCjnYCb1NROptqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:45AM +0100, David Hildenbrand (Arm) wrote:
> Truncating a tmpfs file or memfd to a page-aligned size inside a large
> swap entry can loop indefinitely in shmem_undo_range(). The task holds
> the inode lock and cannot be killed.
> 
> A large swap entry represents a whole swapped-out folio. For example,
> truncate a file whose pages 0-7 share one swap entry to four pages:
> 
>     [ 0  1  2  3 | 4  5  6  7 ]
>          keep    |   discard
>                  ^
>             new EOF, start = 4
> 
> i_size has already been updated when boundary handling asks
> shmem_get_partial_folio() for page 4. Since it is swapped out, the helper
> calls shmem_get_folio() with SGP_READ. That rejects page 4 with -EINVAL
> because its starting offset equals i_size. Nothing is read back.
> 
> The final scan cannot free the entry without losing pages 0-3. It skips
> it, restarts from start = 4, and finds it again indefinitely. An unaligned
> truncate avoids this particular failure because the requested page starts
> below i_size. Folios already in the page-cache cannot trigger it as the
> direct lookup will return them beyond EOF.
> 
> Fix it by letting shmem_get_partial_folio() call shmem_swapin_folio()
> directly for swap entries. This bypasses the read path's i_size check,
> allowing the existing boundary handling to zero and split the folio. If
> swap-in returns a smaller folio, it also splits the swap entry so the final
> scan can free the entries beyond EOF. Retry the lookup if the entry
> changes during swap-in.
> 
> Handling swap-in allocation failures remains broken and is unchanged by
> this commit. Even when shmem_swapin_folio() correctly returns -ENOMEM
> instead of -EEXIST, shmem_get_partial_folio() returns NULL and
> shmem_undo_range() skips boundary handling. If the large swap entry
> remains intact, truncation can still loop in the final scan, while hole
> punching can return without zeroing the boundary.

Oof.

> This may read an entire large folio back from swap while holding
> i_rwsem, only to discard part of it. Avoiding that I/O would require
> splitting both the swap entry and any large folio still in the swap
> cache. That, however, is much bigger work.
> 
> Original fix generated by LLM and sent by Chris Mason in private.
> 
> Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

It is getting horrible situation somewhat better, so:

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

