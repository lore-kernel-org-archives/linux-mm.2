Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B2DCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 257AF6B0005; Thu, 11 Jun 2026 23:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206DB6B0088; Thu, 11 Jun 2026 23:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E2C6B008C; Thu, 11 Jun 2026 23:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 039E66B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:45:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1757165A34
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:45:07 +0000 (UTC)
X-FDA: 84869869854.01.F4E7B9F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7220F20003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:45:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Omfx/M+u";
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781235906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8wuNTTt8Nkmf44XvMl/+1kApdnUIs1lQ+xGFMDCtpqk=;
	b=Vdi5Ej7MIZq/dzaA9qgBsOEbjqJTqbT3HYBD2C7gSdkBtW9i4HHZqBD911ua6o3vSJjf/E
	nBHlq3aoIlYdt+dR7GJBvOuWJoYw0WAPX68c0fP24ks+tqA0zKIb29YWFl1ShorQ8aUWuK
	JUFPb60VYICQGUV2PtZ8zHMfmnBNE1g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Omfx/M+u";
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781235906;
	b=5z/AVo30yLdDgmQmHSCut/RizRgVuurDrXVvCtalL9FhTi4aC0qM6+N7JKKx/nMlwQfiQy
	3NxGLQiymJj25j2uw4AyOXMgkdEQbwsS6gFi5iR1Guvrr2fDsMHNnjlJM3VrWQZxA9OzGO
	zt/1GvKegVobadJApPNfXoYEuNOfGYs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=8wuNTTt8Nkmf44XvMl/+1kApdnUIs1lQ+xGFMDCtpqk=; b=Omfx/M+uj8H4iUlLYnVIlSoA0f
	83mqDu1TOrrhlbKmtTjrtxG37j/CPmGVYlIdrf/ix6BxCHIi1LPlAFeg1e2YMZPBPRHUgf3S4LN5x
	PSGpxCML5T8HDnCKR0r6w/1fIUNw6HJzmnXr108sYmRS+Ll/s4fumypdB39yxuKiCUJDDVMet7fOz
	lkafYWbLoqw0lofci3jc7FN/eU9xasCTmwg1LLKB/UkkMA4F7dzYre2Z9xK9kLUClCmePnztc11Qg
	0OGM9nbOeSZ8TM00KEsuAl8ZGFE5YJjtAVOl/DmoHZSSpYU1Fn1Urxg8nahiBFdfhW9BspxdlnoLe
	dH6wy6cw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXsp5-000000033X5-0vpy;
	Fri, 12 Jun 2026 03:44:47 +0000
Date: Fri, 12 Jun 2026 04:44:47 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, jaegeuk@kernel.org, Chao Yu <chao@kernel.org>,
	"jyescas@google.com" <jyescas@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com,
	xiuhong.wang@unisoc.com, hao_hao.wang@unisoc.com
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
Message-ID: <aiuAr0kYDcc-AoVg@casper.infradead.org>
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org>
 <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
 <CAGWkznFQH65gJO=xvxZLoDGWLu7YTCnSyfoy7JdLKV5eY8qLzg@mail.gmail.com>
 <2F9A72CC-772C-4691-9F18-77306EADC6CB@nvidia.com>
 <CAGWkznEGt1eRmiTLsU6DAJBmmbUG4ZY4HE5Cx=Oy0yznqGb0UA@mail.gmail.com>
 <A7D51FCA-7D88-449B-9113-7741BA2D659B@nvidia.com>
 <CAGWkznHyxMNX3=A8ApCuY20As4NJpF_dCTaY_5+STVSv3RjsBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGWkznHyxMNX3=A8ApCuY20As4NJpF_dCTaY_5+STVSv3RjsBw@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7220F20003
