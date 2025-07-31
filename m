Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD3CC87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 21:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906536B0088; Thu, 31 Jul 2025 17:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8166B0089; Thu, 31 Jul 2025 17:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD126B008A; Thu, 31 Jul 2025 17:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6665C6B0088
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:27:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD18813546B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 21:27:14 +0000 (UTC)
X-FDA: 83725845588.05.3253104
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf24.hostedemail.com (Postfix) with ESMTP id D1FF718000C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 21:27:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=ik2cyJWK;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf24.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753997233; a=rsa-sha256;
	cv=none;
	b=su9yH2wM3bsYIJIYLHCO5ij9LQZ8XPlBhAoOdYhO32a+9+VvVaWhr/f8U7itiQK+nmPG9l
	5+eKBTUnzg9/jXLCOL3eVZphnf1KvHpPURqcz4xNsObeZqX6vegBZEpIp0TnChD0kfc7VR
	EYD39OlzRbbeURd0lfFG8LVD9bc2u2k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=ik2cyJWK;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf24.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753997233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nkHd1b/2MRDkjnRLov6dxOfEPt7nfNIj5VrbrXjH2k=;
	b=34oOJ1xURypdf7i0SZP19MRrrZNLHSZ4Iv2KTjq5Lq3zVy5fYNYNEH3pe5xQ0pyH6PnhVc
	dCqhEAuABstq47ZXcS09oQDAV7ecnlVJAHxF4mbTppDfAoO+/wGjlAY7Y3Olz5V6qEPVX9
	Vyfggvet6RHX2bv/abQsA5LJ6/RoQZI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1753997227;
	bh=wjDa7WOGxyHO7D5dQF8LxTZo+LlEelFi+YPWHmw+YgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ik2cyJWK4ofmcUVOZKooHAK3Hx+C25v+XJtLc51IX7lfPrqYTCULgZpCSxZOCRZ+Z
	 4qpZXXY221LjjYd8Myeu0O6KZq89Sy5J8mJcddZ60oIFZyThxRsOTaWB/kJtr07dah
	 s0kPO0xeFpx9zl9QEHujyrWH709KZOouJ95i10lc=
Date: Thu, 31 Jul 2025 23:27:07 +0200
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kho: add test for kexec handover
Message-ID: <c54e6f3f-64b9-408e-9668-e96664f52f27@t-8ch.de>
References: <20250727083733.2590139-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250727083733.2590139-1-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1FF718000C
X-Stat-Signature: btons6seu3sijxr1ar6rgmubsi1d6xcr
X-HE-Tag: 1753997232-428916
X-HE-Meta: U2FsdGVkX18MPFWMxKHQxb5ussjwEl82wkMk5JAol9CVL2NkhwqnRqjXOZOgk45PlFXUQu9LlV7JABxDtcOy15bVJysb7UbiyzdjV34IuqoigBNPcGdLb9sfUFTlHpqkDg/93PWxSr/IWFfVMFBT0utOWOKU8Jpsz0t8LwC/Vp3IeQYLOZBXN3x7aObyabIoD65HZ6o96DY1fEo6DASftHcuooWcNqYs0YYowwmDZbmFfQRYxTJLbXv9OUa2PDMjmGChr5w5Z/nmlffkM9KMV3kdCpg02S86DM5EQwGBOL5DRSbjw8LR7wO4k9/4elvVCW5G7bCAxhWuLwQgDlQ4rYS6dkvBxSNiGNIWGR6w3ypP2osV7IvmEolW7vOuEczdDZ+vwLlgBhWmivzRQJWXsC1pAJWHxwOnt4ag0z3VkpZBI53ktt6csHceNGWxEkhhuZzGOo04MFsKB4Xp7+Opk/qLUeRMcKZcFwOHMNhzD2IbKYbveNkse1iYGoP7MaeSq9w3fMQ5JaZ7DGoJVkPCbJFmNym5CwQ2gnwooLTkuEQbl42ELXsfAdTjoDk5zYPzgr9Ojs5Zbn6/sPZZk044cXLaE0tVklLcLx/0DdJpwDRnS5lAbVZ+feL2k6IJzpM+kUrfJ/XqM38rj/LIOzFgI257M5U5MkV2AW293KTz3MmHBZAMpV2ntPBDsNo2v40WmCYRXZzLbn2HsQYYwGp+ADU2ADGQMIDxZhEOBnV0rn13qJ8QnsVaSaV0HYYBA2T8AAyZwJ8tpa0Ih+hFvuJc+ZjfGq6QJ0++fB6SdHqD3S+HR1uar+E+J/RXH4SkPjtxDQJyoshNskOwYCA6Ne4xVRWgRrrgRUjcB4ZQMPzk6oRpi4lVoBoaC/9AIRWv4hIfvvsgaXRBJwktdXGv303qADyr0qa6WFdMyMYbXpP5ze/i0iRCtJXlX9ZyDV93Rg4PyiBb3f57WC1z7Nqa7nF
 PSri9D9S
 KdlhGY1pbowCM7xRaDEEUEKd9vpp7jN5KfUb4lYlcxmh6GSUWNJicLd+rtpeJ0NESUHPqhuFs88vSRE+7pa8E+6a3We+sNC3kZikis1Et4DeZ6fTsTcupE1WyCvjTYXXuaMxyjHJx5gpk+cFGlCVLNzX4AWS9xA7ubdEe60q75JO7khZV1oN8ERxExcc1kzpOm12NKHNeKRKFUxmalA7vh5quFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On 2025-07-27 11:37:33+0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Testing kexec handover requires a kernel driver that will generate some
