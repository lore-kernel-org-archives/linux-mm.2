Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6271BCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6456B0099; Mon,  8 Jun 2026 07:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77EE6B009B; Mon,  8 Jun 2026 07:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB44D6B009D; Mon,  8 Jun 2026 07:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAB506B0099
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:25:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56140164D5B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:25:02 +0000 (UTC)
X-FDA: 84856513644.14.EEDACE1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id D075820002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:24:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ilWtWRuA;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780917900;
	b=W/3w832w3ycgFYiqbjV6NfVmJvyCnvgyOAfCJHmZ94Gx3uWvFfT5H7fNGq/GCYXYJ8idwP
	of3GO/0LiOd7uCj+BCoyKC06+q2LC5X3zhtHMe/fdZWamDC9hA+kuNoO7L/7XofROD7Xg9
	2I0ATQNHW8ZLud1iZsbsmsV5uR0PBi0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ilWtWRuA;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780917900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9f5T1BSk58DX0DmxRMirXoZ5HUqv5xhVLbUyPoM5/04=;
	b=LIfjGCyiTNZm09+6xwHU3LacpMPkRQ65iidsbdxn2qZVBiC3LHr3NwoI2e32R4haMyqKFT
	K37Pjo9jazS7ARX6n0sGu6mYJ9+nRnh/NDAjntRg4J9vVJcCu7F4CFGyskm+QnQ56l1D5h
	1b/PUh7Kj7ZAVGsYskRRaWrhzf8Tk9k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 460FF2381;
	Mon,  8 Jun 2026 04:24:53 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD71C3F86F;
	Mon,  8 Jun 2026 04:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780917897; bh=H0j2h/IuHXRAGbZayNOkBH0sXrTKcXJvAH7vKH8W7is=;
	h=Date:To:From:Subject:From;
	b=ilWtWRuAoX4VA99FP1OVnP40YBIxS1VZnPKlxQ6i0nM8JzcfNMfRhuXS0sp5M5r02
	 zdmKWOA9+deFTUtaMYcvtNlx8Ta0rU6auzXLhDRCCDo8Q7fuLahVPgXAqalNT6L23R
	 KLSPDrDCzQxQ7i9DLG3iFzXU3oDAgFitziJFh3w8=
Message-ID: <5ca6512c-bdc1-4620-9c99-c7525e059099@arm.com>
Date: Mon, 8 Jun 2026 16:54:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 David Hildenbrand <david@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 LKML <linux-kernel@vger.kernel.org>
From: Dev Jain <dev.jain@arm.com>
Subject: [BUG?] invalidate_lock not held in read_cache_folio()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D075820002
X-Stat-Signature: rpug4sco5d55xj7qzf6jtyd1s9oakyun
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780917899-260875
X-HE-Meta: U2FsdGVkX19N6IMF8pADefnh0ciL+wnkaelFdY9F6r2ZANy5uMaZfYJQ2v2CpX+uV0Hr2FeOQtH7c/Oyv9MG7/KgTZyCw1cAz7rnkzKRoDY4czrC88kAjYcw0ZaSn7Ht65OP8YPDDxXHRp4FRsNoFo86d6S50yR4c/z/Qr9gk5QuczfKKq5/is/Gw2egAsSAV+D8/ohQhJO/Nlfa0SrEQ8Yq5LVOasB262Wq2FmGYageJc12gblxGNvjG+oi55liqPpCLR3wNoRXg7i3JLXzZaltW9rLw/iWL0l4JwjkmmiYUVcn/J4o5W0r57ZXae5r4ovynVdDvqhKWAYsqVdqtnpOUnlDo9GzXTi8CKsSIN7EMFzpbSuEYtnhkvgh7N9LkEcSl1ZqavhYXUiD65DzAoCkPpXPMxcpks/fzWLNCg9nafj7qsRERFoehaNgdso9l+9ljplYUi4JXpoK5eBQvPsPstOWV0Mb0ZgggvuML0BrYUIMFH6vjYUcT01Y6ktB5CKKLJH24yhLZ29dzS8yOaWOAS2NpGfEqIj9hMWRhq1Uyv07UiSj/LiD7FGHzKYzxWP09YUadoSF+x5nmch6EHCvBycVYe0ESjy0UF/TpDJ9IzoZiv4X4wjxYfPnF6sVvT4di7o6l4gl9d3W1h6eyin6QMO0ALxDCAdG2IxSTxikR5P9HMGa2ztj3SsEu5S/W/HS3jcvTnNxUbKQwZjRR+0G2BeKSt88g63WHZZ3lJOLsJkdI/R4+x0JA1PwqfIQxD/AhWtRZiJ6SuvMHxUHrJ4/lgQFIo+sZ/nLFUMqJbjyZosgXAex2YGibsvsNtcFDMTlgRSXeH/2ItOxzeUPPZNg3x2+2liP9seTvI8Twu5WoiwQs3gcVb8EsFB2eCgJbk05xmzeDl1Phj6dKYA/xIMNsWB0zPJarhfX4TrbtgNiySe5+AyBK1lUnG2IsZWFrWKeg9PEOdOqOamfmeb
 A1B5Mg2c
 4SP4VzcsQtx+ZXo6UX9vFwXD7RgIiateBalsmALzx+rigDFohe1Pgvdum1DmTNAnvzCTKHXFImqKUPdH9WqNj7qcIyBVyOMc6YwQoIBPcOEnpsVqJIeb930I4NSDq1f8L520FrtjyLl0xpMcbmhUPZXfKZMmEMBRoX6P1yitAJ2YzqefQlaC2agVYRr/CjDRsfiJqEysYDc952Ob6/S+r90VkLPNKoeSqf6/fr+Ru8Eo/ZS/IY4LfRCP/T6y+Ekv43GuMhdyeqLNA/TwIdh0m7Ef37brkYewVwjwLDgon7sNgDwlQzU5tHkW4jmrUTDMO26QBkp9/tMMonJTl63cQFePn48/G0hXe6Gb5swz1DJeQAcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

