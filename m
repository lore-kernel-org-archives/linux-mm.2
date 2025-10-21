Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71204CCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3CD78E0031; Tue, 21 Oct 2025 08:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED6F8E0030; Tue, 21 Oct 2025 08:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9EE8E0025; Tue, 21 Oct 2025 08:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 852398E0025
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:59:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2577EB9ABE
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:51 +0000 (UTC)
X-FDA: 84022128582.04.6D8681C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id EA11D140011
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H6Fm2KWU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxQnhgSm0DzB03k3ShvGshMJPsSCnBiKfz0W3WaQRCE=;
	b=09W9C13tdUAv2miIQfwNyxs9QZ/8QTMgpp0rcfDcjxyvkFDXYz9ire3mMzgVVBgswhaDaX
	BaTqD9P0H0e2/7FSfT5mcYIWXtxrtRMd+vagMe0c2mDbQrRV2zF3pQyw0Yl0b0B+HAz4b0
	S2Elmoml3QhYHwbYqJX4/gagzHkZ3fA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051589; a=rsa-sha256;
	cv=none;
	b=FZ2cq9BA0RRgsGr6U+bNmq/HxNifrdC65MAw5tGcJScDjwCiq25O/9AinybbSQM1Jy6ddj
	dCya/+DXN93ls2nvRDhiopcTU+JmoDHjauJyhhrHnwwOL270uhCmOKqlywQ3mq1Km+MZvG
	KpP12bdgvv0/CDxHavCvQTcs0/bxh4E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H6Fm2KWU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cxQnhgSm0DzB03k3ShvGshMJPsSCnBiKfz0W3WaQRCE=;
	b=H6Fm2KWUkxzGRk0WbCBYDGnDoL/4J6O2EWKmscYlEJ+x9BEdoYwYYCd3crId34Ve9zbbfb
	2/bGi3/TxgxFnmr3DdebT5GZv5kMX5EL1+V+lBiHPYGiv6jd86N1SolH8wD/x3HIYMvHYc
	k7UAmAJanB9MwRAieHJTru0q0417Fiw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-chxCuemTOwKPEhBU0-8I1g-1; Tue, 21 Oct 2025 08:59:47 -0400
X-MC-Unique: chxCuemTOwKPEhBU0-8I1g-1
X-Mimecast-MFC-AGG-ID: chxCuemTOwKPEhBU0-8I1g_1761051586
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4256fae4b46so4171104f8f.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:59:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051586; x=1761656386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cxQnhgSm0DzB03k3ShvGshMJPsSCnBiKfz0W3WaQRCE=;
        b=qSao4EpW/N+2oc10N4BDRWChJZQLC61uYps0/pr3YbF23jAxWz+OgWhv+GP4XC8BN4
         0F6c9cVyMixFRsPn/A78crUuXcbQh1M+XrGmLn7XNI38Vyz/dHC7t2ruIO045eHWXi2Z
         rQvklq+l1MMt+tSv+e9fXlGie2ICu2QAIfLbEYP82KCivrWDBqN70GWcE7jvCdSJKIMQ
         0ojc8/mg7X1qyFuV4LgCyYhKpT0BSYfuZGUJ7C2h9NeVCe42pMwSp/O8uew4flMobubM
         bnRFsDyqF9D7cuKZDDs95jJVh9sth9Mk2sd/QjTRptJct44X3Ho7AZ4CCqaHHVHyOa/s
         Kl4A==
X-Gm-Message-State: AOJu0YyJ2H51qR4T422YdbhteseYQxmZS/Kft0fhUHLV3Ud3l6Im0h05
	Kv27FEnzQ6YziHkJnPqWVcPjvB3Z0obd7le+/fu3tOFIJBFuZycXBdp15Zk00wc0+zImqnKEeVC
	UPbavbNS9qqfLnNcNf0kiTviJDvv4z161TlnZDnzfwN8bAbcJEWQA
X-Gm-Gg: ASbGncu1Uuy1/dVqQDzhOKdgX0GGgWd8Ycz8k/OnrYwgBhlMpkOE5W3cw8g+rT70WPq
	FoPU2MWiuF1NmrDZ2YJuRt8mfwlSkHtP54aBwHIcyfp8R6Vy1i7uDoKYaCMUnEy+VlZRxkzPh3t
	CqK25mr5t2uz3v/04GZyejfADlWarWXYwRQ1+sp/UWErG+4WV3r8RbiuXlvGbBHWEYXbhKJXcd5
	0yAyBhFVxi5Zma/nLE/IWKG8q9qgAYZlz5MLdzmS4Fq+winqNEnPFVHhJ6ccKIqOIXX6KibldRy
	dIX1TmdDMW42YwQLYk7vT80H88FwG5MnIuP1Zko9xvW6zJzEUhXD7rsCq4+1LCDAjP5cUvtifiR
	EjLE84jc2Dd9oOiMLzhT6jxOd06xTgGH0C0idSV3Tdj2+gkGml+HmfX34F5pB
