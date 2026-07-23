Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E35FAC531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66EC56B0088; Thu, 23 Jul 2026 10:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646E66B008A; Thu, 23 Jul 2026 10:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 535B96B008C; Thu, 23 Jul 2026 10:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 289AA6B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:08:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B27B4A11BE
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:08:23 +0000 (UTC)
X-FDA: 85020221286.18.ECABE07
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B4C84000F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:08:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ctAsY4l3;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784815701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Llb6QhT2IRvGCMWqpRY6F93Ek3l1oCqWy7Lwtb+z6mY=;
	b=v/eKDsiIi8D5aK95y3veKKA3aYTfkx7/YD0CO1MtPDfMdYEP41ztw1D7T+2m+n5J4sjQHs
	oWjKI1KsbqHeR3n8RhgnWsXwAhqlBSEqFy5aKoYwz3tziI09egXeG0sBMlvrSSFM2cdo2/
	jc5AUPG0XVNe7CBSv1VTM3CZjeHMTpg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ctAsY4l3;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784815701;
	b=3cSfokYBH/wIgMN8YISr/2lNIp28ahRwLdWl4adbNz2/N1DLmgSj0wwprHOx+loIdvTLPW
	IZcHkp9l9YqYMLKnUinfQvV3N/AFqUCIOPLJfCGt68m7laVNGany2atweZtX9ilvR6FMxC
	tGl2x4TLG9RMNEFchLUm3tO7CuBwuxY=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8f29ec73064so6107296d6.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784815701; x=1785420501; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Llb6QhT2IRvGCMWqpRY6F93Ek3l1oCqWy7Lwtb+z6mY=;
        b=ctAsY4l32jEiKvoHeQL3CwNYqKWliWLn23W1OFi+cNWggzYkoJcx7R5HHhvQH9fRvX
         Dv+7/46Bao0qn04OQ1FG9Z2W5dODUCtel/BvyOydszWmRuT85qGUqzdsA7ztxQVlP2N+
         9qgAsjNpgOwULEhBm8YMpIFMv0X932std/w1/Fk+1iOVXCJtSBDV+0HT/TfxH5pgtih4
         lrD8RSTyNRm/mtqGgW/9aXU7hcUSj+mMa5tcIF4Z4p99c+8qHZEpGtCi9rg+Ltw88eWL
         zMGb+iAnNUsd2JJY3OHGCz7H4fHtztiyIy73dwcgsvXjlWvO/MLv8jmLV8ldAi7azGkj
         GvWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784815701; x=1785420501;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Llb6QhT2IRvGCMWqpRY6F93Ek3l1oCqWy7Lwtb+z6mY=;
        b=lL6c3jApL17Fh4IJ9af1+Y+yWXXrtLJSqo1dbmLM/B0WAI9pQvhfmjNZZVojzbeg6G
         6nEWuordh9qLakOG7dLn2DpIerHM4LXD2ii9km8H26EmF9sX80x3zCRQ7cH6N6gFXVS2
         qZCta0ACg06G+wteBn8SSWwZvWq+JSkwbDg+hlVUTykqMVKUFHPlUlsaAWjbLss/+uI4
         detBwAogu7atsvy/kLzuL4sn+fwaNvjGeCTMhgu5c3AyWK8Nfcjngv3X/17yWYUVujT/
         /A+02JWS29K8Bhmy4i2ob4/0GJRhlr6SxXy/574bj7Ky2LZWv6T8GOMee2Qr9zbkBjqK
         2qBQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr3jVAvQBtou1TAzqMsyy7YSv1evfAK86b0zIJhAdv4NcJ1OMMpRZ7TeS1XGHMx3LQ5ZpILFJPffQ==@kvack.org
X-Gm-Message-State: AOJu0YyOiTP7jftmMjSV9Xl0DoSJswu9cg6RsCeBC883/CsTCxoYK1J0
	a7YRHFISoPFAO/5IgFUswL0mv2mMLHxsAtptpSIiXdt+nbimmPN5bnUpkV9Axkbg/6w=
