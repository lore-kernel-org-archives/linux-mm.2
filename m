Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A57106FD60
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 01:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBB26B0005; Thu, 12 Mar 2026 21:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07ECA6B0088; Thu, 12 Mar 2026 21:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98D76B0089; Thu, 12 Mar 2026 21:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D77C76B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:18:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 849481A0560
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 01:18:18 +0000 (UTC)
X-FDA: 84539279076.22.4EEC7F2
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id 83270160006
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 01:18:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K2AvzXAm;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773364696;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+7XsAoNKOaWOBAj10JuSqSpQXLhiG0oqQbVuG2+b/o=;
	b=BfOEHvKz3Xp1lv7ujI6fvYEURGJ0UM9kNf6XDKUMOVP6fIMSqpifQzGKkWcqt3pCgWrFXj
	vXndMoZgR7Jemw+NgufcdXtSPeSX/HZPOueSh6O0pCFEOLwsJHkL5b6FAFpSeUP5j7W/fH
	9liDJvdIkj8i5d9mTqRI4O5LL8qWuoY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773364696; a=rsa-sha256;
	cv=none;
	b=qrfA5GTksFx8mWGHyH6xxSCaBORthshGtaMJxgOLo5xy11lXz7qV/IuQhbzc14lJLKdVJa
	qZ9/hPI14xSGanvO6/LbrkrTXhR0vCu4P85XfUjCIiQAwi8KKig8D3Qw/dnKOJ0P/zY6Em
	BoKobnxlUjGkvG0VTv7wC1sI44jOAY0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K2AvzXAm;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-661d20c9787so2427633a12.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773364695; x=1773969495; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+7XsAoNKOaWOBAj10JuSqSpQXLhiG0oqQbVuG2+b/o=;
        b=K2AvzXAm7+elbk63lqoFnTQzRmXv99mPCGmKlfpyAzjg+ilgopYWYTVZCHWPIzD1d/
         hxzoj8xiuapmwRMqdEvDUjM1O7BJz0QM7O5qqO1Ceh5A9hbmrn7syijEp1NAt1p46AQt
         MDgr8r9Y7m+VX/7RS4aQdMNBaC4AAiIZRNyp1YnBa7mSBOltZtVMcw+Ov7GJ6JhYTLm4
         3scnQ9z9Z8IRsVK366EwFf03VJWUpwgos0hmjhV7hbvtlPOAqIWuiGMduNGvTzUchHsm
         k/v2ZA268foFChqXQUxOoiChDwN2HXAT8FOlXE/2oQU+NkUTuzxvw59tM181irilq02B
         beSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773364695; x=1773969495;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G+7XsAoNKOaWOBAj10JuSqSpQXLhiG0oqQbVuG2+b/o=;
        b=Fk+fgmKK+LlWbnab+EGyYL/yMaFdXa71re2ijHG1STau1AH4sYwRo0ErFPVnJXyVj4
         uABzwcI1dbGayndAQSVrYL7KHdeBOkmFsC4NilauI7KdEpbF0j3k3X5+m6UekdEMd9Q0
         4CT6hqWOOwoihMGJcHwDg+CBBZo38XGa15dEk1YQhlsnETdd4N0DoA0gAm9OyctwYFGP
         WglQ4MJj3kEixr7j8DMU8RrY0DluefXG+b8+edsfMVC5e+TITr4egkPi/rk/oeLCmIXA
         FoJLivMTml9j9R0mIk0tKCjbGfSknLw38HsHCJTjqmCcsGtZDZwWOmWqmaG93RTw4BUW
         mkZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKZD+JviRW9JOhwmZxCXmJ7ltUhqBCY1TZRNVVrvK6gToko8+dElR0agGROkVvxnIwuGtagFTWTQ==@kvack.org
X-Gm-Message-State: AOJu0YyQp3RM6d/wUFhZSCvVCtyqglZXSyM4OiFD64q3ma7kKr0/ygC5
	YYPY9XUz8WgHhxdfE7mnpTglpti95HjxehGDDblRzJVCRvcHDT7MLdKL
