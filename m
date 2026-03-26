Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 836E910AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0F46B0005; Thu, 26 Mar 2026 18:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7820B6B0089; Thu, 26 Mar 2026 18:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6703C6B008A; Thu, 26 Mar 2026 18:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 534376B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8F5F13C2D8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:26 +0000 (UTC)
X-FDA: 84589644132.16.88AAC47
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id E84AD180006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l4fnBsEH;
	spf=pass (imf24.hostedemail.com: domain of 3F7LFaQsKCOYIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3F7LFaQsKCOYIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BL72lrNf2QkltPBVeRaNAZDLGH/Oti/Xx+2x3+YF24k=;
	b=CWe93UvItcWGyHR6i1GQ4S60YatgIhtoMQ5McC/tesEjihP1qPjc1TYRaWyZJr4GqjdeXf
	EoxoDLRDljdvvPHVkOdLJFrrNHHeg/eM2exE9jfckU/AErwBfuqd2Q/7wGK7pqk5IsmLRs
	V44Dw0TyCOAPbxBeY9dRmSJjvrqJn2w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l4fnBsEH;
	spf=pass (imf24.hostedemail.com: domain of 3F7LFaQsKCOYIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3F7LFaQsKCOYIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563865; a=rsa-sha256;
	cv=none;
	b=zwMVjh5aNCrhJbwNtNpVXSIkDTRFnb8CHVx/JML5dsHErWWfCpqwlgMQ6THq0Hxds2I2qb
	1BmrOLACJFJyJtD0wRDW8pOso2AgNMnOXGyq/Pz9e3+bv3k7Ee1ZuI6zE57zOafwB8Ff6o
	h3QwLAMr7nR0YcOOLRqKsgpaQ1LJEWI=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c741a9ef5f0so1035864a12.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563864; x=1775168664; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BL72lrNf2QkltPBVeRaNAZDLGH/Oti/Xx+2x3+YF24k=;
        b=l4fnBsEHNcz+odCg3hAkuGtrifeH4EbT9T28AYJN9G4KlWdocmQU6/gUUss+Pm1pVx
         o9od6BR7TaLkIa9q2rWEWb1IQIvHj615lOBwb9yj20yRs/zoVITHbwtPF3yQM3ZS8TzX
         iBkpPzPHEa0wEbRgj8I1rg8of700HHk8kQrURF+Y7tW0VU65H+GiqfcM2pNE+np8xVlI
         MR3yupG6cZ6Emwhn+rL6yMNL6NK35BHxeOqk9kIqQmnZHgwbuoBuOL1DKeIU1nPWR+fy
         t4eY/rt57oL+NSai1BJ01QCRcON2GIyJK/YL90TXyiOei5cjJzcndRVA5gIXpgP8chtU
         HtUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563864; x=1775168664;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BL72lrNf2QkltPBVeRaNAZDLGH/Oti/Xx+2x3+YF24k=;
        b=ktiS9fT/gMUr3QvZFUVx2hWNzkjzDgMvlaQmz/QvZarXbI0Vaur/ebYNfdA60FwjOL
         HYIZIx6ifZa6FywBNV434LToUG3y/3urYyRR68fKyO9RrIq4pnHEkKtL9ZFlIVzO5x48
         f1DZ+08Z2XdRDvUywI+Bh/GXSTdPGpjjzPuOqtoXKbodhg/hfYm9phDI/weLyyOL0s/B
         aIzD5UubNGSvOK0Qm+768n84ZteQU+8v14lPkZDuLXHfUEq3CsTu6S4c677cSLRfaWRu
         VxNvU/JFrgMDq1BDC5Hr7Hcy0pAXVCzTCPmVL8Tjivetm86/dV73MS3wFxTqR6ITcTK/
         tu0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWeMIiZZfnZlV5L1LLLCJPARUtquwaqAdZ/dSfAkz5fMb7Jsj4g5Kd+pRF1Zqqz7PyQ940KWmsNjw==@kvack.org
X-Gm-Message-State: AOJu0YwLbV1ylffQqigOjQjZynuX7CMHPxPBlUR6DQXq/KTUWpZDqUkt
	ECE2zUEIxXIwtQFxwh2vp/atJjGUK+yormEWiFxszmU2gFSybdOYycpfNWQGXy3N6hULIrQAS9x
	pMSDDbyxG7ECD2i9mHxEuD9vzdA==
X-Received: from pfch17.prod.google.com ([2002:a05:6a00:1711:b0:829:9111:d582])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4507:b0:824:b03f:2f65 with SMTP id d2e1a72fcca58-82c86327803mr2542565b3a.7.1774563863167;
 Thu, 26 Mar 2026 15:24:23 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:09 -0700
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAAmyxWkC/3WOTQ6CMBSEr0Le2mppRcSViYkHcGtY9OcBjbQlL
 WkwhLsL7F3OZL6ZmSFiMBjhls0QMJlovFvF+ZCB6oRrkRi9amCUXShjBWktWmLc0AuFRHmXMGw
 MkZpqqXlVFlzASg8BGzPtzW94PR9Qr6YUEYkMwqluK/0ke3I4jVu+M3H04bsfSXyn9k2e87+bi RNKikblTJQU1bW6t963PR6Vt1Avy/IDuIOvYt8AAAA=
X-Change-Id: 20260225-gmem-inplace-conversion-bd0dbd39753a
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=10415;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hyHHU3KevU1bPZ0Pz3Z5wuGltsbom7bIL/N/qi4jWOo=; b=SDVWlzJcpxISVwqOVOCgwwa+YC0UDPLDcSLkwYAyQaCK6yKAR8SuXc9BrH/WMDNBwTtDusyIC
 SdvlK3rvjp4BhmvKLQQSqUcLHSD9J2SVOM6/u8ZuDk7xkSMfAo0WgWK
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 00/44] guest_memfd: In-place conversion support
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: fc6hpto18w7zcphp1ie7wtwk4sc89wzj
X-Rspamd-Queue-Id: E84AD180006
X-Rspamd-Server: rspam09
X-HE-Tag: 1774563864-608068
X-HE-Meta: U2FsdGVkX1+x/X0jSeikF2Ue+jBnh3eP328R8BPFnjJHKImZyj+nX5mGM+Go4GY3Zh6WiU+jJIoC/py4Eew7Ie/plFRPonzU/Riyytwli4d9N0xBPJ//ss7j/ITc/KHgFO3K+abz/MEkqY2uirmzVHpEWCgloFaTpbasoQkA4Ng2w6E8p8W3nYIfq66+YqIqfV31fXtb8wNrGiclbih4dNVCjbXiH6X2gho3XdF1xP0b4rF58mEGedVP7a4J6fDlMr/GebVF5MHleNDAAnd+on3MJvcinC/Qbn1Dj4+dRTnuyhEniX/lRPsdBG63Shz6OB55aPagZ8YAYnTWYITVa3hlUO/wURmJP4qgkLx1+Zfdu8wCqw2kTxFYa/spuXdADFdE9UzKxqOV4psWhSWGIWYbagvyQHwprwhoDZgH+sajfkbmggaY8iCVn4oaNY1H1GIo3aXQ5+lB+rUL/ubFPqZ1s3Z4J5Zk96o2D6G5iWvzggRoCrPru2DqmVdOBFrIsDAt6lGPGlDk7zEy8R5b/WGvDpMCDa0pNGPg86mvSbI4CO7AL5gQwW+uQa8Cg7khHZRP9/2v7YFyQJ1W5uNWRzABYPgaMOw9wma78JQf1vOSq5Y4+TMBmlNNabnHs+Hnyd8FuwrwTGCzZMCwHSi4Qdh4ujBzzcq/OZpQPB5eg9cnfrUxQqNMynG0h1SikbvXuf78Vvv2CdDui7EFG6krAhvOpONVk2XGkPLSUy5+a8ydxcUpxwAcNCLlSd6pfzg6lXJ5NgrKtQd6ucEuJdDcOTGVPXSb7NhboIJonVxpyp5vd6i5T9IKdaDURuhEoqYCRkCF1OgaqcpAMv6DmRUnQKUCMo8KVFGnU10dIybTzCVbirXm3tVgFLEGliz2pZ8HsS2Rdqqt1+qcDcmfLsHJTVLkLhmGS2prILDPXQT+bW4p+yjG/hra23mk3fTgPOMgsEw1IzB65y1JWdG0Jb9
 05hRxklm
 mNkG/Pmm4Bc31ojzF3/MmCMH7PNpZKagI9Jn0YLP4dKlZPm7s9HwbdA82jnqmR3k7ctWxcW6EgbiadnlYShrYYtI9+nwMRA7oJ9sVC0qrOGhQryEF2K5scYIemhrc2lzObVPtVCRUc6sFQSUkNYxtvwENksqwgEMK94LfD88nG2wXoxDQRtL9wJW8y/x1X1zMg01UrQ8tcpOmQgvvWbnE0+B0fhinAKdbNQrcLX26bCGDbzd5Xeqme+iA5SHfOc2Bx7Czf/roAPLLLjgni/6Hux6JvlaCiK42I6n6UBgYtVaglbx6xviE1pBSrZI5vKfNWitTjUKE3FR5oPIMQ3hALwVd+xcQOQIFQGEIqEzVVPDRw/cUgxx2QgkgtQqc+xr4iDDuIxwBTSXBlxeF/gxgfIMPqdFFz8DyXtM1L3HOZAH3za55QC7Qxr7u7m2R5aVo497gD9dA52X9fNHqa66NIf7tv7ufKZ/o0/sZlnNI3FVPZsU07RFrxW4nSYPZbu6u8zK2g3+ltW9tx+3ouY5UeRUDRyuqWHFMpvW3H3uOH/i2FcRLTAPItAnbE5/EEX9cVqS62zf54NrLEOpazBR5a/RsiX582QQgiPW8QV2kqxtGXWbi4NFsTfZY9GHbEjWnzwSK0btqePoFrfnW1E4jEmP8PIyzp4PK++QX1mhJ1LiFzoZzpg0mmCIjXwb+ba+b/mZyIEf+Pb84nzBUdcCwbjxdLijxWZwsokvsoK3etKH1kxIwyDUo6zAqA+ti/IE55x+N3UVFDtxn04h/4BOEh91QUmhnRq8b0zHkAlzTBYGbNwhncQlMSZOWi9drRM6iOD6E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is RFC v4 of guest_memfd in-place conversion support.

Up till now, guest_memfd supports the entire inode worth of memory being
used as all-shared, or all-private. CoCo VMs may request guest memory to be
converted between private and shared states, and the only way to support
that currently would be to have the userspace VMM provide two sources of
backing memory from completely different areas of physical memory.

pKVM has a use case for in-place sharing: the guest and host may be
cooperating on given data, and pKVM doesn't protect data through
encryption, so copying that given data between different areas of physical
memory as part of conversions would be unnecessary work.

This series also serves as a foundation for guest_memfd huge page
support. Now, guest_memfd only supports PAGE_SIZE pages, so if two sources
of backing memory are used, the userspace VMM could maintain a steady total
memory utilized by punching out the pages that are not used. When huge
pages are available in guest_memfd, even if the backing memory source
supports hole punching within a huge page, punching out pages to maintain
the total memory utilized by a VM would be introducing lots of
fragmentation.

In-place conversion avoids fragmentation by allowing the same physical
memory to be used for both shared and private memory, with guest_memfd
tracks the shared/private status of all the pages at a per-page
granularity.

The central principle, which guest_memfd continues to uphold, is that any
guest-private page will not be mappable to host userspace. All pages will
be mmap()-able in host userspace, but accesses to guest-private pages (as
tracked by guest_memfd) will result in a SIGBUS.

This series introduces a guest_memfd ioctl (not kvm, vm or vcpu, but
guest_memfd ioctl) that allows userspace to set memory
attributes (shared/private) directly through the guest_memfd. This is the
appropriate interface because shared/private-ness is a property of memory
and hence the request should be sent directly to the memory provider -
guest_memfd.

RFC v4 integrates comments from RFC v3:

+ ZERO is not supported on shared to private conversions
+ Adds KVM_CAP_GUEST_MEMFD_SET_MEMORY_ATTRIBUTES2_FLAGS to enumerate
  supported content modes for a given VM, or all supported content modes if
  no VM is provided
+ Uses flags and not values to specify content modes for conversion
+ Allows architectures to override the content mode application for the
  entire range rather than per-folio: so if actions can be skipped, folio
  iteration can be skipped entirely.
+ Addresses comments from Sashiko [7]

I would like feedback on:

+ Content modes: 0 (MODE_UNSPECIFIED), ZERO, and PRESERVE. Is that all
  good, or does anyone think there is a use case for something else?
+ Should the content modes apply even if no attribute changes are required?
    + See notes added in "KVM: guest_memfd: Apply content modes while
      setting memory attributes"
    + Possibly related: should setting attributes be allowed if some
      sub-range requested already has the requested attribute?
+ Structure of how various content modes are checked for support or
  applied? I used overridable weak functions for architectures that haven't
  defined support, and defined overrides for x86 to show how I think it would
  work. For CoCo platforms, I only implemented TDX for illustration purposes
  and might need help with the other platforms. Should I have used
  kvm_x86_ops? I tried and found myself defining lots of boilerplate.
+ The use of private_mem_conversions_test.sh to run different options in
  private_mem_conversions_test. If this makes sense, I'll adjust the
  Makefile to have private_mem_conversions_test tested only via the script.

TODOs

+ Address locking issue when kvm_gmem_get_attribute() is called from
  kvm_mmu_zap_collapsible_spte(). In this path, KVM's MMU lock is held
  while guest_memfd tries to take filemap_invalidate_lock while looking up
  the attributes xarray.
+ Move guest_memfd_conversions_test.c to only be compiled and tested for
  x86, since it depends so heavily on KVM_X86_SW_PROTECTED_VM's as a
  testing vehicle

This series is based on kvm/next, and here's the tree for your convenience:

https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v4

Older series:

+ RFCv3 is at [6]
+ RFCv2 is at [5]
+ RFCv1 is at [4]
+ Previous versions of this feature, part of other series, are available at
  [1][2][3].

[1] https://lore.kernel.org/all/bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com/
[2] https://lore.kernel.org/all/20250117163001.2326672-6-tabba@google.com/
[3] https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com/
[4] https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/T/
[5] https://lore.kernel.org/all/cover.1770071243.git.ackerleytng@google.com/T/
[6] https://lore.kernel.org/r/20260313-gmem-inplace-conversion-v3-0-5fc12a70ec89@google.com
[7] https://sashiko.dev/#/patchset/20260313-gmem-inplace-conversion-v3-0-5fc12a70ec89%40google.com

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (26):
      KVM: guest_memfd: Update kvm_gmem_populate() to use gmem attributes
      KVM: guest_memfd: Only prepare folios for private pages
      KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
      KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
      KVM: guest_memfd: Handle lru_add fbatch refcounts during conversion safety check
      KVM: guest_memfd: Introduce default handlers for content modes
      KVM: guest_memfd: Apply content modes while setting memory attributes
      KVM: x86: Add support for applying content modes
      KVM: Add CAP to enumerate supported SET_MEMORY_ATTRIBUTES2 flags
      KVM: selftests: Update framework to use KVM_SET_MEMORY_ATTRIBUTES2
      KVM: selftests: Test using guest_memfd for guest private memory
      KVM: selftests: Test basic single-page conversion flow
      KVM: selftests: Test conversion flow when INIT_SHARED
      KVM: selftests: Test conversion precision in guest_memfd
      KVM: selftests: Test conversion before allocation
      KVM: selftests: Convert with allocated folios in different layouts
      KVM: selftests: Test that truncation does not change shared/private status
      KVM: selftests: Test conversion with elevated page refcount
      KVM: selftests: Test that conversion to private does not support ZERO
      KVM: selftests: Support checking that data not equal expected
      KVM: selftests: Test that not specifying a conversion flag scrambles memory contents
      KVM: selftests: Reset shared memory after hole-punching
      KVM: selftests: Provide function to look up guest_memfd details from gpa
      KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
      KVM: selftests: Update private_mem_conversions_test to mmap() guest_memfd
      KVM: selftests: Add script to exercise private_mem_conversions_test

Sean Christopherson (18):
      KVM: guest_memfd: Introduce per-gmem attributes, use to guard user mappings
      KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
      KVM: Enumerate support for PRIVATE memory iff kvm_arch_has_private_mem is defined
      KVM: Stub in ability to disable per-VM memory attribute tracking
      KVM: guest_memfd: Wire up kvm_get_memory_attributes() to per-gmem attributes
      KVM: guest_memfd: Enable INIT_SHARED on guest_memfd for x86 Coco VMs
      KVM: Move KVM_VM_MEMORY_ATTRIBUTES config definition to x86
      KVM: Let userspace disable per-VM mem attributes, enable per-gmem attributes
      KVM: selftests: Create gmem fd before "regular" fd when adding memslot
      KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
      KVM: selftests: Add support for mmap() on guest_memfd in core library
      KVM: selftests: Add selftests global for guest memory attributes capability
      KVM: selftests: Add helpers for calling ioctls on guest_memfd
      KVM: selftests: Test that shared/private status is consistent across processes
      KVM: selftests: Provide common function to set memory attributes
      KVM: selftests: Check fd/flags provided to mmap() when setting up memslot
      KVM: selftests: Update pre-fault test to work with per-guest_memfd attributes
      KVM: selftests: Update private memory exits test to work with per-gmem attributes

 Documentation/virt/kvm/api.rst                     | 136 ++++-
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/kvm/Kconfig                               |  15 +-
 arch/x86/kvm/mmu/mmu.c                             |   4 +-
 arch/x86/kvm/x86.c                                 | 114 ++++-
 include/linux/kvm_host.h                           |  77 ++-
 include/trace/events/kvm.h                         |   4 +-
 include/uapi/linux/kvm.h                           |  22 +
 mm/swap.c                                          |   2 +
 tools/testing/selftests/kvm/Makefile.kvm           |   5 +
 .../selftests/kvm/guest_memfd_conversions_test.c   | 552 ++++++++++++++++++++
 tools/testing/selftests/kvm/guest_memfd_test.c     |  57 ++-
 tools/testing/selftests/kvm/include/kvm_util.h     | 144 +++++-
 tools/testing/selftests/kvm/include/test_util.h    |  34 +-
 .../selftests/kvm/kvm_has_gmem_attributes.c        |  17 +
 tools/testing/selftests/kvm/lib/kvm_util.c         | 130 +++--
 tools/testing/selftests/kvm/lib/test_util.c        |   7 -
 tools/testing/selftests/kvm/lib/x86/sev.c          |   2 +-
 .../testing/selftests/kvm/pre_fault_memory_test.c  |   4 +-
 .../kvm/x86/private_mem_conversions_test.c         |  55 +-
 .../kvm/x86/private_mem_conversions_test.sh        | 128 +++++
 .../selftests/kvm/x86/private_mem_kvm_exits_test.c |  38 +-
 virt/kvm/Kconfig                                   |   3 +-
 virt/kvm/guest_memfd.c                             | 562 ++++++++++++++++++++-
 virt/kvm/kvm_main.c                                | 116 ++++-
 25 files changed, 2047 insertions(+), 183 deletions(-)
---
base-commit: d2ea4ff1ce50787a98a3900b3fb1636f3620b7cf
change-id: 20260225-gmem-inplace-conversion-bd0dbd39753a

Best regards,
-- 
Ackerley Tng <ackerleytng@google.com>


