Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAE20C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C478B6B00C2; Tue,  4 Aug 2026 17:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8686B00C7; Tue,  4 Aug 2026 17:26:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E7C6B00CA; Tue,  4 Aug 2026 17:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 856666B00C2
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:26:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C5801202EA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:26:06 +0000 (UTC)
X-FDA: 85064869932.01.9A941E9
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6B8F91C0011
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:26:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IoxzuKQF;
	spf=pass (imf20.hostedemail.com: domain of 36lhyagYKCL8xjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=36lhyagYKCL8xjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785878764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1m+pWGOS10uU1f2bsRnNlJub5JOhExh9V1AKmoVmG8=;
	b=Pp8h1mSM5X5XG66uGSIDPsdaudBo8ifj9oVhHlefya6VsWQsihNeSy/sxZk/yeVjRk56IL
	QWwcWqtzXyAEM0Yk/qPzObVfJFvn3RzlmpvOa1gzzw7qr66UAOjqFf7gzQNmeoniexIwFs
	CG5JEfsQYMbv17/in90m/JUlU8aQhRI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785878764;
	b=T7Q67zkgDPCYCrLHd1gCRBlQJt4Sj63ZbsxoXQmvrfvvPK9wNmC0cE+hkcJethReFbL5JU
	GsSPu7JqfZt/Rd0S6xlkiktTWhaSQ9vBMYx/CjztHCPbizDMc6/Q3MylvRy3+J3kwPVtuY
	GmHDONQN72x/PFfaBPjD4m3Ejqtujso=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IoxzuKQF;
	spf=pass (imf20.hostedemail.com: domain of 36lhyagYKCL8xjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=36lhyagYKCL8xjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb74d5db64eso208896a12.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785878763; x=1786483563; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D1m+pWGOS10uU1f2bsRnNlJub5JOhExh9V1AKmoVmG8=;
        b=IoxzuKQF5KoQVQXbo8ydrflDIcwufmXWD2MlBA9jNouAUOkejQo7EwtQk0AI6L1Drn
         3IXqv+ANF/QMW2fdylzZWKNeY6ys9x6cHRp4z9+RlHIjGXZIvrt+CFjeUqwa6uOqvwb/
         RhZAiQY5OVv3LP2FWCdgjWV/Z2XSEeo73WEBnmzh6s8c0q9CofkZORvxpaWOHpMsdLYa
         bUA8tKrk1U3ZyQClFOPE/cMDisqCBconilj9EKjZXWEmCGplP4KbZj60h8gHGJ9LD2Bz
         QUU9zsTK0lF20HgmGWdJ4u7sqHnzrB4SwdkP8rKzxkRKLQEDuhH5SK1BeK3Lfbk9ni9i
         lO5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785878763; x=1786483563;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D1m+pWGOS10uU1f2bsRnNlJub5JOhExh9V1AKmoVmG8=;
        b=npN6QIRBPYya8WcHJBRROM77iLz/OCBfLE12nfjd56sPw9dFBoxWrCMRdY9Zz3nl8N
         SbKSKYyFa7IkvJ4N8/oygGYxtEr+qB7DGDYFfmCxDenyeAWSRw/8d1WDB9eQ7zwVpLUf
         /v1ZS1GJCLEABlMXT3yAdAO5BbX4sj5hbOR2LsXkz5vxaaeRovckI/6nrULpB1NluM/K
         1z1yVu5W7Y5to/uiEOXwIidGVhiAFHnhPmhR4GMl9PLK3TpZ1kTSrk8K0+nwypLq8kNU
         GzEJIsIXpbsw/vK+qj7O00V2ehwDWUTB50MKDq9UT/D6gTQ7+a1zrmuS/qSuAFfWtOAk
         irBw==
X-Forwarded-Encrypted: i=1; AHgh+RqMmjsPJD9wTToNDtc9GrBwB9qlJusDbv6GkZQHftNM/y2N/MH7yKcSzbCM9oV2RLaFZmS89Bt9GA==@kvack.org
X-Gm-Message-State: AOJu0YwdlMqie4iM8i59T9hyfYMTt0XjjKuilnqUt61qGH29XgaC9lA2
	jm8U550FurJmGTsS8M+Y5zgb+GusHhpAFn8R/8+//r3P6DacYF5AeQEcVVTDJsQBV2WwDoxLGB5
	wfKoXxg==
X-Received: from pgip24.prod.google.com ([2002:a63:c158:0:b0:c82:7761:9936])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a103:b0:3bf:6237:4d3f
 with SMTP id adf61e73a8af0-3cb85e4dc7fmr1611110637.18.1785878762819; Tue, 04
 Aug 2026 14:26:02 -0700 (PDT)
Date: Tue, 4 Aug 2026 14:26:02 -0700
In-Reply-To: <CAEvNRgErZqaLPpBveBd2VxdrS_8mjMbArL_=AhzMdikXmUU5VA@mail.gmail.com>
Mime-Version: 1.0
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-20-35f9aec2aed2@google.com>
 <7f23d149-b7f0-465a-a9c0-5c7484e289d2@intel.com> <CAEvNRgErZqaLPpBveBd2VxdrS_8mjMbArL_=AhzMdikXmUU5VA@mail.gmail.com>
Message-ID: <anJY6opttIJ4OQHP@google.com>
Subject: Re: [PATCH v9 20/41] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, aik@amd.com, andrew.jones@linux.dev, 
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B8F91C0011
X-Rspam-User: 
X-Stat-Signature: e4gaey1uhosf8rj4je7ad8g1crgoxhtx
X-HE-Tag: 1785878764-159206
X-HE-Meta: U2FsdGVkX19GBpNdSGxl7QRg/c8tvh4RBXXSXG1N7HNI8fmAZ5ecWjhYpGFF+JTbzgsqDmb9K5R+u2ZptT060WXyB2TZB08XoE/RhBCjzgYXkzDG1WKcA1BTDds/3qI8Bjg/vlETOy8EhlcLdUhb7CCMpoptRobzJ9x/1KsyLKS8+WAOd+ZWPEGj8idXTDM+AUwSmCE8g7d4m+WHYdoo+NYKxyOFSsVb5klqBP/KoologpigyoegSXpGjzJPKiXyVDnE0NAktnf5SRc1m6LO8rJoSAYpyXwdyFQKVnoyw0myALnoa0an3r/7ARUcwY8Fitdb5KJV7fVD3TRHOjjPMtauBxv2BdCNvmhch4jzwEjhE8GXhnY9adeKBqRaxLdQ/FrUqvB7i42tKrdKQAYpXg647S8brsQfixdW+x1cMUqM2A0FKmKqxitd3QBxiVKD0oA1gtRPNlG87b4Cdl6nqvwaPoCkzVYaFOV3UmMi3sQhkTrg4QXMvZk8ppViWuvhlHdeKePKcrqStJq5oynGmUB0dmhAIzb5K5AyWiz2chFv33T7VwRaZhnnWTp7JOzKOBe8OyJWMLw3GQSh6nmFu196oT4FAqVVP6fCztLtOY7LZQ9WY/o0adSRdpWeQFpLAxt0fJ+TVXvstBJcDlLu94LO6J7FdbBv/rACttzWq/f9Nl1sXlPmYILhcjrE8ES9/VWEzt/4kyoqgMBWrNTPdq/Kj+wVeJB8KYwEZwzA1WMQ/tLmbSVsZTkkr/rQc/B76DGiAktER31Utkg8/htE5vLZUbGwH+4caNyoJ0GYCKYI65d3oa8Mrwh9hvkMalr1UPTkJfP9wZ5bM/E/ZGm3dpVYFDPvIOb2D/mlskjLFsuDVylpNMigrXemqNEJYjjclX3YqDXHbTaerKlqD62o0ps9eRYi7bZhPGKHDiV9JZEhERePUg+5fkA2XTus7Lf6A5lh2ol2nGEuChHi2gz
 +D+ykXaH
 6T4fsWdNNbkU6pzTdvz0WQb1q+Wj09IDqMHnIFDrh18Mxf/eGuXMjm0Wz9EU7Je6NRagiosT4zdglBAfp+d1duigyRa7q/a6clBDTeMzb+F3XXHo0tzMXCmY9no1CUEtEKD3+5ORkDBKoT3phyOrdsguo5mcOfJiDzpd1/hzTaC5c/D3yYjPOgV6h+ZGehHx29AxR9V0A8B1zm/O6CxYgqKyS3f9BA2fj7YvxBFeq7lrQR6WXxlzL+gTJo3efr89a2b9Ij8kvA537Ys50/AFCouorWXJbPQ3P5nSMzSrakZU2KoGR+l+wYUg1GO89lCyQo4b/CMDMQZVWIKxL+PkVfm8vEifu6rzICeaFAoNN+eClrQZU2+EVTRyqN+Q2gbN2kfLsFINTgLZ3y7mfE4f/MPLzccQyx10vONCQl+N7MNn6RPWjSSZGBlzOUKrgZvFea2lFHVd3KRlkCVAC37EXAflKLRsok0iHCrK7TzUI1w3ZW/1Bq15NVeUdfJsUZ8KXwIuD2NA5dqayxMlG+uy/ySTxKtb5YCsPgs32HxcPzTW1mJkGiUevbWWU5tzFT1eTPlyUdAtFMhaL/i0+eVW0QQ9EC0/RNc+QXxfO6WTrbcBgobK2p/5JP+FsUJsBDy9JzNFrG4IX1mfZpeKVUtMmJzsyU3fUWKeZ5GZZaO4PjeiT5j8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026, Ackerley Tng wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
> >
> > [...snip...]
> >
> >> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> >> index ea2752989f8bd..df67a6188aa99 100644
> >> --- a/virt/kvm/guest_memfd.c
> >> +++ b/virt/kvm/guest_memfd.c
> >> @@ -1137,10 +1137,12 @@ static bool kvm_range_is_private(struct file *file, pgoff_t index,
> >>   {
> >>   	struct inode *inode = file_inode(file);
> >>
> >> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> >>   	if (!gmem_in_place_conversion)
> >>   		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
> >>   							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
> >>   							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
> >> +#endif
> >>
> >>   	return kvm_gmem_range_has_attributes(inode, index, nr_pages,
> >>   					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
> >
> > With my suggestion[1] on patch 7, this diff block can be dropped.
> >
> > [1]
> > https://lore.kernel.org/all/dd4201f2-3660-46ad-958f-c70feb1ab1c3@intel.com/
> >
> > The code looks good to me,
> >
> > Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >
> 
> I think your earlier suggestion on only defining the module_param when
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES is selected still applies, since it
> removes an avenue for a user to turn off gmem_in_place_conversion if
> the other option (VM memory attributes) isn't available.
> 
>   +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>   +module_param(gmem_in_place_conversion, bool, 0444);
>   +#endif
> 
> Given that we're now dropping the diff block as you suggested, do you
> agree that we should keep this #ifdef?

Yes, the param needs to remain hidden if CONFIG_KVM_VM_MEMORY_ATTRIBUTES=n, so
that userspace attempts to disable gmem_in_place_conversion are ignored (and
logged as such).

The obvious downside is that the param won't exist when in-place conversion is
forced on, which is kinda weird, but I think it's the lesser evil?

