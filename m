Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DDFCCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8232B8E0028; Fri, 10 Oct 2025 11:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D39A8E0003; Fri, 10 Oct 2025 11:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BB78E0028; Fri, 10 Oct 2025 11:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5247C8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:42:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1295B1A03AE
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:42:37 +0000 (UTC)
X-FDA: 83982621954.15.FA226E9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4CE5B120008
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:42:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ah/uyTZs";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760110955; a=rsa-sha256;
	cv=none;
	b=z82ngfhYF6FLQDa40uTg1w1qPdqq5+gSZm/+gDO8c8XGsNQUDcEww3ARPQIEW3pjjTKuqe
	/vyjej7F7cwkDQGj8OAXf6L1Mwou/lzWtLKkIZ7ufApjLWn6JCJpYD8l3Uk7SrTsPvLfWM
	YlX6rcbPoVfFMGT755Ps1qFdBlsnK6Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ah/uyTZs";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSiRQxA5I7cbtbKutRpvTlGvB/h9JsDFAWOVN0dt9w8=;
	b=OvxAEazQcjfynlCqsf8xHkZnlWyJ7yxDFu+voh6twiScKpjD3kSzszvreorov12nbV2J7F
	OEwgXrSLLDcNtBj3Oe+Z6eU42SZ9JwuHByHYepenFlJUy0pjpgzprF+XJ9GddTy4cNzcO7
	XVWNeEZl+gvsjqljhw7N+6smllXuLk4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760110954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSiRQxA5I7cbtbKutRpvTlGvB/h9JsDFAWOVN0dt9w8=;
	b=Ah/uyTZstKHtSfc82gUjllhVxObJLrWvmi0OygZ1aijFQDf10umRYoe0pmrEh5mJ4t/ScA
	DD1clPIxz5lJX8SYNIQt3n7AgrcA+q8azwZsL0DqKK+V8RAZdbH216xOHwNL37xF1nmK5I
	oV88FmXTvru+UQzZ3LrhEl5XNB4rzKw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-442-qAxCNEYFMJiMSx-SkrmWlQ-1; Fri,
 10 Oct 2025 11:42:31 -0400