X-Received: by 2002:a05:6000:26d1:b0:408:d453:e40c with SMTP id ffacd0b85a97d-42704d8efa0mr12411515f8f.25.1761051585855;
        Tue, 21 Oct 2025 05:59:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEOtDIfhDIzkXczwnOUGV3QbWhaE/6kTj9DtjKKHbsfSDizDdGlR5kALx8VAPeRCrHUv5bhA==
X-Received: by 2002:a05:6000:26d1:b0:408:d453:e40c with SMTP id ffacd0b85a97d-42704d8efa0mr12411489f8f.25.1761051585441;
        Tue, 21 Oct 2025 05:59:45 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427f00ba070sm20517572f8f.42.2025.10.21.05.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:44 -0700 (PDT)
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
Subject: [PATCH v1 06/23] vmw_balloon: stop using the balloon_dev_info lock
Date: Tue, 21 Oct 2025 14:59:11 +0200
Message-ID: <20251021125929.377194-7-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Jzfgf_Mh5MImMRQWZH5ej9GNoPU3lPdz4SHSajb5_Rs_1761051586
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Stat-Signature: oo8nyrrfqq83m6jzwu6ugrma5e17p4di
X-Rspam-User: 
X-Rspamd-Queue-Id: EA11D140011
X-HE-Tag: 1761051588-517124
X-HE-Meta: U2FsdGVkX1+11SiBCQ40i4OZEaCQsfBA37D0cr+kSVRDLuUmXNT9gaebi1m2dXmK7wWh+e0865ZzzNbycnpWVRJQAJO8XG6peM70e6fVg2DRvqa5v+4Qt4/t27WVMDToKRwk9A4FZAbA56rC92zRNBv7C8bBbAVH5cjjwxL9l2Q6sHeILLZcL4QHdwnS5BVhTj5rBGn8xf/ul0Lwx0KUBzXWT5Agg/bht52NvTJ85cIBg/lc7X1AWyMAsalLYg4v/2FqgbhncFYwnWUc7P4yPe7T8M9uZfTlhUpCniV3GkcwnsnvZ3mqe2nZ3jkMTXS0W3YDQI02RR3zacrCVSORoOZ8uJKFBXR3C7ukLvkN5Y7ZD/rGH799ogMDvGeANzPEBnC7VTgYw3SQwOKRTGDdBVRiHllJVWa//UD1PPrXn3i/9/lcTt2bDFPgZ3nUxbfiGKoGo5RqRZNrQ+w9guUqA/wZm8gQ726S3AmEZgiEx9WFpJ7MIxHJy+10prhvq04C355ropGc3YA54XkSISvBaVOhkbCGXkK6rFw2Ee+STRJUP/802iq/no0FcBbUhslA1uY+Ct2dYekr9rCQYnjn7mI8Kxqsk9vjPPd0jIh92wXcoOPfdrTA8U0V9pkfJQR4yBZOHTf5GLenCtZNlwXa5NpRCILTDh+0yhDiV3iXXynwi4EA8v+PX3Sdahg1XmeW5mDYwP/sR7I4bnJ2JEcr5abBtpMRWGRSZS+Ac4AtB2wNjhozpY6/U3zkUvgHrmwfP6LTPgALmPx0KVs0GVWxr2WByZsOl/VFShr+J9Xo40b0Z/hqK6yq9ENkrvm+X1J0E0ziYoeA2hZsTOiyDftavt8UbLVaEGrow2zhhJSOk+q4qZvmi+TSh3CRpf1W1k2TG4BLAvva+BJK41yqN/rrF2St9PUkiMdFAsKFvGFiVVuFVjifqHMHiqEhBhp9J0iqw6h70F2E5QzNOS0jd+L
 1CAQW4tZ
 tM05h4prA7EU1AzL4Ew5ubYDyjqTNhOu3PmtiXtm3A2HjHwzBIEkV1zGSqNQ9BDeXd7Pjei2Q8SXsy9/ua4+X9bwg82tcQ1oo921uXGDALpanICSbwvgPGG2PgOdu8NkBDVCxKx7YanF3KS82609IyD4XPzenPMHIk8DRoOhYQ87XiCSy6yPvShne3UKozn83vhNASiBaETUKMaUrwm9AAv/OK2pmv8cR2HKV6jzN0iByoTMcKoD0IslQvHT+eBlcHMlWf4L5apAPDCoNL0Z4Hgi0UJibap66PJ3KjMcP9w+0NDpNu7UuT91UuQyZms/m+ufg/WPQwPh36wq0NJ2hxJuxO7zPfkVauP2QMPE2OCn9QNETK6i1l6sl9BzjZks64i19l3Pit0+BRq8WBqdkhC1Q1xCI036iZVa+cSpax86sdnKTFmalNTlOVjj+f8i5RXR0lCP7l0Gqdie/KCFp4Ij3mGrnASAPlqmf+olcmhJSu3KM70XkEssf+UUlZCei3vKRuX8d5jUVfWxtdl4QzEyhh0LhFV4cO3qbwDXa+xdN2a+JN+8HoZ/uKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's not piggy-back on the existing lock and use a separate lock for the
