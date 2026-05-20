Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D3EFCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 827186B00CA; Wed, 20 May 2026 18:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FD736B00CC; Wed, 20 May 2026 18:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714756B00CD; Wed, 20 May 2026 18:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6050E6B00CA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:23:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FAED1C0317
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:08 +0000 (UTC)
X-FDA: 84789224898.15.4A05A66
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id B640C1C0007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ENk/1yk5";
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUKKOK0OmR1aDSnh65Nr9KPiL6ZvxY2ICpkCGdvKy4Q=;
	b=JeLwNJ0qxdb+OK1F3INggQ+MBk1/1RxUYYcabLyIrh5MuxDRNy/5a36RRFeBcdyhJE2XcD
	ixLhAaAmJ+vUf+zl3aXeqaUF3dfdcHtilYExdBZJ96kytr2UV85JHrMh3Rcbj5B75w5K7S
	U9OIL707wPHHoVHOHMBcSJwd+X9IH+c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ENk/1yk5";
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315786; a=rsa-sha256;
	cv=none;
	b=yR5jM72EFPxhopUyvvsLOki4BcZPsjMlb6QsxBLXr6hGclk00Hsh2qiYC+hU3sFFZQNBiX
	j8i13dVf0JQ20VrawDVMaYyYuZW3x6+Ds+2Ic/SGbn2RfBvD6QFF71BLRQhE4G2tyMCq+K
	WrHXO/ADcTUKvcoQ2DnhggH5HnhMzAo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uUKKOK0OmR1aDSnh65Nr9KPiL6ZvxY2ICpkCGdvKy4Q=;
	b=ENk/1yk5P99njixRffDCjn0XdiR0CF43ilmvXY8mf/0eWMjPh4RHzdVnzvg56u58yTjxj9
	vCSyO9d+duqX1JVxHwgXI6m2OKZ2hWttmTp1gfnxXxvvOKkyvEDCN8YrHmyyqmT4p9HBYe
	HMd+ksE/4VLTRIQMBoqsO5Kbvaem+t0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-yVHtOsjmPm2W9SMgXpNCeA-1; Wed, 20 May 2026 18:23:04 -0400
X-MC-Unique: yVHtOsjmPm2W9SMgXpNCeA-1
X-Mimecast-MFC-AGG-ID: yVHtOsjmPm2W9SMgXpNCeA_1779315783
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48fd396daedso33655895e9.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315783; x=1779920583;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uUKKOK0OmR1aDSnh65Nr9KPiL6ZvxY2ICpkCGdvKy4Q=;
        b=Jb53PrkVLJTpmMgOofee7qR3fIh2xUkiRtP1ozY1xSFGsXGYoyW6rbjJUDHAPzauS/
         eqhW8vI3uLMtv4qOMyEEe1MrsImgSTxAGoVTy7uc8/kGDlBh98OUkmZneHfDJ1TPzf5W
         2rOGxwIt3VUyS0MCAQZVkan8r54wlzGHX9aLHhK1t6QiHUAFgDrDdKPb3ghPnhZTDFoW
         HrSFZSsM4r1yZdB2hXKwDyreERLLsYKJhu0r05WXQ+eD8JB2EZt2Q1diJs8wMezKrR5s
         Joglb2mwoUl1TttCt3UYK15fmWvk/viVmsHGUZrudYFBqeWExc9voSE2C2RXi7dunJGW
         GL8g==
X-Forwarded-Encrypted: i=1; AFNElJ/NhEhiTVnhuN2Ltd47OMlvZpPhf+oFjjaLuHC9f2b4/VwbqxdB9T6mPTncoEv8WzkZi4k1p1XSVg==@kvack.org
X-Gm-Message-State: AOJu0YxMRj++gyQ5SVFIo/vXMnC7FwynGb7kCWtt0xOEBsAG+ObVpLqC
	c7KWEhDoXDWZMUU4QT+9S/0RmlwV+PMIJ4evv0sW6rPY9NVU5q/bQkgM5CxPszDpbrEsgsUH4jR
	BNdMuOmOIxJINrctb+AksIxTZItwLUP6o2qnekbRkr6y3eMwDuVE5
