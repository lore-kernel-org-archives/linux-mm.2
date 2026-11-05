Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4733606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Kuou0bnu
Received: by kanga.kvack.org (Postfix)
	id DB8216B05B3; Thu,  5 Nov 2026 12:54:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F2E6B05B4; Thu,  5 Nov 2026 12:54:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6946B05B5; Thu,  5 Nov 2026 12:54:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB20A6B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:54:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C34C12079D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:54:35 +0000 (UTC)
X-FDA: 85401815310.20.61BB87D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 289DF1C0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:54:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kuou0bnu;
	spf=pass (imf21.hostedemail.com: domain of jocolema@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=jocolema@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793901273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNswTHRkAB3xpLhJNb2j9JZGG582cPl1mfH65MgD+RA=;
	b=2L91F1lnfUxMgJjBaRt9sR5rqECF4NldmsQlRblU8oCMg292cJn6w07GOQzyozzWkkPJKY
	3UmeI7F6XdFBOA+YYK29efFTnxtDQVB8LXE4MoYa3Z29riIL3zxmYQKAkauxXOOfrVeLe0
	2zZatdJuSbhuwCnSxKerRFjAuRWKAPA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793901273;
	b=GcAwCaRi4/RCPFas5zHC5ypjmxgKRqyjZiPjXYkcvSCe/WK72so0IivvmPX51K/Sf1rIap
	2TpNjh0rVhRqd63PoZ8bTHt6lJI6OEqJYaqzggxaUagM3KHKAzuisosuIQ+v62E4Xp5zAd
	4t34dnsl0nEX+8uk2Hh/LC+mPHLM7kA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kuou0bnu;
	spf=pass (imf21.hostedemail.com: domain of jocolema@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=jocolema@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793901272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eNswTHRkAB3xpLhJNb2j9JZGG582cPl1mfH65MgD+RA=;
	b=Kuou0bnu6ZusO1qZpXPnVLn7sQIXDJYpVWfU8DEEPDs8XY/uNjtvIuZ0nS7fYuA7v636eg
	fKOaRuefAYhkQl6VnVOaw21EzvxWbrZsz5XtHBpHYOLs4VInL242BelZqgiDPrPA7FR3E5
	NsYwTlAYQtPeHnNYlzIl4hW+wLhCsYE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-whESyizYMTKoAN_7Vbzs-A-1; Thu,
 05 Nov 2026 12:54:29 -0500
X-MC-Unique: whESyizYMTKoAN_7Vbzs-A-1
X-Mimecast-MFC-AGG-ID: whESyizYMTKoAN_7Vbzs-A_1793901267
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 21F9319560B5;
	Thu,  5 Nov 2026 17:54:26 +0000 (UTC)
Received: from jocolema-thinkpadp1gen4i.rmtusco.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5366418004FC;
	Thu,  5 Nov 2026 17:54:22 +0000 (UTC)
From: "John J. Coleman" <jocolema@redhat.com>
To: zenghui.yu@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	audra@redhat.com
Subject: [PATCH v2] selftests/mm: scale uffd memory region contingent upon base page size
Date: Thu,  5 Nov 2026 10:54:07 -0700
Message-ID: <20261105175407.638242-1-jocolema@redhat.com>
In-Reply-To: <20261011163527.95988-1-zenghui.yu@linux.dev>
References: <20261011163527.95988-1-zenghui.yu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: t6sHsed39c0BFHYZeclg2qOTKimMtmTqFfxV6ia3324_1793901267
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: ectj5w8yc4hs589488rtmqa1upyhkssu
X-Rspamd-Queue-Id: 289DF1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793901272-547100
X-HE-Meta: U2FsdGVkX19zy70aGY5Mpoh9vTKP/VvfuyCWNa8N1nC+kjustXHRqAufhRqmG2X1zD82tU9vx1fi+ehs9eScodUkjNp2SXWNe7vKL/uuPjwwBv5GKsyOYjBDW0WOih8vcvtc+jAJVWLDDtxbDiczoXZ247o8Mf+8JiEnHwLvA8YskmGRjMLUeitLRCKMXr5fbLBEzJCQtmafzXZpXuch11mo/I0aE3jivOnFOYDRdiDXvIXYgTYZlsBmxsbbCHUDd56nPNIZ54gbtdZGVEPys9IXS+zFQsNEip+GFz319JdlDHGToxW+yruuhMCGFtNEYcRoX1nKQUPgm0e5aDXgqHpDIwEsfy3fLF7Al2Jvzz2tjpTcmNNIOmB+sslNZy/0+EAyM4LHu+B2CPA0WysDxUqaErd3qFWdEmmjKJMQQLjQzLgelhYBRQNUrm/AIUWPqoePQVdo8VBPxoFXIao4RcuxBYgjT7Cy4Mv3xYx8/XnE5CxaWo4eDjv/bjuNCAN3qLpGm+23j4AxKx2GJQTJntgbpdOA9fxjHbQpBc+Inwtvwjqg+SRfTMK7EB1Ut+xVLfvvUJotCBH6opSFT3Syni14LwRtglDDc7bAXtUwHjHFrr0RgLiASY/HvVApIUGo6MS19Vbgxatl1tUkG8Vf+yqlhjRRdS5MTf8vs6Q0hMdPbk+g34msPCXUAwv4gyLjM3MIzqa8FEIqM4un1DW9sh0MlvgILz8bH6gashyqnDt4eYbuctMrAAjb20j0wqN1nKqRUf6UBgwFmTgyfdzq58oYKE1sOal7/ij3BjkWSzNigJNdGwoMY6mKqPe3P835/tf3LW+Vu64gSkZ6yXz+bP5YR52PlUpP9ioC/vVHXbw0z7EVxVfSQ79yfaWo4qiU4ahwcYaDBsEfmi145HLhT6GM1i1ezYF9vZi/3bGgFTMd2N0iDtj+DZgcqfTtfjlkqFuvsXLjQzNJY1vIPF/
 3Jg0Uxcx
 6MhLWXrVOvv1aLpOCUJTB9AZ/9kAgkQtDy/HY6ucg+tuY+sxgKRTNnrKlA7hjUL0Ome6GExRABA4lSdebUT2CZ8M4ivjbh+e9OM6U59KTu4qlh6PgItrC6vO9VzxUCrxGh8BUPtdO5TZ2+mGALvwF9X/6ZCK7gApPC0tSACTzgWDHk2niKTiDhasCkrKyGKFcninmosbOS5Et68ZwDJtXrb23FnpxGakZkjLhK91CtJt3ZqmWB77+uRRNhHmQrrGoccNm2uEDoegDymKNspThCTvho+RT5Tp3RZ2SHcn820D2grq9j9H9g2Q1Oo5uTPgJwa+BwSlj+C4DkF1R1zADBJPC4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When executing the uffd-unit-test, the "move-pmd on anon" test will fail 
on aarch64+64k with a segmentation fault because the initial allocated 
memory region is too small.  This only happens with the move-pmd* tests 
because the architecture base page size is still utilized even though the 
memory region is specific to the size indicated by the pmd.

Patch 9f5c2aec3388 ("selftests/mm: fix uffd move-pmd test crash on 64K 
base page systems") implements an initial fix to the segmentation fault 
by skipping the test if the allocated memory region is not large enough 
for the number of pages x page size requested.  But as this will skip 
over the aarch64+64k pmd tests, this patch is intended to resolve the 
problem with 64k pages by scaling up the initial allocated memory region 
subject to base page size of the architecture.

Fixes: a2bf6a9ca805 ("selftests/mm: add UFFDIO_MOVE ioctl test")

Signed-off-by: John J. Coleman <jocolema@redhat.com>
---

I made some basic revisions, but as I am looking to gauge opinions on 
this email chain I am replying to the chain, I apologize if this is an
inconvenience.

Changes in v2:
 * Since psize() is included from vm_util.h through uffd-common.h, 
   PAGE_SIZE macro removed.
 * Added UL suffix to ensure integer is treated as unsigned long.

 tools/testing/selftests/mm/uffd-unit-tests.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 2a97ba1d6feb1b35d6281449fd1917793a64fab1..3be227ed8d413f6e67e475862aba10ce13221446 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -13,8 +13,13 @@
 
 #ifdef __NR_userfaultfd
 
-/* The unit test doesn't need a large or random size, make it 32MB for now */
-#define  UFFD_TEST_MEM_SIZE               (32UL << 20)
+/*
+ * The unit test does not need a large or random size, but the allocation size
+ * needs to scale with base page size per architecture otherwise pmd alignment
+ * tests will fail for architectures like aarch64+64k.  For standard 4k pages, 
+ * this will allocate 64MiB, while allocating 1GiB for 64k page sizes.
+ */
+#define  UFFD_TEST_MEM_SIZE               (psize() * (16UL << 10))
 
 #define  MEM_ANON                         BIT_ULL(0)
 #define  MEM_SHMEM                        BIT_ULL(1)
-- 
2.56.0


