Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B471AEB5946
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 00:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2BAF6B0005; Tue, 10 Feb 2026 19:58:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA416B0089; Tue, 10 Feb 2026 19:58:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90C46B008A; Tue, 10 Feb 2026 19:58:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 974D06B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:58:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CACAC1601B0
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:58:12 +0000 (UTC)
X-FDA: 84430364424.13.4B8B3F8
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id C9D1818000E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:58:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IMQIpEOh;
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770771490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eh9PcHtuZUGG5Kln57hbRWu3FTiRIkMWwrWF8nE8fhI=;
	b=zOuv4zgEd+cml84r1NRG/aIk0Kd8RnlnWzITCg43HsKdmAGRsH7WBPQW3CKjAbGItJHwvN
	CKvL459r44pCcZMoR+xAIRXtAebyfftksP+x6oDCoKYKK/cXXHgtoemiVR36V4biRn5RUf
	qyOYyQO255Yg5Lo7iUli1FgKphyNDNw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IMQIpEOh;
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770771490; a=rsa-sha256;
	cv=pass;
	b=aHCablAAQGpoNYwLuxr4fx5IJ1no156mL/lDv2FVzytjQAk10gha/UxU4QHJ5/IfwnRUQm
	CRQrA4KGYFXQ0sgCi6mTd0RDs2tRh5StL9Be60ikUdHplpMefCNhD/mRY0UhmbVVV/CbHv
	EPiVMmq84AOuAgTpd707wSy3v4JtF/w=
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-94aaa5d3bfcso2228579241.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:58:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770771490; cv=none;
        d=google.com; s=arc-20240605;
        b=HG4LaGvcd/U5nUsQb0fCqkX6s6Y8C3eu6P0nFvXMwWF95ykZYPZg1m4nOPQ4z8GYDR
         ZnRfsbTPKxawkBSXW/HfAY0jSvnhJggKwhds0FhQby6xw3eEDRJUycos45o+BVOj1XuG
         Oqylz96F9knbK7sSI0bsQ343KbT+yIVKWbm/PAmfV4BKzLTfUGlClbKAKV03yk5X9jSP
         wXOGO6B9oCb4ATjMaj+TRBicgKEoFog9LKAcvOpzBGnRw7cMjjJQXJFQFY+7x4d8Yir9
         DG7qydQiQMafH5molNtsLvCMFezCZG4iLX21FWQgyvPagFFrc9TSAQ21UIR/2chhng+Q
         CW1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=eh9PcHtuZUGG5Kln57hbRWu3FTiRIkMWwrWF8nE8fhI=;
        fh=kMT1PoInmzjs+HxvoSpQGhWc7/cQ5QSH31LtiupLllE=;
        b=PQUAUj9LvyB1vz6RTSRT99VG7fTM7DyVdKhWuhl+6JbQiOLWROWwBw2YXiechvqv3K
         fUgxU4cUHKYPtl/PXGpw84RaCWXWY0lpHiZ3czd96obuJoj+DZXfu1Yr5zNa6isyuutt
         mvbQPU8QKVhdFeY/Ex1/dwag9kCQiYK/4WOtayelvpNyS/R9fHHOpDu6jKtPHmgHvtcm
         lQsjpx67mxBa3pIEjDpAPJAkEBpEgYOL8v+ZOrOALuyJ5iTTSicZcq9QwjcUDFfiBCy6
         buekPfeGkTQI0DBaYNZRtYWLCgqVwwBMWQvPKYZZtq5Lm5tFGvgQeioVBjQtTnGNl1C0
         CHyQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770771490; x=1771376290; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=eh9PcHtuZUGG5Kln57hbRWu3FTiRIkMWwrWF8nE8fhI=;
        b=IMQIpEOhKjjcj9PAkr8C6943GTwZiYupvGGt3EOBF+H0cJPPDo821axfNcE/2cJAF2
         4/pe9yjejOfuRdiIiDp0DitfIYBKpGF3YMR2cIgg1eJtVRlHBI+K1Sx8pkGmx3lhz9Mb
         ZW/qs4Vb/mKrxlUx0sVGWd7uy+fc7JpkK0HHrQF70Cty19BF1tR0qzBPD6gxtX5o0Mne
         ojypnkohRIuwc+UtLUTQ05SrdriQyUBOgTF61NXiaeL2sLmh34eE7T5CqRXtZ30JmJOU
         t6/RfQrZyrX6b8DO0a+HAlxv0kjZp+QIhFzsfbsmk+9YItD/vT87rdwrHTWMImo5RAAN
         H5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770771490; x=1771376290;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eh9PcHtuZUGG5Kln57hbRWu3FTiRIkMWwrWF8nE8fhI=;
        b=WXGOG7EnIR0SX5WoBbybiCyztNxcdJGv92qTUF8+0R7ZCNv6pNnOdxzVrPzsKEn8Br
         xEySFXyIIxtc8xoofm9WZ644A3oSqPFhv7uDUjBr7CLcK+VYsTfdiLeYp/Y/b447MGTD
         o6z21TQNrx+9JQAszbhAhOR+5YfVvlGgxBC2QDhCfSRq9UH7htt4eY0wS1xvbrFG0AOG
         yNdoFKRPGpkRrorNXg5IxiHQ12cocj19AB5N3M56mov4vIQ3U47dJ6ghAUKA00Ljc9O9
         wq5L7rO6sENqqZ4iIVP8oikv/DFeqTFd3QN0LFn33ULpeC8b+MfM8XvoPf5n5Vs5+pPt
         v4EQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVh16RCM9rMSah/R7/q3XsMla74sELm5OlXGLukSu+tzkCUM0IsBS1tMLzN86N/NsMNAvmHkt2iA==@kvack.org
