Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C07DBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3ACA6B00F4; Mon, 29 Jun 2026 14:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11E86B00F6; Mon, 29 Jun 2026 14:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E026B00F8; Mon, 29 Jun 2026 14:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60B736B00F4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:22:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F0F168CAA4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:22:58 +0000 (UTC)
X-FDA: 84933771636.21.83FAB18
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id D78BB40004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:22:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hsKO2BAK;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782757377;
	b=YbICSOpf6FjwzsVOdTJDAxKkTPCxvuP1/lSZ1GOY3IKQkjL+HxOOCp/mxIhUdOHwPb92Oa
	Uyc9xDTkfhv2lrnxAha4u0ydyYweqAz2jVgbUme7Nu7LTiaB752j3sIJkjE20FcQZgSe2H
	IZ0zHUhdZA0fr/E1lvBKccFOze6NJcI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782757377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hdEpOaUd21Ax6YrMiG1pwzwQGghCCbiiNKGBo6BJ3iE=;
	b=cTe+mryQVoczOYvA8WwsSWPUdZmIxBYiJCM/jWUeoASKAcegL1STkfntFMa9A1eSfamFOL
	IwDPOf8GQthOfx1M2Y/haIp1/47fRm24kkDKu1RVL4tgmbuA1+neF2EuyLkVSCH1RYU4Eb
	KgiHC8j4+euYxqVDl7qjsOZB6qsTbzI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hsKO2BAK;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e501244f5so72164285a.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782757376; x=1783362176; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hdEpOaUd21Ax6YrMiG1pwzwQGghCCbiiNKGBo6BJ3iE=;
        b=hsKO2BAKm/DzrODdLZhtJX/AoD1o9RXBwyWIUE8MkbeD0TYhDplD+9PlrGtpY8oDGo
         JD1FbddkUtcx96y0PN9Z/diBTIYnGDGpaNne2ygQBpOcZcGzqGNbnEe+RTmUuev51pjk
         /Tt111PetU60A723y5JFWCTkwh9HqSeu8KfLM71/ZoXQGm1tCo4YOPzEypNHmXFBKPvY
         /oppKqYKKOwXE6wpwXPP2KgQRJCWAkJ/z9NwL9P1E89Fo4XNVylPIca9iPYU49Pi46qh
         u7O34GM2z2AmCNwv4hPrTJOfLW69pHHPVjmKN6KEMJbO0DaNvLeVbbs9+9mEzKHKxSwy
         GogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782757376; x=1783362176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hdEpOaUd21Ax6YrMiG1pwzwQGghCCbiiNKGBo6BJ3iE=;
        b=FOV8QcPiXP4h3WuEdBOtrQBfrcgiDG3bPvJvazRj90JxZDvLulg+EyWD9Ia2PkVYiW
         ghTMLaIJMKGqTlGUT+8XJPn5wR6sstYK0asjo6pSv+eUu4llSbjxQ3lBLvFgMeCbeSxG
         Q4pm25rAEeeF7996rQ5hkIKms1c9PbhmEjlJUauVLvuYvq59I+RL4v3fW+Cxyzh0ZGE3
         Kz5BqyxUdAe1mIX1Yqz+rqE9etEfXxK1Vv9nH2BrF+SRTI/VZ9/XDJRYc2Lnll7N7GfJ
         LkSMW/+XO65fvaMWU30O+OJexXv+wSwO/Vkyep/rGShsXv1Ud3yv6yf92l3wfMOjaZEM
         kUXA==
X-Forwarded-Encrypted: i=1; AHgh+RreP/sZkyxBJJvb7RuK+R/LkVTCh5NlwZOaRc4hltAsFTAoM/pnMsjqGwI7i2SnAA/AB6NzE1DEzA==@kvack.org
X-Gm-Message-State: AOJu0Yyw57beb9Qks+t7CK3gcD9DUCLtc8wjiALYB81wHj1t7jUkYNnY
	wQCDJkW34kDCFQ21n33v2a1HTfU8miivgg2TEAp1mA/3o51mhDx21Ob1kQw0urSr+RY=
