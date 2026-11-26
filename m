Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 771FF606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 01:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=V2e1gAzC
Received: by kanga.kvack.org (Postfix)
	id 442C56B0B40; Wed, 25 Nov 2026 20:04:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC766B0B41; Wed, 25 Nov 2026 20:04:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2944D6B0B42; Wed, 25 Nov 2026 20:04:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9E906B0B40
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 20:04:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60159A7938
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:04:32 +0000 (UTC)
X-FDA: 85475474784.10.22C0DAF
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8764C4000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:04:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=V2e1gAzC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795655070;
	b=awFGOEnx/iJpOC/hZ68oq3yvtcLh4hAp54PX2dnLQop+DGUi/LrM8cHAtKSq1t71Et/uFx
	0EQQunFdJxKwkje9tsLRec7wW7/f15FwDa5ILHGi5SgOBjiUR3rtLjEM+TcOhHDpvlaa/W
	NJtX6GpKxHoJtE7T5j4Ayv694jHQTgw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795655070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIktabnjHCDieeGWMO0z9Hmbrz6ngvKHiYWHyOgAZAA=;
	b=4MZWjJxYkkMmDfQ02+jMLyx6pAJ0eEc+/F7HFAYakd1KxSdgfEUQZ0Q685ai2GGpIoyIXG
	j2lj1E/+/x+DQc7lKlMxVUCW025jXKn5AJbNs3n1F2Vv/VPslbBaiH6TIBMAW6U5HhLuVW
	a7z3StiMYpZ67Vp3ahoZoZq0PLYz2tA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=V2e1gAzC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso2542425a12.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795655069; x=1796259869; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KIktabnjHCDieeGWMO0z9Hmbrz6ngvKHiYWHyOgAZAA=;
        b=V2e1gAzC0jJ8jZKhb9YTzNpCYAj+KaKZAsj5UM40rlQc1L5dSenW5yAna0MSZkWkT9
         Vll51hQ7ilXXYcuxX1HQe4bREfKuL4x8w/q5XoLK2tPlSWX8fhlJTLHs0pniKuS6aqhw
         8083Bwc4biRwo8lAUR7d5MXwG4qeqwbmBDCA8nKdq30Rt7+u+rHAk/FSLMy7/GfVKh/I
         /p98lkrh/PUy8dRXxPzU8OwoR1Ske8IHgAepfZxpVzAuSrw7ocMzm5lqOjaDugEZCqvu
         +K6AHxh+qZ9I8w2c2cJbajxBRafvHHbab735Ib4fgIS6Df0OCi6VyhTcgx8AJtqLnrZF
         AbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795655069; x=1796259869;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KIktabnjHCDieeGWMO0z9Hmbrz6ngvKHiYWHyOgAZAA=;
        b=BweIOEz+wnxefriIGIFkMyrLInW0V9Vry7exXsQFmYcdBNeCjuL8ppvuBtyS1BObpN
         9wBugVBlCrt7uCIaBFqKXjYNq7MGbUJbEGHSgJbXNbHCrVV/5ajpbYdjtSsGCiE/m1nS
         51jgMTCGQfO2l6De4yoLedJA9xKBbEzvMWrvluLryL5np98BAWg+ZhahVsNhb7m69q8W
         6CsqRwTHvFMTkbYUHHyrecs/RSzMIwVHXv6ILK1AO+Om4bsoZkNUIa7IC5Nz9IGCVuZq
         AnAeNNW9HPb//cvET1b0vpukUR4xTCENsTlVnYbbgCuyc4ajIxJFA6CVixKJNEtSyRuz
         2K/A==
X-Forwarded-Encrypted: i=1; AL+hErH7rgt5ULESccF++Y65dNMm5+sinHcYy1AcuKb9i4DS/bqPy3D7BFa/NOeLF+kTHSOOudiSt2FLdA==@kvack.org
X-Gm-Message-State: APuU4Z/q1BOoO8ThiPJhFjEyq8LI9xLPjmal9XThykEJzcnXD1DmO6Jf
	VOU5u/nqH0u3fEHautS9vRuj2iEQM9VEG08HVF4hykJPXPtYbDXYGUJ3
