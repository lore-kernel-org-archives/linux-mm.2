Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85DEC606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 05:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HnwNyYEh
Received: by kanga.kvack.org (Postfix)
	id 533886B05B1; Fri, 20 Nov 2026 00:43:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3956B05B2; Fri, 20 Nov 2026 00:43:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F99E6B05B3; Fri, 20 Nov 2026 00:43:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA286B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:43:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12F2BA0541
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:43:01 +0000 (UTC)
X-FDA: 85454403762.30.223A9A3
Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	by imf18.hostedemail.com (Postfix) with ESMTP id 032321C0002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:42:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HnwNyYEh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.80 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795153379;
	b=bCUEyn53Z8MdPnEYhbxshCravQ4lRAeGNpwmUkBxYmHOr5qj7mxsGjiJ0o10yJizifsCDD
	5fazC+jAxN3ILBkYH9rjB/kFzEU6aDrYTFXiXrISfxYkYmew6E2bT3Cz0KeixRZ7l8vWzD
	kPzRFTw/x5J+JNvR59vC1IkuANOgQXo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795153379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hEpOzMSWsqAZ4vmFyWKGhKlXAADp5QsHm5LpUYITr+0=;
	b=OlCzoS744wd7GdTkxTaHFkPYWUDQ3C7GTSFz/0TER/ADh5CzPKSFQ9Jcwe5Lin3INd4xc4
	REjnqqOtD8XHL0Z5GV1g/wWM4SGbHQ1BmqQCRQ5H/aqnS+8wSDWEddwrtRWbqh5PCeHF2G
	SVeXqeh2S9HUo72RqRWkPMZqPNb3/uc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HnwNyYEh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.80 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sygBjDYX2IBEsh5RgXxZv4L/2uT7TB2ul0lFCsAHpAY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795153377; v=1; x=1795758177;
 b=HnwNyYEhKKOlUdgeUYJUJL4JYe667WQ34/ki58BF47Qx6FMrzuJzi/koQHY+tSl9fG6h2AKC
 4jhvrHpMYNsO34J5V4AC+PVlfXiIS59hS21wgPH1wAZWjsXy+y5kxYSZhry1uDm3q+d6qSAuMmG
 rq2jRXrp8iKbnNfr5iXFW5/A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5caa3697f8970349;
	Fri, 20 Nov 2026 05:42:57 +0000
X-Mizu-Trace-ID: 5caa3697f8970349
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Albert Esteve <aesteve@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Philipp Stanner <phasta@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	cuitao@kylinos.cn
Subject: [PATCH v2] dma-buf/udmabuf: account the page array metadata to memcg
Date: Fri, 20 Nov 2026 13:42:41 +0800
Message-ID: <20261120054241.525109-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: eebkboc39orhiadrksgp36o95wazhbng
X-Rspamd-Queue-Id: 032321C0002
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795153378-970162
X-HE-Meta: U2FsdGVkX181KKOZDtTBfp3pMe7z98PDyaKFVsEwe7qGNyjbDb9QCYaMpfYVncAQZMN7olz2S7RVpZsQ4n8fUweYdhJjrQFaXhSm0dtsEzoS4Vzxj+3pQw+nLFpkFajzt+6MTfz2TzVUVHyOGKwfXd4rwhZggEykcQVnUTJsOAd7yfp378zlBr8YK/zrtVcCJVsdgmr0f8wbvb9qN6tvRrCXmtpNBEGB2ahPpsGEgYw5wt7hP+WDJ0YO9bn4XJADOXsZxs6AOCAzCfF8yoTkmK3cmm3bZnZyAn5zsAiEH2F/kzpBcKoDlP7CfyKoOh0j8W7ifxqLV/6kOI+/v8nanSY8T5gKuyT255zJ986DjVgGSs2gW6M5x6vXGGBFSESs6vRMLt1HEjUYDBCrESH1PMbNmk91Q38uam2tCvlwtk7ArfnA7IYtdZtZTkFtJiD+U+qQ/uqycz3dFy3hfkAQGJrB+7YT4GgGtbU4XvL9Io8WyRebas/VFRGc6+D/10BK1Biu8l2DhkkARzDSnW+Uk7NMhFHESJ+lXkh2JpsHkI5W6f/W/BI9fev8ktWvXufaYVIhc6tbwJn/C03Z+ryq1wBRRgHLEMd9iQO2pbuAvMj885GqSm0jdDD7KlbV4Qeyay1GeVPsXFzd45W1VFkgH3vPncN9JeBxa3H2qU+lEuamTFbDWT8JjOhgI5hMzNKAyamtw6e1hrUGextyQ8z1y/ecTJlpnu411nKC1Z8Oqk1O7Yq6pARK4wkINwAgFl/NrC2sQpXbE45IZxoVSnx5Yckm839Pby1sa8ncT7jP4LNds0w291HWnvffY5Mf9mXYfl13zJkktmoaho2n4T81HRMXgFp4lrMwO6+m4xmSuo0QQggXb4OpQrVVVS16ZgI+ajil+vAzFqg2eBGXAneAFQZ4iH2FfL6YqGK5NPOJnpCDajSF0BEIxv6EUib8ske5FuzFYOfFL3tOEOAmeFx
 Ar+oX4pw
 9i/bwBWpkp0+0Giy8IIEpIfo3pVosR3FCjvcDe6SVZAtqgX2vLax6M7/luK7EPJmLKneD6fExhcDqYaK/tRpPFpXwwfDQWHE96fmzpMPIfwIWBSizM44Fh8WQ3XDW6Di8qxTaKIoh45fdzX5X7+Z+9QxEWXXf3uR0DWf5nXkiHB1oxeBlld0zTPsn0b6BFS5QBUlEBDCeZ3kDxTIA8J9U946MPCavVPzgzGAgb0wqbYZzB0WZAShPDXKIVtfftVs8SbOajPOhuQBe2q1IWQfOdlRf5XfLclzk7o9Pu0ZekrhGqsyf0GymMCmGUxkt69984WNWjXRoh8Alq0UNc3gz4RjQx8agWWuFlc8XrzIJMtPlPZifrpu6tmusWtml69KTi7khOa41MV1qdQ5f6+NZdO4NhsvaKjgtN91ThuDvVYBfxS0OMU8Y14ZJpDl8Aa4QGb4Fj2GYD+wKwGGabQbUFzYJfn6Q3haNS4JGumKGMpd8yjM=
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
metadata it induces.  The data pages stay with the memfd they were
instantiated in, including hugetlb memfds, which remain uncharged.

The system heap in the same subsystem accounts its buffer allocation
only when the mem_accounting module param is set; Android runs with it
off because heap buffers change ownership mid lifetime, and explicit
charge transfer for dma-buf memory is being worked on.  The metadata
here is charged to the creator directly, which sidesteps the transfer
problem for a resource that does keep a single owner: the memfd.

Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
Changes in v2:
- commit message: note that the system heap accounting is gated by the
  mem_accounting module param, which Android keeps off, and that
  hugetlb memfds stay uncharged.  No functional change.
Link to v1: https://lore.kernel.org/r/20261106131829.3228926-3-cui.tao@linux.dev

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


