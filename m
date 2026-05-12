Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A28CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7E46B00BE; Tue, 12 May 2026 17:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88C96B00C0; Tue, 12 May 2026 17:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78506B00C1; Tue, 12 May 2026 17:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A75FA6B00BE
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:07:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3AA351405ED
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:05 +0000 (UTC)
X-FDA: 84760002810.10.7EA6679
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id C5BFC4000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LtYtIIDi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MrvzrHYJp3qtzaZog5kuCX8qehdfFd6F9etMXff3gHQ=;
	b=oM5LBkyvo0elEQatvqcBz4151AM+O0GmPUuYdmeenli9vwPoBvHXVUKCBQdQwklx7QgU+f
	ZcNN4vIZjEypoRm/hSTjm0cQOmm0FVm4Tbo/ZBMTTU5xUyxoXxYVpJpCA/nAeGqDzHuVOf
	9fst7BWLhURPTXtA60IjSOzykmrdHdo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620023; a=rsa-sha256;
	cv=none;
	b=aIUmVeMTDa6RP3IfXKSmVG2sDv5p6ZlTorkuIPZ9ixQ0agD8RkHB9L6jUdgeDBGEClL9Vq
	/h0BTCICUlq0s3sFxdeZwQ1Dyot5dfxdxrFIREaKLd0Vvn8d9LQA4pS3CZRiUMSKTTrai0
	dmvvOYwBNKsZ91qc6+qYcYSt0VVxWpQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LtYtIIDi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MrvzrHYJp3qtzaZog5kuCX8qehdfFd6F9etMXff3gHQ=;
	b=LtYtIIDib7iHZUhkzRwiep8gStQBfSm5oC5DU1iL0XgfEFe5B5VIZbVREkpTElgDG0QJNn
	Qpbu+vNfXfoTC9VOfWkdldgilViM9uSVJ116bKewh2+x6ggC+ibWRrUI95Wa/PKNpQEglK
	vy2/o9dHfbMlUBHOihuw6kCnRGTXZlA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-zZWrFn6rNAm-l2R5aOZZlA-1; Tue, 12 May 2026 17:07:00 -0400
X-MC-Unique: zZWrFn6rNAm-l2R5aOZZlA-1
X-Mimecast-MFC-AGG-ID: zZWrFn6rNAm-l2R5aOZZlA_1778620020
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43d7a5b9678so3946945f8f.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620019; x=1779224819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrvzrHYJp3qtzaZog5kuCX8qehdfFd6F9etMXff3gHQ=;
        b=Yu+vD9PcWIOTjbkunTSgKng+pSID/TJqATui5qvHf+q4d8lzcvHG1MTBTiFHnM1j1s
         fg1DKLHeaLeJweSLLrsRgfA1IjdyzhO9+BLaOSoIgYeqHFFuaLFuJt/fKjFCY3pRte/t
         /Dx/67eCzjOqoMD/duqWpGyR6eKPWoV3+bxNhhuuKo3UBIlS8P7NwkPPTuApgAVTjO+h
         ZjvfE7UvE70aLpukTmu3yvjEhHCBVjS68szBj5YLo5KioF9FpkO7ildK9HSEFZOrU8bi
         nAQs4AVsrpGKGmZWdsfs/k6Bo3ZqOfjDRtyRK7UUJ3khdoVxsPsS9vu/KWn6xaW4gTi5
         TJ3Q==
X-Forwarded-Encrypted: i=1; AFNElJ/Bn7mQzpQ4waZO2NR/9Wzrzd9u3i2577OcR41H5VT/1jKRHNiYfbHt18+ZNZPBORPBKacp7H1DDw==@kvack.org
X-Gm-Message-State: AOJu0YwuysfOOA7+PO550AoAcPnfgcf9uwHd59gu1Qphc+F5z5o7KUaB
	Qp7FF11biOBvvII+07qFRVC/F12WC3g3/lDROJT8AyiEGl9pUPIv3uW/EL79UoSxojCzYNYvGvP
	N+XhGLo2P4aIRF9P32TrX9tIX80f9iB41BFyELZBaZZnH0KCFqh7I
