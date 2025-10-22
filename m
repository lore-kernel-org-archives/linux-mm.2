Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25208CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE588E0008; Wed, 22 Oct 2025 04:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6088E0002; Wed, 22 Oct 2025 04:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC6D8E0008; Wed, 22 Oct 2025 04:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF188E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:15:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 101841A0601
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:15:02 +0000 (UTC)
X-FDA: 84025039644.19.9D11EC8
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 32B291A0016
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:15:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NxOOObbV;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761120900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kc+KKthH3EZzvZbA3/zNivfsabMNFBxOZip1Q8c96nE=;
	b=J0X48TZcDGJ+8N2he0drKbRiLKnhOY2NB2V8KlAsOBWT8aP3oWpJfw/lfMKf4nFYXWr8Mj
	k6EhPFftplA0vIFUiqBhY1BdJ2uBiSX48LgCKYfBFB5N/C3pY9eee2KaKjOpe0MBhfR1pm
	lu0u3Z3acS9ewokEAcDccTpkNpfr7dA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NxOOObbV;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761120900; a=rsa-sha256;
	cv=none;
	b=MOjkWtzr7fygXPVFKlrhahZJYNuRIPITcfKuEEG/DW14ggblccx0YbaSUxak796hh0MpwG
	7/LDNtcETzkRlAM7tUyKEbVB+EV0Nm8NbHIN1M+i4kMir5wfyDok5V1mgfQh4nJcGi/gkf
	pX+EGTbhn0Lk91sg9JgeAf6Ewuf6vhA=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8906eb94264so888885385a.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761120899; x=1761725699; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kc+KKthH3EZzvZbA3/zNivfsabMNFBxOZip1Q8c96nE=;
        b=NxOOObbVQsQQZ/dP+/7F34LBEiqTK4/8OzESxIaDiIuDYveoQptApgwlkimTGeX658
         Boexq18rsQd6J0xHdBQhhYRQsX702j46qNqoyaEMkjFGJT5v6KggHY+TKoOFqdeBDccF
         JYc5fMUv55lJ/admSjRn12LjP5rHEEaVWufobTl7L2TWOF4bGnlx/rtyqiVRcYIgGXAo
         ISmNJL0EXIL8titruS8DI5CXSaJrU0MQdP+DzjVwnbcem7ClLEIqPuFGIKUADUUWETOc
         UBEF0waKhW/tfqtK07ONQfXD8qcYt/CMywIPtEeGANrq1U4rYvudS6dRRApPe0ET86Kt
         7ymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761120899; x=1761725699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kc+KKthH3EZzvZbA3/zNivfsabMNFBxOZip1Q8c96nE=;
        b=tkJxCpqoa7jzQCn5FIbEgejLiqMUdOuN+XGsF46UYwW4/mJWjvZPI2Zzog0xzpyOqQ
         kYLinp8Ae0YRXlq6f4G2ODrBvM86NeKI2vl/QXep2CNfecKqHHUFlRVYs5d79261d/x8
         NFcgmLZHqbeF1U9B8urDt9mOSayyaxjvd2z0lw3vQ43iPKPYc8RfrUojcv1X841dAOAn
         8Jk7CaVTvTZs4whmsVPsKaVthfGmypueQs73mKP0XUqZnzRAv7SxllnoY4bmkjAte5ea
         nTlJmxbNhE3E1IIYuTiNqePrB1bRezUzfu76YEyalXKLjUDQ7UHa/nWEKsx3gzCFHji4
         QRAg==
X-Forwarded-Encrypted: i=1; AJvYcCUtDUFXiDi+jjmWRU0xPKE0Uds/clqWXzEbF4f6aNQDPChmF0dcFNYuu3DoKaZ7UBI4ZRNW7liDqA==@kvack.org
X-Gm-Message-State: AOJu0Ywl3WFqEATFizUvfTuNJbrfnWWQUdrGoazsxbT7NM3l7ySWIPuT
	vR4peuYiXUjTkFIFe+QH/M7oh7SMPvyHU+hBQeGDffPfD7mkGHMMpQHy85XmHk35NVLvV1u1U8K
	ygyxO13E80YGMrvcLvFVzXeS468WqHI4=
X-Gm-Gg: ASbGncs0rpNFeNstFe2U1xTsoZFzvqocMxuTMKBW4RJp6htkW6/0jxbkQ6hYFmx+tIW
	gLqA85hQc7821qB+kf0zkwTzNu5YD1i+QgyO5q2GH18X57Ycq/P3ANEM0bXF77oAd8UTBuRMOrD
	5j2Qj/G5pQxX01CATZFNFwDRTvlsAPVwIWWfVHKNtkpKf/vReCyu3oEJkbhjcElXNpAyzy9H8Zd
	ySMznsikr8scwvFK8lMGa9rqsv6R0+S2C7HZJr3Xvjw+cXgZoW1cvfSG0a1FiKocq1sexVboehS
	jU99K0CDP9BO5kwg
X-Google-Smtp-Source: AGHT+IEhER7MQg3744Yoz4/uML1arKqJYpMl8e42fCr1hdvltEI2c6JTn5tM+Uei72z9xIzjCvWCn/SXFXsGhGVB7zM=
X-Received: by 2002:a05:620a:471e:b0:892:624f:7f71 with SMTP id
 af79cd13be357-892624f82b4mr1714089585a.88.1761120899131; Wed, 22 Oct 2025
 01:14:59 -0700 (PDT)
MIME-Version: 1.0
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-3-ying.huang@linux.alibaba.com> <CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
 <87a51jfl44.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <87a51jfl44.fsf@DESKTOP-5N7EMDA>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 22 Oct 2025 21:14:48 +1300