X-MC-Unique: qAxCNEYFMJiMSx-SkrmWlQ-1
X-Mimecast-MFC-AGG-ID: qAxCNEYFMJiMSx-SkrmWlQ_1760110945
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFAEC19560B1;
	Fri, 10 Oct 2025 15:42:19 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D815818004D8;
	Fri, 10 Oct 2025 15:42:03 +0000 (UTC)
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
Subject: [PATCH v6 06/29] static_call: Add read-only-after-init static calls
Date: Fri, 10 Oct 2025 17:38:16 +0200
Message-ID: <20251010153839.151763-7-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: za3s6ugyokoctgyfzzs3ujihk5go7gb7
X-Rspamd-Queue-Id: 4CE5B120008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760110955-321238
X-HE-Meta: U2FsdGVkX1+XVJbZvZV6/P3SIDpGHsJ/iwwgU5U+KoEm2/ivd9DVDdNAAnDpPsMSpaqDLa4pur827gX6lY0hMWwBPZJQtCLP0Z+QMxg2DIdnPw3lwll7sbfv9UuH4LAIv/2XOrWtyA9EdUwzGJjMsJFQFwUWEAYf91rGVwOV+xiHayhb9TYoaPsI7aANmd2ZRmnfq0rWgKJJYjNH9xqNEFWgUKTqy3x6FBn9HyrKHJhvuXRrpASkyLezTPUmB9swJ/NtRjKazL19bdGi9tLp0QdfNDK02hfGEMnCssq1hfwC1le+kwkqHSI/exodlcGdBoyYWJtP7NbL+dLVgC4uxdXYkrsm3QTnAPp8rLXLMO4CKvl6f/wsnOFTAOVLc10NpKIHaVcEiE/CdmW2O1upJCWl+tLFXKN8q2FmKmQbhWbQOv3Y68JkuHf9Cpo+6R0POKKAyi3ZT3pGo/yUXd6IINIEWpALJVwlhBZxXGFiPBkC3/HgTBmwWPgVx1IRJqZA0UUinhEXU64oAYehutUB9uI7jqrM8UCdLs4VJrZ1Qf0j1IPALBJLd67WlmZkWypRwAu9Hjh6UtdMmEisduSSy9u8VBi1qK3rlusjuBYTFM+uNg4aexYFyBbjpbQBXnJwlOpRPNg5ddQtULDdxAkgPWG9719ynMAuWSEjx+bMryDq/0ut2bdDuPe0RY51qH7XFbY3ScVsE1HnGDIq1/7V74pR/Thy6xPE6V4VgvnUaMdLF+4nxfYZRE6vsQnwUmrSexC0RCJuJjXx5+l0vqFvVsiFFoS7KGRru0XX0zIeKTpGG7+3oSqHyyPPuFbsXmg1lF1WLvKPqzFk8hSZHCNU7oz42tsWbrAu1j4FAJLNgTDjyvwgJYwoniHTgmAQbO4dQNg1b+EX3w/txVUMEhbmEkShPhTGF+t+9nM5A0TLJuhap5v3U6+jv4PABAzsrTE+sx5XglJ41jNh4sTjpJd
 voj8Sf7O
 8PDt3g8FllhduzP6IhRpKbrFjiARII2UJhpNfEsXVPw93AI0cM/BVdavzNXJkdqXzAP6X7naPeZ4fRUDlz5aGU60Cq5GWq+999Gt8KD/b5RhOmLk7IHcOljBkXDPofm5ElSNiijOigJA3COAH21Lf2iRevla8zCVIgfgArPFyIdyYjegkgCSu677bcG67aPZ1TvYfKyoMZPcDgzXxJLWTGQN3zoSfvmltn+uoZ7kez8K1TgPkMKnu8C1U+XwhF+77r78RIy4zB6elYg5QQXQG1CPhAkVwGG02umpY4EAR8FXlA3mbUDFF6krlv99wvJzBuBnq26iP7tMxd394PYZyGtmKXvDWSGEHXcOLfDsd2fJRsj8ngow1r35R82LxPvfAeDHX+c7RgTQKrKiEb/NYoJdcSFMHgwWcZvdkkXvgD7rBEh02bNtiHCZaykn4Bp2wmY2jvaYeHN+9Mz52rS79UCst+xBouw4caKqz
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

If a noinstr static call only needs to be patched during boot, its key
can be made ro-after-init to ensure it will never be patched at runtime.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/static_call.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/static_call.h b/include/linux/static_call.h
index 78a77a4ae0ea8..ea6ca57e2a829 100644
--- a/include/linux/static_call.h
+++ b/include/linux/static_call.h
@@ -192,6 +192,14 @@ extern long __static_call_return0(void);
 	};								\
 	ARCH_DEFINE_STATIC_CALL_TRAMP(name, _func)
 
+#define DEFINE_STATIC_CALL_RO(name, _func)				\
+	DECLARE_STATIC_CALL(name, _func);				\
+	struct static_call_key __ro_after_init STATIC_CALL_KEY(name) = {\
+		.func = _func,						\
+		.type = 1,						\
+	};								\
+	ARCH_DEFINE_STATIC_CALL_TRAMP(name, _func)
+
 #define DEFINE_STATIC_CALL_NULL(name, _func)				\
 	DECLARE_STATIC_CALL(name, _func);				\
 	struct static_call_key STATIC_CALL_KEY(name) = {		\
@@ -200,6 +208,14 @@ extern long __static_call_return0(void);
 	};								\
 	ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)
 
+#define DEFINE_STATIC_CALL_NULL_RO(name, _func)				\
+	DECLARE_STATIC_CALL(name, _func);				\
+	struct static_call_key __ro_after_init STATIC_CALL_KEY(name) = {\
+		.func = NULL,						\
+		.type = 1,						\
+	};								\
+	ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)
+
 #define DEFINE_STATIC_CALL_RET0(name, _func)				\
 	DECLARE_STATIC_CALL(name, _func);				\
 	struct static_call_key STATIC_CALL_KEY(name) = {		\
-- 
2.51.0


