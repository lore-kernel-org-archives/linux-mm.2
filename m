Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C473BC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30196B0088; Thu, 27 Aug 2026 10:36:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1A36B008A; Thu, 27 Aug 2026 10:36:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF5C6B0096; Thu, 27 Aug 2026 10:36:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 719AA6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:36:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF3241A0450
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:36:43 +0000 (UTC)
X-FDA: 85147300686.12.322AE60
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1A86612000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:36:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="e WQUpkd";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="fil9/Yl9";
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787841402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8Hy4YJ+WnWdSGIVPU2j3CskGmM3nG/le/p7/8k1oIE=;
	b=aUQZ9VYDbQGVEp9/VxkzXSSpmeWV9przZp/2LUq12AWkFiWBjw5UXUXMnTwQWn1mJ+nGB/
	IG5k8VU5e91AJGEnmlTvYrGrZ4ZKQxxpeDjZFfCuzDiq+5V9ZDwAnYIZqqZU5XIndUvNr0
	caXexTIn16fjI+cWc1RtycIjeUsN0Uo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="e WQUpkd";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="fil9/Yl9";
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787841402;
	b=WNd0pQMhAIP9jBrbIfBc+huYi+VjDyT3XXYMydB6qlaRBeHcL9lNKKFVfoNEfBmhQC5K0/
	v24vDD83CkLZ0xKNaM206JG2e1jBRiGIT/h9QkA3facvziHrJpXHAqDmbFG4lI3lt0oV5N
	itZnHcnCIRBKnP9a1hFS0hpXbIjsWM0=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 885C513801F4;
	Thu, 27 Aug 2026 10:36:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 27 Aug 2026 10:36:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787841401; x=
	1787848601; bh=a8Hy4YJ+WnWdSGIVPU2j3CskGmM3nG/le/p7/8k1oIE=; b=e
	WQUpkdyIoTuVlvw6CHssbWyzbhw9pDNgrIwJrvmq+WFzHyH4zwkTVXxsWcR9R3U+
	gbdmwHSkzI7mMyogViyReou/BO4ZF6/gAC/kjbkZ7vXTBKDOYXryyceb1COPcLlf
	xx8Ur4K1FsofFpIJSdF4w8u0BtjHcgsqOXEt/3RwTOs0t0mZ5tqDSReDr7elFMaC
	JqrSGD8M/57bg5YcawRSTxD2o/KDVxrdvt5LobcgssAY6tRGFiY7a+4AgRCkifI8
	c1WnCliiZRxuKwUTUhjhlebrDWMuvXi7uzp05c7ML9PbKajF/5eeNOwcL4J5qunJ
	bOrCmAEgbUuXj89+BprYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787841401; x=1787848601; bh=a8Hy4YJ+WnWdSGIVPU2j3CskGmM3nG/le/p
	7/8k1oIE=; b=fil9/Yl9fdf+BVXh60B0g3atpC4na1gwYVafsJrX0cKnUvO8Fj0
	nCjJklqkxRKZoZUOApZyp0PNhQNreN8Xe2D5wg5+414E7JMgmC9RwedgAas0Lz9T
	XoillEKsfW9ocm9S9k3mL6+CUk6oxJiJnsipWnRrjjGWKTgrJE2ICZFcFKuuc36L
	aAOrh+U9rdzoWbe56YagPFT2EmVwZgpVrWKeQHsP/+m9KAPK11LCzNUlvX6sg2Mz
	EACG08zEAr/ltC0dGKbTOWsyyXsKF7JHX1VHCOHF6Jx0QzzPDs6oATSvWtwb6D4o
	7QKO9OtSaJe8mU1x0gZUpC+TJpmHvzvVYGQ==
X-ME-Sender: <xms:eUuQajy_8lVw-mjT_dlN3l8bZOMMgkin4fbWaOQIWzGUTYclYVXePg>
    <xme:eUuQatTb5wJB_RJwguPJg75tSCfP9Yw22qIXAPmpEFvvbJQksHJVOIaSqTPpealTk
    ARu5sVJagqrN9bLPVAvl1z0wN8tbhgG9itNnZ1nxtCQP24t-9Tkt8Y>
X-ME-Received: <xmr:eUuQahrG470Lq1b_gW4pxCFnuZHkOA-gA5Sh3cNH7SzueqPvAQMvmya5_Dg>
X-ME-Proxy-Cause: dmFkZTErUJQUVhkPKiqkOcN97ogpHmISM08edx6pbjBW9kaOnTmBSwYErevqtyjNmHVNQV
    WtEj5qaE7OZejpVw+11lQe24wQYQO3n7gcSMB3M9cwcJL9PQQQQXBQxAEY8QQX3zzlMAbV
    F0/GTC5zuLYBZfpO/j6rOdBYyG3nLr7J/+jf0lEq6zlH2iRlrqYtafGTbURoJwq1sw/Vos
    6zLQK10XMSRPvbzp8Jt8gDvkMRwouBZRqYWgq9VQsca2hGV7Qnr+tUSyUnEmP/I4+ANAW8
    BOgTwjdf1cmX+koJoy+Igh8D791vQ8Jqr3NlRg0bLBswtvsdLSltp8+8c92wcGXhU4rEVc
    20Ez4JwsEsEUT8x8nGCXkQ1si+p1hnQC5Y0Sc5NuIKPpP4Hf6wkFjfB/BSqM8MC78nhxZT
    y2bpAWz1OaZBzF7j0zR115CfrBDoxOQoDs13rUWvqQOM4rCIEi6DJV0sY6mj0f5vv/B9Jd
    bjT+05UTyk2/ZQWGS12RRm0u/jTw5y8GvDNDbOUUsVRaKNGcjFNvVqJbls4ldsShYyTAla
    py0fIVqDhNkwUY7ngKcH6Vhoo0FV8NKRTFHPDDkfqeo6COO0L8+QBsxT/985Fju35HLAHB
    C/q8Z4RE3CJfEgnoniMUqH7szN1ozhanQJHwaaXocpQMQfqn7QW/TdnjGXIw
