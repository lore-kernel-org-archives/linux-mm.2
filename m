Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97661CCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 00:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B58F18E0007; Wed,  5 Nov 2025 19:29:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30558E0002; Wed,  5 Nov 2025 19:29:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6DB08E0007; Wed,  5 Nov 2025 19:29:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91F898E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:29:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36E7313B20B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 00:29:57 +0000 (UTC)
X-FDA: 84078299634.24.8917653
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8E4DD100006
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 00:29:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rCAYbZ0o;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762388995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZcPB0QBEU3KQ/VJeADun8Kir6dAYrtPJixr32O5y+v0=;
	b=bE5Ung7Vi6+PRusIwG6/rN/xiMJ9x9SvCmXSEtwUIlh1jSX2cCk1gMplMqWSsD7imP+LCs
	Oiqx1sYNHrNwVRu2gZfJfA0fs0BW5G7G2A1yhNBWUQLqe37oSJAcVLJ63kdTnMQQkzr9oC
	O7q/MQf4T7iUU4axpz7+L0H2QTsUn3w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762388995; a=rsa-sha256;
	cv=none;
	b=tpy/PQVt078QVMM8GM3R7wEBjAjsuSvGXJ0LJplFQiTwhahZND3WlLWI/6J72WDZJsZbV0
	X3/65y9RrpfegA4YFNEPo2xo5WCRgy7c1H3S35eld2aj6eZKk8/AxtP75ukwW7ZjAhynxe
	mIx5kKZlLAC2ErBqlGaIUdULf0DSt8M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rCAYbZ0o;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DCD4460051;
	Thu,  6 Nov 2025 00:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFD3C4CEF5;
	Thu,  6 Nov 2025 00:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762388994;
	bh=ZcPB0QBEU3KQ/VJeADun8Kir6dAYrtPJixr32O5y+v0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rCAYbZ0o4jmwVPrOa5mtARXv6KWnR+npkr2hdKClZjVNtqL7xgeAzod+gE0q39gTB
	 w6fGkilG8LlCfZmtDr1AZwh/zIBcrmzolCfmCX3YbkJxpuMLv1pkEPbk4LeP01vyJI
	 JMYzQM6K84CqYWz65UdGfl1ejf5oAYytpdL1b+sQ=
Date: Wed, 5 Nov 2025 16:29:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Li <chrisl@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, Kemeng Shi
 <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
 <baohua@kernel.org>
Subject: Re: [PATCH v2 3/5] mm, swap: Remove redundant comment for
 read_swap_cache_async
Message-Id: <20251105162953.74b38e11ad1a28093e751822@linux-foundation.org>
In-Reply-To: <CACePvbVydfq5DFP4R3tKXtN-UmZNQJMxm-p-4+fYFwyPfLR9cw@mail.gmail.com>
References: <20251031065011.40863-1-youngjun.park@lge.com>
	<20251031065011.40863-4-youngjun.park@lge.com>
	<CACePvbXO8oSH+-igG1pNFueB5JdoDOadV0n9DNN++iMWgCDiPA@mail.gmail.com>
	<CACePvbVydfq5DFP4R3tKXtN-UmZNQJMxm-p-4+fYFwyPfLR9cw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8E4DD100006
X-Stat-Signature: d6hrc5o1bnapg5zefkmiy65bahqeq8no
X-Rspam-User: 
X-HE-Tag: 1762388995-615120
X-HE-Meta: U2FsdGVkX18LhOwDetS1ogfzeqolko2K5QmLLR7EFT2LlqelSL4Y1ZAeo05cs7fIfc0SE4JIyAUNBgFdNKsWACLZWhtTUIx+1iJoFVE1ulKmyUbVq+iTla1NTrtrUAnViLYvX0Kp1wYO7ZJTUv1sw07crEpZu5/BwqRnc6GIqfiU2U5pDOFGE6f8YsxzsjD7y9Yg6CuKLCZfex4RLZxIjfl77hrckHe0bM/sbRX36L9lAo3CLCX7XoCnWwnYTG1hPCY6Gx6zZWgHFe6KaA0Srk51h+9bzjLuOqgmiSXnXS2gfLLggzEuy4fdABZcIxxSU3GIOQk912Y5HzNHa1M2daqmgIIoBwXD0vkFGDkG9l3pnLTADOiB3uiB7HVUKkzunlDeSobCKl6nqIvHItvPUTpgtglqYlADzC97/U8fNZK9u5n9VNBQB9X7y0FdAI2EzZMXmcL8lKjtndWlQPs3vJJkfzjft+TUXgIon4s/NxQXh0Rn1Vv2uaEODDxUu/vA8CQDNASxB616/ZYuvmkowvlCo14XYhhG7+Bp9AILLcGxD69kcBFA1dK/z+So+YTe66IFldzTicizQMzVNiCGpkLUskuz2ARH7zwsiL/4y3lrSAB7IjRdC7PutEJ7jDQ9DX2qotfKLvrFjH+ZXwATRWgLt3vKYDO0OQ12NXfoSFnhzqOytTrKYzKbOU4cdj6r3ZR4t1CqgAJQlqRqsjkjgYyg1/XrWR0Z/TID8JPfTHqbqlXEZAViI5Saff+Y0K5/6wFP3onTihm5QnqXcJq3CXC5FqEJBbeA2ocI6yhRR7uVI1aBusRlWdtfk2BTPmzOIv9bdMIOqtPfQ/AVKA1MAVRPh1B16JzBXysBUEcl66Vh2WqVofAXKvwRNV6GNqduy+Ocvv//XK7VY+g/AsuREtseD3HFQHOrLZk/Xg57iOruSpn1DneSz2lkyD2JtUabvkkar/6fVdEnJrZ8LJ8
 lI93uhOk
 U+OlA6vO3oqb1gDNZrKLX0bu2guFYVP4Ew/uhdUuCiWs2vUCfuDMzFiL1a9EGXWH8le5acanWi1QGnbV/VWy8ZULfjoWpLquFcC01xDiQbkHAKRv+QvtFwSXzo7/d1edrGXxQb5rMN6HbSlutuMSh8u9Zh/OmXLdIDBTJAjWh5WNjUh+hkwpSI2Lr4lvq0TJoDoZb8x+WrhLNWc70uKIMuRcHskjLrDLuATqZrvwzVGd2V1qPFw0sFKP7+tp+2ypLX63u5jAaQvcovDUbUUeJ/djUS/Q5C/e+rgIxAmfR6XvSljF00eF98bbKAqVHde8gg839
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Nov 2025 23:58:17 -0800 Chris Li <chrisl@kernel.org> wrote:

> Do you mind putting this 5 patches series AFTER the swap table phase
> II? It is the comment adjustment anyway. If there is a conflict with
> phase II, I think phase II should take priority.

OK, I'll drop this series "mm: swap: small fixes and comment cleanups", v2.

