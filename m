Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E04C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57DA6B0088; Wed, 26 Aug 2026 05:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F116B008A; Wed, 26 Aug 2026 05:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45066B008C; Wed, 26 Aug 2026 05:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A98026B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B53601602EC
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:10 +0000 (UTC)
X-FDA: 85142869140.22.A0D707D
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf26.hostedemail.com (Postfix) with ESMTP id C40A214000B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TSL8Gpg1;
	spf=pass (imf26.hostedemail.com: domain of 3T6-OagsKCEQgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3T6-OagsKCEQgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735888;
	b=B6NxSfneCyGTIPrKcm1uZnlStykgpTtNR2TRyf3wRBVBsHjVahjG3OCmjMtECp4Q+DrHwv
	v1uOCTc+WSGzltSPYmzVBrhAb7JARlV/FNXyeSpbbzl5xQw9pbkSoMrlBRRKa0jRVHj1l6
	AeTROg/M2CBFxZ4WMe168KpBSi/nrhc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TSL8Gpg1;
	spf=pass (imf26.hostedemail.com: domain of 3T6-OagsKCEQgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3T6-OagsKCEQgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nhl63cMYXaPayVrWbozuGQk2Zy4kDMBpjtr4nRHAQf4=;
	b=dLPuDoNFjNAoU0909rkeL+/N2CYGkP65X55+kTwoUg1uBVkgYCawqivGSHfARN8WHh0qOD
	23TGRpLaEjsQLb13lGgZTfGc5UKd9B0fJQIEjNaLDpDf0K4THsCT1DVYEsMvxtHBUTqpuT
	VSFWdnuKBuMorNQupPzJ9QazoFOE2VM=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c85798977dcso1160548a12.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735887; x=1788340687; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nhl63cMYXaPayVrWbozuGQk2Zy4kDMBpjtr4nRHAQf4=;
        b=TSL8Gpg1OGKZsnPv2hlJ9fc1oQRjpPU0620z9MAZY0m2JnZU6HVHPKShHd6O24mx4p
         Uvo/WEENw3d5NF9MC4HEfdQIxK+OHOx8EAdinvIW/BCTV7oxQUo45bZSJrKr9W3iGHRE
         b+pqNeaurMESmndZaJJ7mAjUDCWIViFfYm6wdatSAMf+Q7hLyamEQCXDl9uxZhnwo8aJ
         y+xW26Wc53PauMxsQIzw5BkyUJop53vq3bgwWUHypa5rDOdVQOWI8KBPQCS567kjQRvG
         DNn/xLPTFyhQtsPeyV6Ibahn0IPHeSsFeGjdNjXgqJ3SNz4jE/V2jb1SwWrCwVHn8Ci4
         UJOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735887; x=1788340687;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nhl63cMYXaPayVrWbozuGQk2Zy4kDMBpjtr4nRHAQf4=;
        b=OF4VM5ED4TO0OeqtQcuV/b5YMH8sWpBwSuwmnkI8g6IHyUuPN0xnuhtGnOCcEv6mbs
         nxYC6wu+VW/jgiNMKLR6Iuh9UsrijCRnS5Kx5Q2JTZ+J6oXuab/GMGC8g3Hh27uUev1g
         vUst/GdL31jqYbbfHztMNzBg+5TKLfK232WuHPU+rkXrVPABBxGCgFrm5VliY4h52nXN
         msbcrwOji3KU45vfoSAwQecefCzLSriiTXuSvxIiYAhqu2QHks1aigm/K3wB+qY2OqxR
         Jt1Z+idSfjq5FLlAA4HctUzk4AVhjXp2FJ9i0cWSMmRmx3pBU6t5pORsXAvxpKSNlTmN
         rdLQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrg6Tz36SmH64YTh2881ycE9CHwMoKQ1rwtyBqCwEkMQO5qWqvEOktx6yLxMH8laIy32a1Odar6zQ==@kvack.org
X-Gm-Message-State: AFuF++lb3/AEzkGw2KJvZjg7JBUrGBRyvIyeJtLoB2690ub8kGeD//sX
	1XGaECN4qRi6Qtu9IqB6j9DOudw5+MUVB4QuyPM9jW1eKVEq73lYtUjWgmdEsgnNbg87ERL0aIm
	Xpx5iFfDwIP+uBYjqGPaIAXtepA==
X-Received: from pga21.prod.google.com ([2002:a05:6a02:4f95:b0:cc1:5107:1f05])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3b44:b0:3d0:5305:4fb9 with SMTP id adf61e73a8af0-3d05314a80dmr2848377637.7.1787735887159;
 Wed, 26 Aug 2026 02:18:07 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:17:58 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAEevjmoC/33SyU7DMBAA0F+pfMZgj+ONE/+BOHgZpxFNUpwQF
 VX9d5wWKUVRehzL82bRnMmAucGBvO7OJOPUDE3flYDzpx0Je9fVSJtYHggwUAxA0rrFljbd8eA
 C0tB3E+Y5ifrIoo/CaikcKdnHjKk5Xen3jxJ7NyD12XVhP3ufU/vS4Wmcv+6bYezzz7WJScwJt
 3KCi81yk6CMyhQ4OM0wGPtW9319wOfQt2SuN1V3EKhtqCoQlm8JrWQpxRUkF6gCsw3JAkWjmAk
 hBQewgtQCSaa3IVUgy52XznhuXbWC9B0EsA3pAkFiyWFllRRsBZkFUvzBaGbuKIKVVkhtpFhBd
 oH0ox3ZAgmZrMMADuN6R5wtknm0JM6uwwVuEFUU3v2jLrcLzPj1XW56/DvDy+UXiVvESvECAAA =
X-Change-Id: 20260225-gmem-inplace-conversion-bd0dbd39753a
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=13551;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1Ej7vE7kFzLBLFjXUKkqlvGbtROCFl/PzTp7c5tRCMs=; b=rdv3j6HqFdjoM7HzwBCy8iffW0It7iIyc/mZmg2uFb1R9fPWP14jJTyJbKh4KJRJ0lV3aBk2z
 G3P3BiIf1jOCUCdDD59Y9ufxU9n6mywEFy7ag/WckPResAB0YR7xPBH
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Subject: [PATCH v11 00/46] guest_memfd: In-place conversion support
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
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
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C40A214000B
X-Stat-Signature: x1ice48mjop5h4qmxx5jybek8kycincb
X-Rspam-User: 
X-HE-Tag: 1787735888-130292
X-HE-Meta: U2FsdGVkX18h0fY9csTCrB4pKa0zSdd4bypaRGop9HeG0sKyeWW7Pcks52RQ3ToYy2WJQEGTVJs+gs4NTVDCLcYARWN51ZBqHsO4oZc5L73l/2bHfPRRjS4irhzyzpA/Vtox7zn0n2l01HiETdrFxRNzXu5pwxQAoDfVj2fTUihTKLyB3xVc7sG6iw7ZqN30fuTtsl0cTT9XF+Pxq6Iku3pUanx0bZR0YaSp6ZWDyQ0kV7MINbGPOaAWHdyFWpeFD5LIjEDx3jc/p4XnWyj9bIaUKRf5RXVLzUh1Xjt0ftANknHCxtXCOWgJCqKFneh3PXB3uEPLoZyCF+TP+9IZ96CKxusM8/J9JfgOSzbnQBMk0B8m1qdFhuTL6Uu2rTg7S/flZkJ81ZAXIAOuQm/fXpHJ3RhVofVfJgv3PK6M+MRGjdPlaOXofxd+i8+cphshZkEVfoccghrCb03MP+Zv7YUw9RJkSNsCOdhXro/N1yRN3zlYzOooSOaTJPRHsECKKq/HhLz+/0Fl3q+rkIpI/jbMMEBgzrmUuUyDiNz+xlHCwPtFDR9rTuEQ+fmPMkslEg4y+0BS8FzRi98Da3cHu44Fb+1f+GXT2KjHbpMe9zIqQ8memLSL3Uc0QtAO3HSwkgLEHN/ZY9N48Lk6FrGPlCWJV6un9mziI16K3vipqjGRSrHzkpbLsOlOj9BFMiG8wJPMvpDgai7npiYcobPcLmwLIccX/H2r/dtEfqyC8VEH7AbzgMsE5iD0hxipZ2enhJIWnxr92oYOJoZzY+f5uzb4uUExNRB1E7OvitMKr8hBXQebjZsMvFRLIjT9wHXFOyn68hHbwcBTjB/hJp7daW/wdrurNoglf7oEVUTnLtGNzw/av9/z1L9/38VE3Wx74YYeFixiQhUnkNtOH3auzwTWXPdHAqDPC94UkpMMMXH3zGRyuCAUMnltssHv5Fn1e8Dbi9ScAWuae2gQOpb
 56NXreq2
 hJGPD7dWEkeD6RPR0TSBnnUSbQoAIp5M8cKCbLEDQ6ZTu//TaHFRCDk18MJXCm+vOAF0YAXPyxunAzn/niCyDjc0ajvjFYsP7ClHxxRXubFi5nKFCdQi+pNFvxrxd3pQt1MVeWs5vXbbdoC4iusI9awxe8MNtEywRe6BdAT0sTZLTJiqa+hMyrYOSzkBsy31w1gNOy7pEOWZmj2i92DgzgWOnLf/s+coe4vb68U5gqR3xp6cGZnjRIa9PhHUXRZkXZratpUVJTK5udqEVJiGdXdlkm7umFsi1JhnJ2u7RfkQnvS6uPCwEvoNOdsvBi6mwksdrNhvAsM6cv/KFrRvBL7nYQ6REWDamDfgbehm0WXPOV3JKzxH71alC1QDwlaMs9b1fICZuctBDg+wD0WxgYV8tLUrFI97YUUIt8DZHrJLlNz2NBVBZKLNLbEURYmJ4pWlM/GY37Mtj6JRgmxtrfp9D10dJ/hM1EKGgtptUdR3S7947vRFzny1lPaCYek6rM8EMxufM0bvqj05FgTuBCLyh9DpIakOpuMZ8tsSL2IT9H+dm+nTEXnh43kHbnVtuNQkWXGmJ1tJlheq2n1oYx3kSoqu/62ti9mLhm7v/wNkf25B6fx9a/udGan5QyR5pS7zA0Jra3hGbzfQ2j+O5glh7/HR6fi4SKaZDuvLS0adZx4kNV4x98Ukr0H3p5pgSdxLlniDX3bmhWFd2VARO8M/HFI91h5lbBf2OyL+f1cNleY9OFuQ05saz6grsZa7kAUU5WqrQaU/j5Ju7jXBjnKD9IlNGzSRIBFh3hNwrT7dmPlw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here's v11, thanks everyone for the reviewing and testing!  We're at
~5 weeks to soft-close at 7.3-rc5 for the 7.4 merge.

v11 is based on kvm-x86/next, and a cherry-picked version of David's
refactoring patch [6], and is now dependent on another series [5],
which makes kvm_gmem_get_pfn() NOT return a refcounted page to KVM.

Here's everything stitched together for your convenience:

https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v11

v11 changes:

+ Added this to "KVM: guest_memfd: Introduce per-gmem attributes, use
    to guard user mappings" as Yan requested In kvm_gmem_get_pfn(),
    drop the folio refcount before releasing
    filemap_invalidate_lock(). This ensures that a competing
    conversion request from userspace (to be added in a later patch),
    which also takes the filemap_invalidate_lock(), will never see an
    elevated refcount due to kvm_gmem_get_pfn().
+ Added patch "KVM: Rename kvm_mem_is_private() to
  kvm_is_private_gfn()"
    + I added it before "KVM: Provide generic interface for checking
      memory private/shared status", so that this second patch can
      clarify the VM version for kvm_is_private_gfn() to
      kvm_vm_is_private_gfn()
    + In summary, we have
        + kvm_is_private_gfn(kvm, gfn), kvm_vm_is_private_gfn(kvm,
          gfn), kvm_gmem_is_private_gfn(kvm, gfn)
		+ kvm_gmem_is_private_mem(inode, index): called by
          kvm_gmem_is_private_gfn(kvm, gfn)
+ Added documentation for module parameter
  kvm.gmem_in_place_conversion in "KVM: Let userspace disable per-VM
  mem attributes, enable per-gmem attributes" as discussed by Yan and
  Sean in [1]. I was reminded after more discussions on v10 [2][3].
+ Added Sean's patch "KVM: guest_memfd: Invalidate both SHARED and
  PRIVATE mappings", then a no-functional-change patch to allow filter
  to be passed to kvm_gmem_invalidate_start(), then the actual patch
  that introduces conversions.
+ Split out a patch that just updates private_mem_conversions_test to
  support gmem_in_place_conversion, as Xiaoyao suggested
+ I realized that in the v10 patch "Update
  private_mem_conversions_test to mmap() guest_memfd", the requirement
  to have src_type be VM_MEM_SRC_SHMEM is an artificial
  requirement. If private_mem_conversions_test and vm_mem_add()
  figured out alignment correctly for guest_memfd in-place conversion,
  that requirement could be removed. Added a new patch "KVM:
  selftests: Set up page size and alignment independently for
  guest_memfd".
+ Renamed v10 patch "Update private_mem_conversions_test to mmap()
  guest_memfd" to "KVM: selftests: Test in-place conversions in
  private_mem_conversions_test" to better reflect what changed.
+ Regarding conversions of the VMSA page, Sashiko pointed out
  something in the prereq patch series "Stop returning struct page
  from guest_memfd PFN lookup". That turned out to already be handled.
  :) kvm_gmem_invalidate_start eventually calls
  sev_gmem_invalidate_range(), which ensures that if a VMSA page is
  being converted, the vCPU associated with the VMSA page will not be
  allowed to enter the guest until kvm_gmem_invalidate_end(). This
  allows kvm_gmem_make_shared() and eventually rmp_make_shared() to
  never fail due to a VMSA page being in-use (since the vCPU using the
  VMSA page was prevented from running). Conversions fit right into
  the invalidate_start and invalidate_end model :).

