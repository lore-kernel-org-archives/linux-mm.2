Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39726C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB746B008A; Tue, 14 Jul 2026 05:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AE56B008C; Tue, 14 Jul 2026 05:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66466B0092; Tue, 14 Jul 2026 05:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 986A76B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:24:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D7591C013E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:24:59 +0000 (UTC)
X-FDA: 84986847918.25.154A833
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 235E540006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:24:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g5E19SYk;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784021097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eb8w9+npX5/dhsCqW4lckI0v6rU18FNTvsuJCjEq5yM=;
	b=7lxSQlinW+w9NjvCKi3HRjNDEY9XJpvpfmrAFJQMfzzqshIFsJTkkGjpNCLR3Ke+N1LjVB
	/fxwMeBpeWXJOXmFW9GI+7wwh+OA8BbH6a7G6ZcYqO1TkA4mbGEYc2Qjnha8uvIARuaQjX
	ISnwtOWKfwb59oeAZAGGqixd/Q0JE1o=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g5E19SYk;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784021097;
	b=KMilWXOd7+rAj++7uqIQ77Ddp43FI+O4tL6ZKdyTtTUpraXUYHnN4+QSDGH0Q3lDtqz+1F
	SPJjv4cXXHiTFAG0iS9D+CCEzqhaJw4loNBtgtZclP7LO1WPflpPXgx7qJt6oYD79tahM5
	oLhpxbnCJt2UvKmF7KYr6U0Z4oIeyZ4=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493f75f7172so26749825e9.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:24:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784021096; cv=none;
        d=google.com; s=arc-20260327;
        b=JeATWA+CCq3hPWUORbB1EmipTd9aZvKDrdNJ2vwDo/YWCH38EnbLcmqSZaCFsGNcvG
         Q6cCjuZVo6f8hMewzo1eZ5CideIGAm0w+uZTmdfAWNJRtlE2RTqdn24KDO6j9Y9Omp/i
         zItpGzOMB3hWsgYWQ3nAp5xmIJeaOQBxR4WyK/QtRs47H7X68c0U3qJ4TmhuyvxPcINi
         HgRWL8giNXHEZXzcY52FnlfyHak1qHRe+1v0kfJdfv4yo+NV15UrPCEf0mZNB0VQ2WDC
         PJ90igX+V65fHh7WbOCWdAw+uYrorH7vtyjuXp2/OZ7VGAymktlwR4AK3JKrmPJEZm40
         e+AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Eb8w9+npX5/dhsCqW4lckI0v6rU18FNTvsuJCjEq5yM=;
        fh=JKPk/MX1Q6eDwug2QjRcLNMqBCrrPfCPWglVos8868U=;
        b=ewC0cXcPJS66QYaNI8qUraBrkw7hO+v7/oXgrAazXYuguR61prppSQ0WAOUgC5G3xJ
         NlKQpOiV90eOJZSMjacBbNN7qGqFMFLRyjtbAqsUmp0R+LMKe+7MQjCY+bjm6YJk1UVL
         nmf2/mcYDF7ZmXnjJOJcZgEbb06ylFvLamY8PXHujx97kf8UByfo32Mut5PfqK6iePCg
         2US2V3OzgrQwWxiVQ+TjSx1CBXR8Db7fc9IwgC+10/h3BdvVg+DcWhq11P1D6E2cORLr
         l23/VctgvHXMME+RcDQKznxW3/aHSuk0bXs2XrQW+R8ngv60x2Sh363183vfjhBjCIKQ
         VEJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784021096; x=1784625896; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Eb8w9+npX5/dhsCqW4lckI0v6rU18FNTvsuJCjEq5yM=;
        b=g5E19SYkp22ODnC7CvVAH48fFv1+dJ777qNIuJ2btSUF8J9h4EZc/J82odIU1S8Qlb
         EicXLd09gILBqslvG/RS/7xrzNCTYJKMGx+bhZRVEGKGaOR5OjMyV2GW/ExMm/RT4YLm
         Rs8w/1Mo1frQNCszxhAyiQCTViUWahHmlD55IrmCvG+fQWd98t64hcUdZLxZMLuY8kr7
         RXUXplEQauol5lpnB8vYHpXxktgr/N8vZ9cqRYF07T8qlZOZNzCW25acOJ12A+sE1sB2
         ds9FZOKKsQCRw9MqpoE/h1YDYALhePNxLs4CCaDwMN2mPC7oqLAsQ1OhXVBakOrTRlbH
         mxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784021096; x=1784625896;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Eb8w9+npX5/dhsCqW4lckI0v6rU18FNTvsuJCjEq5yM=;
        b=WdF5H49nVYFYarm8KbI++KQysZDTvw7QeMN8kuVOrzKIH6JAIqJEHp3N6WvO+F1gL6
         26rBze8VFo2mYX7AM3bVdpwEasx0gZW/I3EVRUmBIRNh0SOV2HC+IeTfFn62vImIv29l
         wma3zw0kuPB6zPUVkwGxGh9aMXBedC1UkVETdb7XzE8clxKlakf/gVnWkR/QrqkJXWXH
         iLq1W+gP7LyS01acN4OX2SKrkzCyGNdxEDE9URQXMlZnh6EJ2pBcg5MTYtB1fIAagrc0
         eRmOE358eSMoJMaTpk4byrFqNoWFVG95ariDluUWPryvml21Rkp8pB0Gd4NGkJ+wCSgI
         2T/A==
