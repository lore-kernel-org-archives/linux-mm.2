Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7567CCAC587
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 08:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64E368E0001; Sat, 13 Sep 2025 04:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6248F6B000D; Sat, 13 Sep 2025 04:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515168E0001; Sat, 13 Sep 2025 04:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 262CC6B0008
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 04:19:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB2CCBC7CA
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 08:18:59 +0000 (UTC)
X-FDA: 83883526398.26.3490AEB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C881D20003
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 08:18:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KtpoM3bE;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757751537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Spp/Jz1qXl5SUzfrVjS1ofed61ZjUSO+C5UH/+1pmIs=;
	b=Tm5rnf/981wCqIJmOz3eABa0uK2Cz5KVr//peGrOPPYzJoIYrbkJz6f0lgGQVk/+rXbdQD
	CjmZRB1F8RLutatozRsoxVeZE1GyGzfzfQsiIaiU/DB6civBr71MY8NLYub3raelTycBJ3
	4l4lcTgY5WGlUvsQ+/KmaO4bRC3Epj4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757751537; a=rsa-sha256;
	cv=none;
	b=YsPIR59BMFauGL/IDR43Iq2td/HNcSeJmR9iftd544G3JcBjwWLfgqCzKR7u+3D08o9Ghy
	5b/0emS8NgOoh4/6RX/p6GDpmxJx6UXQEm0gvi3OZqcv+w9Y+D0xhUpSBsv+TxZQvDkB1Z
	yPnYRHJ2b4uxYTXNLkA9kqvvagSjrfk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KtpoM3bE;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757751537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Spp/Jz1qXl5SUzfrVjS1ofed61ZjUSO+C5UH/+1pmIs=;
	b=KtpoM3bEKsP5I85ScyDCHWcxG4d8OqaPoa+MG1bORVZajQs9Zw+FLb1Mn3LG9Z/IBx3uo/
	ws1X16tv3q+HFXSm1Wsd8w32Rg6oDynTYBVp95Dx12w0ijgT4g3/geQWf3oPx/CqRVoLfK
	Xvfe2039Eu8OP5pKWHs/lxUh/jkqboA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-501-cbEIzo6iN9yUuPu2mhHx7A-1; Sat,
 13 Sep 2025 04:18:53 -0400
X-MC-Unique: cbEIzo6iN9yUuPu2mhHx7A-1
X-Mimecast-MFC-AGG-ID: cbEIzo6iN9yUuPu2mhHx7A_1757751532
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A99319560B3;
	Sat, 13 Sep 2025 08:18:52 +0000 (UTC)
Received: from localhost (unknown [10.72.112.45])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D19019560B9;
	Sat, 13 Sep 2025 08:18:49 +0000 (UTC)
