Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A3DCD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596F86B00E4; Tue, 16 Jun 2026 17:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56E606B00EB; Tue, 16 Jun 2026 17:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB1B6B00ED; Tue, 16 Jun 2026 17:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 244236B00E4
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:34:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB5C5120191
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:34:15 +0000 (UTC)
X-FDA: 84887079270.26.1F304E8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3713A8000C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:34:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Tgw+agkf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781645654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCfXNXLBXAr5Arz1BeAs2uSx+MoF38R1sHrI4zD9Grw=;
	b=iDn7mUtBMvyR6ssu9YIGc7BCtbXvj8YJwLGXH76B8y6ZDQZIUCL7YyFRnxPO4/YwP5y+vB
	wqvzB6ntUqV43fa7720RgK2sBv7A6+hTTBPckiCxEuD1MdshyZYPUB51lflncvD1roPVti
	gTSPuU5wbuHlCc40bRqxvxyL6CVJ6FY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Tgw+agkf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781645654;
	b=rpIeUl1lICVAVIUUh/EgfXg1JVVPZhmWguU7TZeKLhK7rY16nEhd8NKNsp+2wKiG6xO4fX
	sZpSbDcw03VYqKa9/5rdoxA11erNnQ21y2I7qdzr/1bF1KSRn1tgcDD7yyzP6VWSOnYWVL
	jHQO2hvy0Hdmz++O+zUkxBxdvvgNPdg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BCfXNXLBXAr5Arz1BeAs2uSx+MoF38R1sHrI4zD9Grw=; b=Tgw+agkf9gNlr8xaAP7VLpUzIn
	mt1q8YgGNxaT3kdLwwutfEOiVNWP8kfZl5jlDf/gbEwtfOk0/voLcLbyZ4c6+vlrbtaEWg3c9pJ47
	TJAbjLdXZWaEYwwdJiNm7Hf2BMTC67SE/oQFHWawdwQuQ/tuP8551dSyKfgF97f3KHEGYa8+ur9v3
	2qumHDZ3IyHB+cpsKf5VnypfQwsU9pFSAnHk88i+oJerth2ngfdZXq/EkhaKrnXLr9uotceyBKJM3
	hdw5NTp4WubwiE38Aowitpr8cKTxGFQPnThPTi+4QU6OAaL9RDlK2LPUlwhOVr2ELXgK2WT8K9gSo
	17584hAg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZYCb-0000000BFII-16Pg;
	Tue, 16 Jun 2026 18:07:57 +0000
Date: Tue, 16 Jun 2026 19:07:57 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Pranjal Arya <pranjal.arya@oss.qualcomm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mostafa Saleh <smostafa@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Shuah Khan <shuah@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Brendan Jackman <jackmanb@google.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Wyes Karny <wkarny@gmail.com>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH RFC 00/12] mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
Message-ID: <ajGQ_WPT3Ra2kPCQ@casper.infradead.org>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
 <ai3kkIpaR0aT_6q5@casper.infradead.org>
 <ai_LVreyRWx-RDEd@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai_LVreyRWx-RDEd@pc636>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: otesuueqah3ngw4eid9zgnbm8tf6ni3m
