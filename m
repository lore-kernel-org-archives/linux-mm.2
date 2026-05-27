Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15579CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C746B0005; Wed, 27 May 2026 16:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153CC6B0088; Wed, 27 May 2026 16:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A246B008A; Wed, 27 May 2026 16:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E780A6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:20:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FDDC160EAA
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:20:36 +0000 (UTC)
X-FDA: 84814317672.08.5D6FCFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D8FA5100003
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:20:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AmNiH4dZ;
	spf=pass (imf05.hostedemail.com: domain of rostedt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779913235; a=rsa-sha256;
	cv=none;
	b=tSgIMbuCrCnA45INS90y0ECZvq6Qi6ALkcHNZdtzWAoh0gLvMoYLacOy2gGrSq/U/vDfQ9
	fBvMejTFPxcqj5jiKuhLL5QpiRWMJ79vDiW4xXtpINjHw5Y4qbQQpOZuciMvnv18XKLH/t
	f+3V+M8k/mgY4qDPNwqvbb07xqgU1Pk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AmNiH4dZ;
	spf=pass (imf05.hostedemail.com: domain of rostedt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779913235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bG044lG8uwnuKZ6EhriDC30t1Dn2ecruBKaCCD9TMos=;
	b=ZHrC+w2UsQeoKnD+jDbeqUqG97D1R3Ddyvzqs8RY+cx6pufS4W/Pyx8XFrpbvvQpsK5+9U
	e8K9CqCJcpnf5xFPXoXvUesXYcu1gizYVFx2c3veM2gwpfju+UVhFNYANsQlfw1W+pK+U/
	3fgeivxO19LRjzWPHsxtw9ydZXGkmoQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A36E742B6B;
	Wed, 27 May 2026 20:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAF01F000E9;
	Wed, 27 May 2026 20:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779913233;
	bh=bG044lG8uwnuKZ6EhriDC30t1Dn2ecruBKaCCD9TMos=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AmNiH4dZhZHJSUUeDAnN/GFh4yDmQuZ1MK+zn5eA/EhtCTJqYEeoVt7/V3TUASaE0
	 3hj1S9zbGhLpPU3TYLurVIRM2UOehIOC6wT8rIqQDDURlNafIaKmzHDAS6zmqxslf6
	 iG1Iy2XeKIi4OcgkfxX0RAJWP54en3/4PTCKuenCghFUhqplDUrArE9LMeaaE4ghCO
	 jSzCznk1HDhvUeLDbejUw8ZbbCmYKytyhs01CTLBOx/BlmKj2kvftFl2V/eZKTExU3
	 2S4/FZVcmvmYq/Tq797gLhoW5e60tElbM5VDs4SEqU76Yrk2SUmY3Y//kwYMYf5eNm
	 o84bFDtnVpQHw==
Date: Wed, 27 May 2026 16:20:27 -0400
From: Steven Rostedt <rostedt@kernel.org>
To: Jens Remus <jremus@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 x86@kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, Indu Bhagat
 <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Dylan Hatch
 <dylanbhatch@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Kees Cook <kees@kernel.org>,
 Sam James <sam@gentoo.org>, bpf@vger.kernel.org, linux-mm@kvack.org,
 Namhyung Kim <namhyung@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 "Jose E. Marchesi" <jemarch@gnu.org>, Beau Belgrave
 <beaub@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>, "Carlos
 O'Donell" <codonell@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>, "Steven Rostedt
 (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH v16 03/20] unwind_user/sframe: Store .sframe section
 data in per-mm maple tree
Message-ID: <20260527162027.277e744c@fedora>
In-Reply-To: <20260521142546.3908498-4-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
	<20260521142546.3908498-4-jremus@linux.ibm.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D8FA5100003
X-Stat-Signature: fs5t6cipjhk8m5krg8cxqo1t69c37qqy
X-HE-Tag: 1779913234-973449
X-HE-Meta: U2FsdGVkX1/C6SVeaCArBYH7aOdPjpITl0opj6UpEBBYqf37dX8+ngwe8OWYMQCmJ/Vhy9+qZ5V4ozvu2Ur+kj6s9cGZQhFqz8Aub5JVc5Chebk8//PlRDnZImnwLrZavScWpbybKZYWH732JtV9If+K6prki8G9w6f9Sxl+O2gElkQDgZhicULHC1n9Ls19oQSbquwaLIbvDLbakHzIbLQV9X5fvE82PxzmDRz59EZpr8VY+q0vp+f5TCyO46+qsYDEoln8f7GvlV1SkmavRG1Di1vuo88l16/ftHMfmPlNgQbSos88e7kL1/A2RXwnnCDPJO40Dk9WDyEcmzJuHC4WB7RY5OARzR4rnWYgu7rNBqzcTmSW68koE6ahOKl+yMQYCGcZ0kOG3TaAX9TXSrLtigQxGVdEIoZlYx66b4wbN6yyMEx0lyk671UTRcg+X0Sj4/D0i8WiStvHKbCS8EqsZ1pqiTW2PeKzb8lukcweRIx6Z+BV2h4bgnbflRs5VOAuCmxf0lldAeWxUJv/tNU5gdVu5GEvyY3nIhfkKpa/vcTqvU8ldN2MKj+POReV6b0N7yop1E8pUGX9lj7CZTfQqmcTktxtly3HdajKC/lb2aHabBPEMsgVxtQdlaw1bUdaihC/kty64+wo+Z7iKl+i9ZpwBC63IZn0Pqqp+Dr4L5QJPrVkLpkMZE5eOoYkzdBNIp11PXpuUTkpmVge7qngmCWeMtACo5otVjC7j2fCxKR3iKjDhlgvMu3W8uUmQs7QmF2pl9Ei6nZj5vPF2atFbXi+D3c7oJU/AEklyCGwq/LBIw/YWWJOQVTW3ItTpLybDMroQYQSYh6qh8JmLK0tlC2/k98M/BBwOEdv3rjUkcqYm1CyUqKIGZu9Rldgr0A38trU8pbpnr0u8bkkfl2ViUDqdb6qX8gcJvJEfIGx/ZT8Nxa6JGXqExCLYYf6vmS0upm+C+b9XXFeAct
 Pw/m1ugz
 4aE+BJFGF9sBJ0wfaA3aNbxUTnCTFL8dRyiyiNo0VSgY9GHiE+STV0cjayOUCWO2f5g5WFa5/bOOjkQSutc9BgSnwu68z6qA9QlkZLGSn8XqG92/jwzOW58CQzxyyzEWB0fslYW8ejLQ6NYmdPMA8T6v3xSPhTAB1IwPt/VHmIY7oyURYFki0CQ1VHUzM2xjslKpg649yGUgUw59OU0uqBuiRLivAB/w+383wRGyeKZY2OoSvQ/fxtjkLB/aqZ5U1bHvk2+n8euGY/yD6r8LNOLOvhlIvvFm3f1FW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 16:25:29 +0200
Jens Remus <jremus@linux.ibm.com> wrote:

>  int sframe_remove_section(unsigned long sframe_start)
>  {
> -	return -ENOSYS;
> +	struct mm_struct *mm = current->mm;
> +	struct sframe_section *sec;
> +	unsigned long index = 0;
> +	bool found = false;
> +	int ret = 0;
> +
> +	guard(srcu)(&sframe_srcu);
> +
> +	mt_for_each(&mm->sframe_mt, sec, index, ULONG_MAX) {
> +		if (sec->sframe_start == sframe_start) {
> +			found = true;
> +			ret |= __sframe_remove_section(mm, sec);

Because this is all internal data, the __sframe_remove_section() should
never fail. Perhaps we should add a WARN_ON() if it does?

		if (sec->sframe_start == sframe_start) {
			ret |= __sframe_remove_section(mm, sec);
			WARN_ON(!found && ret);
			found = true;

-- Steve



> +		}
> +	}
> +
> +	if (!found || ret)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +

