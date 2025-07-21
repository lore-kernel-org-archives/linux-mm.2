Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6184C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 19:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D52A6B007B; Mon, 21 Jul 2025 15:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086856B0089; Mon, 21 Jul 2025 15:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6EE6B008A; Mon, 21 Jul 2025 15:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA04E6B007B
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 15:46:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 844AFC019D
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:46:58 +0000 (UTC)
X-FDA: 83689304916.22.96DDFAF
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id B854E4000C
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:46:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CzX09phD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3L5l-aAYKCKYYKGTPIMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3L5l-aAYKCKYYKGTPIMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--seanjc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753127216; a=rsa-sha256;
	cv=none;
	b=1bQbaOgk+MJUT9r/mQzLdOeevMFwSexzCqk/eX1m7t+hodZ7ptrLDtaX+szp6xeSsM00Xe
	zzAwujqwQI8SjaXwslm81rHXuve0/gwYqW3WCu+8x4tXrGsiY6s1ukLqfRLk2hJLk4n3Ku
	DXTbwS8uYI/pINujLL5UnZ5eqwFzyD0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CzX09phD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3L5l-aAYKCKYYKGTPIMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3L5l-aAYKCKYYKGTPIMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753127216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAzCPpfQMz1gzK4so/oBZateRTf7Y7I8QQ8KelEOi7Y=;
	b=ZuoBXnwc2e+KGEwBNVKyn/M5fmimUO0YQztIS2u1plQgLznJrWmykwtn9IVu+bQYa5zT9H
	vn9ltjrJHtbDiF0dsCfKubpYXpWQLRFM8Ug/7nZXTjHU2CVsxDJngsiFtIqFa+kY8V/Rou
	AH68CCMpv1Q3PNf56qBJp/kWfyOOEy0=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31215090074so7042123a91.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 12:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753127215; x=1753732015; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eAzCPpfQMz1gzK4so/oBZateRTf7Y7I8QQ8KelEOi7Y=;
        b=CzX09phDiaaHDw7kv5ARkWE5ej/AbHK+KH5fxmbZkWW6o/GhqAggn2DIeKQOnNyxBT
         ebgM3PI4a6gnEa2jjZkkJAbpDoBQVmubbNA977xoUiTaEds2zIOJbVMSfRdipObJj4kD
         BP33RSsJZVKwQxSStaPs6tXPSgiXB+qdaCXO8SD/GTgcgTdGI30TNZxBq9KJoePC/Y2q
         rDi3FCcIR0XUk9IpQVZBbzd5wX/AYC4wrSuYLc+ExTa6RF0JDQMc5eFcu390z9GZJgPL
         gCLOTJ1WT9U6oK7guxqmfGHss0+eDn+iyKv9doy4vqP5hEn5xSa1YaS5jPMqUtrsrVTt
         uABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753127215; x=1753732015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eAzCPpfQMz1gzK4so/oBZateRTf7Y7I8QQ8KelEOi7Y=;
        b=qk1c4Nv3L0z4PG1k6zfJvEZbDmA70coZw2JimMHSl6qRrV9Rw9OKIU33t2YdoXxosn
         HqTLSH3j5ifb9BpXksWdVJnzyWMTYm13QUwHKvxYh6Oy7ioTU2O6FadPMKWWn6dje7lk
         GN0LqxbpcTOY7GYM5LX7CQTecrWDBGtZR7wAO4tdhAjd+cMuGW+aHdvP2fNbzTfyaFTC
         g83W2c9eap/5BbGoht/CoWlr+ExPMGTjPWBO+9rj1APFy77yNPUoUih8pi7W86OTOc4T
         pQxPOZCzj2CoZNpUMl5rfgc3DFEcuk8CukHB4S2WVSsPrPgfNuPURESQbrx31dG8e9il
         lICA==
X-Forwarded-Encrypted: i=1; AJvYcCVBqpBvWwRTFBlam52kkeOqEnf4rTfnQU5xUPlewRxNNd0WMNRwjpHhhg/+VW26IRMbqR85y9r34A==@kvack.org
X-Gm-Message-State: AOJu0YzdByL1b2jlkHlfzbf3R1x+EcfZiuMDQ1XcHJaE5OORy/FlSCH0
	VTPcFushTwn+ZxhdpWTsywE5B3fUgc/kRtHDbQcorziHEGW01iSVOTUao6n6LbDVRKVrN7KOl3o
	LmnWx0w==
