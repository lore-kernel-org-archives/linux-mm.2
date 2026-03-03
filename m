Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B2EBEC1436
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 12:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFAFD6B019E; Tue,  3 Mar 2026 07:17:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2036B01A1; Tue,  3 Mar 2026 07:17:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4D86B01A3; Tue,  3 Mar 2026 07:17:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB2E56B019E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:17:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 645B4565FF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:17:32 +0000 (UTC)
X-FDA: 84504652344.20.1C54498
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E6FE80009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:17:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q54U6EtS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772540250;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gto/N++4SMjQV7/xwTCfye149xOkcfDi3+BPwgfpGt0=;
	b=zl87Ba8/JfwjzknbmfQ8a6ftHZ/Mvb6oAXYB9e9jJoSC6ToVQPCDsTMon6PxdGsJDlZKef
	vUv3FF/QSqI7zGUTh5kgWHzrDKGeOsw8RxXIklgCHLrWJPQ2oKktHizhHNVDg9/C47J6mc
	g/5fxzGCF2kdzvY4EkfMG93JAbPItAg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q54U6EtS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772540250; a=rsa-sha256;
	cv=none;
	b=I7XUoXDEPLyxVysq8lMhIb/ErQUeajCA+L/zWGsl3K0Vd2KKMI45vICQoTQYWlDGsbU+XY
	CsTvEF4+vlJpnbmUvvqEq1LSofmdjkQeSU4fsCcSAMH+Z0lNPKKkSUQksMiwdyDSqNh03g
	m94QdxN2cXDDqdZsR40+WXYPfCqD6Fk=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b8f92f3db6fso828019366b.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 04:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772540249; x=1773145049; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gto/N++4SMjQV7/xwTCfye149xOkcfDi3+BPwgfpGt0=;
        b=Q54U6EtSVNKSpOf/hQkuy6pllnpLlClMiVepULB0GCZJyOtFmMfYGeyApf+cSnO6CA
         vkOdlF59kXpxjop3PWSDokdwJ/kJi8Kr/F6Kd5ihPeCPYiwPwXwQB24qtWcNLhUbliMZ
         OdRej1Ywv6adNJUfJkuccA6o6lv/ich69dypfdQJ0W35SgZGEVuco2B3CE2HTMgKjjTp
         1jHw7GFl+JKyC01Kjvo2u+Jew1/6VASA3Tds6w+QmmMNTq6PyXY7Bswqa4OGcpG2Ysp/
         yyM237BcuChHZcD3VUkU2G8z/x/1gW+6tRmiK1VIvQx5NQd50Jb53Ame7hnR2Khwc6OC
         kiaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772540249; x=1773145049;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gto/N++4SMjQV7/xwTCfye149xOkcfDi3+BPwgfpGt0=;
        b=QnEwJ2LqyV9H3jqDR2A1GNSTsSqtew/YlZ1HxuxjBFAiEcGrex1HlBUKIOlIyZHHU1
         nr9Fhj2t6zdOW/rNxHdl0eKgw2EUmbSLURA8x3WgqU6tNup2cWaxZyX0grJFEsPGpn4w
         s4A5DzW59dWuqNgiYlhkEzT3QQhpmkOxjq/phQiqqDYN6T2zIQg1IHAi8sWgFV2oUqIr
         Xt5psaYamjLV98mZh+ZOr6Cl1V7RgF4gW+GLYlpaaW8KI8SrMdrmh0TtHnRTrB4H/X68
         yh3poHvrZlG5gDOThYFozJ0Rer0qnbZ4wmoHFLwjJ3q2sbgLEWCs/f2192z9DwwxkzBI
         XdXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXh9HhtrrA8XzuKP9dqn8ieLrrvC0qmPyuiMp2RrGzS1njbPs2cK+tCbTirFdzF4gZD4m6S6vqr0g==@kvack.org
X-Gm-Message-State: AOJu0Yx9s6uUHLTZdEALtRHoUhMzJRmMwBQL1rDW4TaXCQyGbeb4aWUV
	FUIy05YMs66XkgO6y1EB7u1I0feruj6TCOwBxbINqi2y1df3nlIAvlC9
X-Gm-Gg: ATEYQzyH6tUEfIUD/0tjfkw6s803PnBTU0as4YDip+Rmojq2XRu34/WVOomewwgkfI2
	qpuT9uH+hF44o8TFJ6U6BY5X6Wv8ubhPHlYjDRT7lUYolhIgv5pkuJE1/CjFeO3lSerAMRE/ScI
	kHzaLhpUVkHEKRsL4rXYyPFac65LclKwMfRNB9V43SLuMleAislD2+mpy65NEPaxPZWY5Mbbsns
	a7ZjlV+F3z/TrLCJmQNllqP/0ndml0+1Ua+2ynOdxT+3oYQ83YusADlJHtCGw6bfav1z0xYyWb6
	Z6eOex19I1dQBc9MySQuURgK+BUde3WgXt83VWW9Ek4mmMiMx71tPSytaOml3ueametm+rMRrh0
	f+ZhbtU5yObAbytNiRvEfgnCDFXyMlZOAzp4/jtY+dSvCuP8i9QIRicsJZssnaianpBbe1oPYRK
	mFlghC4xb4XW2CSYJKIECcsQ==
