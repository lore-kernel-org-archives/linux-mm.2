Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB8C8CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A218E0030; Fri, 10 Oct 2025 11:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B298E002C; Fri, 10 Oct 2025 11:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA2C8E0030; Fri, 10 Oct 2025 11:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F00298E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:44:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BBB2216030B
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:44:20 +0000 (UTC)
X-FDA: 83982626280.19.4C947CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 118C4A000E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:44:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gZIhhWop;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111059; a=rsa-sha256;
	cv=none;
	b=8k7fXvRPuYnZE+36069tkIWEw4QNndRslstmZhKr2Gbbjn7cxLMqcw0Nr3OBH/tlAKgmcn
	Fmx6g/DJBXrrUNsDPI4wcEeZvimhOlLWzpYvF2MppqZadR66myHkoMfYbVDvNPiI5fsXn2
	+ZxG/Rjw/To0FVMuGil9Qtv7J5pKm4A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gZIhhWop;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCrVovza8CGhJ7LNJd85GGwejUDYWs5pqgpl3zVqzeE=;
	b=Fyrx0XouEiw5VHZt+1BqYWcf7yyu0x3PCpsl8SZ3O+USfEbcGFbmQVYzwjbzb0adsGwMHF
	gfVZJlPRfsMMJP6fTtnXdJJ3Tk4Yyah3qXFrX+6hi2+7MyIeTRS/d7MUpBQunChd50Xug7
	k/OJLQ+ASlgH/hfbTmuaouQn86mWI8s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CCrVovza8CGhJ7LNJd85GGwejUDYWs5pqgpl3zVqzeE=;
	b=gZIhhWopHGvkr35LSBEoghnDW78TUWat7bx8xlZe9TL6OrBjUapYJ2g0BRRpqgs59150U4
	DHAoXfYbwTZKcIoBnU22XilA9GDFcLdyLHWupg2CuyXn0p48fxcVJp0agbC47abSzSsESW
	BJIlYdT6ZyRwxDmYVoWCMteSZITbhB4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-111-YVZig20YMryWO_pVl0YmNA-1; Fri,
 10 Oct 2025 11:44:13 -0400
X-MC-Unique: YVZig20YMryWO_pVl0YmNA-1
X-Mimecast-MFC-AGG-ID: YVZig20YMryWO_pVl0YmNA_1760111048
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55D281800562;
	Fri, 10 Oct 2025 15:44:08 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A49F918004D8;
	Fri, 10 Oct 2025 15:43:53 +0000 (UTC)
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
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v6 13/29] arm/paravirt: Mark pv_steal_clock static call as __ro_after_init
Date: Fri, 10 Oct 2025 17:38:23 +0200
Message-ID: <20251010153839.151763-14-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: ruqgzw5xuo3p8mg5qzij4np1izsxni9i
X-Rspamd-Queue-Id: 118C4A000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760111058-364546
X-HE-Meta: U2FsdGVkX18jiq6aypxHyloHBoXyAexat9/8fLBLOUTJCYr2RPqOWtnJ6szE44k9QNUbaKm9sVGlYzWk0ib1ReyDgnpFwHVREOxaDRqFMC5jjc1wxmms/dyhBZsYUf0Wfrx5gr9Lwlq7EAjin6xrVJEBqDbCOE+cgKgWNr6d0iRt3cl2bzUAzXTgsvQhd7JlcWynvHi8oUTl06F02enwYxO4cK++d2s9EswmGAwaypC9qZH4Gu2m2G5GZ7hO/zdSyCfvu0jpoMLCSExPSN6KT3NWTJiZaXI/mY1y7oS3bZwtkAxif0KFx0YJfJrIELMYkg5t+mDs1bFV2UCzDEnweU3RgIoRMe+IRYm1vILv42EWJRdV2VFwJVa6IslJI+mzjKCkQ2L5XYjiLp/BPH2k6Cj5F3rsBahs+To+SjBubCzrGEjc7hY6G3Y62X+5NZ0ZH87s59P9aSKeZtBYtuagw35adcowZgZmjZ7beweH+Wq8w90/FXWlWhEPIN6Ix/kv2QGvugkb+myYYIllMMDM+foa1v8krVfN5rKwMvZm1YBl2mNhXfMcgKtIJ8GaIezbNnfguoc12zZNDJyjXWtxIHZXeazawUUhU9L2N6u/vpX156SpeEu2z82GCcuMKfiGAnoQ6oVVGhzh7oamo7k4onMQp4B12DT40ELjNzHUGcbmYDvJAkFA6ews9uiKBCtd4nVmAxwqjwGtbac6SCK5GHlTKMAW4z9NNbkIXaGBspnthw1pH+kXIsatjjw5/IrEoU/rbm2KB1om9bXZKW3GRID530FtfQ9q/r/1t+e4vc41iYgRU/vSp2ehWFUP73Bs/KyYnM/0b1pjBZtvuUo62oTd2vQzak8YZOnjTg+FmcbI5m+SJg14GJqgpIuso2KY+XQ3JNCQbqds9v/JLYj2QZZcr+5Ongh8j7AxC1LmrdTUBzYr6B9k+cK2Amygv4zgFBrqB2+9EwVzPq+PPIy
 zUcnUuGf
 Z1mrrH+pqCDjNswU0jke9qSSbjou8odQF7F0o+1evO4PyFO79+J1c3UPUqODS6gZUFJGvKa0K4GpFB1AHcAUZ1lEvyXq+q0VUeg7TxJuI6dkzDlMGLQT4InOZY39PMtGGCYRlu2t0DhOtLCdekL6EW4QjFZXfInRJymb2jrUzKqe6ZGTAejk9BSm3g9pjSR7rYnCKYVKttDoNfJ2s6VISQtsS1didlUk0efwiXQCMMVl59rE+C8xHMmOFB1fF8vvP+SHkpbUv7F3DD0o9Eq8uX+g366D8ZeR+Wb8MfQuM1ufaNSXcIWvB1ZHt3JRD2KrsfSaKy58jCPqiNGvdC5rmv/MFD32zGlcv9a43A2I0HPIAQ8DwR2n/fAamWGi6rMpMO6urvH799LXRNdJ4PVtaAGYbw70erKX+Mez5YiXvKQrWy/LGBD007NC3Ax+q+ao9T/4YvfiDBqrdfAjFWNJA11PuxX3UWz+f77RK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static call is only ever updated in

  __init xen_time_setup_guest()

so mark it appropriately as __ro_after_init.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/arm/kernel/paravirt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/paravirt.c b/arch/arm/kernel/paravirt.c
index 7dd9806369fb0..632d8d5e06db3 100644
--- a/arch/arm/kernel/paravirt.c
+++ b/arch/arm/kernel/paravirt.c
@@ -20,4 +20,4 @@ static u64 native_steal_clock(int cpu)
 	return 0;
 }
 
-DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
+DEFINE_STATIC_CALL_RO(pv_steal_clock, native_steal_clock);
-- 
2.51.0


