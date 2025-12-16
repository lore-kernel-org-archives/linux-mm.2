Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9410DD637B3
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 23:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066566B0088; Tue, 16 Dec 2025 18:36:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0147F6B0089; Tue, 16 Dec 2025 18:36:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62D06B008A; Tue, 16 Dec 2025 18:36:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1D676B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:36:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AC3F8B4B0
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 23:36:08 +0000 (UTC)
X-FDA: 84226944816.06.EA30FFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 91AAC4000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 23:36:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QbHNnQ6M;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765928166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWX2HyjcQW/okJN6shLz0onaZXOswqZyTjyIOovZ5zA=;
	b=x9nhxw3/l0hI4a9x9RZ8zz5btwfBue4qwR519wZArGFEDgJQfwP3Q50JdfFaCCWcWP89EE
	ZQmX/fyRy7I/eQ/VprOfojMmgMW0M9AWXsYAjEKugEOmUucCkqTwZyM/VhPMYHFJQTIcTb
	eG03fI6RJKFEvxYb7YHgL6Q4a9IkUgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765928166; a=rsa-sha256;
	cv=none;
	b=QAwHyOf91zmchNBgVTeCGA0KcKYiJpGopf+RqiiloRF0Rllq1H7ZhfRxOCuxaPT38ZOeBx
	oG/8rzJW3bJQhW6A51pXM+zaW+lp2ZDAOr8/6zJfQ1GCEPsczhOr2PFye4IvWi+Y2x03/Q
	yWgbnT8D56snbBaqLrql4E+9fbMhzx4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QbHNnQ6M;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A8FE433FB;
	Tue, 16 Dec 2025 23:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D84C4CEF1;
	Tue, 16 Dec 2025 23:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765928165;
	bh=EPxpabaG6xA2ZWPpii9OQRflDyARfiJKmlN3zwxmbys=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QbHNnQ6Mguna2cZyCb+0n3KA3a5xcsr9pb3owveLJmX9oWVyNZopHOaqZvyuF4L9O
	 whzU7mt5FC9Ptgi8jfB9iJ8kyfGriQp0RYqgoBRYvWj++1t8ZH0JfgTw0QeFtInMJD
	 /TvRuZ64GC/J5DzqSn1F5aqhiB2c38VpKyNXLsJc=
Date: Tue, 16 Dec 2025 15:36:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Vishal Moola <vishal.moola@gmail.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Baoquan He
 <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc
 parameter
Message-Id: <20251216153604.0c00504223d3fad070f2e803@linux-foundation.org>
In-Reply-To: <20251216211921.1401147-2-urezki@gmail.com>
References: <20251216211921.1401147-1-urezki@gmail.com>
	<20251216211921.1401147-2-urezki@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n6fcbf1qs187cbkuz5hma97cprw75yy3
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91AAC4000A
X-Rspam-User: 
X-HE-Tag: 1765928166-132574
X-HE-Meta: U2FsdGVkX18+N0KYihohZcePR5VSDv+bNuj4mKyT1NlFF1ytqyrw2HlDvGSQPEW7g12aMU1+mSIPyatQ6uOZV6VYfvk0c+YRS0LJFO3x98rVkuA0XI42xR9BqC+zcxfEmCIlBW52oK9xFMym7RuSkoeMfM6+Rx59EQECHp+rytdmiHqMR9jnJecddpRmvzuGwGx9gh/bXaZsR3kOgIzHD2ep8dErTDS8JxcnoAmJB6ypUDlhOmiXAFUHMYxnmBoQZIY9+CJlIHLB4Gy/4yGSQe6wvoy7hp+u5ABaLqk95YCAdju1nXEcTo0+urAgXvbZWZyS57/Vg3MiA4VswU6XS5asYU5eRoXlLbZ58UBZn8zMJHFKLJLH3jdjf1OD3vfysfQhrU92OJV8b0P+iVHDC813FyZa5laUqoi3GHdUILdYd74zGBjYXr0ISlG8mmC4JQUTAxr/cGMjfd3TZkckb+wKzI0aWiAHKYcn94OQAAZ+6uHfonThlAfNI4vlF+IGt3fqx1l6ZumESaIEunBXU4ogTSpxp8lxFVNsM8MsejAAc9tnCePex10obXxFQSf4mWw495MREM4tJ5VovSt4kF26JnM+VvSeUuiVDfA94LuIsKJjNfafRZfmACG6Zspkwxe9gElL9eSnh3O9jkoQ8yv7vbFSTSNsrLEPAL3/iAt0S1hrplr+SAhA+R8um8JG7F6YJs8jZjMG3eyViA3K7iaUhu2XcVEApv/bjiH9Cse8TMsutOeAVKCouWkZojZrCNytkw+aeaFLQjuATkawv3NnussrPMp5b7YGyX557GvyN053M/q4/TnNg1PJJkLEa8Ez/YHROBRiqyn+0hX7tNcQjpduEB7ulYPdUY4PlXLQC7St4WlZOQp8SgdC0Zuk8QhdzxTbcv4IGBN/rs3ni1zI2hr/rPyeKhL9m0dgKLWM3RkQa1zI2N4NXj/u7vnq+Mr5N6zR7mUsGThKvKL
 KWajE65j
 SvdOiGpBtswAz8l2XQvtR0Pow2DxQf9RhxI860AmhACW2JBBzVjlHb4lgjv7s6AI+2SBNZNxGeKQhI1zztNiTTeUi019w6YGHe86YMHSK02ZvsjI7yukvQOFc/6317rfoTDOtB7BfL8/TmxAKGytkGCrpAaj7ZgQGyWnBy/jsbKJaIq6KA63nXA/Gq/eQD4fjtjwUteW9s6je0OPHwyErX+9J7EJ3QojWkTHhGb8O7aVo3ucRnNjr6cn1RvZ7rMXKyDXrtEoYIuWZgvprOy5JvjRI9WwCu3fND7DY1e49/i1UhEE8hKynBkBedcg2XwDrnNvFMiapXjIUHjwklnEPnOrqO2Hh+uGm80bq7UkQq2VldNVtdGGmPsV7VPwZTiSG+2JAONVLR/PflbE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Dec 2025 22:19:21 +0100 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:

> Introduce a module parameter to enable or disable the large-order
> allocation path in vmalloc. High-order allocations are disabled by
> default so far, but users may explicitly enable them at runtime if
> desired.
> 
> High-order pages allocated for vmalloc are immediately split into
> order-0 pages and later freed as order-0, which means they do not
> feed the per-CPU page caches. As a result, high-order attempts tend
> to bypass the PCP fastpath and fall back to the buddy allocator that
> can affect performance.
> 
> However, when the PCP caches are empty, high-order allocations may
> show better performance characteristics especially for larger
> allocation requests.
> 
> Since the best strategy is workload-dependent, this patch adds a
> parameter letting users to choose whether vmalloc should try
> high-order allocations or stay strictly on the order-0 fastpath.
> 
> ...
>
> +module_param(attempt_larger_order_alloc, int, 0644);

We should have user docs, please.  Probably in kernel-parameters.txt.

