Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4458CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF506B00D2; Mon,  8 Jun 2026 04:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16F966B00D3; Mon,  8 Jun 2026 04:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037A36B00D4; Mon,  8 Jun 2026 04:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6B9D6B00D2
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:40:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC3571C2B75
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:27 +0000 (UTC)
X-FDA: 84856098894.11.E012B3F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 59CE6A0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z11GtX6W;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780908025;
	b=Kwq6tCDFubHzxXUeO/iN86ps/xZgO9mSc2PXMA98jlTETH/8CVmyiA4x+PYa1mz/8Iy9Wb
	KYyPf83qa4jh2XOqxOF3RFgfTSO9N7tyi/H2hXs96daEXm/6jFhha50f3tVResA8zRGjNY
	j5j34PuQtI/lTDmMVpIz2bsg7k544jY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z11GtX6W;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780908025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71/5gV60k4yG26aCAIxd/scVyaKUto/kd/wMt0/Zjmg=;
	b=aIqReGFXI9ozWcUwFkkkuBBWGDHVpapo8jyNGNz0jJDRFFzqPjaqtmQkEiWPQr4DbWbwtC
	lFsJctqRtcsx2daPvAF1BblGyI1fqi+Adsrj1B9vrhFH7/bOuKF+hXI0+BZkXXIhg2Xr5k
	Sw9Qwy3q4U33aid6duYpUDY1gvlxsec=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780908024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=71/5gV60k4yG26aCAIxd/scVyaKUto/kd/wMt0/Zjmg=;
	b=Z11GtX6Wa3L/mhVNq2UoDXcYEB1Eo0ZQEYh861HYCA5g0IeP8iQAEVir3s3hbiiXLViHrE
	Pw4dOUspS+i+l/XwGlvBgFi+bjoa//GOOJhA7WrWQpudxgjc9bANCB7Un6+CIEyVIcgmU1
	Gcjn9J9oOTqakBIj9rF/Tiu3uvR130g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-qFCqG7c0M8O8x170bYyjrQ-1; Mon, 08 Jun 2026 04:40:23 -0400
X-MC-Unique: qFCqG7c0M8O8x170bYyjrQ-1
X-Mimecast-MFC-AGG-ID: qFCqG7c0M8O8x170bYyjrQ_1780908022
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4600cf05f07so1851541f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780908022; x=1781512822;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=71/5gV60k4yG26aCAIxd/scVyaKUto/kd/wMt0/Zjmg=;
        b=qaRPI263tYOGU0EPMk4lYOrJ6VmSI6qduQf/N9fz0nfQkOhK+Mys6gncqnsplNd1rB
         5B/Ie1xnhJGGb2XU2Ij2CymR3doeDONXrzdr5ielIspipGdhzYrwVyqZBodJP/Nrq5YV
         DPVQeaIdwWWrVPRmC2Nx+uhotcBbprgOwEUS0ZIPK+lskqwSs8UV1DRz8PwpsH8jSHuO
         vq1Ji61+G9NW3DgcruzIhqLzQTM8QmF1I02etcHFF5bxp7tTbDgwOf9eCWKhWPLOCUBQ
         J9RN06LeNh/pebcr6Z84SvsnsNAckgipvWE6NkgEY31yeX6LlrBiyeLmCuKidGynJzZd
         rqRQ==
X-Forwarded-Encrypted: i=1; AFNElJ+eGo7ygI6P1zLYdxdy66slmHAz+LDeLWvUCnP/s66fAEAVPWUUQ7u+f+4PI0+dLiv7oo/IIW0qgg==@kvack.org
X-Gm-Message-State: AOJu0YzHgnBFiPeQ/gLNA0J2+4tb5TLmjenL/k35qR3TayPDlWNPMkcc
	BlOlviKQ+Yaf0Q4kybBDlCaGN3lQ7lHKhIAx8kEEPSPgVzLiU3M/4NinobTs1JxPMH4TD8O4/hM
	ykZvUFZpt1rHeww+wTM0/MVfIctf2s74PwtGEreZcg8l29gcrtsvR
X-Gm-Gg: Acq92OHfoy58ugMtWdOZSWWzp+toNE9XzYuBdokS9g9tnOONI4mZ2TAJ0USPZpEvmFT
	91+RJEtAgXtLHoYrmcnPoJB7y9szFLunX11BCsT9yxmRh1Cd783qITKvU94pEOEGwSrUy7kbjE0
	chMlO7/CBdZnKmtKGJrGibfXqgUNWuT+PTXN4g9bbPwZ1KK0F2I2JnDcRSlSrIH4+Sgt9ZK5X8x
	DP32TdnYoc5MDmxGNboneJCPRpvYPWEuVuu83LnIqgTKfHuLYxGROo12U+mdLdmI/alyYcyt0fE
	wc2Hawx6z4BGSOlzVwxLWWQsoFWyOKYEjuJbODZ6ALAAb+3bFF9XRvUBf+2sVELZBsLdx/EX1c5
	i5Ijmee0xAPOKYNZm1Mofawo=
