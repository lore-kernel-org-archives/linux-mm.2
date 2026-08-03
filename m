Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 494A7C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C91C6B0098; Mon,  3 Aug 2026 09:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0786B0099; Mon,  3 Aug 2026 09:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B65C6B00A3; Mon,  3 Aug 2026 09:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2D96B0098
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:12:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7334F40643
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:24:51 +0000 (UTC)
X-FDA: 85059272382.13.7FABFF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C5FAD1C0010
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:24:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNcjlv3x;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785745489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZW8Xe7TSzJ7FXXnug3vpzOQOy16s7g8Ksg66fFK9aY=;
	b=uw1HKlKCqwT4EYIFSeaaCCOvKbDi5kAplWi6ompsTzRvQfmNleVxbhGKKCMpaFgtRhTH2j
	hrkJzOvhQfOhXoclMu2mrA8HMLbCVJodx9In2ecPZ4/fmllLFvXpBNJG7zD8Hh0utOqM0K
	+at1eKgsewNSgAMMdrI0WpzyN0Usv0k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNcjlv3x;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785745489;
	b=xtsl0/b2JdseJYqOBG+MOLX+j9mov9g0n1ij7ZNKu4FrI+cqdy+kWO8DKMEoMPjoqbckGn
	2ugXZ9FdsPes3uXcBmrtY/Lu9fqdjXtZF/DCU2sSFlkv8HeUmybqRQWoiNuR7A2PH7t0W7
	tg4cIHIC2j2PGCm1SOyOjry5Izs0aqY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 457FD600FF;
	Mon,  3 Aug 2026 08:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84AE1F000E9;
	Mon,  3 Aug 2026 08:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785745489;
	bh=uZW8Xe7TSzJ7FXXnug3vpzOQOy16s7g8Ksg66fFK9aY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hNcjlv3xU4tfnME+np5OMyup34YXRO6fAka2C7GGyUBrNGRXsfICH5gbQCIikY6IP
	 Hn4mbWmNO6rpbymygca46hhgJ/RcVVEttBlJmFAAprsBePsmjSf6t6tzC50FHRKwtf
	 qxYHufouiki31FOR8CeIeLuvwrOoXk+lmOC0LSXtBprHWtSnhUCxBWDPdmO4Lp518b
	 R5TOuV5ltQmcL4n7CHveqTmUuqUUFTdUvkcWLe3SrHsQ/BWkHASQtnpL68RovVEHou
	 KTSJNJh3E0T3dC2Zu51Befi+P/bJIKTze5d3yXZgZtjG/juNXzQOsajw2ZVfz3TwOC
	 9xQLuvWAo5U/w==
Message-ID: <27485af6-fd17-4092-8c3e-6571b9bbe222@kernel.org>
Date: Mon, 3 Aug 2026 10:24:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] tools/mm/page_owner_sort: show available sort keys
 in usage text
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260803062056.1518070-1-ye.liu@linux.dev>
 <20260803062056.1518070-4-ye.liu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260803062056.1518070-4-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C5FAD1C0010
X-Rspam-User: 
X-Stat-Signature: 97rgbjnctp7dcohozgd6n3qwu9t5fi86
X-Rspamd-Server: rspam04
X-HE-Tag: 1785745489-700642
X-HE-Meta: U2FsdGVkX1+6ktmpkfTOs56RhN23cRLN/tCwt4ruycoa4TzhRoLYZ5Ak3wSPxCutYgK13CEcFhj45DwXEpkW3joptHmsKDGDLJFMF1B10t8NpXq0JLY6Q2n8E5JoUr8D+VGqRPkxb37qTVQjlpdZgGJ0WH/Fgph6JOPcFMVbRcf/ZuZMh6hlnez8mf3rG925sJxRjE2S5JJcq4DUUOhhkOUR2Ew4i0+jhx7alEKR651crD+oA3ZY7Gl9Zr57X1oKW6c1YnYt1zfrMlOkGPu3Mzn2eeX2+w6f1MLW3GwZ6pelEFPps8Or7TZTZqdyiJZjrf0j1uA2WcEa61lNgciCAFX7o3OtuUV9ozHaGpCWIm4jz04V6i6ytOBxhmz7ECdJemzBoHs1DhgyknnNqmLWkGoV1ROByZFkzlB7yFwa998esYDhIKfJYQvr7tPZdaS/t6VU44QECxm6Nqy4F7vKy0QLTbakraIwGQWxp9A+i0+u622E9Yrqe+8aem59dIcrNBUkm4sC4GIILG2uWcjjqgK04gZ6NSQe/7VXK2GdkioZPrk3AY5fDmjQHPO/68Aa6DRDxZjfLVun2o/nZf7HuR/VUkrfU4tzvjpIGy9MyIJ6xMpjV/wW1a/r1JVqUtDME6SBwfyjOWTsll6VwI8tiU9oEMI5WCS2dem/2ozaprQQt6OK5YWttKHGv+q3OdVNSG7HQPrjMkrl1cfzRmmVWLRueAx9h3ptMccfYPnBL34GhVnX5hhOXEibuakG6oAfMpK6txvxBPEZgr8pfy+FgQeQEAKjwrLO0TtJrfhsDrq7jU2EPYzEofFyuho7Qbd0kP9L04UHbyVCQokVy63vRX9GPFhXlV5jpfMib2HeGIK/wrt43FLvikZlaiI7vrQi1gx1IRunkGYrJC3cUzqq2acMnju050Q9usVd4wiS2i3RGFD3oafmhW1fzUBhKDFuxe1lrLOD6zGvTzW7tJN
 jSsHbXmo
 nQoZsvq63MCATOLOfLgP6dC3JGMAv8LOGqODZXAeJbguXkxr8Zh/5Mtrn/9WxoqeiRq471t7x5y+iOBZlBErEzviQA5qnWWE1I5PrH1E2bhGSdsqnGnuSeXJg/dJXiSjg5iUzkzUV8nioRGDxSzPkrum7dXUVd+8h69x7g6QaXPhosux9pyau18FBG1OOWtHHxrTuKBDJRJU7IdWrrUblmYwY+FpgQjfSbNpfck/8DXFARuZ48bFaXVEo2rq89WsPEVRO9SbKB2l39Xw1vt1fOoVUNIKasH5Ii1wAeTk/aEydfQIgRmk26EqY7jtdRmjr2J7XQs5/85VsfYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 08:20, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The --sort option accepts abbreviated or complete key names, but the
> usage text never listed them.  Users had to read the source or the
> documentation to discover valid keys.
> 
> List all available keys (full form and abbreviation) with a brief
> description and examples directly in the --sort help section.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

