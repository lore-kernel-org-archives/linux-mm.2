Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21F45CCD1AB
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 06:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8C38E0007; Tue, 21 Oct 2025 02:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0758E0002; Tue, 21 Oct 2025 02:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6328E0007; Tue, 21 Oct 2025 02:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DDEB8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:16:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8A40B94A1
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:16:35 +0000 (UTC)
X-FDA: 84021112350.14.7B93BDB
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf16.hostedemail.com (Postfix) with ESMTP id CBB0E180006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:16:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="a Hj0ePu";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=sisca4HK;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761027393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0I0/rRQeZwp/IbShSTCGxIxrgyAXggNeKL32rwMMgs=;
	b=iEb30sRkg7NTI3pQuwqmUG816fyOfuCCjA+oEaWtW3RpSsP+HKqFdv7oiSTaDEGWYjlHcL
	eLVtnF3SD2EJsbYleQ37aeVkv8VDyP4D2eHhqPDZbjHJT3TQwy8pJCqeryeTaw5yBv/YP3
	xMIWZxv8c4TtHeQsIladdCPgnm/NvoI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761027394; a=rsa-sha256;
	cv=none;
	b=A0eigl/dQT7zKO2sMl02R7k2iuISZW3NV1XBLKc9yQQ1AWIz3PpWX35xBcCSKKtbg6CJ69
	JcFsR8/3gFMOdAdH8GxN2XCvsUG1KO3F0nTc/Wxa33JIpDfWbUIwwBU24PoNTZAc/Zsihb
	1DsRRpz2q/dDNwnWYcg2aZdWuaYi1b8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="a Hj0ePu";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=sisca4HK;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailflow.stl.internal (Postfix) with ESMTP id CDD5E1300AC5;
	Tue, 21 Oct 2025 02:16:31 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Tue, 21 Oct 2025 02:16:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761027391; x=
	1761034591; bh=h0I0/rRQeZwp/IbShSTCGxIxrgyAXggNeKL32rwMMgs=; b=a
	Hj0ePuHpTCXW24pov1BOQb4xSCLoG0iRwPOV7Ut2MeVAAcgI6yW+cdKf6rMS02Ut
	V7VCjjbN6MQOFaHdn06Y9QhCHLxh+IqGHMUd+tldZGN8f2NHF9GS+TZcQ2+yDnny
	Jj8E/wC1Nq3NuDcG/9CzkQ+RD8iDkx++Yrqn9pOybE0aZfEqtLbzZI04nKvUSWQx
	Mq4pGrd1wz2j+xCj10WxZs9R16PYYtbw6iV3AqG+bu0iWpSKIvdDLz6F1VinXn4M
	4H2dhjKpW9HqcaBUwt/hMJbAtDv+6IlP56V59xKvXvVAVco7UFaxZKgjA4GpS9LB
	VwPhZ/pYmYwm95ODw86NQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761027391; x=1761034591; bh=h0I0/rRQeZwp/IbShSTCGxIxrgyAXggNeKL
	32rwMMgs=; b=sisca4HKx4Ig/i4chEgD7FFZ6gZj0d+Oddv14Y0Jg+W7/faxeZc
	YyDPMM/p/wETgIULXgGprAgVI+qsiUhFMQBYAQTNAJKENUkuxhFEqUqlgl2nd6x8
	1zG8ZsqsO6tJYFPBcLPOthKT+5WmADvFsoD7HFdOtIMjSAaJWFJhham3MraynTOp
	dlJTR54YwpnrSemwhagqeySSF02mk5OsM0X1NwmJSev/UYJb1CEGP6HePHb7uT3N
	h0EH6vd2FnIPcF/LoNy6xPBGHqiZZdMIIhP8GWlirNkc8h3eDjtEd8jbDzhYdCUh
	5YSK7iE46tfGDwIccGRvr28uyM8FSxWvgFw==
X-ME-Sender: <xms:PSX3aJOlA07VrFa5oEBuI9UxfVU4_PGpt34aDSYfALNP9_oYjtKDmw>
    <xme:PSX3aFCnRcHza80FEeERLCpaR0NN0DGk6nVKpCX2eHvdO8rgJuPYF9im2itYBLViA
    -iXCt_Zr0O7rKaMBaV9erhPrTsXx1zPsgCWz4S1iI-BzlS6y81vHw>
X-ME-Received: <xmr:PSX3aLMzW29zICnlZwYz5nazmRwajp2x-6bkr5STG1vUPvyIp-vi9BOEXqBPGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddufeelleeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesfhhrohhmohhrsg
    hithdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhn
    rdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtoh
    ephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhr
    rgguvggrugdrohhrghdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidroh
    hrghdruhhkpdhrtghpthhtohepsghrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpth
    htoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:PSX3aCzl-Z8WNRz8-pZ7B-afK4HGqC8PE_PfiKUfN0gDP1dD6Q31dg>
    <xmx:PSX3aOeghdZuHuWQOPvnu4UWGATq0RBgqYgx_42Tk8aK7Gum1iVSJQ>
    <xmx:PSX3aN11CDm0IrZXGVhulx1jKHgyFjD-UkGi7dPt5jwF9txV13KuYA>
    <xmx:PSX3aHlyEmbgJLV8Q29c82OHwQWV6DoGPztGyi0jeMt45AnQRezF3g>
    <xmx:PyX3aEa-9s5zkJim5FjAIcfsQNkRkQnzVrxtL4ZvpaLwstPrytXxr19q>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Oct 2025 02:16:29 -0400 (EDT)
