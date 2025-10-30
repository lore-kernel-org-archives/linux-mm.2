Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55315CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 17:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0F08E014D; Thu, 30 Oct 2025 13:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881B78E0089; Thu, 30 Oct 2025 13:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749D78E014D; Thu, 30 Oct 2025 13:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60CF88E0089
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:18:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E390160212
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:18:36 +0000 (UTC)
X-FDA: 84055439832.21.ADD390F
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8662D100005
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:18:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ni0dRiKy;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 36J0DaQgKCIEofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=36J0DaQgKCIEofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761844714; a=rsa-sha256;
	cv=none;
	b=rr/eE6/uD/+orertqcPQDJCVHWoPeSg2RZSKfwQydz8e+OxT8jZ+8fOCt7pj9Vo3ZS8GYP
	fEl2US7Q8TJ31ENxKL5hDfoyngPxtNGo2HCPA7RHH54Y2BUeuwdqbnQiDqTpsNz1iCp3YG
	322+Y7ImdahMSBLD3TVWmxLG7clfBcw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ni0dRiKy;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 36J0DaQgKCIEofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=36J0DaQgKCIEofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761844714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zIsYr/NZ5vBEDYePNHV7frUHCwl+Wvsd8lZxHFgSTA=;
	b=FLHAkPsbLG5gzyyosY7hMuHPmkDXr1Ra900eN77Axc++4e/2bqVFKUX/eneY5xnwgmeXJ+
	ERyEMxKo79zRj7UdOUjG0Y89IWLSIYYmLfVfwlpNxm3oXs8R77xJFbClxrq9+rB1NMKrPD
	oda0E5qjYtmPoOPWCASF7xWDCGHgbIk=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-475ddd57999so9824925e9.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761844713; x=1762449513; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0zIsYr/NZ5vBEDYePNHV7frUHCwl+Wvsd8lZxHFgSTA=;
        b=Ni0dRiKyYHzhhN7MNyOYpFeij6wHo3e/DxNsyGDzR8sBmNffTHQitunGjkLwfj3Bvm
         taQw/VCgHLeS4UH4D+h4t+D3vmK8573CGeQTY0VdeP93TFtoIqsaZfCV3tzaAbZ/FZpy
         j1+cLL766KjBvVGhaWdps/iNNEvwN18ypJhDKAGTd6CFT/Ggkmn29IP5yf7u+lzOIr6O
         IvGg1O1Lx+pfvNWO4EEze4ADjzANBMPwxKjgC15dB2+Tx5mDBDDhDEdhNLhbcZfH5I1M
         921kjdq/6EsTuyGtmGQGu3AIylAlAyIX87qnHCsSSJRkWHaZolRRJ+0cRUDcPRd1a9wz
         Ljsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761844713; x=1762449513;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0zIsYr/NZ5vBEDYePNHV7frUHCwl+Wvsd8lZxHFgSTA=;
        b=t2vmD0jj70mRXCWW6EVw7dXdUJa6G3Mwsm81GPQHmBAJb3myijHebLRSowQ0FE6dQo
         6tXg8wkw2gK9cOEcX84cy4bQe1m7z34rdWdR3p6OBtMRh3HHzaUj1Xa4EfgdTVeio2DG
         otJ0OyZaRWsSw/OgA51D4Rp4ZCuqJfOmGmqgD19FVmGXiqDvoKFdJu4qkBkWoOPx+SY6
         +GQ89RLXEf31htstcZmP6TOpGGvxXFqCX5W6kUDxqmlqhoqvW0b3Yp30/rD51r+6xCnF
         I54U7EmC0v3p2vCfDeCdd49Y4yOAoHhO3oUv2480LIjWhyDuAaKlFw0OZkd++K3RgTC3
         p4sQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5aEIJrbJWvgsPZotc0g36wHV7PZjJIPpdEMfsVETUd8nnL8nOmQxL9ezAmKpv1L0WKF7p6LskHQ==@kvack.org
X-Gm-Message-State: AOJu0YwBAjvvpTjdhjs2XO0Ui7WK9VPF9hI9MipBQGTxA/6R2wCu0By1
	IUFruPEXkZ25JpsGexdalpr/VilD5UPbqIgU+8Y7i6vVPwfp4UlvMbg4mVixckF1+GyuNrrf7pP
	z6nbXFKyiMp0P+g==
