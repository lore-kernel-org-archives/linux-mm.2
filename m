Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A3A606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uiwzP25s
Received: by kanga.kvack.org (Postfix)
	id 978636B05B2; Fri,  6 Nov 2026 02:03:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9486A6B05B3; Fri,  6 Nov 2026 02:03:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838216B05B4; Fri,  6 Nov 2026 02:03:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9156B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:03:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84B841C463A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:03:22 +0000 (UTC)
X-FDA: 85403803044.13.F7B0816
Received: from mta0.migadu.com (out-48.mta0.migadu.com [91.218.175.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id 92A5820005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:03:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uiwzP25s;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.48 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793948600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mO1x09i7EnqPJXUwKJeExoIzGQZI3rHtjjcSVoEtSSw=;
	b=MhtQiKRc0Edby9yGqv7peZQR/lcI4G+O6/Aw2860kHDgcsky/kTunX6MkwyVI1q2hKpuwy
	mDGagZ90YrFxHntA0UMlRwQNrBSLbUN9Z20DZ5lAhOE6FXdIDKiDRubTeV1PO/ytJy9oGg
	/FakryCWEyieXberTq32mfDOVDmqgTw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uiwzP25s;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.48 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793948600;
	b=bFgf1zoqmDUy01i2eEwrDqTvK0aGcCoCg31/F/gc3NscAhDrdVo1Wha/uxdzTHNZaHK2Zv
	UdFZpa3eFIc3Y+P4mLnzD2/F7r0II1Vn3CGXHvMyk+iDA7vCTnJJb7WeiB3wHmC8zKewIu
	uqT4f4eujHKxkkw/yUIhXl08YbNStIs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mO1x09i7EnqPJXUwKJeExoIzGQZI3rHtjjcSVoEtSSw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793948598; v=1; x=1794553398;
 b=uiwzP25szE8R7aqwL388yrOGTv4U7r4B7Y+aJmsOhGmpEl56nTTtuloHNeYlDagsG39M4UYY
 XetFr7qaoASJXkzEHaDo9hMiWjLXhWiSoc/Hdsj1Ki1gHf1h2PBDIQYM4H40LzPWFZJSdCg7FEh
 dxsCHwwGutxk8toJZnLqaDQc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 54b6ffc0bb54435e;
	Fri, 06 Nov 2026 07:03:15 +0000
X-Mizu-Trace-ID: 54b6ffc0bb54435e
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
Subject: Re: [PATCH 10/13] fs/coredump: convert vma_dump_size() to use vma_flags_t
Date: Fri,  6 Nov 2026 15:03:07 +0800
Message-ID: <20261106070307.51561-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-late-2026-vma-flags-v1-10-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-10-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5gc9sitwmq5oqbu4mi5sc5p5kp8fcxm4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 92A5820005
X-HE-Tag: 1793948599-650568
X-HE-Meta: U2FsdGVkX1/B0n2lW2vKjFFkg2hmKgk50MBHT8FgG07IqMV/5jadaJLjrYyWSdsCOjRjbOZTJ1ZhNEGvouqtI+o453Gl51CCfUHCZd2YQzjG2KJ7k0hRyNbLDWNIoydduNpwHs7ZPvTnGY/+/2+oHWvbAzskp7P83nrPzNS1Lxhj10pcokx737a7sZGCh6WvB1xOfhiHibiUP2av+b8FUiw5cgRrKtBZEPrzHIjeWu5b4wwSq9RwYje4/YQ07l0f37hN7OEVEk/0rOTrjHNqUEA4uBUkovQvDOvPF8BB3NQColH3K/TEUdFvSv/Hc9FMdLBJeaxU8raxuKJWgxwtB6iHvt3zC/rI7L99xFpt2XHPqW4zZ68m3QhL/qxJKoJjmKjbNt6g3PEoRVqWLxAELGlIzxM8l7u2BPn4nOLKMoakPBNg9Jf5vw60CJnCw+vWcRwzXm2FQXchStaAQ6Hg9PavN+Etuson/c6FUkqBYEHBBtps9pIJycObQOkC9D6MR6nvg0861nFHCyk9sU99OHV29PGlRyDFbiOdqriJdSgJzxqV5r6s3E0TiEvor9Gx4trPwmz3fJyqL5lftq1czy2W58NyaAQRGw/tANoTVpwvv33fE09tl0QclXjuY7tFC0oTE80vb3qEAs93AP+CE4mSvnc/SNkhpFexMiPqAH/f72lkmNWc6ZJazBnRc6JigaAp2EBhVq8/NcAlYi+JG8gV0EcXAEzMgXZ5TCvgg38rGgY1k8q5A5qxJdrHZuyQaFshXnR/PYEvGo2toZs5ZIL6dZBRGlb5iGRzMostq44VXcIPDLkgxt03nbXX+0PhIodBnwPw0Yb4s1jgyiG1uMHcK0Bzt+V7fIQ79FoTPHldCOKU2joDrlzOtxHimrJbdRx4nQifmm/I5H9ZDEZFkhh6+1g6D6l6Bt6i291jSfHSbZ+6qhTmk7WunZ6+XYFZNV1X/vGaAYiCxSKTGtV
 Pns5onQw
 XvOG1KNS2maAl/9cFwo4JsUlp1w08d8xxAxAqRv482S3HxDjFYeh2eA+GYghhecAG369a649o2D4bu/FPRmLGDoT0TQ0PkIpfNLTDeRH0fjtoMzrRm6+ezrsnSU4902FFkb0vDv5oBM3OxRwIAvK558Qx5yuzIkBxu0LSVKMsdDkILQ0eiCi4HAD2SKqz5BnHo0detdmJEcQJ0v9Ykfk/i/9DxntdjYlzbxtnHmORXg8zXXRV3MrWg2HGOU9KyJxuCffVc7VMQuOg9x746OZo0mchb12ZOw26nINhkON1WDeiZm6gd8Rzb6XkbXCpcVY5BQZwiyLqkj4Scehc8mdeoh8aozSRNszl+Hrts8nMQog3aV165zgaop4W+1jPp2vz1iId
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 09:31:01PM +0000, Lorenzo Stoakes (ARM) wrote:
>Replace use of the legacy vm_flags_t flags with vma_flags_t values when
>determining how much of a VMA to dump.
>
>The flags copied into struct core_vma_metadata remain legacy flags as they
>are consumed by the binfmt handlers.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Nothing jumped out at me, so:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

