Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29EAFC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 01:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03C4F6B008A; Wed, 16 Sep 2026 21:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08D86B008C; Wed, 16 Sep 2026 21:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0BE6B0092; Wed, 16 Sep 2026 21:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BBC066B008A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:23:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26E9DA01AF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:23:50 +0000 (UTC)
X-FDA: 85221507420.05.343D2CD
Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	by imf22.hostedemail.com (Postfix) with ESMTP id 134CCC0003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:23:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NSXjE+eQ;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789608228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7fiYg1MNVDZQns0GKIp0vaxCcewKTvOceR72hHoWUg=;
	b=qJ4s6nosOEzHgxKqzfzb+23jOVxhjPElpmv5Qu126Z6YeFxruWTsHhJuPKH/EJksPtYnqe
	hGThmBmp5X34AG7FuKldJoAjAFMf6cj3rJlM0SMg9wos3iEgO+dva2oLxvwhKiGuVu+HWf
	5CRUgiERT5PYBHo+iX1fojKPj5latqw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NSXjE+eQ;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789608228;
	b=ASKjwG4ClqDAywivlNP+tyZRg9lpCWwC9BpTwMfVvRElMexXBlBGCgvaAJLzREz3uEN9Tk
	VEKV2usguata9EbUPdJ/R/3u7+tR1/d6/O7nsFuO6kMws6+mdfOPluuSeWzmYlokLKahTn
	eCQK5i+DPFRR8Q1E63cjSwHvgMFXt3Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wDg1fKXgo2gnh1KZoLEb6HenGD7qVnWNZCNvYn7EiGM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789608226; v=1; x=1790213026;
 b=NSXjE+eQjTHs61mS8ahOdvlpL97CYi3Oil7vbxswIjGlHKEgS5xxU62Mx1lYLoYG0Bfa1DrG
 zOKJP4j8FYwIPImThj88zDmnj7iuq7IKZi1chAB9Lsl/+cfQZh8ej3sNWqww9qhZaAeDv+Dh3Y7
 2SAgwrYf/1MAFCRZ6hyVz3cE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 19db6483ce23b745;
	Thu, 17 Sep 2026 01:23:46 +0000
X-Mizu-Trace-ID: 19db6483ce23b745
X-Migadu-Flow: FLOW_OUT
Date: Thu, 17 Sep 2026 09:23:39 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 2/3] mm/mglru: add tracepoint for scan_folios()
Message-ID: <aqtBG9Oyu-RVI7jv@fedora>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
 <20260911102939.2485750-3-ridong.chen@linux.dev>
 <aqkoeJvFzqpoGeaP@fedora>
 <e38f2b80-20f2-4787-9e07-fb601552f550@linux.dev>
 <aqn7h3BVCCRFI2TI@fedora>
 <20260916095122.50cbb620@robin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916095122.50cbb620@robin>
X-Rspam-User: 
X-Stat-Signature: rb5ogpztraz9i4ckcadyr1jcicmd8b3x
X-Rspamd-Queue-Id: 134CCC0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789608227-875271
X-HE-Meta: U2FsdGVkX19YBocrZ0mbVdpamRSk4xfRWK+6JaPAi4XANLqHl7tW8msTlfC7iCk+A0GGgFI3rvrVGoYYTSO/SaJUL1vn5X62T58FzNjEj8G/L88Dw7lh4EQZcFvVAUoi1IsyUMg4LpIhO82+Qcsf95hi7vJuzWtE55HTKTLpDJ8JftpJQewvS4b0kp1hcHFB20xHshqaAQ3LucY4tCsNP6uUU93qU3AZExpi3zHg/735QPGXI+5WnWUFwcflO3QcPdhtTYDGOuigtJS+U+utSxZqxzxp/AsZbvXo63zH72LzAvkxw1RtEqqgsuP6JmSzVzlUU52Vl3ASpdF0ZRtERRomMgp7+/8L8bwkffmDuOUzqK65Y7pJbCiAYzzgfePs8lUMW6uR2xw+9NUJpKIawbryfjCk3lxsNb5CNYuCtWSHg3ZyRCqyWRzDM3qNJdPp/uVsKrVqVYdrRcGl7Om+SDZZiz+wVkQzWCF8eMqv9UEH5uiuRab869wDpSQ/fNeTAmitoETZ/F4pwTwg7NMphc68vaC4xlr6SgwYKFWCqkmiaz42DqYBeRKbDy/fcg2QTK8eX4thUof6PaBuR+hbf8Xzu1oYngxmwb7/WQ9tQqDt23N88ufkGrk2bEWnNlFg+tTR5BxrHbP0XNh9L9npE6tdjEkzZhJr6+JUWYvIz37Ie3hZcqhwdm74MfFJD0Z5LLBlgtvUvPT5evHIPD9c+Xxx9mkS07pvPl0IWX6JaQvlx1q4SfIKBKPSFdFoZ4w1lcBRA9XUBxGCz/nU4F6+2IM4EPahOyXmKdCJIsMR9448gQzsIMQTldid6Yw85NAxgcSoEiBOgPkCzq+5OW16iUAc6vsOQBV4Y7g6LKfkgLznVxc9GoKz6Fm4GyWA6OGqa/hu/GSDyq47hs5AMit2PTgXuDrZUcNKVc4GH2GpvB67NnuiEIhk92WdyL1m6wVUAdu+71w6sTU4f22SM8U
 AnGeDlvk
 0gct0QUrsf13Fzn2QwjvKqXu98FRvnWM8fLcpMr21ikBV9Wi7cLTyw/ikXGJWSnPj3BG4AtLPbNy59CqWlIN7z0Qc+7rQjECAUoP9nUI9gzt5RwFM2YhOWv6PMXgw6VksPgYJrzDBKANGug+j/BR1IMSmb/LtLuTuoOL33I4op6SgCn2MU7lAKzfyTs4aeo3eBPQs6GOSKKhZM0h4LamldGfM9XfJBr3OahkwsU58yXwFuHvYxahILIJq7cNr4maPVwgrReBaktC+R1AKQRIpeAzxxqwk5Kdj7COG76GnnQObqI+6YQjINF9zTVaOYtqRpDI7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/16/26 at 09:51am, Steven Rostedt wrote:
> On Wed, 16 Sep 2026 10:14:31 +0800
> Baoquan He <baoquan.he@linux.dev> wrote:
> 
> > > However, 'sc' is an internal structure, so sc->order cannot be accessed in
> > > TP_fast_assign(), and I don't think it is worth making scan_control an
> > > external structure just for this.  
> > 
> > Agree.
> 
> Or what you can do is to move include/trace/events/vmscan.h to
> mm/trace_mm.h (or whatever you want to call it) and struct scan_control
> into "vmscan.h" and then you can use internal structures within the
> trace event.

Sounds very reasonable, thanks for the valuable input.

> 
> Up to you, but this is what other subsystems have done.

Yeah, leave this to Ridong to decide.


