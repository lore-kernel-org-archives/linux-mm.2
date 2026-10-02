Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 153D0CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 10:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D050D6B008C; Fri,  2 Oct 2026 06:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8E6F6B0092; Fri,  2 Oct 2026 06:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B563C6B0093; Fri,  2 Oct 2026 06:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE816B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:59:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F25A640677
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:59:13 +0000 (UTC)
X-FDA: 85277389386.30.D758FC9
Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	by imf09.hostedemail.com (Postfix) with ESMTP id 28C8D140008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:59:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ik1FTbeg;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.99 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790938752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4GHouJUETudk7W8FKV7BoRzP5pX7CtTfk1pyabxXaf8=;
	b=v7G6J9f3dmTWzzcCN4Stcd6BSJxxYdjo9O2Atfq1QGClS2iYoaHZTcJp4zNTJLetJj7W27
	KpamE3ycEbBM+3nnc7scmfb9NeOKPjPMqz2k/Pk94Dn5wSGQ224/IQcmt+wI3QriwSo4Rh
	XZHOZyRPcYkF/QXOee9WFLBK2mlutIk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ik1FTbeg;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.99 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790938752;
	b=gK7QB4GPL6T15VrK0GyeRWS/PUtbXVRZMrIlORRO7nAnQpkRT6eirDMuvIPcXyt/p9YPCN
	q3ucfYvP0Q4aXoidgbalD23HnBYjxqRJ/K9eqV02jLDgi3FyogGzBwUII54FdwYhBejx9y
	+GnHvoAJ5ok9x7o09VrsX3hLQv5eBbo=
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48b09f6bbe8so1049449f8f.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 03:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790938750; x=1791543550; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4GHouJUETudk7W8FKV7BoRzP5pX7CtTfk1pyabxXaf8=;
        b=ik1FTbegFDjGpoTo2XEa72/T5qDFoGKyBDfO0N90KfAt40MRInABjamBUocts0azpq
         u5/rxtD/DOJ01TWV37kYPFzCcVET7rnzKssQZUf453fvNucEZZtEWqBeZJDp09NJGrOE
         R5qzdFIUtkMrsveaHT4YuAau2mZGOpnkKtsyPuZmKafkaG8ENO7llyueKYzRw8DdrK7m
         No0oOuooda1V7kXDiLK/tIuKwahoP9V8Tx3HUsF5i+3FmYKGuTNBGzRD6gLwAPnS90uK
         lH6TYsnvBLEf8c8LArSDQ7652v9TV94AMf9aZ9L702sebajiZRiHHzgLSCxFBMYrlttL
         vlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790938750; x=1791543550;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4GHouJUETudk7W8FKV7BoRzP5pX7CtTfk1pyabxXaf8=;
        b=VCRN7Z6Y/+mVeSolDJf58q/CfI/gf/hUyAG+mhk5MHTkajEd1XoQL5gEIhSVPl/wBA
         Tt1NRQTtd7asQTU21qx9OMs79tdsu3xqZInpmdAXeTQnVcENo1tB5/ErJqCL0yBOyqSs
         jWUHpe+d4LZh2bEIGb6aKek97gVeDpIt1WmLQwxv7U5nsBgSoIyvQNeNVKq9w9F6qVoi
         h44TDbiQl3lhuv7+3TCfGd0A9J78iXziY7f3qvOSz7KjJD3XsyfzIvbve6G76BYqyODI
         LdI2GDqRaO6845fT5EyD424UaAXZn3pBHGW2gyhVvPLLakaDstwvXmuszxWHuF6ZXnB6
         KHag==
X-Gm-Message-State: AFuF++nkYjZsInJShnMlp92BEVY5KY+nDaGAL+YDmXFnhmbJXGIGguvN
	EdDIyalRTId9DqTN5e7u0BoCqRO0sUQYP8YD4/ST+whz/iZ/1WDTkWVmcPziUnefiJM=
X-Gm-Gg: AYBFou2lRe/KMBojPZDH8HfSU776bQMBH+6wVceQ/W2TB8bPMe7lVZaLG/UPdmeYAA0
	rUqZiJOQAQRoiRLy0hphNtSRJBr9OzTMSaFtnmjIIGGyBGITvM38b9O4f9aEXsEvLTFMsenievR
	3o4Q0HVqeFeQasg0J8W53wrcpjVn4b4oMZ+W4BontW8cWeMOMhZ+zFIVjhzyYXgukyAB+oo/pEr
	JsiQ6Nf9hKe5cKwUx1aIYfPUEeiCfUG4QtPWBb4z7mV44Kz8vT5tbZ1XVRviqh87XZIee4aBYu3
	H9SCuW7skytVGNWtTMly0jRSCrYEn0TaXDrfqinpmhR9oc7w/X6K+GbqZ49hd17Ds7wvNc5PUVb
	0dAbEq7c+/07cTG1hnd1iXArdQiKgcaQYq0dAD2ZHm01KL7RJAGH06lAy890W97WXUOYOmgO6nY
	V0GddE8yA9lPrcGaUohjOyAD6Ls4g1ptFyb98iqDf9gkEdz36vw2HCV2SSULt6ddH1jVE=
X-Received: by 2002:a05:600c:4ecf:b0:49f:cbf1:e765 with SMTP id 5b1f17b1804b1-4a027458e05mr46243305e9.0.1790938750421;
        Fri, 02 Oct 2026 03:59:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::6:adcb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b38104d64sm4717627f8f.29.2026.10.02.03.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 03:59:09 -0700 (PDT)
Date: Fri, 2 Oct 2026 06:59:08 -0400
From: Gregory Price <gourry@gourry.net>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, rppt@kernel.org, baolin.wang@linux.alibaba.com, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
Subject: Re: [PATCH] mm/page_alloc: let the bulk and folio allocators carry
 alloc_flags
