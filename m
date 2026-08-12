Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F214BC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F065E6B00B2; Wed, 12 Aug 2026 04:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB76F6B00B4; Wed, 12 Aug 2026 04:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5896B00B5; Wed, 12 Aug 2026 04:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5D836B00B2
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:13:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CE1780347
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:13:14 +0000 (UTC)
X-FDA: 85091902308.25.8F6470D
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 45D3220005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:13:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GlGRu99n;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786522392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ul3j3WGcIwdB94lLOJYR7d/dt/sRRRqyC+QOYhiAFkk=;
	b=fYTEv1jiHDeKinnooq44aIj5V0UQQCrcgsJLfY2rSl05fKx25RVALejnU5mXHu4vo/Q4N2
	FSkqeNredgb3EKtCKWue4jBQR93ZfzM25W92SU+KyFao+1AMgpQE1BNDsYQlMsQqO5zfhS
	R4PeIOwNAGCC5cKtxjionMnv7iIqOQQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GlGRu99n;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786522392;
	b=0NypBUXyC06INYHK7wkWOPf1jLaSghUUuB5Dhuetx20XTUqFvY0QkgjUnLMgfjxgPplzze
	/0z5KjA1fLr2fRG0Yv4PkuqCR7hIVRORV62WVBKQWg7gCDGJkh3LZ9XoN5FQSbRO2ghCBk
	J4g1bOh6/sqF2Qb1zYzf82Y2SnvUA+4=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4954f5e8020so2863895e9.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786522391; x=1787127191; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ul3j3WGcIwdB94lLOJYR7d/dt/sRRRqyC+QOYhiAFkk=;
        b=GlGRu99nogHPgeHrAAztzOMSw/BvPmo5a2mLJuRo9rdNffvQFHeY8vz5oMrQtCy1up
         pu/ILBzwrefCbUm+hWBC7Qb/8sc7cUNsNzorDdyeALykPsZ9g+s72KBpkO6rtKUIYPUc
         9AAo5vEzt5JuE13vaUTONwQc+XnUqnNfYeQdg4qTSXufdCVZ6gZOLrQG4XKeZwWv4OHN
         3xX7PybuQqXHR0dMSgz5X9UNX9+YTeTrw8Aj+VacKMdPyavDmp6Aaor14Xp8hF0/+WGJ
         8xQDJXxip3GHzEnq3ohryV6vdPnjoCJD0c7GC5fSURS3oxV3IzpyHVwzMdKUdi4tgAw+
         23qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786522391; x=1787127191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ul3j3WGcIwdB94lLOJYR7d/dt/sRRRqyC+QOYhiAFkk=;
        b=hRgqB6QQ+W9l0F+r8sJjrbd5sb16JmFRIfP1o9CnU/3T4q1w1g3kVjKpynItZdI2Qh
         NWdz8dzc+vogLo6o/M8sNyPiyGcf+ryIMr4qhV3ivQzeTmBYzMNxsEMqdXAHUZ7LncBW
         BgBcncqolxJp4ab8qPLCfflt3VgtzrdiG/3euKob3zIkPW3MJEc+5DIerC8h54ikfoP/
         sD/A0p6XPGtFCDg7Y7UlO49GPR9TJwvDG1iHqc+RaFIKE0HIDzr31bTqdEPhltU445xL
         p1HM736oezMZRhkECgfjwKuMRqAGz5Jto/GjBON1PV8aolHOiMc2y9H/A6y5ATN7ojUf
         Ueiw==
X-Forwarded-Encrypted: i=1; AHgh+RrIjmKeWc2XJQLufw80ZIuB7Vx3RZs3ZpNtLVDDm9AjtdW8u5KTHep4nrqnc4RrbuBSCt7gILx/Xw==@kvack.org
X-Gm-Message-State: AOJu0YxTTYZeII3AfNis8edPQtbvaHduw9h1TA3mvTWzDBctOxz2epvV
	5q166XEqYOI0MRb3F2rVWWE0jOy4smOA8ecUbPfbKrHC9NFTSr9oeQj6C/yiV7lgGpg=