X-Gm-Gg: AZFdTZdY/qwcyCN+N76fv8Izfm5c8fHQ0RMTIBEq+p5TsN8WZe6rYP08m4OfFJx2jCW
	62P4tin75PhxxZmYthsiJAZsc5hlJlsoHTZETRT8Ox3Z5UWjmwncUAtNjgOsmclrKzQY6mPPFtH
	ODwU4lV6GViUbHBJCwQ4FtVOTbIXNLnfadGWawsmZ109X0603EMW7OsTuP2mCT2Yp9BMJT8Konh
	tpvUSQmjBLsGusaO25c+p48wLW5Tu+X4v+3mehnX/9y4PTdx3s3sX8cOZmWq3N6yff9nQD6U1r7
	3AeGL25td8m0vb/7kTEcMw+01YPzzcH39oWLEGnrb7Tcnqz9GPkARwskMlY6OHhWwSc8FvBzV4Z
	YYlnGubzel2byXn8SWCt1Y/fDkIxoQ4jEFnCP6oDtz0e7koz34PAAsZ5Dz/SZT1hst1vcrxwp7a
	Zh2G5gqlvwcbIdAPZPTEvCti6zPx7m0T+i6wrS5+nDNqqTor7AzH44VErl5orZPHVsJG//EjEWo
	qLJj73fB2rsNp6JE45uSFnRoghlg1+4gWhrXJNP78Lns1+wHR07i3ZY4/COhz65H7pPecdkZ7pf
	Wum3qJSrM6WIHoq6O1dI6mYO0jir1O8i2QeHtPBUEmijc+89tbUn81JjFXQLMAJvNjgFSIpD1BT
	1hCrdMWAc4O2JXsLWHzqRAF2OhWBBnX1UmA==
X-Received: by 2002:a17:90b:268f:b0:3b3:a421:7e00 with SMTP id 98e67ed59e1d1-3b41c8d4831mr17552841a91.16.1795655068912;
        Wed, 25 Nov 2026 17:04:28 -0800 (PST)
