Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B672CAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 15:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A018E0003; Sun, 21 Sep 2025 11:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70DE8E0001; Sun, 21 Sep 2025 11:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987638E0003; Sun, 21 Sep 2025 11:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF648E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:08:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A41B119AEA
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:08:35 +0000 (UTC)
X-FDA: 83913588990.15.CBF2633
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0035D180002
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:08:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DyX3ttBu;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758467313;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQ5Rl+x/PE+WH8c0FsTmxn4J3gmnwc4CrD1BWHgi+RY=;
	b=HJpU4++yloq46kBV7aC/4NiOxnNwXkVivyd1ea26+iLzpD9Iexne60JOF99qUvzREElu6x
	ajvgxLcIHOHGLFJybAKyVWSKk9bRw9ZCoZrJEli6TtpqPvNLJByBc8PJRvZBamHhD9ACaP
	2Af+oqNES9q1uAQtpc6D1t9j3nm7JmA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758467313; a=rsa-sha256;
	cv=none;
	b=RRqs8z1RQvjQ7sTDDodXEcZ121V3G+6cLktDkLw8scwNyNo9x5fUhbcbXQTDtEZSyNVfTt
	LtZoqVDSv/hPXyt0cK7DNCnGMTh6VNHQ0a2NesUh0HY7jpGOqyBDGYGYRyBkaZl32RUzH1
	9xm3Ox0J11lWwzwzeqpHb6svrMaTnF4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DyX3ttBu;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-62fbfeb0870so3267808a12.2
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 08:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758467311; x=1759072111; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VQ5Rl+x/PE+WH8c0FsTmxn4J3gmnwc4CrD1BWHgi+RY=;
        b=DyX3ttBuYUnClwoPVHkxech91gkk9s7SZdzHOZA8uLKtZeM5y3V7at16m4hiHIWYFg
         llbJXwwyvAUAPbQUhVPXciSMKz6tYz4MpjGt7Z5T50dZCU76JQWGP2s8rVMdqEeHkiNo
         iYeBxtDvu7lmR95S+7UCjm1Ki/+Yo1A3fHnajKKK0WAn5fIwiM0dkkx06hFxBq9jN4Qj
         3eMKhj5kkNhNmRByP5MCsIqm4q6yzII/dKTIv0t8eDQ9nsdP0hkj34dy52j05eRphqNR
         O9XByBvmHpEkSUhK0ASk3+OBGHZj3MmkKlrhjgFvbsY+FZEQIzdYeNNVSNPvquu5Vp4R
         ciiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758467311; x=1759072111;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VQ5Rl+x/PE+WH8c0FsTmxn4J3gmnwc4CrD1BWHgi+RY=;
        b=BUdNnhb0XzJiV2+MNFSZTGZd1mm0zR6NXevVZCC6mDIXkcVSrVVMyLzGzt1LA2nw3i
         ZSFY1m2S657RTtzW23TtOKC9I7YY+egmKBLYJqU6quo7qqysekzuk8JDuz3552kgRU4S
         nzzT/YeOBHROAhpd0esCkHIPw8aPPCNPujWxGSXfWMtFYjwjR/DJ1TodYBvMkvRAz5Kv
         DPkFdWSwGBFgd0n6ZcMPnV9Tir8kJN8WP1do5YMlpz1eza+A6bLzqj9syF5FeUza6OSt
         aEMzrd6+Sx7msf73a2Tx72XtQR7B3b+U8BOHqhquAfsML768/e0gVx48Te41XE3myq/X
         s4/A==
X-Forwarded-Encrypted: i=1; AJvYcCUw14q21rbBkbQyfMXjbjE8RnzeYCz53DJJuxo6l+lgnCejxXp4albJJJ8sszb15CcrTiBcjGPRdQ==@kvack.org
X-Gm-Message-State: AOJu0YwLyoCo5alNSfMQPnE/EonBENJlzxlAYrCcYRqUVJahL+jRStd1
	Fpri9Fd8XjhhBCfAMN+JdPptPsmPkRQ2wE52vXsNTdiRGp5m1Fm2fpTH
