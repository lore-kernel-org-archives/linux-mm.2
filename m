Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C37D8C4453C
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 05:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6A856B00C9; Thu, 23 Jul 2026 01:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13976B00CA; Thu, 23 Jul 2026 01:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902FB6B00CB; Thu, 23 Jul 2026 01:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7226B00C9
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:46:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7A50A03AF
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:46:53 +0000 (UTC)
X-FDA: 85018957506.21.E9AAEE2
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6D825A0003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:46:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NZkM7sAA;
	spf=none (imf15.hostedemail.com: domain of BATV+ab842403ba89e86779d5+8369+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+ab842403ba89e86779d5+8369+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784785612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K+PZXaq32U3TufEyMUaewYZwMLMqHIERdn548N0cTs0=;
	b=aXCs++DfrCIqnGSmlejESj8lUXeS08DB6p6ev6EeLGQwDgZr1rQ5Saf5PFG3DTOPh09lbX
	HSpvycAjACGAW9iwyjdFotTstRjN/48ZiSn+H4AiD8oXkKBoRtEYlYWgP0pR+iVd+7aWRb
	h+5t0bwaYsYfTYnjL6JEMwm1ij2/nic=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784785612;
	b=fMuV712tAfnbHGOQtq0rrfJhel6+qSiT7vDFZ3aM1ms5bVH48ahslh4jsMDkVBO9q3v9jv
	kn9KAWLPMwjAFHCx+jh3SajTYlf555qqmNdDpqR6YjB4wWpJurC9EOI3K72EGjopdQCv0Y
	yXRPn8tbhVUG9qTcqqJpxr8r33AzTVg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NZkM7sAA;
	spf=none (imf15.hostedemail.com: domain of BATV+ab842403ba89e86779d5+8369+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+ab842403ba89e86779d5+8369+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=K+PZXaq32U3TufEyMUaewYZwMLMqHIERdn548N0cTs0=; b=NZkM7sAALmaobWAaZMJplx7y/U
	LsQ4OswQChA5sGRNqjILzHGzJNfueRIJzfJiHrxA/A+i4KtkMZN1LC6dUHc2nNqb8E+TZmKnf1UP0
	vqjBmd0GbYY6wOcyRT0GVmHFid1Vnrd6LhzUcohsHGgOkQC3666hydey0r0M64SVtPvY+7E48xR1+
	wiqDDdv9V0HWS43BMJC3K7VH9H2VD87W97flsH57GEEhkd5ge4SmeKn6cmRh1cFICRBJkPxCH5GL0
	qqqWBp9GhJ2QyQy5j3WKSTyDPaxOKlc7AbaR7QLPhu2q4PXfjbuXBl3W0SSvknPasBcW5m3gN+M2U
	DTdTtc2A==;
Received: from 217-76-162-32.static.highway.a1.net ([217.76.162.32] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmmGV-0000000DV0i-2isy;
	Thu, 23 Jul 2026 05:46:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	ryncsn@gmail.com,
	trondmy@kernel.org,
	anna@kernel.org,
	sfrench@samba.org,
	linux-mm@kvack.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: swap_ops updates v2
Date: Thu, 23 Jul 2026 07:46:03 +0200
Message-ID: <20260723054622.3460249-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D825A0003
X-Stat-Signature: xum7r76onf1s33g4x3uo7jdsd3d5b9jk
X-HE-Tag: 1784785611-642885
X-HE-Meta: U2FsdGVkX19ZRr/pf4nlaWARjd64wfWFFDaD3UVtILEpQ5ATknqR6n/Ob83Zh4nqO8eNIo3Db85Kb2DqZQmDPWPeAhZ93PkOwn2vK22zD2bDQixF/pVyWxCPBJqoow31sXzRBztdzEu7+MskgGRtaOMTR2zbfVwjAksi5sFlyWwByNpzIk3856JaMJWZueUX5IoDpfmB88Idj2odJ8zTqoPnWC+UbDa7v34vtRuPiLUlJY2MxRNJx9pYhxD+GFHAR4N3wcVZrvCsJsJzPQ9ThDeX80hdeRQIiwXBJpaoNTtc/6II1eXOdp1QQqHtYh/jiyYkpR/o88+qrvYLsAetDR4YexzPDaFkCoBOz19YkisjZgbEayMvEAw6idH2niUXrhUO8sa5VCLfb6qbJp2nFgKpEYR/dIcWdAieycbLi/knH2yWKzM2cevpyMKYz0ozH5971E7y8kGBh14P9Xcx53Dk2ZaCSiJgNZFI+I1mM6wnnQ1+eXCzQXF1FtLOngP/agRwlcqPcru/lGyT6216rbOybXBVjPMlPL5depWuwi5Oa9Fs2gwpPc9OqKm5+tkVZz8neF/Z5XNumkFjMOG8LYo/URZECkfJHAjizy/KU6uCpEFPv9g7jiGNSdZMjFRoYj7OxbmkVRfJx5Afb7PVNzadB1OLeEqNf8HbLb+YThGNsfg60gPIJ5ihr+6vd48HJO2AFbGspvJM8Uv51cMeTLIUMgfmsM+XFOvrWvQohc4T514cgmkphFqhC1xL0hO+ndobiP2LrQzT4Myl404yrJmVBJz6KsmuxC0M+utMjHQjph3IDvu20Um+KKyG9WgSaVGNVKaSgPSR3V6foEXEHnBe2T84Ia1bs1KHrgO8tRj0qw5xQxGea1H/X4vzHabSAXWGKCKnskoA+8pyqBKsZ5qmlUc/p3F72RRsjb5589vjUP4f5NfIQ2Rv57TQPWxJHP+r4aSErcVeDw+t0b9
 HzlsW2tv
 K+lNmvdjIlYC3i5BRU7Go+szOdWPSr/6Mk7uALjtjpX1jEzlQC8FkafhfNtmq1/UbLr5eFhutSKp+/wXsAUa0cVjGGUSNsedJOEpZSOJuFMF0iJM27waZb/H6aEZ6fxkLmmiQX0yW206hlh0X7d3IIFcvn15WFDYS0VhPNaT1Vu1LYAJ9pY/arJm2dIffwp+qNV88BS0DKaF2khh/ubF8Vfk0fMfybgfjvfyYDEu86hXoBE3wJy+uQ6EN0+lcAoyya7iH9X4VoB2rl/GmpEsgNwMN5+RfAihpIIDlmibMhMkO9Vg7XCNckcYOjMX3o46DlYHheESgl1DEO8qUr8YHvo9XlFAdK1ImFeOVaahKwpr1xIXMlf7+5UcVVaP7ClzOqJgGBcdhQdtw/ZVJWg53t6Ps946GM8niziK9+d3yoXtPCON9o7IepkDKJDWfs23dsv2WAUOY6+z7ng1uDcTPY3vnLspPod3y/k8pleFqJ2CN6uxdYFB89joAFuaAE5Y0uH8vmQcSc4NuW47frhuEzUwySI+KMmr28YNwFMaQ9Ba+1k+o3iktdmckdeeiiCyeTqOBcJwC4UcEkJGUwcdUUG2iCqN5V9ZPFgfquJb5YN2FQjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

this series is a follow on to the swap ops series now in mm-unstable.

The first patch reintroduces direct folio writes for synchronous
swap files, the other two remove the double indirect for file
system based swap.

Changes since v1:
 - include swap_ops.h in zswap.c
 - fix a commit message typo
 - add a commit log blurb to mention there are not functional changes in
   patch 2

