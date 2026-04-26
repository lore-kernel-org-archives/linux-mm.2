Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60943FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAAA36B00A6; Sun, 26 Apr 2026 17:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34276B00A8; Sun, 26 Apr 2026 17:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23B26B00A9; Sun, 26 Apr 2026 17:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A00C36B00A6
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44BC6120571
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:02 +0000 (UTC)
X-FDA: 84702045204.14.85786A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1390E40010
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qqbsm0MX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=QZG/s4kDRJPVSOSBBMItxCghsj/srX53lRwmgUdIciVGr25Vfk6FxuiTv1IsM4HeUPRARZ
	895fA+LKfkYy9+wdSepbEyiaNv7nkFZUzMghh3Ib7nMRVUZIaXBcjmUWSqJZrC9JnGdpkA
	lS8MDV3LoeDSjKBoNB+hmTiRY1IbQqA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240080; a=rsa-sha256;
	cv=none;
	b=jjZcYIOK38YEnNA/z5jOB68oNudcZMSkC+KluCLHmC2VvR5J4DGjsb30c1hNkGSULsCPMZ
	uRliyf7YbBbnihm3ytmAPfMNRPDJ+YWRAcmkE310Bd5ZqoAj82PsUNXPsN0V6I6ugbe4Hc
	MPuMq3P6wy0zl6DP3w7MaHn5rJ/3jT8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qqbsm0MX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=Qqbsm0MXf1mnZ/kjXu3Ky/u1WujklA1DeCnV78Z/eb7ze2TfVAY/egQxw6P5/Kvo4Rf9rC
	fraZ3fldaSb4mekhoAP7/kZHWnS+PXu+XNf4vWeMC2AsjYSFF6qSiHopkZgdmGXn/Rx9Za
	ghyETr/qF2oPlE3wxgwxhqeP+jU5CEM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-awhZIJ7fOtC8IkRhMN_Yyg-1; Sun, 26 Apr 2026 17:47:58 -0400
X-MC-Unique: awhZIJ7fOtC8IkRhMN_Yyg-1
X-Mimecast-MFC-AGG-ID: awhZIJ7fOtC8IkRhMN_Yyg_1777240077
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-488c0120047so56215145e9.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:47:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240077; x=1777844877;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
        b=EoRwcQ5D7oPVIDsE7ZllkPgXYak7Dwqno/7ab9Xy4aPYRCboVp7tfKBzVHyyxjP7UB
         nW+7GcCkBvgSAzAZj6wYSnMZau3iFq+cJslh1LvCiiJ9eE4fLd39XHfh5PIg0fw+LYOv
         VrDto4D0u6LbVcmLKyfYnrx2vCiAd8nVNehZp99gqXPgcqcBQdPczs+CVKok+RWC+CYY
         CaSqjiOiSnbAJJgPL/4wczyITiHFYx4NRVK8NayhQ2f5fOT7qhJEyZ6CAZY9kly1EzAA
         8fCJo8JUmhW05I4TLtXWg+CvoaVJLGP7uWM9b2XvRKgg2aDIrDeHTs0/FsxHv35Mz9fB
         zxuw==
X-Forwarded-Encrypted: i=1; AFNElJ/zPvghJk5oQcgXki2naVDd3LupUz+QuV62f0TF+WBS49j+SXHWHvLKelM4+w4LxgozpoWFnAJl+g==@kvack.org
X-Gm-Message-State: AOJu0YyzMsUbmHegzTJjsmBKbHLBw2K2YLU5Lo3oBWrNuWGlVX1TTi1Q
	lE3LfR9g/L2i8iP8eEQvJczOuxAlkd8G1svgp4TcylB3q1aLpAe/XPy0wwYKvG6FDSybFAP5hj4
	wlkpmWHkgTw5x/luB5NfqCdUjzGpeb73uLsMvb1Or/WbSlYaZaAra
X-Gm-Gg: AeBDiet/r6+3uzZ+B5JX5LhXlOiSTo7PXhGHmoU3uVV+VFsrP1xBaLAPvniEcMQokFJ
	BAOVEszDEZgiK7gPn+x7VIpBpKq56ns17AA85udLsp/IFDOcGcr+8518ZN4X9KqidosGJtQqdK/
	9KpbTskvfumYnj3i0+6b8/66rTMTECsIkzQ3wYHaa6mpu5UAoUJRZCn/Pj1IDL5t4QZdmILTIlC
	IrgFz5aKdvZUC5L0Sd1AKayf9/u6PrICYeNiQU16lq/N3GSKbk0/IgXwweThw6J4eXMMcPUwrM+
	NHrzY/SztxSQrPzUe2zzoXPlnI7oiPYDMXjBXLItFC6eP8hdpLEJTtuSATHHH7qeY/zPPRh0Nq3
	pAMHwMtpv3Fh5pYGBlmf43TRiMHptz47KXzmWTuqHGnhRVnuOM/txpxvE
