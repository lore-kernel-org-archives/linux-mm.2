Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 546E1CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 08:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3B938E002B; Mon, 29 Sep 2025 04:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13838E0002; Mon, 29 Sep 2025 04:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DAB28E002B; Mon, 29 Sep 2025 04:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EAB48E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 04:23:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B759C02B3
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:23:04 +0000 (UTC)
X-FDA: 83941597488.09.8989DEC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id A548920009
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:23:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZMO1pRFI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759134181; a=rsa-sha256;
	cv=none;
	b=BVRa9FRbIv+1qxQ2zWvt0XkopW1ZG3bRNPJSNzl4UwJyS5AlkwxVzjW/wmAtf37UvKnUtz
	Lh/YJRLe/oo8HmcBtJbqUeAekCS06DSE9v5DddRHd66SkSnsVnbv/7GoHYKJswbV+D7W8I
	pPTSkzkkmmI4O6Abaane+IJJAqbXYxw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZMO1pRFI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759134181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hh0NZu85G8CAW62R7C9eCRdjUG6H66ANzVKWkbmQFc=;
	b=R3Khcgjr8ljGBB9Rq6ONP4Vvkw8XS6iPCFvCxvTqxX8ZuE20d26/OxBDgV1FbRNTKJt5A9
	Oq3tp7XIHlMqUjo1Mh64Dy0cVAMTYhdLd6QAJF+5iggnnVd5OIn7tnui+pH6aQF6mtbZrE
	rLcyrkzq/ra9X6A0+3GSXcY6xF545eE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759134181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7hh0NZu85G8CAW62R7C9eCRdjUG6H66ANzVKWkbmQFc=;
	b=ZMO1pRFIjJ75Jc2m9Nswk9FWe0FE5WLUoTaLULcWH1Bg4xit7kMaV7yQDhu+yMVQvqe24e
	9aT1CH427vYAc+fk8K9NWAPVhgl6+XKciMBsiggro/+8yffTv5BHTXGcdPFls95njP25D3
	XCGRK3DgSNpQSq3kxYXUwfubrNcGU8M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-NhcYXKauMw6TgaM-QPpCdA-1; Mon, 29 Sep 2025 04:22:57 -0400
X-MC-Unique: NhcYXKauMw6TgaM-QPpCdA-1
X-Mimecast-MFC-AGG-ID: NhcYXKauMw6TgaM-QPpCdA_1759134176
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ee13baf21dso3482886f8f.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:22:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759134176; x=1759738976;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7hh0NZu85G8CAW62R7C9eCRdjUG6H66ANzVKWkbmQFc=;
        b=g38G6ORP/j8DP6TCYEmVgohTjgnh/8+earhSsJ8gZ0GAeiv4dShpTiVZRFtZWV5QGs
         kAUuFMYFUh5v8NbVSRKeW3rNIVKcBf5kTX8jZLVH3VTTgFIyGMSVU64CWLkjuIN0xLRp
         MZwP91/ZRU0+v+3AUfp7sGZd4kALR6Ygx5cm4U48kHt6qJgq4Vw6A2XJRcVMDOdWOKWy
         xzToZ+EMacuT4WHL7aBVI6WNGmtIiD3gd9097eyenyvcEIm8XBwN3xfYjJHgEXUXmdvf
         jjB4OHpQ7oYbOXmVlq5AiNmnyrr4nrPxxMMUpRtmxc/YPJO82G+VQdds0ZFUhSea+URm
         hvOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlQILVYGKsM+jm/TBPCleMiYhtyPMGshETGCcC2l3P7rS1oBzzpGEGYr19OxtFKJ+ljH/6LJwH2Q==@kvack.org
X-Gm-Message-State: AOJu0YxhpIbI9+4yPDuh1E0fjWD4FVaAvBYANavAqqTCibZNVdY0jl3K
	V8aCH6vFcwTAquHFqf84g7gkFWAW0Rx+fV85W2O0nxSCH4Nx3SaZ6n6SbmQrRBtsO7Q2gjpzVA3
	yEUToyUZcVZpi0z34YvPNS5xMnI3L4R6LX3VF0WpBy7XZqh97drNW
