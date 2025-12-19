Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F2ADD78783
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 14:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23036B0088; Fri, 19 Dec 2025 09:50:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D05E6B0089; Fri, 19 Dec 2025 09:50:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1CD6B008A; Fri, 19 Dec 2025 09:50:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79E3D6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:50:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0771F87203
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:50:24 +0000 (UTC)
X-FDA: 84236506368.12.C1F6CAC
Received: from flow-a5-smtp.messagingengine.com (flow-a5-smtp.messagingengine.com [103.168.172.140])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0A55FC000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:50:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Q xHVlmW";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=smxfX5fT;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766155822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoMb6UKImNIuiM4dbTUrAuWjnzBkUKyk4bZM/Nf+U3c=;
	b=8igR3kF8dOkATgmNTDvtodAVFhbwi7oBObbftxRxfBgesNibpZog0VIihZGcDAG1AyiWIs
	oUEqLauTd/iBW1CPIB2h+uO3qtWxwSWvbAnrPx6XzLtft8ZVZDzqRzvdsNpJC0XA8ChQJe
	cBNgrNO2oya1qs4EnWBX9ROZl0ZdjSM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766155822; a=rsa-sha256;
	cv=none;
	b=A22phh/AReg898Z95Jm5iuX78Ec+Re5do2yAGnDTg+mV1kiilcwoV+h0dQ7DvI+UIz9Fkg
	3DP+Ds3bi2VwTNAxK/GxAPToArznpJPj7qdAPY1Bgob6xOdSMlHiSs0QpQY69f8iLdouHg
	ECr5UNIAfFpskttcIihRXDbTLNn2xv8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Q xHVlmW";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=smxfX5fT;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.phl.internal (Postfix) with ESMTP id 262BB13800EC;
	Fri, 19 Dec 2025 09:50:21 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Fri, 19 Dec 2025 09:50:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1766155821; x=
	1766163021; bh=eoMb6UKImNIuiM4dbTUrAuWjnzBkUKyk4bZM/Nf+U3c=; b=Q
	xHVlmWh6l6hH8fAI19X6QsngOW4cJYnTycUy5k/cZvGc9Gh3+yi07bIVMjRkYOIM
	pgMfdpERPEAOiGw29F+aMJ1sYj8BktK89SDzais1X2zCJMwRdjahHOTAnfdy99xS
	L3BrctR3gCBnHmdsqc973LIfs5ea4DjxQZFELQN7m2bEQsI1MDacVwYmU3YZEzm1
	xTDMYHUuXJkcYfxzIiUbDw7wcFnbjtvBYGoL4hV3YcAqz5S1tG8P1WO2yzhG447X
	84eff5BSKhNmwrF8bne2wDp5yZHnob7m0W7bLDBqk/j2O0R6bUdzGVjd6g4FTUIR
	i8sFXI8howTklWraLRZ+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1766155821; x=1766163021; bh=eoMb6UKImNIuiM4dbTUrAuWjnzBkUKyk4bZ
	M/Nf+U3c=; b=smxfX5fTf3GGw+zTCc9Q8Jwj56SaiV5rZINsQEgQYo43vLzwYo2
	7B++A5IibDuyo2cmzyY1Telt65bjYArPQ2YbKP0NULHv9jVUNb6FcYb+k7PORzfB
	Z6P5Uqiz8TAs0Z+p4vm1DaW30M1lydL1ZgTn1ofshIceboEgDQAxhfVKKXsY7+0w
	uPQ5LRKg1DqKWlIrYuNGtLMaARsTwzXrtNXw4iBgerVD05lgSK9h1QIaB5E7bwdr
	RZAfHY5MS3dI1dtM/OTPCwZHOXbiox+qcEeDtjmMbFwttKAyUZuwYDPLsm/D/kXe
	hHiuzpVXUabsmdMq1UgOmlcqmYAKvc/0y/Q==
X-ME-Sender: <xms:K2ZFabx2awBVrkn2GdPv0JFbPL_4SjVA_8xYPq4ozN1IRhgReyMatA>
    <xme:K2ZFaWWBAz-3fcKzJs2zEWapnPjyWdjRieezihufHkhBoiwIOUwNLLGj_Jd5Rv8uM
    c8J_gqXNdWNi4rFz7ZHUQFqd7r4F07PBdBA4Pt_uEMtFE_k1T3uwGc>
