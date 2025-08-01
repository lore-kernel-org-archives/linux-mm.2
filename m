Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BEFC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 10:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F30E6B008A; Fri,  1 Aug 2025 06:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9296B008C; Fri,  1 Aug 2025 06:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7ED8E0001; Fri,  1 Aug 2025 06:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 472326B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 06:14:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A692C0863
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:14:55 +0000 (UTC)
X-FDA: 83727780150.23.F434910
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 34AE44000E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:14:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eKF/9irT";
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754043293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5f0ikHwLTTt3/O8uwlenMs9vmb7xQLN+kpZuqDeh9ZM=;
	b=4/DCAhSvXrF+2Ic88diF+WTRvDT+1NPqCEa85ph8/Hw1rEgHlFWIQgv4obj03+Hv2AMCRL
	1LVL1YbE3hH184j7i4wnbqn3o7LhzITkl6LCnUoMwYTaFeKBSO24e3yi8YAvOhE5/aq4JY
	adHSsJth1Q89DIhKZh05EFJ+F32HBHo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eKF/9irT";
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754043293; a=rsa-sha256;
	cv=none;
	b=EpPe25+7Pc5TWukxpsSn79ekxNdxd/HdDaX41loUEFcAHJUS+uUYo5keqO1d5wNOlTYamm
	DgVcg8OrvoSE+FfKw3npQhVwuJU+X0Klk9V5FunpdVU3Mf5muDidfe7i5Og4WUX/iN2bnf
	6WES1MBcxQxBs368iaG9yiXbQZMxS1c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754043292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5f0ikHwLTTt3/O8uwlenMs9vmb7xQLN+kpZuqDeh9ZM=;
	b=eKF/9irTnqEqy3Z2XxkDx0h2PJN+VdijW6qliQ+3by1R+GH6Hc3deIYjMQZC0beLZZgiPP
	lVm2SrVwlGH594Ag93si6QhVMMn6J5Rq2Rz8nSFwbAAU2+8FFPudG/Od5DCKB6+tWGoyK7
	xBTB7ro8BJt2J13C3Wrx5Gb/A82Hvns=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-jfG0ghytMXOjX58t_ESZ1w-1; Fri, 01 Aug 2025 06:14:49 -0400
X-MC-Unique: jfG0ghytMXOjX58t_ESZ1w-1
X-Mimecast-MFC-AGG-ID: jfG0ghytMXOjX58t_ESZ1w_1754043288
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-451ecc3be97so9239875e9.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 03:14:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754043288; x=1754648088;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5f0ikHwLTTt3/O8uwlenMs9vmb7xQLN+kpZuqDeh9ZM=;
        b=lVuSHOeAEmKhQ+UF+BIz6Mg5vsb0aW+O2YQqsutgxa93lx3IcPpxfdX7a/2Z3u/meb
         VhF1Z3ajLZ1pf8Fhvt/HhtrMgqQDRxzGyBJb+1ts+mnafnxG3WZIswvZEIQgSH2KKjvV
         Gm1YJmgcX7GzISFjorAvvAbvBtfobycE/tb1CqgIWRFUC9CRhDX7LiJjeEetd4fb1L2n
         HR8GBh0kIAbM4CU8QEiXAus25PLGs2f3uVX2HHHA0DT8o+Q9NStTj5Spqx76+0X1nAFv
         4gqmdEP7ePsZSNeNeGd3V9Xgg13RHecrn1Nsv/XtAsvWKoz8ude9YOxg3Vk8OVBybjEG
         zYPg==
X-Forwarded-Encrypted: i=1; AJvYcCVBArqC2Tf9xKNrlELMeF6n/Qjflyi+SNwSj8CkNk1aakw0nmLEqVW+bS5ZZfaKo/hSj0eJWtQzZw==@kvack.org
X-Gm-Message-State: AOJu0YwSOw1vWiNGLRrmFJzYd7bhwebfsyXQfAkAlMfvkl+JEeMv6/oc
	avugl7w0SnGDJBrMny/a1UVoSeX2mGnJZXfiFTgDoozQbuhEz9gM9Ch5vnZRhpBuI1FE01QcCs1
	Hn93ZVkWDj+ofe82mwRrz9jirtfPeWFX5HdRDUp03tgTSbtK7A2BA
