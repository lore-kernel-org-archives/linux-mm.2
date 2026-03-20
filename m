Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 611F21093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDBCA6B0005; Thu, 19 Mar 2026 23:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8CD66B0095; Thu, 19 Mar 2026 23:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC97F6B009D; Thu, 19 Mar 2026 23:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ADDC46B0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:16:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9912B1E047
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:16:21 +0000 (UTC)
X-FDA: 84564978162.28.D16EDE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CDA89C0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:16:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RQ+iyGLk;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/1g5uI07Vmzk5TFoxnacrzmmRPUs2TdN7gTDHLvnXI=;
	b=xzpf3VEMm9CZkRQyIrQ7nVkBhtvBHVk+cg9hN3V1FpSwEXN8b8GyvIZb8WNpbtRiBUiUVG
	WA1KVY/tlJkaCsdb3gimzu/7GHLFLfKl0saJS6flUCTI6PZw4VAi6Zo1kuXmcIFnN+hvKA
	3irzvAKvw5INzZLP6gUvSybePj9Hdwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976580; a=rsa-sha256;
	cv=none;
	b=XdlH7hlUv/avQJCOGCSvMomocyvC5W36MhZloq6JpLJ+KBG0VRCeL8JGKvMXvHkziqrQ1w
	eNDUwMgrmX9oHsFU7C9W90fZKnpXNG9SvilMYQldkZA0222s5CM9Uk7xtGdmDFO/9z0bJR
	rq1x8VVeL5fkQBSy4e26ddY5YDllM6c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RQ+iyGLk;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC37F43B61;
	Fri, 20 Mar 2026 03:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3C4C19424;
	Fri, 20 Mar 2026 03:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773976578;
	bh=ghZRuCo0i0hEdBUwHMzlyAVKjwiFMQ4X15pR6D2bBe0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RQ+iyGLkoPUh3ZeZSnBBL3z2gg76R5vaufFNWDqrzdPTVnYM005Zp8yPUJ2JcuTw1
	 qVSQWxgiB8y9oRDRRe7DZCUqvRY/Ok/F9v5TSUGTYTk/+v2a6pCtFVD9qgUu+A+Cnh
	 sBE+AJjP3Zx/SuDQarU6tHqJ4tmCrftgH1FiKP40=
Date: Thu, 19 Mar 2026 20:16:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mm/vmalloc: use dedicated unbound workqueue for vmap
 area draining
Message-Id: <20260319201618.487dab7d56fb31adda6bdbfa@linux-foundation.org>
In-Reply-To: <20260319074307.2325-1-lirongqing@baidu.com>
References: <20260319074307.2325-1-lirongqing@baidu.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: xmag8xzzoso6gffmyr7dt88rz8bk7i5e
X-Rspamd-Queue-Id: CDA89C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773976579-965039
X-HE-Meta: U2FsdGVkX182skKdrOc79M0lRQL+8Gj493rxKpdLbyWXEcPRqLgucFC3GyhveW3ba2Lwk9Aznne8EOyrlqTnWKVHh6S2Rg3jyWh8uoTVoOgJOK6pvBNVF1GRo23NLscZ6R0zfCzsdvyN+e0t4ER1UDUWjeBbyZ30T6CuaoJCgLNTlsUTJHI01ZZNkH02ekL02A1zbaaQKhtrclE+1DQTtko04vJZe8IEheHCL8tvM5pl1Zeqi8OiY6Mkrr72hoU/VekIsB5qU0VbZTrc8JhIh1V6hIGPMuq/ewlbduaZsHwBGaqQeVRpITjE+1OAMD5v/ZB1xBreZsF9ciNPdUCZuUl+uGaHJE3C9j2eC06pmgVoaIPL7co+u5wg0SxXiFfHtIGnf0jUFMs/BvvW0kNYuBcoAgIbtQKiIg+KXcIPYLNMlD5VXx/wdPnAZvZ3GUAwO0O+h2ZwSz03usbOoqyglDZlVa+rx/P4cCc16iKlK9JoUYBQRaYr1XWhmOuaaD3jA6xtvXQL1HRAGU/DLQ101CwmdYFZpqKN0bow2ocRjV0hwkuiO02NMiQo+axmtTDjkrYelyVURLuc72cb2iNaoRVH2ElMhHhfO0qXtBQKupxPjh1/NlXKzypwEKOXZV4RXdz1SuGTTAdtGOHz5IFF0ZWA81km1n2KONl8G+rEPlADcm/5S2xABbypERsiZI1piJQlKQsb2069vX9Hruiof8o8iqUFMdeKiGw+XUCViZjXosE/5+fohjckcZ2DYtYn0YcrQSowUfN4OPNdsPGPAVOCpAJpj0NSsvqbnpv5oF5xoy2HGmoiSGDkeanthUDZWEBQJe8dKdbh4pE5fLoQHjxztPmseC9dGdNhe8ITAz+BdSlDQb8BhgBWtlW9V3uIFgm5c01vDRuRgnryxpBxFouaeUpNEEW3dM4+P6OSwJHSwajGqYYr6lC3j5WQ8c8dxlSYZjf6VgavZ1Lq7V5
 WPySBIVC
 MFo7R633dvhF2XK4E09VcOaBnK8FpjbBS5dMM+2MHQQScwgcokqBuKW6X1d+SPLiMr+U7HUrwJZ5Vhz5kSrHaYSs12ZaeDUZjMddNJSWinmouahrWwdUkin5IRUJhaOzveQnh6svk5WSFk5002jaAvkR3Vo35t0ervwlJ1xI0xH0LXHOmVLLNie/NWe0761F10zNPPCCVLvRvvOEoAOK4v5vBIfkKRuFcOo1lsr39kapSeQS7MgE06oopsoCs/jsRPD6/BWGMHcj1aI+WV4SFrPWt9G+lHto1Pf/fNb1GZDqX47c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 03:43:07 -0400 lirongqing <lirongqing@baidu.com> wrote:

> The drain_vmap_area_work() function can take >10ms to complete when
> there are many accumulated vmap areas in a system with a high CPU
> count, causing workqueue watchdog warnings when run via
> schedule_work():
> 
> [ 2069.796205] workqueue: drain_vmap_area_work hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> [ 2192.823225] workqueue: drain_vmap_area_work hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> 
> Switch to a dedicated WQ_UNBOUND workqueue to allow the scheduler to
> run this background task on any available CPU, improving responsiveness.
> Use WQ_MEM_RECLAIM to ensure forward progress under memory pressure.
> 
> Create vmap_drain_wq in vmalloc_init_late() which is called after
> workqueue_init_early() in start_kernel() to avoid boot-time crashes.

AI review flags some potential issues:
	https://sashiko.dev/#/patchset/20260319074307.2325-1-lirongqing%40baidu.com

