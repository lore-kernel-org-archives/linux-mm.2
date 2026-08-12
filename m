Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46AE0C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5260D6B028E; Wed, 12 Aug 2026 09:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D66A6B029A; Wed, 12 Aug 2026 09:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5186B029B; Wed, 12 Aug 2026 09:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16BC16B028E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:49:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7AC48038B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:49:38 +0000 (UTC)
X-FDA: 85092750036.01.1F2786D
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id C464E40010
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:49:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="X50/Qy4r";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786542576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kc4Afb6aXWQXjmXmnDB66MIWvaDryZWAnPWngJIIDAE=;
	b=xlMFLimP494Cf2n6UieHyMK3g2mqfkI2LAzIv0pJeDyK8WOuO0kXwQ0b5i9Z2ZnRP+D5I8
	17dlUYBBJJ8STFxjJlo31FjwMCwLhcMqSe8uDv3rptW+574+m9uaS7QUu9FyVgZkKixAeY
	3FhQSko9pCK8drPzBpEo5PJi8b3C7MY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="X50/Qy4r";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786542576;
	b=ttsKvVrF+akVNYUXfNY7xKg3LbH0hzy+IuOQiromqwJAyePlC0+mK2DxLq3leLE+Gq2Ct4
	l6L7rB2BeV10HxHCfEXPU/Iyl5YNRKArIXPBQGhucQd8YU0thlyry9hS+vcOOSC5fCOY7+
	BTxigumuBi2CkUNTS3K1id5O6WUGRU0=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-529a1ee0e62so4548061cf.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786542576; x=1787147376; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kc4Afb6aXWQXjmXmnDB66MIWvaDryZWAnPWngJIIDAE=;
        b=X50/Qy4r9zl2JYHHIhDxLaD1Hb+lOannzJ6HiRBiB23l3h9JO9LnhNCRce16GUOS9t
         uuEDxh6FWHn9MDGCP5hLTEU85dxq553oVEll4ZMfnlJf/1/th4Q9+CLXsNONUwAM0gUp
         hXSZuMstwWJI1yeu+T5hysq+BscjU4lrn998l2LsRWxNQyTCN6kLzQr1n5Xsr1ePf7I6
         OrVsobjfbfiKpJ2YS6V+rjkqRcLX5kpCrf1rG/DO+EvzUCs6E9p7ja+q+B0N01YSsS31
         XeMLwBDCS3ZRnT4FJtXmDXCM8acCDhpAyqUW61ATbY/2/+LfRX31CfsyDUWbvX5wlgG+
         Eilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786542576; x=1787147376;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kc4Afb6aXWQXjmXmnDB66MIWvaDryZWAnPWngJIIDAE=;
        b=pMSAbiEW6wbjUowzP59QozxIScGKN/CTDZEYDrvhbFA3K7pImRI3SU32u+TiuPWaHX
         pUJqwX1N7fFoZ/o1t8S6nD5zBSxrw7d1QpGbHfDV0UwFTUTpMzWqbYTqCom+4lUvciuk
         xwQ5J+2DUSkz+cwVdvUx0wbhMCuEr6szUu6JxC9iv7FMRGmyYN9K40nF8hVBhSIxgwDt
         dGVI1nizz15qAx/SqAK6dhqb0y4G8ImG1g4zurCzhexCFr9qMTfyblqsUSx+KJ0pAvta
         aYqOUdOkjsNnYi73tDESqroDMJWni91DCE2+OAFmF3iFfNGZ/YMLD9k+iQHLYTPcX9IZ
         21YA==
X-Forwarded-Encrypted: i=1; AHgh+RreD9fNUNwrgY8T+r+ySQB8Ok0+S6rMGHgq+ErYGKMI2Hs2u+lY64OrotblN8qyk0pexqhBu8GAyg==@kvack.org
X-Gm-Message-State: AOJu0YyOEvYIGh1KfmcPj17SFumzpftD8raUeIAzef+d+04b4SXNVDfZ
	OoFLfcc+5dckfvqckhGHtJwlb31YkI5743OoYqM/bdqpwWio1HejfoAU5d/rw+ITyMg=
X-Gm-Gg: AR+sD13WL2aS/ZJvAdufEgrIaGi6/Jos1zNSJJs/pPj3xReQylbmNleja0+i1sUvbDv
	B7qNMw6m3IsaVZMm+SnC9a+OFiMf/tef0O384SzfWRqwegUKCVv/2zG3A0TJPxVlts108/vgA80
	dRQPCOTrD/bRVNeioSa8PhZd2oDMrONDrePAPuE0AV/UkzXwj5Csaj4g05NmmZRVaJdXzfyIFWO
	maXzn34W5CEf5rGbpellcVasAVJYxxYJSMSeeRZ6uKtP/4kUXfO7mkCXvqO8YWskm/v+tVJeHiN
	90rZbtvNEW+KIxsAvJ/CuuSe1anPqCVZVmeWsAmi412OVYcxXcc8/27S63T8C4MiUNo4O/zRioH
	Ek686+8DO+Lr9hzpnmw3230xYJCvidAYoPp+1UN/DdtJbcQ7BXH7RLLZBTTIAkeITGvPFlsllwH
	/Z9pyZoaZkbXBT6Z5sMGN4dyZVFkDaAyER9KpE5g==
