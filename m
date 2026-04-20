Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ABF6F588C1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC73B6B00A5; Mon, 20 Apr 2026 08:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78946B00A6; Mon, 20 Apr 2026 08:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918EE6B00A7; Mon, 20 Apr 2026 08:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72E7C6B00A5
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:51:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49815160A21
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:12 +0000 (UTC)
X-FDA: 84678919584.17.D8C22A2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0199418000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gaGfakVB;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SikkYlL1M+gibhFkMnOOpJ+LH2O2BXdI5hRy13pqHRY=;
	b=jEUB6jP/1ce7h1U6BidPFDoyDJ9SHPyccgeptTDaVM3fnCEvPbBY3i4uf+f2iuUohKFGzP
	2ksfz/ebQfuVdReRDzTv/0mEruup9ZgSfp6TFfhfSM+c0Y2BJ69LG7DL8DXE9prxhAFCSh
	AXANbyGVqW7woMtqeIuIWRUqvac2Qtc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gaGfakVB;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689470; a=rsa-sha256;
	cv=none;
	b=NM639WASKrhdNwBPr5DU36tVh4rTEGMySta0GNTbacHtSoH0pAuZ50Nc/LyzEDzcMYo+/B
	hhMcNcpyXW778//TwTYNHpmclVHpHdE8sFnZ4Z3q7EpDbwf/v7q9bSOsndbmYI4u26MGR+
	5nnWCsS3AE87TIfspQ54b0ORXls46e8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SikkYlL1M+gibhFkMnOOpJ+LH2O2BXdI5hRy13pqHRY=;
	b=gaGfakVBS/rWGd0XlGSDz4QY5/SIgU+LXEVaMSILExrQDKKPmzt8GNBi/eectWsA/ErLc0
	fGYkToddKqCkByiNfJ8XZXWjXsBT3AOj6Pt1u25ybT1JpCfafKvxXT5SquLqwaO+I6Yl90
	79LtjnTNmsbShdTNiXI93Y6r/oHDGQs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-giVWwBZZNbajxP2Tr966-w-1; Mon, 20 Apr 2026 08:51:08 -0400
X-MC-Unique: giVWwBZZNbajxP2Tr966-w-1
X-Mimecast-MFC-AGG-ID: giVWwBZZNbajxP2Tr966-w_1776689467
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d103e46c3so2140963f8f.3
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:51:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689467; x=1777294267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SikkYlL1M+gibhFkMnOOpJ+LH2O2BXdI5hRy13pqHRY=;
        b=CYPxjDanoQxMrqRVvbJKVseJzP2YdtmC7MzFP1us9DYnWjePUAE2qAKhdnGHOiAooC
         WRXL9YWdUDGq8+4nwjhP0yEajlcT6XJiJUCZpkA2qSCRycxqzb9GDCA3qKIzTMRoLu1g
         QWXBQnLj6f0WmYhoVb1iYRptrJ9oGL8BOr4/25No3url5Z26SiRYw4raC7/kFrKG8Kur
         99fhBvNoEf+OFHQhOFfbg/xv9GbMafqNY3E0bkBjC7l4ZnqX/cImFSR8DJYd67/JD3nR
         vgw25I7M1PT+6k7mOO+sdRMdwiuU4In7RPlcoYmLQ1QgMzM1wy/igKgUv3vnqZ+xz3UU
         ua2g==
X-Forwarded-Encrypted: i=1; AFNElJ8Ce5NAthhRqHtWyf7Xy4x/Y5eUNFQys6LVXqu6tpdaSVhRh4aS4te0D5zLdlKmnPnTdke8razKAg==@kvack.org
X-Gm-Message-State: AOJu0YxC4TIJAOOQe+Jly2LLnEmDqg7ySYVCCQ04Zu1Uhcb6adNXVapj
	b1wUuXJz105GLLmBsLsuKmzx3setVl4VRDVIx3GJOhehI2rk+WmcW4f5i0xiohanAlZw6eaNELw
	UdXVNRX03XloqJY2TAbBs0EfLXZZXJA2cAd03ZLhTzfOM7vsaGIy5
X-Gm-Gg: AeBDieuWZ+EYpijAPYAdJhpSxcsnkJ/unUcp0ZDu9UNv0iSWtfLIYx2NXzICItb6ZO8
	HXVNoAg3cCpeb24UCOlJas5L6fsCYOj5/UwYXDoURSuDKHbz1SS3QCiny2rsJI1ymkkPmnZ++PW
	oWpo5t3Uw6v1v4/TwKa21A7kaeWS/C3mtxVwRnf9engIo4a0TPPqWu2OJkjA04bnxZmt8/y6m7B
	NmbehbLtA9sz0377hW0z63Hf2pLVw8s126UZv6pi82mYiX44IaFySO3k9IH/qJkWrCHKAZn+muU
	s68RPTBfccj9X4g+Dc8yg4k8ZAn0Y/CeBjt9wX2JycZVd9IzNw69wCnGULBvsYDC9WS6x+nKSFZ
	sop0mJ5baSg47lM0MhAqBYBFM3yX8sb8pW3l5Md6YYsyMkDEe+ZAYQw==
