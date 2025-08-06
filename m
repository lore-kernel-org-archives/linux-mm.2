Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD21DC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 08:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5596E6B00BB; Wed,  6 Aug 2025 04:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A0F6B00BD; Wed,  6 Aug 2025 04:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446C66B00BE; Wed,  6 Aug 2025 04:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37A316B00BB
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:31:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A6331403F5
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:31:17 +0000 (UTC)
X-FDA: 83745662994.30.1DCAB74
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49589160002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:31:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=nDeV21LU;
	spf=pass (imf08.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754469075; a=rsa-sha256;
	cv=none;
	b=rqWeUpj4ZA8F7ncgdqXQm83JYsxb8aTAQo1bkBRURuQxw6pdhKX/OwGywnFONemP8qtKNR
	vIiNnJ2tVvfzLVy+DftDIsXxg5T/ycu3BjAkMzAdjNVnDL+acFCPtXpTMozIoJoCxijO6O
	i4O/qPDIyHa2tZsqDSb16gLbYYwpu98=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=nDeV21LU;
	spf=pass (imf08.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754469075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=py34VqOzQ9pWh6EBiyUkIJl45E2Wer+VK9zaZW2R3SM=;
	b=imeTwp9kFFqlR16bxHG7RaufGtnY9nh9TH4hzo5rISI9uDS3SoWWrvuLkBsAEOACzEwFD7
	g6uzdDxTto4cgAqFP+lcK04IbMTBf+3S4D8scQ5wNv6oC6lgJ8AphXctkmS2cZW2Z/yM56
	e5UA8owKfWxrFoI6OLCwqVYQZqLhNq8=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4bxk5q5vjrz9sqV;
	Wed,  6 Aug 2025 10:31:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754469071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=py34VqOzQ9pWh6EBiyUkIJl45E2Wer+VK9zaZW2R3SM=;
	b=nDeV21LUbtqaEOjteeH1riWZCiLBxbE3BkNV2HdvNgmGeCpKjBFZuH4cNvu89HmQ0VErfB
	ecy16tkxrUZDrAjY7lfQHzSRAofNCCN/EdEcxkFS90w845E/kAs6mlpdjSSMAnYyKL0gnR
	+7+VwzNzTUosrHelFt7O8mO6WHBwvYKkJyy7pE+F7RXkb4ivmYna5nevvQ4uQOSGWuAf98
	qGzRMKS95DASfhM0i7L92eOxI89wHympUSRIfzuceZksFJw9sc43ItD30/SVYRvsUiy75A
	uagw2l3ED9QiBNUUlzxhqRWFPGT3bhXKpoHP5OqUl5d/609MVvQBu4qYXJI2AA==
Date: Wed, 6 Aug 2025 10:31:02 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, x86@kernel.org, linux-block@vger.kernel.org, 
	Ritesh Harjani <ritesh.list@gmail.com>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 0/5] add static huge zero folio support
Message-ID: <sqpsvjefzukhqbumjmnhsotixw2vpdy76d3batdtlbztzk4q5w@osrjvx22pvah>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <c3b0adc9-e8e9-45ce-b839-cb09dcce3b50@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3b0adc9-e8e9-45ce-b839-cb09dcce3b50@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49589160002
X-Stat-Signature: oqngeb39acr8mytpj1wf61t71ps6cahq
X-HE-Tag: 1754469075-536602
X-HE-Meta: U2FsdGVkX1+YKtaTED/2y0uiSdMHoLJ1mCXnoqUhFbKaE6IkngfmBrWBiudhc5V3oMjO+xjJ0uezXoz8SkhtmCELDfLRG4dms/kpjQ1ec4dEBAzMgNjZv+BV1HbknSfi5wVRJiS04Ylp68Vep+Q9stgas7nm+PGgrO/Zp3eYroba3jIKLfuVZPjqXOREEfayrrEt7AgoMPL+vuBY1IgCJSKlJBspyynfHL4JohkdEyFjp2O+cZw5W2RwSuDKa6Dd0oem7FIMEy316772lCEsY0KwTid431OO3fL8rjQ9gtzxewPBOl4rAexpqlUBoQUqD/TFjNYdt3SCFocOp9I2bS39ochZOJB072jvHcYn14ccd237d4WBDBfIx4+trpFtA+XBBmQ7wfmPwmV8tWqdAPp14yC7zCaBP2xsvJrAn90sq1xCrimjkO7s/4ePdGLfgwhDaUPEp0Na2JGOHxj7GA4bmnYWwoSLEAMCjCaUCa70XpWQhIoboVByGr/zv87mfK6/rfCjN2dVXyTZPX0hafVHawRziWGfx79vNwASj3e+84ZpDlDSDb1VieI7fqSE+H/wllZjNH6DpGxAjdbsC1VRtI7W0OBQQze20dKx8GODZ5Hk4o0gP2m9ReBxq6fIyRrkkzgOAni7hzpB4AYPLCIoIMIi5EvcCkTVotgOgWiidyiY8KkN0oA+jtGFclna504S0dqIuNVJNl8p/v90j6aW2JY7F9JqfPILeno+R/LkoUxarb0WYC9M7Zgr6EGl71QN3UiodPijUJ5f/iJT5SkC0YFTaLwbNJio/oJc2Qymv7hec/SPV9/rr2zxaNzO2lQUxDqXyD8ksNcX4TcglBDhrx7XhemMRzN/VppFAP97cpv3pHa4Tjl8dRU9AMMK/TTNrC3lz+yGhWMou8NK5cZag0Gxd3K4o6D4aCcgJqBpZqduSC8+Lq9jpl4FDGWiguG30990IZEbjKNaNdg
 tKUqBJjt
 N/RriATGv6eO9i7svsAmhb2nHPrznCG4U38F9ryNbjQ+RNtRsYxFmlsxE8+sMlOjv/K7ZWzEMhGhfF4EnR2n3yflwSQor36E+Tww54dB7BolcHC7xdrXX/vguM/r0SlS2rJ/ZM/+FYXRrN+Kd3hgGEXbIsNdTJVeOS4TMW/8H69pzEJdsunpe7Hz1JQKrLLK3YYt/fYomOOxRJqG6+xg4aLNYuKYvB+HSccTk/OPu02d5G6SJFv0IJUCWWdoKcgukn2Npjsr5O67M7GZsXBqnqJud6VAUIvcmmTjFtMZF3fDFV5RZGo2goRUgkiDrvFmTdggI+S3YeHgHcFx9WNFXu89ypKz5sduYjStOOEORMzjzPYlaaVCtY0cqmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 09:00:40AM -0700, Dave Hansen wrote:
> On 8/4/25 05:13, Pankaj Raghav (Samsung) wrote:
> > Add a config option STATIC_HUGE_ZERO_FOLIO that will always allocate
> > the huge_zero_folio, and it will never drop the reference.
> 
> "static" is a really odd naming choice for a dynamically allocated
> structure. It's one that's never freed, sure, but it's still dynamically
> allocated in the first place.

That is a fair point.

I like the rename you did to PERSISTENT_HUGE_ZERO_FOLIO instead of
STATIC_HUGE_ZERO_FOLIO as we still allocate it dynamically.

@David, @Lorenzo and @Zi: Does the rename sound good to you?

--
Pankaj

