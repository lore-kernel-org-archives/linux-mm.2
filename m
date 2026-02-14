Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA356EF48C4
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 11:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A0A26B0005; Sat, 14 Feb 2026 06:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423C46B0088; Sat, 14 Feb 2026 06:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BA76B008A; Sat, 14 Feb 2026 06:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0996B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 06:27:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E7B251A087B
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 11:27:54 +0000 (UTC)
X-FDA: 84442837668.03.FF32D76
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf05.hostedemail.com (Postfix) with ESMTP id 41DB7100003
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 11:27:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tk9n+s8Y;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771068473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpYezoVv7JEZ5/A/iares9/UqeOLdNYr44Ew2wojbn4=;
	b=mOiHw9Wu7gxi05/kevzzYPaciYItJCAEaonIXpxKu23t9igkpP8C7OtBdqgNDwEhNu6IIz
	3NhilHTloqWldrcz1p9F4IPWLNoPUIfa0LcED6JfZC/hZTdfJTK8bfyEXwneWN1LMJ5Da2
	gPII21e/nLXrFgXow/3mJwYAYi15f6g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tk9n+s8Y;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771068473; a=rsa-sha256;
	cv=none;
	b=USdh58sIOvIKkpGDUGzGqusj8qXJ1GZvAJni69TLhaIUUht1uE6FctpTl4wUrW5av68q3W
	mFx6Ticxc5/ARVKT3Vbl6hnCbAVh++Mi7kB0F4Pm3yHgMioCNa1HixDs5/8T0DMYAlHKwg
	jbbs+LPDFsGey3cDZcfb2ANhmFBvgN8=
Message-ID: <b398d163-7b58-402b-a37d-9562d658a62d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771068470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fpYezoVv7JEZ5/A/iares9/UqeOLdNYr44Ew2wojbn4=;
	b=Tk9n+s8YHiNSW3Ydfv5tEgx2GFe+9h/u1Mml7AZX78lUW2mQMjwgfWAy9do87rOWaqTeQB
	kGOSkvGGCCTTUw/dG0vNn1z/N4LSngM5+mytnSnCW364ddlLTuGyj+Ax3siRt3uDYmtCAf
	oByqFUDCSSnXhCuOlZhuu0qScHK/x/g=
Date: Sat, 14 Feb 2026 19:27:44 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: thp: deny THP for files on anonymous inodes
Content-Language: en-US
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 ackerleytng@google.com, linux-mm@kvack.org, npache@redhat.com,
 linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, ryan.roberts@arm.com,
 stable@vger.kernel.org, ziy@nvidia.com, dev.jain@arm.com, i@maskray.me,
 baohua@kernel.org, shy828301@gmail.com, akpm@linux-foundation.org,
 david@kernel.org
