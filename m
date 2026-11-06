Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C5C5606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 05:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XdOrnOff
Received: by kanga.kvack.org (Postfix)
	id 3C8106B05B1; Fri,  6 Nov 2026 00:58:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378966B05B2; Fri,  6 Nov 2026 00:58:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241236B05B6; Fri,  6 Nov 2026 00:58:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7CBC6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:58:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 17A181C447B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:58:41 +0000 (UTC)
X-FDA: 85403640042.05.0D50900
Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id E174A160005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:58:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XdOrnOff;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793944719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkBehpMQ1APfXjT2IE3+mlc+y4KHDiIRfa6RZSDO6oE=;
	b=2hlEEtQYU/QaB5ILK4vVzb6sdONkGph+hGKA84KfqovMGT5cJUDHYUyxHruZOhnQfTw/LC
	lBf6Zss5C1BuIO0mo2TCAcLiAYOrR1dmT2MccaxtbGkC8KUWuNniJfjcOE1KdxcK7w9emq
	6tKqK3eXEei23mILxVQzLD4id49s3X0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793944719;
	b=pOsX9gJ68OoMtVWWavxruB55YMLGpblxp0rK6MbJ5BWUmooOT7JkmTy8mWtdw52LMwG0Qx
	i0TMDt6vY8uLqLm5v0Uqv600ZDyrhbqet3RVptAfTQtSzvkh4J6N088wY3C/CP2p1otgql
	gkbPRDaZ/UrwYPsQ0DZJRqawByt2EUU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XdOrnOff;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PkBehpMQ1APfXjT2IE3+mlc+y4KHDiIRfa6RZSDO6oE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793944717; v=1; x=1794549517;
 b=XdOrnOffQTx1UPchmwcD3G9CjSPrVCHD4iwwf1eez29n+8UuEmQWBnNuo+tv+WX0jYnIuuKn
 ZEDuk3T+aac75YrXwLgooXesiE0yhoWtAL4UfUotSKwnYE+DimImSE5t2leD493mh2Kd5la+QK2
 G0d1yur0sUNpDmcaS0qriDm0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d93371a15e2af6bb;
	Fri, 06 Nov 2026 05:58:35 +0000
X-Mizu-Trace-ID: d93371a15e2af6bb
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
Subject: Re: [PATCH 04/13] mm/migrate: convert VMA flag tests to use vma_flags_t
Date: Fri,  6 Nov 2026 13:58:30 +0800
Message-ID: <20261106055830.43260-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-late-2026-vma-flags-v1-4-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-4-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E174A160005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: n4k6arp3dtbz1k7fd73mup543xm1zx9e
X-Rspam-User: 
X-HE-Tag: 1793944718-931129
X-HE-Meta: U2FsdGVkX19ILHtQKxW4vXgGsy7/PJ/8GHkXycxKvMpm7u5fXCTepoI09OBpArD+Zq1Y9vACW1mmlzBfSVDsfuhSQ1/GYkTROF7RjUtHMzv4EUiwwOLbCeqEref35C3xyU1AMjxwFgnX6LFG6zskbLVreUDemQXoS/L245denu2fiRuXEu/dIB6KHILMeDFJlBwmWnN7Pm0w8T7klRUswaQBnBai76ydg3wHsqzl17jpBugEbDeNWfrNFHGuc/rYexgZer/dm/ltvaCB9JF8uvBljKHkj1EoqJsWt/lEoUT9Aon7SfuZ2qKvR7yqdkVS4CP2nxFOZlgOgjqqGIkxDEJMOiFklW1kDR+QGjYdIOQIO2NWTxG/jkVzUt6UZVrer84ddFiQxhv1zQMX+GJt5Ey8VQxdOiBCz1hc+MstmkUAtEFgS3vExXfLWdzr/tkiiZ68Z114OBSDW3bo6zdpkX95P/DmhvOzBPPeILoxS8Rts6j8hfju9cJSLmd1VLIzd6y8gU6bQaafKXgICvx/HQ+mthWNT5DsvbD5D4+ZJP9kCv0TWlQKlnRML3gthF8JH/1Fj0p7Bzel0MK1ugsx4Y6a0IlQ6aDcVkTLMpGciBAgEG2Oi5aMOal9kTXjqggeG4bK4lB92TXPO0wlZZOZUdRwXouEdOahEGlTXGw0TIuEy2VFTnpfkNZa2YV77vGzhvsCta3Gkv0FjlMleLWlzJndAfkQLWK+LGF6E8Jan+9i6SLwBGMV4EchhOMZCeOdP4ShWsdGCzT10J6zJTdIkYKziSs80lArYTykqegb/vY/Kcnj6y1EYBDl8NbCtzly705NlBzsMAw5ZYQTK07QpIk9Me+C3y6VFHKahbr1sKVApYCs6YNF7BWwj+eaPzsCHm/x1zmPLZigbRw1CkAOajI9alTf+Ka3Rg1AR5668EaXRZB7kQYBETyxsUDlWFG/0FRp2mld3KbdfexEhQ8
 DD/ktpLQ
 k2nSIzATezHi4yXKwANddY925R99po6mbS9YZZtZr4AtfIDDGBvlHTlEjPj+LTfsfc42dro1AtcBPekGxCbQewaZqZkA25X1uZXuSZdf7n05//cEW24Zptqw4ZzABlLQRGwDNH/UDqRRk30sLychOjGI9kl2yOuX9a3Jvz01z/5u+ugt3gRmVshSgi0vcFDEgpPwVl8hvUQV9qXXnfG1/pNDXWFwhaRrT6I9Ag33v0/N9AyKEDFuHn2wS2pnCVGtFgyNKVMB8SI/ss5x2x+r80181jueca6NosVSJULKWM4lQEqzco40tFHJ7CphaG1l31jSRLmwIswCk73GroVxquLSZyZWAHd32cFkUVGRG40Zuyu/Fl8BFGmVzwl5mpm7Q13lj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 09:30:55PM +0000, Lorenzo Stoakes (ARM) wrote:
>Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
>migration logic.
>
>We retain the READ_ONCE() of vma->vm_flags in remove_migration_pte(), as
>there is no vma_flags_t equivalent, and arch_make_huge_pte() continues to
>take legacy flags for the time being.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

