Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5B7CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 14:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63DF6900180; Thu, 14 Aug 2025 10:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE08900172; Thu, 14 Aug 2025 10:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A54B900180; Thu, 14 Aug 2025 10:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21EA7900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:37:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92590138711
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:37:43 +0000 (UTC)
X-FDA: 83775616806.29.B7489E1
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4F501C000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:37:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=SyUENzi3
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755182262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDgRnsuLo8vubpJ2VjlcjumR5pIerCmW/K+TXJ575Pg=;
	b=B/fGi66LkDmsAbfWuUOZXiIbmkJKmd0i1I5FwIP9WCMR9qO0ijZNXU89ECaCEEshLWCBl4
	iiuo9BLd74mdFr+zGOb+aQR+RlB3mXsmzM4QH5LaoG9ul5Vcqxt9d2Bd809Y2gGn5rBpEx
	8jZ27DSTCuRTeI6QJmelFYCTQHiVHCM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=SyUENzi3;
	dmarc=none;
	spf=none (imf10.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755182262; a=rsa-sha256;
	cv=none;
	b=LxZKXiWPxtZUJ/AE0+atVNPOXH26j07mcAHj+1zsj+uNvm7Y9mP2XAKzmSeEo3ssbzvOYQ
	yqFhfLVaMLA7OVWDUnKApN0RGmIzbPgGaPAuEtHwcPJa5iHrlEOI7lmSbEkkVq/aZTdBpD
	uVo8/hYubWHnI6in9j4ypR2H/fttL5M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=eDgRnsuLo8vubpJ2VjlcjumR5pIerCmW/K+TXJ575Pg=; b=SyUENzi3LjRgnMVxZh9rxyPzEb
	pvjQGv+BzBjZNJOoDdH1M5wIrmhjf8BYuSm0iS4vljrHEukpEaSYTVBLTtdm7Cu6vwB8npzhj2AWW
	pVxFXgxAZ8I5z3fWWo0KGJSvZ69RB5OrUqwhnfWUWdirkyxkhnSNV30tLX2DIPVkFi3PQ7mmyXg8+
	sBV6ANNZjFCzy0gjxtBAMoB5CVQ9ZZYGtE/c7snxaNtYteGpWDA9AuL4hA93TA4MpDfacuYwY+EQX
	K7o3nvZPdYInwTfBUSKDNTySR0FsnxrOOTDy7Gsu7pWFuERAFxKnYHtMvtZbJwMfjqAuaRAWB2E+y
	nbFygHyg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umZ4w-0000000GS8T-0A08;
	Thu, 14 Aug 2025 14:37:18 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 550C7302DA9; Thu, 14 Aug 2025 16:37:17 +0200 (CEST)
Date: Thu, 14 Aug 2025 16:37:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zihuan Zhang <zhangzihuan@kylinos.cn>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	len brown <len.brown@intel.com>, pavel machek <pavel@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nico Pache <npache@redhat.com>, xu xin <xu.xin16@zte.com.cn>,
	wangfushuai <wangfushuai@baidu.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jeff Layton <jlayton@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Adrian Ratiu <adrian.ratiu@collabora.com>, linux-pm@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to
 address process dependency issues
Message-ID: <20250814143717.GY4067720@noisy.programming.kicks-ass.net>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4F501C000D
X-Stat-Signature: 3zykbs7bgx48a4mwptcagk7jg8ab4psz
X-Rspam-User: 
X-HE-Tag: 1755182260-395023
X-HE-Meta: U2FsdGVkX19dVAH12biIFTSHhr51l0M98PUrhPwENi4r/OIrYLtFa6ovQFxmNLxXCWh4Jf6FmSitOUC8VWb5cJ4Og/Hadgs+j1Cv12nANBt4eR9gpF3rwEcW1BGo5HA/jnO2DMURWTdfBvxIuNhT6g4Tpqtl4eQ9wWh6HdXlpAzGW6xOoNCJADQEsH3CZQwVsdc5eAfw+kRwL/PrBnf1t4k2KUWJSO7XISt9hhkZlKijscMWZQNfLhnqVu6llgxDLEpulzd38wc0vmifHr9XUdHqYwRUOA57jc/CJxSloXCOdvV61xeXSkgaIaoZLBDVUr/n3KrmIWkJlCT17qQVN8xQw2rVIKW3eHXO7qO0kp7jTGBCqLE9MAvWjaPH1D5CAU9t5KA0WCSz+Xe20OJe+10XHoEwHQoMqLL1C2eaOTtux/oi9h2TZ6sw6COpX1mnA1x8bGtXN1q1fPQrL5S8jsgwLsLCxC/CRTbdSQ65+bt70t+RUlpY/FT6fpxMQ6ixcXuGVUz9eApLZnhX74fqDe3teubsSAsFIXYAP/U9lVBGeSE38afKwCQuY77Hd+zfAfYxWRKkEo86zXjsVOIu6OgysJMT9QyHOj+q6KfXwudxX+bun36DUV5nARjdTJXWNkL2Cl1wWrkI46fyvNkW+xHGkSrVP/xvVuXg751+EEFQMp7ZfYjXdhkmM2/MOigO7vr/MIMFGt+j1yy0hdwNaqXLR4Q9Iap8jF8pexUA/qyqBoK/SYBF5ceChNSlLvgZ5SQOQmM5u6IsZMrepy7+mwGL4NeuZ446sVw+/8YaNAXI7PR0FP27BXDXCv8N/GUCT1au3TaOyyie4dq+z3MICnRYEoQy1+Us68k1CaLDQhHL8/1CkNVJFOPINFYYAl7jIMKMPeeBdFnpaiK0jrlBT2wisRlYa9NLI3CSVwup4Jl7Sk1U5cnSx6gca9EnvDct5w8f9pcEuij/bdg3sMa
 EmAYoEMQ
 xEvypVjNwxpyeDmXWRKQIi4Mp2azVJrbC5bol1TAf2uuvNm3qWIKsTwBqlW22msFd3Si08evanshheBpwBRiB0pmQ5B1rC45B+01lfzci6sc5iullC27+T/SK5KQDKL3WW/98R7u8vrJtxK3ilorSU7lbhWfUM+YhlVSqCeZ4M+ILIYP9HIo/1UVI75176JRPSHk7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 08:14:09PM +0800, Zihuan Zhang wrote:

> Freeze Window Begins
> 
>     [process A] - epoll_wait()
>         │
>         ▼
>     [process B] - event source (already frozen)
> 

Can we make epoll_wait() TASK_FREEZABLE? AFAICT it doesn't hold any
resources, it just sits there waiting for stuff.

