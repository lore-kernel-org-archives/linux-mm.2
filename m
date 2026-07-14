Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7847C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 11:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1B86B0005; Tue, 14 Jul 2026 07:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62406B0088; Tue, 14 Jul 2026 07:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B1B6B008A; Tue, 14 Jul 2026 07:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BFD36B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:14:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2FFB4037F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:14:44 +0000 (UTC)
X-FDA: 84987124488.27.3386AA4
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id 560C8C0007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:14:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=r3eOE4fp;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784027683;
	b=SbofEO0nUGKJdJ9CH8TFeWv0QfcIf4XSHkKWMb0vXVT1CGhyC23sdkR58xHeh+DlGemBf9
	K6BYSdkPpgz+LGCTRdYEAXfOOADRp4H0p+nU6ejpsq3wNrtf4rIgWzLpC/sTXBYd6BK2tM
	DI2tI1GrJUtGkCo1hFUeupIXEVEod/k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=r3eOE4fp;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784027683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulsCzZmD/Ne6RgfHVzpkXYONsVEio5AgXncvWtdl/7U=;
	b=636+Z5hf9HjkQqLn0lu7/FKvmW7TDCp6rOr4qGufd4XKjp+y6FPk+WcsWczZnX/0Q2ct5R
	u1b9eL/XONDXSmtQOyL6WPShOlS0i/RgGFcTrPK6AqSuPeJESlUfRzzs07LBrRVff97Y8K
	rbw9meginTZ2qNdmZ33ne0fRyCKJasY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ulsCzZmD/Ne6RgfHVzpkXYONsVEio5AgXncvWtdl/7U=; b=r3eOE4fpb78xRcyeCxL4DOMJQn
	7tAqieKm9NgJPfkVLMq97THSpB7+T5apxzKyp/sLnFuqu+wtz2q+OoFa+ZQy+DT0YtSY9l+yaMO+M
	vzApCEvAtUCv2uiMV36WE7rsrvlghWw0Jfkfix01V6HZ1EA886m1+Y0JCiiSCmX261rsjT1eHgHc9
	MQY0QNbme1GkI0NthyL6abUnwh1vi6gYCZjVq5rEDTzySdjvhgHu4nTSBTtPpq579JlP2/mx+lHfk
	z7+MBRk6yz9JuRiOcIFRFqY1sfw3t74RzqjXKFIU+Az/2aZWuBhHocDmZ2t8NNevlBj/+AUg0cN2G
	FeI29+tQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjb5w-002EbI-1N;
	Tue, 14 Jul 2026 11:14:36 +0000
Date: Tue, 14 Jul 2026 04:14:32 -0700
From: Breno Leitao <leitao@debian.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: osalvador@suse.de, avid@kernel.org, linux-mm@kvack.org, 
	riel@surriel.com, Muchun Song <muchun.song@linux.dev>
Subject: Re: [BUG] mm/hugetlb: possible temporary resv underflow
Message-ID: <alYZ7fso3zp3j3jv@gmail.com>
References: <alEJkwn5VlTTH_ZX@bender.morinfr.org>
 <alSyhslcItgtqSHT@gmail.com>
 <alYT8J9aRQDx_8pP@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alYT8J9aRQDx_8pP@bender.morinfr.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 560C8C0007
X-Rspam-User: 
X-Stat-Signature: m77pneuibe1ybfkesowqs3tyrhzmceok
X-Rspamd-Server: rspam03
X-HE-Tag: 1784027683-663875
X-HE-Meta: U2FsdGVkX18VeDaz/hz4Bu6+t+/j42DxeVtS4wCMQMKuG6blMJZyeksMBVUJ+pIxqgeMKDfoZxIyLaIbKvCABntA132yXi8PoEFPBcvtdHrhlaq6T9liZqbHZbJPXB7LrmBrnkCx4XmGQbQDmRov93W00rCk4UcuzaLKlCQK/4L5D7hA0PUYDZX1d/fiXE4uoGjHcPriPwvlFdKbwSXgPUlPeDshSjQTKnVOiS3BBJAzb+nvIhg0YXkFqfkjDV151zv1e3gD0TPF2GAqhvLIs+YI1sUHQXILoIdVJ0y+LC8SZCkoH7yaPtP/hN8pdTfhl+qzGtSvKp9k7E8Cw7c+eqkCg9SkuUVNSeprf1NuOUZKVe53t48kYzNj26CBN91FC64HZxgOH8CIppo4MjRJy+yBEkHKz2ItGx4OA1qUnm7+S9bZ5MuS8ChsbaqW5xYHrBIAtz/emL6+mSE2wiXCWS27X6KeSKDasbzamv9A9X58GD289+S74E/HmQuEipr+QFTs26JVqS3nX5qZJo0AMNxOGdaWg+WlUtcVOwJiiCAd/ZIb0gaM7VSauXetpVOfTIH4+aylnG6qtn3wTUBLECK1T7pCdb6yDwdxAw9cW5P84Vbf31Fjz6T/OotxYAvqMzJVcCAFZH3zt9eJO3wj9E4hRBDV9juBEyQwkzP8H3qsHvbc1Ck2ZgcwsBTiSkQEipbd/diDUOd2FjmC9laCKFl+t+vVnaJEvpeutQV8te+fKjz335uX2EsnJZt/iTbIFrEtKepxX78Rsv7hdvJpzUuTMU2ZWeK2yGhqkORlUpvfuXnEGthUXn0yp7WejrLRGr4w2QwzIr8oCZMx0v7CEAUXxAwUX3kvWhTYhn8UhCkcUOLeXTlRnJ8vhGvA9g6Eg8YtBmGvLQehOpmT86sQCJ6uU7EVN38zVmFmmqsewp67dEfFoRyX8a9zSyzS8CJTDQEJhRnBmcIAfmN1z5Q
 mqJoa7l1
 wbsAbmAIvOYDt/L6y4LDC22PfoxJYqFo7+OQfgLLywYOyCv5p66jgtRGN12vGk91kD//GuPsJNXtCrzrqQODaJOF+alFwur9YwolpEWkc8NJ6sfO5WecrBblg7sh56GChlQGPZ2UqedFRc9EwAVIqAVS4+QuAkBJF4clLNibNLDTf22bVU7Go1qKwOh2iriN+R9HuAjtJN0HSkBKdeKor4rYmJZjx0jOv6KmmDnNB+BvsHGsIYdnXSGxiGOyj6M7KlPE1p8zqyOggH0HLfZoEbftM/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 12:48:16PM +0200, Guillaume Morin wrote:
> > > I am not sure what the best fix is but checking folio_mapcount() == 0 
> > > in __unmap_hugepage_range() seems to do the trick
> > > 
> > >                 adjust_reservation = false;
> > >  
> > >                 spin_lock_irq(&hugetlb_lock);
> > >                 if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
> > > -                   folio_test_anon(folio)) {
> > > +                   folio_test_anon(folio) &&
> > > +                   folio_mapcount(folio) == 0) {
> > >                         folio_set_hugetlb_restore_reserve(page_folio(page));
> > >                         /* Reservation to be adjusted after the spin lock */
> > >                         adjust_reservation = true;
> > 
> > The fix looks correct to me.
> 
> Excellent! Will you be submitting a patch or do you need me to do
> something there?

Up to you. You can either send it, or, I  can do it myself.

