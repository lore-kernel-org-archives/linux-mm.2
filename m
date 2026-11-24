Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FDC4606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZWagNd19
Received: by kanga.kvack.org (Postfix)
	id 7954E6B07EB; Tue, 24 Nov 2026 12:12:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C9B6B07ED; Tue, 24 Nov 2026 12:12:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634C96B07EE; Tue, 24 Nov 2026 12:12:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CBA86B07EB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:12:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3319C0C67
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:12:15 +0000 (UTC)
X-FDA: 85470655830.26.60C4DE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id AAE63180009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:12:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZWagNd19;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795540333;
	b=2d5V5ouY8TScCeHb0I09VST9iXbAf2qgtqeWXYpVpM8+mvC4n2hi6qCrFZXB9oS/KVsdMP
	d3tr9roDo4gVEXe1GVT65nF6xumSIq5OtUUAuz2wBKYDKdSBe+SSOMlb3Tqqat4lN+ULSq
	9ZoGrnh6+HXC8dM82iS7S/P0zlF+n6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+HphfNU3P4NBBhVQLGMxkibHciZuclM2bCzuhUVplc=;
	b=N8rwvP3w82h+LT3iQV15HNvbTN1oZTaBsJ4H833coHUQ7XJR5Hnornrj7RIl11KTWhbTbj
	2h9RGA4xky5uNzeRtOom36hhyQq8f4vN33ZszJD450X4+1I9u+jqyplQBMsmdkiILIX5Kd
	Rp5ZIZog908Mw3Kjlhndoa+MWl3WgNY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZWagNd19;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D42ED42E29;
	Tue, 24 Nov 2026 17:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3071F000CF;
	Tue, 24 Nov 2026 17:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795540332;
	bh=0+HphfNU3P4NBBhVQLGMxkibHciZuclM2bCzuhUVplc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZWagNd19/8Mk44HmITE+UK2Cz9B7twpXQYvnU5XoBwiZn9SNSuxJ6H2KXuIyFiBbD
	 mUu2MBXhBsaf4FVIxVAk5uiY+bd1NKXG4FySE+eM4ORkYgEvn+OX5kW21KOo0i15bH
	 dxr4ALMuUNmufjoW8WCp75e49zHcTaSAc8XzGpSjO9ibxBcSBC5jbmDUN3VWGcTqUG
	 nP+HfGZxER611yILD2Dvagn7Nol68wczlg0rQon2NI5u3CN74liWodnNc7glhVXdeG
	 qDj578np3LllXgDa6fPEyjrdcs2yQpdj+8wq9m3ffUeqxAMjsitxxJuPlnJ0ZDNkog
	 O7BrCNGKYhPCg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 17:08:03 +0000
Subject: [PATCH v2 11/11] ipe: convert VMA flag tests to use vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-vma-flags-v2-11-bf3fade93064@kernel.org>
References: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
In-Reply-To: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
 David Rientjes <rientjes@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=792; i=ljs@kernel.org;
 h=from:subject:message-id; bh=rH0wf7aPN+m4DmrJH+N9jL6VIPzo603o+4XYYEWHbSg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZj+R/2dj58xw7X5Og//KWFIMU+4jwM2fUJ4Qcy+LZN
 qXWvFW4o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABN5w8jwT+0pX9CaXievXrOO
 oD5dM+fKPUdm/wlT27d5VmVMUAC7HMM/1UvBYTJ1D16aumfMrjA9HskncsZ9Cnuar/vDX3+0/p/
 nBAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AAE63180009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: r63ysbhcrj6dpt7osh4ueu3fb3y6jzr6
