Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F22C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D211B6B00A5; Tue, 22 Sep 2026 00:26:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8C26B00A6; Tue, 22 Sep 2026 00:26:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8156B00AA; Tue, 22 Sep 2026 00:26:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CDCD6B00A5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:26:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28E58A60EC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:26:02 +0000 (UTC)
X-FDA: 85240110564.03.A8547EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9CAB720005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:26:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ER3J5r3V;
	spf=pass (imf13.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790051160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D28fmX0v2APqwSVoGcnG1C5Rh5Hd9l3BseXRfD4IHME=;
	b=W4iJxqFtKi4+KxzBIDdK+Z/m84z6YNRamW52zzaKPmlFRQSLhfd81qtcRYOMtqF+Vx9bV7
	J06M0Bo7irBDrKSGaLGZiuBUfZy7JmgjTI+zqvjj71sTCL18JB9vWNFxhIqiiSmgpJt57c
	gEddFqB68d0C10Rzs100WOgFobQZpVE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ER3J5r3V;
	spf=pass (imf13.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790051160;
	b=3MwB/hVKZUy3/6mcSkv4P4s0zjToxtDLfzMFD7HzQTetw+8FKaCbbZ+96oy+l2gi4krxvu
	rKPYMWM8EquAaP0pK6cPDEwxM7O27nPfuTi7hxYVqiFV3FsGiXd+ZKxGtpDG0LgBWpF/eA
	S+6gd0zGD5flTcDnnMQ2NeSqIQlIbO8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B140600CB;
	Tue, 22 Sep 2026 04:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A901F00898;
	Tue, 22 Sep 2026 04:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790051159;
	bh=D28fmX0v2APqwSVoGcnG1C5Rh5Hd9l3BseXRfD4IHME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ER3J5r3VzZNuMuHQZZdT2tmD/sauynFhocssTfXIyQ+aeQ6bHpu8UA/btjPDGg3MH
	 NfePtUdGHG+QdKUDw/Hf0NGR7IZE7GwghF/aWpWREdZXIu24P6AHSeBPDeGCLdrDIx
	 Wo2hVOEZoDUAtcCdLZA3wprGabCwotwqb5oR8Sxge67tTTQNIQJfd0/VaVOMDx61j7
	 +cDtnjNI9J99y88D82hGsEYUaZkrWCSbySiRs5MQTyfbTWfoiTKsRuMG4xw3dJF/61
	 wFzzJtYuXoUWfMMZjp6HroZWXyPWrA8cZ9PVa08HOFKF79taCFtsp8GJ7ykAzcwjQk
	 z8EZnhQvf7G5A==
Date: Tue, 22 Sep 2026 06:25:50 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 13/13] mm/memory_hotplug: drop
 CONFIG_HAVE_ARCH_PFN_VALID handling from pfn_to_online_page()
Message-ID: <arIDTjj5C05Z0Hp5@localhost.localdomain>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
 <20260921-b4-sparsemem_cleanups-v2-13-54d81d65e125@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-13-54d81d65e125@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 1nc8e58kbs7czodmdz3u6ko5w6gasgad
X-Rspamd-Queue-Id: 9CAB720005
X-Rspamd-Server: rspam07
X-HE-Tag: 1790051160-78819
X-HE-Meta: U2FsdGVkX18E4R5V7+inbBr6p1cUFUQUFLqAy3VuKb5WgxL+zuEgxP7vpY3Dcf01qerTxuDSc0NOjtWPm5CWo+eTpHkXutCNe7jVI6JbQleH56J/+3mvgqXykYs7N/pwID4UFz8ns+LyMHNjB2/9kpybOGnmtkg9wZtln6B2t0XxHNWC5PAogGkTpIIPc6PIkYL3KO9Cy5brWi0ROJtM/CRDJr5INsM0RsxAzDdcJyLa9P9HPJcy6Y6PEojv+HaruU6wrPueHbw7o4XAxYTZiIvFcVVlM4pS0ZGoQ8vWj9ps1r4ev2BUGJvFj1L/RSkG6yo66yBKEm1TfBXQJFtzeTp01cvzf14mpQ83EY4i/wxY9FBydhIrf8KGOSA6uIj3uZdDGGk86e1aNBX1fhKQ1sqH7tLNNlsYIvwJEaLcJMNUTHSndUNuucsYHT8zVW6J6jYFw08hpwdNyco+i2yYWL1jpyhFFZwLDQ+TUvCtSYyKrh/3IBVBJJcUcetfU5griILxFJPG7F+mSSfZy5fnWMonV/dUbR7Ac/lBY+APFoMqQExWYSTcNRQV/EAEIyesY0pm4jsNtkKp76OpG0SLYTgqP/1ufwke33cARbehHnLNq67vPaWZjXUTAz9pzAwoPwH6S82uttL0/JWKNraM/BYptm9QzE9bUyIf0czpLd2Y7C1JY5CtlCR6Q7Lq6+pcmlW+MC0icoJfmIWHa15xU7eT16DvxtpI5kuxs+K76nYLDn0IKBLuvUcGOV2YqoKxpAc1iw0E/YX/2i3nBpRNjaRMJpk31xT9VsDx/bJbec2i220/r+KkRyLgvodumcpPeiFiH5VEn8CM1mS+IevvpiPz/8/plDYD57pCH4Dk2xXIaqwvvcJFag2LZmBxaNCOYw+JPY5Gzkh24dleO6U/BsB4B4hqMPwJFu+hkIM3z8M3wQGADLOMK87DdA3TWA/ODLEUJ8kRViWINZ49PvJ
 W6oioVrH
 EYDURTTWt6M18kncGwu+4Z3HrT2SLPdG1E6gmRaAXpP/fSDZkpZb0rbJ9gED2FNIQfYoH3V35/DQHfChP/nBhuk/vA3axmfB4HpspHFcnpSKBnhG50RAqxgLvqsKpHI1Ob2zlKcSBfF/wwi5ME9nBMAyxCXocDWmXIcj2hKPMsrFXMA5Yke8Li3ftV+09QpUUY14n63D7cQ3Ldj2Can+8g18loJGCJ5+zTV/6Xl/9ZnTPOuUCncm6O/SSuQnF0wY31IUQhCxyRbLcLkIksmSSMSYWyAkabqi7xYIM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 09:59:05PM +0200, David Hildenbrand (Arm) wrote:
> Drop CONFIG_HAVE_ARCH_PFN_VALID handling, as CONFIG_HAVE_ARCH_PFN_VALID
> is never used with CONFIG_MEMORY_HOTPLUG, as the latter depends on
> CONFIG_SPARSEMEM_VMEMMAP. Make sure it stays that way.
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

