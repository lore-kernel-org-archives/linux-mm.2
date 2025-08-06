Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B5A9C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 07:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30966B00B4; Wed,  6 Aug 2025 03:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08406B00B5; Wed,  6 Aug 2025 03:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6EC6B00B6; Wed,  6 Aug 2025 03:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90D066B00B4
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:56:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 402BB16041A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:56:02 +0000 (UTC)
X-FDA: 83745574164.26.F1DB25B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id B164C180007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:55:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YP6vGYOu;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754466959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZLFNyU13X+JHer0jZ2QFk1zQ7UuPpmmQtBWGZ3YSq0=;
	b=xkWS8Sm+UA1GyKRLukz4QGkIlOPPWRiPhaoZ9ZPDVLNkZqPyfJEa2/HQJ4zemGVQO+4dHB
	AJ9iGaStxH+Q4eubyb4iX7BKE/Qk/wHzZ71oCrRDjbCvcGv8ZxswwdLsdU6lVJ0dXdow5r
	YiJfQIK5uS/QWfF+IfHvEFu+SXg1AMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754466959; a=rsa-sha256;
	cv=none;
	b=zIgjoVv1DM3NuHotUxc+C9ownkRIRchu/bpapEVwydxZo7cxVYGEblDteXpBgo0M0RuK44
	ZMOChcp6iyRXBhvk46k2oIpB19KagXqJ+lyfxd79q/pJ1yTGMjW6IblEJvcsMN/4cGOBwz
	SKc+qYv3Wlr5y6EtSH33WDJYXhp8Zzs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YP6vGYOu;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754466959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DZLFNyU13X+JHer0jZ2QFk1zQ7UuPpmmQtBWGZ3YSq0=;
	b=YP6vGYOuYQqrplzQqFkVbAySYS4arJ1cAjmyd6rgX6WVV6m/XMSKDUSqCFsesH1pBd0fD9
	fO/56gU65czymqMmL9BI4coywYg5mc+Umqr7LdRdthNRBwl7+qVJ5VaS2e3c2olt7NDDOc
	iZOQWqequt+0C6XjDnzSVUNJy6fPkcQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-LrCifB75N_eqnYGVxVYGuA-1; Wed, 06 Aug 2025 03:55:57 -0400
X-MC-Unique: LrCifB75N_eqnYGVxVYGuA-1
X-Mimecast-MFC-AGG-ID: LrCifB75N_eqnYGVxVYGuA_1754466956
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459d7ae12b8so21231435e9.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 00:55:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754466956; x=1755071756;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZLFNyU13X+JHer0jZ2QFk1zQ7UuPpmmQtBWGZ3YSq0=;
        b=NfmsQJoEagC1XVehkhWaAacZoOy7jk/ej9YMprBW/uaaJfcoMTw2QzOaBFJNXQhtjC
         W45pW9SItVAEiTtw6q9Lt5a+SfHp7m+nCyNpDfE5tVHM2OwsGzPy3xWVGGQrSryK1/z1
         uMZBrnSqLsH0z0CFuozbs/TKRCbCywm61XE+r0XM9wjxaiYVaVb4GueFy/Nnu7VXudJN
         F24ZCCltEBaAdtMORVuqRcmFLICHx2g/KzgeBSYb6K6kK+ZPBdIuVEGZGGttwZmnj/n+
         DFm+Iotn5nAMNcPxUqE5C0N98fRTho8qH0Mxr4ov3VfqY6nre9KX2J/1d/53WlMD83PW
         FZTA==
X-Forwarded-Encrypted: i=1; AJvYcCUHIV471CNga0zb/Gz5CLNqIWJdJOGmewalm818bHFXS/zDNGuQVFvYKgRpWH6DZqdb1pIwoaGGFA==@kvack.org
X-Gm-Message-State: AOJu0YzN/2kRuMAf81xGorNVEWzE697ebvwk0K9Mc1+cZtD2b/KcIZAE
	AmTdbB8j4Je7NsgGrrg0mKeWIQUyk6HdMRJZCjCZ1xo+oQqBrNckFDn2BxKjSyKsAUub9DLJhir
	UYGXUVq+/0CRdZTnSQ7fKew3jux+vKhg+EzK7qU43RRECAdkMH5XMTaxFrs24+mo=
X-Gm-Gg: ASbGnctHbWP0LzYdhtqFQaUJXXqUVB1EwJzruFltumCCPzSPfmL9aKeNX3udje3FXTb
	xAZ23ReY0nUyX8dOFFLjNnHERGDmUsEDbO23RStbkBXDtMY1RWULrcBMvwmNv09/qyyviAsRanB
	pOwkdMGuiC/WADqRNsUMDnK9tbtBPIIThV3CtlPxnnXn24UXx4SIHfU+cdlFCWs8Hn38FTO+ibC
	cyEoa6Bzzrni3WksqUbJ9HpKF8g/Xnge4vjmAoyZ5V9ZeR8c8z1N+65KTd2F8D9tGh39ziiqK2B
	A2SyNi0amfI+3l7XDLmBPoDeuoHDH5B2wwRPK/OZVW/1h9BTgqsMIlh2yNRziTUY9Tgh5Ao=
