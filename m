Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E11E4CD4F42
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 04:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095376B0092; Fri, 15 May 2026 00:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045DC6B0093; Fri, 15 May 2026 00:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77116B0095; Fri, 15 May 2026 00:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6A1E6B0092
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:06:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C7001C16FF
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:06:02 +0000 (UTC)
X-FDA: 84768316164.03.8828A76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 437C71A0007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:06:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bWC0mPvU;
	spf=pass (imf19.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778817960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZ+iLTZST8FxP/oRfZ0ADx0fv2jSubDq1lGkoIHgCgI=;
	b=svM6SuP2kAsbd74n3lgVXvf7FBEi5Z29ECGCuOfUM8lscx5SVaI018o+sTK0FzZ5vwlIqp
	iPFujf0ZtT5OtFDvlgLfOCWWqwzDsKgiq7mSpW65g+mB3nVycINTFd6bGZZwJOtUmslN4i
	jlaL1wXlzYFToLakXNKzzoGt/PF6eZc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bWC0mPvU;
	spf=pass (imf19.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778817960; a=rsa-sha256;
	cv=none;
	b=UuFhkdEg695vTkwpT3M8oH5SOmdTCENgCrMdFTcBMdKkXHDKOZbj24FMQtoGeDrKoXPWU4
	TNXFvjZUV+6cNqWQ0zUxrbD0+5XsCjbKFRNIM3C+SUPAC+CUsD+e7fWXl9v2dTTAbMqm5a
	a774OEkugwwRjrE3hChx9xvwlXiY+zw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778817959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZ+iLTZST8FxP/oRfZ0ADx0fv2jSubDq1lGkoIHgCgI=;
	b=bWC0mPvUAfZM67c3PJ+2zOHj5nMTjx+yJ2g490jGY4xobZ9Jx16/5ctkulzVX3uCSfKYbG
	3A9uC/IiuQXo6hxCKzpdqpmcOFH8yYv/NDfwJGWSO8nzMLt03PwM3NFXHpqmZhEyQtuqan
	H5uDsIbZDRq9/et3dEws2NimnI/GhJk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-J81_ydOOMyKnt-z-W29Tyw-1; Fri, 15 May 2026 00:05:56 -0400
X-MC-Unique: J81_ydOOMyKnt-z-W29Tyw-1
X-Mimecast-MFC-AGG-ID: J81_ydOOMyKnt-z-W29Tyw_1778817955
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a894c2d57cso1271857e87.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 21:05:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778817954; x=1779422754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aZ+iLTZST8FxP/oRfZ0ADx0fv2jSubDq1lGkoIHgCgI=;
        b=KkfWY9szF/x1U4r1VycYnPFBml0nv5jNTnpCIAJWiRiMOc12MFtb7IoJX5Fk2gXJBd
         e9XNRo/T5QgWFd8xUMyMOpBeFY273XV1zbdbp1UHulIfW3Gyl1bnXpTGRDGlH033iMmo
         E5hkpiw55aev8+AZUzkwEOMSWIdyZgQ8BSQwCwiTYu8yJfeYd4nBGXDSMNvleAFkEmPn
         UNO3Z+aBhFVBgsLo6WxR0UWVbKkzJKQyDOIn684QvtsTT/ST1Y/+VUsb9GRlfVbhqco0
         gSYmb1aZ69hf+fmBasJMoTgaDKI/X+WZOspc8Ua+itxTQp4bEtzPuALgH82e02vJyMex
         uljA==
X-Gm-Message-State: AOJu0YwMC4SkX75YU86gN5YBXSO6GT6qX7Dmy5Xj5UkINJ2vXzFJSAfz
	Vk1mwFaLYsuTj6r65FadfoWEUL8hD9CfQx0r6ik+9rIpwP4+2l3Bv4XzmvnHO4mxSdnG0GX3ib9
	VI15F3izPh0Y6SgFsVElVjOULzzxezUbAI9vWq/gBFnJofF/iySA=
X-Gm-Gg: Acq92OFB8F49m8p7Jq3pUqZngCx/VKfASMH2aP7TLy04lPghezL4OhpoS+cEoBeJqeB
	nu6+cnuXmVm6IPgwyY9E2vX4vwpjY//6RsYoHMAWGq5yueITVbyrr/zug3UyFQK+jA3K11fQtuE
	swwEmmjCBjPZgGb5mEIEA9HsDh9Da8m1FEkVMXLCu6c+HnQiSVvqjiFgtgenlTMKMMDMxg76gSu
	b0FFak60D1C8+WQo22eYNR4Ti+VcglEfH8HNwFEAvN+l+lpN8Arv9DdxA5IIl9kN7lh0CLdMorz
	iuEFd50KUdgXCvV1rfMNQeMg0k6PRChUU/YYqagKAjra/1zsc23jEijAOkjc+MumVtnQk6/wFba
	abt1qT80WzFh0eYpe8nQ+ZHj9nzwpXJPd+t/KaGBwjG+8QOg=
X-Received: by 2002:a05:6512:2397:b0:5a8:9909:50b1 with SMTP id 2adb3069b0e04-5aa0e610e9amr452531e87.10.1778817954386;
        Thu, 14 May 2026 21:05:54 -0700 (PDT)
X-Received: by 2002:a05:6512:2397:b0:5a8:9909:50b1 with SMTP id 2adb3069b0e04-5aa0e610e9amr452515e87.10.1778817953842;
        Thu, 14 May 2026 21:05:53 -0700 (PDT)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a90f11a7c2sm932482e87.32.2026.05.14.21.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 21:05:53 -0700 (PDT)
Message-ID: <2fe8d022-a414-4b23-af4f-9cecf1aac3d1@redhat.com>
Date: Fri, 15 May 2026 07:05:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/5] Migrate on fault for device pages
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260505184421.2324798-1-mpenttil@redhat.com>
 <agaN29W7hAklrCxz@parvat>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <agaN29W7hAklrCxz@parvat>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q9TBAXrdwaZQ43tmq9YSChK82hUwIs5exW4U1bcHVUc_1778817955
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 437C71A0007
X-Stat-Signature: ghkrqmzaqzsuynqpn9gpnwab44obdeu7
X-HE-Tag: 1778817960-869426
X-HE-Meta: U2FsdGVkX19LMS26RqbWNUD3/8eJkCnbIwtmVw0j06WbW6EaEAugFYLmM1G1S/ENrbb+gID1CI9VCzSVNCjFfM+FtRKXzUmCxmlPaWB9JgvZgeRXX4X0UtIAl2gKz7kQba3pnvndRw1FQATJ1zTTZCkt3G7GkJ/MmQfGwCoo9x2erTvvxuwmnuxFkDtQdIrutrRyjTmYw88JAjY+WWnudrWGub5kj6zSB6VYu5adrnPxaLhc/89bVazEutMyZtYqDIfUCfLf3aIGdsdR0TixC9LcSKcd+vCA6Sgisq+HwxY0hl/pZ7WNiRU5Uvoo4gRzfnYNO/9FJX+T8fGeJErYTN9ALfi17OdP5HibTvTOJ/uaB/J902nYmWszf2omNP4lyDBkYhE2Ul2Tjp6G8yVylbEv8qaH3FREh1ayfYCuNIIatUkL/P6PL1cPkxl8iROCr5Rbx1lob413DcpexqhPghkE2JQDPINYs3kcLtnz8RxE8KgPndKfj7kowFSPpqOeowvUGShsS/k993TL4C9jU79fUCbEiR+gferUTSGnEWtxk+ofc9okbto6ktHhYP0QqD6F+PXHYYVS52+hBfVSSVHHKvq2iHPkNlMqHqJRF24ZNb92R1tRRZMbGX7vmw0F7P6poh+3y69hHIjPKjLg0HlBhk58t/1l6aOBVCyPjO1AaGQcNBMlr8ADsf0wFQLWdMJXX20f/t7YXbz+Q6r4lt298a+Aj0iQXNnZdybnb+HBbPvysX2LPpq8Q2S2ns+Ke9TV/JYCzu3SSW1GjPQLplFwUMqBQqx37n1eRJOChMf5syJaeN3418scr96TtqPC03C11jaAKeK5OZ433C/az6c6FZdvdxP9Zkr4Q8T7TkNO713OvfeASY0Pbgtbt5wUuEVrndfkfjp+LUpknD6J0e4XHd64WKSB58wUuGCNqtwmSEgG+0Pd9RSn4UTNTBQnXR48lXRH87aMny1XPQO
 DLpt3ZA4
 /ZvAAjrwK092SxpTTDrdrZqiIaBfKHKE4qWe7AWSYkuLm1vJkdFixvKeADESLJjHNmgkMGCDOAf/GVTnuQ76a/6jCF1W+1G5InwmwupEuq6GHWI47/ozCicLKZif3UorXzIgkmwkX68LJSVSH2BfYVx/wS3IZ/r7u9hMMpAsI9DAnGSNh4+7FOxCNK/Uiu6jtcqPs6kOaab/GEdgzv7jih2IwHDFFne6BbGJuhqTZTBcQmZkoGjPA8azclQ4FLmleP8EgpzwhbzFPIulQ+vdcSkB2UGX2tmcZOzC7+TPa8QCpdpKWmQb480tvuh5o9GxeOBT1f7b8XMU1YEQqhpqO5UmofaW5MVN68B/ntNgjtS+LL+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> FYI: While testing with hmm_tests I ran into
>
> [  107.866004] ============================================
> [  107.866284] WARNING: possible recursive locking detected
> [  107.866577] 7.1.0-rc3-00311-g4277273ca0e1 #12 Not tainted
> [  107.866877] --------------------------------------------
> [  107.867217] hmm-tests/1098 is trying to acquire lock:
> [  107.867491] ffff888113571b38 (&mm->mmap_lock){++++}-{4:4}, at: dmirror_range_fault+0x147/0x610 [test_hmm] <- line 368 of lib/test_hmm.c
> [  107.868076] 
> [  107.868076] but task is already holding lock:
> [  107.868383] ffff888113571b38 (&mm->mmap_lock){++++}-{4:4}, at: dmirror_fault_and_migrate_to_device.constprop.0+0x3aa/0x6a0 [test_hmm] <- line 1267 of lib/test_hmm.c
> [  107.869076] 
> [  107.869076] other info that might help us debug this:
> [  107.869415]  Possible unsafe locking scenario:
> [  107.869415] 
> [  107.869729]        CPU0
> [  107.869866]        ----
> [  107.870054]   lock(&mm->mmap_lock);
> [  107.870247]   lock(&mm->mmap_lock);
> [  107.870436] 
> [  107.870436]  *** DEADLOCK ***
> [  107.870436] 
> [  107.870743]  May be due to missing lock nesting notation
> [  107.870743] 
> [  107.871158] 1 lock held by hmm-tests/1098:
> [  107.871377]  #0: ffff888113571b38 (&mm->mmap_lock){++++}-{4:4}, at: dmirror_fault_and_migrate_to_device.constprop.0+0x3aa/0x6a0 [test_hmm]
> [  107.872081] 
> [  107.872081] stack backtrace:
> [  107.872348] CPU: 1 UID: 0 PID: 1098 Comm: hmm-tests Not tainted 7.1.0-rc3-00311-g4277273ca0e1 #12 PREEMPT(full) 
> [  107.872350] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20260213-6.fc44 02/13/2026
> [  107.872354] Call Trace:
> [  107.872357]  <TASK>
> [  107.872358]  dump_stack_lvl+0x5d/0x80
> [  107.872385]  print_deadlock_bug.cold+0xc0/0xe2
> [  107.872393]  __lock_acquire+0x10cf/0x1b90
> [  107.872400]  lock_acquire+0x189/0x2f0
> [  107.872401]  ? dmirror_range_fault+0x147/0x610 [test_hmm]
> [  107.872404]  down_read+0x9b/0x4b0
> [  107.872420]  ? dmirror_range_fault+0x147/0x610 [test_hmm]
> [  107.872421]  ? lock_acquire+0x189/0x2f0
> [  107.872422]  ? __pfx_down_read+0x10/0x10
> [  107.872424]  ? __lock_acquire+0x3c2/0x1b90
> [  107.872425]  dmirror_range_fault+0x147/0x610 [test_hmm]
> [  107.872427]  ? __pfx_down_read+0x10/0x10
> [  107.872429]  ? __pfx_dmirror_range_fault+0x10/0x10 [test_hmm]
> [  107.872430]  ? __lock_acquire+0x3c2/0x1b90
> [  107.872434]  dmirror_fault_and_migrate_to_device.constprop.0+0x3bf/0x6a0 [test_hmm]
> [  107.872436]  ? __pfx_dmirror_fault_and_migrate_to_device.constprop.0+0x10/0x10 [test_hmm]
> [  107.872439]  ? find_held_lock+0x2b/0x80
> [  107.872444]  ? dmirror_device_remove_chunks+0x5b8/0xa00 [test_hmm]
> [  107.872445]  ? __is_insn_slot_addr+0xee/0x1f0
> [  107.872458]  ? lock_acquire+0x189/0x2f0
> [  107.872460]  ? avc_has_extended_perms+0x234/0x1350
> [  107.872476]  ? __might_fault+0x89/0x150
> [  107.872484]  ? lock_release+0xe1/0x320
> [  107.872486]  dmirror_fops_unlocked_ioctl+0x9ba/0xdb0 [test_hmm]
> [  107.872488]  ? ioctl_has_perm.constprop.0.isra.0+0x2fe/0x6c0
> [  107.872494]  ? __pfx_dmirror_fops_unlocked_ioctl+0x10/0x10 [test_hmm]
> [  107.872498]  ? count_memcg_events_mm.constprop.0+0x22/0x1a0
> [  107.872499]  ? __pfx_ioctl_has_perm.constprop.0.isra.0+0x10/0x10
> [  107.872501]  ? count_memcg_events_mm.constprop.0+0xaa/0x1a0
> [  107.872503]  ? lock_release+0xe1/0x320
> [  107.872504]  ? find_held_lock+0x2b/0x80
> [  107.872506]  ? exc_page_fault+0x7e/0xf0
> [  107.872510]  __x64_sys_ioctl+0x13c/0x1d0
> [  107.872521]  ? lockdep_hardirqs_on_prepare+0xd9/0x190
> [  107.872523]  do_syscall_64+0xf3/0x6a0
> [  107.872526]  ? exc_page_fault+0xde/0xf0
> [  107.872528]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [  107.872529] RIP: 0033:0x7f7381c543ad
> [  107.872531] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
> [  107.872532] RSP: 002b:00007ffc3160a9b0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [  107.872539] RAX: ffffffffffffffda RBX: 00007f7381b44000 RCX: 00007f7381c543ad
> [  107.872540] RDX: 00007ffc3160aa30 RSI: 00000000c0284803 RDI: 0000000000000022
> [  107.872541] RBP: 00007ffc3160aa00 R08: 00000000ffffffff R09: 0000000000000000
> [  107.872541] R10: 0000000000000022 R11: 0000000000000246 R12: 00007ffc3160aa24
> [  107.872542] R13: 000000000041f380 R14: 0000000000000200 R15: 00007f7381200000
> [  107.872544]  </TASK>
>
>
> Thanks,
> Balbir
>
Thanks, I could reproduce. Had lockdep dropped off so went unnoticed. It is nesting mmap_read_lock in the test suite, I will change that in next version.

--Mika



