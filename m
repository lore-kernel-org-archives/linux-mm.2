Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA6DECA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 10:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919CF6B0093; Wed, 30 Sep 2026 06:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9956B0095; Wed, 30 Sep 2026 06:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B94A6B0096; Wed, 30 Sep 2026 06:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 439476B0093
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:28:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A20E240733
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:28:41 +0000 (UTC)
X-FDA: 85270054842.11.0313351
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 025DC8000A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:28:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gb7zXE9I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of naveen@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=naveen@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790764120;
	b=18Z2J4SmAeIv6sR4tKtw+yr7DbsQSQ6k9gxxrN1mZYICdS8vJFatNy8nEY5Fdi8Ki8KvJG
	jGD2yPxCLnvy3LyK8dkZYRYgBIDzVoVMUT3L/qEsat4AsxlqHNQayJSm03NLLUapdTJj9g
	o1ZbYPZk24xog+VHdwAt3DJ/orXpJcs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gb7zXE9I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of naveen@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=naveen@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790764120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3AlfBCTmpruVCLkNFQRzrD/em+eWOpqKpyOiivU3oII=;
	b=JyEqtFfxQPJxnPnauTICCnAwsCDJcRzIt+mFiAtV2qc3QpWpov8qQmFTJBrvCuOm/l8K/X
	EojK4a2vh5N2dHb7xa+TIUQASXWXRABii4QhKH9Alo8BSPeoIsCPErPlb1U6OND9QMpPn1
	A13mw79+pIlV+tIEcd+JpaNfN/p0gqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 695C0419D2;
	Wed, 30 Sep 2026 10:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6EE1F000FF;
	Wed, 30 Sep 2026 10:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790764118;
	bh=3AlfBCTmpruVCLkNFQRzrD/em+eWOpqKpyOiivU3oII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gb7zXE9IoZs6cbj6Ja6aHJwZtGMS/ICAce6EWUxPoyYZD+wWn4JQB36ydNcIHy81P
	 Ix6KhornLVyu7QjQImjuYJQ6q3ut/Fpfea/s1Pxc6E9B/gYaAfai4tv658RbGEJV5w
	 c2FUbn7dDgVRndYi4OQH6cCcxSIYm4BWxmElD3MZlIFl78mR1DXuYpzw7KolJxBXXf
	 DG/sXJIz9HZBpHeGv5t+Hbz1DPI/xqH0NEWgu8GtDXVqzAS+LWJi2HH6uipj3+6Kyb
	 ynwz5InOjqSt/H9stD7inw5OssG4dusyaNgA1GOGAjyR7JwM8ARquCvuPpAC+nmpew
	 Jb/Z6N0cSvjjg==
Date: Wed, 30 Sep 2026 15:55:34 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Michael Roth <michael.roth@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v11 15/46] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
Message-ID: <arzjFT1Fqzcuw9QM@blrnaveerao1>
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
 <20260826-gmem-inplace-conversion-v11-15-0a15d8a799aa@google.com>
 <ao9CKMXAX-hScRSa@google.com>
 <art6ARechyK0iytK@blrnaveerao1>
 <gqybhgtzeufmbohckesirsbu3ftn4s4i3uhjhaestphuppvth5@zx7lqsldosbc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gqybhgtzeufmbohckesirsbu3ftn4s4i3uhjhaestphuppvth5@zx7lqsldosbc>
