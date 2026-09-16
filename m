Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 730CEC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7873E6B0088; Wed, 16 Sep 2026 09:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E9E6B008C; Wed, 16 Sep 2026 09:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675A16B0092; Wed, 16 Sep 2026 09:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4812B6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:51:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34E08120732
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:51:35 +0000 (UTC)
X-FDA: 85219762950.01.510DAA7
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6B84F20009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:51:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789566693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeM1slf5/TlEIZ+/3YKGqvcyO+zDrbVBSRK8hiBB5ps=;
	b=wF0AmaIBfyZY5p68skYyacDWT03uzJ/N6a83zrAh5emd/rP5k6vLmqaXLlMuYoYz1j1248
	CUqmaKORzWgNxihLdDoW18mS78nTESyzT1QYzqVYffltu2ttHCN1i9jGM3njcruV31IeX3
	oX4wmd27kfG+DZTbXZ6USivYQvvlsh0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789566693;
	b=P4LrBv/PXWcBBHSmOj+gFEXHGJGglRwBJJiV5RFOqlE1GEoucBY5Hg+2it7UADFoCbtKZL
	F6FOWNlxOVBDZ0YlDv5vh0ZdQ3t0tG88zhuRW3a0d7Md9G8jOblxjP24Pmg0GakAbLqoRq
	GLtA04VzUOrdi/taukM0Ejo7AGrX2Nw=
Received: from omf04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F3BB780665;
	Wed, 16 Sep 2026 13:51:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id F091320030;
	Wed, 16 Sep 2026 13:51:24 +0000 (UTC)
Date: Wed, 16 Sep 2026 09:51:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>, Masami Hiramatsu
 <mhiramat@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes
 Weiner <hannes@cmpxchg.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Kairui Song <kasong@tencent.com>, Qi
 Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry
 Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "open
 list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 2/3] mm/mglru: add tracepoint for scan_folios()
Message-ID: <20260916095122.50cbb620@robin>
In-Reply-To: <aqn7h3BVCCRFI2TI@fedora>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
	<20260911102939.2485750-3-ridong.chen@linux.dev>
	<aqkoeJvFzqpoGeaP@fedora>
	<e38f2b80-20f2-4787-9e07-fb601552f550@linux.dev>
	<aqn7h3BVCCRFI2TI@fedora>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18SJirAJj0hlDFf3ly3wdOJRosyZeYeUmk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=oeM1slf5/TlEIZ+/3YKGqvcyO+zDrbVBSRK8hiBB5ps=; b=l1CY+DOMbpJKcpjlzAM2diNrXL7nPJVM2lngLvaKciPGh0uXXpSo40knlfQCPckEtCEolPOGvHeP5c95/CMRQsiC46J0m3lV5/Htpsp3/1pRh2IbalqgqXpdXUYRPkkieTHv4N1wIfRnlJlXDCT5by5Yq/R2grAHT1Tu+uJsCgA=
X-HE-Meta: U2FsdGVkX19UJ8lW1xmB0R2mxjz89QBslEjhduHRiY4qlRY5yOWoeny9H58NMlqDwXlP3THcOruj6daUuuul4JVZpmpvlj7i1/ijpeYw2JzEPJJ6ajaF5NxTU1dBURGCnpoeeK//ECSEYTXBLRIu8L9ys9kJvdkaqqLOL8HszlCpbZV1xNu/QranXaw+sY24EEkgWw8svkcU2JbsoDoJ99xGu2T18mLIgRAtscOoamchnegPWe7H8yx4XnV83zhHlqsYu1lIoXYPPYZJJeDpqC7KUy8J/UsvlbLmbdvSQARgBjrtPhQhXPyBQMXtZoT9
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6B84F20009
X-Stat-Signature: irjbtkznaum8zrwiwcezfwryhub1158r
X-HE-Tag-Orig: 1789566684-7934
X-Rspam-User: 
X-HE-Tag: 1789566693-511328
X-HE-Meta: U2FsdGVkX1+Q38mwHf42HIeGzZwa9gV4h7RT4/vsYFKOg3PydaPPiRLzrKtuW3P7xYRrW8fGZLbPHDHcIFXmZbyrfqcoFFQLwTX7i6+Gu+B3FwqVSZEAiFUmUFHbOBxH4EGub3sy9VSwHFLxlFJ+V5SWB4q0or4JCAXMyIyLItVLZK3veWZzJqltLSQ65eMFf7MF8efQHjo6H7/E0U0YEeVzeqIF7DnhoPixJ742cnaPIhJ2V2K0iB5mthrmA745evwT90UBlnWezfnsHkpKLXj58YDZZ1dg9MYG/7DBhKO8fJ695yXN9lNLqggruHcDJZU/QNrNVsVjjJFTBL0pBN/4SylzKVHks5Ea5QJnFVBu6hQG/NDqSHFBk+jiEB+yqe+s8MiFlZfva03zqqXtuarO1Y39Tf3pRHsdnH9ha/BeUSAXvBrz/ZvMynQYCHXDDAF0I8Wtzewrj5WgdyrUgNZgY6R/eHXnkM3TdkHDoTM0d2z1wvJh3QCaZ7qOCNxhhxnzdh9EcNpK76Fy900Ic/suhdzBOZ8NEhP4zXZz0ndshNJhFZve5Mvq/qQulJnedEfU7P7qi5j8+5ReDnf5RYi02HsPW/Z77LA37oDQkSum/FmOXC+kS2G910OMtrj52m65Y+8JhQYhH5m4zvqhrIkHFVMr8c//slTZtdZD6g446C2zzZuoUqbF61PawkCXsgsjQo4JS9VCXobrte79jPuo3+j3MyvjEUXHsiQBwoGtdDzLsGfYm83uRvNk+wSJQ4iaRuEcA5arC7NCDio6GfmWnxDJKlCX8xpA/IhTlrxVnlETH/HUPBoMR4xI5KNCIajApi1+xItI1JemLJrn8VXprgCly4d+DES4/RTz2u0pBpE8HkajLnIRlsKaDz9qN6xWQqekakI06G1uyEyzvaJW+kfEtkdqBly3I9z8PbU0+nwaxMlnvpCUSWDC3r9Di5OR/pEyPDVGwxJSX+j
 HZ8q7lZd
 9JTqYApRHbcsdcjLqnfFHBcHL2PwpUFAV4MWX1aoUdwWQFNK1Zzc6DbPZ2vjaNUj844GkdI24SsuJnJrEwedS1XTuxVU94AXe6rPqSvt44pKzYIv3mBqj8SAkjvpZF0z9JWHvs0hs+2/8oqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 10:14:31 +0800
Baoquan He <baoquan.he@linux.dev> wrote:

> > However, 'sc' is an internal structure, so sc->order cannot be accessed in
> > TP_fast_assign(), and I don't think it is worth making scan_control an
> > external structure just for this.  
> 
> Agree.

Or what you can do is to move include/trace/events/vmscan.h to
mm/trace_mm.h (or whatever you want to call it) and struct scan_control
into "vmscan.h" and then you can use internal structures within the
trace event.

Up to you, but this is what other subsystems have done.

-- Steve