Date: Tue, 21 Oct 2025 07:16:26 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] Large folios vs. SIGBUS semantics
Message-ID: <d7s4dpxtfwf2kdp4zd7szy22lxrhdjilxrsrtpm7ckzsnosdmo@bq43jwx7omq3>
References: <20251020163054.1063646-1-kirill@shutemov.name>
 <aPbFgnW1ewPzpBGz@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPbFgnW1ewPzpBGz@dread.disaster.area>
X-Rspam-User: 
X-Rspamd-Queue-Id: CBB0E180006
X-Rspamd-Server: rspam02
X-Stat-Signature: we6ndoy3sca4kshde7hhwsfcz3fa4kxp
X-HE-Tag: 1761027393-733263
X-HE-Meta: U2FsdGVkX1+aKAY20aK4AL9z7kdlV/lH1AAi4fioolnDzjZZYnw2UzbhQe0ZoUFrx6fb80QZoULGa7qH1WnKh+dk0kBEPUt6jU5OtMD6joeunJYVbHxF7+aTRUo4LjgsPa8nKmD4dmwXFNuhqxXJIX7JCYxKypTokf4ZHuxQuqV1h5pHfJ0yxvXM+we6/D5RoXObRvrMRaDQ2q0cX9H9RDS074cQkF/0ogN4gEQCv/E2rKNq0e+F9c2pP+aUAe9rsYE86VJ+4+4l1GFLBK83xc9l4ZS4HRcXk0jhpIMGRo+J7DDNwL8GL9hpTAvigT8OM5OxU/b/AbqAyBmYn78vmKNe8s40w5iAlTXm8DngRTKkev+v8xgXZq2Gmxzx1eG75Gz6Ee4rJvJZFr9QN7xQQ8z5YPcJBD2g71drK5b4k3ItIkIaXXA6qtX+UUth4MIKDq4dG/jFBsdy0h7yMKIsAjGgPcIsCz3xehbqsp2utOkNu0nPKDLbmeDX2/SDdi8rDPEsYutDKJhkJPG9KEuKglPm/6SEGaU8OipDVzV/s/zjj0vIbccb2jLMkeeqWyifynoW7+4DLrd+vJVNhSuR6MqcxRiB+aj3mafEiGMsCaHeZkyy1Q0vVeC4sWDXrNHFQr4bz+ZzRxfRomLX/yIoAE9KRe46bPKuokd+gSP4vz7QECjFk2AljRRgeLhyUEYKz8Kh8OdYEChnV0bxPH+/aEfnvVYIWERGUviCT+y+rhAJEjQzPoGUfIJf/jXDoArxW7BPG2Ka7qcmok746aht67Qr2CKC65uOcAMJr4sM29OrbD/LsSgTd1DS1d2SyAYGE+cZhu5cSK558jDfbElFJR2hQqO/g4lWCGO+vLgmGCDF5rnntA9t4jeaR136fs6VWBnS4zsY8AgA2bf4CwVJLPKHa8RUJIjRFZ4i9TU6oRg/vTWlJt9rXGQZUjdo8hS0VQRxMTDq5wMaKUHfCVk
 N/0hclbX
 yrROdBM+nO4XuMsoBFLvQUDFvyFhsWX4inTu+S8Li7Wotw3g6ed/oscNBopDS2bR96DqlZmcLPJHBMVRxC5K5dOr15+jjQQ5osC6lPYO54Npe9QsydBRjTqWC6reKdzopbOfw6kBGPbqjm2BXonxafIwUwRQKsC47sCa3w5FeTcUJmreFShqUIf4kXtloHhLJtJkVNFHzWiXlW6PwhI1TT42FHwvVfiIofQQc/sTRVkB6qKe1h/l/3fJgOyvr/nVBjavC7u5rHMUE/e13YTBSDbfgwoiSQKhx2DyJfZmAOpJKv8W4i9+pKRlsYg7SVVt7ZOvDSp22Dp8b6NDR6k0wUl5iiCQutuPpNv5zmM1st43Kx2up5UY1Py/8OX/BlJR9GTxso2uyDGlujfeA0G6K0t0jtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 10:28:02AM +1100, Dave Chinner wrote:
> In critical paths like truncate, correctness and safety come first.
> Performance is only a secondary consideration.  The overlap of
> mmap() and truncate() is an area where we have had many, many bugs
> and, at minimum, the current POSIX behaviour largely shields us from
> serious stale data exposure events when those bugs (inevitably)
> occur.

How do you prevent writes via GUP racing with truncate()?

Something like this:

	CPU0				CPU1
fd = open("file")
p = mmap(fd)
whatever_syscall(p)
  get_user_pages(p, &page)
  				truncate("file");
  <write to page>
  put_page(page);

The GUP can pin a page in the middle of a large folio well beyond the
truncation point. The folio will not be split on truncation due to the
elevated pin.

I don't think this issue can be fundamentally fixed as long as we allow
GUP for file-backed memory.

If the filesystem side cannot handle a non-zeroed tail of a large folio,
this SIGBUS semantics only hides the issue instead of addressing it.

And the race above does not seem to be far-fetched to me.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

