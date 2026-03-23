Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47FDBD58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1956B008A; Mon, 23 Mar 2026 16:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72076B008C; Mon, 23 Mar 2026 16:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A446B0092; Mon, 23 Mar 2026 16:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 836FC6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:47:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34F628C6CC
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:47:20 +0000 (UTC)
X-FDA: 84578513040.07.C1AACB8
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2CBB2180008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:47:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=n5onNoLx;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774298838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yac1rrBqJSF3O+e4IwcngZ2ptSQxNGOfPE9KG9sOce8=;
	b=37D3jqdLxx/P77CimumOJSz7Awo4lV0xtE86yOo3x/Qg7iNXm4dP+VmAfSt0xh0BAt+qr9
	FFoYuzueSsTAOmdpXtmz5La17Hab7J3JVLPsKyYfOveS0p9ftzTOs7eKH9Ikev10R5sCEJ
	J6/Cj5IqVUhEkgFGqyDhQaBMEPLtOG0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=n5onNoLx;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774298838; a=rsa-sha256;
	cv=pass;
	b=KP+knwZFaX+z5ZzYr2p4kxwU4x5DsXpZr6AS6+GRGx9nl1x26wvwBdhO46N4XpBnP2DzwV
	I2ShTBztTHgignAauihYF2+A5TExOy0uaIKG5fsCOa1iwUbe8PIkjXBHtquzNDfrCjo0lO
	UndEZOxFElJlePPT8THDPdVCinmS6+o=
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5ffabb1dfbaso375615137.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:47:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774298837; cv=none;
        d=google.com; s=arc-20240605;
        b=Dbm9Dw/+2SrQ8o9uIwGEbDUYmdqTt26EJCVuPxT80rm234BXxhnX9e20O/0rLAzr/R
         wVOW6iCGMSoRUxOcvcFW40lV5GwH5NXZ7sDa/8lhEnd5m8W6qnBNPBD4TcSehGr4O2ei
         Sf7pAPl4sAW21zy7c1oJGxEY4zTvCka9B+InP0QUOL0ooXgU/bjbDkM60f5nqcYziuJF
         wPCoWVJyezwVMVsYRK2cpE/yMY1zcc0KI+K1Q9yIud46STU5WuD7QRjcXLhRi/u5AYLX
         nE9qcsy3YFynjZKudb+WXmmjG348S1rjDGtaOoj1PGUrML2eQOXCHbV5mXhVBk7ZQfkk
         4DTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=yac1rrBqJSF3O+e4IwcngZ2ptSQxNGOfPE9KG9sOce8=;
        fh=h+Td2oc8pKR4/wGdDLZnYaA1BDrSZqSM1ORcBeJU9S8=;
        b=bh+TbcURW5leKDwkQpd/dgiWSqMKtH9+Tt5dTqVbu7Imq/MWdbQ+dxwaap7u20PXrt
         CMnecRP6uFg3in4rb1qGWCwwOzMKQg0hWxPFFusGqmGoYa8nQxiPNnZ2w8YCK3a6VG/u
         rdiT63UTGOq9AiPrpzlUeZUKg21N8UigvyQ7yzm0eqzC79qg0aaTFr0uSwgWd8Xqju5b
         1RIjYSFptzcuKKdCmRg+C7cdcQ9agyAo2kv9RcYXBfGXIahmX5pMB6XxiblxvUvglVFB
         3xW3ZXcb3RPpIZr48qyksDHVORiMHCQYscZ8y5/E+6Hyz2UT136O+tb7xkmRcRAlmkE1
         kkdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774298837; x=1774903637; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=yac1rrBqJSF3O+e4IwcngZ2ptSQxNGOfPE9KG9sOce8=;
        b=n5onNoLxNWtqIVz5zabBE1ofyW/ztL6uvrMINmf+XEC8/kChQ1xfEydIXKYd5G7QMx
         XroAr2qLFf/fyYMYMdUR5bNI+3y4x2XoCw++LvbeX8nfe3urT+iG5XKjL7khbVVJmVIL
         Ti9tn0JP3JzWj1MvHIhtCI1ugYiXH+e4PMBPWb6VRzufBV7w+suYcpdS+Zewq8rEHXCK
         1zkXmnaxPxDNT2wlsDxMVmToZmltrUyP9FYYJZZBqimEzbEG7M/uTVCKp3isGUjiJL3g
         QBQ9drCXUbkTsopKbQzf+VFG6Jm/+KQyUtYuaEAnfU2nLWVrkQ68n7j+D8JKXdSWRpfa
         JaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774298837; x=1774903637;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yac1rrBqJSF3O+e4IwcngZ2ptSQxNGOfPE9KG9sOce8=;
        b=LrTvK7roifCnbLQrJxWYHfSibVkb+Am6n8Kc41T2CQzbx6IL1al/umj8gz/2e+IJ8x
         OoFP+rRfUGUd/o2q8WuExpQ2aHavCUYALQkYLD6azLJFO7Xw0BdH5WRIiUCJbXSMHB1i
         G2InJZ/PHLdnwmCD7xYab1nwok09qD66CWc+TqYVjEYWX/aLzagZvJVarTDc3wguMNco
         bKLMYN4NavadPGy2XvspqT8RPEuwwj6pffEi4GJiCnVQuTfk1JO698/g5fiR/yYeWWOG
         WBkY/7JJ4bZrLsJKnb+TX+n6U4NXoYDf5ElrJffcjgFJyAI37sT1dvJ0IbbmQhQGVhoC
         lYeg==
