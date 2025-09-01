Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C332DCA1005
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8FF18E0043; Mon,  1 Sep 2025 09:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E676A8E0008; Mon,  1 Sep 2025 09:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D56038E0043; Mon,  1 Sep 2025 09:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C70378E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:38:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95815C0830
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:38:53 +0000 (UTC)
X-FDA: 83840786946.17.675F3DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 15F99140004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:38:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ng67+EuY;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756733931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYwpi82W7VIihj8uBfuL+qMQaHX4FplKNy0RIRsXcCU=;
	b=WthWK+BtPlAamVfppxZ86nFaEw9o7Vfhb4uPnDl82sP6j/WmtA/pbB9+s7VjZ8spnY78Ws
	w+Yi1qD5MoW34DEKyutfI7qjwYEpWq3bEEfiZAyD2Jxi+wNUQNe/uxwotzYTqDycOjZFsy
	xtK3v3JQZalkeMd2n8VztwpmJawUn1g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756733931; a=rsa-sha256;
	cv=none;
	b=Wi8lSr1HM3deYFnVaX41zcUAjcMfxMEouBLYpyp2yWYa1zogxSCex32aa09Yk3z26EBqck
	2FiSdP97AYf1WxogstDVZklcxVqCfk4u4+mZ2iqhqIpVsITHgL/ziQWRv7rxmHkTrKUOIH
	4FswHNV3eG2HceG7+d6txWQNrT0yemU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ng67+EuY;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756733930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WYwpi82W7VIihj8uBfuL+qMQaHX4FplKNy0RIRsXcCU=;
	b=Ng67+EuYPOoX0Q+rNAKdBPZIwbM8dao+XJBGSw0s4CpJmNZzViBS0d3BC8cKupB06FB3X6
	0SOkefzHgD4m/maFYfcZtf1OtH+bOfUfwSdmFwa3WGy8oqxQGF49zD8UZkq/fifsS9jSxG
	Ow1Mp1Zuj9YP5F+RX4eMBDScRK0GxB0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-jaQARqc4OuKCey_hz8kTDA-1; Mon, 01 Sep 2025 09:38:47 -0400
X-MC-Unique: jaQARqc4OuKCey_hz8kTDA-1
X-Mimecast-MFC-AGG-ID: jaQARqc4OuKCey_hz8kTDA_1756733926
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ccfd90630aso1871857f8f.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756733926; x=1757338726;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WYwpi82W7VIihj8uBfuL+qMQaHX4FplKNy0RIRsXcCU=;
        b=V1LWqbPMyxbAFYO+gOgrGTyhfdHaWP7zEJ3w/eQ4FrZMT65DlrbF5y/1j2lGkrc8aQ
         dbRmZuI/o8pj0yzq2vZox2jlf6r4+4TRQ8kOmBYYSoxu2bdqtujbHIg+VFNWfwkNXVmv
         Q21i5MHyFAduEba6IDK5YJ7ZcuWLj1ADYAbVS5Jg/8QIar6VJw2qY4RW+OJLBhN0WB8v
         ZinZLtQpBIz6MgZEetkXFIpf0QYRY/fV+ggWIcVqNtrVgd4iWVbKVw139JqJvfqQu+W4
         o5l/WvJ+nV17jaVBeh4BqELPomxvLaemurdBYhY76N3NBVOk6YNTPSPrnD0S3ovrUBRC
         e8/g==
X-Gm-Message-State: AOJu0YwASL25YnzBnFYQb/8IXYf17iu1ldDjgsTUFCSWqVjyVWOc6WdS
	BwcSFbfYNjJ+2FpwBgNe8Em2MAaNa/ZVktVBGc8AN6LYQCb3d8ky5muaVEfKB5aFrujfsjUAuGN
	+1lmoQRDVdjuTWdHd8cgj3lIWizQLePQR5g+hUIoPO3uPnmxrp11G
X-Gm-Gg: ASbGncsfjxwAk8SI0WWJAnwS+7dqKEfSyF29KcDWRN6zKC7URVldyG5H2qBpFWZHUA2
	6VwdGH4Y39BilPZZ1o+Pf9Yug/V+HMruEY/PLUA88ibmbnzWrTlKABPWGxkk+qyhM8iWqBDxqCg
	8ykAuW8uzKdtVALEqodNfvrvxOB2BjcjuBXE+NnCBfpu8Z6sM3SK5/W/bbAVztgl8Vz/nMCzPXG
	b28ShnXPwULyJa+m9wGmc9vZYc6oD1o/5x5xFWKkq2Vy6Fx5QKOFG9Npbr00KOMRhj5mhfDkH3+
	ULrquBaaJM+v1rvz30blTe5tk7g0HOyYJMk8i28BEDQNa+wibHBjnf0rhQgaMOwK18RVfobkFNc
	CfLNyLbdV5ngNNfByCMuAyUs5DccXjmDljsU8JI4iwLPJsj7Y7/ZiCG8VNpkhsuHLd2Y=
