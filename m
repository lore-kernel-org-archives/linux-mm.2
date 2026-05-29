Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D3FCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAEC26B0107; Fri, 29 May 2026 11:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86BE6B0108; Fri, 29 May 2026 11:26:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D646B0109; Fri, 29 May 2026 11:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C58E66B0107
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:26:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86D9940181
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:26:06 +0000 (UTC)
X-FDA: 84820833132.20.8AB5280
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1058610000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:26:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KzEjJAAC;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+sAoCfzYzafV/AuzgTCD2HmceB0XqeceJe9byk3cHc=;
	b=d8cVDt68FPE3tOaSLJRg/uB+6EvobUUkoszWIkC/56yf/ODqukSfd7AzV1KbgL91Ukoeh0
	tqvIkHZ0sN/HXb26egmHS/HXTpW5ovg7tX6uJLJaMhRXMEa+rNoHTYjGVkJbX2aairMoBA
	tsiw/vBanm4KmuiQ/KRCgUy8OEWcWX8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KzEjJAAC;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068364; a=rsa-sha256;
	cv=none;
	b=01LSnQBxG8+aUdzkTbXdjlh+2sJh2tFFsBVO4WAutXNCKrHeGmq8bY7frKFs0EWe21xy2D
	nEhYbTPBKO3E3agOUkDrIiFJax1bf14adKEd6JdI7xOSPK3KMDI/sfrF5Ewj5HFLoujekJ
	N16LB8QGEb6LBbZs5Zsv/xOQ4BlkoVc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A+sAoCfzYzafV/AuzgTCD2HmceB0XqeceJe9byk3cHc=;
	b=KzEjJAACuxHAULTWm4w13QaFVZF0EGqjaTUbAToh+rWaxJMPwz4glzQ4ZGfltcmWRLbg/3
	QoNHi0o9bhu87b/PWkfVUQGLG1JRRwL7dULknZc/AXWtOeRq6T0Bu/zISV4aPFj1GoFDwP
	m2igU1lf9SfBoOnzyZIwFKv/L+EgAYE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-WLFnslcFNhOaZbeiacKVxQ-1; Fri, 29 May 2026 11:24:55 -0400
X-MC-Unique: WLFnslcFNhOaZbeiacKVxQ-1
X-Mimecast-MFC-AGG-ID: WLFnslcFNhOaZbeiacKVxQ_1780068294
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49048e21ea7so39531865e9.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:24:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068294; x=1780673094;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A+sAoCfzYzafV/AuzgTCD2HmceB0XqeceJe9byk3cHc=;
        b=gZiYvLUE+JcS+PAtjC6ILTHO/zG8kNfrNrZPk0nAjcITj9X+n2N0pe9A84DdN30cSf
         uQg/JCSBwoXzLoMH5NZSKwU/Fi5M8LqLfG5wmdYZCbtOxepWkEXXF7hnozZRkRlxzExY
         Sdna9XPN2+7krrOdy6CGT2HiRAL+m/oAeFLkFLdgyW5sxkjJMGLkAcqc1PKsxaHHxFid
         nQSDDuzj2zBLfv+rA81na/uIwCBQwclwk6w3/Bp36ltj2Ll7TJHJFVleKGnRhLuQvxd7
         lAi2KGzFux6+IMQ7kDOUNc0qiTDry0ZLCjIekNOtBc606qcsqZ11XVZ7YvPGaCr+MZ8T
         F8Uw==
X-Forwarded-Encrypted: i=1; AFNElJ+ixjV+tYZD+Au3mYr/K0NAX0M7O+o1TdN4oWMr9SVrholXseF3v8bdA+iq/SDGjePuiwAuhvakJg==@kvack.org
X-Gm-Message-State: AOJu0Yw3VRhycdKIcvQqKGPxfeE9tOC8Syrg0l20RPRqlvp3PmNnp4Oh
	129R8QRUfPPrwX+W6m1O++41uZLp+6N5L+HaLyqbnx7CeqK484j+MixPhAIFe2rGmPluZd4kZeu
	2L3SSscL4f2C8igx6A98RJ3ZxalavpOkk4dMh14RlNs3rX3WCo1J+
X-Gm-Gg: Acq92OGT4v7fuzic7mc/dTuriYEwBKZVwenhbu/iw2Zkltyjw2MXrP5mNkfqGnpRM6A
	5C5O6KWpzUVAkjTxiUq1OysBDkVugSn4qRICF/ais/zWelz1ENnacO9EYn5QCcnSE60Xrn1CGVz
	uvn99Z0L6bJPvbX8iIwKWJKR91VWdUvXvyGK3T4uWeg9i6tj2PKI3D8CVmfApzCqdyqshzst4in
	ZwrpyttUs6KN+7FX/N1Ukw05dwsXCA8je1/4J38GyKZXlCwoDAi/Vi5XZNcRK04lZriYlRo3bba
	N/q2Z8F2+y96DO9wtu2w8xOCaJjY6hES5b7P7cLwAd7ldB7/t3kllthFn2u2S7NPE19oRWUfVTm
	J4356iTuLjSIg07ZZUqkXRh3Jey9RSRyKGyN8aLjTtFxX/ytWkxiKHA==
