Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 546B6FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8126B00BE; Sun, 26 Apr 2026 17:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0386B00C0; Sun, 26 Apr 2026 17:48:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87726B00C1; Sun, 26 Apr 2026 17:48:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9260C6B00BE
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A24F1405A2
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:39 +0000 (UTC)
X-FDA: 84702046758.18.78D93B5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1411CC000B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y8gpPyHY;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqSjL1olH8+AffRmYI03HiN9kMkx6LQqrsSuHYVoaLI=;
	b=ZqoBLgvb05zXYwYdm2xI6s3f3cSGawFDPhp3UqRAtRt1vl8MIjFBQ4fsZhDW1S8puSKeZ4
	Q0sqNIrDQLqYq/U/Vlemv09Ekrk5DNpJzP1MTEhKJGJ98jyOefc7qCD5WanF1oGuMdZ2QQ
	GhdeJoIcNsndTOVs6We50qkLgeyXPj0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y8gpPyHY;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240117; a=rsa-sha256;
	cv=none;
	b=v/GhkO01lTdcFewH4yt4IznRx+zdrPGdLblXBxKOiaEd1rg32IyEp5Gshcv2s/AkaFIfkX
	VpPABViGdAmroY5afdDraG8ReGdsXWNgid6RYqFsYKe6gFup46jK46B6rgObHM9EDI8vN8
	K82bXaj96eMBfrMDskUCrXhZ0E/v3qo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BqSjL1olH8+AffRmYI03HiN9kMkx6LQqrsSuHYVoaLI=;
	b=Y8gpPyHYKWJryL5g33r8xHukaPrLKrH6+mDewz0w/G681VRi/UUXWLJbk129Cz1OYHRyz8
	MV27l1HwXXIS9kTJvmrbrEgOitTN3ywa6Ralbq/Q7IBzw+FLcGh/kq+jMtA5V3fQ99rwav
	4r6JA6yHq5hHyl+87ZSWUjXu3B+AqSo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-PKPvQAokOh2IGqhi2xu1JQ-1; Sun, 26 Apr 2026 17:48:34 -0400
X-MC-Unique: PKPvQAokOh2IGqhi2xu1JQ-1
X-Mimecast-MFC-AGG-ID: PKPvQAokOh2IGqhi2xu1JQ_1777240114
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48a588ff84eso42423875e9.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240114; x=1777844914;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqSjL1olH8+AffRmYI03HiN9kMkx6LQqrsSuHYVoaLI=;
        b=XoRydGxSuAOpD7APM7/kUlzu43ZcjbaOS0ghoPwe8ZOpqD9IzmHAlXiqZPe8j3akuv
         VwiTxi8UpReSFwrBnw+2XufkkiTQ1+0Bovnyqe5KbB0hu4y84vmjV+PFs6kQCkKSCAqO
         C3CVaZhxKiGPgNwWztCIMIGOQGE/8vyCQGvGYTlHLaFZWM+xFExb4ujW7cERoPD48bAH
         rP7rD3iC0rcln8NDojNR7qJmQWCCh5FdIhEMwtJfERrQ1rNcuezFdVr1X0M3Miwwyqp0
         mwk9MzZgA4WNZHxGJ7GrI9J5t+c+N83nmil0VTg9itHsFYbfNhVeAQy03O+CpewH8oXt
         Hm3A==
X-Forwarded-Encrypted: i=1; AFNElJ9Xd+dDDWisVaCh14Ms15pvnsdAI3oDR12oN4qAv/jXcaBLhFTQVPKox1zAmNvYE7yAQleya3TxZg==@kvack.org
X-Gm-Message-State: AOJu0YyCpr1CC3bdzC1Igt//GzBrrumJdydQWh04B1s13p8cH3sMtItR
	Fk1Ez2UJdN5mAG0cxqMjF9dRBoPH+42FEVHHd4ep/fSSQzGQUVNQN4mue0gyVwtMk27sJQihQpk
	OOydkPNZk/F4GwuJltGZV+q6zG/CfHdi5yom4pRik69jXFs8THfIK
X-Gm-Gg: AeBDies2pfaXftuC8SkuMssFYJIaUwjHQuOxxeh/ZkTXax/7XQRenTtU23BXNPwivOE
	UqayH4GdywzZCGzUXtoeo/vAy+bI8hGS34brjeyCKT8ag+3ML27BVUmyTtBKvekPuQ+FH2PM76U
	BvZz33a9pEvRjd7oKCXg9BzHDHPn/ncPSbMVJWCck+jQA4nxWqYNbUFE56F6ptVcalfZTfl2Meg
	mYcMhdOaqXHCqoRmWkhb1JMhroXio5TjT3fRxU80dhnfzUjAcB1KMowtKq1m8oqLA2Hj3aAu5JU
	v7rAedIus4N1QGDOw5UMFJ0rEIZH0/eWcrWpZDH9kCGqRgZ+yPClqRKYbkkG0uqHchhhTrO86ya
	y0SPdZhxfIjyYMe4Z32vHZUh7g0pjGAwUpaJsbU6cDrGN337Kj3WYrx04
