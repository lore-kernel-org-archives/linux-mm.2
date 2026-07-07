Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9E5C44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C486B00A0; Tue,  7 Jul 2026 02:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC9C6B00A1; Tue,  7 Jul 2026 02:38:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8868A6B00A2; Tue,  7 Jul 2026 02:38:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2466B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:38:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D817F1402DC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:38:49 +0000 (UTC)
X-FDA: 84961027578.14.E50AB32
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf13.hostedemail.com (Postfix) with ESMTP id 288A920006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:38:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="T9c9o/hg";
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406328;
	b=Kp6LOa6kX15H8cUdrvU1y4fOzT2A4SHSIaPDUsDO1BdPab+JANuJ5jO0/UyNUVlK3bqbeH
	2egjdLesh8NSLgv43fp+Lk/Cp9Xb/4kySKNwEsNQTpCMZp/7zss17uQ97IEj/2dWlmFl+m
	Ewx92i5JMq/IKVov3fMiJ53rCN00EBQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="T9c9o/hg";
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1BFGaGU2xupQRN461NQlBdIPrGwg67ma5LofMnJBF8=;
	b=wvw1GnX8n3zMnrf/Kx+dfPV5El5N21JdpQ0YW8huPAS/ZKKqipjA13GnJvLbx/Hmfw09OY
	ssCFHAe9bCIUaDfpWHlInM+7YlSVMkWPS0Dfzpi7WklD7CEL/TnJAZgrJ8rbUMVE0wzAxP
	haJXWmP+oOgJZmflCOEO4TEGvG+yPTk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783406321; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=t1BFGaGU2xupQRN461NQlBdIPrGwg67ma5LofMnJBF8=;
 b=T9c9o/hgrsIen/ufvk8cRltvXc98r0f7EqRqol0h2xOlpYPaEds9LiOavYAnXnMqZK1QU/
 tJFTdwl9AqBP1WE4OfIcKhnLtFGofcXfP6cdLzrZa9UWblf4j+5XR9NDS71K863YqXjtmz
 xmFuMZJGfliqsMk18REwMAJICS4nCNTxK7f92WV5FRLJ1qBczS3RAUcmVt07IoUIIGfQl4
 48L5Bdg31dUmUISHQQ8enci+/1njK//6szFSdbL/RUP5w9Kwk7KoOBLidOuQ/lQtpWa08w
 3fD5BpDEMR8LcT0qm5q25TaViyAC5t1NFXHzMqiEzMGXMUwpqGu6Lm25artsnw==
Cc: <akpm@linux-foundation.org>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
To: <apopple@nvidia.com>
Date: Tue,  7 Jul 2026 14:38:14 +0800
Content-Transfer-Encoding: 7bit
In-Reply-To: <akxtWBdz5XjoAAzF@nvdebian.thelocal>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v5 5/8] mm: extend the template fast path to zone-device compound tails
Message-Id: <20260707063814.40421-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
References: <akxtWBdz5XjoAAzF@nvdebian.thelocal>
X-Lms-Return-Path: <lba+26a4c9eef+a83c22+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 288A920006
X-Stat-Signature: k5z5smp3ehx6t79ibgn3gcrdfqjgcfyi
X-HE-Tag: 1783406325-865050
X-HE-Meta: U2FsdGVkX18j5O6nf7T+snifFCvzfMFZwalpi6jwrAtUle9whTt0kxptqjc68hZ6KgBBSH2U0ogQH4VKLR4JKsBJJrnwlkSPFloQnfVGsWvWQeyNS0jUOUWcwQD9AKMMcfYLKldIC9JwdKGGz/JUNEwFJck+yTrKc/Wif4RM4V8INzBuNvaEy1Vph5Lretw3JCcHLifYoFP83wqClzGjNsFfYZdj3Oi4BoJNtir0vIeJAQ92I++0jK+oeP5Wm6zcw+6X0qT6WRb6mmIl6/Lf6MxM+DaW16c4MIAWlNU7Nlv+SxRLkw5Fvqt7wSWd73pw9rUb1Gv7bmFRmmojQEBggD1g1aHOMqYIGYiOUqGJtVS210fc8lHK/OdE2pYJhKhsdRIT4GuaQC/3CFvBXT50yfKMoNUaLFbRTNX7chjZd834hbGAaVH9aRCX7+ZCDzHLZ89qEC8392YisCphzIvUaZzcBgbdRheS7UhhIYFtKytctev0qyyS9S3TrSFi3HjgkndQ3Grrdj11SJQwv7k1VwFCy8l02Qw6tTCgMWdv5mrr/Yo+kI8NAbz42tM5sbIV/Oye2SwnBLbGosinJP3qA7VLtEnA3AgmSfweVzg8YnYj/xH0jAZnWgijFb5n5lvqUnV8oVLiqb2Xozv7YiQ1lGbLrvPMnwSJ900AcbCz/U9+C9ahNz87prxnJoGg6TCtny3R3sFqWkaqvef9TuyfEvAUDksICz5N/yaJdTpKhVtD/6h6O8NRiMxyNPb1U9vpIhA9Qzf8H3oCVv2RLGxWkJuJWoZESAef8zgENq/0RUYegjYwvlTJHVbxh9XgKX4Fnorgoypx+nFnc4RpttpmLOejmH4lScbIMIl9XIzlMBYy2OLRgpNFO2MQEc2fI1SnDwdx1Nf/f2+nUC0Au9FmBSIs2ltj+iN1x5jVEzOcaUojWVc+5A5cs7QERnjrVofj8ptzHV6xnzYVf7uPydx
 TX+jfmZl
 3JN/JwbMy0CSxMOZynZjN/mh2x7ROWvmB/nrLtcEn3mNiJDQG/1dGhXVxN2BYocAgxl/9OexjJbGOXLRVHn63+KANUI94v0xLFNdRK3xdAYGmaIL1XVS1k2GQrWuFCk8M2SCXf5ptEiUei27KY05UQe4BOkRP7s/6C/q3jhe/MQlp8SKbbLHGDgUJW3dTWQ2pj6oMSZL4WKAeFQVMbVbdbTrbHGZSftglUGNq+o5iQ0NRoDIJ+edRbmlp15K4TYclvWK8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Jul 2026 13:09:01 +1000, apopple@nvidia.com wrote:

> > -	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
> > +
> > +	pfn = head_pfn + 1;
> > +	/*
> > +	 * All tails of the same compound page share the state established by
> > +	 * prep_compound_tail(). Reuse one tail template for the whole range and
> > +	 * refresh only the PFN-dependent fields in that template before each copy.
> > +	 */
> > +	if (use_template) {
> >  		struct page *page = pfn_to_page(pfn);
> >
> > -		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
> > -		prep_compound_tail(page, head, order);
> > -		set_page_count(page, 0);
> > +		zone_device_tail_page_init(page, pfn, zone_idx, nid,
> > +					   pgmap, head, order);
> > +		zone_device_template_page_init(&template, page);
> > +		pfn++;
> 
> Similar comment as the previous patch - I think it's clearer to just init the
> template page here as a separate step and not unroll the loop.

Thanks. I will rework memmap_init_compound() the same way in v6.

Thanks,
Zhe

