Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B47CA600E
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 10:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC476B008A; Thu,  8 Oct 2026 06:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5363B6B008C; Thu,  8 Oct 2026 06:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FDA06B0092; Thu,  8 Oct 2026 06:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A0546B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:03:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3A551C3109
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:03:46 +0000 (UTC)
X-FDA: 85299022452.22.F73C564
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 192ED20006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:03:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hpqj7e9p;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791453825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpUiMVYggDHC60dcd+5OU1osGuMwZpbWqR6frOfrR9k=;
	b=FS1ladc62R096EXdFGXKRnyTiPE/+uudC0gCWfHhBQGWoDtB718y7pqjlX8KnLr8mpLDlT
	pfy+FAs/af+/SNPDinYgMI9FVZH15eL/czRnEpLmeXb0BtFlBD7QPKdQnSot25Uoat/zEf
	+z6nkexC1FDciduP+A1YEeMfwW1CYJ0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hpqj7e9p;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791453825;
	b=y6JcvS7X4qhLy9WMZaicr+276YvGCgTkS5XZmx3aOsxWGzSaBhZV0hAspB54IkCKgtLlmC
	fzo6LnguDrdij6nP1vd3zHXjlqu9O5CxdAi9TgdZFP2ni1kwR8/W+WVq0cMIElZ9krUfsp
	lD3GEtE567JxQqW2FKpDP8ioQEEKvRY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E75A2414EF;
	Thu,  8 Oct 2026 10:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9888C1F00893;
	Thu,  8 Oct 2026 10:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791453823;
	bh=hpUiMVYggDHC60dcd+5OU1osGuMwZpbWqR6frOfrR9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hpqj7e9paR3mLUgx+I9fl3recU/uXrRAyWLlziTybAbQAZv3w4wLaBb349DuynC9F
	 gpU0/ybWFt+MegvClIbMPIlw+5jwM835m4w4fgQLQo9mCFIWLglqVGCAKfkWNs4tT4
	 BgdItEHFcwTpVS6UDVKECTXb3fzziR2cBA2x3BAkCipd5RIfqfIHQZ0ev1deRk1NS5
	 aL4aIq4+KdrP5LitbApMC6W75iQC/uHL1CsV5g07gKFQVd6EBMnCgOGxPhJ3lMvBV1
	 uq4rLCfDywOjVRNNzN1t7ij7pcko4oyb08JxMc8sd3gLXcgeh0BiwQDl3UoB85Yf27
	 mEYh1YaM0IdWg==
Date: Thu, 8 Oct 2026 12:03:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: tarunsahu@google.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, dmatlack@google.com,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	dev.jain@arm.com, Pratyush Yadav <pratyush@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 2/2] memblock: use binary search to locate candidate
 regions
Message-ID: <asdqetdGMXGhtiBh@kernel.org>
References: <20260926092448.4090401-1-tarunsahu@google.com>
 <20260926092448.4090401-2-tarunsahu@google.com>
 <asC1FwHVHOhBHDGK@kernel.org>
 <9huzy0c9siyn.fsf@tarunix.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9huzy0c9siyn.fsf@tarunix.c.googlers.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 192ED20006
X-Stat-Signature: jmejbmckg5fzws4umb5dd58j8b9ijxm4
X-HE-Tag: 1791453824-371923
X-HE-Meta: U2FsdGVkX1+68pE6Yf5+mgQ69IoImOIp82K8jwRBaf4iBoCEImPKHSy0guc+rV9kK2Q/Cnv2BVdBF7QmEkSR/hLe+NK/iuLWZFKprKcJH1rsOAKg5mUndENNtSWmFgSLkHS47ffiDc+3T4RWZWDUV7NqnoEqwCYBWeQhsUmy57S0JJKITL5KB8DbjQlRXf5dFfgx52uukLQT8RNPJaRT8Q8uWAVM8KxT+qqlxGVDLM7dMJAv8JW8SWYm9DVre/N3+6qcF217lReFS+4MneKEEZ51tG1S5x29G9N7zsYox4iKe9nRL34Ix/+vbLd7KC2113UNO6p6/1AlnZOA8Dp5cglekRmxOGvfYpt54Ffg6DQj097uwml2jnQcavP1dlfuwsLc4XPQvVmGOfcZ2HCyAqrH1VYsKDnVeUknL9XAI+X3v9CFPD8VNHYqPvRVcQOCgstbr00NzYqUPexpzbep/4OiTo7cT0etQ1+70zRnWxkKu+UHk11CBLEi/xUWQ6PZikyenaCB38QGxPYyidW/e/AOrau1NaSsFf2ql67LAWBrL/KIXRbFLhOVx7DuyoBwvRe442kaZD5g71YfPu7ryz4yIOzU/3IwM8h2YXX5Rg0M6LVlujmLNYh+7Zr8uvZocOzQf91DjIvEjL+cKcQbtCAqmqNJBmnVbQxaB2KdzQJfk/X7Td0ff35Xjs6AHB6LvO1EHTtel74V/QXdiWVPUTYaLJtZ0VeFC1eOYr8vpBUCPwStovh9ajs03aZV57Nv2R+2xHkNpKsnIKKLcJtDpjXbepAkFumifQGU2uhaJ5lB5k8h7qYnHvrJ6kjY0jvks2qWNqQs8fqD6iWBL9OJ9XBCtcErTUEKRjOFYTEm6U1SMuNIMI0iEUJYsPDGBJmqbrTifdaML7uchKi8CCrUqzwQ1NSU0++WTnF36+ezspgQQ6Uyk795M5g4OjSvVEzXhAzAspX4UojHVpeyivm
 yqPjhxUJ
 CO/yVbW5BwEpuGMPuPmHZPvbiuvfMRJKe4zwdnblZptxC4Wm0n6o7WKkZF47v02ZliFRv1XxpJyOl66AA59kLcKop5N2xzO1QvN54APWch5v00AYW+Smhgfr4SW9nQo6n9FejZbU4RPTVTx39PEktDCOs0O+Hqu7JN8JmJYz0msNJdx5Q+X4+zWL0j9Bu9hdEKJYjoY2mRrKrRK08CNuJJGs+iFm8EUFkIHWReN0oBzD6fj1FOSbiq//O+AeUIcuv7vUhmBDuUDNGK+h9cto2FKm3MQrJltSaJjuOcVGzpXjCkmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 07, 2026 at 02:06:56PM +0000, tarunsahu@google.com wrote:
> Mike Rapoport <rppt@kernel.org> writes:
>
> >> +{
> >> +	int mid, low = 0;
> >> +	int high = type->cnt;
> >> +
> >> +	if (type->cnt && base >= type->regions[type->cnt - 1].base +
> >> +				 type->regions[type->cnt - 1].size)
> >> +		return type->cnt;
> >
> > Using local variables would make it more readable IMHO.
> 
> removing this as per next comment. Let me know what you think? Should we
> keep this optimization or not.

Yeah, that's fine :)
 
> ~Tarun

-- 
Sincerely yours,
Mike.

