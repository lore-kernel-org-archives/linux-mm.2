Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D00C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6E16B0121; Wed, 12 Aug 2026 08:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D5C6B012C; Wed, 12 Aug 2026 08:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3C16B012F; Wed, 12 Aug 2026 08:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BA876B0121
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:46:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A50211C1019
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:46:53 +0000 (UTC)
X-FDA: 85092591906.28.D3C1983
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id B2FDE18000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:46:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oyahjZBe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786538811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxYdP471DepeKW2rJLqfMlMTWPdcu+KytJwblc34E7I=;
	b=yN+aZLiA9I6+MgZUO1ck1cBy18t9r+vT+hFvyb+QB60erfVipg4lwGUeE1DYieeojduDoq
	yorjWRRO1jvOWJkG0b28Bb2yb3+8mrEH0UwNK9xxjNlN4iBS+QVmCS7ylLgP6aFrn5aArc
	O2kxvpAzSdiU8ENtUbBwsoxjc3IlyjM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oyahjZBe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786538811;
	b=JfvoH93fupqERoEqTfFD70y1yFJ5YeXHO8d4FOsCE5px/42X1hKtIbkjaiQwHtHNli722y
	D96wel83bQsSR78QHXT5eqvDanB2BnUaPJDY2GmkJao7k2/X9nXCPFNibCxgyscNwiYFY2
	gKVy8qPTB54SDilSQTFT+n+u15wwyL0=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ccdf36f63dso82505ad.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786538810; x=1787143610; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oxYdP471DepeKW2rJLqfMlMTWPdcu+KytJwblc34E7I=;
        b=oyahjZBec9Ftrs7/BWszDtIvAAB6sgKALYP3X3a+QV7WinPupxTf6Svy8+qU/xwtbD
         Wq84Lbcgzges7TETrC4aKieFANHblQ44jU10Zq06Qd58V5sNKhx2fLElanBFkBRqQZtT
         hHoL+I9W9iqy47t9kp/au7WHr+YnN/O7MaEnK299CTXzrMF2u1fA0AyX0vyVigKCEOqw
         OzM6VVb1AMOMvxL2Xhef/zNSVmEdwAY8GSv0OQjYZDrySEBE91iVIAMEYhawgsbYg94P
         5GznNsNghJogI345lYObMQtnFxlomQ3MiP26Z5iKizAAyDRtRRGQtDaybLMSOmHqvS3a
         6Q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786538810; x=1787143610;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oxYdP471DepeKW2rJLqfMlMTWPdcu+KytJwblc34E7I=;
        b=goBuEk8v2We6RY2Qm7kg9T8Ip9RByv7ZQWqJ5aD0HB1paMcbWW/Og43oo8RQc9vjRM
         R0wPQfYs2mkrYnXKJiWYhMy82UgsAFZRBPMPrLkxbTMQx8xDARFOdhaeZCg2OjYH1t1L
         oP7VJvUfLRpzI9slJdmHu9u5wxWeuWhsbF7jwg42LgG9Zvq5kU29PhJqyKTzreb9cByQ
         H2LFPIIAlYtWpV3rACRt6P5CE4U/YofjFxfZqVmO+mEIPh490Y6EHyGNJxNrDB0qHZRZ
         3x9Fs1h3hfaA9uf1BEgc/3TEmLVLCyF0m7vJwkF4RVTDC1RiK8TtjlGYV03alBQkulMh
         qrHw==
X-Forwarded-Encrypted: i=1; AHgh+RrdnY5MMLw6DhycbdTFfnAE/azVt/omLkZM32nCxLRLGZW9SeLZMvhxRoxTKC2YXeeRztsZBLXQ/Q==@kvack.org
X-Gm-Message-State: AOJu0YyZIQq7lrtqPuT1dnxZIhpZTt/H8UqTMxNkd6ccmNklCFFJMJ0v
	M3ASEs3zqAOAKX9ieqQEZGhpocrp0+/NiCeCSIwg0ct1Bw5oqI96D6pG98ndi/QCQA==
