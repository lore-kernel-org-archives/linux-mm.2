Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58BE1CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 04:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7CD6B0088; Thu,  4 Jun 2026 00:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778C86B008A; Thu,  4 Jun 2026 00:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667806B008C; Thu,  4 Jun 2026 00:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5653E6B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:14:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB7C9162CF0
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:14:45 +0000 (UTC)
X-FDA: 84840914130.30.331E047
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 89292A0006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:14:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eXBof5wv;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780546483;
	b=5Wbk8BwqR003cnH4MWkual5HjA4+TUajnqAazf0o/JOP+sWmGTqjT7gYOKexKRHXgcXzbJ
	vnEFZhNpvNsu1h8UHWnnqc0OhPEDMr2bFFZyR+3zsnRh4m9X/61WdN9q2/VwYzvZeilegm
	taoCmeLAh+fjYP41Eeih5qn/dNsnapQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eXBof5wv;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780546483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWytyULl7iE6NmIMXNglghTQUX52gHdAhp4TQhKDY+Y=;
	b=iyZrOL4tdWIqt1ONHRceokrpik4nvurxTTmbhezJosBKdqGIir3dBT/s11yUpErdXzmAzg
	EIzW95CwDvtAumAGa7oYBPw+bpzzA3ZT6vBq4uMJLHtYZtxs9H6ylA9BAiml4q/O6rem23
	xKB9rIMC5k3rh4U5o2CLayDDcpKO2hU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780546482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AWytyULl7iE6NmIMXNglghTQUX52gHdAhp4TQhKDY+Y=;
	b=eXBof5wvrA0qu04fD+/G2ZjndrYdhjPKOPr6wimppmamyAEkKCIsmbF48g5JMEPiUF4JWi
	ZeE9cc5eCldGjGeXjeuSTMumiu4Q0PxL0EG6rU62DF3qUWt5b4GJ5OXJDP5kfnGsAQpuZq
	+ow+F4y5vUMozVqWAR5aBxGxqL2KKr8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-ZBi4QLM2NQyGI6Yse7CFfg-1; Thu, 04 Jun 2026 00:14:41 -0400
X-MC-Unique: ZBi4QLM2NQyGI6Yse7CFfg-1
X-Mimecast-MFC-AGG-ID: ZBi4QLM2NQyGI6Yse7CFfg_1780546480
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490afe64f26so897215e9.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 21:14:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780546480; x=1781151280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AWytyULl7iE6NmIMXNglghTQUX52gHdAhp4TQhKDY+Y=;
        b=ekDelR0vHoDZhPNg/knSJQ2/xMdynvhKjfs7UWUeZbXv1r+fxtatCBNvQVR12py8UQ
         942cE/MsVZsCiDt8vqb3DnHxKW+f5uCREyuEWWT73EI/ZV3doLReP/AMhpqU8LW6ilaC
         Nejt2syzkMy/1WHL7VlfTiiLqmlF6XRzXhA15et1tjogAWlLoYmmZax/uIe0XqKUCsMc
         8eRR04ud3DEXC64E8qAsxfDClLTJ2Mz1n0UWXh1xuB8RKW9YBzvUbLHAWmdRjTHcS5BH
         uvZcoufpsAs71GlIpD6jo/U/AwiPjOlp1f0LRbXUkpDwa+l//4CKtbE1+dTFuVdziC3f
         FhWQ==
X-Forwarded-Encrypted: i=1; AFNElJ/BvfhDdmpvJs/ttK986D+jmAjdvryuPYTvnMqKNI2yE8W4MmXqeINupNhtpJdr72ALbYea5GL3EQ==@kvack.org
X-Gm-Message-State: AOJu0YzocXErS+f9xJ0NTQGXind0uM4LYSpuZ2YrJNtmmfIaIDhwRLU/
	aP99Lu/C1ESCE+Uc1FRdCKJXJeV5czNnKoTbwpdvrpTb0c44Yxo6rQD6nsYbXYBmokVp2Gd4G3F
	vbHNbHfkBqpk0BvsuJzHc8/rBjSq2gS5IMMqoMokm3wjHWSuiXxp0