X-Gm-Gg: Acq92OG3rwAwoTgoVfspZoaKLs9jn6Omf2470B4OQWxVB7WpLXOKzQ4Smixv3UP1vqh
	GFVJAEasbflCNTpQitFx2T0gxOl80LqV+7UGwCYbodyNE33L11zIGwf9VLosTSs+8A6I44xZJLi
	Gecm6V4hoFuNgdrfPeuDtlEORQ4S/mwojwU8taPcRc5QkFsP0O+OrBCQ3vVY5oPKtYNY8HZGfs3
	LiuZeAbldd6i1vGAYQkCUeS+FjRlFC6OaPaN+hUMfud65RaAiFESkL4PXZoJY3wVdLdoXeOqCtA
	eUxQmzOX7ZIhjaWCTCM8ANa4MalhwcJc3zblDMnOKRdkEyLPDihEJBgIY12E63F/IeQuJbWfrBX
	GHLnTjz6jeVXgyaC/jW3+sfAh99mw1Lstu3VX0/kTR9Y=
X-Received: by 2002:a05:600c:31a9:b0:48f:e6de:1cba with SMTP id 5b1f17b1804b1-49036089574mr1978895e9.17.1779315782958;
        Wed, 20 May 2026 15:23:02 -0700 (PDT)
X-Received: by 2002:a05:600c:31a9:b0:48f:e6de:1cba with SMTP id 5b1f17b1804b1-49036089574mr1978505e9.17.1779315782397;
        Wed, 20 May 2026 15:23:02 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d3e9cbsm16828155e9.4.2026.05.20.15.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:23:01 -0700 (PDT)
Date: Wed, 20 May 2026 18:22:57 -0400
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
Subject: [PATCH v8 29/37] mm: page_reporting: add flush parameter with page
 budget
Message-ID: <842171d4147bb97a96b87386772a4ee2f058fabe.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 52T5_kNY3MAW5BhIoCLlmmO_53LtbvoIUKEiev2AVnE_1779315783
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 9gcud34cnw4tbxikq9hp7s3hw1jy9a87
X-Rspamd-Queue-Id: B640C1C0007
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779315786-539024
X-HE-Meta: U2FsdGVkX19aI6h/VUWeZpjoiOJcMxgjxSiz33mLoyw3xlVGqneqp1oqCoVNUy1PR/AY/x9yv8vxfPfz3w6eiIuvniKVBvEjp9IBgZ43O2zrXyfvdAZOuZbvhg2DGuD2z/ML0Td04I1T+z4d65+B+OT58+SlJCcd85g1X/1NDoc/RdmicwcLjzuztWTAlWTvcdaYcg2OVPMCIKG5YiesKLAziF2OnWoIbOvi6d2weG6O2sA52qKgLCsKff5P8Oh5xJsTPYdqW8z9d2dZ63QzPwe3OkCaKk6gvT5O0N9dzNPuKwjsItaR8Fm1ObWO4FV99pCbLn7fpoz8Z+abQiJnhTK2Fyzhp5dNnGjqbHkLSxGjv0Fs1PcX1NnGYZ5ukXgUih8OjxJXJxsnk6kr4K4XXn6obThZ9Ln/S4lG8HQ0KMRvQrrO+KjFk6KAx5eP8e1DRD0j64A6TRSrpdtnH5sZ10+8O5T1l/F+emUiY0GFTq69BOd8o2yj9G2nrCDbwPVGDaetEldVaLfTQn5BepXeQcyL2oxlkbKCVq/MywKiF10ttD5JBcnciTVAA3+Hgv7AFn0cPbGx50GXDYqZ8BT1WbYp5lrAAzInyjYwfGzxx3w/2Do4bna4oFtxv9TokoDYdIRTt41yt08qc6KJ94+ddWzCYqt553n1cpwq+ldMWVUK+AyeaiZ8+pSK0+uTcgzyLXDDPq4vR0HPsOJL6/GrfA3VQZEYsd/xTDXzDUlhRBqrdV43MapGIwGPi/WrIm3N+Gm0jQXiYgXnO2v16a9FRPRBx2LjzjgHSgkBjFahK05FVP1wRVAzRVS5FNGp/C0CSWD3aIVAWqpxAZQHNuFWmtYgc7Ro0TvZWqF4LcPkXkjbNFxgdjuP9ql1b1TfZ007ykOFrKZQoAnL2He5gbui8KqLAHWKw9qY4XCsZuhg9+0Ag/9dg2+lGy1p1WNMEJ98hfBK4aTtHazGGoTH3np
 V9+QhavA
 BUVwwsE+JswQGGFzUa9/PixCCruqoSYvm6411zDo+ajkc/aGsADg85mZSswXSseDoW24OAjjHueXIMgBNNo/8lariuGKCCkYUXlI+ZFraEoFOTBVsRkR66BUH9ZmDDuMEuo5yQxPxL5ycsCvKmrgL3tUBm+4VY9AajpMbFwFUlPdHwET/dtIVYPalGL6LlE4cO5RF+bE9txmaJrmqFHygsUj/U37zgKitBmcNHCBvpTagtpC33JD7pPNNqBUExstD6ddDLU1thG83lmMNlqS9opyjr7Ov/Z4g3T3oyAnJoXKroVNWec4Hn2NRiebUHaBsvoO/KfESesQ/m7WZHN6YFsUCn/0Q85dVyQ/4mQrgC0McGT+aEL5myd2LfutPhZYwFN+37vXmcHgGUuHlTAXa2ZQgh3kLGBxSBdPs4NoO5kgc77oHHsDCPlHX7oZ+M7XZMKTl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a write-only module parameter 'flush' that triggers immediate
