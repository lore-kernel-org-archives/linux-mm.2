Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1932ECD8CAD
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533EF6B00AA; Tue,  9 Jun 2026 20:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50B966B00AB; Tue,  9 Jun 2026 20:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448126B00AC; Tue,  9 Jun 2026 20:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 337426B00AA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:28:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1173120834
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:28:58 +0000 (UTC)
X-FDA: 84862117956.24.217FDE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2994D140009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:28:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j7FsShf2;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781051337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4E4UY4FfWUNC2nK0Dr4oLj0xnMk5zECoJncsDnalNtw=;
	b=COQZK6b3EEgLfCmPR993pQyQ6MAeC0SitDC06mt5KpBYQetWUe+XTySFlX/B606UiO2lMY
	jdJZjHBpeb0ESvMJXOH+15Uo+YhCvNnnnv9cnV4kfNHPpLjY9CDQ8HySh6MTbdflroRKKM
	qyk/oY6h4kBCcc+lBuO/ufUOWZYGKBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781051337;
	b=o15VCuS0L2Sjw2SouM9lC2eBS/nQOOJF0C9yCvXx6jKi2b0FESZt5GR37yfykorA/jubVU
	N0pAbcagkhX3xGcwE/aVu1YaUNM0+EaZ+Vjb9CjpOgvXouyeb0dauWDt7Ynlv8BpMAZac/
	E/wQmMMjY1HaTs3xAmGIQuDunKzAtV0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j7FsShf2;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 995836024D;
	Wed, 10 Jun 2026 00:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438871F00893;
	Wed, 10 Jun 2026 00:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781051336;
	bh=4E4UY4FfWUNC2nK0Dr4oLj0xnMk5zECoJncsDnalNtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7FsShf2j4vEawnYKBXki4gjQLNiBbfrl7pW8mNu/dcG6VuRCm/D1a/aa6lA/ESkI
	 QVzgWuKLiwkKfkYaAoXAKTOAmg7eWokZ5sFGN/CFiDYoeQyIxDFa3Y6Erqa1le2QXO
	 26eVOIETmn77ObZTc/4Ja33Aj8YNZ9EW8fmYhh5Yl7K4ZZGqgh6gc2TRuOYONwJjfZ
	 eegMU3yx2BvxvHc3uhgr/oXeg9J/Biss+RDdJoAaGip/rkXLLKyUjO0r3CAQBHtTBc
	 THLxgr/18vwkM6Zo87bbeEa0e7uZ7n8tt8TMDMLQjgBOxz0RY2SlfeaeT99HiljVGG
	 qPK9cdG2u49AA==
From: SeongJae Park <sj@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	ranxiaokai627@163.com,
	linux-mm@kvack.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org,
	npache@redhat.com,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	liam@infradead.org,
	ryan.roberts@arm.com,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: Re: [PATCH] mm/huge_memory: fix memory leak when kobject_init_and_add() fails
