Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6336110D14A4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846AF6B0096; Mon, 30 Mar 2026 07:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0EF6B0098; Mon, 30 Mar 2026 07:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6983D6B0099; Mon, 30 Mar 2026 07:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 57CAA6B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:56:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03480C20E5
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:56:49 +0000 (UTC)
X-FDA: 84602577780.11.9B9A1EE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id C993C40009
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:56:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YWkKraRB;
	spf=pass (imf17.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZhz7TUI0zV50+5LEjo8lH0Seax3sAW0V9p7og3voDQ=;
	b=kVp647KqqBPIMFxeXa2RqgQ02D+OBDnCHfDpfI0kbdDTTOF0Hy0GKJZKRjjPZgLGHLmATI
	0hT4zGf8fUdwyJ5IBqH3hiBs4a9oXacGWUXjrjnysnB6TuqAenRX4lectoFE3NU1Ylbkf6
	xXzvNuSs0byznE2a+QiN/X7T3KXDMBM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YWkKraRB;
	spf=pass (imf17.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871807; a=rsa-sha256;
	cv=none;
	b=8B1fJD9lGsT8kCj9vGVCYnjLNLDsuYO71M1WnYCbB1fDfL04ykR+3xCqIcQYy9vxOlX9bF
	cc7Cs+m1G4mYhvPFInSfy5gNU3SLMZGhnwtmlB383sxecDu4EXm8bEmVz3T0I1W+AfP/6Q
	Gbl1nJP/Mejw9ky/I7Hpin6IAcKuCzM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774871807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AZhz7TUI0zV50+5LEjo8lH0Seax3sAW0V9p7og3voDQ=;
	b=YWkKraRBTLJSovuIKViFow4LsoqNjvxmF3LUUlp3WBvBheZ1Ro3FnZ0JVvPDSrXqgjVHT2
	YWrGao7/rg/rabH51atMliZOPdd7EHzemRG8PMMAH8oRWh71mRum4+41Js3eZWClbFRTMD
	0PGCLVjBoteMTVX2N9Iulv7tiwKy24M=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-RX_noD7PME2uzsc8Qcpt3A-1; Mon, 30 Mar 2026 07:56:46 -0400
X-MC-Unique: RX_noD7PME2uzsc8Qcpt3A-1
X-Mimecast-MFC-AGG-ID: RX_noD7PME2uzsc8Qcpt3A_1774871805
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-38a2ad13c07so21245031fa.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871804; x=1775476604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AZhz7TUI0zV50+5LEjo8lH0Seax3sAW0V9p7og3voDQ=;
        b=JLjY/AZlYRA8luCDYWUUZXl8GuNii7lxUrDQwk6A8Tzhxt7p2fu93AVVEsezpny2L6
         pEXLNiucxe0GY76FOTLUH+nxm9gTzWopzJBWxx9fMx0fPXeksfs7zHjTaQWXC7nOK8S2
         wuQFCB75WXozjjrwFnuTm7jtZYjYKd9ZXOXluFIz8Df9u4OU5mS+5lfZME4ROyjcAtay
         W2uvJFIsywzKRT4dfd5VLvYPMilpsFSu7yC78gcvUDwdXmrLSIK18ZrXmJGhw6MYUmYU
         h1f6P5lnyNeHasJmwTPiGrJuQA3PpJhPj0xgSyXOf3fo1VcDCH6M7vauUwHKh70JmLsa
         h83A==
X-Gm-Message-State: AOJu0YzWd9RdsV0Cxhtkv85HC3jGCfcW417x7Zpf69jJ0OhddwjBffIb
	2A02jtMC2bwu1+MOwXpz2G55QE6oAonfBtGwP1Mv/1y5bceu187w9mpUqLkD7QhtAn0jr9JcEXZ
	sLxSY/CSOSXkrdJQfw3q5YW4sgjvveF5S+gWToazMdDcs/VoKgA2I9zxzdmrsIMo8ooRfnGL276
	LZ2l8qq/s5kYdZCc2bBdHByVIZFcDaTmOTAajROA==
X-Gm-Gg: ATEYQzyDAvpjH6Ir73o1Yy/En8FMvXzfpxozGTgU1LMVmIsD3DY+38guHn3S+LOOqmx
	CVndcu5eI4nsOf3P3kqKdHUnTdJ0Jp5tRoUWPEvZq4hb9g1MBc1QFGRox5LgAeNoudmEOUs7Lth
	lf4OtEjlYdcwKKI0BJOdm0Q/eJ0yE4t2dK3FLxVLIrbgq2pMifa7yemipdHmaIcpx9/C4Gq0ckH
	Td+eXuqklwkPqbjvozYdi0DqoJVemf9ScOKFSULbcIUPqd73TaeZOLBoTmKAJntqpONihHh/qh6
	eS6+mJqo8K+X7kGYdCuuAHgJCLw9+JGlrjZ9aG9ncJgu2BNl4zV6WY4lrCg/UyTacDtcegu2bL0
	wzQXH7x+v3v5ZafCHCfExriEeHqpjGK3RNhz+
X-Received: by 2002:a05:651c:1502:b0:38b:fbb9:42c4 with SMTP id 38308e7fff4ca-38c7306a69cmr39104761fa.4.1774871804118;
        Mon, 30 Mar 2026 04:56:44 -0700 (PDT)
X-Received: by 2002:a05:651c:1502:b0:38b:fbb9:42c4 with SMTP id 38308e7fff4ca-38c7306a69cmr39104441fa.4.1774871803499;
        Mon, 30 Mar 2026 04:56:43 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c838daa4bsm16330071fa.32.2026.03.30.04.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:56:42 -0700 (PDT)
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
Date: Mon, 30 Mar 2026 14:56:06 +0300
Message-ID: <20260330115611.347988-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260330115611.347988-1-mpenttil@redhat.com>
References: <20260330115611.347988-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rpZy6yn5E1m2zkFcRDkHvkjSyWlIF8xqYKwcTC6gPY4_1774871805
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C993C40009
X-Stat-Signature: o9qjufmr5w9qtpwgmb3ne4jptd85i8g6
X-Rspam-User: 
X-HE-Tag: 1774871807-453014
X-HE-Meta: U2FsdGVkX18w76AZd3frAy9vJrA40zBRCLtCquqFuknYOsBD598MCHZGMm6ZTQMqGEO2sV1O5ZB0s3z/Gc0YmUHuaVm5/BIZaMHU+vzVu2ekf6D+wB3zwGvJ6uS14WNTjT4zeZuPpMK+nWcBif3KeaEEo4yDC6yJd57lCHU4L+t2qSZNlHlyg6Shr7afLQodnF7DHXSlXuDgqsesrXXj4sb1RhZA8pBC+aXjdWM+RoFDepf3Y2/QlGEPPtbg4nA5MDwZNVoW2mDANCcqGW1mtC0emxB6y9agwmS5ijiLFxXrucTN+2q2UFKACJaPUyzoSTIXIvM0lBF8e6ykcgdqOhRbckyTGox65TBwSPi0rnjulqHugHN8nimKl0Cf8+HtWnnOQNJ6Rlz9Ssr7wyk+lb4RIJxyK5x71D6fvhFeFe9kQzGj0THRmBuT2PP1x8YDDamILvg/QtbKaImK3gqJuMjbtvMUG3HbF9BxWQCXmXqcCGe3B24PrCHA6DTt+jU0XxmngrJWbcggxWUiWwFx41C7ubbGx9gXXRfA3vU62SwR470pTvvZK6OgZYjLA4qZMSOFVRZr4TYclnAWqAu3zeZd36dfxJF4y0muC/OEVcMORE4R5XRva5BJUyd0uMhj7T9hed96+jKah0UOdrT3OBSagq+cGzX4hN/S1TsSQIu+WCIa4PJihbsiQAOM8NL6ekrj7em5v2pPXRxZxNx4Mol4+6Cj6ql41XlJyTBU85PxbBmW+gwoquzBTSVUPcwJRxU/Y/5MDtOk3lquP6dXs/xsMyDEBjrh04H3k/RkJXfTIfgohsalJm6aEKZ2Q/erkfPG2AfYJYYOEFbyRWLFfFgxkmUt0IFwM/vpbQeUdppaashHw+mN3n7sBOkOX/Wf5c/Q/XwfRi2ru8RTZYqrLEZ8hYI8fxMkIliIH/LkHVDIVC1hp0ouRdYwGyoQ3+1S8eFdETHdGBtwVlIWJAA
 eGnddR7k
 abWiuqU5Vt9mYHgtxyYVrCzsfqRE+A21J0MVm3luxK13jJcHWm1BUZ0CO49o2LWoWDwLXTGpVjeNpxKp8q58AY3p36I2uFBUMlvUsInEUk4ERGJuzNxGs9yV/5sPoE/sKsA5mke8eZPwHX1C0xZQhcg6Cg5C486cPErkYC5stvtxzfCqz/eLHtDBZHmfV++Z9guiiffSWd/P7LqGZDREgMZzaNcc8qvxKfHkGRmOnmwDOpfAIrG4/zExozCtlKVShYSCUiRD45TcATolIrv4PV1MbpXyTg99Cx2wbKEdv+WlsjZlxwQoh4n1HSawDFFVoc5lmjJjxx/DToAJiaAbuBuuwKtF9yMqccey5OXxPasWjJsteIK62o+86+P24FnZjfWJ7V4DGdDKktCRJKFAmMgRLNtYKevf36ZVBJUQI+QyttP5tOZ2n2y0mSr1Pqd5SohN+KjVpM1bggXv8nLIQmAKekq8p7MVWDYQYPfod9WGgS5/jM3iUnYntjTNFuk+q6gQwDH+njaNPF4a/KaHRZfL87w==
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


