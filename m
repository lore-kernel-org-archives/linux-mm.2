Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4674C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 16:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C93B6B0146; Wed, 12 Aug 2026 12:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57A616B014A; Wed, 12 Aug 2026 12:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468E06B0150; Wed, 12 Aug 2026 12:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 124CB6B0146
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:07:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90B9DA0400
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:07:55 +0000 (UTC)
X-FDA: 85093098510.15.54932B2
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id B3E914000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:07:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="LKy/B9Hu";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.45 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786550873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LjMnXy9HZacJlswsSe7CtbuBRK5QuLVRHumX2nxtuE=;
	b=KPSr7PgWgbI5fF0ojusnKGwO+YuJCbOAEEsulFphIdBMdAyLKpVPuBviRK5KMQxGVsFVRT
	Ufx20ddvsh15BK74Bpc5VbnBPNgo1SmknHZmXWH/R32FCOrScmzY/zSZqh5qpZFdEbZL7v
	/qHOlEaRv/sj5yRff4vWB7TpOi51fRo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="LKy/B9Hu";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.45 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786550873;
	b=ER8rBpzXI/ZCHIGNaW5vSk+9Knu2V2F7AYZSyvNsEtbqNvIwHqaFfJ9TfS/KuhAgdgvUcY
	tAuo60K/Ku31aM7ia5uZcGfr1xm/70AgEjKklCVsgnMgtUbE31PoFihIpGfe33yf7Dd0tf
	6cXeI3hGi0bbPLlGZiXHQQ+raV04JtY=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8f186025973so11231386d6.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786550873; x=1787155673; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5LjMnXy9HZacJlswsSe7CtbuBRK5QuLVRHumX2nxtuE=;
        b=LKy/B9HuUip81CuSIFYzS3W4YHv4mjWAk8OJbudIE5WIttgfz4A9g3/g2XEC7GDEbk
         vsVUZAanN9GMKDfJUyxiqYd0JbqcKLi76rjgKNDsOJcgKGy3Gy9hfcOTAgaIBl2t7Xrc
         br8jOxC1yPyTACynSIhEZfmOze37/GhKDROq1gLI8sgmnO/DWR1g5dmU5qyM1WtQWa1n
         wr0Yxhed6W7vPh/hKkVFoRg1iNczRDyvASpfCg+jXWLC0dka82EzOvSuh7lpJs3WXQFQ
         +y8MgqEAIssambe7tvrJITdZlW46reeQG+YpdEn9lgZJV45+tXgabCi49KDUqpwA6WDg
         k2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786550873; x=1787155673;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5LjMnXy9HZacJlswsSe7CtbuBRK5QuLVRHumX2nxtuE=;
        b=gZEbdCPwaYuKu87iIK5avfJpildk3Ycy7LBnr+8eScgD6R4rR8NIRUp0fzrJ7YZ7g9
         XWp8Jf1m/9DVOpz5kz5MPV6Yrp131SW1ZUB8Uo9og3BL0mafbktJm6jTTueFAS2PXMJH
         HZmvmM9NgrWK9G7JJCT5B6UINUDq9oTevlcX6XSlfpDllC/p4d6BNiuvgFv5QmYBNCdn
         9ESSmaHHLGFlipxJ4IrqUULabUHwEvcJKymRrpHMLuZeIuVYpkGK3WrnJLAdoja0nSsZ
         T+fYk4KgVmOaBJo8+UmMxmtIKyGd2HpHxBhZpJGMn5/lqNIEgRM2oMPfjmoJN4rAuJCy
         x/CQ==
X-Forwarded-Encrypted: i=1; AHgh+RoCKTxTdBGzCdWS1rG5L1dPYNlP5iGzg+QXjs1JumlrCF301JxrZ30ciowVXo8CStW9RCxrb6l28g==@kvack.org
X-Gm-Message-State: AOJu0Yy3eyjBRC+yn60TrKAc1wnW5pUVyeyyRT3aBGRAGbWxeiydu/mp
	sdS/hbH1tVNUMlhjVDLBWcAHOIMrtLtfsTfrebDnCrbQceEoUup5q7s6bgIgFyQemYE=
X-Gm-Gg: AR+sD11Cop4BLvhVNzEJ/Gz6cohLMejua5N+nCXSIXP0V3bwXIdpA7yz2twnuZdYNgU
	gkPe/DhpbSAC7ZoaT+/N6AnEIMMw0GXbhtjbmQ9yyuO8KLWZEknutdklqcQ6Rztr4UpWdMdeYY+
	Nib20vpWL/5k+nrdei7nWbGy7SAbDkuuCtynLfeY5ulWUIi/P5F+eb4zd92wGtbOCS5Dx3Aa5dL
	Q+f6WqnjmeWbdXzNy7kUpLFOLLTPy0MUTtmGCHt2PWkYq818Rcm3ZnUSTkj4BAhZyWqoaVUwxBb
	cDl/UPYDvN0ygGsd93gAHr4rmKIFIUH8sycOQLQThbKEfBEr3NGGewKuNZ1v4bfm3h5z89MItw4
	Zc+GgEz07FbReLdTGCDrXvZ3+6X23ktmU9ez/TIZs55trcgE1oTpDtbBHJyo5wYxLVq71MUtLlB
	v7R9vVuZQl/1BabAZm+La12hE7kBzIu+MwvYhdUg==
