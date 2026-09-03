Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C5A2C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 20:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EBAE6B008C; Thu,  3 Sep 2026 16:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A06E6B0092; Thu,  3 Sep 2026 16:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B9B6B0095; Thu,  3 Sep 2026 16:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01A5B6B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:01:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E68551A0657
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:01:31 +0000 (UTC)
X-FDA: 85173520782.07.BC50AD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 14AD71C0005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:01:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WBnLcCcp;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788465690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXUouC5ZrR7v9zjeOOFihml7UaPEh0xjvbsdR4q8cH4=;
	b=Vgph+hdj8YZWOyv+OQQcIX2DJPSu5HKPKy8PW0InvgeWsPUuicfWbqbZn4Ln4ioS8mf0IU
	yB8s4pPUsPbsBlslVLb8t8dSKeowN2aFqaiKPWh6HW+Y1caqOogNnn62jyfLLFqilEagq/
	9SzxmWSoefotg+B94MwlVSweSw6zKcI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788465690;
	b=ThFoSZckbEKvt5E2jglzt6m4jfqPRJPFs22GOmmjhLz9ab9MGaXn4LTRMp/M0yEl/zy10U
	8yDIE7cyHuxPPXJN51G2h4HqkAdvSlkwgH6mJdTL3AHSit/tJRDUF1QkygpVBGwSIEffu8
	FiTIPWyD0MZXm+Feq/Emmbm2+ZYP3IU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WBnLcCcp;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F7E043C76;
	Thu,  3 Sep 2026 20:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BEA1F00A3D;
	Thu,  3 Sep 2026 20:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788465688;
	bh=IXUouC5ZrR7v9zjeOOFihml7UaPEh0xjvbsdR4q8cH4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WBnLcCcpVTJVqdABoxFvSB2Sa+8mSerElIug58NG2muLX9XOPrhfTW9NlbWuP91Rx
	 FUH01R78/TN/OUErLi17t/4IoN9+toOebFmlGioJzABnagiCWEM4+99vgmr+cKJY+u
	 JA+Qdj7DRPGpu6DtIkkktTcXTehWqjHNp3vG+rFY=
Date: Thu, 3 Sep 2026 13:01:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Lance Yang <lance.yang@linux.dev>, Qi Zheng
 <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun
 Song <muchun.song@linux.dev>, Dave Chinner <david@fromorbit.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Xunlei Pang <xlpang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from
 non-memcg-aware shrinkers
Message-Id: <20260903130127.1d3b3ba8155b21a0bc10e605@linux-foundation.org>
In-Reply-To: <0c5aba0f-137a-4aaf-bddc-060118322602@linux.alibaba.com>
References: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
	<aphXPCn8isUVV87k@localhost.localdomain>
	<0c5aba0f-137a-4aaf-bddc-060118322602@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14AD71C0005
X-Stat-Signature: kj5hznbjdi8anewugfkhk3jdm4mu4zrz
X-HE-Tag: 1788465689-163173
X-HE-Meta: U2FsdGVkX18GFkLWDr6l+vszHotKgOofwNTI44w3Tcdr+rEQC2x/ku/hUIob7ogvuhowcipand3be2WE/cKi4l0WWK4VMJiNZsO/6enk5EW4uPml4JdiHRkGJb18GSzUckIdtRRqP0vvuMtD1fYdRFCEBsdXlEbsC/aXWexFkw+CUb8tMYYgcImnsmEdTvv0ve2VNVrz2q0mw+7rSaWVkQQHXjHrFWuKDLDxdGSj1wCGnPkG3DmJNP/IiCza2c+6TnklvRCeTrC0m0hLwFu2CI8nS/RBtRSVJotm6/mAu+ion17aCtWvcaRJFZYV0NTr8el9pNAc15MY0zsH2b778hkpclIWs5w7qBmgBQBpoY9NY4U+SFEcN19+OrBNKy7TdHWoITU+CnjGgpvYjYd2tPaXhNyWMbvfVJe3n6pybuucWlL9yCLcSkpolQqfvNj/GfhUFrka5Yw5JSUsL8On5Qu7z8YGgWZDHCWLhLNt3LuQlLY4+3rK3t7rYrjT45b4TWtPect9Q68xDzmpS3VtOrVt23bEVeJ6HKpTqf5VR7xWOsU1BJM1zpyslQKxz1YcjEorSPUVSkGGG/NFEyyWCyM9tvAbfLhuDJnSTL3zRSYLLuHCj1zDwPfTT8lPMnUEErA3oM0ZUkfIu1wH9fFrUHxEnxB28WX34a5PyYCUqlcK4CX1lch5hL8s0l3Og97Ihrjbtlur9ztWV7fYsQQvdSTyqShPgH8CAQa1ytMoYhBpvE4mW/6m6NqaH+U2EEAY5BAPsC1trhujHPgkrydJrvcVEw1THB7D0RoNCFNJeqfg4BEt5O4TLt4ukCGEk0UtJCbl/lxUIL9mbFGJGp+c57KX/4ip6YHqZz9m30ajK6K1YxG+RUvt6F0O6/gW95yX04MEt9Iwg/n/mb2XhHo2xPk1BmVj7xL7LcsowFMpfkFJQNnQOLhELesABuOoVkRdBwtMqFDzplxZtUCE1Dp
 wKKsA6ut
 DCljS27JyyuorBgKfXfh4PWe6vslN0R8Io0io7tHgKCVHEZutPHxZWZaxv2bNi0IKOouxZVy7lS44aUoCDeyHkmYlrnBjwOCrdJrCaOKn7dzxfwcGsm/+0Xz+Jgr1D8+7LJWYa7wFnah2xrRVq88nKxasCnHhf3WJjIsbKnrvkB3OFOkaAgLdhLaG/3V8PJazwS5krTVd0i+4+cKrsRE0x5vG9QMAMXe/wYA/rlcBUaDdYUOEA1U0fIKGLe1P5o9dUCh5zKrpGiALKPRcjyGpbNX8BvpYr5lHC/4BskULUY1+FrLPEURCXK2kC0qKhr8wZNcy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 3 Sep 2026 12:06:53 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:

> Andrew, since the patch is already in mm-new, could you please update
> this changelog sentence
> 
> 	"Since no memcg-aware shrinker can register under nokmem,"
> to
> 	"On a system where no SHRINKER_NONSLAB shrinker registers,"
> 
> per Michal's comment above?

Done.

Such changes can also be made while a patch is in the mm-unstable
branch, btw.