Here's v11 with extra tests:

https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-coco-selftests-v11

Tested with both CONFIG_KVM_VM_MEMORY_ATTRIBUTES enabled and disabled:

+ tools/testing/selftests/kvm/guest_memfd_test.c
+ tools/testing/selftests/kvm/pre_fault_memory_test.c
+ tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+ tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+ tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c

Also tested ./gmem_convert_fault_race (this test is not for merging)

This test reproduces the race that Yan brought up in v10 of this
series (without TDX), where a vCPU faulting in a page using
kvm_gmem_get_pfn() would cause conversion failures.

The test has 4 vCPUs continuously try to fault in the pages while
conversion to private is attempted. Each attempt is a shared to
private conversion. In between attempts, the entire range is converted
back to shared in preparation for the next attempt.

Without patch series "Stop returning struct page from guest_memfd PFN
lookup", the race causes conversions to fail with -EAGAIN quite
quickly:

Random seed: 0x704e99ea
Reproduced -EAGAIN on attempt 1374 at error_offset 0x30000

Random seed: 0x3123e3de
Reproduced -EAGAIN on attempt 983 at error_offset 0x137000

Random seed: 0x2900e25d
Reproduced -EAGAIN on attempt 870 at error_offset 0x1e1000

Random seed: 0x721a2540
Reproduced -EAGAIN on attempt 1571 at error_offset 0x1ce000