X-Received: by 2002:a05:600c:620d:b0:489:1d23:4524 with SMTP id 5b1f17b1804b1-4891d23468bmr440690735e9.5.1777240113579;
        Sun, 26 Apr 2026 14:48:33 -0700 (PDT)
X-Received: by 2002:a05:600c:620d:b0:489:1d23:4524 with SMTP id 5b1f17b1804b1-4891d23468bmr440690285e9.5.1777240113138;
        Sun, 26 Apr 2026 14:48:33 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc0f8188sm806361295e9.2.2026.04.26.14.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:32 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:30 -0400
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
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v4 19/22] mm: page_reporting: add flush parameter with
 page budget
Message-ID: <d4ae5823206893e4c3d9e980d93064c9d52a1a28.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D6lgrA_odPhBtESSbIuxXfx07JNmqlCGxZ3H22WRsQ8_1777240114
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: aqqf9hm6z6woc614n64ns5cyz6stiffm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1411CC000B
X-Rspam-User: 
X-HE-Tag: 1777240116-625360
X-HE-Meta: U2FsdGVkX1+iiMW3xt0rXXt+wE6brlWAqiLmuVR311bFzMzTU+VHFVYJC+2aE/GWwo4tND1uFcbdX0bizJOZF2Drg7+GFg5CWQd+G2mBZ4I1wcJww4uvxsPRTMx1tMc3572dYYJRSz4sdwVqE9vFZLOrmqe8hWk/y6GfaeXSvLDopQ9gO+POEmauewUKjXPkjlmbvcDjFOQucZGowfjALY6KXKZXvOEs3aoaGn9JT/IUI+GV1/YKm8jcSvDalxnqsluJ1fTjahkCftfpGXLeTHkYs2UQPBofOcBFmA4hI56Vu8/6vs6HMbn94p98V+BrnxcQS17CYe1AoSUrrEsM5t1oFbcoDe4EbJH8V0w4HH6sFg9iroi3tSalOyEYzcrWkTwmsJKOC2pUMTe4Zi4N+2ZMbBchO6ayt3zgeml64h2011AJHEx/zYPcW82D4DocsRBWkC25zkGctHPiDBqLazMPJiJMbOsipCYqEsq8J1PayxVcAnjkNEzbDAx9qAuVBotHRv0gXJATyNYBQwiRWszSnLZr5On2vVvL85L+T4m0LDKXQBbvcV5UL4ORqwMrCSH8kWjsCPdy9+0jjEADpe1TH0FRf9O/WYD7i/4XWKM31gKbbYTrGR2Yg1Jwy1cOLkLCaXgPfEXJycAabetdJdbChBxd1hqqCrHXDj4bsk8BcFsJhHC6ayGWmxwLF93Bi08Tqn6Kwf6UsHHGJtfgrzgbLCNF2On7+LLco9mnD+Z5hZUM84hYDLHSXfuiHRfsMe8Q64iDTOsN9Y9QbFTJAe3Ft8/MFdSYwJSZNjyVDcS9QNXEwTNOeDIdzPcy44zf/uU0b/fMFoB0EShdMRf92+tnevlV8isB2qGeQszs3ZhKmcjGRk3uDQXjTltyxoZu1fVyJn2cZs3HYoSmcMju6SmghfooeaFlWm/mtqoP0QCCtbfaPaoZfMA5EYUhti+j1JiwK9JNc6yh5PmzzA3
 XJugnEZb
 iCADGeCQSY0hqSlECJJXpyrfVbccgMohx836hKz75bQHBXP5SEZxLEGX2C+UHmfOjw45PtKTie3/4sagnJ/t6RfoP1qtG5Uq6v55pDChzcgAgdUyu2vMA9+6UmzBqgbDyzwFj6o4vyYfI4gfIJ7D/Ep9BFfttirl96OfAtqusqe8Khmxa0bSMyFVgEkRoILcYbYBdJVttm7lx773VtPA0XdPkc9//wWkibUa6akWz6yuKth1kVIDXXFYr3ik0B2Gx82RGEcVW3UeJbqmiySkeDz68H5ot+YB0xqh1+M9NzIn6pjxYXPtJqie12/3dECt5Amdk89FGJkK6R5mIPBF75ma39XfbLMzF4dXMPUK1EIy6XDfEYR1oXlMqYhNeHumj7Lv+L2l0/G/+Pj5hz0SmB9DuxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a write-only module parameter 'flush' that triggers immediate
page reporting.  The value specifies approximately how many pages
(at page_reporting_order) to report.  The flush loops through
reporting cycles, each processing up to PAGE_REPORTING_CAPACITY
pages, until the budget is exhausted, all pages are reported, or
a signal is pending.

This is helpful when there is a lot of memory freed quickly,
and a single cycle may not process all free pages due to
internal budget limits.

  echo 512 > /sys/module/page_reporting/parameters/flush

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_reporting.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 61f7f08d02d4..05bdcf89f3e3 100644
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