X-Rspamd-Queue-Id: 3713A8000C
X-HE-Tag: 1781645653-344437
X-HE-Meta: U2FsdGVkX19x8YO5/QzS5q80aJybUM4Y78zQqJO6AMdkoTJ3OnbcV0oEaK7GkldJ9RHyZIoyZVGK+meQSXW7uP4vcZkFJ/2sXpRCc2hJKzjwMrK7wckOXtfrph99HMhOVtmqLVOAUccM+Ce70B+Je5/COu9nnRXdzBqJpwBSS+chb9+h7ulMg+1wTZ4TAmfGeCuKwt0OIzRQyTjbhWmIjMDqezWqPLOFOe6mQvgUIP72c59XW5zBldtasQh+m81BrKZSvVCw5AybZFMUVrU53QKOFtZHg5Y6Hgd5G737BzxjNzdIj2ccw0LtU7+/UXFSqnJUiFGO/tqrZCH7KtnUCQ1bTA49Ogvh6GNrdkXYV1CHYMIFRErj1CVtzRfQy6+OYys3CV886+q1i/s7TAG+AcdpVOCGcdkUfChi8s2l+mpnSgp7wdlSRManKGCuax+wC8zSFrtgJUwP1FUtsfPAhOHUzu4SeXO3ukDcYXF555mGuplqR5WRm4aabadUohPUetWJYBeq9tohx+s+LBbr7lp0AkZg6hAbEwCzOl8GB3zhWnQLUDK8hWF4oueMHba98muPnQm8xpTRX3ivGw1Wb9mUVTZawAVS0cuHWZlK2UVQJAosuAyVt0B6SIaqVPxk9mfruVEYiNK13GOQTjWum7Lb/ttF70Z1oX+aj68VXU39En4+iIQwzFC+Q62llGhPpWYYLtQBgwNTu65KrLSa30E6ehO4YhBpWnmQ0MsOK1B0RXwU1jcUGb8A9kU9dRPwiAi7BJ6VeBhuVbNqb7M2TlNxuT5RANSbjERwTrqpLcO4qWEy6xAgvtTHeidsDmI/SmPd/Ht2AQM3gPlIt2aq9fZI8X8/rXkHfy8Nhds5pKIpXfV5tRiM3i6zMsmSFeUrAESyb56TV4JR/sSaHg0BrxcOVN++3fp0fCnjov8Q6Llvan/BMWZcduichRPEURd8ItzVFrci4RwviM58VFi
 KNOgGH/R
 H+8Suggvz1WzXuI+qgk9VAsmkU25tZ3eee1Dedn+cdCJYW69l/HbjdYctgxGzSn9AZluLBlhI5EQv+E16POUYY8BYES6SL6ZNsiB5+rSJl+gPpKkgV7d43tB0CTRX34Ny18muKqhmuS5zAFBWDhTdOa1WbKAgnqn1cIG1UTGi8Pe2xz+ytImpu0QZHVj6chesS1j0+iJzeejSjW0lK6SjrcUEOrafy9lRdNITFAbvxx0KO1zTziyZ82ml7lan/3o2P1AkXlKn+dSB3Mfn5eJ/ocKlW9TolkyfHfdUXIvo8g10Jrq9eOJbQDPydc8BUOxK8fTtb3At1NvgdppPeZbMvGZokwMv5lzGCr3+zGBS0D6Jh0/reNrREhaa6I31+Df9pyvKhnpW6Kq7iCc/oNYwko4AYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 11:52:22AM +0200, Uladzislau Rezki wrote:
> On Sun, Jun 14, 2026 at 12:15:28AM +0100, Matthew Wilcox wrote:
> > What I don't understand is why you maintain a separate "free" tree.
> > It should not be necessary any more, but maybe you tried removing it
> > already and found a performance problem?
>
> We maintain it in order to split several entities. That prevents
> interfering between allocated data and vmap-free-space manager.
> So in that case one context can easily access allocated data, for
> example vread iterator, etc., whereas another can do an allocation.
> 
> So by splitting parts i minimize lock-contention.

Sure, but there are many ways to reduce lock contention.  One is to not
take locks at all; the maple tree is RCU-safe, so you can read the tree
holding only the RCU read lock, as long as you obey the RCU rules.

Specifically:
 - Write side has to RCU-free the objects that are stored in the tree
 - Read side has to trylock the objects it finds (and retry the walk
   if the trylock fails)
 - Read side can see a mixture of objects if the tree is changed while
   it is reading, but for any given index in the tree it is guaranteed
   to see one of the objects which has been referred to by that index.
   That is, if the write side overwrites an index that referred to
   object A with object B, the reader will see either object A or B.
   It will not see NULL and it will not see any other object.
 - If the write side stores both object C and object D in the tree,
   the read side may see neither, both, only C or only D.