X-Gm-Features: AS18NWBLKZ7qT2Y1R89WO7GO8UtVmSMjKHbsauP0TH-Q88ewqIZQTW6sMd0AXws
Message-ID: <CAGsJ_4zPH0fwBOLQwh1y6jG3tCXHLGRCTyVVSCWb+NfLCEMV0Q@mail.gmail.com>
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Yin Fengwei <fengwei_yin@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 32B291A0016
X-Stat-Signature: iwxyyiswjdo9ksnjq6p68aomcg8jp7nh
X-Rspam-User: 
X-HE-Tag: 1761120900-505511
X-HE-Meta: U2FsdGVkX18MDOm6nH8v3Kc7lSsYH/UwnXcvMni6JjhtXxjl9OcMWvDdIuNvZoQUUCmODpA5wWzhBaVaCZWaK56L3hZN5yiWNmzjT1cJGsjUJfoHTiZHv51xJhDn2GvzDshBpNCqIyzKaqWmVp9vQSh6FV+vnqa1JRODXiDqhXmHfoWCd6Rd1xUR+EvSUswwYDxKjXSU72GTHzLXTI6t9hRTJyP/AUbhrSY1KtBnMd6aFpmcp4owSi770K+v5cO5vDxoh9Vx345igu0oBo9XwIymYtlrwIqhDEzAH16A7+3fQMcxBZ1JMg+7iqP2TweVh4Nm1W2mfemctkuMDcDcP9QztzoMzIYHAgPf+BLyOouHD3Xd+s+fDmKT4umnyKBvmPvaPKd3JzIktFRIWi4ljm9Acy+JEDF3dJS6jlnfWFjOEpmaWxze5gWslpNylCfFhEIgRPQOqZrbNXrjUz75GPTfz88x6hjEzNzFvXNAY2L58lILhrbf15ndoRBlp0BJTWDqdwI/+Fd/f5lMU5TVc717aNNstiHmstI/C59TzXdNn/oSDFHc+PiIQLqidY20o9zKf3C7tfykjdcIFNSRh1PyGV9J7E5mBDATLy1B7ng4dnm+EweJTuHva1BVXE4w5y/Kwy4Mqs7Ye+RR4UR3NcaWaXzqUS9YZEnHkVakiiXjYfutiQ+aZA1WnBjhkaxfvVAoZDBtGgTbv0On1YvHhdPrCSrr9LqkA+UW+XY7aope6qHT7MuHjjBBi/ZSSP9Rvouov1ORrUCh7Gf3tMPS0IPXzsIFs1f9N6uLBu033ynKVWyeDJN2k+R8x2aNF62F3cRRRPBhgz05Y9FhlKVD5JGr3yz5C+gdpFU7Y3uqTSVDgZxoIO+ys6lC5QebS2XjmwPy2EpSrMWM7NsSD/vbYNGVD3Qqq3ve3XLFzcB2oEaG4p4DIfMwg054MMAH44xUOTcNnz6jvJA7bQ0gUzB
 SsOCVUja
 yYs1B73Y0V+vK0V6gopP+CyvSG0u27xDUdYbq2R1YjTSycNBWn1Z+T7l1wIK9w8pimdO3fM6dJXhe0a+bKhhvtLgogNZxxcRcQxYZjzBWmtzhJI0XBv4D5HWsRC2vmpmbPZ0Ce2f3kmk2wRJ2acuFJxckztEL50i5XclN4iRJOy+Bx93hBMIzQZDIM+xNnH5k257BzDmpRMCWO6JHJHdh1HnHIhPGyzc1cgcJ3Aqy2j/wEzn/oPqCEV3O8vNTEEvsDMd/Ouk+hUy2lohp30V5Q0/igQ5Yt6ujNlj8x8k+x7Q46txykZPahWEM/Um9A48tMHbtIMCN0CNTYkQBVjA2MH1RnOVLXsNo6sxEzq5PPK4cFAc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
> >                                            unsigned long uaddr)
> > {
> >         unsigned long addr;
> >
> >         dsb(ishst);
> >         addr =3D __TLBI_VADDR(uaddr, ASID(mm));
> >         __tlbi(vale1is, addr);
> >         __tlbi_user(vale1is, addr);
> >         mmu_notifier_arch_invalidate_secondary_tlbs(mm, uaddr & PAGE_MA=
SK,
> >                                                 (uaddr & PAGE_MASK) +
> > PAGE_SIZE);
> > }
>
> IIUC, _nosync() here means doesn't synchronize with the following code.
> It still synchronizes with the previous code, mainly the page table
> changing.  And, Yes.  There may be room to improve this.
>
> > On the other hand, __ptep_set_access_flags() doesn=E2=80=99t seem to us=
e
> > set_ptes(), so there=E2=80=99s no guarantee the updated PTEs are visibl=
e to all
> > cores. If a remote CPU later encounters a page fault and performs a TLB
> > invalidation, will it still see a stable PTE?
>
> I don't think so.  We just flush local TLB in local_flush_tlb_page()
> family functions.  So, we only needs to guarantee the page table changes
> are available for the local page table walking.  If a page fault occurs
> on a remote CPU, we will call local_flush_tlb_page() on the remote CPU.
>

My concern is that:

We don=E2=80=99t have a dsb(ish) to ensure the PTE page table is visible to=
 remote
CPUs, since you=E2=80=99re using dsb(nsh). So even if a remote CPU performs
local_flush_tlb_page(), the memory may not be synchronized yet, and it coul=
d
still see the old PTE.

Thanks
Barry

