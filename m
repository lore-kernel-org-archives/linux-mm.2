Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D6D5EA8100
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 11:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAB646B0005; Tue, 10 Feb 2026 06:56:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58356B0088; Tue, 10 Feb 2026 06:56:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3A266B0089; Tue, 10 Feb 2026 06:56:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F20A6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 06:56:14 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39E1B1A04CC
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:56:14 +0000 (UTC)
X-FDA: 84428393868.10.85FA6D4
Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	by imf30.hostedemail.com (Postfix) with ESMTP id 33A868000D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:56:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="i fsyODX";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=m1eu0+1t;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770724572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7OGNsJbKZkIwzInHqy4lEDiFAkNIOQjQRF1xnBL5Q7g=;
	b=Obj5NM7yjjNoebn9zRSEQAY/0nn51R6tFstf460GRqhNlxyewcq17D56iCva6HHOgiip/y
	XUPtdsM8HUoTNwVyhkQ6v9xlkkcQbVsWGwWHHXW5MzIJsndRN4gNIaFmZjyjIHoMPIX186
	st4OybXyQyyXA/u3wF9OA1jBa2xfaAA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="i fsyODX";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=m1eu0+1t;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770724572; a=rsa-sha256;
	cv=none;
	b=v4K75n709LJWo0nJZ1bKmxBcAZVLA3UhNqTRoZV6Je/aZwrFz2lFpxK1tKyU4dGXz1uGqJ
	GMoqFxsxUtemcJvv81MvRlD76zjRKu05qLvNxkukTEdCTFOcUd/wkF9yRvIcecamc5BHwG
	E+KRAnSUMKiDiyki9ncsYKT3zlDKgX8=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 89ECD1380AEF;
	Tue, 10 Feb 2026 06:56:11 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 10 Feb 2026 06:56:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1770724571; x=
	1770731771; bh=7OGNsJbKZkIwzInHqy4lEDiFAkNIOQjQRF1xnBL5Q7g=; b=i
	fsyODXDd0bNNkWf46UvB3kM1dlqAhZdqXTmST6vBg96LZambuf+WsTf2fu7V0EaS
	U1Vg6fABiIYDzXQhxwpeEGS0569yZRu04hOSgbYwODvkafDzKc5scfHbQl9V3RaQ
	K1er3oI0VHtnyJdboJrf2qM+crj386eSUDENW/wE7oPhSmkJd/VyzJM8/QvZre3X
	tSbE9jgfcDfadXLLYn16G3BqRgm72Ik+ymjCGIO+CES7W2UYYJF9zIoUNGh0jgzZ
	HtmDQxJ8TlSXh/iTYlmy4gFTwj74RIXCIu3QqLLD6wfvRW7+oVmfGHQF5aMpP7nO
	pLXKIKvgah5rT4Wv6ZBGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1770724571; x=1770731771; bh=7OGNsJbKZkIwzInHqy4lEDiFAkNIOQjQRF1
	xnBL5Q7g=; b=m1eu0+1t8dvxUlr3Yh86OyZAQIVh3f+Lz031yVhJes9vgQ2viJR
	nYdFCQA7FduAvnbzM4QpVEna0cdykPFLp8N0/SOxBPtG2J0lYNneDJNrux+KqYFw
	lnsZTQ6ZBAJWUGCxnHBYRkoIoHwCi1PtFiUlb72s6INU8b6xX06iZ29PHya8ZdR9
	63mBZrsMx6g7iKU/LyOTVtCVtB+ZWVuXFdiXf82kuHQcHfMUEuWWy7qByBqPwQ2j
	2mehtN9ATlxFk0uy6RWnUGVHPn0JCiV25PvgCRikv/M5CUXrnKAXNvR0cyUXqUkb
	/N+j+JkGIS+O7iHE9yCL4FLTOj/qhVPp+uw==
X-ME-Sender: <xms:2xyLaVpHT6f3pEbGW9P_DcY5O4kzbyMCWjRo--vW5HzsRm0eFJD-ew>
    <xme:2xyLaSLlj_T7HOrKjMSR4jYdCj3SKa1GCisI8cd6tMmQk68WOHyy8C83MxvlSVfeC
    -sb3PpB91sul_5ybW6fkBZyHnn5E3GYOToY9G3RhStxzq3g_C9ye4Cu>
X-ME-Received: <xmr:2xyLafK4nmaOTJTsLUIsD_NYVzjwDzeLq1Hb5yxvdnuTdsx8gYzXDPHvqtlVaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduleelieduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhgrohifvghntghhrghovddvse
    hgmhgrihhlrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurght
    ihhonhdrohhrghdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgtphht
    thhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvh
    gsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepmh
    hhohgtkhhosehsuhhsvgdrtghomh
X-ME-Proxy: <xmx:2xyLaTnyQsK0sm642iabechfEwDCiWsrFNf8q6qM_fBaDyRIRRtmhA>
    <xmx:2xyLadKbamvYv53WGHDATOcECz-44bOWoOpOV8m57fylkOnUiI4g5w>
    <xmx:2xyLaWVbM1xAo21FFffhm2We6qguNSepDekmi79WQb14Xii3rvqCbA>
    <xmx:2xyLaaMgzjRz7e5MXzJfvdm6gmK24-oTfE7SelZI_7xljDEkQ_gjbw>
    <xmx:2xyLab8u2Tiq6giB_tfOIRtn2ZI_43ba_NAqZkw9qOYA3WZdonFohbUZ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Feb 2026 06:56:09 -0500 (EST)
