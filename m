Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C45C531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 07:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5236B008C; Sun, 26 Jul 2026 03:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56006B0093; Sun, 26 Jul 2026 03:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B448F6B0095; Sun, 26 Jul 2026 03:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BEE76B008C
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 03:06:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11178C0431
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 07:06:10 +0000 (UTC)
X-FDA: 85030043700.22.B1F4884
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7A5C416000C
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 07:06:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CyAZqkbl;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785049568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2ah8cmNlpy4xwoC60wqOGaGixZA4ICSm3J4Wve3bYA=;
	b=TWuYd+cJ8jNDwEQ5JUictb5mDTddmsUjVSuPgyrXcyOe9V0FrtT6htPs7Yihf8pGkV95t5
	it0tmpr8UWS/K0qqdwJ8no1Z5GD0v0oBlhq5poRUOyUoDUwSRjmiCGG0lYdumA9jUmAWh+
	bhVsLn4w3ViuV96W33bgFgwR6dCIQUw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785049568;
	b=vqOkwtZDFq+SUGnWoZm9j/fI7iSIgV3aeZTOOGf7UFUVYwGoUxIV8SHCD7kYl2RAQtaotJ
	eJPfeJsgcS9ZQmNybTcJ2DOFloubHi2ETkhhXC4B1+dd4Ugpz3B/9TUp8vYAZbz+gAROXR
	JDmwsVMvoBasC5/xZNes4IRnKAiuzz8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CyAZqkbl;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E3EA6001D;
	Sun, 26 Jul 2026 07:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51011F000E9;
	Sun, 26 Jul 2026 07:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785049567;
	bh=J2ah8cmNlpy4xwoC60wqOGaGixZA4ICSm3J4Wve3bYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CyAZqkbljYhbZr71MaQjuPepcqDVoDuST4CfRm+DHbB6YuW3EBVGu215mwr6WSQco
	 OIzjVaes3+Zi3JZeDk64m0cbygsQ4AvA3A70APkPefhazaF471av+aM7+tOFPV+oPS
	 H8zHzQhXVOgtPXAWABbqS53sOmKKAQb7fnVBcxWvIn4+2Ajqtgh05pgbsOxhcLzd0S
	 Q2CNRYMcYKA3B9vP2ykm2OarbZ8S47AKPm3vY2qUAvxdX6u7AEhn6DPfijkxxkhwqw
	 p0fh+NJPokNV7ztPN3qFKcIsGzuZvg6+t/Po/mGCfI/sfUuvRuIFt2/W8c9063mHSv
	 SwI8liYCSRdWA==
Date: Sun, 26 Jul 2026 10:06:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>,
	Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lkdtm: use kmalloc() instead of __get_free_page
Message-ID: <amWx2QHfMHDeOuos@kernel.org>
References: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
 <20260723094522.535b284c@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723094522.535b284c@pumpkin>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7A5C416000C
