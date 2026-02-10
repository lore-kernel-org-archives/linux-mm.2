Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF8CEB2700
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 23:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85BEC6B0088; Tue, 10 Feb 2026 18:00:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809C56B0089; Tue, 10 Feb 2026 18:00:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DDFB6B008A; Tue, 10 Feb 2026 18:00:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9726B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:00:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF8721A0145
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 23:00:48 +0000 (UTC)
X-FDA: 84430068576.13.A0086D6
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 88C0D1A001C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 23:00:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mmYcJcPp;
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770764446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BdbA0L4aOjLEGx6QYa1f4OjK1cIC+ShfSgE/ZMrMUhU=;
	b=VuN3p5QXzqJp054KQt6kafYorYv7ULItlwnv82MDCZhjLO+pH0ztQbKyy2+YtyE5TgGsul
	BgbMukUMECzpGbKh1V0d2fV8NvjO/CD+SsLeoW2ZcP5rrhe3oPCvG0eHEz0PE3uSmDPojO
	ATQ++tJFP5QfMygJN39e0474d+NonDg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mmYcJcPp;
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770764446; a=rsa-sha256;
	cv=pass;
	b=pvpKz+tRP9/Y2n2PXxcATGTnwNXZ1tSmHyGprBXtNL5iRF59Jcye1DonjeU4ASFWnlLinl
	KPkpLWv0cEJob2dhfXAByl8c69ajBT4p4Wq+QjwMmjiazpysw6kZyc8Izwj2Mr9YEnmW8+
	+QJngU0IM1vNKfJGOpu0OgXI2/4gDeM=
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-94ac7f22d23so832573241.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:00:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770764445; cv=none;
        d=google.com; s=arc-20240605;
        b=gqOHBvV21R0uO+GgbDgk3+z5bVg4/NNxDv4v+lsn64kfFIDN4UrqofQXBmRnOR1Iuf
         QLt6NzLhNMaaKpX72/KDIkz9rYcYM/twtkWiJZ3N3m+6ZjKXGiBBqZch0R8Sti0Nk681
         m/mf33zIipSMw3E9IUBgzFVEM45ceYD0hkCxBHoX/J7RLUJa6R0jt6jHcdkkwLVSmAi7
         DYvD9BEhCWjMzEEPih+VyX4BqqQYMLQgUBobnvv8Gxk7D+hobSi8xS3dK4sf6ysnvrbA
         71A3u8JG3vwK1ABDA5Mzs2odXg+VqeLW5/j9SFD5w9zuMSxL5j55hFZQLejwBNws+P86
         LWoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=BdbA0L4aOjLEGx6QYa1f4OjK1cIC+ShfSgE/ZMrMUhU=;
        fh=lg/PlIMuBfk3LR7sOZIFtL3CzW8sb6/EbFjnoqW8eOM=;
        b=QB6x/aZGcfn3obkG97/JgpR/vWMApgMcLsQFTFZauaqOdAMY44iu8b/vr32Erm+1Po
         eMJmXTQETACuoG9JFlSsmipAjuUyRf4U+NGaWBT+GTHB6/mE8Tv6EW96tQFPGJfHE5VU
         IePQt5cYb0cADetjRsVCQ6+3u8V4GTwnBx2zjgUPZ5ipKfOdg+2uoHlVjB1V8+bc5gKp
         ndkLoRekBPVwUqsGi42JZFXg5V7P7vPlDvUOyzZHbepcpFcsQM9x7uc8hj0ktnvUmr85
         3Gy5ekCwaC/IK93rOR5sthh81NJeGBm9Pcdva3HSHmEUg8woztqkk8gPK9554ujJFY9P
         RTiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770764445; x=1771369245; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=BdbA0L4aOjLEGx6QYa1f4OjK1cIC+ShfSgE/ZMrMUhU=;
        b=mmYcJcPpFX4QRoFi3b6mrzHMFFkfkr5yLb4DE74m6EWLr0d+jjfiXo5Ap+Gu5kwvZw
         IG+zjAN9iq1q1grqHNqRMn1xpjttXf9RIeviiFosr2tkNoJQQywKKclRepjb7V7sh/G7
         VXVV5dTMGu5Jf6b9qmvK2F3JnlSjuXigVLqh5e6rVcAgJ6IDw++fqZd/rET9N5voEsgu
         LFsoiwXzNFMb5cJZs9RSioIY/AlE3fLQputimPs9e+TUiUeYr84JYHdOLH6VbbG1ad0M
         Qy/G3n1xJoYo/aC2REl45Kx/ZKm/hxoHlev88/APtAzik4VbNMnyKJpli03jn6f+OFnO
         qzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770764445; x=1771369245;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BdbA0L4aOjLEGx6QYa1f4OjK1cIC+ShfSgE/ZMrMUhU=;
        b=o9r139uh2DF7zqL8wTPTsQozoPhmEaNGHNErPScKDysgMD9kaalO+YYSiATZJppIkT
         BHKcJtxsuFn43fyGG5HULeR4KoxtwPrY1HbOY9REA+ClcRAFgFJTyPOf3/UziUwGepGz
         O0cmDD1g7w0JKfvMmR4ibcNi+J+dX4EIIs8USQnhbDvk5okEPpfFPk53KREDwoxpIc6J
         8wigX/E0hbnUFPOJQpRLzmi2VEExEh7g/l27WQJOLxdV6Hz6fFszUEiy+ZyFoED1zB0d
         VF+BxdaCK4nuF2v4i8Y2lf6cSpghZ6vPhS9QA7Ocw+Mo5vNBmo+4OrYaWoYuBBZeFh5/
         2ypQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJaIzM09zIyaOwfAvMNAmkm6BRa9V88QYI11CslCodeBlrXrL4f9A0r2rrFrJOq6Yj3+woDP27yg==@kvack.org