X-Gm-Gg: ASbGncs9/ARWW+Eau4pjG6TTyXd/R+mOZRKadBML1A3dTkyOl+mc/qFcG7ox3m5EZLd
	/fzW6vFww/jJfWEQcHGy+OR6Px8W4fztywMXWuZ++3FAHJZ3u7YXlAYsRdbc7n9b45oG16qK5Wg
	F0BVEBgRnm1894ixZhSoIl07rrFn5YNaLIVbqHPyCMyrCaDzzd78X0+CO2X0s7M1dDbWURyac4o
	pVlmau0nGMNryTO9gJAecT3XJSyaqPej93T8VNOqX/+4Jk3+csNBWZRJjxBOKqIhswm1neIrplN
	qdLij5t2vebwajtn1DkEuqCTb3rw3B0fp7MUXVOl968rEov7eMekLz1rxa50kC+GJ1qtYD0Azc6
	RSqDOtbaU9WWynhIcmrtjreQGqx+v68D+OGlatQQEfmXseDsgC26oJ6IaMhU/9Ch1
X-Received: by 2002:a05:600c:810a:b0:43c:fbba:41ba with SMTP id 5b1f17b1804b1-45892bd1ecfmr88340775e9.28.1754043288107;
        Fri, 01 Aug 2025 03:14:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcNW9A99gwbz1/XGrQLX0CryukwzOCxu8d/MxqztwNcsfV6vrQMa1DlM86ZeUVO2ntIikTPg==
X-Received: by 2002:a05:600c:810a:b0:43c:fbba:41ba with SMTP id 5b1f17b1804b1-45892bd1ecfmr88340295e9.28.1754043287521;
        Fri, 01 Aug 2025 03:14:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:7500:5f99:9633:990e:138? (p200300d82f2075005f999633990e0138.dip0.t-ipconnect.de. [2003:d8:2f20:7500:5f99:9633:990e:138])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4533e6sm5570881f8f.35.2025.08.01.03.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 03:14:46 -0700 (PDT)
Message-ID: <e9f2e391-5c83-481a-9fa4-727c25922f1c@redhat.com>
Date: Fri, 1 Aug 2025 12:14:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in trace_suspend_resume
To: syzbot <syzbot+99d4fec338b62b703891@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org, andrii@kernel.org,
 ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, rppt@kernel.org,
 surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
 Sasha Levin <sashal@kernel.org>