X-Received: by 2002:a05:6000:2102:b0:3d3:8711:d934 with SMTP id ffacd0b85a97d-3d38711dcc7mr3315117f8f.14.1756733925996;
        Mon, 01 Sep 2025 06:38:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3DliMw41VU4hxaIWHMLNG+OBiPKQ08qUXWAlqHFXtcpv953/vrh5P5rTJMXfl1jn2z2RQzw==
X-Received: by 2002:a05:6000:2102:b0:3d3:8711:d934 with SMTP id ffacd0b85a97d-3d38711dcc7mr3315078f8f.14.1756733925456;
        Mon, 01 Sep 2025 06:38:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d21a80c723sm10359081f8f.9.2025.09.01.06.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:38:45 -0700 (PDT)
Message-ID: <48ee3dd0-9af3-4513-aef2-25e185cce349@redhat.com>
Date: Mon, 1 Sep 2025 15:38:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] copy_process: pass clone_flags as u64 across
 calltree
To: schuster.simon@siemens-energy.com, Dinh Nguyen <dinguyen@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com,
 selinux@vger.kernel.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org
References: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
 <20250901-nios2-implement-clone3-v2-2-53fcf5577d57@siemens-energy.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901-nios2-implement-clone3-v2-2-53fcf5577d57@siemens-energy.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: btCh2Xi6KfvUqJZGo7bFjf2gOkWyBO6H3WCyCT0CFpQ_1756733926
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15F99140004
X-Stat-Signature: awxw4xpgsbmc6p1cd7rdkzaax4zq8inf
X-HE-Tag: 1756733930-579531
X-HE-Meta: U2FsdGVkX1/+qRPv4Gv8QwaMdMN4SKgv7kLS6xEd7eGsmWZEgR/D5lcVdejpnSTMFuMYxrJQaMvvO634siQ7ELCGpcjvT95qH5rSBy3aNsQbjz7lXiGmxT9uNxcz1oFCOSkO1B4LYv4JeB3FcqUEJ1jsYi7IQkiFExDZfavHdKqwxMasPMEZC7rkX1jnlF5tWMWXet4DSBLpp7DNKQhAbv53s98nSyXiMRkY/hmK1mJhA7XumGj9401SEH7BCf7VdGuIVpIPXa039ckJiQ1pa6pPHdjj5kC0ttYzBhZ6HZkZ9AvpqlS7DA8lQke2wXJYfh4uWivQN+mUHECAK68wxQdvVnA14Wx7JMva7g3GcwMjEGfZjjL4u7d0eWNyenSltdVFoRGJbg8ISyDrxQLxBZDlLjm6nM6/dtOyxpGinjUbeqiATAXD3woSVdMThsmhcMwF7Undc0J1CbfnmQevHo2AY3IBmrmtpg8cDjJoIBmwE/V4ixuC2oW47JUrrjNUx1X5+OwNkKkQBStvE/xLSIuxYkv/XTn8Be65k1yLVSu0FkSw2oKzcl2BJ2HdZXNX1W/QHMCbrcKV4b6AZrKeLDcNJEGL5/r1gAQEkbPyCg8u9lW+0OfT/nNgHB98BQ+l9MItbFAa9fM5+lR7IVbeo7hi5BwvS27VJVIO+6vW1a4L78qrraopdVutJ1L/ggCMy8USgZ6QmdAyI1M4r6URzzioYGHTen8m1ZOEdV5P2uEOJjK8sBd2uAIk86WGk4YF3pKSL8LgMNGwrlJhkUa1pNnME2pIgORINpnaM9CtSWwMO2jjhVjLun4AvLwBJK6Neze7Ct+CG46WbQXMxeihGs//vCjTWgmiEhHAsRNXi2ZzhREUugkfZSkzeIAWRmg5rUhUMX6kFC+cpx2kjUtYt9wNN6W7EQ+5LcpNYtw/hsdHzt6gQSRTba0bof6QC00a2rjK0B+KAX/VfO4w04a
 5v/CMInp
 LuHSQzdPnyUINkd48gnAU6QNEiO9QSsQ4ohHLxZWcUA3bTltvn8ZLlPg4uXBb/CkAoReyH1sv2i0hdblWrhPWnGdfZIgzI8e90ZyQLWDiM7xWia8JRxG1cmhXZDTRfHV8F6V8cgyeGPnuDoVPc4ArF7n+IAG0bk7JH/dNLtEBFiumdVfhsS1j1R4Paj1/F17DRcjVePnTEvfeymwaRHPuzwuJXmwZxynbngyea5s/e+kktTyR8Ope75DHZdHPzf7VAxxKpHHykECsO6G4/tb9L9Au54XmQe+VJ6TnY+NtYPtUOV5JoLm+QHXwdRGdA10b7F2ww0XDHFnydJNevZSwSXPwUV/S0SzYesIYYafRu3AwpkmAlN//T+XNvkb+MVD9YU8mvQnOKdqbrdA+myD7dTLGA7qxoOxJezIhvjPpykbHcD6dOi+C3SFt4VPlEKbAixAmWfMZF3fcJGMV4IDtIDZ1B6aAi6Up4XHSYqXO7DJr1w5A6P9VGSAqjge+b9u9vZGqLaaRtk40f+FELPtEs1wNOdaRet3ZBb8jh5PjkCYNZtb6s33b3qJ+F+U//L4noWDbv5YPxBUpaKA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 15:09, Simon Schuster via B4 Relay wrote:
