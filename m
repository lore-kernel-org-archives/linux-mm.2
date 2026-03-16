Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C9CF3028C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5D66B012E; Mon, 16 Mar 2026 02:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625636B012F; Mon, 16 Mar 2026 02:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2966B0130; Mon, 16 Mar 2026 02:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8886B012E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:24:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2D3E160626
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:37 +0000 (UTC)
X-FDA: 84550937394.27.6957CAB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id AD2F4160007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AsQ819+i;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIIH/Efdgoi6aCf5h+6YrrdzeWxtIaKwFEFPrl5xCCs=;
	b=P0fPelqyyXLcz1AQPwb63/vgN1igg3fGkCWTJ/9FMNO7BIrs1g13iPcLX2qYcd96hjJknu
	liVv1FH4TQfRlwdq/rQtSM1I9YvgayNK+LcU2MpOhbbaTUhPv+1RDbAzuCTcrjV0v/fvE1
	LrxfVPcjcAwqiBxdBODa5iMhfksMvtk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773642275; a=rsa-sha256;
	cv=none;
	b=Yh9UUhzrxA9sXvP1r9ZFnS2YcSOUgddMCZA+q4ujpf2YzSj6jhP7KZU8TDmWWQzQUDXgxy
	dZ8Geki/vOO31Bl1oGuwm+IepfRJQdp1QRXgMUhVxQDAH2IamZ6qKVfXqZ6A9DmsVViwTA
	LEE0zRpZuiyBwK8P0urHrGZhCf6Tngk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AsQ819+i;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773642275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CIIH/Efdgoi6aCf5h+6YrrdzeWxtIaKwFEFPrl5xCCs=;
	b=AsQ819+i11H1ou8j8PT35B9BYrc8zGWJAmRYcWCGODSuu8tFGiWid4hZTukiCMydBXBvCX
	sKyYR6p5FnJaIsvjvXYPa/NxBTD1s5uH7/WOlg8o9W//z42E+yh0/VjMwcyokFoAfYx9U7
	wajD4/Tqgi7xWJxq5RMZZU4VKzyr9Xc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-GrfxbJ97MFuijir1dtDOnw-1; Mon, 16 Mar 2026 02:24:30 -0400
X-MC-Unique: GrfxbJ97MFuijir1dtDOnw-1
X-Mimecast-MFC-AGG-ID: GrfxbJ97MFuijir1dtDOnw_1773642269
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5a127cf57dcso3239801e87.3
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773642269; x=1774247069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CIIH/Efdgoi6aCf5h+6YrrdzeWxtIaKwFEFPrl5xCCs=;
        b=Y14k3BxVxx3M3tgqBuA7MPq8mR17EFFHtQUexN109aG/2BV5JDhlmYKgYGrqFk4QI3
         daAdKanCG2Cz5kaGg0DIKdnQ8iHCCE5SFPSvDlw02GyWUgvukHUfFqJwrXa004ckO9Zb
         OBdF9cb/jxTOGlQNK0CpFTbYo6L65KOzFwyOSamDgO5FbXLeu02eU95h6l+8k6CP/8lT
         H7Fz5G+GSZDckF7q7BI+pmhcdwpxR24rywxtVgolWRjOzNWj+TyOYTtZXtE6EgLDt/6M
         sbEoSR1aYWEMGdBJticWnwysYSqMv3Rt4j6mQB7ZZIS4uWGUhEet6EylKFIyMp5K30yX
         EblA==
X-Gm-Message-State: AOJu0YzXslYMi3ZUWpXkKcfqmMfa/9xQ+yRdAJmBk5PTqpE6/XvOWJoO
	Z+MYVblmRg+PkG3q/Gfyw8gXjw5N3bUkGzQtO/u/QHZFsnUSrciXwfhjhrGEHvWXRM4+Ll+fiLR
	11gs6/4So5JI8F7n48mglc8VPHsYAsueyHl98fFB50VSF6ARHiCDvBbNx3onFMrVSI3sZTBYG2N
	1e+LfSBE/QmlziHkmKW861nfEbyTThVaiUqBx/Vg==
X-Gm-Gg: ATEYQzyJcQ6WTBQ2lMZ59nDDGChl+woHkFYLQer7GdkOuBlAjnRLfie+xm7/pEsFegz
	ct01upiHx/CbTNvYSL/f6/X3ZnieiDXvhuJbfj6eefuGq2P4SJQRNfJHBa6v2IU9Hgvzd+snwuh
	KwWlgygcfMxSSXjlT7rHfCiyGxUeT0owx1xEBHW2nbNvjy+36vtDHiBIkSSJs6xBvsUO6dyjBBx
	qV+23nn8/dqZZ5jmYEHlqAejDlLifgDNAoNhiaVOUpKg5yGegX261lYCW+nqj4H1Xg8KPGtdOXf
	q5EEc5/9US9eJ63iPD6z6qbFAS0+WwgWZ+pg5aAO6yQFTBClxA04pt4Rp6EVLIOJGmCtki37KES
	IeXt5W08b1Si2iW6DKsKb/M37uv8r91HeWtP8