Received: from localhost ([153.61.198.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad92c07sm30289984a91.13.2026.11.25.17.04.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 17:04:28 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Nov 2026 01:04:27 +0000
Message-Id: <DN4QLI2XAGO1.2DDIFJ49PNRPS@gmail.com>
Cc: "Emil Tsalapatis" <emil@etsalapatis.com>, <bpf@vger.kernel.org>,
 <andrii@kernel.org>, <eddyz87@gmail.com>, <memxor@gmail.com>,
 <daniel@iogearbox.net>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, <linux-rt-devel@lists.linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, <linux-mm@kvack.org>, "David Hildenbrand"
 <david@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Will Deacon"
 <will@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Waiman Long"
 <longman@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>, "Harry Yoo" <harry@kernel.org>
In-Reply-To: <20261125140902.GE2668804@noisy.programming.kicks-ass.net>
References: <20261124060357.11700-1-emil@etsalapatis.com> <20261124060357.11700-2-emil@etsalapatis.com> <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com> <awWRZ9xCzWLnj_R6@thinkstation> <20261125140902.GE2668804@noisy.programming.kicks-ass.net>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8764C4000A
X-Stat-Signature: acinid4ndg7cku7otrzteygaf7ktcfmu
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795655070-592134
X-HE-Meta: U2FsdGVkX1/Bv5yCz59DS+EeNMkEdrVaGsXW9mtcrV5plOJKW6tJ2rROVtmk5FSOUBcaulCDj9p0R0cmMt/eo6iMRMO1dpqlFv2kjrnMSPKLYfJJgvud/Hm0q3eaygKJQcUFM6/zJaKkE+zGP6h6tvSSfzhEX9L5XTRxSVI8AicH5BJq/UX3YulBJbh079HDubU1lV6QVskh7w/8ug/gcMQ9iL8X6qJ3FB3IPLom8jTOOdUSGYrkUUMZeiJEv8RyVVdpAqyQEJlfC7yIhc1vXDTk+e6brLqzfYAXRl4EqU/Ieoe17vOkk2vWTCkdi2Xs+7R1XkxUG04eP1CXn+clflZUIs7TimoOgA8N/ZGeu/+aMsT/FnWJ7BKZ5Q5r9Ob4DG2ezaZcHQ7nAqUbcKtiCXZiO+X8anCisYtAwWBPhverruQmMSzVSt4vl3I0S1jfUfuXfKMqS8/OvqVqynOKWYhpbAwaBhjfBUxSYdzU5HVq7dA/sqt+kMBmiWvoSfzZMLb54jNl2J//pfrfofs+/jKH5GLp17z5i//ivGHJY5kCK4FrT3LLrWSeuaZzyaKi3OquaKQK4dwyrQSW6rNBQyXuvAPZznGSoeYz9BaWGbFWDa+3yzVuZcdT6iDnzLB1NiC63IMwh66lmIFdBJtEqhmXFZUnjNpIoyD+2mG8mma4sd+M/48bkxy0CTV+AEPiOIUAgT5gXXfCo6rCon+oIK//y5t32Xc9bppCpoh3n5YkpGoIrN6giDFN+W+/ssV76AprG5my7w4gqLt2OZvzQE3Z1ckPSNp7Sl9d1VMNzGZ48mrNVR5j4bs6Qi4PTeEG3KLFPOR/WPcwVEo6QHjyc/c8pgNj2HXk0Ul38LoT5sykrYosyUAi5qFj8aCCy4E6JT4xVT2dUgOqSdJZGyUYg6iyViSvTbfhwSNaEdRcEfmHNHdVzdq5ODKvbyCTVgAuUC/scTivgJzLFudBIt/
 A4UNpteq
 RGQQvHtZZ2Mc1a8vzAzJw2LROJdRSXRPN0kPJa3Ugbbxm2BNCPZG2ABGClj/qWatL9NiG8FlHEYtwFCifJJoWY03JGsvIRcxKpNTUFTwCPnMUkbtmGD6m9jzUzGeD3f96aav7I+Xfre4TS+pljVdEQvmpBbarBKb3gHkeQ8i89WYqwivn2HtHoFWeKBwmxYtRXcASIXpJDYmK1cpTfvysX1HtJG/JCu3Ch8bwCLuU20k0J5rfaIT1AsyOpr56doYjKjqhqH4L/ZUknrQdoKRy1ckHgSsCddsbeQ4HyD0kAazlpn8kUv+RlwIK0m/vlVFVpMSXrZ/jHXErmrf2G9r95OOtCY4FlFWYKnU38S+LDRvaYvq9bvdlMRisrHYv3jcETMPlu5YyS3jfsk2EBVQV/cwNOc7s+6hF0+hgulD78gTDx8TryBgeX9wLU6xhE0tKr2YmfAoRrR9LK0sPWLAAwbuE+C1Eu0kSOC9r34GKcncwtnpIl18ixFRZzhxPAa4IYwiR3gMgeRnPZIJfl4Co4LSHPBpor2D8Bny1AiGZ7VleT937WHAx+A3OyC2fVKL7+7x+Mz79WR7TXfTdimkAwqLT1Gb79cADuqi9xBIPYoKDiJpl8eqqb4YwiF2E2PzqPt7Dsndtq3tInKHja4I8HjlxJP0jyAIf9Py1ejn/FqAl9Qqt6oIZtU1rJMnXjvSEitAk8+n9dOtxwPzf2HEJrnagdGUrxZiX+cBBQTdi1hxOAIwHDA4EiEUt65u7OiMz4b+RudJZm0xgfGOXd3B8Mnp7JA6OyKDON6/mwVOQMIunUVC3uwlafdMZovNr9L7ds9sukbeHDl8Kt7m1KdTtyjqdtCFRo9G6OXAUdtWxQKLEUGf8gj4lzmn76O5okM0waNbQd8u/+vMIJq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 06:09 AM Peter Zijlstra <peterz@infradead.org> wrote:
> This is absolute atrocious shite. You cannot attempt a spin_trylock from
> NMI context. That thing might be a mutex.

cannot spin_trylock from NMI _on PREEMPT_RT_ ... correct.
And the patch guard against that.

On RT the nolock path doesn't reach zone->lock in NMI or hardirq:

  __alloc_frozen_pages_noprof()     alloc_flags has ALLOC_NOLOCK
    alloc_nolock_allowed()
      can_spin_trylock()
        if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
                return false;

fwiw kmalloc_nolock() has the same check.

> This should not work; if it does, that is an accident we need to fix.

It's not an accident.
In NMI only !RT SMP kernels reach the trylock.


