Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B162C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 20:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84EE86B0088; Thu, 27 Aug 2026 16:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8026B008A; Thu, 27 Aug 2026 16:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F936B008C; Thu, 27 Aug 2026 16:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39FA26B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:54:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C024D14016D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:54:06 +0000 (UTC)
X-FDA: 85148251692.28.B6F50DB
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2102EC0008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:54:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i1VfYyJs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 366OQagYKCNAE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=366OQagYKCNAE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787864045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZEfQxTOKQyDG0uZqNyCVnRw0wmiuuoqTc9XyRDn+pn0=;
	b=hW2xkRvs+tZnrEa23n3QXWBYI+bV+CtSBUt8fJ+E1yXfpHGxZtr73rJ/YB39xmJTtFgez2
	qPQ8RN1Sf8f2wPyau/SQYqISksh3oZSV7hucAoSa1Up1Hxu3rjUWsMk+DoYhw/KEU1MVhA
	3nR1pqqBQOVx/PssIr6M3/GTKxTUPtk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i1VfYyJs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 366OQagYKCNAE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=366OQagYKCNAE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787864045;
	b=jDxN4PsmWRc29XaNPaP1dbibGPJRkaUl6YtVoaIGX5pB2Fn8XuXYAyXtTyRZwjgBmcC9nW
	xLhXK2/8tnOB4W1O7uG/HAPgXA7axcmF5+eHRL+f1/cUgwvYCwyQJQt2+jrH8T/mU4NmCg
	rOOPjwBJS5kaUuEOuVw2+49h4v3xmec=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-85321e37104so400511b3a.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787864044; x=1788468844; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZEfQxTOKQyDG0uZqNyCVnRw0wmiuuoqTc9XyRDn+pn0=;
        b=i1VfYyJsFF2+z/Fm74G447rF0KOOD1BYsLo1qGJ/e+Pofc/Yx1lcyQaSmL5VxS+NqI
         OsZTOqic9U6+QIyD6Hb6F/G1iH6wX6F9wVmEQguqlfivO8x2ChjioUvB/mWNOMb9gV7U
         HPWt9ptLon/MNPAdKGZQlv38EX+QVMt3N0Q7Jim4befAHW6r6BGgGHKCEfzlQz07GJxb
         XfFuPrNy2xLVEyHBJha4SNsGOOdVjqMjRN9sILHCvtnWkJUEQXqIL25chw3qj8+ZnzZx
         dQl974ZtekggyYlP4dM3j23bXdlIi4EOEMCjP+hvdQsHYH7W7fZviTDsoALlqGf7vRQX
         QTBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787864044; x=1788468844;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZEfQxTOKQyDG0uZqNyCVnRw0wmiuuoqTc9XyRDn+pn0=;
        b=K75GbQlAqZIbZTYhcWUZZ2sqCg4oqqSS0Wd9D+CVZl6fbvBrT5q6jOlz+Md3OgS/7J
         Gj2bkHQn29lkODf7KZzb/1nuKPf711TSbKbQpvd2Q45mSGyNayHXIBRsqKjjVu6pjDfn
         Fi0Kn7hwQOs0Z9VB+CkdTF7az5E0s2LypvR7GfwV07VIAqo29SsMOHWD44mQOH/i9o7P
         ESbGc8AdEEJOJsXn5ZCZw5PKqH8PULL0WizrO9GjcaI2QAdkA0lArtuMbnIBTalwuHtN
         q3F4ZSXgBzyVU8EkjTH+lfA/SGmqyqMlYh854nOfOZNkfwGyuH0MPvQgClyCpl+6XvcP
         cUzA==
X-Forwarded-Encrypted: i=1; AHgh+Rr1q/ZEl3wyqFnPB/DoG0IbECBheG4f0cDy5GbCweqLcTH7xUyCmTIlvC9VMN0yZQVBwdZ/lZQzuw==@kvack.org
X-Gm-Message-State: AFuF++nbIAuHG0/d4WKbieUjWTxADr/WvlruHn9tZmKDNYiPAyZwhrDl
	ksQBN62Gk03DWEWBzIcoD7NBIfuHnXnI51riuwJcSJ9zr+4JFztEz6cpnmQ55V83a+/pEP1MCqi
	u+Y+VmQ==
