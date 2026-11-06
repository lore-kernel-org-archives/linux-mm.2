Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AEB8606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 05:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p+5ATKcy
Received: by kanga.kvack.org (Postfix)
	id 82DEF6B05B0; Fri,  6 Nov 2026 00:54:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804D66B05B6; Fri,  6 Nov 2026 00:54:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4586B05B7; Fri,  6 Nov 2026 00:54:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FCC16B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:54:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACE6F120C81
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:54:28 +0000 (UTC)
X-FDA: 85403629416.01.EC2CB3A
Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 97188180006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:54:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p+5ATKcy;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.74 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793944467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkVgJPqUyM/MWdECKVhoMlY0/kmR087+Z++BChEE7DA=;
	b=Mx0KaLaFlV46JX4uuzYONNxNargDvvQMi3aK7RVGxAcfZGeVosZDk0Prh//o8CkcE9OaWV
	xCQMpUlzHyamPbKeEDbgIYy4g51LVuhxGKv6Y1zT2aU7Ffu9+kmuFixRlNSQmIeEWaugbY
	nzBxJaYwSX12sTYAljKETHqDWzDZ6bM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p+5ATKcy;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.74 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793944467;
	b=Tpagf2tqyfBfrHlUoIC/tNl6VJPRjIBsKnfcZflNrvKgzKfQOVgcsFD5s//UKD9mqeaIZe
	Eh3/++tsvW5f29aeOYyLZMZbg2smPuHmwVaMYvWtb88sBFCAkcycouzoy937QDHgDQrtHh
	KruJe7pR8kciXV/ibQjPwr+uyHQMPXU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZkVgJPqUyM/MWdECKVhoMlY0/kmR087+Z++BChEE7DA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793944464; v=1; x=1794549264;
 b=p+5ATKcypUGZS4VBqs6eMheOi6I74aXlfRwogwAjhKBYw21b1VUhmGNGpK9SSQyZMEJBoKV4
 FckvjSRIpg6ENHbkXNGTrjOnx+hHqUfWH8RrwDdGDeB5IreeZ6cJmJnQk4qRX1/j7CRotF/+VY9
 7Lfilw4xylzHGllFPm9ybBRc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 578f26654fbdc28a;
	Fri, 06 Nov 2026 05:54:24 +0000
X-Mizu-Trace-ID: 578f26654fbdc28a
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
Subject: Re: [PATCH 03/13] mm/rmap: convert remaining VMA flag tests to use vma_flags_t
Date: Fri,  6 Nov 2026 13:54:15 +0800
Message-ID: <20261106055415.42873-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-late-2026-vma-flags-v1-3-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-3-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rbfc6s1dey64x1zz3jt6k36w6yg9paan
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 97188180006
X-HE-Tag: 1793944466-883321
X-HE-Meta: U2FsdGVkX1+vbrAHac5FM7LzRu4q6hyNcZwa7/HIqJVSFHixTrjMYSvp5XfaPcKA7FrXFkrYeXl7ovz1+P5nd77GnKH26Nnr4Ynd3Epmv5Y3ob8GrhVZhHZQ52+rJAxUEKrmlSUGE1lUmZmk2t3BfzNx3Jeczp98qy1H9ZmrkvcBY9ZnPYGnY2cQVnc3Hje4c0xHZGhL5vc7kQz/tH/YnlGSjaHYpw56MTKa9ybNRcVtzTjPM43dqIC303kYBrV+4+KjBzRKart31SK/9nb1skfxwP3hVt+/+cuq80yq/DBGRe280kifa6DC2HUILZM4ETvnwHMY2GnhDdJYwDo1JuB0Olni1Ct2yfie77+aB4jvi3bS74VBqkC2IjuRjJFRyriZISRotxKA+oj1fvORnrDhjq+3NJM7ARYqc1YIoFywouAC3P8S4+Pu4Lt+oCBbxG+JLrFvWz5rTAUeMEhAlQtGLP9hSQXtwDWK669fXHxMfFEMg5C2a1Wi3Z/LQJkYgzYOGwIM0mo9V47ddCmUH/x376ce4RtQIuEiSKouNMVdVLinywKfFEGlMuhQAgiPTpZbjo0mSyLxpTEv4Wj71kKiH7yKd4vyNsytiai5lJrmHEH6L6BZWuVrc4iOBqNpDn6GWI9owUcBVltmoHBrTW0JbQiFStF6SdiRHO4abkXWS40QcxNV4Vm/9rjxslZN3CACN/NfrlhTSz9CFJAZugvdX8CNVGZxlZNMTBE9HK6JBc+u5ba25gcI2fFposcHXL7ZcvLbVjdusDUcUEvIhxCQ/qW09kJHoUVKcSWFj9lE22E3fySZbiSGjt8v3e95w9jTB2Bw6KW7ivR/QSAtoo7994kWWZoPCnOcwEzJLdKlno3Km9hkZv6DQTbezZUI8K32tseQGSc1YU8jvQF03QYyoP4nLhH2vZH23KZtIjPFtYK3KOHftgMFSmJiE03/DtdW/NLRJrx8kBcizSR
 IGRSJj7r
 HwLSLGc87xlGYlAAaNAxCnwT/qZ9xQ/ccwVoWiZANc+lrsB73lHeecEnA61SjlA63SJk4znVb2BIzdcWF1XbvMJmhsIw3G618qxSn/rrKGi94T3441SWOUwTxIyEelBvy8mVwZuPigTF6YrnfOi6eR4b7ety8/6nWwxgUe0284u9Zu11a1BviQtmpJiWXsYt72sUEGvp05ZClc+SDwqtJOI2AR8cMaSWAXweeY53TLu3zvYfC7ic489j8vOdWkGgHaPoryj4TT4u+FcSz3Svwx23T4ukNHmqQ+lFBvxIjWW6vxTjN3WZbJEMB4qJKg07qvAgx8yofdTvbnzEU8edN/Mxud384QrJVQvZQBHAg0x32dNZ+X2WMNI+5e4Ygw3wX7rwx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 09:30:54PM +0000, Lorenzo Stoakes (ARM) wrote:
>Replace the remaining uses of the legacy vm_flags_t flags in the rmap logic
>with vma_flags_t values.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