X-Received: by 2002:a05:6214:f07:b0:908:23fd:8147 with SMTP id 6a1803df08f44-90a7001868fmr51143086d6.23.1786550872775;
        Wed, 12 Aug 2026 09:07:52 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c3ee3a7sm24135746d6.44.2026.08.12.09.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 09:07:52 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wuBUd-00000003DHb-0qab;
	Wed, 12 Aug 2026 13:07:51 -0300
Date: Wed, 12 Aug 2026 13:07:51 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@google.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260812160751.GE662699@ziepe.ca>
References: <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
 <anwraNIKJV8zwrNT@tiehlicka>
 <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
 <20260812122759.GA662699@ziepe.ca>
 <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
 <20260812134934.GC662699@ziepe.ca>
 <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
 <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org>
 <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org>
 <CABgObfYjdQ13Gd9AH-kck85ZWch7j_E00rajawFuRdt5D=m3Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfYjdQ13Gd9AH-kck85ZWch7j_E00rajawFuRdt5D=m3Sg@mail.gmail.com>
X-Rspamd-Queue-Id: B3E914000C
X-Stat-Signature: gcrmhp61apipgwgzqo68x1d7gyrtwmyg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786550873-625182
X-HE-Meta: U2FsdGVkX18a+BCMUd87leh3cNzaKAP0sjjP8ItMuq6OIpCvTB9R9jAi1XwINjcHevONjgrIzHkdZTu8rm8jDeCV38eK1LsYmjdnBdjmvV3AGyuboEtX2e4u3ODJRpgI7NkGSh9YqD307tR2oB/4fo965L6QT22Kh9EXyzoheTaY/zvSL7w9fbzwolA/aw9NtzY59dRjFnVGTp+zUAd0bQl8Ipyoh0DNq6ka+CAPmoNDA/hwl23GOefYaJ6sggEMnZmetIKDNue6sukytWQzK6DELMb/wgSs02MKnbXsYRGkCuT50OGq25xHQv3fgH/bEUb2goDSApGBqtswWjIhhwdE2XX4JOdqxNqiwvxyBQxLCRIRGl6l3POgrUDT63LGjHbSsOHC6BWFsdnN3iBrN+OJYuGdVw2Ev5SiVA3V1LKVVpGdkgHnIlWV8bF6KQeTh/9OHoj+9vaNx1pF64QMpEdlH24ZHsktV5MRT3rq/SMLT3KjgN31AgWyvFMGZggxwj4ckeqzPh0rTHFhJgegROK8DOvyIydKyEbgm21LqyT1rZNpyXpTLfkASO4Yx/3YCAW0fvTaNwqupaIqE1GNbdEEl1nhPGUNtls10rsQff0otqHDvayRH5zLt7Z0DlrnMMb3DysHIUKDv+lAdd5kq4a7WTBbIqyj1qH1CkAiqHCUeV/UUnN2LHwkqKE0RKUAkG5xVA27cP8zGxmSJ/KG9MpbZxnMuo8aYYwlN958VNqkYJpyrNuICEYF4ESh3Tt0va+RUQ5IRwKm5gyvu81IVQrt0JgWHDflgHqAkaFKQjwjGlRxielBsKeprWFrkyy+3PbOLYdn3OVznDgCEPT96yAAmpgFtr12QHi2vL5j3STt8Poq2GqWfx5QaRK2XSgb9XTaZMvYufAYDb2aTJS2FGq6RFw8LAakcdddhu3FUpQp/5yWuOxshFhrGRuZ4z1QfuAJQSGSasaddMaib3Z
 6ChkycsW
 o2enyBXMo1yLsEx1jQzdRucRRZjWj+cLhehLemy7gE6FYFvGRSpGWOGmHmLG6yNLZUyZRU4K+/KdxEjaH2cdWpKuE10cSEFEWcJYIuCqQvBXyzKMspBMqyA7nHehcwbMai3m3SdKVwf5hP69MQEgei+g4xrxstg+WQMYxlY0/zuz4VFPzoYaHBX1GMqOwP28ugyzSmmwc16fzfCIBBhRDApM0tgwim7QGl0nXAfAoOy2ZXGQ+JfKiPDRuHPGzvCUriCliEo4Oezzzhe0PevIH40+z9Fg1mvvH38kHLMXluYNTFtrYdkI476rn7M96zCon7n9gstL+GzfQLik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 06:04:47PM +0200, Paolo Bonzini wrote:
> > + * Atomic-flavor readers run with preemption disabled, so every
> > + * read-side critical section is bounded and running (not blocked) on
> > + * some CPU, which is what makes spinning here sane: the wait is
> > + * bounded by the longest such section. No index flip and no
> > + * grace-period sequence update occur, so concurrent call_srcu(),
> > + * synchronize_srcu() and srcu_barrier() are entirely unaffected.
> 
> Making synchronize_srcu_atomic() spin in CONFIG_PREEMPT_RT is a
> slightly tall request - it's basically putting it on the same level as
> raw_spinlock. But if the MMU notifier guys really want to make OOM
> notifiers atomic, this would be basically the only way to do so.

IMHO it is fine if PREEMPT_RT does something else, just that the
normal cases should follow the current arrangment where it is atomic

> If instead it's okay to remove nonblock_start/end under
> CONFIG_PREEMPT_RT, for RT kernels I'd rather avoid

This seems well agreed at least

Jason

