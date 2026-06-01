Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F316CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33546B0385; Mon,  1 Jun 2026 08:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4156B0387; Mon,  1 Jun 2026 08:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC456B0388; Mon,  1 Jun 2026 08:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 868C56B0385
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:36:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B45D40674
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:36:38 +0000 (UTC)
X-FDA: 84831292476.26.9CEFD8D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id CF46BC0002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:36:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yhr+SfDc;
	spf=pass (imf10.hostedemail.com: domain of juri.lelli@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=juri.lelli@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780317396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89uJQhzYlXTrwrEzk7B7lWaS/o4jYGpdaxvtHqNKqcc=;
	b=2rLAiW5SrDHzd4XjuxoKa7B3OOp+C1fmTSVIVVgjniyeSKYwPpsrnq0c+VRLnzBYg2+EwS
	9p5dvWoSNRRD2+3187UuiXg+GxzhouTVN2Hsquhbvz8S9/pRGFnprsmuyRCm8LC6tsYGgG
	FFxrCIYcRI+V/GxiPT390zLsAAJKCIY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yhr+SfDc;
	spf=pass (imf10.hostedemail.com: domain of juri.lelli@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=juri.lelli@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780317396; a=rsa-sha256;
	cv=none;
	b=3hwknAk5So0l2wcda8SNOinq7dO3ecJ/YtjwzcFHCltTqtQOy0i3V+SXAue/EGr0v9N6df
	Zw69Y+3E+6drvHfgHhBERjAK181Y4AhyoobrDHZ9C46wIjFO7oWp9xnF/jGrFdD0J4ONml
	5hS9hkqY+cfdwVAJPQI0rAkWDzOMJeY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780317395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=89uJQhzYlXTrwrEzk7B7lWaS/o4jYGpdaxvtHqNKqcc=;
	b=Yhr+SfDcsMHGU0faNVAm0r8OOAWImjk6gMgDTTpcJ/DkXTosb69o5M1RHe9G8QooyQN8gZ
	quoviROyHFbvbmVFk2SxPFFXGtX599a/7bvxDNB2ibh705AvkKsZrvkTte4wBGEzo515C8
	HJ4sZyR30ZMV8ehuCJRH8FVZiBTqNRg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-yizTjY02OQiVmT29Y6EnSg-1; Mon, 01 Jun 2026 08:36:33 -0400
X-MC-Unique: yizTjY02OQiVmT29Y6EnSg-1
X-Mimecast-MFC-AGG-ID: yizTjY02OQiVmT29Y6EnSg_1780317393
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45ef66cc579so1286701f8f.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 05:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780317392; x=1780922192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=89uJQhzYlXTrwrEzk7B7lWaS/o4jYGpdaxvtHqNKqcc=;
        b=AopmKJ21rG4T33Ze+lMY++bLVbNyiKyarb2x58zcK2J/45n5NFeRQm1sxhffSXOfxn
         jXYHJprN8Q+cEQzu29wyRSnymgibU5p3CqTdszHVCjgzoQo/mcnntvVf/BWaYkfIbFHD
         KB4cy6/6/kDNwUqcl7RvGjNDI1OeLuGA3pcGusn/KBeJMnk2ukM6dAOPd+O57SkHStQh
         e37Nw9Bcp3CVT91oFKwbNdNXL1CNWdDDgKnPo5hPSppzNPDcZ7Mjqqp6TwJZjFSmTSwL
         WXaIYP29XnN4622yQJaMKA3xFPgAOC2PtRFc/qCxfx3/in5tBdweaoTqO6E3kntotE5l
         FFcA==
X-Forwarded-Encrypted: i=1; AFNElJ+iaa94wPxXztolxZbELuNbXh2ck8zBtIEp9h91/S24+HZ03JOgInPX3+0iMLsbyNNGr2uTT9Quvw==@kvack.org
X-Gm-Message-State: AOJu0YzBSBLur8jy2oPC6lgftMmx6W667/ioPgqwD6mmnG+08oA0KI+X
	Gid29EPwPQhxDXl2BWhOt4jydX6eaoXrvhi5le6IVZNlylwj+zwUFNCMOnBQ1CniTj8GD8J92tr
	c7QYvTqNP75Jp/tLmG6U0yg1mzJTakxAo+yvIVYLzWLHd61hAc4PkjZqkb3cO038=
X-Gm-Gg: Acq92OHGzIvhKRURK1lM3sXLi2ZCfyTtHUVV5+TwTWVE9uSxEK0GGBKKvvIZQ7XdL1f
	XlxmduuZxr94vWq7BpbU6D8h90qF4yoARixEdwRCpQRlAL/5zy6LiLEJloDZx0UOunm9AK8Z7iy
	8YsW7UjEC4ZyQpyNA5+UCXHrMpQOzvnEitKnvuk82reknTllEdmSTXoJpEqcwp05LK6G5B1Fr5F
	STJXF4aUI68g0iFh0wIZVhgAQr8evjDUum78kltIs45XMiQ+AYgWLbEucvbjcZOZg5cNz98Kcnp
	iyMlrW8yK5Fu6M82hEVzi8SBuQE7yzmpGuQxCzvmPuFxvgzCPlqeX1Ax/J8kypxzMcBlavzayLZ
	/Jxmapege+FQBZA7/dzQMlRXnZdAgVCv5JIdf9wINNIkaq1lmHwWGPgIJHctllR4=
X-Received: by 2002:a05:600c:190e:b0:490:a9d6:8f2f with SMTP id 5b1f17b1804b1-490af3ace6cmr16672335e9.4.1780317392562;
        Mon, 01 Jun 2026 05:36:32 -0700 (PDT)
X-Received: by 2002:a05:600c:190e:b0:490:a9d6:8f2f with SMTP id 5b1f17b1804b1-490af3ace6cmr16671665e9.4.1780317392166;
        Mon, 01 Jun 2026 05:36:32 -0700 (PDT)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.44.165])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c1035ebsm114374655e9.5.2026.06.01.05.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 05:36:30 -0700 (PDT)