Message-ID: <ar-OLuvDxoCXXKh8@gourry-fedora-PF4VCD3F>
References: <20260914155115.439742-1-gourry@gourry.net>
 <aqgjUJWVUS_nx20i@gourry-fedora-PF4VCD3F>
 <DLUANOHBUP9C.14W0G57BHYIMF@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLUANOHBUP9C.14W0G57BHYIMF@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 28C8D140008
X-Rspam-User: 
X-Stat-Signature: uaueyiujs6zrt3a15hn3eqqadqrck84s
X-HE-Tag: 1790938751-233195
X-HE-Meta: U2FsdGVkX1/xBtFJXFWQWDx+QgXllW3ewJV4a484L/Wn7/9XPeq1rnNCtnUsvTZ2zngv0WAPVZskdBdyMow9nftPqxcWzPLjdkqQi/07HAfpKb8Y7h4rufU8p3P2AWBn4mUYf5MGu8jWB0RyFVut0GXIK0ytljBHboX+GfSBGFXu8DSBmPgkw56mJNoji166b3vhsjkX3+K2UF172kol23o83dedyapphyZewVQ46IN0o0Fr1yguoJE8R1VgLY3ZpA/kp1/HbkHsAFSBl3N4B9wH5xKdZnfU9Z7yrsn3degrvbqTtJMb4fciykn5NirHYetQJx+gdvxiNgaePlilPaYEb223kpHwC9+PzMLAr7gKctebo6pj2ZjCrSiCtmlVxtuEvC30BtAu306sWlQadwJl3srEwUwT1Po74hto9gShDiShrfZfxvZmLarF4DM2e6jng/S4oROoY4rPezzA75UbZZw6bX3JwHzeDDtX8HOLT+UI4r/v2X5WkMNsXKOLIgE2apurzLxFxBqusW/Gqrg3byrZohwugD9UHtkp2tOcQn0HKtFtuZpgbMLTdeYTdv3Ie+xl6YsgNdxjEGoM+0w/nar0cmnxOVH0zg/Cse32RxMBsJ/Lt3x7N9rfZn563P2/Q9IusRvzMPhCHCzPJ27Ual4AyMANd5ercU10M6TsEjLA8/FJnuar812IO/39QyI6ALCSF2YxvDJSgA9qXGWvG+sFAXdJmHfHmzO7BIZO0BDXDUpTNCYMK1w0mVhMl+EIy9XTYyf5gr8Y5MQD5JACU0b2NhXbpPjgR7/sCL+fDJDqEAW8UyJJ81VxvmA4mR+b3PEaoGy6ZlWvRZgbOA4b41Q9wnsZLdBW318o3JznmefunCc7HV8DX2Q41Bg/TW8ErD1Rb57Yg9ri75w4zTLELCM2K3K1Dp6mb311AlFUCF0Sr/kbuZEKJX9RSsW/cu3mVtY5Gnhosdz9nyE
 FMw7pXXU
 +oaQ5s7ohjv1CTF9FIDyHTAw89b/3TexaKy4qkP2xoYpbrN6Rll5Wkaf13ahk03uQgTRU+s4SKN86o4BRmtRMzRkNr1N7Whlp5mNZhFYnSORXd+YCo8fbR02OL8JACKjrP54q27UssRNmc0LmsJTiZ1GSfPNsjtrzrmYm/NP7z9UszFt6MMsb1TsFuw4dHMcyujBvkT7LmNe6keyNeWojfOwrj7hSKAFqbcarNwpif04U7iNsJ5n8bzzg4qix3DOGgsH5de6KUmkA+BIh/vPLX7rMViOezehlX1O/yoK7RuPU7j92wwD3/CBFpXV15Cqwcs8wTlxDg0rND8XBFRwwRSys2l0XYQZOyNLakxLWJMDb6yYDeQGIUp0GDd1ZzGeF4yYv+G2iCog9hcqt/nPZtfuff6YaiOzEbu5B9NluoTYycPeEZIB+uHJRyP2aPoNuZt6mUyuDQGf2E1yhbCKo7NNtnvu9W+oY8akgyBIGW5dMsKHwBKHtDOx6xSlylOU3xC14LWcLdzKc+xmHa2HQW6JIkPaH1CppKyvq68hnf4NuwVlIzWeTWIGfGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 11:52:22AM +0100, Brendan Jackman wrote:
> On Mon Sep 14, 2026 at 5:54 PM BST, Gregory Price wrote:
> >> Brendan this will conflict mildly with your ALLOC_UNMAPPED work,
> >> because you add an init_alloc_flags call in alloc_pages_bulk_noprof :
> >> https://lore.kernel.org/linux-mm/20260726-page_alloc-unmapped-v3-20-6f5729aa9832@google.com/
> >> 
> >> I wanted to pull this out ahead to try to deal with the conflict.
> >> 
> >
> > Sashiko pointed out some issues that arise from rebasing on the recent
> > ALLOC_NOLOCK work, and in a quick review I found a similar slow-path
> > fallback issue with the NOBLOCK patch separate of this patch.
> >
> > Brendan, if you're alright with it, can I pull the NOBLOCK patch out
> > ahead into a 2-commit series and I'll add the small fixups?
> 
> Hey, sorry about the silence I let LKML pile up rather badly, it's been
> quite a month..
> 
> Yes I am totally alright with this (glad to see you went ahead).

See: https://lore.kernel.org/linux-mm/20260923211041.3127588-1-gourry@gourry.net/

for the RFC that pulls everything out ahead.

I figured out how to make-do without it for the first go-around of
private nodes, but it would still be needed (in some form) if mempolicy
support makes its way into the private nodes series in the future - so i
think we should still discuss it.

~Gregory

