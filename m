Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9B49C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 07:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CC2A6B00A2; Sun,  5 Jul 2026 03:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3B96B00A4; Sun,  5 Jul 2026 03:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9FB6B00A5; Sun,  5 Jul 2026 03:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1ACE76B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 03:30:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7287C1A0682
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 07:30:45 +0000 (UTC)
X-FDA: 84953900850.09.747E835
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9800918000B
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 07:30:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Uk8MqM1T;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783236643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUhQ5u4srEz04rLNb28RAAN9CUToZCgnPFuwRWvIo0I=;
	b=I8c7RNeB5tKdP2f+C+RaFtU/SaKlqjrVfQa54vPkqlnYaayWkWdhZ0f9VX98R6WUU1PCwH
	E7vl9kN6yvCuMWn0nkEbJEdEY+rXov6kXx3u58cbWivHThJfrezeOwNCOwMsdjLljUTfTz
	YR2wwOAUTVJGNOjqO0MvL1EKmmv+QB0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Uk8MqM1T;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783236643;
	b=fXeujJ/OehUkHC4CZ69eJ9iigl+hLqxwrAPoJunygAmesTz/SFyp7aMja7YAmYkyj5uKHu
	pz0epJrmtat+qsNKzvwsFquBpCtCRrbP3d8QweQsqe1ANC/SVDitTu/RJBnhG+4He67+KU
	esAyF2M4BGhy3uFe9Tf9zpC+Kn3XXMI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A43D402E5;
	Sun,  5 Jul 2026 07:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4E81F000E9;
	Sun,  5 Jul 2026 07:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236642;
	bh=mUhQ5u4srEz04rLNb28RAAN9CUToZCgnPFuwRWvIo0I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Uk8MqM1TrvQ2Akr0P3bciF40of6gy+2r77qKifDdcmk+qMvAzZvqNZNizlgWpy2sP
	 Sh7R8LGrcBagwPZ0SXdHjCF6fAebxasfDgpUIjtzRZnBjDhp/uPV4hFnlU98MdeovZ
	 m6FkUJiVolp9rJDCVQ5/py1KTK1KtsVixAeVfnTQ=
Date: Sun, 5 Jul 2026 00:30:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, Steven
 Rostedt <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>,
 Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, derkling@google.com, reijiw@google.com,
 Yosry Ahmed <yosry@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Robin Holt <robinmholt@gmail.com>, Steve Wahl
 <steve.wahl@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dimitris Michailidis <dmichail@fungible.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v5 00/18] mm: Some cleanups for page allocator APIs
Message-Id: <20260705003039.c9b4bd681c059f62b375051a@linux-foundation.org>
In-Reply-To: <997c1a4d-ee99-4214-be58-7ceb3b9b9a36@kernel.org>
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
	<997c1a4d-ee99-4214-be58-7ceb3b9b9a36@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9800918000B
X-Stat-Signature: eodqyhft7j5f89x8y67qsmnowgs3nuw6
X-HE-Tag: 1783236643-863814
X-HE-Meta: U2FsdGVkX1+DU4gx7vKS31ntaXFEUcTSX/8Toz6baDcq8Baacn8bOtSAwSpMZ/5OYHk9I++W5WpzLMNDZKbKFjjHpmguu3zvla/DYXqfrEoItY2iSBuEiQ7r25YCxjnEhfDXcs58HBeowBpKwqtAgnyGjFhpEky9J9IfkIlp6J6TXWiwcIGh9njVJj0kmYE7nFTgwPe3G5Op1+UUFmGvhYkQZ6bo4waVifr2zfJ+73tI+nJ5cpFAVQXQRm3qefcaDbsmlnCU+ZMCouEY6qICwe2sT32LBXPL82XVGozOgV2aj8syZuHXEdNAh3D/6hdIj9YqIq4HG8QpkUohO/NHxeyrija47vr4rLIEY10QheNPVFKk7/RXL3reSdbyrj69LSpZZX7CeDVnwQUw6QsdvnqKpg9x3R0uezsafLEi6gsp5T+ncmKmFpUgGan8b3/uR6wNxQ7GFcvWwfbUX/E/YdevGqeYtVvV+AvYMLICiI7FFkh9N4zkMqaXq/sgKoMwdbTBkwr8jCfGPS9u8E3gG9LE3wIDs7v95TTwwKmouodlterXIFlP95PGZoZRcGjBMs3ulsoTH9Xx/WRtCwQYqTdVqkM5OpgommI8C9S5fcHAHwtskwsJsS1/NUUKO0gNfD4MGKvsl7fZQ1EUbUWXhreCYpgm9ur76gPcppaDR3VOd8NYdfolE7fRdqeZCnmb94o/IS+ae189oCJpHgndeHfGycjgBAKruQrDvrLvJJ19Qj3bR9iYYrInpkq6Orj/Zg3CGmlO4feSPjhnHPxT0bM/xSl72WgzhbvHalx0xuXkdmRQqzuny35Os0AHqdVd3NOte+GXsZB+t1M8YOXmORNkfdRbIyRtKgODUanI13YufnXS+L+gCNzwD8XvlRJhsa5phaVrbSynG21lFroYBP0UTZHcALc5Au5wGCbDv9VDNaLWbXM9vbf7cuT77dxhbqB4wPw9uiKvYSpdjGZ
 JNhbNZeo
 KbN2mpP1Z55w5LRlWvv3nJFoTDUAWqGUbooBc6bUt38zGYMsnIvOjd+BJoM+gFBZAU+0vgkHSBUFzuqj4O8XXPlrynEumC8+3yVaAXyOWCcrqYUkdgGY+66fr4EvAJYIaweRFTi547QzuzEI1Q8YOS+S6JWrTPgCKPNM6lJFSSYYXojyCDdcwR9t5DRkwBffMnnE+l6Yo5k4Qnu9LqYtIaEbK7ZesVYNnKAWSE9eEWJqSFXN7bS/Pd8hht6gAT9f2G2qPhT+IUOXXmc7RAeF0UXLh+dU0ARRGAg72hg7oHaoQHGiVhh6cfJSUL2gjN/yJBHOO/cFwW5+dqIYolG3IlLtbv/ZhiqId4fEGNsQwQKM62LY8j7hD3nBgfqZLMD6og7ER2QxQ3PsJ06YPlz5pJFhNQjf7am18Zj54xk6f+K4AOnpq6TtOtmqGUtA1h2RJ/oTquQSaXyk7MF6QSErr8w6OVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Jul 2026 14:47:32 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 7/3/26 14:31, Brendan Jackman wrote:
> > Based on mm-new.
> 
> Seems ready for mm-new to me. I suspect most further non-trivial page
> allocator work will conflict, so better have it in mm to be based upon.

OK, thanks, added.

I also added some little notes to track Zi Yan's comments.

Sashiko had things to say, mainly pre-existing things.

	https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714e19d3@google.com

the xpc_create_gru_mq_uv() issues look like facepalms.  