Date: Mon, 1 Jun 2026 14:36:27 +0200
From: Juri Lelli <juri.lelli@redhat.com>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
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
	Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [PATCH v9 08/10] x86/mm/pti: Introduce a kernel/user CR3
 software signal
Message-ID: <ah18y7mn2fjO9E1n@jlelli-thinkpadt14gen4.remote.csb>
References: <20260505082355.1982003-1-vschneid@redhat.com>
 <20260505082355.1982003-9-vschneid@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260505082355.1982003-9-vschneid@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -ZvtKC-kyZiRWxttOGPs-vpnHu2fL8VjyhA1urjlvLk_1780317393
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CF46BC0002
X-Stat-Signature: y41zxfstc54drsye1uz791jq13tfc74t
X-HE-Tag: 1780317395-734685
X-HE-Meta: U2FsdGVkX1/U5TV/hzE3WQVrPYwZ9AjFWCSyixm1qfc5SBUClaaGZxX+jO/t3zH9K6n6fs4gTlmMRd0ZG0k8RQn4G6dsNNaaPdPdob7nqOrg4uri6vNyZfUYodA/VzeWWvlPcmdT5duRnwKX3xjzlekkhfJnIyYt9WlqIYcaLE5l4GBLU/7uWMVBfZuQfcGW/oAD9P+URuDwe7ARHyDWpHqG5GvZNH0tx5Sql+f9Xs1fYC+Jr0AbkCDfCGu70EM3cWHxnnJHYsU9zh+rTziE2rSFRBw7YoatcAMX1qitc4wv0TGgqYt97ZSDjuQbKIi/hJ4OGSJnp6D7Nz/xhjNwiQpke1x1RhewV0b5lNi95EA1Xvjaoe/FDUQ5o6hgpC9vS0079UM99xNv4HdG2oDWx0IdG9PsYrB8NEexny6Rzb3uxl4Ode/lznFuFnzgLCqVRfZ4Z5Rv80Bbn20GTYhzWUOAV9N4mZ1KhsnZ1r6xYvoVGje28ETIdTb+zNxyZZOZ0LT33w5v6IppZ0On6yZui7Nllz3mmovJSU7FxJfD4+C615rKgmNwR2uO13ZKTM+fdK+LiSCHq3/g1iZyZT8LFV7lDVugkR2CwpUUvtnzoSfyy/8XSBd6JHOn8dBSDxlT+tR0c405WeKxq3XBhv/jbaQig9FwwDlAs12WaJ9Z0U3DJ+IxRLPu+bpV9lYaLcEhc6HXXMr62/7Lmq2V29anAJQLItPjBUpzWfRdzgg+jVw/ejxgQT4SVmVPY7YhMZkjOmY38wkdyDvDorUwlnBfGLr3Kp+AQBr/ljXgdAMrgLByO+Z+ZlyEmTQ/MSe9/MF6pf7Za52CJLCyGMzOsdgixObhQv/Z7E55QqvbuxY3lD0XBc4auOvEFfBfXl1CtXOtmb2sQ5GUvFa6Ygby12rZF6xU4nGCIXj2ADb7sfjGs7TpZN9LwlREfLh0O1M9KwrcFaZfnKLJ7ZG6sC4maKf
 k4dbMx7d
 0SCJ6Hjnt0rBEveZpxmbWkWIsfTztv7Qnu/tArjCK8Cnn/Ph6OTN1db/MB26htxfuI3sqQ8egq2g9XYiyxfURye2uRqoxwLm4zsaRNZqf8/59THwq432Ex8cZURN2dtx4g06akkuI1o9Q0PzkwlkbVePmQAk+46XfQR5nJaVmt32sHQbMLJbk9xY9zzZlSCD0/wuIotHIQl35FR/iuLIwAcy7fQKZE9BExnCyeT0Xkk4Ot6x685sl6VuC1p5uS8shC5ldlYqzd80lsbRogCrvOQONbwXNhavcV0MlcDaXJMt7v3Mo29ukREcSP8v1YqhAd3GnQSnY3hLbNEnCpUHUoiEmBR0Ojm2WZvopSUts35sV9V77eYigKik0sfga+zceWSqg5uyyXsz1GQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello!

