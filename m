Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6363DCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 17:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF00C8E0005; Mon, 20 Oct 2025 13:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7AE8E0002; Mon, 20 Oct 2025 13:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04AC8E0005; Mon, 20 Oct 2025 13:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 96A9F8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:41:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28FE257A7F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:41:17 +0000 (UTC)
X-FDA: 84019208994.29.4C3C2BD
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4279B140008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:41:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ru3amKAk;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760982075; a=rsa-sha256;
	cv=none;
	b=voxMo8dayF8Gw9mDX9qxEQEx6WTgzfITO87xF8yPwvXve0qjXlBYWXw0A4RIRztE1Yr0yr
	6funelTcpVLhlbIaWiOBCirqqtaYDxEWaJhDb63fZHCve5qsUVzslB/tRycRJ7RSazNGzV
	Y35dgJlTxB3lwvONGp4ulu/X10KePIg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ru3amKAk;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760982075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjTtWJ04FOXbi3894+HZSuerKrZxUoz40xS5pGSg+Yk=;
	b=k+mYWbcvopNrAvjhH57rXVn3ODaIO8tkVHcQ3e3+q7VU5Hdj2OR035Wfu2X0gL08ujdywj
	D0vvZyKQg93ZnIm8pTQS0Wr9OnW1pFG/xlWQ1SuFl/Di7TBkuITTjMHqxUqLC+v2QFm9C2
	k68vnHAYNxlTWjJjmNwh+BO2JM09b2k=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-795be3a3644so39180446d6.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760982074; x=1761586874; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fjTtWJ04FOXbi3894+HZSuerKrZxUoz40xS5pGSg+Yk=;
        b=Ru3amKAkZ0XoQTgMyFz4++NYMI+4S+Wy7MCDMJR0LlQuEQuYUjHivub/iuh5aRjror
         fpmGyfUulOrmzR8Qh/WykGcNI6iNmVCFRh+aA9JJ8qxKnyIqJEeyae/RJ6ytC6VH50SG
         SP1gY18F2f23/RvDEIejm9Cbu7+9RZVdzlk3UEgz+/gl8bVsHeFtCZ7Yv1bUBG722CVX
         3g5QWbjjRRbnTfvTju53NanLt4WjaxNBdE3mC+EpxlLjDRoE8YtpR2AS+IlK5B9llSMM
         M/Q7KYE3PbGa1PAzn4dTIGuX67cphj2eE/iOmwrsgUvZ/JSES1rjIjSkNPq1HQ7xKFvz
         2uOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760982074; x=1761586874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjTtWJ04FOXbi3894+HZSuerKrZxUoz40xS5pGSg+Yk=;
        b=dhTH8RZeKwpTD8d5JiaTELjw/zm2/HVoJxnTS2oswhRiKZMUcnATjoQFicL+u0FWQF
         FW8Q1Xeo7EHnE2JniPIroVQTq6eEcgfBU3l1+hXOKyW1EKAMC4lrGEwJ49woIyqxdvZk
         bCTeIlS2W+1cgrRFdPrsoLrmkGM4Fm0KHFP5bPHVlg19nMSuDZbpZruRKU61iLQKExSZ
         BWcWNkGzAgkbwaNMi76haZ2gmPRXkr2b4DwaqGqMLwYxlVK1Gc/DO4mIwj9cxRegqvr5
         I4LKo1HBGdmKFBSorH09PwJ+m+5wNRqCiX1Aw+joAEQXOLoVWe7TrG7CqZzdimjE7Ey6
         N1xg==
X-Gm-Message-State: AOJu0Yzag+Ou0q/JS32kUV0TiWPzWc0nYHEqpFioyDqJvHsb1ITZLTF7
	1OGZjZCx7MAFhuPZ8s3SPPTtTEnekwRd+N1EulpZAoa7tkwjQ3QfRzONDEWvVP7bLr2hkABhhRo
	F4uL8
X-Gm-Gg: ASbGncukPnlOG3ZNF1NDvB3JZursIlUri1bF7+V8TBuBDvWXJr623f5EjGMSkot6Yns
	QQf8GoAlToS1u1iFaJnNQid0RZEttHUxLFbP22oUviHUFl+IiqYc3jLoxfm9c9Cmfp/ADj1T/78
	86hPmztxHXYbi+lE0PpN8VxQuemJGoW0Dh6CkTALolAxlDEPItQEVBMS12oZ+57d8IUucLZPnQ2
	zPp+D/5DBncpmduXCDX5KP081UkOgabfYaNU/V8dD3fxQBqdi1gJpSWB9xTeVEV1AHOAqmaU3S2
	Q9nYLHYHRr393Tyyd4zodW3F3b8miL4jAUzGXCMefIH9iRmGDJK5AeUWlQTo4BVUS3qZqKulSxt
	8L6ehqVJiiHSoMqZVatD/X+tnvVjfZcsJ05xUpjqfMUgpiIPk8MoiAZQnlRyJ6b6P7Iz8g2DQFh
	LtQcchpgKzFWWtkth8OWBlvhAI0I/3zVH1Q50fZjK9QNiDU3BjA7DRSFjTE+M=