X-Received: by 2002:ac2:5968:0:b0:5a1:3ebd:d53c with SMTP id 2adb3069b0e04-5a1626ffa87mr2464757e87.13.1773642268732;
        Sun, 15 Mar 2026 23:24:28 -0700 (PDT)
X-Received: by 2002:ac2:5968:0:b0:5a1:3ebd:d53c with SMTP id 2adb3069b0e04-5a1626ffa87mr2464739e87.13.1773642268214;
        Sun, 15 Mar 2026 23:24:28 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15602e692sm3263397e87.30.2026.03.15.23.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 23:24:27 -0700 (PDT)
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
Subject: [PATCH v6 1/6] mm:/Kconfig changes for migrate on fault for device pages
Date: Mon, 16 Mar 2026 08:24:02 +0200
Message-ID: <20260316062407.3354636-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260316062407.3354636-1-mpenttil@redhat.com>
References: <20260316062407.3354636-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jFfyMjn34GOVqEWuuK_byUCDWayVVSkwU74AyBQpsPk_1773642269
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD2F4160007
X-Stat-Signature: uu87tajkd3zqeg5ey8medp5yejaporuk
X-HE-Tag: 1773642275-328259
X-HE-Meta: U2FsdGVkX1+FQmF9mA+q1tHtIEJlkG6VwkfVstDbexyeOfMWlRjOq+fHZX/IdVekD8fqvyJsG98uH5tmdjrXBoJ7znKSsuQeqL4wkmxVLBnIUC+n+tlH0u44pnc/D6HELmQDoIS70EU09G7NBKlhtj4g6SMv3gwBDi3xsKcIeqqwxmIHHyVPYpYp4pEy9l0+igIXw4e0iZ+OQ+QDogBbAxMnpvIKyLFE8n63X9jevqIAPgvgoA49NGtSKKe8Ogal0Y+2BV48SqvRqT6qKJEqZHcCQAK1oKIUQs+lBcxoWkGsCdZKk7ApPVETL32rxiEvJid3J9//9TK0e0thrRSJTfole0HyLq/BphTEle6OSXahXLRX//iXz1ix0lLe0Hbjqu8xAeVS6PnwwSvT2QxgfnkzC/bWXbVAnPX/zTDAivscYKxU3dHMUblLLGuj325Rc5EkhwPN27CUVQm96r8LEwcDywrHvliCJfmhNKSh0HRgN8oou9pIR1F5O5au6g2IOTQl917YwKydpZW3O97BU4x6neXh7FJ82KZxFxL7B0BtKrCcmpvclHaci6GSbxZ8W+vJhh9asVWC8/hZ7PjQzt4e+n3qMKrrohhv5zUYzB7zqjTKcLuPb8ZuGBJ/gdaE6NwKNSPLuy0ykldKgRP3tzQDv9DvyuFhpGzZtXQobyAXDEo+Seat7qrmu19zapjRinzejoR3zkukhjZNKnU82HMjLiHdbZ6yqrZ5cKej6YVP17JYKPGDnnT4dGEGQYVEqEOa3gFsRaSaquwLkX6Dxf8XWoJA7GFZfaJ/aBlGSRajCnoHyycHyL37aKJWs8EiqFec8eFoVryzlvT0dIiTj/5wi5RUzvBzY2/d0pnRWyjegSgRhA7ICco6Iy+pE3jd1e5vNXm83OVf1SAfQtpc/q26cIetimOwjS9Nf1lsdOBEuhwD2SGuhBqOfKSYr+4+SUF/oxfiO0IGPdeWhDK
 FwA5ryG+
 6QA809NjzZQ2bm1DkKmlvJvLXHlff3TILAyuUTvbE+uns7u21oc9Y9GCDUL4RHCEASO+KmqrRgn0ogXajmabmV3o9Lxie2Sod5IIDwBE60UF13P8fu1i598zg/Wbw4nZAIptWGgk3eCs4D8xOzg5VbgvRnIUiV2IjWrSysVestW6wfUOz1NZJo/f8vzyqZfj/15R3opz+GWRsg/Cq8aPYZULOoEpL0AOojv3R9PSxCc0UIpW5B3eCh8bnQqHx9WJM6QGR+SM6U2pkIuMcS5RyLSiXG6w0X+7EKoJAfQYds3j9J8H4d0T7lQzwiamWvw4F232k0yg1AwKcRLx5x/oGcg20Dn7UveooxFMzbNrewdO3bWomXuKS0uiuqapEmyrrsmjUspWgIxGdxEUCUTuyGRfUJ9spk1VM0HpA0AtYqtfgtQOxPRCHVVnjJctZs4Len00LvTGTqIImTifZUTqvIVfeZM6AvI9JqUzvBiCrx15O/d8bGi8KfaE5IYK6PysGkYgqQr/cx1jRPgWuJE6UUREFZQ==
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


