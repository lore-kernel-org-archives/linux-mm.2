Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A7F8107BCEA
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 00:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83026B0088; Fri, 13 Mar 2026 20:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30D56B0089; Fri, 13 Mar 2026 20:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32FC6B008A; Fri, 13 Mar 2026 20:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FEE16B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:21:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 579315889D
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:21:23 +0000 (UTC)
X-FDA: 84542764446.14.17465CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A9AD3140009
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:21:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GlMnrYsf;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773447681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKQ6fWwL0j8N5lh7dX8p/uAAVUPvBMVhKznm/zW/5h4=;
	b=7ZfjUdOCFwW3BCeWoxqxnV/RHpoXwFDqU+aM7A+zFtP3vlbAeo/mp6udHmxYpTSQCVutzf
	Mg41bM/nVseGUivHlhoKD/7jykJzgBll/KlycCTRZMeBNHoeYWzQ85XCoP59oqHDOvA3nU
	wFGuefmfZp/FME02YJ6Ux43Ksr8L7v8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773447681; a=rsa-sha256;
	cv=none;
	b=18ROQn6E3lF/AziYtepAu7orZBnLoj3EYaLslSZR5iAqd3ZQEuS6IUjXkUt+WPi5Rk/ySQ
	aph0G2UTmL/+ACwUGYK+GRIQNDHXxTlcV/c504jVIKS3CX7DndGjlLI47IPD1JN0751qzr
	7bOakVOtXDhCeyqDtBdt9h5zTAvK4IM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GlMnrYsf;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB37560008;
	Sat, 14 Mar 2026 00:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9FFC19421;
	Sat, 14 Mar 2026 00:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773447680;
	bh=UJbfjXt9aVSOiW5buRYz/cMornZh+o9XMfOB8wS5ODw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GlMnrYsfkcmXiMzp0R9Fy9lNXxphl9+8SdFOUvmZBrJb7A5Yjy9BNtfgTWiXQEyvP
	 5XU3wmEKnGqzQ2CCTIQ8kc+cWYraMBJgUVR1DAGkrP4VKjUwdJg+GtzekpmvffYuAB
	 65CFALocwvsnhOTwOukU2smnhLdAgLznSpIGtUqfxH/VQetRYSuOZwFnp4N3d9crBN
	 eW1edtyYB+u+/enfauhYREDy3OPqqlI2aaqwCnVnydA1rs13cU+SrfW2L9KQwXreBh
	 meqOa07Gc0+u0tpXdzhDVrZ9ukUva90nUNAt14/9C0s8eITbdOZMqIvKjslcJhBQbT
	 w/8fVKxQLRbsQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [Question] mm/damon: conflict between DAMON_STAT and DAMON_LRU_SORT?
