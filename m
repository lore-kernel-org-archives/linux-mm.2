Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775E5CE7B13
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A8E8E001E; Fri, 14 Nov 2025 10:04:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D520D8E0002; Fri, 14 Nov 2025 10:04:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68708E001E; Fri, 14 Nov 2025 10:04:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4A858E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:04:27 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8175E1A03F3
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:04:27 +0000 (UTC)
X-FDA: 84109533774.19.31222A7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 899011C000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:04:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Txug1u5+;
	spf=pass (imf21.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oVSattGET5cairz4pLrVIWMCsCMvZMhD6IO+zCvSIQ=;
	b=r6zloD2kKOicAvkjgsq/KUZZs7qwzaclFQa1rEJmYfgJgpej7j5+vCJurbdwkkQBwOBlE7
	fkrOg147M2bwdJh0iUoy/ZoXsnIzWeW3JbIgNiCEevjg7jy4eBCmHYvK/QE2FE1ZmaxFgn
	QYAqbK37KGakxDKpelVlNHvknVKQ9X0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Txug1u5+;
	spf=pass (imf21.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132665; a=rsa-sha256;
	cv=none;
	b=RLsoRXVBX3Uf5Ese169BNaVa9uApUevJwYspX5TZEzAoyBx889g5gUt+qZPcyGo2o9Dd3w
	nPcOv5+Z+axNTFiZKBhET674crbf7yJbtDlRFjagdaFZ7o4hvD7zt8TrtTUc6wy2YEy2cQ
	okG18QCvAG8fDVsiwYqxJSAWFwNGaK4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2oVSattGET5cairz4pLrVIWMCsCMvZMhD6IO+zCvSIQ=;
	b=Txug1u5+Lgf+8p2+NVWbGNP+CCqePxEz9JpVu5Qmqbu+LMKAzE+Djn0VtvRhpLGx/tV/rT
	zMUf8VZ0IY+10Nv68Qmz8PPQbGS68sXC4NEr/hUhJTGtdOE8qUE2ZIak6v5vyQhCG5NwCF
	XRojeWQywkH0Ao/9567BNMngtfVNOSg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-417-hJJuaX7AOP2PLODmDdPtew-1; Fri,
 14 Nov 2025 10:04:23 -0500
X-MC-Unique: hJJuaX7AOP2PLODmDdPtew-1
X-Mimecast-MFC-AGG-ID: hJJuaX7AOP2PLODmDdPtew_1763132659
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DAFDE1800342;
	Fri, 14 Nov 2025 15:04:18 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F2E71956046;
	Fri, 14 Nov 2025 15:04:05 +0000 (UTC)
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
Subject: [PATCH v7 08/31] x86/idle: Mark x86_idle static call as __ro_after_init
Date: Fri, 14 Nov 2025 16:01:10 +0100
Message-ID: <20251114150133.1056710-9-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 899011C000C
X-Stat-Signature: 1uowxprmwpgjgun4czptfo9u3sn1b1g4
X-Rspam-User: 
X-HE-Tag: 1763132665-200231
X-HE-Meta: U2FsdGVkX1+RN0Ar4IoNkqrGDp6a/Mkjxxs2Jy2IekODYq/mC3dfiv61Q4UgZgU4t3S1oxf2wPci7hDw5A26P/9eJRjoUJ/YkWJjSPkEo5R3t+5IhyZCvNciChF63ihi0HK3Yp402DtTiG8Pye7b1v95LvnWk5ty5EJ7FBtnhuuZYt5aZ9oiK6LskWLk5EKxy5eu46R+I3hn3UVhiS1267sVqro2wzln4T3oD4OskqZIKNlj6Vocwhtw5JshIsNuCzmEuWKn1mX2k9HsMYfOVjKzvYML3zJqbwY70prJ54QnRBNc6pxWOYRKUor3qjBt+v3JgEojoxsxgtt6q0TffzruEKgt3FTDf9RjYW9fJ7elIAgb/20/D792400Zh8iFlT7z/j3eswzXidnY1x5So77d2YnU2OxaTiRTSjJmzTDRWdLNsm9lRjgED1h2rmDKvZwxTIVP6MFuMjXzXmhaZs43IUGmHXzOMM4UP+wUfgUYpDR5MG48ET48m3mL5K4c7FjYTmffUx34j7E9zz7a0DOdlO9K8DBqBtSZs7QRj9z84w0Zk5ia1wSTvfsoj4m/h/UrMTLIJQQoGbRtsZBFKsEl58yidrZW33QaETp+WG8aYAkMnTrY5TUVEb/Z+/eYLMnh1kNMutdMDMdiBZy8TidrNSl++gRhXxpcJNCXhXeq2Kjozcp9AxgiKVxNvhe7F3ObEJP0YOucnplfX6PNV7lf50O9LlJKI25uKet5Vl/WbBqxJ+U4PHzD72KLIPtR+V1Am4dFYOZluO7f9q55qqJzGcp0ytE/l6wmUo1N0Sl4k2YrgAgAbsB/pyrCBD8I8pIKUMMOF8Dnc+YyO0WK65M2likVmTJReEsBpIih/EOufHC382qBRBemifzVc1kp3nnKYxIJDrIxtwA8pXT3LCQRGpoqw/jVW+V1iDdyReF/gieHUeUN/Qplp2P3OsndN7tLJe/+YQqe6p12ybY
 Hgm5KqPj
 Cr1omh0hqHzWmQFtPwoVqY1PBzqNrT2ihriYQmBYzhR2yym6kl94G9Rrr37Ai5jNFaxxVUOqv6V8XQl3+3FV0UTMaDba8dPRY/66XuhYBLqFP6N6uCxf3ZyyvszIi/YK4SmFXL0qE2pTCPWEcJWr/BQLOvichRRqzJPGuoWtAvXfgneJRpO7mCZoL8GUn26IfHNhCqxFTe9vZMx5Njq2kM/gaPXjTkQf2Q83xPdpjNovAZLnW2jTowNKuHfWZiE2QtJc7a8psKUpRrJ/I1HC1H8aI+TWYSrukiSqvGknPcoEXR1gaYS8SFtsi6S+s/CQaCuzwbVUkUjNakjcSM3wwJf92oMPNUV9oY2B8ZSDblcztX6thC7Qphddi+yUjviFgd7AKIW7RkdwvIr5spq/D64NZsOv1DugPEGbTO4vXZVMP5CAEJH8Y5a4Uu56NkUezYuBW5zf6sdU7Ml1lUXAxp+JLZvdwtoR+o7mu/vJmyRlM4QnS63TQdUxeYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Later commits will cause objtool to warn about static calls being used in
.noinstr sections in order to safely defer instruction patching IPIs
targeted at NOHZ_FULL CPUs.

x86_idle is updated in:
o xen_set_default_idle() <- __init xen_arch_setup()
o __init select_idle_routine()

IOW purely init context, and can thus be marked as __ro_after_init.

Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 4c718f8adc592..4f0c1868d43d9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -771,7 +771,7 @@ void __cpuidle default_idle(void)
 EXPORT_SYMBOL(default_idle);
 #endif
 
-DEFINE_STATIC_CALL_NULL(x86_idle, default_idle);
+DEFINE_STATIC_CALL_NULL_RO(x86_idle, default_idle);
 
 static bool x86_idle_set(void)
 {
-- 
2.51.0


