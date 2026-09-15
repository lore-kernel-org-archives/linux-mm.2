Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B139AC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F286B0088; Tue, 15 Sep 2026 06:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6D56B0093; Tue, 15 Sep 2026 06:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE6B26B0095; Tue, 15 Sep 2026 06:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 906F26B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:40:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6FCEA4F66
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:40:43 +0000 (UTC)
X-FDA: 85215653166.13.59EC497
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf07.hostedemail.com (Postfix) with ESMTP id D254F40008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:40:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l KsecUK";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=LnZRN66h;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789468841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GR5i+ZoXZtVmjVFbg/5ljADDJkwxtSAlXIoGrwBZebs=;
	b=S7nseW4EhywZ6WIcxnCdb5228XO4P1Rw6sF/+dXi2OriCGXkjBgjCnxMDsOrKcyi20iQTw
	Lso1cMdIpKXnG2nvEEgR6lXU49hbIKj6PSRXWf9yq+3JW/fu7pnh2hX9q6pPPoaQ9BKlIs
	dZBORFaehfeXOtnRy2SQ+ProP/R52RI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789468842;
	b=f/UZROWcIGoO7Y5UaTpM1UJF+ssKLUPeicDNA0hRcmmNH9FXOB2Oae04IPco6c9yJ+A3El
	+mFyqsSlGxTduPyLqBe7hJgnSKavkbNacR+Qt8SNMCznClDrUVxp65gL1qn5wvNOKux3GR
	kVxx7P2cGKcUJr5fPcsrrlFNBWjQxrQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l KsecUK";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=LnZRN66h;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 6AC9F1300501;
	Tue, 15 Sep 2026 06:40:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 15 Sep 2026 06:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789468839; x=
	1789476039; bh=GR5i+ZoXZtVmjVFbg/5ljADDJkwxtSAlXIoGrwBZebs=; b=l
	KsecUK6b0SRJRaq+hc/eB8E8+E+0OS3TOgWMDQbkRUi99Sm6DGJRnpgm8BmabSww
	94irUqC7athEF5czc5H34GvEV4gCjrkDH9KM/KFN0XAw5nUNvVVq8ZeeSm/NIPw/
	PUg16rQKCi5d57z4wVR9Yu2ZGdO6Pi0Vhgwli0EWkCkteSF72+SYP3fVidRcnze5
	pEbe+q4EUL40mUCPAn39M/JQBgEsmy/LAFVXDQyjxIbepLwUH+rvZYaW43SkUwbe
	FyxzhyuB5/Z9JophI2poul52Ab9s1BBMp64H0JpfyjCaZwvySDR7e5rEtbG3eOD7
	UoFLCPzfGxpymeQlTS45A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789468839; x=1789476039; bh=GR5i+ZoXZtVmjVFbg/5ljADDJkwxtSAlXIo
	GrwBZebs=; b=LnZRN66hWtnwspXOjsG7LYeKMX9nv/hfkWjD/rulqw4ftSSQMIb
	6Y1xvTgEUtkRJsi2+7XeBVytHuFl9n1BCAdNuR4cf7u+M8fbFeXtoToAU/FrRlKG
	M5xVcp1J14A1W5A4TAUCW/kqAZbA9oTtFCOsRl+sC0AOdGxZUlHKXa+02PREbtpl
	q0B3S6azIA90MT3hN1Xhw3mVppbWdJBkGCanFCXWgBd4fSZ1/FVuLBGkPwJsqXa5
	pQg96MBVgQKXynEQaBjlx2bqLH6yGxnGX0hxMIeXRxAr8ymnzfIMGySzTQXBjbF5
	Z+31RqMy2PEHzdrEc4FhySNOYxWD6DPzC0Q==
X-ME-Sender: <xms:piCparUGOh-7OzOBTWJ9bVDSpNpcvcTxlfTEG3iDldDj8AxLeuuxFQ>
    <xme:piCpakDxqbF2o17pItwMoDiNI7hxLrRQVe9DwAWaaTYA-LJzV41qSF_wbgHG821KO
    k8J9BC-Y-FIbF2baYXh8fzTQI4xYmhtyQ1n-oE8O6t5O1rd0C9hYo6s>