X-Gm-Gg: ATEYQzw6FZXaXvlgjVj2rwf+qhdmGcoycNwGbRUCxdkDFIMoFPvdaL7VxwVruRoZ8wu
	LbhrNZUY/7PWkinkMuD17xekY83v/A0ZL0pecE4PmlcXIoaC3Debp8gmst5Jy5op0dDj0uBqR/G
	dtFhW3HmIzXznjh0bSBa85RPa1M4uXtLE/RMFR8oRlh6tR1jViodnebYlfnhr8k8PVLl78V5hW+
	VFXeulsTeaX4HN0G2hmVr1M2tY0CJFkbPIcyRci963e0PclBfX6adlBx5MtJxR060PgvskxrF+8
	ddVKejmwFiv9Ded1m9ngdmroyTX87s623HGjhE51YhIPnuggVlN3dfj6KkHUpXtgNA49Mm7S2j/
	kkz67aG2Vs3ubdD18cNbaYISg5hqn8BLVnUANsioHX3ZZKNiALYhQ1Wz8DIqQLEn/ygH9lv0jsm
	roSdryesD5aojuZuf4003xjPcgGT2rz2/2
X-Received: by 2002:a17:907:9481:b0:b8e:d1f3:4744 with SMTP id a640c23a62f3a-b976540242amr69402366b.55.1773364694584;
        Thu, 12 Mar 2026 18:18:14 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b976cdb6936sm7941866b.37.2026.03.12.18.18.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Mar 2026 18:18:14 -0700 (PDT)
Date: Fri, 13 Mar 2026 01:18:12 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
	david@kernel.org, ziy@nvidia.com, willy@infradead.org,
	linux-mm@kvack.org, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, richard.weiyang@gmail.com
Subject: Re: [PATCH v3] mm: migrate: requeue destination folio on deferred
 split queue