X-Gm-Gg: ASbGncscH67nLohIgjkXr7Y4b7MFDHgD3LTrc4NH/CVDTYAPaa6P/xEb+C/jqcrjGKt
	u0/B78WtFJm7Iu4qXgMO3I9YkKEqqlgqFdq1RtiJtfK1x7RGX0kkhNlXkBsAPv0AaSCAlhuHQiy
	ZO5EnPwHutKrXxcLUwXDhCq3t+XfEi6Avs9qdI+970g2CSkaouD6jY3dtbJGVDV/Xlxl8OQGTxW
	zZQhv79RZHDolls7jzPGZ4c25SRr740wHflF9INsd0+NOM2VxUsTAfQyMjEmAsFt+r9TUY4E88T
	OGtOLQGcocnsQXpm2Un9Sc+LP+gRxYm2/nHbYx0FR6AbpUwiKbBCp64L0AjLi+0QYDw3xpRFKEZ
	DXwC3mDSHIT0UfQSzRG5rHtkl38p4QJPszXdjrQn9jWO+6gqHk61BvAXVRlaNHjB8pA==
X-Received: by 2002:a5d:5f45:0:b0:3fc:54ff:edb6 with SMTP id ffacd0b85a97d-40e4886dfefmr13974449f8f.35.1759134176197;
        Mon, 29 Sep 2025 01:22:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZbc2TVNXj3otVOPdR85u2ixuUt2c5aBpj1wRJdRdqorY+gkLE61Ny+sN1k7u/kHKIIEJnVA==
X-Received: by 2002:a5d:5f45:0:b0:3fc:54ff:edb6 with SMTP id ffacd0b85a97d-40e4886dfefmr13974427f8f.35.1759134175712;
        Mon, 29 Sep 2025 01:22:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f05:e100:526f:9b8:bd2a:2997? (p200300d82f05e100526f09b8bd2a2997.dip0.t-ipconnect.de. [2003:d8:2f05:e100:526f:9b8:bd2a:2997])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb8811ae8sm17058049f8f.19.2025.09.29.01.22.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 01:22:55 -0700 (PDT)
