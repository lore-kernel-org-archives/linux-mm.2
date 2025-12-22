Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1A05E6ADF9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 22:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647A06B009B; Mon, 22 Dec 2025 17:25:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F1A06B009E; Mon, 22 Dec 2025 17:25:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3DC6B009F; Mon, 22 Dec 2025 17:25:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BFAB6B009B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:25:01 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1A6B1403D6
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:25:00 +0000 (UTC)
X-FDA: 84248538360.25.8D2DD64
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id CA24C14000F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:24:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NAPKAJDd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766442298; a=rsa-sha256;
	cv=none;
	b=EIo7yq1ZPsPW6nRv0kxu8Xc/bviviH/pHcYaEf3cr4+jYxtAl935jt+wQvL3pJWNoChaUb
	JebrfMms9lFRBcjIMvpSJC6SLFsQjfgc2OlSU/a59e6quyatKJmE7r8cyXgESGk2jmU3Id
	03Kc30vYve8SkxvCkgdIE/d+v3GHh8E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NAPKAJDd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766442298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sn/OAPJtWNCT0eie4rU3UF1I3TWQyxcji+TCrLJ8drY=;
	b=JnEfZeFu80GyUAVroDxc9SpmcQpWOr7ypdYNu5kMf20584BFifw+3IP62IZjLuUdt41q5D
	luoPpYDXAMERCF3/VhVDMhZqM31ESLtmEFvbx2TuC0bJAs2Fb0A84p83ScmViLbhlmgBVc
	BBvsEqNav1AWckj6u5Ims3+Ln9yHn98=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5959187c5a9so3975322e87.1
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766442297; x=1767047097; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sn/OAPJtWNCT0eie4rU3UF1I3TWQyxcji+TCrLJ8drY=;
        b=NAPKAJDdw9GC4DuxGazfMERxE+4hsYtt7J6V73THV86uWda+KixGkflf4q7xjpsDgM
         uNcVhNaWyZsWtjV9rX767OkyEoT9eM5X5nebpk8uO35t5hRuqXjzVq0ISJXKyfrgRAaV
         N4D7ZJw+5oXa595CCO7FfnXO4Cd8JYvuKV4Bo/GuqLxMXADwKBPjmNUJHGF1eZELtaeT
         06ZKtGE805SUrX/0YoLxMumRVeg1WtyvpczXxWZzk4CiJ8GwM0S4t0bya1Mdoafbfi3g
         lguymBmedTlMaeef01JqNdiu5e+XyaRf44hwDv4/yr4M//k4QD5qJ+9r+Xa0hSFSLA1X
         wDDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766442297; x=1767047097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sn/OAPJtWNCT0eie4rU3UF1I3TWQyxcji+TCrLJ8drY=;
        b=X9Rt17swkL5EGTrYaHQyJ+vbgLgEhC71xFy/gYlf/efCzQUFmx09HQX64o+vp5X/1B
         ExO3uElJtafFdw7NLVxdu3s1stI+pNQAzNqOplq3rTWY+/34fzjHpOG6wFyhMrqanq9x
         O41qc7C6i2yXQICTjzNMFDOgNk3JTbmNvs6mFz0XnTZf1MrXE/ApcdgAdi+CcF73egVi
         dETizWeHcwpawvEnYN1XtH5TSJV6k2ciYpoipBysLXuV+JteiSs1NJiwbBwmJrlA5H7x
         /SJCznEaBGL6qVK2tPIyQq3ENJu+R/d+Na4gD68rhVJOSRBSELzBGZPKGuFfO1DYw5E2
         zY+A==
X-Forwarded-Encrypted: i=1; AJvYcCWQD9Bw8GFA0QS0H0NoGjX3y+Yjus1NqFH5s5dknnNHkTRNAkSFsILo8tKKYYaqmKdr4zLfhe2WTw==@kvack.org
X-Gm-Message-State: AOJu0YyVr3NcLtOWUyOwfk+aKAOyUFArlBDs4+/uBVAsItgzQXdNia1j
	xZcmz1Uvqsd0pmuqepPqGDlOV2Ng1DSHlp3VaZzoYfniwvmIqZX2L5er