X-Received: by 2002:a05:600c:348d:b0:48a:674d:e756 with SMTP id 5b1f17b1804b1-48a677401c7mr138303935e9.20.1777240076798;
        Sun, 26 Apr 2026 14:47:56 -0700 (PDT)
X-Received: by 2002:a05:600c:348d:b0:48a:674d:e756 with SMTP id 5b1f17b1804b1-48a677401c7mr138303755e9.20.1777240076353;
        Sun, 26 Apr 2026 14:47:56 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a525a0b1asm218200665e9.2.2026.04.26.14.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:47:55 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:47:52 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC v4 07/22] mm: use __GFP_ZERO in
 vma_alloc_zeroed_movable_folio
Message-ID: <5cfba90528b7abc1ebee68ac17efb6e3813fd916.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: orvR_f7EDzV8Fplx3oa64APNi2beY84qSBNa-F3ZCRA_1777240077
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1390E40010
X-Stat-Signature: tjo4bo3nwgfhaucand9wxcbmw8uxxsoq
X-Rspam-User: 
X-HE-Tag: 1777240079-13791
X-HE-Meta: U2FsdGVkX18Kf8mXnZtHy2c2okhtiF3Pbed7x3acndDYzfnTwDMHTr9yUinBhmzS7wilzHmDaau5qIKGfDOJiG4mHGVzjyE8ttP/3QvATWXS8nEZsJTGvB/zKvRVntlDUO+gPGj+S98rLPoRvla9XqVUqlNc/1ahfRsilvp3Td8gkISQrEvY3oXCqJyC4vdM4ZgNAqYxUIkDyTPEuHdyFTzq656W1sm1UMnJybek8XH2+wahs5hCVTJCo9UyRXgfmgg7kQcKBXVaCo3Ta+sb9x3cZlNQwtoJxLGZ6wJOIB4wm0hXOHrPVF9arwBZH3e10b6Kqr4vvqI/CtDNa1h3t+ghTjrKi7c4UCjiPPKbCnMx4RV10LnqYNtfy/ajd1JURqxXObu1ihna7wPc6hBbqabQx6kyDkBMGfXy6gcehACTrD98kawSjcg+SyZUVPWnkAtlKhJ1Qe9lvQLh8imqZJDSgKnJMmTqo/xMAShph2Oi+yMD8XrydPfAbn8G6M0OQNOCbRTwSTFluvWHor6ERoQVBRpI4CRW5C1hogfC7GIvoITySPmA0LyGxIt2gjx/6djs0ITFdevBmKpOe+hi83Ol1+mkGH0sQ2F8ylYi7Pkz66uFdcPyZi/LL6tz3dp70OFJacr7rTuuEFcswPaHTqWyOhM5NoblItMiFxui68roKr5bcr3o8nR7J5nIpcXNO6xTCuicaGVIXrNIWQqieVZeYctfBlxB6Temf2pChGJF5cgHVDzHJKEbHtOrfwfQIEA1SgDbgDDhc0QTBlNuhtFwHHvmDUxlvi5lQEzEf8MEKpIyC82UQ/nH8w9QhfTPg4JZIIZsk7Qr/NRERlg2plIGOnJNIrryV5rMqmjzBqe3LX3AVLm9rDoq9/81hm1WI/rO+6BFC+b6ivUL4sr28me10m/2u+J9p2JUe1nRoz9nBUbqOkqnUEc7QSHLwM8/O3PWYArlKQQoQISUB0S
 56SP5eNy
 VYmX3yx+IBJy/qWafmpjbG7xEWr9QkaWokmJFQ+yVuKfCMPhNMF/+nzkitp2T+7RngKOmtLYNyWoHh8X+vLUrLApVz7uvSz3RPMAJKKY4Ho/OkyQhzauzk5MHPBiq4g/JFVP9RjFkUoyi++Np5vDTX9YKDtS/scBxtf0ZY8BS9x8NMd8k1yr+1LFPcAfxJIxN1qyQFmtzerJD7GSYoKbnqsZOUBYjLh1z/tuT4msMW9lOfwyppFWzplhBo6BrjJSZgF1QHisWfaLeOUGKHDqVOlvk5f+Rgx2uWHlKFqudPN9dURebkm8e1bOfqF3SKPxQhRv2Gw4vNLOeW4pHvBdbq15XnxWZnILnEwVhWAMuLEpPp9e3dINht2SPCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that post_alloc_hook() handles cache-friendly user page
zeroing via folio_zero_user(), convert vma_alloc_zeroed_movable_folio()
to pass __GFP_ZERO instead of zeroing at the callsite.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/highmem.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d..ffa683f64f1d 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -320,13 +320,8 @@ static inline
 struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
-	struct folio *folio;
-
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
-	if (folio && user_alloc_needs_zeroing())
-		clear_user_highpage(&folio->page, vaddr);
-
-	return folio;
+	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
+			      0, vma, vaddr);
 }
 #endif
 
-- 
MST


