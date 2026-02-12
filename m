Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD15EEA868
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 22:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492DF6B0005; Thu, 12 Feb 2026 17:19:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416BE6B0089; Thu, 12 Feb 2026 17:19:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7CD6B008A; Thu, 12 Feb 2026 17:19:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA856B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:19:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D98811C249
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 22:19:30 +0000 (UTC)
X-FDA: 84437222100.14.D33974F
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id D6A0318000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 22:19:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qYp4lMrg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770934768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3sOVu+LZVYjTdyRDxGfxmfxaK6EYfuCHcv1YcBN5FA=;
	b=WkTZASY2P3JXg9Ud8mddxqgndCreD6zqnNR1rT7YEpIjojXgDb4GUq5sGLaj8TxQAZddHw
	uBsWLiVplHbZwaTK1cmrFHKVZX5ffivSStPVelE0WkBBwSgOInkE09Mer/fij/Iap55mkB
	rR0jz7vavykFNa1tq+HvZqJasFd1uB0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770934768; a=rsa-sha256;
	cv=pass;
	b=1MRPrlZe0MJAIQyHsO6nJkPLfsVszsvsFY4yNCtB44acRD/pm35Nkup1xXJ82Jfg0E7JwW
	4SMLXRQYtQ+SW79vTxDXBf14aPpYOL/i51fNMrbw5ibYky8FbzEPwVmhTILQL3BciDO2KN
	3HOxXZykYKu2FqjVsdeb6FDjlMbqles=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qYp4lMrg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5674d8be45eso112064e0c.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:19:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770934768; cv=none;
        d=google.com; s=arc-20240605;
        b=WSqEgD2stZ/woClJrii7ZnP6I8UxpPj5KLXBPYzpmoFZ1CmnFovp+16utHSvkWVAg3
         2HBe6NbZUEl5T0lVstQQ5zsaa7rnTJY/UWT5okkSlxhPtlZGtHXUWmflBAX4nQ8VKGFn
         Xccg6cydgxId//NSV/mJAQB9uJWnI/QE+SOz7tdBq/ntjLgW2i+SLpPxcz+wo+MixeE6
         5NsuXLFKlitCP7sJj16YEIvPg4p+PLGsL5E3zkTBfBlDgsiWgrTYQx2aC1KPRHD7HFsg
         NeOgUTjUVq/BwNqkDoUxwx1AcQy89W6MiE43jqhVKWbA0XMIUiUwnJRsMzYMvXVawRUd
         gjWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=a3sOVu+LZVYjTdyRDxGfxmfxaK6EYfuCHcv1YcBN5FA=;
        fh=tv9ej8SBujGCMEXPBkTMogH1RKFrQ8l6p714C9n7fJg=;
        b=OJp+61KWOgftlhjFXHNY0dJYI26u8zu8k4BetXPQCwTW+lKg/R4+n4OZWumKgtNXYn
         lihUKU8piOPLEUWCj6SZPJjfDcJB5kMT+KfzlJtYCV5sRwJqIL1k5IMAEDzGoujx+Rsm
         JgFR7aHpcPO+57IdQAXq4MHI8mKYkc3j66LqUIsAA332lyi2UGQ0htWqtNK2TayIq+ef
         Zz/anc8hofvfWS3JiucRSy1YL/d1hA015ty+FeKoEtEVb2zFr6MMABt0RzWLyW6QITok
         UwVV7F0RmStWl+1pzu/fgfaAvLfSmxgOca1Fnyi+AY2z4iIliZOJvz4o3rt3Q7L9rp8K
         BR5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770934768; x=1771539568; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=a3sOVu+LZVYjTdyRDxGfxmfxaK6EYfuCHcv1YcBN5FA=;
        b=qYp4lMrgEx0Wl1CWyHrhYdIPfp8tkahxIpuLSsprWW9LhJOHXGqoKf8ZXkAtUbTTpJ
         wjpZG8ghG1n/ALn8jVOxrii9XW7aGtaz0GiSJ1emC4BFb98GkKbOIUp4iisoRNV9oqRc
         yiZfaT4e/48I0cRiGSmYNg0e0GghilkK4ku8+D3LdO2MHoxXsPfb9IWgKo3Uy02I96/w
         95s2NEDPrBqhVOw0rua3rJxczWhGJgge2pzYNDV2KFv43HdL4jM6WpZ+/tJ/TnMi7qGV
         6BKqAnVniyFXQxrQXBStx93vOGsgGsqjj257bhqNzFeGyT2wnw8ty7kcAPdc9jx1NUuA
         iZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770934768; x=1771539568;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a3sOVu+LZVYjTdyRDxGfxmfxaK6EYfuCHcv1YcBN5FA=;
        b=h+1VZVIKUTHOvb3O4kAxVyi4asdNz3ucnh2PZ5mPhqtHU3vlpjqSWYZbhO/1gwg2wV
         Y0c9FOU73QUszMfb9iP7KLkHvyxnikZlKxt5lmgsDicLkgFi5KyBTYzmlvxpyO3JURPQ
         oCHdnGT5S5FJdQQmGMJeiRtVYV3UkniC1yPIYPfExXqny8LNtXPSNWrvZ5/Rkj7iKcUt
         t3BKBtfreH8dO2tOua+6guFHStIE2bpmvaWn9Yj89IQpx3LsuVCWjWYWe1iGRwrGNFxG
         uzbPWp0oCFQ139RW91lYsOXEUiT7eBd2pdkiDlH/uJRuJ9NxRRkHl4fYTlZEIcIZazqA
         a20g==
