Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EF8DCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35F98E0005; Fri,  3 Oct 2025 09:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D5F8E001C; Fri,  3 Oct 2025 09:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49CE8E0005; Fri,  3 Oct 2025 09:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAFB28E001C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:42:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A5BDBB599
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:47 +0000 (UTC)
X-FDA: 83956918374.08.F661853
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id C89D320011
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J2JkWq5P;
	spf=pass (imf13.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759498965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+uBUs752o9ejjaxLycOGdkkyFonqI7ieDhyDaEpM9qA=;
	b=xbFKMLtaF9732niInoNRO0ynjnjuXeH22y948f7x4SrFwP6190Zn/lb7OAQfl1KRKolQrU
	BJvFurdofrd0cGgHIKUx7fBwKkpvx7/ZFTndKSMujnPK34uuNAP+jYKfCWMmo3WuX7r0fu
	8GWsmdpn9C8pG3Dfef5M9Sbk4sDB5YQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J2JkWq5P;
	spf=pass (imf13.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759498965; a=rsa-sha256;
	cv=none;
	b=Sfe0eor+dpVm1OaubfvZYE4mT2kAlkdiNn1OShigM34Xsax4BAXtw99edLCt/tuFyp3R4I
	GA2aOUEkbQVWYXPiKZdnTln5quJICrQIEsE/QmGR16DcoHhcsHWaNVQsdyqm8kW2JpI6zh
	S77fyyC3FCJOZtliR/ajgiKbFEdk0hw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759498964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+uBUs752o9ejjaxLycOGdkkyFonqI7ieDhyDaEpM9qA=;
	b=J2JkWq5PxEYbIWlWupbsTJRZRDPO9oLQItY4Di4Ao1h2NYIDqcZk6xzaSkCaQZT6Yb901+
	ecgd2M22m1L+8I4fOvRNAbUELKeeDgp/hbTZr/aUhU7m4N8sWxfZTj6EP5wYlFf9jWd94G
	pgqJnCiF1Vd1snaz1EXXbxMsmkhPa2k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-4PEntGNLOpijA2AKBOui0A-1; Fri,
 03 Oct 2025 09:42:38 -0400
X-MC-Unique: 4PEntGNLOpijA2AKBOui0A-1
X-Mimecast-MFC-AGG-ID: 4PEntGNLOpijA2AKBOui0A_1759498956
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16EAC1800378;
	Fri,  3 Oct 2025 13:42:36 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8D5FC19560B1;
	Fri,  3 Oct 2025 13:42:34 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org,
	brauner@kernel.org
Subject: [PATCH v5 2/7] iomap: remove pos+len BUG_ON() to after folio lookup
Date: Fri,  3 Oct 2025 09:46:36 -0400
Message-ID: <20251003134642.604736-3-bfoster@redhat.com>
In-Reply-To: <20251003134642.604736-1-bfoster@redhat.com>
References: <20251003134642.604736-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C89D320011
X-Stat-Signature: 33rr43ef3tqhzy4sf7w4i8n3yj7qmdmz
X-HE-Tag: 1759498964-709548
X-HE-Meta: U2FsdGVkX196zq/lt72dcjoWNdUT/MByz/TMCZAbRAZldNeVsXWqBzR7e9j1mVmgf8KBIMkVUpxU9zpQUH8mjtklKfTrrHWfcoIq1zt487A304ksKsD1V6ppq7GVXc2/1kn6CTQmkacgOTt0ili9/ThCMut2pYMG0iIMRpNy/6BIIsdtSGaK703GlloPhP5I/nlV7Oumu4fsR5J4NTkGEIWPcftsotWeA7/PgVr78LAkdol8XK9uL3bAPKnrYVj1kA2U8hvfB0Wod5GupqJcBFpLOErC6uBCzocm3AHrvJ+1VCon9JvDQzSgD9dkEeTP1hXhuL4Dxu2AdWRvKkrOWE8lED58NYmLbPgrX0el4doZa62oY6aAp+7pfD/QYLgpqV/HKHHgHzyl7rCDReS0q4n7DRvibEdB45WTY1FL6IkHZc997bc96Om89z/j0UGtKP0tgtCRLwJTcOp+RUoOAn9DeXVW1hLFslOLgzifg4sTjqoNOsAP/Hv4RtWAamf+vdbu0X03X6uneAak0/upHjs1CULkQ7JeD2tQg+PR0+whuqFxfDBwabEwWUVPGaVRxrEfHpaeAe+MLFythtm8TLstC1ArL0vHQlA5cmGr18bc8KlSrYYXWPdAX7MOgXEE2RPdSxCd7E7dcIvDse0GF0FYukus5KIE9+fG/ceVDIBr4RLIhsH2Tx30jqxY7KmutzltKI27mBGsQw3Wwk3Cgp6y+8Cy1f+jHli5L510yigdL77WXwSXRY1U16i1T/rM4mvOspaqOQ9IO7n1RkyUVxX2cshVqME59QxDUK+sw4qjT4/q6BNfRE2osETTsOwTcmolX7zS+7usZiJrJbZlakwwuUDibQ7yfH1EgaLXumfDa5b7CaS5WWpeTw7tvoO51v/k4/t2vllJ3g2am2REhE6oLBj21TqHuiImy0370mSm8Mhawyrpiy8aS7hhjxSeihljQP5aUrSMhCnxYA2
 DOJl3b6i
 rzMsKY7Qq/yyKRAi1QV81M7vNCKMtfHgXoShpy6OMljhYuZu9v++6tvRVcGC0mxijfBU1xfdHinsRrQ8KmpLxmOgn2KipCOHDolPRJfGw8kd7UNDntA1FBNe8dwzMe+Iivq8hf7CAw43r5rHyqL4OUHMu8pWZzNFmM35qKpMo8u+GaUX4CHAYcmN8c5xBK66CocbaHaj0eqzxAdAlta+4Gi0ArvJxnBPreUE/wnI6fQblVV9qn8GgZ+4pICcpfIwBaqcloiEDRjR9NkwEtHEE8YpXHxQs7K2wGd6TJxLW9h/5zV1ThQyjIpam5738sO6KBV/bIPHwsEJbLe3bAe0AQQNKg87XyvdWJ0GYwsuIM8u1E7dCy4l3IQUIsH6+xVedfy5iqLprNnFcXD8EzMdMX09LHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bug checks at the top of iomap_write_begin() assume the pos/len
reflect exactly the next range to process. This may no longer be the
case once the get folio path is able to process a folio batch from
the filesystem. On top of that, len is already trimmed to within the
iomap/srcmap by iomap_length(), so these checks aren't terribly
useful. Remove the unnecessary BUG_ON() checks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8b847a1e27f1..211644774bb8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -815,15 +815,12 @@ static int iomap_write_begin(struct iomap_iter *iter,
 		size_t *poffset, u64 *plen)
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
-	loff_t pos = iter->pos;
+	loff_t pos;
 	u64 len = min_t(u64, SIZE_MAX, iomap_length(iter));
 	struct folio *folio;
 	int status = 0;
 
 	len = min_not_zero(len, *plen);
-	BUG_ON(pos + len > iter->iomap.offset + iter->iomap.length);
-	if (srcmap != &iter->iomap)
-		BUG_ON(pos + len > srcmap->offset + srcmap->length);
 
 	if (fatal_signal_pending(current))
 		return -EINTR;
-- 
2.51.0


