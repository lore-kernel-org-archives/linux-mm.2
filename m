Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 719A0C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775A36B0092; Mon,  3 Aug 2026 11:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CF36B0098; Mon,  3 Aug 2026 11:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63FE16B0099; Mon,  3 Aug 2026 11:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 344716B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:33:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF774140753
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:33:18 +0000 (UTC)
X-FDA: 85060352076.12.69085C3
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf08.hostedemail.com (Postfix) with ESMTP id D416F160008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:33:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cJw5qID+;
	spf=pass (imf08.hostedemail.com: domain of 3urRwagYKCEEvhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3urRwagYKCEEvhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785771196;
	b=bfstYiJmvblZfVlWAQGj0O8opnSfFCQr27DGBWFeHyKrsKMirb49RIJl27WDWwiIuRHM42
	gmF23EnFQkAGR01GBV4q791WgnHL00rcnAwL20QYjfYyIE2VRFg/K8ZAy0wKU7EDQygqHv
	d1kvnCvwEbAcN+JUZ3br4QiDC9coY1s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cJw5qID+;
	spf=pass (imf08.hostedemail.com: domain of 3urRwagYKCEEvhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3urRwagYKCEEvhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785771196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtEGWO1V/3oKubYEJFYO8Yg77TA8PdsLMD6iXufqvFE=;
	b=5XM3ua4WXnQ50nyDdyYLXTErOXGZtgtCbWf8++A/QZgFdvb+f1QkMl4rhNqfbuMHqVBlcn
	DjVYNttUHinaN7LgXrlMdR5pn/xOB8jT2ZceeujyER0AhUdgkNKIhm407yDZtOgktPVtE8
	DAfC2QGOAgLWXUCfQVumzSvf42AGqhg=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84842381150so6977125b3a.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 08:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785771196; x=1786375996; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gtEGWO1V/3oKubYEJFYO8Yg77TA8PdsLMD6iXufqvFE=;
        b=cJw5qID+5KSSJVAQTeTT8lIQfWHeYDiulAip18RAByp9lJZTkRkNVcq03p36tR02yf
         8ISYFsdYU6kJp5rOQIjGrp8pYDJO4B+PqHpBQJx5r65hIVpSXmbJDnnMYwcYP15LnCk+
         LZD1Uvj+GxCk9RPDK0MBdjkRskS3T9KxWDZo+hmhckSHukSdiceoTaJqwp2dMqjW3v2b
         6iOAw31vDDeKyp88z2vihAvL76pzzUbHzDRzLDcKgO5PBD3/uh1XfjAsynidmdmA+dre
         SwgaunWWBxnlJLtYHdz6rDx5BffRiMtVAp8JAoW+JZjmc2ehTcqS/bQMGWtA6GRRFTUN
         GiQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785771196; x=1786375996;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gtEGWO1V/3oKubYEJFYO8Yg77TA8PdsLMD6iXufqvFE=;
        b=Co8pUuNPN47yUJ9JYPvi/pwrXgK6nKavRGhiaLynjF7fsUiK0MjtydpeoVjLPBZF3I
         F10Tw9NsnekaKGljbW2gOkaQm1cXNKx8ElqgTIja1q45vhDz/mt8efO6K/OxyEBqAIfi
         R6UcBdXlyRM45nSmEGcol5JJdL3B2XWeoHGIWqHkntq2VGISiUeFPKB8CCcR8LgnbxcC
         IoQhY1WS/ZN+lIVOEMqTuVaKvqRz2LRrfhHlW4bSj7/acauo6qkINij9SOyk3PBH0+fb
         Cdh7QOtlo3BKQS/DO/QzPwK8ge4H+5qRQX4cv6q8He7JbFnAK2PHNitG9K/kZ16KJTOT
         LQyA==
X-Forwarded-Encrypted: i=1; AHgh+Rrr8/E4MwkCmimAQE0oO3+bZ0JHR3uQd29PHfLy6IHiX79m/yREXT/eLE4HFuVIU0RmWTIkH/g2Eg==@kvack.org
X-Gm-Message-State: AOJu0YzsUDboFn+ISZhUGHzm1p7uAHmXCR3a5nVTkfmO5qFvZ4IAHS5t
	6bUUJk/+mkZV9CzEKgNxsgTPg3LyBBg8NcFPYfbBd6BgCBoEyachZh0+J4dCwf+kzurzSYFXaTE
	13gtlYg==
X-Received: from pfbhw1.prod.google.com ([2002:a05:6a00:8901:b0:848:46e6:1aac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4613:b0:848:3fe2:c88b
 with SMTP id d2e1a72fcca58-84ee477539amr8885723b3a.6.1785771194900; Mon, 03
 Aug 2026 08:33:14 -0700 (PDT)
Date: Mon, 3 Aug 2026 08:33:14 -0700
In-Reply-To: <25ab36cf-888a-4547-b3f7-5bd4e057c1d0@intel.com>
Mime-Version: 1.0
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-7-35f9aec2aed2@google.com>
 <60d19013-d6d7-4eec-827a-2622e22cec98@intel.com> <CAEvNRgF0SxmoMtqq69tUih54A9K7j_wcMFRrq=r9w6TnAGAUQQ@mail.gmail.com>
 <dd4201f2-3660-46ad-958f-c70feb1ab1c3@intel.com> <amzMtg4K6qEEsudx@google.com>
 <25ab36cf-888a-4547-b3f7-5bd4e057c1d0@intel.com>
Message-ID: <anC0uuZIrbxlGubN@google.com>
Subject: Re: [PATCH v9 07/41] KVM: guest_memfd: Wire up core private/shared
 attribute interfaces
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: multipart/mixed; charset="UTF-8"; boundary="t+KByEqIRolqunqf"
X-Stat-Signature: jtbyp9qtobdqp5ns37j7nhpwjkyt8h5k
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D416F160008
X-Rspam-User: 
X-HE-Tag: 1785771196-822296
X-HE-Meta: U2FsdGVkX1+oNpwp6K6x8bUJ3OQdb2JyXTWne9XKUMEEZdXu4E4CCZeKvz+ynfq98Jto15sWvOVgbCjg9XcAbvbZnI+Ps9GT6pBkWh0oQp4ycJEnUCobrf/mq4YZCVT8/xErazR9Xutfjcg/Dous/IVq5OpMXfO0DitcI2BQas3u1HFKg8ahXuBhperfJeA2QEjS68PsxcQqtwPx61YNE31ST1VpP6hRnvQQV/OYCWHu+u8UP204a9tF4FJaP9d0yE6WHV8WKP+DWvbpO11TrgC08x8UMY8KZT//GMToRXpYwctSWtG+SkNjXykEtCAyuhKgtZAsuobErascchVYp3PE8aqJwIxDHw2w952//58gakE1IX+9K4rJCXlmbMt7c28ll3vfCeC3Nt0yMFBrHEtixx9Es8uM/clwr3zAPsNciCfq//QEiftEpN+UVNCY2b3Wsrk4togYLXP72EiQh9Lt/1iseI9fb3gCdS3RbUw/l5sj6C64rLgocf7yxIaoFqi4Sqr78FELp7lvIPhxOufl2wvT/+UX9LeabZkrPwjlNEbHMUMt5sTW8e3ggRXXTeqf0egaMOj0Cu0soXeMLhhmhW9s1RzxmtV6T6DZqpmNOmQxosLP92JYHg4IUXOBlWkhLtTwaYO9KS5yqKQxDVQOsMSdKLQvJJDhuVpsCa3D3fQENkywsAYw/Qd7xtfb5c7xPx8YO8PqKB0JsEIf3gzXj69nruZ5/NbH/rnIxm4vKsG/W9RKMt/Q6hxHkxnuNL261z1IRMcXIFZ1kD90ra+zA+AA6QTcEB+pD3rUnrBmJ6WZK5WYA4Okix+LKD5c6p19rTjIIdAvoK8AA3JID0KB7ZmPPlZtciCmdAZUuEHqbCyhz2eReSFAfA37ZsO8V+oSagvPAnsJqcq5sbmFvR5/yHNmx1osybZ9S2sILYd05a2rm07aET2HWFCrKr7d8mHGTZ4Y17M/AlPI6eq
 K8MQSrxM
 V/MM6gFKDwuHhDQz+Pidz8k1eeM6pmYEHdhfJHfhotkKBtUHf5ryyodr/NaXIjtAL0mwGe5PqvJpZojvOVih0m9aOEQRKRHeDthD5EvPSF3vku2PPcZivUXGTxmblJprOpF0iWfZbw7H35X/vlWMRUbAQWd4cjXi+E4m+ovP8DWnW9jjNbCntEpRkrG9qDZtKKJBd4U2SFoUKXOpQ658AeRhS6/DOutsnZ0fmAOLzJcTb25+yg1Yp43e7kXlmDOr2hr6yHqeWNkCvvon4dxAEbPR0vML0LnQAVybX51tkfM8XsvLXD81D2uioKjXZVFIGsmknJcDd+Yykh6Rq/CoerwxGZzesqvd3/bpGmiHu3O/D7YWqrrVkr/P9HwgpSrRJL2cZflKDedxz7C4sXzWAqIRDfsiXb5sSZ456uvc0sLbuv0P87FlT7fBOVPSzSfxfFYlusqA/xf93nJKNEK5m+3mD2SxzUY/8YRA7ylFbyu92FpdNRIdYwZIn3zCuhrcHWW8qlLEaxKDwhqpjv5CEXQ2MzUjeJc+gViaX99opw+u/vUVrm35SFQXBd9fKmWg9yR133kbWtsJphGqmM3YQWQe7wHFoJYZVuqE34y6Wj6ub1uGrD9oGlx7LXVIsamQnUKXGsITT3D5mk9PFtJvqXKskdnno1oq58Qxow34EYQHku+bdVZSnD5N63J2GlajVKp1kVCuSS2T/Yz23jQnMVMhskrYTW9+8T3XtMGjBXYOmYAjGeXdI4AhW6HvI8jwg+fBKBzwIqltxjE5covG9Gw6/frgT1Cnbg65umyj8SgXoMmMwAhRF0OiOroqEsNthFcw4IwrAIteV5lOUeAw8LzzZLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--t+KByEqIRolqunqf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 03, 2026, Xiaoyao Li wrote:
> On 8/1/2026 12:26 AM, Sean Christopherson wrote:
> > On Fri, Jul 31, 2026, Xiaoyao Li wrote:
> > > On 7/31/2026 4:42 AM, Ackerley Tng wrote:
> > > If kvm_range_is_private() is useful/required by huge page support, then let
> > > the huge page series to introduce it. It has nothing to do with the in-place
> > > conversion series.
> > 
> > If it weren't for the fact that the range-based search is used later in this
> > series, I would 100% agree with Xiaoyao.
> > But since the core logic is used and needed elsewhere,
> 
> I don't see it a problem. Without introducing kvm_range_is_private() in this
> patch, the core logic of range-based search on gmem can still be introduced
> as kvm_gmem_range_has_attributes() directly in patch 10 or in a separate
> patch.
> 
> > and because kvm_range_has_vm_memory_attributes() takes a range, my vote is
> > to provide the plumbing now, even though a small portion of it isn't
> > strictly necessary.
> 
> So my initial feedback was "we can just use kvm_mem_is_private(kvm, gfn)".
> It makes code simpler.

My apologies, I hadn't actually applied v9 to look at the full context.  I agree,
providing kvm_range_is_private() is completely unnecessary.  It's not even really
a problem with this patch, it's a pre-existing issue that can and should be
addressed with a prep patch.

> And as a bonus, the logic to choose between gmem-based attribute query and
> vm-based attribute query is hidden from the static call.

I don't follow.  What do you mean by "hidden from the static call?"  The whole
point of using a static call is to select between gmem-based and vm-based private
memory.  Or are you saying the populate() flow doesn't need to manually check
gmem_in_place_conversion?

> The second bonus of dropping kvm_range_is_private() is that we can eliminate
> one more chunk in patch 20.

Ya.

Untested, but unless I'm missing something, patches 6 and 7 of this series can
be replaced with the attached patches (6 and 7 should be squashed together no
matter what).

--t+KByEqIRolqunqf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename=0001-KVM-guest_memfd-Use-kvm_mem_is_private-when-populati.patch

From 77bd0524535d65d7c6beb4a0cc70a65fbacc9f81 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 3 Aug 2026 08:10:09 -0700
Subject: [PATCH 1/2] KVM: guest_memfd: Use kvm_mem_is_private() when
 populating guest_memfd memory

Using kvm_mem_is_private() when populating guest_memfd instead of using an
open coded equivalent.  In addition to simplifying the populate code *now*,
this avoids the need to provide a range-based gmem lookup API in the future
as well.

No functional change intended.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8c7709a352cc..48c13d18af15 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -881,9 +881,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
-	if (!kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + 1,
-						KVM_MEMORY_ATTRIBUTE_PRIVATE,
-						KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+	if (!kvm_mem_is_private(kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;
 	}

base-commit: 17548ee538ef4f476e16fb5dd3ca8adfd8a852ed
-- 
2.55.0.508.g3f0d502094-goog


--t+KByEqIRolqunqf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename=0002-KVM-guest_memfd-Stub-in-ability-to-enable-in-place-s.patch

From 02db86dc193d969085bbc0c98c6117e59d469cb5 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 3 Aug 2026 08:17:34 -0700
Subject: [PATCH 2/2] KVM: guest_memfd: Stub in ability to enable in-place
 shared<=>private conversion

Stub in global variable to enable in-place guest_memfd private<=>shared
memory conversion, which will eventually be exposed to userspace via a
module param, and wire up the __kvm_mem_is_private() static call to the
guest_memfd version when in-place conversion is enabled, i.e. when gmem is
the sole authority on private vs. shared memory.

Cc: Fuad Tabba <tabba@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  6 ++++++
 virt/kvm/guest_memfd.c   | 26 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      | 12 +++++++++++-
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 65fbce46b63f..9477ecebbbce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2580,6 +2580,8 @@ static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 #ifdef kvm_arch_has_private_mem
+extern bool gmem_in_place_conversion;
+
 typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
 DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
 
@@ -2588,6 +2590,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 	return static_call(__kvm_mem_is_private)(kvm, gfn);
 }
 #else
+#define gmem_in_place_conversion false
+
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
@@ -2595,6 +2599,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif /* kvm_arch_has_private_mem */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
+bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
+
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 48c13d18af15..e21c7122539a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -474,6 +474,32 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	struct inode *inode;
+
+	if (!slot)
+		return 0;
+
+	CLASS(gmem_get_file, file)(slot);
+	if (!file)
+		return 0;
+
+	inode = file_inode(file);
+
+	/*
+	 * Rely on the maple tree's internal RCU lock to ensure a stable result.
+	 * This result can become stale as soon as the lock is dropped, so the
+	 * caller _must_ protect consumption of private vs. shared either by
+	 * holding guest_memfd's invalidate lock for the entire duration, or by
+	 * checking mmu_invalidate_retry_gfn() under mmu_lock to serialize
+	 * against concurrent attribute updates.
+	 */
+	return kvm_gmem_is_private_mem(inode, kvm_gmem_get_index(slot, gfn));
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 081e3309359d..e5654baa8895 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -101,6 +101,10 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 static bool __ro_after_init allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
+#ifdef kvm_arch_has_private_mem
+bool __ro_after_init gmem_in_place_conversion = false;
+#endif
+
 /*
  * Ordering of locks:
  *
@@ -2422,6 +2426,9 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
 {
 #ifdef kvm_arch_has_private_mem
+	if (gmem_in_place_conversion)
+		return 0;
+
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
 #endif
@@ -2633,8 +2640,11 @@ EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
 
 static void kvm_init_memory_attributes(void)
 {
+	if (gmem_in_place_conversion)
+		static_call_update(__kvm_mem_is_private, kvm_gmem_is_private);
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-	static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
+	else
+		static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
 #endif
 }
 #else
-- 
2.55.0.508.g3f0d502094-goog


--t+KByEqIRolqunqf--

