Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67B5DCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B047C8E002E; Tue, 21 Oct 2025 08:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D1D8E0025; Tue, 21 Oct 2025 08:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955198E002E; Tue, 21 Oct 2025 08:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF648E0025
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:59:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E70811A2EA
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:47 +0000 (UTC)
X-FDA: 84022128414.25.DB16B46
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6883C000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PoyHvWTH;
	spf=pass (imf28.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051584; a=rsa-sha256;
	cv=none;
	b=7YNy+xVzj3dnh3BUZEvRfoQu2td9x6IvK/6wl/rI/MwTbkU3KkGQcAboEQgFLqmhx24QDF
	J9kUP2VMzDpko40CZkHArzYCRr5krSaKiXgY9Rh5svetFyCnQIr3kO2lunWqqp9Ti7z383
	H5Mpm7NPea8SRttGKYQEU/aE5BvLb1U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PoyHvWTH;
	spf=pass (imf28.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P14fEtg6A4OumBhlVUt/bQLfxRXlwvUBKmtTUWPdWKk=;
	b=O5QD0Fgt81YrzzPrSD6bj/NwVlLwA6Tr3UZNVexIFo2k+BAoAHhOxJwQyeWJkIcnVye3Tm
	qIrvs8Ba16GvBRA6RQdDMCkMZqQlYfhcm6MtlVPcsMAFaXpqVTa19GKxhk+5MekOQLd2Bc
	XDurLNYPjj1z7gwtuvLrFREdKos3WOs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P14fEtg6A4OumBhlVUt/bQLfxRXlwvUBKmtTUWPdWKk=;
	b=PoyHvWTHlLTFVn1Xo5fjXv2FHwVfyEWhMo5UdIZyOBU7vDh0YY0w2adDNf+W7jlXZL158e
	Ie0TT1kYwZzKaFT7YYihjBd/8ri8wg612dBCsmUQm2pJvijb7SaaKu5C9pp17Q/kdUDV6x
	R6j1ucZrv1lvTKn/GD+cBtbjj3EN7K8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-9N-zZcnVOLCpBFY40Q8ifA-1; Tue, 21 Oct 2025 08:59:42 -0400
X-MC-Unique: 9N-zZcnVOLCpBFY40Q8ifA-1
X-Mimecast-MFC-AGG-ID: 9N-zZcnVOLCpBFY40Q8ifA_1761051581
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-471148ad64aso23064695e9.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051581; x=1761656381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P14fEtg6A4OumBhlVUt/bQLfxRXlwvUBKmtTUWPdWKk=;
        b=qIO0qP8n0i01FWn1a6GnquIXEfuxJ1m+LSc6ZSIAfFlFRZgzDZFz7kFZ/ovXLaPHvE
         mRceYRV3wUdijH4mfy+ip1dfOFjnVZ+pAoslPAuPeIPwE/R6nyKm6BJkXSb/muONSPX8
         XCf1D5K+xCTXSlZerol9ZhkFHQOvTI/aUNIjmqEbBWrVYOgumkV/GdJh3wvuo+WcMJzY
         M9+oGWuAXvnMPiFMJBJBK5Elt2svJGGUwqasagLoAoI2pSg63hfsmQ3QM9/s9UFeA05/
         fUMsP6Mb7TjTNb5IefAVNfpaPYl3ktcsB8GZAB5G+52fg+1lBxG0z3wAnEdYVM8IJpXc
         ndiQ==
X-Gm-Message-State: AOJu0YxoTEjjbuzCIxJjK8jnGMivyW2gzKM8HvfsJdLOmQ8BDYwdLbMz
	KQz8SJ4iS8QzjuVjSkhnVR2Zcv5ADUaUFiHsK5unDiXXGUKHZaU+tiBwik15+hDkMEape7kbs0s
	KprXEJq5vQLddoUW+JxxPznwUgnHlslRBmnZFXpjnUhYNI9N0xHAO
X-Gm-Gg: ASbGncvQ6TPOSDJYyeofVnNMC0HtILkMVnihXGdqRHskgiJtl8b6msFQ/9t3ucwmADf
	pZ2eJbgiAEMXsthPoiWuZlg8K5WFKFsGdTB1hKwPLYhTo/5CDFr3XaKAIty5XsTrbgrgqNUFevy
	Ve8Flaa9BfZOh94vt5k6b/rzR49yfbf2cdAf4xV36vcUzM85t6qwHHqXLGt5S9RUnjAWa2fFDXj
	zde4MuZK9OTHOwiZuG+EyHCZgRb/QN9PE/PJz+Q/Q3RZcqHAf5dfCEHLHoZROIRm4hol2Joa374
	kcXy0bnpGCB3Lebqtk27gMD9P6n+7mPUL9FpIfkUef8SR46kHj2cPJ/G0oV7DmrXcLSveuOjPK4
	Db3aG/r87KyVeA1+Jz2tMK3ggRFMxpfLNUIwAB41+P/t7wTPvx9/liCzi9+49
X-Received: by 2002:a05:600c:1988:b0:471:1387:376a with SMTP id 5b1f17b1804b1-4711791c661mr133821765e9.28.1761051581238;
        Tue, 21 Oct 2025 05:59:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcapACDzzVAi+UFv8YmL677aUf6eV6ZNfonjpRp41+s2WgUXfVDbrd4RA2JmDz7jP4+SdmlQ==
X-Received: by 2002:a05:600c:1988:b0:471:1387:376a with SMTP id 5b1f17b1804b1-4711791c661mr133821385e9.28.1761051580770;
        Tue, 21 Oct 2025 05:59:40 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4715520d747sm220307515e9.14.2025.10.21.05.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:40 -0700 (PDT)
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
Subject: [PATCH v1 04/23] mm/balloon_compaction: centralize basic page migration handling
Date: Tue, 21 Oct 2025 14:59:09 +0200
Message-ID: <20251021125929.377194-5-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NbdxEY6KlitwF_M3X20z1QDvC_8g1jr4JA-u8NsVTLI_1761051581
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: 5uwy4hmbcipw1i8igqr3pwp5f744soim
X-Rspamd-Queue-Id: C6883C000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1761051584-787941
X-HE-Meta: U2FsdGVkX1+n8+MwQxeMXZPEA5H6uwfP7lbknxr/CRLLJRVP7OboqJCRHmBFKUFQVs+bc/wp6wsUYE5M1KMMwON2PKhyx+fxN9pDS6htqFWeggWs96faB9oABPXfAqtmiO+/CgpW5WcMOR58X7nEpIdC3GloPCid9hDntH2q7Ro3RUnecZJX0Ab+6uHZ6xwSvM34kYYS67PND7Dn3+S77c7YhperapqjgOKqw3BRXlAQJUsOeoO9kkFztS6Ik2Y65kRMpKs70sDMxLAhwtSwwUtEObGuhg88hernwhsTv5gBVLrmoMPVUv16x05K+ZPEV7BPXPXqXiDjte4aEkRqtTycAS20Z9L8X39zKwrf/8h3zRyGloACBw508vnxT5hvb73sNcQDtksfS1eigUYuj3mL9Tz6lBS/e72QHr8XNlCr9M3JDHTSgQlv7N8phqCmmYX/mBEkZffskm/T9scW5BUPS8DLuuzz4kBQb7DsMeYqMRDbL1/cI9y7dbwnXWps8L0NiDVqgm4hrZjj4QDy4o3J1zfNycW076bKnOrlUl49zZ/qpnhzGgUFNme/7C9C8VsO0nQvExGYat6HCnngGbHSNSjY77bniQKx/fUOR+XpZHg+keEkiSNuPFF79nORbxp9/r1YeUlMdMTQiWqNtN3FxSIE/Sy2Zs3e3vxONdUYkEi5euUP6RxLGSFttpw5T3TGi+wISOCOpkaw3KsDQGfCfRh2iowr0525txYSYlqS8ckuENYf8vPUkOILkN+6m9ByUGvO5LE1dYoqt8nG1y4TfBpdebOFlvgyDjpTxFBw5t0inytqDVXcNmv8WldFejKhWmea3xs/e8hc6jdhHeu+8WbMVkio4xCwRandFrZcIt/VXeyJ24QDqXR4UXTobxg8hQNCWM9KW+DzD+u0s9zNa71aAp1zDVRbpsXeFhwSf97RlTmPW2gJa5WX1fUeS49maEmPOhQDTPpEgeA
 Ej8jfweN
 jsA6J2HKfMAAAOdw4UtHSguuI/UHJE6wWUR43teboivdPb4B9EOjt5WI2V3WjRKbXNaURifM8Defh/u7Z5AyrnOFEUbe9cN8woPwDtH6hn+jmwehPsyuEI89PqiwcNcRYuzkfTZKkrZ7oHo04pxc46dd6HkpzjieOuac8M5FqOGfxn4Q70rITfP+/r8Jjq0nitccihk2t9jyyZl+yjlScpToYd2H/Bsb5EGy9cBgMM9HzAxEvgJevEmAb75NVAJoDLwaaXjZI812FmCua0YbPfoIz/343xvtIcnIKxdtC4llHieyn8qrt6dsIA5fzCHNwDd0qVz/TcpccXdMIbaSn+tlDQn+MMZrm+INS0QdU1ZyvlpYZ/J0mGIrasdfAtR5wCjprWH736aUzG5kkJuQkea3E5AS1gFL8/ucRpxarGTcNfKiN/UkcbilzMdD5M2JOpgJ34XRgIxDvlq/wCMgpJaWt6Jnnvz8OYgDNUZ3QiUtLb2FcQpqUwvKISDZ3Ypm2d5Z+7thHrpd9nvX1v6nVUUkT93FDUHmP5DnmD4T5cxpCKG2Y53+f31NpAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's update the balloon page references, the balloon page list, the
BALLOON_MIGRATE counter and the isolated-pages counter in
balloon_page_migrate(), after letting the balloon->migratepage()
callback deal with the actual inflation+deflation.

Note that we now perform the balloon list modifications outside of any
implementation-specific locks: which is fine, there is nothing special
about these page actions that the lock would be protecting.

The old page is already no longer in the list (isolated) and the new page
is not yet in the list.

Let's use -ENOENT to communicate the special "inflation of new page
failed after already deflating the old page" to balloon_page_migrate() so
it can handle it accordingly.

While at it, rename balloon->b_dev_info to make it mach the other
functions. Also, drop the comment above balloon_page_migrate(), which
seems unnecessary.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/powerpc/platforms/pseries/cmm.c | 16 ---------
 drivers/misc/vmw_balloon.c           | 49 +++++-----------------------
 drivers/virtio/virtio_balloon.c      | 12 -------
 mm/balloon_compaction.c              | 37 ++++++++++++++++++---
 4 files changed, 41 insertions(+), 73 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 67c7309c36147..07b21d2bc8a78 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -501,8 +501,6 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 			   struct page *newpage, struct page *page,
 			   enum migrate_mode mode)
 {
-	unsigned long flags;
-
 	/*
 	 * loan/"inflate" the newpage first.
 	 *
@@ -517,9 +515,6 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 		return -EBUSY;
 	}
 
-	/* balloon page list reference */
-	get_page(newpage);
-
 	/*
 	 * When we migrate a page to a different zone, we have to fixup the
 	 * count of both involved zones as we adjusted the managed page count
@@ -530,22 +525,11 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 		adjust_managed_page_count(newpage, -1);
 	}
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
-	balloon_page_insert(b_dev_info, newpage);
-	__count_vm_event(BALLOON_MIGRATE);
-	b_dev_info->isolated_pages--;
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
-
 	/*
 	 * activate/"deflate" the old page. We ignore any errors just like the
 	 * other callers.
 	 */
 	plpar_page_set_active(page);
-
-	balloon_page_finalize(page);
-	/* balloon page list reference */
-	put_page(page);
-
 	return 0;
 }
 #else /* CONFIG_BALLOON_COMPACTION */
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 07e60a4b846aa..52b8c0f1eead7 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1724,18 +1724,17 @@ static inline void vmballoon_debugfs_exit(struct vmballoon *b)
  * @page: a ballooned page that should be migrated.
  * @mode: migration mode, ignored.
  *
- * This function is really open-coded, but that is according to the interface
- * that balloon_compaction provides.
- *
  * Return: zero on success, -EAGAIN when migration cannot be performed
- *	   momentarily, and -EBUSY if migration failed and should be retried
- *	   with that specific page.
+ *	   momentarily, -EBUSY if migration failed and should be retried
+ *	   with that specific page, and -ENOENT when deflating @page
+ *	   succeeded but inflating @newpage failed, effectively deflating
+ *	   the balloon.
  */
 static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 				 struct page *newpage, struct page *page,
 				 enum migrate_mode mode)
 {
-	unsigned long status, flags;
+	unsigned long status;
 	struct vmballoon *b;
 	int ret = 0;
 
@@ -1773,14 +1772,6 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 		goto out_unlock;
 	}
 
