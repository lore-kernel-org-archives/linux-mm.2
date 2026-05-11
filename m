Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E29CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532F66B00FF; Mon, 11 May 2026 05:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A4E6B0100; Mon, 11 May 2026 05:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F92D6B0101; Mon, 11 May 2026 05:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B97C6B00FF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:04:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA1D3A0645
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:03 +0000 (UTC)
X-FDA: 84754551966.27.0AC3812
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id AC0F540005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zh8DoXtC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuTcBXOBEgIcnIT/SeHSDJKAZ2vX9yg2mawsRplntmg=;
	b=aD1LoBEaTSWiAX2dp7Oj66jhk2YSNHWkV+WMK6Vo6sldwTlNj8RcVQjL5lYYBtLGwMtTrT
	s+qJKslhSqtoDu2fzuEaDAWGdtqeyCaKaYremMvKfV/f7UzpOMzTZxzNmKPbWkpFvHCr/F
	DM1nATk2+vRQQ0HuHOoajzHm3X8efzk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490241; a=rsa-sha256;
	cv=none;
	b=QBlg+Vbf+s0gs+G1V2PIzWnDN72xcvpqexHD4d5+Kp1f/ffkK1ueJoSIt7NPkeah2+FX9S
	YK68sG5fy04o/2aSG8C4wNtu9KmQNDwNrAJ87pV48wddVj6d8BS4ZHmTgdQqhVQsXqw8OJ
	nto6kTMcIzQEkf3Z7ai6JuVlSbw7gpM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zh8DoXtC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RuTcBXOBEgIcnIT/SeHSDJKAZ2vX9yg2mawsRplntmg=;
	b=Zh8DoXtC/jRvrfbtlKO13LO014yMiZEayKUUBEP0Ng3ZIqaUiMyrU92WFfc/e1WUFEV+9o
	QCY3UPzsY16Xt+1NfBFdOViuKCcph7hx8I024TWr3EuzWro2me0NYfDj55QQkmBH+FYyn5
	X8NGMWBnH1kSvVRxAhq4OG5W+u0u3EI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-Qf9ozYn2PIuoqLWcX1aozw-1; Mon, 11 May 2026 05:04:00 -0400
X-MC-Unique: Qf9ozYn2PIuoqLWcX1aozw-1
X-Mimecast-MFC-AGG-ID: Qf9ozYn2PIuoqLWcX1aozw_1778490239
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso2611030f8f.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:03:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490239; x=1779095039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RuTcBXOBEgIcnIT/SeHSDJKAZ2vX9yg2mawsRplntmg=;
        b=eNGDpZiOSjt5xCxzyCKWgyqHR8t+q+pnZ3xOw7vXWiTpTVFzTwKAjviZLrdAzLEDCg
         wTBBLuqgtrJYnj7gbh3VGHm9Rqbwih99DqUqlg060ialGtvBPFa11e8lr4G2+opJ6PbR
         H4qTrd8rQekS2Qi0SFE882EoKkA2fU839NspOV1Gkowr0bFsYqqzOFAflfzZnjEtXvUU
         l+nOSubpUUGvHD8HOS1bZwg/bdNF+x3MYyh6nh3QVUQY58VgghQeXwvTC/W+3PsCI5mD
         Q8SscKjCCvKLD2SOBwuwUTaxXnwkVPLY1tN8Rxl2/hJeFBwDB0167qs6VRlD+JD2bdCM
         Wr4g==
X-Forwarded-Encrypted: i=1; AFNElJ/4Yh/doBTeM5PN44+dVcoAtXi+QShs1KwwED6lDLZLuKuCaxLVJUlO2yr0FOYwKpz2MBBwB4eM5A==@kvack.org
X-Gm-Message-State: AOJu0YwPj1lVA1GSrC/ywJaqktPKrl3vvx3xAsaQlyGMglyV/s5NlGkT
	Uz78kjKRXi3SnxrOwVMcv+w/yQ8pKnNby1hdVs8hBenJhy2b+gbYwKZonc6yhcXvxU6k9uGtAqS
	Yrva9P8pXeufRaVHVX3JxllqB2WcIiunvXIuk+gpNtyIaZi9tm3e5
X-Gm-Gg: Acq92OHZZQN9gX9w9Ef6ExMBYILsfLzFK5uA8zCsuRliDVhgwvfjOJQ/k5AUFygyevJ
	7X1lKNhJuIJt9bwXQcb27RozVkSQqcPrbp31B4w1UKsxmL0htmWxLWLJjA7y0bua1RR91AysKF1
	hdYP03pDhPBfLK7ffxnHTnrbRzGUqV6x2HHYh9Aovp5LKsiepoCJ1CXgnmZOgcep8PXcQNkHq/a
	CWweAiT0SzCjrkcnC0siDNbfz/4a8QqLN55Ffozy1VsfGKxwardwn/y91ln9zsDb+egOk9mruZV
	14g2F/G5M/io6o4fMFOBdxBaJGQK174lnl60In3Q1Hnn6Xn6+NsZvh2hXZYXRghFRjTEh4RjCiT
	OrK2u7vNZ+wfMv56SHChzrSiTfV2HDE7GaRiFk8JQX0NMeE7eP6w=