X-ME-Received: <xmr:K2ZFaTb69sywFdeAXlOQOzI63VREBzojGc20YRhljaRX3iEae7rDq0EhZBsIfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegkeehkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepheeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehglhgrugihshhhvghvrdhilhihrg
    dusehhqdhprghrthhnvghrshdrtghomhdprhgtphhtthhopehprghttghhfihorhhksehh
    uhgrfigvihdrtghomhdprhgtphhtthhopehguhhohhgrnhhjuhhnsehhuhgrfigvihdrtg
    homhdprhgtphhtthhopeifrghnghhkvghfvghnghdrfigrnhhgsehhuhgrfigvihdrtgho
    mhdprhgtphhtthhopeifvghihihonhhgjhhunhdusehhuhgrfigvihdrtghomhdprhgtph
    htthhopeihuhhsohhnghhpihhngheshhhurgifvghirdgtohhmpdhrtghpthhtoheplhgv
    ihhjihhtrghngheshhhurgifvghirdgtohhmpdhrtghpthhtoheprghrthgvmhdrkhhuii
    hinheshhhurgifvghirdgtohhmpdhrtghpthhtohepshhtvghprghnohhvrdgrnhgrthho
    lhihsehhuhgrfigvihdrtghomh
X-ME-Proxy: <xmx:K2ZFaY9NBU5bAUrymiTf8XoK3wgGAx9D86I7N-p6O7o27aDppwJKrQ>
    <xmx:K2ZFaTKsTe_TmsfH9ebieE6f2Le4AytPT3523CVfJZl12Y7tVCyHRw>
    <xmx:K2ZFabseFNTwnylvYbUiyDu5QepaDg4sNIc18JYr4X1ZMZD1loy6bg>
    <xmx:K2ZFaXkIeFVz58gWFSzGXNy8uVg3omNPqQgHMc2MVGg7-GimuB1MXA>
    <xmx:LWZFaVmxKppwDFux5dM2-kPAM9DGvLJScCC9PRhqZ0y6JAACZdRKnPZb>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Dec 2025 09:50:18 -0500 (EST)
Date: Fri, 19 Dec 2025 14:50:17 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Cc: patchwork@huawei.com, guohanjun@huawei.com, wangkefeng.wang@huawei.com, 
	weiyongjun1@huawei.com, yusongping@huawei.com, leijitang@huawei.com, 
	artem.kuzin@huawei.com, stepanov.anatoly@huawei.com, alexander.grubnikov@huawei.com, 
	gorbunov.ivan@h-partners.com, akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, yuzhao@google.com, baolin.wang@linux.alibaba.com, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] mm: implement page refcount locking via
 dedicated bit
Message-ID: <iv7m5rmuwssltl6yzwuop3ry5s4l653lykyvrmmy6qdbyyuoew@th5xuev3mwus>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
 <81e3c45f49bdac231e831ec7ba09ef42fbb77930.1766145604.git.gladyshev.ilya1@h-partners.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81e3c45f49bdac231e831ec7ba09ef42fbb77930.1766145604.git.gladyshev.ilya1@h-partners.com>
