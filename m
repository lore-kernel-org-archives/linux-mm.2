Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8962FCCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E67348E002D; Fri, 10 Oct 2025 11:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E185B8E002C; Fri, 10 Oct 2025 11:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06D18E002D; Fri, 10 Oct 2025 11:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B98DD8E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:43:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4BED6119C1F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:43:35 +0000 (UTC)
X-FDA: 83982624390.03.7CAC69A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 772861C0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:43:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D0xrhaxI;
	spf=pass (imf20.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMfkEjR7bo9/GPZWUZrcsZpIJiAh+KjKI2oJCMzgHeQ=;
	b=DOVnKkEsUn40g5F7LvgNxAUmsGgL4oGCwQ+lxQbsBruvLQGiXlEnRIAKTEZV7Ttz//qXFk
	t/9yf5VQYAP3EWJInSr2lkKiZhDoWTjAy5QdN0hkkh6RL5XBtiVcRUuKzTchyM6fi9MmFX
	b0f32bXKqJPkPq3OhqxbVJ//Wmy6DFE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D0xrhaxI;
	spf=pass (imf20.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111013; a=rsa-sha256;
	cv=none;
	b=jb0ZBK42a8tHPvCjpyXEy0ow98hdf6+WETaRuwJWIIGCCNFCrwu39IOK29HqN9MrpxTLNQ
	ETJwbngis50zFOVFcpyKF0B9VfGcKtRi+J14EgOEWydheIUCmrUNA+yNZ5FuQQaz+lAaLT
	K7KmmDMmTLJQ3O0b/DzDF1ZWUdVGw/w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IMfkEjR7bo9/GPZWUZrcsZpIJiAh+KjKI2oJCMzgHeQ=;
	b=D0xrhaxIS+I7MWflA2uYwqAsNM734DmHzznzPjKlAoGC1n5ICuucNr7tyyzZsnUkLCYtK/
	C3wJYTx+uleHYAZ81Y8YuWv77rGXtJvwEqn9OgEDpg4KglNIQZIN1dVCp0Gd/EaeSeVCcs
	BsSatlP3YghCfAaRnMe9uwjitkodPlg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-152-vxoZ-j2iObiDj7gk3pSmjA-1; Fri,
 10 Oct 2025 11:43:29 -0400
X-MC-Unique: vxoZ-j2iObiDj7gk3pSmjA-1
X-Mimecast-MFC-AGG-ID: vxoZ-j2iObiDj7gk3pSmjA_1760111002
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C62319560AF;
	Fri, 10 Oct 2025 15:43:22 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB64E1800578;
	Fri, 10 Oct 2025 15:43:06 +0000 (UTC)
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
Cc: Andrew Jones <ajones@ventanamicro.com>,
	Thomas Gleixner <tglx@linutronix.de>,
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
Subject: [PATCH v6 10/29] riscv/paravirt: Mark pv_steal_clock static call as __ro_after_init
Date: Fri, 10 Oct 2025 17:38:20 +0200
Message-ID: <20251010153839.151763-11-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 772861C0002
X-Stat-Signature: 64oikndbz7d4o5o9ngwbyba33dw38pcf
X-Rspam-User: 
X-HE-Tag: 1760111013-996588
X-HE-Meta: U2FsdGVkX1/kV7gQYeURdYDzPOKRcV3rp2GGniJ16J1gFVwz8A2Vlk7cLUyp90HJs7cM1qJOmUV08v0S0kDOME0QYXE97a2JRa0KzqdpuWV7b5k6zhyGyewAEglIQ6wzcuwaO2uX9irIjyabc2f4CHlTxGzkrEv3AVTHUcs6gjttxfRU98ZJuqJlK7dn+T7TYGCtVj2vY3yO4hQuZAvzX5Zw78rdl0z611Q5TLd/Ju/vON0PkcH+Tzu+HMvEVfaEpvWXfpOqjBQ5gcYQyIRnieN7ZtLEO5bnkix8Cg3aSMzJnbXAZhDdffs8syU63+37cspwhbkBPUZv560YqEmOo0eyRmK5MLvIpkL9EYxWvm2ZKH4WJV/pOrFu2FW4iRpjA29CyxNJpWlG1V24aQ+RpB/evy7m7+isB4sIfqyJb2ZiJSj17la7OCiwB8gNalbeBNOJCUrdobWAtmHpjMp0WxYO1g4AO8tprw1gUz7BYhUA2et6Tg98ZVKZcNxeDKzku8uJ5Wp7sgFOZ6FtIj47dslq+Jjj9XLeqt3klj6MIn6tXSKjbDzrzvDpwLLsHYplfXgti06MqNkhsbbF58mvFMe0AsSONzObmOctGfwFf4DLFL8yoYJJenHuK6vEa3CMTzJDPbrJsvclT3tQ3SKIqMC0rCl+Vxbp11tQll/HHkwpY9exiTNvvmFOnCmg6g02xSxj5nawmEuHKymcZSwECRkHFlu69Y33jO3hYlt6yZ/QypBEdBjJX2XntlYSY/efbFzfZdAjpH94FMNkQWojUr29aKgkNIKdSnk71ZNFrnN04rDkW8MMRf/m/j7HB37FoczoyX5VTx29A8YRnyOvMwNtPuEf8sePRfvhp8Lj0oReo7uHXhH14cosqUtUJ6wrjlCt6rUZUD3ID62jjkJqujj2gFgxbiMXzLhylY/QJQ72NwmGJ31qg5+gpNk5CUKapJ53yyYxscJxMmJ0GeY
 zou7V8qG
 AWxfHG+XaCuY2z/O44r43KNHYAWDj7C75q4MAa4Hcvm74saYlwzHKpgTKgf4Jt5sFVoU9DzsF0gQsdsTUBV+/u7opbdFem63lK97aDAUdu3f8RvzRxw0Sm+zkx22CTgUU7xoq4Oj5NCTfamdZ0pl0Imov+zwCm9OiohUc48F622eNOQTa828DQiage1gK9YzJ5BqSWw5HBh9jI9yWFhIeuoikUrH9kYGUBwK/tctbJLUPgIuWXScEYXOeNVeW2GMAFhybNrl71yekiR4ZNb4M2BR0AjEPvrtznwMZTVJfcgQ4iEIgwHl+4oYcD1/nnir51+w91W/hfHPtyAwYZKu+wEGmfPSPpp+ESPjbiTOopVT3eTecWTt0nwGy5G52mgx/Rz9M7O/zkoUVeuoSnrSbu3paYdkTh0dxViWrzhAF4x3GzoJ0tm4kSa3IaAe1Wqnx4EKZsLKMBCMYxLqDdZpVEBOtNBlFp+Y8zNvwpAngV4MSTLYP2jA4lgNs5W4nvr3fsRXW5lxoutuY5m1NZ0mQcYk7rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static call is only ever updated in:

  __init pv_time_init()
  __init xen_time_setup_guest()

so mark it appropriately as __ro_after_init.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kernel/paravirt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/paravirt.c b/arch/riscv/kernel/paravirt.c
index fa6b0339a65de..dfe8808016fd8 100644
--- a/arch/riscv/kernel/paravirt.c
+++ b/arch/riscv/kernel/paravirt.c
@@ -30,7 +30,7 @@ static u64 native_steal_clock(int cpu)
 	return 0;
 }
 
-DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
+DEFINE_STATIC_CALL_RO(pv_steal_clock, native_steal_clock);
 
 static bool steal_acc = true;
 static int __init parse_no_stealacc(char *arg)
-- 
2.51.0


