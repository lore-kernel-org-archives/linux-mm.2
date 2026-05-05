Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D15CD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 05:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B28E6B0093; Tue,  5 May 2026 01:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262B36B0092; Tue,  5 May 2026 01:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1034F6B0093; Tue,  5 May 2026 01:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDD3C6B008C
	for <linux-mm@kvack.org>; Tue,  5 May 2026 01:18:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B797C1A64
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:18:04 +0000 (UTC)
X-FDA: 84732209688.07.BAB8790
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8266840003
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:18:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IQX00YCp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777958282; a=rsa-sha256;
	cv=none;
	b=doQiRkqmkook2j7eIG1+EDwuU3weoRB7dNDmNzTkpyKWoATuyonRr683T+AOVcZ3kohlaL
	Hccv6TJbhH7CSRNMeGz48hlIL+MHNA5Lu2ns2shovXfUW5JORzTuI6V9s51fj3HWkelzMs
	POXQv6QovHjA/mPXK5094ONC4MRfxJk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IQX00YCp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777958282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xl5SeCFAdc6WoqyWBYEluyvHLd+oZ4wSvK+mq+H5Z7o=;
	b=yAt7I9Zy1bzu4ydRIkAH0u3BCVtp4cKSE809TNVvYwfAoATGJMCdW1tb1VASs0SeSVKYiM
	YxaRp+62HLKrianfzWD6+VopK6qQw1XDvh4mypBNccs+ezR8IcUvEcGCz5z8MWdPjBa4nV
	d+Ece20EGPRFohCSqJ9gVUr22ik18KI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777958281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xl5SeCFAdc6WoqyWBYEluyvHLd+oZ4wSvK+mq+H5Z7o=;
	b=IQX00YCp94mfnFnOkXjhOLagQFZ6fabFgNCg4o5GDjeaAGxdtHzdJEdN+mcDVXD21eBWz4
	yNmVJqUmwiSXXuX9BVXmxF5kFiLAheYfOfO2rguMO3cq+Y0P0WbpHffXu5zEKI5psCszfp
	LkdvSfGvcFySxL77dcyAMTEi4LL2X5Q=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-OXgfcgiAPs6E8x66HEDCYQ-1; Tue, 05 May 2026 01:18:00 -0400
X-MC-Unique: OXgfcgiAPs6E8x66HEDCYQ-1
X-Mimecast-MFC-AGG-ID: OXgfcgiAPs6E8x66HEDCYQ_1777958279
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-393800f642cso13604261fa.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 22:18:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777958278; x=1778563078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xl5SeCFAdc6WoqyWBYEluyvHLd+oZ4wSvK+mq+H5Z7o=;
        b=lUdUV+eKnEh/BUjelIvByt/JUoD1DKLT7NNonxL7HYjYdBjOdEKzVeWiIGMfPt3R55
         VCm8mP6M2VTxehbZ3A1JS8henvJmVBmOnCjsURgGnbRq59W2ysMGi2sumWgdcewhB8Ai
         GdkyabBIy/IoLoVHOj+R7J+XQLjZChDLNfsI93YsoMbrJQP/D6B4oTNC0Bbd9pU3/eGC
         itzrkhY6O+8kFMX5JFPfgeYAJoiaEyyFuH/CXOHxF2m3+pBeF69vveTXS/OREv2mGfmY
         AiyxqtVEIjXXYefdOiUYt/pL/eKpdg01OOL4VyyvJUAkUAJeBlh1CoYn6Yi6R0fGMYyT
         bVTg==
X-Gm-Message-State: AOJu0YxAYgoWKZzvwy6xKn6zclOoyeE0+ITYAkiamFjmrdQewO8GJhUS
	VZLMA2/OmeSPUOfdtl8hTLTXHzYNf7DLrB1hgQI6ronxH2OW5znCOJGPnE0kUVx4ea0WAwVtqci
	PYNKsWBWFqJqcU2JQZEwI9v4aFUMwZaCG0VDiw8w13x62dEScP4NGl8hUE+zedmSFLwrnDeFWfz
	tGk4K4h/vNdVn1r5o4/LV5Sf/BleOFnQrqY5okng==
X-Gm-Gg: AeBDieu5BNqMi6zWLD8MYaWJ0UqqA4R0h7Pd4HtdMxgU0tGC8oQtdAT7Km536XSzhCq
	HZsaEki0pn2aTzFRsJLup2PIgXjoZheqhlnmvJSDe7n5GkmzdWG/QeFduUjDIzpSkr5ywy0428t
	BaBe3XSrp6ZKg6ZDUB97UpuG298kfienRN/JQqaFU/25nDNZPBz9OR5qcJur39Pe/N4GErO8JIy
	cdXyX4TqumhSYaa90xqIPMA1sWhJ5bYiYAT6nlpfyMY/Z364yWOrKAhPszxS0QR/7w5HgQgs4Oh
	QaZpUrkLc1LD0p3sIwr9BRFqQebFKiZNm0uJUcnh1N8SMTQwr4NtySsx5WzFCauwXDguNME9wjc
	NY/TtHf0KJUuo1XZ59B7jtjEx1mMflb4aZCLI2wXjNopEaQk=
X-Received: by 2002:a05:651c:4199:b0:38e:186e:350e with SMTP id 38308e7fff4ca-393b495a02cmr5464511fa.7.1777958278661;
        Mon, 04 May 2026 22:17:58 -0700 (PDT)