X-Gm-Gg: Acq92OHg3wPVIYjs+uGhIHjOwW3EV8cQQM8lb6mBzS2ypd/P3WzDTQIr/vQU1y1pZnL
	SEJLlNKpNhrV2uVnT9M5hvKJ3yI6Zq0xGfP11ngDCE2ivSlfXif/T2OYyYSoGwMd+5ItMlxfmsC
	tOQJhUOyddzKtimM/2hTXxA6KX5DVvNrjkCxXEfGSCtA12/9V1keSdmDD2E/gwcAUo0JJgrWgwI
	J2IqU/rvoKT6rssZ47AAj4BPm6RDmZmkGOeebFtb21MhQk/yHyxRXhn9Q1k+nWVvpISCzvEUTMn
	mkJjlh1CYxL+uD2KsIPZ+ieLYygUlDf3ivNVb6jUaEqbAlSDIrFdPICprwlXydlyF82RjjF3p0/
	2DY0eZb8duje+/LkI3fm/HWEnIsG80ul6P93eV/uL
X-Received: by 2002:a05:6000:2081:b0:454:86d:b4d2 with SMTP id ffacd0b85a97d-45c57536c87mr530474f8f.8.1778620019398;
        Tue, 12 May 2026 14:06:59 -0700 (PDT)
X-Received: by 2002:a05:6000:2081:b0:454:86d:b4d2 with SMTP id ffacd0b85a97d-45c57536c87mr530415f8f.8.1778620018807;
        Tue, 12 May 2026 14:06:58 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-454916df968sm36702334f8f.25.2026.05.12.14.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:06:58 -0700 (PDT)
Date: Tue, 12 May 2026 17:06:53 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v7 20/31] mm: page_reporting: add per-page zeroed bitmap for
 host feedback
Message-ID: <929bcbf8d4bdd51c038ec302e2db26d82d942ba9.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wP2NKz5ged5dhgGEBa_xH0PX08fAy-APDtGiFKnRtHA_1778620020
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: C5BFC4000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 7o6o6qg3ubsc8s3us65royb36g34g1j8
X-HE-Tag: 1778620022-421666
X-HE-Meta: U2FsdGVkX197+VRq3Z2V0BCSfdPu5j/poInDmVisHb+bLgeExbmjmc/DKMJNtGkmj0Bi3owP50WZ6EQfG8TzjC++EEJeHAXLb0MhEAayqyWD1YeiafARDx89KczTDpKMonb+c3CyLgCF9hriXHcQ6CyEvtJ7wwDy8XxIoZ7E/E7/ErxTXXMzwfzjpOR6m2Uf2WmR6NZxtbni6gmZTzxxMSc86xwkTr+FO65WhJ3u91h/qFM8kEIDkSUVxVm01S0MZs76HuPU2XrUeZXKetkxNalrvmrB/29Edq3JVUHqcwAUx6osPEK127pwsy+8XFCWybvqZnPlkqmZBTzsgALcdFj7rFoy/i9sC96H5u/QCEg7IYTMtC+EyoEkPrMsnE3qQHD6ckehuTx1AOPsHKbGoHq7bCVYaOsmkFWMj3NSlDZX2p0F0FnOKPm/5L4S67UkSKBXsxsRpnX7YQFOwfD+I7BENs00RCJaNVyfxNeHT3RVYuLgNkGmXmciPqTUgbi5iVOBMqOb9nblMJ4e/dQvGd7Rq0XdP9ZB9Y+eeMa9jzefrIYljqQ3O7tXxBehPdgoPKVqol739oUxd+/3TPve2N9eD+cSlgaGOqdngsJbIUqstsqoB1SRFQZ2NLoVISBbTk31+CL2c9hrkauJUSiRUAd/SYyFAOuZSpn/gX/iW5yI1kge01K+hGgYtAMz7Ftb/gyEaNs+31eCAfudZ3an9aLHKBJTXFCzZ27U6zbttZNe31NDR9M+EPcgFEeC9k2T0HfJqFTyEYbO7EYimU0ClIzynDWPXlA8SMLkPDPA4eF9CQvNS0PFwiaCIynijREQemN3W8R27UFJCus+YHxbO0DASY71F7y4D2fcWa/r8jhtOLMjRG1iIE/fQn7xEQ4yHxvrRSOHuzZ6FH85RU0dQSEDHUfcVIlQ2uUevdzm0pnBIW96t+aocT1rc7jikwfyy3E84dwIkb55PMIKfBZ
 ni+q2+JM
 11o9IKuyC4rWxC4aT9afQeWsCiZasIgI+gkslLi8ff2TGx+TRMGQT4ctm0jMPYcgc3NOmDz2/d4R8vAZ7clU8vcp02C/Bh9c+OH2Cgmuf5w3f15GNmcbgUSSDCQAPSwFOT98KDDRHx2dpxImZZKCgKBXc2imYQ5c/RrF/fRFEn6zcQqDWm8BZokx8xxiOkq0RNrsfDIsYVALUSD2vjil41CmQcMd6sa2ylt57Y2SKe+gE3aFSRuwuz7OQFmaN3tjbgrfHkkf1EJ8BVISFnwzza8ukipfnbFWxsFYF4OGgyesL/tT1+zMnelWVpnKXisuiqeq1QhnoTvpzjy+/PKHvDQZ1PmdQt4cdq7VpSCcICOm6rt5BRCOzgnNYdJlJKy1t+bJ3m9DGH7lxE8Xi5aS/jkfPtLXWF9IC11ejyzeGSbx0swjGdl/JHcTymv0gUzvFWRHb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The host may skip zeroing some reported pages (e.g., due to alignment
constraints or bounce buffer fallback in QEMU).  Currently, when
host_zeroes_pages is set, all reported pages are unconditionally
marked PG_zeroed - even ones the host did not actually zero.

