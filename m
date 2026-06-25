Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C8ABCDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 00:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D566B0088; Wed, 24 Jun 2026 20:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53DA96B008A; Wed, 24 Jun 2026 20:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42CE96B0092; Wed, 24 Jun 2026 20:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13BF66B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:42:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82CE81C3303
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:42:02 +0000 (UTC)
X-FDA: 84916582884.13.AC26DAE
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id D16AFA0003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:42:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vNitNYsv;
	spf=pass (imf15.hostedemail.com: domain of 3V3k8agYKCJQG2yB704CC492.0CA96BIL-AA8Jy08.CF4@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3V3k8agYKCJQG2yB704CC492.0CA96BIL-AA8Jy08.CF4@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782348120;
	b=4ZOcKGirAKSTpFsym6SJPACxmi0z4qUmn0//SYM3kysPHWE+yDJGrUcu3cNOaOKndBy1OF
	ucpgFfR4402CWDxocKsUO1paW0pjZm5JVeLKFXV/cAqf9ZpB5yqWIdV6a75y7265QqrCaQ
	nRNuL96QZ/LT7xYfDSdOVgGZYqu9Og0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782348120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4DFjavBCbzblLm5XoFLaw3Sc1sbInL5uPLu8y3/D5AM=;
	b=hUmnpLWpfuOh7Fss9Gq991RIXBXwJTCCrH23QV9xC+OgFgkzDTHu2akqpaugDcH6+YGIkF
	g+P990HpCCxlaA+NBlX+mBDE6BeOkZ1lPYfQbj9kLQx+w8qHuc/wbo7zC77EgWucykFDVn
	BcEbFOqVWwcxG6uaBvBJC4rEPdIuESU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vNitNYsv;
	spf=pass (imf15.hostedemail.com: domain of 3V3k8agYKCJQG2yB704CC492.0CA96BIL-AA8Jy08.CF4@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3V3k8agYKCJQG2yB704CC492.0CA96BIL-AA8Jy08.CF4@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c889d1eebafso1929664a12.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782348120; x=1782952920; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4DFjavBCbzblLm5XoFLaw3Sc1sbInL5uPLu8y3/D5AM=;
        b=vNitNYsvBb4pvUIRU4ej9l4nTyLOt4U+zy2CPBLCALDVn4xH9rTsW4UELvbzGrovB3
         +yWQofAqxQaitVe/bs3YQPqP1OYlHVPDsSIdZhxs+iHLitcH+jfBTGMbzSX6H38kBj0y
         jerroWxI1aW97gDR3DjLtk9I0WnjvvU7KvGbyZMYUFUzk0iIqqo1ttuhriG8Rkuz4/y5
         hv9eSxAJ9P7UNJBvcTJIbJcNBwPcR7rdyo1j8SX/UgWTWa9iCIku2zxw5ZK+AbfMhp9s
         UvR9PowWBdjD7PPBTkxirwKA66iacEg1e8XqWSW+bd01nPTnGK15+KLy8JadvI/ShzGq
         atrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782348120; x=1782952920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4DFjavBCbzblLm5XoFLaw3Sc1sbInL5uPLu8y3/D5AM=;
        b=nbEQWJ3fIJJ/X/YG2Wm5TzeCbQYtXrM9XXFgp/kPF+Jreb2bvUDidYk6hB8v8dMPsR
         aYdDuZcRtp4c4ZM0HZIu4CPk1WYDhqI7r3de3i5ygSzpwlBr/hzMVCBptdNBJRTvciBP
         CU0ZCbdmvh/h37cnnQ+UPzG3hBv0oR0vFI/j+2wLLxc6dP91bdSTrf2oAozV3p1zC9le
         nQ8kGE4GVRnTo1RKBW7qHq+pvtEhzunrOktVGSwxIJHZMsMEW28w3LDHfc5J91tl+LPw
         zy1W3JEabDvgdAw/hS05Uyu7SBm8TGiscUxHAg3uoxvS9MXXrtnE/P1CX+dL3i0Ig6HH
         719g==
X-Forwarded-Encrypted: i=1; AFNElJ+ftrelxkTLLLGGGSbayNvyMUrPClSBw5zaO4G06HdRSTidWi5BjU9ZaEm4spCRkKHDLnUyyCGZWg==@kvack.org
X-Gm-Message-State: AOJu0Ywui8xV0S/PjIJsygCwKOXpyVQOb1O7gE571BkbV0XKvZpQVbqT
	lSIXqy9Xovw+Kymgyb8u28yqTsCwWvVwvHgM4KyjyPoMJgrDIp6UFNlKh8VigCpLkN21d64GJjS
	O7BA4Fw==
X-Received: from pgbbo12.prod.google.com ([2002:a05:6a02:38c:b0:c80:296b:72cc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7fa3:b0:3b4:8bc6:138
 with SMTP id adf61e73a8af0-3bd4ae9cd56mr397852637.23.1782348119218; Wed, 24
 Jun 2026 17:41:59 -0700 (PDT)
Date: Wed, 24 Jun 2026 17:41:58 -0700
In-Reply-To: <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
 <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com> <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
Message-ID: <ajx5Vrz9ma--hrGH@google.com>
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the default
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: usrbicoh8ba3f3do9ie99qg8ca358uhd
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D16AFA0003
X-HE-Tag: 1782348120-570176
X-HE-Meta: U2FsdGVkX1+CM6FGVgZn5XgXUW129rFQj+pYiM7YOb8LaRna5JpNW5PLpyAr4pyj4s5Z1IrzNE6sX4GT5kADDfqrUWtdwUddVxC+mRnKBR6zFbsvAxVOtEWPEm2GxmnNb+0F49d8y6PjOcmE0rk3FiPOWKyscNjuPi8lNWIceGwapTiPsxesgrirxBh02/BfGbB3rwz6nWl80+vqhssVIzHHzkwvLdserqol4eX1ULExB8W+TZtfvTxovsyusJEDVZ3OzJzkcL7Tgl8EuJTTvWLZ8faTMGqac4F9GhJ78ra4Srto7VXRHJbg2/90XEhsHsHSEvLUJ1ABf/3L/sTlo8YEbacaX56reUg0p42NeyMfp36nGR93gbHRaQsTXNheanyVsfQZHu8KqnUeMCmitGBb1y94wpE0e2ifGu1TOt7bZhXHzmVaca8Qq9yJX+ldWWY1M6sgs13OH6wdoSIGpYyLfOdtsE2pZeHP+gw7t+hnEd4PX+lGDaCpJc8uVtqxjo9SD3gzAZeoh+ChjEnrOmiI5j+tSfkaQi7TYqnZaiynBG7d1zv/JtHAL/3d93lvHHXFwjCn0QxlVGLivZ0RRRJt0+ReKO3UMB4J1fnINrbXCEeSPOK1MgW+yvbVO/n4DMH59jKHc9C/YJ0gs8p9bDSoPK7cv8mFImnZETPYNSApfX1YO+9D13eaDHc7pydtRAHEB6NTBHFcL4o2dpQAoh+sM6062pUgYcMWJw+FB1mcGlshUYzV28lFgz0JXqJkHoYDidb3wIg0NWlqIp1g8JkjDAWgQ1y0hFIIURU/wcT8CO1VqihEr30dECGbdDBaRxbsUgnoSGnX78Xm/bROknikV4gXJchn/IevSaa/qO7TB3g2iAh82lAfc848k9Hr0kvI275EdhwFDgeS3GXkFoKQMQCCeUYjABa+2t6xZFqdGF8eT6Tk+iPfZTziA8R/K8LR8ABHOuGkLLomzp8
 eKZKggh7
 BrLRE5zfmG/OLSyswyyLI3PgYV+T2jq2j+wPvH8QvhI5DtcfDyL4eDD9VohDeova8DaXT0AvfGw33zsUN4MWhGppAc/q7NbTZR2wxRCfsbaUb3qv5kt8sf920hZubEkcJWfeaPjw8bqmdB38GZVI+k+au61jFTnf/Tqw7hujk6etjfY+sZPPoD9ev1zhlupxYJvd24AoQkedukstLV4NR5gbMk7etRSDqiFbDu0Ka294G0iHOlPfbEZw3mJ+prpAllvERkgYWBDyrPmz4M9CdzJejhPYmeL6L5J6rrRZ+26YbSrHkCPZFNDBFY5pyaoIDvh5vgPWE8wFkChGaSg4tjUmp+LtLH8te4mFIBaIcPT5lbBfGJ2ZFmO2IU6bpGAOlvHZ1VN0tldEugDQ0qwIFLxkQnu3NA0q3gII0kLtXj5ViCkUmWK7DbLQ5osmoyHCFAxMfnys8HMlQQKPKODwogpiPzzZ0NI2X6VHawsc0TUojuK+SpnhE+tOViLyRp4a28sUJeRnKiQ09eSEa8KCGodf7BuE5Hb7NXXemH+hr1wZxwMzf/XAYzjpX5hz0qHje3pAmBr5NNUTqygdnQ8kJ6btOddinfKb+0OV5a8zOnhgCEStaj7XYMmjHTXy0FKOZhVLZPhCiHHoObdalyfrBfl7IlqU0jyE/7yEW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> > With gmem_in_place_conversion=true, userspace can create guest_memfd without the
> > MMAP flag. In such cases, shared memory is allocated from different backends.
> > This means this module parameter only enables per-gmem memory attribute and does
> > not guarantee that gmem in-place conversion will actually occur.

KVM module params are pretty much always about what KVM supports, not what is
guaranteed to happen.

  - enable_mmio_caching doesn't guarantee there will actually be MMIO SPTEs,
    because maybe the guest never accesses emulated MMIO.
  - enable_pmu doesn't guarantee VMs will get a PMU, because userspace may elect
    not to advertise one.
  - and so on and so forth...

Yes, there's a small mental jump to get from "KVM supports in-place conversion"
to "I need to set memory attributes on the guest_memfd instance, not the VM",
but I don't see that as a big hurdle, certainly not in the long term.  And once
the VMM code is written, I really do think most people are going to care about
whether or not KVM supports in-place conversion, not where PRIVATE is tracked.

> > To avoid confusion, could we rename this module parameter to something more
> > accurate, such as gmem_memory_attribute?
> 
> I asked Sean about this after getting some fixes off list. Sean said
> gmem_in_place_conversion is named for a host admin to use, and something
> like gmem_memory_attributes is too much implementation details for the
> admin.
> 
> Sean, would you reconsider since Yan also asked? If the admin compiled
> the kernel knowing what CONFIG_KVM_VM_MEMORY_ATTRIBUTES means, then the
> admin would also be able to use a param like gmem_memory_attributes?

No, because it's not all memory attributes, it's very specifically the PRIVATE
attribute that will get moved to guest_memfd.  I don't want to pick a name that
will become stale and confusing when RWX attributes come along.  The RWX bits
will be per-VM, while PRIVATE will be per-guest_memfd.