References: <688c9223.a00a0220.26d0e1.0068.GAE@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <688c9223.a00a0220.26d0e1.0068.GAE@google.com>
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: JKFDz4YQcyzPQG1TpeXlCtDjDIqjtXvNL0OCtJ3g-gs_1754043288
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 34AE44000E
X-Rspamd-Server: rspam06
X-Stat-Signature: kc47dzhuh7cmqfupz4detyse6rc3xnww
X-HE-Tag: 1754043293-16797
X-HE-Meta: U2FsdGVkX19MvWmLI6EYpPohsP6zoKRyrO+SFAFPmp4Ue/yiPRs2KQpqIAqmSY7E9K3cmtuk9CFkd376z2gMc+76FR8AKZahzD/5n79CNKo72454upYUsPRb2JXHxGmZgBzsdl8CeJiM+TGGFnjYAYT4Dqxw21QO+HImiK5xLWXnYJuWDlQhg2OK4SiZLzsQmm1Fhv7wqPURu+8gDF21qj2BTqnQPVh2Et5njS4uhLsvRXADqDIuQGq+gv9p7Eze1d2SDlCkcbN0BeQr/R0QPjfGwlEZyJLHNtXYhEy+XUEm74LE2E9324iEXurobzBytZoHHBWH2vfcmbTUI6Oso/iulqwAecgZnRqYRtVhAbFbjCMmoaAvzMaQ8F6g05HvNfEOhRwRwxIC7vCzOgQpdhp9RMlHBHctzTg5IEg1NQfzdo2m2ZmYtu5oXKiLtFdULz4e/agIvcLuTHlLpaTY4D4YLiSIZw4N2DoWXwdAxMVvzoZG29RzL4y+oPkGOBtSsldD/xx+TDIByguJdtQeOW8JyGnhl6jE57/UekixoAHnFQM+IziwB6azkIph91zvt07buNiRHmRiYhpQgZjHkMV5oWJIZSUMOKpp1uLa9vZ/T+SPsJurV6vH9Rimaecr3OsmopSTsE+Ciqc1DzBQWHZYYKObWNSBuzlXTi6sMJjtSl/31agK4RruqnNIMMk6F6M2JjcTCGFVCflgq8DCm5kbv0NT2VqzuoNplEX1qYogZuLqTG7tLX2qvh1eoI0SAmJdmJP/Mj1Cybg2aeXRZsCJiaWxD3cLrcy4PHXS7IygonPk754SKCOuwCBERAqN1a9DsdJwWmiIkF/oirGB2JGi/qhb0/W6I2Zee+shdcNZA8lMmKqqWW7LvINOoHqcjXAQf6LHvEeOJw1KGAry3DCnpAxXSpA5IxD9LcWdKy8RHFItPyitwbMcTF7tPhJjSacBlkBPFPYpt08+N+g
 xLVPwUXq
 X0iCSgNcGGRQhk5HuawdL9YwNzeVNsV+CF/+Cb26fgNQRaFTySVFCrtDETT3F94Is6/DcWL7I0ziUpGVqdt6xeln/WATjr3b4/faL5mvscnUElt5fxG99JEX7DgPmuDm8hBrt330f1gLbJfuCj+ltQVsJOIR9956TCm7UOL4aldQNipx7bUPtBLbMzSwiaGqk0T6+Uvro7rcZt0U6JNFltohNkEnWQaAbasaFR23X9rTJ3RZH37mZujZt2pdqFMb/KfQj8OGbVB8gyvBu/T2TV3DEuTwy/16K3dpaFZOmo1PQYIBqgmyI+trvNUQodpMZZRHFSSc5Y7qLS+2frRzui5XG8gSu520a6JQHtWqODoiXB0Vv140BiPFF1bPGpNiWfj8dLDvL3pz+Kb8QUqzFwUCLYksJ3z3lvP6eAPVLkcL2SW5dLLQu54vWiJjlN+4pl7/XOA+hXR3qHz8ZnlXEzN7D5IHmNR1hoKQX9eITFErC1KN4DtWbbUIXBY/FHAtdWFwYu2fT8tlrIY3Tk4N9E0kDG5NTXMHWdxNXI3uijsMD412PFmP0JPhQB9nAf6yhKraBK6sIfwjxf4FV0pOE9EOJsUMRkRKna1rfv7yOWnxnTZdoMXjZjCB519i/C5m9pxdIj9xXhuqZVTzmsfDZRmAeD15O9wnLTgenL0ah8+JKzpMq5cPcp21WMQEEtps7HbvOZn9vkhMeFS+FzOjL9o/WxyP6XFMtX0cqARZADsXRBty/rQls6ADV35vttrA6OV/PRVrUZee3IAK+fM4L0pdnDueCIJtVGanbhFI+2gpEaPJrwhH2xySLDLiZ1HnwHCP4PJggwrhY8FN9XBA7SXo6bd0BSKFM0mxCI49wEXCfKgoqCi0RXgBKgL6N053yg1uDKaitZGhl8QpowJ2lzimiI8MlSNOfmPuiQqPWuNXXSGd0kkQkGuwTMStCT/vgQ+kkdh5dPL8r6TcOZyK3XgHlRemY
 gxBB6sCf
 bA4yqPA1oJshAzKffP4Imy+zpgs3XUKwxNonsJsS2fHP7parL0TOze3xozQBB/YKM86mjPCxBq3qlY9zcJ8rxPus6sTi+U24S4LQbenv7VwQBeR/53b2ZWczTLeUdlbJXvqnOjDKQDYo6Vh8f2MXo4hu/nUlrEJSJtxLgdZlKyOwz0H84BVMFvD2KO14cV2XbLqWJTmlES4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.08.25 12:08, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    f2d282e1dfb3 Merge tag 'bitmap-for-6.17' of https://github..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11709cf0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c686e0c98d241433
