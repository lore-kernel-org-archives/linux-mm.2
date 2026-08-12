Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC21EC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 16:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834B96B02BC; Wed, 12 Aug 2026 12:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7306B02BD; Wed, 12 Aug 2026 12:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D6026B02BE; Wed, 12 Aug 2026 12:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 455F36B02BC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:05:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8D8D120400
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:05:05 +0000 (UTC)
X-FDA: 85093091370.13.6AB86AE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 619A040009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:05:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CdYZ4bnS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786550703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVrpa6t08jfvsuIkBMY48klo1RAJTpG8dCB8zk4ETDc=;
	b=2Gax8BHGDPpEYAEh1kjE/ZFA5ZpcMqJtag4ITSOqECYdleq8Dszodc0vG0uXqNwChcJmdF
	rPMYG+ZU8GRlV8Z5RdozdAqn0lCfYyItbF71LY2ipXHRFgeaqy7EWbxVKCW7VXJ3ZZrkpR
	r5ozAgR4+N7/mOJPrjF1bOo7Z/OxP78=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CdYZ4bnS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786550703;
	b=Npj+UjxETHFSoR50+47lcSWSQQ8btjr5LCJQagIGzKcpwIcJiZik5Hrl3O2tac5etKh967
	iVPx2aTdZ6+r2CBXm/p6lOqUWdWIXQNQhWkI2lbHuJvfZlff+0AfyzkY5VW57hIO4bGl9C
	uVnw1KS+O1gjGoreDspnk9A8tPj59RA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786550702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XVrpa6t08jfvsuIkBMY48klo1RAJTpG8dCB8zk4ETDc=;
	b=CdYZ4bnSgChe7aYw9isAlQzANB1I3LBg35CkItiIcbIVVrDCYC6xzcxD5fTgN+I4o1ebMC
	DX+JsdS2IBz/wkYygKua111brE/P9+YPjD/SlLn/rfO7Owgrtejcd3vcrpsPKs8c8BhpBz
	E1MZDhzYwhKhne+oid/x5OEBB74iNLo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-lK5EGKi7MR6VjtR6bCgiYA-1; Wed, 12 Aug 2026 12:05:01 -0400
X-MC-Unique: lK5EGKi7MR6VjtR6bCgiYA-1
X-Mimecast-MFC-AGG-ID: lK5EGKi7MR6VjtR6bCgiYA_1786550700
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47fd4ee0ac0so1023576f8f.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786550700; x=1787155500;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XVrpa6t08jfvsuIkBMY48klo1RAJTpG8dCB8zk4ETDc=;
        b=orCJEk5532FDS73xCqbw61DkJzX3N0SyJIag0Zu18soXAcGjzxdxGJXH3PnNEuy6i2
         jCPL9tJR7ZK3Zeedr3/coQIafv2gtvY/aWGCpSSdnHV9KhloiAJh4qbQvJyic+q0DkC5
         uFH/DcjYzMCq7+SR89RZwH36KmttcokZfO+MO4cW7TQInwM2Qa7ZLi8WG9cpPT/dssFg
         xRAFfwuFc0Nk4J2IV3pAlT1vxsgS6t4ci5Y6H5IbSOYhtHkQSkybcbdiTJdKtnwoCyXO
         xgg05Ez9vOwI60R0arakjGk1g0vmc+XvWLxl03SIBXwkTUurwoBRoDcCwRuHI2C1GawO
         KAKw==
X-Forwarded-Encrypted: i=1; AHgh+RosR7hKc/EYj4NxNYNRB9OxegYi16NhlLH7Zrib2hitmAdbOKbSRWezSRFcCiSCmzrG2b6MyK5L3g==@kvack.org
X-Gm-Message-State: AOJu0YxWMSBEaV/EEkUz8V0wrzV/W9MvdfgqJxmoR4IP23yeFOrv2ZJC
	Xp5ARc+3rikcLQjwnZK/SlTFsMVZmJ2BhwLYoECjkvUetWTDvGjrHZy73NJLlUcGTXmeuxNMgh1
	DqqohceiZn84qpzVGiLRjlKiGfYz+UAqirSURFHdO7OA3owCWtt6DCwr7vhp7kj5nGf1ptrFDtb
	Fqvuz31MsymJNUrI+jmKnBrrJL88A=
X-Gm-Gg: AR+sD13eosd/Qq7+NIsdKjD+4eGx7ExDIvXYziR6bexhZSmvjkdcC7E7wmklVH/LMjC
	P05tmxfpfZvwOXVtkm5Ob01xT+2R4I+E20m4nzSd2nGuHVpbuRigsTFr9d1Q2OWjVV0yvmG373i
	sN3ZpqvJy3NcROXGhtdyEpsv5PfBxsabH/4TAdX0KDLwjZC6YjrYU3objfskL5p/e7WmnucIEAv
	0D6KEM9ViabLtSJKk2PkKtYkmhZs96riMaXqXni2GdHdSNlToZjp9IJ0HU=
X-Received: by 2002:a05:6000:25ee:b0:47f:943a:45fa with SMTP id ffacd0b85a97d-48152b01a7dmr8831836f8f.29.1786550700466;
        Wed, 12 Aug 2026 09:05:00 -0700 (PDT)
