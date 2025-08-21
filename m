Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA93CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 04:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797A96B00E5; Thu, 21 Aug 2025 00:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76FA26B00EA; Thu, 21 Aug 2025 00:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC926B00EB; Thu, 21 Aug 2025 00:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5949A6B00E5
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:51:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 032B2140275
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:51:35 +0000 (UTC)
X-FDA: 83799541392.07.D09C112
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf09.hostedemail.com (Postfix) with ESMTP id 417E9140003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:51:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oewEGILT;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755751894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yioLSYo9QH9f1PuDLNaGo0+tafqVuX9dPo+aRSjB3YA=;
	b=Ln49koYzQmbl2/VCsE9Xa0CidYKsO66thB3X3CYC1AZDwapLP6Mkkz1w0lAYI8kwEmXUV6
	4Q5JybUcWABm4xFdJv3QONchMSWD7tT9b5Su/D7GmOE+3U3yb8VVFM9Y2iWeqaKVqnM9Ke
	N9cv00PerS99laJBaDzGCUdziFv2PfY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oewEGILT;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755751894; a=rsa-sha256;
	cv=none;
	b=QunBTtLqG9YRFKZuuNx3A6FnaI20NxeYaqpGrU9e9ixOdTrSZsf3iv0+Li/r2rHhyYhpPC
	iXdBfi3rhMTDRMhcoisE32iQBFzx6+kHsNKwffOE8C+SxLlLjruBeEub7x+TZd7pm1gaFZ
	oxS5s+0L23UmInEm2HWWS9wtFO6+2IM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 18C495C5F6B;
	Thu, 21 Aug 2025 04:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C37FC4CEED;
	Thu, 21 Aug 2025 04:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755751892;
	bh=vm7QKEaDiXO+rNlJ45FmZQoPoaxlWAsBMFsHstnZQ+Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oewEGILT+80jklKi2EOEkEMU2Eo9leBjB3vGXsGZDBSJ3aPnWyhS5JMS4PquNaEq7
	 1c9z2p15r2zyKsGcBAKA5ArNmr1nr2DFaL7v5fSWQzkoNQmCnDBba2l0Ya6sXYaiV8
	 SWgHJcH55rHxyNde2GstGcoQv8+ccKcHXWt/AfOU=
Date: Wed, 20 Aug 2025 21:51:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>, linux-mm
 <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
 richard.weiyang@gmail.com, Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390
 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v4] mm: fix accounting of memmap pages
Message-Id: <20250820215131.6925be694bf1d904c3f463b7@linux-foundation.org>
In-Reply-To: <687b556e-0196-4a38-986a-2e7b0308e03d@redhat.com>
References: <20250807183545.1424509-1-sumanthk@linux.ibm.com>
	<687b556e-0196-4a38-986a-2e7b0308e03d@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oumyft67kpunfhuw6oro8igp3kj1immn
X-Rspam-User: 
X-Rspamd-Queue-Id: 417E9140003
X-Rspamd-Server: rspam05
X-HE-Tag: 1755751894-980833
X-HE-Meta: U2FsdGVkX19kc+H2a3UovWDwfnkdb2RFjkg8MIs7juPTfzk23/TckKcY9wUvgFhZzWtj3mBuE+dwocugMb7zWUI3MipGpqHOxqzC+AGpiGzGFBvrTi91uyKKq6bhgrKfxPcoRiDnpq3jcPjgwyT2n+cZtVpT6yIDDrotrByFA/UttuGFMO9StPv3ZO6nUNSETB9vAp1OIyB2mnXmOslygS6XZmVP8ybVmuGpUSeKH6V1DWF4XAG0PKkUrtfk+Y9mb/ago2cZoP8zWw2gDwO0dlVLSL0pvnFP6KiQ3vaUIFGidqE+iBsIUdESXAYEQNmmZWQH/x6OCb6W96qOF2WdPi7tpejAmgwN3NfRu7CkKMCYJjjUBwL8w+Etpj6mFMsrGS5dpdp9LCqEunbNoBMpJXQcl6MNgPxOJ1zKcIVgiYhi7GhU1RU+J7zfGvhR04v9mKEMLtbYJN/HgvDIecKuPymKzSVUSZlE4KdiHg0TPAnK2sUlTkIXmZAdRcbOUuT+a1GgIBDistgjseYIYKbb4DFRJr/hfZaWpi5Mxqa10fHAdMEVce2VOzJ12tXZtu3C8i5q1v8eCbe5lNrAmNMBs3HF9O9Ij80wN1GojFnYFkjrJilZ2uX2oBwNjPpGmGR9awtlSu6bNioQg2X61GjuNre64NDqtjeMrTDqdKAPrUBjhisi82e6oneyDd0pGA1CEi3k6h3OwyIF/jvziEXdze29bhG/EEHJC0JalIH8QZbDhN1GRhlgFFZbndNA6/SmZGTNhNYbnBoQgaTpqhViZXuZMGLHrZ7TElJZgSbJXt/NvF0xP2A643i9T259CVzBtI1dMxjLvHkTNYl14Ou7ECKCZE7iiTDN+Ai7EFA7MQLRS6uYAam2OpSdlHWg0yDfcN2IQ998HKOMiO7/IEMvS8FRD++he29/2xMgLG81gX9jVm8IjXeIX222/qgFDFABcM6fVrDgM3swXgQZaYR
 EaifTRSL
 k+dZgDlvXeyHUpuLF6Ov5nGW+CulgoEP97HzqZnUjlLGkisJcijMKIUZ5m/lvsSCEdmSTkJkUOocuk5bCK/++FNgVxhtMugyE7TPD8A5b5E5I2BFI/k9wcPNmXAIp2IWCabhqK2hgGhk7surAZzC3IBjX3mRx8yLmBFICErNySau+CHaVw4miprbfgy3Vd7Ox1pX7jUITgXlOfavEd93kX789t4GC8GbBUuax7vbwhPiaVr7R14+f1fkas/AHJPYJ2pETTtn072vcbPLVjCtz5nLz0a4XYwKrHl09if9pRxXdOY3pMRfeWbWpFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 8 Aug 2025 16:23:52 +0200 David Hildenbrand <david@redhat.com> wrote:

> > @@ -567,6 +564,8 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
> >   				sparse_buffer_fini();
> >   				goto failed;
> >   			}
> > +			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
> > +							   PAGE_SIZE));
> 
> IIRC, we can have partially populated boot sections, where only some 
> subsections actually have a memmap ... so this calculation is possibly 
> wrong in some cases.

The patch (which has cc:stable!) has been in state "stuck" for 12 days
due to "possibly wrong".  Could someone please find a way to get it
unstuck?

