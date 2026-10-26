Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D051C606A324
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=b4JDoQom
Received: by kanga.kvack.org (Postfix)
	id F06F66B05BD; Mon, 26 Oct 2026 04:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6FC6B05BE; Mon, 26 Oct 2026 04:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7FAF6B05BF; Mon, 26 Oct 2026 04:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE4A46B05BD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:03:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52E71140667
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:03:29 +0000 (UTC)
X-FDA: 85364037738.29.7259E71
Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D09840005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:03:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b4JDoQom;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793001807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXtS8nqPI8bMiiZsI5aMJRhf4Xi82nV2lL/o/RcncNM=;
	b=J5f2hzBGFa7sjpBcjx0+y/zNP2mn7AvRSe9WKTbtsNL2mN9SeCcOvgDtyRcceqNZlXmBby
	gMbBw5Q0SWflRfS2BF2fwtaY+ItfIW22E8K35y5D0lQLYOUqtHpmJLpUs+y0Es+IyyKyQI
	2WC5mjqqMVZolKvlrQYiYVHl4fJzwcg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b4JDoQom;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793001807;
	b=OAxjtSekPdpJkJzHfV1lcRrpIV+MtN43SO0xigqo7udrizjlkVCQqCcX+TMn3hcfykumWc
	Fegyly0hVSNbpvnt4ebQNXtSOvFjq4l3Kv55CAba3nItYpbTZNdUQSNjHNuq3sFYw/jMF3
	eH9R6AA5SQ82ju01YsP+JVE4mk4gkJM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5qs+zHZlkyqRDMqx7SNWEDLyLXIGQ6DciwEgGF1OF3Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793001806; v=1; x=1793606606;
 b=b4JDoQom0Koi8+FkzooWTOyPmsr0fbisC++3eRpFProHJO7+Si+JBtJij98PWU28h+c4QRA9
 AV9k3+2v7Ud3w7hGWKerJwW0MY5hJvXXKVcgj36+5a/KSDfDvD1d6KPl+vsmMDccHSTWq+SYXK+
 kfJ+Jd0or1Hgp+JFMEZU8qyU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 63343c3c8e1494da;
	Mon, 26 Oct 2026 08:03:25 +0000
X-Mizu-Trace-ID: 63343c3c8e1494da
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Hao Ge <hao.ge@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Dev Jain <dev.jain@arm.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH v3 10/10] mm/percpu: stop unmapping the CPU that failed to map
Date: Mon, 26 Oct 2026 16:03:29 +0800
Message-Id: <20261026080329.140244-11-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261026080329.140244-1-hao.ge@linux.dev>
References: <20261026080329.140244-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6D09840005
X-Rspam-User: 
X-Stat-Signature: pxahzpstu1j8drwegkbo3o5r3zrn4skw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793001807-690207
X-HE-Meta: U2FsdGVkX19AT95RykfPbx9V38udh/dw/Zq6MbNLErkeqpmB4nagLx6KiAkvqJ1jjozLv3DdMtsNpjAu0n2JdyO+GgCclN1P98z7LMZhuN1HLHTkgG5BnpUvbK3usbyJURegU9VBUO18a/AX6A/ZYm1kOyCduO4lIIt3kbP2ta3na1HrQEq++Z/mfT7EL6vich+gerURKXkuK6r++TxR6otIp1x0be3OBq64UGVXW+lNf4hX7dPW81U4GuAxvGMBTJ3RayJ30lpOgDWki6mpCeRBQ54Vtro45OZlGx79Md9KKxo5YSRxOn7k2Zc3v3iIkiGeZcpSBE4J8UUKFq95AAdQbDWs0kqIXwJT4Ss7aJIQRLvTEQ8NH5MyfeT8oGpq8WfrTSE67huUUx/0CTwiQ87Y1pReayStcyKgl+NuDwGjTad2Y9gPubXpVU/fw8kCltqKWOqx8gboQAn5AEn3tcJblAkRIW4Ehs9X4U9Tzh1FN6b7pzaGpjkns2xpQmYg+3IQTYAMb8Qj8BhQdHAcj8mX9bbsYRFjSeHUxqCHCvyKLYE7xMQ7N/UehUJ46yF6dkReK2GxKsamqEVK1C3f0g2OzZwUJC7wxlh9Exup53KYU+IWuZg5MsRIYpywhnGkWDLWWfN017JzelUqVOqu9q0/NNAvZECFtfLKQ3gNBvuqOnoFLdPZpZOjbBwN9peoBDMcBhT2BRhEY7y7pjytzeTaTAr0EKcpRkGS7sJsjczZytrnw3kas4NLVbMJhZuQTTBt8UfbrRDUIajkIUVNADI14NIf3494GL1dCtjApUX+yTkoW+JNyBUFtUEtRZD2+qmPoLEXuqkagoLuE18zfaHLmQw6i0Aiwkv4x4FTM6x96vAWgfIoOcS/YzeTQ2AgaSSWXlfFDftmiKFo+1plJGsf5VZZS+A9ybgFPTzOadk2qc1yJvSmNF8Qc63ZGx9G+xTaGwldi6L4MIzlDFX
 vzq7BAZ2
 UlWR0DKuLUmOMdL4nakOmPD5crlyCMiuf6Dp+MOZwWlRq+lDJA7op3GpLGp6uSmpSkOy5pA3HEN1ZdF51L6P+qNu3uXjqL53EJ43hPISVfTejL+E5+z45MgMrpagJK/tQRrYWsZKjjQ6SeYcw9BPHG6evIUn2ZoePLAcBSHbL7PzzSsHCmv41h+BzbfFacTVd8zYWiApg5NBVSwyp9jvG4XXQEPkkA5Cyqp3ftAfhiwf+ZL1zz1eDljSE5epIryffF7RowASX8/6nU+T9b0exl3YmMAseMlaFKc8d2xwV3AMgQtVRSSwlveXvmloZPnlUwsPmq8nATbSgFm0AEnxmj3U3eWHEM7FuFgLc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__pcpu_map_pages() clears the PTEs it installed when it fails, so
pcpu_map_pages() only has to tear down the CPUs it mapped before
the failing one.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/percpu-vm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 509d8901835c..59d3a336a6bd 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -252,10 +252,11 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk, struct page **pages,
 	return 0;
 err:
 	for_each_possible_cpu(tcpu) {
-		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
-				   page_end - page_start);
+		/* The failing CPU's partial mapping undoes itself */
 		if (tcpu == cpu)
 			break;
+		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
+				   page_end - page_start);
 	}
 	pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
 	return err;
-- 
2.25.1


