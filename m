Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345FF606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TfjLmBLG
Received: by kanga.kvack.org (Postfix)
	id A569A6B05CF; Tue, 17 Nov 2026 08:07:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06646B05B3; Tue, 17 Nov 2026 08:07:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE616B05D2; Tue, 17 Nov 2026 08:07:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4FB6B05CF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F03DAA0403
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:34 +0000 (UTC)
X-FDA: 85444637628.04.FFF4C4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 53C67A000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TfjLmBLG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBR9b/K32BoRw8TtSOA9dgWxNmbnE1ZmoY0n9+2HAHE=;
	b=dfWKuoTTI48ACdH8iHcfhmXrQ/tz5SqszWlkipgVYcV64MYN/jlh9kxPcTrHGfLipzJzry
	IszPPCROiVtIM8dAgM5HXislKMpfWC1b73u+pAEZhXx1KIrJUk35/ecril+86fzuAHLxnI
	9HJ0AQsS3EWj5qAWokgyu7xU2SFlo8c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TfjLmBLG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920853;
	b=HYALntJQ61TovjI095V3mR/ed3+BPKC3iU+DaJDlcqkXxGiQkwUA8w+Ew3DfUxan8uIavA
	QIdr5TjvGX3rBoQA0j+EHJ6gDHBmNLqwK4g72+bXPWbhplE0eL5yuFicxgyxrJ9Lid2mGC
	4M1dWpN/A1g0fUR9+/W79NM4N6s6KkE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F22A4644A;
	Tue, 17 Nov 2026 13:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2346C1F000C6;
	Tue, 17 Nov 2026 13:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920852;
	bh=MBR9b/K32BoRw8TtSOA9dgWxNmbnE1ZmoY0n9+2HAHE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TfjLmBLGZIehSAdiJx/3bs8koYeTSqi29GejP+Kw8dUIeDnkRn9yc3SxUR2t33pyW
	 5m7dEycjFd5BX1ORh0TzLYgpYDu4+lsRdp7wBDaFya88vJOFp8hzzL3DbFPuV2KPuL
	 LnFoFlWeuKLM+VsBj6YzQI2+VK+c8gE1Ri1kfc/ldqPYkWLqVAY+ZRuOm1wwGtAae5
	 OUOj96KlkkUu8ItgVL4npceuw55GuQQ9JWxKzXwgDpJPnjbQsl9Ht+5O9lenRZQIgV
	 Tbn8DLDpm2oxrtF8J3ubt2dt7S+1NZwUf/IIDBp+iGoLI2CLq68L8j64wWuRQJs242
	 cWzpWUBGtONgg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:07:03 +0200
Subject: [PATCH v2 11/14] s390/sclp_cpi: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-11-e518c99622c6@kernel.org>
References: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
In-Reply-To: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Queue-Id: 53C67A000A
X-Stat-Signature: x5w8nzf91wgwc783k8fnxbxi4ggifsux
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794920853-841438
X-HE-Meta: U2FsdGVkX1/+0gF6SeiTinIG4Ns2qZzDzz5I0u1LnHJpB/XFNDbb+jCY27J59vofDPcOncIkHDs65vIoFFpp5Eshh1d4T2jJh0a5SFMDqdmjHHP135B0lNmYqDvq2sKUA1CRK3YK6oBNalOHrXgfqfjWXXJ6sXSUTsoOc7zZkZImAI0YqS8dxusALqNzQaf6K80UZptkNMJHzE0vQW+AV1oZoCunWA5XYgk+u2jsOZTCv8ZuVqKsPSnwskKncIjGGTSUppO5JYtzqGiTwVXRwlLPfsaM2GzT7TiYlS/RGr6N7RtsMnknZNKe/czz/5yusy1NVyahDGLTFQEGyZ8byODI2O2ibTVhQlZ+xXx2sVylh7DssNKiQFgLQXtDoY/0LVgnoL8m0CQRDPJES9o0gnJfOaZBkxDtcAnGa9uKl4T7a6Mg2+wZIt9bcpYRDqqhn/u7meAT3wMyfbhdV7IY48fVUK171n0Axc5s9t9PaC4DpuMHVmsd0wUIGFzBTKlLoukhJAKnQfb2VGolHj50YoLvcQdG70HU9NXJtGIXf0VHtLAXzh876Ztj8SMwgMHORHwFUInzPQbVrEcFoeCJ1rEjAGoXcbV5YJ/FQYMxy/MshKcU4o1vORgXuUGnYLmsbA7v0fvLMUUJkcSWHULa6Icege4ZbcjpDWYmW2eqTYz1TlTkeNd99wmiKOJ7npGffCPFxyMc73/7XKy/YBAvV6muNgkLhk4qj0/Q3IWOFRulIqMqnyVjQp/5n7Z3Xc4LQSfBKJ1Hg0mB1x41aCSF5Ba0+q2wzDTqU+w8hj61hvsrMQqGtXZnRxEG0bGtdiA1HkEOMgWtCgmKeq1E5SO1nJnyWFSdoiPfV/4gER+J+gA1Kp3wkfFVTes7iG3Dl+aCqUHtu+c8d2f7ylHPbsr9j/Ue3AwRdJdaCU5l4Ly9/aNT+XdPmOy/BCYy0aRtXa/oAseCgig3wKZ9zHONZJv
 lG2yCOH6
 tZAFXGAA/Cr9kQxWEQV3G5UJr++tmpZsy1/ANJpUYT4sYUOBjD0cMQhoj0a1dg/WcrqAaXKI7VwMsnn3TEpldtyv3yXb7qIw2dkPxcSVxeNlWPTxjOakQ17E7jn5MACrYB+r9ueboailMn0oGRwW/HY3Vg8mv6qzP5uLKYeiMY3ryNOokbgDSC8BkZp9XAjInFf43uJaIP6GU86Na+0/dZJpuUdODRWrPCEiEfioZEa9K2MtfEc+EqOjoo70xswo1uraTsUn7q26xcQ4j7bRJe0526euWddh0sXRw1ATgA4rQ0u2TDaJFAAqHRm1QznKXebGW/c1Cg4eLeAfImCrkXTXe+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

cpi_prepare_req() allocates the SCCB used to send the control program
identification to the SCLP.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_cpi_sys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_cpi_sys.c b/drivers/s390/char/sclp_cpi_sys.c
index b80f73fa1e01..8bca2cdb34c1 100644
--- a/drivers/s390/char/sclp_cpi_sys.c
+++ b/drivers/s390/char/sclp_cpi_sys.c
@@ -84,7 +84,7 @@ static struct sclp_req *cpi_prepare_req(void)
 	req = kzalloc_obj(struct sclp_req);
 	if (!req)
 		return ERR_PTR(-ENOMEM);
-	sccb = (struct cpi_sccb *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb) {
 		kfree(req);
 		return ERR_PTR(-ENOMEM);
@@ -118,7 +118,7 @@ static struct sclp_req *cpi_prepare_req(void)
 
 static void cpi_free_req(struct sclp_req *req)
 {
-	free_page((unsigned long) req->sccb);
+	kfree(req->sccb);
 	kfree(req);
 }
 

-- 
2.53.0


