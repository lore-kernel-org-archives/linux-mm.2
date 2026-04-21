Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86A0F94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A74F6B00AA; Tue, 21 Apr 2026 18:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37EEC6B00AC; Tue, 21 Apr 2026 18:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294536B00AD; Tue, 21 Apr 2026 18:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4766B00AA
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:02:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF28713C7A1
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:05 +0000 (UTC)
X-FDA: 84683936610.23.897C583
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6D8A020013
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JFNXlWyX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cryXnIzewbC4JFE37j7BqLz76I8OG7HbHQFiiqeqBgM=;
	b=q01lsEMQJglWm8TWOVXO5K7GIr1TpZ9S6IiW2cHSB1bHTq+H/Zqs2IyORRq/NhrSM13SVI
	dWN/SoRn9pjRz8rGSsTqx/FNrIJTMPBxsJs8vIcmreWxFyM+33x8rF+uL2v9lSHgFU1Zti
	zplTpGodkfZZM6WW8Yx9cKSNtqKa8LA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JFNXlWyX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808923; a=rsa-sha256;
	cv=none;
	b=mteRbMGVUFaHqhp1/63R2YKqoBinJjl6Giy/a4XzMwTJXOiTYovwbz3ISljf0v+B8dWJbU
	6HGgP1s2QAe4crExajEB0XDWlMNLlquVKz/SBgu51fvrxs13JzAReK0lF3/UadYU7lkSxC
	qERS8O4t9JHqvLZmlhuJd3OB8Yl8i0M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cryXnIzewbC4JFE37j7BqLz76I8OG7HbHQFiiqeqBgM=;
	b=JFNXlWyXmOkYjjpYO/R1iC47mfCqj6IADqqSSqkda6Q9QNg0EEYjx7UvBI9DfJg0zaJ1c+
	6cyWrxehuG6McS5tGK1BH+ltjiEJ/b+P/REEYgs+jq5S1KUerPvtUYhT3SYFpY59Z7Uslw
	cGS/87w/YSWWlaYspvIAFTk8CwlvNjw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-27wIXct1OqG73UuP4LqlKg-1; Tue, 21 Apr 2026 18:02:01 -0400
X-MC-Unique: 27wIXct1OqG73UuP4LqlKg-1
X-Mimecast-MFC-AGG-ID: 27wIXct1OqG73UuP4LqlKg_1776808920
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488d3eec9bcso30644975e9.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808920; x=1777413720;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cryXnIzewbC4JFE37j7BqLz76I8OG7HbHQFiiqeqBgM=;
        b=TSW20tUu6S87dQcW0bk9iiAlNJ03U9XvlqG2iLf1e6Bem/U9ZIHN/48s6MARNT9CoI
         MhY1jAHWp79sFRRc5eJtLSHOYTuJy3Eb4V5ljc1aMnyOsdt70Ova4M/B3ZdyKWI/lNBE
         bP0mYORWr9ROnNBcjG4VUi85yNgUQdoJLNopD7vqM0uwILzx/pr5DSNOJqEUy+GmN4wV
         MMoLthXCUDhksQgRd6yGJLySLe7Iq+YMkEsLAsDWdMz7Nf87fj1Etn92twVgEg0m6oyD
         6/XEYzJiX6OltLT+2XNEncyEToRxyn3Smr7k1yXaiIOVflGNemwmgz9dFn9YbjsGzgzo
         wS5w==
X-Forwarded-Encrypted: i=1; AFNElJ9H9v2g8pNpcHItXRAsptn6OnH29tpsjhGfZ/pB0tiaGQ7gXZgvxRmgnbcYNlouJCXUcYSZelplXA==@kvack.org
X-Gm-Message-State: AOJu0YyGSfF/TqYkqGv8oiUaxxZW5HxnrVc7BIY2tTJWVOym9TGdZsDr
	9nUf9EL13q1aJSSP1et5b6oUgRaslaGz99QxglF0u0zWq3lkg3mHDqf0D75CmWNjqBdcW2hQsR1
	nRivI6RqfRGvAVywi1mdoaSlnfE1kxaEluRd+aWuHmOQBJUha8vPA
X-Gm-Gg: AeBDieu+B/8+ykw0/nYLvX1/jUqvH4RNJKeutbjazxK8XrKVC1JrLh+sa1xFl6fF9sI
	K9zIBkgPQA0FjmG4R0DAq2/sHYuZkbDayN/cuKwfaJT1MNirRTbyxaMtHqQ8d3r1RyJpD1JFfGa
	8CYymg3DWnoQ4fa2JrRpTOEccLQFkKJ9xiqecV1HOlAhY9jfWC6NhRIDG3B8w0FCSHl4pG5oz0c
	X81rVy7o0PRbMe+jyaGN4S14EYKAxz3noCqCkNwt7r2Do25XAmLPgQOx3zPTr/WRRPPBp9VcHYa
	D+cGKU4lqLnVyPara8n9TcVm6ewupv1x1MeqBjbg2Mdhv/Hw2TYdN5KjHQxAEVSKJ5ow5BLX6z8
	ymqmxCmdUa1aLW5z/Ypio4aUthEk/T7DH/WzC/nTHd/adbFwntPBoGQ==
