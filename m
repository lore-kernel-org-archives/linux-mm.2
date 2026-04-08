Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA6C10F9976
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104346B0005; Wed,  8 Apr 2026 16:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5516B0088; Wed,  8 Apr 2026 16:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D946B0089; Wed,  8 Apr 2026 16:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3BA86B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:07:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 822DB140251
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:07:18 +0000 (UTC)
X-FDA: 84636472956.10.529127B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B6A5E140008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:07:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SaBd3YuC;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775678837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Duwelm1sdtZX7g1M5GJ6XXV+FjnxeSae8404SM2yegg=;
	b=TwbJQlD7n2xDlJBXp017Aa0SKIdTL8a0m6r0FpOsPh5mpB7cVpojzGqWYOBVUHug5d59jp
	DTz551Hh6K7okxu0sZgtugllkb08e++pvu82p6lAYl2eMNlrnF3fiT9sGPf0GWHQ5f6Dc0
	dDpxI+fmC013BkgxSNluvXAkrcCb6DA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SaBd3YuC;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775678837; a=rsa-sha256;
	cv=none;
	b=Jmaz+Ep4baSGtd5xQ4jF7r+vZpw0LAA14h0xzSg2XaXe/eGD3tYLDqsEN1Z+U9TJKGDTsD
	DOS3nijDyAeydqUXGjY3GQflUFeTiJZFAw4cPGVaUSFnHArwzi4siw8LSP3faGTAXfv2x4
	hbm09gKcQHUd9bm1WCYk/r7Witr6EPc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 743474338F;
	Wed,  8 Apr 2026 20:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B94C19421;
	Wed,  8 Apr 2026 20:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775678835;
	bh=zkMpvfcXurA2nO2kaov6GLyQ92lcLQj1NOJR5OwkUP0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SaBd3YuCdhQxAdkWNbXgdlSnM/jYGSa2YieQJA6TGn4Gi7PVdxH3vBSE7VNj1yHEY
	 R+ypk9kkxCwnxwY/7zXkHQ+kLYpRChybFCV803VtI0B3C0Y2fsJoXgeK826uT49uVl
	 8vYuzKpEq03hC2FvhTrlf3SYWcb4zEyJLr1evpNs=
Date: Wed, 8 Apr 2026 13:07:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RESEND PATCH v2 0/8] mm: use spinlock guards for zone lock
Message-Id: <20260408130715.d6772b9675b0182bac9fe427@linux-foundation.org>
In-Reply-To: <adaFaMGbndSSMaZn@tiehlicka>
References: <cover.1775654118.git.d@ilvokhin.com>
	<adaFaMGbndSSMaZn@tiehlicka>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B6A5E140008
X-Stat-Signature: q9ozaednsobggphtbqjtaysdqqd5t8on
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775678836-430572
X-HE-Meta: U2FsdGVkX1/0+dluO0nwTmivWzielakDIagxjtzHBHPiyeGdm5suSBPLykV+U2qFB9K4kB/w/HtaL6Eo4rr+pLQJLoHv3yUAEK+Hq0ztwlAFpCNWVkJEJMQojfd2KcljR5JAVTbFY3k4fJQJF9oS8nzkwHteWzjNpDimJKcH9LdyZnLtRXu0lAwdh8zm/NiFT+iAUnPcmTLkHQI13EStYmKttV5VENpzpG0t+ba7NBh9BO37prQ5D5ZQtMDuRpLpET1gox0t26AoH0IIux33sPrqanxjTbt5yeBPaVJ2YOxaX80RmJlbT8XNjjXCdvtjAd5bO68dn+/z1YI4JVqK1XDkmP8RY7W2lp+9fucU6wrOxD96mnJVBvl1rixStg6bGpeKgYesnGKxrbcXD9NeRn2uj/Y2CwZGOcesvD65XDR6Kz7+doPGHAubBKDTAlW48ATDcIHMvuGgu+10m4RbZ7RNM4D9oj3EjI2EuMRhTO07LIenuVRlK9GZe0/0DRMD88pZH/RCr5o52FNK1blelXxVzvJEmz/h89auRrD5FsjP+3L8Ect/nX7iPFyE9T2Ta1QgJeE0baRdoDSm7n2VxnaTegbcW8ygmScltoF8kHL7QwLN147mDN5OfdbDCSyZdD+HhINSwuVTiyaQb1e6fIybczAjfLAttzHKQCypUiTeQfXM0tzjZzOxy7dOmtj9sfNvexjelZ3yQnM9xJIocrXevEqTGuiMdg/QCElmD1NT/OxGadFs+JW+haiGc8NzQ3S/JFRBjHFQdMvWmTOwVV1thyrr1xjWFuWmD17iRBploAId7wiVJcsdKRgA6NItGMai1ka5/sRYsWBHGcXkSevlDv6ov5p88L/1rQ+Orc1+KcPWUmvXLZI/zteo+v5t03rhdYtCrxeEg9nohPqblrOtCUelRF4V2EqElpUXFiI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Apr 2026 18:42:16 +0200 Michal Hocko <mhocko@suse.com> wrote:

> > Dmitry Ilvokhin (8):
> >   mm: use zone lock guard in reserve_highatomic_pageblock()
> >   mm: use zone lock guard in unset_migratetype_isolate()
> >   mm: use zone lock guard in unreserve_highatomic_pageblock()
> >   mm: use zone lock guard in set_migratetype_isolate()
> >   mm: use zone lock guard in take_page_off_buddy()
> >   mm: use zone lock guard in put_page_back_buddy()
> >   mm: use zone lock guard in free_pcppages_bulk()
> >   mm: use zone lock guard in __offline_isolated_pages()
> > 
> >  mm/page_alloc.c     | 53 ++++++++++++-----------------------
> >  mm/page_isolation.c | 67 +++++++++++++++++++--------------------------
> >  2 files changed, 45 insertions(+), 75 deletions(-)
> 
> I like the resulting code. For the whole series.
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks.

As I mentioned previously, the outcome here hinges on how the
developers who work on this code feel about using guard().  Most of
them are in hiding at present but that's OK - it's post -rc1 fun.