X-Rspamd-Server: rspam06
X-Stat-Signature: x3mtadg6rcu7hjut5u17bmkqitz1s7u8
X-Rspam-User: 
X-Rspamd-Queue-Id: 025DC8000A
X-HE-Tag: 1790764119-193454
X-HE-Meta: U2FsdGVkX1+3/juqknFB8iAp4uLG4Zh/0s6VYLtGSwSE3QY0bxT1ihAtZS8zrk61LBbtS+u062j2/gcn+sqN09QLarbmxE4IqGh7YAhXAQqvKEZGRaXlQDpXiI0nY7EXSHpsW4LgQ2bO8NSvZBmViAcp481MM97pUo+/tHrNWEgFh7e5Y4lbB0Kna1M35mHEHQSrix4Zqc6eBYavYC93/R6sHn8B1Apl0MA9JiUp7K0N/fCFIBMvRHTRunFP9VGCf4Wc6ioICjNlChk497ImZcH6MvwRFCx7n8v4O9XCEMpvJVzWyhtLEQ5JD38US2YtHsvdykYObRYuk6wCiU8/qeC8VKxaw4Rb2N1lsgM2a8z5/e++CoWdFSMJH4t7Aj3ny/KY8UEhK37UfDJrvj75TiPc8QIFXCm5P6rLRnJQQMO1ppEPF19uALdq8xi/YLSHA0JmpvR7W9xyIe/bJ1QUXHq9xEprmncrbT3xXiEgmh3xRPkyqA5WHLPlrJY6GNtfi1i25nuJO3uTRJ0E1ucPnFXWTJEkLUt/QhFKeHty7vPvdaRZ8/jYzW+9qCUCDCTgX8d+dvgATFQDg0EkD/clXyx5yqlaNYhb3OJ9ncMePHReCNa2YS4kv7ei+hDPZnxucPyrIfePBWzfo6YXg3TC9ngnFAgu9mrUX66b8XqnJd1Z020xWtrJ5UaQrG8z+hO9fjG4la2TAP+fFGiVNruVLscegg1jecBlsiQEFH8tunBxJzS6dRJocF4OrRCttPq5qaOCvC0486tuTMENz0UphwpYX5r1wJ4bAWHKym/Wu7kfdiZ8SEf/wZyhuSse6Cw2jTrwGkDqnN0xdLMbyDjsFHxazVcnh+MFymP1DKaoKmv9g7UoW/Tp5F0wOoEwrFa3eJqG7lXU9Z4/X2TCWlMCmH2fLga5trRvPprs5ZmHI+Ozn/Y/YVf5tU4Vc4LSAHu7ve0yiOrPEsiZzFhM42Q
 jN3OfAOt
 fpbJW6GaojFE7qgA+q6HQ1ROOQYy/MvvneXr8+OXvbGwXBZYsiTZom/1vCTLh5psWBlPVZk/Bx71FImnEvq3tKhRr4Z7tTiQ5DS6ToF+GvC2o2Uif/fBUYw9IWnuqD1iBbXNyL2m5ub7uGOcET9xrB7QVX7AQdUvgNLNqhxWOe9bLJFi4yi3PvxGu+CgxgIxDLeNyL4pgCqyH3NYVY7Ifn6AatgQouztXYKafquc0mSILSvoj2kDQUYjRzn2QSFLwHURWZrZb+rVw94SM9GWTRm/U/sAS3fkmsI5aKuGHD/g5B3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 08:01:45AM -0500, Michael Roth wrote:
> On Tue, Sep 29, 2026 at 03:10:41PM +0530, Naveen N Rao wrote:
> > On Wed, Aug 26, 2026 at 12:44:40PM -0700, Sean Christopherson wrote:
> > > On Wed, Aug 26, 2026, Ackerley Tng wrote:
> > 
> > Can this be a problem with gmem hugepages? Not sure how that is going to 
> > look like, so this may be covered in other ways.
> > 
> > But, as it exists today, if the guest converts part of a 2M page to 
> > shared, then this skips zapping the SPTEs from the call in 
> > kvm_gmem_invalidate_start(). sev_gmem_make_shared() then issues PSMASH 
> > to convert RMP entry to 4k entries and we end up with 2M NPT+4K RMP. If 
> > the guest then writes to any private page in that range, 
> > page_fault_can_be_fast() returns true, fast_page_fault() only checks 
> > permissions with spte_permission_fault() and does not do anything.  
> > sev_handle_rmp_fault() also does not issue a zap since it finds that the 
> > RMP entry is already 4k, and we end up in a loop.
> 
> In Ackerley's hugetlb series, gmem will split the underlying folio to 4K in
> that case. I assume, if we end up adopting Sean's proposed optimization, we'd
> update the attr_filter to force a zap if there's a demotion, similarly to how
> kvm_gmem_punch_hole() handles it in this series.

Ah, nice - that would be better.

> 
> I think as a general rule of thumb though we'd decided that guessing
> too hard at what hugepages will need is best left to hugepage series
> itself (TDX prep work aside), because it always ends up different than
> expected :)

Got it, that makes sense. Will consider adding WARN_ON_ONCE() so the 
dependency is clear.


Thanks,
Naveen


