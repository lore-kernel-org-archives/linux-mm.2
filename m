Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5EB4CE7B1B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB9F8E0025; Fri, 14 Nov 2025 10:06:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3538E0002; Fri, 14 Nov 2025 10:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B648E0025; Fri, 14 Nov 2025 10:06:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E486E8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:06:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC169B90A9
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:06:08 +0000 (UTC)
X-FDA: 84109538016.08.F7D41D2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0A6E4A0027
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:06:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fYwuMzKH;
	spf=pass (imf15.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5bTE2UFDn4FhRjqFPlcPPiaXyzSIXCKwLwP8uiIlgI=;
	b=B7BRuWc9QEYOKXs36FNIWdm219qe2YXdZ3geEGB9Scw8zFeLUxDeZfFMRNu0A78Wx/XtoU
	Nb+4MQkW2AFgKGgczXWDrVAZigmX0W034OerZaMqKN/UgMgW8VTLvEunoBz0l0MHOITCMn
	6A0EuP5PtxiN9mTHxcRoHjpaOYM15IM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fYwuMzKH;
	spf=pass (imf15.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132767; a=rsa-sha256;
	cv=none;
	b=dVjmMo0RTcqoKGWslWBcRnf55DfSCMTDLPVYk30fnNluV46vNE9kPiZRgUmyKLprVJLYhH
	WVPKjq8k2aYXP4/8o9odKLJkeGiEfOIG4lSXW/+wfOeG6mVQ0gCduSSdPBXbHnFXArwiX8
	3bGLzaVSFwi0M8dG/s1FrjOj4nzHvlg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s5bTE2UFDn4FhRjqFPlcPPiaXyzSIXCKwLwP8uiIlgI=;
	b=fYwuMzKHHd4zImUk/rx4HLD7cDWUiRbl/Z3yB5bSTixnVczrHO7ABiAMfEdkHGvD8c0mWr
	aWIyNDrqsvtUnplnp0pMUVyCo/5cJjMi1Arc8tPxYJ3N1dTUxy1mZ3soByOsgdotORB5t5
	2S6UfzORs/XFqd5Mg5XQ9xkJZrjG7Vo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-491-wjT2W7RgMiuVd7KDFrJugQ-1; Fri,
 14 Nov 2025 10:06:03 -0500
X-MC-Unique: wjT2W7RgMiuVd7KDFrJugQ-1
X-Mimecast-MFC-AGG-ID: wjT2W7RgMiuVd7KDFrJugQ_1763132758
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 85E3818AB416;
	Fri, 14 Nov 2025 15:05:58 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF79C19560B9;
	Fri, 14 Nov 2025 15:05:44 +0000 (UTC)
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
Subject: [PATCH v7 15/31] sched/clock: Mark sched_clock_running key as __ro_after_init
Date: Fri, 14 Nov 2025 16:01:17 +0100
Message-ID: <20251114150133.1056710-16-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 0A6E4A0027
X-Stat-Signature: 184gr4ccg9c4n37rz8pcfuyw1sue6dbu
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763132766-11033
X-HE-Meta: U2FsdGVkX1+o2CdFk76TIcE/wXC4Dte4q4LTWAgsOepbh4qnAiLA5Fl6UkHYUshpbCeQVXUAQ5Nv+zpZpW0yfwzeyS8XsC7q5ykoxCmoHvx3f2uV6kYcGLvqWeHed4eLpd1nAmoruTLL/r3uusd2yDZaLAQqhW+FRRODjcAbn6xtH8jdgadUBPZalmGQ93kXHxkgOBEN3geSPNoOtS0uOEkwIWXK0EP3dRaQOcDbUi083cN3MOKJkirMmCsyXPjr3K8g0p8r8cnNyjVyy3kJAdkXhhTSX6XQDWgpVl0OEfRdYELqJ/5vlHXAb7x/dKol95Gi5OFgGTkNGs4Dz8blj2bYSMerQVWM65d5BslQmFu66EACnnsIP3YXEF/f/kTEU7fyawnglvennZgblvGZStjSHuoK4usvEgCixBYu4lz9uoUaoj81cO8l+EW5rZQY6LNOiMzLepXQcI4mD9FgZvcR9+ZrKtwSOyRAL+YLx08wtXRxVAhNS2/omPaAYJ5cDbp8rfJWmAhHRUdeS0hmoHb4zWgBcSZcrNeHXoz7+KmlC3/8xWGTr1ZV1GQ3rEvWj7+Y5n7O3sx8v4RPGpYuyWkHTb4VYkfBW3wbfFT07FbHUiEdCgzq/2w/Zonm9jKnnnRxyUeOvef6woLflEH3Ak7M7vB+B0ddT+4W3tese3/xXghwwpBTrZUksZDop6/hhruxlXryrYFNmBs9HM22R/cbd/JXYPZXpVr2ZBbTvpbQf1eoJs3f4tFIRYamixzCJVA0PhOLXPPby20q5zEH03C05VS/CaathPfPWgQBcgHXzFoEL+pSyYOWYw6Uz6zWrCIgfHQJacZGn6GwnP1Qs0Aoy7xLuFflY9ejx3CpUtasZ/CwAj/2PphU2jkV0+91KC9rySt737xENGGmF2gjv5qaSIrQ1hkUINnURPTqVFSqeW4aml2PojRUa6wWuRsVoTA19dVfhAvZljsMirN
 2g0WjjbT
 JG7nCZyf6Rh46Pjhf40WyB9tCFCK6URElTUH6fSCHa25jk99X/rYBFYZzz0qSMptN7KCgbZob9+SxhiHcNDW+pZbHYcxl+3l4WTs/2k1nRoHEl1rlLhlWAQc504C32zdbNlf0OfLQS50uA77eCa+rdnEPWFDORiQOOTz1FTBcd7n2YgBCv0dr6NSwoxpubLZDBFqCOuGjQNAQCMWiN+EJSmlSg7ejlr1vZ99QzsSgeasu6mm9G15FGAiY7f+MHccXru6vlDK2m4jCthx1fJWa7t/COCrvnGM1EXr1qQubuLEDcLTzsvQ9Gpatue0/exN7ZzgpwWJSENVEcERgImUjnfSJvhowH05s17T3EvBLEDEca4TcYX5pjl3gH/27HyYy1XgkGLoadOdq3SCYYlX8c+LjWXpCQqh+xkrHiGCmvPvhyNdesEgVpV1l6+A96CM6yR8tvFWWlf2FBs015KKl8JQc/8Zb9vZdecZU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sched_clock_running is only ever enabled in the __init functions
sched_clock_init() and sched_clock_init_late(), and is never disabled. Mark
it __ro_after_init.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 kernel/sched/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index f5e6dd6a6b3af..c1a028e99d2cd 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -69,7 +69,7 @@ notrace unsigned long long __weak sched_clock(void)
 }
 EXPORT_SYMBOL_GPL(sched_clock);
 
-static DEFINE_STATIC_KEY_FALSE(sched_clock_running);
+static DEFINE_STATIC_KEY_FALSE_RO(sched_clock_running);
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 /*
-- 
2.51.0