X-Gm-Message-State: AOJu0YxUXR7LJmXNh6p1VTS4oPrj4FYxGhU5yo/MVj4c3W697wr2HJbd
	zWQ+aOdClLTA3XS5cUWHHsJhW/Ac+u98lcjNWdtyLgGcX4q1daBkF6E6cnmmyVHemsZzjDtuyGn
	ClbL0I73FbaLDKMd7LgdT3uX3HHBElPbl7nHL2gjf
X-Gm-Gg: AZuq6aKOAPpVdn7im7OzgZC1Nt+k9Y4mDdLbTBs5ilshYVsNGe8+BjAn3ve5rOTIsRh
	EfE0uIf3M+9/DaWDXEYCj6lSNk90n1/xq6idCHT21UKtECHcXGihu57g+f2eKQKgBoP3BjUtp6x
	bRuvxfRbDSRF/AB5PsssWeJeJ0K/zUZ4i9D2H+qPL2MnRUBOskBhO/AIZQlXrrg8EkSxUw0DtBQ
	kWySeNsXv8XEeNSBhVzo0lbi7eZOQenTMg4KDJlz9ls27qNoPvIJlyZQfxIfUnUzM2OGLpQhacX
	AUa8ODnw3dcagT+J5SvKlab7qCtueue88WHLSa86i7DuDpJBGzuZUX396+dYlNIIBoLULQ==
X-Received: by 2002:a05:6102:3e8e:b0:5f9:3aaf:1b9a with SMTP id
 ada2fe7eead31-5fde420fac0mr205490137.16.1770764445238; Tue, 10 Feb 2026
 15:00:45 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 10 Feb 2026 15:00:44 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 10 Feb 2026 15:00:44 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org>
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org> <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com> <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org>
MIME-Version: 1.0
Date: Tue, 10 Feb 2026 15:00:44 -0800
X-Gm-Features: AZwV_QiyL3s3BKXXhdK7iIwoIbxPAJAsEDXhkwYpXpmL4-mRW4CWWWKmYNrmdsM
Message-ID: <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, 
	pbonzini@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 88C0D1A001C
