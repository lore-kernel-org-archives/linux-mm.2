Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A04DC606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FAWDg5Vd
Received: by kanga.kvack.org (Postfix)
	id C27DD6B07E7; Tue, 24 Nov 2026 12:11:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF206B07E9; Tue, 24 Nov 2026 12:11:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16816B07EA; Tue, 24 Nov 2026 12:11:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE8A6B07E7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:11:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2DB1040C88
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:11:33 +0000 (UTC)
X-FDA: 85470654066.15.D0A1763
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 52163140007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:11:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FAWDg5Vd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795540291;
	b=pjCfRUj0mzmBiJoKBBlpwGAs6Bs8tFu9cOtOeB7zlUK/Rvxb7fMkDKTuZJw9W/olfWSnCA
	0uVunKCBJOpIBtkiHUg6NfFg4azUiW0KDEqgQ7exC/GRYgD8QMGhzh6fZpOBvaXpYZ8fwm
	gz2mLWk/R0c159IofHYgMBVqfPK0ENc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QldWE4w0TVdbt2gDvBD2hdwiIfOJOYra+WZwlAsjtw8=;
	b=V5kXBMVSsDpmGylc3FxThqezYKXM0N5172dPe25/SMI+wGoo11Ei3XCd31niROaPXbPu+B
	BBkAPLRak/vYNEJHo3QtSMjkROMXAGZIE91vwZywtWkFnCBTNBaTtlFS/3cDpYd6QO/6Fg
	PkDUrXU/q3eeRbI0afTviCC2yzRIbTc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FAWDg5Vd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81513434AE;
	Tue, 24 Nov 2026 17:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0571F00A01;
	Tue, 24 Nov 2026 17:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795540290;
	bh=QldWE4w0TVdbt2gDvBD2hdwiIfOJOYra+WZwlAsjtw8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FAWDg5VdpmSx8rQ4lXebaV7SUMn+/W07Xst8eBB+3X2tL8rSRKmUXHCIMftwFSPK1
	 goeF2p68x4zrFVqN7xqOVkVerTS4zXG+4wTxWabsWpEHq49685dHDsGi1uixY9oNEF
	 yw1zPDt3FpEF4KEpItK8x54ojy5MOVI2n3NR48J8lK+HvY3W2yz5ioRrupk/rL/gsw
	 JnWTskNHr9Jv8Q4/CtMgZye6VMx5Qdrm165YtlCl9x7rSsx1acUmvoIxrlN3N+Jtxs
	 QVVD0egk+QCVnvxAMlVDhkBS8CqDmQHE2ldeU1c9PlzXCKOKpXgrqszLMrksKwsM2j
	 jQ/sEhDIaDEQA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 17:08:01 +0000
Subject: [PATCH v2 09/11] apparmor: convert VMA flag tests to use
 vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-vma-flags-v2-9-bf3fade93064@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=852; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Fq9T8hwtRsQLwO0WpGmIyYpdIofCGHG7KaF/EUohnCo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZj+SVzZ+tY/pliVFg7/PJFXOrpYolpPnfcfUpLJ9Xq
 Hrm/5JjHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIlT2MDH/Ubjy1mjJp2/eW
 Zf+bX7xfEBQ0kWFv7ptlrTMschv3y6YxMtyfM+G4ub3U1Evcyzr+7Ar/vXfCg2O9KeJfXsm9Cjp
 dw8EKAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 52163140007
