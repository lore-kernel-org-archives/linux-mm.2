Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A303ACA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 23:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254FC8E0008; Tue, 19 Aug 2025 19:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22CF98E0001; Tue, 19 Aug 2025 19:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190C38E0008; Tue, 19 Aug 2025 19:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB798E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:46:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 49E4C56FB8
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:46:50 +0000 (UTC)
X-FDA: 83795144580.22.935C514
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id EE7F220007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:46:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="aS/up6TF"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755647208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HEUPIQNacF5PxxegBqbsUnaXiJZQ0xuzwBbC1vo0iYE=;
	b=GfYehdw0oFYNawUPXbr+Az27sdX5vGdCngxTk4QGAQ81y7y7yu3RFZrM0I7wA4yq19Vq9x
	kerPBRUbuG/XrKffGalU7GKUztA8GtN1LiDcK7ukGaAVkK2UJj32OwByYF1Rndmikpt5ko
	LTWi2KqPhR9YyB0UAhiUaR6sEFqXLSw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="aS/up6TF";
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755647208; a=rsa-sha256;
	cv=none;
	b=RJZw4RJJnCwNBNzLUG6H3CSpwuIGrdjDJAp6IXNB9aqBgABBZ/avSFC2IUaZP33/VTX8Ab
	nuaNCb3KuFyp7w+Tgo8uE1DI11oGk8l4IdG3E7he0IWsA2uoIJKeEqWh6ND+uFv7tC2Vf+
	Ix7Q3kymhtnkntcb4SDiDQL0+Jxv+To=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HEUPIQNacF5PxxegBqbsUnaXiJZQ0xuzwBbC1vo0iYE=; b=aS/up6TFfUES39twyNhHcGUqhQ
	2LbOzNknbl7g1/yUUQZydAWqxAyuy2e9u5wgiuF4bjCY5NA2/4SremYME0vfgd0N0ze1tyaYjwkmQ
	PopQ7jcFhndtS2D6BklWFz8raGWRRvXKNF24dDrLnvmFCPxqvUdmRf1i9yu1iy62WI0nmEjdJhYQk
	SSou+oZF1u9gKQG5RBnIvp80YXgpVpdvR0BkpJH9/uqV3CGBpcI1Q6B0A1WYcxQRlCDSoUkkLy6jh
	powKvt5Y8cun2DJP82W2jBsIud7NAnejHd4nmDHQbkTeTmNWxIBZYmAB1/LXwPtc7PjdfBkjsqj0M
	5zaqkVWA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoW2N-0000000E9dY-1uMv;
	Tue, 19 Aug 2025 23:46:43 +0000
Date: Wed, 20 Aug 2025 00:46:43 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Boris Burkov <boris@bur.io>, akpm@linux-foundation.org,
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, kernel-team@fb.com, wqu@suse.com,
	mhocko@kernel.org, muchun.song@linux.dev, roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: Re: [PATCH v3 2/4] mm: add vmstat for cgroup uncharged pages
Message-ID: <aKUM49I-4D24MmwZ@casper.infradead.org>
References: <cover.1755562487.git.boris@bur.io>
 <04b3a5c9944d79072d752c85dac1294ca9bee183.1755562487.git.boris@bur.io>
 <aKPmiWAwDPNdNBUA@casper.infradead.org>
 <tw5qydmgv35v63lhqgl7zbjmgwxm2cujqdjq3deicdz2k26ymh@mnxhz43e6jwl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tw5qydmgv35v63lhqgl7zbjmgwxm2cujqdjq3deicdz2k26ymh@mnxhz43e6jwl>
X-Stat-Signature: qa59tca1ed1yfzpzzoracfagowsp5wpr
X-Rspam-User: 
X-Rspamd-Queue-Id: EE7F220007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755647207-6751
X-HE-Meta: U2FsdGVkX1/aSDKb0ZpF7zvqCCyWavriS/Y5GrTZAARCTHaXRYZq2J52gFhtNNN0x+pW2D3djCRgIU4myJYeaa7OajrERK1ImMOm3WUI8faKjiIptPmSKAwndTmQkMxwdzmaMZcDYdsahTutLaTd1o8xGmtc3vGSrcsXrZsgY6++UyXL2mUNYhtidsV9F35IKaiE8BEFrc0cJykYJHwlnANq8bGuPXhHB6kQhERya+chcnC3+5810KViXRF8XEmfoqtqyWbeq+G+sMZc4Oq+nz/nX5gUHNcAOhDazyWvGdOwldtF5Gw+mZISizLe5N4INja4vfOt7SZvfDqPFi7oEpe134p4fO2i3kvIpG78nxYjRgXcuddF+K6YbstAu7dV2EMxd0h/4bvpqYAMRVcVdkhH4bNgr3P4B2iJbTGCeteuxbY0BcVVwrCL59PrbIstcl2ZMts1rYpG8SwvWt+xi5PNmCrisEWjypU2kp3R3aXeTDnq0VbpBvG7VIGERPh/CDlvpoE0Bi+mxEf15HGC+dXNfT8Jjs4hPeVjn2hCf6jvqjyxxrIJeWJ5hFKyI1aB9cg5y9X1VdPPQ9sJwldOG9ceSkh0i1oxU+qgKynXjrQBtY/Qk7wpf1Hr6Aw7iPMNYrgqzM94NHurSjDCne/W8nrWoLfNsF5hCdpV6unemIbiOrCTEKOgBL2i9Eu3+rcjo2kAecDZkXGvIejOhlnoF19pmGlSHk41d5D0TnXHEbbhg1hc5UePOLCMTIwqJcF/A6UIL84TLeTALeTeZ4ggLv/yfG5f6A/Aj8+Z8xKK8nQvEI0uDYQQfXlMGHE3a1DRsbJgGsEHs93CfYAqCfKQ1IV/xsFJ2PyYmuA2bfzQkx+YTLTzpodDvsojwDp+bHLh/cc7MN7bqWIIHdWFkZYE0YXx3j0G6fZWJwwYfKWM2FG33CNRKAKpfmdkAKkquzErnOgqUdiJxWouoChjOaV
 tUN2opZ6
 x59tAnEocRii41L+uuaxkkAoykFD9jqc8dlwFmizKJvG0glNreqZRV9CD9pxRr1w7/pdy7B2Ysw2D49hubSpbyy26UIHGQJRKtr6KYk8V3SQEdYy7vMqlDwgLsVR9zoN6bJM6naEMCLnw5IFq3Y0YElh8NtlsKVm3ihD7Jd85gjKd0BsNLTDP1Xe8SQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 08:53:59AM -0700, Shakeel Butt wrote:
> My initial thinking was based on Qu's original proposal which was using
> root memcg where there will not be any difference between accounted
> file pages and system wide file pages. However with Boris's change, we
> can actually get the estimate, as you pointed out, by subtracting the
> number of accounted file pages from system wide number of file pages.
> 
> However I still think we should keep this new metric because of
> performance reason. To get accounted file pages, we need to read
> memory.stat of the root memcg which can be very expensive. Basically it
> may have to flush the rstat update trees on all the CPUs on the system.
> Since this new metric will be used to calculate system overhead, the
> high cost will limit how frequently a user can query the latest stat.

OK, but couldn't we make that argument for anything else?  Like slab,
say.  Why's "file" memory different?

