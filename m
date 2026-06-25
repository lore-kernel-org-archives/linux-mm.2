Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AE1CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3651F6B008A; Thu, 25 Jun 2026 04:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D2E6B0092; Thu, 25 Jun 2026 04:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C3A6B0093; Thu, 25 Jun 2026 04:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1BC46B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:47:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A3B5140632
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:47:04 +0000 (UTC)
X-FDA: 84917805168.10.5A0072F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA732140006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:47:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=du4wyvFc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782377222;
	b=1tH93etEBX1MO93AzYuycq/VTT8EYspyqTa6gn1amQ2ptffyVIc4EPEj8jL8+TOHnDdRwz
	AKtuKwb5HcyLatealVkNfm4ysK48WkXckPu647t+iBIkdFGZ18L+vaZ7osslc+iVN7bEIk
	c6XhiM3Y0xtMR2eOmqSaV5EyS7Rwqxs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782377222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wt19WGGroORa/wioMj0fJmzojKxoKhuinoNaN6kTkuY=;
	b=pihGS0nN9KYA8QVBeLH72E0EptWJSaI8vnBroYcGeUSOGWI90wXjciWx9Q4FEGmHUWzhSc
	htVMMhnzfjAs3YFN0EAeNKTAHl4/B1gUtRcZiwmz/yrpRiwSWuasfhZ3di+7vEYo6NZ6Cv
	UmNoaZg9e2YplRnLAmH6b5ofmooPDDo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=du4wyvFc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7C9940BDA;
	Thu, 25 Jun 2026 08:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501611F00A3A;
	Thu, 25 Jun 2026 08:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782377221;
	bh=Wt19WGGroORa/wioMj0fJmzojKxoKhuinoNaN6kTkuY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=du4wyvFcpe6h8cJqJ8+wwVFQIsPj3+N4yyrOgN/qduox/8HRpcOdji6jhccFrjrVm
	 fe8cWu0TwoYUMUMvAnwH5ORIIJS4JfTppMLZ25rxdQvGMNgIkYe5fdXI5cjcxjOFOi
	 pIVScnjWjkimeuSoBvuRunDdMYJRg2MNpvUeqdBcAvWj4Ajcj47cEbqJxmHXOXTbrq
	 IEEjEz95TyfdFohXIjCZhgHI2OAqNKZ+Zb8mHmPCjMMrPDDcqgvM3Sqf2cNQbIJnHF
	 SHC6Oq2q9FY3gbYFLnSDpvOpnDb4GmBPDmTyTMv6ojjv53h+5tNtueC1cRFQtHQxHf
	 YQHHT5H1S8rpg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/6] treewide: remove unnecessary invalid range checks
 in memblock iteration loops
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Huacai Chen <chenhuacai@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Will Deacon <will@kernel.org>, Alexander Potapenko <glider@google.com>, 
 Alexandre Ghiti <alex@ghiti.fr>, Andrey Konovalov <andreyknvl@gmail.com>, 
 David Hildenbrand <david@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
 kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 loongarch@lists.linux.dev, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20260621145919.1453-1-ekffu200098@gmail.com>
References: <20260621145919.1453-1-ekffu200098@gmail.com>
Date: Thu, 25 Jun 2026 11:46:51 +0300
Message-Id: <178237721125.146960.11801589845266315987.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CA732140006
X-Stat-Signature: 8yor6cmhfa6oaxa6w6w53mbohy7r7t1y
X-HE-Tag: 1782377222-206816
X-HE-Meta: U2FsdGVkX19V/QKzA8JYG0UXWSeQB/yy3Y04Y7OHOaGCpeCzPyeIkmprn0+cC5jmayg7QnQURH9+zJgtl/uHf5t6o3imIJjzJ2cO1+YJKsfk0Z1dsLR1xx+1b+Iz3XtYWPoHHG/XiQZlrUGLVuG1uicRNuIAM4EEUNo90OBHRNO8S61yDv/PACa4FCJqilyE4ZRPNE8wZI1sFhj+NtbSuKOuU8a7gCYW/Bgb6xf05SE9q+S8qd3X5iW3V1ZOnPqgwpX3GxP7Qwqu0ZXvAT6XU1hqHnLkrs0kKj3knhG+qRNaLDQPqlTsLWlxiv4PjaPuBe+uVQXITSYMZJnhSspXXX6ktLutr0RZVhZEIiCemAR+YgpB+l5kuy0tT732KZgXbv8gPzW7fdVGw47ybMKFE3f2HB3aSMOrC5/9kzZa+Rmp/nljFVN4Ud5sR7du/vOY/hqWC0kBW9b+37S9T2yClpRZMOadx/0Jeiv4zg4Bg4gmlLBzu50LCDMa43zWRF/QnYacQJstVJHduSkD0PBtyvNtoRWm0iET8UZNTWqIqjO2+Vxfk3OWKT/rxcHn78OGfkJBGnLmebzvcLCR2CWzllGdTNesHtIx2opHlzc8TT3eK9tsafexeuj3lOfUBAPH0SLjdDNSjpsqT9S+Qhe8ZLadTDiXvXb4gG1Y4vc1VyQqzXCaBFSN1nP/PrSRJvf31lCiu8I3LYlEV9rtTqCHcyddMT9NWDT+QHBZr/TvAWsJvjlWNB2UrrP3GEMDmxI384jPvD6S0ifSbWGhv9HN9OGhs/8x3LlOnKZ3ZBgRmdlvlrkHZCNMbyRakctKjhqTFfC8l9xfsLVRsLk8lM58we7+tLI6/FVRaVjdnRE4hQUOrxXpIcZrkv7ayNIigTRIdRs5IyxA1Ka8WQ/Cchdb4EOtTJ+13nPJ5dHZj4StjgiqYLFWNimyR7GnktEmZ4RtRspkYod7m60K22LxKv5
 6LERaY7I
 o1HukKQ/Wgp7Y9QPmE6ZKjKsCMddLKXKSxIjgzKdNDvwStLxrr1iVV+9pWMRFwPihFxxLBtWwSEtj7v+Pme2ac2oBhKkQy5slD9gVpscMgJrpsNwsMmKqNWEMQqbm5wAr9FXYjdMBDyEEqjpVH0Re3o3KEZhgqhWNWY1P0FFa9ixo4JmU9L6k3LLHP/ql5sDmHsEaWCi1uG9ICc4a3gagpNU+zGprA02Ri7fnG/8pIbIG/tIIleaT+5nkZPlwHGnAx5jeauSz7LiicxItqKwvORAhfAFm609Hv/e6DQmf9KGAb9HJL2Uc9RCr5OnPC5ZcPULvtty/uyU1/N3Iz8NWOpgakQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Jun 2026 23:59:10 +0900, Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> treewide: remove unnecessary invalid range checks in memblock iteration loops
> 
> The memblock API guarantees that for_each_mem_range() and
> for_each_mem_pfn_range() never return an invalid range, meaning start is
> always less than end.
> 
> Several memblock callers still have unnecessary invalid range checks in
> their loop bodies, so remove them.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