Date: Tue, 10 Feb 2026 11:56:04 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in
 do_anonymous_page
Message-ID: <aYsaUOWxujne6_RP@thinkstation>
References: <20260210043456.2137482-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210043456.2137482-1-haowenchao22@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 33A868000D
X-Rspamd-Server: rspam07
X-Stat-Signature: xk8umc6dwwa8tfse4zw1jj8jg7dzqoez
X-HE-Tag: 1770724572-446534
X-HE-Meta: U2FsdGVkX1/LbPyzrixoTsJatBX3jNizyO7RuStodTKSPkFlRGXoJDUhbkjxjEo+oefZE9wxyWJFLXOtssbkvDQBwxJbv2/AcDtDVzS+kFVgyfYLlepRvn5kbY8wGfyY75u4T0xZSu8stts4V3fbnG2+I4tp7RDZW+nXuCYIPCYE6g/Y/VAk7rHUgs4V6GX75J+YVqcpl8Pbyk68OLLRlUbvu+kYjdf1Wr3DbYD8osXLNZKD20gwNp8DcxYP5nkfOS8Erjoat7lWJl7wGv+6tcqMPhgt08a0PlKKh/vRVMdUhARAG8hmP6vcVX8Sv6xRGo84Ej8If/o4fDMm82dHRA6n+57kqI+3zuG6AXJEuw2cgsiiaLuFq63AGs3Pew1yOepQ0RSat6OnmQN1Ms97s+d3D7Q0bb7qvN/logqNX4Y8ToBOZ0BQAXil/NuYYgwHKYD7jGH5rFa9R07fQ6yPNLpU9/97OvqVMO60q7J1OllPVVUGbt1Dntf5jUKkmg76EqaT1mC7KymxSqCVLrbKI0sq0bVtbXRlKF30easak+66Szoaci+u4oAk3YTCzZ0/RZpmYI+5hZihjmz6BfGwJeIknxj6w22vcjGRf8AwkzPJ1+SfAHP+Q0pVitqtZK8V6+3m0me/bDxzrWnt2KiPUb93UM+v1jOXs49nD9KB9WFKxwLkfAM0r6cGknFfUuLSXoXTp2fVz4GLCEmE2j3vnhAopOiSLBMCzTRMen9Bsd1y190kZHCIYfV5jtRxZdJSF0wcDzAhcakONTHvtTdDCoZV/4ZDpDWwcNe/WDpfdThfjfaQ0jyZhM85dg8ff64azMEpea5atNo1LduShb8mMjiojfB2geuzX3mHgWx9nyIGyCh+hAGN0ZWcQUVDM7AyeM4RVLo7K8zi+1DNvVcNUYdTfKLidAgVFLbtddrveO3J8A+V2o+SMAizZLJpB+asf4jWdTIVDsDJVIRT/E/
 qWUswgA6
 OAPtobZCpnOm5xap+EaE8vFU5f2xMZLezP/Ht5zKisI6wRh+nPDb5M70N4EpLbQhyo4Pq9vihxs+qE+mGerYemQctE9zd7/ScVG2QiSgYuOB8DHGPHtlv15fDK2JSUJY7uHV879eIiPW7jtxsMiIxWQ4qa8g4LCPEvP2V+NBOTxHW/4DqGHXoqR2jkHOgeBJF7Z+JvboztJxgfjG+1UyG3tDg8whaaHzc3gslf+xJbzrYGkkJEMfKvsOBudfhA744MF7kiAR3nh9hNOSCn3xIFsvnTFkgVfniiXSWpGwXZFo1qjvkvZFPq+91fFMNvrekydDOY1+RcwC3HP9VLNg81E/bYRO7uQBo4IH4gtE9KzOxuf3RxTonGh2IahapaQempB0yrsCmuz7WHAvxBP1i/woUPmSJK/oBp+G99YoVZIgFAqO9EtVMYcF7QhVrlUCpF+mqXDl9IyvmXJaoVuZxWj9g2P3ok9vLjvE5/bKPL4xV2b8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 12:34:56PM +0800, Wenchao Hao wrote:
> When do_anonymous_page() creates mappings for huge pages, it currently sets
> the access bit for all mapped PTEs (Page Table Entries) by default.
> 
> This causes an issue where the Referenced field in /proc/pid/smaps cannot
> distinguish whether a page was actually accessed.
> 
> So here introduces a new interface, set_anon_ptes(), which only sets the
> access bit for the PTE corresponding to the faulting address. This allows
> accurate tracking of page access status in /proc/pid/smaps before memory
> reclaim scan the folios.
> 
> During memory reclaim: folio_referenced() checks and clears the access bits
> of PTEs, rmap verifies all PTEs under a folio. If any PTE mapped subpage of
> folio has access bit set, the folio is retained during reclaim. So only
> set the access bit for the faulting PTE in do_anonymous_page() is safe, as
> it does not interfere with reclaim decisions.

We had similar discussion about faultaround and briefly made it produce
old ptes, but it caused performance regression as old ptes require
additional pagewalk to set accessed bit on touch. It got reverted,
but arch can opt-in for setting up old ptes for non-fault address.

See commits:

5c0a85fad949 ("mm: make faultaround produce old ptes")
315d09bf30c2 ("Revert "mm: make faultaround produce old ptes"")
46bdb4277f98 ("mm: Allow architectures to request 'old' entries when prefaulting")

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

