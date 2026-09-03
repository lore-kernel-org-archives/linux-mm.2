Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED78C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0946B0088; Thu,  3 Sep 2026 11:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E614A6B008A; Thu,  3 Sep 2026 11:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53726B008C; Thu,  3 Sep 2026 11:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B382E6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:22:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4151A160564
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:22:55 +0000 (UTC)
X-FDA: 85172818710.18.9D8A541
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A27D120008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:22:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dcnC1dpc;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788448973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21cCXr0X2DjsXESFCscBUyGKzZA8PXymS9EiSyFzEzM=;
	b=HT5FeaqtUkLLpX0t6c5GdGJm8v83ISGJbu/AmQtIO4jhr15QfRLk0nxUTGS1hFg/sF0Suu
	plK8Plh6/nviI23a3I2cKA0xTGXp/ARbUN+y7kRtrhFqKO7kfrKAyTMzxkUEe+WqG+nJaw
	qKKLoDNvCNTRB8uVTReT/fFtRu+SuSY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788448973;
	b=mBXR9g6XcZzFxGdTGnm570xUQuBqZVKRhNWcaCg6M5oPYmDYquDI8mIW3BfBmy9NfyUOwK
	96jr2xbVSYTvpi3QTszr/NjH+xDP2lsWye3rEkHj+THES5KtHl2MfdGfaffNWY85mk9GCF
	kckLKi552Ye3xmS70OmiG1E6Q7L5+N0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dcnC1dpc;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31FBE6053B;
	Thu,  3 Sep 2026 15:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCA21F000E9;
	Thu,  3 Sep 2026 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788448972;
	bh=21cCXr0X2DjsXESFCscBUyGKzZA8PXymS9EiSyFzEzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dcnC1dpcEalabik8BQ3D4008MOsKQYZw4KTmO+x2pG3UdYeRSt86vsn/OPMgCysKQ
	 veQOLx0QPyKpz7EKh3P/ueR7krMrR5QJ9FUreobY6Z3vU2ZoS4oeoSjuDUyudVkHnM
	 WQIKrBbtgacdOycs6v3IgsDp5XwGDsB7YU7ssVtbr3nJQBomoly9aHVGO0ac1ki9OC
	 0dJxqgL2tAiIIX2Nc2uYVivZG76xWSwDgzK1o+20OvKQVzUyiO2pcbssQko/zNKPft
	 DhBQYTrl3um7OoaGSKffw0nn3yOHw+PHsC0XzdCSMJ9KWEr6hLXSl+wjJtbhxevFLA
	 4CNLzjdI00hGw==
Date: Thu, 3 Sep 2026 18:22:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: s390: replace page allocator calls with
 kzalloc()
Message-ID: <apmQxu1QYcvTyVtS@kernel.org>
References: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
 <20260902130612.41500808@p-imbrenda>
 <apghz4XAgv0ro15t@kernel.org>
 <20260902165315.06996af6@p-imbrenda>
 <apkqHLgg7nqBiYW7@kernel.org>
 <20260903150852.518d6cdc@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903150852.518d6cdc@p-imbrenda>
X-Stat-Signature: jwzcoiiaw4niao3iu4ceoud4ey7crtjs
X-Rspamd-Queue-Id: A27D120008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788448973-304074
X-HE-Meta: U2FsdGVkX18NUfSNm6iHcJpfethGfXW4ZCiKbv3+nG/1a+2C25exF+C07imf/tKuaSbLkJdvz+hnn+fmz9KXbAOpodwUYEnSamuICOHOMU36Qt+TdXEJQ8W/QrqLsZFwBhUTG7XQQXaS3pLMr8wxPcQ7aXlpqltOluMSBCYCSK2Fe9eL8Nr9Xan5KBnK5WgAr9aTc/ovMdGEJs2cTjTVwNxWsuMyoqxWwhhUy6CRJGBZpNiQfUmzEcFzw16bhSbiY0ZoKDGp23lQXhrmY/CT/NSijbLXarftaetz0mwBwDt6xFvsR6Lps+i5aPZveHWLxVKQszGvJ0I2iARB+COwBb+b0iCLaRcTedIndO6/CP1rwY190U0ICDRzoX93DnQOVOyGp6q/XgJEOkaGME5T3UV2IpAM+0TxWPBw3wRuQggN9adBoqzMdLvfQ9Mvj9GAgCzzCtJejmiM1GFvJLcFwH0OEOxO7q6iL2StJNs7Uot4hK0UiADW/ex2ITV45TnnyCZDdWzZidpqFTd2nagPRW3imw8VHZ4l/vSWIj2Tm96pgZfOj4RRkgqjeIPdQwFgIrRCQfw/i/YEYaMvTjtlyGibDWegIGL46RPvwSvHMqdvT9BIzVZVtCf4Dpgkz+Pm6BCXd5WeKj3uqJU0fkGV7mld4FZrc83PRsvyfWNelnO/0jRJmps7OWTayiv8xlqyFiEqcwlNpUpMjiRDGA2skUG0kJ1PMtDH4TyCjUOuNdCAh7c2xuUAKzqKSi067AXxkXRQiRWNPPp8/RqGHkatXbL2uN3vDUTpGhdFMZwHs3JQKKHtOdshS/I6qEDEbQMCUhcGRYNhlV37KdobJAIEHYj3CZGp4tWYoeOHdoRYTKd+YXyFR4xbsnKj4CwoyZnhrIq4kWrb/G4sllgmUq8/em8QmXIuUXX5Gl3AjmvPbX9xw/mhrv/iphKmhGue5eYqD/P1B10ti/OKUTeDokK
 t2sS0lmN
 RhTTpNXptyeQxQnzBB2Q8R7Xo/HFSz+acNIZG40hdLpmSi3mZEG22N2z3gp+CMPbLmc9FShofGS4Jae8r/4CnLjWUhk4e+Y0h+CzDMxbtpsl8hyp+RStkAGISFhCX34C+soJFwDQjw039H5uNTLfyl0A/BUq4nCbLdiySG+J/tpuVyF3qYt1r3xqtGwXA2G5mbKZVPq/R2p6WIrLlo8eWmHe6jgPLxvvpLU1FSI0DFkLgsV+kNobIhk/pS/sL/w4Mn8cW6D/Ja6ZbY5LfEiBN0hHtFaozP8b61rhjpitFjMCbVHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 03:08:52PM +0200, Claudio Imbrenda wrote:
> > 
> > The only place where __free(kfree) is completely safe is handle_sthyi().
> > 
> > In all the other functions using __free(kfree) creates a mix of of goto
> > and cleanup helpers and cleanup docs advise against mixing them:
> > 
> > https://docs.kernel.org/core-api/cleanup.html
> > 
> > The cleanup paths are quite involved in these functions so using
> 
> it looked trivial when I gave it a cursory glance, hence the reason of
> my original request, but... 
> 
> > __free(kfree) there is really not trivial.
> 
> ... yeah, it's actually not trivial at all.
> 
> 
> maybe refactor the first patch, and leave the rest as it is :)

Yeah, that's what I've been thinking too.
And leave the rest to s390 kvm experts :)

-- 
Sincerely yours,
Mike.

