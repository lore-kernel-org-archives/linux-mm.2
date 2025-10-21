Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C26CCD1B9
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0E98E0028; Tue, 21 Oct 2025 08:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791DF8E0025; Tue, 21 Oct 2025 08:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649C08E0028; Tue, 21 Oct 2025 08:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C79C8E0025
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:59:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A1F3B9AF6
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:44 +0000 (UTC)
X-FDA: 84022128288.11.DF7A0DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 12701A000D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SNeghmcf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cInpBRrRn5ydv+Sa63F4MdgmnDVvTCru+7wR3lsxUS4=;
	b=w7zdfzLTt+krO5GTRmeLl5RgUcomuxoxBcdlh2PAW9z91fQR88tnmRe0G8i1ewMjpYZ2nt
	7CJE6DYqZiwHGx6m/8Nzrbyfqh8WWycvXiam01dxpUmV1uIf/EIqwSzldK8IfTB/63fGfp
	32LoNkh5jIU5kivmbne49RMDJDJubmY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SNeghmcf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051582; a=rsa-sha256;
	cv=none;
	b=hbftPjIPJBgl+iqh54iSDVMSQYiVSUJDOS/h4IpsigiUIajsNw8tyULr2NR0ybXwItopse
	pLTxaOhC+Dvyc1AcfWFIgCL8QmoD0DVi2ohtfcOPgENdlyHbfgUF/INQ9ZCVc15XzAsJ+r
	gktitNwQ+sm8QC5dTkkPdKf9W4dHOYg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cInpBRrRn5ydv+Sa63F4MdgmnDVvTCru+7wR3lsxUS4=;
	b=SNeghmcfgssZ09SC5mknOSPcnvZ+wpNLLAB2pEISK92cKdUlxW4xrPkIMX5aCFardcuZAy
	oYRZ0S1TiHJME+DIYtfR3uOywCgN7QjM+WPhM3Rw8PzlVmuyDjJ9z9S0wmcKKK1SuTzGz6
	YDwCoOaBEg57+1cP5D2DfE9bLwJKQIg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-ifGxQQCVM7CWa8SmD7vxVQ-1; Tue, 21 Oct 2025 08:59:40 -0400
X-MC-Unique: ifGxQQCVM7CWa8SmD7vxVQ-1
X-Mimecast-MFC-AGG-ID: ifGxQQCVM7CWa8SmD7vxVQ_1761051579
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47106720618so34993895e9.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:59:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051579; x=1761656379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cInpBRrRn5ydv+Sa63F4MdgmnDVvTCru+7wR3lsxUS4=;
        b=Ub9VZ6q2iC76Wa55Jyp6r6v8Asm5DJzg40chZ3MJAFufJQoLC0ycHT66cmuHsLtnLq
         WzAgI6lm3zgOyZbaj1NsDMbaC4TTOiNQtSzGFcZDeH3R4VODjNy+9ChT8GkcyS0R7Tjc
         zs430kx3CS5KVz+CRbYPJPEFU2RvdVb2cH6JkP0orngi98pcyxmcDbmnHFtJnXVZoit0
         V1l8b2YXDAVCZeYJxFIQZKLDEIH6mlBtOLVe1dJ59T4wXt3Ag9qRHmkE/ntRtcnyNG7H
         G8iTzH5Ybs+QwcS3yikMhAyBWrT3JZ+PfOn9I2biBkMn9O1uxrcPvnYH5PWYHW2wX2M6
         1lcg==
X-Gm-Message-State: AOJu0YwY3tmRUr6VuuJEOj8sJroB6swI7hyRMwa3ciCECA3NWid0yN+n
	3Ob/NkD6YszcqorHMb7Ub0C+fHRTTjlKbrb8OLiCOhIDOUMF75MgAuDm7v0ipgdAqEKgZhToFaX
	vbbQO9xKmCKpTR+0hsOz0k2BqC6W0EnuflMG4WcfTEtcFs05I1eiv
X-Gm-Gg: ASbGncuA7xJVp3tLCPE0ZnmUSiSs3aByw41l61anuiEFSQoC3hEV/znhi0go9PPIS0y
	Jzc4Rjp2/2xTHll3szwFkcLvtPcOk4OToG23AtJw2ASTt6cp6VRX9RrXh3OcfBSBq2c0VUA5DDc
	fV5Af5vbr4aqjk+E+VyukW74tddDVIgN6A907gMoF+H3W7uA8BTC3OZNeRQ5Ls4cYnEbYu5gHA4
	jfsYegWCEhUp9yarPbUxlgl4xKhYlQoSDE7uz7xLsGoSFOzkyEh1NKarz/B6JTDQXBjOb6U1XGy
	d9kjJjaGDM5S81CSGDC/PFFlxa5h9JBKlHXC5/f9BK1xGXUrgo5x8hwt79jhMxWOtrBbZLrEpTZ
	5B2ZXDUXc4ShWgraLUQBtQXzjKoyIwrSYjGGyC4bxNF52vTniZdDy//5j/qbM
X-Received: by 2002:a05:600c:811b:b0:471:13fa:1b84 with SMTP id 5b1f17b1804b1-4711787c803mr122622485e9.12.1761051578983;
        Tue, 21 Oct 2025 05:59:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+zjcAWFH7UfZS6G5yWsBJ4PGUBhvAl9sC1ULzHpIWHcC8Aeot/GO9fktrhO0M9VdZy+aJsA==