X-Received: by 2002:a05:6000:4006:b0:454:1e65:32f0 with SMTP id ffacd0b85a97d-4541e65332dmr22769382f8f.10.1778490238347;
        Mon, 11 May 2026 02:03:58 -0700 (PDT)
X-Received: by 2002:a05:6000:4006:b0:454:1e65:32f0 with SMTP id ffacd0b85a97d-4541e65332dmr22769308f8f.10.1778490237654;
        Mon, 11 May 2026 02:03:57 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e6a5b65sm25227071f8f.8.2026.05.11.02.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:03:57 -0700 (PDT)
Date: Mon, 11 May 2026 05:03:52 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH resend v6 23/30] mm: page_reporting: add flush parameter with
 page budget
Message-ID: <4e2e1015d22d5aeb3a60d74cc08b56e49363d3d8.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LcoigdMZXQsvphTyFeMhYCo74T7Vlv0qZBnBhETsAbI_1778490239
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AC0F540005
X-Stat-Signature: znciym9hw86iuzeboimcxfbsr55njanz
X-Rspam-User: 
X-HE-Tag: 1778490241-687636
X-HE-Meta: U2FsdGVkX1+Ky2ifdOWaPK4hbsYS1SEtrIlD5VTv7X0g+GpglNvXgtBhAbR3qJ145yNJ0t+3+YQzIYYtnqTWUWECEvrrh7KdG/reME22nwdtbT5PCyEGVBKOyV5e96c3lWWzq2r/GQbN/0+X33vmfj9M+NVp75YD5PulWuaNNWKD0jW1Raz4TGBEXNyrPScIcznaWGNfmiceHACUnLa8ezh9exQIzVpc8KPiVJS/6ra7saW7yEXM56d7V/ohReTp4Cz1lvnfmeFw118KbVKi/Pki4R9TK2zRs0iGL98vXjre2HRGmHbx/DRtuihS8qi5t6/mfmskn3Ez9WZLOWoZLfth/NGfFhyQzsqiS6QP97RKuYvLm0Ccmxsug3XcIaB+RAxNf0nFIaKLAZUbmQpk0nyxmQhQBdIh4cPxT/blxNXHvxGPv2DNNAuL0JR266h0VtMyTaKcdtJBtJ17TBRS+6WxT3Ops3UqPbfaWALFwJub1CE1uqRWmjAbZUB6A+soxv6JQnovwd4NqEFePIp3LWazuDr9YYbjlh4PmOhYGbx5vKlWIdkpIUTmk6YzAM80lenwzdqTO59w+ByJSYP7vmyEcbOUizdV7uNW8bW4AIkbmxn3xrrICseuITJqR4VBa4VZRxpVdqMUU+zKWEp/kZ313of/14/GBC9kprhdBKt0S+2x8EadrKWVfjlgZTiHK/vgc7QmMz1pakz10G+snXSHgWCWJGKgQx6XqUCCXoiZFvImwLJyMbFwsRXd7yninWET5nj0SVRowW58qNjjAigMdxwkDcd9yVj2xv2oiDxcd9tBodh3W7ZKXTQ56PchXhXxjBIGI9lzn4zp1rI1KkI8YX+6e8AWB/1/xEBOsCqn3EfocGOovW5k+sNO/NDC4a33A920Xtb2u/O+1ZCv9xRVr/7XpXD9gKrmyugwDcI6XzgB5n4WYfat+h2fBiQqWFvkkU1DO+BCLxaJJZZ
 Yzq8eq0L
 Psc0uU/QqJYU1Ip+jmKGqXZQKZetFS/nYMGlORMcufoRaTZpKzj28ZgH6ILkHp/gYDKyf3jujzk6iE7djAygNu5xhWJN1cw4+B6WQ9+zcGzFHbaGjHWQWu1X7OgYEQR/GNTzgSjp0YnCKrKB4ulRpaPRxjYvVDfzzZq47o41cQyLVt5Cyem2qNgdRSnybEjBNjhKwUmQqOjnloJ8kWiCRdHmpTHALcZQuh8gQvI47iWPXvi4kOlYxpcbel1ZKvNLtwcgpBrMTOLST5h8mejL4KdJS1HXpf4VtYB0u7S9y1E75BAbb7/yM2zhtkNJE7+AK56fMep3v39AG6wknyAmThm3CxvX6ND0CKeDhCZALEpDRb/AOfgYKbKyhDM7lAqnBTYsAKxLFLv0WO0y+/c+48DjjpMz28hoJC8/ejZ5X3fA7bcSbAGThgRbyuCpLS8yGU9sq
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

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_reporting.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 6c957a9daeef..f4a0e27ac7fb 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -358,6 +358,48 @@ static void page_reporting_process(struct work_struct *work)
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
+
+		for (reported = 0; reported < budget;
+		     reported += prdev->capacity) {
+			flush_delayed_work(&prdev->work);
+			__page_reporting_request(prdev);
+			flush_delayed_work(&prdev->work);
+			if (atomic_read(&prdev->state) == PAGE_REPORTING_IDLE)
+				break;
+			if (signal_pending(current))
+				break;
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