X-Stat-Signature: tmxqgd44z56zha6xmxrtpjzqphxhd3iw
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795540291-256881
X-HE-Meta: U2FsdGVkX18+pWFvIlClo2RdgMPV0OKZ2HEwurMrKOtJJxj4M9FER3iUdEIWwtkGxLLyYRER88es4AI4O5z2gdfvmTrm/4+LbDyBblyOKO2M96yeKaKlh1KqEdVNfDwpFQFDmVuRJB43daIh2rRGITQ0weEvYV+FJ7CJqYxluoGkH/BXZkTL5Ak+WdOB9WaD0S2YtGx3DzdjcRgJLM7/8UOgTWRNlIKc25QZhmXMtSX549cUy4nR1Cg3B2GxvBIYrtoVH05UrOtCWqYt8RtWIk6TmXqwdl2ggS1cVWZGeiGR9xFrldPmREFrEN1TZ6pFIVmm/opNqzgxTHEbBE/Rhaaclxr3rckthiOCxOEKpXpT8lWCDD5S1OaGefvSnptyOXErThOYXnjSYbq9UiBLVgyKYjivwXMZu/Ic8y4pIYfgxMB4epKRVQxcYhQtL2A/mnMyypri+pxriXhQFVTGIeFH20KzmknN09oHOKjDwkxavgI/aLOuoqqNwFevp9jb3VQ3MQ8Zxg8TvZZpiu0SCKWT/sb2eh/EoF7b08Y5/EtdlXJ1mm+hqIl4Z2/1GDWnSuKBm5TQu8DxnisHMthZxmLTEvxqTeOYZtU3O2GgaPuAsN96AM6EA+jCipAMbbZ6R463gT/J87ZvvVtQ+cLytPky8FhMjuWSMyPLfzRvES5C5i7v2J7PiT5ONxkZ+dsJyDX4gXuGp2PKNa6HAUxCKTZS4ZfEAiM9k5lYfkqSi6xxAs918+W3qD3fCW3VSzS8uY/m7s4NjtiTTmCTkzR+6HuW357Gmf3atE7bwtpJcPCJl4wTAcFZLQfRjda90PrYXXNW6lennRfVFArROAwvZzRdQzqXzjM/+Bma2mpdfIE/hvoTnBjaC5LJPBmrpAM/Mh2kN8GMupwspT18Y9oDRy6RKY/nVxAOQJpRRddeXy0ztnc27cS5q6zuYmUH+kwQMumnOV86sSXViuXV7o8
 uDa6falb
 g3N06iU+pWZPpQmTjFEgnc5+tigehrd7mpThDI6z3YcVPNeGXoo3l8UHC03Q2Y1Oe58SBwY+yQ729BhClDmf8WYu5O3pOASMvlFXc/S3HgdJ6UHRCUvJgETlLY5L+mppjvngY+z74eW2XNZCNEEaTV1oRrdYIXbxOU0kjSKPTCl31dO1X5G3hm8a2O24GahIbAO8Zpnepmzjregdj8/ozzWXlWqzDcT4CDQ7XmWxVrJTvjqR/Tyz5kkODkYILhrR2wUToko7L+uBxWS2iLVY8laug84AUGVA9rpgI+E7tRxbl0Jg0A/AUoMlSlhiy00O9bxnBqcwVcpgRMhQ6Y/8uZ77KeMWZMh/pVr8PeNAB0iPNFhVifuv7nDZd1luzaOgKw21nkBNslreoS784eCnO0+LJIIsawwTm8GlCBzeA7fOm72CVgfIufaWeDNod6KtzsszwPdYO4J00WKWZRZS/iPKE+wLOl9lgFHM13x7q8qSIJMvs/GNubEQ4GiGBsz+JWauOeGDHdx0yvbbx4KPNXnnqfXGxqNgbSk3BTVPTRcCb/VfFfeAwaxQucekzL6E5bl4ddxWK/GMd/hqwQQ1IKN0IOJuNrvQradKOwG7Ao0joyJU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
AppArmor mprotect LSM hook.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 security/apparmor/lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index eaebc3c60c5a..9ff9096b6199 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -591,7 +591,7 @@ static int apparmor_file_mprotect(struct vm_area_struct *vma,
 				  unsigned long reqprot, unsigned long prot)
 {
 	return common_mmap(OP_FMPROT, vma->vm_file, prot,
-			   !(vma->vm_flags & VM_SHARED) ? MAP_PRIVATE : 0);
+			   !vma_test(vma, VMA_SHARED_BIT) ? MAP_PRIVATE : 0);
 }
 
 #ifdef CONFIG_IO_URING

-- 
2.56.1


