Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D07D606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 06:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Equb2DTs
Received: by kanga.kvack.org (Postfix)
	id 5A5D56B05B4; Fri,  6 Nov 2026 01:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FA26B05B6; Fri,  6 Nov 2026 01:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3C16B05B7; Fri,  6 Nov 2026 01:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C64E6B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:03:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61554A8BB4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:03:34 +0000 (UTC)
X-FDA: 85403652348.04.E7E13BD
Received: from mta0.migadu.com (out-232.mta0.migadu.com [91.218.175.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3F66F40003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:03:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Equb2DTs;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.232 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793945012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1dv3z5zT9lsczFcdl5n0QdTgMSuVwfBVBoxw3rRXK20=;
	b=bsRQnEemD0VdmMFEnVJumD5URBLtsOO/lqs/ImaBi6DiBq2pRC5fof5d8j1xZOHYKCfO4/
	cklPMXWiHsFLh5ggF6t6QvcvNgF62zSj716Y7GvIRm/IPzJz5/tyALJjMcQVeZMMNdQQFn
	8dWHgnglAYzWRZYAsJfXUx16Rzyqgh4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793945012;
	b=dgtPWHseSF4/D8P1jXHfMLd8pfNAUhV5cFkM272POeFYFFWxJg2+lkMmnYWHARL6SzG5W/
	7/tt+c270w2uqHN1gqRd+zlRO69iQgCw+XMhHZsCgWFEzKl5KA8a+MiK+NS05svxnx7MeC
	igVxSRZikGANZ6ntWfi5KQeQIMQBMVI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Equb2DTs;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.232 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1dv3z5zT9lsczFcdl5n0QdTgMSuVwfBVBoxw3rRXK20=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793945011; v=1; x=1794549811;
 b=Equb2DTsW5lM1cyS5BmOLbSUEiZeHwWdMntbvWutT+GB+cbnZu+270jtQhqx3NeTOeiNwcMQ
 NxstduOKiNHidkSSEZQgHoWsfbr6DhlJ2k1xU7KZjJsn1AkvzfiG2FtKtuxNmumrv63EMFzyvyq
 D0OTMPvtDWSrDzubRGc2rPYw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d15d1ba08f67e7a1;
	Fri, 06 Nov 2026 06:03:29 +0000
X-Mizu-Trace-ID: d15d1ba08f67e7a1
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
Subject: Re: [PATCH 05/13] mm: convert THP VMA flag tests to use vma_flags_t
Date: Fri,  6 Nov 2026 14:03:20 +0800
Message-ID: <20261106060320.43724-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-late-2026-vma-flags-v1-5-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-5-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: r9g19u5mo4m31jrjbdt3ta1gkbpsah1u
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3F66F40003
X-Rspam-User: 
X-HE-Tag: 1793945012-137749
X-HE-Meta: U2FsdGVkX1+EFQ17iBVJArjev3yC3gxU+WjK1Qf6PkN5AZ/NlhKBzjxdS5V0XvJPRLimb5aUMru9O3cRP7sqp32XhGYwF4f3srP/OIfDeUV8jSHy9IdoEjQ4WEauTEz2vH9GO1OXcgXxFA6xA30tTQO1ojkj/x+HvVMsecjkl6o0HAEA9hu+OkkyaLdQTCVyIOKBHYlOaiFG0j6f90HviE3GBKkRULCoQVEOoLScZAfXpGjIZCe6FSVn/C+LddlyfPesH8v3IXf/NIDvLxu3eKBJla6KHw/MVDGzVf2z0TtcVYCZLHeSXg9zDiLJxlMRsiitJAZHANRC/9PkvhLqLakf5RVw4nJQgiWGT1U1XlLSyROwgcEtTCuUP/C9f43UZUYji8/O18oRbdKGgO8ynjnOMS6RTJ4ILhMc4kqIOOlbzI/VIDwEcHhQMIkurElHbrakWmP6KdxDURg0mnjHswL11nL10H2eyBsEyHj7g1k8gZsQbaEbERPUobggCpWkPbd3+7Qbh0NIYERlTnEBVXwQXLPz1Ri9vSYKRkP2PUx8g3btiQJRCIuTCK4sZSHw9W1f6HfvUM0K9Be/KPY28210pxzwN2vCXarahZDNtN2WPJOderCJxOkJX3AgCVSxx2bUG0uK6bMuQMm/yYdJrUWQThKUHSurQC/owkyF+ZSiNoh40yQWYRGJGaU1nE4Vt9VbotcgmpxkAp4rk9mUopWLtYe02nCmuzEEaw/v4uzsjf4ZlL+Z1Q2ivVg3c7IcZfLGLEcHK3guuQ+aNoNihjaOGFT9ecVlYWkOyojjqRynDP2nd1zwDCvWqbLLYwYMXB20clGT5s1SixUdbWQOY693aasbD0PKDAYo9VLjA2i3v5dSj9uedNx9lBJGWgkTgW+pd+OrEULGgexiHjXcW9jPZzjBznlPabdHrA6fpYee5mbXJqboBiwTI7UgAaprFifY61LmASGFWS17wF4
 RIIH81UX
 Rok/l7pMWvK0RQFYwo4BJYBXZaSyyTALRWXpRMhg9CFPhgVxNrxlFiiis4Eaf3EeQqAsXlMHojlSXi+XUOK2/q8a2G411ViNV656Cvo1nVjKnFb5FHemi/+cdzu1wovtnJqGn/1pXza2lGSI8632Tv1U/N9Ob8JJptS+LttvDGsMdu+v5v5qkVxlCOYyLrdk2S7nBdJS11eTcAQ3S2EFk3lrlaTFsKoIeH2naI7lArvU7hI559kwPMi485UJkYliytaVKj/IjpyxCvNr4rd4M0gZGbMLjSFABzLLlRH8b63+KRlRuaUuiB3UKDD/QySB6jMzUYsGm/yVf4UwtqdJDhSZhDj+USmleO9KhgeHbR49XaiPU8pA2Ub+UQ1p7EIXrlnzH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 09:30:56PM +0000, Lorenzo Stoakes (ARM) wrote:
>Replace use of the legacy vm_flags_t flags with vma_flags_t values where
>VMA flags are tested directly in the THP and khugepaged logic.
>
>The thp_vma_allowable_orders() family of functions, hugepage_madvise() and
>khugepaged_enter_vma() continue to take legacy flags for the time being.
>
>Also update BUG_ON()'s to VM_WARN_ON_ONCE() while here.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

