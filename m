Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5988CCCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C3AD8E0039; Tue, 21 Oct 2025 09:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49ABC8E002F; Tue, 21 Oct 2025 09:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363B78E0039; Tue, 21 Oct 2025 09:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22AF88E002F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:00:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB3471404A1
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:11 +0000 (UTC)
X-FDA: 84022129422.15.5717E21
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id AB9DD140005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UfLuGWHV;
	spf=pass (imf23.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qyA8pCV8ZcD9NKgO0LjiJR2j4wGQSpAi/OG88VVUt3A=;
	b=AbBUHh7vBuJb9gE9tMdACB49d6N2lJrVzMhaX6BuuV411NbCa8rCAUgO7iUJV450zv1m6D
	Qo7HGh8T8QVdUERHW/MSTAuGLzIukTAERbZPk1S53Q+e1sXT4fiKwPaYh8mwll2bqwiF2p
	8tDvg5u6e7y+alSLIvIPG4JMV+H4Qfo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051609; a=rsa-sha256;
	cv=none;
	b=PTrs5t9wCdeGP+gMRfLUPEt6qlEbvsJRRgxN68We4tGAgOk+EVk4HGnLrs8dWdkkxzsqax
	RSF3ncniipodadXFBKViCkvn8MFzFkRv4PwltJcElu/e9LzquMPt+F8tYjPMd0wZ9repl5
	+QhURoDFD+Ro80JdhlirvCTMBc7gGic=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UfLuGWHV;
	spf=pass (imf23.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qyA8pCV8ZcD9NKgO0LjiJR2j4wGQSpAi/OG88VVUt3A=;
	b=UfLuGWHVVI4j3OAL4UlOjsi326icFXDrQ+ldKy8FudYW0csDT2nzCRNvH+GCFX6YY81Mxx
	E6YAkfjCtMsaFtlH+QbimJwjKj6BZ/WnrkSgcM8WZWHHMrXptlH/GL2G8/XIYIboddjEBQ
	61ItdreV5H5YLvML7QskmIq/bQVu3tE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-IvBnNLQ6P82__MQpQNxmRQ-1; Tue, 21 Oct 2025 09:00:07 -0400
X-MC-Unique: IvBnNLQ6P82__MQpQNxmRQ-1
X-Mimecast-MFC-AGG-ID: IvBnNLQ6P82__MQpQNxmRQ_1761051607
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-471125c8bc1so61196195e9.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:00:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051606; x=1761656406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qyA8pCV8ZcD9NKgO0LjiJR2j4wGQSpAi/OG88VVUt3A=;
        b=X6YRtHZdgaWDEFlVLZjBBUwg38a2/QaOaXpS4eRtN7t74e/EydlgEVFb3x3LOZXN3T
         eMJRo3+8AY/3Y4hpCWgTvRhVCDwVXluY2SMhBD1OZ6tBu9p2QmhnUNWC69E1fv58LI77
         48h4WQvdEnB1kNEKUDMc65tNfEfYWLzqKmCVioiUx0NSvJ845ViVVeihBfWs9W8GZOjS
         vQkhIH+ztwuQk91kxwHMLwKEkaFQaEd4MO3qLpyb0JSTseyPW8Vvo0wUM3NNQJuf+ctr
         bzzdrRQOH7IsGnJZe+/rIBiIhOzsq1+jIO69GVmgDmtRVfyQYrMZj4umWyZSSR5VjGCu
         2WzQ==
X-Gm-Message-State: AOJu0YykuPbmShN58NPSQUC6LIBldDX+SFQsSFfcbqL4ZV8vr4EBc+jT
	b95dRkIZ1ZsVIQnd4VCoHLrB3hUTFPsS5R2759Bz0+p2LiPaNle1MFbwHN3QAhgmgt8kgM0pz6u
	+nb41k6n4X0VGV7LtB2sS5EyLvglTzJ9Xo+8veqfsdaNfx/Qn4ZLI
X-Gm-Gg: ASbGncvWf68AZT0IDZ8DG8Q13hgpvQMKpwNQy3gchE2xr3Kmdi7HE0VU2rB/HjurHPC
	NNwG41zFc//Y4T9YmMR0nF4xnuew/eTe8b85W+PCU0of8IUimAFXEou32bWEdUJ5aV626BrtdPC
	VVXS4TVyW1NqGyUBNzA0enGgE8GkRKy5KhZortsd3zdwclduWvli4pT62A5xsrtQBjQAbX9A7zV
	1k10nrU2MsPzpMuKHK37ibeBF095fad0Rp9ybkQwXA6US0vCufIHIhek5MIfIhmdmsXNzvrfkrA
	SP5WSSzF5twUxycK+yZfExr+jIH2NDHrghXn8LfDcz1vNDntOPWPbE8ZIJFTDhA5dTmOUPwRa2J
	LrbatFFn4lAJQ5ETcXR/59vrtJ1E3wxeq1AAapCqhdO0hm2EPZyK+H3Fh+YHy
X-Received: by 2002:a05:600c:64cf:b0:46e:3b81:c3f9 with SMTP id 5b1f17b1804b1-471178a80f7mr116647365e9.17.1761051606584;
        Tue, 21 Oct 2025 06:00:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbkCxQxFQj6JOplMg8GsGSdkTVrb2edAU/Gb4AKN0gQYX2xa+Zptcgj0djfMLZWDQvHioQbg==
X-Received: by 2002:a05:600c:64cf:b0:46e:3b81:c3f9 with SMTP id 5b1f17b1804b1-471178a80f7mr116647115e9.17.1761051606167;
        Tue, 21 Oct 2025 06:00:06 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-471144d17cdsm278222645e9.18.2025.10.21.06.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 06:00:05 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 15/23] mm/balloon_compaction: assert that the balloon_pages_lock is held
Date: Tue, 21 Oct 2025 14:59:20 +0200
Message-ID: <20251021125929.377194-16-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: csTVVPvF4BXGtO-Y2VCeSGD9JaW47PAETrH_oCi0reA_1761051607
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Stat-Signature: oqsc8rn89y43j1rwnigydqfbdg8y78ys
X-Rspam-User: 
X-Rspamd-Queue-Id: AB9DD140005
X-HE-Tag: 1761051609-100619
X-HE-Meta: U2FsdGVkX1/MQ7PC1v9xZZzFasNi2nsQO2A/D1gFE071J7/V3HlcayGYgsLrUWBcfA1HjaUGA60nY9KKtbS7vJX3kfbN6Y61xL4j9VU+3yrK+Wlaw+mi4KUJDbv4Xihbkp64/kNeUOybeTZR8V9pkMsx3JKiLf53FwVHS1o1fAc8VdM4C2CAeRROwLKw9hIIMppOWdY0mGOS+4u6mQq5N/7AQLHZ2SCITINXlpGnmIMdoCISJqFXeMPixaZRpQpU9hvN3+5w0KXOZdv7JzcYkEMxQ0MJdNftrFx4Tcj6E/lNRVBGGJLI5rAA3aip18CnaFnxySqeNvsz2wF0/tkhPJe+yjRSy2lLsV+6hU2fVgQGL72tooMD3BLRnAgZCDEUOjdS8DZEAFRrY4441JqcdlI2R7gnI85udjfWxTSEI1VlVzyZKPbP4D9RVCXgxUmr/gUmuimJageKjJ20Ta4d77AOxUDjeqPHyXQmsHio2Z91nUR6leM8q/AgSSMRtD8MUrP7MnqGA8gNevQ1nES8fd5C9hYTvqwDJl+T3rIqRNif36wCBWpTdf0bVNVJ74hOb56AxpKL2DDnsfJGZUcN9EHp5WLxFEMUWDM6k35tKBjSwi+++I5Xoen4qKUJVt/YbCRWdalcN2MBPK56Mqku8AXW6d3lWWrjW42rtWUy4w+YKjNgOwLQrGq/lHuJJiyKIv1AfBpBRl02GnyZBb/PtslDQ69LWEBnh73t4mqB4H/joUcj6v3xvt3tnvO+Hx4nQQ2acbJYCIlOsrsHGC2ZnL8V8vNfYhLkH8bBcd8fIZqQmI0IPGrZ8GDTuYK7EtNaRRnHyU93FnZMjobUR3H3Fc/M0BN/gpxtL3TFeqZvA18Esy5abHeFXglZQVq8YM9ewQRsWRqOvt4ElpS0WqBOqQqtPcTA/FpLm7Imx2Oo79dCMKmB5e0yDJ4iI3YLt5zBXrfBFwFpvQiOg/lEVJ5
 i6BCTpcl
 Am5PrVgV9Z4kXfk5MhgoZOgjP3bzE/v6XYh6/hAlAsOYABEe1GjdUXqsD2+GcgQfvr+tUTYJFrmVefcKAyrrTAnXor9Ks6Ri6E0dUEHJqLFHAgx5hzMIOQDxnWgMMDxhGySl3Xx+u1pc1CYEICTT1vbI0L+2REEILWqooyBVJEVWK7Tdt/lt3C6KfL9Y2xXTbVi2eD75OtcKUS1yjwE0qpUqmuS+0rlD55MuV3PC9cy8kBiSKbgGD4m8qmb7YZXZI54nWynHbcqpyfMKxZ+FOTv+/6sUl5E+BJuOA3lkv6Bvz4IjrnxRyLtF1Ft577+CzlejK2hKcCRC2ovU9oiJsUhQXQFjTe+a1VXflF+yp5vrCySV4lGKrixGM3Z7mYsB8Sc3JQZo/oB38bHNz+m5X5wcWK0SpJnmBLT+VwB3eYEjB06WEJ3C5SfbdZNOYB/fs1z3vgDLuZXYBAt7yIxVb47XGrtTHC+fM7fLNaHobqQKqm7Pq/8vWSiSVj7Zt/SgA746Z/rVzYipOzq7QujJiEqrZn0Xl9uu3ghtOjT4HQorhJEvMbKdUCC/RYcPnMfUw3y5F4ZRZ9vEt88Pu1YdMQrwHPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's add some sanity checks for holding the balloon_pages_lock when
we're effectively inflating/deflating a page.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/balloon_compaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 717bc43732d09..f6e0582bd7ffe 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -33,6 +33,7 @@ static inline struct balloon_dev_info *balloon_page_device(struct page *page)
 static inline void balloon_page_insert(struct balloon_dev_info *balloon,
 				       struct page *page)
 {
+	lockdep_assert_held(&balloon_pages_lock);
 	__SetPageOffline(page);
 	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION)) {
 		SetPageMovableOps(page);
@@ -50,6 +51,7 @@ static inline void balloon_page_insert(struct balloon_dev_info *balloon,
  */
 static inline void balloon_page_finalize(struct page *page)
 {
+	lockdep_assert_held(&balloon_pages_lock);
 	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
 		set_page_private(page, 0);
 	/* PageOffline is sticky until the page is freed to the buddy. */
-- 
2.51.0