X-Gm-Gg: ASbGncvqaHp91hVBPb4qkNqEMFMKVTL8XfTQaym+V6UODLS1p1iNTkbw8Po0B2Cb6p7
	E9GnZBpGOcpgZMeKZeqBjkrfrY716kOXzGQ4JcwhPptM+c3HdymH73hOT7IgedKGRfEy1yZeZoS
	isKVjuX4d5zDLCdY9DqgkMb5nKHboxL41XlKu3+69ahq39Pp6AcxRogL+c/v9MyR3ZoSaAt1gvn
	iYncUiOnFHB3iMMdmEbJa4P/xZsitTBN1+oPbaeJUgd6HuTycXLcZsThA8XhvFKyTBPsI1clF2P
	s9I9hoGaZw0/7grgF1Kio8tGH45ba2edPpfowGhPLfqb6iX/H3lXmPcLEYcfOlqVj/OuRwUnBvv
	EhMZkmXaO4h8FZFCtiGI+0Q==
X-Google-Smtp-Source: AGHT+IFVXPsQOi7XpKUWlqx+j+o/p5nBExkNinSkO7HNDpXBS270I9E9VO/QVVuJoBzzzJhwMUvwPQ==
X-Received: by 2002:a05:6402:358c:b0:633:4726:a077 with SMTP id 4fb4d7f45d1cf-6334726a7c7mr1226688a12.15.1758467311085;
        Sun, 21 Sep 2025 08:08:31 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6313323f85csm3322918a12.41.2025.09.21.08.08.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 21 Sep 2025 08:08:30 -0700 (PDT)
Date: Sun, 21 Sep 2025 15:08:30 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn,
	linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>