Random seed: 0x46db97b4
Reproduced -EAGAIN on attempt 6601 at error_offset 0x1af000

Random seed: 0x7eca9fbd
Reproduced -EAGAIN on attempt 5894 at error_offset 0x19c000

Random seed: 0x41355a8a
Reproduced -EAGAIN on attempt 369 at error_offset 0x15a000

With patch series, within 10000 iterations there's no -EAGAIN:

Random seed: 0x51fb3075
__vm_create: mode='PA-bits:ANY, VA-bits:48 or 57, 4K pages' type='1', pages='674'
Guest physical address width detected: 46
Guest virtual address width detected: 48
==== Test Assertion Failure ====
  gmem_convert_fault_race.c:170: iter < iterations
  pid=243 tid=243 errno=0 - Success
     1  0x0000000000243215: test_gmem_convert_fault_race at gmem_convert_fault_race.c:168
     2   (inlined by) main at gmem_convert_fault_race.c:198
     3  0x0000000000267022: __libc_start_call_main at dsa.c:?
     4  0x000000000026919c: __libc_start_main at dsa.c:?
     5  0x0000000000242ba0: _start at ??:?
  Failed to reproduce -EAGAIN within 10000 attempts

[1] https://lore.kernel.org/all/aj7NwCRwWEfLK-gQ@google.com/
[2] https://lore.kernel.org/all/ed483d25-d908-4248-b8c7-862dd35dc6d4@kernel.org/
[3] https://lore.kernel.org/all/a410cca6-0776-44af-8353-9b7375e2fd4e@intel.com/
[4] https://lore.kernel.org/all/CAEvNRgH5ZQPGYzg+YdtEktZ72DgK9PBbzcmC_QFN6M0_6wuo1w@mail.gmail.com/
[5] https://lore.kernel.org/all/20260820-gmem-no-return-page-v3-0-3bf8f80a7b4d@google.com/
[6] https://lore.kernel.org/all/20260825015337.B58AD1F000E9@smtp.kernel.org/