X-Gm-Message-State: AOJu0YzpnRN7Z6G6/RhYWSI+tzPlfvSCSR6IYVKIVStsnZ76yUfRH5RT
	MMTQYB6wkDFVRLR0sNJr6AIf99z6QXJmhPsfgquH5uyFZbbMlW/tvvXHKK8C5vnrVA1+M5G1MY3
	BEzSavT+w1BaYQXMWSSSwNHzT2d4ADdaKFOVK3sw6
X-Gm-Gg: AZuq6aKOQQnStc3s8T4rmpMXV9dQBvi02AMw6Ca+eVlV8YNRktSRbxwPG1BiV7s1utM
	ksjw9YYhPWQizJzqMgLXV4OhG0Xju8cG74MgjXw80S4f21IQ5k2YpTx9oDyZ0Rs4j06yXyY/H4R
	0D1lfcmh5MbeVIUvxkx5zYJ+WYcrRXnGVKveKB9q+ELUxXZB3z+1d3JXk5TPjONa8SOYoQ5s0gt
	0TH8XVtNAsLduB0NRqH54LKBOZL9CeqE3Vjpxer06gmzEJ6oQI76VULswHcehOygf9AG8N5Uejq
	vBR2+R7qil9bIeDWy09HUOcmkQmLaBHfjAshYeK6nxwlH6kPBgicuTF2ebW3D6DLax1TbA==
X-Received: by 2002:a05:6102:944:b0:5f9:4f33:2883 with SMTP id
 ada2fe7eead31-5fde4308643mr373272137.28.1770771489437; Tue, 10 Feb 2026
 16:58:09 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 10 Feb 2026 16:58:08 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 10 Feb 2026 16:58:08 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org> <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org> <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
MIME-Version: 1.0
Date: Tue, 10 Feb 2026 16:58:08 -0800
X-Gm-Features: AZwV_QgxDeulAecHpn01PDRcqPsvuaGcOCbNfwjGI7BfIAkpouXJ6tRzoK3ZvZA
Message-ID: <CAEvNRgGvZbRLcb4JbXjsLUX_V59EApHYTQc49X3Jq70GxovD2w@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, 
	pbonzini@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C9D1818000E