X-Forwarded-Encrypted: i=1; AJvYcCVZDJ0t4GVV0pNfBIJLOyiT/jk7d+EmXTLOvcZdAT9b4cRigN4uo0/Z5zaEBn70mmvoqCzWyWGk1Q==@kvack.org
X-Gm-Message-State: AOJu0YwRKJmKtkKQWfdoV5tXH0F+DFryPACCoqpPxs7ouTw3a6Wji/Kz
	0gCoHIUEs9fI4Y34EPbgNyRHhx04+BWPmkyrXTucoNZO1v44E9L9Hz6hJvXa02FBCCEAS1BwoHs
	KZAeuImvafEpZ0+PYy39e+52ea/pCol7iFeboaKtw
X-Gm-Gg: ATEYQzwH8zPY+mYLYVOuYWBiZs9yMlo35iWt+LazAgjTmd15qHBlmjdG271cCxtBLW1
	BP7+94y6ir4wmNh+H6y77kXDe45ziShKrXc4GCmYJe0N2PvDtf9a2me6nX5vXY89ap9HHbsF4Qd
	1o73UwQadvUFz9F3lJHvq+NrMuzHfK67o7AV5ArB3IW5XexfvU9KP0bTCV1UPwjrPQJ25s2BVW8
	+qj5rXtBQPB8Vb/7oEDd5gJ5dUOsO+G+e7Uc/5J3m9hxD6pWLGQSgVunc8fP9bfOIzoLLCb05J0
	97qtFGxk5L7hUOp546mAI28v63QueLMlQ96temR1zX80JjHMAvaK2ZLQdxlwiy+rxG8G+A==
X-Received: by 2002:a05:6102:4a86:b0:5ef:ac78:3c77 with SMTP id
 ada2fe7eead31-602aecd2a05mr6404753137.18.1774298836454; Mon, 23 Mar 2026
 13:47:16 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 13:47:15 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 13:47:15 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <50bfaeb5-551e-403f-bd00-a7d8b6bbf6e2@kernel.org>
References: <20260317141031.514-1-kalyazin@amazon.com> <20260317141031.514-11-kalyazin@amazon.com>
 <50bfaeb5-551e-403f-bd00-a7d8b6bbf6e2@kernel.org>
