Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B10DC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 18:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49FEA6B031A; Fri, 14 Aug 2026 14:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457A66B031C; Fri, 14 Aug 2026 14:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33F076B031D; Fri, 14 Aug 2026 14:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F059C6B031A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 14:13:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59BAAC01E1
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 18:13:20 +0000 (UTC)
X-FDA: 85100672160.29.80912AA
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2E602A000C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 18:13:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fZNBzp1n;
	spf=pass (imf25.hostedemail.com: domain of 3vFp_agYKCMk7tp2yrv33v0t.r310x29C-11zAprz.36v@flex--seanjc.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3vFp_agYKCMk7tp2yrv33v0t.r310x29C-11zAprz.36v@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786731198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXgZWbJY+AFNvGsunVK4VPpL85oG6gcjHAIado0UDKw=;
	b=VI1tYkvI9Mqe2hw8W9aaCtfdELYTLEEOzj2NfFbEGNgTx4w9/L1Wf0dddgjZWKcnCQZbme
	53WbvY2edNd8jQdR/HgDWHo/sjkTyY0iBHpbExbs2fS2XUifBEE2ix4UsOxXQehedz9qTm
	8NrYFtmgFSyp7rXrv2SmStkx+DH1SE4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786731198;
	b=hpogzlIjaR0nyvxaWSb2ZIzG9cRO47lZIB5EGinCzsnK+jV05y3LIaQT/hlz34cK9GnoRI
	4tltLvnC2UuxkrbANZ5jMr2wfKId+n4loNBTV/+Vyg1UtfkUHhyvw35pZs0yFmA0gxBCEz
	z5uBJYK4venJ77k4s2gzaIyzy8GmpIE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fZNBzp1n;
	spf=pass (imf25.hostedemail.com: domain of 3vFp_agYKCMk7tp2yrv33v0t.r310x29C-11zAprz.36v@flex--seanjc.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3vFp_agYKCMk7tp2yrv33v0t.r310x29C-11zAprz.36v@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb5ea36f969so1425914a12.2
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786731197; x=1787335997; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IXgZWbJY+AFNvGsunVK4VPpL85oG6gcjHAIado0UDKw=;
        b=fZNBzp1nfX/W7zblkDkZrBKU3i+VzGR59b9MYyVr9O3cNqeywSyJoBnUwzG+CcM+Nw
         wH5X9J8p7ERrQAlhBF/UBChOsKqlJp0iL7szeHJ48yTzWh3pPWeAqJPuEPDEbRIjs4W6
         YaLrR+6ya0ZT75du3SS18oRy9Ja6o3+rIM0/M3ZHLnRD703hf6whZnP9ukDmg3UALJRY
         q4EOZ2A+iEwDxyTt9F8B1eeIz5RaRCs42uMuee1JexAgMseORZIVLL76PS1uSg+z1+Wr
         8rJ0G+KQv5vGrzP+wotHJHgHJ3D0cHqCfRIp9P/EabfwHHo94ZRh+U9+WFaZ2Njs9kOd
         4Tpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786731197; x=1787335997;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IXgZWbJY+AFNvGsunVK4VPpL85oG6gcjHAIado0UDKw=;
        b=lwQ+Kg5ihBC7vZ4NkFoeZh7jyHLjcWahsX+9vjp/9arDswjyX6DNVHYAhtccztdgUP
         neC53ySqlWODw+50dM6e5x+aLHox1/glB9jL/beNawi9yKVyw66h8jp8Ma44Huyp5NS+
         tUwyuJfrDO3L4u5VgA/5tg5MXXQMJspqBvXUd2JYCnQWRcbhqpeO2drd0wl0z4PZcLcP
         hQbVc2xesf41YelV8XDtH6gDfrpstUxTVwJFnU0el2DcN7/GeCGichSIpd41BSQYY0Lo
         r734k7yJ+87m1MjlSPhAeOQGUjdxR6IdYaoML8RGLKslFwWxH2bRbm9zftSXEM45v2oe
         dW5w==
X-Forwarded-Encrypted: i=1; AHgh+RoLkogG4DVxPc2C/XI/S2qZDyw4LZHoJ9NAHBc8aW+o2ws9pVG7eQ+S+ZI1K/2ZMWpol3DzB5TkDQ==@kvack.org
X-Gm-Message-State: AOJu0YxBidB9b9WdrMQUjtC7KDVQHrFD+H70SGRlfb/ujViCKlC2f5LY
	EXMAw98Sf7YnZb3+iizq7kbnoBbZtOTuwB1eIV5oLAgoU+Z8vI80X2PUbk2BzFaBSAzy+8iiP5z
	LIPS3AQ==
X-Received: from pgkg8.prod.google.com ([2002:a63:fa48:0:b0:c9a:d174:5315])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7316:b0:3c4:de3:816c
 with SMTP id adf61e73a8af0-3cc71ed56f7mr9388112637.37.1786731196579; Fri, 14
 Aug 2026 11:13:16 -0700 (PDT)
Date: Fri, 14 Aug 2026 11:13:15 -0700
In-Reply-To: <f41624da-8461-45cf-b555-241091faeb63@linux.intel.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-20-2fc18ee6d3ba@google.com> <f41624da-8461-45cf-b555-241091faeb63@linux.intel.com>
Message-ID: <an9auxaZBuTJCAr-@google.com>
Subject: Re: [PATCH v10 20/41] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: a8g7np4tjrqs3caq3fyc9bhaofy4eo5x
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2E602A000C
X-HE-Tag: 1786731198-582253
X-HE-Meta: U2FsdGVkX19QxAFcwxJfTPQn1AmPhGUYN3XoFIIYGsgKQBXYVRJi6dGE71BjwYUYCtrwazPa9FLsgkmtqZKDdj+S+aRE/sVRqRf7FoX51Z/fqNsg2WFX1yiU3b05zBnLDHycnYTgz/Us6LwPr+dz5m9/bI2oKLuZne7RkyJUchofMyBqdxxQUXY/K5PJHLGLfPI+lGvYa+m0OfacO4rl2WgYNkxV+S1p7WQHYyzyZrXuXpkLK3bAXyH/HuuVrFjq7pYu2+8a7kfhBuBJMtpCAKXHbk02k14LE/TqF/VB9IuP89TzJ3omCYexzJ6TAeNtcDEydt/BLdV2nfbIClOMOetMhQDEA+GTF84aLSVG6LL/JJD5Vs4oBpFSw9zqr1P7nirSMmDVUsab8/eRgexuFFn0CHmIJunc6Ba39JTshjP557dmt71Xpn3WCZ0rYGxUtLj6jEDF061rTzelKELLCb0589GYMjjmXAECH4lwL2jVRJGVVi2cmUBUOBgG3w39bJY2jc6AXWzwY/OTHxgm2nHqO6lTq0bWfCU/KoE6UzB9qiMhXtElppQltCoWQ6WvC3hBC/263tNihAlZCuwbTBQia962yXrUG8u69gN+UNo1vsqAif6jBhVDQS9DRce7rgeWfbMFlvaqkwTbJ8k52/WmNSzm7sZbLgY0hYHox8E7MZ9QHn+fvzpcIeIrVZkOLUSJwHOikL7zuOBU8YTrl0Meb+ysxnIRI+MUftB2mIcDLu1ZPUzM8/Q+y/x4iMUkAti1Mpj/dSmXgpVNoGuOU4/EZxF6fPiRTj5DNOT57TsyAsNrVyjK1EAYCv4444Sdq10kLtSZg5ST0ErcE5cB+catBX9h7I8N1m28p/KkVL6UPf66bIApjEwP8BjG8b0n43XegqptO+y81s1BYgnPY6eIwkywBf3x+bsut+JpjOr4UF0mh9/Dyie5hTEee39aCiePWBmDgOt1DasitJN
 mRosRfOd
 qtf4cfUAPoAokd+Hn87Tv/otivtYWOpp0aJTQSDrQo/h1MOUwckIR0lTINHD8vSE1TKRIgWaDJlldIIJsow/AWn+sUZr6u7zolUZHR4VdX5TaHHKTo3pcjF0XFFYRlrtfmUeSi91KDOrYeWziUrFvnia2herut5NymaEeKUESq9afX56au88GGwmx8cxcxMQgmTPSuiqkC/ZWEKKu99RdnkMojxRAsJ3rmcOeKeEIx+BCTYbaiZCbDe9ywV2fwEghFhIFx0ACrfxqkUJgUetQ9uK9nbsbpM/EfZm71hoKXRFTEFpds0faKwsuA6NsZzsRyXYMQpNBaapdyRnsdCZuzhrwoYWwbJIu4f1QCZUo46JYqA7OaJ0oljf4RHeE8TawtZXp34bUKZPOj6IcbU57+LqKRdhcO682fcxz9VYh1zcAA6O5Y9KAAGeZPtkJCQWKiWRIB3hgms14xSWzwluvgfytkJzp7X1dgvPOL6lek8y+VKP2iq/va+8wjUksbUlDvrwOjkv0OJFQsd0PZyzXv37915EcG651d0oAsqUXXxzwSD36/iV3y25OmpUedNdZ9om70Tg7CnvdukrRIT8g+JGOKflwXNtcgWs6Io8GGoRvecE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026, Binbin Wu wrote:
> On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> > 
> > Make gmem_in_place_conversion a module parameter so that userspace can
> > configure enable or disable the use of VM-level memory attributes. The
> > module parameter is only available if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is
> > enabled.
> > 
> > To avoid inconsistencies in the way memory attributes are tracked in KVM
> > and guest_memfd, the vm_memory_attributes module_param is made
> 
> The description is stale, since there is no module_param called
> vm_memory_attributes?
> 
> > read-only (0444).
> > 
> > Since selecting CONFIG_KVM_VM_MEMORY_ATTRIBUTES disables in-place
> > conversion, 
> 
> "selecting CONFIG_KVM_VM_MEMORY_ATTRIBUTES" doesn't necessarily disable
> in-place conversion, it also depends on the setting of
> gmem_in_place_conversion.
> To be accurate, maybe add "by default"?

+1.

Ackerley, please write changelogs in imperative mood, i.e. state things like this
as command, not as a passive description of what the code now does.  And I would
omit the blurb on changing the kvm_arch_has_private_mem() definition, for me that
falls into the category of giving a play-by-play explanation of the code change.
I.e. Let the diff speak for itself.

E.g.

  Allow the user to disable KVM_VM_MEMORY_ATTRIBUTES even when KVM supports
  PRIVATE and SHARED attributes, and expose gmem_in_place_conversion as a
  module parameter when per-VM attributes are supported.  I.e. let userspace
  enable in-place PRIVATE<=>SHARED conversion of guest_memfd pages.

  Provide both a Kconfig option and a (conditional) module param so that
  deployments that use a custom kernel can fully disable per-VM tracking,
  while not forcing distros to ship two separate kernels in order to provide
  backwards compatibility for downstream users.

  Don't allow running VMs with mixed tracking for a given instance of KVM,
  i.e. disallow toggling the module param after KVM is loaded, as the extra
  complexity needed to handle per-VM behavior far outweighs any potential
  benefit.  E.g. neither TDX nor SNP supports live migration, so in effect
  the requirement is that existing deployments that want to support both the
  old and the new models would need to tell their VMM which flavor of
  tracking to use.