Older series:

v10: https://lore.kernel.org/r/20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com
v9: https://lore.kernel.org/r/20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com
v8: https://lore.kernel.org/r/20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com
v7: https://lore.kernel.org/r/20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com
v6: https://lore.kernel.org/r/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com
RFC v5: https://lore.kernel.org/r/20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com
RFC v4: https://lore.kernel.org/all/20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com/T/
RFC v3: https://lore.kernel.org/r/20260313-gmem-inplace-conversion-v3-0-5fc12a70ec89@google.com/T/
RFC v2: https://lore.kernel.org/all/cover.1770071243.git.ackerleytng@google.com/T/
RFC v1: https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/T/

Previous versions of this feature, part of other series, are available at:

+ https://lore.kernel.org/all/bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com/
+ https://lore.kernel.org/all/20250117163001.2326672-6-tabba@google.com/
+ https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (23):
      KVM: Rename kvm_mem_is_private() to kvm_is_private_gfn()
      KVM: guest_memfd: Pass mapping type filter to invalidation helper
      KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
      KVM: guest_memfd: Ensure pages are not in use before conversion
      KVM: guest_memfd: Call arch make_shared callback for to-shared conversion
      KVM: guest_memfd: Return early if range already has requested attributes
      KVM: guest_memfd: Handle lru_add fbatch refcounts during conversion safety check
      KVM: guest_memfd: Zero page while getting pfn
      KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
      KVM: selftests: Test basic single-page conversion flow
      KVM: selftests: Test conversion flow when INIT_SHARED
      KVM: selftests: Test conversion precision in guest_memfd
      KVM: selftests: Test conversion before allocation
      KVM: selftests: Convert with allocated folios in different layouts
      KVM: selftests: Test that truncation does not change shared/private status
      KVM: selftests: Add helpers to pin pages with CONFIG_GUP_TEST
      KVM: selftests: Test conversion with elevated page refcount
      KVM: selftests: Reset shared memory after hole-punching
      KVM: selftests: Provide function to look up guest_memfd details from gpa
      KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
      KVM: selftests: Support guest_memfd attributes in private_mem_conversions_test
      KVM: selftests: Set up page size and alignment independently for guest_memfd
      KVM: selftests: Test in-place conversions in private_mem_conversions_test

