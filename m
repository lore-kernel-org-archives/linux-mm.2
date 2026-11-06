Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3B8A606A33A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 06:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KjbDtO2N
Received: by kanga.kvack.org (Postfix)
	id B17E06B05B4; Fri,  6 Nov 2026 01:38:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7D86B05B5; Fri,  6 Nov 2026 01:38:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C12D6B05B6; Fri,  6 Nov 2026 01:38:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79B926B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:38:22 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0BE8160CB5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:38:21 +0000 (UTC)
X-FDA: 85403740002.09.984111F
Received: from mta0.migadu.com (out-88.mta0.migadu.com [91.218.175.88])
	by imf08.hostedemail.com (Postfix) with ESMTP id D68D0160007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:38:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KjbDtO2N;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.88 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793947100;
	b=l3xaKYtTeQ0WazFWPJd9Ez0pcbly+i/6tO9IuT9Bjv3DXsIiU9H6/Sk6e1iUQS41Mzac/f
	gTI60HtFJ7wJo1GkL6KiWALhWd3OaKLUdVbdg4vzdBpDf2Qnji+anAJKVqi885XPzXaDpr
	Hx/DVmdT0a3vCbe3R3Uu2EKuuj2yDw0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KjbDtO2N;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.88 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793947100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcht1R5s/T4pHG5HNU6dTugC2c81irUDLp57CkDkwJg=;
	b=prn7VBdc4q2mqvKw7aaJoNju8DyLCovr2V4Z/KUg+CJYpk+e797+OVoWEp0rmCyDihYW+R
	06NDv2D+/QFp9GNQfeNoVyurYC8RuZCx9VpmSCcilJau6DjsBF9+RF6EWyarNje3QacPFS
	AXlexLSZSb2/X40qxf6AjcGHhrNRkqo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tcht1R5s/T4pHG5HNU6dTugC2c81irUDLp57CkDkwJg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793947095; v=1; x=1794551895;
 b=KjbDtO2Nh5euTW+0rriEBVaz4oOCla6bAuEgfNeiP3OLVAxPssj9vKMvG4+HrjoYeKeEHG2i
 mnC87rPCmICtl+Y1p5esleZwvRjxdgA7vbxIww+hx0D3rgrMtMp5ghGk9zNbWewAVJ8trrO9w7e
 nYAOHsKkmhYy2+k6ynzWRO/E=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 28db605e17711592;
	Fri, 06 Nov 2026 06:38:11 +0000
X-Mizu-Trace-ID: 28db605e17711592
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
Subject: Re: [PATCH 07/13] mm/madvise: convert madvise_vma_behavior() to use vma_flags_t
Date: Fri,  6 Nov 2026 14:38:01 +0800
Message-ID: <20261106063801.47076-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-late-2026-vma-flags-v1-7-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-7-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t41sa7ggdeif99kmpmu5cstnexeqmmas
X-Rspamd-Queue-Id: D68D0160007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793947099-547831
X-HE-Meta: U2FsdGVkX18BultCNJU2zMSxlmv8gVWD5Dgik+EWHql/tRhn0sK9ywg1DYbNqmKSwrrzebIoGdr0T11nk7XUTQuyL5dER/9ozQ/VFvGL/OHRUlDQe73vr6nX+ale+pjELb/4nPlOLQb1z7JEqmOTf3ZUOcdtlkHIF28V9oNQkIj/WD1Qwl0yu6Invzmb8gO7HkEAkAaICZuD+OZLXuNhfdN1rF04KVQNc0xRL/zrJnVbHBWV5Z6MuX0IacNqYCyG3vNSaZ0xl1Jjwt8lthNWjHibgkvZBscTMUFOV2E0UG7cD826eYcBz8qUPOjRrD7TQw3wzH/VxXbZpPTHO1hg4FWFGtJ6syVR5WNbLL4cgPuEby/o/oXLSW53QSP34vSP3OZ19FOuL2228YqVN37ISqkBwOUyaQGSuO8HEXioMAA6AC29CVsvQEUJDBe5tk/vFqH5Lw+hN087WjGIygcZS6/d5+98ZDb4SissivA9ohMXofgPwXWSf2KsPgAPOyeusc+XzrkvyhJmOh/hlPU5HqadUb/Qtix+dfuNVtZcbLrzwSU1jHilYT2MLHuBdGaCm1ykwKeaJt1L/rTnHcuMByWI4VwZF1RdySxV+jthWnW8Hw//dLLhb1Sxmec+g+AITtFcw/vIZ8BLQC0L6JKMqNP4+OqwgfsShpWYxnbdwqE1r2KrFA78S+o+TP6hrvrrcRqBK2mmVbg/prc+n3uc5xyWW3HteJdUrRNCxL7hWxUIQOPSALKj4DxHMNLyhV4fuAst1YY5bZbgVxndQUgll/+ub1tSrwfEPbhoVvsHuNX2m2ec6GWdQPVmSUL5NCUXQMzXK/dqZrHNjkbGrNKJMbEp2Dn4nBBRE2Fi/T7bGzMgCQ7RmhZH1GV7RB94f/e1+KekipLj1NuC4B75bK+rJfPghwRnLLdy138/8mFJ8G65l1/CdUjpk34T+sipRhWPc5vym5TKf+vNB4zNvsk
 caCfUXEu
 WudRChNXT16FKjcL1dxtSkfzTw2qVdpnh31Z4wjLzylzIJSGWIBE6LvP7098k6qBjhTz/wAWBhzEKruI/uFxw6uDhadOBqNYxNYC5cslHtTHHPTX2H0qWyAInzb9ht+n7GHyJZ2CsGOqgYqGjLXZxkg/uvOVjV7qx6zzyLr88VJ4duOmbFz9BIYq+iKdgBaX8lNo0pMjP0+Hy1mrqcgZedfKtcvURdyipBIRl9OSIzg+UKN8C1KdVVpXHddC/7l7bogW6LmC8lOxIFZqUcd8UXLDEjZcoegwp0AwsyyROXpD++51eLzBTk4F2RIAHQ5B1Ygw3kSXTeVHZb4qhVcMnrMUkboxYxnQeMn1/i+kyg96H3wAkNZUqYeF09oNQo/TviZBA9IAG2OLyBZIzQPlKXCK5uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 09:30:58PM +0000, Lorenzo Stoakes (ARM) wrote:
>Replace use of the legacy vm_flags_t flags with vma_flags_t values
>throughout the madvise logic.
>
>In order to do so, update ksm_madvise() and hugepage_madvise() to take a
>vma_flags_t pointer, and update their other callers in mremap and the
>powerpc KVM ultravisor code accordingly.
>
>In the latter case we replace vm_flags_reset() with vma_overwrite_flags().
>The VMA is write locked at this point, so the atomic flags preserved by
>vma_overwrite_flags() cannot differ from those copied, and the behaviour
>is unchanged.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

