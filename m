Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC411CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51CEA6B00D2; Thu,  7 May 2026 18:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F48D6B00D5; Thu,  7 May 2026 18:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3576B00D6; Thu,  7 May 2026 18:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28EAA6B00D2
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFFB1160675
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:25 +0000 (UTC)
X-FDA: 84742051170.15.B78594B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id AFC33180011
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eboJ9nyN;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/zNXUvir974pwEF1ci0jhyssPrmgKAWIncWIRRvDt4=;
	b=1peUjI07LmpmMQlHvvptoIrdKjSG3IWR0adyfhqi/owTKbG6BdE5TuuPJOsAiRqYoR8TLf
	zvJQgLbsd7aGPqHX+s9mk1/caK4WqzAxi6CFBsjHeVNodZrjMZFYK4BFgzmNgU2NUPDJy7
	41lCjKF7sL8EivqbC3VqpTJ8CMz1q7Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eboJ9nyN;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192603; a=rsa-sha256;
	cv=none;
	b=Qp3ZeWNiccmZLqd5agntBJDI8AVBvIPLkepjTIZwTDW/JRS0TrGjh5Xp6voX0ag/6y1mH1
	kpmsvPYqL6jb3VsfHJ2jcWumwMQGXlb9nx827zPdCFjraJHiVRfSWeyb/l9dBDI+XXovty
	BoBfDYUs5hzv+WEq08ybP/P6WdprSbQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b/zNXUvir974pwEF1ci0jhyssPrmgKAWIncWIRRvDt4=;
	b=eboJ9nyN0J6Xz1uPqmF0zIYREMUnd0WqRIpmf5D/ymBv98xSxNRenfH4edBSTxYjLzUy4i
	yrIxkVfdWSFHUB6g/ZVl9qcaVgXMvqHcc4+Hpuh2rrFGyUOUO4CN+/qUhX/J24O5dWX3cM
	ch+UmGI6YECEFl0LcngxHFKnqTsd15w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-JOBGdYMyPA6CHoyfH2g5Pw-1; Thu, 07 May 2026 18:23:20 -0400
X-MC-Unique: JOBGdYMyPA6CHoyfH2g5Pw-1
X-Mimecast-MFC-AGG-ID: JOBGdYMyPA6CHoyfH2g5Pw_1778192600
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48a55de6fb0so10694025e9.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192599; x=1778797399;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b/zNXUvir974pwEF1ci0jhyssPrmgKAWIncWIRRvDt4=;
        b=ITq9JkyAtopsTN99BsZmgoD+IvbBoN9vISZdpYmImtzq0n4QTFK5+yIVsRF8lqyoUg
         yfh/DwZSaFD4B5GW0ssFXmq4WrKK8wtM7BIvZIZY1MyRgyKKQ+G75NeTgkSfB6TdPWq7
         E0zRs2SwWsCDQvZqQjDg3vFHdoc3HFk3qddOtSzu5u5xWehsOv30F+F7br1rRAXDh+2B
         TqmhSXiQJdDelYCIzZhSIx3wp0oyALWoKyxhnXPxQO6JuNFGNm+2QxO1x5bebPzVy2ud
         tsGsac2rPLPZepUjShql8dh/mTo3QUnePcqDuAkOk99NOawrVGoqXDYHABkq457IfZ9u
         3QUg==
X-Forwarded-Encrypted: i=1; AFNElJ/Nbkorm8WxpD8MCP94C/Y24IE+X6lR8bYbFaamBv4Oua36RGf7UkZc4dGWxJj7tFErqYLRvEhAHg==@kvack.org
X-Gm-Message-State: AOJu0Yxw5uS/SJJXVTYY/nXsXcGS7xwNRCWnzX/n+Ak8/DZbL3BYcXoq
	EZq75cQbgZLzpoI2TWpIuu6ru/wbcM9szwwJ65nkr3vYHyy14tE5gd5NxSDxtmMhY72CjY93uJ2
	3QL9EgJ0OXjHji5Bygst/JK1geC1clGZKJt1KJUAXcRJ+vHpYrtfN
X-Gm-Gg: AeBDiesJtVbDfxJtNeLis28glt6a6mRLLlqpNZAlYnIdQrnNxIf+W7ruJTErW4CjRNS
	3/iVZIPn8Bd+4iGyQ3sSOPJI0sVa+ViO0LBwspVEHbSe7gKkXvRSWEjiOOZxrI6r9C8cFOy3Jy2
	PkA9lQ1r0OgrghNhpYD+HXwzGKTIdix2vjIR54QGYjF5vbizQ8dg1OZbrL2XeSUjhNosbyX+Z6d
	VWxDyuVWXJYx+JVaPTlfAv8cGaJXwVfbt8U2Hqqa5s9NPdLVDLKuhCWAG8xI0pXNtJCCiV66qmX
	ddjGvUf9WCMmOcSvx0aqC9r6TOr+edMD0HG+rqDn1CaeefQ9u5/fYGspPbVs+/Go6HFEQNNv0bJ
	ch5DpuKGGbJDjkbF1ICPDtsjXrqMtOKaCNZ6Zc0wy