Message-ID: <20260313011812.cdxu4ypbwyb3hiol@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260312104723.1351321-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312104723.1351321-1-usama.arif@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Stat-Signature: yc5emcd764sbyc9ojnpgz9c91zwx8dtd
X-Rspamd-Queue-Id: 83270160006
X-Rspamd-Server: rspam03
X-HE-Tag: 1773364696-862521
X-HE-Meta: U2FsdGVkX192QjJHz0fhpw2OiEFDCvJTXOSFcH7+vFWggcueJTpHZgrfJZ514JGHKOO+hLri5hogjrtbVokbgcCT00OKXE0Zwv+HnWOFWez/9cEsbIiRE+CL+MCp3gWcVE2jyWlik64tlUFoF82pvvKJx/XrKPV2bo8yDNVV+FcDQsgwiiWiJwG/QdRqoWzkm6/RcKR0MkuOL5r2vyHm4uswqKzJaFgNeP6AwHEAhERbC4wHlPipfKS/mqfzpJ/mIxLl0Zq79fTfkYWIL2dtOeZI7vgL76HMFKbbL6EvTTGI67fEIF06rVmgxm5047h0U4WX4L6RZ1burY9WYjuw16oSyHO/q6zXo9BmHPQPPW1bQrk9slXaARgxbv3viA/z77AM2Il1qEgC44sBnqzFKKcBXwDWUF2+bVdgrFJzpNQ25vtyIl2ubcLIwreu4f/Ac56RPVVBLA/iZrvIPIt1qMBZxdNfQDEPPiYZ9OAetZFbroDngnOzEpJy+fhD17ziXFMOh5R+83oLXjeU7hCf/bDKHBDZ0qBuNV+tmN0ipUkzFUl1bGGhPelrqQEEbbccme2HaHVkmzNYBK53imjcghiv2PfiXm09Y8lrnGaRuRVHb/E4pdzlcqvsNNuLi9OZ8EGWjrMdrDHbI5gnxJWW2maIkv9myD8Kn3mfoU5LbAsckIFyaq2kQYGU40C387hQJsUWPcHW+i3Df9svNToDClr7GBaujPw4DEPgr8Qm4Txv5RDyRTGT/ITPJXQnnqBdIYZIOe90fw5I3pHdEuq91uOPfAhbT61d+bm7uLjWRGwFnfcRZQqjMRQeYzRAGyjib8nNRaBrsGH/z357NCDEqNW0e3JxQVQuyI4RevINC+pjF80bfv4PEEdcybv2zczeOpxcUbwXXBACuSFu2sjPfWz8fqyu6TXN/Dj/0QWOgXCJ/CwH4L2m4X9VgCBLi9kG/1X0Km5j5m2Pkp9Q13X
 EG0lGRBs
 cS8+Rqk0hErtvgcS+zu6w2qsSx0geKCgc5I5VcB5FlXgQhGR0HNseZU6u9DY0PP/fZYDjR+MYp8ZyaON2edGvGfvk5xvNfdpl5AvYDhQvJ5T0mmrCdXU7zo7lImSHauXKnvPUo8oiwAyHIckwAgSL6KvpX2kbn7vh/AZ++AXla2hAuoboIdlyvbHrrkGL2gs/q4DMClL+wLvteW5PTf2ZVlzd5QI/yqYdQqA6qUaaHEj+/WTap6rl74ukNTPc6bQYBXHh8kzpM3T+MS0potAh4irMfPidmKIQgbQSV5EUgPOQjK0q4yb1+WxdKFwaDipQa6nfNPahCtfdaR9hdFrsYP+UFqf3bUO3yevQiA4Xr6Qp84mMNr6bVKqhOYD8MrrA2PNabwsa6XqIYvuIDUPssFZQ0kpGODTUS0JwyOx2D6IyDkQCRT0U/mTVLCqyf0gTMv7z7xJnbgswFFyLIRXvoNiucPaEb44tRZ2b1MLyMbpqnbWDxgS1hsE0hi3lj4WxCQl6xzN32SBe742uEQ53+059EXpQZtzeoWHQYGe2vbA96rPAGtzgADfl9u4U3HZTmWmSul1IMsgKW7iGxKv4qZ97xumEXktXn1NgD2Z0LIxA0jAnX9JUAfkmTBW5QGyD79ZGK+eN04v7+/GS8vL1gAmdIkVNIkHpRLUf7o11eWwuNBBnn+x6e8sQZ2LFPm3fMiNCtyTKUW8XUYDOgzK8+MQGMJty2wNNE9Y6I2pxlWhfK82pySGO3vpBELiNbGWqxNPCH54Uln66g57zykPScQYuiP2QTs5t3RfEz0DzYR0zid1WLY8M6gXPmtc58yn6/l9IFhm2HHj9nKOG6bw/FDMB3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 03:47:23AM -0700, Usama Arif wrote:
>During folio migration, __folio_migrate_mapping() removes the source
>folio from the deferred split queue, but the destination folio is never
>re-queued.  This causes underutilized THPs to escape the shrinker after
>NUMA migration, since they silently drop off the deferred split list.
>
>Fix this by recording whether the source folio was on the deferred split
>queue and its partially mapped state before move_to_new_folio() unqueues
>it, and re-queuing the destination folio after a successful migration if
>it was.
>
>By the time migrate_folio_move() runs, partially mapped folios without a
>pin have already been split by migrate_pages_batch().  So only two cases
>remain on the deferred list at this point:
>  1. Partially mapped folios with a pin (split failed).
>  2. Fully mapped but potentially underused folios.
>The recorded partially_mapped state is forwarded to deferred_split_folio()
>so that the destination folio is correctly re-queued in both cases.
>
>Reported-by: Johannes Weiner <hannes@cmpxchg.org>
>Fixes: dafff3f4c850 ("mm: split underused THPs")
>Acked-by: Zi Yan <ziy@nvidia.com>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Usama Arif <usama.arif@linux.dev>

LGTM, thanks.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

