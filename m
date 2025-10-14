Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 285AFCCD183
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 00:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863828E00B6; Mon, 13 Oct 2025 20:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC848E0024; Mon, 13 Oct 2025 20:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB2B8E00B6; Mon, 13 Oct 2025 20:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3AB8E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:02:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01234C0344
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:02:52 +0000 (UTC)
X-FDA: 83994769026.26.0295BEA
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6C8E4C0010
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:02:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="nrJQ/CjA";
	spf=pass (imf22.hostedemail.com: domain of 3KpPtaAYKCFUF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3KpPtaAYKCFUF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760400171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbMLU0DBTTE4ZUI3tpJtNUcx/FkgYHD5aLH5yKQ0ecU=;
	b=1ZJWWDoPMslIAkXbQaMyM8Egtflp/Kxz79WDVL0jtOcQ28qKQrfvSS5WRUh0EfE+9qDgWI
	3Xifti/RHQYpL5uA1aemxfawMMN+O9JuUuT5+NAcGuwosd6aFgh8kT6Nmv4XnDhliugXL5
	2kUnuxcvYp8si08/EGwwPk3FLf0ZF74=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="nrJQ/CjA";
	spf=pass (imf22.hostedemail.com: domain of 3KpPtaAYKCFUF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3KpPtaAYKCFUF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760400171; a=rsa-sha256;
	cv=none;
	b=5vl4IkAmBQmRiRohdKYFUZs31P5n7/hNlG7Vo8vixFwzo+R8/zm4BUYdjTQdaGFcMAcxXP
	HRYmBO856i22JkvtP7Wuvn+zpbmraG2LUdeWyBUgvP+HvvrYaw57tpx91jJX0zDwqL5fLF
	mdiaIYMOhlJ+cwD8SiL+Rq8CDj5T/qg=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339b704e2e3so9975875a91.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760400170; x=1761004970; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gbMLU0DBTTE4ZUI3tpJtNUcx/FkgYHD5aLH5yKQ0ecU=;
        b=nrJQ/CjAxXPUU45QVWu3iM8xWHH2eSbCZqakoikjC0yoBcjztiwoEQxiGvjdRHGXKp
         w38fQ0HJFhM+2jqZxjbvtB2Vf1GrNe9k0JM1wahW56OKbjWy8M3VmvKLL/RmzH3adAFV
         9V9NeMibjM23c+8zzrXnRdmMbrbI9n3e2svpZq2v9MWMwUTpR82oA779hDMw+sXxk1Q6
         Z8MVu4R0WaHPePTixwu6XuiHHUHXu9sAk4JHz+KHSP+QsPNU553EkDfYzRZqHgjyaJGb
         UbCX3nz2qiLyOgFj6bmP0qZbULOmXH4EPwJJ/IPbIBT2y8XdkU70fFZ6e7pTcZibmXHM
         H1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760400170; x=1761004970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gbMLU0DBTTE4ZUI3tpJtNUcx/FkgYHD5aLH5yKQ0ecU=;
        b=OK5AKsdlpVBMmxrcW0qW6gips+KhNZ3DjtGfhZK9dX0Hgt5oBJXrPyj517tTc9VmkY
         kskpX6XOsNO6BM92kfxNUdy9+HsNLTF/xbJ32UsJv4Hk35sdmK4Z4y/2yBDfJZfnLmID
         aWLsavglhT6zw5L5ubww4Y9FX/qcw8+32i8pwFtvfejWJYKKhoEpITlx9DcxbGFWJzkm
         66Q2cSqaVSJCbSwDIlKDIdVf2eOHtBTve78+A8nBxr9CquUrE7ny1UtBCJXhkbfA/nNr
         YizlqEY88xk1JuNSkUVx4sx+oj4hIYVJReyfLZ9I8296KgMjVypLf0B//ZbNCD51Oyhl
         7Jvw==
X-Forwarded-Encrypted: i=1; AJvYcCXrh57iumV2/Z6xV+CsMTTkokWTvV2JdSR1flyHx6l3KmQgn+6lBO4Hlx0NvTHYwT42AMQszVrPug==@kvack.org
X-Gm-Message-State: AOJu0Yw0c1KlEmgBmhrTGazaXElLrNn6J+FoIUiPlKwcf+Ed1dfqQ6Qs
	Ww4wIn1GdzmYxtRP3L/MtqAqkkxDgBFSXihRP/+p6bLcJNl4rOnQlFgl69aA1UHmiajrQSJkSwe
	jSVngBQ==
X-Google-Smtp-Source: AGHT+IFj7XEk3dTkPnLos5082VprjEOkbmDHEla6HA+8/jfX0ozELV9F0rEtoGCDSVNCkEzGlN6/hN7WXyk=
X-Received: from pjzm8.prod.google.com ([2002:a17:90b:688:b0:33b:51fe:1a75])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c89:b0:321:9366:5865
 with SMTP id 98e67ed59e1d1-33b513b4afemr31472790a91.33.1760400170137; Mon, 13
 Oct 2025 17:02:50 -0700 (PDT)
Date: Mon, 13 Oct 2025 17:02:48 -0700
In-Reply-To: <20251010153839.151763-17-vschneid@redhat.com>
Mime-Version: 1.0
References: <20251010153839.151763-1-vschneid@redhat.com> <20251010153839.151763-17-vschneid@redhat.com>
Message-ID: <aO2TKOY5JV9OoRUg@google.com>
Subject: Re: [PATCH v6 16/29] KVM: VMX: Mark __kvm_is_using_evmcs static key
 as __ro_after_init
From: Sean Christopherson <seanjc@google.com>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org, 
	x86@kernel.org, linux-arm-kernel@lists.infradead.org, 
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org, 
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Frederic Weisbecker <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Jason Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, 
	Yair Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 6C8E4C0010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5eoqm9saj4keeafayen8o19cjckwh6iu
X-HE-Tag: 1760400171-410628
X-HE-Meta: U2FsdGVkX18AyHIAi/63sJaDKj3Yvvt4ELiiZu6wn2clFYs+kw2t+fSdDJ4dqHv9YAeKRAL6JuVwpobm4Uj5WT1y5hPxm8Ty+ZlwO6EO2fUfNZwfJhJMotoPZgss2poPm/7G+SNF6Ei4qIkmFWFPUzpSc5HOQuRdCZXRSVW5goMJ6hDPfL9J1Gi7ExRFG8sZ3ykOTU+ZjyOpUqYu1luqRnnIzAxVrqi8uqzP5qqezSEJi/ASgzMsc3firBlpJEsADVJOCCGXUd+QIjEKi5F9ZtG6mCQ23mQy3ZLMCWTtXem7s+EftQPJ5QMxr0syt4lLgShLPxRLejAYEsUxpUuxj5ZzWUx51lrfXVAEz+5g0AcGAxwAHv0lMP9N2NKBuTZGJBBOTTfQ+bMWkkfK/A913sZqxCalLbHvQNXn9T4iIX1aSwXi88/JyNcqGzRoaX9vfIGpHoYAKPAtvPS+NvXkSzw560KBKYHJN48U96epHxmLKsc958gYtBvcrB/rMudXxQDSPXPGR3CMwrKdmba8We92LWTQ/2m79kSsDrTBO/QGZ//K3b6xapGQlSlEtanlh+x21hO00sfQ6VcsrL6wZ7SBay9H+ge9DOmHM/BpLicMXummuWtMecENaq2JQ2KY2uVkymuAiieTI0WD4WrJrnIdBsPhJIEQQc70n1vfAqRExyq8nG6H5M/iNts5fPL7dnPcwyYdT0aOkONSum6tLakQYpLwNrBYQ6MiNRvsMzr2+DOJwhAhTxAHvpfC8vG4hXkb3HTWYJC5IPxhxqQs4bhR9RZG3Piqb3Brx5qaT+lsaufT2HhtVmJPkoUjK/4hpHuj5lcyHCSrUCWcSQhJ3bsTQPQlXVMozmax9EK+Jbut6iwK0nnfCbNfFm8xJSCJxtoCWnZkmy/D29xsL+VTKexkcJxYa1Jf6px2vS7C2kWOEV4ayZA5yWFqBDdvUZqpVaYA/t6EfwMvYTpjBdR
 ZA9HLq7x
 Baw7DTbVnxLgAI2Ku9q5d+mGO2LpRQ9k1dNeO6NIV8RXEvAtR5vnzSXVUYpahxag1B9nn/Kq0XbFJVA6ACmN1s+BVGfD9x9exoZaMXVKn9zJ97HaDSfZ15wPjX3SNlCRgZwZ5VXPIQxUkosr887LOXSW4a9j18dgkcfRZWn2P8IhHpsAF5rcKXGd8LrdRM31T07f9+wOfE7aDyjFARfI0qGLA68o/gf7X22b2QkIVW4jg9UJMw0PWQCV4X14RZGBT9+YGmot1UR6DhtWnCdpg50FwwZR6CfTSVgRXb6KB5F6v7oINhNkGlJq8ktB81S88/TbKYKIG/ikQgy/XQaQSEespUmmfucuzK+xmunCPmIlJI7LCtdG+raapzKQMKWLuXCyGbry88p8Fm4arlxWcRT6j9L5LnlP78m4z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025, Valentin Schneider wrote:
> The static key is only ever enabled in
> 
>   __init hv_init_evmcs()
> 
> so mark it appropriately as __ro_after_init.
> 
> Reported-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

Holler if you want me to grab this for 6.19.  I assume the plan is to try and
take the whole series through tip?

