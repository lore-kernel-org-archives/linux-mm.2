Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED38D1951B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 21:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF546B0088; Mon, 26 Jan 2026 16:58:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7CF16B0089; Mon, 26 Jan 2026 16:58:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54FB6B008A; Mon, 26 Jan 2026 16:58:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A27376B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:58:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 597C8D2404
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:58:54 +0000 (UTC)
X-FDA: 84375480588.13.20B0502
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id AB6BB14000A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:58:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qlJAfKG7;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769464732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0Y0PDiJosQ8lSDT8n4SbFwvTbQKfuwuDkLwrjqFKaU=;
	b=2tNrsnmiYqH+E0ofY+UQpRqQrNOViVINPRvMvFRMTvktnptYKwnsx87wYQKEQXQMTUvxGq
	GKhV/uRvy2AnWnao/H6SMrHlpxCJjvSMFrPKfW/Jkxpxlmg+SF9AFpV/GJzroEwsVAVcle
	hJPY+m/SWFeXw3slmo2igAiVd7CwaQY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qlJAfKG7;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769464732; a=rsa-sha256;
	cv=none;
	b=zaAwtMrXUaXpMm6dVsH2SmI5SoABKlimV2U0vxdDfIX9eNRZz4LRMDkMdcLLCEFFcUN3Q0
	HjKgbXtBnXSpzXAjqVJqtOUW+0Gj8G05QdvKIC2v7uKVnOO5nU9LHiPZ5qM07CNd1WED6/
	KVw0hN/oRVWYYCM6stEac75PK9ABBRQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E20460051;
	Mon, 26 Jan 2026 21:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B11C116C6;
	Mon, 26 Jan 2026 21:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769464730;
	bh=70Zp0Pf5VENACIkSIinhlqqiib4923eVbYXv7KmsCzI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qlJAfKG772fuUZd/L3S6jm1UdCiUxKFqNkdHLSFLBqYbaMc3XjRCe+6eTQKtyzjZ2
	 QOCEwZY7yQUZ9NsK5DTpIhIH2a/rMUJisBS6/5372CFwnj73FVzKjfPVfO+GVDNBhl
	 gql4t57I6x5+UxdtWl3J2nc+5Xc4gES0FU+00YCM=
Date: Mon, 26 Jan 2026 13:58:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li, Tianyou" <tianyou.li@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
 Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>, Yong Hu
 <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu
 <yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo
 <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>, Pan Deng
 <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 1/3] mm/memory hotplug: Fix zone->contiguous always
 false when hotplug
Message-Id: <20260126135849.a32235e3f326b45642f02b2d@linux-foundation.org>
In-Reply-To: <804139fd-e210-4387-9a63-ac76f4df66c7@intel.com>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
	<20260120143346.1427837-2-tianyou.li@intel.com>
	<aXIHG8MQhMRt7M5d@kernel.org>
	<804139fd-e210-4387-9a63-ac76f4df66c7@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xgnzpta6mpw1kpx8ktttrqske13shz35
X-Rspamd-Queue-Id: AB6BB14000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769464732-919316
X-HE-Meta: U2FsdGVkX18/ovZJa9fpLonpRoiCaO7WCurF66x0oCs9oTJuqvKtq3J155xD32jU7kRZPFlH8riyFWxIJx3JwiGqn0m/22mJSPeYD3FoQc3xH9rwSR//weY0nSP6raSmTHRtY9zS7NVmWkz8rXKGhThDo7iz8j1QtQ11z5wA28haE7a9TXtlcD7oAdiZ++m7fRcIaZkIolXbpScZXSs7o6YPbVuvp/kiLrE8FxTs+nZMYGUoRduxnzzlkzP/v8FUowK4wuBOzRlw5c/iTbfFWnAXGFXTBUdc8l57IiLD+i7c+vQ8a00ZC0TtbjRPpMkwCOMNRnGfOwTGb/Pwsh7nKgksjPDexdQSM9sjQfFjE2eKEi319zCwH76FyVvoUP0zFeWlnQ4IkqPsZSBU3TauBxwkQbkN8laqF0hqG9ACpd1JU3vN6gOPAxaTjz27qEqVVnjSA4ZVCVaShLaqyKMzUQ4fqdJpICc6k4UetHKOMQEG0mmEYiZCJsG3GZ8dXh5Oj8M3oy+PswByBW3qroA5egKkKQJUVBbRl+9BOfhDwdac3ogcC4bzbe6kpmTS9DezK8vvTxdeMXQ2d/YJKMBhLifA8efBjFhKWNXt2m2xApTh3+KN8P/CxWdr3g8kzy5eFOEOiqnFMOtPY1TnnsUAs2HLkejSGSIXq5GpKl2k0rW1QvYYpRU+uMjOzikGBP03pJ2hrrSF126OI/aHbRZjPgJtzeNw+qwUecZ8q3rX7G+QPUe3wcvtMuk0iFAwdopvmZnNkQAyTmrvBsq5K1m7aesz/mbtQrgF2OOacPndiAmW0XYG+apU4rG2ZbvPeC6n63TcY0JIA2LWQmEy0F7/f87wPobqFF2/KSbA/vWtwRZrIPeeKRMqV8OV5oNHxa9hU6TuWqW6YjLtUhmKnA7KpZovFsYI5yyj+ukdhN+3kR8KgffHpm1UTO9k60wM/l1BH0c8f6XsBIRqjm+o0gC
 9xLTyqx/
 NRNuvInBo9iKN3M9nvKUYJGxUcrdE4gdmjMH1gow0kTwMXV8qh1dKe9KHH8fV8gDiC5MTRh3UYklXCoAWiQvTR8ickDx0W8rslViUFC68BqIvBgKcEoBS8A9vqaiMN6vao0yMgLCmXpehdge0//mjkIF+Ffmd7Em7EYVNK2gXa54IZewghU3Gf3FBhCnx/wScaDTA79svbu3BXCmz8JVC6/5GRfEMNNALDTXHTdDSmjEfFoJUsOiXRlbk2ZT2vwbWZJpIIZd2KA+R6xHX3hgzuIY4P+i7OkEnBk9sSwpDZNTLj/3m8QtAxTNyfMX0RX/fB4g8/lEnACNGi9Y17h9QfHABZqNcbnRVj2x+mA1OWh4B2CoZt70TAIsPPehLyIslvONw4FalFkJOZiZbdVJo12whzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 24 Jan 2026 20:18:39 +0800 "Li, Tianyou" <tianyou.li@intel.com> wrote:

> > cc stable@ perhaps?
> 
> Yes, will do. Thanks.

Please separate backportable patches from those which target the next
merge window.  They have different timing and take different routes
into mainline.

Thanks.