David Hildenbrand (Arm) (1):
      mm/gup: factor out LRU cache draining for folio into lru_cache_drain_for_folio()

Michael Roth (1):
      KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE

Sean Christopherson (21):
      KVM: guest_memfd: Optimize away conversion overheads via dead-code elimination
      KVM: guest_memfd: Use kvm_mem_is_private() when populating guest_memfd memory
      KVM: guest_memfd: Introduce per-gmem attributes, use to guard user mappings
      KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
      KVM: Enumerate support for PRIVATE memory iff kvm_arch_has_private_mem is defined
      KVM: Rename memory attribute APIs to prepare for in-place gmem conversion
      KVM: Provide generic interface for checking memory private/shared status
      KVM: guest_memfd: Stub in ability to enable in-place shared<=>private conversion
      KVM: Consolidate private memory and guest_memfd ifdeffery in kvm_host.h
      KVM: guest_memfd: Invalidate both SHARED and PRIVATE mappings for in-place conversions
      KVM: Move KVM_VM_MEMORY_ATTRIBUTES config definition to x86
      KVM: Let userspace disable per-VM mem attributes, enable per-gmem attributes
      KVM: guest_memfd: Enable INIT_SHARED on guest_memfd for x86 Coco VMs
      KVM: selftests: Create gmem fd before "regular" fd when adding memslot
      KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
      KVM: selftests: Add support for mmap() on guest_memfd in core library
      KVM: selftests: Add selftests global for guest memory attributes capability
      KVM: selftests: Add helpers for calling ioctls on guest_memfd
      KVM: selftests: Test that shared/private status is consistent across processes
      KVM: selftests: Provide common function to set memory attributes
      KVM: selftests: Update private memory exits test to work with per-gmem attributes

 Documentation/admin-guide/kernel-parameters.txt    |  25 +
 Documentation/virt/kvm/api.rst                     |  85 +++-
 .../virt/kvm/x86/amd-memory-encryption.rst         |  14 +-
 Documentation/virt/kvm/x86/intel-tdx.rst           |   4 +
 arch/x86/include/asm/kvm-x86-ops.h                 |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   9 +-
 arch/x86/kvm/Kconfig                               |  15 +-
 arch/x86/kvm/mmu/mmu.c                             |  28 +-
 arch/x86/kvm/svm/sev.c                             |  13 +-
 arch/x86/kvm/vmx/tdx.c                             |   8 +-
 arch/x86/kvm/x86.c                                 |  20 +-
 include/linux/kvm_host.h                           |  83 ++--
 include/linux/swap.h                               |  11 +-
 include/trace/events/kvm.h                         |   6 +-
 include/uapi/linux/kvm.h                           |  16 +
 mm/gup.c                                           |  20 +-
 mm/swap.c                                          |  48 ++
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/include/kvm_util.h     | 139 +++++-
 tools/testing/selftests/kvm/include/test_util.h    |  32 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 222 +++++----
 tools/testing/selftests/kvm/lib/test_util.c        |   7 -
 .../kvm/x86/guest_memfd_conversions_test.c         | 512 +++++++++++++++++++++
 .../kvm/x86/private_mem_conversions_test.c         |  82 +++-
 .../selftests/kvm/x86/private_mem_kvm_exits_test.c |  36 +-
 virt/kvm/Kconfig                                   |   3 -
 virt/kvm/guest_memfd.c                             | 467 +++++++++++++++++--
 virt/kvm/kvm_main.c                                |  92 ++--
 28 files changed, 1701 insertions(+), 299 deletions(-)
---
base-commit: 5619ae2be01e78f6a479706b659fae07823467c1
change-id: 20260225-gmem-inplace-conversion-bd0dbd39753a

Best regards,
--  
Ackerley Tng <ackerleytng@google.com>