Date: Sat, 13 Sep 2025 16:18:46 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: kasan-dev@googlegroups.com, ryabinin.a.a@gmail.com, glider@google.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, linux-mm@kvack.org,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Subject: Re: System is broken in KASAN sw_tags mode during bootup
Message-ID: <aMUo5rXaXOU2nNh4@MiWiFi-R3L-srv>
References: <aKMLgHdTOEf9B92E@MiWiFi-R3L-srv>
 <CA+fCnZebyMgWWEOW_ZxiGwnkiXqXX6XK5NJv-uWXAxdN+JxsSw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CA+fCnZebyMgWWEOW_ZxiGwnkiXqXX6XK5NJv-uWXAxdN+JxsSw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x1uX4N0jdqAxpNoSXDq9PgxpQxMpN6bgL8ds-ys5qtA_1757751532
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o3okh84w6n47q59xdprm9bjkh1ca1zaa
X-Rspamd-Queue-Id: C881D20003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757751537-651045
X-HE-Meta: U2FsdGVkX1/GPxfc0xShclX8IpcLGo1Q2ETPaJxIBTBKkG27S+FQWjZlJIBc7sB7jwdSXmxtilSWGogePfhUBLI9a/sqvEs3Nul0wX03mVbzoSCB8ddyiXpOAt04ErIdlBfotILh9sOdItYaV7rR6i5mezgWnGEwJtVl+/tFBiV92LtHT+1YK28JmpBaLXI+Z4caRNjP8CyrmQdlyplqeq6AN87oba5rWOqNgEoyuBDLjEXLz2CvZPaglzxlWiIuKdGOfWYwje1do6NeXe4pP2J7VzORg4OoiqmoagExC79ijN0IBrm8qBjBeYRU/8fpAsbzE9Re2EGOmscxyPDEOCq1yHIJ6pCDQGaU27xXHsf2OzDCR2Q6s5AKZjMilz5tBNonSuG9S3WAtdZKAG89T9XeSLUeAZzrKvUuuKq0tFOiH9mEkhDqQf13/P0UpIte+VCzQYZJK6enBRuwuceazGMFnQmsHXXP1LABVXkJszbDlI1AMV8ezIffRUtnIfCSEvMlB79hij2ANH0CJyDgDwo6flWHUsGkTXW+BrkXLSfab9dwC1+E5MFnPxNEcuuSi6K2RHTOjWjdG55LLYr8RPkbN9cHClbzFyye2hKyHbjp4zaL09PZSDmTunxYWhPe/ZIP+q2XVIy7KgnQOeNKsjqdZ4/jqAWSf2It0g5BEeyqclI9Zx/JkWnl1NNhM48ZRvazw9ly6IQMw5StchcAQMi2pTRlfRJFsco731G8GwMLnhBMgFq4TCe389TxpOalVM6+En1n0gGe4Ig2VXgLUrdvOJ2WdsjBmq46PoTcuWhDeg4hTUGB+jXIjc5NY+fjhzOozpqc1b/wDzYMZcA5bXUnpD7lB+CLMo8c4W3LFrdWZ/fJYOFW93YR8RLVFRJ7j/38TJAEbiM5zr6MraxjsqYRiPHIuSML+e666do0oh3JaHcXjMSQuswjjl/NZTJqf+LLc4ZXYsFIyrcTeDI
 pM0znRCn
 9i/Slm4L+bgmfqtZIC8f9bP1tipj/3t34qx3SkIxEdo1C+PfdavuB1QVGtb8vST2McUu7foh8ZtWBhTR12qOLgvhDul2Q94R5pbChZXY+7dgdw4t9EUMzywmZ8fOt33Z5BFsO80ZzxTPcnQpXGAlHXXDGvpjZDhylSlbo7ThNvKPwXWDisPkOWSXcl7z8ONX2iVIn+WX2D3xXOGuSvs+Jk0mvk/IYWvLngwvVQFlsTmm0WV5AuyTGuPbIEmrAb5ZH40FNZVUkiEBQKcrtuP34nARvPnTHe+zz3cVadzMGcW/bR+glo152VqNtEfLGXfOsZkaKDgxn7lxBOIDamQzYeVjvj8mRsQmAzN/f6C3Ky6tENAh5SyiJj3n8ncshf4udqj94g+r7LsZwipPsN8lBjgsIeabk0SsjNRdEKAI83kWYQyd4hv16MhhqACqzQ6fHolV2qd5SGIQs4kiWR8TvCCA/JYXiGlzxGThZe/OJwCSmaHyfPaNpyq0hZB3VYSyCuoOlpdlINMgzK3/7pJizrZYcLXV8lN7RF4QT6oefPXkZAdcPv1A3nN+qBBQFLh0MASDfv/fEycydJBonKKPBpxP1fLxH141fkxB+RODua3c0hle0P/we8th+fGqnd13KZYEXfBILjUl7X27Ha9bErKTutQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/06/25 at 07:23pm, Andrey Konovalov wrote:
> On Mon, Aug 18, 2025 at 1:16 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > Hi,
> >
> > This can be reproduced stably on hpe-apollo arm64 system with the latest
> > upstream kernel. I have this system at hand now, the boot log and kernel
> > config are attached for reference.
> >
> > [   89.257633] ==================================================================
> > [   89.257646] BUG: KASAN: invalid-access in pcpu_alloc_noprof+0x42c/0x9a8
> > [   89.257672] Write of size 528 at addr ddfffd7fbdc00000 by task systemd/1
> > [   89.257685] Pointer tag: [dd], memory tag: [ca]
> > [   89.257692]
> > [   89.257703] CPU: 108 UID: 0 PID: 1 Comm: systemd Not tainted 6.17.0-rc2 #1 PREEMPT(voluntary)
> > [   89.257719] Hardware name: HPE Apollo 70             /C01_APACHE_MB         , BIOS L50_5.13_1.16 07/29/2020
> > [   89.257726] Call trace:
> > [   89.257731]  show_stack+0x30/0x90 (C)
> > [   89.257753]  dump_stack_lvl+0x7c/0xa0
> > [   89.257769]  print_address_description.isra.0+0x90/0x2b8
> > [   89.257789]  print_report+0x120/0x208
> > [   89.257804]  kasan_report+0xc8/0x110
> > [   89.257823]  kasan_check_range+0x7c/0xa0
> > [   89.257835]  __asan_memset+0x30/0x68
> > [   89.257847]  pcpu_alloc_noprof+0x42c/0x9a8
> > [   89.257859]  mem_cgroup_alloc+0x2bc/0x560
> > [   89.257873]  mem_cgroup_css_alloc+0x78/0x780
> > [   89.257893]  cgroup_apply_control_enable+0x230/0x578
> > [   89.257914]  cgroup_mkdir+0xf0/0x330
> > [   89.257928]  kernfs_iop_mkdir+0xb0/0x120
> > [   89.257947]  vfs_mkdir+0x250/0x380
> > [   89.257965]  do_mkdirat+0x254/0x298
> > [   89.257979]  __arm64_sys_mkdirat+0x80/0xc0
> > [   89.257994]  invoke_syscall.constprop.0+0x88/0x148
> > [   89.258011]  el0_svc_common.constprop.0+0x78/0x148
> > [   89.258025]  do_el0_svc+0x38/0x50
> > [   89.258037]  el0_svc+0x3c/0x168
> > [   89.258050]  el0t_64_sync_handler+0xa0/0xf0
> > [   89.258063]  el0t_64_sync+0x1b0/0x1b8
> > [   89.258076]
> > [   89.258080] The buggy address belongs to a 0-page vmalloc region starting at 0xcafffd7fbdc00000 allocated at pcpu_get_vm_areas+0x0/0x1da0
> > [   89.258111] The buggy address belongs to the physical page:
> > [   89.258117] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x881ddac
> > [   89.258129] flags: 0xa5c00000000000(node=1|zone=2|kasantag=0x5c)
> > [   89.258148] raw: 00a5c00000000000 0000000000000000 dead000000000122 0000000000000000
> > [   89.258160] raw: 0000000000000000 f3ff000813efa600 00000001ffffffff 0000000000000000
> > [   89.258168] raw: 00000000000fffff 0000000000000000
> > [   89.258173] page dumped because: kasan: bad access detected
> > [   89.258178]
> > [   89.258181] Memory state around the buggy address:
> > [   89.258192] Unable to handle kernel paging request at virtual address ffff7fd7fbdbffe0
> > [   89.258199] KASAN: probably wild-memory-access in range [0xfffffd7fbdbffe00-0xfffffd7fbdbffe0f]
> > [   89.258207] Mem abort info:
> > [   89.258211]   ESR = 0x0000000096000007
> > [   89.258216]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [   89.258223]   SET = 0, FnV = 0
> > [   89.258228]   EA = 0, S1PTW = 0
> > [   89.258232]   FSC = 0x07: level 3 translation fault
> > [   89.258238] Data abort info:
> > [   89.258241]   ISV = 0, ISS = 0x00000007, ISS2 = 0x00000000
> > [   89.258246]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> > [   89.258252]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> > [   89.258260] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000008ff8b8f000
> > [   89.258267] [ffff7fd7fbdbffe0] pgd=1000008ff0275403, p4d=1000008ff0275403, pud=1000008ff0274403, pmd=1000000899079403, pte=0000000000000000
> > [   89.258296] Internal error: Oops: 0000000096000007 [#1]  SMP
> > [   89.540859] Modules linked in: i2c_dev
> > [   89.544619] CPU: 108 UID: 0 PID: 1 Comm: systemd Not tainted 6.17.0-rc2 #1 PREEMPT(voluntary)
> > [   89.553234] Hardware name: HPE Apollo 70             /C01_APACHE_MB         , BIOS L50_5.13_1.16 07/29/2020
> > [   89.562970] pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > [   89.569933] pc : __pi_memcpy_generic+0x24/0x230
> > [   89.574472] lr : kasan_metadata_fetch_row+0x20/0x30
> > [   89.579350] sp : ffff8000859d76c0
> > [   89.582660] x29: ffff8000859d76c0 x28: 0000000000000100 x27: ffff008ec626d800
> > [   89.589807] x26: 0000000000000210 x25: 0000000000000000 x24: fffffd7fbdbfff00
> > [   89.596952] x23: ffff8000826cbeb8 x22: fffffd7fbdc00000 x21: 00000000fffffffe
> > [   89.604097] x20: ffff800082682ee0 x19: fffffd7fbdbffe00 x18: 00000000049016ff
> > [   89.611242] x17: 3030303030303030 x16: 2066666666666666 x15: 6631303030303030
> > [   89.618386] x14: 0000000000000001 x13: 0000000000000001 x12: 0000000000000001
> > [   89.625530] x11: 687420646e756f72 x10: 0000000000000020 x9 : 0000000000000000
> > [   89.632674] x8 : ffff78000859d766 x7 : 0000000000000000 x6 : 000000000000003a
> > [   89.639818] x5 : ffff8000859d7728 x4 : ffff7fd7fbdbfff0 x3 : efff800000000000
> > [   89.646963] x2 : 0000000000000010 x1 : ffff7fd7fbdbffe0 x0 : ffff8000859d7718
> > [   89.654107] Call trace:
> > [   89.656549]  __pi_memcpy_generic+0x24/0x230 (P)
> > [   89.661086]  print_report+0x180/0x208
> > [   89.664753]  kasan_report+0xc8/0x110
> > [   89.668333]  kasan_check_range+0x7c/0xa0
> > [   89.672258]  __asan_memset+0x30/0x68
> > [   89.675836]  pcpu_alloc_noprof+0x42c/0x9a8
> > [   89.679935]  mem_cgroup_alloc+0x2bc/0x560
> > [   89.683947]  mem_cgroup_css_alloc+0x78/0x780
> > [   89.688222]  cgroup_apply_control_enable+0x230/0x578
> > [   89.693191]  cgroup_mkdir+0xf0/0x330
> > [   89.696771]  kernfs_iop_mkdir+0xb0/0x120
> > [   89.700697]  vfs_mkdir+0x250/0x380
> > [   89.704103]  do_mkdirat+0x254/0x298
> > [   89.707596]  __arm64_sys_mkdirat+0x80/0xc0
> > [   89.711697]  invoke_syscall.constprop.0+0x88/0x148
> > [   89.716491]  el0_svc_common.constprop.0+0x78/0x148
> > [   89.721286]  do_el0_svc+0x38/0x50
> > [   89.724602]  el0_svc+0x3c/0x168
> > [   89.727746]  el0t_64_sync_handler+0xa0/0xf0
> > [   89.731933]  el0t_64_sync+0x1b0/0x1b8
> > [   89.735603] Code: f100805f 540003c8 f100405f 540000c3 (a9401c26)
> > [   89.741695] ---[ end trace 0000000000000000 ]---
> > [   89.746308] note: systemd[1] exi
> > =========================
> 
> Might be the same issue as the one being fixed by Maciej here:
> 
> https://lore.kernel.org/all/bcf18f220ef3b40e02f489fdb90fc7a5a153a383.1756151769.git.maciej.wieczor-retman@intel.com/
> https://lore.kernel.org/all/3339d11e69c9127108fe8ef80a069b7b3bb07175.1756151769.git.maciej.wieczor-retman@intel.com/
> 
> Perhaps it makes sense to split that fix out of the series and submit
> separately.

Thanks for the information. I finally got a machine to reproduce the
issue and testing the patches. It's weird it firstly can't be reproduced
in the latest 6.17.0-rc5+, not sure if I made anything wrong on steps.
Later, I started it over and can stably reproduce the problem, I can
confirm Maciej's two patches can fix the problem very well.

Will reply to Maciej's patches to add my Tested-by.

Thanks
Baoquan


