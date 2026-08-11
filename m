Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C34C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF576B0098; Tue, 11 Aug 2026 13:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496686B009B; Tue, 11 Aug 2026 13:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC2C6B009E; Tue, 11 Aug 2026 13:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06A9B6B0098
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:35:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86810A1488
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:35:47 +0000 (UTC)
X-FDA: 85089691134.28.360DDDC
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8658320008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:35:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WOw8DVYS;
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786469745;
	b=T84x+clc7pYwaExXE5FPYHnyMlyW1LqEzZcNZJFfyLoTnQtTrsfnaID9DKenkCkxgztdEd
	TmM7gsRPEuiEtKIil/itYUezcu3ofMTyfxXI87R/YOZgujL7cpJejPyOUGFdfr4S8yI54N
	LLDIW631JpKW8je93y/TsmqgaPZ+hGM=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WOw8DVYS;
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786469745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwkanNiJJOt3W9zGrZeGCByYdRnaM6Axwx+xtbIB3o4=;
	b=UBHeQuoythwtUyeVmSc/r76WX+PT+X2WGpHlM/haArCdcEh2P+uJ6mtwlxcdND12nN7BfA
	e1ELpLa3cVS8BWfMVVh1Ya1GrxyY+itYAQv4ZxbnOkQEhGF2cP4Y0ZM5tElbHJxdt8vQ6t
	wygOug+OSZiTxGpwNMVO3ciWIKEZ1S8=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8485ef63b68so236444b3a.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:35:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786469744; cv=none;
        d=google.com; s=arc-20260327;
        b=DqJ254WFEo1asHcQa/ChTHpAnQ1jbVfn6slXucANOT/30i1/UPn+gfugKGjQpwwm1t
         YxRsUzWxRWFNCs0JvIo47DoF37To4P0qtYObrOBtlpAWRSOUsA1CqSiUn7OiQvNIl09S
         oR/l5UO++x3pqPhWJwxhWsWv0igHBvxSdoL7vGXkAHDwiRFTGcKJlSVT3Vzo8JhuX6Vd
         aBntI3ppKKyj0jwDAIVrufg+lJ0BsEkcKcKjdj3YOOYbhmkKzX8lXSoOtD63CKROq5Lb
         OqSBE++KivNcHJJN3+RA4v1so5C/Xe92x/X2+WfKQyEOTZnPiRXVIpxDoWt4ol7TGOzN
         rfIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=gwkanNiJJOt3W9zGrZeGCByYdRnaM6Axwx+xtbIB3o4=;
        fh=foe9jP7p41mFYHIRenRUxr9vai97Ee0QLa6ev5GTn6o=;
        b=iS9ZqHx0McYXsYwZMT8KLrUZp+5fyUGK0xhY8NuOpa2FW+2Xvxh3WSEE1Dt4K9EqB7
         3GCE0+XpIzJffXTcQRxUcwiUtxQ0og9KXmpWlx4u0mQGl7fUsUTzbNkTsZcO3PwdmhRU
         VO4yz6fpMFjIEnr/d1ehbc5CjQl5vvuFQdWV3BWLkJ2OTISqCGL4ryzuVayXlS3w6ljq
         GTGDeQqxLiuQv8awjsL+XlI4iu6Zzi9fjjuInt3NvLn7l4sJcSZ1Id5to2z4z6ONu2fg
         gviCmKtUQ51ZjXVhsCg3tgyLyNHmjD45sjKN1jJHpZe0+yO0SIip4NIMZq9/s2KARwfO
         bQYA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786469744; x=1787074544; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gwkanNiJJOt3W9zGrZeGCByYdRnaM6Axwx+xtbIB3o4=;
        b=WOw8DVYS2eTRjK/qaoqP7JZTIO1EipPatzl0twhjzs2tpbKzTMj+S/8vQd1CSpSbxI
         ncbcxgabyP6pMH19bpiUOmFW47fZKVOw4AMRNNZr3tXbTK48xGy5Rk8SRFnVK2ESnfWJ
         j4dRiIb+6t68AA5IG5qZXv88kg07U21Gq10ap3nSU79uHKYbvUNWaFzwmeJhCTQwhcu9
         3ni4mVBwNvnHme/hm0kHRQjouhpRbcIh087V5Ay7DhIdW8r7qDTNex/pDdpti6u6Fkhd
         90kA2JwKcg5MPPy0Lnux0sOV+GpHcNy4bOTnJ6VNU7lIMCtDbd6yMR4TJa7LnSfIkCXJ
         z9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786469744; x=1787074544;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gwkanNiJJOt3W9zGrZeGCByYdRnaM6Axwx+xtbIB3o4=;
        b=ih/SNWKAVOUlaemZslVrCeSK4Lsr3EJcZqGSCxM3GXZNbhxyVpWanPKyyxJRdaHD6c
         Gh99vk7ahgqmgOeOvWSx/IyFNukt3+uqk28gLHAbLTyRiUgjY/zp3A7Tyo7q6zYLgfO9
         UbOH4FZWmALCtxLeG4QM1dBcVMIQ97vWQaR6e8H8ZJ7qWWHDhpVdVLtc8Dff6Js9H18f
         7UpghwUzIhEDs7tmCT5NjV/ZZW77219u5XTMPsxELuOqDQY32bHHs3uBv897mjZCra5Y
         ID8Fi2GkSoBIIyv0f+OfVhhmDU66hnar8nPBuAcdfvLBfWhKYYIQslzkbIGshcHg2shH
         t4uA==
