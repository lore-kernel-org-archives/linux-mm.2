Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2004CCAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 15:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE0F8E0027; Mon, 29 Sep 2025 11:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7955B8E0002; Mon, 29 Sep 2025 11:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB478E0027; Mon, 29 Sep 2025 11:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 56D7D8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:17:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C7931DF8AB
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:17:50 +0000 (UTC)
X-FDA: 83942642700.14.55C6FCB
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3EE79180008
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:17:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UpFUCIIU;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759159068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvOyryAypxH3+4wG3KZkQ2EISvw8ZEcZIHjxhBYkRgE=;
	b=Ee1Jss44w83AadUZQHEc7eGUOyKU2jl6CCJftL9C7cBmXkyNvmypoUP+t6st+3+PGoIy1y
	FIqsUXqye68BKASL6FRVFY9cKP+ExDhijN2QDHhBPpzwygSdn1M6zrk2HB4lOPXadhfaze
	UmVZA1lQpwEspyDg0K591XelEpLgnMc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UpFUCIIU;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759159068; a=rsa-sha256;
	cv=none;
	b=I9nbpeRc60R4m0nKKZpDBbcuElMWv4SPajZrU0z109Mpkqxxzibqy7i1bJBnJak1b+SXRT
	1khDUhdrQOvLuMCtMsYSXqVEKSzJwjarAqAaxn6ufgWLfeTBnWoOmIZPWn6JYUiEOY1TfD
	50N7PijTbop19lqE9jfjcc4b24Z9sps=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-749399349ddso59309907b3.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759159067; x=1759763867; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gvOyryAypxH3+4wG3KZkQ2EISvw8ZEcZIHjxhBYkRgE=;
        b=UpFUCIIUGWw7A/JyRZSNgRIcvRSZEXyFDCp7frFMy6bpAR7ODsQeFLeKetRad68tYB
         +n46vwozepMyUdjp6tTNOU7WcSkN4VbV5MGGq2V5cr+ZMX88f5c6BJxB5m6iWZsjeZV/
         cPxMWOozx85RrJsBvZBfrMyw4meBvwu5gIK+zyE15B6FWQt6A1TZjCIGaGbuCadrg5JP
         T+xKfZhHdTs5Ygrh3EhiX2qx5trmh0usylIKapKywP0k3Mry/okc2TWCLPUqY9sMMHHL
         iu6iNA+6iyUFIXfcEo/e+Ox8FUOUw9+GVNNG2P1GjAt2wPNcZEd2c3ng13GYXya4m1gt
         MDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759159067; x=1759763867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gvOyryAypxH3+4wG3KZkQ2EISvw8ZEcZIHjxhBYkRgE=;
        b=I6haW//G2yHdgBmwvtXDmOaWi7fmkQGKZobMR6eSocF+eiJCsGh8aMGWl4Wie37H+f
         pBsVz4D3Vv/SDu2mqvcnDC7JjglIAaieexFGQKa1YCM9vBHojvxLSz7v1ykB9+LxAbu4
         MQapWxB5shB+53R+50160eYzMzH8Fvh3p+dw++SLgFy7HN+8l9cXmnnVMBpUsU1ggGj0
         8hgfIvIITpNoCrwghTAcKm6nN4ZwgOm5AVvMgg/Mk/G/ni0CARG+DDyviBzrpZNJQBld
         CnX0D2v1tqbYtnvJCWZbpo4ck4f2r+urIA7Epg4lXYDR7VVGV675iJm9p0n8u2jnfwfu
         dbNA==
X-Forwarded-Encrypted: i=1; AJvYcCWJYzQnTbk9sio3SyCnpclirIJZnbKXfdLjvHSW3jX3ACWip8Z2/cMadA0j/7/NNIgellefiXJclw==@kvack.org
X-Gm-Message-State: AOJu0Yw5Ku6GWvzVA1uj8iQigvntSW9tD2DbCaPdWpmgtr4JLvTOAIyQ
	WZtUfZoBqv8X/GMPi4Sovp9c3Im7ePDwC4CB36v1Xusdgzy9j9N9meEs