X-Stat-Signature: jp5iaaduffa9xdg1b3hacr6hci87jgrf
X-Rspam-User: 
X-HE-Tag: 1770764446-39089
X-HE-Meta: U2FsdGVkX1/Q2hyS7q/6Fupk1OysS+ofY7KP8euXK7aNJPti46M9xhs584nrlo/4xmbrXG2Xlp0M4nRoVwzIBgCM7xCVruow59bn62Pe3jIPw9OEgbdpKIOoIqy9sUzhoBCu5HWyZEQneXiAIenoVQJYvPEFcS6rwEVVSFQDoqjd2F1F2WkPTWoqHQdyMYQsNMXUmgo8nJn9hc/FUvzAiwybXfczehtsbaV9Ohkc45Ss9Fb83hDKR1Qpn1aGBROWEAFfYFlOIU8UbrHLV5OyqDr+R/GatcO7laD6wT9mucscgzonWdGyVV3mvvg4qZUx7cei96f4rmkWQW3ceutoFMHfxCIkZYTho33R/Gbdb/ZhWnQ7VuS2xCnUvehvO3erymHmjASAo5Gw4NQTXCHeTBSCd/GB/jcMVC08wGy9q8KOvKx8ZltDanXofmawWKo+DZH9UoXBnlgi5TlKXge1toZwnjlVbrnUsx/+o4+26TcNzGMC8/4PUIaOwTDmUxVDVJ171WVgnvrqD3ZlTkdtHNsBgPZxj2Zn2/89yVcuvORyDNekyj49dgLvSIT4pQUmv7LL26vCMSMZRJM7uagG+YL5mKJFodrt4DAYodTPM2TKhbWyxKGEb7HMRyzi05wmNtbI5/3S0ry5Zf76fPIU8F3B5nBnxrnC/nLlxKhAV65ZJtoxIaCV0vfEKNjtQOTaZQF3NMCfW0L+pQ2+HOiIHomhSarYaOOFil0uZ9fUzGWWyP0cRYLeSQr01L08sVlP/xn/CCGoEM0exRGUR6/fh0pet4cUOZuLr1BDmgI1IMyrpfE1eiIkqAPwFU54vyoHPFfEaryZ7tqPQZnsv1/omzdav1ZEzWFK5u/udLcgMUoFNmBIDoa7zCEwr7fMKzTkA1Hm6ccKnm6/rR80Z+TBsVQQntNBghPusM37xcDLRrpC+FgN6wwsx0G/sgpnQ+Yb0+5RCl4G5lTc0L9hJ+o
 gGKZFwOT
 TjOjjb4FA/Ps8yxfuly16ziVTKXTVLdO3t0MfwlQC+32bLLq+C4VqJ1qHYhaYhJHT9cbAFTU6ECrMqQmqkKe2VI75sUQA62IIG3qGkzHl+dRcLlgECqjo+NbYHhQnI81MRVky5Nuu9oPxvg/BuKEzmmbwvj1fy4io7IoAYZ8sZRqRp5NPPMmaNzJijBstLVt1IKvsbgVVFmWtC9Z+ereBIrFvJ/wL9i+HVPDYKMB0qoaOGpnBgFL/YHYRiDlVoZUEne6suDrPcdd+9JVpzHJUoCgdPYeuXU7VNEbTEooDlh7ReWlzSayNRpdQlUcx3L+yvMT8G6ZOI1yU2suUrQ8DDTGxOfKNjgURn4qqtfogyMYbuIbj6UBLqt3RHrgBBg0kH2QVGI1eT1uIlaeIrwp3AXSyAwOJYtUSILFpVc/OyhKZit8/a7oKmnyhR+btV2ZshS1wEWcvT3VfOc2AlgqW/9lWacJ0A8nthSMZRzoc7lfuRLQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

>>> BUT, something just occurred to me.
>>>
>>> We added the mc-handling in
>>>
>>> commit 98c76c9f1ef7599b39bfd4bd99b8a760d4a8cd3b
>>> Author: Jiaqi Yan <jiaqiyan@google.com>
>>> Date:   Wed Mar 29 08:11:19 2023 -0700
>>>
>>>       mm/khugepaged: recover from poisoned anonymous memory
>>>
>>> ..
>>>
>>> So I assume kernels before that would crash when collapsing?
>>>
>>> Looking at 5.15.199, it does not contain 98c76c9f1e [1].
>>>
>>> So I suspect we need a fix+stable backport.
>>>
>>> Who volunteers to try a secretmem reproducer on a stable kernel? :)
>>>
>>
>> I could give this a shot. 5.15.199 doesn't have AS_INACCESSIBLE. Should
>> we backport AS_INACCESSIBLE there or could the fix for 5.15.199 just be
>> special-casing secretmem like you suggested below?
>
> Yes. If there is no guest_memfd we wouldn't need it.
>

Seems like on 5.15.199 there's a hugepage_vma_check(), which will return
false since secretmem has vma->vm_ops defined [1], so secretmem VMAs are
skipped.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/khugepaged.c?h=v5.15.199#n469

>>
>>>
>>> The following is a bit nasty as well but should do the trick until we rip
>>> out the CONFIG_READ_ONLY_THP_FOR_FS stuff.
>>>
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 03886d4ccecc..4ac1cb36b861 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -40,6 +40,7 @@
>>>    #include <linux/pgalloc.h>
>>>    #include <linux/pgalloc_tag.h>
>>>    #include <linux/pagewalk.h>
>>> +#include <linux/secretmem.h>
>>>
>>>    #include <asm/tlb.h>
>>>    #include "internal.h"
>>> @@ -94,6 +95,10 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>>
>>>           inode = file_inode(vma->vm_file);
>>>
>>> +       if (mapping_inaccessible(inode->i_mapping) ||
>>> +           secretmem_mapping(inode->i_mapping))
>>> +               return false;
>>> +

Regarding checking mapping, is there any chance of racing with inode
release? (Might the mapping be freed?)

>>
>> Regarding the degradation of filesystems that don't support large folios
>> yet: Do you mean having the collapse function respect AS_FOLIO_ORDER_MAX
>> would disable collapsing for filesystems that actually want pages to be
>> collapsed, but don't update max folio order and hence appear to not
>> support large folios yet?
>>
>> What about a check like this instead
>>
>> 	if (!mapping_large_folio_support())
>>          	return false;
>
> That would essentially disable CONFIG_READ_ONLY_THP_FOR_FS (support for
> THP before filesystems started supporting large folios officially), no?
>

I think I get what you mean now. I was thinking to also update the
filesystems to specify AS_FOLIO_ORDER_MAX, but I think that is better
separated out as a different patch series, and this should focus on just
fixing the bug.

> --
> Cheers,
>
> David

