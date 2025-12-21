Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 909DBD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 04:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B626E6B0005; Sat, 20 Dec 2025 23:26:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6716B0089; Sat, 20 Dec 2025 23:26:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA786B008A; Sat, 20 Dec 2025 23:26:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 861C76B0005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 23:26:02 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3780D140698
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:26:02 +0000 (UTC)
X-FDA: 84242190564.04.8C917FE
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 394104000D
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:26:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kzKeC0a6;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766291160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LpGoIV9mITVV5O2N3QmL1sMyHl721ZyY07GrdBcwyjM=;
	b=SYuBn6natmABHAwXxs0uD8/khTA8tsAmhHNSbV+v56YdM99jUOVw7tbABf2lRgLsXri719
	6VnBwzSbDOb4ZDCBO7aJcXxQkijYSdy95q8E9O2xPs52uvBeCehF8eSFb3gaP74F2T0rv4
	nuSeZWhVnvwD0Ua2b8AlIDJ1Rp127Gw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kzKeC0a6;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766291160; a=rsa-sha256;
	cv=none;
	b=GG1W1fxb7BxqwwM+hA82Km2EBGJWktXzygHOCXKKuT07r/5V6hrnnYNtiGuwbj57CEqa+5
	Pbo50nDbQ43W81eT3TI6BhGEiOiYO4ZKV8dNLb6HOTX2A9sHulUD2HNlLcNR2XLPPGtr5y
	klXNR7YBH1Wjde5O/HzT5N+Cz9MYfqA=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-34c565b888dso3427496a91.0
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 20:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766291159; x=1766895959; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LpGoIV9mITVV5O2N3QmL1sMyHl721ZyY07GrdBcwyjM=;
        b=kzKeC0a6dQs5N/5nk+iofOnp2XD2fRuq2tNSyYh2g+XojofEvxm3iEhF88GDxKFFTe
         EJCLGdhpOas0oquSblg+NItyiz0+eFvxCl7qmn/W8qzraibKrX5AgwKrQa2Sy1uTksfI
         ND3PHK9u2o87CiiNZqN0vO5XHcA0ywYlyCA5+gGmpFc6VvJyIS7DqYeUPY8QGchMoGFH
         SyJiBFP8WZTEosylZBEFhD+3q1jEFckBG5hZYTJCh+PiRAYTUo/N1oX7UKnQ2dreKToP
         Iw/5rzYCqmEB74L25es7fyk/W4/8Q/+cJqAPfxb/KRemqP5mv+i2X4oiTD/WrCKXLZLj
         +Obg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766291159; x=1766895959;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LpGoIV9mITVV5O2N3QmL1sMyHl721ZyY07GrdBcwyjM=;
        b=jp5agtVoNyQezFGpO+GGr7C+8xVciT7d4qd6xHMaS+ciuWxovwmdJaR8mys/rc11IR
         4pZFwvqMyIPQ4chiM9evmLpSoL98UZiv5HsiuQ6Vb4KVih3vkbzgSOSAS4FBN9Wu9OX/
         9G5rddYG5YC20uyMwUfqZFLSP+LtrUhTwOtYR4k0F9DGxW5xV9i0T7Ncyav9Bx6mhMXl
         o3Y4nzyhK41Enwg/9a7cOFChqA6rjlQn8kD6HDpn1SafF4zuNuC81oKgWvONj3e56Kwe
         ZdLMwvGF5Kwy0I/qQxzwwTrPd0ZIwjm7csHPQYKI6gY2wqu8mrTuF8xTSiNu33c8Qm0A
         tnOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUG1Q3bvc4WEqFfnv1t473+DhXkecAg/6m8LLuuKhl9TStywNZjQmnT6gyDCO4ik0pzQMJQqvCjOA==@kvack.org
X-Gm-Message-State: AOJu0Yy7EYZJY/Fog693iWDcugN2pkQwV69D4+erVwbMN8AgyK/5KSX4
	x1dFa3whnYBKg2Yc9NVVDB/AG6Ur4jDqXrGYbxoFqeBJ4SgICiL5yf+j
X-Gm-Gg: AY/fxX54tXE18AVrG8c9juAgSc+zXBXdy7cdWfhWGG/t3NIwQIkEluQhVjTnCFUfBcT
	JpTjYuixdC6UWQAfeB8MeTIcfIv/be3ennEUYxC0E+x+c/2W8E1H8UO9Noc2fPvYx74FXZvGjc+
	pzijArYtasKHI4Oe+BenPOBp+nVn4ll7u+vdpMAqWpYb+xSQvMqgZloVyUmGpTfWZcQUZ5j28VS
	tnmJ8X9Jvye5FBcoaJ//Mgap8kcHYkZPR/qDoY9SHEV86krwe1gGuv+r6FY4Lo1K44TJrOe6ElC
	SU+m64XcYe1oIX88oa36kSr/Edi5PUyTVccS5mnxO8UHdGEiVu6obSRy3k25TGWuCvJoIsVMuNo
	Q+jMFpVtWmswk4K3pgVNqa9NqghR60DGKPW57Hc19vmaRhGDc3T9sn5NJ7U4rz23u8ykJejw4PA
	3iolSyGbekM81P3P1le/8xoIAW0A==
