Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF4C606EE89
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 05:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SwviooWv
Received: by kanga.kvack.org (Postfix)
	id AB8856B05B0; Fri,  6 Nov 2026 00:47:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43586B05B1; Fri,  6 Nov 2026 00:47:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909EE6B05B2; Fri,  6 Nov 2026 00:47:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 679286B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:47:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 400CA80C83
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:47:43 +0000 (UTC)
X-FDA: 85403612406.10.251667F
Received: from mta1.migadu.com (out-140.mta1.migadu.com [95.215.58.140])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7C97D1A0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:47:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SwviooWv;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793944061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZT+3t8jUtNYvSMUXBsXE5t2lolnKWHLNl4pEvr8+Rfk=;
	b=Y6+PW9Z0xakVflJpaAXLwB1pcECiESLkr6mErZxX9hTCtpI4UwtWwXLYPQgzei+w6PtltT
	GTbvurGfHVPwb0MQ1/Rswb/a3WLf/MI5Gwa/a8XYtE8MAp/g5//uBw0gipicdMCF8XU3/8
	NoYbFxt6BFSBlamU5RTw0vYnG0m73ng=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793944061;
	b=iiY+85gvNjOqRfVf2mWkQ1azzCyWBZPfd6hBfZ9VXrFB+PLjJVrfXyA8aF1G6JpMYSlX2v
	M9l2MyUEmFl1Ma89DwFwPjHdUldi023XCy1q4fSwxc0PpBAcw4qa6XSL6AVnVWi2AkeNa1
	OJZLPK2sAF8icOkpZ/bkI5kM2106tik=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SwviooWv;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZT+3t8jUtNYvSMUXBsXE5t2lolnKWHLNl4pEvr8+Rfk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793944055; v=1; x=1794548855;
 b=SwviooWvDejqDRzO2A0nujqib2PF5765rIQLYOGZu0/WdViNdT8Ds79PoG01GewUKyIVCwJx
 Jfsc/3gtIFAGfelNEfNwAqtYBNnfbnBeG8NMMttoDjdjhCN+dWkXu+gToTOUg9i804PEa9BjD40
 sSZyFc6TRAoPag6ek3iqpitQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 094e1342a4777852;
	Fri, 06 Nov 2026 05:47:33 +0000
X-Mizu-Trace-ID: 094e1342a4777852
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
Subject: Re: [PATCH 01/13] mm/gup: convert GUP code to use vma_flags_t
Date: Fri,  6 Nov 2026 13:47:23 +0800
Message-ID: <20261106054723.41863-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-late-2026-vma-flags-v1-1-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-1-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pmjdik6ko4fuk9i6cbi3yzt6u7dcwire
X-Rspamd-Queue-Id: 7C97D1A0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793944059-453028
X-HE-Meta: U2FsdGVkX19OSTJyli0dVzGuIZhZ1RO6Lbnjddt1SDCrW1ZCumnwd4OzM6qp8rU4J59GfS4kWaA6DEmLFzOa5Dzbp40KDbUmQE5I5f0OC/s/jjqxIcgGdWZtdvtAHUkz0vydxuZI75Ete8uIqZfyHirmBEuFo/8BIDpI9Jx6fwvgjkyHQKQ5BQ2ePRoreC/Ei4gzTO0Jk4TYUSvpqLyYMb7HLDz+S8f3XTyMuheQxqhR+Ob1sRmAmyc4gZKkVSX/nHxBbzfSEl0Gw+7s04d4usd9+lNK+Hd6jssJZmlJq3roYKqP4spyqrVtuRncPZlnVh3L+Daw6KrfjgNL9BlnCES4ENoiXjF5aQwEezgTE1wnWjM1f1ttEvjSpGJdbzNQwm+m6gty2g0SzaBy3yQIm5rycu1azV0Scck+FgX8+vd3SBYcaAndSO+FJ++3fKoqY14s1OpLobMt9ou24RBZ563jMYisJp/5LTxSu2L0aUo1EOqdtzgtuk+I0k2d4mdbgmlU/dLPuyv9Tgi4pe+hFufhmgpfUrYn4zRZPUMbcm2bZmMKy0+knV4XZ1Uw2EOpvLVqzHbBernFlMR9y5lmogs+inhARYGFXhP4CMG5QY8ZdNSgroap1XboQKDLWWQ8Gt/TDF3/JGm6c5tra/JC/LVzIqpenCPDYqvjmbpG7J8fkEdiKN+LT7Kthk3hD3wgw7P1xkXBLaRQQlIF8lxJbZzREDwIYpYsSmjmnX8XCbJRXcjshgTGdWGZSMMgKYVDrPsjNUMWkLOlawEdzvxHa1iAGPpFnDzNKPOiCqqJxiY7rEKv5WeZaTelyNd6lYeYW19c79XrdcKqRkpa2otq7Rymx2mnwL2nIPN5I2Z+i2ac5cjBSj0QXx8/5DbSreTA64eT1btkOjvrsxESsB0ZzJROypd+yUNYBozQSqpdVZ8oPHONLbpHu/+BW56HX3c8Ps904FHqunIPh1e4sLH
 WrxxIVKS
 joGoptUZ4pHruDrhZSBIJJkodHADHW/iQmlf+tgdAcOFctSoMhANpcy+rigb7USinjfa73xJAOzDNX01jw7touD8us0c+6cl7Dv31/BRqxYVdcs4NMUWkxR7NghdGYr+Po5BWJoGhR9rpgZwkWQ5W/USHLiHzsDosS3yQzQ+NBS8//iswMrzZM84jQ3xckpoABfDRe/g/FMtvJ26XniE4jPUP/rU8HGeIt3ELTkCLhgU8+X8ZzyVUnKS7cQpQsLO7s1rpfdMUFdMMFQBl6U6Z1BXwGdeA5zyeTBWeSA6MADBu7KGU+URirCAjCQK4ts0hNW6XqVHO22zfBl3FNSMf+IwKMDjVf6R/loD8/aUhxtjnzP31uONvCzMfHqbPahUG/hpL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 09:30:52PM +0000, Lorenzo Stoakes (ARM) wrote:
>Replace use of the legacy vm_flags_t flags with vma_flags_t values
>throughout the GUP logic, both for the MMU and nommu variants.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Nice work1

Reviewed-by: Lance Yang <lance.yang@linux.dev>

