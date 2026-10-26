Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24790606A324
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FjBhwON2
Received: by kanga.kvack.org (Postfix)
	id 2A3D46B05B0; Mon, 26 Oct 2026 09:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27BFB6B05B3; Mon, 26 Oct 2026 09:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9096B05B8; Mon, 26 Oct 2026 09:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0030F6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:53:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87DDCA07D4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:53:31 +0000 (UTC)
X-FDA: 85364919822.22.2D8255C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id ECA80C000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:53:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FjBhwON2;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793022809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2VNtcJdRiVE5wcehkgvy8TAiipkC3W4OhSqQ91G0hU8=;
	b=LIuz9hZWga9GkI/cke650PJK30Ah6dmzaoR6IbSpFheB5LEPi7PtM44D9J3fjZKyNN4eRS
	GvPQ3bDvuwdvYmB232p+yU/6uxqGwLjO5DbZ0kbQzEWKa3Jvu0uHAm1Sgp8HqwzOvPz32o
	GKn9mn5qZ4lhzI37eXmqFgGj7GzG3ws=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FjBhwON2;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793022809;
	b=oDKRpOGfpWqEH74nMdTEbZO6FfFsUEDvIfXDgdYRpaGk3p2WPVqE9+9ohSpDroYDxkHtF8
	CO4zPxyu9fnfaJzjWv0J9euedk/Qt6AISsPpldapY0WZ5WyfN6llsNVNoNkOZIVtDiiTPN
	tbdP6NFt/SpO0G4/QNqeQAkv5VK4ASc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7856B6021D;
	Mon, 26 Oct 2026 13:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73641F01825;
	Mon, 26 Oct 2026 13:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793022809;
	bh=2VNtcJdRiVE5wcehkgvy8TAiipkC3W4OhSqQ91G0hU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FjBhwON2lGqcDeAsQsur5YQJpwijTGL4gNxeB5JDtzunt2ZZduk4xjYTAo4go/lcZ
	 2Ve+e21JhrcXXcs9OOlnbwi4MzsFVfRdSI1sHTUueXGDCH21vG3mBKNGGZpOdr7YlY
	 cUViZLTP8txseKSOJ0MNjl+SB3FDOhv3ilrjaaXLxzb5OtnypOzQI+/hseFVUmFuvx
	 biJmLnh3FuzD56tP9s1isiBSqoSCE9HED5vpgGDUK1LVc4GQj6oxVJ7kV8SfEJxucz
	 GdAirjMlWMjzqoqiTgccW04NJAFGnOvGT/IILN4tjOafVrcHPqZHTHDWVgJyVSxIlT
	 KbIcgx6+lz/Rw==
Date: Mon, 26 Oct 2026 13:53:23 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, liam@infradead.org, 
	vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, usama.anjum@arm.com, 
	avagin@gmail.com, mirq-linux@rere.qmqm.pl, arnd@arndb.de, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: return -ENOTTY for unknown pagemap
 ioctls
