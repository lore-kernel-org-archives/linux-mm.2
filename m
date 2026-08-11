Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D6D9C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032AE6B008A; Tue, 11 Aug 2026 10:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF2D6B0093; Tue, 11 Aug 2026 10:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7836B0098; Tue, 11 Aug 2026 10:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7A5B6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:27:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96D44A0471
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:27:36 +0000 (UTC)
X-FDA: 85089216912.20.50B7F1E
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf29.hostedemail.com (Postfix) with ESMTP id A24A112000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:27:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ByNY+dwP;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786458454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGh0jdU9hH3pMDac+rBHolUofOnAZc4NvBka4kqdBBE=;
	b=QoxtQ6YVrOwSZrMCYVPyPSuwRvJF50BOOL8bzDkTte8rUhheamd5UKuc+seBlcPqBD8tcY
	CFdC+RGaa+04h0FTvDUKjGHwTLYYOTUNDXjLANV62sQeHXFfCEUPZiCjN/rTO0z/vwEFHs
	gK/Zi8EUOPc48n2axxwE9TKhmowdmNQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ByNY+dwP;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786458454;
	b=MQfcNQPltp7OLYl3trNENx+eD/Eyi8rjx3VhTlFFQcoQ7j2wVX9xAZNhTzNOwnLKW6Rh2/
	yLdjV/L40LAhzGq0noVEd3ic1VCeUDhymraq87JL0ol+v3Nc+1yNQjLLStllN167gPRT9e
	k3vI8cUEBEAGfGB3hx6U0NBo1SDzKaA=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92f0b5ed131so233989385a.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786458454; x=1787063254; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yGh0jdU9hH3pMDac+rBHolUofOnAZc4NvBka4kqdBBE=;
        b=ByNY+dwP4di7iCJRc8+Gn9DtDsLiaUejHxkY0iXSQ9MMNtlDZ0gXoc+m8+7kGm0ETM
         bK6iJ++I+h4wxLNTmenKpkUDNTBL1M2+AIYm+MSzylEf/OOEqxBOEVb0szACvsDlB8lN
         5EiFIDIU9VmHd4oMpmtJjT0F1ml0Vg5+c7E2ujGvSxDud69sMkCjz2WDjOPw8N6EXP4O
         A1Q0/BFDlRInVj/ocf6TVEAc7jJHZClx1p7W2DG/l4C0yYyrVH7YBd6h6kwxHApp4Flv
         DgTuvmGykzV3CPklMDr8vJjiG8AAscLopEviEtDjtstqLLIhHr1oONab3Wp2p6PvcpFb
         muVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786458454; x=1787063254;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yGh0jdU9hH3pMDac+rBHolUofOnAZc4NvBka4kqdBBE=;
        b=RCvR4tLX25DYw68U4VSQwags96G+o1tXTcMP+BCIyPf/wh7XnD85srd07QeS//eISM
         AFf1pW9WCz7O7Rn/+5ZraGVaJh3LQlF6ZrSZBHwUS3m2mNyuoMK/QN8m4CO3FcSHRUYx
         EynoJEdSVWBMY4bS404F64agtlR1wFwY/TxT0x+laAotL3thyT9kucmMTamyzGU+L2oJ
         0Z5ot9xLptWIRhIBK20b+BxBZZUzdELQxGE2+FM8cpRuu+vzvbyv7hNPTE1AoExZpdrC
         iSVZ/Hplcoun6ObRPm0ZMnJhWEiu8f5T2Vqpm3MZKwPjfxxRp1FnsW1aS0p2CvMskZs0
         QR2g==
X-Forwarded-Encrypted: i=1; AHgh+Ro87jrI/EfLnT7u4hlvAXQuEk7Uj8ICSNGPQ4yETBoBXqgDzbVOtMUncZKcjZala9mjpXhT0NSfiA==@kvack.org
X-Gm-Message-State: AOJu0YwjPj/NpjqJ1ZxbUlBGwHl8tlLhhvOUamWuFDTlmzwOEIRgCgx/
	/S2WQXxRbuox4yGjJsLEVGWigJ4iQ5TwMYUQ2UzRYjSJra4l1hPwH0CNiqnYPFScQb4=