X-Received: by 2002:a05:651c:4199:b0:38e:186e:350e with SMTP id 38308e7fff4ca-393b495a02cmr5464161fa.7.1777958278137;
        Mon, 04 May 2026 22:17:58 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3936138935fsm37206141fa.41.2026.05.04.22.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 22:17:57 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v9 1/5] mm/Kconfig: changes for migrate on fault for device pages
Date: Tue,  5 May 2026 08:16:54 +0300
Message-ID: <20260505051658.2219537-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260505051658.2219537-1-mpenttil@redhat.com>
References: <20260505051658.2219537-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sE9kyRKBhNB5Kvo5lABPB9DUycwPYrRtg2gC8QAbg9A_1777958279
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: phsndk9mii6whamehkqi7e39ox3xuo8z
X-Rspam-User: 
X-Rspamd-Queue-Id: 8266840003
X-Rspamd-Server: rspam07
X-HE-Tag: 1777958282-905971
X-HE-Meta: U2FsdGVkX18MFYy3K4zLSOcEyA5TqMe5Ib6uAVvWNtnaRtFzhXOqchx6ZMU2oybqn8Qt71nhuy12LR2ygWOP5zq94OXnDZ3K7igDNv0zhr6E6as0ojkVEnMK4cZQX52ZUKEAuF1rtVuqpxQacYogNWDXNC0XurmSwQPMUM/juf2zfcsO3H9gs64FBTwU6TnsvkWM5YDjd5ED4Fyqsc6rcKqWUqWx9QtP/CK/MwTve6hEezPMpka6GCfsRyMxxJoRD9asJENLiipTcbU+OkqKdzweYDF/fdc0eK/st1SNSHhqECXebLGE/tFUB0u+Ocbp6OHDeuBVAXUPWcOitfvoQUfW55xOXwPuAbADA8RAUdm9/gaP0o+/fY9NkF3Zv2aXHEaM8sOz15pVWI0iXi38Y60RT6ytwQNYo3XRu//pWu4pHVgy3E6qeNrJ7Iyvb6YLQIDoAH07X3aBmu7IB2mQgEBXRemiuhq2VoXF3U6QCcrZk2cevW1ZEk5shx02x2xXMphUbf66/rH904HUo+WJbpjsgv1CTBCyLYqYrHtoC5zl5CoO1QlxyV5d5/tdf170XaGcVg1AQ2ipLs8fXSW7tNvlgkB7iyaLdvvz6Mc1NKY5xrKk8GcyDZDao7OrkrRJhBLvIuPcONxUJ6JmOZ50o3AcAygizv+bFYX4gS0fr50ojr83KUjXBaY+Q+fAIuVUmhtnbRG/HEXlf86AbfHCnZIQ9jZ6mEbo1wGHcaQYSYAnKVYu9TSYN4F7c2qedM/GPmOsCGEZ2mWzRCLwstAwBsqL/QLrEYrS04hR+r7HwwxmprKhKDtmzSzxvHWlgWdEQPoZ8ipn1MLU1Mc4VGvlZJUBvPWGYhsIOzsUMc4omtY6prShT+T2+k8H1/trmolZA2YhWftYqbU83ZwEwlyAgF2Sjd2RsVCG8d1jPOFghWwME/L7L0ZVqHLJl/lNpdbNKvPzQsb8aSKO8aPW5cw
 gQFXT4ZY
 gmzYzE7afM4lVm7KtLSWVe2z3KUHOdcfzsU3kAW5HWT46ZXzAnUwxpooSHmzPIWhIfp6IWzQ2AlQNaxiMDYeoiBuoM26KtdIjjtmV38FKF1PE162+tgajH3teXTsjIdbSh1bLxTpF2iOTeVpOKywogRAxenlfocSn2y/JIKcNhc8o4UZTHwJnxiYdvVzqCt1OSFL+sdpO96VZlDByS2aisjwoGIOd83NK37706lHyss3kTaufB4WLbzwSBKl+pRLAMrmaYmojlnNnv6khiWEvSEkvJr+UBLts2JpNgXDke+0TWnu54k/mO1l57Hnfcp6YPDXUDQlqgTdSX1KWTaMydAQcVJ9G3BElxWP/0okxHjKxQsNmGXwDbOA0STPooPnJALXo6dNjoeZ4WFqn04/qRPLQ+RRkALPekhW9MC9cS5HZZHMrvmHSc89GthdrrLAFfM/J9N773sTU/a9tUZSXA4lBdSlYcTrJqGpSxfytuNRAsXFjFYHhR1MVe8CVRA1VB/rtnR+s0HM+Me7pCwaU4oB3qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

HMM depends on MMU notifiers. With the unified HMM/migrate_device
page table walk migrate_device needs HMM enabled.
Enable them explicitly to avoid breaking random configs.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad9..0d8db75ffc23 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -646,6 +646,7 @@ config MIGRATION
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
+	select HMM_MIRROR
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
@@ -1221,6 +1222,7 @@ config ZONE_DEVICE
 config HMM_MIRROR
 	bool
 	depends on MMU
+	select MMU_NOTIFIER
 
 config GET_FREE_REGION
 	bool
-- 
2.50.0