Message-ID: <at9YUh99R8Ib7Lr9@gremlin>
References: <20261023181300.3366487-1-hengyul@cs.unc.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023181300.3366487-1-hengyul@cs.unc.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECA80C000B
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5g9ojsdgrn97dhf1t6um95q6hi9fmuuy
X-HE-Tag: 1793022809-763420
X-HE-Meta: U2FsdGVkX1+4FyhPbabHMep4eCbbSysPJVUhAuDqEwHM41rWXlBYUcTzfwTg99YuBrz/wA7s7RQALMzoK9fZkjbA53oBiUPYXZDA2reouX+G32EyMOMCK19zQev/pUiobyB1KkRz8KIpRedxDGynnDO4OEymUJvzJTOAqo4BKOGYpafLNgNPLW1y8BnubVQdBZ7J29N24pqyOTBFuM48S7CAiqx5su4pkwSKnwIusgSP8UtNa7p9V/qa8IMQD8UqKvOmO16/iaZZws+Iy9YWXXaoZnqPb0mTm4n9i9M9k/WlA139rIXY9Xs+1uNGAUYVP8OsqAnMwZKQx3uSgpWYp6I0xoLi0/upCBellbYgFsuJq62BDZvm/n2p5zDIJTB3qr3LNuAv8aFj2ymeqwSnIr3e58X+m1yRkAR3UUnPwh4ksQevjKHWLiifrELxfD44L5sRjBp5N1049y659uxOhOd0AnOH6Xwql30kt3hZKXhdqBdxuRfu3G76B4AjZYNqiSWuYd60nmrjy1TZbcLPCsAQajP+ZzlQgvxqgDxnzH4OdRrSz4LPGxdQRWfDwgw0YvFaWS7jy9cKMSZ76dpnABc/5+3P4FRxgGP1WuAWdMOnFy7R8qHZM65Usapt4z489NX8Q/6hLlqMBhaoNn6HLviTG1Zy8XzWDhHyuMkyY8cncqao7bXEIXuvgsxu7KgbT8BVbd0aoi0Hr3Eoe6V/LjHfEKms3UunlpYvw78bP6kRfk/7oFgae4CBCzRymxuoj2UOplDWsUwftdOXWr3tA0drgoctjJUukORywGAcEIYgxiP7T/wLuW0BXKzy3yvS0uTG+gs4/lBVLWgdZwVNSaH0jBrRCrhRiS2dbyb/3aCEBZqU27VTaWznEqLeAn+XspKX757enOz4oGh9Sgll2DOeEkdiuOOEgJMuAe/eBpgw3d/zyAYnD9cgGxU6nMmOlJcGStyX4RcQmUPPDy4
 9FP+Xp77
 hnI5VfM97t+OUKtM/OmFBOfG12iNK33Y7whyxGV1vTPeMiuILaL/dCN0Xvky9QLxDft/XbZ0efYs6raHpFyAyZ9HZqHqZ7znQIZelNCGYDGPwmmKLsZ80vgIXDZXhxB+kJmgwzoa3z4V9mnJSEuezCLvKk7B9FCY9qc+Cw3/dpkIZ+55QuwtZBfywh5vNjo4SBDZQZdd6MmSMTXlw08+92G2soGqUxQX70RsiV8qv7TKzHLeUGfoWabkqwRiA23yM5WKx++sdfz+r2KTXTlbeOUOe64H2PWZvoe5A06kLyL9NXNAmndceiuT8sqG/yIzWOghc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 02:13:00PM -0400, Hengyu Liang wrote:
> Commit 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and
> optionally clear info about PTEs") made do_pagemap_cmd() the ioctl
> handler of /proc/<pid>/pagemap.
>
> However, do_pagemap_cmd() returns -EINVAL for every command other than
> PAGEMAP_SCAN. Before that commit, pagemap had no ioctl handler, and
> the VFS returned -ENOTTY for these commands. As of now, they fail with
> EINVAL, so tcgetattr() and isatty() on pagemap report EINVAL instead
> of ENOTTY.
>
> The issue can be reproduced with a simple C program:
>
>     #include <fcntl.h>
>     #include <stdio.h>
>     #include <termios.h>
>
>     int main(void)
>     {
>             struct termios t;
>             int fd = open("/proc/self/pagemap", O_RDONLY);
>
>             if (tcgetattr(fd, &t) < 0)
>                     perror("tcgetattr");
>             return 0;
>     }
>
> Before that commit, the result is:
>
>     tcgetattr: Inappropriate ioctl for device
>
> After that commit, the result is:
>
>     tcgetattr: Invalid argument
>
> This patch will return -ENOIOCTLCMD for unknown commands, as
> procfs_procmap_ioctl() in the same file does, so that the VFS turns it
> into -ENOTTY.
>
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>

Seems reasonable, though I doubt any sane user is relying on this.

Confirmed the conversion from -ENOIOCTLCMD (first time I saw that :) to -ENOTTY also.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo

