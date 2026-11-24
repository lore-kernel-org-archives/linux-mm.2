Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1068606A682
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=flOieDI7
Received: by kanga.kvack.org (Postfix)
	id F36A86B07E9; Tue, 24 Nov 2026 12:11:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DAA6B07EB; Tue, 24 Nov 2026 12:11:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24716B07EC; Tue, 24 Nov 2026 12:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC2156B07E9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:11:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D94780C34
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:11:54 +0000 (UTC)
X-FDA: 85470654948.13.D24A783
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5CB0D100006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:11:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=flOieDI7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795540312;
	b=gzsQYDYUNPGdq53F0hR6TlVoc4OohZlXj5+TXq37Q06cw5e29vEf3aGEneF4E7ylChcsaq
	lX/OqEun6fIJQ1GlPN6iEHzD+jACHK9qiUIYhrtSeUr2GfP44Mvwm+WFByBpPmbI2+dZ4t
	cdXzEmV37H/2c6+vdkXcvzJxWeyGMGo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YinBgxbv9k9aPLLClvg1TQtKuAgAUMd8VM3evMe5Yvw=;
	b=bspjGBuTLDSF1H9nEVunwXflkAFSASG71M08qIgZ+Ih5pvskjTXMELLoR9cZwj8GtNuZdR
	8lp5l592m4zNJRk3D0wtSfPQKf6NtqT+FTndTL7s/XhRx0mlhIBB5Jgi4q+AzZbJsuamb5
	yDtn9v2taH4RePl8J1HhOLnVkBuRBW4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=flOieDI7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C39141783;
	Tue, 24 Nov 2026 17:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D5F1F000E0;
	Tue, 24 Nov 2026 17:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795540311;
	bh=YinBgxbv9k9aPLLClvg1TQtKuAgAUMd8VM3evMe5Yvw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=flOieDI7Kh9vBBXOWVO8o7dM5nAz0R25xYTttwaLOe1IgLSs+iCwxBl30zbtS91+e
	 7Ww6lGfLE/r00fATsd8UbPhsgVKdXh9IPRnBx7aDCttrF3Eq4tuu4nWV68e/NXeJwq
	 iq81YOM5gmYaLG/bTwDv4R7VdMn3Onx3AL4S4iQeRg6Xr+y5byFWOKLdb7ZD17Cnjq
	 JGbfrS406KNlKaHM6I0WZK8Ri9sMIFsZlVto4U1ksd1BYhR3qwL/HMinuol32TWlcW
	 RZzpRJIdaGGA9zlrVWHylQIiwI5rcm3cGov3Vpum4WR2ir63Blo7v/VTl959Pubgc6
	 XZL6aIka5+n2Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 17:08:02 +0000
Subject: [PATCH v2 10/11] ima: convert VMA flag tests to use vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-vma-flags-v2-10-bf3fade93064@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=956; i=ljs@kernel.org;
 h=from:subject:message-id; bh=aZXr2zSVB/rJfER5dUYjqts6E/Nx59tdty75BvHwYEY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZj+QVSnUuXe77Y1vJhJirX5l9E+6nP6q7dXchw+r7m
 ecWq+3S7yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEgl4wMvwRCfuxt4eRa8oH
 Dkd31cpd004ad9q16nh8Fa7ct/b9wheMDAcdmsP65A5c+PmtRm+uXv88sSVfT2w4W5NV/tTU6mm
 5CC8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 5CB0D100006
