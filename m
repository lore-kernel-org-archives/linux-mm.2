Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD6D5CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2410E6B0010; Thu,  4 Sep 2025 08:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218506B0011; Thu,  4 Sep 2025 08:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E5A6B0012; Thu,  4 Sep 2025 08:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF1CD6B0010
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:03:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 92C5C56338
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:03:56 +0000 (UTC)
X-FDA: 83851434072.24.0ABF250
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf19.hostedemail.com (Postfix) with ESMTP id E830F1A0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:03:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=e8qt5Hgq;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf19.hostedemail.com: domain of haiyuewa@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=haiyuewa@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756987434; a=rsa-sha256;
	cv=none;
	b=2SfFL6VCbiFY0RPzP4UIdbtsw9v8CCoVvr2mOvEdXTD+vjkPPR/2UPlQ9LHL7QvukDAnmK
	dGnWcnbOyv1/2Chym45OdETm6PvLzbz7/rpXqFU6tuLkq+4ziE3UPXGIf3xkDKMvnvyjfI
	09CHkfSAPlOGecbQ4YDbfbRjMl3PDik=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=e8qt5Hgq;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf19.hostedemail.com: domain of haiyuewa@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=haiyuewa@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756987434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IJYiXUgYfec7n2c5/2xp13tDlxmBs6mrIZwN/MTkTps=;
	b=4/wLE4OBaY0DPCyufJAuT1IIgZSNRFs3rN24nul9NPqLTPEWVXNDGQ2Uf6zthKNC6Aimxc
	NYJlJGAz0eWWVEShNMg9/B/NEgxI95re0J8A70faxkRXE/Ng7vqbr/P+3XB2WfSaacZGtx
	z88JTwOEi8gXoePq0nrmFBjWBLrgYjc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=IJ
	YiXUgYfec7n2c5/2xp13tDlxmBs6mrIZwN/MTkTps=; b=e8qt5HgqJQXeGesonp
	OQ/ghJaF4NC8LkBonNk1qKIGXjG73dG9YkVETF2tE5YVy4EIr2zQlj3AEdf7SQVk
	Cmsia3nrt88eFfZo1Blw4oqC+z5rXi4bnbMn6VMw61s3/COE6H/ckgOXlO7gCNlx
	JH1TbMzGGv5jL+VoReQxCyKNg=
Received: from haiyue-pc.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAn1CkigLloi3ngBg--.1994S2;
	Thu, 04 Sep 2025 20:03:48 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Haiyue Wang <haiyuewa@163.com>,
	David Hildenbrand <david@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	virtualization@lists.linux.dev (open list:VIRTIO FILE SYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] fuse: virtio_fs: fix page fault for DAX page address
Date: Thu,  4 Sep 2025 20:01:19 +0800
Message-ID: <20250904120339.972-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgAn1CkigLloi3ngBg--.1994S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtF18JF4rtryxCrWkGF4rKrg_yoW7WF47pF
	yUtr1UGr4kXr1UJF10vr18Xr13trsrAF18XrWxAr1kZF1UW3WDJr1ktrWUtr4UXryjqrW7
	trs8Gw1xtryDKaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zEiiSDUUUUU=