X-Gm-Gg: Acq92OH0QV/lCdIY90127H32pw72cpb3s8IMe8V3O664p0nOqcm000KRMxxZKSCHgWz
	bfX0q6NfyCnJE80C3v8ONf7uS0cS8bTTqZybWwGCUVU2NToqeyM/Sz7iMYkIL2uV7kBOAQk5lY4
	/Ex1sC8vFBoH3sohW9dQnGDmqZ/UK9rcstKS/bhFQDw8LJBGaZ9ApvfCvHcmhk9EqAwxoA4BRD8
	tyVfIHdkc7JfZ4B+ZlgxSAu75xFScjbnGHU43GymadbGnWW5j8glwr9Zirc7FBRgaxLWPnuNu+X
	3iHkld+5swjk0PKuCs1KwPmsyQumLIFUHw3SI7MXjA4FKhfnLYuJAnpJ8P9u0ub1YoPfs2//EKg
	Kj19b1fvvhm3LJMzvOcVhFd4B0RXra0gWMQb7ybSEvJaIO/UqxP7gzA==
X-Received: by 2002:a05:600c:6095:b0:490:bb60:68ca with SMTP id 5b1f17b1804b1-490bc4b54b4mr24735825e9.3.1780546480164;
        Wed, 03 Jun 2026 21:14:40 -0700 (PDT)
X-Received: by 2002:a05:600c:6095:b0:490:bb60:68ca with SMTP id 5b1f17b1804b1-490bc4b54b4mr24735325e9.3.1780546479626;
        Wed, 03 Jun 2026 21:14:39 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc23394asm39489705e9.0.2026.06.03.21.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 21:14:39 -0700 (PDT)
Date: Thu, 4 Jun 2026 00:14:35 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+8ffca916f3fa5455f9b4@syzkaller.appspotmail.com>,
	apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
	gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-next@vger.kernel.org, matthew.brost@intel.com,
	rakie.kim@sk.com, sfr@canb.auug.org.au,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com
Subject: Re: [syzbot] [mm?] linux-next test error: kernel BUG in
 post_alloc_hook