X-Forwarded-Encrypted: i=1; AJvYcCXVCH7QqGzr227UKVWDmuGzlCsUZ5FaIyqtHgWKSW8p0LgXeT+MmBnqtpA4dPJ/Zu6NvqtBZZcpOA==@kvack.org
X-Gm-Message-State: AOJu0Yye/v2ZVRZHw5hFoXBlGZBeVZPJk7Ja3f0IgyeSZhSlR6t6+QRf
	3FuwEm3FtctGRmiVb5YuNp+gECWoqDTlEcM1RYeDC6Hw4dAX/LgyvBAwtu6OAlKreSltc+1ptLD
	0n2CsmamfNWlOxiExzmaUMBXbqpuB9VEyMSDVb21R
X-Gm-Gg: AZuq6aIyKahqulqvEDFh1z+L1XxfcMItc5p53HB2Sn8CfT8WNq8khUuFM69wcajN8xH
	/t3/EfBgkKnqOGzQwe5dKdJtLgojxuNpkMa8iGmslxrGKl1OE4yhhT4K9/qKEqqqgesHBlPIeVW
	fIEtEloAepG55yslb/Dvm/TiCET9QD7CAi83C2ecfsvrZmOnKkTmvXzhh8Rt/Ck18hY3bDfY7t/
	bPISSiZ76SDOPvmiU1M7kFoB9MO4kXPzSGxNJVAshm0JbLr2NfROC7CYdUXb/hZgJENU4d921ji
	CAfKl33T/74fy7L7aTS82d0ABmmV5+SVjVBNI5fguTfMYucktgBZz/adP4+GzVhHvn2AUVA51Ju
	aSLmL
X-Received: by 2002:a05:6122:2504:b0:566:453e:37ae with SMTP id
 71dfb90a1353d-5676824dc5bmr132718e0c.13.1770934767234; Thu, 12 Feb 2026
 14:19:27 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 12 Feb 2026 14:19:26 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 12 Feb 2026 14:19:26 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <5eb7aae7-f642-43d2-810b-d7afd867d665@kernel.org>
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org> <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org> <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <bac19363-0705-4bb2-b022-66054e1f28cd@kernel.org> <CAEvNRgH6yfFtOK3E3__hCjkNTQr55y-_N=SpBBr0i9_q6E2_8g@mail.gmail.com>
 <5eb7aae7-f642-43d2-810b-d7afd867d665@kernel.org>
