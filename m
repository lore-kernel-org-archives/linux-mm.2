Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEDB6CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E137C6B0088; Thu, 21 May 2026 09:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBBB6B008A; Thu, 21 May 2026 09:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA6E6B008C; Thu, 21 May 2026 09:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD99E6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:30:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 522151A061D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:30:21 +0000 (UTC)
X-FDA: 84791511042.25.0D382BD
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 481CF160018
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:30:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sXytiWUb;
	spf=pass (imf08.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779370219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwMA7nMY573fkX+5mD/InfckLTj4HhiPS4RhTrsDllw=;
	b=33is1iveOjpENNqrh/9ZECjrbJI/DdOQmLE6dPa10ocmOr8a/Fmh1J96wWNXYuS9DHzRX7
	s/IAqkedDoK6uTnXv1grwApJRPtZLMkb28Lk311LDqWg8DaBj+HAt9K9hejVqZkBIXhb8/
	eT+CPxs6JHuRRrQ2rxprS9Ho3clfdDk=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sXytiWUb;
	spf=pass (imf08.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779370219; a=rsa-sha256;
	cv=pass;
	b=g10v6dnm8X0AmoZnwKQbqwt+V/LGNFrr9CDrPhgE/tf+Okn2lKo6F51LtovlCO4dnwNPud
	/kwnP0d+l90mAwGeVjVZ57qaSzMhfLmp/vs3hod237bhwvS/vZMzgbGvnYjc6WxJUXneUS
	wI6BWRlMzw8xXdarfd+mrgC4/oUVrJM=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50d6b393d60so1661cf.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 06:30:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779370218; cv=none;
        d=google.com; s=arc-20240605;
        b=AfcKDt4DBCQokpTIRamdArZRhIWgprC0wIJhpE7cLLK5kEvzK/FWZfVytMGjD8tNUI
         jIYgpQ5jxl+UcJxGwW+At1Wj8DdA0LbjzlzTgA/kKTiKXLzh+nLObia3exhRlfamrwhZ
         Q8Rrjc9u6/81Z4z2TVxMu6/Ox3r4iP6yaoK+s2fPMvODhwgDwfRQmN0C15iUOdft2uuL
         nsDRfh78bVOMSrn4k6jWjeGYmOadY4UHIV0Zvb4XYWFhOa4yCxJuO8tl3QpagrdOU3Zy
         CTMAymCoq/D8xlN0iG8pZg5NseK3RwmjHpUKr1I110P4mcHtmBAm1hEkheKWH3SiJnwa
         y8lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iwMA7nMY573fkX+5mD/InfckLTj4HhiPS4RhTrsDllw=;
        fh=L6qQVUefTOYmehF0DuOFszb91OZuoLe9kLQhs2yndvI=;
        b=P772KQQM/CKl7jkbjFKITLqscoWA2fX+J4BqiCmF8OOopKpvHqY/7exIdFALI4Zkxw
         SBkRkmx8O7xNH+mD7KSzFUsV2eiaW6eH56ol6FI2Nwm/YnlH6Xg5VAla2bUINqMxfims
         R1D9FHXVFl1xE/HiPJtj0alLwHPpbOC/C+xcTeLfZlVh6nS4EgWpnAJN0/WwVfJTonFg
         NmgwESa66i1sJ37ne0YYC18j7EmBPFFXpr9msbaLQxcjCbSVAydnY0lkyKgSENcqL1E4
         7HgFHrHplX1wC/zsWjaHQRxQbXaz7F17RCWRQYRprQDxHPUQIzmpXnsk89AXOu91bZne
         44Sw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779370218; x=1779975018; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iwMA7nMY573fkX+5mD/InfckLTj4HhiPS4RhTrsDllw=;
        b=sXytiWUbkSffnMmntpTKWY7EXG8xOVhm9H4bh6NXxt9O7lb0zwUxzSGugR380L3bKK
         7Y5U60JLX37yvYTOIti8mAZ3RlnQCYPYRKvIkfsuSWzTQbwXsrhsc2t2uqRWBg5n4s43
         OdvjZfMjcQV+iDmchtLkQjo1GwXUSfFDrsnynjOhllg79kGxfXn7EyyRaK+EFSdCghz8
         BbF+MbY9xgpZ/cwriOCwmKaDNcUZOpYSKAR31l33SUvoqdaXz9SWQdl/cxJ3C5Sszq1a
         5gcxb8dSR/ZPevsO0gcYDlTK3+nljQ73IGYNwp8U+4LPKSJbNdhbhhYODbe2wwOsOEQQ
         67tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779370218; x=1779975018;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iwMA7nMY573fkX+5mD/InfckLTj4HhiPS4RhTrsDllw=;
        b=pzjBFP/FuNWb/AyQPFXM2Ur9Oh6AKiEPjjEAJDkVmhKUmbdYyd1PKgfI1/huGmzfZ5
         1ov0hZoHJF8/4gEFUXoUDcCjyXxQzLv9KU8av1GUlpvwYFHDg121pVyx3DBUecCKL7MO
         kIOORzAAbBe7xlVSuPNLdViYwRo0M4d8r5HCfgdOeoApDHzu/0E3YnBO5KKa7cfKrZW/
         9GFtAoERd2ftkJsAPlUtYhkCWfl+YAiNMcrsp2+xy2yM4b3/1rsCFWp0BdCayPGb/exs
         z9xbx7tDrC6dQ5GJveF8QrfXVEkyS4hm9z6icYSOUUlC6xyd6KPSoLjlJ8RXQqY0ZKt2
         uc0w==
X-Forwarded-Encrypted: i=1; AFNElJ94Nvckx4QWr2JeBMmdaD4p9cy/MtEXgwwij0CpX6QWXvj60v0b0IqILQGA8+phkFcFZqph0py8Yw==@kvack.org
X-Gm-Message-State: AOJu0YxKQ/vMMYU9KOYh233PljmEujdUqzlfKvPbuLoYVP7+UvD64X5i
	VDgW+kpoOFbzdb8hyUPSq4hD/uwGzrTWxJDsqCuBqLmofhtmYzE5MGDpg3kasGeZh7LFjAzaC5e
	uPgqtm4RQR1fMatPeaol11FauVwoUdpMhSqMpch+j
X-Gm-Gg: Acq92OFxs8s0XqoRkXmf+aJOccsq99YMWWjra0bm8eUCmlLbQs0rzFV1V+jOrOotykJ
	qEqUsik3rHjgWkwDZ9MmxvCPKrEPJzFH/xMoh9hr6/d59xxwYsT88RSit23HJNRywNnxtkcA1go
	IlXy9jlwUGzy7J5F5OW/1PGa7jhwaoqcskAlRFtw45IELf1ULyPhIBESvSom6glqzRmMh5+TBLN
	VKsGpQQpy1agMlCMxGY6x4yEClz+PzdxgsRdUftBOHOWeF43P34F/LOmFIEWzJcLLO6OF3TNF9X
	bS7luvkXdPriZPJNTyVhmDu3DJfJTA==
X-Received: by 2002:a05:622a:180f:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-516c52f3a46mr9684061cf.5.1779370216975; Thu, 21 May 2026
 06:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-16-91ab5a8b19a4@google.com>
 <CA+EHjTxcadguOfOo7RpJVtAzcY5JAFZTbrAT_wcN6akMi8gCUg@mail.gmail.com> <ag8BmtzxTlcuA_zy@google.com>
In-Reply-To: <ag8BmtzxTlcuA_zy@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 14:29:00 +0100
X-Gm-Features: AVHnY4LwO5a6KnCwO_nS2hLkyezQ0CT4SoGe3eTfLFP9egS879lHs2YrlxKCX6M
Message-ID: <CA+EHjTwA_qOnbKhGSDxo_nbsXRqTM1zY1Jqs1drn24PTv-fNPA@mail.gmail.com>
Subject: Re: [PATCH v6 16/43] KVM: guest_memfd: Use actual size for
 invalidation in kvm_gmem_release()
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 481CF160018
X-Stat-Signature: nppi4z9agppedmeh5kz73poc37wcntdr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779370219-506069
X-HE-Meta: U2FsdGVkX1/gRaaOzehS3cQkkKGZ/FWOW+ZsD4xWANcmHullzn3ia/QUd3slECtPLAwzlDicuNUwDV7zHJufnkTcPzJs7UrzuNYglHybFO0F/titG+KW8lXOZpwEJiqs7h2axZTvvMvH0FKFNR9kHLPz9deJ5FDKGIPGENPKyz1i8NWzyk59YvXTC/RuGbQYyFgl4jmyRCwdvy26SIIF+pu4JTs/r7mbFIVBtC1ummtAbWSvMUIu+ZMvbXPlE4C+zYbNU5MSIU/pgCj8ec5mEgHKksx+SW7za3ZO0VdTQNawSWIcapx7jAjAVULnkDsu4AAd0xzb9icG3zkuz9Rj404HKTLlp37PU1ceWPUDx21LDrqDYeid9TLeEzzhEDDyzyxLWBOaTHloHUnFD8T6SJp43AGNhqkqzH8taIUpDJbXUubrc58tuxNwDdCiNlIr2zv5N92xzGMyKoUu01cJbPOoDkuYNAn0OVvnP1x0Ox55PmCZ74RkjcSKNvuQMO9obFnA2ofbL4+2fuT1hI8qRbVwPhsx/CrKoqKRh1ekcz3pbr4fL7CEBvZdnREtEnQHO3vx/6VQRoeXuZh7ufyCmXlTv0o8LSG5q0F3d3gOj/IE2m2iVPPY+7hptlZtEoyCD1oAe5G05lwdeiQoBVixsNxTyQ2/RdgYHtne4LhRtNljVGGvAv52fkcb6ACPfgu+P0Kq6WI9F+lYOJsZT9HbjdSAH8hl1zWQE1mLd99dw9Ph72KvchxKG6U+stwuUSsc7hZJ1zC3ri4GS5hZ+t4+ykfKWeec+VHjLluyqJVjDLfiaImSSUfZ5rwaPrh+5XVMM3gYat3qM/5twRBoe1W1gDBifohd4Jj5yHyuqJE4wSJoqAeAK7h+KnNeCrtMcSCrR3Wdk1tWfLXS5KQdWpAvHxw/cagui0fRsfb5Bs1Utkpd+O3ngFqMjEQyzSfyhLK0PpfBFeAbq+PtahEKdux
 5iVDdcnA
 9FbLSHnyZxmPt/rwtQJOnVo9mdYzx+b71YnR4sDmuddNV/yq6MW/dXEkMPdHeOiCLuHcpcDesXLCivA5fA/+CUSl5tBcGnpCrM8t3BFJsQoFTtIdQVlVz2dHoZ8fXKAEAKiI3Sf5iJgUpV2TG162cPJ58BhodKv7zZgj80QetuPJe0+52Bkb8xv9zUb6LXu/y+C7rDqM4WJYSaFzxonfU189zmyWcPOic4bCwdWCEEqI319rn0Rd4e6iIpjsqqJ4Sfs2I1wN8MdlJqpUTwKQ+f7gUp0YNuXthOvJOP4kb/1YeYkULCfDMKZWvS4FTbbAC9NLKcWcvsUpetiDsAoL2Km8unpaLZvgKD5IFKG4eG+iW3kjF5ILoFhjZoeOsCuCI+mhGpuJylegoUEk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 at 13:59, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, May 21, 2026, Fuad Tabba wrote:
> > Hi Ackerley,
> >
> > On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
> > <devnull+ackerleytng.google.com@kernel.org> wrote:
> > >
> > > From: Ackerley Tng <ackerleytng@google.com>
> > >
> > > __kvm_gmem_invalidate_begin() and __kvm_gmem_invalidate_end() actually do
> > > not specially handle -1ul. -1ul is used as a huge number, which legal
> > > indices do not exceed, and hence the invalidation works as expected.
> > >
> > > Since a later patch is going to make use of the exact range, calculate the
> > > size of the guest_memfd inode and use it as the end range for invalidating
> > > SPTEs.
> > >
> > > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >
> > Want to look at what Sashiko has to say? Seems to be a real issue:
> >
> > https://sashiko.dev/#/patchset/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4%40google.com?part=16
> >
> > If I understand correctly, the fix should simple: use
> > check_add_overflow() to validate the offset and size parameters in
> > kvm_gmem_bind()
> >
> >    int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> >              unsigned int fd, loff_t offset)
> >    {
> >        loff_t size = slot->npages << PAGE_SHIFT;
> >    +    loff_t end;
> >        unsigned long start, end_index;
> >        struct gmem_file *f;
> > ...
> >    -    if (offset < 0 || !PAGE_ALIGNED(offset) ||
> >    -        offset + size > i_size_read(inode))
> >    +    if (offset < 0 || !PAGE_ALIGNED(offset) ||
> >    +        check_add_overflow(offset, size, &end) ||
>
> Eww, TIL I'm not a fan of check_add_overflow().  Burying an out-param in an
> if-statement is nasty.
>
> >    +        end > i_size_read(inode))
>
> This is all rather silly.  @offset and and @slot->npages are fundamentally
> unsigned values.   I don't see any reason to convert them to signed values, only
> to convert them *back* to unsigned values (when stored in start/end, because xarrays
> operate on "unsigned long" indices).
>
> i_size_read() obviously has to return a positive value, so can't we just do this?

lgtm,
/fuad

>
> diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
> index a35a55571a2d..9c6dbb54e800 100644
> --- virt/kvm/guest_memfd.c
> +++ virt/kvm/guest_memfd.c
> @@ -640,9 +640,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  }
>
>  int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> -                 unsigned int fd, loff_t offset)
> +                 unsigned int fd, u64 offset)
>  {
> -       loff_t size = slot->npages << PAGE_SHIFT;
> +       u64 size = slot->npages << PAGE_SHIFT;
>         unsigned long start, end;
>         struct gmem_file *f;
>         struct inode *inode;
> @@ -664,8 +664,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>
>         inode = file_inode(file);
>
> -       if (offset < 0 || !PAGE_ALIGNED(offset) ||
> -           offset + size > i_size_read(inode))
> +       if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
>                 goto err;
>
>         filemap_invalidate_lock(inode->i_mapping);
> diff --git virt/kvm/kvm_mm.h virt/kvm/kvm_mm.h
> index 9fcc5d5b7f8d..3cb5ef86d0d9 100644
> --- virt/kvm/kvm_mm.h
> +++ virt/kvm/kvm_mm.h
> @@ -72,7 +72,7 @@ int kvm_gmem_init(struct module *module);
>  void kvm_gmem_exit(void);
>  int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
>  int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> -                 unsigned int fd, loff_t offset);
> +                 unsigned int fd, u64 offset);
>  void kvm_gmem_unbind(struct kvm_memory_slot *slot);
>  #else
>  static inline int kvm_gmem_init(struct module *module)
> @@ -80,9 +80,8 @@ static inline int kvm_gmem_init(struct module *module)
>         return 0;
>  }
>  static inline void kvm_gmem_exit(void) {};
> -static inline int kvm_gmem_bind(struct kvm *kvm,
> -                                        struct kvm_memory_slot *slot,
> -                                        unsigned int fd, loff_t offset)
> +static inline int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> +                               unsigned int fd, u64 offset)
>  {
>         WARN_ON_ONCE(1);
>         return -EIO;
>