X-Stat-Signature: kmufpey69w831ufoge3hs843s6o6o1jt
X-Rspam-User: 
X-HE-Tag: 1785049568-146679
X-HE-Meta: U2FsdGVkX19IulVevvoISzwLOgqoJXGgqKcRyqmHJ1cLgtWq4OGRDGyuDRi/l8I0NqHTX5q3Y7JiUhXaADOoojiQGyYKInp3t8M9RDwv+YFSYSfc3QiNYYFCVCNikBXKXTA9zYJ7W5kVElYYmpnFPmZJSyVo/Kb0P5HSeqsPl1M5RwFhnNGYdd7eKElDtRt1TeTpnfPxdRKg0A+FhjHMt6ZtkYXY/AELJX5fAm2nmYaP4aubSN9UeHKbuFEOWR+rwujcWbVxFKgmOz4r3eNVnF/hOOGeHeD0xel2hc6R6KFHOih6TmtwGuCyMWdCVA4l4oHStbbmD0GslKCCr0qb5sRCpd+T+CckdWeVanXqggS2Vfer/T+ToUwv8iqdumW7y8J6rIUNTXW5tHGuTh8Q5lcVPZxb+UzISTEZ8QAkXFfsLS85I7+/nIekWSYW5OBVLjrZI0zdFr1T3ma+TVqqYqrzRJInNkneRcYv30XyLVgD6R8G/eZNdRkwaGI6b0kxH4T96YoqnzW/yibn3IIpfrxkHCs7IQM1cnIEY5y523eabPywIKGv6ZW57r7pW0f8g6NxBUwiFot9h8FM8s62xqO4ImxO3/p2KcfiJGkOOGRXqGfc+cXPaKU4Es5PycKwSCb9+hPyzkB7M6joW9ffmlqpMX5VbkybZTOl84RsZAqJrfl3Spxg7b40d+BZWrwjc2qLyOe3TsFpw0VtI92t0U6lXam80amhyD15MWwV4Zj7met/1yCGInT64dMUWFLLWf2XpVY6oKl8mi8JJ2YtYmRj9p3FlrxtL5suW0tbAKgR9BJtTifYmEF0AwTUe5rUsjCslpSLAhWyVHZEme3cV2f2Vwz3LO+L1FntTSAfVlcyL+q8UbgVt9U8ZrWUDAVhHZEFQICX88q7pM0/GJ+CgBsmRZ16X9B0hQaEomk+7D0FumVbHHGdp08gPAxAtyVcOwREbNmkldQAZHKgLNc
 ZrLspOOP
 W7nZQ8/h9ssGcJcsUH02f8xdWKgmhld9c/bd4oGjpK+kwpEAHcWAazqTOGqh56XllJQiDUlih75nnAHld7M/Qrdwbm76vLDkBpNPXNRUnHIr3uOp4w8Uh5zExohPyEp0ZNBGWwG/X1dm3WgTT/y8wBgjTJcmhH3d27y/kon+FXXcOlSqsDA91SnzgaUM+yAAM92AdjCK5rZfSuQfZn7eV/NgV5oEOSz4qyI3vBpveKpD7T6nJtaD89A155Ii9zgBcVAOjAqyOVbEuxK/ylu76XXUJAXmodOTrowrzCYrKV5qkxs6jU0R58aEVLV3MmcYYNJpl2sJe1rSWwy9M+16sYxD/X2yaTSEPCwBKZfdrSGXE6+Ams6yxjPs/uYmTAHBp1YJ2tCpdODukeWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 09:45:22AM +0100, David Laight wrote:
> On Wed, 22 Jul 2026 23:02:46 +0000
> Mahad Ibrahim <mahad.ibrahim.dev@gmail.com> wrote:
> 
> > lkdtm_debugfs_entry and direct_entry use __get_free_page to allocate a
> > temporary buffer, perform copy_from_user to get the crashtype name,
> > strim() to strip whitespace and find_crashtype to find the corresponding
> > crashtype that is being requested.
> > 
> > The lkdtm_debugfs_read uses __get_free_page to allocate a temporary
> > buffer to store all the available crashtypes, and then copy it to
> > userspace.
> > 
> > The buffers that are allocated can be allocated with kmalloc as there is
> > nothing special that requires a struct page, or the page allocator.
> > 
> > kmalloc() additionally provides a better API that doesn't require ugly
> > casts which obfuscate the code and kfree does not need to know the size
> > of the freed object.
> > 
> > Replace use of __get_free_page() with kmalloc().
> 
> None of those buffers need to be PAGE_SIZE.
> Even the sanity limit for overlong requests could be 4k.
> The longest 'crashtype->name' is probably about 32 characters, so could
> probably go on stack.

As Arnd said, this is straightforward change, while changing actual
allocation size is more intrusive patch and you can send it if you think
it's worth the churn.
 
> And can't this code use the sysfs/kernfs wrappers?
> 
> 	David

-- 
Sincerely yours,
Mike.