page reporting.  The value specifies a page budget: at least
this many pages (at page_reporting_order) will be reported,
or all unreported pages if fewer remain.  The actual number
reported may exceed the budget since each reporting pass
processes a full cycle across all zones.

This is helpful when there is a lot of memory freed quickly,
and a single cycle may not process all free pages due to
internal budget limits.

  echo 512 > /sys/module/page_reporting/parameters/flush

Note: the set callback runs under kernel param_lock,
so writing this parameter blocks other built-in parameter
writes until the flush loop completes.  This is acceptable
for a privileged debug/test parameter.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_reporting.c | 54 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 691a9e66aa5b..8b278a494ea5 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -358,6 +358,60 @@ static void page_reporting_process(struct work_struct *work)
 static DEFINE_MUTEX(page_reporting_mutex);
 DEFINE_STATIC_KEY_FALSE(page_reporting_enabled);
 
+static int page_reporting_flush_set(const char *val,
+				    const struct kernel_param *kp)
+{
+	struct page_reporting_dev_info *prdev;
+	unsigned int budget;
+	int err;
+
+	err = kstrtouint(val, 0, &budget);
+	if (err)
+		return err;
+	if (!budget)
+		return 0;
+
+	mutex_lock(&page_reporting_mutex);
+	prdev = rcu_dereference_protected(pr_dev_info,
+				lockdep_is_held(&page_reporting_mutex));
+	if (prdev) {
+		unsigned int reported;
+		bool interrupted = false;
+
+		for (reported = 0; reported < budget;
+		     reported += min(prdev->capacity, budget - reported)) {
+			/*
+			 * First flush completes any previously scheduled
+			 * reporting work.  Then request a new reporting
+			 * cycle and flush again to execute it.
+			 */
+			flush_delayed_work(&prdev->work);
+			__page_reporting_request(prdev);
+			flush_delayed_work(&prdev->work);
+			if (atomic_read(&prdev->state) == PAGE_REPORTING_IDLE)
+				break;
+			if (signal_pending(current)) {
+				interrupted = true;
+				break;
+			}
+		}
+		if (interrupted) {
+			mutex_unlock(&page_reporting_mutex);
+			return -EINTR;
+		}
+	}
+	mutex_unlock(&page_reporting_mutex);
+	return 0;
+}
+
+static const struct kernel_param_ops flush_ops = {
+	.set = page_reporting_flush_set,
+	.get = param_get_uint,
+};
+static unsigned int page_reporting_flush;
+module_param_cb(flush, &flush_ops, &page_reporting_flush, 0200);
+MODULE_PARM_DESC(flush, "Report at least N pages at page_reporting_order, or until all reported");
+
 int page_reporting_register(struct page_reporting_dev_info *prdev)
 {
 	int err = 0;
-- 
MST


