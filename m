Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27EF1FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9996B0088; Thu, 30 Apr 2026 11:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67AC66B008A; Thu, 30 Apr 2026 11:52:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596156B008C; Thu, 30 Apr 2026 11:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0996B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:52:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05A3D460B8
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:52:44 +0000 (UTC)
X-FDA: 84715513848.14.FED90FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11227A0012
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:52:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n69zv3t9;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777560762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62S6o2GZNskLAXNRd+Sj7oY45bd4T2l4s7IyNjHcv10=;
	b=q2+EIGo55qGfHsZ1E3iOvQZ3FYV8jlcbVEDD4s9AidRn6bBuNwzLAZ09Tk8dMxWWh/vkIK
	dxpWxQa2PfhWChBdpD0Wg8mpiq2m0x1+MvRq6vrJRM05SSI4W+eQpkQCB8XvbTDgqRf0J/
	T2Um5CAJbZk8WdtdGzIJWdClC1Fstbs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777560762; a=rsa-sha256;
	cv=none;
	b=Co8AZg5U3fBzb9qpidYttwdiEGX9poQ49in+lGYaNqJ7BwwQ/+JS05juKWOIEq9JIredsA
	R57b9mw/virpR/cJkLcugeEQZXfm616DEy3edOUT5qtTqxfdCRpRnE+WsmTitMdmBLHj+n
	kj7P2Er/3kjt1fQ+UTp8SSvFhZMnCQc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n69zv3t9;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C234543FD0;
	Thu, 30 Apr 2026 14:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712A6C2BCB3;
	Thu, 30 Apr 2026 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777560760;
	bh=YbFKQp1CWU2BNmbn4Lt+wO5guEbZeGI4xVzO7V9p7JQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n69zv3t9cf9ZBucWEfY3LTmi1/f8ekNkqKP3mixu6Gc6c6ujNL2kTcNeNbKgD8g5r
	 X+eZrJ+RwT9e/m9mQQUV8Z/LHgFUuHn0dvN8q5HUVq/zwzfd8W0dX/cglBnI6+Uiyk
	 bSjw1C8zeVbBqjU1ep4zK14JWCVKmuWstOS4i7c0=
Date: Thu, 30 Apr 2026 07:52:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/alloc_tag: replace fixed-size early PFN array
 with dynamic linked list
Message-Id: <20260430075239.efcceac3d83ede2a2d22158c@linux-foundation.org>
In-Reply-To: <20260430020226.34116-1-hao.ge@linux.dev>
References: <20260430020226.34116-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 11227A0012
X-Rspamd-Server: rspam04
X-Stat-Signature: 9w9ee5oqq5sztef85eddt6rmcjjtexf6
X-HE-Tag: 1777560761-854218
X-HE-Meta: U2FsdGVkX18T7FudH3+On0Lvtd6N2Ms8jBulz4UDRAk2BqzUT0WE6q6rGh43sr1Jnyj/XfrC1eBD6IURdUK5T89dB6sFP4ERPRs7zTlBC9QDoBE8iGWLofy3MW9SJ1aJBVP5DQDNmprjfqWHaWfNx45unSO/cgRkL6qrLz8Jeg/5vIuSyDtavQiXqVTM0eTfRA1XKbIT2otltDy3jXZiDKmsZs+0U970KeHJDlThSO9oz+IoYSP0SiKgY5GxgAkwpPUTHXtEgm+2ZatxZ1JkBtgAKgmgP777K13KY4UzhwCT6UdS3kslcR/Xy8kqbknvOGzMCCWGTTtVWP/D3NWC/9dySZjiuqlfuW4YhweLYhVVhob56Qpzo4r/NCtIihuIeBXlG65jzRjycqtL2fThX4mqrYXV3cks+cVobjYjWyi5NGr8DcY2AQ271EmFvJVwXCFQTCEgP59YNSCnqn4JS9YflLKinq1SnUcd/o0xI6mwIZ/WpIX9HaKK7j3OCH3dnlVqFnJ3TszhpM0uvNZ+DGST2VGwisGE/c/+Hqp1eR6fTekxLqfN/hgobUNOlyDExb791UyefrBewKC1lXYU27hlu9tNNdz+hYedeCRMXLgv+Ta2Pb+SG5tv4PUsKOa2zh0yOBCmKqrc8MW4RCfMOvS0rVYbP35pMUuyqsns/Cekzme5lSGa6s24VNJ+eeQlKhxNkv9SD8H+F1lnUa3gjAempXvW3WtfZMJGdJYFqMOElbzZHa534bL27IUC5xlGKUBY6UsZF4OQZWU+ELyIn8uiFn8tAFZwm0sS/jQNCLRnToK5qM/5QbsVi8ITQhWwWpfNzMmBIymyre7fGBLXy3hJ87WdbUUvH6S0KpGqhUSnzAmxhh45n3qN+mFe9MX8QKkwuhaHTx1vV2PcsjR8i4oA6jUrkFgSTJY864t8E1aUu6LG+21TTXtwKObngURPbmSWbjFNGBkSq/NIp/q
 jUR1sqbe
 4xn4LEuRf/RXo6zjGyacPvcvMXb9DviHqw27b5VMPROLGsJk2h2zkYeZwXrfj60WyiwYw1vbdfKkafd/hjXvyLGVxzM33u4HsPOcrtWOYv29TiCFgzMLSqoHBZjvhWKVRqh5+PpFw3NHbilt5Xk/1LZrCzRqRzxVot2Gu2DSxI3bZWLomddE/PzNn8a5YkU5dMOs5fdIjqC870fs6ZKpbQW0zG8pkYJC28KOzrIJx/sFzqADrVjQXAnOVfQuI7vaKpplB0dHpqbkt5ENcxR1C2pZPd2iC8oy/Hq1warbvgsibu2l01N6akDbji8OenZ5DxnS9W7PsbhgRCiVebcCXj8P5CTpy3MKhkJg7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 10:02:26 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> Pages allocated before page_ext is available have their codetag left
> uninitialized. Track these early PFNs and clear their codetag in
> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> warnings when they are freed later.
> 
> Currently a fixed-size array of 8192 entries is used, with a warning if
> the limit is exceeded. However, the number of early allocations depends
> on the number of CPUs and can be larger than 8192.
> 
> Replace the fixed-size array with a dynamically allocated linked list
> of pfn_pool structs. Each node is allocated via alloc_page() and mapped
> to a pfn_pool containing a next pointer, an atomic slot counter, and a
> PFN array that fills the remainder of the page.
> 
> The tracking pages themselves are allocated via alloc_page(), which
> would trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and
> recurse indefinitely. Introduce __GFP_NO_CODETAG (reuses the
> %__GFP_NO_OBJ_EXT bit) and pass gfp_flags through pgalloc_tag_add()
> so that the early path can skip recording allocations that carry this
> flag.

Thanks.  AI review asked a couple of questions:

	https://sashiko.dev/#/patchset/20260430020226.34116-1-hao.ge@linux.dev

Please check to see if there's anything legitimate there?

It also asked some different questions of the v3 patch:
	https://sashiko.dev/#/patchset/20260423083756.157902-1-hao.ge@linux.dev

