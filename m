Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0C3D606A33E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XbIgeKT4
Received: by kanga.kvack.org (Postfix)
	id E1E276B05BD; Mon, 16 Nov 2026 02:14:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF63A6B05BE; Mon, 16 Nov 2026 02:14:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDC76B05BF; Mon, 16 Nov 2026 02:14:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B36C16B05BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:14:31 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4466E120740
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:31 +0000 (UTC)
X-FDA: 85440119142.10.F668AAF
Received: from mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6E743C000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XbIgeKT4;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDNNUKcQznYLFvs5X+9GzieDpnGR07oToeUGRcsD+jw=;
	b=fEBRw36M5JJ4KXr9crOfVDze2sWgggrrvKWQ3gvg5+rhA68BXq1GZMy6pi8DOzK3q4a9M9
	xdglboSukStbaG3QRgRQyHcffEsUc+u36qYWH8LGYNbRUHUidUTZuKk2plBRfMMcRugDIE
	KxegpjiE5xxQs9x3lgwva7RpgAxpJ/o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813269;
	b=mx5vB1vjNqQxBbBrMv45hF8YabJTjmtkb2KCukCWqR+nJG/o5jcOGYVvx3t2088XByr/6N
	r1gJNDXviv/uAIbnYIDDmBIxrhAbvfGap+qt/YX+Y8+OdN/u4GSlt42T/kFQWctzugCDxs
	hCTn0/+zqRjjmW/Be24/tH1BhP49dts=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XbIgeKT4;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ox1OF4PmGlhBQ2M/eFtocGrA519OKUW6bkxfmgExDOw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813268; v=1; x=1795418068;
 b=XbIgeKT4qsJbDHNO3O6KZTrnqZwO0ummpfSNBOuRvtNbiUoxtYGItkrx6cB0AKHeRzkwxaXs
 GXKp2dzSTRD6cBaMDaQecPXbalDHjtz+qysvD/Rgn/1IUoy4E5NWJl0BOSCLoXB66NWqFloqFOw
 sGrizAKGCZTvdXTck8SMsb1g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e7a04197984c81c5;
	Mon, 16 Nov 2026 07:14:27 +0000
X-Mizu-Trace-ID: e7a04197984c81c5
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v5 08/11] mm/vmalloc: drop the KMSAN metadata in vmap_pages_range_noflush() on failure
Date: Mon, 16 Nov 2026 15:13:22 +0800
Message-Id: <20261116071325.263682-9-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261116071325.263682-1-hao.ge@linux.dev>
References: <20261116071325.263682-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E743C000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jwa841zr3ihkjucwd6gp5hww6wuzqmfj
X-Rspam-User: 
X-HE-Tag: 1794813269-259416
X-HE-Meta: U2FsdGVkX1/JGuTBUuzZimh8maK/wqltbSNplPdj10Rhs9Opwws4AKd8WbTun9X14P060CrRr9KrPrd1K4GTArkBGVwI4WtyM4oAAU1734LxghgfzMz69ffRB1VQcvpvqSbyR+s/9XiPgd4YnvkI4rzUQuXwjq2ny6Tofkt06j4+HzmFmWtzyB7lNB8wu9pjHfdTfOxeiSJCT00Z3mgCITdtR4M3825UB6XZ6UV1QP5O+Ba8kDFLAtBy77V7rE5A8koc75V8IFw/Qyj+AizrPviK9AOjAzFJW5ksC1ylG03SXRNpFW2d8Bdd/PZwlHox2eRg+1ZkKeeyQUKNhw3gq4HJYbZtWTZwKSOAVs98/L+yCCHuZm06lN7I+rKqoOma2ZUPIN/LHDmxMwQpYLRsPFVCXi0jkbHoW6uJWFzvwXRrvoA4JL5eWDgAxTjBnu2UKH6O+S1aKxdavvIkNMXhMDdWtJVVyLyIgoP123N2kopR1nEClsgXdtLePhvUb8AmIOpbF+KOJZkC1SUj6V6si5MAsXOVQG8BrR/OO2p2q8JpwGRo9pAQwdeGq6BdPuNcTDb6jJWJZDlFjsAv0oxqqvd4d9GCkGyimEVyQEY38ZI3u1TLYmK2lSNbC9tzMNsM2CiLdhvJ1L2OT4QX7+aFyGaQIyeda0oG9rE3mgXTYnnyNLYfZj6ZG5SembAO9k0JkRJybr25RKlgSU9ajk0bm/uockJxJMODV9TgAvEJZkzH0i4rWDIEubDoulxCneVa9yNqcOYhtYQmYs/Z/AMYbKNPF+0pjFsuui5YuJHEE7SaSvG5zaSZnk0HeVxVnxF3ndavsCWhdZV/5hTcIWKdLMRNwMaOUqMakOKMY6tdJG5YTUZje9UTnUh84BkeMS8py3vugtS4cXLXJIM/r1L70gs4vSh5JIb+mVlTrhhD080BtKjQwb4CO+sjYmkT8zXUrMakwporl2z3LbGftvD
 bPw2KTkE
 HkZnXemP081liYAfuWb+qgkf1Tq12BtMDyyjX/SCsBKU0FgH0RPG+teS6ke2ZB3rP391UqcBXILSGNwPpbh8drWItFirh40PHoeJmDQ1JE2eQsznE53hzs5u9Nx8XmyBTFIKhl0JojgFn4a/UXWfPaqPVoCb8Ei7FvmEG5/PidjHwHzWNuXuBvmHSZB5hKaD2hzo1ZiTNpHvd3dYU1f1FVkElwXKcXzL+JS1KLpXlArNlMeI3zRZTpF0DXjgbcwAzQO2aEfqojgkg0z6XnvWtRthk5CYpevUGnEbyzT417uj0wHL+BuhktSsmwIYavkVE281BqIBweRXYEbiSUMZ7hWAw//Ahm6n8ELB8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmap_pages_range_noflush() sets up the KMSAN metadata for the whole
range before it starts mapping. If the mapping fails, the page
tables undo themselves now, but the metadata stays behind, and the
next attempt to map the same range hits the leftover shadow PTEs.

Tear the metadata down on the error path, it was fully set up before
the mapping failed. The teardown follows the page tables and skips
cond_resched() when the caller's gfp mask cannot block.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 4f3c320a4849..28e65073624a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -801,8 +801,18 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 	if (ret)
 		return ret;
-	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift,
-					  gfp_mask);
+
+	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift,
+					 gfp_mask);
+	/*
+	 * The page tables undo themselves on failure. Tear down the
+	 * metadata that was fully set up before the mapping failed.
+	 */
+	if (ret)
+		kmsan_vunmap_range_noflush(addr, end,
+					   gfpflags_allow_blocking(gfp_mask));
+
+	return ret;
 }
 
 static int __vmap_pages_range(unsigned long addr, unsigned long end,
-- 
2.25.1