X-Received: by 2002:a05:6000:2511:b0:43e:b0b0:629a with SMTP id ffacd0b85a97d-43fe3e0a1bemr20301767f8f.34.1776689466823;
        Mon, 20 Apr 2026 05:51:06 -0700 (PDT)
X-Received: by 2002:a05:6000:2511:b0:43e:b0b0:629a with SMTP id ffacd0b85a97d-43fe3e0a1bemr20301696f8f.34.1776689466326;
        Mon, 20 Apr 2026 05:51:06 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a7b4sm27168068f8f.22.2026.04.20.05.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:51:05 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:51:03 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v2 16/18] mm: page_reporting: add flush parameter with
 page budget
Message-ID: <23f8d36128771ded02b426cf71b840500004ca52.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5ofXQQ7lD0BrFjcm4kYBZyJlNAduFD6_tPKYnUNa7DQ_1776689467
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0199418000F
X-Stat-Signature: os5wjdq833rz9aopfp4qoieb66yruia9
X-Rspam-User: 
X-HE-Tag: 1776689469-99355
X-HE-Meta: U2FsdGVkX18Q0tZrTdGyawqP+Y74zB2t/HAIjmJNwif7dLBW+61JJHB5lgshAhjJxStTmr2cVkwGjJLFrSzRyDa9cIX3jHB8HBSV+8ZHIMbvV8qf1BulgQdiJGu7REcVW4KhXHKl671HS7Fl17pjiehEiPcLn/blrinnwhDz+xZI1eZu59SKS8SrPdynSQOxCfs95oOgRiakWm393hkKkONSk1uV4BDcZyDYXda0iiCBRmtoOjVVYt8SWnVhbUxwY77nxJgOnuTJ7M5Zs8NyyTUnuASxvoLXBZJDPYaz8Vc2Dm73YhRL7c+xNNwlhdkcMmltVhgr87SFtEEZjsjCE3gAynJ+EOABq0eNjHi3GzCShaamlABxxElm/rLpD9QKQQczEc/34U+/Av2IzTjY9jDseFH3CoqM8QDHAAx/an/gHUNlbxfDB5EYDT4GPnLFhLBEf+0aDHWRccPU2xokApCy4bdPKI9bynpkpat4/i/n6uBaDsOmZUaxd+04/e4Y43FlgYq0XO8I830NZsMtizZEV8eLZoqE0gCJm7MG7m28u41LNkR7lB2q670jHiEeWm0aQ41xuuGJIV32dVp3GTgdDu60O0vwtEyuWZXgchHFNXhzMTIMlxJvXYynlIG+Im5fpV833JO9z5kHSa0kNr67Kec/7nUgG2rw6KuZUcAN/eeyroJ1aPYNoF7xu8Hh83kWRui2QHa3Cx+ojvUPloWbX3kj7sUEQQKNQ7XIOWW7+rtWphsI/l4xArKDX+p6A5x4S9dVSYcKuLg/OO8Jb2S7/do2s8qIuVUVE9JizX0Q9N+8ezlqS0FjZRBQgIkmSC9/H/BvHV2qfz2quTFXuZWQ9fLUuq4pXimDqHfTaPu81RhTclgS0O/e2jKeEi59a4eVBccGNg926EmL3Eu/vjK36YQVzJ7wwnirE8GaC7sVJWbPBp/h/gqDz7klNOpqVxoE9lrfrltGvTVD7mP
 K7xJH+0K
 msjfsgq8bWG2TIYjQ7bDeUh0NOEjb8aUSUimimlqLZdoulh5Hzy/OBmn7i0fGjVHcQjplIFf3dkyEsgJdEfAn4hCh0/r2Gh3U+oS2FyPt7ASDSpvAifZMi2z/s3RzHdpBRNvjPf/mvnNyCEol/hoAJwxcJ+viSLXy/Ykef75AsggIHLq+9XdZITm6bKulIZbdE3Xr80ZgJIavA2ZHXs0oOLUjsi8BJkHRNwnV1Kh3pTP00zaBKfQvd65gA7nO2lKVg2ahPhEfJJ/91LDioY0F0cGHwuEJVaaLl/TAMa0kXwizyjZQzWvup6Lzlz05Bm6Y/njoCFIU6bDn7EqbcSWEYxsPctUGAkCYco6ak1PM96p5a8e6XCGq+g8he9vYvdjeEeTWSdAMBGrP0YykkPg3t3ehzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a write-only module parameter "flush" that triggers immediate
page reporting.  The value specifies approximately how many pages
(at page_reporting_order) to report.  The flush loops through
reporting cycles until the budget is exhausted, all pages are
reported, or a signal is pending.

  echo 512 > /sys/module/page_reporting/parameters/flush

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_reporting.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 5e1e1a924b0c..3560f272ab70 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -354,6 +354,48 @@ static void page_reporting_process(struct work_struct *work)
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
+		     reported += PAGE_REPORTING_CAPACITY) {
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
+MODULE_PARM_DESC(flush, "Report up to N pages at page_reporting_order");
+
 int page_reporting_register(struct page_reporting_dev_info *prdev)
 {
 	int err = 0;
-- 
MST