X-ME-Received: <xmr:piCpao3Ofeem80nKOe_L-k3lfV1i-3UxZmkarxLkgRSY75RSG5CpoULtF18>
X-ME-Proxy-Cause: dmFkZTEhemmXWsnAsUPz8NwfFxfaJLXIIfsZPuNrLsudoDyPOrg10URvNaoJjcAhSb4BJ6
    NGycg3zzbEkaFXLNIYaIayK1e5/D+4SX7QMtqs/19tsC2OTy0fD7MUb/ayjwUbYpRSvsny
    dWBBTGqUIjlS66WbFOOR0xO4P3cCOQtscZKQqpTDLonV1xgI83aTnwikIox+H2hLH+T6Km
    Hgh5ZYol3xHjmHDHrcYHJERVc1jNMjSO/LlooMWTYDb7VOTAB0CN7EA0Sskbxhnz6Az/n6
    ysmT947gDGrbmIdSFz1qxgnaVFaBn+TD6H59jKLDiF5HDUCwv2dSJ9A3WfAg1o/EWxqJoX
    abUCfAfCQuyjhs1hHxdWdl4efy1FhwNrm7bf3fgzdv8pc9dZNhdHd1rWL0WQkES6aLPrfi
    +7KysM0c70bc6V7BqYJP+x65hrmyKszDDmY1Ozro56v8Z18cBjhzIFu2zTkzVC8g2+rYaW
    j3MsQy2Yiq9cBFh31x+Sk45MsPHmV6oWBsxBSfAOr7JKPQ/Im4JL1Au1MSg91IBdqo35qJ
    uaMgB4SHkBXLNn7s8/qefkzXTZr7CaL+EOmJ2qBJE2v/TJPRaXQ0FpUC1S1mSRgJC5RTcD
    QNEiW/TiJiUyIKaPsfb3NUIub2mi5cu3cNDEiisw8whWf1yTjs7Kd7pYxY3Q
X-ME-Proxy: <xmx:piCpamXHynRvRmnQQtsmeNVRFhIOjnlI-4P_hCf6v7bjhgfR7GsGzQ>
    <xmx:piCpak8QJ1pEaKAxoJXOmqSu7QHC0nQccZmqxIDFeSpNd0H7fd04kw>
    <xmx:piCpar0mqM4C9apv8P7erX07yB2EwEMo_pV-l94m-zuObpKhC2hb-w>
    <xmx:piCpavBeIKdVeu0j8h5FkJi7ms2m6pb9RzR7KCnnekk51XsPuvcRbA>
    <xmx:pyCpaswXJmJy2chSPwK7aUflrlr_ilJw5UxkfOGcWWIEKicpYgcn-w9q>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Sep 2026 06:40:37 -0400 (EDT)
Date: Tue, 15 Sep 2026 11:40:36 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, akpm@linux-foundation.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, 
	usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aqkQSMX6GuXhow-V@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer>
 <aoLkMUtmzRVuv2Hx@thinkstation>
 <aoQ77EcD3M2kjeya@lucifer>
 <0153303d-f9d6-45ea-a276-fbf2e5625ef9@kernel.org>
 <aoXn1B7cPnPq7uxd@thinkstation>
 <25a39c58-a188-4dda-a832-5deff2c8b8c0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25a39c58-a188-4dda-a832-5deff2c8b8c0@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: sg4qbcno58qtxscajuzwgnke5xbaaq8o
