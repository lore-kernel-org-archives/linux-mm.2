Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 880B6CD6E49
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 11:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28A36B0092; Thu, 28 May 2026 07:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFFB76B0093; Thu, 28 May 2026 07:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3CF26B0096; Thu, 28 May 2026 07:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A2C4A6B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:04:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4129DC2897
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:04:56 +0000 (UTC)
X-FDA: 84816546192.24.8BDBAB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8D3DFC000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:04:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCbfHbhj;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779966294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1CtNhjUDYMnWJZV/Dh2r76Lj7h4Wsj50+rJVpRB4uMU=;
	b=SCgax+zrBl8RAlkHg8XR0efOl3e1HhBXRp4wL8uxApMj55ETbh0Fo4UALDoavGygNK7d7c
	SkpVH+IpmRDdtZfw+o+njA6/PH4mdkVrvEC7eCbaItXt5471QTQHJSTboNUs2StNOMbDXY
	gaaKYId0bRUXek0QHweOTJaJhZeWHjg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779966294; a=rsa-sha256;
	cv=none;
	b=R7nK7MdRvDCZE9KPa30Q5dta80c2GJ3CoHj9QAdy54qyHxv7Y4PU/hbNAoC3M8sAwgfLHK
	BpD6Cmrso3aBd/T8JnDWqilcydhueZ2+iL5fDjv2O7L49WPwYpHa8JWvlP0JnVC3EagVTL
	uCCiU5AMfxnsOhpUsILzmipeYJfyMtg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCbfHbhj;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D544A4185A;
	Thu, 28 May 2026 11:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9901F000E9;
	Thu, 28 May 2026 11:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779966293;
	bh=1CtNhjUDYMnWJZV/Dh2r76Lj7h4Wsj50+rJVpRB4uMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YCbfHbhjlXZWCfKJpb2O3XC8LEjKZ6k7AbSaY2ch87NRacAc53wORdw1mKyoXIgTL
	 nHJCayohntixBeIdQyNTUJpDEZjs7f9dumba6qLLN2tG5FUt5xlsrJgvGcNSzEDxh7
	 +Eg9MhxtvjAWmve64F8Rd+VRQ6h4s/oZzvqlmII6656WaN9KHGu647gDmLcRkPpmc4
	 Y44VW/9OJnMgIy1Vfn2+qwKUOvdaBoA25LhoN+Tu+5hUcN7hBPNuQCV2Wb5vxTBe5r
	 5IC0/ksIxwXEwETTdi6Q2I08V4f1Q+m278bVLidsQOPbhIlAdioVG86tnMtrbCwfUA
	 gFkqKdWD02dUg==
Date: Thu, 28 May 2026 13:04:47 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Tal Zussman <tz2294@columbia.edu>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
Message-ID: <20260528-gepflanzt-losging-ballen-75e4489d9b9f@brauner>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
 <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D3DFC000A