X-Gm-Gg: AR+sD10AgecrY6rS9rIZpCLmH7AaB7y5jbBsEEZ83y8i/tBZ8nJkCPfjBBIOsSuxnIK
	hWSgg0bTpt2K1w284d7d+WMHL+LZhcMrrnXckhlT7bYdnWFISsapuigHwIilpzpd3P2Kb8Vd3Z3
	uRGr+0wT87N2ghZ+Eu6CtCGKJN7LLtFWHYbI8Z8LBeTYlzMSow51RuwzKnUKvB4Bc8R5jgPIyhg
	2Htx7Gl00BFX56JMFMixvPrb4gNNJQiKMZlHLBWXA0B7l6EZeXcUnv7MP1K6WXXkYzM/5jp5tgY
	eg8Twx6AH/81cZZwGyC2ptHIYS+89wH2r15rkzS5JLZBXDwyIJsKURBpb9p3JIVBbaALPBh/KuG
	mMV1HhuRaHN/FPZt05jnPHok9J+KOwQlu6O6Qr+U/rNyuDsDCtxNxVY1NXyWTHt+c4Vefw0Diod
	jeLaJBaN9cWc8=
X-Received: by 2002:a05:6214:411e:b0:8f1:1bf9:5119 with SMTP id 6a1803df08f44-907ca5700d1mr36458076d6.8.1784815700473;
        Thu, 23 Jul 2026 07:08:20 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907baa27ce6sm45312476d6.45.2026.07.23.07.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 07:08:19 -0700 (PDT)
Date: Thu, 23 Jul 2026 10:08:15 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
Message-ID: <amIgT-l7PExKVJlW@cmpxchg.org>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
 <20260722150006.3848560-5-hannes@cmpxchg.org>
 <20260722162207.31a2c491ffaf36d1e8948c14@linux-foundation.org>
 <67e1219e-9d47-4a30-a8dd-fdcf03229f58@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67e1219e-9d47-4a30-a8dd-fdcf03229f58@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B4C84000F
