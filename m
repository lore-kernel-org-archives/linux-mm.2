Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D01F46436
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 09:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E646B0170; Mon, 16 Mar 2026 05:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55CA6B0172; Mon, 16 Mar 2026 05:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61706B0173; Mon, 16 Mar 2026 05:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93A706B0170
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:39:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 343CA1A014C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:39:13 +0000 (UTC)
X-FDA: 84551427786.03.6A6CE6A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66305C0011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:39:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="RGW/SC4M";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=QGIR75ZP;
	spf=pass (imf10.hostedemail.com: domain of john.ogness@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=john.ogness@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773653951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yXXr7UYzVmKZqbUDqTRxeSr99PDOjbUs7jkHvsTHQc=;
	b=29tr0LzPxYlpA+1XFsY0JS6Fht1UOYrjvGyCajC94U1B5UM5MT4fe5P0JOdfwabwpu3mcl
	82OVLOL65MKDcHI59iQ73pk1YInaItqsOGr+f8EcOXu5YE0Yl2EjRurscsL9tDHUvBfikm
	XL19iM0qirlsOnRYQ9zyIZBQOoUckLg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="RGW/SC4M";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=QGIR75ZP;
	spf=pass (imf10.hostedemail.com: domain of john.ogness@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=john.ogness@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773653951; a=rsa-sha256;
	cv=none;
	b=P5Ad8TodY+DKN0BOengV+pitnmzk6o13aZx+qLJg9W9ANLwgtEpv8InzMhm1Jyj1zHS/yl
	G9nKTNXdTu9ekA7m/NnIf+As4apUwQSZpz4du3+zRBGZLs/u1V1LpRZa0DUErvYUkSc0CW
	ElMg0R3Cyr2DySXop8Jd+7HDmvgcqnI=
From: John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1773653948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9yXXr7UYzVmKZqbUDqTRxeSr99PDOjbUs7jkHvsTHQc=;
	b=RGW/SC4MMA/M4YgLuQp6J+nCgqUPKuzJkjfow4kMcP+Ja54NkGd+Iqxcg0INU5BTQJaqbd
	zWuxfRRBwiYqp1zn+ygW2r9mucciJZQfAESPJPEVNCw0VFTSF2q5jqNKXze15EE/2LUqgs
	7tBkXd3YwUwloSiTyIIjO2b3BZA4XAkvszc02Wytj120zLFKlqdZ3lc4ozLwb0uXovN+hS
	zpPZPoCg+QW3Ip+nzLaHWLmdk+psjF1q/GdABgeoje1reSUDEUlS94ig22Rd/SWyObLkBQ
	UVGOB0uvxkkbuO6RBzCm7k94ZLRQqqdVogqowh+uurx+9xqS/e59L4ZyOvGVDg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1773653948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9yXXr7UYzVmKZqbUDqTRxeSr99PDOjbUs7jkHvsTHQc=;
	b=QGIR75ZP1H0QscPuRjVvpUiSFT4GWZluKBzuY8RFXIJ9I/8MYYYcOktCRI31IQE1Zl+P0h
	QgSBF55PD4+EkVCw==
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Eugen Hristev
 <eugen.hristev@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Dennis Zhou
 <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, Thomas
 Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker
 <frederic@kernel.org>, Ingo Molnar <mingo@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
 <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, Brendan
 Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi
 Yan <ziy@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
 <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Petr Mladek
 <pmladek@suse.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, Bjorn
 Andersson <andersson@kernel.org>, Mathieu Poirier
 <mathieu.poirier@linaro.org>, Konrad Dybcio <konradybcio@kernel.org>,
 Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
 linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 20/25] printk: Register information into meminspect
In-Reply-To: <20260311-minidump-v2-v2-20-f91cedc6f99e@oss.qualcomm.com>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <20260311-minidump-v2-v2-20-f91cedc6f99e@oss.qualcomm.com>
Date: Mon, 16 Mar 2026 10:45:06 +0106
Message-ID: <87pl54f70l.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: hyudcukxppsx3u9txszu1hxyoctys7cj
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 66305C0011
X-HE-Tag: 1773653951-653861
X-HE-Meta: U2FsdGVkX1/nd98ocv4Ceh9HtF87YJvWg0SseNTwZ4QMmRCB6pRy8oLIwxdKc9ObzHzS9Eoygb0O3br/YzC+5eI3fGa8XvSR0n1qUnYZk5DN/l26pn/axp2fQPkkalNeUghwUwrFLZA6r4a5qo/bjpaAk5XKAMjNbRo9WKhN20n9STu5jIGNU7bMqH1iQo/+NPYEhrXqcJI0ITkUIxWzXh++Milyf2QywXXwNaQxC0IHwfHuWR/8vX2J5J4zsYRSZaoXzeqLd4bmt9EfdSWrws8+kx0yc0s+laQrn0jtcQyuWgtQzuAJIl5kHZf4f5FBl0OIcctMn1e/W878jrbZiVm6YTj3jvlqkdxHqbqWptYBRH13M+vR3QGAKEZzG3h3Im0LLwxcIX1rZDw4PVGDG1duxl/t1pU/0UoEossqpFLK94oeqUeHDG03OSJG178+PXZVFrHUajhIjvqsfQSBb/Yi1BUzzSB/fovpLpmOWgVoFEWyAIL7zWXCo8YmPM3WTBIjVo4CQMWjQUb1c1qBQNZp0u1X6mqirRGVew742LwY/4V9+0uoRxotvPsYZXLSVal9DZHwRxD5PpPLYVoaHy2UVpxcKEXNTaTRpNPWeEPAK8rO3EhcgLfsymWnkb0U7YHTIlCBdWpUjXhJW6TIzcfX5eqzFjkfRbBYcZdB7OJ3g/w7bD1o3JTugqohuL3R4PSh2+YVVKOnK/g0C0vopDDe4yF9WxeXpSmHLRmkxrQ8xbJW6M5FU/GuV7aSyqlQVp5lqpNN7uhP4Cb+okPxyc0kPEjrGELIZRi9fpFZWPiRymEey2wE9YfN+yHzqB7R51xCe8hHsbUnT1OxqNFhw/fqcVgL3IyFU3cgyTkDtXx0WdqVIInXWmdhwX/Cr65QkobyCJfEHQTfGVI+2AqH3AxFSxszgKZFyAguV6xeilEqHzI6ygDlpQEJHJ2QqC191yhtE2PiSZeQb9jbNq/
 0S+9hrjm
 g2Ngb04Y6Bvy6DF6jsdMSak3ylHbJs9JrqOfPpLjHfLqL6z2CgI/cEFERtHl8bQrl7XCUZmXM6Bp7zJ/K7NmWkJh98LYr76QBI7Ukqockm9GNlDwoBD8jfmSGXr7he0AQ+6IPZCKT+cbrU11Oq+rtUkzM3z3V8ELtUowXJxIjNlluMjGrMimRyzAXCITVAsHBC8rBk8SGFWYhPdxTXLGCcX/cqv1OyYeFOuUPLteieCHoXj/B1pW8cKZX/vQdbmj8ERNLRtW3nMWnjtHByHtEqCtRX+0HZNkWD3964tzR2yZ7+NXwK/LGT0JmtXheDJGnQUI8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-11, Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> wrote:
> Annotate vital static, dynamic information into meminspect for debugging
>
> Static:
>  - prb_descs
>  - prb_infos
>  - prb
>  - prb_data
>  - printk_rb_static
>  - printk_rb_dynamic

FYI: vmcore also exports the symbol "clear_seq". It is not required if
you are interested in reading _everything_ in the buffer. But it may be
interesting if you want to mirror vmcore tool features.

> Dynamic:
>  - new_descs
>  - new_infos
>  - new_log_buf
>
> meminspect uses a different API to annotate variables for inspection,
> and information about these variables is stored in the inspection table.
>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

Reviewed-by: John Ogness <john.ogness@linutronix.de>

