Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8BAECD342C
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 00:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016F06B0088; Mon,  4 May 2026 20:30:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30136B009B; Mon,  4 May 2026 20:30:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D3E6B009D; Mon,  4 May 2026 20:30:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D657A6B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:30:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A1AB61C0CCD
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:30:06 +0000 (UTC)
X-FDA: 84731484012.17.E175518
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id C2BC7180002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:30:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D7Vbe4YI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777941004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJ2Sv+3oMbNngKzUZrpFVSbPEqlLqAid/lINt850Zv4=;
	b=Qk54z+wfqqOOuVLbXO2DlloMxqbahmTJ9dK4SXEqQ3W73tRLiAvK2VdDAakZW04vJGHJml
	hkSoOlW0L3WC7xhRBKXZX8A/Ul2GjBHiBsGWI0WyI0B0qA4d3ZBnD4bjvd+PvH30oddBnY
	Z4P8DuRXlsC/enAMPb77IA2yyjv1N+8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777941004; a=rsa-sha256;
	cv=none;
	b=8QYuXKVJxxH+4PP1/nZrvgqb+HC2aAt0YbV3oK0nGW+pzse0NoRtXSZg8zWuF+zL8s6qGX
	x4w3GfTd+MmY0yX24IMhSOhtQXl4ZNeAUgMm4RUEo6qhrKa8hbopJwFnVtHohIpPrTrKBZ
	U3i3Ycg5rvjW4VmVL6gPdGc9iC7Ekjk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D7Vbe4YI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=skhawaja@google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso23445ad.0
        for <linux-mm@kvack.org>; Mon, 04 May 2026 17:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777941003; x=1778545803; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mJ2Sv+3oMbNngKzUZrpFVSbPEqlLqAid/lINt850Zv4=;
        b=D7Vbe4YI9UxBmvlLCATditkzuG0YMWntDr+8N+WIo6kE3Db3cOiqw+xkUeBgyOebgW
         yqXwqUi2J8yhVAInBqxqJUzPYgaGJ0ukElFRCK9bqO47N/tqOCW9CNfLUdr1QJpNy+gG
         wbfl3NVD7AAIHcxvLWd4JffOPyYydZXvgTlE3NNFck9Do+N6mEICC1K0RXfe1N8Dquyx
         3MHS7syjIxupRO4Gd6YvoDy6J4IBy5uRnbP5f7LAyCYa3I1EBBqzMsIlLsOdMHCUekte
         1RC1T1n4aW7MWUjPWhgpogDe9BeA7ajpgPUUBBNL8BH3PxLZjxHFRVSng4SU9IQ2axQh
         v1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777941003; x=1778545803;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mJ2Sv+3oMbNngKzUZrpFVSbPEqlLqAid/lINt850Zv4=;
        b=Cc/nODJu3lVXEeD16M2G8jGcw6kztzlWNywfF14axVH3dyyPCc0Rwga3pWSfHXWJZr
         1Q5w+N4W+LuPEjYc0t+U0ujxXxDs/9n2Z8XU7dTKU4lZgAUgzAKaOASBXIbxA4Rf2HxD
         lrBcSfzH4bkpgdSY4P8b//mZWeJKNICraHfJ3ONUu8f1sFElAIPhnP+B9WBdlfxvm/Eu
         Nur6XxRSCFSUhIEffnlcNfayL6kXzPzEQQQte9caVhl3Sq/a5WQX+OV/zK/nNILauGa8
         hH5CNh/4HlBG/BWef5HiZbCQ93MuqAoXvEpVo4N+CDWCUzm139l5w25eTPa/332dgn+e
         gh8g==
X-Forwarded-Encrypted: i=1; AFNElJ/5VZqRWUaLQpUCTRPCS5is+dEYe2jEz3Z1nQ6ROsf8VJAheMbB875PwoUug/SNec6LbB0KVWPWJQ==@kvack.org
X-Gm-Message-State: AOJu0YzVI2pTk/QDROw0uq5DCbdsbvr0sf0P1EZ2ilg1sHD5i01OB//6
	3DKIpe3D/iaOVDFLi6I8RFG1h0P8pMc68t+ZLpXlI0Vea3boBEE/REIOhKNROSYOBQ==
X-Gm-Gg: AeBDieupn60p56MaJqkxoWqhj6eiNc9lFq0nGHDoPvkvHzToJp2lcULtEu3ufb79RMO
	MVyOPiK41uvFvmMJ737Ygr4P9xxo33Wph2DJj/7VlJdgkvO8eEYPkFKczPVMlw4tCKOHMjyliEn
	N3GQoD53NyEhWMdtO0A4YN05HS4FRhFkFTR5MZfNjCytM6eYdbDwGuNoEjavbCfinuGIPl8CFoF
	Lw4UFfEXNgg9chjiAjq1rCwuGhW/e5pAzFS/HOngPxNL+g/YP96m6KUyrFznTUxCBEUSwcEV9DB
	XkcLGHUP3H26v4CtEUZhPg51eHqJ3JWsTDkW4DZWZt4PzDUXy93avr0ypHhuKuSS0QCEApCRnUD
	L2TTb4WOQLlWcOozUucNhvphAxDYDNfdzhJ7oTUhyxid2k4Zh7FUSDTjadTep1BsgpSLdoRfgVB
	u0UXK6NUcnf6IfrCJM343H+TTQqPuxIM6BdPv7xa5DoVT9XQQ9gPBI+S3b6YnJ7DY7S37iaBHxL
	z5pbpeWKoSm4Rr1TjyNOw==
