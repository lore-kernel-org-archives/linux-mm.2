Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF02CF65D5
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 10:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88036B008A; Mon, 26 Jan 2026 05:28:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35716B008C; Mon, 26 Jan 2026 05:28:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A41B86B0092; Mon, 26 Jan 2026 05:28:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0996B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:28:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31B8AB7A19
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:28:53 +0000 (UTC)
X-FDA: 84373741746.29.175615A
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 47DA7A0006
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:28:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CH62mXe5;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769423331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=auhtqvKNqSuy3B8gISIK2h86XPLcfd95W6hmGc7ctWo=;
	b=XtIxetVVyUt3XVs/5Jnc5761xOZ3ucUt8LOG+mf1lIoGhf/Pjt6Ljbgrawz/d43zsF4fkN
	Zv4V+J9MZOeIyvP3CQNUvoX67dwbOgjfAENO4dnXE5TajrbO6d6MSrtKOkFTE5Q9UsBPdA
	Y3ZBhyK6CzD6JGxDURTNSpIECVkiksU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CH62mXe5;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769423331; a=rsa-sha256;
	cv=none;
	b=goCANvMMyIUYTgv8ofVEyGswZsIqWzpFMk3m1MyIIe52krYVEwZZc34JFriIuypz+SikZw
	cwxeFKmfiGdOESAdb0wdU8HOqGBoYtIQf60DehXx2OiIOPSDo+GQ6V80Kzr0bWsswMHVeX
	tVzC6ziF2/ENBpVUCIddM9OUgx9PdU0=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59dcd9b89ecso5208055e87.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 02:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769423329; x=1770028129; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=auhtqvKNqSuy3B8gISIK2h86XPLcfd95W6hmGc7ctWo=;
        b=CH62mXe5+NOI0jjloMjdRdOXyM4cOtsZ9ipxBG9muRgvcSE7sIDQBwaSZGKtlgeJOL
         CP4C6Cr/yta8PeFHj+yayQdmQwetvHepCWIF3lFuAQTsxs8ctwHIPJfZ+Jx8i/vlPwhp
         MdjM8GcWYDclvZ9Ynx9oZp40vsGir4ddtHSovU5PEA3bM0UMGAKXVX6jxGVW1igZm6uw
         iAclRmfb2cUI81QOAI9b+OZXzWWMGeY2qSfeNNjMhPVHRvUDo8WyOCDQeeTV+EGS94bU
         5DYoWfuzS+DUHdmzCqBGLMv3jiL0yf+pqE7fDIA0M7Rykfl0ovweoZrxUCcalNsPgsUk
         OF6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769423329; x=1770028129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=auhtqvKNqSuy3B8gISIK2h86XPLcfd95W6hmGc7ctWo=;
        b=eMnJKJZy5B1ZFwNVeB6aCNacZPtwyJNGrto7yk035fdxlFF/Bbra2Iu7/CrGHe6VTx
         LFbpcdS9/zbg1pecgrJRQkfayDjQET3o4W6mX44nF6x75SBlfCQBwIFtOG6Thcxtul9N
         JUsIY2k/rpLQghk7geSKzvV6QWXBxmheAzeQyVCv/mdUdJGuUXTUR1F7taEeuZ7P5gxo
         epoIJsCujce+MVZLHd97KetfNQaccnzCEzYkNXHARiSokbgwS/oxqeEO1YCeHtxSvGrz
         ZpEy7OIcWjElP5c3koFtpV9ld4FH1nL9qVJiVG6qCUaFhcvMl3OvcbYNDyIJfBUIcUDG
         hN7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWyWj45Q2rMX1wbYr7mVigHyFIhAbrtFLTAz9vxmCh5Cd5U2LjY0VPx7ghkEytvHGXCPSPbKi+qiA==@kvack.org
X-Gm-Message-State: AOJu0Yw1f0eYM/+OvTgvDPw98ly189NoHeew2NAsWLxCvCauoJP9w26M
	WMabCT4OuPFzaxxoWSWGb+gDFxDzBpaDFpYYSBbG6DWViysNTR7vrog3