X-Gm-Gg: AfdE7cmPFASvGhmpETW7EWo3KgQ4RSVGAVTNyabg9oErEvZYdubrbNXf8gM2GffdazB
	JzN5sh7wBDmal7bV4S9xI2pspBJofCot3Z41jmEOkFyXsVxUz8F4EujbOECpFEzD79oQzlK0CF+
	61VvIX6Ju8PE0I4RfYKtLfErRtf5L9Nqd5nAdevYoTJKW6yARCIvz/v047OYJAeAmy1gdEArxHw
	x6EJf++sMjXk2Q9EOlpJBmyUP1KXaWtvO1wWZDw0Gb9q7fLpShPH4k1lQ8o3AeJ6hloVOuZjNTU
	dKnV3iPZWep0vjsLWh8+ebYOL0Kiqo0Y8n986k4iceg+PErkYjUSMjz+lBlja9Z3skII/vBQHJN
	AUkCKOnRhw3iwyNBT4Fv87ESgUIC4DouH99d80u0znmc4F9LRzAtJO+bvkNW7ddjmBjTgnArdS/
	KmGR79nh8/03A=
X-Received: by 2002:a0c:e70f:0:b0:8ce:ade5:e8fd with SMTP id 6a1803df08f44-8f1bbec32b1mr5223426d6.25.1782757375699;
        Mon, 29 Jun 2026 11:22:55 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a328fed8sm4510276d6.16.2026.06.29.11.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:22:55 -0700 (PDT)
Date: Mon, 29 Jun 2026 14:22:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <akK3_qUnEPMNs37M@cmpxchg.org>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <akKyjUbFg6ETqUao@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akKyjUbFg6ETqUao@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D78BB40004
X-Rspam-User: 
X-Stat-Signature: upjfq1mbhb7aghq9k9htkkjfk13scpgs
X-HE-Tag: 1782757376-11873
X-HE-Meta: U2FsdGVkX1+HzB7H/ro/4k3zdVe4ZlTdz0yV1ceaTG/xMpbMecxLUsb/vTOjsmVB/55FmqFHfJPzyilSPa8HB/GroBXOtTdrL8wyUoJsTmskspJGQ1W2paoe2P63toLHh0MJf0mV0wRy3bpw3e0Lptp0zE70w+a5qCqDD9p/8Lr/fBemkRbVh4kI0PwVWd7PW5/yeL/ZOMCyMN1pYIQE2M3Nf2mNY95nMDegAqDHinSNidy3oUEthOxWBO43SMR2WDroyaczXwtcjLgE3xh79YG2SRNYIxvG63PAMJVub8c27iTeFYh0anhw7z3Q0ayCJjVnpQywZsG/qEVr51uKrVWjreSMlqsz+rBNIDaCw64FFLcaJfa9F36PTTQGYwyG1wlQcv6OLUuLUmtX5xJ3O6cSDevbBGYFklTN+96fjALR9ReMjF+0qWSuW+8Apn5b3QK4ZAEAklnEKYKPugMtsnm240jaNCkqeEZkcQ81F+MHnP8hIMYHribtSP42i+Xvo85crF9u34hDNCfHhggw1CQJ/n5d8gQrlkM7uA3mkgRbjv7x1P2hjJypUf0I/c+NegzQVvuwiJYNz1EJ5f85IL6YOOhkQZ+SzNJq1rKTYzbTynqb9YrXl4vzKoGitdnP7ObD6I3OCSs2s6pdFVAMvbaqJExr8XeSmKE48HJAAsC+OtnCA8bx+ooHvYkRih013sf9/olhfzyUU2dqSkX982DIBEH9SqndRoPU3PxakieS/YbT86fwy3JS/7MGBkdPVaZ/C3oSx1DA3PKZUcqJbH3jLba7rG1h7aBXyvNO28T2hqwJEHPaeEzzFFeUPGLTxAgLv4ENfnrTs/d9dfnqqfu8kLo/j+co5PK/WgviN47Zczq5LlQh6dKWmT502xERt3pr9ojngcZ3w8C2wnl2YlkCmFOwsCLqZw7Lkb52XIUJNor0utmvVUtXq4BgkZ2cGWW3HZ+DcNeb6/3nCmp
 qAiloXs2
 hbxJwzuDqouN0sndrLEH2HsBJhxnVBSidkU1cfTyny3n9QCqbCZeI0R+5mArrp26fXfW6FPdDT9kvrAg/jrzHLUepBkfmnk10tRoWnHvPMRoHLNX7GC02DetV2QorWW7Gi9naIDrwIpTzetTy1FMSdrFHvicKYSKrZfzWgzZ3bsnrRfPc9vBUpfArRyKawesPwueyDzSiXledI7on5f6g69rxXC5TFz2mY2XEsZBsK+95aw92HWtTiMZhBx+ywk7h/JhmIJ38yz7RPnmhY+vEwG5MRChhi73Pil5SLVaWyFkooE39KsTR2tIAbZwfqwoZW+F+IUGQxU5TskOwKeWKW38UR1RWJPGcFFQ8uym5cxRT9aUesD7imChHUJCitgWkb3eg09ssOIxNcTvnn4I/d1SmG4/WrKwGlHhZTGikbPVq2QKcpywf9Yks81xFhDjWyB+hU3QWBu7IJ+oAqu583nvYFlQBPY4bx6g3qHX0iEVmkeWkHREc71FI8Nknh9p51B10/1wJa/ETqpghQ9gp8nA540aOIGkM97Qvf+2TCe+u0xY9dxOmxN9wTl6dke/ciotTlmf3+Uisuo8rOMZrMB6RpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:59:41PM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 12:33:37PM -0400, Johannes Weiner wrote:
> > Neha reports that mapped shmem aren't considered for NUMA balancing,
> > noting convergence problems and bandwidth bottlenecking for cachelib
> > based workloads on tiered memory systems.
> > 
> > Looking at the code and going through the git history, this doesn't
> > actually seem intentional:
> > 
> > Commit fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault
> > VMAs") added a vma_policy_mof() gate to task_numa_work() so VMAs whose
> > policy lacks MPOL_F_MOF are skipped from NUMA balancing scans. The
> > motivation was a real usecase: Oracle was pinning shared segments with
> > mbind(MPOL_BIND) so trapping faults was both expensive and pointless.
> > 
> > The handling of NULL from vm_ops->get_policy, however, treated "user
> > explicitly opted out" the same as "user never specified anything." For
> > VMAs whose shared policy is absent - the common case for shmem - the
> > scan was disabled too.
> > 
> > This issue is old. It probably hurts less in conventional NUMA. But it's
> > very noticable on tiered systems, where entire tmpfs workingsets can get
> > stuck on lower-bandwidth memory.
> > 
> 
> Eugh.
> 
> Demotions don't care about mempolicy, so opting shmem out of NUMA
> balancing and mbind'ing on a tiered system is just full sadness.

Right, mbinding in tiered mode is a whole other ball of wax. I'm just
trying to make the default case work ;-)

> This is all just more evidence that demotion needs to be completely
> redone, it's creating a mess of undefined behavior for memory placement.

No argument from me.

> > Fix this by having vma_policy_mof() use __get_vma_policy() directly, and
> > thereby handle the fallback to task policy (-> preferred_node_policy()
> > has MPOL_F_MOF per default). Every other consumer of vm_ops->get_policy
> > already handles it this way, the scan-eligibility check was the outlier.
> > 
> > This preserves Mel's intended fix: don't scan stuff the user explicitly
> > pinned. But allow default policy vmas to participate in balancing.
> > 
> > Reported-by: Neha Gholkar <nehagholkar@gmail.com>
> > Tested-by: Neha Gholkar <nehagholkar@gmail.com>
> > Fixes: fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault VMAs")
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Reviewed-by: Gregory Price <gourry@gourry.net>

Thanks! Sorry for making you feel bad.

