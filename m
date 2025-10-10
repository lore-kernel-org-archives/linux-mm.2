Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5074CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC79A8E0027; Fri, 10 Oct 2025 11:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77BE8E0003; Fri, 10 Oct 2025 11:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40308E0027; Fri, 10 Oct 2025 11:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABEFA8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:42:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7107A13A9E4
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:42:17 +0000 (UTC)
X-FDA: 83982621114.26.4EFBCBF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id A698E40012
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:42:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="AXi92g/s";
	spf=pass (imf01.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypuA88VHIrtZCycTQvLRbp4fTjYOiPnVr/lgVBnkLI0=;
	b=smyJDI2WwX6xtTbrZOoxcxPL7K6t+OhEN6OMVSgqkBhBOZwL0utOJswPzIu1ZbE6ulwvD9
	DLPGXoRho5S4dvFqGcZu8YCN6brnAMXnDEtDcZEcwDT3VUcAttImGRCFNCtEtin3PkdC9+
	Ur27HyvzkIAeyxnLuNWUFJm2dzIEoAw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="AXi92g/s";
	spf=pass (imf01.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760110935; a=rsa-sha256;
	cv=none;
	b=tBg7D338NfszjcvH/eln9qHGiJpQ/dtYWaH5m1GPt16a3NS3cOTTmPllhOEjqBKjEuCyub
	e/PnMWPYNBYzyWU/vnie0jx8JRNLarM+FfbILa7qxcfVKf1sJFKd1tlvEbScFK9ULV0fKu
	3ANAxsGf5cQwNhATUERjPwHMlk4thEo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760110935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypuA88VHIrtZCycTQvLRbp4fTjYOiPnVr/lgVBnkLI0=;
	b=AXi92g/sdqnUTFhWSm3/RSKFDv02lv5kjkJI/C3xG/4Tay9BTMlJUiu3cx1l7slbW2cXnu
	kAOxLzGlOKk3O7hge/2RqlXCFy1UjmX19ZiFWs7a9RX7sqy10nMdG5V+KzhYXmhj4BggoJ
	av7TsZ3ehO0HFIWLvUSTsS8Zt34CSSg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-7bEM6FEUOcOziUsCCagKng-1; Fri,
 10 Oct 2025 11:42:10 -0400
X-MC-Unique: 7bEM6FEUOcOziUsCCagKng-1
X-Mimecast-MFC-AGG-ID: 7bEM6FEUOcOziUsCCagKng_1760110923
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A5C2195609D;
	Fri, 10 Oct 2025 15:42:03 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EFB11800576;
	Fri, 10 Oct 2025 15:41:47 +0000 (UTC)
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
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
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
Subject: [PATCH v6 05/29] jump_label: Add annotations for validating noinstr usage
Date: Fri, 10 Oct 2025 17:38:15 +0200
Message-ID: <20251010153839.151763-6-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A698E40012
X-Stat-Signature: sjw3abrbohffucbqz3m3k33983yyn95o
X-Rspam-User: 
X-HE-Tag: 1760110935-848133
X-HE-Meta: U2FsdGVkX18d0rdwJmrQbo2FlQ50D28GVgH+uhobzZ4LAJiPRkvFkFNd78CkW/dpYEpfr404CwqMt1rKE4ULPA4RINp1cVKzmhQUvDXPKj5xsDe6k96/Wpsc/IClZjnqf0S5zcDxAXTas3nWVyvYgQzPfYqKvAQkF6C+e9v3qvzfgvAVIp+LHhSkHeOsXhZTr3+nHhyZeATqgaEZwyS6MV8YKQNhpWlslufzh724OUs2BAGeNLxFqviI/7xwLGMIDg5aDIW4WNkjcB5bgT/DdNNgGLDt4NFCtz/fK0VQQtWbKPkN65a/m3RcXRplJ9QFGnr8qj7+A/hKXa3YQM+/JJYBLcP2OjrMgHWRM4QeiXmdbP2wJUkof+QkQUSfs/KBPH2krloXyDUUwl2vVoBjkCP4dAqURZV4uZFdeXg4XWG+6RJ4CYRjINc1YNmRkjoyJ1yS8QMX6S4AukQ/9McPvkmLyuoduiCf7BGxAn29s0ggbETBS46gBrKkJaYoKHvJPiTlw8VSLf4X04dppOuMrFZL81yDXDpEyRDORqa+xuHux2cDC0P621AQu3wHD/1QukheVmqDj0bHbaWdt/PUXyiS9gE56Hk4lKMjk6wtDeoQ0+Y18CpfobysKC6HpcllMeUAK+b57QWY1fW5iy3QbYJvhzFfQMIDeTs0B9E9wCh+dfVUh2kZeyUrjbOvn22UUAgPp3Vini0LhizOLwGY883g/4PpaH1Vziau2Q3JEgrIz/JLa31QUh7lgblwlFuuNPNcFzqtSmeXHcjHuFTwIyNeV9RS+6b3hpyqoYYmcNfhnONdw2gN8x6Ar7lVT9Kr5Slv8ALfbUExFeEciPeN347rUa12Xn2a9CsGWyCBBDgTUk2vyb5XIscnOS14xUj0CqoCDnmtEigmpdMokABi2oDxiO8Q59zltf3rDUbX9HJzOIJ8L08XVZ4FyYj2pqEjVg1wd6cIbn25feZStOm
 6sis5z7R
 MXKc6NGlPDZ6PBF/NahlDZi6rIUO8SjWSksIOI1P13J84YI3dYmgaThZvR8E5D4gma/WABKN+NtAY7bGfOERXKz6ZhzedridVcaV9piXrl/gzfwcwOmNXG/vPs3S5qjt/VBDOjRNwMDp77i1ip444wcCX2Mr9FZU0O41Ph9ZYmrTZ9wuxnZjSAFGe5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Deferring a code patching IPI is unsafe if the patched code is in a
noinstr region.  In that case the text poke code must trigger an
immediate IPI to all CPUs, which can rudely interrupt an isolated NO_HZ
CPU running in userspace.

Some noinstr static branches may really need to be patched at runtime,
despite the resulting disruption.  Add DEFINE_STATIC_KEY_*_NOINSTR()
variants for those.  They don't do anything special yet; that will come
later.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/jump_label.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index fdb79dd1ebd8c..c4f6240ff4d95 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -388,6 +388,23 @@ struct static_key_false {
 #define DEFINE_STATIC_KEY_FALSE_RO(name)	\
 	struct static_key_false name __ro_after_init = STATIC_KEY_FALSE_INIT
 
+/*
+ * The _NOINSTR variants are used to tell objtool the static key is allowed to
+ * be used in noinstr code.
+ *
+ * They should almost never be used, as they prevent code patching IPIs from
+ * being deferred, which can be problematic for isolated NOHZ_FULL CPUs running
+ * in pure userspace.
+ *
+ * If using one of these _NOINSTR variants, please add a comment above the
+ * definition with the rationale.
+ */
+#define DEFINE_STATIC_KEY_TRUE_NOINSTR(name)					\
+	DEFINE_STATIC_KEY_TRUE(name)
+
+#define DEFINE_STATIC_KEY_FALSE_NOINSTR(name)					\
+	DEFINE_STATIC_KEY_FALSE(name)
+
 #define DECLARE_STATIC_KEY_FALSE(name)	\
 	extern struct static_key_false name
 
-- 
2.51.0


