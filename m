Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD46BEF584C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 12:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8567A6B0005; Sun, 15 Feb 2026 07:41:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D9D6B0088; Sun, 15 Feb 2026 07:41:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F956B008A; Sun, 15 Feb 2026 07:41:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8686B0005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 07:41:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AFCC01CC7E
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 12:41:20 +0000 (UTC)
X-FDA: 84446651520.08.11706C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D3CB81C0007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 12:41:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b+ZIlK0o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771159279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rU3sUoREpCwdBbFBgEy+fnaW70xKpuFWQQuzqvPyNkI=;
	b=DUrbZP06bSlxtxFApyn2QttpXLNVtOGVvUoD5BQi9GVvjdPUaF5PQKVH6QrywWOZW6SmeW
	R55iI0mVtcYHCG8/ylQBtraC7apK27z4LngKf3vWQ/aFNbcZXckchEBt84Tg7fvou44ebf
	HPljhRcLtgroymSede+PeqZqQaZZyaY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771159279; a=rsa-sha256;
	cv=none;
	b=6EsUHeJ+G1dknCdWxJo+cz0PN7HeI0LilobHvv1M/ROfR1JDjSgibocnzg/qDBCO45jbv1
	fnWVRu4DSdFf0yJkf3/xoECzF+uVNKe9ZZ1eDbbaBgf7b//2d/EmaFqX9kYpviKdqgQg1G
	2sckXdlidd88MMM5PRCJYyuhNIJHgYo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b+ZIlK0o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBBC942E28;
	Sun, 15 Feb 2026 12:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B66C4CEF7;
	Sun, 15 Feb 2026 12:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771159277;
	bh=rIfp0fcYCQYR9C/yfgeTqfJfMQN9HQIMG8/4+7V8kwM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b+ZIlK0okrsv6RLyo4uvDRQGNrt7EmSId8eFDX8Z1Lv24sFO4IGLmruZ1CiS58EV8
	 8Kdf66G5Q2/rY9D0mqG3aF4UjRZV7JpSl4A0jcOjJsZMHmZwCHPsN3Cyn5YCQRgSkx
	 V6dlNG65Gd8fj/vcCwEBrdcGsyqDnZ4070E75eqYQNEtEYwm915JF1SBu+YeDjeJED
	 +1FIFwMt0An2h/raGgzU4dQfB0tCaoO7cOtVNN6rsiG6azplH14Emt5aPTLPgoVMrD
	 w7luaPgliHgkXViwpIc44DFJuxecnTbdgf5G6rJdp7RePQEXrMrQ95P3ftGh2Md6uE
	 2bt9eob2dYZJQ==
Message-ID: <3ca2c5a7-66d4-42df-9f88-c2b6eaa0ecb1@kernel.org>
Date: Sun, 15 Feb 2026 13:41:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: thp: deny THP for files on anonymous inodes
To: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, i@maskray.me,
 shy828301@gmail.com, ackerleytng@google.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20260214001535.435626-1-kartikey406@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260214001535.435626-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D3CB81C0007
X-Stat-Signature: hm8cp6dpwnqptkksyh34xeysbiartqrt
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771159278-204118
X-HE-Meta: U2FsdGVkX19P/1E4HtsXzmr8fc+eJld168DmMp//tf5obmR1wlVy9fC3sSu7ZxmANwCmDSGZGVaXVQ+c6kHDAtnZk8qyzKa6OtQrN4elwGZVtsACnlcTdeDe5n8ioeepMZFqSyURB9imuLoHlbmIbJrko8mCPHqI/u2bJRdIELjoNK6LdLB4mHWXHyLP/9rE9ynDXtAp6ii/O/T2AnkmVWEw67kpb9C+2/k+JnSgJq501R+doxm05ZGtDs2oCfayOm19v2XmMV1m5k1Li6KA+ujXjscDBeL4iKIQ0YPbidwpRSay7wGmR/Fnf3XCQ9qpnpG4XQQIHmlWHJeud9FmUNfppZjcIPHX0NZklo6G5Hp+VByeAWjJ4JBgtcHL31LdFgxIc/Dy7sQTZoQT2+vTGUTQV6errNDm8L9YvswzNDJ2e0rkOHVo217OwBWje3O/LL3FFfov6JkKW9tfK1GMUz4CBth5LkV2NaI9Ow9J9laCK6RVyaVXWjQa0EpC0L1rCQdZ9ydfMp/D/dnH2UOroS/Y5WH3DqYdQi190Z9Op6edcZgnp6N0uDbc914bZrvQjOFqW//6PhWM4ybenaV8QV9Uxn8zjiAcab4DXhHUk8O+rdzjLZazXMWWmrzPFcqmT3H1WVBV28ep3BM4PjjXoE5BQZs/g0nSbM4CrQFa+J2Yqs4ZkQ9WjfeT09F3nXR0RcuwfwjxjmNblw9Wi3IAXRp2MgcyE5UtW8XjJ9L0jKdgojnt6egvFVJrW2ogr2zM71EaCr6SlD+WaLvt7xUED1NQmzbTpq5/q6kOgzGJ8edJrnqKM6NBq7GcJlWnO9hj1v6FJVibhqQyCxyJhHSCATrWWAVeTF2o3WKKVfS3mI6zEHDzvld8RhKlKpU7eQTh9Dwy8ZbK0TloM1vxnV70LSipdNXb5x/pUj504VWTqkV6snP3pEMvWU7bUa8IoFS1HZjOUrZ8JfpGQ/MOdKy
 5BwhjFpX
 iZLytbMj97Xgfv6VxJqqKsJn8ZzVEl8XjeWmPKfFrctwUVClui8s07MRdxuPljsg1yKSrsbx/SqIIPfKYWo8WX+PHsv8egL0LiA6FGegKSceJB5Kb40NNbMHS9zf9pFNxzKJJ6lTjoL4pcV1z6baghM6Gti7JdEDMm5+7P5k8K8Ctlgped3Psd175ZjCGxwUacXFqWSoI84KcQGkB9bBjYDjxzF7Azbdek1pzJbpjc6LzjkBp1zL5bz/eGXnbx2YRAJdgnuzgKWkDoXy5eBErvmqhWCYTgzHM3ek+e2AgITFJYAtvE33PpzGpmxMOG+hytvWOV3L+HxBDX3v50JfGPlijoOd8DSw23GOC/BDupY62xkWQaemnUPjV67yHsrpjc4WDQXKtLzUo++rqXfbUJfdlDiTSFf0RZET4BmMRLS7vrQX0PaZdj+Zv4VHn+uxFwKOwlblE61x989XL+T1/xVNk2PfHgq2yMFdVUYKXEH/GrbhEJSwE6VzHpw2q9L31Nb9Pt17VkdJ5TMQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/14/26 01:15, Deepanshu Kartikey wrote:
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

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

