Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BBA2D0E6C3
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 10:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 809B06B000A; Tue, 25 Nov 2025 05:47:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1416B000C; Tue, 25 Nov 2025 05:47:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6C06B002D; Tue, 25 Nov 2025 05:47:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56B136B000A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:47:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AD8013B93A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:47:07 +0000 (UTC)
X-FDA: 84148802094.08.6031FCB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id D016720007
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:47:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CBdCtGYy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="KNWnxEp/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FxVJVgHB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FHG4+5eO;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764067625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHbeARP9IlGU7xmiwXNumdGZc6+N0unX3MD+1RRnabQ=;
	b=OtuklEsGwUZx98xLv177EG1e6pLi+m71VOhDgR3R1Wl6fsS0MQWvICxenYatmeu6r2uDgw
	FVOPbwodwJsgWhgeD7Vc3SsosF/OtAMSjbbyz1UusgKgdKwnrElLSdcslqGii1JR+VmUT1
	+3McuKPqqdGcRIQkdo9pmeXvAWDcnlo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764067625; a=rsa-sha256;
	cv=none;
	b=MsWFuDvcGEiSY14q7+00X/4n1vBPua6w4jBW1jzqd564Q5WX8XeI6dtWToS3vCoexKULAR
	MmUuS6uOhpVdDeTIEfs4ISuqfEfhCYv6/ViXCwNVKbPjedmV76QpAhl8pLMPg8oMC/IMGo
	oe7ieiiUx4DNaCqJfFrugaJp47YF29I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CBdCtGYy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="KNWnxEp/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FxVJVgHB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FHG4+5eO;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5DE7B5BD1C;
	Tue, 25 Nov 2025 10:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764067623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hHbeARP9IlGU7xmiwXNumdGZc6+N0unX3MD+1RRnabQ=;
	b=CBdCtGYyK1EjvwPQaXx387jy3Bu9UYAWqWQMrLUeTiR6l8NpTekjrr2BDkVnzGbOT43fOP
	XUDwZlq/gTR94O2rHkAtAfQ7i+hEhtQiHba5tpOYQLZ+7mbXWRyhqizHL5NvebWvqtRIRJ
	fxdwn28dbH/tVl9CO/0rrqnOv8/oSas=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764067623;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hHbeARP9IlGU7xmiwXNumdGZc6+N0unX3MD+1RRnabQ=;
	b=KNWnxEp/pVdW67N+ThmG5Xy54oNG0gQck+0DW9C/ylBt1jNPNHadybwS+zggZhWG70skwn
	Hp+F6Ms+ayw+TQCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764067622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hHbeARP9IlGU7xmiwXNumdGZc6+N0unX3MD+1RRnabQ=;
	b=FxVJVgHBDOYu/ok02uSe7CP9n4FIUjpLSRKDpkcRpKnLoIwV4lBgKu8E0im+yMHzSS4BJ4
	pxvQsffVT84yxjWvxYvkk1krupa92isXUX/jrOQu5UxrJjAjAdqNfIoc+WWdefHztE613p
	DaBHggEn+JBmmInmlCbuB0ir24je2GI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764067622;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hHbeARP9IlGU7xmiwXNumdGZc6+N0unX3MD+1RRnabQ=;
	b=FHG4+5eOqapfmYZZUZdCK/WNbl66FmbJZZPI638ZnaXFe7mRD6ZSfLOi8c7WOAQU/B053D
	fOFwEJzcoJqm3NBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57A033EA63;
	Tue, 25 Nov 2025 10:46:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uo44EiKJJWm4DQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 25 Nov 2025 10:46:58 +0000
Date: Tue, 25 Nov 2025 10:46:56 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v3 3/4] tools/testing/vma: eliminate dependency on
 vma->__vm_flags
Message-ID: <xdks7jbuu573yb6c76t3vcbzsgwyynypl3ldfrzzzcgfsji3ga@sq6jtr4owprg>
References: <cover.1764064556.git.lorenzo.stoakes@oracle.com>
 <6275c53a6bb20743edcbe92d3e130183b47d18d0.1764064557.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6275c53a6bb20743edcbe92d3e130183b47d18d0.1764064557.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: xxrepd5a5do6hke9cbz69ea4s3yq8ryg