huge page list.

This is a preparation for changing the locking used to protect
balloon_dev_info.

While at it, talk about "page migration" instead of "page compaction".
We'll change that in core code soon as well.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/misc/vmw_balloon.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 52b8c0f1eead7..53e9335b6718c 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -354,10 +354,15 @@ struct vmballoon {
 	/**
 	 * @huge_pages - list of the inflated 2MB pages.
 	 *
-	 * Protected by @b_dev_info.pages_lock .
+	 * Protected by @huge_pages_lock.
 	 */
 	struct list_head huge_pages;
 
+	/**
+	 * @huge_pages_lock: lock for the list of inflated 2MB pages.
+	 */
+	spinlock_t huge_pages_lock;
+
 	/**
 	 * @vmci_doorbell.
 	 *
@@ -987,7 +992,6 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
 					unsigned int *n_pages,
 					enum vmballoon_page_size_type page_size)
 {
-	unsigned long flags;
 	struct page *page;
 
 	if (page_size == VMW_BALLOON_4K_PAGE) {
@@ -995,9 +999,9 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
 	} else {
 		/*
 		 * Keep the huge pages in a local list which is not available
-		 * for the balloon compaction mechanism.
+		 * for the balloon page migration.
 		 */
-		spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
+		spin_lock(&b->huge_pages_lock);
 
 		list_for_each_entry(page, pages, lru) {
 			vmballoon_mark_page_offline(page, VMW_BALLOON_2M_PAGE);
@@ -1006,7 +1010,7 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
 		list_splice_init(pages, &b->huge_pages);
 		__count_vm_events(BALLOON_INFLATE, *n_pages *
 				  vmballoon_page_in_frames(VMW_BALLOON_2M_PAGE));
-		spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
+		spin_unlock(&b->huge_pages_lock);
 	}
 
 	*n_pages = 0;
@@ -1033,7 +1037,6 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
 {
 	struct page *page, *tmp;
 	unsigned int i = 0;
-	unsigned long flags;
 
 	/* In the case of 4k pages, use the compaction infrastructure */
 	if (page_size == VMW_BALLOON_4K_PAGE) {
@@ -1043,7 +1046,7 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
 	}
 
 	/* 2MB pages */
-	spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
+	spin_lock(&b->huge_pages_lock);
 	list_for_each_entry_safe(page, tmp, &b->huge_pages, lru) {
 		vmballoon_mark_page_online(page, VMW_BALLOON_2M_PAGE);
 
@@ -1054,7 +1057,7 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
 
 	__count_vm_events(BALLOON_DEFLATE,
 			  i * vmballoon_page_in_frames(VMW_BALLOON_2M_PAGE));
-	spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
+	spin_unlock(&b->huge_pages_lock);
 	*n_pages = i;
 }
 
@@ -1828,6 +1831,7 @@ static int __init vmballoon_init(void)
 		balloon.b_dev_info.migratepage = vmballoon_migratepage;
 
 	INIT_LIST_HEAD(&balloon.huge_pages);
+	spin_lock_init(&balloon.huge_pages_lock);
 	spin_lock_init(&balloon.comm_lock);
 	init_rwsem(&balloon.conf_sem);
 	balloon.vmci_doorbell = VMCI_INVALID_HANDLE;
-- 
2.51.0


