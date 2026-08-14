Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 912D4C5DF66
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 00:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5906B02CF; Thu, 13 Aug 2026 20:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587406B02D0; Thu, 13 Aug 2026 20:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E1B6B02D6; Thu, 13 Aug 2026 20:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10B8B6B02CF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:05:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE2871C00A3
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 00:05:22 +0000 (UTC)
X-FDA: 85097930484.15.F3CAE6F
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id E9DDC4000A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 00:05:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UukWfBnl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786665920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6S8FmXxg5lAUAXg0md8s6VEd12Y3z7y8v3Uv1Qtefa8=;
	b=DlspPloF7M0+yKzyRTOOnCOHc6iGgRljk3izLulO/6CWo9Zzyfo6qmfiRdDX6V8rylZQvR
	KObYsKmLhbJWAALlBB04zxwIZlpTR7UtugMQEmfMAvZ5kg5eyjsLc6f4AMBF+JZOwe8t/H
	apCVdZczhaM/Z4tPAx/fKu3Jedujnwc=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UukWfBnl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786665920;
	b=IEIFy0Z7GazY6AEERB509Jacj6dD+FGdz7l7+oER7r9hsZS7YYepkWoJ+d2oLo5P0HWuRW
	+I0wdrmEzeF4UhqfoCFVFS9eLqugSWfLY7cY7xpOi6a9Z2LGxPaQlIgcapSr9Jo0y7F9ik
	slBSXtBAOqGZQ7iDFWD3Mbh97mPt79E=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cace91f112so6140825ad.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:05:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786665919; cv=none;
        d=google.com; s=arc-20260327;
        b=ptDRsX0KvbXFT7PrWqXp0+HPoFSmkxuMjOrUm2C7CbQFfXQPEvJhs0zSS/NSALrS+a
         Q8OfGZysTYEpz/JzJKlb2VkbAE4fboiIkSIxUCy9A0lmqB+IZkqOHCrtbkBDI7yUGHzT
         GOHiMWBKggFrgUMjOfVK6VCbDMqa39G/dXrGGxvytC5unexCbSsGXy9aWO56Ljzh6jvj
         Bxr8uI+hbUs2zdT8MVdrUmhEAsfkvrePkorhoKM2cyO7iShhTUiiCrgsHBaMQA7lyxpN
         EldmZZ3te+BI/9tkDH4KCzm+aEP1LNyXGB8Y+j0b60vv267VlOid5W/7tt6NMHHVCA/r
         7doQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=6S8FmXxg5lAUAXg0md8s6VEd12Y3z7y8v3Uv1Qtefa8=;
        fh=JkhUTrVO7SzURWSwvsXuBP0RZvwsvJ/+E77MUBp45JE=;
        b=kI4gzV9gSy58ahx/ztdsDgHWrkNtKTTkVg9zt88hSJknPoL5J6rjLRxopB8C8YphXg
         i3HwmbfSAP3Mcd/BbrbtJ5biEvV2RUT8zTdnH7zbneTv+rAdD/3jYKB//xC+RVK37D0K
         NpQJBMc9CGvoUzCKfDy4b/G1/Ap14stvlCVDzxuj4fiHDOSeeI5EQhRNGLMv5Sm7X2DA
         WymAb9RITsuZN+RzLmCD9ukvFZQG0DT0DSlBvEE/NM+Q40gXGFinW46lmZBgS3HV8uN0
         jCXK0Dz6wOmM4946NFtOz1RsLFX/u165cMQ4yxU0IgPh8YIrxYioo/vM1ourJGvUPowk
         Babw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786665919; x=1787270719; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6S8FmXxg5lAUAXg0md8s6VEd12Y3z7y8v3Uv1Qtefa8=;
        b=UukWfBnlXngNJmMbvQGSvEzwbuKaC4DPCVrr35vdmC2Tl7rR9xTqDDFNMRLD5sAj+2
         JR914i2dwbPXYIpr/Hzy+t+s66Z6rDImi3eFXy9gbO0zYq58m5h8zT1sfbxLpw5ycXdH
         VEUeW1QbQZpd8vJ98umjpykIISWE1pWo7yhwqfsOOseVa4fyiocTnwkPKf4XpG7S0obb
         gOj37ROKNaD5AMNH2+DnCAo4dSXNiUDjt8ivwspczNd+ULuX72oF2MSK4zAxo3nRIGVz
         25ngsGXlRy2mUPGhN445A4bYhv2P0RdRzJCUUxgO0JvTmC+0AzvZmSBxM/EMTNEUeETt
         k3vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786665919; x=1787270719;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6S8FmXxg5lAUAXg0md8s6VEd12Y3z7y8v3Uv1Qtefa8=;
        b=ROcpu85slt9b+G8CdEeRGF3CCJm3blL3ncqpi0Hg1rPAmr7gKX2ie1nSuZ72ZJFFlf
         ZVCUSEBr2CcaUEEzS/9TJE26c7wjZJCN4snwc1f30iuThsOvUCptSTs49Fd2Z1xZfX5m
         fCwKnHh2tO2jPWGTYvSOhIfLQHOws3dx2cW2e6u0at59KBbSIt91M+3zCDQyqREffveA
         egb8EUvOUL9twDPYT9wZhze/fxv4RvH5+tqFK9HKvVv+Q40xn4QDMyLb95IDEQvWLwb4
         WsiA7EqgIbtJqoo/82iAmJu6uDSGGDY4JUlN+JV/unr+a8oOc8nnJcLGOj/TH29O5cTG
         agcw==