Add a zeroed_bitmap to page_reporting_dev_info that the report()
callback can use to indicate which pages were actually zeroed.
The driver's report() callback is responsible for managing the
bitmap: zeroing it before sending pages to the host, then setting
bits for pages the host actually zeroed.

page_reporting_drain() checks the bitmap per-page in addition to the
global host_zeroes_pages flag.

No driver sets host_zeroes_pages yet, so the static key is
off and the bitmap is never read.  Behavior is unchanged.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/page_reporting.h | 7 +++++++
 mm/page_reporting.c            | 8 ++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index c331c6b36687..e2e6a487ddab 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -17,6 +17,13 @@ struct page_reporting_dev_info {
 	/* If true, host zeros reported pages on reclaim */
 	bool host_zeroes_pages;
 
+	/*
+	 * Per-page zeroed status, indexed by scatterlist position.
+	 * The driver's report() callback must clear the bitmap,
+	 * then set bits for pages that were actually zeroed.
+	 */
+	DECLARE_BITMAP(zeroed_bitmap, PAGE_REPORTING_CAPACITY);
+
 	/* work struct for processing reports */
 	struct delayed_work work;
 
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 37e4fce9eb38..6c957a9daeef 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -108,6 +108,7 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 		     struct scatterlist *sgl, unsigned int nents, bool reported)
 {
 	struct scatterlist *sg = sgl;
+	unsigned int i = 0;
 
 	/*
 	 * Drain the now reported pages back into their respective
@@ -122,7 +123,7 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 
 		/* If the pages were not reported due to error skip flagging */
 		if (!reported)
-			continue;
+			goto next;
 
 		/*
 		 * If page was not commingled with another page we can
@@ -133,9 +134,12 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 		 */
 		if (PageBuddy(page) && buddy_order(page) == order) {
 			__SetPageReported(page);
-			if (page_reporting_host_zeroes_pages())
+			if (page_reporting_host_zeroes_pages() &&
+			    test_bit(i, prdev->zeroed_bitmap))
 				__SetPageZeroed(page);
 		}
+next:
+		i++;
 	} while ((sg = sg_next(sg)));
 
 	/* reinitialize scatterlist now that it is empty */
-- 
MST


