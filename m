Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BCBFF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEC846B0095; Tue, 31 Mar 2026 06:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D0A6B009D; Tue, 31 Mar 2026 06:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C3C6B00A0; Tue, 31 Mar 2026 06:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 854EF6B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:11:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BFF4BD4CB
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:11:51 +0000 (UTC)
X-FDA: 84605942022.06.F38C22F
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 76ED3100005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:11:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZV77eGoB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951909; a=rsa-sha256;
	cv=none;
	b=ijv0foJzgQjwVtONZCznImBUtK5fqa6mwWp5K/qPJ6sJrZp001RAqW+8wWA2D/4ZeclfKy
	L7p69Yh2HZAC/mQQkkB4hNQlyAN0K1Vra1RpCpVfVFhD4+VAS+A3e0Ne0h03ntWhqQz8EW
	iKOfaYAqZ8odMaj/8T5WFYegYRsjvvw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZV77eGoB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/KT1XoeoGhxQZGd0moPT/YeBL0YVj4iz/EMh/8Na9M=;
	b=pzAJo8wkI5X0+MF0DiIh6R6K8JeMfDoInmmStr1xTm8K8ssKnO6wKWBwzxxa5Hh+K5hcnE
	BeXHi5HDDw2HG3JkstsU14eFIAzWDXZ5y22mI88nxQzub4irO1k/bqLk5tuXJdtEX9Kbbv
	IWeYM+kh8W/0Ukz5+6X9cp/oG9HNOUM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774951907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G/KT1XoeoGhxQZGd0moPT/YeBL0YVj4iz/EMh/8Na9M=;
	b=ZV77eGoBYxkTQ01Z1xvT+NwWiLOnJG01ICF7R8IEluW7BoQaYyfRsHnF4bxuJdehzxdj8i
	m5gLxZ96FaWK0TlLmANrVzEeuUXgeDwIUAYiYJMSXgUyIuQtaXpJnCSPnF9/D0yIb0gnxj
	f7KmNc4JXej6hhm5RiNUBa77Va9m+5E=
From: Usama Arif <usama.arif@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 1/5] tracing/lock: Remove unnecessary linux/sched.h include
Date: Tue, 31 Mar 2026 03:11:32 -0700
Message-ID: <20260331101134.643490-1-usama.arif@linux.dev>
In-Reply-To: <5593ed9718b1a6e4ec51d99772c485734029d4d4.1774536681.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: n15dr8e96su4d7k7adcesh4i8ba3hhgs
X-Rspamd-Queue-Id: 76ED3100005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774951909-859847
X-HE-Meta: U2FsdGVkX186fGglyk7F+rMwq59rwbeMdCv9JqPdGUJTV9yGBcEyhJrJ8h8rdMYwyjnMsjwMRoZ63ypEgaJKTKIHn7PvOlBCVQ8Nmk+9sg/05PwWqO7zzcBVBSzSaDLarPaXtsvFHVsRnb/OhoVa6rQPEjC87XzEozVa5mSb8R5lJCqDlUnn0Ehn4lmXmXJpwhPAcfEfDs7F6emBIyMEnO4/Wt+rJwFwrYv9ro+2obLZJuGzxnfvAbjioYqlctOPquTKV5V3Pg+x3rDKoFPipLRRJQ+PVUXQ5IIo1TGOH+ZdUoJrWVMTMrZoqZPDkE58hoP5Q+yIQiBB9x4vAtYPGb/k6k4fr63/Q0d61T5hADu/i+VH33yiemYYAlgFys1CxI4envroM7Rnmk0I3krlwYFEMEadCwbi8xFyCf/qCQ8OtsaaksT8DVgeySg8vCCgSYuMyRfPQx9/XP17jlUa+eUyYwfdpP6PJoWhADVojh4azAKVi+mstwD7+mtdpTnGuFGuXg5EdDhe1TnbMw/OWELmD/GZkP84X5bSCr2uCwWIXwx2M/fd8dHL+i3jZdejhGdNYq9w6Z3ccTlQronwTtIy2I9LNsQ5zndfCZ/bi1uXFPE58tKMUIJLBtLzStojBVk5FgxYIzUnMXVnTY8Zy3ZUKhRnWb4w+N0cN5u7QAdwFRwo3yiq8Ou9FQJ00JVjvK+9ukN3QFS22I90ygbFEqfby0cUd08ST1SVSmpmF4LApdfcz10wQA3udfM30E6FkZdnXSznuQA6k4/o4vIQ+wfVBkPlChdUVN08bc/crb5bugy/8eVgdPRrwzwUVpU3m05Mf8JfBA36FADCQXQdbiwVerl2Qy39raTbaOCRygNboQ5q9T4pzkWx3glZ5N3n+wG2gowH+sSNAi4bWSKXQzoMBDAm99Sys1imzFfcb3hfo7M+yMgUdOaU7B8T93poYcWR2+U9YH87kmyRFbt
 +BKVuMJD
 K1QWE98i4RdeG7P+ypOtBNLoFjiEEqkHtyoCUkaHNbkTRA+AM+r9CZt4aBT1CxJVc7YqMQyD5o/VmYoNJwOWZRhoRHb3NEWl5qC+7Z/hd2Te7TZBQiPk3FmTsd8pBY8dhJ16yTS9O4Jo1fl+CFpg10BtiGgrJe+5MPZJZv+OTPwh8wE9+2NOv0iD+/cKlzSp04rNILJ0mXuqP0287N5A2yxODqb9ZmLt7jYIbbbw+smXyiqQW4CT9eg8h0BB+Ll0Chh8r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 15:10:00 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> None of the trace events in lock.h reference anything from
> linux/sched.h. Remove the unnecessary include.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
>  include/trace/events/lock.h | 1 -
>  1 file changed, 1 deletion(-)
> 

Acked-by: Usama Arif <usama.arif@linux.dev>

