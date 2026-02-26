Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA13FD9E19
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 22:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C60C6B013B; Thu, 26 Feb 2026 17:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A3E6B0140; Thu, 26 Feb 2026 17:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB396B0167; Thu, 26 Feb 2026 17:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F22446B013B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:08:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBFCE13A947
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:08:50 +0000 (UTC)
X-FDA: 84487998420.29.DEFFBBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id ECA07A0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:08:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wVuWoyEo;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772143729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12DwDyHNeUzIGukLjlYM793X8FOIq2MbKCdSDJ/VzIc=;
	b=5d77fa9VfjmW+Nbm3MSRvD0tK+0159JLMgBIf5cS7p57svwLqjwmZFH85UXUJvrnmRHZQB
	9HzdHgXbtDQcbQfcrShtspxy0VNxOTXIhPUlPetrHBzvFd+VQsACj5IQLjTmVsRJWWH0WQ
	7X8Iz0s89zMqkKHpd8VoaEUh3EYp+0g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wVuWoyEo;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772143729; a=rsa-sha256;
	cv=none;
	b=glTcPgyjbeaMukWlLZaQeL0+MPnMcRt5TmdK5RdKmaLVTCba4QA/WyoytAKbolWHb49Jid
	DMpJo/03KSLKhvLKAYGrcl2b/hIWj0FjxBIyihin4s3Vkdvwj4ZCIgHjSJBftNwdUisz3r
	argFgcqMd+X9Opxa1ZxXANuuXOxn0Tg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C6A074042D;
	Thu, 26 Feb 2026 22:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C0CC116C6;
	Thu, 26 Feb 2026 22:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772143727;
	bh=04u31OS8pHtQknBMGM0v9En/KT3xrx+KpMvq6UGaC9o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wVuWoyEoWa6hkBNz5BZQM0u1SAhmT92KyWrGnw8SGD79sCKTc4r6NQlwSoVZiaOgg
	 waV04VNXIDDAh+3UainQ+sHa3dTPAzXIsMsjEE8YSQFUY5b0z20fICqwVsaL+XXCfw
	 UATodmqmOCaRws1NDXz98RFcrPgQql9TqEXQllak=
Date: Thu, 26 Feb 2026 14:08:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>, Qi Zheng
 <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com, Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 4/5] mm: rename zone->lock to zone->_lock
Message-Id: <20260226140846.4d8b30f200b0194c4bb78d25@linux-foundation.org>
In-Reply-To: <202602270508.8MKXotxZ-lkp@intel.com>
References: <1221b8e7fa9f5694f3c4e411f01581b5aba9bc63.1772129168.git.d@ilvokhin.com>
	<202602270508.8MKXotxZ-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ECA07A0005
X-Stat-Signature: sp4szd78gnsca9g5hti6uz4p4safhuzu
X-Rspam-User: 
X-HE-Tag: 1772143728-653644
X-HE-Meta: U2FsdGVkX1/9jCaB3/UcmWsgz7mh3lkAZNzlNJ95qYxY7qJIcSz0kFpxzJY1hlXIGoF198ByV03LlWIHuigB2s2OXgA4zMr8H+PSAzN7bO/mTto+3vel1x1aNyXBvggr0G9O3uep4SLGplpi0QSmO8/EPTUC287BWzhOqBSnZVfHQulJDrlQYCVt1ScXZTu4EpvXvZXBQiIlyoB8B32ZGWMC7ZvSKisc/qoIzTiNslJAAXUOt4j9bAcRdodScVzeGNJvAUlG0tLHR/KHtfc5eDg3VbAIz0ykol87e52D/SAkp6+zw8kSPaB6jTfbRVVpg2yP1Zf/JX+VG/BTl3ccRpzi9/t1+xLsx1OS2QA26umpE1JJbbJd53lXIzn636X+ddXv27gebIe4nhvU8+PgJSustjmwcT57/cQ6jXWGACx0itIPbqP+BlG5wzDVCGttVUmMElus3Sf/5OHocL/f2oDeOllLjsDHLDG/l6ekoyDdCmLlrQ89/Cm4JrBQ/8mRTDrX1nhR9y1Y06Saqv7xfvtnn4hM4EkZSWihHQbaX5fJDOWu0uDFPcQsYFRqESSNhjBlBMMJ08IlF0Q0XDtC8hIfQ0OcYFlBFXXEPCzC9ZZRranR99QVKv6pX/RBUdR1tV7HdqN+FNtg0dXhkbRgSZXWFfb5AQ6l8K0EPYkMLtFT/XyfSRoDbUJrLVWV7quD52nf5cfaBP2uZJ5rwgtBotIektHlXyI3HHaWOBOUfhudg/i/BcUpp2g1YQBvl82cpTegjGaVrAM6uWkdTDS8RuWcDmVmtiN7QZDaKI8auznwNUQ2O/UraoUx9mx+QycttZb47SSLpYLF5pLeohzTCh4qIg3cegFJZ2c+6k/ZutmZsERwMrgf17HcmXPQ1TlWDiVA5HWVl2LA8c+Pu+bldC32ufaIhvF2LLTbeghftxruySmKDdlQ+7IVeBOBuoyyoH2qjsuosfhLyxbPAR8
 h4+JqYDm
 1kaiuBJ8BAJtCHhgDhD3gj7zSqqdWu7XxQ6Rv8E3YPJT3QXApdTeO4biMJaz5OdWq9094PDG/oOwJxtaf5KLfjN/Gd9yiEnWdSeW1fbcF0gR5qbKzY2J5zY6zujnsxXjFAvT3WrR0wBW7AcOwcg/yy01XT4h0UyHFxiuhGIDKN1DaeNq10RLO6/HXKYRmOwEWIdHceKqCPd1V66ob3umozYMjBBGgN8wb3MPjsbIA32P0VJJ0L23SnC64PgHLsIotR3lZ4SWQ3pxZ7WHtfdP1t3lPVzRWueb7UbHSo+98CYCIqbZstgfUAyVJwIPWBroeMzYh9GvFOG8Hrldv4MX3cUep/je//tBPunvbfx6NRJtopGEngemsXiVyt89ChfJZVuQj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 05:48:05 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi Dmitry,
> 
> kernel test robot noticed the following build errors:
> 
>    mm/shuffle.c: In function '__shuffle_zone':

yep, thanks.  And kernel/power/snapshot.c.  I've added fixups.