X-Rspamd-Queue-Id: D254F40008
X-HE-Tag: 1789468841-156111
X-HE-Meta: U2FsdGVkX1++lc2dur2Jy8n8qDzNW9I34p8IKoYCGxwRyXNrs0BJYDISbysHxGNIw0fqTfBhR1bYrhVMUTVSJ1f8QInFJ84liijkUS7fF7msrndySN+blTIAmbbLhMIJMIdou4RwUTB+XxK4uzVbEHSGOsa3TXIt3xAd5D5JsEMFxPPBEQES90UoqoE/bPOCF6Iftgc6uhB9qvUqbodEw8JCOuN3zYYc1YpPrgznLcK9zhVUPvvs+HvGcZAHaLDeh/rE/cUkDqz2sGqxTwRXtnAMF4+mpl64iqUtk0inMvW45BIYZ6xDU/IcgPbp7Rx01vIkNGz2Z0SBELY1ACjBkojiFjQjLaFcGwDZ2+p9gCHrAV+D5NqtJnAkjnFGH+iLBPONIVwvUXfAPqamuJ8XNwS9ulKgbJTgDEc3q0tID77QD3SE0bNJXknPRHI3pBdTr0h4tIbUkaZbdriveoxr08hhZu/pO9zux2/QWT7Ax67PxUkQenw4t/w5OZ1E7aI6C6bvETBaBQhOS6irf77DC6AAIJAmM7x3LkDrOHHs0KNiJ7Biw9OEhV9WsbMluZrGX0YlR1L0ZhdxjA9xxm4p8pLeMiU2x3spq1K0pzR/qVLVYGP2g96PxMe9mdn/QaOjXIZx2dyZ9iSeD6I48/mywXPwBa2+VPxqirnVxorFid9Sk/nVuXx/Bo4H3UPuyLb3EKl40xrbFhqGTr440GJR3EJ5TYyiIvqtk0o8VR+HgIVpkmhPz9NL+b5qsb4I2IxmcfRB45jFCVGzLRXxDTb32jaunIbM0u6j7KBmdNcNxi1UvDhLzt7RPrTqwH47rOIwmyMxqr970SiQA+g6Ed9SF3dPgIM/e8FbqbbGD9B9hUGqogIjzWlpnnZ+yP4yf6ZmpQ9/6uzn33BqVu60o/nactYgwwbCoUXZhyLKLIwim5wYeYrzWaOt2OyAkUk21aWv2LCnIaxbPL7bJ8nTje8
 D9MnmLM+
 mG/Mk/BrWJVQLP6XEWU24RZAl528K8IKA2FDtF3ZNR4LLup4SA1KcxhAeGkMJorgEmS236XCUg6QnI4+0r2MOYrRlXIGOA39mb0CpsiAUAtS2O24wHxTKTV6/alIhwpfngA4iNyDSICyC4ZyV/K6vojxVvlbReIJThxw+VDKacyh6OFfwXk1uf4QLC9PDwEiJgL/DFf1VWZl3hhw4qUtyBL6haWsZmZkzxIDX9FESAnhqxJErDeH570YwiStN1p/9qIibXpgPO12k+czB+S0/+jlVt183vFQ+LfnEx5W81fRItAeO2Zs2YTLOqBZjIu1FYLAFvMZB6cJ3UzIfcMeeDLXzLPsHCxbfrSxVmvRGDM4LcOwKaSc8fLJesnSxhJoosaFAsE4Ldf6VteFY0eHepr59QekYceUUWTWlg29F20dogxufvn+Cbv9KqTmLI8N+Hj32
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 04:54:06PM +0200, David Hildenbrand (Arm) wrote:
> I saw that you started sending out cleanups, good. :)

Right. I have few more cleanup ideas in the queue, before substantive
changes.

> Nobody can really review 39 patches of RFC.
> 
> Often it's more helpful to propose an overall design idea, and then discuss if
> and how to get there.

Fair.

The overall design one-pager is in comment in mm/collapse.c in 07/57.

I can pull it out, expand and post as RFD if it helpful.

> > Do we want to find file collapse candidates by walking the virtual
> > address space at all?
> 
> In guest_memfd, we recently discussed that we actually would want a mechanism to
> collapse even without walking the VA space .... but maybe guest_memfd is just
> too special, not sure.
> 
> You still need a mmap to identify the candidate file IIRC.

At the moment, yes. But it is not the only option. We can start from
walking inodes for superblocks that opted in for collapse.

> The churn is always the problem.
> 
> Small, controlled increments please.

Ack.

Just to re-iterate what I told Lorenzo: I never intended to push this as
one big patchset. The purpose of the RFC was to demonstrate the end
state I pursue. I am flexible on how we get there.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

