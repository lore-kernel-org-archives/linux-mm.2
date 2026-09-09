Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F14CBC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83A46B0099; Wed,  9 Sep 2026 06:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B116B009E; Wed,  9 Sep 2026 06:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C653B6B009F; Wed,  9 Sep 2026 06:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92D806B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:41:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C0D324017D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:41:48 +0000 (UTC)
X-FDA: 85193883096.07.D189050
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf04.hostedemail.com (Postfix) with ESMTP id D74A34000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:41:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="J bHeijJ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=UHhPoVte;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788950506;
	b=MihpC/lCXojC9oE5E/rpuq/pzuLKj484XztKxM20wpyG0OXY4lPq9cQHy1iStQ6X+X1Q8x
	EVzyM0g9+NeChvI+bU87uEO6qckiw1Aoi/OdDZF8I/R4hBXIXwX6XcTjESmHbB7Wa7lO0+
	SLKP+07gPcWLeCm1nHEY/M7I1FNJfGY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="J bHeijJ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=UHhPoVte;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788950506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqIFoqRiMmH6sRALWBOwhvDCg+hj0QAMm7L7tYbgZ8Q=;
	b=eCfSpuvj1iRyoNNL8YVoYl5iQsPgkJXIInONLFjop3DhaSYT/sX8kS/uQxczsGCXUlLOLt
	/TVf/fj+rWKmPiS+VpqMzVSMQ5albXpqcf7NAzJ9zaZXLtzxVyHYZwBzWlg7O1LKHjW6qk
	ZsOGL7rh9qAwC1ZlB+GLBokIbbeHZAg=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 683B913800A7;
	Wed,  9 Sep 2026 06:41:46 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 09 Sep 2026 06:41:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788950506; x=
	1788957706; bh=kqIFoqRiMmH6sRALWBOwhvDCg+hj0QAMm7L7tYbgZ8Q=; b=J
	bHeijJI8JDTm2/zSH/YR/bRwHqLWQtfEINyG98w7ojO91ZDFr0EgQPEgivHZ+ucu
	sZ6bb8jsQy/iH1D14wd212njyBe0oDLekefyr91l7N3hDysIHIDjCGfrk1O0wDF9
	1bIxhbwvtRVRg7cjm1dCqJoILxbvl/ZnQLjsSwnSdgMOr49AxZAb+xSDiCloNjiX
	4KOKdmL+SoZCiavKfr+Si3ypsY+1nIh7Vm3+nCqdWuNU0T8iN5+4pta6DKrWPQhF
	x2bVqO7H70TnLcPcWSoiXJmmJIk1LpQG+AM+RUm5riGJOAFcqQMlb9Pqhd6ESlK7
	5ucqVuVeVS0m1QUSLbUuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788950506; x=1788957706; bh=kqIFoqRiMmH6sRALWBOwhvDCg+hj0QAMm7L
	7tYbgZ8Q=; b=UHhPoVteWjrexluIKwxpq7gHRP0Yn+xrFc4oCt4es9DSZe6/Dmn
	qZIaERihWm53WQzrF0jT4be0tN+CUWbpOgFMfSfp8k5J+Aqk7YkNacFf67JdVPRx
	SFjcVGgS6ZIgtHlN1FKtyGxnyvm8lM+0GbZM8P5Y2tyUGlxd+/oxHwaohqcSqfUp
	Zj6rG8Z31iw7EEfxR7/jfm8bgAD5XLm8zo/I/+gkdoQY8ipnaQVpF7ylJLbxz7p6
	XBjmvNViWt6breEaFMyjJ5ah0XjA3Q83LBqUomh6dMy/ZwslsCww2axV6Uua21PJ
	N9BXadM+plZ9X8B2MHwc/msFIKxhlmoYd2A==
X-ME-Sender: <xms:6jehasVffBFtqSzdA-ZyeOR8gTnGoBU6FWOZV-RQ5snrsX8IPlLC6g>
    <xme:6jehahTR4zRa-1HpMXSlRSchSB4v6RAeWyayWueVM1xBZPoUl73ljU_0qVgtcvGjW
    WD1xNSp5RpcPFDGidq6G90VZDpp11bvtYX6BgDGKW99aZlC4VN5X8KW>