X-Gm-Gg: AZuq6aLznrsttnEJEn9um0PRNLozLpLNiOiBs0n+KETvT8vzmqvcq43P1jst4jSPLyS
	gSXSFyeJ56o+2pm1hs8M8voxAVpOfN5Ttzz/mhp/6x8pcowdCJjfnicbR3L2RSZsC6HCUrUnoHa
	KdvK8/bDeSmuvr8L7Q47+CwPqsG+eM1CAvgl0hpxc4Ug8bN7IQSt74MLxurQQUqCX2/S6c/O8+z
	2PxJCW3QVl6bakYk/+64mwVBFxlH2FHsa7tEoU1McIaYo+qCXmTxlUGGxwVibAiF81fALD7F5MY
	4+hYjrGbg9072CHZCHfmh9tk9fXpU929w0Ofg5DXr3MSt59NjAANx+lU/S2tAFnxEORCMJTDzjC
	jVm9KGDYgkR7ZnInsUL4E1EBWFUt0au2ac+7t3F4vKtHLJhoMGSoDrQiFZbz4G98=
X-Received: by 2002:ac2:4bd6:0:b0:59d:f5ad:1267 with SMTP id 2adb3069b0e04-59df5ad12a3mr1093590e87.9.1769423328970;
        Mon, 26 Jan 2026 02:28:48 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59de491f8b9sm2596674e87.68.2026.01.26.02.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 02:28:48 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 26 Jan 2026 11:28:46 +0100
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 2/3] mm: vmalloc: export find_vm_area()
Message-ID: <aXdB3lsm3w0fJT3Q@milan>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260124145754.GA57116@j66a10360.sqa.eu95>
X-Rspam-User: 
X-Rspamd-Queue-Id: 47DA7A0006
X-Rspamd-Server: rspam07
X-Stat-Signature: iwqa1ejk8bpbsym7hkrnad61j6s3ucaz
X-HE-Tag: 1769423331-519720
X-HE-Meta: U2FsdGVkX19PGvAnEBJ+jg+ljaYTTV/YYcUDAbIIErRREp2PgOoHnUwLmL5ZQzJgR5CTNQEHau0Kb39HljdjNQ/cRMjmXTpBPCn0xtSyBI0avsRm22a85OQpqb5kmVyvbSKXmKyQ3sLSNtUE/5x7xQbgfuQQGWxp4KDuYwXENJN5IavZTwF6pFjTGFn/4E5/UL1HWRHsLBWZ6eLgT1odGGFthWbZr86wBPLHGQzyucTO6I/ytwk/6Q8k9zU1/cOKJrDx5E63EJ8qXuiKJkeZxrA0f+xHV3PsUtHWfmvRBtTOc1Y98/zafnggyYLw95IYRgcKVn5BstCejtLwOS8jGVz5Q5gbmqGNXbUsN+mexm20n6qAXDPGlbhMm+bSSX8pZPNAtdMFD23eAM0a7UoXMnFLbReRB8jbAjhyR9SWNcwKb94PBXF1uuF9YJpxuCHZYP2RdeWXm/Fs/rTsZreL1022HXbcoomh2A8dwVnfPjnqk1mRh+Qrn1PFaT8IscqYq7p6BodlQ/LeSsb9HsTuVxnsG/tO0L7BnlkcD4lkw5ttn4g5T9JLxF2ajmEt65Zi1TxeWklK3YM7Kff/uhr8rFr+r2ZBq8ocpeAP3jsPblhO3r3lOONQp8ZO9SgOf7F5vsJEnR5pNDqyU+PIhM+EoQJdA0kImc+bOiUADxcs8jl8mdwjpcRCQHAgr7WKVb6nJh5FkE/yw6CxiEY9XOdr+lXlM8bD+o0s/y2Vb6vyy0rk19ztRsIuEZZDCHghUZY4cDO9uabpzAZTDKHs7k8LaR0tP52ALf4vr/jXbqdyufzbZjqmzupaD4B0v2UgBoydBtRsSoGNFMeLu7DnbjZw45T+EXRpZnPqhKtCwR9Ry5k84Qba1ISLc4RES/H0wU7tp4ni6tDQMEg6J2Ywy9lNyhQcdD3t2/oMB1jnLJT0PZbFpYiQbl8QATsUDXADEPjIcNDrGY31QOgyHBlT1Qy
 3qxVuQNp
 aMBc//R9dm9gT08a87YqSSrQXLzV/i2fP4kw+4UHzCxkRHsbMGaAm4qJO2v4b7OB1SpUCzpw0bd03wyDKEMQkcfnUaAybnJRiYQ/Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, D. Wythe!

