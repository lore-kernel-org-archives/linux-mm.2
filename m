Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E94C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33346B00BA; Fri, 17 Jul 2026 13:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E46B6B00BB; Fri, 17 Jul 2026 13:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9242B6B00BC; Fri, 17 Jul 2026 13:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69C8E6B00BA
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:24:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0E6480215
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:24:01 +0000 (UTC)
X-FDA: 84998941482.01.8784A7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 54D57A000F
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:24:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOgVxDU0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309040;
	b=3sSlqVbVgzvve51aq3hW1n0hUy/E2t31fim4livK6m/+o788/Vdn/ZaR/sAv43gJ4E6ABi
	BXWLfMY79QqKyIl1VTLhI+/rk3xUbXxDF+hkI6d1u2oDWcCBMqIJPt6b+N0SxiblX5wprD
	fHnwBBzE7MLqtdzT8CQH8Px8kF2riF4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOgVxDU0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=FynOWi+8cbzPJyuD6qvzN2D1eQqr8qZ1mliz0SITIr0=;
	b=Ru9rb0/zlSzYkIN3X3Yto4nCTsfYBiTvN1OdOhVBHMRqs50Rpuk652XQ0AbCDn/P7t2a6x
	MZENkUATUWTm8ZtHtEsB/NXl6J8uirSyXQUWPU1aTubBHOzD4FeZAQCqiF+5K1xcBz/JRF
	E+PLfPeuNEa818wC421skOAQLOhsHy0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9287C43856;
	Fri, 17 Jul 2026 17:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46ADC1F00A3A;
	Fri, 17 Jul 2026 17:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309039;
	bh=FynOWi+8cbzPJyuD6qvzN2D1eQqr8qZ1mliz0SITIr0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oOgVxDU0z8Qq4CtxUlf931sX+yyyEkuhah/yMd1nyRYAW3W2Wju/EgaT5+2Ec8FbH
	 dawbYkDZ0zotSHBL/uF3c2BszxLSazLgst824ZLLp/uHWHRZc0GPRo2lzAx3spezsb
	 GAXxE9Q5Rc0Q9vRXa9NLlEEppLhRgJtpHFuPVRG9y+a5JjbUJufp0PmnHlkHjUlCI8
	 YZlSNSUDP9k02C592K4vmppHTehjxOVKIhz66ewMb6dwR8whIgUoOzm4aI1XM0QOb5
	 dxqStnSkmLYH147PmRinlTeSeoFLj4xTrNMY8c2TfVutE86mFIAPoaPTWXZri82tQ1
	 nFu185gt1hmsg==
Date: Fri, 17 Jul 2026 07:23:58 -1000
Message-ID: <7f4e784ee2bbbc23b4b97913e144c0d9@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 "Michal Koutný" <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v3 2/4] cgroup/cpuset: update some comments about the
 page allocator
In-Reply-To: <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
X-Rspamd-Queue-Id: 54D57A000F
X-Rspam-User: 
X-Stat-Signature: hw3ycbj778368g18cnajjpospzs4qo9h
X-Rspamd-Server: rspam03
X-HE-Tag: 1784309040-520805
X-HE-Meta: U2FsdGVkX1/NtzQYbUxqdJKJzDoJh8buDc774l8Bgw3A4OxUjydxcWdxMspiw20JP6CEZ4l/xubyzIJonqe0qDDnzpzZcbRU4xvuV5qxr6f9PJIXksqvP8xZ6EJrgy3YbmVg+ntsCldU4YYmraunGWBmpDkdcNKOHWUjy0Ne+otxs4xwQ3hneJLZXbivXjVbOsS2QMZl/VJ2Sd/pUV08QMqKMGqhOsXA7lnThoCM5bfsO1mz6ZqjWLca6UNzpw07oPRA2ojdvPIxRvTfYEeoAucLRU0zaRBKso9vChq/UWA6dH4Bmt2HGIrNmIKS3VACDTdQ/k7tJccUdQF0Iy6Nd1byKycrT80AN67XuvwM9EbEbj48lwak5TJz2jkDH9PmHp+zUgtVJrtLI9R0ErNCBGaAygWxwFMs3M7GSEd+NUzQHu/SVU9M7ciY+IAjZC62fRXTWpEU2atc76lLL4JMx26ih7C/h19XbJNjz4tkXkRnQVG8+4T5muv7xS26mPZCQUFqwZcj4x+B1UN9qEMEzryFDTNsfcK+g9mtLN7FK9yOGU/cNZlRCGj+FExqslTd9l5N9YJKByx/+yODHpwjfr0X6mIs4nH37tecQv1IPOiyzl5K2bpA6eqbtb33x54DTEyvEZhcKCshs4grjYTlvg24uaWvnLE0AGAI/M58GO3xHvS+dPvCewCWFvu49RYNGWs38JzIr1r5eKumh72s9LaPUp3eCObj/81cndB0B0HWC7KcF1tdEumBim/+qLFuVm0C1wZlOM1zw70nrxyGY004gG06rQFsJRDneL1tQu8VYMPVhmy8UOUk5CsFEOsOnCfVUgnesMa2r5mjfujtDUg5ZBAmCaDpvowZnwxqKbWMDK75leNZL0AkZ3eObMxFrXY3Jt91l5Yb3RgxN3p6cciTXDeyYma/rSr4y8wWEIA9mQ0HLs8UCLxfkbx1a0xq2puWGewofOFdXLUqxML
 KEY3Jqaa
 IOAC7NRMVs3Il0Rbh0D+4/nhc2R1YXzAer/1akpalDyhUQ9+Ktkm3DNk3thOU7zMOCSl40V2113Q7ozGVRiv7hQ+y/lRX3MRi+TtV8r66LkFZISt5Jno2vuus/eJ0WoLut019aX0ijqnE3k0rU5amnjFEWLXknQup/0omSbfbhsF7sXFfHyDBAAFJx1kSaaeFpNpsSDLzTT4HFfdPdi8lk7bfxH0nxr/EjeWJ7/9hlQqtzKNR70sB8t7e1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Applied this one to cgroup/for-7.3 with Vlastimil's reviewed-by and
Waiman's ack added. Please drop it from the mm series.

Thanks.

-- 
tejun