X-Forwarded-Encrypted: i=1; AHgh+Rp0jo0eErRtZjOFMNHHrQtaL6Huq6eOnOzGWL8wCe5lDmm3ZxRMaGeVXM4ZdGwGsAOEWrFqYwANlg==@kvack.org
X-Gm-Message-State: AOJu0YygW0hj45mFJ9rI/2DzMksBOVGZuE/pLj1mr7TTikiyfhjTOerL
	jYhovs8JHT9PRFB6V9ZVR2nLcTruwnZoefD795zNqNWUYPq4lS4NqrhcUU9+tyuMAvwvQ/GVQi7
	LKzJ7Dt1kGfAyyt8Dcsi9Oud5bTkfsQL14/r/VJIn
X-Gm-Gg: AR+sD12l1S817otysslrt+1alNeNrSdiAL1GTKO5wcwRysZjiBpASZ5zB57A96Rpecg
	eVBERhYivo9TDBr3DWYOPz1UOBdbdnFNj2RGJo3MBTKPZ9TWw3nQK4fSw4rjnTD6FHQJBKyqLkJ
	ZYOZepYB4IZNJSloG5KV+kftXFQq4eCFSmD9qeIJpg/YYrtnTXdsn6GguvVO1qYmVXRygOFsZhZ
	rh/pyEnAFZGtiN0H0QUnsU2LbyrTvEnQquuX4O7C4zsm4IuFCG01eLB1bSZe1IuhEctRnFYwzGV
	gp1PKf/Y9lSNw3Taj+jlNhhT7oGkZOj3eSoGAnMjoVRJCK/vEs+5wcHlh42DMXYDZdgmuyR88ke
	X4Ljrd9ap0xwl116qA0btszuMEB0e1829Gv+nRUT3HgnJjA==
X-Received: by 2002:a05:6a21:4cc7:b0:3c3:66c5:68cc with SMTP id
 adf61e73a8af0-3cc71fa8eafmr1715323637.21.1786665918897; Thu, 13 Aug 2026
 17:05:18 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 17:05:17 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 17:05:16 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <an5AcEG9mqDgnBYk@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-12-2fc18ee6d3ba@google.com>
 <1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com> <an3o4h-E8mj6CUaM@google.com>
 <CAEvNRgGpCVCGVjc9jCt9Yr+XypF=71h6eBahkXNkrXhfrtGY+g@mail.gmail.com> <an5AcEG9mqDgnBYk@google.com>
MIME-Version: 1.0
Date: Thu, 13 Aug 2026 17:05:16 -0700
X-Gm-Features: AUfX_mwNyds6nxIp7br0Dvgux1SWKykTqrMhXPSN-3v_34SJDBU412XbJ-YOoSs
Message-ID: <CAEvNRgE+05c9U8C=Zkm1S9hLw3Lw6YMmijZhEe7J4rYQAuNyEw@mail.gmail.com>
Subject: Re: [PATCH v10 12/41] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
To: Sean Christopherson <seanjc@google.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, aik@amd.com, andrew.jones@linux.dev, 
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
	linux-coco@lists.linux.dev, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E9DDC4000A