X-Forwarded-Encrypted: i=1; AHgh+RrSI92IjNtJDdn/HGuSmtQbnk1tLOAMrdwEpai6Pj4ktla+JtM9FffL8uxmzgoaBnZuMBZFxek49w==@kvack.org
X-Gm-Message-State: AOJu0YwxUqkWLrw8/XDZ6DyVi2Gur+UlBs7YoxgIf0ITQfcwKaVw0W/O
	ECkfWOnDpTqjVwLlwtNVf3EZvYtKJvWuADIAOxMtkrvv+bGM56H6GBDTiNNzp4Q2bqXFwnXJem6
	1ovLer1w18K3Dt48cLyxBsfFnQTIFd7RxNodW23h0
X-Gm-Gg: AR+sD119KNezX5oosO/34pwz/f5wJj9HjDfX/yhADYIe32VAQQSvwlTIpZQYcEgIEv3
	2NLd53dZS/itlqAss/VkRul5kT0qcFbwa+1oisLfNKjufeoCcEy3Fa9rWzj7KCMuBa1LafrumKa
	7cfC3M+JI1qLt3IWeyDPK1kaeczOPcry2bgK8cHoEh4zBrBBXhicQL2wi4xozv/RvQGLI2/MRyq
	g3GvXK0QfIlP2MtJ5DzWuV1pr8AK+0C7v0HcOdP4GhZWEa0mSeIqVXCzwjSAcB9g4xSvv1qhi5r
	Jw5VMPg9ZFLQwKdFKFW3C6mHRt4n88mWvgSD/TIlpJaPRHqX/8wMFYNq6GTg3dgUh1eHS4P6X9O
	UYpNMKt6UTJU04NG7SymQ4Bogxc8XslJ3fGHoUPbrsiOggA==
X-Received: by 2002:a05:6a20:9146:b0:3b4:9171:2573 with SMTP id
 adf61e73a8af0-3cc37e9e740mr1534763637.37.1786469743361; Tue, 11 Aug 2026
 10:35:43 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 11 Aug 2026 10:35:42 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 11 Aug 2026 10:35:42 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
 <anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com> <anj2bPrGqzZgZWMF@yzhao56-desk.sh.intel.com>
 <CAEvNRgFzRj_=GVy8T4P8ehhQjYomYxkngzwtKBF0iEL0Cv6fuQ@mail.gmail.com>
 <anp1I64K0KeyQuyo@yzhao56-desk.sh.intel.com> <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
 <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Date: Tue, 11 Aug 2026 10:35:42 -0700
