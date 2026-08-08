Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01890C55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 09:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81786B00A9; Sat,  8 Aug 2026 05:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58C86B00AB; Sat,  8 Aug 2026 05:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95796B00AC; Sat,  8 Aug 2026 05:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4ACF6B00A9
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:03:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDDADA0300
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:03:37 +0000 (UTC)
X-FDA: 85077514074.14.36DDF2A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id DEF8240002
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:03:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QvRzy2ed;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786179816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62QgIjRPmuHGLS2qksqEprqJ+VnHH88j0ClesfgjsMo=;
	b=KuCfzICfGyhv/1lch3HL/rFwrBDL3ney+2QjGYdW5mhkH73P0rlTiw90TtyfLnjsizjCyk
	+526UlGVBVrLCyx3aqg11rAYilphDWLW5hzU83rDEsRr6MJGY8sR3mZXDEKbT+BDEflDDh
	Srmf70FjFViewAa92t/+zSSeTcyxu2I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QvRzy2ed;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786179816;
	b=uTUtbN/549p09uXklOc9dKYfC6ksGvMlRaeXWPXwyQI8eW3hi+PoG8TmrXoa49u45FYq38
	+CxGbBvNnv7y1lAfnHV1X4UbSGcSxcbCHlS/G/gYuqELqWHwei7haxRJnxvsSFWxLAa9Iq
	rHttHBzVWc/aFM8WTaDywJNRTU6x+L0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=62QgIjRPmuHGLS2qksqEprqJ+VnHH88j0ClesfgjsMo=; b=QvRzy2edg7+BtT1irb+jWs+xZg
	WKG3JADZsgD5983Kjk/ygeoKuAkatqmMqlNpRgw4tmHcqbtk5RvpWf+Tj7w2qX7wKq116yMHHFxca
	sjWHI8/4trMi5q/7wYFkOHpOQWmd2pw8Et7oQycCa/bpsDof/8hbJQxXhHcdQsGsnVveofDFKoC5U
	tOlK4kph/jqAF9ehvB22UxBpDyhq/8h2moL8x1VU9XRtWn2istQMt7XHZGxY9U0cdjxSuN0TfbiD6
	cF3i0wAxo5WRxIg73TC8qkdMzJfAOVNcMPrXlltaj5Au1L8jmTUwuNf3lnnZiholtlUq9DRzhfut3
	82VD2ocQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsbRu-00000004kIM-15Cw;
	Sat, 08 Aug 2026 07:26:30 +0000
Date: Sat, 8 Aug 2026 08:26:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org,
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com,
	aliceryhl@google.com, arve@android.com, cmllamas@google.com,
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
	davem@davemloft.net, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org, syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH v4 5/5] tcp: Remove mmap_lock fallback path
Message-ID: <anbaJuYXEoldvtPn@casper.infradead.org>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-6-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806200548.3124802-6-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DEF8240002
X-Stat-Signature: 1tbnrygqbk9xo6m7qg9kdb9qizz7cidh
X-HE-Tag: 1786179815-413994
X-HE-Meta: U2FsdGVkX187o0PdYylC7LKR8pxp7BjQ/WIOmD23fYiwBf7qGKgBlQrkWy60vFlK3A4N2glFBN9k2nJD7cznlYb1RlHBUany5SmC7SPtBkv9FeqQztF1TbtXh9OFzILP9YZDg23T8D219+4cQCx2hvM/A8oKuaC+12sa7ZPbipUJZsXv5mvXY9Qg9z2We2A4eezI2S2iy/BJqFaOjs1F6MsWH1SfubCn4ZAsrH/3Q0soOTlmzz+IiliuzLBM8JNI7AX0OVjIoCX8G/6tx4KzcnwH5NsShB3Bv1APpMHCGvih9m33Qz5jI9DV0tgX8AAUOEQvSJH4EInrU3xu+4ccB9FZ/DhaRaAjebxgSa63Czpsct6JEj5coZrA3Z9t1und2g3zQVx3LC7LmfB9RApc6UxwMeWY0BDl0NTBE8Fjves5EidaL6mJm0sIf2CLdGFRsxQChHN3FrXfbiw1j5fWNWYRFHraUGXeDGprtbGJj4LGx9EkB6Y3lxI88xoY+029diYYlysEtpLYAquGPWiWgammKfNCwaQZ8U6pePROCClw0AfKqJVOfEecsdMNItHTexRm0M8/TPcjepLZryuGvRV8Bvo4Fixu4lCWx90MN0e+Lg6au/NR4jOkdYK5ETkN0BiXxFh0bSA6drYZrOTC/6YXeeZx4B3UZMTaJ76YiqCP3dxqFHHtFLU6Ipg0nGmRfHZ6BFubOBbRY+hD6BcNVoQFXiWfTJ4GqgTe9DCPhVJydJabVi1sRBwIRqdARKWOITM90EGavKu5ud3p8Ntf9PQZNQP6vzKyb5OWtDFCv+90Y4XvdhoER/xQwHr9s30e4uFuy/etZSSNnU4pLzF8kEoVvi1cSVz2FCoEyvlyqvfQCu0Ji6UiCGuvYA6+ZTMQZSp7Uh/I9Aqebi4B7x3bHS87L51ZuHWwcVldHOsbPX/U2Ywy0HvoI8kG/vZuKUMDOX1I/XRnrZf0g8oR3PN
 Xl5I8nrf
 IvBpkfz0PICNIsf1d3ETXAPkDhki2TL/ip0VFIO8qbtYV432gFOucue/VRqh0KVITmqDpXM3rSb1SvJ/TkEqewN/+FoH8lHP8Io0PNcUoDSADNU4z82LqwxwbloxJfgCkGAExOusr5VFxWBecQ2z3X3mFWb1Jh5LYxqS2mk5qJdQEV6ucuWz0GO9Ysd15WRkRBNiKYC7VleeclKlFqDtjE8gL5mIYjWmX9DwPqsXQjCa1ckwIg2HmTDxLjokp4lFKkmYchAjS+QZqAtCAm2w63ehVfa+WyWSkW2kLZzaTaeEvxM/HdSXzGPAE1LHxDj3qMtP6J0Fx/Fb70+hTBHIuyfj4+LmWOXqmUVB50DZAFqz6Am9RKBwPDoeUDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 01:05:48PM -0700, Suren Baghdasaryan wrote:
> Previously, the per-VMA locking could fail in the face of writers
> which necessitates a fallback to mmap_lock. The new
> lock_vma_under_rcu_wait() will wait for writers instead of failing.

It's not called that any more ...


