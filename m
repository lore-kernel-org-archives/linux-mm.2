Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CBEDC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8D76B008C; Fri, 10 Jul 2026 01:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159556B0092; Fri, 10 Jul 2026 01:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0488F6B0093; Fri, 10 Jul 2026 01:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7DAE6B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:11:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 652401693F1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:11:04 +0000 (UTC)
X-FDA: 84971692848.19.BC39278
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 66024C0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:11:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TtLNUOoZ;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf22.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783660262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=x6cYJQREA70XRnYA3vwhMXNMbrevQhRKVoGbok7pL7M=;
	b=DQGMBP7flnF1Wv0RFQMxpdqZp6cNzmijQq42krWX43iQ4TEFzyO9L+xsFdYdy1uyewOAs2
	/U6vK69+vPROxTT3Ze9pUNlQg4+Mq7GosBaz22ubNKYLJs3YyC07CyJlknOxmDFPj4HPpX
	8BA4U8rxjuY82AkZsIhUbpWYHr0gvWI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TtLNUOoZ;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf22.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783660262;
	b=mb+YYKyKFeCrcZK9YgKP7206cwc7d/8QQSF7Er0rmMTMahzo8uOGKHmRoIoFacaLY8+lwQ
	EY4500Avqis1NnitqOlli6H3ZrAcjYB6KQ4yiJUL623T88pGqbGsjXhlsKiqx9Wc+01OI+
	b0sXJ+sn4K8RgHcbtAnhqppy3VCrBwY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=x6cYJQREA70XRnYA3vwhMXNMbrevQhRKVoGbok7pL7M=; b=TtLNUOoZ2jSBmq/alTerGzz2OU
	NSY+9NUMDoQLFNH4Mb4+LQKX3QZ/lnr7XR5Ar8iHbFzT6TKS4Xmx4SLxpfFPA1InPD9757sgLR+FN
	/tLrx1TQgkLNKwWOy3tgy1sf3H0rLWrkDHLOQbqwIaeguoqz35vZBgB+l971tj7b4xJ7/DE7e7cga
	GN+bHipMGYMHA+e4ugflDH9DVxpGvuSj1XLaAsc7Yc7RoDjNDayq0gkWnIZmny2mY9HMO1hvI72X6
	9mwQTWP6jZTIfIoykvt9yxPkkiU39zACLijitka3bQRgap67WO85lp0jFqLh43PwSmCNJnVGc+Xzf
	jrSBay8Q==;
Received: from [2001:4bb8:2cc:d72d:4dff:292f:a943:a4b9] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi3Vq-00000004B4R-2IDe;
	Fri, 10 Jul 2026 05:10:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: willy@infradead.org,
	jack@suse.cz