-	/*
-	 * The page is isolated, so it is safe to delete it without holding
-	 * @pages_lock . We keep holding @comm_lock since we will need it in a
-	 * second.
-	 */
-	balloon_page_finalize(page);
-	put_page(page);
-
 	/* Inflate */
 	vmballoon_add_page(b, 0, newpage);
 	status = vmballoon_lock_op(b, 1, VMW_BALLOON_4K_PAGE,
@@ -1799,36 +1790,12 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 		 * change.
 		 */
 		atomic64_dec(&b->size);
-	} else {
 		/*
-		 * Success. Take a reference for the page, and we will add it to
-		 * the list after acquiring the lock.
+		 * Tell the core that we're deflating the old page and don't
+		 * need the new page.
 		 */
-		get_page(newpage);
-	}
-
-	/* Update the balloon list under the @pages_lock */
-	spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
-
-	/*
-	 * On inflation success, we already took a reference for the @newpage.
-	 * If we succeed just insert it to the list and update the statistics
-	 * under the lock.
-	 */
-	if (status == VMW_BALLOON_SUCCESS) {
-		balloon_page_insert(&b->b_dev_info, newpage);
-		__count_vm_event(BALLOON_MIGRATE);
-	} else {
-		__count_vm_event(BALLOON_DEFLATE);
+		ret = -ENOENT;
 	}
