Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE17CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C93678E002F; Fri, 10 Oct 2025 11:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43988E002C; Fri, 10 Oct 2025 11:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32E28E002F; Fri, 10 Oct 2025 11:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8138E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:44:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 74158585A5
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:44:03 +0000 (UTC)
X-FDA: 83982625566.03.A3F372E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6974120009
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:44:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="g636/hGL";
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYsxd3auPHrfEyiSRiw1uwn1LfepSkxHHrao83gvKCM=;
	b=Tdcmkz85/90GH0AHzaYHQdRzncHI5hJA2F0woH5KAXoRqhHD20rGo8w08o7ByqdXLmcX9g
	kxVOCWhpF4oQjvAOqn3uBSiITfTtrBd3HbwKJ989s0XIxvmCDcVM/yoY5lUD9RSdzC3+eg
	VFQ7RSz6d9VglOpqRJX6SLVQGeKb8HY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="g636/hGL";
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111041; a=rsa-sha256;
	cv=none;
	b=yoK33nhyBlMqUUuEbckomjXajY7QtlsYrp4Dj9lUGJ0ZP+z5D2TFSBUz9W1alE1X7u0Ibp
	YfRwPYJSvTLNnVKOzBvwjRsnZ9TN8gXP7vEb9WpuGzQS8jJdBdg0cUcs0m8HcP9GclV5We
	O14URgh4fcvqg9j/0U7US7Z6MOrJcWU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mYsxd3auPHrfEyiSRiw1uwn1LfepSkxHHrao83gvKCM=;
	b=g636/hGLqJ+CH2dyTESWMmoNkHP9rQfL9UsUtqsa3TJTx8QDuGlA2dTibzsbTTeGalMRJV
	knKoX/5km/wl3n2lRyss6jNA27s5Cp8//nkP69SKmgJ950LHG7Ty0h6yeqOfgCts8Fo1Lp
	Ewp1Pu5L3fzkzM03kjkRGolD/LKDOm4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-jOxiEszlMYa4ZFIRiJxqvw-1; Fri,
 10 Oct 2025 11:43:57 -0400
X-MC-Unique: jOxiEszlMYa4ZFIRiJxqvw-1
X-Mimecast-MFC-AGG-ID: jOxiEszlMYa4ZFIRiJxqvw_1760111033
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7B1719560A2;
	Fri, 10 Oct 2025 15:43:52 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 635F018004D8;
	Fri, 10 Oct 2025 15:43:38 +0000 (UTC)
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
Subject: [PATCH v6 12/29] arm64/paravirt: Mark pv_steal_clock static call as __ro_after_init
Date: Fri, 10 Oct 2025 17:38:22 +0200
Message-ID: <20251010153839.151763-13-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: dq19pewth99rdbyypyk5hgn8e61uhgut
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B6974120009
X-HE-Tag: 1760111041-27348
X-HE-Meta: U2FsdGVkX19CioWTqRw1chlGxSAvgwF9PkcoQn/d6yKACoqgb+JwuRF79kt8mb+WhcU3B2UXsZcoUYN62Tfzst/TFQR+yVOW1jOjuuCYYFUgThCu66by0w0tJiJ/PEbPoR2sgAfMSLoL7C96+Pk+yy5bEePSiozsTs90sS8TzsYahGxhlTwp++Ll50HMqBFf8cNph8SuRCG8khwSDGvA57E6rMvNfBCJGM2HelxDjdOnC8zb5j8FYFJTN/+9s2WU0gc8wGOWoQafFRSS8G6dbAcOE6pdRJGnaECz6o+xAmGuB+AgzrBP/6XiPEViz4Phbcg5n7JmbghojbhzKTHfbEyGDkf7rLu0IXNRuYPCQqL/e8/QBkqiR9jgoJyWW4IAOjDje+x23TKnxNZ0aEXmE2WoDiv+Ha3FSW+IJFsTO5VGF9SWRr0uLy9FSxn8uMOT9MBttu7oEi+Z3HtXaGrFw+6hDaYvlCYs6UNvC1g2KVrW8HFrBhzjOND1bfHvGo0I9AG+i2qwOuDBDmEuKEF4y4ljs3z+8/1ckOzoVTODx1Eutv1ou0T3b3AsTSQg8TZCYgX7zOZwhs1uXtGOwdY+pjNz8meM8iWENYTwTy/2xr+XaB+mwPfIblZq2hfT9dbb0UZ+ziEPyt742SUZfchcCtOIFjEkXGpusYorFbjBLCyLVZcTmijHRdpEOINH8xUgy3H5L1s+8dSF+24Y9/KH49jYPDUUNUUVWNCGam+OyqJN8eVkqGwqJtmrKPMChuYZi9EvSGjUER+9u3WWhFaYMQ1SSXhw3sk2u8k5CaZNi4BcJLkBAgsFHcD8XP0eKDtocSUZHl3sDNbNiOOwypJRCY7K8uz9EpZpeNW5swf0fdPYnwB1luzClXpTDC73GU/n82siQBHXebnPbwQbg6MXMHYSymfIknHSWwSzjVIdyM7u3ZCaFd7VXEA7GSUqFyoISEOH5RGvpFFtJv/Fekg
 /GnGlgtz
 lxr4tlIOvq8QlwO9jqUpp+myM+jEcarxm5B/w9T1ubrNMO22JBQqmhVAT8aLFxb8MPuNuUNnoxKEID1CiI3TKwt5vrm84BRsO10MHG1b5QC1SqU4L4JrRyxONXuNb0U1WKNFYKIOxH6i9kZchIEtD22gMAJ6f6at2RYxqMkuzp6e3nIY2E4gq+zdWUa/0wUtXV7n61T1qAAtADvdtTXB/iXx0b91rNzRO0kKksCXvk+0hLY++OrEKifh/zxtHDUHV67jJ7xixXNkbv+3nO2L47KPE22QYGQPSjV48OZ/QeUiTjY++pGh5ph7skjaEPbjFGwob4GoPR9Vzb4P1yQxaIJcNJB7pmFNUR3+V088EcVtJ7J0iSD9y+I6+UF/zNBT4/xKxTRU3PCRUtT1hhwlsBrjvQbsqOIb5KoKGogWbjXYsB/ejtr4UQL5YA8rUG2sOGTtIPO6IpM9MXfhz0IjAwqzYSgrnGpbBuBY5
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


