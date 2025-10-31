Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FC5ECCF9FF
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E309C8E00CA; Fri, 31 Oct 2025 05:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE08A8E0042; Fri, 31 Oct 2025 05:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0788E00CA; Fri, 31 Oct 2025 05:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B634E8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:35:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54C67C044A
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:35:31 +0000 (UTC)
X-FDA: 84057901662.08.A981148
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8091816000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:35:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NTbfp2cb;
	spf=none (imf08.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761903329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IzxoBLtZptFWlFdxYZIHYSOPY03LpnAZh+l14rPj8Jg=;
	b=HDe0Y6/ol/qPwrxMjwi6ARSGHmhPcO+BGIoXTzzjjnp/J9SKEsSkVP8l+1RTZDDRQx8etl
	xaHLroMpDn6aPI4b/DJ4eQzDSWL2jYBE8PEAFhkDvrkNKLE/Hj23J67nU/1unF4595fkdn
	jv5DVYLBF7/f44OxQf/dK+ZKpUoGCFA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NTbfp2cb;
	spf=none (imf08.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761903329; a=rsa-sha256;
	cv=none;
	b=Dy9Yqx1Nc+PB1C8tR/vDxSaSgcLcSiIEcjdhQg1lDYk0fGDID8JhaJoYbohi5iwCz+OXEY
	ZM46q6CbzU3dNpvTsbatNLYg5Ke9uMPebSJStbk5wXmN/iLL9FsIbGUWZl53tenIi41Q+o
	zqRfq21xwtq4ZNzIYJWz9YaXCz6tBEc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=IzxoBLtZptFWlFdxYZIHYSOPY03LpnAZh+l14rPj8Jg=; b=NTbfp2cbP6O6sGXkbScnzjglXB
	pbAgTSoPb87GWLEFV0nQfOKC59NW54HS+r3/eQ/ax5kmxVKaUbcTW42n4B274bix1savWZfkxMKPr
	aAVq2K8VkvwCt4LhHKFmyVXopRpTSObAmN6UccBH0oq3w3U5vvUrjHH/9uNYlo7Y+6NOSk94LVf8g
	gUCxnM5safupGnaY11uSGylAdtFeTMKKbhGTS+JwJ4c1ofKolaDDqgcTSfqaHhvpARHWRlcL2moVO
	/j9BME6/32LA5URc26kmkCJI+g1mClPaQcBh4ZlyZBEG5sjv7FKz/Ef2OoszeH2Wwr3RisJXoINiK
	GWyHrqBg==;
Received: from [2001:4bb8:2dc:1001:a959:25cf:98e9:329b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vElXW-00000005ook-3cUB;
	Fri, 31 Oct 2025 09:35:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: move blk-crypto-fallback to sit above the block layer
Date: Fri, 31 Oct 2025 10:34:30 +0100
Message-ID: <20251031093517.1603379-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: ejdfjritk8khk6ss7ds5798dqk594w91
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8091816000C
X-HE-Tag: 1761903328-739879
X-HE-Meta: U2FsdGVkX1/TP/RP96OQArPw0eGBW7aO9bS8pozFJ0IGMlOPE3Nn3ya6funax+tn/9tI1QZJH7DAwMdLEPAmXid4hSg40X9egN2tZCl3+zKMR9k9uB0NYsuZjB5yudMqZXb7JKH+01E3gFrj5wcerzD6BIRK9dKiUHUVUAJePziVnSeoRes3mK/ir/NaovW62x8W8Npr1Jm95uzf+UZeawcwqffxG3zvZuDqrFfWELNVAJOWYcHjAJlIG1SLs41z+1r2SELq+BtgdbS+tRrHjbUlWJ4Nh2w31j1Mal9h+V8EDEvRh0foWj69jHUusQ6ek0wMQDiBsKSYWns72ol8ywwLFdLQYmS7cGJ8YDUYvbCPnSAq615rh4drdTEOZikPpBMfj02CEtTHYrjTHtHzna05TzeCuwb0NOeWIudRLQb3b0Y5ZEW40QmT4zGu4inGXF6h+LI4R+5MpCoc8cRrxYGVAbZ36OF+vt/QuNeX2K/7tak5xQ4uCWI+qAOpJYoQRZizyksGyzI8GsxY2Z5fCzbswH/NS+WXAOrDfIbh7GXU4KCE5Zu9SpTVrQ03zTVWXoUWcUVrI48Lg7ZtyvS0i18O6OFbOk4uxMxOOaCjUvlwGxn5gBxHBMVfQd/sBcixpg9D0x3LOfO8nh4cOcvWwEHaG9TLWkH4NVvxzD6pbzapLoW7gPLFmkrH++j28geOYpncKET/fG1nBGNyIuVgApYKUwIjbbn/O7RJB1NReXbFIEIo6BndgUdM8pTNZzhklZ83Vb5SBJ1aNQvszZtsgQ9ZDGEoFPEBWpCl/kSpsxH1OL3tpEusY06A/YGWJroVCzNfbFk+q7qvXHvieEFzmHB9Fvg+P3Lg7vSl1D4uYQzuZ+uQYGiLzRyfJ93PlypUQ917eRUM+0kV1ILTJI0k0pUHHruingbSHMyqc9pZGJUsgNYNAbRn4hXwNKBi8DxEYnLVPm+rSM/pRyy227W
 hoj2YPhC
 RgJPqT8yl7ohjDIwIB3IArbmf7bIBUsLLUdA+OTr9HY2PLkk1QGJQWMYBPX3gIqmDPyeZJ2glgv6XT2/neoaOS77wl3Fg48FGaTD9yh0sXxPAJAlmxmTx059RasqVLNjRLrgc2KIJbHL1JjAZILBQup+Q1IzDrPz4ZT67Rt2puAlvs5IgOokrKlOMBRppyIeJTP+vqNqM3fP+K3MRcXpMs/aVPka9ZjXv5JzCIgCrj1xsoHi3aa7LC2f38vyitAZqU8Tty08AFKPzbpaS2m6JUDficB5EEClXV2Pq9//BKgCLgaIu4hhVDGW2JW3bbsn20tmITKlhuBlEyM1nR84q2zFj+sATFMqX15nlVy+2BEUwTmUc/mI21tHIcSDCUxHI6BS4jfHkd+bmpg49HjxwTyO9LSesWeb27wsOilViboQ3M2XOjOccD/EDFe5w+VhgGXqsSuRSK84fnLd+Z4EyBa5njzxbJ2xPPVtawNO15oUg6AU5iSbXiE2xY4Djs0FOTQj69/daGM+Dcj5NW/4F+BZykIlut0IfvNttf6sG/WwjME1jy8unHVKBVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

in the past we had various discussions that doing the blk-crypto fallback
below the block layer causes all kinds of problems due to very late
splitting and communicating up features.

This series turns that call chain upside down by requiring the caller to
call into blk-crypto using a new submit_bio wrapper instead so that only
hardware encryption bios are passed through the block layer as such.

While doings this I also noticed that the existing blk-crypto-fallback
code does various unprotected memory allocations which this converts to
mempools, or from loops of mempool allocations to the new safe batch
mempool allocator.

There might be future avenues for optimization by using high order
folio allocations that match the file systems preferred folio size,
but for that'd probably want a batch folio allocator first, in addition
to deferring it to avoid scope creep.

Diffstat:
 block/blk-core.c            |   10 -
 block/blk-crypto-fallback.c |  437 ++++++++++++++++++++------------------------
 block/blk-crypto-internal.h |   31 +--
 block/blk-crypto.c          |   65 ++----
 fs/buffer.c                 |    3 
 fs/crypto/bio.c             |   89 +++++---
 fs/ext4/page-io.c           |    3 
 fs/ext4/readpage.c          |    9 
 fs/f2fs/data.c              |    4 
 fs/f2fs/file.c              |    3 
 fs/iomap/direct-io.c        |    3 
 include/linux/blk-crypto.h  |   16 +
 include/linux/mempool.h     |    7 
 mm/mempool.c                |  173 ++++++++++++-----
 14 files changed, 464 insertions(+), 389 deletions(-)

