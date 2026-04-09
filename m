Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55B1DF31E5A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88926B0099; Thu,  9 Apr 2026 12:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18006B009E; Thu,  9 Apr 2026 12:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27C96B009D; Thu,  9 Apr 2026 12:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 951FA6B0099
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:03:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49B5B1608AD
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:03:54 +0000 (UTC)
X-FDA: 84639488388.14.1485E6B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 057ECC0026
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:03:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=foBFWmHy;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf28.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZPfOCtOPWHY9/SgV/wgHngzoQ9jPLQrp7zmaF4Sty0=;
	b=q53H3w2QJiVudxQwfPnKHLoLjE+/U9KMn3DuZE37txXCoisRDkNzQUx3geBU5W8YW/UuWz
	hb5RlZhwRjq0AjUA478G1oR1XfJnLWFlZVXupRmc+tE0BTdo6mkutFXAgbR4lHacqNvcju
	HNMiLEAG15DAxgFAXvDTAsoB+PwCtL8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775750628; a=rsa-sha256;
	cv=none;
	b=K1YmJ3bw206ojqeQY5+eE5e4euVlwcLK9+fZ3xbu49BSLw7zyZcYUyG6n5ZwwxpoV5aGpM
	kY+Qx6DLHlABdLLTuN5p4s+ItRYL6s1AAqU51n9MBEzbbxy2W4o+0pFp86juy5PesAGG6H
	NPiuG+qI+cREy3RZIdxym8C+eeanKZc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=foBFWmHy;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf28.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aZPfOCtOPWHY9/SgV/wgHngzoQ9jPLQrp7zmaF4Sty0=; b=foBFWmHyhmvVqdBAhKUjiLfFlc
	TNRntGXjsR9Y+xNRMC4FB1ZItRiJiNWZJFZcypXaNQ71bGWE7SXJm//2xT6RHrnCe+557Ul2Y2kHe
	1u8skjRrYaShEZUDPBTG0sSYwH2bCTW1/lc6nInQgj7StcBc/iqbW8u3INWkRjaQ+S7oryfHkQsx+
	GEkoxOpMH3Rlhijj2EjZHQwOSuzIjBy7Itq6bdNvEWyOgnACHJwhj3/3o4ATonmIVyoGEoPmrk+v9
	xyXof+/zLRdap/xo3V3/xOwJXa5dWyFWOjGJjJkz4PslGaiHX0B8IEqiJ9q+y+5viLIZ7ZyhUoP9D
	RszNWLEw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArr0-0000000At63-3g29;
	Thu, 09 Apr 2026 16:03:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] FOLD: don't use in_task() to decide for offloading
