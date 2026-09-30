Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD43ECA5FAC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F296E6B008A; Wed, 30 Sep 2026 08:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED99E6B0096; Wed, 30 Sep 2026 08:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9B56B0098; Wed, 30 Sep 2026 08:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A72FC6B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:12:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45F0A1A077D
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:12:00 +0000 (UTC)
X-FDA: 85270315200.19.E0B18E1
Received: from mail-oa2-f34.google.com (mail-oa2-f34.google.com [74.125.231.98])
	by imf04.hostedemail.com (Postfix) with ESMTP id 666254000B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:11:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eLn0WZIz;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.98 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790770318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFYvPCDLrvrC5oT74t7swbnU8bzwyNGtjBbSx2EyWUU=;
	b=Zxx+TaiIdAIeUbEcBqFAuc534HMbv+3ouOnBsoo1hQ0O7GPAXSNiBvcxO/au1nVrnaSJgu
	WsKLTai3LLzj0shcnizUSAW5IeRdJfcy9v574zF3mRkP6EOImlU0CLO7Aegp0SQNVA9+3E
	QuNltok+zqxIs5fDci7jBEu/wzlH5Mg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eLn0WZIz;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.98 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790770318;
	b=Y7rPvqyK8p9ebajmcozBQbXhqR7+BBAzbNgVvV4DYNBgah3xE8+nWae9ICKIYsqGbgFUmY
	h9O52+OE5UCVug11EoK0PIxMat32MwLnnJm1FLBTBfk0QQi/WSOiGppZLdmzF57RTP6/aV
	AWoemvXHS7N3GirmAsL+Yt5Pwly99K0=
Received: by mail-oa2-f34.google.com with SMTP id 586e51a60fabf-49936e6edacso1700370fac.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790770317; x=1791375117; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZFYvPCDLrvrC5oT74t7swbnU8bzwyNGtjBbSx2EyWUU=;
        b=eLn0WZIzhacC2WEaQm4w88kBvIyEht62uW5UQN3pTB07Z9sz4C5IQ7I8sizlTdrB6C
         gu7whJFs4gpfR/2aaxdtJi4NJ0vRhQhX3aaEN3a3evV52WdjcTENLB9vg5iqK+aRl0Fu
         aZgxGiEjneeN09ON2eOUKnxkhhI4l8A+WoHsCAykGxYN12dMpBFus5G+6pX5qEhYTn/Y
         eWReXkRFdyxqv74Hj5NVXFkRiz4dVxlFjqi5NqsDQB5Lu3eR951X+TaLqkrM1UcVc0Qp
         8XOkTcEForNSLWp6a9KV1LTByOXtI6SxGEZe5mETH78yD5tcHVTTRWnt2Ee1uSWMKSJ7
         qx6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790770317; x=1791375117;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZFYvPCDLrvrC5oT74t7swbnU8bzwyNGtjBbSx2EyWUU=;
        b=GKgwpJvpH625NZy+N8B+uKlkYgIhRj8zhTJ+BniSAdBrG0PH62kFKiMgScQ2wWnLFF
         ivnIZRouxWtq0ceHMoSiDv4Tg7qPJ7xKJS8O2kESDN2Fpp+DIE/z6BakbuZH/0CRTr/b
         w5JT4rKXLnD8TalJL22MEXAscIHozG/6VCCQg2snhVvc9xFZQUFSGVTIF+fgotE86lxd
         m1XkoODOXPCK0N0yYkAB+ulGkDIW8dGHhS9BIPjit9n80jGeyGrkrlA/kPDAIllWgNBY
         7NgcNsMuVwCN8u3zAiXADpfJ9Du3/6SImsOzbEsXuCm/Qh0RB2ZVyTYLmx2VSkPm3ypI
         oBSQ==
X-Forwarded-Encrypted: i=1; AKwUvBzA/B534nFNOGPgEcwazXisr7RKChLSDGNvniAjz7384mRLeXGdFX3ACp5JyLr/Y1S44TpkE95O1Q==@kvack.org
X-Gm-Message-State: AFuF++lRi5fTcKUYzSr0lGjpYJa5Z2iwffraW4/dlWvI/P5ofoAH3mEC
	3nVjkY6hz7ipPoGqc/KKWeBK2u6oVGw3OG5sFYOM1TPgVGNwG4nxKIbh
