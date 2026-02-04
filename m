Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDFBEE9D40F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340C86B0093; Wed,  4 Feb 2026 11:43:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319146B009F; Wed,  4 Feb 2026 11:43:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242196B00A0; Wed,  4 Feb 2026 11:43:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0FCC66B0093
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:43:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0DCD139F7C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:43:21 +0000 (UTC)
X-FDA: 84407344602.16.D928492
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id E95AC1C000E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:43:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=ODvhwTy3;
	spf=pass (imf20.hostedemail.com: domain of carges@cloudflare.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=carges@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770223400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oifKHjrKLZmTYhWeeUIGoTzejpK/elT/jpEKRJR5q7o=;
	b=Krw/9LSO8FMx6//GGvm/l6p+bkN6oDyq+BSj0wJKfY4bQRneoA2YAoQPzYAAf4w7CsfSiO
	mulg5r4Nb/nU40xAK4AJ3UytRUCAKlzdbfmE7zoWFNgeW0vCGOPEvoj3xb/BWYPdPGWBZ7
	QWmUMiiM7UWd+d3co75GA2N9IPWSvQw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=ODvhwTy3;
	spf=pass (imf20.hostedemail.com: domain of carges@cloudflare.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=carges@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770223400; a=rsa-sha256;
	cv=none;
	b=7hfgPq+hfCbI1Vz/JQtdCe3Uqu1R2LK6CXa/KyZbte2NE6s2SUqjYpURG42voTxv8z6LWQ
	OOm+gF00rvwYKsDnzDfUkUm0PLz9Vt3jE2smI9EDdFw1UkF1zswgrlaagmkMkY8ESM5WQk
	DCLtz55wAV2AtdfWsW7wuoWqpF1GSs8=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7cfd04f1be8so2997590a34.2
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 08:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1770223399; x=1770828199; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oifKHjrKLZmTYhWeeUIGoTzejpK/elT/jpEKRJR5q7o=;
        b=ODvhwTy34fwQdmiFaRSAtuiKdxoTpSUXc3jSKPCZuB+eSpUvk/P4DUQk76WevO4BwV
         r7Qpv9/20D7lSCnGaLLWj9TxPB8tEwppKcz2j5xqwYiD5Uor9ayRxy0dH7c1J8yDAo6R
         vWCjjW9CXTf2scn94GBTdfip12Df12n9+tBba5dbFwLF/+JJWXIYE8PkgC1xpiQcVNhF
         Jo92pGzpcgcQ6AlZTS8CuZMmpYcyB36kEq8n/EfJ0dRCi+FUFnc647S601Hd8VeL2e2n
         8W1txthbNop2PfsX567ZoklvjfEw0D4dL2z5Hk2JmGOUXNdxrPLEfs8q9jpMjv14ZwDr
         rU1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770223399; x=1770828199;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oifKHjrKLZmTYhWeeUIGoTzejpK/elT/jpEKRJR5q7o=;
        b=FXH+SE0Ui8F180N4q3oZTb5wXQURxPnLwi1l9pFiKmUMVAHUTrpa74/N7u3SKmzyM8
         V6oTrSJZuUzYZSrWVBsoELNSlH7s8/loT3xj0tqhULToDa+PxnsgkHtQh+QYPsXwI+kr
         EpoCCJRwkozedCRe/rmQxTldcMIKM6CujkgoabsfBFxkpk/rdijD0v1/2ut2hdYiva7l
         CtGemenhytkuLC1nZkg27yd34ldlERVl/9Sfe36/f+qLmB/+gsM8vntr2WfUBQftVcJ2
         u6k8zzScBgEEWNrvISHltJiDgWHZrGLUtvEtB3YUDqIsJ4QRCRL6U8hW2K6goh9lYlR0
         E5vw==
X-Forwarded-Encrypted: i=1; AJvYcCXIBiD4plEKNObAlKPtAVzXach3uLQY+V1t9sugX4j7+I1uu43LGI/56pGROa/JYFaePpC0rjtOsg==@kvack.org
X-Gm-Message-State: AOJu0Yynib5Yoxbfup/7qfd+FnAg/dggGLajm21BY+tcvy4F57Sm34M4
	uETkbuSB0mIYaFGmvG0shgbScXpieM+jTQtQb9dj5Pf8BZBbKtRYG9a9WA8to6tusSI=
X-Gm-Gg: AZuq6aIevUhhn/M4NfE0Zd1wftyCWKUcNMdMxSYCqd/7vb/lbVS46HV5XB0ovx4X0/p
	9DFW1/lhJTimjNbLZw2XSLSZZW8l961bNEDb22FkWIKhPW/IPvt5K/t5AUwNyNgiYDj/lZKRelc
	209S0VD3DTmhslvwylsQByy6rsww/FLoZUffPMLPCCzSvypdMfX3iNIdJWCIsmRIEkpqAYrF86B
	gpLSlT3yn6MBYPfeHbik9PWcauP9Gp6C12s7RFylSSz9GEo92ITGioZ5GIBmqvEsh380DE2ZLkt
	eASgfEnyAgYbrVhrUwbCU8b/dPVMS1gtM/r8FNrDNJWcjWicXtc+MntD7o76ro40N0cpatHYnyM
	XXTU5tqiL1egFs5JMm0Uy/ZUiIFXjVIIweIx+nGHEbAVnEdw6DBw4uN/OvrxEl5GD+5SWIA==
X-Received: by 2002:a05:6830:6aae:b0:7c7:6063:8e0f with SMTP id 46e09a7af769-7d4489f0fe5mr1896594a34.15.1770223398896;
        Wed, 04 Feb 2026 08:43:18 -0800 (PST)
Received: from 861G6M3 ([2a09:bac1:76a0:540::281:ee])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4491ffb19sm1956584a34.18.2026.02.04.08.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 08:43:18 -0800 (PST)
Date: Wed, 4 Feb 2026 10:43:16 -0600
From: Chris Arges <carges@cloudflare.com>
To: linux-kernel@vger.kernel.org
Cc: willy@infradead.org, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@cloudflare.com
Subject: kernel crash at mm/filemap.c on v6.18.7
Message-ID: <aYN3JC_Kdgw5G2Ik@861G6M3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Stat-Signature: qydfrprdzupccnjoam1pp1capofb95m6
X-Rspam-User: 
X-Rspamd-Queue-Id: E95AC1C000E
X-HE-Tag: 1770223399-816088
X-HE-Meta: U2FsdGVkX1+WQOloaAcMWr6K57iv4JpFmYWXg+BrAICbEwBCBBKln9vunV8CEfgnoEjNqOtJ5nZPwkT+2qxri7jHOJ4qIDNAfQBxMAwr8t5lfsZf8q49THcC09QoU/Pab/Lb27LVrPgXse/hy5WZ7bZJhMFHyyZNK3tBWL0vbRLDXJPNPmsOhwprIj61tkwWG904wDqJrpTEz6IxrCBi/9Cd3XsLVJdlDM0rz0Jh3UDtq1FoZaQbjYQbJPj8I/ZS5QZXLXsliIRYAUzFYRmuxUYxgARLYdUfVmmTgqcAGb8GBsTh4wEDYKeO2kIoXPHVGyqkTTWUBOlSR45MUtxlKPRTFRLX/PjF1aEMlZ1KgX3tFE28UL6mT1obeL2j2Q9LfC/PfUDOOafLVsbvp8LtF+76LX6d73P8/Z7sEB3DcIRHp0oQbPoZ8d7q5QJ2PqgB2WJSIl6RAmoc/X0glJTxISQ0HWiQkN96azujOE1pndXnGqDAT0YP6Q588eIh8i4jbUNroIAUC/t44Mctv1SMCkjiSSxtyLYf+zzrGz6Dz516JQrApv0um+3QWxRgFHeVaOBdvpShcblW2N3Cts/2br/pyXulDshcusboLAEq13h8MYT+uzPkXsg1bvlvRkYag8n5mUJlZ4n1MDJc3XiBSbHKFlTD1pYWU7NxOci5xa/2zLF2CR7h4m/C8VCMhOhZXUd2VVX5o458hw261LgsPpfWa0TvyrtpvPWck3VgFzDvsQPbF/Rov5xfG8PaEc4cIjEOtYHwNwmzmYW9EsLn3vMDY13Z6siLhqugATYceiH5vWhRdyItGyat+xLDQmbj6uPljdPzuT4ZeuLI3ogWWzW8xf5+LO3pOubnpTRY9d432wb1K3P530DAqeLtcFW8/TDWQb39Ih7Z2hKB7rK2CyawO2ZrigmnyHGyjk2bJPWIXk9/lQpEZIPKj9LoHawgWV10AHUsZVOAYQGW56x
 Ok52nKMF
 hmupIrK8BmULJrBe/gnlf1tym1sBzApzz0m0HhrKv+vEit4/t1qW+nI9FujCO+h4dpyZeyxuT4pRaTgmFMJOKY6Qjflmc8hn+2zV2sbhZCLabgp9XnrtNAOh7xPj2PKmnlSMsCst4QhRfpmDYsLmc2UI7oIwvMlGahqSS3u05odNrUYgsJTtdxZ+LwhqerwlDYvElFngFgrELa/9lv6WvvkbFlZEdeYrqYQkjHKfJBOyUqlHmxTUjn3Nvn1i4owhTiKnvsZ7+1CrpI8PK5HQujCIUxAwFnNBeazz75XbkZ/c5awebvfYeOXWByHRvwm6EVjRYTzoxlgQk5xT9iSd5NAB9K9QIioyNggbTAOqelpocWaAWKhgfgMZQVFzp9y0nnbU7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We got the following VM_BUG_ON_FOLIO assertion failure on a v6.18.7 kernel
at mm/filemap.c:3519 in the filemap_fault() function. The crash occurred
during a page fault while journalctl (pid 3666669) was reading a file on
an xfs filesystem. System was under memory pressure.
This seems like some sort of XFS/page_cache race.

Backtrace:
```
page: refcount:2 mapcount:0 mapping:000000006db8c9ab index:0x7652 pfn:0x2af2802
memcg:ff25824893476540
aops:xfs_address_space_operations ino:c0000c0 dentry name(?):"system@951e885c16c946debbe32b18d75328c2-000000000cc0fd3c-00064"
flags: 0x2affff80000012d(locked|referenced|uptodate|lru|active|node=10|zone=2|lastcpupid=0x1ffff)
raw: 02affff80000012d ff8c4b17ebca0008 ff258260eda3d3b0 ff25825437d792a8
raw: 0000000000007652 0000000000000000 00000002ffffffff ff25824893476540
page dumped because: VM_BUG_ON_FOLIO(!folio_contains(folio, index))
------------[ cut here ]------------
kernel BUG at mm/filemap.c:3519!
Oops: invalid opcode: 0000 [#1] SMP NOPTI
CPU: 7 UID: 0 PID: 3666669 Comm: journalctl Kdump: loaded Tainted: G        W  O        6.18.7-cloudflare-2026.1.15 #1 PREEMPT(voluntary) 
Tainted: [W]=WARN, [O]=OOT_MODULE
Hardware name: Lenovo HR355M-V3-G12/HR355M_V3_HPM, BIOS HR355M_V3.G.031 02/17/2025
RIP: 0010:filemap_fault+0xa61/0x1410
Code: 48 8b 4c 24 10 4c 8b 44 24 08 48 85 c9 0f 84 82 fa ff ff 49 89 cd e9 bc f9 ff ff 48 c7 c6 20 44 d0 96 4c 89 c7 e8 3f 1c 04 00 <0f> 0b 48 8d 7b 18 4c 89 44 24 08 4c 89 1c 24 e8 0b 97 e3 ff 4c 8b
RSP: 0018:ff4ac5c342ccfcb0 EFLAGS: 00010246
RAX: 0000000000000043 RBX: ff25825437d792a8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ff2582406fb9c4c0
RBP: 0000000000007653 R08: 0000000000000000 R09: ff4ac5c342ccfb48
R10: ff2582986cc3ffa8 R11: 0000000000000003 R12: 0000000000000000
R13: ff258239e9fbf740 R14: ff25825437d79138 R15: ff4ac5c342ccfde8
FS:  00007efd812b2980(0000) GS:ff258240d7be4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efd7ec53a08 CR3: 00000021f5891005 CR4: 0000000000771ef0
PKRU: 55555554
Call Trace:
 <TASK>
 __do_fault+0x31/0xd0
 do_fault+0x2e6/0x710
 __handle_mm_fault+0x7b3/0xe50
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_mmap+0x48a/0x670
 handle_mm_fault+0xaa/0x2a0
 do_user_addr_fault+0x208/0x660
 exc_page_fault+0x77/0x170
 asm_exc_page_fault+0x26/0x30
RIP: 0033:0x7efd8187c3dc
Code: e2 ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 41 55 41 54 55 53 48 83 ec 18 48 85 ff 0f 84 bd 01 00 00 48 85 f6 0f 84 d4 01 00 00 <48> 8b 5e 08 48 89 cd 48 85 db 74 60 48 83 fb 0f 0f 86 86 00 00 00
RSP: 002b:00007ffd3e56e120 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000007653a00 RCX: 0000000007653a00
RDX: 0000000000000003 RSI: 00007efd7ec53a00 RDI: 00005653db23c150
RBP: 00005653db23c150 R08: 0000000000000010 R09: 00005653db23c188
R10: 0000000000000001 R11: 00007efd8187d3d0 R12: 0000000000000003
R13: 00007ffd3e56e1b0 R14: 0000000000000001 R15: 00007efd7ec53a00
 </TASK>
```

Some crash analysis showing the index variable requested and the mapping's
inode number matching the file in kmsg.
```
crash> files 3666669 | grep 0fd3c
 28 ff258239e9fbf740 ff258241714d7380 ff25825437d79138 REG  /state/var/log/journal/a8313fd61d2511efaf3fb49691bc0851/system@951e885c16c946debbe32b18d75328c2-000000000cc0fd3c-000649d02a75bf77.journal
crash> struct inode.i_ino -x ff25825437d79138
  i_ino = 0xc0000c0,
crash> p mapping
$2 = (struct address_space *) 0xff25825437d792a8
crash> p -x mapping.host.i_ino
$5 = 0xc0000c0
crash> p -x index
$10 = 0x7653
```

Frame and dis:
```
  #7 [ff4ac5c342ccfc00] asm_exc_invalid_op at ffffffff9460123a
    [exception RIP: filemap_fault+2657]
    RIP: ffffffff94b3ace1  RSP: ff4ac5c342ccfcb0  RFLAGS: 00010246
    RAX: 0000000000000043  RBX: ff25825437d792a8  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 0000000000000001  RDI: ff2582406fb9c4c0
    RBP: 0000000000007653   R8: 0000000000000000   R9: ff4ac5c342ccfb48
    R10: ff2582986cc3ffa8  R11: 0000000000000003  R12: 0000000000000000
    R13: ff258239e9fbf740  R14: ff25825437d79138  R15: ff4ac5c342ccfde8
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018

crash> dis -d filemap_fault+2660 16
0xffffffff94b3ace4 <filemap_fault+2660>:        lea    0x18(%rbx),%edi
0xffffffff94b3ace7 <filemap_fault+2663>:        mov    %r8,0x8(%rsp)
0xffffffff94b3acec <filemap_fault+2668>:        mov    %r11,(%rsp)
0xffffffff94b3acf0 <filemap_fault+2672>:        call   0xffffffff94974400 <up_read>
0xffffffff94b3acf5 <filemap_fault+2677>:        mov    0x8(%rsp),%r8
0xffffffff94b3acfa <filemap_fault+2682>:        mov    (%rsp),%r11
0xffffffff94b3acfe <filemap_fault+2686>:        jmp    0xffffffff94b3a5bf <filemap_fault+831>
0xffffffff94b3ad03 <filemap_fault+2691>:        mov    $0xffffffff96cd7ce8,%rsi
0xffffffff94b3ad0a <filemap_fault+2698>:        mov    %r8,%rdi
0xffffffff94b3ad0d <filemap_fault+2701>:        call   0xffffffff94b7c920 <dump_page>
0xffffffff94b3ad12 <filemap_fault+2706>:        ud2
```

Seems like rdi should contain folio pointer. However the mapping looks to
be NULL.

```
crash> struct folio.mapping 0xff2582406fb9c4c0
      mapping = 0x0,
```

Happy to run experiments, tests, and get more data. So far I've seen this about
6 times on various machines (both arm64 and aarch64).

--chris

