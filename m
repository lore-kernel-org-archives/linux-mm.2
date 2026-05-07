Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF923CD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36F456B00D9; Thu,  7 May 2026 18:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320F66B00DB; Thu,  7 May 2026 18:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20EDE6B00DC; Thu,  7 May 2026 18:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03E6F6B00D9
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3462140602
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:34 +0000 (UTC)
X-FDA: 84742051548.16.D24D222
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 735964000B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QmQ7U/M1";
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YDr6AZkMpuuq2CYnJYP4SwOU9jLN3mgGUSThqOO84A=;
	b=zSv+sp3Xi8t3TCpKAckmi48AZq8rcsKgLV7ovEHVdscI1OsXchZXrRLR70gL++UwpfGhaY
	mnuYkMfyN2x6sKWtdBloqXYOesD2mkL03kGSza+5RqeURnS6TIc2czbDGSeZhhrfirey5S
	UwpfKlODISFgF9f5GbM4806DX/iqSxI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192612; a=rsa-sha256;
	cv=none;
	b=FqLMYJ1p9bRR5zf2ZeUnf41uQ+BLqs9WUW1efmvnE0N05N03+PC4Wxfz+m98a57mM82dSY
	8l2yS5tYDeYMAKcmFcCZmHFZkQH7dVavp+YJUp5Mb7vK2lH0b7vWqISdqZy349cEkOoVw+
	B7me82NLW1aCflIxUrSGFic790ai36Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QmQ7U/M1";
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1YDr6AZkMpuuq2CYnJYP4SwOU9jLN3mgGUSThqOO84A=;
	b=QmQ7U/M1emyEGb0SZnvSWNu3bl9X+BKfROtH8peUyKiXwlwkzATpmor/4NTHNaDI75eVy+
	kM/Mon8h14MVydSPnxVJT3q7xlXSwz7taPSOO+baC+zX0ICZ8FmEKwMzCRTt4hIM/jKRxj
	qcmi4CR0xR46/QoKU1GDf/iOAnqa9M4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-nZyfolbePaez9abXffzptw-1; Thu, 07 May 2026 18:23:30 -0400
X-MC-Unique: nZyfolbePaez9abXffzptw-1
X-Mimecast-MFC-AGG-ID: nZyfolbePaez9abXffzptw_1778192609
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44a52d5e572so832690f8f.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192609; x=1778797409;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1YDr6AZkMpuuq2CYnJYP4SwOU9jLN3mgGUSThqOO84A=;
        b=GBaKLmVJ8ZLo6aG2G+0VpPFu/r9ehlBeBytznO03VkBhmtRa1cL/UeEjNwC0YtirU0
         aXDRQq84wwYvKXGd114cbFWMw5m8A63udaLAL90WRxH4X8p/y84QRr1ZejUpLNloqhCG
         t2d48QD0jtceFnEeZnzJTMR3bSmsTY6gYHEFCYnvGE87Ze33HwQghCAhA8OM/oA4Q8ka
         9jIhh7OWieWsG5kl8ZCSb5L9UaELFErH/hmV28dGe6hHNBv/FbQA3nKLh1zC6hIbKc6P
         RscjWp+Ujz3yt93xXUZ3UpmOn91KR5NlGjjHYUlvCyA5pKXx8iDrb4iCUmNzyNqKHp/X
         DLYQ==
X-Forwarded-Encrypted: i=1; AFNElJ8AhlKHSamodkGuhqQUlkSW0YO+K03m31yWyQCsYmw+0hWPg13KhFA1+5JNaESxeO4ThAHwmXNZRQ==@kvack.org
X-Gm-Message-State: AOJu0YxbfdxiaXLc6QPfaOXtRGIl3KSvJqdU+6cpv5cvEE4ukoNzvs4q
	AXbkP8oCDXjGxFWz9BBMVSZnvSYE5WG9syuMhOJpyyfbG4LZPLLorTXD/mA0O3q10Z8kEIdHntu
	gPdLYXu5RLfolSAquPdKu8cv0iEAuF8wp6+j948cSHMl2EJ5UcC8J
X-Gm-Gg: AeBDietD2y+CtJ38zIHoVKfTdz21+B3EyYkK80nWGICrmwkZqn99UKP2Wcr2XGDD+iV
	BlkmdhBa4MCqxWbQ9hC5cYWqclYVtMVtYceTY7fx6V2eY/KvV5HJTVcL4lrrAwsC03lBvTj2uNt
	kZpVa8Nh0sDtnINtlLMfE+exVUgiePof7HIP79IL2cfzrb+j+fNgaPMaR/jhvJhjiQrr6XARSjh
	pkpv+Lh3e3HilPm23o1xdnXGO+rw76Vud1C0tfLMuNKHy9j4CWTo6k6GFuCIyE6Vn9iGIa/Vwbc
	lpJKXLmX9JVFu825wNLNmUnOM98Rgm/v9gQZ/9XLpEv5HERloa3cSm82+decJMwRtZozEwephxj
	7os1MiVBBlR5ubYnd4tUdwzOqtoOAohvdli0W15nm