X-Gm-Features: AUfX_mzVH_IxH_llFqF_n5qSatkkY6boTgbwv62Y4hoT6hGdHCS9TGJ6hA5mdxs
Message-ID: <CAEvNRgGWDY_fxbyBM-5sMdYMevMe0HzVP9kbC1cCGLE_dV=_Gw@mail.gmail.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8658320008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: z18auaebdo7nmwhxo8e1c34a648d6a9e
X-HE-Tag: 1786469745-715416
X-HE-Meta: U2FsdGVkX189KpCntkXL7ozuWgyT6knmabeR09LjljM7qKIU09eBQzdCDgeYlPydj32Ee+tea+EBdQA93mAsE4UYdVKIlkAy5yUoMsgYlhRu14NF/rU1g9e1eMo0V7619bNkQr8l7uiqcWw3Xgpg6jggfXVBNsStqpQWEIuKxrfBZ1d8N0gYGs7u/b5c8jJx0xmGENbVM2IvL8C8OrDfRzDAPc/Ech29wg5PQVmgYOfCVTOjhdPO1tyUle/CBrsaLp/QoC3ki7/Kz8WbbEpV2FOr9TYe6h4YJVJf6AmrXzGJa3DqgWeqsp5dFhElIZ1269dxjQ/UyWFg/DkMz1qvpAw5MJmAqG15Nw6MOhyqnBlA/pxSLuap34uTwnzGNroXwE1ufwCKdyNop2LRWx7wU/YR41rJYIs+q3d7YAW7ZZwpD0Z6SPHHGiSNIokyibnTwr3Qo4Q5KGWJDmfL+Bp4r7vm1EEyvhke+b+qtEPuZtn3w7iEZdp2XOkqoiW5Wp53ZWAJi7OxxL4Nin6osbDU8j1eVZdzJ1hTlER9xumNoU6Ffr2jVgQyNYkJhBg+ZwGT86CTT1X/o5h+tFyJCTVHwvf9CROKKhd+PmkHBWwAVQOHQYVRssLJfB2AkfTVVmHPsX52frPJt/AWMwbky9RzvbU0yUm2BDsN8ay9kCTTfXSnUYCZnH3stk3zC7UsZR6I6U/g6/cG6c6wyie++a5YGOGdKqoC6vm+b4rFIaKSz1/kCq3uUk9RrA1sfVWa4ZnS/kM962rfkUZntbvYi+H+M76B828FvIr0PqgPD5NceqPWDWgnh8mRKowzbtBZn08tZ+jSMP5QtKJI/o2APjauANt6gdZ3B87d/Qjq94qaOS1J9ZU3SbVxMc7af1kmIFBrRQKWCsv7pTuau6oM3SR+aTWfH4/I5K0tXBcJc2wpJhJPWAP0PpMgD4CDvmlsJ27E/yAvQ5r5UdwmQbeV0N7
 noaqTxAz
 AckhaJ0+qUV4+EV9VTMY4HnJOzJITIlQXPXqz8QX7zVkH4O6R7AJKpByMe4GRsOZssyQaiXImWd38u36N13SO6MXTDvMbAqXWeO0ViWbW8RyX+lPdEYtwdvE1c1CJFWIanC1VABllyclGwywtq0+18L3awy5msbfnLGy9z5RI4SEwHZYjFnbj6ma3q9llUTLzGIdI0Y9KAPSVjCp2UpK0tEB3Sw0xpOayhX+xSjr66xUmjMeYUFm4JcxlQiWQEpzn9SxOhV0iWzOw/tRAuSoBy8rvHvDIWcCE7BGVdwGEdFV4Ckn3Do2e4gbtBqHSqaF0V9Iz4ytDSPJd0HaOBWZ6pItdFaHyAgqUGexqewkJhsrgo5sGTk4jUE4ydgPLaJ8TvqLn0wLQC7+8nyrsD+Dx80JDQbiCdB6h5Xsq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Mon, Aug 10, 2026 at 07:17:11PM -0700, Ackerley Tng wrote:
