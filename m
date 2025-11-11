Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2AE9CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 23:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 101BF8E000A; Tue, 11 Nov 2025 18:32:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B25C8E0002; Tue, 11 Nov 2025 18:32:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0A398E000A; Tue, 11 Nov 2025 18:32:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DBECB8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:32:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A72A86DDC
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:32:10 +0000 (UTC)
X-FDA: 84099926820.08.E9F3740
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BFEC6180016
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:32:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="S2/rrKum";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762903928; a=rsa-sha256;
	cv=none;
	b=W4E0Ugd027LAXyYQGBdZLB3bkYfGG/IGQNgXcP2KJB4pswjIlrgxrxY34DfXVP+Kl7jmpl
	Xr3iP3uE1dkvD5gtk8aIT+fa4qSoNGgbovQGFFprCFxX0175fBDU8r7uFNWH6Bxtc/onhB
	0GsyvIi193WS/VBKO8NlCUiziTidhFE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="S2/rrKum";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762903928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Do9854tye1ZmwNaEEj+ELCmQaReIw/Kh3SIdEdrIZw8=;
	b=2GLSZdvGW/IZrCLKzi1SZjWJnKkIK2cvGjTbXnAojPnOY4UTy9K8y1shINKRB9ZU4StLXK
	ZhTi1Hf1wXM+NIEaNJgcOGPYfOMgjS0lBMlG1FbnMTuaD54UnNORA4B5oNlER5tgqYiA3U
	wSfN3IFc07D9R7wCAPwuVAWzSVbzU6s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D206860208;
	Tue, 11 Nov 2025 23:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2A2C4CEFB;
	Tue, 11 Nov 2025 23:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762903927;
	bh=15gSMcQavutFnv+Z/xMlrpnRjjmIwljBDh7AC7FFiUs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=S2/rrKumxa0tlc6XvlhElrRrHHB9n+azEYvy7TRXW3JPkscc/92IMNRiFcaNHHFt9
	 P6RiHGpbThsIt6FCvebpUbgOslxGRfnfUtrzd1RPB4g183/U1kwaM6THmSldwcgFJl
	 It9Mg80POtI+BkRM+knJz3wtuFwxYmm1ciV7Afqs=
Date: Tue, 11 Nov 2025 15:32:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 iamjoonsoo.kim@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] mm/compaction: some fix for the range passed to
 pageblock_pfn_to_page()
Message-Id: <20251111153206.8ceaed9b3a0cd811c7a029b8@linux-foundation.org>
In-Reply-To: <20251002033140.24462-1-richard.weiyang@gmail.com>
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BFEC6180016
X-Rspamd-Server: rspam07
X-Stat-Signature: prq3bjtjj68i6ct36ef63widkfy6ydpr
X-Rspam-User: 
X-HE-Tag: 1762903928-547843
X-HE-Meta: U2FsdGVkX19h9p34W2Babg5Nt2+NeaDIsCZc7QEsbHeKH/o1WVjeei156TC8cjQZurIz2bIX3zEPFKX4dgUi2ADtewAk2rUFVIND22MbwuCFZv/oTjfZxFryef0GTEkvKsQDAWToPyYvDq/3E+7z5Qx82LGGv8L+n18eNY6jWo+o/N6S3VC0L+qriiRQ471rYqKaVJ/Sort5eGX7Ckox5ngBZLwmQWuro4YL5DFN8kmknwSYl03gnK+v14WCS5NmmkC9SGbP4QCJqrvGcQ3AGdaZRUDQu7PeHu9f/ZRGAzqWMK9WNWUqysuZmP12RJJbdERfL7TqSZK8sXeigIZzLcauEKALkEOiNlF12jdYqxbCq90MlJe1UMvBkwfLi9e7ntxGQAJj5clQxCIHkSxXG8Xq7TwydhLknsCc02A2J1nDUMeb9HZnYQ4Th6duvqTFq0Ffl4NAGbf/V+jM73GtlVcM/Og/F8qVm9QZ0v/71lRYH26Rl5oWMEvvCUbahyz99JTKtkQAwFAcY9rop4Afcv8KNuZ9FkpL/X5rVf9Hf+LucfENhLjo+Z9AA74pWpADyncDGKiP26KwX5H7eyOAMwb3rdj+c4tQXvCWyUJhSFgqCp+K/rekpToy2KNlgIqjlbcF20dsdaQ785szMNHS7NUM80g8qzEinDslK1/VRVMDXh08XrPSPgVTndhOwz7nyuvWEAxpf2NS1tObF1NIM/ujW3t8ixTo0xRfGSpNkMf9L/zWbOQYMFYw4LzJoeHHokdUOXMqGCUA57YCnvYkkPyeuPVBJsqnI7R1UKYYDmZSpHklgNNeb9MLhBd5Grx8Kp8W9JJNpfN8i+/IL0rj9tQzdWiFELNKecbTQG9seR9Q73IIX+1pvQJ8Odzog80VYnERnMkA8c9EAm0RGsaVbPXqtuYhZlIa00lOXhOzpvWcMBYGnRzGbdoPYncknRHM15F3ux2OeHvsmrwa59N
 vXKxBZuG
 gUGyGVSNdp/ep/pkNGcZsz1AgtVBKFQiAqCWPwnLZY072XL29kSIjYYvmp9xZB1t7LZ5gz1X0LIT+uv35jBhm9GGV7rA5kmWH1W9AwzTy/nSvYHdI/h8CFmprIkhJawy0PuwsfgVVNHQWjApFrgVcqpZLK6YHoqr3nM1bqDGNrgk9C5cAwVJItVrAZcoEpMI8ystpAzHlQZnUbaS0U0sq7RVjCwTCV0+gjfhEMl1xV/SAbWUMhkkoPjN82JOsOn0nVa1rS6S5DqWMWiChoSv11sR2w+asfQoF12HWnYWZAayBQGbK/XZa/byqAw5KyFCC61k//FMSVlO+TEawLbcRyCvK7MHP3oFDLgc1O//5peFgQEQaF/fzWIFKw4TovFmJMCZAQYpE5hL3Cmj9tTD88zAYpCb1DaL/VMCscZvLtJF+UGU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Oct 2025 03:31:38 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> During the code reading of isolate_migratepages_range(), first spot the range
> passed to pageblock_pfn_to_page() is different from that to
> isolate_migratepages_block().
> 
> This implies there is a chance that pageblock_pfn_to_page() thinks the range
> is in the same zone, but isolate_migratepages_block() will isolate range in
> two different zones. This is not what we expect.
> 
> Then I found pageblock_pfn_to_page() has an optimization if zone->contiguous,
> this means even the range is across two different zones, it will think the
> range is within the same zone.
> 
> So introduce two patches to fix it:

Review was inconclusive and we aren't sure if there's actually anything
to fix here, so I'll drop this series for now, thanks.


