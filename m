Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7035BC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793816B009B; Thu, 27 Aug 2026 15:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7695A6B009D; Thu, 27 Aug 2026 15:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67FB96B009E; Thu, 27 Aug 2026 15:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4435E6B009B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:11:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D16E8140195
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:11:20 +0000 (UTC)
X-FDA: 85147992720.25.84CB38F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 605914000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:11:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gyBqQhQW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787857879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91R3l1V/uOl03V126v1cFNRh0hJ1Q8Z9vQ2ulIXNDfU=;
	b=YkiOevrhJXDBq3jdYq898TOtGTMnmCrCN0ehdmoW+nprbYIhSbKeY5psXFe3oAbvgwhDdx
	YlF0tFRfiHTfHGTr6U5EwdtFQZdnWwgH1j0kgKUcEFm4GAhqJaeCBtX91ctzfQz/mJixnI
	NRLEa8KUrgI0an451mCIJVV2Mrdt2y0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gyBqQhQW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787857879;
	b=HCPHkg1jSetFIIsxGkX2Rl10xzRzSRt6RHBR1XvFTrd3CKEZnIy7XgjusnrCz1PeACi4wu
	+Fh80Ew++RqxGHJv3GH1mmyEKHUvmnZfgwFLy5SeoaScq2rYTf3f/Cf5lfHobsLEsFQbzv
	N2VXBTSCyqt7rw/etqoYF3yHrZA6t8s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=91R3l1V/uOl03V126v1cFNRh0hJ1Q8Z9vQ2ulIXNDfU=; b=gyBqQhQWSUlpKmkDdVZfEWq4jC
	6Hn05OsO+eGBDUz0AAmCUEB8dWDSJmRIrRRmJjlK6HFS+x9kWb9Lu9gWKzDjol1WfGMTi7t7NMIN0
	VWiiU82QKosQg/iEoVdatEQU1vueasyXko0mWYU4KN2egNMRYMsj6pLR75wquzW36Ad9tlRcEAbeZ
	HfI+ZL/4ygNnv+qG3c7nh5elZzcg+I+63ohE3j5fqgx39c2GRiCbrmcRZrXHx4aBN6AFfeFLxeLpn
	9kNSe8uFVHwuGrBkfCU7MPZ6YyE27qsmSJf+8cf+peQXfCmqIg5VU63anBDtlkGHfABhRaSUqgTLe
	1bQfMvzw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzfVF-0000000DNOM-0LZD;
	Thu, 27 Aug 2026 19:11:09 +0000
Date: Thu, 27 Aug 2026 20:11:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: artem.kuzin@huawei.com
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, vbabka@kernel.org, cl@gentwo.org,
	linux@armlinux.org.uk, will@kernel.org, mark.rutland@arm.com,
	liam@infradead.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, wangkefeng.wang@huawei.com,
	panov.nikita@huawei.com
Subject: Re: [RFC PATCH 00/18] mm: arm64: Add kernel replication feature
Message-ID: <apCLzAaw6oRIqbSH@casper.infradead.org>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8xejmbytwp9t5dsne436yuoai3435ucf
X-Rspamd-Queue-Id: 605914000A
X-HE-Tag: 1787857878-429407
X-HE-Meta: U2FsdGVkX1/2Vuk3kS1rufRgVpbDcSAMgUwCUXYH/pQr817JW/Kz9Ed3wFGxn2hx8MbT6VcLCD2+pyLsf6I2EqNcXcMPjucHbtVifB2ZJoNY4e0tbd84HViAjVUn89CFBkfeeebDFesP0o+rHH/7u98+Cwd0wqWJlKohZCI9slJeCUBX2ZaDlyRfZsEwf3TKM1SZDHlgDsg+c4nWFhAQznaXkdXQCVcXmil7LKRDQG92UPaLnlyoXD4IQrkNkUtVQdTTh6OpbVOzBeMlrdtg2NTPVNwhHMcDlUho6PSfJ/3NAjCu7GENsC7QV67+NHHzHvOxI3JOw9GIk+FKke6NnseZmQ8a7ht91gTGOJFha+2mi4cq7JRkpAtOfHbRBld12ZhWJzaR+FrMnvqxOGAyK6St6EaVw0GxaT/JJcUN3f1OkVcCP7qGjxKrHxTDZXmbA1sgBt3cOR4HNICSlprAG5rGi4YOkR9zUW75iMmYDGD2fQfbrEvh+t+N/t0kREDuDCx3m31ptW4izhZU3YWivG0122ShKmWIR7MP8ctZO9FiPNRimAbrfvfvSIdJk7A1IiNzxwUVLIRWXHMo68AKyYITxDqxHdJs82eJCAS335duhivkQhmhqNKKLbHJYPhqtwVbTwZbmtXXjgTU0D4mJeTiz8zYMEaWkTJ9Juz+0RRF1AswN9xYA76rXFCmdszSB2DhzxAlQqAVB3lXGpJ7uFnrfmPdUQQZomMzkC/R7PN+FuvY5pK/eXfW12OT2+tU/+tCq6lDbwzw4gt3lndvPaPOGizacU0MzpUZ/5k/lsxE8fOMpLcmtQewA8NbdgZUkh/uOipIj0xxtTsRa7QnrCDaFl6E6L6hMMEGrh+9qBVyojtmNrUwfR8twsze189GPuyfIznLZWpLPP8ZMIWRvke+6sd0Vr4NI6lKQkUvoxF7Vq/UXhjJqetDUsw+q22aIbuYMP7iCRYh7UCbdsh
 yABay1EY
 dpRTlW1q9bhZICRlAFQyBA5UsJ6f1oFF3TIzmjqyOrhx0nVSvXxNY3M+NFj1S0msUBjWNFxGwKfIoBY5TX3DEwluYjSybt6je+JV4T2BynZMGWy+2HLjPUx48jVzcSTk5mNojOhRmgYTHcGmINBj70clJAtSajoGB/72ZV0UsMZmKQowhGCoqwBDn8qtCCEqEn3xYGtNYbD+9XGgsHKNM+uIxO0S+JpQ8S7SDlXHyogWVYpmOQO2hrNlOsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 12:11:40AM +0800, Nikita Panov wrote:
> There were several prior submissions with some sort of replication
> for NUMA systems, including one from our side for the x86_64 platform.
> In the last couple years, several research articles related to solving
> locality issues on NUMA machines through replication emerged as well.

You're lumping a lot of different NUMA replication things together in
your list.  That doesn't give me confidence you know what you're doing.

I *think* what you're doing here is kernel text replication.  Other
architectures (mips, arm) have managed to do this without core MM
changes.  Why can't you?

