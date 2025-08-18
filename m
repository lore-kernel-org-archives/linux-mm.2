Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6B2CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 09:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9EC8E002A; Mon, 18 Aug 2025 05:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1818E001E; Mon, 18 Aug 2025 05:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7328E002A; Mon, 18 Aug 2025 05:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2858E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:44:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F15341184CD
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:44:19 +0000 (UTC)
X-FDA: 83789392638.07.9512141
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf24.hostedemail.com (Postfix) with ESMTP id 84B72180006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:44:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=K9ndjHDx;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755510258; a=rsa-sha256;
	cv=none;
	b=DCa39UbkcP+j8op5bYgYdXtswIHIDCoSd/meTWfwR4ZfKdOzL2zu86chj9kJrwe0rmusv1
	3GhD1k8/i4D2fPmzkbx1VIIyMOkoMyAllSnyEEBo2sQaBbOG5eZ9qWdSU69xK07ukuK4oC
	sRr+oyOUHAy/9YOvwRBBGLNCSBsEtPk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=K9ndjHDx;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755510258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhUabrkYn48Lbikledq2qqqh5BAE4/QD+CFPQO3FXYg=;
	b=opW3u3/EA+LVp+FZBZtWmCbyRuw1aQHVD0sKQ3z9HvQP7JELZudGEDD+lnCkocUQtxKvBQ
	yIqVOCIKVuMHiEH2VjkGsU75jSJE9Qz8g102/3ICustDqFLh0RhaygrBXnIbXF6mehNoBK
	qimQY2GZzfKzmdcxIiSJKXU7YRE60Bs=
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so3246435b3a.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755510256; x=1756115056; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OhUabrkYn48Lbikledq2qqqh5BAE4/QD+CFPQO3FXYg=;
        b=K9ndjHDxelBri2ARdTOZZbfEYJ89b45ue651YYRzsfT3F0Re3dcuBKuvGORuqkMf9W
         xBLgcJrKAkvufzrF/MOw2epGz6a1d9yZRjdfkns1IihalUcfUrXCWc/JBsTV6vNqgd+y
         F5nsTe6VwvsVdhIVkG79gVfzSsgGi1MvNsvtHjrrp5d97jNo8MM3CVhy0InKp0T58KQx
         9es2z5jC1cKi2edAZnyxM+HujpNESX9sAXHgh1x8gKy6qKgevc5aNJs1A3w93+YZwZTP
         UQiN1eY07QcVZmbrlJxmMoG5tPjvZfIy9rasdUv6VELiJOmQOUCJQwpEljKcxNuXr0rr
         Z6vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755510256; x=1756115056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OhUabrkYn48Lbikledq2qqqh5BAE4/QD+CFPQO3FXYg=;
        b=mWLAqjvw2M3JWtBRdAt5N9tdNe33ewyk8cdVa5qA+WmfP6MCzyeVqtzJQ2AFmEFE4p
         Z+flPHwSFTSThHhLDKZ2N18OT6jb2uWnG6rpUoAiyInd9wfKEk5ncvoOz6AN76T2iIti
         doarwYtmfmNBV5oAl4Rqh7VXU2EKGWo36q4cxPy2Jfvddj1vuIRbcxQLwESAALCG6m/W
         H+mNTarPRcHsj+V4ps4Ur7e0x8rQR4Aqjuu3SdoJtLVAApt7wW1cBeSR3Yjq5IwPT56k
         rw+qqwub0a/rMw4vjiqBH2MMQ38uPATxkHet4Z03t5ZKVQ6pYrdO3CRTVibOa6WInTDW
         3rnw==
X-Forwarded-Encrypted: i=1; AJvYcCWekm6c1J11ef82ILCad+eUT+IWIu6Q/GQTuGLivsEvLQ0hKcFrtp/IwhbMBvgEvdnuLcl4ZyBB8Q==@kvack.org
X-Gm-Message-State: AOJu0YwXtJ8wXH3P4LYw+X6jqQ33Wh0vKbXXgU2E5/L+x1KyElGaxbDw
	DW4ws6Cd0ai795vT3gs6ffN+Da27gyWCxcntNCml0oq1kEZFuvfdMaJXojwoCzQMPzo=