X-Gm-Gg: AR+sD119XWMaXDj0fNjt8LlPNvqWPf7Zy2e6djWyDt+QzVxsD+OADzJgtAbAB+aMlV/
	p/wzmM/gf5FrzmF+ioXQDxQtDaAlFlLtKtVdH6M84aryqFO6dw8jko0JZJnRwyWMN/5++amNUCz
	LS+GZv+DGs1lVgOiK4j91XUjCdVn22c/Xgr/xL8qd82RRY7wJUDbl3r6hkgNRhzMM1RRKDEoDgI
	62up3OnAfpRz0bDeayby3RlJ/i/3YYF+5+kRAaYNVYUI3wHcYtDOFYVR2TzIpfn8oc/Fo9R8vhX
	oJSojPue4NCz3+DclafnL0qxOrZh7L4Xrg/LUCI8AyCz1p4udDu2JYmqNZCskKz6+mBLQarOMv5
	ggRJMAD/7+4Ze4wraPGySLhYmEbdkkozlAJg5HozqAh+YvDkf7qq9KRZSu8yeMBQshmpLj1Zuxw
	ctHQg8LWjnTI6bj0nOjo+ChL3YZJHKGTucQYl0/nxINa553rdu2ZSSok9RbrEzvzMsXzwLvMQ=
X-Received: by 2002:a05:600c:524c:b0:499:7410:545 with SMTP id 5b1f17b1804b1-4997c145066mr36029645e9.12.1786522390781;
        Wed, 12 Aug 2026 01:13:10 -0700 (PDT)
Received: from localhost (109-81-23-83.rct.o2.cz. [109.81.23.83])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997b237ab6sm26020375e9.0.2026.08.12.01.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 01:13:10 -0700 (PDT)
Date: Wed, 12 Aug 2026 10:13:09 +0200
From: Michal Hocko <mhocko@suse.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
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
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <anwrFZEKcW8bPJTY@tiehlicka>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
 <20260811135537.GC544626@ziepe.ca>
 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
 <20260811142730.GG544626@ziepe.ca>
 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
 <20260811104229.72fdd928@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811104229.72fdd928@gandalf.local.home>