X-Gm-Gg: AYBFou2U8pOZ4qRrjDbFo41/3006MtGpeLy16x5qNjcG09Q1XmMcHFb2XpSRErRh4gX
	3gUiZKTdnRPjTkWQXlmZdw/mZQAHPkj99IhvQr7RcrVAAY5Xg8z+oajV90v/i2pZrhF48urUyyw
	H/bNkMfDFrhBkwFFpSo7539qqzxqciyty1GIAPbw/v/h/pnXpBteSZ/z+2BBGeIvrOeohaEgysz
	o5u7yRO6NTebixojE69zss4IeKHoLZOUUDAqXNMTKVe6/bMwrnOUaU9DMpkbhDquZEAubmxQ3vO
	qOZ8DfcZxBcFbOZjmgxxIn397tdKPCw1Qj+wBPb13Q6j9zMUigkQJJJk4YXLMFHIugrRSVToixc
	MMPCJPbtZp0TLOW8Ecgt4mqjrysbTJ2JkgCz4C7iV2AE99DhaKGXqpeyD1cWYGYu4rtcOsvaMYi
	JVDQCRCHoBdGe8O7VEG2OmKs9Q1IWNdOAp6ZOuZPx3+jlbu88nH2C0xXyp3I/CppeFi4wkTcfio
	RCFU88rBCbXduoQCyEqvi2fJqiIgg==
X-Received: by 2002:a05:6870:9615:b0:49d:c9ed:21f2 with SMTP id 586e51a60fabf-49ddda314d9mr1064165fac.18.1790770317220;
        Wed, 30 Sep 2026 05:11:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-49de00cd469sm522330fac.17.2026.09.30.05.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 05:11:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference with MPOL_WEIGHTED_INTERLEAVE policy
Date: Wed, 30 Sep 2026 05:11:52 -0700
Message-ID: <20260930121154.687586-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <808292b4-841c-45bd-aacd-b487be1858ca@bytedance.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 666254000B
X-Stat-Signature: na77ph6ig9zjfeizje7yhaoptse49tsz
X-HE-Tag: 1790770318-271369
X-HE-Meta: U2FsdGVkX1+2APaythQwunv5H7bgjLhjj5jPJ0PhtwDD5fDolU1Bf5BjXff8W9iBlacTDZBRIke24HBO+J2plwbazgaTTZjNstxYVaqXyTog5jZn1QT2EEvh0lX5SC6/miACwy6cFNK7z4OwDARlrnuTxGGDLiTV0OTOWgbI4BOtRPvfdn+j2+V3EresFmUfPXXRqMyKeGZixA7ROxGUso0Jj5PHdNvNW5YdxVxRajZy5UY3YJidaENbD2NSBBhqbP2jzsGtG9pkxRAacY61azng5zK/jeGLVBR/tpd3LmtGmG9qv2yDGgAMSSLhjl7FNXxqmrqfq0TQi1q+KuWt4gW1hSpC/x86F0yWEeyCeIyEtLmmb+nCRpoKxu+5fiiNZmlAeZLko8dzcpZKAk/s92MjIL8S5aSjxaWG5BB1UPgjGcHFNN8+hrAvNfEd9p1DtMwtW6QaxgPvvHlcEQUbzBnHN+NODA0obvLt+4qqxk+J7mLwfLJAwQggl6mu0byerVhlnuRYG1pzwv7X1Ko2q1uLFwjZeYpEAkSC7wt+vRo6u3I3O4rfcY9R7Jm4v7ZWvwY2pDyHvscgzZ8RhSSl4H8Gyrqz0WKudIM0HjZ0YwXtTx8Djpe4pJQvRGvU6KwuFyckp/99Gb2tPqWI86YztgU1AHlgcx1S7Ilt/xB6ViDZJ7TrRGSVrZ9MXSh6bcMSsivTduywl3ewEwcgGCJFgcF7meReq8ZSbFI167XPNol1IbIRjpbFsb2/zJz5IIamD8fHCmzmnJqmljL2N+v09jL3SN/8NUz5PIXBSnu8wRJubvNLLKFkARP5HpFW64/SlVNm6mmKFAKe5ibWHsnl2DUxnW+YttA8CvhfYWra6Vg8WP9JMfBwaNV629N0UNk7qmSXvkMk630fmd0KQbe9oNQwUuwUJAJGiQ0zoefq9wQMBVQxFwne4hUQmSyJ10WDCftIB29nabXw8EjNuUU
 ABsz/PEl
 rFmKmWC/VRt48tfeUb256Cta4WY+TmR2kJRJD+JKrqYcnnas6JLf61IJ3WZncsq7fL0qCKPMELHYQf6D+Imhc0hivBn+2H5Z5AzwemB6ryNmgu0JU7cQVH+TxbGPOCpwbXBClKXkn+5iPw/7YSZ+IqJc7PFjMH/Hu2XWCqa8pbekcx4/DV01xCdAF+ZdaWQBT/oJoLjiJjMtL8HYvQrCHyCRerB7FYQGMZmg2P55rl5VHaMMlW6MejUQKnFXqzvCB6tEF9s2sz1c0/08/51mQxn7MWl1JXKgz7BXg2rYgSqppXA63RlQlMxWI5jKHrPhuARe15DsShHyxNpe3Qcj/k6lvhA7jRClKjldBlQKFdcREU/qaO72nzfHCgEzl0aKdnqRtiRo1MmbRszGNxMRhNAWrHPWt265w27U+yjfrgyX7rgsRtg7GVBfY+gxey8c2WRfuGEQ/G9AjbTBLPqXrCisrYJKP2zEmx1AnHDy3YoLDGT4RWO1FDv1C7TFk64Gjm0njkUrDUzbU4pjntCvI8dZwTLAZjdfsUChgpUQ2GwKvYKCZeEFkPn1NsPgva+syhgJmO4rf45R9h0sKgogtLL7KwiCjhJR62iskIpQjNmXRtTnQU1b7QBZ2D8QScDvbnnM2XI58cG/L/GC1TU1uETh1xyjHyHyS1hQS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Sep 2026 19:52:05 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> On 9/30/26 7:26 PM, David Hildenbrand (Arm) wrote:
