Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30CEBC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 21:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A50A6B0088; Thu, 24 Sep 2026 17:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F116B008A; Thu, 24 Sep 2026 17:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F7E76B008C; Thu, 24 Sep 2026 17:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3388E6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:53:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC0D41604EF
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:53:09 +0000 (UTC)
X-FDA: 85250006898.15.AE82A53
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf17.hostedemail.com (Postfix) with ESMTP id E711940008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:53:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="RSz/PYUM";
	spf=pass (imf17.hostedemail.com: domain of 3wpu1agYKCC0bNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3wpu1agYKCC0bNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790286787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96howwJpIzasaCW/3Q0EcsFpl6itohsELojaGu9d8N0=;
	b=iv3KL6xfVBWH2o+G6POlg0fj2oJSawK5qr7X2CVEAdJZguYjQqis9b7amiF6zpIrLKVcGI
	SxzLPUi7Z+RIqFdAvukH4eWHKI+XJQ75a5VSkjKJI+F7Yn+ZDkbSs0X1muiA0xKCTz0ssS
	1DSbwuKR8x2obILdRd1KK1YI1bB+s14=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="RSz/PYUM";
	spf=pass (imf17.hostedemail.com: domain of 3wpu1agYKCC0bNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3wpu1agYKCC0bNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790286788;
	b=B+3fkoSMoPbeIe5Q2byHOqKtC8IVB1yPvWL0wx6+jDJwVc4ReFsySfTNbHoLRl9K88Ajm9
	skz2wmx2+WWtMxze5KWV2u6jdmk2uxyAfBpYnmhIm2/C070jQ/dXxFaoWF1XBmxynEKp6G
	9N51dsoWrvOkkDazpZ+BIQeY+E0SKdE=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-86b3c58d686so403096b3a.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790286787; x=1790891587; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=96howwJpIzasaCW/3Q0EcsFpl6itohsELojaGu9d8N0=;
        b=RSz/PYUMTkfDxZtXg0nrzZGOmxx12ZVYoNn4XJ+9ZKsYAdX0chSPvqnBedvlAEodpo
         XBf1bB1e8nFkWHNqj6KgRYVoY7fRI3CvC/XJC85kDcxX8o3w6+OexHMro4+uLdbHzVVw
         x/idT5knDIrijFqQF32rbxSjQb/VE6eqMsGjJy1BMtSPuQxrDpZ7uZIEyzhK/sBpV6vm
         GpRK71VWqLJ/WsKGHgy/4nw6Ep9eplMZ9gUsx1QNCIluLkzsCbdh8rWk/ybSu3rAllg+
         9BoXhgtd5OV+SSXPHOJlOHaNSeWY2AAZaFwpwgZ0L7bDku5S3cEIa2ie1Xfd6+GB+1i8
         P2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790286787; x=1790891587;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=96howwJpIzasaCW/3Q0EcsFpl6itohsELojaGu9d8N0=;
        b=TCg5oNWpj780zU8pQldPIHa4bmsI/fF6XUTPP7uMqXkJRoqUuw+0wH1FjJlFJzZ4f8
         mvCgZtGpwvvADH8rcIh3eziLJTj4sDD/ME7Kjt3cmd9g+ps6dTg5EE9cB5yLuMvfJCvq
         qxyiKqS7r13ilqYrMtCxiB/etrf2/P0LDN8/ew7C4/ZAbv2+Yu6k7U2bvl26NJiWGdTd
         pOCCNSaaPUQlElSP0Ade9DcX5mVJvGJO+h28kx+gYor+AYwugo1HXCSoXa+nLgHJI1Rt
         oPZ4AJ0bHGzFqELv0QO/jJuXiDhjggk22oJVt1zB9iNLXxedcQMELFmZa3OW1GObHgT0
         IF8g==
X-Forwarded-Encrypted: i=1; AKwUvBxnWcCT325tgoErOZajRQTWmppzM6yuR2PCie2vheQHtNUhIscFEh4LmfF12mi0Shhk7eOoa/ytHQ==@kvack.org
X-Gm-Message-State: AFuF++kf1Jv76DmF6TQQVNtWkFOviSrJdVug6iZk6TqSV2MomCLeU0UZ
	5JhTt38F1SpUoHNNEblPfUtTpuABufzZRnC1deyVa2NxTaYFsHttSDaA0Yu51oqIfUI3aFARJ2g
	7SAmp4A==
X-Received: from pgbcw5.prod.google.com ([2002:a05:6a02:4285:b0:cc7:513b:37d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:439e:b0:3d3:ae50:97ce
 with SMTP id adf61e73a8af0-3de0e755869mr3534504637.27.1790286786082; Thu, 24
 Sep 2026 14:53:06 -0700 (PDT)
Date: Thu, 24 Sep 2026 14:51:49 -0700
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
Mime-Version: 1.0
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <179028368162.2007072.12117327378679658047.b4-ty@b4>
Subject: Re: [PATCH v13 00/44] guest_memfd: In-place conversion support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E711940008
X-Stat-Signature: yfb3zh535q1hrzjawdjfti4fuzdqwygr
X-HE-Tag: 1790286787-746641
X-HE-Meta: U2FsdGVkX1/Iy4kMqdcU2PhVwv7+lP534bRpWmFTEpypU/pDLLoc/qHzg4hktgi+d//sjNLUqm9+WjMKN4S3NGoXJXtbgQL1sLeyXHOD0aPk/DFd6ug9M8wDyT2JFZIGw3HlaE4TOWoSS9BzU6ZJNHkGaenvIyKhjd2uzpW2AfIVL6PKu1tbT/iQU8IQ7974xH5LrJOD52tnPpHznDXLUEeJWDnT3v50hPht2rY03o7O+SDejm1FLROrh45HHBgZuafkHxlaQD5FnQ6GU0l+DmUwxTamCuYtALAjNy5ErCg/QPmoUYvlcfgvHJcl4dolG2eCFaRee2aqK29sWIZUYbF5Y6/6MxSnX9cKa+yAjimI3pHhO7dpuve30IifbyRktmUIV1sf3jVNP0McQaWMRRZkiBNDhM4Vlby4rIW76iPxb4s5YI7YasTTVDRvCxfMM7BAc36n51qAHwcN3WfPbOfaEAHh/LpQuTp4TEFpOYG28wdFfgynABhYP7dw/EDBvytW6oe56VJ3h4ZMRK8nbSUbb2NBStc9V6r9/K1whTdQ1Zgirln1r/3Et/EHRI6uNRjCVV87nPUStAktwq9JuKb0zDPKzkz64yKCxzHXzcSK/1WX+du4OrES6JxcTERYvuiHVpgZFmrWTlIEIHWLue9T2eRfBS4AzhYsXq/jHmzIUuU8F0yP/KAW3l5lZKTpOKRTzOVk76EfM4IDubvPb/RXzb8/MeOt0ZQ5wHWws4nLedDYFWWlihJwC8Ok59Vbu4BRuVoj7xuQV3nv5l7fthFqQX5MFQtdSDqO6UiU/dPnwAj+NXL+LuvzW0tfbRCgq9+2Rr/FZTppditNMuBrZnYIcMvOZkS5hNxcklfhxL8zPEanaL5kHNDeYbdNZAoorX3Cvl/U/90tK0ltQm4V0oIQIuFNokYejkvlcISlotyXhTfkah6Iqb4oAQqHwTkngPBDpve/CFhYUiJjR8z
 H0Hz6olN
 gdPDwOvX9uxvUhD9IMxtfoR/pcy2OBnBS3NePrcV0AmLe+djMwu2m7P+obhFayMNzanamLwwbSsNeyWegaNCRCgv6QiZkzluyiMopzjYpNUU9Gx0KR3fP/LLmHIBSQXCORMAXE/OakJpR+Xv7L5Zqhayn5vxnSxLrgJSjvrYI5qtUY0gc0IP57d+G4R0JN5obOfRWjofWwhgZM1naHBOUMJlSILQAEoF62GyVd+cjuCwDv2K0sBmxKakJ2e+OfADvdakKXZRUz2VnFz6253UEoNaAy2p8gdMBy87XB8tmfFSvS3qUe3KZ1Cj1Zqm07CmKtplSJY/3ujRfft749gEmnASxjhh2KP6noQkxP9+ai6jmV3jSHPsMI3varUC8vedL5uKr5ZCBkCOh+Nt1GpHMkoe1scAmvRJR39LtL9qNRTmSIwWHlcYaZUZrabBDpgHuJisN2DRzD4J1E9QHZMTXMLvYQHJIMmjYCC/pO3wfIXRts7O/7i21S/C/sozwwTHbJlSP/bWlIy5DBV0HVtjpw9gZaVeDW/NzjcPxGlOUPDM4b8MnyMkF0WC5mu67O4+ZFuboKYamUaQgArsZw9Lf0ZgMMXrhwzmZmwTkm/cP8h/rxqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 16:55:26 -0700, Ackerley Tng wrote:
> Here's v13. Thanks everyone for the comments and fast responses!
> We're now at ~3 weeks to soft-close at 7.3-rc5.
> 
> v13 is based on 7.3-rc2 and:
> 
> + Hugh's patch to export lru_cache_drain_for_folio()
> + Another series [1], which makes kvm_gmem_get_pfn() NOT return a
>   refcounted page to KVM.
> 
> [...]

Applied to kvm-x86 coco.  A *huge* thanks to everyone who helped with this!

[01/44] KVM: guest_memfd: Optimize away conversion overheads via dead-code elimination
        https://github.com/kvm-x86/linux/commit/54623a16bbdc
[02/44] KVM: guest_memfd: Use kvm_mem_is_private() when populating guest_memfd memory
        https://github.com/kvm-x86/linux/commit/fa7b8b1bb5d0
[03/44] KVM: guest_memfd: Introduce per-gmem attributes, use to guard user mappings
        https://github.com/kvm-x86/linux/commit/1ae5be958ff7
[04/44] KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
        https://github.com/kvm-x86/linux/commit/44e17d0a3663
[05/44] KVM: Enumerate support for PRIVATE memory iff kvm_arch_has_private_mem is defined
        https://github.com/kvm-x86/linux/commit/c2ae2bc1a311
[06/44] KVM: Rename memory attribute APIs to prepare for in-place gmem conversion
        https://github.com/kvm-x86/linux/commit/a84ef89cbf91
[07/44] KVM: Rename kvm_mem_is_private() to kvm_is_private_gfn()
        https://github.com/kvm-x86/linux/commit/98fd6e30bd14
[08/44] KVM: Provide generic interface for checking memory private/shared status
        https://github.com/kvm-x86/linux/commit/8ab5719fbcdc
[09/44] KVM: guest_memfd: Stub in ability to enable in-place shared<=>private conversion
        https://github.com/kvm-x86/linux/commit/ee1168fb7313
[10/44] KVM: Consolidate private memory and guest_memfd ifdeffery in kvm_host.h
        https://github.com/kvm-x86/linux/commit/bcc640eabbb2
[11/44] KVM: guest_memfd: Invalidate both SHARED and PRIVATE mappings for in-place conversions
        https://github.com/kvm-x86/linux/commit/e088c7f86bef
[12/44] KVM: guest_memfd: Always fault from guest_memfd if in-place conversion is enabled
        https://github.com/kvm-x86/linux/commit/2e646bcfcf90
[13/44] KVM: guest_memfd: Pass mapping type filter to invalidation helper
        https://github.com/kvm-x86/linux/commit/2f7f4e102880
[14/44] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
        https://github.com/kvm-x86/linux/commit/799c9fadc639
[15/44] KVM: guest_memfd: Ensure pages are not in use before conversion
        https://github.com/kvm-x86/linux/commit/dcde2f853ff4
[16/44] KVM: guest_memfd: Call arch make_shared callback for to-shared conversion
        https://github.com/kvm-x86/linux/commit/6fa1dab756fd
[17/44] KVM: guest_memfd: Return early if range already has requested attributes
        https://github.com/kvm-x86/linux/commit/856852ef2108
[18/44] KVM: guest_memfd: Zero page while getting pfn
        https://github.com/kvm-x86/linux/commit/cb0544296a33
[19/44] KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE
        https://github.com/kvm-x86/linux/commit/edcc3f42981e
[20/44] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
        https://github.com/kvm-x86/linux/commit/af602a96f401
[21/44] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config definition to x86
        https://github.com/kvm-x86/linux/commit/31670c382efc
[22/44] KVM: Let userspace disable per-VM mem attributes, enable per-gmem attributes
        https://github.com/kvm-x86/linux/commit/537ec2b15fdd
[23/44] KVM: guest_memfd: Enable INIT_SHARED on guest_memfd for x86 Coco VMs
        https://github.com/kvm-x86/linux/commit/b5ed1ee2a7a0
[24/44] KVM: selftests: Create gmem fd before "regular" fd when adding memslot
        https://github.com/kvm-x86/linux/commit/b312cab4e48c
[25/44] KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
        https://github.com/kvm-x86/linux/commit/8d5f49000f8b
[26/44] KVM: selftests: Add support for mmap() on guest_memfd in core library
        https://github.com/kvm-x86/linux/commit/ee455183c92b
[27/44] KVM: selftests: Add selftests global for guest memory attributes capability
        https://github.com/kvm-x86/linux/commit/c3e48c166e35
[28/44] KVM: selftests: Add helpers for calling ioctls on guest_memfd
        https://github.com/kvm-x86/linux/commit/0bbbd2b02bf0
[29/44] KVM: selftests: Test basic single-page conversion flow
        https://github.com/kvm-x86/linux/commit/eaef4ed5fabc
[30/44] KVM: selftests: Test conversion flow when INIT_SHARED
        https://github.com/kvm-x86/linux/commit/e5fa04dc920e
[31/44] KVM: selftests: Test conversion precision in guest_memfd
        https://github.com/kvm-x86/linux/commit/492080a3d4e5
[32/44] KVM: selftests: Test conversion before allocation
        https://github.com/kvm-x86/linux/commit/97137c140360
[33/44] KVM: selftests: Convert with allocated folios in different layouts
        https://github.com/kvm-x86/linux/commit/5362c5fb88f6
[34/44] KVM: selftests: Test that truncation does not change shared/private status
        https://github.com/kvm-x86/linux/commit/bfb9b5a286ea
[35/44] KVM: selftests: Test that shared/private status is consistent across processes
        https://github.com/kvm-x86/linux/commit/8b72eaa766b6
[36/44] KVM: selftests: Add helpers to pin pages with CONFIG_GUP_TEST
        https://github.com/kvm-x86/linux/commit/e8a40b9a604e
[37/44] KVM: selftests: Test conversion with elevated page refcount
        https://github.com/kvm-x86/linux/commit/0db3f14f40c4
[38/44] KVM: selftests: Reset shared memory after hole-punching
        https://github.com/kvm-x86/linux/commit/c235250e8bc1
[39/44] KVM: selftests: Provide function to look up guest_memfd details from gpa
        https://github.com/kvm-x86/linux/commit/ee6f4c381903
[40/44] KVM: selftests: Provide common function to set memory attributes
        https://github.com/kvm-x86/linux/commit/f49dd8ba330e
[41/44] KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
        https://github.com/kvm-x86/linux/commit/ef72e71da099
[42/44] KVM: selftests: Set up page size and alignment independently for guest_memfd
        https://github.com/kvm-x86/linux/commit/710169986d9b
[43/44] KVM: selftests: Update private_mem_conversions_test for in-place conversions
        https://github.com/kvm-x86/linux/commit/e24e534ff850
[44/44] KVM: selftests: Update private memory exits test to work with per-gmem attributes
        https://github.com/kvm-x86/linux/commit/37e0791600e5

--
https://github.com/kvm-x86/linux/tree/next

