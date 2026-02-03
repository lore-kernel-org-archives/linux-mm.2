Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E815EE83040
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 03:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAFFA6B0089; Mon,  2 Feb 2026 22:23:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D846B008A; Mon,  2 Feb 2026 22:23:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F856B0092; Mon,  2 Feb 2026 22:23:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C2EB86B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 22:23:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62B6E58833
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:23:47 +0000 (UTC)
X-FDA: 84401700894.26.0783B5D
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7A8B212000A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:23:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QVLkWBRX;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770089025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqF7j9+NtH77eRf3A06joazi3wU3U3ry+bHbamRYbTw=;
	b=YrCgFLuMfTOdCb7HB4n++xA40CHleY+v914rQbABp437JTkn+PYfZ4KIrB3fdYerSECUPm
	t0MndF1Due5/HjPs72nKqfuZyh7ue1PA0QbV6KdO9IjD1dWwie0BImDbvkremnOL+CsM59
	5vsyUYhQj2xMP6iY4aONnTIT6rKIGSM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QVLkWBRX;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770089025; a=rsa-sha256;
	cv=none;
	b=Qo66PHlfgj5NzqhhID8cgLoAo9SEFBUoGt3ncRNuADpHfLSu9DtGZaZ929HHGmU9tsrBcK
	/N4TaOnMZUmk/IsmTzy4YQvvpWbgCO9O0/Qoo0ZtJ33IsN6sPxYcuLOdfEzbR1YAaj3Uoj
	IG8/HO81CRRWUkVxDJxsVhq8OdgSF8k=
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-662f65c7d8cso2843896eaf.2
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 19:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770089024; x=1770693824; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yqF7j9+NtH77eRf3A06joazi3wU3U3ry+bHbamRYbTw=;
        b=QVLkWBRXW06hcDB0cQWBlaxiVHRKWvMZfgOXKxGC6gnW5hdpG3G+9PctnhAiwGwUiL
         DwIW+N9D9l+gbFZEsQHdo2EkInJhx47HAL7+BYo/j8/3VmM0Bnbw/ZMWlMutUhruZWp9
         of2gieKvoAKhqxMH9VjAbM0sn2soTzdF5yYUjp9KjgOTyx27Q7oRlHWSmiS15jItohuW
         CENzki3kq60y6CAWcSe4SE0BJnTIf/7r+9jKRwYaLW03G1x+bca/H0odQHsbF/QDyYIm
         qIZ8xx2WAJFByj8+piZGwPlwSGT96YXM/DbldsgYmUkt5TBaB9IJYkgPu1s+TTa6ZfX0
         WyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770089024; x=1770693824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yqF7j9+NtH77eRf3A06joazi3wU3U3ry+bHbamRYbTw=;
        b=KtEeEdg2SUsgNBWfG7mrAZN6UC7/oFCkuwvcKjzwUb/Pugy8QNLr09z2ikfyowZ1gE
         CcF+195qYpV8svPhszX92pHRyFl2kHmxQQiqKWvMCl/dp6IH937wR4y09fNrNNen7H5L
         RGIHPpBc008NpaGLziyZrXN/RuY+c9m57LApG8DZyh/RHBXswumJamup/h3I2LNoPuFj
         rx/BAdLkIMq5uv1j/mju0EAKHEkjJmQvWUGpTHpcy7SaUUElujaYLD4xo8YRBpnxosXw
         0qZn4/DsTmcRbYIZT3PVJFINB1QEfnA8HZYfnOK+rC0RNNps0RtMghJIdSxZJMupz6JM
         JzLA==
X-Forwarded-Encrypted: i=1; AJvYcCX9QwUKXUnI2YhxsA8NSGszHTAPoAdEkETLbtb59oPzl0xGrJHd25EK+IeBqlOyhrn34ICORe7uZQ==@kvack.org
X-Gm-Message-State: AOJu0Ywesr4gbErLvqqcuBc4CHa2qVayZfoPeWfhoJvhvEpaxKLLeT9G
	TIZukVtyV3XNWj0bkiJJKDdqKSs2U2nvz/p9UMofoH2JUGjdDoff3b76
