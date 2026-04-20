Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D5FF588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856026B0005; Mon, 20 Apr 2026 08:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8069D6B0088; Mon, 20 Apr 2026 08:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6696B0089; Mon, 20 Apr 2026 08:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1F06B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:50:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E3996E55B3
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:29 +0000 (UTC)
X-FDA: 84678917778.23.17D1BCB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 722C0140009
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LgTt0YwL;
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IelIqVYy/AcgVP/OqP2S72GFWZ6ux/wlNrxvOYGdRd0=;
	b=wiMRdYRbxpeuTbfl/VFHyc30+8F2rgweENiHuv16vdDyaz4yd7S5k+gN7/kzwrnVE1Vt5w
	D1j4xzIcuvJvXrv8r+Okn+3PD2nF3Eyuw7WOE7FF98FMJQ0Qc3gDpJTZr3jrndI9u1ftOP
	W9B1u+vtSm77dZz+2NPYm6KR7vwKSjA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689427; a=rsa-sha256;
	cv=none;
	b=xSj0lI5qr+DebH/EQR5eIp1ljXzfGSO1c0ZhjdFBhpZv1My8r2YL+/FSo58gq2nli1uHSL
	/ErbILstPEGmpHzanS8zi/5NfyXTM1S6iEMjxniPXktpK6M7GISo9RF7HjdDJoSLdSj0hh
	Lv0el+zUZdKed0oIONS7ijIrTGDVG3c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LgTt0YwL;
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IelIqVYy/AcgVP/OqP2S72GFWZ6ux/wlNrxvOYGdRd0=;
	b=LgTt0YwLYx5MFxdPs4yZlltbV56Hlt76MCyM9ooSt6+5a8r+N1XfEWQcOYp2Oja6hLS30S
	RYF6af3rb8tnZ5S58vvVJrCUwVHxAb0aCJRMRvR5n8sS9TDlab6RT7jTPFJ1UokhoKtxM6
	+2ZzMXZbA+SmPXbuQnKOtNiPozzoxBU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-PlEqS1sBO-O9Z0AVn3n2YA-1; Mon, 20 Apr 2026 08:50:25 -0400
X-MC-Unique: PlEqS1sBO-O9Z0AVn3n2YA-1
X-Mimecast-MFC-AGG-ID: PlEqS1sBO-O9Z0AVn3n2YA_1776689424
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43e52dc8a04so2741259f8f.3
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:50:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689424; x=1777294224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IelIqVYy/AcgVP/OqP2S72GFWZ6ux/wlNrxvOYGdRd0=;
        b=nDhCaDlG1kDbkDt/OlZF01K8Yz+LSdfHjjy4p8Xjl2vBAIj6waRJ+SdeLMxsRyvp3O
         SknZ1Pt6OJ023MYjBCj5NyzsUBeQ5GIzRd1nIPDGxEbKXFokBclUddXR22U19AxGxrwk
         EjP4ishe/MAbeOOpzaz9Geg5vajojepgedNvIgRkYXNwt9xqaRaxDELGwd+KNwXztYcv
         3DS00q5Y2A1QwCllGmCKbYerWc/pRI7WXJ4T+ihC9OlrQsl3k4g+892pKrQmux1Wuf8J
         FEHNUYOvYCtScGlEviyNx0HVDVYRYQkfx7J/IU/2yAQZVZm3yXsrDIOjA8QOsPtuQq0D
         XAyA==
X-Forwarded-Encrypted: i=1; AFNElJ+e0OvxACHHX6Jbev8wqupfZabRUG8h1d7r3v8920JVuOZXKpvQWUF3+qiWw9H2t1cX7fbgdnYoew==@kvack.org
X-Gm-Message-State: AOJu0YxXMg23upGNc6srTHETfjyhjrGLQdRdmMk9Xg0ZC44L6npbg2SL
	3fvy1tf8geQL0gejhwQ0Cog9AQgAfjRf+tiziM7ysD1vom9B8Q9oL/L9aoJGxmyEnE++HIf1uFg
	Ewoe6ZvDMbyStqN/GSi8HiJ3nMNEUH4grkin/cZBs3uOnjEHqUJR6
X-Gm-Gg: AeBDieucGvozP0FPEZnINIphctraW1JNn2xQ7tCDTieR/txNce+XWuwgAxF9n4Irx1f
	rRa3CvJaOdWtvZOpUPGLZxHI+kQ/Tihg/FWWEnhGmrZFCX32xNHKao8Z6lNod4luvL7tpTCerIZ
	bfkVbGvkkyVpBgBbzeTvAyttPenAocDzUeFicn5LSdDz9hH8ZbpX23+O5yo3p4nWj8XQshoiR3V
	IRkSU+86sGZcic3DD6x3xXcg7IFWYcVFaEEd6pjrVaoEERJbys4zrX0Kn0aT+fnhu1ZhFnwKeLW
	e9ij/+chj5+9S/s9HtETY2HcAd3z464+7GA8ydikYT9dLmkBPSnNa1WvlrWzDK0r4Bq+zQnUXeU
	wbG6GijTLXm2JBQsbjzzJ2EvDZ6sVC7v8EafOI2fWyboPIgtwAvE+XA==
X-Received: by 2002:a5d:5f89:0:b0:441:1c95:17e7 with SMTP id ffacd0b85a97d-4411c951810mr250601f8f.15.1776689424162;
        Mon, 20 Apr 2026 05:50:24 -0700 (PDT)