X-Stat-Signature: hrgg6sorxts9qo7xrpofcza7ahucmf8e
X-HE-Tag: 1784815701-404804
X-HE-Meta: U2FsdGVkX18SmsSEqAr6IrpFnNqTc/EIKFCHBLkrXCWN8djhZcrVCAE6RMrhaEY/M9i6qIEdWqjaSgfCu2gbZb0OuvW2hBtxBLB8AlY6I8If7FdzG65jb4BO+8itnB8CQ8JGKlccvIqsMD1CGJyZ4hAOYMI0K1xlFp9KGKKZ13iElYU0vH49Q/vdSAGejaQ6z62cMgRebGBk7lF/3wnV8LsS+FhhfkOE3zOoRqdC785Q/wkrm1OifgE6348QcsWrE6ZsqnjE2a8+VO9C/s1EgaLnbhUF9OngFIFOJ/D1X9unhyzQ15ZwIuL9IQ+FSXeseyytg5XVZ/0/Q2fqmsrfkV+fdHiR2sCRbWtNkXE0irShcntsPluBB+MSlWTHdVe6BK3LY/gYG/0UOpZM1X0TCdPEhda4qF/OiSDtoNgr/QQ6vP6DCB+MryVq9Nv0B7sh3H1HuuikWNTANQmg012b1/T4s2Wvfdfd5VXh8rI4sUXQQ8M/B3T/kvfwnC5O3n2FXw5wSgqn1AhkM79DSPtfBcssEs7CGfWX55fscjnZ6hSoi2sexLqrF3YWP2adZNCy9NdGOi5cPwKeeIk0cPUZSb917lcG9FDHq9g+fxuziK3E7MiBpr8eIZ4mhS50OgzqoAN0cLTwsf49poVmJwhXlgy3DZxkuwYeSGrfrlJLKyS8yxd6QBNCgmSPsZI8k80aoCkI66+cyWd1mR0aoPR0oSK1gLBAxSohAnwfZgMgLNWdDfQWJhUZdOjR6j8hrInVaSVz9ba19ODhuDk4xcss4Hi6gQQeE8Roc+thGnlK1lzU8rJb5sTmlirEufrii8oc0WacdpOplnIi/hnXOtu1pABhphe5Lp9QUdMqxqsUy2NJyF2XzzYpgFDAl4wkRudDmZr13Inf0ZYTlcKOScCCK24rDmaSwAX147DJFwWIFue6h0bdiPjCZFZWGPycswXa11NW8YhSYFCtsrKR5wa
 ZHHmsW25
 Neg6UhglRJWEKXfMf196n3xX9hHfMViQ6HP5PFZ52gFwiLRGDhIO5COD2TRiW4OFb9lg6tM4IUyaf8+aiqPVDhfrU93aZ/0God4VzkIa0lXB5g+pH0iemjYQKGClQQNIKVApljHIpdJn1pThbphYW7PXQryAPIQIgrSfI1ux2ShC8gJWu60OdBRL7sGn1wn2wPGKxc0fsebUkB7+4MOP0iyzzs4utrUiu9+uR4RpuGhf4UP2WQNZ/o8LMuttbUHkB2PH7V2ENPcuQeid7QqfR2wQwpZlz2kDTyzWQopHuBwQTDdmgkSsMRofPuvpIFDWKxYv3ETMi/PR8oOH5HYx+v2FAsmMtUidOZpC2Rin19wr3bslIUMyQHEMsab+9iQ79+YKH46I2aKZhl2Ud6mK9lpX8q0Ma1TN1nQ/GkNB6O+uJvcP0w5F+CYcxv7FneHB9iCZm1YPtuiG2yjJoFL2GMZo0WvrckO8F0kPoQi0rQlmgUY7CI7+IYLZiVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 12:22:58PM +0200, Vlastimil Babka (SUSE) wrote:
> + Greg and Sasha
> 
> On 7/23/26 01:22, Andrew Morton wrote:
> > On Wed, 22 Jul 2026 10:56:47 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> >> 
> >> Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
> >> Cc: <stable@vger.kernel.org>
> >> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > This cc:stable fix doesn't apply to current mainline because the
> > preceding non-cc:stable patches get in the way.
> > 
> > This means that the -stable maintainers will have to ask you to redo
> > the fix to make it backportable.  And you'll then be preparing a patch
> > which hasn't had standalone testing in mainline.  All very cumbersome.
> 
> Or they backport the whole series, even if only 4/4 has a Fixes: tag.
> 
> > So is it practical to make the fix come first, as a cc:stable hotfix so
> > we can upstream the other patches in the next merge window?
> 
> I think it can't come first, it's simply a complex fix that can't be done in
> a single patch that would be reviewable. 3/4 is certainly a strict
> dependency. I'm not sure if 2/4 as well. Perhaps 2/4 does deserve a Fixes:
> tag and Cc: stable on its own, as it also fixes a defrag_mode deficiency.

Yes. Only 1/4 could be argued away.

2/4 actually came after 4/4 during development. Without it, compaction
cannot make sufficient forward progress on the promoted non-movable
requests. So it is a hard functional requirement.

Whether it deserves an independent Fixes: depends on how many
GFP_KERNEL pageblock_order requests we have :-) I'm guessing not many.

> > (An alternative would be to put cc:stable on all four patches.  That's
> > a bit abusive but we do it rarely).
> 
> I don't think it's necessary, the stable team are quite capable of figuring
> out the deps and backporting them with a Stable-dep-off: tag. IIRC the
> "fake" tagging is discouraged? Maybe they can clarify.

Yes, I *think* it should work with tagging just 4/4.

It won't apply cleanly or build without 3/4. So I'd assume if that
dependency is lost, the automated backport will bounce and I can send
a backport series by hand.

