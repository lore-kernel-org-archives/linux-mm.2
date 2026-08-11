Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC41C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05A956B009D; Tue, 11 Aug 2026 11:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031496B00B6; Tue, 11 Aug 2026 11:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E628F6B00B8; Tue, 11 Aug 2026 11:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C70606B009D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:30:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BB1F1403F1
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:30:38 +0000 (UTC)
X-FDA: 85089375756.11.FC60D5F
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 772DCC0008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:30:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=YBBNj9bi;
	spf=pass (imf28.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZ5oPQk870n4i5Wo5FTt731WhaBz04ce9fYdf/2ufqM=;
	b=Te9oTIgEiPVIsMPNulgPXQcYJp+ur1/U/zufNqT36Ir2HSAblgWSjrvo10DFA2nFnazSbh
	pPpzwdyrUUbiaIVxHUgW7tjM1mPUQUvpVP1/RD+JD9g7chWOdNkFRIq5J3yQidAqX9f/le
	oKubAeInbgdzQFxpycnXMDeJp+Ukox8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=YBBNj9bi;
	spf=pass (imf28.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462236;
	b=vta/d98pvVuMxkO0gIH98VfvkQJUP8IIYyV588dwgL3kQjFM9ktuBXSCRSjOd5ARvL5pv+
	PBSst1nufi2WB1YA2HJAx2krxVuy257WKG79aI4sLkvMCpKsTgILitfgTUPSQZbr+/qiHQ
	I8Fxy9nvQqKIYc0qH4Q3ad/q51tKaA4=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8f032b47e3cso22568536d6.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786462236; x=1787067036; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HZ5oPQk870n4i5Wo5FTt731WhaBz04ce9fYdf/2ufqM=;
        b=YBBNj9bitYHjtEFVqm/FkKo713gcq2SWd2XK2fLq1BGc5SRk8h+FUganEn9/SM7m9r
         41b+tdjhNMUvlaVPNQmR/2gE0ZxLPOju6SgIIEt5RQ3bqL4hUaA1tizf6S4VF1aarKfJ
         ZIl8OnMOqiJb9evXE6iHsO1gBrIsDdyO39NOj9TEqreMLoyv6kah5W85S+bF3JVOtXDZ
         aHDvY3CU0IyS83GwdM052DuhRQ4XgXHwAJsBWvrKPI57l/vnmUrs6OWM6yrxIYQ/txYn
         ISA95O2Oy7hJYqkcsBoWxXvgFeMAxQE6H7CDdyKapNkyC7JU1v3maGP9ILHASaixsLqN
         MSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786462236; x=1787067036;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HZ5oPQk870n4i5Wo5FTt731WhaBz04ce9fYdf/2ufqM=;
        b=Cw8r4gtlK8r6MetVuFeKmoiA1L4yMsJpGtIanQklKQ3AXiVucwaxhmKZZn70fzu2Wh
         6WObp2lqHurqZmXNM+TpZjspXXhYJO0c69tMITGPD1y6Lsc+UHLGGs+G8DsGn0oh4x5l
         4AGMstYlhW1KQCBMotwfIhruzDpAc+v2mN9U6mp37FmcqVTL6kt1HIYg2CytinlcMeDb
         dDsGfJ2msyXwbrh5y6551rA1xSeMVPgz6LSoVvkktpPg4DUMcbLUbA5+NOyvm4Mt5hR3
         2QMPrwMtwHk/KRc4n9M3QA5q+Jm/CHoDqhtFpdJR5YaCQ/aCI1B1wZfxrgPcpXVUGF2a
         Ld4w==
X-Forwarded-Encrypted: i=1; AHgh+Rr+4BbpnM8JJe++5NbSzJvhYlsePmN7fAJyQITNQbeuqkPVWa1jUMHYutmW255w8Ko6nmjvAme+ng==@kvack.org
X-Gm-Message-State: AOJu0Yyy6fMWayT7H1K/4Okr5cZ8o9qlJjlD4Pm1wfxT0/tHzwmlNzoG
	zQ9Ct54pAOZ34TEaDa9rB0l4CUpusjGRv/WUnHdVli/Vu5e1B1p9JQ5EPFHG/f9VVVY=
X-Gm-Gg: AR+sD133OnVGAXcljt8X/ZBVthR79foAAfAgSYN49nXhrsD+glGVs9XoBzqjvJ81C3c
	FRI8IiUvAHViSCTvYFPKBHcYEPMlzuYJs5+65F2RO2oDLdNh30eDO8JNCgPVQ2SEdNaixpeQmJ/
	ukooF6bhQNR1MjhePkG7bznxs5YIeCJOI4E3Sz/H0r8C2nlzA5XJPYrYxhI7hArD+HylgPRDCcw
	BnDakdkVl3mqU3zaPMh97UNQYW+neuss5BryT4l8LFHrZH4AIOYagHfEd+HKEQGh7P7XVuWjd4a
	DhA+IE/hgPzlkFW0HktEDoH9pcwk4wxnFoJy4e9qGStkxg/J82UVMWvm8///sEiR918rCh7cRq9
	4N5+FTZBNzeqUQLW4glmTu8rlA2kWetiMrOmb+gEuZwJaWE45H0Gg2aOzscLNCc7SMdf5tSCJXV
	hsRP1nI33/mHJnW/BFR7OPNsEYAcPBAJaNn8qtkg==
X-Received: by 2002:a05:6214:2aa3:b0:8f0:c170:4591 with SMTP id 6a1803df08f44-90a667e886cmr37546616d6.4.1786462235465;
        Tue, 11 Aug 2026 08:30:35 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c2a05f3sm1600106d6.18.2026.08.11.08.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 08:30:33 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtoQy-00000002X83-0m35;
	Tue, 11 Aug 2026 12:30:32 -0300
Date: Tue, 11 Aug 2026 12:30:32 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
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
Message-ID: <20260811153032.GJ544626@ziepe.ca>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
 <20260811135537.GC544626@ziepe.ca>
 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
 <20260811142730.GG544626@ziepe.ca>
 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
 <20260811104229.72fdd928@gandalf.local.home>
 <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 772DCC0008
X-Stat-Signature: mnj34toj9h4towi1pxhy3b38qedpokmq
X-HE-Tag: 1786462236-921234
X-HE-Meta: U2FsdGVkX19JoRlPTm0/nrONm0FXn9ncc/QZ81J90ilxFbT8V6pylfkRxWLn1KDGuwK/f6rbdNyzY73U0NS2x26q4w5/W4IszNzLHIVWmXzNDzMPHQFODQsb5MP+0n5xEUVPxmF3iS1gH7yLcSWAg4oFtQcuz4ifBWnLl5Ohlvtcja2I4KJdQft05PEpzBw+VjPzT/nX6N4mvJV7saYElm5QMi3FkI4BTIW2N3gQE9r2yQ/skEjzhF6eELscRmov1rgR2MjrgbtMCE0ZEvypNlgPqfPwEFaQGKrjvhPSQafhl27Aybey6pyObNpiqoNIQeNBSvayDRzdj7OB9OUntuzi43wBEfvanqASKunGlvDuaOMAPgoW8EZ5HwVH6+SERv31/2FVE9ETuwQJ8u45dmuGXGOKt8ARM8E5WIWr4NlLmVqn8FV/o6L2UPgyWPNtM+UiOgdf9F06p/ckWRudB7gJoHa4mCbYubJocXTfCL14JsHuv7K66vagGcm5H4eMjxEdSI92OttE8hZc8eGsxlO/xbbzrOHNn1fJFD27UpopJ4uw1MtfQ0WFTB+FUp24YqxBojatORcnXMYioaNSU07pYctl4T2gJ4RQPA4KhQhEWPkzyT/H4eeO3UzJ/2ZPoOaS38qWu27deYI/FgZYDHAtdDRs7Yy5BM1/BSpLGGjcZ1+wSz4xR1Vj5dLdpdVoHqx7fRqjFLZeTTQnujKto3/dhhici2CbAQSc2idLYFQ5hTWKO0eJ+qEyt41Mdhv6tz9vWKB1n9YEupDst87QNgrwARemnVHuegcyQizr/9ygHbOCWnqFru7eB0c6yIgcmVxN/tVJsrgcqCpgoerb3Wk4Oo6DXte74QhJ80piWrcELZku7vk068PKJViTmt7owqudSodPX8IKiWtt4ipguYMRKu7i36h8a2zyOkdh7z5KMZvT52o7w6MRXc+V5H2VwgKSOXTktRGRP4bChvn
 rK63RgYq
 B+nXrSwW3QsthQisRjvAb1yAeLR8HKNDN4XT0VB808hdyxf7fhc6djDg+/PfsDny4bFZ6a3of1mZG96+WHYg36GjN8DRZb5pQL7Mh+n8Sh6AoaQjVUvx3LcTAduOSIQ61fgeDR/iRmT1tNkQGW8YTJiA+6LzVJRldaRKRG/mdiG1nKr8EjtJ8xvE0opm78DTc1Yj57ytTPiiVqaa0UKPl5NHvrjehI/rT77m1aYJcAaVrEjXQS9bymsn8Kr1gYjD4Cd5wwlT9XumMvtm9gXy9CAm8H4Ir/iUIJY8B3k3oLSiEDqTLnIede9y9BtAqw/HVa17fEjyX5WNuluuAHaCKhbwUyxGvpEqFrR/jKnQMngMeU0k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 04:24:48PM +0100, David Woodhouse wrote:

> I had a second reason for disabling the overzealous check too: to allow
> SRCU grace periods within the notifier callbacks.

Don't agree with allowing this at all.
 
> > Thus, perhaps something like this:
> > 
> >  		if (ops->invalidate_range_start) {
> >  			int _ret;
> >  
> > 			if (!IS_ENABLED(CONFIG_PREEMPT_RT) && !mmu_notifier_range_blockable(range))
> > 				non_block_start();
> >  			_ret = ops->invalidate_range_start(subscription, range);
> > 			if (!IS_ENABLED(CONFIG_PREEMPT_RT) && !mmu_notifier_range_blockable(range))
> > 				non_block_end();
> > 
> > ?

This seems fine to me

> Or put it in a per-mmu-notifier-ops flag (a bit like the one in commit
> 5ff7091f5a2c, but with almost opposite semantics), and let the drivers
> Jason cares about still keep the guard, while KVM doesn't need to. With
> or without the RT part...

Nope, common API semantics please.

Jason