MIME-Version: 1.0
Date: Thu, 12 Feb 2026 14:19:26 -0800
X-Gm-Features: AZwV_QgPQnyNf4Yx87-SiJgefQNyHVopqum0-GIjRxoOkTAMZgtv0fsZFCPwzds
Message-ID: <CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, 
	pbonzini@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, 
	Fangrui Song <i@maskray.me>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D6A0318000D
X-Stat-Signature: jducsumdcnkumc667gzs1sci6qdpcqw5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770934768-36981
X-HE-Meta: U2FsdGVkX1+gljHOWwH66Zp2f1gWZcLrIh60rBP/RD4lG7K+tMfBzF6mgA1wETlhqP4GHL8fcH+ywSsTqv1Sbn91pVqQ4gtqNDan8XUq9bVvhu+ahjORAGv410wQ59G7gckX98o/Xmk80C4rc0KXrb1GBBavQO35c80/UF5hiO8yW3HCRUPmZuTC1HHX+6a0qso8nyM/2caKNx7/jUsbUtT7e/EnBppsOtc8NOiOKcy+NiDNrSJXonI4gRFASdpW6wNijD3IxSeu/T5QQ2A+4tYkTthjVdaWBzielrkVquUJksLxvS+bplqctymnIQDG29F5CPOkKsahwaqvxa0rnE6v+3MOKmSuoktcYIzGp2sI/GxOL9aWh4wcyMURG69dU7pccos1SSHuv4JsxqSZ1jtYlCU5vRqYNKQomSwQbecZH/buYXtDgcALllgDL3vinF0qkK7ukgtVsUCQ4/J8aPoeXvwPijSkcItYD9T/GyfFoLv15DzdExE+ZedJrmYVUzkEEUtrFn/gxDekhEamIDizMJ4KG+p19tquKriYXl8EfTVqkg0Fb8SNDTCOo6QgMc4fcn4Xq/Iwi0BkcftxmG4XYGXvCHexEd0BdO1H7/nrC37ydwne86OnBoN/tNwqcsNAPtITOypEmiLoQSmW69GnKPy2QxKZI56TXLEMjacsYuPhXhXPQuA9085EM+2Sz7XUGLEro4XYE8rZqJEEvD8nBKCnBS+sOjv057M5QPmWcio9fVjVdmYVuP8vJhIMJDIWS3CA6q7gPDOl1ANF9Tow5ZIrssbOAIozKp+SOybV+R0FXO8cqL3dgShaJ5079F0/Hsjn4IpCkPiWCaDklP9GX11KQELe0IA3zJbwQT984oIQ9s4Dh6Uqe8hmCK8Lv15vQhRj8N5DVvjNADbfWbDC0/azQiL9g1oqqIqlAjl3LAWbSMN6EzBIVh1OOyXJPzvcN188VLRtMkB5m+t
 4ffyYBxI
 gnUkmfog9GMpe7+KdptPlT0VgUJYJmqetUaUpqI72Bw26fDZ1q5YkFSYH4IQmr3DZEUCljdyGDHR1K1kv+WdTeeSxwotY+tmrueyLc+tExh/JSRbPzsBsnwQXU6IhI3F8oP6noFXChnnxtiY3F/gobwCXLT1K4S/gMxA4QzrZniBf8BPX8qy2hZuHktcZwAn8qcuKgLdgk94aBiMqdpBsNXjAdowD4pYXkHb1V04heYZ/78hNurKD+LUosp+3HukzF0ThyJfZBzKkMSA2nSHIHE6b7vQdfmfhnXcaaP6mZ3lVyC4D6f1q4hwQFhGUE0SzXYnLTcsHDI0UTtaCCN8tMxH3SnlTn7oFoGvGPFtS0viKY7ucsXDuqGoUNDTbXwIozLmlEQYcqRGaAswO3iuzS/ir6nn87D8tlyqG6M+mrmUZw9DVDzvfQ/sMG2OTr1VewBhQWzR0mqS3phGlF2lu0UoP5rm5z+zbL41ZWbWnI4NqHVbNDHjTMERR7gQC/85AVMrq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