> > On 9/30/26 09:26, Li Zhe wrote:
> >> MPOL_WEIGHTED_INTERLEAVE is useful on tiered-memory systems because it
> >> can seed a workload's new allocations across fast memory and slower
> >> capacity memory according to a configured ratio.
> >>
> >> That initial placement is useful for workload managers and orchestration
> >> systems.  They can take the amount of fast memory and slower capacity
> >> memory on a machine into account before starting a workload, and choose a
> >> weighted policy that seeds the workload across the tiers at allocation
> >> time.  This avoids starting from an all-fast or all-slow placement and
> >> then relying on promotion or demotion to reshape a large working set.
> >>
> >> After those pages have been placed, however, the policy cannot currently
> >> opt in to migrate-on-fault placement.  set_mempolicy() and mbind()
> >> reject MPOL_WEIGHTED_INTERLEAVE when MPOL_F_NUMA_BALANCING is specified,
> >> so memory tiering cannot promote hot pages that were initially placed on
> >> the slower nodes by the weighted policy.
> >>
> >> Initial placement is only a starting point.  Pages initially allocated on
> >> fast memory are not necessarily the long-term hot pages, and pages
> >> initially allocated on slower memory may become hot as the workload's hot
> >> set changes.  The policy therefore needs to be able to combine weighted
> >> initial placement with memory tiering's NUMA fault based hot-page
> >> promotion.
> > Ok, so memory allocation will respect the weights but balancing will ignore
> > them? That really sounds rather odd to me.
> >
> > And I assume that was the reason why we might have disallowed the combination:
> > it turns a weighted mechanism into an unweighted mechanism.
> >
> > So are we really sure these semantics that you would essentially set in stone
> > here are the semantics we want? (ignoring weights)
> Yes, that is a fair concern. It does look odd if the weights are
> interpreted as a hard resident placement ratio.
> 
> My understanding of the existing MPOL_WEIGHTED_INTERLEAVE ABI is that
> the weights are allocation weights, not a long-term resident ratio. The
> sysfs ABI documentation says that these weights only affect new
> allocations, and that changing them at runtime will not migrate already
> allocated pages.  The implementation also has normal allocation fallback
> if the selected weighted target cannot satisfy the allocation.
> 
> The use case here follows that interpretation.  The weights are used to
> seed the initial placement across memory tiers.  After that, with an
> explicit MPOL_F_NUMA_BALANCING opt-in, memory tiering would promote hot
> pages based on access patterns, not based on the original allocation
> ratio.  Users that want weighted allocation without that behavior would
> keep using MPOL_WEIGHTED_INTERLEAVE without MPOL_F_NUMA_BALANCING.
> 
> That said, I agree that allowing this flag combination would set the
> semantics for it.  If reusing MPOL_F_NUMA_BALANCING for this is too
> ambiguous, do you think we should model this as a separate opt-in ABI
> for "weighted initial placement plus access-based balancing" instead?
> For example, a separate flag or policy mode would make it clearer that
> the weights are not intended to constrain migrate-on-fault placement.
> 
> If the allocation-only interpretation of the weights is acceptable, I
> can make it explicit in the commit message and documentation in v2.
> Otherwise I would appreciate your suggestion on the preferred interface.

I see two usecases for weighted interleave. Let's say you first allocate
all the cold memory, and then all the hot memory using an interleave
policy. This leaves the same hotness in both tiers since they are
interleaved:

In one scenario you might genuinely want to keep some hot memory in
both tiers to maximize bandwidth utilization.

But in the other case when you are not limited by bandwidth, you might
indeed want to start out with a weighted interleave allocation to
reduce variance on where hot memory lands, and then make promotion /
demotion decisions based on access.

Zhe, do you have a specific use-case in mind? For the second use
case I would be curious to see if you see any meaningful performance
differences in startup time when comapring a workload using other
mempolicies for the allocation and then tiering vs. using weighted
interleave and then tiering. 

But yeah, I think David is right that we should go over the semantics
and really make sure this is what we want to commit to.

Thanks again Zhe! Have a great day,
Joshua

> Thanks,
> Zhe