X-Gm-Gg: AZuq6aL8Zkhl1ACywHDP/3YeTiXEOYiR/eKfS+ji9ijLkopmF5CxV4SqpY8iIssAbLL
	lSkdKbNfKOgzuAwSvfBFG98w4+KQVn7P2wFKFO08kT3S8tWqT1JUeJSAi+AnPsF9x249qI837HN
	SD5s2FdsSaYlgZ7HsTbrCx0MrsxnhX5g+rsu9e5iUuprucwm9RPWeL+OafirHDifRZLoOMl97cV
	rAULF9+kO38N/Crr2+PMxmoNfDcSsP2YBMJ9ezsoPSXoEpMg+6jl6Nvh+wQbfT50k2LQEzVMYPH
	HIxbHtP3ad79R05bF3pY+NlR65f2Qv0Rfk4KqrilPL6+BigFyQFObPO0Ca47+Rxh5Zu9P7iqs1s
	UW4vlljo9Pdc07E+3Rizr/GbktQGXcdTuGT68MPBnBTbFvilsgWlxFM2t//xRLbQ1kWrjLJWXqJ
	HpbsAmTw/5ZQ==
X-Received: by 2002:a05:6820:1528:b0:662:c161:206e with SMTP id 006d021491bc7-6630f3cdb13mr5166424eaf.82.1770089024432;
        Mon, 02 Feb 2026 19:23:44 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:40::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4095717052bsm12915115fac.8.2026.02.02.19.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 19:23:43 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Wupeng Ma <mawupeng1@huawei.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/hugetlb: Restore failed global reservations to subpool
Date: Mon,  2 Feb 2026 19:23:40 -0800
Message-ID: <20260203032340.1861093-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202183918.057dac34b3a1819328814fc9@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7A8B212000A
X-Stat-Signature: 13o6k59wx3goe85x6th41jame8h4qpsj
X-Rspam-User: 
X-HE-Tag: 1770089025-157654
X-HE-Meta: U2FsdGVkX197E8Z05Ecx8znozPVxoMoSMUPGjar6GCyYUolFPYbRUY0G393UGbATe1YCAp1JLKsstY+HXiA2Oy3CUc5BcK50hq6yfERkySDnt/2X2ufB4y+xpoKNqKcumTT3IPd6Mxgwji/xXkadEyit7ryyn5MZD1XTZzZGuL+/Ab9uyJpFvGk7ce0w0YvIJlpaObCngH+iq81k0/nHyY9fcxlClunAK2ANVvfqnu5w4abSnv+FcL+SrlxsP9e8y4Xso81VaML8q3fs9Zbw/ZAYL6aRKy8uCgzj6vrWrJ4Fx6LJiSuJ0sckM9u6AtF+JK3iJqMbEpHqDO91LUDHZV6LhnIZeW/VrB43l40v4w4gM9zeWRmNm9kzN2/rmS4OYtS4Dd/6i5b2C0uoDv6Vhaq2Ae6EzTpr6+wboiQADzFKZcc8LrrS5Ere7jp8Tpwq1ie2U+v5FHxUbpjoiBP/sikTmX98bZMFy2gCojqo4p6/20rUS9vzS24faADZLuJoIPQy7kFNhcYxUmjS3Xbg6e5KDJpcOnsT8AWo8sbmZPJ4srt9BMz+y3KhESdO0WQfyjhCdRJwXFwwGt71Agyc9YGBWCGv0hiW1naqKjQwZtrWD0Sa/VWAhu6ZifM+FOmZUnVHffpmx+WI6QOaWa3Elw22jd+yOLX5cMvqUqc81olUSXaD+ohJucJnmDSLEP3Ur0JB1zBygNJZsq2pLRo5Mh1cidH/LOmSnMt8vz+JnPc6oHDeK67ap93T3FU+e6gS2ILVnHcCYOVxdSjHqImqTb8UvAC4eJJOXlg2ERJsVPhzfP5eCwZw91+6Uz+c766TazHx1sqguqz0wPmF8hBdAQ7pWl9dbvu0VEkNpfegvGnNgUj0Lev8E78d2sRQpnR56Nen/MDlO9PRSiPw2gUoQnyKeFOWqk/8xG59fnkxFc0vPmj/Wza2TVlzHN5L+jQTDW3JultkZh/8oJELmJk
 c7M/Hzy4
 BZ7H29iSUhBCe1vYTLWaqTF+w+JCbJoTitLkIBHL3YuerZPKESUnoNxpRDVzMW6mgtHD+f718j3p6OkP17ILd1grP/y08Pt2LeBKjpk99HZ3r1ZZR7u8iR2k7M7U5+DyQ6WMCPLZCPIamPzjMpBv8zlJgs2ZTqcS6b05uzpd+dMlqmRNIE+0/jq0+pKODye0XskNT5ajrVLgV/ngbxZ/pO/qvEU5dQuMClj827M548Sov79qGu0zELRkEhT30n6saX2cjLrLkZvY3W++G+muIch902yfx8dapByZCmG+1aIuJInGV/EwpgKOKo1K/WY5+Y4MsirclJJX5zgkcjgPFdGiDYYYiAxS7wTb10ID5AP2+6G8lAohjD5GwJZOv3OqLp1KDa9zU0JGSmvMngwgAsDxOlkivItK1k4qx+gbKhwENaVoZU1Pn2jckZ6mqdVvUS7HoGCj9F7OQwpnvCleq9gUIQ38gptCD/pm458lvw9TzEHPXz7oUPr69Cm1ieqywFDhp5hJ1QmLZpSQ4pUlbZD+1vbuVIXpyIVOlBFax9zOjOjaaKQQjiCznvWoZgEpzHUUcAz5iDHgOesQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2 Feb 2026 18:39:18 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 21 Jan 2026 09:47:54 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 16 Jan 2026 15:40:36 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > 
