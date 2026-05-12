Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C43CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FB086B00C6; Tue, 12 May 2026 17:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3336B00C8; Tue, 12 May 2026 17:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9296B00C9; Tue, 12 May 2026 17:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DF026B00C6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:07:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 140D41205B9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:30 +0000 (UTC)
X-FDA: 84760003860.07.6629611
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 753BB180006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="d/XcsfQn";
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuTcBXOBEgIcnIT/SeHSDJKAZ2vX9yg2mawsRplntmg=;
	b=Jpg1pjao0VAbzg04SRNHv6c+57KF6j6saiXVM83Rtge2RyN0zZvt2zKMFKQMN/NAvjRs7r
	wrOFdtQG2Uh4KyYYNi2DKMxDvuUgAd9Z3kCenLJ9scgAj+quMibW6HIg5Kq5XogbQ0Ed3c
	j9k4clHPLLwM8OjG6dXv1du21YBeSFI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="d/XcsfQn";
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620047; a=rsa-sha256;
	cv=none;
	b=gXb0UlAXzi8Uyud4sfTUlKX2/O7GaInlOr9uaFlY/KSs4Dhs6AE4IRELNInENmySWgR5uZ
	jJL9ROxY6K288j3WgH1kwW+6EbHK2u2r2s62xg2PpMBB7gdDuQk2IEQFdp6kB5Gzifz3lX
	tMz5aPmoQRhA2tygSul1EMIkcgbvvuk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RuTcBXOBEgIcnIT/SeHSDJKAZ2vX9yg2mawsRplntmg=;
	b=d/XcsfQn0hWhqNo2+FbUMhHplDQwwyJQ/GvoyYLzrvSOq+xVEZfAZ0bmVDxJc6NcpTJFiQ
	OfoTO87lZ+cUsBJo69kbwjOrfvN86Zp62hi4YOM5bEpyF3dS4m+KTB6AB/QzPe1YXEG42U
	1bSiFaXilb1Wa2IcOCO3nGurcuRwJrQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-UH-a-mjWNraTX4DUFZ5Q6A-1; Tue, 12 May 2026 17:07:22 -0400
X-MC-Unique: UH-a-mjWNraTX4DUFZ5Q6A-1
X-Mimecast-MFC-AGG-ID: UH-a-mjWNraTX4DUFZ5Q6A_1778620041
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48fb4ffebe7so2908325e9.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620041; x=1779224841;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RuTcBXOBEgIcnIT/SeHSDJKAZ2vX9yg2mawsRplntmg=;
        b=MrkNtr4x8rUy/hXStTHmAz1RJk0YyckYKVHLIeJPVUN88wk+bW8XSyAHD0VZ2w24DQ
         ndG0ZZ80AQvKB6nZ/Bgca8WGP2qy2UgtHoQZtRixKF/6LGv69DK3KDfHjIrG0SA3uSry
         5GpPn2EShpsjWqYl7gGOTt3dxO1rdfnMc/oRavaMj5LRaDohG+x3ye9/5DSSk7KbIEvd
         hPkoWhrgDVsuW9CcWO2tRSsI9/DZQsq9gSCJCKNM4LsyoYQsLaiUqqVi7H9QFKjFtrbr
         rHrHV6g4y02YLNWO/B7tEKM2wtzY4d8sbutcUZC6aOC1tAwTu7K5VR2bSulTBvQCXlsP
         SASQ==
X-Forwarded-Encrypted: i=1; AFNElJ/LKDkWhhfUnNfi3cQ5H3IWsKtHBRtdvuVMlS3js+/U/pm5Si1JMvd96nQHJ4klW7Wd96PtA4DFDQ==@kvack.org
X-Gm-Message-State: AOJu0YzOvJ1fDhKpFVpigfJEPnr9tSJUoBqRJ40nQH0utDhKqtL17FZ+
	VQUhdiUM/tBIkIsi5CWvfSdvk0HzAbPZ3MS9b/9eYIMpfrCZWR1Pk3egKLP4Hyuy/SuiYaSVLjI
	yRCWvNHgx4PkSZdtw4JVY5YXdtV++iq2Jq7axqVznkMyhd001F5mT
X-Gm-Gg: Acq92OEJimQhFMcqG1oBZ9VUvda+IC6bDcwSD0Eg956HJNsZFf/T1tdAND1bLhUS5Gj
	JYJhV9+14KVPEu9ClKt6aJv6blWd7ocfWzZWIM+C87EP2GP3khwPqJJnBkDVDc1w3r7ejXBCBzN
	BfG88lBPWAQSTwYAzBJHCL8uqVxMDgiTHAU0AnVh1JJmOP+x7eyrIWgrq7LH9LbjNN/VfTUCnP8
	L4fXUARlr6ehaKrHm0rmpJAgSEtWT7dqQFgYYVl93X1OJeMcU8haQkDRpIJ50IRPcMv65QW9hfz
	HiQ695jbdfFxkyrkIqZGzupgXQmJ8APhbeoPbVF2bPvLRYJSOyN7kqD/+0KaXVvXQ3/oU74lCrP
	pykiNhc15DiVzkVkD3FaQEDYE06d2PkhFkyhUQG+h
