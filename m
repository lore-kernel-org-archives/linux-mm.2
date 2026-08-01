Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53CFDC55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 19:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D24A6B007B; Sat,  1 Aug 2026 15:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482366B0088; Sat,  1 Aug 2026 15:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 397B96B008A; Sat,  1 Aug 2026 15:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F1806B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 15:06:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9316FC0322
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 19:06:14 +0000 (UTC)
X-FDA: 85053631068.27.C5CFFB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E3D75C0006
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 19:06:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KcR4Ag30;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785611173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jRl03g1jUXCa0izU8Qj8LdKNePNcVRPBMQzxL9uDZY=;
	b=nWlnWLvEVaO3VuJOKBvyqkadF+G3MpKjqjg1hC39ffcVfgol1kgC9z9lc36a3P+IgzJL+A
	lBf9HB6A+TbZGYrqtykc1J1Wr4imbJh7QPTtf8MCObbMMiR1yPYMpRRdoBecEIeZb9q+VS
	hzWv+s8FB4nB5k08QqiFl5vcZgwCYHU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KcR4Ag30;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785611173;
	b=TFQ71a3jhBzU8eSCgFa025qAOFeBZmXPSaxLLYU7CAn7XxKFB0+te364ZzZ+iQRIFuOWJ8
	EWUhPFSgMNpPIQvv011snKwGm0u1Z0Koqr+5Jrqoo9CcenWKnLJXGCWvxnjDG9jmFyz9W9
	BsrH+adH8GtYneTeiCVnHb2nnqKiWP0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD6FB600BB;
	Sat,  1 Aug 2026 19:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5921F00AC4;
	Sat,  1 Aug 2026 19:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785611171;
	bh=/jRl03g1jUXCa0izU8Qj8LdKNePNcVRPBMQzxL9uDZY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KcR4Ag30xihbWbkaxsf0xcyba3xjWFnNP9Weyb5yFkv2wbNyKZTmaiFuqT1hEXRuY
	 KCxABNWSCVmJGUNPlaIKSO7QeCnKoii7ICpYJAw3JS7JNhLGyI9rIgrOoySkFByWIh
	 6SJX+OmNTkHfuyvc30/9yDs4oANeZVzNmfhhCP2Q=
Date: Sat, 1 Aug 2026 12:06:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: alex@alexrp.com
Cc: linux-mm@kvack.org, Andreas Larsson <andreas@gaisler.com>,
 sparclinux@vger.kernel.org
Subject: Re: [Bug 221820] New: sparc64 mmap() returns EINVAL for
 non-MAP_FIXED hint within VA_EXCLUDE_START...END
