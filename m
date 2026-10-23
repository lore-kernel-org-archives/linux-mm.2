Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9479B606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 18:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mjELGUmC
Received: by kanga.kvack.org (Postfix)
	id B715D6B0BCD; Fri, 23 Oct 2026 14:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22F26B0BCE; Fri, 23 Oct 2026 14:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38C56B0BCF; Fri, 23 Oct 2026 14:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 810EB6B0BCD
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:24:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19E96160165
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:24:32 +0000 (UTC)
X-FDA: 85354716384.19.F87A316
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 49F9E4000A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:24:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mjELGUmC;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792779870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=no8c1akp7ulgV2WRnZedT63d3z/z/BLscoYXpWIfqEU=;
	b=lJPqEWSiK2bTrTGJi5vUQHfMCqX8l+vrcvVJqt3WEYNRqtQfRibOQ2iPaWl7lD+NLmcis1
	7PlD3Sio21cwRmWWWFQMBz2PubB4FVJw88ZkIMFjA3FzBcVUI6/nxNrTwYKLG/9UkQTptI
	HojS9eMQfrvJeSpTiSjVYnFe4ajge5w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mjELGUmC;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792779870;
	b=HD2/vFHS9AYfpQ483PXKqR2EsS6ccQpMx/kRT+tJQtrxtadOe0ZgqdtyR72klCdjGVIPs0
	PylkzDMaRmKjkojlk8/hkcZsDGa5JjbXhBSSI9VGobWglCeLN/dXNSa3J02j0JKUSFpCQF
	7wzuJULDOHNyOgRJ17b1cE/mrDUOwwk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 645B36022C;
	Fri, 23 Oct 2026 18:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E9B1F01828;
	Fri, 23 Oct 2026 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792779869;
	bh=no8c1akp7ulgV2WRnZedT63d3z/z/BLscoYXpWIfqEU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mjELGUmCidvCP5m5Pcw9owT1y+bk/0RqFxk+cTyF0zMqtdEYxzQjFUj6mz8yVLr08
	 /wdKz7PBXBIwaKMES+empFipHDE6CzTiguLZOfSO/UXz7v6d1yYcxXbWnom8DfNCZD
	 6wMg+JYi+R3DChrjRi3mJ99AI+t2dzu5mIpOZEns=
Date: Fri, 23 Oct 2026 11:24:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: linux-mm@kvack.org, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, usama.anjum@arm.com,
 avagin@gmail.com, mirq-linux@rere.qmqm.pl, arnd@arndb.de,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: return -ENOTTY for unknown pagemap
 ioctls
Message-Id: <20261023112428.c7a84bfb2d9005e5070da38d@linux-foundation.org>
In-Reply-To: <20261023181300.3366487-1-hengyul@cs.unc.edu>
References: <20261023181300.3366487-1-hengyul@cs.unc.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 49F9E4000A
X-Stat-Signature: uu8qjuniws3giokntmd84fh4uyjdgczh
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792779870-20026
X-HE-Meta: U2FsdGVkX1/tP+Z/2OHg/cbdjUGrKhKFYvlfDAYVs676hvjB+6o4QQ7Uo37oAiYwrM/fQWikhb/PIV5suDLDKpG+oisV2bc+E9hp2Og4IlY/TfKwZ2U841WdnYSRUs+7ltE6quMRa8RBfnrgahzjSaYtI5k7oR2/+dwLu9y5cqxkRLkCJkulV6se7xK43avdMV6rGy5nNYDPxJA1OeFghikFMNGmE81UqzpmK/KQvgi9dn+Um0RQ0btfTAijP7DShSP4QqexTKBOnUSZ5Uqco4vvMS+NXaZWT1E2RyVRmmuB2LZYNHBQPHGLnm/rmefIQDla+1rDQzMDXXLK/GuBaLyh3N7YCx2td4tgRn4Hlu2AGeF1XqvvlZav0ANFXiJ3lTflgqZXGCjBZeHU6aNaPZUcnvwddSwqxRcCjkyElnutNQpk6ekfT/OW8EvNc0TeTP1dmxZC5iM5kJ8GPbYLZUfcpHfqnimEhFIEnMW5iXAU3QVnMPgmm0fv+5cErynjKJw8R1q+W7H/79LjRbU9jdrp0bAl8L5gTuw/XIlET8iWKQeRbasGZBo3i2QHzhrceE/SohGg9iWcYVJFpZCLiGv8L26C082jdfV1aZA+SC1aSCFN+qi+tFWecorBX6TxhaII9o2oST5bxWGuXGd5P/n5BrHWHE1PhxlsKTRG82B0xEmPWsxRwkK5f0ndMIR/6zmhTg7Mv/2ywXXC73pYIAFOHIamYGdGmMqFGE4aQIDHdV3ZmeaoHtO4zyN8O2kJ6UpXrvWQFdzNWdSf2Zg7lSQ9UB3og/H/hKUYSTnjwazqOzFMfBWolwKy48gsr9vHh3SzRCSt8pUuwxzAspVX/zlCuuqQIRb1OKH96hAEhzNbc4bs1PWOf2p3UFbFqTj19lSrx8iR6WE6ywq4wv9V1/Z4EVr4eBIqQs620RWY7JZjpYZM3nyKbge4TV4UW2QRl/K7zbFG2zXGVN6rG/k
 HjB5z/mr
 Z+Dnc4ZWcS9vXYV2nujnKEcmGbhzVyNF5OfUeNrudGUGIVA0djWjH/T6t3tlXo+cZE2S+U6/JxCzzPynx+BXZJpNQQ4ZxC2t3fSIH+0xUyrnIoXkEp4fOJFh43aAsJbVcuWuQVIpUtFFAP7JvRd8W/eGoD3821P+NSPkRG4GpT3Z/yDcBz3FmgZZAzZMrvHccXo2ypWEURHwl7L69PyjZmk2Wp3GcTOdaH8gvmzTJL/v6LRfA+mKn6/1+u4mvVitJcS+mXNVSvXQxxvG1+/R3uOXD3UYPLu2+goAnER+2egbYcn1SaFCg/HNM86/J8B4Bz64FBcrb83dHtVeRXB0lEFY23496gwm7nf5O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 14:13:00 -0400 Hengyu Liang <hengyul@cs.unc.edu> wrote:

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

OK, thanks, annoying.

> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")

Three years ago.  So if anyone had to update their userspace code
because we altered this, they will now need to unupdate it.  It's hard
to believe that this will cause significant harm - perhaps there are
correctness test suites which will be surprised (again).

> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
> ---
> Unknown commands should fail with ENOTTY: Documentation/driver-api/
> ioctl.rst says so and calls -EINVAL wrong, and POSIX requires
> tcgetattr() to fail with ENOTTY on a file that is not a terminal.
> 
> I found no user space that relies on EINVAL here: Wine and the mm and
> kvm selftests only use PAGEMAP_SCAN on pagemap, whose results do not
> change, and CRIU and LTP only read the file.

Good info, thanks.



