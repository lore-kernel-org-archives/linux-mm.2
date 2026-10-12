Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E108ACA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 20:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB54D6B0088; Mon, 12 Oct 2026 16:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66B76B008A; Mon, 12 Oct 2026 16:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97BE86B008C; Mon, 12 Oct 2026 16:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76F576B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:01:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC1C3140BFF
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:00:59 +0000 (UTC)
X-FDA: 85315042638.14.09318F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B40EC0009
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:00:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a7uSih0+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791835258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K11kw6sxAxVo7MdG1IcddqCM6rMQ01SADHyb+upAIqQ=;
	b=Tx62VdfseiZQa0UN8sWTfCSKnVhh8xVuT+54+RkdY3jTepN4ST2ZBEiH0sCoeFFeLYB/K9
	GZgQB3438b4waNp7A19bCqYyGdONcOvPervi1jU/KurIEiq/owngInBD9xfrkdNwZcTf2j
	ufkDh2PPXrOzOAKud56iuy5eIvegKwY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a7uSih0+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791835258;
	b=ysXHtoEUhgcx+WISpN12UHjr/xFKkrgjwN3oYzMxNzWHGXbaPExcNhQLE2enGkmKbTSQ4X
	egqp2ez4ToZ0AW1zROq3lRPFIO5/fvk96QFEY1dzMMbogC4jdVftGGoPnO0qDqLUXiRCPS
	9IEV6ZCl6g/hoyxv7u+Lbricfoy/zrU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13EA843B53;
	Mon, 12 Oct 2026 20:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EA81F0089B;
	Mon, 12 Oct 2026 20:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791835257;
	bh=K11kw6sxAxVo7MdG1IcddqCM6rMQ01SADHyb+upAIqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a7uSih0+PNDDade+F/+WyATs5BK/TSjcW4FQOY9UK/vuZ4NWQUmtB5ehgD5Ij3KVK
	 XC0zI/Nl5bpFeJCPGMGoqUirRerSskjkP/EfgY3ps+M10bN+PipSe76x0rq0Iam+r4
	 rNQIvEJWrYGwNKzO8Sd0A7Tjdj7l8Doi6feY9mUosNQvPuBuowq2jI9TqhlBkPXHgS
	 I4CLH6Z/2AnTa2JmVFh3Mnu2rOVgr1ekKFquDJDv1XSc3n5NmDXn0BhhBxtL1lSZjh
	 xUlfam7H6AoHLtDouxCOOQgTuszzhohzz/Qb8JVJOP4uvp8qOCVTttOZ+Zt0eoegie
	 xTA7ai32Y2rTw==
Date: Mon, 12 Oct 2026 21:00:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Samarth Narang <samarth.colleges@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, jannh@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: keep the hardware dirty bit in MADV_COLD's
 THP path
Message-ID: <as08NnPG1AF2cG1Z@gremlin>
References: <20261011132227.413217-1-samarth.colleges@gmail.com>
 <42087cd7-473e-40a7-ae63-3c841c615c8f@kernel.org>
 <CAAbz3fTZyeDL1Sy5FOxuJ8e0zgM5SJa1UKa7sk2apkaJFeeBaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAbz3fTZyeDL1Sy5FOxuJ8e0zgM5SJa1UKa7sk2apkaJFeeBaA@mail.gmail.com>
X-Rspamd-Queue-Id: 2B40EC0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: zkwt5x9c9ef13uxywakw9c1b45zj3bap
X-HE-Tag: 1791835258-929821
X-HE-Meta: U2FsdGVkX191w8yFoWz0PkUh/sp46KX1UX+S1AhbK86DDYK5eBcX9ziIAYlkwqcmTbdjEcXONNSNRpE83pp2TgH1Tj+Alb3dwoP6g48WufJLvLgL7NIlMkwUsWICvqSDnR/BmgdkkCLEWVvd+dcEYwQkHMBiE6jUrhWvWrIlYKHRYHbAZTNXNSHx66VD02tWVT6QsgsdMXdntUtt1Dv8b3ui1AOrer5/WQMcGiqrhqgsnJbw1G0eRuT+7+rnx8pclUoQyJcCdju3hKCWpDxPAD+nChDEPNVtcVsRU3d2W0X2WUPoF3N0tBdcz4fOaGkyow0VZv3nQIfV4hUU3dmtGdBJFVMERkb05Vpaw/GYvhR/a19N2xYg0qfAh9OwcbexGnR5jD5BzN4U9euLX9sF1OnL1uwEQjgcGZk8qJ8FDK83NLEGRAWaNCizrk9DdjcdVJcVGr6M77sxoEvhg6MJwA7KNYH8GdR250JZZZAOI9m2KO8EJ+9Fkri5fc/3Os1UbvRplrYncCbvv2Na32RYxqsbHsVnhOEnbgX7kmGsZUgUkoBEJ2wR8vqIHStuqJxzuu30s0TusPyOQYogWNHPW6V9f+0jHoGO+Fb5nnQ5QGbqLdU7/SNn6iSQ2a6Dn913kv1p+SWtrTloixEbDZTt4Z4MAhibzbi+Uh8cP73fRRF4XKVEoUMOwx+SXy6RukH7yQQ5w/vnwGU1X5nXL3U3w8QowmAyU8iWZZ/NA7jHJXdwYxVog+P5X0W1gJBts+FRkJ2uZPu7U2xCng1U9Gq0B2gJlKNk5hdnFHYPJeBRJaNdaBtXirluh4W7umxw7dot9+XJFSHOnLgsB9bKXijFXvOSaT4NQjEEw4qEG0X1QpDSk/6rTB/zNHL1mSkDyD5K+YGPm9AfrJBgQWhIuvoGJnrF6pUd0uRmuGq9MY47Qux7476sTKN7cKRAY76bUM+AwV78RqFPJ/d1zCi3bLO
 PS+sSgp7
 QOUPBt476JBqmEiT2O9M4qfiOfTv377jY0IqFPizd57dexDFFrxb+YlNk0jG9Af2+inIPxvUZyOOwXflrF+4p5u1qeiESnsFMmygweZ3vGWm4+61Ie9pkyzY6MXtIsuXzsOYbP1foZx5LNUyM8EZxXtwkflFU5BJ8WUvgqPgdnqJl0zjHH5AidOo8pZXcHuBefvY86eFfyUWKcHs0zoIWvWAOcNTlZGdfLGtfwDJIhzHpuN0oVq0tkD6ZE42+VNQUPepW9wdDZxonjFmUJkKDwkbLqiV67f9BZcexe++4YAMw7dn3IQIcUEc3Sr97QGhILlk7qJrbMuAXnUXp2VC8pfiuSfuklHpUemk6gfSmBFjsGKNu8Rp/t39mPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 02:25:38PM -0400, Samarth Narang wrote:
> Thanks both for your review into this; I was building a structural detector
> tool over page-table bit paths, and came across this.
> I got agents to reproduce it on x86 where we mark a 2MiB anon THP
> MADV_FREE, race a store from a second CPU against MADV_COLD, then force
> reclaim with MADV_PAGEOUT. The race pass loses stores while the control
> pass does not.
>
> Based on your suggestion, can we clear the accessed bit in place with
> pmdp_test_and_clear_young(), as the PTE path does via
> ptep_test_and_clear_young(), instead of rebuilding the entry from
> pmdb_invalidate()'s return value. I tried this patch on the bug, and the
> fix holds. Let me know what you think.

As I already told you, this is being handled by a member of the core team,
thanks.

--
Cheers, Lorenzo