>> Yan Zhao <yan.y.zhao@intel.com> writes:
>>
>> > On Mon, Aug 10, 2026 at 02:06:06PM -0700, Ackerley Tng wrote:
>> >> Yan Zhao <yan.y.zhao@intel.com> writes:
>> >>
>> >> >
>> >> > [...snip...]
>> >> >
>> >> >> > @@ -542,8 +576,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>> >> >> >
>> >> >> >  	mas_init(&mas, mt, start);
>> >> >> >  	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
>> >> >> > -	if (r)
>> >> >> > +	if (r) {
>> >> >> > +		*err_index = start;
>> >> >> >  		goto out;
>> >> >> > +	}
>> >> >> > +
>> >> >> > +	if (to_private) {
>> >> >> > +		unmap_mapping_pages(mapping, start, nr_pages, false);
>> >> >> > +
>> >> >> > +		if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
>> >> >> > +						     err_index)) {
>> >> >> Note: conversion failures could occur if another vCPU is attempting to map a GFN
>> >> >> within this range.
>> >> >>
>> >> >> CPU 0 (setting attributes)          CPU 1 (attempting to map)
>> >> >> --------------------------          --------------------
>> >> >>                                  A: mmu_invalidate_retry_gfn_unsafe
>> >> >>                                     filemap_invalidate_lock_shared
>> >> >>                                     __kvm_gmem_get_pfn ==> folio refcount++
>> >> >>                                     filemap_invalidate_unlock_shared
>> >> >>
>> >> >> filemap_invalidate_lock
>> >> >> filemap_get_folios
>> >> >> check folio_ref_count(folio) ==> Not match !!
>> >> >> filemap_invalidate_unlock
>> >> >>
>> >> >>                                  B: read_lock(&vcpu->kvm->mmu_lock);
>> >> >>                                     is_page_fault_stale
>> >> >>                                     kvm_mmu_finish_page_fault ==>folio recount--
>> >> >> 				    read_unlock(&vcpu->kvm->mmu_lock);
>> >> >>
>> >> >>
>> >>
>> >> Thanks for reporting this!
>> >>
>> >> >> Retrying in kvm_gmem_is_safe_for_conversion() or moving the invocation of
>> >> >> kvm_mmu_invalidate_start() + kvm_mmu_invalidate_range_add() to an earlier
>> >> >> position does not help as long as CPU 1 stays at stage A.
>> >> >>
>> >>
>> >> IIUC CPU 1 isn't blocked by a conversion so stages A and B should
>> >> complete fine, and CPU 0 would already be retrying for other reasons
>> >> anyway, like speculative refcounts from elsewhere in the kernel, so the
>> >> conversion would take longer but it'd work out.
>> >>
>> >> Is that understanding right, that this doesn't completely break
>> >> conversions?
>> > It depends on the timing. The max retry count cannot be expected under unlucky
>> > conditions.
>> >
>> >> >> So, should we avoid this failure?
>> >> >> e.g., by moving filemap_invalidate_unlock_shared() from stage A to after
>> >> >> stage B?
>> >>
>> >> Not really sure about this, how will control go back to guest_memfd
>> >> after the fault finishes for guest_memfd to unlock the filemap?
>> > I don't understand your question. But I find this solution is less ideal than my
>> > below proposal.
>> >
>>
>> When kvm_gmem_get_pfn() is called from kvm_mmu_faultin_pfn_gmem(), KVM
>> MMU takes over from there, there isn't another call when KVM MMU
>> finishes mapping the page into the stage 2 page tables back into
>> guest_memfd.
>>
>> After stage B, how is filemap_invalidate_unlock_shared() going to be
>> called? Do you mean filemap_invalidate_unlock_shared(folio->mapping)?
> Something like this. However, since this would cause the shared filemap
> invalidate lock to be held longer, conversions may have to wait for any on-going
> faults regardless of the GFN range, which I don't quite like.
>
>> I think filemap_invalidate_unlock_shared(folio->mapping) is a little
>> asymmetric...
>>
>> >> > Or what about having KVM always treat gmem page as non-refcounted, and have
>> >> > kvm_gmem_get_pfn() put folio refcount before releasing the filemap invalidate
>> >> > lock?
>> >> > Below patch is applied and tested at the end of this series.
>> >> >
>> >> > From 8c2f29bc15bceb6a8fa103cf2585ec11354fd74e Mon Sep 17 00:00:00 2001
>> >> > From: Yan Zhao <yan.y.zhao@intel.com>
>> >> > Date: Mon, 10 Aug 2026 06:24:52 +0800
>> >> > Subject: [PATCH] KVM: guest_memfd: Return gmem page as non-refcounted
>> >> >
>> >> > Have kvm_gmem_get_pfn() put gmem page refcount before releasing filemap
>> >> > invalidate lock and return the gmem page as non-refcounted. This avoids
>> >> > gmem memory attribute conversion failure caused by temporarily holding gmem
>> >> > page after faulting and before completing mapping.
>> >> >
>> >> > guest_memfd always holds gmem page in filemap cache. TDX does not increment
>> >> > gmem page refcount when having gmem pages mapped in S-EPT. Additionally,
>> >> > as gmem pages are not swappable, setting dirty or accessed bit is not
>> >> > necessary. Therefore, there's no need to treat gmem pages as refcounted
>> >> > pages.
>> >> >
>> >> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>> >> > ---
>> >> >  virt/kvm/guest_memfd.c | 5 ++---
>> >> >  1 file changed, 2 insertions(+), 3 deletions(-)
>> >> >
>> >> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> >> > index 2115e73e455a..e357b4ffa777 100644
>> >> > --- a/virt/kvm/guest_memfd.c
>> >> > +++ b/virt/kvm/guest_memfd.c
>> >> > @@ -1332,11 +1332,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >> >  #endif
>> >> >
>> >> >  	folio_unlock(folio);
>> >> > +	folio_put(folio);
>> >> >
>> >> >  	if (!r)
>> >> > -		*page = folio_file_page(folio, index);
>> >> > -	else
>> >> > -		folio_put(folio);
>> >> > +		*page = NULL;
>> >> >
>> >> >  out:
>> >> >  	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
>> >> > --
>> >> > 2.43.2
>> >>
>> >> Hmm going with the above CPU 0 and 1 illustration, if instead CPU 0
>> >> truncates the folio and the folio ends up being freed, then KVM's MMU
>> >> has a pointer to a page that is already
>> >> freed. kvm_release_faultin_page() is passed the pointer to this page and
>> >> will dereference the page.
>> > Not really. It's just like KVM mapping non-refcounted pages.
>> > kvm_release_faultin_page() does not access the non-refcounted pages.
>> > The invalidate protocol also ensures no mapping of stale pfn.
>> >
>> > As below, if CPU 0 truncates the folio, it needs to hold filemap invalidate lock,
>> > add KVM mmu invalidate range, hold mmu_lock, zap KVM mappings before the
>> > truncation.
>> >
>> >
>> > CPU 0                                      CPU 1
>> > -----                                    --------
>> >                                          Save fault->mmu_seq
>> >
>> >                                      B1. filemap_invalidate_lock_shared
>> >                                          __kvm_gmem_get_pfn
>> >                                          folio_put
>> >                                          filemap_invalidate_unlock_shared
>> >
>> > 				     B2. read_lock
>> >                                          is_page_fault_stale
>> >
>> >                                      B3. kvm_tdp_mmu_map
>> >                                      B4. kvm_mmu_finish_page_fault
>> >                                          read_unlock
>> > A1. filemap_invalidate_lock
>> >     kvm_gmem_invalidate_start
>> >
>> > A2. write_lock
>> >     zap KVM MMU
>> >     write_unlock
>> >     truncate
>> >
>> > A3. kvm_gmem_invalidate_end
>> >     filemap_invalidate_unlock
>> >
>> >
>> > A1 occurs either before or after B1.
>> > 1) If A1 occurs before B1, B1 will find the correct pfn.
>> > 2) If A1 occurs after B1 and before B2,
>> >    a. if A2 is before B2, B2 must find the fault is stale, so it's fine.
>> >    b. if A2 is after B2, A2 must be after B4 as well. So, accessing stale pfn
>> >       in CPU 1 is fine.
>> > 3) If A1 occurs after B2 and before B3,
>> > 4) If A1 occurs after B3 and before B4,
>> > 5) If A1 occurs after B4,
>> >    A2 must be after B4 (for 3-5 conditions).
>> >    So, accessing stale pfn in CPU 1 is fine.
>>
>> It's not about the stale PFN, if there's no refcount on the page
>> returned from B1, then after A3, the page can be freed.
>>
>> Contractually, I think KVM is allowed to reference the page?
>> kvm_release_page_clean() calls kvm_set_page_accessed() on the page
> In my patch, "*page = NULL;" is returned in kvm_gmem_get_pfn(). So,
> fault->refcounted_page is NULL. With it, kvm_release_faultin_page() does
> not access the faultin PFN or the page.
> So, no worry about UAF.
>