X-Stat-Signature: m4xhpraj7f3sqj31c7i5he99bjn4ur15
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A55FC000C
X-Rspam-User: 
X-HE-Tag: 1766155821-590832
X-HE-Meta: U2FsdGVkX1+Am5pmOJh/UAK/qkcWJctkYyJlSs/qlSB+XumyFD8Xrrp1WitJwFAFKKT2G3FJAt48QoDeN/vqjAf137tklkBr+rxDi1ke8nFKlB5elqrOx/YTbAntOdqhYp+VjcYaH70mLWzUHHmN5VH0+WoIyWWAbmzMvtYZGzr54LqHHMhjN00CTw1PkAQKYKPuPQNCpkFpxSFsgKSrfP5OHaCpIMTBbDVoK/rCh3z0RoqVBtDrk7FsNsQePQaZTHFpqqea1IVkWkNy91qNWXv97qGfzOactrGjPkcI4GpvQTflUREnG3IlfdQFKmMqWa8AUr+VvzUZjPJaZOs4fTILNFiOIqY0c8RHDL4pTQdSsuzHWbjD/wDdFOs7qMSxA0j7DKMefzbq2H/clVFQuhZh76IIeUA7MYdCQQZsIuaVkHOa2xA/Z97cDZaYYVkshc4SrAgj5A7Y46LAnBRC11QwEcstFFzX6AvEixDVV0NRw2Vl5OWRnUmYyPwHn2okU+bJKDM88iDdABLBE5SzGNp4Ue4qMAPIXMiy8VMDth3ruQRXqLNyCoQxSYFJp366KobEWMhLSctfmbOn8hgWZ8CyN+CftApzcBgpFxziwucNRjOyZFYAruVQ3SL2S/yB+mwXH3aX4CTFwppJ4OgNh3J3rVV259wFRstsWSDBIPMS//ERBPt+ltBddJOo9sV1k9nmRpgv7F2bXSa2GBEoc+zHLCixDRAeS7fn1vj5PfboK9RRzlkfP6o3yUilvcK4ImklSOhsuS/WyhFV1VXwjTs3eVl+pHq9ZI3ux1vmuVDWDGkJfnEw4sKDibaQxP+XvzZ/xq5ff8gg26Qiz/EAnemrVXEa+HzwOYszUHmqxRsRV8KzWDbyZ80FiHl/KuQtJzjJ89aIkkC6HI5z7c+h+V4qSPBGuhc3WcQK2MZPPauWfn7GIi/V/3p5v42G4fBGx8FTiO8nss+gnDNvZUT
 NmZ43KfV
 8HgHFINBZQJhFrnKNUu6SUJ0ZqVP5fKEJXwyTTIa8sNP16eC+YoaN5d/xNsHf/2EPY5O49m/oIWqJ6b3KJO2O7FhLvUhAfpCX+XjrDTAnCCqUnsdGINPV9qHbtpvVsGS5HXk/TuLjYRjmtKJ5QluawzAwb8zjYD4hCIDm1CLD9V7Z5IRuzi8ALcnIfvTGDfi7V/Nhm1kU7lLHIPl8AXdF5SO4e68fs0LU/q03OqGfMNvNk0/c1gSC+rFSEVAIdyJowcasVx3EItHP7XR1SNhIK9dILt4fhPvSftJubi4zqMsMFUDVTewXtygJ5HkDXjRuk8mST0JV5b8PSw+wI50fendf3jzV7GHTYSDCwMCPDeEr+cUsgcbwTqR1SVkxqV6EjagdXZEzJreWTf8/93zCzBm2m9aqKzbVlqFNKqBfsSEZbRaCFF3enAHws9ruZwROKzBI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 12:46:39PM +0000, Gladyshev Ilya wrote:
> The current atomic-based page refcount implementation treats zero
> counter as dead and requires a compare-and-swap loop in folio_try_get()
> to prevent incrementing a dead refcount. This CAS loop acts as a
> serialization point and can become a significant bottleneck during
> high-frequency file read operations.
> 
> This patch introduces FOLIO_LOCKED_BIT to distinguish between a

s/FOLIO_LOCKED_BIT/PAGEREF_LOCKED_BIT/

> (temporary) zero refcount and a locked (dead/frozen) state. Because now
> incrementing counter doesn't affect it's locked/unlocked state, it is
> possible to use an optimistic atomic_fetch_add() in
> page_ref_add_unless_zero() that operates independently of the locked bit.
> The locked state is handled after the increment attempt, eliminating the
> need for the CAS loop.

I don't think I follow.

Your trick with the PAGEREF_LOCKED_BIT helps with serialization against
page_ref_freeze(), but I don't think it does anything to serialize
against freeing the page under you.

Like, if the page in the process of freeing, page allocator sets its
refcount to zero and your version of page_ref_add_unless_zero()
successfully acquirees reference for the freed page.

How is it safe?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

