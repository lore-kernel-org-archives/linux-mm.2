Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32229F8FA90
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 16:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53EC26B0005; Tue, 21 Apr 2026 12:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0A76B0089; Tue, 21 Apr 2026 12:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DEEA6B008A; Tue, 21 Apr 2026 12:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BFEF6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:36:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2C3F1A0B58
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:36:49 +0000 (UTC)
X-FDA: 84683116938.02.728B2FE
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id 087BDC0013
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:36:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=imOVadVo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3nqfnaQYKCOEVHDQMFJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3nqfnaQYKCOEVHDQMFJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776789408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIUrNdIXF/OzM+8I4bF+3IsDchXtCAl73sYtHCgqt6w=;
	b=mp01JTCybYp5lq6JV3rqMiAQRKbZWABs77CuXKZ8CkviTx+SgGjIb6M2fr18mmbooRWDzx
	N4CpC1vXVeAMqszgSwn3LGE3KJKtJpiF+HGK/02gBuRL9cbU/mLjO4fZIKL+h6eG0C7bbJ
	2+2k260xHWRsku3XucdGn+tWttHBlPQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=imOVadVo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3nqfnaQYKCOEVHDQMFJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3nqfnaQYKCOEVHDQMFJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--seanjc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776789408; a=rsa-sha256;
	cv=none;
	b=wuIOt4BpIVOPuFVxX6t6zWRNKH/J04AtUJqHmldQoPJb/Hu0jLaxrJMQ6e7pb87AkraVI2
	L8A7t5gDUJWyO9bt6BrF8CGUWMayBOaxAkp4RL3pcB3Q4O660YifSqK0o708pknz0vpecJ
	G4HGa1Ienf6eatA7cS62jyHWTq3zgO8=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8230d6d54a5so3885231b3a.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776789407; x=1777394207; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wIUrNdIXF/OzM+8I4bF+3IsDchXtCAl73sYtHCgqt6w=;
        b=imOVadVoqOJhBsPWGwCNbGqBdioxGoSvjFzECwJA4wSyYFwBe97fWW1WMS9NH6m/U+
         ice6Vk997sPNqycYcpi8b4LDneigXupI1gpqgvGkLrmSU+V1j2BxqcZNRNS3QRyUjCV7
         RYdkzfWfuTWlARWsGhnQzpjYqWf2i43Cc6dGvn3YVRvijbJ6nmHZqs9Df63HvNWFHw+o
         rDRiycL+GjDpBzFFi3xqIZIzvfEVuhMkwakD8KWX/scmTPoEmBR/EmcyLqC2odAs878E
         asZYM88XHtYfGnc5RQihPbNRFlpBkPxhrZQhwSrtFWWkM2Wc4ZKmhFLOAAtx+UeiAk8a
         MTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776789407; x=1777394207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wIUrNdIXF/OzM+8I4bF+3IsDchXtCAl73sYtHCgqt6w=;
        b=E1eoWOsDUqv4mambdAwQrqalwKwFxjJRAyG33k45QGwnTPVk5A44BfV6uSb/o7mLmy
         ydMxOwcQ7aa2Mub620wcd5CikxyTAvluenn9KklIgE876+7175qwEEpY53HhW/SFYNDr
         DcQKCZhDatWoBB76o6mkE6IkEAWaZHKl8zekXxUxkzszaWkMz5c9Ua969IrMEouRd9aO
         k7KV225MHfKXozkoWFX342Cl/e4p+7wBKunAgK4zC9t2i8D5bS1YTY1RqSYjZwE4s5eb
         c1M+/+JnqXxJyCeL5mts5Rvca4B8Dbx0t0UZN/gyhGg40oBM6ufQdi26hHUSMX44U7A3
         1zzw==
X-Forwarded-Encrypted: i=1; AFNElJ+NNW78o2bweXI0UDgXx4GWu5PlvkW01q2z9kTr+rAKl4cD9OPnuGrh0rhr4nZhErNvdigWv2nifw==@kvack.org
X-Gm-Message-State: AOJu0YxbCpcSTVLN0Jvvbj1dEJd9wtrgoMA+CX660uRQ4CWQvcd6Sims
	SWH7Rzqg6WmdJ3Qs5yfzNoydRAXBadzRBFJxkCE0N0FOS2tidWXWuOTyioo0RWH3lyamXvkEemP
	xuAMhiA==
X-Received: from pfde6.prod.google.com ([2002:aa7:8c46:0:b0:82f:20ed:8059])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a247:b0:82c:1cd0:2f7e
 with SMTP id d2e1a72fcca58-82f8b553974mr14884576b3a.20.1776789406330; Tue, 21
 Apr 2026 09:36:46 -0700 (PDT)
Date: Tue, 21 Apr 2026 09:36:45 -0700
In-Reply-To: <aed88qcV6PjEIHnd@lucifer>
Mime-Version: 1.0
References: <20260410151746.61150-1-kalyazin@amazon.com> <aed88qcV6PjEIHnd@lucifer>
Message-ID: <aeennZlV60k81OBf@google.com>
Subject: Re: [PATCH v12 00/16] Direct Map Removal Support for guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nikita Kalyazin <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
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
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
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
	"coxu@redhat.com" <coxu@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com" <tabba@google.com>, 
	"prsampat@amd.com" <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>, 
	"pavel@kernel.org" <pavel@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>, 
	"yangyicong@hisilicon.com" <yangyicong@hisilicon.com>, "vannapurve@google.com" <vannapurve@google.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	Jack Thomson <jackabt@amazon.co.uk>, Takahiro Itazuri <itazur@amazon.co.uk>, 
	Derek Manwaring <derekmn@amazon.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 087BDC0013
