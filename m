Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD0BCA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E508E0019; Fri,  5 Sep 2025 09:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25E68E0009; Fri,  5 Sep 2025 09:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914998E0019; Fri,  5 Sep 2025 09:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F13E8E0009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:27:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10DEE574A5
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:27:49 +0000 (UTC)
X-FDA: 83855274258.18.FB2A606
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id A4F9FA0009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:27:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hDtbE4C4;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757078866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+HJzw3vtqVXsw40E0BOixM6XDjjd+gcatIWkGtLLJo=;
	b=540O2oXqDZ67O6cxVpytk5e/NkRV4aOCfkOZjNuEer05zW5D+XqnJFn/OCIZs0CQ0TGtiG
	4gAv4j3Rvo/TseIE740VVcFDbUSx+JPBLD+8SAoa7EhOPNdXq11hP71TtMN9YfrJxFSFTl
	ahdvUbbMXH9UqvsbIeNHqKA1wJDdeGE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hDtbE4C4;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757078866; a=rsa-sha256;
	cv=none;
	b=pWjlZFR2xetSyEPLAIO0hXaDdqQCgDAOa9+TlWkeIgnUi0x+YC+0moUfPtoIbMc65izc1X
	5sxrSY6abZkaz0PdyAx2YKXZzJp/hyoTQZKDOEi+2Ext9z6U2lflfzazzNHOc7ha2F7E47
	ibKeo7he3GE+KDcwBn53vwQD3HEAG/Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757078866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w+HJzw3vtqVXsw40E0BOixM6XDjjd+gcatIWkGtLLJo=;
	b=hDtbE4C4jwB4pJVjb/mE2Nr0/PNUPbErgbQv3bpJGSeBGz+7ShMgIT6baUcGfHijs95oRi
	QV1WTwukHmzG4IKFLu3MZmD5ud2HtK4JB20mfZiYyn+8DQF+eyK6yC9FQMEsm0aX9Fjldh
	o8QldfpEWAPKEGlQi07/g+3HDlFZYdE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-u-EaJh9DPT-WC7mDckmYgw-1; Fri, 05 Sep 2025 09:27:44 -0400
X-MC-Unique: u-EaJh9DPT-WC7mDckmYgw-1
X-Mimecast-MFC-AGG-ID: u-EaJh9DPT-WC7mDckmYgw_1757078863
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e1260394dcso1081026f8f.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 06:27:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757078863; x=1757683663;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w+HJzw3vtqVXsw40E0BOixM6XDjjd+gcatIWkGtLLJo=;
        b=vBDdzfvZMm1UwC+lWcFElcqruL9Q/2RbXltKdsRF2Rs/MeqnHKH0DZiLDlXUkukqxo
         t49YhVPe7z5SoD3ivWajJl0JQRTzjEVG6UlpsvzikBZskIHGtobIHkaSBB9n7NIPYp96
         /vXKKoUT9WoAn7Ao0e6wdmIEda5vhUiZ8crqBtDZZBZFYZ2QVN/QaUh2chLblbLs70t2
         Lqp5PhGlVeq8gcHd3ptXRWcN9VcE21qzGOKmh005BD9OAEDs2GwNBD0PdD/2QTo5QaUW
         nMt519TJoP3ZN5RRPSuXYc7p78bIRcYAHElUoT41CcosJl6zA6+1DQ1P6bqKe0hhFMqr
         p5XQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTR+pY6kYsB6TIo12e3293A5ex2KRtNr67ccxKS9DyPF0/7i/0VjynyNMuxVuD3j2Gk5e2zEmhEQ==@kvack.org
X-Gm-Message-State: AOJu0YyHys56KYyE6Fe29pOaBT4J+5rrcTfMk6MlIgEYRlxHriVGRNGZ
	DP2kUwwt3SBR4LB/adYOR8gA+TkRMx0trC0ictheNZ29DuS8tIwRKQ8KjKXplk6NIS1K2r0Uxn7
	/jp+qMB2x9SDdnxzL/g6HAlwiDyjze/wzQa/wENaj4BPtqWgkcacR