Date: Fri, 13 Mar 2026 17:21:17 -0700
Message-ID: <20260314002119.79742-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAPLv50pLx+Jk+7so9uWrpy8qzOnvSr5QkbJkQL-kctEwkx=qOQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: pzrnkwpxmfu6j6n3f59hggyxaa5so3gy
X-Rspamd-Queue-Id: A9AD3140009
X-Rspamd-Server: rspam03
X-HE-Tag: 1773447681-914638
X-HE-Meta: U2FsdGVkX19L6XGdPHG4BU989OxZ6ZvDqcd8Ba4zV5/sc78naKRIs97DKdzz9g6MOHzz9ThcX7bWNuA5DFOBS43ZOKIXCtBY09PA11prbkD3yBaOe3ENt3WrScBjEMDeLGmC7MXB707YkLcGzhUkISfkmR70mzqMI4NUaxXI5QtH63d35ucd7EueV1MCBnrlSop7U8KvAJ7EnZbd268tTOP1arLlNRMO0t+crv3DB0Q7b5f1zohNNePQYuuVEjFxkiWHywkwsRIs6QxjRxo4PI7PJFJjOfNuWaLcz33HIyW4qTVzuWgE9K6o02k4yZAv+QGeNKpiYJxYwHOi8nTzRljJYDgJWJQQD2aPM9anB1RpTYEwXr1wQuGQ2KIoDC7Y3zsxUH2fCUsVG7RGcX6e9fTfJOArvJuCcvZ6L2KZ0pkDAGi3Vhg7D+O2GUWckbmp5wMxZ7dPSMbYPTA1W92SOcR+O74mNJ6GGukGlivrrwFbKD/Pb9wLoAXz2LAfC8+lyKjSXIhK0tSuodFARrHTpIVOBulFXgaU4FYGtSFKbp4kjGEBhqmSmDrhHkRBKNfdJJBLNAWp8V3TUgMABdpOQqAcQlPGS3O5gMulIaPt/qqKsD6eMg5BEzTsGmPDdJt1D6iuEaqcnCxTDiC4tBasNzFxIMVHfRYwE9bomKLv968AlkdLFR4zormH1EPSZZ/UDD9DO5SqVbXBXP9AIDAXC1/nSNKziPCiV0xSZY+UGkgyDKyMH9oEWzYdAtqhCPBw70pEa+rF7791g0ZbJcYAEpj3MUOgaWo8SH2MKlp1UYd82PwTMJP9G5WCpAizStUqEkCy2/v5ZSxp6eJ4WKpSDtX2yQ6jDDw1QD42jYw3PZ1QrVYLWvMQCwkbT6HtDiNRWfdVR4m2uEfngFUycZgCpKjQypIxgdwt26gpNjauszYSoC2H7AkAUnk6Hq5sxhWPc8HJ1ZG4AB2AFOKxPs8
 0Ii1yaxb
 HFw+rA4+3YPO/bcf/j0gNDSMPFbWXLx8bVCQTn/nHl/0LxHuc3ePRosKIK7XGean+8DizqDBmk4ytfMsLEZfpROnHX6m4/fvtI2DSXPvPxFM6HourlJSL15zEs68HSj1Wa4aieKEyK34QqGmh8zbILvsUL1R8UOIq50m6FcoJQFCuCkTt4WGYY6cdy97CKKQlZNwsDV18GztWfOtG+/K3VjaToGo78CpLffY2ExMsrK3wO0Ld1CjXNaraF99k+SrK8fxcNbRKsbbSbxynEInMRHmvqGFb7hwTPn+6fju/bPsyhdUqGuyvJOZfVPI2NUP/GJrZ/DhIKVn0MHomFP/ntEqfO4XEc5ExloxJvvGe99dJL1e6pb/YLCF+kgIJtQIviHVU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 14 Mar 2026 03:42:35 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Fri, Mar 13, 2026 at 10:52 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > Yes.  But, I think 'Special-Purpose Access-aware Kernel Modules' section of
> > Documentation/mm/damon/design.rst is a better place to document it.
> >
> > Would you mind sending a patch for that?
> >
> 
> Hi SeongJae,
> 
> Thank you so much for your quick and detailed reply!
> 
> I'm happy to send a documentation patch for this. As you suggested, I'll
> add the explanation to the "Special-Purpose Access-aware Kernel Modules"
> section of Documentation/mm/damon/design.rst.
> 
> Additionally, would it be helpful to add a short note with a :ref:
> cross-reference in Documentation/admin-guide/mm/damon/lru_sort.rst
> pointing to that section? I think this could help sysadmins quickly
> understand the reason behind the -EBUSY error without having to dig deep
> into the full design document.

Yes, I think that will be helpful.  Let's do so!

> 
> I may need a few days to prepare the patch properly, I want to
> familiarise myself with the reStructuredText syntax and the current
> design.rst. I'll do my best to send it soon. Is that okay?

That's perfectly fine.  No rush, take your time :)

> 
> Thanks again for your guidance and for maintaining DAMON!

My pleasure!


Thanks,
SJ

[...]

