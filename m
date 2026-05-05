Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CCE6FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 08:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1299A6B0099; Tue,  5 May 2026 04:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100F46B009B; Tue,  5 May 2026 04:26:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32516B009D; Tue,  5 May 2026 04:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2BE06B0099
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:26:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FDB21C0F2F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:26:03 +0000 (UTC)
X-FDA: 84732683406.26.9CB73F5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4892160004
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:26:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hdVDDV8I;
	spf=pass (imf08.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777969561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gsMdRwe6f8nfnzql67PXdPtXLWn8XHtAqrkCOyrxHE=;
	b=XO86o1BiKjH9DikvpJVhuNAXSYC4Wvyrcdxz+m0Wki61OgjjHPS9eTC3GBrILUqeorwCuO
	cjgqEQnOjEUYYp3s0XXGdNUVvzj87rzT4JClehMWSVZjtH+MOFVFU4vPEH28LapiGhTbIp
	7LUwDA+5R2BbdBNioanruXt1fKtAeSw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hdVDDV8I;
	spf=pass (imf08.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777969561; a=rsa-sha256;
	cv=none;
	b=JCyYH4AFP/tbirVsJ5UJidqJ2K2eeK+Ph+F3TSRpSFZ36Aa+gAEbxH1NUs38EjigmseoPn
	b0Rujpa7w90oiuzamrpiLMu1mg/bke52GMCl/SFLHnzYDcFRAhPCL1PTRhFzYjwnhbbYE8
	gVpGsUmOox09Gwxr3a9yG3pjlW1t/gA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777969561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7gsMdRwe6f8nfnzql67PXdPtXLWn8XHtAqrkCOyrxHE=;
	b=hdVDDV8IaH8gtdIU2U1ygNVTu4bPGvKNn54mlU8PXwmWCaY8+DNqiGIpQ3+PjkApQtbj1H
	bHuDwfoclWWLBvpxjMgE+0fkwNCio+yOsV+ueZXSI8WXVBIKwiCIvlkrjnM4CDa1nMvu7b
	vxIcGLkh7ixd2OZtW66YZ9gcNc9ZQiY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-vNbTdYtOPay9rcVFW-zwGg-1; Tue,
 05 May 2026 04:25:56 -0400
X-MC-Unique: vNbTdYtOPay9rcVFW-zwGg-1
X-Mimecast-MFC-AGG-ID: vNbTdYtOPay9rcVFW-zwGg_1777969552
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C0D5180049F;
	Tue,  5 May 2026 08:25:52 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.48.109])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 45D6C30001BE;
	Tue,  5 May 2026 08:25:39 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
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
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v9 05/10] jump_label: Add annotations for validating .entry.text key usage
Date: Tue,  5 May 2026 10:23:50 +0200
Message-ID: <20260505082355.1982003-6-vschneid@redhat.com>
In-Reply-To: <20260505082355.1982003-1-vschneid@redhat.com>
References: <20260505082355.1982003-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Q-VIHcgn8lxZ73QDst-6P0GvzSAQqIKt1r5Bn4f-2aI_1777969552
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: bnaoeyzutuu3h74zfthyyp17r3hzgbcu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A4892160004
X-Rspam-User: 
X-HE-Tag: 1777969561-632238
X-HE-Meta: U2FsdGVkX19sjTjwR2TB+JAQI8dRbTfItQW7dV0i46hxVn8uOriFC+fE+dUHILkWZA+P47yL5j/S4wh+JlIDVWUoEiNQwOeYAG1HLAYbXsUjK7sTuqPHeiO1nWEiHImbkGUhQyHcjxuFLeO/ocP2Rykyhm+wmbLTwzS8B31w3QuuB6WbQNnITbL3amt9ybNC/VIRme9oZUTK1jUCFGUO1TruRRR2QKI1m6QfzM2lNlKoFjbfNEeY/KBy70SNDEHVfKBoTH8kvp7y91N/8+bPTkhJ6AoKklLwX3+D4OQ6V5ynRzk7zdINEuQpljc6wmbCiRcPFF1GT+XC967s36To0ALFhxHp/s5sIEQuAK1oVOJmjBElzRcv616KFNiNIb4qC0ear9F/VyxcnGf5m0C7LdFt+WySk6Ef6cvq+RpdfjRo6xTgwYRU6a5wiy6Edf/WkkO+HvEyOU+JMm5rquFK9LFFS4bomUM3yK94ZKpnO4Liirs/7ZQyhDx6ZlsaV0QIZrC3Aw3b2sgRO19uNWloYxaa6wDGm9d0/E4f9ZoF0WsG54PepG4kAwZDFNCYsxYiu/wnMG4tFUReLiNKrd3lrBUcgfKbv3q2UNE4GrK7W9/VSEMTOkjB6mxETncyPnI27qdo/06ZKBFQgRvgoygWUkLqtVUDoi6ZRU4yPLQ0yIjeIgHcfxcxkrcS5pm37gPiVqGN7o52KGiWv4jYNR21s3D63PC6eMlQs6Tu7XAHH1mWoea8zagi9Ea/gvFE3k4NUY2bWvNYDeY9hTUsSRTQtQiYUyIuS+8Y7Rvh9OUI+2pM2anGJ+kPvtCz3x3/g5L0s+iMgwVtmzt27I30kGy5jx4LnsQjRm6e7sXRJhHsJQyOeIcHSe28V7642pVeK2j+W3bgF9WIS+qWJJU4EEhvB5HqXJVrA7nTbZz+dKcnB9y3k5L5lwCiFKd/CTlb5z5HdVgYLr5c4WlWOnsyx/C
 DHlDp5/V
 dewpcMRcvKjFwCtqCdLKIZVB4AB/7uLqkQEdnC4oH/DZrC5O8oafnXgWM0SNzIJUjvZ8H12iH0O9Yq2iAoDNCTOl1AXdcqjZreqgDcXu2MD2SbJjn7ZD+8+5AMBhEXxPbJf7tbYIcJ1HLmBUpOx/Tgwh3/x9N/XVYhxkziXbGbZM+u6OCkIM+XD9OJwFbMF7G84QHumJDnq0pjKgriKx06+MR1OUYMdv/zOJ0fHRxnyH85DNMuN1KcyN1/A6WBR355/CNxjLQvCHsFiJX3lkjDPKuHK3XIoQM0fKgqHgARMSnu8/4unXl0CcCVHn7fzFy6OY1om4BExCiUv2xmDwB0VSWEoto+dMz4GF5l+mrjvo4QAIjXKL66xNxQA7Vdfw7CJ2YS4OvtbpOuiZ9rcNauFckFa9UKICrMj8zkPyWCaTKzBUH0EyoRzCKnOQ/8i19ZjxcP/WK5/6n19E5gAo+q/35VA50zS0Bcv3puxaN8t9ywVlIsPJWU4fX5lEUNQxwxqbo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Adding static keys to entry text needs to be done with care, as they may be
