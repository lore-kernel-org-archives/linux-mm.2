Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF981093170
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AA4A6B041E; Thu, 19 Mar 2026 22:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181CF6B0420; Thu, 19 Mar 2026 22:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEE66B0425; Thu, 19 Mar 2026 22:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF1F46B041E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:41:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 995E78C39E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:41:22 +0000 (UTC)
X-FDA: 84564890004.27.FE85036
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E0749140002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:41:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GaMcRgKC;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773974481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpDVPanMDl9S/YuUcFV5UbubYh9DqGJYCQSVxgmyRuY=;
	b=SGNjxeR8KHjH1t9pYMPWy1goqT/KUGJBPm+F4OIBDlPAyYNiALAbIAngXZi8A2ytXabIRL
	WEt644gUzVvKte0k2WHlHcdGARzDe/vz7ujRG9ruPnhyjt9uP527ItXavODD766EmfeGzR
	vi0VXOrY1YfPPKE0kaV4XmMbYJUEo04=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773974481; a=rsa-sha256;
	cv=none;
	b=wWdeBwEoZ8zwhs9edb7R5zBmCDE+O3bia93SODihgHJFdskT1AwLkeFn29acfGf5LxTERs
	64E7r1CjTDWukNAbJe02tFj6wynXYZfg2r80+oULi0Mvrh6XgIfG0axlIDkeNGSaYL+/aD
	lP+U2tsI1y2ukDUYIp8XBm8BBpMdGiI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GaMcRgKC;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CAD14434AC;
	Fri, 20 Mar 2026 02:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1530FC19424;
	Fri, 20 Mar 2026 02:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773974479;
	bh=dW4W0pRhSJJfJO50TMduySGdeJlAKq6w+m3RnpGWm5Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GaMcRgKCezfkg6LHE9uTNlKAHPUdosSJso9i1Pmj+34bAqDJv+s352xbqtcXO4nvr
	 6Rx/I8vKIZs0LgvdB7mOvngG+Vx3LeFQ/CsLMWO7oUKuw3ev6bWXdDsr8Yr2iLqktU
	 BMsypUk7l9MRqy1788IbGpJ/FubAcnJZ/i/PHIpw=
Date: Thu, 19 Mar 2026 19:41:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Matthew Wilcox
 <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>, Eero Kelly
 <eero.kelly@dfinity.org>, Andrew Battat <andrew.battat@dfinity.org>, Adam
 Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Message-Id: <20260319194118.3eb42ee3c507fd0ce2cd66bd@linux-foundation.org>
In-Reply-To: <20260319190409.294523-1-ziy@nvidia.com>
References: <20260319190409.294523-1-ziy@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bfiasw8gqj9yfasmsz9hr67486bz9s4j
X-Rspam-User: 
X-Rspamd-Queue-Id: E0749140002
X-Rspamd-Server: rspam12
X-HE-Tag: 1773974480-341221
X-HE-Meta: U2FsdGVkX18uM8N/SS6vG92yXiXuu+kudkivpJ68qtPbVzxO3ZoerfOG+ndjUfi2d4IQc52rJ+nTtzMrJUJvVsek7B5AVQZqY9HpO8983AOkvXcbMCf4vO6ZOL6LMqYMljsx0UsFlTg91L71i0jNT+GlcNV9jCt2RQrKq3pXD1jv526V4m3xqHqXyzuBDmV7uQKbgviE6H9mv9PLFd6DOiJLfplXu7VCBrWNKq1ICyLQqEM1/Ud9GYC0NI8be6KCqfWPOKhTuaHy18XjcVJ3UyJP3He9zOIyZfPaj8Dl3odlN35vRgK5QVQI3nPijMiPINGiYfbCnm9ZKup7JpPhJu54K0zYtRAda3NcbnmCpzgitAmlfHt+HG7crzWdox2X6S6wCJqMSNB3cmlrSQs4u5dejFYYQ5sdwNw8plOGff6Zla11hvTiwmFw5DZDBrKEOxoTAo9bQBPTKQEJRW2DvvhbwHNl95ydNerv3B8QljTPbmdglfGsLD1NwPX5KtRvdPhOadBtu9yYXWkjRcGzwxg9C8PF/Zyu3qrUl9Mj87pnXjFy9KHSwObiLUmKBABtZsgT8dzu8jqmeIp1/R4ZBBBqLKcaRCg13V1jZ2g2W6/JkrRL+UXisSAIU5cMfw6ir51kKRlwq/i1A2kkytwnk5iN8lqcUtnx9+lxTT8nWF3UJQh9rK7dcYJuHZWjeTmY7L7Hw70F/Sl35gtpzb8MKjLVq6sEOz6e6BfzXjKKADbaFOJgWmhZBPyOLvRGfPgFnIEfeZdPM2p4X/z0s751gvwqxKlYB+FmNSGLF5Dwqda8brv2iKb53O2xQwMuBbOknZHBXJ6aNt6u6bqcVeR2cmUKLmNge7oNw6VlWscJIg+j8Puy+lNVL0KkXLcRhlT3KN3t3XzzyfBZCDuOKAZ9JCKHij3t6cJxM/UiPJ+9Cs4HIYCcdM01T9GHkMfOXq95wQNg8sRc6P5Ru3YozvV
 1wh/2QQw
 bnEIe5LTBqMoC6wkKrQ9TGI8SaAuspAaW5o6BUMFKsg+9LINpiI28oSJiOrQ7q4reLw/Kp8HQwAw72X7gK4ucj3nMbaU4w5xNsq4KzfB6LT7opupok+xJLXO/jP8e41YNcBte8M3n2BWojMu2dytn4eI0xIVZhz9zYRB8gbMkLZCicxmbIdouK6XViHZx0EZK1NS6QGmsYlyaAS2eTHIT5/GtVsDRwHMoOQd91Njd5x2+Q/VomW0PReGdXM9WJSJLTT5WYGX5xNuZhZLtF+xMe9HyCtTCWLykv3IH/CakHoTHGjsMR5gayMnCm3dt2lCuF25u+9IhJN0W8T2yf+zX/IYyvFWG/VPRrxjTA391L6S0bcQFpaoxfS1LMJ2zPMJy0dhk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 15:04:08 -0400 Zi Yan <ziy@nvidia.com> wrote:

> The added folio_split_race_test is a modified C port of the race condition
> test from [1]. The test creates shmem huge pages, where the main thread
> punches holes in the shmem to cause folio_split() in the kernel and
> a set of 16 threads reads the shmem to cause filemap_get_entry() in the
> kernel. filemap_get_entry() reads the folio and xarray split by
> folio_split() locklessly. The original test[2] is written in rust and uses
> memfd (shmem backed). This C port uses shmem directly and use a single
> process.
> 
> Note: the initial rust to C conversion is done by Cursor.

Sashiko has questions:
	https://sashiko.dev/#/patchset/20260319190409.294523-1-ziy%40nvidia.com

(this is getting painful :(.  I hope they're worthwhile)