Oh sorry, I missed that. I did see *page = NULL but I didn't connect the
dots.

Wait but in the above trace, if CPU 1 got the page correctly, wouldnt it
take the !r branch where page is not set to NULL? It's only later that
CPU 0 truncates the page, but by that time KVM MMU already holds a
non-NULL page pointer?

Unless on both branches guest_memfd just doesn't provide the page to KVM
MMU?

>> (UAF?). Not sure which other KVM architectures reference the struct page
>> itself. Are we going to teach the rest of KVM to not reference and not
>> do kvm_release_page_*?
> It's just like how KVM maps non-refcounted pages.
> And guest_memfd actually asks consumers (like TDX) not to take page refcount.
> __kvm_gmem_populate() also puts the folio refcount before invoking
> filemap_invalidate_unlock().
>

I guess long term this is what guest_memfd would like, that KVM should
just be getting PFNs from guest_memfd.

>> Would like to see what Sean thinks of this. Either way, is it okay to
>> follow up after conversions lands?
> Let's see what Sean thinks of this :)
> I raised this because the issue was encountered by one TDX's stress selftest.

Which stress selftest is this? I can try running this on my side too.

> I have no strong opinion on whether it should be fixed after this series lands.
> But the fix I proposed is quite small :)

Small code change, big implications! Might be nice to have this for the
future where guest_memfd no longer hands out pages.