X-Stat-Signature: wjjwggeqgcour6cw4o8nhydddrmotb61
X-Rspam-User: 
X-HE-Tag: 1781235905-251437
X-HE-Meta: U2FsdGVkX18a+yIdO31+A/O8zjZAQxtfma08wjSJ+ImfT5H3tWO0Q1auCI1JMLa/WpYpO/EDs0CLmiiu/i+LTzEjQXd5JmAnrHuETNgx8lUJxG6QkVMip01xF9HO4qD1Ltmqi7SyoN3/02Lep9Erbho3OmocXCOKRCorkdqXG0S4cyvGoN9vljUN8XZEBa6CjYHxHmGr/QqRUjg7GSOGMiq0LvK1Lh0XY7ujjXtZjp/p3lu1RHkcod4OZozlCfXZN8tkqXnV6v4Hn+3SXgd8aJoNd3sNrNgEE+4MqNYL3ai3Ogm4f077P1mYUDITlTGMW8k7jmD7ddFPBzzdnqghrodXONGqDyPk6xtPp8im/NFgb+nmr9a4hMVq76E2yTcZ+BOOv1kVz8eVycyboptClxAeqmHj0JSHcK/N2C08I8ZZOcY4w8bKhvknA1uCKYFDbahzi7amRlqyZOrejNchSZE1qf83cl1GGK+XwsN9lR3s9lh5fjeDLuyOWeLQjXZYwkOvJ3gcpHyFqjwj2u4DCVjlIWsyIG9oXypuGaQeAJk7pxn+gURCmW/p88/W1l8UhiD+JVlag8vnE2LIMjdlozAtAuBoj6ZqIGq9kx3POz/ni5MyN1eW85TG7RMz1QmwR+IB22ZOhYSnQOrCK9S/SHQhNwqASl5jW0RSpo1zJ5cl0yPTReQQdL8xSj9E9/y9s022+u1GlS6/b2PlzxkT1hST1Vs6Tb70kEI/Pk09pz5+0xwKwvl6V8brVj+qnNeul96oXL3ZvUcIFSxJ/EyfZjllGTuOrCfNQg/ZpPWAD0e/1wLlpzWQt2/MsGA5H/ZTFeRbvcP5AMD01KIShvm45qKQ9kA2Er6oSz0lkJ/8G2VCkNaeW0Z8C2QrYRQ4c5cpMQM7XZ1UBYOgReayZBvCpXofyueC9CWzYzZw5HvA7x7ZJPB09MNhzJI21/gACH6tKrUkicNp4HKJ/Ht3Uw4
 xELsw7Yq
 tW+Qg3c4LESR1ZUuyYXrTHMoIba/yVrX9qMefTy/tTtsj0KPoakqNSVUIY0qXckG4ejhLB8vjGfsrdvqOzScz2V7fCYq89Z0xS0Hai3uOQMZh4r0tl1OZ2IBmnhecjHMepVDOuWGAxi6i7/WpV/nh2qoW9tKvplf++wx3rtJJMMSfuHgUzgiskOLjTUy69HXN5beJWnuupoaf4xYhgnTQmyBir5S++QyEqZpSuIZTOd/8PWAdwjAZjl4mETCLPxyLFOic3aQ5zbUcjh4R0yAlRRJ8cFU+cf5VILxUgNrOkK4uQpoz/LJF2Gk65jB9vsLyVqJAj0nPVSnAa4avTZlVu7YGaGt0n5Xv26Wa3Utz2IeMED8Kdl8Nsp/JlULNnC4FnLBN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 03:45:19PM +0800, Zhaoyang Huang wrote:
> > > pin_user_pages*(..., FOLL_LONGTERM)
> > > └─ __gup_longterm_locked() [gup.c:2465]
> > > │ ├─ follow_page_pte() [gup.c:802]
> > > │ │ └─ try_grab_folio() [gup.c:858]
> > >              if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
> > >                  return -ENOMEM;
> > >
> > >                                // Could __folio_split->folio_put could
> > > race here ?
> > >              if (flags & FOLL_GET)
> > >                  folio_ref_add(folio, refs);
> > > └─ check_and_migrate_movable_pages() [gup.c:2490]
> > > └─ collect_longterm_unpinnable_folios() [gup.c:2391]
> > > └─ └─if (!folio_isolate_lru(folio))
> > >
> > > Could the __folio_split race in the above scenario? It looks like
> > > try_grab_folio set the refcount without using atomic operation.
> >
> > folio_ref_add() used by try_grab_folio() is an atomic op.
> > Which refcount change is not atomic here?
> The atomic I mean is folio_try_get is implemented by
> atomic_add_unless, while try_grab_folio does this by the below
> sequence which leaves a window to have __folio_split race with it.
> right?
> 
> if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
> ....
> 
> if (flags & FOLL_GET)
>     folio_ref_add(folio, refs);

No.  try_grab_folio() is only called when we already have a reference to
the folio.  It says so right in the comment:

 * It is called when we have a stable reference for the folio, typically in
 * GUP slow path.

You may not be able to see it; in the GUP slow path, we have a lock
preventing unmapping, and the folio is mapped, therefore
there's a reference count on the folio already.  This isn't true for
try_grab_folio_fast(), which is why it uses try_get instead of ref_add.