X-ME-Received: <xmr:6jehardkP3jo5HCLH9-rLNYN-9t2nbkdQRSZIu5utqsQ3k4sigEIGrk2L8g>
X-ME-Proxy-Cause: dmFkZTFtLjv8RYkaq2KOBNDHIDm+JOFoDRz/txBIRtvLfi3jajWftiquSrS7lUz15GDtJw
    ZOsPoBToNQmmrpwX9wEG/IMwctc1l1Wf1Y2SedqlX3vPWZtcpN5ewOiZ61MuL9Ij4Jnfx3
    U9v//DrA1CcVS1qE5MG3ShUl2XBgF8Qcaew1nccOXf0rTqAbaAiI2JpvLYyias9OwsKlYG
    VsbABRmlg2uz3Pv/UHBh4lrmI6JV5VXme4xVA5YQBUZhmlvB7ncMW5ab4sZ0wqYH1bm2TG
    S1/fVkqzOlhjLLx9BGdAp6Bq3hZ1WVQpTicAaqDxCw8vjzBNsONxFItyag/hXfw8lVx4OO
    EiWQctQ3P/1Yxu6/5y8fw3oYORhYCFJKG6DuEYt7dJ8btnp38IOAxjWJEsurEK1fRBek0z
    ztzCjw68d0x2f36ktxCo0MhQGeLaMCNx/gnQZF52aQ8Mlx7YP3RWYVxcqzwqEIruKp/zkF
    OKkmxSrqWuyobb75H+1KOeuVk3n10uFTmMkhcoY3ib9x8bjUSyKMCt48MsCUTKF88VrEbk
    L12cdYBGh4TpHzQ0zzKmgMpY9yBvNv5Zaq5OmRtGLRP2Ix1M3m59F39F/Y+4MYV8XTZ9bn
    hsVdaxTOrKaXZ1VaovGzC6NjKoo2QHgQBevaHeGpILmvpfm15tFUza/k7rew
X-ME-Proxy: <xmx:6jeharUd_xRCJamGUgRjyUgpu--FkUIIlnru2pddbGp75Le0XK8_Jg>
    <xmx:6jehapjNfpB6y9Ak3NdphzJu_O1Eas3uMOK7ZjRRPRVkRWRk9Zxm4w>
    <xmx:6jehahElGdLuV2jqcuOx_gXtqlTde3Z6vk8rtmoSQyCqfUbhgJRDFw>
    <xmx:6jehanIyyuhe4fiUxZMxKtcHZR9pz6Y96OV3YvNzTXBwnPusel_zTw>
    <xmx:6jehannmD6nV_zLTPVSsU0c6aTkow2pnkoJVt7vFCaWM-ftkK-ZceVkh>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Sep 2026 06:41:45 -0400 (EDT)
Date: Wed, 9 Sep 2026 11:41:44 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev, nico.pache@linux.dev, 
	ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, agordeev@linux.ibm.com, 
	jgg@ziepe.ca, leon@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 06/19] selftests/mm: stop khugepaged during the
 MADV_COLLAPSE cases
Message-ID: <aqE3Vq8Go01c1icS@thinkstation>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-7-kirill@shutemov.name>
 <4e064b9d-aea9-485a-8547-3830999cff01@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e064b9d-aea9-485a-8547-3830999cff01@linux.alibaba.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D74A34000A