Subject: Re: [Patch v2 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
Message-ID: <20250921150830.buufaqnc7x2zpdvo@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250920122958.nf6vcm6iyl2wz3bj@master>
 <20250920134130.84541-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250920134130.84541-1-sj@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: bncinirsbxo5axy1mtejs5bmng66kd9k
X-Rspamd-Queue-Id: 0035D180002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758467312-928255
X-HE-Meta: U2FsdGVkX1+0PeX3syHNzCJXkVNRPFmp5JKzlo/vxXJflTGQKPNarzW5xYl8e/p0fG3czBceAtkUHBhhGG3mWSJd/T39aZ3HQD7878CodhQ7elVv4ge0yYXFLEh4OqtHnY0qE82WoHjYoJ+Hy1gZNBFKNPYerrQEK5SNBL60FiNp5tddO/QCXREgSUsFMWmixni1JtCgb9E4VCpZa+wtJY/qQ8vC6j8qeXy0GHeDInXyAoanJExOjuu0DRNqSkl9laT30uDNHYeQKIpzGyxaLjIk1OO788e1qPK5FmPH7+53Ayw9qeRTinVdcvj28zpmPLKswMXtN3oYSlFrmVcMCe1XhGehR+dK0w+hzV5Y+Ku6n1XuRF4Q8IZt9qopn8KYDZEI9LR1c2Ab30DCcVOQH9nOuWlVvNRyL2QjFu8qZaXExzRwHD5ay9fHEMWSeaEmVAK58nu5vJ4d3/2NrXVeiX1dyh/wDL2OGnsFukFS0dMbtAYGYbeoX6bU4UfOLquhomNzVp+Uu8TCVWFeyqxoNx0QGTd9/2Ivki0eCbQ3PGdYNZkKzNwNvRhqro3NueFMmduwYkbUoYnV/5BLT4voX1A/zyWGxBWDTre+U1Uiaas02BN6dfiYKLDWBuZ/K7lcmk5ybyokHjq2bvUbzdx0UCq4oGHI/8FMgizO2R3JAWCpcFbCzfUF8Nd/jVbmvrqSd0RK21Aj5aO3W1176OapPTvMSJCfZ/hIFDMmg407JRP70dBdtZeH8DdBBg+fLRCaFCc8IabnxSuAa9Kww72Dom1CqXtLqYdfW90MX4qFB8EueNbiFeuLsDfHAhkqp/AHwu2xBH7wL7C/aARZKcPHoMTXNMp6qVA5tm6qsS1R+FSoPbNgm+fy3uC+6zA1P4b2FwJot6yQS6acLBm8naB2ynNaJuw3iAgKLDgWis81Tsfmnt/mVEk9hRgsu+RzsBeVHz3s/aEvTfCHN0YuJLe
 89z0IsVI
 v5e8ZpoD4OYd5jAw8c5CLHDy2kel8HrfjMFSXYOiQgR0NPiA2A7mHhk6fa7/3iF/FL9mrLkOnrqOKW9vvjZ2dDUjf4XJz30ibiGcw+FsOAMzilPiIgpXk5fMPrUiltgBejjV/WDkhvfhxLbBIfMhL+tmkuc7ehXdQyZy26y4M6JOENA77FcXy3oRpDfItB1LqO/1f3XFl3KjFk2XUV8d9WOtzhL7V3Bsd9z3LsEvvm8LEnRVMolNM8QI6i2474+vK3uLjs3E3uwQ/J/NwYWsn5BDkUtteMPmaxgQw3QICvGnzYdzFOgvGrFojOMR7XwhssViJOYOT1dD7YcZIJ2ogY8vKj0Sx4SeQTel9D4bjnHUYGZKCOfc0pkhFC7dHfD8xYrotDTnJeEMiTJfeLLT9QHOwK3Ftfw04lBxC48/lTLgGRB+A1Jt54uUxAm3/oPrm9v8ICinvGuwyambzHD/nMk7bmPuBSa6KblrGJaoDf95fFPE9MOXwX/XcMtYZAk/RrtzfiixjfDa3y7g/HgdBehR2CE3fEuBLfvFbvKjRnD8+4lcUObLGg3qPHQoGQ+EiB14i5lzTCz5t/yVc5RtCrW/mz1SKIiDNdiElYk75cVAmVt4i/FUP6oaouC4+FS5RulyijddpUcUUbgdgnj4VS6N94vPIbyLBufPqgEKGXouK5dtHybwQ1egrNqKe3c8jUrwWV1VpneMPDTAr/KtEGEfoxlsedIoUry0VtoE2fyXQvAlb3ft0ioneDfsCAolT0heETcpcuWIRGH84UF0SgWwy/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 06:41:30AM -0700, SeongJae Park wrote:
>On Sat, 20 Sep 2025 12:29:58 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> On Sat, Sep 20, 2025 at 04:52:33AM -0700, SeongJae Park wrote:
>> [...]
>> >
>> >On latest mm-new tree, I am getting below error while building UML mode kernel
>> >for kunit.  And 'git bisect' points me this patch.  I'm not familiar with this
>> >code and have no time to dive deep for now, so reporting first.
>> 
>> Thanks for reporting.
>
>Thank you for fast reply!
>
>> 
>> >
>> >Oops: general protection fault, probably for non-canonical adI
>> >[  356.456907] CPU: 34 UID: 0 PID: 309 Comm: khugepaged Not tainted 6.17.0-rc4+ #370 PREEMPT(voluntary)
>> >[  356.457702] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-4.el9 04/01/2014
>> >[  356.458484] RIP: 0010:collect_mm_slot (mm/khugepaged.c:1427)
>> 
>> If my understanding is correct, the error happens in following code flow:
>> 
>>   khugepaged_scan_mm_slot()
>>     mm = slot->mm;                (1)
>>     collect_mm_slot()
>>       mm = slot->mm;              (2)
>> 
>> Looks the reason is slot is NULL at (2), but we have already accessed it at (1).
>> 
>> Not find the cause yet.
>> 
>> Would you mind sharing your UML config and test step? So that I can reproduce
>> it.
>
>To reproduce the issue, I do below:
>
>    $ ./tools/testing/kunit/kunit.py run --kunitconfig mm/damon/tests
>
>Then the OOPs happens a few seconds aftr the kunit run, or during the
>kunit-purpose UML build.  The issue sometimes doesn't happen or take time more
>than seconds.  Since the code is related with khugepaged, apparently there are
>some timing factors.  But I was able to reproduce about 3/4 times.

I run Qemu with kernel built from mm-new base commit b8086c280108
"drivers/base: move memory_block_add_nid() into the caller". Then run the
kunit command above.

Not see error for around 20 times of the test.

Is my step correct?

>
>It was also reproducible when I build and install kernel on my QEMU machine
>using 'make install'.
>

Run qemu with the same kernel and do "make clean && make all" several times.

Not spot errors yet.

kselftests/mm/khugepaged pass with this kernel.

Will do kernel build for more time to see the effect.

If my step is not correct, please let me know.

>
>Thanks,
>SJ
>
>[...]

-- 
Wei Yang
Help you, Help me

