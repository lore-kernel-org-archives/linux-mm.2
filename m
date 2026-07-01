Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EFB9C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53E616B00C1; Wed,  1 Jul 2026 12:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 516A76B00C2; Wed,  1 Jul 2026 12:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4062F6B00C3; Wed,  1 Jul 2026 12:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4C96B00C1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:09:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A737D140406
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:32 +0000 (UTC)
X-FDA: 84940692984.29.EA09707
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDA38140010
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vKVgzqDC;
	spf=pass (imf23.hostedemail.com: domain of 3uTtFagYKCJ4QC8LHAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3uTtFagYKCJ4QC8LHAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922170;
	b=McCJYHBlb4GNSNMrbIihtcuaAOrwf5OnZAx+vCsyp6/FQVTZfFslTXNUChyOnbOTEEUUPD
	MeZxX5ssQJLulAXAhD/MqTMrJ/R0saBx5vSP4fFfWJhH0Ftm1b8/5K5JuTq01bpiCtUBEt
	q2qPDftfMKGo6/Z71WPCh9FK5Jkbam8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fb46jkRTl6zwGFz7DUfAUgbXgotI+sXKJjyrZvcz3JQ=;
	b=koJNrx9t4pEc8HAWEDe90F/xTTSqarY1Hk/0KPONWQvTZI3Tzi1vfTeWBR5g82avk/3AyH
	F6nFBcRy31jyEKoZwKqa5r3ZdzIM42JXmqH844DdhqRDnNGnaRwWSZekYh/NVQFt145Tge
	t3uubFnDwi5D4RokYubsSMhN/VqWeX0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vKVgzqDC;
	spf=pass (imf23.hostedemail.com: domain of 3uTtFagYKCJ4QC8LHAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3uTtFagYKCJ4QC8LHAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-37d125687b6so898510a91.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 09:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782922170; x=1783526970; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fb46jkRTl6zwGFz7DUfAUgbXgotI+sXKJjyrZvcz3JQ=;
        b=vKVgzqDCoSuPavku12oJ72bsFDlfD2k9KgD6lGYS1gtrUcAYs6xdEtj+gm5ZvZxCL5
         P0Ojej3ZOemxtV0yxDZzHbGdL4Vxvfih4j6DtOthE8UC03J7qm/eLjxJe2l3kfQvjhUe
         BaXyvBwFQI74JerHRQ6EV9t1VKEVCRrUbdTXZ0WAd2l9ydOhZNQkwvJhVlqa/9ZVNypm
         FGPDMKCHj08JhXPzkeA4ZdbpN+QGJ+FQHe4f+g3HASEcaR997LUq3zwnfnP7V83qdIo3
         EGitqRFnUx1Wo/J5evL/RORyAFQNmbO4g5mmbaGov6flauZrd+BUnvky6qdNY2DNfeJC
         EAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782922170; x=1783526970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fb46jkRTl6zwGFz7DUfAUgbXgotI+sXKJjyrZvcz3JQ=;
        b=cbB1Sk3yC9Nd/tE9aGgfkTfnXSoU2gh/TOIhuVLvEugMsJsRWlWw7M84wJ4IuCYOHm
         8xBSu5Vl5XD4NcRNaHd7kNTeDB0h7B3xOiRIv43jugbs6mE8OVeYbDYi3NYKsGBSa5CB
         NxEJaimVZA59p+pJm+DhL0TdZlGHu4/WkeuvOIxB6ZLqFG93pCJx9a+NfDSu4i9eYIkR
         HVlrn7gZd173pVo0EyWkPaqeK0NmpicQzPU1UtQNAm35BnALkopLqdRqjFJJpyEFM+/o
         UpUem62dI88ytyXGm+PCyZbMRqDSmgGCVLgautHoDnYepxLS5ScXa6kyggzuwMeYHJXL
         vzqQ==
X-Forwarded-Encrypted: i=1; AHgh+RpPAfetV2k91puJGT+RX+RV2Rlt4eJK7HoaxwhAGZ1gXhah1hUNW9GRKpbHLZrw2NrBJ0j9dBFLuQ==@kvack.org
X-Gm-Message-State: AOJu0YzX+s4KuZaS9wR6Qf5lpeN6hZ0vpd/JkRN2x6Z7HLOK9/IIpq0n
	GRPZC17lGnRVMZCdbHUXLuvMxookXxWHbOeIByCokk/toSR1eyMtfL4JToszG0bvPh1alpBj25f
	rryPXIA==
X-Received: from pjbnl12.prod.google.com ([2002:a17:90b:384c:b0:380:8669:e33b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c03:b0:37f:9ce3:ca96
 with SMTP id 98e67ed59e1d1-380aa20dab8mr1881109a91.31.1782922169200; Wed, 01
 Jul 2026 09:09:29 -0700 (PDT)
Date: Wed, 1 Jul 2026 09:09:28 -0700
In-Reply-To: <584a8f9a-1538-4f8b-b576-75ef0fa961c7@intel.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-17-9d2959357853@google.com> <584a8f9a-1538-4f8b-b576-75ef0fa961c7@intel.com>
Message-ID: <akU7uAKb5E_Tklx-@google.com>
Subject: Re: [PATCH v8 17/46] KVM: guest_memfd: Advertise KVM_SET_MEMORY_ATTRIBUTES2
 ioctl
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: DDA38140010
X-Stat-Signature: ngi55iaud1ohp3ewe1czmn5k7rdhyhbp
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782922170-170777
X-HE-Meta: U2FsdGVkX18Kg8gNKkKM+izYuOUHho1M8BBE+OYc8GOXURuXhgl33WFbmV6uuMhSzW7jVAvWq04X2oNpejAxz2gpBqJW3FhyXBnSRlpWmenNn8S28jomweDgsEXWCaXJUZJkHv2Li4LOmtueOnoWfo7PAnNAGbxqlVfsrkyIe7Fhb6IOF9xB3XoNis9p4MrzHAh7BvIvozciSkb/Ne1Saq59szwgDmONDLfR66OzfU0Un2YX7dqSTpU5QYyhqbE+/ktWFguqXOzceasQXG1ISiA/nKuSTT01j3a/xZImQWY8UKSNP+iL031gG2irZ0YbXquTwU1+5PLB7YhSxdfiI+cYrNI4d00fS/JzVU+y2jU5M5G94cwDjWHf8hLFwQ22vsn2bRg0OLz4MesXeKyH158WbeHbtjTAkXXs7g+yfJBUQCWdilLuaz07Zg6Rprs3fOyg4QVkp2UYkn3hulS75/iN8on5FeOjwOPwtDunMJ1ZK7BKZuIje0p4IYOHtiTz4YkelgwZKgBFJCno+6MXg8pbPsMsI61s8TUJRC/5cezqGmcj8tQiSNNx0GXPC6PE0oATq5DZk/+zcY4rm+M7z27BvbBrC1UjfLEQ1QFTkaDpXFhXy0l0+aJPvM900jWk/07G/xxwysS90k7ZHfG/s4OuK+HqHLVHN6/Gyxhef9UbiI/uEQBIzeaz9ivD2S6wjdTTevaPbkgaqIa6fAU6NltNuOJegqFc3zZApgQxdzbf3zes1lzwYK5yOqdNMHhWRAv99mHxsmyWrRWlnsJqdNfaY1zAc9IG10EUnIAZJpJq6bc3zSkrA4nKV40fnp32oaYidrYmyzOgcr0fkItbey6In6QGzOzLTHeM+olXikNbwJonNQya67iR9BbS/3HC1pN8TSwMDPc+z+Jeswr9mVwMESH7MclVL6bLmWkle9QwTEYkjZT/CAp9ppPU0r5qr7qEl/kbj8G2bvGJ1Vg
 yz5qtROr
 X3jyilaXE4Fxk3NaRhGvJuV26l+tGlkNxgGZGqDTbV8uvW//vBzevP5pJQm89M812Zek9xzoCW/CHMVm8Iq2E7/2f8810eaN+KbpIMcpWZ0rEkN4mETjDlw++Is33Z600Nl7/Zad4tgUfDAGLbo9aR+4CqzQxUZtu0Ko+7ReRg+81PYjaFEwkP5K5dVTiDb/d3x7YvxG2i2a65i3O45vgP4UdI8TFgScASwSnMdlHG6H7GVq2M2Dq9e6e/HpGzNRIMFoNCPMpBrxNN4DS4FvcqPTfu6CnAzMeARxPAOe7oA0Zsjk30n5zmu+BrNTaiymA0v3CSxeT+22WJBHbgd2HNGaew4Gue1uJbGReSMNWZUdV/uaYK21dDIIbTl1ZEXYLMTWcQ6kcKLAtQzIpMhBzshW9xWWgelPAQRiBPdsuiHBtIVa2CTaB6AEG3md1Zg6kimB417U6/xncR8K+JtWm2YJyfHeKhgTuctYt2J3hrjCOLslcjAySy+5KEURpShQ9e90K1MNMl2pvK8TX1QcEMLBZD8EzAvFCoUsrnNUiD4TCIgYriqvDug8U4zyipvmF+c2fdc5ckdi83/cbdr482B5wSqoD2hL4WAD/u2o/g6w2MaTiMyy/pBMWNPWmM7gbHtJtQ1T9oSg8VAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026, Xiaoyao Li wrote:
> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> > @@ -4969,6 +4973,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> >   		return 1;
> >   	case KVM_CAP_GUEST_MEMFD_FLAGS:
> >   		return kvm_gmem_get_supported_flags(kvm);
> > +	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
> > +		if (!gmem_in_place_conversion || !kvm_supports_private_mem(kvm))
> > +			return 0;
> > +
> > +		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
> >   #endif
> >   	default:
> >   		break;
> 
> this looks inconsistent with the
> 
> 	case KVM_SET_MEMORY_ATTRIBUTES2:
> 		if (!gmem_in_place_conversion)
> 			return -ENOTTY;
> 
> Well, the check of
> 
> 	if (!kvm_arch_has_private_mem(f->kvm))
> 		return -EINVAL;
> 
> is buried in the following kvm_gmem_set_attributes(). How about moving of
> kvm_arch_has_private_mem() check to put it along with
> gmem_in_place_conversion check in kvm_gmem_ioctl() in Patch 13?

Me confused, patch 13 already adds the kvm_arch_has_private_mem() in
kvm_gmem_set_attributes().

That said, the ordering here is wonky and misleading.  A cursory read of the series
would make one think that waiting to advertise KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
makes it safe/ok for KVM to plumb in support for KVM_SET_MEMORY_ATTRIBUTES2 over
multiple patches.  But that's not actually true, because the ioctl becomes live
the instant the code exists, userspace doesn't need to wait for KVM to formally
advertise support.

To further confuse matters, it is actually safe/ok to iteratively add support,
because it's all effectively dead code until "Let userspace disable per-VM mem
attributes, enable per-gmem attributes".

So, I think we should go a step further than what I think Xiaoyao is suggesting,
and fully squash patch 17 into patch 13.  That way the reader doesn't have to jump
through as many mental hoops to piece together what is happening.  It'll obviously
be a bigger patch, but should be easier to review/understand overall.

Oh, and that combined patch should carve out error_offset straightaway, so that
the full uAPI can be reviewed in a single patch.

