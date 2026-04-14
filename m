Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1B6FF531DA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 04:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52C0F6B008A; Tue, 14 Apr 2026 00:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5038C6B0092; Tue, 14 Apr 2026 00:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F21C6B0093; Tue, 14 Apr 2026 00:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 255696B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:13:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C5F0C19F5
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:13:04 +0000 (UTC)
X-FDA: 84655841088.09.CA9ED45
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6DF9410000F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:13:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PN40Msi3;
	spf=pass (imf14.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776139982; a=rsa-sha256;
	cv=none;
	b=XXi8YRRXna05Ys0e/SJD8KmvWRPoaI2nZj4pMHRfifdkw9Zvaogfouknp0FB9wor9To3Q4
	SCcuQmqwYRxM8f16usklm/hNI69a9YBZ1td0KdXG1L/g26DqjqC9SgPk/avJiWVouu6NKK
	Yi6vSNN4RlZZ1cPcM6C2zOGk3kpNfPs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776139982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bp6pPh2X7xEOk98kCGOB5ari2987Sw0Wx9pM6w06sw0=;
	b=aml/WjabDtx5Z25x0M6jkINjQJoUB3g6SGg48i6nInOenE+8EUdD3XQZTTB3380/w1XNEA
	uA53oq1DIZYr1dgQ4TSx8c6FmsMMJfpQ9KrTuTLE67o0U25j+Dx4qm6jwFvuBirIK1zCpA
	tkdevEBbIH84l012ilz2iOnq/T+v/Co=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PN40Msi3;
	spf=pass (imf14.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776139981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bp6pPh2X7xEOk98kCGOB5ari2987Sw0Wx9pM6w06sw0=;
	b=PN40Msi3vTcdxuNtcYv5zZjoh+ugFATvl9cLc0XY+vSV0TnGJVZI6kLSVnQddgGVJi28dJ
	02cZvzCqqITUNetQT2j7g9u9WMgUDeFduT/DZEvg3paZ40eqdJ4VU03Ncgz9payXBlIFrh
	j9BwTBpHVRssKv3Xq+QGf153+cTMqhc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-tgLrFLMzPfCSZi9HOXB4FQ-1; Tue, 14 Apr 2026 00:12:59 -0400
X-MC-Unique: tgLrFLMzPfCSZi9HOXB4FQ-1
X-Mimecast-MFC-AGG-ID: tgLrFLMzPfCSZi9HOXB4FQ_1776139978
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a2be9dfb74so2938892e87.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:12:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776139978; x=1776744778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Bp6pPh2X7xEOk98kCGOB5ari2987Sw0Wx9pM6w06sw0=;
        b=gG2fJEG3ZYkXhFV81i+6GrZaOpbQh8Z74Khsu8xq6YN4Bqib7/ppJVudkJ3b0BahRM
         YNtPtiFBmfLwmZqmwuZCndQBDQjbgRVtibYRp43S29c2CzO6s2nKt5uHxV28P7MbFPPZ
         I4FjCRP2vHdxXRABLGxhajvqsMgmdlVpVQw9QkKKzlxuwu6+ujUoQun9KO6zoAezVqHI
         UWa80u6bGHdKxcF8ALIvgSz3YDrHM02j5JFnDBSkdGx66x4nXtW0yOERBG3mCv9jUNA7
         Wy1BwNUFdhUJ0oLXskeXY1/lWOAYTSMesmv40O5NuWAwddSW+yTHkCD2QtsZnZcMYSpn
         dBZw==
X-Gm-Message-State: AOJu0YyuOtDjuo8/288F1fsziBUkhm5GBgLkRaU1jnSzE9baDC/M6gKq
	NobcA8g72AA4hQrbW6Fg48pJtm9ghvQNOH+6PE14O37mbWprEJyN0B65SW8SrkrwkWvLj2WIJsZ
	/gh6DmqnMfYTvBRU8QsOG+0aev3d8A8K7PbaR+WOlVhQ37TEdSeDVuRSBEgR0zl+8dncL+1kePq
	T0zxCF4X9LIgkgFu2+zHZ/mDd3eo299elF5HNeDA==
X-Gm-Gg: AeBDievSJ7tYMzPPEs7bc8hIGxv8Vr+Ce+JAnFj7C0MjyKjLfV3LqO5FynFGgxfhv4z
	Ue4297JnurJ/0Y2rUUWRvFHBXzFPxFIXS8sKnYejgy1Qup0YMOkMPTzzq+FNF1eqWRrCjX1xQco
	Mkh31N6IlJCp+54Gs+aVVXQfvKhlOXxja9G240BtehqnqR0cHMOE+JK761SDWSi3e3JuUj/MWQY
	6AeP+8VcojSXI6HcrEQQ/jTU4LtbINPKJWCIdKZDxi0UA2wX1zZG9CWfatlVfBaZdo9R4WXroyh
	mGZC0Zu5ppc7FP2jHQzKNL5yWhTCqii16PKj8U/ZPZDsEZgTGCwwCt3gH7fF4CcRTQ5ivfnwFnV
	hDAlW0SakQtj7nsokdF8BwoV4lD0kgdl4ckLb
X-Received: by 2002:a05:6512:15a2:b0:5a2:c05c:1199 with SMTP id 2adb3069b0e04-5a3ef904b66mr4996134e87.15.1776139977631;
        Mon, 13 Apr 2026 21:12:57 -0700 (PDT)
X-Received: by 2002:a05:6512:15a2:b0:5a2:c05c:1199 with SMTP id 2adb3069b0e04-5a3ef904b66mr4996113e87.15.1776139977020;
        Mon, 13 Apr 2026 21:12:57 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a3eee865e7sm3040666e87.10.2026.04.13.21.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 21:12:56 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
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
Subject: [PATCH v8 1/5] mm/Kconfig: changes for migrate on fault for device pages
Date: Tue, 14 Apr 2026 07:12:22 +0300
Message-ID: <20260414041226.1539439-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260414041226.1539439-1-mpenttil@redhat.com>
References: <20260414041226.1539439-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JadPtS5_j2fMgLVs4wriWjRyLl9p-i_X04RIgi6IpQ8_1776139978
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6DF9410000F
X-Stat-Signature: bx751tcpzizuh3xtksa5iuenqp8d9cpw
X-HE-Tag: 1776139982-810492
X-HE-Meta: U2FsdGVkX19SD6l1HGjctBZonxbMKuS+xDoRAr6SSWbTPhp9d8ebsCyLHiTjKzClHAoVXO6M6HQDxwUHNHUzbZ1mCmu3rQ0yliFtswvYw3B3jTbTOrUDFb6BoFD6NNKlBXTtXCiLu2zB5pV0GFQ47k5+E/Mid+pRhuRPP6wRnAVVtY9YyiZ7Gu1fC0hyFDBlhOHYpRNbIEb1SbG+5cg2ML3NXD5ZhqXCYeh3o47ZKkl7lw2v02rO+6yh9Uv7se79dx8E9Au+35uTbQ9GxOgM28MOYy1BAmhe8fTfZvk2Wj81c8EnYGuCfQLmHL15+CN6Bivz9zdskntCyNPDpWHk5fsWXQgeh1mLekexhtd1cUS6JQDhC5Rl3XiwnZmWV+laD1Rv9fiaTC69+VPAarNlBapzGZHJqg9D8FeHQsGfGE/S/Thj+Z3nrUvzsFe4ADVRcPFWIHNDj+DLV+Ra6GvhUF/03IKKw8/10hxeJ4J92zvmCFPNlPsFSeeMWOKsSzsgwg7BGA7QAmO0KfVZ6PenePqeKrn8X81x4WLvG6Yxm/9WaJB28mXxnA9lqbZSjht7xNDRUWanJBEZfW2Zh+Vqych0nqhEshVxS2k/kSt9PFfJopJyRwLz2LrPHEgCrtOMLRh3/t4uDcD/Yt+eJ36pGHUc/cFT6aBfbF/2uOlIFnR3YEjC7k1bnatlBQAVtDkVkuXhg6e1uS3uyBxGARBl6HNCmpxZ6VoNtTbYGSvUYHTWownHWr8GWkrDWLTSmDsa7ZMirChhV/I4pTst8TxmflWOeqwjDr7HX7wcZJZ2LnfjZMW6BpIVw841B363r6jzd5LN19EX3wJMIfnSs5ybkD6axZO3Xw4aLTKCW7duEDgcFYHY+eAp7SY0bs5CA9ukqK20b13ojur4zn7tWBMF0mRlEK4A6FoRycTqQGv7KkeeJfVu18v2Dhfk7+g2rWh7OqITPb6vLEUEjIIRUul
 urEdDynC
 jHMfdHKkY0kHcjLOTIGR4XzIVqXQM+iDhLSB3IBLg4NHvtzYYZn0T3cBXtkDtZ5FofFjZCIysopbG0Vl9RFD9GLf6hFSt4xinQSWHw/yaMj2zpL+kwIx2HZ8o++ife2Gn3j1W2S6Ux9XIpwrl7CH8aQRDmQLP/DFYj2KiWfl6MdfPpNF04zOeLIf3lXutLGKG3suMKBgn6duvbr0IenQiXTb09vnciUSr1WNByH7lMaFICuNoSaWb5V8XKSGuWFlEQkzyAgFEHrFVB7nfZ6ysV1VeBFkS+ylMX6wF8yTQEy6Vag21JOTlPZ9kA82g95e+RAbyzDRbSLs5q2WVSar/2SRsTJ7c6Ntrunkn4w22aDQ7MqcoDW0fcXDseTT52JTkdp/pQ7Pd0/XKmMcW+E/rfqb7qDe7zPAZTNYv7n4tzmwR1d5Qc2engxWLG3s5BinkGcXHBa1av0wjWjmuBmGpcHINyezF85qJbxmqovizVosQMH4vq0wq9UcCzWtJfGmU0r+20szwGLaE21hgSgnW1/X1FQ==
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