> dashboard link: https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
> compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: arm
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e0e2a2580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12a439bc580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-f2d282e1.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/25cab46afcee/vmlinux-f2d282e1.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/77cd04442f1b/zImage-f2d282e1.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+99d4fec338b62b703891@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 4155 at mm/highmem.c:622 kunmap_local_indexed+0x20c/0x224 mm/highmem.c:622
> Modules linked in:
> Kernel panic - not syncing: kernel: panic_on_warn set ...
> CPU: 0 UID: 0 PID: 4155 Comm: syz.1.17 Not tainted 6.16.0-syzkaller #0 PREEMPT
> Hardware name: ARM-Versatile Express
> Call trace:
> [<80201a24>] (dump_backtrace) from [<80201b20>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:257)
>   r7:00000000 r6:8281f77c r5:00000000 r4:8224bc00
> [<80201b08>] (show_stack) from [<8021fb00>] (__dump_stack lib/dump_stack.c:94 [inline])
> [<80201b08>] (show_stack) from [<8021fb00>] (dump_stack_lvl+0x54/0x7c lib/dump_stack.c:120)
> [<8021faac>] (dump_stack_lvl) from [<8021fb40>] (dump_stack+0x18/0x1c lib/dump_stack.c:129)
>   r5:00000000 r4:82a76d18
> [<8021fb28>] (dump_stack) from [<80202624>] (vpanic+0x10c/0x360 kernel/panic.c:440)
> [<80202518>] (vpanic) from [<802028ac>] (trace_suspend_resume+0x0/0xd8 kernel/panic.c:574)
>   r7:804be014
> [<80202878>] (panic) from [<802548c4>] (check_panic_on_warn kernel/panic.c:333 [inline])
> [<80202878>] (panic) from [<802548c4>] (get_taint+0x0/0x1c kernel/panic.c:328)
>   r3:8280c684 r2:00000001 r1:822326d8 r0:8223a0a0
> [<80254850>] (check_panic_on_warn) from [<80254a28>] (__warn+0x80/0x188 kernel/panic.c:845)
> [<802549a8>] (__warn) from [<80254ca8>] (warn_slowpath_fmt+0x178/0x1f4 kernel/panic.c:872)
>   r8:00000009 r7:82266338 r6:df985d14 r5:840d5400 r4:00000000
> [<80254b34>] (warn_slowpath_fmt) from [<804be014>] (kunmap_local_indexed+0x20c/0x224 mm/highmem.c:622)
>   r10:00000000 r9:ded86c30 r8:deb6caa4 r7:00a00000 r6:00000003 r5:840d5400
>   r4:ffefd000
> [<804bde08>] (kunmap_local_indexed) from [<8053ace8>] (__kunmap_local include/linux/highmem-internal.h:102 [inline])
> [<804bde08>] (kunmap_local_indexed) from [<8053ace8>] (move_pages_pte mm/userfaultfd.c:1457 [inline])
> [<804bde08>] (kunmap_local_indexed) from [<8053ace8>] (move_pages+0xb1c/0x1a00 mm/userfaultfd.c:1860)
>   r7:00a00000 r6:00000000 r5:8490d6ac r4:ffefb000
> [<8053a1cc>] (move_pages) from [<805c401c>] (userfaultfd_move fs/userfaultfd.c:1923 [inline])
> [<8053a1cc>] (move_pages) from [<805c401c>] (userfaultfd_ioctl+0x1254/0x2408 fs/userfaultfd.c:2046)
>   r10:8425d6c0 r9:df985e98 r8:00000001 r7:21000000 r6:00000000 r5:20000040
>   r4:8486d000
> [<805c2dc8>] (userfaultfd_ioctl) from [<8056c4d4>] (vfs_ioctl fs/ioctl.c:51 [inline])
> [<805c2dc8>] (userfaultfd_ioctl) from [<8056c4d4>] (do_vfs_ioctl fs/ioctl.c:552 [inline])
> [<805c2dc8>] (userfaultfd_ioctl) from [<8056c4d4>] (__do_sys_ioctl fs/ioctl.c:596 [inline])
> [<805c2dc8>] (userfaultfd_ioctl) from [<8056c4d4>] (sys_ioctl+0x130/0xba0 fs/ioctl.c:584)
>   r10:840d5400 r9:00000003 r8:8572d780 r7:20000040 r6:8572d780 r5:00000000
>   r4:c028aa05
> [<8056c3a4>] (sys_ioctl) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:67)
> Exception stack(0xdf985fa8 to 0xdf985ff0)
> 5fa0:                   00000000 00000000 00000003 c028aa05 20000040 00000000
> 5fc0: 00000000 00000000 002f6300 00000036 00000000 002f62d4 00000938 00000000
> 5fe0: 7eb28780 7eb28770 000193dc 001321f0
>   r10:00000036 r9:840d5400 r8:8020029c r7:00000036 r6:002f6300 r5:00000000
>   r4:00000000
> Rebooting in 86400 seconds..

Probably fixed by

	https://lore.kernel.org/r/20250731144431.773923-1-sashal@kernel.org/

#syz test

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1453,10 +1453,15 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
  		folio_unlock(src_folio);
  		folio_put(src_folio);
  	}
-	if (dst_pte)
-		pte_unmap(dst_pte);
+	/*
+	 * Unmap in reverse order (LIFO) to maintain proper kmap_local
+	 * index ordering when CONFIG_HIGHPTE is enabled. We mapped dst_pte
+	 * first, then src_pte, so we must unmap src_pte first, then dst_pte.
+	 */
  	if (src_pte)
  		pte_unmap(src_pte);
+	if (dst_pte)
+		pte_unmap(dst_pte);
  	mmu_notifier_invalidate_range_end(&range);
  	if (si)
  		put_swap_device(si);
-- 
2.39.5



-- 
Cheers,

David / dhildenb