X-Gm-Gg: AR+sD12xdEcvAWj0Iy90tGhK4rq8GF1ajiAR5l6FehFZdu0MAASNZ3vdFZH17W+C21X
	HBVygTDQQfnWoTccUsUVv3lsDGXijiIyhb7m8M+3rYKee9EB7W4XXnEh5iZt6GYIrzhf9tM0W7t
	N9qazTAQSnH8M8863PNoUCdS7q7vBa3tIsFepd9p9K64LHusvcaqu1QHVmkt6gRbpOpISxZuKST
	yNbAht4UKYIYV7Ho5PHVXhA7g4IEroK/qTp9kz4J+sdRlKr9i6DDhFFWqCHjzYtgsORYdgvU58E
	IYqsJwqw/e7P7R9CJ62Lv5h9FbBr7ZhFG27ajPPjDtIZhySedvuNwdb6WLWq6wFOW0JKjoVRvkA
	7Xc/IGaKzeSKfedK6aPiV1dHPg5IFxUnWupLtZgbeHpz9ZrcHXdJ8UQRtO1OutMftnYav0gwUQQ
	JeSgpofdn44pH5DTKfNkWsq9HJ357dO1OakMpOoA==
X-Received: by 2002:a05:620a:4549:b0:914:bd27:2d1 with SMTP id af79cd13be357-936a8edb650mr322022485a.11.1786458453669;
        Tue, 11 Aug 2026 07:27:33 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936a849ed87sm122584685a.15.2026.08.11.07.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 07:27:31 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtnRy-00000002VR0-3Mpe;
	Tue, 11 Aug 2026 11:27:30 -0300
Date: Tue, 11 Aug 2026 11:27:30 -0300
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
	Sean Christopherson <seanjc@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260811142730.GG544626@ziepe.ca>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
 <20260811135537.GC544626@ziepe.ca>
 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A24A112000E
X-Stat-Signature: ku6ik7e77eegn5d4prrm4xxyzejm9b6a
X-Rspam-User: 
X-HE-Tag: 1786458454-937438
X-HE-Meta: U2FsdGVkX1+comzr3jTm4P/Rpg3tEUxpct5xXQ4dK/ePObiBikXQttQnqJSP7ijhXob2ARYlTcPMXkbiG0v9xr6yWdfSrPDX2UG7Rw2/kqA7mmohYot3I+RCSFsDifa6thfDJV0lL/52YxtNYA5E9ZhBtXDtOaXXHIY1s8125CcXVE5hsBSDHIMVGZQOSph6rlfzAvAMQqNlKj6RNcn0fVg3JkA6Ni2gwq+tKM55XQEr7q/7fQML0m6DJKnPRl4OBAXu6Q2NjRonB9RNasw0IFICHzafS1FTmRS4rU9qqeafz1zY9s/DxBG/GTyGS2+YFMjYvqZMCraFnEmDJC14Y1U4CYqMKh2lY0Xzx/3CL6jkojfjNk40RLYSJ1wVa6kA0Up0K9mx04ItQO+uCHyTS0WWxo5IDsVZrh3ceFTMQolGIGNmI0LWvViTMmycqOpy5KmlznnIp12j1KKsVG/zY6pO2+qrXJLtkKBVkgPBq5bqhqFnBj01t022E1H3a1ssntDpW4kd9SMTn/pREejOqi/IP1xkSB2GePBF3RHplQ+znahCBD7l6XCbh3ukLIPBFKDS4J3le7MxuvSbOegC3lYPeqqn1IQkzuaSynRwFg9sXh92Y2QXzr4Fy20lvwvAzm3P2Zp8LfBqO042Qo0uOBwHbdt5NdUvL/w3M98GjVE/kv9A1/rrRfbV5KfT90EMDydHqPyHKWf9ehRUC7clIUOBQWR8c8mk25henqLYTUnm0qHxQ88JL+VuP/zf3DsG95V6KPQ+4iYE3FbHS1eWiejMN2aaljl2pSRHA22BXBORVGTyAKPvPfEsLBczlZ8wJHuPeI9hUUl0FOjjaiMUG6wqNdbV8KdFYJ3/0DqVWeMPDf6p8uzpvf8S9G1QYKh1CLY/VDrOWBkVf2aoI2VU61F1rjegoTww5dwjfaKtipQHUAlmuqRgcS7lWcMDJt/flbkt2g0VDW8l8c/IBGg
 QgPRuB8a
 1elhv/w7hGg3BQLMGkJ1PxINBpiy+UazqpnDb3IW1hUVYAAGRH/KltM+kZQ7OXXLZnjP9ul2u8TJgeXxd3Euhw1sRah2p9fHVWSkU91j9SByYZEZ3U969kOrBbrKmXM6nusqo2lebEqdS9Cl9NoYYPQD2HW3MrCYClmYLktBgxhyWb4cnKu3I9bTkszZTZsWEsA7Pm8D0E6Cbs/AQHp97BkXSlNAuB7VrAFKbPbBrC7Za0Zqhrmbu07ClqaoZYPx02wt6llbSKX8owfK4ViJPL4UQO4/S7MM8Z+pdaSXI7deCwR/HaMpugytz7EoWGcjjZVnu8S4awBznbnxwMujz0C09GaJFRREYwHVpN7Q/AeFFW4033zDiE4/MD1nklypiphF4NwIIUFcJYx2OjX+01cJ0J9YPEXtUY4k65Ypg/8Qy6m/JVPY08KX5k18j0a29FRiuBM9KhE4Vs6SuFYCn4GYO6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 03:21:35PM +0100, David Woodhouse wrote:
