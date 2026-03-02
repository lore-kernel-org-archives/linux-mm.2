Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3B31E9B359
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF016B0089; Mon,  2 Mar 2026 05:40:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0936B008A; Mon,  2 Mar 2026 05:40:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8F96B008C; Mon,  2 Mar 2026 05:40:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9836B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:40:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DEDE75C4C4
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:40:31 +0000 (UTC)
X-FDA: 84500779062.07.36CAC3E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id D0A90100003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:40:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bsyRSWnr;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772448030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RF6wWZ9Q7iOw8AraJlgJV+OCrGtDdL884/ShRfPQ9O0=;
	b=tcUUEVXAb8ddwjXfeslzpetDKD8g4YyMyNqShufQqwdEtXrcEeQMmxhBC8YFndGC0HOvi5
	ydcKqZ4/beZ1KaBxpCLYok6WtrCuXBSPKxbqd7IqQ1g9chmq/sU+SBDTDVe0NTVsMPG4tE
	uPzdk7Uyx0zNHhNhEMY0ISPRV9DakAM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bsyRSWnr;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772448030; a=rsa-sha256;
	cv=none;
	b=RI9efW6be99cTWVGLUOuNm8LkvfbMCLGtbA4CjvMSjusjcr3cQA3bOTP8FNCI7RNehzUIm
	lGFP7ouAqytzkXHCl5qGTHAhYYYz0TulOyd99sDnbMRtayiWKwCjmeUNxfKtU1LY62e06X
	eEx/iEJ5MxCZpyCIAexqzd449NowxWE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772448029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RF6wWZ9Q7iOw8AraJlgJV+OCrGtDdL884/ShRfPQ9O0=;
	b=bsyRSWnr7sfr990EEpFTcliGcpXW9vSUO8CNs3t7d0gbVuBiyJmIAPyfEDs1GN+n7+R8VC
	bMYjVK9fM7P7xUoM3pMBVLHremNJBLR61OAgkOsksdyDoaPazHGcN0A6ur6U80pKh5rgB2
	fTtXgzgpyD7pfC7ao3B7sKd1vBquXME=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-451-ZBsYiD0AOjiVGEZzb1eGbg-1; Mon,
 02 Mar 2026 05:40:27 -0500
X-MC-Unique: ZBsYiD0AOjiVGEZzb1eGbg-1
X-Mimecast-MFC-AGG-ID: ZBsYiD0AOjiVGEZzb1eGbg_1772448026
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E75FA18004BB;
	Mon,  2 Mar 2026 10:40:25 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.98])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EF98D30001B9;
	Mon,  2 Mar 2026 10:40:19 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 0/3] mm/swap: use swap_ops to register swap device's methods
Date: Mon,  2 Mar 2026 18:40:13 +0800
Message-ID: <20260302104016.163542-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qzl8nHb57zQ7FRX63peCT9LOPawM06SPrseIiwRXqTU_1772448026
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0A90100003
X-Stat-Signature: b8zgiojp9fatygwxj3jp9o9p5krewaof
X-Rspam-User: 
X-HE-Tag: 1772448029-881402
X-HE-Meta: U2FsdGVkX19AufwoTcGB7Oiy0J+uzODtrmvfzl+je+CSPQqUQEd0o1RXwlTMstBWF2trwq6KkDFcQSKrA1vIfDzOSs1IJ8fSoiYwo3uO0GAeMy4YCIU6m/7vOoY1h/KeS1+Od1cS4lFDKcj0qgquD7PIYcx4dHkgzzsOdwqn27TVtrv5lEeP+B1fF/aI5LNu1zDVx8e0lBWMdk/6kTyONpYEzmL6kt8iLKh3C/mMCBH5bECCJ7mAR24qYi/6I/dVKBc0drUqUz9+Y8tZPUldcUpRgCYz12jqCjTswrYBsBBnaFTW6kCQF5c3WDwIG0BCpP1ycfq/I1o8CM6X/oDUXvJDryxWw6RnIxqZr1JenE+aWqVHD4VQXy8/nuX6f8mTZIvLcdWU9JFmKxMOCoj7hmm6DoD4lEYZTagttWjaugUoJzrDUOv2JHEQwT6IrB8yKsaduGioKtIOUR9T3Sfxd+51rycCJNKndtQX92cApJfSZgT7GMagt8BpsEwncxye2AlTn8B6EiGGOWjMxAKdCVrZWbNdAXRSht7ALHHYBeGf5QXFfVzpK2ZrfEqvEage91N/McWXoE9thl3J48a0SPGUjUnVtsxfUbb968ik2uHDMfdVqwQPeH4edoCpvWU8u8ezbtiuevkoeRv0btO9nSLCtiqyVI1cwtrKmyPD1Q/pznZ6k0NtkwpXq17ivCBETtgTgfWH2EvpVsQKx3R7XaXYCqz5OdN5NlcXoelkeX5tem8/3qz77XO5znpYuIV392IxU7qh+nKQA2lZIqw86IjEo1ZWw7XU1zFh2Smyvew7bNPB0zUJ0ETj7uTjLBck8bU03DhrIPPbLGlXO6PwVH26m/m3cNnBMI/USda5uCZdEfetq9zUagz6caifhGrQrlg0r+ofwcTFl32sfhPL/sGZhMDf0AsA/ZmWdHYPyeISDK4hmyE9xSLQPjHRLZKUg4EYj5PQT6+Wo5q3sUO
 ine3Plop
 DlNzqDfdNl0k08h+UGmNnAiykS4CanIKAc6p+WQLPQEb3thqAaGtKHFUgVFaSO+wQsguBrpo803HnFQoFirodf6JFAD+xe3jgtJ7dFKRAZlPwo98s4l7S1o4PIpXFXftRGcHgky4w36VwJ1dfmC678MTOPf0WnlexJ87ryHB0B2Un9kJtyyuw3EetO0c/uXjr3luig0QKuYtNj0afewm9p303Vr+i7NfYfDmjtHB5d2L5aIl/HWSHV21vFU2FIxvykwfu5Q9vRfax7F4X0wZyx469NqOdmJbRzxAaeb0bc+QIVtKTujvZjtChjvh1a2kIkjOBnS0vSIK+PvhUka9soSJY7mpXAPP13tC+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This can simplify the code logic and benefit any new type of swap device
added later.

And also do renaming in this patchset:
-------
   file renaming:
   ---
   mm/page_io.c to mm/swap_io.c

   function renaming:
   ---
   swap_writepage_* to swap_write_folio_* in file mm/swap_io.c 


Baoquan He (3):
  mm/swap: rename mm/page_io.c to mm/swap_io.c
  mm/swap: use swap_ops to register swap device's methods
  mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*

 MAINTAINERS                 |   2 +-
 include/linux/swap.h        |  13 +++++
 mm/Makefile                 |   2 +-
 mm/swap.h                   |   3 +-
 mm/{page_io.c => swap_io.c} | 104 +++++++++++++++++++++---------------
 mm/swapfile.c               |   2 +
 mm/zswap.c                  |   3 +-
 7 files changed, 80 insertions(+), 49 deletions(-)
 rename mm/{page_io.c => swap_io.c} (91%)

-- 
2.52.0


