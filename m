Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058EB606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=fr+GItX2
Received: by kanga.kvack.org (Postfix)
	id 138956B05C6; Tue, 10 Nov 2026 00:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110996B05C7; Tue, 10 Nov 2026 00:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1ACB6B05C8; Tue, 10 Nov 2026 00:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5F966B05C6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:49:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5010214087E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:25 +0000 (UTC)
X-FDA: 85418131890.17.9B1E62D
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 629C4160004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fr+GItX2;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e1CwuUVsSjZnbMobjwr4r9fMJTFxCCqI+vgT8IsHHyE=;
	b=VAmVT35l0IsXUbCbKhGrR3wyKPeHCvHl6lf7cuA0N0vG/Jx9+0A4wLgb/NJTpn6ZtEZppK
	IHBVP4B2FjoE61tBmdw4cwwH3NkGGWUr0DeHyoM/y1esiO8f67OehPa3jCPAgNiXiar6jM
	mzaj1R0QSuNPmPP7eDDSCT1aX1LaY3I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289763;
	b=nsOA9IQIe/qWVNF8VvIEuL+i6Rp7LPAzOCPjg7cjSw6mmtYgz3nRoZbc0wT72++Ed3wm7F
	/Ud6fN3WWk+NwF7No7EU01QGk/FPV63TSdrsJXTGbBGp52Pv2EIre2V7Hlz3zK5aHUnqiK
	bKL6Q1ZntAgMXgEm09XrA5bNHWGhic4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fr+GItX2;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ed1414df17so6628605ad.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289762; x=1794894562; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e1CwuUVsSjZnbMobjwr4r9fMJTFxCCqI+vgT8IsHHyE=;
        b=fr+GItX2eQPR6gT1D53CGNPvE8b4hdy0sVWp2OSrn6kTPCZbCRn2+vGOfU3QawEY86
         IV7b2febyFGntdetb8/KDFtYGASesuGisAJqJsAwoXwuhTQ8fQpRaiV22CEIt6K/2uPg
         LrfK7apkxlKOh+Sw00cPHHzCNYf+A8JPoUhvM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289762; x=1794894562;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=e1CwuUVsSjZnbMobjwr4r9fMJTFxCCqI+vgT8IsHHyE=;
        b=vkcdKb3xOVkYL3qkyI+ePB3BFqEDpYquQXWWLDIe2bH9Iy5aCOkhlhLPXlGDP5Sz+J
         bFL9p+AqpKcqLhzrPYxryn4APYR7BqXqXc960A1JpMBrZ+yIn6T8COO6xAz+Hf2l6C8h
         n0cy1lZBkWqu7ypkL2C/g3XawiaEl8nYYfjF0EZP9s0UPU2h9hkrIicJM+AylI7UXohu
         59YhEM8yTfpA/uAiENVPNf1Ii1PdQxsfpIYRRSCd7FDLt8lWydEEjH/Vqa9ehByYk3a1
         EgLKigN3KGWXNWXpGE1TP7cNJBhWlZOjf6g9gUWstjn8ZVYkvI1ZB8DevyueqyetCpk+
         jg+g==
X-Forwarded-Encrypted: i=1; AL+hErGgNEJWudEw1ngbszEiU3UZD0WrScNjmZQDIFcnSc+u5NezRn0gTbqGYnhTEN4nbPFYmKMrCXVLhA==@kvack.org
X-Gm-Message-State: APuU4Z9a3w74w1CPRQqeUtMAYovGdnxU/QoEnw6NmOoPStLgygW+cIgf
	kR9MYaksb9zInm9X24adJoiu4TQF5f+L1CxXExtGDL4K/EHXUVcCnYBVnnrJwsrHPQ==
X-Gm-Gg: AYBFou1JyMyzSHbTujEOM2NP3V6dLWFO5NIgje7vQ9pVNsEVZ4c0Ufgt7vL1m5TisXg
	3kpFYFiAfOLZPaXPwrUC0mhi3Q9PV2yKtbMHIp65vbNeBQNWQ0O+fQVuErl/bJ8V29yj8wbj5mg
	JfTV6U/mLMwwnAJoyUIYjX7Pri7Gvbwec0Pp17WwxyszB1rwoR8dpND7kokqjD2OSN6deKkgnS6
	VgCBxbKg1uFVROd/3pjODSSPLZ0u3va7vvU1iH6HjQ3Gf44o94wmfdzfxn2AjgmwckVz8ehPayi
	WiWwp59aIA+sp8NM/MKuJIM2nUtOagx9pcVqQ0OClj4xNHsKy53+gmUZPoEfRq3A5e+tlZovTlb
	GM8C3pqwX8er32GhyVXuAsQgHeriEDAuhQqfGsNx+fuL6TBIZxvgtIgLMiE6VUaLkO1wW7XpdrK
	mnjec5DnMcUaWjLkFgJQtxss3ZdkgPGrw98BOHuzxDjYe/dIRic7ZnqZbVPugXeIgTXk17++0+l
	YG5E/2hNqrPLoYnSIW/YbINprkONZzfTQTIfKV7yBg6/P3nDag978ig8EvD9CelMfHvx/Gxqqyk
	rjqIOJASaUE/5Q5Jrc0qShc5AOjENRNHPH4EyD1Ec+5XYal/b4MRnRVAmFTyYJc1kg31sg==
