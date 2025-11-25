Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A72DD0EE00
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 17:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBED56B0096; Tue, 25 Nov 2025 12:21:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96BA6B00A2; Tue, 25 Nov 2025 12:21:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3A36B00A4; Tue, 25 Nov 2025 12:21:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD19C6B0096
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:21:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 707E61308A8
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:21:31 +0000 (UTC)
X-FDA: 84149795982.02.8B356D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6C998160014
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:21:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f0+AP+ps;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764091289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFsKSOAAt+BJ2HW3Q+CmoZoy3mVn+ELlSFmfSNw3rCk=;
	b=DZ0pdPk1EqaxuKA+hzic2f3aCOciDQLuxfx6ziGRBY0F+M6YhzF0pAauKzVx7oVuKgE93A
	dlZAqZX9QCpjORinx7omRcbUhnVN/EMl5aZWudk15fwNemMY9WQnWTWd3feckluOxstxah
	uerxOI2xPP3h9YCJK06CXJV77gpj//M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f0+AP+ps;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764091289; a=rsa-sha256;
	cv=none;
	b=ciiEPkdz7oH8o0f2M7609EsN9QweDLKiDGJ2RgtJc+Jgp3OOOSHROVHDHayCz67gbM1WHO
	odfIwRB/XDPYuBueSGRY1BFEUvOvafujCvwA+bW69PMDTA8/N/yLduGQhVU01upiTVO5gd
	kog3mGYEGTyKR4Qj0Gd/OJEFZnDI3VU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 226CD43FF4;
	Tue, 25 Nov 2025 17:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F6FC4CEF1;
	Tue, 25 Nov 2025 17:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764091288;
	bh=5V9QV7SiBzMU5nx3Mn2uqFLHCyID9A3N1YOoa6yxqY4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=f0+AP+psoLoGzXaq00ep6BDykJP5aOdtZfoQZ4KAyuamvgXUZO/UGmEJZu88bAQIq
	 Ph+B0PjesF0Ac7gLWJ9KCv+Omr0a+hSLWs0rbzhWkIUTz4dhCv1QM8hBT4VZXdt0Tw
	 qAckYaIks0SEUeBlWRsbMccDVtm+g6LfRTNVGc0U=
Date: Tue, 25 Nov 2025 09:21:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@redhat.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Peter Xu
 <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel
 Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Kees
 Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn
 <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Pedro
 Falcato <pfalcato@suse.de>, Shakeel Butt <shakeel.butt@linux.dev>, David
 Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song
 <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v3 0/4] initial work on making VMA flags a bitmap
Message-Id: <20251125092125.3e425e05382642ddff2db496@linux-foundation.org>
In-Reply-To: <cover.1764064556.git.lorenzo.stoakes@oracle.com>
References: <cover.1764064556.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 49p5xf9ch6m7su7ah5p1dk54t6y9rxcz
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C998160014
X-Rspamd-Server: rspam09
X-HE-Tag: 1764091289-111180
X-HE-Meta: U2FsdGVkX1/HRpX36NnTJ3x1jERCj6uUA5FyAuYl/27f7EXATkuP3HW+hX+KDLqOUhfWewb1oswbH1T/GoXdMRQAeIMBxpVOJ4rQ9Y4ie84ThExn2Rc/IXeUx93QjjfSa4hxYWLKC8kt9FK+hF6krLMQ+ah53fdlZ9K0ReQy6TEXZ8CeHnKhpoYsotULX4QetLe26P81BSgwCZRCJiACTP5tsv962vfCQX1rRyJh6R5r3JlaalYqTTA83xDJJKnEWZdieqTJ1CHLDT8FG0pWRn2sO84p/iIfXBPTd0Om1/N6qbQOv675EW/lvQztEUGXfJUtLh2XPFP4f9DBXWpJmsyW45LtZuxEEJYH7jP+Jzxdn4IDjxj8bgGJW3qqPuzZBrlffXtCy0HFxaL5hncFnnbn7sqSPLGOeT5VwaS5AG+vorWdEjguQcamUveqsuOiUeTzO1WOlLXgPJ+pY2rTf+jekqzFIq1Lcfwpt5pFxf780Q/m+Pe4Z+XizTc0H9h6UmhKSlWBLydU0zEFfhA/1aFfaqAK9QpweiRKXq8H20P5g5kpnDWeeY3qwN52Ze/DWplUovi0jwCkn+gSdL0VfzL83R/O6Tccvg95kQXyKlVWYo04yeWoX4TUFBZz2rRv9Ia1dHd+BX9m+4JWWR2Qe7zjTOHIZYIAsti6OQsGdD9TEAJX7vwDQhHvi9MlYNFFRzzHmhSMuHNBNa8KPGk3IUF0/roxEyqX1BPw8KjQACzRqWiBVWKxN3IR5yuO2vsRokId3vfVjFd3VPW4CGjV+RGkEVTeL3+mAKVkHFPZqCdhvQkCsHblYyDXykLK+2RUUsinvWdXXAjLJcnuU9Qm+PnhND+pseUjeo1ceUsiWr1oG3qGoqAYIjgHu8WYN8mfM8AlV1lTOUdVUprGpmy/qOopRx8W4IvwllB4hRpmBOLBQF0OWGByN2UhS6iX7Hr9mTxlwJfXMl6T1hkadbb
 ld4ZLtVW
 fTPXZywK0WH0v454VCxVm9RYHhHBeOITnrasWO5e+qxfOBRH7m3YucbHv+FACTvSLVKTDvTkwBYqL7I06J1NbsMLdWtcSQo/Py4cxj1bssl3xlSGvg9u7T3wYw5jDvFXRhOXmEXSkHS3bDJ1KbLC9Cm9YSyHLPRGwn5LK8BFVWvGx1cAdjONoW6RrA9Kuhhxw+am7mwL7deQaUHAFgrP4al4RJ1o2td6fSQt7+Y5bNRHC+HjVflHMsOn56jc2Ne0R8GtMdCnY4AYkFvbmmm9bs94aj5uxa403izcbDHlXnzp6nqmJlNEb6s+4nJUlyG9oayPCIILfFGPnKhTUz4iW/uPHXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Nov 2025 10:00:58 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> We are in the rather silly situation that we are running out of VMA flags
> as they are currently limited to a system word in size.
> 
> This leads to absurd situations where we limit features to 64-bit
> architectures only because we simply do not have the ability to add a flag
> for 32-bit ones.
> 
> This is very constraining and leads to hacks or, in the worst case, simply
> an inability to implement features we want for entirely arbitrary reasons.
> 
> This also of course gives us something of a Y2K type situation in mm where
> we might eventually exhaust all of the VMA flags even on 64-bit systems.
> 
> This series lays the groundwork for getting away from this limitation by
> establishing VMA flags as a bitmap whose size we can increase in future
> beyond 64 bits if required.

All added to mm-unstable, thanks.

