Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6186C5AC7C
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD656B0093; Thu,  6 Aug 2026 18:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84ED6B0095; Thu,  6 Aug 2026 18:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4DB86B0096; Thu,  6 Aug 2026 18:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7584B6B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:48:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EAE6F1A0292
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:48:46 +0000 (UTC)
X-FDA: 85072335852.07.481E24E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D6D951A0004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:48:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Y/hkOxsi";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786056525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKWps21C2vpIWj/xL3lTP3KBe8XdUi+jDN1FX8vkfyI=;
	b=lnVtKImhVoeL+n8bRhoBtgNZZuFmyxZ1BubSWUgLqhQQbQEBxVrwPH3vnJAetinZAiwn+O
	Cahu+z9QBgZovqCw59sSONM0QOjTGlPJmL87P9hXe0OYqlPuO0p8qofQ8VY2Q4Zlez5Y0d
	6E3NAINhaIYTG/96H9tq5crinurs/j4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786056525;
	b=7BGy5KkfM+aS+qAMVDx9YeSRjS/PvSNJeuZ+q9Pl/kCmPDqBnR5ctNqBgAy3E50gcDsyRA
	bQa8ycdoXemG5ugkb+HVLVN4fYujDRfQVmziZ7f2yquY777WHhXwdbFFjxllP0DKwdIZcK
	H6aWMiK3sAisnccJ813mP2Ur/O9s94I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Y/hkOxsi";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5325A600B0;
	Thu,  6 Aug 2026 22:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CFC1F000E9;
	Thu,  6 Aug 2026 22:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786056524;
	bh=aKWps21C2vpIWj/xL3lTP3KBe8XdUi+jDN1FX8vkfyI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Y/hkOxsiIyXqvny+I6euy/SH9J9Y7PfvaVvzz4ktCdEuX4pKj6zPoGgBWZ5XftV5k
	 TJfDirsMpGdI8gmczhDD0jw9OYPO5/iIRZkpzwjANRXqfSxsf443+QOpy/gnslQp/t
	 soLmaACg6qvULyVpdT1asWMzpnJCBRCNU+SfzJlM=
Date: Thu, 6 Aug 2026 15:48:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Catalin Marinas <catalin.marinas@arm.com>, Danilo Krummrich
 <dakr@kernel.org>, David Hildenbrand <david@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Palmer
 Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, Will Deacon
 <will@kernel.org>, driver-core@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH] drivers/base, mm: move arch_numa.c to mm/
Message-Id: <20260806154842.9faab19cdfb7cf09799d8f79@linux-foundation.org>
In-Reply-To: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
References: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: xmenzak58f79oksj8jt3hhhi3ioy5hyt
X-Rspamd-Queue-Id: D6D951A0004
X-HE-Tag: 1786056524-919797
X-HE-Meta: U2FsdGVkX1+BSA9QOOsSH3Hw/UzQBjl6Sd6P3bHpMj+3JI/CxWwACtJoGH8h4WLUCN0iSBu88CLYf+WLw6wmYlR2Xv9vdfOW70RwfZ6DeSuXSqT1+4HZ4+5ITUE5JOoSKe3o/hA4iwxhGTyTqj8ycJMDbLGtUNZESQTThUYyS854I7xWqtPHgLQXmiaiS8M/vryFSo0+kf7bKPiVOhuUmwv4YT2f0aJJAvNqdSWwLPuDhKwkwbxtqqBH8dBgPsB+XyQc4QrD6Z21zuXuiUrvxObX6XFYI+2A/nmTKjRL75PHH0Q9xywJBH6la03Y1Jn1CFd//qwOho2p6RnJlCYD5Jxj2QdYK8/lUrtZUkPvUH9n9zB8s7ZZNrLrmLZtY2uCch5IjYkgKBSp1QEdIm3vuHaaNWoP7d8yGpdEuoUh6BeEfLon05FKEV5h7T730WO67bB76IvsX+oRb0fdYdtGsTTYZOFyBB7+ieBf5SjtAFN/xC7mh5knEqvebL87GgEWJRcuQDMv3zTv/dBOatgZUyU2td9/bfWX21CXghIEygeA9monzIw1dLoEfQ2LJ++WnxpCaPk6U9kvlUFc1Y0dkKl6T6Em2uPKitC0PJ8nbLf4L5gvZ7i+tAbR47GK8+OxW1mgoSfpflNFcC/jeVsqTfIVjJZwrQ2z8vB1Cqp2u8dxKvr545SYmePFzmXyBBh+eSy5OhxB5EG1nLjs5ePz5DNt9ubdA9HwpJcBOaR+ainzGBFCBPLLPoTTasepZ/MijtKujZKn3qYCejh0jD19CHeJDUekqayXWty8gd4rJZ4RUBQ1hkFIerlgjL3i4YFCkEPvtgd5kz3HybgXR5t2DHS4ip0Wu9k3cIE8mdt5I1PTDWFR6AnY0emHT3wAd1ZWNekOsZLm/G+LhzbkZgbz11aEZfAJ0BCQM+9ebnIvQyDFTZfvniGhPOxwRHe/bqBvQ1nNBJHksXRZcapoohq
 Q+nUBIrt
 8pEtCgv5PJDsmfv2SCi03DIL3eZ1t8Qaw0f4xkPPmEOdR2Y4bIFh77diHqwAyS1MEmcjEB2b0J6gEtNQkt/lmRYZZYyow8HAvJhD9ifoukPh/mh4Ya+7eiCeJhMZF3Lt27N+pzsxjNsvacFKh4zLHi0kaD8U8wodI7Y1LSpd9rP3gZCOWlL1/Yw1ob1+EH6Qr3YzRiurJ1dKVT23ocsQKRLivftUh8QEYu5PebaHbPQP8kEYr469VvWSGMyrZNWb2gCQF3XlmrQkGAVqKH9Y+dQOWyg3/KLbPR0Gj/muCRXJK28du0woEoSwEC3Zn3wcN5UG9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 06 Aug 2026 09:58:38 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> arch_numa.c implements boot time discovery and initialization of NUMA
> topology on architectures that select GENERIC_ARCH_NUMA (currently arm64
> and riscv).
> 
> Since this is step in the initialization of the memory management
> subsystem, it's logical to have arch_numa.c in mm/ alongside numa.c,
> numa_memblks.c and numa_emulation.c.
> 
> Move arch_numa.c to mm/ and add its F: entry to "MEMBLOCK AND MEMORY
> MANAGEMENT INITIALIZATION" in MAINTAINERS.

Unclear what tree this is targeted at.  I grabbed it.


mm-stable does have this change:

--- linux-7.2-rc5/drivers/base/arch_numa.c	2026-07-27 04:44:55.000000000 -0700
+++ 25/drivers/base/arch_numa.c	2026-08-06 15:47:59.019918702 -0700
@@ -231,10 +231,6 @@ static int __init numa_init(int (*init_f
 {
 	int ret;
 
-	nodes_clear(numa_nodes_parsed);
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-
 	ret = numa_memblks_init(init_func, /* memblock_force_top_down */ false);
 	if (ret < 0)
 		goto out_free_distance;


which is easily handled either way.