X-Google-Smtp-Source: AGHT+IHCdTRyaZvpqo+/OPaDQY8r+AbasdEQ23wkQlt2bLrH8q67zZ1ProzQYNVQGguXSMigXOn343oEtxk=
X-Received: from pjbnw5.prod.google.com ([2002:a17:90b:2545:b0:313:17cf:434f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f91:b0:311:ea13:2e70
 with SMTP id 98e67ed59e1d1-31c9f3c612fmr34864736a91.14.1753127215555; Mon, 21
 Jul 2025 12:46:55 -0700 (PDT)
Date: Mon, 21 Jul 2025 12:46:53 -0700
In-Reply-To: <20250717162731.446579-11-tabba@google.com>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-11-tabba@google.com>
Message-ID: <aH6ZLYgwK0EdIERg@google.com>
Subject: Re: [PATCH v15 10/21] KVM: x86/mmu: Generalize private_max_mapping_level
 x86 op to max_mapping_level
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B854E4000C
X-Stat-Signature: 9irg38eu1q959ckrmboa86zwqkjiqh7i
X-HE-Tag: 1753127216-764618
X-HE-Meta: U2FsdGVkX18e6xeDrjGjoBwUnYZByPhkU+P+a16uB8LK6bZ32Qk2APw1s+eqsmb1S+tk3Ftjl95J0bk7+5mRqcMcHoLon6TZ4g8uFWRXEwmKrY9Tu5eVxSRSGgabcDZhCQa6uR48eY6NaAtpMN5Iaym5KEJc3iothR32N0U9zGRlnWbidGSeLryywxnIoH1YXNhfxstfa16DSAE2l+H2jNVZT0Pd4NnKQF81PdGUvkTahZ7IUI+MCsCvX+ku90Rt9FlSMKP3rkyY5mTL0qBuQZ592vxbdedOOivVFbg7neZmDlA8JzLU7IM3kH16jVAA16T6q2JkleBT0fiP+6tgWFTaYpVXAlqP9dT5FFCNl8YOWLR7oBE9ndRfyezhmvlqls5hTb+/ryo7t2A/CaQ4ObpdirCFlZWlLR7KeLnaMtyIP/5LzGw0p2pvVnOCf2Vq3kJ2d2ofWxpn2Pzx6RD7xc/WVrWCFXJs4qwX4q7D8I25zeeZxc2E6Q7G5DeWA32oNz8neHknZvoo7e9u1Fy9PwzU02+Vj/J8i03M1KqKhpCG6xwdZgIioe6njDU7uttPEtC/aqmtOeeLkdZi9ShwjCaysWxD3Qz3oRplxk0TSITHMLeYAONnHQjYJYY7IAtgH3pvrqz09hcgXxIxsF2CDWtbJ5WPkcPczUUkNmLl6sZth0LGJO2yk2dUXIP5pWztHvw5uHaMQ25pKneGQly4AZ5L1A4sSzja/mrnFS8K1M7LcRAvnpfRfK9q5YpVxJf9BDtC6DAAwrBUVrCxwFtyKl6ILzuY41s+SEZTgYiKHtyt70k+IbL3zFUO4dJ3A6ArEjeYE5//vH399S78D6cPqxPkErEFxSfe2okyLXuGHs2rLS7fypxy98y1oJkb1OUpX81pLtiPs1YYiBkIrSAYo8fuy96ucmFrJVgP6fJCIThUqIbr5UrNGtHfaKPbRFVtRsObCZqX9eJy3UKAESf
 kDAJinkh
 ThMUceTzdnOIBZ1q4EnElrItodKMgNrP7+cJlIpuySqb9wZd9EnMpxeHIuDyD9GF5NBAJeGjOj3k8TYTakqnHA5cmtB+N0tEJcFDNMvIzIIyhmGalVPfSEkAutOAkYBbawh4O+TtWAWR03RBb63TFTfougTIzQourTxqvTbDDvgcBY7sseMt+9OjBqtGp19wZXX+o1cSS8ry6AkmjFn2Itn3RppSgSC22NffjyV9siMFzb4+jaHzCKPZYheXgW/U5H2gYFDebC3nwD3tTqATZsK+pRZ/8e20UUBry2X7qcXATOuJhL6EQVl1bpVmmDmpI503A6kxEEwhT/ivk3wEZCufMAfyIE/Ii5YwEKM/mnVAn7LFLmZeChqJfTNWQoORdg5GmgTWpYOcfbhOsYWSR8IHOzKVLtY824vwVqN4yI34GbIt2eJWAoTCH/tMQAGQij1lfFipVj+SgJDCr2T38zs9VKSEFGKLHv/EHcOe4bPkHeppSKhVsAFXTLsNLsp/JGT5FeCmMXbHOt0oi/JPNrhiUs7gBrxa5RxxCEMeJQsD27W5yCBC43UJqc0hxIg0a2qwsIMNu7l0V+x0Mm5IQLMdMrRQtUQnxgySsPF03TLCGf7Yfa/x3TMZ9k+caeftuy6joMaEOLDk2mzR7FvcyZ8piCBJ16hUVDz32nOBcj39Hg6Yxfcvy+Yv3A0pLY71kCRC3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 17, 2025, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Generalize the private_max_mapping_level x86 operation to
> max_mapping_level.

No, this is wrong.  The "private" part can be dropped, but it must not be a fully
generic helper, it needs to be limited to gmem.  For mappings that follow the
primary MMU, the primary MMU is the single source of truth.  It's not just a
nitpick, I got royally confused by the name when looking at the next patch.

s/private_max_mapping_level/gmem_max_mapping_level and we're good.

