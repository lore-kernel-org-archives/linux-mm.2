Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD56606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nLXVC7XI
Received: by kanga.kvack.org (Postfix)
	id DA3866B05B0; Mon,  9 Nov 2026 09:02:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53DD6B05B3; Mon,  9 Nov 2026 09:02:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C914F6B05B4; Mon,  9 Nov 2026 09:02:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAE646B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:02:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42BA1A7497
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:02:12 +0000 (UTC)
X-FDA: 85415744904.11.F54C823
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id F0707180014
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:02:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nLXVC7XI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of leo.yan@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=leo.yan@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794232930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31ISwiUcoP1nwNnlM+AcNE1UFEe5nZziDgYbUSqlYK0=;
	b=BSeSNf/W/0A6NDlHkBrEc12QPGhjAEgUVvb54Q+8FL3SODXcWXYAGZdS8FneJtQuzddog9
	tjDYWzZ2t+wqCMbwscbzlP1Fl5Ejs/XiIExgRg7xFFhCT0iBphHIoemmMyZJKeWFXR9nOV
	nu5VvSaMuoxr+erCXsHFPABWMRTLrkI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nLXVC7XI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of leo.yan@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=leo.yan@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794232930;
	b=3c1JbQv+/ifsCj3cL0BUXRK64yR9frf0k4LtD2FftzUoR2I3d6ViIovVsyomYOz3dBTTrx
	PLHdlJLIVYwXYmmQn8Uof6yCqZZdgVu2Xt7Ui5sLuBRwMP9vP0zHLivvjRNe6duVmV9FMC
	NxUx4SZvZVNl9hCdZ041Ae5S7Sr0MC8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5CE614BF;
	Mon,  9 Nov 2026 06:02:05 -0800 (PST)
Received: from localhost (unknown [10.2.196.114])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76CC03F632;
	Mon,  9 Nov 2026 06:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794232928; bh=w9un5PJmooT1yfWMFaaQzUU8OhNkwnbnmZBSdQGnUt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nLXVC7XIwT6vpEuK2LRZP1svw0GEjcPNFGmmqHhRpwzotbRQo+5ycs4hK07CKHxQL
	 6R9eRRQ1NlCugddQ2GCkXXcY1pHLJ/yiSdtqva4IrDvKeIIfCjaGoFInwNeNaK6nuU
	 b8g826oaOEWo8Lcm+sywiM3CD/XY1xmWpeLwIdz0=
Date: Mon, 9 Nov 2026 14:02:06 +0000
From: Leo Yan <leo.yan@arm.com>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, catalin.marinas@arm.com,
	will@kernel.org, urezki@gmail.com, linux-mm@kvack.org,
	baohua@kernel.org, dev.jain@arm.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, david@kernel.org, rppt@kernel.org,
	xueyuan.chen21@gmail.com, chleroy@kernel.org, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, ajd@linux.ibm.com,
	jiangwen6@xiaomi.com, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 00/10] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
Message-ID: <20261109140206.GY9176@e132581.arm.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
 <20261108230842.3a77b9fe2d4bfc2a04b355a5@linux-foundation.org>
 <CAHKocdGWE9OVA5pJh33U-FYnNkUqRS0pzFt=rCwXWzY9w-QXyw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHKocdGWE9OVA5pJh33U-FYnNkUqRS0pzFt=rCwXWzY9w-QXyw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F0707180014
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8hgarqah7qwwxxcod7ft1a9yyfyydnbx
X-HE-Tag: 1794232929-880537
X-HE-Meta: U2FsdGVkX1+wsTbh56LeiHE8eovDbnMHlrXAIXV/xeO6YjfG1xPk+yJfhG9gh4M6wxOlGM+bnP4lP0rRt/GSX8IHnoNiUXU6HCeWD9blaco+yoeERkq606EjKBva8AKTLprRtIeeAx9xm2OQeOjcFK6UeC26ameW64Zoh3dSi4SddHHMSBEO/W1m81h3Kf3d3w2mIv2hrZcMyhHpFL4pibZ9U9r+KVXIiwXv8D0zbQTEn7GtvINn1d2SB53DP6RvI5/GKlM7hsBZhkW4BK/qTtDFV+f+Mm6dPRBSfG5xCKRQvjoYjV9zv12nQX8o+50QM/PfUa1rDx4gxeAvxHjc1xNqHwGZmh7aQk8GShzZaGIhcL8D4vuGdIbZzF6vVoirzG7DQrBKCT0Ck83ipHr/hoRyvHL6j6mErSB9zhQ4iZOV+JCWnZLAKnvGrsv1geYvtL5JYr5ZWVUW7J9yWm0ky81WpSxNFHu1BXfhDVx03s4VMlMIW9kDG/Jb9z6Q4GXiTCDvE5JNwC5h8h5Hvd1dhd+eCk5lPgP+fc83j0CuQSmAcMjzYJcnb5lkvutExUHR+oKcvV9w16yAa861+fYTbTeDQRXayohCOoFZlSSnlOsK//POc/QlqaoC02FCIxz653o3tzubD08YVVsJ6l4qqvJUA7SSQ/BmQJF4M4z/IZJrOlE/zUPddKiC+0SK6ynnrF4ROgPqqSZMqaPVQvmj2Sz9UyurnAshig4jNxnyHckntezKgT4CkBQ2ulWIej6qzFLGHHpIibw5ll82ed8NLsML4ZO/TW01qcVOU5Fe9cqrRhprgFcwj1w6gq3wrFl9mzDjkJgXBFhR0XQzkh0bQN8CU4nBe8V4U5fpj+D4e03jESr5I/pOFTqva9T0qq7UneEhocTlOM253bpqKQyD75lfhsB+2az9kB8i9JhyKKa6mslyT738cLnPCPX/9p9dt7o2ya2ilVSWm6LC/pX
 8Tn7LG59
 4Sm0p88EfYjmUChEQ9lJKnSpQOvZPL2QK44SicTwkEed5eHH1dxw2Ap4SV9myNY1XjTFgvMQmJJbO29JMI74SOXvtw43m+Xsj2KsFAZbCIssI/pgPlRaIld+W7W0dI361wxvgnJSBtM6vQ0c9Y2I7+Sar+/qrZ6nfmdAeWsDY5aWmYbx+QXyWIevvSw3SBxU4xtFCwi2YmP31fWRt70UG9L1otTyAEm2jyYm+L1VBOe9ONF/1ilk9oZFsjTTO6xCTIMmJL9J+gLxm7pa0qmdWe4M8kqZyorVytCl32FviV/p/W13+t9ZNWNkN2wh/YgYACjIVMxlbRRpLUZLbJgNdVgeqqS1h7t8K2As5824uIMImzpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 07:07:23PM +0800, Wen Jiang wrote:

[...]

> > Do we have sufficient ARM review?
> >
> 
> Thanks for picking this up.
> 
> On ARM review: Dev reviewed the earlier revision in detail and
> his suggestions are folded in. Leo Yan tested the large vmap() path
> on TRBE/SPE. We'd welcome more ARM review from Ryan, Catalin
> and others.

I confirmed that my Tested-by tag remains valid on the latest version.
The improvement is consistent with L2D TLB refill reduced from
~16000+ to ~500+ across multiple runs.

Thanks,
Leo