X-Gm-Gg: AR+sD13JEXH1bBUd8W6h43bbFT9d0rgki38M3xSCSIhhX46+0a+Isq285iIQQJYvKI2
	aaTCFlNLYBaYDAibE02WRXsRhgQ0uD0YbyxPVsKwLHM0tWbbnf5lpl76eXJ77gVhxRfH/y56OJW
	ku2zSKsHDhxRYc+l6H6PUSrdQB/OZQIBmUXmGlI7D9u9Q2rsUDAj1tjRaj9d8/Yy/ZkLBQZdwMK
	Rv8GR/6nbQSwiVu1rY1BpCxKmJ+r+Es3EKhrvHWBKRL3dXrCbI5GiSBhpN71ZlibtQ6D2EPTWYp
	yk4ohLjEtIsg/7JEUAjVXq0Epy9FBZ6+iffxF03hd06lOzi6osyTaL9U16DA0qKmivrZPGWvTj3
	0oOyDhzrHtuR7x8yMt/OcSpLue0yzPZ9410POj+NSYO1wUYvjVXLlyhPcpQbCpb4JSXcsTnAQRJ
	QPSIPnCOiBc+kK76Up+Wea2zHvRelN4knGvf4D/kI7hZmLvW9+sZib/au952mwR7haJvsITJE+T
	QUZ6t38ZQBijrFTpG/sWt4=
X-Received: by 2002:a17:902:ffcf:b0:2ca:bf8e:360b with SMTP id d9443c01a7336-2d34aa71fedmr6106885ad.9.1786538810039;
        Wed, 12 Aug 2026 05:46:50 -0700 (PDT)