X-Rspam-User: 
X-Rspamd-Queue-Id: D016720007
X-Rspamd-Server: rspam01
X-HE-Tag: 1764067624-979101
X-HE-Meta: U2FsdGVkX19Z1kBdxygitZCkKXca/B5YMFVUsbF76yIhcfHR966KGk0cUKxwOa6UWlbtrAvX+j/vV2BsZeRoaMQJIzd7p68pAVZp+ZJz+CL6rKUlF5EyfcHUkSnXY7cjGLAe+T2SugdnGbLwyq05Comr0UzCWBGWkuY4oyvJ/wALiB7bQu4VcCvs0nD2+HBZAA3jTRwa9HDBEPyq2qhTnPMjmNUcwV/44dRq30/cgqhVNCoEQ2SuJiee7v2Ug5/p6yaB8G522vxmi/qlvp+6C06zaSVqvs47XC4YB1RIowZ1rZDnZQAKss8tXbxdxQv/SAhSAqyzEuMym6KrU8IRygxYPBD3dfczvNQrDeF614Wo+vjjMywdiC7Be5vf7BI21Mnvubvk9om7+EYssJSPG9gMCxeqKuGORByc4VPXVQ8giyq0mj0OuW/66tjF6NhRjBdtR9rzcV7sakIVK7SO+XhP4OGcODA60pAEZE1m3GpurChJQfwISEtaEXahnaFINJunDOmQ0njRpjp2fYSSpVv/ME7lEsv8qxgyYAagxjKA1PMs8ra8Qj1oXI5AQDYsWXi8ENsD5Rw3ZTeuauc1yEcexqt8kNuu+gyA0vduXNrQiZmqVxEG+I67JVLoUU4KvhRUO6T/L4lgy9fAadLQmqhvCNE0cVNm8t98tAqpmmj6GvHKFOeKh0a6/2wRqXT883V4/TeeGJG0ClNZzHTBCIqXzp1dEp3C0TF+wP0pmLnYFHqzUJYOaq9pgZ6miZkAm/m+vdpuPqfA9FatRwNydFTWOzeppQRf7AGK1RFYX6LwcupYmVSb0/40PyCBkRW6NCRXoMHukXyoL8/ALod/xrzrZHSJ0CvQMZBmMqlF3iiU2ilR+zpxiSS++AZeD7TSISblpsIWG+VR+eg++QA8awtrNXWLuQhCAVJ5ksiUmGshQKAW/REuEBhkB1P0hvh09bwyjfTR9btXjws7T67
 u9LQSXHY
 qidP0RKWq4T4290fi0+5el7teEGFc/ybCqXAtoORXzXL9B0nPqPH/hur/hSJsv9Thf8dnqruxvRY0qAbW1XaTCSKD+f0b/M0DNssZR91P1KG02+e9FnEwl/cm3CW6BVmaq2AWl/iHbgI8B/0thJskg5Q0Az6BD7X1xsrcXJ4Pz+bzmYKIcIf4/Jhr6dg3DvgDL3UeRDEgtMMLQTk5q+UX0JP0nhCUIwjMSH7PGJaEBtNC9nrpyRNlgvnzwCkb0/EnScqht8alkxoq4lA7MTikRpCzOsRFQeg6LpZco9UgvD3ihibMrW6W14psGdYLK5wPxrexiTgcu3C7ZjC9PspfOc1stYWSnyBGwcnwvZQCwBdfXmBjsfUbXizTKNtiIKO+gNLg6iUI+Q0C3JUb8H/2b2e7R1v+8lC3AZmEef0ZycKbRrkskVe7BrwUIJ3+froPP+h/di2Es1chXjH2G1YqV3kmlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 10:01:01AM +0000, Lorenzo Stoakes wrote:
> The userland VMA test code relied on an internal implementation detail -
> the existence of vma->__vm_flags to directly access VMA flags. There is no
> need to do so when we have the vm_flags_*() helper functions available.
> 
> This is ugly, but also a subsequent commit will eliminate this field
> altogether so this will shortly become broken.
> 
> This patch has us utilise the helper functions instead.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

