Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F493CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 20:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 386C56B0088; Tue, 23 Jun 2026 16:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3360F6B008A; Tue, 23 Jun 2026 16:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225F86B008C; Tue, 23 Jun 2026 16:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAA896B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:44:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62418140144
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:44:48 +0000 (UTC)
X-FDA: 84912356256.12.79B1489
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6DEB2180002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:44:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=LQb5Q4AX;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782247486;
	b=FmtlQUuJtW0p9ZkGSpEuU7G/hvN50hQKOxiPU1Ce64lOSpvQrlI0mXgcm/9APHDb6E7f+N
	FSgXcM57l5pQbNIVcrWcGOjA2qk6bE4t0wCl2G6C8p1U5708WdjFFRbz7bjPCFEgN8U+YQ
	tV1aCqyeMAQJjwemXWllIq4dmlTvna4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782247486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/GXbcxhxDosqTJ+sCODRYXG+WQ/GMMMUnDuHdmb1hw=;
	b=KNS3kruXfbdhFv+sdY1QgobbjMnYSz/zoBEOFKZD46fsN3bR43jLh2mIlp/WStyW1Fwp8q
	/mrMXQWW2b2vPEH2NNg1CxNJ8Z7wiVuP0zxb2RggFDGgIDTsB9gufduZlZm24eArw7p82N
	PWu6k5rpwWAFOQH2FbQ1JkVs58vRixo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=LQb5Q4AX;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1782247483;
	bh=Q/GXbcxhxDosqTJ+sCODRYXG+WQ/GMMMUnDuHdmb1hw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LQb5Q4AX+Rx0nVbM65YeNcgJOpeXXWoHbUaxjJ1K+JuH2i32to1rctjLRaWGJ9zic
	 5CuoABTSF3pPyL/PMo2DISCM5OGGNu4IvoaroO+9ykKcEZj7l0JyZWlXs8cd+U7NSe
	 sHGCt7SBg+IwhgOZgtXWQhzPJ/Vn/4npXi1uKKXwxjOfGFHnRG2XLlJJ0l1TaRBIuE
	 s8lXOCA1c6a2mA8B+PO0OzRN1h+SnmeO65KAXQs/AE/6PN6LdexMZ6hA70/pnfupus
	 2ty7jGNL454wtTvSybH//kdwZBrOxiz65IqQSeRI8lfJ8lkVr/NGcpzcQ+8jQy72lf
	 +Smodgac87GqA==
Received: from fedora-2.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2239117E045E;
	Tue, 23 Jun 2026 22:44:43 +0200 (CEST)
Date: Tue, 23 Jun 2026 22:44:21 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Christian A. Ehrhardt" <lk@c--e.de>, dri-devel@lists.freedesktop.org,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/panthor: Check VMA boundaries for PMD mappings
Message-ID: <20260623224421.56dba65d@fedora-2.home>
In-Reply-To: <20260623220341.7ad4a0e2@fedora-2.home>
References: <20260623181942.1536598-1-lk@c--e.de>
	<ajrRhpVH6uhOABnV@casper.infradead.org>
	<20260623220341.7ad4a0e2@fedora-2.home>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: htxk59w15pk3g6xj9cwz89xksrnbjoza
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DEB2180002
X-HE-Tag: 1782247486-752096
X-HE-Meta: U2FsdGVkX18sI3C1dOLP9uP3y2GCeKLG99BaItiwyC81U9uqqBbPKa9/W+haj40lvnBNyknBq1EmbBkYaFi0hjzHCXSQZT161xt1/umjjKxoKUbeJKGLw1Mf1ncgths+CKjeIjSekSD2Xe01TFS09nn0WCXMwO8oY1fOThBOHIJ4HOP2x+EOcXfFUZMr/ryDIvwAnUg4t2ieWBsJ2E8Y9/vv9gTQUl6HfxFpry6mKMIPWinYFXTC9w4HF9ODNid8nIT6uL+5qNhRrrOVrkQaFZJbMq5KjbCJ+fZnY7RLQMNhPU06AbnatTumQGkMS/BUO6NDQ2MetK2GoEbgFY169aorDyKh6XNb4rbJup7rIclf+yc2Il70ji6UfGPLQLBhzqlbEHUR3fm3f4c6ZObzri4e/vparWFYAEpgFbGM4xZcP02XKWsX1hBPOR16BNBuPP9d1rtXihbU5+1/B5miNaMQMBw8ga56aiu6DJYQ6nsuvyhf2+6G4LP6b6n7+qLeDTaM0hI5WO9hy3IzNwfwdi7KVxBx8NY5/gLBMo2cg4Ga02KYsHq4mdxXEy6lVw6X7C+AXVdQc9UsT9voemwlVZoc781cYBs+lgOxjf6FiiozMlVldOmXIGfJ+3DVudbX35ulAYY9+Gm5j1ZfV57TnFXpcpwsIDiQcPi8oCf/1z6iBx82yWe0RC2nrRvMUCkKusNTT0TUjPXWak+8YYXEuXQ4S2zVet3BnVE3GXL32gN66uRtG5TPaZCBjZvaPDfDci3En6uB9Qf1JyO9e1z1f4CZpm9HwSJ56rzp9EZR4Wbw+fpKrZ2Fi83YvbGE60fnxvcltPYdutQ0I1ZIJ72uaXRT8vZDmxOwOPeMgwMFRK+6mwklXULfbQEAQQP9yY8J7eB1gsj64phhHL/GjVqXaYE7hxCxIXburFjOi6o7Ay4qiqbGlkjF4GmD2YKbT3wiv4hjjsMOSrzTnPdpORc
 kDvQKcRI
 5mAQ1dGm+FWxaXA2fL/os9BYAhpV3FJ6TyQcYjRZPanBWOYooDYcVo0obdUln9K37BCPio0AcSnNzAtST4J5MbXrr7RtggOlD31H9kmeOnP30CqrEGTMc29yje/X/EWfN/NSaiUQvYdhK8+lRpN8OoY7gDA2dooSmMBqEkfC1Up40+8SkBREra36U+u/2MOl7W63wDsZIPPVRZziKwOEIiUUGX0o1NOWKw9hOmZM9f+SQcf9Z3n+T++tGm6gr3/v30PGJYeN3AvViQKMA7jyeeVEJGSUac9rE0mClyOZ60OKtLt3pIL4zY//QHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 22:03:41 +0200
Boris Brezillon <boris.brezillon@collabora.com> wrote:

> Anyway, I'll try to get back to this map_pages() implementation, and
> see how we can handle the fallback when locks can't be acquired in that
> path (I assume this would mean no PMD mapping in the fallback path if
> we get rid of huge_fault()).

More on that. I had a brief look at map_pages()/fault_around(), and it
seems it's only meant to populate PTE entries, not PMDs. Part of the
perf boost we were looking for when adding huge_fault() was limiting
the number of faults when adjacent pages are touched, but the other
part was limiting the page table depth to optimize page-table walks, so
if we're implementing map_pages() without huge_fault(), we basically
lose the second part of the optimization. I'd need to check how much
perf we leave on the table with that.

