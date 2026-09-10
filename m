Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC9E3C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121F16B0093; Thu, 10 Sep 2026 03:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA956B0095; Thu, 10 Sep 2026 03:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000CC6B0096; Thu, 10 Sep 2026 03:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D36036B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:45:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBE498041F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:45:54 +0000 (UTC)
X-FDA: 85197068628.04.56E0E9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C4FC180006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:45:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CZWX4zGf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHie/OUYvzpMclT00g8vWkGuNljOmHgsxZgOpA1lmeE=;
	b=QAxM2gEbMtfzT2tYuBd5oGeejC8jU7ybhwi0dIGDVvRbiwPfEo0j6+YCGN3fCsUSRLvRrE
	zG5V+IQt2zn/0w03X3dS4aPwBKfJASYyMFUYsv/LF0zc6675QidGTwATbBbqbSFqSr8WQn
	lcn/m1GR1cV+mpgxEZVDYpCQ5IzngQc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789026353;
	b=tspAljP9fNAHop8a43+KAyP/woEU5A9HyIQI0yoRf1QCCcW/+Wr54003zs86QflwyAn7qx
	TrjEWZYSJ9XqlXXauF453Ey5Cas+7DmBxbHfEI7P9epPDaP/FigYIv5nRJ5Cwo5Q6KmIS2
	RIHlbdIc9AySDKyzSuT+qyMrttejPaU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CZWX4zGf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24FD3600C8;
	Thu, 10 Sep 2026 07:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653471F000FF;
	Thu, 10 Sep 2026 07:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789026351;
	bh=FHie/OUYvzpMclT00g8vWkGuNljOmHgsxZgOpA1lmeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CZWX4zGfjD1vQw77WThWI3jUeBou+JcpJFL+9iYkw3XZn+IFlsjGzIce+4aEXXub2
	 OwRyLOxFMBeqVW26fPDu1WpwPBc2xePTtmFcUl9OZoz6zV8Nm5dshkUw+IOdoJ/ofp
	 T07qNSNkuVlGlgvmH6WnrqohagdnsrRBj1AyKWl9E6sjCJCRXshVTbIXWSgm+hGSAN
	 01Dyvh6JrLsmHjTKJ0qlP0OGn/K6a4gX6xk/kJ35fwGQ0uRdQEfUkIqqLclCwEXQsv
	 DCgVt+54VEcdy0ePOczJybx9+x8wCyNZEB46KI0YQuSkZ33a+IRvh4jBJtTq+iJEWJ
	 hI8mR9r85yR8g==
Date: Thu, 10 Sep 2026 09:45:42 +0200
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
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/12] mm/sparse: cleanup sparse_init_one_section()
Message-ID: <aqJgJrM2pJV9ubS9@localhost.localdomain>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-5-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-5-008fc8d579fe@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0C4FC180006
X-Stat-Signature: ako5d56h6yjtjbt74hzbhuczzg19ueoi
X-HE-Tag: 1789026352-629579
X-HE-Meta: U2FsdGVkX1/gj8PDMgHcYsCBV0Xyz8yVHtY5cTYzMRmJSeo0C8FRjrUvup3B4gqpv/cEbUCxAms4s30UrehHpSIGjpWHD3tb5OYRvU4BYlcWClHmmc3vtWuZN2Bi1zHTitKTy0fZ3MV3L0QnxSzJBO0Ce3B5sLipQG6oyra39ETLyhbp9BOgh64lkL/cihhNVrj5YTsLpjDzEUCRoGm8BZFJFoXwUJ/POp5LBzAnlDQj1bAcXeHkXxXWbHPhv7iJO0NVIwR7Ivh46McpaAqmy9AcOMi9LPWe41mSXKOfbYvwKOOZtkrjBYEPzEpbm0K4xjFYNOpjqvKhB5sSWNH6TzTgcIzdREJXIdON/EUOOZG9dhEQUD6jkIRJ7WRYnNuHeSVFo/0Mvf+u9P3wIytyGws60U93/xWLApWAMwbsopJbpeymxbVMU8+rnxamc9MQaY36ygq7PuGDghlxyjC/CTPTfDFOa8dzJcOISfRWhuz88ia2uHL1bu3RyAYALS99LyRDS2FkBKlERMM/am7ZHBX0g6NNsP2mOsbfOJxhOdA1h/AocpI2jS8VEh5t561Qrc52jYa4vJxM46JnQLMDyBoSwudJlRZ5y0qh4z/fvlx1WIEbbgTy7EE2Yzo/rmfDSgF/8HMKrEqSs6PTPTf0HJbQvxjw0rTX93pkabWtq4ZZ2fK/UblIQsMZ8EISK3Vac21GrgPXh/8KYL0blrHvgUfsLFbGzyohJwgVGuZLSRk/1/UNctEJxyXXO8nx+2KAYA/giarXNHfnF9KmhG+1orWzrNqUlvCPYavwMD1J4yehHa6t9j/USIz6eDA99m2lRiwFtJ5WyG3+7gtoa00wNPeHucFH5FQetHMkMT53Lwzz+GI21IHWe7EzB9IdDXaUhYek0+Fn5pVHYWXdyh0cok0ORJy1HRLsYY3NnDVFs/cYOzikEf6XOQluFMi2vWlwwSaagJmaGao8gnSGIda
 KarcHoy9
 Wq1oudjtQ6UIQbMJlgQ3UM4r0QgWCdXx1BAl3dJ4tV3Y6ZjkuqaOdADzPk6/s3r8yvacGmoURHVMI4nPh/s4i35vf6G/zVNnEHRBZcYDghIbfWPXftR+tGrCf5nsrwzBPEDn7xT2Ii6rJv3UnCwbW7l8UJDWCAW/FbBdxeBu/ZeoV/pC9TW2hfZsDvdlL9PY/99YZ+0oqK4oQ0j2t5bStvqz/nyzjh6Mxik2xYBTqFIdc+H4te8XX1P59+vJ+S6ivMLd27JVErZ93oMDWXbjZ+Nd/E17p/wsiPt4OE1xoLJnxHIXsWuanZDvvQ0ZPR5EDqFCZoZ6tpqN0/fTymZlmnZIu4yDolD2uQvAVpmMq4CqUoVqJfzn6A4pR8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:32:58PM +0200, David Hildenbrand (Arm) wrote:
> Let's avoid the "pnum" terminology.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