X-Rspam-User: 
X-Rspamd-Queue-Id: 45D3220005
X-Rspamd-Server: rspam07
X-Stat-Signature: r4f4ft4ftiomu7sq17gumts3ak7riwfd
X-HE-Tag: 1786522392-697227
X-HE-Meta: U2FsdGVkX18//+FZCUJIRLN2YL4YEx/M7z8YQSO/6/pmvW94juijy8WZ2uTs8jBhH41yQz5sAGT3VDdMtBumMFYx4Rw+bmmW53tSZ2lExiHULwpnkFa6W6NliL1WkvA5WXBdJRrEq788gr6HfmP6vSsMed+VNrWnHH5uJ11d2p6IkWE2Vp+YdIu5LAcnu40B1YixcpPM43+eQ8Tosv7QHf3+OZTYUiZK7uhd48GrzW0IRgXw3qSF8T4UVgqCVPaSkAf9yK3Tq6NGMt2gBUkvFVb1MeaUwuvDGR1DIECuRTyxd+ilVcqnviE2n9K5SOXvZOFBAT/s9JSgteddQDoWj0n7kBnRScWPes6ZrKa5i2+pFOCRiNCSKRMarHkPr+zb04Kb4DIC9MgCgLpQyDYE1I1xzdUE++tGZIVWZZOR7LQPpFNm7nYuUuPSxNT7psSWdcD2mmHpvyrsm7e72X0jZIEYnYphpkDFa/J9YNQPiaXtes9MzSUnq2BimYRfknHavsk9fyZ2V/HG/ZnMenV1g4ewlp/kqLPfdvlhLHTYhpw+40TZ521BIdWBsgeqggzbRrXDfniLVGTFFMrUtX/+8iuRTJ0H3wtHAwpQWobju81lveR1WhwvCwKJcMI3sPEg6sDcYop5gVXfwCUCmwd9AYsDeQZzrRlNhME3Mx2GXuyMWB/SPleXhg6tvUXwyCzyY/kWXwhXU0TE3M2TWn4JvepEZhM6zF63aqV0FOGxiE9SCNDMno7lyPtReLMlAxU6YQ09J/KyAhRS6vWo6LRbRyLRWfnvRnhkrU9bGvF2PZl2NfWvy5FYsfy62aapdp/Sy97K2orSwjkMjU6OKzsvKP/62lCp3ecE2tDmzPQUbBd/siGpWihW9oBLyuzNoIOnpG8+aGPZ4oPEXmDTFacCyFxJFfv48lQLueSSdpJ2qABGZVFJ4zMvAba6cRS3URWCwsdyo/v9LDYsMUunZDu
 eCWefUfk
 WnDY9YoDjwGwL0Tz5XwqADUbknyaft4oY9DjuH4Hxa9HJhk6J9jJ1pS8gTnFEwAG3XgqRJDbjcF4+d7oyeIMNhOTHlkYfT1x95ZiHytubgZDhgOaEtL/kMmUQcsAyvTr+UYdY2Dy6aqUOPP7t3t+mJEfLBtU/Za7vKZePCWqLK6x0i4lwNYgvzo8y+BnRosoleY7p0/Jat+/LQb+uKnH3afkydxeU14K6xxT5hJhm/r7KPOCifbBhl7LuJuqfMwoK/5GbL9vVDqPIsnI9/HdpCaNtP30wMw+0e73852BKKzUInkpaBzYLETIJEF1U0cEW+U4yft6h4iUI8OoOj/2LLxC0tvomeN8KRtnVMoG8vC39xAklEEUjba9CJI1ssaQmyu8TrUE6Uovr0VSK4s9TIpsIeIoJ1PmnZsF7CALO3Ov7qvpQW+xPT3DIeZc6NaqIHOkUkXM25h+/VsCIg3SxcCI0xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 10:42:29, Steven Rostedt wrote:
> On Tue, 11 Aug 2026 15:33:18 +0100
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > > If might_sleep doesn't work sanely at all in preempt_rt then just
> > > globally turn it off?  
> > 
> > Turn might_sleep off? Or PREEMPT_RT? :)
> > 
> > The RT maintainers are on this thread if you want to pick either of
> > those fights... that was not the course of action I chose to take.
> 
> I guess the question is, what exactly is the reason for sleeping to be
> prohibited? In RT, sleeping is allowed in most context because most context
> are threads (like interrupt handlers and such). Now, you still can't sleep
> in NMIs and hard interrupt handlers that were not converted to threads, but
> I'm not sure that's the case here anyway.
> 
> If the non_block_start() is just a big hammer to make sure things are fine
> in non-RT, it will likely still be fine in RT even though it may block and
> sleep. But what it blocks on are sleeping spin locks that likely would not
> cause an issue here if they didn't cause an issue in non-RT.

Yes, this makes a lot of sense to me. While it is not really great that
the oom_repaer gets blocked by a RT sleeping lock because it delays the
whole operation this shouldn't break the "do not make any direct or
indirect dependency to MM" assumption as those locks are normally
spinlocks so there is no way to depend on blockable allocations.

So the warning is mostly a false positive on RT configs and what you
propose below makes sense.

> 
> Thus, perhaps something like this:
> 
>  		if (ops->invalidate_range_start) {
>  			int _ret;
>  
> 			if (!IS_ENABLED(CONFIG_PREEMPT_RT) && !mmu_notifier_range_blockable(range))
> 				non_block_start();
>  			_ret = ops->invalidate_range_start(subscription, range);
> 			if (!IS_ENABLED(CONFIG_PREEMPT_RT) && !mmu_notifier_range_blockable(range))
> 				non_block_end();
> 
> ?

-- 
Michal Hocko
SUSE Labs