X-Stat-Signature: oad7u4ne73787orfwo7eth8tuw4ko7jd
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795540312-250597
X-HE-Meta: U2FsdGVkX1+SoKWA8g1qdoMCCX3jQPu50h0G7OFeeYMzIc59XoXx3GxJc2OMApD1eHOZENoUL1c9+AahfvhNum7qLGKNJE0VYMXd7AZDjsXWda456y2fMM6scVKrrcRMOXB1M7iQ6yPOCTv78eDttQ3dmvzTte0XkTDG0sQUoHEhOhEv2Hf3n5n9LtYxC7Pf4uf+sRTVP/SQRlcAxBgdq/nrA5Ub3Fk+iwikiM6YjPIl1R7fAG17AgNNQ7DQYzprk0+DtBJiyVH3HUOSeWOwyGu0GoHZTmXpjfLRwb9/vofqVPXmjXll6dYL1IvUCWCI/d/wJ7LH1q6BVjDOKaZbEnCeLdkc5AZ406PnB34VC3zYgviO6i9lPiDpPwiGB/ImH5+6sjZRGLGX5eJMl2jVX9ItMimWZIZaoFoZdqYN8nLiymIrnuDghSPZnp9ltuiTPqlphBR3CjlR+nVqCFjWZZgNLlg+aXmPXl+IXcNAs3Jom2HCfJa6VGO8RPMvOeNIYrPCmdp5YovK+MTwP6qsDcfk3xmnZeTEVSOOi6ZhaWkY/J8ynDo7P5Wy2iNgmd3wPcE/fbBeIjUmmatO4Xj0bLuCDgahA6z8Sc5CR/B+xngLX3ys/VvcNmq7kKpNA25v9SV4u6A2APM3h9zSCwiCIEzKIpFjjqKC0xUSaENOhLVgM/ENllIWWN01Da49bhO0UrLkC9flhdEAmRyYxUCIkHryqM/Wy5Y+qOSWoZKVdZuYF3rXKw/O2SRxmgFHdY4yji9Zioe00NPUGxe6sOPr+CPTf2a+F/LNQ29o5GF3T4juc98YN1z81jEeyzRzzG5JyMC1Ww84vIS5xmOCHGbVr4f8STB3fMixIfMwWWlTE9PiYD2FpRMnEGbWpkegL4Ztezk4vlqWI2Ipgg1tutZn8HVqU1z7iSsyyLHniwwXEKqbA0pr0c1yZhP0S8+AmGwJEirM3hsfu6bVrPzzpIJ
 3MTiY+CE
 fMeTFjUnZK6TnQCxgtPYD410a7LQ5ftVqi96M4srZMC4zHHeo1VbZx9adsIUfMF7Nrg3hOhpw3tmCz3p88pHx3asJ5pOsiBicwU6jiyF69/gb14ee6hjRtTAy0NMXu0Kefka5TYLjUdcbPlTIZjiQacBiJEaCLViJrt4U2gRs+ZIYgKHS80JGIr6itjCavAJb/Jax2RZXP7dEuF+nPfxlzVELjuTvp3OshQ0yg54WRkVYjr47OP4z6H7N7Le9c3fT510ZfcSiIglfgSa4vdi5A03FvXtz8Cubq80iB/cWvfujHkVDKYM4so0QJFZPBc8OMmVmwAqUsv0yvTKfOMRAHtHkDgFk+RRnfwvvSqSJGZPks3Pzv8WCwL0nn9+HYtnNqsybk86DxQYu/iW8AMM89OYAgNxgoKM5tXKK6oFuMQy/xdLtPNgjaojOXuKBFzAz6jCpI12Ax+L9t2YcJ/BfRFPN3Cm1vtA4qYatmSYUVW6W+ookLxkiAZ7HEMGFevbOAnH9Ze7pLhFmzjUud6cYG8nuSmmyz0heFGvVN6jx44hqJqCv1Hz8RQm0/qpDopR/705seQ5zKeJfD2CZU6Zq708mcdO/aQitsb92NJt9f/uwUNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
IMA mprotect LSM hook.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 security/integrity/ima/ima_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index fed80da3ee09..92032afe4cd1 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -556,7 +556,7 @@ static int ima_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 
 	/* Is mprotect making an mmap'ed file executable? */
 	if (!(ima_policy_flag & IMA_APPRAISE) || !vma->vm_file ||
-	    !(prot & PROT_EXEC) || (vma->vm_flags & VM_EXEC))
+	    !(prot & PROT_EXEC) || vma_test(vma, VMA_EXEC_BIT))
 		return 0;
 
 	security_current_getlsmprop_subj(&prop);

-- 
2.56.1


