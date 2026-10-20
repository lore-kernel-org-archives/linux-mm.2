Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D670606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=F0ZLLANj
Received: by kanga.kvack.org (Postfix)
	id 2456A6B0454; Tue, 20 Oct 2026 04:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C5A6B0456; Tue, 20 Oct 2026 04:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BE556B0457; Tue, 20 Oct 2026 04:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C88EC6B0454
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:47:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B2961601CC
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:47:14 +0000 (UTC)
X-FDA: 85342375188.05.A72E510
Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	by imf24.hostedemail.com (Postfix) with ESMTP id 03F4E180006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:47:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F0ZLLANj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792486032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=54htZqDx8IcPvoQ5GW/HM2qiVh5OPSFZJzSyn6By+zs=;
	b=IpMpHOt7ypP2y+ZcsbAjQhfnUksH+EkGuAs5fuYCQmha3nzqAI80THdidq3szqRoJZqCPK
	ozuVypkZOIdw3I7dviO7Qz6RbMF2wKpIx8kORqJeTQ5aahenMaCUSisZNMx/PC9040bZPS
	xwtM0YKkeWmWSEbfVYIf8Tr+CMN3l6Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F0ZLLANj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792486032;
	b=iW26JxscrgEfsENG86pwdvWI742ICwwIIu78YiGVgQN7+KvBKljQWbOhWA61g+nJZlwPU/
	SySaEAg3kt8rqdnqEtjpX19DWGRx1BOVcPqlaKX+UgFC9BcuoLM7jfdUt7y/0wZxPaGnn7
	EyHGvsCzDb3t/fyLO1LgtJaGt9oYPHc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xCCvVkqwA/gvOvrWt1gYYjIKWBs4Cqg/yh1DeergSOg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792486029; v=1; x=1793090829;
 b=F0ZLLANjY9iV2f894FrY3RftmNVEagi5f688G6PpzyHhwgrvb/kkks/0tOr3s3dyY5ua7PRB
 Z6CtLd8aLSsedz8fNapTFcjaZcxc33qFfbrhXpgKSx6TxxbbmBw/VSpqO6E20BkWceiH3RCEOdB
 pDRvDcY8YKhg0ixYqt34RRHA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b46a699f94547d5f;
	Tue, 20 Oct 2026 08:47:09 +0000
X-Mizu-Trace-ID: b46a699f94547d5f
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Tue, 20 Oct 2026 16:46:30 +0800
Subject: [PATCH] mm/hugetlb: charge hugetlb cgroup and memcg in
 alloc_hugetlb_folio_reserve()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-for-alloc_hugetlb-1020-v1-1-e6eac82dd754@kylinos.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM4QpAMBSG4VvR+W11tkK5FUmzHRwt04aU3Lvh5
 /PV914QKTBFqLMLAh0c2S8JMs/ATHoZSbBNBoWqlKhQDD4I7Zw33bSPtLlefDMiKWsrXZRWQjq
 vgQY+v3DT/o57P5PZ3hrc9wNf+nEpegAAAA==
X-Change-ID: 20261020-for-alloc_hugetlb-1020-00e2dd7a56d1
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Steve Sistare <steven.sistare@oracle.com>
Cc: hongfu.li@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792486026; l=3395;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=smxh7KjhK+88XH3fNI2hv0AD+wsJkhBDxzNm2aVgsW8=;
 b=mtTAju+8iai/GzL9RcaM34UF7B+nDlXEw6LQEc+TwcOFbxGA0v4acni9RBgeuHdmIFG1iesKY
 Vb0qrWq2EhaBF53Ewq4gnMFh5NcmbaO4S/c+DDATLwivzCytr3UuxNu
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 03F4E180006
X-Stat-Signature: pee794b9nd5pzo7a7brm5j45j5aednwj
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,LOTS_OF_MONEY,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792486031-828670
X-HE-Meta: U2FsdGVkX19tQsNKzp80xQZ+AlSQEdR1PhRxiHj6qzI5oqdp062kROIJOialRc4PDvzP9cxv0KN6s3G7IxJMV5xwRz/lTSHSaT/aEyQ8YYvVo3jOF1CqkUyhIo1vYXF8ABo7BTWNzXH4Q4rSezaMCC68l2plGrux1Gb6Tvvz5j7/duQXk+N6kQZcs8JltvDoK2Y74H1XZv7LFZXvURbdEK/C2x4cJw0ww/XzCW3YHVYuJJa09h4Tpy2kupNmy3ZpeoyTDH3XJpM8K/WI7D9u7Dc25Lato04MqgAfu4pdYuBU8UDdSZK+v5TTPgZMv+CmzZ5itb6CwGkBwvPZ/+2RbCTglFV2OH4/pxjbXB7rVJXYfQpqZe4OJODFB4C3t6U17/O0aNhDQnfukqQtEwdI5ghbPnr4uozrO+1jD0p51R9dCBdwknTTUE0LMxOAkPZg8d+PdztxEkE0kPKzgSCYGzYei9v9MHSLRXVYkneE3QG9UM4z/yk654+Jxj5JpYWFZcz+1wUBjlSGL5gpqYUCSF+1H9reMtojDuAFK1WbMGDBH3v9U9QmYOpHunYz10sXNEt7R0r8XHsvvVNCOLmFxYPFDkcx7YgxsFYB/NV2n5XZ5R7eeIDApf8+a68PHd80Cfu14iCm7MJrr9Ll5GwkUZ9v1hE5+3xhRyznPmRFwtLNC4Dre3QY8HGwQckwqPyrxFqx1+19XyvmvvatY1waFh4ABCuccsxHOSWVISIHqxyAvzw8IGQWkUQtMDqCNWBk01afs0kwF8J5kwCSAJui7ZMlt2PKAcROxBk1CtBKZnXiKomKo+JaJ4FYDaAtnuriyK96m31GcOTYg3OT2UAZCB2r/dGA8JMBmgBO7rdJSJ3lRT47Lq1Pz93H3S5HyV3q5xCZOEx2apReiq9dgFcIVHSMF1ionIs8WyzXbaFwkCOnYUef6UA149iEB9KRLxidQo5r3/sLcZ93D5WOsBS
 q0j5gb4B
 /b4pE4vPEOEMfps7GIlEncsx13nsBKK8raMXeV1BroPFq3vpYtUUtQjTRsYgcjv1cJLZnrflpmXXa4N1v2JPjYzBFRieJwy69DlTiRESDlC86guZwVt4jPUbGfbpeW64Ln814SxCXzkCUxgNrm4SNagQwM3sn8Hy2Lra/S4BVeZ4WrG43TiRZUH4xxN/Y3Qmn+fJJ3O4QqZc9phFHFLJ0uRCa2bCWuswE8O4aR17TMRkqn5T4/t7xakeXet1nM4S/GYQZVNp0sBD8aP30HiXmfsEa0AXvLp4t1enZ28atbdRMbeDtWAdBIYsGpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hongfu Li <lihongfu@kylinos.cn>