> data and preserve it with KHO on the first boot and then restore that
> data and verify it was preserved properly after kexec.
> 
> To facilitate such test, along with the kernel driver responsible for
> data generation, preservation and restoration add a script that runs a
> kernel in a VM with a minimal /init. The /init enables KHO, loads a
> kernel image for kexec and runs kexec reboot. After the boot of the
> kexeced kernel, the driver verifies that the data was properly
> preserved.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

(...)

> --- /dev/null
> +++ b/tools/testing/selftests/kho/init.c
> @@ -0,0 +1,100 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#ifndef NOLIBC

This is not necessary anymore, nolibc now provides these headers.
You can keep it if you want, though.

> +#include <errno.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <syscall.h>

This should be <sys/syscall.h>.

> +#include <sys/mount.h>
> +#include <sys/reboot.h>
> +#endif
> +

(...)

> --- /dev/null
> +++ b/tools/testing/selftests/kho/vmtest.sh
> @@ -0,0 +1,183 @@

(...)

> +
> +function mkinitrd() {
> +	local kernel=$1
> +
> +	mkdir -p "$initrd_dir"/{dev,debugfs,proc}
> +	sudo mknod "$initrd_dir/dev/console" c 5 1

You could generate the initrd with usr/gen_init_cpio or
usr/gen_initramfs.sh which would remove the need to use sudo.
Especially as I think the mknod should fail if $TMP is mounted 'nodev'.

> +
> +	"$CROSS_COMPILE"gcc -s -static -Os -nostdinc -I"$headers_dir/include" \
> +			-fno-asynchronous-unwind-tables -fno-ident -nostdlib \
> +			-include "$test_dir/../../../include/nolibc/nolibc.h" \

If you drop the #ifdef NOLIBC, use '-I "$test_dir/../../../include/nolibc/'
here instead. Or better, $kernel_dir/tools/include/nolibc/.

> +			-o "$initrd_dir/init" "$test_dir/init.c" \
> +
> +	cp "$kernel" "$initrd_dir/kernel"
> +
> +	pushd "$initrd_dir" &>/dev/null
> +	find . | cpio -H newc --create > "$initrd" 2>/dev/null
> +	popd &>/dev/null
> +}

(...)


Thomas