X-Received: by 2002:a05:600c:a011:b0:48a:563c:c8c0 with SMTP id 5b1f17b1804b1-48fc9a0e65emr6519395e9.7.1778620040978;
        Tue, 12 May 2026 14:07:20 -0700 (PDT)
X-Received: by 2002:a05:600c:a011:b0:48a:563c:c8c0 with SMTP id 5b1f17b1804b1-48fc9a0e65emr6518995e9.7.1778620040393;
        Tue, 12 May 2026 14:07:20 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6be40sm36486377f8f.12.2026.05.12.14.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:07:19 -0700 (PDT)
Date: Tue, 12 May 2026 17:07:15 -0400
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
Subject: [PATCH v7 24/31] mm: page_reporting: add flush parameter with page
 budget
Message-ID: <7970645404129ef31ca7035c7d6b5ff960bf14bb.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a04CUnGEgkZyFtyYzJ4UgcA1WtUCX2qtHEwHw-jR1Pc_1778620041
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 753BB180006
X-Stat-Signature: it51jgwtpdyzm9m8cmbcykqc174gsb5c
X-HE-Tag: 1778620046-776098
X-HE-Meta: U2FsdGVkX1+3PsRraAyUkK9zRDcjQxlE/E6giVN7nwFDbzx9vgWlAdLKga8UUKIUvARZB5sG7XqzrZ8Weg/NPsnxAHWZuiG9fspHiiMzBVJs1k2NqgQ3Qj0giw9WdbKVFIkaPUftKqiLYt8j5fNZ0s7gqiS/UBX0M266+ZG5tIJ6JcIw2WndjAIajZl7liREl1U/GqO6sinAAiTB45dEkVCqaoFjoI2MKYpt93zQXN4DLg7rpndf8zPLom4sWdrZjXVUfGoOH3WuCkI+QIxT9kplBOVBIHDYF80bJpgzOBaw6tkc+fqmKBNTlbWki6mB9VqhWiNWiIjxwmc1ge1VP0AplSf1GAPF3Z1RY8zo74tlTXEUjXnBp4aPSyFjKkJXZMCGwKcEm2tPcCBzdjwcbq6N9wwloMvke+jaj/s0LHJI2NvLOH0ikDjD600HusOP/i6vhJIlOwZa3LLd+4rk7dtJBVKV8rUK812Oh0Rnvn1MIZgOPb/PqtJgLqLAtSO1ubiPOwGXJYPimqhPFHPcmPA3cOdudhyv+JUCVvMVO1iKuNqBGlTDdjeGqz8qsD6G5CaLLy7NgpvuKyFWcEGoVce+EOX6Jwewh8kmjgmmaiGmRkNqLZkARgE1df6ZN64YKc83jevKJSD6LHo30MiVdz7LMaACuK8c0h19lvq9nM2cCP13H0LEqiE+LAF2zef8LUdRxB1cTe2fM2pGY8rNdUAmPqMQCow1fpzBqzkPB7F/tAZH0cyEPfMluXmxvAMJs6zo2kNpNYqJBoVv4ujK9KioTw1d5W7Czpc4T8afb8e42Vs2R3q2JjNSngCT7w8Ch2LPe6inlR0WVoarPii04MBciq/jlt10MvzGyDsjrMXJQwVGJTiHnt8/RAed+Yz/c0v1xLATI0djCUJGzUgFjUnkbTvQKj6BHxZSGFYInEGuD8yQG1g/vsruD0m81n6CseDfXRw4nLOzxeB+HaB
 wbSAofFe
 s8duj7VmqJDXzGTXLbNhNo3FtcLAHahXW2YLX0MxIbURCGd4iwznZUKPUy0v/n6cUmQX7LWUF5EH/9EMV95ptWy71zdfewM9tsCjw1w6d3P5K3j4wIltVHQWIqfhFZHXpswRMAxJjVHzAgYp+bNBJYKKDPzCLipBWi0jidjGBWTJenOkhrdm58Nka4A0YDPTLKtuUOGa2B2RUgivzKksudHy0hZ2hjs4uX8N2kztfh1cu+gfx/T+xkFbgyngIa/tIhDK+hF695/u2dihl3KuQn9htKk5tRnE5APemm1x6T23WPn9vZ54sk2rn1UXYY7O1Ptb/5rORz11Wtj5F2p+Nm6RjPu4YniYeX2ItEgBK4aeABGZxif8m4OON9jQH1taBsRDINtB0vljXMh/UBWrSNj/Qv6fZ+kRu4w+Ijw6IlmMtSCCiv3XhxS0eh0XqSXGrYT4c
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