X-Received: by 2002:a05:600c:811b:b0:471:13fa:1b84 with SMTP id 5b1f17b1804b1-4711787c803mr122622255e9.12.1761051578618;
        Tue, 21 Oct 2025 05:59:38 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427f009a781sm20658322f8f.30.2025.10.21.05.59.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:38 -0700 (PDT)
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
Subject: [PATCH v1 03/23] powerpc/pseries/cmm: remove cmm_balloon_compaction_init()
Date: Tue, 21 Oct 2025 14:59:08 +0200
Message-ID: <20251021125929.377194-4-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pbikv-VBvdeoETzmZ2-VtzRDhR6boL6FF-FM3td01xE_1761051579
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 12701A000D
X-Rspamd-Server: rspam03
X-Stat-Signature: 976a1w8zqy1zfdqpywsp7t3jafgni87r
X-HE-Tag: 1761051581-971614
X-HE-Meta: U2FsdGVkX19SdH0Hg5GTfuV0pGfilICAko4QRZ44sMq9pyd9a3f0FKyDTLmmQ+K31fUVQXXsMn5b6tu8X8V/swbgnCtYj2eGf9B1ZftsjCJusBl4XR6gps/vPm/pZUCwWG9HuMKLqaVnaPKtJmft57ZfEepQRI5rCQ6HL8l+9q7yp8VM6w8c+cHvLjyIAmuTvNeFg30XuQbdY70hluP0s7OlQm008uBDh8XkD3sHguwb9k2IdVchQZJ2yN6APl3+jK1SsaoDefcCB0aOZfwTakalMFk3RFWGqDlru6MOLhZpoOJUhSq6hfvdMU/9xm6jOVIMCHJRtf+91ntUjI9BkQsoa4Vj7LRLdYlQBMAAdfN2l2HQl+hFxfuVs+HDW9TP9UakH8j2xjjYTG/vXeXPl09w37D6mgBTYggG0MCAG5xJJw26ENc5FJKHLTJXf09PYvnhNzsiGJYnnfLwZ+lgRg/y7P6bbEDJx2xuyH+6K4n+nYRH9onMPwrNIMznoZCujKeWzJGZ12fVqXU2FJbdyxNGapYeIlG5HMXQe6AbZUr7dyYWaxwS+Km2ZhAFdzgvNs7xiVke5GjJ802txBgu7PtJmttaR3RdYf3XBcIPAiNEZoJQcUweRCJD+eiJ8fvqGXC1e04mnClZd3hruiWT/cRThy5STe9t/D1myI7Gi1TmkqbubxPsxX3MF3xsCX0qydOyQh1pC95c8MLctpOSJ2zUmA8rK9X7kRIZbNB6Nw123dkmCuMc0z73KWH4Zd0lgwILXHzDVuMhplyCCIJ+UdMnN1Be5ErFi4SiEWOkEht45jJZr2/QpDGu0TnUxD+A+Qp+hEUcE4jhQZ+FczaykRyGunKbKsAckSi0RsaerY2lqj0ZGzdh+DWHsgUMssbKyyUHa4SqKfHXgFb6qPLlYJYEq69nl444H8Nm9D1HlDe3luDMUeXqDH3fiZHmYpHQAMLiuJgy3zqqylsMlXu
 rD16LEWE
 aY0yon551VnJcwLgHygGD1SQHD74WwriPG3rq+oAB2ActfHySG1ZqG8y9rT1AEjZeo3TjU1ad3f+LriSlNeHvUWwKtHonABGmnHlKJmyaYB3gIHKv9HWy/nXwr4W+QC6E81Ab56Nd60BlLnA6PrQyzFasB8MvpAlsDh7YQ7lGF5jVBuPQ+5wD9j0/UA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that there is not a lot of logic left, let's just inline setting up
the migration function.

To avoid #ifdef in the caller we can instead use IS_ENABLED() and make
the compiler happy by only providing the function declaration.

Now that the function is gone, drop the "out_balloon_compaction" label.
Note that before commit 68f2736a8583 ("mm: Convert all PageMovable users
to movable_operations"), now not anymore.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/powerpc/platforms/pseries/cmm.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 310dab4bc8679..67c7309c36147 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -548,15 +548,9 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 
 	return 0;
 }
-
-static void cmm_balloon_compaction_init(void)
-{
-	b_dev_info.migratepage = cmm_migratepage;
-}
 #else /* CONFIG_BALLOON_COMPACTION */
-static void cmm_balloon_compaction_init(void)
-{
-}
+int cmm_migratepage(struct balloon_dev_info *b_dev_info, struct page *newpage,
+		    struct page *page, enum migrate_mode mode);
 #endif /* CONFIG_BALLOON_COMPACTION */
 
 /**
@@ -573,11 +567,12 @@ static int cmm_init(void)
 		return -EOPNOTSUPP;
 
 	balloon_devinfo_init(&b_dev_info);
-	cmm_balloon_compaction_init();
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		b_dev_info.migratepage = cmm_migratepage;
 
 	rc = register_oom_notifier(&cmm_oom_nb);
 	if (rc < 0)
-		goto out_balloon_compaction;
+		return rc;
 
 	if ((rc = register_reboot_notifier(&cmm_reboot_nb)))
 		goto out_oom_notifier;
@@ -606,7 +601,6 @@ static int cmm_init(void)
 	unregister_reboot_notifier(&cmm_reboot_nb);
 out_oom_notifier:
 	unregister_oom_notifier(&cmm_oom_nb);
-out_balloon_compaction:
 	return rc;
 }
 
-- 
2.51.0