X-Received: by 2002:ac8:7f47:0:b0:516:dbf6:f8e7 with SMTP id d75a77b69052e-52d646fa46bmr42007131cf.17.1786542575667;
        Wed, 12 Aug 2026 06:49:35 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d61c0821esm18333021cf.4.2026.08.12.06.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 06:49:34 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wu9Ko-000000033xl-0724;
	Wed, 12 Aug 2026 10:49:34 -0300
Date: Wed, 12 Aug 2026 10:49:34 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
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
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260812134934.GC662699@ziepe.ca>
References: <20260811135537.GC544626@ziepe.ca>
 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
 <20260811142730.GG544626@ziepe.ca>
 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
 <20260811104229.72fdd928@gandalf.local.home>
 <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
 <anwraNIKJV8zwrNT@tiehlicka>
 <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
 <20260812122759.GA662699@ziepe.ca>
 <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
X-Rspamd-Queue-Id: C464E40010
X-Stat-Signature: osuwpmep1d5yymaitxyy9hmh5ri7txj7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786542576-362322
X-HE-Meta: U2FsdGVkX1/dwx++RoFpBq26f9Vm52192ifB4oAiuxnS3YbJPrhYfMSKJdxW3dvuOrhxo2f11/fBTWEzeyCC62dBwEAgUfldLIzcsIPelebblqorG58LYJIMve7YLssdmlRjJHo8hpBhSVGSyrm7GXKTff5SAP5zj7h8amL60Wa6zL3vrM9OlzSroRLP5PKYj13Vrx6EIxRsUkR2dNqdKTTJwGOdWdPkcI3hfXHICql34GfacgJJI1meD2wpxVlyAkK1w920a/u9i/5hrxMrfUm+KPwshAa4E7+4UMyOFB7EovRgHIZEzyRCgHLSDJ9oWtznYQMxTKCQrK5IUrKsuUs1WVkJzSAYCyJhql1oFtDOAU3kpeIQfAn/UCOUDoPSifxrtkoQ8B9j6UOq1bwdctiaOvPBkkHuUyeyX00TrOPWLrZyJRi+BbFiDYh6l7DA+i2y49S5s5tEWgDECR3Mkdf+VUNAPFCtmEnXMP72W3skUbKdbiHZ82lnzC46ZcXPL9Ub7L6Swuvs903Hk00un7MV73AYQz1sf4pj7a2zxm+jp4T6JTYjo9ifH5TwrRswIFjxp6ndtH15mkXQHT1J+ebybJXDzvx4V8s7MwpjwyCQfD+Ac0xZZvFrpYIGinn/GOEElc86Xex9QjppfO/idIuRFbGUKMiSy/eiu328smd2rks6epuTJl/stCa/k5y+uIrkZ31pFuJxTMGl9sTJx7skvYyydW9jVlhXL/L2jPS7X/1McY8aFzanXH6ji5aVoacsESz49lmVv28QEWUgH5X5oJ0EO5xE0DKD7dZJ9aIJ/6lC9Wri9eHNFUEvKfEF5PdqS7EI1hdjiRG+VoHhx5Q3rrhLH5ZRBh4b6aMWEysr3I9mrrSMNOdMJ8cXvMsyI9KTPPimG4KxSgRz7qfFHMBSD+pvLqGkjLp2ZQf8hocZ4WUEXHQe75Odn1Fg53gnq7GJ5ka736WZyRAg6aj
 czOg+BgR
 MQi0oISSDP4YLNECcZvEyLua1xHxxtczRmyIDixFcES1dZ92V37wNjlhsaYB2/NHgo/o9nDMiv5fwe+sioocMyoJ19OF+ijztax4OYdg9OxWZxMtGBjuqEOWzsRZDOZ9s8z8H0n2Z/EcGezx6s05CJ4lQbavoQxbVD2bw+DVVNARGKQneZJCUev61irWxyDAdmQpios54eIlyRd4E0M0QhHcI4m+VrKCoxdmUd6VxnMt9EWFt5U6IsiU1+iovtF+yVMqSGWiQ4J7ESRXUhtVVqgUVFZmV94b4rgDxrJDYM4UQou85ZagpKaTnkgeKggA8e7edMlxdG2Dh9Ro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 02:46:08PM +0100, David Woodhouse wrote:
> I hear you. I'm less sceptical, given the use case, but I'll certainly
> concede that the universe is known for inventing better idiots.
> 
> I'm certainly not averse to having a wrapper so that the read sections
> don't just srcu_read_lock() directly, but also get a sanity check
> (non_block_start? local_irq_save? what would it actually be? does it
> have to be different for the hardirq vs. process-context invocations?)
> for free.
> 
> Or instead of a GPC-specific wrapper, do we make it a first-class SRCU
> citizen, SRCU_READ_FLAVOR_ATOMIC? If it disables preemption, we'd know
> that lock+unlock must happen on the *same* CPU, which could potentially
> simplify my new try_synchronize_srcu() and/or allow for a *spinning*
> grace period if we really do want that (although I'm unconvinced; it's
> *latency* we care about here, and punting to the WQ when we *already*
> have to wait is fair enough).

These all seem like good ideas, then you don't need to touch the
notifiers..

Jason

