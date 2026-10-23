Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2035B606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JcErSQ9T
Received: by kanga.kvack.org (Postfix)
	id 3E4CD6B0B82; Fri, 23 Oct 2026 10:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BDAA6B0B84; Fri, 23 Oct 2026 10:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD2A6B0B85; Fri, 23 Oct 2026 10:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 060976B0B82
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:46:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 955D4A0052
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:46:21 +0000 (UTC)
X-FDA: 85354166562.28.4E7FA6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A248E12000A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:46:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JcErSQ9T;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792766779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqGtpWRMUHozarHKXyqBee5uJfZddr1rf+OxSwhQcQY=;
	b=LpNNZkRgu8T8jaP47Ccl42vz01ni3oupfehYHLckjmwycvC3MscriY10Un9fq+cGdwXeK+
	P07SzZytphN0eczHlc7f+U3jgZjbYJwd+wDierIf9N7sEONoGV5VJJrLf/X9ys2jgJ87os
	D9g/4FhA+nthRbKJYwIClAFMf5Y8QKc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JcErSQ9T;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792766779;
	b=w6SVv3X8v2U27NZdfyRW3Vy/XcicVC/juiJbe3l/0mSJIVaubfJEZXs1eda/9ogfqVvTrl
	UbZhh4eeHu2T/g5pbdl/AvnmBk73eHxcFFGlghovIPwPUPxEpzZnHN7B/otB+jOLNzz7Hk
	A0z5NFIusuH10iMnSx0eyiCrOYEsLYQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F12D60236;
	Fri, 23 Oct 2026 14:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878171F01828;
	Fri, 23 Oct 2026 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792766778;
	bh=lqGtpWRMUHozarHKXyqBee5uJfZddr1rf+OxSwhQcQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JcErSQ9TuliGlGZxkzOepRIlxxK5HiIRT8we8KsFU71OvmBN/ibjVFPXcSg/HflJN
	 kTLNHHCLpjxyXrsbHml7H2KaJL4tc9uTquWA8q8XGUJmxatuYnSEJhLDc2tI1NPqFe
	 Uu2r0WBMORQ4bbrUKycyppkd6uoCrFRnrSIV1BfN5HlzyEWXlX2+aO/s7Z0k3BhWCY
	 v8ZbTTiNooLJXOtqe1M+vgZL0nXrcVC2CVNBYI10LGecEAGJtwg+RT8DAVJCuZU6SP
	 cAPeVty2DeCh+QMQNzN52jFe4gQ5b5hect0Vz8p4V2QgBYXjpighiU4TNq2VBA21TS
	 py8YucAC1UEYQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id ADC06198004A;
	Fri, 23 Oct 2026 10:46:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 23 Oct 2026 10:46:15 -0400
X-ME-Sender: <xms:NHPbaodxIwfmERKVMjO3emuC-DmCiY3_wsg_1clj_OjlSJ4QcopNZQ>
    <xme:NHPbaj6DF3rY_8J2h4I3gpAc7Dgb1qW5r22W6entvNGUtZsQKI-pL8WkYi2aqDWcX
    kIoIJEtvoTpCP5FLEUh8x0yyqUbWNSzsJ7LpsUZW_Ih_OXfbk9xLWk>
X-ME-Received: <xmr:NHPbao3WddwwbxsCpGRLyfnGMn-oEOOo-xSQsrvLJUsLOPp5ELRM6ZuXcVU>
X-ME-Proxy-Cause: dmFkZTGWzcuTEmWQLzfWqLZ4TItB4My1D1r9DQkczQVudo2y/CBinrz6rqIzv2fdTJmQit
    MWJwEuqXf9cP1nnF52BUgbU7yUcs+aIKR0NY8tHKyUAivJTQMueCYpQn8ziVleohN2asNT
    tGiSIb/MnF0vPL0n8KcVeHWwb9xD6DTByHfWnkc+E9lBZUsMWiAGWDml2tJ4AoFQ4qmqUq
    klzQi7HiNDGq/ym69P3GPHlzA0NXkSTJL0DBnmmdXKgajw/9OG+7sspwLXuaVqp9sQ+R2u
    vUgM0+L9lfRB0WiRaKnp8iETDuUJ7ldQdWNvFo8/07kNi01NTiuWZMMGjzKp3oJnYQ1kMe
    aZmc1+hS843Xgoa+at+eHcthqrFTNsIASPbVgVkQdLBcwgNLu7f47IV84EwluPtPFk7HHj
    1+OOrN5ppjcVEBedXqBYX28mBxEESempkNBsvPR/9gv+U656dlQkJ6Hy0PbhEtYHkYfRGn
    emwXRBdrGi/52+YAD/MDJ1luUrBPlH3HdqF0uC79YL+SljSesdSUh0kBE5jzBGKa18s1fo
    L2nyo7hZ8GmQH2Sp65qRN0u4GS2G4gUK83dT0rZiG9HsflYpRKpvrHv/ZxkI+8xU2yvc/1
    2U770t5dX5AZkR/YSRK4lyW4+zSO3qlgebWsbxvTefu8FgM9L8ZrPx3JNQTA
