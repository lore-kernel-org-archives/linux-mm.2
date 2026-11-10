Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9958560A2603
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=aBbioC2n
Received: by kanga.kvack.org (Postfix)
	id AE5696B05B7; Tue, 10 Nov 2026 13:30:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95D76B05B8; Tue, 10 Nov 2026 13:30:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984836B05B9; Tue, 10 Nov 2026 13:30:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7B86B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:30:02 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07D6FC0A06
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:30:02 +0000 (UTC)
X-FDA: 85420048644.04.A09C26E
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2E21720011
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:30:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=aBbioC2n;
	spf=pass (imf13.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794335400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/fDqdjeF2qNLQi3iaEH9vKqxnzXslPVSp3ugOVQ8hM=;
	b=M4rTmBPGsYh1/TpcUPf3oV0+wcjoFXPDPp74FF2EZn2xe2xsrVKfFaelHOzDVFSN/VZiwD
	W/FkSO4onlYErqrmr7ux/rIZTe8nC/pIt17LBuBJrnVT/C2miTo96hgQJynOxGHz96IaYV
	ExllBnvBrDUSzKQK5n/uuEbeP4Vyk0o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794335400;
	b=O3srtreEFOldakIpwHORIY/6lQaez1HFg9PavPgEIxdGPCGN3HUORTLobEkSW3tEdVBTKA
	lfkE3XvjiEq5WYJWQnSkOice29fm1csyhv8Z7fJDqVqs2ToOln40GzvGWkT6GycACtaOGY
	/21GxzJDV3IgEznNR9I9/NOwwfY6P4E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=aBbioC2n;
	spf=pass (imf13.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ed3f563739so3465ad.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794335399; x=1794940199; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h/fDqdjeF2qNLQi3iaEH9vKqxnzXslPVSp3ugOVQ8hM=;
        b=aBbioC2nLhBc+D3X4m3yW6N+pKSLeLFar1nqPYW1Z/QfP7Gs0Jag0rVFTBaF4VgQY8
         hN44CIEkwPNg/RrpUaYjOfXQcBSL9WpAhtNi6YtxoJgG8YdzTgzNwoMSgYrlImGpqNFx
         9VN14XouleVqQjsrgFwV1LkUPm6b9bURnm/3oa8SeDthFIYkNvi9v84adK4+jbUacMGZ
         tdCX7n6y4SGucnMEWIKygQadRE7MhCTmcgPATMrWBdGDWZT1m0eIz8KiZ1v2kw8qIalg
         tenWAZlZ85KqVDI9LM2gCxQRjcL+7W4xLwKuUpVVhvDxkRrqKcWVCtzMNYyvh/NmoqQo
         QtQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794335399; x=1794940199;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h/fDqdjeF2qNLQi3iaEH9vKqxnzXslPVSp3ugOVQ8hM=;
        b=Ue24GYVMBD+9g3yfawWj3ld2+aGZmQVNqrGbf+4Y/1C28cAheKF6EOqgbJuQoMSBTz
         oPSuJGdoRRpBso1x78Lgg149heqCNkkFOYbLHfoTz2JSehzKOIdKDRTM4noSj49rEcz2
         0r9h3rSLg4qJaPA8astjsunldI1CTY5mzPKqniAfUaB/LwDZ7LAfYwBFbr3Pd6ekTmMZ
         pQqauoqQt6jFn6Nrce1qR1ULsPplFcDf3X5dzsyUxqI0ALad2GP+XazYs9ZDFKHlooyI
         bemF/r6HJgB3/uAwH0aVhY7SLLjHeh87X8VEzQxdPvSBp2tjNesEuq1DllFog3SozWb9
         FSog==
X-Forwarded-Encrypted: i=1; AL+hErG1oRBVBb0K2aXDaTuyAYsK5CYt8jbRJ8VNW+gFe79jP0VC+uyyaYxY+p9WDVFg1P7JWtI7pK/+cg==@kvack.org
X-Gm-Message-State: APuU4Z8ChZc3ioRVRo9cCmx7GqbR8hns7tSGV7iG1yLKNOX47dsf1Brf
	AGnrMU19sTp8X6ZEBUTcszM3U+zVA+9WlBZmY6vZGiyQrQL8W1RR/eJ2HTW256TBHg==
X-Gm-Gg: AYBFou03qjn0rSGwjKwASkrj7l2Wp28kRjb4XecY1G3FVhovZ86wUBnvRUYFCe4wbDO
	ZGtZrt1hz88uDeT6dKRokz5AZwilqtnrUAuJmUgnbOzZIeuEVXfj8SyRTfADdFaZnYiWOpKoqXs
	c2UUextVSHD7tqOmBO72nUXpnj3xRZabDp4dwH1rCqNdL61+fHx6MiuxjF5K6NyF+WC8/Ba0BR9
	RxUraQxOT1jFe+eU9SOLvDAkz0sKDNOkmpoh+1RLUmSlfhxse6TYddBe8yhfVTDtZ7yMx94IGgR
	kupabny9+gLFOCVRpnX1EdLkY3fk39iHxeNP59rUpnT/QRjJT/9vZ+S1zxzHHOIOqjBWv3EM9f0
	SiOB6BRvqG1xdh9G53k3eWcNKeZM8OQ50UVy3jbNSiIljSBc79x5vdTmv9CnZGnXWCiIEOqLgv4
	LEKNzpSGKOzMwZVZKXxG1fylV//3EYfobla/xcGGQUpUXLBz8CLHsBimlvf+F/+kzVWfAIxA1XW
	/kwUpJoDAxlFl5a1pWwPoCxFYpcwkrsRvSGMhX29bTU/ofDN6C3l1M719pM1VpzKeHWQplSNXDP
	iQ103APY2SjKKbkx8cV6mBwl7JWkvmWCwHUZJTVQUVw++sgye2kwedgPYwE69sWR+S1Z0VkHJLs
	Hzc0U6fDIkQevQjQfu1A0Abfeccu9ntZBxJoFE05LA2w=
X-Received: by 2002:a17:902:ce04:b0:2c9:b404:b55 with SMTP id d9443c01a7336-2edb81c27e3mr6143235ad.6.1794335398359;
        Tue, 10 Nov 2026 10:29:58 -0800 (PST)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6a4013csm12795005ad.1.2026.11.10.10.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:29:57 -0800 (PST)
Date: Tue, 10 Nov 2026 18:29:54 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] liveupdate: luo_file: allow keeping private_data
 from retrieve until finish
Message-ID: <avNilY9saqTlNZNn@google.com>
References: <20261110175855.2437084-1-pratyush@kernel.org>
 <20261110175855.2437084-2-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261110175855.2437084-2-pratyush@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: g1cnbqbwc9go84upixekak5yedgfhckr
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 2E21720011
X-Rspam-User: 
X-HE-Tag: 1794335400-463291
X-HE-Meta: U2FsdGVkX19fWl7WveejUBBnBY1fUGOoICrVe+Mi9T/4htiOL7porgTYW5zQFfOG+iS9p72w18p2i68ISRxFysAl/KSaFki+RBZvEYBo27pe2Al/6HMKvxqgdzXH5KcZD4JdMAvhbHKQjnJmDAWgJvt455zdVBopyVUyS3WS68+3rhO5EeGNVNJ+PUeNX64NTk6ib9HazhTXbpKn3Md9bIzobP6wGaQPEWhgfIUrVo1Y2P56Joe3X6pUwm9pY3mNi7xUftP9NFA+qdGROYiSEaQZpyTWRY4wFdAujcO6QsKDBf+mO3ve1NQOzR2BlC36aE+hjBo18uO3nyVjfqdhkL2Qkh9v438HP5NAtcACVJBd9ujRAMKvI4Z+f1MrqU6d+BD0fvZng3VqHwaAmGX3gbJoVmWEPUNhXY4jLmsHdFcBveu2OUk2ljbGGDlYuvuKn6L31fNrzND44w20CLTg6sXcV8YoGPt1aTW0uvW5tMVAX05aAifH7ubE3moEr2jHftXtyehLe8o3pWx6svWnAcktpLvZFn5LJt4DrOLTzTpyyWz/WpTtS+4TWV5VIQOwY4QHSNXJeZDI2xNCzWt504dyAzT5CiQoKB4ytqBZizpZeSiLbqYZQnysW9MeS/vnFKm5709pTrhcqpwdttNrMEIKiqB6+YZBtoExBU4cEQnqu+yvMjSWZi0HsFP9D5a1WsLVdC2TLRU5zFiiLWXjiP5Sqsxyc6w6F+4QhC7O7ergDl/TVStF8151cxvOiZzvD8oCh3iJ4/0HJ+CuSLwTi090J5jxZ0VvnP8er+/8rteKd/t/g85rXVyOUsrEf2XyO6vQUoBsBhWdxAJukE9NoKEYFXUIltUpzIXPG8o6X14EjegZhErsZEp/Kd6RiB4irTIAH99qFAk5FcD9rMB1kqg/EE0ztharyxiL1j8jdL4Y+meJmU3vo6t23bsZVbPeEf/J2fMBQGxEbVFsN8J
 B4cNdloX
 YOTzzwBWgF42Aq1pC1yHoJ5HCtDF3YQe+kQPmL/B8WSaKrJz0tlRNwinl+xPN4I5ukJNMXJZwS3S7sqfDXTZyFEulW0TDvKDzSm9mgOzsLvQTx4Y5YULLPbnKM02EzF3gP3SGj7t6R+/StTfxcmmz6yJK5IoiqtvANVHAzwEWD7EhETuZbNN1UftWnEjTedbpR6U8iSEtP4sWxVuk1+HeYvSHcbWYQuq54eKI6uJpE3xelo4lynSejr0WZsJLIrRVur6g7AJRSlgWBG/V79iG3vzgyMuBe2hVOK5PFFpJsmIQk5sb2tsQomRAgx20cPfrCZ2pniqXy2BKhvKJNCXoSbYyNVgx+xx+3UNFHRMNgM0eXUJdsHQbwL5rB5a+s7Vu94LmpIiRs7hmEi3NmGoeYNLyonCR3nTsNKIFCLrRHamBeZ0jorp45UDauS4sH7WAKLnz/jPo6NfgoDCpIx9qbdhPemPkMUlFch6e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 06:58:52PM +0100, Pratyush Yadav wrote:
>From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
>The private_data field of struct liveupdate_file_op_args lets file
>handlers keep runtime state that is not preserved. It is set by
>.preserve() and passed to the later outgoing callbacks, up to
>.unpreserve(). But in the new kernel, nothing set by .retrieve() is
>kept, and .can_finish() and .finish() always get a NULL private_data.
>
>Handlers might need to keep runtime state from retrieve until finish.
>For example, memfd will need to remember the folios it holds on to
>until finish so it can release them there.
>
>Save the private_data set by a successful .retrieve() in the luo_file,
>and pass it to .can_finish() and .finish(). The handler must free it in
>.finish().
>
>While at it, update a stale comment under struct
>liveupdate_file_op_args. There is no 'data', but there is
>'serialized_data' and 'private_data'. Refer to them instead.
>
>Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>---
> include/linux/liveupdate.h   | 11 +++++++----
> kernel/liveupdate/luo_file.c | 11 ++++++++---
> 2 files changed, 15 insertions(+), 7 deletions(-)
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