X-Received: by 2002:a17:903:2a84:b0:2e5:e1de:9c3c with SMTP id d9443c01a7336-2edb91d9bfamr13050805ad.47.1794289762137;
        Mon, 09 Nov 2026 21:49:22 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d7e1c0sm4971905ad.34.2026.11.09.21.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:49:21 -0800 (PST)
Date: Tue, 10 Nov 2026 14:49:16 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] zsmalloc: redesign object alloc API
Message-ID: <avKwQ4IEOVfYm-8J@google.com>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <auy9UfB30AlYabV8@google.com>
 <CAKEwX=Nao4jWtY04FXEjxiHUNUhJU2A6nCZLqhRRm-dPBZTmcw@mail.gmail.com>
 <CAO9r8zP_K0NF0gt71Emh+2dXmUh+C27uiu5TsyBcGUdLbCus1Q@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zP_K0NF0gt71Emh+2dXmUh+C27uiu5TsyBcGUdLbCus1Q@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 629C4160004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9xaqw4kj6sn8ysnm3dz9r4gp71zft5n5
X-Rspam-User: 
X-HE-Tag: 1794289763-989483
X-HE-Meta: U2FsdGVkX18ZWHyN3ItpcQdLMpT4qE9RFOvy9Zk94nSxdu1j5GtMMr5x6GtXPYidBac1jiXx4RmLJbl9Z2uksi0TwmQNs2GohAcyyS7X+poenjJk6v/FpbCeSnh4nOBP7F5eJXga8Jhbi/NwHKku2713sZv0BcKaf+3or0JEva2fdDDZbKbZdxOiwMxYUpXQsbok2Fah4KbkQxF0aeeOB/M4dCao8me2mGzxUPzSXT3CFIXY9YXnqLvFsHsV2GTC3yshEVOmJXhUfzX0TtSVWWuBvbaleuiE6K3QxAUGXyK6Oo4APUQ29FiUPkXJbWjpNTF50K7wJBwWh1howvLByp6nyfaQrt0ofEHUeXbwCK2NnJ4cvlTYgHB8eXzHwKYVvXugCPlL7BQlVW1UeigWGlsMkMypDF6mE7j/1smG7HIiShOZiwmuJMm7tngs/k3xtPdMT2C5pM3iboczZGVkKnJPVKVVEN75N+zjPM5WH/7b76IDBZlAQvbdCb1CtHIS3S21sljTMWHo+mYi4qIabP5fO8IOqtT2RehWU+z3BOBCaAnqHgxAwIsOLh4x0Nm0mqMPbyKYb2OWUKifC5Gnp1263tdceN56YtQCWEXbcO+/8ytCkZ46sK71cIT81YtkNWRGFNNPsmq/1QUF6i8Bo8+oNrk1zX71JC7M1nsKu2apSuYgHWA7OOyDC6Eb+ysWshhlTPKe3m/jl3TrSrWayoHjQfGKeOeUAtA3rTs6Kh9y2XZ6leGW5iChR3njsUYFtlBfbVGXGswzb0hcpSfpyCvx5Gv/XoPClOa1MKg6ZXlmtfR1whVFJjMhlEFbaIIO/pIFsYpmdG+7Q81gNTa4+exCBB6EXV2X0ew2DaLvt5EewXnobUanC80u8wGx+XsvGTytXlFGAnOxRDBor9jz7Pf18oFzO3vfNwO1gCpWU0anvacP3qz3hjmtXLgnodSKFchui4U7hfH+wF0WI2E
 z4sNy0il
 q5Rxy0eX+Ydx8B1nFiSFeWhPmfsSy3hBKpkB5SXKkKuuLM076+Lrx75ZcywgGKaY/UhNItEADbT3CFHVxGRLR6xvm6qeRjXq8zUSLEJKoTvCsVISfiLMkjGBFWG3GzTvfStG10eR6iMUcPTNAJRjq2dnEgdZfCkkSFJn+rTOiSNJFSq5SQR2tVjNV2uMRE9rj4FLGHHaggckTwWMN069x2Lr+RaVXadzjYbWoHG5RklpOQeDkihaWPgoqCeW5G7qegQ8m8zxi+vZUSuT4h1az/z/zUgbT4uc8SUzbPQU2YNR9RGgiaSVr3YU8VtLqm8iEM4iCnxbMOtDKPlDmcEebIHrx5UhNbdb3lIhJCbY32fE7KxlpXw7HohwHzyaxtpc+FrMlwBUgfWRGJu7UU3BhjN/713baWbhtdMcMf3nx6H2dSYXoUe/XOZdqXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/05 09:39), Yosry Ahmed wrote:
> On Thu, Nov 5, 2026 at 9:37 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Thu, Nov 5, 2026 at 10:31 AM Yosry Ahmed <yosry@kernel.org> wrote:
> > >
> > > On Thu, Nov 05, 2026 at 01:47:30PM +0900, Sergey Senozhatsky wrote:
> > > > Both zram and zswap already have per-entry structures that store zsmalloc
> > > > handles, so allocating a separate handle_cachep object per stored page is
> > > > redundant.  This series embeds struct zs_handle directly into zram and
> > > > zswap entries and drops handle_cachep, saving 8 bytes and a slab
> > > > alloc/free per stored object (2MB per 1GB of swapped out 4K pages).
> > >
> > > I always hated that extra layer of indirection, thanks for doing this!
> >
> > +1.
> >
> > The mental load saving excites me more than the memory saving :)
> 
> Oh I am 100% supporting this just for my own mental wellbeing, the
> memory saving is the icing on the cake.

Thank you guys!