X-Gm-Gg: ASbGncuvXKqFhpALuFDOxxH+SeW/C/R7MsENUomkNDSmyoRnY2xgLIfaf4Lp0OIZUX5
	2y4XjzMKa8V6+SRdKHOfNf2TQt+mIXCP+2ze4XpBjMOXW23Q4v91kILTnb4fb+GUYeAHlm6sJlf
	ofWzRLDC6WWkwzmqcz8EcQrHWrpWhxBCa8UeJLu4pJ3cxUlU/i6XDSCxTZo/BeKg/V+m11SF7TD
	DJevBJYOBx+vrkCcHMU4S4fnmpfiIAhzeHFVVN5tzgHsmo80CpQOI1sR16hJ0ytVOtfAz2IpbMa
	dbJLjHG++ymzF09fvxu3ia7XueDUr4L4Yozv8Q6Q1MhkNpERX2+E2OVt7Q6jXxd6t9Xt0fL8wF3
	4Fs3h/ksyFShY+0Bhk2rmbxdOzw+doGb3YwrMKBMePTbkYFfCBXGviQ==
X-Google-Smtp-Source: AGHT+IG03Xxr9FsAaNhFS/ao7nWzoRTl2e11K0kClHGJkJfFFVQCaVlVRxoehRsBF6M99SMNTqAnpQ==
X-Received: by 2002:a05:690c:9a07:b0:719:3e4f:60f7 with SMTP id 00721157ae682-76401288ea4mr191557227b3.26.1759159066447;
        Mon, 29 Sep 2025 08:17:46 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5f::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-765bd126227sm28968727b3.16.2025.09.29.08.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 08:17:45 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev,
	lkp@intel.com,
	Chris Mason <clm@fb.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Brendan Jackman" <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Suren Baghdasaryan" <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 4/4] mm/page_alloc: Batch page freeing in free_frozen_page_commit
Date: Mon, 29 Sep 2025 08:17:27 -0700
Message-ID: <20250929151744.2922386-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <202509281204.3086f707-lkp@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3EE79180008
X-Rspamd-Server: rspam05
X-Stat-Signature: 8q6g3nzgmbt6aj9bx11tmjfqbgfnd165
X-Rspam-User: 
X-HE-Tag: 1759159068-567963
X-HE-Meta: U2FsdGVkX18tlpb04msTw8ok+96+gq0KkXAYZFM+vqwPNcoPtjh4onZlKPd01vdvX3ADgSb1qj5dJz/08j6ttIiZ30ELF3vrzxXHJL6bXuLqeECVBSilMH1vzRkX4dFnXsb+53jqg5JNtXG8OYscLI+N5DU9TMMpI4dQBAkz8wSAphueSpgcg1wiTfFHEyodq0FxZNCABD11uQGLoAmoqtiAPuz02Y0KKJ0nnUB7w4+GGDPdVAjr9D2WeCnNnsMP2DrNYgSv31lAxryIgPZBAJFVYb+eB/qtrko/cuRYsq2DE/zv58Uk8xDJI9F4HMX7E1E3kbsxTnzP0PI7Iaxyd/RaV6VO2h+p8NMMH1NkYuWUBgsllZxhncjeHyIrx1E4otPzmdBS4JYtpTKWJ4VEOKr/nuJbAoqsDLMHugs4fnmGPVSORVXwCOufnTWX7bTDeirBLqETk9gwjYCDnQ3dY6+M5t/KjQpVWZriGNMWIYCXoCl6BMRWOHVNhrRjS60Wz3C/NUGp5+VIWzBGNVhO8DXIsuj/Y19TWqXbXqKnAqyzqxSJW+BZHhv4w+O+U8gkLPiYZ1FdkpIGWthQXbhCpYXcY2GVLh6YK3zzktV8/hBHOHcup4wGU3LnDvQnnit4T4XPKSqGjIF1J2gK5L8xC9jfb1WROL9agLycePJG885d/bMoNP0hK+jqoYWhLTkWm1L00SzA3KS7Bk5oqjtPe47sKrd2TS3MamQb6ToFhDa89NfEBc8dQTOKB30BNtgxLYs5Mr381a7JVx7bWuz4BQ3EDVwvc1RphvQcCBJaFqfXuRKeFvfS8oc8u1Cy5Bf+4y3Hl0LrfEh95UI0wSEeLKMPye/QAeJccGk/4r8rTUnnvGRH20K2qK9qpZAAOM/yKvIXGmOf+E7pbf4lzwYGiR/6Xdy2EgtKzSKmFkKdpjqVNCgSVJ94DwHgz/zRG1p8CL6sDUBr4FA21rE9vaS
 VjrHk5uM
 VnC9DNu6Y/o2zMFyNRD/3IzGRpGBdnVtcoMqJYHVQ60E+mEx0k6S0cwNHDG0ONoDS0R6ukvMA7U7ygvxvnXJMD+moXoURd25IvkTMsMBodGYAMhVdmKqYMy08xQbSshwkI9v1TGIxZGIiTljb3jMul7vVev6iUHkXsw81yz/eNtTogDSnPPManA2obeE7lzuQQO2NaROF41LKF3vy5U6C4YoPyumY4P+oF4QdAHlE7kzb0fGkKDJsmCoo0C5XFpCXgnzQwOMKUXyS+GrIVyIBcHZ80xEkIQnqX1opGg5t8aH6hLKrWsAF8sdMmAJikrfRpcOSMvTJqwb6m/xesmEiI1cqShxE8f9ZvTzEd0wB6koaevkoY7cCv9rmh9w8RFMP2uU9rN+pJp4fJ1QBamdNQ2lii7jat/GJCBqD55LO3BkByTUTSYK1gg4NoD2AXAhcjvgeRYVgW8nGXLOAknbq2Y+sb+cEjd8q4tI9rb/9oWcgv7ED3jaOavmpcd6YtGoZrh12M4l+raRIPnzIq+1vczlsun2RUdDuoQUzT73U7aJR/Nw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Sep 2025 13:17:37 +0800 kernel test robot <oliver.sang@intel.com> wrote:

Hello Kernel Test Robot,

> Hello,
> 
> kernel test robot noticed "WARNING:bad_unlock_balance_detected" on:
> 
> commit: 7e86100bfb0d65a17f3228a9af4c2a49ac38f057 ("[PATCH v2 4/4] mm/page_alloc: Batch page freeing in free_frozen_page_commit")
> url: https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-page_alloc-vmstat-Simplify-refresh_cpu_vm_stats-change-detection/20250925-044532
> patch link: https://lore.kernel.org/all/20250924204409.1706524-5-joshua.hahnjy@gmail.com/
> patch subject: [PATCH v2 4/4] mm/page_alloc: Batch page freeing in free_frozen_page_commit
> 
> in testcase: trinity
> version: 
> with following parameters:
> 
> 	runtime: 300s
> 	group: group-03
> 	nr_groups: 5
> 
> config: x86_64-randconfig-161-20250927
> compiler: gcc-14
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202509281204.3086f707-lkp@intel.com
> 
> 
> [  414.880298][ T7549] WARNING: bad unlock balance detected!
> [  414.881071][ T7549] 6.17.0-rc6-00147-g7e86100bfb0d #1 Not tainted
> [  414.881924][ T7549] -------------------------------------
> [  414.882695][ T7549] date/7549 is trying to release lock (&pcp->lock) at:
> [ 414.883649][ T7549] free_frozen_page_commit+0x425/0x9d0 
> [  414.884764][ T7549] but there are no more locks to release!
> [  414.885539][ T7549]
> [  414.885539][ T7549] other info that might help us debug this:
> [  414.886704][ T7549] 2 locks held by date/7549:
> [ 414.887353][ T7549] #0: ffff888104f29940 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap (include/linux/seqlock.h:431 include/linux/mmap_lock.h:88 include/linux/mmap_lock.h:398 mm/mmap.c:1288) 
> [ 414.888591][ T7549] #1: ffff8883ae40e858 (&pcp->lock){+.+.}-{3:3}, at: free_frozen_page_commit+0x46a/0x9d0 

So based on this, it seems like I must have overlooked a pretty important
consideration here. When I unlock the pcp, it allows both the zone and pcp
lock to be picked up by another task (pcp lock less likely), but it also
means that this process can be migrated to a different CPU, where it will
be trying to unlock & acquire a completely different pcp.

For me the most simple solution looks to be migrate_disable() and
migrate_enable() in the function to ensure that this task is bound to the
CPU it originally started runing on.

I'm not sure how this will affect performance, but I think in terms of
desired behavior it does seem like this is the correct way to do it.

Joshua