X-Received: by 2002:adf:ec0f:0:b0:45e:db3b:921d with SMTP id ffacd0b85a97d-460307563f0mr16344554f8f.31.1780908022112;
        Mon, 08 Jun 2026 01:40:22 -0700 (PDT)
X-Received: by 2002:adf:ec0f:0:b0:45e:db3b:921d with SMTP id ffacd0b85a97d-460307563f0mr16344502f8f.31.1780908021651;
        Mon, 08 Jun 2026 01:40:21 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2f2710sm39846375f8f.14.2026.06.08.01.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:40:21 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:40:14 -0400
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
Subject: [PATCH v10 33/37] mm: page_reporting: add flush parameter with page
 budget
Message-ID: <f9b2dc2d4d7036e354282596674bd70e4c4946e7.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6xGUTTMQB7-HiQWodFB-j4zVLVjNlU_tfCSehGXVLdM_1780908022
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 59CE6A0005
X-Stat-Signature: ibf7qzm7h9fmffj59hkbsozrcpfqxfgt
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780908025-368240
X-HE-Meta: U2FsdGVkX19gMex8JSECKjZF5ls+Jn+Tp31IMvYDDiqQhUegmkaAjN5lj2rkz9GNI6OqHXh06trg0rmdHRSDCD207UQ4cRPURs6FpnuZ7XJVY0dOMi5eBCUfbDIq3j8a/xkckk7PoB6vV8uG5afNRYskx2Pr324DUtWBmdW+VHpoIh0aO76XbHJ/IXdupvayEgtCmxMxYAobsn+4KP3WUIEEEAWzg6TPRbqeNzWmJ8pI5Esuxh56JVc090fPVP/S53p5Zc1s8Z1lgJrcwXItUyJ2J1hLR+L6Fypcv7nQZt+QfuWetFFo2QIhavzUbpWAuP6ZmzNxNvu4PIlBwdzX04G48XiyUtEjcPmHndfxmoDHGtvRd08MpJuAqGiBBV1CufiYrwhZAR2qVuhWLhbEXTgHmJMkIGBqmK4v1zetS0trWtw4ClwF2XSIhjnzwGgu1dq8Y4gyyxsE58/Jik3A8AuFv+j4HJZUnej/qZaIEMS7qh/n9wWPSqz1DNsM8ixpTfZ419ZBDzPcn4aiUy/wZZ+j+tT9R8tRQIsnVWZD2Lel8hJ82+g5UG3xYPLeJaxqCNEt8k8davvWuP6Rs9wxwtXv97CrqmprI6ulq08A6ulp8iqs7/yIpSMULhXq3dE07svajnoMFZ+CD54V+SD5Op9TILLAPK72FZmSptK346Rndmh/SHud0l0XLChsytg8HisqwfPMcQxwJzYMoKJudi1QcP4fXSBdVsw5wiu8cJIcJpXKgJutl88gGZq/bAbf2WJyTEF/nFTO31wgBdGsveXsaH13ItSlzKoJUEbfi1PZgG+/ZlrViOujcTTMnWzX+0jDa1afSJgzq0qMF4fOpWITKYdBu8KialiwZNXzrdLiUh0cgCW3bsUcgE7Cz0zOOm6I3SvmJcY7ksTX5CdcWREE8cf0OdE6qVxjMyFvryo8i4tJWeKP6mpli7sFaf9T+OTiWR3ZOgHygY79g0E
 K8AyAmPu
 GxaBva3lQiN4j2onhcI499ErVq1WHRR/DG30b6H1e47Vl4zygXrhfpO//0XEn/j3ltUt76uxL2TvUXxS2mKycFj2MvwpiKN8x3Hs0RDqbqVELF+qex/HJULw+E3fd42pzt4j6IWEF9VvEprHJWHSnuVK9DUx5AtvwV6F7rosUtTUUtZubASj0QbL8MdJCAqVE60cbleJQfgDME1W1hJhOaJSZkg6PhMbShPgf+R6tIGsYRn1UtRnaoProdfUxpdKEQtbo+1G8Gq9uhtU3dCm79cKTjrLa1kqicgBT1n1ss/J1wpQacDONOFS9EzNarsFIM9qld23gHYn3/g+x/BB3bOh4AlZfKZlWnleyfKv6eTODP4WL1azB1hM589xhofxxnNG1cu7rMXJqkHUD2+4p1gvV4TdVxUajUCwbyt95TpVkC/kHpn+FY3bfT+7lva35PTsT
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
Note: flush_delayed_work is called twice (once before the
main loop, once after). The first call ensures any pending
work completes before we submit new budget. The race with
__page_reporting_request is benign: if a concurrent request
arrives between our flushes, it queues new delayed work that
will run on its own schedule.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_reporting.c | 54 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 9c39448e758b..400150a2aa15 100644
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


