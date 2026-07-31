Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE578C55175
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14CA86B0099; Fri, 31 Jul 2026 14:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CDAE6B009F; Fri, 31 Jul 2026 14:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6616B009B; Fri, 31 Jul 2026 14:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBA266B0096
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:37:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45430120483
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:22 +0000 (UTC)
X-FDA: 85049554044.18.D46CD66
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf06.hostedemail.com (Postfix) with ESMTP id 841C9180013
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LSCn9HYa;
	spf=pass (imf06.hostedemail.com: domain of 3cshsagYKCBE9vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3cshsagYKCBE9vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785514100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fnhBgLexccnG/MXIqot9sZlADClDA3hnAx45msmNhUo=;
	b=CUfqy+rO4NfAaD788IUXqtZLSPEGwiOFpfpsyXU1xFFTnwwxyjLQ5ZlJ7l2OS72bmAjcQA
	Pp/dWehwfqONxTl39bt3hXdPmibZ6oPXF5oHlBoJ5KgFZO430tzL8bGt66EVndwO3rONbs
	1L0GPbCzoMVQyDGD+chtfoWo+UfkbQI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785514100;
	b=Tawct7mM4uw1ijco0tET/CmCY6jwanfJNzvFK6jkH15OuGGh2myUKCSjthYAmWg2M2HWUQ
	7q1Tmkvm5b4qIp/E6g8vwHC3ni0xnmmy5lIYJQcBK+uRizpuCmP3isx9LegNNTt/hxmC4O
	nCIXt3RHm6/V2/mstF31/w1fD6p8oTM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LSCn9HYa;
	spf=pass (imf06.hostedemail.com: domain of 3cshsagYKCBE9vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3cshsagYKCBE9vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e667368f0so1982455a91.2
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785514099; x=1786118899; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fnhBgLexccnG/MXIqot9sZlADClDA3hnAx45msmNhUo=;
        b=LSCn9HYaV0GOoQTK65gUkenbuAUuJD078Yh8kqNMn/XJyM71WqwY2bCXmert3llhlT
         gLR6m6pmZNBjFvX3H1Vbmjxq6cippuweHiKTRr9BaWDtV5d1ZTUAbIcrx3McAcSU+Kji
         TH1+iGXM1syLTcD+u9OPABj/QGQxoSAaPtqw0188+g9KduPZtuRFU2p/SKYqCsWQ7fMv
         oQD7nDsfnuOVK2kWdHcIP6Y23zfQ/zOcGXMV52NxFUPzJORHBBwQUB/b8k50YV3Sx7d1
         Q+SPdc2AsTUxd8gnUOZ7sOw3pzkce+zMg68SpZgnFL7zFYUMayytSW/n8Tw2tH8OSP5V
         9SEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785514099; x=1786118899;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fnhBgLexccnG/MXIqot9sZlADClDA3hnAx45msmNhUo=;
        b=nlw+V4wpsCEzaXZz54XNSX01V66eua/pWlw1vEtIrmw7HByo1+p7v3gCSfSs8Es+IP
         jHYvkiPwpwTKWLEdsSncdlS9efAyOjY/7FeXAyxkTJOlKjQdtSZnpmAY0c5Q+hprScYs
         cWCSsvLC5cEDmdMZWNXW4x/gjn0sITGpUKLQ+z86nnTHtNDy9wFQUKDSDjyQuVHwCTv5
         iChvPfg1TKdVyNihUhxP1wx0GEILE6PlRWrZQE6wBm4Ky7agJ/rNJDmYnMb/2WFXFI1m
         21LyGZFoU5JLGtOfmb9YJAcaapVz7LVQ2djUEyMARX/GzVgj73ccZdBwfV3sZwNYiCTy
         VOxA==
X-Forwarded-Encrypted: i=1; AHgh+RqZudnnTCaPItDXxYH48iJSPsl2OU9+acB6n0LCjNqFYJjaVcM3kho7E4tQkS2bmIVcVRpUoXTYYQ==@kvack.org
X-Gm-Message-State: AOJu0YyJbNSjCr5yfV86ICXa84vrW3m6dG1R1JoqNFfrCnp0M/5N21Pa
	V5Ffyvhn8f7xhsHYDfBQQB9irTJdz0k3NB+2UiDf9RuuL8LCQJ2zr/bpnbcX0/WCEDIPxfbDL92
	wDevoTA==
X-Received: from pjp5.prod.google.com ([2002:a17:90b:55c5:b0:37f:acb7:9d81])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a8a:b0:37c:18e0:90dc
 with SMTP id 98e67ed59e1d1-38fbc45a7abmr414580a91.16.1785514098749; Fri, 31
 Jul 2026 09:08:18 -0700 (PDT)
Date: Fri, 31 Jul 2026 09:08:18 -0700
In-Reply-To: <b78bfee9-29f3-4044-8ac7-f294b3cd0ad8@intel.com>
Mime-Version: 1.0
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-1-35f9aec2aed2@google.com> <b78bfee9-29f3-4044-8ac7-f294b3cd0ad8@intel.com>
Message-ID: <amzIckjuwf0JfINI@google.com>
Subject: Re: [PATCH v9 01/41] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 841C9180013
X-Stat-Signature: m3434f1qjcs3pstw9mamibzhourzfiaa
X-Rspam-User: 
X-HE-Tag: 1785514100-622344
X-HE-Meta: U2FsdGVkX1/O5Ts9QjHcDqr7Oo1y6RfiHklx6x5VEGvheePcOcBCVPp8X0OXBThMT+ai0E/fjGCRHXAxCAJmwwral8QIgQpWzTqxcBr4MYW8cDSuc3qVN71t3Wf+69fXQaiXs29xcDVjMaQZNUMLOy4bY1AmyEUtJ4SuDgKRc/K98R+diH4HFMvcaqO+67Q6drcaH8KOp3lD7MAJQ/RzA7EgjyYKnbsF/Wl+lIpgKLkKI2nAvY2jwRLLOQk/RClsiPYfMAmXgO0kMLrMW8xd4XWwFQa0wy3Sh+DDmdHSGkldig/cYfooJvJoYdAwooYdkcdeLmQcG/GxNSNq126fkWlveDrjwpOrkzm8vqThuAsm0i2oFj6egGa3QcNj+PvBLuxoSZMbgAZgb2M6tZa66H6xk4ww2bGjutMWzUMoq/J1QvBXP3tcAyaO89PHzPmbQw/5D7UgbxkDYYUX/SpjnjEzrs08rsmyhUcyUYp+wnly/9n07lk4+CLHCTxQtSNv/BIoZxBYzdA2LfdITIC3y6N45kS7G+LT/b8PdLhWWHqX8A8vrO5bdflBp+oeIpM6YRO+I4UxGpa6M2RE/6KKo8RXeLsqGoZgARL2ChPorab1JEVjgh+642t5ue58jNMPmJPULpaAV9fgUdOqO0edgmML9dRgu4YnMHyH3htjBu3MxcSMtyVlxBANv1R9XpupxfW418Yg4wRGTIqjf7ICuMCDjTvBNkRxDj6v8U51k1s7LUhrtXUa5cFKb5BLMatDwZNCHX7PYbG0MPlDxIw41b51OqN39Jw8z/J9Z+yhNAxrrULqJLRONCNGahfDvnKJ23pSYFOOuFCAoqaeGTnHqV95SNgp0pU8YmX7Rt4mF2PWNNocCPHoWVEn+6epSPhE4plguYkUwawwLD0emZqNHojdknO9S8DWTTmznn6MIHVGSNP040XwDxILfezxuxLRy91+i3msHzddDrfRffQ
 ufjtIdPT
 a7sCII/WDNcwShBqwT2LE386RqRLfj0aYlj0W2CIHKE1THx/GNWNf1DG3c53sBU5N5Eyvm//nlW9kCO+PfpMXYqBUdRkcXAI8J1Ldas032dbZjzRROeEDGeaQx/hnHm4xQ7NY9kidUFx7rOHWIJWDksPxzZgGa4ftzbEEEx/9jmCkns6MgBLmmpUs0BTV/wtya3iiiUdb81QC1kRqWbHp0sBorEA2/qyoGJIqj/22A6g9H4BXyeijlQXUHA8xwzJcvC1uOvMNsPDJmleO7m0pzm3quDDIPFzx+Ig0umTRckibjdlVxASmo9fE50BNVjppcGxrLAiCMLy4uzrNf3dk3rpq03BBXbstCt0nFOBzTCoAhXZdr4uMWIewT69ORQul2U/iISjntB0LF5J364duo1qjnFKVNvnx7SY0w6Ad3WbaoITLDEIxmF2h81tjevgCaCbR8G0wMLj6fPzm11wYjRkGXPqn3PaG7KM09aDuBpRp/tNN7VUu11hyqkJWWycXjhlObVX6RMHCQIRxOUwElGQJNh+LqQeWQx385NTsLocyVaM2VwUnuGE30VSA1AazrXrw3emEcYX0jnVWV1k5plnHhmdrhpd9Eqbc4wuVs/mnI5OE03eqyRAmg23RIj2P6iTI15ASbSujQfJBxVOMiZ3Y97aE5HYqbSeXhH5dXg0VoTi3i63HoC73tFUlWxLT0VZBanJWkzXUFLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026, Xiaoyao Li wrote:
> On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
> > From: Sean Christopherson<seanjc@google.com>
> > 
> > Start plumbing in guest_memfd support for in-place private<=>shared
> > conversions by tracking attributes via a maple tree.  KVM currently tracks
> > private vs. shared attributes on a per-VM basis, which made sense when a
> > guest_memfd_only_ supported private memory, but tracking per-VM simply
> > can't work for in-place conversions as the shared/private status of a given
> > page needs to be per-gmem_inode, not per-VM.
> > 
> > Use the filemap invalidation lock to protect the maple tree, as taking the
> > lock for read when faulting in memory (for userspace or the guest) isn't
> > expected to result in meaningful contention, and using a separate lock
> > would add significant complexity (avoiding deadlock is quite difficult).
> > 
> > Co-developed-by: Vishal Annapurve<vannapurve@google.com>
> > Signed-off-by: Vishal Annapurve<vannapurve@google.com>
> > Co-developed-by: Fuad Tabba<tabba@google.com>
> > Signed-off-by: Fuad Tabba<tabba@google.com>
> > Signed-off-by: Sean Christopherson<seanjc@google.com>
> > Tested-by: Shivank Garg<shivankg@amd.com>
> > Co-developed-by: Ackerley Tng<ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng<ackerleytng@google.com>
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> <...>
> 
> >   static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
> > @@ -60,9 +68,25 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >   	return gfn - slot->base_gfn + slot->gmem.pgoff;
> >   }
> > +static u64 kvm_gmem_interpret_entry(struct inode *inode, void *entry)
> 
> Ummm, I'm not sure on the name. It doesn't look like KVM's style?
> 
> Maybe, just kvm_gmem_get_attributes()?

+1000, "interpret_entry" is extremely vague.