X-Received: by 2002:a05:600c:c094:b0:487:5c0:671f with SMTP id 5b1f17b1804b1-48e51e1a7c4mr115499915e9.9.1778192599399;
        Thu, 07 May 2026 15:23:19 -0700 (PDT)
X-Received: by 2002:a05:600c:c094:b0:487:5c0:671f with SMTP id 5b1f17b1804b1-48e51e1a7c4mr115499725e9.9.1778192598907;
        Thu, 07 May 2026 15:23:18 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e539109b7sm142179255e9.15.2026.05.07.15.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:18 -0700 (PDT)
Date: Thu, 7 May 2026 18:23:14 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Subject: [PATCH v5 17/28] mm: page_reporting: add per-page zeroed bitmap for
 host feedback
Message-ID: <8f7e00cf0ab76d2d393e043bf82cca32546e9e4f.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RtNwMGPpoeDbw9rJxpeTuQVf5g6yuWpp67r0E89oGqk_1778192600
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AFC33180011
X-Stat-Signature: 1zqzrefgb7ygkzsdedyujiby4fepmp6n
X-HE-Tag: 1778192603-546349
X-HE-Meta: U2FsdGVkX1/FeuwiX0mz1uD8Gg84ztSrM4ph9Ci0he378LqBgxR3eGPF/ipgtgg2frcW0+GVcOOxP01IUz833fAxhKKkcaZBqnztYG98s42LhPZjSiM1Ui/B9Lz0N6ohkWMXbs7UWmweANRVdF6wRI760wLXtGaw29PtFwUWHEP9yCRV/KroEj6agw+eNwrV7BGOmifUfRwWlsrfPmhw7ikZaou85ubUD15iuvhIc1k1Xk/z42NrbikxDWYghrOVCfQSXEhY4H7sQBzMODIzlRR/moKLIwU8UJWBwBrK2bdFjdS6m1OnsvzKyEj2eArh0LeoHwKhSqUUjzlpUJfcV/Q+OrOeWQxH8/Bo2GEluu/I/gz1KbMXkpaZfXnjQwJ1H7yEL90lEUr8lPJ4/QgmafxiIkQsN/hYJwbnL/jE0+WXYopalr/YxgpXa7vlaqt92aoMizQwJmF+HcI+hu1kJbDsCZboNJWAs1F3AgOXxtbdq5aZRb174TL0X1XnvowBYNXbvgG153LS2gcKtUMqi0cvvGODUqxUxRosMvkL7NfbXofJBKYf+l+ZqFz21/sAUVpLxgaqRUIgvjjGXeZvgqEo/QP4lHbKDH4X5x6lMX3/ypTkjP6FmVa8XwwYOzk1g5E1A/vHE09tZysolQz+JjOze44ea894tjSE1ph2ecqXQj039e9m/aDI/AUIiTNh4/lecZ2YoFG1fi3vpVnsJIxj28ny+AwS8aBMnUJlzm2fKmlHVmN+kIE67+r2Hjr0sfD94qR39O88SjIEtxUx4CNTCXjFCvmNLeqZ6r91+lu3rHffItaM7+gEyKzd8JSA4TKxakgROZK0N0LS8NC+WyU7GnGSFEOs+iqt+5cFATtemdrSprubsgiTryT23Oo18ZduqDtOlfNPGNL3u2kisOep2leTW4dcFbbgq+rfhMcBRnZTFdhFNzn9K5BaPxMlZ77lIF87R8TXmP6s7Az
 6JxiinBZ
 sppqi2g53Pl4tNOIjUbjCBmQR1SamtA93oSTX2+2vAfiz10FC3wgAKckqjoqhIMNHN7KvfGd1Kzvz1FyXnaVUNet4lb2PFZw/otHqJCKrtt4L3U0H2mTkTS9MvqKFPrWyY0cZll5gpc4pK0qIkJZ5ejHzioPh8/lyEhVvS/C4NXixTMItmkm2Qr7RPkNPtHc+tPURWaVguWT5Td9F4zlnKjipwchQSl5QckKOC4iAUCsPLsvI43IaUyGE3xJ8xizy5YA0i2UyZqXOJAzg5NiRwpibH/dAj5Aj3cGmiHdWrM7iSyZBVabXJsEMYE0E1Y3IWl23ArS9VEYk+L7RPywThC+2RXKMrVIyEhIUa9xhul3uPT13h1AaPoZzRw==
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
index 81e5a2819b3c..df929f682901 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -16,6 +16,13 @@ struct page_reporting_dev_info {
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
index 1f48fcd7c042..8137ff50ce1c 100644
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


