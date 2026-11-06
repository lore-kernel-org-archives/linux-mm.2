Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEEC2606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=e39dX1aD
Received: by kanga.kvack.org (Postfix)
	id D272A6B05BA; Fri,  6 Nov 2026 08:19:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFEC56B05BB; Fri,  6 Nov 2026 08:19:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14876B05BC; Fri,  6 Nov 2026 08:19:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 996A96B05BA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:19:43 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 337D3A0D05
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:19:43 +0000 (UTC)
X-FDA: 85404751446.09.0ADF9D0
Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4E33E12000E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:19:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e39dX1aD;
	spf=pass (imf29.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793971181;
	b=BRb5Geg6iU2aQC/Tt4pdnOg6FF6CdNNQ1NOvVbo/Sz+h16KiBldARfrSZY+Bn4lRseWYm3
	j5TRCgNjfT/nYvlbNaGYo1JI9mTGroarcn5r7Gt3LVN12E5kFJL/JSqKvAQOMc/+3O6Uwx
	0kGCEsXiFd9nfFOC6G7uSVWvebnwe0g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e39dX1aD;
	spf=pass (imf29.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793971181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHDTPFGM/AF1nyT/Yc6bbkTHW5yMlJbnq5ZETvmi2Vs=;
	b=NqlcZ1Qv2ycRqC0ZLvTGaMCO49HoDR1MkYquGR8/S9IFktKZUvjw+mABq82QgnIdC/tMMk
	+6opghH/19hgN0vTrAxwTi08NX1onk4p2FdqPmulIgJ9CDaDNx+038x87MJe7jc0mvteR3
	ELGrWEePJe+JHQTkbnN25OMOEWWIuMQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=55Gu1BuWJQRvJsCcgFgbtSGQhBxGx47gTgITgbn0eiI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793971178; v=1; x=1794575978;
 b=e39dX1aDFsU5NTPTFLe3+RT+3/gSUyvAl18yS049B+1+avfXR5NJDC/GkY5xOMwPLboBKIzd
 N/1dhMtcwKi5kzXqiwRZhxE3jiyRM5th46sYicPK4WAzdzE7WYf96hN+5fs28ZwivqYdNalGYQh
 JAlb8yu3ez3DJaz2LqvdS2LE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2231816b5623e6c8;
	Fri, 06 Nov 2026 13:19:38 +0000
X-Mizu-Trace-ID: 2231816b5623e6c8
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: akpm@linux-foundation.org,
	dgilbert@interlog.com,
	mkp@kernel.org,
	loberman@redhat.com,
	jmeneghi@redhat.com,
	kraxel@redhat.com,
	vivek.kasireddy@intel.com,
	mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	stefanha@redhat.com,
	sgarzare@redhat.com,
	rostedt@goodmis.org,
	vdonnefort@google.com,
	mhiramat@kernel.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	axboe@kernel.dk
Cc: linux-mm@kvack.org,
	James.Bottomley@HansenPartnership.com,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	phasta@kernel.org,
	joro@8bytes.org,
	will@kernel.org,
	linux-scsi@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bobbyeshleman@meta.com,
	mathieu.desnoyers@efficios.com,
	robin.murphy@arm.com,
	mason@kernel.org,
	aesteve@redhat.com,
	tjmercier@google.com,
	harry@kernel.org,
	vbabka@suse.cz,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH 2/7] dma-buf/udmabuf: account the page array metadata to memcg
Date: Fri,  6 Nov 2026 21:18:24 +0800
Message-ID: <20261106131829.3228926-3-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106131829.3228926-1-cui.tao@linux.dev>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: biomtwapq8i9nam689my9cb7yx669ghg
X-Rspamd-Queue-Id: 4E33E12000E
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793971181-354563
X-HE-Meta: U2FsdGVkX1+TRB41XbVKJqTSMuTKKdqjnvwe6S80o9PrV3uAUsSL7LeHgtijYQ1L0DwWqBRjE6PVDYABxnAiUTDWCBARPiPFw7FgcXknkk494JoAILRxLu5OV8IIR428TALv/KbonDCCddtsQRS8XWHgVL9+3sKyLTFKtu5yB2R+JmOrLotd7T2KKO6h3qif+9+4qGxA5uinVNhnKxSMxrTVybXXoPfMTnFj6ZOHlB8YTvMIEJr74WI6gxHE9EkHfmAAZ0ABReZPafAXTx8SZ00VVVdQ1g/k1ur59Yi+JrUkVQLNUWasnJwRJZc2WUSq/VEiApIMzF3p3LVwo820SyQt5lB5LCX6eX7UPt7vhG7Lkipnjw/tSWxII976wi+duSWSkWS6zfwtNPKAn90AV5xI48BmejGmKjrG/StE1YvPKlS7qQU/oO0ljhhWmxR9u8yhh1OoB+2cXmtvawooUv+JYhlm2RZ4xkaP8vKhRM4LSUcmQ8bIdEpV3eAI1gPqCq+2GIEdyrS+rYVV5QgRJI6QzA5sjQrNpMHFtUg7+VVZvaGWt4nLAglal2leMR8WpqP2DN08bUeQpYoBxYcg4wDfi8Urt4466r8cQMz6RoBWOy7DXHtT6BRCqA/Yh1hq10DXcS1KlshoOt0IrkMQ+RAQEI2kg8LGePPmlXnd9FA/ouyYBCnKzIZdwxQR4Du6t1SL3hjZqox+6m4xUsEWYnGEnj1FkSB0DFABWIHu7iGB34BbVkAVi0YOJlx7lT835kBqLuCpMdQuVaVeRKxy272amJ3OiGs5J+hRaA9sG8sOQuRh3ZgD4UP5BRSefL6U11fTCZcunxJ3vDC8JA1NvL28Fjk+B4T1rKbQVjr4C9t4UGeNsdClO5DyGpEMZLSbndtR99nJGAMJkPvPSBlxOCPJkG36G9NUlSibOaTG5OK2KiElUQjVSqFz0QOM8UbqW6PH2i4xFZ4EwGZO5zf
 MvWOICU2
 zn+MABH1bF57iZb4BV5p17nkWY/qUS05uSFXh9uw6OF/xFln2a8v3i2st7JBjn00PqMgxvs8PWhcbHw1g7dgmJ6AM73jHnotRkp8eBq2NA+2XTSBI4FrwIHgj2vKHZopBKunLXL6CqJPETOqGcVp6WB13sknYabaPdoJcwcv1YIzF+u+70xWf3Q1x+PzakXoXAiHt3lp5aZZD60Zfok1sJZjJYuxmE2NjEJq6OIdD3qsN9b25KkAw/O43HEgcqn5vbLC2hJEPC8Jqrp3n6Y2MypLCxpkEvaJfPCFUp73fJq90COo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Tao Cui <cuitao@kylinos.cn>

udmabuf pins the pages of a memfd and hands them out as a dma-buf.  The
data pages keep the accounting of the memfd they were instantiated in,
but the bookkeeping around them does not: the page pointer array and
the pinned_folios array, both sized by the buffer page count, plus the
transient folios array sized by the memfd folio count, are plain
GFP_KERNEL.  A 1GB buffer costs about 4MB of uncharged SUnreclaim
memory, and size_limit_mb defaults to INT_MAX.

Charge the three kvmalloc allocations so the creator pays for the
metadata it induces.  The system heap in the same subsystem already
accounts its buffer allocation; the data pages here stay with the
memfd.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 drivers/dma-buf/udmabuf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index df6dd0046242..40182c82df6b 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -190,11 +190,12 @@ static void unpin_all_folios(struct udmabuf *ubuf)
 
 static __always_inline int init_udmabuf(struct udmabuf *ubuf, pgoff_t pgcnt)
 {
-	ubuf->pages = kvmalloc_objs(*ubuf->pages, pgcnt);
+	ubuf->pages = kvmalloc_objs(*ubuf->pages, pgcnt, GFP_KERNEL_ACCOUNT);
 	if (!ubuf->pages)
 		return -ENOMEM;
 
-	ubuf->pinned_folios = kvmalloc_objs(*ubuf->pinned_folios, pgcnt);
+	ubuf->pinned_folios = kvmalloc_objs(*ubuf->pinned_folios, pgcnt,
+					    GFP_KERNEL_ACCOUNT);
 	if (!ubuf->pinned_folios)
 		return -ENOMEM;
 
@@ -387,7 +388,7 @@ static long udmabuf_create(struct miscdevice *device,
 	if (ret)
 		goto err;
 
-	folios = kvmalloc_objs(*folios, max_nr_folios);
+	folios = kvmalloc_objs(*folios, max_nr_folios, GFP_KERNEL_ACCOUNT);
 	if (!folios) {
 		ret = -ENOMEM;
 		goto err;
-- 
2.43.0


