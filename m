Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3897AC5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513896B00AF; Tue, 11 Aug 2026 11:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EAA26B00B2; Tue, 11 Aug 2026 11:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4004C6B00B3; Tue, 11 Aug 2026 11:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 200786B00AF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:29:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B31201C13B4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:29:18 +0000 (UTC)
X-FDA: 85089372396.07.E98B4C1
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id CE64518000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:29:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="E/le3N7t";
	spf=pass (imf24.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.42 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PH0RdPEa3oSLEapGNLL6x5bM2qkhDfi4j65pHbraVdA=;
	b=w+ms1RZVhF5d8QrolTM7tvgO0BfZZWQ8R+bscWOTggOQlkfbmCiIx7aT6X2a75CPtYvVfl
	00cjee+WWeryjaFhjmH4cuFcGwk/c1eZu+LAMnXSSiVO7DFeYIm2vYAN9zEaejmK6lDBTY
	gsEx5Qof32HhBGLZmeZFgVWMqqnRUrc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="E/le3N7t";
	spf=pass (imf24.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.42 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462156;
	b=e0wbcRGCBYVQn7scnOpqhAx/zYEWfioFGpvmXweIWYqOz6XGputLIqjeefkdRn5EOoEkEQ
	4QFvN3qgoNQ8n34+beKuebn1Dr1gc/cxq3FisADP2zJBxMJWhP8ieTStmzqNnN+3eHCqTW
	2i1PEduKdOYx5PTInkMR/n0FAd39BpM=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8f23e851626so6470436d6.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786462156; x=1787066956; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PH0RdPEa3oSLEapGNLL6x5bM2qkhDfi4j65pHbraVdA=;
        b=E/le3N7t9FKlqSs2wyLaChUkn/fbAejODtnSDVo52un2syyDYwPo5kl6n8x5ZPeIWW
         lftW+S3Sf4/VdCLCb4sXH3ZoxVZwO00FyTgR/qo790L1C+vKG5pdkKL9cjgbMWLENxEy
         3KYwSUoLRVuwelds/YmFIle8R5vvldplSVErd3gCk1GKO2jSu42A+HzI76RkJKb+e/rB
         bIAiI2XcMyvGTDXbZ4OwPvmXs0XQgzi2wHNlMObz47TMSPJRLT4mW26sGJ7dPD/SicrW
         SUDijpYrMndB2ugNxOMdwpvvxfXsMsqcJ66PnwXCZb2C2GIcJge9wrZXrdLs9PBcrUnq
         Efzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786462156; x=1787066956;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PH0RdPEa3oSLEapGNLL6x5bM2qkhDfi4j65pHbraVdA=;
        b=Qv8YSonD1SpGCTVi+px3oKfMt9cOb7GVmm/grBKw+kzolIVEq82T3rt/6q/t8XXqFp
         4tA9zqUzgbGEzaVH9kv4zJilSl6heZQQBL+aV85v5L6GWxBGGpVjkLBWOaknXVux8ruQ
         gnsj6RwAmV4XgGMzphf9M+HZ9cFN9M8xn7l9rXI2iLGPGwONqS4oD0hvSfv5fB6gAFJ3
         G1EahuwD8tbBk6nyoTA8we0Ix3drM3f7CkijnAWGn0yDS10ywNk6GC4vC/7Xv/71eZV0
         K7QNpF3/oNCg8Lerm25soHqnlbLhVZt3ukdWeJ48+Ni8XtPwg5EcWO+6wW/WJWc69l9C
         GFbg==
X-Forwarded-Encrypted: i=1; AHgh+RqBa2dSegXo3vvby4oyic7z45ASiAgl3JHzvoipKUnIjwQ0EQmVYseFQR8Om/05lK704dBNOBxIpQ==@kvack.org
X-Gm-Message-State: AOJu0YxwGQThY8nC2vpEoz5Bht98Jvqc4kuH0hdjnC9wi3aIDh1UHyvQ
	Xl/rUbAAg0C7pNo8BHVvIQr4ycu9W1772Gd1+MC5sjtMUHETVHjH/VfI//2hjyJnusY=
X-Gm-Gg: AR+sD129EGeQHlNux1VJkcgLQeDA4vnGO01MwfHXQuMrh3aBigJ6JbDbPQ6RFRu55sr
	gQhNck/ZkP0Ld9qKLxSs+sWKcZylFTq67DNzCXaH0YEFYNdFbeopZ0mhLATp0HCx7KXRjd7GiqM
	DMWDkhYKoQGe7wj0hgjNWei/TCv2uovnbMdWX5rg76CHoXTJ8rn72faQ7L3lkCIy+CVXTuNWrzR
	aBvtBSzREe6RQkL6kx+nJUT+iRXZYYcI21oqq9prJiDnpHe5Pdol083un1Q7OQ96IVQ3G75uUd0
	4ztFeVVxug8bEJfudgWJXyiSUFluABASKDsk/8WySdYhssmSZDSTDqZXtU7tLmAuGIwv1STwQbp
	6ABR1zV0xT+jc2RVV8BpKQ9ulyoO4w4KPwtOmP8KG5TDvZj0Azf2YQSHzbBC/OoXbUgEnWJyDnR
	26AJI5hT7ovwxoDMMkJl0njEUCEMwPSti+l9UJqg==
X-Received: by 2002:ad4:5ca5:0:b0:90a:6016:deab with SMTP id 6a1803df08f44-90a6c0dc16fmr9015366d6.8.1786462155946;
        Tue, 11 Aug 2026 08:29:15 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c3c1d73sm1372206d6.34.2026.08.11.08.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 08:29:15 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtoPi-00000002X6a-0ioj;
	Tue, 11 Aug 2026 12:29:14 -0300
Date: Tue, 11 Aug 2026 12:29:14 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260811152914.GI544626@ziepe.ca>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
 <20260811135537.GC544626@ziepe.ca>
 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
 <20260811142730.GG544626@ziepe.ca>
 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE64518000E
X-Stat-Signature: zw86cqwzs95idcjqwbodo8bjrmu3spaj
X-HE-Tag: 1786462156-812431
X-HE-Meta: U2FsdGVkX18o9TwfDc6SjP90ySA5L5OJcKz3fJuyVtyOnns/Vf7QPh0n9MBAU89e9ii5sPPnq9JJYg1w2cYMtsfp/uVcsn0CgrZ/LVb2bRdd+AmlMMw2EODly+nRDkLy6xyNi6gPP0AkG9rhCD0db2DNH8BJGI27pfD4vZueCsU/ESMRoC0Pcer20jiXos3fMZSbOiY3jrx4Qy1QTVESrPLtYT3AcYQH+RzK0SmuuuOJdYSrl6ICtLDmY8es/DXL04VXc+2n23GhAXnAEDpha2trJ3JqM6WqF+kPNkbLahWl2l2l+hC++VFy6FcMmeUbP8Fq9R6OteEY3/0EfEgZGGY1UnYNaUHJUXhVtZWZtNjRCXFUGt15SWMmoLZETguDFnJOLc/ABuIb216IYlu8EptpocPmBMxbJ62G5MP1wffGa7sRSinCzE2MLNJcyjm8Ts/G58fDEuKcGkxMbUSbEtI8wFu49XqiBuDaPvOnmAH4FwSG/8VQ+Dw1XuZMqTtkkvgXDZKJknip62N+H5ugfx3sO+9MJHZ8avnKNsfDx4y/yIdnIXL1V5SbG2uCaj0eamaCPJMTgndBTUmDoEZ+cNYGhKXm3jsDHGVWMmRr/cxICK1qrW66JBYHTbpfX2rjcOoYcMp2cl+JIgkBO0XTIKn91VPzS/DY2McRT2F+O5rHxlXgWXdUeuUEfYiTsHqa+A8OyP/RZOiZ3TIVgV2hGrUVH3Rg63eR+gLwouvt12s2Y2J9t4Dptbm/Ry5V78LOGMCGCNs8HVhfHJrxlM/AZOenqozhghOMhvkXQDZYlzDLTPn/AYdJAaArHjVs589scehAer6dBBJMWGr05uJypibXj+P+DAFVIHXHPXaTODnmz918U4mQOLOCJ4gMcryu8F7a6BsqHnUGxdbSTQmRye0VTXC+MDeBvpdXSWUfTNES8Kegm2+B6urRr+4wUHIAu4QdSzyqFlmpHsqVr91
 eSKcOYxk
 uTHMeLhqC8TuLflU3s00iPZwvObnvf8NKrYdN6rkoCmiyp+HnDEu8kz90I9YTJim+hJXaUNAWqY9fUyKlSSyMM6H7SgfjTHc8wPZxpbN9JJvt3EKpEUsSuZU3HmzTL0CsEmEQDMH0PLhVN2nuHr0YJFlC3G+pdK9zOX/zg2ysH7QL8UjxRnE9hvDDEZMZaeuNouzXCuMMLuL7JHzGWQj23nMOQeGsm62cxC2U3chZ7eDwDg71X/ckcZ3+QZqd/TycB+wLiGXkfo3vgOPP6ZS8EiDLcQDSBvd9Nq9UQYs8zM4MAnkme2PODtCcgYYTu5YBAbNbBXfTvznz+WA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 03:33:18PM +0100, David Woodhouse wrote:
> > At the cost of completely destroying the mm shootdown performance with
> > 1s RCU grace period waits every mm operation. No thanks.
> 
> I feel like we're not talking about the same things here.
> 
> The KVM patch which this enables does *not* behave as you have
> described. Have you looked at it?

It does, it calls synchronize_rcu() from
kvm_mmu_notifier_invalidate_range_start() - don't do that...

> Nobody's suggesting that we force any *other* MMU notifiers to do
> anything that they don't do today.

Sure, but nobody should implement their own notifiers with such a
heavy locking primitive.

Jason