Date: Thu,  9 Apr 2026 18:02:18 +0200
Message-ID: <20260409160243.1008358-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409160243.1008358-1-hch@lst.de>
References: <20260409160243.1008358-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 057ECC0026
X-Stat-Signature: c4cdrac9coug6t66ohmps9176b8mo7d6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775750623-737486
X-HE-Meta: U2FsdGVkX19LnIvFYpdyPg95cuTqzwDAmtaStYugVw2kKjeOJBrzSchB6S5/IwDb6KPtok1Y+/Rk/jP1iQGu/tqjuh9prqu+zPLBziiGgzPyK+Mm0kTVGmB11VxBDVFPVyqcVq0CUIcJFBRlUKx+nKnYW6HyyWHEokKXHtLcDl3lsyKHlFMhZjiCBr3gTEh2CE4D95iVKzrWEQL9MEzlFk0cuGXiELM6kU+IMcA7DBj5QDxrNCimiKgANrkG9O8x0EpKa97Mz6uSvU8asNtHfbFmXcRQL0wPHtQDoyWRg8sspnmzkXA2uqPX4UgsTDhUuPp9nddxtexe/XUBCyg2ELyne/5FcMP+M/zMAp2xwZD36kfvewdAIZZR+5jPbni7hXlwD6WaNUERpXEdHfbr8XUGjzuIKZQHsqqKXnfFeycW22KWcsi4bf7qXQ2juqkzfb4EiKSQGa9ahZjXrrjqcnVCivBg60TEA+f38q+O2nJnYwfYfITE2CAiltPHJDXktnr+tJ5Y29sHK6SWl5cxpM09XQf07VNRElyr7LhaCEtU1iv7j0X5YFePx0zEuioenSubMiA90UriYVBVgsGdUq8ilXSlURrtT2RSJXgL9nGGn9C1ouP9tpJ3N66XakajdILgoanyAssQAqbxrJjcQcrV6zrAXGVzpSIsnAHRKXQI0dFrbL8ZRe4pDSRu8MBp/ZH3z9ckrNEs3r7sLJlfJcQxpI1exGA0v0o8f1GcO3x6Wi3p1pmC0hRR5zhUbZVH2MQt4Hw3vNW+/fKXkv7ZAfU8tAFQqm+3wMIvUjQnmprFa5/MT7wwxSj1SxMKyBgMhzalBVMbhTX6bqLl28Hh1B1dEOb8ahR1ovG6ePhK9a6rdZk2FsD+FvcBIxTMNjyQoa+Xz/JIKUEUyPmBFuvazA+zfN4wJH0hf1DKogdljl+BXN/Q6vfRzOk50iFjQ1iOA7jP+erbQu7KwKgonvi
 PmLvC3Oo
 EdWyrDPEH5P6WaYSh424nn26rgQPTYzpALp6k0177VN82HntbLUVKm30DTDaY0KDGaOV5C8OC/rR9xpG6nc1TOoVlu/ZStnLLumIGDlAEnkEFzvV8J2dtR7L/Xh1TsbVt2Ix631g5guGc4daqbpVkuroRC+FdsLgWry8xOEpbpFMAV+3GhUEVESXVyeNJRlvYwlMkf035aWQEDe7KxmogDEI31FjUKfzp/BrXnfCLzr2LjezNKrhs9+0JXQsRt8V6F8YsLPZlLQBfiipSt+0Bdv0BxR7mexNyego+R+GmConryNURiKE63guJdo7/JCzaN7EiwPUBa4GrMqWt8w1zxv6GNtVt8dIPj2CEjz3DKIUbXv2pY76XFB7hsHPhcsfcAM7El+bPulfgRayd4xWJTrDP1eJSbaUB4ryZSpKuA9OLxjdwQtvstsvJlAD6VCCvE9eSouSFgmYYVmh6/IN0i/RP1+c8Xdqb61b7KQ+S/p+MYeqrzJ/nTxwCrQOAYL2d8z6v9kIsEJ40oBe+t9MDZicCGltLMEe2GSlMuhOlaixPhlE5F1je2AGHDZcfXgRil+AUmVJQX7+s8pQoviT1QKAglbuamaaBkMiPXGTXQABbCQ77kwDRxeckh5N/6KRsUgTKlplwYmF0SK38jpqHAErZbpH3LGVDNR+SmJZ1osq/lVUxRRK2slKDcnfLytz0tf+A91awcJ2v0QYY+iTmSbm3CDWI3/Mb2+38IAy3KvPGRHqVyWfStOEKmtrRaD1r2kAnRCy/f1X9OG1W3r4yU5640g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As described in commit c99fab6e80b76, some block drivers might call
into ->bi_end_io from non-preemptible context.  Copy and past the
logic from that commit, although having a core helper for it would
be nicer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/bio.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 45c311e5ff71..72664807c757 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -375,6 +375,16 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
 
 void submit_bio(struct bio *bio);
 
+/* Offload from atomic contexts to minimize scheduling overhead */
+static inline bool bio_in_atomic(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+		return true;
+	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+		return true;
+	return !preemptible();
+}
+
 void __bio_complete_in_task(struct bio *bio);
 
 /**
@@ -386,10 +396,11 @@ void __bio_complete_in_task(struct bio *bio);
  */
 static inline bool bio_complete_in_task(struct bio *bio)
 {
-	if (in_task())
-		return false;
-	__bio_complete_in_task(bio);
-	return true;
+	if (bio_in_atomic()) {
+		__bio_complete_in_task(bio);
+		return true;
+	}
+	return false;
 }
 
 extern void bio_endio(struct bio *);
-- 
2.47.3