X-Received: by 2002:a17:903:46c5:b0:2b7:b03d:9dce with SMTP id d9443c01a7336-2ba4f9cf2d3mr1830885ad.18.1777941003113;
        Mon, 04 May 2026 17:30:03 -0700 (PDT)
Received: from google.com (195.236.83.34.bc.googleusercontent.com. [34.83.236.195])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9cae110acsm107750285ad.42.2026.05.04.17.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 17:30:02 -0700 (PDT)
Date: Tue, 5 May 2026 00:29:58 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, 
	Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH 0/4] dma-mapping: Add preservation of direct
 allocations
Message-ID: <afk5m8xwYqNstzPw@google.com>
References: <20260505002320.2210067-1-skhawaja@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260505002320.2210067-1-skhawaja@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C2BC7180002
X-Stat-Signature: ktbtx74dnqf5p7fie39ruejg1fbhzkb3
X-Rspam-User: 
X-HE-Tag: 1777941004-134672
X-HE-Meta: U2FsdGVkX1/11qm9frkmTqafQXscr0ZRJCL43bKe0sDBFfR2WuGAsPQObzBNh1zXHLHRv90X2XBXoYzp8pPP1sGdTqsA6DRFxwGBPOWExNeP2AghFNQvjMMWi+byqkUfrGaA/g/dyWjzkJqcri0XORCbK9YGjuDhcZRAOYEUn4suH3H0BZtz1DjfhMH6I3F31fIPMCRNFFK8L+/l3GV0NxUZP98LBchXFwlf3J5syEhnP7zexgJCy0AVfqBmG2ij/V3k2Th+a/XKF3ecMt9BmIew0BiyKXNXLgj0dGRv8PTN6mN06YoxxPQCUMv/R6wkwGU9lIDzY9QTik1YiLF58+amiKIIBFGNCdWCW4v1U4srKXJbQ5VJTrCGWaB6JNuZ72T94UB7MJ4ktigThH2m0OIwc46y5I7KWXcf3PT/NcVykElaRaKzZEg9hl02Ia5icrhI+RgsPlBYcOiMkaN9Eyxngys+VyPWaHhGWXn9TQuyg/ihVxEzQiSv53JK7EmfofFBnh4jM6DrVvOLP5rVSUc4rKdH3xue5aA5IOftgItTwHI+y8NMuugbbFM+1UvkBPy4kvDhUnaZFwyNnlypMGtzIaKIbaZW54wo1QBB9tRKStv7t6JNylpFzVZIfcPQZrB5Aw3uQr20hYyzBBfhyFvG1y+iHIr4A63QPbopEOhWpHls4iK4jTexeWSyHzU72DxhuOpCd+57oCSf/tMCn3epVRIiLOKE38SyZd7k83JNAwrpWGk0tsQSqHpiLKQcjbaDOrjZWAjxSsNZS/PmezYagSxC5x8xUwXmSb8t56QLOUbGxfXdBTPKZL0VSquQy542dPPLUmrsN0HEv5v8hFiWvfhJmwZpC3hv2iLQId5+X/IW82FWDd3GA2mN2C219XmnUyflwsX1UCpedbc7iV5mMyNtR1kPGE14/5ZicEucZGpixhK1TKAsyIdSaD0hv2p/nHbfSQIK4cDZUDo
 +0CY5Ar+
 SeRRyKL2zJfgKXCE32JpDURWlVsgctyYpwSeMZWxmD28DdwV87VsHeqgGy/OjLl8pMihH+Z3ZtU9QTFxaH3sGPk5JAjdwtvJozPTPFskR9Db215uExDK8dWM+DYb0H6WSFJ9xDZHlWOJER1ZK/OE+6kvoH6gA2Rhf1rnp/N2b4Yfi1BgHeId4edQxjkYQ0YjdfDPkyjXijcQ0OTsZvf64xZE0NMUzMtW8+MvUXP3WUk3UksQg01Fyvdnu80WTzXOFeLAt06ociSRshNcc4ve3c7vldFpq5pwhrapM6svt8eZyRSu4PFlX4qB4H1KdnhuTmFVqjx5iO7PPhzA6bnOCSNtnn+wUdWlimFrGnEC/DIwbDiAnW3SmZ4DBj5YbGK5FczEwiZmgevKnw/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 12:23:16AM +0000, Samiullah Khawaja wrote:
>This is an RFC to discuss the preservation of DMA allocations for
>devices that are using direct allocation mode. Note preservation here
>means preservation of physical memory only using KHO. IOVAs and IOMMU
>mappings are out of scope.
>

Sorry, please ignore this separate cover letter email. It was sent by
mistake and has wrong prerequisite-patch-id.

