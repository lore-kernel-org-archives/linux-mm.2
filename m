Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8702ECCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E676C8E000D; Tue, 11 Nov 2025 08:53:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3F208E0002; Tue, 11 Nov 2025 08:53:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D550F8E000D; Tue, 11 Nov 2025 08:53:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C396F8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:53:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61858C059E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:41 +0000 (UTC)
X-FDA: 84098469042.29.9DD2BD0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id B41A9C0010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yMasYjzu;
	spf=none (imf10.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762869219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/l9Hdn5bqG50yE8Iq7CCW/03Z6STb0lgI5QBSkVDgR4=;
	b=xjYcGqP4FdZyj/HIA/Tli+2kv448QJJ/vc7Ps1oGqGFPxKrb0TrYp5vLAMvutoqtpoPlcg
	K8gnXyc3uyUFSWt8lMthopPmrIusEf8aivx1E/uYaCSQ2omDHVqFHQ14g94JI9YrOWYXXV
	evRiEiKmkw3F4yyus9TUSp0vqpOhLS0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762869219; a=rsa-sha256;
	cv=none;
	b=nl58rLEjKEnJC7dAOvw2GO2NbsNLZ4X60QVQo0thXdOEjy7/x0esqYr5oWu0xXCUT+vfyT
	V7AmaNZ8pSaEZQo0dk9kIYDYrqXZC6Mjcix4Hv6SxzP4+E5FPDbBmiR/Yq67ZLNUmt0jMi
	m7GI9a2i8rQ/nzeJd+oViKEUzwTrLIQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yMasYjzu;
	spf=none (imf10.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/l9Hdn5bqG50yE8Iq7CCW/03Z6STb0lgI5QBSkVDgR4=; b=yMasYjzuWp173oMums2Wv1+XOh
	Rwj6mMgOVRRmUN/7Thitzct40xTKrIrKh9ZaD8JyLn2wH3ZWhJVsGoL/wT0YdjlVTRs6R+pmM/jsZ
	Jf4SEbFf42Q6zY5CdbjlBZwTkrcnJoYnPr9ii/rBw9FNgkVMIPhY4QE2gGsZyCTzB0Oeyk6+l7Dqy
	t7fItH5E1JfwMY/r/qPzdMRxgcpLLEJ2TbdMLnNYHQQAv1Nygat3LM5QAFo9awGLn2hc9Ou49c/iA
	ugxTJWY8Ck0DnIV0sNWJF1CKI8v/SNDQgSLtGAVYOaJgzZMzcedJemVWcqr5WWvKOUyhnOcOqhP9r
	tGmoJfHA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIooS-00000007Gda-3Jnd;
	Tue, 11 Nov 2025 13:53:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] mempool: fix a wakeup race when sleeping for elements
Date: Tue, 11 Nov 2025 14:52:34 +0100
Message-ID: <20251111135300.752962-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111135300.752962-1-hch@lst.de>
References: <20251111135300.752962-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: uz6scgequco11e6iik8hbwcn8rnhyxmd
X-Rspam-User: 
X-Rspamd-Queue-Id: B41A9C0010
X-Rspamd-Server: rspam01
X-HE-Tag: 1762869219-793234
X-HE-Meta: U2FsdGVkX18cCboUK99GsORPrBFsecX2c+9fdqEt0kY20ZUYIqnkXwXK915XlPnwosd2s1Ki8+pk7DUVG447l2hrhTNDlUB9K8lE25Y/V4+gRXZDMXn593wLS6+Lam0aHovrlCNEjj4ZeK0u52aO3BKok9T4puMWRSYmVfL0vWJYKZ7Ku5YukUx9ZsBqYhCWeC0Lrg+tA7fM2IEU9JZGZ9MhEydg2NO7USYLSkxux4cprDo+Uwc5hPu0b4Q649yROxA8vstKiKsGMfRhok9mH1jj9gZBOSpI9Ssdutc6RWFF8aQrCCROz+KLdUruU0rpfx7lk+zMkdrZmdm2avg6LoDqRL2bhEBfieFzufRINJnSIm1nc/e+abjXs9FIsjoNUdrY6x+TJQ6f+WUk3aqwE4PMKDcUcynlm8CqPHQSrGojwsQlEUBe8a7XQJ1hiGrU5JzPuDDw2OAWesxwwUDKmyM0NrMEuppffBs6uty4kKoJXbmP4vcjXpHzqsQdz/OaTV/6VLPqmLGcaOltWjpuoJUUTQfWc2TAf6EFy5Li5fufNksCsuPFCLBJtJBFMO6OviZUMb02SJUWFBedGaXDp0MtY+cPesVP9uZOgyRi8YkXQeXpTlzgPeVwhENdfaDApN7c/sK/ecOQ1HfZfnLMqHKrx1Fr8gulCABX6Ln3+OEg2uuSx8OXiyOqt64L13flpIkedS+idju9VLGmNjo3ZH78czvQVXl9y+BVZ8nnQ+CE5+RrAOYRbvpVJdclByx8zhKJHzYQo2AUkLaib37Szbvo0z5Drl3yZFKqW5VEN4NKoQqKznBfvBGunNOFqkCL6v37Vgmdb9OezXGk7jR/oPBmOnGz3owubbdfurSRNRKZ9p4XQwv8o9NW3s/vFxrelleAgEXJ1YzvfkRkiDiNbsycYyTMKhIP7zvJucaANJw1QmuNJVrh9vmiAcq8FPU560thD5GZRtpuJbokcjd
 IhK8SZfx
 JOI4aXziD31sAABtQet0ve5hJh0yEMkoZpgZ6HZO6k5HjjDf7OSekuCPqd3dnVj2bbY335czljQD8BcTzW7sO9cuEt5wQDYZh3yLgM0n4bfHXMlvszKzRaugH41jk+gN62IHNCwT2bIfF5parTszmx422m/t26PB43j1V3d8QXueVr5YOwsj8aCAvO6YFeDoFy4QOHc+Sm+XUotwShvvTjb5jhXCVyZs6jniQlK2QbJXmkATU4Z+EsWYD/MwGjV31UxmAeYuGaoAKbNQ9iu2SCKhti+cb4NfiiVUWMi/WbsLKZkU8RqdZuVFoTfovU2rH2FtpM0QQMLzx8y6QSnH97A2ViqktbT75Ts+hySuEM1Zf4dIlGLZ9P3wFSHVcZuQk9bl5vGKNvo2UJy7Qo2QkCpJMNox+t02+9C63E8f0Q2HAJYaXoFpMi8dVxV4fdMi+aBIYP4XXeB3yprfc49WCAmn+UIrtIHfn3MuzjUbsJo+6ELRsCHkMe8aVYl8p0Sb//m9/SZUIKjmQhajtZLEV+4pItOh5/xvruCAl0Qf+6H5THVo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Waiters always need to re-check their condition after adding themselves
to the waitqueue, as otherwise they might miss a wakeup.  Check
for elements in the pool and use them before going to sleep.

The workaround mentioned was probably due to this, but seems genuinely
useful for other reasons, so keep it and update the comment describing
it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/mempool.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 850362f4ca7a..8cf3b5705b7f 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -388,6 +388,7 @@ static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
 	spin_lock_irqsave(&pool->lock, flags);
 	if (unlikely(!pool->curr_nr))
 		goto fail;
+alloc:
 	element = remove_element(pool);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
@@ -406,13 +407,17 @@ static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
 		DEFINE_WAIT(wait);
 
 		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
+		if (pool->curr_nr) {
+			finish_wait(&pool->wait, &wait);
+			goto alloc;
+		}
 		spin_unlock_irqrestore(&pool->lock, flags);
 
 		/*
-		 * Wait for someone else to return an element to @pool.
-		 *
-		 * FIXME: this should be io_schedule().  The timeout is there as
-		 * a workaround for some DM problems in 2.6.18.
+		 * Wait for someone else to return an element to @pool, but wake
+		 * up occasionally as memory pressure might have reduced even
+		 * and the normal allocation in alloc_fn could succeed even if
+		 * no element was returned.
 		 */
 		io_schedule_timeout(5 * HZ);
 		finish_wait(&pool->wait, &wait);
-- 
2.47.3