X-Forwarded-Encrypted: i=1; AHgh+RqoVp82jmII1Ctvx73/8QznNnoT8yOL3ESOjNURIM3Dj2M0082KvSX9lxAUCn+KJUC0uSrc8TG+KQ==@kvack.org
X-Gm-Message-State: AOJu0YxCkQBhk/Bt9iBpRZbvAjdG3YjegkGm2XABcYEVfweXh0E4fKlX
	xFY8w5rjJqjq7vKlQCg8k8IKRSfdOyyLcVhZXzX5o/envbTDR2i38J2JUwbG3jgveYUhVHqNJk+
	DKH04wdp169LJ0oc6dmQB5C6UADuC7HU=
X-Gm-Gg: AfdE7cllFY2O7rOJtskxSZk77kJ/TDub+eVacdvs4ov6uM1WTikFrtWDipzhomlu3cG
	S9r8cC9yAWwf4RGOTfcnP+64Ct+KDRBIi5NqzWiT9zEO3/VWJ1GCOKXZY+WHf/P3RketJvyr4SZ
	T/QJkQ8MwQ+4qR9Q+M0pK87+dvgxgBMQafop/A0WyYqQ+wTbN5KnmDoV86YGr8L8AD0fDhLuYh6
	thamIRzMNo4rYA8NzYzwdwTUH3aNiUKg8NylGs10TpBPBe7kRX03KrqCBZXVmJIhVspSEENoA==
X-Received: by 2002:a05:600c:5392:b0:490:b00c:8e6a with SMTP id
 5b1f17b1804b1-493f8826bbfmr125775275e9.28.1784021095515; Tue, 14 Jul 2026
 02:24:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260709073823.6643-1-jiangwen6@xiaomi.com> <20260709073823.6643-3-jiangwen6@xiaomi.com>
 <bc4ab9da-0b16-4203-9901-4845323c3e5c@arm.com>
In-Reply-To: <bc4ab9da-0b16-4203-9901-4845323c3e5c@arm.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Tue, 14 Jul 2026 17:24:44 +0800
X-Gm-Features: AUfX_mylJ-bQk36F-lqOtF83r56yTp9Z07DBP_uUrN5vhZN-KgZgzRTY9TytYoU
Message-ID: <CAHKocdFn9DP=wGLYJrhndxTnxz=eMeWYjK1m2OzPotcvz_sVjA@mail.gmail.com>
Subject: Re: [PATCH v6 2/6] arm64/vmalloc: Allow arch_vmap_pte_range_map_size
 to batch multiple CONT_PTE
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, david@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com, 
	dev.jain@arm.com, "Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>, 
	Leo Yan <leo.yan@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 235E540006
