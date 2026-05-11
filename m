Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E324CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002606B00F4; Mon, 11 May 2026 05:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C996B00F6; Mon, 11 May 2026 05:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32726B00F7; Mon, 11 May 2026 05:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D17D86B00F4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:03:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A08DA0657
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:42 +0000 (UTC)
X-FDA: 84754551084.05.88DD641
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 55562C0002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="L//YqEVs";
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MrvzrHYJp3qtzaZog5kuCX8qehdfFd6F9etMXff3gHQ=;
	b=7Fjb6+x7fnWYVCSvAGscoB8K1/kaW9Vqat+srY/0wLIgAcBbdCxuEImRJHnMdhQvoztZPL
	X0qXHqbNT9ja8FCN+X9hMyUpPQas70QZF8GHwpmQMib97rvdKYY5z1QSFYK/F8KmXtVq19
	AqpNY2s+nMNo9ZZvVckkFEP0icYrnkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490220; a=rsa-sha256;
	cv=none;
	b=6MIwnbtpOpe3cT32LFibEa+CvxQGTdbwiyCExqB+soDIUY4ycsX+bF6/XETBi262g7VkZx
	+0u9Kj6XX12G/8UIOkB0WjmdQ0YSuBfCzH68UWVrqeNMlTS1IecEnS0yEq6FzXm2W8+1Fs
	a+JlxhEhld/tWvb4MB6pxMXncsBgWpE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="L//YqEVs";
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MrvzrHYJp3qtzaZog5kuCX8qehdfFd6F9etMXff3gHQ=;
	b=L//YqEVsExN0njxRNIjq+sXrrFhZQj2Duxe/pAGvbk1FalXCH9xuq6rp99Qe0isRCaF4/G
	cTcZNiWetiHfqZPBgbVIPcxnReWn3yKY9wNpY8cf8uzLpz18g6tuWFduDan6xJD/i8xGPh
	HNQJTMd5PdRuEHREwbj9S4uIJf0E6+A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-0nlDTFSwOWulJJm4LdvG-Q-1; Mon, 11 May 2026 05:03:37 -0400
X-MC-Unique: 0nlDTFSwOWulJJm4LdvG-Q-1
X-Mimecast-MFC-AGG-ID: 0nlDTFSwOWulJJm4LdvG-Q_1778490216
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-458e7004f63so780024f8f.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:03:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490216; x=1779095016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrvzrHYJp3qtzaZog5kuCX8qehdfFd6F9etMXff3gHQ=;
        b=mYrfH5Mfo0YFfq6aPyX6GUgZ9ZgRS1YMoHZjW2B2eNfpegnJtaBc+GBTkyP6ehNFF9
         csKsrv1ymX07ktdKNdWvJk+UnlC98Pp6g2TA0fM49E3X1iU4EVP+MNamJi847joYGeLA
         xUGHfCe6KKH/y3xXGhjFw8PXQtB3GOaJbONc9+G4PjDNIJWFQOYN5jHadhkmFD/Y3A01
         ECEYdI+7PboM3tytOaKpIqJbFeJutD4k7y1zj2sHEuTLVdmCfZW7KMRw2VnMAtfAL2AD
         QuVfd0JhERHYfMCSL7VlbT0fKgy4TVPvoNjGPG4EnIM0stJkaK3PDdv5JHU6O2Kt7JlA
         M/xA==
X-Forwarded-Encrypted: i=1; AFNElJ+Z0guSBGsdJrbI0VXVODCUQw7YFNF99U2zqhDowDWgHp8L8RCJmZoaxho9RT3FDg4fOPjDQXxQdQ==@kvack.org
X-Gm-Message-State: AOJu0YykHuoZAVoh9I+j/D+aEdh2sDCWygNsfrK8As2+2RbOULM0P4SW
	LY9blQ6Om/hq0XV9BmaRtTnn58c8ko9vm9MfYWPMhC/012IyNRk12QOqXbJFHh4OaI10ZgGsN3u
	wsk6JcZ6GSzXcTP+nnoRtVhOsEakhO1pW1XqOgbgH+BxBhpeIkN0M
X-Gm-Gg: Acq92OHjTninh7A4ynIzNUtzZRLkS4sKgyIAa9xwbmXCzmW1mMtcWDxAKzcKfOJWydv
	V9QiUeBp8Nx2j7yxLrSDRAR5jJNTchkWyB7/Kk7PjrktZYXHhOcimK8eZzFS2ZzmhFtAjq/Bs+4
	sl0Yazp66afQt/SLhHoCrfl71cOLWJZVG7ZRrVa1DTpd7lNlN8/O51K3ztWkVAAPDKlm94jLxzt
	asSE2BHgeDIbnoPb3/rqENmKGtlJO02Vpi0zCoO8o0EMoc018TXQJ7c+9ZQvrHLMEkoisYFOW1o
	YsivXo5HknwHimgZf6FT6GTAkw1qtMpjbBEZtrc3mEHkoFpOp7htP4uIiFzj5gb/MFhPcXCc/7A
	HT3h3z6MDKpJRoXkVFKfWBYVLADniag1UjCMPFmEH
