Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B3B606A335
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nj9sDAKN
Received: by kanga.kvack.org (Postfix)
	id B980E6B05B3; Fri,  6 Nov 2026 02:46:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48C16B05B4; Fri,  6 Nov 2026 02:46:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A109A6B05B5; Fri,  6 Nov 2026 02:46:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 852356B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:46:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0FD361A0513
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:46:05 +0000 (UTC)
X-FDA: 85403910690.09.B3D5790
Received: from mta1.migadu.com (out-238.mta1.migadu.com [95.215.58.238])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0EEA0180004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:46:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nj9sDAKN;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.238 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793951163;
	b=7CgHceypwp4qhOmOS1KxHRyqg0S+tGD+2wUzUa+kg1YKvfjjEYGyAJKzpkmeC7VkkrU29H
	Flrx0oq1r5XCaaC2vGicr9K2jVKixAlz/461glPjToLtXt+s2W3Kr3ZVOamscFc1sSIh74
	tbroXbn9a+5FyUbfFp6W/i9hP4845Go=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nj9sDAKN;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.238 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793951163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8RPjRkRw6TGzo85+j1RMaJO9Gz+t0O/3LiAQ/KX/BlA=;
	b=m789nKEZou6EOf0Ie5dEwXpeL4eWC6sh94/XJdrzQSuDkelmjTGFQmEBeDOyiEnpYX/ZAL
	Vp7kqV69m8if1+tX/aXsXLubII1DPNN2it3ONRx5byvOlreVAxedyVQEpqu+nwiE2Q13iL
	yh/IuOo0CNJ95VrQ7dmVNeqw0cC7xhY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8RPjRkRw6TGzo85+j1RMaJO9Gz+t0O/3LiAQ/KX/BlA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793951161; v=1; x=1794555961;
 b=nj9sDAKNfkvbBGNxUae68sem25H3PJydnfLYRCEquTfzOGknOJJaghCjguFnHEM1Tv2sOAqv
 1Dlhalz3OIiYsrxXcBlzYQ7L5wC9z9d/t1tVu2xjsUHyj9DmQPymjq+m+Nk6PEfXpKvCGwRWJhK
 UyWYLWpQac9Ccw6BbX++PldM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a2e578c5cb1dba6c;
	Fri, 06 Nov 2026 07:45:25 +0000
X-Mizu-Trace-ID: a2e578c5cb1dba6c
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	willy@infradead.org,
	jack@suse.cz,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	maddy@linux.ibm.com,
	npiggin@gmail.com,
	mpe@ellerman.id.au,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	pfalcato@suse.de,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	leon@kernel.org,
	sj@kernel.org,
	rakie.kim@sk.com,
	rientjes@google.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	james.clark@linaro.org,
	mhiramat@kernel.org,
	oleg@redhat.com,
	john.johansen@canonical.com,
	georgia.garcia@canonical.com,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	zohar@linux.ibm.com,
	roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com,
	eric.snowberg@oracle.com,
	wufan@kernel.org,
	stephen.smalley.work@gmail.com,
	omosnacek@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	selinux@vger.kernel.org
Subject: Re: [PATCH 12/13] perf: convert VMA flag tests to use vma_flags_t
Date: Fri,  6 Nov 2026 15:45:19 +0800
Message-ID: <20261106074519.54904-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-late-2026-vma-flags-v1-12-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-12-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0EEA0180004
X-Stat-Signature: 8begrimte3paf338fp7nfinf6148ykxo
X-Rspam-User: 
X-HE-Tag: 1793951162-418512
X-HE-Meta: U2FsdGVkX19Jarh8KJZziPCEEbXo2uRjuJBEOWSj55eF/hR81+ZmycXSv09BhbwYQ/jp4qdqh8k/RTq+PohQkFh/KBUUSqCWWH9KJYpaarB+ykrOI+q6EFaUntd/wtYXqNbMXrDRQRtgQe3gRdAMDWrxeJXZaMdCUvH3vzgIfirqUsCTjxc5PRK19f7VrF0NVMpWZ9I7Bg2GAwl74JVNn0NA7Jf962BQehNbUBbOD/+2kCLGHhDdasypLZxpeosnoPrpWJ1HlIRvQ3cXRCvICY33vS195/F7DjxEsyCcZkU1fFjJxqlO23vuHY4Jz9IWCMdzsyy2aBvTLWlW933RIy+KHjJTUHk/9m+p/8u2rSl+AZ7DbGfFGqLSb0rZGurC0lK3Ru3sb9RF6jHBI72thfH+ETgb5/xRTJqHex9Mxlopqykw7eLlSGQkKoJn7jWNWMy70DUmzDWyNXi/1cZ3i+u6g3T14NMNsHQmu0xLfC4QOgTGRDlTjLPDwjtHsG/XwKKIilL88TwW/mk17n6b0OHX9fO7s8lNGg7UMb2AHyUulR8SR+ZFjTa19RcmH7PRDmwvuois2G6ma9IIWQ43wSt+2UCyAD85MPzSV/poOw/C3TAVp+1K4PVk2rtEJAG2ewa5zIx9IPeOrLK8JKEiyG29VPRG30yFyMBn1MQlUl7dBsuePVebFXQd+zLS24viI0rAC20PklUn35gjjXmNVlz94s1t7sxux+Y6Ml4krcnsfVI4OSY0WE/xCGSV/Q4fkdacrjwRymGrKIu3hQAUCTANANTli3QuPpXuUORiAcB1Un3/o9wqgMO4iiEs5F7TbFab3GNlP2a6B6E99z/hG9tEYJv0Y2igp+rSNtYE9KmE0bFu4h+SzpuD8Fi6vwzAjDRrbMy6vskwUxFm+APfJ7cwtJ1BSX4wjaouwqvhKHs3yz5c4uHksxhGPfLGY9c/6FFQ24I6MYBWtrXtK3Q
 BkzIIj2g
 u5arau3RAmTc+Q2U6/vZy27Xxs9uVDqoOgdAnDdiqCOQq8mLX+6S5g35yHoTwnN9+49oJB6OHsPACETxg8qoJ8ZiMjrv/AUxIUB2Ma+srjKYwwnIzjgZCV+aqa3ZRCoF80fyjcNZVGH1u49canZv/Ae1bD18tvLckN9j9GjDn5P6mh7jKz9jTqbLGg364RX+0CiYY08KeX6lz5YastPXBZciyUdcKOu4tV6V0IEoq9GB99KdEokjvrmab4fsbjNYsC74CM3R2/Cu5MrrfYWVrWjWdXKs645Qg68Umnud4Ve+cmT9MWqtU0uUYQStkvot5wATRGPcxtasD/p3yCPrZcpon+4Gog0AeabvxY4sRwIPwph545+c1Uhf+mW3f5QZSyUc8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 09:31:03PM +0000, Lorenzo Stoakes (ARM) wrote:
>Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
>perf mmap and mmap event logic.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