X-Stat-Signature: zxkchbxorr4m3jdwqs87pkfpbocr6wrp
X-Rspam-User: 
X-HE-Tag: 1770771490-563606
X-HE-Meta: U2FsdGVkX18Jgoalr4tPd0neSdOyWo5OrRIKSZRLSeKkYuvJe72YnWmUpzE59VKEjfEMTiFoRcRLKAsvDObP8D3Z3EMXZAqKsWPZ6cMElRdrHtvjaP9DL/dP8YnLjk7QAhlkUQjuRrKgJGRPxA7hPa687YvocXGTB3G0jU6bftVagpbfROBq0sZCQXqxNBTV35b5boUiD+piUhhDRg73tM1NDU6vD9+mHgEqP0BeGY0sIq8svSgPvJN721PzKxZeo7O9ns+DSNmER5N+CBdkpbqzl5pnmtBRWGJjSt5aRQRSX74NLHsveOedEOnApzSV3k7a2Wkde1UgmN7A2SkjwDrIKKVt9RW/cu7QKrjj1xuzRZUWOoh2x+10Yft+cA69RQOwLZDRwHXV+EJrj00BAdzLkvILFI4DjzMmrcJjr70TzJ2ycP4RcAJF+WIKx4JNbWhT2giwQG1zjr3EvFZEJRT4WFx0XMRYZB4IE4ZEjZlNrX9yR4dVqyK6QoUtbLSaybjt5FM7+vTWnnney6czvfnphVjgTHGteviU610oRlu1KAOabwXochaT4m1r7jgojmspVFi1BApqh9rHky4ITAbw2LFU8vq3RxdDyAuWxBgrisrtm1VUnKEGZKMRui/gyTLMxX3btFSkK8Be/Lr++1oMMJGWMD4ZYcR7AsYli+o4ecuaXUwHgzO6XuS59d70RtoDxwz9p0zObFQ5FA19XI2P+83wUhN7m0nQBDw4kK9hty1F7iJrZ6QwTMbM9bhpFxvoGozwBsNVuceRpuZI2l2xu/yP9pChDaxE+jsCowwy8A9Nmm7hUV+uTJK6kM9hr9jdT9ius6xfpyR7NLY6OFyvUM74thXyIAc3eGgN9PKzG85mMidkDlSPY6riR3zoA3EmBczhlkfIYc9PtFTzZf+O7t+wRHCwza+QXwVQdMLA9cDwnTSqlDkbxb7ogJIMkUcqZXHub3hL5QBJxPW
 k1t41K0+
 F+A+Y7h6A9QUJj1uAZwmk/szKdlhhDAnRduIIx+P+Zd20zxf/HmTlCTYJr5bxvlnOlzW1VhbY6zD1DuJ3Xi1PSMWG1545nxgVH87KrVIFuYoYbcYpCEWOm/bikxIYkHhA7DoW/20Sm+/BDqFPcyYluuZuOc8eSLPrD9kW1xC+M4PTZ7J7waVhYaElyLaEzv+/yrw1rAXJFPfjfXTM0XrwrcP42eB3T2lR0BL7uSmAc9YeAa7zc4c6ijA63cnidK2ekaSxLwOV+CX+FiHgir3Inm2sWqU/0Zvl+S6Pzsrfa4b0E03VlrD2kcXuhmVNqhvt7cajyHfo+r93o4XHEl2Z6Yp0UPflY7RqSAXcfHEWyVPjEeFTGYX0OVH9oGnFNpS9J27J1m70D+qUUeakRKEmoN4DRp/lOq69B9blO0/FuQ6TUU6ed1ZGnm4r0L2MuyVa4Nppw+zBrrEq5+i7GMNTBr6lAZcb1d+uDdSSnDfSFhKNKwYBJmZAIjps5DXbsYvZlnPbfjMdZMpYOPMr3Ss4W9lAwebnJfOhaHH1AlnwOIDzvi1GdiRexcc9Yva68e43loUj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>
>>>> BUT, something just occurred to me.
>>>>
>>>> We added the mc-handling in
>>>>
>>>> commit 98c76c9f1ef7599b39bfd4bd99b8a760d4a8cd3b
>>>> Author: Jiaqi Yan <jiaqiyan@google.com>
>>>> Date:   Wed Mar 29 08:11:19 2023 -0700
>>>>
>>>>       mm/khugepaged: recover from poisoned anonymous memory
>>>>
>>>> ..
>>>>
>>>> So I assume kernels before that would crash when collapsing?
>>>>
>>>> Looking at 5.15.199, it does not contain 98c76c9f1e [1].
>>>>
>>>> So I suspect we need a fix+stable backport.
>>>>
>>>> Who volunteers to try a secretmem reproducer on a stable kernel? :)
>>>>
>>>
>>> I could give this a shot. 5.15.199 doesn't have AS_INACCESSIBLE. Should
>>> we backport AS_INACCESSIBLE there or could the fix for 5.15.199 just be
>>> special-casing secretmem like you suggested below?
>>
>> Yes. If there is no guest_memfd we wouldn't need it.
>>
>
> Seems like on 5.15.199 there's a hugepage_vma_check(), which will return
> false since secretmem has vma->vm_ops defined [1], so secretmem VMAs are
> skipped.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/khugepaged.c?h=v5.15.199#n469
>

On 6.1.162, secretmem VMAs are skipped since secretmem VMAs are not
anonymous [2].

[2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/huge_memory.c?h=v6.1.162#n135

Same for 6.6.123 [3].

[3] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/huge_memory.c?h=v6.6.123#n125

It breaks in 6.12.69 [4].

[4] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/huge_memory.c?h=v6.12.69#n159

IIUC the patch that enabled khugepaged for secretmem is

commit 7a81751fcdeb833acc858e59082688e3020bfe12
Author: Zach O'Keefe <zokeefe@google.com>
Date:   Mon Sep 25 13:01:10 2023 -0700

    mm/thp: fix "mm: thp: kill __transhuge_page_enabled()"

...

@@ -132,12 +132,18 @@ bool hugepage_vma_check(struct vm_area_struct
*vma, unsigned long vm_flags,
                                           !hugepage_flags_always())))
                return false;

-       /* Only regular file is valid */
-       if (!in_pf && file_thp_enabled(vma))
-               return true;
-
-       if (!vma_is_anonymous(vma))
+       if (!vma_is_anonymous(vma)) {
+               /*
+                * Trust that ->huge_fault() handlers know what they are doing
+                * in fault path.
+                */
+               if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
+                       return true;
+               /* Only regular file is valid in collapse path */
+               if (((!in_pf || smaps)) && file_thp_enabled(vma))
+                       return true;
                return false;
+       }

        if (vma_is_temporary_stack(vma))
                return false;

Because file_thp_enabled() would return true for secretmem.

>>>
>>>>
>>>>
>>>> [...snip...]
>>>>