X-Gm-Gg: AY/fxX4vXaMkLeBhAWnbIrpVeUUvMpzuigZBTA1K/n0iJA3Wwhv/4w28x5NIV7H+X9l
	LxiHfhH3F1kzRMHCB59XBwhe0fRVSS/BA3P1L/0/QT+lDuOfgX8rIDzCMgb2JCdnXgicjQ/PFvU
	EGeRuhBh5aN0SztwNek0iMNXIaSFhq1avN09kfZ6H50Aq7s+hciT68e8y9NL7ksMBhyaAKLHXIY
	jnZ4NKlajTW2H2jSF52WciXNk0H5wnBjV0s5T/PBJoGnYCF+cfGRIjgZPYKNXjqwBot27niFiX5
	foYg5HzkBDdvjGMfoVqojc3Y52xbJtbzzzqMH6785oK+mRsQ0f4lPF8YHcHZhWjOiAbxcLIz4xV
	gMvIw0zgfJZxSF9o1VX85Qh1upD74dFkA4Dz+uBOt7jRMTcncBqjBgudyW3tIe8qN7GQVw75msP
	HaKsdfdp3j1yGb8ZK4jXQ=
X-Google-Smtp-Source: AGHT+IHKzpn400t05hIadcb+Wh63yw6NvPoXhFOWLmAT0LANkEjsAg/G6SFnu7Qr7y/2raDb+pTAgA==
X-Received: by 2002:a05:6512:2388:b0:59a:115f:5b8e with SMTP id 2adb3069b0e04-59a17dd70b4mr4476616e87.45.1766442296571;
        Mon, 22 Dec 2025 14:24:56 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-59a1862840asm3524409e87.96.2025.12.22.14.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 14:24:55 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	pavel@ucw.cz,
	rafael@kernel.org
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Tue, 23 Dec 2025 01:24:19 +0300
Message-ID: <20251222222419.1814906-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
References: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CA24C14000F
X-Stat-Signature: wwb7ukk1y1n1egotqk4mqdkw3c9moo94
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766442298-783378
X-HE-Meta: U2FsdGVkX19TfuE/KjG3A9WbcxaivG36NwZBPoa2jn4iglIsmClhtnXUZn4B8Xt2PiEXYYMhyHdjwvU21AoEqEsmPy3nlRsUdZTLpwi7loa5tszMSGEPLzxOLjyXtnA6M3CdoDHvI7xIT3a8rjosu70QqxRI0VmJtXr23osGWrRnzBO9cHBcE99AvUH39CNKMrziC9eO4L0HuCwUQ/hj8Efcr+fpkTUWRVCRBTamMV4jZlWdO+n3ZILAQnyiEWJnFGm8HozYVGSNMPWjPgXAGjInq+IB4dKyfw5Dm5BQAGSYiPrB4t9ojct4fudxsa3aNvU+AHXH9pnfwB8I+VgKhTZ9yJCw8VwJCdAGOyGKXCGGl1owbfaCASxm4t49Emh8N9uF6ihRDE89C9Iq9/ItlyEHzjGQ6UGKQWeZQy2265WX3oYf/u2jKLY3Y0IZmii5WsQOtR7RSzW++gqlC81Y8/iWp2PDMluvs+LqAbzMIx+mjBcEi9kAN67Fa+aE2sdixKzjS6PJsrJLHWupTB9yM8YsixAiGUAxZEa6Jl+oG+DV1pCpqKFbZigAWv3G+nyZoOMBLD86ni0L9wMIAI3fMsXdGa2u4RhR+4xQ1Xt9ww2ptaw3muf4PS04kyJyFC3GEKnK/zoTWC0UgN7rG3QyR97j8jsYHJsg9zXKA4AVsK9QeIEYT4kHAdV7e2MQALywjZ4z7YfB0B62opfKiSBJnBhmGOokElGAW+rIHV3fMDP6EminG2FmBqV4aFB8ZXL6RrkUwOcpxDJb36FZ3xurMO7vQBE+a1U1TplXexh90xc2ojUWkaIQ5s2x0QSPL4oVMhfFhmJZBKkOYUKWAVMQikb4GBrZvcHyZ/tI+m9L3/tw2jGLZgXVGbXHeq3eldHog27fZnFAwiRnEjIb3d4HphpPoF1Bou/wN0BShENRx8u7MejpBnymfkylTMkuEIqTdf/iCljopdwQPpv3gbx
 FKCQ9pNa
 v1rDae3b0PaI1c2HAoDJb6B349EN3DcCx1cBYXAAwG1xvLQNr2Pb1UGSyJ+Nci5UZEkxfwqF7EYS7AB61WtLfmmEgOn/ks5Q1/yodAkouYyHd8TSMDFhXQoa9VgpcaLnvOGwAzfrvrAyjSe1c0mSjHcYQZ1qbUpbYUUaiLMUsY09OvNEYzr0fTTJQih/gOiihujS3AxhHdb1LxEuMkV9U5MdAGnJhHbC0r9pWu2o01tUmG0EUedQsr97Pau/IwZNhu8pm34jIlOSfCroGASTT/nCvIFW1J1z8RVtxsv6EWyuhSnfm0BSPOp4hqAztUQBZliFZ46abjcc7t8WXr3N7yRENn0vRuA0GAzx2RANh6wl3OM0ik6mcHhC/Wy7i9LfqkZ2Alv82ANRno+NijG4H31mSBBvI/meenfzgOy3Cicnv2yU2fm9q3iyho0JFvmEeoQv+TUcZbsNWeLPR9zHDRQkdhvmKjZyREmzLVc9yMS52b8Utuwdglcku5PjmFyy+Wh55p99ABbYneze3mGX4N6/L5LLs1oY/bHhj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Milan Broz <gmazyland@gmail.com>:
> Anyway, my understanding is that all device-mapper targets use mempools,
> which should ensure that they can process even under memory pressure.

Let me give you more details.

Here is output of "free -h":

               total        used        free      shared  buff/cache   available
Mem:            62Gi        47Gi       924Mi       2.4Gi        17Gi        14Gi
Swap:          378Gi        95Gi       282Gi

Swap is located on dm-integrity on real partition.

As you can see, my data does not fit into physical memory, so swap is required
here.

But swap is big, so in theory allocations should always work.

I have a lot of Chromium windows opened (nearly 200).

My laptop is Dell Precision 7780. It is high speced expensive laptop.
I have 64 GiB ECC physical memory, btrfs raid on two 3.5 TiB partitions.
Everything is located on two 4 TiB NVMe SSD physical disks.

Sometimes whole system freezes for several minutes when I open new memory-hungry
Chromium tabs. In such cases I see in logs:

https://zerobin.net/?383b5c32b958aca8#yXmgYidkC8pUFixwQKB+v+O3bkbis4RHduz3gji4DxI=

Notice that all backtraces contain shmem_swapin_folio, so swap is involved here.

Hibernation works thanks to my patch
https://zerobin.net/?ad6142bd67df015a#68Az6yBUxHA3AXB7jY1+clSRnR745olFHAByxwPGM08= .

My kernel is 6.12.48 from Debian with my local patches.

Sometimes I see messages "page allocation failure" in my logs. This is very
strange: I already explained above, that there is a plenty of space in swap.

Here is output of "journalctl | grep -B 10 -A 100 'page allocation failure'":

https://zerobin.net/?4170949dd9a8b25c#p5Z73TfGgpem4O4UsiWllrMCLCoHzDEw+KwJ7n8LWPA=

Maybe my swap is fragmented?

I that logs I notice that:
- Allocation failures often happen immidiately after wake up from hibernation
or suspend
- We try to alloc page of order 4 (what this means? 2^4 pages?)
- GFP mask is "GFP_KERNEL|__GFP_COMP" or "GFP_NOIO|__GFP_COMP". Failure to
allocate in "GFP_NOIO|__GFP_COMP" case is somewhat understandable. But
what about "GFP_KERNEL|__GFP_COMP"? As well as I understand, we are allowed
to do I/O, so we can drop everything to swap. And swap is big. So why we
fail?
- In all backtraces "dell_smbios_call" is involved

Hibernation always works, but takes a lot of time. Usually several minutes.
When hibernating, I see in logs this:

Dec 20 10:02:18 comp kernel: PM: hibernation: Allocated 26015132 kbytes in 193.21 seconds (134.64 MB/s)

I. e. 3 minutes to allocate space in memory for hibernation image.

And sometimes even this:

Dec 11 08:34:26 comp kernel: PM: hibernation: Allocated 25942484 kbytes in 348.90 seconds (74.35 MB/s)

Also sometimes I notice that in browser background for one site is replaced
with black rectangle. So, I assume that browser failed to allocate something,
too, but I unable to find this in logs.

> Anyway, my understanding is that all device-mapper targets use mempools,
> which should ensure that they can process even under memory pressure.

This seems to be not true. I see a lot of words "alloc" in dm-integrity
code:

$ grep alloc drivers/md/dm-integrity.c

And it seems that allocation happens not only in initialization,
but also in normal operations (but I didn't looked at code carefully).

Also, I see a lot of mentions of bufio in dm-integrity code.
As well as I understand, this is some cache layer. But, as well as I understand,
in my case there should no be any caches, everything should be written
directly to partition.

So, how to debug this next?

Maybe there are some ioctls, etc, to avoid this problems or to enable
more verbose logging?

I even okay with inserting some printfs to kernel code, just send me patch.

-- 
Askar Safin