X-Stat-Signature: 3sf587djj9os8dyho4ka9j54k6ryzz6d
X-Rspamd-Server: rspam06
X-HE-Tag: 1779966294-168196
X-HE-Meta: U2FsdGVkX19C8vz+VRagg3qvIsNqSVRl/R685ISK65CLEbqqCtWB4etdPVuCGVuVGtz4YLRmRuruQK9MiVLNOqj3YIKwcv7s1jiwRKbTbqpYiTxQzA2WXz3CXvwt182YcaWzYSJLqNT8R4EaPR0Dy2abQWtzj261YEKm4cgcj/A4V91DFJ2rjy9X9s1uLLNi6gHPNk62m7B6VuPq9upl5qAG5sbsZvopaf7bWYNWTQ6lz+NozOcK62XTYXKd2XN6Kt3wXIJN9mswbRasm2OmegZ0SroXrECQxNDHRZW8lnlMlm+Ha715KIMriMgEmlXxnennzyzdND3D2492uhiiuwJZ5KKL70OpCrOwDars8VBCIADlBMXjogfVjaSPdIi1B9sS5gjeIR8tmPidodCW1NB1nDjnwsL1wkR7UtM89gYbPz8BLXNLfr89tTrqW1Yw0h1jHe00leMPAiK57UIEw1aEk98S9SO7UQbKpwUb/pVW2I+aegH1svX8peN9FLzH4dtKE/y4BUOo/V8QEB9PG55LSZJsGm4Ux+iqBQRrMIZTJOS1QkWiQLTgQLBqvZH/D/Er2Z2AZAOirbM/73F4zSZ7fWqp2YAibJXLOHKZzNnRJNdwvwf0UDJQePbidMckXDMQVgrgbsQawB4W15tAyny8Yafad8W18DxJjSrlVIcv4tawaSHTz4RMl8FP90w0iReBfVqkbFj5Gv/DORplf60iY4ZqSFaLbwokeHA/Qnp5gYK9Hx0Dy+ItCpc8w9a1OiGdb0DjxQXu4hHlhgzu4w7naDP1jYyuNgmQ/HmATKX49eiq/rPeUJd0xWzJIoJISqcLkcdcgOzAo65xbFMoZca/dKAf60LM+ACJYRa+sfK6F8JN7Ny69t0KPyrvBGSaT8dYvdPhcKEWltjWYJoz1K3nwLQNFo51Td/d+Lj8tSbiKZYOabEqwyuwnnHMv9AwW9Tf7/5WRUlIrxLN2wW
 TxpCvTC1
 nFWzMaPDH4sLFcHF1Ut2K/FaGnxgRGdZTAGhh66BOQLj8DqiQhV7kYhElBbi1lTGzghmPto20WUPXqMGDCGdl3EO/H/b6EIPd3jZljzr7T9iHAf5+gcdLrKmjAupoCRiLuUCyDUsgBJhNFR/RAvtU+I/SI5nJxiP1PO6LGomVXwjqt3/mjkAQu/za/NdABh1X315uCo4z2ZkdXIKzER6OE3tp9H1aMeiIsr7Rp2DcK4wRlhardh7YnnhepYuu/CjXT+83P8Iu08Mr5htWSHlVXnl9h4VEDkOIluqgACT/uRGkQIM8DASDm14P83wsjbiZPHYliwzkF6bjjNwjttrqayJcnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 11:22:37AM +0200, Jan Kara wrote:
> On Wed 20-05-26 16:48:51, Tal Zussman wrote:
> > mm/filemap.c has accumulated additional infrastructure over the years
> > that is not directly related to the page cache. It is currently nearly
> > 5000 lines long. This series splits out the folio bit-lock and wait
> > queue code into separate files, and moves the VFS-level
> > generic_file_{read,write}_iter() family of files to fs/read_write.c, in
> > order to provide better separation of concerns. This also slims down
> > mm/filemap.c by ~1000 lines.
> > 
> > The folio wait infrastructure is centralized in mm/folio_wait.c and
> > include/linux/folio_wait.h, with functions moved from mm/filemap.c,
> > mm/page-writeback.c, and include/linux/pagemap.h. Afterwards, the code
> > is cleaned up a little, with functions and data types renamed to refer
> > to folios rather than pages.
> > 
> > generic_file_{read,write}_iter() implement the VFS-level read/write path
> > for filesystems, including support for direct I/O. These functions and
> > their helpers are moved to fs/read_write.c, along with other VFS-level
> > read/write functions. dir_pages() is also moved to include/linux/fs.h.
> > i_blocks_per_folio() is not moved from include/linux/pagemap.h, as it
> > requires folio_size(), which is not currently available in
> > include/linux/fs.h.
> > 
> > No functional change is intended.
> > 
> > Note: I have additional cleanups to mm/filemap.c ready to go, foremost
> > among them centralizing on the filemap_*() naming convention and making
> > the exposed page cache API clearer and more consistent, but I've split
> > these patches off from that in order to avoid sending these logically
> > separate patches to ~60 maintainers.
> 
> Overall this makes sense to me. In particular I agree it makes sense to
> move the file read/write helpers into fs. Regarding the page waiting bits

Seconded.

> it makes some sense to me as well although there it's more of "I don't
> really care" opinion so let's see what Matthew and others think...

Agreed.