X-Google-Smtp-Source: AGHT+IF27fdheVev+QfR8cbUM42iDCUTKvZpHAkwKN/mALsFLATrPYKyM8gqCwn8kv46sHcSKP7PrA==
X-Received: by 2002:a05:6214:2484:b0:87c:1d41:575d with SMTP id 6a1803df08f44-87c2054aefcmr170598696d6.3.1760982074158;
        Mon, 20 Oct 2025 10:41:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87cf51fcd39sm54735456d6.6.2025.10.20.10.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 10:41:13 -0700 (PDT)
Date: Mon, 20 Oct 2025 13:41:12 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com
Subject: Re: [RFC PATCH] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Message-ID: <aPZ0OKx_VnQ4H_w1@gourry-fedora-PF4VCD3F>
References: <20251020170615.1000819-1-gourry@gourry.net>
 <487730c6-423a-4a03-a668-9b9ff92a5cfb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487730c6-423a-4a03-a668-9b9ff92a5cfb@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4279B140008
X-Stat-Signature: 384bq4mbmcofs1deqt1f1tm5jek3sqq1
X-HE-Tag: 1760982075-555813
X-HE-Meta: U2FsdGVkX1+ao+MPavAaGNXcMkNaquyCmS/7L51dqmGeqUxGOhkalEmjG77hUrlonP6o8VWF7xSZUJXk65vu248qQElad/jNF3mWebXQQ44oXCBh1VIzKHC+nkJvM5KUxR8PQWAnyWrkJ2cq9DlhHPH91OVNhLCieRashD+si1cKoieNVkF4pN5KSMWJOoVVhhuQsRH1JPN1qUnQK9oy+5unA74tHn8MNLQeQe6VrCkRFTQMC9R/V6zN+sYKuFgqmFfixGbkZhh2khS+dp9JKsMyE6kzTpsGuPt/hxL8U4tsVbXL2imG+6vPfr4jrNnoR08DvxyqaOxveN+lostWsL51bEdHcl+xthrZJiDAXBShfbbPaCy0Rhlzf2ErkehQAsY+LlduMLOVbV7feq56c5kECRaJXnh0wcDBpv7xNKulJh0ZhJA0lUiNuOkIxmkd3xuW5xY0K+A11UBANSTDy1b6mUvPMr2MveuzPnQW/PMbAy/mT6f02AuZfx2ZhQwuQGe63mvs+FtY8sny4err4T2vKQyfdlxKm/p7YLgXXC1FE0e0QIk6APcGfj8avoU+DOFGWUdVm+uHfuByMKx2ezvH6J9Gj2/cjsIP3tqQ4Bmjb1NYs2PmBHmEquiUaLhHUMtK90OPzaBApLVwjko2TuA+wur4fJkbzrqg5wC/eMBBhODod5rIpst1IVHJQVpJdpFWeyYjCUcUnbjePMBosIFmGQBUjAWy7AbqMgLtWQ/48vfxxKqEvS5R2Ciw8wdJ6+O+5AjoaIxxe71/xhazxLYM1oFGHFaGi0+23yoikOvG15/1F60F1HSGAFC7RUvjrRgqRaTB5MRDXRxVwQZueVqdJB6IxaL4jP6rKHZMUgaVvnTl73D7CgK9atCi8VSTfdDU7hRwCKBWZpXUHqdJKutbMNjUBMsqryyn0YsjoG+hG0T2f4EUvCpaOyRkQuwACP692xY25kBmop2qbOg
 pHCmmJx6
 PDmeteceJ2lJuuwsMKQz0Lkjrs+MczrBj10QRKJcMa4QOa2siwhezajk9AdIDm5bcyjcvVsFXwqVronDuEUGRWBDQ0daG11hszPje4RJctYZ1RH+TIvLu9ThGbduAlMlKuMSCJjqYHOeAfAt6ibj9gThEYpoOwwGQAa9hF3Wjv5YtpnylIwYKuWNoBQP5nn7YACSpTVabcd4/6pYVKMDY4DBLQ5swElYcpE7ZgiDltNzQTGA8T5d/nPxn6nTtreGadR5JB+6GcGSzR6TmX7AXsZlwpJsAxLrn9wb/XMPclc9Rb4HHuMi8TLA7NB/AjL3Vnimh8zyHZcZLUoiPcmlKAw0zx+7WeD0ev+UxKHIFbsZ/gVy6b8Qq+VFPqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 07:24:04PM +0200, David Hildenbrand wrote:
> On 20.10.25 19:06, Gregory Price wrote:
> 
> Do we really need the folio_hugetlb_migratable() check?
> This code is completely racy.

My thought was it's better to check if any *one* folio in the bunch is
non-migratable, it's better to never even call compaction in the first
place.  But you're right, this is racy.

In one race, the compaction code will just fail if this bit gets set
between now and the isolate call in folio_isolate_hugetlb() - resulting
in searching the next block anyway.  So that seemed ok?

In the other race, the bit becomes un-set and we skip a block that might
otherwise be valid.

I can drop this check, it's just an optimistic optimization anyway.

I should also probably check CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION here
regardless, since we should skip compaction if migration isn't possible.

>> folio_nr_pages() should be fine AFAIKT (no
> VM_WARN_ON() etc), not sure about folio_test_hugetlb_migratable().

will change, and will check/change based on above thoughts.

~Gregory

