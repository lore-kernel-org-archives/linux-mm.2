Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE726CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 19:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428EC6B0088; Mon,  4 May 2026 15:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DA106B008A; Mon,  4 May 2026 15:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EFC66B008C; Mon,  4 May 2026 15:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 195186B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 15:58:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE2EC1C019C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:58:37 +0000 (UTC)
X-FDA: 84730799874.28.F01A98A
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id A74582000A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:58:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Oi+mJuUv;
	spf=pass (imf13.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777924715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=esEqdBvyNeHgcLcZRMKUkcBSd2coHxMvjI5oFXwBBPs=;
	b=K82y+w/JgZS/E5VTwHs8YC9a4K05yvecvjaiRahMhcfDi7BT4ESyQkY8cHDlc0QcN2flZX
	UM6jrng1UdbBBe7+mogMzF2AlNd9RPj9pYmCKt9H4cXXwmaRIVWjmor91DZq90+9FPZ6/J
	Fv/zZtGcSvKsuOPYu3dMgA1UNAVoXsw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Oi+mJuUv;
	spf=pass (imf13.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777924715; a=rsa-sha256;
	cv=pass;
	b=GCk8w/1uzKst8p+Xv9wN16vqaFztEcQl2xGhy+c5mDRwO9ulzON5e8xbg++18l5KPnXYM6
	UyHiB4WbcZ5AuPijqW/RZGhH5aASXB6Z2lQNQg32/z1nJ/WeOumwkbFEYNta1fwgfzRPrK
	fIyJMW7ZP2I8FAEYjW7FYq2ylr6IOXM=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-676a89de629so6979384a12.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 12:58:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777924714; cv=none;
        d=google.com; s=arc-20240605;
        b=PqSHseniXab4x0S5ucoO4kdQW0glDKFTIUg6WvUOxVEVWYzzadt9axFuRLSPclQCU8
         Hk2GhfKBT3++d/ymul0bfGFo1RplV6AKp+2nvq31JI38nrqsUKr57CqCsJTSe4cn7qT7
         0o4xvu4ih9wBjD2mSUzcP+aB36S82iO5W2JNv+oQBrPh7tNqY3mNE3g9IFWJiLfHMC5q
         qlIF0U+irNigkOIa4K9Wt04tOwh2ppMPv16oW1HnFa/Bd205T2sNWYxy/41fuWbgyUkR
         Ed9i9578w+8BNM4B6R4fOcnl0CmyTmYCujvDAxCl4kBqIKfjyQJqaCbJkP8zi4Y3EMAP
         TL/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=esEqdBvyNeHgcLcZRMKUkcBSd2coHxMvjI5oFXwBBPs=;
        fh=8iasGABunLtuxJDbbEHEicyJtN+whtOPSUzb9jVXyUg=;
        b=UjSRN59AYSz5ZqR4MWQ0T7t2AvWyGZiBFeKi8mwT/LxeoIeijBHVl0tpjMVdN2KKGY
         nPFSczP3wmqVnXlS1ZIZ6MGSq+FYuLon2MN0UMkZ9SygWQt7wvk7BJ0qTUz64SuCfS0Q
         klbxDfsBQNBQXmdZ66aA+1l88/MZLXGB98nYfl7v7IBw/OpLKM+ZheySX6YT/uIpyDo5
         sSds2827RXgH1CTiRyWxYpl8SfyTUviB0VbnQcAdppUDyvfYt58gI5udwl/ZmyazWfko
         NNS7XmSPY0Mr1CqrvuMlzg6VrpIlb+G6StZ1d52O6plcQ6AtmBTqfJTFm3PaP4E/rExl
         ojFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777924714; x=1778529514; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=esEqdBvyNeHgcLcZRMKUkcBSd2coHxMvjI5oFXwBBPs=;
        b=Oi+mJuUvDsMXTjeIpkUhK/Ivpr1tliJ1xia4uu/w7PeadrdrG8iOuCYqGEWF4g2hbs
         zdgtQ1B4vmUQuPwcCODutorc6izffEIcLOl9NWvVB807RMYO/QWSpHcyE5ecFexRxvPI
         G7t2MJbGSss1zg1xzp1Trqxgeeimi8OFbHI3bdnAdYzh42chcrlQ6XiztBCVtIE0QeYg
         M1e3g6SPt1HTubO4Dq3jkvA0Ad9ywQ2kRsPh45/+C83QJJ8aw5ihIqZfdYag9ssZB0uM
         1CN9uV9ObAOkGYvx9TQNRtnghpESyJI2So7MNHORBqfHMuUvS+O/hVNIYdzEEVYu6MZq
         RSjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777924714; x=1778529514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=esEqdBvyNeHgcLcZRMKUkcBSd2coHxMvjI5oFXwBBPs=;
        b=pR2IWLKCfy45bNA1cxp51bjykSxxprSDQQLtmh5zSZK5v8LO1kd2AdnytTrumax3am
         FR6chPZrQIeUtznU2B+MWyDI+oebjaijG/kHCPoVldVdwWqbEi8IryjVm4+r33lmIeA6
         FcZKwnYHCbuMfh27812vWxE4lsiw4hNQSX2cR0rWripy1BrgzMYMedFE+s+t2XeykbXC
         D8Vogx0NCsyJnVQgOcnrD5P7RWtvUXCvVIfKyMN35thl/HwE20DumPV/zLudgxwycAf5
         wIw+1s50afwKszPes6sG3PzoePwITotCBOsVHOe+6Vzrl8GBgpPNKAbTRS6+QbSfJ1YI
         ar9g==
X-Forwarded-Encrypted: i=1; AFNElJ9kUkjZfB8VgzSJ1kbcUDQ7vzBAVdvN6cDHHspa5dHu8ciym2kHD43JPw/YsK6HizoPcU5pZYyGdw==@kvack.org
X-Gm-Message-State: AOJu0YygA4+YSOEP/EGMo+1Z7mq51J0H5iAP4i9NxqZUuR9iTsFAYOCT
	d8t++3ErvpX+FdqFsHbq4/AuTkYGs845+r3up7ntIgbHRDnr/8RFrYsErdsNxR/jwaEtsDYOaah
	Hryjz/KYzJSPBIfG3h4gjhQAmnw4uaj0=
X-Gm-Gg: AeBDieuKw2c33zrCpJtCHeh0BumCVKAD8fpUIVLoPUd7Kd96TnDbg27i4n0/qymaBG3
	BYCdVKyajdnMXl8Ntgh8k1XATNw/RwigY39oGtvY4owePeAudsv6WRdyNcZvSotdFlcp4sBIx68
	fgcvu1Jb2BMWQbOUJ5gXE31klvkgUnIDxyhvRQTT5iBr9nR8UD79F80irz9ucFp8K1JShNK7h49
	YFqMwZW3FNq7OaXjAWukB+PQ8IxRC6voFMvTozqMOg/cPEwZjKpxVLBuoj6v0FYqzDHl8qo7wHh
	e29UtM/ogq8mS/qHXBv0
X-Received: by 2002:aa7:c34f:0:b0:672:64b:c97b with SMTP id
 4fb4d7f45d1cf-67c1aab3100mr3731156a12.26.1777924714107; Mon, 04 May 2026
 12:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <CANaxB-y=SD7V7dcBXuAqq8=p2R46SAr1uKZtMACynvk1=Cftqg@mail.gmail.com>
 <20260424221126.1238744-1-elaidya225@gmail.com> <CANaxB-xFcF7U=wJv8EqKy=j=-P3SN+sLQ9ytH8Ej69h03tqL8Q@mail.gmail.com>
In-Reply-To: <CANaxB-xFcF7U=wJv8EqKy=j=-P3SN+sLQ9ytH8Ej69h03tqL8Q@mail.gmail.com>
From: Ahmed Elaidy <elaidya225@gmail.com>
Date: Mon, 4 May 2026 22:58:22 +0300
X-Gm-Features: AVHnY4K-gqls4V5lFPSYuwMzajTBx-lOIHJ6BTOdcQJ2CRq2bDdmxV7hRnhW0rw
Message-ID: <CAP48DwbE3MnQqVmbOsrSZgo6tYvqE4RV9o4dS2TODUP9G85aog@mail.gmail.com>
Subject: Re: [PATCH v2] mm: fix VM_SOFTDIRTY propagation on VMA merge
To: Andrei Vagin <avagin@gmail.com>
Cc: stable@vger.kernel.org, lorenzo.stoakes@oracle.com, linux-mm@kvack.org, 
	akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A74582000A
X-Stat-Signature: ss4t3niqmh86c1pz3wyf76hwczaqexns
X-HE-Tag: 1777924715-854882
X-HE-Meta: U2FsdGVkX19mX6TVo7mHcW1B6/+qBbaZWesuTB2FMucYdUfITB/f2Om1KcdBFAA7ENs5yRwqcZbymhr5MpYKMxyA+O0WhtZAYYmbOYMQWD5kknihwoO/EM9LpHh+MmGxIGcbDfGTn5O8VCkDMvHjNjlnn3usnwRtrecyG6bviQ1H7FcaryP4RPBAS/C4G0yCk3Q5KcQ52bASmNfWYr9P6LDmF8bsxx7d8QZUZSidnJuvaoqPSZZprYuCkmaVBtoI46jIyIvpCm0eKrA6QsV0wTuMgw06sOzGn+GRMWAXN15w9qvnsgDAWmbs4GD4QovUEFl62KXP/l5KMEaOFoPmiRnjJxn8hovS66cSCTnKgowva+6LMG55SJ7W8vr5SWeOxmVK9WKyD3aGHAbaW1oNCMo9rC6AK0CEdEEiHfQxmj+CzmRoejvPAAF9Oc54wOOBgPO0+Q1MyIMDcMO6EUBfcG32uJ3bgZFPV7pOvM3JtKZXn0qOlf1UiS8WOmbcWFqL0kcgSkOuSMVp4kKB6Y/+IBEEzpGV1550yy4Y449uotydq1NzZUt0DpWRrzsSIjD2uJZjtH8lTaj/oDKjkVFXuCiN50/TWPjbxGKnC78Q3rucPCLpZp8mxYJoHwh8wGIIXzJwM8dVA85hAN0WzMXIAjazDp4YNFVULqN3fdvemWt2cPAPhO195rdUV4TBJTkx07TctiJh6ODZRvvzPtxStbgpxDJfl0FmeCAUZVFUzHK7L42bTqEAMcwCwpRIZTq/J0TfDa4TJl3SqSq7rUkjuf9AoAFmCnpE57lTBX2xQPRm1V7BXz4SkBAE1Yu4O0lX6uCL2vPOgTsrmOt8Xo523aNcYE+/PM4TiV2Jw6HvJe8cf6VW102+8hDZwBDh1WJUQCByR94yTRL7G8lxZjwg+yjIeidMe5vS1Y3sU3oGDa8ac1RiNUXLPU3o0Z7kg7WGFSxxaDIdlrALlW4SRqf
 e9UPl1Mp
 WdSYjEx5yD1g8kTDC+I5d3oz5zWWg78Sf4di2mPQx/wTU7UpEtLWAr4BEu1/lLfzcogOGxyMI6clyu0gGMTpYGojixdazml2nG/DYU499eOG76ks5OzBz1u6ROLGvsm532RjWHXIoG2obgq45Zb87gP0yPraiNrLM3L5NeGWqYrb6glsMPSd/lWmSZX5LQc8B7E8QIE+lgndoIEDx4egkSTts3wuz/K2sfjOTsW0oPFJZksCPZt3R+2jb+s8i1a67Iv5jpiTn+eLR8q56zyp3yBBryBoK79Wkj1z0aFzUvkUWWXAEeB2CkiWBeLW5M5uJYImuZ0i4tAmRM0UGqFLxcJZzKivHbKIkfQ0BUWiCnrVVG3zVCkWTvtfO0sj+b5PxmDt5n/BeKDbFf4Xyv0vYzmKpN+97b/TZodo87a3dsOD7ZRhBILteHY8Bum1Dzspeq7a7xCg6KTgsoH61e0DAF1kD9LCv9XNA8G8Ew1rJVF83zMlJ3nspa+QoMLdMra45ggOKY0zuv+BvEi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrei,

Thanks for the review.

> Should we fix vma_merge_new_range too?

Yes, vma_merge_new_range() exhibited the exact same logic gap where
vma_expand() leaves the merged VMA without VM_SOFTDIRTY if the target
sequence didn't have it natively. I have added the exact same fix to
vma_merge_new_range() in v3.

> How are you testing this patch?

Testing was done using the CRIU ZDTM transition test suite
(soft-dirty-merged-vmas.c) on virtme-ng. The test enforces an
unprivileged namespace testing environment (ZDTM_ROOTLESS=3D1) where it
tracks VM_SOFTDIRTY across merged VMAs. The unpatched 6.18 kernel
fails this incremental tracking natively, but correctly propagates the
bit with this fix applied.

I've addressed the formatting suggestions and added the Fixes tag to
point to the 2014 commit (34228d473efe). I have just sent the v3 patch
to the list.

Best regards,
Ahmed


On Mon, May 4, 2026 at 7:42=E2=80=AFPM Andrei Vagin <avagin@gmail.com> wrot=
e:
>
>
>
> On Fri, Apr 24, 2026 at 3:11=E2=80=AFPM Ahmed Elaidy <elaidya225@gmail.co=
m> wrote:
>>
>> During VMA merging, such as through mprotect(), VM_SOFTDIRTY flags could=
 be
>> lost. This breaks tools relying on soft-dirty tracking, such as CRIU
>> incremental dump/restore.
>>
>> Upstream resolved this using a broader VM_STICKY infrastructure (commit
>> bf14d4a05387 "mm: propagate VM_SOFTDIRTY on merge"). To minimize churn a=
nd
>> risk in the stable 6.18.y tree, this patch skips backporting the entire
>> VM_STICKY series (9 patches). Instead, it introduces a minimal standalon=
e fix.
>>
>> VM_SOFTDIRTY is intentionally excluded from normal flag comparison to al=
low
>> merging in mprotect. This patch ensures the resulting merged VMA retains
>> the VM_SOFTDIRTY flag if either of the original VMAs had it.
>>
>> Suggested-by: Andrei Vagin <avagin@gmail.com>
>> Cc: stable@vger.kernel.org
>
>
> It probably should be: Cc: stable@vger.kernel.org # 6.18.x and
> the prefix in the subject can be [PATCH 6.18.y]..
>
> Please add The Fixes tag to the commit that introduced the issue.
>
>>
>> Cc: lorenzo.stoakes@oracle.com
>> Signed-off-by: Ahmed Khalid Elaidy <elaidya225@gmail.com>
>> ---
>>  mm/vma.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/mm/vma.c b/mm/vma.c
>> index 5815ae9e5770..03728d855684 100644
>> --- a/mm/vma.c
>> +++ b/mm/vma.c
>> @@ -978,6 +978,14 @@ static __must_check struct vm_area_struct *vma_merg=
e_existing_range(
>>         if (err || commit_merge(vmg))
>>                 goto abort;
>>
>> +       /*
>> +        * VM_SOFTDIRTY is excluded from normal flag comparison to allow
>> +        * merging in mprotect, but we have to ensure the result is corr=
ectly
>> +        * marked with it if either side had it.
>> +        */
>> +       if ((vmg->target->vm_flags ^ vmg->vm_flags) & VM_SOFTDIRTY)
>> +               vm_flags_set(vmg->target, VM_SOFTDIRTY);
>
>
> Should we fix vma_merge_new_range too?
>
> How are you testing this patch?
>
> Thanks,
> Andrei