X-Gm-Gg: ASbGncvBDQcpxhogbzDvBa33xPVzNSSUOgOvKsmSYJidNhTtmzSPeiw4tXa+REeLcwH
	lkIH3gNZ9I/dMU5b9u3TfO4OqOmkl41TdsS7DXPFa3vA/jWbNozw60sI0KmFY4zhBFYxq/UXMQH
	KWZahU3MVFFy5XQbasHogp2cfi4Nk2u+sIvBgsE52PoWpMq01L1mhaSxBDmHDsUyXnBw8BODPaQ
	+nKjIAtGaDNRk6TleWjL5HJrZmqHOdqDd698j+u2w10IbVo4n5LHRK9DgTgpumLAqqQ2NoTE78l
	pc5JpMkI82zY+C1v+K/4/Am0njlE+uUBLPSyZR2R7I/VIGtaSOrirWCpteuF82Ibfw8NK6UZj2z
	qKvlTUSk+nFIaGzH0Zxz+lZDJw4m3WOe1iiMOXLRcg5vrj3rBU0f7LFxI
X-Received: by 2002:a05:6000:2112:b0:3d2:6129:5505 with SMTP id ffacd0b85a97d-3d261295a85mr15734975f8f.36.1757078863090;
        Fri, 05 Sep 2025 06:27:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZVGmOwcxzS6bCHYMi5kxOeAkyusM/0MaTTJuiCZfznajBXiRf8SwJWTPxKS7bzDRNkpDXeg==
X-Received: by 2002:a05:6000:2112:b0:3d2:6129:5505 with SMTP id ffacd0b85a97d-3d261295a85mr15734950f8f.36.1757078862585;
        Fri, 05 Sep 2025 06:27:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3dedea839c1sm9930047f8f.63.2025.09.05.06.27.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 06:27:41 -0700 (PDT)
Message-ID: <4a0c3727-9043-41e3-a5b4-fd3763c94d05@redhat.com>
Date: Fri, 5 Sep 2025 15:27:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] general protection fault in
 unpin_user_page_range_dirty_lock
To: syzbot <syzbot+0d2f32dad7098551e15d@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, jgg@ziepe.ca, jhubbard@nvidia.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com,
 syzkaller-bugs@googlegroups.com
