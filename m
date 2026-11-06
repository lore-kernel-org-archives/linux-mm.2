Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B849606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 06:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IcbILbbr
Received: by kanga.kvack.org (Postfix)
	id 269416B05B2; Fri,  6 Nov 2026 01:40:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21AD46B05B3; Fri,  6 Nov 2026 01:40:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109506B05B5; Fri,  6 Nov 2026 01:40:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7E496B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:40:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79A0A140960
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:40:54 +0000 (UTC)
X-FDA: 85403746428.03.D42F618
Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7E728120005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:40:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IcbILbbr;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793947252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4USJW9qcyUNn/FtQy4xUl++EAECigPJpoER1jiXivk=;
	b=p6zkNGfECI3ugzWaz4B54CEPpRCcoOqpieL999MojL59i6VOJunxFRWpnPwHYSeDGUlEOz
	jUvALJc53d+SNVuWaCYtU+l1T8v15gaBTpOyMSCAhPIh95FgDSwZohbavdq0yO3uxgLCyu
	5FqYNdxSQ7UxsPDpnXxO07XTimddHl8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IcbILbbr;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793947252;
	b=g+jEUgGvsCB2y1LTruFuHVvqJFAD14bcZ3/siA31Wjg0DgPsS3VBJRyoT2lxElV38KIjD4
	51fn/fTFofhVrNOsu1KQe+mYzqR1TvU/w0EDi4hnfEV0lTvr3k8yNXMA17ATwOWkLRqml8
	vLB5FbFIoKn/BAOu7Bkl/zF2G6WN3ZI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/4USJW9qcyUNn/FtQy4xUl++EAECigPJpoER1jiXivk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793947245; v=1; x=1794552045;
 b=IcbILbbryd1I3w1iL8fhJLF2OUYHv5Tyqkc68QQjOHZymCkhfCKDjFPt8t5LirvIlRN47tqe
 ee8LhFrRGDFMoSWHsHZ1JFPRE1zEzqKvRbBoUIV3cCuFStEPm2EHHYMP8JIUF+xhi6tgbXWaNEp
 SgWZgo+3zPwEUJKaCwLHEWp8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 500c6a5405d2c587;
	Fri, 06 Nov 2026 06:40:42 +0000
X-Mizu-Trace-ID: 500c6a5405d2c587
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
Subject: Re: [PATCH 08/13] mm: convert miscellaneous VMA flag tests to use vma_flags_t
Date: Fri,  6 Nov 2026 14:40:36 +0800
Message-ID: <20261106064036.47774-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-late-2026-vma-flags-v1-8-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-8-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r9ima4zwfkcs6fsecja4epq9neertqzq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7E728120005
X-HE-Tag: 1793947252-521337
X-HE-Meta: U2FsdGVkX1+NQGi2gcU49uqyNa3+r1lvfS5RjpPM6Ppl+e5logEVXHkyRnyVknGXHYv41qJ6XWa9kIooR+v5GPZvdcJi7OkPDY48kZZ5J9QC881jXCLZhAAQrPgqAmj2p7TPUM8IB1Cf1ZAznGm3Ajb9hGIrVChDal3PiAw6oAEeGBaUoybgCWeKZBAnbJX/A5jkUtSqYTGvZaagaTQHQ+rU1uGHiwzMKfgFMa9VZesUOQrUsiu4Xn8qbkfBstnYSh1M4zuMsPshgRf4DoOiQACXginEARVdIwDPSyp9NmlojNuSE2N9Nx5BHbmm3jCol6gW5dh2opF+XzY2hixQqGHFep+kDgDUChZRxd1BTXdaFJMprepltOtVglCR8N6tr4jAc+nZnkbwzS4MilQBUCLuUoQm7XgGfgHojfEHR0/XhQvKHJKQcGsks9VHk2XRnQ3nwTBTKU1OxeL/lNpZO/EjWLE0w+vKhbOk5FmyjafdgDbbL1lbV1XEYUok1Rw4YfW3qW+4/zBhRYNQrLJ3j99KFo/nHyHNCnslCvR21LEqGwzdwOdC+ewAE1qwRke3sLibMMwKN4BQaNtItP804kMM7sXVtnCWL+IZmgLkrCi98MofpeprZvZiY9oTCBhLGPPSrE3V+Sn9Q+G2dx4t21SvuaYD62Yy/cuFhSyEYNrx3ZjNmX9maZSUKDA9ohfYiXlZWw8gil/zvgRzRxxS7vyPzAI3rMfmDR7yTvZNPWNY7forLqLvVAcH8ZUM7AkgPtrUvgYMKTWvTOtrMnxq2no7b6KakcIdji+DfxGqNTGo9gARUJJdIXvGdHXA8OUZ+HBaGOcji+7Y5LCGhgw5H3SQAw4nWMS3ZPTejh/6gRPCGJwLMRuuYCQb9dORe6c1FLilHv2x+0+fJo/J9S7jpIruIKtrXhBZYn0oPxBDrvaIC1ncl20FZK0gHNctDZkq0W91oxNSkIaIBQunUxi
 k8sNDG32
 OhmtzV5WUVuT98mVu3AwalkQbSW5/q1GvqjMPyo7X9tMKAsGafZ/fcBXdm0GjLIDoPRBkIYvQoyfDUrpPdxf8bm36RhoGP6pwdqg+xe8wO/wMFrFxYDgqtcn5yCHpOkjzuSU83jG5Vl4boM8Mjc1OccDVkv8GfW+aSokylDDZcFNDbOc7lQFLAjpyPfzxGOVJQICoWbCrjrzNIEADS9kpldnfp7K2VUlp7nS4m9CKC647JYuD2qHK7u1JPewwgwiVkbWdn5dvXy1eQWYfoW29BrxIX9OXeKy82ExImZBGNNGTiRF6QGMEfCY2dRWuBr9J4rPN4kX8t1z1R3Iukkq8WewBMWYXbZ8EqBrWCX7KpoeXIK27Ur3KY+0KvxTZM1+3DQDO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 09:30:59PM +0000, Lorenzo Stoakes (ARM) wrote:
>Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
>remaining straightforward VMA flag tests scattered throughout core mm, HMM
>(and its test module), DAMON and the OOM reaper.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

