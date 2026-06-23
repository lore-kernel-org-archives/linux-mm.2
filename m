Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE1E9CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9703C6B008A; Mon, 22 Jun 2026 20:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9471A6B0092; Mon, 22 Jun 2026 20:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837436B0093; Mon, 22 Jun 2026 20:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 423E26B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:22:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7E59140326
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:22:34 +0000 (UTC)
X-FDA: 84909276228.14.D268788
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf22.hostedemail.com (Postfix) with ESMTP id 05B11C0003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:22:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GeY0iv38;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3x9E5agYKCKocOKXTMQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3x9E5agYKCKocOKXTMQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782174153;
	b=KTpQveuZgrGhk0Po21EkfJPh0yygcXoNWOUCMQlk3MP7ez6a044VNaT8VNtWXDLpm1V5VC
	5hwNAJsf9swolSMNnwKzXIju5laEQNBS8Y3yrgU4Uj6AyAxQ4ySzwgsnWI3EJn/JG8JPyt
	1xYZw1Wz/Bdfbl2K06P9oZCDuXLaR1U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782174153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQLsIF+iVXLuEt9X7AENLYAj3zuZSbHkrs731kL+O+A=;
	b=4Ymv7twghzmBGzM8z8B5yZhzArtmQ/92crsFNvbvoSgythUhV2OFuhkPWqhZkZzCnfBlQ1
	w7bAmhqhhAZokr/ChVtvvrq8e0nXEE8pQCZ6DaBeg61qmkJgW1kFd6BMs20B49IzQqi/5P
	O/4RiUcjIKOcqkaF24gumlO0fu96jpA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GeY0iv38;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3x9E5agYKCKocOKXTMQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3x9E5agYKCKocOKXTMQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8423970cb30so3698876b3a.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782174152; x=1782778952; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oQLsIF+iVXLuEt9X7AENLYAj3zuZSbHkrs731kL+O+A=;
        b=GeY0iv38oUIrRlKZvrkBT141nWyTb7nF2Xo2b015XDAjxgsVIptqucvQf3c6yi+6+3
         F3RQ2OENo6flf7BG8oOcNa9RoTJTl/oqlhRzxBhbXQ0yyV43A2Ry64zCitAg2sBbQKcK
         OZHsD6U8eJAhz6MVuXrcF5vW2KVNDs4DjfmDLsRB3ULjzgOeIhTQ03fl978zDrXs3LJs
         p1FYlRQhcZ438P5euvwQEnYrWI0haKO0tfOBBAcIVg8XhHBb+WI4LWTNSjG8pplpr3jE
         bFcn2dsgFyhV9+kgFepTChxm6e6p+BeTU3h/x6D+BrYwV0dLKDgZ9+3ZkSC+tPqtuY5a
         dx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782174152; x=1782778952;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oQLsIF+iVXLuEt9X7AENLYAj3zuZSbHkrs731kL+O+A=;
        b=gJwfbZT+rcPKABmHVnnTIPnqopCwU3/KM3XkjBdlz+/IkI8QCQ6YOwsJ6Z8JhoLlDG
         miUa2BVuJyt4WegKyhwwWhrMWBcN0nG0Bp+v70yfpSF4pEWp1jwC5vhm8LttGt8KQgBe
         1upMQfta8BRKap7dwYwzVOvIvP2ISYfPLrnnfM6sE0uPBFpyQVtzGs1CfYuFXX3jQPC7
         WL0FTRCfOG849EfPVjTmK0ii88N5W6wScNZkwaiAidRVqIKnvhWyEZRxZi6klhgw6YdY
         6eGYoIZOnxg0PZKM0xppOqnX7qvYe6nf4sN/Y/+jIICTx13757utA0irCVJlhxK1Qebo
         xVzg==
X-Forwarded-Encrypted: i=1; AFNElJ+fMA3biHLfr/S2Q/j2u2OhJ8+bEu4x4J1D01tDehBIJmGDA5Jy3eRVY5cSNWPRtFbArIbsxmK0nQ==@kvack.org
X-Gm-Message-State: AOJu0YxbQOmbHIwrAEWnfyYZG+YWMd7WNEj2rCKbI2ejTJlpCDjtU3nn
	XsqXhCZTNRa7Cd8mcRvNRAclTj2nO8DYjtrQJEv5x2j4MvPToT6aGojR9Z/sLwdeiKSYp/BruOL
	zD5/cjw==
X-Received: from pfbk14.prod.google.com ([2002:a05:6a00:b00e:b0:82f:8cba:4285])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:855:b0:842:3be7:4d55
 with SMTP id d2e1a72fcca58-84597094577mr199419b3a.11.1782174151143; Mon, 22
 Jun 2026 17:22:31 -0700 (PDT)