X-Stat-Signature: ar88xiewdpsn9him5azytwzit7uifhhb
X-HE-Tag: 1784021096-542918
X-HE-Meta: U2FsdGVkX185je8F9a0kvqEMqVilDf/R/X+fWEZ8WjNWSOqH3bxakSgU7KBcBQreaWNO14i1KJ7DRJHOmpWyXsBBLtX+PFE/bLWl4V97n9/8ce3oD/mSMN00zmm9OWYIWIbPwGVFHxbrgZq6rjNcAwiBKU9N+sqV++G+leOUrxNiC2uK1XTYGw8aguXNTSjPk5kld2oXr1UJL0SmWX45Ii78JWSG0WumC4lCcfOkc/bLRc8QXAbCCRlN59Cpg52pxfMGWHtcqty4XcsMHALlkyyY98zSpowV04VWUz2zrJeEAGOteRPlSqi9880F8qAou88yegHVKV2CPYzKRVVDf8UGY+flQuSnx7UxJ8aNJx7taaPnnUgEYMFFMs99UoQ1uByUF2KQzLsHVFmO8V346SjQXIjn3yPxD/6/NC9e4wUNuAL/xf5QdKrxghpXXMqVWBD054kNP+9G17FdtdhLtqpFP5/zR/TLXS419z+25vSMBwbePyvrnOjKnTnwVyGTPN1mB69RNTqm/n47XwgMl3nRqGYoNfgZRmgnWy20tH8QVqN7jD7ncCwfbqCCy2HD2xbjuMyIuFfiuB/bzdK45EOUtqyMrDMaIubLLuOSclUrHpJIOElRBmwbgxMXu/AmHX34/udSy/OLcXR36UivffqLuu8dZqq31SmFBJHC9PZJr0WTBCcWHjlVyLb3mXfZNdfTy5RKt/L2CnvlqGfFQq+0RN4fx3+5KmOnIyRjiq+jVZZW2QA9mws4go4IWCM/jYeCtqVCPmF5Z9+oZXz2R4/s36B7eLH8AkplPnvXSg1UjmfvP4Z6jNkiKzQB/DW+CCYlGGV59P5tAtRAaEWpBiFKouWHe565Jc9wi98SyxD7n5iZp94yxtFb7Td7eLeRxeHCaX7kRextivefAnL9csCQkmEYgsPf66313R8sIcQC33nGXARmm6TrzXf/w4ep6lCJyDnhPA9NRYKQxcq
 fFghcxFV
 ZdmsmzpcG5s6xWehpp3dWtRd2JxEfNusawOwfYeDMIVOdlaM3RXcguUiv/chuPsgwTzi+m3uYARF7jIZHFmt8BllTu6TKA+L+tpzzJ9S/5W9FRuEGHyEIAGfQv63A4JNAcxzDPqOEXdWlTUookvqmE7gwQ16P9jNlRXjmXsjfDdHtesQXWfMCA+GwNtqDVSfvDcBFpPanYkZRqcW8AbY+BrA8vZCgrb35Qnn9F19IwuucLLiRgPn68Q7UWBmKDqt6vzpKhQfVh+s2kqKinFznCbG0JAOaEGzBMmpvU4i6fM37Ajerp2eOlJdooDYlnE9fFcuKEtINE2ZMbAdpr8V8wVgmnR0b4iNWLU7qOq5mzx2WBKH0TQkvPVpVGI8TWpRwTMlgtSfdMxQbTTkLJCPq0iKlNRzvj/8OhQTLD/CHMLSz5yfTTz9ZUiAAJVUsU7i4EHM+tHj2ADFRjzt2qrSGFFCV4EPeVXlSJ80kfanoik3E4JSd7hjLGLGE5Cbo/NmBztSHRB5Bytm93QkcFr2jmv0tnkCYKwIps01hp5voT1KRhEpzEQhIo1qyj3BdlRrhV1uMTdKnL9GxsRWP/49BqPkpQvaFx9gu9YReSX0whJ+OObvz7XEsnyLFA9kLjwkA9sCobISTIEZcamYpr0bTD6Rgng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 at 15:13, Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
>
>
> On 09/07/26 1:08 PM, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
> > blocks, reducing both PTE setup and TLB flush iterations.
>
> Too little commit description for the proposed change here.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Tested-by: Leo Yan <leo.yan@arm.com>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > ---
> >  arch/arm64/include/asm/vmalloc.h | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
> > index 4ec1acd3c1b34..7d9c7dc795c42 100644
> > --- a/arch/arm64/include/asm/vmalloc.h
> > +++ b/arch/arm64/include/asm/vmalloc.h
> > @@ -23,6 +23,8 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
> >                                               unsigned long end, u64 pfn,
> >                                               unsigned int max_page_shift)
> >  {
> > +     unsigned long size;
> > +
> >       /*
> >        * If the block is at least CONT_PTE_SIZE in size, and is naturally
> >        * aligned in both virtual and physical space, then we can pte-map the
> > @@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
> >       if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
> >               return PAGE_SIZE;
> >
> > -     return CONT_PTE_SIZE;
> > +     size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
> > +     size = rounddown_pow_of_two(size);
> > +     return size;
>
> Please do explain the fact in a comment that huge pte mappings
> upto PMD_SIZE are being allowed here, if the given block is
> CONT_PTE_SIZE aligned.
>
> IIUC arch_vmap_pte_range_map_size() gets used only when config
> CONFIG_HUGETLB_PAGE is enabled. Hence should not these new huge
> sizes being supported here also be added as valid HugeTLB sizes
> thus updating __hugetlb_valid_size() and adding corresponding
> new HugeTLB page sizes with hugetlb_add_hstate() ?
>
> OR could arch_vmap_pte_range_map_size() and set_huge_pte_at()
> can be updated for vmalloc without doing corresponding changes
> into HugeTLB itself ?

These sizes are not new HugeTLB page sizes. They are only vmalloc mapping
spans selected for a particular virtually and physically aligned range, so that
the PTEs can be installed with the contiguous bit in larger batches.

Therefore I do not think they should be added to __hugetlb_valid_size() or
registered with hugetlb_add_hstate(). Those describe the HugeTLB hstate sizes,
while this change only affects how vmalloc chooses the PTE-level mapping span.

Thanks,
Wen
> >  }
> >
> >  #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
>

