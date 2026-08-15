Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D216CC5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 00:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D32636B0330; Fri, 14 Aug 2026 20:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB316B0331; Fri, 14 Aug 2026 20:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAAF66B0332; Fri, 14 Aug 2026 20:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 900896B0330
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:50:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17373C02A0
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:50:57 +0000 (UTC)
X-FDA: 85101674154.15.2C50CE4
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf29.hostedemail.com (Postfix) with ESMTP id F3CE5120002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:50:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T/5uVyRr";
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786755055;
	b=R81zjuBEg6cgNp7cvb3cL4dxCLbz7vlob6x45UUlS6C1QtpaLdlU/Iyj6+3k5+/Qkc1PDs
	FQOfnFE3orexkfWTgrbwSJ0HpGWY+7EuXv72vH39RotswKarrcwR6czTHlbJwazwId2LQY
	IcKj+0tyP8aXG5ERd/eQGrg2sHaZGes=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T/5uVyRr";
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786755055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDhhlho4mNWXttvB/DhHQXs8kfIB971s8EySIMTwhQY=;
	b=cckBpGUVH9Akt2gau2BlNwUZBC7EFP8gVs7gc+ekl5KKMq137T/OLHhgYIufmpf4u+Lfwq
	B3xFnUsJRh2HPcf4227CTBJUi9jX9OeIeLgAzKevT8PKM8noWaAKyppJIJJmo1cCnWx0Zx
	ZbOVTW16zm7H4cv+sZ10ysdt9La5Gqk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=76/lMek3I/Lm2DW5pZ43j1lOWGN+BgwgiOZBOJZUj0E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786755053; v=1; x=1787359853;
 b=T/5uVyRrVviafwxqmWzk85xw6vUb5zOTXbqkBjjcXbzT4jxvV+GrgoyvY6KGQvrfjt1R+1wn
 ej834zA5R8CMgdVIh/C9hjZPvty+/+CHW0osf1h4blGBv6ww3zfceSkb/4PMZZEYAKSfwjssbsz
 FRNuP2oBPHlKJngZccb0d5/M=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:70::)
	by smtp.migadu.com with ESMTPS id 95cad438e84247e2;
	Sat, 15 Aug 2026 00:50:53 +0000
X-Migadu-Flow: FLOW_OUT
Date: Fri, 14 Aug 2026 17:50:48 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/9] memcg: make the v1 soft limit knob inert
Message-ID: <an-3qupr53VNNOUa@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-2-shakeel.butt@linux.dev>
 <an1-4Rgwlsfd9Hjt@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an1-4Rgwlsfd9Hjt@tiehlicka>
