Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58900606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 06:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fBum1Kjx
Received: by kanga.kvack.org (Postfix)
	id 2CC836B05B0; Fri,  6 Nov 2026 01:09:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D366B05B2; Fri,  6 Nov 2026 01:09:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E346B05B3; Fri,  6 Nov 2026 01:09:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0FAC6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:09:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6EB7B1A0D04
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:09:55 +0000 (UTC)
X-FDA: 85403668350.28.867FC76
Received: from mta1.migadu.com (out-158.mta1.migadu.com [95.215.58.158])
	by imf14.hostedemail.com (Postfix) with ESMTP id 58F5C100002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:09:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fBum1Kjx;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.158 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793945393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lf0giC54COfoOdgBhV+lbp71w6egVz2uLYQE0MSpLfQ=;
	b=7oQ2je/4n6WN5UhosDWsva+hdCyGMiBnrnN4bUtM96hunJjW5+IcJTvL+xpeYJVYcWBVJp
	a3I6sKgGV4Swg/TMr+QGl+yZyrED9jsEvOy8ZOHIUD5thB9PAdk2PAasFal2tFCZSU6F5W
	+Wv4r+ZwpELSZ0jGu3EDWZOR3DvfcaM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793945393;
	b=OKvxj4ifdoW4T06kJoTNdf6r6wPnZbxCiqmqTL/lwJ0BdWQA+jDPRjEi8tWA5OpirCc3UE
	aimyTYUZCvbUYj6VwL1JtjtGBtvcyex9tcLllEyQC6BDD+kabD12jh03eGxrIko4UD0Zp7
	pcpTWqm5/eItlwIDID2vMeYvEeJuu3M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fBum1Kjx;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.158 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Lf0giC54COfoOdgBhV+lbp71w6egVz2uLYQE0MSpLfQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793945391; v=1; x=1794550191;
 b=fBum1KjxXc5aHuwrSqkzF/umohLHIxRvceiC+uyAyeTwLoJU3HpQW+k+droykaRe5TgN15/C
 WGXJGaP/sHZP2OxsFJeTFqrkWqF2u7+Su4o+lPxVcNQr/dAv/ffh8yawOHorsuTyH5iU2NAwjzk
 pnhqkv9t2Vy8+XM3si0JWR5U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fc26a8218d0fb5f7;
	Fri, 06 Nov 2026 06:09:50 +0000
X-Mizu-Trace-ID: fc26a8218d0fb5f7
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
Subject: Re: [PATCH 06/13] mm/ksm: convert VMA flag tests to use vma_flags_t
Date: Fri,  6 Nov 2026 14:09:41 +0800
Message-ID: <20261106060941.44538-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-late-2026-vma-flags-v1-6-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-6-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: pdg8ufqhd6nwut6rzxj37cykngtxjan8
X-Rspamd-Queue-Id: 58F5C100002
X-Rspam-User: 
X-HE-Tag: 1793945393-115191
X-HE-Meta: U2FsdGVkX1+YcZWjUrUFpok1jkFzUtZTy7tw2eaCZcbX30PZWA4qXvS2VVQaf5NTMbGv4vhCuIUekUYngyJrLPYbV/VCluIYtnezVy/91oy4t8eK0pCoElscoI7dP51NJYIfCwSerIOYrRzmZmlrz6u9lexMjfpZLIf9meaAvA/hCUdfwPRCzAkaQ6URRa0mnB23f7NHgmU0Rc1fMMgbmJjPheQLeX4q49ByvFaNDOHtnPnzM7ZmZv6aG2dbhrHCsi9fJs0ewboCglG3vYgzTGXyPLj09ZLiBxKXWR2CfW3qeoZK4wCYAEEvKt1NdahyJ49C1oa/BNI99iT2quNQogNyQuFbtc8pbycJb9M1wyHtzAzfsi9S8XhxvSiTwua7nJesR3hoStmFTApV3mZisRLa0LvpDqMrOLDGJo41gfHgkSu1Vl3Tog5mKN/pEixyOkutObbUS983yKp/PNtX3F/mRiWp4TQ6+5urlRDjdpbHZjM9S+TnBc44WLppU1GK2DLSFbf0DK1I4sk6CGjHWzQotGKNlCYfDh9AbjSJCqUyHi+wlFZtXC9Jbg8yyozYNKmFV6rbFQxUHJ6bc7sEmc27wWiCnq3aNsA+SCmNAtqcspRtOJsW33SV3q6aL0+3OCzomi19qN+l2j2sL3mECZ2blsI77eIHZW3/MofohSWj0q2lWrUcVp100ofIFDznTXpOEgzILig9bgwxrRjFiIRLFsmBWdSiakHQCXwCrz1xts4P5+uzvZV4Wa7teQ8AwEP3Sag2KEkthFXjUAsgTS5Y359M40CzyrDsu/XTGGbK4ZXWTgul7UDARudZ7d17jKw71MzhUjQUskUV4bJJgrg0Tff8LYADafq+o07VbyYRNy/RJ/P0m7vwgYxYYTuPy1oMiQEBWfy7+QEQHVyo4LpnBvIJeWN+4FlLJwsoQ0B+v0VQhzCqeP244FyuWzK7m/DRmCiskPsHMEmo59c
 TbFv3Iyf
 CBCcLzO97jkC+Qi+JMVFFdQlJJHnTSroincbuX6x+Sg8EsyxauAHCLJkVz+L1hqDb6cN9ybxvYuw9xNrpvh/fMxkL/9hiAt+D+sV5fPUYaRg83p1d0ScdoI1wsfmq0c8+DXtC6ilhlh0kAzdmeZhyBbgDTkpLX90C+bxtRtVIFANlJtfBQSESd98xp116+YifuMGFM1/Zt6qDI/a0sd7y9Ov4nH9fS+H4cs2U+UACWb3A90lfb5R4fbWP27XKrlQ7FzK2SG9DT/pclM50l8brwRX+uISa/JRQZjKSa3dYbQRH8bzI/PZ/ouE161ECXvUsZP9+9uhdBp4FbsxSVSvx8xOuwkaqCjQmBk+EsmEv7BdZi2fTLrYqr5BCOAsON0gzqyZ5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 09:30:57PM +0000, Lorenzo Stoakes (ARM) wrote:
>Replace use of the legacy vm_flags_t flags with vma_flags_t values where
>KSM tests VMA flags directly.
>
>The ksm_madvise() interface continues to take legacy flags for the time
>being.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

