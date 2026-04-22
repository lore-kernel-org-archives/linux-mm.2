Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F38F9EDC0
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 12:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B206B008A; Wed, 22 Apr 2026 08:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31CA96B008C; Wed, 22 Apr 2026 08:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231E56B0092; Wed, 22 Apr 2026 08:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13BB26B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:30:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81C6AB5C96
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:30:57 +0000 (UTC)
X-FDA: 84686126154.02.5D5EDFA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB183C0017
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:30:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=V6YwThkO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776861055; a=rsa-sha256;
	cv=none;
	b=5PBvMO1KDwYHKoqMsWyUTX1VRuZ04Ijz5sTJRm8r9AGQIl+7q3E4OIe4+1+XDr0b6cixOy
	4LPpvTs5LqZfpg1e2rUpf75AtJEwmYptK/TqhJW8E9pRelSJXUXv+tD4KJ+eNfwTap1llT
	2X5qACpXc0dyqlkGm1wy8giOfxU7fgc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=V6YwThkO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776861055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HR0UyK/31h18NRfVg/xbPHrrMlhCbADOJ5J0G4KLAtc=;
	b=Kf8R/QtOI1Wicas9BWftnBwN+OSyNBFq34Wleve6UU5lxr3t/1jy5S/r2cSGLgRJOYcy5M
	syi2Wm6v1Um+uQ5X7wFHBgUCkYsMV6/erjuxcZIDduoiY8YUbV9kvxNYId9V2h4SqXeUTj
	vNarhyLXdzaP+NIGFKE9Fvg+Wzh4J7w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HR0UyK/31h18NRfVg/xbPHrrMlhCbADOJ5J0G4KLAtc=; b=V6YwThkO5mpdkuaVfYJxPlVFx/
	dWtOXdGaDBoTt/LI2JxZMFt+YG+bFPXedYLa2PTo+pecMddTiAIpbHvCR9p6eNnIW+a9UzYQWXRav
	oIg0fRFBKqUPpTxWi3lTRlvMcbOczQPPLal4pLlSPF9f5Q2X6yE/VOOdK2yCPEYGoeylveHLbZJOy
	pLr8ptEX07CFHipvBuFjfdeUPsNhXGhhZB4pYQmfzUpVDOXJddYWu50zdP1OFijpkPODsseDlOlhy
	JJ9qMuPiZTvWCxnpdMaTaaGe/1LLORiQCqE9vdIsAdKUegekx8v5u5WhdYkZlvUXaL6GjiP+SBJXo
	PnlPmcnw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFWjA-0000000Bjpp-11dj;
	Wed, 22 Apr 2026 12:30:48 +0000
Date: Wed, 22 Apr 2026 13:30:47 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Frederick Mayle <fmayle@google.com>
Cc: David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kalesh Singh <kaleshsingh@google.com>,
	Suren Baghdasaryan <surenb@google.com>, android-mm@google.com,
	kernel-team@android.com,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: limit filemap_fault readahead to VMA boundaries
Message-ID: <aei_d5KMKmLhMx3S@casper.infradead.org>
References: <20260422005608.342028-1-fmayle@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422005608.342028-1-fmayle@google.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: azwd8mbjknag885ji9hoeaf3emtri4t3
X-Rspam-User: 
X-Rspamd-Queue-Id: CB183C0017
X-HE-Tag: 1776861054-852922
X-HE-Meta: U2FsdGVkX1/sQJlvg9Q/4EwNe8URGUUeBWicfVMSKx7NKFdm6OJDc+OU+AbViJxtr6tzmkBytboHZQ+uePXvrcXQR7d8+wT9M3eFC0pI9CQlmP3DdZTQ4zoxoWvfSBZ7ldnZj3V+8yfBNj0/4QcL7qVvJAESxh+j2GPT0Pq6FnXa5s5bNvBch+pfx9Bh+N+6MZ7cvwqem8FfWUAOQvxAo075oPreoSr27BHTB7NcF7lGA53zr85zcYBB53pZpYHrfqyxVAvoK8KcpIZzqjY1GPS1rw5HRMmc11Dt98+WPRWBnhJC7A4HOWMkAzvahv1dfJ0xT7BXvvN+qRlXjeniqhi2sZFxsZMfqC8XalZF9aVy+m3E4YHPLGyqjlntAAtToHG9szPGBGj/mfw//xecCqnU52H5JxpvAxinRQV5MNakT+wtdD4eZ2i+21iJE2ku8Ak3vgaxznvIEly1y8j+xcvJEDHqjRY+P/umXdqeYCabNU8MheJSmghdRBYnCwBYCUCM6rrcfn/hoTpwN+Rqql9rez3kddOv7ZaIUYVoY7Hiee8P4Yq53LVPa3AHSdgcjGVl5n3stX1tI8uyQiCCx6pU7ulnmeFdkrivwDwo7EAYUmnyFJouh+mOqwKkI8lKaL4DtkuhH9nek+Xg9GMzBeEHVzoLALWk7VSaCKLh4rWllba6/2hdw7dPOhsdyvtg3So/Ht4zIx6htqaK1rjDJ/3GNbBDrJrGIct2YcH9Zb2DKN3mSTxlO5Cw+yCbuq98BOFulgTCcyvUcwXnhvijRPJDbW7ReC5IbZsr9a8l5ok4Ht5viha3VdNp8K9h/Kn6mT+/dI8bKUWLWD+pIBMlfRaLp5EikWFfEGO0yAkmco1tCxzZ8FTEdt5J5Knq4BgEdawFMxOT71ShNAo3KA/O38/HH8G3yBmnMbVBJ8ebEIRIAw553IXYQ8jDly9RHFEZGycOyMZXpRE74fQ5KTX
 3pWUyY0c
 V6M3lxVsf1ueHBpdDSMPorgAOhOOP26zAaAtG5YVXfzWBdyyQrc/3mv9iIbykM8UVjwdb1aivDyLmhg+auBKM8i54a+o7al7eZDrFf8Tv3bIT1sSgR4uH17aYwkiEUk0YbN74WhQRHjSyBypnkGxeocZ/OV/Tps4vVmJYaH2RtyvOd7fJpiszY32GK+K1VAPAvTQsnEZpZ+ub7Dh127AvE/CjwioTgqEfW7nhhKzIWOyiuwXnkIz2FngHQ76GkRU+CLsaztYhzVHCplGCjwI7wlZTcNNEUuHR57oC21RyCD7QTWsY9XSTjsO8CgaVFkvjk0fx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 05:56:07PM -0700, Frederick Mayle wrote:
> When a file mapping covers a strict subset of a file, an access to the
> mapping can trigger readahead of file pages outside the mapped region.
> Readahead is meant to prefetch pages likely to be accessed soon, but
> these pages aren't accessible via the same means, so it fair to say we
> don't have a good indicator they'll be accessed soon. Take an ELF file
> for example: An access to the end of a program's read-only segment isn't
> a sign that nearby file contents will be accessed next (they are likely
> to be mapped discontiguously, or not at all). The pressure from loading
> these pages into the cache can evict more useful pages.

The problem is that we might (for example) use mprotect() to mark a
portion of the file as being unmodifiable, but nevertheless still want
to prefetch through it (since it will be read, just not written).  I'm
sure this solves your problem, but I'm not sure it covers all use cases.

