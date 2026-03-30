Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6AEFFF493F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 04:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFD26B0095; Mon, 30 Mar 2026 00:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8156B0096; Mon, 30 Mar 2026 00:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F6B6B0098; Mon, 30 Mar 2026 00:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E44D76B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:30:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EB4C1B8822
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:30:44 +0000 (UTC)
X-FDA: 84601453608.26.D6AB08B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1FBE0140003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:30:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KnzxLjky;
	spf=pass (imf09.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KnzxLjky;
	spf=pass (imf09.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774845042; a=rsa-sha256;
	cv=none;
	b=s+m41V8fFuv7RYXS7YPXQeB4RfCTE6ZQAujTY1m/J3mAwnt0LeDu6oXH1PsxDwJBpytPND
	V6OeOntq56wCPqAr3e4EGP9SEuGEpUQga2pFJY6tBsgGuqIFFYyT5aUyQwckTa4+Am5Y6C
	cwgCIjp8U7HqJkGxbsV/zLO/PdtOrEk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774845042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZhz7TUI0zV50+5LEjo8lH0Seax3sAW0V9p7og3voDQ=;
	b=orKMTcDMoTpTe1ayL2yLFRcs5SdDuwGp14vVYi+rO8zKfVGhD5dNqGYbTGZMUS9DtI7OyU
	gV+YLH3VAEQqtVR3pen5XJD0szld8aH0M+nKc1K5kydx0MOkGpDMdVPG5PJg/O4ah/QSzz
	TDxdTIuyZJxH5qTcq7lGftQQIrgXZAg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774845041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AZhz7TUI0zV50+5LEjo8lH0Seax3sAW0V9p7og3voDQ=;
	b=KnzxLjky9ikwRqtRRCtdu64tISA0rgRiYxT1+tsJfdmhB/lE0YqKafwzTR/qCZMAjbaZMh
	6uec85yov7jaA0PKqiUHu6o9DiMHwKPwstjEFZ9Ot6RudWJ/5ApwsEfb05Ih/z6K/b0Xyc
	l+RlIrlCroI6f9ovaR9S9CKZ83GcM5M=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-711-f5s3IOBYO-axbu_Fi2OpRg-1; Mon, 30 Mar 2026 00:30:40 -0400
X-MC-Unique: f5s3IOBYO-axbu_Fi2OpRg-1
X-Mimecast-MFC-AGG-ID: f5s3IOBYO-axbu_Fi2OpRg_1774845039
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-38be64ed420so17050321fa.1
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 21:30:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774845038; x=1775449838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AZhz7TUI0zV50+5LEjo8lH0Seax3sAW0V9p7og3voDQ=;
        b=IQeita1RIoZlBhn6iP5ctlujyW1QVKotAlxPp4ytkFKWHr7FAK4b7DXSsqNv+EbXU+
         WhFU9SGKQvouKEtlqW2gKGETm9R/NMXvXp5cUZd+I0QUiol1lxbALhOmR0dRRojJztU+
         xSWLyWH5WhzDu7ZHFrFb/mKusRW8zgcKQctuk54EGQRRyfK9Z1X3aiE9pq8iCcybWDj3
         EdKI+pmGFh/SiLQvCt80A+aC2VTnWBQodQvaFNJBu0L6sepVi/DSDwWmxkSyUDaeN6gg
         ViFGCj7bB7WY/fcysRdXB/fZlCXpSfjWlwcUKJbT+oXOApJ5Wf9Munh1dA1/Zk+ab08k
         YQVw==
X-Gm-Message-State: AOJu0YwZvESzA3TvIMU1NxlAlGVBqA3xeTRZH/K+lCrWRSVx9CwjCQu0
	TKkpLzTrZGQKdIcnNFBlmWUboHrFEB7/WXKUiGC0s/QdHG/+aPx2cV188DtfyKWH1el6dajRs65
	T+Va7WKL1w5HT0g94SChlGVcHMVXp6pqye/nDv0yRcQXAfkR64+HNJeMIpgctmLKCJ9C1yENUys
	zc4vlQvk2UiXuuMFyyWQxbP0/xJBzrokD0s4GhdQ==
X-Gm-Gg: ATEYQzyNz/9Kpy7rmHZusueY8ovP5G/Raw6jal6HMhiCY0IkkL9Ff8JhqZiHPdZjswR
	Sk3+K6keudd76sKgjxX7EK9zfKcG+QP+yMgUBaFBN2NkN4pPug6aWbaXGXwdRXOXRnHbMLZB/MM
	xZnb3Zu19fMjrPje3qPc29kCcwBr3NZxW6Rgwq+smCvg1XoTugpPR0X35DKltxp/+q/KYBm7pze
	zAo6neFXAoOHmlGGk/pGr2LHWqud741TwWLIiqaD+jwZxILjSGXOHdDjY3UOh3YurSAuWR31xQS
	oWbTjyLa0hL/S6LFiJpMuD5BD9dBAabDo/wYZt4gFIgcxgWT09fvfiBI66TVok0y4JnTx9HmXR8
	BjiAVFa2UtN9lzvVfKIf/Ea+NMXX5PBMO8Ouq
X-Received: by 2002:a05:651c:10b8:b0:38c:6b40:c6bc with SMTP id 38308e7fff4ca-38c740057e5mr27913311fa.27.1774845037888;
        Sun, 29 Mar 2026 21:30:37 -0700 (PDT)
X-Received: by 2002:a05:651c:10b8:b0:38c:6b40:c6bc with SMTP id 38308e7fff4ca-38c740057e5mr27913121fa.27.1774845037308;
        Sun, 29 Mar 2026 21:30:37 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c83729522sm12470671fa.14.2026.03.29.21.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 21:30:36 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v7 1/6] mm:/Kconfig changes for migrate on fault for device pages
Date: Mon, 30 Mar 2026 07:30:12 +0300
Message-ID: <20260330043017.251808-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260330043017.251808-1-mpenttil@redhat.com>
References: <20260330043017.251808-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y7TD7SDBW5zvInqgSeZjXAur5mvRbmE0DYquDgNuq1k_1774845039
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1FBE0140003
X-Stat-Signature: it4kqx8ttsqnbio693k8be3nd9oeq11e
X-Rspam-User: 
X-HE-Tag: 1774845041-843134
X-HE-Meta: U2FsdGVkX1/oaYGob3iob5DvxerA5GK5nu7vGmlZZx7x8FMZwt2dWU07AqabFDQUSWvjt0g4Imckb/EWoJ5qbRH6bZJpNErS8j41K7v7DFTqLXo/BLXwDxBLtnFlRgFTs4Gi5DbSJcgXqngna1Q/Squ6kWgHqwLSip+8jIB1Tqrkkzk7YqhRb4nLsm6KtyCZhauEBLupmj46TMfbFkOLze+1RXAabebPd9oXjOYo2KiZh3di6zbMQzIkZehtMq3oyTHbDd00Xx3IGn/v2w1B7t3pI+/6Qj7LcoI6EqC4ZzI3DjTh0RezStfeR9v95WLqEL67ejW1nF3R7Ls4wcKdmhaOjInmWuDKQ4LSiQSGOFX2jg1x/i7s34s0oxXG1mhmO6vM4MEmVpEYk1awzpqclMuMCM8RMTmOLLN2ycqKwovFvlQ+SKDiEY9lqU2ZxdtpBgAPCxw0hmDv51QHKGVMVDyt+N+w5MtSsDwsMhsAkZaa8AOvRkhliTF8ICnrcTtWr73YX3chYTgMqP+V7UgA+fNnIWAwOMlsT3Ohq8E9PXnnY5AwfgBNrPVq++gydJUowkQum51Z9A5+rrpVRzk2KJ/TkwnHUikjV2WsdnqGmHZ2yFXe4jZYj4NDU9ymlBsnH5bhFnWpkKD6/tvJg0QquDOP1/nLRWlwf+1whkfp7IewRvGBLkiE7x9j6Gyr7ia37FhDI0v4PSC8bDvCzU/ZTQ9u76wFgNbqBNKcKUsQzQc75YI4cgBO5DV9nMcdK94p5cUipmNcUcZfUL3PbldJA4G4m/jIIVI1gGOR3TkeAOWYIbRAWtV7442NuNzyvRwH+Ohp36ETB3kvjDM75n30HxzGKickHf4gyrBgyUrW7ICbuXfHpECTtTXN80kISOyTEyAHyDTW7qlKC6UWu+zGUdemoPjlPsgNAXNpcdqfzOE3Xg+TfRL8OYjA1o9ZIHAijBo58zoM9Z/JTuqFPQK
 dzXNidKM
 tYT2wgfXufY35S8zGqasn38X2ZnjBxEuEUY009w/nTss3gLWNj7cra7nhUEavQh6s/fCX+BNg5Ury2Mv+N2PeMv7JWaDNf9duurpjAygJah59XubTKtjZiyYFN5oEsJGjtQC+01mikVPyI+hVV6LscIP+wwTe64f0UoqjnM8kN8HhMkv0xAvfDhZ3Azx8A1mXnLi++CBOaAAKX4fGL6/VxWnPhsAnd5UJlayffdn8rhJGzBw4oTvcWzZqS/jtS0/vs+waJ2C/XhVll+JvX+YibXyeRH3h0wDQhdc9OMQxsd2kH6AbgumGAwa21Uijur1hFtqS0EA3BpZKECbqPAdRT6QbExUjHx59rsLgR5KCI9jSXlL8l1kVbZuBBnabGSyAL3NuZf2r2d/Udi/Ss2hCW4bh1vwnkdxdDltg+j0iw5QzSmkv57xlt+Czzb0KFt1xCNvT2ECHmZbYzuJHn0Taj1VO7FRpbg1BCdgtHyk335lYWkT2TP3wugm/yy975AKQYwiEzTqSn54XDRWUKuosI6eKhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

With the unified HMM/migrate_device page table walk
migrate_device needs HMM enabled and HMM needs
MMU notifiers. Enable them explicitly to avoid
breaking random configs.

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
index ebd8ea353687..583d92bba2e8 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -647,6 +647,7 @@ config MIGRATION
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
+	select HMM_MIRROR
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
@@ -1222,6 +1223,7 @@ config ZONE_DEVICE
 config HMM_MIRROR
 	bool
 	depends on MMU
+	select MMU_NOTIFIER
 
 config GET_FREE_REGION
 	bool
-- 
2.50.0


