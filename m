Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35EE3C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 441B16B00BA; Mon, 13 Jul 2026 12:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A4D6B0120; Mon, 13 Jul 2026 12:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357C06B0121; Mon, 13 Jul 2026 12:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7856B0120
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:29:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7437E12010A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:29:04 +0000 (UTC)
X-FDA: 84984287808.11.F80622E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id CA82B180006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:29:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AbywF//u";
	spf=pass (imf16.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783960142;
	b=EeDrU++5B++10PlCLO51mteVnczTzQyASiG4cx3HGRXMqHHKvWSx4WoRM3vcn0vgGqZkm5
	oKFaU9fT1AcbAC8/FzuWmlQNjlFQr7Bvge/cYAl8zR2NGLQPSq4+QNpA7jQBvWZSxJKtId
	Ixn8EEEP/borbbkHAXx5kd4NYdFT15M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AbywF//u";
	spf=pass (imf16.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783960142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CFDmixcUjoeF5+PlFwCEhk46S7uxAFIdPx361f4C1CQ=;
	b=UexeG6NjwO6YGxujwDoJehtrJ8693VUQj+PlF3/ksXO4HqIVYnElme2j5QpXZuiszyWf9U
	Pa6LRWEAKzdxnUUn2JTjIOrYzQFkvWidnI9tR4qyvOtuJiZvN6/jn5y2T3YSGxgexy/HIL
	5Rl2KHmWunmVT2dgVIeuhRi3RqDWArY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 102F941FC0;
	Mon, 13 Jul 2026 16:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA341F000E9;
	Mon, 13 Jul 2026 16:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783960141;
	bh=CFDmixcUjoeF5+PlFwCEhk46S7uxAFIdPx361f4C1CQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=AbywF//uoTfPbKUnjWCbbXRhBTXlj10/bnq8WvBoRKz3OyYZQBjkWUpVRW4sS73uQ
	 k26h8Gj3JQo6mBpxHK5SbYlTHdo6ia1xxwIQoV2vfyOvFpQHHMkcvtza1vuPhIx2Th
	 q1/04r6c9gAamcYGBJAgz97VNhNiA37XNLrNALVPnZPbKRMuhv4+ip8kcBEZUm4HmI
	 8pncJF8EFHY2ywf3pHuGLDcCAvDe3BbGzrBV249qfZcDDOPojNt/tRgKwJzP9Eg+MW
	 vlmT8ur589pf7NICrCU3ocwDci/vDhuNPoCWNLO9weFX1WdPJTdZ/b5DjtdXRv7PEO
	 WAFwsZx8xJ5dg==
Date: Mon, 13 Jul 2026 10:28:58 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Vivian Wang <wangruikang@iscas.ac.cn>
cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, 
    "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
    Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
    Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v6 0/2] mm/sparse-vmemmap: flush_cache_vmap() after
 hotplugging vmemmap
In-Reply-To: <20260713-mark-after-vmemmap-populate-v6-0-b945ceba29d4@iscas.ac.cn>
Message-ID: <4bc663fc-76ae-f6a0-32e1-6f9b1610f790@kernel.org>
References: <20260713-mark-after-vmemmap-populate-v6-0-b945ceba29d4@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CA82B180006
X-Stat-Signature: chpr5o6kw7b799hrt6u9idarra8gb4s9
X-HE-Tag: 1783960142-548345
X-HE-Meta: U2FsdGVkX18kuRmn+wUGkoojOZNqjCDEMF/WKNqX9He3QGKyJ0T1rbPQzCqQds75kO4ySjUP45W0qm3RwJgBbPTTjzcgPpNM7HdUFDjZ50bJzuvH1y+jgAtZXGcF/Dy+EDoEc1WXYmROf0FEzBlG6atN5uxwF9axrN13ugpgI8TncHZTDm9hgk1vk1jB6wHSyAUp//Z9E7LeKdLqvOldH0TscihRlHT8CNOQ9FRJLwBDI6l21gKu6yjWbUsAG9oa4lycQIm+Xf8A8DPwlOgQUb/iwNVxlo5as73A9sg3Ph8LFnmZ7E35d/o4yNrw9pnDhEv1/M6bzZWiSeYiVHntQcBOV2roTgF+qNMd9VB7//kK65s0T7ZHHIb8owizSU5TVH2semogcEYbOTuwVBzXebfoDEP3p+lpTCSHHxj0g6/vcZkDu/POxpZQz4jk5kMT5x/bLOl3yvaNOXlglXamRC4ITAQT8HOQWSNuV/u6dpE5+tqs/i3+yzBxbqx3rpMUVuFfBEc8G/JgPLuyb98Wevxl89HG/iyktlHqO1fC+kjD5NlSD7T8GkyFL+9hDUbq3vfb/sw0+adn/m5l+gl3+SRXvgRUMIzE4ynYjMWJ6tPAhecisByoU7oURja5xNvrqsJP0UhfNz4Qx3/RShytKBcP0SPWXxs6RkF74sPCGtYqRs0J/Vzn16Gy3WLomo+61nx6iwhhzDye6XPJK7hzP+gONbkx81F6rJU6OHMAqiIHjeWCYWRbSXmaEdoOCah987p5kG0YtAPtQ008RRGGrXSMdec82xrulwVqhV8UJ9D4Czc101lQCqbu6FpyifnO5p7wYrXLcZfLw3x7C7KMd6e0vSjWm80tQFeZgqgUH1QnprIwxbmWpYATWsu1WYbGSFB6cppFUzHUjYhHHNh34oktOyRNzdyVep639N6zSWt45+q4MIxqHMiyh+NmHwHHU1DdjUbCMhk7mtBZFfU
 vGGUJpun
 KrR35sr5pYqRl8twRcBIhW4W28z83qIgHCeHZJ+Uw0AZBmh/E439xnJ9hv6+HFKH2Fg8wQi7VmrKt62LSwVWUKJ2wqmtUwHA2zU+36ESkgU2GuHbu4/rnDLDl59J5vnd0/Yi6vFkwpezwf9Nh/FyZbRfoV+sNT3dMGljvwDuZ+2k8ETcPLrFM423gWY8DAhoJRWRhv8iw3J7LJ4PVLCcekk0JKaBVgJ1hbLQsK1pa2v8+EAvKuh2Gj29dbFxQA263bcLcdot4s4EjPtsz4Tq0QM+wYcR02NgxO8Iv4FWJFfrC+j3cAxEaul0GPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026, Vivian Wang wrote:

> Patch 1 is a bit of clean up that fixes the compilation error with patch
> 2, since VMEMMAP_{START,END} is not defined when MMU=n.
> 
> The mark_new_valid_map() thing doesn't do anything useful on MMU=n
> anyway, and the new_valid_maps_cpus_check code is only used on 64BIT, so
> I just made it all of it conditional on 64BIT && MMU. I hope this is
> acceptable.

Thanks, queued for v7.2-rc.


- Paul