X-Gm-Gg: ASbGncvuc7V4QKKmgRCq47cZx7G7kEE13exYrArNM6YEF4l8tMdaJZWKcB9WdiRo1pb
	DeLSfWfQW6wkxpmGrOXDywOlHurHkrtWvl6aG85qTIEC+NkXXuYsza2QMRRj5OXM/P116NfDP3L
	aJecJ59/mvcRx708IboHYdjAq33V5sJs7p5smc/fHnrk7a10VwPhwnUgT412dEggT73myZNfnKJ
	eC9g9bBLTA4PqOcoJ1S5xBrHGzCQfb5BSWMVfAX9Eg6rNAKt0xO3M32/rZZBrdc9+sS4bMZvVB1
	s5zponrjeyOUfJ31V2KNb88MVaEPazlZ7Ny8t8Cxtwizz1mrLOFGzzCO1O+8CFHwPmk7tz14VvW
	c62D8bojK9l+ETNIQvJ503cf9AF8STd5GJC/HoQRwTZ+Zvf8PpR+myqGA2AXK
X-Google-Smtp-Source: AGHT+IEZaY/YH9MtTwNMDfFJQKUI2OS6UAuZArNL0C86X+FxToOfXP0efaPYaMKUFj+v4u4OB+zJ+g==
X-Received: by 2002:a05:6a20:2451:b0:222:ca3f:199 with SMTP id adf61e73a8af0-240d297f5c3mr16558144637.18.1755510255710;
        Mon, 18 Aug 2025 02:44:15 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e45292c7bsm6733189b3a.36.2025.08.18.02.44.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Aug 2025 02:44:15 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	shuah@kernel.org,
	skhan@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	arnd@arndb.de,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	dave.hansen@intel.com,
	david@redhat.com,
	ebiederm@xmission.com,
	khalid@kernel.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linyongting@bytedance.com,
	luto@kernel.org,
	markhemm@googlemail.com,
	maz@kernel.org,
	mhiramat@kernel.org,
	neilb@suse.de,
	pcc@google.com,
	rostedt@goodmis.org,
	vasily.averin@linux.dev,
	viro@zeniv.linux.org.uk,
	willy@infradead.org,
	xhao@linux.alibaba.com,
	linux-kselftest@vger.kernel.org,
	libo.gcs85@bytedance.com,
	yuanzhu@bytedance.com
Subject: Re: [PATCH v2 13/20] x86/mm: enable page table sharing
Date: Mon, 18 Aug 2025 17:44:02 +0800
Message-Id: <20250818094402.13385-1-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <e3aca3b7-4f38-410d-91d6-5a2521dedb6c@oracle.com>
References: <e3aca3b7-4f38-410d-91d6-5a2521dedb6c@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 84B72180006
X-Stat-Signature: bwt8cd9rcb5gy3qc36g6ewni97unaip5
X-HE-Tag: 1755510257-421708
X-HE-Meta: U2FsdGVkX1+58FZKT6bUwQyPC19jC2lJtf5UIBieNxaOlSzS8+52rSQuvvnwrpOixev4AP1kjx72bv1YyNboADTjb8KzpKt/4UoiQsQ27Sfg1rgeq3jUwv1W88J4N2CfAsxBDGlGvtDfrgKApG+TdbQ9j90xNvxLD7G5kAJukKlx+nZMhrfQa3qfpKQcvd1u34Aizg4+qLBnVsYktY011QQ2GoVsilf2rAMgL/NmLl7m1+8koU8DwRtN9EA2YjBRnnH/xYj0fhjEO0O/Osjl7SEWkVSyJerpb0C3x49lbJL1rnx0Ld+yiyYFpaAlJo1zL81pRj80I90Ltw9tbQPfk3e2aGomFm/d+ZYsTckqkWDonM/D52o12FknNbbAn2FApxZGtBcy7qPpkgRoLpV5HXxfr0XGDva1CTS3ITFAe9nSOogH+QEZPi+0Wt5Fz3nPpaaENrTTc3DG+8fh4tIRdkBRE8Y5iBt87hjX5bcEgLlvpYdpbDR6N3uBang+7tbiesA4HtCvb5yUaqtt08IZt1h1Kp8DZxkdwND17qeSOZ60Cb3yZTV4+X+xXciX9FoNBaxmjYZ7hffMxu2PHI2YUKSDdXXFO2Xkbc7LJRNgIXEEJt9PN91RWa8+vc6/r6ASLKW4oTt5ZzwK/gq2zBXcGT2FAOCs9Vr2oCx6Jkv91dw0S8UCmlMdJ4OO8TKwCMGHvBQcbSlTNIoN2mQ2wfCDuA9pWKHAH6DAZC9jeC5+IGePvO4qm7rp1IgKGW7dBWhYvV4MJ5jnvNDKmXPEkHZg7IOv/C4q0GJdTom8l93nLLnxW5RYVrNGDJ7oXlMBVWdrcaM1S3sSBzkiCLo4W3wysbFzMFp1zE8XLsWMBGK01NZ437YjJOJDeuwsIZJh2kppBOTSixjMp8ZBl932gTCKqvYLYDCSTrToIMsqgP3AtHicNEl1NVYWv6yNt+exjT2nAOAA1IA+LxT3UML9eFN
 WFVt1ndG
 KqoBMeIo9pGHlNKe2OU42Q+MxFJBz5EAuIr6QaacP8R7xIIZeKZ/2WBSIr1PceJoFou/JTKDadPdtSVFWy5FQqJ0kDuclFmxvlGSA6RUdMwv5ajLb8kVO7Mn0hbH9WR15Dda0RwMlXipSZ6H0yOwLRHKuxbnjrC3lhiw6nrTaOQBcdrjQktTtFoo+4LIqwhfj26JsB+6NQ6XvRpRUhk2l0xvzo90F4bf52EPsUIp0vHkG2UlIplfMno3JRt9447d+67nh2hfhEKtsBOGt8Ul0ErevRp6ijmwf11pU6xuZslwhE//r1sLS4Qj0tn/n/uXRQ9eQtkNTMBV0WaM01xuOX/QeQPv4c7AuxcfzKhyq2QO4Lt4oN02mPivKBBCZtQTNvqKnvU0nN+IrjHAodb3O3qn0FQfvIHLdFH2hg6VgJx4VDf1C7hfdQ1Min9zw99d1VHKe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you! Anthony.