References: <68bae4ce.a00a0220.eb3d.0014.GAE@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <68bae4ce.a00a0220.eb3d.0014.GAE@google.com>
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: Xdsus74Ryk91UtaIcQLg9wA1gavt4JDjSSIqzmTinbg_1757078863
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A4F9FA0009
X-Stat-Signature: n3d4i6rzttt84nfatgizebyp3j7s9u4d
X-Rspam-User: 
X-HE-Tag: 1757078866-401189
X-HE-Meta: U2FsdGVkX18+dpLCx+WxqM9+/ZjO4NIBWAzyMa9t2dLjGDki+GI/N3Vx+EtEZhmoUQ0+diWT3/WcmVUFUw1ker5uJ+RcoKeFLFgZq4Ll/9wjr+GZnK0DEYLhKU8bbTmNTfx9RRxC7BKsk5dGi/Y3RexyH02Sq/FedxETKh1DXQ9ImXtyVJE/OtE0XsZrUL4jApIFwr4UgHhBBzCJwA/6bRBldCRa6FecGiuEO7TV+KVlW6gP6ljoC9MOEdEYRvoGyck0NIuDSlm1bX8ha0rKmHbh/XHAYGSHOjna4+IINKzcYGI3R8PjNzGRa0R2rtnYF+BdMEjZMyuGg6jGxsZsN4w4fwPcDexPwr2Dr+5TYRhOJFxlUa9m8gxtFUe4UDNlCiADHpnvguiaWMEC8vYdIjj2phSlYC6uJJHCrWoWi5B1CqB0YFeuz7Qqr+B5pk18TS+Vc7agS2qwcW/TOl52iAj1H72m4oDGQXh0XI6GtehYPyCjJBJUQ09vChRb9N/nkxAepS7IDR36qxAZwm0QwHFBxhtinsaCIry52WHjsZBMRygorzW4PqQyywNm1luTTIuD2ch2OtGhdEXLZcUz451boi+PQekvROvDNU3vnrB2T78KaQEieDg7ni3xlUlqBfLi8gM3qjL21ywnkMtEboP+b5X8T+nBSzXNmz15QVZlCk+mnJet3zjb9bHvypTjV/wAj+Mdg4PFDS2m/cR9hAQ66STqq45lIgDsz/53xJgfWdb5Fw5GCZDSBmsZ8UH3TmDXgpMBigOeoQaqg19TWBza+RQPXShmrsrtQnQcIjGCpLV7LHjcSEodtfhNuI/angXl79CdX+xoSfl/a08TxIrK8yutoDX4VoaNadO1qRdo9iCczPSamkSYm4nhWzB8zf/kT1omutkV08IeifL/6JImT2wz8N3yh+uM46G3/Kc8+s2Ff47Dyibiwv8ppLX3AFBhkQSRX/DcR5Pi73u
 od+kG30T
 V0n3FDleXPPGMvATHci8DYKFSmPdWVJ1ZP80KNcwIk6uA4RMIiZzviNZgQhmlvSvZI3sdYkKTOSUgN23Rn3HJ5Nj7tS3oln+AESMS2fMpmqTOWacD3FlJ4JJLy7GaXwRSZBZKuLVqbWU/pT57ZQMSSJMNdVaB0M9/ZHASz1MkL36yz8LGpRaBwuZgBayv07V2XQRiy+L0fHwiU8yWFGJ5I5LRyq9U0hRrxJMnpMG0ztvi01IIXssA3ja83yfyDCrBfPG/b/bge/KUmq5Oul5Rd7Q2URcCWULuM6HZIumRskw8tb+R3Bxuh0+jg8q38VPQpV0iN8KKoZIiUfquxp0HoSa5xrP9StecLal6LNrdXeyV+pjnrdbTQvduarAE89JpiuUjNIprFmZ+zSi18wqwRoBKtRJVeYj8uD6kK1nSCfE4CaVVPtz5Cd8zhmQXUtbqoXdQLhfJ57k6P96hs6WD1vO+2xzVCp41AcFgOy8byV/eBXQxQFr2nBHAYB18s5RE/vZfViE/gUhUPicLpA8Ju44NLMONeSMPArs58LXw8dyoZ0PpjspOddag9iuGHcbjRG4VJFlOo6rOANMpydZikCRCq+s7kNqi+niNYyq/YIV0ZGqb1zLZB6CRygB4pwhOdh9ccqRehkOiExGAUboeVLrMU08xxYkQsssyNZyLnWIe+x7t1GMvbtHVJnzJA3n0ReupgyutpuPOeLks2lclvi+9+FkF90Ec+PA+gTXy/6vNpFcqK3C+/s9cDOeywQOTePeRHApeYvSKqoFvgBu0bcttaBvyq73KULbFB1ektpGbDdtgLfdP7SinkIILBRK6tFNBDqTv76M2nuPD1HDt/5WmOI0Ej5SsPwjxN6g6LBsPj8G+HfXeRgXABIkXzdGmAe0zY/X5AeFco7VoqYU81WjdM7UvPfAU0atrXxC6NgEcjrvRVr2xoNZzJlUvLYEjC6yP03Vat3/LwDicCuFnfxPWu9xZ
 9ESqU8v/
 JpK7t5N/3NI39VKvGKnd9DxtjmJx9N6sePEmn7lAqYF9VYBbO9NWXc5IeLUhxUrEqWOjFhpdKPR8vht58f3uHpTFIRiiF6U22knfmc5e5xEeFdsaDcNn/Sfm06EFhSCT+YX8VeYpEgt8nTE2D+pk4d20SikAOXialwfXueigv4SFv3QnOZon7W+n7jUNMKrLijTjFZxmbuG0EPQrlSrFKTUuEGlMaIVnEH+1JAlm5LgcgKHFncwPe6ToQv4QCoBeYHvb94K7ex9jOMUNX0HTtG7IRQusGqHSGPgQ3IpoJkgARUp4yU4wDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 15:25, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4ac65880ebca Add linux-next specific files for 20250904
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=138b087c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fbc16d9faf3a88a4
> dashboard link: https://syzkaller.appspot.com/bug?extid=0d2f32dad7098551e15d
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a8a134580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=159de962580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/36645a51612c/disk-4ac65880.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/bba80d634bef/vmlinux-4ac65880.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e58dd70dfd0f/bzImage-4ac65880.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0d2f32dad7098551e15d@syzkaller.appspotmail.com
> 
> mmap: syz.0.17 (6062) uses deprecated remap_file_pages() syscall. See Documentation/mm/remap_file_pages.rst.
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 UID: 0 PID: 6062 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
> RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
> RIP: 0010:gup_folio_range_next mm/gup.c:241 [inline]
> RIP: 0010:unpin_user_page_range_dirty_lock+0x63/0x4e0 mm/gup.c:369
> Code: 45 31 ed 4c 89 74 24 18 4c 89 6c 24 10 49 c1 e5 06 4b 8d 1c 2e 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 ff 3e 1c 00 4d 01 f5 4c 8b 23 4c 89
> RSP: 0018:ffffc9000413f6d0 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000008 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: dffffc0000000000 R08: ffffea0002d10037 R09: 1ffffd40005a2006
> R10: dffffc0000000000 R11: fffff940005a2007 R12: 0000000000000002
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000555587af6500(0000) GS:ffff8881259fa000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000000 CR3: 0000000074024000 CR4: 00000000003526f0
> Call Trace:
>   <TASK>
>   batch_unpin+0x3eb/0x560 drivers/iommu/iommufd/pages.c:691
>   iopt_pages_unpin_xarray drivers/iommu/iommufd/pages.c:1711 [inline]
>   iopt_pages_unfill_xarray+0x813/0xaa0 drivers/iommu/iommufd/pages.c:1747
>   iopt_area_remove_access+0x2c4/0x3f0 drivers/iommu/iommufd/pages.c:2196
>   iommufd_access_unpin_pages+0x33b/0x4e0 drivers/iommu/iommufd/device.c:1357
>   iommufd_test_access_unmap+0x28c/0x300 drivers/iommu/iommufd/selftest.c:1448
>   iommufd_test_staccess_release+0x6a/0xb0 drivers/iommu/iommufd/selftest.c:1489
>   __fput+0x44c/0xa70 fs/file_table.c:468
>   task_work_run+0x1d1/0x260 kernel/task_work.c:227
>   resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>   exit_to_user_mode_loop+0xec/0x130 kernel/entry/common.c:43
>   exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
>   syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
>   syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
>   do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fdd6e78ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd897539d8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 0000000000019b27 RCX: 00007fdd6e78ebe9
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000789753ccf
> R10: 0000001b31420000 R11: 0000000000000246 R12: 00007fdd6e9c5fac
> R13: 00007fdd6e9c5fa0 R14: ffffffffffffffff R15: 0000000000000003
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
> RIP: 0010:gup_folio_range_next mm/gup.c:241 [inline]
> RIP: 0010:unpin_user_page_range_dirty_lock+0x63/0x4e0 mm/gup.c:369
> Code: 45 31 ed 4c 89 74 24 18 4c 89 6c 24 10 49 c1 e5 06 4b 8d 1c 2e 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 ff 3e 1c 00 4d 01 f5 4c 8b 23 4c 89
> RSP: 0018:ffffc9000413f6d0 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000008 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: dffffc0000000000 R08: ffffea0002d10037 R09: 1ffffd40005a2006
> R10: dffffc0000000000 R11: fffff940005a2007 R12: 0000000000000002
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000555587af6500(0000) GS:ffff8881259fa000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000000 CR3: 0000000074024000 CR4: 00000000003526f0
> ----------------
> Code disassembly (best guess):
>     0:	45 31 ed             	xor    %r13d,%r13d
>     3:	4c 89 74 24 18       	mov    %r14,0x18(%rsp)
>     8:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
>     d:	49 c1 e5 06          	shl    $0x6,%r13
>    11:	4b 8d 1c 2e          	lea    (%r14,%r13,1),%rbx
>    15:	48 83 c3 08          	add    $0x8,%rbx
>    19:	48 89 d8             	mov    %rbx,%rax
>    1c:	48 c1 e8 03          	shr    $0x3,%rax
>    20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
>    27:	fc ff df
> * 2a:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
>    2e:	74 08                	je     0x38
>    30:	48 89 df             	mov    %rbx,%rdi
>    33:	e8 ff 3e 1c 00       	call   0x1c3f37
>    38:	4d 01 f5             	add    %r14,%r13
>    3b:	4c 8b 23             	mov    (%rbx),%r12
>    3e:	4c                   	rex.WR
>    3f:	89                   	.byte 0x89
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 

#syz dup: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in io_sqe_buffer_register

-- 
Cheers

David / dhildenb