X-Stat-Signature: 9eo3z14x7tr97gaze1ps6g3z3ugtaojj
X-Rspam-User: 
X-HE-Tag: 1786665920-779741
X-HE-Meta: U2FsdGVkX1/Ol7jurABuwyLKPVQLrW/f1DjyHZYD8wHEH2AurZEH4Y0KjjNImGzWSONT76W31PgHgmdT2WIeU9cFZVv1rtA4zZ5hksnA12si5v7iZ7NIxf+1dT9KescupaTm1KLyCZK7KlwZGRNcF0+z/nmX7kzG3vaexjNt+qY9HzefkK6baHETPLfQ4128cvw+2UCBx5FFt9m6LhFTTNGpyOF2jU4dPUT/2TigJ5CoQce0nK0LLqAmai5vJApl+XjPYMrEEnhuc8w2N9HixUaLPhXrPz1XCNbHIi6v9QQpS2pzpJI+kjmUVsvLNbPX00sxxxcIC8GUv0ABb/DcpCu3eA+1jPgBQEYbXQ823ifrLhhKKuuzxWlHjH8lNR6bmCAisxJ4xeIdJMEi/NNRHJmawQaAW+DfKqhMJugzFav/ejOYRLZG80FPe4dLa7mdmTnK5xQ548E8dLaSr2qTvndTU2oRw0DZwrOmE0bJNXoldOKL4aKqC5wo9T/GguqB7Ehcp09b4Ja2T0WB0IjV7E2C/WfDqtzIxI8miSMdQs00lag3a9N2hiCoz1nMhc/6yGAYUGbcXb3J+l0mxA65AlkTV0dQDVHU3phfBOTg3IDpGD+VhSJKqAqHMDWL2g3mRzh5tyK0u6XNvFuOLMIZcUi+Cy6Zd6TcP4Ed4MdEA8pGSoVT19KyCOD4wyAGjF/WxOGYqAtmmvGP/DHwvI0TZSgCQ1jOnKPVuSiR5NIOxKeyQgI3jbfFdzy7Lyxn0dp6MDMpBlcXDYt6nFo0kdwm8EOHCXJowpqowG4GgeDCgy0JnwBegz26jBt0YESbrhjvzsmQmfvSq8/NnHcUTb2TXyDt9Pa0ijnSeO7hRtr5x7kkNTAangBJD16TfK0LclFW+iqf3TZEOpKYpuAOQfB8FlPf37lNIYRkIZC9WPqu8+PMuihPNhFGgha00kpE4OEgnw3mPprL3dRCJ4ZrsK2
 XEXmCMap
 GgdHNcOePNcBrRTMdYjprev+AvNpgm8+sp62BK1jSGM2Ax4SFxmQ39nimR5qcMTSLGDrv2m88zdLbeEh85+ML+suv369OdKol1mFUROOX83bWJZBahm2ehWX6sxv5M2PG9PksGwlSgFucl5dSgRaDV1kiAmtgi+rRGBn5JmjGFWHQ4j201lwDMvYZ3bAie2wqWuLarSZm4iLhP2isDG60E3N0Gno4nKaEicnIhKQCf+Dt9k1XgT92TY6G4j4rLhEC6CYbHbRQm16cKRUz7JYolEeKechBsxZVTByYDNjSvTRxOPU7KnaMPiC26EtZNf7EqX7EnfWZoZtgz2xyGWHWzYyH2+Dmi27mMbtBOA3niG3+rN7gbLQsbmbLwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Aug 13, 2026, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>
>> > On Thu, Aug 13, 2026, Binbin Wu wrote:
>> >> On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
>> >> > +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
>> >> > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
>> >> > +{
>> >> > +	struct folio_batch fbatch;
>> >> > +	pgoff_t next = start;
>> >> > +	int i;
>> >> > +
>> >> > +	folio_batch_init(&fbatch);
>> >> > +	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
>> >> > +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
>> >> > +			struct folio *folio = fbatch.folios[i];
>> >> > +			pgoff_t start_index, end_index;
>> >> > +			kvm_pfn_t start_pfn;
>> >> > +			kvm_pfn_t nr_pages;
>> >> > +
>> >> > +			start_index = max(start, folio->index);
>> >> > +			end_index = min(end, folio_next_index(folio));
>> >> > +			/*
>> >> > +			 * end_index is either in folio or points to
>> >> > +			 * the first page of the next folio. Hence,
>> >> > +			 * all pages in range [start_index, end_index)
>> >> > +			 * are contiguous.
>> >> > +			 */
>> >> > +			start_pfn = folio_file_pfn(folio, start_index);
>> >> > +			nr_pages = end_index - start_index;
>> >> > +
>> >> > +			kvm_arch_gmem_make_shared(start_pfn, nr_pages);
>> >> > +		}
>> >> > +
>> >> > +		folio_batch_release(&fbatch);
>> >> > +		cond_resched();
>> >> > +	}
>> >> > +}
>> >> > +#else
>> >> > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) {}
>> >> > +#endif
>> >> > +
>> >> >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>> >> >  				     size_t nr_pages, uint64_t attrs,
>> >> >  				     pgoff_t *err_index)
>> >> > @@ -599,7 +636,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>> >> >
>> >> >  	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
>> >> >  	kvm_gmem_invalidate_start(inode, start, end, filter);
>> >> > +
>> >> > +	if (!to_private)
>>
>> Should I make this condition
>>
>> 	if (!to_private && kvm_x86_ops.gmem_make_shared)
>>
>> instead?
>>
>> Will that help?
>
> No, because that's bleeding x86 details into common code, which defeats the purpose
> of arch hooks.

Ah okay yup maybe it should have been kvm_arch_has_gmem_make_shared()
that defaults to false and x86 will return !!kvm_x86_ops.gmem_make_shared.

> That's why I think it's worth analyzing the cost: if it's in the
> noise, leave it alone.  If it's meaningful, figure out a not-too-gross way to skip
> the entire thing if kvm_arch_gmem_make_shared() is a glorified nop in the end.

Is noise defined relative to the entire conversion process? Would this
benchmark look like

1. Convert 4G to shared on TDX with CONFIG_AMD_SEV defined
2. Convert 4G to shared on TDX without CONFIG_AMD_SEV defined

and then compare the difference in time taken?