References: <20260214001535.435626-1-kartikey406@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260214001535.435626-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 41DB7100003
X-Stat-Signature: pf3u93zgd6hh1t5ow1c9x7rq7urayxyj
X-Rspam-User: 
X-HE-Tag: 1771068473-73740
X-HE-Meta: U2FsdGVkX18cjN/eD4rWXmVvQlsTwx4Ig0+91QK8+Wb88eOfUGfDnHhWCnM3FJ+BsYM8pxz4iS1PZbtpgVVBB6Ghr/u6QcqpK/tx/Ul2DFiJCVFb+rviieG94QL+hQ0brq6bQLwbfVJmQeBR4UKxPwKKpPRHr9a/Fbc82HKCfnIMyxHTMQ04sbs3S998yvoGCsy6qX5zBTs2ssx9+cakGOnEa66J2oE5cIY77Lk+VOgzFlPXZxWKB1aSiR98g5GywfaK8t0RsSPhiSGl4KXnNPGYOqIBGCKahPXX37yNnTCGaG95IV2YJngAJTAwDIAxX4nLcbx4qUZCle23QiaEsiu/KAgvZJNuh4EgGdTtHl0wN4Ahz5FTQXPxNKeUcxismXe1FkHahk0PnRZBmKjE0wFgUD6DIqaggMDqZ1AovGD8XbPABeSBFTYTn/PmvXRieE++g8MDqCoNLs8RSLcHCOOye2u6XYZH8q8FaJqb6gugERlX6VccsjRKxjlObwHYMdT8tnzWRCaSmsVLqJgVmozRZYjou4wyEjoMN8UMYtzZXTyO6AWaCZmRoAZiTvEK6qk6uwB/7MjrHPZ3Rr5CqHu7GJSPQMH5rCiLJ/66mOBV0WBc+hczz48S+ObjO4QwWoVtHO7IrE+Mcj2e/44/fAsOl5Z3rJ76aEQnTSYbR0zlVbZCldu1S2cPKN0BGF/2cofG64RV3FGUaol3V5ZuC4ZThQPNS96GDs5+7cL1w7O05MbZ2ClvfkwA48y4ucJbhUSg5i6OxGhrW3EbWARuB0NTeE2GXh/oYPoUUIfoIMNWEoJiqGpPNVy3mYjwC3k4/CKnQJ+Z9D+SbjX14S68LLlgMdXVVUa6+rypCNjSTIvuiW/wpULd1UQCyiE2G8g/ZPNgebyhBALSvG6RK+tgihG2X/4hcDeSaPH+SDywn2T2iORaddoZtQ0Hi1ADWwWMty8C9MaLT/7J7HP38Br
 RCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/14 08:15, Deepanshu Kartikey wrote:
> file_thp_enabled() incorrectly allows THP for files on anonymous inodes
> (e.g. guest_memfd and secretmem). These files are created via
> alloc_file_pseudo(), which does not call get_write_access() and leaves
> inode->i_writecount at 0. Combined with S_ISREG(inode->i_mode) being
> true, they appear as read-only regular files when
> CONFIG_READ_ONLY_THP_FOR_FS is enabled, making them eligible for THP
> collapse.
> 
> Anonymous inodes can never pass the inode_is_open_for_write() check
> since their i_writecount is never incremented through the normal VFS
> open path. The right thing to do is to exclude them from THP eligibility
> altogether, since CONFIG_READ_ONLY_THP_FOR_FS was designed for real
> filesystem files (e.g. shared libraries), not for pseudo-filesystem
> inodes.
> 
> For guest_memfd, this allows khugepaged and MADV_COLLAPSE to create
> large folios in the page cache via the collapse path, but the
> guest_memfd fault handler does not support large folios. This triggers
> WARN_ON_ONCE(folio_test_large(folio)) in kvm_gmem_fault_user_mapping().
> 
> For secretmem, collapse_file() tries to copy page contents through the
> direct map, but secretmem pages are removed from the direct map. This
> can result in a kernel crash:

Good catch, thanks!

For secretmem, file_thp_enabled() can incorrectly return true
(i_writecount=0, S_ISREG=1), so the mapping becomes eligible for file
THP collapse ...

However, if any folio is dirty, collapse bails out early with
SCAN_PAGE_DIRTY_OR_WRITEBACK, as secretmem doesn't support normal
writeback, IIUC.

> 
>      BUG: unable to handle page fault for address: ffff88810284d000
>      RIP: 0010:memcpy_orig+0x16/0x130
>      Call Trace:
>       collapse_file
>       hpage_collapse_scan_file
>       madvise_collapse
> 
> Secretmem is not affected by the crash on upstream as the memory failure
> recovery handles the failed copy gracefully, but it still triggers
> confusing false memory failure reports:
> 
>      Memory failure: 0x106d96f: recovery action for clean unevictable
>      LRU page: Recovered

Right. On my setup, that would hit SCAN_COPY_MC in 
hpage_collapse_scan_file()
rather than a hard crash.

> 
> Check IS_ANON_FILE(inode) in file_thp_enabled() to deny THP for all
> anonymous inode files.
> 
> Link: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
> Link: https://lore.kernel.org/linux-mm/CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com
> Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
> Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
> Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
> ---

Confirmed that file_thp_enabled() is working as expected now with this fix.

Tested-by: Lance Yang <lance.yang@linux.dev>


Cheers,
Lance

