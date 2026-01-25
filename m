Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A80E4E63C8E
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 12:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F606B0005; Sun, 25 Jan 2026 07:10:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CDD36B0088; Sun, 25 Jan 2026 07:10:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1126B0089; Sun, 25 Jan 2026 07:10:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DEFB66B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 07:10:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DAD91B0493
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:10:24 +0000 (UTC)
X-FDA: 84370368768.07.EF752D4
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf23.hostedemail.com (Postfix) with ESMTP id 78D05140014
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:10:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ipdmt3Fx;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769343023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdh1TAQMYWo4B4FTcZIJrahTI6XAf3PsxQELr4l8rg4=;
	b=bdlNfKTFobLSfxGVOv5VlF0HkWQ2tlP1fJ9mWgbXCl+t41+8Ke6ukKnocl8ivE23HBZNkv
	XPdwrPh/UPWYxNbGbmlRE9Ngb+tu0VPKYhxeuj2zgePPGZ9KPjeN5DXiIqWWeoDCJL0Qzp
	kt+ThL+MeBMyej+hO8uKwtxF4h/H5Uc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ipdmt3Fx;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769343023; a=rsa-sha256;
	cv=none;
	b=sjh7mSc0CFcjLY7++sFVD9fEneVKolvuwGm/fn+f/xfs5L4ppNf4faOHGG7stKds5OgWGO
	dxF8q1x7V1EzYWa7R1vnhuSfa0eTP2otyL1GPH7qqgp55m2gcJ1RmPmcgDp6lsAgpqOdeM
	5UkWGBxahBH1hxNPk0AWg6h/XtYLQnQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769343019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pdh1TAQMYWo4B4FTcZIJrahTI6XAf3PsxQELr4l8rg4=;
	b=Ipdmt3FxTs1DByvHiuNGivi3qJdRmZwgEJNN20DVHX/uBDjlXfvfEptoPpmxt5iHGHQVuh
	e/yYIHuYgjfb6EkH4aJaE3eeWZlQQ4e/vfN/FYjCQo44s7htzyKoY/YqZWqvXga55bGhPJ
	fG1SQ94+igE8o8C1307HRXGOmAS/ysY=
From: Lance Yang <lance.yang@linux.dev>
To: willy@infradead.org
Cc: syzbot+bf6e6a6ca143afea5ca2@syzkaller.appspotmail.com,
	Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	syzkaller-bugs@googlegroups.com,
	ziy@nvidia.com
Subject: Re: [syzbot] [mm?] kernel BUG in hpage_collapse_scan_file (2)
Date: Sun, 25 Jan 2026 20:10:01 +0800
Message-ID: <20260125121001.32733-1-lance.yang@linux.dev>
In-Reply-To: <69757ea0.a00a0220.33ccc7.0017.GAE@google.com>
References: <69757ea0.a00a0220.33ccc7.0017.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: up6bmx1fart9fd9r9e5bqxucrykbzgik
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 78D05140014
X-HE-Tag: 1769343022-473562
X-HE-Meta: U2FsdGVkX1/yTy1w5XSTnUlR7nHdAK8eHo0BNir3mJIjXc8RPOXAC8JsSv9Lp766XviPCBQLpbRC/SNcSPvpogdKElnNumOB9ot8mqv+9+GKjOg75OS8VIFh3NjtWy9AIv29B4C50m4Lp/JycGA2e9xpHvQxp5Qo7aF6GePYn+sMTwQ5e9FntavNnG5tD1jxCp+Lh5U2kG5zhrtunkYuQf+l54XozDCX/cWGvmu2WhAX+9Qge+seiaiFN3L7FLR1RskyUmQE9ZphzqjZxEm80ozUj3YVdjux/LNh7xMZbZMOSAG1VxDs4rKWMk3YI5k4wVghYIF2Z1j80z8hohEgkcNIRH9rntb0hJTQryltmIoN3fk3qDIbq6BVw0otItIGXoXeAyqcZR7idz8CPqF9mmrTfp3IFW6PgmaCWJKLjkquBRyP6psPNP1DZ0wE1H8dHvGBGlwFVtRuOTngwAVpX1ZeiUh0x6VKVodkZ9zrBFJVPKSiFapDwKfSiedP6Y93rSG1rZhJmt3Hh6NclE0H/YjrDoZcNt4BsqBhiYi3cuggNUCTUcQvJHbC9He353PFBl59IHhFtkakUvAqLNAfMIftfld1pAh3Z4VG3QkGpopUc9fOGDKgPes3rhmvujERpRQxYYTzJ/Az1P4vUKQFlJYkjrnZzgwdlAqZEO0dfO9cG0W2CRXxFuIIsCrxdGPooWZ+L1A1kHFZIaPoVQn0KT9En0X8gOnMYCXuH+Ji8Lwoj5YXoNAgDKeMycYGWqk9qjHWHyclFK85M0SqkkJA37W/gsOUcfoKnM+A2ZVq5zJ12KYAuC+lGhJnTLKnMMqIaQ08gyVqfRmoEfJz5cHHoHOu3wM+x4ltKvNHiUulEWYtqF443O81UMRcaEHPF6vm/EogHCd1wZwasDECCtoWwl29S1UH/n9r3B+VZV607cVGP6ZtTevpP3cK7Ka9mpGQ/llQFzXH9TJOliYl1+1
 hYcSf1Ch
 1juBx1Wie0Wux1BxJTGfwkSJWU4jyCIbLiuftb+rqYjPS1rPsdwywvwjLAvPHbSG6GL2u7LTOMH3DnSt/aPJRYJitNvHmeCoMOd0m6Sc10S9QPOqI8HK9jjuR5vdp37EYLjZR1PK3w/JYHk87QtRSfc0OMqWKBdSpE0JDeWtT5bY0C+0ND6cAOWyjc1VcEYnzMsY22GpUqhExeMELd7OB99xk1LS1Ja0ckA1rom8+B7w0itpVTS9jNhX82HFo338LO/LZe6PQBET5mUt5/3KYqGDmMIT0cn3Bhcvsog0WMSJ2PPx2D3nYMMXuY5jr9vS4TThcMh3l8E+HSUVoKYT6pukMIust4+PJyQvYe/hwQCGqL1eAwBu1Tsp8ez4YqpdMMJY5WdzDkfCflhlojAXU7F+/Er7N5hf3oXKC3kCt2Huiz1JQ+PDp8Ko9QJTZcU9kc4pWXudJBeXgvW+zGPmVGsN0w6mIOfVORsl/qij1q81hqBIvYjW/0PtEVU0K1wBplozmRl9o0YWTv9IB3LCk9dCKVIZa0T3hMveHfYF7nEdF1XljHl5toHjjTQ9xtTuo1FT/BRrPKAmXUq0ygd03h/xO8yT8Vfn+lSHsg6cenFH4YhGPtzq4MOq8hQ9/abnDkNY09zp5tRa0+3TS+shgl6UtAQhLH0/Z61ln1AnDeNf2ViWLr9namfr+D48CExyMdYMydaK/WuJ4Dk0OZJDPnutzIK4WNGRsCUsuRTGQ9jMXqg9ad5Hjv+cEYL0gkSkodQ8VB1Yfb/DMqDBHeS5wxVufFy41j3DZLrQnbOfsiR8OWwm9NidyHUMM9gWVrV6A8aVIxj3XAlV4vCiAql1iODm93kXW10Vv13ifbDNk2maVTp9Ivg2HwEaAnFZ08JhCOzfpHxvOU4DoDoCTpSjel9hd9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ccing Willy.