> > >  - On PREEMPT_RT, spinning locks become sleeping locks, and perfectly
> > >    legitimate spinlock/rwlock usage in notifier implementations (e.g.
> > >    KVM's mn_invalidate_lock and gfn_to_pfn_cache locks) triggers the
> > >    splat despite having no allocator dependency whatsoever. This is
> > >    reproducible today on a PREEMPT_RT kernel: KVM takes
> > >    kvm->mn_invalidate_lock in kvm_mmu_notifier_invalidate_range_start(),
> > >    and if the OOM reaper reaps a KVM process the result is a "BUG:
> > >    sleeping function called from invalid context" from
> > >    rt_spin_lock().
> > 
> > I don't know anything about PREEEMPT_RT, but this seems like an issue
> > with RT if a traditionally atomic safe functions are now triggering
> > might sleep failures?
> 
> I can sympathise with that point of view. In fact I've spent the last
> couple of years mostly ignoring this "problem" and just blaming RT for
> doing exactly that, but I don't think we can really get away with it
> any more.
> 
> cf. https://lore.kernel.org/all/787aa26cf62dfd361eea8ed19f384fc517892501.camel@infradead.org/

If might_sleep doesn't work sanely at all in preempt_rt then just
globally turn it off?

> > >  - A notifier implementation may legitimately need to wait for an RCU
> > >    grace period before allowing the caller to proceed with unmapping
> > 
> > That's not allowed. We really want to forbid that, it is not an
> > acceptable way to implement a driver using these APIs due to
> > performance.
> 
> Speak for yourself. For the KVM gfn-to-pfn-cache the performance scales
> *much* better with RCU than with explicit locking:
> https://lore.kernel.org/all/8f41cb82b7c99d5a3d1dda016e4841326b4d8a52.camel@infradead.org/

At the cost of completely destroying the mm shootdown performance with
1s RCU grace period waits every mm operation. No thanks.

The unstated secondary purprose of the atomic context is to force the
driver implementors to make sane choices that don't degrade the MM
spectacularly.

> Perhaps we could find a way to push down an *accurate* sanity check
> into the code paths where what you say is *true*? I guess it could be
> done with a flag on each notifier? Or *into* the notifier callback
> function(s)?

I think it is right and correct the way it is.

Jason

