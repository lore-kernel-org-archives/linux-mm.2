Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07EF7D41D74
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 00:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9C76B0006; Thu, 11 Dec 2025 19:38:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C6F6B0007; Thu, 11 Dec 2025 19:38:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571D66B0008; Thu, 11 Dec 2025 19:38:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 448336B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 19:38:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1739134D04
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:38:32 +0000 (UTC)
X-FDA: 84208958064.10.303AFB8
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D8CA4000C
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:38:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UNGSlChf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765499911; a=rsa-sha256;
	cv=none;
	b=0f44qa0lQTzTM7L+I4lZPES0EGjgmMNk2nT+rhn1mTFpEmCMPMdlsIaLDG3+8cguz3bs6n
	8Nd8iAOWW0zN/6/fLqQPMDL4Sll6tAdHdlShnJao8+0U2peSEVhmcrMA1CWmxwMNCKXFxr
	qAXK1H0amngU7CZ43FwCwY35KcvMgD0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UNGSlChf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765499911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YZ0qmDtGhajRkqHtaliRPUZ/qSpTKdV4P+LwDIEFjU=;
	b=FVJkEJT2eKJkn80om9R5dnEJ61DWnGE14XIv2V5EdHTtaCXi+Wjtb6dkAJwKX/xeaWpjus
	WKhv1LyKtegHGDouh/IHVr95ZmnhlpJsLQ8XiHTbuVpqXwF6YIevj4gXBIMj5veTbdIk3q
	o5i+Tn741pcofJPOhBPQPmnYlEecA9A=
Date: Thu, 11 Dec 2025 16:38:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765499909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9YZ0qmDtGhajRkqHtaliRPUZ/qSpTKdV4P+LwDIEFjU=;
	b=UNGSlChfG2aKxIANpnTQ+6ru3hxpXwV0OlXRuFgq3n5tWFouyd5yp8wBT6o7bYIWTGxe2m
	NG+YRj8D9Ozfiy0EVWbxfpv8REyQSrb+WojRv0duMuMqXP5RJLG2ENLsvIEO7mnyGKcvMs
	3zJnOk9FWjqOD3/Vh+nGACnvSqREiZI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: rename mem_cgroup_from_slab_obj()
Message-ID: <lrocj3x7mybrkkl3wbngzqfontqegiwmmkoidpr5by4yjodx2b@alsgfvurtvog>
References: <20251210154301.720133-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210154301.720133-1-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2D8CA4000C
X-Stat-Signature: bmfgzx943a4ad7or5busmzn7e4xy5edn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765499910-847690
X-HE-Meta: U2FsdGVkX19R6I9hslpvbbEK3/olOyHEv8cGIoKKUlmYvIMw5S8xXg0JBPp5+7rYj7D9slOYkIsj81CatQQQ5VHIUNDFSDt7/0UyVAMWDhBQRVkD7rYAng28oGtxpHJ1LtBSvbDsRAn1R0zHtMMKTeOWESUXHQwDFjwUeEEqJcwzOPCjvxok7UYfTp12O5oymc/8VBGGPUBZfa9RaTKtNW7AkXfzzvQ1fg2178Bxub05jDkwlGPKS5b4aRgWYUa24XFXoO2fvj28DjTDH5hHcbXzXzqc0ACdoSg+IDFsLmcjVsoz43OHTg8QINEg2HK9AJ2duw8wKpvLMlxHbf045TUXxvkV+tBqOxn4g1D+ikL5kihts35VowR7fH8BJ4PrNk9WC5pKDTcSPnG6Djk/d5tRcjXDKWQtb216MzqGW/N14rikFjfHNrr/XwShkGLF4WTGRcOqPozt7m2BnyXMzNrLzGBleydAoToX73fbKrNMr1mFYY48A+MJebCsRtq+Yge5uV+ss6KLlEDowr40LwkVDotE/cHWRCLtCwsGKXxcrwj2M0vicY68Nwfx6zrr+EofmEV1ZM7ylq9X0k2bcf5n6zWppGocGtctzrx0IEg6VHRwZHJLX0kIPF8BlyHnr3wPxRw7v7FefJNfcItWPkAQfp7nXq9ubLnY3G4peSFWzuZGNZOMOS1rlWakoqXX0wFMbFcWvcIDQ8QfotizO88h/elnu1JFXMAqMh6yZCsZjqg3ZGnOH0XzYa5Tm7/aZ/mg7W4C7tg4ybsRd/KWa5pus9ytNmTEk5z/ADEGTZqJ0gTPGXI4KbL1hrb0xKzLHweWFUMAOYRoYOAOJtUS+7vIo3nmYzz7iDSNaqvv0Pou7R/ypRqkwJmchEtHcIbO4oZsCQke+oDjStfFJutCFtGUi/8Hnm06SmjX23vIKTb3SJtfmBgHsVC7+M8DOY/c3/J3esJcCwO9iG32Nl5
 /w6jagzJ
 VtTxZXxXmMVlYHMx5/mWdtFtxlz25kwjd7js+TpZhLuQyPoi8/PTBM7aUYnZHNnZ02SV7kpOcH7CCAFaKWMhOPzTjewxdd2z0V8l5eN2NTZmxT1QCjIjDgKh/nox2qQ8OVJSai7osWKfX/upMaScAkKX52/OsEWLBsvtSIWYvnwqaS8y09l13zQmkW1kiIDMwnpwmtqPk4TJmOOsmdDHO4V9Qb0hZIggWaaEMesZV/47QOXHB/aJA8wR0Nl9CDyHvHySk1Jc8tEIW+gipwWs2hpdMkWkLZDMJAZxC93CzYlADHt2bOB5Sfq+rF/Gf9ezxuspdSZ7bFLkJ1LbSHDbyrRoqJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 10:43:01AM -0500, Johannes Weiner wrote:
> In addition to slab objects, this function is used for resolving
> non-slab kernel pointers. This has caused confusion in recent
> refactoring work. Rename it to mem_cgroup_from_virt(), sticking with
> terminology established by the virt_to_<foo>() converters.
> 
> Link: https://lore.kernel.org/linux-mm/20251113161424.GB3465062@cmpxchg.org/
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