X-Received: by 2002:a05:600c:1f0d:b0:488:b8bc:6a32 with SMTP id 5b1f17b1804b1-48e51f45874mr152541155e9.23.1778192609312;
        Thu, 07 May 2026 15:23:29 -0700 (PDT)
X-Received: by 2002:a05:600c:1f0d:b0:488:b8bc:6a32 with SMTP id 5b1f17b1804b1-48e51f45874mr152540905e9.23.1778192608850;
        Thu, 07 May 2026 15:23:28 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e67455581sm2909895e9.4.2026.05.07.15.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:28 -0700 (PDT)
Date: Thu, 7 May 2026 18:23:26 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Subject: [PATCH v5 21/28] mm: page_reporting: add flush parameter with page
 budget
Message-ID: <26688a24bd4c2dc461859b47e887e730b2577f1c.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sxYaWLkigWEdA3O1n2udpyFhOF_HRWNl-719knIfDPY_1778192609
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 735964000B
X-Rspam-User: 
X-Stat-Signature: uian5tjuygcaz3bmj8f9j8iytuspcyc5
X-HE-Tag: 1778192612-341612
X-HE-Meta: U2FsdGVkX1+nj3t/yPKT/TbtgDhDiXCsu3Mw6AZo2MeqTgW2UMSUEn63m3AEnE3qoevzYXqAMcQGW/fQvuqL6iNifl2Z2K92YlxXyCAw66a3c9hLfXr2QSUYFxnuBZiNHXZgy7JhOSyXKJbhN9ONFFNXi95C6X74hpzBxnKDzaaFSvACmRC6dJ1oPhJYVWHwQ3Y5sdWBaePHPkya6SjjCDbLZk7KQc2cROgtSrs0Auagm6vwHaHslEmMlnrIXPYoUBEcvkXXblU8+2hcvPvJMtNNI5V68++wpbymcXnQs9diwlWMc4gd1vEQIfDRjfQFBUvMbSBhhm880M8WMvwZlxP76EpO4KkdzMds1dq3flvIUfh15/Mkk5jBVhRod7KHLuTLEXCi/ZuFK5JyFe0co2ATR8drE2/NAaO189IcqjdvOXv+t3CzYm/NEUqrDDeCOPSYATeo+LZA321hx4WPyng0lFQ8ovi/5HAL96Av8jarCruebTfQMuDhEuvCUBr4SrUDKP2lJ0fviszw1aecdUHbUSQSq/+UTDrvc+EYNMmx+RQGdbnchUUj6Sue432mCVj8AJBSZ8clfe/sXKaUkmlmFsUB2EffyUBKAGOtYHl1CrVxiHhBH0ZspdLHdts7b+A2FccgpfgLtHYWzy7DkxlScpv0Clb3PZCnj+89PT/m3U41kyfCwrt5P3m5YjOWDzKtUvdintW1ovGAZHXwBiM883Ph/e+B4/cvUULag+POVQ5dV4/hu+eIks3kAAiLuYRsvNFCOtBJN3g5gCW0xYVRFXM+//KrvR7QPsAhhDhtZMBUPQs5rN1osFRKGdlXtEadGJHZ4tH2bCbluAG01eqoh282RkjUaKmHW0IaCRqd2AXhlCgg3jT36N9epXgqFM4ib8EF0uoLLPUxsJCNGm6/ZoXjGzfP+pWTLPWSEXUinoIrqvJHz3KDRtoho7ac4pShBmWT1d49CHf6V1z
 atlUgTGD
 DGqtRmF6y4/Mffb9mrgXchhanI5KoNYv35DNew/CsNYSzBm3yMcgu1C0y7uFsSsw+7QDBSchXDNXTbEfQ1Jhe+uk9NOa8pY3mA3DrGzXDwuEzVJTE8ryPXSMdDRDw3JDsEphKhFg7NzYY8xIMoscAToOPa8hEM3pIeUt3dPQViZ3FXCz8OSG1TkSvD13uuBDEIRg6ERjiYc1wOR0fOTGYpgHGMh4NpK/wLEOpFR4uBpkI6Y9amATcRAsVPDvFPRddqloSrpwRJ1TV4B6LdVVCWi277fR9RU3eIIdeNuxEiAWc0gmDI48SKeZXBS0kpvA5cxuhA0ycmokSVv8tGmdVnFP5hWXYlZR9Lq6vkrM9tHVt1LlSnDucGFSlCQ==
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
index 8137ff50ce1c..5590645acaa9 100644
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