X-Google-Smtp-Source: AGHT+IFXk6DKJ2LvWY2ZBOreY5EWyiD1FLIIWcEezkT9L8CiZAonL3OXc94rN18lwM8G/At6waViWG4yx0JY7g==
X-Received: from wmbka6.prod.google.com ([2002:a05:600c:5846:b0:470:ffaa:ae5e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b8b:b0:471:989:9d7b with SMTP id 5b1f17b1804b1-4773086d53amr4625785e9.21.1761844712453;
 Thu, 30 Oct 2025 10:18:32 -0700 (PDT)
Date: Thu, 30 Oct 2025 17:18:31 +0000
In-Reply-To: <20250924152214.7292-9-roypat@amazon.co.uk>
Mime-Version: 1.0
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk> <20250924152214.7292-9-roypat@amazon.co.uk>
X-Mailer: aerc 0.21.0
Message-ID: <DDVTTQZBJXAK.1OC7BTWCVCP9U@google.com>
Subject: Re: [PATCH v7 12/12] KVM: selftests: Test guest execution from direct
 map removed gmem
From: Brendan Jackman <jackmanb@google.com>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"song@kernel.org" <song@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: dbqehxxcwhyrfos139pphdpe614cr3r3
X-Rspamd-Queue-Id: 8662D100005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761844714-414625
X-HE-Meta: U2FsdGVkX18rEtJno6ASH0OjKwiyaKreVOSRTYwdU8G7ErlRRADFUd/cIFluh2snSKR2XdCwu3hdBrPhl5iEu2GCCN7V3V1KntzS3JtPSg/mKYvZmnEfVo+yo9rKoesuEiqe/RMgm2MTvaOvbkgLq72MbIcaYpY4lf0me1rVcDbAnxKJa+332QKyrrF8AE0gmYpPK1rwWyx5omjPL6w72Zpx9N0z4QZ7zwD7xDFVvFu2umBPMLSzJU3ZJB3Pe/RmNZl2gwyzv9MGaUvdFabxj/Q0yYwxANzDzzxa7HbgdjOgcJL3Tx0cnQbw0zxEYwaIxhET+x6Fiu1sDZK2DINmaIueWapaXx9YCy6k5btDkfbYesXFRcnQhjDM+xEBmTwq2Dndke1/MHTLk5sqkfL5Ap/Ct+AYJnAwpp1E/Z7tgOdsfJicn8arV/4h09EANsos8sVPMqu4F3EnkhZ9HqAswo1MEP67KO3Zhl0R3bIfCTem0Qq7aGGwIjlI712CM3HYFKGRGKuXsWIBEICxrf5KIPPENJOUcqkazxaihSrl+WxuFrERzHLfHKqgqiRRxveUsVVLgBibLfrAFkpMzmcAD0JrpDMjo0/8VE/jm1MwttcsJrY9ZK3hl1p/B0oi7ByybCP0m2QTAetv5EpKtSSftnyEIKaFCbbjqODAIEDV31OXktOybOIDu4GF999GxL28SPVsk3c7/EqzeD8AfXYpcPxd4ycKftykyE6CCJJft8uvjKL8WyFgCXfx4eRDYuJMdr0Uu8EpDLz7uOGN+/SVIu74lgsc47I8d/y5nVGmQQDiW8aAUp3GtKUMe/Mn0ibMz6+2FtLf3sOrXBfBLpz1hzAUmzZxdS85rvFWCRq0jijqiJCUfwoOZRJDUjAsFsyYE7eFz7GDbWrOHjXu46qPkHRwXfNTdXEwKVM7IsaIaaBums+R+ChQ/lnZ2Cfa9Q5ufLGryoUlVSv6dYfJjgs
 5Eo4xVxK
 AQTPsY6Krg7rpIQHwP1Ye+5n1JRnOTRklcO4mAylCroQFRq+/jowU+0MRUM4LieLGL/8kHP5susDB9k3nIXMLlurUQ6soOtUrCgZ2MqVGXJuZdzqPkyfZp05yj1hreWFd+U93B37a0mIoJsyVsqNZYJOkab2cI+O0o7mxyfaa1aRgfS1BwEjpVw3gbXTFJV+wycIpziXX26PE6Cg6FVfuO4V5odckO7AwrZ34O6AMxeOTaDy6rydc+qme4uqtIapY253EX+IW70zYd1G1AJtnc7GN/HUH03/5smZA77XH/yr/ptDiilg2aKvwWZavobgDoQ7/K14+07iB366yOSpE1W+Jbqz5EGemq74Qg435uBI7+bJaPvD/kD5/DAfIHDB85tO1wohhiVxcLb2E1Ok0d0v2sjkgHXgTa8vvN6et0Z2Rfl3y2scCVWR9b6lwVcX+LqcLytLX2ZWVglTIqJaq01HbqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Sep 24, 2025 at 3:22 PM UTC, Patrick Roy wrote:
> Add a selftest that loads itself into guest_memfd (via
> GUEST_MEMFD_FLAG_MMAP) and triggers an MMIO exit when executed. This
> exercises x86 MMIO emulation code inside KVM for guest_memfd-backed
> memslots where the guest_memfd folios are direct map removed.
> Particularly, it validates that x86 MMIO emulation code (guest page
> table walks + instruction fetch) correctly accesses gmem through the VMA
> that's been reflected into the memslot's userspace_addr field (instead
> of trying to do direct map accesses).
>
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  .../selftests/kvm/set_memory_region_test.c    | 50 +++++++++++++++++--
>  1 file changed, 46 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
> index ce3ac0fd6dfb..cb3bc642d376 100644
> --- a/tools/testing/selftests/kvm/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> @@ -603,6 +603,41 @@ static void test_mmio_during_vectoring(void)
>  
>  	kvm_vm_free(vm);
>  }
> +
> +static void guest_code_trigger_mmio(void)
> +{
> +	/*
> +	 * Read some GPA that is not backed by a memslot. KVM consider this
> +	 * as MMIO and tell userspace to emulate the read.
> +	 */
> +	READ_ONCE(*((uint64_t *)MEM_REGION_GPA));
> +
> +	GUEST_DONE();
> +}
> +
> +static void test_guest_memfd_mmio(void)
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +	struct vm_shape shape = {
> +		.mode = VM_MODE_DEFAULT,
> +		.src_type = VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP,
> +	};
> +	pthread_t vcpu_thread;
> +
> +	pr_info("Testing MMIO emulation for instructions in gmem\n");
> +
> +	vm = __vm_create_shape_with_one_vcpu(shape, &vcpu, 0, guest_code_trigger_mmio);

When I run this test on my minimal config in a nested VM I get:

[root@testvm:~]# /nix/store/xlxd60n7v1qfr6s5zxda410zrzdd0xc2-kselftests/bin/run_kselftest.sh -t kvm:set_memory_region_test
TAP version 13
1..1
# timeout set to 120
# selftests: kvm: set_memory_region_test
# Random seed: 0x6b8b4567
# Testing KVM_RUN with zero added memory regions
# Testing MMIO during vectoring error handling
# Allowed number of memory slots: 32764
# Adding slots 0..32763, each memory region with 2048K size
# Testing MMIO emulation for instructions in gmem
# ==== Test Assertion Failure ====
#   lib/kvm_util.c:1118: region->mmap_start != MAP_FAILED
#   pid=614 tid=614 errno=19 - No such device
#      1	0x0000000000407b02: vm_mem_add at ??:?
#      2	0x000000000040a924: __vm_create at ??:?
#      3	0x000000000040ab16: __vm_create_shape_with_one_vcpu at ??:?
#      4	0x00000000004042cf: main at ??:?
#      5	0x00007faa6b08a47d: ?? ??:0
#      6	0x00007faa6b08a538: ?? ??:0
#      7	0x0000000000404384: _start at ??:?
#   mmap() failed, rc: -1 errno: 19 (No such device)

Here's the kconfig I'm using (basically defconfig+KVM): 

https://gist.githubusercontent.com/bjackman/4ea941ef5072606769211f3b000c8ed7/raw/73808882ddae6ff2ae8a0be85ac977b2980f7292/kconfig.txt

Sorry I'm too ignorant about KVM to know what I'm missing here but I
guess it's a missing TEST_REQUIRE()?


