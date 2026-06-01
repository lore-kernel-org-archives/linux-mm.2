Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E00A1CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D10D6B0447; Mon,  1 Jun 2026 12:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8BB6B0449; Mon,  1 Jun 2026 12:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5C46B044A; Mon,  1 Jun 2026 12:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 118F96B0447
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:02:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A468D91441
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:02:05 +0000 (UTC)
X-FDA: 84831810210.30.775E450
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D2DEC100003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:02:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KSPJowpG;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780329723;
	b=W8BVJmtBKo1n30fxr8AhiHTD3Yx45+m3dJX5A3NSHhc5JlqWkP0AWzBcJa1QuFGdvZURXQ
	WHEY624FNyzUXc/9TT3YdLzSGYHKxLD67+eAp54eIURBSLL67pptMA2uXEjbEAe15ZVNU3
	rtCFh4eijNBOPbaTSAkHOLIaudtpQ4Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KSPJowpG;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780329723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uYb9Mgzy8PSXvySU0VfN77Z6O1JKO18qgUu7id2miaY=;
	b=kMvkLe6DfQ5I0kmWzlHaFZcZfOg88Jwajcws32hISbrgWKaFQOmRRu0N/whEOaDAOAgkKi
	rp3uSBDS2DlpphBO6TI6fS+xXlBmdIhCJq0vrTNCGVb9rFTXmyh2fi0jvDvQb2oNX//oQW
	ebivqdbErFzN0nMih40CFLew5OlADzc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE8D542B20;
	Mon,  1 Jun 2026 16:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DCD1F00893;
	Mon,  1 Jun 2026 16:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780329722;
	bh=uYb9Mgzy8PSXvySU0VfN77Z6O1JKO18qgUu7id2miaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KSPJowpGOXItRHd2Yy7nW7/sB6nhrfd6QeMJ582YP/svwRsgDyWqGIV5W6A+mXbrW
	 i/XpgadnobUyE/M29xCMT68bm6QhUkvn0P2oynxzZreOYpzE0i5fuhHSbSuMh7ZfdF
	 DhwBLpU9Hd2wJWLWKXdxzrKHN/LIVVxhjT+0avUvJ8ik74th08G8oJYt389/70m70E
	 meeSyFaNu8uYElINmMMzKeZC7nSMtuiEILoFsdVTe9N7HX9oPhqsQL7u7uvpsAW0tM
	 kfCcc5eNSycbKzVpjY/KDVV+ZGykpdvW+Yq0js0J5A302QKYrrfR9n17HY6b5G7zLW
	 rbNh9JuJ6R+hw==
Date: Mon, 1 Jun 2026 17:01:57 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>, 
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
Message-ID: <ah2rKKATQwGN_PHu@lucifer>
References: <20260601083044.57132-1-ljs@kernel.org>
 <cd8b6bb1-5c42-47e4-8773-2c301a029372@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd8b6bb1-5c42-47e4-8773-2c301a029372@arm.com>
X-Rspamd-Queue-Id: D2DEC100003
X-Stat-Signature: p4d48bk5dyxw7auegdbn95t88jm3zy4x
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780329723-319166
X-HE-Meta: U2FsdGVkX18P3YXNM+1smEzlLK5E1sxn1e1GDkRbBSKSZGyxfWCH9QehJJQg/9b4QFEPBYp1Z/gUuBsy7hTWg03JvNYL8LhHeNK+lbdpBi3LrbGok7ZqD2BqtgeicoZFQ2inA8YuDBvXG0oPtkUTYKXoeHCmDLLLIu3a8duWt6+r2olMyYuI0Bpxh07FGDCFEAW6kdkZBeugxCzr76f96cpkFrMznsg0a4b1Xwg5j17nEImh68vcI7mNn/BMwgXe5SFvRf5zP8WRzBS4pwRyZ043kA3PyNMDmMdR43tmfkTj/h3yWdyWO398bJLYx7CkIRXGoR54rWS/AYwiRn49FJmoQiOWfsOgjl7tzDBtNj1YfQvLwT021S2SwXWd+ntVM6dfJH30KzRtihb0h9O7gEjGUTIqjsVpjC2FIFRLGY5IW4p9fl+SxET/l0LVCtn4FyiLZFmpSSgF5pUdgtjMCTAr8T88PbVtlFxQOd31cI6uxwV5kTmyHMv23jVyfZVVOjhGrXMv29acpyUl2wkXsJJWxuPBF939SrcS7aOnbR9NAVfdc6uqzHQqFA6IawkVgiBWNJCzLUoXuRaWJQ6NAliBy1cuetdmWTdD+sJ+CzeLuasnv3JQ3cgZNy0OusEO5qOxOxrY7ocHyPwGt0kcaJv3ScJl7oP2SL5yvNMNeBXNI/dztwDJ1sXA2pG3XmHwWFbjXBiBAeRUOZfUpuL3/Bem2wDJfK9XIsTUCBOIlFYXCjfvoT+/LurNw2tj4ygAieoUx6d+pkYwpA0p/W1aeCf/SPA+RASgzMwHZHOlIhw/pWiKU2CGQE8La+yGwdVSxTHOCwQZVkGlt0D3y44as2TScl/WIkj8DwrP9xL2HonROs4MGObXRef6gmRoPQ2BAvSuf4vuJ/d488Bp+mvAWo9dCTZ4SXkz8OsGDaNIJWLIRqSUUMGHrxH6KKcSt4ygno2ZBSkDFiLOV64/VwF
 hPv9v2vJ
 3lGfTExPvFypSMx7BJP4qIFm3GpOyTgWXdICjveK2SKtSQV9RpuHfWLMQO7UaTvE+d7WfT8EW1CVXxYawLJ+gL/4MhHkpTAhTJ2Uj1RABsn837H6jMBpaErxDCLuTuM7v7TSttlTORL8ZBJDpMKuNoz5N/I7EAcNhziA3DkiNwS0FGLQiIejPExdl5UFFDCl1gSOyvcU7jxrDjVzfrEipQd9KTNrBNxNyStS74URpRMsWmV5rHwrgQnAote10GWpSOvWsdjyMGQf1l8KgsS83WI+LPjcq20OvBZyUF3x5CG+qLY73WmnhnO5Cr7vyyO/KQ+zZGfXG+r58CIVNcj7Oo1wrCAv5O7IoK7WYYnP9NUDaule9FDCbgNvHWvLUQmIvb/5a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 09:20:51PM +0530, Dev Jain wrote:
> Sashiko continues to find existing problems :) What do you think:
>
> https://sashiko.dev/#/patchset/20260601083044.57132-1-ljs%40kernel.org

Thanks for highlighting Dev and to be clear I'm not yelling at you :P I'm
yelling about this aspect of sashiko... :)

So, this patch fixes a serious issue that renders THP device-private
completely broken in a way that can lead to memory corruption, and this
review comment has nothing to do with that :)

So TL;DR - maybe as a follow up?

IMO there's _no_ obligation to respond to stuff like this, in the same
way as somebody in a review saying 'hey here's this unrelated broken
thing'.

And this kind of thing should _never_ _ever_ block a series or patch.

(I kinda wish sashiko didn't do it, I have extremely limited time as it is,
it'd be better as a passive background scan of existing issues or
something.)

Cheers, Lorenzo

