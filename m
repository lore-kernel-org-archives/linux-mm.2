Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 370BCC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 22:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AE1A6B00C3; Wed, 22 Jul 2026 18:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35EF96B00C4; Wed, 22 Jul 2026 18:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277C46B00C5; Wed, 22 Jul 2026 18:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2C066B00C3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:54:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8044214032C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:54:06 +0000 (UTC)
X-FDA: 85017917292.09.19BD2E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4E06540003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:54:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0+cFNP5V;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784760844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZH0UCJW2OUCFvq2mZvsq/vH6LEHSHRw0NfCnh2a/1c=;
	b=DkjHwzXLter9dtC+34uU8EAruYRQxXh9K2sKGoIWwaqKYaDhvp/7QDKIYyiODnqllUySRq
	eGoVf0EzseZ0CA9ZKOdBbHacAhGJ8JqivyYaKdT1/nuwY9OU7VTATdryUCXDrJGMUm31+e
	SzJKXBwMhKZE3lTegJSIhPoCjlxMbp4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784760844;
	b=62R0g8yt7Qgu7se9nOFOlDbMeYxW2co11V/wbXc3vO2TFHPEi5uEno7+e0opuZ+dElk5Om
	Z9HkFl+v7bROCTCGj1wI31OTfqL2zJtz0U+OEb8D9fqHtVGEySzcvJtaQ5zuuy+sKEC+qW
	vovauVU3deUmPae56XBvHXmMCfWp/qo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0+cFNP5V;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AA31600AB;
	Wed, 22 Jul 2026 22:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42431F000E9;
	Wed, 22 Jul 2026 22:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784760843;
	bh=ZZH0UCJW2OUCFvq2mZvsq/vH6LEHSHRw0NfCnh2a/1c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0+cFNP5VCjlcHpDbvEpfxcNnlP3pj6eAQgM+HLiNXa+SMAGtEo5bRYzNZS+dsUwUy
	 1hTF41aqNo2etfxJz3CBoyRGO1uyg8rQ5p3k9ozOGm/t2ct6lEVcxf3InCdxoT1kvR
	 vZsrxWbd+qHtRph7/Wt70Lxwo7znJ/n89iyKB1+U=
Date: Wed, 22 Jul 2026 15:54:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: pratmal@google.com
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, David Hildenbrand
 <david@redhat.com>, Vlastimil Babka <vbabka@kernel.org>, Greg Thelen
 <gthelen@google.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_reporting: Add page_reporting_delay_ms
 sysctl
Message-Id: <20260722155402.f313e8a98615bd3b513221eb@linux-foundation.org>
In-Reply-To: <20260722211517.1898228-1-pratmal@google.com>
References: <20260722211517.1898228-1-pratmal@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mrg5q3z7e8kosetgix8xnzfb1hhredc7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E06540003
X-HE-Tag: 1784760844-801479
X-HE-Meta: U2FsdGVkX19v7g/DG+v/I0sYO6aCLygBZgSg4LKoPecMVlrPe1QfHgWAfTokBD6RFuog94GqyE6dEhCaJ9ZMLiDSrp19lsUBKaYKpbZxP1qiwBTGEwWwb3iY/AeM0I/E0dFd3LLX469CrcmFqWTiAOoT1Pz4FT/uYZ0UbG+DvIDFocqjbh0A79hknxPr94Fp3y11BLPVoLe/IzJ4f8ptlihyD2tRgqFoywrZ60Dk1PyYy/TYjFxZbPjfwkdGue89HaoCsODgG816ULCz1kgClj5Ne8IzRZFK0bELfk7R7eaYpk8LZQr106I5fKI0LnKqdztGKP7TbHtFP578hOMGu5FGO9yFQDKu7fIkcB8U569M9oyHEp272KvPpRAHjg7/dCHVCwZGmri4QAtqpsTqxRHysEKvTR7eRCB4AlbvM9cvixa8d7zVBQJEgbA6W/bKWKiNuMA4DTm7Ug+U6qqmb6U7P6Ba0yZx6FNzbvsQs+oRMYokqZzBKVnrlN2TVghj4stvMSCEU1SzYUH++wFk/GrRf59Dy317jcxFKMXt+xU15v+jEhFh5fXYdgNDrXCF0eIbiNJ7QBeA0v24nirT16y8RrWg2mIx/A7CSdilSVtRFmoDImyfkQS3Xekod37w3LGVbb1DKeJ+cOrcorfBszGtLzG6luht1EHGlxNMbMZHVXtRWx6LgZz/blXGT/rbDeu9k+fkVtE4Xj3LGK6Vw0hceigeY1D2n2GA9EI7s76NjrLUK8/3yRAWNg16J7AytGit+7vPQ51GRwW0wD/frgoWlkfgKoQxI559QbklzuZYhylhKaosGhw283LmwQJZgtl4H5sLlo043fSRNPPKXP44+jH90YQCd1v0zFPEDwV6DEgQb7wGYR4jXciNYPN9+nxUpdeRf7GCgTrgV679RblTkF4dQl89mjor8UVv4phk/brl2G2LUqwDjKPR7VUhDtafAJDUyjfkisrXCqr
 8uLwm4hK
 14XbP8bwcPzCdF314sJBEDGx9VTSSenMio4BinTCVAdKEDmwcwWveoYx5+q5nh3Ddb2G/gCMsA8a3fWNU/563x2QPLOjW/XLygXbpZzF/Eo8BNzL/FokgvIdvYPnrHBtzrnmOTSdRaQLd4DWFcOn6HOsQz3fesj4oe3BFv1jRKksTY7v7LLI48ysAXS2qyVsoffmVSpu1MpIuaNimNCHaNU1tX6rZQHCSwyMqW3V3eZiUTNE4bGCT3Gw2Wsmk574PyKSpd9foERluFSUWVuiCfs8JIP8yxPrXL7iaue+NurM2C6UTaTUzBF01bopaiwUzpRwM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 21:15:17 +0000 pratmal@google.com wrote:

> From: Pratyush Mallick <pratmal@google.com>
> 
> Currently, the free page reporting daemon uses a hardcoded delay of
> (2 HZ) between reporting intervals. While this is a reasonable
> default, it lacks the flexibility to adapt to varying guest workloads.
> 
> A low delay allows aggressive memory reclamation, returning unused
> pages to the host as quickly as possible. However, during spiky
> allocation/free churn, this immediate reporting can lead to a severe
> performance penalty (nested page faults) as the guest re-allocates memory
> that the host has just unmapped. In these scenarios, there is benefit
> from increasing the delay to batch free pages over a longer window,
> absorbing the churn without hypercall and re-fault overhead.
> 
> This patch refactors the delay into a dynamically tunable sysctl,
> /proc/sys/vm/page_reporting_delay_ms, measured in milliseconds. The value
> defaults to 2000ms to precisely match the original (2 HZ) behavior.
> 

Seems reasonable.

> +The default value is 2000 (2 seconds). The minimum allowed value is
> +0 (immediate reporting) and the maximum allowed value is 10000 (10 seconds).

Why implement a max?  If setting it to something enormous causes bad
behavior then Don't Do That?


