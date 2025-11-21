Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C6ACFC295
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 17:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FAC6B008C; Fri, 21 Nov 2025 12:37:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7EA6B0093; Fri, 21 Nov 2025 12:37:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28976B0095; Fri, 21 Nov 2025 12:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E27DF6B008C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:37:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89FA51300A1
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:37:21 +0000 (UTC)
X-FDA: 84135320682.26.73852EB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id DC2CA40017
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:37:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HLyGab2g;
	spf=pass (imf04.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763746639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3OE0zpMaGFe7FLO1SjE8KbYNBSyHZmUa+LcldBnwuQ=;
	b=ruH+o9oTWB4R9RcB8UfA9Y2Alr/5K8HJ8PYKVEbusTvQSk7eFYsYeiDenu1iCe27hmymTa
	kU/88MBSPeaP6j5MvxaEDyhi/hOvIqkturX1smKO/LCKNwaZddR///BXUsstmiT/5kPTu0
	+/l5gauXuUFAuw/LWqLb3kPDMUX419I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HLyGab2g;
	spf=pass (imf04.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763746639; a=rsa-sha256;
	cv=none;
	b=uTtlpz5+r8prl0iSXpQo/tz5s/SXkNUTscCrOw0uoEwe1JllsctUDOiIy3KGwimP9NkYg4
	poSawWkchFosMwGPL6je8PmN+su1FWene9ucnPTJdnK0o9wWojk0SYK+1hZJf3Hl42fn1d
	QKXvEYchSbzo1xVb55w+PvNQhOm5tTQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763746637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V3OE0zpMaGFe7FLO1SjE8KbYNBSyHZmUa+LcldBnwuQ=;
	b=HLyGab2gL8y2QKkizA/AljoznHmN75jEWMrWhCPWYV136R0boKIzdyjJoPMCydKrzxz7ND
	CermfLPBAoqEbP2yR1BuEqEtBB/fxSlKGblSUXUmdPMN/43PHZHXjlO7HVyBQDRNQ5K1ev
	pEU0sk2Lkjw7BavCgB3h2gZ/nkpSiiY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-xcydoKdWOhawG3kY_StUFg-1; Fri, 21 Nov 2025 12:37:13 -0500
X-MC-Unique: xcydoKdWOhawG3kY_StUFg-1
X-Mimecast-MFC-AGG-ID: xcydoKdWOhawG3kY_StUFg_1763746632
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-429c5c8ae3bso1940054f8f.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:37:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763746632; x=1764351432;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V3OE0zpMaGFe7FLO1SjE8KbYNBSyHZmUa+LcldBnwuQ=;
        b=akFICloSAMbKlKcJd6mf14CIN3yspO2n1ssnPWqgIBwrfw0rl7jEIS70I/7of5Ovy8
         qB8NXMRO7qvzMlh2idrgEvIIq8UORbOW4Ry4k2DBka2OR4WnYY33dOpeTwvVcCrDl+5E
         JQsVEbfa6ZpXvdS2tVNDqV5BGZLJcfjpnuabLudbQXdGWfggIJfHtTMQSrg+FFuktNNH
         W//kSaFG9F7183Kt6mVavwtYXY9QPM8o9+gO1EDdAeCr7bmWNXV4TnkPuYSNwAOovl6i
         aUX5AexUaWjCER79S0+0RDZkt7ACCw37JEJGQ8lMq26DaZ7VaQl7Sz56LzUe17Dpw1BR
         1Opg==
X-Forwarded-Encrypted: i=1; AJvYcCWV5K9yzbGE8GdFJdhJCL6a451Gez/3uQucEqu/SMKHedSAUn8ApTF3UdqSbZ9llh4b9kJNgzKFug==@kvack.org
X-Gm-Message-State: AOJu0YyAZfLaNMOOGycNz7pu8ZpZa7Aiwutw52jPA079Iw6fh6MCPl5i
	ULHcS593yqN559dbXzHZBAEpsxzU6CKERc95VJwE6Bksf2w9O5SF7MMGagDSZLLHwrQYA0vlwAS
	xW7+6GgF/X2bj3vbKHb+3He7UvPCKQiAL6nvzqVQueS0TxYPx6oO9
X-Gm-Gg: ASbGnct7+H5MPct5ffPHg+3hnd4OYR0Ehroz/WoqRFunHP6c3TtokK2VYDRCjbG0GqV
	8nZdIvj1TkwDC/GMLOzkyhW81BYWhMKEAjryc82EmLTuWpu8kJhP+WBpaRdB/o/Q87rLsnbCsnO
	dC9TeYALNr/v1g4sbCbZJhuXTcuOxBOtAu/uyjZiRR/o2dsSuXQiOjckuklkFdDfEfBzxtSOzcR
	jHbaKzQWHMREzshDCtlyrtDjnmRvOmDLLXLsEp3I9QFSFxAxIcge4Mcx+irdjdXFZmBafgZfYdN
	NJdSN2iwVgW+vKx9cqHuc9SqgXXwRLCb4qdLjSn21nZ019TY743g7sN1+CYeW6pzeD5D/XwDNeq
	N9Rezc9Mo91lH/vmm+Fs9rRvzmZa0VvatiiZdyULMCOdOqHGenkrs74jVXfdPucHqCy4Rj3Y=
X-Received: by 2002:a05:6000:2282:b0:42b:3ab7:b8b9 with SMTP id ffacd0b85a97d-42cc1cbd0dcmr3334302f8f.20.1763746632029;
        Fri, 21 Nov 2025 09:37:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwrptJrvQrMlATO+zOU3GD53XUKYoEIwVBRtwZMVM9uxcxDwDk+rU+CpbkpyNs1Ksl4qe7Bg==
X-Received: by 2002:a05:6000:2282:b0:42b:3ab7:b8b9 with SMTP id ffacd0b85a97d-42cc1cbd0dcmr3334227f8f.20.1763746631366;
        Fri, 21 Nov 2025 09:37:11 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cc231dc6esm4094867f8f.7.2025.11.21.09.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 09:37:10 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rcu@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker
 <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, Jason
 Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard
 Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 "David S. Miller" <davem@davemloft.net>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Han Shen <shenhan@google.com>, Rik van Riel
 <riel@surriel.com>, Jann Horn <jannh@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [RFC PATCH v7 30/31] x86/mm, mm/vmalloc: Defer kernel TLB flush
 IPIs under CONFIG_COALESCE_TLBI=y
In-Reply-To: <bad9eaaa-561a-498a-90d1-fe3a3ab8ba37@intel.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
 <20251114151428.1064524-10-vschneid@redhat.com>
 <bad9eaaa-561a-498a-90d1-fe3a3ab8ba37@intel.com>
Date: Fri, 21 Nov 2025 18:37:09 +0100
Message-ID: <xhsmh5xb3thh6.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LOY9KTpbaPu4r3FPYKXQDXFfb40k9n8GGaIUONWTIEw_1763746632
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC2CA40017
X-Stat-Signature: suro17o9nbjtut58oom5pdn6tiazt4qy
X-Rspam-User: 
X-HE-Tag: 1763746637-412215
X-HE-Meta: U2FsdGVkX1/RblAcHAYdC1VERlWK3wnS4ob7O5HXflbPzU/Xp+gE09G9vcnSJcrRsJ3h9pWjsUVVw6HmBk4UslfY22ndDFHh1WZDnLLHgnQegKrio+g88ONeSInQaiyKNhD0yheyhc2gYvXv09eu59i2tHcNgUsgheA4R8iwI/qOh2fL9DWnpGUUUGumARjd5nzvO1WJ8VE3JgLgNKA3xdpZ/uLagtjqTC2NQYl9NCzsxlpI2V1x0e7tahjMRoIhHS1CnNMVK3popaX54BVtRIc1gEeEyVCW9b1HUTc85hJlrDvbGZRiukbnSz7C2IbLNRtmMKHkc2zSGV5qngXSy+5KszBN8n0etzwuS3lu/QM4V9rO6NkcMs0A3EPtiLnxFYcPC67vTHo4f2AgZqGJTGcLd86GrsSaqevgoWuMyNaxDp9IqeHnL7Sj6LATEHf6QMNHJE8mmvmEd2lBJbSJXV3/tpV0+hPm5pJJdF50lUZyQEvBNUw065rYX3gr1UV0JHxYd6Ql4sSbzepETIK9LgC/+YM2bqVLCF85H4bo3lRrACQegK3zFQkj9dwJpvL2VvAAQqPmBf+pIU2KkjlSMPjYLJYaKSqD17V5nqEiRwj9+LDOYJvKzSu6kJNbtOkqq4pEYj8cc8fn7Si66STNcNUyKtQiecPA72o01Lqr4p0niIlmVaJryYuOKv0VlXy2Ll82St01Ptt+gVSaqm3ForpLKRSySgvW3RXB8E8eVXCZlY7xEh9DCkkx+bk71hE2uESITSSSLLiZjgxHivMMoAES1/xSB3znKahzG0FNicbq2IysaNKdE7scKjkU6CQHr9hxxY2EN3lrzXHG/5X0w3TpUPytQXqvw3DCoELy84zWhJDWnM1Mq1v43RegmiQsvbjpZlxTIxNpwcHbg6zSqtePIODmu10CPBzUvvR5rUoOnwij7wR/TmtSC6fy6ZevKGGmsqTRAiv7e9fna/q
 9W3cFMgI
 wwyIVaUyU/kv3RBYjO1DPaGcCXH/LkwmJSRXnaHnlcH+5A0EFdChfnI1ClUzyk1iXwQzeO/8Go5YlQ0sHgoeE5qQpLHoflBRIVaV9i8l/Eoe63OAUf6QK+bYy47oKQDQWfM6kyv77qfxTyFcpCjKI47Bck+f+YNZ0x9RusyIlxlWGJU6RQu066TSj5Me4sgew2SAHsQhndxiTjvljU9hv6SbhPrJsouRnro4FPswXV9thv/kfppsxUfGaY7Xt076KUX7HATU9PtIsI7vGhv0MAVAymwnA4pQYckZPMd0QggH8TISd/a0dYavbTM6jLcyBar+cEQ11zhkGPB3ZnFQvcOTypx1jGmnctKXn6LGbpLjARtccws370e7NFhN/rU0rYnMGRMVvXosFvcE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/11/25 10:31, Dave Hansen wrote:
> On 11/14/25 07:14, Valentin Schneider wrote:
>> +static bool flush_tlb_kernel_cond(int cpu, void *info)
>> +{
>> +	return housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE) ||
>> +	       per_cpu(kernel_cr3_loaded, cpu);
>> +}
>
> Is it OK that 'kernel_cr3_loaded' can be be stale? Since it's not part
> of the instruction that actually sets CR3, there's a window between when
> 'kernel_cr3_loaded' is set (or cleared) and CR3 is actually written.
>
> Is that OK?
>
> It seems like it could lead to both unnecessary IPIs being sent and for
> IPIs to be missed.
>

So the pattern is

  SWITCH_TO_KERNEL_CR3
  FLUSH
  KERNEL_CR3_LOADED := 1

  KERNEL_CR3_LOADED := 0
  SWITCH_TO_USER_CR3


The 0 -> 1 transition has a window between the unconditional flush and the
write to 1 where a remote flush IPI may be omitted. Given that the write is
immediately following the unconditional flush, that would really be just
two flushes racing with each other, but I could punt the kernel_cr3_loaded
write above the unconditional flush.

The 1 -> 0 transition is less problematic, worst case a remote flush races
with the CPU returning to userspace and it'll get interrupted back to
kernelspace.