X-Received: by 2002:a05:6000:25ee:b0:47f:943a:45fa with SMTP id
 ffacd0b85a97d-48152b01a7dmr8831732f8f.29.1786550700093; Wed, 12 Aug 2026
 09:05:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260811135537.GC544626@ziepe.ca> <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
 <20260811142730.GG544626@ziepe.ca> <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
 <20260811104229.72fdd928@gandalf.local.home> <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
 <anwraNIKJV8zwrNT@tiehlicka> <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
 <20260812122759.GA662699@ziepe.ca> <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
 <20260812134934.GC662699@ziepe.ca> <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
 <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org> <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org>
In-Reply-To: <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 12 Aug 2026 18:04:47 +0200
X-Gm-Features: AUfX_mxYjj1lPDXZPmp8aW6GUhdMuK_6ly_mDoPX9KEz7UGbw_A0i1e76HlJ2LU
Message-ID: <CABgObfYjdQ13Gd9AH-kck85ZWch7j_E00rajawFuRdt5D=m3Sg@mail.gmail.com>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Simona Vetter <simona.vetter@ffwll.ch>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Sean Christopherson <seanjc@google.com>, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2f-zXvJrXD6slpyDtKeolOw2fr7kjMg8ZWyaVtWFu-c_1786550700
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 5q96c9yom7q8niow95t8tnno1uhddbdk
X-Rspamd-Queue-Id: 619A040009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786550703-786832
X-HE-Meta: U2FsdGVkX1+pIB5SQF72piEyAWZm9qltwtJRbRMIxEnJRsVZlRa0lEROHAzRkF6vODchFsYPyBlIh0WUlcq6gLXhar1QcHGgfQqZ+QMZ8eyotgtx4xrT8XbQrHfHx8NrV+biyD1p4RlYFkwqb8h/wKr3TU5PMuNWHFQQzDsduipSfr//d1cNhTiRv9jv2yYhH8lGn6+Tti+mM/7qMtQaj+ygSP7JsbPO6ofY4jm9CSP4FjQeE/o8McupeJ67DoqsSXXGRg9e6E6y3n/AWTDjhftHi+CcvwCQ55JlefiYB2DJOHR7cA+nGCAO64v1IGusW47bQvpRHLi5h9Ht55d9YbNx67SrwsoLuUzf7foXNTBxjThfjGGUmXz/y/nrGo3AG+tIM/9umqpsRgyDwTxViUV+Rjh1aNhCHfcWU/E08S76GYe4BxBhNPjGd9ukxxoM17cY/ZjKpU8+R/2P71p7fRLKZT2P9smTi+YMs94JLdid7zSYLfKiMvttrtsHLhtArrPtoH1BkP3eduL/BcfkRqGELtSdHUCRvpL98Tx1vyS9ZPyDmT0LqITJTV1Xbrr3PvLChWreSAn2q5yZMVjHgDj/uaqC2KDUFg/EWmPFSW5BqbreR5+VOWZqR4P4FU6LWiJ7w174DV4zOnT2SfTYxlvQF86IiuM86lHF2e8MbekSWZJaxW3yB3YR/nip6C6ckzP6pBGFhPlSwjMEVuO4WEpt40/n4jcIi0XjH+ZCnAofWNpxfz08v4Efd3fiLBeMlxy1AAlEpir6JmCzpugQiQK5Z5vrrVtWNCHa+mC051JeT1E1hfviZ34ZaVuGKKQTg1m3P25BFNvJHVI8owZm88HXj2nbENucFF+b+wd5r+ay7zNGPn6zVKEF+zbwSuJ1bCYDMKj/APKA0JB/8T85eQVikTNRHrL0qQ9g0f7BjyaUF/of+22DP49NX54A98yVsb+pn0qHWl0SWtO8yrB
 xvAfBxNJ
 hruuxI+NRxwqAT/782BYTwDOrF0HLD4LhcnLzoCc9wL3p+jJ2woRLrvhm8nvIcGkFmIc0WEQ1q3l4VX07dVRfwIBTsbhhvzb4ufo6RuVd6ZhmiMMYMv4lK0tEOTaYmbspF/e58vE0w/CYJvyL7SGQ9a95Cl+h0PD+YTbJNpqwykM5exQh0PqPVv+671toP4GY8mQU1rO7+1RuZKNJ5ewVYybdZPVjp5e1HzM+w408gwZVOo/yynW7eEza5pomfDTmlRK0kmrbxi8K/VWBVxVILIrdbIpqnlItKioA6WpT6D3qEoP1Njgykroz4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> + * Atomic-flavor readers run with preemption disabled, so every
> + * read-side critical section is bounded and running (not blocked) on
> + * some CPU, which is what makes spinning here sane: the wait is
> + * bounded by the longest such section. No index flip and no
> + * grace-period sequence update occur, so concurrent call_srcu(),
> + * synchronize_srcu() and srcu_barrier() are entirely unaffected.

Making synchronize_srcu_atomic() spin in CONFIG_PREEMPT_RT is a
slightly tall request - it's basically putting it on the same level as
raw_spinlock. But if the MMU notifier guys really want to make OOM
notifiers atomic, this would be basically the only way to do so.

If instead it's okay to remove nonblock_start/end under
CONFIG_PREEMPT_RT, for RT kernels I'd rather avoid
preempt_disable/enable and only make synchronize_srcu_atomic() try to
skip the index flip:

   if (!try_synchronize_srcu(ssp))
      synchronize_srcu_expedited(ssp);

Paolo


