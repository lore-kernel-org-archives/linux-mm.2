Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7CEEC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 23:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89BFF6B0088; Fri, 10 Jul 2026 19:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84CA16B008A; Fri, 10 Jul 2026 19:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C026B008C; Fri, 10 Jul 2026 19:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4537D6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:53:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAD3612061C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:53:52 +0000 (UTC)
X-FDA: 84974522304.25.61E2015
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BC94A40007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:53:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=REiuFs4V;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783727631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVL+OWDjz7dR1B8k2mIwS3yFQn8TSeFYCxydqWdE8V4=;
	b=BsKNuv2VDhcBXW/OSEDUxaYJMeCkK8qg9Vqoe0PB+xq3J/4HhW4p053s3vpZESnZl5Z8iQ
	GjTZuCTwncOiC6IEQKzk7oMjKyMF5Wkaejo72d4dB13KWu2Kfn8lHytCDMB7WCm4CIzt4N
	CqmGHsSaPyz0FMNOHvLcIN5nughrVKo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=REiuFs4V;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783727631;
	b=TTO4cut242yha4lkQLCZ+18t+BGtsUVhBuBe3CFDMQ+N7G3QO8ptyqCXAyCfgP7iqVKZ+A
	2bk7UWSZ68SJYWxkXmmz0OkvN6gG+6Lr5hPe0XwawewY/t3Zwm/+ccFoP+O0kiqk8QMTLn
	y/8u65Kt8LLIEe5jECUBSWrUiP7oZbQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7454041AA3;
	Fri, 10 Jul 2026 23:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52AB1F000E9;
	Fri, 10 Jul 2026 23:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783727629;
	bh=HVL+OWDjz7dR1B8k2mIwS3yFQn8TSeFYCxydqWdE8V4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=REiuFs4VZ8HBHgEuS8pPATEsHkD67CqvsVug2ISH3ua+FB7HXhRIT42SsJ522Cw+R
	 4RqPTXUcoSl3sv9Nx0CKFVeyB/CD/AOjA+DBcmQVnwjcj3BAB7XLv8oNxPSn2XhyYx
	 Nb5shhdV5JTt0cIfb3ciLGYnVvFYGsDsaTGMTEZw=
Date: Fri, 10 Jul 2026 16:53:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: apopple@nvidia.com, balbirs@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, david@kernel.org,
 dev.jain@arm.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, npache@redhat.com, rakie.kim@sk.com,
 ryan.roberts@arm.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, shakeel.butt@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v3 0/3] mm: handle device-private PMDs in walk callbacks
Message-Id: <20260710165348.cab6f58aa81b30e34d121d0d@linux-foundation.org>
In-Reply-To: <20260710105557.1987433-1-usama.arif@linux.dev>
References: <20260710105557.1987433-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC94A40007
X-Stat-Signature: jycmn5469exaashtut77chud7swf3rss
X-HE-Tag: 1783727630-946906
X-HE-Meta: U2FsdGVkX1+3llgfx1kLqHBwlBfhJ95osBwXDQvEgbCcMCStbMPn6bXcghgYMALIJ/j0AAmjRm2Zrf/mN3YX+VPyziuFmYoeGHemM8MHn8cl5bJKo069UNQB5Z0ZrhZbUOntzvXfSWbGNZgykPojrEaNBX5bHKZ5Fz9d/8qeKq46uBV1QJz+BrQ5kjrYhIJRvUOyvFs2kv+I4y+DEswP37dtkcgO/o6VVgec09xQ3n39kGp+F1K+nqaZo0h0OGNmNRlGUzKQ7BWME6M43n4vSRjY3/4cQL3C4zoOBpwG2m+f5PeYTF5NhfQPnGlz1rDwz7uuafMbDtR5z5El3Y5BizcfC1daV0pwXCGp87oAFiIpACYthNEDSrDN84+tzOYSdmewtjn/X5NO9PgXGxhbscXYhyVyPUHea7A1TFRNDciCMScDVstM1DBwoQmuYwfS2OpjmCQvmn+defpDx48fBOrf+HOaaQUX1eiJehjAhRkX2AxecCxBc6VKtjYlRh2YuHI4j1BjKGYJyCcuN/r0mWBAF81/Y+VnGUAAvycbhwsMoHH2/ynFHXm4TUkkLHiOJ28FZzgK5JmRZsMrcLueyBpwYRtLG4m3kBMhQG3dzrzheJ9hp1zOSPoSoxlYAdomQgJZu0WfWcqKja223I96GDzXYMUGIMGrxVUPbZ7Fis4kIT07g8Zb2QkvYIwd+7eiAZXHdKWRdtzKmMV/eQ0gnKGKqZigc7a5KTqV6wQJld6l9Jkx2u+CC70SH5o6rUWqsMdlU/fhfyMX27hPnME0PRz99zEiA/AvFoRz1DZLK5Ny3tG2/GfcSLg+YPLw1bGgr4BYX/BeFPpLyi+UD68AGnHeOBoKualt/E18Ee//MYwGMuTReggkd6rHF1iljBzav3DoYRaNrLWJBcQd8SRwUvO3wFvnp/XsVoJf6nO6E5nFHR3wDBhMjTMdPrCSlVwe3Kb5EXxFLhg9FT36h40
 NiBbbH06
 J22kOhJxt3kHUZeVaW0noQth9OCfMAkri2Sk2ZzDdSl7CXphdCt9+Af+dSzR+5B0uC98zYvxxIibXDLM9e1EholRuiG1rvVMrVdad0LNiOcCc92PD13weigsaECyEuhYMWMPSPudJrW4U0NKyx3VO01wwCxz0cV+Qr/Wm/6TAND/OdplLjsB4b11gtkgK28S8ZQlq9mKWLsuNv8mjw2ghH74uQwhNqSk9+jOZa8e5m/xrkFc2ujsCgr7q+11rp+rXACqT7K73nPRE2tP0As1CLJej2lg7F0GwiYXsDcAANJ+0jt5lsGegvi6+aTtW718OqVp8PDNpAABvO4cj5QWL1zdzDE/IzHhETILTdTk4mH+auhp/n1QwcOmmfiJ+3zHcIMqf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 03:55:20 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
> to PMD operations") a PMD may hold a device-private swap entry whenever
> an HMM-based GPU driver migrates an anonymous THP folio to device memory
> via migrate_vma_pages().
> 
> pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
> for any non-present, non-none huge PMD), so several MM walk callbacks
> that used to assume present THP or migration entry are now reachable with
> a device-private PMD. The results range from a VM_BUG_ON() firing on debug
> kernels, to an oops on a bogus vmemmap dereference, to silently isolating
> an unrelated live folio from LRU in the aliasing case.

Added, thanks.

I didn't add these as hotfixes - the Fixes: commit is somewhat old. 
Feel free to disagree with this!

Sashiko went nuts over possible pre-existing issues:

	https://sashiko.dev/#/patchset/20260710105557.1987433-1-usama.arif@linux.dev