My understanding is that there are two ways we are serializing against concurrent
addition of a folio into the pagecache (see 730633f0b7f9).

The kerneldoc of read_cache_folio() says:

"Context: May sleep.  Expects mapping->invalidate_lock to be held."

I put the following in __filemap_add_folio():

+       BUG_ON(!inode_is_locked(mapping->host) &&
+              !rwsem_is_locked(&mapping->invalidate_lock));


And got the following trace:


[    0.088725] kernel BUG at mm/filemap.c:858!
[    0.088727] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[    0.111312] Modules linked in:
[    0.111437] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.1.0-rc5-00493-g65484bf449f7 #178 PREEMPT
[    0.111801] Hardware name: linux,dummy-virt (DT)
[    0.111987] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[    0.112255] pc : __filemap_add_folio+0x5dc/0x680
[    0.112437] lr : __filemap_add_folio+0x168/0x680
[    0.112629] sp : ffff80008005b550
[    0.112757] x29: ffff80008005b5b0 x28: 0000000000100cc0 x27: 00000000ffffffff
[    0.113030] x26: 0000000000000000 x25: 0000000000000001 x24: 0000000000000000
[    0.113312] x23: 0000000000100cc0 x22: ffff0000c2825cc8 x21: 0000000000000000
[    0.113599] x20: fffffdffc30cd700 x19: 0000000000000000 x18: 00000000ffffffff
[    0.113885] x17: 2e33352820736b63 x16: 6f6c62206c616369 x15: ffff80008005b4d0
[    0.114167] x14: 0000000000000000 x13: ffff0000c34a225f x12: 0000000000000000
[    0.114451] x11: 0000000000000000 x10: 000000000000003a x9 : ffffce3993f54940
[    0.114759] x8 : 0000000000000000 x7 : ffff00017f3fc910 x6 : 05ffff0000000001
[    0.115040] x5 : ffff0000c150b000 x4 : ffff80008005b610 x3 : 0000000000100cc0
[    0.115312] x2 : 0000000000000003 x1 : 0000000000000000 x0 : 0000000000000000
[    0.115587] Call trace:
[    0.115686]  __filemap_add_folio+0x5dc/0x680 (P)
[    0.115871]  filemap_add_folio+0xec/0x2d0
[    0.116031]  do_read_cache_folio+0x144/0x2d8
[    0.116194]  read_cache_folio+0x1c/0x30
[    0.116344]  read_part_sector+0x4c/0xf0
[    0.116499]  read_lba+0xb0/0x1a0
[    0.116627]  efi_partition+0xa8/0x740
[    0.116769]  bdev_disk_changed+0x238/0x620
[    0.116939]  blkdev_get_whole+0xac/0x100
[    0.117090]  bdev_open+0x280/0x3c0
[    0.117221]  bdev_file_open_by_dev+0xe4/0x158
[    0.117394]  disk_scan_partitions+0x70/0x160
[    0.117565]  add_disk_fwnode+0x1a4/0x1d0
[    0.117725]  device_add_disk+0x1c/0x30
[    0.117869]  virtblk_probe+0x6a0/0x918
[    0.118025]  virtio_dev_probe+0x1c8/0x310
[    0.118184]  really_probe+0xc4/0x2b0
[    0.118330]  __driver_probe_device+0x88/0x170
[    0.118497]  driver_probe_device+0x44/0x178
[    0.118669]  __driver_attach+0x98/0x1b8
[    0.118819]  bus_for_each_dev+0x84/0xf0
[    0.118979]  driver_attach+0x2c/0x40
[    0.119123]  bus_add_driver+0xec/0x218
[    0.119269]  driver_register+0x64/0x138
[    0.119419]  __register_virtio_driver+0x2c/0x50
[    0.119598]  virtio_blk_init+0x74/0xd0
[    0.119757]  do_one_initcall+0x60/0x3f0
[    0.119903]  kernel_init_freeable+0x1f4/0x540
[    0.120075]  kernel_init+0x2c/0x1f8
[    0.120218]  ret_from_fork+0x10/0x20
[    0.120357] Code: 9401562d d4210000 f9400ec0 b5ffdd20 (d4210000)
[    0.120592] ---[ end trace 0000000000000000 ]---