-
-	/*
-	 * We deflated successfully, so regardless to the inflation success, we
-	 * need to reduce the number of isolated_pages.
-	 */
-	b->b_dev_info.isolated_pages--;
-	spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
-
 out_unlock:
 	up_read(&b->conf_sem);
 	return ret;
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 1b93d8c643612..8969271581bca 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -827,7 +827,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 {
 	struct virtio_balloon *vb = container_of(vb_dev_info,
 			struct virtio_balloon, vb_dev_info);
-	unsigned long flags;
 
 	/*
 	 * In order to avoid lock contention while migrating pages concurrently
@@ -840,8 +839,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 	if (!mutex_trylock(&vb->balloon_lock))
 		return -EAGAIN;
 
-	get_page(newpage); /* balloon reference */
-
 	/*
 	  * When we migrate a page to a different zone and adjusted the
 	  * managed page count when inflating, we have to fixup the count of
@@ -854,11 +851,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 	}
 
 	/* balloon's page migration 1st step  -- inflate "newpage" */
-	spin_lock_irqsave(&vb_dev_info->pages_lock, flags);
-	balloon_page_insert(vb_dev_info, newpage);
-	vb_dev_info->isolated_pages--;
-	__count_vm_event(BALLOON_MIGRATE);
-	spin_unlock_irqrestore(&vb_dev_info->pages_lock, flags);
 	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
 	set_page_pfns(vb, vb->pfns, newpage);
 	tell_host(vb, vb->inflate_vq);
@@ -869,10 +861,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 	tell_host(vb, vb->deflate_vq);
 
 	mutex_unlock(&vb->balloon_lock);
-
-	balloon_page_finalize(page);
-	put_page(page); /* balloon reference */
-
 	return 0;
 }
 #endif /* CONFIG_BALLOON_COMPACTION */
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 03c5dbabb1565..5444c61bb9e76 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -232,20 +232,49 @@ static void balloon_page_putback(struct page *page)
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 }
 