X-Received: from pfbkr16.prod.google.com ([2002:a05:6a00:4b50:b0:848:5480:9ac7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:e09:b0:851:fb36:a702
 with SMTP id d2e1a72fcca58-85629f09cc5mr4062708b3a.9.1787864043380; Thu, 27
 Aug 2026 13:54:03 -0700 (PDT)
Date: Thu, 27 Aug 2026 13:54:02 -0700
In-Reply-To: <ztufznh6v5md5cn56t7pvokubvbpc3yki6dhiilgebb5uq3ju3@aa4xc6wwte5r>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
 <20260826-gmem-inplace-conversion-v11-15-0a15d8a799aa@google.com>
 <ao9CKMXAX-hScRSa@google.com> <mtbqvvvpwbzybgy6z47lwui6ag53kyubub3hkczui7u72zxesl@lnwsglrgwl5p>
 <ao9px1j7CLYXMiGP@google.com> <ztufznh6v5md5cn56t7pvokubvbpc3yki6dhiilgebb5uq3ju3@aa4xc6wwte5r>
Message-ID: <apCj6gz8x24Dkle8@google.com>
Subject: Re: [PATCH v11 15/46] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: cdi4jn73efmyp3ujfwbfau9rkz7wyom8
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2102EC0008
X-Rspam-User: 
X-HE-Tag: 1787864044-5461
X-HE-Meta: U2FsdGVkX19haoPy2h+h8c9ikquErLSJ/Tb2rrYGhxI3jMWIPuGPOkM/r3cRpVL1J6lahSBufcaQymC1jirRARK9QTNoxxu5ncSeYL97C5a/R9Pi5oy4319akmPXXPwPWFjDFnlBvNb1X2U+RpULTWW69FOcxYikQyljDF4YEp2zvBtV1EANB1xV8mtucoI8xqss89HDNRaVEoI2kqCee1E/TClMP4b5Y6wV7FHaXWxJjrbMSnW58VPFdFp2SoQPaBnf/3TAK5BqZKZnYtKV6/NEr9h4JcfqtNjyeM90fZRURfXBM5ebYsTKYkJPIwvTndC244421WqVgd9HTtjSue3XnBBnmSmG4S13tPY2uWedzz/6qnUPpZard9dfA/ylLhjyvWdM0xfuwdrdaS7V/iP/6mRqkiNzNM+1IQwgMqmt0SqCDPZmfiNN23X4HOjw7s4OqwoLcDOgBbqWEBA8mtKTyx3ToxSuNCyekO2JJ9A5GKfI+/2O+gZ66UMrKhEeJYlw+2MnY81eDYuzzXXWV0dBnILuPVI4op8/DPLPkHId9NvxmdHALccbXhdPSKo32JGm2VQw5WwtCy5d9nUTb6qj4QKbk847/sv0Z5PJqwXyiWdfUbGerpvY23z7oCqQ21SIGasgmRJw4K0Bjq3laBrLFX9NVgqaHCBeKn4NtbZENIpXPBT9npZIsAZ2IjYv6Z4EBJUIM1luNb/txsX44HZG5VSmczN3sFLxRX1Oveudkh73793aC4Si98gaVryo/J4cnMRhko16zOTozhnRiuHI2U2YnK0haqchm9UwcLB+SdXgOBQkobPRbkkDd/xasR0AS4exB+0pRm+kXWyvKx3mnhmY3CgKJqgNDeqmgeXgrAz0P3oNQGrxDeyVM9s9g+n1bT+rwNou/n3eQJ3gGZgLfijOmSRr7JItHZFpTvdzikVBPqma/t44HZ9hdoH0YwVHQ3kfRxCqrW1XgHA
 wnwYDJP0
 CEz3pdhIxQeh5UbkYl9NjUTzAqiIbubCzJ7cR8nO56TkIA32Z/26CugVxSVqFUEUKFnu7g8/54RmvvZlTefiga2gK4tXjxNQ4qvQ1EypWn+Vmn1GcnN6Q8IAWQqktudpvqxIbEWOQXgnwU+uO5xI+DGG/edao8IE7cN+Dz0zpHUCZ+GEXC6aqgCftzivYdNFAUcNuWNZK1GhNIhM5hjooBit6KhIqL1OtH/thswZAVrpAyvO72DL5HrtHLrH+ykafVZuRi8ltmGYwupnLjP7ZpX7337Ipf4bwKeG4zo6tkA5tXbMbOv/qOT+vMzgNrCDYRTpIlyQtPQL2fipNhO9yWAKUEp7WOIDfch+OQkL2dohJpi78mnLRpCnCQxunxtycYQGFMOD74ab/3dDHrn5hH0+zh2o5jxf7bKzBIgUCSkEiryEFyre95bU0FBQEDGFi3RGCpsKAA+uqb5AIv7Zf2Vhc9c3zOK2ULcgKoX6ffQ4XvUglFMWNg8JlaXqaLsg93DlAGF3wZm0ZxzXM2C8R30qSEtKZFNuL8lngWY4kYvxQFOm15VRVg+hgON3NZ+egn0xQ5rXocMvXQ65Oty1cOjGTDryFE0K/DuWbLPH6v68f3rtxAUQFX8FnUkN+JD+bEulp3p/di9HU54CCzbvUuOoUIngjhTbK1BEElLg5Gx4VxtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026, Michael Roth wrote:
> On Wed, Aug 26, 2026 at 03:33:43PM -0700, Sean Christopherson wrote:
> > > So there's real performance differences here but it's sort of been
> > > addressed through a solution that offers additional performance
> > > benefits on top so there's no longer as much to be gained here I think.
> > 
> > Or another way to look at it, eager conversion would allow QEMU to drop its
> > workaround.
> 
> True, for SNP at least, but pre-map is nice too, and not really gmem's
> place, so most likely KVM_PRE_FAULT_MEMORY would remain regardless.

Hmm, good point.  And as below, we can't sanely avoid the check in kvm_gmem_get_pfn()
without reintroducing the preparation tracking, so the lazy approach is probably
the best option at this point.

> > To be clear, I'm a-ok with the code as-is, I just want to make sure we document
> > exactly why we're choosing this implementation.
> 
> Agreed. My understanding of the current design choice is basically that
> it doesn't *need* to happen here, since kvm_gmem_get_pfn() will already
> trigger it on-demand when it is actually needed (or not), and that tends
> to happen at fault time when other platforms like TDX handle it. 

Oh, this jogged my memory.  For out-of-place conversion, waiting until
kvm_gmem_get_pfn() to update the RMP makes sense because KVM doesn't know whether
or not the SHARED backing as been allocated, and can't easily get at it in the
first place.

> To handle it differently would be to go out of our way to make SNP special in
> this flow in exchange for performance, 

Not really?  We'd still need kvm_gmem_get_pfn() to update the RMP to handle PFNs
that were never explicitly converted.  Either that or KVM would have to preallocate
everything (ewww).