X-Originating-IP: [114.84.56.142]
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiYAS+a2i5fI1csAAAs9
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E830F1A0002
X-Stat-Signature: 5ke6z5c5bszz1yymdzi7c16dhsa7i96e
X-HE-Tag: 1756987433-994850
X-HE-Meta: U2FsdGVkX1+WEepTaCxNQnwNTpUF4cM42Dw1HKotnsYxFBXUAEQH7W2XLla2KpqUnIRPb9xtxpUus/0Vqaf01X/og7ysyZU1X1H50NxshSXBLmU50VVzFmdCwC1h5R8Rb2cTvDduQlcGH0QSMyZ2kIY4hIkUgF+4Ha8/ruRdm411zmIvyq1qaTCTq8rwZP9fNGh0f0tY4wpXjugM/BFWXLtud0Gp92q/CunBmkYouV7vzguGyFjy0wQ3Nae78nmjxDeMgHNgtgdQTLFo3CsA8bIQwx9AOFTWRFfqZHL8zIl52AqfIx5kDmw9mVpDYSg+P6AoklBXxZk4cM84bqe395sxG791GToNjsR0I2tn2lZ8+xjtlj9jwgwcw8c5TckFQa12cdQyYlcasiV3mn5sSy6Aji+ula07NisEYiQ8fkXKuW7teeioAlqyvefdv6lVVw91NCGKehde5IxId05cnrzDiZooBBhXz6+YW3G9C1saDGAkrLlMpfan0rMUzHCZmx0eYyGNZmqry9EF/JuY8fo5F+zM3MOrZH0gdf6xZpVfDhRO2unMgSt4vsL7qGxQX9lVceEDvljSewxJrHqLPdGwPZQGK4yOh2hWWutSdkZRRu5rxK/J6QLuDe+pcOtkQzH4dGUZunHVlH3xcev5WDVmdK9Bco9HCBFUG5Fu3dBe0226jhecF1pFh2gNx/Jj/jgGhsXBnRVpT4afmRXhixCSmXUvjPm81GUd5f3QnjEvZKbZYCjoGpqqSRbv24NgT7Pr9eaE969pVm4o0zzNbQjV5U2Gz5tj1FSCa13b/Oh3ndYmzC3AvXrE3fxeHjfPdjhCS7vBPF/h0kNj5TT/M57Vr/ueBgZkdoG6SCPy7fJiMVYDWTILj7FJxQExwKoub+J1viPch0apY/dRbWvc22/wXPJimS4MLb5Wt2lnf+zE75hVA885HtILV2Q4KIXqwvut1NUqHhgIs4ECfNp
 A4C5s/M4
 qyNgt1E2IhZ4EDw+XUpf1S3hduh+49h3F/V/1t1IzrLCBz5BpzugFuEL0pVe8R1NHsx2MCdHebd/rPV+TmFmRbSNXnVWOHZ6rAalJmPpSsSb8d4zVMP6fIM97q8a6z7/hvBA6nliCoqXkb4h2gS65uNoH/df43yYBQEd59jKwoVIhNYlKKhRCakCivkkXQvzy+f2Z7DWmoYKPoRYpTM5ZGPpjiUxqpCe0DEOFSTelbmBaPQsRv5FpkiXpqc09ayqXhGdfRmGEJ0ODtNVGtGyTjWfEWFmXkAfCmOf+TxQA2un7xx+Y67Po07qSltP7WX0JelfmGcoJTjJL4P/psJoeDcoqVQj66grjcgwTPBQ4Qc8NOVGTReA5+Fo4IWvpk1nNbc4EZThekItvPlwVLFGVfeolRxJISlnRlGa6lVQKL23KKjEsAt8gCIE/0COjmmSWenYAzA1pxH/U9Qk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The commit ced17ee32a99 ("Revert "virtio: reject shm region if length is zero"")
exposes the following DAX page fault bug (this fix the failure that getting shm
region alway returns false because of zero length):

The commit 21aa65bf82a7 ("mm: remove callers of pfn_t functionality") handles
the DAX physical page address incorrectly: the removed macro 'phys_to_pfn_t()'
should be replaced with 'PHYS_PFN()'.