> From: Simon Schuster <schuster.simon@siemens-energy.com>
> 
> With the introduction of clone3 in commit 7f192e3cd316 ("fork: add
> clone3") the effective bit width of clone_flags on all architectures was
> increased from 32-bit to 64-bit, with a new type of u64 for the flags.
> However, for most consumers of clone_flags the interface was not
> changed from the previous type of unsigned long.
> 
> While this works fine as long as none of the new 64-bit flag bits
> (CLONE_CLEAR_SIGHAND and CLONE_INTO_CGROUP) are evaluated, this is still
> undesirable in terms of the principle of least surprise.
> 
> Thus, this commit fixes all relevant interfaces of callees to
> sys_clone3/copy_process (excluding the architecture-specific
> copy_thread) to consistently pass clone_flags as u64, so that
> no truncation to 32-bit integers occurs on 32-bit architectures.
> 
> Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   block/blk-ioc.c                | 2 +-
>   fs/namespace.c                 | 2 +-
>   include/linux/cgroup.h         | 4 ++--
>   include/linux/cred.h           | 2 +-
>   include/linux/iocontext.h      | 6 +++---
>   include/linux/ipc_namespace.h  | 4 ++--
>   include/linux/lsm_hook_defs.h  | 2 +-
>   include/linux/mnt_namespace.h  | 2 +-
>   include/linux/nsproxy.h        | 2 +-
>   include/linux/pid_namespace.h  | 4 ++--
>   include/linux/rseq.h           | 4 ++--
>   include/linux/sched/task.h     | 2 +-
>   include/linux/security.h       | 4 ++--
>   include/linux/sem.h            | 4 ++--
>   include/linux/time_namespace.h | 4 ++--
>   include/linux/uprobes.h        | 4 ++--
>   include/linux/user_events.h    | 4 ++--
>   include/linux/utsname.h        | 4 ++--
>   include/net/net_namespace.h    | 4 ++--
>   include/trace/events/task.h    | 6 +++---
>   ipc/namespace.c                | 2 +-
>   ipc/sem.c                      | 2 +-
>   kernel/cgroup/namespace.c      | 2 +-
>   kernel/cred.c                  | 2 +-
>   kernel/events/uprobes.c        | 2 +-
>   kernel/fork.c                  | 8 ++++----
>   kernel/nsproxy.c               | 4 ++--
>   kernel/pid_namespace.c         | 2 +-
>   kernel/sched/core.c            | 4 ++--
>   kernel/sched/fair.c            | 2 +-
>   kernel/sched/sched.h           | 4 ++--
>   kernel/time/namespace.c        | 2 +-
>   kernel/utsname.c               | 2 +-
>   net/core/net_namespace.c       | 2 +-
>   security/apparmor/lsm.c        | 2 +-
>   security/security.c            | 2 +-
>   security/selinux/hooks.c       | 2 +-
>   security/tomoyo/tomoyo.c       | 2 +-
>   38 files changed, 59 insertions(+), 59 deletions(-)
> 
> diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> index 9fda3906e5f5..d15918d7fabb 100644
> --- a/block/blk-ioc.c

(adjust To: list)

Hopefully we caught most of them. The ones not called "clone_flags" are 
a bit nasty.

We could have split of some changes (e.g., trace event), but likely not 
worth  it.

Thanks!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