> > > Commit a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> > > fixed an underflow error for hstate->resv_huge_pages caused by
> > > incorrectly attributing globally requested pages to the subpool's
> > > reservation.
> > > 
> > > Unfortunately, this fix also introduced the opposite problem, which would
> > > leave spool->used_hpages elevated if the globally requested pages could
> > > not be acquired. This is because while a subpool's reserve pages only
> > > accounts for what is requested and allocated from the subpool, its
> > > "used" counter keeps track of what is consumed in total, both from the
> > > subpool and globally. Thus, we need to adjust spool->used_hpages in the
> > > other direction, and make sure that globally requested pages are
> > > uncharged from the subpool's used counter.
> > > 
> > > ...
> > > 
> > > Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> > > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > > Cc: stable@vger.kernel.org
> > 
> > This (simple, cc:stable) patch presently has no reviews, if someone
> > could please be so kind.
> 
> Oh.
> 
> Joshua, it's unclear from the changelog - what are the userspace-visible
> effects of the bug?

Hello Andrew,

Sorry about that, I definitely could have been more explicit with the
userspace behavior. What ends up happening is that the subpool will
imagine that all of its hugeTLB pages are consumed, so it will be
unable to service allocations trying to get hugeTLB pages from it,
despite none of the hugeTLB pages in the system really being used.

Maybe we can reword the following block:

> > > Repeating this process will ultimately render the subpool unable to
> > > allocate any hugepages, since it believes that it is using the maximum
> > > number of hugepages that the subpool has been allotted.

Into this block, to make it more explicit?

With each failed allocation attempt incrementing the used counter, the
subpool eventually reaches a point where its used counter equals its
max counter. At that point, any future allocations that try to allocate
hugeTLB pages from the subpool will fail, despite the subpool not having
any of its hugeTLB pages consumed by any user.

Once this happens, there is no way to make the subpool usable again,
since there is no way to decrement the used counter as no process
is really consuming the hugeTLB pages.


I hope this makes it a bit more clear, and please let me know if there is
anything else I can do! I hope you have a great evening,

Joshua