Going to try and summarize the findings/discussions here, copying from a
few earlier emails. David, you can jump directly to [Question].

> On 2/11/26 16:38, Ackerley Tng wrote:
>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>
>>> On 2/11/26 00:00, Ackerley Tng wrote:
>>>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>>>
>>>>
>>>> Seems like on 5.15.199 there's a hugepage_vma_check(), which will return
>>>> false since secretmem has vma->vm_ops defined [1], so secretmem VMAs are
>>>> skipped.
>>>
>>> Are you sure? We check for CONFIG_READ_ONLY_THP_FOR_FS before that:
>>>
>>
>> Ah... I was working on a reproducer then I realized 5.15 doesn't have
>> MADV_COLLAPSE, then I tried to hack in an ioctl to trigger
>> khugepaged. That turned out to be awkward but it got me to look at
>> hugepage_vma_check(), and then I went down the rabbit hole to keep
>> looking for the similar check function throughout the other stable
>> kernels... and amongst all of that forgot that
>> CONFIG_READ_ONLY_THP_FOR_FS was unset :(
>>
>> You're probably right about VM_EXEC.
>>

[Bug]
khugepaged (and MADV_COLLAPSE) will try to collapse secretmem pages with
MADV_HUGEPAGE applied. There is no crash, but there is a false memory
failure printout that looks like

    [ 1068.322578] Memory failure: 0x106d96f: recovery action for
clean unevictable LRU page: Recovered

The correct Fixes tag should be:

    Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")

I was able to reproduce this on 6.12, 6.18 and HEAD

[Stable Backports]
The first stable version this affects is 6.12.

In 6.12, S_ANON_INODE does not yet exist, so I think in
file_thp_enabled() we can return false if vma_is_secretmem(vma).

6.18 needs a fix for both secretmem and guest_memfd.

[Solution]
For 6.18 and later, David's suggestion of using IS_ANON_FILE() seems to
work. This affects more filesystems than just secretmem and guest_memfd
though.

[Question]
I'm not familiar with the concept of anonymous inodes. What does that
entail? Why is it suitable in deciding THP eligibility?

[Next Steps]
I'm going to be traveling over the next few weeks, so perhaps Deepanshu
can help with the fixup patches for 6.12, 6.18 and HEAD?

[Details]
Here's a reproducer for 6.18 for guest_memfd x MADV_COLLAPSE

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c
b/tools/testing/selftests/kvm/guest_memfd_test.c
index e7d9aeb418d3..8760fe6fa482 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -371,10 +371,45 @@ static void test_guest_memfd_guest(void)
        kvm_vm_free(vm);
 }

+#define ALIGNED_ADDRESS ((void *)0x400000000UL)
+
+static void repro(void)
+{
+       struct kvm_vcpu *vcpu;
+       struct kvm_vm *vm;
+       uint8_t *mem;
+       int fd, i;
+
+       vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu,
1, guest_code);
+
+       fd = vm_create_guest_memfd(vm, SZ_2M, GUEST_MEMFD_FLAG_MMAP |
+                                             GUEST_MEMFD_FLAG_INIT_SHARED);
+
+       mem = mmap(ALIGNED_ADDRESS, SZ_2M, PROT_READ | PROT_WRITE,
MAP_FIXED | MAP_SHARED, fd, 0);
+       TEST_ASSERT_EQ(mem, ALIGNED_ADDRESS);
+
+       for (i = 0; i < SZ_2M; i += getpagesize())
+               READ_ONCE(mem[i]);
+
+       TEST_ASSERT_EQ(madvise(mem, SZ_2M, MADV_HUGEPAGE), 0);
+
+       TEST_ASSERT_EQ(madvise(mem, SZ_2M, MADV_COLLAPSE), 0);
+
+       TEST_ASSERT_EQ(madvise(mem, SZ_2M, MADV_DONTNEED), 0);
+
+       READ_ONCE(mem[0]);
+
+       close(fd);
+       kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
        unsigned long vm_types, vm_type;