On 05/05/26 10:23, Valentin Schneider wrote:
> Later commits will rely on being able to check whether a remote CPU is
> using the kernel or the user CR3.
> 
> This software signal needs to be updated before the actual CR3 write, IOW
> it always immediately precedes it:
> 
>   KERNEL_CR3_LOADED := 1
>   SWITCH_TO_KERNEL_CR3
>   [...]
>   KERNEL_CR3_LOADED := 0
>   SWITCH_TO_USER_CR3
> 
> The variable also gets mapped into the user space visible pages.
> I tried really hard not to do that, and at some point had something mostly
> working with having an alias to it through the cpu_entry_area accessed like
> so before the switch to the kernel CR3:
> 
> 	subq $10, %rsp
> 	sgdt (%rsp)
> 	movq 2(%rsp), \scratch_reg /* GDT address */
> 	addq $10, %rsp
> 
> 	movl $1, CPU_ENTRY_AREA_kernel_cr3(\scratch_reg)
> 
> however this explodes when running 64-bit user code that invokes SYSCALL,
> since the scratch reg is %rsp itself, and I figured this was enough headaches.
> 
> This will only be really useful for NOHZ_FULL CPUs, but it should be
> cheaper to unconditionally update a never-used per-CPU variable living in
> its own cacheline than to check a shared cpumask such as
>   housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)
> at every entry.
> 
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---

Just fyi, I had to do the below to make clang happy with this.

Best,
Juri
---
diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index deb8224b5ee48..07fabf762f700 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -186,7 +186,7 @@ For 32-bit we have the following conventions - kernel is built with
 
 .macro SWITCH_TO_KERNEL_CR3 scratch_reg:req
 	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_PTI
-	NOTE_CR3_SWITCH \scratch_reg $1
+	NOTE_CR3_SWITCH \scratch_reg 1
 	mov	%cr3, \scratch_reg
 	ADJUST_KERNEL_CR3 \scratch_reg
 	mov	\scratch_reg, %cr3
@@ -197,7 +197,7 @@ For 32-bit we have the following conventions - kernel is built with
 	PER_CPU_VAR(cpu_tlbstate + TLB_STATE_user_pcid_flush_mask)
 
 .macro SWITCH_TO_USER_CR3 scratch_reg:req scratch_reg2:req
-	NOTE_CR3_SWITCH \scratch_reg $0
+	NOTE_CR3_SWITCH \scratch_reg 0
 	mov	%cr3, \scratch_reg
 
 	ALTERNATIVE "jmp .Lwrcr3_\@", "", X86_FEATURE_PCID
@@ -245,7 +245,7 @@ For 32-bit we have the following conventions - kernel is built with
 
 .macro SAVE_AND_SWITCH_TO_KERNEL_CR3 scratch_reg:req save_reg:req
 	ALTERNATIVE "jmp .Ldone_\@", "", X86_FEATURE_PTI
-	NOTE_CR3_SWITCH \scratch_reg $1
+	NOTE_CR3_SWITCH \scratch_reg 1
 	movq	%cr3, \scratch_reg
 	movq	\scratch_reg, \save_reg
 	/*
@@ -274,7 +274,7 @@ For 32-bit we have the following conventions - kernel is built with
 	bt	$PTI_USER_PGTABLE_BIT, \save_reg
 	jnc	.Lend_\@
 
-	NOTE_CR3_SWITCH \scratch_reg $0
+	NOTE_CR3_SWITCH \scratch_reg 0
 	ALTERNATIVE "jmp .Lwrcr3_\@", "", X86_FEATURE_PCID
 
 	/*