X-Received: by 2002:a05:600c:8483:b0:488:7ff6:1f75 with SMTP id 5b1f17b1804b1-488fb782d91mr292619095e9.21.1776808920125;
        Tue, 21 Apr 2026 15:02:00 -0700 (PDT)
X-Received: by 2002:a05:600c:8483:b0:488:7ff6:1f75 with SMTP id 5b1f17b1804b1-488fb782d91mr292618445e9.21.1776808919403;
        Tue, 21 Apr 2026 15:01:59 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ffc558f2sm265846935e9.1.2026.04.21.15.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:58 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:56 -0400
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
Subject: [PATCH RFC v3 14/19] mm: page_reporting: add flush parameter with
 page budget
Message-ID: <abd751c3d59d5c99c1f318d5c8e9027bdb26f024.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i6RxeObmZ9WrACY0OZY1cMa-zs6GRzmLAROsb8_vdYo_1776808920
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6D8A020013
X-Stat-Signature: aaw16porzp1owft46ezsmsqwb4f69tfm
X-Rspam-User: 
X-HE-Tag: 1776808923-637603
X-HE-Meta: U2FsdGVkX1+UBx3kVaRkPtkVhIERbUaCJNoQotOz9olQGZNpHIo6+B/P4dItDQQ1abWA9s4GNQqVvPWOVzcarGf6GWJh6HlYTqbID7J/1CAGy/uBDyNGnaue8YYX0CMygssyhQWo+gEscI6EnUqljjnBh39nLQeNRRCZbiXrUGBjYF7aLtPFMtVqKs+X3yPuap2S1+6ocyPn2ceeGJYYan0DtsnqkA9lYpfPg3DM/OB5FVABtbRpmHcOyR14lSGm2/pJZDBJ0GPS1eDkj30Ukmo92pYkv5EEglrGIARM1+crA9zR227utzEY5gtvrudtzmeB1bL11LO19gdXUrG9pzp4bFF3s8bo1sMsNEnV/jkho/KtGJIfIMQR5bH5meal7XL67rZ29pJ8Pwl4bvI+9f5y3xic54e5teLMdD45SBsFcJwer8L/QiYUugK/ugLCLWxY11xb6rB7tVbsbx65Bid1bQJtvZWeQD8+5reqSHdz11YYvYqsaYeJmWhT1X4V8pe/rOgdZMSnzGy+YoKcASOb2sFt7PAsA/Fg26ZloCiVv6RQGmo+7EsC3Qbcw74Wl7+TWpJJR9YjwIHXqlgo4bsHI21cHvVdZcoV58q81f0hZ0B3323u/jdfRdxSnSmxjGfLWbLhljG+x+x1OQqRtcK+9c0sI3G1oSJ6MMxI9b4qtfoJFZK8un+qG5cPhpabRaOOUe1QKQOca7GI9sT6AuKIl2kyalJguWRprWd6uymHYIT8t7Z2CDkvkNXTqOG9kPuui8KIRHBFwVgS6OEMZhcjE0v7EeQMSdxbWfjwUytYxOWQI6TXoHKNHFUr2Hawr9HllUK91VOA8PwsXoekzHycehSj9ZL6kmbLtRkPmv7XHZyVuHQ1/XVBgtxRBYyQ4kJkyXbEU783B7sdu8oxkjbyE/jh2MEspD/v9AdjgNODbp3DIlEuhXP8iMnHBdvncVNePUwDa2pJCzLIz3B
 WwYOOMzK
 nMp8nbhzcLAZnzbz1h3emyke3inIudwujmiOuo0QwiFXFYA2f5GP6UEplSvaXBb393Yri7vqNvDNQiHh53uk0DSWYAe6Kx5exGBXh9Ra4chS60xQT1DLyESFfwJf0qiiLx7PMKhZBCWplvljnq9r11OivXEpm5cLOb2UQK9BkdmCQVIUCwJYNj33vBJQIQC/D2HLDprAWXmovwpUfA4Vieob91k7BVfEYpdHOylEKcrnUvw8ZYWzK8wvBsR7eO01FtNtnwFb/6lN4e2Yw9gzlKV8Rh61FE+tdeH3XW2lIpSuAmC7HQgQwtiXvMjh7KWTyhtB4Ce40AIPpx4PpzqljhNI/iDF8MFylCOuQjz/GvprqA+5QW+TnzesU3nzkRtqvhXg2AII0TNSjLHk8VKs4+TH89A==
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
index 6177d2413743..c09a8ac754dc 100644
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