X-Received: by 2002:a05:600c:4ba6:b0:488:a882:c7 with SMTP id 5b1f17b1804b1-48e51f4bab4mr214595805e9.25.1778490216146;
        Mon, 11 May 2026 02:03:36 -0700 (PDT)
X-Received: by 2002:a05:600c:4ba6:b0:488:a882:c7 with SMTP id 5b1f17b1804b1-48e51f4bab4mr214595015e9.25.1778490215419;
        Mon, 11 May 2026 02:03:35 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6b071sm23711514f8f.14.2026.05.11.02.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:03:35 -0700 (PDT)
Date: Mon, 11 May 2026 05:03:30 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH resend v6 19/30] mm: page_reporting: add per-page zeroed
 bitmap for host feedback
Message-ID: <bdd094ecd33f2afd6103f53e1d9cfb1cba0f1496.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KSk-uuifPCRMday4c_SSxUwQQ3WFGkLUBwQbl8jGhNA_1778490216
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 55562C0002
X-Stat-Signature: ckgsne7qpr8t41irpwo76778gpa1hopm
X-Rspam-User: 
X-HE-Tag: 1778490220-313238
X-HE-Meta: U2FsdGVkX1/cht1OwDVkhn7FFXwhL3k6Z2B6Cw+KewE5MWCEFpjrnGpKBq2iI/jn7m7u5jXGLvX35mMcI8a4u/+LKwazj57AQhp2UdHMo0oZ1yDVnHGbBmsOR0QHEh1CaJnLCetOAQ87q1ntYyTNVg7V4/QdIQvPjGTEwf3WfSGzNQSqeMuhNmI6ZJtra+a79t2ylWgfDo53NBgXR9O63taJHIDEdxxKPwwpXN/ubdYjCGoiSdihz4cFK2nr+vOzwEJdwyegi25tqKkXZ6EDSwzDd3AajFJaY3ghwvrhyZ/JkHftw5hnt7qNpSzX+oZ8EcFDDkQRAj90u2kj0BQLPflCDpV1JYRMGxkMCPjCNFaXpIynaHYvOqWlx9nlaRYtOJG9H68NNS1extY9YzkL21mgsZn59Tn+BGryROX2NddoLLRAd4h+ANrS5H9ePzAf2P+Ik0wdyFJUYiMsAxbHmmeyyNqxu/D0keSgOSxoFaU9pmAZhlp/46CSEujdeTpdBinqfXzd1NENzAsHEEXmaeAz8FBqLarLtK4l28w6ltAURurRfojMuStEsHLWkaxfgEtmbtRbVNoe6vlpFr+sQIeZftoSf5uzUvNuxUR28idEdFCZN21vK419N0DEKl4/i04Kv7qTHqITyhx5t+olcS93PEIMuMB0qhVq3eFVmwhPdTaskdT5YN9WvzUvaxdsVV74QQc8y0WEta5W3y5SWu6oYDKdseulcQzlC0C+seszSISyh/aTZBpx8rWteJgu+EJs4uA7EiQMOmMWph3jhLOFdla16UstLRvyC58hg4mXxBKbsP9SvnTukDRz/Mszyyx9EnKDq0GrmdBlK5wBxQdXzAy6ikpR7HLSwBgsWkmQFGKT2/pCqqEvuPlubrI50TVnLdfFlswiFeTZkOXQqRpeJMayMb3FiNEo0ZLvqqq1LUtjDKhM9rtNRcAjlnAXRhbH/XDPLvKE6ebcQXg
 JB6ppVzy
 v6Ztte4L58kWaWEknrgFqc1ajUnJSoxKgzxBRmzKUUHwg84VxrvbWn9+nc2njfLFBeagWX/k0h6x5FxoMmdcLFak9gJ/CmxKnvfSHmqxy8F8tOgQUY1PrMtEbexr920cmqNnaVfOKnW1wUF436d622q2iAbx9JfKOkSJ52MP+CUuAZiZr67dxmNSh3vyX9HNRGgyyfKZgJFJEyHSmpD/8d7rOPsbnGXbmbtddr0sJd+VGmC5Ne9b9pOEokLBPz+yz5UZk7pv6ZQ7ssxcoP26auAnCbbn1m5fKluI+GEiccNeLJIdGaqVo0/VtRtVby27zYuRJxKmXf05vzSkEA+b2PBqR0uMxoMU/0wJhwOHqtrxuihFUZqRB95aG4xogb/K0L6okVH4SdNDBgH9fia1LSv/6WPgu1aS9nuqNmRQ1RtHmVZfSx9rcaaseGMtyU+ZYeq4g
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


