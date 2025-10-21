Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9642CCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A448E0002; Tue, 21 Oct 2025 08:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5118E0025; Tue, 21 Oct 2025 08:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164998E0002; Tue, 21 Oct 2025 08:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC3B48E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:59:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8289D13ADEC
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:42 +0000 (UTC)
X-FDA: 84022128204.25.024F8E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4FE671C000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nd6goDZb;
	spf=pass (imf18.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8R/9+ffq24GRtsamw+sO0Dq3xyN1P0TNXMmPfo3y584=;
	b=eMRxQo5cRwk2xdz1dTntZW+DKa/in24tczNRmQnzs+ScLf/I/rf9fVY8AMLmtX/+af5p3u
	Lgig4WrtUDrpSrMSLY+eLMlSASmEVvntySiMDEcCtAgUwpCxQlIAjBA5uj28vEXHx44vDK
	tGdQBkJcEZkIVpqHQLwLBFNGo0SZp8o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051580; a=rsa-sha256;
	cv=none;
	b=Un3pnua3EfuDOvZ26E4q6FTp41kNmFvvbQ1VdmtN2jdEtXErKlh8lqhIulrpj0lmdbSzNj
	SmtVouG6on+/6vqfDc/lCxiGnsFHQ62B16sdqpgMkCBf2YF+okAI2SgawhtbQYGuaxSPjO
	jbqMWQ1OZDKsnLKiOAt8CEHu03JqD9g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nd6goDZb;
	spf=pass (imf18.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8R/9+ffq24GRtsamw+sO0Dq3xyN1P0TNXMmPfo3y584=;
	b=Nd6goDZbxtHT0pGcSMcrGpJGZJXlc1s1oX2XhVKHKoXm2oaYRGzoGgOf60636RJpaNviSr
	TU1NM9ei4JzOG8FRB/FKPRxeMeBSvPCgdIjzIl0uxBf42NA/UEtu/3Et4KBTk7utK8gVcU
	pQlVNzSh5LoGNdbVN0NU72/zT1Go0ok=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-homBenfDOBmS1CJqjjx5_A-1; Tue, 21 Oct 2025 08:59:38 -0400
X-MC-Unique: homBenfDOBmS1CJqjjx5_A-1
X-Mimecast-MFC-AGG-ID: homBenfDOBmS1CJqjjx5_A_1761051577
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471144baa6bso32644995e9.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:59:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051577; x=1761656377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8R/9+ffq24GRtsamw+sO0Dq3xyN1P0TNXMmPfo3y584=;
        b=IBjlOy3tJxqqfRaveyUHHcQNaTApkZHnjQT5PZTLMWiwTz504v2kzu5vm8QgJWKvtG
         Ls265zKGSIfJJXY06TJeWK+vS88BKrAbwQEhVMOHgpQnQi79wngpnbcLQBCb+WCaJxUU
         EiDKORNCs9Do4uRiT61LVRAw1nCuukAteSDdTG7oeRqHNXA40lc8rnMDxUF0HfxUpEqT
         pel/uypa4SYJ8Vtm6KU4Mu/mrKvGWUI75kgPz0/+/oQdOtHT0QN/sGjKCumfrTpWAW1h
         0QsVoilEZZMwf2a+9TwbHBV6aAJ2FEuFmpqG6BTFLs64h9OaQq84NXFsHmKmc2sIgmAf
         /MMw==
X-Gm-Message-State: AOJu0YxIJsfwT1OxT9RSW8PViimFEFzbR+awWTaZPvMztnlj9mh8WdYP
	291XT5ZcuyunD2iT0fRF39SuLWOdtlUYSbQZFnRTA23Ke1XghZjJ/CrWSst5KrI/7A6Rx8r6US9
	pj77zelF1aWuGsLCNLNkkEOfCc01Y8SoZbWEPsF0/royMpm30CokW
X-Gm-Gg: ASbGnctGatJrwAqajo35J3WEp74eCGAFkMLVZddIoFQWYbxRwHyuUZ2WneH0P/lKITy
	kvXM6NgkObz3SRIF3gm1mdCwI5wuXKAuWacEZSivG77wxJIcpfWRpf62O/8BugWiXx2TN6apF07
	bezNPjuUY7yNY0e8pRueWZeEDwWsQR/axbX8c/X+7ve097OGykXmZJP53j9QDUqtqZ3D8sWpvXN
	xMeIDgmVfqrqqMOXpiBDKP57HgXiUiB3OFrJTrkNSKo+TnL/wwwk6/YuLyK5Ldi6FOAs33vgQKN
	06WWsEKabXuMXh5Wan5YnuVTv8szZwu+F113IecuJUAyqJjqrgHQ13c+MJaCIErxFmOiDXiyec8
	Ot6lP+zfZqJKYJ52BcRqyI2v6ymQlc8Az9sb0L3EaFq2JY7McnNNlAHDFbNwU
X-Received: by 2002:a05:600c:444d:b0:45b:79fd:cb3d with SMTP id 5b1f17b1804b1-471179202famr118678415e9.36.1761051576988;
        Tue, 21 Oct 2025 05:59:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEokGBhUzCRsmptihAjBHDZlL2+6LwM1McdhB6sS9tCAS0C96fTIUzPBBNJE//85lgKmaBsaA==
X-Received: by 2002:a05:600c:444d:b0:45b:79fd:cb3d with SMTP id 5b1f17b1804b1-471179202famr118678045e9.36.1761051576500;
        Tue, 21 Oct 2025 05:59:36 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47496be2eb6sm16562465e9.2.2025.10.21.05.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:36 -0700 (PDT)
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
Subject: [PATCH v1 02/23] vmw_balloon: remove vmballoon_compaction_init()
Date: Tue, 21 Oct 2025 14:59:07 +0200
Message-ID: <20251021125929.377194-3-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QxWyGo2wjdoipWTznh5fe7oKhLn5SRGOTGzyPmL8XC0_1761051577
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Stat-Signature: x17n14bfuwmztdyhqhiaz5inyb9qk4p6
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FE671C000B
X-HE-Tag: 1761051580-154062
X-HE-Meta: U2FsdGVkX1+6q1eMKD1A9qJFN0hhBuoFs70sBwO8/Mk64EaAq5LkMMzAUUkRmADJvYEFo4DeDJvWrbpBi0iOWFClgkqTxGGqQ51UdyZuzJlrjy7CKOy6oHU8Ze+CHjYZeFZ/+kDJPF8EzVzQe/EnYkUuRjF20OGrZb6ZVwYFjF8Pb1wqD4ZWw4IVE6TCdBBW43MXsmc7GwVRkU04DObEZnAAt6ppZ5J/Fw7Opgti7dCBrC/ik7GjcnhiEQQeTZO6AhYlepY9zlRlrRq6ZH0FCnIdd0WSZmrQCxGPdi838k48uky/kNcRMwXohOSwbbZJhO20ab6aaA1XpLZL5I3inrS+zrN/DJV88BMQqtvFImqJ4rZzQ/YKRzhhaI6wPOMm7ZOyii77nOqBhcHPhaQgBpx9keyty8NS1jY7ABg/4NhgZGKMbtQT7rtoWEZWOAHsQd/wuOm/M4aHQJdgsdIv1G87t0ATzX+MA5gSlBxn6D5rbJTrZDwqdF9EunJrMc8+arE0AhFcfszQY1JMk+2oN2tiaiYg/9DzXb46Q0u5xL7wre5wOuibHm9toAjldd8u5kGlOBKrDu5PUpxa0XeU2kJdiZBSWsqTaPT9fpKaD+p0NZn4jFM7v/MfhPnZ2EFLWlEoG0mTv0/l/9i3uGIPOcbgfwDHRnGBgyb6ZF/OoJX98Z6gZZTWlAqrdqvy9mWKmq3btX0NAwu6VThmGpkXR3Iuknhp1fDcDWH1nC3l5YzV02ygOmakDPQzD1T+k57LmbC7x/gSbgwI5naMFzyNZ8tBsDl33ZjlGevbvOHQysTht3VUQGn6KMLrtQGkHQaeIShAr9A+Za6FsRp7kYDt1GkiRu38D14VT7ZxuZwA0hbpIKzw6aJjFI/S7/FIfn1Ih75UdBTh8PUtxlgf0Vr03/8VPE+2IGADNnO0NWis8xdHSaiSpzpIPpVeCtw/+yIhe0QBLAw288BEDIfNmmc
 almNdXn7
 znYw2xum337xN0SKyMFN/Z0sFvMGAHWYJ8qYHe0fi2TLYs0pDYCFtfRqTkQ9TY4aiBXSCQ0rgK0ma3h9wwlMUNacxEHH/M4/2AGlaO7yOfvmIQ1taiwa0U8DEbHOmGNKmwh0DWbet8hqYMvF+h8naARYM6QfSqWOr300LW2mTNHZhOJAZ4enMIvs5zYxdCHZoXHSVSwLCApLZk8ZV3a8YJi3Dui1mGx+YvIXZFyedMeddJH9vS8IcPrCBcHXSudI4f0qHqpJf+Uft/g/TYTK3/7Cmrm0L2/3BsMWV3wZyHqSFKPboBH5sE0/1AvqJ5+MourpdMMTE5kw21fxo77tFn48qPbAbN0lRhxYw4usHTah8GwBFRMZ0B48d3CaFqHfs5pyj5lp98ac+zLb7lQTSEgXlGaBh5K1ksGl7haTq0mA9Y1n+cNxHnX18evalh6TqW4xJ2I/RU1x8/eMG1P+JpRAnzhHWTTW6PBe3ThZ+hsaLN1OgE7UGSMg+2MA3kZ530YeT5vvR3KlCmoNsmR3BLvYKbOGKjLGNgX8oD7E7PP46g+UKlKDjYy4gyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that there is not a lot of logic left, let's just inline setting up
the migration function and drop all these excessive comments that are
not really required (or true) anymore.

To avoid #ifdef in the caller we can instead use IS_ENABLED() and make
the compiler happy by only providing the function declaration.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/misc/vmw_balloon.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 2cc34c4968fac..07e60a4b846aa 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1833,27 +1833,10 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 	up_read(&b->conf_sem);
 	return ret;
 }
-
-/**
- * vmballoon_compaction_init() - initialized compaction for the balloon.
- *
- * @b: pointer to the balloon.
- *
- * If during the initialization a failure occurred, this function does not
- * perform cleanup. The caller must call vmballoon_compaction_deinit() in this
- * case.
- *
- * Return: zero on success or error code on failure.
- */
-static __init void vmballoon_compaction_init(struct vmballoon *b)
-{
-	b->b_dev_info.migratepage = vmballoon_migratepage;
-}
-
 #else /* CONFIG_BALLOON_COMPACTION */
-static inline void vmballoon_compaction_init(struct vmballoon *b)
-{
-}
+int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
+			  struct page *newpage, struct page *page,
+			  enum migrate_mode mode);
 #endif /* CONFIG_BALLOON_COMPACTION */
 
 static int __init vmballoon_init(void)
@@ -1873,12 +1856,9 @@ static int __init vmballoon_init(void)
 	if (error)
 		return error;
 
-	/*
-	 * Initialization of compaction must be done after the call to
-	 * balloon_devinfo_init() .
-	 */
 	balloon_devinfo_init(&balloon.b_dev_info);
-	vmballoon_compaction_init(&balloon);
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		balloon.b_dev_info.migratepage = vmballoon_migratepage;
 
 	INIT_LIST_HEAD(&balloon.huge_pages);
 	spin_lock_init(&balloon.comm_lock);
-- 
2.51.0