-/* move_to_new_page() counterpart for a ballooned page */
 static int balloon_page_migrate(struct page *newpage, struct page *page,
 		enum migrate_mode mode)
 {
-	struct balloon_dev_info *balloon = balloon_page_device(page);
+	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
+	unsigned long flags;
+	int rc;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
 	/* Isolated balloon pages cannot get deflated. */
-	if (WARN_ON_ONCE(!balloon))
+	if (WARN_ON_ONCE(!b_dev_info))
 		return -EAGAIN;
 
-	return balloon->migratepage(balloon, newpage, page, mode);
+	rc = b_dev_info->migratepage(b_dev_info, newpage, page, mode);
+	switch (rc) {
+	case 0:
+		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+
+		/* Insert the new page into the balloon list. */
+		get_page(newpage);
+
+		balloon_page_insert(b_dev_info, newpage);
+		__count_vm_event(BALLOON_MIGRATE);
+		break;
+	case -ENOENT:
+		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+
+		/* Old page was deflated but new page not inflated. */
+		__count_vm_event(BALLOON_DEFLATE);
+		break;
+	default:
+		return rc;
+	}
+
+	b_dev_info->isolated_pages--;
+	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+
+	/* Free the now-deflated page we isolated in balloon_page_isolate(). */
+	balloon_page_finalize(page);
+	put_page(page);
+
+	return 0;
 }
 
 const struct movable_operations balloon_mops = {
-- 
2.51.0