Cc: akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm: remove wb_writeout_inc
Date: Fri, 10 Jul 2026 07:10:52 +0200
Message-ID: <20260710051052.1839523-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: p86soyyo594wo1g3mjsdyxr5iuwotnnz
X-Rspamd-Queue-Id: 66024C0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783660262-890365
X-HE-Meta: U2FsdGVkX18zCxld5EWHJxtPqghkusJ2g0YeZKVIwsgOvh7zEx3PJvJn3yockrfNjku3Ti1oN4TIrQzBsC5gBJOQkLJpPLHExLrYItAtGk8vQ0II8l/aXjD0RdSaAzRuuRlB4gCjQ1S3LED0y7limTCU7sKrbns6EHwVNcJnhsidexmMMVoCUSIQ+R9q21M+GIfYQG/05mqwA+y9/G5ftUX4rvEalV0gwVUDysyFthRa0S72BaQL3VjvIeJZ7kfmmfTcA+p+rUhZFtN+DbpLhhf0ju4ClVnEkqWvQalzxKCWtKA7KJvDV488uOMau2odZ6Vcu9fIHm14XJyqokuo8z4NKMfx2TmWlGr2TCq78WYJtORbM1jYIndmmLvozXY30BZABDxpU+/vW+DE0fhI1a9JrfHer/3GLPqdJao6TvHMsZb8HEqh4BzTEcCN8SmFQ1TehQ9+/PM/MTZsTSR9b9Sk/7xs1b6TCfsGDKJ8VsBT5Kwwin58p99jSo4SIN8cUMjWAU26e3H/Yr4Myti6rS6vjuaAISgOgJ993RmYHyMFHkuIiuB8rYW+hnYLyZMG2oJpoYcre0dLmWjvgKvpcV6EumE+9/ECiKMf1qdYUHeOdBQur1Bzm369+q5VERh4sZe3TG8xxrJGuyG8mht8f0GTEpHYLiklYJft0W+UVRITBIoIU9botj/6gZGANxOvS1mwuava6TOaVKbIqtIZ/BWOxG93nyBUq57xedyelIZ1MdgSdlDgnGAb8OxqEtq9Fw3ok/6RrXJG3HMxSF+sRtkJt/zccw3zm0zmlzTovrs/IOys2uUs/NpRHV8ned/wsk7g0TFe498crIzCsjF0hQH/EjqyZQ4BOOWaRjHPjxl9KA3WUXXypu/Harm5OQZ6p/93jBj4q1FmIm2kq24IQqVuXa4fyIu/2QCJXz9WOCGS0Sw9kISjRpsIypdivigCOwU1wW+mWy1oC0/Hovy
 8qdlSHTA
 V7mkGn62clyX3MUalh40S+Y16a029ulwX/hileTp0gIv3Q81xBw5ClgNF06t2qDQ/Ho+WGzvHH/e2+pJZr/MIS3SVwX3stvzRBYZAkhKV3TvFtM64sLpypmWZCCOXIQCt9jRCOG9hauYoVNPH/u2MfN5reQ9RD573JtMB2Iv6l7/6UJlv1BrPgPchrE426accMpaT/6kv7APMyR73P7sa2zpPzecY2JdlxKusBhZ9ZT20LQ6euhw8x3WwT1mz0A7qT1veB5pEILJYjmawfd+bjI9mRhpneZ/rWuodPKwb2utDXXoEFf5Tk0ytcaK6dyHC7fec0LJVHSHSZt4kcOcn/dYogIVze4EMPnjPg8ZAvltIrMbOJfSAYCsh+OWmsMpSVu2y/+vygaA0UdUVK14O/7OIpe8ISjMhA5FG7XkQ1UnshlkredM419A665eBnx4+MRVVQ+9jmXQt0WjkJago382kWpYjWsQvZL8UzN5O/gpcA1Th9r0xW5zX0ZLSLp+5Uk4ygGE7Mk8ZPLHv0+ZU4Mfuz9hirbh29f0jpFF1uTsWuyIcZXxaIpsTxNcvPS7amcCQm7fEh5V2xswCC3HZ4wLMyDTki6fWJvMufDLjSA7nqt6CWby4Y2H4YPpANVijTD9M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove this entirely unused but exported function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/backing-dev.h |  2 --
 mm/page-writeback.c         | 10 ----------
 2 files changed, 12 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 5b7d12b40d5e..c2284466e7aa 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -76,8 +76,6 @@ static inline s64 wb_stat_sum(struct bdi_writeback *wb, enum wb_stat_item item)
 	return percpu_counter_sum_positive(&wb->stat[item]);
 }
 
-extern void wb_writeout_inc(struct bdi_writeback *wb);
-
 /*
  * maximal error of a stat counter.
  */
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e98748112d1e..47495be68598 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -584,16 +584,6 @@ static inline void __wb_writeout_add(struct bdi_writeback *wb, long nr)
 				       wb->bdi->max_prop_frac, nr);
 }
 
-void wb_writeout_inc(struct bdi_writeback *wb)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__wb_writeout_add(wb, 1);
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL_GPL(wb_writeout_inc);
-
 /*
  * On idle system, we can be called long after we scheduled because we use
  * deferred timers so count with missed periods.
-- 
2.53.0


