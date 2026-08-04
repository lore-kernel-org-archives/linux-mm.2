Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D503C55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 690416B008A; Tue,  4 Aug 2026 00:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A4A6B0092; Tue,  4 Aug 2026 00:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5095A6B0093; Tue,  4 Aug 2026 00:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22ED26B008A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:26:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8177C408C9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:26:56 +0000 (UTC)
X-FDA: 85062301632.11.F25BE97
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3215A140007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:26:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wq51YGji;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hwL36eymgoLnccdesFRfeMb71MKt5ljy6aFM5YklG3k=;
	b=vZSeapxXyqga53acxY4amACZOdKr8zoilrDJcMLJdUb0Rp9WnTPjuCry9mKB/lMulGv8sq
	H1hVc8GH9bpxxnemsDWuioYEV9tXSPxfvM59o+ZOt/TcKqm3gsXArZjdo5xK9YZ2ELVSFo
	eUfgMIRgRpjS94peOr9i8igdIM1TTW8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wq51YGji;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817614;
	b=t9GnIFSs32IPdUD7CEjpg1DZrC9cYnlj1ynCifQmREphMQjmkYgXy/ylD6vVWNYOSRjnKD
	ghBrE6EwUUPUq0ZVHkTpD+zPUIZw4foMkuWvBbGwR9BoWdwkABft+H+qiSYjFGQNwI29g8
	gMdS83WqtyWMDN/KOTHOnPP9HOUswd4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785817613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hwL36eymgoLnccdesFRfeMb71MKt5ljy6aFM5YklG3k=;
	b=Wq51YGjixDLeHhsKYX0TC9gYhPWfwK46/ZDK7kRDjnL0TyE2eBOiGpZ3q1YqjVmdUs2aSG
	QtOIzWDyLQ/rHaq0vtQYufrMYr1yU8d/pbe1+j/SgAxBJw3KHWet2yeQ37HJZofNBlX6de
	nP2aWOiQ2FRwCoWvOLLs632R/AIuxBs=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-SEqPhioKMBqmMioCC2ZpZw-1; Tue, 04 Aug 2026 00:26:52 -0400
X-MC-Unique: SEqPhioKMBqmMioCC2ZpZw-1
X-Mimecast-MFC-AGG-ID: SEqPhioKMBqmMioCC2ZpZw_1785817611
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5aebb33d6b8so2747820e87.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:26:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817611; x=1786422411;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hwL36eymgoLnccdesFRfeMb71MKt5ljy6aFM5YklG3k=;
        b=VXLySngIc+cVdbs6iM2PJAg/mAcH3RAsLBfbdaCL9gEthT+xm8L2Du1tKzidHKVMyP
         zfiDxGVd0Zrh6Cjed44WeKXWTROlj1RprE2q1/ulTGyxyRHS8ehfknxBXpwCOGGAOM1d
         AbRBMWUv8mkYuTs41XDBFtipgDrm3ZOrO3Qk1U9ewFioT7L03bJhRaazMPdoS1HHLWKM
         VGR4Uh9tQSA6tVb/tkNQnYr6ysWpu5f6vdG8DG/PIub6wQEt5qeRBDPQp7RLb2BdGMIO
         Q2P4SKmypG6ZlnYfIDUGhNUS79xBTzEbukjRwCV+ZSHpDjXc9c+kEra6HwD4QgZ9V4r8
         7/3g==
X-Gm-Message-State: AOJu0YwOutRdI8qrtNba32j7SWmGPlYsf0U75c00fUOfINe6oxmhcBym
	8Xwy+OLdpLsNluXykvex9pNwwTzF+4BPxl8HjBTpT83Mmo4L+yMaJSU0Mg+HQR7PJ2bd6lk1BTW
	b4rqeHpZW7/IbyIpp6Ogt1C2/05nGJK6A8kt/NnpkOeJO3CbkmtjBziwEIE/lwTkrB2Ns09DAmQ
	W2o0hjBcCcg5Otre15a6QSMZ3C+IMxlz6DOZdgCA==
X-Gm-Gg: AR+sD10gzVboSd2XP1jnKJ9eRMf7yETvsPsq+VKD93iVZ3x0QrIccTrgBlv2X8G6HQF
	iT/iWnQ5MQonWMCukXiVn+gX3MleePfVnmW8wpvTyp8hl0rPDoCPwYp7ya8FJd2Q2hdxo9AIkHG
	OO2AS5WAes4zxaq78oCpZnn9DsQQ3fszAWSL6uddhMy3H73t/TFdUmv/MBGWgFEmv82GyuFsgWa
	bNSpJlaqwaYl9V6AcGYTq/zFHMCubiKf8a6336tiON7kCKZE2mFAGcwZ+wvC7tQ1n5+hMU/Uggy
	cQPjwnDWsNVG5VgCujm4qVN5QyeefMCSjGC63ScVZwrN4ClT6rKpwJKqBtUIpO6MqDmHa9y91G/
	MadRxG0I7At2fya0A
X-Received: by 2002:a05:6512:3c96:b0:5b2:991f:90d1 with SMTP id 2adb3069b0e04-5b2e4f3cb5bmr2664345e87.26.1785817610794;
        Mon, 03 Aug 2026 21:26:50 -0700 (PDT)