MIME-Version: 1.0
Date: Mon, 23 Mar 2026 13:47:15 -0700
X-Gm-Features: AQROBzB7NM0e-Hubu0XRJL2ihJNatUocmuhRQlqLx8a7dgTL41taW0scozymRvQ
Message-ID: <CAEvNRgEXp6busURR20cazeG2DQWdU5=ZaJv21OcSq+mhVKwJ4g@mail.gmail.com>
Subject: Re: [PATCH v11 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com" <tabba@google.com>, 
	"prsampat@amd.com" <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>, 
	"osalvador@suse.de" <osalvador@suse.de>, "pavel@kernel.org" <pavel@kernel.org>, 
	"rafael@kernel.org" <rafael@kernel.org>, "vannapurve@google.com" <vannapurve@google.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2CBB2180008
X-Stat-Signature: sidifjhqktdg9gk4bhbcibgwynbi7cxe
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774298838-466143
X-HE-Meta: U2FsdGVkX1/RsnUmw0b4HyxX6qWH7wCurFocOZk6opL+UeIAbwBpZ/qxtwyuhVABZg++fJgWv1D3fRAjEEnPHxCAiHImCauwPI1G10zHFKY4GUKZ9G+sViDp8fVumUxC7SIv3c0Y18LCB1cZq6+IY6BjPPXgQ7lR/5PhqLJV72rm6sSk0243sE+S2t2yKcAu+bpPYZ1AowSwlnH1c03FFgtgSn1OComq/QaouQvATrhuWAB6nCtLzOX/jMKT47BoL6CKpz42xXc0ZF5h8yiKZ2iLXu8OFx9SMfaHPGQazJd7T8tN4YNbsaeRrVYpYjZl2ocpwxjQzDQ2Jhen+0Y7ybzRxwWvcSrv9+90KnFBTBC3ZubO/8/9BKNBw2yuYFjJvxm2MCvLgORIJnSVWSaZUrugq6zzSwX3GZhBpQV72yjc1yaxjzxP73sSCfm0oKUmV6wUkS6MFfBepnvo4pW56N5WAdNMV7p4saMcJBECpQ5CfmmidnhN5nO3/pcNlM4sOJVPUi4nkKnpU+i5ZpLb0l8iHP0xqfBhN8SC6bVMZVKwmj4ZlJGrBl1o123nP956Czs8kl2IiZSi7btb2EJeiOM5lhfVGaZHdqq8YDMAPQ2vkpoVjZ9nPcmp+GH3xc1pJOoM0vD8vIwCY100LQ90y3fRH51KRb8rjgW5VSAM7CZiXxLJfdBeVLQixBacDi28Umrjf5QpHst79ZONnso8trKItpK52Qyr+51W5/lPpW8TvYvUJmaACVFriOa+AKwMwwW4KBkC6xG53y4/YOAgRF6xYJhNK/teuZIjfrobm8gfyArfLs3RVC7I+UdTVk5Yddli73EZ0G4G6Mz/PoQ6PTCMjLS9jCMBYAHsC+b6fpupJPF+qpUh286vMW7u5+nltJtpugoa6cHCGKdovFacybo4ySrB09By6ATW8mEav1b9KprV+Fut2TzHKlnlgA8gozorbpViDnJAGeRFOSc
 bkIo/Cun
 /UcpIk2Qw1wycxsXBGzERY88StBX9B1mcaSzs17qXi08E6vVyxPBGKZu4hA8INZBuM+ljMGHExdMLFkIIsf0Ghw5BRfn/rqdPv5zIG0uvkfL/kSlmv8wl2G4VL/Diwz9Z3z+EoMRvp0TE2CU0tbx2WzG+I2RcovL05BFeSu1vDwmog48/Njy/CagPnURumpdsZdJoUMJfw4PTvRREMXuUU4jXX70w5MByEM802XbGL2b6cu/sMKlX8NvpcTQMbw/cc5bKIY5W9OpI+T0atHZE/dKxpVeI50jAsmkTlh5w1AoBmNbgskPFkcx7C/UuFQwpI4P2e/UJvxz9qLhiFS3Zy8zbmbD9//yHnhQvQrRbTYI+lgNczy+1AANHcv+qLY+M7V5nj+QVFaL/CALQ0msr2i0s7FR0Y/0ZrORYxQ6p/t/O1pI5dI4hFFfTX8vzMW1JZHGkKYPlV/juvkBrhOuYoGAIXrDYQ8C7HLvPO2fZygeAznW12WdR9+HruInxOjUQfBlU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

>
> [...snip...]
>
>> +static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
>> +{
>> +	u64 gmem_flags = GMEM_I(folio_inode(folio))->flags;
>> +	int r = 0;
>> +
>> +	if (kvm_gmem_folio_no_direct_map(folio) || !(gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP))
>
> The function is only called when
>
> 	kvm_gmem_no_direct_map(folio_inode(folio))
>
> Does it really make sense to check for GUEST_MEMFD_FLAG_NO_DIRECT_MAP again?
>

Good point that GUEST_MEMFD_FLAG_NO_DIRECT_MAP was already checked in
the caller. I think we can drop this second check.

> If, at all, it should be a warning if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is
> not set?
>
> Further, kvm_gmem_folio_zap_direct_map() uses the folio lock to
> synchronize, right? Might be worth pointing that out somehow (e.g.,
> lockdep check if possible).
>
>> +		goto out;
>> +
>> +	r = folio_zap_direct_map(folio);
>> +	if (!r)
>> +		folio->private = (void *)((u64)folio->private | KVM_GMEM_FOLIO_NO_DIRECT_MAP);
>> +
>> +out:
>> +	return r;
>> +}
>> +
>> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
>> +{
>
> kvm_gmem_folio_zap_direct_map() is allowed to be called on folios that
> already have the directmap remove, kvm_gmem_folio_restore_direct_map()
> cannot be called if the directmap was already restored.
>

This inconsistency was probably introduced by my comments [1] (sorry!)

I think the inconsistency here is mostly because
kvm_gmem_folio_zap_direct_map() is called from two places but restore is
only called from one place :P

[1] https://lore.kernel.org/all/CAEvNRgEzVhEzr-3GWTsE7GSBsPdvVLq7WFEeLHzcmMe=R9S51w@mail.gmail.com/

> Should we make that more consistent?
>
>
> Hoping Sean can find some time to review
>
> --
> Cheers,
>
> David