+       repro();
+       return 1;
+
        TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));

        page_size = getpagesize();

console shows warning:

[  558.315452] WARNING: CPU: 1 PID: 252 at
arch/x86/kvm/../../../virt/kvm/guest_memfd.c:372
kvm_gmem_fault_user_mapping+0x120/0x1c0

stdout output:

# /mnt/host/kvm/guest_memfd_test
Random seed: 0x6b8b4567
__vm_create: mode='PA-bits:ANY, VA-bits:48,  4K pages' type='0', pages='657'
Guest physical address width detected: 46
Bus error
#

Here's a more complete reproducer for 6.12 for secretmem x MADV_COLLAPSE

diff --git a/tools/testing/selftests/mm/memfd_secret.c
b/tools/testing/selftests/mm/memfd_secret.c
index 9a0597310a76..2a0c5cc9fe20 100644
--- a/tools/testing/selftests/mm/memfd_secret.c
+++ b/tools/testing/selftests/mm/memfd_secret.c
@@ -21,6 +21,7 @@
 #include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
+#include <stddef.h>

 #include "../kselftest.h"

@@ -299,10 +300,145 @@ static void prepare(void)

 #define NUM_TESTS 6

+#define SZ_2M (2UL << 20)
+#define ALIGNED_ADDRESS ((void *)0x400000000UL)
+#define READ_ONCE(x) (*(volatile typeof(x) *)&(x))
+
+uint64_t get_pfn(void *addr) {
+       uint64_t pagemap_entry;
+       static int fd = -1;
+       uintptr_t offset;
+       uintptr_t vaddr;
+
+       if (fd < 0) {
+               fd = open("/proc/self/pagemap", O_RDONLY);
+               if (fd < 0)
+                       ksft_exit_fail_msg("open pagemap\n");
+       }
+
+       vaddr = (uintptr_t)addr;
+       offset = (vaddr / getpagesize()) * sizeof(uint64_t);
+
+       if (pread(fd, &pagemap_entry, sizeof(uint64_t), offset) !=
sizeof(uint64_t))
+               ksft_exit_fail_msg("pread pagemap\n");
+
+
+       /* Bit 63 is "present" */
+       if (!(pagemap_entry & (1ULL << 63)))
+               ksft_exit_fail_msg("Page not present in userspace pagemap\n");
+
+       /* Bits 0-54 are the PFN */
+       return pagemap_entry & ((1ULL << 55) - 1);
+}
+
+bool in_direct_map(uint64_t pfn) {
+       static int devmem_fd = -1;
+       uint8_t bounce;
+
+       if (devmem_fd < 0) {
+               devmem_fd = open("/dev/mem", O_RDONLY);
+               if (devmem_fd < 0)
+                       ksft_exit_fail_msg("Can't open /dev/mem:
%s\n", strerror(errno));
+       }
+
+       if (pread(devmem_fd, &bounce, 1, pfn * getpagesize()) == 1) {
+               return true;
+       } else {
+               if (errno == EFAULT)
+                       return false;
+               else if (errno == EPERM)
+                       ksft_exit_fail_msg("Access probably blocked:
%s\n", strerror(errno));
+               else
+                       perror("pread /dev/mem");
+
+               return false;
+       }
+}
+
+void check(void)
+{
+       uint64_t pfn;
+       uint8_t *mem;
+
+       mem = mmap(NULL, SZ_2M, PROT_READ | PROT_WRITE, MAP_PRIVATE |
MAP_ANONYMOUS, -1, 0);
+       if (mem == MAP_FAILED)
+               ksft_exit_fail_msg("Couldn't allocate memory\n");
+
+       mem[0] = 'A';
+
+       pfn = get_pfn(mem);
+       printf("%d pfn=%lx in_direct_map=%d\n", __LINE__, pfn,
in_direct_map(pfn));
+
+       munmap(mem, SZ_2M);
+}
+
+void repro(void)
+{
+       uint64_t pfn;
+       uint8_t *mem;
+       int ret;
+       int fd;
+       int i;
+
+       printf("%d triggering secretmem\n", __LINE__);
+
+       fd = memfd_secret(0);
+       if (fd < 0) {
+               if (errno == ENOSYS)
+                       ksft_exit_skip("memfd_secret is not supported\n");
+               else
+                       ksft_exit_fail_msg("memfd_secret failed: %s\n",
+                                          strerror(errno));
+       }
+
+       if (ftruncate(fd, SZ_2M))
+               ksft_exit_fail_msg("ftruncate failed: %s\n", strerror(errno));
+
+       mem = mmap(ALIGNED_ADDRESS, SZ_2M, PROT_READ | PROT_WRITE,
MAP_FIXED | MAP_SHARED, fd, 0);
+       if (mem != ALIGNED_ADDRESS)
+               ksft_exit_fail_msg("Couldn't allocate memory\n");
+
+       for (i = 0; i < SZ_2M; i += getpagesize())
+               READ_ONCE(mem[i]);
+
+       pfn = get_pfn(mem);
+       printf("%d pfn=%lx in_direct_map=%d\n", __LINE__, pfn,
in_direct_map(pfn));
+
+       ret = madvise(mem, SZ_2M, MADV_HUGEPAGE);
+       if (ret)
+               ksft_exit_fail_msg("MADV_HUGEPAGE failed mem=%p ret=%d
errno=%d\n", mem, ret, errno);
+
+       ret = madvise(mem, SZ_2M, MADV_COLLAPSE);
+       if (ret != -1 || errno != EINVAL)
+               ksft_exit_fail_msg("MADV_COLLAPSE should have failed
ret=%d errno=%d\n", ret, errno);
+
+       /*
+        * Sleep allows memory_failure to complete, IIUC. If memory
+         * failure handling doesn't complete, faulting in memory in
+         * the next step fails with SIGBUS, as expected.
+        */
+       sleep(1);
+
+       for (i = 0; i < SZ_2M; i += getpagesize())
+               READ_ONCE(mem[i]);
+
+       printf("%d pfn=%lx in_direct_map=%d\n", __LINE__, pfn,
in_direct_map(pfn));
+
+       pfn = get_pfn(mem);
+       printf("%d new pfn=%lx in_direct_map=%d\n", __LINE__, pfn,
in_direct_map(pfn));
+
+       munmap(mem, SZ_2M);
+       close(fd);
+}
+
 int main(int argc, char *argv[])
 {
        int fd;

+       check();
+       repro();
+       return 1;
+
        prepare();

        ksft_print_header();

Special configs:

+ Enable CONFIG_READ_ONLY_THP_FOR_FS
+ Disable CONFIG_STRICT_DEVMEM (so that reading /dev/mem will return
  -EFAULT for memory not in the direct map, just for testing)

stdout output with annotations:

# /mnt/host/mm/memfd_secret
370 pfn=106a600 in_direct_map=1      <<== my check that direct map check works
383 triggering secretmem
405 pfn=106f568 in_direct_map=0      <<== secretmem is indeed not in
the direct map
425 pfn=106f568 in_direct_map=1      <<== after memory failure
handling, folio is restored to direct map
428 new pfn=106be67 in_direct_map=0  <<== next fault: secretmem has a
new folio not in the direct map
#

>>
>> [...snip...]
>>