X-Rspam-User: 
X-Stat-Signature: fgz3m494z46jchnpe68hmcndsb515bga
X-HE-Tag: 1788950506-676906
X-HE-Meta: U2FsdGVkX1/iukXEyYBMShPDN09OuQszbymM+nVo4MQubVw3DQuFYs0PkA65XwgYNVXGYb1V/dg5ig3/hxPhEHbgZSj/6j8iEjaz9Z1/Tnve2sd9hEzW+707ShnTikM3XeuCWt/WleYUhhtMypZIci7EWiUMaQWU0IjDHNzd8VXumY/his96VkVFOwUeBs4iQsJHZt50aEw3XgN5yMGHi0Wlb7BYqK+LjAXovgpd1oI/Nmf+9hn92FpShOCzK00ENPfSieCulqtElrVHB6Epr9VarsezmwyIPFbQF2OG3/KftfFMzYuyL7kVCV7E17t4bXbvPgBvCsY998gRt9OD7vZ1XRqpvCubyy1v+uWbSQHldH3oCUEIBGFe0JXgJk7bT6fTS1IQSZSDQoZwI/sLLxbyeRjk7xSKaRxS6ANsz3LX25LyJcYL35Jkh9UmvlJDvZziViT5fZcXh9fDo/Wn7XjLXaiyjIX/V6ujWt79zVO1y50Kz3/YEYyeNpfCOjkIAe1GuRy/ceNcSLD8GKKGvmotsBL0Fvnn/IxAj1aK/hdZIo7INioFhU/yhVlkzDoP3b0JyyC4rYTfHVyoZXO0Bi23Jyt1z5sBny8cnClBpLGPL4JlSkr2/7ASg/KE5AaANcnM0tJD/w9SgGGDNXQ152ra9DSg35hZ8JvxxcUDauSduFcNN89TJghXuOrfSWKrleZnTeDUzbTNUuz9cuHzvuCct8mWevR7K+qxV7nrAB5YNIJaWQGC2uxHi+HFGuNMu0wkNCuyOFiVrBrRElFUK82EJyv3aVlgD92mk2Fu4CsjCP6I9fSnnrIyqCDAVLYUsSgtpoS7l0mudAEv5j4uJy4+KbCJAQolgUgrFlfPK7cRY43VA1Cr0XEr36OWfSdneY/5Fb3wbOb+tSv9HNOYpfn+i8uzODz1Lvw6trVn7Z0tzXlVlnyiyF7gXh7ZcXgoXJiUUjB+rlruuYlwbgw
 Oz5aRkkx
 7hu+oxB+vY+eLB80F4Y3Xht4T589XnIWVCH92gsAEX4gXj+Y6QEfSsfHu+m7HKT2ocwdMJ5qqbGNOvx7vbjVarxAok9o/zLiVvey3abdB54fbTCabFG/vTxcobqy4hGCYPTgmTDFlrtbOOk2GMT5whiG4Vyxm9WoEpiE/C8vOZbOkv84PveP9BLVhbF8hQi0FVP3DFWi+F8Uridi1TEa9PuDceBIrYw91mwBVjGpW2EVXDBNPNLfRdUyLjahVrZkoUD9Q50YvMQuBGA2yF8v5V8wU84vWVBAczC1igSRIowjrlTHsdG/X+ONkbe65CUfVxCpElirZYEqKSDQxUXHC0PTTJ6q8+Z+P3CUzepXTO/5ezDWSOn98OSC87p6M0YwCVEF3nnGmgMPFGN9JNzv5GgEQk4rv9E22Czze2nbTQwEgATqNQ6LjhMa1LUvJzoeBb4husmZ1pJD6jItvgWBZaCs6wNAsYVn30Qcg3EH3vSPXfvBIybip5nJ/0DnSgAOIL9yk6R0gKCT+P3c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 05:55:01PM +0800, Baolin Wang wrote:
> 
> 
> On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > __madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
> > khugepaged out of the range and to prove MADV_COLLAPSE ignores the setting.
> > It clears the global controls only, which is no longer enough.  A per-order
> > control overrides them, and -s, which makes the cases fault in folios of
> > one order, leaves that order's control at "always".  khugepaged then
> > collapses the very range the case is working on, and the case fails on a
> > collapse that was interfered with rather than refused.
> 
> Right. So I think the correct fix tag is b7f16963efe7 ("mm/khugepaged: run
> khugepaged for all orders"), because before this commit, khugepaged would
> not try to collapse this range since it only checked whether the PMD order
> was suitable for collapse.

Agreed.  The series is in mm-new already; if a respin is needed I will use
that tag.

> > @@ -547,9 +547,16 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
> >   	/*
> >   	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
> >   	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
> > +	 *
> > +	 * "inherit" rather than "never" so that MADV_COLLAPSE on shmem still
> > +	 * finds an order to build.
> >   	 */
> >   	settings.thp_enabled = THP_NEVER;
> >   	settings.shmem_enabled = SHMEM_NEVER;
> > +	for (i = 0; i < NR_ORDERS; i++) {
> > +		settings.hugepages[i].enabled = THP_INHERIT;
> > +		settings.shmem_hugepages[i].enabled = SHMEM_INHERIT;
> > +	}
> 
> This looks like a workaround to me. Shouldn't we fix this in shmem instead?

Good point.

It can be a follow-up patch.  Do you want to make a proper shmem.c fix
and update the selftest along with it?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

