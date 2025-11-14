Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C5BECE8D40
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B80C68E0022; Fri, 14 Nov 2025 10:05:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58D28E0002; Fri, 14 Nov 2025 10:05:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6EB48E0022; Fri, 14 Nov 2025 10:05:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 957C38E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:05:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CF6B14041C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:05:25 +0000 (UTC)
X-FDA: 84109536210.01.8AC5F2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86C7218001D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:05:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Oz3IZmNY;
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYsxd3auPHrfEyiSRiw1uwn1LfepSkxHHrao83gvKCM=;
	b=zH9gOpUVnuyh0B4S0FA4qe+5kxlUfIhGnoULnOPD6icLeijveYURM8b5Ha1QHktjIO8OyI
	hMFb4p0lKr0QAmvSsHzo9d+G7nSi/xoqkK4BX498tNLBqxxPUvfMRkvgyuln3A1hsj2usH
	TBVxBwC18P9S3AGVzfCf7hyH8F17y/8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Oz3IZmNY;
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132723; a=rsa-sha256;
	cv=none;
	b=Twoh3nfAKP0cL/5JjRV5OoFWDNHX0HygFKNUnBOm2GhLvEBEmzjvPrj3gn/cF5h2haFFl8
	nOGqBabGTrDlcm+Dz+iqUHURxVEHoVfj1AqpqiIgXiVS1h7vEjj/OFBbJN97Kz9pIQfsjq
	kD+LkLfl0i2x98Axu0W41IKL9E/KXiI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mYsxd3auPHrfEyiSRiw1uwn1LfepSkxHHrao83gvKCM=;
	b=Oz3IZmNY0C8gwU6NG6pT/wEzYaiwkxKUmUIKJ0owrUC947xbXzN5tZ7L8BeTfOs6LrsvcU
	2mGWva/WWhw57ph1X+zVVkzB4TXYp+sQJiL/PZkCufEn4BrsIa567A4zfHSCEnyT/Rps65
	wPRttTq6j97Gl4Ubf/zmj4irG/swa/s=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-39-6oHxJBeGO0qqNP5iNM1MBA-1; Fri,
 14 Nov 2025 10:05:21 -0500
X-MC-Unique: 6oHxJBeGO0qqNP5iNM1MBA-1
X-Mimecast-MFC-AGG-ID: 6oHxJBeGO0qqNP5iNM1MBA_1763132716
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A25441801306;
	Fri, 14 Nov 2025 15:05:16 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0658819560B9;
	Fri, 14 Nov 2025 15:05:02 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v7 12/31] arm64/paravirt: Mark pv_steal_clock static call as __ro_after_init
Date: Fri, 14 Nov 2025 16:01:14 +0100
Message-ID: <20251114150133.1056710-13-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 86C7218001D
X-Stat-Signature: znkknruwddifnu5m3wftnnf6o1giwxo7
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763132723-38391
X-HE-Meta: U2FsdGVkX19Me55WQMAg2UYKlyz5vJqGk08/xRs+YW/AfpeeOokbhU2jbThpg/L2VM1n89i5j2dSlGaK7iN4PHizSRJJjeJQCHzjPZNx89w31d5bpR0/Zyzkigguq04GS72KmZ//pL7Qxx6bnJADnwpFsDKFzZu2x7WD6BwvIFXFe+w6wpUmteZ7m+KkKns1dRwuzE6c2/5RZ4y+EG48NikvjOgAzZQNBSahaX4ojWmSFmM6Beb2N1398GenT4hWciDWSHbEVWfHWStri97VwSLenc1lrYqDbbcRDOCK9jYKdN+WdQ/74UFqyFRC+7JL4KWqiuMv+IOh8Us/fIKFpawspZ0gwoaB5EYs7DGg30HPh04bKZOzdG0pHZtdQRFD4WzpEbtxEZ4dpUEw1MNMqk8wX4wQlTCbaGVPJFZd2zsQEpXXLndOx4QQ+wKf76MuAKgVrEVfjtWZeTieark1bVM+6i4teRUACJV+Cg0LdcAAZr89yiF5nvS8xz0UnHvVbpOTqRBWCBj556XLcU73HiMarfPF3pvifTMpj09uEM9m0gSVZ+JEfnRl80vPIHLwutZ5yqL8LYYQcZx06lASFFaWxl4U+0ALYGUtlXlTbWrq0N/CLZWpGJ8Ce3QCFeL0b2mirLwhRJNuNnaHEAHdO7ql5ASYiqsJRJhnoprJclD7kCp11JItWyiULTF2qxpKfeyxtCl3GeC6PUCXEn/YSvRSxDfV/3tefrRn+e5bap8mRamsFln0oAwtFh5i99WJY3zCLaDnCtzu+KEYN2dCVU+yEHdbwztbbEwakEuYXHBvtJivkgwrovf2qE9ZHRbcmVOO3RzNDivjk0eu9sWq7LBKaWwppB4Xkdzz4v5RJEElKKCjvstwKbCJlKXQBtnvOeh46fZZK7rHCakfgeVrWWCdT0/TztPQT02XsKO6XS0EKqsXNyzOhAju0VmC4gaC5j+B2mIeO+P1/GN7GB1
 e2NcST0D
 IY2duR9jGtYmWxn0+osikA9N0qWFkBVWt4aSXqMLr9TU8YQOjDcPb2X6oMnfG6w8y/LyxxQvEvVSqe8CLFD/Gman6jaGD7V8flRx0asgK2Ot62ak7NGTOY5y4zrcAsbM18oly3wZRC98943JATkuKrYU2QbKjlypopgffwB61SYF+dti5joAXHb19Srd0tYLI1E1HaFZfg1k9i17jQzKU/+bf4vJn26RHibb//tg09zGGtUMolEvFj3aJf3LcshscLDTuRJsjAuDeB8VnnEUtB34NcpK30jNAwS/v4JoaI+BlFYrAkt86pydHG6QWV3cCp5BeIdDzvJAUURx0BZrUcKgDp6ERq7UbiGpA1GuWESsp45M/Uzcl85FJs1YdeT2XmrByOGwrvSpgerjmZlGeA0GN1QruwbKjrGTNRc5cefsp0tWTNxTH/IzW610aKiPHZzTq9HM2XeoPBPkk+m5iqCEWgKc84qxXqXB8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static call is only ever updated in

  __init pv_time_init()
  __init xen_time_setup_guest()

so mark it appropriately as __ro_after_init.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/arm64/kernel/paravirt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index aa718d6a9274a..ad28fa23c9228 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -32,7 +32,7 @@ static u64 native_steal_clock(int cpu)
 	return 0;
 }
 
-DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
+DEFINE_STATIC_CALL_RO(pv_steal_clock, native_steal_clock);
 
 struct pv_time_stolen_time_region {
 	struct pvclock_vcpu_stolen_time __rcu *kaddr;
-- 
2.51.0


