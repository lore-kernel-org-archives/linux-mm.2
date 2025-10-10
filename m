Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 525B9CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4B48E0003; Fri, 10 Oct 2025 11:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94068E002C; Fri, 10 Oct 2025 11:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9891A8E0003; Fri, 10 Oct 2025 11:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F0328E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:43:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BDBB160369
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:43:16 +0000 (UTC)
X-FDA: 83982623592.13.96E37AF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9892A20002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:43:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ApcS89A4;
	spf=pass (imf03.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1F5Hxk9Mh6e5UiSiQQtZ6dU5HQkdaz+pE8DP+qaty64=;
	b=nYHx2qfPAmHWjJ+k+etKPQ3fgWD9OFX96tRGQnRlI20rpEXar0QhUVwOLK4OIRzvEj3CDb
	Xwpbowe2M52th0sJQzvA53aE5oCRE5dJIDcGT0k8J+cmynrzWTtbhH+Vb8eYkmNKP+FfmG
	ZrhuavftzahvMyR7TTA4jsd/xEGzCwc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ApcS89A4;
	spf=pass (imf03.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760110994; a=rsa-sha256;
	cv=none;
	b=JGijaSxTAdOcs27GojGDFBy+BQNs7LL9l/IzDi1JlG68l52mMmEZSXETxJVT2euWySgik6
	Hb/0+Khdo/IM2LIYCMtneFtpYV97L5LPs/hmb0MR8I1Qo+OAJdLyo84OA0NiHI5prqXKV5
	EPmeUH0YxIXAAk0CX9r6EH0ohjiUMNo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760110994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1F5Hxk9Mh6e5UiSiQQtZ6dU5HQkdaz+pE8DP+qaty64=;
	b=ApcS89A4OzY8sL1JWCcw1VO+ZmGJBgy7+1/H+wSM0+ZDq8fHKF/iaxvoSsy0nHQClsTwch
	fhuLgIkbbZ1PKqD3krhPPElrlXmRRahG02tD7Z98Y+UJaR7BW3VMI/i/lpXbwClyyaOEob
	/hS9v21krf+1YcKNf72ZMVniFu1USM0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-437-AOZGRuQIPCu19cfaiiylOw-1; Fri,
 10 Oct 2025 11:43:12 -0400
X-MC-Unique: AOZGRuQIPCu19cfaiiylOw-1
X-Mimecast-MFC-AGG-ID: AOZGRuQIPCu19cfaiiylOw_1760110986
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D97D19560AA;
	Fri, 10 Oct 2025 15:43:06 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F4231800576;
	Fri, 10 Oct 2025 15:42:50 +0000 (UTC)
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
Subject: [PATCH v6 09/29] x86/paravirt: Mark pv_steal_clock static call as __ro_after_init
Date: Fri, 10 Oct 2025 17:38:19 +0200
Message-ID: <20251010153839.151763-10-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 9892A20002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kxsndtefd6361w5osz1dmdua1xhepaeb
X-HE-Tag: 1760110994-557989
X-HE-Meta: U2FsdGVkX1/w5nI9JZxfuw3qHilo42NuClwjaipDHz6RPAGfxqtjeAPn74tf+7GVf3of3qUQWMwrLJDGFSYsn1JzSd/ox0zcwZ0rzeqIB/OmHUeabVmS0QrCrgaab5Ovuf1HnyPhjsMcAmQRZ7xdD+Q8y+996gwIcdyQLtN4NvpykRZE4NTrIRltErlXaTM7TDk7mOB8BQDKyIhWV3y6eynGI8RTYA4iEpNXbXQcioMmx/I5zqWFV+IzwM6xln8UroDrLPB/G1QF5M21bq+rYW/19O+GISHM5e+n1wIoek53ELszrrmgPWbSFcVa3sruevfH4lDTJc5Q3p2NwrvH5xFsaPlxwo/45ht7EOPBtLPitktkAHwOI2sI5rmh1GJEwsKYwl2xN6d2oYqTp62z/cmNLLIZACRuDqwsp2Dcnlcyx4cueDWaoWV6QB8QEGhTZ/uE61Uzjnb8Nx5FkPGN9xzytQMAxIdUVL1y2Hw9fNzdHPYdNr6Hl+dIjJpg7gxcAPaI5CY7LAWLjTUtYNLsW4Hvacu4/Yjs0868MIRkK0HA93Wg1N2wrb+dwXaSPsutp1RAXr3teEgZqovFWdoNiQ/KqSJUn3iuOiTFLUIkH9+Pz6THXSzsB5DhbkbKfr0SMwOUM3hh7/3YEoTmf0touKm/yeVh6ILd8n/2oSVzDLBP/YhtcIzPJqTAKd4edSWtje/1TRfVW1cLnxtbM6chD8tL/s5oSqQ65RaJk/ReJYsJpvEMX2MuqICuYJ94ONfv3b8n3rTb68qK408zWL3u/VDs181ckhBAErpCrWFm++Wn16XONPd5guANZbh74pkDsLFXtXjHpHEv0kAo9i/ApdFZJbBGEZyek+CfSkiHlffg7eyA0H2AqlvnTYHnHDi44gTVKnaLYtdbaF9I7kCy+IIOYZyUIcVOzNNZkoSB9lfq9OEtbJWsnmqd/8c73xfgio0AcpGZ+2k6EGP6hoP
 q7C5fZpk
 Zn+MxiDLxbJKgrJ7YONKSQaNY8KWx5NNy2GRz0FBIWcVFFQ2PHeChHRELL3Eb/v66qSQ6VXAgF5IOY7y7IFrhV3u4adbrmEP2b0uCxekvds8W/Ep0XZlR8U9WXR/wT1XphNjGM4PrHdIJ38qJbgRhtmAvrccnZ1ZpRBbLK0Vfu30O8x8uaYdUMPK0SWdijtLYV955Wy64DTErhA4mDnEPzt17XkO/6pIdUQwNCOGt4VDtYSTGLo+SCqiHy68UeXegN/l1PVER35ini4FN82SCebtYJ/RyNSv4njilIWgLT3DNZOGOVgSe/ioQnMpIbLl9qkd0fCF+e1nyzxk0Mk0oo4+ovlBTKJU+QI048XYImeVMLCYfneNZFdMYfLd+sXT2zvkruOo1rdRew1iwnBLowCEUZM2UEr4A13pjkz/ptbjpmb3CxEy68Dn8ApahwFv4XaQL/kle9cplCBMqhGf0FZpSLlF0DVcVzdub
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static call is only ever updated in

  __init pv_time_init()
  __init xen_init_time_common()
  __init vmware_paravirt_ops_setup()
  __init xen_time_setup_guest(

so mark it appropriately as __ro_after_init.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kernel/paravirt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 34b6fa3fcc045..f320a9617b1d6 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -68,7 +68,7 @@ static u64 native_steal_clock(int cpu)
 	return 0;
 }
 
-DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
+DEFINE_STATIC_CALL_RO(pv_steal_clock, native_steal_clock);
 DEFINE_STATIC_CALL_RO(pv_sched_clock, native_sched_clock);
 
 void paravirt_set_sched_clock(u64 (*func)(void))
-- 
2.51.0