Date: Tue,  9 Jun 2026 17:28:45 -0700
Message-ID: <20260610002846.77541-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b3a6dc63-7701-491a-ad06-ee0be7d23123@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2994D140009
X-Rspam-User: 
X-Stat-Signature: wkxd5xd1xpycm576cre3949z5tuc57qp
X-Rspamd-Server: rspam08
X-HE-Tag: 1781051337-876317
X-HE-Meta: U2FsdGVkX1/jisSfSan0Dn0MkDlQWB4Uc+AwwRCgT7pDuxz4ExhAK+6mxA+McZNloXtNA6uj8USjpiB0U1vBTCB5xM76voERgqumMZPG0Q9SKKA97M7/EEDPLmyDrWyE0RsLC4SOWqpIzewc5j239KWJZNuoactHpcdK05HBh9myhTrHJMIao5cnBOP43JzKgHQ4cq3SfSMXziWFwp0JkAJ3voS0ki4r2s0cD8c0oh1FoFcT+fvcskNZJ7VeDrKPxKoaQvOG2VkTDJ1/UcHQdGffnUpy2gyxJbz0Qkr3pkN/L3l/aehY57TfCKGC3mBF1OTQwQeUUnLjzUUarxataCyWShMlTt2SsTla1mmRO6hs7jzdD+LRtmpGyiz2PbtnK2LGcVCNX5AZAfIWdHwxaSQq0I9pQlwzieKh1rDPopSaUO90kNxsDv1Z+FlFOClW/DQm1t8waWPRRYK84ytLndaVp3TjMiCMignIe/4O2NeeR1Qt8nczYt+or75MYHveWxjAu0lGBe78R7uhNmhgQk2sHDd+wkBFiumPmHYU0OT7kZtJQOp80GF2JTYlOXOxigf40cCT+vFrAtskYNc2QWd+S2988ZljJ07Z89XdT0KVDYsrzatsgY/j/M320XXlTLE+MKoKTxhCH0JePoi5/rwSU5aHaoD7w1/JjTaedlWM0L1vRFbyNLEvnWpN/Wupeh3XQT3+vpP1VKLubl+vpi5uWc3eGMoC+2aSMWVeAsxUSbGn8lu9ctnVP5QSIFLSfBF4l2hR/tDB5DsQdq56A3r/GeAbaCJfvwPrIx28bQxGhuFgKPJ75UCq+cF/Ke9Umyb2Vu6W/g6KOlxmJ24rOqKH02r+cZUU5ntCKawCY1+V3xuqwMb84GJmkg0A6/NICCzrdQa5xyfbuxVh5UKAKAsI4/5/r5zajRvvSbxGqcVn5FQH5DyHmi2MT49h7N7AUZOX+Bqu6dGt1Z2ZLGH
 BXng+K83
 eshet65eEQVKQiD2PwVgSRxtrR+lHpYhtkiKaItzDI/6SE5wFCNJtG2dmCNulaFaih6EyhbSsxQ9+oOojcGUXQwufMxr1n6NIjEgOrOSjf2KNgiHyOEPp0jvX8jevo29MJrzjRbUtutSulZuVNjgx7WCHcJmgrK8BHZpcSKGECnF7D/VX2N7CBFu1QVaJvhpmQkGeQfW/ihvDwkW09amsipPKyFMTvNjl8VfyinY85N2bfoGV9mtMor+Mnns9v885BelC2KJKMic1TkmFyjgoJOt4VytqDh4v/cTs4ChM5L/EtxDuu2TVBEDG5v6YVOIpn+hy3OZbUd5/v+Nz3EhkW4iw//wzfPQAks+xjslVwCuc6o3H1HswftOq5WN3/IcomTCV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Guangshuo

On Tue, 9 Jun 2026 22:04:16 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> 
> 
> On 2026/6/9 21:19, David Hildenbrand (Arm) wrote:
> > On 6/9/26 15:12, ranxiaokai627@163.com wrote:
> >> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >>
> >> As documented in the comments for kobject_init_and_add():
> >>
> >> "If this function returns an error, kobject_put() must be called to
> >> properly clean up the memory associated with the object.  This is the
> >> same type of error handling after a call to kobject_add() and kobject
> >> lifetime rules are the same here."
> >>
> >> This is because kobject_init_and_add() may have already allocated memory
> >> internally for the kobject name (kobj->name), and leaving the refcount
> >> at 1 prevents its release callback from being triggered.
> >>
> >> Fixes: 3485b88390b0a ("mm: thp: introduce multi-size THP sysfs interface")
> >> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >> ---
> >>   mm/huge_memory.c | 7 ++-----
> >>   1 file changed, 2 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index 653f2dc03403..601750dbe79f 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -790,11 +790,8 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
> >>   
> >>   	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
> >>   				   "hugepages-%lukB", size);
> >> -	if (ret) {
> >> -		kfree(thpsize);
> >> -		goto err;
> >> -	}
> >> -
> >> +	if (ret)
> >> +		goto err_put;
> >>   
> >>   	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
> >>   	if (ret)
> > 
> > This looks a lot like:
> > 
> > https://lore.kernel.org/all/20260411062152.2092967-1-lgs201920130244@gmail.com/
> 
> Right, the same issue :) There is a v2:
> 
> https://lore.kernel.org/linux-mm/20260412175428.2613383-1-lgs201920130244@gmail.com/
> 
> Still pending, though ...

I added the author of the patch (Guangshuo) to the recipients list of this
mail, because they may better to aware of this.


Thanks,
SJ