X-Received: by 2002:a5d:5f89:0:b0:441:1c95:17e7 with SMTP id ffacd0b85a97d-4411c951810mr250513f8f.15.1776689423506;
        Mon, 20 Apr 2026 05:50:23 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a397sm31385276f8f.23.2026.04.20.05.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:22 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:20 -0400
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
Subject: [PATCH RFC v2 01/18] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <8fb5a2dd7eee6fb8ead6b2cb84dc5cc0c45a0f32.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bnvGrn5zIAQbdFX2oyNH_-XLiTrrqrBo18LJsBiKIvM_1776689424
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: y18uxx4tysf4wgfis5wyzu36kjw6he7j
X-Rspam-User: 
X-Rspamd-Queue-Id: 722C0140009
X-Rspamd-Server: rspam05
X-HE-Tag: 1776689427-982496
X-HE-Meta: U2FsdGVkX1/fja4pkdseWeCM0Nc99n4dAEkhHs58lNipX605YjNtU4DqywhnybLZqX711xqZpVymoNnz7B2fGzPOXIWl4tgjT/UPjIX9u+RbR6IAFyuC+gYPXq8U6CzSbU5WWZAP5finw8Xege1SMqkkXEmI+AjnyHIW/6mB8vmLwGXykuaFi8CfLpW6HHa6lq7AkG609zJiirx2FgwAedmQ5fZjyTB0uWSkzYmw5P3igtzpxS0qqi6liMhlahIlCD0CvR9r+HFSt2IqWwIrf+nr2R1jbyy2bfnvtaRKeXYe3hZ6ZimvY3vnf7MDFDvGWjm88grkgCyY/ybtJrHJy9Vrxtwaxeh7lQQkMb+DVuhdpsMFPvRseZZ/ojZAG+JQ6VBnME+a9Ika17+MHgnSI+jAKRqJIg+4RJjQgbyHnl7tXiVmlVLSe7BiSlHP+n0ymA8mTNC8M+OcEZZZKejAMM8S2HsGovuw5SWNqrgmYKIh3D16wen4yp/6+H9VJ5kQu0QU+9tgGLWaRXg+1IKx1V+0v4YjWcScJypAMR6Ahz5Sd3KKqwP29xqfVge67PBj2XpfFt8CoJuskZpJdckAKz5fw9gkVRzOWW9n8wq3N6yGRwz5kktyQu2nzUuDCV9g3EG3IiEUZL47Vmt+338qsfZo5fiQMNXsJruXySZjHfM5N/R3/NW5450/fZbmVDfjubCdt2bZVTG3l2HlxGjK2m1D2vMzGUvNVmAaEXT8pgdnVnWD/damFFkXurl0ZOtZKXCutR4jLUmpsYoSvBLmBpDhYILfnxzUbe29t5D12cvq3CWK4iuPaXQr5Yyl779PykP/IIQOnqIIMT9FC0+3b292n8i86GhnLqQFCEJn1B9xvGVJkVTvNgcGVtavqHzv8y8FrgAQBjGyXF8qSPtXd7zVcufz0KMECwymboaYTQS27YoO7yPtbEx0hoaRpCiEPOERN2HEpw1wpcYcALu
 sP1LawE2
 pyqcfFhOmw4LsHHJFOBTLyG+9jOx131cIKpZYd3ck/vizHX6fG8MPNI68Zpv7ZEBCNpvTh0gCR3YA415InSoEceL2Far/kE/2g5ZiDh1611c5dMotIUzdkfSREOOivdIW1v7w/y83Ltda7u0tKT2p+cBWwDWo28/ZV7gSEy1EB1kfXDj8gSypoR2cdvie5MDg9EECIox8xZTd7cOyyOIx/BPZ69ps/9IhmoP7nCSxbBMYLJgG0ky91N8Q/JFMhbnm2yyAG1kGGXj4C+sze54bun853ADZFLGkGEk872m4nQyHCC9Bpt618ueB0RIb6TA+4hGuPRDTcUbwBAMWiuXZo77eLIEZ6FbfGxUSIhRq4H5T3+Txa71uWtqiTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a reported free page is split via expand() to satisfy a
smaller allocation, the sub-pages placed back on the free lists
lose the PageReported flag.  This means they will be unnecessarily
re-reported to the hypervisor in the next reporting cycle, wasting
work.

Propagate the PageReported flag to sub-pages during expand() so
that they are recognized as already-reported.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..edbb1edf463d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1730,7 +1730,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, int migratetype, bool reported)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1752,6 +1752,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		__add_to_free_list(&page[size], zone, high, migratetype, false);
 		set_buddy_order(&page[size], high);
 		nr_added += size;
+
+		/*
+		 * The parent page has been reported to the host.  The
+		 * sub-pages are part of the same reported block, so mark
+		 * them reported too.  This avoids re-reporting pages that
+		 * the host already knows about.
+		 */
+		if (reported)
+			__SetPageReported(&page[size]);
 	}
 
 	return nr_added;
@@ -1762,9 +1771,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 						int high, int migratetype)
 {
 	int nr_pages = 1 << high;
+	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2322,7 +2332,8 @@ try_to_claim_block(struct zone *zone, struct page *page,
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
-		nr_added = expand(zone, page, order, current_order, start_type);
+		nr_added = expand(zone, page, order, current_order, start_type,
+				  false);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