executed before a context serialization operation has been run. Add
DEFINE_STATIC_KEY_*_ENTRY() variants for those. They don't do anything
special yet; that will come later.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
[Reduced from .noinstr to .entry.text]
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/linux/jump_label.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index b9c7b0ebf7b9d..e05b4a52ba1b4 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -374,6 +374,20 @@ struct static_key_false {
 #define DEFINE_STATIC_KEY_FALSE_RO(name)	\
 	struct static_key_false name __ro_after_init = STATIC_KEY_FALSE_INIT
 
+/*
+ * Objtool will warn about static keys used in early entry code, as they may
+ * be unsafe if executed before any serializing operation.
+ *
+ * The _ENTRY variants are used to tell objtool the static key is safe to be
+ * used. If using one of these _ENTRY variants, please add a comment above the
+ * definition with the rationale.
+ */
+#define DEFINE_STATIC_KEY_TRUE_ENTRY(name)					\
+	DEFINE_STATIC_KEY_TRUE(name)
+
+#define DEFINE_STATIC_KEY_FALSE_ENTRY(name)					\
+	DEFINE_STATIC_KEY_FALSE(name)
+
 #define DECLARE_STATIC_KEY_FALSE(name)	\
 	extern struct static_key_false name
 
-- 
2.52.0


