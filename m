Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1B74CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 09:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A158E0005; Fri,  7 Nov 2025 04:49:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B121A8E0002; Fri,  7 Nov 2025 04:49:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4EC88E0005; Fri,  7 Nov 2025 04:49:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91E828E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:49:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43B9EC040D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:49:49 +0000 (UTC)
X-FDA: 84083339298.13.A42A573
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf28.hostedemail.com (Postfix) with ESMTP id 05313C000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:49:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b="fw1/iwM8";
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf28.hostedemail.com: domain of "prvs=399a1f935=acsjakub@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=399a1f935=acsjakub@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762508987; a=rsa-sha256;
	cv=none;
	b=jGLI2/Sjki8RUBQ5m4z9jIYsOylZu9ysfx7YMFsMh8/XDe/RK4uhBZvkuhuWVCSOA4JhxE
	SrclFSpttoNHPtS0IhHER29+o//8SwWzpKimQ3yEdVvFHFk8ygJvQq143rLBlk3+McQSdQ
	z/cdy8waSnPchKor8ehgYBrY9LpzXF0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b="fw1/iwM8";
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf28.hostedemail.com: domain of "prvs=399a1f935=acsjakub@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=399a1f935=acsjakub@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762508987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSmOMSfMDPnh2RnGvEKnRHhJf3u17n26UTMXVggCb24=;
	b=rrRt5O/enZclRAM9E1MUjswW6vq8ig6hVksAoBlIOFDSFFHmN0VGSedNIeFFqKhKKBLl7z
	63oh8UfgF4xAtq9DduVPV/Q5h9tX53zclXQ0RNt4xZEgjrT5x06QS/TbHHWWB3BhJBThGr
	2IOgEiRTmwFwWIG/AGTZtWyP9Y3KNT0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1762508987; x=1794044987;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tSmOMSfMDPnh2RnGvEKnRHhJf3u17n26UTMXVggCb24=;
  b=fw1/iwM8hCUYy3+V3HKNxWtT79zPK6nNTrENA07kbg5M7vdadUzCu9Hm
   cOfKRbUjNOendALF7/xRWKvBSbPaosYR1YW/epgK5jz8clsyCzue2WJCf
   2EBaOC7C3DNLQ9H3n5prRPOn3rZBh8uedspWriFj7jZokMzTmN0/ggG6W
   7vfMGblCzbraobGwVx1cIjNbTKmW1WUF6HFCwT+vjxbUNTH4iJ/qeYbsY
   Z3VMXhx1/c7aT1IzbJ6cFMHfNmyNRbiZCr0F/kiSMhKUwlj2BZ380SUNx
   brkXSvBaEd1r1cbADsEPhuBDYcVvzeyeMgEPflSMiJJw/gQ2UivAQAgOf
   Q==;
X-CSE-ConnectionGUID: Nq04Ner7T1iISROkPCGKRg==
X-CSE-MsgGUID: QoTYeIQ2T72oQgSQfm8RBQ==
X-IronPort-AV: E=Sophos;i="6.19,286,1754956800"; 
   d="scan'208";a="6610224"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 09:49:43 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:3609]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.26:2525] with esmtp (Farcaster)
 id c7de7f36-394a-411d-a4d8-9f571b0cb2a5; Fri, 7 Nov 2025 09:49:43 +0000 (UTC)
X-Farcaster-Flow-ID: c7de7f36-394a-411d-a4d8-9f571b0cb2a5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 7 Nov 2025 09:49:43 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Fri, 7 Nov 2025
 09:49:41 +0000
Date: Fri, 7 Nov 2025 09:49:38 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>, Jann Horn
	<jannh@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <peterx@redhat.com>, <axelrasmussen@google.com>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] mm/ksm: fix flag-dropping behavior in ksm_madvise
Message-ID: <20251107094938.GA71570@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
References: <20251001090353.57523-1-acsjakub@amazon.de>
 <20251001090353.57523-2-acsjakub@amazon.de>
 <13c7242e-3a40-469b-9e99-8a65a21449bb@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <13c7242e-3a40-469b-9e99-8a65a21449bb@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D041UWB004.ant.amazon.com (10.13.139.143) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05313C000B