X-Received: by 2002:a05:600c:b8d:b0:458:6733:fb43 with SMTP id 5b1f17b1804b1-459e70d810amr15082765e9.19.1754466956368;
        Wed, 06 Aug 2025 00:55:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHreEm/o70R+4VZDPuQwDE7mdbv00ibKdg9EKpHj1ehYh9wMi6gBd79ZjCe60Nx7uWZ1VDZqg==
X-Received: by 2002:a05:600c:b8d:b0:458:6733:fb43 with SMTP id 5b1f17b1804b1-459e70d810amr15082535e9.19.1754466955963;
        Wed, 06 Aug 2025 00:55:55 -0700 (PDT)
Received: from [192.168.3.141] (p4fe0ffa9.dip0.t-ipconnect.de. [79.224.255.169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8e1cb7deesm11542751f8f.2.2025.08.06.00.55.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 00:55:55 -0700 (PDT)
Message-ID: <50ad6ed2-2f4b-44b1-8b78-8eb3993834f0@redhat.com>
Date: Wed, 6 Aug 2025 09:55:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in follow_page_pte
To: syzbot <syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, jgg@ziepe.ca, jhubbard@nvidia.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com,
 syzkaller-bugs@googlegroups.com
References: <68930511.050a0220.7f033.003a.GAE@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <68930511.050a0220.7f033.003a.GAE@google.com>
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: QjY0lDBWtc_B9K3uKODalx5YsaV1aiuV8DzI4VYz-XA_1754466956
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B164C180007
X-Stat-Signature: cjd3g9mhqgjz7rbpsuosk9cpp6yf7cg3
X-Rspam-User: 
X-HE-Tag: 1754466959-306106
X-HE-Meta: U2FsdGVkX184KAbPdcJB8ImNNgc9b3KH8UydOvODX9y/3jl6IppdzCP8q03C4yY1BXKErZb4JPQjrIUWt53RDAoAxpt1UMTp2k1vl3Jv9nfz37i8hMRKjEawk2qGowOci/uLpNqKBYM4GoxpeMRH+2W2n9UrxOZRWuqlrqq0oleI8scg3mGRzQI1TU2AoRZm0F0JnrIN5vYqc/k/lAVzLL/vtewI+vprDRsgj8WswGp3BTAAExDtXOez4y1pMopA+RRirP/abDBomlEOUUNDx3gPCvSQhvdCWEMq0oGKMu2XDog/BFeAw1G/Zy2v2SemtStbZs1Xas+w+TSIurhVyvM9hlA96xaK3q48s+PKrGcQzhgy2TEGzenzVCjY/QcQ3e2MxpLkn+6xgmJk2TrDMt6XaFl8T779TqZIgWgOw12yJmdHd9zUU50dBimsEj2vwq7UlYeuBfzanItRqsPJbbi6knyBjkQxgnOspGpPA67twCqeJOvLGwMdL2MHoLh3iNfHngddWI3XRoIdOQOiPvsQ/nZKbTimlnotT9T9fKaID+gHdyLu12xeCdfNT3bY8wM9uRkC0puxAqsylGKz6rM4chCgk0gNq+UyevM0b0XfW93jY19Q/zDcOv2mKpCsreHG/7A1Nmpof7cdy8hSpkgifND5kVGPoYOgAlXjYUuB02J0m+ZcoMMxuvb3vzYbymzUfL7s0CP9dp6k7W6L7vNh6y5g4vxmbF/5iYU6GzyyBWd3NWvozmkJPWd26CJQLPeoaWhjXCHEvzqk4uUXaDtY/GlF6Yo0+v4nT16bvrGy5cUNoSTyw5fnsFXz+2R+Q19THd8Ok3Xj0rtJ1jDYww3izt2TeLT7GDjDVf3p7bQr3M1H/i9po7iYSU7Xn+RXNh2kE08QCBt76Wnr11C37PJjt1vFZli/ZtPy1bQkDUtKfT98DWI4Khn6PFBRSVzEqA+q/Al1iPzl/qjaE49
 eLHlcHOQ
 zw5u0hsnGkgmmcAYXaDmjcqhFCbZVLL6WjXUiaJoSfC7XjHK18j1nVr43lxDyDgwMoLHMPLmGN+r7UnAF/RM2P9X6w9CYMMEUWt+VoxqwiRIoqsG5Kz3/J27RwnFfUF8vkaHN8mP1l83emmiMwyhH8YSoYNujMTLBqvMiNZg4muvNeTllbmAraqN2ltP6W7iNuTHCpFYJpGjfOV/iPpegG7U/MJchCYcg37TQD1VT6oVooLQFSp1EBUKiG76/MrIv8cwDIU5GvyBZz9zf86J6nMkA4/ObaTQCPen7mGllmPVOkPklFMfE83hp+PMtqtH/pMWqPIwV4hTJmbV2ouuueVWLoJFA43kGmv81jROpozLirx/2Wbc6FsiVdFaN+tVi4JNRM/10k2UnFy6MnHW+PT+1fPu7PSTBqk65u6zsx7IXHwwz2t8bk6gDwqxfPaWZI4pVkqaU9SMFWGZka0hJjXrPP0G8DxaWzMGZrazAcfdtXIcqRH88JcfH3npKJoByx7mtSsI423+9AqhoUptRtfXKKzxHmF9LmUUuYzr4F9+1IW/N0v64N9w0wGVxG/queRaohGcfTt6Nidxgd7oYOVMlFlq1Fzazn3VCx4Dnh2up3FD0rdvv4OwePkWtcUmcZT0+aYxYQfEdxXZ9suD/l+9RSYdNNzjRo5f7+svXAjKib0u7lXznb/gVBmbHInbLV6P9zdDz2RgwfaHN2kk7tefHX/OZyo7rBX0MEDBCDZjVRfxas+0Xg++7PCCpBsMJGdAZJwYl1cfPldLkQFVII4QCFud/gjqdxL9KjhSqLmkmOv9LEgTIG+zUSQwhPsqYBUh2Dc7gkgPpCRfIMdXFY4ay6T+yO5B5E1PAdSgXue4KvMMk8NjEPkUTS9NioLMJYEKkFSRKiyZITBYTmoCdQ9kR4gXSK5p50C+yFexvGZwjXD9Rr57QxrOahObZK02wP2qg6ITqevX+U6UXu6Slo8AyXfW5
 hfFqW/6Q
 F3D+LZwLRuOSJV6Vy2S6wxe6LXMvvtUemJjZZpDoQRYyb+tnAcqc33KYHit1kT0NIAxus5Ep0b9Yg2DEAWSG1DOTHdltT094Q9q08eWR4Z87fVdDpOFCrdKCUhVfubQE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 09:32, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7e161a991ea7 Merge tag 'i2c-for-6.17-rc1-part2' of git://g..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=16d385bc580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=75e522434dc68cb9
> dashboard link: https://syzkaller.appspot.com/bug?extid=57bcc752f0df8bb1365c
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13fa96a2580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1083c434580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/85ce789ac77a/disk-7e161a99.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/4d1fd8fed61a/vmlinux-7e161a99.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/9bd5f709ed6f/bzImage-7e161a99.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com
> 
>   do_initcall_level+0x104/0x190 init/main.c:1331
>   do_initcalls+0x59/0xa0 init/main.c:1347
>   kernel_init_freeable+0x334/0x4b0 init/main.c:1579
>   kernel_init+0x1d/0x1d0 init/main.c:1469
>   ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5866 at mm/gup.c:869 follow_page_pte+0xe3c/0x13e0 mm/gup.c:868

That's the

	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
			     !PageAnonExclusive(page), page);

[   89.134725][ T5866] page: refcount:507 mapcount:1 mapping:0000000000000000 index:0x200000009 pfn:0x70809
[   89.144633][ T5866] head: order:9 mapcount:505 entire_mapcount:0 nr_pages_mapped:505 pincount:2
[   89.153655][ T5866] memcg:ffff88801b6f8000
[   89.157938][ T5866] anon flags: 0xfff6000002007c(referenced|uptodate|dirty|lru|head|swapbacked|node=0|zone=1|lastcpupid=0x7ff)
[   89.170337][ T5866] raw: 00fff00000000000 ffffea0001c20001 dead000000000122 dead000000000400
[   89.179013][ T5866] raw: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   89.188218][ T5866] head: 00fff6000002007c ffffea0001c52088 ffffea0001cc9988 ffff88807c250551
[   89.196996][ T5866] head: 0000000200000000 0000000000000000 000001fbffffffff ffff88801b6f8000
[   89.205866][ T5866] head: 00fff00000010a09 ffffea0001c20001 000001f9000001f8 00000002ffffffff
[   89.214719][ T5866] head: ffffffff000001f8 0000000000000015 0000000000000000 0000000000000200

So it's a pte-mapped THP, whereby the folio is pinned two times.

The warning indicates that we likely have !exclusive anon page that is mapped writable
into the page table.

xdp_umem_pin_pages calls pin_user_pages(FOLL_WRITE | FOLL_LONGTERM).

Let me dig, the reproducer seems to involve fork, io_uring, mprotect and setsockopt.

-- 
Cheers,

David / dhildenb