X-Received: by 2002:a05:6512:3c96:b0:5b2:991f:90d1 with SMTP id 2adb3069b0e04-5b2e4f3cb5bmr2664315e87.26.1785817610290;
        Mon, 03 Aug 2026 21:26:50 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23c46c4sm2311351e87.17.2026.08.03.21.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:26:48 -0700 (PDT)
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
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v13 01/11] mm/Kconfig: changes for migrate on fault for device pages
Date: Tue,  4 Aug 2026 07:26:21 +0300
Message-ID: <20260804042631.2175585-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804042631.2175585-1-mpenttil@redhat.com>
References: <20260804042631.2175585-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8uYRkRVCX-zdytfjd_-yvslKhDONLHzM_6i7pW5zppY_1785817611
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: epzeqccd5xpz4geksy4931brtxjt64cm
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3215A140007
X-Rspam-User: 
X-HE-Tag: 1785817614-972389
X-HE-Meta: U2FsdGVkX1+WNva79gO0Td35k5OWgQnKubvpeN7xxY1Qd+ZlxSjCiXm8TrWrnzYImFBbfE0JbLwchkteJgvxs0itArx+U8Nef5Oz1LCjDh/L+YAXJhNdet34RwpzYU/ELP01j6e9geK9G2zUCAq5hfkxMQmq3mBMxyjmTmdY4IIhvxQLcM8tny9HR3SKPoVhN31PeObjgvK6zGtNu1MSIiz7wJFfN7Yku7P9p1w1cYuCkHyTsFGLmuaMin2CJOMOS6vFUjbNFQUNcRUzGeLcKUMx6KEwUWChrxPe4TkL9x/BoKGa6k3VQj9QkR0S2vkJgFYPw6dHXyxPEhh8IWyrsK1fsD5xWUCC7+5I+GxheMQ4Yxyp41xarNHF9oi7JSNPXIb39zFT0raEAp4c+LM2nlf45pE+EO8fWUpxqOdDq5JhWbhfndCviwqdz8IQcGH8C4CFjfFDfWLf5PmUjeaGD0YtV/kS3H/gXQqkpyOpBkydBbtxuHeqXVI1r7UrtmOiGaV6ohuBGzX2SuCyJUkE56RZh+UPZP9H0Kv9Vu2l9IC3RjCyrpxDIbIX7ceXU7gQXeB/0/BhvY6luPVV6vgREFoXTE+ioWIAOmyWS8n0oCeZDYsPffljH7MJ3K8znlQxbVW3SQFDiuE0MdmFkCUET28G16WUerWdgVT4rErgqOJNGKlJJmQJMCMUNaid5pAkTrRB7hR1aWs+Se/Ek+/Yx3K01RjLRhO4d7xuWvo57yv6iohd2yPSnkRW+kzuFYwGo6CzH6zMoNPqSzK86kpsAMlh6o/Ju6V1nRqnFBXdqmq2eJ6ffJeXoeV3+stz5RBLJm1JNm1iIGAwGgb6j4Vty1awiaIIYVqGgDCcKYQcbdI2HcxmsuGR9M7CcKpRQTtCrVs3ZF3/9cuL4bED+sj01AN2sY9oTc7aI52ReO+w7EeNoQ8MtMWTx36+e7yN3kXSQyQ85oQ+824/PJZtTlc
 pjKMP1u9
 seO7EZaVQTTSeAURzz64M2Wz9FiBRlEO2PnLyoZmh5dS1EXcRDqj8upxD7AYcWIw+LfAuJZBi+t36PIsnkrrSVp89C2yu0XvGxcBzVwdctV49CQmqiG1vSmtCfE15PzLqSSnpZUfv2aBtCy3/UtWWZgbJ5TL0vZQ/g9WI9iAcJhfcyipd+rsMZB+pvIY1X6pJCPKtjdrKU1K2h42zkTuLgNx7RqKyR9hOZYD4S51KlJI9YN38AN7n6t/fKyKzzziGv56JIlOAPjMStmJFqpz9Gjg9itIHp/30PL0HNIxuMqrFv1057LLUvukH8ML/zovIHROEv99Bun2scmb3H4+T+iBPBgzldwqKk7Fdx3Gr/h4e1k2vGqJ2fsGGobNr7w0c+ZQKKPNE3+YDbOmDkVbA+7OrSv3ik3McLrPjUDA1HAbCimZD3fzKQIxvXBlXxQEX02SZciTgP2f5zwweLvejwl4DD2pODWqcgh0p1oSmN85pocQi6tZhll2IRq/3PU2sXGbVBe7BxleHEKYjVK9h92XOETZfHkwDDBJr66GtAVw7llxzlPO/7l/KmL/nfdy9xAfCB2zrpE9agbpxK4ulBx4b+njJ002ePTOQNNw2lt/aVKw=
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
Cc: Lorenzo Stoakes <ljs@kernel.org>
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
index 9e0ca4824905..7647671f37f0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -699,6 +699,7 @@ config MIGRATION
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
+	select HMM_MIRROR
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
@@ -1260,6 +1261,7 @@ config ZONE_DEVICE
 config HMM_MIRROR
 	bool
 	depends on MMU
+	select MMU_NOTIFIER
 
 config GET_FREE_REGION
 	bool
-- 
2.55.0