Yep, I checked the comments in arch/mm/x86/fault.c file which says as your
advices in previous email.


I changed my code in kernel 5.5 as below:

       if (unlikely(is_shared_vma) && ((fault & VM_FAULT_RETRY) &&
           (flags & FAULT_FLAG_ALLOW_RETRY) || fault_signal_pending(fault, regs)))
               mmap_read_unlock(mm);

BTW: I wrote some selftests in my github repostory, which perform
the basic function of mshare, and I will write some complicated cases
to support the new functions or defect found in mshare. For example,
once you support mshare as a VMA in KVM (just as the defeat viewed by 
Jann Horn), I will add extra test cases to verify its correctiness for 
this scenario.

From Jann Horn's review:
https://lore.kernel.org/all/CAG48ez3cUZf+xOtP6UkkS2-CmOeo+3K5pvny0AFL_XBkHh5q_g@mail.gmail.com/

Currently, I put my selftest in my github repostory, and you could retrieve it
as below:

    git remote add yongting-mshare-selftests https://github.com/ivanalgo/linux-kernel-develop/
    git fetch yongting-mshare-selftests dev-mshare-v2-selftest-v1
    git cherry-pick a64f2ff6497d13c09badc0fc68c44d9995bc2fef

At this stage, I am not sure what is the best way to proceed:
- Should I send them as part of your next version (v3)?
- Or should I post them separately as [RFC PATCH] for early review?

Please let me know your preference and any sugestion is welcome.
I am happy to rebase and resend in the format that works best for
the community.

Thanks
Yongting

> Anthony
>
>>
>> As a result, needs to release vma->vm_mm.mmap_lock as well.
>>
>> So it is supposed to be like below:
>>
>> -    fault = handle_mm_fault(vma, address, flags, regs);
>> +    fault = handle_mm_fault(vma, addr, flags, regs);
>> +
>> +    if (unlikely(is_shared_vma) && ((fault & VM_FAULT_COMPLETED) ||
>> +        (fault & VM_FAULT_RETRY) || fault_signal_pending(fault, regs))) {
>> +        mmap_read_unlock(vma->vm_mm);
>> +        mmap_read_unlock(mm);
>> +    }
>>
>>>         if (fault_signal_pending(fault, regs)) {
>>>           /*
>>> @@ -1413,6 +1446,8 @@ void do_user_addr_fault(struct pt_regs *regs,
>>>           goto retry;
>>>       }
>>>   +    if (unlikely(is_shared_vma))
>>> +        mmap_read_unlock(vma->vm_mm);
>>>       mmap_read_unlock(mm);
>>>   done:
>>>       if (likely(!(fault & VM_FAULT_ERROR)))
>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>> index e6c90db83d01..8a5a159457f2 100644
>>> --- a/mm/Kconfig
>>> +++ b/mm/Kconfig
>>> @@ -1344,7 +1344,7 @@ config PT_RECLAIM
>>>     config MSHARE
>>>       bool "Mshare"
>>> -    depends on MMU
>>> +    depends on MMU && ARCH_SUPPORTS_MSHARE
>>>       help
>>>         Enable msharefs: A ram-based filesystem that allows multiple
>>>         processes to share page table entries for shared pages. A file 
>>
>> Yongting Lin. 
>
>