alloc_hugetlb_folio_reserve() hands out a folio from the hugetlb pool and
consumes a global reservation, but unlike the fault path it never charged
the folio to the hugetlb cgroup or to the memcg.  Folios allocated for
memfd_pin_folios() through memfd_alloc_folio() were therefore silently
bypassing the accounting: they are never charged to the hugetlb cgroup
usage counter (hugetlb.<size>.current) nor to the memcg (memory.current),
so both limits (hugetlb.<size>.max, memory.max) are bypassed.

Charge the folios to both the hugetlb cgroup and the memcg, just like
hugetlb_alloc_folio() does.

Test with a process that creates a hugetlb memfd and pins pages through
UDMABUF_CREATE. The counters were read while the folio was still pinned:

Before this patch:
$ echo $$ > /sys/fs/cgroup/test/cgroup.procs
$ ./memfd-alloc-folio 1 &
$ cat /sys/fs/cgroup/test/hugetlb.2MB.current
0
$ cat /sys/fs/cgroup/test/memory.current
1351680
$

After this patch:
$ echo $$ > /sys/fs/cgroup/test/cgroup.procs
$ ./memfd-alloc-folio 1 &
$ cat /sys/fs/cgroup/test/hugetlb.2MB.current
2097152
$ cat /sys/fs/cgroup/test/memory.current
3313664
$

Fixes: 26a8ea80929c ("mm/hugetlb: fix memfd_pin_folios resv_huge_pages leak")
Cc: stable@vger.kernel.org
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/hugetlb.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b37d7d0db7fc..62b819b84faa 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2193,12 +2193,19 @@ struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask)
 {
+	struct hugetlb_cgroup *h_cg = NULL;
+	size_t nr_pages = pages_per_huge_page(h);
 	struct folio *folio;
+	int idx = hstate_index(h);
+	int ret;
+
+	if (hugetlb_cgroup_charge_cgroup(idx, nr_pages, &h_cg))
+		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
 	if (!h->resv_huge_pages) {
 		spin_unlock_irq(&hugetlb_lock);
-		return NULL;
+		goto err_uncharge_hugetlb_cgroup;
 	}
 
 	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
@@ -2206,15 +2213,33 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 	if (folio) {
 		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
+		hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio);
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
 
-	if (folio)
-		lruvec_stat_mod_folio(folio, NR_HUGETLB,
-				      folio_nr_pages(folio));
+	if (!folio)
+		goto err_uncharge_hugetlb_cgroup;
+
+	ret = mem_cgroup_charge_hugetlb(folio, current->mm,
+					gfp_mask | __GFP_RETRY_MAYFAIL);
+	/*
+	 * Unconditionally increment NR_HUGETLB here because if
+	 * mem_cgroup_charge_hugetlb failed, freeing the page will
+	 * decrement NR_HUGETLB.
+	 */
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
+
+	if (ret) {
+		folio_put(folio);
+		return NULL;
+	}
 
 	return folio;
+
+err_uncharge_hugetlb_cgroup:
+	hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg);
+	return NULL;
 }
 
 /* folio migration callback function */

---
base-commit: 2887e63d2e8e0cf55402612d8996ce955a2c3e55
change-id: 20261020-for-alloc_hugetlb-1020-00e2dd7a56d1

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


