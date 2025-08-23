Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F429CA0EFC
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 03:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6F98E0023; Fri, 22 Aug 2025 23:31:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF0D8E0018; Fri, 22 Aug 2025 23:31:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E058E0023; Fri, 22 Aug 2025 23:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E3A228E0018
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 23:31:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8DEC2160446
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 03:31:01 +0000 (UTC)
X-FDA: 83806595922.14.E399D6F
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id BBA2B40003
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 03:30:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YJ2qYSTt;
	spf=pass (imf07.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755919859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=D2PoBOZMCYl8EkuZw0KQkOT5J11R7R6GRcyZnZYHv98=;
	b=umqnzpOqPfojgJNkiZXxa4zoCEcF6NxQqYC7fAmjX1QEL9EN0f5wdDaSh3el9t/0U9eeh7
	We2XPcqDI6us/Dcm6ssMhnNvedMXc1Mu71TmNi3NbuCAPqRaCjhPk2FW3lyxZuURsyqCqh
	ZSm+U9kcQXNKokVGh7b7yQahnhARSL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755919859; a=rsa-sha256;
	cv=none;
	b=68Df3daZMvqscUcchDuEpBwnePtuan2+91nhWUvHa+dAn635rv2bLlF8CbjlFSMqbSw+EQ
	cOE6o7KmHXf3w/9bfMgKb8LCqRkPqRETF+k4WegICFJW6oSbYOY8voujpuWhepMK4QWjbn
	87XuhUx+n6mdWUU61m7/X4DQZpjmN18=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YJ2qYSTt;
	spf=pass (imf07.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-324eb9cc40aso2050575a91.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 20:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755919858; x=1756524658; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D2PoBOZMCYl8EkuZw0KQkOT5J11R7R6GRcyZnZYHv98=;
        b=YJ2qYSTtGFrnNGFbmsUzzged57CH7VEFxN8uxsGWT2Mafeobr8AgVCXeKPv4phB1PJ
         22UV6Qt/4t5ofJ9iyLflj93dikwrKzwkYdPOX3Ezac3z1/3ulQf/jQZU+dhL7MNlfwpk
         vdgi6TPS8z3IXuyeKSfoX8QYljTxzVHly2BGO7MtPJhiNmHOUgsMyd145U9yLDmObFCy
         lcrvJTwSVAeTijPHRuWU2W6oUExwUggbsOdC55w3RrKu68ptEOeqTXaBJqtnYCJnbWsA
         JPPIhm6u12pb2daluKyXnpCkMZW/TSKm8Fb6px4lOPJ9/K3WbigoUcWKbaAtLjaItOmc
         24Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755919858; x=1756524658;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D2PoBOZMCYl8EkuZw0KQkOT5J11R7R6GRcyZnZYHv98=;
        b=aZWFvVMuj+MoNg1o2nqqC5C55ydzdTE4EPvEFYZz+px5vtnQooY8nbkrn49amc4VXs
         lPfFg7i4FtYAv9SU3q/BXDJEagfkRvu/Bf+CubgpXZpHsZIrQjkSn3x5cN/mxKZYIQa1
         cJ9DZBaYMcPYqe+oUVSzHkoeWtTH0yhCUX9ALL1/r6m/boTHsJPDcXsLeC69TCZ7wOJ5
         Hs+p7zU+WtwnpMaGPYx/TqAvkGo+S3VLb5HewoNE8zqffXga13Nr9OXkCARrpQsTrC2A
         RWhChSiHdAfzoh9V8MvgsKwj0VaC4FN9Z12YehNJk9rL6LIjOHFsgMRGMy7C9gJo4eui
         6lPA==
X-Forwarded-Encrypted: i=1; AJvYcCU/u2XockTuwYRY8ND575dE2BDEAzySTtO9vjLKvmW5G7PP1FPQSn8yTCAeY88pccDp7x7hvX6SYg==@kvack.org
X-Gm-Message-State: AOJu0Yy9J/J/hoCew9fs2n+uXnOkQUbOMPgLNsROYqWsA9J/vCI1SpBf
	68V08pjlgM9eJOAHDMlpj+S7FLAXm6dhaFsXDR7Od1cwMhNbo7RBETiw
X-Gm-Gg: ASbGncs8/p527W2Uchuwi7PpCsJW/d83N8Q2AlTkGh+zK5X3bTetkx90JljdgGa0r8l
	L++rpjbdgEiHqSZcnM3dwrvtJNpqE5P99J4072dgqFAQPwcNddyrN03VKeglflPpnmIKey/5nzp
	J1oDwFvaI3a/QDCtK6F2DUM9R0HG66HD8yRPUoJJPiYpxfamE9adekLGD3Dty0+q4wuhHCa18UD
	yZlL8I66mYBUlEh7rCN3idUPpgwD5imfHtbFPFwaBKxKT6aM01ur5mcsMjo63euduMNU4OhWyRH
	v3gi4TLPLPd84WdcVASnvVOx1r7PtZkPgnhWpvVFrEtBQhK7jrjS0TerazCL/NTWe1ZlTEaF7mG
	ywr6Wa1Tk/dlZMw==
X-Google-Smtp-Source: AGHT+IFmj7aQFwvEpvF0QoxrLVJzRODk9vf1gxSaWNQf3S/lCJxMZH19RSe9Ih133SJS671Y8wg+rQ==
X-Received: by 2002:a17:903:3d0c:b0:234:8a4a:ad89 with SMTP id d9443c01a7336-2463292ce7cmr60060995ad.1.1755919858315;
        Fri, 22 Aug 2025 20:30:58 -0700 (PDT)
Received: from dw-tp ([171.76.85.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24668879763sm10092605ad.108.2025.08.22.20.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 20:30:57 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, syzbot <syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, pasha.tatashin@soleen.com, syzkaller-bugs@googlegroups.com, Andrew
 Donnellan <ajd@linux.ibm.com>
Subject: Re: [syzbot] [mm?] kernel BUG in page_table_check_set
In-Reply-To: <20250822181653.cd2024360870ef94cdb7db07@linux-foundation.org>
Date: Sat, 23 Aug 2025 08:53:28 +0530
Message-ID: <875xeeafgv.fsf@gmail.com>
References: <68a7ef20.050a0220.37038e.004d.GAE@google.com> <20250822181653.cd2024360870ef94cdb7db07@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BBA2B40003
X-Stat-Signature: ut1zysb958he48hktoqg1jcefyob45iu
X-HE-Tag: 1755919859-793240
X-HE-Meta: U2FsdGVkX1/qVYjLRp0UJjCdt8P7z+fi4t1ue6SiVVAXktKWZL8cGb7FKtZQJL214skx3IDUo1r5f4JQYbGM0fyNhw0mIQjFodMaHOF6rZSQvNMey2wMHf2WEd7wykQ4VNtaagp9/cxO2+sbzURfIKqBZ0pT5X7k3u3W2NBXZv8y/aYKWpRgCnnHbSD7W7hmo8vu0kzgmcxlsPd2HzzgMg30V5G/J1E8bhdtAXuTCVkuUB55VPYFY4DwJpQaw/zP3LeV44Z5vXW0tMyvgYzpTF0G2KS1JQeO7hq2vzVf4SKboEHdw0ZhLW7Q9pXL6cs+0F2fauIShghtorQiYipTQ15l8YXcRXbbknMEfVHtnARx9KIf2Y4oJvacM587I1eBExPEP472n+d4Lmtf+guZRzEkWQTWYdLkwnPtjaXanxqBw8C/Af28MyH7OCSZ78qaP7qFmOy1W5BBXM8ogXQp2tMn7JC3u85wzWsZpvfM74+Z53suu4AeBWXxPWNuwq94aXl8pRB7fRGuzs1dcStK086aVKX0QV2X2PqNk9mjF8/MJEg/XmB/0gUjfrga2AEChu5P1x8IrxsWYHUuhi+KOrrFgxIOBhkSEOUHsJo4dostmwa4WHyQ6nEXbOaiPdJOHcJACLMf84oNFVF6gzo9fI6hhRmycNLorevK8fo4+o9aT57hnpiPDtJIWJv8Y7EQH42xMWrL9wCsukIdrhRu27KG8IZoRJ72uHksDzYhL9PPwGuN19JYi7rAoHNqNebghUUe1q/e44NnCZyyC+wGeWh+lc8C3mLTFHB7UmcSfcAboMFmPDhBEedmsplXNHLUA88joCaosbWvXSpAd3sSDU3nbsDORdas3E5dlSx0dWYaE1toGSz/G8KTNICyyoEXLriXzhDKQP3fU53bT9lDR02mKVrMJYujktzsD6N/tDoRC+W6zANElfGNZLiwf9ArTv6kN3Gn5s+vxv2vSaC
 C/WR0rJ1
 aqc8YZZfLFxZyYnGm63D+PeSBJElYgCQ4Sv+KlzpRHeHam01CevrzH3/0RKvdkJQ9vyaamx9DHDoe5ajWyYtaNk5QVXqjSH/97Qk+Eps0T+wMgqxX+7sSacgzfqRZuhuS5VjSdMeK5CaHHsuULLGGgwPiRkajjBhp6mQGQx/89Eh8ZGTlBviwbS2s+dpWs1RWTMULhLop2J2RcVtEI5rpEujmROPzHblc6QB+MmPCmXik5QdbW7epOazNFCvxltk3HTLZ6pHIDH+6q0oMS/eTaU8lWWG2fFG+GfAP3xhHbtq5IHp/eve2wnbYRkruLpa7Gvd0D1c0zrCOt2mf45XA+Zyd9PB4U+cgV/WbZTko/O1HIk0afM51PMMfMc7LIPV03WFVnjLHEEe/wyYbpB4/SYYUBrerIJLd/44iT79j1I8sJxjvY6pGi5+hgL9ay51qPwHJltIjMvojqwrRAcVF4WIEXAWW2UA/hQZZwZJTgKoeqQARpam0YfpCFaM5aaPLhfoibgbNc4BFaNVS5UrDu2nx524BU/GawbDC5V3I1LmWdws/pJSgMixdRShdmMvIYl8Vw1jw2AA9UmNrrpHlTi3SVCoPjtql9jTbZpaoMDTzyMuzODPucnl1G5rZ+M9bprKIiurSiVn2O1RA5mEQstjqnIq6Gwrj5DqQTp+69ymBMMIdeXgCOzwNwOiy3pZ2mCbPw5XBrcunSBXKnIxxZtY7y/wAKnMClwiYGxCyvFNHVV3NxT+b5AoopfH2NnfDv6B6iiXRjBPrImqxejRqvuGgvwJWqU2t6PAwongwzLorJVxJPzg2C/V2YKW4xhZAkxf2Dyc+vT6kSaCzfdb6PKwMzXBEMzbzRTTgktpwtO5prWhIpJXcHmh4DwxUwSnhRNjkHp79j8mjAhX1E8kL5mpuO9YkN2XMCss/Aoi88J09puAOmIo9I014NFs/QuDItehLqzet+7czwjd5fn4yOWZ+vQex
 6xy5mx0V
 afPZISwl+OUe/s4ewsrd7e/V3Nho9t8urFyU0tLPvjgxj/ooZZ5B+Y0Z8G/mVtPm0Qm2VS62lYvOjWU6nLuaeddJKWRetsBp0Bk1L2thldEqXQzgVh1sVoP0idL16V2uX7gyq4my76Bwr/gHTzK4C8H8omy7fiaTc9t6cd+J5N9BIeCZFVu2449zi7PqHQ1kEcql/oGAlY2b4mu59dYlxmDTELpC14wb9Au6d6vSW3GdIUCTU8DpmeJ13+8LUqQ671kVfHDU9GpMxzcK/BbY2Qur+0LuygEQdnfbQVoKd0IrtOAiXnbDYh3hRgtUBModd4X4oH5U+40yspI2NvpOFQjj9ItbWBjnu78ecOzpNhk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 21 Aug 2025 21:16:32 -0700 syzbot <syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com> wrote:
>
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
>> console output: https://syzkaller.appspot.com/x/log.txt?x=15f926f0580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
>> dashboard link: https://syzkaller.appspot.com/bug?extid=49a796ed2c9709652f1e
>> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
>> userspace arch: arm64
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15faa7a2580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144143bc580000
>> 
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com
>> 
>> ------------[ cut here ]------------
>> kernel BUG at mm/page_table_check.c:118!
>
> Thanks.
>
> Presumably due to the series "Support page table check on PowerPC". 

The syzbot triggered this on:
 HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
 git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci

This tree does not have "Support page table check on PowerPC", correct?

Also, I guess Dev's change fixes this reported problem which could happen in
this path: commit_anon_folio_batch() -> change_pte_range() ... 

[1]: https://lore.kernel.org/all/20250812060124.C9344C4CEF0@smtp.kernel.org/
[2]: https://lore.kernel.org/all/68a80cc6.050a0220.3809a8.0002.GAE@google.com/

-ritesh


> Andrew, could you please take a look?
>
> The series has been in mm.git for a week so I guess the impact of this
> is small.  I won't drop it at this time, but prompt attention would be
> appreciated.
>
>> Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>> Modules linked in:
>> CPU: 1 UID: 0 PID: 6740 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
>> pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
>> pc : page_table_check_set+0x584/0x590 mm/page_table_check.c:118
>> lr : page_table_check_set+0x584/0x590 mm/page_table_check.c:118
>> sp : ffff80009c9674c0
>> x29: ffff80009c9674d0 x28: ffff80008fae0000 x27: 0000000000000002
>> x26: ffff0000c079ca80 x25: 0000000000000001 x24: 0000000000000001
>> x23: ffff0000c079ca80 x22: 000000000012b950 x21: 0000000000000001
>> x20: 0000000000000003 x19: 1ffff00012eb65b0 x18: 0000000000000000
>> x17: 0000000000000000 x16: ffff800080528a28 x15: 0000000000000001
>> x14: 1fffe000180f3950 x13: 0000000000000000 x12: 0000000000000000
>> x11: ffff6000180f3951 x10: 0000000000ff0100 x9 : 0000000000000000
>> x8 : ffff0000cdb05b80 x7 : ffff800080d16554 x6 : 0000000000000000
>> x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff800080d15b5c
>> x2 : 0000000000000001 x1 : 0000000000000002 x0 : 0000000000000001
>> Call trace:
>>  page_table_check_set+0x584/0x590 mm/page_table_check.c:118 (P)
>>  __page_table_check_ptes_set+0x2a8/0x2e0 mm/page_table_check.c:209
>>  page_table_check_ptes_set include/linux/page_table_check.h:76 [inline]
>>  __set_ptes_anysz arch/arm64/include/asm/pgtable.h:709 [inline]
>>  __set_ptes+0x4a0/0x504 arch/arm64/include/asm/pgtable.h:741
>>  contpte_set_ptes+0x120/0x188 arch/arm64/mm/contpte.c:464
>>  set_ptes arch/arm64/include/asm/pgtable.h:1794 [inline]
>>  modify_prot_commit_ptes+0x4e4/0x694 arch/arm64/mm/mmu.c:1556
>>  prot_commit_flush_ptes mm/mprotect.c:197 [inline]
>>  commit_anon_folio_batch mm/mprotect.c:246 [inline]
>>  set_write_prot_commit_flush_ptes mm/mprotect.c:273 [inline]
>>  change_pte_range mm/mprotect.c:354 [inline]
>>  change_pmd_range mm/mprotect.c:570 [inline]
>>  change_pud_range mm/mprotect.c:633 [inline]
>>  change_p4d_range mm/mprotect.c:659 [inline]
>>  change_protection_range mm/mprotect.c:687 [inline]
>>  change_protection+0x1e84/0x3ff0 mm/mprotect.c:721
>>  mprotect_fixup+0x504/0x744 mm/mprotect.c:837
>>  do_mprotect_pkey+0x864/0xb30 mm/mprotect.c:993
>>  __do_sys_mprotect mm/mprotect.c:1014 [inline]
>>  __se_sys_mprotect mm/mprotect.c:1011 [inline]
>>  __arm64_sys_mprotect+0x80/0x98 mm/mprotect.c:1011
>>  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>>  invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
>>  el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>>  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>>  el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
>>  el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
>>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
>> Code: d4210000 97e865fd d4210000 97e865fb (d4210000) 
>> ---[ end trace 0000000000000000 ]---
>> 
>> 
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>> 
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> 
>> If the report is already addressed, let syzbot know by replying with:
>> #syz fix: exact-commit-title
>> 
>> If you want syzbot to run the reproducer, reply with:
>> #syz test: git://repo/address.git branch-or-commit-hash
>> If you attach or paste a git patch, syzbot will apply it before testing.
>> 
>> If you want to overwrite report's subsystems, reply with:
>> #syz set subsystems: new-subsystem
>> (See the list of subsystem names on the web dashboard)
>> 
>> If the report is a duplicate of another one, reply with:
>> #syz dup: exact-subject-of-another-report
>> 
>> If you want to undo deduplication, reply with:
>> #syz undup