Received: from google.com (21.168.124.34.bc.googleusercontent.com. [34.124.168.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392f8893496sm3642752a91.2.2026.08.12.05.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 05:46:49 -0700 (PDT)
Date: Wed, 12 Aug 2026 12:46:43 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] kho: Introduce preserve/restore APIs for
 high-order pages
Message-ID: <anxrM6HPKPq74So3@google.com>
References: <20260803113944.3694290-1-praan@google.com>
 <20260803113944.3694290-3-praan@google.com>
 <2vxzmrur3880.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzmrur3880.fsf@kernel.org>
X-Rspamd-Queue-Id: B2FDE18000C
X-Stat-Signature: pwjyskdzs6r5r3u8npjoqbtc5bdg5gm3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786538811-15021
X-HE-Meta: U2FsdGVkX1+BpJnfsSuURmYfgHuYl1XIrcAeBVKb7wCMSHJ3XuyMWWs+TKmefbvFoiNb5gq4Yk7OaZCr1A8Jz5zPf3i+ZVu1bcmZ3OLXuEentYE9UFH3I3jyf5jeqfgGQ84zjJmSIkFXKJzWzpcWSIPcvTz703AGfLBpLw25Cj+PIpla+7ktd30fir7dczTwuJ2gRn/8G3NwA/OTm8VBnmmpeEXVXk0+Jj3OlyXltFmeq/0ccOhc4a/yJ0AC6c1DrdzZaVMeFbqPN3A30mwcwFPqW1knNQoNS4lYexfl4+82oSgGug0pEzRjObpXzOFg5LcEZVD2Xtio4KpYHUBhCYXGc01Tpo64wswMTlZN6MkdYLK56sslQMTf3ve6gSdiqTM2qd4+gkCOmIfgLJhsStc+PDR+BBdcm5ZeXRxdnUZEluuo0mu+6Sn3SnadsdT7HY+WDEUtGL7DDy7tMMgHa3higIV+shSIECEYFCEcJ+ujvS6TlIc9nrKeigcqa/yCEbD2ITK4naAUaUSs0xMNfFc6oHSRm8J8sczZwpLTY25a6mevz+yXQOK4LtThbbJ1EhdXkA4B0WZFRUHXHkHy27rxwyW0F1auhEJrtzacf92ZED4b6bL7j3Mfh3JuAMkEQF1rd1v7hgQMQ/ShvhmjT5xmBzvJ5M/X53tjUU3kvJEw/GYtonZklbE9vIZIGS1CyYaOQXUwjAAB3JWNHC2YeA2r2AhgtDznigya0ZzDOtDIJr+ysCOh28EpEWmfzBpjWzCfGBzpiz5D4FyEHRd1xc3vM4hCwjmpclZyGg6LKwJgYmdOE0vO4qDDuNTny6jsf0uFGqtGfgg5ni7WSCfkNrynlG2iw0RbekKseClVlw2wCNpOHixZ2R4Ndhlv90f49lakL3ZL4zfIq/8BxAUNvLzg1MFj3u08AInMskHc71fNoIbto1aDMiA/Q7+Hgs3/ZoIsEu9ZT8lGzMIT3ub
 R4bdDKWx
 QHTqqNJ9lfGeZNu540hKFXxW5ujRDQaYrWEB/RTBIcWa8ITArXBFplArSNTw6BI6qvx97pZsyUpo6VIIErkMco7JEOJ2io52PrVcQTGeum/JYqxs27l9fGiMpe7Z3IFXwEH4WDiBGHDOccZdHkTLNvXhgT13O70F2iYJcNcH2OCKKzTuqSyfPlpsI/TUTRU708lZmStXg+EMldjer1xy37zt1iZOJ1Zxfw2gDe8YhSfgl2fWQ5hVngwxylJUwi1lkM4GcO6EQla3btwSBwpA0W4oPW1J5Ae2YA5itd6ARom4w6qZKacY8C5VVvX0s0H89uXzK/Im9ACzJvQPKt3czohCMesrlHaRlanAK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 01:10:23PM +0200, Pratyush Yadav wrote:
> On Mon, Aug 03 2026, Pranjal Shrivastava wrote:
> 
> > The current KHO page preservation APIs (e.g. kho_preserve_pages) assume
> > that multi-page blocks are split into independent 4KB pages during
> > restoration. This is incompatible with high-order non-compound pages,
> > such as DMA buffers, which must be restored with tail pages having a
> > zero reference count.
> >
> > Introduce explicit preserve and restore APIs for high-order pages,
> > which preserve and restore a high-order page block as a single unit,
> > applying a refcount of 1 to the head page while leaving tail pages at 0.
> > Rename the existing internal helper to __kho_restore_page() and
> > consolidate the common restoration code into it.
> >
> > Signed-off-by: Pranjal Shrivastava <praan@google.com>
> 
> The code here looks very convoluted TBH. I think it will be simpler to
> make kho_restore_page() only return non-compound pages. That is, it
> returns 0 or higher order non-compound page.
> 
> Then kho_restore_pages() can call kho_restore_page() and then do
> split_page() on the page it got to turn it into 0-order pages.
> kho_restore_folio() can call kho_restore_page() and then do
> prep_compound_page() on the page it got.
> 
> And then you expose kho_restore_page() to be used by DMA APIs to get
> non-compound high order pages directly.
> 
> How does that sound?
> 

I like the suggestion to use a single base primitive and mold it via
split_page() and prep_compound_page().

However, To implement this, we'll need __kho_restore_page(phys, &order)
as the internal base primitive because callers (like kho_restore_folio)
need to retrieve the order from the KHO metadata to pass into 
prep_compound_page(), and a raw non-compound struct page doesn't store 
its order.

By having __kho_restore_page() initialize the head_ref = 1 & all_tails
=0 refcount pattern by default, all three public APIs can just wrap it
and call the appropriate MM subsystem helpers. I'll spin v5 with this

Thanks,
Praan