X-Received: by 2002:a17:906:f59a:b0:b87:6953:9d5e with SMTP id a640c23a62f3a-b93764f8694mr964218066b.33.1772540248466;
        Tue, 03 Mar 2026 04:17:28 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ae8fee1sm590757366b.45.2026.03.03.04.17.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Mar 2026 04:17:28 -0800 (PST)
Date: Tue, 3 Mar 2026 12:17:27 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	riel@surriel.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
	harry.yoo@oracle.com, jannh@google.com, baohua@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com,
	stable <stable@kernel.org>
Subject: Re: [PATCH v3] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
Message-ID: <20260303121727.ss3d3gbzituygb6p@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260303061528.2429162-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303061528.2429162-1-dev.jain@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5E6FE80009
X-Stat-Signature: zh31uakiq6g56zk8udf19gnhj8p8y9hx
X-Rspam-User: 
X-HE-Tag: 1772540250-924207
X-HE-Meta: U2FsdGVkX18ZWbhf8CcvuYqGUdkJUDBpgLweE19H5WLeM//npX3yekAxDcEjdZbqX8zOyq5Er+2INItqDYdyj0Ne9wJEd+B49/4oilf3Y9DmrD2EYhGHDp254GyGky6JIOFoi8uP2EBsUwxjbyEbgwFWFEIjG+U6F4nKQ+INreFgBTIbrxiN7u8mnwwJt/WUsxBXlyxo7OO+iqku4OLL3qYsBD+0vMbULKm/oixLT3/DX1zCepIxFI6F4hZaP1vWcHWeHAD6f+JziHZGvBwNRNZhlec2trLHV2p/wwLGqMUiXKQw6hCVjdAryOe06XUhGYdAaYi/v6iaS4NG5tCOcPzRfxszsxOr6AcZ/36H6b/iiA7szCEYwdq/+dMxRXnx75rDe14KjchvOM65v/P3g0NvjfmpiPt8R7bWMvlHokzHkpBPTo0+Svs6ct4kipHtxo08q5FNNehtERZwKCf0VYo+3pC3KzuvF1zqm/o23fhmmHKeJJe8rwaMVtSlBvNNdzq3Qi+WVT8t8Ap58OZRkXp9x/9B5h7+H0O0FL2I3SE98cJmnBGElk0tBMcf8xD+olY6pmZXmWTC4T+pESICJIaVeMWguo95s0cKoWdnoaXMEaTI6tZyIy6ARP37rQGvG4y1HbEsx+emcSr6Ltr4x3bUWUNkY5sUfQzgH41g2V6GraszSU1xsFNJf9LgHUaRcvLnXs5bqam0OlLS5oFnU06McgWp7T396GIJZr2Aj0vR20bi98ZsjdHNo+YcND9yagrlnlA1NKF+c8xZuxpPBQW7KODOpTIyB+vC2BL40N0Z0MLxAk9sovvkZNNaSGBus8rqI/t1L8WWCauUgI2Evrmn83CJWIhY35ztPmoAT5LtmaP0xxdNQmpFf6dYPeD8YyAuJfF2tiCaPRXoMV/8Htw/iewrbJKlpXv65QQQGqRxS557ZzOGt7KbxEcU7wIAzl8nWGXvTY6Frhnqovi
 6lQOQEFN
 s7+1BV1cwRybPP6j7/m0RUKFwJViWSWg4yTNzEglPTkOgU91Pj+00XtJbUsETcxH4dqoCkuitIVwnUkPPN0qaGkfwv0Aprd8cx/6/2+EN44jwVQtpt9MU/gxV6NRo3o+VFGmCE22goJ/AWb389mnC+DB8Xemx59NMZ6NqRh0sAphAZ7Evzx6v0N7kKJnVA3VNjfNj07Dc+1CQaDbuYO5AxB8uTfctWWlfsv1Hs091lDOTS/u4NvUeCeetwFautxpbjI85ChMF9D60nZPVegg4vmQpdzwCJs6Yylgq8TWlmzpZFR+syvX0jHWkpcPZ7+M9O0d9+VlbW1yQxRvh6i0Iic9Hli758rSbNEpAKy++GdqxNwWRQ86bKaZn7Xz7N9HcC6Iz1pGSD819DqDnOnyVlujQw846mgEk10PLn7ETSyNw8yN/KFf2XhVqmXq/HoRZCMoh+YF0mVWlQSeHM0J7BTdwPF2Gw0FlMcio0z5pqy/q7xpR56mNb6IHPrPwxr0dKsr0V1Q3UtJHivn8z5jIYFixqbnum/JWNFGj16kbSIEG9p6kRsE10GAHe5Wnct+3lbZYqZO0gGfEBLgp6DKa4x7KOTYvvOQ89FTN7jPkPECqCCV9pVTNOw8vvSacjQ4FfqZUPF31SohxQ6v4sKCgi8fBiXUa3I9WRW8gB/4C76lJvR7aw55J0utGV7wfqREyKdEp3x5SZy1TQaIiXFMofqJehA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:45:28AM +0530, Dev Jain wrote:
