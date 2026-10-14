Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25303CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 21:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF8A6B0092; Wed, 14 Oct 2026 17:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56FE6B0095; Wed, 14 Oct 2026 17:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48FA6B0096; Wed, 14 Oct 2026 17:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6F06B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:48:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E2E0A8201
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:48:28 +0000 (UTC)
X-FDA: 85322571096.29.5204EF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7AC4B1C0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:48:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nmV5xaNV;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792014506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nE9p+aOXIIOki/AIut1T2dhQSauB3dnwPrKqbqAJc+c=;
	b=jXQunzNtCmCJ9qbbUHTA8MZGNZW9rdAC3YC/jGaan1IphQBcdQ65wD/zow1kpdEPcOgjb2
	+JIP3z0EOQeDbHbwpATYvucWQB61BbCCz8sQCa/AYPpJWYm1eF6i/I9KL+RSe03eVuRmYE
	6k+mw7V76Oj9W0+uQ1hWmZS9l1Zl/HQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792014506;
	b=tgkjz15wTtN6zJVlhB26zijaRVlDc91MMYulbRjn8Pzx6vu3aZYXhiVGn8F+UnDhPFDfNv
	78//DhOtIZKbuRgHw9PkMc7Jkfo8AQ+4LL5qno9+JjPDehiIucR03NY9t4a+jIFoLpcpls
	iP6DCRod3mGfvSjxSKFI6sxRZ9PDPZY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nmV5xaNV;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BA676020C;
	Wed, 14 Oct 2026 21:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190E31F000C4;
	Wed, 14 Oct 2026 21:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792014504;
	bh=nE9p+aOXIIOki/AIut1T2dhQSauB3dnwPrKqbqAJc+c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nmV5xaNV3LJfbFGcryQYEiM9V9gNC5vV908mtxNrFb8K68y2kN+x3hOTAOZrE9BgZ
	 xZk1RUwjXH3S4Tz59mmdLpXd1LMk034hsCYchfQHBtqrxKz1d+RKGuGbeuBun4RGGO
	 jBrPxe99Fcj6wK2jornOlOK/QyS0EQURvzVvIpI4=
Date: Wed, 14 Oct 2026 14:48:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>,
 "Ryan Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 "David Laight" <david.laight.linux@gmail.com>, <linux-mm@kvack.org>,
 <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: stop recalculating min_free_kbytes once set by
 userspace
Message-Id: <20261014144823.8c89da26c547fa95936a2fe5@linux-foundation.org>
In-Reply-To: <20261014140859.1006967-1-noren@nvidia.com>
References: <20261014140859.1006967-1-noren@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7AC4B1C0004
X-Stat-Signature: q67wr449kb4pm7x7mb8bgbdgme86enhj
X-HE-Tag: 1792014506-245961
X-HE-Meta: U2FsdGVkX1/1cqrxo7P6tlyI7x7izKvgv6SQxIQEdM+5Ru1tA0BD82inGw0ucylT5OjpajYKeO228sVqCdq1rHrpv4Ve0vSC1LkF1ErtzsyinLreUYVo68ULl67hhSEQAq4rLHD601JVP2kXY0JT4EwuFxllwcDk8FHp1zif5m2qQJLSxl3WorXIFRgOTbdJN+tX+hQDfjQ/4pGB+14D2Z/TeWmBv5S/l4QqCX5wV5sbTbMCCzqNAFfV1M4KXi9UlTzVhhe4RsL5S3OC0HVQT3MOTCJ9AVdrmZPvSSORueFllnzRZJvZYbEXIvAW1cxZqTQbSDhDhmJJ3/rAl/JaBN8ZZYC3wWmUaz+Nsr16yiRgJgsZOfhTuAwW7vXeHYAo5D31Xqmhy8g4Sk+KMabfpbeWHaRNq2Z8WFz17LK5PnhECCRQr/pHxoQM/C2rI3QnIgQqC4DFZLW0cAi8rbfugBpzSZTFUBwh9C9k8MOMG+flX3fx/AD8Op8qdFBUTG90cxU9liphY7MHdscmtLHudy0zL7J73YhePO5816twtjvYJaG/+/Ry5Ap+0RjldxIMOoXoSWCSGX0BBwQDiWAM2naDAKXZmq1gpfdyD4CsnT041VsLrHq/M/dFU0fk3IBEHBn4zKrxBR2wkgkzWufN5bZW5FnxKmdp+ElVodY4a5oNvqm0hiQcYJuN6Ee17MvB38QwZLTEkuT/8Ja9waRKINYP2lsu5wh8wMYL5Rb3M5BwkVaGWqEAvHCGLgpGIe2ptvnI7ewMlhuCVcfmjYUrTE1eYV/6P5k67qEsqbfsGS9m74duG/E/hBBvYexgiBvdiO2CJB8Sb95ianTuaekDvRdyLp27Dvi8+4bC2/SB2BeuTI+ArhLbt5EPLibzI50OxUPJE6kuL+PCDHc4pTUI5daSJbJJHeL6wbv1fR7wAFtr2vH0z6+KK/rM+d5hMOEIHf04yrxe/OkKrfWDtjV
 NAfTE9Ir
 3wqCieYo71OIqBbHXScHLWQoijCmHqlMwZYPXSyJ1ZvouydPEtHccj1W5uv5wNe3Dlk6IJNANuoAdnWtCuIbsWJh6bSiT5/72VR47sDPNlRKxaZmb7BMeevbDINt+L8WXCLoLWKvN4Mc5Dga9wO8+2489TWCqvn7fPEUeN421wDy74R+9e2+ImIZ/CdXmgO783YvFJCeibhndo5TUhwjgpW7kvlty3KNqcE48z3gHQ8yQaePkW5R/fIr19rIRZxYPCgwG5vnaREeQoJ6UWaxwsIlozobyZCTT0b2a6lfhP+740ynBfXDd1L/kMNocdLqeloSDsR4Qvjdv0YqR5ye7n98qdSLqaH8Jr8wumxThy35akTmgmGq39/pmbbiIdhRhF2QjKXq5GZKo9PU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 17:08:59 +0300 Nimrod Oren <noren@nvidia.com> wrote:

> min_free_kbytes is recalculated on memory hotplug and on THP sysfs
> writes. The new value comes from calculate_min_free_kbytes() or, while
> THP is enabled, from set_recommended_min_free_kbytes(). A value written
> to the vm.min_free_kbytes sysctl is replaced whenever the new value is
> higher, so a lower value does not stick. This matters most when THP is
> enabled on configurations with large pageblocks, where the new value
> can be excessive [1].
> 
> Stop recalculating min_free_kbytes once a value has been written to the
> sysctl. Systems where the sysctl is never written keep the current
> behavior.

This problem lies somewhere in the range of "minor annoyance" to
"catastrophically horrible", but it isn't clear where in that range it
falls.

So can we please can we have a paragraph which explains the real-world
userspace-visible runtime effects of this problem?