Message-ID: <6b473885-cb16-4b57-b863-bcba22083c12@redhat.com>
Date: Mon, 29 Sep 2025 10:22:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] possible deadlock in ksm_do_scan
To: syzbot <syzbot+f1b91395f2bcbcc8128b@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, chengming.zhou@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 syzkaller-bugs@googlegroups.com, xu.xin16@zte.com.cn
References: <68d95f20.a70a0220.10c4b.0022.GAE@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <68d95f20.a70a0220.10c4b.0022.GAE@google.com>
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: SNJ2lvbOfwwI6VsHrqfnbdV0fJD8oLAzF-5X2XCJPq4_1759134176
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A548920009
X-Stat-Signature: nxcx9mmu1kwpey6361dzifo6qx6g1ze1
X-Rspam-User: 
X-HE-Tag: 1759134181-287511
X-HE-Meta: U2FsdGVkX19oOedRHy3A4fVs0xjU2B4+a7+uvdHbdBu9x3T2GWHtvcYxuwCNlAPN4YjFhScZYhD85iViXbjktZ4wE62ZZgrRUYcFD6livnxTdKzVIzh9meoenxvxcDjdmODq9X2phkNVVA/F/Pzb5ysHE+zalbnVtZ5EqCI1C5QtZg/YhkKeFyA77yZCCah1H7hPc/Gt/8WLI9y1aDqjaaBSroIdCiLHyPnR8CcOJP9RgkE6P+UkVibgupPUto5lqK0OH5uQJFLcB0nJBhlj83ZN7ncvQpG70cXDA068ZJ9tBfCz9iGxoWkWWgBvwYtHU6FUgID8ulvgh8/sYS1lXHTFk9N6e+SkwFeW91Z5LNOfOwxMCz8pwzp/mIAVmf5GAvCCEGLhnEEWTxUAY/5nwqdXAIHpNDbhR7RwuueT0ngdeXZR4lebOPND4sabPK1Ip9mgMJhRIYzUrFNW9IKVTXTsARA44svqOYU/AUmoFUWQpApJh7j2THW9/cyftSrI00ki0foszmU8fNAb0DveP5pvoGd2Ajkh6VvElDHtYUvUUJHe0WLCZfW36a3YPKsWT1nJuDfS1SkNViJ+jMkV52SfSTBs6uLHWrlqukGNpxXQd0d12Lvc+Vel73BIvC4e+o2SFRyLpG6NmmjTrxPWDGlYwjr+OWNwGL6hmcRjf9xkHY1ZE19QBktlGvWYlLbqOAqj/extYzEHClILWw6j2VM68GcnGgXUSlcJ7WXCukDihOhtTdXfsoUqu8UmS1gW7TC0jsRLP+6jYOx3aP2q7abUPLQ+tWuXxI+3pz6akAWLEBKGmp2tnC2EnDAquzn4Xq6xjxME1A6HIJpgoYXoVWdWFO4a4nh2yjIjmosDba47nKFLEug9s6Aw6TxLuUu/csWTzTBroD2ZE4P8V+xXTsIxP34O6cmnlbAlw8g8blgh7Zyad5JymcBPoVq5ja2GINWuNbAfG6+FZh1RpC3
 6JCPdqrI
 t1QDsscVOcads3kH08DgL6Yzr5swxGi7kYc98w76GPWOaXEGDIzxZxXMIOTdoVxgaoE2qoPO0lNSKbwt8taAI5RDe3G/DL4bKUKKzWW/W8TBxa4pdsuapVU3vIiYmudl6pl0KtUJ5BdWrYu/ePE6QSjo2yuF3Rux9hD0/B/f62mbuzUIrD/ZVhUrikU0ws0PdFziULIaFI12wQ60kWL/sE46wz4pYWw/crJeiPhvD+DjZoY2U/GG8FaHHArh1YMXclfgjK3BzcAVM7IksH0X0+bMqJi91wpsGY1JPGZYenT0j8Cpd41jzZOPg4OIUJ6g/x6GbFLuyRvdA3vnMOXgFXbZZUobw/VVSSQ6akt88JSqWj4DtkzKwbP6cbqUpfUIClXyD/qRRDhx2K3Q3kOlOFoof7Nm08mggfDMDu1oWGmJWCtsuisZ9z5T5OE7fEV8am0hitNpbvVq9+bt5XI4+MZkaKchtCYzHp4nY7w2P0HvwV0U9zsfEvxW+pY7ya5o7jCjpDdDPVivT+32CauJLuCc2pMZbN7gMnGOP+tx79FhjJ/waGXtYM8H7qe//OO/RqMSS+0/B/GFRxt0tFL/O3DpxWtmL98qSlyEidlm7o6SaFYNFKtxtew9MRq8vKULoZoCx7SOpTbmJSd1Vre4cUDIEPaW5l5K32pgVdo5kmnD3xHdwE8at3KnJK1/vDEF9wNSbiIkwBojGDplW0spE08qP87Ry0wxwCo67Rv9QuwM1YA6Onlv6tK9bPeDEHebqpH20vSbBGZt3rieMfdcD/nLsRa3jsFwTEM/BKkw2KzNU+2urVnWPE/Vgfw15xapaquthLWDM/E4LZbrrh6pvghjmkE6LAvSkjTBhFdXaq9gXL6b1faJ//lezi7t4I6OYTKHDwV1wnUA0oB1JjUVdTIqErbSmgjqxOmLuTHoCsH369L8OdngJjsxNzhz8P7Th3vgQVqT3HBcKa7TyfS1dJYx4WtGv
 yfKtc9U6
 B4UVr4MEz0ShAcP6Rt3ouWNF/n1NUj11A+yBYfCp7xO5NAQFje8uiyky/rA/iwXLyowA+KCNK56RRY+lt2xRErIWiwFTLs/4oT/3KpW9Jyo5LTFYVQShQGOe91ZU78S81Fsp5h4/i0s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.09.25 18:15, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b5a4da2c459f Add linux-next specific files for 20250924
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15a154e2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=841973c5ab4f4157
> dashboard link: https://syzkaller.appspot.com/bug?extid=f1b91395f2bcbcc8128b
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/2d0e39514585/disk-b5a4da2c.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c7c8001fe2ea/vmlinux-b5a4da2c.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/807bea872f12/bzImage-b5a4da2c.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f1b91395f2bcbcc8128b@syzkaller.appspotmail.com
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> ksmd/37 is trying to acquire lock:
> ffffffff8e645220 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:318 [inline]
> ffffffff8e645220 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4896 [inline]
> ffffffff8e645220 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:5220 [inline]
> ffffffff8e645220 (fs_reclaim){+.+.}-{0:0}, at: kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5251
> 
> but task is already holding lock:
> ffff888028ba01e0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:368 [inline]
> ffff888028ba01e0 (&mm->mmap_lock){++++}-{4:4}, at: scan_get_next_rmap_item mm/ksm.c:2532 [inline]
> ffff888028ba01e0 (&mm->mmap_lock){++++}-{4:4}, at: ksm_do_scan+0x602/0x6540 mm/ksm.c:2659
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #7 (&mm->mmap_lock){++++}-{4:4}:
>         lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>         __might_fault+0xcc/0x130 mm/memory.c:7125
>         _copy_from_iter+0xf3/0x1790 lib/iov_iter.c:259
>         copy_from_iter include/linux/uio.h:228 [inline]
>         copy_from_iter_full include/linux/uio.h:245 [inline]
>         skb_do_copy_data_nocache include/net/sock.h:2269 [inline]
>         skb_copy_to_page_nocache include/net/sock.h:2295 [inline]
>         tcp_sendmsg_locked+0x2347/0x5540 net/ipv4/tcp.c:1272
>         tcp_sendmsg+0x2f/0x50 net/ipv4/tcp.c:1413
>         sock_sendmsg_nosec net/socket.c:714 [inline]
>         __sock_sendmsg+0x19c/0x270 net/socket.c:729
>         sock_write_iter+0x279/0x360 net/socket.c:1182
>         new_sync_write fs/read_write.c:593 [inline]
>         vfs_write+0x5c9/0xb30 fs/read_write.c:686
>         ksys_write+0x145/0x250 fs/read_write.c:738
>         do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>         do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #6 (sk_lock-AF_INET){+.+.}-{0:0}:
>         lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>         lock_sock_nested+0x48/0x100 net/core/sock.c:3720
>         lock_sock include/net/sock.h:1679 [inline]
>         inet_shutdown+0x6a/0x390 net/ipv4/af_inet.c:907
>         nbd_mark_nsock_dead+0x2e9/0x560 drivers/block/nbd.c:318
>         sock_shutdown+0x15e/0x260 drivers/block/nbd.c:411
>         nbd_clear_sock drivers/block/nbd.c:1424 [inline]
>         nbd_config_put+0x342/0x790 drivers/block/nbd.c:1448
>         nbd_release+0xfe/0x140 drivers/block/nbd.c:1753
>         bdev_release+0x536/0x650 block/bdev.c:-1
>         blkdev_release+0x15/0x20 block/fops.c:702
>         __fput+0x44c/0xa70 fs/file_table.c:468
>         task_work_run+0x1d4/0x260 kernel/task_work.c:227
>         resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>         exit_to_user_mode_loop+0xe9/0x130 kernel/entry/common.c:43
>         exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
>         syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
>         syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
>         do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #5 (&nsock->tx_lock){+.+.}-{4:4}:
>         lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>         __mutex_lock_common kernel/locking/mutex.c:598 [inline]
>         __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:760
>         nbd_handle_cmd drivers/block/nbd.c:1140 [inline]
>         nbd_queue_rq+0x257/0xf10 drivers/block/nbd.c:1204
>         blk_mq_dispatch_rq_list+0x4c0/0x1900 block/blk-mq.c:2129
>         __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
>         blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
>         __blk_mq_sched_dispatch_requests+0xda4/0x1570 block/blk-mq-sched.c:307
>         blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
>         blk_mq_run_hw_queue+0x348/0x4f0 block/blk-mq.c:2367
>         blk_mq_dispatch_list+0xd0c/0xe00 include/linux/spinlock.h:-1
>         blk_mq_flush_plug_list+0x469/0x550 block/blk-mq.c:2976
>         __blk_flush_plug+0x3d3/0x4b0 block/blk-core.c:1225
>         blk_finish_plug block/blk-core.c:1252 [inline]
>         __submit_bio+0x2d3/0x5a0 block/blk-core.c:651
>         __submit_bio_noacct_mq block/blk-core.c:724 [inline]
>         submit_bio_noacct_nocheck+0x2fb/0xa50 block/blk-core.c:755
>         submit_bh fs/buffer.c:2829 [inline]
>         block_read_full_folio+0x599/0x830 fs/buffer.c:2447
>         filemap_read_folio+0x117/0x380 mm/filemap.c:2444
>         do_read_cache_folio+0x350/0x590 mm/filemap.c:4009
>         read_mapping_folio include/linux/pagemap.h:999 [inline]
>         read_part_sector+0xb6/0x2b0 block/partitions/core.c:722
>         adfspart_check_ICS+0xa4/0xa50 block/partitions/acorn.c:360
>         check_partition block/partitions/core.c:141 [inline]
>         blk_add_partitions block/partitions/core.c:589 [inline]
>         bdev_disk_changed+0x75f/0x14b0 block/partitions/core.c:693
>         blkdev_get_whole+0x380/0x510 block/bdev.c:748
>         bdev_open+0x31e/0xd30 block/bdev.c:957
>         blkdev_open+0x457/0x600 block/fops.c:694
>         do_dentry_open+0x953/0x13f0 fs/open.c:965
>         vfs_open+0x3b/0x340 fs/open.c:1097
>         do_open fs/namei.c:3975 [inline]
>         path_openat+0x2ee5/0x3830 fs/namei.c:4134
>         do_filp_open+0x1fa/0x410 fs/namei.c:4161
>         do_sys_openat2+0x121/0x1c0 fs/open.c:1437
>         do_sys_open fs/open.c:1452 [inline]
>         __do_sys_openat fs/open.c:1468 [inline]
>         __se_sys_openat fs/open.c:1463 [inline]
>         __x64_sys_openat+0x138/0x170 fs/open.c:1463
>         do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>         do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #4 (&cmd->lock){+.+.}-{4:4}:
>         lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>         __mutex_lock_common kernel/locking/mutex.c:598 [inline]
>         __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:760
>         nbd_queue_rq+0xc8/0xf10 drivers/block/nbd.c:1196
>         blk_mq_dispatch_rq_list+0x4c0/0x1900 block/blk-mq.c:2129
>         __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
>         blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
>         __blk_mq_sched_dispatch_requests+0xda4/0x1570 block/blk-mq-sched.c:307
>         blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
>         blk_mq_run_hw_queue+0x348/0x4f0 block/blk-mq.c:2367
>         blk_mq_dispatch_list+0xd0c/0xe00 include/linux/spinlock.h:-1
>         blk_mq_flush_plug_list+0x469/0x550 block/blk-mq.c:2976
>         __blk_flush_plug+0x3d3/0x4b0 block/blk-core.c:1225
>         blk_finish_plug block/blk-core.c:1252 [inline]
>         __submit_bio+0x2d3/0x5a0 block/blk-core.c:651
>         __submit_bio_noacct_mq block/blk-core.c:724 [inline]
>         submit_bio_noacct_nocheck+0x2fb/0xa50 block/blk-core.c:755
>         submit_bh fs/buffer.c:2829 [inline]
>         block_read_full_folio+0x599/0x830 fs/buffer.c:2447
>         filemap_read_folio+0x117/0x380 mm/filemap.c:2444
>         do_read_cache_folio+0x350/0x590 mm/filemap.c:4009
>         read_mapping_folio include/linux/pagemap.h:999 [inline]
>         read_part_sector+0xb6/0x2b0 block/partitions/core.c:722
>         adfspart_check_ICS+0xa4/0xa50 block/partitions/acorn.c:360
>         check_partition block/partitions/core.c:141 [inline]
>         blk_add_partitions block/partitions/core.c:589 [inline]
>         bdev_disk_changed+0x75f/0x14b0 block/partitions/core.c:693
>         blkdev_get_whole+0x380/0x510 block/bdev.c:748
>         bdev_open+0x31e/0xd30 block/bdev.c:957
>         blkdev_open+0x457/0x600 block/fops.c:694
>         do_dentry_open+0x953/0x13f0 fs/open.c:965
>         vfs_open+0x3b/0x340 fs/open.c:1097
>         do_open fs/namei.c:3975 [inline]
>         path_openat+0x2ee5/0x3830 fs/namei.c:4134
>         do_filp_open+0x1fa/0x410 fs/namei.c:4161
>         do_sys_openat2+0x121/0x1c0 fs/open.c:1437
>         do_sys_open fs/open.c:1452 [inline]
>         __do_sys_openat fs/open.c:1468 [inline]
>         __se_sys_openat fs/open.c:1463 [inline]
>         __x64_sys_openat+0x138/0x170 fs/open.c:1463
>         do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>         do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #3 (set->srcu){.+.+}-{0:0}:
>         lock_sync+0xba/0x160 kernel/locking/lockdep.c:5916
>         srcu_lock_sync include/linux/srcu.h:173 [inline]
>         __synchronize_srcu+0x96/0x3a0 kernel/rcu/srcutree.c:1429
>         elevator_switch+0x12b/0x640 block/elevator.c:588
>         elevator_change+0x315/0x4c0 block/elevator.c:691
>         elevator_set_default+0x186/0x260 block/elevator.c:767
>         blk_register_queue+0x34e/0x3f0 block/blk-sysfs.c:942
>         __add_disk+0x677/0xd50 block/genhd.c:528
>         add_disk_fwnode+0xfc/0x480 block/genhd.c:597
>         add_disk include/linux/blkdev.h:775 [inline]
>         nbd_dev_add+0x717/0xae0 drivers/block/nbd.c:1981
>         nbd_init+0x168/0x1f0 drivers/block/nbd.c:2688
>         do_one_initcall+0x236/0x820 init/main.c:1283
>         do_initcall_level+0x104/0x190 init/main.c:1345
>         do_initcalls+0x59/0xa0 init/main.c:1361
>         kernel_init_freeable+0x334/0x4b0 init/main.c:1593
>         kernel_init+0x1d/0x1d0 init/main.c:1483
>         ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>         ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> -> #2 (&q->elevator_lock){+.+.}-{4:4}:
>         lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>         __mutex_lock_common kernel/locking/mutex.c:598 [inline]
>         __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:760
>         elevator_change+0x1e5/0x4c0 block/elevator.c:689
>         elevator_set_none+0x42/0xb0 block/elevator.c:782
>         blk_mq_elv_switch_none block/blk-mq.c:5032 [inline]
>         __blk_mq_update_nr_hw_queues block/blk-mq.c:5075 [inline]
>         blk_mq_update_nr_hw_queues+0x598/0x1ab0 block/blk-mq.c:5133
>         nbd_start_device+0x17f/0xb10 drivers/block/nbd.c:1486
>         nbd_genl_connect+0x135b/0x18f0 drivers/block/nbd.c:2236
>         genl_family_rcv_msg_doit+0x215/0x300 net/netlink/genetlink.c:1115
>         genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
>         genl_rcv_msg+0x60e/0x790 net/netlink/genetlink.c:1210
>         netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
>         genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
>         netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>         netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
>         netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>         sock_sendmsg_nosec net/socket.c:714 [inline]
>         __sock_sendmsg+0x21c/0x270 net/socket.c:729
>         ____sys_sendmsg+0x505/0x830 net/socket.c:2617
>         ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2671
>         __sys_sendmsg net/socket.c:2703 [inline]
>         __do_sys_sendmsg net/socket.c:2708 [inline]
>         __se_sys_sendmsg net/socket.c:2706 [inline]
>         __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2706
>         do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>         do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #1 (&q->q_usage_counter(io)#49){++++}-{0:0}:
>         lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>         blk_alloc_queue+0x538/0x620 block/blk-core.c:461
>         blk_mq_alloc_queue block/blk-mq.c:4399 [inline]
>         __blk_mq_alloc_disk+0x15c/0x340 block/blk-mq.c:4446
>         nbd_dev_add+0x46c/0xae0 drivers/block/nbd.c:1951
>         nbd_init+0x168/0x1f0 drivers/block/nbd.c:2688
>         do_one_initcall+0x236/0x820 init/main.c:1283
>         do_initcall_level+0x104/0x190 init/main.c:1345
>         do_initcalls+0x59/0xa0 init/main.c:1361
>         kernel_init_freeable+0x334/0x4b0 init/main.c:1593
>         kernel_init+0x1d/0x1d0 init/main.c:1483
>         ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>         ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> -> #0 (fs_reclaim){+.+.}-{0:0}:
>         check_prev_add kernel/locking/lockdep.c:3165 [inline]
>         check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>         validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
>         __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>         lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>         __fs_reclaim_acquire mm/page_alloc.c:4269 [inline]
>         fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4283
>         might_alloc include/linux/sched/mm.h:318 [inline]
>         slab_pre_alloc_hook mm/slub.c:4896 [inline]
>         slab_alloc_node mm/slub.c:5220 [inline]
>         kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5251
>         alloc_rmap_item mm/ksm.c:565 [inline]
>         get_next_rmap_item mm/ksm.c:2378 [inline]
>         scan_get_next_rmap_item mm/ksm.c:2565 [inline]
>         ksm_do_scan+0xbaf/0x6540 mm/ksm.c:2659
>         ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2684
>         kthread+0x711/0x8a0 kernel/kthread.c:463
>         ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>         ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> other info that might help us debug this:
> 
> Chain exists of:
>    fs_reclaim --> sk_lock-AF_INET --> &mm->mmap_lock
> 
>   Possible unsafe locking scenario:
> 
>         CPU0                    CPU1
>         ----                    ----
>    rlock(&mm->mmap_lock);
>                                 lock(sk_lock-AF_INET);
>                                 lock(&mm->mmap_lock);
>    lock(fs_reclaim);

KSM simply holds the mmap lock here while performing an allocation that 
might trigger reclaim. Nothing special about that.

So the issue (if true) is likely somewhere in the  sk_lock-AF_INET path.

-- 
Cheers

David / dhildenb


