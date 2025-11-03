Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC706CCFA05
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 10:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486C58E0053; Mon,  3 Nov 2025 05:59:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45EB38E002A; Mon,  3 Nov 2025 05:59:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374768E0053; Mon,  3 Nov 2025 05:59:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 255158E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 05:59:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C636A49349
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:59:09 +0000 (UTC)
X-FDA: 84068998818.17.8233B3E
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf19.hostedemail.com (Postfix) with ESMTP id C20321A0005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:59:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q 2knTnH";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=lVlBNiwT;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762167547; a=rsa-sha256;
	cv=none;
	b=xigeR+/M20HV8nV9E3aQOsREXtbNW1u4e3+JqqyQp5+QKrjfErnhFgEbJP+rjhcbkwQ8UO
	Gvg8FsbCCvsmeZVEx+pj+o++dEIi77olHe1/KIRayihQfhWRQdwHs+VPIT0DT81+9yqfTx
	3QdhpTY3aUUB7xoHyMPn6IOc/B8Dn5k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q 2knTnH";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=lVlBNiwT;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762167547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4NQ+5V5v/JGdSry3DxICjbmhUscqySQtyw/XKVp7C8=;
	b=5e+aUEGzNftmvPlfEYriiyCD6yjbJDhuc/D6KCNjMqZnDkXAnMW7udl6VlFH1htaGi5mHT
	l4ZiWUhfudQVo+0R2FuHLhibGXtaeynDLmxEACz9ErcjnOhVzySsCLaPaTO/gRhJkSYL/k
	BspRtUNMdgg2Ch4Ao+ggEhCJQG8EKl4=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id C602513003AD;
	Mon,  3 Nov 2025 05:59:05 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 03 Nov 2025 05:59:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1762167545; x=
	1762174745; bh=+4NQ+5V5v/JGdSry3DxICjbmhUscqySQtyw/XKVp7C8=; b=Q
	2knTnHJpCxm/V+t/6L2eXw8ev9sqJ4+v8FOdLFzCmXayS841G+ajjojZc3mVGWo1
	R/rFK56aHJkZ1jBIx0YT8KWoMPrdvg5RguHvKvlK9bEknZ64YZBSbfq/tH4L3oP6
	jvetTJXEFdx1+IcFzhY3jQ3CEr8JzNmsV5Q9XmZPmWWZOzKWjXKM5nI7tlPPWEAl
	NE8/tnEEZUGs32nXtTnC9VhfN1PaBSjvoFFG7kEhd6BZnqFopGoRkp6S/bTJgctA
	I6UVrx/JYJ9vvjkOiHQAXLhyvF5SXfflFOuv7ksbPP5vBXeq2ironAjhr0h4LhPZ
	I8vaa/XNOBLCecDBwkefA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1762167545; x=1762174745; bh=+4NQ+5V5v/JGdSry3DxICjbmhUscqySQtyw
	/XKVp7C8=; b=lVlBNiwTkjN8wsYrqTh12ENcFZ1ihIQHs9QDHRYujxGBg4EaMby
	yKdjdrdnFNHVTvRGMx+qJdHXDvjOm16nbBy+e3I5HCiOC3dwLajHn6CAbokwlUyW
	TrIsXspuYJC5CLWz05By8CNnsjCjQCMzTKazQ45ewTPwY/0OJFEWaf0VWpKaIzzZ
	ELZ3pSfmOZ7zlJChYfSOVzFWWFTCoyFjGqdqFt84f2N8Sh/6TL8iGS8MIU5xBXvB
	vMPd9jTsdFhRKU/oQ5OkX9mAOmgLyBPaK24v5lnfyfrzHcX2X1ohuhitfc406b2r
	kNsdhdnEfaxw30A7qh35vEc9H6ke5IiGpXQ==
X-ME-Sender: <xms:9ooIaWdpcp6jmTbiN5aIhEsQsac_oYPEgtSv2-xYRFY9MkQd2V3ZWg>
    <xme:9ooIadB6CyFhmtFnVz7JCCojqBEyBUF_R0NcTtzlyPxEhFJ9VdHrzMJhlup6_KTDv
    BwBDgB5fyQsKOQvQLBh7ZuAPczjwPK4ZGFm5dAd2H20XRSKb3b-gg>
X-ME-Received: <xmr:9ooIabuvo8IgbLOqK2r44-zrQF4cMwEzGLbSXlPBMuFogAHLsR_QO_ZnSwwhGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddujeejleeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:94oIaSE-l0bqLj1DMOX4Xt-klS_pL6IlF9w2BfNKAtsbuHytbb07vw>
    <xmx:94oIaW3Pegr5WO_ZGDTy_3Yfxoe2V1tZ8Iz6p2ivYvN2J4-07Cn9OA>
    <xmx:94oIaS4actkpP1P69yNXCMCeDC7HHElOHKLN46hnyVxhUuP1JNg5sw>
    <xmx:94oIaaV2RfNWnQLiVkbvvW6DXvGpS1sywTYvjz1dGfeZycLOU-xu2A>
    <xmx:-YoIaVNuEwv4ZFAuSeU1Yd4rcsmlBos7lni2xBITnXmInUmd7XxEezEG>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Nov 2025 05:59:02 -0500 (EST)
