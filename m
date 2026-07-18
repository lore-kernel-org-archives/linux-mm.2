Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BDDAC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 05:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC246B00F6; Sat, 18 Jul 2026 01:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ACE76B013F; Sat, 18 Jul 2026 01:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3CE6B0140; Sat, 18 Jul 2026 01:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17E026B00F6
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:31:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C8FA16033C
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:31:16 +0000 (UTC)
X-FDA: 85000774152.10.57DA08D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8138140007
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:31:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J8gwCtLN;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784352674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dLIszYNfsJNJUQOCH1B4wSKKzHLogHiFHjq0dxMjok=;
	b=6c69fiyz07l9Cp6pw6N/4WJN7glEcPUT+KgsCmHXhb6YZtzEKKH7yNpuJ3ljGC1RH5oVv+
	9zhlNwm/gKUJbdd1nuzJK2DAtcbF43729+/NEI4nJWbcD33vTBjDI2as6TU8MZiMMGeGl+
	uKfIZA9bZe9R/Ic3VhnLWK5jiKyEUfA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784352674;
	b=GL1U0bdthkp/mawBi5cUCDZyAlR5eVNvYMFaT38tEwDx/4/VuxVkbXzmtFLpOx57h9LJkP
	mjtdbBpEC8TrW3ZYnH0ZfFcPqSTvHczMx3sPLnePMz89ymC/JW759DkpVHj2iyrChj37yr
	M2KdCSszWkz4atnfGWb0taRIIv9+e5k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J8gwCtLN;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C0A460A68;
	Sat, 18 Jul 2026 05:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607CB1F000E9;
	Sat, 18 Jul 2026 05:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784352673;
	bh=2dLIszYNfsJNJUQOCH1B4wSKKzHLogHiFHjq0dxMjok=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=J8gwCtLNwxCjxM7xkBVg8wShlNaphqxmHgcBPvvNUOVOuGjVFdsi82rdxowI8c4qJ
	 /4IAgBfK1lvFevmpVAC2tvn71k5tVcccc0XL4XOMPeB0+QnEI+gvCK9thPBAYufmwB
	 v4Zk9/WwRH9b6KCOwUDQiBzxzMwKz8qrJ8NTvUoU=
Date: Fri, 17 Jul 2026 22:31:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ren Wei <enjou1224z@gmail.com>, linux-mm@kvack.org,
 pasha.tatashin@soleen.com, vega@nebusec.ai, roxy520tt@gmail.com, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes
 Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/1] mm/page_table_check: widen map counters
Message-Id: <20260717223112.ba8646377b103cae717580c8@linux-foundation.org>
In-Reply-To: <20260717221108.c6caf7dd11a47bd7c32aa6ff@linux-foundation.org>
References: <cover.1784337674.git.roxy520tt@gmail.com>
	<b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com>
	<20260717221108.c6caf7dd11a47bd7c32aa6ff@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8138140007
X-Stat-Signature: e7xwr7sd7wgcyk6hamxc8oip5t4na6n3
X-HE-Tag: 1784352674-414396
X-HE-Meta: U2FsdGVkX19v+2mNqph6fXRCLVCwnNqa0eI9/YJCxJ1TjwskxYo3Y0lXXq+e291wRkLVR7qLlL5Acyt68Oj29/cYHndIUAg8YFTyEqw9fYqRytpmqaKQXqjdOFRTweX0iGFVHWq+1zTSnoNseKBJR1NNshR84GacKcePgqJ5jR9/r8z+R58QZj6zpnpse3LUR4xBd0sCkNNyXjBI6eWNwP4amvwYQjOtIohxVvjOlabOf4alVWA0X2n47EPZoawR7viij07sERr9dMurW3n5VZjY2z6F2Igmpg7sKzDdvLk2NJh9Q7/d0QoNdj9APoqfqe4iKAFzYNp2Qv5AaBXkLuNVOSs2jFgN5joXlJW84yvZALCpOyrBgi2m+IJgCUbM3KfGMv6mUmztDJbB6h28+IikJPAw5ldUI156HLOA8RfT9BZwLY6CF5z66HoHEdFWNuzJyJOFX2iu6CIVIu1YE+O2AdB38ihvWlt/87XMXNk/VwSo6jbRiVvtsOcPd80VvGmdQOPK2pGvJ87fcjQgWvXlgjBU9hxRWN6NpdJvwHVFGDgbPHbW2VaNknYixkAA2OZxTrsCgwNfLcnnU+b5Q3djLzDZzYfLflyIaMLz/aFOQrq6jGgsuU0KrT9QeTL0JipHLhslTIBYF5KNOt+TnKGJyprn3p8KEmEbCfRCHGx8SjmEPB1Gr9TQD7c1vvuk1t4yuzQO0ZLLz+PUjqCe23UV6Ybuw1h/YysRiF2N962LY2VETP/BZ3v8uAOyNRWFtcsKXUnIg7FFAp35/WjjZf6u8Xyio7xtXU9XqpvZ7STsdO1NSzYA+WzCX0/ItUtsUldchwxfYPeIcx8KqpnjARePLPlK8Z5XpnTOOFkRsfivTu+AyM8g0wUjSEYi0EjBDwGCVY2Zj/7BeUpUBFO2+5HTEWyvq2Hjxf4Hczi90qNqEXu2OLNSZ4fNHi+DLCxBFS04xA6v/PG6JYuSjUq
 4q4X9eS3
 JZ4UgRUS8WMy02EK/Wl5IwNqcON7ZLsQ30ui2548jniBviAdycGpzH/yFHgBzMCfNcfBod/oRByPa9KQtip6/n9PGdOL0w71+Do/3ejiqc+evfVI1hEzT0gaeT5AO3HYlgFU826fq4M2l2WmDR1xEf8mBM4P3VfTO6EX0n3LLZPpbs79VhcYWD7frY2t2mvKHlccWxdpeP7K17BUPLw7VrcMxD6Nu6/lQmjEr60R3aqHKHY3/Veg7LCBcxsPcsXXEjc1nDf32k3OQbLnwujnT/buMd9WEi+IBk4eXwtDx2eK6xsWyYfXTpddZ4vE7U23mT/2mFSZQf+3xN0mqST3KFYCl8fGmvKZuOtfUivqsFWoOMNY4UAPJqjFTXgLahuUYZkPO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 22:11:08 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> Probably adding __aligned(sizeof(atomic64_t)) will address?

err, no.  I think page_ext code will need alteration for this.