X-Google-Smtp-Source: AGHT+IHNNuynLyRmIPqzr2LeSbDsX8JQfc/BaLNI04hU+jLXbgaR6T4E8rvmFHPFVnqbrGTclw3VmQ==
X-Received: by 2002:a05:6a20:7489:b0:366:1919:5646 with SMTP id adf61e73a8af0-376a75ef72cmr7730608637.1.1766291158701;
        Sat, 20 Dec 2025 20:25:58 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7c14747csm5743255a12.27.2025.12.20.20.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Dec 2025 20:25:58 -0800 (PST)
Date: Sun, 21 Dec 2025 12:25:44 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
Message-ID: <mcf4mydmyz6e5ioeseaawhfro2snox4hyfr2irpx4kxkagx2k7@uszrm24ulffg>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-4-yanglincheng@kylinos.cn>
 <3c75d915-5d7f-4e80-975f-4479393e7139@kernel.org>
 <tnvhnikpfxyjassrdsnqmpxlem3hnoepwxmp4hysfzqzl3wltw@7utx5hxc52th>
 <6e8684a5-1f71-4be6-8805-9b047a2bcb78@kernel.org>
 <20251221021044.2r5fhepiyyhvuo7h@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251221021044.2r5fhepiyyhvuo7h@master>
X-Rspamd-Server: rspam02
X-Stat-Signature: hysb1y8wxeyc8oimhz4c1hzmfeg47dcs
X-Rspam-User: 
X-Rspamd-Queue-Id: 394104000D
X-HE-Tag: 1766291160-219043
X-HE-Meta: U2FsdGVkX19GwAbGF0XMlsCszr3e6yNHTzLqJrWrh2BfTJLx8xBAFwS19t7h+SrmCnK/Nvak4j+/8F3t/DiLJYxlrxULSs+bSk2CD2sJDpMJe6ERZfA2ipezszF0duAkTUpKAdF5LyXxevjWHSurHduZjMVfqjj9/aBUva9Mv7EBRV0thiAbhB7dQTvpy5VtEgsbfnQlRt1QMOsoit5UgxcqYgUpS/GRiHUEiluMrd6R7me8GcxOwX2o5kAgwoNzuLZ+1+pzwyLlM5foub58JrXjoO5kn/UyopbN1a/fVwZgp9gWS6oQd0hgMgifrjPlH/+A7W/gn8TA/3sIfflQtiFeNqD5//txBMb8VNstS9766Azwm6zo6eudTCV2tzHueBbXYUvoU3Q+0cbm8XAiiuU36aALIMHBv7IADVR55h55aOTJMRE515QYdVnH+nwtNplFMoDvtYQNd4lYj4d5rTeuVFHCDii/Z2IBbNMNJHb7Gcg1v4C7vNwngsgiIAw6Gjd9GE7pn4Fd6G5ZpQT0mJEuISNwCZoGmr5J5bG7lIQqmwqvPeKiIIQKd4ZDeKAWKPA2y6M4O33qIfSCTis5piSpt02hh8mNIlxfDOCbYemAatX4bJPL0QDvXE0+D8Ikdf5AQdafifg9rYwWkx/7mDPIExsSTSkVS4eSavc3yNohX1Fd2rXXIL3oHGgqN3aqzCor35tG13myDg2oVzoTn9rXA9YVspt3xtIQKXL8F2xJDHZ3Kzh/REcGTLvKXQ4uWxQvDLMct1sV2bwY20m2bATkE7xRy+qYiFsPxgHRrqKCAQ35yT4QMJqgR8Oe1zuhc2P/5+TMheSSPHFJCKwOvHBipXYRyKZ8+10bHO7eJlQU/Cmj4nzWqcgPu4sXwAbd2HGpCAJCGxiWj94SuuW3dIcKwEddQj2GireIrL4umLUosrYnYeCuxr6OxtslAsx425YOlu15zvDa0dVoihA
 7sVilmzA
 5C8o2BF16EjN1nwTlvZahyQ/AySOTAvGh5gZ/QxvDpHMUfihkg/CEmnNWvBLOvBN4zUC/cCb7+maDk8R+m1hva2c3p3e9mkNcth9QMAXL2QnTgte+5ysLhKBg/RckHe3tGPIISbOHgmA7HywTW/MPeRF3E32Abk1Q0/rLdo8aD0VbVRdhLmFM4lkTmd6MwdbFbAJ9pMTOwVzh8OxboZNvrP9UXJdMuki/xDzlb4LLP5yJSPkU+I5+9J8mVh5Q+zhH6zzsDTDkwLlkOVRUlwU0FrRIeENDDXDAEvhiJx8fQSVw0ufjO/nUdWkwJS7ZBoHaqvABFc99xriHsrjwCh9muAeiIhypfOgjn+Z/VTiYUnGflzqzuq8tesfBZAGJUMxz5cTsU5sCXnzDK35/DhOeAQ/rhv5zLC/cK0UJRLeidf+UX7XsURluxUcK00muOg7AnmHqr+wlQR4rKdMTA5yLnhxhRga8SaO4Zj7BfUr03JwpYHy4aVRMGfEFCiiWCUp0avLBXHRQFrJiTjp4vY2jMow2s1LXJCoD/bX68uGzDp5AnrwAsJYU79R05HGcbBZ1BDKfHSSW70AU0vclrvhyOO18tl6Fdab2FvuUA2+IzCcCSs+D9VVhE4bBA76lb1yy8DQQ2b51N9j/5bT1gLgGB29egXCpoZNKaw1+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 21, 2025 at 02:10:44AM +0000, Wei Yang wrote:
> On Fri, Dec 19, 2025 at 09:58:17AM +0100, David Hildenbrand (Red Hat) wrote:
> >On 12/19/25 06:29, Vernon Yang wrote:
> >> On Thu, Dec 18, 2025 at 10:31:58AM +0100, David Hildenbrand (Red Hat) wrote:
> >> > On 12/15/25 10:04, Vernon Yang wrote:
> >> > > For example, create three task: hot1 -> cold -> hot2. After all three
> >> > > task are created, each allocate memory 128MB. the hot1/hot2 task
> >> > > continuously access 128 MB memory, while the cold task only accesses
> >> > > its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
> >> > > still prioritizes scanning the cold task and only scans the hot2 task
> >> > > after completing the scan of the cold task.
> >> > >
> >> > > So if the user has explicitly informed us via MADV_COLD/FREE that this
> >> > > memory is cold or will be freed, it is appropriate for khugepaged to
> >> > > scan it only at the latest possible moment, thereby avoiding unnecessary
> >> > > scan and collapse operations to reducing CPU wastage.
> >> > >
> >> > > Here are the performance test results:
> >> > > (Throughput bigger is better, other smaller is better)
> >> > >
> >> > > Testing on x86_64 machine:
> >> > >
> >> > > | task hot2           | without patch | with patch    |  delta  |
> >> > > |---------------------|---------------|---------------|---------|
> >> > > | total accesses time |  3.14 sec     |  2.92 sec     | -7.01%  |
> >> > > | cycles per access   |  4.91         |  2.07         | -57.84% |
> >> > > | Throughput          |  104.38 M/sec |  112.12 M/sec | +7.42%  |
> >> > > | dTLB-load-misses    |  288966432    |  1292908      | -99.55% |
> >> > >
> >> > > Testing on qemu-system-x86_64 -enable-kvm:
> >> > >
> >> > > | task hot2           | without patch | with patch    |  delta  |
> >> > > |---------------------|---------------|---------------|---------|
> >> > > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> >> > > | cycles per access   |  7.23         |  2.12         | -70.68% |
> >> > > | Throughput          |  97.88 M/sec  |  110.76 M/sec | +13.16% |
> >> > > | dTLB-load-misses    |  237406497    |  3189194      | -98.66% |
> >> >
> >> > Again, I also don't like that because you make assumptions on a full process
> >> > based on some part of it's address space.
> >> >
> >> > E.g., if a library issues a MADV_COLD on some part of the memory the library
> >> > manages, why should the remaining part of the process suffer as well?
> >>
> >> Yes, you make a good point, thanks!
> >>
> >> > This seems to be an heuristic focused on some specific workloads, no?
> >>
> >> Right.
> >>
> >> Could we use the VM_NOHUGEPAGE flag to indicate that this region should
> >> not be collapsed, so that khugepaged can simply skip this VMA during
> >> scanning? This way, it won't affect the remaining part of the task's
> >> memory regions.
> >
> >I thought we would skip these regions already properly in khugeapged, or
> >maybe I misunderstood your question.
> >
>
> I think we should, but seems we didn't do this for anonymous memory during
> khugepaged.
>
> We check the vma with thp_vma_allowable_order() during scan.
>
>   * For anonymous memory during khugepaged, if we always enable 2M collapse,
>     we will scan this vma. Even VM_NOHUGEPAGE is set.
>
>   * For other cases, it looks good since __thp_vma_allowable_order() will skip
>     this vma with vma_thp_disabled().

Hi David, Wei,

The khugepaged has already checked the VM_NOHUGEPAGE flag for anonymous
memory during scan, as below:

khugepaged_scan_mm_slot()
    thp_vma_allowable_order()
        thp_vma_allowable_orders()
            __thp_vma_allowable_orders()
                vma_thp_disabled() {
                     if (vm_flags & VM_NOHUGEPAGE)
                         return true;
                }

REAL ISSUE: when madvise(MADV_COLD)，not set VM_NOHUGEPAGE flag to vma,
so the khugepaged will continue scan this vma.

I set VM_NOHUGEPAGE flag to vma when madvise(MADV_COLD), the test has
been successful. I will send it in the next version.

--
Thanks,
Vernon