X-HE-Tag: 1795540333-278330
X-HE-Meta: U2FsdGVkX18gtf9QpqG1iHg7s1xtmZAIuE6OJEbfM+4LXRvAtCXr899J/pYYKwXzjjimLGxQODWmhoOsNLhdjGD6BKECd4YBMopZCjKyxMOhw3z2wlaO6F9zu4j+nwCBFMh4Gde7Wsh3LvqkxtXcsXXrvQpO/i442n53RONpBE3zeOOZONjl8yCQRBcAQzzYDTPUPtrJ1US7JyZu10epinWg3cNDskFfL/JNtZYG6exAmc9MfTyRBREneDFHD8eI1qIfGCOLQu6jE1/vXlG9lh7Erntd7x2RXnioslLj88o/uQRb7PUAKfwQwoLJJlJE4OAl2tti3wHT6tGHZNr0gtM9qg3HVs0+rJrvyO/4x0d4GC9QKEct9/j7oQ6OpeKt9Q9iqoy3jx+tP3bgUC6+Nqg0UC/5ZfsqMufIiaXOo05tYHBI3YZ5SmurQ47veX5o4fy9TD5vdVqtm4LUySFVJSrIp8jJ55tkOwDb2iju/Qa+SXhhqEPogxNx4sudoGJaRI8Z+UPqr3SjKNnQY/hc+AIohGmmqCCibralMRSSHG53wMkfESDidYMEE1FE3DrAILu+R281L4J6e8esPmEtheB62Ygk03FbSqXD8BHB2cs+YCAB0aCwivUH0aaTpSzYrEmYNnZ0TZOY0jwlRhzLMlo/ifacNNy6ZiQ4Fk5EhABnWY0IvIDSQFMDeYjY8l4guuF6B/BBP8SFlh36b81zKsCI/7AfOY7Nz9PZBf7+zVlxIc8ZgEpG6G9MKqnoJ1zYNoG+YjKUP00gE7IquYQxFBzQl9nmWuG9rbYvUHwqt/vZmsNidRhALmq8Gk36boBnsMTTzMmEATT4OfOqgbp0OiRa2nZ4KZ0NZfkOK2vppW92ImNGk38J+o2IimCeSwcpnA41i4CXKrh2vxypf2NbrSNFbDtG8HWOayra/upNxdMhcnVOw65Iwj/mg5ZgEI9+S+HzQfAEg2/jeBFt7SF
 2X7FOrS/
 JTI7H1q8BlsR38aCSNodQ7Vl5V3L9HTZW6tr/3N776ucWUg+lBbSejV7VvTWKKDIoSDyEbsjenvju5Yrj8cHr4gPdXyNShRNVNN+he/aFKcp8hx4wVPasekyqEQ215V1l41Z8Qggg/Pe+n4jPtd0mNvtifiBXg8e8Om/vn0Y0v2MAYir0YYv7PH6PmaESQum9OfKzuuUKcYCzO2f0bDIF4L5QixiUsHeAO0dQwXHMyMOEFLk70IAy0b0PY8v6zYeskpfu6NRBFt+MGVIwZjd1PSFF6fpwFw1/OJWM6M9cu6xKoJ5PTGgCvBonfjwO+CdafjUziOld+AqYGVL+o5MLylR7SdEl6wU84AT3ZcRD5uA6jGAYLdSI+JhbHD6G3Io2QEZlnbCMGYuepOtec8tR3xemoCDfjTCKKu10mB339TFm6Pwujo+/R7YoEOr3ddSIcrEFmWk324IfjZDkkakUhvrejJxD1bQ7z9srsHN5JHos2cHejeplOzEePoy4T4h/QEVeJvsJpetL31TKnfHDipXiGoYMxa6LKWAQmgmnhEkkTDmtGGIx5AGS5ygZ73/qoBJqiuZy3FoMzTEzGdEZRBdJksl5SHagZmJvxAanX/GGiXA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
IPE mprotect LSM hook.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Fan Wu <wufan@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 security/ipe/hooks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index d878b52ceec8..247b07748b1d 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -112,7 +112,7 @@ int ipe_file_mprotect(struct vm_area_struct *vma,
 	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
 
 	/* Already Executable */
-	if (vma->vm_flags & VM_EXEC)
+	if (vma_test(vma, VMA_EXEC_BIT))
 		return 0;
 
 	if (prot & PROT_EXEC) {

-- 
2.56.1