X-Rspamd-Queue-Id: F3CE5120002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: n4ezq37n9psr34o17cm7dhgdbj5t9iwu
X-HE-Tag: 1786755054-283185
X-HE-Meta: U2FsdGVkX18e3GeJS3d5PmuFVPdvjJVEhwts1wJMnwQLEUqUKcY8LlZKX+jufaLMzPKCLao3LoYMMKgWaXyNaJ6vR1WXve6jYlWX7Cx7NS88EYh9hE8wCkn/ZtYimlzLbfF4jOqGvMKrV9XUfZLYE88vmB6BJ28JYChAoRWf6BrhlvN0kqHLhya0KORbonK0erqBon6e0m1Ay/nA8rjXtLo0qfeClrSFqPVXFBYckE0UxbhKPmwAmsVo/bs8qOLCLYp4QyrFFO6hxvDydZS9M94aiNK+gVck9BZ39Rg9HRrTENTmAzIvF4l8jn6BLaN8Qqzk2bc1XWKA6Zexa8YOsJYH3abRCwEU/XW1TQy3s+iO5v/RFz/LLZcBdmdrYbKeUWCwO6P2CgqgQm1x9A4tgSs5AX8gn0XQk4hYHNeOOHQ7V9FsTG24ddN/+OTbfYQrHoWdGVrdyjrH2ysFEQ6XJnxA4Kz80c1qMhvU9AB3wJkgJbfBaoQmwiq6D07tPN38f/WcxoE4lJ2RUuEJTUIXZORQFhAzG79OOwzisy194qpb4l8JffQeQ1SmraaYNkGHNxOKBLvxX86/NuEG39JBnEYhXlShCoth3kOQAieW7PnUcBLFCTVMzVnKE0sorZSL9vT94rBRQi+9cqKFMPlDCE2UhyHVG6I1W7HrJAKALKtrZRjDf/MS/wju5rI1n/qQ18B0BDYIdS5gjBw6H6rz+dEWae64gNM/6v1QLa563DqyxK5/2L3pAUsKE6krdopPLnzNX9+ai+8YsLz18LfBDI/8MsUJipyh/XNUrYLsqjIvPKzZYcsgBusvdAJzgrKCkQuprV8wSqOcyPzY/atGePaV0jDrKpL2+x1TvAhxf7JOUcqm6GMLV8DqzjLYqFB2dV6J8ahB1zvr/7KS1uQy4tt3YcyUkcOi1AHrI4LBvhwy1ZEiCpuPvV7ycCkJ9LIH++w2nfK57GIU368oChc
 a1k23iV0
 cB/1lb5teNQXslZ/9h7YCa7otfLlnln4OWbCLIxFzwYy4fpR9YOfhK8RmoRQiXSlw05jorONGTmvWs/qWQUsLX4FXGvK99+2nAR0KnguV4D4WbdsvYQyVEUCNxVNK3LqcxhTZ+YTfcYTeXvylqMfVkzZGFlMgZTpUcf0gQ8sOLsP1m/AG0rqGjaGQT888x+nHdqPNh/wBsoTWi/lNGAUszfb2EzwBeFUMBF++zWELRWZoFiThVLv7XpCLyrkRZiRNgIVl34WqXoL44AyHfyKhzBjCu31D8yTEMoAqEw6muq7a5EMM5PRK2zt4jbTlvTQn3TQzPX10kNZaAGvdjrqw+O+6sF03IF/mf78ho3ysauDVEHM2OFRGl+Fl80AfQvCP9PYE+VzhbltEgUWwGzX3B4SKexIwBoYTgq2VyPkJ+VGIKg6xdBULRp6+i4jXzvUZQJwjjwxckNJrYox4kdJJjUBGECUmTyADYxamrAkxJn0fN8sWstnVKvgx6/yNQtC1L/8/Cf2r5qzwFR9GnOkvFpW0aevzcsP20wX5blB4dF9U38cKBEvJzFeaS01S2Plu44ZsP40vhMyQMVruQoDRSk89hWJrfcJAIYlT23ycs89NrC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 10:22:57AM +0200, Michal Hocko wrote:
> On Tue 11-08-26 13:31:55, Shakeel Butt wrote:
> > The v1 soft limit has been deprecated since v6.12 and nobody has
> > reported depending on it. Start the removal by decoupling the interface
> > from the implementation: keep memory.soft_limit_in_bytes, but ignore
> > writes to it and always report the maximum value on read similar to
> > what memory.kmem.limit_in_bytes already does.
> > 
> > Writes are still parsed, so malformed input keeps returning -EINVAL.
> > The knob now also behaves the same everywhere: it used to return
> > -EOPNOTSUPP on PREEMPT_RT, where soft limit reclaim has always been
> > disabled.
> 
> Is there any specific reason to not return EOPNOTSUPP for everybody now?

I followed the memory.kmem.limit_in_bytes example. If you have strong opinion, I
am ok with EOPNOTSUPP as well.

> 
> > This also fixes the syzbot report linked below. Soft limit reclaim is
> > the only caller that runs shrink_lruvec() from kswapd against a
> > specific memcg, so it is the only way to reach lru_gen_shrink_lruvec()
> > and in turn set_mm_walk(), which warns when called from kswapd.
> > 
> > Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Anyway
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks for reviewing the series.