On Sat, 24 Jan 2026 18:23:28 -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ca3a02fda4da Add linux-next specific files for 20260123
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10c42452580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=10f2b64f8f12b9a4
> dashboard link: https://syzkaller.appspot.com/bug?extid=bf6e6a6ca143afea5ca2
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f7cbfa580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112d405a580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/291ebca63a31/disk-ca3a02fd.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b2112a214b54/vmlinux-ca3a02fd.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/77d1ae437e07/bzImage-ca3a02fd.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bf6e6a6ca143afea5ca2@syzkaller.appspotmail.com
> 
> node ffff888148816ec0 offset 0 parent ffff888148817700 shift 0 count 64 values 0 array ffff88807be6b0f0 list ffff888148816ed8 ffff888148816ed8 marks 0 0 0
> ------------[ cut here ]------------
> kernel BUG at ./include/linux/xarray.h:1441!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 6017 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/13/2026
> RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]

Seems like that is:

```
static inline struct xa_state *XAS_INVALID(struct xa_state *xas)
{
	XA_NODE_BUG_ON(xas->xa_node, xas_valid(xas));
	return xas;
}
```

Which was added by commit 43b00759f21b (not land upstream yet):

```
commit 43b00759f21b10142094d1ae5ff65cbb368953a3
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Sun Dec 14 10:53:31 2025 -0500

    XArray: Add extra debugging check to xas_lock and friends

    While tracking down a recent bug, we discovered somewhere that had
    forgotten to call xas_reset() before calling xas_lock().  Add a debug
    check to be sure that doesn't happen in future and fix all the places in
    the test suite which were carelessly doing just this.

    Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
```

which catches places that forget to reset xas before locking.

> RIP: 0010:collapse_file mm/khugepaged.c:2041 [inline]

Yeah, maybe it caught a bug in collapse_file() ...

When we lock again with xas_lock_irq(), xas->xa_node is still pointing
at a node from the earlier xas_load(), so the BUG_ON fires, IIUC.

Fix it by calling xas_set() before xas_lock_irq() to reset the state.
And one spot in rollback doesn't actually need xas at all, just changed
it to xa_lock_irq() directly.

---8<---
commit 2003255c52846ab10cad6c2e57cda4d17dddadbe
Author: Lance Yang <lance.yang@linux.dev>
Date:   Sun Jan 25 19:37:56 2026 +0800

    HACK

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fba6aea5bea6..3656ae491385 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2038,6 +2038,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			try_to_unmap(folio,
 					TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);

+		xas_set(&xas, index);
 		xas_lock_irq(&xas);

 		VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);
@@ -2140,9 +2141,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		int nr_none_check = 0;

 		i_mmap_lock_read(mapping);
-		xas_lock_irq(&xas);
-
 		xas_set(&xas, start);
+		xas_lock_irq(&xas);
 		for (index = start; index < end; index++) {
 			if (!xas_next(&xas)) {
 				xas_store(&xas, XA_RETRY_ENTRY);
@@ -2192,6 +2192,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto rollback;
 		}
 	} else {
+		xas_set(&xas, start);
 		xas_lock_irq(&xas);
 	}

@@ -2250,9 +2251,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 rollback:
 	/* Something went wrong: roll back page cache changes */
 	if (nr_none) {
-		xas_lock_irq(&xas);
+		xa_lock_irq(&mapping->i_pages);
 		mapping->nrpages -= nr_none;
-		xas_unlock_irq(&xas);
+		xa_unlock_irq(&mapping->i_pages);
 		shmem_uncharge(mapping->host, nr_none);
 	}
---

Tested with the syzbot reproducer[1], no more crashes :)

[1] https://syzkaller.appspot.com/x/repro.c?x=112d405a580000

Cheers,
Lance

[...]

