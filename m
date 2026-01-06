Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B582DCD0437
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 04:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C8A6B008A; Mon,  5 Jan 2026 23:38:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 198C86B0093; Mon,  5 Jan 2026 23:38:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B9D6B0095; Mon,  5 Jan 2026 23:38:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9BB76B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 23:38:46 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C7A01603C5
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:38:46 +0000 (UTC)
X-FDA: 84300283452.12.61973FF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0726920004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:38:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pgcvkbsi;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767674325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTHalOLUmgnOoLmmCtnuWbnyzLCxCDhqZLeNdhtc+EQ=;
	b=K5qSXIWbZEHwXTES1T5NOdUI3t8ev1xmRkNS3OzeXqbrgVrSLa3ly3BJcxKkB9v+Gl6VFH
	VxyCNnE8X8ViT4xApBi3u1M1CCdLuBH70iP+qiuyBo5h1yErw6l098WUHNtbmhIt5kuBMH
	uS0fZZ04saJA/MYfUy7DmkrQ62pUskg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767674325; a=rsa-sha256;
	cv=none;
	b=n+COQBGBqcXT/x2Kkhh0HC3gVztBpBo4tHJSWwyHeih0ZIu+4FYgSFivm27XH2zfj/eyUJ
	zAQFeX7bNY1GBICmy+uI28X790fZRZtCnkQ2TIMGq14iCrgyypQ1funuX1AzQBg41AlcFD
	g7eU4ZsLMh6mLj0kz2u5fIt3OQgNy2M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pgcvkbsi;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yTHalOLUmgnOoLmmCtnuWbnyzLCxCDhqZLeNdhtc+EQ=; b=pgcvkbsiN/sb/abeSWJdygSHLe
	LAlq87gfHKyohHUgWzMhd3z3ZOoD6JW13qZO7VER2AXxIdhNoIIzaQvaQb8q1AU8lP67+nsdr7mb1
	WA1mO0Q/x4rcJj8weriQ3HLtKMhTDwwU6dMSFgwaWD9dRR9bAGGwkhLQkww0adWPfkx7RHebUzZ/t
	B3XYUaO05sewBVPXsGbG/Wj7OvkrBuaEcMrBYtnvdjTYiKXnQCsE7emj5hCQYXiXwux3/o2kAVNfR
	hr1L9D3pTNPkyJGe6FH2Fdp3Bvw27HIES/txC9lRQ7hj6KWUtk05PZjRDgukGz4Xm3l4/hdkQ6GbJ
	Z/4uf2xg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vcyq8-0000000BK1y-0Xwg;
	Tue, 06 Jan 2026 04:38:40 +0000
Date: Tue, 6 Jan 2026 04:38:39 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] Free contiguous order-0 pages efficiently
Message-ID: <aVyRz62kQbPe5HbI@casper.infradead.org>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105161741.3952456-1-ryan.roberts@arm.com>
X-Stat-Signature: wq88a3bmprrtrsibcxoaxhcbakg1qnti
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0726920004
X-Rspam-User: 
X-HE-Tag: 1767674324-404439
X-HE-Meta: U2FsdGVkX1/52/+lxPEHZI85G2/Gcz6p7UlDQyzmnoopGsfPGIxcGm2b75X/eFtYzBtxM2REeelj4d58H8j7GtvUccQEyFd6+/sO5tcFXkQcGSt1ME2YdXVQpslauser6REx5focmVOUaIL9yA/ETKYA7u59alNZfCxf3xEM3U+d/mEZghBg1JIilGMvl8eOUtCvDVskWa95EcrD75u7Pr7akt3iMdsbRTRDyLQPRBt6C4eE8uMTBiRRc7NbV307nHgVdCyjANQ7vNGYkvhIfp46b14pbmxh9fVrVJHhaMBbCUnnPwnulH2w1qiJhL392K0ZBLXseI++0XdGKigYzLhqSH51eMHJ5iEuguzDbli9rbjnROq6JFjvSjGaHZmfaRIJ0gwodkVNLyP4xAr9vOurTtpNXqJeZ+AIsIwHd0ZFivYxcK7umXHIi32Y696SCPz3QPj5VxY2c5MxFXi1jtIg+HmdvUbO5ZM1F8hLClPUUywVbWXvxC0I3ItmhtQOJxLt5iZ4qRn3S4LOT/gs0CL1jWwmlUZcsr/0f+TSTesgko4qg8SbE4QsOhi5PPG74KU+gVhCUr2VwU65PlZv/q0ZHm+G9xdQXz7+UF7npTcstIHdgosImJovXXIHzX7/6I7opSVUbPx8xGmYhu6D6FrO2E93zavjseOAQicdfeQUmJGl2Ug2NL4DyaX/LizOfAO0J6o13bAPC5C/Fp6F3LwjizSJC5HFTcyAUsy/x1YVx7kV6AnYpfgcA07TG0mfeh9pNGVhZGLodfxfemIgWjpsQFw7I+glZzi8ShdDXVp31eZf+L/jQlymv4aOERnXZRCmOCq1hoiLMasJ1Pv8wM5Kmh3lgB6IslKQ2X4ivbIifXjKKIVCJ6EyyJoXhDHsCZa4Rv262AjhqqwfOOeGRg05BlJQyq+fT2Wi1q4aKo9vMpziQStWWwgzwj1iR5S3YADnw0CixoX77u+iVrO
 n8DjZUP0
 9z560jK/K3e2Z2nyHuWzqjsvCUOFPXq6Bs6coFvdz3hsIl/IseOaHqSxHWMPFGdLNVv1OBhOpw3zp+kzLBBlWwTBo3vu2ORn8W5kKtpgUduxwguKf6G/Z3tkAhB94wDcApjI5nPOrD5h0wxGN5v0cUu/3n3+SLtwhOXEPRTmcnNFVlFLnXcqY5qSw8hpPvZYsnPvGx4a6keVkgEhnDXQpOpTcotVJ1KeNNw99CXo5GNetLtb4tN3uGltnDPFdYkfj5W1NfCyMC860sWFBOcEAzxXrXg312otP/3I06W99UDQqObt4eo3vlPB/4n2HNbmhRQhs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 04:17:36PM +0000, Ryan Roberts wrote:
> Hi All,
> 
> A recent change to vmalloc caused some performance benchmark regressions (see
> [1]). I'm attempting to fix that (and at the same time signficantly improve

Unfortunately, there was no [1] ... I'm not sure this benchmark is
really doing anything representative.  But the performance improvement
is certainly welcome; we'd deferred work on that for later.