X-ME-Proxy: <xmx:NHPbamAm7NyUBz06IvsKkX4ExFTeotqYnXDVWnh28bi7qJBm-q1gVg>
    <xmx:NHPbapHrTjiOSJmluRQ3UdYqxMxueCquFcSMHWzCsOVwKAV3RqU0lQ>
    <xmx:NHPbago35GXJXdHH4AychpbXg6n8uSJ4cq75y25cdS1rRJCnNPx5Vg>
    <xmx:NHPbap3IqfFmICatC8MF6w5rAe0H8G1201YtKl2IMScodEvb6MI-sg>
    <xmx:NHPbasCOcP9XXZMfbA85AOiwEouDFFnDBy3EsIC-u_P8YgKgy91TwKAF>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 23 Oct 2026 10:46:11 -0400 (EDT)
Date: Fri, 23 Oct 2026 15:46:10 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <atty0n4UzTfI46eN@thinkstation>
References: <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
 <as5q14OsbK2CmOrh@thinkstation>
 <20261014202936.GC371161@cmpxchg.org>
 <78238103-3a7f-432c-b1df-bd14d7cf4bb1@kernel.org>
 <atDMN5MoGrwJNpAj@thinkstation>
 <4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com>
 <atiCG2iPrHwDznSZ@thinkstation>
 <d2b8edf0-39ab-4a44-bd0d-58230dee2fad@arm.com>
 <ats7oFM-fsYdUS8y@thinkstation>
 <attOFXch_TchIfEv@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <attOFXch_TchIfEv@thinkstation>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A248E12000A
X-Stat-Signature: ip1a1r8meica3wcgncbo7cf9ghm4fer3
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792766779-908704
X-HE-Meta: U2FsdGVkX190Ymk5l7ZD+eFszDD2n7fL+PvnenBdc6UKfqrTdPqxqCv2gpNXd/pbT0WoUewWqiBT30eonJ3z7y3vW1y+GVXRntmQ6p+aWpZeC4hoj5YlY1B67Ye9Fl85uRDP/kUrN/K3wtGAU4r5pHITO0NrlaQbSdwC2sNVO5etV/dP84mW90UnLyZx3Xv4ehurNU3xL+UFLofLvHU1YIRMepJmJZV6xecD0gXy6gVq/bO9Y4uX60oudxWXAaP/mU2TxiJ5iu5F+2Ept2TbGsWSSyNg8rtvc5n0qcMUoL11JOjZPyqnIqMX0GJkCElp6MlCDRmBKS2HtPPleYzhQ7KwKt4IsWtVlUfJeIphpjI7QegrHFFKHRV1YT3NkHS0bxQJE/RCF4Bo7vulOAnZPqWSclh4L2UETCoE18vTyRkD/sxalsnNFF643vyWgKPsvNe02RkNHn5u1MUeREJ2pPCTk4GRoEPfqDOHqxJxQ+v+tSSUTD7djP9wkq0NKrJVFX/GVm1Vi0szHbeoB8a4COpWZaKzCgYmlKRPpRAL6I61749COS992gSA+SRRYhbLAMMloFANzQ2XlLSVb2QCVP66kKEjYHYeGJ/Ar2icPXNpks+ZquhDHizIvsttJMWd8eE5Z+fmf+X4kGxs6ZpYGCEAVJEBzj29bgYINFebQVw+LkvIT7CHmqp7e4VGxjYqrYJD35LO1CajE0zDVcJP7KI1swy9TDzpMcQbUjDeZArW2CdhUF9Zof7s7s2crlho4HO7610DR2n0aLAtNCIlZBNGyUb30s93UFOWjIDKB5MQAEkom3dQPfw6srFnfpg3yDpJkxxjmc5BNWx87boCyFfYsPvAShAAOENEdXiVgWNw6VD/bjFaGx7YyrrnVwz420dHnCQd+NXu63VBGsODPL1Y3efZStUmBS7g/JwTAQFq8eyrjeevfEOpIV/OonJ+VpzzPbuck4Nidz1rMMH
 Y9j68xz1
 nVpKdep0v10CwbSFs6KXvWlhfJM1UsDiG1KmZJRMdLtUCdCE+Jq2EM6YFBAuUopuy6wSNRxUpl/SjLn46tw2OqtJ2G0x//cIg8d9rH8ryTbSC/sHhonVeSBEf90xp/jY016P8YZEqXbilZZQGfXY6/l5vej62lSUktCGdDJ1mKfBFlj3UTGidiZzw9Erwu1d3Sai4gmjIraPml6qpWDdT9vuuqimhTtlWvor2gjNLL/XMTcuFX9xVtM/HR/jrDt5H/y31IKkpBLOGAZzPq0FVRDs6GE4Y161gBTFHc5RxOWMVNhzgNd3UR4+BjfwRpdkbN3pP0TCVQ8Tu0Ubc0kEOmeC9TuutU3iA0rsS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 01:12:02PM +0100, Kiryl Shutsemau wrote:
> The diff below replaces the previous one. It needs cleanup and splitting
> before it goes upstream.

Proper patchset:

https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git page_alloc/nofrag-watermark-v1

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