>We batch unmap anonymous lazyfree folios by folio_unmap_pte_batch.
>If the batch has a mix of writable and non-writable bits, we may end up
>setting the entire batch writable. Fix this by respecting writable bit
>during batching.
>Although on a successful unmap of a lazyfree folio, the soft-dirty bit is
>lost, preserve it on pte restoration by respecting the bit during batching,
>to make the fix consistent w.r.t both writable bit and soft-dirty bit.
>
>I was able to write the below reproducer and crash the kernel.
>Explanation of reproducer (set 64K mTHP to always):
>
>Fault in a 64K large folio. Split the VMA at mid-point with MADV_DONTFORK.
>fork() - parent points to the folio with 8 writable ptes and 8 non-writable
>ptes. Merge the VMAs with MADV_DOFORK so that folio_unmap_pte_batch() can
>determine all the 16 ptes as a batch. Do MADV_FREE on the range to mark
>the folio as lazyfree. Write to the memory to dirty the pte, eventually
>rmap will dirty the folio. Then trigger reclaim, we will hit the pte
>restoration path, and the kernel will crash with the following trace:
>
>[   21.134473] kernel BUG at mm/page_table_check.c:118!
>[   21.134497] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>[   21.135917] Modules linked in:
>[   21.136085] CPU: 1 UID: 0 PID: 1735 Comm: dup-lazyfree Not tainted 7.0.0-rc1-00116-g018018a17770 #1028 PREEMPT
>[   21.136858] Hardware name: linux,dummy-virt (DT)
>[   21.137019] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>[   21.137308] pc : page_table_check_set+0x28c/0x2a8
>[   21.137607] lr : page_table_check_set+0x134/0x2a8
>[   21.137885] sp : ffff80008a3b3340
>[   21.138124] x29: ffff80008a3b3340 x28: fffffdffc3d14400 x27: ffffd1a55e03d000
>[   21.138623] x26: 0040000000000040 x25: ffffd1a55f7dd000 x24: 0000000000000001
>[   21.139045] x23: 0000000000000001 x22: 0000000000000001 x21: ffffd1a55f217f30
>[   21.139629] x20: 0000000000134521 x19: 0000000000134519 x18: 005c43e000040000
>[   21.140027] x17: 0001400000000000 x16: 0001700000000000 x15: 000000000000ffff
>[   21.140578] x14: 000000000000000c x13: 005c006000000000 x12: 0000000000000020
>[   21.140828] x11: 0000000000000000 x10: 005c000000000000 x9 : ffffd1a55c079ee0
>[   21.141077] x8 : 0000000000000001 x7 : 005c03e000040000 x6 : 000000004000ffff
>[   21.141490] x5 : ffff00017fffce00 x4 : 0000000000000001 x3 : 0000000000000002
>[   21.141741] x2 : 0000000000134510 x1 : 0000000000000000 x0 : ffff0000c08228c0
>[   21.141991] Call trace:
>[   21.142093]  page_table_check_set+0x28c/0x2a8 (P)
>[   21.142265]  __page_table_check_ptes_set+0x144/0x1e8
>[   21.142441]  __set_ptes_anysz.constprop.0+0x160/0x1a8
>[   21.142766]  contpte_set_ptes+0xe8/0x140
>[   21.142907]  try_to_unmap_one+0x10c4/0x10d0
>[   21.143177]  rmap_walk_anon+0x100/0x250
>[   21.143315]  try_to_unmap+0xa0/0xc8
>[   21.143441]  shrink_folio_list+0x59c/0x18a8
>[   21.143759]  shrink_lruvec+0x664/0xbf0
>[   21.144043]  shrink_node+0x218/0x878
>[   21.144285]  __node_reclaim.constprop.0+0x98/0x338
>[   21.144763]  user_proactive_reclaim+0x2a4/0x340
>[   21.145056]  reclaim_store+0x3c/0x60
>[   21.145216]  dev_attr_store+0x20/0x40
>[   21.145585]  sysfs_kf_write+0x84/0xa8
>[   21.145835]  kernfs_fop_write_iter+0x130/0x1c8
>[   21.145994]  vfs_write+0x2b8/0x368
>[   21.146119]  ksys_write+0x70/0x110
>[   21.146240]  __arm64_sys_write+0x24/0x38
>[   21.146380]  invoke_syscall+0x50/0x120
>[   21.146513]  el0_svc_common.constprop.0+0x48/0xf8
>[   21.146679]  do_el0_svc+0x28/0x40
>[   21.146798]  el0_svc+0x34/0x110
>[   21.146926]  el0t_64_sync_handler+0xa0/0xe8
>[   21.147074]  el0t_64_sync+0x198/0x1a0
>[   21.147225] Code: f9400441 b4fff241 17ffff94 d4210000 (d4210000)
>[   21.147440] ---[ end trace 0000000000000000 ]---
>
>
>#define _GNU_SOURCE
>#include <stdio.h>
>#include <unistd.h>
>#include <stdlib.h>
>#include <sys/mman.h>
>#include <string.h>
>#include <sys/wait.h>
>#include <sched.h>
>#include <fcntl.h>
>
>void write_to_reclaim() {
>    const char *path = "/sys/devices/system/node/node0/reclaim";
>    const char *value = "409600000000";
>    int fd = open(path, O_WRONLY);
>    if (fd == -1) {
>        perror("open");
>        exit(EXIT_FAILURE);
>    }
>
>    if (write(fd, value, sizeof("409600000000") - 1) == -1) {
>        perror("write");
>        close(fd);
>        exit(EXIT_FAILURE);
>    }
>
>    printf("Successfully wrote %s to %s\n", value, path);
>    close(fd);
>}
>
>int main()
>{
>	char *ptr = mmap((void *)(1UL << 30), 1UL << 16, PROT_READ | PROT_WRITE,
>			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>	if ((unsigned long)ptr != (1UL << 30)) {
>		perror("mmap");
>		return 1;
>	}
>	
>	/* a 64K folio gets faulted in */
>	memset(ptr, 0, 1UL << 16);
>
>	/* 32K half will not be shared into child */
>	if (madvise(ptr, 1UL << 15, MADV_DONTFORK)) {
>		perror("madvise madv dontfork");
>		return 1;
>	}
>
>	pid_t pid = fork();
>
>	if (pid < 0) {
>		perror("fork");
>		return 1;
>	} else if (pid == 0) {
>		sleep(15);
>	} else {
>		/* merge VMAs. now first half of the 16 ptes are writable, the other half not. */
>		if (madvise(ptr, 1UL << 15, MADV_DOFORK)) {
>			perror("madvise madv fork");
>			return 1;
>		}
>		if (madvise(ptr, (1UL << 16), MADV_FREE)) {
>			perror("madvise madv free");
>			return 1;
>		}
>
>		/* dirty the large folio */
>		(*ptr) += 10;
>
>		write_to_reclaim();
>		// sleep(10);
>		waitpid(pid, NULL, 0);
>
>	}
>}
>
>Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
>Cc: stable <stable@kernel.org>
>Signed-off-by: Dev Jain <dev.jain@arm.com>
>---
>Patch applies on mm-unstable (9af4957ef127).
>
>v2->v3:
> - Don't special case for anon folios
>
>v1->v2:
> - Just respect the writable bit instead of hacking in a pte_wrprotect() in
>   failure path
> - Also handle soft-dirty bit
>
> mm/rmap.c | 9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)
>
>diff --git a/mm/rmap.c b/mm/rmap.c
>index bff8f222004e4..5a3e408e3f179 100644
>--- a/mm/rmap.c
>+++ b/mm/rmap.c
>@@ -1955,7 +1955,14 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
> 	if (userfaultfd_wp(vma))
> 		return 1;
> 
>-	return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
>+	/*
>+	 * If unmap fails, we need to restore the ptes. To avoid accidentally
>+	 * upgrading write permissions for ptes that were not originally
>+	 * writable, and to avoid losing the soft-dirty bit, use the
>+	 * appropriate FPB flags.
>+	 */
>+	return folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
>+				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
> }
> 

Hi, Dev

When reading the code, I got one confusion. Current call flow is like below:

    try_to_unmap_one();
        nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
	..
	pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
	..
	set_ptes(mm, address, pvmw.pte, pteval, nr_pages);

We get pteval by folio_unmap_pte_batch() but it is set again by
get_and_clear_ptes(), which maybe a different value. Then we use this pteval
to restore ptes.

So even we fix folio_unmap_pte_batch(), how this impact on the final restored
value?

Hope I don't miss something.

> /*
>-- 
>2.34.1
>

-- 
Wei Yang
Help you, Help me