X-Stat-Signature: jpcreetpnzt6cu8cpia61cn7ej5h6gqt
X-HE-Tag: 1776789407-466150
X-HE-Meta: U2FsdGVkX19beIsFq55To7FaGtLYqCsADr8+jJWjJZXMk5quThizhNxBmUKknt6/mdXOWmlCLL0PIngSThrJBjZXhbHWgX73wHFRLQx1ovh5kMpAgQLH/uF3HGlJgRfkIgsvcaAvSIL+Wf+tYQXelF2PrbUTHe1GDnY7Ob9tileG3CViUKluZQ/VcZqtzczuCYX1QgI7c4rIeuNSTuOA/HfEgnExowUoRQqgclSv+HPpWV1+cq9UQ/PT0JhITwQPGgn87jLBaHJVRThBWsO9EuYFrAsL8Jt7C3ug5YbRIFXaEarvxR5eJzLsltEkuV1U3T+YARRwmAxTDHtp0SzcOsReC4/cM4L8V5HsE9mTk9Zij+TVo+kJwc1kJSfdq8bKsy8m8R+PbiOdB6/DVAbHstJy1Snp7yPEYLq4Iqvxn5t3naI/WdBwUXg1PqqBXUfSrw8s8x6Y3DCyfxDB2/yzM3S3qT204OX64wdwX1ivMR0obDHu8w2KGsiUz8XkVAfSFzykCEw5ySKlb0kjpkpdTEPxW1Jjo/Ery/Dos2yIHw/IrftNRhzA5ZJhfphWB/xzkwhN2TVCiB9Pu5oCJ1iJzfhNFp1VAmBT1diAAl+zr2dwAwjkJ5y5dJnFmt6ZXA09z7oP0Vfc1ErAkP0vgX4dTnNu5GRA6Paq45BbmHn1aPpBKF6bzvV856N6iNa9E4xYtkSmSOxh3trZSxeTvqVFdVHyupAhkYWA0s/RIXQCzaVviW1K/ltOPdcS9Iz7fT6Ck79l+kJh7DBrx7pt0JWXjh3yFUye+4D+laD0ZqojPvKEq6BdCLL/lOEXCl4REkwyveszCux16qteWapCHqyPr8tHIZz62uYftuNz42t3YIkh5p2UbVk0FiV6V+yK2FflHAyT/HXwl4NVs6Em3V+186xzmuklfEZzGMUjbB++cF8jyW2EF/vP5XkJnO6m1P+7nvDCPK/1qb2rbUc4ajo
 xQvWSnAH
 FVLt6lJPBc6cQXIJ3HmFiyxCdwp3jk1K4T+PFZFx/u9Yus3oqNGAOvjdXw053one30YT5a/nt4LHG0epYJVP6PeGMJ51jZST0hpnJ5cPHYVTGBiTT9BvewqN0LoYt1DcNOSM95dYp8yww02aryCohMpiGUlffu/M+lAn9flAXja/nvbtA1ud6obNr7/BBmla1EZFcxA1g7cYIVnsqqNIz/A6UUg0E6gD9T79w6fR7sHxEOSLN2zA+1PGaySgPiR6JGITuwGUD1AJkNaQbAd4OudHdJg0KkiIAlv41sXzA850ZE5PSEgSg0n+jY6283t/tBFKNRvU4yRKkVBUgbJnHF5pjO3wWgpW+ZU8VIHMEcB6/ku76S9uA/D1Rl/EebUMqLJnfbzclafCjSS9Xs1kS/jBDreiFO8pFnvqwRCGUOCbWb/WMap0w57QiIfdCziQURa9wndM4xvIJfyUQAgkPp2DKZKcREY46K0dICltOHAG/ZoVQiZCAo+GTMltNpoaWYkBWDoOB2yVpEWLoHVJD6nUx+untKxxShHCVf+0FgRGlGqCYFqDZ+12WB6+aGJw8LDeNdq96TqnkxhttAwoucKsS77LHAVdT8cY/DzxqZdzqnmqXuVXWf8xEfWewIvIYAug5L4u0WGNEQiflndoS3WDbpLfFHWPTY8gMH7yoQ8OD0xwlKt2p1hhqkH8pfr5fzfUJhQqH1ke01sMcXNuZp/pQ1Xl3iKuLXfLEu7mR0bnHg+98DMZFDHqGwvC3n6ZfuZCTSzrsctOz9bCpQuH8irjyFlkovDsJd5MHCT+knhVZF2VS2PE6IMKIG62h/CG4GmmoldqbeaiaS1kcbJIyHZzcvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026, Lorenzo Stoakes wrote:
> On Fri, Apr 10, 2026 at 03:17:47PM +0000, Kalyazin, Nikita wrote:
> > From: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> >
> > [ based on kvm/next ]
> 
> Hm, given this touches a fair bit of mm, I wonder if we shouldn't try to do this
> through the mm tree?

Yeah, when the time comes, the mm pieces definitely need to go through the mm
tree.  Ideally, I think this would be merged in two separate parts, with all mm
changes going through the mm tree, and then the KVM changes through the KVM tree
using a stable topic branch/tag from Andrew.