X-Stat-Signature: e9facmm1h9rushgouodoixa6ywgcnxww
X-HE-Tag: 1762508986-557720
X-HE-Meta: U2FsdGVkX19rJCH9e5FNTx/FOQFzC/0lFuBwwfeOEMSQYd7xKaFl/ee4byqvnPZvCnldi1cpgX1AJSUIUyc6ZmHb5yX25DFfLEgTPj5lwMHim5K8J173w2yXdUsT0J1PZO0TE+lnOw3rxcHnKEd7XGaf9t3ivxIM7FS/CqJ/3Ocl3JopXk3mw3nWNjOvroXqXn7gB3q0fe+th/mnl9EJThG/Gd33BUMYNF0kfBeQrjWRCHLI32KHnaYvIAu2mFM6/8akp4XjF0RXSZ+pms1jASATKVAjnQRyToX35O2aeMs7L8Vu1DQfiY9/51zgxOj47ItsjOWzv06g5JD91cFyf3FH63wHhLb3BF07BbLpg2qAVUGCN2CYr9tUHBa5Vk/4uW0Q835mjUGKsCN48RomITgc4QE0YjTB/jl5dxDSE1gKT2BJ4XawOzVnJUqy7Ni3pfhiEyVJIvgX6by5EgX2hnjFGK3073wPBTTOJCeEryeqLuMawGBbK+ZqUojQu49KpDA5M8ZS1pOQi4NtgDNDqbm1auP4W+xKjJvW5vWSfhUXvhEkqPe5gA9hq1i+3EAbMVCkAWJ+OHj5XJd7+0iHgCQcSUSb/hdc4TdrjAAyT41InQ+PTua6WM8tyv+2IwY8X1Y3acau42usk/n4A+tN0Aa33z3b0dOETD7fGxj7ERo+CJODcTMKw9DnXGJGxod9PKJ2j8xPjjc4kjxrlEPpoHukn/DlfLBurn7PIxNfBh20TSMmmV2f8GYgUgZMNgfZn6n7Dbf4qzKpr3hP2+sZJmqpYxNsq5DqsFsSWltkwk5GYAimGAjKWbyo2OCdWW/G3qbZ+mXbBYS1sk9NPRr/+l60b8tiAVRZePKygYfaiA6gmR35Nlb9B1qAQp4/zUVLiMzqnoHiqhfp2IxQ86dCrBIg8w/S8U5vnrYrez239b1vcYa9AE6vXRtvhOah1ndOTapboFRoYJF2EO0sBSR
 DImOeU0m
 4Mi1qF2C0sHTu2Zg/4HoApuzgwuEjN7BKrD7l7BCO0/Im1vGhr7mZTpjIicd1YT8A0mLB/4+zJOQY2v2e4Jt5e0MBsypcfhrv28frdy0l7nFgR49sqIw3JKtR0pUiNb8RHkQdDpcD4cVKwWHdD74k6OZsL94o/l199fTr0XVMtN2oIe2IfyP69j5SpPRJpTqutPQFAnM9BGsm7obr6e5oaxUIJje/T4mzj6U8F82TxF0JCymStx7KUN8XT9yFxQl2fM8GoRCcTNjBAHk82I2o7WI4cwylIL0bIR/q7I5NmIQkRgGgDHVuShTa1gZusSxkrzmLxB15naWeElYTT2zVhynyt7RGBQJoa2QZhJOnbxGbGMsYzaI/x+vbkMg7mVAvTUeYuGZG/wdMHwm4izLOIXQyR72CXH8R4kcFfELK4t5WBWo465+saTWMHDZhfkdc15Yb24g1G4meXWynN/LkJ3c+iQ4dHfOcZYed53yDwe9QkNh02OcylNqz9Gz7gkT226D0NR9zQ1FdKG7ijbiL9W0cctIFGqNWHWpXrWsqMkN5qFwXpjcRKKuzz5f8IFKo0/ynuUCNvrt8FaXkz7lKAXUjsur8fH1+TIBIpFI7vgjUR22IfGgaF0u9Hg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 11:39:28AM +0100, Vlastimil Babka wrote:
> On 10/1/25 11:03, Jakub Acs wrote:
> > syzkaller discovered the following crash: (kernel BUG)
> > 
> > [   44.607039] ------------[ cut here ]------------
> > [   44.607422] kernel BUG at mm/userfaultfd.c:2067!
> > [   44.608148] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
> > [   44.608814] CPU: 1 UID: 0 PID: 2475 Comm: reproducer Not tainted 6.16.0-rc6 #1 PREEMPT(none)
> > [   44.609635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> > [   44.610695] RIP: 0010:userfaultfd_release_all+0x3a8/0x460
> > 
> > <snip other registers, drop unreliable trace>
> > 
> > [   44.617726] Call Trace:
> > [   44.617926]  <TASK>
> > [   44.619284]  userfaultfd_release+0xef/0x1b0
> > [   44.620976]  __fput+0x3f9/0xb60
> > [   44.621240]  fput_close_sync+0x110/0x210
> > [   44.622222]  __x64_sys_close+0x8f/0x120
> > [   44.622530]  do_syscall_64+0x5b/0x2f0
> > [   44.622840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [   44.623244] RIP: 0033:0x7f365bb3f227
> > 
> > Kernel panics because it detects UFFD inconsistency during
> > userfaultfd_release_all(). Specifically, a VMA which has a valid pointer
> > to vma->vm_userfaultfd_ctx, but no UFFD flags in vma->vm_flags.
> > 
> > The inconsistency is caused in ksm_madvise(): when user calls madvise()
> > with MADV_UNMEARGEABLE on a VMA that is registered for UFFD in MINOR
> > mode, it accidentally clears all flags stored in the upper 32 bits of
> > vma->vm_flags.
> > 
> > Assuming x86_64 kernel build, unsigned long is 64-bit and unsigned int
> > and int are 32-bit wide. This setup causes the following mishap during
> > the &= ~VM_MERGEABLE assignment.
> > 
> > VM_MERGEABLE is a 32-bit constant of type unsigned int, 0x8000'0000.
> > After ~ is applied, it becomes 0x7fff'ffff unsigned int, which is then
> > promoted to unsigned long before the & operation. This promotion fills
> > upper 32 bits with leading 0s, as we're doing unsigned conversion (and
> > even for a signed conversion, this wouldn't help as the leading bit is
> > 0). & operation thus ends up AND-ing vm_flags with 0x0000'0000'7fff'ffff
> > instead of intended 0xffff'ffff'7fff'ffff and hence accidentally clears
> > the upper 32-bits of its value.
> > 
> > Fix it by changing `VM_MERGEABLE` constant to unsigned long, using the
> > BIT() macro.
> > 
> > Note: other VM_* flags are not affected:
> > This only happens to the VM_MERGEABLE flag, as the other VM_* flags are
> > all constants of type int and after ~ operation, they end up with
> > leading 1 and are thus converted to unsigned long with leading 1s.
> > 
> > Note 2:
> > After commit 31defc3b01d9 ("userfaultfd: remove (VM_)BUG_ON()s"), this is
> > no longer a kernel BUG, but a WARNING at the same place:
> > 
> > [   45.595973] WARNING: CPU: 1 PID: 2474 at mm/userfaultfd.c:2067
> > 
> > but the root-cause (flag-drop) remains the same.
> > 
> > Fixes: 7677f7fd8be76 ("userfaultfd: add minor fault registration mode")
> 
> Late to the party, but it seems to me the correct Fixes: should be
> f8af4da3b4c1 ("ksm: the mm interface to ksm")
> which introduced the flag and the buggy clearing code, no?
> 
> Commit 7677f7fd8be76 is just one that notices it, right? But there are other
> flags in >32 bit area, including pkeys etc. Sounds rather dangerous if they
> can be cleared using a madvise.
> 
> So we can't amend the Fixes: now but maybe could advise stable to backport
> for even older versions than based on 7677f7fd8be76 ?
> 

Good point. It was a bit tricky to determine the correct "fixes" tag, as
there were more candidates:
- the commit that initially introduced VM_MERGEABLE as a constant with
  different inferred type to other vm_flags constants
- the commit that first started using upper 32 bits of vm_flags and did
  not make sure the constants are defined safely
- f8af4da3b4c1 indeed, as the one that makes the drop actually possible
- 7677f7fd8be76 that shows us a path where the drop manifests

Looking back, I agree f8af4da3b4c1 is the better option, but as you
said, that won't be changed now.

Nevertheless, I'll send the backports after a round of kselftests,
thanks for pointing this out.

Have a good day,
Jakub
 



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Christof Hellmis
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