X-Received: by 2002:a05:600c:1c1b:b0:48f:e230:29f4 with SMTP id 5b1f17b1804b1-4909c639d91mr48523105e9.15.1780068294235;
        Fri, 29 May 2026 08:24:54 -0700 (PDT)
X-Received: by 2002:a05:600c:1c1b:b0:48f:e230:29f4 with SMTP id 5b1f17b1804b1-4909c639d91mr48522645e9.15.1780068293714;
        Fri, 29 May 2026 08:24:53 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909ca6575csm82033265e9.4.2026.05.29.08.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:24:53 -0700 (PDT)
Date: Fri, 29 May 2026 11:24:48 -0400
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
Subject: [PATCH v9 29/37] mm: page_reporting: add flush parameter with page
 budget
Message-ID: <b40a2db51c2ac3a69219c467389165a0a53d9ac4.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HtZ_vr7ohD0iUKF1YQIoImMuM1JpAnOai5Kc_V04Mts_1780068294
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: sh65ubwgksefnsnq7bcsfinc16txi1yy
X-Rspamd-Queue-Id: 1058610000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780068363-988472
X-HE-Meta: U2FsdGVkX1+bqLwNdRRWJzEEwp9yRiRWv/Ph6/g5iAGvHEMfxZFCEh3BeeBIvld+4HF48aom5AWCt06xf+89Ffm3engBxta9hukcbQsYDIfDFCvdBKHZ3Fokta8MrJln0Bl7PANquLTOGGWRSJ5fBxjoB8zBNadxZFfVgvNSALT0BILWOJeJt1bRmSvXBPwulhA0K4haYqQ01ypAb/tzUFtBosW4+dNlZ0wcMcUxUbvYkw8XAxWWPDqNNDL8n81UFJAUVUEC2WO9Dfadxr0+9N/hCvxUK23bCaQopGkOP3CE8ajwNfaXTfcGNNQ/cypGCW9gBlegEE4bgb8X2A3O+tyx+yl6UnvJ2UjSlAwnkDVdn2XZpRYTm77oO7eQq0Bc6p4VZv2PAFase14GVF7Oo5mRrcl/RKmMXrzjSR6CvSyJXKYuKG1H0lTBo+A4orMXa7AU7YrSe36J3ZANb2nM+AQefGDh7rJ65MQxYfHFpoE9CLaAg1y2el/BFjUXncVbZiPvkMoo4CCYnok1zeM8rpuZJXdY+MWut7/3IUm7skrvuKI5ZgGi6nOIHQ8oTX7QFGRvaXJZ01YlIPPqphUipZY7A0yv20OG0bTk0uxKXJ/EdT9M+ZuftbouGRo3BUA2CDov6m9C8VNqsTHi3bRNElI9hunO10H0K+MCc5FrVld+qTKPl1oE4S864kEVsat3F85oB7c31o1Xi9IXtdIHezcjVDX4T4LITd2aUT1qIiOPbF5mQDMw7HZFhF8rHTC9DIpsaJQ4mgT1VxKlD2u0DjDjOl7Vf+HNaUbNP+Fyj12JgDYuwOZefkIC0r2wV4q3MYR3KgfWhOrb0IUCLPG6WdXWAH6mAp6osNBDJ4MOAcHqWZ/Eh+D/hpo0IDA1lzty3PD+Wt086g+JCdNigtxBDVdz/b/+/Wha8Bc2LRZEMeQ7Bqcc53jkc5ksZW6Ti6IJssWys9JtR/8HOsk0ZBL
 GKzBJNOj
 fUNE2flt5ugDwPib/XwNZCqcYTbjuc61tzlTa7DKmY9Tw2a6Cmd4nDkTv1G13zxnS3zdn5VLgAJNWRR1IRsvC3gO/NjWrv7gbzIAspQrmMhX1tYik+fQ20wCh755J9ktUPLsvjdYwVMlZXKYqj33TmzIVSggsx0s3QvLlu4zTKVU9P0IU3XpTeKhRZ23AWN8WmiHV2odVKnQAVUwHb3ZL7kCEOwmyibdbRDd5b0aiZ2UVAhHLPBIqVOn2O1TYIUgT0zzD5JBE5GsL3MKIDtzFjtnkLJpMVuhdmC83EqekrgAKBBHU0nXGdgwALLvhD5cQx36sKZ7ReK07ZIE92oX9O93Dcb+OuLz5JAuv+gHiX34iqpQuZ5WtXSx7U9n93eqRpcyLJMs+zb2TLc6tbs5MgLuErQDRtXLPOZSaNS8c+r7cJ2VoOOHATgunY+q1vdQMwQLL
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
index f68c79e57427..3f584f538c68 100644
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