X-ME-Proxy: <xmx:eUuQalvR0stlA8xpKyuVvx3x11HtLQyX2zUnjNtaXoZtB33dRQDIww>
    <xmx:eUuQauuaYOXfH1Pt6XD8buemfRfm-DN9UNo8L8ZRKs06rV65yjL6Kw>
    <xmx:eUuQahrLI4reIbIKjYWAi1bXXnYWHNT_5e0L6hy1IQpNhwv7QfQFyQ>
    <xmx:eUuQagG7HPQcvKxdT3zgAcoqlq6fEdkEE11p4nwiP8OiykQ6Yf9CuA>
    <xmx:eUuQauKvGAmRsBuBFBfm68W8EiX8UNXNcsELKBFTf7q_oF1KhihCanBE>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 10:36:40 -0400 (EDT)
Date: Thu, 27 Aug 2026 15:36:39 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v3 02/18] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
Message-ID: <apBK55hfvYtGDpiB@thinkstation>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A86612000E
X-Stat-Signature: bg8wdpxnmt5znxueiuboaw7m97huqy8x
X-Rspam-User: 
X-HE-Tag: 1787841401-318239
X-HE-Meta: U2FsdGVkX19VNytF20OMy9o8wPFJ/GYYV+jQuOyu6I7Ga8XUuD5gLLrDYm/J5/7QAlT26bu057GuXKlwENP9M8RhcP/1yfLJlnaiBLCI3G9bAJHS3LuFt18wN7qOx+YyBLNS6wMvquIDzzkV8Ym8o2OmwQlY8tT+DX2LrjBRywg/GM9+b4cXOxDDjpXvOFnr/9MmxknW9/JYPhFaAvx5t0HBfRCZKYpU2+qTIfxaijfjr7uyku4cTqPnZgVyQiZ+Tm1eAxR+qQIxQOfN03OTl7phBu9yPh2hhrGbI7J0zJqWzFeaZ9uBb9Q3ehe9wz6kn0Jn2otNw191hqjnbPDLcxvHTYJZH0rOrPEa6QQOTUr7BQmZonWrDO+QNO6qhAcMrgr8eJcFeZnpvFfRQOf9kJed+vVU9ubfbukMwvpn6dJjw4SmiTBgbbaY4KERVC0muxdY2kXMzAFR8JcU5XDXCDdNvEYzHysgcHlDAPJwpONC2vI5J5iY07baNdgVMhmu+pPXF6QZczw0owyuVZ1sFADWcLd7PBorelnQyB2tRv34RpZAfRi35Hik0uHOKt+6Vp0jZ/+FyD/WphPJOa5DIsFqGentNJJZgKs3MJnvk1Ekoo4yZYE1B7k5/2E4LqRpxHJgukvuBSXVyH1F5YQlDjgYbqb5DyDQboETDNTu1xJ2IidXNO5ImowqDRs+TcmF4tQcwFnI6sW5DZJAB3Jl3qESsSblPvpTcpCqfCX02UGvVtqkfpV+1/uC2qV0PWaMvicLnt6vcvclugKUAZcQKVdWXSwH7Rbr+yU2cBiu1aTVtkDrZQOS7be+OiNOkPbFVu7u+HHrQd5td9rt0a4nkuOXbOgSKhH57QNrjqdWWdDNOLTmCyG3x/RVpdiYDTZMIYL7uu2j9wO7xQeGU9DJXRBs/wSQ5OHnMKnVXvGLPTo5W5rYB3l5xWs7QwglzBIZKCqpdP5WAo+GVjm0L2F
 aRHAUZQ7
 EvQkGFsf96LNrt3gXJf9ueCPkexzEtiRwro21rIWD+2UtE9NWMgM9sC/oEGoll+jbBlnwa/QhlMwGhsfCSUFMAwK0N9QXiwyvFdC9GuJUMlUjDfJPEqFwYhit7l01JumLJQ2/f7pQQk695zZbUWjnZJaT0VU9V/VAKxW5k8Dd/x/exVECnacVVMDpw09XyVsbg7UeBeowwHZT/E521Rwi0TFg0N27J2c7RF2wRS7XxbhHj3zZg5/ZqMXZns08Lud5eAuBVZiKKVisaO5fnwNi4/f0yaAer0/KuAz8fpckPpkQDBCQ/emXQB51M3tkUWyK1mkoQ+lgRR9k8FBsSC8rOsaeisyFsIj8ro0RsX5L9bSCpsNEY9bDF/1NuY83OTvTzI46BgJynaSh087mpe0yvMdcFlH4wJgApgmrwmPQEMETwsbaF3QpnD6etOqXsAYouyZHCdMwEZpICkRybPWVct6PB+4rwSafT+ldhtg+CYEsAss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 02:55:15AM +0800, Kairui Song via B4 Relay wrote:
> @@ -3886,11 +3889,11 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
>  	 * TODO: this will also currently refuse folios without a mapping in the
>  	 * swapcache (shmem or to-be-anon folios).
>  	 */
> -	if (!folio->mapping && !folio_test_anon(folio))
> +	if (!folio->mapping && !is_anon)

Just noticed, !folio->mapping is always !is_anon as folio_test_anon() is
encoded in folio->mapping.

>  		return -EBUSY;
>  
>  	/* order-1 is not supported for anonymous THP. */

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