[    1.390321] BUG: unable to handle page fault for address: ffffd3fb40000008
[    1.390875] #PF: supervisor read access in kernel mode
[    1.391257] #PF: error_code(0x0000) - not-present page
[    1.391509] PGD 0 P4D 0
[    1.391626] Oops: Oops: 0000 [#1] SMP NOPTI
[    1.391806] CPU: 6 UID: 1000 PID: 162 Comm: weston Not tainted 6.17.0-rc3-WSL2-STABLE #2 PREEMPT(none)
[    1.392361] RIP: 0010:dax_to_folio+0x14/0x60
[    1.392653] Code: 52 c9 c3 00 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 48 c1 ef 05 48 c1 e7 06 48 03 3d 34 b5 31 01 <48> 8b 57 08 48 89 f8 f6 c2 01 75 2b 66 90 c3 cc cc cc cc f7 c7 ff
[    1.393727] RSP: 0000:ffffaf7d04407aa8 EFLAGS: 00010086
[    1.394003] RAX: 000000a000000000 RBX: ffffaf7d04407bb0 RCX: 0000000000000000
[    1.394524] RDX: ffffd17b40000008 RSI: 0000000000000083 RDI: ffffd3fb40000000
[    1.394967] RBP: 0000000000000011 R08: 000000a000000000 R09: 0000000000000000
[    1.395400] R10: 0000000000001000 R11: ffffaf7d04407c10 R12: 0000000000000000
[    1.395806] R13: ffffa020557be9c0 R14: 0000014000000001 R15: 0000725970e94000
[    1.396268] FS:  000072596d6d2ec0(0000) GS:ffffa0222dc59000(0000) knlGS:0000000000000000
[    1.396715] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.397100] CR2: ffffd3fb40000008 CR3: 000000011579c005 CR4: 0000000000372ef0
[    1.397518] Call Trace:
[    1.397663]  <TASK>
[    1.397900]  dax_insert_entry+0x13b/0x390
[    1.398179]  dax_fault_iter+0x2a5/0x6c0
[    1.398443]  dax_iomap_pte_fault+0x193/0x3c0
[    1.398750]  __fuse_dax_fault+0x8b/0x270
[    1.398997]  ? vm_mmap_pgoff+0x161/0x210
[    1.399175]  __do_fault+0x30/0x180
[    1.399360]  do_fault+0xc4/0x550
[    1.399547]  __handle_mm_fault+0x8e3/0xf50
[    1.399731]  ? do_syscall_64+0x72/0x1e0
[    1.399958]  handle_mm_fault+0x192/0x2f0
[    1.400204]  do_user_addr_fault+0x20e/0x700
[    1.400418]  exc_page_fault+0x66/0x150
[    1.400602]  asm_exc_page_fault+0x26/0x30
[    1.400831] RIP: 0033:0x72596d1bf703
[    1.401076] Code: 31 f6 45 31 e4 48 8d 15 b3 73 00 00 e8 06 03 00 00 8b 83 68 01 00 00 e9 8e fa ff ff 0f 1f 00 48 8b 44 24 08 4c 89 ee 48 89 df <c7> 00 21 43 34 12 e8 72 09 00 00 e9 6a fa ff ff 0f 1f 44 00 00 e8
[    1.402172] RSP: 002b:00007ffc350f6dc0 EFLAGS: 00010202
[    1.402488] RAX: 0000725970e94000 RBX: 00005b7c642c2560 RCX: 0000725970d359a7
[    1.402898] RDX: 0000000000000003 RSI: 00007ffc350f6dc0 RDI: 00005b7c642c2560
[    1.403284] RBP: 00007ffc350f6e90 R08: 000000000000000d R09: 0000000000000000
[    1.403634] R10: 00007ffc350f6dd8 R11: 0000000000000246 R12: 0000000000000001
[    1.404078] R13: 00007ffc350f6dc0 R14: 0000725970e29ce0 R15: 0000000000000003
[    1.404450]  </TASK>
[    1.404570] Modules linked in:
[    1.404821] CR2: ffffd3fb40000008
[    1.405029] ---[ end trace 0000000000000000 ]---
[    1.405323] RIP: 0010:dax_to_folio+0x14/0x60
[    1.405556] Code: 52 c9 c3 00 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 48 c1 ef 05 48 c1 e7 06 48 03 3d 34 b5 31 01 <48> 8b 57 08 48 89 f8 f6 c2 01 75 2b 66 90 c3 cc cc cc cc f7 c7 ff
[    1.406639] RSP: 0000:ffffaf7d04407aa8 EFLAGS: 00010086
[    1.406910] RAX: 000000a000000000 RBX: ffffaf7d04407bb0 RCX: 0000000000000000
[    1.407379] RDX: ffffd17b40000008 RSI: 0000000000000083 RDI: ffffd3fb40000000
[    1.407800] RBP: 0000000000000011 R08: 000000a000000000 R09: 0000000000000000
[    1.408246] R10: 0000000000001000 R11: ffffaf7d04407c10 R12: 0000000000000000
[    1.408666] R13: ffffa020557be9c0 R14: 0000014000000001 R15: 0000725970e94000
[    1.409170] FS:  000072596d6d2ec0(0000) GS:ffffa0222dc59000(0000) knlGS:0000000000000000
[    1.409608] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.409977] CR2: ffffd3fb40000008 CR3: 000000011579c005 CR4: 0000000000372ef0
[    1.410437] Kernel panic - not syncing: Fatal exception
[    1.410857] Kernel Offset: 0xc000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Fixes: 21aa65bf82a7 ("mm: remove callers of pfn_t functionality")
Signed-off-by: Haiyue Wang <haiyuewa@163.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
v2:
  - Add 'fuse' prefix as git commit title.
  - Add more message about how the bug be exposed.
v1: https://lore.kernel.org/linux-mm/20250828061023.877-1-haiyuewa@163.com/
---
 fs/fuse/virtio_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index c826e7ca49f5..76c8fd0bfc75 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1016,7 +1016,7 @@ static long virtio_fs_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	if (kaddr)
 		*kaddr = fs->window_kaddr + offset;
 	if (pfn)
-		*pfn = fs->window_phys_addr + offset;
+		*pfn = PHYS_PFN(fs->window_phys_addr + offset);
 	return nr_pages > max_nr_pages ? max_nr_pages : nr_pages;
 }
 
-- 
2.51.0