Date: Mon, 22 Jun 2026 17:22:30 -0700
In-Reply-To: <CA+EHjTx2xKjheiW5VzHw_TdWFUqdJqfgu=dOPa=_yaYBMY8uyw@mail.gmail.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com> <CA+EHjTx2xKjheiW5VzHw_TdWFUqdJqfgu=dOPa=_yaYBMY8uyw@mail.gmail.com>
Message-ID: <ajnRxuJ19OzZ8zJC@google.com>
Subject: Re: [PATCH v8 13/46] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05B11C0003
X-Rspam-User: 
X-Stat-Signature: ac9hndsefc8ixtifu57a5hj5wid17p71
X-HE-Tag: 1782174152-412073
X-HE-Meta: U2FsdGVkX1++dcH4PLqk0tkXUbAjDkXvs6tEdCCPdL8aB1KeWZ2/rpA6TZ9xKuASUMjMjJQUs3SUX72uuOxUeb+rnDXUge0WLFgDU1kAs5mhIJAFiv2hD9OrReasMKMI+csK+PrfU/LUHbsiKzLquAuf3bFADjt9U8xEPIsTzHD78Y1lgDjvBfH22Od9u8P3BtnpvhZx86jVVtv8T5ztcQbem73Pc6RyoxuCxY+Gj+rPjVl5nwV8T2/JjeRzpILghXKO1q8QTkOZFRoqQCKY131wxjiWGJpuB5OZyQFae4WNcZe/dC/YogMhGDQCvQy2Gb2wGov75yk9s2LT/FHfMFI/LpuaWiXcR4XOKlbnxRobJaVpAR9TRKoK5LU5yOjbJBEiFh7wHxkH+KutE8Uqw7AMbY+HVOPL1aucH1+itwtCqpBk5yikT5yZyBLk6gM4cW3iAK5D4DAKa5sDhIMkLvmmEw4tkPkzkkTnbeX4NiHwZ8segBV3zCVjWgTzJ+RV3E126TnP5DItVmDzMWOQCf0dkWtEbokXst4YkL12f/RRCLdBCT/1sUStumalP2kM9aO4HgKBS9GGeb+UpKhcVhqyXd7rqnIcNruvhXpT1XZSL7WlHT2p/K/N/Cg7ZF++zkSsUsMhmBxPMqn0fpF7Gtf2G1kne+jxcZLqArAyYq6l9QJvZrk/pnFCQCZpVnIfRIygZKaINBplPO4tAXv9DtOlOPaxLV/1L7pSOAyIVpHvhsx0H4aRAYXTAh9jUEEDwYt84zJokHrBtHiUbDPoHbMHV6Zex1nLzUzNtqmPdukUukqY5gmtWOFM3GqrkVj/RITEYIC3YLzYsvv41/tBHuLJ8hF/e62qxQ9VPH/cLkhREp1nJIsGsnv/hl1ID6+QLd+v2OCs1Hgm+/l2XUm/QVktyU2Atr3AqkLZCs6LbsjrRWEXwaAJs80QSpfjuGk0V6S72QtTXfFPMR0dqQ3
 GfePvBqq
 Gyl/CF+LoqxM5NE9bYUlD1nLv7Bgo7yBwxOZwhD4Fz/dumj0hRFb7fNHQW8IE8J600uFyRJXFdIfYhiGtGh4xHydgetSwnAYHnOaq09BAwE9BctkFMhcZ3Jz7pGapquvGGB2VPoE0qLS6K32cxpsXcyQ6MsO8V+bcssKBEVsbZtRxb5nwa4sN0mmHaDZua5aeVomw8cSlKjx77Wd+B7D1GbAfrP6JoqDCPz6A+qPeD93BQkxQnL4WJRk+ORqHACp1b+hjmupquqwDglcub6y498zq6df8bYA/FZ05p+SFv2GgVDBtpFlBdPQd1s5KiPX7Pcqg7jPuPLFiweudWq/A7QHVU2q8lCozhoms6HpazxXhwzMR2DYFW3BDMy5sONx6tBJGfmT3d3gZ66SAvsu8mUPvVE5ROdlemvQfUQxd79zZKal2d2jWGBn3hjoiwUOD6pQhEBmoEbBvN8Kn2kOhxod/r11EKDWfwJ/12VdqJ9ZBZD3Ianb1K4J99v7s3djoRUe9D0CN+hXksxk0uECKF26IIwZN61odrzs+nXYGogHQ++BJoKuixLY5ES6yxUG8zx8mBqLhAkKw6kbTOnCu8xYkeqQz5rJyt+FFUPZxHCcxFX3K+j6/o8lZp5wFNC4gYqWN1+MhM/XMXaiZ7adNe8remg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026, Fuad Tabba wrote:
> On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
> <devnull+ackerleytng.google.com@kernel.org> wrote:
> >
> > From: Ackerley Tng <ackerleytng@google.com>
> >
> > Introduce base support for KVM_SET_MEMORY_ATTRIBUTES2 in guest_memfd, which
> > just updates attributes tracked by guest_memfd.
> >
> > Validate input fields in general. Guard usage of KVM_SET_MEMORY_ATTRIBUTES2
> > by making sure requested attributes are supported for this instance of kvm.
> >
> > A new KVM_SET_MEMORY_ATTRIBUTES2 is defined to support writes (unlike
> > KVM_SET_MEMORY_ATTRIBUTES) in addition to reads so it can provide error
> > details to userspace. This will be used in a later patch.
> >
> > The two ioctls use their corresponding structs with no overlap, but
> > backward compatibility is baked in for future support of
> > KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2 in the VM
> > ioctl.
> >
> > The process of setting memory attributes is set up such that the later half
> > will not fail due to allocation. Any necessary checks are performed before
> > the point of no return.
> >
> > Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> > Co-developed-by: Sean Christoperson <seanjc@google.com>
> > Signed-off-by: Sean Christoperson <seanjc@google.com>
> > Reviewed-by: Fuad Tabba <tabba@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> 
> Note sure if it's user error on my part, if I'm applying this to the
> wrong base, but I found a build break here on patch 13:
> kvm_gmem_invalidate_start() doesn't exist in the base tree. The
> function is kvm_gmem_invalidate_begin() here. The rename
> (190cc5370a8b6) landed via a different merge path and isn't an
> ancestor of the stated base.
> 
> Patches 19 and 20 have the same mismatch. Fix for all three is
> s/kvm_gmem_invalidate_start/kvm_gmem_invalidate_begin/.

Ya, Ackerley used a slightly older kvm/next to send the patches.  I at least was
testing against kvm-x86/next, which does have the rename.

Other than noting that this should be applied against the current kvm/next, I
don't think there's anything else to be done?