Date: Mon, 3 Nov 2025 10:59:00 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-ID: <xadc6rbs7fkk2mb5b4reobqwue2kveo736r3wpa5zwted4daua@rgasjiwwot3g>
References: <20251027115636.82382-1-kirill@shutemov.name>
 <20251027115636.82382-2-kirill@shutemov.name>
 <20251027153323.5eb2d97a791112f730e74a21@linux-foundation.org>
 <hw5hjbmt65aefgfz5cqsodpduvlkc6fmlbmwemvoknuehhgml2@orbho2mz52sv>
 <9e2750bf-7945-cc71-b9b3-632f03d89a55@google.com>
 <aQWT_6cXWAcjZYON@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQWT_6cXWAcjZYON@casper.infradead.org>
X-Stat-Signature: 14btsusz5sjh7smzo95zra3fapgqsbcp
X-Rspamd-Queue-Id: C20321A0005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762167547-941901
X-HE-Meta: U2FsdGVkX1+YgYWRy3p3qE6SA11O62bhcWjNzhhUnSCph/KkTTiBEwoG3TdRii1k+rS/ja4aW6/qUfEdWBabo6oJhf25mgq+Oa1XpBl1k0uyUf7csZ5fCtMK4kKQlMs9D5cS0nV0EXmfQhDdkt6GR5OyfJjjypw/pyxFuYWdEzL3Xu5yF/7zR+30t/ibMoaGaeS0FGLQg0gpB/jqfEgkhGKrQdhoU2f/YokddK01MskoXsToBCQ3Mc+++INfoUMPPP/DKhQt91pO9qXEvKvi+PQNkCTt9jbrz0a+zLv1P3N81m6lp3l3HdhIeNnOvBqANu7dBfFdtBBtY0fnzCYVDsokvV76bs0Qa/OqXVAV+lTQTcAJOeR18hRjfxy0uVwC8Tlo9JHwFoxd0ATQmLqZcP5KJr2B0yYQ+GK1ILlU4V0uTG9C2s0xPNvfVhSu89FKqtiyRHPFUog+Y5jM1zTlMMSJ4fWcHCfz4Or0YQAw0GyQ1NYeLI7U1p2G0Vog/oX7rlI2JB2hHhskFT9+81bmrHjAY8ltsCDoNiTDPEulyoWCBJQwXQqYNw7r/YTE/28lVSumV3+pyqENGjXIcJDAsU5cWm338e7pxhqSbeEwoP8StxpALyAOUptJcCZKbP++c3XhDYjjOV5nxsRTQLBPx3YTpYo2VaN/JUhQlKjF6qYNLcQtvet+iezWbu8qzDyBuveuol1bG8o0lDOkz4LZQzgRUQFqBzOTpHs5AoU8QmF9hCfT2ZN+vUHMTyh8vxqhHoFUr/+kr/DoNaSOz968bCVYTHLykaOqvXAOA9fMizINGnHxlfcIIHy8Dha+s2FELfupsJddEiluacbgwn8AEYnb1ecpBrAsKxiaCeYk1XHpMx7ALuAO+XBdlZODNKRqUujNAQoU8gFlnaNuDxkb1JXhpYF3hSulJ/ir8LDBwCwGgzhZhHzhBotSzUzkudTAZecB7F0QuEiyQLkZQY3
 2w+Fzsp/
 AjzckaaIp7XDBSnFOU98f9ep5ESL7zS+xRaGQrhaLLWTk0uElTeeOaeIOTvGQj+bDhNjm/oc2iBe6bp8m9mEssPjs3sv26M3QuaCzNRZtcyr9Gf0nFsyvxMKA1hxQd31KtnI1cm24PBtLOjwscu/sEujD/EsiarWaYcTPKZtYlrFNCisKcHvRaIgJw1Yj5idQ9m/M7Q9azE19n009SqEq9Ewz0z5II8Z4yD8B9MZZl85wXEYEVbXY40//iJoDpYrKPEUXEGtOGPb/HZUIqkr9CAq15tMRq71SyY0XIeemXgNjFYpvO/OZqztWFgVzVBKKKyw2N3df28zPlsyfl5qJiFIYD7VxdMztfThJUCwaaWA5O10Dx0p+0MpDQSpXKddSci9+JTTbQFqWLFK7BtCrSaKjKBFwZ92jyKb2paD5Ki95Fjnl/cPcHfrqoilqmpZp3p8JtqCHdRnA55za9+cJ9tYXC//LBcmlWJQga8zyvZhlJCf2kbolZx8BA5YMN3d4cZRpuBU0c/bY76O5lyoPwJaPYOmdP+dljnHA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 01, 2025 at 05:00:47AM +0000, Matthew Wilcox wrote:
> On Wed, Oct 29, 2025 at 02:45:52AM -0700, Hugh Dickins wrote:
> > But you're giving yourself too hard a time of backporting with your
> > 5.10 Fixee 01c70267053d for 1/2: the only filesystem which set the
> > flag then was tmpfs, which you're now excepting.  The flag got
> > renamed later (in 5.16) and then in 5.17 at last there was another
> > filesystem to set it.  So, this 1/2 would be
> > 
> > Fixes: 6795801366da ("xfs: Support large folios")
> 
> I haven't been able to keep up with this patchset -- sorry.
> 
> But this problem didn't exist until bs>PS support was added because we
> would never add a folio to the page cache which extended beyond i_size
> before.  We'd shrink the folio order allocated in do_page_cache_ra()
> (actually, we still do, but page_cache_ra_unbounded() rounds it up
> again).  So it doesn't fix that commit at all, but something far more
> recent.

What about truncate path? We could allocate within i_size at first, then
truncate, if truncation failed to split the folio the mapping stays
beyond i_size.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