> > > On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > > > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > > > find_vm_area() provides a way to find the vm_struct associated with a
> > > > > virtual address. Export this symbol to modules so that modularized
> > > > > subsystems can perform lookups on vmalloc addresses.
> > > > > 
> > > > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > > > ---
> > > > >  mm/vmalloc.c | 1 +
> > > > >  1 file changed, 1 insertion(+)
> > > > > 
> > > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > > index ecbac900c35f..3eb9fe761c34 100644
> > > > > --- a/mm/vmalloc.c
> > > > > +++ b/mm/vmalloc.c
> > > > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > > > >  
> > > > >  	return va->vm;
> > > > >  }
> > > > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > > > >  
> > > > This is internal. We can not just export it.
> > > > 
> > > > --
> > > > Uladzislau Rezki
> > > 
> > > Hi Uladzislau,
> > > 
> > > Thank you for the feedback. I agree that we should avoid exposing
> > > internal implementation details like struct vm_struct to external
> > > subsystems.
> > > 
> > > Following Christoph's suggestion, I'm planning to encapsulate the page
> > > order lookup into a minimal helper instead:
> > > 
> > > unsigned int vmalloc_page_order(const void *addr){
> > > 	struct vm_struct *vm;
> > >  	vm = find_vm_area(addr);
> > > 	return vm ? vm->page_order : 0;
> > > }
> > > EXPORT_SYMBOL_GPL(vmalloc_page_order);
> > > 
> > > Does this approach look reasonable to you? It would keep the vm_struct
> > > layout private while satisfying the optimization needs of SMC.
> > > 
> > Could you please clarify why you need info about page_order? I have not
> > looked at your second patch.
> > 
> > Thanks!
> > 
> > --
> > Uladzislau Rezki
> 
> Hi Uladzislau,
> 
> This stems from optimizing memory registration in SMC-R. To provide the
> RDMA hardware with direct access to memory buffers, we must register
> them with the NIC. During this process, the hardware generates one MTT
> entry for each physically contiguous block. Since these hardware entries
> are a finite and scarce resource, and SMC currently defaults to a 4KB
> registration granularity, a single 2MB buffer consumes 512 entries. In
> high-concurrency scenarios, this inefficiency quickly exhausts NIC
> resources and becomes a major bottleneck for system scalability.
> 
> To address this, we intend to use vmalloc_huge(). When it successfully
> allocates high-order pages, the vmalloc area is backed by a sequence of
> physically contiguous chunks (e.g., 2MB each). If we know this
> page_order, we can register these larger physical blocks instead of
> individual 4KB pages, reducing MTT consumption from 512 entries down to
> 1 for every 2MB of memory (with page_order == 9).
> 
> However, the result of vmalloc_huge() is currently opaque to the caller.
> We cannot determine whether it successfully allocated huge pages or fell
> back to 4KB pages based solely on the returned pointer. Therefore, we
> need a helper function to query the actual page order, enabling SMC-R to
> adapt its registration logic to the underlying physical layout.
> 
> I hope this clarifies our design motivation!
> 
Appreciate for the explanation. Yes it clarifies an intention.

As for proposed patch above:

- A page_order is available if CONFIG_HAVE_ARCH_HUGE_VMALLOC is defined;
- It makes sense to get a node, grab a spin-lock and find VM, save
  page_order and release the lock.

You can have a look at the vmalloc_dump_obj(void *object) function.
We try-spinlock there whereas you need just spin-lock. But the idea
is the same.

--
Uladzislau Rezki