Message-ID: <20260604001334-mutt-send-email-mst@kernel.org>
References: <6a20a309.85ccb786.283107.0005.GAE@google.com>
 <20260603154737.48dfcc19a51da03241e1af48@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260603154737.48dfcc19a51da03241e1af48@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xg0ZmSQzeSkQdf0Jq4rCbbHwsAvKah7l8r3syHOJUr0_1780546480
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 89292A0006
X-Rspam-User: 
X-Stat-Signature: wmawybhs3tzxxta1kqyqhzn8mfy9z1yd
X-HE-Tag: 1780546483-474681
X-HE-Meta: U2FsdGVkX19soOIg+7FhMhebwfCmqmMGmI+XtAroSK6Rg1ma88gtyWdusi+ES3ibuEFkadaI7DnMEnwYtyPX5X4I88lTcsGCTUehdNvZ3T48SZAhXD2tDXEHeyu2z/taF2RXgFiSB5dGAv6WSYOMr49KQyqN3wOK9jWp70rmn3mIp47vQWz/kSDNK5gWKtGaQtfoMt1+jIPaTjzbXBF6BPD0a39PNcAKjDVBU+/3+p1Oh4P4faM3a9C+0+nOXLBIbEwcNZF5dDzQVqEfRUSqgiIda9U9cYpMwYmRigafrvUJ2ej9nXi2l8lImqO+jatAL8KXDwBpR0cVDO6wS+B3lfu34RHNVUj6yFaSZteMqCU/yvXQDJEiH4ZZ/5THkZ4h2vHPvKxvMfVtPr+fzHn+wrO9rMKeDQ1hiuemovLYgP1resJo8f0p8cQtBvU8qyYnmHoeDK+SJoGCV4lhSDiI8HKmX4xe4hPgmAXtJRBlbjB6Vb++V0F+SFdtmnAK1PHOIAnZ//M/u+62ZUXX1m8SCdWlNbvl20AFkRcPTJQX6gwcCp8fEuLFd97tBwaZ83TaGEH6J9xULaxd2PEOYf4VfBSjLSWafVsJrGt9ggoRFNvAIrcIZogQcqTe6aFPbnffg4j4Hx2Rb27JgLm0UuoXmA/0Sk4HMrAUSZQNmw99HDbb5qpsTYfmmJKwZLpBFa25B5F3ldw8/kidpc7Py8wbndeXE+Tns2+Ijp/oWXF/6dQnK1F/nGdYNBcbrmfui+rpE09/lijO9hUT0Wm02Z/mfc9Apee4jR4cHjc6NUsf2TWj1wZO84ZvF4/14zhMjzi8CCbpcP95LW2fdHzLFiYQcImHl8dPjFVpNk4xkzcKUU2poOgv16uQQP1ufad0H07vIcfJrbuGoY1hcOMRwZ+CVUbFYRHeL0BjD7CNJ7BRC9nz3xyS/c20o+K3gBw8J4QIeGHWSQ6DmSX2Wqced6/
 3Bf4wsEn
 uCBQNPXZIQXbDfv/3tbwbNG9UX89e6YyMdzs/wtau43qBcdUCXmTIIYPVgVGiuG6etzt3ot7lcuoJAiXWaaj62lgQM0xWVs9+dnj2bsk8D++ST1CnFJVzW5Hlbp1p8Mv1VAsmEkQgqosFo32l9UIV2ePf43MzCcxHS+oUtVwVCNan/mHJNTHmxLB77vrPYqboHxTq/Xp/PFEMDGPnWnNa0yUAnrBgt+AtMkohRvejF7UYgIe6j+WT+iJyL00y3b5M128+kfNX5IFeh41eEV5oysXqySst/faYJfhjfhQiK78mBs6YCoelImleo1MxUlTz45namzQ7HOuYD6HYTutZ1tq8xJrOWlK0VSDPXSUHFzv2pFdt2Xyj88XgQxtGJcI8AXPwa4AiAoGU+PJEPZbhKyp/uXsfXyLSw4jmtjG34ESGhX52nPWBSwVbCWzw/rO1UNw54cjNlcbVA0XOIpDTxqZprzM2zf5QixWXOLaZLRXZk6Ktf3DX8kh8OFWJVJGDynbSfDH/9mTrlOXVJH3hjt8sdIpAbZ6BU3qGWnA5HIUeGGseWVx2gJI3hs5v0/dmHSpJLBwnLb00dqKVchwAzwjqnbeU2n0+ShRu3v2Dd+n2z26Jz2e4aPb8WLbAvLwa3Ly2Y5xARS85RZjOIi9trJZzO6p8LJm9X125MST28jz91Vix+Hf2XGw9MmUIAOIPpXHvuidIh7jyEp2rOJUw9PtTUE9s+1g4DbfeN+dZ8nHbc8A4rj5BebhOhW+O0fYd8F6ip179Tp1q42bE2OlEN9JcHa5H6ZDbvam8DcZ39I8KaigBwRCpn7xE0SmxtqyFvFn1ldNMaJyuMaeRnbdwokS2mWBuPTemPup1CR0xskWFxxFTKBPSZbG5ct6OrmYwBlE3EnFoNEhy94H2RbuzTj+JCpBECsvkTIY6IjfhhMt2WmZb23obHbIbsalXewpxei86Vr/1WtqSI/b8aykn6itdxTI6
 FZOlv89f
 QYwhJwP5Bg3tPEN+MjfVZkPayPt4BYuf7Llg3zUXQ2kofWl/FLvxk1eq98qpaYhYLL18bCcP1Fc5DVh6tlu+2Sr4wCOvf+gnzekz5kx4YwzaM4ueY9XQBjJ5SPAr0OrHJ8WBQqecrb1KY62WMx26A1muVkQVwiOnrrzicCgR58pnA3AEq/Drwxq5SyUfVh2Aw9UMReI4vanBnhxxW+L4FbwyRcu9fC2IwsZgTSbQ4jZS0JiDhx9c+QaY8j1zFTBEhuCYb6hofcfbE4ixpsI1o8HuVaPqw/u7nO2UQsXXmLgCaj0/28AHs1tI9nKqKwTm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 03:47:37PM -0700, Andrew Morton wrote:
> (cc Mike Tsirkin)
> 
> On Wed, 03 Jun 2026 14:56:25 -0700 syzbot <syzbot+8ffca916f3fa5455f9b4@syzkaller.appspotmail.com> wrote:
> 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    a225caacc365 Add linux-next specific files for 20260603
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13b0de66580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=717edf2a5f9fc390
> > dashboard link: https://syzkaller.appspot.com/bug?extid=8ffca916f3fa5455f9b4
> > compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> > 
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/f799d07ea17d/disk-a225caac.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/72d0f0ff94e6/vmlinux-a225caac.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/99d4279e6fec/bzImage-a225caac.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+8ffca916f3fa5455f9b4@syzkaller.appspotmail.com
> > 
> > ...
> >
> > **********************************************************
> > **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
> > **                                                      **
> > ** This system shows unhashed kernel memory addresses   **
> > ** via the console, logs, and other interfaces. This    **
> > ** might reduce the security of your system.            **
> > **                                                      **
> > ** If you see this message and you are not debugging    **
> > ** the kernel, report this immediately to your system   **
> > ** administrator!                                       **
> > **                                                      **
> > ** Use hash_pointers=always to force this mode off      **
> > **                                                      **
> > **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
> > **********************************************************
> 
> Geeze, who added that.
> 
> > page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x13fe38
> > head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> > flags: 0x100000000000040(head|node=0|zone=2)
> > raw: 0100000000000040 dead000000000100 dead000000000122 0000000000000000
> > raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> > head: 0100000000000040 dead000000000100 dead000000000122 0000000000000000
> > head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> > head: 0100000000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
> > head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000004
> > page dumped because: VM_BUG_ON_PAGE(1 && PageCompound(page))
> > ------------[ cut here ]------------
> > kernel BUG at ./include/linux/page-flags.h:682!
> > Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> > CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted syzkaller #0 PREEMPT_{RT,(undef)} 
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
> > RIP: 0010:__ClearPagePrezeroed include/linux/page-flags.h:682 [inline]
> > RIP: 0010:post_alloc_hook+0x287/0x310 mm/page_alloc.c:1863
> 
> That's the __ClearPagePrezeroed(page) added by 504f40f6bda6 ("mm:
> page_reporting: skip redundant zeroing of host-zeroed reported pages").
> 
> Was it intended that this series
> (https://lore.kernel.org/cover.1779315441.git.mst@redhat.com) be
> included in -next?  It's huge, it's late, review is minor.

Of course not (
I've no idea how that happened.
Should not push to next late at night.


> <remainder of report is below>
> 
> > Code: ff ff 89 da be 01 00 00 00 48 c7 c7 40 50 4f 8e e8 ce 4b d4 02 e9 c5 fe ff ff 4c 89 ef 48 c7 c6 40 ef 7a 8b e8 2a c6 05 ff 90 <0f> 0b 31 ed f7 44 24 04 00 01 00 00 0f 84 8e fd ff ff e9 86 fd ff
> > RSP: 0000:ffffffff8e0078e0 EFLAGS: 00010046
> > RAX: 0000000000000000 RBX: 0000000000000002 RCX: ffffffff8e0fef40
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> > R10: dffffc0000000000 R11: ffffed10170c4903 R12: dffffc0000000000
> > R13: ffffea0004ff8e00 R14: 1ffffd40009ff1c0 R15: 0000000000000000
> > FS:  0000000000000000(0000) GS:ffff888125a79000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffff88823ffff000 CR3: 000000000e1b8000 CR4: 00000000000100b0
> > Call Trace:
> >  <TASK>
> >  prep_new_page mm/page_alloc.c:1925 [inline]
> >  get_page_from_freelist+0x3081/0x3320 mm/page_alloc.c:4015
> >  __alloc_frozen_pages_noprof+0x194/0x380 mm/page_alloc.c:5376
> >  __alloc_pages_mpol+0xe0/0x390 mm/mempolicy.c:2495
> >  alloc_slab_page mm/slub.c:3287 [inline]
> >  allocate_slab+0x83/0x5e0 mm/slub.c:3404
> >  new_slab mm/slub.c:3447 [inline]
> >  ___slab_alloc+0x160/0x930 mm/slub.c:4485
> >  __slab_alloc_node mm/slub.c:4549 [inline]
> >  slab_alloc_node mm/slub.c:4925 [inline]
> >  __do_kmalloc_node mm/slub.c:5331 [inline]
> >  __kmalloc_noprof+0x140/0x7b0 mm/slub.c:5345
> >  _kmalloc_noprof include/linux/slab.h:973 [inline]
> >  _kzalloc_noprof include/linux/slab.h:1286 [inline]
> >  __alloc_empty_sheaf mm/slub.c:2774 [inline]
> >  alloc_empty_sheaf mm/slub.c:2794 [inline]
> >  init_percpu_sheaves mm/slub.c:7555 [inline]
> >  do_kmem_cache_create+0x8ae/0x9a0 mm/slub.c:8595
> >  create_boot_cache+0xbf/0x120 mm/slab_common.c:717
> >  create_kmalloc_cache+0x41/0xb0 mm/slab_common.c:735
> >  new_kmalloc_cache+0xd4/0x180 mm/slab_common.c:982
> >  create_kmalloc_caches+0x14/0x50 mm/slab_common.c:1005
> >  kmem_cache_init+0x14a/0x1e0 mm/slub.c:8496
> >  mm_core_init+0x7e/0xb0 mm/mm_init.c:2728
> >  start_kernel+0x162/0x3e0 init/main.c:1034
> >  x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
> >  x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
> >  common_startup_64+0x13e/0x157
> >  </TASK>
> > Modules linked in:
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:__ClearPagePrezeroed include/linux/page-flags.h:682 [inline]
> > RIP: 0010:post_alloc_hook+0x287/0x310 mm/page_alloc.c:1863
> > Code: ff ff 89 da be 01 00 00 00 48 c7 c7 40 50 4f 8e e8 ce 4b d4 02 e9 c5 fe ff ff 4c 89 ef 48 c7 c6 40 ef 7a 8b e8 2a c6 05 ff 90 <0f> 0b 31 ed f7 44 24 04 00 01 00 00 0f 84 8e fd ff ff e9 86 fd ff
> > RSP: 0000:ffffffff8e0078e0 EFLAGS: 00010046
> > RAX: 0000000000000000 RBX: 0000000000000002 RCX: ffffffff8e0fef40
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> > R10: dffffc0000000000 R11: ffffed10170c4903 R12: dffffc0000000000
> > R13: ffffea0004ff8e00 R14: 1ffffd40009ff1c0 R15: 0000000000000000
> > FS:  0000000000000000(0000) GS:ffff888125a79000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffff88823ffff000 CR3: 000000000e1b8000 CR4: 00000000000100b0
> > 
> > 
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > 
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> > 
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> > 
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> > 
> > If you want to undo deduplication, reply with:
> > #syz undup


