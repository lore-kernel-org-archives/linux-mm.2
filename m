Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F38B9E81A29
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 14:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60E3D6B0088; Mon, 16 Feb 2026 09:23:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B10A6B0089; Mon, 16 Feb 2026 09:23:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0A06B008A; Mon, 16 Feb 2026 09:23:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3893A6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:23:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61F821D17B
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:23:08 +0000 (UTC)
X-FDA: 84450536856.24.041E7F3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id DF54B20002
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:23:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jHsQp3d8;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771251785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjZspzWG+H0E9YOj5DSRiLsaeWdF6wIeH3nEZ2b5sNw=;
	b=g4noIsbvkunwvBMgRcp+Dk3VbL6aYkKUsv7mMkumuYNdWIrhVWGsDGd83hYo9tlZZLwhnh
	cVjYvddPbOUg9BxdDGTJxo7Z2ENYCTx24MWGE4/RS2N6/ae7RnPHH9FIBuBHLK0Z+nFwum
	8c5jNuxqT3jtCZgSHwjPqgcPfkqwVtk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jHsQp3d8;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771251785; a=rsa-sha256;
	cv=none;
	b=SsJqP0pm6S9+eXarbMVGmYFtRSikCXgfWu743iFgzfbMBtrmlHgYu6F+l74GhJaX3osDU0
	K0cl5EFJZtwVe0mWUGOFMe6qRJ3fNb/rpRFvJe5Z0p0R3GnZR/kBNlZCUipV+PJgcRtfNP
	nMP44recIGRIMlcMUuOtaJt2RNDkZVQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VjZspzWG+H0E9YOj5DSRiLsaeWdF6wIeH3nEZ2b5sNw=; b=jHsQp3d8DBzb5jm7ifkv/OZN4a
	sGgXPTqIE0ySv3ULEZCeuWMvy5h0yLvGhe73/RFofgAt3CArNHwIBugLdjRVQ4wEH3RZ4zxAoFYNJ
	SjJeEThhExQ79rfBQZcrk54F21LtPKW99MEa5dxnIT1INbpLrrK6c8DtgOxzesZKxkYL8NagFeYzR
	S4TqqCsCZc/4m3BjpS5My1dUzqJWqGYtdlQO+G8hi/5Ayh+VGdAVcK1Nk6XwuisASjYfy4bugRg++
	P4oVwygHfMEe5TKZxeeGa3SzWsH51Az/e9e3rVzxz2L6GDbs1sPPZXpnJX/2bv4W8+rMweByDG9hZ
	S/mcKWbQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vrzV6-00000002YPL-0NHZ;
	Mon, 16 Feb 2026 14:23:00 +0000
Date: Mon, 16 Feb 2026 14:22:59 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
Message-ID: <aZMoQw-86_FtUvLU@casper.infradead.org>
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260214084514.2842745-1-haowenchao22@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF54B20002
X-Stat-Signature: mfzytbpqfrrrg1tyj6ofa8b1ey6o839j
X-Rspam-User: 
X-HE-Tag: 1771251784-237432
X-HE-Meta: U2FsdGVkX19LFGen0k7a8aMd7hi2XKoyhyQM/a4W60GMoUPNMjdzLnN5RdYK3J7HPoCp23o5zxeKphO2uvJzJAQObe8MoDIV67HywvktB3aW8v9ysqOzMYsm1JkVATqfDSMhkKb39kwx3l9Jf4FQ8sh50wmlN2Iu11WyxEhqnvXtzSDmJ5VjfGFCvBpzRR05uBUIom47HKce2f6P2qpqvoyRDaq9Vz04zPQruqnhSbiiTz7oAQuB1BXG80gEmddDuwXw9L/XwMP3s7cyewQ1mdF7NJYBLbyWfn/ef2Ea3mvF/5vLxRfP/mnzX9+X0Rpw56tZsHejlS5zw7AJpK8/Od0+EPx/Dk/IvzPEVcZZCne5K9HXIvragt8wCirvKzmOWOdTT8LB+V1kwhWlvr1nDWxPA4uGOCKKi93bko2mO4GdLARLKyVh+l6WvaEeRWafe0N+pl3twU3FQ6WL4ik6XIvr5xsxjKCcm4qaEeWNUa78oDcTYnEydHk6ezMAVi1X1HzBSBTDQhlMVhUKj/uuz0fPUa3E+kdSPPjgvfLTKISn2CuUoOe+Ss1bhgVupTH8wTpSxW+GPkR9IpgsE7+6b5ScCbE3KINm3Yl4DeITCNDWY1ILboLOj1ifh6vmUdlLP7pnTpapnpLSMt6z23o2kmU+m03dy6HeSdU+Q8dueGpVRdKbxUpf/oLathHSf/NIFHzXx+ui87NgvnTk/SpmfvWf0FUmAO5xKgsMYYZXGu+0YHdcjFyDaeF1dUnWakWHsfN4LGm2P8BhBQryWbhsZ4TT0h2w7J7wReVXrTRNVR1hVsX7EAieDur37p0vJOxggS4TyhxeVxiXdGfIz2bhJ14uPJTtADwgz9cDFMt8KRTs3LGmzmBqJbDVuiGK8XEslENdcLVZQfHqgraQ661S5QdOZkhOzroYJBDW3+zOJ1n3sH/SiKKBDvuKaxYDbBuBAcEFBRTKJ+qIrlg7Xpd
 afvvCYJt
 AkSpuJ5fW76I6ggn8scKqVijwtg0INgNTyV3UlSPpIA4A9lHzpGFppV1fK6AKv2W9TLp6t20szqZXPoZwzLafCuyyPd1FSc+SzTBeuhYLKCr1JGWvhilvUGcxNaOG60vOT2zgi1A3rtcE6NHxsO1NUZfC/sgwISJFaMZ6xb8dewN2S4QMTuGYl/eSYZHEggShtUWFrw3P3pvSHZjPr2bZ3QQFdvzt/LGaV8wSxxRqdlRyOfWlKU+ieqdc5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 14, 2026 at 04:45:14PM +0800, Wenchao Hao wrote:
> Add kernel command line option "count_zero_page" to track anonymous pages
> have been allocated and mapped to userspace but zero-filled.
> 
> This feature is mainly used to debug large folio mechanism, which
> pre-allocates and map more pages than actually needed, leading to memory
> waste from unaccessed pages.

Why are you trying to get this upstream when you admitted in an earlier
email this is just for your internal use?

Why do you think that "unaccessed pages" are the only, or even the
largest source of extra memory consumption?  The vast majority of files
are never mmaped.

This just seems like a giant waste of time.