Message-Id: <20260801120610.10908474cd8e554947a64417@linux-foundation.org>
In-Reply-To: <bug-221820-27@https.bugzilla.kernel.org/>
References: <bug-221820-27@https.bugzilla.kernel.org/>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E3D75C0006
X-Rspam-User: 
X-Stat-Signature: a5m3ngxtgp8cprupi6ura9ank8tyyohd
X-Rspamd-Server: rspam04
X-HE-Tag: 1785611172-917339
X-HE-Meta: U2FsdGVkX19nenGylx4fH5rA8C7jLPgLfLub4+CrbNCQR1PTd+2RZVeJz/bNtmMenz6VbsHr7tHR1BqV7farDwyhdkzBl9t6mExWAOpBQ19joATLjKV3P4i1SSEJ6qGNu+FWIsuKuJGQLI+0UNW+nbn+odA38h1dZ3IRH3l4RXf9kwt8z1Dx7QFAURT/l+yr7Bupcr9Vdggn3paxGfcIp0Teo8zM8a+q2JDLlqAH6GSmM6oZotcBDBOkUWx4p5rBPUYJX4KXPYH8D3Kh2lsVwCSJ7Cpj07ssO6rmrh8CJ3E77jnsExMCgaDNEaxfQFaC4UEcPg8O2Qkf8oSEcoQpmVrWVXArics5IT8uFrM/5/B6J6Xglk9XKwnO52FpUva9nq5YS5V69uNKwfnclgHgPe3VyVq4MpU1TuBTu4NNkvN9yqzF+mVEtQwqzOI4f3wQW1zKBj78iIKXKy1DwxxFg/d0Iz9cq/WVM7YBSalUIYD/1xhlaKcH9EIuXRsI1QTEjKykpQHSzPV2sSShY4twOn9d9M2uaaYRDHZrc7uy8tdlaj14Y3IEoKnXeuwsRroKo7RGnVVEecPPIqd0bmrAzAJXGXsf/ud8oDiZC6iE2KCc21XE2GpEhdNA/QWBkYHEy6MCE053JYufAQX3JKtmlIJuArhHtYJrNxtWPh0kHJ5YjsHQsPsfw3pAY6u/ETiP/hhBWyECoK3FB0Dsy3Rf6Dmc3N94GPyJ0bQqwSemNjjaiMFY5sdWu1XQATVktkuiampeiiZPJdq4P0vjDkpwVJJL4+zcMk3NmX6kM3Q6MsNVHxfUwTcNAXkzblLG/WwuY+QnGROjFecKqz++itW7v3V82CXwEltUxi/PbgxqKoCQ55ScHR4EwyvbGxb0UjoZhOuydoQ1CCC8ERln9tPyw6YOo/1V9ET8CySwrGKUsi8q39sjcozqGEZfkN9OwjEpXcGgFFsKHXUV5zdgUc9
 4behv2d2
 U63Pfd4l2toMTx++zLOqAkZCiPU1H24RpiapB8hQ/cJcFHtgmGP7stephdW+IDczfttufWwZyVmFKvob8W9tI/IWXItMRvz9B2OYO4HFzOOBzZkAyPcrOyIRF5yH7Z7ITO1iiUYnQDBrLlF5wzvIsxelH/WQ2nb2i59HmdHpFHkPo8gyyCXnqSeMSHTR6Hqsb1LXAEC+iPNjz2Krf0xc2/GjcyoH7hMMJV5WdymHBPjOu6JZQgqe/1FOEgBdOp1L3PYvIRrJ2JLOZnYIZ5O4oXKgDU+O5RcLS5X6lD7oK0FspCRt3aQM6MufQ7bj74zMkuJCTPc0WYXYtsj50rFYUsI5LrAIUEpup9mNKQ0+8uV+oczWPxhZNl3yVkQNwvCxLbbf1KmDVI19IJ7kIpFNzerkFNI1anf+L8o6z3VJM9pJGRog6CTCtFE9riw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).


On Sat, 01 Aug 2026 09:41:47 +0000 bugzilla-daemon@kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=221820
> 
>             Bug ID: 221820
>            Summary: sparc64 mmap() returns EINVAL for non-MAP_FIXED hint
>                     within VA_EXCLUDE_START...END
>            Product: Memory Management
>            Version: 2.5
>           Hardware: Sparc64
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: Other
>           Assignee: akpm@linux-foundation.org
>           Reporter: alex@alexrp.com
>         Regression: No
> 
> Repro:
> 
>     alexrp@niagara:~$ uname -a
>     Linux niagara 7.1.3.1-sparc64-smp #1 SMP Debian 7.1.3-1+sunvdc (2026-07-12)
> sparc64 GNU/Linux
>     alexrp@niagara:~$ cat bug.c
>     #include <errno.h>
>     #include <stdio.h>
>     #include <string.h>
>     #include <sys/mman.h>
>     #include <unistd.h>
>     int main() {
>         long pgsz = sysconf(_SC_PAGE_SIZE);
>         void *addr = mmap((void *)0xfff80000fffc6000, pgsz, PROT_READ |
> PROT_WRITE, \
>           MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>         printf("%p (%s)\n", addr, strerror(errno));
>     }
>     alexrp@niagara:~$ cc bug.c
>     alexrp@niagara:~$ ./a.out
>     0xffffffffffffffff (Invalid argument)
> 
> I find this fairly surprising. I could understand if I had specified MAP_FIXED
> because in that case the kernel is unable to satisfy the requirements I've
> specified. But without MAP_FIXED, 0xfff80000fffc6000 is merely a hint and
> should be ignored if it falls within a VA range that the kernel considers
> off-limits.

Thanks.

That does seem wrong.  It works for me on x86_64 so yes, it does appear
to be a sparc thing.

The test code does have a few glitches which I don't think matter here, but below
is chatgpt's fixed-up version.  Could someone in sparcland please take a quick
look?

#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

int main(void)
{
    long pgsz = sysconf(_SC_PAGE_SIZE);

    void *addr = mmap((void *)0xfff80000fffc6000,
                      pgsz,
                      PROT_READ | PROT_WRITE,
                      MAP_PRIVATE | MAP_ANONYMOUS,
                      -1,
                      0);

    if (addr == MAP_FAILED) {
        fprintf(stderr, "mmap failed: %s\n", strerror(errno));
        return 1;
    }

    printf("mapped at %p\n", addr);

    munmap(addr, pgsz);
    return 0;
}

