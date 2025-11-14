Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FF49CE8D40
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEEA78E001C; Fri, 14 Nov 2025 10:04:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5FD8E0002; Fri, 14 Nov 2025 10:04:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC628E001C; Fri, 14 Nov 2025 10:04:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDC838E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:04:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AA5F58EA0
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:04:01 +0000 (UTC)
X-FDA: 84109532682.27.8DF2DB2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9866F140021
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:03:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L2793zVI;
	spf=pass (imf23.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSiRQxA5I7cbtbKutRpvTlGvB/h9JsDFAWOVN0dt9w8=;
	b=07rCXkMzZV6Azg8uyPs7nguPrSOdkaJSyHbftEcE7dA1PkzZ6DEE6etZKsoNTMZLjj/K0F
	j82Ivc4CJ7Ih47iv3FbieJuZ76FjjTtJNquDUXHconTWRwlRmEQvoeV9OWrNfknG2AAz4B
	f1GMuW7WaRheRWkiFqYrvxZ5BVjRpNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132639; a=rsa-sha256;
	cv=none;
	b=A+SJ+650R3R7S1w4mZ/i2RRbgfIEiSltDhDgbmIMZp1R0XrZgcVtKu4qkVuSNrHnACpD+P
	YeW2s73Tb6FvKXpkPTyfqBLOs2HXH/L1I3+WU9iQ+1aCbs5Mc2YQ7xVzEz1MnNVV6/JH5B
	FXKvXC9XlT6V+H/w62Ez1GgY3gjF5QI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L2793zVI;
	spf=pass (imf23.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSiRQxA5I7cbtbKutRpvTlGvB/h9JsDFAWOVN0dt9w8=;
	b=L2793zVIHHwVUv9tuIFgxh1V+vi5GwKZnVDZTfifo2aaU1elSOjPtHD54y7StnrjT5FHGU
	oTs7MgMDHch402qkdewj1raroASSptXtkwVROyD0SzHEbghdf5RS2g7ns136E7VkqZ1JMQ
	ETZadQJqiB+jGMMYTjC8JPweL3FpMe8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-VO3NDkKcOP-dF92Nk4JHRQ-1; Fri,
 14 Nov 2025 10:03:56 -0500
X-MC-Unique: VO3NDkKcOP-dF92Nk4JHRQ-1
X-Mimecast-MFC-AGG-ID: VO3NDkKcOP-dF92Nk4JHRQ_1763132631
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54050180047F;
	Fri, 14 Nov 2025 15:03:50 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 694CE1955F43;
	Fri, 14 Nov 2025 15:03:35 +0000 (UTC)
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
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v7 06/31] static_call: Add read-only-after-init static calls
Date: Fri, 14 Nov 2025 16:01:08 +0100
Message-ID: <20251114150133.1056710-7-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 9866F140021
X-Stat-Signature: knnxqixmcyf986qant65fi1c73mq3y8s
X-HE-Tag: 1763132639-289283
X-HE-Meta: U2FsdGVkX1848vAJ+3z9+YDR3hC/7WzA9mCADmK+dxmsEsnMGXP6WSgf7J9cPMR3LG0asx8IBF+Dneo8DeLfYFNn1WJb2uRzlpL7/5M/JSSKpCDH3KsLb0xUTjf6q/KzUEVLKf3qWQ8EyX02wmuVnoK3i4wRBTQbU80tw4C9O9tXyAo4mwUuMzL9bohFTTlzJbEjFs3meqY3L7C1hMZnhjzZMWhUOK7Ut0kQ8NtYBurEgHH2yVi6DqUW6dVAIPivn3AfI+OhTPNaPiSVVIPoj6tnYnbK7D5Oj2/CmqqE6aFSFsLO6Q6JYGd+yEIT8HkhL5Wj6EzTDQiL7wevqgD5FJHCtilleehm3y59YHR46c1VVcuEd/2vtvLhI1Yor5G8fM3wvPAMkSFE3z0xmPAJaeYhVRGejw6S1uGw6WTqFqEF815JLytguXAUY+x8Mt+85Ykhg8duO+sdqUHIspe3QwFrmyx/XSthio+P6F8c2M6SperF5vb4zf2OoD4Pdw+5GPA2pSvQNYSTHw9byk1xIss2rvt8PQ9OH74Glyl3HChobLGDJBkSylq1ZtHR84wiAZEZQ9MWrRkQQE28jgDX8fYA5sc02WxhvTh3gELL4MmckBEjseUbr2Tzc8r0U4UZAf6VbkmcyIB45apB2CZPtE32tauBKSJc1fxTDXR9PAYC2WWNgFL7n9Oil8D86OpbhqdCJUlNtVZQ7MlY6a41ezY1z1nkSRxhtmfzCgqYS+q8Ys4JQvx3LacRIJ8qMMsScJRP5R2Zp1rYN7Fxi7SqT7Di1CaKHU9nxnL2fQap2D1qQzW+EJVzGl8h5tfoVeyFPxE6GDb6s1D5uRBxR3ewcSeNgjbUUmkoAioX00t4ega6bYz7Dl/wMlX73doZyeaQ/7kU/fhGGpZv4c8YDzZsvB+G4kKuOo2SYQvurC2GhfrnztWrhqmYQR4ixBZlhv1RhlUNUXjQk7dfylfyogk
 tsYG7rPf
 iBF29NnM2elXAec6ZkIX4PmjdeUwMbP8i6z0XEc/3GhP9O6wJVSHZtjYaqbhiD8Gaj9Onzw5YcPqkfKJPPDOZwkKIIL2DRJg82mROJ8ViukPICHPpqegdD4ubPuQOqasvRG5K+KH/QE53VFjIHPw3RVD5X/2DLHc3m5PQ+OFaRLBC10p1o2sgAqptSwvkRyu7OkTdZykli7iC/zAFm90TBT5bly2bj2B+xzSPbcXFPguRlj0NqPrK7KBGSHkoL4f2U5AON1y3qJiMErIDFyxfXZ+DmLSqPbb0EckZyGVAOoRPH+LxFdQjDUUtt9WlqvRUq/POkMIV71M8etT59SXBsg8nRAIZ5eLxkppw7i+KvbTSzSWQvWOQ4dYT8p4N+n0fDIprtjbMGRupxwhbDNL+ehCifGjIL/TqIFAp9uW9j0QeQUUID4sg9YO8Mgx+w3WRlULPzzJwIzq8YfzdQoZJpI0xbXbHHjEs7Bbs
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


